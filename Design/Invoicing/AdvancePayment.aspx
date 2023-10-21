<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="AdvancePayment.aspx.cs" Inherits="Design_Invoicing_AdvancePayment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <style>
        #ddlBusinessZone_chosen, #ddlState_chosen, #ddl_panel_chosen {
            width: 150px !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $bindCountry(function (callback) {
                $bindBusinessZone();
            });
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
        });
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Advance Payment<br />
            </strong>           
            <div class="row">
                <div class="col-md-7" style="text-align: center"></div>
                <div class="col-md-14" style="text-align: center">
                    <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" />
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Advance Payment
            </div>
            <div class="row">
                <div class="col-md-3">
                  <label class="pull-left">  Client Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                    <asp:TextBox ID="txtPanelName" CssClass="required" runat="server" MaxLength="50" />
                    <input id="hdPanelID" type="hidden" />
                </div>
                <div class="col-md-3">
                    <input style="font-weight: bold;" type="button" value="More Filter" class="ItDoseButton" id="btnMoreFilter" onclick="MoreSearch();" />
                </div>
                <div class="col-md-3"></div>
            </div>

            <div class="divSearchInfo" style="display: none;" id="divSearch">
                <div class=" row">
                    <div class="col-md-3">
                       <label class="pull-left"> Counrty  </label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlCountry" runat="server" class="ddlCountry chosen-select chosen-container required" onchange="$bindBusinessZone()"></asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                       <label class="pull-left"> Business Zone </label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="$bindState(jQuery('#ddlBusinessZone').val(),'','')" class="required ddlBusinessZone chosen-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3 showSearch"><label class="pull-left">State </label>
                    <b class="pull-right">:</b></div>
                    <div class="col-md-3 showSearch">
                        <asp:DropDownList ID="ddlState" runat="server" onchange="$bindPanel();" class="required ddlState chosen-select">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                       <label class="pull-left"> Client Name </label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddl_panel" runat="server" onchange="Search();" CssClass="required ddl_panel chosen-select">
                        </asp:DropDownList>
                    </div>

                </div>
            </div>

            <div class="row clInvoice1" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left">Invoice No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlInvoiceNo" CssClass="requiredField" runat="server" onchange="$showInvoiceBalance();">
                    </asp:DropDownList>
                </div>
                <div class="row clInvoice" style="display: none">
                <div class="col-md-1"> </div>
                <div class="col-md-3">
                    <label class="pull-left">Pending Invoice Amt. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:Label ID="lblPendingInvoiceAmt" runat="server" ForeColor="Red" Font-Bold="true" Text="0"></asp:Label>
                </div>
                <div  class="col-md-3">
                  <label class="pull-left">Total Outstanding </label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-2" >
                    <asp:Label ID="lblTotalOutstanding" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>
                </div>
            </div>
            <div class="row clInvoice" style="display: none">
                <div class="col-md-3">
                   <label class="pull-left"> Invoice Amt. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:Label ID="lblInvoiceAmt" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-3">
                   <label class="pull-left"> Balance Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:Label ID="lblBalanceAmount" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>   
                 
               
            </div>


            <div class=" row">
                <div class="col-md-3 showSearch">
                    <label class="pull-left">Receive Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 showSearch">
                    <asp:TextBox ID="dtFrom" runat="server" CssClass="required"></asp:TextBox>
                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" />
                </div>
           
                <div class="col-md-3">
                    <label class="pull-left">Advance Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtAdvanceAmt" Enabled="false" runat="server" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftbAdvAmt" runat="server" TargetControlID="txtAdvanceAmt"
                        ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                    <input type="hidden" id="hfAmount" value="0" />
                </div>
                <div class="col-md-3 clInvoice" style="display:none">
                   <label class="pull-left"> TDS Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 clInvoice" style="display:none">
                    <asp:TextBox ID="txtTDSAmount" runat="server"  onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftbTDSAmt" runat="server" TargetControlID="txtTDSAmount"
                        ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                </div>
                         <div class="col-md-3" >
                   <label class="pull-left" style="display:none"> WriteOff Amount </label>
                    <b class="pull-right" style="display:none">:</b>
                </div>
                <div class="col-md-2 " >
                    <asp:TextBox ID="txtWriteOff" runat="server" Visible="false" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftbWriteOff" runat="server" TargetControlID="txtWriteOff"
                        ValidChars=".0987654321">
                    </cc1:FilteredTextBoxExtender>
                </div>   
              <div class="col-md-5" style="display:none">  <em><span style="color: #0000ff; font-size: 8.5pt">TDS and WriteOff Amount in Base Currency</span></em></div>
            </div>
            <div class=" row">
                <div class="col-md-3">
                    <label class="pull-left">Type </label>
                    <b class="pull-right">:</b>    
                </div>
                <div class="col-md-10">
                    <asp:RadioButtonList ID="rdbtypeOfPayment" runat="server" RepeatDirection="Horizontal" onchange="bindTypeofPayment()">
                        <asp:ListItem Text="Deposit" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Credit Note" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Debit Note" Value="2"></asp:ListItem>
                        
                    </asp:RadioButtonList>
                </div>
               
                <div class="col-md-4 clCreditDebitNoteType" style="display:none">
                    <label class="pull-left">Credit/Debit Note Type </label>
                    <b class="pull-right">:</b>    
                </div>

                <div class="col-md-5 clCreditDebitNoteType" style="display:none">
                    <asp:DropDownList ID="ddlCreditDebitNoteType" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-1 pull-left clCreditDebitNoteType" style="display:none">
                    <input type="button" value="New" id="btnNewDesignation" onclick="CreditDebitNoteTypeWindow()" class="searchbutton" />
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
                <div id="spnBlanceAmount" style="display: none; color: red; font-weight: bold; text-align: left;" class="col-md-3">
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Payment Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlPaymentMode" onchange="$onPaymentModeChange(this,jQuery('#ddlCurrency'),function(){});"></select>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Factor</label>
                    <b class="pull-right">:</b>
                </div>
                <div id="spnConvertionRate" style="color: red; font-weight: bold; text-align: left;" class="col-md-4">
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
                
                <div class="col-md-3 clPaidAmt">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                </div>
                <div id="divPaymentDetails" class="col-md-15 isReciptsBool" style="overflow-y: auto; overflow-x: hidden;">
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
                    <span class="pull-left">Transaction ID</span>
                    <strong class="pull-right">:</strong>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txttransactionid" />
                </div>
            </div>
            <div class="row">

                <div class="col-md-3 ">
                    <label class="pull-left">Remarks   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtPaymentRemarks" runat="server" MaxLength="100"  CssClass="requiredField"></asp:TextBox>
                </div>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input id="btnSave" type="button" runat="server" value="Save" class="savebutton"  onclick="saveAdvancePayment()"/>
            <input id="btnExcel" type="button" value="Excel (Cancel Entry)" onclick="ExporttoExcel();" class="searchbutton" />
            <input id="btnExcelActive" type="button" value="Excel (Active Entry)" onclick="ExporttoExcelActive();" class="searchbutton" />
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Previous Advance Amount
            </div>
            <div id="tb_Search">
            </div>

        </div>
        <asp:Button ID="btnHide" runat="server" Style="display: none" UseSubmitBehavior="false" />
    </div>

    <cc1:ModalPopupExtender ID="mpPaymentCancel" runat="server"
        DropShadow="true" TargetControlID="btnHide" CancelControlID="imgPaymentCancel" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlPaymentCancel" BehaviorID="mpPaymentCancel">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnlPaymentCancel" runat="server" Style="display: none; width: 580px;" CssClass="pnlVendorItemsFilter">
        <div class="Purchaseheader">
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td style="text-align: right">
                        <img id="imgPaymentCancel" runat="server" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" onclick="closePaymentCancel()" />
                    </td>
                </tr>
            </table>
        </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="2" style="text-align: center">&nbsp;<asp:Label ID="lblErrorPopUp" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </td>

            </tr>
            <tr>
                <td style="text-align: right" >Cancellation Remark :&nbsp;
                </td>
                <td style="text-align: left">
                    <input type="text" id="txtRejectRemark" style="width: 300px" maxlength="50" class="required"/>
                </td>
            </tr>
            <tr style="display: none" id="trChequeBounce">
                <td style="text-align: right">Cheque Bounce Amt. :&nbsp;
                </td>
                <td style="text-align: left">
                    <asp:TextBox ID="txtChequeBounceAmt" runat="server" MaxLength="8"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbChequeBounceAmt" runat="server" TargetControlID="txtChequeBounceAmt" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                </td>
            </tr>

            <tr style="text-align: center">
                <td colspan="2">
                    <input id="btnRejectAdvance" type="button" value="Save" onclick="RejectAdvance();" class="ItDoseButton" />
                    <input id="btnCancelRejectAdvance" type="button" value="Cancel" onclick="CancelRejectAdvance();" class="ItDoseButton" />
                    <input type="text" id="txt_id" style="display: none;" />

                </td>
            </tr>

        </table>

    </asp:Panel>

    <asp:Button ID="btnCreditDebitNoteType" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalCreditDebitNoteType" runat="server"
        DropShadow="true" TargetControlID="btnCreditDebitNoteType" CancelControlID="closeCreditDebitNoteType" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlCreditDebitNoteType" OnCancelScript="CloseCreditDebitNoteTypeWindow()" BehaviorID="modalCreditDebitNoteType">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlCreditDebitNoteType" runat="server" Style="display: none; width: 540px; height: 130px;" CssClass="pnlVendorItemsFilter">
        <div class="Purchaseheader">
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td>Add New Credit/Debit Note Type &nbsp;</td>
                    <td style="text-align: right">
                        <img id="closeCreditDebitNoteType" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" />
                    </td>
                </tr>
            </table>
        </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="2" style="text-align: center;">&nbsp; 
                    <label for="txtCreditDebitNoteType" id="lblMsgCreditDebitNoteType" class="ItDoseLblError"></label>
                </td>
            </tr>
            <tr>
                <td style="width: 160px; text-align: right">Credit/Debit Note Type :&nbsp;</td>
                <td style="width: 233px; text-align: left">
                    <input type="text" id="txtCreditDebitNoteType" style="width: 200px;" value="" maxlength="50" />
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="text-align: center;">
                        <input type="button" class="searchbutton" onclick="SaveCreditDebitNoteType()" id="btnSaveCreditDebitNoteType" style="" value="Save" />
                        <input type="button" class="searchbutton" onclick="CloseCreditDebitNoteTypeWindow()" id="btnCancelCreditDebitNoteType" style="" value="Cancel" />
                    </div>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <script type="text/javascript">
        function closePaymentCancel() {
            $find('mpPaymentCancel').hide();
            $("#txtRejectRemark,#txtChequeBounceAmt").val('');
            $("#lblErrorPopUp").text('');
            $("#btnRejectAdvance").removeAttr('disabled').val('Save');
        }
    </script>
    <script type="text/javascript">

        function validate() {
            if ($("#ddl_panel").val() == 0) {
                toast("Error", 'Please Select Client Name', "");
                $("#ddl_panel").focus();
                return false;
            }
            if ($.trim($("#<%=txtAdvanceAmt.ClientID%>").val()) == 0 || $.trim($$("#<%=txtAdvanceAmt.ClientID%>").val()) == "") {
                toast("Error", 'Please Enter Advance Amount', "");
                $("#<%=txtAdvanceAmt.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#txtPaymentRemarks").val()) == "") {
                toast("Error", 'Please Enter Remarks', "");
                $("#txtPaymentRemarks").focus();
                return false;
            }
        }
        function clearform() {
            $(':text, textarea').val('');
            $("#hfAmount").val('0');
            $('input[type=radio]#rblSearchType_2').attr("checked", true);
            //$('input[type=radio]#rblSearchType_0').attr("disabled", true);
            //$('input[type=radio]#rblSearchType_3').attr("disabled", true);
        }

    </script>
    <script type="text/javascript">
        function Reject(rowID) {
            $("#txt_id").val($(rowID).closest("tr").find("#tdID").text());
            if ($.trim($(rowID).closest("tr").find("#tdPaymentMode").text()) == "CHEQUE") {
                $('#trChequeBounce').show();
            }
            else {
                $('#trChequeBounce').hide();
            }
            $('#txtRejectRemark,#txtChequeBounceAmt').val('');
            $find('mpPaymentCancel').show();
        }
        function CancelRejectAdvance() {
            closePaymentCancel();
        }
        function RejectAdvance() {
            if ($.trim($("#txtRejectRemark").val()) == "") {
                toast("Error", 'Please Enter Remarks', "");
                $("#txtRejectRemark").focus();
                return;
            }
            $("#btnRejectAdvance").attr('disabled', 'disabled').val('Submitting...');


            serverCall('AdvancePayment.aspx/RejectPrevAdvPayment', { ID: jQuery("#txt_id").val(), CancelReason: jQuery.trim(jQuery("#txtRejectRemark").val()), ChequeBounceAmt: jQuery("#txtChequeBounceAmt").val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Amount Rejected Successfully", "");
                    Search();
                    $clearControl();
                    $find('mpPaymentCancel').hide();
                    $("#btnRejectAdvance").removeAttr('disabled').val('Save');
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                    $("#btnRejectAdvance").removeAttr('disabled').val('Save');
                }
                $modelUnBlockUI(function () { });
            });


        }

        $(document).ready(function () {
            $('#<%=txtAdvanceAmt.ClientID%>').keypress(function (event) {
                var $this = $(this);
                if ((event.which != 46 || $this.val().indexOf('.') != -1) &&
                   ((event.which < 48 || event.which > 57) &&
                   (event.which != 0 && event.which != 8))) {
                    event.preventDefault();
                }

                var text = $(this).val();
                if ((event.which == 46) && (text.indexOf('.') == -1)) {
                    setTimeout(function () {
                        if ($this.val().substring($this.val().indexOf('.')).length > 3) {
                            $this.val($this.val().substring(0, $this.val().indexOf('.') + 3));
                        }
                    }, 1);
                }

                if ((text.indexOf('.') != -1) &&
                    (text.substring(text.indexOf('.')).length > 2) &&
                    (event.which != 0 && event.which != 8) &&
                    ($(this)[0].selectionStart >= text.length - 2)) {
                    event.preventDefault();

                }
            });
        });

        //Cancel Report
        function ExporttoExcel() {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
            }
            if (PanelID == "") {
                toast("Info", "Please select Panel !!");
                return;
            }
            $.ajax({
                //url: "AdvanceAmountPayment.aspx/ExporttoExcel",
                url: "AdvancePayment.aspx/SearchdataExcel",
                data: '{PanelID: "' + PanelID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = result.d;
                    if (result == "true") {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                    else {
                        toast('Info','No Record Found..!');
                    }
                    $modelUnBlockUI(function () { });

            },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });

        }
        //Active Report - Bilal - 15/04/19
        function ExporttoExcelActive() {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
            }
            if (PanelID == "") {
                toast("Info", "Please select Panel !!");
                return;
            }
            $.ajax({
                url: "AdvancePayment.aspx/SearchdataExcelActive",
                data: '{PanelID: "' + PanelID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = result.d;
                    if (result == "true") {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                    else {
                        toast('Info','No Record Found..!');
                    }
                    $modelUnBlockUI(function () { });
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });

        }
            function Search() {

                var PanelID = ""; var EntryType = "";

                if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                    PanelID = jQuery("#hdPanelID").val().split('#')[0];
                    EntryType = jQuery("#hdPanelID").val().split('#')[1];
                }
                else {
                    PanelID = $("#ddl_panel").val().split('#')[0];
                    EntryType = $("#ddl_panel").val().split('#')[1];
                }
                //typeofPayment: $('#rdbtypeOfPayment input[type=radio]:checked').val() 
                serverCall('AdvancePayment.aspx/SearchPrevAdvPayment', { PanelID: PanelID}, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        AdvanceAmtData = $responseData.data;
                        var output = $('#tb_Search_grd').parseTemplate(AdvanceAmtData);
                        $('#tb_Search').html(output);
                        $('#tb_Search').show();
                        jQuery("#tblSearch").tableHeadFixer({
                        });
                    }

                    else {
                        $('#tb_Search').hide();
                        toast("Error", $responseData.ErrorMsg, "");
                        $("#btnRejectAdvance").removeAttr('disabled').val('Save');
                    }
                    $modelUnBlockUI(function () { });
                });
            }
    </script>

    <script id="tb_Search_grd" type="text/html">    
        <div class="content" style="overflow:scroll;height:300px">

        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"  id="tblSearch"
    style="border-collapse:collapse;">
         <thead>
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;text-align:center">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px; text-align:center">Client Code</th>            
			<th class="GridViewHeaderStyle" scope="col" style="width:240px; text-align:center">Client Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px; text-align:center">TransactionID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center;width:100px;">Base Amount(<%=Resources.Resource.BaseCurrencyNotation %>)</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Payment Mode</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Payment Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Card No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Card Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Pay Currency</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Paid Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Conversion</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;text-align:center">Deposit By</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:100px;">Deposit Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:140px;">Entry Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:240px;">Remarks</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:60px;">Cancel Advance</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none">Receipt</th>		                   			
            <th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:30px;">#</th>	
</tr>
             </thead>
      <#       
              var dataLength=AdvanceAmtData.length;
              var objRow;   
             var RecieveAmt=0;
        for(var j=0;j<dataLength;j++)
        {
        objRow = AdvanceAmtData[j];         
             RecieveAmt+=Number(objRow.ReceivedAmt);  
            #>
                    <tr>
<td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Panel_Code#>                        
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Company_Name#>
</td>
    <td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.TransactionID#>
</td>
 <td class="GridViewLabItemStyle" id="tdID" style="text-align:left;display:none"><#=objRow.ID#>
<td class="GridViewLabItemStyle" style="text-align:right;width:110px"><#=objRow.ReceivedAmt#></td>
<td class="GridViewLabItemStyle" id="tdPaymentMode" style="text-align:left;"><#=objRow.PaymentMode#></td>
     <td class="GridViewLabItemStyle" id="td1" style="text-align:left;"><#=objRow.CreditNote#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CardNo#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CardDate#></td>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.S_Currency#></td>
<td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.S_Amount#></td>
<td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.C_Factor#></td>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.EntryBy#></td>
<td class="GridViewLabItemStyle" style="text-align:center;width:120px"><#=objRow.AdvanceAmtDate#></td>
<td class="GridViewLabItemStyle" style="text-align:center;width:120px"><#=objRow.EntryDate#></td>
<td class="GridViewLabItemStyle" style="text-align:left;width:150px"><#=objRow.remarks#></td>
<#if(objRow.AllowCancel=="1"){#>
<td class="GridViewLabItemStyle" style="text-align:center">
 <a href="javascript:void(0);" onclick="Reject(this);"display='none';">
    <img src="../../App_Images/Reject.png" style="border:none;" title="Reject Amount" />
          </a>
</td>
<#}else{#>
<td class="GridViewLabItemStyle" style="text-align:center"></td>
<#}#>
 <td class="GridViewLabItemStyle" style="text-align:center;display:none">
 <a href="AdvanceAmountPayment.aspx?panelid=<#=objRow.Panel_ID#>&id=<#=objRow.ID#>">
    <img src="../../App_Images/folder.gif" style="border:none;" title="Receipt" />
                        </td>
    <td id="Print"  class="GridViewLabItemStyle" style="width:200px">
     <%--<#if(objRow.TYPE !='TDS') { #>--%>
<a href="javascript:void(0);" onclick="getInvoice('<#=objRow.ID#>','<#=objRow.CreditNote#>');">Print</a>
    <%--<# } #>--%>
</td>
</tr>

<#}#>

<tr >
<td class="GridViewLabItemStyle" colspan="3"   style="color:Red  ; font-weight:bold;text-align:right">Total :</td>
<td class="GridViewLabItemStyle"  style="color:Red  ; font-weight:bold;text-align:right"><#=precise_round(RecieveAmt,'<%=Resources.Resource.BaseCurrencyRound%>')#></td>
 

 </tr> 
        </table> 
     
  </div>
    </script>
    <script type="text/javascript">
        jQuery(function () {
            SetMode();
        });
        function SetMode() {
            var paymentMode = jQuery.trim(jQuery("#paymentMode option:selected").text());

            if (paymentMode == "Cheque" || paymentMode == "Draft" || paymentMode == "Credit Card" || paymentMode == "NEFT") {
                jQuery('.Bank').show();
                jQuery('.chk').show();
            }
            else {
                jQuery('.chk').hide();
                jQuery('.Bank').hide();
            }
            jQuery('.spnPaymentMode').text(paymentMode);
        }
    </script>
    <script type="text/javascript">
        function getInvoice(id, _Type) {
            window.open('../../Design/Invoicing/AdvancePaymentPDF.aspx?id=' + id + '&Type=' + _Type + '');
        }
        function saveAdvancePayment() {
            var PanelID = ""; var EntryType = "";

            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
                EntryType = jQuery("#hdPanelID").val().split('#')[1];
            }
            else {
                if ($("#ddl_panel").val() != null && $("#ddl_panel").val() != "") {
                    PanelID = $("#ddl_panel").val().split('#')[0];
                    EntryType = $("#ddl_panel").val().split('#')[1];
                }
            }

            if (PanelID == 0 || PanelID == null || PanelID == "") {
                toast("Error", 'Please Select Client Name', "");
                jQuery("#txtPanelName").focus();
                return;
            }
            if ($('#txttransactionid').val() == "" && $('#ddlPaymentMode').val()=="7")  //NEFT
            {
                toast("Error", 'Please Fill TransactionID', "");
                jQuery("#txttransactionid").focus();
                return;
            }
            if (jQuery.trim($("#<%=txtAdvanceAmt.ClientID%>").val()) == 0 || jQuery.trim($("#<%=txtAdvanceAmt.ClientID%>").val()) == "") {
                toast("Error", 'Please Enter Advance Amount', "");
                $("#<%=txtAdvanceAmt.ClientID%>").focus();
                    return;
                }

                if (jQuery.trim(jQuery("#txtPaymentRemarks").val()) == "") {
                    toast("Error", 'Please Enter Remarks', "");
                    jQuery("#txtPaymentRemarks").focus();
                    return;
                }

                var typeOfPayment = jQuery('#rdbtypeOfPayment input[type=radio]:checked').val();
                if ((typeOfPayment == "1" || typeOfPayment == "2") && $('#ddlCreditDebitNoteType').val() == "0") {
                    toast("Error", 'Please Select Credit/Debit Note Type', "");
                    jQuery("#ddlCreditDebitNoteType").focus();
                    return;
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
                    toast("Error", "Error Please Enter Card Detail", "");
                    return false;
                }
                if ($cardDateValidate == 1) {
                    toast("Error", "Error Please Enter Card Date Detail", "");
                    return false;
                }
                if ($bankValidate == 1) {
                    toast("Error", "Error Please Select Bank Name", "");
                    return false;
                }
                if ($("#hfID").val() == "") {
                    toast("Error", "Plase select again", "");
                    return false;
                }
                var TransactionID = $('#txttransactionid').val();
                if ($('#ddlPaymentMode').val() != "1") {
                    if (TransactionID == "") {
                        toast("Error", "Plase Enter TransactionID", "");
                        return false;
                    }
                }


                var resultAdvanceAmount = AdvanceAmount();

                serverCall('AdvancePayment.aspx/SaveAdvPayment', { PanelAdvanceAmount: resultAdvanceAmount }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", "Amount Submitted Successfully", "");
                        jQuery("#ddlInvoiceNo option").remove();
                        // Search();

                        jQuery('#tb_Search').html('');
                        AdvanceAmtData = $responseData.data;
                        var output = $('#tb_Search_grd').parseTemplate(AdvanceAmtData);
                        $('#tb_Search').html(output);
                        $('#tb_Search').show();
                        jQuery("#tblSearch").tableHeadFixer({
                        });





                        $('#<%=dtFrom.ClientID %>').val('<%=DateTime.Now.ToString("dd-MMM-yyyy") %>');


                            $clearControl();
                            $(function () {
                                $getCurrencyDetails(function (baseCountryID) {
                                    $getConversionFactor(baseCountryID, function (CurrencyData) {
                                        jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                                        jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                                        jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));
                                    $bindPaymentMode();
                                });
                            });
                        });


                    }

                    else {
                        toast("Error", $responseData.ErrorMsg, "");
                    }
                    $modelUnBlockUI(function () { });
                });


            }
            $clearControl = function () {
                $("#<%=txtAdvanceAmt.ClientID%>,#txtTDSAmount,#txtWriteOff,#txtPaymentRemarks,#txtPanelName,#hdPanelID,#txttransactionid").val('');
            clearInvoiceDetail();
        }

        function AdvanceAmount() {

            var AdvanceAmount = new Array();
            var objAdvanceAmount = new Object();

            var PanelID = ""; var EntryType = "";
            var PanelData = "";

            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
                EntryType = jQuery("#hdPanelID").val().split('#')[1];
                PanelData = jQuery("#hdPanelID").val();
            }
            else {
                PanelID = $("#ddl_panel").val().split('#')[0];
                EntryType = $("#ddl_panel").val().split('#')[1];
                PanelData = jQuery("#ddl_panel").val();
            }

            objAdvanceAmount.PanelID = PanelID;
            objAdvanceAmount.EntryType = EntryType;

            objAdvanceAmount.DepositeDate = $('#<%=dtFrom.ClientID%>').val();
                objAdvanceAmount.AdvAmount = $('#<%=txtAdvanceAmt.ClientID%>').val();

            objAdvanceAmount.TypeOfPayment = $('#rdbtypeOfPayment input[type=radio]:checked').val();
            objAdvanceAmount.Remarks = $("#txtPaymentRemarks").val()

            objAdvanceAmount.PanelPaymentMode = PanelData.split('#')[2];

            var CreditDebitNoteTypeID = 0;
            var CreditDebitNoteType = "";
            var typeOfPayment = jQuery('#rdbtypeOfPayment input[type=radio]:checked').val();
            if ((typeOfPayment == "1" || typeOfPayment == "2")) {
                CreditDebitNoteTypeID = $('#ddlCreditDebitNoteType').val();
                CreditDebitNoteType = $('#ddlCreditDebitNoteType option:selected').text();

            }

            objAdvanceAmount.CreditDebitNoteTypeID = CreditDebitNoteTypeID;
            objAdvanceAmount.CreditDebitNoteType = CreditDebitNoteType;

            $("#tblPaymentDetail").find('tbody tr').each(function (index, value) {
                if (index == 0) {

                    objAdvanceAmount.PaymentMode = $(this).closest('tr').find('#tdPaymentMode').text();
                    objAdvanceAmount.PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text();
                    objAdvanceAmount.BankName = String.isNullOrEmpty($(this).closest('tr').find('#tdBankName select').val()) ? '' : $(this).closest('tr').find('#tdBankName select').val();
                    objAdvanceAmount.S_Amount = $(this).closest('tr').find('#txtPatientPaidAmount').val();
                    objAdvanceAmount.S_CountryID = $(this).closest('tr').find('#tdS_CountryID').text();
                    objAdvanceAmount.S_Currency = $(this).closest('tr').find('#tdS_Currency').text();
                    objAdvanceAmount.S_Notation = $(this).closest('tr').find('#tdS_Notation').text();
                    objAdvanceAmount.C_Factor = $(this).closest('tr').find('#tdC_Factor').text();
                    objAdvanceAmount.Currency_RoundOff = $('#txtCurrencyRound').val();
                    objAdvanceAmount.CurrencyRoundDigit = $(this).closest('tr').find('#tdCurrencyRound').text();
                    objAdvanceAmount.Naration = "";
                    objAdvanceAmount.Converson_ID = $(this).closest('tr').find('#tdConverson_ID').text();
                    objAdvanceAmount.CardNo = String.isNullOrEmpty($(this).closest('tr').find('#txtCardNo').val()) ? '' : $(this).closest('tr').find('#txtCardNo').val();
                    objAdvanceAmount.CardDate = String.isNullOrEmpty($(this).closest('tr').find('#txtCardDate').val()) ? '' : $(this).closest('tr').find('#txtCardDate').val();

                }
            });

            objAdvanceAmount.IsAgainstinvoice = PanelData.split('#')[4];
            if (PanelData.split('#')[4] == "1") {
                objAdvanceAmount.InvoiceNo = $('#ddlInvoiceNo option:selected').text();
                objAdvanceAmount.InvoiceAmount = $('#lblInvoiceAmt').text();
                objAdvanceAmount.InvoiceDate = $('#ddlInvoiceNo').val().split('#')[2];
            }
            else {
                objAdvanceAmount.InvoiceNo = "";
                objAdvanceAmount.InvoiceAmount = 0;
                objAdvanceAmount.InvoiceDate = "";
            }
            if (($('#txtWriteOff').val() != "" && $('#txtWriteOff').val() != 0) || ($('#txtTDSAmount').val() != "" && $('#txtTDSAmount').val() != 0)) {
                AdvanceAmount.push(objAdvanceAmount);
                objAdvanceAmount = new Object();

            }
            else {
                AdvanceAmount.push(objAdvanceAmount);
            }
            if ($('#txtTDSAmount').val() != "" && $('#txtTDSAmount').val() != 0) {
                objAdvanceAmount.PaymentMode = "TDS";
                objAdvanceAmount.PaymentModeID = "11";
                objAdvanceAmount.CardNo = "";
                objAdvanceAmount.AdvAmount = $('#txtTDSAmount').val();
                AdvanceAmount.push(objAdvanceAmount);
                objAdvanceAmount = new Object();
            }
           // if ($('#txtWriteOff').val() != "" && $('#txtWriteOff').val() != 0) {
             //   objAdvanceAmount.PaymentMode = "WriteOff";
            //    objAdvanceAmount.PaymentModeID = "12";
             //   objAdvanceAmount.AdvAmount = $('#txtWriteOff').val();
            //    AdvanceAmount.push(objAdvanceAmount);
             //   objAdvanceAmount = new Object();
           // }

            objAdvanceAmount.TransactionID = $('#txttransactionid').val()

            return AdvanceAmount;
        }


        var $bindCountry = function (callback) {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: 0, StateID: 0, CityID: 0, IsStateBind: 0, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 0, IsLocality: 0 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=Resources.Resource.BaseCurrencyID%>' });
                jQuery('#ddlCountry').val('<%=Resources.Resource.BaseCurrencyID%>').trigger("chosen:updated");
                callback($ddlCountry.val());
            });

        }

        $bindBusinessZone = function () {
            var $ddlBusinessZone = jQuery('#ddlBusinessZone');
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWithCountry', { CountryID: jQuery('#ddlCountry').val() }, function (response) {
                $ddlBusinessZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', isSearchAble: true });
            });
            $("#ddlBusinessZone").trigger('chosen:updated');
        }

        var $bindState = function (zoneid, stateid, panelid) {
            var $ddlState = $('#ddlState');
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: "14", BusinessZoneID: zoneid }, function (response) {
                $ddlState.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'State', defaultValue: "Select", isSearchAble: true });
                if (stateid != '') {
                    jQuery('#ddlState').val(stateid);
                    jQuery("#ddlBusinessZone").val(zoneid);
                    $("#ddlBusinessZone").trigger('chosen:updated');
                }
            });
        }

        function bindState() {
            jQuery("#ddlState option").remove();


            jQuery('#ddlState').trigger('chosen:updated');
            if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);

            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlState').trigger('chosen:updated');

        }
        function onFailureState() {

        }
        var $bindPanel = function () {
            if (jQuery("#ddlBusinessZone").val() == 0) {
                showerrormsg('Please Select BusinessZone');
                jQuery("#ddlBusinessZone").focus();
                return;
            }

            jQuery("#ddl_panel option").remove();
            jQuery('#ddl_panel').trigger('chosen:updated');

            var $ddlPanel = $('#ddl_panel');
            serverCall('AdvancePayment.aspx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").val() ,PanelGroup :jQuery("#rblSearchType input[type=radio]:checked").next('label').text()}, function (response) {
                $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', defaultValue: "", isSearchAble: true });
                $("#ddl_panel").trigger('chosen:updated');
            });
        }


        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            if (panelData != null) {
                jQuery('#ddl_panel').append(jQuery("<option></option>").val('0').html(''));
                for (i = 0; i < panelData.length; i++) {
                    jQuery("#ddl_panel").append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('#ddl_panel').trigger('chosen:updated');
            }
        }
        function OnfailurePanel() {

        }
        function clearControl() {
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
            jQuery('#ddlState,#ddlCity,#ddl_panel').empty();
            jQuery('#ddlState,#ddlCity,#ddl_panel').trigger('chosen:updated');
            jQuery('#txtPanelName,#hdPanelID').val('');
            jQuery('#tb_Search').html('');
            jQuery('#tb_Search').hide();

        }
        function clearInvoiceDetail() {
            $(".clInvoice").hide();
            jQuery('#txtTDSAmount,#txtWriteOff').val('');
            $("#lblInvoiceAmt,#lblPendingInvoiceAmt,#lblBalanceAmount,#lblTotalOutstanding").html('');
            $("#lblPendingInvoiceAmt").html('0');
            //jQuery("#ddlInvoiceNo option").remove();
        }
        function bindTypeofPayment() {
            if (jQuery('#rdbtypeOfPayment input[type=radio]:checked').val() == "0") {
                jQuery('#txtTDSAmount,#txtWriteOff').removeAttr('disabled');
                $(".clInvoice").show();
                //showPayment();
            }
            else {
                jQuery('#txtTDSAmount,#txtWriteOff').attr('disabled', 'disabled');
                //showPayment();
                clearInvoiceDetail();
            }
            if (jQuery('#rdbtypeOfPayment input[type=radio]:checked').val() == "1" || jQuery('#rdbtypeOfPayment input[type=radio]:checked').val() == "2") {
                jQuery(".clCreditDebitNoteType").show();

            }
            else {
                jQuery(".clCreditDebitNoteType").hide();
            }
            jQuery('#txtTDSAmount,#txtWriteOff').val('');
            jQuery("#ddlCreditDebitNoteType").prop('selectedIndex', 0);
          //   Search();
        }

    </script>
    <script type="text/javascript">
        function MoreSearch() {

            $("#btnMoreFilter").val();
            jQuery('.divSearchInfo').slideToggle("slow", "linear");
            jQuery('#divSearch').show();
            if (jQuery('#btnMoreFilter').val() == "More Filter")
                jQuery('#btnMoreFilter').val('Back');
            else
                jQuery('#btnMoreFilter').val('More Filter');
            jQuery("#hdPanelID").val('');
            jQuery("#txtPanelName").val('');
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
            jQuery('#ddlState,#ddl_panel').empty();
            jQuery('#ddlState,#ddl_panel').trigger('chosen:updated');
            jQuery('#tb_Search').hide();
        }


        jQuery(function () {
            var PaymentMode = "";
            jQuery('#txtPanelName').bind("keydown", function (event) {
                jQuery('#divSearch').hide();
                jQuery('#btnMoreFilter').val('More Filter');
                if (event.keyCode === jQuery.ui.keyCode.TAB &&
                    $(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
            })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindPanelAdvPay", {
                          SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(),
                          PaymentMode: PaymentMode,
                          PanelName: request.term
                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = this.value;
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {
                      jQuery("#hdPanelID").val('');
                      jQuery("#hdPanelID").val(ui.item.value);
                      this.value = ui.item.label;
                      showPayment();

                      Search();
                      return false;
                  },
              });
        });
        function showPayment() {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val();
            }
            else {
                PanelID = $("#ddl_panel").val();
            }
            if (PanelID != "") {
                if (PanelID.split('#')[3] == "2") {
                    $(".clInvoice").show();
                    $(".clInvoice1").show();
                    $GetInvoiceDetails();
                }
                else
                    $(".clInvoice").hide();
            }
            else {
                $(".clInvoice").hide();
            }
            $("#txtTDSAmount,#txtWriteOff").val('');
        }
    </script>
    <script type="text/javascript">
        function CreditDebitNoteTypeWindow() {
            $find('modalCreditDebitNoteType').show();
            $('#txtCreditDebitNoteType').focus();
        }
        function CloseCreditDebitNoteTypeWindow() {
            $find('modalCreditDebitNoteType').hide();
            $('#txtCreditDebitNoteType').val('');
        }
        function SaveCreditDebitNoteType() {
            if ($.trim($('#txtCreditDebitNoteType').val()) == "") {
                toast("Error", "Please Enter Credit/Debit Note Type", "");
                $('#txtCreditDebitNoteType').focus();
                return;
            }
            $('#btnSaveCreditDebitNoteType').attr('disabled', 'disabled').val('Submitting...');

            serverCall('AdvancePayment.aspx/saveCreditDebitNoteType', { CreditDebitNoteType: $.trim($('#txtCreditDebitNoteType').val()) }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($("#<%=ddlCreditDebitNoteType.ClientID%> option").length == 0)
                        $("#<%=ddlCreditDebitNoteType.ClientID%>").append('<option value="0" selected="selected">Select</option>');

                    $("#<%=ddlCreditDebitNoteType.ClientID%>").find('option:selected').removeAttr("selected");
                    $("#<%=ddlCreditDebitNoteType.ClientID%>").append('<option value="' + $responseData.TypeID + '" selected="selected">' + $responseData.TypeName + '</option>');
                    CloseCreditDebitNoteTypeWindow();
                }

                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $('#btnSaveCreditDebitNoteType').removeAttr('disabled').val('Save');
                $modelUnBlockUI(function () { });
            });

        }

        jQuery(function () {
            jQuery('#ddlCreditDebitNoteType option').empty();
            PageMethods.bindCreditDebitNoteType(onSucessCreditDebitNoteType, onFailureCreditDebitNoteType);
        });
        function onSucessCreditDebitNoteType(result) {
            var data = $.parseJSON(result)
            jQuery('#ddlCreditDebitNoteType').append(jQuery("<option></option>").val("0").html('Select'));
            if (data != null) {

                for (i = 0; i < data.length; i++) {
                    jQuery('#ddlCreditDebitNoteType').append(jQuery("<option></option>").val(data[i].ID).html(data[i].TypeName));
                }
            }
        }
        function onFailureCreditDebitNoteType() {

        }
    </script>


    <script  type="text/javascript">

        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            if (calculateConversionFactor == "1")
                $("#txtAdvanceAmt").val('0');
            var _temp = [];
            if (calculateConversionFactor == 1) {
                var blanceAmount = $("#<%=txtAdvanceAmt.ClientID%>").val();
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
                var blanceAmount = $("#<%=txtAdvanceAmt.ClientID%>").val();
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
        function makeid(length) {
            var result = '';
            var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            var charactersLength = characters.length;
            for (var i = 0; i < length; i++) {
                result += characters.charAt(Math.floor(Math.random() *
           charactersLength));
            }
            return result;
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

        var $onPaidAmountChanged = function (e) {
            var row = $(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
            var $paidAmount = Number(e.target.value);


            $("#<%=txtAdvanceAmt.ClientID%>").val($paidAmount);
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

            var $roundOffTotalPaidAmount = Math.round($totalPaidAmount);
            $('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));

            var $blanceAmount = $("#<%=txtAdvanceAmt.ClientID%>").val();
            if (isNaN($blanceAmount) || $blanceAmount == "")
                $blanceAmount = 0;
            var $currencyRound = 0;
            $blanceAmount = parseFloat($blanceAmount) + precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');
            $currencyRound = precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');

            var $currencyRoundValue = parseFloat($('#txtPaidAmount').val()) + parseFloat($currencyRound);

            if ($blanceAmount < 1)
                $('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
            else
                $('#txtCurrencyRound').val('0');


            $("#<%=txtAdvanceAmt.ClientID%>").val($totalPaidAmount);
            chkBalanceAmount();
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
                $("#ddlPaymentMode option[value=9]").remove();
                $bindPaymentControl();
            });
        }
        $bindPaymentControl = function () {
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            $('#ddlPaymentMode').prop('selectedIndex', 0);
            $validatePaymentModes(1, 'Cash', Number($('#txtAmount').val()), $('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails($('#ddlPaymentMode option:selected'), response, function (data) {
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
            $('#tblPaymentDetail tbody').append($temp);
            $('#tblPaymentDetail tbody tr').find('#txtCardDate').datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0",
                onSelect: function (dateText) {
                    $('#tblPaymentDetail tbody tr').find('#txtCardDate').val(dateText);
                }
            });
            if ($(".clChequeNo").length == 0)
                $('.clHeaderChequeNo').hide();
            else
                $('.clHeaderChequeNo').show();
            if ($(".clChequeDate").length == 0)
                $('.clHeaderChequeDate').hide();
            else
                $('.clHeaderChequeDate').show();

            if ($(".clBankName").length == 0)
                $('.clHeaderBankName').hide();
            else
                $('.clHeaderBankName').show();
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

        $(function () {
            $('input[type=radio]#rblSearchType_0').attr("checked", true);
            //$('input[type=radio]#rblSearchType_0').attr("disabled", true);
            //$('input[type=radio]#rblSearchType_3').attr("disabled", true);
            $getCurrencyDetails(function (baseCountryID) {
                $getConversionFactor(baseCountryID, function (CurrencyData) {
                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));
                    $bindPaymentMode();
                });
            });
        });

        var $GetInvoiceDetails = function () {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val();
            }
            else {
                PanelID = $("#ddl_panel").val();
            }
            serverCall('AdvanceAmountPayment.aspx/bindInvoice', { PanelID: PanelID.split('#')[0] }, function (response) {
                InvoiceData = jQuery.parseJSON(response);
               // var $responseData = JSON.parse(response);
                jQuery("#ddlInvoiceNo option").remove();
                if (InvoiceData.length != 0) {
                   // InvoiceData = $responseData.data;
                    jQuery("#ddlInvoiceNo").append(jQuery("<option>0</option>").val("0").html("Select"));
                    for (i = 0; i < InvoiceData.length; i++) {
                        jQuery("#ddlInvoiceNo").append(jQuery("<option></option>").val(InvoiceData[i].ID).html(InvoiceData[i].InvoiceNo));
                    }
                }
                else {
                    jQuery("#ddlInvoiceNo").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                $modelUnBlockUI(function () { });
            });
            // callback(true);
        }
        var $showInvoiceBalance = function () {
            $("#txtAdvanceAmt").val('0');
            $("#txtTDSAmount,#txtWriteOff").val('');

            $getCurrencyDetails(function (baseCountryID) {
                $getConversionFactor(baseCountryID, function (CurrencyData) {
                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '2'), ' ', jQuery('#spnBaseNotation').text()));
                    $bindPaymentMode();
                });
            });
            $("#lblInvoiceAmt,#lblPendingInvoiceAmt,#lblBalanceAmount,#lblTotalOutstanding").html('');
            $("#lblPendingInvoiceAmt").html('0');
            if ($('#ddlInvoiceNo').val() != "0") {
                $showBalanceAmt(function () { });
                $totalOutstandingBalance(function () { });
            }
        }
        var $showBalanceAmt = function () {
            $('#lblInvoiceAmt').text($('#ddlInvoiceNo').val().split('#')[1]);
            serverCall('AdvanceAmountPayment.aspx/InvoicePendingAmt', { InvoiceNo: $('#ddlInvoiceNo option:selected').text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    result = $responseData.data;
                    $('#lblPendingInvoiceAmt').text(precise_round(parseFloat($('#lblInvoiceAmt').text() - parseFloat(result)), '<%=Resources.Resource.BaseCurrencyRound%>'));
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
            });

        }
        var $totalOutstandingBalance = function () {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") {
                PanelID = jQuery("#hdPanelID").val();
            }
            else {
                PanelID = $("#ddl_panel").val();
            }
            serverCall('AdvanceAmountPayment.aspx/totalOutstanding', { PanelID: PanelID.split('#')[0] }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $('#lblTotalOutstanding').text(parseFloat($responseData.data));
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
            });
            // callback(true)
        }
        function chkBalanceAmount() {

            var AdvAmt = $('#txtAdvanceAmt').val();
            if (isNaN(AdvAmt) || AdvAmt == "")
                AdvAmt = 0;

            var CancellationAmount = 0;

            var TDSAmount = 0;
            if ($('#txtTDSAmount').is(':visible')) {
                TDSAmount = $('#txtTDSAmount').val();
                if (isNaN(TDSAmount) || TDSAmount == "")
                    TDSAmount = 0;
            }

            var WriteOff = 0;
            if ($('#txtWriteOff').is(':visible')) {
                WriteOff = $('#txtWriteOff').val();
                if (isNaN(WriteOff) || WriteOff == "")
                    WriteOff = 0;
            }

            var totalAmt = parseFloat(AdvAmt) + parseFloat(CancellationAmount) + parseFloat(TDSAmount) + parseFloat(WriteOff);


            
            if (jQuery('#rdbtypeOfPayment input[type=radio]:checked').val() == "1")
                $('#lblBalanceAmount').text(precise_round(parseFloat($('#lblPendingInvoiceAmt').text()) - parseFloat(totalAmt), '<%=Resources.Resource.BaseCurrencyRound%>'));

            
            else if (jQuery('#rdbtypeOfPayment input[type=radio]:checked').val() == 2)
               $('#lblBalanceAmount').text(precise_round(parseFloat($('#lblPendingInvoiceAmt').text()) + parseFloat(totalAmt), '<%=Resources.Resource.BaseCurrencyRound%>'));
        }
    </script>
</asp:Content>

