<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="BulkSettelment.aspx.cs" Inherits="Design_OPD_BulkSettelment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>OPD Bulk Settlement<br />
                    </b>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="dtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="dtTo" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="dtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Client </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select requiredField" onchange="$bindAdvanceAmt()">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Only Balance Patient </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="checkbox" class="pull-left" id="ChkOnlyBalPatient" checked="checked" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtTotlAmt" Enabled="false" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                    <%--<cc1:FilteredTextBoxExtender ID="ftbAmt" runat="server" TargetControlID="txtTotlAmt" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>--%>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Balance Amt.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblBalAmt" runat="server" Font-Size="10pt" Style="font-weight: bold;"></asp:Label>
                    <asp:Label ID="lblBalAmtOrg" runat="server" Font-Size="10pt" Style="font-weight: bold; display: none"></asp:Label>
                    <input type="text" class="ItDoseTextinputNum" style="font-weight: Bold; display: none" value="0" id="txtBlanceAmount" autocomplete="off" disabled="disabled" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Due Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <span id="spnDueAmount" style="font-weight: bold;"></span>
                    <asp:Label runat="server" ID="lblDueAmt" Text="" Style="margin-left: 100px;"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divAdvanceAmt" style="display: none">
            <div class="Purchaseheader">Advance Payment Detail  </div>
            <div class="row">
                <div class="col-md-24">
                    <div style="max-height: 200px; overflow: auto;">
                        <div class="col-md-10">
                            <table id="tblAdvanceAmt" style="border-collapse: collapse; width: 100%;">
                                <thead>
                                    <tr id="trHeader">
                                        <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 80px; text-align: center">Balance Amt.</td>
                                        <td class="GridViewHeaderStyle" style="width: 200px; text-align: center">Created By</td>
                                        <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Created Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">Select</td>
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
        <div class="POuter_Box_Inventory divPaymentControl">
            <div class="Purchaseheader">Payment Detail&nbsp;&nbsp;&nbsp;  </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Currency</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select onchange="$onChangeCurrency(this,'1',function(){});" id="ddlCurrency">
                    </select>
                    <span id="spnBaseCurrency" style="display: none"></span>
                    <span id="spnBaseCountryID" style="display: none"></span>
                    <span id="spnBaseNotation" style="display: none"></span>
                    <span id="spnCFactor" style="display: none"></span><span id="spnConversion_ID" style="display: none"></span><span id="spnControlpatientAdvanceAmount" style="display: none">0</span>
                </div>
                <div id="spnBlanceAmount" style="color: red; font-weight: bold; display: none; text-align: left;" class="col-md-3">
                </div>
                <div class="col-md-3" style="display: none">
                    <label class="pull-left" style="display: none">Factor</label>
                    <b class="pull-right">:</b>
                </div>
                <div id="spnConvertionRate" style="color: red; font-weight: bold; text-align: left;" class="col-md-3">
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Currency Round</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" class="ItDoseTextinputNum" style="font-weight: Bold" value="0" id="txtCurrencyRound" autocomplete="off" disabled="disabled" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Payment Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlPaymentMode" onchange="$onPaymentModeChange(this,jQuery('#ddlCurrency'),function(){});"></select>
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">TDS</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtTDS" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Write Off</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtWriteOff" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                </div>
                <div class="col-md-3 clPaidAmt">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                </div>
                <div id="divPaymentDetails" class="col-md-18 isReciptsBool" style="overflow-y: auto; overflow-x: hidden;">
                    <table class="GridViewStyle cltblPaymentDetail" border="1" id="tblPaymentDetail" rules="all" style="border-collapse: collapse;">
                        <thead>
                            <tr id="trPayment">
                                <th class="GridViewHeaderStyle" scope="col">Payment Mode</th>
                                <th class="GridViewHeaderStyle" scope="col">Paid Amt.</th>
                                <th class="GridViewHeaderStyle" scope="col">Currency</th>
                                <th class="GridViewHeaderStyle" scope="col">Base</th>
                                <th class="GridViewHeaderStyle clHeaderChequeNo" scope="col" style="display: none;">Cheque/Card No.</th>
                                <th class="GridViewHeaderStyle clHeaderChequeDate" scope="col" style="display: none;">Cheque/Card Date</th>
                                <th class="GridViewHeaderStyle clHeaderBankName" scope="col" style="display: none;">Bank Name</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="col-md-3">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Remarks   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10 ">
                    <asp:TextBox ID="txtRemarks" runat="server" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="getDetail()" />
                    <input id="btnCancel" type="button" value="Cancel" onclick="clearform();" class="resetbutton" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div id="divSettlementOutput" style="max-height: 350px; overflow: auto;">

                        <div class="col-md-24">
                            <table id="tblSettlement" style="border-collapse: collapse; width: 100%;">
                                <thead>
                                    <tr id="Header">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Bill Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 150px;">MR No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 150px;">Visit No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 70px;">Net Amt.</td>
                                        <td class="GridViewHeaderStyle" style="width: 70px;">Paid Amt.</td>
                                        <td class="GridViewHeaderStyle" style="width: 70px;">Balance Amt.</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">Amt.</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">TDS</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">WriteOff</td>
                                        <td class="GridViewHeaderStyle" style="width: 10px;">
                                            <input id="chkAllRows" type="checkbox" onclick="CheckAll(this);" /></td>
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



        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <input id="btnSave" type="button" value="Save" class="savebutton" style="display: none; text-align: center" />
                </div>
            </div>
        </div>
        <div id="tb_PatientLabSearch">
            <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                style="border-collapse: collapse; width: 100%;">
            </table>
        </div>
    </div>

    <script type="text/javascript" language="javascript">
        jQuery(function () {
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
            jQuery('#ddlPanel').trigger('chosen:updated');
        });
        $(function () {
            $("#btnSave").click(SaveData);
        });
    </script>
    <script type="text/javascript">
        function getReceiptdata() {
            var ReceiptArr = new Array();
            $("#tblSettlement").find('tr').find('input[type=checkbox]').each(function () {
                if ($(this).attr('id') != "chkAllRows") {
                    if ($(this).is(':checked')) {
                        var objrec = new Object();
                        objrec.LedgerTransactionID = $(this).closest("tr").find("#hdnLedgerTransactionId").val();
                        objrec.LedgerTransactionNo = $(this).closest("tr").find("#hdnLedgerTransactionNo").val();
                        objrec.Patient_ID = $(this).closest("tr").find("#hdnPatientId").val();
                        objrec.Panel_ID = $(this).closest("tr").find('#hdnPanelId').val()
                        objrec.Amount = $(this).closest("tr").find('#txtAmt').val();
                        objrec.TDSAmount = $(this).closest("tr").find('#txtTDSAmt').val();
                        objrec.WriteOffAmount = $(this).closest("tr").find('#txtWriteOffAmt').val();
                        objrec.CentreID = $(this).closest("tr").find('#hdnCentreId').val();
                        objrec.S_Amount = $(this).closest('tr').find('#hdnSAmount').val();

                        if (jQuery("#tblAdvanceAmt").find('tbody tr').find("input[type=checkbox]:checked").length == 0) {


                            $("#tblPaymentDetail").find('tbody tr').each(function (index, value) {

                                if (index == 0 && $(this).closest('tr').find('#txtPatientPaidAmount').val() > 0) {
                                    objrec.PaymentMode = $(this).closest('tr').find('#tdPaymentMode').text();
                                    objrec.PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text();
                                    objrec.BankName = String.isNullOrEmpty($(this).closest('tr').find('#tdBankName select').val()) ? '' : $(this).closest('tr').find('#tdBankName select').val();
                                    objrec.S_CountryID = $(this).closest('tr').find('#tdS_CountryID').text();
                                    objrec.S_Currency = $(this).closest('tr').find('#tdS_Currency').text();
                                    objrec.S_Notation = $(this).closest('tr').find('#tdS_Notation').text();
                                    objrec.C_Factor = $(this).closest('tr').find('#tdC_Factor').text();
                                    objrec.Currency_RoundOff = $('#txtCurrencyRound').val();
                                    objrec.CurrencyRoundDigit = $(this).closest('tr').find('#tdCurrencyRound').text();
                                    objrec.Naration = $.trim($('#txtRemarks').val());
                                    objrec.Converson_ID = $(this).closest('tr').find('#tdConverson_ID').text();
                                    objrec.CardNo = String.isNullOrEmpty($(this).closest('tr').find('#txtCardNo').val()) ? '' : $(this).closest('tr').find('#txtCardNo').val();
                                    objrec.CardDate = String.isNullOrEmpty($(this).closest('tr').find('#txtCardDate').val()) ? '' : $(this).closest('tr').find('#txtCardDate').val();
                                }
                            });
                        }
                        ReceiptArr.push(objrec);
                    }
                }
            });
            return ReceiptArr;
        }
        function getLtData() {
            var LtDataArr = new Array();
            $("#tblSettlement").find('tr').find('input[type=checkbox]').each(function () {
                if ($(this).attr('id') != "chkAllRows") {
                    if ($(this).is(':checked')) {
                        var objlt = new Object();
                        objlt.PaidAmount = $(this).closest("tr").find("#hdnPaidAmount").val();
                        objlt.Amount = parseFloat($(this).closest("tr").find('#txtAmt').val()) + parseFloat($(this).closest("tr").find('#txtTDSAmt').val()) + parseFloat($(this).closest("tr").find('#txtWriteOffAmt').val());
                        objlt.LabID = $(this).closest("tr").find("#hdnLedgerTransactionId").val();
                        objlt.PanelID = $(this).closest("tr").find("#hdnPanelId").val();
                        LtDataArr.push(objlt);
                    }
                }
            });
            return LtDataArr;
        }

        function SaveData() {
            var TDSChk = 0; var UnPaidAmount = 0;
            var TDSAmt = $.trim($("#txtTDS").val());
            if (isNaN(TDSAmt) || TDSAmt == "")
                TDSAmt = 0;
            var WriteOffAmt = $.trim($("#txtWriteOff").val());
            if (isNaN(WriteOffAmt) || WriteOffAmt == "")
                WriteOffAmt = 0;
            if (TDSAmt > 0 || WriteOffAmt > 0) {
                $("#tblSettlement").find('tr:not(#Header)').each(function () {
                    if (jQuery(this).closest('tr').find('#chkDistributeAmt').is(':checked')) {
                        UnPaidAmount = UnPaidAmount + parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text());
                    }
                });

                if (parseFloat(parseFloat(TDSAmt) + parseFloat(WriteOffAmt)) > parseFloat(UnPaidAmount)) {                 
                    toast("Error", "TDS Plus WriteOff Amount not greater then balance Amount", "");
                    return;
                }
            }
            var AdvanceAmtID = 0;
            jQuery("#tblAdvanceAmt").find('tbody tr').each(function () {
                if (jQuery(this).closest('tr').find('#chkAdvanceAmt').is(':checked')) {
                    AdvanceAmtID = jQuery(this).closest('tr').find('#tdAdvanceID').text();
                }


            });


            var ReceiptArr = getReceiptdata();
            var LtDataArr = getLtData();
            if (ReceiptArr.length == 0) {
                toast("Error", "Please Select Data", "");
                return;
            }
            serverCall('BulkSettelment.aspx/SaveBulkPayment', { ReceiptData: ReceiptArr, LtData: LtDataArr, totalPaidAmt: $("#txtTotlAmt").val(), AdvanceAmtID: AdvanceAmtID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Record Saved Successfully", "");
                    window.location.reload();
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
            });
        }

    </script>
    <script type="text/javascript">
        function getSearchData() {
            var Objdata = new Object();
            Objdata.PanelID = $("#ddlPanel").val();
            Objdata.dtFrom = $("#dtFrom").val();
            Objdata.dtTo = $("#dtTo").val();
            Objdata.OnlyBalPatient = $("#ChkOnlyBalPatient").prop("checked") == true ? 1 : 0;
            return Objdata;
        }
        function vaidation() {
            if ($("#ddlPanel").val() == "") {
                toast("Error", "Please Select Client", "");
                $("#ddlPanel").focus();
                return false;
            }
            if ($("#txtTotlAmt").val() == "" || $("#txtTotlAmt").val() == "0") {
                toast("Error", "Please Enter Amount", "");
                $("#txtTotlAmt").focus();
                return false;
            }
            var $cardNoValidate = 0; var $cardDateValidate = 0; var $bankValidate = 0;
            jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                if (jQuery(this).closest('tr').find("#tdPaymentMode").text() != 1) {
                    if (jQuery(this).closest('tr').find("#txtCardNo").val() == "") {
                        $cardNoValidate = 1;
                        jQuery(this).closest('tr').find("#txtCardNo").focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find('#txtCardDate').val() == "") {
                        $cardDateValidate = 1;
                        jQuery(this).closest('tr').find('#txtCardDate').focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find(".bnk").val() == 0) {
                        $bankValidate = 1;
                        jQuery(this).closest('tr').find(".bnk").focus();
                        return false;
                    }
                }
            });
            if ($cardNoValidate == 1) {
                toast("Error", "Please Enter Card Detail", "");
                return false;
            }
            if ($cardDateValidate == 1) {
                toast("Error", "Please Enter Card Date Detail", "");
                return false;
            }
            if ($bankValidate == 1) {
                toast("Error", "Please Select Bank Name", "");
                return false;
            }
            return true
        }
        var BalanceAmount = 0;
        function getDetail() {
            
            if (vaidation() == false)
                return;
            var data = getSearchData();
            var countryID = $("#ddlCurrency").val();
            
            $('#tblSettlement tr').slice(1).remove();
            

            serverCall('BulkSettelment.aspx/SearchForBulkPayment', { searchdata: data }, function (response) {

                var SearchData = JSON.parse(response);
                if (SearchData.length > 0) {
                    jQuery("#tblAdvanceAmt").find('tbody tr').each(function () {
                        jQuery(this).closest('tr').find('#chkAdvanceAmt').attr('disabled', 'disabled');
                    });
                    var TotalBilledAmount = 0;
                    var TotalPaidAmountAmount = 0;
                    for (var j = 0; j < SearchData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('<input type="hidden" id="hdnPanelId" value="');
                        output.push(SearchData[j].Panel_ID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnCentreId" value="');
                        output.push(SearchData[j].CentreID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnLedgerTransactionId" value="');
                        output.push(SearchData[j].LedgerTransactionId);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnBillDate" value="');
                        output.push(SearchData[j].BillDate);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnLedgerTransactionNo" value="');
                        output.push(SearchData[j].Transaction_ID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnPatientId" value="');
                        output.push(SearchData[j].PatientID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnPaidAmount" value="');
                        output.push(SearchData[j].PaidAmt);
                        output.push('"/>');

                        output.push('<input type="hidden" id="hdnCountryID" value="');
                        output.push(countryID);
                        output.push('"/>');

                        output.push('<input type="hidden" id="hdnSAmount" value="');
                        output.push(0);
                        output.push('"/>');

                        output.push('</td>');
                        output.push('<td id="CenterID"  class="GridViewLabItemStyle"  style="width:100px;">');
                        output.push(SearchData[j].BillDate); output.push('</td>');
                        output.push('<td   class="GridViewLabItemStyle"  style="width:150px;">');
                        output.push(SearchData[j].PatientID); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle" Style="width:150px">');
                        output.push(SearchData[j].Transaction_ID); output.push('</td>');
                        output.push('<td id="NetAmount"  class="GridViewLabItemStyle" Style="width:50px;text-align:right;" >'); output.push(SearchData[j].NetAmount); output.push('</td>');
                        output.push('<td id="PaidAmount"  class="GridViewLabItemStyle" Style="width:50px;text-align:right;">'); output.push(SearchData[j].PaidAmt); output.push('</td>');
                        output.push('<td id="tdBalanceAmount"  class="GridViewLabItemStyle" Style="text-align:right">'); output.push(parseFloat(SearchData[j].NetAmount - SearchData[j].PaidAmt)); output.push('</td>');

                        output.push('<td id="tdUnPaidAmount"  class="GridViewLabItemStyle" Style="text-align:right;display:none">'); output.push(parseFloat(SearchData[j].NetAmount - SearchData[j].PaidAmt)); output.push('</td>');
                        output.push('<td id="Amount" class="GridViewLabItemStyle"  Style="width:70px; text-align:center" ><input id="txtAmt" type="text" value="0"  Class="Readonly ItDoseTextinputNum"  disabled="disabled"  /> </td>');
                        output.push('<td id="tdTDSAmount" class="GridViewLabItemStyle"  Style="width:70px; text-align:center" ><input id="txtTDSAmt" type="text" value="0"  Class="Readonly ItDoseTextinputNum"  disabled="disabled"  /> </td>');
                        output.push('<td id="tdWriteOffAmount" class="GridViewLabItemStyle"  Style="width:70px; text-align:center" ><input id="txtWriteOffAmt" type="text" value="0"  Class="Readonly ItDoseTextinputNum"  disabled="disabled"  /> </td>');
                        output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:10px;"><input id="chkDistributeAmt" type="checkbox" onclick="GetAmt(this);" /></td>');
                        output.push('</tr>');
                        output = output.join('');

                        $('#tblSettlement').append(output);
                        TotalBilledAmount = TotalBilledAmount + parseInt(SearchData[j].NetAmount);
                        TotalPaidAmountAmount = TotalPaidAmountAmount + parseInt(SearchData[j].PaidAmt);
                    }
                    $('#spnDueAmount').text(TotalBilledAmount - parseFloat(TotalPaidAmountAmount));

                    $('#btnSave').show();
                    BalanceAmount = parseFloat($('#txtTotlAmt').val());
                    $("#lblBalAmt").text(BalanceAmount);
                    $('.divPaymentControl :input:not(#txtCurrencyRound)').attr("disabled", true);

                }
                else {
                    toast("Info", "Record Not Found", "");
                    $('#btnSave').hide();
                }

            });
        };
    </script>
    <script type="text/javascript">
        jQuery(function () {
            $getCurrencyDetails(function (baseCountryID) {
                $getConversionFactor(baseCountryID, function (CurrencyData) {
                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));
                    $bindPaymentMode();
                });
            });

        });
        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            var _temp = [];
            if (calculateConversionFactor == 1) {
                var blanceAmount = $("#txtTotlAmt").val();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                _temp = [];
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                    $.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        $('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', $('#ddlCurrency option:selected').text()));
                        $bindPaymentControl();
                        callback(true);
                    })
                }));
            }
            else {
                _temp = [];
                var blanceAmount = $("#txtTotlAmt").val();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                    $.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        $('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', $('#ddlCurrency option:selected').text()));
                        callback(true);
                    })
                }));
            }
        }
        var $getConversionFactor = function ($countryID, callback) {
            serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $countryID, Amount: 0 }, function (response) {
                callback(JSON.parse(response));
            });
        }
        var $getCurrencyDetails = function (callback) {
            var $ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/Services/CommonServices.asmx/LoadCurrencyDetail', {}, function (response) {
                var $responseData = JSON.parse(response);
                jQuery('#spnBaseCurrency').text($responseData.baseCurrency);
                jQuery('#spnBaseCountryID').text($responseData.baseCountryID);
                jQuery('#spnBaseNotation').text($responseData.baseNotation);
                jQuery($ddlCurrency).bindDropDown({
                    data: $responseData.currancyDetails, valueField: 'CountryID', textField: 'Currency', selectedValue: '<%= Resources.Resource.BaseCurrencyID%>', showDataValue: 1
                });
                callback($ddlCurrency.val());
            });
        }
    </script>
    <script type="text/javascript" language="javascript">

        function clearform() {
            jQuery(':text:not(#dtFrom,#dtTo)').val('');
            jQuery(":checkbox").attr('checked', '');
            jQuery("#ChkOnlyBalPatient").prop("checked", "checked");

            jQuery('#tblSettlement tr').slice(1).remove();
            jQuery("#txtTotlAmt").val('');
            jQuery('#btnSave').hide();
            jQuery("#lblBalAmt,#spnDueAmount").text('');
            jQuery("#txtBlanceAmount").val('0');
            jQuery('.divPaymentControl :input:not(#txtCurrencyRound)').attr("disabled", false);
            jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            jQuery('#spnUHIDNo,#spnReturn,#spnBlanceAmount').html('');
            $getCurrencyDetails(function (baseCountryID) {
                $getConversionFactor(baseCountryID, function (CurrencyData) {
                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));
                    $bindPaymentMode();
                });
            });

            jQuery("#tblAdvanceAmt").find('tbody tr').each(function () {
                jQuery(this).closest('tr').find('#chkAdvanceAmt').prop('checked', false).removeAttr('disabled');
                jQuery(this).closest('tr').css('background-color', '');

            });
        }
    </script>
    <script type="text/javascript">
        var $onPaidAmountChanged = function (e) {
            var row = $(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
            var $paidAmount = Number(e.target.value);


            jQuery("#txtTotlAmt").val($paidAmount);
            $convertToBaseCurrency($countryID, $paidAmount, function (baseCurrencyAmount) {
                $(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount);
                $calculateTotalPaymentAmount(e, function () {
                });
            });
        }
        var $convertToBaseCurrency = function ($countryID, $amount, callback) {
            var baseCurrencyCountryID = Number($('#spnBaseCountryID').text());
            $amount = Number($amount);
            $amount = isNaN($amount) ? 0 : $amount;
            if (baseCurrencyCountryID == $countryID || $amount == 0) {
                callback($amount);
                return false;
            }
            try {
                serverCall('../Common/Services/CommonServices.asmx/ConvertCurrency', { countryID: $countryID, Amount: $amount }, function (response) {
                    callback(Number(response));
                });
            } catch (e) {
                callback(0);
            }
        }
        var $calculateTotalPaymentAmount = function (event, row, callback) {
            var $totalPaidAmount = 0;
            $('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
            // var $netAmount = parseFloat($('#txtAmount').val());
            var $roundOffTotalPaidAmount = Math.round($totalPaidAmount);
            $('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));

            var $blanceAmount = $("#txtTotlAmt").val();
            if (isNaN($blanceAmount) || $blanceAmount == "")
                $blanceAmount = 0;
            var $currencyRound = 0;
            $blanceAmount = parseFloat($blanceAmount) + precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');
            $currencyRound = precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');

            var $currencyRoundValue = parseFloat(jQuery('#txtPaidAmount').val()) + parseFloat($currencyRound);

            if ($blanceAmount < 1)
                jQuery('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
            else
                jQuery('#txtCurrencyRound').val('0');


            jQuery("#txtTotlAmt").val($totalPaidAmount);
            $onChangeCurrency($("#ddlCurrency"), 0, function (response) {
            });
        };
        var $paymentModeCache = [];
        $bindPaymentMode = function () {
            jQuery("#ddlPaymentMode option").remove();
            serverCall('../Common/Services/CommonServices.asmx/bindPaymentMode', {}, function (response) {
                $paymentModeCache = JSON.parse(response);
                var $ddlApprovedBy = jQuery('#ddlPaymentMode');
                $ddlApprovedBy.bindDropDown({ data: JSON.parse(response), valueField: 'PaymentModeID', textField: 'PaymentMode', showDataValue: '1' });
                jQuery("#ddlPaymentMode option[value=9]").remove();
                $bindPaymentControl();
            });
        }
        $bindPaymentControl = function () {
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            jQuery('#ddlPaymentMode').prop('selectedIndex', 0);
            $validatePaymentModes(1, 'Cash', Number($('#txtAmount').val()), jQuery('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails(jQuery('#ddlPaymentMode option:selected'), response, function (data) {
                    });
                });
            });
        };

        var $validatePaymentModes = function ($PaymentModeID, $PaymentMode, $billAmount, $ddlCurrency, callback) {
            var $totalPaidAmount = 0;
            $('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number($(this).text()); });
            var data = {
                currentSelectedPaymentMode: $('#ddlPaymentMode').val(),
                totalSelectedPaymentModes: $('#ddlPaymentMode').val(),
                billAmount: $billAmount,
                totalPaidAmount: $totalPaidAmount,
                defaultPaidAmount: 0,
                patientAdvanceAmount: 0,
                roundOffAmount: Number($('#txtControlRoundOff').val()),
                currentCurrencyName: $.trim($($ddlCurrency).find('option:selected').text()),
                currentCurrencyNotation: $.trim($($ddlCurrency).find('option:selected').text()),
                baseCurrencyName: $.trim($('#spnBaseCurrency').text()),
                baseCurrencyNotation: $.trim($('#spnBaseNotation').text()),
                currencyFactor: Number($('#spnCFactor').text()),
                paymentMode: $.trim($PaymentMode),
                PaymentModeID: Number($PaymentModeID),
                currencyID: Number($ddlCurrency.val()),
                currencyRound: $($ddlCurrency).find('option:selected').data("value").Round,
                Converson_ID: Number($('#spnConversion_ID').text()),
                isInBaseCurrency: false
            }
            if (data.baseCurrencyNotation.toLowerCase() == data.currentCurrencyNotation.toLowerCase())
                data.isInBaseCurrency = true;
            callback(data);
        }
        var $bindPaymentDetails = function (data, callback) {
            $payment = {};
            $payment.billAmount = data.billAmount;
            $payment.$paymentDetails = [];
            $payment.$paymentDetails = {
                Amount: data.defaultPaidAmount,
                BaceCurrency: data.baseCurrencyName,
                BankName: '',
                C_Factor: data.currencyFactor,
                PaymentMode: data.paymentMode,
                PaymentModeID: data.PaymentModeID,
                PaymentRemarks: '',
                RefNo: '',
                S_Amount: 0,
                baseCurrencyAmount: data.defaultPaidAmount,
                S_CountryID: data.currencyID,
                S_Currency: data.currentCurrencyName,
                S_Notation: data.currentCurrencyName,
                currencyRound: data.currencyRound,
                Converson_ID: data.Converson_ID,
            };
            callback($payment);
        }
        var $bindPaymentModeDetails = function (IsShowDetail, data, callback) {
            var $patientAdvancePaymentModeID = [9];
            var $disableBankDetailPaymentModeID = [1, 4, 9];
            if ($patientAdvancePaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                maxInputValue = data.patientAdvanceAmount;
            var $temp = []; var maxInputValue = 100000000;
            $temp.push('<tr class="');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1) {
                $temp.push($.trim(data.$paymentDetails.S_CountryID));
            }
            else {
                $temp.push('clShowDetail ');
                $temp.push($.trim(data.$paymentDetails.S_CountryID));
            }
            $temp.push('"');
            $temp.push(' id="'); $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('">');
            $temp.push('<td id="tdPaymentMode" class="GridViewLabItemStyle ');
            $temp.push($.trim(data.$paymentDetails.PaymentMode.split('(')[0]));
            $temp.push('"');
            $temp.push('style="width:100px">');
            $temp.push($.trim(data.$paymentDetails.PaymentMode.split('(')[0])); $temp.push('</td>');
            $temp.push('<td id="tdAmount" class="GridViewLabItemStyle" style="width:100px">');
            $temp.push('<input type="text" onlynumber="10" decimalplace="');
            $temp.push(data.$paymentDetails.currencyRound); $temp.push('"');
            $temp.push('max-value="');
            $temp.push(maxInputValue); $temp.push('"');
            $temp.push(' value="'); $temp.push(data.$paymentDetails.Amount); $temp.push('"');
            $temp.push(' autocomplete="off" id="txtPatientPaidAmount" class="ItDoseTextinputNum requiredField" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onPaidAmountChanged(event);" /></td>');
            $temp.push('<td id="tdS_Currency" class="GridViewLabItemStyle">');
            $temp.push(data.$paymentDetails.S_Currency); $temp.push('</td>');
            $temp.push('<td id="tdBaseCurrencyAmount" class="GridViewLabItemStyle"  style="text-align:right">');
            $temp.push(data.$paymentDetails.baseCurrencyAmount); $temp.push('</td>');


            if (IsShowDetail.data('value').IsChequeNoShow == 1)
                jQuery('.clHeaderChequeNo').show();
            $temp.push('<td id="tdCardNo" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('value').IsChequeNoShow == 0 ? '"style="display:none">' : ' clChequeNo">');
            $temp.push(IsShowDetail.data('value').IsChequeNoShow == 0 ? '' : '<input type="text" autocomplete="off" class="requiredField" id="txtCardNo" />');
            $temp.push('</td>');

            if (IsShowDetail.data('value').IsChequeDateShow == 1)
                jQuery('.clHeaderChequeDate').show();
            $temp.push('<td id="tdCardDate" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('value').IsChequeDateShow == 0 ? '"style="display:none">' : ' clChequeDate">');
            $temp.push(IsShowDetail.data('value').IsChequeDateShow == 0 ? '' : '<input type="text" autocomplete="off" readonly  class="setCardDate requiredField" id="txtCardDate');
            $temp.push('"/>');
            $temp.push('</td>');

            if (IsShowDetail.data('value').IsBankShow == 1)
                jQuery('.clHeaderBankName').show();
            $temp.push('<td id="tdBankName" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('value').IsBankShow == 0 ? '"style="display:none">' : ' clBankName">');
            $temp.push(IsShowDetail.data('value').IsBankShow == 0 ? '' : '<select class="bnk requiredField" style="padding: 0px;"></select>');
            $temp.push('</td>');


            $temp.push('<td id="tdPaymentModeID" style="display:none">'); $temp.push(data.$paymentDetails.PaymentModeID); $temp.push('</td>');
            $temp.push('<td id="tdBaceCurrency" style="display:none">'); $temp.push(data.$paymentDetails.BaceCurrency); $temp.push('</td>');
            $temp.push('<td id="tdS_CountryID" style="display:none">'); $temp.push(data.$paymentDetails.S_CountryID); $temp.push('</td>');
            $temp.push('<td id="tdS_Notation" style="display:none">'); $temp.push(data.$paymentDetails.S_Notation); $temp.push('</td>');
            $temp.push('<td id="tdS_Amount" style="display:none">'); $temp.push(data.$paymentDetails.S_Amount); $temp.push('</td>');
            $temp.push('<td id="tdC_Factor" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.C_Factor); $temp.push('</td>');
            $temp.push('<td id="tdCurrencyRound" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.currencyRound); $temp.push('</td>');
            $temp.push('<td id="tdConverson_ID" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.Converson_ID); $temp.push('</td>');

            $temp.push('</tr>');
            $temp = $temp.join("");
            jQuery('#tblPaymentDetail tbody').append($temp);
            jQuery('#tblPaymentDetail tbody tr').find('#txtCardDate').datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0",
                onSelect: function (dateText) {
                    jQuery('#tblPaymentDetail tbody tr').find('#txtCardDate').val(dateText);
                }
            });
            if (jQuery(".clChequeNo").length == 0)
                jQuery('.clHeaderChequeNo').hide();
            else
                jQuery('.clHeaderChequeNo').show();
            if (jQuery(".clChequeDate").length == 0)
                jQuery('.clHeaderChequeDate').hide();
            else
                jQuery('.clHeaderChequeDate').show();

            if (jQuery(".clBankName").length == 0)
                jQuery('.clHeaderBankName').hide();
            else
                jQuery('.clHeaderBankName').show();
            var bankControl = $('#divPaymentDetails table tbody tr:last-child').find('.bnk');
            callback({ bankControl: bankControl, IsOnlineBankShow: IsShowDetail.data('value').IsOnlineBankShow });
        }
        $onPaymentModeChange = function (elem, ddlCurrency, callback) {
            $('.cltblPaymentDetail tr').slice(1).remove();
            $validatePaymentModes($("#ddlPaymentMode").val(), $("#ddlPaymentMode option:selected").text(), Number($('#txtAmount').val()), $('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails($('#ddlPaymentMode option:selected'), response, function (data) {
                        $bindBankMaster(data.bankControl, data.IsOnlineBankShow, function () {
                            $calculateTotalPaymentAmount(function () { });
                        });
                    });
                });
            });
        }
        var $bindBankMaster = function (bankControls, IsOnlineBankShow, callback) {
            $getBankMaster(function (response) {
                response = jQuery.grep(response, function (value) {
                    return value.IsOnlineBank == IsOnlineBankShow;
                });
                $(bankControls).bindDropDown({ data: response, valueField: 'BankName', textField: 'BankName', defaultValue: '', selectedValue: '' });
                callback(true);
            });
        }
        var $bankMaster = [];
        var $getBankMaster = function (callback) {
            if ($bankMaster.length < 1) {
                serverCall('../Common/Services/CommonServices.asmx/getBankMaster', {}, function (response) {
                    $bankMaster = JSON.parse(response);
                    callback($bankMaster);
                });
            }
            else
                callback($bankMaster);
        }
    </script>
    <script type="text/javascript">
        var totalPendingAmt = 0;
        function GetAmt(ctrl) {
            BalanceAmount = parseFloat($('#txtTotlAmt').val());
           // BalanceAmount = parseFloat($('#lblBalAmt').text());
            totalPendingAmt = 0;
            if (jQuery(ctrl).is(':checked')) {
		      // jQuery('#tblSettlement #txtAmt').each(function () { 
                        jQuery(ctrl).val('0'); 
                     //  });
              //  BalanceAmount = parseFloat($('#txtTotlAmt').val());
                $("#tblSettlement").find('tr:not(#Header)').each(function () {
				        
                    var $totalAmount = 0;
                    jQuery('#tblSettlement #txtAmt').each(function () { $totalAmount += parseFloat(jQuery(this).val()); });
                    if ($totalAmount == BalanceAmount && $totalAmount > parseFloat($('#txtTotlAmt').val())) {
                        toast("Error", "Total Amount for Settlement is Exhausted", "");
                        jQuery(ctrl).prop('checked', false);
                        jQuery(ctrl).find('#hdnSAmount').val(0);
                        totalPendingAmt = 1;
                        BalanceAmount = 0;
                        return;
                    }
                    if (totalPendingAmt == 0) {
                        totalPendingAmt = 0;



                        if (jQuery(this).closest('tr').find('#chkDistributeAmt').is(':checked')) {
                            var NetAmount = parseFloat(jQuery(this).closest('tr').find('#NetAmount').text());
                            var PaidAmt = parseFloat(jQuery(this).closest('tr').find('#PaidAmount').text());

                            var $totalUnPaidAmount = 0;
                            jQuery('#tblSettlement').find('tr:not(#Header)').find('input[type=checkbox]:checked').each(function () {
                                $totalUnPaidAmount += parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text());
                            });


                            if (BalanceAmount != 0) {
                                var AmountToDistribute = 0;
                                var ChkChecked = ' ';
                                if (NetAmount > PaidAmt) {
                                    if (BalanceAmount >= (NetAmount - PaidAmt)) {

                                        var distributedTDS = 0;
                                        var distributedWriteOff = 0;
                                        if (parseFloat(jQuery('#txtTDS').val()) > 0) {

                                            var TDSPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);

                                            jQuery(this).closest('tr').find('#txtTDSAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtTDS').val()) * parseFloat(TDSPer) / 100), 5));
                                            distributedTDS = parseFloat(jQuery(this).closest('tr').find('#txtTDSAmt').val());

                                        }
                                        if (parseFloat(jQuery('#txtWriteOff').val()) > 0) {
                                            var WriteOffPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                            jQuery(this).closest('tr').find('#txtWriteOffAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtWriteOff').val()) * parseFloat(WriteOffPer) / 100), 5));
                                            distributedWriteOff = precise_round(parseFloat(jQuery(this).closest('tr').find('#txtWriteOffAmt').val()), 5);

                                        }

                                        AmountToDistribute = precise_round((NetAmount - PaidAmt - distributedTDS - distributedWriteOff), 5);
                                        jQuery(this).closest('tr').find('#txtAmt').val(AmountToDistribute);

                                        var $totalPaidAmount = 0;
                                        jQuery('#tblSettlement #txtAmt').each(function () { $totalPaidAmount += parseFloat(jQuery(this).val()); });
                                        BalanceAmount = parseFloat($('#txtTotlAmt').val()) - parseFloat($totalPaidAmount);
									   // alert($totalPaidAmount);


                                    }
                                    else if (BalanceAmount > 0) {
                                        var distributedTDS = 0;
                                        var distributedWriteOff = 0;
                                        if (parseFloat(jQuery('#txtTDS').val()) > 0) {

                                            var TDSPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                            jQuery(this).closest('tr').find('#txtTDSAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtTDS').val()) * parseFloat(TDSPer) / 100), 5));
                                            distributedTDS = parseFloat(jQuery(this).closest('tr').find('#txtTDSAmt').val());
                                        }
                                        if (parseFloat(jQuery('#txtWriteOff').val()) > 0) {

                                            var WriteOffPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                            jQuery(this).closest('tr').find('#txtWriteOffAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtWriteOff').val()) * parseFloat(WriteOffPer) / 100), 5));
                                            distributedWriteOff = parseFloat(jQuery(this).closest('tr').find('#txtWriteOffAmt').val());
                                        }

                                        jQuery(this).closest('tr').find('#txtTDSAmt').val(distributedTDS);

                                        jQuery(this).closest('tr').find('#txtWriteOffAmt').val(distributedWriteOff);

                                        jQuery(this).closest('tr').find('#txtAmt').val(BalanceAmount);
                                        BalanceAmount = 0;
                                    }


                                    serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: jQuery(this).closest('tr').find('#hdnCountryID').val(), Amount: jQuery(this).closest('tr').find('#txtAmt').val() }, function (response) {
                                        var $convertedCurrencyData = JSON.parse(response);
                                        jQuery(ctrl).closest('tr').find('#hdnSAmount').val(precise_round($convertedCurrencyData.BaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                                    });

                                }
                                else {

                                    toast("Error", "Already full Paid", "");
                                    jQuery(this).closest('tr').find('#chkDistributeAmt').prop('checked', false);
                                  //  jQuery(ctrl).closest('tr').find('#chkDistributeAmt').prop('checked', false);                            
                                    jQuery(this).closest('tr').find('#hdnSAmount').val(0)
                                }
                            }
                            else {

                                toast("Error", "Total Amount for settlement is exhausted", "");
                                jQuery(ctrl).closest('tr').find('#chkDistributeAmt').prop('checked', false);
                                jQuery(this).closest('tr').find('#hdnSAmount').val(0)
                            }

                        }
                        else {
                            // BalanceAmount = BalanceAmount + parseFloat(jQuery(this).closest('tr').find('#txtAmt').val());
                            // jQuery(ctrl).find('#txtAmt').val('0');

                        }
                    }



                });
            }
            else {
               // BalanceAmount = parseFloat($('#txtTotlAmt').val());
                var $totalUnPaidAmount = 0;
                jQuery('#tblSettlement').find('tr').find('input[type=checkbox]:checked').each(function () {
                    $totalUnPaidAmount += parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text());
                });
              
                $("#tblSettlement").find('tr:not(#Header)').each(function () {
                    if (jQuery(this).closest('tr').find('#chkDistributeAmt').is(':checked')) {
                        BalanceAmount = BalanceAmount + parseFloat(jQuery(ctrl).closest('tr').find('#txtAmt').val());
                        jQuery(ctrl).closest('tr').find('#txtAmt').val('0');
                        jQuery(ctrl).closest('tr').find('#txtTDSAmt').val('0');
                        jQuery(ctrl).closest('tr').find('#txtWriteOffAmt').val('0');
                        var NetAmount = parseFloat(jQuery(this).closest('tr').find('#NetAmount').text());
                        var PaidAmt = parseFloat(jQuery(this).closest('tr').find('#PaidAmount').text());

                        if (BalanceAmount != 0) {

                            var AmountToDistribute = 0;
                            var ChkChecked = ' ';
                            if (NetAmount > PaidAmt) {
                                if (BalanceAmount >= (NetAmount - PaidAmt)) {


                                    var distributedTDS = 0;
                                    var distributedWriteOff = 0;
                                    if (parseFloat(jQuery('#txtTDS').val()) > 0) {
                                        var TDSPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                        jQuery(this).closest('tr').find('#txtTDSAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtTDS').val()) * TDSPer / 100), 5));
                                        distributedTDS = parseFloat(jQuery(this).closest('tr').find('#txtTDSAmt').val());
                                    }
                                    if (parseFloat(jQuery('#txtWriteOff').val()) > 0) {
                                        var WriteOffPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                        jQuery(this).closest('tr').find('#txtWriteOffAmt').val(precise_round(parseFloat(parseFloat(jQuery('#txtWriteOff').val()) * parseFloat(WriteOffPer) / 100), 5));
                                        distributedWriteOff = parseFloat(jQuery(this).closest('tr').find('#txtWriteOffAmt').val());
                                    }
                                    AmountToDistribute = (NetAmount - PaidAmt - distributedTDS - distributedWriteOff);
                                    jQuery(this).closest('tr').find('#txtAmt').val(AmountToDistribute);

                                    var $totalPaidAmount = 0;
                                    jQuery('#tblSettlement #txtAmt').each(function () { $totalPaidAmount += parseFloat(jQuery(this).val()); });


                                    BalanceAmount = parseFloat($('#txtTotlAmt').val()) - parseFloat($totalPaidAmount);


                                }
                                else if (BalanceAmount > 0) {

                                    var distributedTDS = 0;
                                    var distributedWriteOff = 0;
                                    if (parseFloat(jQuery('#txtTDS').val()) > 0) {
                                        var TDSPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                        jQuery(this).closest('tr').find('#txtTDSAmt').val(parseFloat(parseFloat(jQuery('#txtTDS').val()) * TDSPer / 100));
                                        distributedTDS = precise_round(parseFloat(jQuery(this).closest('tr').find('#txtTDSAmt').val()), 5);
                                    }
                                    if (parseFloat(jQuery('#txtWriteOff').val()) > 0) {
                                        var WriteOffPer = parseFloat(jQuery(this).closest('tr').find('#tdUnPaidAmount').text() * 100) / parseFloat($totalUnPaidAmount);
                                        jQuery(this).closest('tr').find('#txtWriteOffAmt').val(parseFloat(parseFloat(jQuery('#txtWriteOff').val()) * WriteOffPer / 100));
                                        distributedWriteOff = precise_round(parseFloat(jQuery(this).closest('tr').find('#txtWriteOffAmt').val()), 5);
                                    }

                                    jQuery(this).closest('tr').find('#txtAmt').val(parseFloat(jQuery(this).closest('tr').find('#txtAmt').val()) + precise_round(BalanceAmount, 5));
                                    BalanceAmount = 0;
                                }

                                serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: jQuery(this).closest('tr').find('#hdnCountryID').val(), Amount: jQuery(this).closest('tr').find('#txtAmt').val() }, function (response) {
                                    var $convertedCurrencyData = JSON.parse(response);
                                    jQuery(ctrl).closest('tr').find('#hdnSAmount').val(precise_round($convertedCurrencyData.BaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                                });

                            }
                            else {

                                toast("Error", "Already full Paid", "");
                                jQuery(ctrl).find('#chkDistributeAmt').prop('checked', false);
                                jQuery(ctrl).find('#hdnSAmount').val(0);
                            }
                        }
                        else {

                            toast("Error", "Total Amount for settlement is exhausted", "");
                            jQuery(ctrl).find('#chkDistributeAmt').prop('checked', false);
                            jQuery(ctrl).find('#hdnSAmount').val(0)
                        }

                    }
                    else if (parseFloat(jQuery(ctrl).closest('tr').find('#txtAmt').val()) > 0) {
                        var count = 0;
                        $("#tblSettlement").find('tr:not(#Header)').each(function () {
                            if (jQuery(this).closest('tr').find('#chkDistributeAmt').is(':checked')) {
                                count = count + 1;
                            }
                        });
                        if (count == 0) {
                            var amt = jQuery(ctrl).closest('tr').find('#txtAmt').val();
                            BalanceAmount = parseFloat($('#txtTotlAmt').val());
                            jQuery(ctrl).closest('tr').find('#txtAmt').val('0');
                        }
                        else {
                            var amt = jQuery(ctrl).closest('tr').find('#txtAmt').val();
                            BalanceAmount = parseFloat(amt);
                            jQuery(ctrl).closest('tr').find('#txtAmt').val('0');
                        }
                    }
                   
                    
                });
            }
            jQuery("#lblBalAmt").text(precise_round(BalanceAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
        }





        function CheckAll(ctrl) {
            if (jQuery(ctrl).is(':checked')) {
                jQuery('#tblSettlement').find('tr').each(function (index) {
                    if (jQuery(this).attr('id') != "Header") {
                        jQuery(this).find('#chkDistributeAmt').prop('checked', false);
                        jQuery(this).find('#chkDistributeAmt').click();
                    }
                });
            }
            else {
                jQuery('#tblSettlement').find('tr').each(function (index) {
                    if (jQuery(this).attr('id') != "Header") {
                        jQuery(this).find('#chkDistributeAmt').prop('checked', 'checked');
                        jQuery(this).find('#chkDistributeAmt').click();
                    }
                });

            }
        }

        function GetAmt1(ctrl) {
            var TDSAmt = parseFloat(jQuery('#txtTDS').val());
            var WriteOffAmt = parseFloat(jQuery('#txtWriteOff').val());
            if (jQuery(ctrl).is(':checked')) {
                if (BalanceAmount != 0) {
                    var NetAmount = parseFloat(jQuery(ctrl).closest('tr').find('#NetAmount').text());
                    var PaidAmt = parseFloat(jQuery(ctrl).closest('tr').find('#PaidAmount').text());
                    var AmountToDistribute = 0;
                    var ChkChecked = ' ';
                    if (NetAmount > PaidAmt) {
                        if (BalanceAmount >= (NetAmount - PaidAmt)) {
                            BalanceAmount = BalanceAmount - (NetAmount - PaidAmt);
                            AmountToDistribute = (NetAmount - PaidAmt);
                            jQuery(ctrl).closest('tr').find('#txtAmt').val(AmountToDistribute);
                        }
                        else if (BalanceAmount > 0) {
                            jQuery(ctrl).closest('tr').find('#txtAmt').val(BalanceAmount);
                            BalanceAmount = 0;
                        }
                        serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: jQuery(ctrl).closest('tr').find('#hdnCountryID').val(), Amount: jQuery(ctrl).closest('tr').find('#txtAmt').val() }, function (response) {
                            var $convertedCurrencyData = JSON.parse(response);
                            jQuery(ctrl).closest('tr').find('#hdnSAmount').val(precise_round($convertedCurrencyData.BaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                        });
                    }
                    else {
                        toast("Error", "Already full Paid", "");
                        jQuery(ctrl).prop('checked', false);
                        jQuery(ctrl).closest('tr').find('#hdnSAmount').val(0)
                    }
                }
                else {
                    toast("Error", "Total Amount for settlement is exhausted", "");
                    jQuery(ctrl).prop('checked', false);
                    jQuery(ctrl).closest('tr').find('#hdnSAmount').val(0)
                }
            }
            else {
                BalanceAmount = BalanceAmount + parseFloat(jQuery(ctrl).closest('tr').find('#txtAmt').val());
                jQuery(ctrl).closest('tr').find('#txtAmt').val('0');
            }
            jQuery("#lblBalAmt").text(precise_round(BalanceAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
        }
    </script>
    <script type="text/javascript">
        function $bindAdvanceAmt() {
            jQuery('#tblAdvanceAmt tr').slice(1).remove();
            if (jQuery("#ddlPanel").val() != 0) {
                serverCall('BulkSettelment.aspx/getClientAdvanceAmt', { Panel_ID: jQuery("#ddlPanel").val() }, function (response) {

                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $("#divAdvanceAmt").show();
                        var $responseDetail = jQuery.parseJSON($responseData.response)

                        for (var j = 0; j < $responseDetail.length; j++) {
                            var $rowID = [];
                            $rowID.push('<tr id="trAdv_');
                            $rowID.push((parseInt(j) + 1));
                            $rowID.push('">');
                            $rowID.push('<td class="GridViewLabItemStyle">');
                            $rowID.push((parseInt(j) + 1)); $rowID.push('</td>');
                            $rowID.push('<td id="tdAdvanceAmt"  class="GridViewLabItemStyle"  style="text-align:right">');
                            $rowID.push($responseDetail[j].RemAmt); $rowID.push('</td>');
                            $rowID.push('<td class="GridViewLabItemStyle" >');
                            $rowID.push($responseDetail[j].CreatedBy); $rowID.push('</td>');
                            $rowID.push('<td id="tdAdvanceID" class="GridViewLabItemStyle" style=display:none >');
                            $rowID.push($responseDetail[j].ID); $rowID.push('</td>');
                            $rowID.push('<td   class="GridViewLabItemStyle"  >');
                            $rowID.push($responseDetail[j].CreatedDate); $rowID.push('</td>');
                            $rowID.push('<td   class="GridViewLabItemStyle"  >');
                            $rowID.push('<input type="checkbox" id="chkAdvanceAmt" onclick="getAdvanceAmt(this)" />'); $rowID.push('</td>');
                            

                            $rowID.push('</tr>');
                            $rowID = $rowID.join('');

                            $('#tblAdvanceAmt').append($rowID);


                        }
                    }
                    else {
                        $("#divAdvanceAmt").hide();
                    }
                });
            }
        }
        getAdvanceAmt = function (rowID) {
            if ($(rowID).is(':checked')) {
                jQuery("#tblAdvanceAmt").find('tbody tr').each(function () {
                    jQuery(this).closest('tr').find('#chkAdvanceAmt').prop('checked', false);
                    $(this).closest('tr').css('background-color', '');
                    
                });
                $(rowID).prop('checked', 'checked');

                $(rowID).closest('tr').css('background-color', 'aqua');

                
                jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                    jQuery(this).closest('tr').find('#txtPatientPaidAmount').val('0').attr('disabled', 'disabled');
                    jQuery(this).closest('tr').find('#tdBaseCurrencyAmount').text('0');
                });

                jQuery("#txtTotlAmt").val(jQuery(rowID).closest('tr').find('#tdAdvanceAmt').text());
            }
            else {
                jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                    jQuery(this).closest('tr').find('#txtPatientPaidAmount').val('0').removeAttr('disabled');
                });
            }


        }
    </script>
    <style>
        .yellow {
            background-color: aqua;
        }
    </style>
</asp:Content>

