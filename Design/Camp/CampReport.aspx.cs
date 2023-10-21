using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Camp_CampReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            lblView.Text = Common.Encrypt("1");

            
        }
    }
   
    [WebMethod]
    public static string SearchCampRequest(string fromDate, string toDate, int searchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cr.ID, fpm.Panel_Code,fpm.Company_Name, cr.CampName,DATE_FORMAT(cr.StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(cr.EndDate,'%d-%b-%Y')EndDate,");
            sb.Append(" cr.CreatedBy,DATE_FORMAT(cr.CreatedDate,'%d-%b-%Y')CreatedDate,DATE_FORMAT(cr.ApprovedDate,'%d-%b-%Y')ApprovedDate,cr.IsActive,cr.IsApproved,cr.IsCreated,cr.CampType");
            sb.Append(" , fpm.`State`,fpm.`City`,fpm.`Locality` ");
            sb.Append(" FROM camp_request cr");
            sb.Append(" INNER JOIN f_Panel_master fpm on cr.Panel_ID=fpm.Panel_ID ");
            sb.Append(" WHERE cr.CreatedDate>=@FromDate AND cr.CreatedDate<=@ToDate  AND cr.IsApproved=1 ");
           
          
           
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),                
                                            new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (searchType == 0)
                {

                    return Util.getJson(dt);
                }

                else {

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Camp Report";
                    return Util.getJson(dt);

                }
            }




        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
   
}