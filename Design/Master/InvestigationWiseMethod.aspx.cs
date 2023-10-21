using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Design_Master_InvestigationWiseMethod : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddepartmet();
           // bindinvestigation();
            bindcentre();
            bindmachine();
            BindField();
        }
    }
    
    void BindField()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(ID,'#',IsDefault)ID,ColumnName,ColumnValue,IsDefault FROM DOSReport_column WHERE IsActive=1"))
        {
            var aaa = dt.Columns["ID"].DataType;
            List<colectionReport> CollectionList = dt.AsEnumerable().Select(i => new colectionReport
            {
                ID = i.Field<string>("ID"),
                ColumnName = i.Field<string>("ColumnName"),
                ColumnValue = i.Field<string>("ColumnValue")
            }).ToList();
           
            if (dt.Rows.Count > 0)
            {
                chlfield.DataSource = CollectionList;
                chlfield.DataTextField = "ColumnName";
                chlfield.DataValueField = "ID";
                chlfield.DataBind();
                foreach (ListItem li in chlfield.Items.Cast<ListItem>())
                {
                    li.Attributes.Add("class", "chk");
                    if (li.Value.Split('#')[1] == "1")
                    {
                        li.Attributes.Add("class", "chk chkDefault");
                        li.Selected = true;
                    }
                }
            }
        }
    }
    public class colectionReport
    {
        public string ID { get; set; }
        public string ColumnName { get; set; }
        public string ColumnValue { get; set; }
        public int IsDefault { get; set; }
    }
    void binddepartmet()
    {
        ddldepartment.DataSource = StockReports.GetDataTable(@"SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE `categoryId`='LSHHI3' AND active=1 ORDER BY NAME");
        ddldepartment.DataValueField = "subcategoryid";
        ddldepartment.DataTextField = "NAME";
        ddldepartment.DataBind();
        ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));
    }
    void bindinvestigation()
    {
        ddlinvestigation.DataSource = StockReports.GetDataTable(@"SELECT investigation_id,CONCAT(testcode,' ~ ',NAME) invname FROM investigation_master ORDER BY NAME");
        ddlinvestigation.DataValueField = "investigation_id";
        ddlinvestigation.DataTextField = "invname";
        ddlinvestigation.DataBind();
        ddlinvestigation.Items.Insert(0, new ListItem("Select Test", "0"));

    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTestMaster(string department)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (department == "0")
            {
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT investigation_id,CONCAT(testcode,' ~ ',NAME) invname FROM investigation_master ORDER BY NAME").Tables[0];
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT im.investigation_id,CONCAT(im.testcode,' ~ ',im.NAME) invname FROM investigation_master im inner join f_itemmaster imm on imm.type_id=im.investigation_id and  imm.subcategoryid=@deptid ORDER BY invname",
                    new MySqlParameter("@deptid",department)).Tables[0];
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    void bindcentre()
    {
        ddlcentretype.DataSource = StockReports.GetDataTable(@" select ID,Type1 from centre_type1master Where IsActive=1 order by Type1");
        ddlcentretype.DataValueField = "id";
        ddlcentretype.DataTextField = "type1";
        ddlcentretype.DataBind();
        ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));

    }
    void bindmachine()
    {
        ddlmachine.DataSource = StockReports.GetDataTable(@"SELECT id,NAME FROM macmaster ORDER BY NAME");
        ddlmachine.DataValueField = "id";
        ddlmachine.DataTextField = "NAME";
        ddlmachine.DataBind();
        ddlmachine.Items.Insert(0, new ListItem("Select Machine", "0"));



    }
    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con,CommandType.Text,"SELECT centreid,centre FROM centre_master   WHERE centreid IN (SELECT DISTINCT testcentreid FROM `patient_labinvestigation_opd`) and Type1Id =@TypeID ORDER BY centre"
                ,new MySqlParameter ("@TypeID",TypeId)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
            
    }
    
    
    [WebMethod(EnableSession = true)]
    public static string searchdataexcel(string investigationid, string centreid, string machine, string departmentid, string FldList)
    {
StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string selectQuery = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  CONCAT('SELECT ', GROUP_CONCAT(REPLACE(ColumnValue,'$','') ))ColumnValue FROM dosreport_column WHERE ID IN (" + FldList + ")").ToString();
            
            sb.Append( selectQuery);
            sb.Append(" FROM investigation_master im ");
            sb.Append(" inner join f_itemmaster immm on immm.type_id=im.investigation_id");
            sb.Append(" inner join f_subcategorymaster smmm on smmm.SubCategoryID=immm.SubCategoryID");
            if (departmentid != "0")
                sb.Append(" and smmm.SubCategoryID=@deptid ");
            sb.Append(" inner join investigation_observationtype io on io.investigation_id=im.investigation_id");
            if (investigationid != "0")
                sb.Append(" and im.investigation_id=@invid ");
            sb.Append(" inner join investigations_sampletype ist on ist.investigation_id=im.investigation_id and isdefault=1");
            sb.Append(" inner join sampleType_master sm on sm.id=ist.sampletypeid");
            sb.Append(" inner join observationtype_master iom on iom.observationtype_id=io.observationtype_id");
            sb.Append(" INNER JOIN centre_master cm  ");
            if (centreid != "")
                sb.Append(" on cm.CentreID =@centreid ");

            sb.Append(" left join investiagtion_delivery id on id.investigation_id=im.investigation_id and id.centreid=cm.CentreID");

            sb.Append(" left join test_centre_mapping tcm on tcm.Investigation_ID=im.Investigation_ID and tcm.Booking_Centre=cm.`CentreID`");
            sb.Append(" left join investigations_outsrclab iol on iol.Investigation_ID=im.Investigation_ID and iol.CentreID=cm.`CentreID`");

            sb.Append(" left JOIN investigation_centre_method icm ON icm.`investigationid`=im.`Investigation_Id` ");
            sb.Append(" left JOIN macmaster mac ON mac.`ID`=icm.`machineid` ");
            if (machine != "0")
                sb.Append(" and mac.id=@machine");

            StringBuilder sbN = new StringBuilder();
            if (selectQuery.Contains("cm.centre"))
                sbN.Append(" cm.centre");
            if (selectQuery.Contains("iom.name")) //Dept
                sbN = sbN.ToString() == "" ? sbN.Append(" iom.name") : sbN.Append(" ,iom.name");
            if (selectQuery.Contains("im.TestCode"))
                sbN = sbN.ToString() == "" ? sbN.Append(" im.TestCode") : sbN.Append(" ,im.TestCode");
            if (selectQuery.Contains("im.name")) //testName
                sbN = sbN.ToString() == "" ? sbN.Append(" im.name") : sbN.Append(" , im.name");

            if (selectQuery.Contains("IFNULL(mac.name,'') MachineName")) //MachineName
                sbN = sbN.ToString() == "" ? sbN.Append(" mac.name ") : sbN.Append(" , mac.name ");

            if (sbN.ToString() != "")
            {
                sb.Append(" order by " + sbN.ToString());
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@invid", investigationid),
                new MySqlParameter("@centreid",centreid),
                new MySqlParameter("@machine",machine),
                new MySqlParameter("@deptid", departmentid)).Tables[0])
                {
                    if (dt.Rows.Count > 0)
                    {
                        
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


                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "DOS_Data";
                        return JsonConvert.SerializeObject(new { status = true, response = 1 });

                    }

                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "No Record Found !" });
                    }
        }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string searchdata(string investigationid, string centreid, string machine, string departmentid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT smmm.name deptname, icm.id, cm.centre,im.`TestCode`,im.name TestName,ist.SampleTypename,sm.Container ,sm.ColorName,mac.name MachineName,icm.`method` ");
            sb.Append(" ,ifnull(id.bookingcutoff,'')bookingcutoff,ifnull(id.sracutoff,'')sracutoff,ifnull(id.reportingcutoff,'')reportingcutoff,ifnull(concat(id.testprocessingday ,' ',id.tattype),'') Testprocessingday_DayType, ");
            sb.Append(" CONCAT(IF(IFNULL(Sun_Proc,0)=0,'','Sun,'),IF(IFNULL(Mon_Proc,0)=0,'','Mon,'),IF(IFNULL(Tue_Proc,0)=0,'','Tue,'),IF(IFNULL(Wed_Proc,0)=0,'','Wed,'),IF(IFNULL(Thu_Proc,0)=0,'','Thu,'),IF(IFNULL(Fri_Proc,0)=0,'','Fri,'),IF(IFNULL(Sat_Proc,0)=0,'','Sat')) Processingdays, ");
            sb.Append(" CONCAT(IF(IFNULL(Sun,0)=0,'','Sun,'),IF(IFNULL(Mon,0)=0,'','Mon,'),IF(IFNULL(Tue,0)=0,'','Tue,'),IF(IFNULL(Wed,0)=0,'','Wed,'),IF(IFNULL(Thu,0)=0,'','Thu,'),IF(IFNULL(Fri,0)=0,'','Fri,'),IF(IFNULL(Sat,0)=0,'','Sat')) ReportDeliverydays ");
            sb.Append(" ,'' TotalTATAfterBookingCutoff");
            sb.Append(" ,'' TotalTATAfterSRACutoff");
            sb.Append(" ,ifnull(date_format(id.updatedate,'%d-%m-%Y %h:%i'),'') Last_TAT_modified_Date,ifnull(id.username,'') Last_TAT_modified_by ");
            sb.Append(" FROM investigation_centre_method icm ");
            sb.Append(" INNER JOIN investigation_master im ON icm.`investigationid`=im.`Investigation_Id` ");
            sb.Append(" inner join f_itemmaster immm on immm.type_id=im.investigation_id");
            sb.Append(" inner join f_subcategorymaster smmm on smmm.SubCategoryID=immm.SubCategoryID");

            if (departmentid != "0")
                sb.Append(" and smmm.SubCategoryID=@deptid ");

            if (investigationid != "0")
                sb.Append(" and im.investigation_id=@invid ");

            sb.Append(" inner join investigations_sampletype ist on ist.investigation_id=im.investigation_id and isdefault=1");
            sb.Append(" inner join sampleType_master sm on sm.id=ist.sampletypeid");




            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=icm.`centreid` ");
            if (centreid != "")
                sb.Append(" and cm.CentreID = @centreid ");


            sb.Append(" left join investiagtion_delivery id on id.investigation_id=im.investigation_id and id.centreid=cm.CentreID");


            sb.Append(" INNER JOIN macmaster mac ON mac.`ID`=icm.`machineid` ");
            if (machine != "0")
                sb.Append(" and mac.id=@machine ");

            sb.Append(" ORDER BY centre,testcode,testname,machinename ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@invid", investigationid),
                   new MySqlParameter("@centreid", centreid),
                   new MySqlParameter("@machine", machine),
                   new MySqlParameter("@deptid", departmentid)).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = true, response = dt });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, response = ex.GetBaseException() });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string savedata(string investigationid, string centreid, string machine)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from investigation_centre_method where investigationid=@invid and centreid=@centreid and machineid=@machine",
                 new MySqlParameter("@invid", investigationid),
                   new MySqlParameter("@centreid", centreid),
                   new MySqlParameter("@machine", machine));
                  // new MySqlParameter("@method", method));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  investigation_centre_method(investigationid,centreid,machineid,method,insertdate,insertby) values (@invid,@centreid ,@machine,@method,now(),'" + UserInfo.ID + "') "
                   ,new MySqlParameter("@invid", investigationid),
                   new MySqlParameter("@centreid", centreid),
                   new MySqlParameter("@machine", machine));
                  // new MySqlParameter("@method", method));

             tnx.Commit();
             return JsonConvert.SerializeObject(new { status = true, response = 1 });
       
        }
            
        
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true,response = ex.GetBaseException() });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod(EnableSession = true)]
    public static string editdata(string id,string method)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
        MySqlHelper.ExecuteNonQuery(con,CommandType.Text,"update investigation_centre_method set method=@method,updatedate=now(),updateby=@UserID where id=@ID"
            ,new MySqlParameter("@method",method)
            , new MySqlParameter("@UserID", UserInfo.ID)
            , new MySqlParameter("@ID", id));
        return JsonConvert.SerializeObject(new { status = true, response = '1' });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string deletedata(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from investigation_centre_method where id=@ID",
             new MySqlParameter("@ID", id));
            return JsonConvert.SerializeObject(new { status = true, response = '1' });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}