using Microsoft.AspNet.SignalR;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
public class NotificationHub : Hub
{


    public void BroadCastMessage(string RoleID, string UserID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " CALL NotificationDetail_New(@RoleID,@UserID) ",
                  new MySqlParameter("@RoleID", RoleID),
                  new MySqlParameter("@UserID", UserID)
                  ).Tables[0])
            {
                //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", JsonConvert.SerializeObject(dt));
                Clients.All.receiveMessage(JsonConvert.SerializeObject(dt));

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
