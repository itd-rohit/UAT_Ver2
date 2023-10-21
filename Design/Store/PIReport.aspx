<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PIReport.aspx.cs" Inherits="Design_Store_PIReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Indent&nbsp;Report</b>
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError" />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="divSearch">
                <div class="Purchaseheader">
                    Indent From Location Details
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">CentreType:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Location:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                                </div>
                            </div>
                            <div class="row" style="display: none">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">State:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Zone:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                                </div>
                            </div>
                            <div class="row" style="display: none">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Centre:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">City:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="div1">
                <div class="Purchaseheader">
                    Date
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">From Date:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-3 ">
                                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">To Date:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-3 ">
                                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                        Animated="true" runat="server">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Indent Type :   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-2 ">
                                    <asp:DropDownList ID="ddltype" runat="server">
                                        <asp:ListItem Value="SI">SI</asp:ListItem>
                                        <asp:ListItem Value="PI">PI</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3 ">
                                    <asp:CheckBox ID="ch" runat="server" Font-Bold="true" Text="Pending SI" />
                                </div>
                                <div class="col-md-2 ">
                                    <label class="pull-left ">Indent No :   </label>
                                </div>
                                <div class="col-md-2 ">
                                    <asp:TextBox ID="txtindentno" runat="server" />
                                </div>
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
                        <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport('Excel');" id="btnsave" />
                        &nbsp;&nbsp;
                        <input type="button" value="Get Report PDF" class="searchbutton" onclick="GetReport('PDF');" id="btnsave0" />
                    </div>
                </div>
            </div>
        </div>
    </div>




    <script type="text/javascript">
        $(function () {
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=ListCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=ddlsubcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            }); $('[id*=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentrecity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            bindcentertype();
            bindZone();

        });
    </script>

    <script type="text/javascript">
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                var $ddlCtype = $('#<%=lstCentreType.ClientID%>');
                 $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });
             });
             }

             function bindZone() {
                 jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                var $ddlZone = $('#<%=lstZone.ClientID%>');
                $ddlZone.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
            });
            }

            function bindState(BusinessZoneID) {
                jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                    var $ddlState = $('#<%=lstState.ClientID%>');
                    $ddlState.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });
                }
                bindCentrecity();
            }

            function bindCentrecity() {
                var StateID = jQuery('#lstState').val();
                jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID.toString() }, function (response) {
                var $ddlCity = $('#<%=lstCentrecity.ClientID%>');
                $ddlCity.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
            });

            bindCentre();
            }

            function bindCentre() {
                var StateID = jQuery('#lstState').val().toString();
                var TypeId = jQuery('#lstCentreType').val().toString();
                var ZoneId = jQuery('#lstZone').val().toString();
                var cityId = jQuery('#lstCentrecity').val().toString();
                jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {
                    var $ddlCentre = $('#<%=lstCentre.ClientID%>');
                    $ddlCentre.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), isClearControl: '' });
                });
                }
                bindlocation();
            }


            function bindlocation() {
                var StateID = jQuery('#lstState').val().toString();
                var TypeId = jQuery('#lstCentreType').val().toString();
                var ZoneId = jQuery('#lstZone').val().toString();
                var cityId = jQuery('#lstCentrecity').val().toString();

                var centreid = jQuery('#lstCentre').val().toString();
                jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindindentlocation', { centreid: centreid, StateID: StateID, TypeId: TypeId, ZoneId: ZoneId, cityId: cityId }, function (response) {
                var $ddllocation = $('#<%=lstlocation.ClientID%>');
                $ddllocation.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });

            });
            }



    </script>



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
        function GetReport(reportType) {


            var isch = $("#<%=ch.ClientID%>").is(':checked') ? 1 : 0;
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();
            $modelBlockUI();

            serverCall('PIReport.aspx/GetReport', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), type: $('#<%=ddltype.ClientID%>').val(), ch: isch, locationid: locationid, indentno: $('#<%=txtindentno.ClientID%>').val(), reportType: reportType }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.FromDate = JSON.parse(response).FromDate;
                    $objData.ToDate = JSON.parse(response).ToDate;
                    $objData.Type = JSON.parse(response).Type;
                    $objData.Ch = JSON.parse(response).Ch;
                    $objData.LocationID = JSON.parse(response).LocationID;
					$objData.IndentNo = JSON.parse(response).IndentNo;

                    $objData.ReportType = JSON.parse(response).ReportType;
                    $objData.ReportDisplayName = JSON.parse(response).ReportDisplayName;
                    $objData.IsAutoIncrement = JSON.parse(response).IsAutoIncrement;



                    PostFormData($objData, JSON.parse(response).ReportPath);
                }
                else {
                    toast("Error", "Error", "");
                }
            });

        }
        function GetReportPDF() {
            var isch = $("#<%=ch.ClientID%>").is(':checked') ? 1 : 0;
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();
            $modelBlockUI();

            serverCall('PIReport.aspx/GetReportPDF', { fromdate: $('#<%=txtfromdate.ClientID%>').val().toString(), todate: $('#<%=txttodate.ClientID%>').val().toString(), type: $('#<%=ddltype.ClientID%>').val().toString(), ch: isch, locationid: locationid }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {

                    var $objData = new Object();
                    $objData.FromDate = JSON.parse(response).FromDate;
                    $objData.ToDate = JSON.parse(response).ToDate;
                    $objData.Type = JSON.parse(response).Type;
                    $objData.Ch = JSON.parse(response).Ch;
                    $objData.LocationID = JSON.parse(response).LocationID;
                    $objData.ReportPath = JSON.parse(response).ReportPath;
                    PostFormData($objData);
                }
                else {
                    toast("Error", "Error", "");
                }
            });
        }

    </script>
</asp:Content>

