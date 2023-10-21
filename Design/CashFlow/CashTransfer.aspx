<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CashTransfer.aspx.cs" Inherits="Design_CashFlow_CashTransfer" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/chosen.css" />
   
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style=" text-align: center;">

            <b>Cash Transfer</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Option
             
            </div>


            <table style="text-align: center; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right">
                        <b>Transfer To :&nbsp;</b>
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="bindSearchType('1')">
                            <asp:ListItem Text="User" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Field Boy" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Bank" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 20%; text-align: right" class="required">
                        <b>
                            <asp:Label ID="lblSearchType" runat="server" Text="User "></asp:Label>
                            :&nbsp; </b>
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:DropDownList ID="ddlEmployee" Width="320px" class="ddlEmployee chosen-select" runat="server" onchange="fieldBoyMobileNo()">
                        </asp:DropDownList>&nbsp;
                    </td>
                </tr>

            </table>

        </div>
        <div class="POuter_Box_Inventory" >
            <table style="text-align: center; border-collapse: collapse; width: 100%">
                <tr>
                    <td style="width: 30%; text-align: right"><b>Last Transfer To :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:Label ID="lblLastTransferTo" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right"><b>Last Transfer Amount :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:Label ID="lblLastTransferAmount" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right"><b>Total Cash Amount Pending for Receive :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:Label ID="lblTotalCashPendingAmount" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; text-align: right"><b>Last Transfer Date Time :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                        <table style="width:100%;border-collapse:collapse">
                            <tr>
                                <td style="width: 40%; text-align: left">
                                    <asp:Label ID="lblLastTransferDateTime" runat="server"></asp:Label>
                                </td>
                                <td style="width: 60%; text-align: left" class="required">
                                  <span id="spnFieldBoyMobileNo"  style="display:none"> <b>Mobile No. :&nbsp;</b><asp:TextBox ID="txtFieldBoyMobileNo" runat="server" MaxLength="10"></asp:TextBox></span>
                                   <cc1:FilteredTextBoxExtender ID="ftbFieldBoyMobileNo" runat="server" TargetControlID="txtFieldBoyMobileNo" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                                  
                                </td>
                            </tr>
                        </table>
                        
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" >
            <table style="text-align: center; border-collapse: collapse; width: 100%">
                <tr>
                    <td style="width: 30%; text-align: right"><b>Total Cash Balance :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                        <asp:Label ID="lblTotalCashBalance" runat="server" Style="font-size: large; color: blue; font-weight: bold"></asp:Label>
                    </td>
                </tr>

                <tr>
                    <td style="width: 30%; text-align: right" ><b>Cash Transfer Amount :&nbsp;</b>
                    </td>
                    <td style="width: 70%; text-align: left">
                       
                              
                                    <asp:TextBox ID="txtCashTransferAmount" runat="server" Width="120px" CssClass="requiredField"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbCashTransfer" runat="server" TargetControlID="txtCashTransferAmount" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                                
                               
                           
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" class="searchbutton" id="btnSave" value="Save" onclick="SaveCashTransfer('0')" />
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Transfer History
             
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
                        <input type="button" class="searchbutton" id="btnSearch" value="Search" onclick="SearchCashTransfer('1')" />
                        <input type="button" class="searchbutton" id="btnExportToExcel" value="ExportToExcel" onclick="SearchCashTransfer('0')" />
                    </td>
            </table>

        </div>

        <div class="POuter_Box_Inventory" >
            <div style="width: 99%; overflow: auto; height: 210px;">

                <table style="width: 99%; border-collapse: collapse" id="tb_CashTransfer" class="GridViewStyle">
                    <tr id="trHeader" style="height: 20px;">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer To</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Amount</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer Date Time</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">TypeName</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">IsReceive</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">IsReject</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">RejectReason</th>
                    </tr>
                </table>

            </div>
        </div>

        <asp:Button ID="btnButton" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="mpShortDeposit" runat="server"
            DropShadow="true" TargetControlID="btnButton" CancelControlID="imgcloseCashReceive" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlShortDeposit" BehaviorID="mpShortDeposit">
        </cc1:ModalPopupExtender>

        <asp:Panel ID="pnlShortDeposit" runat="server" Style="display: none; width: 520px; height: 176px;" CssClass="pnlVendorItemsFilter">
            <div class="Purchaseheader">
                <table style="width: 100%; border-collapse: collapse" border="0">
                    <tr>
                        <td style="text-align: left">ShortDeposit Reason
                        </td>
                        <td style="text-align: right">
                            <img id="imgcloseCashReceive" runat="server" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" />
                        </td>

                    </tr>
                </table>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>

                    <td style="text-align: center; width: 100%" colspan="2">&nbsp;
                             <span id="spnErrorShortDeposit" class="ItDoseLblError"></span>

                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 40%; font-weight: bold">Total Cash Balance&nbsp;:&nbsp;
                          
                    </td>
                    <td style="text-align: left; width: 60%;font-weight: bold">
                        <asp:Label ID="lblTotalCashBalancePopUp" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 40%; font-weight: bold">Cash Transfer Amount&nbsp;:&nbsp;
                          
                    </td>
                    <td style="text-align: left; width: 50%;font-weight: bold">
                        <asp:Label ID="lblCashTransferAmtPopUp" runat="server"></asp:Label>
                    </td>
                </tr>

                <tr>
                    <td style="text-align: right; width: 40%" >ShortDeposit&nbsp;Reason&nbsp;:&nbsp;
                          
                    </td>
                    <td style="text-align: left; width: 60%">
                        <asp:TextBox ID="txtShortDepositRejectReason" runat="server" MaxLength="50" Width="280px" CssClass="requiredField"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center; width: 100%">
                        <input type="button" value="Save" id="btnShortDepositReject" onclick="saveShortDeposit();" class="searchbutton" />&nbsp;&nbsp;&nbsp;
                               <input type="button" value="Cancel" onclick="cancelShortDeposit();" class="searchbutton" />
                    </td>
                </tr>
            </table>
        </asp:Panel>


    </div>
    <script type="text/javascript">
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
            bindSearchType('0');
            SearchData();
            SearchCashTransfer('2');
        });

    </script>
    <script type="text/javascript">
        function bindSearchType(con) {
            jQuery('#lblSearchType').text(jQuery('#rblSearchType input[type=radio]:checked').next().text());
            jQuery('#spnFieldBoyMobileNo').hide();
            
            jQuery('#txtFieldBoyMobileNo').val('');
            PageMethods.bindSearchType(jQuery('#rblSearchType input[type=radio]:checked').val(), onSucessSearchType, onFailureSearch, con);
        }
        function onSucessSearchType(result, con) {
            var empData = jQuery.parseJSON(result);
            jQuery("#ddlEmployee option").remove();
            jQuery('#ddlEmployee').trigger('chosen:updated');
            if (empData != null) {
                jQuery('#ddlEmployee').append(jQuery("<option></option>").val('0').html('Select'));
                for (var a = 0; a <= empData.length - 1; a++) {
                    jQuery('#ddlEmployee').append(jQuery("<option></option>").val("".concat(empData[a].ID, "#", empData[a].Mobile)).html(empData[a].Name));
                }

            }
            jQuery('#ddlEmployee').trigger('chosen:updated');
            if (con == 1)
                SearchData();

           
                
            
        }
        function SearchData() {
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.SearchData(jQuery('#rblSearchType input[type=radio]:checked').next().text(), onSucessSearch, onFailureSearch);
        }
        function onSucessSearch(result) {
            CashDeposit = jQuery.parseJSON(result);
            for (var i = 0; i <= CashDeposit.length - 1; i++) {
                jQuery("#lblLastTransferTo").text(CashDeposit[0].EmployeeName_To);
                jQuery("#lblLastTransferAmount").text(CashDeposit[0].Amount);
                jQuery("#lblLastTransferDateTime").text(CashDeposit[0].CreatedDate);
                jQuery("#lblTotalCashPendingAmount").text(CashDeposit[0].TransferPendingAmt * (-1));
                jQuery("#lblTotalCashBalance").text(Math.abs(parseFloat(CashDeposit[0].ReceivedAmt) + parseFloat(CashDeposit[0].TransferAmt + parseFloat(CashDeposit[0].TransferPendingAmt))));
            }
            jQuery("#btnSave").show();
            jQuery.unblockUI();
        }
        function onFailureSearch(result) {
            jQuery.unblockUI();
        }
        
    </script>
    <script type="text/javascript">
        function SaveCashTransfer(con) {
         
            if (jQuery('#ddlEmployee').val() == 0) {
                
                toast('Error', "Please Select " + jQuery('#rblSearchType input[type=radio]:checked').next().text());
                jQuery('#ddlEmployee').focus();
                return;
            }
            if (jQuery('#txtCashTransferAmount').val() == "" || jQuery('#txtCashTransferAmount').val() == 0) {
                toast('Error',"Please Enter Transfer Amount");
                jQuery('#txtCashTransferAmount').focus();
                return;
            }
            
            if (parseFloat(jQuery('#txtCashTransferAmount').val()) > parseFloat(jQuery('#lblTotalCashBalance').text())) {
                toast('Error',"Please Enter Valid Transfer Amount");
                jQuery('#txtCashTransferAmount').focus();
                return;
            }

            if (jQuery('#rblSearchType input[type=radio]:checked').val() == 2 && (jQuery.trim(jQuery('#txtFieldBoyMobileNo').val()) =="" || jQuery.trim(jQuery('#txtFieldBoyMobileNo').val()).length<10)) {
                toast('Error',"Please Enter Valid FieldBoy MobileNo");
                jQuery('#txtFieldBoyMobileNo').focus();
                return;
            }
            if (parseFloat(jQuery('#txtCashTransferAmount').val()) != parseFloat(jQuery('#lblTotalCashBalance').text()) && con == 0) {
                $find("<%=mpShortDeposit.ClientID%>").show();
                jQuery('#lblTotalCashBalancePopUp,#lblCashTransferAmtPopUp,#spnErrorShortDeposit').text('');
                jQuery('#lblTotalCashBalancePopUp').text(jQuery('#lblTotalCashBalance').text());
                jQuery('#lblCashTransferAmtPopUp').text(jQuery('#txtCashTransferAmount').val());
                return;
            }
            SaveCashDepositAmt();
        }
        function SaveCashDepositAmt() {
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.SaveCashDeposit(jQuery('#ddlEmployee').val().split('#')[0], jQuery('#ddlEmployee option:selected').text(), jQuery('#rblSearchType input[type=radio]:checked').val(), jQuery('#txtCashTransferAmount').val(), jQuery('#rblSearchType input[type=radio]:checked').next().text(), jQuery.trim(jQuery('#txtShortDepositRejectReason').val()),jQuery('#txtFieldBoyMobileNo').val(),jQuery('#ddlEmployee').val().split('#')[1], onSucessCashDeposit, onFailureCashDeposit);

        }
        function onSucessCashDeposit(result) {
            if (result == "1") {
                toast('Success',"Record Saved Successfully");
                jQuery('#txtCashTransferAmount,#txtShortDepositRejectReason,#txtFieldBoyMobileNo').val('');
                jQuery('#spnFieldBoyMobileNo').hide();
                jQuery('#ddlEmployee').prop('selectedIndex', 0);
                jQuery('#ddlEmployee').trigger('chosen:updated');
                SearchData();
                SearchCashTransfer('1');
            }
            else if (result == "2") {
                if (jQuery('#rblSearchType input[type=radio]:checked').val() == 2)
                    toast('Error',"Receiver Not Set to Particular Field Boy.Please Contact to Account Team");
                else
                    toast('Error',"Receiver Not Set to Bank.Please Contact to Account Team");
            }
            else if (result == "3") {
                toast('Error',"Please Enter Valid Cash Transfer Amount");
                jQuery('#txtCashTransferAmount').focus();
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
        function SearchCashTransfer(con) {
            if (con != 2)
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.exportCashDeposit(jQuery('#txtFromDate').val(), jQuery('#txtToDate').val(), con, onSucessExportCashDeposit, onFailureCashDeposit, con);
        }
        function onSucessExportCashDeposit(result, con) {
            if (con == 0) {
                if (result == 1)
                    window.open('../common/ExportToExcel.aspx');
                else
                    toast('Error',"No Record Found");
            }
            else {
                var CashTransferData = jQuery.parseJSON(result);
                jQuery('#tb_CashTransfer tr').slice(1).remove();
                if (CashTransferData != "") {
                    var mydata = [];
                    for (var i = 0; i <= CashTransferData.length - 1; i++) {

                        mydata.push("<tr>");
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(CashTransferData[i].TransferBy); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(CashTransferData[i].TransferTo); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="right" style="font-size:12px;width:70px">'); mydata.push(CashTransferData[i].Amount); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:160px">'); mydata.push(CashTransferData[i].TransferDateTime); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">'); mydata.push(CashTransferData[i].TypeName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">'); mydata.push(CashTransferData[i].IsReceive); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">'); mydata.push(CashTransferData[i].IsReject); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:160px">'); mydata.push(CashTransferData[i].RejectReason); mydata.push(' </td>');
                        mydata.push("</tr>");

                    }
                    mydata = mydata.join("");
                    jQuery("#tb_CashTransfer tr:first").after(mydata);
                }
                else {
                    //jQuery('#lblMsg').text('No Record Found');
                }
            }
            jQuery.unblockUI();
        }
    </script>
    <script type="text/javascript">
        function cancelShortDeposit() {
            $find("<%=mpShortDeposit.ClientID%>").hide();
            jQuery("#spnErrorShortDeposit").text('');
        }
        function saveShortDeposit() {                      
            if (jQuery.trim(jQuery('#txtShortDepositRejectReason').val()) == "") {
                jQuery("#spnErrorShortDeposit").text('Please Enter Short Deposit Reason');
                jQuery('#txtShortDepositRejectReason').focus();
                return;
            }
           
                jQuery('#lblTotalCashBalancePopUp,#lblCashTransferAmtPopUp,#spnErrorShortDeposit').text('');
                $find("<%=mpShortDeposit.ClientID%>").hide();
                SaveCashTransfer('1');
            
        }
        function fieldBoyMobileNo() {
            if (jQuery('#rblSearchType input[type=radio]:checked').val() == 2 && jQuery('#ddlEmployee').val() !=0) {
                jQuery('#txtFieldBoyMobileNo').val(jQuery('#ddlEmployee').val().split('#')[1]);
                jQuery('#spnFieldBoyMobileNo').show();
                
            }
            else {
                jQuery('#txtFieldBoyMobileNo').val('');
                jQuery('#spnFieldBoyMobileNo').hide();
               
            }
        }
    </script>
</asp:Content>

