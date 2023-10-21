<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false"  CodeFile="TATReport.aspx.cs"
    Inherits="Design_Lab_TATReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
</Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" title="Click to Show/Hide Search Criteria." >
            <div class="content" style="text-align: center; width:auto">
                <b>TAT Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3"> <label class="pull-right">From Date :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" /></div>
                 <div class="col-md-3"><label class="pull-right">To Date :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="dtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtToDate" Format="dd-MMM-yyyy" PopupButtonID="dtToDate" /></div>
                 <div class="col-md-3"><label class="pull-right">Lab No :</label></div>
                <div class="col-md-3"><asp:TextBox ID="txtLabNo" runat="server"  CssClass="ItDoseTextinputText" /></div>
                 <div class="col-md-3"><label class="pull-right"> UHID No :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="txtUHID" runat="server"  CssClass="ItDoseTextinputText" /></div>
            </div>
            <div class="row">
               
                 <div class="col-md-3"><label class="pull-right">Patient Name :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="txtPName" runat="server" CssClass="ItDoseTextinputText" /></div>
                               <div class="col-md-3"><label class="pull-right">Barcode No.</label> </div>
                 <div class="col-md-3"><asp:TextBox ID="txtBarCodeNo" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox></div>
                 <div class="col-md-3"><label class="pull-right">Search By Date :</label></div>
                <div class="col-md-3">   <asp:DropDownList ID="ddlSearchByDate" runat="server" Width="155px">
                            <asp:ListItem Selected="True" Value="RegisterationDate">Registeration Date</asp:ListItem>
                            <asp:ListItem  Value="SampleCollectionDate">Sample Collection Date</asp:ListItem>
                            <asp:ListItem  Value="SampleReceivingDate">Sample Receiving Date</asp:ListItem>
                            <asp:ListItem Value="SampleRejectionDate">Sample Rejection Date</asp:ListItem>
                            <asp:ListItem Value="ApprovedDate">Approved Date</asp:ListItem>
                        </asp:DropDownList></div>
                 <div class="col-md-3"><label class="pull-right">Centre :</label></div>
                <div class="col-md-3">  <asp:DropDownList ID="ddlCentreAccess" runat="server"> </asp:DropDownList></div>
                </div>
             <div class="row">
                <div class="col-md-3"><label class="pull-right"> Department :</label></div>
                  <div class="col-md-3"><asp:DropDownList ID="ddlDepartment"   runat="server" ></asp:DropDownList></div>
                  <div class="col-md-3">
                      <label class="pull-right" ><asp:CheckBox ID="chkInvestigation" runat="server" Checked="false" Text="Investigation :" onClick="BindInvestigation();" />
                          </label>
                             </div>
                  <div class="col-md-3" ><asp:DropDownList ID="ddlInvestigation" runat="server"> </asp:DropDownList> </div>
                  <div class="col-md-3" ><label class="pull-right"> <asp:CheckBox ID="chkPanel" runat="server" Text="Panel :" onClick="BindPanel();" /></label> </div>
                   <div class="col-md-3" ><asp:DropDownList ID="ddlPanel" runat="server"></asp:DropDownList> </div>
                   <div class="col-md-3" ><label class="pull-right">  <asp:CheckBox ID="chkDoctor" runat="server" Text="Refered By :" onClick="BindDoctor();" /></label> </div>
                        <div class="col-md-3" ><asp:DropDownList ID="ddlReferDoctor"  runat="server"></asp:DropDownList></div>
                 </div>
             <div class="row">
                   <div class="col-md-3"><label class="pull-right">Status :</label></div>
                <div class="col-md-3"> <asp:DropDownList ID="ddlStatus" Width="155px" runat="server" >
                            <asp:ListItem></asp:ListItem>
                            <asp:ListItem Value="Approved">Approved</asp:ListItem>
                            <asp:ListItem Value="Not Approved">Not Approved</asp:ListItem>
                            <asp:ListItem Value="Result Done">Result Done</asp:ListItem>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Result Not Done">Result Not Done</asp:ListItem>
                            <asp:ListItem Value="Forward">Forward</asp:ListItem>
                            <asp:ListItem Value="Hold">Hold</asp:ListItem>
                            </asp:DropDownList></div>
                 <div class="col-md-3"><label class="pull-right"><input id="chkTATDelay" runat="server" type="checkbox" />
                            TAT Delay</label></div>
                  <div class="col-md-15"> 
                        <input id="ChkisUrgent" runat="server" type="checkbox" />
                            Search Urgent Investigations</div>
                 </div>
            </div>
         
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center;">
                         
                   <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF"  Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel"  Selected="True" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                
                <div class="col-md-20">           
                    <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />    
               
                </div>
                </div>
               </div>
             <script type="text/javascript" language="javascript">
            
                 var DoctorData = "";
                 function BindDoctor() {
                     var ddlDoctor = $("#<%=ddlReferDoctor.ClientID %>");
    var chkDoc = $("#<%=chkDoctor.ClientID %>");
    if (chkDoc.is(":checked")) {
        ddlDoctor.attr("disabled", true);
        chkDoc.attr("disabled", true);
        $("#<%=ddlReferDoctor.ClientID %> option").remove();
        serverCall('../../Lab/Services/ItemMaster.asmx/GetDoctorMaster', {}, function (response) {
            var data = $.parseJSON(response);
            if (data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    ddlDoctor.append($("<option></option>").val(data[i].Doctor_ID).html(data[i].NAME));
                }
            }
            ddlDoctor.attr("disabled", false);
            chkDoc.attr("disabled", false);
        });
    }
    else {
        $('#<%=ddlReferDoctor.ClientID %> option:nth-child(1)').attr('selected', 'selected')
        ddlDoctor.attr("disabled", true);
        chkDoc.attr("disabled", false);
    }
};
var PanelData = "";
function BindPanel() {
    var ddlPanl = $("#<%=ddlPanel.ClientID %>");
     var chkPanl = $("#<%=chkPanel.ClientID %>");
     if (chkPanl.is(":checked")) {

         ddlPanl.attr("disabled", true);
         chkPanl.attr("disabled", true);
         $("#<%=ddlPanel.ClientID %> option").remove();
         ddlPanl.append($("<option></option>").val("").html(""));
         serverCall('../../Lab/Services/ItemMaster.asmx/GetPanelMasterAll', {}, function (response) {
             var data = $.parseJSON(response);
             if (data.length > 0) {
                 for (var i = 0; i < data.length; i++) {
                     ddlPanl.append($("<option></option>").val(data[i].Panel_ID).html(data[i].Company_Name));
                 }
             }
             ddlPanl.attr("disabled", false);
             chkPanl.attr("disabled", false);
         });
     }
     else {
         $('#<%=ddlReferDoctor.ClientID %> option:nth-child(1)').attr('selected', 'selected')
         ddlPanl.attr("disabled", true);
         chkPanl.attr("disabled", false);
     }

 };
 var InvestigationData = "";
 function BindInvestigation() {
     var ddlInv = $("#<%=ddlInvestigation.ClientID %>");
     var chkInv = $("#<%=chkInvestigation.ClientID %>");
     if (chkInv.is(":checked")) {

         ddlInv.attr("disabled", true);
         chkInv.attr("disabled", true);
         $("#<%=ddlInvestigation.ClientID %> option").remove();
         ddlInv.append($("<option></option>").val("").html(""));
         serverCall('../../Lab/Services/ItemMaster.asmx/bindInvestigation', {}, function (response) {
             var data = $.parseJSON(response);
             if (data.length > 0) {
                 for (var i = 0; i < data.length; i++) {
                     ddlInv.append($("<option></option>").val(data[i].Investigation_ID).html(data[i].name));
                 }
             }
             ddlInv.attr("disabled", false);
             chkInv.attr("disabled", false);
         });
     }
     else {
         $('#<%=ddlInvestigation.ClientID %> option:nth-child(1)').attr('selected', 'selected')
         ddlInv.attr("disabled", true);
         chkInv.attr("disabled", false);
     }
 };
 function getreport() {
     var FromDate = jQuery('#<%=dtFrom.ClientID%>').val().trim();
        var ToDate = jQuery('#<%=dtToDate.ClientID%>').val().trim();
        var CentreId = jQuery('#<%=ddlCentreAccess.ClientID%>').val().toString();
        var Panel = jQuery('#<%=ddlPanel.ClientID%>').val().toString();
        var Department = jQuery('#<%=ddlDepartment.ClientID%>').val().toString();
        var Investigation = jQuery('#<%=ddlInvestigation.ClientID%>').val().toString();
        var Doctor = jQuery('#<%=ddlReferDoctor.ClientID%>').val().toString();
        var Labno = jQuery('#<%=txtLabNo.ClientID%>').val().toString();
        var PatientID = jQuery('#<%=txtUHID.ClientID%>').val().toString();
        var Pname = jQuery('#<%=txtPName.ClientID%>').val().toString();
        var barcodeno = jQuery('#<%=txtBarCodeNo.ClientID%>').val().toString();

        var SearchByDate = jQuery('#<%=ddlSearchByDate.ClientID%>').val().toString();
        var Status = jQuery('#<%=ddlStatus.ClientID%>').val().toString();
        var chkTATDelay = jQuery('#<%=chkTATDelay.ClientID%>').is(':checked') ? 1 : 0;
        var ChkisUrgent = jQuery('#<%=ChkisUrgent.ClientID%>').is(':checked') ? 1 : 0;
        var ReportFromat = jQuery('#<%=rdoReportFormat.ClientID%> input:checked').val().toString();
        var Reporttype = "0";
        serverCall('TATReport.aspx/GetReport', { FromDate: FromDate, ToDate: ToDate, CentreId: CentreId, ReportFromat: ReportFromat, PanelID: Panel, DepartmentID: Department, Reporttype: Reporttype, InvestigationID: Investigation, DoctorID: Doctor, Labno: Labno, PatientID: PatientID, barcodeno: barcodeno, SearchByDate: SearchByDate, Status: Status, chkTATDelay: chkTATDelay, ChkisUrgent: ChkisUrgent, Pname: Pname }, function (response) {
            var $responseData = JSON.parse(response);
            PostQueryString($responseData, 'TATReportPdf.aspx');
        });
    }
</script>
</form>
</body>
</html>