using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Reflection;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Newtonsoft.Json;

public partial class Design_Investigation_FamilyPackageMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindolddata()
    {
        DataTable dt = StockReports.GetDataTable(@" SELECT itemid,typename , testcode,DATE_FORMAT(CreaterDateTime,'%d-%b-%Y') EntryDate,(SELECT entryby FROM familypackage_master WHERE itemid=itemid LIMIT 1) EntryBy FROM f_itemmaster WHERE `SubcategoryID`=18 order by typename");
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binditemdetail(string itemid)
    {
        DataTable dt = StockReports.GetDataTable(@"  SELECT no_of_person,fromage,toage,gender,testlist,testname,DiscountPer  FROM familypackage_master WHERE itemid='" + itemid + "'");
        return Util.getJson(dt);
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindtest()
    {
        DataTable dt = StockReports.GetDataTable("SELECT itemid,typename FROM f_itemmaster WHERE `IsActive`=1 AND `SubcategoryID` NOT IN(38) ORDER BY typename ");
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savealldata(List<FamilyPackageMaster> datatosaved)
    {
        string ItemId = ""; string Investigation_ID = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Investigation_Master objInvestigation_Master = new Investigation_Master(tnx);
            objInvestigation_Master.Creator_ID = HttpContext.Current.Session["ID"].ToString();
            objInvestigation_Master.Name = datatosaved[0].ItemName.ToUpper();

            objInvestigation_Master.Ownership = "Public";
            objInvestigation_Master.ReportType = 1;

            objInvestigation_Master.Group_ID = "";
            objInvestigation_Master.Type = "N";
            objInvestigation_Master.Print_Sequence = 0;

            objInvestigation_Master.GenderInvestigate = "B";
            objInvestigation_Master.ColorCode = "";

            objInvestigation_Master.Reporting = 0;

            objInvestigation_Master.TestCode = datatosaved[0].TestCode.ToUpper();
            Investigation_ID = objInvestigation_Master.Insert();

            Investigation_ObservationType objInves_ObservationType = new Investigation_ObservationType(tnx);
            objInves_ObservationType.ObservationType_ID = Util.GetInt(datatosaved[0].SubCategoryID);
            objInves_ObservationType.Investigation_ID = Util.GetInt(Investigation_ID);
            objInves_ObservationType.Ownership = "Public";
            objInves_ObservationType.Creator_ID = HttpContext.Current.Session["ID"].ToString();

            ItemMaster objIMaster = new ItemMaster(tnx);
            objIMaster.Type_ID = Util.GetInt(Investigation_ID);
            objIMaster.TypeName = datatosaved[0].ItemName.ToUpper();
            objIMaster.SubCategoryID = Util.GetInt(datatosaved[0].SubCategoryID);
            objIMaster.IsActive = 1;
            objIMaster.Inv_ShortName = "";
            objIMaster.IsTrigger = "";
            objIMaster.TestCode = datatosaved[0].TestCode.ToUpper();
            objIMaster.MaxDiscount = 0;
            objIMaster.Booking = Util.GetInt(1);
            objIMaster.BillCategoryID = 0;
            ItemId = objIMaster.Insert().ToString();

            foreach (FamilyPackageMaster fpm in datatosaved)
            {
                string query = "insert into  familypackage_master (ItemID,No_Of_Person,FromAge,ToAge,Gender,TestList,EntryDate,EntryBy,TestName,DiscountPer) values ";
                query += "('" + ItemId + "','" + fpm.No_Of_Person + "','" + fpm.FromAge + "','" + fpm.ToAge + "','" + fpm.Gender + "','" + fpm.TestList + "',now(),'" + UserInfo.LoginName + "','" + fpm.TestName.Trim() + "','" + fpm.DescPer + "') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query);
            }
            tnx.Commit();
            
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

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
    public static string updatealldata(List<FamilyPackageMaster> datatosaved)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string q1 = "update investigation_master set Name='" + datatosaved[0].ItemName.ToUpper() + "',TestCode='" + datatosaved[0].TestCode + "' where Investigation_Id=(select type_id from f_itemmaster where itemid='" + datatosaved[0].ItemID + "') ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q1);

            string q2 = "update f_itemmaster set TypeName='" + datatosaved[0].ItemName.ToUpper() + "',TestCode='" + datatosaved[0].TestCode + "' where ItemID='" + datatosaved[0].ItemID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q2);

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from familypackage_master where ItemID='" + datatosaved[0].ItemID + "' ");

            foreach (FamilyPackageMaster fpm in datatosaved)
            {
                string query = "insert into  familypackage_master (ItemID,No_Of_Person,FromAge,ToAge,Gender,TestList,EntryDate,EntryBy,TestName,DiscountPer) values ";
                query += "('" + datatosaved[0].ItemID + "','" + fpm.No_Of_Person + "','" + fpm.FromAge + "','" + fpm.ToAge + "','" + fpm.Gender + "','" + fpm.TestList + "',now(),'" + UserInfo.LoginName + "','" + fpm.TestName.Trim() + "','" + fpm.DescPer + "') ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query);
            }

            tnx.Commit();
            
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



}

public class FamilyPackageMaster
{
    public string ItemName { get; set; }
    public string TestCode { get; set; }
    public string SubCategoryID { get; set; }
    public string No_Of_Person { get; set; }
    public string FromAge { get; set; }
    public string ToAge { get; set; }
    public string Gender { get; set; }
    public string TestList { get; set; }
    public string TestName { get; set; }

    public string ItemID { get; set; }
    public string DescPer { get; set; }


}