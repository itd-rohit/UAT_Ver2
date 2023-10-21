<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AddSupportAttachment.aspx.cs" Inherits="Design_Support_AddSupportAttachment" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../Purchase/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Upload File</div>
            <div class="row" style="text-align: center;">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    Select File:
                </div>
                <div class="col-md-5">
                    <asp:FileUpload ID="fu_Upload" runat="server" />
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnSave" runat="server" Text="Upload" OnClick="btnSave_Click" ValidationGroup="fUpload" />
                </div>

            </div>
            <div class="row" style="text-align: center;">
                <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                    CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 600px;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <Columns>



                        <asp:TemplateField HeaderText="Remove">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/Design/Purchase/Image/Delete.gif" runat="server" />

                            </ItemTemplate>
                            <HeaderStyle Width="25px" />
                        </asp:TemplateField>





                        <asp:TemplateField HeaderText="File Name">
                            <ItemTemplate>
                                <a target="_new" href='../../Design/Lab/DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&FilePath=<%# Eval("FileUrl")%>&IsSupport=1'><%# Eval("AttachedFile")%></a>
                                <asp:Label ID="lblPath" Visible="false" runat="server" Text='<%# Eval("FileUrl")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="150px">


                            <ItemStyle Width="100px"></ItemStyle>
                        </asp:BoundField>


                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"
                        HorizontalAlign="Left" />
                    <EditRowStyle BackColor="#999999" />
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                </asp:GridView>
            </div>
        </div>
    </div>
  
</asp:Content>

