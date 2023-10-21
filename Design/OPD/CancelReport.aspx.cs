using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_OPD_CancelReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            BindCenter();
        }
        
    }

    public void BindCenter()
    {
       // string str = "SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY centre ";
        string str="";
        if (UserInfo.Centre == 1)
        {
            str = "SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY centre ";
        }
        else{
           str =  string.Format("SELECT DISTINCT cm.`CentreID`,cm.`Centre` FROM centre_master cm INNER JOIN f_login l ON l.`CentreID`=cm.`CentreID` WHERE l.`EmployeeID`='{0}' ORDER BY centre" ,UserInfo.ID);
        }
        DataTable dt = StockReports.GetDataTable(str);
        chlCentres.DataSource = dt;
        chlCentres.DataTextField = "Centre";
        chlCentres.DataValueField = "CentreID";
        chlCentres.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres == string.Empty)
        {
            lblMsg.Text = "Please select the Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();

        //sb.Append(" SELECT DATE_FORMAT(lt.date,'%d-%b-%Y') CancelDate,DATE_FORMAT(lt.date,'%d-%b-%Y')RecDate,    ");
        //sb.Append(" IFNULL(em.Name,'System') CancelBy,em2.Name GenerateBy,lt.CancelReason, ");
        //sb.Append(" lt.LedgerTransactionNo,lt.GrossAmount,lt.DiscountOnTotal,lt.NetAmount, ");
        //sb.Append(" IF(IsCredit=0,'Non-Credit','Credit')PayMode,lt.Adjustment PayAmt, ");
        //sb.Append(" CONCAT(pm.Title,' ',pm.PName)Patient,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age, ");
        //sb.Append(" dm.Name ReferBy, GROUP_CONCAT(ItemName)ItemName,cm.Centre,lt.TypeOfTnx FROM   ");
        //sb.Append(" (SELECT LedgerTransactionNo,Patient_id,Doctor_id,GrossAmount,Centreid,DiscountOnTotal,NetAmount,Adjustment,CancelDate,DATE,Creator_UserID,CancelReason,IsCredit,TypeOfTnx,Cancel_UserID FROM  ");
        //sb.Append(" f_ledgertransaction WHERE IsCancel=1  AND  ");
        //sb.Append(" date(IFNULL(CancelDate,date))>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND date(IFNULL(CancelDate,date))<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        //sb.Append(" AND CentreID in (" + Centres + " )) lt ");
        //sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo ");
        //sb.Append(" LEFT JOIN employee_master em ON em.Employee_ID = lt.Cancel_UserID ");
        //sb.Append(" INNER JOIN employee_master em2 ON em2.Employee_ID = lt.Creator_UserID ");
        //sb.Append(" ");
        //sb.Append(" INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id ");
        //sb.Append(" INNER JOIN doctor_referal dm ON dm.Doctor_id=lt.Doctor_id ");
        //sb.Append(" INNER JOIN centre_master cm ON cm.Centreid=lt.Centreid");
        //sb.Append(" group by lt.LedgerTransactionNo ");
        //sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE_FORMAT(IFNULL(r.CancelDate,r.CreatedDate),'%d-%b-%Y') CancelDate,DATE_FORMAT(r.CreatedDate,'%d-%b-%Y')RecDate,  ");
        sb.Append(" IFNULL(em.Name,'System') CancelBy,em2.Name GenerateBy,r.CancelReason, ");
        sb.Append("  r.LedgerTransactionNo,0 GrossAmount,0 DiscountOnTotal,0 NetAmount,  ");
        sb.Append(" 'Settlement' PayMode,r.Amount PayAmt, ");
        sb.Append(" CONCAT(pm.Title,' ',pm.PName)Patient,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age, ");
        sb.Append(" '' ReferBy, '' ItemName,cm.Centre,'Settlement' TypeOfTnx FROM   ");
        sb.Append(" f_receipt r  ");
        sb.Append(" INNER JOIN employee_master em2 ON em2.Employee_ID = r.CreatedByID ");
        sb.Append(" LEFT JOIN employee_master em ON em.Employee_ID = r.Cancel_UserID  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_id=r.Patient_id  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.Centreid=r.Centreid  ");
        sb.Append(" WHERE  ");
        sb.Append("  date(IFNULL(r.CancelDate,r.CreatedDate))>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" AND date(IFNULL(r.CancelDate,r.CreatedDate))<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'  ");
        sb.Append(" AND r.IsCancel=1  ");
        sb.Append(" AND r.CentreID in (" + Centres + ") ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = AllLoad_Data.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"C:\CancelReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "CancelReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "No Records Found..";


    }
}