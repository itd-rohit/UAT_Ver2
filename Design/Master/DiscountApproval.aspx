<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DiscountApproval.aspx.cs" Inherits="Design_Master_DiscountApproval" MasterPageFile="~/Design/DefaultHome.master"%>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            
                <b>Discount Approval Master</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
        <div class="content">
        <table id="AddDiscountApproval" runat="server" style="text-align:left; width: 945px;"> 
    <tr>
    <td  colspan="2" align="center" style="height: 26px">
      
        <asp:Label ID="lblDiscountApproval" runat="server" Text="DiscountApproval:" Width="122px" ></asp:Label>
        <asp:TextBox ID="txtDiscountApproval" runat="server" ></asp:TextBox>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtID" runat="server" Visible="False"></asp:TextBox></td>
    
    </tr>

        <tr>
        <td colspan="2" align="center">
         <asp:Label ID="lblActive" runat="server" Text="Is Active :" Width="108px"></asp:Label>
            <asp:DropDownList ID="ddlActive" runat="server">
                <asp:ListItem Value="0">No</asp:ListItem>
                <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
            </asp:DropDownList>
        </td>
        </tr>
        <tr align="center">
    <td colspan="2" style="height: 26px">
     <asp:Button ID="BtnSaveDiscountApproval" runat="server" Text="Save" Width="72px" OnClick="BtnSaveDiscountApproval_Click" CssClass="ItDoseButton"/>&nbsp;
    </td>
    </tr>
    <tr>
    <td colspan="2">
    <asp:Panel ID="Panel1"  ScrollBars="Horizontal" CssClass="" runat="server" >
    <asp:GridView ID="GrdCentres" AutoGenerateColumns="False" runat="server"  CssClass="GridViewStyle" Width="956px" OnSelectedIndexChanged="GrdCentres_SelectedIndexChanged" >
            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
            <RowStyle CssClass="GridViewItemStyle"  />
            <Columns>
            <asp:BoundField DataField="ID" HeaderText="ID" >
                    <ItemStyle CssClass="GridViewItemStyle" />
                     <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:BoundField>
                <asp:BoundField DataField="ApprovalType" HeaderText="Name" >
                    <ItemStyle CssClass="GridViewItemStyle" />
                     <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:BoundField>
                <asp:BoundField DataField="Active" HeaderText="Active" >
                    <ItemStyle CssClass="GridViewItemStyle" />
                     <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:BoundField>
                
                <asp:CommandField ShowSelectButton="True"   HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Select"/>
                <asp:TemplateField Visible="False">
                <ItemTemplate>
                <asp:Label ID="local_ID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                </ItemTemplate>
                    
                </asp:TemplateField>
                
                
                
            </Columns>
        </asp:GridView>
        </asp:Panel>
    </td>
    
    </tr>
        
    
    </table>
        </div>
        
        
        
        </div>



</div>
</asp:Content>
