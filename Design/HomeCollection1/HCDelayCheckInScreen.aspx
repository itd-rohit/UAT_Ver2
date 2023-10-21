<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HCDelayCheckInScreen.aspx.cs" Inherits="Design_HomeCollection_HCDelayCheckInScreen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width:100%">
    <asp:Label ID="lb" runat="server" Font-Bold="true" Font-Size="25px" ForeColor="Red"></asp:Label>
    <asp:GridView ID="grd" Width="100%" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None">
       <Columns>
           <asp:TemplateField HeaderText = "Sr No.">
              <ItemTemplate>
                        <%# Container.DataItemIndex + 1 %>
                    </ItemTemplate>
           </asp:TemplateField>
       </Columns>
        <AlternatingRowStyle BackColor="White" />
        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
        <SortedAscendingCellStyle BackColor="#FDF5AC" />
        <SortedAscendingHeaderStyle BackColor="#4D0000" />
        <SortedDescendingCellStyle BackColor="#FCF6C0" />
        <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    </div>
    </form>
</body>
</html>
