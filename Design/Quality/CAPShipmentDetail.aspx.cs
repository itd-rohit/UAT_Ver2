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

public partial class Design_Quality_CAPShipmentDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtshipdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtduedate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            ddlcentretype.DataSource = StockReports.GetDataTable(@" SELECT DISTINCT TYPE1id,TYPE1  FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY TYPE1");
            ddlcentretype.DataValueField = "TYPE1id";
            ddlcentretype.DataTextField = "TYPE1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));




        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }


    [WebMethod(EnableSession = true)]
    public static string bindprogram()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT programid,programname FROM `qc_capprogrammaster` WHERE  isactive=1 GROUP BY programid ORDER BY programname"));

    }

    [WebMethod(EnableSession = true)]
    public static string bindprogramdata(string programid)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT programid,programname,description,investigationid,investigationname,departmentname FROM `qc_capprogrammaster` WHERE programid in(" + programid + ") AND isactive=1 order by programid"));

    }
    [WebMethod(EnableSession = true)]
    public static string saveprogrammapping(List<ShipmentDetail> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            // Duplicate
            foreach (ShipmentDetail sd in data)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" insert into qc_capshippingdetail (CentreId,ProgramID,ShipmentNo,ShipDate,DueDate,Mailing,Note,EntryDate,EntryByName,EntryByID)");
                sb.Append(" values ");
                sb.Append(" (@CentreId,@ProgramID,@ShipmentNo,@ShipDate,@DueDate,@Mailing,@Note,@EntryDate,@EntryByName,@EntryByID)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreId", sd.LabID),
                     new MySqlParameter("@ProgramID", sd.ProgramID),
                      new MySqlParameter("@ShipmentNo", sd.ShipMentNo),
                       new MySqlParameter("@ShipDate", Util.GetDateTime(sd.ShipDate).ToString("yyyy-MM-dd")),
                        new MySqlParameter("@DueDate", Util.GetDateTime(sd.DueDate).ToString("yyyy-MM-dd")),
                         new MySqlParameter("@Mailing", sd.Mailing),
                          new MySqlParameter("@Note", sd.Note),
                           new MySqlParameter("@EntryDate", DateTime.Now),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName),
                            new MySqlParameter("@EntryByID", UserInfo.ID));

            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string getprogramlist(string processinglabid)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT qe.id, qe.CentreId,cm.centre,qe.programid,eqm.programname,
GROUP_CONCAT(InvestigationName) testname,qe.EntryByName,DATE_FORMAT(qe.EntryDate,'%d-%b-%Y') entrydatetime,qe.ShipmentNo,DATE_FORMAT(qe.ShipDate,'%d-%b-%Y')ShipDate,DATE_FORMAT(qe.DueDate,'%d-%b-%Y') DueDate,qe.Mailing,qe.Note
 FROM qc_capshippingdetail qe
INNER JOIN centre_master cm ON cm.centreid=qe.CentreId
INNER JOIN `qc_capprogrammaster` eqm ON eqm.programid=qe.programid AND eqm.IsActive=1
WHERE qe.isactive=1 AND qe.CentreId =" + processinglabid + " GROUP BY qe.CentreId,qe.programid"));
    }


    [WebMethod(EnableSession = true)]
    public static string deletedata(string id)
    {
        StockReports.ExecuteDML("update  qc_capshippingdetail set isactive=0,UpdateDate=now(),UpdateByID='" + UserInfo.ID + "',UpdateByName='" + UserInfo.LoginName + "' where id='" + id + "' ");
        return "1";
    }



    [WebMethod]
    public static string exporttoexcel(string processinglabid)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append("  SELECT qe.id, qe.CentreId,cm.centre,qe.programid,eqm.programname,");
        sb.Append(" InvestigationName testname, ");
        sb.Append(" qe.ShipmentNo,DATE_FORMAT(qe.ShipDate,'%d-%b-%Y')ShipDate,DATE_FORMAT(qe.DueDate,'%d-%b-%Y') DueDate,qe.Mailing,qe.Note, ");
        sb.Append(" qe.EntryByName,DATE_FORMAT(qe.EntryDate,'%d-%b-%Y') entrydatetime");
        sb.Append(" FROM qc_capshippingdetail qe INNER JOIN centre_master cm ON cm.centreid=qe.CentreId");
        sb.Append(" INNER JOIN `qc_capprogrammaster` eqm ON eqm.programid=qe.programid AND eqm.IsActive=1 ");
        sb.Append(" WHERE qe.isactive=1 AND qe.CentreId =" + processinglabid + " order BY qe.CentreId,qe.programid ");
       



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
            HttpContext.Current.Session["ReportName"] = "CAPPTShippingDetail";
            return "true";
        }
        else
        {
            return "false";
        }


    }
    
    

}

public class ShipmentDetail
{
    public int LabID { get; set; }
    public int ProgramID { get; set; }
    public string ShipMentNo { get; set; }
    public string ShipDate { get; set; }
    public string DueDate { get; set; }
    public string Mailing { get; set; }
    public string Note { get; set; }
}