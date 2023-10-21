<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="AddFileRegistration.aspx.cs" Inherits="Design_Lab_AddFileRegistration" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 
    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  

</Ajax:ScriptManager>
      <div class="POuter_Box_Inventory">
          <div class="Purchaseheader">Upload Attachment</div>
    <div class="content">
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />

    
        <strong>Document Type:</strong> 
         
        <%
                if (Request.QueryString["PageName"] == "Centermaster")
            {%>
            <asp:DropDownList ID="ddlCenterMasterdoctype" Width="200px" runat="server">  
            <asp:ListItem Value="MOU">MOU</asp:ListItem>                                  
              <asp:ListItem Value="PANCard">Pan Card</asp:ListItem>
              <asp:ListItem Value="AddressProof"> Address Proof</asp:ListItem>
              <asp:ListItem Value="Others">Others</asp:ListItem>
            </asp:DropDownList>
            <% } 
            else 
            {
            %>
        <asp:DropDownList ID="ddldoctype" Width="200px" runat="server">  
                                        </asp:DropDownList>
                                         <% } %>
                                        <br />
        <strong>Select File:</strong>
    <asp:FileUpload ID="fu_Upload" runat="server"  />
    <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" onclick="btnSave_Click"    ValidationGroup="fUpload"  />
    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
        ErrorMessage="*"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server"   ValidationGroup="fUpload" ForeColor="Red" 
ControlToValidate="fu_Upload" Display="Dynamic" 
ErrorMessage=""
ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>
        <asp:Label runat="server" ForeColor="Red" Text="<br/>Note:- <br/>1. Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed.<br/>2. Maximum file size upto 10 MB."></asp:Label>
    <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False" 
        CellPadding="4" ForeColor="#333333" GridLines="None" style="width:99%;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        <Columns>
       
            <%--<asp:BoundField DataField="AttachedFile" HeaderText="File Name" ItemStyle-Width="250px" />--%>

            <asp:TemplateField>
            <ItemTemplate>
                <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />
                
            </ItemTemplate>
            <HeaderStyle Width="25px" />
            </asp:TemplateField>


            <asp:BoundField DataField="doctype" HeaderText="DocType" />


            <asp:TemplateField>
            <ItemTemplate>
            <a target="_self" href='DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a> 
		   <%--<a target="_self" href='<%# Eval("DocPath")%>' target="_blank"><%# Eval("AttachedFile")%></a>--%>
            <asp:Label ID="lblPath" runat="server" Text='<%# Eval("AttachedFile")%>' style="display:none;"></asp:Label>
             <asp:Label ID="CenterID" runat="server" Text='<%# Eval("CenterID")%>' style="display:none;"></asp:Label>
                
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
          </div>
</form>
</body>
</html>

