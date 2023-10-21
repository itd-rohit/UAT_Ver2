<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCScheduling.aspx.cs" Inherits="Design_Quality_QCScheduling" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
   
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
    <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>  
    <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
  <%--   <%: Scripts.Render("~/bundles/WebFormsJs") %>--%>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 <%--    <%: Scripts.Render("~/bundles/JQueryStore") %>--%>
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
	   <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>QC Scheduling</b>

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td><strong>Business Zone :</strong></td>
                        <td>
                            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" Width="125px" runat="server" ClientIDMode="Static"></asp:ListBox>
                            &nbsp;&nbsp;&nbsp; <strong>State : </strong>
                            <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" Width="225px" runat="server" ClientIDMode="Static" onchange="bindcentre()"></asp:ListBox>
                        </td>
                        <td><strong>Centre Type :</strong></td>
                        <td>
                            <asp:ListBox ID="lstType" CssClass="multiselect" SelectionMode="Multiple" Width="125px" runat="server" ClientIDMode="Static" onchange="bindcentre()"></asp:ListBox>
                        </td>

                    </tr>
                    <tr>
                        <td><strong>Centre :</strong></td>
                        <td>
                            <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="500px" runat="server" ClientIDMode="Static" onchange="bindmachine()"></asp:ListBox></td>
                        <td><strong>Machine :</strong></td>
                        <td>
                            <asp:ListBox ID="lstmachine" CssClass="multiselect" SelectionMode="Multiple" Width="500px" runat="server" ClientIDMode="Static" onchange="bindparameter()"></asp:ListBox></td>

                    </tr>
                    <tr>
                        <td><strong>Lab Observation :</strong></td>
                        <td colspan="2">
                            <asp:ListBox ID="lstparameter" CssClass="multiselect" SelectionMode="Multiple" Width="600px" runat="server" ClientIDMode="Static"></asp:ListBox></td>
                        <td>
                            <input type="button" value="Search" onclick="searchdata()" class="searchbutton" />

                            &nbsp;&nbsp;
                             <input type="button" value="Export To Excel" onclick="excelexport()" class="searchbutton" />
                                 &nbsp;&nbsp;
                            <input type="button" value="Save Data" onclick="savedata()" class="savebutton" id="btnsave" style="display:none;" />
                        </td>

                    </tr>

                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
              <div class="Purchaseheader" style="width: 1300px; " > 
                  <table>
                      <tr>
                          <td width="300px">Lab Observation List </td>

                          <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;" >
                                &nbsp;&nbsp;</td>
                    <td>Saved Data&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightyellow;" >
                                &nbsp;&nbsp;</td>
                    <td>New Data</td>

                      </tr>
                  </table>
        </div>
                <div style="width: 1295px; max-height: 370px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr id="trheader1">
                                <th class="GridViewHeaderStyle" style="width: 30px;" rowspan="2">Sr.No<br /><input type="checkbox" id="chhead" /></th>
                                <th class="GridViewHeaderStyle" style="width: 125px;" rowspan="2">LabObservation ID</th>
                                <th class="GridViewHeaderStyle" rowspan="2">LabObservation Name</th>
                                <th class="GridViewHeaderStyle" rowspan="2">Lock<br />Machine<br /><input type="checkbox" id="chheadlock" /></th>
                                <th class="GridViewHeaderStyle" colspan="8" align="center">Level 1</th>
                                <th class="GridViewHeaderStyle" colspan="8" align="center">Level 2</th>
                                <th class="GridViewHeaderStyle" colspan="8" align="center">Level 3</th>

                            </tr>
                            <tr id="trheader">
                                <th class="GridViewHeaderStyle">
                                    <input id="lb1time" type="text" style="width: 80px;" name="timelevel1" onblur="showme(this)" class="timelevel1 timepiker" value="" placeholder="Level 1 Time" /></th>

                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSunHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkSun_level1')">Sun </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkMonHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkMon_level1')">Mon </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkTueHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkTue_level1')">Tue </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkWedHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkWed_level1')">Wed </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkThuHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkThu_level1')">Thu </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkFriHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkFri_level1')">Fri </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSatHead_level1"  style="cursor:pointer;"  onclick="chkAll(this,'chkSat_level1')">Sat </label></th>
                                <th class="GridViewHeaderStyle">
                                    <input id="lb2time" type="text" style="width: 80px;" name="timelevel2" onblur="showme(this)" class="timelevel2 timepiker" value="" placeholder="Level 2 Time" /></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSunHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkSun_level2')">Sun </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkMonHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkMon_level2')">Mon </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkTueHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkTue_level2')">Tue </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkWedHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkWed_level2')">Wed </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkThuHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkThu_level2')">Thu </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkFriHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkFri_level2')">Fri </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSatHead_level2"  style="cursor:pointer;"  onclick="chkAll(this,'chkSat_level2')">Sat </label></th>
                                <th class="GridViewHeaderStyle">
                                    <input id="lb3time" type="text" style="width: 80px;" name="timelevel3" onblur="showme(this)" class="timelevel3 timepiker" value="" placeholder="Level 3 Time" /></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSunHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkSun_level3')">Sun </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkMonHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkMon_level3')">Mon </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkTueHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkTue_level3')">Tue </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkWedHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkWed_level3')">Wed </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkThuHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkThu_level3')">Thu </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkFriHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkFri_level3')">Fri </label></th>
                                <th class="GridViewHeaderStyle"><label class="lb" id="chkSatHead_level3"  style="cursor:pointer;"  onclick="chkAll(this,'chkSat_level3')">Sat </label></th>

                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">

        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        $(function () {

            $(".timepiker").timepicker({
              
                step: 60
            });

            $('[id=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstmachine]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstparameter]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


         
         bindZone();
         bindtype();
         jQuery("#tblitemlist").tableHeadFixer({

         });
        });

        $(document).on('click', '#chhead', function () {
            if ($("#chhead").is(":checked")) {

                $("#tblitemlist tr").find("#chk").prop("checked", true);

            }
            else {

                $("#tblitemlist tr").find("#chk").prop("checked", false);

            }
        });

        $(document).on('click', '#chheadlock', function () {
            if ($("#chheadlock").is(":checked")) {

                $("#tblitemlist tr").find("#chklock").prop("checked", true);

            }
            else {

                $("#tblitemlist tr").find("#chklock").prop("checked", false);

            }
        });


        function bindtype() {

            //$.blockUI();
            $.ajax({
                url: "QCScheduling.aspx/bindtypedb",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
              
                success: function (result) {
                    typedata = jQuery.parseJSON(result.d);
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        $('#lstType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].TEXT));
                    }

                    $('[id*=lstType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                }
            });
            //$.unblockUI();
        }

        function bindZone() {
            //$.blockUI();
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
              
                success: function (result) {
                    BusinessZoneID = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    $('[id=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
            //$.unblockUI();
        }

        $('#lstZone').on('change', function () {
            jQuery('#<%=lstState.ClientID%> option').remove();
               jQuery('#<%=lstCentre.ClientID%> option').remove();
               jQuery('#lstState').multipleSelect("refresh");
               jQuery('#lstCentre').multipleSelect("refresh");
               jQuery('#<%=lstmachine.ClientID%> option').remove();
            jQuery('#lstmachine').multipleSelect("refresh");

            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#lstparameter').multipleSelect("refresh");
               var BusinessZoneID = $(this).val();
               bindBusinessZoneWiseState(BusinessZoneID);
        });

        function bindBusinessZoneWiseState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                //$.blockUI();
                jQuery.ajax({
                    url: "../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                   
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
                //$.unblockUI();
            }
        }

        function bindcentre() {





            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");

            jQuery('#<%=lstmachine.ClientID%> option').remove();
            jQuery('#lstmachine').multipleSelect("refresh");

            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#lstparameter').multipleSelect("refresh");

            var StateID = jQuery('#<%=lstState.ClientID%>').val();
            var TypeId = jQuery('#<%=lstType.ClientID%>').val();
            var ZoneId = jQuery('#<%=lstZone.ClientID%>').val();
            //$.blockUI();
            jQuery.ajax({
                url: "QCScheduling.aspx/bindcentre",
                data: '{ TypeId: "' + TypeId + '",StateID:"' + StateID + '",ZoneId:"' + ZoneId + '"}',
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    centredata = jQuery.parseJSON(result.d);
                    for (i = 0; i < centredata.length; i++) {
                        jQuery("#lstCentre").append(jQuery("<option></option>").val(centredata[i].centreid).html(centredata[i].centre));
                    }
                    jQuery('[id=lstCentre]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });


                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
            //$.unblockUI();
        }

        function bindmachine() {

            jQuery('#<%=lstmachine.ClientID%> option').remove();
            jQuery('#lstmachine').multipleSelect("refresh");

            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#lstparameter').multipleSelect("refresh");

            var centreid = jQuery('#<%=lstCentre.ClientID%>').val();

            if (centreid != "") {
                //$.blockUI();
                jQuery.ajax({
                    url: "QCScheduling.aspx/bindmachine",
                    data: '{ centreid: "' + centreid + '"}',
                    type: "POST",
                    timeout: 120000,
                   
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        machinedata = jQuery.parseJSON(result.d);
                        for (i = 0; i < machinedata.length; i++) {
                            jQuery("#lstmachine").append(jQuery("<option></option>").val(machinedata[i].MacID).html(machinedata[i].machinename));
                        }
                        jQuery('[id=lstmachine]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
                //$.unblockUI();
            }
        }

        function bindparameter() {

            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#lstparameter').multipleSelect("refresh");



            var machineid = jQuery('#<%=lstmachine.ClientID%>').val();

            if (machineid != "") {
                //$.blockUI();
                jQuery.ajax({
                    url: "QCScheduling.aspx/bindparameter",
                    data: '{ machineid: "' + machineid + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        parameterdata = jQuery.parseJSON(result.d);
                        for (i = 0; i < parameterdata.length; i++) {
                            jQuery("#lstparameter").append(jQuery("<option></option>").val(parameterdata[i].LabObservation_ID).html(parameterdata[i].PatameterName));
                        }
                        jQuery('[id=lstparameter]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
                //$.unblockUI();
            }
        }

        function searchdata() {
            var centreid = jQuery('#<%=lstCentre.ClientID%>').val();
            var machineid = jQuery('#<%=lstmachine.ClientID%>').val();
            var parameter = jQuery('#<%=lstparameter.ClientID%>').val();

            if (centreid == "") {
                showerrormsg("Please Select Centre");
                return;
            }
            if (machineid == "") {
                showerrormsg("Please Select Machine");
                return;
            }
            if (parameter == "") {
                showerrormsg("Please Select Lab Observation ");
                return;
            }
            $('#tblitemlist tr').slice(2).remove();
            $("#chhead").prop("checked", false);
            $("#chheadlock").prop("checked", false);
            $('#lb3time').val('');
            $('#lb2time').val('');
            $('#lb1time').val('');
            $('.lb').removeClass("GridViewDragItemStyle");
            $('#btnsave').hide();
            //$.blockUI();
            jQuery.ajax({
                url: "QCScheduling.aspx/binddata",
                data: '{ centreid: "' + centreid + '",machineid:"' + machineid + '",parameter:"' + parameter + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        //$.unblockUI();
                        $('#btnsave').hide();
                        return;
                    }
                    $('#tblitemlist').append("<tbody>");
                    for (i = 0; i < ItemData.length; i++) {
                        var color = "lightyellow";
                        if (Number(ItemData[i].savedid) > 0) {
                            color = "pink";
                        }
                        var mydata = "<tr style='background-color:" + color + ";' id='" + ItemData[i].LabObservation_ID + "'>";
                        mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '<input type="checkbox" id="chk"/></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_ID">' + ItemData[i].LabObservation_ID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_Name">' + ItemData[i].LabObservation_Name + '</td>';
                        if (ItemData[i].LockMachine == "1") {
                            mydata += '<td class="GridViewLabItemStyle"  id="lockmachine"><input type="checkbox" id="chklock" checked="checked"  /></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="lockmachine"><input type="checkbox" id="chklock"  /></td>';
                        }
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_time"><input  type="text" style="width:80px;" name="timelevel1" class="timelevel1 timepiker"  value="' + ItemData[i].Level1Time + '" id="level1_time"  /></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_sunday"><span flag="' + ItemData[i].Level1Sun + '" style="cursor:pointer;" id="chkSun_level1" class="' + ItemData[i].Level1SunClass + '">Sun</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_monday"><span flag="' + ItemData[i].Level1Mon + '" style="cursor:pointer;" id="chkMon_level1" class="' + ItemData[i].Level1MonClass + '">Mon</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_tuesday"><span flag="' + ItemData[i].Level1Tue + '" style="cursor:pointer;" id="chkTue_level1" class="' + ItemData[i].Level1TueClass + '">Tue</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_wednesday"><span flag="' + ItemData[i].Level1Wed + '" style="cursor:pointer;" id="chkWed_level1" class="' + ItemData[i].Level1WedClass + '">Wed</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_thursday"><span flag="' + ItemData[i].Level1Thu + '" style="cursor:pointer;" id="chkThu_level1" class="' + ItemData[i].Level1ThuClass + '">Thu</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_friday"><span flag="' + ItemData[i].Level1Fri + '" style="cursor:pointer;" id="chkFri_level1" class="' + ItemData[i].Level1FriClass + '">Fri</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="level_1_saturday"><span flag="' + ItemData[i].Level1Sat + '" style="cursor:pointer;" id="chkSat_level1" class="' + ItemData[i].Level1SatClass + '">Sat</span></td>';

                        mydata += '<td class="GridViewLabItemStyle"  id="level_2_time"><input type="text" style="width:80px;" name="timelevel2" class="timelevel2 timepiker"  value="' + ItemData[i].Level2Time + '" id="level2_time"  /></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_sunday"><span flag="' + ItemData[i].Level2Sun + '" style="cursor:pointer;" id="chkSun_level2" class="' + ItemData[i].Level2SunClass + '">Sun</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_monday"><span flag="' + ItemData[i].Level2Mon + '" style="cursor:pointer;" id="chkMon_level2" class="' + ItemData[i].Level2MonClass + '">Mon</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_tuesday"><span flag="' + ItemData[i].Level2Tue + '" style="cursor:pointer;" id="chkTue_level2" class="' + ItemData[i].Level2TueClass + '">Tue</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_wednesday"><span flag="' + ItemData[i].Level2Wed + '" style="cursor:pointer;" id="chkWed_level2" class="' + ItemData[i].Level2WedClass + '">Wed</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_thursday"><span flag="' + ItemData[i].Level2Thu + '" style="cursor:pointer;" id="chkThu_level2" class="' + ItemData[i].Level2ThuClass + '">Thu</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_friday"><span flag="' + ItemData[i].Level2Fri + '" style="cursor:pointer;" id="chkFri_level2" class="' + ItemData[i].Level2FriClass + '">Fri</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_2_saturday"><span flag="' + ItemData[i].Level2Sat + '" style="cursor:pointer;" id="chkSat_level2" class="' + ItemData[i].Level2SatClass + '">Sat</span></td>';

                        mydata += '<td class="GridViewLabItemStyle"  id="level_3_time"><input type="text" style="width:80px;" name="timelevel3" class="timelevel3 timepiker"     value="' + ItemData[i].Level3Time + '" id="level3_time"  /></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_sunday"><span flag="' + ItemData[i].Level3Sun + '" style="cursor:pointer;" id="chkSun_level3" class="' + ItemData[i].Level3SunClass + '">Sun</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_monday"><span flag="' + ItemData[i].Level3Mon + '" style="cursor:pointer;" id="chkMon_level3" class="' + ItemData[i].Level3MonClass + '">Mon</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_tuesday"><span flag="' + ItemData[i].Level3Tue + '" style="cursor:pointer;" id="chkTue_level3" class="' + ItemData[i].Level3TueClass + '">Tue</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_wednesday"><span flag="' + ItemData[i].Level3Wed + '" style="cursor:pointer;" id="chkWed_level3" class="' + ItemData[i].Level3WedClass + '">Wed</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_thursday"><span flag="' + ItemData[i].Level3Thu + '" style="cursor:pointer;" id="chkThu_level3" class="' + ItemData[i].Level3ThuClass + '">Thu</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_friday"><span flag="' + ItemData[i].Level3Fri + '" style="cursor:pointer;" id="chkFri_level3" class="' + ItemData[i].Level3FriClass + '">Fri</span></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="leve1_3_saturday"><span flag="' + ItemData[i].Level3Sat + '" style="cursor:pointer;" id="chkSat_level3" class="' + ItemData[i].Level3SatClass + '">Sat</span></td>';
                        mydata += "</tr>";
                        $('#tblitemlist').append(mydata);

                    }
                    $('#tblitemlist').append("</tbody>");
                    $(".timepiker").timepicker({

                        step: 60
                    });
                    Func();
                    $('#btnsave').show();
                    //$.unblockUI();

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
          
        }



        function showme(ctrl) {
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });


        }


        function chkAll(ctrl, chk) {
            if ($(ctrl).hasClass("GridViewDragItemStyle")) {
                $(ctrl).removeClass("GridViewDragItemStyle");
                $("#tblitemlist tr").find("#" + chk).attr("flag", "0").removeClass("GridViewDragItemStyle");
            }
            else {
                $(ctrl).addClass("GridViewDragItemStyle");
                $("#tblitemlist tr").find("#" + chk).attr("flag", "1").addClass("GridViewDragItemStyle");
            }


        };


        function Func() {
            $("#tblitemlist tr").find("span").click(function () {
                if ($(this).hasClass("GridViewDragItemStyle")) {
                    $(this).removeClass("GridViewDragItemStyle");
                    $(this).attr("flag", "0");
                }
                else {
                    $(this).addClass("GridViewDragItemStyle");
                    $(this).attr("flag", "1");
                }

            });
        }

        function createdatatodave() {
            var daattosave = new Array();
            var centreid = jQuery('#<%=lstCentre.ClientID%>').val();
            var machineid = jQuery('#<%=lstmachine.ClientID%>').val();
          

            $('#tblitemlist tbody tr').each(function () {
                var row = this;
                var id = $(row).attr("id");

                if ($(row).find("#chk").is(':checked')) {
                    var objPLO = new Object();
                    objPLO.centreid = centreid;
                    objPLO.machineid = machineid;
                  
                    objPLO.LabObservation_ID = id;
                    objPLO.LockMachine = $(row).find("#chklock").is(':checked') ? 1 : 0;
                    objPLO.Level1_Time = $(row).find("#level1_time").val();
                    objPLO.Level1_Sun = $(row).find("#chkSun_level1").attr("flag");
                    objPLO.Level1_Mon = $(row).find("#chkMon_level1").attr("flag");
                    objPLO.Level1_Tue = $(row).find("#chkTue_level1").attr("flag");
                    objPLO.Level1_Wed = $(row).find("#chkWed_level1").attr("flag");
                    objPLO.Level1_Thu = $(row).find("#chkThu_level1").attr("flag");
                    objPLO.Level1_Fri = $(row).find("#chkFri_level1").attr("flag");
                    objPLO.Level1_Sat = $(row).find("#chkSat_level1").attr("flag");

                    objPLO.Level2_Time = $(row).find("#level2_time").val();
                    objPLO.Level2_Sun = $(row).find("#chkSun_level2").attr("flag");
                    objPLO.Level2_Mon = $(row).find("#chkMon_level2").attr("flag");
                    objPLO.Level2_Tue = $(row).find("#chkTue_level2").attr("flag");
                    objPLO.Level2_Wed = $(row).find("#chkWed_level2").attr("flag");
                    objPLO.Level2_Thu = $(row).find("#chkThu_level2").attr("flag");
                    objPLO.Level2_Fri = $(row).find("#chkFri_level2").attr("flag");
                    objPLO.Level2_Sat = $(row).find("#chkSat_level2").attr("flag");

                    objPLO.Level3_Time = $(row).find("#level3_time").val();
                    objPLO.Level3_Sun = $(row).find("#chkSun_level3").attr("flag");
                    objPLO.Level3_Mon = $(row).find("#chkMon_level3").attr("flag");
                    objPLO.Level3_Tue = $(row).find("#chkTue_level3").attr("flag");
                    objPLO.Level3_Wed = $(row).find("#chkWed_level3").attr("flag");
                    objPLO.Level3_Thu = $(row).find("#chkThu_level3").attr("flag");
                    objPLO.Level3_Fri = $(row).find("#chkFri_level3").attr("flag");
                    objPLO.Level3_Sat = $(row).find("#chkSat_level3").attr("flag");

                    daattosave.push(objPLO);
                }

            });
            return daattosave;
        }


        function savedata() {
            $("#btnsave").attr('disabled', true).val("Saving Data...");

            if (jQuery('#<%=lstCentre.ClientID%>').val() == "") {
                showerrormsg("Please Select Centre");
                $("#btnsave").attr('disabled', false).val("Save Data");
                return;
            }
            if (jQuery('#<%=lstmachine.ClientID%>').val() == "") {
                showerrormsg("Please Select Machine");
                $("#btnsave").attr('disabled', false).val("Save Data");
                return;
            }
            if (jQuery('#<%=lstparameter.ClientID%>').val() == "") {
                showerrormsg("Please Select Lab Observation ");
                $("#btnsave").attr('disabled', false).val("Save Data");
                return;
            }

            var objsavedata = createdatatodave();

            if (objsavedata == "") {
                showerrormsg("Please Select Data To Save ");
                $("#btnsave").attr('disabled', false).val("Save Data");
                return;
            }

           
            //$.blockUI();

            $.ajax({

                url: "QCScheduling.aspx/SaveData",
                data: JSON.stringify({objsavedata: objsavedata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        //$.unblockUI();
                        showmsg("Record Saved Successfully");
                        searchdata();
                       
                    }
                    else {
                        showerrormsg("Record Not Saved");
                        //$.unblockUI();
                    }

                    $("#btnsave").attr('disabled', false).val("Save Data");
                },
                error: function (xhr, status) {
                    showerrormsg("Error has occured Record Not saved ");
                    $("#btnsave").attr('disabled', false).val("Save Data");
                    window.status = status + "\r\n" + xhr.responseText;
                    //$.unblockUI();
                }
            });

        }

        function excelexport() {

            var centreid = jQuery('#<%=lstCentre.ClientID%>').val();
            var machineid = jQuery('#<%=lstmachine.ClientID%>').val();
            var parameter = jQuery('#<%=lstparameter.ClientID%>').val();

            if (centreid == "") {
                showerrormsg("Please Select Centre");
                return;
            }
            if (machineid == "") {
                showerrormsg("Please Select Machine");
                return;
            }
            if (parameter == "") {
                showerrormsg("Please Select Lab Observation ");
                return;
            }

            //$.blockUI();
            jQuery.ajax({
                url: "QCScheduling.aspx/binddataexcel",
                data: '{ centreid: "' + centreid + '",machineid:"' + machineid + '",parameter:"' + parameter + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var save = result.d;
                    if (save == "1") {
                        window.open('../common/ExportToExcel.aspx');
                        //$.unblockUI();
                    }
                    else {

                        showerrormsg(save);
                        //$.unblockUI();
                    }
                },

                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }
    </script>

    


</asp:Content>

