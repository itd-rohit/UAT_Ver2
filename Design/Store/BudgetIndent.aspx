<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="BudgetIndent.aspx.cs" Inherits="Design_Store_BudgetIndent" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">    
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Budget Indent</b><br />
            <asp:Label ID="lblError" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Category Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCategoryType" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Manufacture   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstManufacture" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Zone  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Sub Category Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstSubCategory" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox></td>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Machine  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstMachine" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Item Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstItemType" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox></td>
                 
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Item</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstItemGroup" runat="server" CssClass="multiselect " SelectionMode="Multiple"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <input id="btnMoreFilter" class="ItDoseButton" onclick="showSearch();" style="font-weight: bold;" type="button" value="More Filter" /></td>
              
                </div>
            </div>
            <div class="row divSearchInfo" style="display: none;" id="divSearch">
                <div style="background-color: papayawhip">
                    <div class="Purchaseheader">
                        Search Option
                    </div>
                    <div class="col-md-3" style="margin: 10px 0px">
                        <label class="pull-left">City</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="margin: 10px 0px">
                        <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                    </div>

                    <div class="col-md-5" style="margin: 10px 0px">
                        <asp:ListBox ID="lstCity" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                    </div>
                    <div class="col-md-3" style="margin: 10px 0px">
                        <input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />
                    </div>
                </div>

            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-3">
                    <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-3">
                    <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

            </div>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="searchbutton" onclick="searchData(0)" />&nbsp;&nbsp;
                        <input type="button" id="btnApprove" value="Approve" style="display: none" class="searchbutton" onclick="ApproveBudget()" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left; display: none" id="divBudgetSearch">
            <div id="divDetail" style="overflow: auto; height: 400px; text-align: center">
                <table border="1" id="mtable" style="width: 99%; border-collapse: collapse" class="GridViewStyle">
                    <thead>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div id="divLastIssueQty" style="display: none; position: absolute; text-align: left">
    </div>
    <asp:Label ID="lblApprovalCount" runat="server" Style="display: none"></asp:Label>
    <script type="text/javascript">
        function showSearch() {
            jQuery('.divSearchInfo').slideToggle("slow", "linear");
            jQuery('#divSearch').show();
            jQuery('#btnMoreFilter').hide();
            jQuery("#ddlCity_chosen").width("190px");
        }
        function hideSearch() {
            jQuery('.divSearchInfo').slideToggle("slow", "linear");
            jQuery('#divSearch').hide();
            jQuery('#btnMoreFilter').show();
            jQuery('#<%=lstCity.ClientID%> option').remove();
            jQuery('#lstCity').multipleSelect("refresh");
        }
    </script>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        jQuery(document).mousemove(function (e) {
            mouseX = e.pageX - 1100;
            mouseY = e.pageY;
            mouseZ = e.pageZ - 200;
        });
        function searchData(con) {
            jQuery("#lblError").text('');
            jQuery("#btnApprove").hide();
            jQuery("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            if (con == 0)
                

            var CentreType = jQuery('#lstCentreType').multipleSelect("getSelects").join();
            var CategoryType = jQuery('#lstCategoryType').multipleSelect("getSelects").join();
            var Manufacture = jQuery('#lstManufacture').multipleSelect("getSelects").join();
            var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
            var SubCategory = jQuery('#lstSubCategory').multipleSelect("getSelects").join();
            var Machine = jQuery('#lstMachine').multipleSelect("getSelects").join();
            var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
            var ItemType = jQuery('#lstItemType').multipleSelect("getSelects").join();
            var ItemIDGroup = jQuery('#lstItemGroup').multipleSelect("getSelects").join();
            var CityID = jQuery('#lstCity').multipleSelect("getSelects").join();
            serverCall('BudgetIndent.aspx/bindData', { CentreType: CentreType, CategoryType: CategoryType, Manufacture: Manufacture, ZoneID: ZoneID, SubCategory: SubCategory, Machine: Machine, StateID: StateID, ItemType: ItemType, ItemIDGroup: ItemIDGroup, FromDate: jQuery('#txtFromDate').val(), ToDate: jQuery('#txtToDate').val(), CityID: CityID }, function (response) {
                if (response != "")
                    onSuccessData(response);
                else {
                    toast("Error", 'No Rrecord found', "");
                    jQuery("#lblError").text('No Record Found');
                    jQuery("#divBudgetSearch,#divDetail").hide();
                    jQuery("#mtable thead").html('');
                    jQuery("#mtable tbody").html('');
                }
                jQuery("#btnSearch").removeAttr('disabled').val('Search');

            });
        }
        function onSuccessData(result) {
            var data = jQuery.parseJSON(result.d);
            var tblbody = [];
            var tblhead = [];
            var tblhrow = [];
            var count = 0;
            var ReqQty = 0;
            jQuery.each(data, function () {
                var tblrow = [];
                jQuery.each(this, function (k, v) {
                    if (k == 'SubCategoryType' || k == 'ItemID' || k == 'ItemType' || k == 'ItemName' || k == 'MachineName' || k == 'Manufacture' || k == 'PackSize' || k == 'PurchaseUnit' || k == 'Qty' || k == 'NetAmount') {
                        if (k == 'ItemID') {
                            tblrow.push("<td class='GridViewLabItemStyle' style='display: none;'>"); tblrow.push(v); tblrow.push("</td>");
                        }
                        else if (k == 'Qty' || k == 'NetAmount') {
                            tblrow.push("<td class='GridViewLabItemStyle "); tblrow.push(k); tblrow.push("' style='text-align: right;width:20px'>"); tblrow.push(v); tblrow.push("</td>");
                        }
                        else {
                            tblrow.push("<td class='GridViewLabItemStyle "); tblrow.push(k); tblrow.push("' style='text-align: left'>"); tblrow.push(v); tblrow.push("</td>");
                        }
                    }
                    else {
                        var ReqQty = v;
                        if (ReqQty == null) {
                            tblrow.push("<td class='GridViewLabItemStyle "); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("'></td>");
                        }
                        else
                            tblrow.push("<td class='GridViewLabItemStyle "); tblrow.push( k.substr(k.indexOf('#') + 1) ); tblrow.push( "'><div class='tooltip' > <span class='tooltiptext' >AverageConsumption " ); tblrow.push( k.split('#')[0] ); tblrow.push( "</span> "); tblrow.push(ReqQty.split('#')[1]); tblrow.push(" <input type='text' onkeypress='return checkForSecondDecimal(this,event);' onchange='updateBudgetIndent(this)'  style='width:70px' class='clBudgetQty ' id='"); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("' value='"); tblrow.push(ReqQty.split('#')[0]); tblrow.push("'/></div><span class='clBudgetIndent' style='display:none' id='"); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("'>"); tblrow.push(ReqQty); tblrow.push("</span><img src='../../App_Images/view.GIF' id='"); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("' style='cursor:pointer' onmouseover='viewLastIssueQty(this)' onmouseout='hideLastIssueQty()'/></td>");
                    }
                    if (k == 'SubCategoryType') {
                        count = count + 1;
                    }
                    if (count == 1) {
                        if (k == 'ItemID') {
                            tblhrow.push("<td style='width:150px; display: none;' class='GridViewHeaderStyle'>"); tblrow.push(k); tblrow.push("</td>");
                        }
                        else if (k == 'Qty' || k == 'NetAmount') {
                            tblhrow.push("<td style='width:30px;' class='GridViewHeaderStyle "); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("'>"); tblrow.push(k); tblrow.push("</td>");
                        }
                        else
                            tblhrow.push("<td style='width:100px;' class='GridViewHeaderStyle "); tblrow.push(k.substr(k.indexOf('#') + 1)); tblrow.push("'>"); tblrow.push(k); tblrow.push("</td>");
                    }
                })
                tblbody.push("<tr>" + tblrow.join("") + "</tr>");
            });
            tblhead.push("<tr>" + tblhrow.join("") + "</tr>");
            jQuery("#mtable thead").html(tblhead.join(""));
            jQuery("#mtable tbody").html(tblbody.join(""));
            jQuery("#divBudgetSearch,#divDetail").show();
            jQuery("#mtable").tableHeadFixer({
            });
            if (jQuery("#lblApprovalCount").text() == "1") {
                jQuery("#btnApprove").show();
            }
            else {
                jQuery("#btnApprove").hide();
            }
        }
        function OnfailureData(result) {
        }
        function hideLastIssueQty() {
            jQuery('#divLastIssueQty').hide();
        }
        function updateBudgetIndent(rowID) {
            var IndentNo = jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[2];
            var ApprovedQty = jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[8];
            var ItemID = jQuery(rowID).closest('tr').find('td:nth-child(2)').text();
            if (parseFloat(jQuery(rowID).val()) > parseFloat(ApprovedQty)) {                
                toast("Error", 'Budget Qty. Cannot Greater Then Approved Qty.', "");  
                jQuery(rowID).focus()
                return;
            }
            //jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.updateBudgetIndent(IndentNo, ItemID, jQuery(rowID).val(), onSuccessIndentData, OnfailureData, rowID);
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function onSuccessIndentData(result, rowID) {
            if (result == 1) {
                var totalQty = 0;
                jQuery(rowID).closest('tr').find(".clBudgetQty").each(function () {
                    var Qty = 0;
                    if (isNaN(jQuery(this).val()) || jQuery(this).val() == "")
                        Qty = 0;
                    else
                        Qty = jQuery(this).val();
                    totalQty = precise_round(totalQty, 5) + precise_round(jQuery(this).val(), 5);
                });
                jQuery(rowID).closest('tr').find(".Qty").text(totalQty);
                var Tax = jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[5];
                var rate = jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[3];
                var discper = jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[4];
                var discountAmout = precise_round((rate * discper * 0.01), 5);
                var ratedisc = precise_round((rate - discountAmout), 5);
                var tax = precise_round((ratedisc * Tax * 0.01), 5);
                var ratetaxincludetax = precise_round((ratedisc + tax), 5);
                var NetAmount = precise_round(parseFloat(ratetaxincludetax) * parseFloat(totalQty), 5);
                jQuery(rowID).closest('tr').find(".NetAmount").text(NetAmount);
            }
            else if (result == 2) {
                toast("Error", 'You do not have right to Access this page', "");              
                jQuery("#mtable thead").html('');
                jQuery("#mtable tbody").html('');
                jQuery("#divBudgetSearch,#divDetail,#btnApprove,#btnSearch").hide();
            }
            else {
                //showerrormsg('Error');
                toast("Error", 'Error', "");
            }
            
        }
        function viewLastIssueQty(rowID) {
            var url = "../../Design/Store/IndentLastIssueQty.aspx?ItemID=" + jQuery(rowID).closest('tr').find('td:nth-child(2)').text() + "&FromLocationID=" + jQuery(rowID).attr('id') + "&Rate=" + jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[3] + "&Tax=" + jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[5] + "&Disc=" + jQuery(rowID).closest('td').find(".clBudgetIndent").text().split('#')[4] + "";
            jQuery('#divLastIssueQty').load(url);
            jQuery('#divLastIssueQty').css({ 'top': mouseY, 'right': mouseX }).show();
        }
        function onSucessLastIssueQty(result) {
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (jQuery(sender).closest('td').find(".clBudgetIndent").text().split('#')[6] == "0") {
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            else {
                if ((charCode != 46 && sender.value.indexOf('.') != -1) && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            if (charCode == '46' && jQuery(sender).closest('td').find(".clBudgetIndent").text().split('#')[6] == "0") {
                return false;
            }
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstCategoryType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstManufacture]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            jQuery('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            jQuery('[id*=lstSubCategory]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstMachine]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstItemType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstItemGroup]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            jQuery('[id*=lstCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            bindcenterType();
            bindZone();
            bindCategoryType();
            bindManufacture();
            bindMachine();
        });
    </script>
    <script type="text/javascript">
        function bindMachine() {
            jQuery('#<%=lstMachine.ClientID%> option').remove();
            jQuery('#lstMachine').multipleSelect("refresh");
            StoreCommonServices.bindmachine(onSucessMachine, onFailureMachine);
        }
        function onSucessMachine(result) {
            jQuery('#lstMachine').bindMultipleSelect({ data: JSON.parse(result), valueField: 'ID', textField: 'NAME', controlID: jQuery('#<%=lstMachine.ClientID%>') });
            
        }
        function onFailureMachine() {
        }
        function bindcenterType() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            CommonServices.bindTypeLoad(onSucessCentreType, onFailureCentreType);
        }
        function onSucessCentreType(result) {
            var typedata = jQuery.parseJSON(result);
            jQuery('#lstCentreType').bindMultipleSelect({ data: JSON.parse(result), valueField: 'id', textField: 'type1', controlID: jQuery('#<%=lstCentreType.ClientID%>') });
                         
            
        }
        function onFailureCentreType() {
        }
        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            CommonServices.bindBusinessZone(onSucessBusinessZone, onFailureBusinessZone);

        }
        function onSucessBusinessZone(result) {
            var BusinessZoneID = jQuery.parseJSON(result);         
                jQuery('#lstZone').bindMultipleSelect({ data: JSON.parse(result), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery('#<%=lstZone.ClientID%>') });
                         
        }
        function onFailureBusinessZone() {

        }
        jQuery('#lstZone').on('change', function () {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            var BusinessZoneID = $(this).val();

            bindState(BusinessZoneID);
        });
        function bindState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                    jQuery("#lstState").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery("#lstState") });

                });
            }
        }
        function bindCategoryType() {
            jQuery('#<%=lstCategoryType.ClientID%> option').remove();
            jQuery('#lstCategoryType').multipleSelect("refresh");
            StoreCommonServices.bindcategory(onSucessCategoryType, onFailureCategoryType);
        }
        function onSucessCategoryType(result) {
            //var categoryData = jQuery.parseJSON(result);
            jQuery('#<%=lstCategoryType.ClientID%>').bindMultipleSelect({ data: JSON.parse(result), valueField: 'ID', textField: 'Name', controlID: jQuery("#<%=lstCategoryType.ClientID%>") });

        }
        function onFailureCategoryType() {

        }
        jQuery('#lstCategoryType').on('change', function () {
            jQuery('#<%=lstItemType.ClientID%> option').remove();
            jQuery('#lstSubCategory').multipleSelect("refresh");
            var CategoryTypeID = $(this).val();
            bindSubCategory(CategoryTypeID);
        });
        function bindSubCategory(CategoryTypeID) {
            if (CategoryTypeID != "") {
                serverCall('Services/StoreCommonServices.asmx/bindsubcategory', { categoryid: CategoryTypeID.toString() }, function (response) {
                    jQuery("#lstSubCategory").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: jQuery("#lstSubCategory") });
                });
            }
        }
        jQuery('#lstSubCategory').on('change', function () {
            jQuery('#<%=lstItemType.ClientID%> option').remove();
            jQuery('#lstItemType').multipleSelect("refresh");
            var SubCategoryID = $(this).val();
            bindItemType(SubCategoryID);
        });
        function bindItemType(SubCategoryID) {
            if (SubCategoryID != "") {
                serverCall('Services/StoreCommonServices.asmx/binditemtype', { subcategoryid: SubCategoryID.toString() }, function (response) {
                    jQuery("#lstItemType").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: jQuery("#lstItemType") });
                });
            }
        }

        jQuery('#lstItemType').on('change', function () {
            jQuery('#<%=lstItemGroup.ClientID%> option').remove();
            jQuery('#lstItemGroup').multipleSelect("refresh");
            var ItemTypeID = $(this).val();
            bindItemGroup(ItemTypeID);
        });
        function bindItemGroup(ItemTypeID) {
            if (ItemTypeID != "") {
                serverCall('BudgetIndent.aspx/bindItemGroup', { SubcategoryID: ItemTypeID.toString() }, function (response) {
                    jQuery("#lstItemGroup").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemIDGroup', textField: 'ItemNameGroup', controlID: jQuery("#lstItemGroup") });

                });
            }
        }
        function bindManufacture() {
            jQuery('#<%=lstManufacture.ClientID%> option').remove();
            jQuery('#lstManufacture').multipleSelect("refresh");
            StoreCommonServices.bindManufacture(onSucessManufacture, onFailureManufacture);
        }
        function onSucessManufacture(result) {
            jQuery('#<%=lstManufacture.ClientID%>').bindMultipleSelect({ data: JSON.parse(result), valueField: 'ID', textField: 'NAME', controlID: jQuery('#<%=lstManufacture.ClientID%>') });


        }
        function onFailureManufacture() {

        }

    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('#txtCity').bind("keydown", function (event) {
                if (event.keyCode === jQuery.ui.keyCode.TAB &&
                    jQuery(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
                if (jQuery('#lstState').multipleSelect("getSelects").join() == "") {                    
                    toast("Error", 'Please Select State', "");
                    jQuery('#lstState').focus();
                    jQuery('#txtCity').val('');
                    return;
                }
            })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindCityWithState", {
                              StateID: jQuery('#lstState').multipleSelect("getSelects").join(),
                              CityName: request.term
                          }, response);
                      },
                      search: function () {
                          // custom minLength                    
                          var term = this.value;
                          if (term.length < 3) {
                              return false;
                          }
                      },
                      focus: function () {
                          // prevent value inserted on focus
                          return false;
                      },
                      select: function (event, ui) {
                          if (jQuery("#lstCity option[value='" + ui.item.value + "']").length == 0) {
                              jQuery("#lstCity").append(jQuery("<option></option>").val(ui.item.value).html(ui.item.label));
                              jQuery('#lstCity').find(":checkbox[value='" + ui.item.value + "']").attr("checked", "checked");
                              jQuery("#lstCity option[value='" + ui.item.value + "']").attr("selected", 1);
                              jQuery('#lstCity').multipleSelect("refresh");
                          }
                          else {
                              toast("Error", 'City Already Added', "");
                             
                          }
                          jQuery('#txtCity').val('');
                          return false;
                      },
                  });
        });
    </script>
    <script type="text/javascript">
        function accessRight() {
            jQuery('#btnSearch').hide();
        }
        function ApprovalCount(AppCount) {
            if (AppCount == 0)
                jQuery('#btnApprove').hide();
            else
                jQuery('#btnApprove').show();
        }

    </script>
    <script type="text/javascript">
        function ApproveBudget() {
            var isEmptyValue = 0;
            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                jQuery(this).find('td').find(".clBudgetQty").each(function () {
                    var Qty = jQuery.trim(jQuery(this).closest('td').find(".clBudgetQty").val());
                    if (Qty == "" || Qty == 0) {                        
                        toast("Error", 'Please Enter Qty', "");
                        jQuery(this).closest('td').find(".testValue").focus();
                        isEmptyValue = 1;
                        return;
                    }
                    if (isEmptyValue == 1) {
                        return;
                    }
                });
            });
            if (isEmptyValue == 1) {
                return;
            }
           
            var dataItem = new Array();
            var item = new Object();
            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                var $tds = jQuery(this).find('td');
                var ItemID = $tds.eq(1).text();
                jQuery(".clBudgetQty", this).each(function () {
                    var Qty = this.value;
                    var FromLocationID = parseInt($(this).attr('id'));
                    var IndentNo = jQuery(this).closest('td').find(".clBudgetIndent").text().split('#')[2];
                    if (Qty.length != 0 && Qty.length != '' && Qty != 'null') {
                        item.ItemID = ItemID;
                        item.IndentNo = IndentNo;
                        item.FromLocationID = FromLocationID;
                        item.Qty = Qty;
                        dataItem.push(item);
                        item = new Object();
                    }
                });
            });
            if (dataItem.length > 0) {//"{ItemDetail:'" + JSON.stringify(dataItem) + "'}",
                serverCall('BudgetIndent.aspx/BudgetIndentApprove', { ItemDetail: SON.stringify(dataItem) }, function (response) {
                    if (response == "1") {                       
                        toast("Success", 'Record Saved Successfully', "");
                        searchData(1);
                    }
                    else if (response == "2") {
                        jQuery("#btnApprove").hide();                       
                        toast("Error", 'You do not have right to Approve Budget Indent', "");
                    }
                    else {
                        
                        toast("Error", 'Error', "");
                    }                    
                    dataItem.splice(0, dataItem.length);

                });
            }
        }
    </script>
</asp:Content>

