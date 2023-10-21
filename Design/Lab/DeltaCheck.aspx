<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeltaCheck.aspx.cs" Inherits="Design_Lab_DeltaCheck" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <div id="show" runat="server">
        <table cellspacing="0" style="width: 550px; font-family: Arial; font-size: 12px;" rules="all" frame="box" border="1">
            <tr style="background-color: #AEB6CB; font-weight: bold;">
                <td style="width: 100px;">Booking Date</td>
                <td style="width: 100px;">LabObservation Name</td>
                <td style="width: 80px;">Value</td>
                <td style="width: 100px;">Reading Format</td>
                <td>Min</td>
                <td>Max</td>
            </tr>
            <% foreach (DataRow dr in dt.Rows)
               {
            %>
            <tr style="<% if (getTags_Flag(dr["Value"].ToString(), dr["MinValue"].ToString(), dr["MaxValue"].ToString(), "") != "")
                          { 
         %>
            background-color: #FB6B5B; <%
     }
                          else
                          {%>
          background-color: white; <%} %>">
                <td style="white-space: nowrap;"><%=dr["BookingDate"].ToString() %></td>
                <td style="white-space: nowrap;"><%=dr["LabObservationName"].ToString() %></td>
                <td style="white-space: nowrap;"><%=dr["Value"].ToString() %></td>
                <td style="white-space: nowrap;">
                    <%=dr["ReadingFormat"].ToString() %>                             
                </td>
                <td><%=dr["MinValue"].ToString() %></td>
                <td><%=dr["MaxValue"].ToString() %></td>
            </tr>
            <%      
               }  %>
        </table>
    </div>

</body>
</html>
