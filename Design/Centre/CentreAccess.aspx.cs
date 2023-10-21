using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class CentreAccess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindAllCentre(ddlCentreName, null, null);
            if (Request.QueryString["centreID"] != null)
            {
                lblCentreID.Text = Common.Decrypt(Request.QueryString["centreID"]);
            }

            if (lblCentreID.Text != "")
            {
                lblCentreID.Text = lblCentreID.Text;
                lblHeder.Text = " Centre Access For " + AllLoad_Data.getCentre(Util.GetInt(lblCentreID.Text));

                ddlCentreName.SelectedIndex = ddlCentreName.Items.IndexOf(ddlCentreName.Items.FindByValue(lblCentreID.Text));
                ddlCentreName.Enabled = false;
            }
            else
            {
                lblCentreID.Text = ddlCentreName.SelectedValue;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string updateCentreAccess(int CentreID, int AccessCentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "delete from centre_access where CentreID='" + CentreID + "' AND CentreAccess='" + AccessCentreID + "' ");

            tranX.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveCentreAccess(object CentreAccess, int CentreID)
    {
        List<Centre_Access> dataCentreAccess = new JavaScriptSerializer().ConvertToType<List<Centre_Access>>(CentreAccess);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            //string DeleteSQL = " delete from centre_access where CentreID='" + CentreID + "' and  CentreAccess in ( select centreid from centre_master where  stateID='" + stateID.TrimEnd(',') + "' ";
            //if (cityID != "0" && cityID != "-1")
            //{
            //    DeleteSQL += " and cityID='" + cityID.TrimEnd(',') + "'  ";
            //}
            //DeleteSQL += " ) ";

            string AccessCentreID = "";
            foreach (var temp in dataCentreAccess)
            {
                AccessCentreID += temp.CentreID + ",";
            }
            string DeleteSQL = " delete from centre_access where CentreID='" + CentreID + "' and  CentreAccess in(" + AccessCentreID.TrimEnd(',') + ") ";

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, DeleteSQL);

            for (int i = 0; i < dataCentreAccess.Count; i++)
            {
                string str = "insert into centre_access(CentreID,CentreAccess,createdBy) values('" + CentreID + "','" + dataCentreAccess[i].CentreID + "','" + UserInfo.ID + "')";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
            }

            tranX.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindCentreAccess(int centreID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT cm1.Centre,cm1.CentreID,cm.Centre AccessCentre,cm.CentreID AccessCentreID FROM centre_access ca INNER JOIN centre_master cm ON ca.CentreAccess=cm.CentreID INNER JOIN centre_master cm1 ON cm1.CentreID=ca.CentreID WHERE ca.centreID=" + centreID + "");
        return Util.getJson(dt);
    }
}