using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.IO;

public partial class Design_OPD_PanelWiseBussinessReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            lstpanellist.DataSource = StockReports.GetDataTable("SELECT fpm.Company_Name,fpm.Panel_ID FROM f_panel_master fpm  INNER JOIN  centre_panel cp ON cp.panelid = fpm.panel_id  WHERE (cp.centreid IN ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`='" + UserInfo.Centre + "'  ) OR cp.centreid='" + UserInfo.Centre + "') and fpm.IsActive=1  GROUP BY fpm.panel_id ORDER BY Company_Name;");
            lstpanellist.DataTextField = "Company_Name";
            lstpanellist.DataValueField = "Panel_ID";
            lstpanellist.DataBind();

            lstCentreList.DataSource = StockReports.GetDataTable("SELECT DISTINCT cm.CentreID,CONCAT(cm.Centre,' [',cm.CentreID,'] ') AS Centre FROM centre_master cm WHERE  cm.isActive=1  ORDER BY cm.Centre"); ;
            lstCentreList.DataTextField = "Centre";
            lstCentreList.DataValueField = "CentreID";
            lstCentreList.DataBind();

            lstpaneltype.DataSource = StockReports.GetDataTable(" SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE Active=1 ");
            lstpaneltype.DataTextField = "PanelGroup";
            lstpaneltype.DataValueField = "PanelGroupID";
            lstpaneltype.DataBind();
            lstpaneltype.Items.Insert(0, new ListItem("Select", "0"));
            string str = " Select Name,FeildboyID from feildboy_master where IsActive=1 order by Name";
            lstfeildboy.DataSource = StockReports.GetDataTable(str);
            lstfeildboy.DataTextField = "Name";
            lstfeildboy.DataValueField = "FeildboyID";
            lstfeildboy.DataBind();

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        validation objval = new validation();
        bool validdate = objval.datevalidation(Util.GetDateTime(txtFromDate.Text));
        if (validdate == false)
        {
            lblMsg.Text = "You are not authorize to view report from this date";
            return;
        }
        string str = getSearchQuery();
        if (str == "")
            return;
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {

            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = UserInfo.LoginName;
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
            dt.Columns.Add(dc);

            if (rbtnReportType.SelectedItem.Text != "MonthWise")
            {
                dc = new DataColumn();
                dc.ColumnName = "Centre";
                string value = "";
                foreach (ListItem item in lstCentreList.Items)
                {
                    if (item.Selected == true)
                    {
                        value = value + "'" + item.Text + "',";
                    }
                }
                value = value.TrimEnd(',');
                dc.DefaultValue = value;
                dt.Columns.Add(dc);
            }
            else
            {

            }

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            if (rbtnReportType.SelectedItem.Value == "0")
            {

                Session["ds"] = ds;
                Session["ReportName"] = "PanelwiseBusinessRepor_Summary";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }
            else if (rbtnReportType.SelectedItem.Value == "1")
            {
                // ds.WriteXmlSchema(@"C:\PanelwiseBusinessReportCITY.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "PanelwiseBusinessReportCITY";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }
            /**Region Item Wise Business Reports***/
            else if (rbtnReportType.SelectedItem.Value == "2")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "PanelBusinessForLIS_Detail";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/CommonCrystalreport.aspx');", true);
            }
            /**Region Item Wise Business Reports***/

            else if (rbtnReportType.SelectedItem.Text == "MonthWise")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "PanelBusinessForLIS_Summary";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }

            else
            {

                Session["ds"] = ds;
                Session["ReportName"] = "PanelwiseBusinessReportUserWise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }

        }
        else
            lblMsg.Text = "No Records Found..";



    }
    public string getSearchQuery()
    {
        string PanelList = "";
        string CentreList = "";
        string PanelTypeList = "";
        string FeildBoyList = "";
        foreach (ListItem item in lstpanellist.Items)
        {
            if (item.Selected == true)
            {
                PanelList = PanelList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstCentreList.Items)
        {
            if (item.Selected == true)
            {
                CentreList = CentreList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstpaneltype.Items)
        {
            if (item.Selected == true)
            {
                PanelTypeList = PanelTypeList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstfeildboy.Items)
        {
            if (item.Selected == true)
            {
                FeildBoyList = FeildBoyList + "'" + item.Value + "',";
            }
        }
        PanelList = PanelList.TrimEnd(',');
        CentreList = CentreList.TrimEnd(',');
        PanelTypeList = PanelTypeList.TrimEnd(',');
        FeildBoyList = FeildBoyList.TrimEnd(',');
        if (PanelList == "")
        {
            lblMsg.Text = "Please Select Panel ";
            return "";

        }
        if (CentreList == "")
        {
            lblMsg.Text = "Please Select Centre ";
            return "";

        }

        StringBuilder sb = new StringBuilder();

        if (rbtnReportType.SelectedItem.Value == "0")
        {

            sb.Append("   SELECT pnl.Company_Name PanelName, ROUND(SUM(lt.GrossAmount),2)GrossAmount,ROUND(SUM(lt.DiscountOnTotal),2) DiscountAmount,ROUND(SUM(lt.NetAmount),2)NetAmount,  ");
            sb.Append("   ROUND(SUM(lt.Adjustment),2) ReceivedAmt, ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,COUNT(lt.`LedgerTransactionNo` )cnt  ");
            sb.Append("   FROM f_ledgertransaction lt        ");
            sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID    ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID     ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
          //  if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
              //  sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
           // }

            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }

            sb.Append("   GROUP BY pnl.Panel_ID    ");
            sb.Append("   ORDER BY pnl.Company_Name    ");
  if (Util.GetString(HttpContext.Current.Session["ID"]) == "EMP001")
            {
               //System.IO.File.WriteAllText("C:\\PanelSumm.txt", sb.ToString());
            }
        }
        else if (rbtnReportType.SelectedItem.Value == "1")
        {
            //PDFBILAL
            sb.Append("   SELECT dr.Name Doctor, pnl.Company_Name PanelName, DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,lt.LedgerTransactionNo LabNo,lt.BillNo,pmh.CardNo,concat(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'-',LEFT(pm.Gender,1))Age, ");
            sb.Append("   GROUP_CONCAT(ltd.ItemName)ItemName,lt.GrossAmount,lt.DiscountOnTotal DiscountAmount,lt.NetAmount, lt.IsCancel,  IF(lt.IsDocUploaded,'Yes','')DocumentUploaded, lt.RemarksAccount, lt.DocUploadedBy, lt.DocUploadedTime, lt.RemarksAccountBy, lt.RemarksAccountTime, lt.DocUploadedByID, lt.RemarksAccountByID, ");
            sb.Append("   lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt ");

            sb.Append("   FROM f_ledgertransaction lt   ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append("   INNER JOIN f_itemmaster itm ON itm.ItemID=ltd.ItemID  ");

            sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID  ");
            sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=pmh.Patient_ID  ");
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID   ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ") ");
            }
            // if (UserInfo.Panel_Id != "" && PanelList == "")
           // {
             //   sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
           // }
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("   INNER JOIN doctor_referal dr ON dr.Doctor_ID=pmh.referedby  ");
            sb.Append("   GROUP BY lt.LedgerTransactionNo  ");
            sb.Append("   ORDER BY Company_Name,lt.date,lt.LedgerTransactionNo  ");
			 if (Util.GetString(HttpContext.Current.Session["ID"]) == "EMP001")
            {
               // System.IO.File.WriteAllText("C:\\PanelDettol.txt", sb.ToString());
            }

        }

        /**For ItemWise Panel Reports**/
        else if (rbtnReportType.SelectedItem.Value == "2")
        {
            sb.Append("     select date_format(lt.Date,'%d-%b-%Y')Date,lt.LedgerTransactionNo,pm.PName,concat(pm.Age,'-',left(pm.Gender,1))Age, ");
            sb.Append("     ltd.ItemID,ltd.ItemName,(ltd.Rate*ltd.Quantity)GrossAmountItem,((ltd.Rate*ltd.Quantity)-ltd.Amount ) DisAmtItem, ");
            sb.Append("     IFNULL(r.Rate,0) CashRateItem, ");
            sb.Append("     ltd.Amount AmountItem, ");
            sb.Append("     ((lt.AmtCash*ltd.Amount)/lt.NetAmount) AmtCashItem, ");
            sb.Append("     ((lt.AmtCheque*ltd.Amount)/lt.NetAmount) AmtChequeItem, ");
            sb.Append("     ((lt.AmtCreditCard*ltd.Amount)/lt.NetAmount) AmtCreditCardItem,  ");
            sb.Append("     ((lt.AmtCredit*ltd.Amount)/lt.NetAmount) AmtCreditItem, ");
            sb.Append("     (((lt.NetAmount-lt.AmtCash-lt.AmtCheque-lt.AmtCreditCard-lt.AmtCredit)*ltd.Amount)/lt.NetAmount)PendingAmtItem, ");
            sb.Append("     lt.AmtCash, ");
            sb.Append("     lt.AmtCheque, ");
            sb.Append("     lt.AmtCreditCard, ");
            sb.Append("     lt.AmtCredit, ");
            sb.Append("     lt.NetAmount, ");
            sb.Append("     lt.DiscountOnTotal, ");
            sb.Append("     lt.GrossAmount, ");
            sb.Append("     lt.Adjustment, ");
            sb.Append("     pli.BarcodeNo, ");
            sb.Append("     '' AgaLedgerTransactionNo,lt.TypeOfTnx,em.Name,em.Employee_ID,pnl.Company_Name,pnl.Panel_id ");
            sb.Append("     ,dr.Name Doctor,dr.Doctor_ID, ");
            sb.Append("     pnl.payment_mode TnxType, ");
            sb.Append("     SUBSTRING(Company_Name,1,POSITION(' ' IN Company_Name)-1)PanelCode, ");
            sb.Append("     SUBSTRING(Company_Name FROM POSITION(' ' IN Company_Name)+1)PanelName, ");
            sb.Append("     itm.TestCode , lt.IsCancel, lt.CancelReason,pnl.MarketingPerson,  ");
            sb.Append("   '0' MarketingPersonWise  ");


            sb.Append("     from f_ledgertransaction lt  ");
            sb.Append("     inner join Patient_labInvestigation_Opd pli on lt.LedgerTransactionNo = pli.LedgerTransactionNo  ");
            sb.Append("     inner join f_ledgertnxdetail ltd on lt.LedgerTransactionNo = ltd.LedgerTransactionNo  ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_itemmaster itm ON itm.ItemID=ltd.ItemID ");
            sb.Append("     inner join employee_master em on em.Employee_ID=lt.Creator_UserID  ");
            sb.Append("     inner join patient_medical_history pmh on pmh.Transaction_ID=lt.Transaction_ID ");
            sb.Append("     inner join patient_master pm on pm.Patient_ID=pmh.Patient_ID ");
            sb.Append("     inner join f_panel_master pnl on pnl.Panel_ID=pmh.Panel_ID     ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")    ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
           // {
             //   sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
           // }
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }

            sb.Append("     LEFT JOIN f_ratelist r ON r.ItemID=ltd.ItemID  AND r.Panel_ID='78'   ");
            sb.Append("     inner join doctor_referal dr on dr.Doctor_ID=pmh.referedby ");
            sb.Append("    GROUP BY  ltd.ItemName,lt.LedgerTransactionNo  order by Company_Name,lt.LedgerTransactionNo ");
        }

        else if (rbtnReportType.SelectedItem.Text == "MonthWise")
        {

            sb.Append(" SELECT DATE,Centre,PanelName,SUM(GrossAmount) GrossAmount,SUM(DiscountAmount) DiscountAmount,   ");
            sb.Append(" SUM(NetAmount)NetAmount, SUM(ReceivedAmt)ReceivedAmt,SUM(PendingAmt)PendingAmt,SUM(PatientCount)  PatientCount   ");
            sb.Append(" FROM ( SELECT pnl.Panel_Id,DATE_FORMAT(lt.DATE,'" + rbtnReportType.SelectedValue.ToString() + "')DATE,lt.Date MySQLDate,   ");
            sb.Append(" cm.Centre,pnl.Company_Name PanelName,ROUND(SUM(lt.GrossAmount),2)GrossAmount,ROUND(SUM(lt.DiscountOnTotal),2) DiscountAmount,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),2)NetAmount,        ");
            sb.Append(" ROUND(SUM(lt.Adjustment),2) ReceivedAmt,    ");
            sb.Append(" ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,   ");
            sb.Append(" COUNT(lt.`LedgerTransactionNo` )PatientCount         ");
            sb.Append(" FROM f_ledgertransaction lt         ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.centreID          ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID      ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID      ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
            //    sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
            //}
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append(" GROUP BY  DATE_FORMAT(DATE,'" + rbtnReportType.SelectedValue.ToString() + "'),pnl.Panel_ID  ) t   ");
            sb.Append(" GROUP BY DATE,Panel_Id      ");
            sb.Append(" ORDER BY MySQLDate    ");

        }
        /**For ItemWise Panel Reports**/
        else
        {
            sb.Append("   SELECT dr.Name Doctor, pnl.Company_Name PanelName, DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,lt.LedgerTransactionNo LabNo,lt.BillNo,pmh.CardNo,concat(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'-',LEFT(pm.Gender,1))Age,  ");
            sb.Append("   GROUP_CONCAT(ltd.ItemName)ItemName,lt.GrossAmount,lt.DiscountOnTotal DiscountAmount,lt.NetAmount, lt.IsCancel,  IF(lt.IsDocUploaded,'Yes','')DocumentUploaded, lt.RemarksAccount, lt.DocUploadedBy, lt.DocUploadedTime, lt.RemarksAccountBy, lt.RemarksAccountTime, lt.DocUploadedByID, lt.RemarksAccountByID, ");
            sb.Append("   lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt,CONCAT(em.Title,' ', em.Name)UserName  ");

            sb.Append("   FROM f_ledgertransaction lt   ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }
            sb.Append("   INNER JOIN f_itemmaster itm ON itm.ItemID=ltd.ItemID  ");

            sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID  ");
            sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=pmh.Patient_ID  ");
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID   ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ") ");
            }
          //  if (UserInfo.Panel_Id != "" && PanelList == "")
           // {
             //   sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
           // }
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("   INNER JOIN doctor_referal dr ON dr.Doctor_ID=pmh.referedby  ");
            sb.Append("   INNER JOIN employee_master em ON em.Employee_ID =  lt.Creator_UserID   ");
            sb.Append("   GROUP BY lt.LedgerTransactionNo  ");
            sb.Append("   ORDER BY Company_Name,lt.date,lt.LedgerTransactionNo ");

        }
        if (Util.GetString(HttpContext.Current.Session["ID"]) == "EMP001")
        {
            // System.IO.File.WriteAllText("C:\\LedgerTausif.txt", sb.ToString());
        }

        return sb.ToString();

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        validation objval = new validation();
        bool validdate = objval.datevalidation(Util.GetDateTime(txtFromDate.Text));
        if (validdate == false)
        {
            lblMsg.Text = "You are not authorize to view report from this date";
            return;
        }
        string PanelList = "";
        string CentreList = "";
        string PanelTypeList = "";
        string FeildBoyList = "";
        foreach (ListItem item in lstpanellist.Items)
        {
            if (item.Selected == true)
            {
                PanelList = PanelList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstCentreList.Items)
        {
            if (item.Selected == true)
            {
                CentreList = CentreList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstpaneltype.Items)
        {
            if (item.Selected == true)
            {
                PanelTypeList = PanelTypeList + "'" + item.Value + "',";
            }
        }
        foreach (ListItem item in lstfeildboy.Items)
        {
            if (item.Selected == true)
            {
                FeildBoyList = FeildBoyList + "'" + item.Value + "',";
            }
        }

        if (PanelList == "")
        {
            lblMsg.Text = "Please Select Panel ";
            return;

        }
        if (CentreList == "")
        {
            lblMsg.Text = "Please Select Centre ";
            return;

        }
        PanelList = PanelList.TrimEnd(',');
        CentreList = CentreList.TrimEnd(',');
        PanelTypeList = PanelTypeList.TrimEnd(',');
        FeildBoyList = FeildBoyList.TrimEnd(',');
        StringBuilder sb = new StringBuilder();
        if (rbtnReportType.SelectedItem.Value == "0")
        {

            sb.Append("   SELECT pnl.Company_Name PanelName, ROUND(SUM(lt.GrossAmount),2)GrossAmount,ROUND(SUM(lt.DiscountOnTotal),2) DiscountAmount,ROUND(SUM(lt.NetAmount),2)NetAmount,  ");
            sb.Append("   ROUND(SUM(lt.Adjustment),2) ReceivedAmt, ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,COUNT(lt.`LedgerTransactionNo` )PatientCount, lt.ECHS ECHS,pli.BarcodeNo BarcodeNo  ");
            sb.Append("   FROM f_ledgertransaction lt        ");
            sb.Append("  INNER JOIN Patient_labInvestigation_Opd pli ON lt.LedgerTransactionNo = pli.LedgerTransactionNo   ");
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID = lt.Panel_ID  ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND lt.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("   GROUP BY pnl.Panel_ID    ");
            sb.Append("   ORDER BY pnl.Company_Name    ");
        }
        else if (rbtnReportType.SelectedItem.Value == "1")
        {
            sb.Append("   SELECT  pnl.Company_Name PanelName, lt.ECHS ECHS,pli.BarcodeNo BarcodeNo, lt.LedgerTransactionNo LabNo,DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,dr.Name Doctor,'' OtherDr,concat(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'-',LEFT(pm.Gender,1))Age, '' policy_passport, ");
            sb.Append("   GROUP_CONCAT(plo.ItemName)ItemName,lt.GrossAmount,lt.DiscountOnTotal DiscountAmount,lt.NetAmount,  ");
            sb.Append("   lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt ");
            sb.Append("   FROM f_ledgertransaction lt   ");
            sb.Append("  INNER JOIN Patient_labInvestigation_Opd pli ON lt.LedgerTransactionNo = pli.LedgerTransactionNo   ");
            sb.Append("   INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID = plo.LedgerTransactionID   ");
           // sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append("   INNER JOIN f_itemmaster itm ON itm.ItemID=plo.ItemID  ");
            sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID   ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ") ");
            }
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND lt.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("   INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID  ");
            sb.Append("   GROUP BY lt.LedgerTransactionNo  ");
            sb.Append("   ORDER BY Company_Name,lt.date,lt.LedgerTransactionNo  ");

        }
        /**For ItemWise Panel Reports**/
        else if (rbtnReportType.SelectedItem.Value == "2")
        {
            sb.Append("     select pnl.Company_Name ClientName,pnl.Panel_Code ClientCode,date_format(lt.Date,'%d-%b-%Y') RegDate,lt.LedgerTransactionNo LabNo,pm.PName,concat(pm.Age,'-',left(pm.Gender,1))Age, '' policy_passport,");
            sb.Append("     itm.TestCode ,plo.ItemName,plo.Rate GrossAmountItem,(plo.Rate-plo.Amount ) DisAmtItem, ");
            sb.Append("     plo.Amount NetAmountItem, plo.MRP, em.Name RegBy  ");
            sb.Append("     from f_ledgertransaction lt  ");
            sb.Append("     INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID = plo.LedgerTransactionID   ");
            sb.Append("     AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("     AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }
            sb.Append("     INNER JOIN f_itemmaster itm ON itm.ItemID=plo.ItemID ");
            sb.Append("     inner join employee_master em on em.Employee_ID=lt.CreatedByID  ");
            sb.Append("     inner join patient_master pm on pm.Patient_ID=lt.Patient_ID ");
            sb.Append("     inner join f_panel_master pnl on pnl.Panel_ID=lt.Panel_ID   ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("     order by pnl.Company_Name,lt.Date ");
        }

        else if (rbtnReportType.SelectedItem.Text == "MonthWise")
        {
            sb.Append(" SELECT   DATE,Centre,PanelName,SUM(GrossAmount) GrossAmount,SUM(DiscountAmount) DiscountAmount,   ");
            sb.Append(" SUM(NetAmount)NetAmount, SUM(ReceivedAmt)ReceivedAmt,SUM(PendingAmt)PendingAmt,SUM(PatientCount)  PatientCount   ");
            sb.Append(" FROM ( SELECT   pnl.Panel_Id,DATE_FORMAT(lt.DATE,'" + rbtnReportType.SelectedValue.ToString() + "')DATE,lt.Date MySQLDate,   ");
            sb.Append(" cm.Centre,pnl.Company_Name PanelName,ROUND(SUM(lt.GrossAmount),2)GrossAmount,ROUND(SUM(lt.DiscountOnTotal),2) DiscountAmount,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),2)NetAmount,        ");
            sb.Append(" ROUND(SUM(lt.Adjustment),2) ReceivedAmt,    ");
            sb.Append(" ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,   ");
            sb.Append(" COUNT(lt.`LedgerTransactionNo` )PatientCount         ");
            sb.Append(" FROM f_ledgertransaction lt         ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.centreID          ");
         //   sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID      ");
           // sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID      ");

            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
            //    sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
            //}
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append(" GROUP BY  DATE_FORMAT(DATE,'" + rbtnReportType.SelectedValue.ToString() + "'),pnl.Panel_ID  ) t   ");
            sb.Append(" GROUP BY DATE,Panel_Id      ");
            sb.Append(" ORDER BY MySQLDate    ");
        }
        else if (rbtnReportType.SelectedValue.ToString() == "3")
        {


            sb.Append(" SELECT DATE,Centre,PanelName,Round(SUM(GrossAmount)) GrossAmount,Month ");
            sb.Append(" FROM ( SELECT  pnl.Panel_Id,DATE_FORMAT(lt.DATE,'%M-%y')DATE,lt.Date MySQLDate,DATE_FORMAT(lt.DATE, '%m') Month,  ");
            sb.Append(" cm.Centre,pnl.Company_Name PanelName,ROUND(SUM(lt.GrossAmount))GrossAmount,ROUND(SUM(lt.DiscountOnTotal)) DiscountAmount,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),2)NetAmount,        ");
            sb.Append(" ROUND(SUM(lt.Adjustment),2) ReceivedAmt,    ");
            sb.Append(" ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,   ");
            sb.Append(" COUNT(lt.`LedgerTransactionNo` )PatientCount         ");
            sb.Append(" FROM f_ledgertransaction lt         ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.centreID          ");
          //  sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID      ");
          //  sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID      ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append(" GROUP BY  DATE_FORMAT(DATE,'%M-%y'),pnl.Panel_ID  ) t   ");
            sb.Append(" GROUP BY DATE,Panel_Id      ");
            sb.Append(" ORDER BY Month    ");
            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt1 = changedatatablepaneldetail1(dtme, "Department");
                if (dt1.Rows.Count > 0)
                {
                    Session["ReportName"] = "Monthly - Gross Amount";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt1;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);
                }
            }
        }
        else if (rbtnReportType.SelectedValue.ToString() == "4")
        {

            sb.Append(" SELECT DATE,Centre,PanelName,Round(SUM(NetAmount))NetAmount,Month ");
            sb.Append(" FROM ( SELECT  pnl.Panel_Id,DATE_FORMAT(lt.DATE,'%M-%y')DATE,DATE_FORMAT(lt.DATE, '%m') Month,lt.Date MySQLDate,   ");
            sb.Append(" cm.Centre,pnl.Company_Name PanelName,ROUND(SUM(lt.GrossAmount))GrossAmount,ROUND(SUM(lt.DiscountOnTotal)) DiscountAmount,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),2)NetAmount,        ");
            sb.Append(" ROUND(SUM(lt.Adjustment),2) ReceivedAmt,    ");
            sb.Append(" ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,   ");
            sb.Append(" COUNT(lt.`LedgerTransactionNo` )PatientCount         ");
            sb.Append(" FROM f_ledgertransaction lt         ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.centreID          ");
       //     sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID      ");
         //   sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID      ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.IsCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=0 ");
                }
                else
                {
                    sb.Append(" and lt.IsCredit<>0 and pnl.RollingAdvance=1 ");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
            //    sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
            //}
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append(" GROUP BY  DATE_FORMAT(DATE,'%M-%Y'),pnl.Panel_ID  ) t   ");
            sb.Append(" GROUP BY DATE,Panel_Id      ");
            sb.Append(" ORDER BY Month      ");
           // System.IO.File.AppendAllText(@"C:\months.txt", sb.ToString());
            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt1 = changedatatableNetamountWise(dtme, "Department");
                if (dt1.Rows.Count > 0)
                {
                    Session["ReportName"] = "Monthly - Net Amount";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt1;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);
                }
            }
        }
        else if (rbtnReportType.SelectedValue.ToString() == "5")
        {

            sb.Append(" SELECT DATE,Centre,PanelName,Round(SUM(PendingAmt))PendingAmt ");
            sb.Append(" FROM ( SELECT pnl.Panel_Id,DATE_FORMAT(lt.DATE,'%M-%y')DATE,lt.Date MySQLDate,   ");
            sb.Append(" cm.Centre,pnl.Company_Name PanelName,ROUND(SUM(lt.GrossAmount))GrossAmount,ROUND(SUM(lt.DiscountOnTotal)) DiscountAmount,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),2)NetAmount,        ");
            sb.Append(" ROUND(SUM(lt.Adjustment),2) ReceivedAmt,    ");
            sb.Append(" ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,   ");
            sb.Append(" COUNT(lt.`LedgerTransactionNo` )PatientCount         ");
            sb.Append(" FROM f_ledgertransaction lt         ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.centreID          ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID      ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }

            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID      ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ")   ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
            //    sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
            //}
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.HomeVisitBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append(" GROUP BY  DATE_FORMAT(DATE,'%M-%y'),pnl.Panel_ID  ) t   ");
            sb.Append(" GROUP BY DATE,Panel_Id      ");
            sb.Append(" ORDER BY PanelName ,MySQLDate    ");
            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt1 = changedatatablePendingAmountWise(dtme, "Department");
                if (dt1.Rows.Count > 0)
                {
                    Session["ReportName"] = "PanelwiseBusinessReport_For_PendingAmount";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt1;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);
                }
            }
        }
        /**For ItemWise Panel Reports**/
        else
        {
            sb.Append("   SELECT dr.Name Doctor, pnl.Company_Name PanelName, DATE_FORMAT(lt.Date,'%d-%b-%Y') DATE,lt.LedgerTransactionNo LabNo,lt.BillNo,pmh.CardNo,concat(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'-',LEFT(pm.Gender,1))Age, lt.policy_passport `ESIC/CGHS/ECHS Id`, ");
            sb.Append("   GROUP_CONCAT(ltd.ItemName)ItemName,lt.GrossAmount,lt.DiscountOnTotal DiscountAmount,lt.NetAmount, lt.IsCancel,  IF(lt.IsDocUploaded,'Yes','')DocumentUploaded, lt.RemarksAccount, lt.DocUploadedBy, lt.DocUploadedTime, lt.RemarksAccountBy, lt.RemarksAccountTime, lt.DocUploadedByID, lt.RemarksAccountByID, ");
            sb.Append("   lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt,CONCAT(em.Title,' ', em.Name)UserName  ");

            sb.Append("   FROM f_ledgertransaction lt   ");
            sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
            sb.Append("   AND lt.IsCancel=0   ");
            sb.Append("   AND  lt.Date>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'   ");
            sb.Append("   AND  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            if (CentreList != "")
            {
                sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
            }


            sb.Append("   INNER JOIN f_itemmaster itm ON itm.ItemID=ltd.ItemID  ");

            sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID  ");
            sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=pmh.Patient_ID  ");
            sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID   ");
            if (chkPaymentMode.SelectedItem.Value != "All")
            {
                //Updated By Bilal-15/04/2019
                if (chkPaymentMode.SelectedItem.Value == "Cash")
                {
                    sb.Append(" and lt.AmtCredit=0 ");
                }
                else if (chkPaymentMode.SelectedItem.Value == "Credit")
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=0");
                }
                else
                {
                    sb.Append(" and lt.AmtCredit<>0 and pnl.RulingAdvance=1");
                }
            }
            if (PanelList != "")
            {
                sb.Append("   AND pnl.Panel_ID IN (" + PanelList + ") ");
            }
            //if (UserInfo.Panel_Id != "" && PanelList == "")
            //{
            //    sb.Append(" AND pnl.Panel_ID IN (" + UserInfo.Panel_Id + ") ");
            //}
            //priya
            if (PanelTypeList != "")
            {
                sb.Append("   AND pnl.PanelGroupID IN (" + PanelTypeList + ")   ");
            }
            if (FeildBoyList != "")
            {
                sb.Append("   AND pnl.FieldBoyID IN (" + FeildBoyList + ")   ");
            }
            sb.Append("   INNER JOIN doctor_referal dr ON dr.Doctor_ID=pmh.referedby  ");
            sb.Append("   INNER JOIN employee_master em ON em.Employee_ID =  lt.Creator_UserID   ");
            sb.Append("   GROUP BY lt.LedgerTransactionNo  ");
            sb.Append("   ORDER BY Company_Name,lt.date,lt.LedgerTransactionNo ");

        }


        if (rbtnReportType.SelectedValue.ToString() != "3" && rbtnReportType.SelectedValue.ToString() != "4" && rbtnReportType.SelectedValue.ToString() != "5")
        {
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                if (rbtnReportType.SelectedItem.Value == "0")
                {
                    Session["ReportName"] = "PanelwiseBusinessReport_Summary";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt;
                }
                else if (rbtnReportType.SelectedItem.Value == "1")
                {
                    Session["ReportName"] = "PanelwiseBusinessReport";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt;

                }
                /**Region Item Wise Business Reports***/
                else if (rbtnReportType.SelectedItem.Value == "2")
                {
                    Session["ReportName"] = "ItemwiseBusinessReport";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt;
                }

                else if (rbtnReportType.SelectedItem.Text == "MonthWise")
                {

                    Session["ReportName"] = "PanelwiseBusinessReport_MonthWise";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt;



                }
                else
                {
                    Session["ReportName"] = "PanelwiseBusinessReportUserWise";
                    Session["Period"] = "Period From : " + txtFromDate.Text.Trim() + " To : " + txtToDate.Text.Trim();
                    Session["dtExport2Excel"] = dt;

                }


                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../common/ExportToExcel.aspx');", true);

            }
            else
                lblMsg.Text = "No Records Found..";


        }
    }

    DataTable changedatatableNetamountWise(DataTable dt, string p)
    {


        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("Centre");
            dtc.Columns.Add("PanelName");


            DataView dv = dt.DefaultView.ToTable(true, "Date").DefaultView;
            //dv= dt.DefaultView.ToTable(true,"Month").DefaultView;
            //.Sort = "Date Asc ";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["DATE"].ToString(), typeof(int));
                // dtc.Columns.Add(dw.ToString());
            }
            dtc.Columns.Add("Total", typeof(int));

            DataView dvmonth = dt.DefaultView.ToTable(true, "Centre", "PanelName").DefaultView;
            dvmonth.Sort = "Centre,PanelName asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["Centre"] = dw["Centre"].ToString();
                dwr["PanelName"] = dw["PanelName"].ToString();



                DataRow[] dwme = dt.Select("PanelName='" + dw["PanelName"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["DATE"].ToString()] = Util.GetInt(dwm["NetAmount"].ToString());
                    int c = 0;
                    if (int.TryParse(dwm["NetAmount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                dwr["Total"] =Util.GetInt(a);
                dtc.Rows.Add(dwr);

            }




            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }
    }

    DataTable changedatatablePendingAmountWise(DataTable dt, string p)
    {


        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("Centre");
            dtc.Columns.Add("PanelName");


            DataView dv = dt.DefaultView.ToTable(true, "DATE").DefaultView;
            //dv.Sort = "DATE asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["DATE"].ToString(), typeof(int));
            }
            dtc.Columns.Add("Total", typeof(int));

            DataView dvmonth = dt.DefaultView.ToTable(true, "Centre", "PanelName").DefaultView;
            dvmonth.Sort = "Centre,PanelName asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["Centre"] = dw["Centre"].ToString();
                dwr["PanelName"] = dw["PanelName"].ToString();



                DataRow[] dwme = dt.Select("PanelName='" + dw["PanelName"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["DATE"].ToString()] = Util.GetInt(dwm["PendingAmt"].ToString());
                    int c = 0;
                    if (int.TryParse(dwm["PendingAmt"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                dwr["Total"] = Util.GetInt(a);
                dtc.Rows.Add(dwr);

            }




            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }
    }


    DataTable changedatatablepaneldetail1(DataTable dt, string p)
    {


        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("Centre");
            dtc.Columns.Add("PanelName");


            DataView dv = dt.DefaultView.ToTable(true, "DATE").DefaultView;
            // dv.Sort = "DATE asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["DATE"].ToString(), typeof(int));
            }
            dtc.Columns.Add("Total", typeof(int));

            DataView dvmonth = dt.DefaultView.ToTable(true, "Centre", "PanelName").DefaultView;
            dvmonth.Sort = "Centre,PanelName asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["Centre"] = dw["Centre"].ToString();
                dwr["PanelName"] = dw["PanelName"].ToString();



                DataRow[] dwme = dt.Select("PanelName='" + dw["PanelName"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["DATE"].ToString()] = Util.GetInt(dwm["GrossAmount"].ToString());
                    int c = 0;
                    if (int.TryParse(dwm["GrossAmount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                // dwr["Total"] = a.ToString();
                dwr["Total"] = Util.GetInt(a);
                dtc.Rows.Add(dwr);

            }




            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }
    }


}
