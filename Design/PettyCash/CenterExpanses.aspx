<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CenterExpanses.aspx.cs" Inherits="Design_PettyCash_CenterExpanses" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Center  Expenses Details</b>
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
            <div class="Purchaseheader">
                Expense Entry<asp:Label ID="lblFileName" runat="server" Style="display: none"></asp:Label>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Center</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcenter" runat="server" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtamount" runat="server" onkeyup="showme(this);" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <input type="checkbox" id="chkadjustment" /><strong style="color: green">Adjustment
                    </strong>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Payment Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtpaymentdate" runat="server" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtpaymentdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Invoice Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtinvoicedate" runat="server" />
                    <cc1:CalendarExtender ID="calinvoicedate" runat="server" TargetControlID="txtinvoicedate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Narration</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtnarration" runat="server" MaxLength="100" CssClass="requiredField" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Payment Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlmode" runat="server" onchange="paymentmode(this);" CssClass="requiredField">
                        <asp:ListItem Value="1" Text="Cash"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Cheque"></asp:ListItem>
                        <asp:ListItem Value="3" Text="Credit Card"></asp:ListItem>
                        <asp:ListItem Value="4" Text="Debit Card"></asp:ListItem>
                        <asp:ListItem Value="5" Text="NEFT"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Expense Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlexptype" runat="server" onchange="exptype(this);" CssClass="requiredField">
                    </asp:DropDownList>
                    <span class="expothertype" style="display: none">Type : </span>
                    <input type="text" id="expother" style="display: none;" onchange="BindExpance(this)" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtinvoice" runat="server" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 bank" style="display: none">
                    <label class="pull-left">Bank</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 bank" style="display: none">
                    <asp:DropDownList ID="ddlbank" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3 refrence" style="display: none">
                    <label class="pull-left">
                        <asp:Label ID="lblpaymode" runat="server" Text="ref"></asp:Label></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 refrence" style="display: none">
                    <asp:TextBox ID="txtrefnumber" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3 chkdate" style="display: none">
                    <label class="pull-left">Cheque Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 chkdate" style="display: none">
                    <asp:TextBox ID="txtcheckdate" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calCheckDate" runat="server" TargetControlID="txtcheckdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Reciept</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <a href="javascript:void(0)" onclick="showuploadbox();">Upload</a>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Remarks</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <b style="color: red;"><span id="spnremarks" runat="server"></span></b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Save" class="searchbutton" onclick="savedata();" id="btnsave" />
        </div>
    </div>
    <script type="text/javascript">
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
            if ($(ctrl).val() > 100000) {
                toast("Error", "Petty Cash Expances Should be Not More Than than 100000");
                $(ctrl).val('100000');
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
    </script>
    <script type="text/javascript">
        function savedata() {
            if ($('#ddlcenter').val() == "0") {
                toast("Error", "Please Select Center");
                $('#ddlcenter').focus();
                return false;
            }
            if ($('#txtamount').val() == "") {
                toast("Error", "Please Enter Amount");
                $('#txtamount').focus();
                return false;

            }
            if ($('#txtnarration').val() == "") {
                toast("Error", "Please Enter Narration");
                $('#txtnarration').focus();
                return false;
            }
            if ($('#ddlexptype').val() == "0") {
                toast("Error", "Please Select Expanse Type");
                $('#ddlexptype').focus();
                return false;
            }

            if ($('#ddlbank.ClientID option:selected').val == "0") {
                $('#ddlbank').text("");
            }
            // checkbox adjustment
            var Adjustment = "0";
            if ($('#chkadjustment').is(":checked")) {
                Adjustment = "1";
            }
            var Paymentlist = new Array();
            var objpay = new Object();
            objpay.centerid = $('#ddlcenter option:selected').val();
            objpay.center = $('#ddlcenter option:selected').text();
            objpay.amount = $('#txtamount').val();
            objpay.paydate = $('#txtpaymentdate').val();
            objpay.mode = $('#ddlmode option:selected').text();
            objpay.bankname = $('#ddlbank option:selected').text();
            objpay.refnumber = $('#txtrefnumber').val();
            objpay.checkdate = $('#txtcheckdate').val();
            objpay.invoiceno = $('#txtinvoice').val();
            objpay.invicedate = $('#txtinvoicedate').val();
            objpay.exptype = $('#ddlexptype option:selected').text();
            objpay.exptypeID = $('#ddlexptype option:selected').val();
            objpay.narration = $('#txtnarration').val();
            objpay.Remarks = "";
            objpay.Adjustment = Adjustment;
            objpay.Reciept = $('#lblFileName').text();
            Paymentlist.push(objpay);

            serverCall('CenterExpanses.aspx/Saveexpanses', { Paymentlist: Paymentlist }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                }
                else {
                    toast("Error", $responseData.response);
                }
                $('#btnsave').attr('disabled', false).val("Save");
                clearForm();
                BindBalance();
            });
        }

        function clearForm() {
            $('#ddlcenter,#ddlbank,#ddlmode,#ddlexptype').prop('selectedIndex', 0);
            $("#ddlcenter").chosen("destroy").chosen({ width: '100%' });
            $('#txtamount,#txtpaymentdate,#txtrefnumber,#txtcheckdate,#txtinvoice,#txtnarration,#txtinvoicedate,#expother').val('');
            $('#ddlexptype').show();
            $('#lblFileName').text('');
            $('.bank,.refrence,.chkdate,.expothertype,#expother').hide();
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
    </script>
    <script type="text/javascript">
        $(function () {
            BindBalance();
            $('.bank').css('display', 'none');
            $('.refrence').css('display', 'none');
            $('.chkdate').css('display', 'none');
            $("#ddlcenter").chosen("destroy").chosen({ width: '100%' });
        });
        function BindBalance() {
            serverCall('CenterExpanses.aspx/BindBalance', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var data = jQuery.parseJSON($responseData.response)
                    $('#lblbalance').text(data[0].total);
                    $('#lblpending').text(data[0].pending);
                }
                else {
                }
            });
        }
    </script>
    <script type="text/javascript">
        function paymentmode(ctrl) {
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
        function exptype(ctrl) {
            if ($('#ddlexptype option:selected').text() == "Other") {
                $("#expother").show();
                $(".expothertype").show();
            }
            else {
                $("#expother").hide();
                $(".expothertype").hide();
            }

        }
        function BindExpance(ctrl) {
            $('#ddlexptype option:selected').text(ctrl.value);
        }
    </script>
</asp:Content>