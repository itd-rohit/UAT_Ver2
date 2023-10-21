<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MobileImage.aspx.cs" Inherits="Design_PROApp_MobileImage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <% foreach(System.Data.DataRow dw in dt.Rows)
                      
                  { %>
              <div style="margin-bottom:20px;">
                  <img style="height: 605px;border: 5px black solid;" src="<%=dw["Filename"].ToString() %>" />
              </div>

                <%} %>
    </div>
    </form>
</body>
</html>
