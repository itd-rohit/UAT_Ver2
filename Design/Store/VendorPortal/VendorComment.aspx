<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VendorComment.aspx.cs" Inherits="Design_Store_VendorPortal_VendorComment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     
    <title></title>
</head>
<body>
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <form id="form1" runat="server">
         <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:604px;">
            <div class="POuter_Box_Inventory" style="width:600px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Add Comment</b>  
                            <br />
                            <strong>Purchase Order No :</strong>&nbsp;&nbsp; <asp:Label ID="lbpono" runat="server" style="font-weight: 700" />
                            <asp:Label ID="lblpoid" style="display:none;" runat="server" />
                            <asp:Label ID="lblitemid" style="display:none;" runat="server" />
                            <asp:Label ID="lblcotype" style="display:none;" runat="server" />
                            <br />
                            <asp:Label ID="lblitemnametitle" runat="server" Visible="false" Font-Bold="true" Text="Item Name :">
                                
                            </asp:Label>&nbsp;&nbsp;
                             <asp:Label ID="lblitemname" runat="server" Visible="false" Font-Bold="true" >
                                
                            </asp:Label>
                        </td>
                    </tr>
                    </table>
                </div>


              </div>


         <div class="POuter_Box_Inventory" style="width:600px;">
            <div class="content">
                <strong>Comment : </strong><asp:TextBox ID="txtcomment" runat="server" Width="480px" MaxLength="200" />
                <center>
                    <br />
                    <input type="button" class="savebutton" value="Save" onclick="savemycomment()" />
                    <br />
                    <br />
                </center>
                </div>
             </div>
    
    </div>
    </form>

    <script type="text/javascript">
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
        function savemycomment() {

            if ($('#<%=txtcomment.ClientID%>').val() == "") {
                showerrormsg("Please Enter Comment");
                $('#<%=txtcomment.ClientID%>').focus();
                return;
            }

            $.blockUI();

            $.ajax({
                url: "VendorComment.aspx/SaveComment",
                data: '{POID:"' + $('#<%=lblpoid.ClientID%>').text() + '",PONO:"' + $('#<%=lbpono.ClientID%>').text() + '",ItemID:"' + $('#<%=lblitemid.ClientID%>').text() + '",Type:"' + $('#<%=lblcotype.ClientID%>').text() + '",comment:"' + $('#<%=txtcomment.ClientID%>').val() + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        showmsg("Comment Saved.!");
                        return;
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });
        }
    </script>
</body>
</html>
