<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MenuMaster.aspx.cs" Inherits="Design_EDP_MenuMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="width:1006px">
        <div class="POuter_Box_Inventory" style="text-align: center;width:1000px">
            <b>Menu Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="width:1000px">        
                <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Menu Name" HeaderStyle-Width="500px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("menuname") %>
                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("id") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Display Order" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:TextBox ID="txtOrder" Text='<%#Container.DataItemIndex+1 %>' runat="server"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>



                    </Columns>
                </asp:GridView>           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1000px">
            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>

