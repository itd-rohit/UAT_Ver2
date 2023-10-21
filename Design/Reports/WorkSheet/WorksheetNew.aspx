<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WorksheetNew.aspx.cs" EnableEventValidation="false" Inherits="Design_Lab_WorksheetNew" %>

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
 
             
    <script type="text/javascript"></script>
    <asp:HiddenField ID="hdnChkValue" runat="server" />
    <asp:HiddenField ID="hdnDepartmentValue" runat="server" />
    <asp:HiddenField ID="hdnCentre" runat="server" />
   
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Pathology Check List</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>      
            <div>
               
                 <div class="row">
                    <div class="col-md-4"><label class="pull-right">From Date :</label></div>
                     <div class="col-md-2">  <asp:TextBox ID="dtFrom" runat="server" ></asp:TextBox></div>
                          <div class="col-md-2"> 
                                <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" />

                                <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>

                                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                    ControlExtender="mee_txtFromTime"
                                    ControlToValidate="txtFromTime"
                                    InvalidValueMessage="*" /></div>
                     <div class="col-md-4"><label class="pull-right">To Date :</label></div>
                     <div class="col-md-2"> <asp:TextBox ID="dtTo" runat="server" ></asp:TextBox></div>
                         <div class="col-md-2">
                                <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtTo" Format="dd-MMM-yyyy" PopupButtonID="dtTo" />
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                    ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                                    InvalidValueMessage="*"></cc1:MaskedEditValidator></div>
                   
                     </div>
                    <div class="row">
                           <div class="col-md-4"><label class="pull-right"> Booking Centre :</label></div>
                    <div class="col-md-4"> <asp:ListBox ID="chlCentre" runat="server"  ClientIDMode="Static"  CssClass="multiple" SelectionMode="Multiple"></asp:ListBox> </div>
                    <div class="col-md-4"><label class="pull-right">Department :</label></div>
                     <div class="col-md-4"><asp:ListBox ID="ddlDepartment" CssClass="multiselect"  ClientIDMode="Static" SelectionMode="Multiple"  runat="server" onchange="BindInvestigations()"></asp:ListBox>
                                <asp:HiddenField ID="hdnItemId" runat="server"  /></div>
                     <div class="col-md-4"><label class="pull-right">Investigations :</label></div>
                     <div class="col-md-4"> <asp:ListBox ID="ddlInvestigations" CssClass="multiple" SelectionMode="Multiple" ClientIDMode="Static" runat="server"></asp:ListBox></div>
                     </div>
                <div class="row">
                    <div class="col-md-4"><label class="pull-right">HLM Type :</label></div>
                    <div class="col-md-4"><asp:DropDownList ID="ddlhlmtype"  runat="server">
                                    <asp:ListItem Value="0">--Select--</asp:ListItem>

                                    <asp:ListItem Value="OPD">OPD</asp:ListItem>
                                    <asp:ListItem Value="IPD">IPD</asp:ListItem>
                                    <asp:ListItem Value="ICU">ICU</asp:ListItem>
                                </asp:DropDownList></div>
                  <div class="col-md-4"><label class="pull-right">OutSource Lab :</label></div>
                    <div class="col-md-4">  <asp:ListBox runat="server" CssClass="multiple" ClientIDMode="Static" SelectionMode="Multiple" ID="ddlOutsourceLabs"></asp:ListBox></div>
                    <div class="col-md-4"><label class="pull-right">Tag Processing Lab</label> </div>
                    <div class="col-md-4"><asp:ListBox CssClass="multiple"  ClientIDMode="Static" SelectionMode="Multiple" ID="ddlTagProcessingLab" runat="server"></asp:ListBox></div>
               
                    </div>
                 <div class="row">
                     <div class="col-md-4"></div>
                    <div class="col-md-20"><asp:RadioButton ID="chkSampleCollected" GroupName="A" Checked="true" ToolTip="Include Sample Collected" Text="Sample Collected" runat="server" />
                                <asp:RadioButton ID="chkDepartmentReceived" GroupName="A" ToolTip="Include Department Received" Text="Department Received" runat="server" />
                                <asp:RadioButton ID="chkResultNotDone" GroupName="A" ToolTip="IncludeResultNotDone" Text="Test Pending" runat="server" />
                                <asp:RadioButton ID="chkUnapprove" GroupName="A" ToolTip="Include Unappprove" Text="Unappprove" runat="server" />

                                <asp:RadioButton ID="chkOutsource" GroupName="A" ToolTip="OutSource Only" Text="OutHouse Only" Style="display: none;" runat="server" />

                                <asp:RadioButton ID="chkAllPatient" GroupName="A" ToolTip="All Patient" Text="All Patients" runat="server" /></div>
                     
                     </div>
              
            </div>                                           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                     <div class="col-md-4">   <asp:RadioButtonList runat="server" ID="rd1" RepeatDirection="Horizontal" Style="font-weight: 700">
                                    <asp:ListItem Value="1" Selected="True">PDF</asp:ListItem>
                                    <asp:ListItem Value="2">Excel</asp:ListItem>
                                </asp:RadioButtonList></div>
                 <div class="col-md-16">
            <asp:Button ID="btnPreview" runat="server" Text="Report" OnClick="btnPreview_Click" OnClientClick="return ValidateData();" CssClass="ItDoseButton" />
                     </div>
                 <div class="col-md-4"></div>
                </div>

        </div>    
     <script type="text/javascript">
         $(function () {
             $('[id$=ddlDepartment]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id$=chlCentre]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id$=ddlOutsourceLabs]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id$=ddlInvestigations]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id$=ddlTagProcessingLab]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });          

             if ($('#ContentPlaceHolder1_hdnCentre').val() != '') {
                 var data = [];
                 data = $('#ContentPlaceHolder1_hdnCentre').val();
             }

            // bindAllCentre();
             if ($('#ContentPlaceHolder1_hdnItemId').val() != '') {
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
             jQuery('#chlCentre').trigger('chosen:updated');

             jQuery('#ddlOutsourceLabs').trigger('chosen:updated');
             jQuery('#ddlInvestigations').trigger('chosen:updated');
             jQuery('#ddlTagProcessingLab').trigger('chosen:updated');
             BindInvestigations();
         });
         function BindInvestigations() {
     
             $('[id$=ddlInvestigations]').find('option').remove();
             var DeptId = $('[id$=ddlDepartment]').val().toString();
             
             if (DeptId != "0") {
                 var $ddlInv = $('#ddlInvestigations');
                 $("#ddlInvestigations option").remove();
                 serverCall('WorksheetNew.aspx/BindInvestigations', { DeptId: DeptId }, function (response) {
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
         function GetItemId() {
             var ItemId = $('[id$=ddlInvestigations]').val();
             $('[id$=hdnItemId]').val(ItemId);           
         }              
        function bindtype1() {

            jQuery('#ddlType1 option').remove();

            serverCall('WorksheetNew.aspx/gettype1', { }, function (response) {
                var typedata = $.parseJSON(response);            
                $("#ddlType1").prepend("<option value='' selected='selected'>Select Centre Type</option>");
                for (var a = 0; a <= typedata.length - 1; a++) {
                    jQuery('#ddlType1').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));

                }
                $('#ddlType1').find('option[value=7]').remove();
            });
        }

        function bindAllCentre() {
           // debugger
          //  jQuery('#chlCentre option').remove();
            serverCall('WorksheetNew.aspx/bindCentre', {}, function (response) {
                var centreData = jQuery.parseJSON(response);
                if (centreData != '') {
                    for (var i = 0; i < centreData.length; i++) {
                        jQuery('#chlCentre').append($("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                    }
                    $('[id$=chlCentre]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                }
            });                                                     
        }
        function SelectAll() {

            $('#chlCentre').find('input[type=checkbox]').each(function () {
                if ($('[id$=chkCentreAll]').is(':checked')) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }
            });
        }

        function ValidateData() {                     
            flag = true;
            var ErrMsg = '';
         
            if ($('[id$=ddlCentreType]').val() == "0") {
                ErrMsg += 'Please select centre type.\n';
            }
          
            if ($('[id$=chlCentre]').val().toString() == "")
            {
                ErrMsg += 'Please select centre.\n';
            }
            if ($('[id$=chkSampleCollected]').is(':checked') || $('[id$=chkDepartmentReceived]').is(':checked') || $('[id$=chkResultNotDone]').is(':checked') || $('[id$=chkUnapprove]').is(':checked') || $('[id$=chkOutsource]').is(':checked') || $('[id$=chkAllPatient]').is(':checked')) {

            }
            else {
                ErrMsg += "Please choose any search criteria. \n";
            }
            $('[id$=hdnChkValue]').val('');
            var OutSource = $('[id$=ddlOutsourceLabs]').val().toString();
            var TagProcess = $('[id$=ddlTagProcessingLab]').val().toString();
            if (OutSource.length > 1 && TagProcess.length > 1) {
                ErrMsg += "Please select either outsource or Tag processing lab. \n";
                $('[id$=hdnChkValue]').val('');
            }
            else {
                if (OutSource != "") {
                    $('[id$=hdnChkValue]').val(OutSource);
                }
                if (TagProcess != "") {
                    $('[id$=hdnChkValue]').val(TagProcess);
                }

            }
            $('[id$=hdnCentre]').val('');
            $('[id$=hdnDepartmentValue]').val('');
            $('[id$=hdnCentre]').val($('[id$=chlCentre]').val().toString());
            $('[id$=ddlDepartment]').val().toString();
            $('[id$=hdnDepartmentValue]').val($('[id$=ddlDepartment]').val().toString());
            $('[id$=hdnItemId]').val('');
            $('[id$=hdnItemId]').val($('[id$=ddlInvestigations]').val().toString());
            //  alert($('[id$=hdnDepartmentValue]').val());
            if (ErrMsg.length > 0) {
                toast("Error", ErrMsg, "");
                return false;
            }
        }

       
        function chkValue() {
            $('[id$=hdnChkValue]').val('');
            var value = "";
            var LabOut = "";
            $('[id$=ddlOutsourceLabs]').find('td').each(function () {

                if ($(this).find('input[type=checkbox]').is(':checked')) {
                    LabOut = $(this).find('input').val().split('#')[1];
                    if (LabOut == "Outsource") {
                        value += $(this).find('input').val().replace('#Outsource', '') + ",";
                    }
                    else {
                        value += $(this).find('input').val().replace('#Lab', '') + ",";
                    }
                }
            });

            value = value + "#" + LabOut;
            if (value.length > 4)
                $('[id$=hdnChkValue]').val(value);
        }
        $(document).ready(function () {
            //  bindtype1();
            $('[id$=ddlOutsourceLabs]').find('td').each(function () {
                var LabOut = $(this).find('input').val().split('#')[1];
                $(this).find('input').attr('onchange', 'validatecheck(this)');
                if (LabOut == "Lab") {
                    $(this).find('input').next().css('color', 'blue');
                }
                else {
                    $(this).find('input').next().css('color', 'Green');

                }

            });
        });
        function validatecheck(ctrl) {
            var Arr = new Array();
            var LabOutChecked = $(ctrl).val().split('#')[1];
            $('[id$=ddlOutsourceLabs]').find('td').each(function () {
                if ($(this).find('input[type=checkbox]').is(':checked')) {
                    Arr.push($(this).find('input[type=checkbox]').val().split('#')[1]);

                }
            });
            var ctr = 0;
            for (var i = 0; i < Arr.length; i++) {
                if (Arr[i] == LabOutChecked) {
                    ctr++;
                }
            }

            if (ctr != Arr.length) {
                alert('Please select only similar type of labs');
                $(ctrl).prop('checked', false);
                return false;
            }
        }
        var LabChecked = true;
        function selectAllLab() {
            $('[id$=ddlOutsourceLabs]').find('td').each(function () {
                if ($(this).find('input[type=checkbox]').val() != undefined) {
                    var LabOut = $(this).find('input[type=checkbox]').val().split('#')[1];
                    if (LabOut == "Lab") {
                        if (LabChecked) {
                            $(this).find('input[type=checkbox]').attr('checked', 'checked');
                        }
                        else {
                            $(this).find('input[type=checkbox]').removeAttr('checked');
                        }
                    }
                    else {
                        $(this).find('input[type=checkbox]').removeAttr('checked');

                    }
                }
            });
            if (LabChecked) {
                LabChecked = false;
                outsourceChecked = false;
            }
            else {
                LabChecked = true;
                outsourceChecked = true;
            }
        }

        var outsourceChecked = true;
        function selectAllOutsource() {
            $('[id$=ddlOutsourceLabs]').find('td').each(function () {
                if ($(this).find('input[type=checkbox]').val() != undefined) {
                    var LabOut = $(this).find('input[type=checkbox]').val().split('#')[1];
                    if (LabOut == "Outsource") {
                        if (outsourceChecked) {
                            $(this).find('input[type=checkbox]').attr('checked', 'checked');
                        }
                        else {
                            $(this).find('input[type=checkbox]').removeAttr('checked');
                        }
                    }
                    else {
                        $(this).find('input[type=checkbox]').removeAttr('checked');
                    }
                }
            });
            if (outsourceChecked) {
                outsourceChecked = false;
                LabChecked = false;
            }
            else {
                outsourceChecked = true;
                LabChecked = true;
            }
        }       
    </script>
</form>
</body>
</html>

