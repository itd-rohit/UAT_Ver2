using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_InvalidContactNo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string contactDetail()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,ContactNo,if(IsActive=1,'Active','DeActive')Status,IsActive FROM ContactNo_Invalid_master"))
        {
            return JsonConvert.SerializeObject(new { status = true, response = "", responseDetail = Util.getJson(dt) });
        }
    }
    public static string bindContactDetail(MySqlTransaction tnx,string message)
    {
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT ID,ContactNo,if(IsActive=1,'Active','DeActive')Status,IsActive FROM ContactNo_Invalid_master WHERE IsActive=1").Tables[0])
            {
                List<string> ConData = new List<string>();
                ConData.Add("var invalidContact = new Array()");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    ConData.Add(string.Concat("invalidContact.push(", '"', dt.Rows[i]["ContactNo"].ToString(), '"', ")"));
                }
                File.WriteAllText(HttpContext.Current.Server.MapPath("~/Scripts/InvalidContactNo.js"), string.Concat(string.Concat(string.Join(";", ConData.ToArray()), ";")));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = message, responseDetail = Util.getJson(dt) });
               
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveContactNo(string ContactNo, string typeData, string ID, string StatusID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (typeData.ToUpper() == "SAVE")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM ContactNo_Invalid_master WHERE ContactNo=@ContactNo",
                    new MySqlParameter("@ContactNo", ContactNo)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "ContactNo already exits" });
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO ContactNo_Invalid_master(ContactNo,CreatedByID,CreatedBy,IsActive)VALUES(@ContactNo,@CreatedByID,@CreatedBy,@StatusID)",
                       new MySqlParameter("@ContactNo", ContactNo),
                       new MySqlParameter("@IsActive", StatusID),
                       new MySqlParameter("@CreatedByID", UserInfo.ID),
                       new MySqlParameter("@CreatedBy", UserInfo.LoginName));

                   return bindContactDetail(tnx, "Record Saved Successfully");
                    
                }
            }
            else
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM ContactNo_Invalid_master WHERE ContactNo=@ContactNo AND ID!=@ID",
                   new MySqlParameter("@ContactNo", ContactNo), new MySqlParameter("@ID", ID)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "ContactNo already exits" });
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE ContactNo_Invalid_master SET ContactNo=@ContactNo,IsActive=@IsActive WHERE ID=@ID ",
                       new MySqlParameter("@ContactNo", ContactNo), new MySqlParameter("@IsActive", StatusID),
                       new MySqlParameter("@ID", ID));

                    return bindContactDetail(tnx, "Record Updated Successfully");
                }
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}