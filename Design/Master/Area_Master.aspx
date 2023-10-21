<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Area_Master.aspx.cs" Inherits="Design_Master_Area_Master" MasterPageFile="~/Design/DefaultHome.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Area Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Area Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="TxtCName" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="txtID" runat="server" class="requiredField" Visible="False"></asp:TextBox>

                </div>
                <div class="col-md-4">
                    <label class="pull-left">Country </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4 ">
                    <asp:DropDownList ID="ddlCountry" CssClass="chosen-select" runat="server">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 ">
                    <label class="pull-left">Is Active</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlActive" runat="server">
                        <asp:ListItem Value="0">No</asp:ListItem>
                        <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 ">
                </div>
                <div class="col-md-4 " style="padding-left:221px">
                    <asp:Button ID="BtnSaveCentre" runat="server" Text="Save" Width="52px" OnClick="BtnSaveCentre_Click" CssClass="ItDoseButton" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Area Detail&nbsp;&nbsp;&nbsp;                 
            </div>
            <div id="PatientLabSearchOutput">
                <table id="Addcentre" runat="server" style="text-align: left; width: 945px;">
                    <tr>
                        <td colspan="2">
                            <asp:Panel ID="Panel1" ScrollBars="Horizontal" CssClass="" runat="server">
                                <asp:GridView ID="GrdCentres" AutoGenerateColumns="False" AllowPaging="true" OnPageIndexChanging="GrdCentres_PageIndexChanging" runat="server" CssClass="GridViewStyle" Width="956px" OnSelectedIndexChanged="GrdCentres_SelectedIndexChanged">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <RowStyle CssClass="GridViewItemStyle" />
                                    <Columns>
                                        <asp:BoundField DataField="ID" HeaderText="ID">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="name" HeaderText="Area">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="CountryName" HeaderText="Country">
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
                                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="4" FirstPageText="First" LastPageText="Last" />
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            
        });

    </script>
</asp:Content>
