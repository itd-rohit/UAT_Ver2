<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILC_EQAS_ConfiguredParametersReport.aspx.cs" Inherits="Design_Quality_ILC_EQAS_ConfiguredParametersReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%:Scripts.Render("~/bundles/JQueryStore") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <b>ILC & EQAS Parameter Mapping Report</b>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Report Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddltype" runat="server" class="ddltype chosen-select chosen-container" Width="300px">
                        <asp:ListItem Value="1">ILC</asp:ListItem>
                        <asp:ListItem Value="2">EQAS </asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Processing Lab </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">

                    <asp:ListBox ID="ddlprocessinglab" CssClass="multiselect" SelectionMode="Multiple" Width="365px" runat="server"></asp:ListBox>
                </div>
            </div>
            <div class="row" style="text-align: center;">

                <input type="button" value="Get Report" class="searchbutton" onclick="summaryreport()" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $('#<%=ddlprocessinglab.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });

        function bindcentre() {
            var TypeId = '';
            jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
            if (TypeId == "0") {
                return;
            }
            serverCall('ILC_EQAS_ConfiguredParametersReport.aspx/bindCentre', { TypeId: TypeId }, function (response) {
                jQuery("#<%=ddlprocessinglab.ClientID%>").bindMultipleSelect({ data: JSON.parse(response), valueField: 'centreid', textField: 'centre', controlID: jQuery('#<%=ddlprocessinglab.ClientID%>') });

            });
            }
    </script>
    <script type="text/javascript">
        function summaryreport() {
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (processingcentre == '') {
                toast("Error", "Please Select Centre..!", "");
                return false;
            }
            serverCall('ILC_EQAS_ConfiguredParametersReport.aspx/Getsummaryreport', { processingcentre: processingcentre.toString(), ReportType: $('#<%=ddltype.ClientID%>').val() }, function (response) {
                ItemData = response;
                if (ItemData == null) {
                    toast("Error", "No Item Found", "");
                }
                else {
                    PostFormData(response, response.ReportPath); 
                }
            });
        }
    </script>
</asp:Content>




