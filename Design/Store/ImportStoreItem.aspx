<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ImportStoreItem.aspx.cs" Inherits="Design_Store_ImportStoreItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/JQueryStore") %>    
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Import Store Item Group</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4">
                    <asp:Button ID="btndownloadexcel" runat="server" OnClick="btndownloadexcel_Click" Text="Download Sample Excel" Style="font-weight: 700" CssClass="searchbutton" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Select File  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">

                    <asp:FileUpload ID="file1" runat="server" Style="font-weight: 700" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" CssClass="searchbutton" />
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnsave" runat="server" Text="Save To DataBase" OnClick="btnsave_Click" CssClass="savebutton" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="padding: 0px;">
                    <div style="width: 100%; overflow-y: auto">
                        <asp:GridView ID="grd" runat="server" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black">
                            <Columns>
                                <asp:TemplateField HeaderText="SrNo">

                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Select">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chk" Checked="true" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#CCCCCC" />
                            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                            <RowStyle BackColor="White" />
                            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#808080" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#383838" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>



