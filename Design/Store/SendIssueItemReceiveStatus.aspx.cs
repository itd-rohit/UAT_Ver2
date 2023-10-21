﻿using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_SendIssueItemReceiveStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
          


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

            if (ddllocation.Items.Count > 1)
            {

                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
               

            }
         
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchBatch(string fromdate, string todate, string BatchNumber, string location)
    {



        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT group_concat(distinct siid.IssueInvoiceNo)IssueInvoiceNo, DispatchStatus, ifnull(DATE_FORMAT(siid.DeliveryDate,'%d-%b-%Y'),'')DeliveryDate,ifnull(DeliveryByUserName,'')DeliveryByUserName,ifnull(DATE_FORMAT(siid.ReceiveDate,'%d-%b-%Y'),'')ReceiveDate,ifnull(ReceiveByUserName,'')ReceiveByUserName, DispatchOption,CourierName,AWBNumber,FieldBoyID,FieldBoyName,OtherName,NoofBox,TotalWeight,ConsignmentNote,Temperature, (case  when DispatchStatus=1 then 'pink' when DispatchStatus=2 then 'yellow' else 'lightgreen' end) Rowcolor, siid.BatchNumber, sid.IndentNo,DATE_FORMAT(siid.BatchCreatedDateTime,'%d-%b-%Y') BatchCreatedDateTime,BatchCreatedByName,DATE_FORMAT(siid.DispatchDate,'%d-%b-%Y')DispatchDate,DispatchByUserName,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.tolocationid) DispatchFrom,");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=sid.fromlocationid) DispatchTo");
        sb.Append(" FROM st_indentissuedetail siid");
        sb.Append(" INNER JOIN `st_indent_detail` sid ON siid.indentno=sid.indentno and sid.itemid=siid.itemid");
        sb.Append(" WHERE DispatchDate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' AND DispatchDate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and DispatchStatus>0 ");
        sb.Append(" and sid.fromlocationid=" + location + "");
        if (BatchNumber != "")
        {
            sb.Append(" and siid.BatchNumber='" + BatchNumber + "' ");
        }
        sb.Append(" GROUP BY siid.BatchNumber");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveStatus(string BatchNumber, string status, string noofboxreceive)
    {

        

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_indentissuedetail set DispatchStatus=@DispatchStatus,ReceiveDate=now(),ReceiveByUserID=@ReceiveByUserID,ReceiveByUserName=@ReceiveByUserName,NoofBoxReceive=@NoofBoxReceive  where BatchNumber=@BatchNumber",

                    new MySqlParameter("@DispatchStatus", status),

                    new MySqlParameter("@ReceiveByUserID", UserInfo.ID),
                    new MySqlParameter("@ReceiveByUserName", UserInfo.LoginName),
                     new MySqlParameter("@NoofBoxReceive", noofboxreceive),
                    new MySqlParameter("@BatchNumber", BatchNumber));







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
    
    
}