<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ContactUs.aspx.cs" Inherits="Design_Online_Lab_ContactUs" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Online Lab Report</title>
     <link href="../../Design/Purchase/PurchaseStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../../scripts/jquery-1.4.1.min.js"></script>
    <script type="text/javascript">

        function OpenPdfTest(labNo) {
            if ($.trim(labNo) != "") {
                window.open("popup.aspx?LabNo=" + labNo);
            }
        }

    </script>
    <style type="text/css">
     .nav{
 
    list-style:none;
    margin:0;
    padding:0;
    text-align:center;
}
.nav li{
    display:inline;
      
  

}
.nav a{
    display:inline-block;
    background-color: #569ADA;
  
    padding:10px;
    border-radius: 8px;
    text-decoration:none;
}
        .nav a 
        {
            border-radius: 4px;
            color:white;
            font-weight:bold;
        }

       .nav a:hover {background-color: #3B0B0B; }

        input[type="submit"]
        {
             background-color: #569ADA;
    padding:5px;
    border-radius: 8px;
    -ms-border-radius: 8px;
    text-decoration:none;
    color:white;
    font-weight:bold;
    cursor:pointer;
        }
            input[type="submit"]:hover
            {
                background-color: #3B0B0B;
            }

        /*/*#divUserType
        {
            background-color:white;
        }*/
    </style>
</head>
<body style="background-color:#D7E9FE;">
    <form id="form1" runat="server">
    <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        
        <div style=" border: 1px solid Gray;">
          
  <div style="background-color:white">
         <table style="width:100%;border:1px solid gray;">
             <tr>
                 <td align="left"><img src="Images/clientlogo.png" width="300px" height="100px"/></td>
                  <td align="right">
                      <asp:Button ID="Btn_logout"  runat="server" Text="LogOut" OnClick="Btn_logout_Click" style="display:none;"/>
             <div id="menu" runat="server">      
                 
        <ul class="nav">
		    
		    <li><a href="ViewlabReportPanel.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Patient Report</span></a></li>
             <li style="display:none;"><a href="OtherReports.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Other Report</span></a></li>
       
		    
            
            
            <li><a href="ContactUs.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Contact US</span></a></li>
            <li><asp:LinkButton ID="LinkButton2" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li>
	    </ul></div>  
                      <div id="menupat" runat="server" visible="false">
                             <ul class="nav">
		    
<li><asp:LinkButton ID="LinkButton1" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li></ul>
                      </div>
                    <%--  <br />
                      <marquee direction="left" onmouseover="this.stop();" onmouseout="this.start();" scrollamount="3" onmousehover="this.stop()"><span style="color:#3B0B0B;font-weight:bold;">Welcome To MOLQ OnLine Lab.</span></marquee>--%>
  
                  </td>
             </tr>
         </table>
     </div> 

     <div style="margin: 0px auto 0px auto; width: 1000px;background-color:#EFF3FB;">
         <div  style="width: 1000px;">
           
            <div  style="text-align: center">             
                <b>Contact Us</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
         
        </div>                 
        <div  style="width: 1000px;height:500px;" >
              <table width="100%" style="border:1px solid #569ADA;">
                

              

                <tr>
                    <td align="center">
            <div style="width:100%;float:left;">
                <br />
                <div class="fancybox"><h4 class="fancytitle" style="background-color:#569ADA;color:white; text-align:center;"><strong><label id="lbname" runat="server"></label> </strong></h4><div class="boxcontent">


<label id="lbadd" runat="server"></label>
                                                                                                                                                         </div><div style="width:100%">&nbsp;</div></div></div>
                        <div style="width:100%">&nbsp;</div>
            <div style="width:100%">
            <iframe id="myweb" width="950" height="350" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" runat="server"></iframe>
            </div>
                        </td></tr></table>
                        </div>
         
        </div>
            </div>
    </form>
</body>
</html>
