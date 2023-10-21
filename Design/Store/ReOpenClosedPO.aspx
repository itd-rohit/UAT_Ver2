<%@ Page ClientIDMode="Static" Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ReOpenClosedPO.aspx.cs" Inherits="Design_Store_ReOpenClosedPO" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
         <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1304px;">
     <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px;text-align: center;">
         
                <b>Reopen Closed Purchase Order </b>
                <br />
                <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError"  />
          
        </div>
      <div class="POuter_Box_Inventory" style="width: 1300px;">
            
            <div class="divSearchInfo" style="display: none;" id="divSearch">
                <div style="width: 1300px; background-color: papayawhip;">
                    <div class="Purchaseheader">
                        Search Option
                    </div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="width: 10%">City :&nbsp;</td>
                            <td style="width: 22%">
                                <asp:TextBox ID="txtCity" runat="server" Width="232px"></asp:TextBox>
                            </td>
                            <td style="width: 12%">&nbsp;</td>
                            <td style="width: 22%">
                                <asp:ListBox ID="lstCity" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                            </td>
                            <td style="width: 10%">
                                <input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />
                            </td>
                            <td style="width: 24%">&nbsp;</td>
                        </tr>
                    </table>
                </div>
            </div>
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="width: 10%">Close From :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                         &nbsp;&nbsp;&nbsp;
                        <input id="Button2" class="ItDoseButton" onclick="showhide();" style="font-weight: bold;display:none;" type="button" value="More Filter" />
                        Close To :&nbsp;<asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    &nbsp; Type :

                        <asp:DropDownList ID="ddlclosetype" runat="server" Width="150px" class="ddlusername chosen-select chosen-container" >
                            <asp:ListItem Value="0">Select</asp:ListItem>
                             <asp:ListItem Value="5">Auto Close</asp:ListItem>
                             <asp:ListItem Value="4">Manual Close</asp:ListItem>  
                        </asp:DropDownList>
                    &nbsp; PO No:<asp:TextBox ID="txtPoNo" runat="server" Width="180px" MaxLength="30" />
                       
                    &nbsp; Vendor :&nbsp;<asp:ListBox ID="lstVendor" runat="server" CssClass="multiselect " SelectionMode="Multiple" Width="300px"></asp:ListBox>
                    </td>
                </tr>    
                
                <tr>
                    <td colspan="2">
                        <div class="Purchaseheader">Location Filter</div>
                    </td>
                </tr>             
                
                <tr>
                    <td>Centre Type :&nbsp;</td>
                     <td><asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="140px" runat="server" onchange="bindlocation()"></asp:ListBox>
                         &nbsp;
                         Zone :&nbsp;
                         <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="140px"></asp:ListBox>
                     &nbsp; State :&nbsp;<asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="240px" onchange="bindlocation()"></asp:ListBox>
                     &nbsp;Location :<asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="420px" runat="server" ClientIDMode="Static"></asp:ListBox>
                     </td>
                    
                </tr>             
            </table>

          <table style="width: 100%; border-collapse: collapse;display:none;" >
                <tr>
                    <td style="width: 10%">
                    </td>
                    <td style="width: 22%">
                        
                    </td>
                    <td style="width: 12%">Category Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstCategoryType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                    <td style="width: 10%">Manufacture :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstManufacture" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%"></td>
                    <td style="width: 22%">
                        
                    </td>
                    <td style="width: 12%">Sub Category Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstSubCategory" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox></td>

                    <td style="width: 10%">Machine :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstMachine" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%"></td>
                    <td style="width: 22%">
                       
                    </td>
                    <td style="width: 12%">Item Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstItemType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox></td>
                    <td style="width: 10%">Item :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstItemGroup" runat="server" CssClass="multiselect " SelectionMode="Multiple" Width="300px"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 22%">
                        <input id="btnMoreFilter" class="ItDoseButton" onclick="showSearch();" style="font-weight: bold;display:none;" type="button" value="More Filter" /></td>
                    <td style="width: 12%">&nbsp;</td>
                    <td style="width: 22%">&nbsp;</td>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 24%">&nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">


            <table width="99%">

                <tr>
                    <td width="50%">
                        <table width="99%">
                        <tr style="height:28px;">

                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#f5b738;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                PO Closed By User</td>
                            
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#CC99FF;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                PO Closed By System</td>
                                
                            
                           
                        </tr>
                    </table>
                    </td>
                      <td width="50%" align="left">

                             <input type="button" id="btnSearch" value="Search" class="searchbutton" onclick="searchData()" />&nbsp;&nbsp;

                          <input type="text" style="width:250px;display:none;" id="txtreopenreason" maxlength="200" />
                          &nbsp;&nbsp;
                          <input type="button" id="btnreopen" value="ReOpen" class="savebutton" style="display:none;" onclick="reopenAgain()" />



            <span id="bal"></span>
                      </td>
                </tr>
            </table>
          
                       
            </div>
           

        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 <div class="Purchaseheader">
                     PO Detail
                      </div>

                 <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:50px;">View</td>
                                       
                                        <td class="GridViewHeaderStyle">PO Number</td>
                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">Vendor</td>

                                        <td class="GridViewHeaderStyle">PO Type</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">Close Date</td>
                                        <td class="GridViewHeaderStyle">Close By</td>
                        <td class="GridViewHeaderStyle">Close Reason</td>
                                        <td class="GridViewHeaderStyle">Gross Amt</td>
                                        <td class="GridViewHeaderStyle">Net Amt</td>
                                       
                                       <td class="GridViewHeaderStyle"  style="width:50px;">Select</td>
                                        
                                     
                        </tr>
                </table>

                </div>
                </div>

          
             </div>

        </div>
    
      <script type="text/javascript">
     jQuery(function () {
            jQuery('[id*=lstCentreType],[id*=lstCategoryType],[id*=lstManufacture],[id*=lstZone],[id*=lstSubCategory],[id*=lstMachine],[id*=lstState],[id*=lstItemType],[id*=lstItemGroup],[id*=lstCity],[id*=lstVendor]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindcentertype();
            bindZone();
          //  bindCategoryType();
          //  bindManufacture();
          //  bindMachine();
            bindVendor();
        });
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            CommonServices.bindTypeLoad(onSucessCentreType, onFailureCentreType);
        }
        function onSucessCentreType(result) {
            var typedata = jQuery.parseJSON(result);
            for (var a = 0; a <= typedata.length - 1; a++) {
                jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].id).html(typedata[a].type1));
            }
            jQuery('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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
            for (i = 0; i < BusinessZoneID.length; i++) {
                jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
            }
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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
                jQuery.ajax({
                    url: "../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }
        function bindCategoryType() {
            jQuery('#<%=lstCategoryType.ClientID%> option').remove();
                jQuery('#lstCategoryType').multipleSelect("refresh");
                StoreCommonServices.bindcategory(onSucessCategoryType, onFailureCategoryType);
            }
            function onSucessCategoryType(result) {
                var categoryData = jQuery.parseJSON(result);
                for (i = 0; i < categoryData.length; i++) {
                    $('#<%=lstCategoryType.ClientID%>').append($("<option></option>").val(categoryData[i].ID).html(categoryData[i].Name));
            }
            jQuery('[id*=lstCategoryType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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
                jQuery.ajax({
                    url: "Services/StoreCommonServices.asmx/bindsubcategory",
                    data: '{categoryid:"' + CategoryTypeID + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var subcategoryData = jQuery.parseJSON(result.d);
                        for (i = 0; i < subcategoryData.length; i++) {
                            jQuery("#lstSubCategory").append(jQuery("<option></option>").val(subcategoryData[i].ID).html(subcategoryData[i].Name));
                        }
                        jQuery('[id*=lstSubCategory]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
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
            jQuery.ajax({
                url: "Services/StoreCommonServices.asmx/binditemtype",
                data: '{subcategoryid:"' + SubCategoryID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var ItemTypeData = jQuery.parseJSON(result.d);
                    for (i = 0; i < ItemTypeData.length; i++) {
                        jQuery("#lstItemType").append(jQuery("<option></option>").val(ItemTypeData[i].ID).html(ItemTypeData[i].Name));
                    }
                    jQuery('[id*=lstItemType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
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
            jQuery.ajax({
                url: "BudgetIndent.aspx/bindItemGroup",
                data: '{SubcategoryID:"' + ItemTypeID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var ItemGroupData = jQuery.parseJSON(result.d);
                    for (i = 0; i < ItemGroupData.length; i++) {
                        jQuery("#lstItemGroup").append(jQuery("<option></option>").val(ItemGroupData[i].ItemIDGroup).html(ItemGroupData[i].ItemNameGroup));
                    }
                    jQuery('[id*=lstItemGroup]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
    }
    function bindManufacture() {
        jQuery('#<%=lstManufacture.ClientID%> option').remove();
            jQuery('#lstManufacture').multipleSelect("refresh");
            StoreCommonServices.bindManufacture(onSucessManufacture, onFailureManufacture);
        }
        function onSucessManufacture(result) {
            var ManufactureData = jQuery.parseJSON(result);
            for (var a = 0; a <= ManufactureData.length - 1; a++) {
                jQuery('#<%=lstManufacture.ClientID%>').append($("<option></option>").val(ManufactureData[a].ID).html(ManufactureData[a].NAME));
        }
        jQuery('[id*=lstManufacture]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
    }
    function onFailureManufacture() {

    }
    function bindMachine() {
        jQuery('#<%=lstMachine.ClientID%> option').remove();
        jQuery('#lstMachine').multipleSelect("refresh");
        StoreCommonServices.bindmachine(onSucessMachine, onFailureMachine);
    }
    function onSucessMachine(result) {
        var MachineData = jQuery.parseJSON(result);
        for (var a = 0; a <= MachineData.length - 1; a++) {
            jQuery('#lstMachine').append($("<option></option>").val(MachineData[a].ID).html(MachineData[a].NAME));
        }
        jQuery('[id*=lstMachine]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
    }
    function onFailureMachine() {

    }
    function bindVendor() {
        jQuery('#<%=lstVendor.ClientID%> option').remove();
        jQuery('#lstVendor').multipleSelect("refresh");
        StoreCommonServices.bindsupplier(onSucessVendor, onFailureVendor);
    }
    function onSucessVendor(result) {
        var VendorData = jQuery.parseJSON(result);
        for (var a = 0; a <= VendorData.length - 1; a++) {
            jQuery('#lstVendor').append($("<option></option>").val(VendorData[a].supplierid).html(VendorData[a].suppliername));
        }
        jQuery('[id*=lstVendor]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
    }
    function onFailureVendor() {

    }
    </script>

      <%--  City Search --%>
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
         jQuery(function () {


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


             jQuery('#txtCity').bind("keydown", function (event) {
                 if (event.keyCode === jQuery.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 if (jQuery('#lstState').multipleSelect("getSelects").join() == "") {
                     showerrormsg("Please Select State");
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
                               showerrormsg("City Already Added");
                           }
                           jQuery('#txtCity').val('');
                           return false;
                       },
                   });
         });
    </script>

    <script type="text/javascript">

        function bindlocation() {

            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            var cityId = "";

            var centreid = "";
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery.ajax({
                url: "MappingStoreItemWithCentre.aspx/bindlocation",
                data: '{centreid:"' + centreid + '",StateID:"' + StateID + '",TypeId:"' + TypeId + '",ZoneId:"' + ZoneId + '",cityId:"' + cityId + '"}',
                type: "POST",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstlocation").append(jQuery("<option></option>").val(centreData[i].LocationID).html(centreData[i].Location));
                    }
                    $('[id=lstlocation]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }
    </script>

    <script type="text/javascript">

        var reopen = '<%=reopen%>';
        function searchData() {
            

               
            $('#txtreopenreason').hide();
            $('#btnreopen').hide();
            

                 var location = jQuery('#<%=lstlocation.ClientID%>').multipleSelect("getSelects").join();
                 var CentreType = jQuery('#lstCentreType').multipleSelect("getSelects").join();
                 var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
                 var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
                 var VendorID = jQuery('#lstVendor').multipleSelect("getSelects").join();
                 $.blockUI();
                 $('#tblitemlist tr').slice(1).remove();
                 $.ajax({
                     url: "ReOpenClosedPO.aspx/SearchData",
                     data: '{location:"' + location + '",fromdate:"' + $('#txtFromDate').val() + '",todate:"' + $('#txtToDate').val() + '",ZoneID: "' + ZoneID + '",StateID: "' + StateID + '",CentreType: "' + CentreType + '",PONo:"' + jQuery('#txtPoNo').val() + '",CloseType:"' + jQuery('#ddlclosetype').val() + '",VendorID:"' + VendorID + '"}', // parameter map      
                     type: "POST",
                     timeout: 120000,

                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (result) {
                         POData = jQuery.parseJSON(result.d);

                         if (POData.length == 0) {
                             showerrormsg("No Closed PO Found");
                             $.unblockUI();

                         }
                         else {
                             $('#txtreopenreason').show();
                             $('#btnreopen').show();
                             for (var a = 0; a <= POData.length - 1; a++) {
                                 
                                 var mydata = '<tr id=' + POData[a].PurchaseOrderID + ' style="height:30px;background-color:' + POData[a].rowColor + '" >';

                                 mydata += '<td>' + parseFloat(a + 1) + '</td>';

                                 mydata += '<td class="GridViewLabItemStyle"  id="tdPODetail" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showPODetail(this)" />';
                                 


                                 mydata += '</td>';

                                 mydata += '<td style="font-weight:bold">' + POData[a].PurchaseOrderNo + '</td>';
                                
                                 mydata += '<td>' + POData[a].Location + '</td>';
                                 mydata += '<td>' + POData[a].SupplierName + '</td>';
                                 mydata += '<td>' + POData[a].POType + '</td>';
                                 mydata += '<td>' + POData[a].POStatusType + '</td>';
                                 mydata += '<td>' + POData[a].ClosedDate + '</td>';
                                 mydata += '<td>' + POData[a].closedbyname + '</td>';
                                 mydata += '<td>' + POData[a].closedreason + '</td>';
                                 mydata += '<td>' + POData[a].GrossTotal + '</td>';
                                 mydata += '<td>' + POData[a].NetTotal + '</td>';
                                 if (reopen == "1") {
                                     mydata += '<td  ><input type="checkbox" id="chk"  /></td>';
                                 }
                                 else {
                                     mydata += '<td  ></td>';
                                 }
                               


                                 mydata += '<td style="display:none;" id="tdPurchaseOrderID">' + POData[a].PurchaseOrderID + '</td>';
                                 
                                 mydata += '</tr>';
                                 $('#tblitemlist').append(mydata);

                             }
                             $.unblockUI();

                         }

                     },
                     error: function (xhr, status) {
                         alert(xhr.responseText);
                         $.unblockUI();

                     }
                 });

             
        }

      
        function showPODetail(rowID) {
            var id = jQuery(rowID).closest('tr').attr("id");
            if (jQuery('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                jQuery('table#tblitemlist tr#ItemDetail' + id).remove();
                jQuery(rowID).attr("src", "../../App_Images/plus.png");
                return;
            }
            var PurchaseOrderID = jQuery(rowID).closest('tr').find("#tdPurchaseOrderID").text();
            jQuery.ajax({
                url: "ReOpenClosedPO.aspx/bindPODetail",
                data: '{PurchaseOrderID:"' + PurchaseOrderID + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    Podata = jQuery.parseJSON(result.d);
                    if (Podata.length == 0) {
                        showerrormsg("No Item Found");
                    }
                    else {
                        jQuery(rowID).attr("src", "../../App_Images/minus.png");
                        var mydata = "<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>";
                        mydata += '<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;">S.No.</td>';
                        mydata += '<td>Item Name</td>';
                        mydata += '<td>Order Qty</td>';
                        mydata += '<td>Checked Qty</td>';
                        mydata += '<td>Approved Qty</td>';
                        mydata += '<td>GRN Qty</td>';
                        mydata += '<td>Closed Qty</td>';
                       
                       

                        for (var a = 0; a <= Podata.length - 1; a++) {

                            mydata += '<tr  style="height:30px;background-color:lightgoldenrodyellow" id=' + Podata[a].PurchaseOrderDetailID + '>';
                            mydata += '<td>' + parseFloat(a + 1) + '</td>';
                            mydata += '<td>' + Podata[a].ItemName + '</td>';
                            mydata += '<td>' + Podata[a].OrderedQty + '</td>';
                            mydata += '<td>' + Podata[a].CheckedQty + '</td>';
                            mydata += '<td>' + Podata[a].ApprovedQty + '</td>';
                            mydata += '<td>' + Podata[a].GRNQty + '</td>';
                            mydata += '<td style="font-weight:bold;background-color:red;color:white">' + Podata[a].RejectQty + '</td>';
                           
                         
                           
                            mydata += '</tr>';
                        }
                        mydata += "</table></div>";
                        var newdata = '<tr id="ItemDetail' + id + '"><td></td><td colspan="10">' + mydata + '</td></tr>';

                        $(newdata).insertAfter($(rowID).closest('tr'));
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }


        function reopenAgain() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    dataIm.push($(this).find("#tdPurchaseOrderID").text());


                }
            });


            if (dataIm.length == 0) {
                showerrormsg("Please Select PO To Reopen");
                return;
            }

            if ($('#txtreopenreason').val() == "") {
                showerrormsg("Please Enter Reopen Reason");
                $('#txtreopenreason').focus();
                return;
            }

            $.blockUI();
            $.ajax({
                url: "ReOpenClosedPO.aspx/reopennow",
                data: JSON.stringify({ mydata: dataIm, reopenreason: $('#txtreopenreason').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        showmsg("PO Reopen Sucessfully..!");

                        searchData();

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });
        }
    </script>
   
</asp:Content>

