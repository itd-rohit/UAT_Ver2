<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TopPhlebotomist.aspx.cs" Inherits="Design_HomeCollection_TopPhlebotomist" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Top Performing Phelbotomist</strong>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4" style="border: 1px solid black; height: 500px">
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Top</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <asp:DropDownList ID="ddltop" runat="server">
                                <asp:ListItem Value="5">5</asp:ListItem>
                                <asp:ListItem Value="10">10</asp:ListItem>
                                <asp:ListItem Value="15">15</asp:ListItem>
                                <asp:ListItem Value="20">20</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                   
                    <div class="row">
                        <div class="col-md-14">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Year</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <asp:DropDownList ID="ddlyear" runat="server"></asp:DropDownList>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Month</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <asp:DropDownList ID="ddlmonth" runat="server"></asp:DropDownList>

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
                            <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select chosen-container" onchange="getcity()" runat="server" ClientIDMode="Static"></asp:DropDownList>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>City</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlcity" onchange="getroute()" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static"></asp:DropDownList>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Route</b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlroute" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <div class="col-md-4" style="text-align: center">
                            <input type="button" value="Get Report" class="searchbutton" onclick="searchdata()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-20" style="border: 1px solid black; background-color: white;">
                    <div style="width: 100%; overflow: auto; max-height: 500px;" id="mydiv">
                        <table id="tblItems" frame="box" rules="all" style="float: left; width: 99%;">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id=<%=ddlzone.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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
            getzone();
        });
        function getzone() {
            jQuery('#<%=ddlzone.ClientID%> option').remove();
            jQuery('#<%=ddlzone.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');

            serverCall('TopPhlebotomist.aspx/bindzone',
                {},
                function (result) {

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
            jQuery('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlzone.ClientID%>').val() != "") {
                serverCall('TopPhlebotomist.aspx/bindstate',
                    { zoneid: (jQuery('#<%=ddlzone.ClientID%>').val()).toString() },
                    function (result) {

                        var cityData = jQuery.parseJSON(result);
                        jQuery("#<%=ddlstate.ClientID%>").append(jQuery("<option></option>").val("0").html("Select State"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery("#<%=ddlstate.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].state));
                        }

                        $('#<%=ddlstate.ClientID%>').trigger('chosen:updated');

                    })
            }
        }

        function getcity() {


            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlstate.ClientID%>').val() != "" && jQuery('#<%=ddlstate.ClientID%>').val() != "0") {
                serverCall('TopPhlebotomist.aspx/bindcity',
                    { stateid: jQuery('#<%=ddlstate.ClientID%>').val() },
                    function (result) {

                        var cityData = jQuery.parseJSON(result);
                        jQuery("#<%=ddlcity.ClientID%>").append(jQuery("<option></option>").val("0").html("Select City"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery("#<%=ddlcity.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].city));
                        }

                        $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                    })

            }
        }

        function getroute() {



            jQuery('#<%=ddlroute.ClientID%> option').remove();
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlcity.ClientID%>').val() != "" && jQuery('#<%=ddlcity.ClientID%>').val() != "0") {
                serverCall('TopPhlebotomist.aspx/bindroute',
                    { cityid: jQuery('#<%=ddlcity.ClientID%>').val() },
                    function (result) {

                        var cityData = jQuery.parseJSON(result);
                        jQuery("#<%=ddlroute.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Route"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery("#<%=ddlroute.ClientID%>").append(jQuery("<option></option>").val(cityData[i].Routeid).html(cityData[i].Route));
                        }

                        $('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
                    })

            }
        }
    </script>

    <script type="text/javascript">

        function searchdata() {

            var myear = $("#<%=ddlyear.ClientID%>").val();
           var mmonth = $("#<%=ddlmonth.ClientID%>").val();
           var stateid = $("#<%=ddlstate.ClientID%>").val();
           var cityid = $("#<%=ddlcity.ClientID%>").val();
           var routeid = $("#<%=ddlroute.ClientID%>").val();
           var top = $("#<%=ddltop.ClientID%>").val();
           $('#tblItems tr').remove();
           serverCall('TopPhlebotomist.aspx/GetReport',
               { myear: myear, mmonth: mmonth, stateid: stateid, cityid: cityid, routeid: routeid, top: top },
               function (result) {
                   ItemData = $.parseJSON(result);

                   if (ItemData.length == 0) {
                       toast("Error", "No Data Found");
                       $('#tblItems tr').remove();

                   }
                   else {
                       var mydata = new Array();
                       for (var i = 0; i < ItemData.length ; i++) {
                           mydata.push("<tr  id='"); mydata.push(ItemData[i].PhlebotomistID); mydata.push("'>");

                           mydata.push('<td style="width:20%;" valign="top">');

                           if (ItemData[i].ProfilePics != '') {
                               mydata.push(' <img style="margin-right: 10px;" class="Circles" src="'); mydata.push(ItemData[i].ProfilePics); mydata.push('" />');
                           }
                           else {
                               mydata.push(' <img style="margin-right: 10px;" class="Circles" src="../../App_Images/NoProfilePic.jpg" />');
                           }
                           mydata.push('</td>');

                           mydata.push('<td style="width:40%;padding:5px;font-weight:bold;" valign="top">');
                           mydata.push('Name :- '); mydata.push(ItemData[i].Phelboname); mydata.push("<br/>");
                           mydata.push('DOB :- '); mydata.push(ItemData[i].Age); mydata.push("<br/>");
                           mydata.push('Mobile :- '); mydata.push(ItemData[i].Mobile); mydata.push("<br/>");
                           mydata.push('State :- '); mydata.push(ItemData[i].state); mydata.push("<br/>");
                           mydata.push('City :- '); mydata.push(ItemData[i].city); mydata.push("<br/>");
                           mydata.push('Route :- '); mydata.push(ItemData[i].RouteName);
                           mydata.push('</td>');
                           mydata.push('<td style="width:40%;padding:5px;font-weight:bold;" valign="top">');
                           mydata.push('<table style="width:99%">');
                           mydata.push('<tr>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightblue , white);">'); mydata.push(ItemData[i].AvgRevenue); mydata.push(' </td>');
                           mydata.push('<td>Revenue Statistics </td>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightgreen , white);">'); mydata.push(ItemData[i].Revenue); mydata.push(' </td>');
                           mydata.push('</tr>');
                           mydata.push('<tr>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightblue , white);">'); mydata.push(ItemData[i].AvgCount); mydata.push(' </td>');
                           mydata.push('<td>Collection Count </td>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightgreen , white);"">'); mydata.push(ItemData[i].PatientCount); mydata.push(' </td>');
                           mydata.push('</tr>');
                           mydata.push('<tr>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightblue , white);">'); mydata.push(ItemData[i].AvgRating); mydata.push(' </td>');
                           mydata.push('<td>Customer Rating </td>');
                           mydata.push('<td style="width:30%;background-image: linear-gradient(to right, lightgreen , white);"">'); mydata.push(ItemData[i].Rating); mydata.push(' </td>');
                           mydata.push('</tr>');

                           mydata.push('<tr>');
                           mydata.push('<td style="width:30%">Average </td>');
                           mydata.push('<td></td>');
                           mydata.push('<td style="width:30%">Achieved</td>');
                           mydata.push('</tr>');
                           mydata.push('</table>');
                           mydata.push('</td>');
                           mydata.push("</tr>");
                          
                       }

                       mydata = mydata.join("");
                       $('#tblItems').append(mydata);


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

