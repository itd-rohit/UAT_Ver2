<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PettyCashTransfer.aspx.cs" Inherits="Design_PettyCash_PettyCashTransfer" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" >
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Transfer</b>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                </div>
                <div class="col-md-3 Purchaseheader">
                    <label class="pull-left">Total Balance</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 Purchaseheader">
                    <asp:Label ID="lblbalance" runat="server" Text="0"></asp:Label>
                </div>
                <div class="col-md-3 Purchaseheader">
                    <label class="pull-left">Total Pending</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 Purchaseheader">
                    <asp:Label ID="lblpending" runat="server" Text="0"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">

                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="lstCentre" runat="server" onchange="BindBalance($(this).val())" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Payment Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="paymentmode" runat="server" onchange="paymenttypeResult(this);">
                        <asp:ListItem Value="1">Cash</asp:ListItem>
                        <asp:ListItem Value="2">Cheque</asp:ListItem>
                        <asp:ListItem Value="3">Credit Card</asp:ListItem>
                        <asp:ListItem Value="4">Debit Card</asp:ListItem>
                        <asp:ListItem Value="5">NEFT</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Remarks</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <div id="divremarks" style="color: red;"></div>
                </div>
            </div>
            <div class="row">

                <div class="col-md-2 bank" style="display: none">
                    <label class="pull-left">Bank</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 bank" style="display: none">
                    <asp:DropDownList ID="bankname" runat="server" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3 refrence" style="display: none">
                    <label class="pull-left">
                        <asp:Label ID="lblpaymode" runat="server" Text="ref"></asp:Label></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 refrence" style="display: none">
                    <asp:TextBox ID="txtcardno" runat="server" MaxLength="30" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-2 chkdate" style="display: none">
                    Cheque Date
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 chkdate" style="display: none">
                    <asp:TextBox ID="Chequedate" runat="server" ReadOnly="true" CssClass="requiredField" />
                    <cc1:CalendarExtender ID="calCheckDate" runat="server" TargetControlID="Chequedate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">

                <div class="col-md-2">
                    <label class="pull-left">Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" CssClass="requiredField" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy" OnClientDateSelectionChanged="checkDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtamount" runat="server" MaxLength="50" onkeyup="showme(this);" CssClass="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbAmount" runat="server" ValidChars="0123456789" TargetControlID="txtamount"></cc1:FilteredTextBoxExtender>
                    <asp:Label ID="lblFileName" runat="server" Style="display: none"></asp:Label>
                </div>
                <div class="col-md-3">
                    <input type="checkbox" id="chkadjustment" />Adjustment
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Receipt</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <a href="javascript:void(0)" onclick="showuploadbox();">Upload</a>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="butsave" class="searchbutton" value="Save" onclick="savedata()" />
            <input type="button" id="btnview" class="searchbutton" value="ViewPendingExpenses" onclick="existingdata()" />
        </div>
    </div>
    <asp:Button ID="hidetest" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash" runat="server" TargetControlID="hidetest" BehaviorID="modalpettycash" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel" CancelControlID="pettycan">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel" Style="display: none; width: 1000px; height: 430px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            <div class="content">
                <div class="Purchaseheader">
                    Pending Expense For Approval
                </div>
            </div>
            <table id="pettyexpense" style="width: 100%; border-collapse: collapse; text-align: center; height: 40px;">
                <tr>
                    <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                    <td class="GridViewHeaderStyle" style="width: 100px;">Center code</td>
                    <td class="GridViewHeaderStyle" style="width: 120px;">Center Name</td>

                    <td class="GridViewHeaderStyle" style="width: 80px;">Amount</td>
                    <td class="GridViewHeaderStyle" style="width: 80px;">Date</td>
                    <td class="GridViewHeaderStyle" style="width: 120px;">CreatedBy</td>
                    <td class="GridViewHeaderStyle" style="width: 100px;">Type</td>
                    <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                    <td class="GridViewHeaderStyle" style="width: 120px;">Invoice No.</td>
                    <td class="GridViewHeaderStyle" style="width: 100px;">Invoice Date</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">Bank</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">CardNo</td>
                    <td class="GridViewHeaderStyle" style="width: 120px;">ApprovedBy</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">ApprovedDate</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">Receipt</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">Expanses Type</td>
                    <td class="GridViewHeaderStyle" style="width: 90px;">Narration</td>
                    <td class="GridViewHeaderStyle" style="width: 60px;">Action</td>
                </tr>
            </table>
        </div>
        <div style="text-align: center;">
            <input id="pettycan" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>

    <asp:Button ID="butpettyaccept" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash1" runat="server" TargetControlID="butpettyaccept" BehaviorID="modalpettycash1" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" CancelControlID="btnacceptCancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel1" Style="display: none; width: 350px; height: 130px;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls">
            <table style="width: 100%; border-collapse: collapse">
                <tbody style="display: inline-block; margin-top: 33px; margin-left: 33px;">
                    <tr>

                        <td style="width: 100px; text-align: right">Remark:</td>
                        <td style="width: 233px; text-align: left">
                            <asp:TextBox ID="txtRemark" runat="server" MaxLength="200"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="text-align: center;">
                                <input id="btnaccept" type="button" value="Submit" onclick="Accept()" class="searchbutton" />
                                <input id="btnacceptCancel" type="button" class="searchbutton" value="Cancel" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="labacceptid" runat="server"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </asp:Panel>

    <asp:Button ID="butpettyreject" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalpettycash2" runat="server" TargetControlID="butpettyreject" BehaviorID="modalpettycash2" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" CancelControlID="butrejectcancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" Style="display: none; width: 350px; height: 130px;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls">
            <table style="width: 100%; border-collapse: collapse">
                <tbody style="display: inline-block; margin-top: 33px; margin-left: 33px;">
                    <tr>

                        <td style="width: 100px; text-align: right">Remark:</td>
                        <td style="width: 233px; text-align: left">
                            <asp:TextBox ID="txtcancelremark" runat="server" MaxLength="200"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="text-align: center;">
                                <input id="butreject" type="button" value="Submit" onclick="Reject()" class="searchbutton" />
                                <input id="butrejectcancel" type="button" class="searchbutton" value="Cancel" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblrejectid" runat="server"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function checkDate(sender, args) {
            if ($('#paymentmode option:Selected').val() == "4") {
                var previoustwoday = new Date();
                previoustwoday.setDate(previoustwoday.getDate() - 3);
                if (sender._selectedDate < previoustwoday) {
                    toast("Error", "You can select only two days back date!");
                    sender._selectedDate = new Date();
                    // set the date back to the current date
                    sender._textbox.set_Value(sender._selectedDate.format(sender._format))
                }
            }
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
            bindbank();
        });

        function paymenttypeResult(ctrl) {
            if (ctrl.value == "2") {
                $('.bank').css('display', '');
                $('.refrence').css('display', '');
                $('.chkdate').css('display', '');
                $('#lblpaymode').text('Cheque No.');
            }
            else if (ctrl.value == "3" || ctrl.value == "4") {
                $('.bank').css('display', '');
                $('.refrence').css('display', '');
                $('.chkdate').css('display', 'none');
                $('#lblpaymode').text('Card No.');
            }
            else if (ctrl.value == "5") {
                $('.bank').css('display', '');
                $('.refrence').css('display', '');
                $('.chkdate').css('display', 'none');
                $('#lblpaymode').text('Refrence No.');
            }
            else {
                $('.bank').css('display', 'none');
                $('.refrence').css('display', 'none');
                $('.chkdate').css('display', 'none');
            }
        }

        function bindCentre(state) {
            jQuery('#lstCentre option').remove();
            if (state != "") {
                serverCall('PettyCashTransfer.aspx/bindCentre', { State: state }, function (response) {
                    jQuery("#lstCentre").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Centreid', textField: 'centre', isSearchAble: true });
                });

            }
        }
        function bindbank() {
            serverCall('PettyCashTransfer.aspx/bindbank', {}, function (response) {
                jQuery("#bankname").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'bank_id', textField: 'bankname', isSearchAble: true });
            });
        }
        function savedata() {
            if ($('#lstCentre').val() == "0") {
                toast("Error", "Please Select Centre ");
                $('#lstCentre').focus();
                return;
            }
            if ($('#paymentmode').val() == "") {
                toast("Error", "Please Select Payment Mode");
                $('#paymentmode').focus();
                return;
            }
            if ($('#paymentmode').val() == "2" || $('#paymentmode').val() == "3" || $('#paymentmode').val() == "4" || $('#paymentmode').val() == "5") {
                if ($('#bankname').val() == "0") {
                    toast("Error", "Please Select Bank");
                    $('#bankname').focus();
                    return;
                }
                if ($.trim($('#txtcardno').val()) == "") {
                    toast("Error", "".concat("Please Enter ", $('#lblpaymode').text()));
                    $('#txtcardno').focus();
                    return;
                }
                if ($('#paymentmode').val() == "2" && $.trim($('#Chequedate').val()) == "") {
                    toast("Error", "Please Enter Cheque Date");
                    $('#Chequedate').focus();
                    return;
                }
            }
            if ($('#txtentrydatefrom').val() == "") {
                toast("Error", "Please Enter Date");
                $('#txtentrydatefrom').focus();
                return;
            }
            if ($('#txtamount').val() == "") {
                toast("Error", "Please Enter Amount ");
                $('#txtamount').focus();
                return;
            }

            var temp = [];
            var divide = $('#lstCentre').val();
            temp = divide.split('#');
            var dataIm = new Array();
            var obj = new Object();
            obj.Center = temp[0];
            obj.CenterName = $('#lstCentre option:Selected').text();
            obj.CenterCode = temp[1];
            obj.Remarks = temp[2];
            obj.Amount = $('#txtamount').val();
            obj.PaymentMode = $('#paymentmode option:Selected').text();
            if ($('#bankname option:Selected').val() == "0") {
                obj.BankName = "";
            }
            else {
                obj.BankName = $('#bankname option:Selected').text();
            }
            obj.ChequeDate = $('#Chequedate').val();
            obj.CardNo = $('#txtcardno').val();
            obj.Date = $('#txtentrydatefrom').val();
            obj.Adjustment = $('#chkadjustment').is(":checked") ? 1 : 0;
            obj.Reciept = $('#lblFileName').text();
            dataIm.push(obj);
            serverCall('PettyCashTransfer.aspx/Savepettycash', { Allitem: dataIm }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $('#btnsave').attr('disabled', false).val("Save");
                    clearForm();
                    toast("Success", $responseData.response);
                    bindCentre('0');
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function existingdata() {
            if ($('#lstCentre').val() == "0") {
                toast("Error", "Please Select Centre");
                $('#lstCentre').focus();
                return;
            }
            var temp = [];
            var divide = $('#lstCentre').val();
            temp = divide.split('#');
            $('#pettyexpense tr').slice(1).remove();
            serverCall('PettyCashTransfer.aspx/SearchRecords', { Centreid: temp[0] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    $find("modalpettycash").hide();
                }
                else {

                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr style='background-color:"); $mydata.push(ItemData[i].rowColor); $mydata.push(";' id='"); $mydata.push(ItemData[i].id); $mydata.push("'>");
                        $mydata.push('<td >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].centrecode); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].centre); $mydata.push('</td>');

                        $mydata.push('<td style="text-align:right">'); $mydata.push(Math.abs(ItemData[i].amount)); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].DATE); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].createby); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].TYPE); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].paymentmode); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].InvoiceNo); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].InvoiceDate); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].Bank); $mydata.push('</td>');
                        if (ItemData[i].CardNo == "0") {
                            $mydata.push('<td></td>');
                        }
                        else {
                            $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].CardNo); $mydata.push('</td>');
                        }
                        if (ItemData[i].ApprovedBy == null) {
                            $mydata.push('<td></td>');
                        }
                        else {
                            $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].ApprovedBy); $mydata.push('</td>');
                        }
                        if (ItemData[i].ApprovedDate == null) {
                            $mydata.push('<td></td>');
                        }
                        else {
                            $mydata.push('<td>'); $mydata.push(ItemData[i].ApprovedDate); $mydata.push('</td>');
                        }
                        $mydata.push('<td style="text-align:left"><a href="'); $mydata.push(ItemData[i].Filename); $mydata.push('" target="_blank" > View</a></td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].ExpansesType); $mydata.push('</td>');
                        $mydata.push('<td style="text-align:left">'); $mydata.push(ItemData[i].Narration); $mydata.push('</td>');
                        if (ItemData[i].IsApproved == '0') {
                            $mydata.push('<td style="text-align:left"><input type="button" id="accept" class="searchbutton" value="Accept" onclick="Accept('); $mydata.push(ItemData[i].id); $mydata.push(')" />&nbsp;&nbsp;<input type="button" id="reject" class="resetbutton" value="Reject" onclick="CancelRemark('); $mydata.push(ItemData[i].id); $mydata.push(')" /></td>');
                        }
                        else {
                            $mydata.push('<td></td>');
                        }
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#pettyexpense').append($mydata);
                        $find("modalpettycash").show();
                    }
                }
            });
        }
        function Remark(id) {
            $('#labacceptid').val(id);
            $find("modalpettycash1").show();
        }
        function CancelRemark(id) {
            $('#lblrejectid').val(id);
            $find("modalpettycash2").show();
        }
        function Accept(id) {
            var aceptid = id;
            if (id != "") {
                serverCall('PettyCashTransfer.aspx/acceptexpense', { ID: aceptid }, function (response) {
                    var save = response;
                    if (save.split('#')[0] == "1") {
                        existingdata();
                        $('#txtRemark').val('');
                        $find("modalpettycash1").hide();
                        toast("Success", "Data Accept successfully");
                    }
                });
            }
        }
        function Reject() {
            var cancelremark = $('#txtcancelremark').val();
            var id = $('#lblrejectid').val();
            if (id != "") {
                serverCall('PettyCashTransfer.aspx/rejectexpense', { ID: id, Cancelremark: cancelremark }, function (response) {
                    if (response.split('#')[0] == "1") {
                        existingdata();
                        $('#txtcancelremark').val('');
                        $find("modalpettycash2").hide();
                        toast("Success", "Data Reject Successfully");
                    }
                });
            }
        }
        function showme(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
        }
        function clearForm() {
            $('#bankname').val('0');
            $('#Chequedate,#txtcardno,#txtentrydatefrom,#txtamount').val('');
            $('.bank,.chkdate,.refrence').hide();
            $('#lstCentre').html('');
            $('#paymentmode').val('1');
            $('#lblFileName').text('');
        }
    </script>
    <script type="text/javascript">
        function showuploadbox() {
            var FileName = "";
            if ($('#lblFileName').text() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#lblFileName').text();
            }
            $('#lblFileName').text(FileName);
            fancyBoxOpen('UploadExpncesDoc.aspx?FileName=' + FileName);
        }
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 796,
                maxHeight: 300,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );
        }
        function BindBalance(centerid) {
            var selectedcenterid = centerid.split('#')[0];
            $('#divremarks').html(centerid.split('#')[2]);
            serverCall('PettyCashTransfer.aspx/BindBalance', { centerid: selectedcenterid }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                $('#lblbalance').text(ItemData[0].total);
                $('#lblpending').text(ItemData[0].pending);
            });
        }
    </script>
</asp:Content>