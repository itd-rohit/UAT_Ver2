<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Appointment_Delta.aspx.cs" Inherits="Design_Appointment_Appointment_Delta" %>

<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>
<script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="padding: 0px 0px 0px 0px;">
    <div id="show" runat="server" style="display:none">
        <% try
           {
               if (dt.Rows.Count > 0)
               { %>
        <table cellspacing="0" style="width: 450px; font-family: Arial; font-size: 12px;" rules="all" frame="box" border="1">
            <tr style="background-color: #AEB6CB; font-weight: bold;">
                <td style="width: 30px;background-color:white;text-align:left;color:black;font-weight:bold;">Mobile</td>
                <td style="width: 100px;background-color:white;text-align:left;color:black;font-weight:bold;"><%=dt.Rows[0]["Mobile"].ToString()%></td>          
            </tr>
           <tr style="background-color: #AEB6CB; font-weight: bold;">
               <td style="width: 30px;background-color:white;text-align:left;color:black;font-weight:bold;">Test</td>
               <td style="width: 100px;background-color:white;text-align:left;color:black;font-weight:bold;"><%=dt.Rows[0]["Investigation"].ToString()%></td>           
            </tr>
           <tr style="background-color: #AEB6CB; font-weight: bold;">
                <td style="width: 30px;background-color:white;text-align:left;color:black;font-weight:bold;">Address</td>
                <td style="width: 100px;background-color:white;text-align:left;color:black;font-weight:bold;"><%=dt.Rows[0]["Address"].ToString()%></td>           
            </tr>
          <tr >
                <td style="width:30px;background-color:white;text-align:left;color:black;font-weight:bold;">Remark</td>
                <td style="width: 100px;background-color:white;text-align:left;color:black;font-weight:bold;"><%=dt.Rows[0]["Remarks"].ToString()%></td>           
            </tr>
            
        </table>
        <% }
           }
           catch (Exception ex)
           {
               ClassLog cl = new ClassLog();
               cl.errLog(ex);

           } %>
    </div>
</body>
</html>
