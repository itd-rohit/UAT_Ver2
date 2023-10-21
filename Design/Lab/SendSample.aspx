<%@ Page  Language="C#"  MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static"  EnableEventValidation="true" CodeFile="SendSample.aspx.cs" Inherits="Design_Lab_SendSample" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <style type="text/css">
        div#divSample {
            height: 200px;
            overflow: hidden;
        }

        .FullRowColor {
            background-color: pink !important;
        }

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

        /*#divAllPendingBatch > .handsontable tr, .handsontable td {
     background-color: pink; 
}*/
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" ></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">        
                <b>Sample Transfer</b>
                <br />
                <div style="float: right; clear: both;" id="div_pcount"></div>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />            
        </div>
        <div  class="POuter_Box_Inventory">        
              <div class="row">
                    <div class="col-md-3 ">
                         <label class="pull-left">Transferred To   </label>
			   <b class="pull-right">:</b>                        
                    </div>
                  <div class="col-md-5 ">
                              <select id="ddlCentre" class="ddlCentre chosen-select chosen-container"></select>                         
                      </div>
                  <div class="col-md-3 ">
                       <asp:CheckBox ID="chkAllCentre" runat="server" Text="All Centre"   />
                  </div>
                       <div class="col-md-3 "> 
                           <label class="pull-left">Batch Number  </label>
			   <b class="pull-right">:</b>

                       </div>
                        <div class="col-md-5 ">
                            <asp:TextBox ID="txtBatchNo" runat="server" disabled="disabled"></asp:TextBox>                            
                       </div>
                  <div class="col-md-4 ">
                      <input type="button" id="btnNewBatch"  value="New Batch" onclick="CheckBatchNo();" class="ItDoseButton" />
                  </div>
             </div>
                    <div class="row">
                       <div class="col-md-3 ">
                           <label class="pull-left">SIN No.  </label>
			   <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5 ">
                            <asp:TextBox ID="txtBarcode" MaxLength="15" runat="server" ></asp:TextBox>
                        </div>
                          <div class="col-md-3 ">
                            <input type="button" value="Pending Barcode" style="cursor:pointer;font-weight:bold;" onclick="$showmee()" />
                        </div>
                        <div class="col-md-3 "> 
                            <label class="pull-left">Add Batch  </label>
			   <b class="pull-right">:</b>
                        </div>                       
                            <input type="button" id="btnbatchSampleRejected" value="Batch Sample Rejected" title="Click to Open Rejected Data" style="display:none; font-weight:bold; cursor:pointer;padding:5px;border-radius:5px;font-size:15px;  background-color:red"   onclick="getRejectedData()"/>                                                
                        <div class="col-md-5 ">
                         <input type="text" id="txtAddedBatchNo" maxlength="20" /></div>
                  </div>
                    <div class="row">
                       <div class="col-md-3 "> 
                           <label class="pull-left">Number of Vials  </label>
			   <b class="pull-right">:</b>
                       </div>     
                        <div class="col-md-21 ">              
                            <div id="colordiv" runat="server"></div>  </div>                
                   </div>                         
        </div>
        <div  class="POuter_Box_Inventory">
            <div >
                <div id="divSample"></div>
            </div>
        </div>
        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader"> Pending List</div>
            <div >
         <div id="divAllPendingBatch" style="overflow:scroll;max-height:200px;height:80px;"></div>
                </div>
           <%-- <div id="divAllPendingBatchNR" style="overflow:scroll;max-height:200px;height:80px;display:none;">
                 No Record Found
            </div>--%>                      
             </div>
         <div  class="POuter_Box_Inventory">
             <div class="row">
                    <div class="col-md-3 ">
                         <label class="pull-left">From Date  </label>
			   <b class="pull-right">:</b>
                        </div>
                 <div class="col-md-2 ">
                     <asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>
                         <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
<div class="col-md-1 "> </div>
                  <div class="col-md-2 ">
                         <label class="pull-left">To Date  </label>
			   <b class="pull-right">:</b>
                        </div>
                 <div class="col-md-2 ">
                      <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                         <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                 <div class="col-md-12 ">
                      <input type="button" class="ItDoseButton" id="btnSearch" value="Search" onclick="$searchSample()" />
                         <input type="button" class="ItDoseButton" id="btnSampleTransfer" value="Sample Transfer Report" onclick="window.open('SampleTransferReport.aspx', '_blank');" />
                         <input type="button" class="ItDoseButton" id="btneditbatch" value="Batch Edit" onclick="window.open('EditBatch.aspx', '_blank');" />    
                     </div>
             
             </div>
             </div>
           <div  class="POuter_Box_Inventory">
            <div >
                <div id="divSubmit" style="display:none;">
                    <div class="row">
                    <div class="col-md-3 ">
                         <label class="pull-left">Batch Number  </label>
			   <b class="pull-right">:</b>
                        </div>
                 <div class="col-md-5 ">
                      <asp:Label ID="lblBatchNo" runat="server" Text=""></asp:Label>
                     </div>
                         <div class="col-md-3 ">
                            <label class="pull-left"> Field Boy</label>
			   <b class="pull-right">:</b>
</div>
                         <div class="col-md-5 ">
                              <select id="ddlBDE" class="requiredField"></select>
                             </div>

                        </div>
                      <div class="row">
                    <div class="col-md-3 ">
                         <label class="pull-left">Courier Detail  </label>
			   <b class="pull-right">:</b>
                        </div>
                           <div class="col-md-5 ">
                               <asp:TextBox ID="txtCourierDetail" runat="server" ></asp:TextBox>
</div>
                           <div class="col-md-3 ">
                              <label class="pull-left">Docket No.</label>
			   <b class="pull-right">:</b>
                               </div>
                          <div class="col-md-5 ">
                              <asp:TextBox ID="txtDocketNo" runat="server"  ></asp:TextBox>
                              </div>
                           </div>
                     <div class="row">
                         <div class="col-md-8 ">

                             </div>
                    <div class="col-md-2 ">
                        <input id="Button1" type="button" value="Transfer" onclick="UpdateBatchStatus();" />

                         </div>
                            <div class="col-md-2 ">
                                <input id="Button2" type="button" value="Cancel" onclick="$('#divSubmit').hide(); $('#divPending').show(); $('#divAllPendingBatch').show();"  />
                                </div>
                           </div>                                                          
                </div>
                <div id="divPending" style="overflow:scroll; height:200px;"></div>
            </div>
        </div>         
    </div>
    <div id="divSinInfo" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 886px; max-width: 50%">
                    <div class="modal-header">
                        <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Cancel Send Sample</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeSinModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>  


                        
                    </div>
                    <div class="modal-body">
                        <div class="row">
                             <div id="divSendSampleDetail" style="overflow:auto;height:460px"></div>  
                        </div>
 <div class="row">
<table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>
                    <td  style="text-align:center">
                        <input type="button" id="btnCancelAllSin" value="Cancel All" tabindex="5" class="ItDoseButton"  onclick="$removeSendSample('0', 'All')"/>                                               
                    </td>                   
                </tr>
            </table>
</div>
                    </div>
                </div>
            </div>
        </div>
<div id="divRejectSample" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 886px; max-width: 50%">
                    <div class="modal-header">
                        <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Cancel Send Sample</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeRejectModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div> 


                       
                    </div>
                    <div class="modal-body">
                        <div class="row">
                              <div  style="max-height: 400px; overflow-y:auto;overflow-x: hidden;">
             <div id="div_RejectSampleItems" >               
            </div>
        </div>
                        </div>
 
                    </div>
                </div>
            </div>
        </div>            
     <div class="BackOverlay" id="modalBackOverlay"></div>
    <div id="divModalSample" class="ModalPop" style="display:none;">
        <div style="float:left;width:100%;text-align:center;margin-top:0px;height: 160px;
    overflow: auto;">
        <table id="tblSample"  style="width: 100%">
            <tr>
                <th class="GridViewHeaderStyle">
                    S.No.
                </th>
                <th class="GridViewHeaderStyle">
                    BarcodeNo
                </th>
                <th class="GridViewHeaderStyle">
                    Test
                </th>
                <th class="GridViewHeaderStyle">
                    FromCentre
                </th>
                <th class="GridViewHeaderStyle">
                    ToCentre
                </th>
            </tr>

        </table>
       </div>
        <div style="float:left;width:100%;text-align:center;margin-top:10px;">
            <input type="button" id="btnSave" onclick="MergeBatch();" value="Add Batch" />
            <input type="button" id="btnClose" onclick="$closePop();" value="Close" />
        </div>
    </div>

<div id="divCancelSendSample" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width: 860px; max-width: 50%">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeelemp()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Pending Barcode Details</h4>
                    </div>
                    <div class="modal-body">
                        <div  class="POuter_Box_Inventory">
             <div class="row">
                    <div class="col-md-3 ">
                         <label class="pull-left">From Date  </label>
			   <b class="pull-right">:</b>
                        </div>
                 <div class="col-md-3 ">
                     <asp:TextBox ID="txtFromDateBarcode" runat="server" ClientIDMode="Static"></asp:TextBox>
                         <cc1:CalendarExtender ID="calFromDateBarcode" runat="server" TargetControlID="txtFromDateBarcode" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>

                  <div class="col-md-3 ">
                         <label class="pull-left">To Date  </label>
			   <b class="pull-right">:</b>
                        </div>
                 <div class="col-md-3 ">
                      <asp:TextBox ID="txtToDateBarcode" runat="server" ClientIDMode="Static"></asp:TextBox>
                         <cc1:CalendarExtender ID="calToDateBarcode" runat="server" TargetControlID="txtToDateBarcode" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                 <div class="col-md-12 ">
                      <input type="button" class="ItDoseButton" id="btnSearchPending" value="Search" onclick="$showmee()" />
                     </div>
             
             </div>
             </div>
                        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="Purchaseheader">Pending Barcode List</div>                
                   <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblpending" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">Reg Date</td>
                                        <td class="GridViewHeaderStyle">PName</td>
                                        <td class="GridViewHeaderStyle">Test</td>
                                        <td class="GridViewHeaderStyle">Barcode</td>
                                        <td class="GridViewHeaderStyle" ><input type="checkbox" onclick="$chkAll(this)" /></td>                                                                                                                                                                                                   
                        </tr>
                </table>
                </div>
              <div class="row" style="text-align:center">
                           <input type="button" id="btnSaveAddToBatch" class="savebutton" value="Add To Batch" onclick="$addToBatchAll()" />
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
        function $chkAll(ctr) {
            $(".penClass").prop("checked", ($(ctr).prop("checked")));
        }

        function showBatchSamRej() {

        }
        function $closeRejectModel() {
            $('#divRejectSample').hideModel();
        }
        function $closeelemp() {
            $('#divCancelSendSample').hideModel();
        }
        function $closeSinModel() {
            $('#divSinInfo').hideModel();
        }

    </script>
    <script type="text/javascript">
        function cancelAllSin() {
        }
        function $removeSendSample(ID, Con) {
            var $sampleLogisticID = $SampleDetail[ID].sampleLogisticID;
            var $dispatchCode = $SampleDetail[ID].dispatchCode;
            var $SinNo = $SampleDetail[ID].BarcodeNo;
            var $testid = $SampleDetail[ID].test_id;
            _temp.push(serverCall('SendSample.aspx/updateLogistic', { sampleLogisticID: $sampleLogisticID, dispatchCode: $dispatchCode, removeCondition: Con, SinNo: $SinNo, testid: $testid }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                        closeSendSample();
                        $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
                        $searchAllPending();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                });
            }));
        }
        var $SampleDetail;
        function viewSampleDetail(rowID) {
            var $dispatchCode = PendingBatch[rowID].dispatchCode;
            serverCall('SendSample.aspx/viewSampleData', { dispatchCode: $dispatchCode }, function (response) {
                $SampleDetail = JSON.parse(response);
                SampleDetailPending = JSON.parse(response);
                var container1 = document.getElementById('divSendSampleDetail');
                $(container1).html('');
                hot3 = new Handsontable(container1, {
                    data: $SampleDetail,
                    stretchH: 'all',
                    contextMenu: true,
                    width: 840,
                    colHeaders: [
              "S.No.", "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test", "Remove"
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
                 { data: 'Status', renderer: removeRender },
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
            var MyStr = '<span>' + parseInt(row + 1) + '</span>';//td.innerHTML   
            td.innerHTML = MyStr;
            return td;
        }
        function removeRender(instance, td, row, col, prop, value, cellProperties) {
            alert($SampleDetail[row].Status);
            if ($SampleDetail[row].Status == 'Pending for Dispatch') {
                td.innerHTML = '<img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="$removeSendSample(\'' + row + '\',\'IN\')">';
                $("#btnCancelAllSin").show();
            }
            else {
                td.innerHTML = '';
                $("#btnCancelAllSin").hide();
            }
            return td;
        }
    </script>
    <script type="text/javascript">
        var filterdata = new Array();
        var sampleOutput = new Array();
        function $searchBarcode() {
            $('#divSample').css('height', '200px');
            filterdata = new Array();
            if ($('#ddlCentre').val() == "" || $('#ddlCentre').val() == "0") {
                toast("Error", "Please Select To Centre", "");
                return;
            }
            var $objFilter = new Object();
            $objFilter.BarcodeNo = $('#txtBarcode').val();
            $objFilter.ToCentreID = $('#ddlCentre').val();
            if ($('#txtBatchNo').val() == "") {
                toast("Error", "Please Enter BatchNo", "");
                $('#txtBatchNo').focus();
                return;
            }
            $objFilter.BatchNo = $('#txtBatchNo').val();
            filterdata.push($objFilter);
            var _temp = [];
            _temp.push(serverCall('SendSample.aspx/SampleSearch', { data: filterdata }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    var mydata = JSON.parse(response);
                    if (mydata.length > 0) {
                        var ClrQtyArray = mydata[0].ColorValue.split(',');
                        $(ClrQtyArray).each(function (index, value) {
                            var nn = $('.' + value).html();
                            $('.' + value).html(Number(nn) + Number(mydata[0].sampleqty));
                        });
                    }
                    for (var i = 0; i <= mydata.length - 1; i++) {
                        $('#txtBatchNo').val(mydata[i].BatchNo);
                    }
                    $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
                    $searchAllPending();
                    sampleOutput = $.merge(JSON.parse(response), sampleOutput);
                    var container1 = document.getElementById('divSample');
                    $(container1).html('');
                    hot1 = new Handsontable(container1, {
                        data: sampleOutput,
                        colHeaders: [
                  "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test", "Sample Reject"
                        ],
                        readOnly: true,
                        currentRowClassName: 'currentRow',
                        columns: [
                     { data: 'BarcodeNo', readOnly: false },//, readOnly: false,renderer:UpdateBarcode
                     { data: 'PName' },
                     { data: 'Age' },
                     { data: 'Gender' },
                     { data: 'SampleTypeName' },
                     { data: 'Test' },
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
                            updateFlag(change);
                        }
                    });
                    hot1.render();

                    if ($('#txtBatchNo').val() == "") {
                        // GenerateBatchNo();
                    }
                    $('#txtBarcode').val('');
                });

            }));
        }
        function updateFlag(change) {
            var myarr = [];
            myarr = change;
            if (myarr != null) {
                var row = change[0][0];
                var col = change[0][1];
                var old = change[0][2];
                var newvalue = change[0][3];
                if (col == 'BarcodeNo') {
                    UpdateBarcodeNo(newvalue, old)
                }
            }
        }
        function UpdateBarcodeNo(newBarcode, oldbarcode) {
            var testid = sampleOutput;
            serverCall('SendSample.aspx/UpdateBarcodeNo', { OldBarcode: oldbarcode, newBarcode: newBarcode }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }

        $openReject = function (BarcodeNo) {
            $encryptQueryStringData(BarcodeNo, function ($returnData) {
              // $fancyBoxOpen('SampleReject.aspx?BarcodeNo=' + $returnData + '');
              window.open('../Lab/SampleReject.aspx?BarcodeNo=' + $returnData, null);
            });
        }


        function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="$openReject(\'' + sampleOutput[row].BarcodeNo + '\')" >Reject</span>';
            return td;
        }
        var PendingBatch;
        function $searchPendingBatch(fromDate, toDate) {
            $('#divPending').css('height', '200px');
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.BarcodeNo = $('#txtBarcode').val();
            objFilter.ToCentreID = (($('#ddlCentre').val() == "") ? "0" : $('#ddlCentre').val());
            objFilter.BatchNo = $('#txtBatchNo').val();
            objFilter.FromDate = fromDate;
            objFilter.ToDate = toDate;
            filterdata.push(objFilter);
            serverCall('SendSample.aspx/BatchSearch', { data: filterdata }, function (response) {
                PendingBatch = JSON.parse(response);
                var container1 = document.getElementById('divPending');
                $(container1).html('');
                hot2 = new Handsontable(container1, {
                    data: PendingBatch,
                    colHeaders: [
               "#", "Batch No.", "Vials Qty.", "Field Boy", "Courier Detail", "Docket No.", "Status", "View", "Print", "Edit Batch"
                    ],
                    readOnly: true,
                    currentRowClassName: 'currentRow',
                    columns: [
                 { data: 'Status', renderer: StatusRender },
                 { data: 'dispatchCode', renderer: printRenderBarcode },
                 { data: 'Quantity' },
                 { data: 'PickUpFieldBoy' },
                 { data: 'CourierDetail' },
                 { data: 'CourierDocketNo' },
                 { data: 'Status' },
                 { data: 'Status', renderer: viewRender },
                     { data: 'Print', renderer: printRender },
                     { renderer: editBatchRenderer },
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
        function StatusRender(instance, td, row, col, prop, value, cellProperties) {
            if (PendingBatch[row].Status == "Pending for Dispatch") {
                td.innerHTML = '<a href="javascript:void(0);" onclick="setDispatch(\'' + row + '\');$(\'#divSubmit\').show(); $(\'#divPending\').hide();" >Transfer</a>';
            }
            return td;
        }
        function editBatchRenderer(instance, td, row, col, prop, value, cellProperties) {
            if (PendingBatch[row].dispatchCode != "" && PendingBatch[row].Status == "Pending for Dispatch") {
                td.innerHTML = '<a href="javascript:void(0);" onclick="$editBatchData(\'' + PendingBatch[row].dispatchCode + '\');" >Add More Sample</a>';
            }
            return td;
        }
        function $editBatchData(batchNo) {
            if (batchNo.trim() != '') {
                $encryptQueryStringData(batchNo, function ($returnData) {
                    window.open('../Lab/EditBatch.aspx?batchNo=' + $returnData, null);
                });
            }
        }
        function printRenderBarcode(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<a href="javascript:void(0);" onclick="printBarcode(\'' + value + '\');" >' + value + '</a>';
            return td;
        }
        function viewRender(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<img src="../../App_Images/View.gif" style="cursor:pointer" onclick="viewSampleDetail(\'' + row + '\')">'
        }
        function printRender(instance, td, row, col, prop, value, cellProperties) {
            if (PendingBatch[row].dispatchCode != '') {
                td.innerHTML = '<img src="../../App_Images/View.gif" style="cursor:pointer" onclick="$printDispatchSampleReport(\'' + PendingBatch[row].dispatchCode + '\')">'
            }
        }
        function $printDispatchSampleReport(batchNo) {
            if (batchNo.trim() != '') {
                $encryptQueryStringData(batchNo, function ($returnData) {
                    window.open('../Lab/DispatchSampleReport.aspx?batchNo=' + $returnData, null);
                });

            }
        }
        function setDispatch(_id) {
            $('#lblBatchNo').html(PendingBatch[_id].dispatchCode);
        }
        function UpdateBatchStatus() {
            $('#lblMsg').text('');
            if ($('#ddlBDE').val() == "0") {
                toast("Error", "Please Select Field Boy", "");
                $('#ddlBDE').focus();
                return;
            }
            filterdata = new Array();
            var objFilter = new Object();
            objFilter.ToCentreID = (($('#ddlCentre').val() == "") ? "0" : $('#ddlCentre').val());
            objFilter.BatchNo = $('#lblBatchNo').html();
            objFilter.FieldBoyID = $('#ddlBDE').val();
            objFilter.FieldBoy = $("#ddlBDE.ClientID option:selected").text();
            objFilter.CourierDetail = $('#txtCourierDetail').val();
            objFilter.CourierDocketNo = $('#txtDocketNo').val();
            objFilter.Status = 'Transferred';
            filterdata.push(objFilter);
            var _temp = [];
            _temp.push(serverCall('SendSample.aspx/UpdateBatchStatus', { data: filterdata }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    printBarcode($('#lblBatchNo').html());
                    $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
                    $searchAllPending();
                    $('#divSubmit').hide();
                    $('#divPending,#divAllPendingBatch').show();
                    if ($('#lblBatchNo').html() == $('#txtBatchNo').val()) {
                        $('#txtBatchNo').val('');
                    }
                });
            }));
        }
        function CheckBatchNo() {
            if ($('#txtBatchNo').val() == "") {
                $generateBatchNo();
            }
            else {
                $confirmationBox('Do you want to generate new batch no ??');
                
            }
        }

        function $generateBatchNo() {
            serverCall('SendSample.aspx/GenerateBatch', {}, function (response) {
                $('#txtBatchNo').val(response);
            });
        }
        function printBarcode(_data) {
            //  window.location='barcode:///?cmd=' + _data + '&Source=barcode_source_disptach';
        }
        //------------------------ All Pending Batch data : changes by Apurva
        var $allPendingBatch;
        function $searchAllPending() {
            serverCall('SendSample.aspx/BatchPending', { data: filterdata }, function (response) {
                $allPendingBatch = JSON.parse(response);
                var container1 = document.getElementById('divAllPendingBatch');
                $(container1).html('');
                hot2 = new Handsontable(container1, {
                    data: $allPendingBatch,
                    colHeaders: [
               "#", "Batch No.", "Vials Qty.", "Field Boy", "Courier Detail", "Docket No.", "Status", "View", "Print", "Edit Batch"
                    ],
                    readOnly: true,
                    currentRowClassName: 'FullRowColor',
                    columns: [
                 { data: 'Status', renderer: StatusRenderPending },
                 { data: 'dispatchCode', renderer: printRenderBarcodePending },
                 { data: 'Quantity', renderer: FullRowColor },
                 { data: 'PickUpFieldBoy', renderer: FullRowColor },
                 { data: 'CourierDetail', renderer: FullRowColor },
                 { data: 'CourierDocketNo', renderer: FullRowColor },
                 { data: 'Status', renderer: FullRowColor },
                 { data: 'Status', renderer: viewRenderPending },
                     { data: 'Print', renderer: printRenderPending },
                     { renderer: editBatchRendererPending },
                    ],
                    stretchH: "all",
                    autoWrapRow: false,
                    manualColumnFreeze: true,
                    fillHandle: false,
                    // rowHeaders: true,
                    cells: function (row, col, prop) {
                        var cellProperties = {};
                        cellProperties.className = "FullRowColor";
                        $(col).css('background-color', 'pink !important');
                        return cellProperties;
                    },
                    beforeChange: function (change, source) {
                        //updateRemarks(change);
                    }
                });
                //if ($allPendingBatch.length > 0) {
                //    $('#divAllPendingBatch').show();
                //    $('#divAllPendingBatchNR').hide();

                //} else {
                //    $('#divAllPendingBatch').hide();
                //    $('#divAllPendingBatchNR').show();

                //}
            });
        }
        function StatusRenderPending(instance, td, row, col, prop, value, cellProperties) {
            if ($allPendingBatch[row].Status == "Pending for Dispatch") {
                td.innerHTML = '<a href="javascript:void(0);" onclick="setDispatchPending(\'' + row + '\');$(\'#divSubmit\').show(); $(\'#divAllPendingBatch\').hide();" >Transfer</a>';
            }
            td.className = 'FullRowColor';
            return td;
        }
        function printRenderBarcodePending(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<a href="javascript:void(0);" onclick="printBarcode(\'' + value + '\');" >' + value + '</a>';
            td.className = 'FullRowColor';
            return td;
        }
        function editBatchRendererPending(instance, td, row, col, prop, value, cellProperties) {
            if ($allPendingBatch[row].dispatchCode != "" && $allPendingBatch[row].Status == "Pending for Dispatch") {
                td.innerHTML = '<a href="javascript:void(0);" onclick="$editBatchData(\'' + $allPendingBatch[row].dispatchCode + '\');" >Add More Sample</a>';
            }
            td.className = 'FullRowColor';
            return td;
        }
        function FullRowColor(instance, td, row, col, prop, value, cellProperties) {
            td.className = 'FullRowColor';
            td.innerHTML = value;
        }
        function printRenderPending(instance, td, row, col, prop, value, cellProperties) {
            if ($allPendingBatch[row].dispatchCode != '') {
                td.innerHTML = '<img src="../../App_Images/View.gif" style="cursor:pointer" onclick="$printDispatchSampleReport(\'' + $allPendingBatch[row].dispatchCode + '\')">'
            }
            td.className = 'FullRowColor';
        }
        function setDispatchPending(_id) {
            $('#lblBatchNo').html($allPendingBatch[_id].dispatchCode);
        }
        function viewRenderPending(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<img src="../../App_Images/View.gif" style="cursor:pointer" onclick="$viewSampleDetailPending(\'' + row + '\')">'
            $(td).css('background-color', 'pink');
            $(td).addClass('FullRowColor');
        }
        var SampleDetailPending;
        function $viewSampleDetailPending(rowID) {
            var dispatchCode = $allPendingBatch[rowID].dispatchCode;
            serverCall('SendSample.aspx/viewSampleData', { dispatchCode: dispatchCode }, function (response) {
                SampleDetailPending = JSON.parse(response);
                $SampleDetail = JSON.parse(response);
                var container1 = document.getElementById('divSendSampleDetail');
                $(container1).html('');
                hot3 = new Handsontable(container1, {
                    data: SampleDetailPending,
                    stretchH: 'all',
                    contextMenu: true,
                    width: 840,

                    colHeaders: [
              "S.No.", "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test", "Remove"
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
                 { data: 'Status', renderer: removeRender },
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
            var MyStr = '<span>' + parseInt(row + 1) + '</span>';//td.innerHTML   
            td.innerHTML = MyStr;
            return td;
        }
        function removeRender(instance, td, row, col, prop, value, cellProperties) {
            if (SampleDetailPending[row].Status == 'Pending for Dispatch') {
                td.innerHTML = '<img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="$removeSendSample(\'' + row + '\',\'IN\')">';
                $("#btnCancelAllSin").show();
            }
            else {
                td.innerHTML = '';
                $("#btnCancelAllSin").hide();
            }
            return td;
        }
        //---------------End All Pending Batch data

    </script>
    <script id="tb_RejectSampleItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
	    <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>            
	    <th class="GridViewHeaderStyle" scope="col" style="width:80px">SIN No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px">Batch No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Age</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Gender</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">SampleTypeName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:260px">Test</th>            		      
</tr>
<#  var dataLength=RejectSample.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = RejectSample[j];
         
            #>
<tr id="<#=j+1#>" style="background-color:white;">
<td class="GridViewLabItemStyle"><#=j+1#></td>  
<td class="GridViewLabItemStyle" style=""><#=objRow.BarCodeNo#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.DispatchCode#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.PName#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Age#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Gender#></td> 
<td class="GridViewLabItemStyle" style=""><#=objRow.SampleTypeName#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Test#></td>

</tr> 
<#}#> 
        </table>          
          </script>  
    <script type="text/javascript">
        function getRejectedData() {
            $("#lblMsg").text('');
            serverCall('SendSample.aspx/rejectedSampleData', {}, function (response) {
                var RejectSample = JSON.parse(response);
                if (RejectSample.length > 0) {
                    var output = $('#tb_RejectSampleItems').parseTemplate(RejectSample);
                    $('#div_RejectSampleItems').html(output);
                    $('#divRejectSample').showModel();
                }
                else {
                    $('#divRejectSample').hideModel();
                    toast("Info", "No Record Found", "");
                }
            });
        }
        function getRejectedSampleData() {
            $("#lblMsg").text('');
            serverCall('SendSample.aspx/getRejectedSampleData', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData > 0)
                    $("#btnbatchSampleRejected").show();
                else
                    $("#btnbatchSampleRejected").hide();
            });
        }
    </script>
    <script type="text/javascript" >
        serverCall('../Common/Services/CommonServices.asmx/CompareDate', { FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val() }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData == false) {
                toast("Info", "The Date range should not exceed more than 30 days", "");
                $('#btnSearch').attr('disabled', 'disabled');
            }
            else {
                $('#lblMsg').text('');
                $('#btnSearch').removeAttr('disabled');
            }
        });
        function $searchSample() {
            $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
            $searchAllPending();
        }
    </script>
    <script type="text/javascript">
        function $bindfieldboy() {
            var $ddlBDE = $("#ddlBDE");
            $("#ddlBDE option").remove();
            var $centreID = '<%= UserInfo.Centre%>';
            serverCall('../Lab/Services/LabBooking.asmx/getfieldboy', { centreid: $centreID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.length == 0) {
                    $("#ddlBDE").append($("<option></option>").val("0").html("Field Boy Not Found"));
                }
                else {
                    $ddlBDE.bindDropDown({ data: JSON.parse(response), valueField: 'id', textField: 'Name', isSearchAble: true, defaultValue: "Select" });




                }
            });
        }
        $('#chkAllCentre').change(function () {
            var AllCentre = "0";
            if ($(this).is(':checked')) {
                AllCentre = "1";
            } else {
                AllCentre = "0";
            }
            $bindSampleTransferCentre(AllCentre);
        });
        $(function () {
            $bindfieldboy();
            $bindSampleTransferCentre("0");
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
            getRejectedSampleData();
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
                    $searchBarcode();
                }
            });
            $searchAllPending();
            $('#txtAddedBatchNo').keyup(function (e) {
                if (e.which == 13) {
                    $openPopUp();
                }
            });
        });
        function $bindSampleTransferCentre(AllCentre) {
            $("#ddlCentre option").remove();
            var _temp = [];
            _temp.push(serverCall('SendSample.aspx/bindSampleTransferCentre', { AllCentre: AllCentre }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    var $responseData = JSON.parse(response);
                    if ($responseData.length == 0) {
                        $("#ddlCentre").append($("<option></option>").val("0").html("Not Found"));
                    }
                    else {
                        if ($responseData > 1)
                        { $("#ddlCentre").append($("<option></option>").val("").html("-- Select Centre --")); }
                        for (i = 0; i < $responseData.length; i++) {
                            $("#ddlCentre").append($("<option></option>").val($responseData[i].CentreID).html($responseData[i].Centre));
                        }
                        $("#ddlCentre").chosen("destroy").chosen({ width: '100%' });
                    }
                    $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
                });
            }));
        }
    </script>
   <script type="text/javascript">
       function $openPopUp() {
           var TransferredTo = $('#ddlCentre').val();
           var BatchNo = $('#txtBatchNo').val().trim();
           var BatchToAdd = $('#txtAddedBatchNo').val().trim();
           if (BatchNo == "") {
               toast("Error", "Please Enter Batch No.", "");
               $('#txtBatchNo').focus();
               return;
           }
           if (BatchToAdd != "") {
               if (TransferredTo == "") {
                   toast("Error", "Please Select Centre", "");
                   $('#ddlCentre').focus();
                   return;
               }
               serverCall('SendSample.aspx/OpenPopup', { BatchToAdd: BatchToAdd, BatchNo: BatchNo, TransferredTo: TransferredTo }, function (response) {
                   var $responseData = JSON.parse(response);
                   if ($responseData.status) {
                       data = $responseData.response;
                       if (data.length > 0) {
                           $('#tblSample tr').slice(1).remove();
                           $('#txtBatchNo').val(data[0].BatchNo);
                           for (var i = 0; i < data.length; i++) {
                               var $mydata = [];
                               $mydata.push("<tr>");
                               $mydata.push('<td class="GridViewItemStyle">');
                               $mydata.push((i + 1));
                               $mydata.push('</td><td class="GridViewItemStyle">');
                               $mydata.push(data[i].BarcodeNo);
                               $mydata.push('</td><td class="GridViewItemStyle">');
                               $mydata.push(data[i].InvestigationName);
                               $mydata.push('</td><td class="GridViewItemStyle">');
                               $mydata.push(data[i].FromCentre);
                               $mydata.push('</td><td class="GridViewItemStyle">');
                               $mydata.push(data[i].ToCentre);
                               $mydata.push('</td></tr>');
                               $mydata = $mydata.join("");
                               jQuery('#tblSample').append($mydata);
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
               toast("Error", "Please Enter Batch No. to be added", "");
           }
       }
       function MergeBatch() {
           var $transferredTo = $('#ddlCentre').val();
           var $batchNo = $('#txtBatchNo').val().trim();
           var $batchToAdd = $('#txtAddedBatchNo').val().trim();
           if ($batchToAdd != "") {
               if ($transferredTo == "") {
                   toast("Error", "Please Select Centre", "");
                   return;
               }
               serverCall('SendSample.aspx/AddBatchToBatch', { BatchToAdd: $batchToAdd, BatchNo: $batchNo, TransferredTo: $transferredTo }, function (response) {
                   var $responseData = JSON.parse(response);
                   if ($responseData.status) {
                       $getRecord($batchNo);
                       $searchAllPending();
                   }
                   $('#divModalSample').hide();
                   $('#modalBackOverlay').hide();
               });
           } else {
               toast("Error", "Please Enter Batch no to be added", "");
           }
       }
       function $getRecord(BatchNo) {
           serverCall('SendSample.aspx/GetRecord', { BatchNo: BatchNo }, function (response) {
               var $responseData = JSON.parse(response);
               if ($responseData.length > 0) {
                   var ClrQtyArray = $responseData[0].ColorValue.split(',');
                   $(ClrQtyArray).each(function (index, value) {
                       var nn = $('.' + value).html();
                       $('.' + value).html(Number(nn) + Number($responseData[0].sampleqty));
                   });
               }
               for (var i = 0; i <= $responseData.length - 1; i++) {
                   $('#txtBatchNo').val($responseData[i].BatchNo);
               }
               $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
               sampleOutput = $.merge(JSON.parse(response), sampleOutput);
               var container1 = document.getElementById('divSample');
               $(container1).html('');
               hot1 = new Handsontable(container1, {
                   data: sampleOutput,
                   colHeaders: [
             "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test", "Sample Reject"
                   ],
                   readOnly: true,
                   currentRowClassName: 'currentRow',
                   columns: [
                { data: 'BarcodeNo', readOnly: false },//, readOnly: false,renderer:UpdateBarcode
                { data: 'PName' },
                { data: 'Age' },
                { data: 'Gender' },
                { data: 'SampleTypeName' },
                { data: 'Test' },
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
                       updateFlag(change);
                   }
               });
               hot1.render();
               if ($('#txtBatchNo').val() == "") {
                   // GenerateBatchNo();
               }
               $('#txtBarcode').val('');
               $('#txtAddedBatchNo').val('');

           });
       }
       function $closePop() {
           $('#divModalSample').hide();
           $('#modalBackOverlay').hide();
       }
       function $showmee() {
           if ($('#ddlCentre').val() == "" || $('#ddlCentre').val() == "0") {
               toast("Error", "Please Select To Centre", "");
               return;
           }
           if ($('#txtBatchNo').val().trim() == "") {
               toast("Error", "Please Enter Batch No.", "");
               return;
           }

           var FromDate = $("#txtFromDateBarcode").val();
           var TODate = $("#txtToDateBarcode").val();

           $('#tblpending tr').slice(1).remove();

           serverCall('SendSample.aspx/bindpendinglist', { FromDate: FromDate, TODate: TODate }, function (response) {
               var $PendingList = JSON.parse(response);
               if ($PendingList.length == 0) {
                   //toast("Error", "No Pending BaroCode Found", "");
                   $('#divCancelSendSample').showModel();
                   return;
               }
               else {
                   for (i = 0; i < $PendingList.length; i++) {
                       var $mydata = [];
                       $mydata.push("<tr style='background-color:white;' id='");
                       $mydata.push($PendingList[i].barcodeno); $mydata.push("'>");
                       $mydata.push('<td class="GridViewLabItemStyle" >');
                       $mydata.push((i + 1));
                       $mydata.push('</td>');
                       $mydata.push('<td class="GridViewLabItemStyle" >');
                       $mydata.push($PendingList[i].RegDate);
                       $mydata.push('</td>');
                       $mydata.push('<td class="GridViewLabItemStyle" >');
                       $mydata.push($PendingList[i].pname);
                       $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      
                       $mydata.push($PendingList[i].TestName);
                       $mydata.push('</td><td class="GridViewLabItemStyle" style="font-weight:bold;" >');
                       $mydata.push($PendingList[i].barcodeno);
                       $mydata.push('</td><td class="GridViewLabItemStyle" ><input type="checkbox" class="penClass" id="mmcheck"/></td></tr>');
                       $mydata = $mydata.join("");
                       jQuery('#tblpending').append($mydata);
                   }
                   $('#divCancelSendSample').showModel();
               }
           });
       }
       function $addToBatchAll() {
           if ($('#ddlCentre').val() == "" || $('#ddlCentre').val() == "0") {
               toast("Error", "Please Select To Centre", "");
               return;
           }
           var barcode = [];
           $('#tblpending tr').each(function () {
               id = $(this).closest("tr").attr("id");
               if (id != "triteheader") {
                   if ($(this).closest("tr").find('#mmcheck').prop('checked') == true) {
                       barcode.push(id);
                   }
               }
           });
           if (barcode.length == 0) {
               toast("Error", "Please Select Barcode to Add", "");
               return;
           }
           $("#btnSaveAddToBatch").attr('disabled', true).val("Adding...");
           $('#tblpending tr').each(function () {
               id = $(this).closest("tr").attr("id");
               if (id != "triteheader" && $(this).closest("tr").find('#mmcheck').prop('checked') == true) {
                   filterdata = new Array();
                   var objFilter = new Object();
                   objFilter.BarcodeNo = id;
                   objFilter.ToCentreID = $('#ddlCentre').val();
                   objFilter.BatchNo = $('#txtBatchNo').val();
                   filterdata.push(objFilter);
                   var _temp = [];
                   _temp.push(serverCall('SendSample.aspx/SampleSearch', { data: filterdata }, function (response) {
                       $.when.apply(null, _temp).done(function () {
                           var mydata = JSON.parse(response);
                           if (mydata.length > 0) {
                               var ClrQtyArray = mydata[0].ColorValue.split(',');
                               $(ClrQtyArray).each(function (index, value) {
                                   var nn = $('.' + value).html();
                                   $('.' + value).html(Number(nn) + Number(mydata[0].sampleqty));
                               });
                           }
                           for (var i = 0; i <= mydata.length - 1; i++) {
                               $('#txtBatchNo').val(mydata[i].BatchNo);
                           }
                           sampleOutput = $.merge(JSON.parse(response), sampleOutput);
                           var container1 = document.getElementById('divSample');
                           $(container1).html('');
                           hot1 = new Handsontable(container1, {
                               data: sampleOutput,
                               colHeaders: [
                         "SIN No.", "Name", "Age", "Gender", "Sample Type", "Test", "Sample Reject"
                               ],
                               readOnly: true,
                               currentRowClassName: 'currentRow',
                               columns: [
                            { data: 'BarcodeNo', readOnly: false },//, readOnly: false,renderer:UpdateBarcode
                            { data: 'PName' },
                            { data: 'Age' },
                            { data: 'Gender' },
                            { data: 'SampleTypeName' },
                            { data: 'Test' },
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
                                   updateFlag(change);
                               }
                           });
                           hot1.render();
                           if ($('#txtBatchNo').val() == "") {
                               // GenerateBatchNo();
                           }
                           $('#txtBarcode').val('');
                       });

                   }));
               }
           });
           $searchPendingBatch($('#txtFromDate').val(), $('#txtToDate').val());
           $searchAllPending();
           $('#btnSaveAddToBatch').attr('disabled', false).val("Add To Batch");
           $('#divCancelSendSample').hideModel();
       }
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
               if (jQuery('#divRejectSample').is(':visible')) {
                   jQuery('#divRejectSample').hideModel();
               }

           }

       }
       $('#txtBatchNo,#txtDocketNo,#txtCourierDetail').alphanum({
           allow: '/-.,&'
       });
       function ChkDate() {
           serverCall('../Common/Services/CommonServices.asmx/CompareDate', { FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val() }, function (response) {

               if (response == false) {
                   toast('Error', 'Date range should not exceed more than 30 days');
                   $('#btnSearch').attr('disabled', 'disabled');
               }
               else {

                   $('#btnSearch').removeAttr('disabled');
               }
           }, 0, false);


       }
       $confirmationBox = function (contentMsg) {
           jQuery.confirm({
               title: 'Confirmation!',
               content: contentMsg,
               animation: 'zoom',
               closeAnimation: 'scale',
               useBootstrap: false,
               opacity: 0.5,
               theme: 'light',
               type: 'red',
               typeAnimated: true,
               boxWidth: '480px',
               buttons: {
                   'confirm': {
                       text: 'Yes',
                       useBootstrap: false,
                       btnClass: 'btn-blue',
                       action: function () {
                           $('#txtBatchNo').val('');
                           $generateBatchNo();
                       }
                   },
                   somethingElse: {
                       text: 'No',
                       action: function () {
                           
                       }
                   },
               }
           });

       }
    </script>
</asp:Content>

