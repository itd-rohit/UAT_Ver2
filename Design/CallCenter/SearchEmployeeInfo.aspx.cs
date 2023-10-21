using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_SearchEmployeeInfo : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string SearchReceiptData(object query)
    {
        List<SearchData> datatDetail = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<SearchData>>(query);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append("SELECT ed.id as SNo, ed.`EmployeeName`,ed.EmployeeCode,ed.`MobileNo`,ed.emailid,ed.`ExtensionNo`,IFNULL(ed.Designation,'')Designation,IFNULL(c.`Centre`,'')Centre FROM EmployeeDetails ed ");//,d.name AS Designation,c.`Centre` ,e.`Name` AS EntryBy,ed.`EntryDate`
            sb.Append(" Left JOIN Centre_Master c ON C.`CentreCode`=ed.`CentreCode` ");
            sb.Append(" INNER JOIN employee_Master e ON e.`Employee_ID`=ed.EntryById ");
            sb.Append(" where ed.IsActive=1   ");
            if (Util.GetString(datatDetail[0].SearchType) != "All")
            {                
                    sb.Append(" AND  " + Util.GetString(datatDetail[0].SearchType) + " LIKE  @SearchType");              
            }
            else
            {
                if (datatDetail[0].SearchValue != "")
                {
                    sb.Append(" AND  ed.EmployeeName LIKE  @SearchType");
                }
            }
            if (Util.GetString(datatDetail[0].CentreID) != "0")
            {
                sb.Append(" AND  ed.centreid=@centre ");
            }
            sb.Append(" order  BY ed.employeeName ASC ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@SearchType", "%" + datatDetail[0].SearchValue + "%"),
               new MySqlParameter("@centre", Util.GetInt(datatDetail[0].CentreID))).Tables[0])

                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class SearchData
    {
        public string SearchType { get; set; }
        public string SearchValue { get; set; }
        public string CentreID { get; set; }

    }
}