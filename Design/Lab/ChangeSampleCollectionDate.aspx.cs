using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Text;

public partial class Design_Lab_ChangeSampleCollectionDate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetData(string VisitNo)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  lt.pname,lt.Age,lt.Gender,lt.PanelName,cm.`Centre`,plo.LedgertransactionNo,plo.Test_id,plo.BarcodeNo,plo.Itemname,DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%y %r')sampledate,IFNULL(DATE_FORMAT(plo.sampleReceivedate,'%d-%b-%y'),'')sampleReceivedate,plo.`Approved` FROM patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` INNER JOIN centre_master cm ON cm.`CentreID`=plo.`CentreID` WHERE plo.`LedgerTransactionNo`='" + VisitNo + "' and plo.result_flag=0");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string UpdateData(List<Sampledetails> objSampledetails)
    {
        for (int i = 0; i < objSampledetails.Count; i++)
        {
            string dtsampledate = Convert.ToDateTime(objSampledetails[i].sampledate).ToString("yyyy-MM-dd HH:mm:ss");
            StockReports.ExecuteDML("Update patient_labinvestigation_opd set SampleCollectionDate='" + dtsampledate + "' where Test_ID='" + objSampledetails[i].testid + "'");
        }
        return "1";
    }


    public class Sampledetails
    {
        public string sampledate { get; set; }
        public string testid { get; set; }

    }
}