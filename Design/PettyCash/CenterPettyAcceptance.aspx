<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CenterPettyAcceptance.aspx.cs" Inherits="Design_PettyCash_CenterPettyAcceptance" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Petty Cash Acceptance</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Center</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlcenter" runat="server" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-1">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-1">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12"></div>
                <div class="col-md-2" style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="Bindtabledata();" />
                </div>
                <div class="col-md-4" style="text-align: center"></div>

                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: Pink; border-radius: 9px; cursor: pointer" onclick="AllExpances(0);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllExpances(0)">New</span>
                </div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: #90EE90; border-radius: 9px; cursor: pointer" onclick="AllExpances(1);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllExpances(1)">Accept</span>
                </div>
                <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: aqua; border-radius: 9px; cursor: pointer" onclick="AllExpances(2);">
                </div>
                <div class="col-md-1">
                    <span onclick="AllExpances(2)">Reject</span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expense Detail
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <div style="width: 100%; max-height: 375px; overflow: auto;">
                        <div style="width: 100%;">
                            <table id="transfertable" style="border-collapse: collapse; width: 100%;">
                                <thead>
                                    <tr id="tr1">
                                        <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Center Code</td>
                                        <td class="GridViewHeaderStyle" style="width: 160px;">Center Name</td>
                                        <td class="GridViewHeaderStyle" style="width: 60px;">Amount</td>
                                        <td class="GridViewHeaderStyle" style="width: 90px;">Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">CreatedBy</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">Type</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Payment Mode</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Bank</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Card No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 80px;">Receipt</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Action</td>
                                        <td class="GridViewHeaderStyle" style="width: 200px;">Remark</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function Bindtabledata() {
            if ($('#ddlcenter').val() == "0") {
                toast("Error", "Please Select Center");
                $('#ddlcenter').focus();
                return false;
            }
            serverCall('CenterPettyAcceptance.aspx/bindtable', { centerid: $('#ddlcenter').val(), fromdate: $('#txtentrydatefrom').val(), todate: $('#txtentrydateto').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    getDetails($responseData);
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function AcceptPettyledger(id, value) {
            if (value == "2") {
                $.confirm({
                    title: 'Confirmation!',
                    useBootstrap: false,
                    closeIcon: true,
                    columnClass: 'small',
                    type: 'red',
                    typeAnimated: true,
                    animationBounce: 2,
                    boxWidth: '480px',
                    content: '' +
                    '<form action="" class="formName">' +
                    '<div class="form-group">' +
                    '<label>Enter Reject Reason</label>' +
                    '<input type="text" placeholder="Your Reject Reason" class="name form-control" required />' +
                    '</div>' +
                    '</form>',
                    buttons: {
                        formSubmit: {
                            text: 'Submit',
                            btnClass: 'btn-blue',
                            action: function () {
                                var name = this.$content.find('.name').val();
                                if (!name) {
                                    toast('Error', 'Please Enter Reject Reason');
                                    this.$content.find('.name').focus();
                                    return false;
                                }
                                UpdatePettyledger(id, value, name)
                            }
                        },
                        cancel: function () {
                            //close
                        },
                    },
                    onContentReady: function () {
                        var jc = this;
                        this.$content.find('form').on('submit', function (e) {
                            e.preventDefault();
                            jc.$$formSubmit.trigger('click'); // reference the button and click it
                        });
                    }
                });
            }
            else {
                UpdatePettyledger(id, value, '');
            }
        }
        function UpdatePettyledger(id, value, txt) {
            serverCall('CenterPettyAcceptance.aspx/UpdatePettyledger', { id: id, val: value, region: txt }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    getDetails($responseData);
                }
                else {
                    toast("Error", $responseData.response);

                }
            });
        }
        function Acceptance(i, tableid, ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            var value = i;
            var txt = "";
            AcceptPettyledger(id, value);
        }
        function getDetails($responseData) {
            var grossamt = 0;
            var ItemData = jQuery.parseJSON($responseData.responseDetail);

            if (ItemData.length == 0) {
                toast("Info", "No Data Found");
            }
            else {
                $('#transfertable tr').slice(1).remove();
                for (var i = 0; i <= ItemData.length - 1; i++) {
                    grossamt = parseFloat(grossamt) + ItemData[i].amount;
                    var $myData = [];
                    $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].rowColor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("'>");
                    $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                    $myData.push('<td>'); $myData.push(ItemData[i].centrecode); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].centre); $myData.push('</td>');
                    $myData.push('<td style="text-align:right">'); $myData.push(Math.abs(ItemData[i].amount)); $myData.push('</td>');
                    $myData.push('<td>'); $myData.push(ItemData[i].DATE); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].createby); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].TYPE); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].paymentmode); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Bank); $myData.push('</td>');
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].CardNo); $myData.push('</td>');
                    if (ItemData[i].Filename != "") {
                        $myData.push('<td><a href="'); $myData.push(ItemData[i].Filename); $myData.push('" target="_blank"> View</a></td>');
                    }
                    else
                        $myData.push('<td></td>');
                    if (ItemData[i].IsApproved == "0") {
                        $myData.push('<td  class="GridViewLabItemStyle" ><input type="button" value="Accept" id="accept" class="searchbutton" onclick="Acceptance(1,\''); $myData.push(ItemData[i].id); $myData.push('\',this)" />  <input type="button" value="Reject" id="reject" class="resetbutton" onclick="Acceptance(2,\''); $myData.push(ItemData[i].id); $myData.push('\',this)" /> </td>');
                    }
                    else {
                        $myData.push('<td></td>');
                    }
                    $myData.push('<td style="text-align:left">'); $myData.push(ItemData[i].Remarks); $myData.push('</td>');
                    $myData.push('</tr>');
                    $myData = $myData.join("");
                    $('#transfertable').append($myData);
                }
                var $myData1 = [];
                $myData1.push("<tr id='footer' style='font-weight:bold;color:red;'>");
                $myData1.push('<td colspan="3" align="right">Total::&nbsp;&nbsp;&nbsp;&nbsp;</td>');
                $myData1.push('<td>'); $myData1.push(grossamt); $myData1.push('</td>');
                $myData1.push("</tr>");
                $myData1 = $myData1.join("");
                $('#transfertable').append($myData1);
            }
        }
    </script>
    <script type="text/javascript">
        function AllExpances(status) {
            $('#transfertable tr').slice(1).remove();
            serverCall('CenterPettyAcceptance.aspx/bindtablewithstatus', { status: status }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    getDetails($responseData);
                }
                else {
                    toast("Info", $responseData.response);
                }
            });
        }
        $(function () {
            $("#ddlcenter").chosen("destroy").chosen({ width: '100%' });
        });
    </script>
</asp:Content>