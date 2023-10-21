<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MembershipCardTests.aspx.cs" Inherits="MembershipCardTests" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
<Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>
  
        <Ajax:UpdatePanel id="UpdatePanel6" runat="server">
                    <contenttemplate>
 
  
 <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b></b><strong>Bind Investigations with Membership Card
 </strong><br />
        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />      
    </div>
    </div> 
    
    <div class="POuter_Box_Inventory">
        &nbsp;<TABLE style="WIDTH: 500px" cellSpacing=0 cellPadding=0 border=0><TBODY><TR><TD style="WIDTH: 34%; HEIGHT: 16px; TEXT-ALIGN: right">
          <strong>Membership Card :</strong>   &nbsp;</TD>
    <td colspan="2" style="height: 16px">
        <asp:DropDownList ID="ddlMembershipCard" runat="server" AutoPostBack="True" 
        OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
        </asp:DropDownList></td>
</TR></TBODY></TABLE>
   
    </div> 
    
     <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Department List&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server"
                       Text="Select All" AutoPostBack="true" OnCheckedChanged="chkSelectAll_CheckedChanged"/></div>
    <div class="content"> 
        <asp:CheckBoxList ID="chkObservationType" runat="server" RepeatColumns="8" RepeatDirection="Horizontal" >
        </asp:CheckBoxList>&nbsp;</div>
    </div>
     <div class="POuter_Box_Inventory">
    <div class="content" style="text-align: center">    
    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Width="60px" Text="Search" OnClick="btnSearch_Click"  /></div>    
    </div> 
       <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Investigation List&nbsp;<asp:CheckBox ID="chkAllInv" runat="server"  Text="Select All" AutoPostBack="true" OnCheckedChanged="chkAllInv_CheckedChanged" /></div>
    <div class="content"> 
        <div style="height:280px;overflow:auto;">
        <asp:CheckBoxList ID="chlInvList" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" >
        </asp:CheckBoxList>&nbsp;</div></div>
    </div>
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align: center">    
    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Width="60px" Text="Save" OnClick="btnSave_Click" /></div>    
    </div>
    </div> 
</contenttemplate>
                       
                    </Ajax:UpdatePanel>

     </asp:Content>
