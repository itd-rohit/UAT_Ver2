<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionChangeDropLocation.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionChangeDropLocation" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

     <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align:center;">
         
                <strong>Home Collection Change Drop Location</strong> 
                </div>
                
           <div class="POuter_Box_Inventory">
          

                       <div class="row">
                           <div class="col-md-2">
                               <label class="pull-left"><b>From Date</b></label>
			                    <b class="pull-right">:</b>
                           </div>
                             <div class="col-md-3"> 
                                 <asp:TextBox ID="txtfromdate" runat="server"  ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender>
                             </div>
                            <div class="col-md-2">
                                <label class="pull-left"><b>To Date </b></label>
			                    <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">        
                                <asp:TextBox ID="txttodate" runat="server" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left"><b>Mobile</b></label>
			                    <b class="pull-right">:</b> 
                            </div>
                           <div class="col-md-4">
                                <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" MaxLength="10" ></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                                </cc1:FilteredTextBoxExtender>

                           </div>
                           <div class="col-md-3">
                                <label class="pull-left"><b>Prebooking ID</b></label>
			                                <b class="pull-right">:</b> 
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtprebookingno" runat="server" AutoCompleteType="Disabled" ></asp:TextBox>
                            </div>
                       </div>
                
                       <div class="row">
                           <div class="col-md-2">
                               <label class="pull-left"><b>Zone</b></label>
			                    <b class="pull-right">:</b> 
                           </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlzone" class="ddlzone chosen-select" onchange="bindState()" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left"><b>State</b></label>
			                    <b class="pull-right">:</b> 
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlstate" class="ddlstate chosen-select" onchange="bindCity()" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                 <label class="pull-left"><b>City</b></label>
			                    <b class="pull-right">:</b> 
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlcity" class="ddlcity chosen-select" onchange="bindPhelbo()"    runat="server"></asp:DropDownList>

                            </div>
                            <div class="col-md-3">
                                 <label class="pull-left"><b>Phelbotomist </b></label>
			                    <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlPhelbotomist" class="ddlPhelbotomist chosen-select"    runat="server"></asp:DropDownList>
                            </div>


                       </div>
                       <div class="row">
                           <div class="col-md-10"></div>
                           <div class="col-md-2">
                                   <input type="button" value="Search" class="searchbutton" onclick="Searchme('')" />
                           </div>
                       </div>
               
                </div>
           

             <div class="POuter_Box_Inventory">
           
                <div  style="width:100%; max-height:380px;overflow:auto;">

                    <table id="tbl" style="width:100%;border-collapse:collapse;text-align:left;">
                        <thead>
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle">Phelbo</td>
                                        <td class="GridViewHeaderStyle">AppDate</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">PrebookingID</td>
                                        <td class="GridViewHeaderStyle">MobileNo</td>
                                        <td class="GridViewHeaderStyle">PatientName</td>
                                        <td class="GridViewHeaderStyle">City</td>
                                        <td class="GridViewHeaderStyle">Area</td> 
                                        <td class="GridViewHeaderStyle">Pincode</td>
                                        <td class="GridViewHeaderStyle" style="width:105px;">Route</td>
                                        <td class="GridViewHeaderStyle" style="width:175px;">Drop Location</td>
                            </tr>
                            </thead>
                            </table>
                  </div>
                 <center>
                           <input type="button" value="Update Data" class="savebutton" onclick="saveme()" id="btnupdate" style="display:none;" />
                 </center>
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


            jQuery("#tbl").tableHeadFixer({

            });

        });

        function bindState() {

            jQuery('#<%=ddlstate.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();

            jQuery('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlPhelbotomist.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlzone.ClientID%>').val() == '0') {
                return;
            }
            var ddlstate;
            ddlstate = $("#<%=ddlstate.ClientID %>");
            $("#<%=ddlstate.ClientID %> option").remove();
            serverCall('HomeCollectionChangeDropLocation.aspx/bindstate',
                { zoneid:  jQuery('#<%=ddlzone.ClientID%>').val() },
                function (result) {
                    stateData = jQuery.parseJSON(result);
                    if (stateData.length == 0) {
                        jQuery('#<%=ddlstate.ClientID%>').append(jQuery("<option></option>").val("0").html("No State Found"));
                    }
                    else {
                        ddlstate.bindDropDown({ defaultValue: 'Select State', data: JSON.parse(result), valueField: 'id', textField: 'state', isSearchAble: true });

                       }
                    $('#<%=ddlstate.ClientID%>').trigger('chosen:updated');
                })
           }

           function bindCity() {
                jQuery('#<%=ddlcity.ClientID%> option').remove();
                jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
                jQuery('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                jQuery('#<%=ddlPhelbotomist.ClientID%>').trigger('chosen:updated');
                if (jQuery('#<%=ddlstate.ClientID%>').val() == '0') {
                return;
                }
               var ddlcity;
               ddlcity = $("#<%=ddlcity.ClientID %>");
               $("#<%=ddlcity.ClientID %> option").remove();

               serverCall('HomeCollectionChangeDropLocation.aspx/bindcity',
                   { stateid: jQuery('#<%=ddlstate.ClientID%>').val()},
                   function (result) {
                       cityData = jQuery.parseJSON(result);
                       if (cityData.length == 0) {
                           jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                    }
                    else {
                           ddlcity.bindDropDown({ defaultValue: 'Select City', data: JSON.parse(result), valueField: 'id', textField: 'city', isSearchAble: true });
                    }
                       $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                   })
        }


        function bindPhelbo() {

            jQuery('#<%=ddlPhelbotomist.ClientID%> option').remove();
            jQuery('#<%=ddlPhelbotomist.ClientID%>').trigger('chosen:updated');
            if (jQuery('#<%=ddlcity.ClientID%>').val() == '0') {
            return;
            }
            var ddlPhelbotomist;
            ddlPhelbotomist = $("#<%=ddlPhelbotomist.ClientID %>");
            $("#<%=ddlPhelbotomist.ClientID %> option").remove();

            serverCall('HomeCollectionChangeDropLocation.aspx/bindPhelbo',
                { cityid:  jQuery('#<%=ddlcity.ClientID%>').val() },
                function (result) {
                    phelboData = jQuery.parseJSON(result);
                    if (phelboData.length == 0) {
                        jQuery('#<%=ddlPhelbotomist.ClientID%>').append(jQuery("<option></option>").val("0").html("No Phelbotomist  Found"));
                    }
                    else {
                        //jQuery('#<%=ddlPhelbotomist.ClientID%>').append(jQuery("<option></option>").val("0").html("Select Phelbotomist "));
                        //for (i = 0; i < phelboData.length; i++) {
                        //    jQuery('#<%=ddlPhelbotomist.ClientID%>').append(jQuery("<option></option>").val(phelboData[i].PhlebotomistID).html(phelboData[i].Name));
                        //}
                        ddlPhelbotomist.bindDropDown({ defaultValue: 'Select Phelbotomist', data: JSON.parse(result), valueField: 'PhlebotomistID', textField: 'Name', isSearchAble: true });
                    }
                    $('#<%=ddlPhelbotomist.ClientID%>').trigger('chosen:updated');
                })
        }

        function Searchme(status) {
            $('#tbl tr').slice(1).remove();
            serverCall('HomeCollectionChangeDropLocation.aspx/GetALlData',
                { State: jQuery('#<%=ddlstate.ClientID%>').val() , City:  jQuery('#<%=ddlcity.ClientID%>').val() , Phelbotomist:  jQuery('#<%=ddlPhelbotomist.ClientID%>').val(), fromdate: $('#<%=txtfromdate.ClientID%>').val() , todate: $('#<%=txttodate.ClientID%>').val() , status:  status , mobileno:  $('#<%=txtmobile.ClientID%>').val() , prebookingid:  $('#<%=txtprebookingno.ClientID%>').val()  },
                function (result) {
                    ItemData = jQuery.parseJSON(result);
                    if (ItemData.length == 0) {
                        toast("Error","No Data Found..");
                        $('#btnupdate').hide();
                        return;
                    }
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var color = "bisque";
                        var mydata = [];
                        mydata.push("<tr style='background-color:"); mydata.push(color); mydata.push(";' id='"); mydata.push(ItemData[i].PreBookingID);mydata.push("'>");
                        mydata.push( '<td class="GridViewLabItemStyle"  id="srno">');mydata.push(parseInt(i + 1));mydata.push(' <input type="checkbox" id="chk" onclick="setenable(this)"/></td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="phleboname" style="font-weight:bold;">');mydata.push(ItemData[i].Phleboname);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="appdate" style="font-weight:bold;">');mydata.push(ItemData[i].AppDate);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="currentstatus" >');mydata.push(ItemData[i].currentstatus);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="prebookingid" style="font-weight:bold;">');mydata.push(ItemData[i].PreBookingID);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="patientname" style="font-weight:bold;">');mydata.push(ItemData[i].PatientName);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="Mobile" style="font-weight:bold;">');mydata.push(ItemData[i].MobileNo);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="city" style="font-weight:bold;">');mydata.push(ItemData[i].city);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle"  id="locality">');mydata.push(ItemData[i].locality);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="pincode" style="font-weight:bold;">'); mydata.push(ItemData[i].pincode);mydata.push('</td>');
                        mydata.push( '<td class="GridViewLabItemStyle">');
                        mydata.push('<select class="ddlroute" onchange="binddroplocation(this)" style="width:100px;"> ');
                        if (ItemData[i].RouteName == "") {
                            mydata.push('<option  value="0">Select Route</option>');
                        }
                        for (var a = 0; a <= ItemData[i].routelist.split(',').length - 1; a++) {

                            if (ItemData[i].routelist.split(',')[a].split('#')[1] == ItemData[i].RouteName) {
                                mydata.push('<option selected="selected" value='); mydata.push(ItemData[i].routelist.split(',')[a].split('#')[0]); mydata.push('>'); mydata.push(ItemData[i].routelist.split(',')[a].split('#')[1]);mydata.push('</option>');
                            }
                            else {
                                mydata.push('<option value='); mydata.push(ItemData[i].routelist.split(',')[a].split('#')[0]); mydata.push('>'); mydata.push(ItemData[i].routelist.split(',')[a].split('#')[1]);mydata.push('</option>');
                            }
                        }
                        mydata.push( '</td>');
                        mydata.push( '<td class="GridViewLabItemStyle">');
                        mydata.push( '</select>');
                        mydata.push( '<select class="ddlcentre" style="width:170px;"> ');
                        if (ItemData[i].centrelist == "") {
                            mydata.push('<option value='); mydata.push(ItemData[i].cpid); mydata.push('>'); mydata.push(ItemData[i].centre);mydata.push('</option>');
                        }
                        else {
                            for (var a = 0; a <= ItemData[i].centrelist.split(',').length - 1; a++) {

                                if (ItemData[i].centrelist.split(',')[a].split('^')[1] == ItemData[i].centre) {
                                    mydata.push('<option selected="selected" value='); mydata.push(ItemData[i].centrelist.split(',')[a].split('^')[0]); mydata.push('>'); mydata.push(ItemData[i].centrelist.split(',')[a].split('^')[1]);mydata.push('</option>');
                                }
                                else {
                                    mydata.push('<option value='); mydata.push(ItemData[i].centrelist.split(',')[a].split('^')[0]); mydata.push('>'); mydata.push(ItemData[i].centrelist.split(',')[a].split('^')[1]);mydata.push('</option>');
                                }
                            }
                        }
                        mydata.push('</select>');
                        mydata.push('</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join("");
                        $('#tbl').append(mydata);
                    }
                    $('#btnupdate').show();
                    $("#tbl").find("select").attr("disabled", "disabled");
                })
        }
        function binddroplocation(ctrl) {
            $(ctrl).closest('tr').find('.ddlcentre option').remove();
            var routeid = $(ctrl).closest('tr').find('.ddlroute').val();
            if (routeid != "0") {
                serverCall('HomeCollectionChangeDropLocation.aspx/GetDropLocationList',
                    {routeid:routeid},
                    function (result) {
                        ItemData = jQuery.parseJSON(result);
                        if (ItemData.length == 0) {
                            toast("Error","No DropLoation Found Please Choose Another Route..");
                            $(ctrl).closest('tr').find('.ddlcentre').append(jQuery("<option></option>").val("0").html("No DropLocation Found"));
                            return;
                        }
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            $(ctrl).closest('tr').find('.ddlcentre').append(jQuery("<option></option>").val(ItemData[i].cpid).html(ItemData[i].Centre));
                        }
                    })
            }
        }

        function setenable(ctrl) {
            if ($(ctrl).is(':checked')) {
                $(ctrl).closest('tr').find("select").removeAttr("disabled");
                $(ctrl).closest('tr').css('background-color','aqua')
            }
            else {
                $(ctrl).closest('tr').find("select").attr("disabled", "disabled");
                $(ctrl).closest('tr').css('background-color', 'bisque')
            }
        }

        function saveme() {
            var dataIm = new Array();
            var c = 0;
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest("tr").find('#chk').is(':checked')) {
                    if ($(this).closest('tr').find('.ddlroute').val() == "0") {
                        $(this).closest('tr').find('.ddlroute').focus();
                        c = 1;
                        return;
                    }
                    if ($(this).closest('tr').find('.ddlcentre').val() == "0") {
                        $(this).closest('tr').find('.ddlcentre').focus();
                        c = 2;
                        return;
                    }
                    dataIm.push(id + "#" + $(this).closest('tr').find('.ddlroute').val() + "#" + $(this).closest('tr').find('.ddlroute option:selected').text() + "#" + $(this).closest('tr').find('.ddlcentre').val());
                }
            })
            if (c == 1) {
                toast("Error","Please Select Route");
                return;
            }
            if (c == 2) {
                toast("Error","Please Select Drop Location");
                return;
            }

            if (dataIm.length == 0) {
                toast("Error","Please Select Data To Update");
                return;
            }
            serverCall('homeCollectionchangedroplocation.aspx/SaveData',
                { dataIm: dataIm },
                function (result) {
                    //$.unblockUI();
                    var save = result;
                    if (save == "1") {
                        toast("Success","Record Update Successfully");

                        Searchme('');
                    }
                    else {
                        toast("Error",save);
                    }
                })
        }
    </script>

</asp:Content>

