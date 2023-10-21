<%@ Page Language="C#" AutoEventWireup="true" CodeFile="output.aspx.cs" Inherits="Design_Dashboard_output" %>

<%@ Register assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" namespace="CrystalDecisions.Web" tagprefix="CR" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="background-color:red; color:white;font-weight:bold;">
        <asp:Label ID="lblMsg" runat="server" ></asp:Label>
        </div>
       
        <CR:CrystalReportViewer ID="cv" runat="server" AutoDataBind="true" />
       
    </form>
</body>
</html>
