<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AddFileAppointment.aspx.cs" Inherits="Design_OPD_AddFileAppointment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <link href="../Purchase/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        jQuery(function () {
            jQuery('#divMasterNav').hide();
        });
    </script>
        <div id="Pbody_box_inventory" style="width: 780px" >
      <div class="POuter_Box_Inventory" style="width: 780px" >
          <div class="Purchaseheader">Upload File</div>
    <div class="content">
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />

    Document Type: <asp:DropDownList ID="ddldoctype" Width="200px" runat="server" /><br /><br />
    Select File:
    <asp:FileUpload ID="fu_Upload" runat="server"  />
    <asp:Button ID="btnSave" runat="server" Text="Upload" onclick="btnSave_Click"    ValidationGroup="fUpload"  />
    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload"
        ErrorMessage="*"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server"   ValidationGroup="fUpload" 
ControlToValidate="fu_Upload" Display="Dynamic" 
ErrorMessage="<br/>Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed."
ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>

    <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False" 
        CellPadding="4" ForeColor="#333333" GridLines="None" style="width:100%;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <Columns>
       
            <%--<asp:BoundField DataField="AttachedFile" HeaderText="File Name" ItemStyle-Width="250px" />--%>

            <asp:TemplateField>
            <ItemTemplate>
                <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="../../App_Images/Delete.gif" runat="server" />
                
            </ItemTemplate>
            <HeaderStyle Width="25px" />
            </asp:TemplateField>


            <asp:BoundField DataField="doctype" HeaderText="DocType" />


            <asp:TemplateField>
            <ItemTemplate>
            <a target="_new" href='ShowAttachedfile.aspx?fileurl=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
            <asp:Label ID="lblPath" runat="server" Text='<%# Eval("FileUrl")%>'></asp:Label>
            </ItemTemplate>
            </asp:TemplateField>


            <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px" >
<ItemStyle Width="150px"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px" >
            

<ItemStyle Width="100px"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField />
            

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
          </div></div>
</asp:Content>

