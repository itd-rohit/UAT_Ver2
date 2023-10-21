<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionLoginDetail.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionLoginDetail" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" />           
    <style type="text/css">
          #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
           
            width: 705px;
            left: 20%;
            top: 12%;
           
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
           
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 5px; 
            background-color: #d7edff;
            border-radius: 5px;
        }      
    </style>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>   
    <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">          
                <strong>Home Collection Phelbotomist Login Detail</strong> 
                </div>                     
          <div class="POuter_Box_Inventory" >
              <div class="row">
                    <div class="col-md-2">
                        <label class="pull-left">From Date   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                          <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>

                        </div>
                   <div class="col-md-2">
                        <label class="pull-left">To Date   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server"></cc1:CalendarExtender>
</div>
                  <div class="col-md-1">
                  <input type="button" value="More Filter" onclick="showmore()" style="font-weight: 700;cursor:pointer;display:none;" />
                       </div>
                  <div class="col-md-2">
                        <label class="pull-left">State   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlstate" runat="server"  onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>  

                         </div>
                        <div class="col-md-2">
                        <label class="pull-left">City   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        
                  <asp:DropDownList ID="ddlcity" runat="server" onchange="bindLocality()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                  </div>
                   </div>
               <div class="row" style="text-align:center">
                   <input type="button" value="Search" class="searchbutton" onclick="searchdata('')" />
                   </div>             
          </div>
          <div class="POuter_Box_Inventory" >
                <div class="row">
                <table id="tbl" style="width:100%;border-collapse:collapse;text-align:left;">                 
                        <tr id="trheader">
                             <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                      <td class="GridViewHeaderStyle" style="width: 50px;">Detail</td>
                                        <td class="GridViewHeaderStyle">State</td>
                                        <td class="GridViewHeaderStyle">City</td>
                                        <td class="GridViewHeaderStyle">Phelbotomist</td>
                                        <td class="GridViewHeaderStyle">Mobile</td>
                                        <td class="GridViewHeaderStyle">LoginDateTime</td>
                                        <td class="GridViewHeaderStyle">BodyTemperature</td>
                                        <td class="GridViewHeaderStyle" style="width:80px;">SelfiImage</td>
                                        <td class="GridViewHeaderStyle" style="width:80px;">BikeImage</td>
                                        <td class="GridViewHeaderStyle" style="width:80px;">BagImage</td>
                                        <td class="GridViewHeaderStyle" style="width:80px;">TempImage</td>
                                                            </tr>
                            </table>
              </div>
          </div>
        </div>
    <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position:absolute;right:-20px;top:-20px;width:36px;height:36px;cursor:pointer;" title="Close" />             
            <div class="POuter_Box_Inventory" style="width:705px;">
                 <div class="Purchaseheader" style="text-align:center">
               <span id="imgtype"></span>                    
            </div>              
                <img  id="img1" style="height:500px;width:700px;" alt=""/>            
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
         });

        </script>

    <script type="text/javascript">
        function bindCity(con) {          
            jQuery('#<%=ddlcity.ClientID%> option').remove();         
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
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
                $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            });                       
        }
        </script>

    <script type="text/javascript">
        function searchdata(status) {
            
            $('#tbl tr').slice(1).remove();
            serverCall('HomeCollectionLoginDetail.aspx/getdata', { fromdate: jQuery('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val() }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast("Info","No Data Found");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr style='background-color:lightgreen;' id='");$mydata.push(ItemData[i].Phlebotomistid);$mydata.push("'>");
                        $mydata.push('<td class="GridViewLabItemStyle"  id="srno">');$mydata.push(parseInt(i + 1));$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="srnod" title="Click To View Test Detail"><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="state" style="font-weight:bold;">');$mydata.push(ItemData[i].state);$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="City" style="font-weight:bold;">');$mydata.push(ItemData[i].City);$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="name" style="font-weight:bold;">');$mydata.push(ItemData[i].name);$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="Mobile" style="font-weight:bold;">');$mydata.push(ItemData[i].Mobile);$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="LoginDate" style="font-weight:bold;">');$mydata.push(ItemData[i].LoginDate);$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="TempValue" style="font-weight:bold;">');$mydata.push(ItemData[i].TempValue);$mydata.push('</td>');

                        var imgtype = "Selfie Image";
                        $mydata.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showimg(\'');$mydata.push(ItemData[i].SelfieImage);$mydata.push('\',\'');$mydata.push(ItemData[i].Phlebotomistid);$mydata.push('\',\'');$mydata.push(ItemData[i].name);$mydata.push('\',\'');$mydata.push(ItemData[i].foldername);$mydata.push('\',\'');$mydata.push(imgtype);$mydata.push('\')" /></td>');
                        imgtype = "Bike Image";
                        $mydata.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showimg(\'');$mydata.push(ItemData[i].BikeImage);$mydata.push('\',\'');$mydata.push(ItemData[i].Phlebotomistid);$mydata.push('\',\'');$mydata.push(ItemData[i].name);$mydata.push('\',\'');$mydata.push(ItemData[i].foldername);$mydata.push('\',\'');$mydata.push(imgtype);$mydata.push('\')" /></td>');
                        imgtype = "Bag Image";
                        $mydata.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showimg(\'');$mydata.push(ItemData[i].BagImage);$mydata.push('\',\'');$mydata.push(ItemData[i].Phlebotomistid);$mydata.push('\',\'');$mydata.push(ItemData[i].name);$mydata.push('\',\'');$mydata.push(ItemData[i].foldername);$mydata.push('\',\'');$mydata.push(imgtype);$mydata.push('\')" /></td>');
                        imgtype = "Temp Image";
                        $mydata.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showimg(\'');$mydata.push(ItemData[i].TempImage);$mydata.push('\',\'');$mydata.push(ItemData[i].Phlebotomistid);$mydata.push('\',\'');$mydata.push(ItemData[i].name);$mydata.push('\',\'');$mydata.push(ItemData[i].foldername);$mydata.push('\',\'');$mydata.push(imgtype);$mydata.push('\')" /></td>');

                        $mydata.push("</tr>");
                        $mydata = $mydata.join("");
                        $('#tbl').append($mydata);
                       
                    }

                }
            });
           
        }


        function showdetail(ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tbl').find('#ItemDetail' + id).length > 0) {
                $('table#tbl tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            serverCall('HomeCollectionLoginDetail.aspx/BindDetail', { fromdate: jQuery('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), phelbo: id }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {

                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    var $mydata = [];
                    $mydata.push("<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                    $mydata.push('<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                    $mydata.push('<td  style="width:20px;">#</td>');
                    $mydata.push('<td>DateTime</td>');
                    $mydata.push('<td>Battery</td>');
                    $mydata.push('<td>Status</td>');
                    $mydata.push('<td>PreBookingID</td>');

                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $mydata.push("<tr style='background-color:azure;' id='");$mydata.push(ItemData[i].stockid);$mydata.push("'>");
                        $mydata.push('<td>');$mydata.push(parseInt(i + 1));$mydata.push('</td>');
                        $mydata.push('<td>');$mydata.push(ItemData[i].endate);$mydata.push('</td>');
                        $mydata.push('<td>');$mydata.push(ItemData[i].BatteryPercentage);$mydata.push('</td>');
                        $mydata.push('<td>');$mydata.push(ItemData[i].STATUS);$mydata.push('</td>');
                        $mydata.push('<td>');$mydata.push(ItemData[i].PreBookingID);$mydata.push('</td>');
                        $mydata.push("</tr>");
                    }
                    $mydata.push("</table><div>");
                    $mydata = mydata.join("");
                    var newdata = '<tr id="ItemDetail' + id + '"><td></td><td colspan="5">' + $mydata + '</td></tr>';
                    $(newdata).insertAfter($(ctrl).closest('tr'));                  
                }
            });        
        }
        function showimg(imgname, phelboid, phelboname, foldername, imgtype) {
            $('#img1').attr('src', '');
            $('#imgtype').html(imgtype + " of " + phelboname);
            $('#popup_box1').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            PageMethods.GetUrl(phelboid, foldername, imgname, onSucess, onError);
            function onSucess(result) {  
                var scr = result;
                $('#img1').attr('src',scr);
            }  
  
            function onError(result) {  
                toast("Error", 'Something wrong.');
            }  
        }
        function unloadPopupBox() {
            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            
        }
    </script>
</asp:Content>

