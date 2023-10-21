<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemBarcodeMapping.aspx.cs" Inherits="Design_Store_ItemBarcodeMapping" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <title></title>
      <%: Scripts.Render("~/bundles/WebFormsJs") %>
       <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

     <script type="text/javascript">
         function mycheck() {

             if ($('#<%=txtbarcodeno.ClientID%>').val().trim() == "") {
                 $('#<%=txtbarcodeno.ClientID%>').focus();
                 showerrormsg("Please Enter Barcode No");
                 return false;
             }
             return true;
         }

         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         </script>
</head>
<body>
    
    <form id="form1" runat="server">

        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

 
<Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 


         <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
      <div id="Pbody_box_inventory" style="width:650px;">
   <div class="POuter_Box_Inventory" style="width:650px;">
            <div class="content" style="height:50px;">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Store Item Mapping With Barcode</b>
                            <br />
                            <asp:Label ID="lbmsg" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                </table>
                </div>
       </div>

          <div class="POuter_Box_Inventory" style="width:650px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">Item :</td>

                        <td>
                            <asp:DropDownList ID="ddlitem" runat="server" Width="500px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700">Barcode No :</td>
                        <td>
                            <asp:TextBox ID="txtbarcodeno" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="font-weight: 700; text-align: center">

                            <asp:Button ID="btnsave" Text="Map Barcode" runat="server" CssClass="savebutton" OnClick="btnsave_Click" OnClientClick="return mycheck();" />
                        </td>
                    </tr>
                </table>
                </div>
          </div>
       </ContentTemplate>

           
      </Ajax:UpdatePanel> 
    </form>
</body>
</html>
