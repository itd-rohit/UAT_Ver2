﻿<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="BusinessReportUser.aspx.cs" Inherits="Design_OPD_BusinessReportUser" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/CheckboxSearch.js" />
</Scripts>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>User Wise Business Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />        
        <div class="POuter_Box_Inventory" runat="server" id="divcentre" >
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">Centre</div>
                    <div class="col-md-6">  <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" /></div>
                   <div class="col-md-3">Search Centre :</div> 
                    <div class="col-md-6">&nbsp; <input id="txtSearchCentres" onkeyup="SearchCheckbox(this,chklCentres)"/></div>  
                                    
                </div>              
            </div>
             <div class="row"  style="overflow: scroll;text-align:left; height:200px;">
                    <div class="col-md-24"> <asp:CheckBoxList ID="chklCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList></div>
                 </div>       
        </div>
        <div class="POuter_Box_Inventory" runat="server" id="divuser" >
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">User</div>
                    <div class="col-md-6"> <asp:CheckBox ID="chkUsers" runat="server" Text="Select All Users" onclick="SelectAll('Users')" /></div>
                    <div class="col-md-3">Search User :</div>
                    <div class="col-md-6">&nbsp; <input id="txtSearchUsers" onkeyup="SearchCheckbox(this,chklUser)"/></div>
                    </div>                                                
            </div>
            <div  class="row" style="text-align:left; overflow: scroll;height:150px">
                 <div class="col-md-24">
                <asp:CheckBoxList ID="chklUser" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                     </div>
            </div>
            <div class="row">
                    <div class="col-md-3">From Date :</div> 
                        <div class="col-md-3"><asp:TextBox ID="ucFromDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-3">Time :</div>
                     <div class="col-md-2"><asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" ToolTip="Enter Time" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator></div>
                
                 <div class="col-md-3">To Date :</div> 
                     <div class="col-md-3"><asp:TextBox ID="ucToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-3">Time :</div>
                     <div class="col-md-2">
                        <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" ToolTip="Enter Time"
                            TabIndex="4" />
                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtToTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator> </div>
                </div>
             <div class="row">
                    <div class="col-md-24"> <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Selected="True" Value="0">Summary</asp:ListItem>
                            <asp:ListItem Value="1">Detail</asp:ListItem>                           
                        </asp:RadioButtonList></div>                 
            
               </div>            
            
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;" runat="server" id="divsave" >
            <div class="row">  
                     <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem  Value="1" Text="PDF" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="2" Text="Excel"></asp:ListItem>

                        </asp:RadioButtonList></div><div class="col-md-16">
            <asp:Button ID="btnPreview" runat="server" Text="Report"  CssClass="searchbutton" OnClick="btnPreview_Click" /> 
                 </div> 
                <div class="col-md-4"></div> 
                </div>       
        </div>
    </div>
    <script type="text/javascript">
      
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chklCentres.ClientID %>');
                    var chkBoxCount = chkBoxList.getElementsByTagName("input");
                    for (var i = 0; i < chkBoxCount.length; i++) {
                        chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                    }
                }
                else {
                    var chkBoxList = document.getElementById('<%=chklUser.ClientID %>');
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

