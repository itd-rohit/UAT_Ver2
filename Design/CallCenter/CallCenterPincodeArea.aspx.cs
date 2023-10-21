using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_CallCenterPincodeArea : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetCentre()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE isactive ='1' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }
    [WebMethod]
    public static string GetFeildBoy() {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT FeildboyID,NAME FROM feildboy_master WHERE IsActive='1'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindData()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT ccp.ID,ccp.Pincode,AreaID,fl.NAME FROM call_centre_pincode ccp INNER JOIN f_locality fl ON ccp.AreaID=fl.ID ORDER BY ID DESC ");
        sb.Append(" SELECT ccp.ID,ccp.Pincode,ccp.`CentreID`,ccp.`FieldboyID`,cm.`Centre`,fm.`Name`,cm.`Locality` FROM call_centre_pincode ccp ");
        sb.Append(" INNER JOIN centre_master cm ON ccp.`CentreID`=cm.`CentreID` ");
        sb.Append(" INNER JOIN feildboy_master fm ON fm.`FeildboyID`=ccp.`FieldboyID` ");
        sb.Append(" GROUP BY ccp.`CentreID`  ORDER BY ID DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            return null;
        }
    }
    [WebMethod]
    public static string EditData(string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,Pincode,CentreID,FieldboyID FROM call_centre_pincode WHERE CentreID='" + CentreID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveData(string Pincode, string CentreID, string Id, string FieldboyID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Id == "")
            {
                var cId = FieldboyID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < cId.Length; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO call_centre_pincode(Pincode,CentreID,CreatedDate,CreatedBy,FieldboyID)  VALUES('" + Pincode + "','" + CentreID + "',Now(),'" + UserInfo.LoginName + "','" + Convert.ToInt32(cId[i]) + "')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }
            else{
                string str = "DELETE FROM call_centre_pincode WHERE CentreID='" + CentreID + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString());
                var cId = FieldboyID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                for (int i = 0; i < cId.Length; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO call_centre_pincode(Pincode,CentreID,CreatedDate,CreatedBy,FieldboyID)  VALUES('" + Pincode + "','" + CentreID + "',Now(),'" + UserInfo.LoginName + "','" + Convert.ToInt32(cId[i]) + "')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }
            //else
            //{
            //    var cId = FieldboyID.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            //    for (int i = 0; i < cId.Length; i++)
            //    {
            //        StringBuilder sb1 = new StringBuilder();
            //        sb1.Append("update call_centre_pincode set Pincode='" + Pincode + "', CentreID='" + CentreID + "',UpdatedDate=Now(),UpdatedBy='" + UserInfo.LoginName + "',FieldboyID='" + Convert.ToInt32(cId[i]) + "' ");
            //        sb1.Append(" Where  ID='" + Id + "' ");
            //    }
            //}
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            return "0";
        }
    }
}