<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CashCreditDebitNote.aspx.cs" Inherits="Design_CashFlow_CashCreditDebitNote" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/jquery-ui.css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
 <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style=" text-align: center;">
            
            <b>Cash Credit Debit Note</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Option            
            </div>
            <table style="text-align: center; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right" class="required">
                        <b>Employee Name :&nbsp;</b>
                    </td>
                    <td style="width: 30%; text-align: left">
                         <asp:TextBox ID="txtEmployeeName" runat="server" Width="230px" ClientIDMode="Static" />
                            <input type="hidden" id="hdEmployeeID" />
                            <input type="hidden" id="hdEmployeeName" />
                        
                    </td>
                    <td style="width: 20%; text-align: right" >
                        &nbsp;
                    </td>
                    <td style="width: 30%; text-align: left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right" class="required">
                        <b>Amount :&nbsp;</b></td>
                    <td style="width: 30%; text-align: left">
                         <asp:TextBox ID="txtAmount" runat="server" Width="120px" ClientIDMode="Static"  MaxLength="6" />
                        <cc1:FilteredTextBoxExtender ID="ftbAmount" runat="server" TargetControlID="txtAmount" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    </td> 
                    <td style="width: 20%; text-align: right" >
                        &nbsp;</td>
                    <td style="width: 30%; text-align: left">
                        &nbsp;</td>
                </tr>
                <tr>
                     <td style="width: 20%; text-align: right">
                        <b>Type :&nbsp;</b>
                    </td>
                   <td style="width: 30%; text-align: left">
                        <asp:RadioButtonList ID="rblTypeOfPayment" runat="server" RepeatDirection="Horizontal" >
                            
                            <asp:ListItem Text="Credit Note" Value="-1" Selected="True" ></asp:ListItem>
                            <asp:ListItem Text="Debit Note" Value="1" ></asp:ListItem>
                            
                            </asp:RadioButtonList>
                    </td>
                     <td style="width: 20%; text-align: right" >
                      <b> Remarks :&nbsp;</b>
                    </td>
                    <td style="width: 30%; text-align: left">
                        <asp:TextBox ID="txtRemarks" runat="server" Width="276px" MaxLength="50"/>
                    </td>
                </tr>
            </table>
            </div>
         <div class="POuter_Box_Inventory" style=" text-align: center">
            <input type="button" class="searchbutton" id="btnSave" value="Save" onclick="SaveCreditDebitNote()" />
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
                        <input type="button" class="searchbutton" id="btnSearch" value="Search" onclick="SearchCreditDebitNote('1')" />
                        <input type="button" class="searchbutton" id="btnExportToExcel" value="ExportToExcel" onclick="SearchCreditDebitNote('0')" />
                    </td>
            </table>

        </div>

        <div class="POuter_Box_Inventory" >
            <div style="width: 99%; overflow: auto; height: 210px;">

                <table style="width: 99%; border-collapse: collapse" id="tb_CreditDebitNote" class="GridViewStyle">
                    <tr id="trHeader" style="height: 20px;">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer To</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Amount</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Transfer Date Time</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">TypeName</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">IsReceive</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">IsReject</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Type</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; font-size: 13px;">Remarks</th>
                    </tr>
                </table>

            </div>
        </div>


        </div>
    <script type="text/javascript">
        jQuery(function () {
           
            SearchCreditDebitNote('2');
        });
        function SaveCreditDebitNote() {
            if (jQuery("#hdEmployeeID").val() == "") {
                toast('Error',"Please Select Valid Employee");
                jQuery("#txtEmployeeName").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtAmount").val()) == "" || jQuery.trim(jQuery("#txtAmount").val()) ==0) {
                toast('Error',"Please Enter Valid Amount");
                jQuery("#txtAmount").focus();
                return;
            }
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.CreditDepitNoteSave(jQuery('#hdEmployeeID').val(), jQuery('#hdEmployeeName').val(), jQuery('#rblTypeOfPayment input[type=radio]:checked').val(), jQuery('#txtAmount').val(), jQuery('#txtRemarks').val(), jQuery('#rblTypeOfPayment input[type=radio]:checked').next().text(), onSucessNote, onFailureNote);

        }
        

        
        function onSucessNote(result) {
            if (result == "1") {
                toast('Success',"Record Saved Successfully");
                jQuery('#hdEmployeeID,#txtAmount,#txtRemarks,#hdEmployeeName,#txtEmployeeName').val('');
                SearchCreditDebitNote('2');
            }
           
            else {
                toast('Error','Error');
            }
            jQuery.unblockUI();
        }
        function onFailureNote(result) {
            toast('Error','Error');
            jQuery.unblockUI();
        }


          </script>

     <script type="text/javascript">
         jQuery("#txtEmployeeName")
               .bind("keydown", function (event) {
                   if (event.keyCode === $.ui.keyCode.TAB &&
                      jQuery(this).autocomplete("instance").menu.active) {
                       event.preventDefault();
                   }
               })
               .autocomplete({
                   autoFocus: true,
                   source: function (request, response) {
                       $.getJSON("CashCreditDebitNote.aspx?cmd=GetEmpList", {
                           EmpName: extractLast1(request.term)
                       }, response);
                   },
                   search: function () {
                       // custom minLength
                       var term = extractLast1(this.value);
                       if (term.length < 2) {
                           return false;
                       }
                   },
                   focus: function () {
                       // prevent value inserted on focus
                       return false;
                   },
                   select: function (event, ui) {
                       this.value = '';
                       jQuery("#<%=txtEmployeeName.ClientID%>").val(ui.item.label);
                       jQuery("#hdEmployeeID").val(ui.item.value);
                       jQuery("#hdEmployeeName").val(ui.item.EmployeeName);
                      return false;
                  },
              });
              function extractLast1(term) {
                  return term;
              }
    </script>
    <script type="text/javascript">
        function SearchCreditDebitNote(con) {
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.exportCreditDebitNote(jQuery('#txtFromDate').val(), jQuery('#txtToDate').val(), con, onSucessExport, onFailure, con);
        }
        function onSucessExport(result, con) {
            if (con == 0) {
                if (result == 1)
                    window.open('../common/ExportToExcel.aspx');
                else
                    toast('Error',"No Record Found");
            }
            else {
                var CreditDebitNoteData = jQuery.parseJSON(result);
                jQuery('#tb_CreditDebitNote tr').slice(1).remove();
                if (CreditDebitNoteData != "") {
                    var mydata = [];
                    for (var i = 0; i <= CreditDebitNoteData.length - 1; i++) {

                        mydata.push("<tr>");
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">' + parseInt(i + 1) + '</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">' + CreditDebitNoteData[i].TransferBy + '</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">' + CreditDebitNoteData[i].TransferTo + '</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="right" style="font-size:12px;width:70px">' + CreditDebitNoteData[i].Amount + '</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:160px">' + CreditDebitNoteData[i].TransferDateTime + ' </td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">' + CreditDebitNoteData[i].TypeName + ' </td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">' + CreditDebitNoteData[i].IsReceive + ' </td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:60px">' + CreditDebitNoteData[i].IsReject + ' </td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:40px">' + CreditDebitNoteData[i].NoteType + ' </td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;width:160px">' + CreditDebitNoteData[i].Remarks + ' </td>');
                        mydata.push("</tr>");

                    }
                    mydata = mydata.join(" ");
                    jQuery("#tb_CreditDebitNote tr:first").after(mydata);
                }
                else {
                    toast('Error',"No Record Found");
                }
            }
            jQuery.unblockUI();
        }
        function onFailure() {

        }
    </script>
</asp:Content>

