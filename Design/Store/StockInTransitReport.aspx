<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StockInTransitReport.aspx.cs" Inherits="Design_Store_StockInTransitReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">

         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Stock In-Transit Report</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader"></div>
                 <table width="99%">
                           
                     
                     <tr>
                         <td class="required" width="200px">
                             Report Type:
                         </td>
                         <td colspan="3">

                             <asp:RadioButtonList ID="rdoIndentType" runat="server"  onchange="setIndentType();" RepeatDirection="Horizontal" style="font-weight: 700">
                              <asp:ListItem Text="Summary" Value="1" Selected="True"></asp:ListItem>
                              <asp:ListItem Text="Detail" Value="2"></asp:ListItem>
                             </asp:RadioButtonList>
                         </td>
                     </tr>            
                                       
                     
                     <tr>
                         <td class="required">

                             <span id="mysi">From Date:</span>

                       </td>
                         <td>

                                            <asp:TextBox ID="txtfromdate" runat="server" ReadOnly="true" Width="100"></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender><asp:TextBox ID="txtfromtime" runat="server" Width="100"></asp:TextBox>


                         </td>
                         <td class="required">

                             <span class="sp1" style="display:none;">To Date :</span> </td>
                         <td>

                                             <span class="sp1" style="display:none;">         <asp:TextBox ID="txttodate" runat="server" ReadOnly="true" Width="100"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender><asp:TextBox ID="txtfromtime0" runat="server" Width="100"></asp:TextBox></span>
                         </td>
                     </tr>            
                                       
                       

                                       
                                    </table>
                    
               </div>
              </div>

          

                 <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                  
                   <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport();" id="btnsave" />
                   
               </div>
                     </div>

         </div>

    

    

    

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



        function setIndentType() {

            if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "1") {
                $('.sp1').hide();
                $('#mysi').html('As On Date:');
                $('#<%=txtfromtime.ClientID%>').val('23:59:59');

            }
            else {
                $('.sp1').show();
                $('#mysi').html('From Date :');
                $('#<%=txtfromtime.ClientID%>').val('00:00:00');
            }
        }
        function GetReport() {


            var reporttype = $("#<%=rdoIndentType.ClientID%>").find(":checked").val();

            $.blockUI();
            $.ajax({
                url: "StockInTransitReport.aspx/GetReport",
                data: '{fromdate:"' + $('#<%=txtfromdate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",reporttype:"' + reporttype + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Data Found");
                        $.unblockUI();

                    }
                    else {
                        window.open('../common/ExportToExcel.aspx');
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }


    </script>
</asp:Content>

