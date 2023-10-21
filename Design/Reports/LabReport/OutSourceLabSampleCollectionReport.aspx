<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="OutSourceLabSampleCollectionReport.aspx.cs" Inherits="Design_OPD_OutSourceLabSampleCollectionReport" %>


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
            <b>OutSource Lab Sample Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" id="div1" runat="server" >
            <div class="row">
                <div class="col-md-4">From Date :</div>
                <div class="col-md-2"> <asp:TextBox ID="txtFromdate" runat="server"></asp:TextBox></div>
                    <div class="col-md-2">
                     <asp:TextBox ID="txtFromTime" runat="server"> </asp:TextBox>
                        <cc1:CalendarExtender ID="ccfromdate" TargetControlID="txtFromdate" PopupButtonID="txtFromdate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender></div>
                <div class="col-md-4">To Date :</div>
                <div class="col-md-2"><asp:TextBox ID="txtTodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ccTodate" TargetControlID="txtTodate" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtTodate"></cc1:CalendarExtender>
                   </div> <div class="col-md-2">
                        <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox></div>
            </div>
            <div class="row">
                <div class="col-md-4">Report Type :</div>
                <div class="col-md-8"> <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="horizontal">
                            <asp:ListItem Value="0" Selected="true">With Rate</asp:ListItem>
                            <asp:ListItem Value="1">WithOut Rate</asp:ListItem>
                        </asp:RadioButtonList></div>
                <div class="col-md-4"></div>
                <div class="col-md-8"></div>
                </div>         
        </div>
        <div class="POuter_Box_Inventory"  id="div2" runat="server" >
            <div class="Purchaseheader">
                 <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" />Booking Centre :
            </div>
            <div class="row" style="height:100px;overflow:scroll;border:double">
                <div class="md-col-24">
                     <asp:CheckBoxList ID="chklstOutSrcCentre" runat="server" RepeatColumns="10" RepeatDirection="Horizontal"></asp:CheckBoxList>
                </div>              
            </div>
        </div>
           <div class="POuter_Box_Inventory"  id="div5" runat="server" >
            <div class="Purchaseheader">
                 <asp:CheckBox ID="chkTestCentres" runat="server" Text="Select All Centers" onclick="SelectAll('TestCentre')" />Test Centre :
            </div>
            <div class="row" style="height:100px;overflow:scroll;border:double">
                <div class="md-col-24">
                     <asp:CheckBoxList ID="chklstOutSrcTestCentre" runat="server" RepeatColumns="10" RepeatDirection="Horizontal"></asp:CheckBoxList>
                </div>              
            </div>
        </div>
        <div class="POuter_Box_Inventory"  id="div3" runat="server" >
            <div class="Purchaseheader">
                 <asp:CheckBox ID="chkUsers" runat="server" Text="Select All Users" onclick="SelectAll('Users')" />OutSource Lab :
            </div>
            <div class="row" style="height:100px;overflow:scroll;border:double">
                  <div class="md-col-24">  <asp:CheckBoxList ID="chklstOutSrcLab" runat="server" RepeatColumns="10" RepeatDirection="Horizontal"></asp:CheckBoxList> </div>             
            </div>
        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;"  id="div4" runat="server" >
            <div class="row">
                <div class="col-md-4">
                      <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatDirection="horizontal">
                <asp:ListItem Value="1" Selected="true">PDF</asp:ListItem>
                <asp:ListItem Value="2">Excel</asp:ListItem>
            </asp:RadioButtonList></div>
                     <div class="col-md-16">
            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
                </div><div class="col-md-4"></div>
            </div>          
        </div>


    <script type="text/javascript">
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chklstOutSrcCentre.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                    }
            }
            else if (Type == "TestCentre") {
                var chkBoxList = document.getElementById('<%=chklstOutSrcTestCentre.ClientID %>');
                    var chkBoxCount = chkBoxList.getElementsByTagName("input");
                    for (var i = 0; i < chkBoxCount.length; i++) {
                        chkBoxCount[i].checked = document.getElementById('<%=chkTestCentres.ClientID %>').checked;
                }
            }
                else {
                    var chkBoxList = document.getElementById('<%=chklstOutSrcLab.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkUsers.ClientID %>').checked;
                    }
                }


        }
        
    </script>
</form>
</body>
</html>

