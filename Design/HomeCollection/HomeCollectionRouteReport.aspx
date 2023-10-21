<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionRouteReport.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionRouteReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />


    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>




    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <strong>Home Collection Route/City Wise Slot Summary</strong>
           
        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-5" style="border: 1px solid black;">

                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Report Type </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:RadioButtonList ID="rd" runat="server" onchange="setreporttype();" RepeatDirection="Vertical" Style="font-weight: 700">
                                <asp:ListItem Value="1" Selected="True">Route Wise Slot Summary</asp:ListItem>
                                <asp:ListItem Value="2">City Wise Slot Summary</asp:ListItem>

                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>From Date </b></label>
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

                    <div class="row">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Zone </b></label>
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
                            <label class="pull-left"><b>State </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:ListBox ID="ddlstate" CssClass="multiselect" onchange="getcity()" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>
                    </div>

                    <div class="row lbcity">
                        <div class="col-md-14">
                            <label class="pull-left"><b>City </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row lbcity">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlcity" onchange="getroute()" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row lbroute">
                        <div class="col-md-14">
                            <label class="pull-left"><b>Route </b></label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                    <div class="row lbroute">
                        <div class="col-md-24">
                            <asp:DropDownList ID="ddlroute" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <input type="button" value="Get Report" class="searchbutton" onclick="searchdata()" />&nbsp;&nbsp;<input type="button" value="Export To Excel" class="searchbutton" onclick="    exporttoexcel()" />
                    </div>

                </div>

                <div class="col-md-19" style="border: 1px solid black; background-color: white; vertical-align: top">
                    <div style="width: 99%; overflow: auto; max-height: 470px;" id="mydiv">

                        <table id="tblItems" frame="box" rules="all">
                        </table>
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


                      setreporttype();
                  });


                  function setreporttype() {
                      if ($("#<%=rd.ClientID%>").find(":checked").val() == "2") {
                          $('.lbroute').hide();
                          getzone();
                          $('#tblItems tr').remove();

                      }
                      else {
                          $('.lbroute').show();
                          getzone();
                          $('#tblItems tr').remove();


                      }
                  }


                  function getzone() {
                      jQuery('#<%=ddlzone.ClientID%> option').remove();
            jQuery('#<%=ddlzone.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            serverCall('HomeCollectionRouteReport.aspx/bindzone', {}, function (result) {
                var cityData = jQuery.parseJSON(result);
                for (i = 0; i < cityData.length; i++) {
                    jQuery("#<%=ddlzone.ClientID%>").append(jQuery("<option></option>").val(cityData[i].businesszoneid).html(cityData[i].businesszonename));
                }

                jQuery('[id=<%=ddlzone.ClientID%>]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }


        function getstate() {
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlzone.ClientID%>').val() != "") {
                serverCall('HomeCollectionRouteReport.aspx/bindstate', { zoneid: jQuery('#<%=ddlzone.ClientID%>').val().toString() }, function (result) {
                    var cityData = jQuery.parseJSON(result);
                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#<%=ddlstate.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].state));
                    }

                    jQuery('[id=<%=ddlstate.ClientID%>]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
            }
        }

        function getcity() {


            jQuery('#<%=ddlcity.ClientID%> option').remove();
         jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
         jQuery('#<%=ddlroute.ClientID%> option').remove();
         jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
         if (jQuery('#<%=ddlstate.ClientID%>').val() != "") {
             serverCall('HomeCollectionRouteReport.aspx/bindcity', { stateid: jQuery('#<%=ddlstate.ClientID%>').val().toString() }, function (result) {
                 var cityData = jQuery.parseJSON(result);
                 jQuery("#<%=ddlcity.ClientID%>").append(jQuery("<option></option>").val("0").html("Select City"));
                 for (i = 0; i < cityData.length; i++) {
                     jQuery("#<%=ddlcity.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].city));
                  }

                 $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
             });

         }
     }

     function getroute() {



         jQuery('#<%=ddlroute.ClientID%> option').remove();
         $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
         if (jQuery('#<%=ddlcity.ClientID%>').val() != "" && $("#<%=rd.ClientID%>").find(":checked").val() == "1") {
             serverCall('HomeCollectionRouteReport.aspx/bindroute', { cityid: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
                 var cityData = jQuery.parseJSON(result);
                 jQuery("#<%=ddlroute.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Route"));
                 for (i = 0; i < cityData.length; i++) {
                     jQuery("#<%=ddlroute.ClientID%>").append(jQuery("<option></option>").val(cityData[i].Routeid).html(cityData[i].Route));
                  }

                 $('#<%=ddlroute.ClientID%>').trigger('chosen:updated');

             });

         }
     }
    </script>

    <script type="text/javascript">

        function searchdata() {
            var reporttype = $("#<%=rd.ClientID%>").find(":checked").val();
             var fromdate = $("#<%=txtfromdate.ClientID%>").val();
             var todate = $("#<%=txttodate.ClientID%>").val();
             var cityid = $("#<%=ddlcity.ClientID%>").val();
             var cityname = $("#<%=ddlcity.ClientID%> option:selected").text();
             var routeid = $("#<%=ddlroute.ClientID%>").val();
             var routename = $("#<%=ddlroute.ClientID%> option:selected").text();
             if (reporttype == "1") {
                 if (routeid == "null" || routeid == "0" || routeid == null || routeid == "") {
                     toast("Error","Please Select Route");
                     return;
                 }
             }
             if (reporttype == "2") {
                 if (cityid == "null" || routeid == "0" || cityid == null || cityid == "") {
                     toast("Error", "Please Select City");
                     return;
                 }
             }
             $('#tblItems tr').remove();
             serverCall('Homecollectionroutereport.aspx/GetReport', { reporttype: reporttype, fromdate: fromdate, todate: todate, cityid: cityid, cityname: cityname, routeid: routeid, routename: routename }, function (result) {
                 ItemData = result;

                 if (ItemData == "false") {
                     toast('Info', "No Data Found");
                     $('#tblItems tr').remove();


                 }
                 else {
                     var rtype = '';
                     var colspan = 0;
                     if ($("#<%=rd.ClientID%>").find(":checked").val() == "1") {
                         rtype = 'Route Wise Slot Summary';
                         colspan = 1;
                     }
                     else if ($("#<%=rd.ClientID%>").find(":checked").val() == "2") {
                         rtype = 'City Wise Slot Summary';
                         colspan = 2;
                     }

                     var data = $.parseJSON(result);
                     if (data.length > 0) {
                         var mydata = "";
                         var minimumvalue = 0;
                         var maximumvalue = 0;
                         var maximumvaluetext = '';
                         var minimumvaluetext = '';
                         var total = 0;
                         var vacantslot = 0;
                         var mydatahead = [];
                         var SlotData = $.parseJSON(result);
                         mydatahead.push('<tr id="header">');

                         var col = [];
                         mydata += '<tr id="header1">';
                         for (var i = 0; i < SlotData.length; i++) {
                             for (var key in SlotData[i]) {
                                 if (col.indexOf(key) === -1) {
                                     if (key == "Timeslot") {
                                         mydata += '<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">' + key + '</th>';
                                     }
                                     else {
                                         mydata += '<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">' + key.split('_')[1] + '</th>';
                                     }
                                     col.push(key);
                                 }
                             }
                         }
                         mydata += '</tr>';
                         mydatahead.push('<th colspan="' + col.length + '" style="text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); mydatahead.push(rtype);mydatahead.push('</th>');
                         mydatahead.push('</tr>');
                         var patientcount = 0;
                         var netamount = 0;
                         var isset = 0;
                         for (var i = 0; i < SlotData.length - 1; i++) {
                             mydata += '<tr>';
                             for (var j = 0; j < col.length; j++) {
                                 if (Number(SlotData[i][col[j]]) == 0) {
                                     mydata += '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;"></td>';
                                 }
                                 else {
                                     if (col[j] != "Timeslot") {
                                         mydata += '<td style="background-color: #95ffc5;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">' + SlotData[i][col[j]] + '</td>';
                                     }
                                     else {
                                         mydata += '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">' + SlotData[i][col[j]] + '</td>';
                                     }
                                 }

                                 if (col[j] != "Timeslot") {
                                     total = total + Number(SlotData[i][col[j]]);

                                     if (Number(SlotData[i][col[j]]) == 0) {
                                         vacantslot = vacantslot + 1;
                                     }
                                     else {


                                         if (Number(SlotData[i][col[j]]) > maximumvalue) {
                                             maximumvalue = Number(SlotData[i][col[j]]);
                                             maximumvaluetext = 'Slot : ' + SlotData[i][col[0]] + '     Phlebotomist : ' + col[j].split('_')[1];
                                         }

                                         if (Number(SlotData[i][col[j]]) < minimumvalue) {
                                             isset = 1;
                                             minimumvalue = Number(SlotData[i][col[j]]);
                                             minimumvaluetext = 'Slot : ' + SlotData[i][col[0]] + '     Phlebotomist : ' + col[j].split('_')[1];
                                         }
                                         if (isset == 0) {
                                             minimumvalue = Number(SlotData[i][col[j]]);
                                             minimumvaluetext = 'Slot : ' + SlotData[i][col[0]] + '     Phlebotomist : ' + col[j].split('_')[1];
                                         }
                                     }
                                 }
                             }

                             mydata += '</tr>';
                         }
                         for (var i = SlotData.length - 1; i < SlotData.length; i++) {
                             mydata += '<tr>';
                             for (var j = 0; j < col.length; j++) {

                                 mydata += '<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">' + SlotData[i][col[j]] + '</td>';

                             }
                             mydata += '</tr>';
                         }
                         var footerdata = [];

                         footerdata.push('<tr><th colspan=' + col.length + ' style="text-align: left;font-size:12px;background-color: bisque;color: black;padding: 2px;border:1px solid gray;">');
                         var cc = col.length - 1; var ss = SlotData.length - 1;
                         var totalslot = parseInt(ss) * parseInt(cc);
                         var occupiedslot = totalslot - vacantslot;

                         footerdata.push('<table>');
                         footerdata.push('<tr><td style="width:250px;">Total No of Phlebotomist</td><td style="width:150px;">:  '); footerdata.push(cc); footerdata.push('</td><td></td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Total No of Slot</td><td style="width:150px;">:  '); footerdata.push(totalslot); footerdata.push('</td><td></td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Total No of Vacant Slot</td><td style="width:150px;">:  '); footerdata.push(vacantslot); footerdata.push('</td><td></td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Total No of Occupied Slot</td><td style="width:150px;">:  '); footerdata.push(occupiedslot); footerdata.push('</td><td></td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Total Collection</td><td style="width:150px;">:  '); footerdata.push(total); footerdata.push('</td><td></td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Minimum value booked Slot</td><td style="width:150px;">:  '); footerdata.push(minimumvalue); footerdata.push('</td><td>'); footerdata.push(minimumvaluetext); footerdata.push('</td></tr>');
                         footerdata.push('<tr><td style="width:250px;">Maximum value booked Slot</td><td style="width:150px;">:  '); footerdata.push(maximumvalue); footerdata.push('</td><td>'); footerdata.push(maximumvaluetext); footerdata.push('</td></tr>');
                         footerdata.push('</table>');

                         footerdata.push('</th>');
                         footerdata.push('</tr>');

                         $('#tblItems').append(mydatahead.join(""));
                         $('#tblItems').append(mydata);
                         $('#tblItems').append(footerdata.join(""));



                     }
                 }

             });

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

