<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CentreLoad.ascx.cs" Inherits="Design_UserControl_CentreLoad" %>
<%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
<script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>

<div class="row">
    <div class="col-md-24">

        <div class="row">
            <div class="col-md-3 ">
                <label class="pull-left">Business Zone   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>

            </div>
            <div class="col-md-3 ">
                 <label class="pull-left">State </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5 ">
                <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
            </div>
            <div class="col-md-4 ">
                
            </div>
            <div class="col-md-4 ">
                
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-24">
        <div class="row">
            <div class="col-md-3 ">
                <label class="pull-left">Centre   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-6 ">
                <asp:ListBox ID="lstCentreLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        $('[id*=lstCentreLoadList]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
        $('[id*=lstZone]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
        $('[id*=lstState]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });      
        bindZone();
    });
    function bindZone() {
        serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', { }, function (response) {
            jQuery('#lstZone').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery('#lstZone') });
        });      
    }
    $('#lstZone').on('change', function () {
        jQuery('#<%=lstState.ClientID%> option').remove();
       
        jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
        jQuery('#lstState').multipleSelect("refresh");
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstCentreLoadList').multipleSelect("refresh");
        var BusinessZoneID = $(this).val().toString();
        bindBusinessZoneWiseState(BusinessZoneID);
    });
    $('#lstState').on('change', function () {       
        jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstCentreLoadList').multipleSelect("refresh");
        var BusinessZoneID = $('#lstZone').val().toString();
        var StateID = $(this).val().toString();
        bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, 0);
    });
    
    function bindBusinessZoneWiseState(BusinessZoneID) {
        if (BusinessZoneID != "") {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery('#lstState') });
            });           
        }
    } 
    function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID) {
        serverCall('../Common/Services/CommonServices.asmx/bindCentreLoad', { BusinessZoneID: BusinessZoneID, StateID: StateID, CityID: 0 }, function (response) {
                jQuery('#lstCentreLoadList').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery('#lstCentreLoadList') });
            });            
    }
</script>
