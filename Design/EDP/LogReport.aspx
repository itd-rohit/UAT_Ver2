<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="LogReport.aspx.cs" Inherits="Design_EDP_LogReport" %>

<%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server"> 
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:97%">
       
        <div class="POuter_Box_Inventory"  style="width:99.6%">
            <div class="Purchaseheader">
               Log Report
            </div>
              <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>
            <div class="content">
                <table style="width: 100%">
                    <tr>
                        <td >Date From : <uc1:EntryDate ID="txtDate" runat="server" /></td>
                        <td >To Date : <uc1:EntryDate ID="txtDate0" runat="server" /></td>
                        <td >LabNo :  <asp:TextBox ID="txtLabNo" runat="server" Width="200px"></asp:TextBox></td>
                        <td >Centre :  <asp:DropDownList ID="ddlcenter" runat="server" Width="200px"></asp:DropDownList></td>
                    </tr>   
                </table>
            </div>

        </div>

        <div class="POuter_Box_Inventory"  style="width:99.6%"> 
            <div class="content">
                <asp:RadioButtonList ID="rbtnSelect" runat="server" RepeatColumns="6">
                    <asp:ListItem Value="0" Selected="True">Change Panel</asp:ListItem>
                    <asp:ListItem Value="1">Change Doctor</asp:ListItem>
                    <asp:ListItem Value="2">Change PName/Age/Gender</asp:ListItem>
                    <asp:ListItem Value="13" >Change Status</asp:ListItem>
                    <asp:ListItem Value="3">Settlement Data</asp:ListItem>
                    <asp:ListItem Value="4">SMS</asp:ListItem>
                    <asp:ListItem Value="5">Emailing</asp:ListItem>
                    <asp:ListItem Value="7">Print Report</asp:ListItem>
                    <asp:ListItem Value="8">Change Barcode</asp:ListItem>
                    <asp:ListItem Value="9">Auto Email Summary</asp:ListItem>
                    <asp:ListItem Value="14">Log Interpretation </asp:ListItem>
                    <asp:ListItem Value="10">Rate Change Log</asp:ListItem>
                    <asp:ListItem Value="11">Re Sample Booking Log</asp:ListItem>
                    <asp:ListItem Value="12">Cheque Transaction Detail</asp:ListItem>
                    <asp:ListItem Value="15">Referange Report</asp:ListItem>
                    <asp:ListItem Value="16">Patient Trace</asp:ListItem>
                    <asp:ListItem Value="17">Lock-Unlock Client Log</asp:ListItem>
                    <asp:ListItem Value="18">Doctor Master</asp:ListItem>
                    <asp:ListItem Value="19">Panel Master</asp:ListItem>
                    <asp:ListItem Value="20">Employee Master</asp:ListItem>
                    <asp:ListItem Value="21">Investigation Master</asp:ListItem> 
                    <asp:ListItem Value="23">Accession Remark</asp:ListItem>
                </asp:RadioButtonList>&nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory"  style="width:99.6%">
            <div class="content" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" CssClass="searchbutton" Width="150px" Text="Search" OnClick="btnSave_Click" />
            </div>
        </div>
    </div>

</asp:Content>
