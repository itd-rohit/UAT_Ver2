<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="B2CTabSetting.aspx.cs" Inherits="Design_B2CTabSetting" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top:-42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Tab Configure</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Tab Details
                </div>
                <div id="row" style="text-align: center">
                    <div class="col-md-2"></div>
                    <div class="col-md-20">
                        <table cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                            style="border-collapse: collapse;" class="exporttoexcel">
                            <thead>
                                <tr class="nodrop exporttoexcelheader" id="Header">
                                    <th scope="col" style="width: 6%;">Sr No</th>
                                    <th scope="col" style="display: none;">Tab Order</th>
                                    <th scope="col" style="width: 20%;">Tab Name</th>
                                    <th scope="col" style="width: 20%;">Title</th>
                                    <th scope="col" style="width: 20%;">Active</th>
                                    <th scope="col" style="width: 10%;">
                                        <input type="checkbox" id="chkal" onclick="chkall()" /></th>

                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-md-2"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="padding-top: 2px; padding-bottom: 2px; text-align: center;">
                <input id="btnSave" type="button" onclick="SaveData();" value="Save" class="savebutton" style="width: 120px;" />
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                SearchData();
            });
            function chngcur() {
                document.body.style.cursor = 'pointer';
            }
            function chngcurmove() {
                document.body.style.cursor = 'move';
            }
            function chkall() {
                if ($("#chkal").prop('checked')) {
                    $("#tb_grdLabSearch :checkbox").prop('checked', 'checked');
                }
                else {
                    $("#tb_grdLabSearch :checkbox").prop('checked', false);
                }

            }
            function SearchData() {
                jQuery('#tb_grdLabSearch tbody').html('');
                serverCall('B2CTabSetting.aspx/SearchData', {}, function (response) {
                    if (response != "") {
                        var $responseData = JSON.parse(response);
                        if ($responseData != null) {
                            for (var i = 0; i < $responseData.length; i++) {
                                var $appendText = [];
                                $appendText.push('<tr class="GridViewItemStyle" id="'); $appendText.push($responseData[i].ID); $appendText.push('">');
                                $appendText.push('<td onmouseover="chngcurmove()"> '); $appendText.push(i + 1); $appendText.push('</td>');
                                $appendText.push('<td onmouseover="chngcurmove()" style="display:none;">'); $appendText.push($responseData[i].Ordering); $appendText.push('</td>');
                                $appendText.push('<td onmouseover="chngcurmove()">'); $appendText.push($responseData[i].Name); $appendText.push('</td>');
                                $appendText.push('<td onmouseover="chngcurmove()"><input id="txtTitle" type="text" value="'); $appendText.push($responseData[i].Title); $appendText.push('"/></td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].Active); $appendText.push('</td>');
                                if ($responseData[i].Active == 'Yes') {
                                    $appendText.push('<td ><input id="chk" checked="checked" type="checkbox" />'); $appendText.push('</td>');
                                }
                                else {
                                    $appendText.push('<td ><input id="chk" type="checkbox" />'); $appendText.push('</td>');
                                }
                                $appendText.push("</tr>");
                                $appendText = $appendText.join("");
                                jQuery('#tb_grdLabSearch tbody').append($appendText);
                            }
                            $("#tb_grdLabSearch").tableDnD
                            ({
                                onDragClass: "GridViewDragItemStyle",
                                onDragStart: function (table, row) {
                                }
                            });
                        }
                    }
                });
            }
            function SaveData() {
                var TabList = "";
                $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        var TrData = $(this).closest('tr').attr('id') + '_' + $(this).closest('tr').find('#txtTitle').val();
                        TabList = TabList == '' ? TrData : TabList + ',' + TrData;
                    }
                });
                serverCall('B2CTabSetting.aspx/SaveData', { TabList: TabList }, function (response) {
                    if (response == "1") {
                        SearchData()
                        toast("Success", 'Record Saved Successfully', '');
                    }
                    else {
                        toast("Error", "Record Not Saved", "");

                    }
                });

            }
        </script>

    </form>
</body>
</html>


