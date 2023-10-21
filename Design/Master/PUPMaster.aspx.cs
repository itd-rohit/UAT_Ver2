using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_PUPMaster : System.Web.UI.Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            bindAllData();
            bindTagProcessingLab();
            txtcreationdt.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindAllCentre(ddlPrintAtCentre, null, null, "All");
            if (Request.QueryString["EnrolID"] != null)
            {
                lblEnrollID.Text = Common.Decrypt(Request.QueryString["EnrolID"]);
                bindEnrolment();
            }
            else
                lblEnrollID.Text = string.Empty;
        }
    }

    private void bindEnrolment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Company_Name,Add1,Phone,Mobile,Payment_Mode,CentreID_Print,EmailID,EmailIDReport, ");
            sb.Append(" ReportDispatchMode,MinBusinessCommitment,GSTTin,InvoiceBillingCycle,BankID,AccountNo,IFSCCode,PanelUserID,PanelPassword, ");
            sb.Append(" TagProcessingLabID,CreditLimit,InvoiceTo,MinBalReceive,ReferenceCodeOPD,MRPPercentage,AAALogo,OnLineLoginRequired ");
            sb.AppendFormat("  FROM sales_enrolment_master WHERE ID=@lblEnrollID AND ISEnroll=0");
            sb.Append(" ");           
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@lblEnrollID", lblEnrollID.Text)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                txtPUPName.Text = dt.Rows[0]["Company_Name"].ToString();
                txtAddress.Text = dt.Rows[0]["Add1"].ToString();
                txtLandline.Text = dt.Rows[0]["Phone"].ToString();
                txtMobile.Text = dt.Rows[0]["Mobile"].ToString();
                ddlPaymentMode.SelectedIndex = ddlPaymentMode.Items.IndexOf(ddlPaymentMode.Items.FindByValue(dt.Rows[0]["Payment_Mode"].ToString()));
                ddlPrintAtCentre.SelectedIndex = ddlPrintAtCentre.Items.IndexOf(ddlPrintAtCentre.Items.FindByValue(dt.Rows[0]["CentreID_Print"].ToString()));
                txtEmailInvoice.Text = dt.Rows[0]["EmailID"].ToString();
                txtEmailReport.Text = dt.Rows[0]["EmailIDReport"].ToString();
                ddlReportDispatchMode.SelectedIndex = ddlReportDispatchMode.Items.IndexOf(ddlReportDispatchMode.Items.FindByValue(dt.Rows[0]["ReportDispatchMode"].ToString()));
                txtMinBusinessComm.Text = dt.Rows[0]["MinBusinessCommitment"].ToString();
                txtMinBusinessComm.Attributes.Add("disabled", "disabled");
                txtGSTTIN.Text = dt.Rows[0]["GSTTin"].ToString();
                ddlInvoiceBillingCycle.SelectedIndex = ddlInvoiceBillingCycle.Items.IndexOf(ddlInvoiceBillingCycle.Items.FindByValue(dt.Rows[0]["InvoiceBillingCycle"].ToString()));
                ddlBankName.SelectedIndex = ddlBankName.Items.IndexOf(ddlBankName.Items.FindByValue(dt.Rows[0]["BankID"].ToString()));
                txtAccountNo.Text = dt.Rows[0]["AccountNo"].ToString();
                txtIFSCCode.Text = dt.Rows[0]["IFSCCode"].ToString();
                txtOnlineUserName.Text = dt.Rows[0]["PanelUserID"].ToString();
                // txtOnlineUserName.Attributes.Add("disabled", "disabled");
                txtOnlinePassword.Text = dt.Rows[0]["PanelPassword"].ToString();
                txtOnlinePassword.Attributes.Add("disabled", "disabled");
                ddlTagProcessingLab.SelectedIndex = ddlTagProcessingLab.Items.IndexOf(ddlTagProcessingLab.Items.FindByValue(dt.Rows[0]["TagProcessingLabID"].ToString()));
                ddlTagProcessingLab.Attributes.Add("disabled", "disabled");
                txtCreditLimit.Text = dt.Rows[0]["CreditLimit"].ToString();
                ddlInvoiceTo.SelectedIndex = ddlInvoiceTo.Items.IndexOf(ddlInvoiceTo.Items.FindByValue(dt.Rows[0]["InvoiceTo"].ToString()));
                //  ddlInvoiceTo.Attributes.Add("disabled", "disabled");
                txtMinCash.Text = dt.Rows[0]["MinBalReceive"].ToString();
                ddlReferringRate.SelectedIndex = ddlInvoiceTo.Items.IndexOf(ddlInvoiceTo.Items.FindByValue(dt.Rows[0]["ReferenceCodeOPD"].ToString()));
                // ddlReferringRate.Attributes.Add("disabled", "disabled");
                //  ddlPrintAtCentre.Attributes.Add("disabled", "disabled");
                txtMRPPercentage.Text = dt.Rows[0]["MRPPercentage"].ToString();
                txtMRPPercentage.Attributes.Add("disabled", "disabled");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE Active=1 ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlPanelGroup.DataSource = dt;
                    ddlPanelGroup.DataTextField = "PanelGroup";
                    ddlPanelGroup.DataValueField = "PanelGroupID";
                    ddlPanelGroup.DataBind();
                    //ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("Walk-In"));
                   // ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("CC"));
                    //ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("B2B"));
                    ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("FC"));
                  //  ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("HLM"));
                }
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT Bank_ID,BankName FROM `f_bank_master` ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlBankName.DataSource = dt;
                    ddlBankName.DataTextField = "BankName";
                    ddlBankName.DataValueField = "Bank_ID";
                    ddlBankName.DataBind();
                }
                ddlBankName.Items.Insert(0, new ListItem("", "0"));
            }

            using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT proID,CONCAT(Title,ProName) proName FROM pro_master WHERE isActive=1").Tables[0])
            {
                if (dt1.Rows.Count > 0)
                {
                    ddlPro.DataSource = dt1;
                    ddlPro.DataTextField = "proName";
                    ddlPro.DataValueField = "proID";
                    ddlPro.DataBind();

                    ddlPro.Items.Insert(0, new ListItem("NA", "0"));
                }
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  CONCAT(Company_Name,' = ',Panel_ID) AS Company_Name,Panel_ID,ReferenceCode,ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID IN (SELECT DISTINCT(ReferenceCode) FROM f_panel_master) ORDER BY Company_Name ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlReferringRate.DataSource = dt;
                    ddlReferringRate.DataTextField = "Company_Name";
                    ddlReferringRate.DataValueField = "Panel_ID";
                    ddlReferringRate.DataBind();
                }
                ddlReferringRate.Items.Insert(0, new ListItem("SELF", "0"));
            }

            using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(Company_Name,' = ',Panel_ID) AS Company_Name,Panel_ID FROM f_panel_master ORDER BY Company_Name "))
            {
                if (dt.Rows.Count > 0)
                {
                    ddlInvoiceTo.DataSource = dt;
                    ddlInvoiceTo.DataTextField = "Company_Name";
                    ddlInvoiceTo.DataValueField = "Panel_ID";
                    ddlInvoiceTo.DataBind();
                }
                ddlInvoiceTo.Items.Insert(0, new ListItem("SELF", "0"));
            }
            //using (DataTable dt = StockReports.GetDataTable("SELECT   CentreID,Centre FROM Centre_master where Type1='HUB' ORDER BY Centre "))
            //{
            //    if (dt.Rows.Count > 0)
            //    {
            //        ddlHUB.DataSource = dt;
            //        ddlHUB.DataTextField = "Centre";
            //        ddlHUB.DataValueField = "CentreID";
            //        ddlHUB.DataBind();
            //    }
            //    ddlHUB.Items.Insert(0, new ListItem("", "0"));
            //}
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT * FROM salesteam_master ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlSalesManager.DataSource = dt;
                    ddlSalesManager.DataTextField = "PRONAME";
                    ddlSalesManager.DataValueField = "PROID";
                    ddlSalesManager.DataBind();
                }
                ddlSalesManager.Items.Insert(0, new ListItem("Select", "0"));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindTagProcessingLab()
    {
         using (DataTable dt = StockReports.GetDataTable("SELECT  cm.`CentreID`,Concat(cm.`Centre`,' [',cm.`CentreID`,']') Centre FROM centre_master cm  WHERE cm.IsActive=1 AND (Category='Lab' or Category='HUB') ORDER BY centre;"))
        {
            if (dt.Rows.Count > 0)
            {
                ddlTagProcessingLab.DataSource = dt;
                ddlTagProcessingLab.DataTextField = "Centre";
                ddlTagProcessingLab.DataValueField = "CentreID";
                ddlTagProcessingLab.DataBind();
            }
        }
         using (DataTable dt1 = StockReports.GetDataTable("SELECT  cm.`CentreID`,Concat(cm.`Centre`,' [',cm.`CentreID`,']') Centre FROM centre_master cm  WHERE cm.IsActive=1 AND (Category='Lab' or Category='HUB') ORDER BY centre;"))
        {
            if (dt1.Rows.Count > 0)
            {
                ddlTagBusinessLab.DataSource = dt1;
                ddlTagBusinessLab.DataTextField = "Centre";
                ddlTagBusinessLab.DataValueField = "CentreID";
                ddlTagBusinessLab.DataBind();
            }
         }
            ddlTagProcessingLab.Items.Insert(0, new ListItem("Select", "-1"));
            ddlTagBusinessLab.Items.Insert(0, new ListItem("Select", "-1"));
        
    }

    [WebMethod]
    public static string gettype1()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod]
    public static string savePUP(object Panel, int DocumentID)
    {
        All_Insert AI = new All_Insert();
        return AI.savePUP(Panel,DocumentID);
    }

    [WebMethod]
    public static string UpdatePUP(object Panel, int DocumentID)
    {
        All_Update AU = new All_Update();
        return AU.UpdatePUP(Panel,DocumentID);
    }

    [WebMethod]
    public static string getPanelData(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT AllowSharing,SecurityRemark,SecurityAmt,showBalanceAmt,panno,PANCardName,ReceiptType,PanelCreationDt,RollingAdvance,employee_id,LabReportLimit,IsShowIntimation,IntimationLimit,SalesManagerID,TagHUBID,AAALogo,HideReceiptRate,Panel_Code,Panel_ID,Company_Name,Add1,Phone,Mobile,PanelGroupID,COCO_FOCO SavingType,TagProcessingLabID,PROID,");
            sb.Append(" InvoiceBillingCycle,ShowAmtInBooking,ReportInterpretation,IsActive,HideDiscount,Payment_Mode,CentreID_Print PrintAtCentre,");
            sb.Append(" EmailIDReport,IsBookingLock,EmailID,ReportDispatchMode,MinBusinessCommitment,BankID,GSTTin,AccountNo,IFSCCode,CreditLimit,");
            sb.Append(" InvoiceTo,ReferenceCode,ReferenceCodeOPD,PanelUserID,PanelPassword,MinBalReceive,InvoiceDisplayName,InvoiceDisplayNo,IsPrintingLock,");
            sb.Append(" HideRate,TagBusinessLabID,IsOtherLabReferenceNo,BarCodePrintedType,SampleCollectionOnReg,BarCodePrintedCentreType,BarCodePrintedHomeColectionType,SetOfBarCode,SampleRecollectAfterReject,CountryID, ");
            sb.AppendFormat(" StateID,CityID,BusinessZoneID,LocalityID,ZoneId,IsAllowDoctorShare,InvoiceCreatedOn,MonthlyInvoiceType");
            sb.AppendFormat(" FROM f_panel_master WHERE Panel_ID=@PanelId");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PanelId", PanelID)).Tables[0])

                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
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

    [WebMethod]
    public static string bindPUP()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("  SELECT Concat(Company_Name,' = ',Panel_Code) Company_Name,Panel_ID FROM f_panel_master ORDER BY Company_Name"));
    }

    [WebMethod]
    public static string getExcelData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT * FROM f_panel_master WHERE IsActive=1 AND PanelType <> 'Centre' ORDER BY Company_Name ");


        return Util.getJson(new { Query = sb.ToString(), ReportName = "PUPMasterData", ReportPath = AllLoad_Data.getHostDetail("Report") });
    }

    [WebMethod]
    public static string manualEncryptDocument(string fileName, string filePath)
    {
        return JsonConvert.SerializeObject(new { status = "true", fileName = Common.Encrypt(fileName), filePath = Common.Encrypt(filePath), type = Common.Encrypt("1") });
    }

    [WebMethod(EnableSession = true)]
    public static string SaveEmployee(object Panel)
    {
         List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(Panel);
        string rsltt = string.Empty;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction MySqltrans = con.BeginTransaction();
        string Employee_id = string.Empty;
        try
        {
            string CentreID = StockReports.ExecuteScalar("select Group_Concat(distinct CentreID) from centre_Panel where PanelId=" + panelMasterData[0].Panel_ID + " and Isactive=1 order by Id");
            if (CentreID == "" || panelMasterData[0].PanelUserID == "" || panelMasterData[0].PanelPassword == "")
            {
                MySqltrans.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "This Panel not have Centre Access,Panel LoginID,Password !!" });
            }
            string roleID = "183"; //PCC
            int DesgID = 59;
            string Desg = "PCC";
            if (panelMasterData[0].Panel_ID != panelMasterData[0].InvoiceTo) //SubPCC
            {
                //roleID = "";
                DesgID = 60;
                Desg = "SUB PCC";
            }
            MSTEmployee objMSTEmployee = new MSTEmployee(MySqltrans);
            objMSTEmployee.Title ="Mr.";
            objMSTEmployee.Name = panelMasterData[0].Company_Name;
            objMSTEmployee.House_No = ""; // panelMasterData[0].Add1;
            objMSTEmployee.Street_Name = "";
            objMSTEmployee.Locality = "";
            objMSTEmployee.City = "";
            objMSTEmployee.PinCode = 0;
            objMSTEmployee.PHouse_No = "";
            objMSTEmployee.PStreet_Name = "";
            objMSTEmployee.PLocality = "";
            objMSTEmployee.PCity = "";
            objMSTEmployee.PPinCode = 0;
            objMSTEmployee.FatherName = "";
            objMSTEmployee.MotherName = "";
            objMSTEmployee.ESI_No = "";
            objMSTEmployee.EPF_No = "";
            objMSTEmployee.PAN_No = "";
            objMSTEmployee.Passport_No = "";
            //objMSTEmployee.DOB = Util.GetDateTime(DOB.Trim());
            objMSTEmployee.Qualification ="";
            objMSTEmployee.Email =  panelMasterData[0].EmailID.Trim();
            objMSTEmployee.AllowSharing = "0";
            objMSTEmployee.Phone ="";
            objMSTEmployee.Mobile = panelMasterData[0].Mobile.Trim();
            objMSTEmployee.Blood_Group = "";
          //  objMSTEmployee.StartDate = Util.GetDateTime(StartDate.Trim());
            objMSTEmployee.Designation = Desg;
            objMSTEmployee.DesignationID = DesgID; ;
            objMSTEmployee.CreatedByID = Util.GetInt(UserInfo.ID);
            objMSTEmployee.ApproveSpecialRate = 0;
            objMSTEmployee.AmrValueAccess = 0;
            objMSTEmployee.ValidateLogin = 1;
            objMSTEmployee.IsMobileAccess = 0;
            objMSTEmployee.PROID = 0;
            objMSTEmployee.IsHideRate = 0;
            objMSTEmployee.IsEditMacReading =0;
            objMSTEmployee.IsSampleLogisticReject = 0;
            objMSTEmployee.CreatedBy = UserInfo.LoginName;
            objMSTEmployee.GlobalReportAccess = 0;
            objMSTEmployee.Employee_ID = Util.GetString(panelMasterData[0].EmployeeID);
            if (panelMasterData[0].EmployeeID != 0)
            {
                objMSTEmployee.Update();
                Employee_id = Util.GetString(panelMasterData[0].EmployeeID);
            }
            else
                Employee_id = objMSTEmployee.Insert();

           
          
            string rsltdata = SaveLogin(MySqltrans, Employee_id, panelMasterData[0].PanelUserID, panelMasterData[0].PanelPassword, panelMasterData[0].PanelPassword, CentreID, roleID, "1", Util.GetInt(CentreID.Split(',')[0]), Util.GetInt(roleID));
            if (rsltdata.IndexOf("Record Saved")>0)
            {
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "Update f_panel_master set employee_id='" + Employee_id + "' where panel_ID='" + panelMasterData[0].Panel_ID + "'");
            }
            else
            {
                MySqltrans.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
            }
            MySqltrans.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Panel Login created successfully" });
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Not Saved" });
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SaveLogin(MySqlTransaction MySqltrans, string EmployeeID, string Username, string Pwd, string ConfirmPwd, string Centre, string Role, string Login, int defaultCentreID, int defaultRoleID)
    {
        int sts = 0;
        int rslt = 0;
        int centreID;
        int roleID;

        int isTPwd = 0;
        string TranPwd = string.Empty;
      

        MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, "DELETE FROM f_login WHERE EmployeeID=@EmployeeID", new MySqlParameter("@EmployeeID", EmployeeID));

        int isDefault = 0;

        string[] cid = Centre.Split(',');
        string[] rid = Role.Split(',');
        int lenCentreID = Util.GetInt(cid.Length);
        int lenRoleID = Util.GetInt(rid.Length);

        for (int i = 0; i < lenCentreID; i++)
        {
            centreID = Convert.ToInt32(cid[i]);
            for (int j = 0; j < lenRoleID; j++)
            {
                roleID = Convert.ToInt32(rid[j]);
                if (centreID == defaultCentreID && roleID == defaultRoleID)
                    isDefault = 1;
                else
                    isDefault = 0;
                string str1 = "insert into f_login(RoleID,EmployeeID,Username,Password,CentreId,IsTPassword,TPassword,lastpass_dt,isDefault,CreatedByID,CreatedBy,Createdon)" +
                            "values(@roleID,@EmployeeID,@Username,@Pwd,@centreID,@isTPwd,@TranPwd,now(),@isDefault,@CreatedByID,@CreatedBy,NOW())";
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, str1, new MySqlParameter("@roleID", roleID),
                    new MySqlParameter("@EmployeeID", EmployeeID), new MySqlParameter("@Username", Username),
                    new MySqlParameter("@Pwd", Pwd), new MySqlParameter("@centreID", centreID),
                    new MySqlParameter("@isTPwd", isTPwd), new MySqlParameter("@TranPwd", TranPwd),
                    new MySqlParameter("@isDefault", isDefault),
                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                    new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            }
            sts = 1;
        }
        if (sts == 1)
        {
            rslt = 1;
            return JsonConvert.SerializeObject("Record Saved");
        }
        return JsonConvert.SerializeObject("Not Saved");
    }
}