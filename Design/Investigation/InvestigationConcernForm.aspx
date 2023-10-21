<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InvestigationConcernForm.aspx.cs" Inherits="Design_Investigation_InvestigationConcernForm" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="PurchaseHeader" style="text-align: center;">
                <b>Tag Concern Form with Investigation</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>
            <div class="content" style="text-align: right">
                <asp:Button ID="btn" runat="server" CssClass="searchbutton" Text="Create New Form" OnClick="btn_Click" />
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-10" style="font-weight: bold; color: red; text-align: left;">
                    Investigation ::&nbsp;<asp:Label ID="lb" runat="server"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Width="99%" OnSelectedIndexChanged="grd_SelectedIndexChanged" OnRowDataBound="grd_RowDataBound">
                                    <AlternatingRowStyle BackColor="White" />
                                    <Columns>
                                       <asp:TemplateField HeaderText="Sr No">
                                           <ItemTemplate>
                                              <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                       </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Form Name">
                                          
                                            <ItemTemplate>
                                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("concentformname") %>'></asp:Label>
                                                 
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="File Name">
                                             <ItemTemplate>
                                              
                                                 <asp:Label ID="Label2" runat="server" Text='<%# Bind("filename") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:CommandField ShowSelectButton="True"   HeaderText="View Form" SelectText="View"/>


                                        <asp:TemplateField HeaderText="Select">
                                           <ItemTemplate>
                              <asp:CheckBox ID="chk" runat="server" />
                           </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                    <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                                    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                                    <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                                    <SortedAscendingCellStyle BackColor="#FDF5AC" />
                                    <SortedAscendingHeaderStyle BackColor="#4D0000" />
                                    <SortedDescendingCellStyle BackColor="#FCF6C0" />
                                    <SortedDescendingHeaderStyle BackColor="#820000" />
                                </asp:GridView>
                </div>
            </div>
            </div>
        
         <div class="POuter_Box_Inventory" style="text-align:center">
             <div class="row">
                 <asp:Button ID="btnsaveall" runat="server" CssClass="savebutton" Text="Save" OnClick="btnsaveall_Click" />
             </div>
             </div>

        </div>


    <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 875px; background-color: papayawhip">

            <div class="content" style="text-align: center;">
                <asp:Image ID="img"  runat="server" Style="width: 400px; height: 450px;" />
                <iframe id="frm" runat="server" style="width: 400px; height: 450px;" ></iframe>

                <br />
                <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />

                   </div>
              </div>
    </asp:Panel>


     <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd"  TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />


</asp:Content>

