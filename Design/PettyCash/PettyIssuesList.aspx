<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyIssuesList.aspx.cs" Inherits="Design_PettyCash_pettyissueslist" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Issue New/Accept/Reject</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                PettyCash
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-2" style="display: none">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre($(this).val());"></asp:ListBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="lstCentre" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-10"></div>
                <div class="col-md-4" style="text-align: center">
                    <input type="button" id="btnSearch" class="searchbutton" onclick="Bindtabledata('Serch')" value="Search" />
                    <input type="button" id="btnexportReport" class="searchbutton" onclick="Bindtabledata('Excel')" value="Excel Report" />
                </div>
                <div class="col-md-4" style="text-align: center"></div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: Pink; border-radius: 9px" onclick="AllIssue(0);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllIssue(0)">New</span>
                </div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: #90EE90; border-radius: 9px" onclick="AllIssue(1);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllIssue(1)">Accept</span>
                </div>

                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: aqua; border-radius: 9px" onclick="AllIssue(2);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllIssue(2)">Reject</span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expanses Detail
            </div>
            <div style="width: 100%; max-height: 375px; overflow: auto;">
                <div class="row">
                    <div class="col-md-24">
                        <table id="transfertable" style="border-collapse: collapse; width: 100%;">
                            <thead>
                                <tr id="tr1">
                                    <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Center Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>

                                    <td class="GridViewHeaderStyle" style="width: 80px;">Amount</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 140px;">Created By</td>
                                    <td class="GridViewHeaderStyle" style="width: 60px;">Type</td>
                                    <td class="GridViewHeaderStyle" style="width: 110px;">Payment Mode</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Card No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Bank</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Approved By</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">ApprovedDate</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Reject Remark</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Remark</td>
                                    <td class="GridViewHeaderStyle" style="width: 80px;">Action</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
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

            bindCentre('0');

        });

        function bindCentre(state) {
            jQuery('#lstCentre option').remove();
            if (state != "") {
                serverCall('PettyCashTransfer.aspx/bindCentre', { State: state }, function (response) {
                    jQuery("#lstCentre").bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Centreid', textField: 'centre', isSearchAble: true });

                });
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $('#txtentrydatefrom').bind('blur', function () {
                var StartDate = $('#txtentrydatefrom').val();
                var EndDate = $('#txtentrydateto').val();
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                if (StartDate != '' && StartDate != '' && sDate > eDate) {
                    toast("Error", "Please ensure that the End Date is greater than or equal to the Start Date.");
                    return false;
                }
            });
            $('#txtentrydateto').bind('blur', function () {

                var StartDate = $('#txtentrydatefrom').val();
                var EndDate = $('#txtentrydateto').val();
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                if (StartDate != '' && StartDate != '' && sDate > eDate) {
                    toast("Error", "Please ensure that the End Date is greater than or equal to the Start Date.");
                    return false;
                }
            });
        });

        function Bindtabledata(type) {

            var temp = [];
            var result;
            if ($('#lstCentre').val() == null) {
                result = "";
            }
            else {
                var divide = $('#lstCentre').val();
                temp = divide.split('#');
                result = temp[0];
            }

            var StartDate = $('#txtentrydatefrom').val();
            var EndDate = $('#txtentrydateto').val();
            var eDate = new Date(EndDate);
            var sDate = new Date(StartDate);
            if (StartDate != '' && StartDate != '' && sDate > eDate) {
                toast("Error", "Please ensure that the End Date is greater than or equal to the Start Date.");
                return false;
            }

            serverCall('pettyissueslist.aspx/bindtable', { centerid: result, fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val(), type: type }, function (response) {

                var ItemData = jQuery.parseJSON(response);

                if (ItemData.length == 0) {
                    $('#transfertable tr').slice(1).remove();
                    toast("Info", "No Data Found");
                }
                else {
                    commontabledatabind(ItemData)
                    if (type == "Excel") {
                        window.location = "../Common/ExportToExcel.aspx";
                    }
                }
            });
        }

        function commontabledatabind(ItemData) {

            var grossamt = 0;
            $('#transfertable tr').slice(1).remove();
            for (var i = 0; i <= ItemData.length - 1; i++) {
                grossamt = parseInt(grossamt) + ItemData[i].amount;
                var $myData = [];
                $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].rowColor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("'>");
                $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].centrecode); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].centre); $myData.push('</td>');

                $myData.push('<td style="text-align:right">'); $myData.push(Math.abs(ItemData[i].amount)); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].DATE); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].createby); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].TYPE); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].paymentmode); $myData.push('</td>');
                if (ItemData[i].CardNo == "0") {
                    $myData.push('<td></td>');
                }
                else {
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].CardNo); $myData.push('</td>');
                }
                $myData.push('<td>'); $myData.push(ItemData[i].Bank); $myData.push('</td>');
                if (ItemData[i].ApprovedBy == null) {
                    $myData.push('<td></td>');
                }
                else {
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].ApprovedBy); $myData.push('</td>');
                }
                if (ItemData[i].ApprovedDate == null) {
                    $myData.push('<td></td>');
                }
                else {
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].ApprovedDate); $myData.push('</td>');
                }
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].CancelRemark); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Remarks); $myData.push('</td>');
                if (ItemData[i].IsApproved == "0") {
                    $myData.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow('); $myData.push(ItemData[i].id); $myData.push(')" /></td>');
                }
                else {
                    $myData.push('<td></td>');
                }
                $myData.push('</tr>');
                $myData = $myData.join("");
                $('#transfertable').append($myData);
            }
            var $myData1 = [];
            $myData1.push("<tr id='footer' style='font-weight:bold;color:red;'>");
            $myData1.push('<td colspan="3" align="right">Total::&nbsp;&nbsp;&nbsp;</td>');
            $myData1.push('<td>'); $myData1.push(grossamt); $myData1.push('</td>');

            $myData1.push("</tr>");
            $myData1 = $myData1.join("");
            $('#transfertable').append($myData1);
        }
    </script>
    <script type="text/javascript">

        function AllIssue(status) {
            var divide = $('#lstCentre').val();
            if (divide == null || divide == "0") {
                result = "";
            }
            else {
                temp = divide.split('#');
                result = temp[0];
            }

            $('#transfertable tr').slice(1).remove();

            serverCall('pettyissueslist.aspx/bindtablewithstatus', { status: status, Centre: result, fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No Data Found");
                }
                else {
                    commontabledatabind(ItemData);
                }
            });
        }
        function deleterow(id) {
            $confirmationBox('Are you sure you want delete this record?', id);
        }
        $confirmationBox = function (contentMsg, rowID) {
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
                            $confirmationAction(rowID);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        $confirmationAction = function (rowID) {
            serverCall('pettyissueslist.aspx/removerow', { id: rowID }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);

                    Bindtabledata();
                }
                else {
                    toast("Error", $responseData.response);
                }

            });
        }
        $clearAction = function () {

        }
    </script>
</asp:Content>