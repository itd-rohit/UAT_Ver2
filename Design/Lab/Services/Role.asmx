<%@ WebService Language="C#" Class="Role" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class Role : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    public string changecentre(string centreid, string centrename)
    {
        Session["Centre"] = centreid;
        Session["CentreName"] = centrename;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string CentreType = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(Type1,'#',IsInvoice)CentreType FROM centre_master cm INNER JOIN f_Panel_master pm ON cm.CentreID=pm.CentreID WHERE cm.CentreID=@CentreID AND pm.PanelType='Centre' ",
                      new MySql.Data.MySqlClient.MySqlParameter("@CentreID", centreid)));
            Session["CentreType"] = CentreType.Split('#')[0];
            Session["IsInvoice"] = CentreType.Split('#')[1];
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string setrole(string roleid, string rolename)
    {
        string status = "";

        try
        {
            if (rolename.ToLower() == "logout")
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_login_detail ld INNER JOIN (SELECT MAX(ID)ID, EmployeeID,CentreID FROM f_login_detail WHERE IFNULL(LogOutTime,'')='' AND " +
                         " Employeeid ='" + UserInfo.ID + "' and CentreID=" + UserInfo.Centre + " GROUP BY  EmployeeID,CentreID ) ld2 ON ld.ID=ld2.ID SET ld.LogOutTime =NOW() ");

                    con.Close();
                    con.Dispose();
                }
                Session.RemoveAll();
                Session.Abandon();
                status = "logout";
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("select fl.EmployeeID,fl.UserName,em.name EmpName,'' Hospital_ID,fl.RoleID ");
                sb.Append(" from f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append("  where fl.Active = 1 and em.IsActive=1 and fl.RoleID = '" + roleid + "' and fl.EmployeeId = '" + UserInfo.ID + "' and fl.CentreID=" + UserInfo.Centre + " ");

                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(sb.ToString());

                if (dt.Rows.Count > 0)
                {
                    if (Util.GetString(dt.Rows[0]["UserName"]) == "ITDOSE")
                        Session["Ownership"] = "Public";
                    else
                        Session["Ownership"] = "Private";

                    Session["LoginType"] = rolename;
                    Session["UserName"] = Util.GetString(dt.Rows[0]["UserName"]);
                    Session["ID"] = Util.GetString(dt.Rows[0]["EmployeeID"]);
                    Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                    Session["HOSPID"] = Util.GetString(dt.Rows[0]["Hospital_ID"]);
                    Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);



                    dt = new DataTable();
                    dt = StockReports.GetDataTable("Select DeptLedgerNo,IsStore from f_role_dept where RoleID ='" + UserInfo.RoleID + "' ");

                    if (dt != null && dt.Rows.Count > 0)
                    {

                        Session["DeptLedgerNo"] = dt.Rows[0]["DeptLedgerNo"].ToString();
                        Session["IsStore"] = dt.Rows[0]["IsStore"].ToString();
                    }

                    Session["PrintLabReport"] = StockReports.ExecuteScalar("select PrintFlag from f_rolemaster where ID='" + UserInfo.RoleID + "' limit 1 ");

                }
                status = rolename;
            }
        }
        catch
        {
            status = "logout";
        }
        return status;

    }



}