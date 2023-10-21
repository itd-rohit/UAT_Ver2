<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CityMaster.aspx.cs" Inherits="Design_B2CMobile_CityMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top:-42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />

            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>City Master</b>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">City Master</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">City Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="TxtCName" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtID" runat="server" Visible="False"></asp:TextBox>

                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Is Active   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlActive" runat="server">
                            <asp:ListItem Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-5">
                        <asp:CheckBox ID="CheckBox1" runat="server" /><asp:Label runat="server" AssociatedControlID="CheckBox1" ID="lblid" Text="IsDefault"></asp:Label>
                    </div>
                    <div class="col-md-2">
                        <asp:Button ID="BtnSaveCentre" runat="server" Text="Save" Width="120px" OnClick="BtnSaveCentre_Click" CssClass="savebutton" />
                    </div>

                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <asp:GridView ID="GrdCentres" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" Width="98%" OnSelectedIndexChanged="GrdCentres_SelectedIndexChanged">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <RowStyle CssClass="GridViewItemStyle" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="name" HeaderText="City">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IsDefault" HeaderText="IsDefault">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Active" HeaderText="Active">
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
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
