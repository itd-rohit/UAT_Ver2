<%@ WebService Language="C#" Class="StoreCommonServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using System.Linq;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class StoreCommonServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string bindcategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT `CategoryTypeID` ID,`CategoryTypeName` Name FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string bindsubcategory(string categoryid)
    {
        string query = "SELECT `SubCategoryTypeID` ID,`SubCategoryTypeName` Name FROM st_Subcategorytypemaster where active=1 ";
        //if (categoryid != "0")
        //{
            query += " and CategoryTypeID='" + categoryid + "' ";
        //}

        query += "ORDER BY SubCategoryTypeName";
        DataTable dt = StockReports.GetDataTable(query);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string binditemtype(string subcategoryid)
    {
        string query = " SELECT SubCategoryID ID,NAME Name FROM st_subcategorymaster WHERE active=1  ";
        //if (subcategoryid != "0")
        //{
       // query += " and   `SubCategoryTypeID`='" + subcategoryid + "' ";
        //}

        query += "ORDER BY NAME";
		//System.IO.File.WriteAllText (@"D:\\qbinditme.txt", query);
        DataTable dt = StockReports.GetDataTable(query);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    
    [WebMethod(EnableSession = true)]
    public string binditem(string itemcategory)
    {
        string query = " SELECT ItemID,TypeName FROM st_itemmaster WHERE `ApprovalStatus`=2 AND isactive=1  ";
        if (itemcategory != "0")
        {
            query += " and SubCategoryID='" + itemcategory + "'";
        }

        query += "ORDER BY TypeName";
        DataTable dt = StockReports.GetDataTable(query);
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod(EnableSession = true)]
    public string bindManufacture()
    {
        DataTable dt = StockReports.GetDataTable("SELECT MAnufactureID ID, NAME FROM st_manufacture_master where isactive='1' ORDER BY NAME");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    [WebMethod(EnableSession = true)]
    public string bindunit()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(id,'#',AllowDecimalValue)ID ,unitname NAME FROM  `st_unit_master` ORDER BY unitname"))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod(EnableSession = true)]
    public string bindmachine()
    {

        DataTable dt = StockReports.GetDataTable("SELECT ID, NAME FROM macmaster WHERE isactive=1  ORDER BY Name");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public string checkduplicateitem(string itemname, string itemid)
    {
        string query = "select count(*) from st_itemmaster_group where ItemNameGroup='" + itemname.Trim().ToUpper() + "' ";
        if (itemid != "")
        {
            query += " and ItemIDGroup<>'" + itemid + "'";
        }
        string count = StockReports.ExecuteScalar(query);
        return count;
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string bindtestandparameter()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT Id invid,typename FROM ( ");
        sb.Append("SELECT investigation_id id,CONCAT(NAME,'#','Investigation') typename   ");
        sb.Append("FROM investigation_master inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.investigation_id AND im.isactive=1 AND inv.autoconsumeoption>0 ");
        sb.Append("UNION ALL ");
        sb.Append("SELECT labobservation_id id,CONCAT(NAME,'#','Observation') typename FROM `labobservation_master` WHERE isactive=1 AND labobservation_id IN(SELECT labobservation_id FROM labobservation_investigation  WHERE isautoconsume=1) ) ");
        sb.Append(" t ORDER BY typename ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
    [WebMethod(EnableSession = true)]
    public string bindsupplier()
    {

        DataTable dt = StockReports.GetDataTable("SELECT supplierid,suppliername FROM st_vendormaster WHERE `ApprovalStatus`=2 AND isactive=1 ORDER BY suppliername");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    
        [WebMethod(EnableSession = true)]
    public string bindvendorgstndata(string vendorid)
    {

        DataTable dt = StockReports.GetDataTable(@"SELECT CONCAT(HouseNo,' ',Street) address,CONCAT(ssg.stateid,'#&#',GST_No,'#&#',SupplierType,'#&#',ssg.address) stateid,ssg.state  FROM st_vendormaster st
LEFT JOIN `st_supplier_gstn` ssg ON st.supplierid=ssg.supplierid WHERE st.supplierid=" + vendorid + " ORDER BY state");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
    


     [WebMethod(EnableSession = true)]
    public string bindcentre(string stateid)
    {

      

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.Panel_ID centreid,pm.company_name centre FROM f_panel_master  pm");
        sb.Append("  INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP') INNER JOIN st_locationmaster lm ON pm.Panel_ID=lm.Panel_ID  WHERE pm.IsActive=1 ");

        if (stateid != "")
            sb.Append(" AND cm.StateID IN(" + stateid + ")");

        

        sb.Append(" ORDER BY Centre");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
             
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod(EnableSession = true)]
    public string getbarcodedata(List<BarcodeSearch> BarcodeData)
    {



        string stockid = "";
        if (Util.GetString(BarcodeData[0].stockid).Trim() != "")
            stockid = String.Join(",", BarcodeData.Select(a => String.Join(", ", a.stockid)));
        
        
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT_WS(',', barcodeno,LEFT(REPLACE(itemname,'&amp;',''),52),batchnumber,IF(expirydate='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%y')))str,stockid FROM st_nmstock  ");
        sb.Append(" where stockid in (" + stockid + ")");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        sb = new StringBuilder();

        StockReports.ExecuteDML("UPDATE st_nmstock SET IsBarcodePrinted=1,BarcodePrintedDateTime=NOW() WHERE stockid IN (" + stockid + ")");
        foreach (DataRow dr in dt.Rows)
        {
            int qty = BarcodeData.Where(f => f.stockid == Util.GetInt(dr["stockid"])).SingleOrDefault().qty;
            for (int i = 1; i <= qty; i++)
            {
                sb.Append(dr["str"] + "^");
            }
        }

        string s = sb.ToString().Trim('^');


        return s;
    }

    [WebMethod(EnableSession = true)]
    public string checkStockPhysicalVerificationPage(string locationid)
    {

        return StorePageAccess.OpenStockPhysicalVerificationPage(locationid);

    }

    [WebMethod(EnableSession = true)]
    public string checkotherstockpage(string locationid)
    {

        return StorePageAccess.OpenOtherStockPages(locationid);

    }
}

public class BarcodeSearch
{
   public int stockid { get; set; }
   public int qty { get; set; }
}