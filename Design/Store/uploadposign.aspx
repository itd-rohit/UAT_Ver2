<%@ Page Language="C#" AutoEventWireup="true" CodeFile="uploadposign.aspx.cs" Inherits="Design_Store_uploadposign" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label><br />

    <strong>Select File:</strong>
    <asp:FileUpload ID="fu_Upload" runat="server"  />
    <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" onclick="btnSave_Click"    ValidationGroup="fUpload"  />

          <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
        ErrorMessage="*"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server"   ValidationGroup="fUpload" ForeColor="Red" 
ControlToValidate="fu_Upload" Display="Dynamic" 
ErrorMessage=""
ValidationExpression="[a-zA-Z\\].*(.jpg|.JPG|.jpeg|.JPEG|)$"></asp:RegularExpressionValidator>
        <asp:Label ID="Label1" runat="server" ForeColor="Red" Text="<br/>Note:- <br/>1. Only .jpeg files is allowed.<br/>2. Maximum file size upto 10 MB."></asp:Label>


    </div>
    </form>
</body>
</html>
