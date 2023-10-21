<%@ Page Language="C#" AutoEventWireup="true" CodeFile="showreading.aspx.cs" Inherits="Design_Lab_showreading" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
   <div id="show" runat="server">
    <table cellspacing="0" style="width:450px;font-family:Arial; font-size:12px;" rules="all" frame="box" border="1" >
        <tr style="background-color:#AEB6CB; font-weight:bold;">
            <td style="width:200px;text-align:left;">Observation Name</td>
            <td style="width:110px;text-align:left;">Value</td>
            
            <td style="width:70px;text-align:left;">Min</td>
            <td style="width:70px;text-align:left;">Max</td>

        </tr>


    <% foreach (System.Data.DataRow dr in dt.Rows) {
       %>
    
    
     <tr style="<% if(getTags_Flag(dr["Value"].ToString(),dr["MinValue"].ToString(),dr["MaxValue"].ToString(),"")!="")
     { 
         %>
            background-color:#FB6B5B;
             <%

     }else{%>
          background-color:white;
         <%} %>
         ">
         <td><%=dr["LabObservationName"].ToString() %></td>
               <td>    
                <%=getTags(dr["Value"].ToString(),dr["MinValue"].ToString(),dr["MaxValue"].ToString(),"") %>
                &nbsp; <%=dr["readingFormat"].ToString() %>

            </td>
       
            <td><%=dr["MinValue"].ToString() %></td>
            <td><%=dr["MaxValue"].ToString() %></td>

        </tr>


    
    <%
       
       }  %>

            </table>
</div>
    </form>
</body>
</html>
