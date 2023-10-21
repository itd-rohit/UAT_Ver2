<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Homecollection_RatingReport.aspx.cs" Inherits="Design_HomeCollection_Homecollection_RatingReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />


    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <style type="text/css">
        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            width: 1285px;
            left: 1%;
            top: 12%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #d7edff;
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
    </style>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>Home Collection Rating Search</strong>
        </div>


        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>From Date </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left"><b>To Date </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-1">
                    <input type="button" value="More Filter" onclick="showmore()" style="font-weight: 700; cursor: pointer; display: none;" />

                </div>
                 <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Mobile No. </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" MaxLength="10" TabIndex="3"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                    </cc1:FilteredTextBoxExtender>
                </div>
            </div>

            <div class="row" id="more" runat="server">
                <div class="col-md-3">
                    <label class="pull-left"><b>State </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlstate" runat="server" onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>City </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcity" runat="server" onchange="bindLocality()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Area </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlarea" runat="server" TabIndex="11" onchange="bindpincode()" class="ddlarea chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-2" style="display: none">
                    <label class="pull-left"><b>Pincode </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2" style="display: none">
                    <asp:TextBox ID="txtpincode" runat="server" MaxLength="6"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                    </cc1:FilteredTextBoxExtender>
                </div>
            </div>

            <div class="row more">
                <div class="col-md-3">
                    <label class="pull-left"><b>Drop Location </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcentre" runat="server" TabIndex="11" class="ddlcentre chosen-select chosen-container"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left"><b>Phelbo </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlphelbo" runat="server" TabIndex="11" class="ddlphelbo chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Patient Name </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtpname" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>Patient Rating </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPatientRating" runat="server" TabIndex="11" class="ddlphelbo chosen-select chosen-container">
                        <asp:ListItem Value="0">-Select-</asp:ListItem>
                        <asp:ListItem Value="5">5</asp:ListItem>
                        <asp:ListItem Value="4">4</asp:ListItem>
                        <asp:ListItem Value="3">3</asp:ListItem>
                        <asp:ListItem Value="2">2</asp:ListItem>
                        <asp:ListItem Value="1">1</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" value="Search" class="searchbutton" onclick="searchdata('')" />
                <input type="button" value="Export To Excel" class="searchbutton" onclick="GetReportExcel()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-1" style="width: 20px;height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen; cursor: pointer;">
                    </div>
                    <div class="col-md-5">More than and Equal 3 stars</div>
                    <div class="col-md-1" style="width: 20px;height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink; cursor: pointer;">
                    </div>
                    <div class="col-md-3">
                        Less than 3 stars
                    </div>
                </div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
        <div class="row">
            <div style="max-height: 380px; overflow: auto;">
                <table id="tbl" style="width: 100%; border-collapse: collapse;">
                    <tr id="trheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">AppDate</td>
                        <td class="GridViewHeaderStyle">MobileNo</td>
                        <td class="GridViewHeaderStyle">PatientName</td>
                        <td class="GridViewHeaderStyle">State</td>
                        <td class="GridViewHeaderStyle">City</td>
                        <td class="GridViewHeaderStyle">Area</td>
                        <td class="GridViewHeaderStyle">Pincode</td>
                        <td class="GridViewHeaderStyle">Phelbo</td>
                        <td class="GridViewHeaderStyle">Phelbo Mo</td>
                        <td class="GridViewHeaderStyle">DropLocation</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">PatientRating</td>
                        <td class="GridViewHeaderStyle">Patient Feedbacks</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">PhelboRating</td>
                        <td class="GridViewHeaderStyle">Phelbo Feedbacks</td>
                    </tr>
                </table>
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
        });

    </script>

    <script type="text/javascript">
        function bindCity(con) {

            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: jQuery('#<%=ddlstate.ClientID%>').val() },function (result) {
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
        function bindLocality() {
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                }
                else {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < localityData.length; i++) {
                        jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                    }
                }
                $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
            });
        }

        function bindpincode() {
            jQuery('#<%=txtpincode.ClientID%>').val('');
            serverCall('customercare.aspx/bindpincode', { LocalityID: jQuery('#<%=ddlarea.ClientID%>').val() }, function (result) {
                pincode = result;
                if (pincode == "") {
                    jQuery('#<%=txtpincode.ClientID%>').val('').attr('readonly', false);
                }
                else {
                    jQuery('#<%=txtpincode.ClientID%>').val(pincode).attr('readonly', true);
                }
                bindcentre();
            });
        }
        function bindcentre() {
            jQuery('#<%=ddlcentre.ClientID%> option').remove();
            $('#<%=ddlcentre.ClientID%>').trigger('chosen:updated');
            serverCall('Homecollection_RatingReport.aspx/bindcentre', { areaid: jQuery('#<%=ddlarea.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Drop Location Found---"));
                }
                else {
                    jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < localityData.length; i++) {
                        jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val(localityData[i].droplocationid).html(localityData[i].centre));
                    }
                }
                $('#<%=ddlcentre.ClientID%>').trigger('chosen:updated');
                bindphelbo();
            });

        }


        function bindphelbo() {

            jQuery('#<%=ddlphelbo.ClientID%> option').remove();
            $('#<%=ddlphelbo.ClientID%>').trigger('chosen:updated');
            serverCall('Homecollection_RatingReport.aspx/bindphelbo', { areaid: jQuery('#<%=ddlarea.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                }

                else {
                    jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < localityData.length; i++) {
                        jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val(localityData[i].PhlebotomistID).html(localityData[i].name));
                    }
                }
                $('#<%=ddlphelbo.ClientID%>').trigger('chosen:updated');
            });
        }       
    </script>
    <script type="text/javascript">
        function searchdata(status) {
            $('#tbl tr').slice(1).remove();
            serverCall('Homecollection_RatingReport.aspx/getdata', { fromdate: jQuery('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: $('#<%=ddlarea.ClientID%>').val(), PatientRating: $('#<%=ddlPatientRating.ClientID%>').val(), centre: $('#<%=ddlcentre.ClientID%>').val(), phelbo: $('#<%=ddlphelbo.ClientID%>').val(), mobileno: $('#<%=txtmobile.ClientID%>').val(), pname: $('#<%=txtpname.ClientID%>').val(), status: status }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast('Info',"No Home Collection Data Found");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var color = "";
                        if (ItemData[i].PatientRating >= 3) {
                            color = "lightgreen";
                        }

                        else {
                            color = "pink";
                        }
                        var $mydata = [];
                        $mydata.push("<tr style='background-color:"); $mydata.push(color); $mydata.push(";' >");
                        $mydata.push('<td class="GridViewLabItemStyle"  id="srno">'); $mydata.push(parseInt(i + 1));$mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="appdate" style="font-weight:bold;">'); $mydata.push(ItemData[i].appdate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="Mobile" style="font-weight:bold;">'); $mydata.push(ItemData[i].MobileNo); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="patientname" style="font-weight:bold;">' ); $mydata.push(ItemData[i].PatientName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;"  id="state" >'); $mydata.push(ItemData[i].State); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="city" style="font-weight:bold;">' ); $mydata.push(ItemData[i].City); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;"  id="locality">'); $mydata.push(ItemData[i].locality); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="pincode" style="font-weight:bold;">'); $mydata.push(ItemData[i].Pincode); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="phleboname" style="font-weight:bold;">'); $mydata.push(ItemData[i].phleboname); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="phlebomobile" style="font-weight:bold;">'); $mydata.push(ItemData[i].PMobile); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;"  id="centre">'); $mydata.push(ItemData[i].Centre); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="PatientRating" style="background-color:black;">');
                        for (var a = 1; a <= ItemData[i].PatientRating ; a++) {
                            $mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                        }
                        $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="PatientFeedback">'); $mydata.push(ItemData[i].PatientFeedback); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="PhelboRating" style="background-color:black;">');
                        for (var a = 1; a <= ItemData[i].PhelboRating ; a++) {
                            $mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                        }
                        $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="PhelboFeedback">'); $mydata.push(ItemData[i].PhelboFeedback); $mydata.push('</td>');
                        $mydata.push("</tr>");
                        $mydata = $mydata.join("");
                        $('#tbl').append($mydata);
                    }

                }
            });         
        }
        function showmore() {
            $('.more').toggle('slow');
        }
        function GetReportExcel() {
            serverCall('Homecollection_RatingReport.aspx/exporttoexcel', { fromdate: jQuery('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: $('#<%=ddlarea.ClientID%>').val(), PatientRating: $('#<%=ddlPatientRating.ClientID%>').val(), centre: $('#<%=ddlcentre.ClientID%>').val(), phelbo: $('#<%=ddlphelbo.ClientID%>').val(), mobileno: $('#<%=txtmobile.ClientID%>').val(), pname: $('#<%=txtpname.ClientID%>').val() }, function (result) {
                ItemData = result;
                if (ItemData == "false") {
                    toast('Info',"No Item Found");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });          
        }
    </script>
</asp:Content>


