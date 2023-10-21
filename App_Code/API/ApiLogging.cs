using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WebDemoAPI.Models
{
    public class ApiLogging
    {
        public void InsertLog(ApiLog apiLog)
        {
            try
            {

                using (var sqlConnection = new MySqlConnection(Util.GetConString()))
                {
                    sqlConnection.Open();
                    var cmd =
                        new MySqlCommand("INSERT IGNORE INTO `abha_api_log`(`Host`,`Headers`,`StatusCode`,`RequestBody`,`ResponseBody`,`RequestedMethod`,`UserHostAddress`,`Useragent`,`AbsoluteUri`,`RequestType`) VALUES (@Host,@Headers,@StatusCode,@RequestBody,@ResponseBody,@RequestedMethod,@UserHostAddress,@Useragent,@AbsoluteUri,@RequestType);", connection: sqlConnection)
                        {
                            CommandType = CommandType.Text
                        };
                    cmd.Parameters.AddWithValue("@Host", apiLog.Host);
                    cmd.Parameters.AddWithValue("@Headers", apiLog.Headers);
                    cmd.Parameters.AddWithValue("@StatusCode", apiLog.StatusCode);
                    cmd.Parameters.AddWithValue("@RequestBody", apiLog.RequestBody);
                    cmd.Parameters.AddWithValue("@ResponseBody", "");
                    cmd.Parameters.AddWithValue("@RequestedMethod", apiLog.RequestedMethod);
                    cmd.Parameters.AddWithValue("@UserHostAddress", apiLog.UserHostAddress);
                    cmd.Parameters.AddWithValue("@Useragent", apiLog.Useragent);
                    cmd.Parameters.AddWithValue("@AbsoluteUri", apiLog.AbsoluteUri);
                    cmd.Parameters.AddWithValue("@RequestType", apiLog.RequestType);
                    cmd.ExecuteNonQuery();
                    sqlConnection.Close();
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}