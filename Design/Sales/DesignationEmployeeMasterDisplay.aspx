<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="DesignationEmployeeMasterDisplay.aspx.cs" Inherits="Design_Designation_DesignationEmployeeMasterDisplay" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../scripts/main.js"></script>
    <link href="../../styles/main.css" rel="stylesheet" />

    <div id="Pbody_box_inventory" style=" width: 1304px;">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <b>Employee with Designation Master Display </b>
            <br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>&nbsp;
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align:center;" >
            <div class="POuter_Box_Inventory" style="width: 1200px; font-size: 16px; margin-left: 50px; margin-right:50px;text-align: left; font-family: 'Times New Roman';">
                <asp:PlaceHolder ID="pl1" runat="server"></asp:PlaceHolder>
            </div>
        </div>
   </div>

</asp:Content>

