<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StockStatusReport.aspx.cs" Inherits="Design_Store_StockStatusReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Stock Status Report</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Location Detail</div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Current Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="ddllocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Item Detail
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val().toString())"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Department Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val().toString())"></asp:ListBox>

                </div>
 </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Item Category</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Items</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                </div>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Other Detail
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:CheckBox ID="ck" runat="server" Text="Manufacture" Font-Bold="true" onclick="bindmm()" /></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:DropDownList ID="ddlmanu" runat="server"></asp:DropDownList>
                </div>
               
                    <div class="col-md-3">
                        <label class="pull-left">Machine</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:DropDownList ID="ddlmachine" runat="server" ></asp:DropDownList>
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <input type="button" class="searchbutton" value="PDF Report" onclick="getReport('PDF')" />
                    <input type="button" class="searchbutton" value="Excel Report" onclick="getReport('Excel')" />
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id*=ddlcategory]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddllocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlsubcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddlmanu.ClientID%>').append($("<option></option>").val("0").html(""));
                bindmachine();
                bindCatagoryType();
            });
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
    <script type="text/javascript">
        function bindmm() {
            if ($('#<%=ck.ClientID%>').prop('checked') == true) {
                    bindManufacture();
                }
                else {
                    var ddlManufacturingCompany = $('#<%=ddlmanu.ClientID%>');
                    ddlManufacturingCompany.empty();
                    ddlManufacturingCompany.append($("<option></option>").val("0").html(""));
                }
            }
            function bindManufacture() {
                var ddlManufacturingCompany = $('#<%=ddlmanu.ClientID%>');
            ddlManufacturingCompany.empty();
            serverCall('Services/StoreCommonServices.asmx/bindManufacture', {}, function (response) {
                ddlManufacturingCompany.bindDropDown({ defaultValue: 'Select Manufacture', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
            });
        }
        function bindmachine() {
            var ddlMachineName = $('#<%=ddlmachine.ClientID%>');
            ddlMachineName.empty();
            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                ddlMachineName.bindDropDown({ defaultValue: 'Select Machine', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
            });
        }
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
                jQuery("#ddlcattype").bindMultipleSelect({  data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: jQuery("#ddlcattype") });
            });
        }
        function bindSubcattype(CategoryTypeID) {
            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");
            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeID != "") {
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID }, function (response) {
                    jQuery("#ddlsubcattype").bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: jQuery("#ddlsubcattype") });
                });
            }
            binditem();
        }
        function bindCategory(SubCategoryTypeMasterId) {
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");
            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (SubCategoryTypeMasterId != "") {
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId }, function (response) {
                    jQuery("#ddlcategory").bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: jQuery("#ddlcategory") });
                });
            }
            binditem();
        }
        function binditem() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error","Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            var LocationID= $('#<%=ddllocation.ClientID%>').val().toString();
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    serverCall('StockStatusReport.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, CategoryId: CategoryId, LocationID: LocationID }, function (response) {
                        jQuery("#ddlItem").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: jQuery("#ddlItem") });
                    });
                }
            }
        }
    </script>
    <script type="text/javascript">
        function getReport(reportType) {
            var locations = $("#ddllocation").val().toString();
            var Items = $("#ddlItem").val().toString();
            var manu = $("#<%=ddlmanu.ClientID%>").val();
            var machine = $("#<%=ddlmachine.ClientID%>").val();
            serverCall('StockStatusReport.aspx/getreport', { location: locations, Items: Items, manu: manu, machine: machine, reportType: reportType }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.ItemID = JSON.parse(response).ItemID;
                    $objData.ManufactureID = JSON.parse(response).ManufactureID;
                    $objData.MacID = JSON.parse(response).MacID;
                    $objData.LocationID = JSON.parse(response).LocationID;
                    $objData.ReportType = JSON.parse(response).ReportType;
                    $objData.ReportDisplayName = JSON.parse(response).ReportDisplayName;
                    $objData.IsAutoIncrement = JSON.parse(response).IsAutoIncrement;
                    PostFormData($objData, JSON.parse(response).ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });
        }
    </script>
</asp:Content>

