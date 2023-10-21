<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateZIP.aspx.cs" Inherits="Design_Master_CreateZIP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="text-align: center;">
        <div class="POuter_Box_Inventory">

            <b>Create BackUp</b><br />
            <asp:Label ID="lblError" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <br />
            <asp:Button ID="btnZip" runat="server" Text="Create BackUp" CssClass="ItDoseButton" OnClick="btnZip_Click" />
        </div>
    </div>
    <script type="text/javascript">
        
    </script>
</asp:Content>
