using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_StoreLocationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string bindcentertype()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE BusinessZoneID IN(" + BusinessZoneID + ") AND IsActive=1 ORDER BY State"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentrecity(string stateid)
    {
        if (stateid != "")
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id,city FROM city_master WHERE stateid iN(" + stateid + ") AND isactive=1 ORDER BY city"));
        }
        else
        {
            return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id,city FROM city_master WHERE isactive=1 ORDER BY city"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindCentreNew(string TypeId, string ZoneId, string StateID, string cityid, string isstorecreated)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(pm.Panel_ID,'#',cm.StateID) CentreID,pm.company_name Centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   WHERE pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

        if (cityid != "")
            sb.Append(" AND cm.cityid IN(" + cityid + ")");

        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

        if (isstorecreated == "1")
        {
            sb.Append(" and pm.Panel_ID not in (select distinct Panel_ID from st_locationmaster )");
        }

        sb.Append(" ORDER BY Centre");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId, string ZoneId, string StateID, string cityid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Panel_ID CentreID,pm.company_name Centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   WHERE pm.IsActive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

        if (cityid != "")
            sb.Append(" AND cm.cityid IN(" + cityid + ")");

        if (TypeId != "")
            sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

        sb.Append(" ORDER BY Centre");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(string centreid, string location, string cpname, string cpno, string cpnoemail, string address, string autoreceive, string autoconsume)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from st_locationmaster where Location='" + location.ToUpper() + "'"));
        if (count > 0)
        {
            return "Location Already Exist";
        }

        if (address == "")
        {
            return "Address is Empty";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_locationmaster(panel_id,Location,ContactPerson,ContactPersonNo,CreatedBy,CreatedDate,ContactPersonEmail,storelocationAddress,stateid,AutoIndentReceivedDay,ConsumeType) values(@panel_id,@Location,@ContactPerson,@ContactPersonNo,@CreatedBy,now(),@ContactPersonEmail,@storelocationAddress,@stateid,@AutoIndentReceivedDay,@ConsumeType)",
                     new MySqlParameter("@panel_id", centreid.Split('#')[0]),
                     new MySqlParameter("@Location", location.ToUpper()),
                     new MySqlParameter("@ContactPerson", cpname.ToUpper()),
                     new MySqlParameter("@ContactPersonNo", cpno.ToUpper()),
                     new MySqlParameter("@CreatedBy", UserInfo.ID),
                     new MySqlParameter("@ContactPersonEmail", cpnoemail),
                     new MySqlParameter("@storelocationAddress", address.ToUpper()),
                     new MySqlParameter("@stateid", centreid.Split('#')[1]),
                     new MySqlParameter("@AutoIndentReceivedDay", autoreceive),
                     new MySqlParameter("@ConsumeType", autoconsume)
                     );
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Location Saved Sucessfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        String Query = "select ConsumeType, AutoIndentReceivedDay, ssm.state, concat(pm.panel_id,'#',sl.stateid)panel_id,pm.company_name Centre,LocationID,Location,sl.ContactPerson,sl.ContactPersonNo,sl.ContactPersonEmail, sl.storelocationAddress,sl.IsActive,CASE WHEN sl.IsActive=1 THEN 'Active' ELSE 'DeActive' END astatus,";
        Query += "(SELECT NAME FROM employee_master WHERE employee_id=sl.CreatedBy)CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y') CreatedDate FROM st_locationmaster sl ";
        Query += " INNER JOIN f_panel_master pm on pm.`panel_id`=sl.`panel_id`  ";
        Query += " INNER JOIN state_master ssm on ssm.`id`=sl.`stateid`  ";
        if (ZoneId != "")
            Query += " AND ssm.BusinessZoneID IN(" + ZoneId + ")";
        if (StateID != "")
            Query += " AND ssm.id IN(" + StateID + ")";
        Query += " where sl.isactive=1 ";
        if (centreid != "0" && centreid != "null")
        {
            Query += " and sl.panel_id=" + centreid;
        }
        Query += " ORDER BY Centre,location DESC";
        using (DataTable dt = StockReports.GetDataTable(Query))
        {
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = true, response = JsonConvert.SerializeObject(dt) });
            else
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
    }


    [WebMethod(EnableSession = true)]
    public static string UpdateData(string centreid, string location, string cpname, string cpno, string locid, string isactive, string cpnoemail, string address, string autoreceive, string autoconsume)
    {

        if (centreid == "0" || centreid == "")
        {
            return "Please Select Centre";
        }
        int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from st_locationmaster where Location='" + location.ToUpper() + "' and LocationID<>'" + locid + "'"));
        if (count > 0)
        {
            return "Location Already Exist";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_locationmaster set panel_id=@panel_id,Location=@Location,ContactPerson=@ContactPerson,ContactPersonNo=@ContactPersonNo,isactive=@isactive,UpdateBy=@UpdateBy,UpdatedDate=now(),ContactPersonEmail=@ContactPersonEmail,storelocationAddress=@storelocationAddress,AutoIndentReceivedDay=@AutoIndentReceivedDay,ConsumeType=@ConsumeType where LocationID=@LocationID",
                     new MySqlParameter("@panel_id", centreid.Split('#')[0]),
                     new MySqlParameter("@Location", location.ToUpper()),
                     new MySqlParameter("@ContactPerson", cpname.ToUpper()),
                     new MySqlParameter("@ContactPersonNo", cpno.ToUpper()),
                     new MySqlParameter("@isactive", isactive),
                     new MySqlParameter("@UpdateBy", UserInfo.ID), new MySqlParameter("@LocationID", locid), new MySqlParameter("@ContactPersonEmail", cpnoemail), new MySqlParameter("@storelocationAddress", address), new MySqlParameter("@AutoIndentReceivedDay", autoreceive), new MySqlParameter("@ConsumeType", autoconsume)
                     );
            tnx.Commit();

            return JsonConvert.SerializeObject(new { status = true, response = "Location Updated Sucessfully" });
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ExportToExcel()
    {

        DataTable dt = StockReports.GetDataTable(@"SELECT panel_id,(select state from state_master where id=sl.stateid)State,(SELECT company_name FROM f_panel_master WHERE panel_id=sl.panel_id) Centre,
LocationID,Location,AutoIndentReceivedDay,ContactPerson,ContactPersonNo,storelocationAddress,CASE WHEN IsActive=1 THEN 'Active' ELSE 'DeActive' END IsActive,case when ConsumeType=1 then 'AutoConsumeOn' else 'AuotConsumeOff' end AuotConsumeStatus,
(SELECT NAME FROM employee_master WHERE employee_id=sl.CreatedBy)CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y') CreatedDate,
(SELECT NAME FROM employee_master WHERE employee_id=sl.UpdateBy)UpdateBy,DATE_FORMAT(UpdatedDate,'%d-%b-%Y') UpdatedDate
FROM st_locationmaster sl where sl.isactive=1 ORDER BY Centre,Location ");

        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "StoreLocationMaster";
            return JsonConvert.SerializeObject(new { status = true });
        }
        else
        {
            return JsonConvert.SerializeObject(new { status = false });
        }
    }


}