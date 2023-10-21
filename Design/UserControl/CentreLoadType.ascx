<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CentreLoadType.ascx.cs" Inherits="Design_UserControl_CentreLoadType" %>
<%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
<script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />
<style type="text/css">
    .multiselect {
        width: 100%;
    }
    .ms-parent .multiselect {
    width:195px;
    }
</style>
<table style="width: 100%; border-collapse: collapse">
    <tr>
        <td style="width: 130px; text-align: right;font-weight:bold;">Business Zone :&nbsp;
        </td>
        <td style="width: 20px; text-align: left">
            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 70px; text-align: right;font-weight:bold;">State :&nbsp;
        </td>
        <td style="width: 20px;">
            <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 70px; text-align: right;font-weight:bold;">City :&nbsp;
        </td>
        <td style="width: 20px; text-align: left">
            <asp:ListBox ID="lstCity" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 50px; text-align: left;font-weight:bold;">Type :&nbsp;
        </td>
        <td style="width: 20px; text-align: left">
            <asp:ListBox ID="lstTypeLoadList" CssClass="multiselect" SelectionMode="Multiple"  Width="230px"  runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
    </tr>
</table>
<script type="text/javascript">
    $(function () {
        $('[id*=lstTypeLoadList]').multipleSelect({
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
        $('[id*=lstCity]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
     
        $('.ms-parent multiselect').css('width', '195px;');
        bindZone();
        
    });
    function bindZone() {
        $.ajax({
            url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
            data: '{}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {
                BusinessZoneID = jQuery.parseJSON(result.d);
                for (i = 0; i < BusinessZoneID.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                }
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            },
            error: function (xhr, status) {
                alert("Error ");
            }
        });
    }
    $('#lstZone').on('change', function () {
        jQuery('#<%=lstState.ClientID%> option').remove();
        jQuery('#<%=lstCity.ClientID%> option').remove();
        jQuery('#<%=lstTypeLoadList.ClientID%> option').remove();
        jQuery('#lstState').multipleSelect("refresh");
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstTypeLoadList').multipleSelect("refresh");
        jQuery('#bindCentre option').remove();
        jQuery('#bindCentre').multipleSelect("refresh");
        var BusinessZoneID = $(this).val();
        bindBusinessZoneWiseState(BusinessZoneID);
    });
    $('#lstState').on('change', function () {
        jQuery('#<%=lstCity.ClientID%> option').remove();
        jQuery('#<%=lstTypeLoadList.ClientID%> option').remove();
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstTypeLoadList').multipleSelect("refresh");
        jQuery('#bindCentre option').remove();
        jQuery('#bindCentre').multipleSelect("refresh");
        var BusinessZoneID = $('#lstZone').val();
        var StateID = $(this).val();
        bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID);
    });
    $('#lstCity').on('change', function () {
        jQuery('#<%=lstTypeLoadList.ClientID%> option').remove();
        jQuery('#lstTypeLoadList').multipleSelect("refresh");
        jQuery('#bindCentre option').remove();
        jQuery('#bindCentre').multipleSelect("refresh");
        bindType();
        });
    $('#lstTypeLoadList').on('change', function () {
        var BusinessZoneID = $('#lstZone').val();
        var StateID = $('#lstState').val();
        var CityID = $('#lstCity').val();
        var TypeID = $(this).val();
        bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID, TypeID);
    });

    function bindBusinessZoneWiseState(BusinessZoneID) {
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
    function bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID) {
        if (StateID != "") {
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZoneAndStateWiseCity",
                data: '{ BusinessZoneID: "' + BusinessZoneID + '",StateID: "' + StateID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    for (i = 0; i < CityData.length; i++) {
                        jQuery("#lstCity").append(jQuery("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                    jQuery('[id*=lstCity]').multipleSelect({
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
    function bindType() {
                jQuery.ajax({
                    url: "../Common/Services/CommonServices.asmx/bindTypeLoad",
                    data: '{ }',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        CentreLoadListData = jQuery.parseJSON(result.d);
                        for (i = 0; i < CentreLoadListData.length; i++) {
                            jQuery("#lstTypeLoadList").append(jQuery("<option></option>").val(CentreLoadListData[i].id).html(CentreLoadListData[i].type1));
                        }
                        jQuery('[id*=lstTypeLoadList]').multipleSelect({
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
