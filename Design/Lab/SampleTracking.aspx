<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SampleTracking.aspx.cs" Inherits="Design_Lab_SampleTracking" %>

<!DOCTYPE html>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sample Status</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 836px;vertical-align:top;margin:-0px">
            <div class="POuter_Box_Inventory" style="width: 830px; text-align: center;">
                <b>Sample Status</b>
            </div>
            <div style="text-align: center;">
                <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="width: 830px">
                <div  class="row">
                <div class="Purchaseheader">
                    <asp:Label ID="lbinfo" runat="server"></asp:Label>
                </div>
                    </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 830px">
                  <div  class="row">
                <div style="width: 99%; height: 300px; overflow:auto;">

                    <asp:GridView ID="grd" Width="99%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">

                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="EntryDate" HeaderText="Entry Date Time" ItemStyle-Width="170px" />
                            <asp:BoundField DataField="EntryBy" HeaderText="Entry By" ItemStyle-Width="200px" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                            <asp:BoundField DataField="CentreName" HeaderText="CentreName" />
                        </Columns>
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                        <RowStyle ForeColor="#000066" />
                        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#F1F1F1" />
                        <SortedAscendingHeaderStyle BackColor="#007DBB" />
                        <SortedDescendingCellStyle BackColor="#CAC9C9" />
                        <SortedDescendingHeaderStyle BackColor="#00547E" />

                    </asp:GridView>

                </div>
                      </div>
            </div>
        </div>

    </form>
</body>
</html>
