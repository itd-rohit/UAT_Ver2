<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddcentrePanel.aspx.cs" Inherits="Design_Master_AddcentrePanel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />


    <title>Add Panel</title>
</head>
<body>
    <form id="form1" runat="server">
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
        <Ajax:UpdatePanel ID="mm" runat="server">
            <ContentTemplate>

                <div id="Pbody_box_inventory" style="width: 700px;">
                    <div class="POuter_Box_Inventory" style="width: 696px;">
                        <div class="content" style="text-align: center" style="width: 700px;">
                            <b>
                                <asp:Label ID="lbheder" Font-Bold="true" runat="server"></asp:Label></b>
                            <br />
                            <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="content" style="text-align: center">
                            &nbsp;
                        </div>
                    </div>
                    <div class="POuter_Box_Inventory" style="text-align: left; width: 696px;">
                        <div class="content" style="width: 700px;">

                            <table style="width: 600px;">
                                <tr>
                                    <td style="font-weight: bold; color: red;">Centre Name::<asp:Label ID="lb" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="height: 450px; overflow: scroll;">
                                            <asp:GridView ID="grd" OnRowDataBound="grd_RowDataBound" runat="server" Width="100%" AutoGenerateColumns="False" CellPadding="3" EnableModelValidation="True" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Panel Name">
                                                        <HeaderTemplate>
                                                            Panel::
                                                            <asp:TextBox ID="txtearch" Width="300px" runat="server" placeholder="Search Panel" />
                                                            <asp:Button Style="cursor: pointer" ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" ForeColor="White" BackColor="Red" />
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("company_name") %>'></asp:Label>
                                                            <asp:Label ID="Label2" runat="server" Visible="false" Text='<%# Bind("panel_id") %>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Select">

                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="chk" runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <FooterStyle BackColor="White" ForeColor="#000066" />
                                                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                                <RowStyle ForeColor="#000066" />
                                                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                                            </asp:GridView>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">
                                        <asp:Button Font-Bold="true" ID="btnsave" OnClick="btnsave_Click" runat="server" Text="Save " Style="cursor: pointer; background-color: maroon; color: white; padding: 5px;" />
                                    </td>
                                </tr>
                            </table>



                        </div>



                    </div>



                </div>

            </ContentTemplate>


        </Ajax:UpdatePanel>
    </form>
</body>
</html>
