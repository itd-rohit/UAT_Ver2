using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.Web.UI;
using System.Web;
using System.Drawing;
public partial class Design_DefaultHome : System.Web.UI.MasterPage
{
    public string serverPath = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        serverPath = string.Format("{0}://{1}:{2}/{3}/", Request.Url.Scheme, Request.Url.Host, Request.Url.Port, Request.Url.AbsolutePath.Split('/')[1]);
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
               // Response.Redirect("~/Design/Default.aspx", false);
				Response.Redirect("~/Design/Default.aspx");
                return;
            }
            //Block Url Page Access
             try
            {
                if (rptMenu.Visible)
                {
                    DataSet ds = new DataSet();
                    ds.ReadXml(Server.MapPath(string.Format("~/Design/MenuData/{0}.xml", Util.GetString(Session["LoginType"]))));
                    string AccessPath = Request.Url.AbsolutePath;
                    AccessPath = AccessPath.Substring(AccessPath.IndexOf("/", 2)).ToLower();
                    List<string> pagelist = ValidationSkipPage.ValidationSkipPages();
                    if (AccessPath != "/design/welcome.aspx" && !ValidationSkipPage.ValidationSkipPages().Exists(x => x.ToLower() == AccessPath) && (ds.Tables["items"].AsEnumerable().Where(myRow => myRow.Field<string>("urlname").ToLower() == AccessPath).AsDataView().Count == 0))
                    {
                          Response.Redirect("~/Design/Default.aspx", false);
                    }

                   // if (pagelist.Contains(AccessPath) != true)
                   // {
                   //     if (ds.Tables["items"].Select("urlname='" + AccessPath + "'").Length == 0)
                   //         Response.Redirect("~/Design/Default.aspx", false);
                   // }
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("~/Design/Default.aspx", false);
                return;
            }
            lblLoginName.Text = UserInfo.LoginName;
            lblCentreName.Text = UserInfo.CentreName;
            lblCentreName.ToolTip = UserInfo.CentreName;

            lblRole.Text = UserInfo.LoginType;

            //string Cookies = Guid.NewGuid().ToString(); 
            //loadCookies(Cookies);
            //hfSessionUserID.Value = Util.GetString(Cookies);

         

            titleUser.Text = string.Concat(Resources.Resource.ApplicationName.Replace("/", string.Empty), " (", Session["LoginName"], ")");

            //string URL = serverPath + System.Configuration.ConfigurationManager.AppSettings["ServerUrl"].ToString();
            //Response.AddHeader("Refresh", string.Format("{0};URL='{1}'", Convert.ToString((Session.Timeout * 60) - 10), URL));

           // Response.AddHeader("AuthToken", Guid.NewGuid().ToString());


             

               // Session["AuthToken"] = Response.Headers.GetValues("AuthToken").FirstOrDefault();
            if (Session["LoginType"] == null && Session["UserName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            else
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();

                try
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" SELECT UPPER(rm.RoleName) RoleName,rm.ID,rm.image,rm.background FROM f_login fl INNER JOIN f_rolemaster rm ");
                    sb.Append(" ON fl.RoleID=rm.ID AND fl.EmployeeID=@EmployeeID AND fl.Active=1 AND fl.RoleID<>@RoleID AND rm.Active=1 and fl.CentreID=@CentreID  ");
                    if(UserInfo.ID !=1)
                    {
                      sb.Append(" AND fl.RoleID<>6 ");
                    }
                    sb.Append(" ORDER BY rm.RoleName ");
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                          new MySqlParameter("@EmployeeID", UserInfo.ID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                    {
                        string LoginType = UserInfo.LoginType;
                        if (LoginType == "PCC")
                        {
                            ddlCentreByUser.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Distinct  cm.CentreID,Centre FROM centre_master cm  INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` WHERE fl.`EmployeeID`=@EmployeeID AND fl.Active=1 AND cm.isActive=1 and ( cm.CentreID  =@CentreID) and cm.isActive=1 order by cm.CentreCode",
                                           new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@EmployeeID", UserInfo.ID)).Tables[0];
                        }
                        else
                        {
                            ddlCentreByUser.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT cm.centreID,Centre FROM centre_master cm INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` AND fl.`EmployeeID`=@EmployeeID AND fl.Active=1 AND cm.isActive=1 ORDER BY Centre ",
                               new MySqlParameter("@EmployeeID", UserInfo.ID));
                        }
                        ddlCentreByUser.DataTextField = "Centre";
                        ddlCentreByUser.DataValueField = "centreID";
                        ddlCentreByUser.DataBind();
                        ListItem selectedListItem = ddlCentreByUser.Items.FindByValue(UserInfo.Centre.ToString());

                        rptRole.DataSource = dt;
                        rptRole.DataBind();

                        if (selectedListItem != null)
                        {
                            selectedListItem.Selected = true;
                        }
                    }

                    if (Session["CentreType"].ToString().ToUpper() == "PUP" || Session["CentreType"].ToString().ToUpper() == "CC" || Session["CentreType"].ToString().ToUpper() == "FC" || Session["CentreType"].ToString().ToUpper() == "B2B" || Session["CentreType"].ToString().ToUpper() == "HLM" || Session["CentreType"].ToString().ToUpper() == "PCC")
                    {
                        string str = string.Empty;

                        if (Session["CentreType"].ToString().ToUpper() == "CC" || Session["CentreType"].ToString().ToUpper() == "FC" || Session["CentreType"].ToString().ToUpper() == "B2B" || Session["CentreType"].ToString().ToUpper() == "HLM" || Session["CentreType"].ToString().ToUpper() == "PCC")
                        {
                            int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE CentreID=@CentreID AND PanelType='Centre' AND Panel_ID=InvoiceTo",
                               new MySqlParameter("@CentreID", Session["Centre"])));
                            if (IsShowIntimation == 1)
                            {
                                str = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@Centre) ",
                                   new MySqlParameter("@CentreType", Session["CentreType"]), new MySqlParameter("@Centre", Session["Centre"])));
                                lblMasterBalanceAmount.Text = str.Split('#')[0].ToString();
                            }
                            else
                            {
                                lblMasterBalanceAmount.Text = string.Empty;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "clientScript", "document.getElementById('spnMasterBalanceAmt').style.visibility = 'hidden';", true);

                            }
                        }
                        else
                        {
                            int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE Panel_ID=@Panel_ID ",
                                new MySqlParameter("@Panel_ID", Session["OnlinePanelID"])));
                            if (IsShowIntimation == 1)
                            {
                                str = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@OnlinePanelID) ",
                                    new MySqlParameter("@CentreType", Session["CentreType"]), new MySqlParameter("@OnlinePanelID", Session["OnlinePanelID"])));
                                lblMasterBalanceAmount.Text = str.Split('#')[0].ToString();
                            }
                            else
                            {
                                lblMasterBalanceAmount.Text = string.Empty;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "clientScript", "document.getElementById('spnMasterBalanceAmt').style.visibility = 'hidden';", true);
                            }
                        }

                        if (str.ToString().Trim() != string.Empty)
                        {
                            if (str.Split('#')[1].ToString() == "1")
                            {
                               lblMasterBalanceAmount.ForeColor = Color.Red;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "", "setInterval(blinker, 1000);", true);
                            }
                        }
                    }
                    else
                    {
                        lblMasterBalanceAmount.Text = string.Empty;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "clientScript", "document.getElementById('spnMasterBalanceAmt').style.visibility = 'hidden';", true);

                    }

                    try
                    {
                        var menuDataSet = new DataSet();
                        menuDataSet.ReadXml(Server.MapPath(string.Format("~/Design/MenuData/{0}.xml", Util.GetString(Session["LoginType"]))));
                        var table = menuDataSet.Tables[0];
                        if (table.Columns.Contains("image"))
                        {
                            rptMenu.DataSource = table;
                            rptMenu.DataBind();
                        }
                        else
                        {
                            DataColumn newColumn = new DataColumn("image", typeof(String)) { DefaultValue = "" };
                            table.Columns.Add(newColumn);
                            rptMenu.DataSource = table;
                            rptMenu.DataBind();
                        }

                        System.Xml.Serialization.XmlSerializer reader = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
                        System.IO.StreamReader file = new System.IO.StreamReader(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml"));
                        List<DefaultPageMaster> defaultPageMasterList = (List<DefaultPageMaster>)reader.Deserialize(file);
                        file.Close();
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
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
    }

    public class DefaultPageMaster
    {
        public string UserID { get; set; }
        public int roleID { get; set; }
        public string pageURL { get; set; }
    }

    protected void rptMenu_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
 
            Repeater Repeater2 = (Repeater)(e.Item.FindControl("rptSubMenu"));
            string LoginType = Convert.ToString(Session["LoginType"]);

            Label a1 = (Label)e.Item.FindControl("lblMenuID");
            var menuId = a1.Text;
            List<object> menuData = new List<object>();
            var parentDir = Resources.Resource.ApplicationName;
            XDocument document = XDocument.Load(Server.MapPath(string.Format("~/Design/MenuData/{0}.xml", LoginType)));
            var menuList = document.Descendants("NewDataSet").Descendants("Menu").Descendants("Items").Select(d =>
                            new
                            {
                                MenuID = d.Element("MenuID").Value,
                                MenuDisplayName = d.Element("DispName").Value,
                                MenuURL = parentDir + d.Element("URLName").Value
                            }).Where(m => m.MenuID == menuId).ToList();

            Repeater2.DataSource = menuList;
            Repeater2.DataBind();
            menuData.Clear();
        }
    }

    protected void rptRole_ItemCommand(object source, RepeaterCommandEventArgs e)
    {

        if (e.CommandName == "Select")
        {
 
            var role = Util.GetString(e.CommandArgument).Split('#');

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.RoleID FROM f_login fl INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID");
            sb.AppendFormat(" WHERE fl.Active = 1 AND fl.RoleID = {0} AND fl.EmployeeId = '{1}' AND fl.CentreID={2}", role[1], Util.GetString(Session["ID"]), Session["Centre"]);

            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {
                if (dt.Rows.Count > 0)
                {
                    Session["LoginType"] = role[0].ToString();
                    Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);
                     Response.Redirect("~/Design/Welcome.aspx",true);
                }
            }
        }
    }

    protected void lnkSignOut_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update f_login_detail Set Logouttime=@Logouttime WHERE EmployeeID=@EmployeeID and DATE_FORMAT(Logintime,'%Y-%m-%d')=CURRENT_DATE()",
              new MySqlParameter("@Logouttime", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")), new MySqlParameter("@EmployeeID", Session["ID"]));
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

        Session.RemoveAll();
        Session.Abandon();
        HttpCookie myCookie = new HttpCookie("ASP.NET_SessionId");
        myCookie.Expires = DateTime.Now.AddDays(-1);
        Response.Cookies.Add(myCookie);
        HttpCookie Login = new HttpCookie("Login");
        Login.Expires = DateTime.Now.AddDays(-1);
        Response.Cookies.Add(Login);
        HttpCookie LabUserID = new HttpCookie("LabUserID");
        LabUserID.Value = Guid.NewGuid().ToString();
        LabUserID.Expires = DateTime.Now.AddDays(-1);
        Response.Cookies.Add(LabUserID);
        Response.Redirect("~/Design/Default.aspx", true);  
    }
    private void loadCookies(string UserID)
    { 
        Response.Cookies.Add(new HttpCookie("LabUserID", UserID));
    }
}