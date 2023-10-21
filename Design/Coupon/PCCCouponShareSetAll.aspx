<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PCCCouponShareSetAll.aspx.cs" Inherits="Design_Coupon_PCCCouponShareSetAll" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" />

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <style type="text/css">
        .mybutton {
            cursor: pointer;
            padding: 5px;
            border-radius: 8px;
            margin: 5px;
            font-weight: bold;
            color: white;
            background-color: blue;
            font-size: 15px;
        }

        #ContentPlaceHolder1_ddldepartment_chosen {
            width: 300px !important;
        }

        #ContentPlaceHolder1_ddltest_chosen {
            width: 500px !important;
        }
    </style>



    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />


            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>LUPI MITRA Coupon Share Master Set ALL</b>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">LUPI MITRA Search</div>

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Coupon
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcoupon" runat="server" onchange="getpanel()" CssClass="ddlcoupon chosen-select"></asp:DropDownList>
                </div>

                <div class="col-md-4 mmt" style="display: none;">
                    <label class="pull-left">
                        Default Coupon Share %
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 mmt" style="display: none;">
                    <asp:TextBox ID="txtMRPPercentage" runat="server" Text="0" />
                    <cc1:FilteredTextBoxExtender ID="ftbMRPPercentage" runat="server" TargetControlID="txtMRPPercentage" ValidChars=".0123456789" />
                </div>
                <div class="col-md-5 mmt" style="display: none;">
                    <asp:Label ID="lb" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>

                <div class="col-md-2">
                    <label class="pull-left">
                        Client
                    </label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-5">
                <asp:ListBox ID="ddlpanel" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
            </div>
                <div class="col-md-12">
                <input type="button" value="Export To Excel" onclick="exporttoexcel()" class="searchbutton" id="btnexport" />
                    <input type="button" value="Save" onclick="saveme()" class="savebutton" style="display: none;" id="btnsave" />
                </div>
                </div>
           

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Item Search</div>
             <div class="row" id="ttfil">
                 <div class="col-md-2"></div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-5">
                 <asp:DropDownList ID="ddldepartment" runat="server" class="ddldepartment chosen-select" onchange="binddataall()"></asp:DropDownList>
                 </div></div>
           
            <div style="width: 100%">
                <table width="100%">
                    <tr>
                        <td width="50%" valign="top">
                            <div class="Purchaseheader">New Share</div>
                            <div class="TestDetail" style="margin-top: 5px; max-height: 300px; overflow: scroll; width: 100%;">
                                <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr id="ItemHeader">
                                            <td class="GridViewHeaderStyle" width="20px">#</td>
                                            <td class="GridViewHeaderStyle" width="80px">Item Code</td>
                                            <td class="GridViewHeaderStyle" width="250px">Item Name</td>
                                            <td class="GridViewHeaderStyle">LUPI MITRA Share %<br />
                                                <input type="text" id="txtdiscperhead" placeholder="Share % All" style="width: 80px" onkeyup="showme2(this)" name="t1" /></td>
                                            <td class="GridViewHeaderStyle">Client Share Amt<br />
                                                <input type="text" id="txtdiscamthead" placeholder="Share Amt All" style="width: 90px" onkeyup="showme2(this)" name="t2" />
                                            </td>
                                            <td class="GridViewHeaderStyle" width="20px">
                                                <input type="checkbox" onclick="checkall(this)" /></td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </td>
                        <td width="1%"></td>
                        <td width="49%" valign="top">
                            <div class="Purchaseheader">Saved Share</div>
                            <div class="TestDetail" style="margin-top: 5px; max-height: 300px; overflow: scroll; width: 100%;">
                                <table id="tblitemlist1" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr id="ItemHeader1">
                                            <td class="GridViewHeaderStyle" width="20px">#</td>
                                            <td class="GridViewHeaderStyle" width="150px">LUPI MITRA Name</td>
                                            <td class="GridViewHeaderStyle" width="220px">Item Name</td>
                                            <td class="GridViewHeaderStyle">LUPI MITRA Share %</td>
                                            <td class="GridViewHeaderStyle">Client Share Amt</td>
                                            <td class="GridViewHeaderStyle">Default Share</td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
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
            $('[id=ddlpanel]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $("#tblitemlist").tableHeadFixer({
            });
            $("#tblitemlist1").tableHeadFixer({
            });
        });
    </script>
    <script type="text/javascript">
        function getpanel() {
            jQuery('#<%=ddlpanel.ClientID%> option').remove();
            jQuery('#<%=ddlpanel.ClientID%>').multipleSelect("refresh");
            var couponid = $('#<%=ddlcoupon.ClientID%>').val();
            if (couponid != "0") {
                serverCall('PCCCouponShareSetAll.aspx/bindpanel', { coupanid: couponid }, function (response) {
                    CentreLoadListData = jQuery.parseJSON(response);
                    for (i = 0; i < CentreLoadListData.length; i++) {
                        jQuery("#ddlpanel").append(jQuery('<option></option>').val(CentreLoadListData[i].panel_id).html(CentreLoadListData[i].Company_Name));
                    }
                    $('[id=ddlpanel]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
            }
            getdatashare();
            getoldsharedata();
        }

        function getdatashare() {
            var data = jQuery('#<%=ddlcoupon.ClientID%>').val();
            if (data == "0") {
                $('#<%=txtMRPPercentage.ClientID%>').val('0');
                $('#btnsave,#btnexport').hide();
                $('#tblitemlist tr').slice(1).remove();
                $('#tblitemlist1 tr').slice(1).remove();
                $('#ttfil').show();
                $('.mmt').hide();
            }
            else {
                $('#<%=txtMRPPercentage.ClientID%>').val('0');
                $('#btnsave').show();
                if (data.split('#')[2] == "2") {
                    $('.mmt').hide();
                    bindcoupontest();
                }
                else {
                    $('#btnsave,.mmt,#ttfil').show();
                    $('#tblitemlist tr').slice(1).remove();
                    $('#tblitemlist1 tr').slice(1).remove();
                }
            }
        }
        function getoldsharedata() {

            $('#tblitemlist1 tr').slice(1).remove();
            serverCall('PCCCouponShareSetAll.aspx/getoldsharedata', { couponid: jQuery('#<%=ddlcoupon.ClientID%>').val().split('#')[0] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var $tr = [];
                    if (ItemData[i].ItemID == "0") {
                        $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:#c4ffc9;'>");
                    }
                    else {
                        $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:bisque;'>");
                    }
                    $tr.push('<td class="GridViewLabItemStyle">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle">'); $tr.push(ItemData[i].panelname); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" >'); $tr.push(ItemData[i].itemname); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle">'); $tr.push(ItemData[i].shareper); $tr.push('</td> ');
                    $tr.push('<td class="GridViewLabItemStyle">'); $tr.push(ItemData[i].shareamt); $tr.push('</td> ');
                    $tr.push('<td class="GridViewLabItemStyle">'); $tr.push(ItemData[i].defaultshare); $tr.push('</td> ');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist1').append($tr);
                    jQuery('#tblitemlist1').css('display', 'block');
                }
            });
        }
        function bindcoupontest() {
            $('#btnsave').hide();
            $('#tblitemlist tr').slice(1).remove();
            $('#ttfil').hide();
            serverCall('PCCCouponShareSetAll.aspx/bindcoutest', { couponid: jQuery('#<%=ddlcoupon.ClientID%>').val().split('#')[0] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No  Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    $('#btnsave').show();
                    var $tr = [];
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:lightyellow;'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(ItemData[i].SharePer); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(ItemData[i].ShareAmt); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
                }
            });

        }
        function binddataall() {
            $('#btnsave').hide();
            $('#tblitemlist tr').slice(1).remove();
            if ($('#<%=ddldepartment.ClientID%>').val() == "0") {
                return;
            }
            serverCall('PCCCouponShareSetAll.aspx/bindtestALL', { departmentid: $('#<%=ddldepartment.ClientID%>').val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    $('#btnsave').show();
                    var $tr = [];
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:lightyellow;'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(ItemData[i].SharePer); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(ItemData[i].ShareAmt); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
                }
            });
        }
        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {
                    if ($(ctr).is(":checked")) {
                        $(this).find('#chk').attr('checked', true);
                    }
                    else {
                        $(this).find('#chk').attr('checked', false);
                    }
                }
            });
        }
        function showme1(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            // alert($(ctrl).closest("tr").find("#txttddisc").text());
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            if ($(ctrl).attr('id') == "txtper") {
                $(ctrl).closest('tr').find('#txtnet').val('');
                if ($(ctrl).val() > 100) {
                    $(ctrl).val('100');
                }
            }
            if ($(ctrl).attr('id') == "txtnet") {
                $(ctrl).closest('tr').find('#txtper').val('');
            }
            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
        }
        function showme2(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            if ($(ctrl).attr('id') == "txtdiscperhead") {
                $(ctrl).closest('tr').find('#txtdiscamthead').val('');
                var name = "t2";
                $('input[name="' + name + '"]').each(function () {
                    $(this).val('');
                });
                if ($(ctrl).val() > 100) {
                    $(ctrl).val('100');
                }
            }
            if ($(ctrl).attr('id') == "txtdiscamthead") {
                $(ctrl).closest('tr').find('#txtdiscperhead').val('');
                var name = "t1";
                $('input[name="' + name + '"]').each(function () {
                    $(this).val('');
                });
            }
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }
        function saveme() {
            var couponid = $('#<%=ddlcoupon.ClientID%>').val();
            if (couponid == "0") {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return;
            }
            var defaultshare = $('#<%=txtMRPPercentage.ClientID%>').val() == "" ? 0 : $('#<%=txtMRPPercentage.ClientID%>').val();
            if (couponid.split('#')[2] == "1" && defaultshare == 0) {
                toast("Error", "Please Enter Default Coupon Share %");
                $('#<%=txtMRPPercentage.ClientID%>').focus();
                return;
            }
            if ((JSON.stringify($('#ddlpanel').val()) == '[]')) {
                toast("Error", "Please Select LUPI MITRA ");
                $('#ddlpanel').focus();
                return;
            }
            var a = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "ItemHeader" && $(this).find("#chk").is(':checked')) {
                    var shareper = $(this).closest("tr").find("#txtper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtper").val());
                    var shareamt = $(this).closest("tr").find("#txtnet").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtnet").val());
                    if (shareper == 0 && shareamt == 0) {
                        $(this).closest("tr").find("#txtper").focus();
                        a = 1;
                        return;
                    }
                }
            });
            if (a == 1) {
                toast("Error", "Please Enter Share % Or Share Amt");
                return false;
            }
            var data = getitemdata();
            if (couponid.split('#')[2] != "1") {
                if (data.length == 0) {
                    toast("Error", "Please Select Item");
                    return false;
                }
            }
            var panelid = $('#ddlpanel').val();
            serverCall('PCCCouponShareSetAll.aspx/savealldata', { data: data, panelid: panelid, defaultshare: defaultshare, couponid: couponid.split('#')[0] }, function (response) {
                TestData1 = response;
                if (TestData1 == "1") {
                    toast("Success", "Record Save Sucessfully");
                    window.location.reload();
                }
                else {
                    toast("Error", TestData1);
                }
            });
        }
        function getitemdata() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "ItemHeader" && $(this).find("#chk").is(':checked')) {
                    var itemid = $(this).attr("id");
                    var discper = $(this).closest("tr").find("#txtper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtper").val());
                    var discamt = $(this).closest("tr").find("#txtnet").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtnet").val());
                    var finddata = itemid + "#" + discper + "#" + discamt;
                    dataIm.push(finddata);
                }
            });
            return dataIm;
        }
        function exporttoexcel() {
            var couponid = $('#<%=ddlcoupon.ClientID%>').val();
             if (couponid == "0") {
                 toast("Error", "Please Select Coupon");
                 $('#<%=ddlcoupon.ClientID%>').focus();
                return;
            }
            serverCall('PCCCouponShareSetAll.aspx/exportdatatoexcel', { couponid: jQuery('#<%=ddlcoupon.ClientID%>').val().split('#')[0] }, function (response) {
                var resultData = JSON.parse(response);
                if (!resultData.status) {
                    toast("Error", resultData.data);
                }
                else {
                    ExportToExcelData(resultData.data);
                }
             });
         }
    </script>
</asp:Content>

