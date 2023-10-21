<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Category_InvRole.aspx.cs" Inherits="Design_EDP_Category_InvRole" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
    <%: Scripts.Render("~/bundles/JQueryStore") %>

    
    
                
 <script type="text/javascript">
     function SelectAll(Type) {
         if (Type == "Dept") {
             var chkBoxList = document.getElementById('<%=chkSelectAll.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkObservationType.ClientID %>').checked;
                 }
             }
             else {
                 var chkBoxList = document.getElementById('<%=chkAllInv.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chlInvList.ClientID %>').checked;
                 }
             }
         }
 
 </script>  
 <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b></b><strong>WorkGroup</strong><br />
        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />      
    </div>
    </div> 
    
    <div class="POuter_Box_Inventory">
        &nbsp;<TABLE style="WIDTH: 500px" cellSpacing=0 cellPadding=0 border=0><TBODY><TR><TD style="WIDTH: 34%; HEIGHT: 16px; TEXT-ALIGN: right">
    LoginType / Depts. : &nbsp;</TD>
    <td colspan="2" style="height: 16px">
        <asp:DropDownList ID="ddlLoginType" runat="server" AutoPostBack="True" 
        OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
        </asp:DropDownList></td>
</TR></TBODY></TABLE>
   
    </div> 
    
     <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
       
        Department List&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server" Text="Select All" onclick="SelectAll('Dept')" /></div>
                      
    <div class="content"> 
        <div id="" style="overflow:scroll; height:100px;" class="col-md-24">
        <asp:CheckBoxList ID="chkObservationType" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" Width="956px">
        </asp:CheckBoxList>&nbsp;</div>
    </div>
      </div>
     <div class="POuter_Box_Inventory">
    <div class="content" style="text-align: center">    
    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Width="60px" Text="Search" OnClick="btnSearch_Click"  /></div>    
    </div> 
       <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Investigation List&nbsp;<asp:CheckBox ID="chkAllInv" runat="server"  Text="Select All"  onclick="SelectAll('Inv')" /></div>
    <div class="content"> 
         <div id="Div1" style="overflow:scroll; height:100px;" class="col-md-24">
        <asp:CheckBoxList ID="chlInvList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" Width="956px">
        </asp:CheckBoxList>&nbsp;</div>
        </div>
    </div>
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align: center">    
    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Width="60px" Text="Save" OnClick="btnSave_Click" /></div>    
    </div>
    </div> 


     </asp:Content>
