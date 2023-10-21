<%@ Page Title="Change Payment Mode" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangePaymentMode.aspx.cs" Inherits="Design_Lab_ChangePaymentMode" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

  
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
     
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">

               <div class="col-md-24">
                            <asp:Label ID="llheader" runat="server" Text="Change Payment Mode" Font-Size="16px" Font-Bold="true"></asp:Label>
                   </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-6"></div>
                <div class="col-md-6"><b>Visit No :&nbsp;</b>

                     <asp:TextBox ID="txtLabNo" runat="server" Width="200px" MaxLength="15" class="requiredField" type="text" data-title="Enter Visit No" placeholder="Enter Visit No To Search"></asp:TextBox>

                </div>
                <div class="col-md-12">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata('BT')" style="width: 195px;" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details&nbsp;
            </div>
           <div class="row">
                 <div class="col-md-3">
                       </div>
             <div class="col-md-3"><b>Patient ID :</b>
                       </div>
             <div class="col-md-6"><asp:Label ID="lblPatientID" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4"><b>Patient Name:</b>
                       </div>
             <div class="col-md-4"><asp:Label ID="lblName" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4">
                       </div>
            </div>


             <div class="row">
                 <div class="col-md-3">
                       </div>
             <div class="col-md-3"><b>Age / Gender:</b>
                       </div>
             <div class="col-md-6"> <asp:Label ID="lblAge" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4"><b>Amount Paid:</b>
                       </div>
             <div class="col-md-4"><asp:Label ID="lblAmtPaid" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4">
                       </div>
            </div>



            <div class="row">
                 <div class="col-md-3">
                       </div>
             <div class="col-md-3"><b>Doctor:</b>
                       </div>
             <div class="col-md-6"> <asp:Label ID="lblDoctor" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4"><b>Net AMount:</b>
                       </div>
             <div class="col-md-4"><asp:Label ID="lblNetAmt" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4">
                       </div>
            </div>

            <div class="row">
                 <div class="col-md-3">
                       </div>
             <div class="col-md-3"><b>Due Amount:</b>
                       </div>
             <div class="col-md-6"> <asp:Label ID="lblDueAmt" runat="server" CssClass="PatientLabel" ForeColor="Red" Font-Bold="true"></asp:Label>
                       </div>
             <div class="col-md-4"><b>Visit No:</b>
                       </div>
             <div class="col-md-4">  <asp:Label ID="lblLabNoToSave" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4">
                       </div>
            </div>



            <div class="row" style="display: none;">
                 <div class="col-md-3">
                       </div>
             <div class="col-md-3"><b>Receipt No:</b>
                       </div>
             <div class="col-md-6"> <asp:Label ID="lblReceiptNo" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4"><b>Lab ID:</b>
                       </div>
             <div class="col-md-4">   <asp:Label ID="lblLabID" runat="server" CssClass="PatientLabel"></asp:Label>
                        <asp:Label ID="lblCentreID" runat="server" CssClass="PatientLabel"></asp:Label>
                       </div>
             <div class="col-md-4">
                       </div>
            </div>

            <div class="row" >
                <div class="col-md-8">
                    </div>
                 <div class="col-md-16">
                      <asp:RadioButtonList ID="rdoChangePaymentMode" runat="server" RepeatDirection="Horizontal" onchange="getReceiptData();">
                            <asp:ListItem Text="Main Booking" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Receipt" Value="2" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                       </div>
                </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Reciept Details
            </div>
            <div class="row">
                <div class="col-md-24">
                     <table style="width: 100%" cellspacing="0" id="tblReceipt" class="GridViewStyle">
                <tr>
                    <td class="GridViewHeaderStyle" style="text-align: center;">#</td>
                    <td class="GridViewHeaderStyle" style="text-align: center;">Receipt No</td>
                    <td class="GridViewHeaderStyle" style="text-align: center;">Amount</td>
                    <td class="GridViewHeaderStyle" style="text-align: center;">Payment Mode</td>
                    <td class="GridViewHeaderStyle" width="100px" style="text-align: center;">Select</td>
                </tr>
            </table>
                </div>
            </div>
           
        </div>
        <div id="divReceiptData" style="display: none;">
            <table style="width: 400px" id="tblPaymentModeDetails">
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trMode">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Mode :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:Label ID="lblMode" runat="server" Text="Cash To Credit" Font-Bold="true" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trPaymentMode">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Payment Mode :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:DropDownList ID="ddlPaymentMode" runat="server" Width="250px" onchange="setPaymentMode();">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trBank">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Bank Name :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:DropDownList ID="ddlBank" runat="server" Width="250px">
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trTransactionID">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Transaction ID :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtTransactionID" runat="server" MaxLength="20" placeholder="Enter Transaction ID" Width="245px"></asp:TextBox>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trCardNo">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Card/Cheque No :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtCardNo" runat="server" MaxLength="20" placeholder="Enter Card No" Width="245px"></asp:TextBox>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trCardDate">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Card/Cheque Date: :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtCardDate" runat="server" Width="245px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtCardDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif" id="trPayTM">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Mobile No.: :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtPayTMMobileNo" runat="server" Width="245px" MaxLength="10"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPayTM" runat="server" TargetControlID="txtPayTMMobileNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Naration :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtNaration" runat="server" MaxLength="150" placeholder="Enter Naration" Width="245px"></asp:TextBox>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif; display: none;">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Receipt ID :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtReceiptID" runat="server" Width="245px" disabled></asp:TextBox>
                    </td>
                </tr>
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif; display: none;">
                    <td align="right" class="ItDoseLabel" style="width: 200px; height: 13px" valign="middle">
                        <b>Prev Payment Mode ID :</b>
                    </td>

                    <td align="right" class="ItDoseLabel" style="width: 250px; height: 13px; text-align: left"
                        valign="middle">
                        <asp:TextBox ID="txtPrevPaymentModeID" runat="server" Width="245px" disabled></asp:TextBox>
                    </td>
                </tr>
            </table>
            <div style="text-align: center;">
                <input type="button" value="Save" id="btnsave" class="searchbutton" onclick="SaveData();" style="width: 195px; margin-left: 25px;" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $("#<%=txtCardDate.ClientID%>").datepicker({
            dateFormat: "dd-M-yy",
            changeMonth: true,
            changeYear: true, yearRange: "-20:+0"
        });

        function getData() {
            var TypeToPerform = $('#ContentPlaceHolder1_rdoChangePaymentMode input[type=radio]:checked').val();
            var PayMode = $('#<%=ddlPaymentMode.ClientID%> option:selected').text();
            var PayModeID = $('#<%=ddlPaymentMode.ClientID%>').val();
            if (TypeToPerform == "1") {
                if ($('#<%= lblMode.ClientID%>').html().trim() == "Cash To Credit") {
                    PayMode = "Cash";
                    PayModeID = "1";
                }
                else {
                    PayMode = "Credit";
                    PayModeID = "4";
                }
            }
            var Objlt = new Object();
            Objlt.PatientID = $('#<%= lblPatientID.ClientID%>').html();
            Objlt.CentreID = $('#<%= lblCentreID.ClientID%>').html();
            Objlt.LedgerTransactionID = $('#<%= lblLabID.ClientID%>').html();
            Objlt.VisitNo = $('#<%= lblLabNoToSave.ClientID%>').html();
           
            Objlt.PaymentMode = PayMode;
            Objlt.PaymentModeID = PayModeID;
            Objlt.Bank = $('#<%=ddlBank.ClientID%>').val();

            if ($('#<%=ddlPaymentMode.ClientID%>').val() == "8")
                Objlt.CardNo = $('#<%=txtPayTMMobileNo.ClientID%>').val();
            else
                Objlt.CardNo = $('#<%=txtCardNo.ClientID%>').val();

            Objlt.TransactionID = $('#<%=txtTransactionID.ClientID%>').val();
            Objlt.CardDate = $('#<%=txtCardDate.ClientID%>').val();
            Objlt.Naration = $('#<%=txtNaration.ClientID%>').val();
            Objlt.ReceiptID = $('#<%=txtReceiptID.ClientID%>').val();
            Objlt.TypeToPerform = TypeToPerform;
            return Objlt;
        }

        function Validation() {
            
            var TypeToPerform = $('#ContentPlaceHolder1_rdoChangePaymentMode input[type=radio]:checked').val();
            if (TypeToPerform == "2") {
                if ($('#<%=txtReceiptID.ClientID%>').val() == "" || $('#<%= lblLabNoToSave.ClientID%>').html() == "") {

                    toast("Error", "please enter visit number..!", "");
                    return false;
                }
                if ($('#<%=ddlPaymentMode.ClientID%>').val() == "") {
                    toast("Error", "Please Select Any Payment Mode..!", "");
                    return false;
                }
                if ($('#<%=ddlPaymentMode.ClientID%>').val() != "1" && $('#<%=ddlPaymentMode.ClientID%>').val() != "4" && $('#<%=ddlPaymentMode.ClientID%>').val() != "8") {
                    if ($('#<%=ddlBank.ClientID%>').val() == "") {
                        toast("Error", "Please Select Any Bank..!", "");
                        return false;
                    }
                    if ($('#<%=txtCardNo.ClientID%>').val() == "") {
                        toast("Error", "Please Enter Card/ Cheque No..!", "");
                        return false;
                    }
                    if ($('#<%=txtTransactionID.ClientID%>').val() == "") {
                        toast("Error", "Please Enter Transaction ID..!", "");
                        return false;
                    }
                    if ($('#<%=txtCardDate.ClientID%>').val() == "") {
                        toast("Error", "Please Select Card/ Cheque Date..!", "");
                        return false;
                    }
                }
                if ($('#<%=ddlPaymentMode.ClientID%>').val() == "8" && $('#<%=txtPayTMMobileNo.ClientID%>').val() == "") {
                    toast("Error", "Please Enter PayTM Mobile No.", "");
                    $('#<%=txtPayTMMobileNo.ClientID%>').focus();
                    return false;
                }
            }
            if ($('#<%=txtNaration.ClientID%>').val() == "") {
                toast("Error", "Please Enter Naration..!", "");
                return false;
            }
            return true;
        }

        function SaveData() {
            if (Validation() == false)
                return;
            var LTData = getData();
            if (LTData == "")
                return;
            if (confirm("Do You Want To change ChangePaymentMode ") == false) {
                $("#btnsave").attr('disabled', false);
                return;
            }
            $("#btnsave").attr('disabled', true);
            serverCall('ChangePaymentMode.aspx/SaveData', { LTData: LTData }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status == true) {
                    clearAllTextBox();
                    clearAllLabel();
                    toast("Success", "Payment Mode Changed Successfully..!", "");
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
            });
        }

        function showPaymentModeDiv(ReceiptNo, PaymentModeID) {
            $('#divReceiptData').show();
            if ($('#ContentPlaceHolder1_rdoChangePaymentMode input[type=radio]:checked').val() == "1") {
                $('#tblPaymentModeDetails tr#trBank,tr#trCardNo,tr#trCardDate,tr#trPaymentMode,tr#trPayTM,tr#trTransactionID').hide();
                $('#tblPaymentModeDetails tr#trMode').show();
                if (PaymentModeID == "1") {
                    $('#<%=lblMode.ClientID%>').html('Cash To Credit');
                }
                else {
                    $('#<%=lblMode.ClientID%>').html('Credit To Cash');
                }
            }
            else {
                setPaymentMode();
            }
            $('#<%=txtReceiptID.ClientID%>').val(ReceiptNo);
            $('#<%=txtPrevPaymentModeID.ClientID%>').val(PaymentModeID);

        }
        function setPaymentMode() {
            if ($('#<%=ddlPaymentMode.ClientID%>').val() == "1" || $('#<%=ddlPaymentMode.ClientID%>').val() == "4" || $('#<%=ddlPaymentMode.ClientID%>').val() == "") {
                $('#tblPaymentModeDetails tr#trBank,tr#trCardNo,tr#trCardDate,tr#trMode,tr#trPayTM,tr#trTransactionID').hide();
                $('#tblPaymentModeDetails tr#trPaymentMode').show();
            }
            else if ($('#<%=ddlPaymentMode.ClientID%>').val() == "8") {
                $('#tblPaymentModeDetails tr#trBank,tr#trCardNo,tr#trCardDate,tr#trMode,,tr#trTransactionID').hide();
                $('#tblPaymentModeDetails tr#trPaymentMode,tr#trPayTM').show();
            }
            else {
                $('#tblPaymentModeDetails tr#trBank,tr#trCardNo,tr#trCardDate,tr#trPaymentMode,tr#trTransactionID').show();
                $('#tblPaymentModeDetails tr#trMode,tr#trPayTM').hide();
            }
        }
        function getReceiptData() {
            $('#divReceiptData').hide();
            $('#tblReceipt tr').slice(1).remove();
            var VisitNo = $('#<%= lblLabNoToSave.ClientID%>').html();
 
            serverCall('ChangePaymentMode.aspx/getReceiptData', { VisitNo: VisitNo }, function (response) {

                ReceiptData = JSON.parse(response);
                if (ReceiptData.length != 0) {
                    for (var i = 0; i <= ReceiptData.length - 1; i++) {
                        var mydata = [];
                        mydata.push("<tr>");
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(ReceiptData[i].ReceiptNo); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(ReceiptData[i].Amount); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(ReceiptData[i].PaymentMode); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;"><img src="../../App_Images/Post.gif" style="cursor:pointer;" onclick="showPaymentModeDiv(' + ReceiptData[i].ID + ',' + ReceiptData[i].PaymentModeID + ');" /></td>');
                        mydata.push('</tr>');
                        mydata = mydata.join('');
                        $('#tblReceipt').append(mydata);
                    }
                }
                else {
                    $('#<%=rdoChangePaymentMode.ClientID %>').find("input[value='1']").prop("checked", true);
                    $('#divReceiptData').show();
                    $('#tblPaymentModeDetails tr#trBank,tr#trCardNo,tr#trCardDate,tr#trPaymentMode,tr#trPayTM,tr#trTransactionID').hide();
                    $('#tblPaymentModeDetails tr#trMode').show();
                    $('#<%=lblMode.ClientID%>').html('Credit To Cash');
                    return false;
                }
                clearAllTextBox();
                $modelUnBlockUI(function () { });
            });  
        }
        function searchdata(callFrom) {
            $('#<%=rdoChangePaymentMode.ClientID %>').find("input[value='2']").prop("checked", true);
            var LabNo = "";
            if (callFrom.trim() == 'BT') {
                LabNo = $('#<%= txtLabNo.ClientID%>').val();
            }
            else {
                LabNo = $('#<%= lblLabNoToSave.ClientID%>').html();
            }

            serverCall('ChangePaymentMode.aspx/searchdata', { LabNo: LabNo }, function (response) {

                TestData = JSON.parse(response);
                if (TestData == "-1") {
                    toast("Error", "Time is expired . You cannot  Change Payment Mode..!", "");
                    $('#btnSave,.divDiscount').hide();
                    return false;
                }
            else  if (TestData.length != 0) {
                    clearAllLabel();
                    // Patient Personal Details
                    $('#<%= lblPatientID.ClientID%>').html(TestData[0].Patient_ID);
                     $('#<%= lblName.ClientID%>').html(TestData[0].PName);
                    $('#<%= lblAge.ClientID%>').html(TestData[0].Age + " " + TestData[0].Gender);
                    $('#<%= lblDoctor.ClientID%>').html(TestData[0].DoctorName);
                    $('#<%= lblAmtPaid.ClientID%>').html(TestData[0].Adjustment);
                    $('#<%= lblNetAmt.ClientID%>').html(TestData[0].NetAmount);
                    $('#<%= lblDueAmt.ClientID%>').html(parseInt(TestData[0].NetAmount) - parseInt(TestData[0].Adjustment));
                    $('#<%= lblLabNoToSave.ClientID%>').html(TestData[0].LedgerTransactionNo);
                    $('#<%= lblReceiptNo.ClientID%>').html(TestData[0].ReceiptNo);
                    $('#<%= lblLabID.ClientID%>').html(TestData[0].LedgerTransactionID);
                    $('#<%= lblCentreID.ClientID%>').html(TestData[0].CentreID);                  
                    getReceiptData();
                }
                else {
                    clearAllLabel();
                    toast("Error", "Record Not Found..!", "");
                    return false;
                }
                clearAllTextBox();
                $modelUnBlockUI(function () { });
            });   
        }

        function clearAllTextBox() {
            $(":text").val('');
            $("#btnsave").attr('disabled', false);
        }
        function clearAllLabel() {
            $('.PatientLabel').html('');
            $('#tblReceipt tr').slice(1).remove();
            $('#divReceiptData').hide();

        }     

    </script>   
</asp:Content>

