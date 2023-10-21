<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="InvestigationRequiredFields.aspx.cs" Inherits="Design_Investigation_InvestigationRequiredFields" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
         <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 

    <div id="Pbody_box_inventory" style="width:705px;">
        <div class="POuter_Box_Inventory"style="width:700px;" >

            <b>Required Fields</b>
        </div>
        <div class="POuter_Box_Inventory" style="width:700px;">
            <div class="content" style="text-align: center" style="width:700px;">
                <b>Investigation Required Filed For Booking</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" style="color:red;" Font-Bold="true"></asp:Label>
            </div>
            <div class="content" style="text-align: center">
                &nbsp;</div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:left;width:700px;" >
        <div class="content" style="width:700px;">
       
   <table style="width:600px;">
        <tr>
           <td style="font-weight:bold;color:red;">
               Test Name::<asp:Label ID="lb" runat="server"></asp:Label>
               </td>
            </tr>
       <tr>
           <td>
               <div class="Purchaseheader">Fields</div>
               <div style="height:450px;overflow:auto;">
               <asp:GridView ID="grd" OnRowDataBound="grd_RowDataBound" runat="server" Width="100%" AutoGenerateColumns="False" CellPadding="3" EnableModelValidation="True" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
                   <Columns>
                       <asp:TemplateField HeaderText="Field Name">
                         
                           <ItemTemplate>
                               <asp:Label ID="Label1" runat="server" Text='<%# Bind("fieldname") %>'></asp:Label>
                                <asp:Label ID="Label2" runat="server" Text='<%# Bind("id") %>' style="display:none;"></asp:Label>
                           </ItemTemplate>
                       </asp:TemplateField>
                       <asp:TemplateField HeaderText="ShowOnBooking">
                           
                           <ItemTemplate>
                               <asp:CheckBox ID="chk" runat="server" />
                           </ItemTemplate>
                       </asp:TemplateField>

                        <asp:TemplateField HeaderText="ShowOnSampleCollection">
                           
                           <ItemTemplate>
                               <asp:CheckBox ID="chk1" runat="server" />
                           </ItemTemplate>
                       </asp:TemplateField>


                   </Columns>
                   <FooterStyle BackColor="White" ForeColor="#000066" />
                   <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                   <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                   <RowStyle ForeColor="#000066" />
                   <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
               </asp:GridView>
</div>
           </td> </tr>
         
            <tr>
            <td style="text-align:center;">
                <asp:Button Font-Bold="true" ID="btnsave" OnClick="btnsave_Click" runat="server" Text="Save Fields" style="cursor:pointer;background-color:maroon;color:white;padding:5px;" />
            </td>
       </tr>
   </table>
        
    
   
        </div>
        
        
        
        </div>



</div>

               </ContentTemplate>

          
      </Ajax:UpdatePanel> 
   </asp:Content>
