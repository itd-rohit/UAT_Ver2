<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyCashLedgerStatus.aspx.cs" Inherits="Design_PettyCash_PettyCashLedgerStatus" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Ledger Status</b>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Petty Cash Ledger Status
            </div>

            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2"></div>

                <div class="col-md-3">
                    <input type="button" value="Search" class="searchbutton" onclick="Bindtabledata();" />
                    <input type="button" id="btnexportReport" class="searchbutton" onclick="exportReport()" value="Excel Report" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Petty Cash Ledger Status Details
            </div>
            <div class="row">
                <table id="ledgerstatus" style="border-collapse: collapse; width: 100%;">
                    <thead>
                        <tr id="tr1">
                            <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 120px;">Center Code</td>
                            <td class="GridViewHeaderStyle" style="width: 260px;">Center Name</td>

                            <td class="GridViewHeaderStyle" style="width: 140px;">Total Issued Amt.</td>
                            <td class="GridViewHeaderStyle" style="width: 120px;">Total Expenses</td>
                            <td class="GridViewHeaderStyle" style="width: 120px;">Available Amt.</td>
                            <td class="GridViewHeaderStyle" style="width: 140px;">Pending for Approval Amt.</td>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function exportReport() {
            $("#ledgerstatus").remove(".noExl").table2excel({
                name: "Petty Cash Ledger Status",
                filename: "PettyCashLedgerStatusReport", //do not include extension
                exclude_inputs: false
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            Bindtabledata();
        });
        function Bindtabledata() {
            var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var eDate = new Date();
            var sDate = new Date(StartDate);
            if (StartDate != '' && StartDate != '' && sDate > eDate) {
                toast("Error", "Please ensure that the Search Date is less than or equal to the Current Date.", "");
                return false;
            }
            serverCall('PettyCashLedgerStatus.aspx/bindtable', { todate: $('#<%=txtentrydatefrom.ClientID%>').val() }, function (response) {
                $responseData = $.parseJSON(response);
                if ($responseData.length == 0) {
                    $('#ledgerstatus tr').slice(1).remove();
                    toast("Info", "No Data Found", "");
                }
                else {
                    $('#ledgerstatus tr').slice(1).remove();
                    for (var i = 0; i <= $responseData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr  id='"); $mydata.push($responseData[i].id); $mydata.push("'>");
                        $mydata.push('<td >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].centreCode); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].Centre); $mydata.push('</td>');

                        $mydata.push('<td style="text-align:right"> <b>'); $mydata.push($responseData[i].TotalIssue); $mydata.push('</b></td>');
                        $mydata.push('<td style="text-align:right"> <b>'); $mydata.push($responseData[i].TotalExp); $mydata.push('</b></td>');
                        $mydata.push('<td style="text-align:right"> <b>'); $mydata.push($responseData[i].Total); $mydata.push('</b></td>');
                        $mydata.push('<td style="text-align:right"> <b>'); $mydata.push($responseData[i].pending); $mydata.push('</b></td>');
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#ledgerstatus').append($mydata);
                    }
                }
            });
        }
    </script>
</asp:Content>