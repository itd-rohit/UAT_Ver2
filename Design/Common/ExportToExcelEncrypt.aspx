﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ExportToExcelEncrypt.aspx.cs" Inherits="Design_Common_ExportToExcelEncrypt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <span style="font-size: 12pt">
            <asp:ImageButton ToolTip="Export To Excel" ImageUrl="~/App_Images/excelexport.gif" ID="btnExport" runat="server" OnClick="btnExport_Click" Height="16px" Width="16px" /><br />
                    <asp:Label ID="Label1" Font-Size="Small" runat="server" Text="Export To Excel"></asp:Label>
                    &nbsp; &nbsp;&nbsp;
                   
                    <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span></div>
           
        
        <div class="POuter_Box_Inventory" style="margin:[10px][10px][10px][10px][10px]">
            <table border="0" style="width: 100%">
                <tr>
                    <td colspan="5" style="height: 29px; text-align: center; width: 968px;">
                       
                        <asp:Label ID="lblHeader" runat="server" Font-Bold="True" Font-Size="X-Large"></asp:Label></td>
                </tr>
                 
                <tr>
                    <td colspan="5" style="height: 26px; text-align: center; width: 968px;">
                        <asp:Label ID="lblPeriod" runat="server" Font-Bold="True" Font-Size="Medium"></asp:Label></td>
                </tr>
         
               
                
            </table>
        </div>
        
                                      
    </div>
    </form>
</body>

</html>
