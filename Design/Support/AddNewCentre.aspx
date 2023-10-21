<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ValidateRequest="false" AutoEventWireup="true" CodeFile="AddNewCentre.aspx.cs" Inherits="Design_Support_AddNewCentre" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Add New Client</b>


        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                New Client Form
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">IP Address   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtIp" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Database Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDbName" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">User Id   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUid" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Password   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="Txtpwd" runat="server"></asp:TextBox>
                </div>
            </div>

            
        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSave" runat="server" Text="Add Now" OnClick="btnSave_Click" />

        </div>




    </div>
</asp:Content>

