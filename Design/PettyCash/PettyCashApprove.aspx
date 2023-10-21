<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyCashApprove.aspx.cs" Inherits="Design_PettyCash_Pettycashapprove" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
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
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Center</label>
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
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">ExpenseType</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlExpense" SelectionMode="Multiple" runat="server" ClientIDMode="Static" CssClass="multiselect"></asp:ListBox>
                </div>
                <div class="col-md-6"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-9"></div>
                <div class="col-md-4" style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="existingdata('',0)" />
                    <input type="button" value="Excel" class="searchbutton" onclick="existingdata('',1)" />
                </div>
                <div class="col-md-3" style="text-align: center">
                </div>
                <div class="col-md-1 square badge-Tested" onclick="existingdata(0,0)" style="height: 20px; width: 2%; float: left; cursor: pointer">
                </div>
                <div class="col-md-2" onclick="existingdata(0,0)">
                    New
                </div>
                <div class="col-md-1 square badge-Approved " onclick="existingdata(1,0)" style="height: 20px; width: 2%; float: left; cursor: pointer">
                </div>
                <div class="col-md-2" onclick="existingdata(1,0)">
                    Accept
                </div>
                <div class="col-md-1 square badge-Printed" onclick="existingdata(2,0)" style="height: 20px; width: 2%; float: left; cursor: pointer">
                </div>
                <div class="col-md-1" onclick="existingdata(2,0)">
                    Reject
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expenses Detail
            </div>
            <div class="row">
                <table id="pettyexpense" style="width: 100%; border-collapse: collapse; text-align: center;">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Center Code</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Amount</td>
                        <td class="GridViewHeaderStyle" style="width: 90px;">Date</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Created By</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Type</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Invoice No.</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Invoice Date</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Bank & Card No.</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Approved By & Date</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Receipt</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">Expense Type</td>
                        <td class="GridViewHeaderStyle" style="width: 40px;">Narration</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Action</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:Button ID="butpettyaccept" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash1" runat="server" TargetControlID="butpettyaccept" BehaviorID="modalpettycash1" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" CancelControlID="btnacceptCancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel1" Style="display: none; width: 350px; height: 130px;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Remark</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">

                    <asp:TextBox ID="txtRemark" runat="server" MaxLength="200"></asp:TextBox>
                </div>
            </div>

            <div class="row" style="text-align: center;">
                <input id="btnaccept" type="button" value="Submit" onclick="Accept()" class="searchbutton" />
                <input id="btnacceptCancel" type="button" class="searchbutton" value="Cancel" />
            </div>

            <div class="row">
                <asp:Label ID="labacceptid" runat="server"></asp:Label>
            </div>
        </div>
    </asp:Panel>

    <asp:Button ID="butpettyreject" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash2" runat="server" TargetControlID="butpettyreject" BehaviorID="modalpettycash2" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" CancelControlID="butrejectcancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" Style="display: none; width: 350px; height: 130px;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls">
            <div class="row">
                <div class="col-md-6">
                    <label class="pull-left">Remark</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-18">

                    <asp:TextBox ID="txtcancelremark" runat="server" MaxLength="200"></asp:TextBox>
                </div>
            </div>

            <div class="row" style="text-align: center;">
                <input id="butreject" type="button" value="Submit" onclick="Reject()" class="searchbutton" />
                <input id="butrejectcancel" type="button" class="searchbutton" value="Cancel" />
            </div>

            <div class="row" style="display: none">
                <asp:Label ID="lblrejectid" runat="server"></asp:Label>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        function exportReport() {
            $("#pettyexpense").remove(".noExl").table2excel({
                name: "Petty Cash Approve",
                filename: "PettyCashApprove", //do not include extension
                exclude_inputs: false
            });
        }
    </script>
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
            $('[id*=ddlExpense]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            BindExpense();
        });
        function BindExpense() {
            serverCall('PettyCashapprove.aspx/Bindexpense', {}, function (response) {
                jQuery('#ddlExpense').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Typename', controlID: $("#ddlExpense"), isClearControl: '' });
            });
        }
        function bindCentre(state) {
            jQuery('#lstCentre option').remove();
            if (state != "") {
                serverCall('PettyCashTransfer.aspx/bindCentre', { State: state }, function (response) {
                    jQuery("#lstCentre").bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Centreid', textField: 'centre', isSearchAble: true });

                });
            }
        }
        function existingdata(status,IsReport) {
            var temp = [];
            var result;
            var divide = $('#lstCentre').val();
            if (divide == null || divide == "0") {
                result = "";
            }
            else {
                temp = divide.split('#');
                result = temp[0];
            }

            var ExpType = '';
            var SelectedLaength = $('#ddlExpense').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                ExpType += $('#ddlExpense').multipleSelect("getSelects").join().split(',')[i] + ',';
            }
            if (ExpType.replace(',', '') == "") {
                toast("Error", 'Select Expense Type')
                return;
            }
            $('#pettyexpense tr').slice(1).remove();
            serverCall('PettyCashapprove.aspx/SearchRecords', { status: status, Centreid: result, fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val(), ExpType: ExpType,IsReport:IsReport }, function (response) {
               if (IsReport == 1) {
                    if (response == 1)
                        window.open('../Common/ExportToExcel.aspx');
                    else
                        toast("Info", "No Data Found", "");

                }
                else {
                    $responseData = $.parseJSON(response);
                    if ($responseData.length == 0) {

                        toast("Info", "No Data Found", "");
                    }
                    else {
                        commontabledata($responseData);
                    }

                }
            });
        }
        function commontabledata($responseData) {
            var grossamt = 0;
            $('#pettyexpense tr').slice(1).remove();
            for (var i = 0; i <= $responseData.length - 1; i++) {
                grossamt = parseInt(grossamt) + Math.abs($responseData[i].amount);
                var $mydata = [];
                $mydata.push("<tr style='border-bottom:1px solid black;background-color:");
                $mydata.push($responseData[i].rowColor); $mydata.push(";' id='");
                $mydata.push($responseData[i].id); $mydata.push("'>");
                $mydata.push('<td >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].CentreCode); $mydata.push('</td>');

                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].Centre); $mydata.push('</td>');
                $mydata.push('<td style="text-align:right">'); $mydata.push(Math.abs($responseData[i].Amount)); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].DATE); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].CreatedBy); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].TYPE); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].PaymentMode); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].InvoiceNo); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].InvoiceDate); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].Bank); $mydata.push(' - '); $mydata.push($responseData[i].CardNo); $mydata.push('</td>');

                if ($responseData[i].ApprovedDate == null) {
                    $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].ApprovedBy); $mydata.push(' - '); $mydata.push('</td>');
                }
                else {
                    $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].ApprovedBy); $mydata.push(' - '); $mydata.push($responseData[i].ApprovedDate); $mydata.push('</td>');
                }
                if ($responseData[i].Filename != "") {

                    $mydata.push('<td style="text-align:left"><a href="javascript:void(0)" onclick="showuploadbox('); $mydata.push($responseData[i].Filename); $mydata.push(')" > View</a></td>');
                }
                else
                    $mydata.push('<td ></td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].ExpansesType); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].Narration); $mydata.push('</td>');
                if ($responseData[i].IsApproved == '0') {
                    $mydata.push('<td style="text-align:left"><input type="button" id="accept" class="searchbutton" value="Accept" onclick="Accept(');
                    $mydata.push($responseData[i].id); $mydata.push(')" />&nbsp;&nbsp;<input type="button" id="reject" class="resetbutton" value="Reject" onclick="CancelRemark('); $mydata.push($responseData[i].id); $mydata.push(')" /></td>');
                }
                else {
                    $mydata.push('<td></td>');
                }
                $mydata.push('</tr>');
                $mydata = $mydata.join("");
                $('#pettyexpense').append($mydata);
            }
            var $mydata1 = [];
            $mydata1.push("<tr id='footer' style='font-weight:bold;color:red;'>");
            $mydata1.push('<td colspan="3" align="right">Total::&nbsp;&nbsp;&nbsp;</td>');
            $mydata1.push('<td>' + grossamt + '</td>');
            //mydata1 += '<td>' + discamt + '</td>';
            //mydata1 += '<td>' + netamt + '</td>';
            //mydata1 += '<td>' + paidamt + '</td>';
            $mydata1.push("</tr>");
            $mydata1 = $mydata1.join("");
            $('#pettyexpense').append($mydata1);

        }
        function Accept(itemid) {
            var remark = ""; //$('#txtRemark').val();
            var id = itemid; //$('#labacceptid').val();
            if (id != "") {
                serverCall('PettyCashapprove.aspx/acceptexpense', { ID: id, Remark: remark }, function (response) {
                    if (response.split('#')[0] == "1") {
                        existingdata('',0);
                        $('#txtRemark').val('');
                        $find("modalpettycash1").hide();
                        toast("Success", "Data Accept Successfully", "");
                    }
                });
            }
        }
        function Reject() {
            if ($.trim($('#txtcancelremark').val()) == "") {
                toast("Success", "Please Enter Remark", "");
                $('#txtcancelremark').focus();
                return;
            }
            var cancelremark = $('#txtcancelremark').val();
            var id = $('#lblrejectid').text();
            if (id != "") {
                serverCall('PettyCashapprove.aspx/rejectexpense', { ID: id, Cancelremark: cancelremark }, function (response) {
                    if (response.split('#')[0] == "1") {
                        existingdata('',0);
                        $('#txtcancelremark').val('');
                        $find("modalpettycash2").hide();
                        toast("Success", "Data Reject Successfully", "");
                    }
                });
            }
        }
        function CancelRemark(id) {
            $('#lblrejectid').text(id);
            $find("modalpettycash2").show();
        }

        function clearForm() {
            $('#lstCentre').html('');
            //  $('#txtentrydatefrom').val('');
            //  $('#txtentrydateto').val('');
        }
        function showuploadbox(FileName) {

            $fancyBoxOpen('UploadExpncesDoc.aspx?FileName=' + FileName + '&IsView=1');
        }
    </script>
</asp:Content>