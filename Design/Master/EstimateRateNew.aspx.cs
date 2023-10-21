using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Lab_EstimateRate : System.Web.UI.Page
{
    public string AccessType = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        
        if (!IsPostBack)
        {


            if (!string.IsNullOrEmpty(Util.GetString(Session["RoleID"])) && Util.GetString(Session["RoleID"]) == "212")
            {
                AccessType = "";
            }
            else if (!string.IsNullOrEmpty(Util.GetString(Session["OnlinePanelID"])))
            {
                Response.AddHeader("Cache-Control", "no-store");

                ((DropDownList)Master.FindControl("ddlcentrebyuser")).Visible = false;
                ((TextBox)Master.FindControl("txtDynamicSearchMaster")).Visible = false;
                ((HtmlControl)Master.FindControl("spnSelectCentre")).Visible = false;
                ((HtmlControl)Master.FindControl("spnSampleTracker")).Visible = false;
                ((HtmlControl)Master.FindControl("feedback")).Visible = false;

                AccessType = "PUP";
            }
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindPanel(string BusinessZoneID, string StateID, string CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',if(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID),'#',pn.Panelid_mrp)Panel_ID,pn.`Company_Name`  ");
            sb.Append("   FROM Centre_Panel cp   ");
            sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id  ");
            sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId`  ");
            sb.Append("  AND cm.`BusinessZoneID` =@BusinessZoneID ");
            if (StateID.Trim() != "0")
                sb.Append("   AND cm.`StateID`=@StateID  ");
            sb.Append(" AND cp.isActive=1 AND pn.isActive=1  ");
            sb.Append(" AND CURRENT_DATE() >= IF(cp.IsCamp=1,cp.`FromCampValidityDate`,CURRENT_DATE())  ");
            sb.Append("  AND CURRENT_DATE() <= IF(cp.IsCamp=1,cp.`ToCampValidityDate`,CURRENT_DATE()) ");
            sb.Append("  ORDER BY cm.DefaultPanelId  ");//ORDER BY pn.company_name
			//System.IO.File.WriteAllText (@"C:\\avi.txt", BusinessZoneID);
			//System.IO.File.WriteAllText (@"C:\\avi1.txt", StateID);
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                              new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                              new MySqlParameter("@StateID", StateID)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally
        {
            con.Close();
            con.Dispose();
        }


    }




    [WebMethod(EnableSession = true)]
    public static string bindDefaultPanel()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT cm.CountryID, cm.stateid,cm.BusinessZoneID,CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',if(pn.paneltype='PUP',pn.TagprocessingLabID,pn.CentreID),'#',pn.Panelid_mrp) Panel_ID ");
            sb.Append("   FROM Centre_Panel cp   ");
            sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id  ");
            sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId`  ");
            sb.Append("  AND cm.centreid =@CentreID ");
            sb.Append(" AND cp.isActive=1 AND pn.isActive=1  ");
            sb.Append(" AND CURRENT_DATE() >= IF(cp.IsCamp=1,cp.`FromCampValidityDate`,CURRENT_DATE())  ");
            sb.Append("  AND CURRENT_DATE() <= IF(cp.IsCamp=1,cp.`ToCampValidityDate`,CURRENT_DATE()) ");
            sb.Append("  ORDER BY cm.DefaultPanelId  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                              new MySqlParameter("@CentreID",UserInfo.Centre)
                              ).Tables[0];
            return  Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return  Util.GetString(ex.GetBaseException());
        }
        finally
        {
            con.Close();
            con.Dispose();
        }


    }



    [WebMethod(EnableSession = true)]
    public static string SaveNewEstimate(List<Patient_Master> PM, List<Patient_Lab_InvestigationOPD> PLO)
    {
		int centre_id=UserInfo.Centre;
		
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int EstimateID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select get_Tran_id('Estimate') "));
            for (int i = 0; i < PLO.Count; i++)
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO estimate_billDetail(EstimateID,ItemId,ItemName,DiscAmt,Title,PName,Mobile,Gender,Address,Age,AgeYear,AgeMonth,AgeDays,DOB,Panel_ID,Rate,Amount,CreatedDate,Email,CreatedByID,CreatedBy,IsDOBActual,TotalAgeInDays,SubCategoryID,IsPackage,Centreid) ");
                sb.Append(" VALUES(@EstimateID,@ItemId,@ItemName,@DiscountAmt,@Title,@PName,@Mobile,@Gender,@Address,@Age,@AgeYear,@AgeMonth,@AgeDays,@DOB,@Panel_ID,@Rate,@Amount,NOW(),@Email,@CreatedByID,@CreatedBy,@IsDOBActual,@TotalAgeInDays,@SubCategoryID,@IsPackage,@Centreid)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@EstimateID", EstimateID),
                                             new MySqlParameter("@ItemId", PLO[i].ItemId),
                                             new MySqlParameter("@ItemName", PLO[i].ItemName),
                                             new MySqlParameter("@DiscountAmt", PLO[i].DiscountAmt),
                                             new MySqlParameter("@Title", PM[0].Title),
                                             new MySqlParameter("@PName", PM[0].PName),
                                             new MySqlParameter("@Mobile", PM[0].Mobile),
                                             new MySqlParameter("@Gender", PM[0].Gender),
                                             new MySqlParameter("@Address", PM[0].House_No),
                                             new MySqlParameter("@Age", PM[0].Age),
                                             new MySqlParameter("@AgeYear", PM[0].AgeYear),
                                             new MySqlParameter("@AgeMonth", PM[0].AgeMonth),
                                             new MySqlParameter("@AgeDays", PM[0].AgeDays),
                                             new MySqlParameter("@DOB", PM[0].DOB),
                                             new MySqlParameter("@Panel_ID", PM[0].CentreID),
                                             new MySqlParameter("@Rate", PLO[i].Rate),
                                             new MySqlParameter("@Amount", PLO[i].Amount),
                                             new MySqlParameter("@Email", PM[0].Email),
                                             new MySqlParameter("@CreatedByID", UserInfo.ID),
                                             new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                             new MySqlParameter("@IsDOBActual", PM[0].IsDOBActual),
                                             new MySqlParameter("@TotalAgeInDays", PM[0].TotalAgeInDays),
                                             new MySqlParameter("@SubCategoryID", PLO[i].SubCategoryID),
                                             new MySqlParameter("@IsPackage", PLO[i].IsPackage),
											 new MySqlParameter("@Centreid", centre_id));



            }
            int LastID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));


            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,plo.`ItemName` FROM `estimate_billDetail` plo ");
            sb1.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=plo.`ItemID` ");
            sb1.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb1.Append(" WHERE AllowDuplicateBooking=0 AND `EstimateID`>0 AND  plo.`EstimateID`=@EstimateID ");
            sb1.Append(" GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1  ");
            using (DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb1.ToString(),
               new MySqlParameter("@EstimateID", EstimateID)).Tables[0])
            {
                if (dtDuplicate.Rows.Count > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtDuplicate.Rows[0]["Name"].ToString(), " Found duplicate in ", dtDuplicate.Rows[0]["ItemName"].ToString()) });
                }
            }

            tnx.Commit();

             return JsonConvert.SerializeObject(new { Status = "true", response = "Record Saved Successfully", responseDetail = (Util.GetString(EstimateID)) });
          //  return JsonConvert.SerializeObject(new { Status = "true", response = "Record Saved Successfully", responseDetail = Common.EncryptRijndael(Util.GetString(EstimateID)) });


        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { Status = false, response = "Error", responseDetail = string.Empty });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod]
    public static string ExcelReport(string searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] SearchValue = searchdata.Split('$');

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT '' Srno,CONCAT(em.`Title`,em.`PName`) PatientName,pm.`Company_Name` Panel,em.`Mobile`,em.`Gender`,em.`Address`,em.`Age`,em.`DOB`,em.`GrossAmt`,em.`DiscountAmt`,em.`NetAmt`,em.`ItemName` TestDetails ");
            sb.Append(" FROM `estimatemaster` em INNER JOIN f_panel_master pm ON pm.panel_id=em.`Panel_ID` ");
            sb.Append("    where em.CreaterDateTime>=@FromCreaterDateTime ");
            sb.Append("    AND em.CreaterDateTime<=@ToCreaterDateTime ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@FromCreaterDateTime", string.Concat(Util.GetDateTime(SearchValue[0].ToString()).ToString("yyyy-MM-dd"), " 00:00:00")),
                        new MySqlParameter("@ToCreaterDateTime", Util.GetDateTime(SearchValue[1].ToString()).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0];

            if (dt.Rows.Count > 0)
            {
                int i = 1;
                foreach (DataRow dr in dt.Rows)
                    dr["Srno"] = i++;


                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Estimate Patient '" + (i - 1) + " Entry Found'";
                return "true";
            }
            return "false";
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }




    



}