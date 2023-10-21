using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;
using System.Linq;
public partial class Design_Employee_EmployeeStoreLocationMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                int Employee_ID = Util.GetInt(Common.Decrypt(Request.QueryString["employeeid"].ToString()));
                StringBuilder sb = new StringBuilder();
                ddlemployee.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select Employee_ID,Name from employee_master where Employee_ID=@Employee_ID",
                   new MySqlParameter("@Employee_ID", Employee_ID));
                ddlemployee.DataValueField = "Employee_ID";
                ddlemployee.DataTextField = "Name";
                ddlemployee.DataBind();


                sb.Append(" SELECT fl.centreid,centre FROM f_login fl ");
                sb.Append(" INNER JOIN centre_master cm ON cm.centreid=fl.centreid AND cm.isactive=1 ");
                sb.Append(" WHERE employeeid=@Employee_ID GROUP BY centreid ORDER BY centre");
                ddlcentre.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", Employee_ID));
                ddlcentre.DataBind();

                string centreid = string.Empty;

                foreach (GridViewRow dwr in ddlcentre.Rows)
                {
                    centreid += ((Label)dwr.FindControl("Label2")).Text + ",";
                }
                centreid = centreid.TrimEnd(',');

                //centreid = "'" + centreid + "'";
                //centreid = centreid.Replace(",", "','");

                string[] centreidTags = centreid.Split(',');
                string[] centreNames = centreidTags.Select((s, i) => "@tag" + i).ToArray();
                string centreClause = string.Join(", ", centreNames);

                sb = new StringBuilder();

                sb.Append("  SELECT LocationID,Location FROM st_locationmaster lm   ");
                sb.Append("   INNER JOIN f_panel_master pm ON pm.`panel_id`=lm.`Panel_ID`  ");
               // sb.Append("  INNER JOIN centre_master cm ON   cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` ='Centre'  AND cm.IsActive=1 ");
               // sb.Append("   AND cm.centreid IN ({0}) order by location");

               


                using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), centreClause), con))
                {
                    for (int i = 0; i < centreNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(centreNames[i], centreidTags[i]);
                    }

                    DataTable dt = new DataTable();
                    using (dt as IDisposable)
                    {
                        da.Fill(dt);

                        chlist.DataSource = dt;
                        chlist.DataValueField = "LocationID";
                        chlist.DataTextField = "Location";
                        chlist.DataBind();
                    }
                }

               

                string accesslocation = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT AccessStoreLocation FROM employee_master where Employee_ID=@Employee_ID",
                   new MySqlParameter("@Employee_ID", Employee_ID)));
                if (accesslocation != string.Empty)
                {
                    foreach (string s in accesslocation.Split(','))
                    {
                        foreach (ListItem li in chlist.Items)
                        {
                            string value = li.Value;
                            if (s == li.Value)
                            {
                                li.Selected = true;
                            }
                        }
                    }
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

    protected void btnsave_Click(object sender, System.EventArgs e)
    {
        string loc = string.Empty;
        foreach (ListItem li in chlist.Items)
        {
            string value = li.Value;
            if (li.Selected)
            {
                loc += value + ",";
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update employee_master SET  AccessStoreLocation=@AccessStoreLocation WHERE  Employee_ID=@Employee_ID",
              new MySqlParameter("@Employee_ID", Util.GetInt(Common.Decrypt(Request.QueryString["employeeid"].ToString()))),
              new MySqlParameter("@AccessStoreLocation", loc.TrimEnd(',')));
            lbmsg.Text = "Record Saved.";

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

    protected void ch_CheckedChanged(object sender, System.EventArgs e)
    {
        if (ch.Checked)
        {
            foreach (ListItem li in chlist.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            foreach (ListItem li in chlist.Items)
            {
                li.Selected = false;
            }
        }
    }

    protected void ch_ShowPUP(object sender, System.EventArgs e)
    {
        string centreid = "";
        foreach (GridViewRow dwr in ddlcentre.Rows)
        {
            centreid += ((Label)dwr.FindControl("Label2")).Text + ",";
        }
        centreid = centreid.TrimEnd(',');

        centreid = "'" + centreid + "'";
        centreid = centreid.Replace(",", "','");


        string[] centreidTags = centreid.Split(',');
        string[] centreNames = centreidTags.Select((s, i) => "@tag" + i).ToArray();
        string centreClause = string.Join(", ", centreNames);


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT LocationID,Location FROM st_locationmaster lm   ");
            sb.Append("   INNER JOIN f_panel_master pm ON pm.`panel_id`=lm.`Panel_ID`  ");
            sb.Append("  INNER JOIN centre_master cm ON   cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END  AND cm.IsActive=1 ");
            if (chkPUP.Checked)
            {
                sb.Append("   AND pm.`PanelType` in('Centre','PUP')  ");
            }
            else
            {
                sb.Append("  AND pm.`PanelType` ='Centre' ");
            }
            sb.Append("   AND cm.centreid IN ({0}) order by location");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), centreClause), con))
            {
                for (int i = 0; i < centreNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(centreNames[i], centreidTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                   
                    chlist.DataSource = dt;
                    chlist.DataValueField = "LocationID";
                    chlist.DataTextField = "Location";
                    chlist.DataBind();
                }
            }

            

            string accesslocation = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select AccessStoreLocation from employee_master where Employee_ID=@Employee_ID",
                new MySqlParameter("@Employee_ID", Util.GetInt(Common.Decrypt(Request.QueryString["employeeid"].ToString())))));
            if (accesslocation != "")
            {
                foreach (string s in accesslocation.Split(','))
                {
                    foreach (ListItem li in chlist.Items)
                    {
                        string value = li.Value;
                        if (s == li.Value)
                        {
                            li.Selected = true;
                        }
                    }
                }
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