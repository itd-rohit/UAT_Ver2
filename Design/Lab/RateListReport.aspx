<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="RateListReport.aspx.cs" Inherits="Design_Lab_RateListReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .ms-parent .multiselect {
            width: 195px;
        }
    </style>
    <%--Search--%>
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
            $('.chosen-container').css('width', '200px');
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Rate List Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search criteria</div>
            
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Business Zone</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">State</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">City</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:ListBox ID="lstCity" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>

                    <div class="col-md-1">
                        <label class="pull-left">Type</label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlType" class="ddlType chosen-select chosen-container" runat="server" ClientIDMode="Static">
                        </asp:DropDownList>
                    </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:CheckBoxList ID="chkCategory" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Tagged PUP" Value="PUP"></asp:ListItem>
                    </asp:CheckBoxList>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>

    </div>



    <%--Saving--%>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=bindCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $("#spnDefaultLogo").mouseover(function () {
                $("#spanLogo").show();
            });
            $("#spnDefaultLogo").mouseout(function () {
                $("#spanLogo").hide();
            });
        });

        function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID, TypeID) {
            $('#IsNable').val('0');
            if (TypeID != "") {
                serverCall('RateListReport.aspx/bindCentreLoadType', { BusinessZoneID: BusinessZoneID, StateID: StateID, CityID: CityID, TypeID: TypeID }, function (response) {
                    jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery("#lstCentre") });                  
                });
               
            }
        }

        
       
    </script>
    <script type="text/javascript">
        function getReport() {
            var CentreIDs = '';
            var SelectedLaength = $('#lstCentre').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                CentreIDs += $('#lstCentre').multipleSelect("getSelects").join().split(',')[i] + ',';
            }
            if (CentreIDs == ",") {
                toast('Error','Please Select Centre');
                return;
            }
            var IsMultipleCentre = (CentreIDs.split(',').length > 2) ? "1" : "0";
            var PUP = '0';
            $('#<%=chkCategory.ClientID %> input[type=checkbox]').each(function () {
                        if ($(this).prop('checked') == true) {
                            if ($(this).val() == "PUP") {
                                PUP = '1';
                            }
                        }
            });
            serverCall('RateListReport.aspx/getReport', { CentreIDs: CentreIDs, PUP: PUP, IsMultipleCentre: IsMultipleCentre}, function (response) {
                if (response == 1)
                    window.open("../common/ExportToExcel.aspx");
                else {
                    toast('Info', "No Record Found");
                }

            });
                    

                }
        $('#lstZone,#lstState,#lstCity').on('change', function () {
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
        });

    </script>
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
            $('[id*=lstCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('.ms-parent multiselect').css('width', '195px;');
            bindZone();

        });
        function bindZone() {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery("#lstZone").bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery("#lstZone") });               
            });
            
        }
        $('#lstZone').on('change', function () {
            $("#ddlType option").remove();
            $('#ddlType').trigger('chosen:updated');
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#<%=lstCity.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            jQuery('#lstCity').multipleSelect("refresh");
            jQuery('#bindCentre option').remove();
            jQuery('#bindCentre').multipleSelect("refresh");
            var BusinessZoneID = $(this).val().toString();
            bindBusinessZoneWiseState(BusinessZoneID);
        });
        $('#lstState').on('change', function () {
            $("#ddlType option").remove();
            $('#ddlType').trigger('chosen:updated');
            jQuery('#<%=lstCity.ClientID%> option').remove();
            jQuery('#lstCity').multipleSelect("refresh");
            jQuery('#bindCentre option').remove();
            jQuery('#bindCentre').multipleSelect("refresh");
            var BusinessZoneID = $('#lstZone').val().toString();
            var StateID = $(this).val().toString();
            bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID);
        });
        $('#lstCity').on('change', function () {
            $("#ddlType option").remove();
            $('#ddlType').trigger('chosen:updated');
            jQuery('#bindCentre option').remove();
            jQuery('#bindCentre').multipleSelect("refresh");
            bindType();
        });
        $('#ddlType').on('change', function () {
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            var BusinessZoneID = $('#lstZone').val().toString();
            var StateID = $('#lstState').val().toString();
            var CityID = $('#lstCity').val().toString();
            var TypeID = $(this).val().toString();
            bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID, TypeID);

        });

        function bindBusinessZoneWiseState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    jQuery("#lstState").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery("#lstState") });                   
                });
                
            }
        }
        function bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID) {
            if (StateID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneAndStateWiseCity', { BusinessZoneID: BusinessZoneID, StateID: StateID }, function (response) {
                    jQuery("#lstCity").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'City', controlID: jQuery("#lstCity") });                 
                });
                
            }
        }
        function bindType() {
            serverCall('../Common/Services/CommonServices.asmx/bindTypeLoadWithoutPCCPUP', {  }, function (response) {                            
                jQuery("#ddlType").bindDropDown({ data: JSON.parse(response), valueField: 'id', textField: 'type1', defaultValue: '---Please Select Type---', isSearchAble: true });
            });
           
        }
    </script>
</asp:Content>

