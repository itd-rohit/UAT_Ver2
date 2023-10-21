<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OutSourceSampleReport.aspx.cs" Inherits="Design_Lab_OutSourceSampleReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />


    <%: Scripts.Render("~/bundles/Chosen") %>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>OutSource Sample Report</b>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                 <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">

                    <asp:TextBox ID="txtFromDate" runat="server" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                 <div class="col-md-5">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
             <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">OutSource Lab   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:ListBox ID="lstOutSourceLab" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                     </div>
                <div class="col-md-2"></div>
                 <div class="col-md-3">
                    <label class="pull-left"><asp:CheckBox ID="chkCentre" runat="server" onClick="BindCentre();" Text="Centre" Style="font-weight: 700" /></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:DropDownList ID="ddlCentre" runat="server" class="ddlCentre  chosen-select chosen-container"></asp:DropDownList>

                     </div>

                  </div>
            
        </div>

    <div class="POuter_Box_Inventory" style="text-align: center;">
        <input type="button" class="searchbutton" value="Report" onclick="getReport();" />
    </div>

    </div>
    <script type="text/javascript">
        function getReport() {
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            var CentreID = '';
            if (($('#<%=chkCentre.ClientID%>').prop('checked') == true)) {
                CentreID = $('#<%=ddlCentre.ClientID%>').val();
            }
            else {
                CentreID = 'All';
            }
            var OutSourceLabID = '';
            var SelectedLaength = $('#lstOutSourceLab').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                OutSourceLabID += $('#lstOutSourceLab').multipleSelect("getSelects").join().split(',')[i] + ',';
            }
            if (OutSourceLabID == ',') {
                toast("Error", 'Please Select Out Source Lab');
                return;
            }
            if (CentreID == '') {
                toast("Error", 'Please Select Centre');
                return;
            }
            serverCall('OutSourceSampleReport.aspx/getReport', { dtFrom: dtFrom, dtTo: dtTo, CentreID: CentreID, OutSourceLabID: OutSourceLabID }, function (result) {
                if (result == "1") {
                    window.open('../common/ExportToExcel.aspx');
                }
                else if (result == "0") {
                    toast("Info", 'Record Not Found');
                }
                else if (result == "-2") {
                    toast("Error", 'Date Difference Not More Than 31 Days');
                }
                else if (result == "-1") {
                    toast("Error", 'Error');
                }
            });

        }
        $(function () {
            $('[id*=lstOutSourceLab]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindOutSourceLab();
        });
        function bindOutSourceLab() {
            serverCall('OutSourceSampleReport.aspx/bindOutSourceLab', {}, function (response) {
                jQuery('#lstOutSourceLab').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: $("#lstOutSourceLab"), isClearControl: '' });
            });           
        }        
        function BindCentre() {

            if (($('#<%=chkCentre.ClientID%>').prop('checked') == true)) {
                serverCall('OutSourceSampleReport.aspx/BindCentre', {}, function (response) {
                    $("#<%=ddlCentre.ClientID %>").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
                });               
            }
            else {
                $("#<%=ddlCentre.ClientID %> option").remove();
                $("#<%=ddlCentre.ClientID %>").trigger('chosen:updated');
                
            }
        };
        
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
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
        });
    </script>
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .ms-parent .multiselect {
            width: 195px;
        }
    </style>
</asp:Content>

