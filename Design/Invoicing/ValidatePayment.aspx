<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="ValidatePayment.aspx.cs" Inherits="Design_Invoicing_ValidatePayment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
   <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />                    
            <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">            
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        <div id="DIV1" class="POuter_Box_Inventory"   style="text-align: center;">          
                <b>Pending Amount validation</b>
                <br />
                </div>       
        <div id="SearchDiv" class="POuter_Box_Inventory">         
<div class="row">
    <div class="col-md-2">
                       <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>    
    </div>                                                                        
                           <div class="col-md-3">

                              <asp:TextBox ID="txtFromDate"  runat="server"></asp:TextBox>
<cc1:calendarextender runat="server" ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />

                           </div>
                       <div class="col-md-2">
                         <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>    
                            </div>
                              <div class="col-md-3">
                                 <asp:TextBox ID="txtToDate"  runat="server"></asp:TextBox>
 <cc1:calendarextender runat="server" ID="calToDate"
    TargetControlID="txtToDate"
    Format="dd-MMM-yyyy"
     />                      
                           </div>
                             <div class="col-md-2">
                            <label class="pull-left">Client Name </label>
                    <b class="pull-right">:</b>    </div>
                             <div class="col-md-6">
                                 <asp:DropDownList ID="ddlPanel" runat="server" CssClass="ddlPanel chosen-select">
                            </asp:DropDownList>                                                                                
                           </div>
    
                              <div class="col-md-3">
                                   <label class="pull-left">Payment Mode </label>
                    <b class="pull-right">:</b>    </div>
                             <div class="col-md-3">
                                 <asp:DropDownList ID="ddlSearchPaymentMode" ClientIDMode="Static" runat="server" 
                                     CssClass="ddlSearchPaymentMode chosen-select">
                                     </asp:DropDownList>
                             </div>   
    </div>
            <div class="row">                      
                         <div class="col-md-2">
                                     <label class="pull-left">Status </label>
                    <b class="pull-right">:</b>    </div>                 
                                    <div class="col-md-3">
                                       <select  id="ddlStatus">
                                         <option value="0">Pending</option>
                                         <option value="1">Approved</option>
                                     </select>
                                    </div>               
                          <div class="col-md-2">                   
                                     <label class="pull-left">Date Type </label>
                    <b class="pull-right">:</b> </div>
                            <div class="col-md-3"> 
                                      <select id="ddlDateType">
                                         <option value="ivac.ReceivedDate">Receive Date</option>
                                         <option value="ivac.EntryDate">Entry Date</option>
                                         <option value="ivac.ApprovedOnDate">Approval Type</option>
                                     </select>                               
                            </div>
                        </div>                                                            
            </div>          
        <div class="POuter_Box_Inventory" style="text-align: center;">                            
                     <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="searchbutton"  />                
            </div>               
             <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div id="Output" style="max-height:350px; overflow:auto; ">            
            </div>
                      <asp:Button ID="btnButton" runat="server" Style="display:none" OnClientClick="JavaScript: return false;"/>
    <cc1:ModalPopupExtender ID="mpPaymentCancel" runat="server"
                            DropShadow="true" TargetControlID="btnButton"   CancelControlID="imgclosePaymentCancel" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlPaymentCancel"    BehaviorID="mpPaymentCancel">
                        </cc1:ModalPopupExtender>  
                 <asp:Panel ID="pnlPaymentCancel" runat="server" Style="display: none;width:380px; height:120px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>        
                    <td style="text-align:left">
                        Do you want to Cancel this amount ?
                    </td>                              
                    <td  style="text-align:right">      
                        <img id="imgclosePaymentCancel" runat="server" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"   />  
                    </td>                    
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse">               
                  <tr>
                      <td colspan="2" style="text-align:center">
                          <span id="spnRejectReason" class="ItDoseLblError"></span>
                      </td>
                  </tr>
                  <tr>
                      <td  style="text-align:right">
                          Reason  :&nbsp;
                      </td>
                      <td style="text-align:left">
                          <input type="text" id="txtCancelReason" maxlength="50" style="width:240px" />
                      </td>
                  </tr>
                      <tr>
                          <td colspan="2" style="text-align:center">
                               <input type="button" value="Yes" id="btncancel" onclick="YesAgreed();" class="searchbutton"/>&nbsp;&nbsp;&nbsp;
                               <input type="button" value="No" id="btnnotcancel" onclick="NoAgreed();" class="searchbutton"/>
                          </td>
                      </tr>
                </table>           
    </asp:Panel>
                   <div id="divEditPaymentOther" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 70%; max-width: 70%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Payment Detail</h4></div>
                           
                   
                       
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeModelOther()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                    <h4 class="modal-title"></h4>
                </div>

                <div class="modal-body" >
                    <div class="row">
                                   <div class="col-md-4">
                        <label class="pull-left">Client Name</label>
                        <b class="pull-right">:</b>
                    </div>
                         <div class="col-md-8" ><span id="spnClientNameOther"></span></div>

                        <div class="col-md-4">
                        <label class="pull-left">Paid Date</label>
                        <b class="pull-right">:</b></div>
                            <div class="col-md-8">
                                <span id="spnPaidAmtDate"></span>
                                </div>
                    

                        </div>

                     </div>
 </div>
 </div>
 </div>
    <div id="divEditPayment" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 70%; max-width: 70%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Payment Detail</h4></div>
                           
                   
                       
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeModel()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body" >
                    <div class="row">
                                   <div class="col-md-4">
                        <label class="pull-left">Client Name</label>
                        <b class="pull-right">:</b>
                    </div>
                         <div class="col-md-8" ><span id="spnClientName"></span></div>

                        <div class="col-md-4">
                        <label class="pull-left">Paid Date</label>
                        <b class="pull-right">:</b></div>
                            <div class="col-md-8">
                                <span id="spnPaidDate"></span>
                                </div>
                    

                        </div>
                      <div class="row">
                                   <div class="col-md-4">
                        <label class="pull-left">Amount</label>
                        <b class="pull-right">:</b>
                    </div>
                                  <div class="col-md-3">
                                   <asp:TextBox ID="txtTotlAmt"  CssClass="requiredField ItDoseTextinputNum"  runat="server" Width="100px"></asp:TextBox>
                                        <span id="spnS_Currency" style="display:none"></span>
                                        <span id="spnS_Amount" style="display:none"></span> 
                                        <span id="spnBank" style="display:none"></span>  
                                        <span id="spnCardNo" style="display:none"></span>
                                        <span id="spnCardDate" style="display:none"></span>
                                       <input type="hidden" id="hfID" value="" />
                                      </div>                                 
                     <div class="col-md-3">
                         <label class="pull-left">Paid Amt.</label>
                        <b class="pull-right">:</b>
                         </div>
                     <div class="col-md-6">
                         <span id="spnPaidAmt" style="font-weight:bold" ></span>
                         </div>
                     </div>
                              <div class="row clInvoice">
                                  <div class="col-md-4">
                        <label class="pull-left">Invoice No.</label>
                        <b class="pull-right">:</b>
                    </div>
                                  <div class="col-md-6">
                                      <span id="spnInvoiceNo" style="font-weight:bold"></span>
                                   <span id="spnIsMainPayment" style="font-weight:bold;display:none"></span>
                                      </div>
                                  <div class="col-md-4">
                        <label class="pull-left">Invoice Amount.</label>
                        <b class="pull-right">:</b>
                    </div>
                                  <div class="col-md-6">
                                      <span id="spnInvoiceAmount" style="font-weight:bold"></span>
                                  
                                      </div>
                              </div>
                <div class="row clIsMainPayment" >
                    <div class="col-md-4">
                        <label class="pull-left">Currency</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <select onchange="$changePaymentMode(this);" id="ddlCurrency">
                        </select>
                        <span id="spnBaseCurrency" style="display: none"></span>
                        <span id="spnBaseCountryID" style="display: none"></span>
                        <span id="spnBaseNotation" style="display: none"></span>
                        <span id="spnCFactor" style="display: none"></span>
                        <span id="spnConversion_ID" style="display: none"></span>                      
                    </div>       
                    <div class="col-md-1"> </div>             
                    <div class="col-md-2">
                        <label class="pull-left">Factor</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div id="spnConvertionRate" style="color: red; font-weight: bold; text-align: left;" class="col-md-6">
                    </div>
                    <div class="col-md-4 ">
                        <label class="pull-left">Currency Round</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <input type="text" class="ItDoseTextinputNum" style="font-weight: Bold" value="0" id="txtCurrencyRound" autocomplete="off" disabled="disabled" />
                    </div>
                    <div class="col-md-1"> </div>
                </div>
                <div class="row clIsMainPayment">
                    <div class="col-md-4 ">
                        <label class="pull-left">Payment Mode</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <select id="ddlPaymentMode" onchange="$onPaymentModeChange(this,jQuery('#ddlCurrency'),$('#spnS_Amount').text(),$('#txtTotlAmt').val(),function(){});"></select></div>
                    <div class="col-md-3 clPaidAmt">
                    </div>
                </div>
                <div class="row clIsMainPayment">
                    <div class="col-md-4 ">
                    </div>
                    <div id="divPaymentDetails" class="col-md-19 isReciptsBool" style="overflow-y: auto; overflow-x: hidden;">
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
                    <div class="col-md-2">
                    </div>
                </div>
                    <div class="row">
                    <div class="col-md-4 ">
                        <label class="pull-left">Update Remarks</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtUpdateRemarks"  CssClass="requiredField"  runat="server"  MaxLength="50"></asp:TextBox>
                        </div>

                        </div>
                   <div class="row" style="text-align:center">
                     <div class="col-md-24">
                    <input id="btnSave" type="button" value="Save" class="savebutton" onclick="$UpdatePaymentDetails();" style=" text-align: center" />
                   
                </div>
                </div>
                 </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeModel()">Close</button>
                </div>
            </div>
        </div>
    </div>                
        </div>
      <script id="sc_ValidatePaymentSearch" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblValidatePayment"
    style="border-collapse:collapse;">
            <thead>
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:180px;">Paid By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:126px;">Paid Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Client Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Transaction ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Payment Mode</th>	            
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Pay Currency</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Paid Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Conversion</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Base Amount(<%=Resources.Resource.BaseCurrencyNotation %>)</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Bank Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cheque No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cheque Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Remarks </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Edit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Accept</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Cancel</th>            
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none"">Receipt</th>
		</tr>
                </thead>
  <#  
              var dataLength=PaymentData.length;
              var objRow;   
              var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = PaymentData[j];      
           #>          
                    <tr  >
<td class="GridViewLabItemStyle"><#=j+1#>
    <#
     if(objRow.MonthlyInvoiceType=="1")
    {#>  
    <img src="../../App_Images/details_open.png"  style="cursor:pointer" onclick="showHLMDetail(this)" id="imgPlus" />
    <img src="../../App_Images/details_close.png"  style="cursor:pointer; display:none" onclick="hideHLMDetail(this)" id="imgMinus" />
     <#}
    #>
</td>
<td class="GridViewLabItemStyle" style="text-align:center" id="tdType"><#=objRow.AdvType#></td>
<td class="GridViewLabItemStyle"  style="text-align:center; display:none" id="tdInvoiceAmount1"><#=objRow.InvoiceAmount#></td>
<td class="GridViewLabItemStyle" style="text-align:center;display:none " id="tdInvoiceNo1"><#=objRow.invoiceNo#></td>
<td class="GridViewLabItemStyle" style="text-align:center;display:none " id="tdCountryID"><#=objRow.S_CountryID#></td>
<td class="GridViewLabItemStyle" style="text-align:center;display:none " id="tdPaymentModeID"><#=objRow.PaymentModeID#></td> 
                        <td class="GridViewLabItemStyle"  style="text-align:center; display:none" id="tdIsMainPayment"><#=objRow.IsMainPayment#></td>                                              
<td class="GridViewLabItemStyle"><#=objRow.EntryBy#><input style="display:none;"  value="<#=objRow.panel_id#>|<#=objRow.ReceivedAmt#>|<#=objRow.ID#>|<#=objRow.EntryType#>|<#=objRow.Payment_Mode#>|<#=objRow.CentreID#>" id="data"/></td>
<td class="GridViewLabItemStyle" id="tdPaidDate" style="text-align:center"><#=objRow.EntryDate#></td>
<td class="GridViewLabItemStyle" id="tdClientName"><#=objRow.Company_Name#></td>
                        <td class="GridViewLabItemStyle" id="tdtransactionID"><#=objRow.TransactionID#></td>
<td class="GridViewLabItemStyle" ><#=objRow.PaymentMode#></td>
<td class="GridViewLabItemStyle" id="tdS_Currency"><#=objRow.S_Currency#></td>
<td class="GridViewLabItemStyle" style="text-align:right" id="td1S_Amount"><#=objRow.S_Amount#></td>
<td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.C_Factor#></td>
<td class="GridViewLabItemStyle" style="text-align:right" id="recAmnt"><#=objRow.ReceivedAmt#></td>
<td class="GridViewLabItemStyle" id="tdBank"><#=objRow.BankName#></td>
<td class="GridViewLabItemStyle" id="CardNo"><#=objRow.CardNo#></td>
<td class="GridViewLabItemStyle" id="CardDate"><#=objRow.CardDate#></td>
<td class="GridViewLabItemStyle"><#=objRow.remarks#></td>
<td class="GridViewLabItemStyle" style="display:none" id="tdID"><#=objRow.ID#></td>
<td class="GridViewLabItemStyle" style="display:none" id="tdReceiptNo"><#=objRow.ReceiptNo#></td>
 <td class="GridViewLabItemStyle">
    <#if(objRow.ValidateStatus=="0"  && objRow.IsCancel=="0"  && objRow.PaymentModeID=="RAZORPAY PAYMENT"){#>
      <a href="javascript:void(0);" onclick="$editAmount(this);" display='none';">
    <img src="../../App_Images/edit.png" style="border:none;" title="edit" />
          </a>
    <#}#>
</td>
<td class="GridViewLabItemStyle">
    <#if(objRow.ValidateStatus=="0" && objRow.IsCancel=="0"){#>
      <a href="javascript:void(0);" onclick="$finalValidate(this);" display='none';">
    <img src="../../App_Images/Post.gif" style="border:none;" title="Approve Amount" />
          </a>
    <#}#>
</td> 

<td class="GridViewLabItemStyle">
    <#if(objRow.ValidateStatus=="0"  && objRow.IsCancel=="0" && objRow.PaymentModeID=="RAZORPAY PAYMENT"){#>
      <a href="javascript:void(0);" onclick="alertMsg(this);" display='none';">
    <img src="../../App_Images/Reject.png" style="border:none;" title="Not Approve Amount" />
          </a>
    <#}#>
</td> 
<td class="GridViewLabItemStyle" style="display:none">
     <#if(objRow.ValidateStatus=="1"){#>
    <a href="ValidatePayment.aspx?panelid=<#=objRow.panel_id#>&id=<#=objRow.ID#>">
        <img src="../../App_Images/folder.gif" style="border:none" title="Receipt" />
    </a>
    <#}#>
</td>
</tr>
            <tr id="tr_Detail_<#=objRow.ID#>" style="background-color:#FFFFFF;display:none" >
            <td colspan="9" id="td_Detail_<#=objRow.ID#>">                               
            </td></tr>
            <#}#>
     </table>           
    </script>
        </div>        
    <script type="text/javascript">
        function hideHLMDetail(rowID) {
            $(rowID).closest('tr').find('#imgMinus').hide();
            $(rowID).closest('tr').find('#imgPlus').show();
            var ID = $(rowID).closest('tr').find('#tdID').text();
            $('#tr_Detail_' + ID).hide();
        }
        function showHLMDetail(rowID) {
            var ID = $(rowID).closest('tr').find('#tdID').text();
            var ReceiptNo = $(rowID).closest('tr').find('#tdReceiptNo').text();
            serverCall('ValidatePayment.aspx/bindHLMPaymentMode', { ID: ID, ReceiptNo: ReceiptNo }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    HLMPaymentMode = $responseData.data;
                    var output = $('#tb_HLMPaymentMode').parseTemplate(HLMPaymentMode);
                    $('#td_Detail_' + ID).html(output);
                    $('#td_Detail_' + ID).show();
                    $('#tr_Detail_' + ID).show();
                    $(rowID).closest('tr').find('#imgMinus').show();
                    $(rowID).closest('tr').find('#imgPlus').hide();
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                    $('#Output').html('');
                    $('#Output').hide();
                }
                $modelUnBlockUI(function () { });
            });
        }
            </script>
    <script id="tb_HLMPaymentMode" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tbl_HLMPaymentMode"
    style="width:580px;border-collapse:collapse;">                                  
		<tr id="HLMPaymentModeHeader">
            <th style="width:4%;"></th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Invoice&nbsp;No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Invoice&nbsp;Amount.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Payment Mode</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Amount</th>
            <th  style="width:30px;"></th>
</tr>
       <#       
              var dataLength=HLMPaymentMode.length;

              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = HLMPaymentMode[k];      
            #>        
                  <tr>
                      <td style="width:4%;">                   
                      </td>
                    <td class="GridViewLabItemStyle" id="tdInvoiceNo" style="width:120px;"><#=objRow.InvoiceNo#></td>
                    <td class="GridViewLabItemStyle" id="tdInvoiceAmount" style="width:60px;text-align:right"><#=objRow.InvoiceAmount#></td>
                    <td class="GridViewLabItemStyle" id="tdPaymentMode" style="width:90px;text-align:center"><#=objRow.PaymentMode#></td>                 
                    <td class="GridViewLabItemStyle" id="tdReceivedAmt" style="width:90px;text-align:right"><#=objRow.ReceivedAmt#></td>
                    <td style="width:30px;">                
                      </td>                                                                
                 </tr>
            <#}#>                      
     </table>     
    </script>
    <script type="text/javascript">
        var $onChangeCurrency = function (elem, calculateConversionFactor, BaseAmount, callback) {
            var _temp = [];
            if (calculateConversionFactor == 1) {              
                _temp = [];
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: 0 }, function (CurrencyData) {
                    $.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        $bindPaymentControl();
                        callback(true);
                    })
                }));
            }
            else {
                var balanceAmount = BaseAmount;
                var $baseAmount = String.isNullOrEmpty(balanceAmount) ? 0 : balanceAmount;
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $baseAmount }, function (CurrencyData) {
                    $.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        $onPaymentModeChange($("#ddlPaymentMode"), jQuery('#ddlCurrency'), $baseAmount, $('#txtTotlAmt').val(), function () { });


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
        var $getCurrencyDetails = function ($type, callback) {
            var selectedID = $type == "0" ? '<%= Resources.Resource.BaseCurrencyID%>' : $type;
            var $ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/Services/CommonServices.asmx/LoadCurrencyDetail', {}, function (response) {
                var $responseData = JSON.parse(response);
                jQuery('#spnBaseCurrency').text($responseData.baseCurrency);
                jQuery('#spnBaseCountryID').text($responseData.baseCountryID);
                jQuery('#spnBaseNotation').text($responseData.baseNotation);
                jQuery($ddlCurrency).bindDropDown({
                    data: $responseData.currancyDetails, valueField: 'CountryID', textField: 'Currency', selectedValue: selectedID, showDataValue: 1
                });
                callback($ddlCurrency.val());
            });
        }
        var $onPaidAmountChanged = function (e) {
            var row = $(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
            var $paidAmount = Number(e.target.value);
            
            $convertToBaseCurrency($countryID, $paidAmount, function (baseCurrencyAmount) {
                $(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount);
                $("#txtTotlAmt").val(baseCurrencyAmount);
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
            $validatePaymentModes(1, 'Cash', 0, $('#ddlCurrency'), 0, function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails($('#ddlPaymentMode option:selected'), response, function (data) {
                    });
                });
            });
        };
        var $validatePaymentModes = function ($PaymentModeID, $PaymentMode, $baseAmount, $ddlCurrency, defaultPaidAmount, callback) {
            var $totalPaidAmount = 0;
            $('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number($(this).text()); });
            var data = {
                currentSelectedPaymentMode: $('#ddlPaymentMode').val(),
                totalSelectedPaymentModes: $('#ddlPaymentMode').val(),
                billAmount: $baseAmount,
                totalPaidAmount: $totalPaidAmount,
                defaultPaidAmount: defaultPaidAmount,
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
                Amount: data.billAmount,
                BaceCurrency: data.baseCurrencyName,
                BankName: '',
                C_Factor: data.currencyFactor,
                PaymentMode: data.paymentMode,
                PaymentModeID: data.PaymentModeID,
                PaymentRemarks: '',
                RefNo: '',
                S_Amount: data.billAmount,
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
        $onPaymentModeChange = function (elem, ddlCurrency, $baseAmount, $totalAmount, callback) {
            $('.cltblPaymentDetail tr').slice(1).remove();
            $validatePaymentModes($("#ddlPaymentMode").val(), $("#ddlPaymentMode option:selected").text(), $baseAmount, $('#ddlCurrency'), $totalAmount, function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails($('#ddlPaymentMode option:selected'), response, function (data) {
                        $bindBankMaster(data.bankControl, data.IsOnlineBankShow, function () {
                            if ($("#spnBank").text() != "")
                                $(".bnk").val($("#spnBank").text());
                            if ($("#spnCardNo").text() != "")
                                $('#tblPaymentDetail tbody tr').find('#txtCardNo').val($("#spnCardNo").text());
                            if ($("#spnCardDate").text() != "")
                                $('#tblPaymentDetail tbody tr').find('#txtCardDate').val($("#spnCardDate").text());
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
            $getCurrencyDetails("0", function (baseCountryID) {
                // $getConversionFactor(baseCountryID, function (CurrencyData) {
                // jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                // jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                // jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));
                $bindPaymentMode();
                // });
            });
        });
    </script>
        <script type="text/javascript">
            function $UpdatePaymentDetails() {
                if ($("#txtTotlAmt").val() == "" || $("#txtTotlAmt").val() == "0") {
                    toast("Error", "Please Enter amount", "");
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
                if ($("#hfID").val() == "") {
                    toast("Error", "Plase select again", "");
                    return false;
                }
                if ($.trim($("#txtUpdateRemarks").val()) == "") {
                    toast("Error", "Plase Enter Update Remarks", "");
                    $("#txtUpdateRemarks").focus();
                    return false;
                }
                var ID = $("#hfID").val();
                var resultAdvanceAmount = "";
                if ($("#spnIsMainPayment").text() == "1") {
                     resultAdvanceAmount = AdvanceAmount();
                }
                else {
                    resultAdvanceAmount = AdvanceAmountOther();
                }

                
                serverCall('ValidatePayment.aspx/UpdateAdvPayment', { PanelAdvanceAmount: resultAdvanceAmount, ID: ID, IsMainPayment: $("#spnIsMainPayment").text(), PaymentUpdateRemark: $.trim( $("#txtUpdateRemarks").val()) }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                        Search();
                        $clearControl();
                        $("#divEditPayment").hideModel();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                    $modelUnBlockUI(function () { });
                });
            }
            function $clearControl() {
                $("#txtUpdateRemarks").val('');
                $("#spnInvoiceNo,#spnIsMainPayment").text('');
                $("#spnInvoiceAmount").text('0');
                $("#txtTotlAmt").attr('disabled', 'disabled');
            }
            function AdvanceAmountOther() {
                var objAdvanceAmount = new Object();
                objAdvanceAmount.AdvAmount = $('#txtTotlAmt').val();
                return objAdvanceAmount;
            }
            function AdvanceAmount() {
                var objAdvanceAmount = new Object();
                objAdvanceAmount.AdvAmount = $('#txtTotlAmt').val();
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
                return objAdvanceAmount;
            }
            function $editAmount(rowID) {
                $("#ddlCurrency").val($(rowID).closest('tr').find("#tdCountryID").html());
                $("#ddlPaymentMode").val($(rowID).closest('tr').find("#tdPaymentModeID").html());
                $("#spnClientName").text($(rowID).closest('tr').find("#tdClientName").html());
                $("#spnPaidDate").text($(rowID).closest('tr').find("#tdPaidDate").html());
                $("#spnS_Currency").text($(rowID).closest('tr').find("#tdCountryID").html());
                $("#spnS_Amount").text($(rowID).closest('tr').find("#td1S_Amount").html());
                $("#txtTotlAmt").val($(rowID).closest('tr').find("#recAmnt").html());
                if ($(rowID).closest('tr').find("#tdIsMainPayment").html() == "1") {
                    $("#txtTotlAmt").attr('disabled', 'disabled');
                }
                else {
                    $("#txtTotlAmt").removeAttr('disabled');
                }
                $("#spnBank").text($(rowID).closest('tr').find("#tdBank").html());
                $("#spnCardNo").text($(rowID).closest('tr').find("#CardNo").html());
                $("#spnCardDate").text($(rowID).closest('tr').find("#CardDate").html());
                $("#spnPaidAmt").text("".concat($("#spnS_Amount").text(), " ", $(rowID).closest('tr').find("#tdS_Currency").html()));
                $onChangeCurrency($("#ddlCurrency"), 2, $("#spnS_Amount").text(), function (response) {
                });
                
                
                $("#spnInvoiceNo").text($(rowID).closest('tr').find("#tdInvoiceNo1").html());
                $("#spnInvoiceAmount").text($(rowID).closest('tr').find("#tdInvoiceAmount1").html());
                $("#hfID").val($(rowID).closest('tr').find("#tdID").html());
                $('.clInvoice').hide();
                if ($(rowID).closest('tr').find("#tdInvoiceAmount1").html() == '' || $(rowID).closest('tr').find("#tdInvoiceNo1").html() == '') {
                    $('.clInvoice').hide();
                }
                else {
                    $('.clInvoice').show();
                }
                $("#spnIsMainPayment").text($(rowID).closest('tr').find("#tdIsMainPayment").html());
                if ($(rowID).closest('tr').find("#tdIsMainPayment").html() == "0") {
                    $('.clIsMainPayment').hide();
                }
                else {
                    $('.clIsMainPayment').show();
                }
                $("#divEditPayment").showModel();
            }
            var PassedValue = "";
            function alertMsg(val) {
                PassedValue = val;
                $('#txtCancelReason').val('');
                $('#spnRejectReason').text('');
                $find('mpPaymentCancel').show();
                $('#txtCancelReason').focus();
            }
            function YesAgreed() {
                $('#spnRejectReason').text('');
                if ($.trim($('#txtCancelReason').val()) == "") {
                    toast("Error", 'Please Enter Reject Reason', "");
                    $('#txtCancelReason').focus();
                    return;
                }
                NotAcceptAmount_Submission(PassedValue);
            }
            function NoAgreed() {
                $('#txtCancelReason').val('');
                $find('mpPaymentCancel').hide();
            }
    </script>
<script type="text/javascript">
    function NotAcceptAmount_Submission(val) {
        serverCall('ValidatePayment.aspx/CancelAmountSubmission', { data: $(val).closest("tr").find("#data").val(), CancelReason: $('#txtCancelReason').val() }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                $('#txtCancelReason').val('');
                $find('mpPaymentCancel').hide();
                Search();
                toast("Success", "Amount Submission Cancel", "");
            }
            else {
                toast("Error", $responseData.ErrorMsg, "");
            }
            $modelUnBlockUI(function () { });
        });
    }
    function Search() {
        serverCall('ValidatePayment.aspx/SearchPendingValidation', { PanelID: $('#ddlPanel').val(), FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), Status: $('#ddlStatus').val(), Paymentmode: $('#ddlSearchPaymentMode').val(), Type: $('#ddlDateType').val() }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                PaymentData = $responseData.data;
                var output = $('#sc_ValidatePaymentSearch').parseTemplate(PaymentData);
                $('#Output').html(output);
                $('#Output').show();
                $("#tblValidatePayment").tableHeadFixer({
                });
            }
            else {
                toast("Error", $responseData.ErrorMsg, "");
                $('#Output').html('');
                $('#Output').hide();
            }
            $modelUnBlockUI(function () { });
        });
    }
    function $finalValidate(val) {
        serverCall('ValidatePayment.aspx/finalValidate', { data: $(val).closest("tr").find("#data").val(), InvoiceNo: $(val).closest("tr").find("#tdInvoiceNo1").text() }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                Search();
                toast("Success", $responseData.response, "");
            }
            else {
                toast("Error", $responseData.response, "");
            }            
        });
    }
    function $changePaymentMode(rowID) {
        jQuery.confirm({
            title: 'Confirmation!',
            content: "".concat('Do You want to change Currency<br/><br/><b>Current Currency :', $("#ddlCurrency option:selected").text(), "</b><br/>", "<b>Current Payment Mode :", $("#ddlPaymentMode option:selected").text(), "</b>"),
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
                        $("#txtTotlAmt").val('0');
                        $onChangeCurrency(rowID, '1', '0', function () { });
                    }
                },
                somethingElse: {
                    text: 'No',
                    action: function () {
                        $("#ddlCurrency").val($("#spnS_Currency").text());
                        $clearChangeCurrency();
                    }
                },
            }
        });
    }
    $clearChangeCurrency = function () {
    }
    $closeModel = function () {
        $("#divEditPayment").hideModel();
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            $("#divEditPayment").hideModel();
        }
    }
    pageLoad = function (sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
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
        });
        </script>   
</asp:Content>

