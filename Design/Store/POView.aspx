<%@ Page Language="C#" AutoEventWireup="true" CodeFile="POView.aspx.cs" Inherits="Design_Store_POView" %>

<!DOCTYPE html>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
    <title></title>
   
</head>
<body style="width:805px">
      <%: Scripts.Render("~/bundles/WebFormsJs") %>
       <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript">

        function closeme() {
            window.parent.MakeAction('Approval');
            window.parent.$.fancybox.close();
        }
        
    </script>
    <form id="form1" runat="server">
        <iframe id="urIframe" runat="server" style="width:800px;height:475px;"></iframe>
        <br />
       <center>
           <%if(canapproved>0){ %>
           <input type="button" value="Approved" class="savebutton" onclick="closeme()" />
           <%} %>
       </center>

        </form>
</body>
</html>
