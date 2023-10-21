using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;


public partial class Design_DocAccount_Doctor_MIS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy"); 
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtFrom.Text = DateTime.Now.AddMonths(-1).ToString("01-MMM-yyyy");
            dtTo.Text = DateTime.DaysInMonth(DateTime.Now.AddMonths(-1).Year, DateTime.Now.AddMonths(-1).Month) + "-" + DateTime.Now.AddMonths(-1).ToString("MMM-yyyy");
            string id = Util.GetInt(Session["Centre"]).ToString();
            lstCentreAccess.DataSource = StockReports.GetDataTable("Select IFNULL(CentreID,'1')as CentreID,Centre from centre_master where IsActive=1 and CentreID='"+id+"' order by Centre;");
            lstCentreAccess.DataTextField = "Centre";
            lstCentreAccess.DataValueField = "CentreID";
            lstCentreAccess.DataBind();

            ddlPanel.DataSource = StockReports.GetDataTable("Select Panel_ID,Company_Name from f_panel_master where IsActive=1 and CentreID='" + id + "' order by company_name;");
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "Panel_ID";
            ddlPanel.DataBind();

            ddlCategory.DataSource = StockReports.GetDataTable(" SELECT ID,NAME FROM `billingcategory_master` WHERE IsActive=1 ORDER BY NAME ");
            ddlCategory.DataTextField = "NAME";
            ddlCategory.DataValueField = "ID";
            ddlCategory.DataBind();

            ddlDepartment.DataSource = StockReports.GetDataTable("SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE CategoryID IN ('LSHHI3','LSHHI44') AND Active=1 AND NAME<>'' ORDER BY NAME;");
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "SubcategoryID";
            ddlDepartment.DataBind();

            lsDoctorSpl.DataSource = StockReports.GetDataTable("SELECT Specialization FROM `doctor_referal` WHERE IFNULL(Specialization,'')<>'' GROUP BY Specialization");
            lsDoctorSpl.DataTextField = "Specialization";
            lsDoctorSpl.DataValueField = "Specialization";
            lsDoctorSpl.DataBind();

            Area_text.DataSource = StockReports.GetDataTable("SELECT ID,AREA FROM `area_master` ORDER BY AREA");
            Area_text.DataTextField = "AREA";
            Area_text.DataValueField = "ID";
            Area_text.DataBind();

            ddlDoctor.DataSource = StockReports.GetDataTable("SELECT Doctor_ID,NAME FROM doctor_referal WHERE Isactive=1 and CentreID='" + id + "' ORDER BY NAME");
            ddlDoctor.DataTextField = "NAME";
            ddlDoctor.DataValueField = "Doctor_ID";
            ddlDoctor.DataBind();
        }
    }

    public static string getSelectData(string str)
    {
        string ids = "";
        if (str != "")
        {
            string[] arr = str.Split(',');
            if (arr.Length != 0)
            {
                for (int i = 0; i < arr.Length; i++)
                {
                    if (ids != string.Empty)
                        ids += ",'" + arr[i].ToString() + "'";
                    else
                        ids = "'" + arr[i].ToString() + "'";
                }
            }
        }
        return ids;
    }

    [WebMethod(EnableSession = true)]
    public static string SearchDoctorSummary(string dtFrom, string dtTo, string CentreID, string PanelID, string ProID, string DoctorID, string CategoryID, string HeadDepartmentID, string DepartmentID, string parm1, string val1, string parm2, string val2, string shareAmount1, string shareAmount2, string Area, string Speclization, string IsReff, string Doct_Mobile)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string txtPatientCount = val1;
            string txtRefAmount = shareAmount2;
            string ddlPatientCount = parm1;
            string ddlRefAmount = shareAmount1;

            StringBuilder sb = new StringBuilder();
            sb.Append("	SELECT  Referal,Doctor_ID,DoctorName Doctor,Mobile Mobile,Phone1 Phone,Phone2 ,'' AREA,dtEntry AddedDate,Doctor_ID1 Doctor_ID1,MasterShare,");
            sb.Append("	SUM(DoctorShare) SharedAmount, ");
            sb.Append(" COUNT(DISTINCT LedgerTransactionNo) AS Total,Specialization FROM (  ");

            sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d-%m-%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
            sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName  AS Item,ua.Rate,ua.itemid,ua.RemoveDocShareItemWise, ");
            sb.Append("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.Doctor_ID Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
            sb.Append(" IF(ua.ReferMasterShare='1','Y','N') MasterShare, ");

            sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
            sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
            sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
            sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
            sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
            sb.Append(" END,2),0) AS DoctorShare  ");

            sb.Append(" FROM utility_accountdata ua ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0  ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID <> 78  AND ds.Panel_ID=ua.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID`  AND ds1.Panel_ID <> 78  AND IFNULL(ds1.ItemID,0)=0   AND ds1.Panel_ID=ua.Panel_ID ");
            sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
            sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
						 
            sb.Append(" WHERE ua.date>='"+Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") +" 00:00:00' AND ua.date<='"+Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") +" 23:59:59' AND ua.ReferMasterShare=1 ");
            if (IsReff.Trim() != "BOTH")
            {
                sb.Append(" and IF(dr.isReferal='1','Y','N') ='" + IsReff + "'");
            }
            if (Doct_Mobile.Trim() != string.Empty)
            {
                sb.Append(" and ua.Mobile LIKE @DoctorName ");
            }
            if (CategoryID != string.Empty)
            {
                sb.Append(" and im.SubCategoryID in (" + CategoryID + ") ");//Category
            }
            if (PanelID != string.Empty)
            {
                sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
            }
            if (CentreID != string.Empty)
            {
                sb.Append(" and ua.CentreID in (" + CentreID + ") ");
            }
            if (DepartmentID != "")
            {
                sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
            }
            if (Speclization != string.Empty)
            {
                sb.Append(" and ua.Specialization in(" + Speclization + ")");
            }
            if (DoctorID != string.Empty)
            {
                sb.Append(" and ua.Doctor_ID in(" + DoctorID + ")");
            }
            //  sb.Append("  GROUP BY LedgertransactionNo,ua.ItemID ");
            
            //    sb.Append(" GROUP BY LedgertransactionNo,ua.ItemID ");
            sb.Append("	 GROUP BY ua.`Test_ID`	)t  ");
            sb.Append(" group by Doctor_ID ");
            if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
            {
                if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                {
                    if (ddlPatientCount == "between")
                    {
                        sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                    }
                }
                else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                {
                    if (ddlRefAmount == "between")
                    {
                        sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                }
                else
                {
                    if (ddlPatientCount == "between")
                    {
                        sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                    }
                    if (ddlRefAmount == "between")
                    {
                        sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                }
            }

            sb.Append(" UNION ALL   ");
            // salek 

            sb.Append("	SELECT  Referal,Doctor_ID,DoctorName Doctor,Mobile Mobile,Phone1 Phone,Phone2 ,'' AREA,dtEntry AddedDate,Doctor_ID1 Doctor_ID1,MasterShare,");
            sb.Append("	SUM(DoctorShare) SharedAmount, ");
            sb.Append(" COUNT(DISTINCT LedgerTransactionNo) AS Total,Specialization FROM (  ");

           
            sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d-%m-%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
            sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName  AS Item,ua.Rate,ua.itemid,ua.RemoveDocShareItemWise, ");
            sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.Doctor_ID Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
            sb.Append(" IF(ua.ReferMasterShare =1,'Y','N') MasterShare, ");

            sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

            sb.Append(" FROM utility_accountdata ua ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID <> 78  AND ds.Panel_ID=ua.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID`  AND ds1.Panel_ID <> 78  AND IFNULL(ds1.ItemID,0)=0   AND ds1.Panel_ID=ua.Panel_ID ");
            sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
            sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
            sb.Append(" WHERE ua.date>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' AND ua.date<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59'  AND ua.ReferMasterShare=0 ");
            if (IsReff.Trim() != "BOTH")
            {
                sb.Append(" and IF(dr.isReferal='1','Y','N') ='" + IsReff + "'");
            }
            if (Doct_Mobile.Trim() != string.Empty)
            {
                sb.Append(" and ua.Mobile LIKE @DoctorName ");
            }
            if (CategoryID != string.Empty)
            {
                sb.Append(" and im.SubCategoryID in (" + CategoryID + ") ");//Category
            }
            if (PanelID != string.Empty)
            {
                sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
            }
            if (CentreID != string.Empty)
            {
                sb.Append(" and ua.CentreID in (" + CentreID + ") ");
            }
            if (DepartmentID != "")
            {
                sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
            }
            if (Speclization != string.Empty)
            {
                sb.Append(" and ua.Specialization in(" + Speclization + ")");
            }
            if (DoctorID != string.Empty)
            {
                sb.Append(" and ua.Doctor_ID in(" + DoctorID + ")");
            }
            //    sb.Append(" GROUP BY LedgertransactionNo,ua.ItemID ");
            sb.Append("	 GROUP BY ua.`Test_ID`	)t  ");
            sb.Append(" group by Doctor_ID ");
            if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
            {
                if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                {
                    if (ddlPatientCount == "between")
                    {
                        sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                    }
                }
                else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                {
                    if (ddlRefAmount == "between")
                    {
                        sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                }
                else
                {
                    if (ddlPatientCount == "between")
                    {
                        sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                    }
                    if (ddlRefAmount == "between")
                    {
                        sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                    else
                    {
                        sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                    }
                }
            }

            sb.Append("   order by Doctor ");

          //   System.IO.File.WriteAllText(@"C:\SearchDoctorSummary_3.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
			//	System.IO.File.WriteAllText(@"C:\SearchDoctorSummary_Json_3.txt", JsonConvert.SerializeObject(dt));
                
				 return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DoctorSummaryReport(string dtFrom, string dtTo, string CentreID, string PanelID, string Printseparate, string DoctorID, string CategoryID, string HeadDepartmentID, string DepartmentID, string parm1, string val1, string parm2, string val2, string shareAmount1, string shareAmount2, string Area, string Speclization, string ReportType, string IsReff, string Doct_Mobile,string ReportFormate)
    {
        try
        {
            return JsonConvert.SerializeObject(new { CentreID = CentreID, PanelID = PanelID, fromDate = dtFrom, toDate = dtTo, DepartmentID = DepartmentID, DoctorID = DoctorID, ReportType = ReportType, PatientCount = parm1, PatientValue = val1, ShareAmtType = shareAmount1, ShareAmtvalue = shareAmount2, CategoryID = CategoryID, Area = Area, Speclization = Speclization, IsReff = IsReff, Doct_Mobile = Doct_Mobile,ReportFormate = ReportFormate, Printseparate = Printseparate });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string showPatientData(string dtFrom, string dtTo, string DoctorID, string _getSelectedPanel, string _getSelectedCentre, string _Category, string _Department)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string _CentreData = getSelectData(_getSelectedCentre);
            string _PanelData = getSelectData(_getSelectedPanel);
            string _BillCategory = getSelectData(_Category);
            string _DepartmentData = getSelectData(_Department);
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT ua.LedgerTransactionID,ua.LedgerTransactionNo AS PatientID,DATE_FORMAT(ua.Date,'%d-%m-%Y') AS dtEntry,Round(ua.FinalAdjustment,2)FinalAdjustment,   ");
            sb.Append("  UPPER(ua.PName) Patient,Round(ua.GrossAmount,2)GrossAmount,Round(ua.DiscountOnTotal,2)DiscountOnTotal,Round(ua.NetAmount,2)NetAmount,  Round((ua.NetAmount-ua.FinalAdjustment),2) AS Balance,   ");
            sb.Append("  ua.ItemName  AS Item,ua.Rate  ");
            sb.Append("  FROM utility_accountdata ua  ");
            sb.Append("  INNER JOIN f_itemmaster im ON im.ItemID=ua.ItemID and ua.DoctorGroup=@DoctorID  ");
            if (_PanelData != "")
            {
                sb.Append("  AND ua.Panel_ID IN (" + _PanelData + ")  ");
            }
            if (_CentreData != "")
            {
                sb.Append("  AND ua.CentreID in (" + _CentreData + ")  ");
            }
            if (_DepartmentData != "")
            {
                sb.Append("	and ua.SubCategoryID  in (" + _DepartmentData + ")  ");
            }
            if (_BillCategory != "")
            {
                sb.Append(" and im.Category in (" + _BillCategory + ") ");
            }
            sb.Append(" and  ua.Date>=@dtFrom and ua.Date<=  @dtTo GROUP BY ua.LedgerTransactionID order by ua.LedgerTransactionID  ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@DoctorID", DoctorID),
                                              new MySqlParameter("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " 00:00:00")),
                                              new MySqlParameter("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " 23:59:59"))).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string showTestData(string LabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ua.LedgerTransactionNo AS PatientID,DATE_FORMAT(ua.Date,'%d-%m-%Y') AS dtEntry,UPPER(ua.PName) Patient,Round(ua.GrossAmount,2)GrossAmount,ua.DiscountOnTotal,");
            sb.Append(" Round(ua.NetAmount,2)NetAmount, Round((ua.NetAmount- ua.FinalAdjustment),2) AS Balance,    ua.ItemName  AS Item,Round(ua.Rate,2)Rate,ua.itemid,ua.RemoveDocShareItemWise,Round(ua.Amount,2)Amount,IFNULL(ds1.`DocSharePer`,0)DocSharePer,ua.ReferMasterShare, ");

            sb.Append("IFNULL(ROUND(sum(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
            sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
            sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
            sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
            sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
            sb.Append(" END),2),0) AS DoctorShare  ");

            sb.Append(" FROM utility_accountdata ua ");

            sb.Append(" LEFT JOIN doctor_referral_share_items ds ON  ds.itemID=ua.`ItemId`  AND ds.Panel_ID=ua.Panel_ID  AND ds.Doctor_ID =0 ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON  ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID AND ds1.Doctor_ID=0 ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0    AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0  ");// sumit  ( AND ds3.itemID = ua.`ItemId`) add
            sb.Append(" WHERE ua.LedgerTransactionID=@LabID AND ua.ReferMasterShare=1 GROUP BY LedgertransactionNo,ua.ItemID ");

            sb.Append(" UNION ALL   ");

            sb.Append(" SELECT ua.LedgerTransactionNo AS PatientID,DATE_FORMAT(ua.Date,'%d-%m-%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
            sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName  AS Item,Round(ua.Rate,2)Rate,ua.itemid,ua.RemoveDocShareItemWise,Round(ua.Amount,2)Amount,IFNULL(ds1.`DocSharePer`,0)DocSharePer, ua.ReferMasterShare,");
            sb.Append(" IFNULL(ROUND(sum(CASE  ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
            sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
            sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
            sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");

            sb.Append(" END),2),0) AS DoctorShare   ");
            sb.Append(" FROM utility_accountdata ua  ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID=ua.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID`AND IFNULL(ds1.ItemID,0)=0   AND ds1.itemID = 0  AND ds1.Panel_ID=ua.Panel_ID ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
            sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");// sumit  ( AND ds3.itemID = ua.`ItemId`) add
            sb.Append(" WHERE ua.LedgerTransactionID=@LabID AND ua.ReferMasterShare=0 GROUP BY LedgertransactionNo,ua.ItemID ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@LabID", LabID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DoctorMerge(string proid, string doc_select)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            bool res = false;
            string str = "";
            string idpro = "";
            string[] arr = proid.Split(',');
            if (arr.Length != 0)
            {
                for (int i = 0; i < arr.Length; i++)
                {
                    if (idpro != string.Empty)
                        idpro += ",'" + arr[i].ToString().Trim() + "'";
                    else
                        idpro = "'" + arr[i].ToString().Trim() + "'";
                }
            }
            else { idpro = proid; }

            if (idpro != "" && doc_select != "")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update doctor_referal set DoctorGroup=@DoctorGroup,IsActive=0 where Doctor_ID in(" + idpro + ")",
                            new MySqlParameter("@DoctorGroup", doc_select));

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update doctor_referal set DoctorGroup=@DoctorGroup,IsActive=1 where Doctor_ID =@Doctor_ID",
                            new MySqlParameter("@DoctorGroup", doc_select),
                            new MySqlParameter("@Doctor_ID", doc_select));

                string docname = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Name FROM doctor_referal WHERE Doctor_ID=@Doctor_ID",
                                                            new MySqlParameter("@Doctor_ID", doc_select)));

                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update utility_accountData set DoctorGroup=@DoctorGroup,DoctorName=@DoctorName,Doctor_ID=@Doctor_ID where  Doctor_ID in(" + idpro + ")",
                            new MySqlParameter("@DoctorGroup", doc_select),
                            new MySqlParameter("@DoctorName", docname),
                            new MySqlParameter("@Doctor_ID", doc_select));
                res = true;
            }
            if (res == true)
            {
                return JsonConvert.SerializeObject(new { status = true, response = "Doctor Merge Successfully" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    

    [WebMethod(EnableSession = true)]
    public static string updateDocshare(string ItemID, string labNo, string Chkvalue)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "Update utility_accountData set RemoveDocShareItemWise=@RemoveDocShareItemWise where LedgerTransactionNo=@LedgerTransactionNo and ItemID=@ItemID";
            using (MySqlCommand m = new MySqlCommand(str, con))
            {
                m.Parameters.AddWithValue("@RemoveDocShareItemWise", Chkvalue == "0" ? 1 : 0);
                m.Parameters.AddWithValue("@LedgerTransactionNo", labNo);
                m.Parameters.AddWithValue("@ItemID", ItemID);
                m.ExecuteNonQuery();
            }
            return JsonConvert.SerializeObject(new { status = true, response = "RemoveDocShareItemWise Updated Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string DoctorRefferal(string DoctorID, string CheckValue)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update doctor_referal set isReferal=@isReferal where Doctor_ID =@Doctor_ID",
                        new MySqlParameter("@isReferal", CheckValue),
                        new MySqlParameter("@Doctor_ID", DoctorID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update utility_accountData set DoctorMasterShareAllow=@DoctorMasterShareAllow where Doctor_ID =@Doctor_ID",
                        new MySqlParameter("@DoctorMasterShareAllow", CheckValue),
                        new MySqlParameter("@Doctor_ID", DoctorID));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "DoctorMasterShareAllow Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.ToString() });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ShareMasterUpdate(string DoctorID, string CheckValue)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update doctor_referal set ReferMasterShare=@ReferMasterShare where Doctor_ID =@Doctor_ID",
                        new MySqlParameter("@ReferMasterShare", CheckValue),
                        new MySqlParameter("@Doctor_ID", DoctorID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update utility_accountData set ReferMasterShare=@ReferMasterShare where Doctor_ID =@Doctor_ID",
                        new MySqlParameter("@ReferMasterShare", CheckValue),
                        new MySqlParameter("@Doctor_ID", DoctorID));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "ReferMasterShare Upated Successfylly" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.ToString() });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}