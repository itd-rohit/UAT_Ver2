<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false"  CodeFile="LabInvestigationAnalysisReport.aspx.cs" Inherits="Design_OPD_LabInvestigationAnalysisReport" %>


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

 <div id="Pbody_box_inventory">
     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
</Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" >
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <b>Lab Investigation Analysis Report</b><br />
                        <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="Purchaseheader">
                    Search Criteria
                </div>
                <div class="row">
                    <div class="col-md-4"><label class="pull-right">From Date :</label> </div>
                    <div class="col-md-4"><asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>                                
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" PopupButtonID="txtFromDate" /></div>
                    <div class="col-md-4"><label class="pull-right">To Date :</label></div>
                    <div class="col-md-4"> <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>                                
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="txtToDate" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" />
                               
                             </div>
                </div>
                   <div class="row">
                   <%-- 
				    <div class="col-md-4"><label class="pull-right">Center :</label></div>
                    <div class="col-md-4"> <asp:DropDownList ID="ddlcenter" class="chosen-select" runat="server">
                               </asp:DropDownList></div>
				   --%>
							   
							   <div class="col-md-4"><label class="pull-right">Center :</label></div>
                    <div class="col-md-4"> <asp:ListBox ID="ddlcenter"  CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox> 
                         <asp:HiddenField ID="hdnCentre" runat="server"  />
                        </div>
                  <div class="col-md-4"><label class="pull-right">Panel :</label></div>
                    <div class="col-md-4"> <asp:ListBox ID="lstpanellist"  CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox> 
                         <asp:HiddenField ID="hdnPanelID" runat="server"  />
                        </div>
                     </div>
                <div class="row">
                    <div class="col-md-4"><label class="pull-right">Department :</label></div>
                     <div class="col-md-4"><asp:ListBox ID="ddlDepartment" CssClass="multiselect"  ClientIDMode="Static" SelectionMode="Multiple" runat="server" onchange="BindInvestigations()"></asp:ListBox>
                                <asp:HiddenField ID="hdnItemId" runat="server"  />
                               <asp:HiddenField ID="hdnDepartmentValue" runat="server" />
                     </div>
                     <div class="col-md-4"><label class="pull-right">Investigations :</label></div>
                     <div class="col-md-4"> <asp:ListBox ID="ddlInvestigations" CssClass="multiselect" SelectionMode="Multiple" ClientIDMode="Static"  runat="server"></asp:ListBox>                          
                     </div>
                </div>
                 <div class="row">
                    <div class="col-md-4"><label class="pull-right">Report Type :</label></div>
                    <div class="col-md-4"> <asp:RadioButtonList ID="rbtnReportType" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True">Summary</asp:ListItem>
                                    <asp:ListItem>Detail Report</asp:ListItem>
                                </asp:RadioButtonList></div>
                    <div class="col-md-4"><label class="pull-right">Report Format :</label></div>
                    <div class="col-md-4"><asp:RadioButtonList ID="rblreportformat" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="1" Selected="True">Pdf</asp:ListItem>
                                    <asp:ListItem Value="2">Excel</asp:ListItem> </asp:RadioButtonList></div>
                </div>               
            </div>
           
            <div class="POuter_Box_Inventory" >
                <div class="content" style="vertical-align: middle; text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Specify From Date " ControlToValidate="txtFromDate" Display="None" SetFocusOnError="True">*</asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Specify To Date" ControlToValidate="txtToDate" Display="None" SetFocusOnError="True">*</asp:RequiredFieldValidator><asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="Please Fix following Errors :"
                            ShowMessageBox="True" ShowSummary="False" />
                    &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClientClick="return ValidateData();" OnClick="btnSearch_Click" /></div>
            </div>
 </div>
      
    
     <script type="text/javascript">
         $(function () {
             BindInvestigations(0);
            $("#Pbody_box_inventory").css('margin-top', 0);
			 $('[id$=ddlcenter]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
			
             $('[id$=ddlDepartment]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });            
             $('[id$=lstpanellist]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             
             $('[id$=ddlInvestigations]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
			 
           

         
             

             if ($('#hdnCentre').val() != '') {
                 var data = [];
                 data = $('#hdnCentre').val();
             }

             
             if ($('#hdnItemId').val() != '') {
                 var data1 = [];
                 data1 = $('[id$=hdnItemId]').val();
             }             
         
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 $(selector).chosen(config[selector]);
             }
             jQuery('#ddlDepartment').trigger('chosen:updated');
             jQuery('#ddlcenter').trigger('chosen:updated');
             jQuery('#ddlInvestigations').trigger('chosen:updated');           
         });
         function BindInvestigations(itemid) {

             $('[id$=ddlInvestigations]').find('option').remove();
             var DeptId = $('[id$=ddlDepartment]').val().toString();

             if (DeptId != "0") {
                 var $ddlInv = $('#ddlInvestigations');
                 $("#ddlInvestigations option").remove();
                 serverCall('LabInvestigationAnalysisReport.aspx/BindInvestigations', { DeptId: DeptId }, function (response) {
                     var data = $.parseJSON(response);
                     if (data.length > 0) {
                         var html = "<option value=0>--Select--</option>";
                         for (var i = 0; i < data.length; i++) {
                             jQuery('#ddlInvestigations').append($("<option></option>").val(data[i].ItemId).html(data[i].TypeName));
                         }
                     }
                     $('[id$=ddlInvestigations]').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
                 });
             } else {
                // $('[id$=ddlInvestigations]').find('option').remove();

             }
         }
                

         function ValidateData() {
             flag = true;
             var ErrMsg = '';            

             if ($('[id$=ddlcenter]').val().toString() == "") {
                 ErrMsg += 'Please select centre.\n';
             }                                   
                           
             $('[id$=hdnCentre]').val('');
             $('[id$=hdnDepartmentValue]').val('');
             $('[id$=hdnCentre]').val($('[id$=ddlcenter]').val().toString());
             $('[id$=ddlDepartment]').val().toString();
             $('[id$=hdnDepartmentValue]').val($('[id$=ddlDepartment]').val().toString());
             $('[id$=hdnPanelID]').val('');
             $('[id$=hdnPanelID]').val($('[id$=lstpanellist]').val().toString());
             $('[id$=hdnItemId]').val('');
             $('[id$=hdnItemId]').val($('[id$=ddlInvestigations]').val().toString());
             //  alert($('[id$=hdnDepartmentValue]').val());
             if (ErrMsg.length > 0) {
                 //alert(ErrMsg);
                 toast("Error", ErrMsg, "");
                 return false;
             }
         }

     
    </script>
 
</form>
</body>
</html>