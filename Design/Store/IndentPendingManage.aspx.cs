using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Store_IndentPendingManage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',panel_id) locationid,location FROM st_locationmaster WHERE isactive=1   ");
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
    public static string bindcompletedata(string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT ifnull(sd.PendingRemarks,'')PendingRemarks,MinorUnitInDecimal, sd.IssueInvoiceNo, locationid,panel_id,st.itemid,sd.batchnumber,IF(expirydate='0001-01-01','', DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ItemName,st.stockid,(sendqty-receiveqty-ConsumeQty-StockInQty) pendingqty,sd.IndentNo");
        sb.Append(" FROM st_nmstock st inner join  st_indentissuedetail sd ");
        sb.Append("   on sd.stockid=st.stockid AND sendqty-receiveqty>0 and  sd.itemid=st.itemid");
        sb.Append("  ");
        sb.Append(" WHERE (sendqty-receiveqty-ConsumeQty-StockInQty)>0 and locationid='" + locationid.Split('#')[0] + "' ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Indentdata(string indentno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IndentNo,ItemName, ");
        sb.Append("  (SELECT location FROM st_locationmaster WHERE locationid= ToLocationID)IndentToLoccation,(SELECT location FROM st_locationmaster WHERE locationid= FromLocationID) IndentFromLoccation,ApprovedQty ReqQty,MinorUnitName, ");
        sb.Append(" ReceiveQty,PendingQty, RejectQty,UserName IndentSendBy, ");

        sb.Append("  DATE_FORMAT(dtEntry,'%d-%b-%Y') IndentDate ");
        sb.Append("  FROM `st_indent_detail` ");
        sb.Append("   WHERE IndentNo='" + indentno + "' ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


   
      [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savestock(List<string[]> consumedata, List<string[]> stockindata)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //consume data
            if (consumedata.Count > 0)
            {
                foreach (string[] mydataadj in consumedata)
                {

                    string sql = "select if(InitialCount < (ReleasedCount+" + Util.GetFloat(mydataadj[3]) + "),0,1)CHK from st_nmstock where stockID='" + mydataadj[2] + "'";
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                    {
                        tnx.Rollback();

                        return "Stock Unavailable";
                    }


                    int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(1)"));
                    StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                    objnssaled.FromLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled.ToLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled.StockID = Util.GetInt(mydataadj[2]);
                    objnssaled.Quantity = Util.GetFloat(mydataadj[3]);
                    objnssaled.TrasactionTypeID = 1;
                    objnssaled.TrasactionType = "Consume";
                    objnssaled.ItemID = Util.GetInt(mydataadj[4]);

                    objnssaled.IndentNo = mydataadj[5];
                    objnssaled.Naration = mydataadj[7];
                    objnssaled.SalesNo = SalesNo;
                    string saledid = objnssaled.Insert();
                    if (saledid == string.Empty)
                    {
                        tnx.Rollback();
                        return "Sales Not Saved";
                    }
                    
                    string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(mydataadj[3]) + " ,pendingqty=pendingqty- " + Util.GetFloat(mydataadj[3]) + " where StockID = '" + mydataadj[2] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);

                    string indentupdate = "update st_indent_detail set RejectQty=RejectQty+" + Util.GetFloat(mydataadj[3]) + " where IndentNo='" + mydataadj[5] + "' and itemid='" + mydataadj[4] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, indentupdate);

                    string indentupdate1 = "update st_indentissuedetail set ConsumeQty=ConsumeQty+" + Util.GetFloat(mydataadj[3]) + " where IndentNo='" + mydataadj[5] + "' and itemid='" + mydataadj[4] + "' and stockid='" + mydataadj[2] + "' and IssueInvoiceNo='" + mydataadj[6] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, indentupdate1);




                    int SalesNo1 = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(10)"));
                    StoreSalesDetail objnssaled1 = new StoreSalesDetail(tnx);
                    objnssaled1.FromLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled1.ToLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled1.StockID = Util.GetInt(mydataadj[2]);
                    objnssaled1.Quantity = Util.GetFloat(mydataadj[3]);
                    objnssaled1.TrasactionTypeID = 10;
                    objnssaled1.ItemID = Util.GetInt(mydataadj[4]);
                    objnssaled1.TrasactionType = "InTransitConsume";
                    objnssaled1.IndentNo = mydataadj[5];
                    objnssaled1.Naration = "";
                    objnssaled1.SalesNo = SalesNo1;
                    string saledid1 = objnssaled1.Insert();
                    if (saledid1 == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }

                }


            }
            // Stock IN
            if (stockindata.Count > 0)
            {
                foreach (string[] mydataadj in stockindata)
                {

                    string strUpdateStock = "update st_nmstock set pendingqty=pendingqty- " + Util.GetFloat(mydataadj[3]) + " where StockID = '" + mydataadj[2] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);

                    string indentupdate = "update st_indent_detail set RejectQty=RejectQty+" + Util.GetFloat(mydataadj[3]) + " where IndentNo='" + mydataadj[5] + "' and itemid='" + mydataadj[4] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, indentupdate);

                    string indentupdate1 = "update st_indentissuedetail set StockInQty=StockInQty+" + Util.GetFloat(mydataadj[3]) + " where IndentNo='" + mydataadj[5] + "' and itemid='" + mydataadj[4] + "' and stockid='" + mydataadj[2] + "' and IssueInvoiceNo='" + mydataadj[6] + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, indentupdate1);


                    int SalesNo1 = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(11)"));
                    StoreSalesDetail objnssaled1 = new StoreSalesDetail(tnx);
                    objnssaled1.FromLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled1.ToLocationID = Util.GetInt(mydataadj[0]);
                    objnssaled1.StockID = Util.GetInt(mydataadj[2]);
                    objnssaled1.Quantity = Util.GetFloat(mydataadj[3]);
                    objnssaled1.TrasactionTypeID = 11;
                    objnssaled1.ItemID = Util.GetInt(mydataadj[4]);
                    objnssaled1.TrasactionType = "InTransitStockIn";
                    objnssaled1.IndentNo = mydataadj[5];
                    objnssaled1.Naration = "";
                    objnssaled1.SalesNo = SalesNo1;
                    string saledid1 = objnssaled1.Insert();
                    if (saledid1 == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Sales Not Saved";
                    }



                }
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