using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for MapOrganism_Antibiotics
/// </summary>
public class MapOrganism_Antibiotics
{
    public MapOrganism_Antibiotics()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable GetObservation_Data(string OrganismID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT om.OrganismName, lom.Name ObsName, lom.LabObservation_ID,loa.DefaultReading  FROM labobservation_master LOM  ");
        sb.Append("  INNER JOIN labobservation_organism_antibiotics LOA ON LOM.LabObservation_ID=LOA.LabObservation_ID  ");
        sb.Append("  INNER JOIN organism_master om ON om.OrganismID=loa.OrganismID ");
        sb.Append("  WHERE LOA.OrganismID='" + OrganismID + "' ORDER BY loa.PrintOrder ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public string SaveObservation(string OrganismID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string str = "";
            int MaxPrintOrder = 0;
            MaxPrintOrder = Util.GetInt(StockReports.ExecuteScalar("Select max(printOrder) from labobservation_organism_antibiotics where OrganismID= '" + OrganismID + "'"));
            str = " INSERT INTO labobservation_organism_antibiotics(OrganismID,LabObservation_ID,PrintOrder,DefaultReading,UserID) VALUES ('" + OrganismID + "','" + ObservationId + "'," + MaxPrintOrder + "+1,'S','" + HttpContext.Current.Session["ID"].ToString() + "'); ";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
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

    public string RemoveObservation(string OrganismID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from  labobservation_organism_antibiotics where labObservation_ID='" + ObservationId + "'and OrganismID='" + OrganismID + "' ");
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

    public string SaveMapping(string OrganismID, string ObsData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= ObservationId|Prefix|SampleTypeName|SampleTypeID|Method|Header|IsCritical#
            ObsData = ObsData.TrimEnd('#');

            string str = "";
            int len = Util.GetInt(ObsData.Split('#').Length);
            string[] Data = new string[len];
            Data = ObsData.Split('#');
            for (int i = 0; i < len; i++)
            {
                // str = "Update labobservation_investigation Set printOrder=" + (Util.GetInt(i) + 1) + ",Prefix='" + Util.GetString(Data[i].Split('|')[1]) + "',SampleTypeName='" + Util.GetString(Data[i].Split('|')[2]) + "',SampleTypeID='" + Util.GetString(Data[i].Split('|')[3]) + "',MethodName='" + Util.GetString(Data[i].Split('|')[4]) + "',Child_Flag='" + Data[i].Split('|')[5].ToString() + "',IsCritical='" + Data[i].Split('|')[6].ToString() + "',UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateName='" + HttpContext.Current.Session["LoginName"].ToString() + "',UpdateRemarks='',UpdateDate='" + System.DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "' where labObservation_ID='" + Data[i].Split('|')[0].ToString() + "' and Investigation_Id='" + InvestigationID + "' ";
                str = "UPDATE labobservation_organism_antibiotics SET PrintOrder=" + (Util.GetInt(i) + 1) + ", DefaultReading='" + Util.GetString(Data[i].Split('|')[1]) + "', UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "', UpdateName='" + HttpContext.Current.Session["LoginName"].ToString() + "',UpdateRemarks='',UpdateDate='" + System.DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss") + "' WHERE labObservation_ID='" + Data[i].Split('|')[0].ToString() + "'AND OrganismID='" + OrganismID + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
            }

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