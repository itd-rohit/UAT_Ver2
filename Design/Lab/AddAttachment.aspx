<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AddAttachment.aspx.cs" Inherits="Design_Lab_AddAttachment" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="vertical-align: top; margin: -0px">
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Add File
            </div>
            <div class="row">
                <div class="col-md-3 col-xs-24" style="text-align: center">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 col-xs-24">
                    <label class="pull-left">Test   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21 col-xs-24">
                    <asp:DropDownList ID="ddlTests" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlTests_SelectedIndexChanged"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 col-xs-24">
                    <label class="pull-left">Select File   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 col-xs-24">
                    <asp:FileUpload ID="fu_Upload" runat="server" />
                </div>
                <div class="col-md-5 col-xs-24">
                    <asp:Button ID="btnSave" runat="server" Text="Upload" OnClick="btnSave_Click" ValidationGroup="fUpload" CssClass="savebutton" />
                    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload"
                        ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server" ForeColor="Red" ValidationGroup="fUpload"
                        ControlToValidate="fu_Upload" Display="Dynamic"
                        ErrorMessage="<br/>Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed."
                        ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
                </div>
            </div>
            <div class="row">
                <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                    CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 100%;" OnRowCommand="grvAttachment_RowCommand">
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <Columns>



                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />

                            </ItemTemplate>
                            <HeaderStyle Width="25px" />
                        </asp:TemplateField>


                        <asp:TemplateField>
                            <ItemTemplate>
                                <a target="_self" href='DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&Type=5&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
                                <asp:Label ID="lblPath" runat="server" Text='<%# Eval("FileUrl")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px" />


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

