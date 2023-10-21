<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CustomerRating.aspx.cs" Inherits="Design_HomeCollection_CustomerRating" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <script src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
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
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>


     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>


    
     <div id="Pbody_box_inventory">
          <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">
           
                <strong>Customer Rating</strong> 
                </div>
              


         <div class="POuter_Box_Inventory">
            
                       <div class="row">     
                           <div class="col-md-4" style="border: 1px solid black;vertical-align:top">
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
                                            <label class="pull-left"><b> To Date</b></label>
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
                                       <asp:ListBox ID="ddlzone" CssClass="multiselect" onchange="getstate()" SelectionMode="Multiple" runat="server" ClientIDMode="Static" ></asp:ListBox>
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
                                            <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select chosen-container"  onchange="getcity()" runat="server" ClientIDMode="Static" ></asp:DropDownList>
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
                                            <asp:DropDownList ID="ddlcity" onchange="getroute()" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static" ></asp:DropDownList>                          
                                       </div>
                                   </div>
                                      
                                            
                                   <div class="lbroute row">
                                       <div class="col-md-14">
                                           <label class="pull-left"><b>Route</b></label>
			                                <b class="pull-right">:</b>
                                        </div>
                                         </div>
                                <div class="row lbroute">
                                       <div class="col-md-24">
                                            <asp:DropDownList ID="ddlroute" class="ddlroute chosen-select chosen-container" runat="server" ClientIDMode="Static" ></asp:DropDownList>
                                       </div>
                                   </div>
                                   <div class="row" style="text-align: center">
                                      
                                  
                                        <input type="button" value="Get Report" class="searchbutton" onclick="searchdata()" />
                                  
                                   </div>
                                   
                           
                          
                           

              </div>
                           <div class="col-md-20" style="border:1px solid black;background-color:white;">
                               <div style="width:100%;overflow:auto;max-height:500px;" id="mydiv">
                                   

                                <table id="tblItems"   frame="box"  rules="all" style="float:left;width:99%;" >

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
            var ddlzone;
            ddlzone = $("#<%=ddlzone.ClientID %>");
            $("#<%=ddlzone.ClientID %> option").remove();
            serverCall('CustomerRating.aspx/bindzone',
                {},
                function (result) {
                    var cityData = jQuery.parseJSON(result);
                    ddlzone.bindMultipleSelect({ data: JSON.parse(result), valueField: 'businesszoneid', textField: 'businesszonename', controlID: $("#<%=ddlzone.ClientID %>") });

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
                var ddlstate;
                ddlstate = $("#<%=ddlstate.ClientID %>");
                $("#<%=ddlstate.ClientID %> option").remove();
                serverCall('CustomerRating.aspx/bindstate',
                    { zoneid:  (jQuery('#<%=ddlzone.ClientID%>').val()).toString()  },
                    function (result) {
                        var cityData = (result);
                        ddlstate.bindDropDown({ defaultValue: 'Select State', data: JSON.parse(result), valueField: 'id', textField: 'state', isSearchAble: true });
                        $('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
                    })
            }
        }
        function getcity() {
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlstate.ClientID%>').val() != "" && jQuery('#<%=ddlstate.ClientID%>').val()!="0") {               
                var ddlcity;
                ddlcity = $("#<%=ddlcity.ClientID %>");
                $("#<%=ddlcity.ClientID %> option").remove();
                serverCall('CustomerRating.aspx/bindcity',
                    { stateid:  jQuery('#<%=ddlstate.ClientID%>').val() },
                    function (result) {
                        var cityData = jQuery.parseJSON(result);
                        ddlcity.bindDropDown({ defaultValue: 'Select City', data: JSON.parse(result), valueField: 'id', textField: 'city', isSearchAble: true });
                        $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                    })
            }
        }

        function getroute() {
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlcity.ClientID%>').val() != "" && jQuery('#<%=ddlcity.ClientID%>').val() != "0") {               
                var ddlroute;
                ddlroute = $("#<%=ddlroute.ClientID %>");
                $("#<%=ddlroute.ClientID %> option").remove();
                serverCall('CustomerRating.aspx/bindroute',
                    { cityid: jQuery('#<%=ddlcity.ClientID%>').val() },
                    function (result) {
                        var cityData = jQuery.parseJSON(result);
                        ddlroute.bindDropDown({ defaultValue: 'Select Route', data: JSON.parse(result), valueField: 'Routeid', textField: 'Route', isSearchAble: true });
                        $('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
                    })
            }
        }
    </script>
    <script type="text/javascript">
        function searchdata() {
            var fromdate = $("#<%=txtfromdate.ClientID%>").val();
           var todate = $("#<%=txttodate.ClientID%>").val();
           var stateid = $("#<%=ddlstate.ClientID%>").val();
           var cityid = $("#<%=ddlcity.ClientID%>").val();
           var routeid = $("#<%=ddlroute.ClientID%>").val();
          
           $('#tblItems tr').remove();
            
           serverCall('CustomerRating.aspx/GetReport',
               { fromdate:  fromdate , todate:  todate , stateid:  stateid , cityid:  cityid , routeid:  routeid  },
               function (result) {
                   ItemData = $.parseJSON(result);
                   if (ItemData.length == 0) {
                       toast("Error","No Data Found");
                       $('#tblItems tr').remove();
                   }
                   else {

                       for (var i = 0; i <= ItemData.length - 1; i++) {
                           var mydata = [];
                           mydata.push("<tr  id='"); mydata.push(ItemData[i].PhlebotomistID);mydata.push("'>");
                           mydata.push('<td style="width:15%;" valign="top">');

                           if (ItemData[i].ProfilePics != '') {
                               mydata.push(' <img style="margin-right: 10px;" class="Circles" src="'); mydata.push(ItemData[i].ProfilePics);mydata.push('" />');
                           }
                           else {
                               mydata.push(' <img style="margin-right: 10px;" class="Circles" src="../../App_Images/no-avatar.gif" />');
                           }
                           mydata.push( '</td>');
                           mydata.push( '<td style="width:30%;padding:5px;font-weight:bold;" valign="top">');
                           mydata.push( 'Name :- ');mydata.push(ItemData[i].Phelboname);mydata.push("<br/>");
                           mydata.push( 'DOB :- ');mydata.push(ItemData[i].Age);mydata.push("<br/>");
                           mydata.push( 'Mobile :- ');mydata.push(ItemData[i].Mobile);mydata.push("<br/>");
                           mydata.push( 'State :- ');mydata.push(ItemData[i].state);mydata.push("<br/>");
                           mydata.push( 'City :- ');mydata.push(ItemData[i].city);mydata.push("<br/>");
                           mydata.push( 'Route :- ');mydata.push(ItemData[i].RouteName);mydata.push("<br/>");
                           mydata.push( '<span style="color:red;">Average Rating :- ');mydata.push(ItemData[i].Rating);mydata.push("</span>");
                           mydata.push( '</td>');
                           mydata.push( '<td style="width:20%;padding:5px;font-weight:bold;" valign="top">');
                           mydata.push( ' <div id="allChart_');mydata.push(ItemData[i].PhlebotomistID );mydata.push('" style="width: 100%; float: left;"></div>');
                           mydata.push( '</td>');
                           mydata.push( '<td style="width:35%;padding:5px;font-size:10px;" valign="top">');
                           mydata.push( ' <table id="lastthree_');mydata.push(ItemData[i].PhlebotomistID);mydata.push('" style="width: 100%; float: left;"></table>');
                           mydata.push( '</td>');
                           mydata.push( "</tr>");
                           mydata = mydata.join("");
                           $('#tblItems').append(mydata);
                           DrawChartStatus(ItemData[i].PhlebotomistID, ItemData[i].fiveStar, ItemData[i].fourStar, ItemData[i].threeStar, ItemData[i].twoStar, ItemData[i].oneStar);
                           LastThreeVisit(ItemData[i].PhlebotomistID);
                       }
                   }
               })
       }
        google.charts.load('current', { 'packages': ['corechart'] });
        function DrawChartStatus(divid, fiveStar, fourStar, threeStar, twoStar, oneStar) {
            var data = google.visualization.arrayToDataTable([
      ["", "", { role: "style" } ,{ role: 'annotation' }],
      ["5 Star", fiveStar, "#09f", fiveStar],
      ["4 Star", fourStar, "#09f", fourStar],
      ["3 Star", threeStar, "#09f", threeStar],
      ["2 Star", twoStar, "#09f", twoStar],
      ["1 Star", oneStar, "#09f", oneStar]
            ]);
            var chart = new google.visualization.BarChart(document.getElementById("allChart_" + divid));
            var options = {
                title: 'Rating',
                legend: { position: 'none' }
            };

            chart.draw(data, options);
        }

       function exporttoexcel() {
           var count = $('#tblItems tr').length;
           if (count == 0 || count == 1) {
               toast("Error","Please Search Data To Export");
               return;
           }
           var ua = window.navigator.userAgent;
           var msie = ua.indexOf("MSIE ");
           sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=mydiv]').html()));
       }
       function LastThreeVisit(divid) {        
           $('#lastthree_' + divid + ' tr').remove();
           serverCall('CustomerRating.aspx/GetLastThreeData',
               { phelboid:  divid  },
               function (result) {
                   LastData = $.parseJSON(result);

                   if (LastData.length == 0) {
                       toast("Error", "No Data Found");
                       $('#lastthree_' + divid + ' tr').remove();
                   }
                   else {
                       var mydata1 = [];
                       mydata1.push('<tr> <td colspan="4" align="center" style="font-weight:bold;">Last Three Ratings</td></tr>');
                       mydata1.push('<tr style="background-color:aquamarine;"> <td>Name</td> <td>UHID</td> <td>App DateTime</td> <td>Rating</td> </tr>');
                       for (var i = 0; i <= LastData.length - 1; i++) {
                           mydata1.push('<tr> <td>'); mydata1.push(LastData[i].patientname); mydata1.push('</td> <td>'); mydata1.push(LastData[i].patient_id); mydata1.push('</td> <td>'); mydata1.push(LastData[i].appdate); mydata1.push('</td> <td>'); mydata1.push(LastData[i].PhelboRating);mydata1.push('</td> </tr>');
                       }
                       mydata1 = mydata1.join("");
                       $('#lastthree_' + divid).append(mydata1);
                      
                   }
               })
       }
    </script>
</asp:Content>

