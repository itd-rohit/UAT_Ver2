<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionTracking.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionTracking" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
    <style type="text/css">
          .gm-style-cc {
         display: none !important;
     }

     .gm-style a[href^="https://maps.google.com/maps"] {
         display: none !important;
     }
    </style>
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    
     <%: Scripts.Render("~/bundles/Chosen") %>

     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyBVtUztjJy215wJb3VbmUWHoCfGR7anRgE"></script>
   
 
     <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
              <div class="POuter_Box_Inventory" style="text-align:center;font-weight:bold;">
         
                Phelbotomist Tracking
             
                    </div>
                 

           <div class="POuter_Box_Inventory" >
       <div class="row">
           <div class="col-md-6">
                <div class="row">
            <div class="col-md-6">
                    <label class="pull-left">
                        State
                    </label>
                    <b class="pull-right">:</b>
                </div>
            <div class="col-md-18">
                <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select" onchange="bindCity()" runat="server"   ></asp:DropDownList>
            </div>
               </div>
               <div class="row">
            <div class="col-md-6">
                    <label class="pull-left">
                        City
                    </label>
                    <b class="pull-right">:</b>
                </div>
            <div class="col-md-18">
                <asp:DropDownList ID="ddlcity" class="ddlcity chosen-select" onchange="bindroute()"    runat="server" ></asp:DropDownList>
                </div>
                   </div>
               <div class="row">
            <div class="col-md-6">
                    <label class="pull-left">
                        Route
                    </label>
                    <b class="pull-right">:</b>
                </div>
            <div class="col-md-18">
                <asp:DropDownList ID="ddlroute"  class="ddlroute chosen-select"  runat="server" ></asp:DropDownList>
                 </div>
                   </div>
               <div class="row" style="text-align:center">
                   <input type="button" value="Track" class="searchbutton" onclick="tracknow()" />
                   </div>
                </div>
           <div class="col-md-18">
               <div id="dvMap" style="width: 99%; height: 500px">
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
                jQuery(selector).chosen(config[selector]);
            }
                 
            showmap();
         

        });

        </script>
    <script type="text/javascript">


        function bindCity() {
           
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
                cityData = jQuery.parseJSON(result);
                if (cityData.length == 0) {
                    jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                    }
                    else {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }

                    }
                jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            });
             
        }

        function bindroute() {
            
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            serverCall('HomeCollection.aspx/bindroute', { cityid: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Route Found---"));
                    }

                    else {
                        jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("Select Route"));
                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val(localityData[i].routeid).html(localityData[i].Route));
                        }
                    }
                jQuery('#<%=ddlroute.ClientID%>').trigger('chosen:updated');
            });
            
        }
    </script>

    <script type="text/javascript">
        function tracknow() {
            var stateid = $('#<%=ddlstate.ClientID%>').val();
            var length = $('#<%=ddlcity.ClientID%> > option').length;
            var cityid = "0";
            if (length > 0) {
                cityid= $('#<%=ddlcity.ClientID%>').val();
            }

            var length1 = $('#<%=ddlroute.ClientID%> > option').length;
            var routeid = "0";
            if (length1 > 0) {
                routeid = $('#<%=ddlroute.ClientID%>').val();
            }

         

            var gzoon = 4;
            if(stateid!="0" && cityid=="0")
            {
                gzoon = 8;
            }
            if (stateid != "0" && cityid != "0") {
                gzoon = 12;
            }
            serverCall('homecollectiontracking.aspx/track', { stateid: stateid, cityid: cityid, routeid: routeid }, function (result) {
                var markers = jQuery.parseJSON(result);

                var mapOptions = {
                    center: { lat: markers[0].Latitude, lng: markers[0].Longitude },
                    zoom: gzoon,
                    mapTypeControl: false,
                    streetViewControl: false,


                    fullscreenControl: false,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };


                var map = new google.maps.Map(document.getElementById("dvMap"), mapOptions);

                for (i = 0; i < markers.length; i++) {
                    var data = markers[i]
                    var myLatlng = new google.maps.LatLng(data.Latitude, data.Longitude);
                    var marker = new google.maps.Marker({
                        position: myLatlng,
                        map: map,
                        title: data.Title,
                        animation: google.maps.Animation.DROP
                    });

                }
            });
            
        }

        function showmap() {

            var map = new google.maps.Map(document.getElementById('dvMap'), {
                center: { lat: 20.59, lng: 78.96 },
                zoom: 4,
                mapTypeControl: false,
                streetViewControl: false,
              
                fullscreenControl: false,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

        }
    </script>
</asp:Content>

