<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DepartmentMaster.aspx.cs" Inherits="Design_Investigation_DepartmentMaster" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .FixedHeader {
            position: absolute;
        }
    </style>

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
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <Ajax:UpdateProgress ID="updateProgress" runat="server">
        <ProgressTemplate>
            <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
                <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading
                    <img src="../Purchase/Image/progress_bar.gif" /></span>
            </div>
        </ProgressTemplate>
    </Ajax:UpdateProgress>
    <Ajax:UpdatePanel ID="up" runat="server">
        <ContentTemplate>
            <div id="Pbody_box_inventory" style="width: 1100px;">
                <div class="POuter_Box_Inventory" style="width: 1096px;text-align: center;">
                   
                        <b>&nbsp;Department Master</b>&nbsp;<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

                    
                </div>
                <div class="POuter_Box_Inventory" style="width: 1096px;">
                    <div class="Purchaseheader">
                        Add Details&nbsp;
                    </div>
                 

                        <table style="width:100%;border-collapse:collapse" >
                            <tr>
                                <td style="text-align: right; width: 568px;"><b>Department Name :&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtdeptname" runat="server" Width="223px" Style="text-transform: uppercase;"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="r1" runat="server" ControlToValidate="txtdeptname" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtId" Visible="false" runat="server" /></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 568px;"><b>Description :&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddldescription" runat="server" Width="227px">
                                        <asp:ListItem Value="SELF">SELF</asp:ListItem>
                                        <asp:ListItem Value="PATHOLOGY">PATHOLOGY</asp:ListItem>
                                        <asp:ListItem Value="RADIOLOGY">RADIOLOGY</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 568px;"><b>Display Name :&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtdisplayname" runat="server" Width="223px" Style="text-transform: uppercase;"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="r2" runat="server" ControlToValidate="txtdisplayname" ErrorMessage="*" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 568px; font-weight: 700;">Booking Remarks :&nbsp;</td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtbokkingremarks" runat="server" Style="text-transform: uppercase;" Width="400px" MaxLength="500"></asp:TextBox>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 568px; font-weight: 700;">Report Line1 :&nbsp;</td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtline1" runat="server"  multiline="true" Width="400px" MaxLength="500"></asp:TextBox>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 568px; font-weight: 700;">Report Line2 :&nbsp;</td>
                                <td colspan="2">
                                    <asp:TextBox ID="txtline2" runat="server" multiline="true" Width="400px" MaxLength="500"></asp:TextBox>
                                </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
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
                                    <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="itdosebtnnew"  />
                                    <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="itdosebtnnew" ValidationGroup="save" />
                                </td>
                            </tr>
                        </table>

                    
                </div>


                <div class="POuter_Box_Inventory" style="width: 1096px;">
                    <div class="Purchaseheader">
                        Department List&nbsp;
                    </div>
                    <div class="content">
                        <table style="width:100%;border-collapse:collapse" >
                            <tr>
                                <td align="center"><strong>Search By Name :</strong><asp:TextBox ID="txtsearch" runat="server" Width="260px"></asp:TextBox>
                                    &nbsp;&nbsp;
                  <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="itdosebtnnew" />
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
                                                <asp:TemplateField HeaderText="Name">

                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("name") %>'></asp:TextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("active") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("displayname") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Description") %>' Visible="false"></asp:Label>
                                                         <asp:Label ID="Label11" runat="server" Text='<%# Bind("deptinterpretaion") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("reportline1") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("reportline2") %>' Visible="false"></asp:Label>
                                                        
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                                <asp:BoundField DataField="displayname" HeaderText="DisplayName" />
                                                <asp:BoundField DataField="deptinterpretaion" HeaderText="Booking Remarks" />
                                                <asp:BoundField DataField="status" HeaderText="Status" />
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

        </ContentTemplate>
    </Ajax:UpdatePanel>


</asp:Content>


