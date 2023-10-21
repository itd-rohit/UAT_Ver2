<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyCashRejectApproval.aspx.cs" Inherits="Design_PettyCash_PettyCashRejectApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Expense/Payment Reject</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                PettyCash
            </div>
            <div class="row">
                <div class="col-md-6"></div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Expenses" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Issue" Value="2"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3" style="display: none">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none">
                    <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="bindCentre($(this).val().toString());"></asp:ListBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="lstCentre" runat="server"></asp:DropDownList>
                </div>
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
            <div class="row" style="text-align: center">
                <input type="button" value="Search" class="searchbutton" onclick="existingdata();" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expanses Detail
            </div>
            <div class="row">
                <table id="pettyexpense" style="width: 100%; border-collapse: collapse; text-align: center;">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Center code</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>

                        <td class="GridViewHeaderStyle" style="width: 60px;">Amount</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Date</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Created By</td>
                        <td class="GridViewHeaderStyle" style="width: 60px;">Type</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Invoice No.</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Bank</td>
                        <td class="GridViewHeaderStyle" style="width: 100px;">Card No.</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">ApprovedBy</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">ApprovedDate</td>
                        <td class="GridViewHeaderStyle" style="width: 60px;">Action</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <asp:Button ID="butpettyreject" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash2" runat="server" TargetControlID="butpettyreject" BehaviorID="modalpettycash2" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" CancelControlID="butrejectcancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" Style="display: none; width: 350px; height: 100px;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="row">
            <div class="col-md-6">
                <label class="pull-left">Remark</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-18">
                <asp:TextBox ID="txtcancelremark" runat="server" MaxLength="200"></asp:TextBox>
            </div>
        </div>
        <div class="row" style="text-align: center">
            <div class="col-md-24">
                <input id="butreject" type="button" value="Submit" onclick="Reject()" class="searchbutton" />
                <input id="butrejectcancel" type="button" class="searchbutton" value="Cancel" />
            </div>
        </div>

        <div class="row" style="display: none">
            <div class="col-md-3">

                <asp:Label ID="lblrejectid" runat="server"></asp:Label>
            </div>
        </div>
    </asp:Panel>
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
                    //$("#lstCentre option").eq(1).before($('<option>', {
                    //    value: '0',
                    //    text: 'ALL'
                    //}));
                    //jQuery("#lstCentre").chosen("destroy").chosen({ width: '100%' });
                });
            }
        }
        function existingdata() {
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
            serverCall('PettyCashRejectApproval.aspx/SearchRecords', { Centreid: result, fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val(), type: $('#<%=rblSearchType.ClientID %> input[type=radio]:checked').val() }, function (response) {
                $responseData = $.parseJSON(response);
                if ($responseData.length == 0) {
                    $('#pettyexpense tr').slice(1).remove();
                    toast("Info", "No Data Found", "");
                }
                else {
                    commontabledata($responseData);
                }
            });
        }

        function commontabledata($responseData) {
            var grossamt = 0;
            $('#pettyexpense tr').slice(1).remove();
            for (var i = 0; i <= $responseData.length - 1; i++) {
                grossamt = parseInt(grossamt) + Math.abs($responseData[i].amount);
                var $mydata = [];
                $mydata.push("<tr style='background-color:"); $mydata.push($responseData[i].rowColor); $mydata.push(";' id='"); $mydata.push($responseData[i].id); $mydata.push("'>");
                $mydata.push('<td >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].centrecode); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].centre); $mydata.push('</td>');

                $mydata.push('<td style="text-align:right">'); $mydata.push(Math.abs($responseData[i].amount)); $mydata.push('</td>');
                $mydata.push('<td>'); $mydata.push($responseData[i].DATE); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].createby); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].TYPE); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].paymentmode); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].InvoiceNo); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].Bank); $mydata.push('</td>');
                if ($responseData[i].CardNo == "0") {
                    $mydata.push('<td></td>');
                }
                else {
                    $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].CardNo); $mydata.push('</td>');
                }
                if ($responseData[i].ApprovedBy == null) {
                    $mydata.push('<td></td>');
                }
                else {
                    $mydata.push('<td style="text-align:left">'); $mydata.push($responseData[i].ApprovedBy); $mydata.push('</td>');
                }
                if ($responseData[i].ApprovedDate == null) {
                    $mydata.push('<td></td>');
                }
                else {
                    $mydata.push('<td>'); $mydata.push($responseData[i].ApprovedDate); $mydata.push('</td>');
                }

                if ($responseData[i].IsApproved == '1') {
                    $mydata.push('<td><input type="button" id="reject" class="resetbutton" value="Reject" onclick="CancelRemark('); $mydata.push($responseData[i].id); $mydata.push(')" /></td>');
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
            $mydata1.push('<td>'); $mydata1.push(grossamt); $mydata1.push('</td>');
            $mydata1.push("</tr>");
            $mydata1 = $mydata1.join("");
            $('#pettyexpense').append($mydata1);
        }
        function Reject() {
            if ($.trim($('#txtcancelremark').val()) == "") {
                toast("Error", "Please Enter Remark", "");
                $('#txtcancelremark').focus();
                return;
            }
            var cancelremark = $('#txtcancelremark').val();
            var id = $('#lblrejectid').text();
            if (id != "") {
                serverCall('PettyCashRejectApproval.aspx/rejectexpense', { ID: id, Cancelremark: cancelremark }, function (response) {
                    if (response.split('#')[0] == "1") {
                        existingdata();
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
            jQuery('#lstState option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            bindState();
            $('#lstCentre').html('');
            $('#txtentrydatefrom').val('');
            $('#txtentrydateto').val('');

        }
    </script>
</asp:Content>