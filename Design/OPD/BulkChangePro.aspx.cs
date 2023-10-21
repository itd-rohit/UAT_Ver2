using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_BulkChangePro : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }



            string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";

            DataTable dt = StockReports.GetDataTable(str);
            ddlCentreAccess.DataSource = dt;
            ddlCentreAccess.DataTextField = "Centre";
            ddlCentreAccess.DataValueField = "CentreID";
            ddlCentreAccess.DataBind();
            ddlCentreAccess.Items.Insert(0, "Centre");

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT proID,CONCAT(Title,ProName) proName FROM pro_master WHERE isActive=1 ");
            DataTable dtPro = StockReports.GetDataTable(sb.ToString());
            if (dtPro != null && dtPro.Rows.Count > 0)
            {
                ddlSourceProMaster.DataSource = dtPro;
                ddlSourceProMaster.DataTextField = "proName";
                ddlSourceProMaster.DataValueField = "proID";
                ddlSourceProMaster.DataBind();
                ddlSourceProMaster.Items.Insert(0, "Source Pro");

                ddlTargetProMaster.DataSource = dtPro;
                ddlTargetProMaster.DataTextField = "proName";
                ddlTargetProMaster.DataValueField = "proID";
                ddlTargetProMaster.DataBind();
                ddlTargetProMaster.Items.Insert(0, "Target Pro");

            }
        }

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getMappedProDetails(string CentreID, string ProId)
    {


        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT a.panel_id,a.panel_code,a.company_name,0 CheckStatus FROM f_panel_master a ");

        if (CentreID != "")
        {
            sbQuery.Append(" where a.centreid=" + CentreID + "");
        }

        if (ProId != "")
        {
            sbQuery.Append(" and a.proid=" + ProId + "");
        }


        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return JsonConvert.SerializeObject(dt);
    }



    [WebMethod(EnableSession = true)]
    public static string InsertUpdateMappedRecord(string TargetProId, string Mapped_list)
    {
        string CreatedBy = HttpContext.Current.Session["ID"].ToString();
        List<MappedRecord> datafeedbackRatingId = new JavaScriptSerializer().Deserialize<List<MappedRecord>>(Mapped_list);

        int a = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {

            foreach (var item in datafeedbackRatingId)
            {
                excuteCMD.DML(Tranx, con, "update f_panel_master set ProId=@TargetProId where panel_id=@panel_id", CommandType.Text, new
                {
                    TargetProId = TargetProId,
                    panel_id = item.panel_id
                });
            }
            Tranx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, Msg = "Change SuccessFully" });
        }
        catch (Exception)
        {
            Tranx.Rollback();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, Msg = "Some Error Occured" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    class MappedRecord
    {
        public string panel_id { get; set; }

    }


}