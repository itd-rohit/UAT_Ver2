<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageRole.aspx.cs" Inherits="Design_EDP_ManageRole" MasterPageFile="~/Design/DefaultHome.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .FixedHeader {
            position: absolute;
        }
        .size {
        }
    </style>

    <div id="Pbody_box_inventory" style="width: 1100px;">
        <div class="POuter_Box_Inventory" style="width: 1096px; text-align: center;">

            <b>&nbsp;Manage Role</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


        </div>
        <div class="POuter_Box_Inventory" style="width: 1096px;">
            <div class="Purchaseheader">
                Add Details&nbsp;
            </div>


            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 568px;"><b>Role Name :&nbsp;</b></td>
                    <td>
                        <asp:TextBox ID="txtRoleName" runat="server" Width="223px" Style="text-transform: uppercase;"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="r1" runat="server" ControlToValidate="txtRoleName" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                    </td>
                    <td>
                        <asp:TextBox ID="txtId" Visible="false" runat="server" /></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>

                <tr>
                    <td style="text-align: right; width: 568px;"><b>Color code in HEXA :&nbsp;</b></td>
                    <td>
                        <asp:TextBox ID="txtcolor" runat="server" Width="223px" Style="text-transform: uppercase;"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="r3" runat="server" ControlToValidate="txtcolor" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox1" Visible="false" runat="server" /></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                                <tr>
                    <td style="text-align: right; width: 568px;"><b>Role Icon Image :&nbsp;</b></td>
                    <td>
                        <asp:FileUpload ID="FileUpload1" runat="server" />
                    </td>
                    <td>
                        <asp:TextBox ID="TextBox2" Visible="false" runat="server" /></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 568px;"><b></b></td>
                    <td>
                        <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" />
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="6" style="text-align: center">
                        <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="itdosebtnnew" ValidationGroup="save" />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" CssClass="itdosebtnnew" />
                    </td>
                </tr>
            </table>


        </div>


        <div class="POuter_Box_Inventory" style="width: 1096px;">
            <div class="Purchaseheader">
                Role List&nbsp;
            </div>
            <div class="content">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td align="center"><strong>Search By Name :</strong><asp:TextBox ID="txtsearch" runat="server" Width="260px"></asp:TextBox>
                            &nbsp;&nbsp;
                  <asp:Button ID="btnsearch" Text="Search" OnClick="btnsearch_Click" runat="server" CssClass="itdosebtnnew" />
                        </td>
                    </tr>
                     <tr>
                                <td align="center">

                                    <div style="overflow: scroll; height: 300px; width: 1075px;">
                                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDeleting="GridView1_RowDeleting" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" Width="99%" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex + 1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Role Name">

                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("name") %>'></asp:TextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("RoleName") %>'></asp:Label>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("IsActive") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Background") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Image") %>' Visible="false"></asp:Label>
                                                  
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="IsActive" HeaderText="IsActive" />
                                                <asp:BoundField DataField="Background" HeaderText="Background" />
                                                <asp:ImageField DataImageUrlField="Image" HeaderText="Image" ControlStyle-Width="30px" ControlStyle-Height="30px"></asp:ImageField>
                                                <asp:TemplateField HeaderText="Edit">

                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                            Text="Select"></asp:LinkButton>
                                                    </ItemTemplate>

                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="ChangeStatus">

                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                                                            Text="Deactive"></asp:LinkButton>
                                                    </ItemTemplate>

                                                </asp:TemplateField>
                                            </Columns>
                                            <FooterStyle BackColor="White" ForeColor="#000066" />
                                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                            <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                                            <SelectedRowStyle BackColor="Pink" Font-Bold="True" />
                                        </asp:GridView>
                                    </div>
                                </td>
                            </tr>

                </table>
            </div>
        </div>
    </div>

        <script type="text/javascript">
            function ConfirmOnDelete(item, type) {
                var msg = "";
                if (type == "1") {
                    msg = "Are you sure to deactive : " + item + "?";
                }
                else {
                    msg = "Are you sure to active : " + item + "?";
                }
                if (confirm(msg) == true)
                    return true;
                else
                    return false;
            }
    </script>

</asp:Content>
