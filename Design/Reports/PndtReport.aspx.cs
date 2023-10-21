using System;
using System.Data;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.IO;

public partial class Reports_Forms_PndtReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SET @rownr=0; SELECT (@rownr := @rownr + 1) AS SNo, pm.pname 'Patient Name',pm.age Age,CONCAT(IFNULL(pm.Gender,''))Gender, lt.Children 'No. of Children',lt.Son, ");
        sb.Append(" CONCAT(IFNULL(pm.House_no,''),' ',IFNULL(pm.Street_Name,''),' ',' ',IFNULL(pm.City,''), ' ', ");
        sb.Append(" ' ',IFNULL(pm.Phone,''),' ', IFNULL(pm.Mobile,''))  `Full Address with telephone No. if any`, ");
        sb.Append(" CONCAT(IFNULL(dr.House_no,''),' ',IFNULL(dr.Street_Name,''),' ',IFNULL(dr.Locality,''),' ',  IFNULL(dr.City,''),IFNULL(dr.State,''),' ', ");
        sb.Append(" IFNULL(dr.StateRegion,''),' ',IFNULL(dr.CountryRegion,''),' ', IFNULL(dr.Pincode,''))  `Reffered by full Name address of Doctor/GCC/Self referral`, ");
        sb.Append(" CONCAT(dr.Name,' ',dr.Street_Name)doctor,DATE_FORMAT(lt.`Pregnancydate`,'%d-%b-%Y')Pregnancydate,lt.AgeSon,lt.Daughter,lt.AgeDaughter,(pd.Name)PNDTDoctor,'N/A' `History of genetic/medical disease in the family  `, ");
        sb.Append(" 'N/A' `Previous children with`,''`Advanced maternal age (35 years)` ,'N/A' `Last Menstrual period/Wks of Pregnancy History of genetic/medical disease in the family`, ");
        sb.Append(" 'N/A' `procedures carried out	Any complication test of procedure (specify)`,'N/A' `Laboratery test recomended`, ");
        sb.Append(" 'N/A'	`Pre-natal diagnostic procedures`,'N/A'	`Ultrasonography Normal / Abnormal`,DATE_FORMAT(lt.Date,'%Y-%m %d') AS `Date on which procedure carried out`, ");
        sb.Append(" DATE_FORMAT(lt.Date,'%Y-%m %d') AS `Date on which Consent obtained`,'N/A'	`The result of pre-natal diagnostic procedure where conveyed to	Was MTP advised Conducted`, ");
        sb.Append(" 'N/A'	`Date of Which MTP carried out` FROM  `f_ledgertransaction` lt   ");
        sb.Append(" INNER JOIN patient_master pm   ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sb.Append(" INNER JOIN doctor_referal dr  ON dr.Doctor_ID = lt.`Doctor_ID`  ");
        sb.Append(" INNER JOIN pndt_doctor pd ON pd.id=lt.PndtDoctorId  ");
        sb.Append("    Where DATE(lt.Date)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append("    AND DATE(lt.Date)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' AND pm.Gender = 'Female' ");//Condition by Harish

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "PNDT Report";
            Response.Redirect("../../Design/common/ExportToExcel.aspx");
        }
        else
        {
            lblMsg.Text = "No Record Found..!";
        }
    }
}