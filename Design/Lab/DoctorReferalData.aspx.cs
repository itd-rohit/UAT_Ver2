using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_BillChargeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select CentreId,Centre FROM Centre_MAster where IsActive=1 Order By Centre  ");
       // sb.Append(" WHERE  cm.IsActive=1  AND fpm.IsPermanentClose=0  ");

        //if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        //{

        //}
        //else
        //{
        //    sb.Append("  AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='" + UserInfo.Centre + "' ) OR cm.CentreID ='" + UserInfo.Centre + "' )  ");

        //}
        //sb.Append(" Order By fpm.Company_Name");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                return Util.getJson(dt);
            }
            else
            {
                return null;
            }
        }
    }
    [WebMethod(EnableSession = true)]
    public static string exportReport(DateTime FromDate, DateTime ToDate, string PanelID)
    {
        DataTable dt = Search(FromDate, ToDate, PanelID);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "ReferalDoctorData";
            HttpContext.Current.Session["Period"] = "From : " + FromDate.ToString("dd-MMM-yyyy") + " To : " + ToDate.ToString("dd-MMM-yyyy");
            return "1";
        }
        else
        {
            return "0";
        }
    }

    public static DataTable Search(DateTime FromDate, DateTime ToDate, string PanelID)
    {



        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT dr.Doctor_Id,dr.DoctorCode,Concat(dr.Title,'',dr.Name) Name,dr.Gender,dr.Email,dr.IMARegistartionNo,dr.RegistrationOf,dr.RegistrationYear,dr.ProfesionalSummary,dr.Designation,dr.Phone1,dr.Phone2,dr.Phone3,dr.Mobile,dr.House_No,dr.Street_Name,dr.Locality,dr.State,dr.City,dr.Degree,dr.Specialization ,GROUP_CONCAT(Cm.centre) MappedCentre  FROM `doctor_referal` dr ");
        sb.Append(" LEFT JOIN `doctor_referal_centre`  drc ON drc.doctor_Id=dr.doctor_Id ");
        sb.Append("  INNER JOIN  centre_Master cm ON CM.centreId=drc.centreId ");
        sb.Append("  WHERE dr.IsActive=1 GROUP BY dr.Doctor_Id ORDER BY dr.name ");
        if (PanelID != "0")
            sb.Append(" AND cm.`CentreId` IN (" + PanelID + ") ");


        //sb.Append("  Select Date_Format(lt.Date,'%d-%b-%Y') OpenDate, lt.`BillNo` as BillNo,lt.`PName` PatientName, ");
        //sb.Append(" IF(lt.`Doctor_ID`='2',lt.`OtherDoctorName`,IF(lt.Doctor_ID=1,dr.Name,CONCAT(dr.Title,' ',dr.Name)))Referar, ");
        //sb.Append(" sm.Name as ServiceSubGroup,IF(plo.ispackage=1,plo.PackageName,plo.InvestigationName) ItemDescription,lt.`PanelName` as RatePlan,plo.`Rate` Amount ,plo.Amount NetAmount,plo.`DiscountAmt` ");
        //sb.Append(" ,IF(lt.NetAmount <> lt.Adjustment,'Unpaid','Paid') PaymentStatus ");
        //sb.Append(" FROM f_Ledgertransaction lt INNER JOIN Patient_Labinvestigation_OPD plo on lt.`LedgerTransactionID`=plo.ledgertransactionId ");
        //sb.Append(" INNER join doctor_referal dr on lt.`Doctor_ID`=dr.`Doctor_ID` ");
        //sb.Append(" INNER join f_subcategorymaster sm ON plo.`SubCategoryID`=sm.`SubCategoryID` WHERE lt.`IsCancel`=0 AND  IF(plo.isPackage=1,plo.SubCategoryID=15,plo.SubCategoryID!=15) ");

        //if (PanelID != "0")
        //    sb.Append(" AND lt.`Panel_id` IN (" + PanelID + ") ");

        //sb.Append(" AND lt.DATE >= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00" + "' AND  lt.DATE <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59" + "' ");
        //sb.Append(" ORDER BY lt.PanelName,lt.Date ");


        DataTable dtData = StockReports.GetDataTable(sb.ToString());


        return dtData;

    }



}