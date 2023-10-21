<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="ChangeReportType.aspx.cs" Inherits="Design_Lab_ChangeReportType" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <script src="../../Scripts/jquery-3.1.1.min.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <script src="../../Scripts/toastr.min.js"></script>

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">

    <%: Scripts.Render("~/bundles/confirmMinJS") %>
</head>
<body>

    <form id="form1" runat="server">

        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="Change Report Type" Font-Size="16px" Font-Bold="true"></asp:Label><br />
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Change Report Type</div>

            <div class="row">
                <div class="col-md-6">
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Lab No.  </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLabNo" runat="server" MaxLength="15" class="requiredField" type="text" data-title="Enter Visit No." autocomplete="off"></asp:TextBox>
                </div>
                <div class="col-md-12">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata('BT')" />
                </div>
            </div>

        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Prescribed Investigation
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle" style="text-align: center;">#</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Test ID</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Investigation ID</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Item Name</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;display:none;">PlO Data</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Date</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;display:none">LabNo</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Select</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" id="payDetail" style="display: none">
            <div class="Purchaseheader">&nbsp;&nbsp;&nbsp;  </div>
            <%--<div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Report Type  </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlReportType" runat="server">
                       <asp:ListItem Value="1">Path Numeric</asp:ListItem>
                       <asp:ListItem Value="3">Path RichText</asp:ListItem>
                <asp:ListItem Value="7">Histo Report</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>--%>
           
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <input type="button" value="Save" class="searchbutton" onclick="savedata()" id="btnSave" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            function searchdata(callFrom) {

                $('#tb_ItemList tr').slice(1).remove();
                var LabNo = "";
                if (callFrom.trim() == 'BT') {
                    LabNo = $('#txtLabNo').val();
                }
                else {
                    LabNo = $('#lblLabNoToSave').html();
                }
                if (LabNo == "") {
                    toast("Info", "Please Enter Visit No", "");
                    $('#txtLabNo').focus();
                    clearAllTextBox();
                    return;
                }

                serverCall('ChangeReportType.aspx/searchdata', { LabNo: LabNo }, function (response) {

                    var TestData = JSON.parse(response);
                    if (TestData.length != 0) {
                        $('#lblLabID').html(TestData[0].LedgerTransactionID);
                        $('#btnSave,#pDetails,#payDetail').show();

                        for (var i = 0; i <= TestData.length - 1; i++) {
                            var mydata = [];

                            mydata.push("<tr>");
                            mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">');
                            mydata.push(parseInt(i + 1));
                            mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdTest_ID" >'); mydata.push(TestData[i].Test_ID); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(TestData[i].Investigation_Id); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(TestData[i].ItemName); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" style="display:none" id="tdItemid" >'); mydata.push(TestData[i].ItemId); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;">'); mydata.push(TestData[i].DATE); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" style="display:none"; id="tdLedgerNo">'); mydata.push(TestData[i].LedgerTransactionNo); mydata.push('</td>');
                           
                            mydata.push('<td class="GridViewLabItemStyle" style="text-align:center;" >  <input id="chkItem" type="checkbox" ');
                            
                        mydata.push("></td></tr>");
                        mydata = mydata.join('');
                        $('#tb_ItemList').append(mydata);
                    }
                }
                else {
                    clearAllTextBox();
                    toast("Info", "No Record Found", "");

                    return false;
                }
                $modelUnBlockUI(function () { });
            });
        }

        function validation() {
            //if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#txtCardNo').val() == "") {
            //    toast("Error", "Please Enter Card Detail", "");
            //    $("#txtCardNo").focus();
            //    return false;
            //}
            //if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#txtCardDate').val() == "") {
            //    toast("Error", "Please Enter Card Detail", "");
            //    $("#txtCardDate").focus();
            //    return false;
            //}
            //if ($("#ddlPaymentMode").val() != "1" && $("#ddlPaymentMode").val() != "8" && $('#ddlBank').val() == "0") {
            //    toast("Error", "Please Select Bank", "");
            //    $("#ddlBank").focus();
            //    return false;
            //}
            //if ($('#txtReason').val().trim() == '') {
            //    toast("Error", "Please Enter Refund Reason", "");
            //    $('#txtReason').focus();
            //    return false;
            //}
            //if ($('#ddlRefundBy').val() == '') {
            //    toast("Error", "Please Select Refund By", "");
            //    $('#ddlRefundBy').focus();
            //    return false;
            //}
            return true
        }

        function savedata() {
            var PLOdata = patientlabinvestigationopd();
            if (PLOdata.length == 0) {
                toast("Error", "Please Select Item to Change Report Type", "");
                return false;
            }
            if (validation() == false)
                return;
            confirmRefund('Confirmation', 'Are you sure to Change Report Type', PLOdata);


        }
        //function showpaymentoption() {
        //    if ($('#ddlPaymentMode').val() == "1") {
        //        $('#trPayment').hide();
        //    }
        //    else if ($('#ddlPaymentMode').val() == "8") {
        //        $('#trPayment').hide();
        //    }
        //    else {
        //        $('#trPayment').show();
        //    }
        //}

        function clearAllTextBox() {
            $("#txtReason").val('');
            $('#ddlPaymentMode,#ddlPayBy').prop('selectedIndex', 0);
            $('.PatientLabel').html('');
            $('#btnSave,#pDetails,#payDetail').hide();
        }

        </script>
        <%--Set All Property--%>
        <script type="text/javascript">
            function patientlabinvestigationopd() {
                var dataPLO = new Array();
                $('#tb_ItemList tr').not(":first").each(function () {
                    var checkedornot = $(this).closest('tr').find("#chkItem").is(':checked');
                    if (checkedornot == true) {
                        var objPLO = new Object();
                        objPLO.Test_ID = $(this).find('#tdTest_ID').html();
                        objPLO.LabID = $(this).find('#tdLedgerNo').html();
                        objPLO.ItemID = $(this).find('#tdItemid').html();
                        objPLO.Reporttype = $('#ddlReportType').val();
                        dataPLO.push(objPLO);
                    }
                });
                return dataPLO;
            }

        </script>
        <script type="text/javascript">
            function confirmRefund(title, content, PLOdata) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: "".concat('<b>', content, '<b/>'),
                    animation: 'zoom',
                    closeAnimation: 'scale',
                    useBootstrap: false,
                    opacity: 0.5,
                    theme: 'light',
                    type: 'red',
                    typeAnimated: true,
                    boxWidth: '420px',
                    buttons: {
                        'confirm': {
                            text: 'Yes',
                            useBootstrap: false,
                            btnClass: 'btn-blue',
                            action: function () {
                                serverCall('ChangeReportType.aspx/SaveOPDRefund', { PLO: PLOdata }, function (response) {
                                    var $responseData = JSON.parse(response);
                                    if ($responseData.status) {
                                        toast("Success", $responseData.response, "");
                                        $("#txtReason").val('');
                                        $('#ddlPaymentMode,#ddlPayBy').prop('selectedIndex', 0);
                                        $('#btnSave,#payDetail').hide();
                                    }
                                    else {
                                        toast("Error", $responseData.response, "");
                                    }
                                    $modelUnBlockUI(function () { });
                                });
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearActions();
                            }
                        },
                    }
                });

            }
            function clearActions() {
            }
        </script>
    </form>
</body>
</html>

