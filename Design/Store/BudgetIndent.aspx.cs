using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Store_BudgetIndent : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            DataTable dt = accessRight();
            if (dt.Rows.Count == 0)
            {
                lblError.Text = "You do not have right to access this page";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "accessRight();", true);
                return;
            }
            else
            {
                int MakerCount = dt.AsEnumerable().Count(row => "Maker" == row.Field<String>("TypeName"));
                lblApprovalCount.Text = Util.GetString(dt.AsEnumerable().Count(row => "Approval" == row.Field<String>("TypeName")));
            }
        }
    }

    private DataTable accessRight()
    {
        return StockReports.GetDataTable("SELECT TypeName FROM st_approvalright WHERE TypeName IN('Maker','Approval') AND AppRightFor='BG' AND EmployeeID='" + UserInfo.ID + "' AND Active=1 ");
    }

    [WebMethod]
    public static string bindcentertype()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod]
    public static string bindData(string CentreType, string CategoryType, string Manufacture, string ZoneID, string SubCategory, string Machine, string StateID, string ItemType, string ItemIDGroup, string FromDate, string ToDate, string CityID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cm.Centre CentreName,cm.centreID,fpm.Panel_ID,GROUP_CONCAT(ind.IndentNo)IndentNo,ind.FromLocationID,ind.ID,im.ItemID,img.ItemNameGroup ItemName,subm.SubCategoryTypeName SubCategoryType,sub.Name ItemType ,  ");
        sb.Append(" im.ManufactureID,im.ManufactureName Manufacture,im.MachineID,im.MachineName,im.PackSize,im.MajorUnitName PurchaseUnit,TrimZero(ind.Rate)Rate,TrimZero(ind.DiscountPer)DiscountPer, ");
        sb.Append(" TrimZero(ind.TaxPerCGST+ind.TaxPerIGST+ind.TaxPerSGST)TaxPer ,SUM(ind.NetAmount)NetAmount,IF(im.MajorUnitInDecimal =0,TRUNCATE(SUM(IF(ind.BudgetQty=0,ApprovedQty,BudgetQty)),0),SUM(IF(ind.BudgetQty=0,ApprovedQty,BudgetQty)))Qty,SUM(ind.ApprovedQty+ind.MaxQty)ApprovedQty, ");
        sb.Append(" IFNULL(indm.AverageConsumption,0)AverageConsumption,im.MajorUnitInDecimal ");
        sb.Append(" ");
        sb.Append(" FROM st_indent_detail ind INNER JOIN f_panel_master fpm ON ind.FromPanelId=fpm.Panel_ID AND fpm.PanelType='Centre' ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=fpm.CentreID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON fpm.Panel_ID=loc.Panel_ID AND ind.FromLocationID=loc.LocationID ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.ItemID=ind.ItemId ");
        sb.Append(" INNER JOIN st_itemmaster_group img ON img.ItemIDGroup=im.ItemIDGroup ");
        sb.Append(" INNER JOIN `st_Subcategorytypemaster` subm ON subm.SubCategoryTypeID=im.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster sub ON sub.SubCategoryID =im.SubCategoryID ");
        sb.Append(" LEFT JOIN st_itemlocationindentmaster indm ON indm.ItemID=ind.ItemID AND indm.LocationID=loc.LocationID ");
        sb.Append(" WHERE ind.IndentType='PI' AND ind.IsActive=1 AND ind.isCancel=0  AND IsBudget=0 AND IFNULL(PIGroupID,'')='' ");
        sb.Append(" AND ApprovedQty>0 ");
        sb.Append(" AND ind.dtEntry>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND ind.dtEntry<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (CentreType != string.Empty)
            sb.Append(" AND cm.Type1 IN (" + CentreType + ")");
        if (CategoryType != string.Empty)
            sb.Append(" AND subm.CategoryTypeID IN (" + CategoryType + ")");
        if (Manufacture != string.Empty)
            sb.Append(" AND im.ManufactureID IN (" + Manufacture + ")");
        if (ZoneID != string.Empty)
            sb.Append(" AND cm.BusinessZoneID IN (" + ZoneID + ")");

        if (SubCategory != string.Empty)
            sb.Append(" AND subm.SubCategoryTypeID IN (" + SubCategory + ")");
        if (Machine != string.Empty)
            sb.Append(" AND im.MachineID IN (" + Machine + ")");
        if (StateID != string.Empty)
            sb.Append(" AND cm.StateID IN (" + StateID + ")");
        if (ItemType != string.Empty)
            sb.Append(" AND sub.SubCategoryID IN (" + ItemType + ")");
        if (ItemIDGroup != string.Empty)
            sb.Append(" AND im.ItemIDGroup IN (" + ItemIDGroup + ")");
        if (CityID != string.Empty)
            sb.Append(" AND cm.CityID IN (" + CityID + ")");
        sb.Append(" Group BY ind.FromLocationID,ind.ItemID");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            using (DataTable dtMerge = new DataTable())
            {
                if (dt.Rows.Count > 0)
                {
                    dtMerge.Columns.Add("SubCategoryType");
                    dtMerge.Columns.Add("ItemID");
                    dtMerge.Columns.Add("ItemType");
                    dtMerge.Columns.Add("ItemName");
                    dtMerge.Columns.Add("MachineName");
                    dtMerge.Columns.Add("Manufacture");

                    dtMerge.Columns.Add("PackSize");
                    dtMerge.Columns.Add("PurchaseUnit");
                    //  dtMerge.Columns.Add("Rate");
                    // dtMerge.Columns.Add("DiscountPer");
                    //  dtMerge.Columns.Add("TaxPer");
                    dtMerge.Columns.Add("Qty", typeof(decimal));
                    dtMerge.Columns.Add("NetAmount", typeof(decimal));

                    DataRow newrow = dtMerge.NewRow();
                    foreach (DataRow dr in dt.Rows)
                    {
                        DataRow[] RowCreated = dtMerge.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                        if (RowCreated.Length == 0)
                        {
                            DataRow[] RowExist = dt.Select("ItemID='" + dr["ItemID"].ToString() + "'");
                            if (RowExist.Length > 0)
                            {
                                DataRow row = dtMerge.NewRow();
                                row["ItemID"] = RowExist[0]["ItemID"].ToString();
                                row["SubCategoryType"] = RowExist[0]["SubCategoryType"].ToString();
                                row["ItemType"] = RowExist[0]["ItemType"].ToString();
                                row["ItemName"] = RowExist[0]["ItemName"].ToString();
                                row["MachineName"] = RowExist[0]["MachineName"].ToString();
                                row["Manufacture"] = RowExist[0]["Manufacture"].ToString();
                                row["PackSize"] = RowExist[0]["PackSize"].ToString();
                                row["PurchaseUnit"] = RowExist[0]["PurchaseUnit"].ToString();

                                //  row["Rate"] = RowExist[0]["Rate"].ToString();
                                //  row["DiscountPer"] = RowExist[0]["DiscountPer"].ToString();
                                //   row["TaxPer"] = RowExist[0]["TaxPer"].ToString();

                                //decimal GrossAmt = Util.GetDecimal(RowExist[0]["Rate"].ToString()) * Util.GetDecimal(RowExist[0]["ReqQty"].ToString());
                                //decimal Newprice = Util.GetDecimal(GrossAmt) - (Util.GetDecimal(RowExist[0]["DiscountPer"].ToString()) * Util.GetDecimal(GrossAmt) * Util.GetDecimal(0.01));
                                //decimal NetAmt = Util.GetDecimal(Newprice) + Util.GetDecimal(Util.GetDecimal(Newprice) * Util.GetDecimal(RowExist[0]["TaxPer"].ToString()) * Util.GetDecimal(0.01));

                                decimal NetAmount = 0; decimal Qty = 0;
                                for (int i = 0; i < RowExist.Length; i++)
                                {
                                    if (!dtMerge.Columns.Contains(RowExist[i]["CentreName"].ToString() + "#" + RowExist[i]["FromLocationID"].ToString()))
                                    {
                                        dtMerge.Columns.Add(RowExist[i]["CentreName"].ToString() + "#" + RowExist[i]["FromLocationID"].ToString());
                                    }
                                    NetAmount = NetAmount + Util.GetDecimal(RowExist[i]["NetAmount"].ToString());
                                    Qty = Qty + Util.GetDecimal(RowExist[i]["Qty"].ToString());

                                    row[string.Concat(RowExist[i]["CentreName"].ToString(), "#", RowExist[i]["FromLocationID"].ToString())] = string.Concat(RowExist[i]["Qty"].ToString(), "#", RowExist[i]["AverageConsumption"].ToString(), "#", RowExist[i]["IndentNo"].ToString(), "#", RowExist[i]["Rate"].ToString(), "#", RowExist[i]["DiscountPer"].ToString(), "#", RowExist[i]["TaxPer"].ToString(), "#", RowExist[i]["MajorUnitInDecimal"].ToString(), '#', RowExist[i]["ApprovedQty"].ToString());
                                }
                                row["NetAmount"] = NetAmount.ToString();
                                row["Qty"] = Qty.ToString();
                                dtMerge.Rows.Add(row);
                            }
                        }
                    }

                    // Util.GetInt(dt.Compute("SUM(Qty)", String.Empty))
                    DataRow newrow1 = dtMerge.NewRow();
                    newrow1["SubCategoryType"] = ""; newrow1["ItemType"] = ""; newrow1["ItemName"] = ""; newrow1["MachineName"] = ""; newrow1["Manufacture"] = "";
                    newrow1["PackSize"] = ""; newrow1["PurchaseUnit"] = "Total";

                    newrow1["Qty"] = Util.GetString(dtMerge.AsEnumerable().Sum(x => x.Field<decimal>("Qty")));
                    newrow1["NetAmount"] = Util.GetString(dtMerge.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount")));
                    dtMerge.Rows.Add(newrow1);

                    return Util.getJson(dtMerge);
                }
                else
                {
                    return "";
                }
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string updateBudgetIndent(string IndentNo, string ItemID, string BudgetQty)
    {
        using (MySqlConnection conn = Util.GetMySqlCon())
        {
            conn.Open();
            using (MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "SELECT COUNT(*) FROM st_approvalright WHERE TypeName IN ('Maker','Approval') AND AppRightFor='BG' AND EmployeeID=@EmployeeID AND Active=1 ",
                        new MySqlParameter("@EmployeeID", UserInfo.ID)));
                    if (count > 0)
                    {
                        string[] IndentNoList = IndentNo.Split(',');
                        Array.Reverse(IndentNoList);
                        string ConcatData = string.Empty; string PIGroupID = string.Empty;
                        for (int i = 0; i < IndentNoList.Length; i++)
                        {
                            if (i == 0)
                            {
                                PIGroupID = IndentNoList[i].ToString();
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_indent_detail SET BudgetQty=@BudgetQty,NetAmount=(Rate*(1 - (DiscountPer*0.01)) + (Rate*(1 - (DiscountPer*0.01))*(TaxPerIGST+TaxPerCGST+TaxPerSGST)*0.01))*@BudgetQty WHERE IndentNo=@IndentNo AND ItemID=@ItemID",
                                 new MySqlParameter("BudgetQty", Util.GetDecimal(BudgetQty)), new MySqlParameter("IndentNo", IndentNoList[i].ToString()), new MySqlParameter("ItemID", ItemID));
                            }
                            else
                            {
                                if (ConcatData == string.Empty)
                                    ConcatData = string.Concat("(", ItemID, ",'", IndentNoList[i].ToString(), "'", ")");
                                else
                                    ConcatData = string.Concat(ConcatData, ",(", ItemID, ",'", IndentNoList[i].ToString(), "'", ")");
                            }
                        }
                        if (ConcatData != string.Empty)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_indent_detail SET PIGroupID='" + PIGroupID + "',NetAmount=0 WHERE (ItemID,IndentNo) IN (" + ConcatData + ")");
                        }
                        tnx.Commit();
                        return "1";
                    }
                    else
                    {
                        return "2";
                    }
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
                    conn.Close();
                }
            }
        }
    }

    [WebMethod]
    public static string bindItemGroup(string SubcategoryID)
    {
        return Util.getJson(StockReports.GetDataTable(" SELECT  ig.`ItemIDGroup`,ig.`ItemNameGroup` FROM st_itemmaster im INNER JOIN `st_itemmaster_group` ig ON im.ItemIDGroup=ig.ItemIDGroup WHERE im.`SubcategoryID`='" + SubcategoryID + "'  GROUP BY ig.ItemIDGroup "));
    }

    [WebMethod(EnableSession = true)]
    public static string BudgetIndentApprove(string ItemDetail)
    {
        using (MySqlConnection conn = Util.GetMySqlCon())
        {
            conn.Open();
            using (MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "SELECT COUNT(*) FROM st_approvalright WHERE TypeName ='Approval' AND AppRightFor='BG' AND EmployeeID=@EmployeeID AND Active=1 ",
                        new MySqlParameter("@EmployeeID", UserInfo.ID)));
                    if (count > 0)
                    {
                        JavaScriptSerializer Serializer = new JavaScriptSerializer();
                        List<ItemData> ItemDetails = Serializer.Deserialize<List<ItemData>>(ItemDetail);
                        ItemDetails = ItemDetails.Where(s => !string.IsNullOrWhiteSpace(Util.GetString(s.Qty))).ToList();
                        string ConcatData = string.Empty;
                        for (int k = 0; k < ItemDetails.Count; k++)
                        {
                            string[] IndentNoList = ItemDetails[k].IndentNo.Split(',');
                            for (int i = 0; i < IndentNoList.Length; i++)
                            {
                                if (ConcatData == string.Empty)
                                    ConcatData = string.Concat("(", ItemDetails[k].ItemID, ",'", IndentNoList[i].ToString(), "'", ")");
                                else
                                    ConcatData = string.Concat(ConcatData, ",(", ItemDetails[k].ItemID, ",'", IndentNoList[i].ToString(), "'", ")");
                            }
                        }
                        // string aa = ConcatData;
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE st_indent_detail SET IsBudget=1,BudgetQty=IF(BudgetQty>0,BudgetQty,ApprovedQty), ApprovedDate=NOW(),ApprovedUserID='" + UserInfo.ID + "',ApprovedUserName='" + UserInfo.LoginName + "' WHERE (ItemID,IndentNo) IN (" + ConcatData + ")");

                        tnx.Commit();
                        return "1";
                    }
                    else
                    {
                        return "2";
                    }
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
                    conn.Close();
                }
            }
        }
    }

    public class ItemData
    {
        public int ItemID { get; set; }
        public string IndentNo { get; set; }
        public string FromLocationID { get; set; }
        public decimal Qty { get; set; }
    }
}