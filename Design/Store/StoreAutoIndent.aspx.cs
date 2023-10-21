using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_StoreAutoIdent : System.Web.UI.Page
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
    public static string SearchData(string location, string item, string fromdate, string todate,string indenttype)
    {

        if (location == "null" || location == null)
        {
            location = "";
        }
        if (item == "null" || item == null)
        {
            item = "";
        }
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        MySqlDataAdapter da = new MySqlDataAdapter("store_autoindentdata", con); 
        da.SelectCommand.CommandType = CommandType.StoredProcedure; 
        DataSet ds = new DataSet(); 
        da.SelectCommand.Parameters.AddWithValue("@_locationid", location.Trim());
        da.SelectCommand.Parameters.AddWithValue("@_itemid", item.Trim());
        da.SelectCommand.Parameters.AddWithValue("@_fromdate",Convert.ToDateTime(fromdate).ToString("yyyy-MM-dd")+" 00:00:00");
        da.SelectCommand.Parameters.AddWithValue("@_todate",Convert.ToDateTime(todate).ToString("yyyy-MM-dd")+" 23:59:59");
        da.SelectCommand.Parameters.AddWithValue("@_indenttype", indenttype);
        da.Fill(ds);


        
        return Newtonsoft.Json.JsonConvert.SerializeObject(ds.Tables[0]);
    
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveindent(List<StoreSalesIndent> store_SaveIndentdetail)
    {
        int generatelocation = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
           
                // Cheking Rights For Maker
                StringBuilder sbRigths = new StringBuilder();
                sbRigths.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
                sbRigths.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 ");
                sbRigths.Append(" AND AppRightFor='" + store_SaveIndentdetail[0].IndentType + "' AND TypeName='Maker' ");
                DataTable dtRigths = StockReports.GetDataTable(sbRigths.ToString());
                if (dtRigths.Rows.Count == 0)
                {
                    Exception ex = new System.Exception("Dear User You Did not Have Any Right To Make " + store_SaveIndentdetail[0].IndentType);
                    throw ex;
                }


                string indentno = "";
              

                foreach (StoreSalesIndent ssi in store_SaveIndentdetail)
                {
                    if (generatelocation != ssi.FromLocationID)
                    {
                        indentno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('" + store_SaveIndentdetail[0].IndentType + "')").ToString();
                       
                    }
                    
                  
                    if (indentno == "")
                    {
                        tnx.Rollback();
                        return "0#Error";
                    }


                    DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT sl.panel_id,sc.toloationid FROM st_centerindentright sc INNER JOIN st_locationmaster sl ON sc.toloationid=sl.locationid where sc.indenttype='SI' and sc.fromloationid=" + ssi.FromLocationID + "").Tables[0];

                    if (dt.Rows.Count == 0)
                    {
                        continue;
                    }


                     DataTable dtitem = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT `MinorUnitId`,`MinorUnitName`,GSTNTax FROM st_itemmaster WHERE itemid=" + ssi.ItemId + "").Tables[0];
                    StoreSalesIndent objindent = new StoreSalesIndent(tnx);
                    objindent.IndentNo = indentno;
                    objindent.ItemId = ssi.ItemId;
                    objindent.ItemName = ssi.ItemName;
                    objindent.FromLocationID = ssi.FromLocationID;
                    objindent.FromPanelId = ssi.FromPanelId;
                    objindent.ToLocationID = Convert.ToInt32(dt.Rows[0][1].ToString()); //ssi.ToLocationID;
                    objindent.ToPanelID = Convert.ToInt32(dt.Rows[0][0].ToString()); //ssi.ToPanelID;
                    objindent.ReqQty = ssi.ReqQty;
                    objindent.MinorUnitID = Convert.ToInt32(dtitem.Rows[0][0].ToString()); //ssi.MinorUnitID;
                    objindent.MinorUnitName = dtitem.Rows[0][1].ToString(); //ssi.MinorUnitName;
                    objindent.ExpectedDate = Util.GetDateTime(ssi.ExpectedDate);
                    objindent.Narration = ssi.Narration;
                    objindent.IndentType = ssi.IndentType;
                    objindent.Rate = ssi.Rate;
                    objindent.DiscountPer = ssi.DiscountPer;
                    objindent.TaxPerIGST = ssi.TaxPerIGST;
                    objindent.TaxPerCGST = ssi.TaxPerCGST;
                    objindent.TaxPerSGST = ssi.TaxPerSGST;
                    objindent.FromRights = "Maker";
                    objindent.NetAmount = ssi.NetAmount;
                    objindent.UnitPrice = ssi.UnitPrice;
                    objindent.Vendorid = ssi.Vendorid;
                    objindent.VendorStateId = ssi.VendorStateId;
                    objindent.VednorStateGstnno = ssi.VednorStateGstnno;

                    objindent.MaxQty = ssi.MaxQty;



                    string a = objindent.Insert();
                    if (a == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Error";
                    }

                    if (objindent.IndentType == "PI")
                    {
                        if (ssi.mapid.Split('#')[1] == "SampleProcessing")
                        {
                            string strUpdateStock1 = "update mac_data_AutoConsumption set IsAutoPIDone = 1 where EntryID in  (" + ssi.mapid.Split('#')[0] + ")";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);
                        }
                        else
                        {
                            string strUpdateStock1 = "update st_patienttransaction set IsAutoPIDone = 1 where id in  (" + ssi.mapid.Split('#')[0] + ")";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);
                        }
                    }
                    else
                    {

                        if (ssi.mapid.Split('#')[1] == "SampleProcessing")
                        {
                            string strUpdateStock1 = "update mac_data_AutoConsumption set IsAutoSIDone = 1 where EntryID in  (" + ssi.mapid.Split('#')[0] + ")";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);
                        }
                        else
                        {
                            string strUpdateStock1 = "update st_patienttransaction set IsAutoSIDone = 1 where id in  (" + ssi.mapid.Split('#')[0] + ")";
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);
                        }

                       
                    }


                    generatelocation = ssi.FromLocationID;
                }


               

                tnx.Commit();
                return "1#" + indentno;
            
           

        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);

        }
        finally
        {
            //  SIndentData = SIndentData;
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}