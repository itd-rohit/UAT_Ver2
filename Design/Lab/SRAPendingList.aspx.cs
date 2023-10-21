using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;


public partial class Design_Lab_SRAPendingList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          //  txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromdate.Text = DateTime.Now.AddDays(-7).ToString("dd-MMM-yyyy");
        }
    }

    [WebMethod]
    public static string SearchPendingData(string fromdate, string todate, string type,string sortby,string sortorder)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" select DISTINCT Centre, SampleTypeName, PName, PanelName, patient_id,SINNo,VisitID, Centre,Department,TestName,test_id,LastStatusDate,");
            sbQuery.Append(" CONCAT(TIMESTAMPDIFF(DAY,LastDate,NOW()) , ' Days ',MOD( TIMESTAMPDIFF(HOUR,LastDate,NOW()), 24), ' Hours ',MOD( TIMESTAMPDIFF(MINUTE,LastDate,NOW()), 60), ' Min ') TimeDiffe,");
            sbQuery.Append(" TIMESTAMPDIFF(MINUTE, t.LastDate, NOW()) TimeDiffe1,ReferedBy  from ( SELECT (select centre from centre_master where centreid=pli.centreid) Centre, pli.BarcodeNo SINNo,");
            sbQuery.Append("pli.ledgerTransactionNO VisitID,pli.patient_id patient_id,lt.PName,lt.PanelName,pli.`SampleTypeName`, ");
            sbQuery.Append(" ot.Name Department,pli.itemname TestName,pli.test_id");

            if (type == "0")
            {
                sbQuery.Append(" ,date_format(sl.TransferredDate,'%d-%b-%Y %h:%i %p')LastStatusDate ,sl.TransferredDate LastDate");
            }
            else if (type == "1")
            {
                sbQuery.Append(" ,date_format(ifnull(sl.ReceivedDate,pli.date),'%d-%b-%Y %h:%i %p')LastStatusDate,ifnull(sl.ReceivedDate,pli.date) LastDate");
            }
            else if (type == "2")
            {
                sbQuery.Append(" ,date_format(sl.ReceivedDate,'%d-%b-%Y %h:%i %p')LastStatusDate ,sl.ReceivedDate LastDate ");
            }
            else if (type == "3")
            {
                sbQuery.Append(" ,date_format(pli.date,'%d-%b-%Y %h:%i %p')LastStatusDate,pli.date LastDate");
            }
            sbQuery.Append(" ,(SELECT NAME FROM doctor_referal WHERE Doctor_Id=lt.Doctor_Id LIMIT 1) ReferedBy ");
            sbQuery.Append(" FROM  patient_labinvestigation_opd pli  ");
            sbQuery.Append(" INNER JOIN investigation_observationtype iot ON pli.investigation_ID=iot.investigation_ID ");
            sbQuery.Append(" inner join observationtype_master ot on ot.ObservationType_ID=iot.ObservationType_ID");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=pli.ledgerTransactionID   and pli.IsReporting='1' ");
            if (type == "0")
            {
                sbQuery.Append(" inner join sample_logistic sl on sl.barcodeno=pli.barcodeno and sl.isactive=1 and pli.issamplecollected='S'");//and pli.issamplecollected<>'Y
                sbQuery.Append(" AND sl.tocentreid=@centreID  ");
                sbQuery.Append(" AND sl.status='Transferred' ");
                sbQuery.Append(" AND sl.TransferredDate >=@fromDate ");
                sbQuery.Append(" AND sl.TransferredDate <=@todate ");

            }
            else if (type == "1")
            {
                sbQuery.Append(" left join sample_logistic sl on sl.barcodeno=pli.barcodeno and sl.isactive=1 and pli.issamplecollected='S'");  //and pli.issamplecollected<>'Y'
                sbQuery.Append("  AND sl.LogisticReceiveDate >=@fromDate ");
                sbQuery.Append(" AND sl.LogisticReceiveDate <=@todate ");
                sbQuery.Append(" where ifnull(sl.status,'')  in ('','Received at Hub') and ( pli.date >=@fromDate and pli.date <=@todate) and pli.issamplecollected='S'");  //and pli.issamplecollected<>'Y'
                sbQuery.Append(" and ifnull(sl.tocentreid,pli.centreid)=@centreID  ");
            }
            else if (type == "2")
            {
                sbQuery.Append(" inner join sample_logistic sl on sl.barcodeno=pli.barcodeno and sl.isactive=1 and pli.issamplecollected='S'");  //and pli.issamplecollected<>'Y'
                sbQuery.Append(" and sl.tocentreid=@centreID  ");
                sbQuery.Append(" and sl.status='Received' ");
                sbQuery.Append("  AND sl.ReceivedDate >=@fromDate ");
                sbQuery.Append(" AND sl.ReceivedDate <=@todate");

            }
            else if (type == "3")
            {
                sbQuery.Append(" where pli.centreid=@centreID and  pli.date >=@fromDate and pli.date <=@todate and pli.issamplecollected in('S','N') and pli.Interface_companyName='Insta' ");
            }
            sbQuery.Append(" AND pli.IsSampleCollected <> 'R' and pli.Barcodeno <>'' ");


            sbQuery.Append("   ) t order by " + sortby + " " + sortorder + " ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
               new MySqlParameter("@centreID", UserInfo.Centre),
               new MySqlParameter("@fromDate",string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd")," 00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " 23:59:59"))
               ).Tables[0]);

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}