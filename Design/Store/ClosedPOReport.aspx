<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ClosedPOReport.aspx.cs" Inherits="Design_Store_ClosedPOReport" %>

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
                            <b>Closed Purchase Order Report</b>  
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
                                            <td class="required" align="right">Close From Date :</td>
                                            <td>
                                                 <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>&nbsp;</td>
                                            <td class="required" align="right">Close To Date :</td>
                                            <td>
                                                <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>&nbsp;&nbsp;&nbsp;&nbsp; <%--PO Type :--%><asp:DropDownList ID="ddltype" runat="server" Width="100" style="display:none;">
                            <asp:ListItem Value=""></asp:ListItem> <asp:ListItem Value="1">Direct PO</asp:ListItem>
                             <asp:ListItem Value="2">PO From PI</asp:ListItem>
                                                                                     </asp:DropDownList>&nbsp;Close Type :
                                                &nbsp;<asp:DropDownList ID="ddltype2" runat="server" Width="100">
                            <asp:ListItem Value=""></asp:ListItem> <asp:ListItem Value="5">Auto Close</asp:ListItem>
                             <asp:ListItem Value="4">Manual Close</asp:ListItem>
                                                                                     </asp:DropDownList></td>

                                        </tr>

                                       
                       <tr style="display:none;">
                                            <td class="required" align="right">Report Type in Excel :</td>
                                            <td>
                                              <asp:DropDownList ID="ddltype1" runat="server">
                                                
                                                   <asp:ListItem Value="2">Detail</asp:ListItem>
                                              </asp:DropDownList>   </td>
                                            <td class="required" align="right">&nbsp;</td>
                                            <td>
                                                &nbsp;</td>

                                        </tr>

                                    </table>
                    
               </div>
              </div>

          

                 <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                  
                   <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport();" id="btnsave" />
                    &nbsp;&nbsp; </div>
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
        function GetReport() {




            $.blockUI();
            $.ajax({
                url: "ClosedPOReport.aspx/GetReport",
                data: '{fromdate:"' + $('#<%=txtfromdate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",type:"' + $('#<%=ddltype.ClientID%>').val() + '",type1:"' + $('#<%=ddltype2.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Item Found");
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
        function GetReportPDF() {




            $.blockUI();
            $.ajax({
                url: "ClosedPOReport.aspx/GetReportPDF",
                data: '{fromdate:"' + $('#<%=txtfromdate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",type:"' + $('#<%=ddltype.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {
                        window.open('Report/commonreportstore.aspx');
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

