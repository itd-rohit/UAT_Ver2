<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowRemarks.aspx.cs" Inherits="Design_Lab_ShowRemarks" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" /> 
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
     <div id="Pbody_box_inventory" style="width:750px;">
         <div class="Purchaseheader" >Remarks</div> <br />
   <asp:TextBox ID="txtremarks" runat="server" Width="720px"></asp:TextBox>
         <br />
         <br />
         <asp:Button ID="btnsave" runat="server" Text="Update" CssClass="savebutton" OnClick="btnsave_Click" />
    </div>
    </form>
</body>
</html>
