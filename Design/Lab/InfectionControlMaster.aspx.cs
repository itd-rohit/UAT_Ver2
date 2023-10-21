using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_InfectionControlMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindInvestigation()
    {
        StringBuilder sb = new StringBuilder();
        string str = "SELECT inv.`Investigation_Id`,NAME FROM `investigation_master` inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` WHERE im.`IsActive`=1  ORDER BY inv.`Name` ";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindObservation(string InvestigationId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT Distinct lom.LabObservation_Id,lom.Name FROM `labobservation_master` lom ");
        sb.Append("  INNER JOIN labobservation_investigation loi ON lom.LabObservation_Id=loi.LabObservation_Id ");
        sb.Append("  WHERE lom.IsActive=1 AND lom.Name <> '' ");
        if (InvestigationId != "")
        {
            InvestigationId = "'" + InvestigationId.Replace(",", "','") + "'";
            sb.Append("  AND loi.Investigation_Id IN (" + InvestigationId + ")  ");
        }
        sb.Append("  ORDER BY lom.Name  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindExistsObservation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT lom.LabObservation_Id,lom.Name FROM `labobservation_master` lom ");
        sb.Append("  INNER JOIN investigation_master_infectioncontrol icm ON icm.LabObservation_Id=lom.LabObservation_Id ");
        sb.Append("  WHERE lom.IsActive=1 AND lom.Name <> '' AND icm.IsActive=1 ");
        sb.Append("  ORDER BY lom.Name  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string AddObservation(string LabObservationId)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    string[] strArr = LabObservationId.Split(',');
                    for (int i = 0; i < strArr.Length; i++)
                    {
                        int cnt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM investigation_master_infectioncontrol WHERE LabObservation_Id='" + strArr[i] + "' AND IsActive=1").ToString());
                        if (cnt == 0)
                        {
                            string str = "INSERT INTO investigation_master_infectioncontrol(LabObservation_Id,IsActive,AddedOn,AddedBy) values('" + strArr[i] + "',1,NOW(),'" + UserInfo.ID + "')";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                        }
                    }
                    Tnx.Commit();
                    con.Close();
                    return "1";
                }
                catch
                {
                    Tnx.Rollback();
                    con.Close();
                    return "0";
                }
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RemoveObservation(string LabObservationId)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    string[] strArr = LabObservationId.Split(',');
                    for (int i = 0; i < strArr.Length; i++)
                    {
                        string str = "UPDATE investigation_master_infectioncontrol SET IsActive=0, DeletedBy='" + UserInfo.ID + "',DeletedOn=NOW() WHERE LabObservation_Id='" + strArr[i] + "' AND IsActive=1";
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                    }
                    Tnx.Commit();
                    con.Close();
                    return "1";
                }
                catch
                {
                    Tnx.Rollback();
                    con.Close();
                    return "0";
                }
            }
        }
    }
}