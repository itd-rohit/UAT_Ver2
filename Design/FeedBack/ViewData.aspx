<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewData.aspx.cs" Inherits="Design_Websitedata_ViewData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <table style="width:500px" border="1" frame="box" rules="all">
            <%
                foreach (System.Data.DataColumn dw in dt.Columns)
                {%>
            <tr>
                <td><%=dw.ColumnName.ToString().Replace('_',' ') %></td><td>  <%=dt.Rows[0][dw].ToString() %></td>
            </tr>

              <%  }
                 %>
        </table>

    </div>
    </form>
</body>
</html>
