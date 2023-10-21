<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UtilityAccountData.aspx.cs" Inherits="Design_DocAccount_UtilityAccountData" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
  <Services>
  <Ajax:ServiceReference Path="~/Lis.asmx" />
  </Services>
     </Ajax:ScriptManager>
   
     <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <div class="row">
    <div class="col-md-24" style="text-align:center;">
    <b>Load Data</b><br />
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033" CssClass="ItDoseLblError"></asp:Label>&nbsp;</div>
   </div>
   </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> 
        Search Criteria</div>
       <div class="row">
           <div class="col-md-4">From Date:</div>
           <div class="col-md-8"><asp:TextBox ID="txtfromdate"  runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender></div>
           <div class="col-md-4">To Date:</div>
           <div class="col-md-8"> <asp:TextBox ID="txttodate"  runat="server" Width="200px"></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender></div>
       </div></div>
       <div  class="POuter_Box_Inventory"  style="text-align:center;">
           <div class="row">
               <div class="col-md-24">
                   <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="savebutton" OnClick="btnSave_Click"/>
               </div>
           </div></div>
       </div>
</asp:Content>

