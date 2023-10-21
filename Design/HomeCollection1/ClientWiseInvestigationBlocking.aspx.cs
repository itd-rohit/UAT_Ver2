using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_EDP_ClientWiseInvestigationBlocking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindClient();
            bindInvestigation();
            bindCentreType();
        }
    }

    private void bindCentreType()
    {
        using (DataTable dt =StockReports.GetDataTable("SELECT ID,Type1 FROM centre_type1master WHERE IsActive=1"))
        {
        if (dt.Rows.Count > 0)
        {
            ddlCentreType.DataSource = dt;
            ddlCentreType.DataTextField = "Type1";
            ddlCentreType.DataValueField = "ID";
            ddlCentreType.DataBind();
            ddlCentreType.Items.Insert(0, new ListItem("All", "0"));
            ddlCentreType.SelectedIndex = ddlCentreType.Items.IndexOf(ddlCentreType.Items.FindByValue("6"));

        }
      }
    }
    public void bindInvestigation()
    {
       using (DataTable dt = StockReports.GetDataTable("select IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) testname,im.`ItemID` testid from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44' order by testname"))
       {        
        ddlinvestigation.DataSource = dt;
        ddlinvestigation.DataTextField = "testname";
        ddlinvestigation.DataValueField = "testid";
        ddlinvestigation.DataBind();
        ddlinvestigation.Items.Insert(0, new ListItem("Select Test", "0"));
       }
    }
    public void bindClient()
    {


        using (DataTable dt = StockReports.GetDataTable("Select Id,CompanyName from f_Interface_Company_Master order by CompanyName"))
        {
            ddlClientName.DataSource = dt;
            ddlClientName.DataTextField = "CompanyName";
            ddlClientName.DataValueField = "Id";
            ddlClientName.DataBind();
           
        }
    }

    [WebMethod]
    public static string Save(string ItemID, string ClientName, string priority, string RateSelection)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int COUNT = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(ItemID) FROM f_itemaster_clientWise sms WHERE IsActive=1 and ItemID=@ItemID and sms.ClientName=@ClientName ",
                                              new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@ClientName", ClientName)));
            if (COUNT > 0)
                return "2";

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO f_itemaster_clientWise(ClientName,ItemID,IsActive,EnteredBy,EnteredByID,IPAddress,TestPriority,RateSelection) ");
            sb.Append(" VALUES(@ClientName,@ItemID,1,@EnteredBy,@EnteredByID,@IPAddress,@TestPriority,@RateSelection) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ClientName", ClientName), new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@EnteredBy", UserInfo.LoginName), new MySqlParameter("@EnteredByID", UserInfo.ID),
                new MySqlParameter("@IPAddress", StockReports.getip()), new MySqlParameter("@TestPriority", priority),
                new MySqlParameter("@RateSelection", RateSelection));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string Update(string status, string ID, string ItemID, string ClientName, string RateSelection)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (status == "1")
            {
                int COUNT = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(ItemID) FROM f_itemaster_clientWise sms WHERE IsActive=1 and ItemID=@ItemID and ClientName=@ClientName ",
                                                 new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@ClientName", ClientName)));
                if (COUNT > 0)
                    return "2";
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_itemaster_clientWise SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedById=@UpdatedByID,UpdateDate=NOW() WHERE ID=@ID ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@IsActive", status), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                 new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@ID", ID));

            //sb = new StringBuilder();
            //sb.Append(" INSERT INTO f_itemaster_clientWise_log(ClientName,ItemID,IsActive,UpdatedBy,UpdatedByID,UpdateDate,IPAddress,RateSelection) ");
            //sb.Append(" VALUES(@ClientName,@ItemID,@IsActive,@UpdatedBy,@UpdatedByID,NOW(),@IPAddress,@RateSelection)");
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
            //    new MySqlParameter("@ClientName", ClientName), new MySqlParameter("@ItemID", ItemID),
            //    new MySqlParameter("@IsActive", status), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
            //    new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@IPAddress", StockReports.getip()),
            //    new MySqlParameter("@RateSelection", RateSelection));



            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindList(string ClientName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sms.ClientName,sms.ID,sms.ItemID,TestCode,im.typename,DATE_FORMAT(sms.dtEntry, '%d %b %Y') dtEntry,TestPriority, ");
        sb.Append(" DATE_FORMAT(sms.UpdateDate, '%d %b %Y') UpdateDate, CONCAT(emp.`Title`,' ',emp.`Name`) CreatedBy, ");
        sb.Append(" CONCAT(emp1.`Title`,' ',emp1.`Name`) UpdatedBy,sms.IsActive, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN 'Active' ELSE 'Deactive' END STATUS, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN 'Deactive' ELSE 'Active' END Actions, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN '0' ELSE '1' END ChangeStatus,  ");
        sb.Append(" CASE WHEN sms.RateSelection='NormalRate' THEN 'Normal Rate' WHEN sms.RateSelection='ScheduleRate' THEN 'Schedule Rate' ELSE 'Normal and Schedule Rate' END RateSelection,sms.RateSelection RateSelectionID  ");
        sb.Append(" FROM f_itemaster_clientWise sms ");
        sb.Append(" INNER JOIN f_itemmaster im  ON sms.ItemID=im.ItemID and sms.ClientName='" + ClientName + "' and sms.IsActive=1  ");
        sb.Append(" INNER JOIN `employee_master` emp ON sms.EnteredByID=emp.`Employee_ID` ");
        sb.Append(" LEFT JOIN `employee_master` emp1 ON sms.UpdatedByID=emp1.`Employee_ID` order by TestPriority ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string BindDetals(string ItemID, string ClientName)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sms.ClientName,sms.ID,sms.ItemID,TestCode,im.typename,DATE_FORMAT(ifnull(sms.dtEntry,''), '%d %b %Y') dtEntry, ");
        sb.Append(" IFNULL(DATE_FORMAT(ifnull(sms.UpdateDate,''), '%d %b %Y'),'') UpdateDate,ifnull( CONCAT(emp.`Title`,' ',emp.`Name`),'') CreatedBy, ");
        sb.Append(" ifnull(CONCAT(emp1.`Title`,' ',emp1.`Name`),'') UpdatedBy,sms.IsActive, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN 'Active' ELSE 'Deactive' END STATUS, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN 'Deactive' ELSE 'Active' END Actions, ");
        sb.Append(" CASE WHEN sms.IsActive=1 THEN '0' ELSE '1' END ChangeStatus, ");
        sb.Append(" CASE WHEN sms.RateSelection='NormalRate' THEN 'Normal Rate' WHEN sms.RateSelection='ScheduleRate' THEN 'Schedule Rate' ELSE 'Normal and Schedule Rate' END RateSelection,sms.RateSelection RateSelectionID  ");
        sb.Append("  FROM f_itemaster_clientWise_log sms  ");
        sb.Append(" INNER JOIN f_itemmaster im  ON sms.ItemID=im.ItemID and sms.ClientName='" + ClientName + "' ");
        sb.Append(" left JOIN `employee_master` emp ON sms.EnteredByID=emp.`Employee_ID` ");
        sb.Append(" LEFT JOIN `employee_master` emp1 ON sms.UpdatedByID=emp1.`Employee_ID` where sms.ItemID='" + ItemID + "'  ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string SavePriority(List<Clientpriority> dataPLO)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_itemaster_clientWise set TestPriority=0 where ClientName='" + dataPLO[0].ClientName + "'");
            int p = 1;
            foreach (Clientpriority cp in dataPLO)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_itemaster_clientWise set TestPriority=" + p + " where ClientName='" + dataPLO[0].ClientName + "' and itemid='" + cp.ItemID + "'");
                p++;
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string SavePrioritySingle(string pri, string itemid, string clientname)
    {
        StockReports.ExecuteDML("update f_itemaster_clientWise set TestPriority=" + pri + " where ClientName='" + clientname + "' and itemid='" + itemid + "'");
        return "1";
    }
    [WebMethod]
    public static string SaveRateSelection(int ID, string RateSelection)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  f_itemaster_clientWise SET RateSelection=@RateSelection,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdateDate=NOW() where ID=@ID",
               new MySqlParameter("@ID", ID), new MySqlParameter("@RateSelection", RateSelection),
               new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID));


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindClientRate(int _PageNo, int _PageSize, string ItemID, string CentreType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.TestCode ItemCode,im.typename ItemName,    ");
        sb.Append(" pm.`Panel_Code` ClientCode,  pm.`Company_Name` ClientName,pm.Panel_ID ClientID, r.`Rate` Rate,0 ScheduleRate,'' FromDate,'' ToDate, ");
        sb.Append(" IF(im.subcategoryid=15,'Package','Test') ItemType  ,im.ItemID ,0 totalRow,pm.CentreType1   ");
        sb.Append(" FROM f_itemmaster im  ");
        sb.Append(" CROSS JOIN `f_panel_master` pm ON  pm.`IsActive`=1  AND IFNULL(pm.centretype1,'')!=''");
        if (CentreType.ToUpper() != "ALL")
            sb.Append(" AND pm.CentreType1='" + CentreType + "' ");
        sb.Append("   AND im.ItemID='" + ItemID + "'  INNER JOIN `f_ratelist` r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=pm.`ReferenceCode`  AND r.`Rate`>0  ");
        sb.Append(" UNION ALL ");

        sb.Append("  SELECT  im.TestCode ItemCode,im.typename ItemName,       ");
        sb.Append("  pm.`Panel_Code` ClientCode,  pm.`Company_Name` ClientName,pm.Panel_ID ClientID,0 Rate,r.`Rate` ScheduleRate,  ");
        sb.Append("  DATE_FORMAT( FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT( ToDate,'%d-%b-%Y')ToDate,  ");
        sb.Append("  IF(im.subcategoryid=15,'Package','Test') ItemType,im.ItemID  ,0 totalRow  ,pm.CentreType1    ");
        sb.Append("  FROM f_itemmaster im                  ");
        sb.Append("  CROSS JOIN `f_panel_master` pm   ON pm.`IsActive`=1 AND IFNULL(pm.centretype1,'')!=''");
        if (CentreType.ToUpper() != "ALL")
            sb.Append(" AND pm.CentreType1='" + CentreType + "' ");
        sb.Append(" AND im.ItemID='" + ItemID + "'             ");
        sb.Append("  INNER JOIN f_ratelist_schedule r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=pm.`ReferenceCode`   ");
        sb.Append("  AND r.`Rate`>0 AND r.IsActive=1 AND r.RateApplicableForAll=1 AND ToDate>= CURRENT_DATE()  ");

        sb.Append(" UNION ALL ");

        sb.Append(" SELECT  im.TestCode ItemCode,im.typename ItemName,     ");
        sb.Append(" pm.`Panel_Code` ClientCode,  pm.`Company_Name` ClientName,pm.Panel_ID ClientID,0 Rate,r.`Rate` ScheduleRate,  ");
        sb.Append(" DATE_FORMAT( FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT( ToDate,'%d-%b-%Y')ToDate,  ");
        sb.Append(" IF(im.subcategoryid=15,'Package','Test') ItemType,im.ItemID  ,0 totalRow  ,pm.CentreType1   ");
        sb.Append(" FROM f_itemmaster im             ");
        sb.Append(" CROSS JOIN `f_panel_master` pm   ON pm.`IsActive`=1     AND IFNULL(pm.centretype1,'')!=''");
        if (CentreType.ToUpper() != "ALL")
            sb.Append(" AND pm.CentreType1='" + CentreType + "' ");
        sb.Append(" AND im.ItemID='" + ItemID + "' ");
        sb.Append(" INNER JOIN f_ratelist_schedule r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=pm.`Panel_ID`    ");
        sb.Append(" AND r.`Rate`>0 AND r.IsActive=1 AND r.RateApplicableForAll=0 AND ToDate>= CURRENT_DATE()  ");


        if (_PageNo != 0)
        {
            int from = _PageSize * _PageNo;
            int to = _PageSize;
            sb.Append(" limit " + from + "," + to + " ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (_PageNo == 0)
        {
            if (dt.Rows.Count > 0)
            {
                dt.Rows[0]["totalRow"] = Util.GetInt(dt.Rows.Count);
                dt = dt.AsEnumerable().Skip(0).Take(_PageSize).CopyToDataTable();
                dt.AcceptChanges();
                return Util.getJson(dt);

            }
        }
        dt.AcceptChanges();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}


public class Clientpriority
{
    public string ClientName { get; set; }
    public string ItemID { get; set; }
}