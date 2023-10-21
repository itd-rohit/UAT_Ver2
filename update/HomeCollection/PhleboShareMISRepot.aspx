<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhleboShareMISRepot.aspx.cs" Inherits="Design_HomeCollection_PhleboShareMISRepot" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/Chosen") %>

     <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>  

    <%: Scripts.Render("~/bundles/Chosen") %>




    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Phlebo Collection Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Type</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlreporttype" runat="server" onchange="setreportfilter()">
                        <asp:ListItem Value="1" Text="Summary" />
                        <asp:ListItem Value="2" Text="Month Wise" />
                        <asp:ListItem Value="3" Text="Day Wise" />
                        <asp:ListItem Value="4" Text="Detail" />
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row" id="tr1">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>From Date</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>From Date</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row" id="tr2" style="display: none;">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Year</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlyear" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>From Month</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlfrommonth" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>To Month</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddltomonth" runat="server"></asp:DropDownList>
                </div>
            </div>

            <div class="row" id="tr3" style="display: none;">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Year</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlyeardaywise" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Month</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlmonthdaywise" runat="server"></asp:DropDownList>
                </div>
            </div>


            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Zone</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlzone" class="ddlzone chosen-select" onchange="bindState()" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>State</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select" onchange="bindCity()" runat="server"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left"><b>City</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlcity" class="ddlcity chosen-select" onchange="bindPhelbo()" runat="server"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Phelbotomist</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="ddlPhelbotomist" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" class="searchbutton" value="Get Report" onclick="getreport()" />
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

            jQuery('[id*=ddlPhelbotomist]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        function setreportfilter() {
            if ($('#<%=ddlreporttype.ClientID%>').val() == "1" || $('#<%=ddlreporttype.ClientID%>').val() == "4") {
                $('#tr1').show();
                $('#tr2,#tr3').hide();
            }
            else if ($('#<%=ddlreporttype.ClientID%>').val() == "2") {
                $('#tr1').hide();
                $('#tr2').show();
                $('#tr3').hide();
            }
            else if ($('#<%=ddlreporttype.ClientID%>').val() == "3") {
                $('#tr1').hide();
                $('#tr2').hide();
                $('#tr3').show();
            }
        }
        function bindState() {
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');
            if (jQuery('#<%=ddlzone.ClientID%>').val() == '0') {
                return;
            }
            serverCall('StateWiseRevenueReport.aspx/bindstate', { zoneid: jQuery('#<%=ddlzone.ClientID%>').val() }, function (result) {
                stateData = jQuery.parseJSON(result);
                if (stateData.length == 0) {
                    jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val("0").html("No State Found"));
                }
                else {
                    jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val("0").html("Select State"));
                    for (i = 0; i < stateData.length; i++) {
                        jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val(stateData[i].id).html(stateData[i].state));
                    }
                }
                $('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
            });
        }
    function bindCity() {
        jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');

            if (jQuery('#<%=ddlstate.ClientID%>').val() == '0') {
                return;
            }
            serverCall('PhleboShareMISRepot.aspx/bindcity', { stateid: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
                cityData = jQuery.parseJSON(result);
                if (cityData.length == 0) {
                    jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                }
                else {
                    jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select City"));
                    for (i = 0; i < cityData.length; i++) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].city));
                        }
                    }
                $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            });
        }
        function bindPhelbo() {
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');
            if (jQuery('#<%=ddlcity.ClientID%>').val() == '0') {
                return;
            }
            serverCall('PhleboShareMISRepot.aspx/bindPhelbo', { cityid: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
                phelboData = jQuery.parseJSON(result);
                if (phelboData.length == 0) {

                }
                else {

                    for (i = 0; i < phelboData.length; i++) {
                        jQuery('#<%=ddlPhelbotomist.ClientID%>').append(jQuery("<option></option>").val(phelboData[i].PhlebotomistID).html(phelboData[i].Name));
                    }
                }
                $('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');
            });
        }
    </script>

    <script type="text/javascript">
        function getreport() {
            serverCall('PhleboShareMISRepot.aspx/getreport', { reporttype: $('#<%=ddlreporttype.ClientID%>').val(), fromdate: $('#<%=txtFromDate.ClientID%>').val(), todate: $('#<%=txtToDate.ClientID%>').val(), year: $('#<%=ddlyear.ClientID%>').val(), frommonth: $('#<%=ddlfrommonth.ClientID%>').val(), tomonth: $('#<%=ddltomonth.ClientID%>').val(), daywiseyear: $('#<%=ddlyeardaywise.ClientID%>').val(), daywisemonth: $('#<%=ddlmonthdaywise.ClientID%>').val(), phlebotomist: $('#<%=ddlPhelbotomist.ClientID%>').val().toString() }, function (result) {
                ItemData = result;
                if (ItemData == "false") {
                    //info("Info", "No Item Found");
                    alert("No Item Found");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });
        }
    </script>


</asp:Content>

