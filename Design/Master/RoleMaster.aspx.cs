using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Master_RoleMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
        }
    }
    private void BindRole()
    {
        DataTable dtPanel = StockReports.GetDataTable("SELECT ID,RoleName FROM f_roleMaster WHERE  Active='1' Order by RoleName");
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddlRole.DataSource = dtPanel;
            ddlRole.DataTextField = "RoleName";
            ddlRole.DataValueField = "ID";
            ddlRole.DataBind();
            ddlRole.Items.Insert(0, "--Select--");

        }
        else
        {
            ddlRole.Items.Clear();
            ddlRole.Items.Add("-");

        }
    }
    [WebMethod]
    public static string GetRole(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select ID, RoleName,MaxDiscount,EditInfo,EditPriscription,Settlement,DiscAfterBill,ChangePanel,ChangePayMode,ReceiptCancel,LabRefund,PrintDueReport ");
        sb.Append(" from f_rolemaster ");
        sb.Append(" Where Active=1 and ID='" + RoleID + "' ");
        sb.Append(" order by RoleName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string SaveRole(string RoleID, string ItemData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ItemData = ItemData.TrimEnd('#');
            string str = "";
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
            str = " UPDATE f_RoleMaster set UpdateDate=Now(),Updateby=@Updateby, MaxDiscount=@MaxDiscount, EditInfo=@EditInfo, EditPriscription=@EditPriscription,Settlement=@Settlement,DiscAfterBill=@DiscAfterBill,ChangePanel=@ChangePanel,ChangePayMode=@ChangePayMode,ReceiptCancel=@ReceiptCancel,LabRefund=@LabRefund,PrintDueReport=@PrintDueReport    where id=@id";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                new MySqlParameter("@MaxDiscount", Util.GetInt(Item[0].Split('|')[0].Trim())),
                new MySqlParameter("@EditInfo", Util.GetInt(Item[0].Split('|')[1].Trim())),
                new MySqlParameter("@EditPriscription", Util.GetInt(Item[0].Split('|')[2].Trim())),
                new MySqlParameter("@Settlement", Util.GetInt(Item[0].Split('|')[3].Trim())),
                new MySqlParameter("@DiscAfterBill", Util.GetInt(Item[0].Split('|')[4].Trim())),
                new MySqlParameter("@ChangePanel", Util.GetInt(Item[0].Split('|')[5].Trim())),
                new MySqlParameter("@ChangePayMode", Util.GetInt(Item[0].Split('|')[6].Trim())),
                new MySqlParameter("@ReceiptCancel", Util.GetInt(Item[0].Split('|')[7].Trim())),
                new MySqlParameter("@LabRefund", Util.GetInt(Item[0].Split('|')[8].Trim())),
                new MySqlParameter("@PrintDueReport", Util.GetInt(Item[0].Split('|')[9].Trim())),
                new MySqlParameter("@Updateby",UserInfo.LoginName),
                new MySqlParameter("@id", RoleID));
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}
