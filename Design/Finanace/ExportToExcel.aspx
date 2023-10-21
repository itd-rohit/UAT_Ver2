<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="ExportToExcel.aspx.cs" Inherits="Design_Finanace_ExportToExcel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
<link href="../../Design/Purchase/PurchaseStyle.css" rel="stylesheet" type="text/css" />

    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    
   
   
    <div id="Pbody_box_inventory">
        <div class="Outer_Box_Inventory" style="width: 99.7%">
            <div class="content" style="text-align: center;">
                <span style="font-size: 12pt">
            <asp:ImageButton ToolTip="Export To Excel" ImageUrl="~/Design/Purchase/Image/excelexport.gif" ID="btnExport" runat="server" OnClick="btnExport_Click" Height="16px" Width="16px" /><br />
                    <asp:Label ID="Label1" Font-Size="Small" runat="server" Text="Export To Excel"></asp:Label>
                    &nbsp; &nbsp;&nbsp;
                   
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span></div>
            </div>
        
        <div class="Outer_Box_Inventory" style="width: 99.7%; margin:[10px][10px][10px][10px][10px]">
            <table border="0" style="width: 100%">
                <tr>
                    <td colspan="5" style="height: 29px; text-align: center; width: 968px;">
                       <%-- <asp:CheckBoxList CellPadding="0" CellSpacing="0" RepeatDirection="horizontal"  ID="chklOther" runat="server">
                        <asp:ListItem Text="Basic" Value="Basic"></asp:ListItem>
                       <%-- <asp:ListItem Text="Total Earning" Value="Earning"></asp:ListItem>
                        <asp:ListItem Text="Total Deduction" Value="Deduction"></asp:ListItem>
                        <asp:ListItem Text="NetPayable" Value="NetPayable"></asp:ListItem>
                        </asp:CheckBoxList>--%>
                        <asp:Label ID="lblHeader" runat="server" Font-Bold="True" Font-Size="X-Large"></asp:Label></td>
                </tr>
                 
                <tr>
                    <td colspan="5" style="height: 26px; text-align: center; width: 968px;">
                        <asp:Label ID="lblPeriod" runat="server" Font-Bold="True" Font-Size="Medium"></asp:Label></td>
                </tr>
         <%--<tr>
             <td style="width: 21%; height: 18px;">
             </td>
             <td style="width: 18%; height: 18px;">
             </td>
             <td style="width: 20%; height: 18px;" align="center">
                 </td>
             <td style="width: 20%; height: 18px;">
             </td>
             <td style="width: 25%; height: 18px;">
             </td>
           
         </tr>--%>
                <tr>
                    <td colspan="5" style="height: 18px; width: 968px;">
                    <asp:GridView  ID="EmployeeGrid" HeaderStyle-VerticalAlign="Top" runat="server" CssClass="exporttoexcel">
                        <HeaderStyle cssclass="exporttoexcelheader" VerticalAlign="Top" />
                    </asp:GridView>
                    <%--<asp:Panel ID="pnl" runat="server" ScrollBars="Auto" Width="968px" Height="490">
                    
                    </asp:Panel>--%>
                    </td>
                </tr>
                
            </table>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.7%">
            <div class="content" style="text-align: center;">
           
                &nbsp;</div>
         </div>
                                      
    </div>
    </form>
   
</body>
</html>
