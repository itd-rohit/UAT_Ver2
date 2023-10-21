<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PCCCouponShare.aspx.cs" Inherits="Design_Coupon_PCCCouponShare" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" />

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
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
            <b>LUPI MITRA Coupon Share Master</b>
        </div>

        <div class="POuter_Box_Inventory" style="">
            <div class="Purchaseheader">LUPI MITRA Search</div>

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Business
                        Zone
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        State
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlstate" runat="server" onchange="bindPanel()" class="ddlstate chosen-select">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Client
                        Zone
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlpanel" runat="server" class="ddlpanel chosen-select" onchange="getdata()"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Coupon
                        
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcoupon" runat="server" onchange="getdatashare()" class="ddlcoupon chosen-select"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-4">
                    <label class="pull-left">
                        Default Coupon Share %
                        
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtMRPPercentage" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="chkMRPPercentage()" Text="0" />
                    <cc1:FilteredTextBoxExtender ID="ftbMRPPercentage" runat="server" TargetControlID="txtMRPPercentage" ValidChars=".0123456789" />


                </div>
                <div class="col-md-6">
                    <asp:Label ID="lb" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>
                </div>
            </div>

            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-4">
                        Item Search
                    </div>
                    <div class="col-md-3">
                        Coupon Share Set
                    </div>
                    <div class="col-md-2" style="width: 30px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                    </div>
                    <div class="col-md-3"></div>
                    <div class="col-md-4">
                        Coupon Share Not Set
                    </div>
                    <div class="col-md-2" style="width: 30px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightyellow;">
                    </div>
                </div>

            </div>
            <div class="row">
                <div class="col-md-12" id="ttfil">
                    <input type="button" value="Special Test" class="mybutton" onclick="bindspecialtest()" />
                    <input type="button" value="Group Test" class="mybutton" onclick="bindgrouptest()" />
                    <input type="button" value="Other Test" class="mybutton" onclick="bindother()" />

                    <span style="color: red; font-size: 12px">
                        <i>* In Other test those test show where rate is saved</i>
                    </span>

                </div>
                <div class="col-md-12" id="testfilter">
                    <asp:DropDownList ID="ddldepartment" runat="server" class="ddldepartment chosen-select" onchange="binddataall()"></asp:DropDownList>
                </div>
            </div>


            <div class="TestDetail" style="margin-top: 5px; max-height: 300px; overflow: scroll; width: 100%;">
                <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <thead>
                        <tr id="ItemHeader">

                            <td class="GridViewHeaderStyle" width="50px">S.No.</td>
                            <td class="GridViewHeaderStyle" width="120px">Item Code</td>
                            <td class="GridViewHeaderStyle" width="400px">Item Name</td>
                            <td class="GridViewHeaderStyle" width="60px">MRP</td>
                            <td class="GridViewHeaderStyle" width="140px">LUPI MITRA Share<br />
                                (Without Coupon)</td>
                            <td class="GridViewHeaderStyle" width="100px">LUPI MITRA Share %<br />
                                <input type="text" id="txtdiscperhead" placeholder="Share % All" style="width: 80px" onkeyup="showme2(this)" name="t1" /></td>
                            <td class="GridViewHeaderStyle" width="120px">Client Share Amt.<br />
                                <input type="text" id="txtdiscamthead" placeholder="Share Amt All" style="width: 90px" onkeyup="showme2(this)" name="t2" />
                            </td>

                            <td class="GridViewHeaderStyle" width="240px">Created By</td>
                            <td class="GridViewHeaderStyle" width="140px">Created Date</td>
                            <td class="GridViewHeaderStyle" width="20px">
                                <input type="checkbox" onclick="checkall(this)" /></td>


                        </tr>
                    </thead>
                </table>
            </div>

            <center>
                <input type="button" value="Save" id="btnsave" class="savebutton" onclick="savedata()" /></center>
        </div>
    </div>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function chkMRPPercentage() {
            if (jQuery.trim($("#<%=txtMRPPercentage.ClientID%>").val()) != "") {
                if (jQuery("#<%=txtMRPPercentage.ClientID%>").val() > 100) {
                    toast("Error", 'Please Enter Valid Percentage');
                    jQuery("#<%=txtMRPPercentage.ClientID%>").val('0');
                }
            }
        }
    </script>
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
            $('#<%=ddlBusinessZone.ClientID%>').trigger('chosen:updated');
            $("#tblitemlist").tableHeadFixer({
            });
        });
        function bindState() {
            jQuery("#ddlstate option").remove();
            jQuery('#ddlstate').trigger('chosen:updated');
            jQuery('#<%=ddlpanel.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlpanel.ClientID%> option').remove();
            if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(0, jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);

            jQuery("#ddlstate").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlstate").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlstate").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlstate').trigger('chosen:updated');

        }
        function onFailureState() {

        }
        function bindPanel() {
            if (jQuery("#ddlCity").val() == 0) {
                jQuery('#<%=ddlpanel.ClientID%> option').remove();
            }
            else
                PageMethods.bindPanel($("#<%=ddlBusinessZone.ClientID%>").val(), $("#<%=ddlstate.ClientID%>").val(), onSuccessPanel, OnfailurePanel);

        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            jQuery('#<%=ddlpanel.ClientID%> option').remove();

            if (panelData.length == 0) {
                jQuery("#<%=ddlpanel.ClientID%>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            if (panelData.length > 0) {
                jQuery("#<%=ddlpanel.ClientID%>").append(jQuery("<option></option>").val("0").html("Select PCC"));
                for (i = 0; i < panelData.length; i++) {

                    jQuery('#<%=ddlpanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('#<%=ddlpanel.ClientID%>').trigger('chosen:updated');
            }

        }
          function OnfailurePanel() {

          }
          function getdata() {
              var data = jQuery('#<%=ddlpanel.ClientID%>').val();
            if (data == "0") {
                $('#<%=txtMRPPercentage.ClientID%>').val('0');
                  $('#<%=lb.ClientID%>').text('');
              }
              else {
                  $('#<%=txtMRPPercentage.ClientID%>').val('0');
                  $('#<%=lb.ClientID%>').text("Share on MRP(%) (Without Coupon) : " + data.split('#')[2]);
              }
              bindcoupon();
              $('#tblitemlist tr').slice(1).remove();
              hidetestfilter();
          }
          function bindspecialtest() {
              var length = $('#<%=ddlpanel.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }
            var length1 = $('#<%=ddlcoupon.ClientID%> > option').length;
            if (length1 == 0) {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlcoupon.ClientID%>').val() == "0") {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return;
            }
            hidetestfilter();
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PCCCouponShare.aspx/bindspecialtest', { panelid: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[0], mrppanelid: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[3], refercode: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[4], couponid: jQuery('#<%=ddlcoupon.ClientID%>').val().split('#')[0], EntryTypeID: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[5] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Special Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var color = "lightyellow";
                    if (ItemData[i].savedid != "0") {
                        color = "lightgreen";
                    }
                    var $tr = [];
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:"); $tr.push(color); $tr.push(";'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdmrp" style="text-align:right">'); $tr.push(ItemData[i].mrp); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdnetshare" style="text-align:right">'); $tr.push(ItemData[i].netshare); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(precise_round(ItemData[i].SharePer, 5)); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(precise_round(ItemData[i].ShareAmt, 5)); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentryby">'); $tr.push(ItemData[i].CreatedBy); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentrydate">'); $tr.push(ItemData[i].CreatedDate); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdpanel" style="display:none;">'); $tr.push(ItemData[i].panelid); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponid" style="display:none;">'); $tr.push(ItemData[i].couponid); $tr.push('</td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
                }
            });
        }
        function bindgrouptest() {
            var length = $('#<%=ddlpanel.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }
            var length1 = $('#<%=ddlcoupon.ClientID%> > option').length;
            if (length1 == 0) {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlcoupon.ClientID%>').val() == "0") {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return;
            }
            hidetestfilter();
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PCCCouponShare.aspx/bindgrouptest', { panelid: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[0], mrppanelid: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[3], refercode: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[4], couponid: jQuery('#<%=ddlcoupon.ClientID%>').val().split('#')[0], EntryTypeID: jQuery('#<%=ddlpanel.ClientID%>').val().split('#')[5] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Group Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var color = "lightyellow";
                    if (ItemData[i].savedid != "0") {
                        color = "lightgreen";
                    }
                    var $tr = [];
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:"); $tr.push(color); $tr.push(";'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdmrp" style="text-align:right">'); $tr.push(ItemData[i].mrp); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdnetshare" style="text-align:right">'); $tr.push(ItemData[i].netshare); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(precise_round(ItemData[i].SharePer, 5)); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(precise_round(ItemData[i].ShareAmt, 5)); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentryby">'); $tr.push(ItemData[i].CreatedBy); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentrydate">'); $tr.push(ItemData[i].CreatedDate); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdpanel" style="display:none;">'); $tr.push(ItemData[i].panelid); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponid" style="display:none;">'); $tr.push(ItemData[i].couponid); $tr.push('</td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
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
        function showtestfilter() {
            $("#testfilter").show();
            $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0);
            $("#<%=ddldepartment.ClientID%>").trigger('chosen:updated');
        }
        function hidetestfilter() {
            $("#testfilter").hide();
            $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0);
            $("#<%=ddldepartment.ClientID%>").trigger('chosen:updated');
        }
       function bindother() {
           var length = $('#<%=ddlpanel.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }
            showtestfilter();

            $('#tblitemlist tr').slice(1).remove();
        }
        function binddataall() {
            var length = $('#<%=ddlpanel.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                toast("Error", "Please Select PCC");
                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }
            var length1 = $('#<%=ddlcoupon.ClientID%> > option').length;
            if (length1 == 0) {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlcoupon.ClientID%>').val() == "0") {
                toast("Error", "Please Select Coupon");
                $('#<%=ddlcoupon.ClientID%>').focus();
                return;
            }
            $('#tblitemlist tr').slice(1).remove();
            if ($('#ddldepartment').val() == "0") {
                return;
            }
            serverCall('PCCCouponShare.aspx/bindtestALL', { panelid: jQuery('#ddlpanel').val().split('#')[0], mrppanelid: jQuery('#ddlpanel').val().split('#')[3], departmentid: $('#ddldepartment').val(), refercode: jQuery('#ddlpanel').val().split('#')[4], couponid: jQuery('#ddlcoupon').val().split('#')[0], EntryTypeID: jQuery('#ddlpanel').val().split('#')[5] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var color = "lightyellow";
                    if (ItemData[i].savedid != "0") {
                        color = "lightgreen";
                    }
                    var $tr = [];
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:"); $tr.push(color); $tr.push(";'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdmrp" style="text-align:right">'); $tr.push(ItemData[i].mrp); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdnetshare" style="text-align:right">'); $tr.push(ItemData[i].netshare); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(precise_round(ItemData[i].SharePer, 5)); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(precise_round(ItemData[i].ShareAmt, 5)); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentryby">'); $tr.push(ItemData[i].CreatedBy); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentrydate">'); $tr.push(ItemData[i].CreatedDate); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdpanel" style="display:none;">'); $tr.push(ItemData[i].panelid); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponid" style="display:none;">'); $tr.push(ItemData[i].couponid); $tr.push('</td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
                }
            });
        }
        function savedata() {
            var length = $('#ddlpanel > option').length;
            if (length == 0) {
                toast("Error", "Please Select PCC");
                $('#ddlpanel').focus();
                return false;
            }
            if ($('#ddlpanel').val() == "0") {
                toast("Error", "Please Select PCC");
                $('#ddlpanel').focus();
                return;
            }
            var length1 = $('#ddlcoupon > option').length;
            if (length1 == 0) {
                toast("Error", "Please Select Coupan");
                $('#ddlcoupon').focus();
                return false;
            }
            if ($('#ddlcoupon').val() == "0") {
                toast("Error", "Please Select Coupan");
                $('#ddlcoupon').focus();
                return;
            }
            var defaultshare = $('#txtMRPPercentage').val() == "" ? 0 : $('#txtMRPPercentage').val();
            if ($('#ddlcoupon').val().split('#')[2] == "1" && defaultshare == 0) {
                toast("Error", "Please Enter Default Coupon Share %");
                $('#txtMRPPercentage').focus();
                return;
            }
            var data = getitemdata();
            var panelid = $('#ddlpanel').val().split('#')[0];
            var defaultshare = $('#txtMRPPercentage').val();
            var coupon = $('#ddlcoupon').val().split('#')[0];
            serverCall('PCCCouponShare.aspx/savealldata', { data: data, panelid: panelid, defaultshare: defaultshare, coupon: coupon, EntryTypeID: $('#ddlpanel').val().split('#')[5], EntryType: $('#ddlpanel').val().split('#')[6] }, function (response) {
                TestData1 = response;
                if (TestData1 == "1") {
                    toast("Success", "Record Save Sucessfully");
                    if ($('#ddlcoupon').val().split('#')[2] == "2") {
                        bindcoupontest();
                    }
                    else {
                        bindspecialtest();
                    }
                    // window.location.reload();
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
                   var panelid = $(this).closest("tr").find("#tdpanel").text();
                   var couponid = $(this).closest("tr").find("#tdcouponid").text();

                   var finddata = itemid + "#" + panelid + "#" + discper + "#" + discamt + "#" + couponid;
                   dataIm.push(finddata);
               }
           });
           return dataIm;
       }

       function precise_round(num, decimals) {
           return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
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
       function bindcoupon() {
           jQuery('#ddlcoupon option').remove();
           jQuery('#ddlcoupon').trigger('chosen:updated');
           serverCall('PCCCouponShare.aspx/bindcoupon', { panelid: jQuery('#ddlpanel').val() }, function (response) {
               cityData = jQuery.parseJSON(response);
               if (cityData.length == 0) {
                   jQuery('#ddlcoupon').append(jQuery("<option></option>").val("0").html("---No Coupon Found---"));
                }
                else {
                   jQuery('#ddlcoupon').append(jQuery("<option></option>").val("0").html("Select Coupon"));
                    for (i = 0; i < cityData.length; i++) {
                        jQuery('#ddlcoupon').append(jQuery("<option></option>").val(cityData[i].coupanid).html(cityData[i].coupanname));
                    }
                }
               jQuery('#ddlcoupon').trigger('chosen:updated');
            });
        }
        function getdatashare() {
            var data = jQuery('#ddlcoupon').val();
            if (data == "0") {
                $('#txtMRPPercentage').val('0');
                hidetestfilter();
                $('#tblitemlist tr').slice(1).remove();
                $('#ttfil').show();
            }
            else {
                $('#txtMRPPercentage').val(data.split('#')[1]);
                if (data.split('#')[2] == "2") {
                    bindcoupontest();
                }
                else {
                    hidetestfilter();
                    $('#ttfil').show();
                    $('#tblitemlist tr').slice(1).remove();
                }
            }
        }
        function bindcoupontest() {
            hidetestfilter();
            $('#tblitemlist tr').slice(1).remove();
            $('#ttfil').hide();
            serverCall('PCCCouponShare.aspx/bindcoutest', { panelid: jQuery('#ddlpanel').val().split('#')[0], mrppanelid: jQuery('#ddlpanel').val().split('#')[3], refercode: jQuery('#ddlpanel').val().split('#')[4], couponid: jQuery('#ddlcoupon').val().split('#')[0], EntryTypeID: jQuery('#ddlpanel').val().split('#')[5] }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No  Test Found");
                    return;
                }
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var $tr = [];
                    var color = "lightyellow";
                    if (ItemData[i].savedid != "0") {
                        color = "lightgreen";
                    }
                    $tr.push("<tr id='"); $tr.push(ItemData[i].ItemID); $tr.push("' style='background-color:"); $tr.push(color); $tr.push(";'>");
                    $tr.push('<td class="GridViewLabItemStyle" id="tdsrno">'); $tr.push(parseInt(i + 1)); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemcode">'); $tr.push(ItemData[i].TestCode); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tditemname">'); $tr.push(ItemData[i].ItemName); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdmrp" style="text-align:right">'); $tr.push(ItemData[i].mrp); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdnetshare" style="text-align:right">'); $tr.push(ItemData[i].netshare); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareper"><input type="text" value="'); $tr.push(precise_round(ItemData[i].SharePer, 5)); $tr.push('" onkeyup="showme1(this)" style="width:80px" id="txtper" name="t1" /></td> ');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponshareamt"><input type="text" value="'); $tr.push(precise_round(ItemData[i].ShareAmt, 5)); $tr.push('" onkeyup="showme1(this)" style="width:90px" id="txtnet" name="t2" /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentryby">'); $tr.push(ItemData[i].CreatedBy); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdentrydate">'); $tr.push(ItemData[i].CreatedDate); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdpanel" style="display:none;">'); $tr.push(ItemData[i].panelid); $tr.push('</td>');
                    $tr.push('<td class="GridViewLabItemStyle" id="tdcouponid" style="display:none;">'); $tr.push(ItemData[i].couponid); $tr.push('</td>');
                    $tr.push("</tr>");
                    $tr = $tr.join("");
                    $('#tblitemlist').append($tr);
                    jQuery('#tblitemlist').css('display', 'block');
                }
            });
        }
    </script>
</asp:Content>

