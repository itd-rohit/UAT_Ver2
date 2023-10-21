<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GraphicalReport.aspx.cs" Inherits="Design_HomeCollection_GraphicalReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>


     <script src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    
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
 
    

     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <strong>Day/Week/Month Wise Summary</strong>
            </div>
      


        <div class="POuter_Box_Inventory" >
         
            <div class="row" >
                <div class="col-md-5" style="border: 1px solid black;vertical-align:top">
                                <div class="row">  
                                       <div class="col-md-14">
                                           <label class="pull-left"><b>Report Type</b></label>
			                                <b class="pull-right">:</b>
                                        </div>
                                     </div>
                                    <div class="row">  
                                       <div class="col-md-24" style="margin-left:-4px">
                                            <asp:RadioButtonList ID="rd" runat="server" onchange="setreporttype();" RepeatDirection="Vertical" style="font-weight: 700"> 
                                            <asp:ListItem value="1" Selected="True">Day Wise Monthly Summary</asp:ListItem>
                                            <asp:ListItem value="2">Week Wise Monthly Summary</asp:ListItem>
                                            <asp:ListItem value="3">Month Wise Monthly Summary</asp:ListItem>
                                             </asp:RadioButtonList>                              
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
                                        <asp:DropDownList ID="ddlzone" class="ddlzone chosen-select" onchange="bindState()" runat="server"></asp:DropDownList>

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
                                        <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select" onchange="bindCity()" runat="server"></asp:DropDownList></div>
                                </div>
                    
                               <div class="row">  
                                       <div class="col-md-14">
                                        <label class="pull-left"><b>City</b></label>
			                                <b class="pull-right">:</b>
                                    </div>
                                   </div>
                                     <div class="row">  
                                       <div class="col-md-24">
                                           <asp:DropDownList ID="ddlcity" class="ddlcity chosen-select" onchange="bindPhelbo()" runat="server"></asp:DropDownList></td>
                                    </div>
                                          </div>
                                 <div class="row">  
                                       <div class="col-md-14">
                                        <label class="pull-left"><b>Phelbotomist</b></label>
			                                <b class="pull-right">:</b>
                                    </div>
                                      </div>
                                    <div class="row">  
                                       <div class="col-md-24">
                                            <asp:ListBox ID="ddlPhelbotomist" CssClass="multiselect" SelectionMode="Multiple" runat="server"  ClientIDMode="Static" ></asp:ListBox>
                                    </div>
                                </div>
                                
                                <div class="row">  
                                       <div class="col-md-14">
                                        <label class="pull-left"><b>From Date </b></label>
			                                <b class="pull-right">:</b>
                                    </div>
                                    </div>
                                    <div class="row">  
                                       <div class="col-md-12">
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
                                       <div class="col-md-12">
                                        <asp:TextBox ID="txttodate" runat="server" ReadOnly="true"></asp:TextBox>
                                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                            Animated="true" runat="server">
                                        </cc1:CalendarExtender>
                                    </div>
                                       </div>
                                <div class="row" style="text-align:center">
                                  
                                        <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                              
                        </div>
                     </div>
                      <div class="col-md-19" style="border: 1px solid black;vertical-align:top">
                          
                            <div style="width: 100%; height:480px; overflow: auto; background-color:white; ">
                                <div id="chart_div" style="width: 100%; float: left;"></div>
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
            //jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');
            if (jQuery('#<%=ddlzone.ClientID%>').val() == '0') {
                return;
            }
            
            var ddlstate;
            ddlstate = $("#<%=ddlstate.ClientID %>");
            $("#<%=ddlstate.ClientID %> option").remove();

            serverCall('GraphicalReport.aspx/bindstate',
                { zoneid:  jQuery('#<%=ddlzone.ClientID%>').val() },
                function (result) {
                    stateData = jQuery.parseJSON(result);
                    if (stateData.length == 0) {
                        jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val("0").html("No State Found"));
                    }
                    else {
                        //jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val("0").html("Select State"));
                        //for (i = 0; i < stateData.length; i++) {
                        //    jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val(stateData[i].id).html(stateData[i].state));
                        //}
                        ddlstate.bindDropDown({ defaultValue: 'Select State', data: JSON.parse(result), valueField: 'id', textField: 'state', isSearchAble: true });
                    }
                    $('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
                })
            
        }

        function bindCity() {


            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();


            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
//            jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');

            if (jQuery('#<%=ddlstate.ClientID%>').val() == '0') {
                return;
            }
            var ddlcity;
            ddlcity = $("#<%=ddlcity.ClientID %>");
            $("#<%=ddlcity.ClientID %> option").remove();

            
            serverCall('GraphicalReport.aspx/bindcity',
                { stateid:  jQuery('#<%=ddlstate.ClientID%>').val() },
                function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                       }
                       else {
                           //jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select City"));
                        //   for (i = 0; i < cityData.length; i++) {
                        //       jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].id).html(cityData[i].city));
                        //}

                        ddlcity.bindDropDown({ defaultValue: 'Select City', data: JSON.parse(result), valueField: 'id', textField: 'city', isSearchAble: true });
                    }
                    $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                   
                })
        }


        function bindPhelbo() {
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
            //jQuery('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');
            if (jQuery('#<%=ddlcity.ClientID%>').val() == '0') {
                return;
            }
            var ddlPhelbotomist;
            ddlPhelbotomist = $("#<%=ddlPhelbotomist.ClientID %>");
            $("#<%=ddlPhelbotomist.ClientID %> option").remove();
            serverCall('GraphicalReport.aspx/bindPhelbo',{ cityid: jQuery('#<%=ddlcity.ClientID%>').val() },function (result) {
                    phelboData = jQuery.parseJSON(result);
                    if (phelboData.length == 0) {

                    }
                    else {
                        ddlPhelbotomist.bindMultipleSelect({ data: JSON.parse(result), valueField: 'PhlebotomistID', textField: 'Name', controlID: $("#<%=ddlPhelbotomist.ClientID %>") });

                    }
                    $('#<%=ddlPhelbotomist.ClientID%>').multipleSelect('refresh');


                })

        }

        function setreporttype() {
            $('#chart_div').html('');
        }

        google.charts.load('current', { 'packages': ['corechart'] });
        function searchdata() {
            var reporttype = $("#<%=rd.ClientID%>").find(":checked").val();
            var fromdate = $("#<%=txtfromdate.ClientID%>").val();
            var todate = $("#<%=txttodate.ClientID%>").val();
            var stateid = $("#<%=ddlstate.ClientID%>").val();
            var cityid = $("#<%=ddlcity.ClientID%>").val();
            var phelbotomist = $("#<%=ddlPhelbotomist.ClientID%>").val();
            $('#chart_div').html('');
            
            
            serverCall('GraphicalReport.aspx/GetReport',
                { reporttype: (reporttype).toString(), fromdate: (fromdate).toString(), todate: (todate).toString(), stateid: (stateid).toString() ,cityid: (cityid).toString(), phelbotomist: (phelbotomist).toString() },
                function (result) {
                    var data = $.parseJSON(result);

                    if (data.length == 0) {
                        toast("Error","No Data Found");

                       

                    }
                    else {
                        var rtype = '';


                        if ($("#<%=rd.ClientID%>").find(":checked").val() == "1") {
                            rtype = 'Day Wise Monthly Summary';


                        }
                        else if ($("#<%=rd.ClientID%>").find(":checked").val() == "2") {
                            rtype = 'Week Wise Monthly Summary';


                        }
                        else if ($("#<%=rd.ClientID%>").find(":checked").val() == "3") {
                            rtype = 'Monthly  Summary';


                        }


                    var arr = [['AppDate', 'Pending', 'DoorLock', 'RescheduleRequest', 'CancelRequest', 'Rescheduled', 'Completed', 'BookingCompleted', 'Canceled']]


                    $.each(data, function (index, value) {


                        arr.push([value.AppDate, value.Pending, value.DoorLock, value.RescheduleRequest, value.CancelRequest, value.Rescheduled, value.Completed, value.BookingCompleted, value.Canceled]);

                    });

                    var dataTableData = google.visualization.arrayToDataTable(arr);


                    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));


                    var options = {
                        title: rtype,
                        curveType: 'function',
                        chartArea: { width: '75%', height: '75%' },
                        legend: { position: 'right', textStyle: { fontSize: 10 } },
                        hAxis: {
                            textStyle: {
                                fontSize: 8

                            }

                        },
                        vAxis: {
                            viewWindowMode: 'explicit',
                            viewWindow: {

                                min: 0
                            }
                        },
                        height: 480
                    };


                    chart.draw(dataTableData, options);

                       


                }
                })
        }


    </script>
</asp:Content>

