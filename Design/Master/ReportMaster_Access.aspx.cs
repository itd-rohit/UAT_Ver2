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

public partial class Design_Master_ReportMaster_Access : System.Web.UI.Page
{
    public string ReportID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ReportID = Request.QueryString["ReportID"].ToString();
            lblReportname.Text = Request.QueryString["ReportName"].ToString();           
        }
    }   
    [WebMethod]
    public static string SaveReportAccess(List<ReportAccess> ReportDetail, int ReportID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from Report_master_access where ReportID=@ReportID ",
                 new MySqlParameter("@ReportID", ReportID));


            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT into Report_master_access (ReportID,  AccessType , AccessTypeto ,DurationInDay,ShowPdf,ShowExcel, EntryBy,  EntryByName,Active)");
            sb.Append(" VALUES (@ReportID,  @AccessType,  @AccessTypeto,@DurationInDay,@ShowPdf,@ShowExcel,  @EntryBy,  @EntryByName,@Active) ");
            foreach (ReportAccess item in ReportDetail)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@ReportID", item.ReportID),
                  new MySqlParameter("@AccessType", item.AccessType),
                  new MySqlParameter("@AccessTypeto", item.AccessTypeto),
                   new MySqlParameter("@DurationInDay", item.DurationInDay),
                    new MySqlParameter("@ShowPdf", item.ShowPdf),
                     new MySqlParameter("@ShowExcel", item.ShowExcel),                      
                  new MySqlParameter("@EntryBy", UserInfo.ID),
                  new MySqlParameter("@EntryByName", UserInfo.LoginName),
                  new MySqlParameter("@Active", item.Active));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string getReportAccessDetails(string ReportID, string accessType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            if (accessType == "Employee_ID")
            {
                sb.Append(@" SELECT rma.AccessTypeto Employee_ID, Concat(em.Title,'',em.Name) `Name`,rma.DurationInDay,rma.ShowPdf,rma.ShowExcel,rma.Active FROM Report_master_access rma 
                            INNER join employee_master em on rma.AccessTypeto=em.Employee_ID AND rma.ReportID=@ReportID AND rma.AccessType=@AccessType ");
            }
            else if (accessType == "CentreId")
            {
                sb.Append(@" SELECT cm.CentreID, cm.Centre `Name`,rma.DurationInDay,rma.ShowPdf,rma.ShowExcel,rma.Active FROM centre_master cm 
                            left join  Report_master_access rma  on rma.AccessTypeto=cm.CentreID AND rma.ReportID=@ReportID AND rma.AccessType=@AccessType where cm.IsActive=1 order by rma.Active desc, Name ");
            }
            else if (accessType == "RoleId")
            {
                sb.Append(@" SELECT rm.ID RoleID, rm.RoleName `Name`,rma.DurationInDay,rma.ShowPdf,rma.ShowExcel,rma.Active FROM f_rolemaster rm 
                            left join  Report_master_access rma  on rma.AccessTypeto=rm.ID AND rma.ReportID=@ReportID AND rma.AccessType=@AccessType where rm.Active=1 order by rma.Active desc, Name");
            }
            //else
            //{
            //    sb.Append(" SELECT Group_Concat(AccessTypeto) AccessTypeto,DurationInDay,ShowPdf,ShowExcel,rma.Active FROM Report_master_access WHERE ReportID=@ReportID AND AccessType=@AccessType  group by AccessType");
            //}

            DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ReportID", ReportID),
                new MySqlParameter("@AccessType", accessType)
               ).Tables[0];
            con.Close();
            con.Dispose();
            if (dtSearch.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, data = dtSearch });

            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();
            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }

    }      

    public class ReportAccess
    {
        public int ReportID { get; set; }
        public string AccessType { get; set; }
        public int AccessTypeto { get; set; }
        public int DurationInDay { get; set; }
        public int ShowPdf { get; set; }
        public int ShowExcel { get; set; }
        public int Active { get; set; }
    }
}