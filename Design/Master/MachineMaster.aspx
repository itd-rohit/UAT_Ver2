<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineMaster.aspx.cs" Inherits="Design_Master_MachineMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Machine Colour Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
          
                <table id="Addcentre" runat="server" style="text-align: left; width: 945px;">
                    <tr>
                        <td>

                            <asp:Label ID="lblCentreName" runat="server" Text="Machine:" Width="120px"></asp:Label>
                           <asp:TextBox ID="TxtCName" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtID" runat="server" Visible="False"></asp:TextBox>

                           
                        </td>
                        <td>
                            Colour:<asp:DropDownList ID="ddlColour" runat="server"></asp:DropDownList>
                             <asp:Label ID="lblActive" runat="server" Text="Is Active : " Width="108px"></asp:Label>
                            <asp:DropDownList ID="ddlActive" runat="server">
                                <asp:ListItem Value="0">No</asp:ListItem>
                                <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                            </asp:DropDownList>
                               <asp:Button ID="BtnSaveCentre" runat="server" Text="Save" Width="52px" OnClick="BtnSaveCentre_Click" CssClass="ItDoseButton" />
                        </td>
                    </tr>

                   
                    
                    <tr>
                        <td colspan="2">
                            <div style="overflow:scroll;height:200PX">
                            <asp:Panel ID="Panel1" ScrollBars="Horizontal" CssClass="" runat="server">
                                <asp:GridView ID="GrdCentres" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" Width="956px" OnSelectedIndexChanged="GrdCentres_SelectedIndexChanged">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <RowStyle CssClass="GridViewItemStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="ID" HeaderText="ID">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Name" HeaderText="Machine">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Colour" HeaderText="Colour">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Active" HeaderText="Isactive">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>

                                        <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Select" />
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="local_ID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                            </ItemTemplate>

                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                                </div>
                        </td>
                                            </tr>
                </table>
        </div>
    </div>

</asp:Content>

