<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" 
MaintainScrollPositionOnPostback="true" CodeFile="FooterNote.aspx.cs" Inherits="Design_Store_FooterNote" Title="Vendor / Footer Note"
 enableEventValidation="false" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: System.Web.Optimization.Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <div id="Pbody_box_inventory" style="width:98%;">
        <div class="POuter_Box_Inventory" style="text-align: center;width:99.7%;">

            <b>Vendor / Footer Note<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


       
        <div class="POuter_Box_Inventory" style="width:99.7%;">
             <div class="Purchaseheader">
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 
                Vendor Note              
               
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                Footer Note
            </div>
            <table style="width: 100%" border="0">
               
                <tr>
                    
                    <td>


                        <CKEditor:CKEditorControl ID="txtVendorNote" BasePath="~/ckeditor" runat="server" EnterMode="BR" Width="660px"></CKEditor:CKEditorControl>

                    </td>
                     <td>


                        <CKEditor:CKEditorControl ID="txtFooterNote" BasePath="~/ckeditor" runat="server" EnterMode="BR" Width="650px"></CKEditor:CKEditorControl>

                    </td>
                </tr>
              <tr>
                   
                    <td align="center" colspan="2">
                        <asp:Button ID="Button1" runat="server" OnClick="btnSave_Click" Text="Save" Width="80px" CssClass="savebutton" />                     
                         </td>
                </tr>
                
                
            </table>
         
        </div>
        </div>
      
</asp:Content>

