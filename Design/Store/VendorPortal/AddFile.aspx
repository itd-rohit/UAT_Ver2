<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddFile.aspx.cs" Inherits="Design_Store_VendorPortal_AddFile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
      <link href="../../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
      <div id="Pbody_box_inventory" style="width: 600px; min-height:300px;">

          <div class="POuter_Box_Inventory" style="width: 600px">
            <div class="Purchaseheader">Upload Invoice</div>
            <div class="content">

                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


           


               
                <br />
     <asp:Label ID="lb" Font-Bold="true" Text="Select File : " runat="server" />
                <asp:FileUpload ID="fu_Upload" runat="server" />
                <asp:Button ID="Button1" runat="server" Text="Upload" CssClass="savebutton" OnClick="Button1_Click" ValidationGroup="fUpload" />
                <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
                    ErrorMessage="*"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server" ValidationGroup="fUpload" ForeColor="Red"
                    ControlToValidate="fu_Upload" Display="Dynamic"
                    ErrorMessage="<br/>Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed."
                    ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>

           

                <br />

                <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                    CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowCommand="grvAttachment_RowCommand">
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <Columns>

                        <asp:TemplateField HeaderText="File">
                            <ItemTemplate>
                                <asp:Label ID="FileName" runat="server" Text='<%# Bind("File") %>'></asp:Label>
                                 <asp:Label ID="lblPath" runat="server" Text='<%# Eval("Filename")%>' style="display:none;"></asp:Label>
                                  
             
                            </ItemTemplate>

                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="File Name">
                            <ItemTemplate>

                                 <a target="_self" href='DownloadFile.aspx?FileName=<%# Eval("Filename")%>'><%# Eval("Filename")%></a>
                               
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
    </form>
</body>
</html>
