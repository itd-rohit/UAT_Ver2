<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="OpdRefund.aspx.cs" Inherits="Design_Lab_OpdRefund" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
   
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
   
    	
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>	

     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">

    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    </head><body>
    	
  <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="OPD Refund" Font-Size="16px" Font-Bold="true"></asp:Label><br />
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>

            <div class="row">
                <div class="col-md-6">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Visit No.  </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">

                    <asp:TextBox ID="txtLabNo" runat="server" class="requiredField" MaxLength="15" type="text" data-title="Enter Visit No." autocomplete="off"></asp:TextBox>

                </div>
                <div class="col-md-12">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata('BT')" />
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" id="pDetails" style="display: none">
            <div class="Purchaseheader">
                Patient Details&nbsp;
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">UHID No.  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="lblPatientID" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Patient Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblName" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Age / Gender</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="lblAge" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Paid Amount </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblAmtPaid" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Doctor  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="lblDoctor" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Net Amount</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblNetAmt" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Due Amount  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:Label ID="lblDueAmt" runat="server" CssClass="PatientLabel" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Visit No.  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblLabNoToSave" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                </div>
            </div>
            <div class="row" style="display: none">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-6">
                </div>
                <div class="col-md-4">
                    <b>Lab ID:</b>
                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblLabID" runat="server" CssClass="PatientLabel"></asp:Label>
                </div>
                <div class="col-md-4">
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Prescribed Investigation
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle" style="text-align: center;">#</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Item Code</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Item Name</td>
                            <td class="GridViewHeaderStyle" style="text-align: center; display: none;">Patient  Data</td>
                            <td class="GridViewHeaderStyle" style="text-align: center; display: none;">PlO Data</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Date</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Quantity</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Rate</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Discount</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Amount</td>

                            <td class="GridViewHeaderStyle" style="text-align: center;">Sample Status</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Select</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" id="payDetail" style="display: none">
            <div class="Purchaseheader">Payment Detail&nbsp;&nbsp;&nbsp;  </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Pay By  </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPayBy" runat="server">
                        <asp:ListItem Value="P">Patient</asp:ListItem>
                        <asp:ListItem Value="C">Corporate</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Currency</label>
                    <b class="pull-right">:</b></div>
                <div class="col-md-5">
                    <select id="ddlCurrency" disabled="disabled">
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">

                    <label class="pull-left">Payment Mode  </label>
                    <b class="pull-right">:</b>


                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPaymentMode" runat="server" onchange="showpaymentoption()" CssClass="requiredField"></asp:DropDownList>
                </div>

            </div>




            <div class="row" id="trPayment" style="display: none;">
                <div class="col-md-3">
                    <label class="pull-left">Cheque/Card No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCardNo" MaxLength="20" runat="server" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Cheque/Card Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCardDate" ReadOnly="true" runat="server" CssClass="requiredField"></asp:TextBox>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Bank Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBank" runat="server" CssClass="requiredField" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Refund Reason  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtReason" runat="server" MaxLength="150" CssClass="requiredField" type="text" data-title="Enter Refund Reason"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Refund By</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlRefundBy" runat="server" CssClass="requiredField">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-5"></div>
            </div>
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <input type="button" value="Save" class="searchbutton" onclick="savedata()" id="btnSave" />
                </div>
            </div>
        </div>

    <script type="text/javascript">
        function searchdata(callFrom) {

            $('#tb_ItemList tr').slice(1).remove();
            var LabNo = "";
            if (callFrom.trim() == 'BT') {
                LabNo = $('#txtLabNo').val();
            }
            else {
                LabNo = $('#lblLabNoToSave').html();
            }
            if (LabNo == "") {
                toast("Info", "Please Enter Visit No", "");
                $('#txtLabNo').focus();
                clearAllTextBox();
                return;
            }

            serverCall('OpdRefund.aspx/searchdata', { LabNo: LabNo }, function (response) {

                var TestData = JSON.parse(response);
                if (TestData == "-1") {
                    $('#btnSave,#pDetails,#payDetail').hide();
                    toast("Error", "Time is expired . You cannot Refund..!", "");
                    return false;
                }
                if (TestData.length != 0) {
                   // if (parseInt(TestData[0].Adjustment) == 0 && TestData[0].IsCredit == '0') {
                    //    clearAllTextBox();
                   //    toast("Info", "Amount Not Received in this Entry,So You Can Not Refund", "");
                   //     return false;
                 //   }
				 if (TestData[0].BillTimeDiff > 10080 && '<%=Session["RoleID"]%>' == '2') {
                        // $("#lblMsg").text('You can Edit Patient within 30 minutes of Billing...!');
                        toast("Info", "You can Edit  within 7 Days of Billing...!", "");
                        $('#btnSave,#pDetails,#payDetail').hide();
                        return false;
                    }
					else
					{
                    $('#ddlRefundBy').val(TestData[0].CreatedByID);
                    // Patient Personal Details
                    $('#lblPatientID').html(TestData[0].Patient_ID);
                    $('#lblName').html(TestData[0].PName);
                    $('#lblAge').html("".concat(TestData[0].Age, " ", TestData[0].Gender));
                    $('#lblDoctor').html(TestData[0].DoctorName);
                    $('#lblAmtPaid').html(TestData[0].Adjustment);
                    $('#lblNetAmt').html(TestData[0].NetAmount);
                    $('#lblDueAmt').html(parseInt(TestData[0].NetAmount) - parseInt(TestData[0].Adjustment));
                    $('#lblLabNoToSave').html(TestData[0].LedgerTransactionNo);
                    $('#lblLabID').html(TestData[0].LedgerTransactionID);

                    //if ((parseInt(parseInt(TestData[0].NetAmount) - parseInt(TestData[0].Adjustment)) > 0) && TestData[0].IsCredit == '0') {
                    //    $('#btnSave').hide();
                    //    $('#txtReason').attr("disabled", "disabled");
                    //}
                    //else {
                    $('#btnSave,#pDetails,#payDetail').show();
                    $('#txtReason').removeAttr("disabled", "disabled");
                    //  }

                    for (var i = 0; i <= TestData.length - 1; i++) {
                        var mydata = [];

                        mydata.push("<tr>");
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">');
                        mydata.push(parseInt(i + 1));
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(TestData[i].ItemCode); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(TestData[i].ItemName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="display:none" id="tdItemid" >'); mydata.push(TestData[i].ItemId); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(TestData[i].DATE); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right;">'); mydata.push(TestData[i].Quantity); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right;" id="ploTDRate">'); mydata.push(TestData[i].Rate); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right;" id="ploTDDiscount">'); mydata.push(TestData[i].DiscountAmt); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right;" id="ploTDAmount">'); mydata.push(TestData[i].Amount); mydata.push('</td>');

                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">');
                        if (TestData[i].IsSampleCollected == 'N') {
                            mydata.push('Not Collected');
                        }
                        else if (TestData[i].IsSampleCollected == 'S') {
                            mydata.push('Collected');
                        }
                        else if (TestData[i].IsSampleCollected == 'R') {
                            mydata.push('Rejected');
                        }
                        else if (TestData[i].IsSampleCollected == 'Y') {
                            mydata.push('Lab Received');
                        }
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;" >  <input id="chkItem" type="checkbox" ');
                        if (TestData[i].ReportType != '5') {
                            if (parseInt(TestData[i].IsARefundEntry) > 0) {
                                mydata.push(' disabled ');
                            }
                                <% if (Util.GetString(HttpContext.Current.Session["RoleID"]).Trim() != "177" && Util.GetString(HttpContext.Current.Session["RoleID"]).Trim() != "6")
                               { %>
                        else if (TestData[0].IsTransferred != '0') {
                            mydata.push(' disabled ');
                        }
                        else if (TestData[i].IsSampleCollected == 'Y' && TestData[i].ReportType != '5') {
                            mydata.push(' disabled ');
                        }

                            <%}%>
                            if (TestData[i].IsSampleCollected == 'Y' && '<%=Session["RoleID"]%>' != '177') {
                                mydata.push(' disabled ');
                            }
                        }
                        mydata.push("></td></tr>");
                        mydata = mydata.join('');
                        $('#tb_ItemList').append(mydata);
                    }
					}
                }
                else {
                    clearAllTextBox();
                    toast("Info", "No Record Found", "");

                    return false;
                }
                $modelUnBlockUI(function () { });
            });
        }

        function validation() {
            if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#txtCardNo').val() == "") {
                toast("Error", "Please Enter Card Detail", "");
                $("#txtCardNo").focus();
                return false;
            }
            if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#txtCardDate').val() == "") {
                toast("Error", "Please Enter Card Detail", "");
                $("#txtCardDate").focus();
                return false;
            }
            if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#ddlBank').val() == "0") {
                toast("Error", "Please Select Bank", "");
                $("#ddlBank").focus();
                return false;
            }                    
            if ($('#txtReason').val().trim() == '') {
                toast("Error", "Please Enter Refund Reason", "");
                $('#txtReason').focus();
                return false;
            }
            if ($('#ddlRefundBy').val() == '') {
                toast("Error", "Please Select Refund By", "");
                $('#ddlRefundBy').focus();
                return false;
            }
            return true
        }

        function savedata() {
            var PLOdata = patientlabinvestigationopd();
            if (PLOdata.length == 0) {
                toast("Error", "Please Select Item to Refund", "");
                return false;
            }
            if (validation() == false)
                return;
            confirmRefund('Confirmation', 'Are you sure to Refund Item', PLOdata);


        }
        function showpaymentoption() {
            if ($('#ddlPaymentMode').val() == "1") {
                $('#trPayment').hide();
            }
            else if ($('#ddlPaymentMode').val() == "8") {
                $('#trPayment').hide();
            }
            else {
                $('#trPayment').show();
            }
        }

        function clearAllTextBox() {
            $("#txtReason").val('');
            $('#ddlPaymentMode,#ddlPayBy').prop('selectedIndex', 0);
            $('.PatientLabel').html('');
            $('#btnSave,#pDetails,#payDetail').hide();
        }

    </script>
    <%--Set All Property--%>
    <script type="text/javascript">
        $(function () {
            //jQuery("#txtCardDate").datepicker(
           jQuery("#txtCardDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            });
        });
        function patientlabinvestigationopd() {
            var dataPLO = new Array();
            $('#tb_ItemList tr').not(":first").each(function () {
                var checkedornot = $(this).closest('tr').find("#chkItem").is(':checked');
                if (checkedornot == true) {
                    var objPLO = new Object();
                    objPLO.LabID = $('#lblLabID').html();
                    objPLO.OldLabNo = $('#lblLabNoToSave').html();
                    objPLO.Reason = $('#txtReason').val();
                    objPLO.RefundBy = $('#ddlRefundBy').val();
                    objPLO.ItemID = $(this).find('#tdItemid').html();
                    objPLO.PaymentModeID = $('#ddlPaymentMode').val();
                    objPLO.PaymentMode = $('#ddlPaymentMode option:selected').text();
                    objPLO.PayBy = $('#ddlPayBy').val();
                    dataPLO.push(objPLO);
                }
            });
            return dataPLO;
        }

    </script>
    <script type="text/javascript">
        $(function () {
            $getCurrencyDetails(function (baseCountryID) {
                $("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            });
        });

            var $getCurrencyDetails = function (callback) {
                var ddlCurrency = $('#ddlCurrency');
                serverCall('../Common/Services/CommonServices.asmx/LoadCurrencyDetail', {}, function (response) {
                    var responseData = JSON.parse(response);
                    $(ddlCurrency).bindDropDown({
                        data: responseData.currancyDetails, valueField: 'CountryID', textField: 'Currency', selectedValue: '<%= Resources.Resource.BaseCurrencyID%>'
                });
                callback(ddlCurrency.val());
            });
        }
        function confirmRefund(title, content, PLOdata) {
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
                            serverCall('OpdRefund.aspx/SaveOPDRefund', { PLO: PLOdata }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    toast("Success", $responseData.response, "");
                                    $("#txtReason").val('');
                                    $('#ddlPaymentMode,#ddlPayBy').prop('selectedIndex', 0);
                                    $('#btnSave,#payDetail').hide();
                                    // alert($('#lblLabID').html());
                                    var lab = $('#lblLabID').html();
                                    var $Encrypt = function (lab, callback) {
                                        if (barcodeno != "") {
                                            serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: barcodeno.trim() }, function (response) {
                                                callback(response);
                                            });
                                        }
                                    }
                                    if (lab != "") {
                                        serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: lab.trim() }, function (response) {
                                            var url = "../Lab/RefundReceiptNew1.aspx?LabID='" + response.trim() + "'";
                                            window.open(url.trim());
                                        });
                                    }
  
                                   // var enccryptid = $Encrypt(lab);
                                   
                                   
                                }
                                else {
                                    toast("Error", $responseData.response, "");
                                }
                                $modelUnBlockUI(function () { });
                            });
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
    </script>

</form></body></html>

