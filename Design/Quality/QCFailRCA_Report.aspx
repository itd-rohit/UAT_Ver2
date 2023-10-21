<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCFailRCA_Report.aspx.cs" Inherits="Design_Quality_QCFailRCA_Report" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <b>QC Fail RCA Report</b>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">Centre   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="ddlprocessinglab" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="300" onchange="bindcontrol(); bindMachine();"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Control/Lot Number </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlcontrol" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="200"></asp:ListBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Machine</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="ddlMachine" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="250"></asp:ListBox>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" value="Report" class="searchbutton" onclick="exporttoexcel()" />
            </div>
        </div>
    </div>
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
                jQuery(selector).chosen(config[selector]);
            }
            $('[id=<%=ddlprocessinglab.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=<%=ddlcontrol.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=<%=ddlMachine.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


        });
        function bindcontrol() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            jQuery('#<%=ddlcontrol.ClientID%> option').remove();
            jQuery('#<%=ddlcontrol.ClientID%>').multipleSelect("refresh");
            if (labid != "0" && labid != null && labid != "") {
                serverCall('QCFailRCA_Report.aspx/bindcontrol', { labid: labid.toString() }, function (response) {
                    jQuery("#<%=ddlcontrol.ClientID%>").bindMultipleSelect({ data: JSON.parse(response), valueField: 'controlid', textField: 'controlname', controlID: jQuery('#<%=ddlcontrol.ClientID%>') });

                });
                }
            }
            function bindMachine() {
                var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                jQuery('#<%=ddlMachine.ClientID%> option').remove();
                jQuery('#<%=ddlMachine.ClientID%>').multipleSelect("refresh");
                if (labid != "0" && labid != null && labid != "") {
                    serverCall('QCFailRCA_Report.aspx/bindMachine', { labid: labid.toString() }, function (response) {
                        var CentreMachineListData = $.parseJSON(result.d);
                        if (CentreMachineListData.length == 0) {
                            showerrormsg("No Control Found");
                        }
                        else
                            jQuery("#<%=ddlMachine.ClientID%>").bindMultipleSelect({ data: JSON.parse(response), valueField: 'MacID', textField: 'machinename', controlID: jQuery('#<%=ddlMachine.ClientID%>') });
                    });
                }
            }
    </script>
    <script type="text/javascript">      
        function exporttoexcel() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var MachineId = $('#<%=ddlMachine.ClientID%>').val();

            if (labid == "0" || labid == null || labid == "") {
                toast("Error", "Please Select Centre");
                return;
            }
            if (controlid == "0" || controlid == null || controlid == "") {
                toast("Error", "Please Select Control");
                return;
            }
            if (MachineId == "0" || MachineId == null || MachineId == "") {
                toast("Error", "Please Select Machine");
                return;
            }

            serverCall('QCFailRCA_Report.aspx/showreadingexcel', { labid: labid.toString(), controlid: controlid.toString(), MachineId: MachineId.toString() }, function (response) {
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



