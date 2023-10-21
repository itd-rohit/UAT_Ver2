<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UnConsumeReport.aspx.cs" Inherits="Design_Store_ConsumeReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>UnConsume Report</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Location Details</div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">CentreType</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val().toString())"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Location</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
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
                    <label class="pull-left">SubCategory Type</label>
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
                    <label class="pull-left">Machine</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="ddlmachine" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="binditem()"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Items</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                <div class="col-md-3">
                  
                </div>
                <div class="col-md-9">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Report Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:RadioButtonList ID="radsummary" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Selected="true" Value="0">Detail</asp:ListItem>
                        <asp:ListItem Value="1">Item Summary</asp:ListItem>
                        <asp:ListItem Value="2">Amt Summary</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" value="PDF Report" class="searchbutton" onclick="getReport('PDF')" />
                <input type="button" value="Excel Report" class="searchbutton" onclick="getReport('Excel');" />

            </div>
        </div>
        <script type="text/javascript">
            $(function () {
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=lstState]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=lstCentre]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=ddlcategory]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=ddlItem]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=ListCentre]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=ListItem]').multipleSelect({
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
                $('[id*=lstCentreType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                }); $('[id*=lstlocation]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=lstCentrecity]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $('[id*=ddlmachine]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                bindCatagoryType();
                bindcentertype();
                bindZone();
                bindmachine();
            });
        </script>
        <script type="text/javascript">
            function bindCatagoryType() {
                jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
                jQuery("#ddlcattype").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: jQuery("#ddlcattype") });
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
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            var machineid = $('#ddlmachine').val().toString();

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeId != "") {
                serverCall('ItemLocationMapping.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, CategoryId: CategoryId, machineid: machineid }, function (response) {
                    jQuery("#ddlItem").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: jQuery("#ddlItem") });
                });
            }
        }
        </script>
        <script type="text/javascript">
            function bindcentertype() {
                jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery("#lstCentreType").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: jQuery("#lstCentreType") });
            });
        }
        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery("#lstZone").bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery("#lstZone") });
            });
        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    jQuery("#lstState").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery("#lstState") });
                });
            }
            bindCentrecity();
        }
        function bindCentrecity() {
            var StateID = jQuery('#lstState').val().toString();
            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery("#lstCentrecity").bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: jQuery("#lstCentrecity") });
            });
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {
                    jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery("#lstCentre") });
                });
            }
            bindlocation();
        }
        function bindmachine() {
            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#ddlmachine').multipleSelect("refresh");

            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                jQuery("#ddlmachine").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: jQuery("#ddlmachine") });
            });


        }
        function bindlocation() {

            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();

            var centreid = jQuery('#lstCentre').val().toString();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid: centreid, StateID: StateID, TypeId: TypeId, ZoneId: ZoneId, cityId: cityId }, function (response) {
                jQuery("#lstlocation").bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: jQuery("#lstlocation") });
            });
        }
        </script>
        <script type="text/javascript">
            function getReport(reportType) {
                var CategoryTypeId = $('#ddlcattype').val().toString();
                var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
                var CategoryId = $('#ddlcategory').val().toString();
                var machineid = $('#ddlmachine').val().toString();
                var itemid = $('#<%=ddlItem.ClientID%>').val().toString();
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();
            serverCall('UnConsumeReport.aspx/GetReport', { type: $('#<%=radsummary.ClientID%> input:checked').val(), fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), categorytypeid: CategoryTypeId, subcategorytypeid: SubCategoryTypeId, subcategoryid: CategoryId, itemid: itemid, locationid: locationid, machineid: machineid, reportType: reportType }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                   

                    var $objData = new Object();
                    $objData.Type = JSON.parse(response).Type;
                    $objData.ManufactureID = JSON.parse(response).ManufactureID;
                    $objData.FromDate = JSON.parse(response).FromDate;
                    $objData.ToDate = JSON.parse(response).ToDate;
                    $objData.CategoryTypeID = JSON.parse(response).CategoryTypeID;
                    $objData.SubCategoryTypeID = JSON.parse(response).SubCategoryTypeID;
                    $objData.SubCategoryID = JSON.parse(response).SubCategoryID;
                    $objData.ItemID = JSON.parse(response).ItemID;

                    $objData.LocationID = JSON.parse(response).LocationID;
                    $objData.MachineID = JSON.parse(response).MachineID;
                   
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

