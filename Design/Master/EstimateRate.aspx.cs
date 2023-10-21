using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Design_Lab_EstimateRate : System.Web.UI.Page
{
    public string AccessType = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "";

        if (cmd == "GetTestList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetTestList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            if (!string.IsNullOrEmpty(Util.GetString(Session["RoleID"])) && Util.GetString(Session["RoleID"]) == "212")
            {
                AccessType = "";
            }
            else if (!string.IsNullOrEmpty(Util.GetString(Session["OnlinePanelID"])))
            {
                Response.AddHeader("Cache-Control", "no-store");

                ((DropDownList)Master.FindControl("ddlcentrebyuser")).Visible = false;
                ((TextBox)Master.FindControl("txtDynamicSearchMaster")).Visible = false;
                ((HtmlControl)Master.FindControl("spnSelectCentre")).Visible = false;
                ((HtmlControl)Master.FindControl("spnSampleTracker")).Visible = false;
                ((HtmlControl)Master.FindControl("feedback")).Visible = false;
                setPanel("pn.panel_id", Util.GetString(Session["OnlinePanelID"]));
                AccessType = "PUP";
            }
            else if (!string.IsNullOrEmpty(Util.GetString(Session["CentreType"])) && Util.GetString(Session["CentreType"]) == "PCC")
            {
                setPanel("cm.centreid", Util.GetString(UserInfo.Centre));
                AccessType = "PCC";
            }
        }
    }

    protected void setPanel(string Type, string ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',IF(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID))Panel_ID,pn.`Company_Name`  ,cm.centreid ");
        sb.Append("  FROM Centre_Panel cp    ");
        sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id    ");
        sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId`   WHERE  ");
        sb.Append("  " + Type.Trim() + "='" + ID.Trim() + "'  ");
        ddlPanel.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "Panel_ID";
        ddlPanel.DataBind();
        ddlPanel.SelectedIndex = 0;
    }

    //[WebMethod]
    //DataTable GetTestList()
    //{
    //    if (Util.GetString(Request.QueryString["PanelId"]) == "")
    //    {
    //        return null;
    //    }
    //    StringBuilder sb = new StringBuilder();
    //    sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryid='15','Package','Test') type, ");
    //    sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,'" + Request.QueryString["PanelId"].ToString() + "',if('" + Util.GetString(Request.QueryString["PrescribeDate"]) + "' <>'','" + Util.GetDateTime(Request.QueryString["PrescribeDate"]).ToString("yyyy-MM-dd") + "',  CURRENT_DATE()))),0)Rate, ");
    //    sb.Append(" 0 DiscPer ");
    //    sb.Append(" from f_itemmaster im ");
    //    sb.Append(" WHERE isActive=1 ");
    //    if (Request.QueryString["SearchType"] == "1")
    //        sb.Append(" AND typeName like '" + Request.QueryString["TestName"] + "%' ");
    //    else if (Request.QueryString["SearchType"] == "0")
    //        sb.Append(" AND im.testcode LIKE '" + Request.QueryString["TestName"] + "%' ");
    //    else
    //        sb.Append(" AND typeName like '%" + Request.QueryString["TestName"] + "%' ");
    //    sb.Append("  order by typename limit 20 ");

    //    DataTable dt = StockReports.GetDataTable(sb.ToString());
    //    return dt;

    //}
    //DataTable GetTestList()
    //{
    //    StringBuilder sb = new StringBuilder();
    //    sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryid='15','Package','Test') type,ifnull(rl.Rate,0) Rate from f_itemmaster im ");
    //    sb.Append(" INNER JOIN f_ratelist rl ON rl.`ItemID`=im.`ItemID` AND rl.`Panel_ID`='" + Request.QueryString["PanelID"] + "'   ");
    //    sb.Append(" WHERE isActive=1 ");
    //    if (Request.QueryString["SearchType"] == "1")
    //        sb.Append(" AND typeName like '" + Request.QueryString["TestName"] + "%' ");
    //    else if (Request.QueryString["SearchType"] == "0")
    //        sb.Append(" AND im.testcode LIKE '" + Request.QueryString["TestName"] + "%' ");
    //    else
    //        sb.Append(" AND typeName like '%" + Request.QueryString["TestName"] + "%' ");
    //    sb.Append("  order by typename limit 20 ");
    //    DataTable dt = StockReports.GetDataTable(sb.ToString());
    //    return dt;
    //}
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPanel(string BusinessZoneID, string StateID, string CityID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',if(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID))Panel_ID,pn.`Company_Name`  ");
        sb.Append("   FROM Centre_Panel cp   ");
        sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id  ");
        sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId`  ");
        sb.Append("  AND cm.`BusinessZoneID` ='" + BusinessZoneID.Trim() + "'  ");
        if (StateID.Trim() != "-1")
            sb.Append("   AND cm.`StateID`='" + StateID.Trim() + "'  ");
        //if (CityID.Trim() != "-1")
        //    sb.Append(" AND cm.`CityID` ='" + CityID.Trim() + "' ");
        //  sb.Append(" AND cm.`CentreID` IN () ");
        sb.Append(" AND cp.isActive=1 AND pn.isActive=1  ");
        sb.Append(" AND CURRENT_DATE() >= IF(cp.IsCamp=1,cp.`FromCampValidityDate`,CURRENT_DATE())  ");
        sb.Append("  AND CURRENT_DATE() <= IF(cp.IsCamp=1,cp.`ToCampValidityDate`,CURRENT_DATE()) ");
        sb.Append("  ORDER BY pn.company_name  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewEstimateLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks, string Name)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = "";
            Patient_Estimate_Log pelObj = new Patient_Estimate_Log(tnx);
            pelObj.Mobile = MobileNo;
            pelObj.Call_By = CallBy;
            pelObj.Call_By_ID = CallByID;
            pelObj.Call_Type = CallType;
            pelObj.UserName = UserInfo.LoginName;
            pelObj.UserID = UserInfo.ID;
            pelObj.Remarks = Remarks;
            pelObj.Name = Name;
            pelObj.CentreID = "0";
            ID = pelObj.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            else
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally { }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetRemarks()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT RemarksValue,Remarks FROM Call_Centre_Remarks WHERE IsActive='1'");
            string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
            return rtrn;
        }
        catch (Exception ex)
        {
            return "";
        }
    }

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }

    private DataTable GetTestList()
    {
        if (Util.GetString(Request.QueryString["PanelId"]) == "")
        {
            return null;
        }

        string Gender = ""; //Util.GetString(Request.QueryString["Gender"]);
        string DOB = "";// Util.GetString(Request.QueryString["DOB"]);
        double AgeInDays = 0;

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.itemid value,CONCAT(typeName,' # ',Name) label,if(im.subcategoryid='15','Package','Test') type, ");
        //shatrughan 10.03.17 for schedule date wise rate
        sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,'" + Request.QueryString["PanelId"].ToString() + "',if('" + Util.GetString(Request.QueryString["PrescribeDate"]) + "' <>'','" + Util.GetDateTime(Request.QueryString["PrescribeDate"]).ToString("yyyy-MM-dd") + "',  CURRENT_DATE()),'" + Request.QueryString["Panel_Id"].ToString() + "')),0)Rate ");

        //  sb.Append(" (SELECT get_discountPer(" + Request.QueryString["PanelId"].ToString() + ",im.itemid," + (DateTime.Now - Util.GetDateTime(DOB)).TotalDays + ",'" + Gender.Substring(0, 1) + "'))DiscPer ");

        sb.Append(" from f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");

        sb.Append(" WHERE isActive=1 ");

        if (Request.QueryString["SearchType"] == "1")
            sb.Append(" AND typeName like '" + Request.QueryString["TestName"].ToString() + "%' ");
        else if (Request.QueryString["SearchType"] == "0")
            sb.Append(" AND im.testcode LIKE '" + Request.QueryString["TestName"].ToString() + "%' ");
        else
            sb.Append(" AND typeName like '%" + Request.QueryString["TestName"].ToString() + "%' ");
        if (Gender != "")
        {
            sb.Append(" and `Gender` in ('B','" + Gender.Substring(0, 1) + "') ");
        }
        sb.Append(" HAVING IFNULL(Rate,0)<>0 ");

        ///Alias Name Change by Apurva 30-06-2018

        if (Request.QueryString["SearchType"] != "0")
        {
            sb.Append(" union all  ");
            sb.Append(" SELECT im.itemid value,ima.`Alias`  label,if(im.subcategoryid='15','Package','Test') type, ");
            //shatrughan 10.03.17 for schedule date wise rate
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,'" + Request.QueryString["PanelId"].ToString() + "',if('" + Util.GetString(Request.QueryString["PrescribeDate"]) + "' <>'','" + Util.GetDateTime(Request.QueryString["PrescribeDate"]).ToString("yyyy-MM-dd") + "',  CURRENT_DATE()),'" + Request.QueryString["Panel_Id"].ToString() + "')),0)Rate ");

            //  sb.Append(" (SELECT get_discountPer(" + Request.QueryString["PanelId"].ToString() + ",im.itemid," + (DateTime.Now - Util.GetDateTime(DOB)).TotalDays + ",'" + Gender.Substring(0, 1) + "'))DiscPer ");

            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER JOIN `f_itemmaster_alias` ima ON ima.ItemID=im.`ItemID` ");
            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");

            sb.Append(" WHERE isActive=1  AND ima.Active=1 ");

            if (Request.QueryString["SearchType"] == "1")
                sb.Append(" AND  ima.`Alias`  like '" + Request.QueryString["TestName"].ToString() + "%' ");
            else if (Request.QueryString["SearchType"] == "0")
                sb.Append(" AND  ima.`Alias`  LIKE '" + Request.QueryString["TestName"].ToString() + "%' ");
            else
                sb.Append(" AND  ima.`Alias`  like '%" + Request.QueryString["TestName"].ToString() + "%' ");
            if (Gender != "")
            {
                sb.Append(" and `Gender` in ('B','" + Gender.Substring(0, 1) + "') ");
            }

            sb.Append(" HAVING IFNULL(Rate,0)<>0 ");
        }
        /// end Alias changes

        sb.Append("  order by label limit 20 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}