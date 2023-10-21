<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Store/VendorPortal/VendorPortal.master" AutoEventWireup="true" CodeFile="VendorWelcome.aspx.cs" Inherits="Design_Store_VendorPortal_VendorWelcome" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

   <div style="padding-left:10%; padding-right:10%;font-family: Tahoma;">
 <br /><br />
     <h2 style="color: #9b0000; text-align: center">
         
     
     Welcome 
                 <asp:Label ID="lblName" runat="server" Text=""></asp:Label></h2>
                 
                 
     <div style="border:solid 2px #83D13D; padding:5px;-moz-border-radius: 5px;
-webkit-border-radius: 5px; background-color:#F2FFE1; text-align: center;">

         <table width="100%">
             <tr>
                 <td align="center">
<table >
            
             <tr >
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                     State :</td>
                 <td style="text-align: left">
                     &nbsp;</td>
                 <td style="width: 300px; text-align: left;">
                      <asp:Label ID="lblstate" runat="server" Text=""></asp:Label></td>
             </tr>
             <tr >
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                     Contact Person :</td>
                 <td style="text-align: left">
                     &nbsp;</td>
                 <td style="width: 300px; text-align: left;">
                     <asp:Label ID="lblcontact" runat="server" Text=""></asp:Label></td>
             </tr>
             <tr>
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                     You have logged in :</td>
                 <td style="text-align: left">
                 </td>
                 <td style="text-align: left" >
                     <asp:Label ID="lblModule" runat="server" Text="Supplier Portal"></asp:Label></td>
             </tr>
             <tr>
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                     You
                     Current Login Time is :</td>
                 <td style="text-align: left">
                 </td>
                 <td style="text-align: left" >
                     <asp:Label ID="lblCLogin" runat="server" Text=""></asp:Label></td>
             </tr>
             <tr>
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                     You have
                     Last Logged Out at :</td>
                 <td style="text-align: left">
                 </td>
                 <td style="text-align: left" >
                     <asp:Label ID="lblLastLogin" runat="server" Text=""></asp:Label></td>
             </tr>
             </table>
                 </td>
             </tr>
         </table>
         
         
         </div>
        

 
 </div>
</asp:Content>

