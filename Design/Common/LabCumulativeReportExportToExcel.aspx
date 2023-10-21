<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeFile="LabCumulativeReportExportToExcel.aspx.cs" Inherits="Design_Common_ExportToExcel" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 

    <title>Untitled Page</title>
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
         
                <tr>
                    <td colspan="5" style="height: 18px; width: 968px;">
                    <asp:GridView  ID="EmployeeGrid" HeaderStyle-VerticalAlign="Top" runat="server" CssClass="exporttoexcel">
                        <HeaderStyle cssclass="exporttoexcelheader" VerticalAlign="Top" />
                    </asp:GridView>
                    
                    </td>
                </tr>
                
            </table>
        </div>
        
                                      
    </div>
    </form>
   
</body>
</html>
