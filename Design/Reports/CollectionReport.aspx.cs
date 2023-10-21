using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

[System.Runtime.InteropServices.GuidAttribute("01FDD488-3DEB-42D1-92D5-C9340E37FDE5")]
public partial class Design_Reports_CollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            bindCentreMaster();
            BindUser();
            bindpanel();


        }
        if (Session["RoleId"].ToString() == "1")
        {
            trReportFormat.Visible = true;
        }
        else
        {
            trReportFormat.Visible = false;
        }

    }
    private void bindCentreMaster()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin();
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "CentreID";
            chlCentres.DataBind();
        }
    }
    private void bindpanel()
    {
        chpanel.DataSource = StockReports.GetDataTable("select company_name,panel_id from f_panel_master where isActive=1 order by company_name");
        chpanel.DataValueField = "panel_id";
        chpanel.DataTextField = "company_name";
        chpanel.DataBind();
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtFromTime.Text = "00:00:00";
        txtToTime.Text = "23:59:59";
    }
    private void BindUser()
    {
        string strCentres = string.Empty;
        foreach (ListItem li in chlCentres.Items)
        {
            if (strCentres != string.Empty)
                strCentres += ",'" + li.Value + "'";
            else
                strCentres = "'" + li.Value + "'";
        }
        DataTable dt = new DataTable();
        string str = "Select em.Name As Name,em.Employee_ID from employee_master em inner join f_login flg on flg.EmployeeID = em.Employee_ID where em.IsActive=1 and flg.Active=1 and flg.CentreID in(" + strCentres.Trim() + ") ";

        if (Session["RoleId"].ToString() == "9" || Session["RoleId"].ToString() == "214")
        {
            str += " and em.Employee_ID='" + Session["ID"].ToString() + "' ";
        }

        str += " group by em.Employee_ID ";
        str += "order by em.Name ";

        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            cblUser.DataSource = dt;
            cblUser.DataTextField = "Name";
            cblUser.DataValueField = "Employee_ID";
            cblUser.DataBind();
        }

        if (Session["RoleId"].ToString() == "9" || Session["RoleId"].ToString() == "214")
        {
            foreach (ListItem li in cblUser.Items)
            {
                li.Selected = true;
            }
        }
    }
    protected void rbtReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtReportType.SelectedValue == "12")
        {
            panel.Visible = true;
        }
        else
        {
            panel.Visible = false;
        }
    }
    protected void challpanel_CheckedChanged(object sender, EventArgs e)
    {
        if (challpanel.Checked)
        {
            foreach (ListItem li in chpanel.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            foreach (ListItem li in chpanel.Items)
            {
                li.Selected = false;
            }
        }
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        LoginRestrict LR = new LoginRestrict();
        if (!LR.LoginDateRestrict(Util.GetString(Session["RoleID"]), Util.GetDateTime(ucFromDate.Text), Util.GetString(Session["ID"])))
        {
            lblMsg.Text = LoginRestrict.LoginDateRestrictMSG();
            return;
        }

        string startDate = string.Empty, toDate = string.Empty, user;

        if (ucFromDate.Text != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " " + txtFromTime.Text.Trim();
            else
                startDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");

        if (ucToDate.Text != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + " " + txtToTime.Text.Trim();
            else
                toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");

        user = GetSelection(cblUser);

        GetCollectionData(startDate, toDate, user);
    }
    private void GetCollectionData(string fromDate, string toDate, string userID)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        DataTable dt1 = new DataTable();
        DataTable dtBackDateSettleMent = new DataTable();
        DataTable dtBookingSummary = new DataTable();

        if (rbtReportType.SelectedValue == "0")
        {
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT rec.CreatedByID Receiver,em.`Name` as EmployeeName, Rec.`PaymentMode` PaymentMode, ");
            sb1.Append(" SUM(`Amount`)`Amount` ");
            sb1.Append(" FROM f_receipt Rec  ");
            sb1.Append(" INNER JOIN employee_master em ON rec.CreatedByID=em.Employee_ID ");
            sb1.Append(" WHERE rec.`CreatedDate` >='" + fromDate + "' AND rec.`CreatedDate` <= '" + toDate + "' AND rec.`IsCancel`=0 ");
            if (userID != string.Empty)
                sb1.Append(" AND rec.`CreatedByID` IN (" + userID + ") ");

            sb1.Append(" AND rec.`CentreID` IN (" + Centres + ") ");
            sb1.Append(" GROUP BY rec.CreatedByID, rec.`PaymentModeID` ");
            sb1.Append(" ORDER BY em.`Name`,rec.`PaymentModeID` ");



            dt = StockReports.GetDataTable(sb1.ToString());
        }
        else if (rbtReportType.SelectedValue == "1")
        {
            //summary query
            StringBuilder sb2 = new StringBuilder();
            sb2.Append(" SELECT rec.CreatedByID Receiver,em.Name As EmployeeName, Rec.`PaymentMode` PaymentMode, ");
            sb2.Append(" SUM(`Amount`)`Amount` FROM f_receipt Rec  ");
            sb2.Append(" INNER JOIN employee_master em ON rec.CreatedByID=em.Employee_ID ");
            sb2.Append(" WHERE rec.`IsCancel`=0");
            if (userID != string.Empty)
                sb2.Append(" AND rec.`CreatedByID` IN (" + userID + ") ");

            sb2.Append(" AND rec.`CreatedDate` >='" + fromDate + "' AND rec.`CreatedDate` <= '" + toDate + "' ");
            sb2.Append(" AND rec.`CentreID` IN (" + Centres + ") ");
            sb2.Append(" GROUP BY rec.CreatedByID, Rec.`PaymentModeID` ");
            sb2.Append(" ORDER BY em.`Name`,Rec.`PaymentModeID` ");

            dt1 = StockReports.GetDataTable(sb2.ToString());

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  IF(DATE(rec.`CreatedDate`)>DATE(lt.Date),1,0) IsBackDateSettlement, DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y %H:%i')DATE,DATE_FORMAT(lt.Date,'%d-%m-%Y %H:%i')BillDate,lt.LedgerTransactionNo,em.`Employee_ID`,em.Name As EmployeeName,  ");
            sb.Append(" '' PaymentType, rec.`ReceiptNo`, lt.`LedgerTransactionNo` ");
            sb.Append(" ,CONCAT(Rec.`PaymentMode`,' ',Rec.`Amount`) Payment, ");
            sb.Append(" CONCAT(pm.`Title`,' ',pm.`PName`)PatientName, CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),IF(agedays<>0,CONCAT(' ',agedays,' D'),'')) Age,pm.`Gender`, ");
            sb.Append(" lt.Patient_ID,Rec.`Amount`,Rec.`PaymentMode`,Rec.`PaymentModeID` FROM f_receipt Rec  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionID=rec.LedgerTransactionID ");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`Patient_ID`=lt.`Patient_ID` ");
            sb.Append(" INNER JOIN employee_master em ON rec.CreatedByID=em.Employee_ID ");
            sb.Append(" WHERE rec.`IsCancel`=0 ");
            if (userID != string.Empty)
                sb.Append(" AND rec.`CreatedByID` IN (" + userID + ") ");

            sb.Append(" AND rec.`CentreID` IN (" + Centres + ") ");
            sb.Append(" AND rec.`CreatedDate` >='" + fromDate + "' AND rec.`CreatedDate` <= '" + toDate + "' ");

            sb.Append("   ");
            dt = StockReports.GetDataTable(sb.ToString());



            sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(rec.`CreatedDate`,'%d-%m-%Y')DATE,DATE_FORMAT(lt.Date,'%d-%m-%Y')BillDate,lt.LedgerTransactionNo, ");
            sb.Append(" SUM(Rec.`Amount`) Amount,Rec.`PaymentMode`,Rec.`PaymentModeID` FROM f_receipt Rec  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNo=rec.LedgerTransactionNo ");
            sb.Append(" WHERE rec.`IsCancel`=0 AND date(lt.Date) < Date(rec.`CreatedDate`) ");
            if (userID != string.Empty)
                sb.Append(" AND rec.`CreatedByID` IN (" + userID + ") ");
            sb.Append(" AND rec.`CentreID` IN (" + Centres + ") ");
            sb.Append(" AND rec.`CreatedDate` >='" + fromDate + "' AND rec.`CreatedDate` <= '" + toDate + "' ");
            sb.Append(" GROUP BY Rec.`PaymentMode`,DATE(rec.`CreatedDate`), DATE(lt.Date)  ");
            dtBackDateSettleMent = StockReports.GetDataTable(sb.ToString());

            sb = new StringBuilder();
            sb.Append(" SELECT  em.`Name`,COUNT(1) TotalBooking, SUM(`GrossAmount`)`GrossAmount`,SUM(`DiscountOnTotal`)`DiscountOnTotal`,SUM(`NetAmount`)`NetAmount` ");
            sb.Append(" FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=lt.`CreatedByID`  ");
            sb.Append(" WHERE lt.`Date` >='" + fromDate + "' AND lt.`Date` <='" + toDate + "'   ");
            sb.Append("  ");
            sb.Append(" AND lt.`CentreID` IN (" + Centres + ") ");
            if (userID != string.Empty)
                sb.Append(" AND em.`Employee_ID` IN (" + userID + ") ");
            sb.Append(" GROUP BY em.`Employee_ID` ");
            sb.Append(" ORDER BY em.`Name` ");

            dtBookingSummary = StockReports.GetDataTable(sb.ToString());

        }
        else if (rbtReportType.SelectedValue == "2")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT lt.`Panel_ID`,lt.`PanelName` AS ClientName, Rec.`PaymentMode` PaymentMode,  ");
            sb.Append(" SUM(`Amount`)`Amount` FROM f_receipt Rec   ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=Rec.`LedgerTransactionID` ");
            sb.Append(" WHERE rec.`IsCancel`=0 ");
            if (userID != string.Empty)
                sb.Append(" AND rec.`CreatedByID` IN (" + userID + ")  ");
            sb.Append(" AND rec.`CreatedDate` >='" + fromDate + "'  ");
            sb.Append(" AND rec.`CreatedDate` <= '" + toDate + "'  ");
            sb.Append(" AND rec.`CentreID` IN (" + Centres + ")  ");
            sb.Append(" GROUP BY lt.`Panel_ID`, Rec.`PaymentModeID` ");
            sb.Append(" ORDER BY lt.`PanelName`,Rec.`PaymentModeID` ");
            dt = StockReports.GetDataTable(sb.ToString());

        }
        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            if (rbtReportType.SelectedValue == "0")
            {

                // ds.WriteXml(@"E:\\CollectionReportSummary.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReportSummary";
            }
            else if (rbtReportType.SelectedValue == "1")
            {
                dt1.TableName = "collectionSummary";
                dtBackDateSettleMent.TableName = "BackDateSettlement";
                ds.Tables.Add(dt1.Copy());
                ds.Tables.Add(dtBackDateSettleMent.Copy());

                // Added by Salek Kumar 2018-09-21
                dtBookingSummary.TableName = "BookingSummary";
                ds.Tables.Add(dtBookingSummary.Copy());

                ds.WriteXmlSchema(@"E:\\CollectionReport_PatientWise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "CollectionReport_PatientWise";

            }
            else if (rbtReportType.SelectedValue == "2")
            {
                dt.TableName = "ClientWiseSummary";
                ds.Tables.Add(dt.Copy());
                //ds.WriteXmlSchema(@"H:\\ClientWiseSummary.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "ClientWiseSummary";
            }
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            if (Session["RoleID"].ToString() == "1")
            {
                if (rdoReportFormat.SelectedValue == "1")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                }
                else if (rdoReportFormat.SelectedValue == "2")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/CommonCrystalReportViewerExcel.aspx');", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }

        }
        else
            lblMsg.Text = "No Record Found";
    }

    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
    protected void btnexcel_Click(object sender, EventArgs e)
    {

    }
}
