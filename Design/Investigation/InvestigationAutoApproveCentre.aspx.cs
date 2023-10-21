using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvestigationAutoApproveCentre : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            binddepartment();
        }
    }

    private void binddepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");

        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod(EnableSession = true)]
    public static string searchdata(string centreid, string deptid)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT '" + deptid + "' deptid, im.investigation_id,im.name imname,IFNULL(iac.id,0) isdone,'" + centreid + "' centreid  FROM `investigation_master` im INNER JOIN investigation_observationtype io ON io.investigation_id=im.investigation_id AND ObservationType_Id=" + deptid + " LEFT JOIN investigation_autoapprovemaster_centre iac ON iac.investigation=im.Investigation_id AND iac.CentreId=" + centreid + " ORDER BY NAME  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string savedata(List<string> data)
    {
        try
        {
            StockReports.ExecuteDML("delete from investigation_autoapprovemaster_centre where departmentid='" + data[0].Split('#')[1] + "' and CentreId='" + data[0].Split('#')[0] + "' ");
            foreach (string ss in data)
            {
                if (ss.Split('#')[3] == "1")
                {
                    StockReports.ExecuteDML("insert into investigation_autoapprovemaster_centre (departmentid,CentreId,Investigation,Entrydatetime,Entryby,IsActive) values ('" + ss.Split('#')[1] + "','" + ss.Split('#')[0] + "','" + ss.Split('#')[2] + "',now(),'" + Util.GetString(UserInfo.ID) + "','1')");
                }
            }
            return "1";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
}