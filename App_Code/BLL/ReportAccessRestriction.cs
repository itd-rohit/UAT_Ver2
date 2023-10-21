using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Data;
using Newtonsoft.Json;

/// <summary>
/// Summary description for ReportAccessRestriction
/// </summary>
public class ReportAccessRestriction
{
    public string ReportAccess(int ReportID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        
        DataTable dtrole = new DataTable();
        DataTable dtcentre = new DataTable();
        StringBuilder sb = new StringBuilder();
        try
        {
            int globalemp = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Count(1) FROM Employee_master WHERE IsActive=1 AND GlobalReportAccess=1 and Employee_ID=@Employee_ID",
                new MySqlParameter("@Employee_ID", Util.GetInt(UserInfo.ID))));
            if (globalemp > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, responseMsg = "GlobalEmployee", ShowPdf = "-1", ShowExcel = "-1" });
            }

            sb = new StringBuilder();
            sb.Append("SELECT AccessType,DurationInDay,ShowPdf,ShowExcel,AccessTypeTo FROM report_master_access  WHERE Active=1 AND ReportID=@ReportID ");


            using (DataTable dtemp = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@ReportID", ReportID)).Tables[0])
            {

                var EmployeeRow = dtemp.AsEnumerable().Where(s => s.Field<String>("AccessType") == "Employee_ID" && s.Field<int>("AccessTypeTo") == Util.GetInt(UserInfo.ID));

                if (EmployeeRow.Count() > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        status = true,
                        responseMsg = "Authorize",
                        DurationInDay = EmployeeRow.CopyToDataTable().Rows[0]["DurationInDay"],
                        ShowPdf = EmployeeRow.CopyToDataTable().Rows[0]["ShowPdf"],
                        ShowExcel = EmployeeRow.CopyToDataTable().Rows[0]["ShowExcel"]
                            
                    });

                }
                else
                {

                    var RoleRows = dtemp.AsEnumerable().Where(s => s.Field<String>("AccessType") == "RoleId" && s.Field<int>("AccessTypeTo") == Util.GetInt(UserInfo.RoleID));
                    if (RoleRows.Count() > 0)
                    {
                        dtrole = RoleRows.CopyToDataTable();
                    }
                    var CentreRrow = dtemp.AsEnumerable().Where(s => s.Field<String>("AccessType") == "CentreId" && s.Field<int>("AccessTypeTo") == Util.GetInt(UserInfo.Centre));
                    if (CentreRrow.Count() > 0)
                    {
                        dtcentre = CentreRrow.CopyToDataTable();
                    }



                    if (dtcentre.Rows.Count > 0 && dtrole.Rows.Count > 0)
                    {
                        return JsonConvert.SerializeObject(new { status = true, responseMsg = "Authorize", DurationInDay = dtrole.Rows[0]["DurationInDay"], ShowPdf = dtrole.Rows[0]["ShowPdf"], ShowExcel = dtrole.Rows[0]["ShowExcel"] });
                    }
                    else if (dtcentre.Rows.Count > 0 && dtrole.Rows.Count == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = true, responseMsg = "Authorize", DurationInDay = dtcentre.Rows[0]["DurationInDay"], ShowPdf = dtcentre.Rows[0]["ShowPdf"], ShowExcel = dtcentre.Rows[0]["ShowExcel"] });
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, responseMsg = "UnAuthorize" });
                    }

                }
            }
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, responseMsg = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}