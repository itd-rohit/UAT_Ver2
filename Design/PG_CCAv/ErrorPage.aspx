<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ErrorPage.aspx.cs" Inherits="Design_PaymentGateWay_ErrorPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <center> <h1>Something Went Wrong Please try again!..</h1><br />

        <asp:Label ID="ErrorCode" runat="server" style="font-size:30px;color:red"  CssClass="ItDoseLblError" />
                <br/>
                <br/><br/><br/>
        <a href="../../Default.aspx">HOME</a></center>
            <!-- comment by HEMANT on 27-9-2019 -->

            <asp:label id="lblMsg" runat="server" forcolor="red" cssclass="ItDoseLblError" />
            <br />
        </div>
    </form>
</body>
</html>
