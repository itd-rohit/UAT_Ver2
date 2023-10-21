<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageContentType.aspx.cs" Inherits="Design_Default2" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div style="display:inline-block;padding-left:10%;padding-right:10%;width:80%">
         <br /><br />
         <h2 style="color: #9b0000; text-align: center">
             Manage Content Type
         </h2>
         <div style="border:solid 2px #83D13D; padding:5px;-moz-border-radius: 5px;
-webkit-border-radius: 5px; background-color:#F2FFE1; text-align: center;width:100%">

         <table width="100%">
             <tr><asp:Label runat="server" ID="lblMessage" ForeColor="Red" Font-Bold="true"></asp:Label></tr>
             <tr>
                 <td align="center">
<table >
             <tr id="select">
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                      Type:</td>
                 <td style="text-align: left">
                 </td>
                 <td style="text-align: left">
                     <asp:DropDownList ID="ddlContentType" runat="server" Width="201px" OnSelectedIndexChanged="BindContentValue" AutoPostBack="true">
                     </asp:DropDownList>
                      <asp:TextBox runat="server" ID="txtContentType"></asp:TextBox>
                 </td>
                 <td>
                     <asp:Button runat="server" ID="btnAddType" OnClick="AddNewType" Text="Add New Type" />
                 </td>
                 <td>
                     <asp:Button runat="server" ID="btnCancel" OnClick="Cancel" Text="Cancel" />
                 </td>
             </tr>
            <%--<tr style="display:none" id="typeDiv">
                 <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">
                      Type:</td>
                <td style="text-align: left"></td>
                <td  style="text-align: left">
                   
                </td>
            </tr>--%>
            <br />
            <tr>
                <td colspan="5">
                    <CKEditor:CKEditorControl ID="ckeContentValue" BasePath="~/ckeditor" runat="server"></CKEditor:CKEditorControl>
                </td>
            </tr>
            <tr>
                <td colspan="5" style="text-align:center">
                    <asp:Button runat="server" Text="Save" ID="btnSave" OnClick="SaveContent" />
                </td>
            </tr>
         </table>
                 </td>
             </tr>
         </table>
         
         
         </div>

     </div> 
    <script type="text/javascript">
        $(document).ready(function () {
            //$('#AddContentType').click(function () {
            //    $('#typeDiv').show();
            //});
        });
    </script>
</asp:Content>

