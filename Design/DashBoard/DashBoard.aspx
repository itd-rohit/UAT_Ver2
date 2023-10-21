<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DashBoard.aspx.cs" Inherits="Design_DashBoard_DashBoard" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="sc" EnablePageMethods="true" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Admin DashBoard</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option &nbsp;</div>
            <div class="row">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 2%">&nbsp;</td>
                        <td style="width: 6%">From Date</td>
                        <td style="width: 2%">:</td>
                        <td style="width: 8%">
                            <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                        </td>
                        <td style="width: 2%">&nbsp;</td>
                        <td style="width: 6%">To Date</td>
                        <td style="width: 2%">:</td>
                        <td style="width: 8%">
                            <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                        </td>
                        <td style="width: 10%">&nbsp;</td>
                        <td style="width: 36%">&nbsp;</td>
                        <td rowspan="2" style="height: 20px; width: 5%; background-color: green; text-align: center; color: white">
                            <asp:Label ID="lblTotalPatCount" runat="server" Font-Bold="true"></asp:Label>
                        </td>
                        <td style="width: 1%">&nbsp;</td>
                        <td rowspan="2" style="height: 20px; width: 5%; background-color: blue; text-align: center; color: white">
                            <asp:Label ID="lbltotalSamplEcount" runat="server" Font-Bold="true"></asp:Label></td>
                        <td style="width: 8%">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 2%">&nbsp;</td>
                        <td style="width: 6%">Centre </td>
                        <td style="width: 2%">:</td>
                        <td colspan="5" style="width: 26%">
                            <asp:ListBox ID="lstCentreList" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>
                        </td>
                       
                        <td style="width: 10%">
                            <input type="button" value="Search" onclick="$getReport()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-12 ">
                    <div class="Purchaseheader">Location Wise Grid</div>
                    <div style="width: 100%; max-height: 200px; overflow: auto">
                        <table id="tblLocationWiseDetail" style="display: none; width: 100%; border-collapse: collapse">
                            <thead>
                                <tr id="trLocationWise">
                                    <th class="GridViewHeaderStyle">Location Name</th>
                                    <th class="GridViewHeaderStyle">Patient Count</th>
                                    <th class="GridViewHeaderStyle">Test Count</th>
                                    <th class="GridViewHeaderStyle">Gross Amt.</th>
                                    <th class="GridViewHeaderStyle">Disc Amt.</th>
                                    <th class="GridViewHeaderStyle">Net Revenue</th>
                                    <th class="GridViewHeaderStyle">Recieved Amt.</th>
                                    <th class="GridViewHeaderStyle">Refund Amt.</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div style="background-color: #cacaca">&nbsp;</div>
                    <div class="Purchaseheader">Service Group Wise Grid</div>
                    <div style="width: 100%; max-height: 200px; overflow: auto">
                        <table id="tblServiceGroup" style="display: none; width: 100%; border-collapse: collapse">
                            <thead>
                                <tr id="trServiceGroup">
                                    <th class="GridViewHeaderStyle">Service Group Name</th>
                                    <th class="GridViewHeaderStyle">Test Count</th>
                                    <th class="GridViewHeaderStyle">Gross Amt.</th>
                                    <th class="GridViewHeaderStyle">Net Revenue</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div style="background-color: #cacaca">&nbsp;</div>
                    <div class="Purchaseheader">Client Wise Grid</div>
                    <div style="width: 100%; max-height: 200px; overflow: auto">
                        <table id="tblClientWise" style="display: none; width: 100%; border-collapse: collapse">
                            <thead>
                                <tr id="trClientWis">
                                    <th class="GridViewHeaderStyle">Client Name</th>
                                    <th class="GridViewHeaderStyle">Test Count</th>
                                    <th class="GridViewHeaderStyle">Gross Amt.</th>
                                    <th class="GridViewHeaderStyle">Disc Amt.</th>
                                    <th class="GridViewHeaderStyle">Net Revenue</th>
                                    <th class="GridViewHeaderStyle">Received Amt.</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-12 ">
                    <div class="Purchaseheader">Report Data</div>
                    <div style="width: 100%; max-height: 600px; overflow: auto">
                        <table id="tblReport" style="display: none; width: 100%; border-collapse: collapse">
                            <thead>
                                <tr id="trReport">
                                    <th class="GridViewHeaderStyle">Service Group</th>
                                    <th class="GridViewHeaderStyle">Test Count</th>
                                    <th class="GridViewHeaderStyle">Net Revenue</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
       
        var TagBusinessUnitID = [];
        $getReport = function () {
            var TagBusinessLabID = jQuery('#lstCentreList').multipleSelect("getSelects").join();
            //if (TagBusinessLabID == "") {
            //    toast('Error', 'Please Select TagBusinessLabID');
            //    return;
            //}
            jQuery('#lblTotalPatCount,#lbltotalSamplEcount').text('');
            jQuery('#tblLocationWiseDetail tr').slice(1).remove();
            jQuery('#tblReport tr').slice(1).remove();
            jQuery('#tblServiceGroup tr').slice(1).remove();
            jQuery('#tblClientWise tr').slice(1).remove();
            serverCall('DashBoard.aspx/GetLocationWiseReport', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    jQuery('#lblTotalPatCount').html($responseData.PtCount);
                    jQuery('#lbltotalSamplEcount').html($responseData.TestCount);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1)
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdTagBusinessUnit">');
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("<a style='cursor:pointer' onclick='return $getLocationWiseDetail(this)'>");
                        $Tr.push(ItemData[i].TagBusinessUnit);
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("</a>");
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Pt_Count); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TotalReceivedAmount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].RefundAmt); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdTagBusinessLabID">'); $Tr.push(ItemData[i].TagBusinessLabID); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblLocationWiseDetail tbody').append($Tr);
                    }
                    jQuery("#tblLocationWiseDetail").tableHeadFixer({
                    });
                    jQuery("#tblLocationWiseDetail").show();
                }
                else {
                    var $Tr = [];
                    $Tr.push("<tr> ");
                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;color:red;font-size:14px;font-weight:bold" colspan="7">'); $Tr.push($responseData.response); $Tr.push('</td>');
                    $Tr.push('</tr>');
                    $Tr = $Tr.join("");
                    jQuery('#tblLocationWiseDetail tbody').append($Tr);
                    jQuery("#tblLocationWiseDetail").show();
                }
            });
            serverCall('DashBoard.aspx/GetReport', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                TagBusinessUnitID = []
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1)
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;"');
                        else if (ItemData[i].IsTotal == 2)
                            $Tr.push(' style="background-color:blue;color:#fff;font-weight:bold;"');
                        $Tr.push(">");
                        if (ItemData[i].IsTagLab == 1) {
                            $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;font-size:12px;background-color:#d8d8d8" colspan="3">');
                            $Tr.push(ItemData[i].SubCategoryName);
                        }
                        else {
                            $Tr.push('<td class="GridViewLabItemStyle" id="tdSubCategoryName">');
                            if (ItemData[i].IsTotal == 0)
                                $Tr.push("<a style='cursor:pointer' onclick='return $getDepartmentDetail(this)'>");
                            $Tr.push(ItemData[i].SubCategoryName);
                            if (ItemData[i].IsTotal == 0)
                                $Tr.push("</a>");
                            $Tr.push('</td>');
                            $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdSubCategoryID">'); $Tr.push(ItemData[i].SubCategoryID); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdTagBusinessLabID">'); $Tr.push(ItemData[i].TagBusinessLabID); $Tr.push('</td>');
                        }
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblReport tbody').append($Tr);
                    }
                    jQuery("#tblReport").tableHeadFixer({
                    });
                    jQuery("#tblReport").show();
                }
                else {
                    var $Tr = [];
                    $Tr.push("<tr> ");
                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;color:red;font-size:14px;font-weight:bold" colspan="4">'); $Tr.push($responseData.response); $Tr.push('</td>');
                    $Tr.push('</tr>');
                    $Tr = $Tr.join("");
                    jQuery('#tblReport tbody').append($Tr);
                    jQuery("#tblReport").show();
                }
            });
            serverCall('DashBoard.aspx/ServiceGroup', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdSubCategoryName">');
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("<a style='cursor:pointer' onclick='return $getServiceGroupDetail(this)'>");
                        $Tr.push(ItemData[i].SubCategoryName);
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("</a>");
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdSubCategoryID">'); $Tr.push(ItemData[i].SubCategoryID); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblServiceGroup tbody').append($Tr);
                    }
                    jQuery("#tblServiceGroup").tableHeadFixer({
                    });
                    jQuery("#tblServiceGroup").show();
                }
                else {
                    var $Tr = [];
                    $Tr.push("<tr> ");
                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;color:red;font-size:14px;font-weight:bold" colspan="4">'); $Tr.push($responseData.response); $Tr.push('</td>');
                    $Tr.push('</tr>');
                    $Tr = $Tr.join("");
                    jQuery('#tblServiceGroup tbody').append($Tr);
                    jQuery("#tblServiceGroup").show();
                }
            });
            serverCall('DashBoard.aspx/GetClientWiseReport', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdClientName"> ');
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("<a style='cursor:pointer' onclick='return $getClientDetail(this)'>");
                        $Tr.push(ItemData[i].ClientName);
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("</a>");
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TotalReceivedAmount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdPanel_ID">'); $Tr.push(ItemData[i].Panel_ID); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblClientWise tbody').append($Tr);
                    }
                    jQuery("#tblClientWise").tableHeadFixer({
                    });
                    jQuery("#tblClientWise").show();
                }
                else {
                    var $Tr = [];
                    $Tr.push("<tr> ");
                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;color:red;font-size:14px;font-weight:bold" colspan="6">'); $Tr.push($responseData.response); $Tr.push('</td>');
                    $Tr.push('</tr>');
                    $Tr = $Tr.join("");
                    jQuery('#tblClientWise tbody').append($Tr);
                    jQuery("#tblClientWise").show();
                }
            });
        }
    </script>
    <div id="divServiceGroupDetail" class="modal fade" style="overflow: auto">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 75%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">
                                <asp:Label ID="lblServiceGroupDetail" runat="server"></asp:Label></h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                                <button type="button" class="closeModel" onclick="$CloseServiceGroupDetail()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="width: 100%; max-height: 200px; overflow: auto">
                            <table id="tblServiceGroupDetail" style="width: 100%; border-collapse: collapse; text-align: left;">
                                <thead>
                                    <tr id="trServiceGroupDetail">
                                        <th class="GridViewHeaderStyle">S.No.</th>
                                        <th class="GridViewHeaderStyle">Service Name</th>
                                        <th class="GridViewHeaderStyle">Test Count</th>
                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <br />
                <div class="modal-footer " style="padding: 10px">
                    <button type="button" onclick="$CloseServiceGroupDetail()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $CloseServiceGroupDetail = function () {
            jQuery('#tblServiceGroupDetail tr').slice(1).remove();
            jQuery("#lblServiceGroupDetail").text('');
            jQuery('#divServiceGroupDetail').hideModel();
        }
        $getServiceGroupDetail = function (rowID) {
            jQuery("#lblServiceGroupDetail").text('');
            jQuery("#lblServiceGroupDetail").text(jQuery(rowID).closest("tr").find('#tdSubCategoryName').text());
            var SubCategoryID = jQuery(rowID).closest("tr").find('#tdSubCategoryID').text();
            serverCall('DashBoard.aspx/getServiceGroupDetail', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), SubCategoryID: SubCategoryID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0) 
                            $Tr.push(i + 1);
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].ItemName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblServiceGroupDetail tbody').append($Tr);
                    }
                    jQuery("#tblServiceGroupDetail").tableHeadFixer({
                    });
                    jQuery('#divServiceGroupDetail').showModel();
                }
            });
        }
    </script>
    <div id="divReportDataClientDetail" class="modal fade" style="overflow: auto">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 75%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">
                                <asp:Label ID="lblPanel_ID" runat="server" Style="display: none"></asp:Label>
                                <asp:Label ID="lblReportDataClientName" runat="server"></asp:Label></h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                                <button type="button" class="closeModel" onclick="$CloseReportDataClient()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="width: 100%; max-height: 200px; overflow: auto">
                            <table id="tblReportDataClientName" style="width: 100%; border-collapse: collapse; text-align: left;">
                                <thead>
                                    <tr id="trReportDataClientName">
                                        <th class="GridViewHeaderStyle">S.No.</th>
                                        <th class="GridViewHeaderStyle">Service Name</th>
                                        <th class="GridViewHeaderStyle">Test Count</th>
                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <br />
                <div class="modal-footer " style="padding: 10px">
                    <button type="button" onclick="$CloseReportDataClient()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $CloseReportDataClient = function () {
            jQuery('#tblReportDataClientName tr').slice(1).remove();
            jQuery("#lblReportDataClientName,#lblPanel_ID").text('');
            jQuery('#divReportDataClientDetail').hideModel();
        }
        $getClientDetail = function (rowID) {
            jQuery("#lblReportDataClientName").text('');
            jQuery("#lblReportDataClientName").text(jQuery(rowID).closest("tr").find('#tdClientName').text());
            var Panel_ID = jQuery(rowID).closest("tr").find('#tdPanel_ID').text();
            jQuery("#lblPanel_ID").text(Panel_ID);
            serverCall('DashBoard.aspx/getClientDetailReport', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), Panel_ID: Panel_ID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1)
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push(i + 1);
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdItemName">');
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("<a style='cursor:pointer' onclick='return $getClientPatientDetail(this)'>");
                        $Tr.push(ItemData[i].ItemName);
                        if (ItemData[i].IsTotal == 0)
                            $Tr.push("</a>");
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdItemID">'); $Tr.push(ItemData[i].ItemID); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblReportDataClientName tbody').append($Tr);
                    }
                    jQuery("#tblReportDataClientName").tableHeadFixer({
                    });
                    jQuery('#divReportDataClientDetail').showModel();
                }
            });
        }
    </script>
    <script type="text/javascript">
        $getClientPatientDetail = function (rowID) {
            jQuery('#tblClientPatientDetail tr').slice(1).remove();
            var ItemID = jQuery(rowID).closest("tr").find('#tdItemID').text();
            jQuery('#lblClientPatientDetail').text(jQuery(rowID).closest("tr").find('#tdItemName').text());
            serverCall('DashBoard.aspx/GetClientPatientDetail', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), Panel_ID: jQuery("#lblPanel_ID").text(), ItemID: ItemID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0) 
                            $Tr.push(i + 1);
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].BillNo); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].BillDate); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].LabNo); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $Tr.push(ItemData[i].PName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $Tr.push(ItemData[i].Gender); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblClientPatientDetail tbody').append($Tr);
                    }
                    jQuery("#tblClientPatientDetail").tableHeadFixer({
                    });
                    jQuery('#divClientPatientDetail').showModel();
                }
            });
        }
        $CloseClientPatientDetail = function () {
            jQuery('#tblReportDataPopUp tr').slice(1).remove();
            jQuery("#lblClientPatientDetail").text('');
            jQuery('#divClientPatientDetail').hideModel();
        }
    </script>
    <div id="divClientPatientDetail" class="modal fade" style="overflow: auto">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 75%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">
                                <asp:Label ID="lblClientPatientDetail" runat="server"></asp:Label></h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                                <button type="button" class="closeModel" onclick="$CloseClientPatientDetail()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="width: 100%; max-height: 200px; overflow: auto">
                            <table id="tblClientPatientDetail" style="width: 100%; border-collapse: collapse; text-align: left;">
                                <thead>
                                    <tr id="trClientPatientDetail">
                                        <th class="GridViewHeaderStyle">S.No.</th>
                                        <th class="GridViewHeaderStyle">Bill No.</th>
                                        <th class="GridViewHeaderStyle">Bill Date</th>
                                        <th class="GridViewHeaderStyle">Lab No.</th>
                                        <th class="GridViewHeaderStyle">Patient Name</th>
                                        <th class="GridViewHeaderStyle">Gender</th>
                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer " style="padding: 10px">
                    <button type="button" onclick="$CloseClientPatientDetail()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $getDepartmentDetail = function (rowID) {
            jQuery("#lblReportDataTagLab,#lblReportDataSubcategory").text('');
            jQuery('#tblReportDataPopUp tr').slice(1).remove();
            var SubCategoryID = jQuery(rowID).closest("tr").find('#tdSubCategoryID').text();
            var TagBusinessLabID = jQuery(rowID).closest("tr").find('#tdTagBusinessLabID').text();
            jQuery("#lblReportDataSubcategory").text(jQuery(rowID).closest("tr").find('#tdSubCategoryName').text());

            serverCall('DashBoard.aspx/getTagBusinessLabDepartmentDetail', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), SubCategoryID: SubCategoryID, TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        if (i == 0) 
                            jQuery("#lblReportDataTagLab").text(ItemData[i].TagBusinessUnit);
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0) 
                            $Tr.push(i + 1);
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].ItemName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblReportDataPopUp tbody').append($Tr);
                    }
                    jQuery("#tblReportDataPopUp").tableHeadFixer({
                    });
                    jQuery('#divReportData').showModel();
                }
            });
        }
        $CloseReportData = function () {
            jQuery('#tblReportDataPopUp tr').slice(1).remove();
            jQuery("#lblReportDataTagLab,#lblReportDataSubcategory").text('');
            jQuery('#divReportData').hideModel();
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) 
                $addHandler(document, "keydown", onKeyDown);            
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divReportData').is(':visible')) 
                    $CloseReportData();
                else if (jQuery('#divReportDataClientDetail').is(':visible')) 
                    $CloseReportDataClient();
                else if (jQuery('#divServiceGroupDetail').is(':visible')) 
                    $CloseServiceGroupDetail();
                else if (jQuery('#divLocationWise').is(':visible')) 
                    $CloseLocationWise();
                else if (jQuery('#divClientPatientDetail').is(':visible')) 
                    $CloseClientPatientDetail();                
            }
        }
    </script>
    <div id="divReportData" class="modal fade" style="overflow: auto">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 75%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">
                                <asp:Label ID="lblReportDataTagLab" runat="server"></asp:Label></h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                                <button type="button" class="closeModel" onclick="$CloseReportData()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Service Group</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lblReportDataSubcategory" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div style="width: 100%; max-height: 200px; overflow: auto">
                            <table id="tblReportDataPopUp" style="width: 100%; border-collapse: collapse; text-align: left;">
                                <thead>
                                    <tr id="trReportDataPopUp">
                                        <th class="GridViewHeaderStyle">S.No.</th>
                                        <th class="GridViewHeaderStyle">Service Name</th>
                                        <th class="GridViewHeaderStyle">Test Count</th>
                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <br />
                <div class="modal-footer " style="padding: 10px">
                    <button type="button" onclick="$CloseReportData()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $CloseLocationWise = function () {
            jQuery('#tblLocationWise tr').slice(1).remove();
            jQuery("#lblLocationWise").text('');
            jQuery('#divLocationWise').hideModel();
        }
        function clientActiveTabChanged(sender, args) {
            var selectedTab = sender.get_tabs()[sender.get_activeTabIndex()]._tab;
            jQuery('#tblLocationWiseClient tr').slice(1).remove();
            jQuery('#tblLocationWiseDepartment tr').slice(1).remove();
            var tabText = selectedTab.childNodes[0].childNodes[0].childNodes[0].innerHTML;
            if (sender.get_activeTabIndex() == 0) {
                GetLocationWiseClientDetail(jQuery('#lblTagBusinessLabID').text());
            }
            else if (sender.get_activeTabIndex() == 1) {
                GetLocationWiseDetailDepartment(jQuery('#lblTagBusinessLabID').text());
            }
        }
        function SetActiveTab(tabControl, tabNumber) {
            var ctrl = $find(tabControl);
            ctrl.set_activeTab(ctrl.get_tabs()[tabNumber]);
        }
        $getLocationWiseDetail = function (rowID) {
            jQuery("#lblLocationWise").text('');
            jQuery('#tblLocationWiseClient tr').slice(1).remove();
            jQuery('#tblLocationWiseDepartment tr').slice(1).remove();
            var TagBusinessLabID = jQuery(rowID).closest("tr").find('#tdTagBusinessLabID').text();
            jQuery('#lblTagBusinessLabID').text(TagBusinessLabID);
            jQuery("#lblLocationWise").text(jQuery(rowID).closest("tr").find('#tdTagBusinessUnit').text());
            SetActiveTab('<%=tabHeader.ClientID%>', 0);
            GetLocationWiseClientDetail(TagBusinessLabID);
        }
        GetLocationWiseClientDetail = function (TagBusinessLabID) {
            jQuery('#tblLocationWiseClient tr').slice(1).remove();
            serverCall('DashBoard.aspx/GetLocationWiseClientDetail', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0) 
                            $Tr.push(i + 1);
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].ClientName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblLocationWiseClient tbody').append($Tr);
                    }
                    jQuery("#tblLocationWiseClient").tableHeadFixer({
                    });
                    jQuery('#divLocationWise').showModel();
                }
            });
        }
        GetLocationWiseDetailDepartment = function (TagBusinessLabID) {
            jQuery('#tblLocationWiseDepartment tr').slice(1).remove();
            serverCall('DashBoard.aspx/GetLocationWiseDetailDepartment', { fromDate: jQuery("#txtFromDate").val(), toDate: jQuery("#txtToDate").val(), TagBusinessLabID: TagBusinessLabID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ItemData = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr ");
                        if (ItemData[i].IsTotal == 1) 
                            $Tr.push(' style="background-color:#4CAF50;color:#fff;font-weight:bold;font-size:12px;"');
                        $Tr.push(">");
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].IsTotal == 0) 
                            $Tr.push(i + 1);
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(ItemData[i].SubCategoryName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].TestCount); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].GrossSales); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].Disc); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(ItemData[i].NetSales); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        jQuery('#tblLocationWiseDepartment tbody').append($Tr);
                    }
                    jQuery("#tblLocationWiseDepartment").tableHeadFixer({
                    });
                    jQuery('#divLocationWise').showModel();
                }
            });
        }
    </script>
    <div id="divLocationWise" class="modal fade" style="overflow: auto">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 75%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">
                                <asp:Label ID="lblTagBusinessLabID" runat="server" Style="display: none"></asp:Label>
                                <asp:Label ID="lblLocationWise" runat="server"></asp:Label></h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                                <button type="button" class="closeModel" onclick="$CloseLocationWise()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <cc1:TabContainer ID="tabHeader" runat="server" OnClientActiveTabChanged="clientActiveTabChanged" ActiveTabIndex="0">
                            <cc1:TabPanel runat="server" HeaderText="Client" ID="tabClient" BackColor="#d7edff">
                                <ContentTemplate>
                                    <div class="row">
                                        <div style="width: 100%; max-height: 200px; overflow: auto">
                                            <table id="tblLocationWiseClient" style="width: 100%; border-collapse: collapse; text-align: left;">
                                                <thead>
                                                    <tr id="trLocationWisePopUpClient">
                                                        <th class="GridViewHeaderStyle">S.No.</th>
                                                        <th class="GridViewHeaderStyle">Client Name</th>
                                                        <th class="GridViewHeaderStyle">Test Count</th>
                                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </cc1:TabPanel>
                            <cc1:TabPanel ID="tabDepartment" runat="server" HeaderText="Department" BackColor="#d7edff">
                                <ContentTemplate>
                                    <div class="row">
                                        <div style="width: 100%; max-height: 200px; overflow: auto">
                                            <table id="tblLocationWiseDepartment" style="width: 100%; border-collapse: collapse; text-align: left;">
                                                <thead>
                                                    <tr id="trLocationWiseDepartment">
                                                        <th class="GridViewHeaderStyle">S.No.</th>
                                                        <th class="GridViewHeaderStyle">Service Name</th>
                                                        <th class="GridViewHeaderStyle">Test Count</th>
                                                        <th class="GridViewHeaderStyle">Gross Amt.</th>
                                                        <th class="GridViewHeaderStyle">Disc Amt.</th>
                                                        <th class="GridViewHeaderStyle">Net Revenue</th>
                                                    </tr>
                                                </thead>
                                                <tbody></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </cc1:TabPanel>
                        </cc1:TabContainer>
                    </div>
                </div>
                <br />
                <div class="modal-footer " style="padding: 10px">
                    <button type="button" onclick="$CloseLocationWise()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <style>
        a:link {
            color: green;
            background-color: transparent;
            text-decoration: none;
        }
        a:visited {
            color: pink;
            background-color: transparent;
            text-decoration: none;
        }
        a:hover {
            color: red;
            background-color: transparent;
            text-decoration: underline;
            font-weight: bold;
        }
        a:active {
            color: yellow;
            background-color: transparent;
            text-decoration: underline;
        }
        .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
            height: 20px !important;
        }
    </style>
    <script type="text/javascript">
        jQuery(function () {
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
            jQuery('[id*=lstCentreList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
    </script>
</asp:Content>

