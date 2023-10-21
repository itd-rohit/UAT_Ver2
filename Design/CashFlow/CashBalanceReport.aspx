<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CashBalanceReport.aspx.cs" Inherits="Design_CashFlow_CashBalanceReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />

    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript">
        $(function () {
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
        });
    </script>
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            <strong>Cash Balance Report<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 20%">Business Zone :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" Width="280px" class="ddlBusinessZone chosen-select">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right; width: 20%">State :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlState" runat="server" Width="190px" onchange="bindCentre('1')" class="ddlState chosen-select">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Type :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlType" runat="server" onchange="bindCentre('0')" Width="280px" class="ddlType chosen-select">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right; width: 20%">As On Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtDate" runat="server" Width="100px" onchange="ChkDate();"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        <asp:TextBox ID="txtTime" runat="server" MaxLength="10" Width="75px" ToolTip="Enter Time" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtTime">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right"><b>Centre :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:ListBox ID="lstCenterList" CssClass="multiselect" SelectionMode="Multiple" Width="340px" runat="server" ClientIDMode="Static" onchange="bindSearchType(0)"></asp:ListBox>
                    </td>
                    <td style="width: 20%; text-align: right"><b>Employee :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:ListBox ID="lstEmployee" CssClass="multiselect" SelectionMode="Multiple" Width="360px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <input type="button" class="searchbutton" id="btnSearch" value="Search" onclick="SearchReport()" />
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=lstCenterList],[id*=lstEmployee]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        function bindState() {
            jQuery("#lblMsg").text('');
            jQuery("#ddlState option").remove();
            if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(0,jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);
            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlState').trigger('chosen:updated');
        }
        function onFailureState() {
        }
    </script>
    <script type="text/javascript">
        function bindCentre(con) {
            if (jQuery("#ddlBusinessZone").val() == 0 && con == 0) {
                jQuery("#lblMsg").text('Please Select Business Zone');
                jQuery("#ddlBusinessZone").focus();
                return;
            }
            if (jQuery("#ddlState").val() == 0 && con == 0) {
                jQuery("#lblMsg").text('Please Select State');
                jQuery("#ddlState").focus();
                return;
            }
            if (jQuery("#ddlType").val() != 0 && jQuery("#ddlBusinessZone").val() != 0 && jQuery("#ddlState").val() != 0)
                PageMethods.bindCentre(jQuery("#ddlType").val(), jQuery("#ddlBusinessZone").val(), jQuery("#ddlState").val(), onSucessCentre, onFailureCentre);
        }
        function onSucessCentre(result) {
            var CentreData = jQuery.parseJSON(result);
            jQuery('#lstCenterList').empty();
            jQuery("#lstCenterList").multipleSelect('refresh');
            for (i = 0; i < CentreData.length; i++) {
                jQuery('#lstCenterList').append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
            }
            jQuery('#lstCenterList').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function onFailureCentre(result) {
        }
    </script>
    <script type="text/javascript">
        function onSucessSearchType(result) {
            jQuery("#lstEmployee option").remove();
            jQuery("#lstEmployee").multipleSelect('refresh');
            var empData = jQuery.parseJSON(result);
            if (empData != null) {
                for (var a = 0; a <= empData.length - 1; a++) {
                    jQuery('#lstEmployee').append(jQuery("<option></option>").val(empData[a].ID).html(empData[a].Name));
                }
            }
            jQuery('#lstEmployee').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function bindSearchType() {
            var CentreID = jQuery("#lstCenterList").val();
            if (CentreID != "")
                PageMethods.bindSearchType(CentreID, onSucessSearchType, onFailureSearch);
            else {
                jQuery("#lstEmployee option").remove();
                jQuery("#lstEmployee").multipleSelect('refresh');
            }
        }
        function onFailureSearch() {
            jQuery.unblockUI();
        }
    </script>
    <script type="text/javascript">
        function SearchReport() {
            var EmployeeID = jQuery("#lstEmployee").val();
            var CentreID = jQuery("#lstCenterList").val();
            if (EmployeeID != "" && CentreID != "") {
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                PageMethods.bindSearchReport(EmployeeID,CentreID, jQuery('#txtDate').val(), jQuery('#txtTime').val(), onSucessReport, onFailureSearch);
            }
            else {
            }
        }
        function onSucessReport(result) {
            if (result == 1)
                window.open('../common/ExportToExcel.aspx');
            else
                jQuery("#lblMsg").text("No Record Found");
            jQuery.unblockUI();
        }

        function ChkDate() {
            PageMethods.getDate(jQuery('#txtDate').val(), onSucessDate, onFailureDate);
        }
        function onSucessDate(result) {
            if (result != "")
                jQuery('#txtTime').val(result);
        }
        function onFailureDate() {

        }
    </script>

</asp:Content>

