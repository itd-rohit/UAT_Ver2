using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

public partial class Design_Store_MIS_LoginDetails : System.Web.UI.Page
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
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DataTable dt = StockReports.GetDataTable("select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centreId");
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
            } 
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string dtFrom, string dtTo, string CentreID,string UserID, string ReportType, string compare)
    {
        try
        {
            string _checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }
        if (CentreID != "")
        {
            CentreID = "'" + CentreID + "'";
            CentreID = CentreID.Replace(",", "','");
        } 
        if (UserID != "")
        {
            UserID = "'" + UserID + "'";
            UserID = UserID.Replace(",", "','");
        }
        DataTable dt =new DataTable();
        StringBuilder sb = new StringBuilder();
        if (ReportType == "1")///Login Summary
        {
            sb.AppendLine(@" SELECT lgd.`EmployeeName`,lgd.`ipAddress`,lgd.`Browser`,cm.`Centre`,rol.`RoleName`,DATE_FORMAT(lgd.`LoginTime`,'%d-%b-%Y %I:%i %p')LoginTime,ifnull(DATE_FORMAT(lgd.`LogOutTime`,'%d-%b-%Y %I:%i %p'),'')LogOutTime FROM f_login_detail lgd
                            INNER JOIN `centre_master`  cm ON cm.`CentreID`=lgd.`CentreID` AND cm.`isActive`=1  
                            INNER JOIN `f_rolemaster` rol ON rol.`ID`=lgd.`RoleID` AND rol.`Active`=1 ");                                                  
            sb.AppendLine(" WHERE lgd.`LoginTime`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and lgd.`LoginTime`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine(" ORDER BY lgd.`LoginTime` DESC; ");
            dt = StockReports.GetDataTable(sb.ToString());
        }
            
        return JsonConvert.SerializeObject(new { status = true, response = dt });
     

    }
    public static DataTable changedatatableMIS(DataTable dt)
    {
        DataTable dtnew = new DataTable();
        DataView view = new DataView(dt);
        view.Sort = "RegBy asc";
        DataTable distinctuserValues = view.ToTable(true, "RegBy");
        DataView view1 = new DataView(dt);
        DataTable distinctstatusValues = view1.ToTable(true, "Status");
        dtnew.Columns.Add("User");
        foreach (DataRow dw in distinctstatusValues.Rows)
        {
            dtnew.Columns.Add(dw["Status"].ToString());
            dtnew.Columns[dw["Status"].ToString()].DataType = typeof(int);
        }
        
        foreach (DataRow du in distinctuserValues.Rows)
        {
            DataRow rr = dtnew.NewRow();
            foreach (DataColumn dc1 in dtnew.Columns)
            {
                string nn = dc1.ToString();
                if (dc1.ToString() == "User")
                {
                    rr[dc1] = du["RegBy"].ToString();
                }
                else
                {
                    rr[dc1] = 0; 
                }
            }
            dtnew.Rows.Add(rr);
        }
        for (int k = 1; k < dtnew.Columns.Count; k++)
        {
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if ((dt.Rows[j]["Status"].ToString()) == dtnew.Columns[k].ToString())
                    {
                        if (dtnew.Rows[i]["User"].ToString() == dt.Rows[j]["RegBy"].ToString())
                        {
                            dtnew.Rows[i][dtnew.Columns[k].ToString()] = dt.Rows[j]["StatusCount"].ToString();
                        }

                    }

                }
            }
        }
        dtnew.AcceptChanges();
        return dtnew;
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
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


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

    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        string CentreID = ""; //GetSelection(lstCentre);
       
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        if (ddlReportType.SelectedItem.Value.ToString() == "1")///Login Summary
        {
            sb.AppendLine(@" SELECT lgd.`EmployeeName`,cm.`Centre`,rol.`RoleName`,DATE_FORMAT(lgd.`LoginTime`,'%d-%b-%Y %I:%i %p')LoginTime,DATE_FORMAT(lgd.`LogOutTime`,'%d-%b-%Y %I:%i %p')LogOutTime,lgd.`ipAddress`,lgd.`Browser` FROM f_login_detail lgd
                            INNER JOIN `centre_master`  cm ON cm.`CentreID`=lgd.`CentreID` AND cm.`isActive`=1  
                            INNER JOIN `f_rolemaster` rol ON rol.`ID`=lgd.`RoleID` AND rol.`Active`=1 ");
            sb.AppendLine(" WHERE  lgd.`LoginTime`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  lgd.`LoginTime`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
           
            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine(" ORDER BY lgd.`LoginTime` DESC; ");
            dt = StockReports.GetDataTable(sb.ToString());
        }
     
        Session["ReportName"] = "Login Report";
        Session["dtExport2Excel"] = dt;
        Session["Period"] = " From : " + dtFrom.Text + " To : " + dtTo.Text;

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Common/ExportToExcel.aspx');", true);
    }
    private string GetSelection(ListBox cbl)
    {
        string str = "";

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
}