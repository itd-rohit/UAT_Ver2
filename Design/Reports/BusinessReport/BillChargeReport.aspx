<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BillChargeReport.aspx.cs" Inherits="Design_Lab_BillChargeReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/PostReportScript") %>
   
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Bill Charge Report</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="width: 20%; text-align: right; font-weight: bold">From Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 20%">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender runat="server" ID="calFromDate"
                            TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />


                    </td>

                    <td style="width: 20%; text-align: right; font-weight: bold">To Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 40%">
                        <asp:TextBox ID="txtToDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />

                    </td>
                </tr>

                <tr>
                    <td style="width: 20%; text-align: right; font-weight: bold">Client :&nbsp;</td>
                    <td style="text-align: left; width: 20%">
                        <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="360px"></asp:ListBox>

                    <td style="width: 20%">&nbsp;</td>
                    <td style="text-align: left; width: 40%">&nbsp;</td>

                </tr>
                <tr>
                    <td colspan="4" style="text-align: center; width: 100%">

                       
                        &nbsp;


                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style=text-align:center">

             <input type="button" class="searchbutton" value="Export To Excel" onclick="exportReport()" />
             </div>
    
    <script type="text/javascript">

        jQuery(function () {
            jQuery('#divMasterNav').hide();
        });
        function bindPanel() {
            PageMethods.bindPanel(onSuccessPanel, OnfailurePanel);
        }

        function onSuccessPanel(result) {
            var PanelData = jQuery.parseJSON(result);

            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (PanelData != null) {
                for (i = 0; i < PanelData.length; i++) {
                    jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(PanelData[i].Panel_Id).html(PanelData[i].Company_Name));
                }
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false

                });

            }


        }
        function OnfailurePanel() {

        }
        jQuery(function () {

            jQuery('[id*=lstPanel]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindPanel();
        });
        function exportReport() {
            jQuery('#lblMsg').text('');
            if (jQuery('#lstPanel').multipleSelect("getSelects").join() == "") {

                jQuery('#lblMsg').text('Please Select Client Name');
                return;
            }
            else
                PageMethods.exportReport($("#txtFromDate").val(), $("#txtToDate").val(), jQuery('#lstPanel').multipleSelect("getSelects").join(), onsucessReport, onFailureReport);
        }
        function onsucessReport(result) {
        var resultData = jQuery.parseJSON(result); 
            if (resultData == "0") {
                jQuery('#lblMsg').text('No Record Found');
            }
            else  {
                 PostReportAutoIncrement(resultData.Query, resultData.ReportName, resultData.Period, resultData.ReportPath);
              //  window.open('../common/ExportToExcel.aspx');
            }
        }
        function onFailureReport(result) {

        }
    </script>
</asp:Content>

