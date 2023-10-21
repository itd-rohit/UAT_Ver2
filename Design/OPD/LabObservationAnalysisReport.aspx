<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabObservationAnalysisReport.aspx.cs" Inherits="Design_OPD_LabObservationAnalysisReport" %>

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
        <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <b>Lab Observations Analysis Report</b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3"><label class="pull-right"> Date From:</label></div>
                 <div class="col-md-3">  <asp:TextBox ID="txtFromDate" runat="server" class="filterdate" />
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtFromDate" PopupButtonID="txtFromDate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender></div>
                <div class="col-md-3"></div>
                <div class="col-md-3"><label class="pull-right"> To From:</label></div>
                <div class="col-md-3"> <asp:TextBox ID="txtToDate" runat="server" class="filterdate" />
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtToDate" PopupButtonID="txtToDate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender></div>
                <div class="col-md-9"></div>
            </div>

            <div class="row">
                <div class="col-md-3"><label class="pull-right">Machine :</label></div>
                <div class="col-md-6"> <asp:ListBox ID="lstMac" CssClass="multiselect" SelectionMode="Multiple" runat="server" ></asp:ListBox>
                    </div>
                 <div class="col-md-3"><label class="pull-right">Centre :</label></div>
                 <div class="col-md-6"> <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox></div>
                <div class="col-md-6"></div>
                </div>
             <div class="row">
                <div class="col-md-3"><label class="pull-right">Department :</label></div>
                  <div class="col-md-6"> <asp:ListBox ID="lstDepartment" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>
                             </div>
                  <div class="col-md-3">
                       <input type="button" value="Get Parameter" class="searchbutton" onclick="bindParameter()" />
                 
                      </div>
                 </div>
                  <div class="row">
                  <div class="col-md-3"><label class="pull-right">Parameter :</label></div>
                  <div class="col-md-6"><asp:ListBox ID="lstParameter" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox> </div>
                  <div class="col-md-3">
                       
                  </div>
                 </div>
            <div class="row">
                <div class="col-md-3"><label class="pull-right">Report Formate :</label></div>
                   <div class="col-md-21"> <asp:RadioButtonList ID="rboReporttype" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">Department vs Observation</asp:ListItem>
                                <asp:ListItem Value="1">Department vs Observation </asp:ListItem>
                                <asp:ListItem Value="2">Machine vs Observation </asp:ListItem>
                            </asp:RadioButtonList></div>
                  
                   </div>
        </div>        
     <div class="POuter_Box_Inventory">           
             <div class="row">   
                   <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                 <div class="col-md-20" style="text-align:center">  <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" /></div>
                  </div>                         
              
             </div> 
     <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=<%=lstMac.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstCentre.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstDepartment.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstParameter.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
         });
         function bindParameter() {
             if ($('[id$=lstDepartment]').val() == "") {
                 toast("Error", "Please select Dept..!", "");
                 return;
             }
             $('#<%=lstParameter.ClientID%> option').remove();
             jQuery('#<%=lstParameter.ClientID%>').multipleSelect("refresh");
             serverCall('LabObservationAnalysisReport.aspx/bindParameter', { DeptID: $('[id$=lstDepartment]').val().toString() }, function (response) {
                 var data = $.parseJSON(response);
                 if (data.length > 0) {
                     for (var i = 0; i < data.length; i++) {
                         jQuery('#<%=lstParameter.ClientID%>').append($("<option></option>").val(data[i].labObservation_ID).html(data[i].Name));
                     }
                 }
                 jQuery('#<%=lstParameter.ClientID%>').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
             });
         }
         function getreport() {
             var FromDate = jQuery('#<%=txtFromDate.ClientID%>').val().trim();
             var ToDate = jQuery('#<%=txtToDate.ClientID%>').val().trim();
             var CentreId = jQuery('#<%=lstCentre.ClientID%>').val().toString();
             var Parameter = jQuery('#<%=lstParameter.ClientID%>').val().toString();
             var Machine = jQuery('#<%=lstMac.ClientID%>').val().toString();
             if (CentreId == "") {
                 toast("Error", "Please select CentreId", "");
                 return;
             }
             if (Parameter == "") {
                 toast("Error", "Please select Parameter", "");
                 return;
             }
             var ReportFromat = jQuery('#<%=rdoReportFormat.ClientID%> input:checked').val().toString();
             var Reporttype = jQuery('#<%=rboReporttype.ClientID%> input:checked').val().toString();
             serverCall('LabObservationAnalysisReport.aspx/GetReport', { FromDate: FromDate, ToDate: ToDate, CentreId: CentreId, ReportFromat: ReportFromat, Parameter: Parameter, Machine: Machine, Reporttype: Reporttype }, function (response) {
                 var $responseData = JSON.parse(response);
                 PostQueryString($responseData, 'LabObservationAnalysisReportPdf.aspx');
             });

         }
    </script>
</form>
</body>
</html>
