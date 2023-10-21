using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_ControlLotMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            ddldepartment.DataSource = StockReports.GetDataTable("SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 ORDER BY NAME  ");
            ddldepartment.DataValueField = "subcategoryid";
            ddldepartment.DataTextField = "NAME";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));


            ddlmachine.DataSource = StockReports.GetDataTable("SELECT ID MACHINEID,NAME MACHINENAME FROM MACMASTER where isactive=1 ORDER BY MACHINENAME");
            ddlmachine.DataValueField = "MACHINEID";
            ddlmachine.DataTextField = "MACHINENAME";
            ddlmachine.DataBind();
            ddlmachine.Items.Insert(0, new ListItem("Select Machine", "0"));
        }
    }

    [WebMethod]
    public static string bindcontolprovider()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT DISTINCT `MAnufactureID`,Upper(`ManufactureName`)ManufactureName
 FROM st_itemmaster WHERE `subcategorytypeid` IN (30) ORDER BY `ManufactureName`"));
    }

     [WebMethod]
    public static string bindcontolname(string controlprovider)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT itemid,typename
 FROM st_itemmaster st WHERE `subcategorytypeid` IN (30) and MAnufactureID=" + controlprovider + "   ORDER BY typename"));
    }


    [WebMethod]
    public static string bindbatch(string controlname)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT batchnumber,DATE_FORMAT(`ExpiryDate`,'%d-%b-%Y')ExpiryDate FROM `st_nmstock` WHERE ExpiryDate>=CURRENT_DATE and itemid=" + controlname + ""));
    }



    [WebMethod(EnableSession = true)]
    public static string bindparameter(string parametername,string machineid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.`LabObservation_ID`, TRIM(lom.`Name`) PatameterName  FROM `labobservation_master` lom    ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID  ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machineparam mpm ON mpm.Machine_ParamID=pm.Machine_ParamID   ");
        sb.Append(" INNER JOIN " + Util.getApp("MachineDB") + ".mac_machinemaster mm ON mm.MACHINEID=mpm.MACHINEID AND mm.groupid='" + machineid + "'");
        if (parametername != "")
        {
            sb.Append(" and lom.`Name` like '%" + parametername + "%' GROUP BY lom.`LabObservation_ID`  ORDER BY lom.Name LIMIT 20 ");
        }
        else
        {
            sb.Append("  GROUP BY lom.`LabObservation_ID`  ORDER BY lom.Name ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(string controlprovider, string controlname, string lotnumber, string datestart, string lotexpiry, List<ControlData> controldata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string controlid = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT qc_get_control_id();"));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_controlmaster (ControlID,ControlProvider,ControlName,LotNumber,StartDate,LotExpiry,MachineID,MachineName,Subcategoryid,Subcategoryname,EntryDate,EntryById,EntryByName) values (@ControlID,@ControlProvider,@ControlName,@LotNumber,@StartDate,@LotExpiry,@MachineID,@MachineName,@Subcategoryid,@Subcategoryname,@EntryDate,@EntryById,@EntryByName)",
                new MySqlParameter("@ControlID", controlid.ToUpper()),
                new MySqlParameter("@ControlProvider", controlprovider.ToUpper()),
                new MySqlParameter("@ControlName", controlname.ToUpper()),
                new MySqlParameter("@LotNumber", lotnumber.ToUpper()),
                new MySqlParameter("@StartDate", Util.GetDateTime(datestart).ToString("yyyy-MM-dd")),
                new MySqlParameter("@LotExpiry", Util.GetDateTime(lotexpiry).ToString("yyyy-MM-dd")),
                new MySqlParameter("@MachineID", controldata[0].MachineID),
                new MySqlParameter("@MachineName", controldata[0].MachineName),
                new MySqlParameter("@Subcategoryid", controldata[0].Subcategoryid),
                new MySqlParameter("@Subcategoryname", controldata[0].SubcategoryName),
                new MySqlParameter("@EntryDate",DateTime.Now),
                new MySqlParameter("@EntryById", UserInfo.ID),
                new MySqlParameter("@EntryByName", UserInfo.LoginName)
                );


            

            foreach (ControlData cd in controldata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert qc_controlparameter_detail (ControlID,LabObservation_ID,LabObservation_Name,LevelID,Level,Minvalue,`Maxvalue`,BaseMeanvalue,BaseSDvalue,BaseCVPercentage,Unit,Temperature,Method,EntryDate,EntryByID,EntryByName) values (@ControlID,@LabObservation_ID,@LabObservation_Name,@LevelID,@Level,@Minvalue,@Maxvalue,@BaseMeanvalue,@BaseSDvalue,@BaseCVPercentage,@Unit,@Temperature,@Method,@EntryDate,@EntryByID,@EntryByName)",
                    new MySqlParameter("@ControlID", controlid.ToUpper()),
                    new MySqlParameter("@LabObservation_ID", cd.LabObservation_ID),
                    new MySqlParameter("@LabObservation_Name", cd.LabObservation_Name.ToUpper()),
                    new MySqlParameter("@LevelID", cd.LevelID),
                    new MySqlParameter("@Level", cd.Level),
                    new MySqlParameter("@Minvalue", cd.MinValue),
                    new MySqlParameter("@Maxvalue", cd.MaxValue),
                    new MySqlParameter("@BaseMeanvalue", cd.BaseMeanValue),
                    new MySqlParameter("@BaseSDvalue",cd.BaseSDValue),
                    new MySqlParameter("@BaseCVPercentage", cd.BaseCVPercent),
                    new MySqlParameter("@Unit", cd.Unit),
                    new MySqlParameter("@Temperature", cd.Temperature),
                    new MySqlParameter("@Method", cd.Method),
                    new MySqlParameter("@EntryDate", DateTime.Now),
                    new MySqlParameter("@EntryById", UserInfo.ID),
                    new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }
            tnx.Commit();

            return "1" ;
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return  Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateData(string controlid,string controlprovider, string controlname, string lotnumber, string datestart, string lotexpiry, List<ControlData> controldata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  qc_controlmaster set ControlProvider=@ControlProvider,ControlName=@ControlName,LotNumber=@LotNumber,StartDate=@StartDate,LotExpiry=@LotExpiry,Subcategoryid=@Subcategoryid,Subcategoryname=@Subcategoryname,updatedate=@updatedate,updatebyid=@updatebyid,updatebyname=@updatebyname where ControlID=@ControlID",
                new MySqlParameter("@ControlID", controlid.ToUpper()),
                new MySqlParameter("@ControlProvider", controlprovider.ToUpper()),
                new MySqlParameter("@ControlName", controlname.ToUpper()),
                new MySqlParameter("@LotNumber", lotnumber.ToUpper()),
                new MySqlParameter("@StartDate", Util.GetDateTime(datestart).ToString("yyyy-MM-dd")),
                new MySqlParameter("@LotExpiry", Util.GetDateTime(lotexpiry).ToString("yyyy-MM-dd")),
                new MySqlParameter("@Subcategoryid", controldata[0].Subcategoryid),
                new MySqlParameter("@Subcategoryname", controldata[0].SubcategoryName),
                new MySqlParameter("@updatedate", DateTime.Now),
                new MySqlParameter("@updatebyid", UserInfo.ID),
                new MySqlParameter("@updatebyname", UserInfo.LoginName)
                );




            foreach (ControlData cd in controldata)
            {
                if (cd.SavedID == "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert qc_controlparameter_detail (ControlID,LabObservation_ID,LabObservation_Name,LevelID,Level,Minvalue,`Maxvalue`,BaseMeanvalue,BaseSDvalue,BaseCVPercentage,Unit,Temperature,Method,EntryDate,EntryByID,EntryByName) values (@ControlID,@LabObservation_ID,@LabObservation_Name,@LevelID,@Level,@Minvalue,@Maxvalue,@BaseMeanvalue,@BaseSDvalue,@BaseCVPercentage,@Unit,@Temperature,@Method,@EntryDate,@EntryByID,@EntryByName)",
                        new MySqlParameter("@ControlID", controlid.ToUpper()),
                        new MySqlParameter("@LabObservation_ID", cd.LabObservation_ID),
                        new MySqlParameter("@LabObservation_Name", cd.LabObservation_Name.ToUpper()),
                        new MySqlParameter("@LevelID", cd.LevelID),
                        new MySqlParameter("@Level", cd.Level),
                        new MySqlParameter("@Minvalue", cd.MinValue),
                        new MySqlParameter("@Maxvalue", cd.MaxValue),
                        new MySqlParameter("@BaseMeanvalue", cd.BaseMeanValue),
                        new MySqlParameter("@BaseSDvalue", cd.BaseSDValue),
                        new MySqlParameter("@BaseCVPercentage", cd.BaseCVPercent),
                        new MySqlParameter("@Unit", cd.Unit),
                        new MySqlParameter("@Temperature", cd.Temperature),
                        new MySqlParameter("@Method", cd.Method),
                        new MySqlParameter("@EntryDate", DateTime.Now),
                        new MySqlParameter("@EntryById", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_controlparameter_detail set Minvalue=@Minvalue,`Maxvalue`=@Maxvalue,BaseMeanvalue=@BaseMeanvalue,BaseSDvalue=@BaseSDvalue,BaseCVPercentage=@BaseCVPercentage,Unit=@Unit,Temperature=@Temperature,updatedate=@updatedate,UpdateById=@UpdateById,UpdateByName=@UpdateByName where id=@id",
                      new MySqlParameter("@id", cd.SavedID),
                      new MySqlParameter("@Minvalue", cd.MinValue),
                      new MySqlParameter("@Maxvalue", cd.MaxValue),
                      new MySqlParameter("@BaseMeanvalue", cd.BaseMeanValue),
                      new MySqlParameter("@BaseSDvalue", cd.BaseSDValue),
                      new MySqlParameter("@BaseCVPercentage", cd.BaseCVPercent),
                      new MySqlParameter("@Unit", cd.Unit),
                      new MySqlParameter("@Temperature", cd.Temperature),
                      new MySqlParameter("@Method", cd.Method),
                      new MySqlParameter("@updatedate", DateTime.Now),
                      new MySqlParameter("@UpdateById", UserInfo.ID),
                      new MySqlParameter("@UpdateByName", UserInfo.LoginName));
                }
            }
            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string deletedata(string id)
    {



        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(1) from qc_control_centre_mapping where ControlID='" + id + "'")) == 0)
            //{
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_controlmaster set IsActive=0,updatedate=now(),updatebyid=" + UserInfo.ID + ",updatebyname='" + UserInfo.LoginName + "' where ControlID='" + id + "' ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_controlparameter_detail set IsActive=0,updatedate=now(),updatebyid=" + UserInfo.ID + ",updatebyname='" + UserInfo.LoginName + "' where ControlID='" + id + "' ");
                tnx.Commit();

                return "1";
            //}
            //else
            //{
            //    tnx.Commit();

            //    return "Control Already Mapped With Center You can't Deactive it";
            //}
              
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
       
        
    }


    [WebMethod(EnableSession = true)]
    public static string deletedataparameter(string id)
    {
        StockReports.ExecuteDML("update qc_controlparameter_detail set IsActive=0,updatedate=now(),updatebyid=" + UserInfo.ID + ",updatebyname='" + UserInfo.LoginName + "' where id in("+id.TrimEnd(',')+") ");
        return "1";
    }
    

    [WebMethod(EnableSession = true)]
    public static string bindparametersaved(string id)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT id,controlid,LabObservation_Name,LevelID,LEVEL,Minvalue,LabObservation_Id,");
        sb.Append(" `Maxvalue`,BaseMeanvalue,BaseSDvalue,BaseCVPercentage,Unit,");
        sb.Append(" Temperature,Method");
        sb.Append(" FROM `qc_controlparameter_detail` WHERE ControlID= '" + id + "' and IsActive=1");
       
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    [WebMethod(EnableSession = true)]
    public static string getdata(string type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT controlid,`ControlProvider`,controlname,lotnumber,DATE_FORMAT(startdate,'%d-%b-%Y')startdate, ");
        sb.Append(" DATE_FORMAT(LotExpiry,'%d-%b-%Y')LotExpiry,Machineid,machinename,`SubCategoryID`,`SubCategoryName`,");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,EntryByID,EntryByName,");
        sb.Append(" if(LotExpiry>=current_date,if(IsActive=1,'Active','DeActive'),'Expired') IsActive,");
        sb.Append(" if(IsActive=1,'',concat('DeActive Date:- ',DATE_FORMAT(updatedate,'%d-%b-%Y'),'<br/>Deactive By:- ',UpdateByName  ) )Deactivby,");
        sb.Append(" (select group_concat(LabObservation_Name)  FROM `qc_controlparameter_detail` qcd WHERE qcd.ControlID=qc.controlid and qcd.IsActive=1) parameter");

        sb.Append(" FROM qc_controlmaster qc ");
        if (type == "1")
        {
            sb.Append(" where IsActive=1 and LotExpiry>=current_date");
 
        }
        else
        {
            sb.Append(" where LotExpiry<current_date || IsActive=0 ");
        }
        sb.Append("  ORDER BY controlid");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}

public class ControlData
{
    public string SavedID { get; set; }
    public string MachineID { get; set; }
    public string MachineName { get; set; }
    public string Subcategoryid { get; set; }
    public string SubcategoryName { get; set; }
    public string LabObservation_ID { get; set; }
    public string LabObservation_Name { get; set; }
    public string LevelID { get; set; }
    public string Level { get; set; }
    public string MinValue { get; set; }
    public string MaxValue { get; set; }
    public string BaseMeanValue { get; set; }
    public string BaseSDValue { get; set; }
    public string BaseCVPercent { get; set; }
    public string Unit { get; set; }
    public string Temperature { get; set; }
    public string Method { get; set; }
    public string ControlID { get; set; }
}