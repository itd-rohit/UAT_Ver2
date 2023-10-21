<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowvendorQuotationDetail.aspx.cs" Inherits="Design_Store_ShowvendorQuotationDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 1090px;">

            <div class="POuter_Box_Inventory" style="width: 1090px;">
                <div class="content">
                    <table width="99%">
                        <tr>
                            <td align="center">
                                <asp:Label ID="llheader" runat="server" Text="Supplier Quotation Detail" Font-Size="16px" Font-Bold="true"></asp:Label></td>

                        </tr>
                        <tr>

                            <td align="center">
                                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                        </tr>

                    </table>

                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 1090px;">
                <div class="content" style="width: 1090px;">

                    <asp:FormView ID="grd1" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Both" Width="1000px">
                        <EditRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                        <ItemTemplate>
                            <table width="99%" cellspacing="2" cellpadding="2">

                                <tr>
                                    <td width="150px"><b>Qutationno:</b></td>
                                    <td width="350px"><%# Eval("Qutationno")%></td>

                                    <td width="150px"><b>Quotationrefno:</b></td>
                                    <td width="350px"><%# Eval("Quotationrefno")%></td>
                                </tr>



                                <tr>
                                    <td><b>Vendor Name:</b></td>
                                    <td><%# Eval("VendorName")%></td>
                                    <td><b>Vendor Address:</b></td>
                                    <td><%# Eval("VendorAddress")%></td>
                                </tr>




                                <tr>
                                    <td><b>State:</b></td>
                                    <td><%# Eval("VednorStateName")%></td>
                                    <td><b>Gstnno:</b></td>
                                    <td><%# Eval("VednorStateGstnno")%></td>
                                </tr>




                                <tr>
                                    <td><b>Delivery State:</b></td>
                                    <td><%# Eval("DeliveryStateName")%></td>

                                    <td><b>From Date:</b></td>
                                    <td><%# Eval("EntryDateFrom")%> &nbsp;&nbsp;<b>To Date:</b>&nbsp;&nbsp;<%# Eval("EntryDateTo")%></td>

                                </tr>



                                <tr>
                                    <td><b>Created By:</b></td>
                                    <td><%# Eval("CreatedBy")%></td>
                                    <td><b>Created Date:</b></td>
                                    <td><%# Eval("CreatedDate")%></td>
                                </tr>

                                <tr>
                                    <td><b>Checked By:</b></td>
                                    <td><%# Eval("CheckedBy")%></td>
                                    <td><b>Checked Date:</b></td>
                                    <td><%# Eval("CheckedDate")%></td>
                                </tr>

                                <tr>
                                    <td><b>Approved By:</b></td>
                                    <td><%# Eval("ApprovedBy")%></td>
                                    <td><b>Approved Date:</b></td>
                                    <td><%# Eval("ApprovedDate")%></td>
                                </tr>

                            </table>




                        </ItemTemplate>
                        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                        <RowStyle ForeColor="#000066" />
                    </asp:FormView>
                    <br />

                    <div style="width: 98%; overflow: auto; max-height: 400px;">
                        <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="DeliveryLocationName" HeaderText="DeliveryLocation" />
                                <asp:BoundField DataField="ItemCategoryName" HeaderText="ItemCategoryName" />
                                <asp:BoundField DataField="ItemName" HeaderText="ItemName" />
                                <asp:BoundField DataField="HSNCode" HeaderText="HSNCode" />
                                <asp:BoundField DataField="ManufactureName" HeaderText="ManufactureName" />
                                <asp:BoundField DataField="MachineName" HeaderText="MachineName" />
                                <asp:BoundField DataField="Rate" HeaderText="Rate" />



                                <asp:BoundField DataField="DiscountPer" HeaderText="DiscountPer" />
                                <asp:BoundField DataField="SGSTPer" HeaderText="SGSTPer" />
                                <asp:BoundField DataField="CGSTPer" HeaderText="CGSTPer" />
                                <asp:BoundField DataField="IGSTPer" HeaderText="IGSTPer" />
                                <asp:BoundField DataField="BuyPrice" HeaderText="BuyPrice" />
                                <asp:BoundField DataField="DiscountAmt" HeaderText="DiscountAmt" />
                                <asp:BoundField DataField="GSTAmount" HeaderText="GSTAmount" />
                                <asp:BoundField DataField="FinalPrice" HeaderText="FinalPrice" />

                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#007DBB" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#00547E" />
                        </asp:GridView>
                    </div>
                    <br />
                    <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
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

    </form>
</body>
</html>
