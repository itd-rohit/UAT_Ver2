<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LoyaltyCardSearch.aspx.cs" Inherits="Design_Coupon_LoyaltyCardSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css" />
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Loyalty Card Search</b>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Coupon Code   </label>
                    <b class="pull-right">:</b>
                </div>
              
                    <div class="col-md-2">
                                        <input id="txtCouponNo1" class="LoyaltyCardNo1" maxlength="4" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                   </div> <div class="col-md-2"> <input id="txtCouponNo2" class="LoyaltyCardNo2" maxlength="4" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                   </div> <div class="col-md-2"> <input id="txtCouponNo3" class="LoyaltyCardNo3" maxlength="5" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                       </div> 
             
                <div class="col-md-3">
                    <label class="pull-left">Mobile No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input id="txtMobileNo" class="mobileNo" type="text" allowfirstzero onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Mobile No." onlynumber="10" autocomplete="off" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-4"></div>
                <div class="col-md-3">
                    <label class="pull-left">To Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center">
            <input id="btnLoyaltyCard" type="button" value="Search" onclick="LoyaltyCardSearch()" class="searchbutton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div style="height: 200px" class="row">
                <table id="tblCouponDetail" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 100%">
                    <tr id="trCouponDetail" class="Header">
                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Mobile No.</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Coupon Code</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Coupon Name</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Coupan Type</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Edit</td>
                        <td class="GridViewHeaderStyle" style="text-align: left">Remove</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        LoyaltyCardSearch = function () {
            jQuery('#tblCouponDetail tr').slice(1).remove();
            var CouponCode = "".concat(jQuery.trim(jQuery("#txtCouponNo1").val()), jQuery.trim(jQuery("#txtCouponNo2").val()), jQuery.trim(jQuery("#txtCouponNo3").val()));

            serverCall('LoyaltyCardSearch.aspx/LoyaltyCardSearch', { CouponCode: CouponCode, MobileNo: jQuery.trim(jQuery("#txtMobileNo").val()), FromDate: jQuery.trim(jQuery("#txtFromDate").val()), ToDate: jQuery.trim(jQuery("#txtToDate").val()) }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var CouponDetails = jQuery.parseJSON($responseData.response);
                    for (var i = 0; i <= CouponDetails.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr id='"); $Tr.push(CouponDetails[i].CoupanId); $Tr.push("' class='"); $Tr.push(CouponDetails[i].Coupancode); $Tr.push("' >");
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(i + 1); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdMobileNo">'); $Tr.push(CouponDetails[i].MobileNo); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanCode">'); $Tr.push(CouponDetails[i].Coupancode); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanName">'); $Tr.push(CouponDetails[i].coupanName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[i].CoupanType); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="$edit(this)"/></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="$remove(this)"/></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdLoyaltyID">'); $Tr.push(CouponDetails[i].LoyaltyID); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdCoupanId">'); $Tr.push(CouponDetails[i].CoupanId); $Tr.push('</td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        jQuery('#tblCouponDetail').append($Tr);
                    }
                }
                else {
                    toast('Error', $responseData.response);
                }
            });
        }
        $edit = function (rowID) {
            jQuery("#spnCouponCode,#spnMobileNo,#spnLoyalityID,#spnCoupanId").text('');
            jQuery("#txtNewMobileNo").val('');
            var CouponCode = jQuery(rowID).closest("tr").find("#tdCoupanCode").text();
            var MobileNo = jQuery(rowID).closest("tr").find("#tdMobileNo").text();
            var ID = jQuery(rowID).closest("tr").find("#tdLoyaltyID").text();
            var CoupanId = jQuery(rowID).closest("tr").find("#tdCoupanId").text();
            serverCall('LoyaltyCardSearch.aspx/EditLoyaltyCardChk', { CouponCode: CouponCode }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    jQuery("#spnCouponCode").text(CouponCode);
                    jQuery("#spnMobileNo").text(MobileNo);
                    jQuery("#spnLoyalityID").text(ID);
                    jQuery("#spnCoupanId").text(CoupanId);
                    jQuery("#divCouponEdit").showModel();
                }
                else {
                    toast('Error', $responseData.response);
                    jQuery("#spnCouponCode,#spnMobileNo,#spnLoyalityID,#spnCoupanId").text('');
                }
            });
        }
        $remove = function (rowID) {
            var CouponCode = jQuery(rowID).closest("tr").find("#tdCoupanCode").text();
            var MobileNo = jQuery(rowID).closest("tr").find("#tdMobileNo").text();
            var ID = jQuery(rowID).closest("tr").find("#tdLoyaltyID").text();
            var CoupanId = jQuery(rowID).closest("tr").find("#tdCoupanId").text();
            CouponConfirm(CouponCode, MobileNo, ID, CoupanId);


        }
    </script>
    <script type="text/javascript">
        CouponConfirm = function (CouponCode, MobileNo, ID, CoupanId) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: "".concat('<b>Do You Want to Remove?</b><br/>', '<b>Coupon Code :</b>', CouponCode, '<br/>', '<b>Mobile No. :</b>', MobileNo),
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '520px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            confirmationAction(CouponCode, MobileNo, ID, CoupanId);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            clearAction();
                        }
                    },
                }
            });
        }
        confirmationAction = function (CouponCode, MobileNo, ID, CoupanId) {
            serverCall('LoyaltyCardSearch.aspx/RemoveLoyaltyCard', { CouponCode: CouponCode, MobileNo: MobileNo, ID: ID, CoupanId: CoupanId }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response);
                    LoyaltyCardSearch();
                }
                else {
                    toast('Error', $responseData.response);
                }

            });
        }
        clearAction = function () {

        }
        $closeCouponEdit = function () {
            jQuery("#divCouponEdit").hideModel();
            jQuery("#spnCouponCode,#spnMobileNo,#spnLoyalityID,#spnCoupanId").text('');
            jQuery("#txtNewMobileNo").val('');
        }
        $UpdateCoupon = function () {
            if (jQuery.trim(jQuery("#txtNewMobileNo").val()) == "") {
                jQuery("#spnError").text('Please Enter Mobile No.');
                jQuery("#txtNewMobileNo").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtNewMobileNo").val()).length != 10) {
                jQuery("#spnError").text('Please Enter Valid Mobile No.');
                jQuery("#txtNewMobileNo").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtNewMobileNo").val()) == jQuery("#spnMobileNo").text()) {
                jQuery("#spnError").text('Old and New Mobile No. cannot be same');
                jQuery("#txtNewMobileNo").focus();
                return;
            }
            serverCall('LoyaltyCardSearch.aspx/UpdateCouponDetail', { CouponCode: jQuery("#spnCouponCode").text(), MobileNo: jQuery("#spnMobileNo").text(), ID: jQuery("#spnLoyalityID").text(), CoupanId: jQuery("#spnCoupanId").text(), NewMobileNo: jQuery("#txtNewMobileNo").val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response);
                    $closeCouponEdit();
                    LoyaltyCardSearch();
                }
                else {
                    jQuery("#spnError").text($responseData.response);
                }
            });
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divCouponEdit').is(':visible')) {
                    $closeCouponEdit();
                }
            }
        }
    </script>
    <div id="divCouponEdit" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 44%; max-width: 42%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-8" style="text-align: left">
                            <h4 class="modal-title">Coupon Detail</h4>
                        </div>

                        <div class="col-md-16" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeCouponEdit()" aria-hidden="true">&times;</button>to close</span></em>
                            <span id="spnLoyalityID" style="display: none"></span>
                            <span id="spnCoupanId" style="display: none"></span>
                        </div>
                    </div>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24" style="text-align: center">
                            <span id="spnError" class="ItDoseLblError"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Coupon Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnCouponCode"></span>
                        </div>


                        <div class="col-md-6">
                            <label class="pull-left">Old Mobile No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <span id="spnMobileNo"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">New Mobile No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input id="txtNewMobileNo" class="requiredField NewmobileNo" type="text" allowfirstzero onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Mobile No." onlynumber="10" autocomplete="off" />


                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align: center"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align: center">
                            <input type="button" id="btnUpdateCoupon" value="Update" onclick="$UpdateCoupon()" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeCouponEdit()">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

