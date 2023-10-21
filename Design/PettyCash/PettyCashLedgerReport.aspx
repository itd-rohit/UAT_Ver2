<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyCashLedgerReport.aspx.cs" Inherits="Design_PettyCash_PettyCashLedgerReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Ledger Report</b>
                </div>
            </div>
            <div class="row">
                <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align: center">
                    <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" onchange="Changereport()">
                        <asp:ListItem Text="Month Wise" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Date Wise" Value="2"></asp:ListItem>
                        <asp:ListItem Text="ALL" Value="3"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Petty Cash Ledger Report
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-2" style="display: none">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre($(this).val().toString());"></asp:ListBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="lstCentre" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">ExpenseType</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlExpense" runat="server"></asp:DropDownList>
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
                <div class="col-md-5"></div>

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
            <input type="button" id="btnSearch" class="searchbutton" onclick="searchLedger()" value="Search" />
            <input type="button" id="btnexportReport" class="searchbutton" onclick="exportReport()" value="Excel Report" />
        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Petty Cash Ledger Report Details
            </div>

            <div style="width: 100%; max-height: 475px; max-height: 475px; overflow-y: scroll;">
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <div style="width: 100%;">
                            <table id="ledgerstatus" style="border-collapse: collapse; width: 100%;">
                                <thead>
                                    <tr id="tr1">
                                        <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Center Code</td>
                                        <td class="GridViewHeaderStyle" style="width: 350px;">Center Name</td>

                                        <td class="GridViewHeaderStyle" style="width: 120px;">Amount Recieved</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">Amount Paid</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">Month</td>
                                        <td id="tdreciept" class="GridViewHeaderStyle" style="width: 120px; display: none;">Receipt</td>
                                        <td id="exptype" class="GridViewHeaderStyle" style="width: 100px; display: none;">Expense Type</td>
                                        <td id="narration" class="GridViewHeaderStyle" style="width: 160px; display: none;">Narration</td>
                                        <td id="tdRemark" class="GridViewHeaderStyle" style="width: 160px; display: none;">Remark</td>
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
        function Changereport() {
            $('#ledgerstatus tr').slice(1).remove();
        }
        function bindCentre(state) {
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            if (state != "") {
                serverCall('PettyCashTransfer.aspx/bindCentre', { State: state }, function (response) {
                    jQuery("#lstCentre").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Centreid', textField: 'centre', isSearchAble: true });
                    $("#lstCentre option").eq(1).before($('<option>', {
                        value: 'ALL',
                        text: 'ALL'
                    }));
                    jQuery("#lstCentre").chosen("destroy").chosen({ width: '100%' });
                });

            }
        }
    </script>
    <script type="text/javascript">
        function exportReport() {
            $("#ledgerstatus").remove(".noExl").table2excel({
                name: "Petty Cash Ledger Report",
                filename: "PettyCashLedgerStatusReport", //do not include extension
                exclude_inputs: false
            });
        }
    </script>

    <script type="text/javascript">

        function searchLedger() {
            var total = 0;
            var totalExp = 0;
            var totalIssue = 0;
            var centreid = "";

            if ($('#<%=lstCentre.ClientID%>').val() == "0") {
                toast("Error", "Please Enter Centre ");
                $('#<%=lstCentre.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlExpense.ClientID%>').val() == "") {
                toast("Error", "Please Select Expense ");
                $('#<%=ddlExpense.ClientID%>').focus();
                return;
            }

            if ($('#<%=rblSearchType.ClientID %> input[type=radio]:checked').val() != "1") {
                $('#ledgerstatus tr #month').html("Date");
            }
            else {
                $('#ledgerstatus tr #month').html("Month");
            }
            serverCall('PettyCashLedgerReport.aspx/bindtable', { Centreid: $('#<%=lstCentre.ClientID%>').val(), fromdate: $('#<%=txtentrydatefrom.ClientID%>').val(), todate: $('#<%=txtentrydateto.ClientID%>').val(), viewtype: $('#<%=rblSearchType.ClientID %> input[type=radio]:checked').val(), ExpType: $('#<%=ddlExpense.ClientID%>').val() }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No Data Found");
                }
                else {
                    $('#ledgerstatus tr').slice(1).remove();
                    $('#btnexportReport').css('display', '');
                    $("#exptype,#narration,#tdreciept,#tdRemark").hide();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        if (i == 0) {
                            $myData.push("<tr class='Purchaseheader'><td colspan='5' style='text-align: right'>Opening Amount ");
                            $myData.push(ItemData[i].opening); $myData.push("</td></tr>");
                        }
                        else {
                            if (ItemData[i].centreid != centreid) {
                                total = Number(ItemData[i - 1].opening) + Number(ItemData[i - 1].TotalIssue) + Number(ItemData[i - 1].TotalExpense);
                                $myData.push("<tr class='Purchaseheader' style='background: pink;'><td colspan='3' style='text-align: right'>Issue Amount: ");
                                $myData.push(ItemData[i - 1].TotalIssue); $myData.push("</td><td colspan='2'  style='text-align: right'>Total Exp: ");
                                $myData.push(ItemData[i - 1].TotalExpense.replace('-', '')); $myData.push("</td><td colspan='2'  style='text-align: right'>Available Amount: ");
                                $myData.push(total); $myData.push("</td></tr>");
                                $myData.push("<tr class='Purchaseheader' ><td colspan='5' style='text-align: right'>Opening Amount "); $myData.push(ItemData[i].opening);
                                $myData.push("</td></tr>");
                            }
                        }
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].rowColor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("'>");
                        $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].centreCode); $myData.push('</td>');
                        $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Centre); $myData.push('</td>');

                        if (ItemData[i].Total >= 0) {
                            $myData.push('<td style="text-align: right">'); $myData.push(Math.abs(ItemData[i].Total)); $myData.push('</td>');
                        }
                        else {
                            $myData.push('<td></td>');
                        }
                        if (ItemData[i].Total < 0) {
                            $myData.push('<td style="text-align: right">'); $myData.push(Math.abs(ItemData[i].Total)); $myData.push('</td>');
                        }
                        else {
                            $myData.push('<td></td>');
                        }

                        $myData.push('<td>'); $myData.push(ItemData[i].month); $myData.push('</td>');
                        if ($('#<%=rblSearchType.ClientID %> input[type=radio]:checked').val() == "3") {
                            $("#exptype").show();
                            $("#narration").show();
                            $("#tdreciept").show();
                            $("#tdRemark").show();
                            if (ItemData[i].Filename != "") {
                                var str1 = ItemData[i].Filename;
                                //if (str1.split('.')[1] == "jpg")
                                //{
                                //    var FileName = ItemData[i].Filename.replace(/\\/g, "_");
                                //    $myData.push('<td>  <input type="button" value="View" onclick="imagepopup(\'');$myData.push(FileName);$myData.push('\')" /></td> ');
                                //}
                                //else
                                //    $myData.push('<td><a href="');$myData.push(ItemData[i].Filename);$myData.push('" target="_blank" > View</a></td>');

                                $myData.push('<td style="text-align:left"><a href="javascript:void(0)" onclick="showuploadbox('); $myData.push(ItemData[i].Filename); $myData.push(')" > View</a></td>');

                            }
                            else
                                $myData.push('<td></td>');
                            $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].ExpansesType); $myData.push('</td>');
                            $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Narration); $myData.push('</td>');
                            $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Remarks); $myData.push('</td>');

                        }
                        $myData.push('</tr>');

                        if (i == ItemData.length - 1) {
                            total = Number(ItemData[i - 1].opening) + Number(ItemData[i - 1].TotalIssue) + Number(ItemData[i - 1].TotalExpense);
                            $myData.push("<tr class='Purchaseheader'><td colspan='2' style='text-align: right'>Issue Amount: "); $myData.push(ItemData[i - 1].TotalIssue); $myData.push("</td><td colspan='1'  style='text-align: right'>Total Exp: "); $myData.push(ItemData[i - 1].TotalExpense.replace('-', '')); $myData.push("</td><td colspan='2'  style='text-align: right'>Available Amount: "); $myData.push(total); $myData.push("</td></tr>");
                        }
                        centreid = ItemData[i].centreid;
                        $myData = $myData.join("");
                        $('#ledgerstatus').append($myData);
                    }
                }
            });

        }

        function showuploadbox(FileName) {

            $fancyBoxOpen('UploadExpncesDoc.aspx?FileName=' + FileName + '&IsView=1');
        }
    </script>
</asp:Content>