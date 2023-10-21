using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// Summary description for ValidationSkipPage
/// </summary>
public class ValidationSkipPage
{
    public static List<string> ValidationSkipPages()
	{
        List<string> page = new List<string>();
        page.Add("/Design/Lab/DynamicLabSearch.aspx");
        page.Add("/Design/Lab/BarCodeReprint.aspx");
        page.Add("/Design/Investigation/ObservationManage.aspx");
        page.Add("/Design/Investigation/AddInterpretation.aspx");
        page.Add("/Design/Lab/OpdSettelment.aspx");
        page.Add("/Design/Lab/AddFileRegistration.aspx");
        page.Add("/Design/Lab/AddReport.aspx");
        page.Add("/Design/Lab/SampleReject.aspx");
        page.Add("/Design/Lab/SampleTransferReport.aspx");
        page.Add("/Design/Lab/EditBatch.aspx");
        page.Add("/Design/Lab/AddAttachment.aspx");
        page.Add("/Design/Lab/ShowRerun.aspx");                                       
        page.Add("/Design/Sales/UploadDocument.aspx");
        page.Add("/Design/Lab/DeltaCheckMobile.aspx");
        page.Add("/Design/Appointment/HomeCollectionNew.aspx");
        page.Add("/Design/master/EstimateRate.aspx");       
        page.Add("/Design/Sales/EnrolmentVerification.aspx");      
        page.Add("/Design/Common/CrystalReport.aspx");
        page.Add("/Design/FrontOffice/DoctorReferalCentreMapping.aspx");
        page.Add("/Design/lab/SampleLog.aspx");
        page.Add("/Design/Welcome.aspx");
        page.Add("/Design/Lab/PrintReportFrontOffice.aspx");
        page.Add("/Design/OPDConsultation/DoctorEdit.aspx");
        page.Add("/Design/UnAuthorized.aspx");
        page.Add("/Design/Investigation/InvComments.aspx");
        page.Add("/Design/Investigation/labobservation_Help.aspx");
        page.Add("/Design/Investigation/InvestigationRole.aspx");
        page.Add("/Design/Investigation/InvestigationRequiredFields.aspx");
        page.Add("/Design/Investigation/InvestigationConcernForm.aspx");
        page.Add("/Design/Support/CategoryTAT.aspx");
        page.Add("/Design/Support/CategoryTagEmployee.aspx");
        page.Add("/Design/Support/AnswerTicket.aspx");
        page.Add("/Design/Investigation/InvTemplate.aspx");
        page.Add("/Design/Lab/ApprovalReport.aspx");
        page.Add("/Design/Lab/AutoApprovalReport.aspx");
        page.Add("/Design/Lab/Lab_PrescriptionOPDEditInfo.aspx");
        page.Add("/Design/master/MachineMaster.aspx");  
		page.Add("/Design/Store/UnConsumeReport.aspx"); 
	    page.Add("/Design/Lab/Lab_PrescriptionOPDEdit.aspx");
        page.Add("/Design/Edp/LogReport.aspx");
        page.Add("/Design/Lab/SerachWorksheet.aspx");
        page.Add("/Design/appointment/AddFileAppointment.aspx");
        page.Add("/Design/Investigation/AliasMaster.aspx");
        page.Add("/Design/DashBoard/TATPendingNew.aspx");


        
        return page;
	}
    public static List<string> notCheckSessionState()
    {
        List<string> page = new List<string>();
        page.Add("Default.aspx");
        page.Add("LogOut.aspx");
        page.Add("Design/B2CMobile/Services/Services_B2CApp.asmx");
        return page;
    }
}