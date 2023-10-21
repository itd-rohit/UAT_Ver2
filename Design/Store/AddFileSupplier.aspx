<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddFileSupplier.aspx.cs" Inherits="Design_Store_AddFileSupplier" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="row">
                    <div class="col-md-24 ">
                       <b> Upload Attachment</b>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24 ">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </div>
                </div>
            </div>
             <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3 ">
                     <label class="pull-left ">Document Type   </label>
                        <b class="pull-right">:</b>
                    
                </div>
                <div class="col-md-5 ">
                    <%
                        if (Request.QueryString["PageName"] == "Centermaster")
                        {%>
                    <asp:DropDownList ID="ddlCenterMasterdoctype" runat="server">
                        <asp:ListItem Value="MOU">MOU</asp:ListItem>
                        <asp:ListItem Value="PANCard">Pan Card</asp:ListItem>
                        <asp:ListItem Value="AddressProof"> Address Proof</asp:ListItem>
                        <asp:ListItem Value="Others">Others</asp:ListItem>
                    </asp:DropDownList>
                    <% }
                            else
                            {
                    %>
                    <asp:DropDownList ID="ddldoctype" runat="server">
                    </asp:DropDownList>
                    <% } %>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left ">Select File  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:FileUpload ID="fu_Upload" runat="server" />
                </div>
                <div class="col-md-3 ">
                    <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" OnClick="btnSave_Click" ValidationGroup="fUpload" />
                    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
                        ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server" ValidationGroup="fUpload" ForeColor="Red"
                        ControlToValidate="fu_Upload" Display="Dynamic"
                        ErrorMessage="<br/>Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed."
                        ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24 ">
                    <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                        CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowCommand="grvAttachment_RowCommand">
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <Columns>

                            <asp:TemplateField HeaderText="File Type">
                                <ItemTemplate>
                                    <asp:Label ID="FileName" runat="server" Text='<%# Bind("FileName") %>'></asp:Label>
                                    <asp:Label ID="lblPath" runat="server" Text='<%# Eval("AttachedFile")%>' Style="display: none;"></asp:Label>

                                </ItemTemplate>

                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="File Name">
                                <ItemTemplate>

                                    <a target="_self" href='DownloadAttachement.aspx?FileName=<%# Eval("AttachedFile")%>&FilePath=<%# Eval("AttachedFile")%>'><%# Eval("OriginalFileName")%></a>
                                    <asp:Label ID="OriginalFileName" Visible="false" runat="server" Text='<%# Bind("OriginalFileName") %>'></asp:Label>
                                </ItemTemplate>

                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />

                                </ItemTemplate>
                                <HeaderStyle Width="25px" />
                            </asp:TemplateField>
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
            </div>
    </form>
</body>
</html>
