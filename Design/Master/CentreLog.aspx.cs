using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;

public partial class Design_Master_CentreLog : System.Web.UI.Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["centreID"] != null)
            {
                lblCentreID.Text =Request.QueryString["centreID"];
                string centre = StockReports.ExecuteScalar(string.Format("select Centre from centre_master where centreID='{0}'  ", lblCentreID.Text));
                lblHeder.Text = "Centre Log of : " + centre;
            }
        }
    }
    [WebMethod]
    public static string bindCentreLog(string CentreID)
    {
        DataTable dt = StockReports.GetDataTable(string.Format("SELECT ID,CentreID,LogType,CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y %I:%i %p')CreatedDate FROM Centre_master_log WHERE CentreID='{0}' ORDER BY CreatedDate", CentreID));
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string EncryptCentreLog(string ID)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(Util.GetString(ID)));
        return Newtonsoft.Json.JsonConvert.SerializeObject(addEncrypt);
    }
}