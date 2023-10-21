<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CouponMasterApproval.aspx.cs" Inherits="Design_Coupon_CouponMasterApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script src="../../Scripts/fancybox/jquery.fancybox.js" type="text/javascript"></script>
    <asp:Label ID="lblcoupontype" runat="server" Style="display: none;"></asp:Label>
    <asp:Label ID="lblcouponcategory" runat="server" Style="display: none;"></asp:Label>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Coupon Status and Approval</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Status   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlstatus" runat="server">

                        <asp:ListItem Value="0" Selected="True">Maked</asp:ListItem>
                        <asp:ListItem Value="1">Checked</asp:ListItem>
                        <asp:ListItem Value="2">Approved</asp:ListItem>
                        <asp:ListItem Value="3">Rejected</asp:ListItem>
                        <asp:ListItem Value=""></asp:ListItem>
                    </asp:DropDownList>

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Coupon Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcoupontype" runat="server"></asp:DropDownList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Coupon Category </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcouponcategory" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Coupon Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtcouponname" runat="server"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">

                <input type="button" value="Search" class="searchbutton" onclick="SearchData()" />
            </div>

            <div class="row">
                <table width="100%">
                    <tr>
                        <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Maked</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Checked</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Approved</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #FF5722;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Rejected</td>
                    </tr>
                </table>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Coupon Detail
            </div>
            <div style="width: 100%; max-height: 375px; overflow: auto;">
                <table id="tblcoupon" style="border-collapse: collapse; width: 100%; max-height: 200px; overflow: auto;">
                    <tr id="trquuheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                        <td class="GridViewHeaderStyle" style="width: 140px;">Coupon Name</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Coupon Type</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Coupon Category</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Valid From</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Valid To</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Min. Billing Amt.</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">Issue For</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Applicable</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Discount Amt.</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Discount(%)</td>
                        <td class="GridViewHeaderStyle" style="width: 120px; display: none;">Applicable</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Multiple Coupon </td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">WeekEnd / HappyHours </td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">Days </td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">View Center/PUP</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">View Test</td>
                        <td class="GridViewHeaderStyle" style="width: 120px;">View Coupon</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Reject</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>


    <asp:Button ID="btnHide" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalCentre" runat="server" TargetControlID="btnHide" BehaviorID="modalCentre" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel3" CancelControlID="viewcancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel3" Style="display: none; width: 500px; height: 500px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            Search Centre: 
            <asp:TextBox ID="txtcentresearch" runat="server" placeholder="Enter Centre Name" Width="235px" />
            <table id="viewcenter" style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td class="GridViewHeaderStyle">Center <span style="margin-left: 100px;">Total Centre : 
                        <asp:Label ID="lbltotalcountcentre" runat="server"></asp:Label></span> </td>
                </tr>
            </table>

        </div>
        <div style="text-align: center;">
            <input id="viewcancel" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>


    <asp:Button ID="hidetest" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalCentre1" runat="server" TargetControlID="hidetest" BehaviorID="modalCentre1" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel4" CancelControlID="viewtestcan">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel4" Style="display: none; width: 500px; height: 500px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            <table id="viewtest" style="width: 100%; border-collapse: collapse; text-align: center;">
                <tr>
                    <td class="GridViewHeaderStyle" style="width: 20px;">Test</td>
                    <td class="GridViewHeaderStyle" style="width: 20px;">Disc%</td>
                    <td class="GridViewHeaderStyle" style="width: 20px;">Disc Amt</td>
                </tr>
            </table>

        </div>
        <div style="text-align: center;">
            <input id="viewtestcan" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>


    <asp:Button ID="hidecouponcode" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalcouponcode" runat="server" TargetControlID="hidecouponcode" BehaviorID="modalcouponcode" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlcouponcode" CancelControlID="btncouponcode">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlcouponcode" Style="display: none; width: 500px; height: 500px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            Search Coupon Code: 
            <asp:TextBox ID="txtcouponsearch" runat="server" placeholder="Enter Coupon Code" Width="235px" />
            <table id="tblcouponcode" style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: left;">Couoan Code      <span style="margin-left: 100px;">Total Coupon : 
                        <asp:Label ID="lbltotalcount" runat="server"></asp:Label></span></td>
                </tr>
            </table>

        </div>
        <div style="text-align: center;">
            <input id="btncouponcode" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnltype" Style="display: none; width: 550px; height: 500px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            <table id="viewtype" style="width: 100%; border-collapse: collapse; text-align: center; height: 87px;">
                <tr>

                    <td class="GridViewHeaderStyle">Issue Type</td>
                    <td class="GridViewHeaderStyle">Issue For</td>

                </tr>
            </table>

        </div>
        <div style="text-align: center;">
            <input id="btntypeclose" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>


    <asp:Panel ID="pnltypewithdata" Style="display: none; width: 550px; height: 500px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls" style="width: 100%; max-height: 400px; overflow: auto;">
            <table id="viewtypewithdata" style="width: 100%; border-collapse: collapse; text-align: center; height: 87px;">
                <tr>
                    <td class="GridViewHeaderStyle">Coupon Code</td>

                    <td class="GridViewHeaderStyle">Issue Type</td>
                    <td class="GridViewHeaderStyle">Issue For</td>

                </tr>
            </table>

        </div>
        <div style="text-align: center;">
            <input id="btntypeclosewithdata" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modeltypewithdata" runat="server" TargetControlID="hidecouponcode" BehaviorID="modeltypewithdata" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnltypewithdata" CancelControlID="btntypeclosewithdata">
    </cc1:ModalPopupExtender>
    <cc1:ModalPopupExtender ID="modeltype" runat="server" TargetControlID="hidecouponcode" BehaviorID="modeltype" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnltype" CancelControlID="btntypeclose">
    </cc1:ModalPopupExtender>
    <asp:Button ID="btnhidereject" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="modalReject" runat="server" TargetControlID="btnHide" BehaviorID="modalReject" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlReject" CancelControlID="btnreject">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlReject" Style="display: none; width: 350px; height: 173px; overflow: auto;" CssClass="pnlVendorItemsFilter" runat="server">
        <div class="Controls">
            <table id="tblReject" style="width: 100%; border-collapse: collapse; text-align: center; height: 87px;">
                <tr>
                    <td class="required">Remark</td>
                    <td>
                        <asp:TextBox ID="txtremark" runat="server" Width="200px"></asp:TextBox></td>
                    <span id="spncouponid" style="display: none;"></span>
                </tr>
            </table>
        </div>
        <div style="text-align: center;">
            <input id="btnrejectsave" type="button" class="searchbutton" value="Save" onclick="RejectCoupon()" />
            <input id="btnreject" type="button" class="searchbutton" value="Cancel" />
        </div>
    </asp:Panel>
    <script type="text/javascript">
        var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypereject = '<%=approvaltypereject %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>';
        var approvaltypeedit = '<%=approvaltypeedit %>';
        var approvaltypenotapproval = '<%=approvaltypenotapproval %>';
        function SearchData() {
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var status = $('#<%=ddlstatus.ClientID%>').val();
            var coupantype = $('#<%=ddlcoupontype.ClientID%>').val();
            var couponcategory = $('#<%=ddlcouponcategory.ClientID%> ').val();
            var coupanname = $('#<%=txtcouponname.ClientID%>').val();
            serverCall('CouponMasterApproval.aspx/SearchData', { fromdate: fromdate, todate: todate, status: status, coupantype: coupantype, couponcategory: couponcategory, coupanname: coupanname }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No Coupon Found");
                    $('#tblcoupon tr').slice(1).remove();
                }
                else {

                    $('#tblcoupon tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {

                        var color = "bisque";
                        if (ItemData[i].approved == "1") {
                            color = 'pink';
                        }
                        else if (ItemData[i].approved == "2") {
                            color = '#90EE90';
                        }
                        else if (ItemData[i].approved == "3") {
                            color = '#FF5722;';
                        }
                        else {
                            color = "bisque";
                        }
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:'); $Tr.push(color); $Tr.push(';" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="itemid" style="display:none;">'); $Tr.push(ItemData[i].coupanid); $Tr.push('</td>');
                        $Tr.push('<td id="serial_number" class="order">'); $Tr.push((i + 1)); $Tr.push('</td>');
                        $Tr.push('<td ><span id="coupanname">'); $Tr.push(ItemData[i].coupanname); $Tr.push(' </span><input type="text" name="txtcoupanname"  style="display:none;"  value='); $Tr.push(ItemData[i].coupanname); $Tr.push(' class="coupanname" /> </td>');
                        $Tr.push('<td> <span id="coupantype">'); $Tr.push(ItemData[i].coupantype); $Tr.push(' </span>  <select id="ddlcoupantype" style="width: 100px;display:none;" class="ddlcptype"><option value='); $Tr.push(ItemData[i].coupantypeid); $Tr.push('>'); $Tr.push(ItemData[i].coupantype); $Tr.push('</option></select></td>');
                        $Tr.push('<td> <span id="coupancategory">'); $Tr.push(ItemData[i].coupancategory); $Tr.push(' </span><select id="ddlcoupancategory" style="width: 100px;display:none;" class="ddlcpcategory"> <option value='); $Tr.push(ItemData[i].coupancategoryid); $Tr.push('>'); $Tr.push(ItemData[i].coupancategory); $Tr.push('</option></select></td>');
                        $Tr.push('<td> <span id="validfrom">'); $Tr.push(ItemData[i].validfrom); $Tr.push(' </span><input type="text"  class="setmydate" name="setvalidfrom" style="display:none; width: 80px;"  value='); $Tr.push(ItemData[i].validfrom); $Tr.push('></td>');
                        $Tr.push('<td> <span id="validto">'); $Tr.push(ItemData[i].validto); $Tr.push(' </span><input type="text"  class="setmydate" name="setvalidto" style="display:none;  width: 80px;"  value='); $Tr.push(ItemData[i].validto); $Tr.push('></td>');
                        $Tr.push('<td id="minbookingamount" style="text-align:right"  >'); $Tr.push(ItemData[i].minbookingamount); $Tr.push('</td>');
                        if (ItemData[i].issuetype == "ALL") {
                            $Tr.push('<td id="issuefor">'); $Tr.push(ItemData[i].issuetype); $Tr.push('</td>');
                        }
                        else if (ItemData[i].issuetype == "UHID" || ItemData[i].issuetype == "Mobile") {
                            $Tr.push('<td id="issuefor">'); $Tr.push(ItemData[i].issuetype); $Tr.push('&nbsp;&nbsp;<img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtype(' + ItemData[i].coupanid + ')"/></td>');
                        }
                        else {
                            $Tr.push('<td id="issuefor">'); $Tr.push(ItemData[i].issuetype); $Tr.push('&nbsp;&nbsp;<img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtypewithdata(' + ItemData[i].coupanid + ')"/></td>');
                        }
                        $Tr.push('<td id="TYPE">'); $Tr.push(ItemData[i].TYPE); $Tr.push('</td>');
                        $Tr.push('<td id="discountamount" style="text-align:right">'); $Tr.push(ItemData[i].discountamount); $Tr.push('</td>');
                        $Tr.push('<td id="discountpercentage" style="text-align:right">'); $Tr.push(ItemData[i].discountpercentage); $Tr.push('</td>');
                        $Tr.push('<td id="centre" style="display:none;">'); $Tr.push(ItemData[i].centre); $Tr.push('</td>');
                        $Tr.push('<td id="ApplicableFor" style="display:none;" >'); $Tr.push(ItemData[i].ApplicableFor); $Tr.push('</td>');
                        $Tr.push('<td id="IsMultipleCouponApply" >'); $Tr.push(ItemData[i].IsMultipleCouponApply + '</td>');
                        $Tr.push('<td>'); $Tr.push(ItemData[i].WeekEnd); $Tr.push('</td>');
                        $Tr.push('<td>'); $Tr.push(ItemData[i].DaysApplicable + '</td>');
                        $Tr.push('<td id="vcen"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewcenter('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        if (ItemData[i].TYPE != "Total Bill") {
                            $Tr.push('<td id="vtest"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtest('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        }
                        else {
                            $Tr.push('<td id="vtest"></td>');
                        }
                        $Tr.push('<td id="vtest"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="ViewCouponCode('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        if (ItemData[i].approved == "0") {

                            if (approvaltypechecker == "1") {
                                $Tr.push('<td id="discountpercentage"  ><input type="button" value="Check" class="resetbutton" onclick="Approved('); $Tr.push(ItemData[i].coupanid); $Tr.push(',1)"/></td>');
                            }
                            else {
                                $Tr.push('<td></td>');
                            }
                            if (approvaltypereject == "1") {
                                $Tr.push('<td   ><input type="button" value="Reject" class="searchbutton" onclick="ShowReject('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                            }
                            else {
                                $Tr.push('<td></td>');
                            }
                        }
                        else if (ItemData[i].approved == "1") {
                            if (approvaltypeapproval == "1") {
                                $Tr.push('<td id="discountpercentage"  ><input type="button" value="Approve" class="savebutton" onclick="Approved('); $Tr.push(ItemData[i].coupanid); $Tr.push(',2)"/></td>');
                            }
                            else {
                                $Tr.push('<td></td>');
                            }
                            if (approvaltypereject == "1") {
                                $Tr.push('<td   ><input type="button" value="Reject" class="searchbutton" onclick="ShowReject('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                            }
                            else {
                                $Tr.push('<td></td>');
                            }
                        }
                        else if (ItemData[i].approved == "3") {
                            $Tr.push('<td ></td>');
                            $Tr.push('<td >'); $Tr.push(ItemData[i].Remark); $Tr.push('</td>');
                        }
                        else if (ItemData[i].approved == "2") {
                            if (approvaltypenotapproval == "1") {
                                $Tr.push('<td id="discountpercentage"  ><input type="button" value="Not Approved" class="resetbutton" onclick="Approved('); $Tr.push(ItemData[i].coupanid); $Tr.push(',0)"/></td>');
                            }
                            else {
                                $Tr.push('<td></td>');
                            }
                        }
                        else {
                            $Tr.push('<td ></td>');
                            $Tr.push('<td ></td>');
                        }
                        if (approvaltypeedit == "1") {
                            if (ItemData[i].LedgertransactionNo == "" && ItemData[i].approved != "3" && ItemData[i].approved != "2") {
                                $Tr.push('<td ><input type="button" id="btnedit" value="Edit" class="searchbutton"  onclick="EditData(this)"/>');
                                $Tr.push('<input type="button" id="btnupdate" value="Update" class="searchbutton" style="display:none;" onclick="UpdateData(this)"/>');
                                $Tr.push('<input type="button" id="btncancel" value="Cancel" class="searchbutton" style="display:none;" onclick="CancelData(this)"/></td>');
                            }
                            else {
                                $Tr.push('<td ></td>');
                            }
                        }
                        $Tr.push('<td ></td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#tblcoupon').append($Tr);
                    }
                    $('.ddlcptype').append($('#<%=lblcoupontype.ClientID%>').html());
                    $('.ddlcpcategory').append($('#<%=lblcouponcategory.ClientID%>').html());
                    $(".setmydate").datepicker("destroy");
                    $('#tblcoupon').on('focus', ".setmydate", function () {
                        $(this).datepicker({
                            dateFormat: "dd-M-yy",
                            changeMonth: true,
                            changeYear: true, yearRange: "-20:+0"

                        }).attr('readonly', 'readonly');
                    });
                }
            });
        }
    </script>
    <script type="text/javascript">
        function viewtest(couponID) {
            serverCall('CouponMasterApproval.aspx/BindTestModal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No test Found");
                }
                else {
                    $('#viewtest tr').slice(1).remove();
                    var total = 0;
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="mtest" align="left">'); $Tr.push(ItemData[i].typename); $Tr.push('</td>');
                        $Tr.push('<td  id="mtestdisper">'); $Tr.push(ItemData[i].discper); $Tr.push('</td>');
                        $Tr.push('<td  id="mtestdisamt">'); $Tr.push(ItemData[i].discamount); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        total += ItemData[i].discamount;
                        $('#viewtest').append($Tr);
                    }
                    $('#viewtest').append('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody"><td></td><td><b>Total Amount</b> </td><td><b>' + total + '</b></td>')
                    $find("modalCentre1").show();
                }
            });
        }
        function viewcenter(couponID) {
            serverCall('CouponMasterApproval.aspx/BindCenterModal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No center Found");
                }
                else {
                    $('#viewcenter tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].Centre); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewcenter').append($Tr);
                    }
                    $find("modalCentre").show();
                    $('#<%=lbltotalcountcentre.ClientID%>').text(ItemData.length);
                }
            });
        }
        function ViewCouponCode(couponID) {
            serverCall('CouponMasterApproval.aspx/BindCouponCodeModal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No center Found");
                }
                else {
                    $('#tblcouponcode tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center" style="text-align:left;">'); $Tr.push(ItemData[i].coupancode); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#tblcouponcode').append($Tr);
                    }
                    $find("modalcouponcode").show();
                    $('#<%=lbltotalcount.ClientID%>').text(ItemData.length);
                 }
             });
         }
    </script>
    <script type="text/javascript">
        function Approved(couponID, Status) {
            serverCall('CouponMasterApproval.aspx/Approved', { CouponID: couponID, Status: Status }, function (response) {
                var data = response;
                if (data.split('#')[0] == "1") {
                    toast('Success', data.split('#')[1]);
                    SearchData();
                }
                else {
                    toast('Error', data.split('#')[1]);
                }
            });
        }
        function ShowReject(coupanid) {
            $('#spncouponid').html(coupanid);
            $find("modalReject").show();
        }
        function RejectCoupon() {
            var couponID = $('#spncouponid').html();
            var Remark = $('#<%=txtremark.ClientID%>').val();
            if (Remark == "") {
                toast('Error', "Please Fill Remark");
                return;
            }
            serverCall('CouponMasterApproval.aspx/RejectCoupon', { CouponID: couponID, Remark: Remark }, function (response) {
                var data = response;
                toast('Success', data);
                $find("modalReject").hide();
                $('#spncouponid').html("");
                $('#<%=txtremark.ClientID%>').val("");
                SearchData();
            });
        }
    </script>
    <script type="text/javascript">
        function EditData(ctrl) {
            var coupanid = $(ctrl).closest('tr').find("#itemid").html();
            openmypopup("couponmasteredit.aspx?CouponId=" + coupanid);
        }
        function UpdateData(ctrl) {
            var UpdateCoupan = new Object();
            UpdateCoupan.coupanId = $(ctrl).closest('tr').find("#itemid").text();
            UpdateCoupan.coupanName = $(ctrl).closest('tr').find("input[name='txtcoupanname']").val()
            UpdateCoupan.coupanTypeId = $(ctrl).closest('tr').find("#ddlcoupantype option:selected").val();
            UpdateCoupan.coupanType = $(ctrl).closest('tr').find("#ddlcoupantype option:selected").text();
            UpdateCoupan.coupanCategoryId = $(ctrl).closest('tr').find("#ddlcoupancategory option:selected").val();
            UpdateCoupan.coupanCategory = $(ctrl).closest('tr').find("#ddlcoupancategory option:selected").text();
            UpdateCoupan.validFrom = $(ctrl).closest('tr').find("input[name='setvalidfrom']").val();
            UpdateCoupan.validTo = $(ctrl).closest('tr').find("input[name='setvalidto']").val();
            serverCall('CouponMasterApproval.aspx/UpdateData', { objupdate: UpdateCoupan }, function (response) {
                toast('Success', response);
                SearchData();
            });
        }
        function openmypopup(href) {
            var width = '1200px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
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
    </script>
    <script type="text/javascript">
        $(function () {
            $('#ContentPlaceHolder1_txtcentresearch').keyup(function () {
                var search = $(this).val();
                $('#viewcenter tr:not(:first)').hide();
                var len = $('#viewcenter tr:not(:first) td:nth-child(1):contains("' + search + '")').length;

                if (len > 0) {

                    $('#viewcenter tr:not(.notfound) td:contains("' + search + '")').each(function () {
                        $(this).closest('tr').show();
                    });
                }

            });

            $('#ContentPlaceHolder1_txtcouponsearch').keyup(function () {
                var search = $(this).val();
                $('#tblcouponcode tr:not(:first)').hide();
                var len = $('#tblcouponcode tr:not(:first) td:nth-child(1):contains("' + search + '")').length;

                if (len > 0) {

                    $('#tblcouponcode tr:not(.notfound) td:contains("' + search + '")').each(function () {
                        $(this).closest('tr').show();
                    });
                }

            });

        });
        // Case-insensitive searching (Note - remove the below script for Case sensitive search )
        $.expr[":"].contains = $.expr.createPseudo(function (arg) {
            return function (elem) {
                return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
            };
        });
    </script>
    <script type="text/javascript">
        function viewtypewithdata(couponID) {
            serverCall('coupon_master.aspx/bindtypemodalwithdata', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No Data Found");
                }
                else {
                    $('#viewtypewithdata tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].coupancode); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].issuetype); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].issuevalue); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewtypewithdata').append($Tr);
                    }
                    $find("modeltypewithdata").show();
                }
            });
        }
        function viewtype(couponID) {
            serverCall('coupon_master.aspx/bindtypemodalbindtypemodal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No Data Found");
                }
                else {
                    $('#viewtype tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');

                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].type); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].value); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewtype').append($Tr);
                    }
                    $find("modeltype").show();
                }
            });

        }
    </script>
</asp:Content>

