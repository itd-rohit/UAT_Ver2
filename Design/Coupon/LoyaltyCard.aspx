<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LoyaltyCard.aspx.cs" Inherits="Design_Coupon_LoyaltyCard" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Loyalty Card Mapping Master</b>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <div class="row">

                        <div class="col-md-20">
                            <label class="pull-left">Coupon Code   </label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                </div>

                <div class="col-md-5 pull-left">
                    <div class="row ">
                        <div class="col-md-8 ">
                            <input id="txtCouponNo1" class="requiredField LoyaltyCardNo1" maxlength="4" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                        </div>
                        <div class="col-md-8">
                            <input id="txtCouponNo2" class="requiredField LoyaltyCardNo2" maxlength="4" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                        </div>
                        <div class="col-md-8">
                            <input id="txtCouponNo3" class="requiredField LoyaltyCardNo3" maxlength="5" type="text" onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Coupon Code" autocomplete="off" />
                        </div>
                    </div>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <div class="row">
                        <div class="col-md-20">
                            <label class="pull-left">Mobile No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <div class="col-md-18">
                            <input id="txtMobileNo" class="requiredField mobileNo" type="text" allowfirstzero onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Mobile No." onlynumber="10" autocomplete="off" />
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input id="btnLoyaltyCard" type="button" value="Save" onclick="LoyaltyCard()" class="searchbutton" />
        </div>
    </div>
    <script type="text/javascript">
        LoyaltyCard = function () {
            if (jQuery.trim(jQuery("#txtCouponNo1").val()) == "") {
                toast("Error", "Please Enter Coupon Code");
                jQuery("#txtCouponNo1").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtCouponNo2").val()) == "") {
                toast("Error", "Please Enter Coupon Code");
                jQuery("#txtCouponNo2").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtCouponNo3").val()) == "") {
                toast("Error", "Please Enter Coupon Code");
                jQuery("#txtCouponNo3").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtMobileNo").val()) == "") {
                toast("Error", "Please Enter Mobile No.");
                jQuery("#txtMobileNo").focus();
                return;
            }
            var CouponCode = "".concat(jQuery.trim(jQuery("#txtCouponNo1").val()), jQuery.trim(jQuery("#txtCouponNo2").val()), jQuery.trim(jQuery("#txtCouponNo3").val()));
            serverCall('LoyaltyCard.aspx/saveLoyaltyCard', { CouponCode: CouponCode, MobileNo: jQuery.trim(jQuery("#txtMobileNo").val()) }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response);
                    jQuery("#txtCouponNo,#txtMobileNo").val('');
                }
                else {
                    toast('Error', $responseData.response);
                }
            });
        }
    </script>
</asp:Content>

