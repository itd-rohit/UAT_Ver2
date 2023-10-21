using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_CopyItemfromLocation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlpanel.DataSource = StockReports.GetDataTable("SELECT locationid,location FROM st_locationmaster WHERE isactive=1 ORDER BY location");
            ddlpanel.DataValueField = "locationid";
            ddlpanel.DataTextField = "location";
            ddlpanel.DataBind();
            ddlpanel.Items.Insert(0, new ListItem("Select", "0"));
            lstlocationto.DataSource = ddlpanel.DataSource;
            lstlocationto.DataValueField = "locationid";
            lstlocationto.DataTextField = "location";
            lstlocationto.DataBind();


        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string locationid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT sm.locationid, sm1.SubCategoryTypeName,ssm.Name, sm.itemid,(SELECT ItemNameGroup FROM st_itemmaster_group WHERE ItemIDGroup=st.ItemIDGroup) Typename  ");
        sb.Append("   ,st.ManufactureName,st.MachineName,st.PackSize,st.CatalogNo FROM st_mappingitemmaster sm   ");
        sb.Append("   INNER JOIN st_itemmaster st ON sm.itemid=st.itemid  ");
        sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=st.SubCategoryID  ");
        sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=st.SubCategoryTypeID  ");
        sb.Append("   WHERE locationid=" + locationid + " and sm.isactive=1 and st.isactive=1 ");
        sb.Append("   ORDER BY typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(string locationidfrom, string locationidto, string testid)
    {

        string[] Centres = locationidto.Split(',');
        string[] Items = testid.Trim(',').Split(',');
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {

            StringBuilder Command = new StringBuilder();
            Command.Append("INSERT INTO st_mappingitemmaster (LocationId,CreatedDate,ItemId,CreatedBy,IsActive) VALUES ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from st_mappingitemmaster where LocationId in (" + string.Join(",", Centres) + ") and ItemId in(" + string.Join(",", Items) + ")");

            for (int i = 0; i < Centres.Length; i++)
            {
                for (int j = 0; j < Items.Length; j++)
                {

                    Command.Append(" (");
                    Command.Append("'" + Centres[i] + "',");
                    Command.Append("now(),");
                    Command.Append("'" + Items[j] + "',");
                    Command.Append("'" + UserInfo.ID + "',");
                    Command.Append(" '1'");
                    Command.Append(" ),");

                }
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Command.ToString().Trim().TrimEnd(','));
            Tranx.Commit();
            return "1";

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


}