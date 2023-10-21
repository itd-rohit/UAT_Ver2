<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorItemIssueDetail.aspx.cs" Inherits="Design_Store_VendorPortal_VendorItemIssueDetail" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
   <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:1004px;">
            <div class="POuter_Box_Inventory" style="width:1000px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Item Issue Detail</b>  
                            <br />
                            <strong>Purchase Order No :</strong>&nbsp;&nbsp; <asp:Label ID="lbpono" runat="server" style="font-weight: 700" />
                           
                            <br />
                           
                             <strong>Item Name :</strong>&nbsp;&nbsp; <asp:Label ID="lblitemname" runat="server" style="font-weight: 700" />
                           <br />
                            <strong>Order Qty :</strong>&nbsp;&nbsp; <asp:Label ID="lblorderqty" runat="server" style="font-weight: 700" />
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

        <div class="POuter_Box_Inventory" style="width:1000px;">
            <div class="content">

                <div style="width:990px;overflow:scroll">

               
                <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4" AutoGenerateColumns="False">
                    
                    <columns>
		<asp:templatefield headertext="Sr.No.">
			<itemtemplate>
				<%# Container.DisplayIndex + 1 %>
			</itemtemplate>
		</asp:templatefield>
                         <asp:BoundField DataField="InvoiceNo" HeaderText="InvoiceNo" />
                        <asp:BoundField DataField="Courierdetail" HeaderText="Courierdetail" />
                           <asp:BoundField DataField="AWBNumber" HeaderText="AWBNumber" />
                         <asp:BoundField DataField="InvoiceDate" HeaderText="Invoicedate" />
	                    <asp:BoundField DataField="IssueDate" HeaderText="IssueDate" />
                         <asp:BoundField DataField="DispatchDate" HeaderText="DispatchDate" />
                        <asp:BoundField DataField="IssueQty" HeaderText="IssueQty" ItemStyle-Font-Bold="true" />
                        <asp:TemplateField HeaderText="Invoice">
                           
                            <ItemTemplate>
                              
                                <a href="#" style="font-weight:bold;" onclick="window.open('AddFile.aspx?Type=1&Filename=<%# Eval("InvoiceNo")%>',null,'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no')"><%# Eval("InvoiceNo")%></a>

                                
                            </ItemTemplate>
                        </asp:TemplateField>
	</columns>
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
            </div>
    
    </div>
    </form>
</body>
</html>
