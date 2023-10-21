<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OtherReports.aspx.cs" Inherits="Design_Online_Lab_OtherReports" %>

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

      <script type="text/javascript"> 
          function CheckBoxListSelect1(Chk,chl)
          { 
              var chh=document.getElementById(Chk).value;
      
       
          
       
              var chkBoxList = chl;
       
              var chkBoxCount= chkBoxList.getElementsByTagName("input");
        
              for(var i=0;i<chkBoxCount.length;i++)
              {
                  chkBoxCount[i].checked = document.getElementById(Chk).checked;
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
        .nav a span
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
             <li><a href="OtherReports.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Other Report</span></a></li>
       
		    
            
            
            <li><a href="ContactUs.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Contact US</span></a></li>
           <li><asp:LinkButton ID="LinkButton2" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li>
	    </ul></div>  
                      <div id="menupat" runat="server" visible="false">
                             <ul class="nav">
		    
<li><asp:LinkButton ID="ink" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li></ul>
                      </div>
                    
                  </td>
             </tr>
         </table>
     </div>

    <div style="margin: 0px auto 0px auto; width: 1000px;background-color:#EFF3FB;">
     <div  style="width: 1000px;">
           
            <div  style="text-align: center">             
                <b>Other Reports</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
         
        </div>
        <div  style="width: 1000px;height:500px;" >
            <table width="100%" style="border:1px solid #569ADA;">
                

              

                <tr>
                    <td align="center">

                        <table width="80%">
                            <tr>
                                <td>From Date:</td><td>
                                    <asp:TextBox ID="FrmDate" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate"></cc1:CalendarExtender>
                                    </td><td>To Date:</td><td> 
                                        <asp:TextBox ID="ToDate" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate"></cc1:CalendarExtender>
                                         </td>
                            </tr>

                            <tr id="trpanelforpro" runat="server" visible="false">
                                <td valign="top">Panel:<br />
                                    <input id="chkpan" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkpan',document.getElementById('<%=chkPanel.ClientID %>'))"  />
                                </td><td colspan="3" align="left">

                                    <div style="height:250px;overflow:scroll;width:700px;">
    <asp:CheckBoxList ID="chkPanel" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
        </asp:CheckBoxList></div>
                                                                             </td>
                            </tr>

                            <tr>
                                <td colspan="4">&nbsp;</td>
                            </tr>
                                                       
                            
                        </table>
                    </td>
                </tr>
               
            </table>
            <div style="text-align:center;border:1px solid #569ADA;">
                         <asp:Button  runat="server" ID="lk_ratelist" Text="Rate List Report" OnClick="lk_ratelist_Click"></asp:Button>
                        <asp:Button  runat="server" ID="btn_SummaryRpt" Text="Business Summary Report" OnClick="btn_SummaryRpt_Click"></asp:Button>
                      
                            <asp:Button  runat="server" ID="btn_DetailedRpt" Text=" Business Detailed Report" OnClick="btn_DetailedRpt_Click"></asp:Button>                
                  <asp:Button  runat="server" ID="btn_payment" Text="Payment Details" OnClick="btn_payment_Click" ></asp:Button>  
                           <asp:Button  runat="server" ID="btn_samplerej" Text="Sample Rejection Report" onclick="btn_samplerej_Click" ></asp:Button> 
                        
                                              <asp:Button Width="220px"  runat="server" ID="btn_prosummary" Text="PRO Business Summary Report" OnClick="btn_prosummary_Click"></asp:Button>
                      
                            <asp:Button  Width="220px"   runat="server" ID="btn_prodetail" Text="PRO Business Detailed Report" OnClick="btn_prodetail_Click"></asp:Button> 
                             <asp:Button  Width="220px"   runat="server" ID="btn_LedgerRpt" Text="Ledger Report" OnClick="btn_LedgerRpt_Click"></asp:Button> 
                  </div>
            </div>
        </div>
</div>
    </form>
</body>
</html>
