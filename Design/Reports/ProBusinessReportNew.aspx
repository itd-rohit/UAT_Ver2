<%@ Page ClientIDMode="Static" Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="ProBusinessReportNew.aspx.cs" Inherits="Design_Reports_ProBusinessReportNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
        <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
    <style type="text/css">
        div#divLabDetail {
            height: 200px;
            overflow: scroll;
        }
    </style>

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<%--<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/CheckboxSearch.js" />
</Scripts>--%>
</Ajax:ScriptManager>

  <div id="Pbody_box_inventory">
          <div class="POuter_Box_Inventory">
<div class="row" style="text-align:center; "> 
    <div class="col-md-24">
<b>Pro Business Report</b>

   </div>  
      <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />        
</div>
</div>
      <div class="POuter_Box_Inventory" runat="server" id="divcentre">
             <div class="Purchaseheader">
               <div class="row">
                    <div class="col-md-6">Centre  <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" /></div>
                    <div class="col-md-4">Search Centre :&nbsp;</div> <div class="col-md-4"><input id="txtSearchCentres" onkeyup="SearchCheckbox(this,chklCentres)" /></div>                    
                </div> 


            </div>

            <div class="row"  style="overflow: scroll;text-align:left; height: 50px;">
                    <div class="col-md-24"> <asp:CheckBoxList ID="chklCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList></div>
                 </div> 
              </div> 
          <div class="POuter_Box_Inventory" runat="server" id="divuser"> 
              <div class="Purchaseheader">
               <div class="row">
                    <div class="col-md-6">Pro  <asp:CheckBox ID="chkPro" runat="server" Text="Select All Pro" onclick="SelectAll('Pro')" /></div>
                    <div class="col-md-4">Search Pro :&nbsp;</div> <div class="col-md-4"><input id="txtSearchPro" onkeyup="SearchCheckbox(this,chklPro)" /></div>                    
                </div> 


            </div>

            <div class="row"  style="overflow: scroll;text-align:left; height: 100px;">
                    <div class="col-md-24"> <asp:CheckBoxList ID="chklPro" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" OnSelectedIndexChanged="chklPro_SelectedIndexChanged" AutoPostBack="true" CssClass="chkCentre"></asp:CheckBoxList></div>
                 </div> 
        </div>
          <div class="POuter_Box_Inventory" runat="server" id="divPro">
               <div class="Purchaseheader">
                   <div class="row">
                    <div class="col-md-6">Client   <asp:CheckBox ID="chkClient" runat="server" Text="Select All Client" onclick="SelectAll('Client')" /></div>
                    <div class="col-md-4">Search Client :&nbsp;</div> <div class="col-md-6"><input id="txtSearchUsers" onkeyup="SearchCheckbox(this,chklClient)" /></div>                    
                </div>                              
            </div>          
                <div class="row"  style="overflow: scroll;text-align:left; height: 100px;">
                    <div class="col-md-24">  <asp:CheckBoxList ID="chklClient" runat="server" RepeatColumns="8" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList></div>
                 </div> 
            <div class="row">
                    <div class="col-md-6">From Date : <asp:TextBox ID="ucFromDate" runat="server" Width="100px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-6">Time :<asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator></div>
                
                 <div class="col-md-6">To Date : <asp:TextBox ID="ucToDate" runat="server" Width="100px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-6">Time :
                        <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time"
                            TabIndex="4" />
                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtToTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator> </div>
                </div>
             <div class="row">
                    <div class="col-md-8"> <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Selected="True" Value="0">Summary</asp:ListItem>
                            <asp:ListItem Value="1">Detail</asp:ListItem>  
                           <%--<asp:ListItem Value="2">TestCount</asp:ListItem>  --%>							
                        </asp:RadioButtonList></div>                 
                 <div class="col-md-8"></div>
                
               </div> 
              <div class="POuter_Box_Inventory" style="text-align: center;" runat="server" id="divsave" >
            <div class="row">  
                 <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem  Value="1" Text="PDF" Selected="True" ></asp:ListItem>
                            <asp:ListItem Value="2" Text="Excel"></asp:ListItem>

                        </asp:RadioButtonList></div><div class="col-md-20">
            <asp:Button ID="btnPreview" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnPreview_Click" /> 
                 </div>  
                </div>       
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
            else if (Type == "Pro") {
                var chkBoxList = document.getElementById('<%=chklPro.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkPro.ClientID %>').checked;
                }
            }
            else {
                var chkBoxList = document.getElementById('<%=chklClient.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkClient.ClientID %>').checked;
                }
            }


    }
        </script>
      
</asp:Content>
