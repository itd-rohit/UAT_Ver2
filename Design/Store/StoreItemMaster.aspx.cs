using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StoreItemMaster : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlcategorytype.Focus();
            // bindalldata();
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='IM' AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("Checker"))
                {
                    approvaltypechecker = "1";
                }
                if (dt.Contains("Approval"))
                {
                    approvaltypeapproval = "1";
                }
                if (dt.Contains("Maker"))
                {
                    approvaltypemaker = "1";
                }
            }
        }
    }

    private void bindalldata()
    {
        ddlcentermapping.DataSource = StockReports.GetDataTable("select centreid ID,centre Name from centre_master where isactive=1 order by centre");
        ddlcentermapping.DataValueField = "ID";
        ddlcentermapping.DataTextField = "Name";
        ddlcentermapping.DataBind();
        ddlcentermapping.Items.Insert(0, new ListItem("Select", "0"));

        ddllabmachine.DataSource = StockReports.GetDataTable("SELECT ID MACHINEID,NAME MACHINENAME FROM MACMASTER ORDER BY MACHINENAME");
        ddllabmachine.DataValueField = "MACHINEID";
        ddllabmachine.DataTextField = "MACHINENAME";
        ddllabmachine.DataBind();
        ddllabmachine.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveItemMaster(List<StoreItemMaster> StoreItemMaster, List<string[]> consumedata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_itemmaster_group (ItemNameGroup) values(@ItemNameGroup)", new MySqlParameter("@ItemNameGroup", StoreItemMaster[0].TypeName.ToUpper()));
            int itemgorupid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select max(ItemIDGroup) from st_itemmaster_group"));
            string Itemid = "";
            foreach (StoreItemMaster itemdata in StoreItemMaster)
            {
                StoreItemMaster objsm = new StoreItemMaster(tnx);
                objsm.CategoryTypeID = itemdata.CategoryTypeID;
                objsm.SubCategoryTypeID = itemdata.SubCategoryTypeID;
                objsm.SubCategoryID = itemdata.SubCategoryID;
                objsm.TypeName = itemdata.TypeName.ToUpper() + " " + itemdata.MachinName.ToUpper() + " " + itemdata.ManufactureName.ToUpper() + " " + itemdata.PackSize;
                objsm.Description = itemdata.Description;
                objsm.Specification = itemdata.Specification;
                objsm.MakeandModelNo = itemdata.MakeandModelNo;
                objsm.ClientItemCode = itemdata.ClientItemCode.ToUpper();
                objsm.HsnCode = itemdata.HsnCode.ToUpper();
                objsm.Expdatecutoff = itemdata.Expdatecutoff;
                objsm.GSTNTax = itemdata.GSTNTax;
                objsm.TemperatureStock = itemdata.TemperatureStock;
                objsm.IsActive = itemdata.IsActive;
                objsm.IsExpirable = itemdata.IsExpirable;
                objsm.ManufactureID = itemdata.ManufactureID;
                objsm.ManufactureName = itemdata.ManufactureName;
                objsm.CatalogNo = itemdata.CatalogNo;
                objsm.MachinId = itemdata.MachinId;
                objsm.MachinName = itemdata.MachinName;
                objsm.MajorUnitId = itemdata.MajorUnitId;
                objsm.MajorUnitName = itemdata.MajorUnitName;
                objsm.PackSize = itemdata.PackSize;
                objsm.Converter = itemdata.Converter;
                objsm.MinorUnitId = itemdata.MinorUnitId;
                objsm.MinorUnitName = itemdata.MinorUnitName;
                objsm.ItemIDGroup = itemgorupid;
                objsm.IssueMultiplier = itemdata.IssueMultiplier;
                objsm.BarcodeOption = itemdata.BarcodeOption;
                objsm.BarcodeGenrationOption = itemdata.BarcodeGenrationOption;
                objsm.IssueInFIFO = itemdata.IssueInFIFO;
                objsm.MajorUnitInDecimal = itemdata.MajorUnitInDecimal;
                objsm.MinorUnitInDecimal = itemdata.MinorUnitInDecimal;
                Itemid = objsm.Insert();
                if (Itemid == string.Empty)
                {
                    tnx.Rollback();
                    return "0#Error";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_itemconsumedetail where ItemId=@ItemId",
                    new MySqlParameter("@ItemId", Itemid));
                foreach (string[] myarr in consumedata)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO st_itemconsumedetail(ItemID,inv_parameter_id,CreaterDateTime,CreaterID,inv_parameter_name,inv_parameter_type,");
                    sb.Append(" quantity,unit,entryDate,entryBy,labmachineID,labmachineName)");
                    sb.Append(" VALUES (@ItemID,@inv_parameter_id,@CreaterDateTime,@CreaterID,@inv_parameter_name,@inv_parameter_type,");
                    sb.Append(" @quantity,@unit,NOW(),@entryBy,@labmachineID,@labmachineName) ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@ItemID", Itemid), new MySqlParameter("@inv_parameter_id", Util.GetString(myarr[0])), new MySqlParameter("@CreaterDateTime", Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd")),
                        new MySqlParameter("@CreaterID", Util.GetString(HttpContext.Current.Session["ID"].ToString())), new MySqlParameter("@inv_parameter_name", Util.GetString(myarr[1])), new MySqlParameter("@inv_parameter_type", Util.GetString(myarr[2])),
                        new MySqlParameter("@quantity", Util.GetString(myarr[3])), new MySqlParameter("@unit", Util.GetString(myarr[4])),
                        new MySqlParameter("@entryBy", Util.GetString(UserInfo.LoginName)), new MySqlParameter("@labmachineID", Util.GetString(myarr[5])), new MySqlParameter("@labmachineName", Util.GetString(myarr[6])));
                }
            }
            tnx.Commit();

            return "1#";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateItemMaster(List<StoreItemMaster> itemdata, List<string[]> consumedata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  st_itemmaster_group set ItemNameGroup=@ItemNameGroup where ItemIDGroup=@ItemIDGroup", new MySqlParameter("@ItemNameGroup", itemdata[0].TypeName.ToUpper()), new MySqlParameter("@ItemIDGroup", itemdata[0].ItemIDGroup));

            string Itemid = "";
            foreach (StoreItemMaster itemdata1 in itemdata)
            {
                if (itemdata1.IsActive == 0)
                {
                    // check if Stock Avilable 
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM st_nmstock WHERE itemid='" + itemdata1.ItemID + "' AND (`InitialCount`-ReleasedCount-PendingQty)>0") ) > 0)
                    {
                        tnx.Rollback();
                        return "0#" + itemdata1.TypeName.ToUpper() + " " + itemdata1.MachinName.ToUpper() + " " + itemdata1.ManufactureName.ToUpper() + " " + itemdata1.PackSize.ToUpper() + " is In Stock. Can't Deactive.";
                    }
                }
                float oldtax = 0;
                if (itemdata1.ItemID != 0)
                {
                     oldtax = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select GSTNTax from st_itemmaster where itemid='" + itemdata1.ItemID + "'"));
                }
                StoreItemMaster objsm = new StoreItemMaster(tnx);
                objsm.CategoryTypeID = itemdata1.CategoryTypeID;
                objsm.SubCategoryTypeID = itemdata1.SubCategoryTypeID;
                objsm.SubCategoryID = itemdata1.SubCategoryID;
                objsm.ItemID = itemdata1.ItemID;
                objsm.TypeName = itemdata1.TypeName.ToUpper() + " " + itemdata1.MachinName.ToUpper() + " " + itemdata1.ManufactureName.ToUpper() + " " + itemdata1.PackSize;
                objsm.Description = itemdata1.Description;
                objsm.Specification = itemdata1.Specification;
                objsm.MakeandModelNo = itemdata1.MakeandModelNo;
                
                //objsm.ApolloItemCode = itemdata1.ApolloItemCode.ToUpper();
                objsm.HsnCode = itemdata1.HsnCode.ToUpper();
                objsm.Expdatecutoff = itemdata1.Expdatecutoff;
                objsm.GSTNTax = itemdata1.GSTNTax;
                objsm.TemperatureStock = itemdata1.TemperatureStock;
                objsm.IsActive = itemdata1.IsActive;
                objsm.IsExpirable = itemdata1.IsExpirable;
                objsm.ManufactureID = itemdata1.ManufactureID;
                objsm.ManufactureName = itemdata1.ManufactureName;
                objsm.CatalogNo = itemdata1.CatalogNo;
                objsm.MachinId = itemdata1.MachinId;
                objsm.MachinName = itemdata1.MachinName;
                objsm.MajorUnitId = itemdata1.MajorUnitId;
                objsm.MajorUnitName = itemdata1.MajorUnitName;
                objsm.PackSize = itemdata1.PackSize;
                objsm.Converter = itemdata1.Converter;
                objsm.MinorUnitId = itemdata1.MinorUnitId;
                objsm.MinorUnitName = itemdata1.MinorUnitName;
                objsm.ItemIDGroup = itemdata1.ItemIDGroup;
                objsm.IssueMultiplier = itemdata1.IssueMultiplier;
                objsm.BarcodeOption = itemdata1.BarcodeOption;
                objsm.BarcodeGenrationOption = itemdata1.BarcodeGenrationOption;
                objsm.IssueInFIFO = itemdata1.IssueInFIFO;
                objsm.MajorUnitInDecimal = itemdata1.MajorUnitInDecimal;
                objsm.MinorUnitInDecimal = itemdata1.MinorUnitInDecimal;
                if (itemdata1.ItemID == 0)
                {
                    Itemid = objsm.Insert();
                }
                else
                {
                    Itemid = Util.GetString(itemdata1.ItemID);
                    objsm.Update();

                    if (itemdata1.GSTNTax != oldtax)
                    {


                        // update quotation table
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" UPDATE st_vendorqutation SET ");
                        sb.Append(" IGSTPer=IF(VendorStateId=DeliveryStateID ,0," + itemdata1.GSTNTax + "), ");
                        sb.Append(" SGSTPer=IF(VendorStateId=DeliveryStateID," + itemdata1.GSTNTax + "/2,0), ");
                        sb.Append(" CGSTPer=IF(VendorStateId=DeliveryStateID," + itemdata1.GSTNTax + "/2,0), ");
                        sb.Append(" GSTAmount=((rate-DiscountAmt)*" + itemdata1.GSTNTax + "*0.01), ");
                        sb.Append(" BuyPrice=((rate-DiscountAmt)+((rate-DiscountAmt)*" + itemdata1.GSTNTax + "*0.01)), ");
                        sb.Append(" FinalPrice=((rate-DiscountAmt)+((rate-DiscountAmt)*" + itemdata1.GSTNTax + "*0.01)), ");
                        sb.Append(" updatedate=NOW(), ");
                        sb.Append(" updatebyid=" + UserInfo.ID + " ");
                        sb.Append(" WHERE itemid='" + itemdata1.ItemID + "' and (IGSTPer+SGSTPer+CGSTPer)=" + oldtax + " ");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                        // update pending pi 

                        sb = new StringBuilder();
                        sb.Append(" UPDATE st_indent_detail SET ");
                        sb.Append(" TaxPerIGST=IF(TaxPerIGST=0,0," + itemdata1.GSTNTax + "), ");
                        sb.Append(" TaxPerCGST=IF(TaxPerCGST=0,0," + itemdata1.GSTNTax + "/2), ");
                        sb.Append(" TaxPerSGST=IF(TaxPerSGST=0,0," + itemdata1.GSTNTax + "/2),  ");
                        sb.Append(" unitprice=((rate-(rate*DiscountPer*0.01))+(rate-(rate*DiscountPer*0.01))*(" + itemdata1.GSTNTax + ")*0.01), ");
                        sb.Append(" NetAmount=((rate-(rate*DiscountPer*0.01))+(rate-(rate*DiscountPer*0.01))*(" + itemdata1.GSTNTax + ")*0.01) ");
                        sb.Append(" *IF(ApprovedQty<>0,ApprovedQty,IF(CheckedQty<>0,CheckedQty,ReqQty)),dtUpdate=NOW(),UpdatedBy='" + UserInfo.LoginName + "',UpdatedByID='" + UserInfo.ID + "' ");
                        sb.Append(" WHERE IndentType='PI' AND POQty=0 AND itemid='" + itemdata1.ItemID + "'   ");
                        sb.Append(" AND (TaxPerIGST+TaxPerCGST+TaxPerSGST)=" + oldtax + " ");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                    }

                }
                if (Itemid == "0")
                {
                    tnx.Rollback();
                    return "0#Error";
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_itemconsumedetail where ItemId=@ItemId",
                   new MySqlParameter("@ItemId", Itemid));
                foreach (string[] myarr in consumedata)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO st_itemconsumedetail(ItemId,inv_parameter_id,CreaterDateTime,CreaterID,inv_parameter_name,inv_parameter_type,quantity,");
                    sb.Append(" unit,entryDate,entryBy,labmachineID,labmachineName)");
                    sb.Append(" VALUES (@ItemID,@inv_parameter_id,@CreaterDateTime,@CreaterID,@inv_parameter_name,@inv_parameter_type,");
                    sb.Append(" @quantity,@unit,NOW(),@entryBy,@labmachineID,@labmachineName) ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@ItemID", Itemid), new MySqlParameter("@inv_parameter_id", Util.GetString(myarr[0])), new MySqlParameter("@CreaterDateTime", Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd")),
                                new MySqlParameter("@CreaterID", Util.GetString(HttpContext.Current.Session["ID"].ToString())), new MySqlParameter("@inv_parameter_name", Util.GetString(myarr[1])), new MySqlParameter("@inv_parameter_type", Util.GetString(myarr[2])),
                                new MySqlParameter("@quantity", Util.GetString(myarr[3])), new MySqlParameter("@unit", Util.GetString(myarr[4])), new MySqlParameter("@entryBy", Util.GetString(UserInfo.LoginName)),
                                new MySqlParameter("@labmachineID", Util.GetString(myarr[5])), new MySqlParameter("@labmachineName", Util.GetString(myarr[6])));
                }
            }
            tnx.Commit();
            return "1#";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
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
    public static string SearchData(string searchtype, string searchvalue, string Category, string CategoryType, string NoofRecord, string AppType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT  sm.itemidgroup,sm.itemid,sm.CategoryTypeID,cat.CategoryTypeName,sm.SubCategoryTypeID,subcat.SubCategoryTypeName,BarcodeOption,BarcodeGenrationOption,IssueInFIFO, ");
        sb.Append(" itemcat.SubCategoryID,itemcat.Name itemgroupName,sg.ItemNameGroup ItemName , ");
        sb.Append(" sm.hsncode,sm.apolloitemcode,sm.isactive,sm.description,sm.specification,sm.MakeandModelNo,sm.Expdatecutoff,sm.TemperatureStock,sm.GSTNTax,sm.IsExpirable,if(sm.IsExpirable='1','Yes','No') Expirable");

        sb.Append(" FROM st_itemmaster sm  ");
        sb.Append("  inner join st_itemmaster_group sg on sg.ItemIDGroup=sm.itemidgroup");
        sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID ");
        sb.Append(" where sm.itemid<>0 and sm.isactive=1 ");
        if (searchvalue != "")
        {
            sb.Append(" and   " + searchtype + " like'%" + searchvalue + "%'");
        }

        if (Category != "0" && CategoryType != "0")
        {
            sb.Append(" and   " + Category + "='" + CategoryType + "'");
        }

        if (AppType != "")
        {
            sb.Append(" and ApprovalStatus="+AppType+" ");
        }

        sb.Append("  group by sm.itemidgroup order by CategoryTypeName,SubCategoryTypeName,itemgroupName,sm.itemidgroup asc limit " + NoofRecord + "");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDataExcel(string searchtype, string searchvalue, string Category, string CategoryType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT sm.CategoryTypeID,cat.CategoryTypeName,sm.SubCategoryTypeID,subcat.SubCategoryTypeName, ");
        sb.Append(" itemcat.SubCategoryID ItemTypeID,itemcat.Name itemTypeName,sm.Itemid,sg.ItemNameGroup ItemName ,sm.Description,sm.Specification,sm.MakeandModelNo, ");
        sb.Append(" sm.hsncode HSNCode,sm.apolloitemcode ApolloItemCode,if(sm.IsExpirable='1','Yes','No') Expirable,sm.Expdatecutoff ExpiryDateCutoff,sm.TemperatureStock StorageTemperature,sm.GSTNTax, ");
        sb.Append(" ManufactureID, ManufactureName, CatalogNo, MachineID,MachineName, MajorUnitName PurchasedUnit,Converter, PackSize, MinorUnitName ConsumptionUnit,IssueMultiplier, ");
        sb.Append(" case when sm.isactive=1 then 'Active' else 'Deactive' end `Status`,");
        sb.Append(" case when sm.ApprovalStatus=0 then 'Created' when sm.ApprovalStatus=1 then 'Checked' else 'Approved' end `ApprovalStatus`,");
        sb.Append(" DATE_FORMAT(sm.CreaterDateTime, '%d/%m/%Y') CreatedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CreaterID) CreatedBy, ");
        sb.Append(" DATE_FORMAT(sm.CheckedDate, '%d/%m/%Y') CheckedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CheckedBy) CheckedBy, ");
        sb.Append(" DATE_FORMAT(sm.ApprovedDate, '%d/%m/%Y') ApprovedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.ApprovedBy) ApprovedBy ");
        sb.Append(" FROM st_itemmaster sm  ");
        sb.Append(" inner join st_itemmaster_group sg on sg.ItemIDGroup=sm.itemidgroup");
        sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID ");

        sb.Append(" where sm.itemid<>0 ");
        if (searchvalue != "")
        {
            sb.Append(" and   " + searchtype + " like'%" + searchvalue + "%'");
        }

        if (Category != "0" && CategoryType != "0")
        {
            sb.Append(" and   " + Category + "='" + CategoryType + "'");
        }

        sb.Append("  order by CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = " StoreItemMaster";
            return "true";
        }
        else
        {
            return "false";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindSavedManufacture(string itemid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ItemId,ManufactureID,ManufactureName,CatalogNo,MachineID,isactive");
        sb.Append(" ,MachineName,MajorUnitId,MajorUnitName,PackSize MultipiyFactor,MinorUnitId,MinorUnitName,IssueMultiplier,converter,MajorUnitInDecimal,MinorUnitInDecimal ");
        sb.Append("  FROM st_itemmaster where ItemIdGroup='" + itemid + "' ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SetStatus(int itemId, int Status)
    {
        string str = "";
        if (Status == 1)
        {
            str = "update st_itemmaster set ApprovalStatus='" + Status + "',CheckedBy='" + UserInfo.ID + "',CheckedDate=now() where ItemId='" + itemId + "'";
        }

        if (Status == 2)
        {
            str = "update st_itemmaster set ApprovalStatus='" + Status + "',ApprovedBy='" + UserInfo.ID + "',ApprovedDate=now() where ItemId='" + itemId + "'";
        }

        StockReports.ExecuteScalar(str);
        return "true";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getconsumeitemlist(string itemid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT inv_parameter_id,inv_parameter_name,inv_parameter_type,`quantity`,unit,labmachineid,labmachinename  ");
        sb.Append(" FROM  st_itemconsumedetail WHERE itemid='" + itemid + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindalldatatosearch(string type)
    {
        string query = "";
        switch (type)
        {
            case "sm.CategoryTypeID":
                query = "SELECT `CategoryTypeID` ID,`CategoryTypeName` NAME FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName";
                break;

            case "sm.SubCategoryTypeID":
                query = "SELECT `SubCategoryTypeID` ID,`SubCategoryTypeName` NAME FROM st_Subcategorytypemaster where active=1 order by SubCategoryTypeName";
                break;

            case "sm.ItemGroupId":
                query = "SELECT SubCategoryID ID,CONCAT(NAME,' # ',SubCategoryTypeName) NAME FROM st_subcategorymaster ssm INNER JOIN  st_Subcategorytypemaster ssc ON ssm.SubCategoryTypeID=ssc.SubCategoryTypeID WHERE ssm.active=1 ORDER BY NAME";
                break;

            case "sm.ManufactureID":
                query = "SELECT MAnufactureID ID, NAME FROM st_manufacture_master where isactive='1' ORDER BY NAME";
                break;

            case "sm.MachineId":
                query = "SELECT ID  ,Name  NAME FROM MACMASTER ORDER BY NAME";
                break;
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(query));
    }


    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT itemidgroup,itemnamegroup FROM `st_itemmaster_group`  ");
        sb.Append(" where itemnamegroup like '%" + itemname + "%' ");
        sb.Append(" ORDER BY itemnamegroup limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
}
