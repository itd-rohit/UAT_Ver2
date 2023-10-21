<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GRNInvoiceEdit.aspx.cs" Inherits="Design_Store_GRNInvoiceEdit" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

       <asp:UpdatePanel ID="up" runat="server">
         <ContentTemplate>
     <div id="Pbody_box_inventory" style="width:1304px;">
          <div id="Div1" style="width:1304px;">

         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>GRN Invoice Detail Update</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>


                <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td><strong>&nbsp;&nbsp;&nbsp; GRN No:&nbsp;&nbsp; </strong>
                            <asp:TextBox ID="txtgrnno" Width="195px" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnsearch" runat="server" CssClass="searchbutton" OnClick="btnsearch_Click" Text="Search" />&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                         <td>&nbsp;</td>
                         <td></td>
                    </tr>
                </table>
                </div>
                    </div>


               <div class="POuter_Box_Inventory" style="width:1300px;" id="btndata" runat="server" visible="false">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">
                            Invoice No :&nbsp;
                        </td>

                        <td>

                            <asp:TextBox ID="txtinvoiceno" runat="server" Width="120px"></asp:TextBox>

                        </td>

                         <td style="font-weight: 700">Invoice Date :</td>
                          <td> 
                              <asp:TextBox ID="txtinvoicedate" runat="server" Width="120px"></asp:TextBox>
                              <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy" PopupButtonID="txtinvoicedate" TargetControlID="txtinvoicedate">
                              </cc1:CalendarExtender>
                        </td>
             <td style="font-weight: 700">&nbsp;</td>
                          <td>&nbsp;</td>
              <td style="font-weight: 700">Gate Entry No :&nbsp;</td>
              <td><asp:TextBox ID="txtgateentryno" runat="server" Width="120px"></asp:TextBox></td>

                    </tr>
                 
                    <tr>
                        <td style="font-weight: 700">Challan No :&nbsp;&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtchallanno" runat="server" Width="120px"></asp:TextBox>
                        </td>
                        <td style="font-weight: 700">Challan Date :&nbsp;&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtchallandate" runat="server" Width="120px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Animated="true" Format="dd-MMM-yyyy" PopupButtonID="txtchallandate" TargetControlID="txtchallandate">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="font-weight: 700">  <asp:TextBox ID="txtgrnid" runat="server" Width="120px" style="display:none;"></asp:TextBox></td>
                        <td>&nbsp;</td>
                        <td style="font-weight: 700" colspan="2">
                            <input class="searchbutton" onclick="openmypopup('AddGRNDocument.aspx')" type="button" value="Add Invoice" />
                        </td>
                    </tr>
                 
                    <tr>
                        <td colspan="8" style="font-weight: 700; text-align: center;">

                            <asp:Button ID="btnupdate" runat="server" Text="Update" CssClass="savebutton" OnClick="btnupdate_Click" />
                        </td>
                    </tr>
                 
                </table>
                </div>
                   </div>
              </ContentTemplate>
           </asp:UpdatePanel>



    <script type="text/javascript">

        var filename = "";

        function openmypopupbarcode(href) {




            var width = '1240px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function openmypopup(href) {

           
            href = href + '?GRNNo=' + $('#<%=txtgrnid.ClientID%>').val();
            var width = '1100px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
    </script>
</asp:Content>

