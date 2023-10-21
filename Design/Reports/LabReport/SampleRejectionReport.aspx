<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="SampleRejectionReport.aspx.cs" Inherits="Design_OPD_SampleRejectionReport" Title="Sample Rejection Report" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >     
       <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
</Scripts>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Rejection Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
        </div>
           <div class="POuter_Box_Inventory" id="div1" runat="server"> 
            <div class="Purchaseheader">
                Date
            </div>   
               <div class="row">
                   <div class="col-md-3">From Date :</div>
                   <div class="col-md-3"> <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                   <div class="col-md-3">To Date :</div>
                   <div class="col-md-3"> <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                 </div>
                   <div class="col-md-12"></div>
               </div>        
             </div>
        <div class="POuter_Box_Inventory"  id="div2" runat="server">
            <div class="Purchaseheader">
              Booking  Centre <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Booking Centers" onclick="SelectAll('Centre')" />
            </div> 
           <div class="row" style="height:100px;overflow:scroll;border:double">
               <div class="col-md-24">
             <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>   
                   </div>                    
               </div>
             </div>
           <div class="POuter_Box_Inventory"  id="div6" runat="server">
            <div class="Purchaseheader">
                Test Centre <asp:CheckBox ID="chkTestCentres" runat="server" Text="Select All Test Centers" onclick="SelectAll('TestCentre')" />
            </div> 
           <div class="row" style="height:100px;overflow:scroll;border:double">
               <div class="col-md-24">
             <asp:CheckBoxList ID="chlTestCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkTestCentre"></asp:CheckBoxList>   
                   </div>                    
               </div>
             </div>
         <div class="POuter_Box_Inventory"  id="div3" runat="server">
            <div class="Purchaseheader">
                Department <asp:CheckBox ID="chkAllDept" runat="server" Text="Select All Department" onclick="SelectAll('Dept')" />
            </div> 
           <div class="row" id="Div1" style="height:100px;overflow:scroll;border:double"">
               <div class="col-md-24">
             <asp:CheckBoxList ID="chkDept" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList> 
                   </div>                      
               </div>
             </div>
      <div class="POuter_Box_Inventory"  id="div4" runat="server">           
             <div class="row">   
                   <div class="col-md-12"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                  </div>                         
              
             </div> 
        <div class="POuter_Box_Inventory" style="text-align: center;"  id="div5" runat="server">
            <asp:Button ID="btnPDFReport" runat="server" Text="Get Report" CssClass="searchbutton" OnClick="btnPDFReport_Click"/>
            
        </div>
     <script type="text/javascript">   
         function SelectAll(Type) {
             if (Type == "Centre") {
                 var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                 }
             }
             else if(Type=="Dept") {
                 var chkBoxList = document.getElementById('<%=chkDept.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkAllDept.ClientID %>').checked;
                 }
             }
             else if (Type == "TestCentre") {
                 var chkBoxList = document.getElementById('<%=chlTestCentres.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkTestCentres.ClientID %>').checked;
                 }
             }
        }
    </script>
</form>
</body>
</html>


