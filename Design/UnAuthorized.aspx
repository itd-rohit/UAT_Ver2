<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UnAuthorized.aspx.cs" Inherits="Design_Store_UnAuthorized" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div style="text-align: center;">
                   
                    <asp:Label ID="lblMsg" Font-Size="X-Large" runat="server" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" Text="You are not authorized to view this page..!" />
                </div>
                </div>
        </div>
         </div>
</asp:Content>

