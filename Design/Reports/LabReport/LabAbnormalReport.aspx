<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabAbnormalReport.aspx.cs" Inherits="Reports_Forms_LabAbnormalReport" %>

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
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>Lab Abnormal Report&nbsp;</b><br />
         <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
    </div>
   </div>
    <div class="POuter_Box_Inventory" id="div1" runat="server">
    <div class="Purchaseheader">
        Report Criteria</div>
          <div class="row">
                    <div class="col-md-4">From Date :</div>
                    <div class="col-md-4"><asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>                                
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" PopupButtonID="txtFromDate" /></div>
                    <div class="col-md-4">To Date</div>
                    <div class="col-md-4"> <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>                                
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="txtToDate" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" />
                               
                             </div>
                </div>
         <div class="POuter_Box_Inventory"  id="div3" runat="server">
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
         <div class="row">
                    <div class="col-md-4" >Patient ID :</div>
                    <div class="col-md-4">  <asp:TextBox ID="txtPID"  runat="server"></asp:TextBox></div>
                    <div class="col-md-4">Lab No :</div>
                    <div class="col-md-4">  <asp:TextBox ID="txtLabNo" runat="server" ></asp:TextBox>
                               
                             </div>
                </div>
          <div class="row">
                 
                    <div class="col-md-8">  <asp:RadioButtonList ID="rdbAbCriReport" runat="server" RepeatDirection="Horizontal"
                            CssClass="ItDoseRadiobuttonlist" >
                            <asp:ListItem Selected="True" Text="Abnormal Report" Value="0"></asp:ListItem>
                           <asp:ListItem Text="Critical Report" Value="1"></asp:ListItem>                       
                        </asp:RadioButtonList>
                               
                             </div>
                </div>
   
  </div>
    <div class="POuter_Box_Inventory" style="text-align:center;"  id="div2" runat="server">
        <div class="row">
              <div class="col-md-4"><asp:RadioButtonList ID="rblreportformat" runat="server" RepeatDirection="Horizontal"
                            CssClass="ItDoseRadiobuttonlist" >
                            <asp:ListItem Selected="True" Text="Pdf" Value="0"></asp:ListItem>
                           <asp:ListItem Text="Excel" Value="1"></asp:ListItem>                       
                        </asp:RadioButtonList> </div>
            <div class="col-md-16">
                 <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" Text="Report" />
            </div><div class="col-md-4"></div>
        </div>
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