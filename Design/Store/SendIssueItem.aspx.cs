using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Store_SendIssueItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtdispatchdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            txtbatchdatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtbatchdateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
         
          
            bindalldata();
           

        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();

            if (ddllocation.Items.Count==1)
            {
               

                ddllocationfrom.Items.Clear();
                sb = new StringBuilder();

                sb.Append(" select distinct locationid,location from (");
                sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
                sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.fromloationID AND sc.toLoationID=" + ddllocation.SelectedValue + " ");
                sb.Append("  AND IndentType='SI' AND  sl.isactive=1  union all ");

                sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
                sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.toLoationID AND sc.fromloationID=" + ddllocation.SelectedValue + " ");
                sb.Append("  AND IndentType in ('DirectStockTransfer','DirectIssue') AND  sl.isactive=1  ");


                sb.Append("  ORDER BY location ) t ");

                ddllocationfrom.DataSource = StockReports.GetDataTable(sb.ToString());
                ddllocationfrom.DataTextField = "location";
                ddllocationfrom.DataValueField = "locationid";
                ddllocationfrom.DataBind();

                if (ddllocationfrom.Items.Count> 1)
                {
                    ddllocationfrom.Items.Insert(0, new ListItem("Select To Location", "0"));
                }
              
            }
            else
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
                ddllocationfrom.Items.Insert(0, new ListItem("Select To Location", "0"));
            }
        }

    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindentfromlocation(string tolocation)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" select distinct locationid,location from (");
        sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
        sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.fromloationID AND sc.toLoationID=" + tolocation + " ");
        sb.Append("  AND IndentType='SI' AND  sl.isactive=1  union all ");

        sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
        sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.toLoationID AND sc.fromloationID=" + tolocation + " ");
        sb.Append("  AND IndentType in ('DirectStockTransfer','DirectIssue') AND  sl.isactive=1  ");


        sb.Append("  ORDER BY location ) t ");


      
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string location, string locationto, string fromdate, string todate, string IssueInoiceNo, string status)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sid.IndentNo,DATE_FORMAT(sid.dtEntry,'%d-%b-%Y') IndentDate,siid.IssueInvoiceno , (case when DispatchStatus=0 and IsBatchCreated=0 then 'white'  when DispatchStatus=0 and IsBatchCreated=1 then 'bisque' when DispatchStatus=1 then 'pink' when DispatchStatus=2 then 'yellow' else 'lightgreen' end) Rowcolor,BatchNumber ,(case when DispatchStatus=0 and IsBatchCreated=0 then 'Pending'  when DispatchStatus=0 and IsBatchCreated=1 then 'BatchCreated' when DispatchStatus=1 then 'Dispatched' when DispatchStatus=2 then 'Delivered'  else 'Received' end) Status,");
        sb.Append(" DATE_FORMAT(siid.DATETIME,'%d-%b-%Y') IssueDate ,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.tolocationid) DispatchFrom,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.fromlocationid) DispatchTo");
        sb.Append(" FROM st_indentissuedetail siid");
        sb.Append(" INNER JOIN `st_indent_detail` sid ON siid.indentno=sid.indentno and siid.itemid=sid.itemid");
        sb.Append(" WHERE DATETIME>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND DATETIME<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        if (status == "Pending")
        {
            sb.Append(" AND DispatchStatus=0 and IsBatchCreated=0");
        }
        else if (status == "BatchCreated")
        {
            sb.Append(" AND DispatchStatus=0 and IsBatchCreated=1");
        }   
        else if (status == "Dispatched")
        {
            sb.Append(" AND DispatchStatus=1 ");
        }
        else if (status == "Delivered")
        {
            sb.Append(" AND DispatchStatus=2 ");
        }
        else if (status == "Received")
        {
            sb.Append(" AND DispatchStatus=2 ");
        }

        sb.Append(" and sid.tolocationid="+location+"");
        sb.Append(" and sid.fromlocationid="+locationto+"");
        if (IssueInoiceNo != "")
        {
            sb.Append(" and siid.IssueInvoiceno='" + IssueInoiceNo + "' ");
        }
        sb.Append(" GROUP BY siid.IssueInvoiceno order by DATETIME");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IssueInvoiceNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select sim.typename,(siid.sendqty-siid.receiveqty-siid.consumeqty-siid.stockinqty) sendqty  ");
        sb.Append(" from st_indentissuedetail siid ");
        sb.Append(" inner join st_itemmaster sim on sim.itemid=siid.itemid ");
        sb.Append(" where IssueInvoiceNo='" + IssueInvoiceNo + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetailInner(string BatchNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select siid.indentno,siid.issueinvoiceno, sim.typename,(siid.sendqty-siid.receiveqty-siid.consumeqty-siid.stockinqty) sendqty  ");
        sb.Append(" from st_indentissuedetail siid ");
        sb.Append(" inner join st_itemmaster sim on sim.itemid=siid.itemid ");
        sb.Append(" where BatchNumber='" + BatchNo + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SendDispatchData(List<string> datatosave,string NoofBox, string TotalWeight, string ConsignmentNote, string Temperature)
    {
        
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string BatchNumber = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('DIS-Inv')").ToString();
            string indentno = datatosave[0].Split('#')[1];
            foreach (string ss in datatosave)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_indentissuedetail set IsBatchCreated=1,BatchNumber=@BatchNumber,BatchCreatedDateTime=now(),BatchCreatedByID=@BatchCreatedByID,BatchCreatedByName=@BatchCreatedByName,NoofBox=@NoofBox,TotalWeight=@TotalWeight,ConsignmentNote=@ConsignmentNote,Temperature=@Temperature where IssueInvoiceNo=@IssueInvoiceNo",
                    new MySqlParameter("@BatchNumber", BatchNumber),
                    new MySqlParameter("@BatchCreatedByID", UserInfo.ID),
                    new MySqlParameter("@BatchCreatedByName", UserInfo.LoginName),
                    new MySqlParameter("@NoofBox", NoofBox),
                    new MySqlParameter("@TotalWeight", TotalWeight),
                    new MySqlParameter("@ConsignmentNote", ConsignmentNote),
                    new MySqlParameter("@Temperature", Temperature),
                    new MySqlParameter("@IssueInvoiceNo", ss.Split('#')[0]));
            }

           
           



            tnx.Commit();
            return "1#" + BatchNumber + "#" + indentno;
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#"+Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchBatch(string fromdate, string todate, string BatchNumber,string location)
    {

        

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  group_concat(distinct siid.IssueInvoiceNo)IssueInvoiceNo,NoofBox,TotalWeight,ConsignmentNote,Temperature,'white' Rowcolor, siid.BatchNumber, sid.IndentNo,DATE_FORMAT(siid.BatchCreatedDateTime,'%d-%b-%Y') BatchCreatedDateTime,BatchCreatedByName,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.tolocationid) DispatchFrom,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.fromlocationid) DispatchTo");
        sb.Append(" FROM st_indentissuedetail siid");
        sb.Append(" INNER JOIN `st_indent_detail` sid ON siid.indentno=sid.indentno and siid.itemid=sid.itemid");
        sb.Append(" WHERE BatchCreatedDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND BatchCreatedDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and DispatchStatus=0 ");
        sb.Append(" and sid.tolocationid=" + location + "");
        if (BatchNumber != "")
        {
            sb.Append(" and siid.BatchNumber='" + BatchNumber + "' ");
        }
        sb.Append(" GROUP BY siid.BatchNumber");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    


     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string FinalDispatchData(string BatchNumber,string DispatchOption,string DispatchDate,string CourierName,string AWBNumber,string FieldBoyID,string FieldBoyName,string OtherName, string NoofBox, string TotalWeight, string ConsignmentNote, string Temperature)
    {
        
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
      
        try
        {

            if (DispatchOption == "Courier")
            {
                FieldBoyID = "0";
                FieldBoyName = "";
                OtherName = "";
            }

            


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update st_indentissuedetail set DispatchOption=@DispatchOption,DispatchDate=@DispatchDate,CourierName=@CourierName,AWBNumber=@AWBNumber,FieldBoyID=@FieldBoyID,FieldBoyName=@FieldBoyName,OtherName=@OtherName,NoofBox=@NoofBox,TotalWeight=@TotalWeight,ConsignmentNote=@ConsignmentNote,Temperature=@Temperature,DispatchStatus=1,DispatchByUserID=@DispatchByUserID,DispatchByUserName=@DispatchByUserName where BatchNumber=@BatchNumber",

                    new MySqlParameter("@DispatchOption", DispatchOption),
                    new MySqlParameter("@DispatchDate", Util.GetDateTime(DispatchDate).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@CourierName", CourierName),
                    new MySqlParameter("@AWBNumber", AWBNumber),
                    new MySqlParameter("@FieldBoyID", FieldBoyID),
                    new MySqlParameter("@FieldBoyName", FieldBoyName),
                    new MySqlParameter("@OtherName", OtherName),
                    new MySqlParameter("@NoofBox", NoofBox),
                    new MySqlParameter("@TotalWeight", TotalWeight),
                    new MySqlParameter("@ConsignmentNote", ConsignmentNote),
                    new MySqlParameter("@Temperature", Temperature),
                    new MySqlParameter("@DispatchByUserID", UserInfo.ID),
                    new MySqlParameter("@DispatchByUserName", UserInfo.LoginName),
                    new MySqlParameter("@BatchNumber", BatchNumber));


            // Send Email
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, @"SELECT  sid.indentno,sid.issueinvoiceno,sid.batchnumber ,sd.UserId,em.Email,em.name FROM st_indentissuedetail sid
INNER JOIN `st_indent_detail`  sd ON sd.indentno=sid.indentno AND sd.itemid=sid.itemid AND sd.indenttype='SI'
INNER JOIN employee_master em ON em.employee_id=sd.userid
WHERE batchnumber='" + BatchNumber + "' GROUP BY indentno ").Tables[0];

            foreach (DataRow dw in dt.Rows)
            {
                if (dw["Email"].ToString() != "")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("<div> Dear <b>" + dw["name"].ToString() + "</b> </div>");
                    sb.Append("<br/>");
                    sb.Append(" Greetings from Apollo Health and Lifestyle Limited");
                    sb.Append("<br/>"); sb.Append("<br/>");
                    sb.Append("Indent No- <b>" + dw["indentno"].ToString() + "</b> Raised By You is Dispatched With following Detail");
                    sb.Append("<br/>");
                    sb.Append("Issue Invoice No: <b>" + dw["issueinvoiceno"].ToString() + "</b>  Batch No: <b>" + dw["batchnumber"].ToString() + "</b>  Dispatch By: " + UserInfo.LoginName + " at: " + DateTime.Now.ToString("dd-MM-yyyy hh:mm"));
                    sb.Append("<br/><br/>");
                    sb.Append("DispatchOption: <b>" + DispatchOption + "</b>  Courier Name: <b>" + CourierName + "</b>  AWB Number: " + AWBNumber);

                    sb.Append("<br/><br/>");
                    sb.Append("Thanks & Regards,");
                    sb.Append("<br/>");
                    sb.Append("Apollo Health And Lifestyle Limited.");
                    sb.Append("<br/>");

                    ReportEmailClass REmail = new ReportEmailClass();
                    string IsSend = "0";
                    //IsSend = REmail.sendstoreemail(dw["Email"].ToString(), "Logistic delivery Against Sales Indent", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                     new MySqlParameter("@TransactionID", BatchNumber),
                     new MySqlParameter("@UserID", UserInfo.ID),
                     new MySqlParameter("@IsSend", IsSend),
                     new MySqlParameter("@Remarks", "Logistic delivery"),
                     new MySqlParameter("@EmailID", dw["Email"].ToString()),
                     new MySqlParameter("@MailedTo", "Indent Raised By"));
                }
            }
           
           



         
            return "1";
        }
        catch (Exception ex)
        {

         

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#"+Util.GetString(ex.Message);

        }
        finally
        {
          
            con.Close();
            con.Dispose();
        }

        
    }

    
    
}