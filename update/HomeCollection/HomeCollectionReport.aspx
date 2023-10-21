<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionReport.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>

    
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/Chosen") %>

     <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>  
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">          
                <strong>Home Collection Revenue Report</strong> 
                </div>              
         <div class="POuter_Box_Inventory" >            
              <div class="row">
                <div class="col-md-5" style="border:1px solid black;">                  
                         <div class="row">
                <div class="col-md-14">
                    <label class="pull-left"><b>Report Type </b></label>
                    <b class="pull-right">:</b>
                </div>
                             </div>
                 <div class="row">
                <div class="col-md-24">
                    <asp:RadioButtonList ID="rd" runat="server" onchange="setreporttype();" RepeatDirection="Vertical" style="font-weight: 700"> 
                                <asp:ListItem value="1" Selected="True">State Wise Revenue</asp:ListItem>
                                <asp:ListItem value="2">City Wise Revenue</asp:ListItem>
                                <asp:ListItem value="3">Day Wise Revenue</asp:ListItem>
                                <asp:ListItem value="4">Month Wise Revenue</asp:ListItem>
                            </asp:RadioButtonList>
                    </div>                
                        </div>
                    <div class="row">
                <div class="col-md-14">
                     <label class="pull-left"><b> From Date </b></label>
                    <b class="pull-right">:</b>
                   </div>
                        </div>
                     <div class="row">
                <div class="col-md-14">
                    <asp:TextBox ID="txtfromdate" runat="server"  ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </div>
                        </div>
                     <div class="row">
                <div class="col-md-14">
                     <label class="pull-left"><b> To Date </b></label>
                    <b class="pull-right">:</b>
                   </div>
                        </div>
                     <div class="row">
                          <div class="col-md-14"> 
                         <asp:TextBox ID="txttodate" runat="server"  ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                         </div>
                    </div>
                  <div class="row">
                <div class="col-md-14">
                     <label class="pull-left"><b> Zone </b></label>
                    <b class="pull-right">:</b>
                   </div>
                        </div>
              <div class="row">
                          <div class="col-md-24"> 
                              <asp:ListBox ID="ddlzone" CssClass="multiselect" onchange="getstate()" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" ></asp:ListBox>
                              </div>
                   </div>
                     <div class="row">
                <div class="col-md-14">
                     <label class="pull-left"><b> State </b></label>
                    <b class="pull-right">:</b>
                   </div>
                        </div>
              <div class="row">
                          <div class="col-md-24"> 
                              <asp:ListBox ID="ddlstate" CssClass="multiselect" onchange="getcity()" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" ></asp:ListBox>
                              </div>
                  </div>
                    <div class="row lbcity">
                <div class="col-md-14">
                     <label class="pull-left"><b> City </b></label>
                    <b class="pull-right">:</b>
                   </div>
                        </div>
              <div class="row lbcity">
                          <div class="col-md-24"> 
                              <asp:ListBox ID="ddlcity" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" ></asp:ListBox>
                              </div>
                  </div>
                     <div class="row">
                          <input type="button" value="Get Report" class="searchbutton"  onclick="searchdata()" />&nbsp;&nbsp;<input type="button"  value="Export To Excel" class="searchbutton" onclick="    exporttoexcel()" />
                     </div>
                     </div>
                  <div class="col-md-19"  style="border:1px solid black; background-color:white;vertical-align:top"> 
                       <div style="width:100%;overflow:auto;max-height:700px;" id="mydiv">
                                   

            <table id="tblItems"   frame="box"  rules="all" style="float:left;width:50%;" >

                </table>
                                     <div style="width:50%;height:100%; overflow:auto;float:left;" id="chart_div"> </div>
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
            $('[id=<%=ddlstate.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=<%=ddlcity.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
           
            setreporttype();
        });


        function setreporttype() {
            if ($("#<%=rd.ClientID%>").find(":checked").val() == "1") {
                $('.lbcity').hide();
                getzone();
                $('#tblItems tr').remove();
            }
            else {
                $('.lbcity').show();
                getzone();
                $('#tblItems tr').remove();
               
            }
            $('#chart_div').html('');
        }


        function getzone() {
            jQuery('#<%=ddlzone.ClientID%> option').remove();
            jQuery('#<%=ddlzone.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlstate.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').multipleSelect("refresh");
            serverCall('HomeCollectionReport.aspx/bindzone', {  }, function (result) {
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
            jQuery('#<%=ddlcity.ClientID%>').multipleSelect("refresh");
            if (jQuery('#<%=ddlzone.ClientID%>').val() != "") {
                serverCall('HomeCollectionReport.aspx/bindstate', { zoneid: jQuery('#<%=ddlzone.ClientID%>').val().toString() }, function (result) {
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
            jQuery('#<%=ddlcity.ClientID%>').multipleSelect("refresh");
            if (jQuery('#<%=ddlstate.ClientID%>').val() != "" && $("#<%=rd.ClientID%>").find(":checked").val() != "1")  {
                serverCall('HomeCollectionReport.aspx/bindcity', { stateid: jQuery('#<%=ddlstate.ClientID%>').val().toString() }, function (result) {
                    var cityData = jQuery.parseJSON(result);
                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#<%=ddlcity.ClientID%>").append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].city));
                        }

                    jQuery('[id=<%=ddlcity.ClientID%>]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
                
            }
        }
    </script>

    <script type="text/javascript">

        function searchdata() {
            var reporttype = $("#<%=rd.ClientID%>").find(":checked").val();
            var fromdate = $("#<%=txtfromdate.ClientID%>").val();
            var todate = $("#<%=txttodate.ClientID%>").val();
            var stateid = $("#<%=ddlstate.ClientID%>").val().toString();
            var cityid = $("#<%=ddlcity.ClientID%>").val().toString();
            $('#chart_div').html('');
            $('#tblItems tr').remove();
            serverCall('Homecollectionreport.aspx/GetReport', { reporttype: reporttype, fromdate: fromdate, todate: todate, stateid: stateid, cityid: cityid }, function (result) {
                ItemData = result;
                if (ItemData == "false") {
                    toast('Info', "No Data Found");
                    $('#tblItems tr').remove();
                }
                else {
                    var rtype = '';
                    var colspan = 0;

                    if ($("#<%=rd.ClientID%>").find(":checked").val() == "1") {
                            rtype = 'State Wise Revenue Summary';
                            colspan = 1;

                        }
                        else if ($("#<%=rd.ClientID%>").find(":checked").val() == "2") {
                            rtype = 'City Wise Revenue Summary';
                            colspan = 2;

                        }
                        else if ($("#<%=rd.ClientID%>").find(":checked").val() == "3") {
                            rtype = 'Day Wise Revenue Summary';
                            colspan = 3;

                        }
                        else if ($("#<%=rd.ClientID%>").find(":checked").val() == "4") {
                            rtype = 'Month Wise Revenue Summary';
                            colspan = 3;

                        }
                var data = $.parseJSON(result);
                if (data.length > 0) {
                    DrawChartStatus(data, rtype, reporttype);
                    var mydata = "";
                    var totalpatient = 0;
                    var totalrevenue = 0;
                    var mydatahead = "";
                    var $mydata = [];
                    var SlotData = $.parseJSON(result);
                    $mydata.push('<tr id="header">');
                    var col = [];
                    mydata += '<tr id="header1">';
                    for (var i = 0; i < SlotData.length; i++) {
                        for (var key in SlotData[i]) {
                            if (col.indexOf(key) == -1) {
                                if (key != 'Y') {
                                    mydata += '<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">' + key + '</th>';
                                    col.push(key);
                                }
                            }
                        }
                    }
                    mydata += '</tr>';
                    $mydata.push('<th colspan="'); $mydata.push(col.length); $mydata.push('" style="text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">' + rtype + '</th>');
                    $mydata.push('</tr>');
                    var patientcount = 0;
                    var netamount = 0;
                    for (var i = 0; i < SlotData.length; i++) {
                        mydata += '<tr>';
                        for (var j = 0; j < col.length; j++) {
                            if (col[j] == "AveragePerPatient") {
                                var avg = netamount / patientcount;
                                mydata += '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">' + parseInt(avg) + '</td>';
                            }
                            else {
                                mydata += '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">' + SlotData[i][col[j]] + '</td>';
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

                        mydata += '</tr>';
                    }
                    var totalavg = totalrevenue / totalpatient;
                    var footerdata=[]
                    footerdata.push('<tr id="footer"><th colspan="'); footerdata.push(colspan); footerdata.push('" style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">Total</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(totalpatient); footerdata.push('</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(totalrevenue); footerdata.push('</th><th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); footerdata.push(parseInt(totalavg)); footerdata.push('</th></tr>');
                    $mydata = $mydata.join("");
                    $('#tblItems').append($mydata);
                    $('#tblItems').append(mydata);
                    $('#tblItems').append(footerdata.join(""));



                }
            }
            });        
        }
        function exporttoexcel() {
            var count = $('#tblItems tr').length;
            if (count == 0 || count == 1) {
                toast('Error', "Please Search Data To Export");
                return;
            }         
            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");
            sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=mydiv]').html()));
        }
        google.charts.load('current', { 'packages': ['corechart'] });
        function DrawChartStatus(Status, rtype, reporttype) {          
            var json = Status;
          
            if (reporttype == 3 || reporttype == 4) {
                if (Status.length > 1) {
                    var result = [];
                    Status.reduce(function (res, value) {
                        if (!res[value.Y]) {
                            res[value.Y] = { Y: value.Y, Revenue: 0 };
                            result.push(res[value.Y])
                        }
                        res[value.Y].Revenue += value.Revenue;
                        return res;
                    }, {});
                    json = result;
                }

            }          
            var arr = [['', '',  { role: 'annotation' }]]          
            $.each(json, function (index, value) {                                 
                arr.push([value.Y, value.Revenue, value.Revenue]);             
             });
             var data = google.visualization.arrayToDataTable(arr);
             var options= {
                 title: rtype,
                 hAxis: { title: 'Revenue'},
                 legend: { position: 'none' },
                 scaleBeginAtZero: true,
                 height: 500               
             };
             var chart;
             if (reporttype == 3 ) {
                 chart = new google.visualization.BarChart(document.getElementById('chart_div'));
             }
             else {
                  chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
             }
            chart.draw(data, options);

        }
    </script>

</asp:Content>

