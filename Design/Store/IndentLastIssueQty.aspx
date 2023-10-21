<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IndentLastIssueQty.aspx.cs" Inherits="Design_Store_IndentLastIssueQty" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div id="show" runat="server">
    <table  style="width:400px;font-family:Arial; font-size:12px;border-collapse:collapse;"  >
        <tr style="background-color:#AEB6CB; font-weight:bold;">
            <td style="width:60px;text-align:center">Rate</td>
            <td style="width:60px;text-align:center">Tax(%)</td>
            <td style="width:60px;text-align:center">Disc(%)</td>
            <td style="width:80px;text-align:center">Last Issue Qty</td>
            <td style="width:80px;text-align:center">Last Issue Date</td>           
        </tr>
    <% foreach (System.Data.DataRow dr in dt.Rows) {
       %>      
     <tr style="background-color:#90EE90; font-weight:bold;">
<td style="text-align:right;border-right-color:white;border:solid;border-width:1px"><%=dr["Rate"].ToString() %></td>
<td style="text-align:right;border-right-color:white;border:solid;border-width:1px"><%=dr["Tax"].ToString() %></td>
<td style="text-align:right;border-right-color:white;border:solid;border-width:1px"><%=dr["Disc"].ToString() %></td>
<td style="text-align:right;border-right-color:white;border:solid;border-width:1px"><%=dr["ReceiveQty"].ToString() %></td>
<td style="text-align:center;border-right-color:white;border:solid;border-width:1px"><%=dr["IssueDate"].ToString() %></td>          
        </tr>    
    <%}  %>
            </table>
</div>
</body>
</html>
