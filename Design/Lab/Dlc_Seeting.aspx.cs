using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Lab_Dlc_Seeting : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindinvestigation();
        }
    }



    private void bindinvestigation()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            ddlInvestigation.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT   CONCAT(ivm.`Investigation_Id`,' ~ ',ivm.`Name`)NAME, ivm.`Investigation_Id` id FROM   `investigation_master` ivm    INNER JOIN f_itemmaster im ON im.`Type_ID`=ivm.`Investigation_Id`    WHERE im.`IsActive`=1  AND im.subcategoryid<>'LSHHI44'  ORDER BY NAME").Tables[0];
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem("All Investigation", ""));
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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string  GetObservationData(string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();    
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select IM.Investigation_Id,im.Name, LOM.LabObservation_ID,Concat(Loi.Prefix,LOM.Name) as ObsName,LOM.`dlcCheck`  from investigation_master IM inner join labobservation_investigation LOI");
            sb.Append(" on IM.Investigation_Id=LOI.Investigation_Id inner join labobservation_master LOM on");
            sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID and  IM.Investigation_Id='" + InvestigationID + "' ");
            sb.Append(" order by loi.printOrder");

          
           return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
          

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveObservationData(string ItemData, string Itemdata1)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
           // string item1="";

           


            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
           

            for (int i = 0; i < len; i++)
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE labobservation_master SET dlcCheck=1 WHERE LabObservation_ID =@LabObservation_ID",
          
              new MySqlParameter("@LabObservation_ID", Item[i].Split('|')[0].ToString()));
           
            }

            // DlcCheck=0

            string item1 = Itemdata1.TrimEnd('#');

            string str1 = string.Empty;
            int len1 = Util.GetInt(item1.Split('#').Length);
            string[] Item1 = new string[len1];
            Item1 = item1.Split('#');

            for (int i = 0; i < len1; i++)
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE labobservation_master SET dlcCheck=0 WHERE LabObservation_ID =@LabObservation_ID",

              new MySqlParameter("@LabObservation_ID", Item1[i].Split('|')[0].ToString()));

            }

            Tnx.Commit();
            return "1";
        }
                   
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
      
    }

    [WebMethod]
    public static string UpdateStatus(string LabObservation_ID, string status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE labobservation_master SET dlcCheck=@status WHERE LabObservation_ID =@LabObservation_ID",
                        new MySqlParameter("@status", status),
                        new MySqlParameter("@LabObservation_ID", LabObservation_ID));
            return status;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return status;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}


