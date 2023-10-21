<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="AddPanelAttachment.aspx.cs" Inherits="Design_Lab_AddPanelAttachment" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head  runat="server">
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
</head>
<body>
 <form id="form1" runat="server">
    
    <div class="POuter_Box_Inventory"  style="text-align:center;">
        <div class="row"><div class="col-md-24"><b>Attach Panel Document</b></div> </div>  </div>
     <div class="POuter_Box_Inventory"  style="text-align:center;">
          
   <div class="POuter_Box_Inventory" >
       <div class="row">
           <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
       </div>
       <div class="row">
           <div class="col-md-5">Select Panel:</div>
          <div class="col-md-5"> <asp:DropDownList ID="ddlPanel" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged"></asp:DropDownList></div>
           </div>
       <div class="row">
           <div class="col-md-5">Select File:</div>
           <div class="col-md-3">
    <asp:FileUpload ID="fu_Upload" runat="server"  /></div>
           <div class="col-md-3">
    <asp:Button ID="btnSave" runat="server" Text="Upload" onclick="btnSave_Click"    ValidationGroup="fUpload"  />
    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload"
        ErrorMessage="*"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server"   ValidationGroup="fUpload" 
ControlToValidate="fu_Upload" Display="Dynamic" 
ErrorMessage="<br/>Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed."
ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
           </div>
       </div>
       <div class="row">
            <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False" 
        CellPadding="4" ForeColor="#333333" GridLines="None" style="width:100%;" OnRowCommand="grvAttachment_RowCommand">
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <Columns>
       
            <%--<asp:BoundField DataField="AttachedFile" HeaderText="File Name" ItemStyle-Width="250px" />--%>

            <asp:TemplateField>
            <ItemTemplate>
                <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />
                
            </ItemTemplate>
            <HeaderStyle Width="25px" />
            </asp:TemplateField>


            <asp:TemplateField>
            <ItemTemplate>
            <a target="_blank" href='DownloadAttachment.aspx?Type=4&FileName=<%# Eval("AttachedFile")%>&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
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
         
 
      </form>
</body>
</html>
<%--</asp:Content>--%>

