<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyExpanseReport.aspx.cs" Inherits="Design_PettyCash_PettyExpanseReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Expense Report</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Center</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcenter" runat="server"></asp:DropDownList>
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
                    <input type="button" value="Search" class="searchbutton" onclick="Bindtabledata('');" />
                    <input type="button" id="btnexportReport" class="searchbutton" onclick="exportReport()" value="Excel Report" />
                </div>
                <div class="col-md-4" style="text-align: center"></div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: Pink; border-radius: 9px; cursor: pointer" onclick="Bindtabledata(0);">
                </div>
                <div class="col-md-1">
                    <span onclick="Bindtabledata(0)">New</span>
                </div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: #90EE90; border-radius: 9px; cursor: pointer" onclick="Bindtabledata(1);">
                </div>
                <div class="col-md-1">
                    <span onclick="Bindtabledata(1)">Accept</span>
                </div>

                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: aqua; border-radius: 9px; cursor: pointer" onclick="Bindtabledata(2);">
                </div>
                <div class="col-md-1">
                    <span onclick="Bindtabledata(2)">Reject</span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expenses Detail
            </div>
            <div style="width: 100%; max-height: 375px; overflow: auto;">
                <div class="row">
                    <div class="col-md-24">
                        <table id="transfertable" style="border-collapse: collapse; width: 100%;">
                            <thead>
                                <tr id="tr1">
                                    <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Center Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Expense Type</td>
                                    <td class="GridViewHeaderStyle" style="width: 80px;">Amount</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">CreatedBy</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Type</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Bank</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Card No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Reciept</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px;">Status</td>
                                    <td class="GridViewHeaderStyle" style="width: 140px;">Remarks</td>
                                    <td class="GridViewHeaderStyle" style="width: 140px;">Approved By</td>
                                    <td class="GridViewHeaderStyle" style="width: 110px;">Approved Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 110px;">Invoice No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 110px;">Narration</td>
                                    <td class="GridViewHeaderStyle" style="width: 110px;">Remark</td>
                                    <td class="GridViewHeaderStyle" style="width: 60px;">Action</td>
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
        function exportReport() {
            $("#transfertable").remove(".noExl").table2excel({
                name: "Petty Cash Expance Report",
                filename: "ExpansesReport", //do not include extension
                exclude_inputs: false
            });
        }
    </script>
    <script type="text/javascript">
        function Bindtabledata(status) {
            var grossamt = 0;
            var rejectamt = 0;
            var netamt = 0;
            if ($('#<%=ddlcenter.ClientID%>').val() == "0") {
                toast("Error", "Please Select Center");
                $('#<%=ddlcenter.ClientID%>').focus();
                return false;
            }
            $('#transfertable tr').slice(1).remove();
            serverCall('PettyExpanseReport.aspx/bindtable', { status: status, centerid: $('#<%=ddlcenter.ClientID%>').val(), fromdate: $('#<%=txtentrydatefrom.ClientID%>').val(), todate: $('#<%=txtentrydateto.ClientID%>').val() }, function (response) {
                var ItemData = jQuery.parseJSON(response);

                if (ItemData.length == 0) {
                    toast("Info", "No Data Found");
                }
                else {

                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        grossamt = parseInt(grossamt) + Math.abs(ItemData[i].amount);
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].rowColor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("'>");
                        $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].centrecode); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].centre); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].DATE); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].ExpansesType); $myData.push('</td>');
                        $myData.push('<td style="text-align:right">'); $myData.push(Math.abs(ItemData[i].amount)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].createby); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].TYPE); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].paymentmode); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].Bank); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].CardNo); $myData.push('</td>');
                        if (ItemData[i].Filename != "") {

                            $myData.push('<td style="text-align:left"><a href="javascript:void(0)" onclick="showuploadbox('); $myData.push(ItemData[i].Filename); $myData.push(')" > View</a></td>');

                        }
                        else
                            $myData.push('<td ></td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].STATUS); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].CancelRemarks); $myData.push('</td>');
                        if (ItemData[i].ApprovedBy === null) {
                            $myData.push('<td> </td>');
                        }
                        else {
                            $myData.push('<td>'); $myData.push(ItemData[i].ApprovedBy); $myData.push('</td>');
                        }

                        if (ItemData[i].ApprovedDate === null) {
                            $myData.push('<td> </td>');
                        }
                        else {
                            $myData.push('<td>'); $myData.push(ItemData[i].ApprovedDate); $myData.push('</td>');
                        }

                        $myData.push('<td>'); $myData.push(ItemData[i].InvoiceNo); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].Narration); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].Remarks); $myData.push('</td>');
                        if (ItemData[i].IsApproved == "0") {
                            $myData.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow('); $myData.push(ItemData[i].id); $myData.push(')" /></td>');
                        }
                        else {
                            $myData.push('<td></td>');
                        }
                        if (ItemData[i].IsApproved == '2') {
                            rejectamt = parseInt(rejectamt) + Math.abs(ItemData[i].amount);
                        }
                        netamt = parseInt(grossamt) - parseInt(rejectamt)
                        $myData.push('</tr>');
                        $myData = $myData.join("");
                        $('#transfertable').append($myData);
                    }
                    var $myData1 = [];
                    $myData1.push("<tr id='footer' style='font-weight:bold;color:red;'>");
                    $myData1.push('<td colspan="5" align="right">Total::&nbsp;&nbsp;&nbsp;</td>');
                    $myData1.push('<td>'); $myData1.push(grossamt); $myData1.push('</td>');
                    $myData1.push('<td  align="right">RejectedAmt::&nbsp;</td>');
                    $myData1.push('<td>'); $myData1.push(rejectamt); $myData1.push('</td>');
                    $myData1.push('<td  align="right">Net::&nbsp;</td>');
                    $myData1.push('<td>'); $myData1.push(netamt); $myData1.push('</td>');
                    $myData1.push("</tr>");
                    $myData1 = $myData1.join("");
                    $('#transfertable').append($myData1);
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
            serverCall('PettyExpanseReport.aspx/removerow', { id: rowID }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);

                    Bindtabledata('');

                }
                else {
                    toast("Error", $responseData.response);
                }

            });
        }
        $clearAction = function () {

        }
        function showuploadbox(FileName) {

            $fancyBoxOpen('UploadExpncesDoc.aspx?FileName=' + FileName + '&IsView=1');
        }
    </script>
</asp:Content>