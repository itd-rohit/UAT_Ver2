<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PurchaseOrderReport.aspx.cs" Inherits="Design_Store_PurchaseOrderReport" %>

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

        <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Purchase Order Report</b>
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError" />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" >
            <div id="divSearch">
                <div class="Purchaseheader">
                  Location Details
                </div>
                <div class="row">
                    <div class="col-md-24">
                           <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">From Date:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:TextBox ID="txtfromdate" CssClass="requiredField" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                            </div>
                                <div class="col-md-3 ">
                                <label class="pull-left ">To Date:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                               <asp:TextBox ID="txttodate" CssClass="requiredField" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                            </div>
                               </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">PO Type:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                               <asp:DropDownList ID="ddltype" runat="server">
                            <asp:ListItem Value=""></asp:ListItem> <asp:ListItem Value="1">Direct PO</asp:ListItem>
                             <asp:ListItem Value="0">PO From PI</asp:ListItem>
                             </asp:DropDownList>
                            </div>
                                <div class="col-md-3 ">
                                <label class="pull-left ">Report Type in Excel:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                               <asp:DropDownList ID="ddltype1" CssClass="requiredField" runat="server">
                                                  <asp:ListItem Value="1">Summary</asp:ListItem>
                                                   <asp:ListItem Value="2">Detail</asp:ListItem>
                                              </asp:DropDownList> 
                            </div>
                               </div>
                        </div>
                    </div>
                </div>
            </div>
               <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="div6">
                <div class="row">
                    <div class="col-md-24 ">
                   <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport();" id="btnsave" />
                    &nbsp;&nbsp; <input type="button" value="Get Report PDF" class="searchbutton" onclick="GetReportPDF();" id="btnsave0" /></div>
                    </div>
                </div>
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
        function GetReport() {

            $modelBlockUI();

            serverCall('PurchaseOrderReport.aspx/GetReport', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), type: $('#<%=ddltype.ClientID%>').val(), type1: $('#<%=ddltype1.ClientID%>').val() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.FromDate = JSON.parse(response).FromDate;
                    $objData.ToDate = JSON.parse(response).ToDate;
                    $objData.Type1 = JSON.parse(response).Type1;
                    $objData.Type = JSON.parse(response).Type;
                    $objData.ReportType = JSON.parse(response).ReportType;
                    $objData.ReportPath = JSON.parse(response).ReportPath;
                    $objData.ReportDisplayName = JSON.parse(response).ReportDisplayName;
                    $objData.IsAutoIncrement = JSON.parse(response).IsAutoIncrement;
                    PostFormData($objData, $objData.ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });

        }
        function GetReportPDF() {

            $modelBlockUI();

            serverCall('PurchaseOrderReport.aspx/GetReportPDF', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), type: $('#<%=ddltype.ClientID%>').val(), type1: $('#<%=ddltype1.ClientID%>').val() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.FromDate = JSON.parse(response).FromDate;
                    $objData.ToDate = JSON.parse(response).ToDate;
                    $objData.Type1 = JSON.parse(response).Type1;
                    $objData.Type = JSON.parse(response).Type;
                    $objData.ReportPath = JSON.parse(response).ReportPath;

                    PostFormData($objData, $objData.ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });
        }

    </script>
</asp:Content>

