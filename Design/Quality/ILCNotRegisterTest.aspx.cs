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

public partial class Design_Quality_ILCNotRegisterTest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddldepartment.DataSource = StockReports.GetDataTable("SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 and subcategoryid NOT IN (15,18) ORDER BY NAME  ");
            ddldepartment.DataValueField = "subcategoryid";
            ddldepartment.DataTextField = "NAME";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));



            txtcurrentyear.Text = DateTime.Now.Year.ToString();
            ddlcurrentmonth.Items.Add(new ListItem(DateTime.Now.ToString("MMMM"), DateTime.Now.Month.ToString()));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE  centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and centreid in (select distinct centreid from f_login where employeeid='" + UserInfo.ID + "') ORDER BY centre"));


    }

    [WebMethod]
    public static string bindilc(string department, string processingcentre, string all)
    {

        if (department == "1")
        {

            if (all == "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT DISTINCT a.CentreID centreid,cm.`Centre` centre FROM centre_master cm  ");
                sb.Append(" INNER JOIN ( ");
                sb.Append(" SELECT tcm.test_centre CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre  =" + processingcentre + " AND tcm.test_centre <>" + processingcentre + "  ");
                sb.Append(" UNION");
                sb.Append(" SELECT tcm.test_centre2 CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre =" + processingcentre + " AND tcm.test_centre2 <>" + processingcentre + " ");
                sb.Append(" UNION ");
                sb.Append(" SELECT  tcm.test_centre3 CentreID FROM test_centre_mapping tcm WHERE tcm.booking_centre=" + processingcentre + " AND tcm.test_centre3 <>" + processingcentre + " ");
                sb.Append(" )a ON a.CentreID=cm.`CentreID` AND cm.`isActive`=1");

                return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre centre FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) order by centre"));
            }


        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT labid centreid,ilclabname  centre FROM qc_ilclabmaster WHERE isactive=1 order by centreid"));

        }


    }

    [WebMethod]
    public static string bindtest(string department)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT type_id,CONCAT(testcode,' ~ ',typename) typename FROM f_itemmaster WHERE subcategoryid='" + department + "' AND isactive=1 ORDER BY typename ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string bindparameter(string test)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT DISTINCT  im.`LabObservation_ID`,concat(im.name,'#','Observation') `name`  FROM `labobservation_investigation` loi 
INNER JOIN labobservation_master im ON loi.`labObservation_ID`=im.`LabObservation_ID` AND im.`IsActive`=1 AND im.name<>'' and loi.child_flag=0
INNER JOIN investigation_master imi ON imi.investigation_id=loi.investigation_id AND imi.ReportType=1
WHERE loi.investigation_id IN (" + test + ") UNION ALL SELECT investigation_id LabObservation_ID,Concat(name,'#','Investigation') `name` FROM investigation_master  WHERE  investigation_id IN (" + test + ") AND reporttype<>1 ORDER BY NAME");


        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }




    [WebMethod]
    public static string SaveData(List<ILCDataMonth> ilcdata)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            foreach (ILCDataMonth ilc in ilcdata)
            {

                if (ilc.SavedID == "")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_ilcparametermapping_special ");
                    sb.Append("  (ProcessingLabID,ProcessingLabName,ILCLabTypeID,ILCLabType,ILCLabID,ILCLabName, ");
                    sb.Append("   TestType,TestID,TestName,AcceptablePer,Rate,Cmonth,Cyear, EntryDate,EntryByID,EntryByName) ");
                    sb.Append("  VALUES (@ProcessingLabID,@ProcessingLabName,@ILCLabTypeID,@ILCLabType,@ILCLabID,@ILCLabName, ");
                    sb.Append("             @TestType,@TestID,@TestName,@AcceptablePer,@Rate,@CMonth,@CYear,@EntryDate,@EntryByID,@EntryByName); ");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@ProcessingLabID", ilc.ProcessingLabID),
                       new MySqlParameter("@ProcessingLabName", ilc.ProcessingLabName),
                       new MySqlParameter("@ILCLabTypeID", ilc.ILCLabTypeID),
                       new MySqlParameter("@ILCLabType", ilc.ILCLabType),
                       new MySqlParameter("@ILCLabID", ilc.ILCLabID),
                       new MySqlParameter("@ILCLabName", ilc.ILCLabName),
                       new MySqlParameter("@TestType", ilc.TestType),
                       new MySqlParameter("@TestID", ilc.TestID),
                       new MySqlParameter("@TestName", ilc.TestName),
                       new MySqlParameter("@AcceptablePer", ilc.AcceptablePer),
                       new MySqlParameter("@Rate", ilc.Rate),
                       new MySqlParameter("@CMonth", ilc.CMonth),
                       new MySqlParameter("@CYear", ilc.CYear),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName)
                       );
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" update qc_ilcparametermapping_special set AcceptablePer=@AcceptablePer, Rate=@Rate,Cmonth=@Cmonth,cyear=@cyear,updatedate=@updatedate ");
                    sb.Append(" ,updatebyid=@updatebyid,updatebyname=@updatebyname where id=@id");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@AcceptablePer", ilc.AcceptablePer),
                     new MySqlParameter("@Rate", ilc.Rate),
                     new MySqlParameter("@Cmonth", ilc.CMonth),
                     new MySqlParameter("@cyear", ilc.CYear),
                
                     new MySqlParameter("@id", ilc.SavedID),
                     new MySqlParameter("@updatedate", Util.GetDateTime(DateTime.Now)),
                     new MySqlParameter("@updatebyid", UserInfo.ID),
                     new MySqlParameter("@updatebyname", UserInfo.LoginName)
                     );

                }

            }


            return "1";
        }
        catch (Exception ex)
        {





            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {

            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string getalldata(string processingcentre,string month,string year)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT id, ProcessingLabID,ProcessingLabName,ILCLabTypeID,ILCLabType,ILCLabID,ILCLabName,TestType
             ,TestID,TestName,Rate,CMonth,CYear,AcceptablePer,MONTHNAME(STR_TO_DATE(CMonth,'%m’')) CMonthName
              FROM qc_ilcparametermapping_special where isactive=1 and ProcessingLabID =" + processingcentre + " and cmonth=" + month + " and cyear="+year+" "));
    }

    [WebMethod]
    public static string deletedata(string id)
    {
        StockReports.ExecuteDML("update  qc_ilcparametermapping_special set isactive=0,deletedate=now(),deletebyid='" + UserInfo.ID + "',deletebyname='" + UserInfo.LoginName + "' where id='" + id + "' ");
        return "1";

    }
    [WebMethod]
    public static string exporttoexcel(string processingcentre, string month, string year)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT id, ProcessingLabID,ProcessingLabName,ILCLabType,ILCLabID,ILCLabName,TestType, ");
        sb.Append("  TestID,TestName,Rate,MONTHNAME(STR_TO_DATE(CMonth,'%m’')) Month, CYear Year, ");
        sb.Append("  IF(IsActive=1,'Active','Deactive')`Status`,DATE_FORMAT(EntryDate,'%d-%b-%y')EntryDate,EntryByName, ");
        sb.Append("  ifnull(DATE_FORMAT(updatedate,'%d-%b-%y'),'') UpdateDate,ifnull(updatebyname,'')UpdateByName");
        sb.Append("  FROM qc_ilcparametermapping_special where isactive=1 and ProcessingLabID =" + processingcentre + " and cmonth=" + month + " and cyear=" + year + "");

        DataTable dt = StockReports.GetDataTable(sb.ToString());





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
            HttpContext.Current.Session["ReportName"] = "ILCLabParameterMappingMonth";
            return "true";
        }
        else
        {
            return "false";
        }


    }





}


public class ILCDataMonth
{
    public string SavedID { get; set; }
    public string ProcessingLabID { get; set; }
    public string ProcessingLabName { get; set; }

    public string ILCLabTypeID { get; set; }
    public string ILCLabType { get; set; }

    public string ILCLabID { get; set; }
    public string ILCLabName { get; set; }

    public string TestType { get; set; }
    public string TestID { get; set; }
    public string TestName { get; set; }
    public string Rate { get; set; }
    public string AcceptablePer { get; set; }
    public string CMonth { get; set; }
    public string CYear { get; set; }
    public string Fequency { get; set; }

}