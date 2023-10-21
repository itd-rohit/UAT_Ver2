using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_CentreMaster : System.Web.UI.Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            bindAllData();
            calPermanentClose.StartDate = DateTime.Now;
            txtPermanentCloseDate.Attributes.Add("readOnly", "readOnly");
            ddlExpectedPaymentDate.Items.Insert(0, new ListItem("Select", "0"));
            for (int i = 1; i < 29; i++)
            {
                ddlExpectedPaymentDate.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
        }
    }

    [WebMethod]
    public static string bindTagBusinessLab()
    {
        using (DataTable dt = AllLoad_Data.getTagBusinessLab())
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT CONCAT(ID,'#',Category)ID,Type1 Text FROM centre_type1master Where IsActive=1 AND id=6 ORDER BY Type1").Tables[0])//AND Category='CC' AND ID!=7 
            {
                if (dt.Rows.Count > 0)
                {
                    ddlType1.DataSource = dt;
                    ddlType1.DataTextField = "Text";
                    ddlType1.DataValueField = "ID";
                    ddlType1.DataBind();
                    
                }
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,NAME FROM `f_designation_msater` ORDER BY NAME ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlContactPersonDesignation.DataSource = dt;
                    ddlContactPersonDesignation.DataTextField = "NAME";
                    ddlContactPersonDesignation.DataValueField = "ID";
                    ddlContactPersonDesignation.DataBind();
                }
                ddlContactPersonDesignation.Items.Insert(0, new ListItem("", "0"));
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

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Type1 FROM  centre_type1master WHERE IsActive=1 AND Type1<>'PUP' ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlSearchCentreType.DataSource = dt;
                    ddlSearchCentreType.DataTextField = "Type1";
                    ddlSearchCentreType.DataValueField = "ID";
                    ddlSearchCentreType.DataBind();
                    ddlSearchCentreType.Items.Insert(0, new ListItem("All", "0"));
                }
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,ReferenceCode,ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID IN (SELECT DISTINCT(ReferenceCode) FROM f_panel_master) ORDER BY Company_Name ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlReferringRate.DataSource = dt;
                    ddlReferringRate.DataTextField = "Company_Name";
                    ddlReferringRate.DataValueField = "Panel_ID";
                    ddlReferringRate.DataBind();

                    ddlReferMrp.DataSource = dt;
                    ddlReferMrp.DataTextField = "Company_Name";
                    ddlReferMrp.DataValueField = "Panel_ID";
                    ddlReferMrp.DataBind();

                    ddlReferShare.DataSource = dt;
                    ddlReferShare.DataTextField = "Company_Name";
                    ddlReferShare.DataValueField = "Panel_ID";
                    ddlReferShare.DataBind();

                    ddlLogisticExpenseRateType.DataSource = dt;
                    ddlLogisticExpenseRateType.DataTextField = "Company_Name";
                    ddlLogisticExpenseRateType.DataValueField = "Panel_ID";
                    ddlLogisticExpenseRateType.DataBind();
                }
                ddlReferringRate.Items.Insert(0, new ListItem("SELF", "0"));
                ddlReferMrp.Items.Insert(0, new ListItem("SELF", "0"));
                ddlReferShare.Items.Insert(0, new ListItem("SELF", "0"));
                ddlLogisticExpenseRateType.Items.Insert(0, new ListItem("SELF", "-1"));
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  RTRIM(LTRIM(fpm.Company_Name)) AS Company_Name,CONCAT(fpm.Panel_ID,'#',cm.type1ID)Panel_ID FROM f_panel_master fpm INNER JOIN centre_master cm ON cm.CentreID=fpm.CentreID WHERE fpm.PanelType='Centre' ORDER BY fpm.Company_Name ").Tables[0])
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
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE Active=1 ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlPanelGroup.DataSource = dt;
                    ddlPanelGroup.DataTextField = "PanelGroup";
                    ddlPanelGroup.DataValueField = "PanelGroupID";
                    ddlPanelGroup.DataBind();
                    ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("PUP"));
                }
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 AND Category='Lab' ORDER BY centre").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlTagBusinessLab.DataSource = dt;
                    ddlTagBusinessLab.DataTextField = "Centre";
                    ddlTagBusinessLab.DataValueField = "CentreID";
                    ddlTagBusinessLab.DataBind();
                }
                ddlTagBusinessLab.Items.Insert(0, new ListItem("Select", "-1"));
            }
            //Expense To
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,fpm.Panel_ID  FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID WHERE fpm.PanelType='Centre' AND cm.IsActive=1 AND cm.type1ID IN(9,10,11) ORDER BY fpm.Company_Name ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlLogisticExpenseTo.DataSource = dt;
                    ddlLogisticExpenseTo.DataTextField = "Company_Name";
                    ddlLogisticExpenseTo.DataValueField = "Panel_ID";
                    ddlLogisticExpenseTo.DataBind();
                }
                ddlLogisticExpenseTo.Items.Insert(0, new ListItem("SELF", "-1"));
            }
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

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT proID,CONCAT(Title,ProName) proName FROM pro_master WHERE isActive=1 ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlProId.DataSource = dt;
                    ddlProId.DataTextField = "proName";
                    ddlProId.DataValueField = "proID";
                    ddlProId.DataBind();
                }
                ddlProId.Items.Insert(0, new ListItem("Select", "0"));
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

    [WebMethod]
    public static string bindCentre(string CentreType)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            sb.Append(" SELECT CentreID,Centre FROM centre_master   ");
            if (CentreType != "0")
                sb.Append(" WHERE type1ID=@CentreType");
            sb.Append(" ORDER BY centre ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreType", CentreType)).Tables[0])

            { 
               if (dt.Rows.Count > 0)
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                else
                    return null;
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

    [WebMethod]
    public static string getCenterData(string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(type1ID,'#',Category)type1ID,UHIDCode,CentreCode,centreid,Centre,Address,isActive,Mobile, Landline, Email  ,");
            sb.Append(" type1,contactperson,contactpersonmobile,zoneID,BusinessUnitID,SubBusinessUnitID,UnitHeadID,contactpersonemail,contactpersondesignation,");
            sb.Append(" OnLineUserName,OnlinePassword,TagProcessingLabID,ReferalRate,coco_foco SavingType,StateID,CityID,LocalityID,BusinessZoneID,Sales_HierarchyID,");
            sb.Append(" IFNULL(IndentType,'')IndentType,Category,CountryID FROM centre_master where CentreID=@CentreID");
		//	System.IO.File.WriteAllText("C:\\CentreMaster.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", CentreID)).Tables[0])

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
    public static string getPanelData(string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(SalesManager,'') SalesManager, InvoiceDisplayAddress,LedgerReportPassword,showBalanceAmt,AAALogo,HideReceiptRate,Panel_ID,");
            sb.Append("PanelGroupID,Payment_Mode,CentreID_Print PrintAtCentre,EmailIDReport,EmailID,ReportDispatchMode,MinBusinessCommitment,BankID,GSTTin,AccountNo,");
            sb.Append(" IFSCCode,CreditLimit,InvoiceTo InvoiceTo,ReferenceCode,ReferenceCodeOPD,InvoiceBillingCycle,InvoiceDisplayNo,InvoiceDisplayName,IsBookingLock,IsPrintingLock, ");
            sb.Append(" MinBalReceive,HideDiscount,PatientPayTo,IsPermanentClose,IF(IsPermanentClose=1,DATE_FORMAT(PermanentCloseDate,'%d-%b-%Y'),'')PermanentCloseDate,");
            sb.Append(" PanelID_MRP,PanelShareID,LabReportLimit,IntimationLimit,IsShowIntimation,TagBusinessLabID,IsLogisticExpense,LogisticExpenseRateType,LogisticExpenseToPanelID, ");
            sb.Append(" SecurityDeposit,RollingAdvance,OwnerName,HideRate,IsOtherLabReferenceNo,chkExpectedPayment,ExpectedPaymentDate,IsBatchCreate,");
            sb.Append(" BarCodePrintedType,SampleCollectionOnReg,BarCodePrintedCentreType,BarCodePrintedHomeColectionType,SetOfBarCode,ShowCollectionCharge,CollectionCharge,ShowDeliveryCharge,DeliveryCharge,CoPaymentApplicable,CoPaymentEditonBooking,ReceiptType,SampleRecollectAfterReject,MonthlyInvoiceType,InvoiceCreatedOn,IsAllowDoctorShare,MrpBill,PANCardName,PANNO,SecurityAmtComments FROM f_panel_master WHERE CentreID=@CentreID AND PanelType='Centre' ");
			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\pnld.txt",sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", CentreID)).Tables[0])

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
    public static string bindCentreType(string Category)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(ID,'#',Category)ID,Type1 FROM centre_type1master WHERE IsActive=1 AND Category=@ID AND ID!=7", new MySqlParameter("@ID", Category)).Tables[0])

                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
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

  [WebMethod(EnableSession = true)]
    public static string SendCentreWelcomeEmail(string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string IsSend = string.Empty;
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT cm.CentreID,cm.Centre,cm.Type1,fpm.OwnerName,fpm.LedgerReportPassword,fpm.CreditLimit,fpm.LabReportLimit,fpm.IntimationLimit,cm.contactpersoneMail,");
            sb.Append(" lo.UserName,lo.Password ");
            sb.Append(" ,(SELECT Subject FROM email_configuration WHERE ID=5) EmailSubject");
            sb.Append("  ,(SELECT Template FROM email_configuration WHERE ID=5) EmailBody");

            sb.Append(" FROM f_panel_master fpm INNER JOIN centre_master cm ON fpm.CentreID=cm.CentreID AND fpm.PanelType='Centre'  ");
            sb.Append(" INNER JOIN f_login lo ON lo.EmployeeID=fpm.Employee_ID AND lo.CentreID=cm.CentreID WHERE  WelcomeMail=0 AND cm.contactpersoneMail<>'' AND cm.CentreID=@CentreID");
            sb.Append(" AND cm.Type1Id IN (SELECT ecc.Type1Id FROM email_configuration_client ecc INNER JOIN email_configuration ec ON ec.ID=ecc.EmailConfigurationID  WHERE ecc.EmailConfigurationID=5 AND ec.IsActive=1 AND ec.isClient=1) ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", CentreID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    string body = dt.Rows[0]["EmailBody"].ToString(); string mainBody = string.Empty;
                    
                    mainBody = body;
                    body = body.Replace("{OWNERNAME}", dt.Rows[0]["OwnerName"].ToString());
                    body = body.Replace("{CENTRENAME}", dt.Rows[0]["Centre"].ToString());
                    body = body.Replace("{CENTRETYPE}", dt.Rows[0]["Type1"].ToString());
                    // body = body.Replace("{LOGINID}", dt.Rows[0]["UserName"].ToString());
                    // body = body.Replace("{LOGINPASSWORD}", dt.Rows[0]["Password"].ToString());
                    // body = body.Replace("{FINANCIALPASSWORD}", dt.Rows[0]["LedgerReportPassword"].ToString());
                    body = body.Replace("{INTIMATIONLIMIT}", dt.Rows[0]["IntimationLimit"].ToString());
                    body = body.Replace("{REPORTINGLIMT}", dt.Rows[0]["LabReportLimit"].ToString());
                    body = body.Replace("{BOOKINGLIMIT}", dt.Rows[0]["CreditLimit"].ToString());


                    ReportEmailClass re = new ReportEmailClass();
                    IsSend = re.SalesEnrolmentEmail(dt.Rows[0]["contactpersoneMail"].ToString(), dt.Rows[0]["EmailSubject"].ToString(), body, "", "");
                }
                else
                    return "-2";
            }
            return IsSend;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string EncryptCentreLog(string ID)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(Util.GetString(ID)));
        return Newtonsoft.Json.JsonConvert.SerializeObject(addEncrypt);
    }

    [WebMethod]
    public static string getInvoiceToDetail(string Panel_ID, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
            if ((Type.Trim() == "B2B" || Type.Trim() == "FC") && Panel_ID.Split('#')[1].Trim() == "9")
            {

                string atr = "SELECT TagBusinessLabID,PanelID_MRP,0 PanelShareID,PanelShareID ReferenceCodeOPD,TagProcessingLabID,InvoiceBillingCycle FROM f_panel_master WHERE Panel_ID=@Panel_ID";
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, atr.ToString(), new MySqlParameter("@Panel_ID", Panel_ID.Split('#')[0])).Tables[0];
            }
            else
            {
                string st = "SELECT TagBusinessLabID,PanelID_MRP,PanelShareID,ReferenceCodeOPD,TagProcessingLabID,InvoiceBillingCycle FROM f_panel_master WHERE Panel_ID=@Panel_ID'";
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, st.ToString(), new MySqlParameter("@Panel_ID", Panel_ID.Split('#')[0])).Tables[0];

            }

            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
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

    [WebMethod]
    public static string getInvoiceTo(string InvoiceTo)
    {

        return StockReports.ExecuteScalar(string.Format("SELECT cm.type1ID FROM Centre_master cm INNER JOIN f_panel_master fpm1 ON cm.CentreID=fpm1.CentreID  AND fpm1.PanelType='Centre' AND fpm1.Panel_ID='{0}' ", InvoiceTo));
    }

    [WebMethod]
    public static string gettype1()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod]
    public static string saveCentre(object Centre, object Panel)
    {
        All_Insert AI = new All_Insert();
        return AI.saveCentre(Centre, Panel);
    }

    [WebMethod]
    public static string UpdateCentre(object Centre, object Panel)
    {
        All_Update AU = new All_Update();
        return AU.UpdateCenterMaster(Centre, Panel);
    }

    [WebMethod]
    public static string getExcelData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(cm.Category='CC','Client','Processing Lab')CentreType,cm.`type1` 'Type',pm.PanelGroup `PatientType`,cm.Centre CentreName,cm.CentreCode SAPCentreCode,cm.`UHIDCode` `UHID Abb. Code`,IF(cm.IsActive=1,'Yes','No')IsActive,cm.`Address`, ");
        sb.Append(" cm.`BusinessZoneName` BusinessZone,cm.`State`,cm.`City`,cm.Zone `CityZone`,cm.`Locality`,cm.Landline,cm.Mobile,cm.Email,cm.ContactPerson,cm.`ContactPersonMobile`, ");
        sb.Append(" cm.ContactPersonEmail,pm.`OwnerName`,cm.`COCO_FOCO`,pm.Payment_Mode `PaymentMode`,pm.RollingAdvance,pm.EmailIdReport,pm.MinBusinessCommitment,pm.`GSTTin` `GSTTIN`, ");
        sb.Append(" pm.InvoiceBillingCycle,pm.`BankName`,pm.`AccountNo`,pm.`IFSCCode`,pmInvoice.`Company_Name` AS InvoiceTo,pm.`InvoiceDisplayName`,pm.InvoiceDisplayNo, ");
        sb.Append(" pm.InvoiceDisplayAddress,pm.MinBalReceive,cm.TagProcessingLab,pm.TagBusinessLab,pm.`SecurityDeposit`,pm.IntimationLimit,pm.LabReportLimit `ReportingLimit`, ");
        sb.Append(" pm.`CreditLimit` BookingLimit,pm.IsShowIntimation ShowIntimation,pm.`IsPrintingLock`,pm.`IsBookingLock`,pm.`HideRate` `HideAmountInBooking`,pm.showBalanceAmt `ShowBalanceAmount`,pm.HideReceiptRate, ");
        sb.Append(" pmMRP.`Company_Name` MRP,pmRate.Company_Name  AS `Patient Net Rate`,IF(cm.Type1='CC',pmClient.`Company_Name`,'') AS ClientRate");
        sb.Append(" FROM centre_master cm   ");
        sb.Append(" INNER JOIN f_panel_master pm ON pm.Centreid=cm.centreid  ");
        sb.Append(" INNER JOIN f_panel_master pmRate ON pmRate.Panel_id=pm.`ReferenceCodeOPD`  ");
        sb.Append(" LEFT JOIN f_panel_master pmInvoice ON pm.`InvoiceTo`=pminvoice.Panel_id ");
        sb.Append(" LEFT JOIN f_panel_master pmMRP ON pm.PanelID_MRP=pmMRP.Panel_id ");
        sb.Append(" LEFT JOIN f_panel_master pmClient ON pm.PanelShareId=pmClient.Panel_id ");
        sb.Append(" WHERE  pm.`PanelType`='Centre'   ");
        return Util.getJson(new { Query = sb.ToString(), ReportName = "CentreMasterData", ReportPath = AllLoad_Data.getHostDetail("Report") });
    }

    [WebMethod]
    public static string GetBalanceAmt(string CentreType, int ID)
    {
        return Util.GetString(StockReports.ExecuteScalar(string.Format("CALL get_balance_amount('{0}','{1}') ", CentreType, ID)));
    }

    [WebMethod]
    public static string getCentreType(string InvoiceTo)
    {


        return StockReports.ExecuteScalar(string.Format("SELECT cm.type1ID FROM Centre_master cm INNER JOIN f_panel_master fpm1 ON cm.CentreID=fpm1.CentreID  AND fpm1.PanelType='Centre' AND fpm1.Panel_ID='{0}' ", InvoiceTo));
    }
    [WebMethod]
    public static string bindBusinessZone(string CountryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master WHERE IsActive=1 and CountryId=@CountryId ORDER BY BusinessZoneName ",
                new MySqlParameter("@CountryId", CountryId)).Tables[0])
                return Util.getJson(dt);
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
}