<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StateWiseRevenueReport.aspx.cs" Inherits="Design_HomeCollection_StateWiseRevenueReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyBVtUztjJy215wJb3VbmUWHoCfGR7anRgE"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>


    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>State Wise Revenue Report</strong>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row" >
                <div class="col-md-4" style="border: 1px solid black;height: 500px">
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>From Date</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <asp:TextBox ID="txtfromdate" runat="server" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>To Date</b></label>
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
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Zone</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:ListBox ID="ddlzone" CssClass="multiselect" onchange="getstate()" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>State</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:ListBox ID="ddlstate" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">


                        <input type="button" value="Get Report" class="searchbutton" onclick="searchdata()" />

                        <input type="button" value="Export To Excel" class="searchbutton" onclick="    exporttoexcel()" />
                    </div>


                </div>

                <div class="col-md-8" style="border: 1px solid black; background-color: white;">
                    <div style="width: 100%; overflow: auto; max-height: 700px;" id="mydiv">
                        <table id="tblItems" frame="box" rules="all" style="float: left; width: 50%;">
                        </table>
                    </div>
                </div>
                <div class="col-md-12" style="border: 1px solid black; background-color: white;">
                    <div id="dvMap" style="width: 100%; height: 500px">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">


        $(document).ready(function () {


            $('[id=<%=ddlzone.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=<%=ddlstate.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            getzone();
            showmap();
        });

        function getzone() {
            jQuery('#<%=ddlzone.ClientID%> option').remove();
            jQuery('#<%=ddlzone.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').multipleSelect("refresh");
            serverCall('StateWiseRevenueReport.aspx/bindzone', {},function (result) {
                    var cityData = jQuery.parseJSON(result);
                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#<%=ddlzone.ClientID%>").append(jQuery("<option></option>").val(cityData[i].businesszoneid).html(cityData[i].businesszonename));
                             }

                             jQuery('[id=<%=ddlzone.ClientID%>]').multipleSelect({
                                 includeSelectAllOption: true,
                                 filter: true, keepOpen: false
                             });
                         })


                 }
                 function getstate() {
                     jQuery('#<%=ddlstate.ClientID%> option').remove();
                     jQuery('#<%=ddlstate.ClientID%>').multipleSelect("refresh");

                     if (jQuery('#<%=ddlzone.ClientID%>').val() != "") {
                         serverCall('StateWiseRevenueReport.aspx/bindstate',{ zoneid: (jQuery('#<%=ddlzone.ClientID%>').val()).toString() },function (result) {

                                 var cityData = jQuery.parseJSON(result);
                                 for (i = 0; i < cityData.length; i++) {
                                     jQuery("#<%=ddlstate.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].state));
                                 }

                                 jQuery('[id=<%=ddlstate.ClientID%>]').multipleSelect({
                                     includeSelectAllOption: true,
                                     filter: true, keepOpen: false
                                 });
                             })

                     }
                 }

                 function showmap() {

                     var map = new google.maps.Map(document.getElementById('dvMap'), {
                         center: { lat: 20.59, lng: 78.96 },
                         zoom: 5,
                         mapTypeControl: false,
                         streetViewControl: false,

                         fullscreenControl: false,
                         mapTypeId: google.maps.MapTypeId.ROADMAP
                     });

                 }



                 function searchdata() {

                     var fromdate = $("#<%=txtfromdate.ClientID%>").val();
                     var todate = $("#<%=txttodate.ClientID%>").val();
                     var stateid = $("#<%=ddlstate.ClientID%>").val();


                     $('#tblItems tr').remove();
                     serverCall('StateWiseRevenueReport.aspx/GetReport',
                         { fromdate: (fromdate).toString(), todate: (todate).toString(), stateid: (stateid).toString() },
                         function (result) {
                             ItemData = result;

                             if (ItemData == "false") {
                                 toast("Error", "No Data Found");
                                 $('#tblItems tr').remove();
                             }
                             else {

                                 var data = $.parseJSON(result);
                                 var rtype = 'State Wise Revenue Summary';
                                 var colspan = 1;
                                 if (data.length > 0) {

                                     var mydata = [];
                                     var totalpatient = 0;
                                     var totalrevenue = 0;

                                     var mydatahead = [];
                                     var SlotData = $.parseJSON(result);
                                     mydatahead.push('<tr id="header">');

                                     var col = [];
                                     mydata.push('<tr id="header1">');
                                     for (var i = 0; i < SlotData.length; i++) {
                                         for (var key in SlotData[i]) {
                                             if (col.indexOf(key) == -1) {
                                                 if (key != 'Y' && key != 'SLA' && key != 'SLO') {
                                                     mydata.push('<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); mydata.push(key); mydata.push('</th>');
                                                     col.push(key);
                                                 }
                                             }
                                         }
                                     }
                                     mydata.push('</tr>');
                                     mydatahead.push('<th colspan="'); mydatahead.push(col.length); mydatahead.push('" style="text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); mydatahead.push(rtype); mydatahead.push('</th>');
                                     mydatahead.push('</tr>');
                                     var patientcount = 0;
                                     var netamount = 0;
                                     for (var i = 0; i < SlotData.length; i++) {
                                         mydata.push('<tr>');
                                         for (var j = 0; j < col.length; j++) {
                                             if (col[j] == "AveragePerPatient") {
                                                 var avg = netamount / patientcount;
                                                 mydata.push('<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">'); mydata.push(parseInt(avg)); mydata.push('</td>');
                                             }
                                             else {
                                                 mydata.push('<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">'); mydata.push(SlotData[i][col[j]]); mydata.push('</td>');
                                                 if (col[j] == "PatientCount") {
                                                     patientcount = Number(SlotData[i][col[j]]);
                                                     totalpatient = totalpatient + Number(SlotData[i][col[j]]);
                                                 }
                                                 if (col[j] == "Revenue") {
                                                     netamount = Number(SlotData[i][col[j]]);
                                                     totalrevenue = totalrevenue + Number(SlotData[i][col[j]]);
                                                 }
                                             }

                                         }

                                         mydata.push('</tr>');
                                     }
                                     var totalavg = totalrevenue / totalpatient;
                                     var footerdata = [];
                                     footerdata.push('<tr id="footer"><th colspan="'); footerdata.push(colspan); footerdata.push('" style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">Total</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(totalpatient); footerdata.push('</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(totalrevenue); footerdata.push('</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(parseInt(totalavg)); footerdata.push('</th></tr>');
                                     mydatahead = mydatahead.join("");
                                     mydata = mydata.join("");
                                     footerdata = footerdata.join("");

                                     $('#tblItems').append(mydatahead);
                                     $('#tblItems').append(mydata);
                                     $('#tblItems').append(footerdata);
                                     var markers = data;
                                    var mapOptions = {
                                         center: { lat: 20.59, lng: 78.96 },
                                         zoom: 5,
                                         mapTypeControl: false,
                                         streetViewControl: false,


                                         fullscreenControl: false,
                                         mapTypeId: google.maps.MapTypeId.ROADMAP
                                     };


                                     var map = new google.maps.Map(document.getElementById("dvMap"), mapOptions);

                                     for (i = 0; i < markers.length; i++) {



                                         var data = markers[i]
                                         var myLatlng = new google.maps.LatLng(data.SLA, data.SLO);
                                         var marker = new google.maps.Marker({
                                             position: myLatlng,
                                             map: map,
                                             label: data.Revenue,
                                             title: data.State + "\nPatient Count:- " + data.PatientCount + "\nRevenue:- " + data.Revenue,
                                             animation: google.maps.Animation.DROP
                                         });

                                         var infowindow = new google.maps.InfoWindow({
                                             content: "" + data.Revenue

                                         });
                                         infowindow.open(map, marker);

                                     }
                                 }
                             }
                         })

                 }

                 function exporttoexcel() {
                     var count = $('#tblItems tr').length;
                     if (count == 0 || count == 1) {
                         toast("Error", "Please Search Data To Export");
                         return;
                     }


                     var ua = window.navigator.userAgent;
                     var msie = ua.indexOf("MSIE ");


                     sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=mydiv]').html()));
                 }
    </script>

</asp:Content>

