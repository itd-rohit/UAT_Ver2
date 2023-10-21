<%@ Page Language="C#" AutoEventWireup="true" CodeFile="B2CCancelReasion.aspx.cs" Inherits="Design_Master_B2CCancelReasion" Title="Untitled Page" %>

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
                  <asp:ScriptReference Path="~/Scripts/toastr.min.js"/>

            </Scripts>
        </Ajax:ScriptManager>

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Cancel Reason Master</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Cancel Reason Master</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Cancel Reason   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-12">



                        <asp:TextBox ID="txtcancelReason" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtID" runat="server" Visible="False"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Is Active   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlActive" runat="server">
                            <asp:ListItem Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="row" style="text-align: center">
                    <asp:Button ID="btnSampleRejection" runat="server" Text="Save" Width="100px" OnClick="BtnSampleRejection_Click" CssClass="savebutton" />&nbsp;
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24" style="text-align:center">                        
                            <asp:GridView ID="GrdSampleRejection" AutoGenerateColumns="False" runat="server" Width="100%" CssClass="GridViewStyle" OnSelectedIndexChanged="GrdCentres_SelectedIndexChanged">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <RowStyle CssClass="GridViewItemStyle" />
                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="CancelReason" HeaderText="Reason">
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

