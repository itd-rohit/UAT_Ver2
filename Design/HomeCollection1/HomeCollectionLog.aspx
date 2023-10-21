<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomeCollectionLog.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />

</head>
<body style="width: 700px; background-color: lightblue;">
    <form id="form1" runat="server">
        <div class="row" style="text-align: center">
            <b>Log of PrebookingID :<%=Util.GetString(Util.GetString(Request.QueryString["prebookingid"])) %></b>
        </div>
        <div class="row">
            <div style="max-height: 800px; overflow: auto">
                <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4" Width="100%">
                    <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" HorizontalAlign="Left" />
                    <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                    <RowStyle BackColor="White" ForeColor="#330099" />
                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    <SortedAscendingCellStyle BackColor="#FEFCEB" />
                    <SortedAscendingHeaderStyle BackColor="#AF0101" />
                    <SortedDescendingCellStyle BackColor="#F6F0C0" />
                    <SortedDescendingHeaderStyle BackColor="#7E0000" />
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
