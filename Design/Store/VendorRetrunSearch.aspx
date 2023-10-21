<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorRetrunSearch.aspx.cs" Inherits="Design_Store_VendorRetrunSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Supplier Return Search </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Supplier   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="lstsupplier" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtdatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
<div class="col-md-2"></div>
                <div class="col-md-2">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtdateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtdateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                    &nbsp;&nbsp;
                       <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
               <div class="col-md-24" style="text-align: center">
                <div style="width: 100%; max-height: 330px; overflow: auto;">
                    <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                            <td class="GridViewHeaderStyle">ReturnInvoiceNo</td>
                            <td class="GridViewHeaderStyle">ReturnDate</td>
                            <td class="GridViewHeaderStyle">SupplierName</td>
                            <td class="GridViewHeaderStyle">LocationName</td>
                            <td class="GridViewHeaderStyle">ItemName</td>
                            <td class="GridViewHeaderStyle">BatchNumber</td>
                            <td class="GridViewHeaderStyle">ExpiryDate</td>
                            <td class="GridViewHeaderStyle">ReturnQty</td>
                            <td class="GridViewHeaderStyle">Unit</td>
                            <td class="GridViewHeaderStyle">Rate</td>
                            <td class="GridViewHeaderStyle">DiscAmt</td>
                            <td class="GridViewHeaderStyle">TaxAmt</td>
                            <td class="GridViewHeaderStyle">UnitPrice</td>
                            <td class="GridViewHeaderStyle">Print</td>
                        </tr>
                    </table>
              </div>
        </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstsupplier]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        function searchdata() {
            var ddlcocation = $('#<%=lstlocation.ClientID%>').val().toString();
            var sullpier= $('#<%=lstsupplier.ClientID%>').val().toString();
            if (ddlcocation.length == 0)
                ddlcocation = "";
            if(sullpier.length==0)
                sullpier="";
            $('#tblitemlist tr').slice(1).remove()
            serverCall('VendorRetrunSearch.aspx/SearchData', { locationid: ddlcocation, supplierid: sullpier, fromdate: $('#<%=txtdatefrom.ClientID%>').val(), todate: $('#<%=txtdateto.ClientID%>').val() }, function (response) {
                rowcolor = "";
                if (response == "-1") {
                    openmapdialog();
                    return;
                }
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No Item Found", "");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var rowcolor = "lightgreen";
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].StockID); $myData.push("'>");
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="VendorReturnNo"  >'); $myData.push(ItemData[i].VendorReturnNo); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].EntryDateTime); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].Suppliername); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].location); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].ItemName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].BatchNumber); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].ExpiryDate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].ReturnQty); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].MinorUnit); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].Rate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].DiscountAmount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].taxamount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].UnitPrice); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" /></td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                    }
                }

            });
        }
        function printme(ctrl) {
            window.open('VendorReturnReceipt.aspx?salesno=' + $(ctrl).closest('tr').find("#VendorReturnNo").html());

        }
        function exporttoexcel() {
            var ddlcocation = $('#<%=lstlocation.ClientID%>').val();
            var sullpier = $('#<%=lstsupplier.ClientID%>').val()
            if (ddlcocation.length == 0)
                ddlcocation = "";
            if (sullpier.length == 0)
                sullpier = "";
            serverCall('VendorRetrunSearch.aspx/ExcelReport', { locationid: ddlcocation, supplierid: sullpier, fromdate: $('#<%=txtdatefrom.ClientID%>').val(), todate: $('#<%=txtdateto.ClientID%>').val() }, function (response) {
                if (response == "false") {
                    toast("Error", "No Item Found", "");

                }
                else {
                    window.open('../Common/exporttoexcel.aspx');

                }

            });
        }

    </script>
</asp:Content>

