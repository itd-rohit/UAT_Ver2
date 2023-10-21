<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelbomistProductivity.aspx.cs" Inherits="Design_HomeCollection_PhelbomistProductivity" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .Circles {
            height: 150px;
            width: 170px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            float: left;
        }
    </style>

    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>




    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Phelbomist Productivity</strong>
        </div>


        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-4" style="border: 1px solid black;">

                    <div class="row">
                        <div class="col-md-16">
                            <label class="pull-left"><b>Zone </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlzone" class="ddlzone chosen-select" onchange="bindState()" runat="server"></asp:DropDownList>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-16">
                            <label class="pull-left"><b>State </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select" onchange="bindCity()" runat="server"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-16">
                            <label class="pull-left"><b>City </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlcity" class="ddlcity chosen-select" onchange="bindPhelbo()" runat="server"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-16">
                            <label class="pull-left"><b>Phelbotomist </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <asp:ListBox ID="ddlPhelbotomist" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-16">
                            <label class="pull-left"><b>From Date </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-16">
                            <asp:TextBox ID="txtfromdate" runat="server" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>To Date </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-14">
                            <asp:TextBox ID="txttodate" runat="server" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <input type="button" value="Search" class="searchbutton" onclick="Searchme()" />
                    </div>
                </div>
                <div class="col-md-20" style="border: 1px solid black; background-color: white; vertical-align: top">
                    <div style="width: 99%; max-height: 480px; overflow: auto; background-color: white;">
                        <div style="width: 38%; float: left;" id="divPhelobo">
                        </div>
                        <div id="allChart" style="width: 38%; float: left;"></div>
                        <div id="allChart_second" style="width: 20%; float: left;"></div>
                    </div>
                </div>
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
            serverCall('PhelbomistProductivity.aspx/bindstate', { zoneid: jQuery('#<%=ddlzone.ClientID%>').val() }, function (result) {
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
            serverCall('PhelbomistProductivity.aspx/bindcity', { stateid: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
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
            serverCall('PhelbomistProductivity.aspx/bindPhelbo', { cityid: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
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
        function Searchme() {
            serverCall('PhelbomistProductivity.aspx/GetALlData', { Phelbotomist: jQuery('#<%=ddlPhelbotomist.ClientID%>').val().toString(), fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val() }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast('Info',"No Data Found..");

                    return;
                }
                DrawChartStatus(ItemData);

            });          
        }
        google.charts.load('current', { 'packages': ['corechart'] });

        function DrawChartStatus(Status) {
            var ReportName = '';
            var data = Status;
            $('#divPhelobo').html('');
            $('#allChart').html('');
            $('#allChart_second').html('');
            for (var i = 0; i < Status.length; i++) {
                var phelboData = [];
                phelboData.push('<div style="margin-left: 5px; margin-top: 20px; width:98%; float:left;"> ');
                if (Status[i].ProfilePics != '') {
                    phelboData.push(' <img style="margin-right: 10px;" class="Circles" src="'); phelboData.push(Status[i].ProfilePics); phelboData.push('" />');
                }
                else {
                    phelboData.push(' <img style="margin-right: 10px;" class="Circles" src="../../App_Images/NoProfilePic.jpg" />');
                }
                phelboData.push(' <table style="font-size: 13px; font-variant: small-caps; font-weight: bold;"> ');
                phelboData.push(' <tr> <td>Name-'); phelboData.push(Status[i].Name); phelboData.push('</td></tr> ');
                if (Status[i].Age != '') {
                    var AgeYear = Status[i].Age.split('-')[2];
                    var d = new Date();
                    var n = d.getFullYear();
                    var DiffAge = n - AgeYear;
                    phelboData.push(' <tr> <td>Age-'); phelboData.push(DiffAge); phelboData.push(' Yrs</td></tr> ');
                }
                else {
                    phelboData.push(' <tr> <td>Age-</td></tr> ');
                }
                phelboData.push(' <tr> <td>DOB-'); phelboData.push(Status[i].Age); phelboData.push('</td></tr> ');
                phelboData.push(' <tr> <td>State-'); phelboData.push(Status[i].state); phelboData.push('</td></tr> ');
                phelboData.push(' <tr> <td>City-'); phelboData.push(Status[i].city); phelboData.push('</td></tr> ');
                phelboData.push(' <tr> <td><b style="color:red;" >Average<span style="font-size:20px;">&#9733;</span>Rating'); phelboData.push(Status[i].Rating); phelboData.push('</b></td></tr> ');
                phelboData.push('  </table> </div>');
              //  phelboData = $mydata.join("");
                $('#divPhelobo').append(phelboData);
                var id = 'chartdiv' + i + '';
                var str = '<div style="height:170px;" id=' + id + ' ></div>';
                $('#allChart').append(str);

                var data = google.visualization.arrayToDataTable([
          ['', '', { role: 'style' }, { role: 'annotation' }],
          ['Rescheduled:' + Status[i].Rescheduled + '', Status[i].Rescheduled, 'blue', Status[i].Rescheduled],
          ['Canceled:' + Status[i].Canceled + '', Status[i].Canceled, '	#800000', Status[i].Canceled],
          ['Completed:' + Status[i].Completed + '', Status[i].Completed, 'green', Status[i].Completed]

                ]);

                var options = {
                    title: 'Phelbomist Call Status',
                    legend: { position: 'none' }
                };
                var chart = new google.visualization.ColumnChart(document.getElementById(id));
                chart.draw(data, options);
                var id_second = 'chartdiv_second' + i + '';
                var str_second = '<div style="height:170px;" id=' + id_second + ' ></div>';
                $('#allChart_second').append(str_second);

                var data_second = google.visualization.arrayToDataTable([
          ['', '', { role: 'style' }, { role: 'annotation' }],
          ['InTime:' + Status[i].InTime + '', Status[i].InTime, 'blue', Status[i].InTime],
          ['Devited:' + Status[i].Devited + '', Status[i].Devited, '	#800000', Status[i].Devited]
                ]);
                var options_second = {
                    title: 'Phelbomist Closed Status',
                    legend: { position: 'none' }
                };
                var chart_second = new google.visualization.ColumnChart(document.getElementById(id_second));
                chart_second.draw(data_second, options_second);
            }
        }
    </script>
</asp:Content>



