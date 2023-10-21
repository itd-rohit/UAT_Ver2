<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SMSConfigurationMaster.aspx.cs" Inherits="Design_Master_SMSConfigurationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multi-select.min.js"></script>

    <link href="../../App_Style/example-styles.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>SMS Configuration Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <table id="tblSMSConf" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
                        <thead>
                            <tr id="Header">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 30px">S.No.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px">Module</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px">Screen</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">SMSTrigger</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 190px">ToWhom</th>

                                <th class="GridViewHeaderStyle" scope="col" style="width: 180px">TagType</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px">Client</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px">SMSType</th>
                                <th class="GridViewHeaderStyle" scope="col" style="">Active</th>

                                <th class="GridViewHeaderStyle" scope="col" style="">View</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display: none">
            <input type="button" value="Save" id="btnSave" />
        </div>
    </div>

    <div id="divSmsView" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">SMS View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeSMSView()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Template</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtTemplate" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px"></asp:TextBox>
                            <span id="spnSMSID" style="display: none"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Active Columns</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                         <span id="spnActiveColumns"></span>   
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">SQL Query</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtSQLQuery" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnPopUpSave" value="Save" onclick="saveSMSTemp()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div id="divClient" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">Client View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeClientiew()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left"><b>Module</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <span id="spnModule"></span>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"><b>Screen</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnScreen"></span>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">TagClient</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <asp:DropDownList ID="ddlTagClient" runat="server" class="ddlTagClient chosen-select chosen-container" onchange="$bindClient()"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Client</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20">
                            <asp:ListBox ID="lstClient" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnClient" value="Save" onclick="saveClient()" />
                        </div>
                    </div>
                    <div class="Purchaseheader divShow" style="display: none"><span id="spnType"></span></div>
                    <div class="row divShow" style="display: none">
                        <div class="col-md-4">
                        </div>
                        <div class="col-md-20">
                            <asp:ListBox ID="lstDiscardClient" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>


                        </div>
                    </div>
                    <div class="row divShow" style="text-align: center; display: none">
                        <div class="col-md-24">

                            <input type="button" id="btnRemove" value="Remove Discard" onclick="removeDiscard()" />

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">

        $closeSMSView = function () {
            jQuery('#divSmsView').closeModel();
        }
        $closeClientiew = function () {
            jQuery('#divClient').closeModel();
        }
        $(function () {
            $bindModule();
            $('[id*=lstClient]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstDiscardClient]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

        });
        $bindModule = function () {
            serverCall('SMSConfigurationMaster.aspx/bindModule', {}, function (response) {
                var $SMSConfig = JSON.parse(response);
                if ($SMSConfig.status) {
                    $SMSConfig = jQuery.parseJSON($SMSConfig.response);
                    for (var i = 0; i < $SMSConfig.length ; i++) {

                        var $myData = [];
                        $myData.push('<tr  class="GridViewItemStyle">');
                        $myData.push('<td style="text-align:left" id="tdSNo">'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td style="text-align:left" id="tdModule">'); $myData.push($SMSConfig[i].Module); $myData.push('</td>');
                        $myData.push('<td style="text-align:left" id="tdScreen">'); $myData.push($SMSConfig[i].Screen); $myData.push('</td>');
                        $myData.push('<td style="text-align:left">'); $myData.push($SMSConfig[i].SMSTrigger); $myData.push('</td>');
                        $myData.push('<td style="text-align:left">');
                        if ($SMSConfig[i].ToWhom1 != "") {
                            $myData.push("<input type='checkbox'>"); $myData.push($SMSConfig[i].ToWhom1);
                        }
                        if ($SMSConfig[i].ToWhom2 != "") {
                            $myData.push("<input type='checkbox'>"); $myData.push($SMSConfig[i].ToWhom2);
                        }
                        if ($SMSConfig[i].ToWhom3 != "") {
                            $myData.push("<input type='checkbox'>"); $myData.push($SMSConfig[i].ToWhom3);
                        }
                        $myData.push('</td>');


                        $myData.push('<td>'); $myData.push('<select style="width:240px" id="ddlCentreTag_'); $myData.push($SMSConfig[i].ID); $myData.push('"'); $myData.push('name="ddlCentreTag_'); $myData.push($SMSConfig[i].ID); $myData.push('"'); $myData.push(' multiple></select>');
                        $myData.push('<img id="imgView" alt="View" src="../../App_Images/Post.gif" style="cursor:pointer" onclick="$saveTagType(this)"/>');
                        $myData.push('</td>');
                        $myData.push('<td>'); $myData.push('<img id="imgView" alt="View" src="../../App_Images/edit.png" style="cursor:pointer" onclick="$addClient(this)"/>'); $myData.push('</td>');

                        $myData.push('<td style="text-align:left">'); $myData.push($SMSConfig[i].SMSType); $myData.push('</td>');


                        $myData.push('<td >'); $myData.push("<input type='checkbox' onclick='activeDeactiveSMS(this)' ");
                        if ($SMSConfig[i].IsActive == "1")
                            $myData.push(' checked = "checked"');
                        $myData.push(' id="chk_'); $myData.push($SMSConfig[i].ID); $myData.push('"');
                        $myData.push('></td>');
                        $myData.push('<td id="tdID" style="display:none" >'); $myData.push($SMSConfig[i].ID); $myData.push('</td>');
                        $myData.push('<td >'); $myData.push('<img id="imgView" alt="View" src="../../App_Images/View.gif" style="cursor:pointer" onclick="$view(this)"/>'); $myData.push('</td>');

                        $myData.push('</tr>');
                        $myData = $myData.join("");
                        jQuery("#tblSMSConf tbody").append($myData);

                        jQuery("#ddlCentreTag_" + $SMSConfig[i].ID).bindDropDown({ data: JSON.parse(response).CentreType, valueField: 'ID', textField: 'type1' });

                        jQuery("#ddlCentreTag_" + $SMSConfig[i].ID).multiSelect({
                            selectAll: true,
                        });

                    };
                }
            });
        }
        $saveTagType = function (rowID) {

            var SNo = $(rowID).closest('tr').find("#tdSNo").text();
            var SMSConfigurationID = $(rowID).closest('tr').find("#tdID").text();

            var TagTypeID = $("#ddlCentreTag_" + SMSConfigurationID).val().toString();
            $confirmationBox("".concat('Do You want to save TagType of Module <b>', $(rowID).closest('tr').find("#tdModule").text(), '</b>'), 0, TagTypeID, SMSConfigurationID, '', '');
        }
        $addClient = function (rowID) {
            jQuery('#spnModule').text($(rowID).closest('tr').find("#tdModule").text());
            jQuery('#spnScreen').text($(rowID).closest('tr').find("#tdScreen").text());
            var ID = $(rowID).closest('tr').find("#tdID").text();
            $("#spnSMSID").text(ID);
            bindTagClient();
            jQuery('#divClient').showModel();
        }
        $view = function (rowID) {
            var ID = $(rowID).closest('tr').find("#tdID").text();
            serverCall('SMSConfigurationMaster.aspx/bindSMSTemplate', { ID: ID }, function (response) {
                var $SMSConfigDetail = JSON.parse(response);
                $("#spnSMSID").text(ID);
                $("#txtTemplate").val($SMSConfigDetail[0].Template);
                $("#spnActiveColumns").text($SMSConfigDetail[0].ActiveColumns);
                $("#txtSQLQuery").val($SMSConfigDetail[0].SQLQuery);
                jQuery('#divSmsView').showModel();
            });
        }
        saveSMSTemp = function () {
            if ($("#txtTemplate").val() == "") {
                toast('Error', 'Please Enter Template', '');
                $("#txtTemplate").focus();
                return;
            }

           
            if ($("#txtSQLQuery").val() == "") {
                toast('Error', 'Please Enter SQLQuery', '');
                $("#txtSQLQuery").focus();
                return;


            }
            serverCall('SMSConfigurationMaster.aspx/saveSMSTemplate', { ID: $("#spnSMSID").text(), Template: $("#txtTemplate").val(), SQLQuery: $("#txtSQLQuery").val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                }
                else {
                    toast('Error', $responseData.response, '');
                }
                $closeSMSView();
            });
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divSmsView').is(':visible')) {
                    $closeSMSView();
                }


            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        bindTagClient = function () {
            serverCall('SMSConfigurationMaster.aspx/bindClientType', {}, function (response) {
                $("#ddlTagClient").bindDropDown({ data: JSON.parse(response).CentreType, valueField: 'ID', textField: 'type1', isSearchAble: true, defaultValue: "Select", showDataValue: '' });
            });
        }
        $bindClient = function () {

            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");

            jQuery('#lstDiscardClient option').remove();
            jQuery('#lstDiscardClient').multipleSelect("refresh");

            serverCall('SMSConfigurationMaster.aspx/bindClient', { CentreType1ID: $("#ddlTagClient option:selected").val(), SmsConfigurationID: $("#spnSMSID").text() }, function (response) {
                $("#lstClient").bindMultipleSelect({ data: JSON.parse(response).client, valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstClient"), isClearControl: '' });
                $("#lstDiscardClient").bindMultipleSelect({ data: JSON.parse(response).bindClient, valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstDiscardClient"), isClearControl: '', showDataValue: '' });



                if (JSON.parse(response).isActivatedTypeID > 0) {
                    $("#btnClient").val('Discard Client');
                    $("#spnType").text('Discard Client');
                    $("#btnRemove").val('Remove Discard');
                }
                else {
                    $("#btnClient").val('Activate Client');
                    $("#spnType").text('Activate Client');
                    $("#btnRemove").val('Remove Activate');
                }
                if ($("#lstDiscardClient option").length > 0)
                    $(".divShow").show();
                else
                    $(".divShow").hide();

            });
        }
    </script>
    <script type="text/javascript">
        $confirmationBox = function (contentMsg, type, TagTypeID, SMSConfigurationID, CentreType1ID, rowID) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            $confirmationAction(type, TagTypeID, SMSConfigurationID, CentreType1ID, rowID);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction(type, rowID);
                        }
                    },
                }
            });
        }
        $confirmationAction = function ($type, TagTypeID, SMSConfigurationID, CentreType1ID, rowID) {
            if ($type == 0) {
                serverCall('SMSConfigurationMaster.aspx/saveTagType', { TagTypeID: TagTypeID, SmsConfigurationID: SMSConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);

                    if ($responseData.status) {
                        toast('Success', $responseData.response, '');
                    }
                    else {
                        toast('Error', $responseData.response, '');
                    }
                });

            }
            else if ($type == 1) {
                serverCall('SMSConfigurationMaster.aspx/removeClient', { ClientID: TagTypeID, CentreType1ID: CentreType1ID, SavingType: $("#btnClient").val(), SmsConfigurationID: SMSConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);

                    if ($responseData.status) {
                        toast('Success', $responseData.response, '');
                        jQuery('#ddlTagClient').prop('selectedIndex', 0);
                        jQuery('#ddlTagClient').chosen('destroy').chosen();
                        jQuery('#lstClient option').remove();
                        jQuery('#lstClient').multipleSelect("refresh");

                        jQuery('#lstDiscardClient option').remove();
                        jQuery('#lstDiscardClient').multipleSelect("refresh");
                    }
                    else {
                        toast('Error', $responseData.response, '');
                    }

                });
            }
            else if ($type == 2) {
                serverCall('SMSConfigurationMaster.aspx/activeDeactiveSMS', { Active: TagTypeID, SmsConfigurationID: SMSConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);

                    if ($responseData.status) {
                        toast('Success', $responseData.response, '');
                    }
                    else {
                        toast('Error', $responseData.response, '');
                    }
                });
            }
        }
        $clearAction = function (type, rowID) {
            if (rowID != "" && type == 2) {
                var ID = $(rowID).closest('tr').find("#tdID").text();
                if ($(rowID).closest('tr').find("#chk_" + ID).is(':checked')) {
                    $(rowID).closest('tr').find("#chk_" + ID).prop('checked', false);
                }
                else {
                    $(rowID).closest('tr').find("#chk_" + ID).prop('checked', 'checked');
                }
            }
        }
        saveClient = function () {
            if ($("#ddlTagClient").val() == "0") {
                toast('Error', 'Please Select TagClient', '');
                $("#ddlTagClient").focus();
                return;
            }
            var ClientID = $("#lstClient").val().toString();
            if (ClientID == "") {
                toast('Error', 'Please Select Client', '');
                $("#lstClient").focus();
                return;
            }
            serverCall('SMSConfigurationMaster.aspx/saveClient', { ClientID: ClientID, CentreType1ID: $("#ddlTagClient").val(), SavingType: $("#btnClient").val(), SmsConfigurationID: $("#spnSMSID").text() }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                    jQuery('#ddlTagClient').prop('selectedIndex', 0);
                    jQuery('#ddlTagClient').chosen('destroy').chosen();
                    jQuery('#lstClient option').remove();
                    jQuery('#lstClient').multipleSelect("refresh");

                    jQuery('#lstDiscardClient option').remove();
                    jQuery('#lstDiscardClient').multipleSelect("refresh");
                    $("#lstDiscardClient").bindMultipleSelect({ data: JSON.parse(response).bindClientActDis, valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstDiscardClient"), isClearControl: '', showDataValue: '' });

                }
                else {
                    toast('Error', $responseData.response, '');
                }
            });
        }
        removeDiscard = function () {
            var ClientID = $("#lstDiscardClient").val().toString();
            if (ClientID == "") {
                toast('Error', 'Please Select Client', '');
                $("#lstDiscardClient").focus();
                return;
            }
            $confirmationBox("".concat('Do You want to ', $("#btnRemove").val(), " Client"), 1, ClientID, $("#spnSMSID").text(), $("#ddlTagClient").val(), '');
        }
        activeDeactiveSMS = function (rowID) {
            var ID = $(rowID).closest('tr').find("#tdID").text();
            var Module = $(rowID).closest('tr').find("#tdModule").text();
            var Screen = $(rowID).closest('tr').find("#tdScreen").text();
            var msg = "DeActivate"; var Active = 0;
            if ($(rowID).closest('tr').find("#chk_" + ID).is(':checked')) {
                msg = "Activate";
                Active = 1;
            }


            $confirmationBox("".concat('Do You want to ', msg, " SMS<br/><br/><b>Module :", Module, "</b><br/><b>Screen :", Screen), 2, Active, ID, '', rowID);

        }
    </script>
</asp:Content>

