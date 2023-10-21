<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CashReceive.aspx.cs" Inherits="Design_CashFlow_CashReceive" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/chosen.css" />
     <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
      <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script> 
   
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style=" text-align: center;">
            
            <b>Cash Receive</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Option            
            </div>
             <table style="width: 100%; border-collapse: collapse">
                <tr>                  
                    <td style="width: 20%; text-align: right">
                        <b>Receive Cash From :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="bindSearchType()">
                            <asp:ListItem Text="User" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Field Boy" Value="2" ></asp:ListItem>
                            <asp:ListItem Text="Bank" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>                
            </table>
            <div style="width: 99%; overflow: auto; height: 310px;">
                <table style="width: 99%;border-collapse:collapse" id="tb_CashReceive" class="GridViewStyle">
                    <tr id="trHeader" style="height: 20px;">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Type</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Deposit By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Deposit Date Time</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: right; font-size: 13px;">Amount</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;display:none"><input type="checkbox" id="chkHeader" class="chlAll" /></th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">&nbsp;</th>
                    </tr>
                </table>
                <div style="text-align: right; margin-top: 10px;">
                    <input id="btnSave" type="button" onclick="saveData();" style="margin-right: 12px; display: none;" value="Save" class="searchbutton" />&nbsp;
                </div>
            </div>
        </div>
           <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Cash Receive History             
            </div>
            <table style="text-align: center; border-collapse: collapse; width: 100%">
                <tr>
                    <td style="width: 20%; text-align: right"><b>From Date :&nbsp;</b>
                    </td>
                    <td style="width: 20%; text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right"><b>To Date :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="4">
                        <input type="button" class="searchbutton" id="btnSearch" value="Search" onclick="SearchCashReceive('1')" />&nbsp;
                         <input type="button" class="searchbutton" id="btnExportToExcel" value="ExportToExcel" onclick="SearchCashReceive('0')" />
                    </td>
            </table>
        </div>
        <div class="POuter_Box_Inventory" >
        <div style="width: 99%; overflow: auto; height: 210px;">
                <table style="width: 99%;border-collapse:collapse" id="tbl_CashReceive" class="GridViewStyle">
                    <tr id="trCashReceive" style="height: 20px;">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Receive By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: right; font-size: 13px;">Amount</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer Date Time</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">TypeName</th>                      
                    </tr>
                </table>               
            </div>
            </div>
    </div>
     <asp:Button ID="btnButton" runat="server" Style="display:none" />
     <cc1:ModalPopupExtender ID="mpCashReceive" runat="server"
                            DropShadow="true" TargetControlID="btnButton"   CancelControlID="imgcloseCashReceive" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlCashReceive"    BehaviorID="mpCashReceive">
                        </cc1:ModalPopupExtender> 

       <asp:Panel ID="pnlCashReceive" runat="server" Style="display: none;width:520px; height:196px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>  
                     <td style="text-align:left">
                         Reject Reason
                         </td>      
                    <td style="text-align:right">
                        <img id="imgcloseCashReceive" runat="server" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"   />  
                    </td>                              
                                     
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse"> 
                   <tr>
                     
                       <td style="text-align:center;width:100%" colspan="2">&nbsp;
                             <span id="spnErrorCashReceive" class="ItDoseLblError" ></span>
                            <span id="spnRowID" class="ItDoseLblError" style="display:none" ></span>
                            </td>
                  </tr>  
                  <tr>
                      <td  style="text-align:right;width:10%;font-weight:bold">
                          Type&nbsp;:&nbsp;
                          
                      </td>
                       <td style="text-align:left;width:90%">
                             <asp:Label ID="lblType" runat="server" ></asp:Label>
                            </td>
                  </tr> 
                  <tr>
                      <td  style="text-align:right;width:10%;font-weight:bold">
                          Deposit&nbsp;By&nbsp;:&nbsp;
                          
                      </td>
                       <td style="text-align:left;width:90%">
                             <asp:Label ID="lblDepositBy" runat="server" ></asp:Label>
                            </td>
                  </tr>  
                  <tr>
                      <td  style="text-align:right;width:10%;font-weight:bold">
                          Amount&nbsp;:&nbsp;
                          
                      </td>
                       <td style="text-align:left;width:90%">
                             <asp:Label ID="lblRejectAmount" runat="server"></asp:Label>
                            </td>
                  </tr>      
                  <tr>
                      <td  style="text-align:right;width:10%;font-weight:bold">
                          Deposit&nbsp;Date&nbsp;Time&nbsp;:&nbsp;
                          
                      </td>
                       <td style="text-align:left;width:90%">
                             <asp:Label ID="lblDepositDateTime" runat="server"></asp:Label>
                            </td>
                  </tr>      
                  <tr>
                      <td  style="text-align:right;width:10%" class="required">
                          Reject&nbsp;Reason&nbsp;:&nbsp;
                          
                      </td>
                       <td style="text-align:left;width:90%">
                             <asp:TextBox ID="txtRejectReason" runat="server" MaxLength="50" Width="280px"></asp:TextBox>
                            </td>
                  </tr>                         
                      <tr>
                          <td colspan="2"  style="text-align:center;width:100%">
                               <input type="button" value="Save" id="btnCashReceiveReject"  onclick="saveCashReceiveReject();" class="searchbutton"/>&nbsp;&nbsp;&nbsp;
                               <input type="button" value="Cancel" onclick="cancelCashReceiveReject();" class="searchbutton"/>                             
                          </td>
                      </tr>
                </table>     
    </asp:Panel>


    <script type="text/javascript">
        jQuery(function () {
            SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
            SearchCashReceive('2');
        });
        function SearchData(TypeID) {
            jQuery('#tb_CashReceive tr').slice(1).remove();
            jQuery('#lblMsg').text('');
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.SearchData(TypeID, onSucessSearch, onFailureSearch);
        }
        function onSucessSearch(result) {
            var CashReceiveData = jQuery.parseJSON(result);
            if (CashReceiveData != "") {
                var mydata = [];
                for (var i = 0; i <= CashReceiveData.length - 1; i++) {
                    
                    mydata.push("<tr>");
                    // alert(parseInt(parseInt(CashReceiveData.length) - i));
                    mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                    mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><span id="spnTypeName">'); mydata.push(CashReceiveData[i].TypeName); mydata.push('</span><span style="display:none;"  id="spnTypeID">'); mydata.push(CashReceiveData[i].TypeID); mydata.push(' </span><span style="display:none;"  id="spnNoteType">'); mydata.push(CashReceiveData[i].NoteType); mydata.push(' </span></td>');
                    mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><span id="spnEmpName">'); mydata.push(CashReceiveData[i].Name); mydata.push(' </span><span style="display:none;"  id="spnEmpId">'); mydata.push(CashReceiveData[i].EmpID); mydata.push(' </span><span style="display:none;"  id="spnId">'); mydata.push(CashReceiveData[i].ID); mydata.push(' </span></td>');
                    mydata.push('<td class="GridViewLabItemStyle" id="tdCreatedDate" align="left" style="font-size:12px;">'); mydata.push(CashReceiveData[i].CreatedDate); mydata.push('</td>');
                    mydata.push('<td class="GridViewLabItemStyle" align="right" style="font-size:12px;"><span  id="spnAmount">'); mydata.push(CashReceiveData[i].Amount); mydata.push('</span></td>');
                    mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><input id="btnReceive" type="button" onclick="ReceiveCash(this);" value="Receive" class="searchbutton" />&nbsp;<input id="btnReject" type="button" onclick="RejectCash(this);" value="Reject" class="searchbutton" /></td>');
                    mydata.push("</tr>");                                     
                }               
                mydata = mydata.join("");
                jQuery("#tb_CashReceive tr:first").after(mydata);
            }
            else {
                jQuery('#lblMsg').text('No Record Found');
            }      
            jQuery.unblockUI();
        }
        function onFailureSearch(result) {
            jQuery.unblockUI();
        }
        
        function validateNumbers(e, t) {
            try {
                if (window.event) {
                    var charCode = window.event.keyCode;
                }
                else if (e) {
                    var charCode = e.which;
                }
                else { return true; }
                if ((charCode > 47 && charCode < 58) || (charCode == 8))
                    return true;
                else
                    return false;
            }
            catch (err) {
                alert(err.Description);
            }
        }
    </script>
     <script type="text/javascript">
         function CashReceive() {
             var dataCashReceive = new Array();
             var objCashReceive = new Object();
             jQuery("#tb_grdPCCGrouping tr").each(function () {
                 var id = jQuery(this).attr("id");
                 var $rowid = jQuery(this).closest("tr");
                 if (id != "trHeader") {
                     objCashReceive.ID = $rowid.find("#spnId").text();
                     objCashReceive.EmpId = $rowid.find("#spnEmpId").text();
                     objCashReceive.EmpName = $rowid.find("#spnEmpName").text();
                     dataCashReceive.push(objCashReceive);
                     objCashReceive = new Object();
                 }
             });
             return dataCashReceive;
         }
         function ReceiveCash(rowID) {
             jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
             var dataCashReceive = new Array();
             var objCashReceive = new Object();
             objCashReceive.ID = jQuery(rowID).closest("tr").find("#spnId").text();
             objCashReceive.EmpId = jQuery(rowID).closest("tr").find("#spnEmpId").text();
             objCashReceive.EmpName = jQuery(rowID).closest("tr").find("#spnEmpName").text();
             objCashReceive.Amount = jQuery(rowID).closest("tr").find("#spnAmount").text();
             objCashReceive.TypeID = jQuery(rowID).closest("tr").find("#spnTypeID").text();
             objCashReceive.TypeName = jQuery(rowID).closest("tr").find("#spnTypeName").text();
             objCashReceive.NoteType = jQuery(rowID).closest("tr").find("#spnNoteType").text();
             dataCashReceive.push(objCashReceive);
             PageMethods.SaveCashReceive(dataCashReceive, onSucessCashDeposit, onFailureCashDeposit);
         }
         function saveData() {
             if (jQuery('#ddlEmployee').val() == 0) {
                 toast('Error',"Please Select " + jQuery('#rblSearchType input[type=radio]:checked').next().text());
                 jQuery('#ddlEmployee').focus();
                 return;
             }
             jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
             PageMethods.SaveCashReceive(jQuery('[id$=tb_CashReceive]').find('[id$=txtEntAmount]').val(), $('[id$=tb_CashReceive]').find('[id$=lblDepositat]').text(), onSucessCashDeposit, onFailureCashDeposit);
         }
         function onSucessCashDeposit(result) {
             if (result == "1") {
                 toast('Success',"Record Saved Successfully");
                 SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
                 SearchCashReceive('2');
             }
             else if (result == "2") {
                 toast('Error',"Already Receive OR Cancel");
                 SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
             }
             else {
                 toast('Error','Error');
             }
             jQuery.unblockUI();
         }
         function onFailureCashDeposit(result) {
             toast('Error','Error');
             jQuery.unblockUI();
         }
         function RejectCash(rowID) {
             jQuery("#spnErrorCashReceive").text('');
             jQuery("#btnCashReceiveReject").removeAttr('disabled');
             jQuery.confirm({
                 title: 'Confirmation!',
                 content: '<b>Do you want to Reject ?</b> <br/><br/> Deposit By : <b>' + jQuery(rowID).closest("tr").find("#spnEmpName").text() + '</b><br/> Amount : <b>' + jQuery(rowID).closest("tr").find("#spnAmount").text() + '</b>',
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
                             // confirmationAction(rowID);
                             jQuery("#lblType").text(jQuery(rowID).closest("tr").find("#spnTypeName").text());
                             jQuery("#spnRowID").text(jQuery(rowID).closest("tr").find("#spnId").text());
                             jQuery("#lblDepositBy").text(jQuery(rowID).closest("tr").find("#spnEmpName").text());
                             jQuery("#lblRejectAmount").text(jQuery(rowID).closest("tr").find("#spnAmount").text());
                             jQuery("#lblDepositDateTime").text(jQuery(rowID).closest("tr").find("#tdCreatedDate").text());
                             $find("<%=mpCashReceive.ClientID%>").show();
                         }
                     },
                     somethingElse: {
                         text: 'No',
                         action: function () {
                             clearAction();
                         }
                     },
                 }
             });        
         }
         function clearAction() {
         }
         function saveCashReceiveReject() {
             if (jQuery.trim(jQuery("#txtRejectReason").val()) == "") {
                 jQuery("#spnErrorCashReceive").text('Please Enter Reject Reason');
                 jQuery("#txtRejectReason").focus();
                 return;
             }
             jQuery("#btnCashReceiveReject").attr('disabled', 'disabled');
             var rowID = jQuery("#spnRowID").text();
             if (rowID != "") {
               //  jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                 var dataCashReceive = new Array();
                 var objCashReceive = new Object();
                 objCashReceive.ID = jQuery("#spnRowID").text();                
                 objCashReceive.RejectReason = jQuery.trim(jQuery("#txtRejectReason").val());
                 dataCashReceive.push(objCashReceive);
                 PageMethods.RejectCashReceive(dataCashReceive, onSucessRejectDeposit, onFailureCashDeposit);
             }
             else {
                 jQuery("#spnErrorCashReceive").text('Error Occurred');
                 jQuery("#btnCashReceiveReject").removeAttr('disabled');
             }
         }
         function cancelCashReceiveReject() {
             $find("<%=mpCashReceive.ClientID%>").hide();
             jQuery("#spnRowID").text('');
         }
         function onSucessRejectDeposit(result) {
             if (result == "1") {
                 toast('Success',"Record Saved Successfully");
                 SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
             }
             else if (result == "2") {
                 toast('Error',"Already Receive OR Cancel");
                 SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
             }
             else if (result == "3") {
                 jQuery("#spnErrorCashReceive").text('Please Enter Reject Reason');
                 jQuery("#btnCashReceiveReject").removeAttr('disabled').fadeIn();
                 return;
             }
             else {
                 toast('Error','Error');
             }
             $find("<%=mpCashReceive.ClientID%>").hide();
            
         }
    </script>
    <script type="text/javascript">
        function bindSearchType() {
            SearchData(jQuery('#rblSearchType input[type=radio]:checked').val());
        }
        function SearchCashReceive(con) {
            if (con == 1)
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.exportCashReceive(jQuery('#txtFromDate').val(), jQuery('#txtToDate').val(), con, onSucessExportCashReceive, onFailureCashReceive, con);
        }
        function onSucessExportCashReceive(result, con) {
            if (con == 0) {
                if (result == 1)
                    window.open('../common/ExportToExcel.aspx');
                else
                    toast('Error',"No Record Found");
            }
            else {
                var CashReceiveData = jQuery.parseJSON(result);
                jQuery('#tbl_CashReceive tr').slice(1).remove();
                if (CashReceiveData != "") {
                    var mydata = [];
                    for (var i = 0; i <= CashReceiveData.length - 1; i++) {
                        
                        mydata.push("<tr>");
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(CashReceiveData[i].ReceiveBy); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(CashReceiveData[i].TransferBy); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="right" style="font-size:12px;width:70px">'); mydata.push(CashReceiveData[i].Amount);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:160px">'); mydata.push(CashReceiveData[i].TransferDateTime); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">'); mydata.push(CashReceiveData[i].TypeName); mydata.push('</td>');
                        mydata.push("</tr>");
                        
                    }
                    mydata = mydata.join("");
                    jQuery("#tbl_CashReceive tr:first").after(mydata);
                }
                jQuery.unblockUI();
            }
        }
        function onFailureCashReceive(result) {         
            jQuery.unblockUI();
        }
    </script>
</asp:Content>

