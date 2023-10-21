using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_PODAccept : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string fromdate, string todate,string podnumber, string Type)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");
        if (Type == "NEW")
        {
            string fromempids = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(employeeidfrom),0) FROM st_pod_employeetagging WHERE employeeidto=" + UserInfo.ID + "");
            sb.Append(" SELECT '" + Type + "' as Type,pd. PODnumber,lt.invoiceno ,'Pink' as rowColor,pd.LedgerTransactionID,pd.is_forwarded,pd.IsPOD_Accept,pd.couriername,pd.consinmentno,DATE_FORMAT(pd.senddate,'%d-%b-%Y')senddate,lm.location ,");
            sb.Append(" (SELECT COUNT(*) accept FROM st_pod_details WHERE podnumber=pd.PODnumber AND ispod_accept=0 ) remain, ");
            sb.Append(" SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount,pd.locationid,pt.fromemployeeid,pt.IsCurrent,   ");
            sb.Append("  COUNT(CASE WHEN IsPOD_Accept=1 THEN 1 ELSE NULL END) paid,COUNT(CASE WHEN IsPOD_Accept=2 THEN 1 ELSE NULL END) unpaid ,pet.Islast,(select name from employee_master where employee_id=pt.fromemployeeid)name");
            sb.Append(" FROM st_pod_details pd  INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  INNER JOIN  st_PodTransfer  pt ON pd. podnumber =pt.podnumber INNER JOIN st_pod_employeetagging pet ON pt.fromemployeeid=pet.Employeeidfrom and pet.isactive=1 ");
            sb.Append(" INNER JOIN st_ledgertransaction lt ON lt.LedgerTransactionNo=pd.LedgerTransactionNo ");
            sb.Append("  where pd.IsPOD_transfer=1");
            if (podnumber != "")
            {
                sb.Append(" AND pd.PODnumber='" + podnumber + "'");
            }
            else
            {
                sb.Append(" and pd.podgendate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" and pd.podgendate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            sb.Append(" AND pt.fromemployeeid in(" + fromempids + ") and pt.IsCurrent=1 and pt.STATUS!='Reject'");
            sb.Append(" GROUP BY pd.PODnumber ");
        }
        if (Type == "Accept")
        {

            sb.Append(" SELECT '" + Type + "' as Type,pd. PODnumber,lt.invoiceno ,'#90EE90' as rowColor,pd.LedgerTransactionID,pd.is_forwarded,pd.IsPOD_Accept,pd.couriername,pd.consinmentno,DATE_FORMAT(pd.senddate,'%d-%b-%Y')senddate,lm.location ,");
            sb.Append(" (SELECT COUNT(*) accept FROM st_pod_details WHERE podnumber=pd.PODnumber AND ispod_accept=0 ) remain, ");
            sb.Append(" SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount,pd.locationid,pt.fromemployeeid,pt.IsCurrent,   ");
            sb.Append("  COUNT(CASE WHEN IsPOD_Accept=1 THEN 1 ELSE NULL END) paid,COUNT(CASE WHEN IsPOD_Accept=2 THEN 1 ELSE NULL END) unpaid ,pet.Islast,(select name from employee_master where employee_id=pt.fromemployeeid)name");
            sb.Append(" FROM st_pod_details pd  INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  INNER JOIN  st_PodTransfer  pt ON pd. podnumber =pt.podnumber INNER JOIN st_pod_employeetagging pet ON pt.fromemployeeid=pet.Employeeidfrom and pet.isactive=1 ");
            sb.Append(" INNER JOIN st_ledgertransaction lt ON lt.LedgerTransactionNo=pd.LedgerTransactionNo ");
            sb.Append("  where pd.IsPOD_transfer=1");
            if (podnumber != "")
            {
                sb.Append(" AND pd.PODnumber='" + podnumber + "'");
            }
            else
            {
                sb.Append(" and pd.podgendate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" and pd.podgendate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            sb.Append(" AND pt.fromemployeeid in(" + UserInfo.ID + ") and pt.STATUS='Accept'");
            sb.Append(" GROUP BY pd.PODnumber ");
        }
        if (Type == "Reject")
        {

            sb.Append(" SELECT '"+Type+"' as Type, pd. PODnumber,lt.invoiceno ,'aqua' as rowColor,pd.LedgerTransactionID,pd.is_forwarded,pd.IsPOD_Accept,pd.couriername,pd.consinmentno,DATE_FORMAT(pd.senddate,'%d-%b-%Y')senddate,lm.location ,");
            sb.Append(" (SELECT COUNT(*) accept FROM st_pod_details WHERE podnumber=pd.PODnumber AND ispod_accept=0 ) remain, ");
            sb.Append(" SUM(pd.GrossAmount )GrossAmount,SUM(pd. DiscountOnTotal )DiscountOnTotal,SUM(pd. TaxAmount )TaxAmount,SUM(pd. NetAmount )NetAmount,pd.locationid,pt.fromemployeeid,pt.IsCurrent,   ");
            sb.Append("  COUNT(CASE WHEN IsPOD_Accept=1 THEN 1 ELSE NULL END) paid,COUNT(CASE WHEN IsPOD_Accept=2 THEN 1 ELSE NULL END) unpaid ,pet.Islast,(select name from employee_master where employee_id=pt.fromemployeeid)name");
            sb.Append(" FROM st_pod_details pd  INNER JOIN  st_locationmaster  lm ON pd. Locationid =lm. LocationID  INNER JOIN  st_PodTransfer  pt ON pd. podnumber =pt.podnumber INNER JOIN st_pod_employeetagging pet ON pt.fromemployeeid=pet.Employeeidfrom and pet.isactive=1 ");
            sb.Append(" INNER JOIN st_ledgertransaction lt ON lt.LedgerTransactionNo=pd.LedgerTransactionNo ");
            sb.Append("  where pd.IsPOD_transfer=1");
            if (podnumber != "")
            {
                sb.Append(" AND pd.PODnumber='" + podnumber + "'");
            }
            else
            {
                sb.Append(" and pd.podgendate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append(" and pd.podgendate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            sb.Append(" AND pt.fromemployeeid in(" + UserInfo.ID + ") and pt.STATUS='Reject'");
            sb.Append(" GROUP BY pd.PODnumber ");
        }


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string pod)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT lt.LedgerTransactionID,pd.IsPOD_Accept,Case when ifnull(pd.IsPOD_Accept,0)=2 then 'aqua' when ifnull(pd.IsPOD_Accept,0)=1 then '#90EE90' else 'pink' end as rowColor,lt.LedgerTransactionNo,lt.IsDirectGRN,lt.PODnumber,lt.Ispodgenerate,  lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.PurchaseOrderNo PurchaseOrderNo,lt.InvoiceNo,lt.ChalanNo,pd.Remarks, ");
        sb.Append(" vm.SupplierName,DATE_FORMAT(lt.datetime,'%d-%b-%Y')GRNDate,lt.NetAmount,lt.GrossAmount,lt.DiscountOnTotal,lt.TaxAmount ");
        sb.Append(" FROM   st_ledgertransaction lt ");

        sb.Append(" INNER JOIN st_vendormaster vm ON lt.vendorid=vm.SupplierID ");


        sb.Append(" INNER JOIN st_pod_details pd ON lt.LedgerTransactionNo=pd.LedgerTransactionNo ");
        sb.Append(" where lt.PODnumber='" + pod + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PODTransfer(string podnumber, string PODType)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string maxid = Util.GetString(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"select id from st_PodTransfer where PODNumber='" + podnumber + "' and Iscurrent=1"));
            int iscurrent = 1;
            if (PODType == "Reject")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select count(*) from st_PodTransfer where PODNumber='" + podnumber + "'"));
                if (count >= 2)
                {
                    string maxidupdate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT id FROM st_PodTransfer where PODNumber='" + podnumber + "' order by id desc limit 1,1"));
                    iscurrent = 0;
                    MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"update st_PodTransfer set Iscurrent=1,Status='Transfer' where PODNumber='" + podnumber + "' and id=" + maxidupdate + "");
                }
                else
                {
                   MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"delete from st_PodTransfer where PODNumber='" + podnumber + "'");
                   MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"update st_pod_details set couriername='',consinmentno='',IsPOD_transfer =0,POD_Transferby='0' where PODnumber='" + podnumber + "'");
                }
            }

            if (PODType == "Transfer")
            {
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update st_pod_details set Is_forwarded='1',forwarded_by='" + UserInfo.ID + "',forward_date=now() where PODnumber='" + podnumber + "'");
            }
            if (PODType == "Accept")
            {
                MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "update st_pod_details set IsPOD_Accept='1',Pod_acceptedby='" + UserInfo.ID + "',Pod_Acceptdate=now() where PODnumber='" + podnumber + "'");
            }
        
               MySqlHelper.ExecuteScalar(tnx, CommandType.Text,"update st_PodTransfer set Iscurrent=0,Status='Recieved' where PODNumber='" + podnumber + "' and id=" + maxid + "");
       
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_PodTransfer (PodNumber,FromEmployeeId,Status,IsCurrent)values(@PodNumber,@FromEmployeeId,@Status,@IsCurrent)",
                           new MySqlParameter("@PodNumber", podnumber),
                           new MySqlParameter("@FromEmployeeId", UserInfo.ID),
                           new MySqlParameter("@Status", PODType),
                           new MySqlParameter("@IsCurrent", iscurrent));


               //***************************Log generate******************************************************************//
               MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_PodTransfer_Log(PodNumber,EmployeeId,STATUS)values(@PodNumber,@FromEmployeeId,@Status)",
                             new MySqlParameter("@PodNumber", podnumber),
                             new MySqlParameter("@FromEmployeeId", UserInfo.ID),
                             new MySqlParameter("@Status", PODType));
               //**************************************end*******************************************************************************************

             tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PODTransferReject(string podnumber, string PODType, string Reason)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string maxid = Util.GetString(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"select id from st_PodTransfer where PODNumber='" + podnumber + "' and Iscurrent=1"));
            int iscurrent = 1;
            if (PODType == "Reject")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select count(1) from st_PodTransfer where PODNumber='" + podnumber + "'"));
                if (count >= 2)
                {
                    string maxidupdate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT id FROM st_PodTransfer where PODNumber='" + podnumber + "' order by id desc limit 1,1"));
                    iscurrent = 0;
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_PodTransfer set Iscurrent=1,Status='Transfer' where PODNumber='" + podnumber + "' and id=" + maxidupdate + "");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_pod_details set Remarks='" + Reason + "'  where PODnumber='" + podnumber + "'");
                   
                }
                else
                {
                   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_PodTransfer where PODNumber='" + podnumber + "'");
                   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_pod_details set Remarks='" + Reason + "' , couriername='',consinmentno='',IsPOD_transfer =0,POD_Transferby='0' where PODnumber='" + podnumber + "'");
                    // st_ledgertransaction isPODNumber=0,podnumber=''
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_ledgertransaction set PODnumber ='',Ispodgenerate =0 where PODNumber='" + podnumber + "' ");

                }
            }
           
           MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_PodTransfer set Iscurrent=0,Status='Recieved' where PODNumber='" + podnumber + "' and id=" + maxid + "");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_PodTransfer (PodNumber,FromEmployeeId,Status,IsCurrent)values(@PodNumber,@FromEmployeeId,@Status,@IsCurrent)",
                           new MySqlParameter("@PodNumber", podnumber),
                           new MySqlParameter("@FromEmployeeId", UserInfo.ID),
                           new MySqlParameter("@Status", PODType),
                           new MySqlParameter("@IsCurrent", iscurrent));

            //***************************Log generate******************************************************************//
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_PodTransfer_Log(PodNumber,EmployeeId,STATUS)values(@PodNumber,@FromEmployeeId,@Status)",
                          new MySqlParameter("@PodNumber", podnumber),
                          new MySqlParameter("@FromEmployeeId", UserInfo.ID),
                          new MySqlParameter("@Status", PODType));
            //**************************************end*******************************************************************************************


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    
    }

    
}