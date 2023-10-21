<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="SRAPendingList.aspx.cs" Inherits="Design_Lab_SRAPendingList" %>

<!DOCTYPE html>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="font-size: 11px;">
                <div class="row" style="margin-top: 0px;">
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left"><strong>Refresh </strong></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlrefresh" runat="server" Style="font-size: 12px;">
                                    <asp:ListItem Value="60000">1</asp:ListItem>
                                    <asp:ListItem Value="120000" Selected="True">2</asp:ListItem>
                                    <asp:ListItem Value="300000">5</asp:ListItem>
                                    <asp:ListItem Value="600000">10</asp:ListItem>
                                    <asp:ListItem Value="Stop">Stop</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left"><strong>From&nbsp;Date</strong></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:TextBox ID="txtfromdate" runat="server" Width="74px" Style="font-size: 12px;" />
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtfromdate" Format="dd-MMM-yyyy" PopupButtonID="txtfromdate"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><strong>To&nbsp;Date</strong></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txttodate" runat="server" Width="74px" Style="font-size: 12px;" />
                                <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txttodate" Format="dd-MMM-yyyy" PopupButtonID="txttodate"></cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-15">
                        <div class="row">
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlsortby" runat="server" Style="font-size: 12px;">
                                    <asp:ListItem Value="t.LastDate">LastStatusDate</asp:ListItem>
                                    <asp:ListItem Value="t.Centre">BookingLocation</asp:ListItem>
                                    <asp:ListItem Value="TimeDiffe1">TimeDifference</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlsortorder" runat="server" Style="font-size: 12px;">
                                    <asp:ListItem Value="asc">Ascending</asp:ListItem>
                                    <asp:ListItem Value="desc">Descending</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-17 ">
                                <input type="button" style="background-color: lightblue; cursor: pointer; font-weight: 700; font-size: 12px;" value="Logistic Pending" title="Logistic Pending" onclick="searchdata('0')" />
                                <input type="button" style="background-color: lightblue; cursor: pointer; font-weight: 700; font-size: 12px;" value="SRA Pending" title="SRA Pending" onclick="searchdata('1')" />
                                <input type="button" style="background-color: lightblue; cursor: pointer; font-weight: 700; font-size: 12px" value="Dept Receive Pending" title="Department Receive Pending" onclick="searchdata('2')" />
                                <input type="button" style="background-color: lightblue; cursor: pointer; font-weight: 700; font-size: 12px; display: none;" value="Coll. Pending(Insta)" title="Collection Pending(Insta)" onclick="searchdata('3')" />
                                <input type="button" value="< 15 Min" style="font-weight: 700; font-size: 11px" />
                                <input type="button" value="> 15 <30 Min" style="background-color: pink; font-weight: 700; font-size: 11px" />
                                <input type="button" value=">30 Min" style="background-color: cyan; font-weight: 700; font-size: 11px" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="height: 300px; overflow-y: auto; overflow-x: hidden;">
                    <table style="width: 99%" cellspacing="0" id="tbl" class="GridViewStyle">
                        <tr id="Header">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px; text-align: left">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">Booking Location</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">Last Status Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">SIN No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">Visit No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">UHID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align: left">PName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align: left">Sample Type</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align: left">Department</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 220px; text-align: left">TestName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">Referred By</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">PartyName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: left">Time Difference</th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">
        setInterval(function () {
            searchdata('1');
        }, $('#<%=ddlrefresh.ClientID%>').val());
        $(function () {
            searchdata('1');
        });
        function searchdata(type) {
            $('#tbl tr').slice(1).remove();
            serverCall('SRAPendingList.aspx/SearchPendingData', { fromdate: $('#txtfromdate').val(), todate: $('#txttodate').val(), type: type, sortby: $('#ddlsortby').val(), sortorder: $('#ddlsortorder').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.length == 0) {
                    return;
                }
                else {
                    var rowcolor = "";
                    for (var i = 0; i <= $responseData.length - 1; i++) {
                        if ($responseData[i].TimeDiffe1 <= 15) {
                            rowcolor = "white";
                        }
                        else if ($responseData[i].TimeDiffe1 > 15 && $responseData[i].TimeDiffe1 <= 30) {
                            rowcolor = "pink";
                        }
                        else {
                            rowcolor = "cyan";
                        }
                        var $mydata = [];
                        $mydata.push("<tr id='");
                        $mydata.push($responseData[i].test_id);
                        $mydata.push("'");
                        $mydata.push("style='background-color:");
                        $mydata.push(rowcolor);
                        $mydata.push(";height:25px;'>");
                        $mydata.push('<td class="GridViewLabItemStyle">');
                        $mydata.push(parseInt(i + 1));
                        $mydata.push('</td><td ID="tdBarcodeNo1111" class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].Centre);
                        $mydata.push('</td><td ID="tdBarcodeNo1" class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].LastStatusDate);
                        $mydata.push('</td><td ID="tdBarcodeNo" class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].SINNo);
                        $mydata.push('</td><td class="GridViewLabItemStyle"><b>');
                        $mydata.push($responseData[i].VisitID);
                        $mydata.push('</b></td><td class="GridViewLabItemStyle"><b>');
                        $mydata.push($responseData[i].patient_id);
                        $mydata.push('</b></td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].PName);
                        $mydata.push('</td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].SampleTypeName);
                        $mydata.push('</td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].Department);
                        $mydata.push('</td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].TestName);
                        $mydata.push('</td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].ReferedBy);
                        $mydata.push('</td><td class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].PanelName);
                        $mydata.push('</td><td ID="tdBarcodeNo222" class="GridViewLabItemStyle">');
                        $mydata.push($responseData[i].TimeDiffe);
                        $mydata.push('</td></tr>');
                        $mydata = $mydata.join("");
                        $('#tbl').append($mydata);
                    }
                }
            });
        }

    </script>
</body>


</html>
