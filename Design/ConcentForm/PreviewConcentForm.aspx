<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="PreviewConcentForm.aspx.cs" Inherits="Design_Lab_PreviewConcentForm" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head  runat="server">
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
</head>
<body>
 <form id="form1" runat="server">
    
    <div class="POuter_Box_Inventory"  style="text-align:center;">
        <div class="row"><div class="col-md-24"><b>Preview Concent Form</b></div> </div>  </div>
     <div class="POuter_Box_Inventory"  style="text-align:center;">
          
   <div class="POuter_Box_Inventory" >
       <div class="row">
           <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
       </div>
       <div class="row">
          <asp:Image runat="server" Style="width: 94%; height: 600px; border: 1px solid black;" id="mm"/>
       </div>
   </div>
</div>
         
 
      </form>
</body>
</html>
<%--</asp:Content>--%>

