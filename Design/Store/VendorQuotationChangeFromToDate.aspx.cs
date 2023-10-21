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


public partial class Design_Store_VendorQuotationChangeFromToDate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod(EnableSession = true)]
    public static string bindlocation()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  deliverylocationid,deliverylocationname FROM `st_vendorqutation` group by deliverylocationid ORDER BY deliverylocationname"));



    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT MachineID,MachineName FROM `st_itemmaster` ORDER BY MachineName"));



    }
    [WebMethod(EnableSession = true)]
    public static string bindsupplier()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT supplierid VendorId,suppliername VendorName FROM `st_vendormaster` WHERE isactive=1 ORDER BY suppliername"));
    }


    [WebMethod(EnableSession = true)]
    public static string binditem()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  itemid,typename FROM `st_itemmaster` WHERE isactive=1 ORDER BY itemid"));



    }
    [WebMethod(EnableSession = true)]
    public static string SearchFromRecords(string locationid, string machineid, string supplier, string maxrecord, string expiry)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  ");
        sb.Append(" SELECT sv.ID,sv.VendorName,sv.VednorStateName,sv.DeliveryStateName,sv.DeliveryLocationName,sv.ItemName,sv.ManufactureName,sv.MachineName,im.itemid, ");
        sb.Append(" DATE_FORMAT(EntryDateFrom,'%d-%b-%Y')EntryDateFrom,DATE_FORMAT(EntryDateTo,'%d-%b-%Y')EntryDateTo ,im.HSNCode,im.PackSize ");
        sb.Append(" FROM  `st_vendorqutation` sv ");
        sb.Append(" INNER JOIN st_itemmaster im ON sv.itemid=im.itemid ");
        sb.Append(" where   sv.ApprovalStatus=2 and sv.isactive=1");
        if (locationid != "")
        {
            sb.Append(" and sv.DeliveryLocationID in (" + locationid + ")");
        }
        if (machineid != "")
        {
            sb.Append(" and sv.MachineID in (" + machineid + ")");
        }
        if (supplier != "")
        {
            sb.Append(" and sv.VendorId in (" + supplier + ")");
        }

        if (expiry != "0")
        {
            sb.Append(" and sv.EntryDateTo<=date(DATE_ADD(NOW(),INTERVAL "+expiry+" DAY)) and sv.EntryDateTo>=date(now())");
        }
        else
        {
            sb.Append(" and sv.EntryDateTo<=date(NOW())");
        }
        sb.Append(" ORDER BY sv.EntryDateTo asc ");
        sb.Append(" limit " + maxrecord + " ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod]
    public static string Savedata(List<string> data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            foreach (string indata in data)
            {
                string id = indata.Split('#')[0];
                string todate =Util.GetDateTime(indata.Split('#')[1]).ToString("yyyy-MM-dd");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_vendorqutation set EntryDateTo='" + todate + "',Updatedate=now(),updatebyid='"+UserInfo.ID+"' where id='" + id + "'");
            }

            tnx.Commit();



            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();

            return ex.Message;

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    
}
