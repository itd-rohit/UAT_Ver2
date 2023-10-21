<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="LogisticSampleReceive.aspx.cs" Inherits="Design_Lab_LogisticSampleReceive" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <style type="text/css">
        div#divPending {
            height: 200px;
            overflow: hidden;
        }

        .NoColor {
            background-color: #fff !important;
        }

        .PinkRow {
            background-color: pink !important;
        }

        .OrangeRow {
            background-color: orange !important;
        }
        .bisqueRow {
        background-color:bisque !important;
        
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Logistic Sample Receive</b>
            <br />
            <div style="float: right; clear: both;" id="div_pcount"></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">From Centre </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:DropDownList ID="ddlCentre"  runat="server" CssClass="ddlCentre chosen-select chosen-container">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Batch Number </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtBatchNo" runat="server" MaxLength="20"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Route No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtBarcode" runat="server" MaxLength="20"></asp:TextBox>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Field Boy </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:DropDownList ID="ddlFieldBoy" runat="server" CssClass="ddlCentre chosen-select chosen-container">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate">
                    </cc1:CalendarExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input id="btnSearch" type="button" value="Search" class="ItDoseButton" onclick="$searchPendingBatch();" />
        </div>
        <div class="POuter_Box_Inventory">
            <div>
                <div id="divPending"></div>
            </div>
        </div>
        <div id="divSinInfo" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 886px; max-width: 50%">
                    <div class="modal-header">
                        <div class="row">
                            <div class="col-md-12" style="text-align: left">
                                <h4 class="modal-title">Cancel Send Sample</h4>
                            </div>

                            <div class="col-md-12" style="text-align: right">
                                <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                    <button type="button" class="closeModel" onclick="$closeSinModel()" aria-hidden="true">&times;</button>to close</span></em>
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div id="divSendSampleDetail" style="overflow: auto; height: 460px">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">
        $(function () {
            jQuery('#ddlFieldBoy,#ddlCentre').chosen("destroy").chosen({ width: '100%' });
        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divSinInfo').is(':visible')) {
                    jQuery('#divSinInfo').hideModel();
                }

            }

        }
        var $closeSinModel = function (callback) {
            $('#divSinInfo').hideModel();
        }
        var $pendingBatch;
        function $searchPendingBatch() {
            $('#divPending').css('height', '200px');
            $filterData = new Array();
            var objFilter = new Object();
            objFilter.FromCentreID = (($('#ddlCentre').val() == "") ? "0" : $('#ddlCentre').val());
            objFilter.BatchNo = $('#txtBatchNo').val();
            objFilter.FromDate = $('#txtFromDate').val();
            objFilter.ToDate = $('#txtToDate').val();
            $filterData.push(objFilter);
            serverCall('LogisticSampleReceive.aspx/BatchSearch', { data: $filterData }, function (response) {
                $pendingBatch = JSON.parse(response);
                var container1 = document.getElementById('divPending');
                $(container1).html('');
                hot2 = new Handsontable(container1, {
                    data: $pendingBatch,
                    colHeaders: [
               "#", "Batch No.", "Vials Qty.", "Trans. Centre", "Field Boy", "Courier Detail", "Docket No.", "Status", "Send Date", "View"
                    ],
                    readOnly: true,
                    currentRowClassName: 'currentRow',
                    columns: [

                         { data: 'Status', renderer: StatusRender },
                         { data: 'dispatchcode', renderer: RowColor },
                         { data: 'Quantity', renderer: RowColor },
                         { data: 'TransferFromCentre', renderer: RowColor },
                         { data: 'PickUpFieldBoy', renderer: RowColor },
                         { data: 'CourierDetail', renderer: RowColor },
                         { data: 'CourierDocketNo', renderer: RowColor },
                         { data: 'Status', renderer: RowColor },
                         { data: 'SendDate', renderer: RowColor },
                         { data: 'Status', renderer: viewRender },
                    ],
                    stretchH: "all",
                    autoWrapRow: false,
                    manualColumnFreeze: true,
                    fillHandle: false,
                    // rowHeaders: true,
                    cells: function (row, col, prop) {
                        var cellProperties = {};
                        return cellProperties;
                    },
                    beforeChange: function (change, source) {
                        //updateRemarks(change);
                    }
                });
            });
        }
        function viewRender(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<img src="../../App_Images/View.gif" style="cursor:pointer" onclick="$viewSampleDetail(\'' + row + '\')">'
            if ($pendingBatch[row].RowColor != "") {
                td.className = $pendingBatch[row].RowColor;
            }
        }
        function StatusRender(instance, td, row, col, prop, value, cellProperties) {
            if ($pendingBatch[row].Status == "Transferred") {

                var Updatestatus = 'Received at Hub';
                td.innerHTML = '<a href="javascript:void(0);" onclick="$UpdateBatchStatus(\'' + row + '\',\'' + Updatestatus + '\');" >Accept</a>';

                //Bilal - Added on - 2020-04-08
                if ('<%=IsSampleLogisticReject%>' == '1') {
                    Updatestatus = 'Reject at Hub';
                    td.innerHTML += ' | <a href="javascript:void(0);" onclick="$UpdateBatchStatus(\'' + row + '\',\'' + Updatestatus + '\');" >Reject</a>'
                }
            }
            else {
                td.innerHTML = '';
            }
            if ($pendingBatch[row].RowColor != "") {
                td.className = $pendingBatch[row].RowColor;
            }
            return td;
        }


        function RowColor(instance, td, row, col, prop, value, cellProperties) {
            if ($pendingBatch[row].RowColor != "")
            {
                td.className = $pendingBatch[row].RowColor;
            }
            td.innerHTML = value;
        }
        function $UpdateBatchStatus(_row, _status) {
            $filterData = new Array();
            var $objFilter = new Object();
            $objFilter.ToCentreID = (($('#ddlCentre').val() == "") ? "0" : $('#ddlCentre').val());
            $objFilter.BatchNo = $pendingBatch[_row].dispatchcode;
            $objFilter.Status = _status; // 'Received at Hub';
            $filterData.push($objFilter);

            var _$temp = [];
            _$temp.push(serverCall('LogisticSampleReceive.aspx/UpdateBatchStatus', { data: $filterData }, function (response) {
                $.when.apply(null, _$temp).done(function () {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $searchPendingBatch();
                        $('#divPending').show();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                });
            }));
        }
        $(function () {
            $("#txtBatchNo").keydown(
                function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 13) {
                        e.preventDefault();
                        if ($('#txtBatchNo').val() != "")
                            $searchPendingBatch();
                    }
                });
        });
    </script>
    <script type="text/javascript">
        function $viewSampleDetail(rowID) {
            var $dispatchCode = $pendingBatch[rowID].dispatchcode;
            serverCall('LogisticSampleReceive.aspx/viewSampleData', { dispatchCode: $dispatchCode }, function (response) {
                $sampleDetail = JSON.parse(response);
                var container1 = document.getElementById('divSendSampleDetail');
                $(container1).html('');
                hot3 = new Handsontable(container1, {
                    data: $sampleDetail,
                    stretchH: 'all',
                    contextMenu: true,
                    width: 840,
                    colHeaders: [
              "S.No.", "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test"
                    ],
                    readOnly: true,
                    currentRowClassName: 'currentRow',
                    columns: [
                 { renderer: AutoNumberRenderer, width: '40px' },
                 { data: 'BarcodeNo', width: '80px' },
                 { data: 'PName', width: '120px' },
                 { data: 'Age', width: '110px' },
                 { data: 'Gender', width: '60px' },
                 { data: 'SampleTypeName', width: '120px' },
                 { data: 'Test', width: '200px' },
                    ],
                    stretchH: "all",
                    autoWrapRow: false,
                    manualColumnFreeze: true,
                    fillHandle: false,
                    // rowHeaders: true,
                    cells: function (row, col, prop) {
                        var cellProperties = {};
                        return cellProperties;
                    },
                    beforeChange: function (change, source) {
                        //updateRemarks(change);
                    }
                });
                $('#divSinInfo').showModel();
                hot3.render();
            });
        }
        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML   
            td.innerHTML = MyStr;
            return td;
        }
    </script>
</asp:Content>

