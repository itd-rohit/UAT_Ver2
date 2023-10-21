using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_RevertDiscountApprovalStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string LedgertransactionNo)
    {
        string str = "SELECT PName,DATE_FORMAT(DATE,'%d-%b-%Y %h:%i %p') DATE,LedgertransactionNo,LedgertransactionId,DiscountApprovedByName,NetAmount,DiscountOnTotal, IF(DiscountApprovedByName='','NoDiscount','Discount') STATUS,IsDiscountApproved,IF(IsDiscountApproved='1','Approved','Pending') DiscountStatus FROM f_Ledgertransaction WHERE LedgertransactionNo='" + LedgertransactionNo + "' ";
        using (DataTable dt = StockReports.GetDataTable(str))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateStatus(string LedgertransactionId)
                                             
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    string str = "Update f_ledgertransaction SET IsDiscountApproved=0  WHERE LedgertransactionId='" + LedgertransactionId + "'";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO RevertDiscountStatus_log (LedgertransactionId,UserId) VALUES(@LedgertransactionId,@UserId)",
                       new MySqlParameter("@LedgertransactionId",LedgertransactionId),
                       new MySqlParameter("@UserId",UserInfo.ID)
                        );

                    Tnx.Commit();
                    con.Close();
                    return "1";
                }
                catch {
                    Tnx.Rollback();
                    con.Close();
                    return "0";
                }
            }
        }
    }
   

}