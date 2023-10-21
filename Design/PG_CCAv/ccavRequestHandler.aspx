<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ccavRequestHandler.aspx.cs" Inherits="Design_PaymentGateWay_ccavRequestHandler" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="nonseamless" method="post" name="redirect" action=" https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction">
        <input type="hidden" id="encRequest" name="encRequest" value="<%=strEncRequest%>" />
        <input type="hidden" name="access_code" id="access_code" value="<%=strAccessCode%>" />
    </form>
    <script type="text/javascript" language="javascript">document.redirect.submit();</script>
     <%-- for Lve https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction --%>
</body>
</html>
