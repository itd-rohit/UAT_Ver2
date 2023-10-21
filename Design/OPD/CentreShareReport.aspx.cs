using System;
using System.Data;
using System.Collections.Generic;
using System.IO;
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
using System.Web.Services;
using System.Web.Script.Services;


public partial class Design_OPD_CentreShareReport : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate1.SetCurrentDate();
            ucToDate1.SetCurrentDate();
            BindDepartment();
            //  BindPanel();
            BusinessUnit();
          //  btnExport.Visible = false;
            // btnpdf.Visible = false;
        }

    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("  SELECT SubCategoryID,NAME FROM `f_subcategorymaster` WHERE active='1'  ");
       // sb.AppendLine("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
       // sb.AppendLine(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");

       // //if (AllGlobalFunction.IsWorkstation.ToUpper() == "Y")
       // //{
       //     sb.AppendLine(" inner join f_investigation_role cr on cr.Investigation_Id = im.Investigation_Id   and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "'    ");
       // //}
       // //else
       // //{
       //    // sb.AppendLine(" inner join f_categoryrole cr on cr.ObservationType_ID = ot.ObservationType_ID  and cr.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "'    ");
       //// }
       // sb.AppendLine(" order by ot.Name");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            chkDepartment.DataSource = dt;
            chkDepartment.DataTextField = "NAME";
            chkDepartment.DataValueField = "SubCategoryID";
            chkDepartment.DataBind();
        }
    }
    protected void BusinessUnit()
    {
        string sql = " SELECT CentreId,concat(Centre,' [',CentreID,']') Centre FROM centre_master WHERE  isactive=1 AND Type1ID ='6' ORDER BY CentreID  ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt.Rows.Count > 0)
        {
            cblTestCentre.DataSource = dt;
            cblTestCentre.DataTextField = "Centre";
            cblTestCentre.DataValueField = "CentreId";
            cblTestCentre.DataBind();
        }
        // sql = " SELECT CentreId,concat(Centre,' [',CentreID,']') Centre FROM centre_master WHERE  isactive=1 order by Centre  ";
        //  dt = StockReports.GetDataTable(sql);
        dt = StockReports.GetDataTable(Util.GetCentreAccessQuery());
        if (dt.Rows.Count > 0)
        {
            cblBooingCentre.DataSource = dt;
            cblBooingCentre.DataTextField = "Centre";
            cblBooingCentre.DataValueField = "CentreId";
            cblBooingCentre.DataBind();
        }
    }
    protected void btnonscreen_Click(object sender, EventArgs e)
    {
        string mainreporttype = rdbtesttype.SelectedItem.Value;
        string reporttype = RadioButtonList1.SelectedItem.Value;
        string displaytype = "OnScreen";
        Detailwise(displaytype);
        //   btnExport.Visible = true;
    }
    protected void Detailwise(string displaytype)
    {
        lblMsg.Text = "";
        string reporttype = RadioButtonList1.SelectedItem.Value;
        string mainreporttype = rdbtesttype.SelectedItem.Value;
        string Department = StockReports.GetSelection(chkDepartment);
        string BookingCentre = StockReports.GetSelection(cblBooingCentre);
        string TestCentre = StockReports.GetSelection(cblTestCentre);
        StringBuilder sb = new StringBuilder();
        if (reporttype == "0" || reporttype == "1")
        {
            sb.AppendLine(" SELECT BookingCentre,SUM(Rate) GrossAmount,SUM(IFNULL(`SHARE`,0)) SHARE,SUM(Amount) NetAmount FROM (");
        }
        sb.AppendLine(" SELECT cm.`Centre` BookingCentre,cm1.`Centre` TestCentre,");
        sb.AppendLine(" DATE_FORMAT(lt.date,'%d-%b-%Y') RegistrationDate,");
        sb.AppendLine(" DATE_FORMAT(plo.`ApprovedDate`,'%d-%b-%Y %I:%i %p') ApproveDate,plo.ApprovedName ApprovedBy , ");
       // sb.AppendLine(" (SELECT em.Name  FROM employee_master em where plo.ApprovedDoneBy=em.`Employee_ID`  ) ApprovedBy , ");
        sb.AppendLine(" DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultDate,");
        sb.AppendLine(" IFNULL(plo.`ResultEnteredName`,'') ResultDoneBy,");
        sb.AppendLine(" plo.ResultDone_IpAddress IpAddress, ");
        sb.AppendLine(" plo.Machinename, ");
        //  sb.AppendLine(" DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultDate,");
        sb.AppendLine(" plo.LedgerTransactionNo LabNo,plo.`BarcodeNo`,lt.`PName`,CONCAT(lt.age,'/',lt.`Gender`) Age_Gender,");
        sb.AppendLine(" lt.panelname PanelName,plo.packagename PackageName,IF(plo.`IsPackage`=1,plo.Rate*plo.quantity,'') PackageAmount,");
        sb.AppendLine(" plo.ItemID,plo.itemcode TestCode,");
        sb.AppendLine(" plo.`itemname` TestName,IF(plo.`IsPackage`=1,0,plo.`Rate`*plo.quantity) Rate,");
        sb.AppendLine(" IF(plo.`IsPackage`=1,0,plo.Amount) Amount,");
        sb.AppendLine(" IF(fcm.AmountShare<>0,ROUND((IF(plo.`IsPackage`=1,0,plo.`Rate`*plo.quantity)*fcm.PerShare*0.01),2),fcm.AmountShare) `Share`,plo.mrp StandardRate,");
        sb.AppendLine(" CASE WHEN  plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=1 THEN 'Out-Source' ");
        sb.AppendLine(" WHEN  plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=0 THEN 'Out-House' ELSE 'In-House' END TestType  ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
        sb.AppendLine(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_id ");
        //sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` ");//and lt.IsCancel=0
		sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionid`=plo.`LedgerTransactionid` and isreporting=1  ");//and lt.IsCancel=0
        if (BookingCentre != "" && BookingCentre != "ALL")
        {
            sb.AppendLine(" and plo.`CentreID` in (" + BookingCentre + ") ");
        }
        if (TestCentre != "" && TestCentre != "ALL")
        {
            sb.AppendLine(" and plo.`TestCentreID` in (" + TestCentre + ") ");
        }

        if (mainreporttype == "OutSource")
        {
            sb.AppendLine(" and plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=1 ");
        }
        else if (mainreporttype == "OutHouse")
        {
            sb.AppendLine(" and plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=0 ");
        }
        else if (mainreporttype == "InHouse")
        {
            sb.AppendLine(" and plo.TestCentreID=plo.CentreID ");
        }
        sb.AppendLine(" INNER JOIN centre_master cm ON cm.`CentreID`=plo.`CentreID`");
        sb.AppendLine(" INNER JOIN centre_master cm1 ON cm1.`CentreID`=plo.`TestCentreID`");
       // sb.AppendLine(" INNER JOIN f_ledgertnxdetail ltd ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND ltd.`ItemID`=plo.`ItemId`");
       // sb.AppendLine(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID`");
       // sb.AppendLine(" INNER JOIN f_itemmaster im ON plo.`Investigation_ID`=im.`Type_ID` ");
       // sb.AppendLine(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'");
        if (Department != "" && Department != "ALL")
        {
            sb.AppendLine(" and plo.`SubCategoryID` in (" + Department + ") ");
        }
        sb.AppendLine(" LEFT JOIN centre_master_sharing fcm ON fcm.`CentreID`=plo.`CentreID` AND fcm.ItemID=plo.ItemID");
       // sb.AppendLine(" LEFT JOIN f_ratelist r1 ON r1.`ItemID`=plo.`ItemID` AND r1.`Panel_ID`=78 ");
        sb.AppendLine(" WHERE lt.date >='" + ucFromDate1.GetDateForDataBase() + " 00:00:00' and lt.date <='" + ucToDate1.GetDateForDataBase() + " 23:59:59' order by lt.date  ");

        if (reporttype == "0" || reporttype == "1")
        {
            sb.AppendLine(" )a GROUP BY a.BookingCentre");
        }
        if (reporttype == "1")
        {
            sb.AppendLine(" ,a.RegistrationDate");
        }
        System.IO.File.WriteAllText("C:\\CentreShearreport01.txt", sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            lblMsg.Text = "Total " + dt.Rows.Count + " Record's Found...!!!";
            grd.DataSource = dt;
            grd.DataBind();
        }
        else
        {
            lblMsg.Text = "No Record Found..!!!";
            grd.DataSource = null;
            grd.DataBind();
        }

    }
    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        grd.DataSource = null;
        grd.DataBind();
       // btnExport.Visible = false;
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string reporttype = RadioButtonList1.SelectedItem.Value;
        string mainreporttype = rdbtesttype.SelectedItem.Value;
        string Department = StockReports.GetSelection(chkDepartment);
        string BookingCentre = StockReports.GetSelection(cblBooingCentre);
        string TestCentre = StockReports.GetSelection(cblTestCentre);
        StringBuilder sb = new StringBuilder();
        if (reporttype == "0" || reporttype == "1")
        {
            sb.AppendLine(" SELECT BookingCentre,SUM(Rate) GrossAmount,SUM(IFNULL(`SHARE`,0)) SHARE,SUM(Amount) NetAmount FROM (");
        }
        sb.AppendLine(" SELECT cm.`Centre` BookingCentre,cm1.`Centre` TestCentre,");
        sb.AppendLine(" DATE_FORMAT(lt.date,'%d-%b-%Y') RegistrationDate,");
        sb.AppendLine(" DATE_FORMAT(plo.`ApprovedDate`,'%d-%b-%Y %I:%i %p') ApproveDate,plo.ApprovedName ApprovedBy , ");
       // sb.AppendLine(" (SELECT em.Name  FROM employee_master em where plo.ApprovedDoneBy=em.`Employee_ID`  ) ApprovedBy , ");
        sb.AppendLine(" DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultDate,");
        sb.AppendLine(" IFNULL(plo.`ResultEnteredName`,'') ResultDoneBy,");
        sb.AppendLine(" plo.ResultDone_IpAddress IpAddress, ");
        sb.AppendLine(" plo.Machinename, ");
        //  sb.AppendLine(" DATE_FORMAT(plo.`ResultEnteredDate`,'%d-%b-%Y %I:%i %p') ResultDate,");
        sb.AppendLine(" plo.LedgerTransactionNo LabNo,plo.`BarcodeNo`,lt.`PName`,CONCAT(lt.age,'/',lt.`Gender`) Age_Gender,");
        sb.AppendLine(" lt.panelname PanelName,plo.packagename PackageName,IF(plo.`IsPackage`=1,plo.Rate*plo.quantity,'') PackageAmount,");
        sb.AppendLine(" plo.ItemID,plo.itemcode TestCode,");
        sb.AppendLine(" plo.`itemname` TestName,IF(plo.`IsPackage`=1,0,plo.`Rate`*plo.quantity) Rate,");
        sb.AppendLine(" IF(plo.`IsPackage`=1,0,plo.Amount) Amount,");
        sb.AppendLine(" IF(fcm.AmountShare<>0,ROUND((IF(plo.`IsPackage`=1,0,plo.`Rate`*plo.quantity)*fcm.PerShare*0.01),2),fcm.AmountShare) `Share`,plo.mrp StandardRate,");
        sb.AppendLine(" CASE WHEN  plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=1 THEN 'Out-Source' ");
        sb.AppendLine(" WHEN  plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=0 THEN 'Out-House' ELSE 'In-House' END TestType  ");
        sb.AppendLine(" FROM f_ledgertransaction lt ");
        sb.AppendLine(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_id ");
        //sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo` ");//and lt.IsCancel=0
		sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionid`=plo.`LedgerTransactionid` and isreporting=1  ");//and lt.IsCancel=0
        if (BookingCentre != "" && BookingCentre != "ALL")
        {
            sb.AppendLine(" and plo.`CentreID` in (" + BookingCentre + ") ");
        }
        if (TestCentre != "" && TestCentre != "ALL")
        {
            sb.AppendLine(" and plo.`TestCentreID` in (" + TestCentre + ") ");
        }

        if (mainreporttype == "OutSource")
        {
            sb.AppendLine(" and plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=1 ");
        }
        else if (mainreporttype == "OutHouse")
        {
            sb.AppendLine(" and plo.TestCentreID<>plo.CentreID AND plo.IsLabOutSource=0 ");
        }
        else if (mainreporttype == "InHouse")
        {
            sb.AppendLine(" and plo.TestCentreID=plo.CentreID ");
        }
        sb.AppendLine(" INNER JOIN centre_master cm ON cm.`CentreID`=plo.`CentreID`");
        sb.AppendLine(" INNER JOIN centre_master cm1 ON cm1.`CentreID`=plo.`TestCentreID`");
       // sb.AppendLine(" INNER JOIN f_ledgertnxdetail ltd ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` AND ltd.`ItemID`=plo.`ItemId`");
       // sb.AppendLine(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID`");
       // sb.AppendLine(" INNER JOIN f_itemmaster im ON plo.`Investigation_ID`=im.`Type_ID` ");
       // sb.AppendLine(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'");
        if (Department != "" && Department != "ALL")
        {
            sb.AppendLine(" and plo.`SubCategoryID` in (" + Department + ") ");
        }
        sb.AppendLine(" LEFT JOIN centre_master_sharing fcm ON fcm.`CentreID`=plo.`CentreID` AND fcm.ItemID=plo.ItemID");
       // sb.AppendLine(" LEFT JOIN f_ratelist r1 ON r1.`ItemID`=plo.`ItemID` AND r1.`Panel_ID`=78 ");
        sb.AppendLine(" WHERE lt.date >='" + ucFromDate1.GetDateForDataBase() + " 00:00:00' and lt.date <='" + ucToDate1.GetDateForDataBase() + " 23:59:59' order by lt.date  ");

        if (reporttype == "0" || reporttype == "1")
        {
            sb.AppendLine(" )a GROUP BY a.BookingCentre");
        }
        if (reporttype == "1")
        {
            sb.AppendLine(" ,a.RegistrationDate");
        }
       // System.IO.File.WriteAllText("C:\\CentreShearreport011.txt", sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Centre_Share_Report .xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/vnd.ms-excel";
            string tab = "";
            foreach (DataColumn dc in dt.Columns)
            {
                Response.Write(tab + dc.ColumnName);
                tab = "\t";
            }
            Response.Write("\n");
            int i;
            foreach (DataRow dr in dt.Rows)
            {
                tab = "";
                for (i = 0; i < dt.Columns.Count; i++)
                {
                    Response.Write(tab + dr[i].ToString());
                    tab = "\t";
                }
                Response.Write("\n");
            }
            Response.End();
        }
        else
        {
            lblMsg.Text = "No Data To Export..!";
            return;
        }

      
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
    }
}





