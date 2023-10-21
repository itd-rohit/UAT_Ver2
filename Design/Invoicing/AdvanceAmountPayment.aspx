<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static"
    CodeFile="AdvanceAmountPayment.aspx.cs" Inherits="Design_Invoicing_AdvanceAmountPayment"
    %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
          
<webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
          <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
<script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
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
   
    <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">           
                                  <strong><asp:Label ID="lblHeader" runat="server"></asp:Label> <br />
                    </strong>
            <table style="width:100%;border-collapse:collapse;text-align:center;display:none" id="tblType">
                <tr style="text-align:center">
                    <td style="width:40%">
                        &nbsp;
                    </td>
                    <td  colspan="4" style="width:30%">
                                         <asp:RadioButtonList ID="rblSearchType" runat="server"    RepeatDirection="Horizontal"  onchange="clearControl()" >
                    <asp:ListItem Text="BTC/LAB" Value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="PUP" Value="2"></asp:ListItem>
                    <asp:ListItem Text="HLM" Value="3"></asp:ListItem>
                </asp:RadioButtonList>
                    </td>
                     <td style="width:30%">
                        &nbsp;
                    </td>
                </tr>
            </table>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                
           
        </div>
        <div class="POuter_Box_Inventory" style="width:1300px;" >
            <div class="Purchaseheader">
                 Payment</div>
          
                <table style="width:100%;border-collapse:collapse">
                    <tr>
                        <td style="text-align:right;width:20%" class="required">
                            Client Name :&nbsp;</td>
                        <td style="width: 30%">
                            <asp:DropDownList ID="ddl_panel" runat="server" onchange="Search('0');" Width="320px" CssClass="ddl_panel chosen-select">
                            </asp:DropDownList> <span style="color:red">*</span></td>
                         <td style="text-align:right;width:20%">
                            Deposit Date :&nbsp;</td>
                        <td style="width: 30%">
                            <asp:TextBox ID="dtFrom" runat="server" Width="100px" ></asp:TextBox>
                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy"
                                 />
                            
                        </td>
                    </tr>
                   <tr class="clInvoice">
                        <td style="text-align:right;width:20%" class="required">
                            Invoice No. :&nbsp;</td>
                        <td style="width: 30%">
                            <asp:DropDownList ID="ddlInvoiceNo" runat="server"  Width="320px" onchange="showBalanceAmt()" >
                            </asp:DropDownList> <span style="color:red">*</span></td>
                         <td style="text-align:right;width:20%">
                           Pending Invoice Amt. :&nbsp;</td>
                        <td style="width: 30%">
                           <asp:Label ID="lblPendingInvoiceAmt" runat="server" ForeColor="Red" Font-Bold="true" ></asp:Label>
                            
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:20%">
                            Payment Mode :&nbsp;
                        </td>
                        <td style="width: 30%;" >                          
                            <asp:DropDownList ID="paymentMode" runat="server"    onchange="SetMode();" Width="116px">
<%--                                <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                <asp:ListItem Value="Cheque">Cheque</asp:ListItem>
                                <asp:ListItem Value="Draft">Demand Draft</asp:ListItem>
                                <asp:ListItem Value="NEFT">NEFT</asp:ListItem>
                                <asp:ListItem Value="RTGS">RTGS</asp:ListItem>
                                <asp:ListItem Value="IMPS">IMPS</asp:ListItem>
				<asp:ListItem Value="UPI">UPI</asp:ListItem>
                                <asp:ListItem Value="Paytm">Paytm</asp:ListItem>
                                 <asp:ListItem Value="Bank deposit">Bank deposit</asp:ListItem>--%>
								<asp:ListItem Value="RazorPay Payment">RazorPay Payment</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="text-align:right;width:20%;display:none" class="clInvoice" >
                                  Invoice Amt. :&nbsp;</td>
                        <td style="width: 30%;display:none" class="clInvoice">
                            <asp:Label ID="lblInvoiceAmt" runat="server" ForeColor="Red" Font-Bold="true" ></asp:Label>
            </td>
                    </tr>

                    <tr>
                       <td style="text-align:right;width:20%" class="required">
                          Advance Amount :&nbsp;</td>
                        <td style="width: 311px;">
                            <asp:TextBox ID="txtAdvAmt" runat="server" Width="82px" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> <span style="color:red">*</span>
                            <cc1:FilteredTextBoxExtender ID="ftbAdvAmt" runat="server" TargetControlID="txtAdvAmt"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                            </td>
                         <td style="text-align:right;width:20%;" class="required clInvoice11"  >
                            Total Outstanding :&nbsp;
                        </td>
                         <td>
                             <asp:Label ID="lblTotalOutstanding" runat="server" ForeColor="Red" Font-Bold="true" ></asp:Label>
                        </td>
                    </tr>   
                     <tr class="Bank"  style="text-align:right">
                    <td style="text-align:right;width:20%">Bank Name :&nbsp;</td>
                        <td style="width: 80%;text-align:left" colspan="3"> 
                        <asp:DropDownList ID="ddlBankName" runat="server" Width="160px"></asp:DropDownList>                       
                                       </td>
                    </tr>   
                    <tr class="chk required" style="text-align:right;width:20%" >
                    <td>Enter <span class="spnPaymentMode"></span> No. :&nbsp;</td>
                        <td style="width: 30%;text-align:left">                                               
                        <asp:TextBox ID="txtCheque" runat="server" Width="156px" AutoCompleteType="Disabled" MaxLength="50" ></asp:TextBox>
                                                   </td>                                                        
                    <td style="text-align:right;width:20%" class="required">Enter <span class="spnPaymentMode"></span> Date :&nbsp;</td>
                      <td style="width: 30%;text-align:left"> 
                    
                      <asp:TextBox ID="txtCheckDate" runat="server" Width="100px"></asp:TextBox>                            
                            <cc1:CalendarExtender runat="server" ID="calChequeDate" TargetControlID="txtCheckDate" Format="dd-MMM-yyyy"
                                />                   
                    </td>
                    </tr> 
                    <tr  style="display:none">
                        <td style="width: 20%;text-align:right;" >                          
                            TDS Amount :&nbsp;
                        </td>
                         <td style="width: 30%;text-align:left;" >                          
                            <asp:TextBox ID="txtTDSAmount" runat="server" Width="82px" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> &nbsp;<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtTDSAmount"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align:right;width:20%;display:none" class="clHLM">
                            Cancellation & Discount Amount :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left;display:none" class="clHLM">                          
                             <asp:TextBox ID="txtCancellationAmount" runat="server" onkeyup="chkBalanceAmount()" Width="82px" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> 
                        <cc1:FilteredTextBoxExtender ID="ftbHLMCancelationAmount" runat="server" TargetControlID="txtCancellationAmount"
                                ValidChars=".0987654321"></cc1:FilteredTextBoxExtender>
                        </td>
                         
                    </tr>
                    <tr class="clHLM" style="display:none">
                        <td style="text-align:right;width:20%">
                            Electricity Bill Amount :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left">                          
                             <asp:TextBox ID="txtElectricityAmount" runat="server" Width="82px" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> 
                        </td>
                         <td style="width: 20%;text-align:right">                          
                            Water Bill Amount :&nbsp;
                        </td>
                         <td style="width: 30%;text-align:left">                          
                            <asp:TextBox ID="txtWaterAmount" runat="server" Width="82px" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> &nbsp;<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtWaterAmount"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr> 
                    <tr class="clHLM" style="display:none">
                        <td style="text-align:right;width:20%">
                            Other Amount :&nbsp;
                        </td>
                        <td style="width: 30%;text-align:left">                          
                             <asp:TextBox ID="txtOtherAmount" runat="server" Width="82px" onkeyup="chkBalanceAmount()" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"/> 
                        </td>
                         <td style="width: 20%;text-align:right;display:none" class="clInvoice" >                          
                            Balance Amount :&nbsp;</td>
                         <td style="width: 30%;text-align:left;display:none" class="clInvoice">                          
                            <asp:Label ID="lblBalanceAmount" runat="server" ForeColor="Red" Font-Bold="true" ></asp:Label></td>
                    </tr> 

                                        
                     <tr>
                        <td style="text-align:right;width:20%" class="required">
                          Remarks :&nbsp;</td>
                        <td style="width: 80%;text-align:left" colspan="3">
                            <asp:TextBox ID="txt_PaymentRemarks" runat="server" Width="420px"  MaxLength="50"/> <span style="color:red">*</span>                          
                            </td>
                    </tr> 
                      <tr  style="display:none">
                       <td style="text-align:right;width:20%">
                          Type :&nbsp;</td>
                         <td style="width: 80%;text-align:left" colspan="3">
                            <asp:RadioButtonList ID="rdb_typeOfPayment" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Deposit" Value="0" Selected="True"></asp:ListItem>
                           <%-- <asp:ListItem Text="Credit Note" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="Debit Note" Value="2" ></asp:ListItem>--%>
                            </asp:RadioButtonList>
                            </td>
                    </tr> 
                                           
                     
                                           
                </table>
            </div>
             <div class="POuter_Box_Inventory"   style="text-align:center;width:1300px;">

                 <table  style="width:100%">
                     <tr>
                         <td style="width:20%">&nbsp;</td>
                    
                 <td style="background-color:#90EE90;width:60px;border:1px solid black;cursor:pointer;" onclick="Search('1')"></td>
                                     <td style="text-align:left"><b>Verify</b></td>
                          <td style="background-color:#FFC0CB;width:60px;border:1px solid black;cursor:pointer;" onclick="Search('2')"></td>
                                     <td style="text-align:left"><b>Pending</b></td>
                         <td style="background-color:#3399FF;width:60px;border:1px solid black;cursor:pointer;" onclick="Search('3')"></td>
                                     <td style="text-align:left"><b>Reject</b></td>
<td>
               <input id="btnSave" type="button" runat="server" value="Save"  class="savebutton" />
               <input id="btnPay" type="button"  value="Save" onclick="PayNow();"  style="" class="savebutton" />
    <input type="hidden" id="hdnOnlineTransactionNo" value="" />
    <asp:HiddenField ID="hdnRazorpay_Order_ID" runat="server" />


</td>
                         <td style="width:50%">&nbsp;</td>
                          </tr>

                     </table>
           </div>
            <div class="POuter_Box_Inventory"   style="text-align:center;width:1300px;">
                <div class="Purchaseheader">
                    Previous Payment</div>
                <div id="tb_Search" style="width:100%">
                </div>
            
        </div>
        <div id="Div_Reject" class="POuter_Box_Inventory" style="width: 400px; display: none;
            cursor: default; text-align: left;">  
            <div style="text-align:center">
                <table style="width:100%;border-collapse:collapse">
                    <tr>
                        <td colspan="2">
                             <input type="text" id="txt_id" style="display: none;width: 225px" />     
                            <asp:Label ID="lblCancelMasg" runat="server" CssClass="ItDoseLblError" />   
                        </td>
                    </tr>
                    <tr>
                        <td>
                          <b>  Remarks:</b>
                        </td>
                         <td>
                            <input type="text" id="txt_RejectRemark" style="width: 300px" maxlength="50" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                             <input id="Button2" type="button" value="Save" onclick="RejectAdvance();" class="ItDoseButton" />
                            <input id="Button3" type="button" value="Cancel" onclick="CancelRejectAdvance();" class="ItDoseButton"/>
                            </td>
                        </tr>
                </table>           
                </div>
        </div>
    </div>
        <script type="text/javascript">
            function validate() {
                if ($("#ddl_panel").val() == 0) {
                    $("#lblMsg").text('Please Select Client Name');
                    $("#ddl_panel").focus();
                    return false;
                }
                if ($.trim($("#txtAdvAmt").val()) == 0 || $.trim($("#txtAdvAmt").val()) == "") {
                    $("#lblMsg").text('Please Enter Advance Amount');
                    $("#txtAdvAmt").focus();
                    return false;
                }
                if ($.trim($("#txt_PaymentRemarks").val()) == "") {
                    $("#lblMsg").text('Please Enter Remarks');
                    $("#txt_PaymentRemarks").focus();
                    return false;
                }

            }
            function clearform() {
                $(':text, textarea').val('');
            }

        </script>
    <script type="text/javascript">
        function Reject(val) {
            $("#txt_id").val($(val).closest("tr").find("#data").val());
            $('#txt_RejectRemark').val('');
            $.blockUI({ message: $('#Div_Reject') });
        }
        function CancelRejectAdvance() {
            $.unblockUI();
        }
        function RejectAdvance() {
            $("#lblMsg").text('');
            if ($.trim($("#txt_RejectRemark").val()) == "") {
                $("#lblCancelMasg").text('Please Enter Cancellation Remarks');
                $("#txt_RejectRemark").focus();
                return;
            }
           // jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.RejectPrevAdvPayment($("#txt_id").val(), $.trim($("#txt_RejectRemark").val()), onSucessAdv, onFailureAdv);
        }
        function onSucessAdv(result) {
            if (result == 1) {
                $("#lblMsg").text('Amount Rejected Successfully');
            }
            else {
                $("#lblMsg").text('Error');
            }
            Search('0');
          //  $.unblockUI();
        }
        function onFailureAdv(result) {
            alert('Error!!!');
          //  $.unblockUI();
        }

        $(document).ready(function () {
           
            Search('0');
            SetMode();
            $('#<%=txtAdvAmt.ClientID%>').keypress(function (event) {
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
            // $('.chk').hide();
            // $('.Bank').hide();
        });
        function onSucessSearch(result) {
            PatientData = jQuery.parseJSON(result);
            if (PatientData != null) {
                var output = $('#tb_Search_grd').parseTemplate(PatientData);
                $('#tb_Search').html(output);
                $('#tb_Search').show();
                     jQuery("#tblSearch").tableHeadFixer({

                });
            }
            else {
                $('#tb_Search').hide();
            }
               if ($("#<%=ddl_panel.ClientID %>").val().split('#')[1] == "PUP"){
           // if (($("#<%=ddl_panel.ClientID %>").val().split('#')[1] == "HLM") || ($("#<%=ddl_panel.ClientID %>").val().split('#')[1] == "PUP" && $("#<%=ddl_panel.ClientID %>").val().split('#')[2] == "Credit")) {
                PageMethods.bindInvoice($("#<%=ddl_panel.ClientID %>").val().split('#')[0], onSucessInvoiceData, onFailureSearch);
            }
        }
        function onSucessInvoiceData(result) {
            jQuery("#ddlInvoiceNo option").remove();
            InvoiceData = jQuery.parseJSON(result);
            if (InvoiceData.length == 0) {
                jQuery("#ddlInvoiceNo").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
               jQuery("#ddlInvoiceNo").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < InvoiceData.length; i++) {
                    jQuery("#ddlInvoiceNo").append(jQuery("<option></option>").val(InvoiceData[i].ID).html(InvoiceData[i].InvoiceNo));
                }
                   showBalanceAmt();
            }
            
        }
        function onFailureSearch(result) {

        }
        function Search(con) {
            if($("#<%=ddl_panel.ClientID %>").val()!=null)
            PageMethods.SearchPrevAdvPayment(con, $("#<%=ddl_panel.ClientID %>").val().split('#')[0], onSucessSearch, onFailureSearch);
        }
    </script>

    <script id="tb_Search_grd" type="text/html">    
        <div class="content" style="overflow:scroll;height:300px">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblSearch"
    style="border-collapse:collapse;width:1250px">
 <thead>
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;text-align:center">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px; text-align:center">Client Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:280px; text-align:center">Client Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:center">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Payment Mode</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Payment Mode No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px;text-align:center">Payment Mode Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:210px;text-align:center">Deposit By</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:100px">Deposit Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:136px">Entry Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:300px">Remarks</th>	
            <th class="GridViewHeaderStyle" scope="col" style="text-align:center;width:200px">Reject Reason</th>			
            <th class="GridViewHeaderStyle" scope="col" style="text-align:center;display:none">Receipt</th>                     			
</tr>
</thead>
      <#       
              var dataLength=PatientData.length;
              var objRow;   
             var RecieveAmt=0;var PendingAmt=0;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];         
            if(objRow.ValidateStatus ==1 && objRow.IsCancel ==0){
             RecieveAmt+=Number(objRow.ReceivedAmt);  
}
            if(objRow.ValidateStatus ==0){
             PendingAmt+=Number(objRow.ReceivedAmt);  
}

            #>
                    <tr id="<#=j+1#>"
                        <#
 if(objRow.ValidateStatus ==0)
                        {#>
                        style="background-color:#FFC0CB" 
                        <#}                      
                        else if(objRow.ValidateStatus ==1 && objRow.IsCancel ==0)
                        {#>
                        style="background-color:#90EE90"
                        <#}
                       else if(objRow.IsCancel ==1)
                        {#>
                        style="background-color:#3399FF"
                        <#}
                      
                         
                        #> >
<td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Panel_Code#>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Company_Name#>
<input style="display:none;"  value="<#=objRow.ID#>" id="data"/>
</td>
<td class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.ReceivedAmt#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.PaymentMode#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ChequeNo#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ChequeDate#></td>
<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.EntryBy#></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.AdvanceAmtDate#></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EntryDate#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.remarks#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.RejectReason#></td>

</tr>

<#}#>

<tr >
<td class="GridViewLabItemStyle" colspan="3"   style="color:Red  ; font-weight:bold;text-align:right">Approved Total :</td>
<td class="GridViewLabItemStyle"  style="color:Red  ; font-weight:bold;text-align:right;font-size:large"><#=RecieveAmt#></td>
 

 </tr> 
            <tr >
<td class="GridViewLabItemStyle" colspan="3"   style="color:Red  ; font-weight:bold;text-align:right">Pending Total :</td>
<td class="GridViewLabItemStyle"  style="color:Red  ; font-weight:bold;text-align:right;font-size:large"><#=PendingAmt#></td>
 

 </tr> 
        </table> 
     
  </div>
    </script>
   <script type="text/javascript">
       $(function () {
           SetMode();
       });
       function SetMode() {
           var paymentMode = $.trim($("#paymentMode option:selected").text());
           if (paymentMode == "Cheque" || paymentMode == "Demand Draft" || paymentMode == "NEFT" || paymentMode == "IMPS" || paymentMode == "RTGS" || paymentMode == "UPI") {
               $('.Bank,.chk').show();
           }
           else {
               $('.chk,.Bank').hide();
           }
           $('.spnPaymentMode').text(paymentMode);

           if (paymentMode == "RazorPay Payment") {
               $('[id$=btnSave]').hide();
               $('[id$=btnPay]').show();
           }
           else {
               $('[id$=btnSave]').hide();
               $('[id$=btnPay]').show();
           }

           if (paymentMode == "Bank deposit")
           {
               $('.Bank').show();
           }
       }
   </script>
    <script type="text/javascript">
        $(function () {
            $('#<%=btnSave.ClientID %>').click(function () {
                $("#lblMsg").text('');
                if ($("#ddl_panel").val() == 0) {
                    $("#lblMsg").text('Please Select Client Name');
                    $("#ddl_panel").focus();
                    return;
                }
                if ($.trim($("#txtAdvAmt").val()) == 0 || $.trim($("#txtAdvAmt").val()) == "") {
                    $("#lblMsg").text('Please Enter Advance Amount');
                    $("#txtAdvAmt").focus();
                    return;
                }
                // if ($("#ddl_panel").val().split('#')[1] == "HLM" || ($("#ddl_panel").val().split('#')[1] == "PUP" && $("#ddl_panel").val().split('#')[2] == "Credit")) {
                if ($("#ddl_panel").val().split('#')[1] == "HLM") {
                    if ($('#ddlInvoiceNo option').length == 0) {
                        $("#lblMsg").text('Please Select Invoice No.');
                        $("#ddlInvoiceNo").focus();
                        return;
                    }
                    if (parseFloat($('#txtAdvAmt').val()) > 200000 && $("#paymentMode").val() == "Cash") {
                        $("#lblMsg").text('Cash cannot be accepted more than Rs. 2,00,000');
                        $("#txtAdvAmt").focus();
                        return;
                    }
                    if (parseFloat($('#lblPendingInvoiceAmt').text()) < parseFloat($('#txtAdvAmt').val())) {
                        $("#lblMsg").text('Please Enter Valid Advance Amount');
                        $("#txtAdvAmt").focus();
                        return;
                    }
                }

                if ($("#paymentMode").val() == "Cheque" || $("#paymentMode").val() == "Draft" || $("#paymentMode").val() == "IMPS" || $("#paymentMode").val() == "NEFT" || $("#paymentMode").val() == "RTGS") {
                    if ($("#ddlBankName").val() == 0) {
                        $("#lblMsg").text('Please Select Bank Name');
                        $("#ddlBankName").focus();
                        return;
                    }
                    if ($.trim($("#txtCheque").val()) == "") {
                        $("#lblMsg").text('Please Enter ' + $.trim($("#paymentMode option:selected").text()) + ' No.');
                        $("#txtCheque").focus();
                        return;
                    }
                }
                if ($("#ddl_panel").val().split('#')[1] == "HLM") {
                    var AdvAmt = $("#txtAdvAmt").val();
                    var CancellationAmount = $("#txtCancellationAmount").val();
                    if (isNaN(CancellationAmount) || CancellationAmount == "")
                        CancellationAmount = 0;
                    var TDSAmount = $("#txtTDSAmount").val();
                    if (isNaN(TDSAmount) || TDSAmount == "")
                        TDSAmount = 0;
                    var ElectricityAmount = $("#txtElectricityAmount").val();
                    if (isNaN(ElectricityAmount) || ElectricityAmount == "")
                        ElectricityAmount = 0;
                    var WaterAmount = $("#txtWaterAmount").val();
                    if (isNaN(WaterAmount) || WaterAmount == "")
                        WaterAmount = 0;
                    var OtherAmount = $("#txtOtherAmount").val();
                    if (isNaN(OtherAmount) || OtherAmount == "")
                        OtherAmount = 0;
                    var totalAmount = parseFloat(CancellationAmount) + parseFloat(TDSAmount) + parseFloat(ElectricityAmount) + parseFloat(WaterAmount) + parseFloat(OtherAmount);


                    if (parseFloat(totalAmount) != parseFloat(AdvAmt)) {
                        $("#lblMsg").text('Please Enter Valid Advance Amount');
                        $("#txtAdvAmt").focus();
                        return;
                    }
                }
                if ($.trim($("#txt_PaymentRemarks").val()) == "") {
                    $("#lblMsg").text('Please Enter Remarks');
                    $("#txt_PaymentRemarks").focus();
                    return;
                }
              //  jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                var typeOfPayment = $('#rdb_typeOfPayment input[type=radio]:checked').val()
                var resultAdvanceAmount = AdvanceAmount();
                $.ajax({
                    url: "AdvanceAmountPayment.aspx/SaveAdvPayment",
                    data: JSON.stringify({ PanelAdvanceAmount: resultAdvanceAmount,InvoiceNo: $('#ddlInvoiceNo option:selected').text() }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            Search('0');
                            $('input[type="text"]').val('');
                            $('#paymentMode').val('Cash');
                            $('.chk,.Bank').hide();
                            $('#<%=dtFrom.ClientID %>').val('<%=DateTime.Now.ToString("dd-MMM-yyyy") %>');
                            $('#<%=txtCheckDate.ClientID %>').val('<%=DateTime.Now.ToString("dd-MMM-yyyy") %>');
                            $("#lblMsg").text('Amount Submitted Successfully');
                            SetMode();
                        }
                        else {
                            $("#lblMsg").text(result.d);
                        }
                     //   $.unblockUI();
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Error');
                      //  $.unblockUI();
                    }
                });
            });
        });
        function AdvanceAmount() {
            var AdvanceAmount = new Array();
            var objAdvanceAmount = new Object();


            objAdvanceAmount.PanelName = $("#ddl_panel option:selected").text();
            objAdvanceAmount.PanelID = $("#ddl_panel").val().split('#')[0];
            objAdvanceAmount.DepositeDate = $('#dtFrom').val();
            objAdvanceAmount.AdvAmount = $('#txtAdvAmt').val();

            objAdvanceAmount.PaymentMode = $('#paymentMode').val().toUpperCase();
            if ($('#paymentMode').val().toUpperCase() != "CASH") {
                objAdvanceAmount.BankName = $("#ddlBankName option:selected").text();
                objAdvanceAmount.BankID = $("#ddlBankName").val();
                objAdvanceAmount.DraftNo = $("#txtCheque").val();
                objAdvanceAmount.DraftDate = $("#txtCheckDate").val()
            }
            else {
                objAdvanceAmount.BankName = "";
                objAdvanceAmount.BankID = 0;
                objAdvanceAmount.DraftNo = "";
                objAdvanceAmount.DraftDate = "";
            }
            objAdvanceAmount.TypeOfPayment = $('#rdb_typeOfPayment input[type=radio]:checked').val();
            objAdvanceAmount.Remarks = $("#txt_PaymentRemarks").val()

            objAdvanceAmount.EntryType = $("#ddl_panel").val().split('#')[1];
            objAdvanceAmount.PanelPaymentMode = $("#ddl_panel").val().split('#')[2];
            objAdvanceAmount.CentreID = $("#ddl_panel").val().split('#')[3];
            objAdvanceAmount.OnlinePaymentTransactionNo = $('#hdnOnlineTransactionNo').val();
            
               if ($("#ddl_panel").val().split('#')[1] == "HLM") {
          //  if (($("#ddl_panel").val().split('#')[1] == "HLM") || ($("#ddl_panel").val().split('#')[1] == "PUP" && $("#ddl_panel").val().split('#')[2] == "Credit")) {
                objAdvanceAmount.InvoiceNo = $('#ddlInvoiceNo').val().split('#')[0];
                objAdvanceAmount.InvoiceAmount = $('#lblInvoiceAmt').text();
                objAdvanceAmount.InvoiceDate = $('#ddlInvoiceNo').val().split('#')[2];
                if (($('#txtCancellationAmount').val() != "" && $('#txtCancellationAmount').val() != 0) || ($('#txtTDSAmount').val() != "" && $('#txtTDSAmount').val() != 0) || ($('#ElectricityAmount').val() != "" && $('#ElectricityAmount').val() != 0) || ($('#txtWaterAmount').val() != "" && $('#txtWaterAmount').val() != 0) || ($('#txtOtherAmount').val() != "" && $('#txtOtherAmount').val() != 0)) {
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();

                }


                if ($('#txtCancellationAmount').val() != "" && $('#txtCancellationAmount').val() != 0) {

                    objAdvanceAmount.PaymentMode = "Cancellation";
                    objAdvanceAmount.AdvAmount = $('#txtCancellationAmount').val();
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();
                }
                if ($('#txtTDSAmount').val() != "" && $('#txtTDSAmount').val() != 0) {

                    objAdvanceAmount.PaymentMode = "TDS";
                    objAdvanceAmount.AdvAmount = $('#txtTDSAmount').val();
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();
                }
                if ($('#txtElectricityAmount').val() != "" && $('#txtElectricityAmount').val() != 0) {

                    objAdvanceAmount.PaymentMode = "Electricity";
                    objAdvanceAmount.AdvAmount = $('#txtElectricityAmount').val();
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();
                }

                if ($('#txtWaterAmount').val() != "" && $('#txtWaterAmount').val() != 0) {

                    objAdvanceAmount.PaymentMode = "Water";
                    objAdvanceAmount.AdvAmount = $('#txtWaterAmount').val();
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();
                }
                if ($('#txtOtherAmount').val() != "" && $('#txtOtherAmount').val() != 0) {

                    objAdvanceAmount.PaymentMode = "Other";
                    objAdvanceAmount.AdvAmount = $('#txtOtherAmount').val();
                    AdvanceAmount.push(objAdvanceAmount);
                    objAdvanceAmount = new Object();
                }

            }
            else if ($('#txtTDSAmount').val() != "" && $('#txtTDSAmount').val() != 0) {
                AdvanceAmount.push(objAdvanceAmount);
                objAdvanceAmount = new Object();
                objAdvanceAmount.PaymentMode = "TDS";
                objAdvanceAmount.AdvAmount = $('#txtTDSAmount').val();
                AdvanceAmount.push(objAdvanceAmount);
                objAdvanceAmount = new Object();
            }
            else {
                objAdvanceAmount.InvoiceNo = "";
                objAdvanceAmount.InvoiceAmount = 0;
                objAdvanceAmount.CancellationAmount = 0;
                objAdvanceAmount.TDSAmount = 0;
                objAdvanceAmount.ElectricityAmount = 0;
                objAdvanceAmount.WaterAmount = 0;
                objAdvanceAmount.OtherAmount = 0;
                AdvanceAmount.push(objAdvanceAmount);
            }



            return AdvanceAmount;
        }


    </script>

    <script type="text/javascript">
        function showPayment() {
            if ($("#ddl_panel").val() != null) {
                if ($("#ddl_panel").val().split('#')[1] == "PUP")
                    $(".clInvoice").show();
                // $(".clHLM,.clInvoice").show();

                else
                    $(".clHLM,.clInvoice").hide();
            }
            else {
                $(".clHLM,.clInvoice").hide();
            }
        }
        function addAdvAmt() {

        }
        function chkHLMAllAmt() {

        }
        function showBalanceAmt() {
            $('#lblInvoiceAmt').text($('#ddlInvoiceNo').val().split('#')[1]);

            PageMethods.InvoicePendingAmt($('#ddlInvoiceNo option:selected').text(), onSucessBalanceAmt, onFailureAdv);


        }
        function onSucessBalanceAmt(response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                result = $responseData.data;
                $('#lblPendingInvoiceAmt').text(precise_round(parseFloat($('#lblInvoiceAmt').text() - parseFloat(result)), '<%=Resources.Resource.BaseCurrencyRound%>'));
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
           // $('#lblPendingInvoiceAmt').text(parseFloat($('#lblInvoiceAmt').text() - parseFloat(result)));

            totalOutstanding();
        }

        function totalOutstanding() {
            PageMethods.totalOutstanding($('#ddl_panel').val().split('#')[0], onSucessTotalOutstanding, onFailureAdv);
        }
        function onSucessTotalOutstanding(response) {

            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                $('#lblTotalOutstanding').text(parseFloat($responseData.data));
            }
            else {
                toast("Error", $responseData.ErrorMsg, "");
            }
            $modelUnBlockUI(function () { });
          //  $('#lblTotalOutstanding').text(parseFloat(result));

        }


        function chkBalanceAmount() {


            var AdvAmt = $('#txtAdvAmt').val();
            if (isNaN(AdvAmt) || AdvAmt == "")
                AdvAmt = 0;

            var CancellationAmount = 0;
            if ($('#txtCancellationAmount').is(':visible')) {
                CancellationAmount = $('#txtCancellationAmount').val();
                if (isNaN(CancellationAmount) || CancellationAmount == "")
                    CancellationAmount = 0;

            }

            var TDSAmount = 0;
            if ($('#txtTDSAmount').is(':visible')) {
                TDSAmount = $('#txtTDSAmount').val();
                if (isNaN(TDSAmount) || TDSAmount == "")
                    TDSAmount = 0;
            }

            var ElectricityAmount = 0;
            if ($('#txtElectricityAmount').is(':visible')) {
                ElectricityAmount = $('#txtElectricityAmount').val();
                if (isNaN(ElectricityAmount) || ElectricityAmount == "")
                    ElectricityAmount = 0;
            }

            var WaterAmount = 0;
            if ($('#txtElectricityAmount').is(':visible')) {
                WaterAmount = $('#txtWaterAmount').val();
                if (isNaN(WaterAmount) || WaterAmount == "")
                    WaterAmount = 0;

            }
            var OtherAmount = 0;
            if ($('#txtOtherAmount').is(':visible')) {
                OtherAmount = $('#txtOtherAmount').val();
                if (isNaN(OtherAmount) || OtherAmount == "")
                    OtherAmount = 0;


            }

            var totalAmt = parseFloat(AdvAmt) + parseFloat(CancellationAmount) + parseFloat(TDSAmount) + parseFloat(ElectricityAmount) + parseFloat(WaterAmount) + parseFloat(OtherAmount);

            $('#lblBalanceAmount').text(parseFloat($('#lblPendingInvoiceAmt').text()) - parseFloat(totalAmt));
        }
    </script>
    <script type="text/javascript">
        function clearControl() {
            jQuery('#tb_Search').html('');
            jQuery('#tb_Search').hide();
            PageMethods.bindClient(jQuery("#rblSearchType input[type=radio]:checked").val(), onSuccessPanel, OnfailurePanel);
        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            jQuery('#<%=ddl_panel.ClientID%> option').remove();
            jQuery('#<%=ddl_panel.ClientID%>').trigger('chosen:updated');
            if (panelData != null) {
              //  jQuery('#<%=ddl_panel.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < panelData.length; i++) {
                    jQuery('#<%=ddl_panel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('#<%=ddl_panel.ClientID%>').trigger('chosen:updated');

            }


        }
        function OnfailurePanel() {

        }
        function hideSearchCriteria() {
            jQuery('#tblType').hide();
        }
    </script>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script type="text/javascript">

    function PayNow() {
       
     
        

        //=====================Check Session & check panel----------

        $.ajax({
            url: "AdvanceAmountPayment.aspx/CheckSession",
            async: false,
            //data: JSON.stringify({ LtID: LtID }),
            contentType: "application/json; charset=utf-8",
            type: "POST", // data has to be Posted 
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                if (result.d == "0")
                {
                    alert('Session Expired, Kindly login again');
                    window.location.href = "../Default.aspx";
                }
            }
        });

        if ($('[id$=ddl_panel]').val() == null)
        {
            alert("Please choose any client");
            return false;
        }

        //-----------------------------------------------------------

        var PanelData = $('[id$=ddl_panel]').val();
        var Amount = $('[id$=txtAdvAmt]').val().trim();
        var Remarks = $('[id$=txt_PaymentRemarks]').val().trim();
        var PanelName = $('[id$=ddl_panel] option:selected').text();
        var PanelAddress='';
        var Email='';
        var Mobile = '';
        var date = new Date();


        var LIS_Receipt = PanelData.split('#')[0] + '/' + Amount + '/' + date.getDate() + date.getMonth() + date.getFullYear() + date.getHours() + date.getMinutes();
     
       
       if (PanelData == "0") {
            alert("Please choose any client");
            return false;
        }
        else {
            PanelAddress = PanelData.split('#')[4];
            Email = PanelData.split('#')[5];
            Mobile = PanelData.split('#')[6];
        }

        if (Amount == "") {
            alert('Please Enter Amount');
            return false;
        }
        if (Remarks == "") {
            alert('Please Enter Remarks');
            return false;
        }

        var Billno = $("#<%=ddlInvoiceNo.ClientID %>").val();

        if (Billno == "0")
        {
            alert('Please Select Invoice  No');
            return false;
        }




	 //------------------------------------------------------------------



        OrderNow(LIS_Receipt, Amount, PanelData.split('#')[0]);
        var APIkey = "";//Atulaya Healthcare//rzp_live_cH58tGiKOsfHoF

	   

        var options = {
            "key": "rzp_test_GK00qHVb7ocQYC",
                                            // "rzp_live_mpmzPN4tbsW5hG",// rzp_test_3kbfbq22aKwEXo --rzp_test_HWRCFv6lsEFwlT
            "amount": parseInt(Amount), // 2000 paise = INR 20
            "name": "Itdose Infosystem",
            "payment_capture": "1",
            "description":'Payment for Client ' +  PanelName,
            "image": "F:\yoda\Yoda_live\App_Images\SHLlogo.png",
            "order_id": $('#<%=hdnRazorpay_Order_ID.ClientID%>').val(),
            "handler": function (response) {

                //------------------------------------------write Notepad----------
                
                $.ajax({
                    url: "AdvanceAmountPayment.aspx/WriteNotePad",
                    async: false,
                    data: JSON.stringify({ data: "Response Received - TransactionID : " + response.razorpay_payment_id }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                    }
                });

                //-----------------------------------------------------------------

                //alert(response);
               // console.log(response);
                var TransactionNo = response.razorpay_payment_id;
                $('#hdnOnlineTransactionNo').val(TransactionNo);
                $('[id$=btnSave]').click();
            },
            "prefill": {
                "name": "",
                "email": Email,
                "contact": Mobile
            },
            "notes": {
                "address": PanelAddress,
                "panelId": PanelData.split('#')[0],
                "centreIdSession":""
            },
            "theme": {
                "color": "#09f"
            }
        };
        var rzp1 = new Razorpay(options);
        rzp1.open();
    //    $('[id$=btnSave]').click();
        $('#hdnOnlineTransactionNo').val('');
        //e.preventDefault();
        return false;
    }


    function OrderNow(Receiptid,amount,PanelID)
    {
        var LIS_Ricept=Receiptid;
        var Amount = amount;
       
         $.ajax({
             url: "AdvanceAmountPayment.aspx/OrderNow",
             data: '{LIS_Ricept:"' + LIS_Ricept + '",Amount:"' + parseInt(Amount) * 100 + '",Panel_Id:"' + PanelID + '"}', // parameter map//* 100
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             async:false,
             success: function (result) {   
                 $('#<%=hdnRazorpay_Order_ID.ClientID%>').val(result.d);
                  
                   
               },
               error: function (xhr, status) {

                   window.status = status + "\r\n" + xhr.responseText;

               }
           });
           
           }

</script>
</asp:Content>
