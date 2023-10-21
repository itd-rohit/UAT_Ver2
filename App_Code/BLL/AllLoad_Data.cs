using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.IO;
using System.Drawing;
using Newtonsoft.Json;
using ClosedXML.Excel;
/// <summary>
/// Summary description for AllLoad_Data
/// </summary>
public class AllLoad_Data
{
	  public static int checkPageAuthorisation(string RoleID, string EmployeeID, string URL)
    {
        int PageAuthorisation = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM user_pageauthorisation_master ps INNER JOIN user_pageauthorisation pa ON ps.id=pa.MasterID " +
            " WHERE ps.url='" + URL + "' AND pa.RoleID='" + RoleID + "' AND pa.EmployeeID='" + EmployeeID + "' AND ps.IsActive=1 AND pa.IsActive=1 "));
			//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\16-Feb-2021\loiuu.txt","SELECT COUNT(*) FROM user_pageauthorisation_master ps INNER JOIN user_pageauthorisation pa ON ps.id=pa.MasterID  WHERE ps.url='" + URL + "' AND pa.RoleID='" + RoleID + "' AND pa.EmployeeID='" + EmployeeID + "' AND ps.IsActive=1 AND pa.IsActive=1 ");
        return PageAuthorisation;
    }

      public static DataTable bindPanel1()
      {

          return StockReports.GetDataTable("SELECT DISTINCT(pn.Company_Name),pn.Panel_ID PanelID  FROM Centre_Panel cp INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.isActive=1 order by cp.isDefault desc");
      }

    public static void bindPanel(DropDownList ddlPanel, string Type = "")
    {
        string qstr = string.Format("SELECT pn.Company_Name,CONCAT(pn.Panel_ID,'#',pn.ReferenceCodeOPD)PanelID  FROM Centre_Panel cp INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='{0}' AND cp.isActive=1 order by cp.isDefault desc", UserInfo.Centre);

        using (DataTable dtPanel = StockReports.GetDataTable(qstr))
        {
            if (dtPanel != null && dtPanel.Rows.Count > 0)
            {
                ddlPanel.DataSource = dtPanel;
                ddlPanel.DataTextField = "Company_Name";
                ddlPanel.DataValueField = "PanelID";
                ddlPanel.DataBind();

            }
            else
            {
                ddlPanel.DataSource = null;
                ddlPanel.DataBind();
            }
        }
    }
    public static DataTable getCentreByLogin()
    {
        if (UserInfo.Centre == 1)
            return StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY centre");
        else
            return StockReports.GetDataTable(string.Format("SELECT DISTINCT cm.`CentreID`,cm.`Centre` FROM centre_master cm INNER JOIN f_login l ON l.`CentreID`=cm.`CentreID` WHERE l.`EmployeeID`='{0}' ORDER BY centre", UserInfo.ID));
    }
    public static DataTable getDepartment()
    {

        return StockReports.GetDataTable("SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE Active=1 ORDER BY NAME");       
    }
    public static DataTable loadDept(string CategoryID)
    {
        return StockReports.GetDataTable("SELECT NAME, SubCategoryID FROM f_subcategorymaster WHERE CategoryId in('"+ CategoryID.Replace(",","','") +"') and Active=1 group by subcategoryID");
    }
    public static DataTable loadcategory()
    {
        return StockReports.GetDataTable("SELECT CategoryID,NAME FROM f_categorymaster group by Name");
    }
    public static DataTable loadCentre()
    {
        return StockReports.GetDataTable("SELECT CentreID,Centre FROM centre_master  ORDER BY centre");
    }
    public static DataTable loadDoctor()
    {
        return StockReports.GetDataTable("SELECT Doctor_ID,NAME FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' ORDER BY NAME");
    }
    public static DataTable loadPanel()
    {
        return StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1 ORDER BY Company_Name");
    }
    public static DataTable loadPanel(string ch)
    {
        return StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE IsActive=1 AND tagprocessinglabid IN (" + ch + ") ORDER BY Company_Name");
    }

    public static void bindAllCentre(DropDownList ddlCentre = null, ListBox lstCentre = null, GridView grdCentre = null, string Type = "")
    {
        if (ddlCentre != null)
        {
            ddlCentre.DataSource = loadCentre();
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            if (Type != "")
                ddlCentre.Items.Insert(0, new ListItem(Type, "0"));
        }
        else if (lstCentre != null)
        {
            lstCentre.DataSource = loadCentre();
            lstCentre.DataTextField = "Centre";
            lstCentre.DataValueField = "CentreID";
            lstCentre.DataBind();
        }
        else if (grdCentre != null)
        {
            grdCentre.DataSource = loadCentre();
            grdCentre.DataBind();
        }
    }
    public static void bindCentreDefault(DropDownList ddlCentre = null, GridView grvCentre = null, string Type = "")
    {
        if (ddlCentre != null)
        {
            ddlCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,Centre FROM centre_master WHERE isActive=1 ORDER BY IF(isDefault='0','2',isDefault),centre");
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
        }
        else if (grvCentre != null)
        {
            grvCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,Centre FROM centre_master WHERE isActive=1 ORDER BY IF(isDefault='0','2',isDefault),centre");
            grvCentre.DataBind();
        }
    }

    public static DataTable getCentreLab()
    {
        if (UserInfo.Centre != 1)
        {
            if (UserInfo.CentreType != "PCC")
                return StockReports.GetDataTable("SELECT CentreID,Centre,type1,COCO_FOCO FROM centre_master WHERE type1ID <> '7' AND IF(type1ID = '8',COCO_FOCO='COCO', type1ID != '8') AND IsActive=1 ORDER BY Centre");
            else
                return StockReports.GetDataTable(string.Format("SELECT CentreID,Centre FROM centre_master WHERE CentreID=(Select TagProcessingLabID from centre_master where CentreID={0}) AND IsActive=1 ORDER By Centre", UserInfo.Centre));
        }
        else
        {
            return StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 ORDER BY centre");
        }
    }
    public static void bindReferDoctor(DropDownList ddlRefer = null, ListBox lstbxRefer = null, string Type = "")
    {
        if (ddlRefer != null)
        {
            ddlRefer.DataSource = StockReports.GetDataTable("SELECT Doctor_ID,CONCAT(NAME,'#',ifnull(AreaName,''))NAME FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' ORDER BY NAME");
            ddlRefer.DataTextField = "NAME";
            ddlRefer.DataValueField = "Doctor_ID";
            ddlRefer.DataBind();
        }
        else if (lstbxRefer != null)
        {

        }
    }
    public static DataTable loadDeptartment(string CategoryID)
    {
        return StockReports.GetDataTable("SELECT  DISTINCT im.SubGroupID ID,im.SubgroupName  FROM f_itemmaster im INNER JOIN f_itemsubgroup sg ON sg.ID=im.SubGroupID WHERE im.SubCategoryID ='" + CategoryID + "' HAVING IFNULL(im.SubGroupID,'')<>'' ORDER BY sg.Print_Sequence ");
    }
    public static DataTable loadsubgroup(string deptID)
    {
       
            return StockReports.GetDataTable("SELECT  ID,SubgroupName  from f_itemsubgroup WHERE SubCategoryID ='" + deptID + "' ORDER BY SubgroupName ");
    }
    public static DataTable loadDeptcategory()
    {
        return StockReports.GetDataTable("SELECT CategoryId,DisPlayName FROM f_subcategorymaster WHERE Active=1 GROUP BY DisPlayName ORDER BY DisplayName");
    }
    public static DataTable loadinvestigation(string ItemID, string ReferenceCodeOPD, string CentreCode, string Gender, string DOB, string Panel_Id, string PanelType, string DiscountTypeID, string PanelID_MRP, string MemberShipCardNo, string SubcategoryID,string SubgroupID)
    {
        double AgeInDays = 0;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,CONCAT(im.typeName,' # ',sub.Name) label,if(im.subcategoryid='15','Package','Test') type, ");
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@ReferenceCodeOPD,CURRENT_DATE(),@Panel_Id)),0)Rate, ");
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@PanelID_MRP,CURRENT_DATE(),@Panel_Id)),0)MRP, ");
            if (MemberShipCardNo == string.Empty)
            {
                if (DiscountTypeID != string.Empty)
                    sb.Append(" IFNULL((SELECT get_discountPer(@DiscountTypeID ,im.itemid)),0)DiscPer ");
                else
                    sb.Append(" 0 DiscPer ");
            }
            else
            {
                sb.Append(" 0 DiscPer ");
            }
            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");
            sb.Append(" INNER JOIN investigation_master inv ON im.`Type_ID`=inv.`Investigation_Id` ");
            if (ItemID != string.Empty)
                sb.Append(" AND im.`ItemID`=@ItemID ");
            if (SubcategoryID != string.Empty)
                sb.Append(" AND sub.SubcategoryID=@SubCategoryID");
 if (SubgroupID != string.Empty)
                sb.Append(" AND im.SubgroupID=@SubgroupID");

            if (PanelType.ToUpper() == "CAMP")
                sb.Append(" INNER JOIN f_ratelist rl ON rl.`ItemID`=im.`ItemID` AND rl.`Panel_ID`=@ReferenceCodeOPD   ");

            sb.Append(" WHERE im.isActive=1 ");
            if (Gender != string.Empty)
            {
                sb.Append(" AND im.`Gender` IN ('B',@Gender) ");
            }
            if (DOB != string.Empty)
            {
                AgeInDays = (DateTime.Now - Util.GetDateTime(DOB)).TotalDays;
                sb.Append(" and im.FromAge <= @AgeInDays and im.`ToAge` >= @AgeInDays  ");
            }
            if (PanelType.ToUpper() != "CAMP")
                sb.Append(" HAVING IFNULL(Rate,0)<>0 ");



            sb.Append("  order by inv.Print_Sequence ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@ReferenceCodeOPD", ReferenceCodeOPD);
                if (DiscountTypeID != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@DiscountTypeID", DiscountTypeID);

                if (MemberShipCardNo != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@MemberShipCardNo", MemberShipCardNo);
                if (ItemID != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@ItemID", ItemID);
                if (SubcategoryID != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@SubCategoryID", SubcategoryID);
if (SubgroupID != string.Empty)
da.SelectCommand.Parameters.AddWithValue("@SubgroupID", SubgroupID);

                da.SelectCommand.Parameters.AddWithValue("@Panel_Id", Util.GetInt(Panel_Id));
                da.SelectCommand.Parameters.AddWithValue("@Gender", Gender.Substring(0, 1));
                da.SelectCommand.Parameters.AddWithValue("@AgeInDays", AgeInDays);
                da.SelectCommand.Parameters.AddWithValue("@PanelID_MRP", PanelID_MRP);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable loadRole()
    {
        return StockReports.GetDataTable(" select ID,RoleName from f_rolemaster where active=1 order by RoleName");
    }
    public static void bindRole(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadRole())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "RoleName";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadMachine()
    {
        return StockReports.GetDataTable("SELECT NAME,ID FROM macmaster WHERE isActive=1 ORDER BY Name ");
    }
    public static void bindMachine(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadMachine())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "NAME";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadSubCategory()
    {
        return StockReports.GetDataTable("select SubCategoryID,sm.Name from f_subCategorymaster sm inner join f_categorymaster cm on cm.CategoryID=sm.CategoryID " +
        "   inner join f_configrelation cr on cr.CategoryID=cm.CategoryID where ConfigRelationID in (3) order by sm.name ");
    }
    public static void bindSubCategory(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadSubCategory())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "NAME";
                ddlObject.DataValueField = "SubCategoryID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadCity(int StateID, int BusinessZoneID = 0)
    {
        if (BusinessZoneID == 0)
            return CacheQuery.loadCity(StateID, null);
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.City,cm.ID FROM `city_master` cm ");
            sb.Append(" INNER JOIN state_master sm ON ");
            sb.Append(" sm.`id`=cm.`stateID` ");
            if (StateID != -1)
                sb.AppendFormat(" AND sm.`id`='{0}' ", StateID);
            sb.Append(" INNER JOIN BusinessZone_master bzm  ");
            sb.Append(" ON bzm.`BusinessZoneID`=sm.`BusinessZoneID` ");
            if (StateID == -1)
                sb.AppendFormat(" and bzm.`BusinessZoneID`='{0}' ", BusinessZoneID);
            sb.Append(" ORDER BY cm.`City`  ");
          // System.IO.File.WriteAllText(@"F:\lffffff.txt", sb.ToString());
            return StockReports.GetDataTable(sb.ToString());
        }
    }
    public static void bindCity(DropDownList ddlObject, int StateID, string Type = "")
    {
        using (DataTable dtData = loadCity(StateID))
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "city";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadState(int CountryID = 0, int BusinessZoneID = 0)
    {
        if (CountryID != 0 && BusinessZoneID==0)
            return CacheQuery.loadState(CountryID, null);
        else if (BusinessZoneID == 0)
            return StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state");
        else
            return StockReports.GetDataTable(string.Format("SELECT ID,State FROM state_master WHERE BusinessZoneID='{0}' AND IsActive=1 ORDER BY state", BusinessZoneID));
    }
    public static void bindState(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadState())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "state";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadLocalityByZone(int ZoneID)
    {
        return StockReports.GetDataTable(string.Format("SELECT ID,NAME FROM f_locality WHERE active=1 AND ZoneID={0} AND Active=1 order by name", ZoneID));
    }
    public static void bindLocalityByZone(DropDownList ddlObject, int ZoneID, string Type = "")
    {
        using (DataTable dtData = loadLocalityByZone(ZoneID))
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "NAME";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadDesignation()
    {
        return StockReports.GetDataTable("SELECT ID,NAME FROM `f_designation_msater` ORDER BY NAME");
    }
    public static void bindDesignation(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadDesignation())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "NAME";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadEmployee()
    {
        return StockReports.GetDataTable("SELECT Employee_ID,NAME FROM employee_master order by Name");
    }
    public static void bindEmployee(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadEmployee())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "NAME";
                ddlObject.DataValueField = "Employee_ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }

    public static DataTable loadBank()
    {
        return CacheQuery.loadBank();
    }
    public static DataTable loadBank(int ID)
    {
        return StockReports.GetDataTable(string.Format("SELECT Bank_ID,BankName FROM f_bank_master  where IsOnlineBank={0} ORDER By BankName", ID));
    }
    public static void bindBank(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadBank())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "BankName";
                ddlObject.DataValueField = "Bank_ID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static DataTable loadDocTypeList(int i)
    {
        // 5 for Doc Department,1 doc Degree,3 Doc Specialization
        return StockReports.GetDataTable(string.Format("SELECT ID,Name from type_master where TypeID ={0} order by Name", i));
    }
    public static void bindDocTypeList(DropDownList typeList, int docType, string type = "")
    {
        using (DataTable dtData = loadDocTypeList(docType))
        {
            if (dtData.Rows.Count > 0)
            {
                typeList.DataSource = dtData;
                typeList.DataTextField = "Name";
                typeList.DataValueField = "Name";
                typeList.DataBind();
                typeList.Items.Insert(0, new ListItem(type, "0"));
            }
        }
    }
    public static DataTable GetUserName(string userID)
    {
        return StockReports.GetDataTable(string.Format("select CONCAT(Title,' ',Name) EmpName from employee_master where Employee_ID = '{0}'", userID));
    }
    public static DataTable loadZone(int CityID)
    {
        return StockReports.GetDataTable(string.Format("SELECT ZoneID,Zone FROM `centre_zonemaster`   Where IsActive=1 AND CityID={0} ORDER By Zone", CityID));
    }
    public static void bindZone(DropDownList ddlObject, int CityID, string Type = "")
    {
        using (DataTable dtData = loadZone(CityID))
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "Zone";
                ddlObject.DataValueField = "ZoneID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += string.Format(",'{0}'", li.Value);
                else
                    str = string.Format("'{0}'", li.Value);
            }
        }
        return str;
    }
    public static ArrayList GetSelection(ListBox cbl)
    {
        ArrayList al = new ArrayList();
        foreach (ListItem li in cbl.Items)
            if (li.Selected)
                al.Add(li.Value);
        return al;
    }
    public static void FillDateTime(TextBox fromDate, TextBox toDate, TextBox fromTime = null, TextBox toTime = null)
    {
        fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        toDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        if (fromTime != null)
            fromTime.Text = "00:00:00";
        if (toTime != null)
            toTime.Text = "23:59:59";
    }
    public static DataTable loadOutSourceLab()
    {
        return StockReports.GetDataTable("SELECT ID,NAME FROM `outsourcelabMaster` WHERE Active=1 ORDER BY NAME");
    }
    public static DataTable loadObservationType()
    {
        return StockReports.GetDataTable("SELECT otm.`ObservationType_ID`,otm.`Name` FROM `observationtype_master` otm INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=otm.ObservationType_ID WHERE scm.`Active`=1  ORDER BY otm.Print_Sequence ");
    }
    public static DataTable loadInvestigation()
    {
        return StockReports.GetDataTable("SELECT inv.`Investigation_Id`,NAME FROM `investigation_master` inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` WHERE im.`IsActive`=1 AND im.`SubCategoryID`='LSHHI26' ORDER BY inv.`Name` ");
    }
    public static DataTable loadLocalityByCity(int CityID, int StateID = 0)
    {
        if (CityID != 0)
            return StockReports.GetDataTable(string.Format("SELECT ID,NAME FROM f_locality WHERE active=1 AND CityID={0} AND Active=1 order by name", CityID));
        else
            return StockReports.GetDataTable(string.Format("SELECT ID,NAME FROM f_locality WHERE active=1 AND StateID={0} AND Active=1 order by name", StateID));
    }
    public static void bindAllCentreLab(DropDownList ddlCentre = null, ListBox lstCentre = null, GridView grdCentre = null, string Type = "")
    {
        if (ddlCentre != null)
        {
            ddlCentre.DataSource = getCentreLab();
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            if (Type != "")
                ddlCentre.Items.Insert(0, new ListItem(Type, "0"));
        }
        else if (lstCentre != null)
        {
            lstCentre.DataSource = getCentreLab();
            lstCentre.DataTextField = "Centre";
            lstCentre.DataValueField = "CentreID";
            lstCentre.DataBind();
        }
        else if (grdCentre != null)
        {
            grdCentre.DataSource = getCentreLab();

            grdCentre.DataBind();
        }
    }
    public static string getCentre(int centreID)
    {
        return StockReports.ExecuteScalar(string.Format("SELECT centre FROM centre_master where centreID='{0}' ", centreID));
    }
    public static DataTable loadPatientType()
    {
        return StockReports.GetDataTable("SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE Active=1  ");
    }
    public static DataTable loadBusinessZone()
    {
        return StockReports.GetDataTable("SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master WHERE IsActive=1 ORDER BY BusinessZoneName");
    }
    public static void bindBusinessZone(DropDownList ddlObject, string Type = "")
    {
        using (DataTable dtData = loadBusinessZone())
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "BusinessZoneName";
                ddlObject.DataValueField = "BusinessZoneID";
                ddlObject.DataBind();
               // if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem("All", "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static string getCentreBusinessZone()
    {
        return StockReports.ExecuteScalar(string.Format("SELECT BusinessZoneID FROM centre_master WHERE IsActive=1 AND CentreID='{0}'", UserInfo.Centre));
    }
    public string changeNumericToWords(string numb)
    {
        string num = numb;
        return changeToWords(num, false);
    }
    public string changeToWords(String numb, bool isCurrency)
    {
        string val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";
        string endStr = (isCurrency) ? ("Only") : ("");
        try
        {
            int decimalPlace = numb.IndexOf(".");
            if (decimalPlace > 0)
            {
                wholeNo = numb.Substring(0, decimalPlace);
                points = numb.Substring(decimalPlace + 1);
                if (Convert.ToInt32(points) > 0)
                {
                    andStr = (isCurrency) ? ("and") : ("point");// just to separate whole numbers from points/cents
                    endStr = (isCurrency) ? ("Cents " + endStr) : ("");
                    pointStr = translateCents(points);
                }
            }
            val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);
        }
        catch { ;}
        return val;
    }
    private string translateWholeNumber(String number)
    {
        string word = "";
        try
        {
            bool beginsZero = false;//tests for 0XX
            bool isDone = false;//test if already translated
            double dblAmt = (Convert.ToDouble(number));
            //if ((dblAmt > 0) && number.StartsWith("0"))
            if (dblAmt > 0)
            {//test for zero or digit zero in a nuemric
                beginsZero = number.StartsWith("0");

                int numDigits = number.Length;
                int pos = 0;//store digit grouping
                String place = "";//digit grouping name:hundres,thousand,etc...
                switch (numDigits)
                {
                    case 1://ones' range
                        word = ones(number);
                        isDone = true;
                        break;
                    case 2://tens' range
                        word = tens(number);
                        isDone = true;
                        break;
                    case 3://hundreds' range
                        pos = (numDigits % 3) + 1;
                        place = " Hundred ";
                        break;
                    case 4://thousands' range
                    case 5:
                    case 6:
                        pos = (numDigits % 4) + 1;
                        place = " Thousand ";
                        break;
                    case 7://millions' range
                    case 8:
                    case 9:
                        pos = (numDigits % 7) + 1;
                        place = " Million ";
                        break;
                    case 10://Billions's range
                        pos = (numDigits % 10) + 1;
                        place = " Billion ";
                        break;
                    //add extra case options for anything above Billion...
                    default:
                        isDone = true;
                        break;
                }
                if (!isDone)
                {//if transalation is not done, continue...(Recursion comes in now!!)
                    word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));
                    //check for trailing zeros
                    if (beginsZero) word = " and " + word.Trim();
                }
                //ignore digit grouping names
                if (word.Trim().Equals(place.Trim())) word = "";
            }
        }
        catch { ;}
        return word.Trim();
    }
    private String tens(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = null;
        switch (digt)
        {
            case 10:
                name = "Ten";
                break;
            case 11:
                name = "Eleven";
                break;
            case 12:
                name = "Twelve";
                break;
            case 13:
                name = "Thirteen";
                break;
            case 14:
                name = "Fourteen";
                break;
            case 15:
                name = "Fifteen";
                break;
            case 16:
                name = "Sixteen";
                break;
            case 17:
                name = "Seventeen";
                break;
            case 18:
                name = "Eighteen";
                break;
            case 19:
                name = "Nineteen";
                break;
            case 20:
                name = "Twenty";
                break;
            case 30:
                name = "Thirty";
                break;
            case 40:
                name = "Fourty";
                break;
            case 50:
                name = "Fifty";
                break;
            case 60:
                name = "Sixty";
                break;
            case 70:
                name = "Seventy";
                break;
            case 80:
                name = "Eighty";
                break;
            case 90:
                name = "Ninety";
                break;
            default:
                if (digt > 0)
                {
                    name = string.Format("{0} {1}", tens(digit.Substring(0, 1) + "0"), ones(digit.Substring(1)));
                }
                break;
        }
        return name;
    }
    private String ones(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = "";
        switch (digt)
        {
            case 1:
                name = "One";
                break;
            case 2:
                name = "Two";
                break;
            case 3:
                name = "Three";
                break;
            case 4:
                name = "Four";
                break;
            case 5:
                name = "Five";
                break;
            case 6:
                name = "Six";
                break;
            case 7:
                name = "Seven";
                break;
            case 8:
                name = "Eight";
                break;
            case 9:
                name = "Nine";
                break;
        }
        return name;
    }
    private String translateCents(String cents)
    {
        String cts = string.Empty, digit = string.Empty, engOne = string.Empty;
        for (int i = 0; i < cents.Length; i++)
        {
            digit = cents[i].ToString();
            if (digit.Equals("0"))
                engOne = "Zero";
            else
                engOne = ones(digit);
            cts += " " + engOne;
        }
        return cts;
    }
    public static void bindDropDown(DropDownList ddlObject, string Type = "", string Query = "")
    {
        using (DataTable dtData = StockReports.GetDataTable(Query))
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "Text";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();
                if (Type != string.Empty)
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }
    public static void getCurrentDate(TextBox toDate, TextBox fromDate)
    {
        toDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        toDate.Attributes.Add("readOnly", "true");
        fromDate.Attributes.Add("readOnly", "true");
    }
    public static int enrolmentAccessRight(string VerificationType)
    {
        return Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM sales_approvalright_master WHERE VerificationType='{0}' AND IsActive=1 AND ApprovalID='{1}'", VerificationType, UserInfo.ID)));

    }
    public static String PreparePOSTForm(System.Collections.Specialized.NameValueCollection data, int ReportType)
    {
        string host = HttpContext.Current.Request.Url.Host;
        string url = string.Empty;
        if (ReportType == 1)
            url = string.Format("{0}/Design/Common/CrystalReport.aspx", Resources.Resource.ReportURL);
        else if (ReportType == 2)
            url = string.Format("{0}/Design/Common/Report.aspx", Resources.Resource.ReportURL);
        //Set a name for the form
        const string formID = "PostForm";
        //Build the form using the specified data to be posted.
        StringBuilder strForm = new StringBuilder();
        strForm.AppendFormat("<form id=\"{0}\" name=\"{0}\" action=\"{1}\" method=\"POST\" target=\"_blank\">", formID, url);

        foreach (string key in data)
        {
            strForm.AppendFormat("<input type=\"hidden\" name=\"{0}\" value=\"{1}\">", key, data[key]);
        }
        strForm.Append("</form>");
        //Build the JavaScript which will do the Posting operation.
        StringBuilder strScript = new StringBuilder();
        strScript.Append("<script language='javascript'>");
        strScript.AppendFormat("var v{0} = document.{0};", formID);
        strScript.AppendFormat("v{0}.submit();", formID);
        strScript.Append("</script>");
        //Return the form and the script concatenated.
        //(The order is important, Form then JavaScript)
        return strForm + strScript.ToString();
    }
    public static void exportToCrystalReport(string sb, string ReportXMLPath, string ReportPath, System.Web.UI.Page page)
    {
        System.Collections.Specialized.NameValueCollection collections = new System.Collections.Specialized.NameValueCollection();
        collections.Add("Query", sb);
        collections.Add("ReportXMLPath", ReportXMLPath);
        collections.Add("ReportPath", ReportPath);
        string strForm = AllLoad_Data.PreparePOSTForm(collections, 1);
        page.Controls.Add(new System.Web.UI.LiteralControl(strForm));
    }

    public static void exportToExcel(string sb, string ReportName, string Period, string IsAutoIncrement, System.Web.UI.Page page)
    {
        System.Collections.Specialized.NameValueCollection collections = new System.Collections.Specialized.NameValueCollection();
        collections.Add("Query", sb);
        collections.Add("ReportName", ReportName.Replace(",", string.Empty));
        collections.Add("Period", Period);
        collections.Add("IsAutoIncrement", "1");
        string strForm = AllLoad_Data.PreparePOSTForm(collections, 2);
        page.Controls.Add(new System.Web.UI.LiteralControl(strForm));
    }

    public static string getSalesChildNode(MySqlConnection con, int EmployeeID)
    {
        MySqlParameter paramTnxID = new MySqlParameter()
        {
            ParameterName = "@_EmployeeIDOut",
            MySqlDbType = MySqlDbType.VarChar,
            Size = 500,
            Direction = ParameterDirection.Output
        };
        MySqlCommand cmd = new MySqlCommand("get_ChildNode_proc", con) { CommandType = CommandType.StoredProcedure };
        cmd.Parameters.Add(new MySqlParameter("@_EmployeeID", EmployeeID));
        cmd.Parameters.Add(paramTnxID);
        return Util.GetString(cmd.ExecuteScalar());
    }
    public static DataTable getTagBusinessLab()
    {
        return StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 AND Category='Lab' ORDER BY centre");
    }
    public static DataTable getLedgerClient(int BusinessZoneID, int StateID, int SearchType, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        {
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID)Panel_ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
            sb.Append(" WHERE   fpm.isInvoice=1   ");
            if (BusinessZoneID != 0)
                sb.AppendFormat(" AND cm.BusinessZoneID='{0}'", BusinessZoneID);
            if (StateID != -1)
                sb.AppendFormat("  AND cm.StateID='{0}' ", StateID);
            sb.AppendFormat(" AND cm.type1ID='{0}'  ", SearchType);
            sb.Append(" AND fpm.Panel_ID=fpm.InvoiceTo   ");
        }
        else
        {
            if (HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "1")
            {
                string SalesTeamMembers = AllLoad_Data.getSalesChildNode(con, UserInfo.ID);
                sb = new StringBuilder();
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name),CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID) Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt  ");
                sb.AppendFormat(" FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID AND fpm.SalesManager IN ({0}) ", SalesTeamMembers);
                sb.Append("  WHERE fpm.PanelType ='Centre' AND fpm.Panel_ID=fpm.InvoiceTo  ");
            }
            else
            {
                sb = new StringBuilder();
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID)Panel_ID,cm.Type1ID,fpm.ShowBalanceAmt FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE    ");
                sb.AppendFormat("  cm.IsActive=1  AND fpm.IsInvoice=1  AND fpm.Panel_ID=fpm.InvoiceTo   AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID ='{0}' ) OR cm.CentreID ='{1}' ) ", UserInfo.Centre, UserInfo.Centre);

            }
        }

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
    }
    public static string getLedgerReportPassword(int? PanelID)
    {
        return StockReports.ExecuteScalar(string.Format(" SELECT IFNULL(LedgerReportPassword,'')LedgerReportPassword FROM f_panel_master fpm  WHERE Panel_ID='{0}' AND IFNULL(LedgerReportPassword,'')<>'' ", PanelID));
    }
    public static int getLedgerPasswordMatches(string EnterPassword, string DeafultPassword)
    {

        System.Text.RegularExpressions.Match Match = System.Text.RegularExpressions.Regex.Match(EnterPassword, DeafultPassword, System.Text.RegularExpressions.RegexOptions.Singleline);
        if (Match.Success)
            return 1;
        else
            return 0;
    }
    public static DataTable getCentreByTagBusinessLab()
    {
        if (UserInfo.Centre == 1)
        {
            return StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm INNER JOIN f_panel_master pm ON cm.CentreId=pm.`CentreID` WHERE pm.`PanelType` = 'Centre'   ORDER BY centre");
        }
        else
        {
            return StockReports.GetDataTable(string.Format("SELECT DISTINCT cm.`CentreID`,cm.`Centre` FROM centre_master cm  INNER JOIN f_panel_master pm ON cm.CentreId=pm.`CentreID` WHERE pm.`PanelType` = 'Centre' AND ( pm.`TagBusinessLabID` ={0} OR cm.CentreId ={1})  ORDER BY centre", UserInfo.Centre, UserInfo.Centre));
        }
    }
    public static string getHostDetail(string ReportType)
    {
        return string.Concat(string.Format("{0}/Design/Common/", Resources.Resource.ReportURL), ReportType, ".aspx");
    }
    public static DirectoryInfo createDocumentFolder(string folderName, string subFolderName, string anotherSubFolderName = "")
    {
        try
        {
            var pathname = new DirectoryInfo(string.Format("{0}{1}\\{2}\\{3}", Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, Resources.Resource.DocumentFolderName, folderName));
            if (pathname.Exists == false)
                pathname.Create();
            pathname = new DirectoryInfo(string.Format("{0}{1}\\{2}\\{3}\\{4}", Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, Resources.Resource.DocumentFolderName, folderName, subFolderName));
            if (pathname.Exists == false)
                pathname.Create();
            if (anotherSubFolderName != "")
            {
                pathname = new DirectoryInfo(string.Format("{0}{1}\\{2}\\{3}\\{4}\\{5}", Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, Resources.Resource.DocumentFolderName, folderName, subFolderName, anotherSubFolderName));
                if (pathname.Exists == false)
                    pathname.Create();
            }
            return pathname;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static int chkDocumentDrive()
    {
        try
        {
            DirectoryInfo folder = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName);
            if (folder.Exists)
            {
                DirectoryInfo[] SubFolder = folder.GetDirectories(Resources.Resource.DocumentFolderName);
                if (SubFolder.Length == 0)
                {
                    var directory = new DirectoryInfo(string.Format("{0}{1}\\{2}", Resources.Resource.DocumentDriveIPAddress, Resources.Resource.DocumentDriveName, Resources.Resource.DocumentFolderName));
                    if (directory.Exists == false)
                    {
                        directory.Create();
                    }
                }
                return 1;
            }
            else
                return 0;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }
    public string getClientBalanceAmt()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "NRL" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "PUP" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "CC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "FC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "B2B" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "HLM" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "PCC")
            {
                string str = string.Empty;

                if (HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "CC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "FC" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "B2B" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "HLM" || HttpContext.Current.Session["CentreType"].ToString().ToUpper() == "PCC")
                {
                    int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE CentreID=@CentreID AND PanelType='Centre' AND Panel_ID=InvoiceTo",
                       new MySqlParameter("@CentreID", HttpContext.Current.Session["Centre"])));
                    if (IsShowIntimation == 1)
                    {
                        str = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@Centre) ",
                           new MySqlParameter("@CentreType", HttpContext.Current.Session["CentreType"]), new MySqlParameter("@Centre", HttpContext.Current.Session["Centre"])));
                        return JsonConvert.SerializeObject(new { status = true, response = str.Split('#')[0].ToString(), blink = str.Split('#')[1].ToString() });

                    }
                    else
                        return JsonConvert.SerializeObject(new { status = false, response = string.Empty, blink = string.Empty });
                }
                else
                {
                    int IsShowIntimation = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsShowIntimation FROM f_panel_master WHERE Panel_ID=@Panel_ID ",
                        new MySqlParameter("@Panel_ID", HttpContext.Current.Session["OnlinePanelID"])));
                    if (IsShowIntimation == 1)
                    {
                        str = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_client_intimation(@CentreType,@OnlinePanelID) ",
                            new MySqlParameter("@CentreType", HttpContext.Current.Session["CentreType"]), new MySqlParameter("@OnlinePanelID", HttpContext.Current.Session["OnlinePanelID"])));
                        return JsonConvert.SerializeObject(new { status = true, response = str.Split('#')[0].ToString(), blink = str.Split('#')[1].ToString() });

                    }
                    else
                        return JsonConvert.SerializeObject(new { status = false, response = string.Empty, blink = string.Empty });
                }
            }
            else
                return JsonConvert.SerializeObject(new { status = false, response = string.Empty, blink = string.Empty });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = string.Empty, blink = string.Empty });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable LoadCountry()
    {
        return StockReports.GetDataTable("SELECT CountryID,NAME FROM country_master Order BY NAME");
    }
    public static DataTable LoadCountryByID(string CountryID)
    {
        return StockReports.GetDataTable("SELECT NAME,Currency,Notation,Address,PhoneNo,FaxNo,EmbassyAddress,EmbassyPhoneNo,EmbessyFaxNo,IsActive,IsBaseCurrency FROM Country_master WHERE CountryID='" + CountryID + "'");
    }
    public static DataTable LoadCurrency()
    {
        return StockReports.GetDataTable("SELECT CountryID,CONCAT(Currency,'$',Notation)CurrencyName,IsBaseCurrency FROM Country_master where IsActive=1 AND Currency IS NOT NULL ");
    }
    public static DataTable LoadBaseCurrency()
    {
        return StockReports.GetDataTable("SELECT CountryID,CONCAT(Currency,'$',Notation)CurrencyName FROM Country_master where IsActive=1 and IsBaseCurrency=1");
    }
    public static DataTable LoadCurrencyFactor(string CountryID)
    {
        using (DataTable dtCurrencyFactor = CacheQuery.loadCurrency())
        {
            if (string.IsNullOrEmpty(CountryID))
                return dtCurrencyFactor;
            else
            {
                DataView CurrencyView = dtCurrencyFactor.DefaultView;
                CurrencyView.RowFilter = "CountryID=" + CountryID + "";
                return CurrencyView.ToTable();
            }
        }
    }
    public decimal GetConversionFactor(int CountryID)
    {
        decimal ConversionFactor = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return ConversionFactor = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select GetConversionFactor(@CountryID)",
               new MySqlParameter("@CountryID", CountryID)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ConversionFactor;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable bindPaymentMode()
    {
        return StockReports.GetDataTable("SELECT PaymentModeID,PaymentMode,IsBankShow,IsChequeNoShow,IsChequeDateShow,IsOnlineBankShow FROM paymentmode_master WHERE Active=1 AND PaymentModeID<>4 AND IsVisible=1 ORDER BY Sequence+0");
    }
    public string ConvertCurrencyBase(int CountryID, decimal Amount)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (MySqlCommand cmd = new MySqlCommand("ConvertCurrency_BaseAmount", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new MySqlParameter("vCountryID", CountryID));
                cmd.Parameters.Add(new MySqlParameter("vAmount", Amount));
                cmd.Parameters.Add("vBaseCurrencyAmount", MySqlDbType.Decimal).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("vConversionFactor", MySqlDbType.Decimal).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("vConverson_ID", MySqlDbType.Int32).Direction = ParameterDirection.Output;
                cmd.Parameters.Add("vSellingCurrencyAmount", MySqlDbType.Decimal).Direction = ParameterDirection.Output;
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    using (dt as IDisposable)
                    {
                        da.Fill(dt);
                        return JsonConvert.SerializeObject(new { BaseCurrencyAmount = (decimal)cmd.Parameters["vBaseCurrencyAmount"].Value, ConversionFactor = (decimal)cmd.Parameters["vConversionFactor"].Value, Converson_ID = (int)cmd.Parameters["vConverson_ID"].Value, SellingCurrencyAmount = (decimal)cmd.Parameters["vSellingCurrencyAmount"].Value });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public decimal ConvertCurrency(int CountryID, decimal Amount)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            return Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ConvertCurrency(@CountryID,@Amount)",
               new MySqlParameter("@CountryID", CountryID), new MySqlParameter("@Amount", Amount)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static string getBillNo(int CentreID, string Type, MySqlConnection con, MySqlTransaction tnx)
    {
        using (MySqlCommand cmd = new MySqlCommand("f_Generate_Bill_No", con, tnx))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new MySqlParameter("_CentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("_Type", Type));
            cmd.Parameters.Add("Bill_No", MySqlDbType.VarChar, 25);
            cmd.Parameters["Bill_No"].Direction = ParameterDirection.Output;
            cmd.ExecuteScalar();
            return (string)cmd.Parameters["Bill_No"].Value;
        }
    }
    public decimal getOPDBalanceAmt(string Patient_ID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IFNULL( SUM(oa.AdvanceAmount-oa.BalanceAmount),0) FROM opd_advance oa WHERE oa.IsCancel = 0  AND   oa.Patient_ID = @Patient_ID ");
        if (con == null)
        {
            MySqlConnection con1 = Util.GetMySqlCon();
            con1.Open();
            try
            {
                return Util.GetDecimal(MySqlHelper.ExecuteScalar(con1, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Patient_ID", Patient_ID)));
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return 0;

            }
            finally
            {
                con1.Close();
                con1.Dispose();
            }

        }
        else
        {
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Patient_ID", Patient_ID)));
        }

    }

    public string sendDiscountVerificationMail(string LedgerTransactionNo, string PName, string Age, string Gender, int DiscountApprovedByID, decimal GrossAmount, decimal DiscountOnTotal, decimal NetAmount, string DiscountReason, int CentreID, int LedgerTransactionID, MySqlConnection con, MySqlTransaction tnx)
    {
        string emailto = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT email FROM `employee_master` WHERE employee_id=@DiscountApprovedByID",
        new MySqlParameter("@DiscountApprovedByID", DiscountApprovedByID)));
        if (emailto == string.Empty)
            return JsonConvert.SerializeObject(new { status = false, response = "Employee Email not set" });



        string _EmailMsg = File.ReadAllText(HttpContext.Current.Server.MapPath("../../EmailBody/Email_Template.txt"));

        string body = string.Empty; string mainBody = string.Empty;
        using (StreamReader reader = new StreamReader(HttpContext.Current.Server.MapPath("../../EmailBody/Email_Template.txt")))
        {
            body = reader.ReadToEnd();
        }
        mainBody = body;
        body = body.Replace("{PName}", PName.ToUpper());
        body = body.Replace("{Age}", Age);
        body = body.Replace("{Gender}", Gender);
        body = body.Replace("{Centre}", Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Centre FROM centre_master WHERE CentreID=@CentreID",
           new MySqlParameter("@CentreID", CentreID))));
        body = body.Replace("{GrossAmt}", Util.GetString(GrossAmount));
        body = body.Replace("{DiscAmt}", Util.GetString(DiscountOnTotal));
        body = body.Replace("{NetAmt}", Util.GetString(NetAmount));
        body = body.Replace("{DiscReason}", Util.GetString(DiscountReason));
        if (Resources.Resource.RemoteLinkApplicable == "1")
        {
            body = body.Replace("{ApprovedLink}", string.Format("Please Click :   <a href=\"{0}/Design/OPD/DiscountApprovedByEmail.aspx?VisitNo={1}&type={2}&discamt={3}&AppBy={4}\">Approve Discount</a>", Resources.Resource.RemoteLink, Common.Encrypt(Util.GetString(LedgerTransactionID)), Common.Encrypt("1"), Common.Encrypt(DiscountOnTotal.ToString()), Common.Encrypt(Util.GetString(DiscountApprovedByID))));
            body = body.Replace("{RejectLink}", string.Format("Please Click :   <a href=\"{0}/Design/OPD/DiscountApprovedByEmail.aspx?VisitNo={1}&type={2}&discamt={3}&AppBy={4}\">Reject Discount</a>", Resources.Resource.RemoteLink, Common.Encrypt(Util.GetString(LedgerTransactionID)), Common.Encrypt("2"), Common.Encrypt(DiscountOnTotal.ToString()), Common.Encrypt(Util.GetString(DiscountApprovedByID))));

        }
        if (Resources.Resource.LocalLinkApplicable == "1")
        {
            body = body.Replace("{LocalApprovedLink}", string.Format("Please Click :   <a href=\"{0}/Design/OPD/DiscountApprovedByEmail.aspx?VisitNo={1}&type={2}&discamt={3}&AppBy={4}\">Approve Discount</a>", Resources.Resource.LinkURL, Common.Encrypt(Util.GetString(LedgerTransactionID)), Common.Encrypt("1"), Common.Encrypt(DiscountOnTotal.ToString()), Common.Encrypt(Util.GetString(DiscountApprovedByID))));
            body = body.Replace("{LocalRejectLink}", string.Format("Please Click :   <a href=\"{0}/Design/OPD/DiscountApprovedByEmail.aspx?VisitNo={1}&type={2}&discamt={3}&AppBy={4}\">Reject Discount</a>", Resources.Resource.LinkURL, Common.Encrypt(Util.GetString(LedgerTransactionID)), Common.Encrypt("2"), Common.Encrypt(DiscountOnTotal.ToString()), Common.Encrypt(Util.GetString(DiscountApprovedByID))));
        }

        //try
        //{
        //    Sales_Email_Record ser = new Sales_Email_Record(tnx);
        //    ser.EmailType = "DiscountApproval";
        //    ser.EmailTypeID = 11;
        //    ser.EmailTo = Util.GetString(emailto);
        //    ser.EmailSubject = "Discount Approval/Rejection";
        //    ser.EmailContent = body.ToString();
        //    ser.CreatedBy = UserInfo.LoginName;
        //    ser.CreatedByID = UserInfo.ID;
        //    ser.IDType1 = "EnrollID";
        //    ser.IDType1ID = 0;
        //    ser.IDType2 = "Panel_ID";
        //    ser.IDType2ID = 0;
        //    ser.LedgertransactionNo = LedgerTransactionNo;
        //    ser.LedgertransactionID = LedgerTransactionID;
        //    ser.IsAttachment = 0;
        //    ser.Insert();
        //    return JsonConvert.SerializeObject(new { status = true, response = "Success" });

        //}
        //catch (Exception ex)
        //{
        //    ClassLog cl = new ClassLog();
        //    cl.errLog(ex);
        //    return JsonConvert.SerializeObject(new { status = false, response = "Discount Approval Email Error Occurred" });

        //}
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO discountemail_log(LedgertransactionNo,LedgertransactionID,Email,Body,EmployeeId,CreatedBy,CreatedByID,CreatedDate) ");
            sb.Append(" VALUES (@LedgertransactionNo,@LedgertransactionID,@Email,@Body,@EmployeeId,@CreatedBy,@CreatedByID,NOW())");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo), new MySqlParameter("@LedgertransactionID", LedgerTransactionID),
                new MySqlParameter("@Email", emailto),
                new MySqlParameter("@Body", body.ToString()), new MySqlParameter("@EmployeeId", DiscountApprovedByID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                new MySqlParameter("@CreatedByID", UserInfo.ID));
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Discount Approval Email Error Occurred" });

        }
    }
    public DataTable bindFieldBoyCentreWise(int CentreID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT fm.Name ,fm.FeildboyID ID FROM feildboy_master fm ");
        sb.Append("  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` ");
        sb.Append("  AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`=@CentreID) ");
        sb.Append("  WHERE fm.isActive=1 ORDER BY NAME ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@CentreID", CentreID)).Tables[0];

    }
    public DataTable bindDiscountApproval(int CentreID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(dm.`EmployeeID`,'#',em.DiscountPerBill_per,'#',em.DiscountPerMonth,'#',em.DiscountOnPackage,'#',em.AppBelowBaseRate,'#',dm.DiscShareType)value,");
        sb.Append(" em.`Name` label ");
        sb.Append(" FROM discount_approval_master dm ");
        sb.Append(" INNER JOIN employee_master em ON dm.`EmployeeID`=em.`Employee_ID` AND dm.`CentreID`=@CentreID AND dm.isActive=1 group by em.Employee_ID ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@CentreID", CentreID)).Tables[0];
    }
    public static string GetCentreAccessQuery()
    {
        return "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "'  ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";
    }

    public static string GetInvestigationQuery()
    {
        return "SELECT inv.`Investigation_Id`,NAME FROM `investigation_master` inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` WHERE im.`IsActive`=1 AND im.`SubCategoryID`<>'LSHHI24' ORDER BY inv.`Name`;";
    }
    public static string GetDoctorQuery()
    {
        return "SELECT CONCAT(Title,' ',NAME) NAME,Doctor_ID FROM doctor_referal WHERE IsActive=1 ORDER BY NAME;";
    }

    public DataTable bindOutstandingEmployee(int CentreID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(co.employeeid,'#',MaxOutstandingAmt,'#',MaxBill)EmployeeID,em.`Name` ");
        sb.Append(" FROM CashOutStandingMaster co  ");
        sb.Append(" INNER JOIN employee_master em ON em.employee_id=co.employeeid WHERE co.`CenterId`=@CentreID ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@CentreID", CentreID)).Tables[0];

    }
    public static string getReportPath(string ReportType, int reportOpenOn = 0)
    {
        if (reportOpenOn == 0)
            return string.Concat(string.Format("{0}/Design/Reports/", string.Concat(HttpContext.Current.Request.Url.Scheme, "://", HttpContext.Current.Request.Url.Host, ":", HttpContext.Current.Request.Url.Port, "/", HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1])), ReportType, ".aspx");
        else
            return string.Concat(string.Format("{0}/Design/Reports/", string.Concat(HttpContext.Current.Request.Url.Scheme, "://", HttpContext.Current.Request.Url.Host, ":", HttpContext.Current.Request.Url.Port, "/", HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1])), ReportType, ".aspx");

    }
    public static DataTable getExcelDatatable(byte[] b)
    {
        //Create a new DataTable.
        DataTable dt = new DataTable();
        dt.TableName = "WorkOrder";
        System.IO.Stream stream = new System.IO.MemoryStream(b);
        using (ClosedXML.Excel.XLWorkbook workBook = new ClosedXML.Excel.XLWorkbook(stream))
        {
            //Read the first Sheet from Excel file.
            ClosedXML.Excel.IXLWorksheet workSheet = workBook.Worksheet(1);



            //Loop through the Worksheet rows.
            bool firstRow = true;
            foreach (ClosedXML.Excel.IXLRow row in workSheet.Rows())
            {
                //Use the first row to add columns to DataTable.
                if (firstRow)
                {
                    foreach (ClosedXML.Excel.IXLCell cell in row.Cells())
                    {
                        dt.Columns.Add(cell.Value.ToString().Trim());
                    }
                    firstRow = false;
                }
                else
                {
                    //Add rows to DataTable.
                    DataRow dr = dt.NewRow();
                    string temp = "";
                    int i = 0;
                    for (int j = 1; j <= dt.Columns.Count; j++)
                    {
                        ClosedXML.Excel.IXLCell cell = row.Cell(j);
                        if (j == 3 && cell.Value.ToString().Trim() != string.Empty)
                        {
                            cell.Style.DateFormat.Format = "dd-MM-yyyy";
                            cell.SetDataType(XLCellValues.DateTime);
                        }
                        temp += "" + cell.Value.ToString();
                        temp = temp.Trim();
                        dr[i] = cell.Value.ToString().Trim();
                        i++;
                    }
                    if (temp != "")
                    {
                        dt.Rows.Add(dr);
                    }

                }


            }
        }


        return dt;
    }

    public static void POSTForm(System.Collections.Specialized.NameValueCollection data, string redirectPath, System.Web.UI.Page page)
    {
        //string host = HttpContext.Current.Request.Url.Host;

        string host = HttpContext.Current.Request.Url.AbsoluteUri;
        string[] host1 = host.Split('/');
        string m = host1[2];
        string m1 = host1[3];
        string m2 = host1[0];
        string name = string.Concat(m2, "//", m, "/", m1);
        // string url = string.Format("{0}/{1}", Resources.Resource.ReportURL, redirectPath);
        // string host1= HttpContext.Current.Request.Url
        string url = string.Format("{0}/{1}", name, redirectPath);


      //  string url = string.Format("{0}/{1}", Resources.Resource.ReportURL, redirectPath);
        const string formID = "PostForm";

        StringBuilder strForm = new StringBuilder();
        strForm.Append("<html><head>");
        strForm.Append("</head><body onload='document.forms[0].submit()'>");
        strForm.AppendFormat("<form id=\"{0}\" name=\"{0}\" action=\"{1}\" method=\"POST\" target=\"_blank\">", formID, url);      
        foreach (string key in data)
        {
            strForm.AppendFormat("<input name='{0}' type='text' value='{1}'>", key, data[key]);
        }
        strForm.Append("</form></body></html>");
        StringBuilder strScript = new StringBuilder();
        strScript.Append("<script language='javascript'>");
        strScript.AppendFormat("var v{0} = document.{0};", formID);
        strScript.AppendFormat("v{0}.submit();", formID);
        strScript.Append("</script>");
        page.Controls.Add(new System.Web.UI.LiteralControl(string.Concat(strForm, strScript.ToString())));              
    }
    public static DataTable loadBusinessZoneWithCountry(int CountryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {           
            return MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master WHERE IsActive=1 AND CountryID=@CountryID ORDER BY BusinessZoneName",
                new MySqlParameter("@CountryID", CountryID)).Tables[0];
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        
    }
    public static void ExpoportToExcelEncrypt(System.Collections.Specialized.NameValueCollection data, int ReportType, System.Web.UI.Page page)
    {
        string host = HttpContext.Current.Request.Url.Host;
         string url =string.Empty;
         if (host.ToLower() != "localhost")
             url = string.Format("{0}/Design/Common/ExportToExcelReport.aspx", Resources.Resource.ReportURL);
         else
         {
             url = string.Format("{0}/Design/Common/ExportToExcelReport.aspx", string.Concat(HttpContext.Current.Request.Url.Scheme, "://", host, ":", HttpContext.Current.Request.Url.Port, "/", HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1]));
         }
        const string formID = "PostForm";
        
        StringBuilder strForm = new StringBuilder();
        strForm.AppendFormat("<form id=\"{0}\" name=\"{0}\" action=\"{1}\" method=\"POST\" target=\"_blank\">", formID, url);

        foreach (string key in data)
        {
            strForm.AppendFormat("<input type=\"hidden\" name=\"{0}\" value=\"{1}\">", key, data[key]);
        }
        strForm.Append("</form>");

        StringBuilder strScript = new StringBuilder();
        strScript.Append("<script language='javascript'>");
        strScript.AppendFormat("var v{0} = document.{0};", formID);
        strScript.AppendFormat("v{0}.submit();", formID);
        strScript.Append("</script>");

        page.Controls.Add(new System.Web.UI.LiteralControl(string.Concat(strForm, strScript.ToString())));

    }
    public static string ExportToExcelEncryptURL()
    {
        string host = HttpContext.Current.Request.Url.Host;
        string url = string.Empty;
        if (host.ToLower() != "localhost")
            url = string.Format("{0}/Design/Common/ExportToExcelReport.aspx", Resources.Resource.ReportURL);
        else
            url = string.Format("{0}/Design/Common/ExportToExcelReport.aspx", string.Concat(HttpContext.Current.Request.Url.Scheme, "://", host, ":", HttpContext.Current.Request.Url.Port, "/", HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1]));
        return url;

    }
    public static string IpAddress()
    {
        string IpAddress = string.Empty;
        if (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
            IpAddress = HttpContext.Current.Request.UserHostAddress;
        else
            IpAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        return IpAddress;
    }
    public static int validateAPIUserNamePassword(string UserName, string Password, string Companyname, MySqlConnection con)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT COUNT(1) FROM `f_Interface_Company_Master` WHERE `APIUserName`=@APIUserName ");
            sb.Append(" AND BINARY `APIPassword`=@APIPassword AND `CompanyName`=@CompanyName AND IsActive=1 ");
            return Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@APIUserName", UserName),
                   new MySqlParameter("@APIPassword", Password),
                   new MySqlParameter("@CompanyName", Companyname)));

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }
 public static string GetSalesManagerQuery()
    {

        if (UserInfo.AccessPROIDs != "")
        {
            string _TeamMember = UserInfo.AccessPROIDs;
            return "SELECT ProId,ProName,Designation as Designation FROM salesteam_master where ProId IN (" + _TeamMember + ");";
        }
        else
        {
            return "SELECT ProId,ProName,Designation as Designation FROM salesteam_master ;";
        }
    }
    public static int IsInvoiceCreated(MySqlConnection con, int LedgerTransactionID)
    {
        return Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd_share WHERE LedgerTransactionID=@LedgerTransactionID AND IFNULL(InvoiceNo,'')!=''",
                                       new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));
    }
    public static string getHostDetail()
    {

        if (Resources.Resource.ReportOpenOnReportServer == "1")
        {
            return string.Format("{0}", Resources.Resource.ReportURL);
        }
        else
        {
            return string.Format("{0}", string.Concat(HttpContext.Current.Request.Url.Scheme, "://", HttpContext.Current.Request.Url.Host, ":", HttpContext.Current.Request.Url.Port, "/", HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1]));

        }

    }
}