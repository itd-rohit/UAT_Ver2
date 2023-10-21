using Resources;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Design_Master_LISMaster : Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            BindGrid();
            BindGlobalFile();
        }
    }

    private void BindGrid()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT FormatName,ID,FormatURL,URL FROM receipt_format_master where IsActive=1 "))
        {
            grdPatientReceiptFormat.DataSource = dt;
            grdPatientReceiptFormat.DataBind();
        }

        using (DataTable dt = StockReports.GetDataTable("SELECT FormatName,ID,FormatURL,URL FROM labReport_format_master where IsActive=1 "))
        {
            grdLabReportFormat.DataSource = dt;
            grdLabReportFormat.DataBind();
        }
    }

    private void BindGlobalFile()
    {
        try
        {
            ddlDocumentDriveName.SelectedIndex = ddlDocumentDriveName.Items.IndexOf(ddlDocumentDriveName.Items.FindByText(Resource.DocumentDriveName));
            rblPatientPhoto.SelectedIndex = rblPatientPhoto.Items.IndexOf(rblPatientPhoto.Items.FindByValue(Resource.ShowPatientPhoto));
            rblSRARequired.SelectedIndex = rblSRARequired.Items.IndexOf(rblSRARequired.Items.FindByValue(Resource.SRARequired));
            txtapplicationname.Text = Resource.ApplicationName;
            txtApplicationURLReportPathName.Text = Resource.ApplicationURLReportPathName;
            ddlBankCacheTimeOut.SelectedIndex = ddlBankCacheTimeOut.Items.IndexOf(ddlBankCacheTimeOut.Items.FindByValue(Resource.BankCacheTimeOut));
           
            txtBaseCurrencyID.Text = Resource.BaseCurrencyID;
            txtBaseCurrencyNotation.Text = Resource.BaseCurrencyNotation;
            txtBaseCurrencyRound.Text = Resource.BaseCurrencyRound;
            ddlCityCacheTimeOut.SelectedIndex = ddlCityCacheTimeOut.Items.IndexOf(ddlCityCacheTimeOut.Items.FindByValue(Resource.CityCacheTimeOut));
            
            txtClientEmail.Text = Resource.ClientEmail;
            txtClientFullName.Text = Resource.ClientFullName;
            txtClientImagePath.Text = Resource.ClientImagePath;
            txtClientLogo.Text = Resource.ClientLogo;
            txtClientNameShowInApplication.Text = Resource.ClientNameShowInApplication;
            txtClientWebSite.Text = Resource.ClientWebSite;
            txtConcentFormApplicable.Text = Resource.ConcentFormApplicable;
            txtConcentFormOpen.Text = Resource.ConcentFormOpen;
            ddlCountryCacheTimeOut.SelectedIndex = ddlCountryCacheTimeOut.Items.IndexOf(ddlCountryCacheTimeOut.Items.FindByValue(Resource.CountryCacheTimeOut));
            ddlCurrencyCacheTimeOut.SelectedIndex = ddlCurrencyCacheTimeOut.Items.IndexOf(ddlCurrencyCacheTimeOut.Items.FindByValue(Resource.CurrencyCacheTimeOut));
            
            txtDefaultCountry.Text = Resource.DefaultCountry;
            txtDefaultFooter.Text = Resource.DefaultFooter;
            txtDefaultHeader.Text = Resource.DefaultHeader;
            txtDiagnosticName.Text = Resource.DiagnosticName;
            txtDocumentDriveIPAddress.Text = Resource.DocumentDriveIPAddress;
            txtDocumentFolderName.Text = Resource.DocumentFolderName;
            txtDocumentPath.Text = Resource.DocumentPath;
            txtEmailDisplayName.Text = Resource.EmailDisplayName;
            txtEmailID.Text = Resource.EmailID;
            txtEmailPassword.Text = Resource.EmailPassword;
            txtEmailSignature.Text = Resource.EmailSignature;
            txtEmailURLLink.Text = Resource.EmailURLLink;
            txtFromEmailid.Text = Resource.FromEmailid;
            txtHiQPdfSerialNumber.Text = Resource.HiQPdfSerialNumber;
            txtHostName.Text = Resource.HostName;
            txtLabReportPath.Text = Resource.LabReportPath;
            txtLinkURL.Text = Resource.LinkURL;
            txtLedgerReportDate.Text = Resource.LedgerReportDate;
            ddlLocalityCacheTimeOut.SelectedIndex = ddlLocalityCacheTimeOut.Items.IndexOf(ddlLocalityCacheTimeOut.Items.FindByValue(Resource.LocalityCacheTimeOut));

           
            txtLocalLink.Text = Resource.LocalLink;
            txtLocalLinkApplicable.Text = Resource.LocalLinkApplicable;
            txtMemberShipCardApplicable.Text = Resource.MemberShipCardApplicable;
            txtMemberShipCardNoAutoGenerate.Text = Resource.MemberShipCardNoAutoGenerate;
            txtMobileAppFooter.Text = Resource.MobileAppFooter;
            txtOldPatientLink.Text = Resource.OldPatientLink;
            txtPanelInvoiceTDS.Text = Resource.PanelInvoiceTDS;
            txtPayTM.Text = Resource.PayTM;
            txtPort.Text = Resource.Port;
            txtRemoteLink.Text = Resource.RemoteLink;
            txtRemoteLinkApplicable.Text = Resource.RemoteLinkApplicable;
            txtReportURL.Text = Resource.ReportURL;
            ddlStateCacheTimeOut.SelectedIndex = ddlStateCacheTimeOut.Items.IndexOf(ddlStateCacheTimeOut.Items.FindByValue(Resource.StateCacheTimeOut));
            
            txtTinySMSFooter.Text = Resource.TinySMSFooter;
            txtTinySMSReturnURL.Text = Resource.TinySMSReturnURL;
            txtDummyWaterMark.Text = Resource.DummyWaterMark;
            txtOPDHomeCollection.Text = Resource.OPDHomeCollection;

            string PatientReceiptFormat = Resource.PatientReceiptFormat;
            foreach (GridViewRow gvr in grdPatientReceiptFormat.Rows)
            {
                if (((Label)gvr.FindControl("lblFormatName")).Text == PatientReceiptFormat)
                {
                    RadioButton rb1 = (RadioButton)gvr.FindControl("rbReportFormat");
                    rb1.Checked = true;
                }
            }

            string LabReportFormat = Resource.LabReportFormat;
            foreach (GridViewRow gvr in grdLabReportFormat.Rows)
            {
                if (((Label)gvr.FindControl("lblFormatName")).Text == LabReportFormat)
                {
                    RadioButton rb1 = (RadioButton)gvr.FindControl("rbReportFormat");
                    rb1.Checked = true;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string PatientReceiptURL = string.Empty; string PatientReceiptFormat = string.Empty;
            foreach (GridViewRow gvr in grdPatientReceiptFormat.Rows)
            {
                RadioButton rb1 = (RadioButton)gvr.FindControl("rbReportFormat");
                if (rb1.Checked)
                {
                    PatientReceiptURL = ((Label)gvr.FindControl("lblURL")).Text;
                    PatientReceiptFormat = ((Label)gvr.FindControl("lblFormatName")).Text;
                }
            }

            string LabReportURL = string.Empty; string LabReportFormat = string.Empty;
            foreach (GridViewRow gvr in grdPatientReceiptFormat.Rows)
            {
                RadioButton rb1 = (RadioButton)gvr.FindControl("rbReportFormat");
                if (rb1.Checked)
                {
                    LabReportURL = ((Label)gvr.FindControl("lblURL")).Text;
                    LabReportFormat = ((Label)gvr.FindControl("lblFormatName")).Text;
                }
            }

            XmlDocument loResource = new XmlDocument();
            loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));

            XmlNode xShowPatientPhoto = loResource.SelectSingleNode("root/data[@name='ShowPatientPhoto']/value");
            XmlNode xSRARequired = loResource.SelectSingleNode("root/data[@name='SRARequired']/value");
            XmlNode xClientLogo = loResource.SelectSingleNode("root/data[@name='ClientLogo']/value");
            XmlNode xDocumentDriveName = loResource.SelectSingleNode("root/data[@name='DocumentDriveName']/value");
            XmlNode xPatientReceiptURL = loResource.SelectSingleNode("root/data[@name='PatientReceiptURL']/value");
            XmlNode xPatientReceiptFormat = loResource.SelectSingleNode("root/data[@name='PatientReceiptFormat']/value");

            XmlNode xLabReportURL = loResource.SelectSingleNode("root/data[@name='LabReportURL']/value");
            XmlNode xLabReportFormat = loResource.SelectSingleNode("root/data[@name='LabReportFormat']/value");
            XmlNode xApplicationName = loResource.SelectSingleNode("root/data[@name='ApplicationName']/value");
            XmlNode xApplicationURLReportPathName = loResource.SelectSingleNode("root/data[@name='ApplicationURLReportPathName']/value");

            XmlNode xBankCacheTimeOut = loResource.SelectSingleNode("root/data[@name='BankCacheTimeOut']/value");
            XmlNode xBaseCurrencyID = loResource.SelectSingleNode("root/data[@name='BaseCurrencyID']/value");
            XmlNode xBaseCurrencyNotation = loResource.SelectSingleNode("root/data[@name='BaseCurrencyNotation']/value");
            XmlNode xBaseCurrencyRound = loResource.SelectSingleNode("root/data[@name='BaseCurrencyRound']/value");
            XmlNode xCityCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CityCacheTimeOut']/value");
            XmlNode xClientEmail = loResource.SelectSingleNode("root/data[@name='ClientEmail']/value");
            XmlNode xClientFullName = loResource.SelectSingleNode("root/data[@name='ClientFullName']/value");
            XmlNode xClientImagePath = loResource.SelectSingleNode("root/data[@name='ClientImagePath']/value");
            XmlNode xClientNameShowInApplication = loResource.SelectSingleNode("root/data[@name='ClientNameShowInApplication']/value");
            XmlNode xClientWebSite = loResource.SelectSingleNode("root/data[@name='ClientWebSite']/value");
            XmlNode xConcentFormApplicable = loResource.SelectSingleNode("root/data[@name='ConcentFormApplicable']/value");
            XmlNode xConcentFormOpen = loResource.SelectSingleNode("root/data[@name='ConcentFormOpen']/value");
            XmlNode xCountryCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CountryCacheTimeOut']/value");
            XmlNode xCurrencyCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CurrencyCacheTimeOut']/value");
            XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
            XmlNode xDefaultFooter = loResource.SelectSingleNode("root/data[@name='DefaultFooter']/value");
            XmlNode xDefaultHeader = loResource.SelectSingleNode("root/data[@name='DefaultHeader']/value");
            XmlNode xDiagnosticName = loResource.SelectSingleNode("root/data[@name='DiagnosticName']/value");
            XmlNode xDocumentDriveIPAddress = loResource.SelectSingleNode("root/data[@name='DocumentDriveIPAddress']/value");
            XmlNode xDocumentFolderName = loResource.SelectSingleNode("root/data[@name='DocumentFolderName']/value");
            XmlNode xDocumentPath = loResource.SelectSingleNode("root/data[@name='DocumentPath']/value");
            XmlNode xEmailDisplayName = loResource.SelectSingleNode("root/data[@name='EmailDisplayName']/value");
            XmlNode xEmailID = loResource.SelectSingleNode("root/data[@name='EmailID']/value");
            XmlNode xEmailPassword = loResource.SelectSingleNode("root/data[@name='EmailPassword']/value");
            XmlNode xEmailSignature = loResource.SelectSingleNode("root/data[@name='EmailSignature']/value");
            XmlNode xEmailURLLink = loResource.SelectSingleNode("root/data[@name='EmailURLLink']/value");
            XmlNode xFromEmailid = loResource.SelectSingleNode("root/data[@name='FromEmailid']/value");
            XmlNode xHiQPdfSerialNumber = loResource.SelectSingleNode("root/data[@name='HiQPdfSerialNumber']/value");
            XmlNode xHostName = loResource.SelectSingleNode("root/data[@name='HostName']/value");
            XmlNode xLabReportPath = loResource.SelectSingleNode("root/data[@name='LabReportPath']/value");
            XmlNode xLinkURL = loResource.SelectSingleNode("root/data[@name='LinkURL']/value");
            XmlNode xLedgerReportDate = loResource.SelectSingleNode("root/data[@name='LedgerReportDate']/value");
            XmlNode xLocalityCacheTimeOut = loResource.SelectSingleNode("root/data[@name='LocalityCacheTimeOut']/value");
            XmlNode xLocalLink = loResource.SelectSingleNode("root/data[@name='LocalLink']/value");
            XmlNode xLocalLinkApplicable = loResource.SelectSingleNode("root/data[@name='LocalLinkApplicable']/value");
            XmlNode xMemberShipCardApplicable = loResource.SelectSingleNode("root/data[@name='MemberShipCardApplicable']/value");
            XmlNode xMemberShipCardNoAutoGenerate = loResource.SelectSingleNode("root/data[@name='MemberShipCardNoAutoGenerate']/value");
            XmlNode xMobileAppFooter = loResource.SelectSingleNode("root/data[@name='MobileAppFooter']/value");
            XmlNode xOldPatientLink = loResource.SelectSingleNode("root/data[@name='OldPatientLink']/value");
            XmlNode xPanelInvoiceTDS = loResource.SelectSingleNode("root/data[@name='PanelInvoiceTDS']/value");
            XmlNode xPayTM = loResource.SelectSingleNode("root/data[@name='PayTM']/value");
            XmlNode xPort = loResource.SelectSingleNode("root/data[@name='Port']/value");
            XmlNode xRemoteLink = loResource.SelectSingleNode("root/data[@name='RemoteLink']/value");
            XmlNode xRemoteLinkApplicable = loResource.SelectSingleNode("root/data[@name='RemoteLinkApplicable']/value");
            XmlNode xReportURL = loResource.SelectSingleNode("root/data[@name='ReportURL']/value");
            XmlNode xStateCacheTimeOut = loResource.SelectSingleNode("root/data[@name='StateCacheTimeOut']/value");
            XmlNode xTinySMSFooter = loResource.SelectSingleNode("root/data[@name='TinySMSFooter']/value");
            XmlNode xTinySMSReturnURL = loResource.SelectSingleNode("root/data[@name='TinySMSReturnURL']/value");
            XmlNode xDummyWaterMarkURL = loResource.SelectSingleNode("root/data[@name='DummyWaterMark']/value");
            XmlNode xOPDHomeCollection = loResource.SelectSingleNode("root/data[@name='OPDHomeCollection']/value");

            xDocumentDriveName.InnerText = ddlDocumentDriveName.SelectedItem.Value;
            xShowPatientPhoto.InnerText = rblPatientPhoto.SelectedItem.Value;
            xSRARequired.InnerText = rblSRARequired.SelectedItem.Value;
            xPatientReceiptURL.InnerText = PatientReceiptURL;
            xPatientReceiptFormat.InnerText = PatientReceiptFormat;
            xLabReportURL.InnerText = LabReportURL;
            xLabReportFormat.InnerText = LabReportFormat;
            xApplicationName.InnerText = txtapplicationname.Text.Trim();
            xApplicationURLReportPathName.InnerText=txtApplicationURLReportPathName.Text.Trim();
            xBankCacheTimeOut.InnerText = ddlBankCacheTimeOut.SelectedItem.Value;
            xBaseCurrencyID.InnerText = txtBaseCurrencyID.Text;
            xBaseCurrencyNotation.InnerText = txtBaseCurrencyNotation.Text.Trim();
            xBaseCurrencyRound.InnerText = txtBaseCurrencyRound.Text.Trim();
            xCityCacheTimeOut.InnerText = ddlCityCacheTimeOut.SelectedItem.Value;
            xClientEmail.InnerText = txtClientEmail.Text;
            xClientFullName.InnerText = txtClientFullName.Text;
            xClientImagePath.InnerText = txtClientImagePath.Text.Trim();
            xClientLogo.InnerText = txtClientLogo.Text.Trim();
            xClientNameShowInApplication.InnerText = txtClientNameShowInApplication.Text.Trim();
            xClientWebSite.InnerText = txtClientWebSite.Text.Trim();
            xConcentFormApplicable.InnerText = txtConcentFormApplicable.Text.Trim();
            xConcentFormOpen.InnerText = txtConcentFormOpen.Text.Trim();
            xCountryCacheTimeOut.InnerText = ddlCountryCacheTimeOut.SelectedItem.Value;
            xCurrencyCacheTimeOut.InnerText = ddlCurrencyCacheTimeOut.SelectedItem.Value;
            xDefaultCountry.InnerText = txtDefaultCountry.Text.Trim();
            xDefaultFooter.InnerText = txtDefaultFooter.Text.Trim();
            xDefaultHeader.InnerText = txtDefaultHeader.Text.Trim();
            xDiagnosticName.InnerText = txtDiagnosticName.Text.Trim();
            xDocumentDriveIPAddress.InnerText = txtDocumentDriveIPAddress.Text.Trim();
            xDocumentFolderName.InnerText = txtDocumentFolderName.Text.Trim();
            xDocumentPath.InnerText = txtDocumentPath.Text.Trim();
            xEmailDisplayName.InnerText = txtEmailDisplayName.Text.Trim();
            xEmailID.InnerText = txtEmailID.Text.Trim();
            xEmailPassword.InnerText = txtEmailPassword.Text.Trim();
            xEmailSignature.InnerText = txtEmailSignature.Text.Trim();
            xEmailURLLink.InnerText = txtEmailURLLink.Text.Trim();
            xFromEmailid.InnerText = txtFromEmailid.Text.Trim();
            xHiQPdfSerialNumber.InnerText = txtHiQPdfSerialNumber.Text.Trim();
            xHostName.InnerText = txtHostName.Text.Trim();
            xLabReportPath.InnerText = txtLabReportPath.Text.Trim();
            xLinkURL.InnerText = txtLinkURL.Text.Trim();
            xLedgerReportDate.InnerText = txtLedgerReportDate.Text.Trim();
            xLocalityCacheTimeOut.InnerText = ddlLocalityCacheTimeOut.SelectedItem.Value; 
            xLocalLink.InnerText = txtLocalLink.Text.Trim();
            xLocalLinkApplicable.InnerText = txtLocalLinkApplicable.Text.Trim();
            xMemberShipCardApplicable.InnerText = txtMemberShipCardApplicable.Text.Trim();
            xMemberShipCardNoAutoGenerate.InnerText = txtMemberShipCardNoAutoGenerate.Text.Trim();
            xMobileAppFooter.InnerText = txtMobileAppFooter.Text.Trim();
            xOldPatientLink.InnerText = txtOldPatientLink.Text.Trim();
            xPanelInvoiceTDS.InnerText = txtPanelInvoiceTDS.Text.Trim();
            xPayTM.InnerText = txtPayTM.Text.Trim();
            xPort.InnerText = txtPort.Text.Trim();
            xRemoteLink.InnerText = txtRemoteLink.Text.Trim();
            xRemoteLinkApplicable.InnerText = txtRemoteLinkApplicable.Text.Trim();
            xReportURL.InnerText = txtReportURL.Text.Trim();
            xStateCacheTimeOut.InnerText = ddlStateCacheTimeOut.SelectedItem.Value; 
            xTinySMSFooter.InnerText = txtTinySMSFooter.Text.Trim();
            xTinySMSReturnURL.InnerText = txtTinySMSReturnURL.Text.Trim();
            xDummyWaterMarkURL.InnerText = txtDummyWaterMark.Text.Trim();
            
            xOPDHomeCollection.InnerText = txtOPDHomeCollection.Text.Trim();

            loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
            lblMsg.Text = "Record Updated Successfully";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error";
        }
    }
}