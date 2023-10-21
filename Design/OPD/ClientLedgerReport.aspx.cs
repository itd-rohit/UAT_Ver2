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
public partial class Design_OPD_ClientLedgerReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCenter();
            bindPanel();


        }
    }
    public void bindPanel()
    {          StringBuilder sb = new StringBuilder();
        string pro_id = HttpContext.Current.Session["PROID"].ToString();
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
         
	
       
		     sb.Append(" select fpm.panel_id,CONCAT(fpm.`Panel_Code`,'~',fpm.company_name ) company_name from f_panel_master fpm WHERE fpm.isactive=1 ");

            if (UserInfo.RoleID == 220 && UserInfo.LoginType != "PCC")
            {
                sb.Append(" and fpm.Panel_ID in(select cm.PanelID from centre_panel cm where cm.centreID= " + UserInfo.Centre + ") and fpm.PROID='" + pro_id + "' ");
            }

            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
            }

            else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            }
            else if (UserInfo.CentreType == "PUP")
                sb.Append(" and fpm.Panel_ID=" + UserInfo.LoginType + "");

            sb.Append(" order by company_name ");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        chkPanel.DataSource = dt;
        chkPanel.DataTextField = "Company_Name";
        chkPanel.DataValueField = "Panel_ID";
        chkPanel.DataBind();

    }
    public void bindCenter()
    {
        string str = " SELECT fl.centreID,cm.Centre Centre  FROM f_login fl INNER JOIN centre_master cm ON cm.CentreID=fl.centreID  WHERE cm.isactive='1' and employeeID='" + Session["id"].ToString() + "' AND fl.RoleID='" + Session["RoleID"].ToString() + "' ORDER BY cm.Centre ";
        // string str = " SELECT CentreID,Centre FROM centre_master WHERE Isactive=1 ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chkCentre.DataSource = dt;
        chkCentre.DataTextField = "Centre";
        chkCentre.DataValueField = "CentreID";
        chkCentre.DataBind();



        //for (int i = 0; i < chkCentre.Items.Count; i++)
        //    chkCentre.Items[i].Selected = true;



    }
    protected void btnSelectAll_Click(object sender, EventArgs e)
    {
        if (btnSelectAll.Text.ToUpper() == "SELECT ALL")
        {
            for (int i = 0; i < chkPanel.Items.Count; i++)
                chkPanel.Items[i].Selected = true;

            btnSelectAll.Text = "DeSelect all";

        }
        else if (btnSelectAll.Text.ToUpper() == "DESELECT ALL")
        {
            for (int i = 0; i < chkPanel.Items.Count; i++)
                chkPanel.Items[i].Selected = false;

            btnSelectAll.Text = "Select all";

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        validation objval = new validation();
      
       // bool validdate = objval.datevalidation(Util.GetDateTime(txtFromDate.Text));
       // if (validdate == false)
       // {
         //   lblMsg.Text = "You are not authorize to view report from this date";
         //   return;
       // }
        string str = "";
        if (rblReporttype.SelectedValue == "0")
        {
             str = getSearchQueryforpcc();
        }
        else if (rblReporttype.SelectedValue == "1")
        {
            str = getsummary();
        }
        if (str == "")
        {
            return;
        }
        DataTable dt = StockReports.GetDataTable(str);

        DataColumn dc = new DataColumn();
        dc.ColumnName = "RunningTotal";
        dc.DefaultValue = "00000000.00";
        dt.Columns.Add(dc);

        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i == 0)
            {
                dt.Rows[i]["RunningTotal"] = Util.GetDouble(dt.Rows[i]["OpeningAmount"]) + Util.GetDouble(dt.Rows[i]["Amount"]);            
            }
            else if (dt.Rows[i - 1]["Panel_ID"].ToString() != dt.Rows[i]["Panel_ID"].ToString())
            {
                dt.Rows[i]["RunningTotal"] = Util.GetDouble(dt.Rows[i]["OpeningAmount"]) + Util.GetDouble(dt.Rows[i]["Amount"]); 
            }
            else
            {
                dt.Rows[i]["RunningTotal"] = Util.GetDouble(dt.Rows[i - 1]["RunningTotal"]) + Util.GetDouble(dt.Rows[i]["Amount"]);
            
            }

        }
        




        DataColumn dc1 = new DataColumn();
        dc1.ColumnName = "User";
        dc1.DefaultValue = "";
        dt.Columns.Add(dc1);

        DataColumn dc2 = new DataColumn();
        dc2.ColumnName = "Period";
        dc2.DefaultValue = "Period From : " + txtFromDate.Text.Trim() + " To " + txtToDate.Text.Trim();
        dt.Columns.Add(dc2);

        DataColumn dc3 = new DataColumn();
        dc3.ColumnName = "Centre";
        dc3.DefaultValue = GetSelection(chkCentre);
        dt.Columns.Add(dc3);



        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        Session["ds"] = ds;
        if (rblReporttype.SelectedValue == "0")
        {
           
            //  ds.WriteXmlSchema(@"E:\PanelWiseBusssinessReportPCC.xml");
            Session["ReportName"] = "PanelWiseBusssinessReportPCC";
        }
        else if (rblReporttype.SelectedValue == "1")
        {
           //  ds.WriteXmlSchema(@"E:\PanelWiseBusssinessReportPCCsummary.xml");
             Session["ReportName"] = "PanelWiseBusssinessReportPCCsummary";
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

    }
    public string getsummary()
    {
        StringBuilder sb = new StringBuilder();
        string PanelList = StockReports.GetSelection(chkPanel);
        if (PanelList == "")
        {
            lblMsg.Text = "Please Select Panel";
            return "";
        }
        sb.Append(" SELECT pm.`Panel_ID`,pm.Company_Name Panel_Code,pm.`Company_Name`,");
        sb.Append("  IFNULL(OpenReceive.receivedAmt,0)-IFNULL(OpenBook.NetAmount,0) OpeningAmount,");
        sb.Append(" DATE_FORMAT(aa.`Date`,'%d-%b-%y') Date,");
        sb.Append("  aa.rate `mrp_rate`,aa.`Amount`, aa.`Type`, aa.`Logistic_charges`,aa.`Stationary_charges` ");
        sb.Append("    FROM f_panel_master pm ");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT SUM(receivedAmt)receivedAmt,Panel_id ");
        sb.Append("   FROM `invoicemaster_onaccount` ");
        sb.Append("  WHERE iscancel=0 AND `ReceivedDate` < '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        if (PanelList != "")
        {
            sb.Append(" AND Panel_id in(" + PanelList + ")  ");
        }
        sb.Append("  GROUP BY `Panel_id` ) OpenReceive ON OpenReceive.Panel_id=pm.Panel_id ");
        sb.Append("LEFT JOIN ");
        sb.Append("  (SELECT SUM(lt.NetAmount)NetAmount,fpm.`Panel_ID` Panel_id ");
        sb.Append("  FROM  `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");
        sb.Append("  WHERE  lt.Date < '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ")  ");
        }
        sb.Append("  GROUP BY fpm.`Panel_ID` ) OpenBook ON OpenBook.Panel_id=pm.Panel_id ");
        sb.Append("  LEFT JOIN ( ");
        sb.Append(" SELECT ReceivedDate `Date`, Panel_id, ");
        sb.Append(" '' rate,`ReceivedAmt` `Amount`, 'ClientPayment' `Type` ,0 `Logistic_charges`,0 `Stationary_charges`  ");
        sb.Append(" FROM `invoicemaster_onaccount` ");
        sb.Append(" WHERE `ReceivedDate` >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND `ReceivedDate` <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

        if (PanelList != "")
        {
            sb.Append(" AND Panel_id in(" + PanelList + ") ");
        }      
        // for opd
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE(lt.`Date`)DATE,fpm.`Panel_ID` Panel_id,  ");
        sb.Append(" plo.`rate`,sum((-1) * plo.`Amount`)Amount, 'TestBooking' `Type`,lt.NetAmount Logistic_charges,lt.DiscountOnTotal Stationary_charges ");
        sb.Append(" FROM  `f_ledgertransaction` lt ");
        sb.Append("       INNER JOIN `patient_labinvestigation_opd` plo  ON plo.`LedgerTransactionNo` = lt.`LedgerTransactionNo` AND plo.isPackage=0 ");     
        sb.Append(" INNER JOIN  f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");      
        sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ") ");
        }
        sb.Append(" GROUP BY DATE(lt.`Date`),lt.LedgerTransactionNo ");
        // for Package
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE(lt.`Date`)DATE,fpm.`Panel_ID` Panel_id,  ");
        sb.Append(" plo.`rate`,sum((-1) * plo.`Amount`)Amount, 'PackgeBooking' `Type`,lt.NetAmount Logistic_charges,lt.DiscountOnTotal Stationary_charges ");
        sb.Append(" FROM  `f_ledgertransaction` lt ");
        sb.Append("      INNER JOIN `patient_labinvestigation_opd` plo  ON plo.`LedgerTransactionNo` = lt.`LedgerTransactionNo` AND plo.isPackage=1 ");       
        sb.Append(" INNER JOIN  f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");       
        sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ") ");
        }
        sb.Append(" GROUP BY DATE(lt.`Date`),lt.LedgerTransactionNo ");
        sb.Append(" ) aa ON aa.Panel_id=pm.`Panel_ID` ");
        sb.Append("   WHERE pm.isActive=1   ");//AND pm.invoicepanelid=pm.Panel_ID
        if (PanelList != "")
        {
            sb.Append(" AND pm.Panel_ID  in(" + PanelList + ") ");
        }
        sb.Append("  ORDER BY pm.`Company_Name`,aa.date,aa.`Type` Desc ");

        return sb.ToString();

    }
    public string getSearchQueryforpcc()
    {
        string PanelList = StockReports.GetSelection(chkPanel);
        string CentreList = StockReports.GetSelection(chkCentre);
        StringBuilder sb = new StringBuilder();

        if (PanelList == "" )
        {
            lblMsg.Text = "Please Select Panel";
            return "";
        }

        sb.Append(" SELECT aa.Remarks `Panel_ID`,pm.Company_Name Panel_Code,pm.`Company_Name`,");
        sb.Append("  IFNULL(OpenReceive.receivedAmt,0)-IFNULL(OpenBook.NetAmount,0) OpeningAmount,");
        sb.Append(" DATE_FORMAT(IFNULL(aa.`Date`,CURRENT_DATE),'%d-%b-%y') Date,  aa.`BarcodeNo`,aa.`PName` ,aa.ItemName, aa.DoctorName, ");
        sb.Append("  aa.rate `mrp_rate`,aa.`Amount`, aa.`Type`, aa.`Logistic_charges`,aa.`Stationary_charges` ");
        sb.Append("    FROM f_panel_master pm ");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT SUM(receivedAmt)receivedAmt,Panel_id ");
        sb.Append("   FROM `invoicemaster_onaccount` ");
        sb.Append("  WHERE iscancel=0 AND `ReceivedDate` < '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        if (PanelList != "")
        {
            sb.Append(" AND Panel_id in(" + PanelList + ")  ");
        }
        sb.Append("  GROUP BY `Panel_id` ) OpenReceive ON OpenReceive.Panel_id=pm.Panel_id ");
        sb.Append("LEFT JOIN ");
        sb.Append("  (SELECT SUM(lt.NetAmount)NetAmount,fpm.`Panel_ID` Panel_id ");
        sb.Append("  FROM  `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");
        sb.Append("  WHERE lt.Date < '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ")  ");
        }
        //if (CentreList != "")
        //{
        //    sb.Append("   AND lt.CentreID IN (" + CentreList + ")   ");
        //}
        sb.Append("  GROUP BY fpm.`Panel_ID` ) OpenBook ON OpenBook.Panel_id=pm.Panel_id ");
        sb.Append("  LEFT JOIN ( ");
        sb.Append(" SELECT ReceivedDate `Date`, Panel_id,  '' `BarcodeNo`,'' `PName` ,'' ItemName, '' DoctorName, ");
        sb.Append(" '' rate,`ReceivedAmt` `Amount`, 'ClientPayment' `Type` ,0 `Logistic_charges`,0 `Stationary_charges`,Remarks  ");
        sb.Append(" FROM `invoicemaster_onaccount` ");
        sb.Append(" WHERE iscancel=0 AND `ReceivedDate` >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' AND `ReceivedDate` <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
       
        if (PanelList != "")
        {
            sb.Append(" AND Panel_id in(" + PanelList + ") ");
        }
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE(lt.`Date`)DATE,fpm.`Panel_ID` Panel_id,  plo.`BarcodeNo`,pm.`PName` ,GROUP_CONCAT(plo.`ItemName`)ItemName, dr.`Name` DoctorName, ");//GROUP_CONCAT(DISTINCT ltd.`ItemName`)ItemName
        //sb.Append(" SUM(ltd.`rate`)rate,(-1) * SUM(ltd.`Amount`)Amount, 'TestBooking' `Type`,lt.NetAmount Logistic_charges,lt.DiscountOnTotal Stationary_charges ");
        sb.Append(" SUM(plo.rate)rate,(-1) * SUM(plo.`Amount`)Amount, 'PackageBooking' `Type`,SUM(plo.rate) Logistic_charges,lt.DiscountOnTotal Stationary_charges,'' Remarks ");
        sb.Append(" FROM  `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND plo.isPackage=0 ");
        sb.Append(" INNER JOIN `doctor_referal` dr ON dr.Doctor_id=lt.`Doctor_id` ");
        sb.Append(" INNER JOIN  f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID` ");
        sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ") ");
        }
        //if (CentreList != "")
        //{
        //    sb.Append("   AND lt.CentreID IN (" + CentreList + ")   ");
        //}
        sb.Append(" GROUP BY lt.LedgerTransactionNo ");
        // for Package
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT DATE(lt.`Date`)DATE,fpm.`Panel_ID` Panel_id,  '' `BarcodeNo`,pm.`PName` ,GROUP_CONCAT(plo.`ItemName`)ItemName, dr.`Name` DoctorName, ");//GROUP_CONCAT(DISTINCT ltd.`ItemName`)ItemName
        //sb.Append(" SUM(ltd.rate)rate,(-1) * SUM(ltd.`Amount`)Amount, 'PackageBooking' `Type`,lt.NetAmount Logistic_charges,lt.DiscountOnTotal Stationary_charges ");
        sb.Append(" SUM(plo.rate)rate,(-1) * SUM(plo.`Amount`)Amount, 'PackageBooking' `Type`,sum(plo.Rate) Logistic_charges,lt.DiscountOnTotal Stationary_charges,'' Remarks ");
        sb.Append(" FROM  `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND plo.isPackage=1 ");
        sb.Append(" INNER JOIN `doctor_referal` dr ON dr.Doctor_id=lt.`Doctor_id` ");
        sb.Append(" INNER JOIN  f_panel_master fpm ON fpm.`Panel_id`=lt.`Panel_id` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID` ");
     
        sb.Append(" WHERE lt.Date >= '" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.Date <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (PanelList != "")
        {
            sb.Append(" AND fpm.`Panel_ID` in(" + PanelList + ") ");
        }
        //if (CentreList != "")
        //{
        //    sb.Append("   AND lt.CentreID IN (" + CentreList + ")   ");
        //}
         sb.Append(" GROUP BY lt.LedgerTransactionNo ");
        sb.Append(" ) aa ON aa.Panel_id=pm.`Panel_ID` ");
        sb.Append("   WHERE pm.isActive=1   ");//AND pm.invoicepanelid=pm.Panel_ID
        if (PanelList != "")
        {
            sb.Append(" AND pm.Panel_ID  in(" + PanelList + ") ");
        }
        sb.Append("  ORDER BY pm.`Company_Name`,aa.date,aa.`Type` ");
        //System.IO.File.WriteAllText(@"E:/Vision Diagnostic centre/vision_live/ErrorLog/clile.txt", sb.ToString());
        return sb.ToString();

    }

    
    public string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ", " + li.Text + "";
                else
                    str = " " + li.Text + "";
            }
        }
        return str;
    }


    private string GetSelectionvalue(CheckBoxList cbl)
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
    protected void chkPanel_SelectedIndexChanged(object sender, EventArgs e)
    {

        string str = string.Empty;

        foreach (ListItem li in chkPanel.Items)
        {
            if (li.Selected)
            {
                str += "\"" + li.Value + "\"" + ",";
            }
        }
        if (str != "")
        {
            DataTable dtpanel = StockReports.GetDataTable(" SELECT Panel_id FROM f_panel_master WHERE `invoicepanelid` in (" + str.TrimEnd(',') + ")");
            if (dtpanel.Rows.Count > 0)
            {
                foreach (DataRow dr in dtpanel.Rows)
                {
                    foreach (ListItem li in chkPanel.Items)
                    {
                        if (li.Value == dr["Panel_id"].ToString())
                        {
                            li.Selected = true;
                        }

                    }
                }
            }
        }
    }
    protected void rbltype_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPanel();
    }
}
