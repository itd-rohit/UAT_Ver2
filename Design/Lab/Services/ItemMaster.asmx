<%@ WebService Language="C#" Class="ItemMaster" %>

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
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class ItemMaster : System.Web.Services.WebService
{


    [WebMethod(EnableSession = true)]
    public string GetNablInvestigations(string CentreId, string CategoryId, string SubCategoryId)
    {
        DataTable dt = new DataTable();
        Item_Master objitem = new Item_Master();
        dt = objitem.Get_NablInvestigations(CentreId, CategoryId.Split('#')[0].Trim(), SubCategoryId.Split('#')[0].Trim());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string Save_isNABLInv(string CentreId, string CategoryId, string SubCategoryId, string ItemData)
    {
        Item_Master objitem = new Item_Master();
        return objitem.Save_isNABLInv(CentreId, CategoryId, SubCategoryId, ItemData);
    }

    [WebMethod(EnableSession = true)]
    public string GetOutSourcelabInv(string CentreID, string CategoryId, string SubCategoryId)
    {
        DataTable dt = new DataTable();

        Item_Master objitem = new Item_Master();
        dt = objitem.GetOutsource_LabInvestigation(CentreID.Split('#')[0].Trim(), CategoryId.Split('#')[0].Trim(), SubCategoryId.Split('#')[0].Trim());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string GetPanelwiseItemRate(string PanelId, string CategoryId, string SubCategoryId, string billcategory)
    {
        DataTable dt = new DataTable();
        Item_Master objitem = new Item_Master();
        dt = objitem.GetPanelwise_Itemrate(PanelId.Split('#')[0].Trim(), CategoryId.Split('#')[0].Trim(), SubCategoryId, billcategory);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod(EnableSession = true)]
    public string GetDoctorwiseItemDiscount(string Doctor_ID, string CategoryId, string SubCategoryId, string billcategory)
    {
        DataTable dt = new DataTable();
        Item_Master objitem = new Item_Master();
        dt = objitem.GetDoctorwise_ItemDiscount(Doctor_ID.Split('#')[0].Trim(), CategoryId.Split('#')[0].Trim(), SubCategoryId, billcategory);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public string GetRole(string RoleID)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.Get_Role(RoleID.Split('#')[0].Trim()));

    }
    [WebMethod(EnableSession = true)]
    public string GetItemWisePanelRate(string ItemID)
    {

        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetItemWisePanelRate(ItemID));
    }
    [WebMethod(EnableSession = true)]
    public string GetDepartmentWiseItem(string SubCategoryID, string billcategory)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetDepartmentWiseItem(SubCategoryID, billcategory));
    }

    [WebMethod(EnableSession = true)]
    public string GetPanel(string GroupID)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.Getpanelitems(GroupID.Split('#')[0].Trim()));
    }
    [WebMethod(EnableSession = true)]
    public string SaveOutSourceLabInv(string CentreID, string ItemData)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SaveOutSource_LabInv(CentreID, ItemData);
    }
    [WebMethod(EnableSession = true)]
    public string Getsubcategory(string CategoryId)
    {
        DataTable dt = new DataTable();
        Item_Master objitem = new Item_Master();
         return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.Getsubcategoryitems(CategoryId.Split('#')[0].Trim()));
    }
    [WebMethod(EnableSession = true)]
    public string Getsubcategorynew(string CategoryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            string str = "Select sc.Name,sc.SubcategoryID SubcategoryID from f_Subcategorymaster sc";
            str += " where  Active=1";
            if (CategoryId != "0" && CategoryId.ToUpper() != "ALL")
                str += " and displayname = @CategoryId";
            str += " order by Name ";
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str, new MySqlParameter("@CategoryId", CategoryId)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string Getsubcategorygroupnew()
    {
        DataTable dt = StockReports.GetDataTable("Select DISTINCT sc.Displayname FROM f_subcategorymaster sc WHERE   active=1 order by Displayname");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public string Getsubcategorygroup(string CategoryId)
    {

        string str = "Select DISTINCT sc.Displayname FROM f_subcategorymaster sc WHERE categoryid='" + CategoryId.Split('#')[0] + "' and active=1 order by Displayname";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod(EnableSession = true)]
    public string SavePanelwiseItemrate(string PanelId, string ItemData, int TaggedPUP)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SavePanelwiseItemrate(PanelId, ItemData, TaggedPUP);
    }

    [WebMethod(EnableSession = true)]
    public string SaveDoctorwiseItemDiscount(List<string[]> itemdata)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SaveDoctorwiseItemDiscount(itemdata);
    }
    [WebMethod(EnableSession = true)]
    public string SaveRole(string RoleID, string ItemData)
    {
        Item_Master objitem = new Item_Master();
        return objitem.Save_Role(RoleID, ItemData);
    }
    [WebMethod(EnableSession = true)]
    public string SaveItemWisePanelRate(string ItemID, string ItemData, int TaggedPUP)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SaveItemWisePanelRate(ItemID, ItemData, TaggedPUP);
    }
    [WebMethod(EnableSession = true)]
    public string GetPanelwiseItems(string PanelId, string CategoryId, string SubCategoryId)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetPanelwise_Items(PanelId.Split('#')[0].Trim(), CategoryId.Split('#')[0].Trim(), SubCategoryId.Split('#')[0].Trim()));
    }
    [WebMethod(EnableSession = true)]
    public string GetDoctorMaster()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetDoctor_Master());
    }

    [WebMethod(EnableSession = true)]
    public string GetDoctorList(string CenterID)
    {
        DataTable dt = new DataTable();
        if (String.IsNullOrEmpty(CenterID))
            CenterID =Util.GetString( UserInfo.Centre);
        dt = StockReports.GetDataTable("SELECT Doctor_ID,CONCAT(NAME,'#',ifnull(AreaName,''))NAME FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' and centreID in('" + CenterID + "','0') ORDER BY NAME ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string GetPanelMasterAll()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetPanelMaster_All());
    }
    [WebMethod(EnableSession = true)]
    public string GetCPTCodeAll()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetCPTCode_All());
    }

    [WebMethod(EnableSession = true)]
    public string GetPanelMasterCurrentCentre()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetPanelMaster_CurrentCentre());
    }
    [WebMethod(EnableSession = true)]
    public string bindInvestigation()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.get_Investigation());
    }

    [WebMethod(EnableSession = true)]
    public string bindPackage()
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.get_Package());
    }
    [WebMethod(EnableSession = true)]
    public string savepanelwiseitemlock(string PanelId, string ItemData, string SubCategoryId)
    {
        Item_Master objitem = new Item_Master();
        return objitem.savepanelwiseitemlock(PanelId, ItemData, SubCategoryId);

    }
    [WebMethod(EnableSession = true)]
    public string GetPanelwiseItemLock(string PanelId, string CategoryId, string SubCategoryId)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetPanelwise_Itemlock(PanelId.Split('#')[0].Trim(), CategoryId.Split('#')[0].Trim(), SubCategoryId.Split('#')[0].Trim()));
    }
    [WebMethod(EnableSession = true)]
    public string SaveHoliday(string CentreID, string Holiday, int IsActive)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SaveCenterHoliday(CentreID, Holiday, IsActive);
    }

    [WebMethod(EnableSession = true)]
    public string SearchHoliday(string CentreID)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.GetCentreHoliday(CentreID));
    }

    [WebMethod(EnableSession = true)]
    public string UpdateHoliday(string CentreID, string Holiday, int IsActive, string ID)
    {
        Item_Master objitem = new Item_Master();
        return objitem.GetDateUpdated(CentreID, Holiday, IsActive, ID);
    }

    [WebMethod(EnableSession = true)]
    public string GetDeliveryDays(string CentreId, string CategoryId, string SubCategoryId)
    {
        Item_Master objitem = new Item_Master();
        return Newtonsoft.Json.JsonConvert.SerializeObject(objitem.Get_DeliveryDays(CentreId, CategoryId.Split('#')[0].Trim(), SubCategoryId.Split('#')[0].Trim()));
    }

    [WebMethod(EnableSession = true)]
    public string SaveInvDeliveryDays(string CentreId, string CategoryId, string SubCategoryId, string ItemData)
    {
        Item_Master objitem = new Item_Master();
        return objitem.SaveInvDeliveryDays(CentreId, CategoryId, SubCategoryId, ItemData);
    }
    [WebMethod(EnableSession = true)]
    public string GetPanelOfcenter(string Centerid)
    {

        string str = "SELECT pm.Company_Name, CONCAT(pm.Panel_ID, '#', pm.ReferenceCodeOPD) PanelID FROM f_panel_master pm INNER JOIN Centre_Panel cp ON cp.PanelID=pm.Panel_ID WHERE cp.CentreId = '" + Centerid + "'  AND pm.Panel_ID = pm.ReferenceCodeOPD";
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(str));


    }



}

