<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InvestigationRole.aspx.cs" Inherits="Design_Investigation_InvestigationRole" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>               
 <script type="text/javascript">
 $(document).ready(function(){
 
 $("#<%=chkSelectAll.ClientID %>").click(function(){
     $("#<%=chkRole.ClientID %> :checkbox").prop("checked", $(this).is(":checked"));
  });

  
         var Investigation_ID = '<%=InvID %>';
         if (Investigation_ID != "") {
             
             $('#ctl00_ddlUserName').hide();
             $('.Hider').hide();
         }
         else {

            
             $('#ctl00_ddlUserName').show();
             $('.Hider').show();
         }
 });
 </script>
<div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory" style="text-align:center;">
    
    <b></b><strong>Map Investigation to Role</strong><br />
        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />      
    
    </div>
    
    
     <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Role List&nbsp;<asp:CheckBox ID="chkSelectAll" runat="server"
                       Text="Select All" />
          </div>
          
            <asp:Label ID="lblInvName" runat="server" Visible="false" Font-Size="Large" ForeColor="Green"></asp:Label>
       <br />
        <br />
  
        <asp:CheckBoxList ID="chkRole" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" Width="956px">
        </asp:CheckBoxList>&nbsp;</div>
   <div class="POuter_Box_Inventory" style="text-align:center">
    <asp:Button ID="BtnSave" runat="server" Text="Save"  CssClass="ItDoseButton"
            onclick="BtnSave_Click" /> </div>
     </div>
</asp:Content>

