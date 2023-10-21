<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomeCollectionHistory.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionHistory" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <title></title>
    <style type="text/css">
        #popup_box2 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 200px;
            width: 600px;
            background-color: #d7edff;
            left: 25%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            border-radius: 5px;
        }

        #popup_box4 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 100px;
            width: 430px;
            background-color: #d7edff;
            left: 25%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sm1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="height: 560px;">
            <div class="POuter_Box_Inventory">
                <b>Home Collection History of <span id="pdetail"></span></b>
                <asp:TextBox ID="txtpid" runat="server" Style="display: none;" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">

                    <div class="row">
                        <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white; cursor: pointer;"
                            onclick="searchdata('Pending')">
                        </div>
                        <div class="col-md-2">
                            Pending
                        </div>
                        <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: deepskyblue; cursor: pointer;"
                            onclick="searchdata('DoorLock')">
                        </div>
                        <div class="col-md-2">
                            DoorLock
                        </div>
                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: mediumpurple; cursor: pointer;"
                            onclick="searchdata('RescheduleRequest')">
                        </div>

                        <div class="col-md-2">
                            Reschedule Request
                        </div>
                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink; cursor: pointer;"
                            onclick="searchdata('CancelRequest')">
                        </div>


                        <div class="col-md-2">
                            Cancel Request
                        </div>
                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightblue; cursor: pointer;"
                            onclick="searchdata('Rescheduled')">
                        </div>


                        <div class="col-md-2">
                            Rescheduled
                        </div>
                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow; cursor: pointer;"
                            onclick="searchdata('CheckIn')">
                        </div>
                        <div class="col-md-2">
                            CheckIn
                        </div>

                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen; cursor: pointer;"
                            onclick="searchdata('Completed')">
                        </div>
                        <div class="col-md-2">
                            Completed
                        </div>

                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: aqua; cursor: pointer;"
                            onclick="searchdata('BookingCompleted')">
                        </div>
                        <div class="col-md-3">
                            Booking Completed
                        </div>
                        <div class="col-md-1" style="width: 15px;height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: hotpink; cursor: pointer;"
                            onclick="searchdata('Canceled')">
                        </div>

                        <div class="col-md-2">
                            Canceled
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div style="max-height: 495px; overflow: auto;">

                        <table id="tbl" style="width: 99%; border-collapse: collapse; text-align: left;">
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="popup_box4">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox4()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />
            <div class="Purchaseheader">
                Cancel Appointment
            </div>
             <div class="row">
                 <div class="col-md-4">
                    <label class="pull-left">
                        PreBookingID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-20">
                      <input type="text" id="txtcancelpre" readonly="readonly" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" />
                  </div>
                 </div>
           <div class="row">
                 <div class="col-md-4">
                    <label class="pull-left">
                        AppointmentDate
                    </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-20">
                      <input type="text" id="txtcancelpre2" readonly="readonly" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" />
                       </div>
                 </div>
                      <div class="row">
                 <div class="col-md-4">
                    <label class="pull-left">
                        Cancel Reason
                    </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-20">
                      <input type="text"  maxlength="200" id="txtcancelreason" />
                       </div>
                 </div>
            
           <div class="row" style="text-align:center">
                <input type="button" value="Cancel" class="resetbutton" onclick="cancelappnow()" />
              
            </div>
        </div>

        <div id="popup_box2">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox1()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

            <div class="POuter_Box_Inventory" style="width: 600px;" id="Div1">
                <div class="Purchaseheader">
                    Reschedule Appointment
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Prebooking ID
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:Label ID="lbhcidre" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Prebooking ID
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Appointment Date Time
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:Label ID="lbappdatere" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Route
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:Label ID="lbrequestedroute" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            DropLocation
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:Label ID="lbrequesteddroplocation" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Phlebotomist Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20">
                        <asp:DropDownList ID="ddlphlebonew" runat="server" onchange="getslot()"></asp:DropDownList>
                        <asp:Label ID="lbphlebore" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
                        <asp:Label ID="lbphleboreid" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            New Appointment Date Time
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:TextBox ID="txtappdatere" runat="server" ReadOnly="true" onchange="getslot()"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txtappdatere" Format="dd-MMM-yyyy" PopupButtonID="txtappdatere" />
                        <div class="col-md-10">
                            <asp:DropDownList ID="ddlapptimere" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" value="Reschedule" class="savebutton" onclick="RescheduleNow()" />
                </div>

            </div>
        </div>
    </form>

    <script type="text/javascript">
        $(function () {
            $("#Pbody_box_inventory").css('margin-top', 0);
            gethistory();
        });
        function gethistory() {
            $('#tbl tr').remove();
            serverCall('HomeCollectionHistory.aspx/gethistory', { pid: $('#<%=txtpid.ClientID%>').val() }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast("Info", "No Home Collection History Found");
                }
                else {
                    var mydata = [];
                    $('#pdetail').html(ItemData[0].patientname + " ( " + ItemData[0].PMobile + " )");
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var color = "";
                        if (ItemData[i].cstatus == "Pending") {
                            color = "white";
                        }
                        if (ItemData[i].cstatus == "CheckIn") {
                            color = "yellow";
                        }
                        if (ItemData[i].cstatus == "Completed") {
                            color = "lightgreen";
                        }
                        if (ItemData[i].cstatus == "BookingCompleted") {
                            color = "aqua";
                        }
                        if (ItemData[i].cstatus == "Canceled") {
                            color = "hotpink";
                        }
                        if (ItemData[i].cstatus == "Rescheduled") {
                            color = "lightblue";
                        }
                        if (ItemData[i].cstatus == "DoorLock") {
                            color = "deepskyblue";
                        }
                        if (ItemData[i].cstatus == "RescheduleRequest") {
                            color = "mediumpurple";
                        }
                        if (ItemData[i].cstatus == "CancelRequest") {
                            color = "pink";
                        }
                        var $mydata = [];
                        $mydata.push("<tr  id='"); $mydata.push(ItemData[i].prebookingid); $mydata.push("'>");
                        $mydata.push('<td>');
                        $mydata.push('<div style="padding-top:5px;padding-bottom:5px;border:1px solid blue;">');

                        $mydata.push('<table style="width:100%;border:1px solid lightblue;background-color:'); $mydata.push(color); $mydata.push('" frame="box" rules="all" >');
                     
 if (ItemData[i].cstatus == "Pending" || ItemData[i].cstatus == "Rescheduled") {
                            $mydata.push('<tr><td colspan="8" style="text-align:center;">');
                            $mydata.push('<input type="button" class="resetbutton" value="Cancel" onclick="cancelapp(\''); $mydata.push(ItemData[i].prebookingid); $mydata.push('\',\''); $mydata.push(ItemData[i].appdate); $mydata.push('\')" />');
                            $mydata.push('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="savebutton" value="Edit" onclick="editappointment(\''); $mydata.push(ItemData[i].prebookingid); $mydata.push('\',\''); $mydata.push(ItemData[i].Patient_ID); $mydata.push('\')" />');
                            $mydata.push('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="searchbutton" value="Reschedule" onclick="resheduleappointment(\''); $mydata.push(ItemData[i].prebookingid); $mydata.push('\',\''); $mydata.push(ItemData[i].PhlebotomistID); $mydata.push('\',\''); $mydata.push(ItemData[i].appdate); $mydata.push('\',\''); $mydata.push(ItemData[i].RouteName); $mydata.push('\',\''); $mydata.push(ItemData[i].centre); $mydata.push('\')" />');
                            $mydata.push('</td></tr>');
                        }
                        $mydata.push('<tr style="height:25px;"><td style="background-color: blanchedalmond;">CreateDate</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].EntryDateTime); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">CreateBy</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].EntryByName); $mydata.push('</td>)');
                        $mydata.push('<td style="background-color: blanchedalmond;">AppDate</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].appdate); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">PrebookingID</td><td style="font-weight:bold;" valign="top"><span id="spid">'); $mydata.push(ItemData[i].prebookingid); $mydata.push('</span>');
                        if ('<%=UserInfo.RoleID.ToString()%>' != "253") {
                            $mydata.push('<span title="Click To View Happy Delivery Code" id="btcode" style="cursor:pointer;float:right;font-weight:bold;background-color: blue;color: white;" onclick="viewcode(this)">Show Happy Code</span><span title="Click To Hide Happy Delivery Code" style="display:none;float:right;cursor:pointer;font-weight:bold;background-color: black;color: white;" id="spcode" onclick="hidecode(this)">'); $mydata.push(ItemData[i].VerificationCode); $mydata.push('</span></td>');
                        }
                        $mydata.push('</tr>');
                        $mydata.push('<tr><td style="background-color: blanchedalmond;">UHID</td><td>'); $mydata.push(ItemData[i].Patient_ID); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">Phelbo</td><td>'); $mydata.push(ItemData[i].phleboname); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">PhleboMobile</td><td>'); $mydata.push(ItemData[i].PMobile); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">Centre</td><td>'); $mydata.push(ItemData[i].centre); $mydata.push('</td>')
                        $mydata.push('</tr>');
                        $mydata.push('<tr><td style="background-color: blanchedalmond;">Status</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].cstatus); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">VisitID</td><td>'); $mydata.push(ItemData[i].visitid); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">PatientRating</td>');
                        if (ItemData[i].patientrating != "0") {
                            $mydata.push('<td  style="background-color: gray;" >');
                            for (var a = 1; a <= ItemData[i].patientrating ; a++) {
                                $mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                            $mydata.push('</td>');
                        }
                        else {
                            $mydata.push('<td></td>');
                        }

                        $mydata.push('<td style="background-color: blanchedalmond;">PhelboRating</td>');
                        if (ItemData[i].phelborating != "0") {
                            $mydata.push('<td  style="background-color: gray;" >');
                            for (var a = 1; a <= ItemData[i].phelborating ; a++) {
                                $mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                            $mydata.push('</td>');
                        }
                        else {
                            $mydata.push('<td></td>');
                        }
                        $mydata.push('</tr>');

                        $mydata.push('<tr><td style="background-color: blanchedalmond;">PatientFeedback</td><td colspan="3">'); $mydata.push(ItemData[i].PatientFeedback); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">PhelboFeedback</td><td colspan="3">'); $mydata.push(ItemData[i].phelbofeedback); $mydata.push('</td>');
                        $mydata.push('</tr>');
                        $mydata.push('<tr><td style="background-color: blanchedalmond;">Test</td><td colspan="7">'); $mydata.push(ItemData[i].testname); $mydata.push('</td>');
                        $mydata.push('</tr>');
                        $mydata.push('<tr><td style="background-color: blanchedalmond;">GrossAmt</td><td>'); $mydata.push(ItemData[i].Rate); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">DiscAmt</td><td>'); $mydata.push(ItemData[i].discamt); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">NetAmt</td><td>'); $mydata.push(ItemData[i].netamt); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">PaymentMode</td><td>'); $mydata.push(ItemData[i].PaymentMode); $mydata.push('</td>');
                        $mydata.push('</tr>');
                        $mydata.push('<tr><td style="background-color: blanchedalmond;">CheckInDate</td><td>'); $mydata.push(ItemData[i].checkindatetime); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">CompletedDate</td><td>'); $mydata.push(ItemData[i].bookeddate); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">BookingDate</td><td>'); $mydata.push(ItemData[i].finaldonedate); $mydata.push('</td>');
                        $mydata.push('<td style="background-color: blanchedalmond;">Images</td>');
                        $mydata.push('<td>');
                        if (ItemData[i].filename != "") {
                            for (var c = 0; c <= ItemData[i].filename.split(',').length - 1; c++) {
                                $mydata.push('<img onclick="openmyimage(\''); $mydata.push(ItemData[i].filename.split(',')[c].split('#')[0]); $mydata.push('\')" style="cursor:pointer;" src="../../App_Images/view.gif" title="'); $mydata.push(ItemData[i].filename.split(',')[c].split('#')[1]); $mydata.push('"/>&nbsp;&nbsp;');
                            }
                        }
                        $mydata.push('<input type="button" value="View Log" style="font-weight:bold;cursor:pointer;float:right;" onclick="openlogbox(\''); $mydata.push(ItemData[i].prebookingid); $mydata.push('\')" /></td>');
                        $mydata.push('</tr>');

                        if (ItemData[i].cstatus == "Canceled") {
                            $mydata.push('<tr><td style="background-color: blanchedalmond;">Cancel Date</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].canceldatetime); $mydata.push('</td>');
                            $mydata.push('<td style="background-color: blanchedalmond;">Cancel By</td><td style="font-weight:bold;">'); $mydata.push(ItemData[i].cancelbyname); $mydata.push('</td>');
                            $mydata.push('<td style="background-color: blanchedalmond;">Cancel Reason</td><td colspan="3" style="font-weight:bold;">'); $mydata.push(ItemData[i].CancelReason); $mydata.push('</td>');
                            $mydata.push('</tr>');
                        }
                        $mydata.push('</table></div>');
                        $mydata.push('</td></tr>');
                        $mydata = $mydata.join("");

                        mydata.push($mydata);
                    }
                    $('#tbl').append(mydata);
                }
            });
        }
        function viewcode(ctrl) {
            $(ctrl).hide('slow');
            $(ctrl).closest('tr').find("#spcode").show('slow');
            serverCall('HomeCollectionHistory.aspx/SaveCodeLog', { pid: $(ctrl).closest('tr').find("#spid").html() }, function (result) {

            });

        }
        function hidecode(ctrl) {
            $(ctrl).hide('slow');
            $(ctrl).closest('tr').find("#btcode").show('slow');
        }

        function openlogbox(ctrl) {
            openmypopup("HomeCollectionLog.aspx?prebookingid=" + ctrl);
        }
        function openmypopup(href) {
            var width = '720px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '500px',
                'min-height': '500px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function openmyimage(id) {
            openmypopup("ViewHCImage.aspx?id=" + id);
        }
        function unloadPopupBox4() {
            $('#popup_box4').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
        function cancelapp(prebookingid, appdate) {
            $('#txtcancelpre').val(prebookingid);
            $('#txtcancelpre2').val(appdate);
            $('#txtcancelreason').val('');
            $('#popup_box4').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
        }
        function cancelappnow() {
            if ($('#txtcancelreason').val() == "") {
                toast("Error", "Please Enter Cancel Reason");
                return;
            }
            serverCall('HomeCollection.aspx/CancelAppointment', { appid: $('#txtcancelpre').val(), reason: $('#txtcancelreason').val() }, function (result) {
                if (result == "1") {
                    toast("Success", "Appointment Cancel");
                    $('#popup_box4').fadeOut("slow");
                    $("#Pbody_box_inventory").css({
                        "opacity": "1"
                    });
                    gethistory();
                }
            });
        }
        function openmypopup1(href) {
            var width = '1300px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '900px',
                'min-height': '900px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function editappointment(prebookingid, patientid) {
            openmypopup1('HomeCollection.aspx?UHID=' + patientid + '&prebookingid=' + prebookingid + '&type=1');
        }
    </script>
    <script type="text/javascript">
        function unloadPopupBox1() {
            $('#popup_box2').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
        function resheduleappointment(prebookingid, phelbotomistid, appdate, route, droplocation) {
            $('#<%=lbhcidre.ClientID%>').text(prebookingid);
            $('#<%=lbappdatere.ClientID%>').text(appdate);
            $('#<%=lbphleboreid.ClientID%>').text(phelbotomistid);
            $('#<%=txtappdatere.ClientID%>').val(appdate.split(' ')[0]);
            $('#<%=lbrequestedroute.ClientID%>').text(route);
            $('#<%=lbrequesteddroplocation.ClientID%>').text(droplocation);
            $('#popup_box2').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            getphelbotomist();
            getslot();
        }
        function getphelbotomist() {
            jQuery('#<%=ddlphlebonew.ClientID%> option').remove();
            serverCall('HomeCollection.aspx/getphelbotomistlist', { prebookingid: $('#<%=lbhcidre.ClientID%>').text() }, function (result) {
                centreData = $.parseJSON(result);
                for (i = 0; i < centreData.length; i++) {
                    jQuery("#<%=ddlphlebonew.ClientID%>").append(jQuery("<option></option>").val(centreData[i].PhlebotomistID).html(centreData[i].Name));
                }
                jQuery("#<%=ddlphlebonew.ClientID%>").val($('#<%=lbphleboreid.ClientID%>').text());
            });
        }
        function getslot() {
            jQuery('#<%=ddlapptimere.ClientID%> option').remove();
            serverCall('HomeCollection.aspx/getslot', { prebookingid: $('#<%=lbhcidre.ClientID%>').text(), appdate: $('#<%=txtappdatere.ClientID%>').val(), phelbotomist: $('#<%=ddlphlebonew.ClientID%>').val(), oldphelbo: $('#<%=lbphleboreid.ClientID%>').text() }, function (result) {
                centreData = $.parseJSON(result);
                jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Slot"));
                for (i = 0; i < centreData.length; i++) {
                    if (parseInt(centreData[i].isbooked) == 0) {
                        jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option></option>").val(centreData[i].Timeslot).html(centreData[i].Timeslot));
                    }
                    else {
                        jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option disabled></option>").val(centreData[i].Timeslot).html(centreData[i].Timeslot));
                    }
                }
            });
        }
        function RescheduleNow() {
            if ($('#<%=ddlapptimere.ClientID%>').val() == "0") {
                 $('#<%=ddlapptimere.ClientID%>').focus();
                 toast("Error", "Please Select Appointment Time");
                 return;
             }
             savereschedule($('#<%=lbhcidre.ClientID%>').text(), $('#<%=txtappdatere.ClientID%>').val(), $('#<%=ddlapptimere.ClientID%>').val(), $('#<%=ddlphlebonew.ClientID%>').val());
         }
         function savereschedule(prebookingid, appdate, apptime, phelbotomistid) {
             serverCall('HomeCollection.aspx/RescheduleNow', { prebookingid: prebookingid, appdate: appdate, apptime: apptime, phelbotomistid: phelbotomistid }, function (result) {
                 if (result == "1") {
                     toast("Success", "Appointment Rescheduled ");
                     $('#popup_box2').fadeOut("slow");
                     $("#Pbody_box_inventory").css({
                         "opacity": "1"
                     });
                     gethistory();
                 }
                 else {
                     toast("Error", result.d);
                 }
             });
         }
    </script>
</body>
</html>
