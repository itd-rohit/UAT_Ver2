<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HistotempleteMaster.aspx.cs" Inherits="Design_Investigation_HistotempleteMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

   
   <script type="text/javascript" language="javascript">
       function ConfirmOnDelete(item, type) {
           var msg = "";
           if (type == "1") {
               msg = "Are you sure to deactive : " + item + "?";
           }
           else {
               msg = "Are you sure to active : " + item + "?";
           }
           if (confirm(msg) == true)
               return true;
           else
               return false;
       }
    </script>
     <Ajax:ScriptManager  ID="ScriptManager1" runat="server">
     </Ajax:ScriptManager>
<Ajax:UpdatePanel ID="up" runat="server">
    <ContentTemplate>
        <div id= "Pbody_box_inventory">
<div class="POuter_Box_Inventory">
<div class="content" style="text-align:center;">   
<b>Templete Master</b>&nbsp;<br />
<asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

</div> 
</div>
<div class="POuter_Box_Inventory" >
        <div class="Purchaseheader" >
            Add Details&nbsp;</div>
            <div class="content">
    <table width="100%">
    <tr><td style="height: 26px; text-align: center;"><asp:Label ID="lblAntibiotic" runat="server" Text="Template Name:"></asp:Label>
    <asp:TextBox ID="txtAntibiotic" runat="server"></asp:TextBox>
     <asp:TextBox ID="txtId" runat="server" Visible="false"></asp:TextBox>
        Template Type:<asp:DropDownList ID="ddltype" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddltype_SelectedIndexChanged">
            <asp:ListItem Value="Gross">Gross</asp:ListItem>
            <asp:ListItem Value="MicroScopic">MicroScopic</asp:ListItem>
            <asp:ListItem Value="Impression">Impression</asp:ListItem>
        </asp:DropDownList>
        <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" />
</td>
   </tr>
        <tr>
                            <asp:DropDownList ID="ddlDepartment" runat="server">
                            </asp:DropDownList>
        </tr>
        <tr>
            <td style="height: 26px;" align="center">

              <%--<ckeditor:ckeditorcontrol ID="txtLimit"  BasePath="~/ckeditor" runat="server"  Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|Font|FontSize|"   EnterMode="BR" Height="200px" Width="780px"></ckeditor:ckeditorcontrol>--%>
                <CKEditor:CKEditorControl ID="txtLimit" BasePath="~/ckeditor" runat="server" EnterMode="BR" Height="200px" Width="780px"></CKEditor:CKEditorControl>
            </td>
        </tr>
   <tr><td align="center" style="height: 26px">
       
   <asp:Button  runat="server" ID="btnSave" Text="Save" OnClick="btnSave_Click" />
   <asp:Button  runat="server" ID="btnUpdate" Text="Update"  OnClick="Unnamed_Click"/></td>
   </tr>
                </table>
    </div>
    </div>


        <div class="POuter_Box_Inventory" >
        <div class="Purchaseheader" >
            Templete List&nbsp;</div>
            <div class="content">
    <table width="100%">
          <tr>
              <td align="center">Search :<asp:TextBox  ID="txtsearch" runat="server"  ></asp:TextBox>
                  &nbsp;&nbsp;
                  <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" />
              </td>
          </tr>
                 <tr><td align="center">

       <div style="overflow:scroll;height:380px;">
       <asp:GridView ID="GridView1" class="GridViewStyle" runat="server" AutoGenerateColumns="False" OnRowDeleting="GridView1_RowDeleting" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" Width="600px">
           <Columns>
               <asp:TemplateField HeaderText="S. No.">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <EditItemTemplate>
                       <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("SpecimenID") %>'></asp:TextBox>
                   </EditItemTemplate>
                   <ItemTemplate>
                       <asp:Label ID="Label1" Visible="false" runat="server" Text='<%# Bind("SpecimenID") %>'></asp:Label>
                       <asp:Label ID="lblsno" runat="server" Text='<%#Container.DataItemIndex+1 %>'></asp:Label>
                       
                   </ItemTemplate>
               </asp:TemplateField>
               <asp:TemplateField HeaderText="Template Name">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <EditItemTemplate>
                       <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("SpecimenName") %>'></asp:TextBox>
                   </EditItemTemplate>
                   <ItemTemplate>
                       <asp:Label ID="Label2" runat="server" Text='<%# Bind("SpecimenName") %>'></asp:Label>
                   </ItemTemplate>
               </asp:TemplateField>
                  <asp:TemplateField HeaderText="Subcategory">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <EditItemTemplate>
                       <asp:TextBox ID="txtsubcategory" runat="server" Text='<%# Bind("SubCategory") %>'></asp:TextBox>
                   </EditItemTemplate>
                   <ItemTemplate>
                       <asp:Label ID="Labelsub" runat="server" Text='<%# Bind("Subcategory") %>'></asp:Label>
                       <asp:Label ID="Labelsubid" Visible="false" runat="server" Text='<%# Bind("SubCategoryID") %>'></asp:Label>
                   </ItemTemplate>
               </asp:TemplateField>
               
               <asp:TemplateField HeaderText="Active">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <EditItemTemplate>
                       <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("IsActive") %>'></asp:TextBox>
                   </EditItemTemplate>
                   <ItemTemplate>
                         <asp:Label ID="Label4"  runat="server" Text='<%# Bind("status") %>'></asp:Label>
                       <asp:Label ID="Label3" Visible="false" runat="server" Text='<%# Bind("IsActive") %>'></asp:Label>
                   </ItemTemplate>
               </asp:TemplateField>
               <asp:TemplateField HeaderText="Edit">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <ItemTemplate>
                       <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                           Text="Select"></asp:LinkButton>
                   </ItemTemplate>
                   
               </asp:TemplateField>

               <asp:TemplateField HeaderText="Delete">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <ItemTemplate>
                       <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                           Text="Deactive"></asp:LinkButton>
                   </ItemTemplate>
                   
               </asp:TemplateField>
           </Columns>
       </asp:GridView>
</div>
       </td>
   </tr>
            
        </table>
                </div></div>
        </div>

    </ContentTemplate>
</Ajax:UpdatePanel>  
    
      
     </asp:Content>

