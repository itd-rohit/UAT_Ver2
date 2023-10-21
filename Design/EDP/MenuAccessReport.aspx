<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MenuAccessReport.aspx.cs" Inherits="Design_EDP_MenuAccessReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div id="Pbody_box_inventory" style="width: 1275px">
             <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
              

           </Services>
        </Ajax:ScriptManager>

             <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
                 <b>Menu Access Report  </b>
              <br />

                 </div>
         <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
             <asp:Button ID="btnReport" runat="server" CssClass="searchbutton" Text="Report" OnClick="btnReport_Click" />
              </div>
         </div>
</asp:Content>

