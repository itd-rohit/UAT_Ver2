<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MultiplePaymentControl.ascx.cs" Inherits="Design_UserControl_MultiplePaymentControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript">
    //$(function () {
    //    $('#txtCreditTIDNumberhidden').val('');
    //    $("#txtCreditTIDNumber").autocomplete({
    //        autoFocus: true,
    //        source: function (request, response) {
    //            $.getJSON("../Common/CommonJsonData.aspx?cmd=TIDNumber", { TID: request.term }, response);
    //        },
    //        search: function () {
    //            if (this.value.length < 2) {
    //                return false;
    //            }
    //        },
    //        select: function (event, ui) {
    //            $("#txtCreditTIDNumberhidden").val(ui.item.value);

    //            console.log("value is:- "+$("#txtCreditTIDNumberhidden").val());
    //        }
    //    });
    //});
    function bindMultiple()
    {
        $('#ContentPlaceHolder1_chkCashOutstanding').prop('checked', false);
        $('#cashoutstanding').attr("style", "display:none");
        $('#txtOutstandingAmt').val();
        $('#ddlOutstandingEmployee').prop('selectedIndex', 0);
        $('#ContentPlaceHolder1_lbloutstandingdiscount').text("");
        $('#tblCashOutstanding').hide();
        if ($('#chkPaymentMode1').is(':checked'))
        {
            $("#tr_PM_1").show();
            $('#cashoutstanding').removeAttr("style");

        }
        else {
            $("#txt_tr_Amt1").val('');
            $("#tr_PM_1").hide();
        }
        if ($('#chkPaymentMode2').is(':checked')) {
            $("#tr_PM_2").show();
        }
        else {
            $("#txt_tr_Amt2").val('');
            $("#tr_PM_2").hide();
        }
        if ($('#chkPaymentMode3').is(':checked')) {
            $("#tr_PM_3").show();
        }
        else {
            $("#txt_tr_Amt3").val('');
            $("#tr_PM_3").hide();
            
        }
        if ($('#chkPaymentMode5').is(':checked')) {
            $("#tr_PM_5").show();
        }
        else {
            $("#txt_tr_Amt5").val('');
            $("#tr_PM_5").hide();
        }
        if ($('#chkPaymentMode6').is(':checked')) {
            $("#tr_PM_6").show();
        }
        else {
            $("#txt_tr_Amt6").val('');
            $("#tr_PM_6").hide();
        }
        if ($('#chkPaymentMode7').is(':checked')) {
            $("#tr_PM_7").show();
        }
        else {
            $("#txt_tr_Amt7").val('');
            $("#tr_PM_7").hide();
        }

        if ($('#chkPaymentMode12').is(':checked')) {
            $("#tr_PM_12").show();
        }
        else {
            $("#txt_tr_Amt12").val('');
            $("#tr_PM_12").hide();
        }

        if ($('#chkPaymentMode15').is(':checked')) {
            $("#tr_PM_15").show();
        }
        else {
            $("#txt_tr_Amt15").val('');
            $("#tr_PM_15").hide();
        }


        if ($('#chkPaymentMode16').is(':checked')) {
            $("#tr_PM_16").show();
        }
        else {
            $("#txt_tr_Amt16").val('');
            $("#tr_PM_16").hide();
        }

if ($('#chkPaymentMode9').is(':checked')) {
            $("#tr_PM_9").show();
        }
        else {
            $("#txt_tr_Amt9").val('');
            $("#tr_PM_9").hide();
        }
        

        if ($("#chkPaymentMode8").is(':visible')) {
            if (document.getElementById('chkPaymentMode8').checked) {
                $("#tr_PM_8").show();
            }
            else {
                $("#txt_tr_Amt8").val('');
                $("#tr_PM_8").hide();
            }

        }
        ShowBalAmt();
        bindBank();
    }
    function ShowBalAmt() {
        var tempNetAmt = $("#txtTotalAmount").val();
        var tempAmtPaid = Number($('#txt_tr_Amt1').val()) + Number($('#txt_tr_Amt2').val()) + Number($('#txt_tr_Amt3').val()) + Number($('#txt_tr_Amt5').val()) + Number($('#txt_tr_Amt6').val()) + Number($('#txt_tr_Amt7').val()) + Number($('#txt_tr_Amt8').val()) + Number($('#txt_tr_Amt9').val()) + Number($('#txt_tr_Amt12').val()) + Number($('#txt_tr_Amt15').val()) + Number($('#txt_tr_Amt16').val());
        $("#txtDueAmount").val((Number(tempNetAmt) - Number(tempAmtPaid)));
        $("#txtPaidAmount").val(Number(tempAmtPaid));
    }

    function BalAmt() {
        var tempNetAmt = $("#txtTotalAmount").val();
        var tempAmtPaid = Number($('#txt_tr_Amt1').val()) + Number($('#txt_tr_Amt2').val()) + Number($('#txt_tr_Amt3').val()) + Number($('#txt_tr_Amt5').val()) + Number($('#txt_tr_Amt6').val()) + Number($('#txt_tr_Amt7').val()) + Number($('#txt_tr_Amt8').val()) + Number($('#txt_tr_Amt9').val()) + Number($('#txt_tr_Amt12').val()) + Number($('#txt_tr_Amt15').val()) + Number($('#txt_tr_Amt16').val());
        if (tempNetAmt >= Number(tempAmtPaid)) {
            $("#txtDueAmount").val((Number(tempNetAmt) - Number(tempAmtPaid)));
        }
        else {
            $('#txt_tr_Amt1,#txt_tr_Amt2,#txt_tr_Amt3,#txt_tr_Amt4,#txt_tr_Amt5,#txt_tr_Amt6,#txt_tr_Amt7,#txt_tr_Amt9,#txt_tr_Amt12').val('');
            if ($("#chkPaymentMode8").is(':visible')) {
                if ($("#chkPaymentMode8").is(':checked') && (Number($("#txt_tr_Amt8").val()) > 0)) {
                    $("#txtDueAmount").val(Number($("#txtTotalAmount").val()) - Number($("#txt_tr_Amt8").val()));
                }
            }
            else {
                $('#txt_tr_Amt8').val('');
                $("#txtDueAmount").val($("#txtTotalAmount").val());
            }

            if ($("#chkPaymentMode15").is(':checked')) {
                
                    $("#txtDueAmount").val(Number($("#txtTotalAmount").val()) - Number($("#txt_tr_Amt15").val()));
                
            }
            else {
                $('#txt_tr_Amt15').val('');
                $("#txtDueAmount").val($("#txtTotalAmount").val());
            }

            if ($("#chkPaymentMode16").is(':checked')) {

                $("#txtDueAmount").val(Number($("#txtTotalAmount").val()) - Number($("#txt_tr_Amt16").val()));

            }
            else {
                $('#txt_tr_Amt16').val('');
                $("#txtDueAmount").val($("#txtTotalAmount").val());
            }


            alert('Receiving amt should not be greater than total amt');         
        }
        var total = Number($('#txt_tr_Amt1').val()) + Number($('#txt_tr_Amt2').val()) + Number($('#txt_tr_Amt3').val()) + Number($('#txt_tr_Amt5').val()) + Number($('#txt_tr_Amt6').val()) + Number($('#txt_tr_Amt7').val()) + Number($('#txt_tr_Amt8').val()) + Number($('#txt_tr_Amt9').val()) + Number($('#txt_tr_Amt12').val()) + Number($('#txt_tr_Amt15').val()) + Number($('#txt_tr_Amt16').val());
        $("#txtPaidAmount").val(Number(total));
    }
    function clearpaymentcontrol() {
        $('#chkPaymentMode1').prop('checked', true);
       
        $('#chkPaymentMode2,#chkPaymentMode3,#chkPaymentMode5,#chkPaymentMode6,#chkPaymentMode7,#chkPaymentMode9,#chkPaymentMode12,#chkPaymentMode15,#chkPaymentMode16').prop('checked', false);
        $('#txtCardNumber,#txtCardDate,#txtChequeNumber,#txtChequeDate,#txtcardnumber5,#txtcarddate5,#txtcarddate6,#txtcardnumber6,#txtcardnumber7,#txtcarddate7,#txtvoucherdate,#txtvoucherno,#txtDebitTIDNumber,#txtCreditTIDNumber,#txtsbicardnumber').val('');
        $('#txt_tr_Amt1,#txt_tr_Amt2,#txt_tr_Amt3,#txt_tr_Amt4,#txt_tr_Amt5,#txt_tr_Amt6,#txt_tr_Amt7,#txt_tr_Amt8,#txt_tr_Amt9,#txt_tr_Amt12,#txt_tr_Amt15').val('');

        $('#tr_PM_1,#tr_PM_2,#tr_PM_3,#tr_PM_5,#tr_PM_6,#tr_PM_7,#tr_PM_8,#tr_PM_9,#tr_PM_12,#tr_PM_15,#tr_PM_16').hide();
        document.getElementById('txtpaytmmobile').value = '';
        document.getElementById('txtpaytmotp').value = '';
    }
</script>
<table  style="border-collapse:collapse;width:100%" id="tblPayment"> 
    <tr>
        <td colspan="3">
<div id='divPaymentMode'></div>      
</td>
    </tr>
    <tr>
        <td>      
<b>Total Amount:&nbsp;</b>
<asp:TextBox ID="txtTotalAmount" CssClass="ItDoseTextinputText" runat="server" ClientIDMode="Static" ReadOnly="true"
    Width="80px" Enabled="true" Columns="10">0</asp:TextBox>
          
            
 </td> 
        <td class="required"><b>Paid Amount:&nbsp;</b><asp:TextBox ID="txtPaidAmount" runat="server" Width="80px" onkeyup="showdue()" TabIndex="20" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
            </td>
        <td>
     <b>Due Amount:&nbsp;</b>

            <asp:TextBox ID="txtDueAmount" runat="server" Width="80px" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
 </td>
    </tr>
    <tr style="display:none">
        <td colspan="3">
            <b>Cash Rendering:&nbsp;</b> <asp:TextBox ID="txtcurrency" runat="server" Width="105px" onkeyup="showreturnamt()" ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox>                                                                                    
                                            <asp:Label ID="lblreturn" runat="server" Font-Bold="true" ForeColor="Red" ClientIDMode="Static"></asp:Label>
            </td>
        </tr>
    </table>
<table id="tb_Payment"  style="border-collapse:collapse;width:100%">
    <tr>
        
        <td class="GridViewHeaderStyle" style="width: 20%">Payment Mode</td>
        <td class="GridViewHeaderStyle" style="width: 12%">Amount</td>
        <td class="GridViewHeaderStyle" style="width: 20%">Cheque No./Card No.</td>
        <td class="GridViewHeaderStyle" style="width: 18%">Cheque/Card Date</td>
        <td class="GridViewHeaderStyle" style="width: 20%">Bank Name</td>
        <td class="GridViewHeaderStyle" style="width: 10%">TID No.</td>
    </tr>
    <tr id="tr_PM_1" style="display: none;">
        
        <td style="width: 20%">Cash</td>

        <td style="width: 12%">
            <asp:TextBox ID="txt_tr_Amt1"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt1" runat="server" TargetControlID="txt_tr_Amt1"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
           </td>
        <td style="width: 20%">&nbsp;</td>
        <td style="width: 18%">&nbsp;</td>
        <td style="width: 20%">&nbsp;</td>
        <td style="width: 10%">&nbsp;</td>
    </tr>

    <tr id="tr_PM_2" style="display: none;">
        
        <td style="width: 20%">Cheque</td>
        <td style="width: 12%">
            
                        <asp:TextBox ID="txt_tr_Amt2"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt2" runat="server" TargetControlID="txt_tr_Amt2"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>

        </td>
        <td style="width: 20%">

            <input id="txtChequeNumber" type="text" style="width: 120px;" /></td>
        <td style="width: 18%">

            <input id="txtchequedate" type="text" style="width: 120px;" class="setmydate" /></td>
        <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank2" class="bank" runat="server" Width="168px" ClientIDMode="Static">
            </asp:DropDownList>
        </td>
        <td style="width: 10%">&nbsp;</td>
    </tr>

    <tr id="tr_PM_3" style="display: none;">
        
        <td style="width: 20%">Credit Card</td>
        <td style="width: 12%">
            

             <asp:TextBox ID="txt_tr_Amt3"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt3" runat="server" TargetControlID="txt_tr_Amt3"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">
            <input id="txtCardNumber" type="text" style="width: 120px;" /></td>
        <td style="width: 18%">
            <input id="txtCardDate" type="text" style="width: 120px;" class="setmydate" /></td>
         <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank3" class="bank" runat="server" Width="168px" ClientIDMode="Static">
            </asp:DropDownList></td>
        <td style="width: 10%">
       <%-- <input id="txtCreditTIDNumber" type="text" style="width: 65px;" />--%>

            <select id="txtCreditTIDNumber" style="width: 65px;" class="tidnumber" />

            
        </td>
    </tr>



    <tr id="tr_PM_5" style="display: none;">
        
        <td style="width: 20%">Debit Card</td>
        <td style="width: 12%">
          
            <asp:TextBox ID="txt_tr_Amt5"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt5" runat="server" TargetControlID="txt_tr_Amt5"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>

        </td>
         <td style="width: 20%">
            <input id="txtcardnumber5" type="text" style="width: 120px;" /></td>
         <td style="width: 18%">
            <input id="txtcarddate5" type="text" style="width: 120px;" class="setmydate" /></td>
         <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank5" class="bank" runat="server" Width="168px" ClientIDMode="Static">
            </asp:DropDownList></td>
        <td style="width: 10%">
       

              <select id="txtDebitTIDNumber" style="width: 65px;" class="tidnumber" />

        </td>
    </tr>
    <tr id="tr_PM_6" style="display: none;">
       
        <td style="width: 20%">Online Payment</td>
        <td style="width: 12%">
            
            <asp:TextBox ID="txt_tr_Amt6"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt6" runat="server" TargetControlID="txt_tr_Amt6"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>

        </td>
         <td style="width: 20%">
            <input id="txtcardnumber6" type="text" style="width: 120px;" /></td>
         <td style="width: 18%">
            <input id="txtcarddate6" type="text" style="width: 120px;" class="setmydate" /></td>
         <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank6" class="bank" runat="server" Width="168px" ClientIDMode="Static">
            </asp:DropDownList></td>
        <td style="width: 10%">&nbsp;</td>
    </tr>
    <tr id="tr_PM_7" style="display: none;">
        
        <td style="width: 20%">NEFT</td>
        <td style="width: 12%">
            <asp:TextBox ID="txt_tr_Amt7"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt7" runat="server" TargetControlID="txt_tr_Amt7"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">
            <input id="txtcardnumber7" type="text" style="width: 120px;" /></td>
         <td style="width: 18%">
            <input id="txtcarddate7" type="text" style="width: 120px;" class="setmydate" /></td>
         <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank7" class="bank" runat="server" Width="168px" ClientIDMode="Static">
            </asp:DropDownList></td>
        <td style="width: 10%">&nbsp;</td>
    </tr>
    <tr id="tr_PM_8" style="display: none;">
       
        <td style="width: 20%">OneApllo</td>
        <td style="width: 12%">
             <asp:TextBox ID="txt_tr_Amt8"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt8" runat="server" TargetControlID="txt_tr_Amt8"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">&nbsp;</td>
         <td style="width: 18%">&nbsp;</td>
         <td style="width: 20%">&nbsp;</td>
        <td style="width: 10%">&nbsp;</td>
    </tr>


    <tr id="tr_PM_15" style="display: none;">
       
        <td style="width: 20%">Coupon</td>
        <td style="width: 12%">
             <asp:TextBox ID="txt_tr_Amt15"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static" ReadOnly="true" Enabled="false"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txt_tr_Amt15"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">&nbsp;</td>
         <td style="width: 18%">&nbsp;</td>
         <td style="width: 20%">&nbsp;</td>
        <td style="width: 10%">&nbsp;</td>
    </tr>



     <tr id="tr_PM_9" style="display: none;">        
        <td style="width: 20%">PayTM</td>
        <td style="width: 12%">
            <asp:TextBox ID="txt_tr_Amt9"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt9" runat="server" TargetControlID="txt_tr_Amt9"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">
             <asp:TextBox ID="txtpaytmmobile"   runat="server" style="width: 120px;" ClientIDMode="Static" MaxLength="10" placeholder="Mobile Number"></asp:TextBox>
            
       <cc1:FilteredTextBoxExtender ID="ftbPayTmMobileNo" runat="server" TargetControlID="txtpaytmmobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
             </td>
         <td style="width: 18%">
            <input id="txtpaytmotp" type="text" runat="server" style="width: 120px;"  placeholder="OTP" ClientIDMode="Static" maxlength="8" />
       
             </td>
         <td style="width: 20%">
             &nbsp;</td>
         <td style="width: 10%">&nbsp;</td>
     </tr>


    <tr id="tr_PM_12" style="display: none;">        
        <td style="width: 20%">Voucher</td>
        <td style="width: 12%">
            <asp:TextBox ID="txt_tr_Amt12"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="ftbAmt12" runat="server" TargetControlID="txt_tr_Amt12"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">
            
            
     
             <asp:TextBox ID="txtvoucherno"   runat="server" style="width: 120px;" ClientIDMode="Static" MaxLength="10" placeholder="Voucher Number"></asp:TextBox>
            
         
     
             </td>
         <td style="width: 18%">
          
       <input id="txtvoucherdate" type="text" style="width: 120px;" class="setmydate" />
             </td>
         <td style="width: 20%">
            <asp:DropDownList ID="ddl_tr_Bank12"  runat="server" Width="168px" ClientIDMode="Static">
                <asp:ListItem Value="Near By Voucher">Near By Voucher</asp:ListItem>
            </asp:DropDownList></td>
        <td style="width: 10%">&nbsp;</td>
     </tr>


    <tr id="tr_PM_16" style="display: none;">        
        <td style="width: 20%">SBI Rewards</td>
        <td style="width: 12%">
            <asp:TextBox ID="txt_tr_Amt16"  onkeyup="BalAmt();" runat="server" style="width: 60px;" ClientIDMode="Static"></asp:TextBox>
        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txt_tr_Amt16"   FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        </td>
         <td style="width: 20%">
            
            
     
             <asp:TextBox ID="txtsbicardnumber"   runat="server" style="width: 120px;" ClientIDMode="Static" MaxLength="10" placeholder="SBI Reward Info"></asp:TextBox>
            
         
     
             </td>
         <td style="width: 18%">
          
       &nbsp;</td>
         <td style="width: 20%">
             &nbsp;</td>
        <td style="width: 10%">&nbsp;</td>
     </tr>
</table>
<script type="text/javascript">
    function bindBank() {
        if ($('.bank option').length == 0) {
            $('.bank option').remove();
            var $options = $("#ddlBank > option").clone();
            $('.bank').append($options);

        }
    }
    function checkNumeric(e, sender) {
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
    }
</script>
