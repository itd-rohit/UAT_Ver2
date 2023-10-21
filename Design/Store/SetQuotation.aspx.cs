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


public partial class Design_Store_SetQuotation : System.Web.UI.Page
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
    public static string binditem()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  itemid,typename FROM `st_itemmaster` where isactive=1  ORDER BY typename"));



    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT MachineID,MachineName FROM `st_vendorqutation` ORDER BY MachineName"));



    }
    [WebMethod(EnableSession = true)]
    public static string bindsupplier()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT VendorId,VendorName FROM `st_vendorqutation` ORDER BY VendorName"));
    }

    [WebMethod(EnableSession = true)]
    public static string SearchFromRecords(string locationid, string machineid, string supplier,string itemid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sv.id mapid, itemid,deliverylocationid, vendorname,VednorStateName,MachineName,(select typename from st_itemmaster where itemid=sv.itemid)ItemName,Rate,DiscountPer ,DiscountAmt,IGSTPer,SGSTPer,CGSTPer,");
        sb.Append(" GSTAmount,FinalPrice,ComparisonStatus FROM st_vendorqutation sv");

        sb.Append(" where deliverylocationid='" + locationid + "' ");
        sb.Append(" and ApprovalStatus=2 and EntryDateTo>=date(now()) ");

        if (machineid != "")
        {
            sb.Append(" and machineid in (" + machineid + ") ");
        }
        if (supplier != "")
        {
            sb.Append(" and VendorId in (" + supplier + ") ");
        }
        if (itemid != "")
        {
            sb.Append(" and itemid in (" + itemid + ") ");
        }
        sb.Append(" order by MachineName,ItemName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));




    }


    [WebMethod(EnableSession = true)]
    public static string savedata(List<SetQuotation1> dataIm)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (SetQuotation1 ss in dataIm)
            {
                StringBuilder sbupdate = new StringBuilder();
                sbupdate.Append("update st_vendorqutation set ComparisonStatus=0,IsActive=1 where DeliveryLocationID=" + ss.locationid + " and itemid='" + ss.itemid + "' and  ApprovalStatus=2");
              
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());

                sbupdate = new StringBuilder();
                sbupdate.Append("update st_vendorqutation set ComparisonStatus=1,IsActive=1 where DeliveryLocationID=" + ss.locationid + " and itemid='" + ss.itemid + "' and id="+ss.mapid+"");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbupdate.ToString());
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
    
}

public class SetQuotation1
{
    public string mapid { get; set; }
    public string locationid { get; set; }
    public string itemid { get; set; }
}