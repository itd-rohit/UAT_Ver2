using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Investigation_ManagePackage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
		
            if (Util.GetString(Session["RoleID"]) == "")
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            BindInvListBox();
        }
    }

 [WebMethod]
    public static int testcodenumber()
    {
        int chkTestCode = Util.GetInt(StockReports.ExecuteScalar(" SELECT MAX(id) FROM packagelab_master "));
        int chkTestnumber = (chkTestCode + 1);
       return chkTestnumber;

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveOrdering(string PackageID, string ObsData, string PackageName, string ItemID, string IsActive, string Rate, string Code, string ShowInReport, string PrintSeprateData, string FromAge, string ToAge, string Gender, string sampledefinedata, string BaseRate)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            ObsData = ObsData.TrimEnd('#');
            string str = "";
            int len = Util.GetInt(ObsData.Split('#').Length);
            string[] Data = new string[len];
            Data = ObsData.Split('#');





            for (int i = 0; i < len; i++)
            {
                string abc = Data[i].Split('|')[0].ToString();
                str = "Update package_labdetail Set UpdatedByID='" + HttpContext.Current.Session["ID"] + "',UpdatedBy='" + HttpContext.Current.Session["LoginName"] + "',UpdateDate=NOW(),Priority=" + (Util.GetInt(i) + 1) + "  where PlabID='" + PackageID + "' and InvestigationID='" + Data[i].Split('|')[0].ToString() + "' ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
            }

            PrintSeprateData = PrintSeprateData.TrimEnd('#');
            sampledefinedata = sampledefinedata.TrimEnd('#');
          
            string[] PSData = new string[len];
            PSData = PrintSeprateData.Split('#');
            for (int i = 0; i < len; i++)
            {
                string InvestigationIDWithPrintSeprateData = PSData[i].Split('|')[0].ToString();
                string PrintSepData = InvestigationIDWithPrintSeprateData.Substring(InvestigationIDWithPrintSeprateData.Length - 1);
                string InvestigationID = InvestigationIDWithPrintSeprateData.Remove(InvestigationIDWithPrintSeprateData.Length - 2);
                str = "Update package_labdetail Set PrintSeprate='" + PrintSepData + "'  where PlabID='" + PackageID + "' and InvestigationID='" + InvestigationID + "' ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
            }
            string[] PSData1 = new string[len];
            PSData1 = sampledefinedata.Split('#');
            for (int i = 0; i < len; i++)
            {
                string InvestigationIDWithPrintSeprateData = PSData1[i].Split('|')[0].ToString();
                string PrintSepData = InvestigationIDWithPrintSeprateData.Substring(InvestigationIDWithPrintSeprateData.Length - 1);
                string InvestigationID = InvestigationIDWithPrintSeprateData.Remove(InvestigationIDWithPrintSeprateData.Length - 2);
                str = "Update package_labdetail Set SampleDefinedPackage='" + PrintSepData + "'  where PlabID='" + PackageID + "' and InvestigationID='" + InvestigationID + "' ";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);
            }

            string strUpdatepackagelab_master = "update packagelab_master set ShowInReport='" + ShowInReport + "',Name='" + PackageName + "',IsActive='" + IsActive + "' where PlabID='" + PackageID + "'";

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strUpdatepackagelab_master);
            if (ItemID != "")
            {
                int chkTestCode = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM f_itemmaster where TestCode='" + Code + "' AND itemID<>'" + ItemID + "' "));
                if (chkTestCode > 0)
                {
                    return "-3";
                }

                string strUpdatef_itemmaster = "update f_itemmaster set ShowInReport='" + ShowInReport + "',BaseRate=" + BaseRate + ",FromAge='" + Util.GetInt(FromAge) + "',ToAge='" + Util.GetInt(ToAge) + "',Gender='" + Gender + "',TypeName='" + PackageName + "',TestCode='" + Code + "',IsActive='" + IsActive + "' where ItemID='" + ItemID + "'";


                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strUpdatef_itemmaster);

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID=@ItemID AND Panel_ID=@Panel_ID ",
                   new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
                   new MySqlParameter("@ItemID", ItemID),
                   new MySqlParameter("@Panel_ID", "78"));

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_rateList where ItemID=@ItemID AND Panel_ID=@Panel_ID",
                   new MySqlParameter("@ItemID", ItemID),
                   new MySqlParameter("@Panel_ID", "78"));
            }

            RateList objRateList = new RateList(tranX);
            objRateList.Panel_ID = 78;
            objRateList.ItemID = Util.GetInt(ItemID);
            objRateList.Rate = Util.GetDecimal(Rate);
            objRateList.IsTaxable = 0;
            objRateList.FromDate = DateTime.Now;
            objRateList.ToDate = DateTime.Now;
            objRateList.IsCurrent = 1;
            objRateList.IsService = "YES";
            objRateList.ItemDisplayName = PackageName;
            objRateList.ItemCode = "";
            objRateList.UpdateBy = UserInfo.LoginName;
            objRateList.UpdateDate = DateTime.Now;
            objRateList.Insert();

            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SavePackageOrdering(string PackageOrder)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        try
        {
            PackageOrder = PackageOrder.TrimEnd('#');
            string strPackageOrder = "";
            int lenPackageOrder = Util.GetInt(PackageOrder.Split('#').Length);
            string[] DataPackageOrder = new string[lenPackageOrder];
            DataPackageOrder = PackageOrder.Split('#');
            for (int i = 0; i < lenPackageOrder; i++)
            {
                strPackageOrder = "Update packagelab_master Set UpdatedByID='" + HttpContext.Current.Session["ID"] + "',UpdatedBy='" + HttpContext.Current.Session["LoginName"] + "',UpdateDate=NOW(),Priority=" + (Util.GetInt(i) + 1) + "  where PlabID='" + DataPackageOrder[i].ToString() + "' ";
                StockReports.ExecuteDML(strPackageOrder);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        return "1";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string AddInvestigation(string PackageID, string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        string str = "";
        try
        {
            string strValidation = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM package_labdetail WHERE PlabID='" + PackageID + "' AND InvestigationID='" + InvestigationID + "';"));
            if (strValidation != "0")
            {
                return "2";
            }

            string LastInvPriority = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT IFNULL(MAX(priority+1),'0') FROM package_labdetail  WHERE PlabID='" + PackageID + "'"));
            int Priority = 0;
            if (LastInvPriority.Trim() == "0")
            {
                Priority = 1;
            }
            else
            {
                Priority = Util.GetInt(LastInvPriority.Trim());
            }
            str = "INSERT INTO package_labdetail(PLabID,InvestigationID,UserID,DateModified,Priority) VALUES('" + PackageID + "','" + InvestigationID + "','" + HttpContext.Current.Session["ID"] + "',NOW(),'" + Priority + "');";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            StringBuilder sbDuplicate = new StringBuilder();
            sbDuplicate.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,inv.`Name` TestName FROM `package_labdetail` pld ");
            sbDuplicate.Append("  INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=pld.`InvestigationID` AND pld.`PlabID`='" + PackageID.Trim() + "' ");
            sbDuplicate.Append("  INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID`  ");
            sbDuplicate.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
            sbDuplicate.Append("  WHERE AllowDuplicateBooking=0  ");
            sbDuplicate.Append("  GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1   ");

       //  DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbDuplicate.ToString()).Tables[0];
       //  if (dtDuplicate.Rows.Count > 0)
       //  {
       //      tnx.Rollback();
       //      tnx.Dispose();
       //      con.Close();
       //      con.Dispose();
       //      return "-0#" + dtDuplicate.Rows[0]["Name"].ToString() + " Found duplicate in " + dtDuplicate.Rows[0]["TestName"].ToString();
       //  }
       //  else
       //  {
       //      tnx.Commit();
       //      return "1";
       //  }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
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
    public static string RemoveInvestigation(string PackageID, string InvestigationID)
    {
        string str = "";
        try
        {
            str = "DELETE FROM package_labdetail WHERE PLabID='" + PackageID + "' AND `InvestigationID`='" + InvestigationID + "';";
            StockReports.ExecuteDML(str);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        return "1";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string AddPackage(string PackageID, string NewPackageID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string str = "";
        try
        {
            int MaxOrder = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT MAX(Priority) FROM package_labdetail WHERE PlabID='" + PackageID + "';"));
            DataTable dtValidation = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT InvestigationID FROM package_labdetail WHERE PlabID='" + NewPackageID + "' Order by Priority;").Tables[0];
            for (int i = 0; i < dtValidation.Rows.Count; i++)
            {
                string strValidation = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM package_labdetail WHERE PlabID='" + PackageID + "' AND InvestigationID='" + dtValidation.Rows[i][0] + "';"));
                if (strValidation == "0")
                {
                    str = "INSERT INTO package_labdetail(PLabID,InvestigationID,UserID,DateModified,Priority) VALUES('" + PackageID + "','" + dtValidation.Rows[i][0] + "','" + HttpContext.Current.Session["ID"] + "',NOW(),'" + (MaxOrder + i + 1) + "');";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                }
            }
            StringBuilder sbDuplicate = new StringBuilder();
            sbDuplicate.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,inv.`Name` TestName FROM `package_labdetail` pld ");
            sbDuplicate.Append("  INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=pld.`InvestigationID` AND pld.`PlabID`='" + PackageID.Trim() + "' ");
            sbDuplicate.Append("  INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID`  ");
            sbDuplicate.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
            sbDuplicate.Append("  WHERE AllowDuplicateBooking=0  ");
            sbDuplicate.Append("  GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1   ");

            DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbDuplicate.ToString()).Tables[0];
            if (dtDuplicate.Rows.Count > 0)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "-0#" + dtDuplicate.Rows[0]["Name"].ToString() + " Found duplicate in " + dtDuplicate.Rows[0]["TestName"].ToString();
            }
            else
            {
                tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
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
    public static string SearchInvestigation(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IFNULL( (SELECT IFNULL(GROUP_CONCAT(IF(li.Child_Flag='1',CONCAT('<b>',lm.Name,'</b>'),lm.Name ) ORDER BY li.printOrder SEPARATOR '#' ),'-NA-')  ");
        sb.Append(" FROM  labobservation_investigation li        ");
        sb.Append(" INNER JOIN labobservation_master lm ON lm.LabObservation_ID=li.labObservation_ID  ");
        sb.Append(" WHERE  li.Investigation_Id=inv.Investigation_Id      ");
        sb.Append(" GROUP BY li.Investigation_Id ) ");
        sb.Append(" ,'') ParameterName, PlabId,PrintSeprate,inv.`Name` Investigation,inv.`Investigation_Id`,pld.SampleDefinedPackage FROM `package_labdetail` pld ");
        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
        sb.Append(" WHERE pld.`PlabID`='" + PackageID + "' ORDER BY Priority+1;  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewPackage(string PackageName, string Rate, string TestCode, string ShowInReport, string FromAge, string ToAge, string Gender, string BaseRate)
    {
        string isDuplicatePackageName = StockReports.ExecuteScalar(" SELECT count(*) FROM packagelab_master where name='" + PackageName + "' ");
        if (isDuplicatePackageName != "0")
        {
            return "-2";
        }
        int chkTestCode = Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM f_itemmaster where TestCode='" + TestCode + "' "));
        if (chkTestCode > 0)
        {
            return "-3";
        }
        string PackageID, ItemID = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            PackageLab_Master objPLM = new PackageLab_Master(tranX);
            objPLM.Name = PackageName.Trim();
            objPLM.Description = PackageName.Trim();
            objPLM.Creator_Date = DateTime.Now;
            objPLM.IsActive = 1;
            objPLM.CreaterID = Util.GetString(HttpContext.Current.Session["ID"]);
            PackageID = objPLM.Insert();

            string SubcategoryID = "SELECT SubCategoryID FROM f_subcategorymaster  WHERE CategoryID = 'LSHHI44' ";

            SubcategoryID = StockReports.ExecuteScalar(SubcategoryID);

            ItemMaster objIMaster = new ItemMaster(tranX);
            objIMaster.Type_ID = 0;
            objIMaster.TypeName = PackageName.Trim();
            objIMaster.Type_ID = Util.GetInt(PackageID);
            objIMaster.Inv_ShortName = PackageName.Trim();
            objIMaster.SubCategoryID = Util.GetInt(SubcategoryID);
            objIMaster.IsTrigger = "0";
            objIMaster.IsActive = 1;
            objIMaster.TestCode = TestCode;
            ItemID = objIMaster.Insert().ToString();

            

            string strage = "Update f_itemmaster set BaseRate=" + BaseRate + ",FromAge='" + Util.GetInt(FromAge) + "',ToAge='" + Util.GetInt(ToAge) + "',Gender='" + Gender + "' where ItemID='" + ItemID + "'";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strage.ToString());

            string MaxPriority = StockReports.ExecuteScalar(" SELECT MAX(priority+1) FROM packagelab_master ");
            string strUpdatePackLabMaster = "update packagelab_master set ShowInReport='" + ShowInReport + "',priority='" + MaxPriority + "' where plabid='" + PackageID + "' ";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, strUpdatePackLabMaster);

            tranX.Commit();

            return ItemID + "#" + PackageID;
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetPackageList(string OrderBy, string Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT plm.NAME,plm.ShowInReport,im.BaseRate,im.ItemID,plm.PlabID,im.TestCode,IFNULL(r.rate,'0') Rate,im.IsActive,im.FromAge,IF(im.ToAge=0,70000,im.ToAge)ToAge,im.Gender, ");
        sb.Append(" IFNULL(em.Name,'') CreatedBy,DATE_FORMAT(plm.`Creater_date`,'%d-%b-%Y %I:%i %p') CreatedOn ");
        sb.Append(" FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI44' AND im.`IsActive`=" + Status + "");
        sb.Append(" INNER JOIN packagelab_master plm ON plm.`PlabID`=im.`Type_ID` ");
        sb.Append(" LEFT JOIN employee_master em ON em.`Employee_ID`=plm.`CreaterID`");
        sb.Append(" LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=78 ");
        sb.Append(" ORDER BY priority+1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    private void BindInvListBox()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT inv.`Investigation_Id`,CONCAT(TRIM(inv.`Name`) , ' ~ ' ,inv.`Investigation_Id` ) AS NAME FROM f_itemmaster im ");//
            sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1 ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=im.`Type_ID`  ");
            sb.Append(" ORDER BY TRIM(inv.`Name`) ");
            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                ddlAddInv.DataSource = dt1;
                ddlAddInv.DataTextField = "NAME";
                ddlAddInv.DataValueField = "Investigation_Id";
                ddlAddInv.DataBind();
                ddlAddInv.Items.Insert(0, "");
            }
            sb = new StringBuilder();
            sb.Append(" SELECT PLabID,NAME FROM `packagelab_master` WHERE IsActive=1 ORDER BY NAME;");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            ddAddPackage.DataSource = dt;
            ddAddPackage.DataTextField = "NAME";
            ddAddPackage.DataValueField = "PLabID";
            ddAddPackage.DataBind();
            ddAddPackage.Items.Insert(0, "");
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
        }
    }
}