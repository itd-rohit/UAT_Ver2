using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_RateTypeMaster : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindAllCentre(ddlPrintAtCentre, null, null, "All");
            AllLoad_Data.bindBank(ddlBankName);
            ddlBankName.Items.Insert(0, new ListItem("", "0"));

            bindPanelGroup();
        }
        // ddlType.Attributes.Add("disabled", "disabled");
    }

    private void bindPanelGroup()
    {
        DataTable dt = AllLoad_Data.loadPatientType();
        if (dt.Rows.Count > 0)
        {
            ddlPanelGroup.DataSource = dt;
            ddlPanelGroup.DataTextField = "PanelGroup";
            ddlPanelGroup.DataValueField = "PanelGroupID";
            ddlPanelGroup.DataBind();
            ddlPanelGroup.Items.Remove(ddlPanelGroup.Items.FindByText("PUP"));
        }
    }

    [WebMethod]
    public static string bindCentre(int typeID)
    {
        DataTable dt = StockReports.GetDataTable(string.Format("SELECT CONCAT(cm.Centre,' = ',cm.CentreID)Centre,CONCAT(cm.CentreID,'#',pm.Panel_ID)CentreID FROM centre_master cm INNER JOIN f_panel_master pm ON cm.CentreID=pm.CentreID WHERE cm.IsActive=1 Group by cm.CentreID Order By cm.Centre; ", typeID)); // AND pm.COCO_FOCO='FOCO'
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod]
    public static string saveRateType(object RateType)
    {
        List<PanelMaster> panelMasterData = new JavaScriptSerializer().ConvertToType<List<PanelMaster>>(RateType);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, string.Format(" SELECT count(*) from f_panel_master where Company_Name = '{0}'", panelMasterData[0].Company_Name)));
            if (count > 0)
            {
                return "2";
            }

            PanelMaster objPanel = new PanelMaster(tnx) { Company_Name = panelMasterData[0].Company_Name.ToUpper(), CentreID = panelMasterData[0].CentreID, PanelGroup = panelMasterData[0].PanelGroup, PanelGroupID = panelMasterData[0].PanelGroupID, IsActive = Util.GetInt(1), Payment_Mode = panelMasterData[0].Payment_Mode, PrintAtCentre = panelMasterData[0].PrintAtCentre, PatientPayTo = panelMasterData[0].PatientPayTo, EmailID = panelMasterData[0].EmailID, EmailIDReport = panelMasterData[0].EmailIDReport, ReportDispatchMode = panelMasterData[0].ReportDispatchMode, MinBusinessCommitment = panelMasterData[0].MinBusinessCommitment, GSTTin = panelMasterData[0].GSTTin, InvoiceBillingCycle = panelMasterData[0].InvoiceBillingCycle, BankName = panelMasterData[0].BankName, BankID = panelMasterData[0].BankID, AccountNo = panelMasterData[0].AccountNo, IFSCCode = panelMasterData[0].IFSCCode, PanelUserID = panelMasterData[0].PanelUserID, PanelPassword = panelMasterData[0].PanelPassword, TagProcessingLab = panelMasterData[0].TagProcessingLab, TagProcessingLabID = panelMasterData[0].TagProcessingLabID };

            if (panelMasterData[0].CreditLimit != string.Empty)
            {
                objPanel.CreditLimit = panelMasterData[0].CreditLimit;
            }
            else
            {
                objPanel.CreditLimit = "0";
            }
            if (panelMasterData[0].ReferenceCodeOPD != "0")
            {
                objPanel.ReferenceCodeOPD = panelMasterData[0].ReferenceCodeOPD;
            }
            else
            {
                objPanel.ReferenceCodeOPD = "0";
            }
            if (panelMasterData[0].ReferenceCode != "0")
            {
                objPanel.ReferenceCode = panelMasterData[0].ReferenceCode;
            }
            else
            {
                objPanel.ReferenceCode = "0";
            }
            if (panelMasterData[0].InvoiceTo != "0")
            {
                objPanel.InvoiceTo = panelMasterData[0].InvoiceTo;
            }
            else
            {
                objPanel.InvoiceTo = "0";
            }
            objPanel.MinBalReceive = panelMasterData[0].MinBalReceive;

            objPanel.ReportInterpretation = panelMasterData[0].ReportInterpretation;
            objPanel.HideDiscount = panelMasterData[0].HideDiscount;

            objPanel.SecurityDeposit = panelMasterData[0].SecurityDeposit;

            objPanel.PanelType = "RateType";
            objPanel.Panel_Code = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, string.Format(" SELECT CONCAT(Type1,LPAD(MaxID+1,4,'0')) FROM centre_type1master WHERE ID='{0}'  ", panelMasterData[0].TypeID)));
            objPanel.HideReceiptRate = Util.GetInt(panelMasterData[0].HideReceiptRate);
            objPanel.IsInvoice = 1;
            objPanel.InvoiceDisplayName = panelMasterData[0].InvoiceDisplayName;
            objPanel.InvoiceDisplayNo = panelMasterData[0].InvoiceDisplayNo;
            objPanel.IsPrintingLock = panelMasterData[0].IsPrintingLock;
            objPanel.IsBookingLock = panelMasterData[0].IsBookingLock;
            objPanel.Fullpaidpanelid = "0";
            objPanel.SalesManager = 0;
            string PanelId = objPanel.Insert();
            if (panelMasterData[0].ReferenceCodeOPD == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, string.Format("UPDATE f_panel_master SET  ReferenceCodeOPD='{0}' WHERE Panel_ID='{0}'", PanelId));
            }
            if (panelMasterData[0].ReferenceCode == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, string.Format("UPDATE f_panel_master SET ReferenceCode='{0}' WHERE Panel_ID='{0}'", PanelId));
            }
            if (panelMasterData[0].InvoiceTo == "0")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, string.Format("UPDATE f_panel_master SET InvoiceTo='{0}' WHERE Panel_ID='{0}'", PanelId));
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, string.Format("INSERT INTO centre_panel(CentreID,PanelID,UserID)VALUES('{0}','{1}','{2}')", panelMasterData[0].TagProcessingLabID, PanelId, UserInfo.ID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, string.Format(" update centre_type1master set MaxID=MaxID+1 where ID='{0}'", panelMasterData[0].TypeID));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
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
    public static string bindReferringRate(int PanelID)
    {
        DataTable dt = StockReports.GetDataTable(string.Format("SELECT Panel_ID,Company_Name FROM  f_panel_master  WHERE Panel_ID='{0}' ", PanelID));
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }
}