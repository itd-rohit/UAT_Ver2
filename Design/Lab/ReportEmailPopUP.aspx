<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportEmailPopUP.aspx.cs" Inherits="Design_Lab_ReportEmailPopUP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<style type="text/css">
    .auto-style1
    {
        font-size: 9pt;
        font-family: Verdana, Arial, sans-serif, sans-serif;
        width: 196px;
        height: 20px;
    }

    .auto-style2
    {
        width: 256px;
        height: 20px;
    }

    .auto-style3
    {
        width: 200px;
        height: 20px;
    }

    .auto-style4
    {
        width: 268px;
        height: 20px;
    }
</style>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<script src="../../Scripts/jquery-3.1.1.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript">
        $(function () {
	
            if (parseInt($('#<%=txtReportApprovedQty.ClientID%>').val()) == 0) {
                $('#<%=lblApproved.ClientID%>').html("Reports Not Approved");
                $('#btnSend').attr('disabled', 'disabled');
                $('#btnCancel').attr('disabled', 'disabled');
            }
            else {
                if ($('[id$=hdnIsDue]').val() == "0") {
                    $('#<%=lblApproved.ClientID%>').html("");
                    $('#btnSend').removeAttr('disabled');
                    $('#btnCancel').removeAttr('disabled');
                }
            }
            EmailStatus();
        });
        function setEmail() {
            var Type = $('#<%=rdoEmailCat.ClientID%> :checked').val(); 
            if (Type == "Patient") {
                $('#<%=txtEmailID.ClientID%>').val($('#<%=txtPatientEmailID.ClientID%>').val());
            }
            else if (Type == "Doctor") {
                $('#<%=txtEmailID.ClientID%>').val($('#<%=txtDoctorEmailID.ClientID%>').val());
            }
            else if (Type == "Client") {
                $('#<%=txtEmailID.ClientID%>').val($('#<%=txtClientEmailID.ClientID%>').val());
            }
        }
        function EmailStatus() {
            $('#tblEmailStatus tr').slice(1).remove();
            $.ajax({
                url: "ReportEmailPopUP.aspx/EmailStatusData",
                data: '{ VisitNo:"' + $('#<%=txtVisitNo.ClientID%>').val() + '"}', // parameter map 
               type: "POST", // data has to be Posted    	        
               contentType: "application/json; charset=utf-8",
               timeout: 120000,
               dataType: "json",
               success: function (result) {
                   EmailStatusData = jQuery.parseJSON(result.d);
                   if (EmailStatusData.length == 0) {
                       $('#divEmailStatus').hide();
                   }
                   else {
                       for (var i = 0; i <= EmailStatusData.length - 1; i++) {
                           var mydata = "<tr>";
                           mydata += '<td class="GridViewLabItemStyle" >' + (i + 1) + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].LedgerTransactionNo + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].PName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].MailType + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].IsSend + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].MailedTo + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].EmailID + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].Cc + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].Bcc + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].UserName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].dtEntry + '</td>';
                           mydata += "</tr>";
                           $('#tblEmailStatus').append(mydata);
                       }
                       $('#divEmailStatus').show();
                   }

               },
               error: function (xhr, status) {
               }
           });
       }
function validateEmail(email) {
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            return emailReg.test(email);
        }
       function sendMail() {
           if ($('#<%=txtEmailID.ClientID%>').val() == '') {
                alert('Please Enter Email ID');
                $('#<%=txtEmailID.ClientID%>').focus();
                return;
            }
            else {
                if (validateEmail($('#<%=txtEmailID.ClientID%>').val()) == false) {
                    alert('Please Enter Valid Email ID');
                    $('#<%=txtEmailID.ClientID%>').focus();
                    return;
                }
            }
            if ($('#<%=txtCc.ClientID%>').val() != '') {                
                if (validateEmail($('#<%=txtCc.ClientID%>').val()) == false) {
                    alert('Please Enter Valid Cc Email');
                    $('#<%=txtCc.ClientID%>').focus();
                    return;
                }
            }

            if ($('#<%=txtBcc.ClientID%>').val() != '') {                
                if (validateEmail($('#<%=txtBcc.ClientID%>').val()) == false) {
                    alert('Please Enter Valid Bcc Email');
                    $('#<%=txtBcc.ClientID%>').focus();
                    return;
                }
            }
           $('#btnSend').attr('value', 'Sending..');
           $('#btnSend,#btnCancel').attr('disabled', 'disabled');

 var FromPUPPortal = '<%=FromPUPPortal%>';
            $.ajax({
                url: "ReportEmailPopUP.aspx/sendMail",
                data: '{ VisitNo:"' + $('#<%=txtVisitNo.ClientID%>').val() + '",EmailID:"' + $('#<%=txtEmailID.ClientID%>').val() + '",Cc:"' + $('#<%=txtCc.ClientID%>').val() + '",Bcc:"' + $('#<%=txtBcc.ClientID%>').val() + '",MailedTo:"' + $('#<%=rdoEmailCat.ClientID%> :checked').val() + '",FromPUPPortal:"'+FromPUPPortal+'"}', // parameter map 
               type: "POST", // data has to be Posted    	        
               contentType: "application/json; charset=utf-8",
               timeout: 120000,
               dataType: "json",
               success: function (result) {
                   DataResult = jQuery.parseJSON(result.d);
                   if (DataResult == '1') {
                       alert('Email Sent.');                                         
                       $('#<%=txtCc.ClientID%>').val('');
                       $('#<%=txtBcc.ClientID%>').val('');
                   }
                   else {
                       alert('Email Not Sent');
                   }
                   EmailStatus();
                   $('#btnSend').attr('value', 'Send');
                   $('#btnSend,#btnCancel').removeAttr('disabled');
               },
               error: function (xhr, status) {
                   alert("Error ");
                   $('#btnSend').attr('value', 'Send');
                   $('#btnSend,#btnCancel').removeAttr('disabled');
               }
           });
       }

        function DisableSend()
        {
            $('[id$=btnSend]').attr('disabled', 'disabled');
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 1005px;">
            <div class="POuter_Box_Inventory" style="width: 1000px;">
                <div class="Purchaseheader">Email</div>
                <div style="margin-left: 350px;">
                    <asp:RadioButtonList ID="rdoEmailCat" runat="server" RepeatDirection="Horizontal" Font-Bold="True" onchange="setEmail();">
                        <asp:ListItem Text="To Patient" Value="Patient" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="To Doctor" Value="Doctor"></asp:ListItem>
                        <asp:ListItem Text="To Client" Value="Client"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <table style="width: 100%; height: 80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblEmailSend">

                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <asp:Label ID="lblApproved" runat="server" CssClass="ItDoseLblError"></asp:Label>
                            <asp:HiddenField ID="hdnIsDue" runat="server" Value="0" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%; text-align: right;"><b>To</b></td>
                        <td style="width: 60%; text-align: left;">
                            <asp:TextBox ID="txtEmailID" runat="server" Width="185px"></asp:TextBox>
                            <asp:TextBox ID="txtVisitNo" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtPatientEmailID" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtDoctorEmailID" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtClientEmailID" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtReportApprovedQty" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
			    <asp:TextBox ID="txtPanelType" runat="server" Width="185px" Style="display: none;"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 40%; text-align: right;"><b>Cc</b></td>
                        <td style="width: 60%; text-align: left;">
                            <asp:TextBox ID="txtCc" runat="server" Width="185px"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <td style="width: 40%; text-align: right;"><b>Bcc</b></td>
                        <td style="width: 60%; text-align: left;">
                            <asp:TextBox ID="txtBcc" runat="server" Width="185px"></asp:TextBox></td>
                    </tr>
		    <tr>
		    <td colspan="2"> <span style="color:red;font-weight:bold;">&nbsp; 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
*To send multiple recipients, put a comma between the email addresses of the recipients.</span></td>
		    </tr>
                    <tr>
                        <td style="width: 40%;"></td>
                        <td style="width: 60%; text-align: left;">
                            <input type="button" value="Send " class="savebutton" onclick="sendMail();" style="width: 100px;" id="btnSend" />
                            <input type="button" value="Cancel" class="savebutton" onclick=" HideDialog(true);" style="width: 95px;" id="btnCancel" /></td>


                    </tr>
                </table>
                <div style="overflow: scroll; display: none; height: 100px;" id="divEmailStatus">
                    <table style="width: 1750px; border: 0px;" cellpadding="3" cellspacing="0" id="tblEmailStatus" class="GridViewStyle">
                        <tr>
                            <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 100px;">Visit No.</td>
                            <td class="GridViewHeaderStyle" style="width: 300px;">Name</td>
                            <td class="GridViewHeaderStyle" style="width: 70px;">Mail Type</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;">Status</td>
                            <td class="GridViewHeaderStyle" style="width: 300px;">Mailed To</td>
                            <td class="GridViewHeaderStyle" style="width: 300px;">To</td>
                            <td class="GridViewHeaderStyle" style="width: 300px;">Cc</td>
                            <td class="GridViewHeaderStyle" style="width: 300px;">Bcc</td>
                            <td class="GridViewHeaderStyle" style="width: 200px;">User Name</td>
                            <td class="GridViewHeaderStyle" style="width: 200px;">Sent Date</td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>

    </form>
</body>
</html>
