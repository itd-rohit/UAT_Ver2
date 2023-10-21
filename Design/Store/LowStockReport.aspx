﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LowStockReport.aspx.cs" Inherits="Design_Store_LowStockReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

      <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Low Stock Report</b>
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError" />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" >
            <div id="divSearch">
                <div class="Purchaseheader">
                   Location Details
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                           <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">CentreType:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                               <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Zone:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">State:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                              <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">City:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Centre:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Location:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                   <asp:ListBox ID="lstlocation" CssClass="multiselect requiredField" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                            </div>
                            </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

           <div class="POuter_Box_Inventory" >
            <div id="div1">
                <div class="Purchaseheader">
                  Item Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Category Type:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>
                            </div>
                           
                         <div class="col-md-3 ">
                                <label class="pull-left ">SubCategory Type:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>
                            </div>
                             </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Item Category:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                 <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                            </div>
                           
                         <div class="col-md-3 ">
                                <label class="pull-left ">Machine:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                             <asp:ListBox ID="ddlmachine" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem()"></asp:ListBox></td>
                            </div>
                             </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Items:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                            </div>
                           
                         <div class="col-md-3 ">
                                <label class="pull-left ">   </label>
                                
                            </div>
                            <div class="col-md-9 ">
                                
                            </div>
                             </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Report From:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                  <asp:DropDownList ID="ddltype" runat="server">
                                                    <asp:ListItem Value="MinLevel">Min Level</asp:ListItem>
                                                    <asp:ListItem Value="RecorderLevel">Reorder Level</asp:ListItem>
                                                </asp:DropDownList>
                            </div>
                           
                         <div class="col-md-3 ">
                                <label class="pull-left ">
                                </label>
                            </div>
                            <div class="col-md-9 ">
                            </div>
                             </div>
                        </div>
                    </div>
                </div>
                </div>
           <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="div6">
                <div class="row">
                    <div class="col-md-24 ">
                      <input type="button" value="Get Report PDF" class="searchbutton" onclick="GetReport('PDF');" id="Button1" />&nbsp;&nbsp;
                   <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport('Excel');" id="btnsave" />
                    </div>
                </div>
            </div>
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
            }); 
            $('[id*=lstCentrecity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlmachine]').multipleSelect({
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
                var $ddlCtype = $('#<%=ddlcattype.ClientID%>');
                $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: $("#ddlcattype"), isClearControl: '' });
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
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID.toString() }, function (response) {
                    var $ddlStype = $('#<%=ddlsubcattype.ClientID%>');
                    $ddlStype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: $("#ddlsubcattype"), isClearControl: '' });
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
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId.toString() }, function (response) {
                    var $ddlC = $('#<%=ddlcategory.ClientID%>');
                    $ddlC.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
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
                    var $ddlItem = $('#<%=ddlItem.ClientID%>');
                    $ddlItem.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                });
            }
        }

     
    </script>

    <script type="text/javascript">

        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                var $ddlCtype = $('#<%=lstCentreType.ClientID%>');
                $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });
            });
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                var $ddlZone = $('#<%=lstZone.ClientID%>');
                $ddlZone.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
            });
        }

        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                    var $ddlState = $('#<%=lstState.ClientID%>');
                    $ddlState.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });
            }
            bindCentrecity();
        }

      

        function bindCentrecity() {
            var StateID = jQuery('#lstState').val();
            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID.toString() }, function (response) {
                var $ddlCity = $('#<%=lstCentrecity.ClientID%>');
                $ddlCity.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
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
                    var $ddlCentre = $('#<%=lstCentre.ClientID%>');
                    $ddlCentre.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), isClearControl: '' });
                });
            }
            bindlocation();
        }

        function bindmachine() {
            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#ddlmachine').multipleSelect("refresh");
            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                var $ddlMachine = $('#<%=ddlmachine.ClientID%>');
                $ddlMachine.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#ddlmachine"), isClearControl: '' });
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
                var $ddllocation = $('#<%=lstlocation.ClientID%>');
                $ddllocation.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
              
            });
        }

    </script>

    <script type="text/javascript">
        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function GetReport(reportType) {          
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            var machineid = $('#ddlmachine').val().toString();
            var itemid = $('#<%=ddlItem.ClientID%>').val().toString();
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();                    
            serverCall('LowStockReport.aspx/GetReport', { categorytypeid: CategoryTypeId, subcategorytypeid: SubCategoryTypeId, subcategoryid: CategoryId, itemid: itemid, locationid: locationid, machineid: machineid, apptype: $('#<%=ddltype.ClientID%>').val(), reportType: reportType }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var $objData = new Object();
                    $objData.ItemID = JSON.parse(response).ItemID;
                    $objData.CategoryTypeId = JSON.parse(response).CategorytypeId;
                    $objData.SubCategoryTypeId = JSON.parse(response).SubCategoryTypeId;
                    $objData.SubCategoryId = JSON.parse(response).SubCategoryId;
                    $objData.LocationID = JSON.parse(response).LocationID;
                    $objData.MachineID = JSON.parse(response).MachineID;
                    $objData.Apptype = JSON.parse(response).Apptype;
                    $objData.ReportType = JSON.parse(response).ReportType;
                    $objData.ReportPath = JSON.parse(response).ReportPath;                    
                    $objData.ReportDisplayName = JSON.parse(response).ReportDisplayName;
                    $objData.IsAutoIncrement = JSON.parse(response).IsAutoIncrement;
                    PostFormData($objData, JSON.parse(response).ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });

        }

        function GetReportPDF() {

            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            var machineid = $('#ddlmachine').val().toString();
            var itemid = $('#<%=ddlItem.ClientID%>').val().toString();
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();
            var length = $('#<%=lstlocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select Location", "");
                $('#<%=lstlocation.ClientID%>').focus();
                return false;
            }

            if (locationid == "0") {
                toast("Error", "Please Select Location", "");
                return;
            }
            $modelBlockUI();


            serverCall('LowStockReport.aspx/GetReportPDF', { categorytypeid: CategoryTypeId, subcategorytypeid: SubCategoryTypeId, subcategoryid: CategoryId, itemid: itemid, locationid: locationid, machineid: machineid, apptype: $('#<%=ddltype.ClientID%>').val() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.ItemID = JSON.parse(response).ItemID;
                    $objData.CategoryTypeId = JSON.parse(response).CategorytypeId;
                    $objData.SubCategoryTypeId = JSON.parse(response).SubCategoryTypeId;
                    $objData.SubCategoryId = JSON.parse(response).SubCategoryId;
                    $objData.LocationID = JSON.parse(response).LocationID;
                    $objData.MachineID = JSON.parse(response).MachineID;
                    $objData.Apptype = JSON.parse(response).Apptype;
                    $objData.ReportPath = JSON.parse(response).ReportPath;

                    PostFormData($objData, JSON.parse(response).ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });

        }
    </script>
</asp:Content>
