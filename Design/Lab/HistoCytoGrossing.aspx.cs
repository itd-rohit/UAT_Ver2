using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_HistoCytoGrossing : System.Web.UI.Page
{
    public string ApprovalId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.AddDays(-5).ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + UserInfo.RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "'");

            binddept();
            binddoctor();
        }
    }

    private void binddoctor()
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        sbQuery.Append("  WHERE centreid=" + UserInfo.Centre + " ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        ddldoctor.DataSource = dt;
        ddldoctor.DataTextField = "Name";
        ddldoctor.DataValueField = "employeeid";
        ddldoctor.DataBind();
        ListItem selectedListItem = ddldoctor.Items.FindByValue(UserInfo.ID.ToString());

        if (selectedListItem != null)
        {
            selectedListItem.Selected = true;
        }
    }

    private void binddept()
    {
        ddldepartment.DataSource = StockReports.GetDataTable(@"SELECT `SubCategoryID`,NAME FROM `f_subcategorymaster` WHERE active=1 AND SubCategoryID IN(4,7)");
        ddldepartment.DataTextField = "NAME";
        ddldepartment.DataValueField = "SubCategoryID";
        ddldepartment.DataBind();
        ddldepartment.Items.Insert(0, new ListItem("", "0"));
    }

    [WebMethod]
    public static string SearchData(List<string> searchdata)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("");

        sbQuery.Append(" SELECT ifnull((SELECT CONCAT(Reslide,'#',IFNULL(ReslideOption,'')) FROM patient_labhisto_slides WHERE testid=plo.`Test_ID` and Reslide=1 limit 1),'0#') isreslide, plo.subcategoryid,plo.patient_id, plo.slidenumber, plo.`Test_ID`,plo.`LedgerTransactionNo`,plo.`BarcodeNo`,lt.`PName`, ");
        sbQuery.Append(" case when HistoCytoStatus='Grossed' then 'pink' when  HistoCytoStatus='Slided' then 'lightgreen' when  HistoCytoStatus='SlideComplete' then '#ff00ff'  else 'lightyellow' end rowcolor,");
        sbQuery.Append("  IF(HistoCytoSampleDetail<>'', ");
        sbQuery.Append(" CONCAT(");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sbQuery.Append(" '^', -1)),''))");
        sbQuery.Append(" ,'') SampleInfo, ");
        sbQuery.Append("inv.`Name`,plo.`SampleTypeName`,lt.`Age`,plo.`Gender`,lt.PanelName,  ");
        sbQuery.Append(" DATE_FORMAT(`SampleCollectionDate`,'%d-%b-%y %h:%i %p') SampleCollectionDate, ");
        sbQuery.Append("DATE_FORMAT(`SampleReceiveDate`,'%d-%b-%y %h:%i %p') SampleReceiveDate, ");
        sbQuery.Append(" ifnull(DATE_FORMAT(`SampleReceiveDate`,'%d-%b-%y %h:%i %p'),'') HistoStatusDate, ");
        sbQuery.Append(" ifnull(HistoCytoStatus,'') HistoCytoStatus,if(plo.result_flag='1','saved','notdone') reportstatus");
        sbQuery.Append(" FROM `patient_labinvestigation_opd` plo  ");
        sbQuery.Append("INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sbQuery.Append("INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` AND inv.reporttype=7 ");
        sbQuery.Append(" AND plo.`IsSampleCollected`='Y' ");
        sbQuery.Append(" where plo.TestCentreID='" + UserInfo.Centre + "' ");
        sbQuery.Append(" and  plo.SampleReceiveDate>='" + Util.GetDateTime(searchdata[1]).ToString("yyyy-MM-dd") + " 00:00:00'");
        sbQuery.Append(" and plo.SampleReceiveDate<='" + Util.GetDateTime(searchdata[2]).ToString("yyyy-MM-dd") + " 23:59:59'");
        //if (Util.GetString(searchdata[7]) != "")
        //{
        //    sbQuery.Append(" and plo.HistoCytoPerformingDoctor='" + searchdata[7] + "' ");
        //}
        if (searchdata[3] != "")
        {
            sbQuery.Append(" and plo.LedgerTransactionNo='" + searchdata[3] + "'");
        }

        if (searchdata[4] != "")
        {
            sbQuery.Append(" and plo.barcodeno='" + searchdata[4] + "'");
        }
        if (searchdata[5] != "")
        {
            sbQuery.Append(" and plo.slidenumber='" + searchdata[5] + "'");
        }
        if (searchdata[6] != "0")
        {
            sbQuery.Append(" and plo.subcategoryid='" + searchdata[6] + "'");
        }
        if (searchdata[8] != "")
        {
            sbQuery.Append(" and HistoCytoStatus ='" + searchdata[8] + "' ");
        }
        else
        {
            if (searchdata[0] == "Assigned")
                sbQuery.Append(" and HistoCytoStatus ='" + searchdata[0] + "' ");
            else if (searchdata[0] == "Grossed")
                sbQuery.Append(" and HistoCytoStatus ='" + searchdata[0] + "' ");
            else if (searchdata[0] == "Slided")
                sbQuery.Append(" and HistoCytoStatus ='" + searchdata[0] + "' ");
            else if (searchdata[0] == "SlideComplete")
                sbQuery.Append(" and HistoCytoStatus ='" + searchdata[0] + "' ");
        }
        sbQuery.Append(" and `Result_Flag`=0 ");

        sbQuery.Append(" order by plo.SampleReceiveDate");
        using (DataTable dt = StockReports.GetDataTable(sbQuery.ToString()))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string savegrossdata(List<string[]> mydataadj)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string test_id = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select testid from patient_labhisto_gross where testid=@testid",
           new MySqlParameter("@testid", Util.GetString(mydataadj[0][0]))));

        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labhisto_gross where testid=@testid",
           new MySqlParameter("@testid", Util.GetString(mydataadj[0][0])));

        try
        {
            StringBuilder sb = new StringBuilder();
            foreach (string[] ss in mydataadj)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_gross ");
                sb.Append("(testid,labno,blockid,blockcomment,grosscomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES(@testID,@labno,@blockid,@blockcomment,@grosscomment ");
                sb.Append(",NOW(),@entrybyname,@entryby)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@testID", ss[0].ToString()), new MySqlParameter("@labno", ss[1].ToString()),
                    new MySqlParameter("@blockid", ss[2].ToString()), new MySqlParameter("@blockcomment", ss[3].ToString()),
                    new MySqlParameter("@grosscomment", ss[4].ToString()), new MySqlParameter("@entrybyname", Util.GetString(HttpContext.Current.Session["LoginName"])),
                    new MySqlParameter("@entryby", Util.GetString(HttpContext.Current.Session["ID"]))
                    );
            }
            if (test_id == string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd set HistoCytoStatus='Grossed' where test_id=@test_id",
                   new MySqlParameter("@test_id", Util.GetString(mydataadj[0][0])));
            }

            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Grossing-Block Creation (',ItemName,')'),@UserID,@LoginName,@IpAddress,@Centre, ");
            sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@test_id");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@test_id", Util.GetString(mydataadj[0][0])),
                 new MySqlParameter("@RoleID", UserInfo.RoleID),
                  new MySqlParameter("@LoginName", UserInfo.LoginName),
                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@Centre", UserInfo.Centre));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getdetailblock(string testid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(labno,' / ',blockid) value,blockid FROM patient_labhisto_gross where testid='" + testid + "' order by testid");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string savedataslide(List<string[]> mydataadj)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string test_id = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select testid from patient_labhisto_slides where testid=@testid",
           new MySqlParameter("@testid", Util.GetString(mydataadj[0][0]))));
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labhisto_slides where testid=@testid and blockid=@blockid",
           new MySqlParameter("@testid", Util.GetString(mydataadj[0][0])), new MySqlParameter("@blockid", Util.GetString(mydataadj[0][2])));

        try
        {
            StringBuilder sb = new StringBuilder();
            foreach (string[] ss in mydataadj)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_slides ");
                sb.Append("(testid,labno,blockid,slideno,slidecomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES(@testID,@labno,@blockid,@blockcomment,@grosscomment");
                sb.Append(",NOW(),@entrybyname,@entryby)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),

                   new MySqlParameter("@testID", ss[0].ToString()), new MySqlParameter("@labno", ss[1].ToString()),
                    new MySqlParameter("@blockid", ss[2].ToString()), new MySqlParameter("@blockcomment", ss[3].ToString()),
                    new MySqlParameter("@grosscomment", ss[4].ToString()), new MySqlParameter("@entrybyname", Util.GetString(HttpContext.Current.Session["LoginName"])),
                    new MySqlParameter("@entryby", Util.GetString(HttpContext.Current.Session["ID"]))
                    );
            }
            if (test_id == string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Slided' where test_id=@test_id",
                    new MySqlParameter("@test_id", Util.GetString(mydataadj[0][0])));
            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Grossing-Slide Creation (',ItemName,')'),@UserID,@LoginName,@IpAddress,@Centre, ");
            sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@test_id");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@test_id", Util.GetString(mydataadj[0][0])),
                 new MySqlParameter("@RoleID", UserInfo.RoleID),
                  new MySqlParameter("@LoginName", UserInfo.LoginName),
                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@Centre", UserInfo.Centre));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getgrossdetail(string testid)
    {
        using (DataTable dt = StockReports.GetDataTable(" SELECT testid,labno,blockid,blockcomment,grosscomment FROM patient_labhisto_gross WHERE testid='" + testid + "'"))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string getdetaildatablock(string testid, string blockid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select reslide,reslideoption, testid,labno,blockid,slideno,slidecomment from patient_labhisto_slides where testid='" + testid + "' and blockid='" + blockid + "'");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string savecompletedata(List<string[]> mydataadj, List<string[]> mydataadj1)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labhisto_gross where testid=@testid",
               new MySqlParameter("@testid", Util.GetString(mydataadj[0][0])));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM patient_labhisto_slides where testid=@testid AND blockid=@blockid",
                new MySqlParameter("@testid", Util.GetString(mydataadj[0][0])),
                new MySqlParameter("@blockid", Util.GetString(mydataadj1[0][2])));

            StringBuilder sb = new StringBuilder();
            foreach (string[] ss in mydataadj)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_gross ");
                sb.Append("(testid,labno,blockid,blockcomment,grosscomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES(@test_id,@labno,@blockid,@blockcomment,@grosscomment");
                sb.Append(",NOW(),@entrybyname,@entryby)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@test_id", ss[0].ToString()),
                new MySqlParameter("@labno", ss[1].ToString()),
                 new MySqlParameter("@blockid", ss[2].ToString()), new MySqlParameter("@entryby", Util.GetString(HttpContext.Current.Session["ID"])),
                  new MySqlParameter("@blockcomment", ss[3].ToString()), new MySqlParameter("@grosscomment", ss[4].ToString()), new MySqlParameter("@entrybyname", Util.GetString(HttpContext.Current.Session["LoginName"])));
            }
            foreach (string[] ss in mydataadj1)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_slides ");
                sb.Append("(testid,labno,blockid,slideno,slidecomment,entrydate,entrybyname,entryby)");
                sb.Append("VALUES(@test_id,@labno,@blockid,@slideno,@slidecomment ");
                sb.Append(",NOW(),@entrybyname,@entryby)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@test_id", ss[0].ToString()),
                 new MySqlParameter("@labno", ss[1].ToString()),
                  new MySqlParameter("@blockid", ss[2].ToString()), new MySqlParameter("@entryby", Util.GetString(HttpContext.Current.Session["ID"])),
                   new MySqlParameter("@slideno", ss[3].ToString()), new MySqlParameter("@slidecomment", ss[4].ToString()), new MySqlParameter("@entrybyname", Util.GetString(HttpContext.Current.Session["LoginName"])));
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Slided' where test_id=@test_id",
               new MySqlParameter("@test_id", Util.GetString(mydataadj1[0][0])));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string markcomplete(string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='SlideComplete' where test_id=@testid",
               new MySqlParameter("@testid", testid));

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Block/Slide Created (',ItemName,')'),@UserID,@LoginName,@IpAddress,@Centre, ");
            sb1.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@testid");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),
                 new MySqlParameter("@testid", testid),
                 new MySqlParameter("@RoleID", UserInfo.RoleID),
                  new MySqlParameter("@LoginName", UserInfo.LoginName),
                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@Centre", UserInfo.Centre));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}