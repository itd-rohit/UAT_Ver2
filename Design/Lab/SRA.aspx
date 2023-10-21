<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SRA.aspx.cs" Inherits="Design_Lab_SRA" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <style type="text/css">
        

        #divBatch {
            background-color: #FFFFFF;
        }

        .spData {
            color: red;
            padding-right: 2px;
            font-weight: bold;
        }

        .w3-btn, .w3-button {
            border: none;
            display: inline-block;
            padding: 6px 12px;
            vertical-align: middle;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            color: white;
            text-align: center;
            cursor: pointer;
            white-space: nowrap;
        }

            .w3-btn:hover {
                box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            }
    </style>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                   <b> Sample Receive Area (SRA)</b>
                </div>
            </div>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">

                <div class="col-md-3 ">
                   <label class="pull-left">SIN No.</label>
			  <b class="pull-right">:</b> 
                </div>
                <div class="col-md-3 ">
                    <asp:TextBox ID="txtBarcode" runat="server"  MaxLength="15"></asp:TextBox>
                </div>
                <div class="col-md-3 ">
                    <input id="btnSearch" type="button" value="Search" onclick="GetSampleTypeWiseData(); " /> <%-- searchBarcode();--%>
                </div>
                <div class="col-md-1 ">
                    <input id="chkInhouse" checked="checked" type="checkbox" />
                </div>
                <div class="col-md-2 ">
                    In-house
                </div>
                <div class="col-md-3 ">
                    <input type="button" value="Pending Barcode" onclick="getSampleListpending()" />
                </div>
                <div class="col-md-3 ">
                    <span id="mmc" style="color: red; font-weight: bold; display: none;">*Receive Pending Batch</span>
                </div>
                <div class="col-md-3 ">
                    <input type="button" value="Reject Sample" class="resetbutton" onclick="openrejectpopup()" />
                </div>
</div>
                 <div class="row">
                <div id="divBatch" style="display: none;">
                    <span class="spHead">Batch No.</span>:
                                <span class="spData" id="spBatch">BT0001</span>
                    &nbsp;
                    <span class="spHead">Total</span>:
                                <span class="spData" id="spTotal">100</span>
                    &nbsp;
                    <span class="spHead">Received</span>:
                                <span class="spData" id="spReceived">80</span>
                    &nbsp;
                    <span class="spHead">Rejected</span>:
                                <span class="spData" id="spRejected">10</span>
                    &nbsp;
                    <span class="spHead">Pending</span>:
                     <a href="javascript:void(0);" onclick="getSampleList('Received at Hub');">
                         <span class="spData" id="spPending">10<img src="../../App_Images/view.GIF" alt="" /></span>
                     </a>
                    &nbsp;
                    <span class="spHead">Sent at</span>:
                                <span class="spData" id="spSent">10</span>
                    &nbsp;
                    <span class="spHead">Receive at</span>:
                                <span class="spData" id="spDtReceive">10</span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-12">
                    Received
                </div>
                <div class="col-md-12">
                    For Segregation
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div id="divReceived" style="height:200px;overflow-y: auto; overflow-x: hidden;"></div>
                </div>
                <div class="col-md-12">
                    <div id="divSegregation" style="height:200px;overflow-y: auto; overflow-x: hidden;"></div>
                </div>
            </div>                       
        </div>       
                <iframe src="SRAPendingList.aspx" style="width: 100%; height: 250px;"></iframe>           
          </div>          
     <div id="divSinDisplay" class="modal fade">
    <div class="modal-dialog">
         <div class="modal-content" style="min-width: 800px;max-width:100%;overflow:auto;height:460px">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Cancel Send Sample</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeSinDisplayModel(function(){})" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>   


				
			</div>
            <div class="modal-body">
                <div  class="row">
					<div class="col-md-24">
                         <div id="divSendSampleDetail" ></div>
					</div>
				</div>             
                <div style="text-align:center" class="row">					   
			    <input type="button" id="btnCancelSinInfo" value="Cancel" onclick="$closeSinDisplayModel()" class="resetbutton" />
				</div>
        </div>
   </div>
       </div>
 </div>

    <div id="divCancelSinInfo" class="modal fade">
    <div class="modal-dialog">
         <div class="modal-content" style="min-width: 200px;max-width:36%">
			<div class="modal-header">
                 <div class="row">
                         

                         <div class="col-md-24" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeCancelSinInfo(function(){})" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>   

				
				
			</div>
            <div class="modal-body">
                <div  class="row">
					<div id="divCancelSinInfoPopUp" class="col-md-24">
                        <div class="row">
						 <div class="col-md-8">
							   <label class="pull-left"><b>Sin No. </b></label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-16" >
							  <asp:TextBox ID="txtSetBarCode" runat="server" CssClass="requiredField" placeholder="Enter SIN No. to Reject"></asp:TextBox>    
						  </div>
					</div>
					</div>
				</div>
              
                <div style="text-align:center" class="row">
					   <input type="button" value="Proceed" class="savebutton" onclick="openrejectpopupnew()" id="btnSaveProceed" />
			    <input type="button" id="btnCancelSin" value="Cancel" onclick="$closeCancelSinInfo()" class="resetbutton" />
				</div>
        </div>
   </div>
       </div>
 </div>   
     <%-- Popup SampleType Wise Test Apurva : 11-09-2018 --%>
    <div id="OtherSampleTypePopup" style="display: none; position: fixed; top: 25%; left: 20%; width: 850px; height: 450px; border: 1px solid red; background-color: #fff; text-align: center; padding: 15px;">

        <a href="javascript:void(0);" style="float: right;" id="A1" onclick="CloseSampleTypeWiseData()">Close</a>
        <div style="margin-top: 20px;overflow:auto;height:350px;">
            <table  width="99%">
 		<tr id="trPackage" style="display:none;">
                    <td colspan="2"><strong><span id="spnPackageName"></span></strong></td>
                </tr>
                <tr>
                    <td style="text-align:left;">
                        <strong>Patient Name : </strong>
                        <span id="PName"></span>
                    </td>
                    <td  style="text-align:left;">
                        <strong>Age : </strong>
                        <span id="PAge"></span>
                    </td>

                    
                </tr>
                <tr>
                    <td  style="text-align:left;">
                        <strong>Booking Center : </strong>
                        <span id="BookingCenter"></span>
                    </td>
                    <td  style="text-align:left;">
                         <strong>Refer Doctor : </strong>
                        <span id="spnReferDoctor"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                </tr>
            </table>
            <table id="tblItems" class="GridViewStyle" width="99%">
                <tr>
                    <th class="GridViewHeaderStyle">SNo.
                    </th>
                    <th class="GridViewHeaderStyle">
                        SampleType
                    </th>
                    <th class="GridViewHeaderStyle">
                        Investigation Name
                    </th>
                     <th class="GridViewHeaderStyle">
                        Department
                    </th>
                    <th class="GridViewHeaderStyle">
                        <input type="checkbox" id="ChkAll" onclick="CheckAll();" />
                    </th>
                </tr>
            </table>
        </div>
         <input type="button" class="savebutton" value="Save" id="btnPopupSave"  onclick="SubmitData();" />
        <input type="hidden" id="hdnSelectedTestIds" value="0" />
    </div>
    <%-- Popup SampleType Wise Test Apurva : 11-09-2018 END --%>
        <%: Scripts.Render("~/bundles/handsontable") %>
        <%: Scripts.Render("~/bundles/MsAjaxJs") %>

        <script type="text/javascript">
            pageLoad = function (sender, args) {
                if (!args.get_isPartialLoad()) {
                    $addHandler(document, "keydown", onKeyDown);
                }
            }
            function onKeyDown(e) {
                if (e && e.keyCode == Sys.UI.Key.esc) {
                    if (jQuery('#divCancelSinInfo').is(':visible')) {
                        $closeCancelSinInfo();
                    }
                    else if (jQuery('#divSinDisplay').is(':visible')) {
                        $('#divSinDisplay').hideModel();
                    }
                }
            }
            var $closeCancelSinInfo = function (callback) {
                $('#txtSetBarCode').val('');
                $('#divCancelSinInfo').hideModel();
            }
            var $closeSinDisplayModel = function (callback) {               
                $('#divSinDisplay').hideModel();
            }           
            function openrejectpopupnew() {
                if ($('#txtSetBarCode').val() == "") {
                    toast("Error", "Please Enter Barcode No.", "");
                    $('#txtSetBarCode').focus();
                    return;
                }
                $('#divCancelSinInfo').hideModel();
                window.open('SampleReject.aspx?barcode=' + $('#txtSetBarCode').val(), '', 'dialogwidth:50;');             
            }

            openrejectpopup = function () {
                $('#divCancelSinInfo').showModel();
                $('#txtSetBarCode').val('');
                $('#txtSetBarCode').focus();

            }
            
            
        
        var SampleDetail;
        function getSampleList(_status) {
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.BatchNo = $('#spBatch').html();
            objFilter.Status = _status;
            filterdata.push(objFilter);
            serverCall('SRA.aspx/getSampleList', { data: filterdata }, function (response) {
                SampleDetail = JSON.parse(response);
                var container1 = document.getElementById('divSendSampleDetail');
                $(container1).html('');
                hot3 = new Handsontable(container1, {
                    data: SampleDetail,
                    stretchH: 'all',
                    contextMenu: true,
                    width: 840,
                    colHeaders: [
              "S.No.", "SIN No.", "Name", "Age", "Gender", "Sample Type", "Vial Qty", "Test", "SampleInfo", "Remove", "Sample Reject"
                    ],
                    readOnly: true,
                    currentRowClassName: 'currentRow',
                    columns: [
                 { renderer: AutoNumberRenderer, width: '40px' },
                 { data: 'BarcodeNo', width: '90px' },
                 { data: 'PName', width: '120px' },
                 { data: 'Age', width: '110px' },
                 { data: 'Gender', width: '60px' },
                 { data: 'SampleTypeName', width: '120px' },
                 { data: 'sampleqty' },
                 { data: 'Test', width: '200px' },
                 { data: 'SampleInfo', width: '200px' },
                 { data: 'Status', renderer: removeRender },
                    { data: 'Remarks', renderer: RemarksRenderer }
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

                $('#divSinDisplay').showModel();

                hot3.render();
               
            });
        }
        function openreject(testid) {
            window.open('SampleReject.aspx?barcode=' + testid, '', 'dialogwidth:50;');
        }
        function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="openreject(\'' + SampleDetail[row].BarcodeNo + '\')" >Reject</span>';
            return td;
        }
        function getSampleListpending() {
            serverCall('SRA.aspx/getSampleListpending', {  }, function (response) {
                SampleDetail = JSON.parse(response);          
                    var container1 = document.getElementById('divSendSampleDetail');
                    $(container1).html('');
                    hot3 = new Handsontable(container1, {
                        data: SampleDetail,
                        stretchH: 'all',
                        contextMenu: true,
                        width: 840,

                        colHeaders: [
                  "S.No.", "SIN No.", "Name", "Age", "Gender", "Sample Type", "Vial Qty.", "Test", "SampleInfo", "Remove", "Sample Reject"
                        ],
                        readOnly: true,
                        currentRowClassName: 'currentRow',
                        columns: [
                     { renderer: AutoNumberRenderer, width: '40px' },
                     { data: 'BarcodeNo', width: '90px' },
                     { data: 'PName', width: '120px' },
                     { data: 'Age', width: '110px' },
                     { data: 'Gender', width: '60px' },
                     { data: 'SampleTypeName', width: '120px' },
                     { data: 'sampleqty' },
                     { data: 'Test', width: '200px' },
                     { data: 'SampleInfo', width: '200px' },
                     { data: 'Status', renderer: removeRender },
                        { data: 'Remarks', renderer: RemarksRenderer }
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
                          
                        }
                    });
                    $('#divSinDisplay').showModel();
                    hot3.render();
                             
            });
        }

        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML   
            td.innerHTML = MyStr;
            return td;
        }

        function removeRender(instance, td, row, col, prop, value, cellProperties) {
            if (SampleDetail[row].Status == 'Received at Hub') {
                td.innerHTML = '<img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="removeSendSample(\'' + row + '\',\'IN\')">';
                $("#btnCancelAllSin").show();
            }
            else {
                td.innerHTML = '';
                $("#btnCancelAllSin").hide();
            }
            return td;
        }
        function removeSendSample(ID, Con) {
            var sampleLogisticID = SampleDetail[ID].sampleLogisticID;
            var dispatchCode = SampleDetail[ID].dispatchCode;
            var SinNo = SampleDetail[ID].BarcodeNo;
            serverCall('SRA.aspx/updateLogistic', { sampleLogisticID: sampleLogisticID, dispatchCode: dispatchCode, removeCondition: Con, SinNo: SinNo }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {

                    toast("Success", $responseData.response, "");
                    getSampleList('Received at Hub');
                    getLogisticData(dispatchCode);
                }
                else {
                    toast("Error", $responseData.response, "");

                }
            });

        }
        </script>
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
                    //searchBarcode();
                    GetSampleTypeWiseData();  //---Changed By Apurva : 11-09-2018
                }
                });
                $('#btnPopupSave').on('keyup', function (e) {
                    var keyCode = e.keyCode || e.which;
                    if (keyCode === 13) {
                        SubmitData();
                    }
                });

                $('#btnSearch').on('keyup', function (e) {
                    var keyCode = e.keyCode || e.which;
                    if (keyCode === 13) {
                        GetSampleTypeWiseData();
                    }
                });
        });
        var sampleOutput = new Array();
        var sampleSegregation = new Array();
        function searchBarcode() {
            var AllData = new Array();
            $('#divSample').css('height', '200px');
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.BarcodeNo = $('#txtBarcode').val();
            objFilter.Inhouse = $('#chkInhouse').is(':checked');
            //---------Appended By Apurva : 11-09-2018----------
            var TestIds = $('[id$=hdnSelectedTestIds]').val();
            objFilter.Test_ID = TestIds;
            //----
            if (objFilter.BatchNo == '') {
                toast("Info", "Please generate New Batch No. or Enter Batch No.", "");
                return;
            }
            filterdata.push(objFilter);
            serverCall('SRA.aspx/SampleSearch', { data: filterdata }, function (response) {

                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        toast("Info", "No Record Found", "");
                    }
                    else {
                        if ($responseData != "" && $responseData != null) {
                            if ($responseData[0].DispatchCode != '') {
                                $('#divBatch').show();
                                $('#spBatch').html($responseData[0].DispatchCode);
                                $('#spTotal').html($responseData[0].Total);
                                $('#spReceived').html($responseData[0].Received);
                                $('#spRejected').html($responseData[0].Rejected);
                                $('#spPending').html($responseData[0].Pending);
                                $('#spSent').html($responseData[0].dtSent);
                                $('#spDtReceive').html($responseData[0].dtLogisticReceive);
                            }
                            else {
                                $('#divBatch').hide();
                            }
                            $('#txtBarcode').val('');
                            for (i = 0; i < $responseData.length; i++) {
                                if ($responseData[i].Segregation == '0') {
                                    sampleOutput.push($responseData[i]);
                                }
                                else {
                                    sampleSegregation.push($responseData[i]);
                                }
                            }
                            var container1 = document.getElementById('divReceived');
                            var container2 = document.getElementById('divSegregation');
                            $(container1).html('');
                            $(container2).html('');
                            if (sampleOutput != "") {
                                hot1 = new Handsontable(container1, {
                                    data: (sampleOutput),
                                    colHeaders: [
                              "S.No", "SIN No.", "Sample Type", "Colors", "Vial Qty.", "Test", "SampleInfo", "Dept.", "Print"
                                    ],
                                    readOnly: true,
                                    currentRowClassName: 'currentRow',
                                    columns: [
                                         { renderer: AutoNumberRendererWithUrgent },
                                    { data: 'BarcodeNo' },
                                    { data: 'SampleTypeName' },
                                    { data: 'MachineColour', renderer: safemachine },
                                    { data: 'sampleqty' },
                                    { data: 'Test' },
                                    { data: 'SampleInfo' },
                                    { data: 'Department' },
                                    {
                                        renderer: PrintRender
                                    }
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
                                    }
                                });
                                hot1.render();
                            }
                            if (sampleSegregation != "") {

                                hot2 = new Handsontable(container2, {
                                    data: (sampleSegregation),
                                    colHeaders: [
                              "S.No", "SIN No.", "Sample Type", "Colors", "Vial Qty.", "Test", "SampleInfo", "Dept.", "Centre"
                                    ],
                                    readOnly: true,
                                    currentRowClassName: 'currentRow',
                                    columns: [
                                         { renderer: AutoNumberRendererWithUrgent },

                                    { data: 'BarcodeNo' },
                                    { data: 'SampleTypeName' },
                                    { data: 'MachineColour', renderer: safemachine },
                                    { data: 'sampleqty' },
                                    { data: 'Test' },
                                    { data: 'SampleInfo' },
                                    { data: 'Department' },
                                    { data: 'OutsourceCentre', renderer: centrename }

                                    ],
                                    stretchH: "all",
                                    autoWrapRow: false,
                                    manualColumnFreeze: true,
                                    fillHandle: false,

                                    cells: function (row, col, prop) {
                                        var cellProperties = {};
                                        return cellProperties;
                                    },

                                    beforeChange: function (change, source) {

                                    }
                                });
                                hot2.render();
                            }
                        }
                    }
                }
                else {
                    toast("Info", "No Record Found", "");
                }
            });          
         }
         function centrename(instance, td, row, col, prop, value, cellProperties) {
             var centrename = "";
             if (value == "" || value == null) {
                 centrename = sampleSegregation[row].TestCentre;
             }
             else {
                 centrename = value;
             }
             td.innerHTML = centrename;
             return td;
         }

         function AutoNumberRendererWithUrgent(instance, td, row, col, prop, value, cellProperties) {
             try {
                 var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML  
                 if (sampleOutput[row].IsUrgent == '1') {
                     MyStr = MyStr + '<img title="Urgent" src="../../App_Images/urgent.gif"/>';
                 }
                 td.innerHTML = MyStr;
                 return td;
             }
             catch (err) {
                 var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML  
                 if (sampleSegregation[row].IsUrgent == '1') {
                     MyStr = MyStr + '<img title="Urgent" src="../../App_Images/urgent.gif"/>';
                 }
                 td.innerHTML = MyStr;
                 return td;
             }
         }
         function safemachine(instance, td, row, col, prop, value, cellProperties) {
             var array = new Array();
             var temdata = [];
             var tempdata = "";
             array = value.split(',');

             for (i = 0; i < array.length; i++) {
                 temdata.push( '<input type="button" title="Machine Name: ');
                 temdata.push();
                 temdata.push(array[i].split('|')[1]);
                 temdata.push('"');
                 temdata.push(' class="w3-btn w3-ripple" style="background-color:');
                 temdata.push(array[i].split('|')[0]);
                 temdata.push(';">');
             }
             td.innerHTML = temdata.join("");
             return td;
         }

         function getBarcodeDetail(_barcode, _labno) {
             try {
                 var barcodedata = new Array();
                 var objbarcodedata = new Object();
                 objbarcodedata.LedgerTransactionNo = '';
                 objbarcodedata.BarcodeNo = _barcode;
                 barcodedata.push(objbarcodedata);

                 serverCall('Services/LabBooking.asmx/getBarcode', { data: barcodedata }, function (response) {
                    
                     window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                 });

             }
             catch (e) {

             }
         }
         function PrintRender(instance, td, row, col, prop, value, cellProperties) {

             //if (sampleOutput[row].BarcodeNo != '')
             //td.innerHTML = '<a href="javascript:void(0);" onclick="getBarcodeDetail(\'' + sampleOutput[row].BarcodeNo + '\',\'\');" >Print</a>';

             // else
             //  td.innerHTML = '';

             //if (PendingBatch[row].Status == "Pending for Dispatch") {

             //    td.innerHTML = '<a href="javascript:void(0);" onclick="setDispatch(\'' + row + '\');$(\'#divSubmit\').show(); $(\'#divPending\').hide();" >Transfer</a>';
             //}
             return td;
         }
        </script>
        <script type="text/javascript">
            function getLogisticData(dispatchCode) {
                serverCall('SRA.aspx/getLogisticData', { dispatchCode: dispatchCode }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $responseData = $responseData.response;
                        if ($responseData.length === 0) {
                            toast("Info", "No Record Found", "");
                        }
                        else {
                            if (jQuery.parseJSON(result.d)[0].DispatchCode != '') {
                                $('#divBatch').show();
                                $('#spTotal').html(jQuery.parseJSON(result.d)[0].Total);
                                $('#spReceived').html(jQuery.parseJSON(result.d)[0].Received);
                                $('#spRejected').html(jQuery.parseJSON(result.d)[0].Rejected);
                                $('#spPending').html(jQuery.parseJSON(result.d)[0].Pending);
                                $('#txtBarcode').val('');
                            }
                            else {
                                $('#divBatch').hide();
                            }
                        }
                    }
                    else {
                        toast("Info", $responseData.response, "");
                    }
                });
            }
        </script>
    <script>
        //-- Added By Apurva : 11-09-2018------------------
        function GetSampleTypeWiseData() {

            var BarcodeNo = $('[id$=txtBarcode]').val().trim();
            var Inhouse = $('[id$=chkInhouse]').is(':checked') ? "1" : "0";
            if (BarcodeNo != "") {
                $.ajax({
                    url: "SRA.aspx/GetSampleTypeWiseData",
                    async: true,
                    data: JSON.stringify({ BarcodeNo: BarcodeNo, Inhouse: Inhouse }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        $('[id$=tblItems] tr').slice(1).remove();
                        var data = $.parseJSON(result.d)
                        if (data.length > 0) {
                            var html = '';
                            $('#PName').html(data[0].PName);
                            $('#PAge').html(data[0].Age);
                            $('#BookingCenter').html(data[0].BookingCentre);
                            $('#spnReferDoctor').html(data[0].ReferDoctor);


                            $('#spnPackageName').html("Package Name : " + data[0].PackageName);
                            if (data[0].PackageName == "") {
                                $('#trPackage').hide();
                            } else {
                                $('#trPackage').show();
                            }


                            for (var i = 0; i < data.length ; i++) {
                                html += '<tr>';
                                html += '<td class="GridViewLabItemStyle">' + (i + 1) + ' <input type="hidden" id="hdnTestId" value="' + data[i].Test_Id + '"> </td>';
                                html += '<td class="GridViewLabItemStyle" style="text-align:left">' + data[i].SampleTypeName + '</td>';
                                html += '<td class="GridViewLabItemStyle"  style="text-align:left">' + data[i].TestName + '</td>';
                                html += '<td class="GridViewLabItemStyle"  style="text-align:left">' + data[i].Department + '</td>';
                                html += '<td class="GridViewLabItemStyle"><input type="checkbox" checked="checked"> </td>';
                                html += '</tr>';
                            }
                            $('[id$=tblItems]').append(html);
                            OpenSampleTypeWiseData();
                        }
                        else {
                            CloseSampleTypeWiseData();
                            $('#lblMsg').text('No Record Found !');
                        }
                    }
                });
            }
        }


        function OpenSampleTypeWiseData() {
            $('#OtherSampleTypePopup').show();
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });

            $('[id$=btnPopupSave]').focus();
        }

        function CloseSampleTypeWiseData() {
            $('#OtherSampleTypePopup').fadeOut("slow");
            $('#OtherSampleTypePopup').hide();
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            $('[id$=txtBarcode]').focus();
        }

        function CheckAll() {
            if ($('[id$=ChkAll]').is(':checked')) {
                $('[id$=tblItems]').find('input[type=checkbox]').each(function () {
                    $(this).attr('checked', true);
                });
            }
            else {
                $('[id$=tblItems]').find('input[type=checkbox]').each(function () {
                    $(this).attr('checked', false);
                });
            }


        }

        function SubmitData() {
            var IsValid = false;
            var TestIds = '';
            $('[id$=tblItems]').find('tr').each(function (index) {
                if (index > 0) {
                    if ($(this).find('input[type=checkbox]').is(':checked')) {
                        TestIds += $(this).find('#hdnTestId').val() + ',';
                        IsValid = true;
                    }
                }
            });

            if (IsValid) {
               // $.blockUI();
                TestIds = TestIds.substring(0, TestIds.length - 1);
                $('[id$=hdnSelectedTestIds]').val(TestIds);
                searchBarcode();
                CloseSampleTypeWiseData();
                //$.unblockUI();
            }
            else {
                alert('Please select any record !');
            }
        }

        ///--------------------------------------------
    </script>
</asp:Content>

