<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="EditBatch.aspx.cs" Inherits="Design_Lab_EditBatch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <style>
            .ModalPop {
                position: fixed;
                top: 25%;
                left: 25%;
                width: 750px;
                height: 200px;
                border: 1px solid #ccc;
                background-color: #fff;
                display: none;
                z-index: 99999;
            }
            .BackOverlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                opacity: 0.5;
                z-index: 9999;
                background-color: #000;
                display: none;
            }
        </style>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Edit Batch</b>
            <br />
            <div style="float: right; clear: both;" id="div_pcount"></div>

            <span id="spnBatchNo" style="display: none"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Batch Number   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtBatchNo" CssClass="requiredField" runat="server" MaxLength="20"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory batchItem" style="display: none">
            <div class="row">
                <div id="batchItems" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <tr id="BatchHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Batch No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">SIN No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Vials Qty.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Age</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Gender</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 110px;">Sample Type</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 180px;">Test</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Status</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Remove</th>
                        </tr>

                    </table>
                </div>
            </div>
            <input type="button" id="btnAdd" value="Add" onclick="addBatch()" style="display: none" />
        </div>
        <div class="POuter_Box_Inventory batchItem" style="display: none">
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td style="text-align: right">Sin No. :&nbsp;
                    </td>
                    <td>
                        <input type="text" id="txtSinNo" style="width: 120px" />
                    </td>
                    <td style="text-align: right">Add Batch :&nbsp;
                    </td>
                    <td>
                        <input type="text" id="txtAddedBatchNo" style="width: 120px" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="BackOverlay" id="modalBackOverlay"></div>
    <div id="divModalSample" class="ModalPop" style="display: none;">
        <div style="float: left; width: 100%; text-align: center; margin-top: 0px; height: 160px; overflow: auto;">
            <table id="tblSample" width="100%">
                <tr>
                    <th class="GridViewHeaderStyle">S.No.
                    </th>
                    <th class="GridViewHeaderStyle">BarcodeNo
                    </th>
                    <th class="GridViewHeaderStyle">Test
                    </th>
                    <th class="GridViewHeaderStyle">FromCentre
                    </th>
                    <th class="GridViewHeaderStyle">ToCentre
                    </th>
                </tr>

            </table>
        </div>
        <div style="float: left; width: 100%; text-align: center; margin-top: 10px;">
            <input type="button" id="btnSave" onclick="$mergeBatch();" value="Add Batch" />
            <input type="button" id="btnClose" onclick="$closePop();" value="Close" />
            <asp:HiddenField ID="ddlCentre" runat="server" Value="0" />
        </div>
    </div>
    <script type="text/javascript">
        var $filterData = new Array();
        jQuery(function () {
            if (jQuery('#txtBatchNo').val() != "") {
                searchBatchDetail();
            }
            jQuery('form').on('keyup keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    e.preventDefault();
                    return false;
                }
            });
            jQuery('#txtBatchNo').on('keyup', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    searchBatchDetail();
                }
            });
            jQuery('#txtSinNo').on('keyup', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    $addBatch();
                }
            });
        });
    </script>
    <script type="text/javascript">
        function searchBatchDetail() {
            if (jQuery.trim(jQuery("#txtBatchNo").val()) != "") {
                serverCall('EditBatch.aspx/BatchSearch', { BatchNo: jQuery("#txtBatchNo").val() }, function (response) {
                    batchData = JSON.parse(response);
                    if (batchData == "-1") {
                        toast('Error','Unable To Edit Batch');
                        jQuery('.batchItem').hide();
                        if (jQuery('#tbSelected tr:not(#BatchHeader)').length == 0) {
                            jQuery('#tbSelected').hide();
                        }
                        return;
                    }
                    if (batchData.length != 0) {
                        jQuery('#tbSelected').css('display', 'block');
                        jQuery("#tbSelected tr:not(#BatchHeader)").remove();
                        for (var i = 0; i < batchData.length; i++) {

                            


                            var $myData = [];
                            $myData.push("<tr>");
                            $myData.push('<td class="GridViewItemStyle">');
                            $myData.push((i + 1));
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push('<span id="spnsampleLogisticID" style="display:none">');
                            $myData.push(batchData[i].sampleLogisticID); $myData.push('</span>');
                            $myData.push('<span id="spntdBatchNo" style="display:none">');
                            $myData.push(batchData[i].DispatchCode); $myData.push('</span>');
                            $myData.push('<span id="spnSinNo" style="display:none">');
                            $myData.push(batchData[i].BarcodeNo); $myData.push('</span>');
                            $myData.push(batchData[i].DispatchCode); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].BarcodeNo); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center">');
                            $myData.push(batchData[i].Quantity); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].PName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].Age); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center">');
                            $myData.push(batchData[i].Gender); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].SampleTypeName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].Test); $myData.push('</td>');
                            $myData.push(' <td class="GridViewLabItemStyle">');
                            $myData.push(batchData[i].Status); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center">');$myData.push('<span id="spntest_id" style="display:none">');
                            $myData.push(batchData[i].test_id);$myData.push('</span>');
                            var dataToAppend = '<tr>';
                            if (batchData[i].Status == 'Pending for Dispatch') {
                                $myData.push('<img id="imgRemove" onclick="$removeSinNo(this)"  src="../../App_Images/Delete.gif" style="cursor:pointer" title="Click to Remove"/>');
                            }
                            $myData.push('</td> </tr>');
                            $myData = $myData.join("");
                            jQuery('#tbSelected').append($myData);
                          
                        }
                        $filterData = new Array();
                        var $objFilter = new Object();
                        $objFilter.BarcodeNo = batchData[0].BarcodeNo;
                        $objFilter.ToCentreID = batchData[0].ToCentreID;
                        $objFilter.BatchNo = batchData[0].DispatchCode;
                        $objFilter.Status = batchData[0].Status;
                        $objFilter.FieldBoyID = batchData[0].PickUpFieldBoyID;
                        $objFilter.FieldBoy = batchData[0].PickUpFieldBoy;
                        $objFilter.CourierDetail = batchData[0].CourierDetail;
                        $objFilter.CourierDocketNo = batchData[0].CourierDocketNo;
                        $filterData.push($objFilter);
                        jQuery("#spnBatchNo").text(jQuery("#txtBatchNo").val());
                        jQuery('.batchItem').show();
                        jQuery("#txtSinNo").focus();
                    }
                    else {
                        toast('Info','No Record Found');
                        jQuery('.batchItem').hide();
                        if (jQuery('#tbSelected tr:not(#BatchHeader)').length == 0) {
                            jQuery('#tbSelected').hide();
                        }
                    }
                });               
            }
            else {
                toast('Error', 'Please Enter Batch No.');
            }
        }
    </script>
    <script type="text/javascript">
        function $remove(sampleLogisticID, BatchNo, SinNo, testid) {
            serverCall('EditBatch.aspx/updateLogistic', { sampleLogisticID: sampleLogisticID, BatchNo: BatchNo, SinNo: SinNo, testid: testid }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status)
                    toast('Success',$responseData.response); 
                else
                    toast('Error', $responseData.response);
            });
        }
        function $removeSinNo(rowid) {
            $remove(jQuery(rowid).closest('tr').find("#spnsampleLogisticID").text(), jQuery(rowid).closest('tr').find("#spntdBatchNo").text(), jQuery(rowid).closest('tr').find("#spnSinNo").text(), jQuery(rowid).closest('tr').find("#spntest_id").text());

            jQuery(rowid).closest('tr').remove();
            if (jQuery('#tbSelected tr:not(#BatchHeader)').length == 0) {
                jQuery('#tbSelected,.batchItem').hide();
            }
        }
    </script>
    <script type="text/javascript">
        function $addBatch() {
            if (jQuery.trim(jQuery("#txtSinNo").val()) != "") {
                serverCall('EditBatch.aspx/addBatch', { SinNo: $.trim($("#txtSinNo").val()), data: $filterData }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $responseData = jQuery.parseJSON($responseData.response);
                        var tableLength = jQuery("#tbSelected tr").length
                        for (var i = 0; i < $responseData.length; i++) {
                            var $myData = [];
                            $myData.push("<tr>");
                            $myData.push('<td class="GridViewItemStyle">');
                            $myData.push(tableLength);
                            $myData.push('</td><td class="GridViewItemStyle ">');
                            $myData.push('<span id="spnsampleLogisticID" style="display:none">');
                            $myData.push($responseData[i].sampleLogisticID); $myData.push('</span>');
                            $myData.push('<span id="spntdBatchNo" style="display:none">');
                            $myData.push($responseData[i].DispatchCode); $myData.push('</span>');
                            $myData.push('<span id="spnSinNo" style="display:none">');
                            $myData.push($responseData[i].BarcodeNo); $myData.push('</span>');
                            $myData.push($responseData[i].DispatchCode);
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].BarcodeNo); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center">');
                            $myData.push($responseData[i].Quantity); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].PName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].Age); $myData.push('</td>');
                            $myData.push(' <td class="GridViewLabItemStyle" style="text-align:center">');
                            $myData.push($responseData[i].Gender); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].SampleTypeName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].Test); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                            $myData.push($responseData[i].Status); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRemove" onclick="$removeSinNo(this)"  src="../../App_Images/Delete.gif" style="cursor:pointer" title="Click to Remove"/></td>');
                            $myData.push('</tr>');
                            $myData = $myData.join("");
                            jQuery('#tbSelected').append($myData);
                        }
                        $("#txtSinNo").val('');
                        $("#txtSinNo").focus();
                    }
                    else {
                        toast('Error', $responseData.response);
                    }
                    
                });               
            }
            else {
                toast("Info", "Please Enter Sin No.", "");
            }
        }
    </script>
    <script type="text/javascript">
        //----------- Add batch to batch by Apurva
        $(function () {
            $('#txtAddedBatchNo').keyup(function (e) {
                if (e.which == 13) {
                    $openPopUp();
                }
            });
        });
        function $openPopUp() {
            var $transferredTo = $('[id$=ddlCentre]').val();
            var $batchNo = $('[id$=txtBatchNo]').val().trim();
            var $batchToAdd = $('[id$=txtAddedBatchNo]').val().trim();
            if ($batchToAdd != "") {
                if ($transferredTo == "") {
                    toast("Error", "Please Select Centre", "");
                    return;
                }
                serverCall('SendSample.aspx/OpenPopup', { BatchToAdd: $batchToAdd, BatchNo: $batchNo, TransferredTo: $transferredTo }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        data = $responseData.response;
                        if (data.length > 0) {
                            $('#tblSample tr').slice(1).remove();
                            $('#txtBatchNo').val(data[0].BatchNo);
                            for (var i = 0; i < data.length; i++) {
                                var $myData = [];
                                $myData.push("<tr>");
                                $myData.push('<td class="GridViewItemStyle">');
                                $myData.push((i + 1));
                                $myData.push('</td><td class="GridViewItemStyle">');
                                $myData.push(data[i].BarcodeNo);
                                $myData.push('</td><td class="GridViewItemStyle">');
                                $myData.push(data[i].InvestigationName);
                                $myData.push('</td><td class="GridViewItemStyle">');
                                $myData.push(data[i].FromCentre);
                                $myData.push('</td><td class="GridViewItemStyle">');
                                $myData.push(data[i].ToCentre);
                                $myData.push('</td></tr>');
                                $myData = $myData.join("");
                                jQuery('#tblSample').append($myData);
                            }
                            $('#divModalSample').show();
                            $('#modalBackOverlay').show();
                        }
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                });               
            } else {
                $('#divModalSample').hide();
                $('#modalBackOverlay').hide();
                toast("Error", "Please enter Batch no to be added", "");
            }
        }
        function $mergeBatch() {
            var $transferredTo = $('#ddlCentre').val();
            var $batchNo = $('#txtBatchNo').val().trim();
            var $batchToAdd = $('#txtAddedBatchNo').val().trim();
            if ($batchToAdd != "") {
                if ($transferredTo == "") {
                    toast("Info", "Please Select Centre", "");
                    return;
                }
                var _temp = [];
                _temp.push(serverCall('SendSample.aspx/AddBatchToBatch', { BatchToAdd: $batchToAdd, BatchNo: $batchNo, TransferredTo: $transferredTo }, function (response) {
                    $.when.apply(null, _temp).done(function () {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            searchBatchDetail();
                            $('#txtAddedBatchNo').val('');
                        }
                        $('#divModalSample').hide();
                        $('#modalBackOverlay').hide();
                    });

                }));
            } else {
                toast("Error", "Please Enter Batch No to be added", "");
            }
        }
        function $closePop() {
            $('#divModalSample').hide();
            $('#modalBackOverlay').hide();
        }
    </script>
</asp:Content>

