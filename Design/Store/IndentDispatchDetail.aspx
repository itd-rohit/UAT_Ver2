<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IndentDispatchDetail.aspx.cs" Inherits="Design_Store_IndentDispatchDetail" %>
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
    <div id="Pbody_box_inventory" style="width:900px;height:300px;">
         
          <div class="POuter_Box_Inventory" style="width:890px;">
            <div class="content">
                 <div class="Purchaseheader">
                     Item Dispatch Detail
                      </div>

                <table style="width:99%">
                    <tr>
                        <td>
                            <div style="width:98%; overflow:auto;">

                            <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4">
                                <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" />
                                <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                                <RowStyle BackColor="White" ForeColor="#330099" />
                                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                <SortedAscendingCellStyle BackColor="#FEFCEB" />
                                <SortedAscendingHeaderStyle BackColor="#AF0101" />
                                <SortedDescendingCellStyle BackColor="#F6F0C0" />
                                <SortedDescendingHeaderStyle BackColor="#7E0000" />
                            </asp:GridView>
                       </div> </td>
                    </tr>
                </table>
    
    </div>
              </div>

        </div>
    </form>
</body>
</html>
