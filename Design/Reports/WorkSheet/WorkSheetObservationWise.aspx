<%@ Page Title="" Language="C#"  EnableEventValidation="false" AutoEventWireup="true" CodeFile="WorkSheetObservationWise.aspx.cs" Inherits="Design_Reports_WorkSheet_WorkSheetObservationWise" %>

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
         
        <asp:HiddenField ID="hdnDepartmentValue" runat="server" />
    <asp:HiddenField ID="hdnCentre" runat="server" />
              <asp:HiddenField ID="hdnItemId" runat="server"  />
    <div class="POuter_Box_Inventory">
    <div class="row">
    <div class="col-md-24" style="text-align:center;">
    <b> WorkSheet Observation Wise</b>  
    <br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />  
    </div>
    </div>
    </div>
      <div class="POuter_Box_Inventory">
     <div class="Purchaseheader">
     Report Critaria
    </div>
           <div class="row">
              <div class="col-md-4"><label class="pull-right"> From Date :</label></div>
                <div class="col-md-2">
                     <asp:TextBox ID="dtFrom" runat="server"></asp:TextBox></div>
                    <div class="col-md-2">
                <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom"  Format="dd-MMM-yyyy"  PopupButtonID="dtFrom" />
                   
                 <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                         AcceptAMPM="false" AcceptNegative="None" MaskType="Time"> </cc1:MaskedEditExtender>
                
                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime" ControlExtender="mee_txtFromTime" ControlToValidate="txtFromTime" InvalidValueMessage="*"  />
                </div>
                <div class="col-md-4"><label class="pull-right">To Date :</label></div>
                <div class="col-md-2"><asp:TextBox ID="dtTo" runat="server"></asp:TextBox></div>
                    <div class="col-md-2">
                <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtTo"   Format="dd-MMM-yyyy"  PopupButtonID="dtTo" />
                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                         AcceptAMPM="false" AcceptNegative="None" MaskType="Time"> </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime" ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"   InvalidValueMessage="*"  ></cc1:MaskedEditValidator></div>
                          <div class="col-md-4"><label class="pull-right">Lab No:</label> </div>
                <div class="col-md-4">  <asp:TextBox ID="txtLabNo" runat="server" ToolTip="Lab No" MaxLength="12" CssClass="ItDoseTextinputText" /></div>
               </div>
   
           <div class="row">
   
                <div class="col-md-4"><label class="pull-right">Patient Name:</label></div>
                <div class="col-md-4"><asp:TextBox ID="txtPName" runat="server" CssClass="ItDoseTextinputText" ToolTip="Patient Name" MaxLength="20"/>
                  </div>
      
              <div class="col-md-4"><label class="pull-right">From Lab No:</label>
                  </div>
                <div class="col-md-4">  <asp:TextBox ID="txtFromLabNo" runat="server" ToolTip="From Lab No" MaxLength="12" CssClass="ItDoseTextinputText" />
                  </div>
                <div class="col-md-4"><label class="pull-right">To Lab No.:</label> </div>
                <div class="col-md-4"> <asp:TextBox ID="txtToLabNo" runat="server" CssClass="ItDoseTextinputText" ToolTip="To Lab No" MaxLength="12"/> </div>
               </div>          
         
                 <div class="row">
              <div class="col-md-4"><label class="pull-right">Center:</label></div>
              <div class="col-md-4"><asp:ListBox ID="chlCentre" runat="server"  ClientIDMode="Static"  CssClass="multiple" SelectionMode="Multiple"></asp:ListBox> </div>
           
              <div class="col-md-4"><label class="pull-right">Department :</label></div>
               <div class="col-md-4"><asp:ListBox ID="ddlDepartment" CssClass="multiselect"  ClientIDMode="Static" SelectionMode="Multiple"  runat="server" onchange="BindInvestigations()"></asp:ListBox></div>
               <div class="col-md-4"><label class="pull-right">Investigation :</label></div>
               <div class="col-md-4"><asp:ListBox ID="ddlInvestigations" CssClass="multiple" SelectionMode="Multiple" ClientIDMode="Static" runat="server"></asp:ListBox></div>
              </div> 
             <div class="row">
            
                <div class="col-md-4"><label class="pull-right"> Status :</label>
                  </div>
                <div class="col-md-4"> <asp:DropDownList ID="ddlStatus" runat="server">
                            
                                    <asp:ListItem></asp:ListItem>
                                    <asp:ListItem Value="Approved">Approved</asp:ListItem>
                                    <asp:ListItem Value="NotApproved">Not Approved</asp:ListItem>
                                    <asp:ListItem Value="ResultDone">Result Done</asp:ListItem>
                                    <asp:ListItem Value="Incomplete">Incomplete</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="ResultNotDone">Result Not Done</asp:ListItem>                                  
                                    <asp:ListItem Value="Hold">Hold</asp:ListItem>                                                                                                
                            </asp:DropDownList>
                  </div>
                  <div class="col-md-4">
                        <label class="pull-right">Panel : </label>
                       
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select"></asp:DropDownList>
                    </div>
               </div> 
    </div> 
    <div class="POuter_Box_Inventory" style="text-align:center;">
        <div class="row">
            <div class="col-md-24">
                <asp:Button ID="btnPreview" runat="server" Text="Report" OnClientClick="return ValidateData();" OnClick="btnPreview_Click" CssClass="ItDoseButton" />
            </div>
        </div>               
    </div>
          <script type="text/javascript">
              $(function () {
              
                  $('[id$=chlCentre]').multipleSelect({
                      includeSelectAllOption: true,
                      filter: true, keepOpen: false
                  });
                  $('[id$=ddlDepartment]').multipleSelect({
                      includeSelectAllOption: true,
                      filter: true, keepOpen: false
                  });
                  $('[id$=ddlInvestigations]').multipleSelect({
                      includeSelectAllOption: true,
                      filter: true, keepOpen: false
                  });
             
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
              jQuery('#chlCentre').trigger('chosen:updated');
              jQuery('#ddlInvestigations').trigger('chosen:updated');
              jQuery('#ddlDepartment').trigger('chosen:updated');
              jQuery('#ddlPanel').trigger('chosen:updated');
              BindInvestigations();
              });
              function BindInvestigations() {

                  $('[id$=ddlInvestigations]').find('option').remove();
                  var DeptId = $('[id$=ddlDepartment]').val().toString();

                  if (DeptId != "0") {
                      var $ddlInv = $('#ddlInvestigations');
                      $("#ddlInvestigations option").remove();
                      serverCall('WorkSheetObservationWise.aspx/BindInvestigations', { DeptId: DeptId }, function (response) {
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
                      $('[id$=ddlInvestigations]').find('option').remove();

                  }
              }
              function ValidateData() {
                  flag = true;
                  var ErrMsg = '';


                  if ($('[id$=chlCentre]').val().toString() == "") {
                      ErrMsg += 'Please select centre.\n';
                  }
                  $('[id$=hdnCentre]').val('');
                  $('[id$=hdnDepartmentValue]').val('');
                  $('[id$=hdnCentre]').val($('[id$=chlCentre]').val().toString());
                  $('[id$=ddlDepartment]').val().toString();
                  $('[id$=hdnDepartmentValue]').val($('[id$=ddlDepartment]').val().toString());
                  //$('[id$=hdnPanel]').val().toString();
                  //$('[id$=hdnPanelValue]').val($('[id$=ddlPanel]').val().toString());
                  $('[id$=hdnItemId]').val('');
                  $('[id$=hdnItemId]').val($('[id$=ddlInvestigations]').val().toString());
                
                  if (ErrMsg.length > 0) {
                      toast("Error", ErrMsg, "");
                      return false;
                  }
              }
                  </script>
</form>
</body>
</html>

