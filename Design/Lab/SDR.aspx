<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SDR.aspx.cs" Inherits="Design_Lab_SDR" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />

    <style type="text/css">
        .tdPage {
            width: 500px;
            vertical-align: top;
        }
        #divReceived {
            z-index: 0;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Distribution Room (SDR)</b>
            <br />
            <div style="float: right; clear: both;" id="div_pcount"></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">SIN No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 col-xs-24">
                    <asp:TextBox ID="txtBarcode" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3 col-xs-24">
                    <input id="btnSearch" type="button" value="Search" onclick="searchBarcode();" />
                </div>


            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div id="divReceived">
                    </div>
                </div>
            </div>


        <div class="POuter_Box_Inventory" id="divComplete" style="display: none;text-align: center">
            
                <input id="btnComplete" type="button" value="Complete" onclick="markComplete();" />

            
        </div>

    </div>
        </div>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">
        var filterdata = new Array();
        var sampleOutput = new Array();
        var sampleSegregation = new Array();
        $(function () {
            $('form').on('keyup keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    e.preventDefault();
                    return false;
                }
            });
            $('#txtBarcode').on('keyup', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    searchBarcode();
                }
            });
        });
        function searchBarcode() {
            $('#divSample').css('height', '200px');
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.BarcodeNo = $('#txtBarcode').val();
            if (objFilter.BatchNo == '') {
                toast("Error", "Please generate New Batch No. or Enter Batch No.", "");
                return;
            }
            filterdata.push(objFilter);
            serverCall('SDR.aspx/SampleSearch', { data: filterdata }, function (response) {
                sampleOutput = JSON.parse(response);
                if (sampleOutput.length > 0) {
                    if (sampleOutput[0].Segregation == 1)
                        $('#divComplete').show();
                    else
                        $('#divComplete').hide();
                } else
                    $('#divComplete').hide();
                var container1 = document.getElementById('divReceived');
                $(container1).html('');
                hot1 = new Handsontable(container1, {
                    data: sampleOutput,
                    colHeaders: [
                "S.No.", "SIN No.", "Sample Type", "Test", "Dept.", "Centre", "New Barcode", "Print", "Reject"
                    ],
                    readOnly: true,
                    currentRowClassName: 'currentRow',
                    columns: [
                    { renderer: AutoNumberRenderer },
                    { data: 'Barcode_Group' },
                    { data: 'SampleTypeName' },
                    { data: 'Test' },
                    { data: 'Department' },
                    { data: 'Centre' },
                    {
                        data: 'BarcodeNo', renderer: StatusRender
                    },
                    {
                        renderer: PrintRender
                    }, { data: 'Remarks', renderer: RemarksRenderer }
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
                hot1.render();
                // hot1.selectCell(0, 0);
            });            
        }
        function openreject(testid) {
            window.open('SampleReject.aspx?barcode=' + testid, '', 'dialogwidth:50;');
        }
        function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="openreject(\'' + sampleOutput[row].Barcode_Group + '\')" >Reject</span>';
            return td;
        }
        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML  
            if (sampleOutput[row].IsUrgent == '1') {
                MyStr = MyStr + '<img title="Urgent" src="../../App_Images/urgent.gif"/>';
            }
            td.innerHTML = MyStr;
            return td;
        }
        function StatusRender(instance, td, row, col, prop, value, cellProperties) {
            if ((sampleOutput[row].BarcodeNo == '') && (sampleOutput[row].Segregation > 1) && (sampleOutput[row].Centre != 'Inhouse'))
                td.innerHTML = '<a href="javascript:void(0);" onclick="generateBarcode(\'' + row + '\');" >Generate</a>';
            else if ((sampleOutput[row].Segregation == 1) && (sampleOutput[row].Centre != 'Inhouse'))
                td.innerHTML = ((sampleOutput[row].BarcodeNo == '') ? sampleOutput[row].Barcode_Group : sampleOutput[row].BarcodeNo);
            else if ((sampleOutput[row].Centre != 'Inhouse'))
                td.innerHTML = value;
            else
                td.innerHTML = sampleOutput[row].Barcode_Group;          
            return td;
        }
        function PrintRender(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<a href="javascript:void(0);" onclick="getBarcodeDetail(\'' + sampleOutput[row].BarcodeNo + '\',\'\');" >Print</a>';
            return td;
        }
        function generateBarcode(_row) {
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.BarcodeNo = sampleOutput[_row].Barcode_Group;
            objFilter.Test_ID = sampleOutput[_row].Test_ID;
            objFilter.SubCategoryID = sampleOutput[_row].SubCategoryID;
            filterdata.push(objFilter);          
            var _temp = [];
            _temp.push(serverCall('SDR.aspx/generateBarcode', { data: filterdata }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    searchBarcode();
                });
            }));           
        }
        function markComplete() {
            var _temp = [];
            _temp.push(serverCall('SDR.aspx/markComplete', { data: sampleOutput }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    searchBarcode();
                });
            }));           
        }
        function getBarcodeDetail(_barcode, _labno) {
            try {
                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.LedgerTransactionNo = '';
                objbarcodedata.BarcodeNo = _barcode;
                barcodedata.push(objbarcodedata);
                serverCall('Services/LabBooking.asmx/getBarcode', { data: barcodedata }, function (response) {
                   var $responseData = JSON.parse(response);
                   window.location = 'barcode:///?cmd=' + $responseData + '&Source=barcode_source';
                });              
            }
            catch (e) {
            }
        }
    </script>
</asp:Content>

