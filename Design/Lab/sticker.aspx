<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sticker.aspx.cs" Inherits="Design_Lab_sticker" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

  
</head>
<body style="width:800px;">
    <form id="form1" runat="server">

 
      
    

<%--            <%foreach(System.Data.DataRow dw in dt.Rows)
                  
              { %>
                <div>
            <table style="float:left;width:50%;padding-bottom:55px;font-size:16px;padding-left:30px;padding-top:20px;">
                <tr>
                   <td style="font-weight:bold;"><%=dw["DATE"].ToString() %></td><td  style="font-weight:bold;"> Theism </td><td><%=dw["labno"].ToString() %></td>
                </tr>
                <tr>
                    <td colspan="4"  style="font-weight:bold;"><%=dw["PName"].ToString() %></td>
                </tr>
                 <tr>
                    <td colspan="4"><%=dw["dname"].ToString() %></td>
                </tr>
                 <tr>
                    <td colspan="4"  style="width:400px;height:60px;vertical-align:top; ">
                       
                        <%=dw["itemname"].ToString() %></td>
                </tr>
            </table></div>

         <% if (no == 12) 
             { %>
     <div style="page-break-before:always;page-break-after:always;"></div>
             <%no = 0; %>  
            <% }
                   no++;
              } %>
       --%>
    </form>
</body>
</html>
