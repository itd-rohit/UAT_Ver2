<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ExpanseReportAdmin.aspx.cs" Inherits="Design_PettyCash_ExpanseReportAdmin" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Expense Approve</b>
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

                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-4">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-12"></div>
                <div class="col-md-2" style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="existingdata();" />
                </div>
                <div class="col-md-4"></div>
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
                    <div class="col-md-24" style="text-align: center">
                        <table id="pettyexpense" style="width: 100%; border-collapse: collapse; text-align: center;">
                            <tr>
                                <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">Center code</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>

                                <td class="GridViewHeaderStyle" style="width: 90px;">Amount</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">Date</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">CreatedBy</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">Type</td>
                                <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Invoice No.</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">Bank</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">Card No.</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">ApprovedBy</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">ApprovedDate</td>
                                <td class="GridViewHeaderStyle" style="width: 100px;">Reciept</td>
                            </tr>
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

            $('#lstCentre').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindCentre(0);

        });

        function bindCentre(state) {
            jQuery('#lstCentre option').remove();

            serverCall('PettyCashTransfer.aspx/bindCentre', { State: state }, function (response) {
                jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'Centreid', textField: 'centre', controlID: jQuery("#lstCentre") });

            });

        }

        function existingdata() {

            var temp = [];
            var result;
            var center = $('#lstCentre').val().toString();
            serverCall('ExpanseReportAdmin.aspx/SearchRecords', { Centreid: center, fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    commontabledata(ItemData);
                }
                else {
                    $('#pettyexpense tr').slice(1).remove();
                    toast("Info", "No Data Found");
                }
            });
        }
        function commontabledata(ItemData) {
            $('#pettyexpense tr').slice(1).remove();
            for (var i = 0; i <= ItemData.length - 1; i++) {
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
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].InvoiceNo); $myData.push('</td>');
                $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Bank); $myData.push('</td>');
                if (ItemData[i].CardNo == "0") {
                    $myData.push('<td></td>');
                }
                else {
                    $myData.push('<td>'); $myData.push(ItemData[i].CardNo); $myData.push('</td>');
                }
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
                if (ItemData[i].Filename == null) {
                    $myData.push('<td></td>');
                }
                else {
                    $myData.push('<td style="text-align:left"><a href='); $myData.push(ItemData[i].Filename); $myData.push('>view</a></td>');
                }
                $myData.push('</tr>');
                $myData = $myData.join("");
                $('#pettyexpense').append($myData);
            }
        }
        function clearForm() {

            $('#lstCentre').html('');
            //$('#txtentrydatefrom').val('');
            //$('#txtentrydateto').val('');
        }
        function AllIssue(status) {
            $('#pettyexpense tr').slice(1).remove();
            serverCall('ExpanseReportAdmin.aspx/bindtablewithstatus', { status: status }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    commontabledata(ItemData);
                }
                else {
                    toast("Info", "No Data Found");
                }
            });
        }
    </script>
</asp:Content>