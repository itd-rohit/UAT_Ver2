using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Investigation_InvestigationAutoApproveMaster : System.Web.UI.Page
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
    void binddepartment()
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
    public static string bindcentre(string StateID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master WHERE isactive=1 and StateID='" + StateID + "' ORDER BY centre  ");
        return JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string binddoctor(string centreid)
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name`  FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        sbQuery.Append("  WHERE centreid=" + centreid + " order by name");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public static string binddata()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");
        sb.Append("SELECT ia.approvebyid, ia.id,sm.name Department,cm.centre,em.name ApproveByName,(SELECT em1.name  ");
        sb.Append(" FROM employee_master em1 WHERE em1.employee_id=ia.entryby) EnterdBy, ");
        sb.Append(" DATE_FORMAT(ia.entrydatetime,'%d-%m-%Y %h:%i %p') EntryDate ");
        sb.Append(" FROM  investigation_autoapprovemaster ia ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON ia.departmentid=sm.SubCategoryID ");
        sb.Append(" INNER JOIN employee_master em ON em.employee_id=ia.approvebyid  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=ia.centreid ");
        sb.Append(" order by cm.centre,sm.name,em.name");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return JsonConvert.SerializeObject(dt);
       

    }
    [WebMethod(EnableSession = true)]
    public static string savedata(string centreid,string docid,string deptid)
    {
        try
        {
            StockReports.ExecuteDML("delete from investigation_autoapprovemaster where departmentid='" + deptid + "' and CentreId='" + centreid + "' ");
            StockReports.ExecuteDML("insert into investigation_autoapprovemaster (departmentid,CentreId,ApproveById,Entrydatetime,Entryby,IsActive) values ('" + deptid + "','" + centreid + "','" + docid + "',now(),'" + Util.GetString(UserInfo.ID) + "','1')");
            return "1";
        }
        catch(Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string deletedata(string ID)
    {
        try
        {
            StockReports.ExecuteDML("delete from investigation_autoapprovemaster where id='" + ID + "' ");
            return "1";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    
   
}