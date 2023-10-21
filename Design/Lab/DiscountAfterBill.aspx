<%@ Page MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" Language="C#"  AutoEventWireup="true" CodeFile="DiscountAfterBill.aspx.cs" Inherits="Design_EDP_DiscountAfterBill" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">



  
   
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <%--	<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>	

     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>--%>
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">

    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>   
    
    	
  
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        <Services>
            <Ajax:ServiceReference Path="../Lab/Services/LabBooking.asmx" />
        </Services>
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                  <b> Discount After Bill</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-6">
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Visit No.</b>   </label>
                    <b class="pull-right">:</b></div>
                     <div class="col-md-4">

                    <asp:TextBox ID="txtLabNo" runat="server"  MaxLength="15"  class="requiredField" type="text" data-title="Enter Visit No." autocomplete="off"></asp:TextBox>

                </div>
                <div class="col-md-3">
                    <input type="button" id="ssbutton" value="Search" class="searchbutton" onclick="searchdata('')" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Visit No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblLabNo" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Lab ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblLabID" runat="server" CssClass="PatientLabel"></asp:Label>
                   <asp:Label ID="lblCentreID" runat="server" CssClass="PatientLabel" style="display:none"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">MR No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblPatientID" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Patient Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblName" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Age/Gender</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblAgeGender" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Work Order Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblWorkOrderDate" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Bill Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblBillAmt" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:Label ID="lblPanelName" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                
                <div class="col-md-5">
                   
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Total Discount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblTotalDiscount" runat="server" Style="text-align: right;" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Mobile</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblMobile" runat="server" Style="text-align: right;" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Email</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblEmail" runat="server" Style="text-align: right;" CssClass="PatientLabel"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Net Bill Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblNetBillAmt" runat="server" CssClass="PatientLabel" Style="text-align: right;"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Paid Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblTotalPaidAmt" runat="server" Style="text-align: right;" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Due Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblDueAmt" runat="server" Style="text-align: right;" Font-Bold="true" ForeColor="Red" CssClass="PatientLabel"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Total Disc.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblTotalDiscGivenAmount" runat="server" CssClass="PatientLabel" Font-Bold="true" />
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                    <input type="button" id="btnRemoveDiscount" value="Remove Discount" class="searchbutton" onclick="removeDiscount();"  style="display:none"  />
                </div>
            </div>
            <div class="divDiscount" style="text-align: center;display:none">
                <div class="Purchaseheader">
                    Discount
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Discount Amt.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAdditionalDiscountAmt" runat="server" placeholder="Disc Amt" AutoCompleteType="Disabled"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbDiscAmt" runat="server" FilterType="Numbers" TargetControlID="txtAdditionalDiscountAmt">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Discount Per.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAdditionalDiscInPer" runat="server" placeholder="Disc Per" AutoCompleteType="Disabled"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbDiscPer" runat="server" FilterType="Numbers" TargetControlID="txtAdditionalDiscInPer">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Discount By
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlApproveBy" runat="server" CssClass="requiredField"></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Discount Reason
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">

                        <asp:TextBox ID="txtDiscReason" runat="server"  MaxLength="150" placeholder="Discount Reason" class="requiredField" Style="text-transform: uppercase;"></asp:TextBox>

                    </div>
                </div>
                <div class="row"  style="display:none">
                    <div class="col-md-3">
                        Total Amount:
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtTotalAmount" runat="server"></asp:TextBox>
                        </div>
                    <div class="col-md-3">
                        Paid Amount:
                    </div>
                     <div class="col-md-5">
                         <asp:TextBox ID="txtPaidAmount" runat="server"></asp:TextBox>
                         </div>
                    <div class="col-md-3">
                        Due Amount:<asp:TextBox ID="txtDueAmount" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <span id="amtCount" style="font-weight: bold;"></span>
                        <asp:Label ID="lblDisAmt" runat="server" CssClass="PatientLabel" />
                    </div>
                </div>
            </div>
        </div>
    <div class="POuter_Box_Inventory divDiscount" style="display:none">
        <div class="Purchaseheader">
            Prescribed Investigation
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="content" style="overflow: scroll; height: 130px;">
                    <table id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle"  style="text-align: center;">#</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center; display: none;">Package</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Test Code</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Test Name</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Quantity</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Rate</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Discount</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Amount</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="POuter_Box_Inventory divDiscount" style="display:none">
        <div class="row" style="text-align: center;">
            <div class="col-md-24">
                <input type="button" id="btnSave" value="Save" class="searchbutton" onclick="saveData();" />
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
        var ItemwiseDisc = 0;
        var isPackage = 0;
        var tempDiscTotal = 0;
        var tmpAmt = 0;
        function searchdata(LedgerTransactionNo) {
            $('#ddlApproveBy').val('0');
            tmpAmt = 0;
            $('#tb_ItemList tr').slice(1).remove();
            LabNo = (LedgerTransactionNo == "") ? $.trim($('#txtLabNo').val()) : LedgerTransactionNo;
            if (LabNo == "") {
                toast("Info", "Please Enter Visit No.", "");
                $('#txtLabNo').focus();
                $('#btnSave,.divDiscount').hide();
                $('.PatientLabel').html('');
                return;
            }
            serverCall('DiscountAfterBill.aspx/searchData', { LabNo: LabNo }, function (response) {
                var TestData = JSON.parse(response);
                if (TestData == "-1")
                {

                    toast("Error", "Time is expired . You cannot  Do Discount After Bill..!", "");
                    $('#btnSave,.divDiscount').hide();
                    return false;
                }
                else  if (TestData.length != 0) {
                    clearAllLabel();
                    clearAllTextBox();
                    ItemwiseDisc = 0;
					if (TestData[0].BillTimeDiff > 10080 && '<%=Session["RoleID"]%>' == '2') {
                       // $("#lblMsg").text('You can Edit Patient within 30 minutes of Billing...!');
                        toast("Info", "You can Edit  within 7 Days of Billing...!", "");
                        $('#btnSave,.divDiscount').hide();
                        return false;
                    }
					else
					{
					
                    // Patient Personal Details
                    $('#lblLabNo').html(TestData[0].LedgerTransactionNo);
                    $('#lblLabID').html(TestData[0].LedgerTransactionID);
                    $('#lblCentreID').html(TestData[0].CentreID);
                    $('#lblPatientID').html(TestData[0].Patient_ID);
                    $('#lblName').html(TestData[0].PName);
                    $('#lblPanelName').html(TestData[0].PanelName);
                    $('#lblMobile').html(TestData[0].Mobile);
                    $('#lblEmail').html(TestData[0].Email);
                    $('#lblAgeGender').html(TestData[0].Age + ' ' + TestData[0].Gender);
                    $('#lblWorkOrderDate').html(TestData[0].DATE);
                    
                    //Amount Related Details
                    $('#lblBillAmt').html(precise_round(parseFloat(TestData[0].GrossAmount),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#lblTotalDiscount').html(precise_round(parseFloat(TestData[0].DiscountOnTotal),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#lblNetBillAmt').html(precise_round(parseFloat(TestData[0].NetAmount),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#lblTotalPaidAmt').html(precise_round(parseFloat(TestData[0].Adjustment),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#lblDueAmt').html(precise_round(parseFloat(parseFloat(TestData[0].NetAmount) - parseFloat(TestData[0].Adjustment)), '<%=Resources.Resource.BaseCurrencyRound%>'));

                    //Amount To Save
                    $('#txtTotalAmount').val(parseFloat(TestData[0].NetAmount));
                    $('#txtPaidAmount').val(parseFloat(TestData[0].Adjustment));
                    $('#txtDueAmount').val(parseFloat(parseFloat(TestData[0].NetAmount) - parseFloat(TestData[0].Adjustment)));
                    $('#amtCount').html(precise_round(parseFloat(TestData[0].GrossAmount),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#lblDisAmt').html(precise_round(parseFloat(TestData[0].DiscountOnTotal), '<%=Resources.Resource.BaseCurrencyRound%>'));
                    if (TestData[0].DiscountApprovedByID != "0") {
                        $('#ddlApproveBy option').each(function () {
                            if (this.value != "0") {
                                if (this.value.split('#')[0] == TestData[0].DiscountApprovedByID) {
                                    $("#ddlApproveBy").find('option[value="' + this.value + '"]').prop('selected', true);
                                }
                            }
                        });
                    }
                    $('#txtDiscReason').val(TestData[0].DiscountReason);
                    //Investigation Table
                    for (var i = 0; i <= TestData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr id='");
                        $mydata.push(TestData[i].ItemId); $mydata.push("'>");
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdIsPackage" style="display:none;">'); $mydata.push(TestData[i].IsPackage); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(TestData[i].ItemCode); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(TestData[i].ItemName); $mydata.push('</td>');
                        
                        $mydata.push('<td id="tdBaseRate" style="font-weight:bold;text-align: center;display:none;">'); $mydata.push(TestData[i].baserate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); $mydata.push(TestData[i].Quantity); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;" id="tdRate">'); $mydata.push(TestData[i].Rate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;"> <input id="txtDisc" type="text" style="text-align: center;" onkeyup="$setitemwisediscount(this);" value="');
                        $mydata.push(TestData[i].DiscountAmt)
                          
                        
                        $mydata.push('"/></td>');
                        if (parseFloat(TestData[i].DiscountAmt) > 0) {
                            ItemwiseDisc = 1;
                            tempDiscTotal += parseFloat(TestData[i].DiscountAmt);
                        }
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;"><input type="text" style="text-align: center;"  id="txtNetAmt" disabled="disabled" value=" ');
                        $mydata.push(TestData[i].Amount);
                        $mydata.push('"/></td></tr>');
                        $mydata = $mydata.join(" ");
                        $('#tb_ItemList').append($mydata);
                        if (TestData[i].IsPackage == '1') {
                            isPackage = 1;
                        }
                    }
                    $('#lblTotalDiscGivenAmount').html(precise_round(parseFloat(TestData[0].DiscountOnTotal),'<%=Resources.Resource.BaseCurrencyRound%>'));
                    $("#btnRemoveDiscount").attr('disabled', false);
                    if (precise_round(parseFloat(TestData[0].DiscountOnTotal),'<%=Resources.Resource.BaseCurrencyRound%>') > 0) {
                        $('#btnSave').hide();
                        $("#ddlApproveBy").attr('disabled', true);
                        $("input[type=text]").attr('disabled', true);
                        $('#btnRemoveDiscount,.divDiscount').show();
                    }
                    else {
                        //Show Save Button
                        $('#btnSave,.divDiscount').show();
                        $("#ddlApproveBy").removeAttr('disabled');
                        $("input[type=text]").removeAttr('disabled');
                        $('#btnRemoveDiscount').hide();
                    }
                    $("#txtLabNo").attr('disabled', false);
					}
                }
                else {
                    clearAllLabel();
                    clearAllTextBox();
                    toast("Error", "Record Not Found", "");
                    $('#btnSave,.divDiscount').hide();
                    return false;
                }
            });
        }
        function clearAllTextBox() {
            $(":text").val('');
        }
        function clearAllLabel() {
            $('.PatientLabel').html('');
        }
        $(function () {
            $("#txtAdditionalDiscountAmt").keyup(
        function (e) {
            var prevDiscAmt = parseFloat($('#lblTotalDiscount').html());
            if (ItemwiseDisc == 1) {
                toast("Error", "Item Wise Discount Amount already Given", "");
                $('#txtAdditionalDiscountAmt').val('');
                return;
            }
            var key = (e.keyCode ? e.keyCode : e.charCode);
            if (key != 9) {
                if (isNaN($('#txtAdditionalDiscInPer').val() / 1) == true) {
                    return;
                }
                if ($('#txtAdditionalDiscInPer').val().length > 0) {
                    if ($('#txtAdditionalDiscInPer').val() != "0") {
                        toast("Error", "Discount Percent already Given", "");
                        $('#txtAdditionalDiscountAmt').val('');
                        return;
                    }
                    else {
                        $('#txtAdditionalDiscInPer').val('');
                    }
                }
                var total = parseFloat($('#amtCount').html());
                var disper = parseFloat($('#txtAdditionalDiscountAmt').val());
                if (disper > total) {
                    toast("Error", "Discount Amount can't greater then total amount", "");
                    var final = 0;
                    $('#txtTotalAmount').val(final);
                    $('#txtAdditionalDiscountAmt').val(total);
                    $('#lblDisAmt').text(total);
                    showdue();
                    return;
                }
                if (isNaN(disper / 1) == true) {
                    $('#txtTotalAmount').val(total);
                    $('#lblDisAmt').text(prevDiscAmt);
                    showdue();
                    return;
                }
                var final = total - disper;
                ItemwiseDisc = 0;
                $('#txtTotalAmount').val(final);
                $('#lblDisAmt').text(disper);
                showdue();
            }
        });
        });
        $(function () {
            $('#btnSave').hide();
            $("#txtAdditionalDiscInPer").keyup(
                function (e) {
                    var prevDiscAmt = parseFloat($('#lblTotalDiscount').html());
                    if (ItemwiseDisc == 1) {
                        toast("Error", "Item Wise Discount Amount already Given", "");
                        $('#txtAdditionalDiscInPer').val('');
                        return;
                    }
                    var ddlPer = $('#ddlApproveBy').val();
                    if (ddlPer.trim() == '0') {
                        toast("Error", "Please Select Discount ApprovedBy", "");
                        $('#txtAdditionalDiscInPer').val('');
                        return;
                    }
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key != 9) {
                        if (isNaN($('#txtAdditionalDiscInPer').val() / 1) == true) {
                            return;
                        }
                        if ($('#txtAdditionalDiscountAmt').val().length > 0 && $('#txtAdditionalDiscountAmt').val() >= 0) {
                            toast("Error", "Discount Amount already Given", "");
                            $('#txtAdditionalDiscInPer').val('');
                            return;
                        }
                        var total = parseFloat($('#amtCount').html());
                        var disper = parseFloat($('#txtAdditionalDiscInPer').val());
                        if (disper > parseFloat($('#ddlApproveBy').val().split('#')[1])) {
                            toast("Error", "Discount Percent Limit Must Be " + $('#ddlApproveBy').val().split('#')[1] + " %", "");
                            var final = 0;
                            $('#txtTotalAmount').val(final);
                            $('#txtAdditionalDiscInPer').val('');
                            $('#lblDisAmt').text(prevDiscAmt);
                            showdue();
                            return;
                        }
                        if (isNaN(disper / 1) == true) {
                            $('#txtTotalAmount').val(total);
                            $('#lblDisAmt').text(prevDiscAmt);
                            showdue();
                            return;
                        }
                        var disval = (total * disper) / 100;
                        var final = total - disval;
                        ItemwiseDisc = 0;
                        $('#txtTotalAmount').val(final);
                        $('#lblDisAmt').text(disval);
                        showdue();
                    }
                });
        });
        $(function () {
            $(".checkSpecialCharater").keypress(function (e) {
                var keynum
                var keychar
                var numcheck
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                formatBox = document.getElementById($(this).val().id);
                strLen = $(this).val().length;
                strVal = $(this).val();
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                    ((e.keyCode) ? e.keyCode :
                                    ((e.which) ? e.which : 0));
                    if ((charCode == 45)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '-');
                            if (hasDec)
                                return false;
                        }
                    }
                    if (charCode == 46) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                //List of special characters you want to restrict
                if (keychar == "#" || keychar == "/" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                    return false;
                else
                    return true;
            });
        });
        var TotalDiscountAmount = 0;
        function patientlabinvestigationopd() {
            var dataPLO = new Array();
            var rowNum = 1;
            var amtValue = 0;
            TotalDiscountAmount = 0;
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    var objPLO = new Object();
                    
                    objPLO.ItemwiseDisc = ItemwiseDisc;
                    objPLO.IsPackage = $(this).closest("tr").find("#tdIsPackage").html();
                    
                    objPLO.ItemId = $(this).closest("tr").attr("id");
                    objPLO.Rate = parseFloat($(this).closest("tr").find("#tdRate").html());
                    if ($('#lblDisAmt').text() != "" && $('#lblDisAmt').text() != "0") {
                        if (Number($(this).closest("tr").find("#txtDisc").val()) > 0 && ItemwiseDisc == "1") {
                            objPLO.DiscountAmt = parseInt($(this).closest("tr").find("#txtDisc").val());
                            objPLO.Amount = parseFloat($(this).closest("tr").find("#tdRate").html()) - parseInt(objPLO.DiscountAmt);
                            if ($('#ddlApproveBy').val().split('#')[4] == "0") {
                                if (Number($(this).closest("tr").find("#tdBaseRate").html()) > 0 && objPLO.Amount < Number($(this).closest("tr").find("#tdBaseRate").html())) {
                                    dataPLO = new Array();
                                    toast("Error", "Base Limit Exceed", "");
                                    return false;
                                }
                            }
                        }
                        else if (ItemwiseDisc == "0") {
                            if ($('#ddlApproveBy').val().split('#')[4] == "1") {
                                var discper = (parseFloat($('#lblDisAmt').text()) * 100) / parseFloat($('#amtCount').html())
                                var amt = (parseFloat($(this).closest("tr").find("#tdRate").html()) * parseFloat(discper)) / 100;
                                if ($('#tb_ItemList tr').length - 1 == rowNum) {
                                    var amtSecondLast = parseFloat(amtValue).toFixed(0);
                                    var amtDiscfinalAmt = parseFloat($('#lblDisAmt').text()).toFixed(0);
                                    var amtDiff = parseFloat(amtDiscfinalAmt) - parseFloat(amtSecondLast);
                                    objPLO.DiscountAmt = parseInt(parseFloat(amtDiff).toFixed(0));
                                }
                                else {
                                    objPLO.DiscountAmt = parseInt(parseFloat(amt).toFixed(0));
                                }
                                objPLO.Amount = parseFloat($(this).closest("tr").find("#tdRate").html()) - parseInt(parseFloat(amt).toFixed(0));
                                amtValue += parseInt(parseFloat(amt).toFixed(0));
                            }
                            else {
                                var discper = (parseFloat($('#lblDisAmt').text()) * 100) / parseFloat($('#amtCount').html())
                                discper = Math.round(discper);
                                var amt = (parseFloat($(this).closest("tr").find("#tdRate").html()) * parseFloat(discper)) / 100;
                                var newamt = parseFloat($(this).closest("tr").find("#tdRate").html()) - parseInt(parseFloat(amt).toFixed(0));
                                if (Number($(this).closest("tr").find("#tdBaseRate").html()) > 0 && newamt < Number($(this).closest("tr").find("#tdBaseRate").html())) {
                                    newamt = Number($(this).closest("tr").find("#tdBaseRate").html());
                                    amt = Number($(this).closest("tr").find("#tdRate").html()) - newamt;
                                }
                                if ($('#tb_ItemList tr').length - 1 == rowNum) {
                                    var amtSecondLast = parseFloat(amtValue).toFixed(0);
                                    var amtDiscfinalAmt = parseFloat($('#lblDisAmt').text()).toFixed(0);
                                    var amtDiff = parseFloat(amtDiscfinalAmt) - parseFloat(amtSecondLast);
                                    var newamt1 = parseFloat($(this).closest("tr").find("#tdRate").html()) - parseInt(parseFloat(amtDiff).toFixed(0));
                                    if (Number($(this).closest("tr").find("#tdBaseRate").html()) > 0 && newamt1 < Number($(this).closest("tr").find("#tdBaseRate").html())) {
                                        dataPLO = new Array();
                                        toast("Error", "Base Limit Exceed", "");
                                        return false;
                                    }
                                    objPLO.DiscountAmt = parseInt(parseFloat(amtDiff).toFixed(0));
                                }
                                else {
                                    objPLO.DiscountAmt = parseInt(parseFloat(amt).toFixed(0));
                                }
                                objPLO.Amount = parseFloat($(this).closest("tr").find("#tdRate").html()) - parseInt(parseFloat(objPLO.DiscountAmt).toFixed(0));
                                amtValue += parseInt(parseFloat(amt).toFixed(0));
                            }
                            rowNum += 1;
                        }
                        else {
                            objPLO.Amount = parseFloat($(this).closest("tr").find("#tdRate").html());
                            objPLO.DiscountAmt = 0;
                        }
                    }
                    else {
                        objPLO.DiscountAmt = parseInt($(this).closest("tr").find("#txtDisc").val());
                        objPLO.Amount = $(this).closest("tr").find("#txtNetAmt").val();
                    }
                    TotalDiscountAmount += objPLO.DiscountAmt;
                    dataPLO.push(objPLO);
                }
            });
         return dataPLO;
     }
     function saveData() {
         var PLOData = patientlabinvestigationopd();
         if (PLOData == "")
             return;
         if (ItemwiseDisc == 0 && $('#txtAdditionalDiscountAmt').val() == '' && $('#txtAdditionalDiscInPer').val() == '') {
             TotalDiscountAmount = 0;
         }
         var DiscountID = "0";

         if (Number(TotalDiscountAmount) == 0 && ItemwiseDisc == 0) {
             toast("Error", "Please Provide Some Discount", "");
             return false;
         }
         if ($('#ddlApproveBy').val() == '0') {
             toast("Error", "Please Select Employee Wise Discount Approved By", "");
             $('#ddlApproveBy').focus();
                return false;
            }
            if (Number(TotalDiscountAmount) > 0) {
                var discpersetinmaster = $('#ddlApproveBy').val().split('#')[1];
                    var discpertotal = (parseFloat(TotalDiscountAmount) * 100) / parseFloat($('#amtCount').html());
                    if (Math.round(discpertotal) > Math.round(discpersetinmaster)) {
                        toast("Error", "Discount Percentage Limit Exceed \nMax Discount Should be: " + discpersetinmaster + "%", "");
                        $('#ddlApproveBy').focus();
                        return false;
                    }
                }
                if ($('#txtDiscReason').val() == '') {
                    toast("Error", "Please Enter Discount Reason !", "");
             return false;
         }
         var LabNo = $('#lblLabNo').html();
         var LabID = $('#lblLabID').html();
         var ApprovedByData = $('#ddlApproveBy').val() + "#" + $("#ddlApproveBy option:selected").text();
         var PrevBillAmount = $('#lblBillAmt').html();
         var PrevTotalDiscount = $('#lblTotalDiscount').html();
         var PrevNetBillAmount = $('#lblNetBillAmt').html();
         var PrevTotalPaidAmount = $('#lblTotalPaidAmt').html();
         var PrevDueAmount = $('#lblDueAmt').html();
         var CurrentDiscountOnTotal = $('#lblDisAmt').html();
         var CurrentDiscountOnPer = $('#txtAdditionalDiscInPer').val();
         var DiscountReason = $('#txtDiscReason').val();
         var DiscountType = "";
         if (ItemwiseDisc == 1) {
             DiscountType = "ItemWise";
         }
         else if ($('#txtAdditionalDiscountAmt').val() != '') {
             DiscountType = "DiscountAmount";
         }
         else if ($('#txtAdditionalDiscInPer').val() != '') {
             DiscountType = "DiscountPer";
         }
         else {
             DiscountType = "";
         }
         serverCall('DiscountAfterBill.aspx/saveData', { PLOData: PLOData, LabNo: LabNo, LabID: LabID, ApprovedByData: ApprovedByData, PrevBillAmount: PrevBillAmount, PrevTotalDiscount: PrevTotalDiscount, PrevNetBillAmount: PrevNetBillAmount, PrevTotalPaidAmount: PrevTotalPaidAmount, PrevDueAmount: PrevDueAmount, TotalDiscountAmount: TotalDiscountAmount, DiscountReason: DiscountReason, DiscountType: DiscountType, DiscountID: DiscountID, CentreID: $("#lblCentreID").text() }, function (response) {
         var $responseData = JSON.parse(response);
         if ($responseData.status) {
             clearAllTextBox();
             toast("Success", "Record Saved..!Discount After Bill Done.", "");
             confirmReceipt('Confirmation', 'Do you want to print Receipt', "1", $responseData);
             $('#btnSave').hide();
             tmpAmt = 0;
             $('#ddlApproveBy').prop('selectedIndex', 0);
             searchdata(LabNo);
             ItemwiseDisc = 0;
            }
            else {
                toast("Error", $responseData.ErrorMsg, "");
                tmpAmt = 0;
            }
            $modelUnBlockUI(function () { });
        });
    }
    function $setitemwisediscount(ctrl) {
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
        if ($('#txtAdditionalDiscountAmt').val().length > 0 && $('#txtAdditionalDiscountAmt').val() != 0) {
            toast("Error", "Discount Amount already Given", "");
            $(ctrl).val('0');
            return;
        }
        if ($('#txtAdditionalDiscInPer').val().length > 0 && $('#txtAdditionalDiscInPer').val() != 0) {
            toast("Error", "Discount Per already Given", "");
            $(ctrl).val('0');
            return;
        }
        var disc = Number($(ctrl).val());
        var rate = $(ctrl).closest("tr").find("#tdRate").text();
        if (parseFloat(disc) > parseFloat(rate)) {
            $(ctrl).val(rate);
            disc = rate;
        }
        $(ctrl).closest("tr").find("#txtNetAmt").val((parseFloat(rate) - parseFloat(disc)));
        $('#tb_ItemList tr').not(':first').each(function () {
            tmpAmt += parseFloat(($(this).find('#txtDisc').val() == '') ? 0 : $(this).find('#txtDisc').val());
        });
        if (tmpAmt > 0) {
            ItemwiseDisc = 1;
        }
        else {
            ItemwiseDisc = 0;
        }
        sumtotal();
        showToalDiscountGivenAmt();
    }
    function sumtotal() {
        var net = 0; totalamt = 0; disc = 0;
        $('#tb_ItemList tr').each(function () {
            var id = $(this).attr("id");
            if (id != "header") {
                totalamt = parseInt(totalamt) + parseFloat($(this).find('#tdRate').text());
                $('#amtCount').html(totalamt);
                net = net + parseFloat($(this).find("#txtNetAmt").val());
                $('#txtTotalAmount').val(net);
                    if (Number($(this).find("#txtDisc").val()) > 0)
                    { ItemwiseDisc = 1; }
                    disc = disc + Number($(this).find("#txtDisc").val());
                    showdue();
                }
            });

            if (disc == 0) {
                ItemwiseDisc = 0;
            }
            var count = $('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                $('#amtCount').html('0');
                $('#txtTotalAmount').val('0');
                temwisedic = 0;
                showdue();
            }
        }
        function showdue() {
            if ($('#txtTotalAmount').val() == "") {
                toast("Error", "Please Select Test", "");
                $('#txtPaidAmount').val('');
                return;
            }
            if ($('#txtPaidAmount').val() == "") {
                $('#txtDueAmount').val($('#txtTotalAmount').html());
                return;
            }
            var total = $('#txtTotalAmount').val();
            var paid = $('#txtPaidAmount').val();
            if (parseInt(paid) > parseInt(total)) {
                $('#txtDueAmount').val(parseFloat(total) - parseFloat(paid));
                return;
            }
            var due = parseInt(total) - parseInt(paid);
            $('#txtDueAmount').val(due);
        }
        function showToalDiscountGivenAmt() {
            var GrossAmt = parseFloat($('#lblBillAmt').html());
            var AfectedAmount = parseFloat($('#txtTotalAmount').val()); 
            $('#lblTotalDiscGivenAmount').html(precise_round(parseFloat(parseFloat(GrossAmt) - parseFloat(AfectedAmount)), '<%=Resources.Resource.BaseCurrencyRound%>'));
        }
        function removeDiscount() {
            if (parseFloat(($('#lblTotalDiscount').html())) <= 0) {
                toast("Error", "Unable to remove discount because discount not available", "");
                return;
            }
            if ($('#lblLabNo').html() == "") {
                toast("Error", "Patient details not available", "");
                return;
            }
            confirmReceipt('Confirmation', 'Are you sure to remove Discount',"0","");

            //if (confirm('Are you sure to remove Discount?') == false) {
            //    return;
            //}
           
        }
        function removeDiscountTypeWise() {
            $('#tb_ItemList tr').not(':first').each(function () {
                $(this).find('#txtDisc').val('0');
                $(this).find('#txtNetAmt').val($(this).find('td#tdRate').text());
                $(this).find('#txtDisc,#txtNetAmt').removeAttr('disabled');
            });
            ItemwiseDisc = 0;
            $('#lblTotalDiscGivenAmount').html("0");
        }
    </script>
    <script type="text/javascript">
        function confirmReceipt(title, content, action, $responseData) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: "".concat('<b>',content,'<b/>'),
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
                            if (action == "1")
                                PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
                            else
                                removeDisc();
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearActions();
                            }
                        },
                    }
                });

            }
            function clearActions() {           
            }
            function removeDisc()
            {
                serverCall('DiscountAfterBill.aspx/removeDiscount', { LabNo: $('#lblLabNo').html(), LabID: $('#lblLabID').html(), GrossAmount: $('#lblBillAmt').html(), DiscAmtRemove: $('#lblTotalDiscount').html() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", "Discount Removed Successfully", "");
                        confirmReceipt('Confirmation', 'Do you want to print Receipt', "1", $responseData);
                        clearAllLabel();
                        clearAllTextBox();
                        searchdata(LabNo);
                        ItemwiseDisc = 0; $('#btnSave').hide();
                       
                        
                    }
                    else {
                        toast("Error", $responseData.ErrorMsg, "");
                    }
                    $modelUnBlockUI(function () { });
                });
            }
        </script>
    </asp:Content>

