<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PaymentResponse.aspx.cs" Inherits="Design_PaymentGateWay_PaymentResponse" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Payment Response</title>
    <script language="javascript" type="text/javascript">
        window.history.forward(1);
    </script>
    <link href="~/Design/Purchase/PurchaseStyle.css" rel="stylesheet" type="text/css" />

</head>
<body>
     <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="text-align: center; background-color: lightyellow">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <h1>Payment Response</h1>
                    <br />
                    <br />
                    <asp:Label ID="lblerrortrnx" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
               
				<fieldset><legend style="color:green">Transaction Details </legend>
                    <table>
                        <tr>
                            <td style="color:green;font-size:12px">Order Status </td>
<td><b> :</b></td>
                             <td><asp:Label ID="lblOrderStatus" runat="server"  /></td>
                        </tr>
                        <tr>
                            <td style="color:green;font-size:12px">Order ID </td>
<td><b> :</b></td>
                             <td><asp:Label ID="lblOrderId" runat="server"  /></td>
                        </tr>
                        <tr>
                            <td style="color:green;font-size:12px">Transaction Amount </td>
<td><b> :</b></td>
                             <td><asp:Label ID="lbltransactionamount" runat="server"  /></td>
                        </tr>
<tr>
                            <td style="color:green;font-size:12px">Transaction Date </td>
<td><b> :</b></td>
                             <td><asp:Label ID="lbltransactionDate" runat="server"  /></td>
                        </tr>
                    </table>
                        </fieldset> </div>
            </div>
            <div class="POuter_Box_Inventory">
                <a href="../Welcome.aspx" id="btnHome" class="savebutton">OK</a>
               <%-- <asp:Button ID="btnHome" runat="server" CssClass="savebutton" Text="Home" CommandName="Home" />--%>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnReceipt" Style="display: none" runat="server" CssClass="PrintButton" Text="View your payment history." CommandName="Receipt" />

            </div>
        </div>
    </form>
</body>
</html>
