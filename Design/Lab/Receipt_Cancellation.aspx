<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Receipt_Cancellation.aspx.cs" Inherits="Design_Lab_Receipt_Cancellation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="Receipt Cancellation" Font-Size="16px" Font-Bold="true"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left"><b>From Date</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtFormDate" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtFromTime" runat="server" Style="display: none"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                        ControlExtender="mee_txtFromTime"
                        ControlToValidate="txtFromTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>To Date</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtToTime" runat="server" Style="display: none"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Centre</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess chosen-select chosen-container" runat="server">
                    </asp:DropDownList>
                </div>
                <div class="col-md-8"></div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <select id="ddlSearchType">
                        <option value="lt.LedgertransactionNo">Visit No.</option>
                        <option value="plo.BarcodeNo">Barcode No.</option>
                        <option value="PM.PName">Patient Name</option>
                        <option value="pm.Mobile">Mobile</option>
                    </select>
                </div>
                <div class="col-md-3 ">
                    <asp:TextBox ID="txtLedgerTransactionNo" MaxLength="15" runat="server" class="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-14">
                    <input type="button" value="Search" class="searchbutton" onclick="$searchData()" />
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Receipt Detail  &nbsp;&nbsp;&nbsp; 
                   <span style="font-weight: bold; color: black;">Total Record Found:&nbsp;</span><span id="spnTestCount" style="font-weight: bold; color: black;"></span>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle">S.No.</td>
                            <td class="GridViewHeaderStyle">Entry DateTime</td>
                            <td class="GridViewHeaderStyle">Lab No.</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Age/Sex</td>
                            <td class="GridViewHeaderStyle">Gross Amount</td>
                            <td class="GridViewHeaderStyle">Disc. Amount</td>
                            <td class="GridViewHeaderStyle">Net Amount</td>
                            <td class="GridViewHeaderStyle">Paid Amount</td>
                            <td class="GridViewHeaderStyle">Receipt Type</td>
                            <td class="GridViewHeaderStyle">Payment Mode</td>
                            <td class="GridViewHeaderStyle">Cancel Receipt</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="divReceiptDetail" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 60%; max-width: 62%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Receipt Detail</h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeReceiptDetailModel()" aria-hidden="true">&times;</button> to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-5">
                                <label class="pull-left">Lab No.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">
                                <span id="spnModelLabNo" style="font-weight: bold;"></span>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-5">
                                <label class="pull-left">Patient Name  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">
                                <span id="spnModelPName" style="font-weight: bold;"></span>
                                <span id="spnModelID" style="font-weight: bold;display:none"></span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-5">
                                <label class="pull-left">Net Amt.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">
                                <span id="spnNetAmt" style="padding: 5px; font-weight: bold;"></span>
                               
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-5">
                                <label class="pull-left">Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">
                                 <input type="text" id="txtCancelReason" class="requiredField" maxlength="200" />
                               
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button"  id="btnReceiptCancel" onclick="$cancelReceipt()"  >Cancel</button>
                    <button type="button" onclick="$closeReceiptDetailModel()">Close</button>
                </div>
            </div>
        </div>
    </div> 
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#txtFormDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            }).attr('readonly', 'readonly');
            jQuery("#txtToDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            }).attr('readonly', 'readonly');

            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
        });
        function $getSearchData() {
            var $dataRec = new Array();
            $dataRec.push({
                SearchType: jQuery('#ddlSearchType').val(),
                LabNo: jQuery('#txtLedgerTransactionNo').val(),
                Centre: jQuery('#ddlCentreAccess').val(),
                FromDate: jQuery('#txtFormDate').val(),
                ToDate: jQuery('#txtToDate').val()               
            });
            return $dataRec;
        }
        var $testCount = 0;
        function $searchData() {
            var $searchData = $getSearchData();
            $testCount = 0;
            jQuery('#tb_ItemList tr').slice(1).remove();
            serverCall('Receipt_Cancellation.aspx/SearchReceiptData', { searchData: $searchData }, function (response) {
                $TestData = JSON.parse(response);
                if ($TestData.status) {
                    $TestData = $TestData.response;
                    if ($TestData.length != 0) {
                        for (var i = 0; i <= $TestData.length - 1; i++) {
                            $testCount = parseInt($testCount) + 1;
                            jQuery('#spnTestCount').html($testCount);
                            var $mydata = [];
                            $mydata.push("<tr id='");
                            $mydata.push($TestData[i].LedgerTransactionNo);
                            $mydata.push("'>");
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].DATE); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle"><b>'); $mydata.push($TestData[i].LedgerTransactionNo); $mydata.push('</b></td>');
                            $mydata.push('<td class="GridViewLabItemStyle"><b>'); $mydata.push($TestData[i].PName); $mydata.push('</b></td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].Pinfo); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].GrossAmt); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].DiscAmt); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].NetAmount); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle"  style="text-align:right">'); $mydata.push($TestData[i].PaidAmt); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].SlipType); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].PaymentMode); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center">');
                            $mydata.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;text-align:center" ');
                            $mydata.push('onclick="$cancelTest(\'');
                            $mydata.push($TestData[i].LedgerTransactionNo); $mydata.push("\',"); $mydata.push("\'");
                            $mydata.push($TestData[i].PName); $mydata.push("\',"); $mydata.push("\'");
                            $mydata.push($TestData[i].NetAmount); $mydata.push("\',"); $mydata.push("\'");
                            $mydata.push($TestData[i].ID); $mydata.push("\');"); $mydata.push('">');
                            $mydata.push('</td>');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join('');
                            jQuery('#tb_ItemList').append($mydata);
                        }
                    }
                    else {
                        jQuery('#spnTestCount').html('0');
                        toast("Info", "Record Not Found", "");
                    }
                }
                else {
                    jQuery('#spnTestCount').html('0');
                    toast("Error", $TestData.response, "");
                }               
                $modelUnBlockUI(function () { });
            });
        }
        function opencanreason(reason, date, user) {
            toast("Error","".concat( "Reason : " , reason , "<br/>" , "Cancel Date : " , date , "<br/>" , "User : " , user), "");
        }
        function $cancelTest(labno, pname, netamt, ID) {
            jQuery('#spnModelLabNo').html(labno);
            jQuery('#spnModelPName').html(pname);
            jQuery('#spnNetAmt').html(netamt);
            jQuery('#spnModelID').html(ID);
            jQuery('#txtCancelReason').val('');
            
            jQuery('#divReceiptDetail').showModel();
            jQuery('#txtCancelReason').focus();
        }
        function $closeReceiptDetailModel() {
            jQuery('#txtCancelReason').val('');
            jQuery('#divReceiptDetail').hideModel();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divReceiptDetail').is(':visible')) {
                    $closeReceiptDetailModel();
                }

            }
        }
        function getReciept() {
            var objrec = new Object();
            objrec.LabNo = jQuery('#spnModelLabNo').html();
            objrec.Cancelreason = jQuery('#txtCancelReason').val();
            objrec.ID = jQuery('#spnModelID').html();
            return objrec;
        }
        function $cancelReceipt() {
            if (jQuery.trim(jQuery('#txtCancelReason').val()) == "") {
                toast("Info", "Please Enter Cancel Reason", "");
                jQuery('#txtCancelReason').focus();
                return;
            }
            jQuery('#txtCancelReason').css("background-color", "white");
            var $Recdata = getReciept();
            confirmReceipt('Confirmation', 'Do you want to cancel Receipt', $Recdata);
        }
        function confirmReceipt(title, content, $Recdata) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: "".concat('<b>', content, '<b/>'),
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '420px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            serverCall('Receipt_Cancellation.aspx/CancelReceipt', { savedata: $Recdata }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    toast("Success", "Receipt Cancel Successfully", "");
                                    $searchData();
                                    jQuery('#divReceiptDetail').hideModel();
                                }
                                else {
                                    toast("Error", $responseData.ErrorMsg, "");
                                }
                                $modelUnBlockUI(function () { });
                            });
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearActions();
                        }
                    },
                }
            });

        }
        function $clearActions() {
        }
    </script>
    <style>
        #tb_ItemList tr:hover {
            color: red;
        }
    </style>
</asp:Content>

