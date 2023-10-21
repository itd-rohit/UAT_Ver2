using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Online_Lab_OtherReports : System.Web.UI.Page
{
    private DataTable dtSearch;
    private string PID = "";
    private string TID = "";
    private string LabType = "";
    private string LedgerTransactionNo = "";
    private string StrPrintHead = "";
    private string OnlineUserType = "";
    private string OnlinePanelID = "";
    private string OnlineDocID = "";
    private string OnlinePROID = "";
    public DataTable dt;
    public DataTable attac, dtRadiologyRpt;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Session["islogin"]) != "true")
        {
            Response.Redirect("~/Design/OnlineLab/Default.aspx");
        }
        OnlineUserType = Request.QueryString["UserType"].ToString();
        PID = Request.QueryString["PID"].ToString();
        TID = Request.QueryString["TID"].ToString();
        LabType = Request.QueryString["LabType"].ToString();
        LedgerTransactionNo = Request.QueryString["LedgerTransactionNo"].ToString();
        OnlinePanelID = Request.QueryString["OnlinePanelID"];
        OnlineDocID = Request.QueryString["OnlineDocID"];
        OnlinePROID = Request.QueryString["OnlinePROID"];
        OnlineUserType = Request.QueryString["UserType"];
        //Session["ID"] = "ONLINE";

        Session["RoleID"] = "";
        if (!IsPostBack)
        {
            bindPanel();
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            Session["RoleID"] = "";
            Session["LoginName"] = "Online";

            btn_payment.Visible = false;
            if (OnlineUserType == "Panel")
            {
                trpanelforpro.Visible = false;
                btn_prosummary.Visible = false;
                btn_prodetail.Visible = false;
                DataTable dtpanel = StockReports.GetDataTable(" SELECT (inamount-outamount) AS Bal ,payment_mode, ratelist,isfinance , CreditLimit  FROM f_panel_master WHERE panel_id='" + OnlinePanelID + "' ");
                Session["dtc"] = dtpanel;
                if (dtpanel.Rows.Count > 0)
                {
                    if (Util.GetString(dtpanel.Rows[0]["payment_mode"]).ToUpper() == "ADVANCE")
                    {
                        if (Util.GetString(dtpanel.Rows[0]["ratelist"]).ToUpper() == "1")
                        {
                            btn_payment.Visible = true;
                        }
                        else
                        {
                            btn_payment.Visible = false;
                        }
                        if (Util.GetString(dtpanel.Rows[0]["isfinance"]).ToUpper() == "1")
                        {
                            btn_LedgerRpt.Visible = true;
                        }
                        else
                        {
                            btn_LedgerRpt.Visible = false;
                        }
                    }
                    if (Util.GetString(dtpanel.Rows[0]["ratelist"]).ToUpper() == "1")
                    {
                        lk_ratelist.Visible = true;
                    }
                    else
                    {
                        lk_ratelist.Visible = false;
                    }
                    if (Util.GetString(dtpanel.Rows[0]["isfinance"]).ToUpper() == "1")
                    {
                        btn_SummaryRpt.Visible = true;
                        btn_DetailedRpt.Visible = true;
                    }
                    else
                    {
                        btn_SummaryRpt.Visible = false;
                        btn_DetailedRpt.Visible = false;
                        btn_LedgerRpt.Visible = false;
                    }
                }
            }
            else if (OnlineUserType == "PRO")
            {
                btn_payment.Visible = false;
                lk_ratelist.Visible = false;
                btn_SummaryRpt.Visible = false;
                btn_DetailedRpt.Visible = false;
                btn_samplerej.Visible = false;
                btn_prosummary.Visible = true;
                btn_prodetail.Visible = true;
                trpanelforpro.Visible = true;
                btn_LedgerRpt.Visible = false;
            }
        }
    }

    protected void ink_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Design/OnlineLab/Default.aspx");
    }

    public void bindPanel()
    {
        string str = "SELECT Company_Name,Panel_ID FROM f_panel_master ORDER BY Company_Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chkPanel.DataSource = dt;
        chkPanel.DataTextField = "Company_Name";
        chkPanel.DataValueField = "Panel_ID";
        chkPanel.DataBind();
    }

    protected void lk_ratelist_Click(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["UserType"]).ToUpper() == "PANEL")
        {
            string panelName = Util.GetString(StockReports.ExecuteScalar("SELECT company_name FROM f_panel_master WHERE panel_id='" + OnlinePanelID + "' "));

            StringBuilder sb = new StringBuilder();

            sb.Append("select a.Panel_ID,a.ItemID,a.Company_Name PanelName,a.TypeName Investigation, ");
            sb.Append("a.Name Department,IFNULL(r.Rate,0) Rate,IFNULL(Frate,0)  FRate,r.ItemCode PanelCode,MasterCode,sampletype,CutOffTime,TAT from ");
            sb.Append("(select pm.Panel_ID,pm.ReferenceCodeOPD,im.ItemID,pm.Company_Name,im.TestCode MasterCode,im.TypeName,sc.Name,im.showflag, ");
            sb.Append(" (SELECT GROUP_CONCAT(sampletypename SEPARATOR ',') FROM investigations_sampletype WHERE investigation_id=im.type_id) sampletype,");
            sb.Append(" (SELECT CutOffTime FROM investiagtion_delivery WHERE investigation_id=im.type_id LIMIT 1) CutOffTime,");
            sb.Append(" (SELECT days FROM investiagtion_delivery WHERE investigation_id=im.type_id LIMIT 1) TAT, ");
            sb.Append("  (SELECT erate FROM f_ratelist  WHERE Panel_ID ='78' AND iscurrent='1' AND itemid=im.itemid) Frate");
            sb.Append(" from f_subcategorymaster sc ");
            sb.Append("inner join f_itemmaster im on im.SubCategoryID=sc.SubCategoryID and sc.CategoryID in ('LSHHI3','LSHHI44')  and im.IsActive=1 and im.typename<>''  ");
            //if (ddlOutSrc.SelectedValue == "InHouse")
            //{
            //    sb.Append(" and im.isTrigger=0");
            //}
            //if (ddlOutSrc.SelectedValue == "OutSource")
            //{
            //    sb.Append(" and im.isTrigger=1");
            //}
            sb.Append(" and sc.CategoryID in ('LSHHI3','LSHHI44') ");
            // sb.Append("and sc.SubCategoryID in (" + SubCategoryID + ") ");
            sb.Append("cross join f_panel_master pm on pm.Panel_ID in (" + OnlinePanelID + ") ) a ");
            sb.Append("left outer join ");
            sb.Append("(select * from  f_ratelist where isCurrent=1 and Panel_ID in ");
            sb.Append("(select distinct ReferenceCodeOPD from f_panel_master where Panel_ID in (" + OnlinePanelID + ")))r ");
            sb.Append("on a.ReferenceCodeOPD = r.Panel_ID and a.ItemID=r.ItemID order by a.Name,a.TypeName ");

            //sb.Append(" SELECT im.`ItemID`,sc.`Name` Department,im.`TypeName` TestName, r.`Rate` 'MRP',");
            //sb.Append("  r2.`Rate` 'MRP2', '" + panelName + "' panelName FROM f_itemmaster im ");
            //sb.Append(" INNER JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND im.`IsActive`=1 AND r.`Panel_ID`='78' ");
            //sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
            //sb.Append(" INNER JOIN f_ratelist r2 ON r2.`ItemID`=im.`ItemID` AND im.`IsActive`=1 AND r2.`Panel_ID`= ");
            //sb.Append(" (SELECT `ReferenceCodeOPD` FROM `f_panel_master` WHERE `Panel_ID`= '" + OnlinePanelID + "') ");
            //sb.Append(" ORDER BY sc.`Name`,im.`TypeName`");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                ds.AcceptChanges();
                //  ds.WriteXmlSchema(@"D:\ratelist.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "RateListReport";
                // ds.WriteXml("c:/Ratelist.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "keymsg", "alert('No Record Found');", true);
            }
        }
    }

    protected void Btn_logout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Design/OnlineLab/Default.aspx");
    }

    protected void btn_SummaryRpt_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT pnl.Company_Name PanelName, ROUND(SUM(lt.GrossAmount),2)GrossAmount,ROUND(SUM(lt.DiscountOnTotal),2) DiscountAmount,ROUND(SUM(lt.NetAmount),2)NetAmount,  ");
        sb.Append("   ROUND(SUM(lt.Adjustment),2) ReceivedAmt, ROUND(SUM(lt.NetAmount-lt.Adjustment),2) PendingAmt ,COUNT(lt.`LedgerTransactionNo` )cnt  ");
        sb.Append("   FROM f_ledgertransaction lt        ");
        sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID    ");
        sb.Append("   AND lt.IsCancel=0   ");
        sb.Append("   AND  DATE(lt.Date)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'   ");
        sb.Append("   AND DATE(lt.Date)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'    ");
        //if (CentreList != "")
        //{
        //    sb.Append("   AND lt.CentreID IN (" + CentreList + ")     ");
        //}

        sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID     ");
        // if (PanelList != "")
        // {
        sb.Append("   AND pnl.Panel_ID IN (" + OnlinePanelID + ")   ");
        //  }
        //if (chkMarketingPerson.Checked && MarketingPersonList != "")
        //    sb.Append("   AND pmh.ReferedBy IN (" + MarketingPersonList + ")  ");

        string payment_mode = Util.GetString(StockReports.ExecuteScalar(" select payment_mode from f_panel_master where panel_id='" + OnlinePanelID + "' "));

        //if (PanelPaymentMode != "")
        sb.Append("   AND  pnl.payment_mode IN ('" + payment_mode + "')  ");

        sb.Append("   GROUP BY pnl.Panel_ID    ");
        sb.Append("   ORDER BY pnl.Company_Name    ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = "";
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre";
            dc.DefaultValue = "ALL";
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            //ds.WriteXmlSchema(@"D:\PanelwiseBusinessRepor_Summary.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PanelwiseBusinessRepor_Summary";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void btn_DetailedRpt_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT dr.Name Doctor, pnl.Company_Name PanelName, DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE,lt.LedgerTransactionNo LabNo,lt.BillNo,pmh.CardNo,concat(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'-',LEFT(pm.Gender,1))Age, ");
        sb.Append("   GROUP_CONCAT(ltd.ItemName)ItemName,lt.GrossAmount,lt.DiscountOnTotal DiscountAmount,lt.NetAmount, lt.IsCancel,  IF(lt.IsDocUploaded,'Yes','')DocumentUploaded, lt.RemarksAccount, lt.DocUploadedBy, lt.DocUploadedTime, lt.RemarksAccountBy, lt.RemarksAccountTime, lt.DocUploadedByID, lt.RemarksAccountByID, ");
        sb.Append("   lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt ");

        sb.Append("   FROM f_ledgertransaction lt   ");
        sb.Append("   INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo   ");
        sb.Append("   AND lt.IsCancel=0 AND  DATE(lt.Date)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'  ");
        //if (CentreList != "")
        //{
        //    sb.Append("   AND lt.CentreID IN (" + CentreList + ")   ");
        //}
        sb.Append("   INNER JOIN f_itemmaster itm ON itm.ItemID=ltd.ItemID  ");

        sb.Append("   INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID  ");
        sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=pmh.Patient_ID  ");
        sb.Append("   INNER JOIN f_panel_master pnl ON pnl.Panel_ID=pmh.Panel_ID   ");
        //if (PanelList != "")
        //{
        sb.Append("   AND pnl.Panel_ID IN (" + OnlinePanelID + ") ");
        //}
        //if (chkMarketingPerson.Checked && MarketingPersonList != "")
        //    sb.Append("   AND pmh.ReferedBy in (" + MarketingPersonList + ")");

        string payment_mode = Util.GetString(StockReports.ExecuteScalar(" select payment_mode from f_panel_master where panel_id='" + OnlinePanelID + "' "));
        // if (PanelPaymentMode != "")
        sb.Append("   and  pnl.payment_mode in ('" + payment_mode + "')");

        sb.Append("   INNER JOIN doctor_referal dr ON dr.Doctor_ID=pmh.referedby  ");
        sb.Append("   GROUP BY lt.LedgerTransactionNo  ");
        sb.Append("   ORDER BY dr.Name,Company_Name,lt.LedgerTransactionNo  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = "";
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre";
            dc.DefaultValue = "ALL";
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());

            // ds.WriteXmlSchema(@"C:\PanelwiseBusinessReportCITY.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PanelwiseBusinessReportCITY";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void btn_payment_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string str = "SELECT pm.company_name, paid_amt 'Amount Paid',DATE_FORMAT(IF(fpp.isvalidated=1,fpp.validated_DateTime,fpp.paid_date),'%d-%M-%Y' )`Date`, IF(fpp.isvalidated=1, 'Validated', 'Validation Pending') `Status` FROM `franschisee_payment_panel` fpp INNER JOIN f_panel_master pm ON fpp.panel_id=pm.panel_id " +
                   " WHERE fpp.panel_id='" + OnlinePanelID + "' and DATE(fpp.paid_date)>= '" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(fpp.paid_date)<= '" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' UNION ALL SELECT 'Balance Amount:',inamount-outamount ,'' ,'' FROM f_panel_master WHERE panel_id='" + OnlinePanelID + "' AND payment_mode='Advance' ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = " Payment Details ";
            Session["Period"] = "Period From : " + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd");
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void btn_samplerej_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT SUBSTRING_INDEX(lt.TypeOfTnx,'-',1)TypeOfTnx,REPLACE(psr.Patient_ID,'LSHHI','')MRNO,psr.LedgerTransactionNo AS LedgerTransactionNo,CONCAT(pm.Title,pm.PName)PNAME,concat(pm.Age,'/',pm.Gender) AS Age,pm.Gender,TRIM(CONCAT(CONCAT(IFNULL(pm.Phone,''),'',IFNULL(pm.Mobile,'')))) Phone,pm.locality Address, ");
        sb.Append(" im.Name InvName, psr.RejectionReason,DATE_FORMAT(psr.EntDate,'%d-%b-%Y %I:%i%p') RejectionDate,em.Name RejectedBy,plo.samplereceivedby,plo.samplereceiver,DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%Y %I:%i%p') ReceiveDate  FROM patient_sample_Rejection  psr ");
        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=psr.Patient_ID ");
        sb.Append(" AND DATE(psr.EntDate)>='" + FrmDate.Text + "'  ");
        sb.Append(" and DATE(psr.EntDate)<='" + ToDate.Text + "' ");

        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=psr.LedgerTransactionNo and lt.panel_id ='" + Util.GetString(Request.QueryString["OnlinePanelID"]) + "'");
        sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=psr.UserID ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=psr.Investigation_ID LEFT JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=psr.LedgerTransactionNo  AND plo.Test_ID=psr.test_ID  ");
        sb.Append(" ORDER BY psr.LedgerTransactionNo ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = "Panel";
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"C:\SampleRejectionReport.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "SampleRejectionReport";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/CommonCrystalReport.aspx');", true);
            lblMsg.Text = dt.Rows.Count + " Records Found ";
        }
        else
        {
            lblMsg.Text = "Record Not found";
        }
    }

    protected void btn_prosummary_Click(object sender, EventArgs e)
    {
        string panel = AllLoad_Data.GetSelection(chkPanel);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT PROName,PatientCount,GrossAmt,DiscAmt,NetAmount,ReceivedAmt,GrossAmt_NonCredit,Disc_NonCredit,NetAmount_NonCredit,ReceivedAmt_NonCredit, ");
        sb.Append(" (NetAmount_NonCredit-ReceivedAmt_NonCredit) OutStandingAmt_NonCredit,PRO_CreditLimit, ");
        sb.Append(" GrossAmt_Credit,Disc_Credit,NetAmount_Credit,ReceivedAmt_Credit FROM ( ");
        sb.Append(" SELECT pro.PROName,count(lt.Transaction_ID)PatientCount, ");
        sb.Append(" SUM(IF(lt.AmtCredit=0,lt.GrossAmount,0))GrossAmt_NonCredit, ");
        sb.Append(" SUM(IF(lt.AmtCredit=0,lt.DiscountOnTotal,0)) Disc_NonCredit, ");
        sb.Append(" SUM(IF(lt.AmtCredit=0,lt.NetAmount,0))NetAmount_NonCredit, ");
        sb.Append(" SUM(IF(lt.AmtCredit=0,lt.Adjustment,0)) ReceivedAmt_NonCredit,  ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.GrossAmount,0))GrossAmt_Credit, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.DiscountOnTotal,0)) Disc_Credit, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.NetAmount,0))NetAmount_Credit, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.Adjustment,0)) ReceivedAmt_Credit,  ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.GrossAmount,0))GrossAmt, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.DiscountOnTotal,0)) DiscAmt, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.NetAmount,0))NetAmount, ");
        sb.Append(" SUM(IF(lt.AmtCredit!=0,lt.Adjustment,0)) ReceivedAmt,  ");
        sb.Append(" pro.CreditLimit PRO_CreditLimit ");
        sb.Append(" FROM  ");
        sb.Append("  f_ledgertransaction lt ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID ");

        sb.Append(" and lt.IsCancel=0  ");
        sb.Append(" AND DATE(lt.DATE)>='" + FrmDate.Text + "' ");
        sb.Append(" AND DATE(lt.DATE)<='" + ToDate.Text + "' ");

        sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=pmh.Panel_ID ");
        if (panel != "")
        {
            sb.Append(" And pm.panel_id in(" + panel + ")");
        }
        sb.Append(" INNER JOIN pro_master pro ON pro.PROID=pm.PROID AND pro.PROID ='" + OnlinePROID + "' ");
        sb.Append(" GROUP BY pro.PROID ) aa ORDER BY PROName ");

        DataTable dtsum = StockReports.GetDataTable(sb.ToString());
        if (dtsum.Rows.Count > 0)
        {
            Session["ReportName"] = "PRO Business Report(Summary)";
            Session["Period"] = "Period From : " + FrmDate.Text + " To : " + ToDate.Text;
            Session["dtExport2Excel"] = dtsum;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found.";
        }
    }

    protected void btn_LedgerRpt_Click(object sender, EventArgs e)
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append("   SELECT '' DATE ,'OpeningAmount' TYPE,  IF(Amount>0,Amount,0)  'DepositAmount(Debit)' ,IF(Amount<0,Amount,0)  'BillAmount(Credit)' FROM (               ");
        sb.Append(" SELECT  IFNULL(SUM(`Amount`),0)Amount FROM `franschisee_tnxdetail_panel` WHERE `IsValid`=1 AND `panelid`='" + OnlinePanelID + "' AND DATE(`Date`)<'" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' ) a");
        sb.Append(" UNION ALL ");
        sb.Append("SELECT DATE_FORMAT(`Date`,'%d-%b-%Y')DATE,'DepositAmount' TYPE, `Amount` 'DepositAmount(Debit)', 0 'BillAmount(Credit)'");
        sb.Append("FROM `franschisee_tnxdetail_panel` ");
        sb.Append(" WHERE `IsValid`=1 AND `panelid`='" + OnlinePanelID + "' ");
        sb.Append(" AND DATE(`Date`)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(`Date`)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND `PatientName`='FRANCHISEE'  ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE_FORMAT(`Date`,'%d-%b-%Y')DATE,'BillAmount' TYPE, 0 'DepositAmount(Debit)', `Amount` 'BillAmount(Credit)'");
        sb.Append(" FROM `franschisee_tnxdetail_panel` ");
        sb.Append(" WHERE `IsValid`=1 AND `panelid`='" + OnlinePanelID + "' ");
        sb.Append(" AND DATE(`Date`)>='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(`Date`)<='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND `PatientName`!='FRANCHISEE' "); // GROUP BY DATE(`Date`)");

        DataTable dtLedgerReport = StockReports.GetDataTable(sb.ToString());

        sb = new System.Text.StringBuilder();

        sb.Append(" SELECT distinct ftd.panelid CenterID, ftd.panelName CenterName, pm.add1 `address`,pm.mobile, pm.phone `contact`,pm.emailid `email` FROM `franschisee_tnxdetail_panel` ftd ");
        sb.Append(" INNER JOIN f_panel_master pm ON ftd.panelid=pm.panel_id  WHERE `IsValid`=1 AND ftd.`panelid`='" + OnlinePanelID + "' ");
        //AND DATE(`Date`)>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        //              sb.Append(" AND DATE(`Date`)<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND `PatientName`='FRANCHISEE'  GROUP BY DATE(`Date`) ");

        DataTable dtCm = StockReports.GetDataTable(sb.ToString());

        DataColumn dc = new DataColumn();
        dc = new DataColumn();
        dc.ColumnName = "Period";
        dc.DefaultValue = "Period From : " + FrmDate.Text + " To : " + ToDate.Text;
        dtLedgerReport.Columns.Add(dc);

        if (dtCm.Rows.Count > 0)
        {
            dc = new DataColumn();
            dc.ColumnName = "Centre";
            dc.DefaultValue = "Panel : " + Util.GetString(dtCm.Rows[0]["CenterName"]);
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre ID";
            dc.DefaultValue = "Panel ID : " + Util.GetString(dtCm.Rows[0]["CenterID"]);
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre Address";
            dc.DefaultValue = "Panel Address : " + Util.GetString(dtCm.Rows[0]["address"]);
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Mobile";
            dc.DefaultValue = "Mobile : " + Util.GetString(dtCm.Rows[0]["mobile"]);
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Contact";
            dc.DefaultValue = "Contact : " + Util.GetString(dtCm.Rows[0]["contact"]);
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Email";
            dc.DefaultValue = "Email : " + Util.GetString(dtCm.Rows[0]["email"]);
            dtLedgerReport.Columns.Add(dc);
        }
        else
        {
            dc = new DataColumn();
            dc.ColumnName = "Centre";
            dc.DefaultValue = "Panel : ";
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre ID";
            dc.DefaultValue = "Panel ID : ";
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Centre Address";
            dc.DefaultValue = "Panel Address : ";
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Mobile";
            dc.DefaultValue = "Mobile : ";
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Contact";
            dc.DefaultValue = "Contact : ";
            dtLedgerReport.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "Email";
            dc.DefaultValue = "Email : ";
            dtLedgerReport.Columns.Add(dc);
        }

        DataSet ds = new DataSet();
        ds.Tables.Add(dtLedgerReport.Copy());

        //                ds.WriteXml("E:/dtLedgerReport.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "LedgerReport";

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
    }

    protected void btn_prodetail_Click(object sender, EventArgs e)
    {
        string panel = AllLoad_Data.GetSelection(chkPanel);
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT pro.PROName,dr.Name Doctor, DATE_FORMAT(lt.date,'%d-%b-%Y')DATE,");
        sb.Append(" lt.LedgertransactionNo LabNo,lt.GrossAmount,lt.DiscountOnTotal Disc,lt.NetAmount, ");
        sb.Append(" lt.Adjustment ReceivedAmt, IF(lt.AmtCredit=0,'Non-Credit','Credit') TYPE, pm.Company_Name Panel, ");
        sb.Append(" pro.CreditLimit PRO_CreditLimit,ptn.PName PatientName,ptn.Age,ptn.Gender,GROUP_CONCAT(ltd.ItemName)ItemsName , lt.DiscountReason   ");
        sb.Append(" from f_ledgertransaction lt ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  ");

        sb.Append(" and lt.IsCancel=0  ");
        sb.Append(" AND DATE(lt.DATE)>='" + FrmDate.Text + "' ");
        sb.Append(" AND DATE(lt.DATE)<='" + ToDate.Text + "' ");

        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.Transaction_ID  ");
        sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=pmh.Panel_ID ");
        if (panel != "")
        {
            sb.Append(" And pm.panel_id in(" + panel + ")");
        }
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID ");
        sb.Append(" INNER JOIN doctor_referal dr ON dr.Doctor_id =pmh.ReferedBy ");
        sb.Append(" INNER JOIN pro_master pro ON pro.PROID=pm.PROID AND pro.PROID  ='" + OnlinePROID + "' ");
        sb.Append(" INNER JOIN patient_master ptn ON ptn.Patient_id=pmh.Patient_id ");
        sb.Append(" GROUP BY lt.LedgertransactionNo ORDER BY pro.PROName,DATE(lt.Date),lt.LedgertransactionNo ");

        DataTable dtsum = StockReports.GetDataTable(sb.ToString());
        if (dtsum.Rows.Count > 0)
        {
            Session["ReportName"] = "PRO Business Report(Detail)";
            Session["Period"] = "Period From : " + FrmDate.Text + " To : " + ToDate.Text;
            Session["dtExport2Excel"] = dtsum;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "No Record Found.";
        }
    }
}