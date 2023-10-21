<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StorePageAccessControl.aspx.cs" Inherits="Design_Store_StorePageAccessControl" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Store Page Access Control </b>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2 ">
                    <label class="pull-left">CentreType  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Zone  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                </div>
                <div class="col-md-2 ">
                    <label class="pull-left">State  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                </div>

                <div class="col-md-2 ">
                    <label class="pull-left">City  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 ">
                    <label class="pull-left">Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                </div>
                <div class="col-md-2 ">
                    <label class="pull-left">Location  </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="Purchaseheader">Month Year Date Detail</div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-5 ">
                            <label class="pull-left">Select Year   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:DropDownList ID="ddlyear" runat="server" Width="120px" onchange="createtable()">
                                <asp:ListItem Value="0">Select Year</asp:ListItem>
                                <asp:ListItem Value="2019">2019</asp:ListItem>
                                <asp:ListItem Value="2020">2020</asp:ListItem>
                                <asp:ListItem Value="2021">2021</asp:ListItem>
                                <asp:ListItem Value="2022">2022</asp:ListItem>
                                <asp:ListItem Value="2023">2023</asp:ListItem>
                                <asp:ListItem Value="2024">2024</asp:ListItem>
                                <asp:ListItem Value="2025">2025</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-12 ">
                            &nbsp;<input type="button" value="Reset" class="resetbutton" onclick="resetme()" />

                            &nbsp;<input type="button" value="Save" class="savebutton" onclick="saveme()" />
                        </div>
                    </div>


                    <div class="col-md-24 " style="margin-top: 10px">
                        <table id="tblitemlist" style="border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">

                                <td class="GridViewHeaderStyle" style="width: 20px;">Sr.No.</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">Year</td>
                                <td class="GridViewHeaderStyle" style="width: 100px;">Month</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">From Date</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">To Date</td>
                            </tr>
                        </table>

                    </div>
                </div>
                <div class="col-md-12 ">
                    <div class="row">
                        <div class="col-md-24 ">
                            <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()" />
                            <input type="button" value="Copy To Next Year" class="savebutton" onclick="copytonextyear()" />
                        </div>

                        <div class="col-md-24 " style="margin-top: 10px">
                            <em><span style="font-size: small"><strong>* Stock Physical Verification Page Access with in seleced date range  
                            <br />
                                *  Block All Stock Transaction Pages(GRN,Direct GRN,Issue,Direct Stock Transfer,Direct Issue)<br />
                            </strong></span></em>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id=ListCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstlocation]').multipleSelect({
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
                    jQuery("#lstCentreType").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: jQuery("#lstCentreType") });
                });
            }

            function bindZone() {
                jQuery('#<%=lstZone.ClientID%> option').remove();
                jQuery('#lstZone').multipleSelect("refresh");
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                    jQuery("#lstZone").bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery("#lstZone") });
                });

            }
            function bindState(BusinessZoneID) {
                jQuery('#<%=lstState.ClientID%> option').remove();
                jQuery('#lstState').multipleSelect("refresh");
                if (BusinessZoneID != "") {
                    serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                        jQuery("#lstState").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery("#lstState") });
                    });
                }
                bindCentrecity();
            }

            function bindCentrecity() {
                var StateID = jQuery('#lstState').val();
                jQuery('#<%=lstCentrecity.ClientID%> option').remove();
                jQuery('#lstCentrecity').multipleSelect("refresh");
                if (StateID != "") {
                    serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID.toString() }, function (response) {
                        jQuery("#lstCentrecity").bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: jQuery("#lstCentrecity") });
                    });

                    bindCentre();
                }
            }

            function bindCentre() {
                var StateID = jQuery('#lstState').val();
                var TypeId = jQuery('#lstCentreType').val();
                var ZoneId = jQuery('#lstZone').val();
                var cityId = jQuery('#lstCentrecity').val();
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                if (TypeId != "") {
                    serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId.toString(), ZoneId: ZoneId.toString(), StateID: StateID.toString(), cityid: cityId.toString() }, function (response) {
                        jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery("#lstCentre") });
                    });
                }
                bindlocation();
            }
        
            function bindlocation() {
                var StateID = jQuery('#lstState').val();
                var TypeId = jQuery('#lstCentreType').val();
                var ZoneId = jQuery('#lstZone').val();
                var cityId = jQuery('#lstCentrecity').val();
                var centreid = jQuery('#lstCentre').val();
                jQuery('#<%=lstlocation.ClientID%> option').remove();
                jQuery('#lstlocation').multipleSelect("refresh");
                serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid: centreid.toString(), StateID: StateID.toString(), TypeId: TypeId.toString(), ZoneId: ZoneId.toString(), cityId: cityId.toString() }, function (response) {
                    jQuery("#lstlocation").bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: jQuery("#lstlocation") });
                });
            }

    </script>


    <script type="text/javascript">
        var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
        ];
        function createtable() {
            var locationid = $('#<%=lstlocation.ClientID%>').val();
                if (locationid == "") {
                    toast("Error", "Please Select Location", "");
                    $('#<%=ddlyear.ClientID%>').val('0');
                    return;
                }
                $('#tblitemlist tr').slice(1).remove();
                if ($('#<%=ddlyear.ClientID%>').val() != "0") {
                    for (var a = 0; a <= 11; a++) {
                        var rowcolor = "pink";
                        var id = parseInt(a + 1) + "_" + $('#<%=ddlyear.ClientID%>').val();
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(rowcolor); $myData.push(";' id='"); $myData.push(id); $myData.push("'>");
                        $myData.push('<td class="GridViewLabItemStyle" id="tdmonth" style="font-weight:bold;">'); $myData.push(parseInt(a + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdyear" style="font-weight:bold;">'); $myData.push($('#<%=ddlyear.ClientID%>').val()); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdmonthname" style="font-weight:bold;">'); $myData.push(monthNames[a]); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"><input type="text" id="from'); $myData.push(id); $myData.push('" class="txtfromdate" style="width:110px" readonly="readonly"/></td>');
                        $myData.push('<td class="GridViewLabItemStyle"><input type="text" id="to'); $myData.push(id); $myData.push('" class="txttodate" style="width:110px" readonly="readonly"/></td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                                "Aug", "Sep", "Oct", "Nov", "Dec"];
                        var minval = "1" + "-" + months[a] + "-" + $('#<%=ddlyear.ClientID%>').val();
                        var maxval = "";
                        if (a == 0 || a == 2 || a == 4 || a == 6 || a == 7 || a == 9 || a == 11) {
                            maxval = "31" + "-" + months[a] + "-" + $('#<%=ddlyear.ClientID%>').val();
                        }
                        else if (a == 3 || a == 5 || a == 8 || a == 10) {
                            maxval = "30" + "-" + months[a] + "-" + $('#<%=ddlyear.ClientID%>').val();
                    }
                    else if (a == 1 && ($('#<%=ddlyear.ClientID%>').val() == "2020" || $('#<%=ddlyear.ClientID%>').val() == "2024")) {
                        maxval = "29" + "-" + months[a] + "-" + $('#<%=ddlyear.ClientID%>').val();
                    }
                    else {
                        maxval = "28" + "-" + months[a] + "-" + $('#<%=ddlyear.ClientID%>').val();
                    }
            $("#from" + id).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: false,
                changeYear: false, minDate: minval, maxDate: maxval
            });
            $("#to" + id).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: false,
                changeYear: false, minDate: minval, maxDate: maxval
            });
        }
        jQuery('#<%=lstCentreType.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstZone.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstState.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstCentrecity.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstCentre.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstlocation.ClientID%>').multipleSelect("disable");
                }
                getsaveddata();
            }


            function getsaveddata() {
                var year = $('#<%=ddlyear.ClientID%>').val();
                var locationid = 0;
                $('#<%=lstlocation.ClientID%> > option:selected').each(function () {
                    locationid = $(this).val();
                    return;
                });
                serverCall('StorePageAccessControl.aspx/getdata', { year: year, locationid: locationid }, function (response) {
                    ItemData = jQuery.parseJSON(response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var txtidfrom = "from" + ItemData[i].entrymonth + "_" + ItemData[i].entryyear;
                        var txtidto = "to" + ItemData[i].entrymonth + "_" + ItemData[i].entryyear;
                        $('#' + txtidfrom).val(ItemData[i].fromdate);
                        $('#' + txtidto).val(ItemData[i].todate);
                        $('#' + txtidto).closest('tr').css('background-color', 'lightgreen')
                    }
                });
            }

            function resetme() {
                $('#<%=ddlyear.ClientID%>').val('0');
                $('#tblitemlist tr').slice(1).remove();
                jQuery('#<%=lstlocation.ClientID%> option').remove();
                jQuery('#<%=lstlocation.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#<%=lstCentre.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                jQuery('#<%=lstState.ClientID%> option').remove();
                jQuery('#<%=lstState.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                jQuery('#<%=lstCentrecity.ClientID%> option').remove();
                jQuery('#<%=lstCentrecity.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                jQuery('#<%=lstCentreType.ClientID%> option').remove();
                jQuery('#<%=lstCentreType.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                bindcentertype();
                jQuery('#<%=lstZone.ClientID%> option').remove();
                jQuery('#<%=lstZone.ClientID%>').multipleSelect("refresh").multipleSelect("enable");
                bindZone();
            }
    </script>

    <script type="text/javascript">
        function getdata() {
            var dataIm = new Array();
            $('#<%=lstlocation.ClientID%> > option:selected').each(function () {
                    var locationid = $(this).val();
                    $('#tblitemlist tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "triteheader") {
                            var ProData = new Object();
                            ProData.LocationID = locationid;
                            ProData.EntryYear = $(this).closest("tr").find('#tdyear').html();
                            ProData.EntryMonth = $(this).closest("tr").find('#tdmonth').html();
                            ProData.EntryMonthName = $(this).closest("tr").find('#tdmonthname').html();
                            ProData.FromDate = $(this).closest("tr").find('.txtfromdate').val();
                            ProData.ToDate = $(this).closest("tr").find('.txttodate').val();
                            dataIm.push(ProData);
                        }
                    });
                });
                return dataIm;
            }
            function saveme() {
                var locationid = $('#<%=lstlocation.ClientID%>').val();
                if (locationid == "") {
                    toast("Error", "Please Select Location", "");
                    return;
                }
                var count = $('#tblitemlist tr').length;
                if (count == 0 || count == 1) {
                    toast("Error", "Please Select Year To Save Data", "");
                    return;
                }
                var sn = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader" && $(this).find('.txtfromdate').val() == "") {
                        sn = 1;
                        $(this).find('.txtfromdate').focus();
                        return;
                    }
                });

                if (sn == 1) {

                    toast("Error", "Please Enter From Date ", "");
                    return;
                }
                var sn1 = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader" && $(this).find('.txttodate').val() == "") {
                        sn1 = 1;
                        $(this).find('.txttodate').focus();
                        return;
                    }
                });
                if (sn1 == 1) {

                    toast("Error", "Please Enter To Date ", "");
                    return;
                }
                var sn11 = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader" && Number($(this).find('.txtfromdate').val().split('-')[0]) > Number($(this).find('.txttodate').val().split('-')[0])) {
                        sn11 = 1;
                        $(this).find('.txtfromdate').focus();
                        return;
                    }
                });

                if (sn11 == 1) {

                    toast("Error", "From Date should be less then to date", "");
                    return;
                }
                var datatosave = getdata();
                if (datatosave.length == 0) {
                    toast("Error", "Please Select Year", "");
                    return;
                }
                serverCall('StorePageAccessControl.aspx/savedata', { datatosave: datatosave }, function (response) {
                    if (response == "1") {
                        toast("Success", "Data Saved Successfully", "");
                        resetme();
                    }
                    else {
                        toast("Error", response, "");

                    }
                });
            }

    </script>
    <script type="text/javascript">
        function exporttoexcel() {

            var locationid = $('#<%=lstlocation.ClientID%>').val();
                if (locationid == "") {
                    toast("Error", "Please Select Location", "");
                    return;
                }

                var count = $('#tblitemlist tr').length;
                if (count == 0 || count == 1) {
                    toast("Error", "Please Select Year", "");
                    return;
                }
                var year = $('#<%=ddlyear.ClientID%>').val();


                serverCall('StorePageAccessControl.aspx/getdataexcel', { locationid: locationid, year: year }, function (response) {
                    var save = response;
                    if (save == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {

                        toast("Error", save, "");
                    }
                });
            }
    </script>


    <script type="text/javascript">
        function copytonextyear() {

            openmypopup("StorePageAccessControlcopy.aspx");
        }


        function openmypopup(href) {




            var width = '1240px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }


    </script>
</asp:Content>



