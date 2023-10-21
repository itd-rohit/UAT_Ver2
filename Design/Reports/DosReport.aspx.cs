using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_DosReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddepartmet();          
            bindcentre();       
            BindField();
        }
    }
    void bindcentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            ddlcentretype.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, " select ID,Type1 from centre_type1master Where IsActive=1 order by Type1").Tables[0];
            ddlcentretype.DataValueField = "id";
            ddlcentretype.DataTextField = "type1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));

            int CenterTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select type1ID FROM centre_master WHERE CentreID=@CentreID",
                new MySqlParameter("@CentreID", UserInfo.Centre)));
            if (CenterTypeID != 0)
            {
                ddlcentretype.SelectedIndex = ddlcentretype.Items.IndexOf(ddlcentretype.Items.FindByValue(Util.GetString( CenterTypeID)));
                
                                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "$bindcentre();", true);

            }
        }
        catch (Exception ex)
        {

        }
        finally
        {
            con.Close();
            con.Dispose();

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
    
    [WebMethod(EnableSession = true)]
    public static string searchdataexcel( string centreid,  string departmentid, string FldList)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string selectQuery = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  CONCAT('SELECT ', GROUP_CONCAT(REPLACE(ColumnValue,'$','') ))ColumnValue FROM dosreport_column WHERE ID IN (" + FldList + ")").ToString();

            sb.Append(selectQuery);
            sb.Append(" FROM investigation_master im ");
            sb.Append(" inner join f_itemmaster immm on immm.type_id=im.investigation_id");
            sb.Append(" inner join f_subcategorymaster smmm on smmm.SubCategoryID=immm.SubCategoryID");
            if (departmentid != "0")
                sb.Append(" and smmm.SubCategoryID=@deptid ");
            sb.Append(" inner join investigation_observationtype io on io.investigation_id=im.investigation_id");
            
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
                
                new MySqlParameter("@centreid", centreid),
                
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
    public static string bindCentre(string TypeId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT centreid,centre FROM centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID) or cm.CentreID =@CentreID) and cm.isActive=1 AND Type1Id =@TypeID order by cm.centre",
                              new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@TypeID", TypeId)).Tables[0]);

          
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
}