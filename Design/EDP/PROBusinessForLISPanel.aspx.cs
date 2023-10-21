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
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_OPD_PROBusinessForLISPanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.SetCurrentDate();
            txtToDate.SetCurrentDate();
            BindCenter();
            BindPRO();
            bindPanel();
            //BindDoctor();
        }
    }

    public void bindPanel()
    {

        if (chkPaymentMode.SelectedItem.Value == "Both")
        {
            string str = "SELECT Company_Name,Panel_ID FROM f_panel_master where Company_Name<>''    " + rblPanelStatus.SelectedItem.Value + " ORDER BY Company_Name  ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);
            chkPanel.DataSource = dt;
            chkPanel.DataTextField = "Company_Name";
            chkPanel.DataValueField = "Panel_ID";
            chkPanel.DataBind();
        }
        else if (chkPaymentMode.SelectedItem.Value == "lt.AmtCredit=0")
        {
            string str = "SELECT Company_Name,Panel_ID FROM f_panel_master where Company_Name<>'' and payment_mode='Cash' " + rblPanelStatus.SelectedItem.Value + " ORDER BY Company_Name  ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);
            chkPanel.DataSource = dt;
            chkPanel.DataTextField = "Company_Name";
            chkPanel.DataValueField = "Panel_ID";
            chkPanel.DataBind();
        }
        else
        {

            string str = "SELECT Company_Name,Panel_ID FROM f_panel_master where IsActive=1 and  payment_mode='Credit' ORDER BY Company_Name ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);
            chkPanel.DataSource = dt;
            chkPanel.DataTextField = "Company_Name";
            chkPanel.DataValueField = "Panel_ID";
            chkPanel.DataBind();

        }
    }
    public void BindCenter()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + Centre.Id + "' and AccessType=2 ) or cm.CentreID = '" + Centre.Id + "') and cm.isActive=1 order by cm.Centre  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstCenter.DataSource = dt;
        chklstCenter.DataTextField = "Centre";
        chklstCenter.DataValueField = "CentreID";
        chklstCenter.DataBind();
        for (int i = 0; i < chklstCenter.Items.Count; i++)
            chklstCenter.Items[i].Selected = true;

    }
    public void BindPRO()
    {
        string str = "SELECT  PROID,PRONAME FROM pro_master WHERE PRONAMe<>'' AND IsActive=1 ORDER BY PROname";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstPRO.DataSource = dt;
        chklstPRO.DataTextField = "PRONAME";
        chklstPRO.DataValueField = "PROID";
        chklstPRO.DataBind();
        //  chklstCenter. = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(Centre.Id));
    }
    public void BindDoctor()
    {
        string str = "SELECT Doctor_ID,NAME FROM doctor_referal WHERE IsActive=1 AND NAME<>'' ORDER BY NAME";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstDoctor.DataSource = dt;
        chklstDoctor.DataTextField = "NAME";
        chklstDoctor.DataValueField = "Doctor_ID";
        chklstDoctor.DataBind();
        //  chklstCenter. = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(Centre.Id));
    }
    public string SearchQuery()
    {
        StringBuilder sb = new StringBuilder();

        string chkCenter = StockReports.GetSelection(chklstCenter);
        string panel = StockReports.GetSelection(chkPanel);
        if (chkCenter == "")
        {
            lblMsg.Text = "!!! Please Select Centre !!!";
            return "";
        }

        if (panel == "")
        {
            // lblMsg.Text = "!!! Please Select Panel !!!";
            //   return "";
        }
        string PROData = StockReports.GetSelection(chklstPRO);
        if (PROData == "")
        {
            lblMsg.Text = "!!! Please Select PRO !!!";
            return "";
        }
        lblMsg.Text = "";
        if (rblReportType.SelectedValue == "Summary")
        {
            sb.Append(" SELECT t.PROName,SUM(t.PatientCount)  PatientCount,SUM(t.GrossAmt)  GrossAmt,SUM(t.DiscAmt)  DiscAmt, SUM(t.NetAmount)  NetAmount,   ");
            sb.Append(" SUM(t.ReceivedAmt)  ReceivedAmt   FROM (  ");
            sb.Append(" SELECT pro.PROID,pro.PROName,COUNT(lt.LedgerTransactionNo)PatientCount,   ");
            sb.Append(" SUM(lt.GrossAmount)GrossAmt, SUM(lt.DiscountOnTotal) DiscAmt,SUM(lt.NetAmount)NetAmount,SUM(lt.Adjustment)  ReceivedAmt   ");
            sb.Append(" FROM    f_ledgertransaction lt   ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID  AND lt.IsCancel=0  ");
            sb.Append(" AND lt.DATE>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND lt.DATE<='" + txtToDate.GetDateForDataBase() + " 23:59:59' and lt.IsCancel=0   ");
            if (chkCenter != "")
            {
                sb.Append("  AND lt.CentreId IN (" + chkCenter + ") ");
            }
            if (panel != "")
            {
                sb.Append(" And lt.Panel_ID in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pro.PROID=fpm.PROID    ");
            if (PROData != "")
            {
                sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            }
            sb.Append(" GROUP BY pro.PROID   ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT pro.PROID,pro.PROName,0 PatientCount,0 GrossAmt,0 DiscAmt,0 NetAmount,SUM(io.ReceivedAmt) ReceivedAmt    ");
            sb.Append(" FROM invoicemaster_onaccount io  ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_Id=io.Panel_ID AND io.IsCancel=0 AND io.Type='ON ACCOUNT' ");
            if (panel != "")
            {
                sb.Append(" And fpm.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pro.PROID=fpm.PROID ");
            if (PROData != "")
            {
                sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            }
            sb.Append(" WHERE io.ReceivedDate>='" + txtFromDate.GetDateForDataBase() + "'  AND io.ReceivedDate<='" + txtToDate.GetDateForDataBase() + "' ");
            sb.Append(" GROUP BY pro.PROID  ) t GROUP BY t.PROID ORDER BY t.PROName ");

        }
        else if (rblReportType.SelectedValue == "Performance")
        {
            sb.Append(" SELECT PROName,ClientName,SUM(t.PatientCount)  PatientCount,SUM(t.GrossAmt)  GrossAmt,SUM(t.DiscAmt)  DiscAmt, ROUND( SUM(t.GrossAmt)-SUM(t.DiscAmt),2)NetAmount,    ");
            sb.Append(" SUM(t.ReceivedAmt)  ReceivedAmt FROM (    ");
            sb.Append(" SELECT pro.PROID,pro.PROName,pm.Panel_ID,pm.company_name  ClientName,  ");
            sb.Append(" COUNT(DISTINCT lt.LedgerTransactionNo)PatientCount,    ");
            sb.Append(" SUM(lt.GrossAmount)GrossAmt,    ");
            sb.Append(" SUM(lt.DiscountOnTotal) DiscAmt,    ");
            sb.Append(" SUM(lt.NetAmount)NetAmount,    ");
            sb.Append(" SUM(lt.Adjustment) ReceivedAmt    ");
            sb.Append(" FROM f_ledgertransaction lt    ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID  AND lt.IsCancel=0     ");
            sb.Append(" AND lt.DATE>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND lt.DATE<='" + txtToDate.GetDateForDataBase() + " 23:59:59' and lt.IsCancel=0   ");
            if (chkCenter != "")
            {
                sb.Append("  AND lt.CentreId IN (" + chkCenter + ") ");
            }
           
            if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pm.PROID=pro.PROID   ");
            sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            sb.Append(" GROUP BY pro.PROID,pm.Panel_ID   ");
            sb.Append(" UNION ALL   ");
            sb.Append(" SELECT pro.PROID,pro.PROName,pm.Panel_ID,pm.company_name ClientName,0 PatientCount,0 GrossAmt,SUM(IF(io.CreditNote=1,io.ReceivedAmt,0)) DiscAmt,0 NetAmount,SUM(IF(io.CreditNote<>1,io.ReceivedAmt,0)) ReceivedAmt      ");
            sb.Append(" FROM invoicemaster_onaccount io   ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_Id=io.Panel_ID    ");
            sb.Append(" AND io.IsCancel=0  ");
            if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pro.PROID=pm.PROID   ");
            sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            sb.Append(" WHERE io.ReceivedDate>='" + txtFromDate.GetDateForDataBase() + "'  AND io.ReceivedDate<='" + txtToDate.GetDateForDataBase() + "'  ");
            sb.Append(" GROUP BY pro.PROID,pm.Panel_ID    ");
            sb.Append(" ) t  GROUP BY PROID,Panel_ID ORDER BY PROName  ");
        }
        else if (rblReportType.SelectedValue == "Detail")
        {
            sb.Append(" SELECT pro.PROName,'' Doctor, DATE_FORMAT(lt.date,'%d-%b-%Y')DATE,");
            sb.Append(" lt.LedgertransactionNo LabNo,lt.GrossAmount,lt.DiscountOnTotal Disc,lt.NetAmount, ");
            sb.Append(" lt.Adjustment ReceivedAmt, IF(lt.AmtCredit=0,'Non-Credit','Credit') TYPE, fpm.Company_Name Panel, ");
            sb.Append(" 0 PRO_CreditLimit,pm.PName PatientName,pm.Age,pm.Gender,GROUP_CONCAT(DISTINCT ltd.ItemName)ItemsName , lt.DiscountReason   ");
            sb.Append(" from f_ledgertransaction lt ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo  "); 
            sb.Append(" AND lt.DATE>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND lt.DATE<='" + txtToDate.GetDateForDataBase() + " 23:59:59' and lt.IsCancel=0   ");
            if (chkCenter != "")
            {
                sb.Append("  AND lt.CentreId IN (" + chkCenter + ") ");
            } 
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
            if (panel != "")
            {
                sb.Append(" And lt.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID ");  
            sb.Append("inner join pro_master pro on pro.PROID=pm.PROID ");
            if (PROData != "")
            {
                sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            }
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_id=lt.Patient_id ");
            sb.Append(" GROUP BY lt.LedgertransactionNo ORDER BY pro.PROName,lt.LedgertransactionNo ");

        }
        else if (rblReportType.SelectedValue == "PerformanceII")
        {
           
			
			
			
			   
            sb.Append(@" SELECT pm.PROName,fpm.Company_Name ClientName,
 SUM(tFinal.Previous_Due) Previous_Due,SUM(tFinal.PatientCount)  PatientCount,
 ROUND(SUM(tFinal.GrossAmt))  GrossAmt,
 ROUND(SUM(tFinal.DiscAmt))  DiscAmt, 
 ROUND(SUM(tFinal.GrossAmt)-SUM(tFinal.DiscAmt),2)NetAmount,
 ROUND(SUM(tFinal.ReceivedAmt)) ReceivedAmt,
 ROUND(SUM(tFinal.Previous_Due)+ ROUND(SUM(tFinal.GrossAmt)-SUM(tFinal.DiscAmt),2)-SUM(tFinal.ReceivedAmt)) CurrentBalance
 FROM (     
 SELECT pro.PROID,pm.Panel_ID,0 Previous_Due,COUNT(DISTINCT lt.LedgerTransactionNo)PatientCount,     
 SUM(lt.GrossAmount)GrossAmt,     
 SUM(lt.DiscountOnTotal) DiscAmt,     
 SUM(lt.NetAmount)NetAmount,
 SUM(lt.Adjustment) ReceivedAmt     
 FROM f_ledgertransaction lt     
 INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID  AND lt.IsCancel=0  ");     
  sb.Append(" AND lt.DATE>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND lt.DATE<='" + txtToDate.GetDateForDataBase() + " 23:59:59' and lt.IsCancel=0   ");
            if (chkCenter != "")
            {
                sb.Append("  AND lt.CentreId IN (" + chkCenter + ") ");
            }

            if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ")");
            } 
sb.Append(" INNER JOIN pro_master pro ON pm.PROID=pro.PROID  ");  
   sb.Append(" AND pro.PROID IN (" + PROData + ") ");
 sb.Append(@" GROUP BY pro.PROID,pm.Panel_ID    
 
 UNION ALL    
 SELECT pro.PROID,pm.Panel_ID,0 Previous_Due,0 PatientCount,0 GrossAmt,SUM(IF(io.CreditNote=1,io.ReceivedAmt,0)) DiscAmt,0 NetAmount,
 SUM(IF(io.CreditNote<>1,io.ReceivedAmt,0)) ReceivedAmt       
 FROM invoicemaster_onaccount io    
 INNER JOIN f_panel_master pm ON pm.Panel_Id=io.Panel_ID    
 AND io.IsCancel=0 ");
  if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ")");
            } 
			
			sb.Append(" INNER JOIN pro_master pro ON pm.PROID=pro.PROID  ");   
			  sb.Append(" AND pro.PROID IN (" + PROData + ") ");
  sb.Append(" WHERE io.ReceivedDate>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND io.ReceivedDate<='" + txtToDate.GetDateForDataBase() + " 23:59:59'   GROUP BY pro.PROID,pm.Panel_ID  ");   
  
sb.Append(@"  UNION ALL
 SELECT pro.PROID,pm.Panel_ID,ROUND(IFNULL(IFNULL(t.NetAmount,0)+IFNULL(t6.PreviousBal,0)-IFNULL(t2.paidamt,0),0)) Previous_Due,
 0 PatientCount,0 GrossAmt,0 DiscAmt,0 NetAmount,0 ReceivedAmt
 FROM  
 f_panel_master pm 
 INNER JOIN pro_master pro ON pro.PROID=pm.PROID  ");
   sb.Append(" AND pro.PROID IN (" + PROData + ") ");  
   if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ") ");
            } 
		 sb.Append(@"LEFT JOIN  
 (SELECT  panelid ,SUM(ivcm.NetAmount) NetAmount  FROM invoicemaster ivcm ");
sb.Append(" WHERE  invoicedate<'" + txtFromDate.GetDateForDataBase() + " 00:00:00'  ");
  sb.Append(@" AND ivcm.iscancel=0 GROUP BY panelid ) t ON t.panelid=pm.panel_id  
  LEFT JOIN
 (SELECT  Panel_id,IFNULL(SUM(ivca.receivedamt),0) paidamt   
 FROM   
 invoicemaster_onaccount ivca  ");  
sb.Append(" WHERE  `ReceivedDate`<'" + txtFromDate.GetDateForDataBase() + " 00:00:00'   AND ivca.iscancel=0 AND `Type`='ON ACCOUNT' GROUP BY panel_id ) t2 ");
 sb.Append(@"  ON t2.Panel_id=pm.panel_id    
 LEFT JOIN  
 ( SELECT pnl.Panel_ID ,IFNULL(SUM(lt.`NetAmount`),0) PreviousBal    
         FROM f_ledgertransaction lt        
         INNER JOIN  f_panel_master pnl ON lt.Panel_ID=pnl.Panel_ID    WHERE lt.iscancel=0  
         AND IFNULL(lt.invoiceno,'')='' ");
		sb.Append(" AND lt.DATE<'" + txtFromDate.GetDateForDataBase() + " 00:00:00'   GROUP BY pnl.Panel_ID ");
  sb.Append(@" ) t6  ON t6.Panel_ID=pm.panel_id  
         ) tFinal 
INNER JOIN f_panel_master fpm ON fpm.Panel_Id=tFinal.Panel_Id
INNER JOIN pro_master pm ON pm.ProId=fpm.ProID
GROUP BY fpm.Panel_ID ORDER BY PROName "); 

           // System.IO.File.WriteAllText("C:\\PROII.txt", sb.ToString());

        }
        else
        {
            sb.Append(" SELECT PROID,PROName,BookingDate,SUM(t.PatientCount)  PatientCount,SUM(t.GrossAmt)  GrossAmt,SUM(t.DiscAmt)  DiscAmt, ROUND( SUM(t.GrossAmt)-SUM(t.DiscAmt),2)NetAmount,      ");
            sb.Append(" SUM(t.ReceivedAmt)  ReceivedAmt FROM (   ");
            sb.Append(" SELECT pro.PROID,pro.PROName,COUNT(lt.Transaction_ID)PatientCount,   ");
            sb.Append(" ROUND(SUM(lt.GrossAmount),0)GrossAmt,  ROUND(SUM(lt.DiscountOnTotal),0) DiscAmt,   ");
            sb.Append(" ROUND(SUM(lt.NetAmount),0) NetAmount, ROUND(SUM(lt.Adjustment),0)  ReceivedAmt, lt.date MySQLDate, ");
            sb.Append(" DATE_FORMAT(lt.DATE,'%b-%Y') BookingDate  FROM    f_ledgertransaction lt   ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID   AND lt.IsCancel=0    ");
            sb.Append(" AND lt.DATE>='" + txtFromDate.GetDateForDataBase() + " 00:00:00'  AND lt.DATE<='" + txtToDate.GetDateForDataBase() + " 23:59:59' and lt.IsCancel=0   ");
            if (chkCenter != "")
            {
                sb.Append("  AND lt.CentreId IN (" + chkCenter + ") ");
            }
            
            if (panel != "")
            {
                sb.Append(" And pm.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pro.PROID=pm.PROID   ");
            sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            sb.Append(" GROUP BY pro.PROID,DATE_FORMAT(lt.DATE,'%b-%Y')  ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT pro.PROID,pro.PROName,0 PatientCount,0 GrossAmt,SUM(IF(io.CreditNote=1,io.ReceivedAmt,0))  DiscAmt,0 NetAmount,SUM(IF(io.CreditNote<>1,io.ReceivedAmt,0))  ReceivedAmt,io.ReceivedDate MySQLDate, ");
            sb.Append(" DATE_FORMAT(io.ReceivedDate,'%b-%Y') BookingDate   ");
            sb.Append(" FROM invoicemaster_onaccount io     ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_Id=io.Panel_ID AND io.IsCancel=0 and io.Type='ON ACCOUNT' ");
            if (panel != "")
            {
                sb.Append(" and pm.panel_id in(" + panel + ")");
            }
            sb.Append(" INNER JOIN pro_master pro ON pro.PROID=pm.PROID     ");
            sb.Append(" AND pro.PROID IN (" + PROData + ") ");
            sb.Append(" WHERE io.ReceivedDate>='" + txtFromDate.GetDateForDataBase() + "'  AND io.ReceivedDate<='" + txtToDate.GetDateForDataBase() + "'  ");
            sb.Append(" GROUP BY pro.PROID ,DATE_FORMAT(io.ReceivedDate,'%b-%Y') ");
            sb.Append(" ) t GROUP BY PROID,BookingDate ");
            sb.Append(" ORDER BY PROName,MySQLDate ");


        }
        return sb.ToString();

    }
    protected void btnReport_Click(object sender, EventArgs e)
    {


        string str = SearchQuery();
        if (str == "")
        {

            return;
        }
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {

            if (rblReportFormate.SelectedValue == "PDF" && rblReportType.SelectedValue != "MonthlySummary")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "User";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + txtFromDate.GetDateForDataBase() + " To : " + txtToDate.GetDateForDataBase();
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "CentreHeader";
                dc.DefaultValue = "";// StockReports.ExecuteScalar("SELECT HeaderInfo FROM centre_master WHERE CentreID='" + Centre.Id + "'"); ;
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                if (rblReportType.SelectedValue == "Summary")
                {

                    Session["ds"] = ds;
                    // ds.WriteXmlSchema(@"D:\PROBusinessForLIS_Panel_Summary.xml");
                    Session["ReportName"] = "PROBusinessForLIS_Panel_Summary";


                }
                else if (rblReportType.SelectedValue == "Performance")
                {

                    Session["ds"] = ds;
                    // ds.WriteXmlSchema(@"D:\PROBusinessForLIS_Panel_Performance.xml");
                    Session["ReportName"] = "PROBusinessForLIS_Panel_Performance";

                }
                else
                {

                    Session["ds"] = ds;
                    //  ds.WriteXmlSchema(@"D:\PROBusinessForLIS_Panel_Detail.xml");
                    Session["ReportName"] = "PROBusinessForLIS_Panel_Detail";

                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
            }
            else
            {
                Session["ReportName"] = "PRO Business Report";
                Session["Period"] = "Period From : " + txtFromDate.GetDateForDataBase() + " To : " + txtToDate.GetDateForDataBase();
                Session["dtExport2Excel"] = dt;


                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
            }
        }

    }



    protected void rblReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rblReportType.SelectedItem.Value == "MonthlySummary")
        {
            td_rptFormate.Visible = false;
        }
        else
        {
            td_rptFormate.Visible = true;
        }
    }

    protected void chkPaymentMode_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPanel();
    }
    protected void rblPanelStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPanel();
    }
}
