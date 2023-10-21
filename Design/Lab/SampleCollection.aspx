<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleCollection.aspx.cs" Inherits="Design_Lab_SampleCollection" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <b>Sample Collection</b>
                </div>
            </div>
           
        </div>

        <div class="POuter_Box_Inventory" id="SearchFilteres">
            <div class="Purchaseheader">
                Search Option
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <select id="ddlSearchType">
                        <option value="plo.BarcodeNo" selected="selected">SIN No.</option>
                        <option value="plo.LedgertransactionNo">Visit No.</option>
                        <option value="lt.PName">Patient Name</option>
                    </select>

                </div>
                <div class="col-md-3 ">
                    <input type="text" maxlength="30" id="txtSearchValue" />

                </div>
                <div class="col-md-3 ">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess chosen-select" runat="server" onchange="$bindPanel('','Manual');">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3 ">
                    <asp:DropDownList ID="ddlPanel" class="ddlPanel chosen-select" runat="server">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4 ">
                    <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment chosen-select">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4 ">
                    <asp:DropDownList ID="ddlUser" runat="server" class="ddlUser chosen-select">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4 ">
                    <select id="ddlSampleStatus" class="ddlSampleStatus chosen-select">
                        <option value="N">Sample Not Collected</option>
                          <option value="S">Collected</option>
                          <option value="Y">Received</option>
                          <option value="R">Rejected</option>
                    </select>
                    
                </div>
                
               
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <asp:TextBox ID="txtFormDate" runat="server" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                </div>
                <div class="col-md-3 ">
                    <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                        ControlExtender="mee_txtFromTime"
                        ControlToValidate="txtFromTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
              
                     <div class="col-md-3 ">
                         <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true"></asp:TextBox>
                         <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />

                     </div>
                <div class="col-md-3 ">
                    <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
               
                     <div class="col-md-3 ">
                         <input id="btnSearch" class="ItDoseButton" type="button" value="Search" onclick="$searchData();" />
                         <input type="text" style="display: none;" id="txtLabNo" /><input type="text" style="display: none;" id="txtLabID" />
                         <input type="text" style="display: none;" id="txtPID" />
                         <input type="text" style="display: none;" id="txtSinNo" />
                     </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    
                        <div class="col-md-10">
                            <div class="Purchaseheader">
                                Patient Detail 
                   <span style="font-weight: bold; color: black;">Total Patient:</span>
                                <asp:Label ID="lblTotalPatient" ForeColor="Black" runat="server" Style="color: black" />
                            </div>
                        </div>
                        <div class="col-md-14">
                            <div class="Purchaseheader">
                                Sample Detail :->
                                <span style="font-weight: bold; color: black;">Patient Name:</span>   
                                <asp:Label ID="lblPatientName" runat="server" Style="color: black" />
                   <span style="font-weight: bold; color: black;">::Total Test:</span>                                 
                                <asp:Label ID="lblSampleCount" runat="server" Style="color: black" />

                                <asp:Label ID="LabelError" Font-Bold="true" BackColor="Red" runat="server" Style="color: black" />
                            </div>
                        </div>
                   </div>
                </div>
                    <div class="row"> 
                       
                        <div class="col-md-10" style="overflow: auto;">
                                <table id="tb_ItemList" class="GridViewStyle" style="width:100%">
                                    <thead>
                                        <tr id="paheader">
                                            <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Select</th>
                                            <th class="GridViewHeaderStyle" scope="col">Visit No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">SIN No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Name</th>
                                        </tr>
                                    </thead>
                                     <tbody></tbody>
                                </table>
                          
                        </div>
                        <div class="col-md-14" style="overflow: auto;">
                          
                              
                                    
                                        <table id="tblSample" class="GridViewStyle" style="width:100%">
                                            <tr id="sampleHeader">
                                                <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                                                <th class="GridViewHeaderStyle" scope="col">Color Code</th>
                                                <th class="GridViewHeaderStyle" scope="col">Sample Type</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="display:none">Patient Name</th>
                                                <th class="GridViewHeaderStyle" scope="col">Investigation</th>
                                                <th class="GridViewHeaderStyle" scope="col">SIN&nbsp;No.</th>
                                                <th class="GridViewHeaderStyle" scope="col">
                                                    <input type="checkbox" onclick="call()" id="hd" />
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">IsSelf Coll. </th>
                                                <th class="GridViewHeaderStyle" scope="col">Vials Qty.</th>
                                                <th class="GridViewHeaderStyle" scope="col">#</th>
                                                <th class="GridViewHeaderStyle" scope="col">Re Print</th>
                                                <th class="GridViewHeaderStyle" scope="col">Re ject</th>


                                            </tr>
                                        </table>
                                    
                               <div class="row">
                                <div class="col-md-24" style="text-align: right">
                                    <input type="button" value="Collect" class="savebutton" onclick="$saveCollData()" id="btnCollect" style="display: none" />
                                </div>
                            </div>
                            </div>
                            
                        </div>
                   
             
          
        </div>

    </div>
  
    <div id="divRequiredField" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 800px; max-width: 50%">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeRequiredFieldsModel()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Required Fields</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div id="divRequiredFieldPopUp" class="col-md-24">
                            <table id="tblRequiredField" style="width: 95%; border-collapse: collapse; margin-left: 15px;">
                            </table>
                        </div>
                    </div>
                    <div style="text-align: center" class="row">
                        <input type="button" value="Save" class="savebutton" onclick="saveRequiredField(this, $(this).val())" id="btnSaveRequired" />
                        <input type="button" id="btnCancelRequiredField" value="Cancel" onclick="$closeRequiredFieldsModel()" class="resetbutton" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="sampledetail" style="display: none; position: absolute;"></div>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function $searchData() {
            var searchdata = $getSearchData();
            $searchSampleCollection();
            $('#tblSample,#btnCollect').hide();
            $('#lblSampleCount').html('0');
            $('#lblPatientName').html('');
        }
        function $searchSampleCollection() {
            $('#tb_ItemList tr').slice(1).remove();
            $('#tblSample tr').slice(1).remove();
            $('#txtLabNo,#txtLabID,#txtPID,#txtSinNo').val('');

            var $searchData = $getSearchData();
            serverCall('SampleCollection.aspx/SearchSampleCollection', { searchdata: $searchData }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $responseData = $responseData.response;
                    $('#lblTotalPatient').text($responseData.length);
                    if ($responseData.length == 0) {
                        toast("Info", "No Record Found", "");
                    }
                    else {
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $myData = [];
                            $myData.push("<tr class='clickablerow' id='");
                            $myData.push($responseData[i].ledgerTransactionNO); $myData.push("'");
                            $myData.push("><td class='GridViewLabItemStyle'>");
                            $myData.push(parseInt(i + 1)); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;"><img alt="" src="../../App_Images/view.gif" style="cursor:pointer;" ');
                            $myData.push('onclick="$showBarCodeData(\'');
                            $myData.push($responseData[i].ledgerTransactionNO);
                            $myData.push("\',\'"); 
                            $myData.push($responseData[i].ledgertransactionID); $myData.push("\',\'");
                            $myData.push($responseData[i].BarcodeNo); $myData.push("\')");
                            $myData.push('"/></td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].ledgerTransactionNO); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" ><b>'); $myData.push($responseData[i].BarcodeNo); $myData.push('</b></td>');
                            $myData.push('<td class="GridViewLabItemStyle"><b>'); $myData.push($responseData[i].PName); $myData.push('</b></td>');
                            $myData.push("</tr>");
                            $myData = $myData.join("");
                            $('#tb_ItemList tbody').append($myData);
                        }
                    }
                }
                else {
                    toast("Error", $responseData.response, "");

                }
            });
        }
        
        function $getSearchData() {
            $('#LabelError').text("");
            var $dataPLO = new Array();
            $dataPLO.push({
                CentreID: $('#ddlCentreAccess').val(),
                SampleStatus: $('#ddlSampleStatus').val(),
                SearchType: $('#ddlSearchType').val(),
                SearchValue: $('#txtSearchValue').val(),
                Department: $('#ddlDepartment').val(),
                FormDate: $('#txtFormDate').val(),
                FromTime: $('#txtFromTime').val(),
                ToDate: $('#txtToDate').val(),
                ToTime: $('#txtToTime').val(),
                PanelID: $('#ddlPanel').val(),
                UserID: $('#ddlUser').val()
            });
            return $dataPLO;
        }
        var $sampleCount = 0;
        function $showBarCodeData(labNo, labid, sinNo) {
            $('#tblSample tr').slice(1).remove();
            $('#LabelError').text("");
            $sampleCount = 0;
            $('#txtLabNo').val(labNo);
            $('#txtLabID').val(labid);
            $('#txtSinNo').val(sinNo);
            serverCall('SampleCollection.aspx/SearchInvestigation', { LabNo: labNo, SmpleColl: $("#ddlSampleStatus").val(), Department: $("#ddlDepartment").val(), sinNo: sinNo }, function (response) {
                var $testData = JSON.parse(response);
                if ($testData.response) {
                    $testData = $testData.response;
                    if ($testData.length == 0) {
                        $('#lblSampleCount').html('0');
                        $('#lblPatientName').html('');
                        $sampleCount = 0;
                        $('#btnCollect').hide();
                        return;
                    }
                    else {
                        $('#btnCollect,#tblSample').show();
                        for (var i = 0; i <= $testData.length - 1; i++) {
                            $('#txtPID').val($testData[i].patient_id);
                            $sampleCount = parseInt($sampleCount) + 1;
                            $('#lblSampleCount').text($sampleCount);
                            $('#lblPatientName').text($testData[i].PName);
                            var $myData = [];
                            $myData.push("<tr id='");
                            $myData.push($testData[i].Test_ID); $myData.push("'");
                            $myData.push("style='background-color:");
                            $myData.push($testData[i].rowcolor);
                            $myData.push(";'>");
                            $myData.push('<td  class="GridViewLabItemStyle">');
                            $myData.push(parseInt(i + 1));
                            $myData.push('</td><td id="colorcode_');
                            $myData.push(parseInt(i + 1));
                            $myData.push('"');
                            $myData.push('class="GridViewLabItemStyle" style="background-color:');
                            $myData.push($testData[i].ColorCode); $myData.push('">');
                            $myData.push('</td><td class="GridViewLabItemStyle" style="width:14%">');
                            if ($testData[i].IsSampleCollected == "N" || $testData[i].IsSampleCollected == "R") {
                                if ($testData[i].reporttype == "7") {
                                    var sampletype = $testData[i].SampleTypes.split('|')[1];
                                    if (sampletype.toUpperCase() == "NA")
                                        sampletype = "";
                                    $myData.push('<input id="txtSpecimenType" value="');
                                    $myData.push(sampletype);
                                    $myData.push('"');
                                    $myData.push(' type="text" placeholder="Enter Specimen Type" style="background-color:lightblue;"/>');
                                    $myData.push('<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlnoofsp"><option>0</option>');
                                    $myData.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                    $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                    $myData.push('<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofsli">');
                                    $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                    $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                    $myData.push('<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofblock">');
                                    $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                    $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                }
                                else {
                                    $myData.push('<select id="sampletypes" name="sampletypes_');
                                    $myData.push(parseInt(i + 1));
                                    $myData.push('"');
                                    $myData.push('onchange="CheckSampleTypeColor(this);"  style="background-color:pink;">');
                                    console.log($testData[i].SampleTypes);
                                    
                                        if ($testData[i].SampleTypes.split('$').length > 1) {
                                            $myData.push('<option value="0"></option>');
                                        }
                                        for (var c = 0; c <= $testData[i].SampleTypes.split('$').length - 1; c++) {
                                            $myData.push('<option value="');
                                            $myData.push($testData[i].SampleTypes.split('$')[c].split('|')[0]);
                                            $myData.push('">');
                                            $myData.push($testData[i].SampleTypes.split('$')[c].split('|')[1]);
                                            $myData.push('</option>');
                                        }
                                    
                                    $myData.push('</select>');
                                }
                            }
                            else {
                                if ($testData[i].reporttype == "7") {
                                    $myData.push($testData[i].SampleTypeName);
                                    try {
                                        $myData.push('<br/><strong>No of Container:&nbsp;&nbsp;');
                                        $myData.push($testData[i].HistoCytoSampleDetail.split('^')[0]);
                                        $myData.push('</strong>');
                                        $myData.push('<br/><strong>No of Slides:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                                        $myData.push($testData[i].HistoCytoSampleDetail.split('^')[1]);
                                        $myData.push('</strong>');
                                        $myData.push('<br/><strong>No of Block:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                                        $myData.push($testData[i].HistoCytoSampleDetail.split('^')[2]);
                                        $myData.push('</strong>');
                                    }
                                    catch (e) {
                                        $myData.push('<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlnoofsp"><option>0</option>');
                                        $myData.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                        $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                        $myData.push('<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofsli">');
                                        $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                        $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                        $myData.push('<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofblock">');
                                        $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                        $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                    }
                                }
                                else {
                                    if ($testData[i].IsSampleCollected == "R") {
                                        $myData.push('<select id="sampletypes" name="sampletypes_');
                                        $myData.push(parseInt(i + 1));
                                        $myData.push('"');
                                        $myData.push('onchange="CheckSampleTypeColor(this);" style="background-color:pink;">');
                                        if ($testData[i].SampleTypes.split('$').length > 1) {
                                            $myData.push('<option value="0"></option>');
                                        }
                                        for (var c = 0; c <= $testData[i].SampleTypes.split('$').length - 1; c++) {
                                            $myData.push('<option value="');
                                            $myData.push($testData[i].SampleTypes.split('$')[c].split('|')[0]);
                                            $myData.push('">');
                                            $myData.push($testData[i].SampleTypes.split('$')[c].split('|')[1]);
                                            $myData.push('</option>');
                                        }
                                        $myData.push('</select>');
                                    }
                                    else {
                                        $myData.push($testData[i].SampleTypeName);
                                    }
                                }
                            }
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="display:none"><b>');
                            $myData.push($testData[i].PName);
                            $myData.push('</b></td>');
                            $myData.push('<td class="GridViewLabItemStyle"><b>');
                            $myData.push($testData[i].name);
                            $myData.push('</b></td>');
                            var barcode = $testData[i].BarcodeNo;
                          
                            if ($testData[i].BarCodePrintedType == "System") {
                                $myData.push('<td class="GridViewLabItemStyle" id="tdBarcode">');
                                $myData.push('<input type="text" id="txtBarcode"  autocomplete="off" disabled="disabled" value=" ');
                                $myData.push($.trim($testData[i].BarcodeNo)); $myData.push('"/>');
                                $myData.push('</td>');
                            }
                            else {
                                if ($testData[i].IsSampleCollected == "N") {
                                    //   if ($testData[i].BarcodeNo != "") {
                                    //      $myData.push('<td class="GridViewLabItemStyle" id="tdBarcode">');
                                    //       $myData.push('<input type="text" id="txtBarcode" autocomplete="off" disabled="disabled"  value=" ');
                                    //      $myData.push($.trim($testData[i].BarcodeNo)); $myData.push('"/>');
                                    //      $myData.push('</td>');
                                    //  }
                                    //  else {
                                    if ($testData[i].setOfBarCode == "SampleType") {
                                        $myData.push('<td class="GridViewLabItemStyle" ><input id="txtBarcode" autocomplete="off"  class="');
                                        $myData.push($testData[i].SampleTypes.split('|')[0]); $myData.push('"');
                                        $myData.push('type="text" maxlength="8"');
                                        $myData.push();
                                        $myData.push('onkeyup="$fillSampleType(this,');
                                        $myData.push("'");
                                        $myData.push($testData[i].SampleTypes.split('|')[0]);
                                        $myData.push("');"); $myData.push('"');
                                        if ($testData[i].BarcodeNo != "") {
                                            $myData.push('placeholder="');
                                            $myData.push($testData[i].BarcodeNo); $myData.push('"');

                                        }
                                        else {
                                            $myData.push('placeholder="Entre Barcode" ');

                                        }
                                        $myData.push('"/>');
                                        $myData.push('</td>');
                                    }
                                    else {
                                        $myData.push('<td class="GridViewLabItemStyle" ><input id="txtBarcode" autocomplete="off"  class="-1" type="text" maxlength="8"  onkeyup=$fillSampleType(this,-1);  ');
                                        $myData.push('placeholder="Entre Barcode" style="background-color:lightblue;"/>');
                                        $myData.push('</td>');
                                    }
                                    //  }
                                }
                                else {
                                    if ($testData[i].IsSampleCollected == "R") {
                                        $myData.push('<td class="GridViewLabItemStyle" ><input id="txtBarcode" autocomplete="off" disabled="disabled"  class="-1" type="text" maxlength="8" value="  ');
                                        $myData.push($.trim($testData[i].BarcodeNo)); $myData.push('"');
                                        $myData.push('/>');
                                        $myData.push('</td>');
                                    }
                                    else {
                                        $myData.push('<td class="GridViewLabItemStyle" id="tdBarcode">');
                                        $myData.push('<span id="tdSinNo">');
                                        $myData.push($.trim($testData[i].BarcodeNo)); $myData.push('</span>');
                                        $myData.push('</td>');
                                    }
                                }
                            }

                            $myData.push('<td class="GridViewLabItemStyle" id="tdBarCodePrintedType" style="display:none;">');
                            $myData.push($testData[i].BarCodePrintedType);
                            $myData.push('</td><td class="GridViewLabItemStyle" id="tdLedgertransactionNo" style="display:none;">');
                            $myData.push($testData[i].LedgerTransactionNo);
                            $myData.push('</td><td class="GridViewLabItemStyle" id="tdIsSampleCollected" style="display:none;">');
                            $myData.push($testData[i].IsSampleCollected);
                            $myData.push('</td><td class="GridViewLabItemStyle"> ');
                            if ($testData[i].IsSampleCollected == "N" || $testData[i].IsSampleCollected == "S" || $testData[i].IsSampleCollected == "R") {
                                $myData.push('<input type="checkbox" ');
                                if ($testData[i].IsSampleCollected == "N") {
                                    $myData.push('checked="checked" ');
                                }
                                $myData.push(' id="mmchk"/>');
                            }
                            $myData.push('</td><td class="GridViewLabItemStyle"> ');                           
                                $myData.push('<input type="checkbox" ');
                                if ($testData[i].IsSampleCollectedByPatient == "1") {
                                    $myData.push('checked="checked" ');
                                }
                                $myData.push(' id="chkIsSampleCollectedByPatient"/>');
                                $myData.push('&nbsp;&nbsp;&nbsp');
                                $myData.push('<img alt="" src="../../App_Images/view.gif" style="cursor:pointer;" onmouseout="hideme();" ');
                                $myData.push('onmouseover="$getdetail(\'');
                                $myData.push($testData[i].MasterSampleQty);
                                $myData.push("\',\'");                                
                                $myData.push($testData[i].SampleRemarks); $myData.push("\')");
                                $myData.push('"/>');
                            $myData.push('</td><td class="GridViewLabItemStyle">');
                            if ($testData[i].reporttype != "7") {
                                $myData.push('<b>Vial Qty :<span class="sampleqty_');
                                $myData.push($testData[i].BarcodeNo);
                                $myData.push('"> ');
                                $myData.push($testData[i].SampleQty);
                                $myData.push('</span></b><br/>');
                                $myData.push();
                                if ($testData[i].IsSampleCollected != "Y") {
                                    $myData.push('<span style="cursor:pointer; color:white;background-color:green;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" ');
                                    $myData.push(' onclick="$addTube(\'');
                                    $myData.push($testData[i].BarcodeNo);
                                    $myData.push('\')">');
                                    $myData.push('+</span>');
                                    $myData.push('<span style="cursor:pointer; color:white;background-color:darkorchid;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;margin-left:5px;" ');
                                    $myData.push(' onclick="$removeTube(\'');
                                    $myData.push($testData[i].BarcodeNo);
                                    $myData.push('\')">');
                                    $myData.push('-</span>');
                                }
                            }
                            $myData.push('</td><td class="GridViewLabItemStyle" style="text-align:center;" id="mmtd"> ');
                            if ($testData[i].IsSampleCollected == "N") {
                                $myData.push('');
                            }
                            else if ($testData[i].IsSampleCollected == "S") {
                                $myData.push('<span style="cursor:pointer; color:white;background-color:green;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" ');
                                $myData.push(' onclick="showme(\'');
                                $myData.push($testData[i].SampleCollector); $myData.push("\',\' ");
                                $myData.push($testData[i].colldate); $myData.push("\')"); $myData.push('">C</span>');
                            }
                            else if ($testData[i].IsSampleCollected == "Y") {
                                $myData.push('<span style="cursor:pointer;color:white;background-color:blue;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;"');
                                $myData.push(' onclick="showme(\''); $myData.push($testData[i].SampleReceiver); $myData.push("\',\' ");
                                $myData.push($testData[i].recdate); $myData.push("\')"); $myData.push('">Y</span>');
                            }
                            else if ($testData[i].IsSampleCollected == "R") {
                                $myData.push('<span style="cursor:pointer;color:white;background-color:red;font-size:25px;padding-left:8px;padding-right:8px;border-radius:20px;" ');
                                $myData.push(' onclick="showme(\''); $myData.push($testData[i].SampleReceiver); $myData.push("\',\' "); $myData.push($testData[i].recdate);
                                $myData.push("\')");
                                $myData.push('">R</span>');
                            }
                            $myData.push('</td><td class="GridViewLabItemStyle" style="text-align:center;"> ');
                            if ($testData[i].IsSampleCollected != "N" && $testData[i].IsSampleCollected != "R") {
                                $myData.push('<img alt="" src="../../App_Images/print.gif" style="cursor:pointer" ');
                                $myData.push(' onclick="getBarcodeDetail1(\'');
                                $myData.push($testData[i].Test_ID); $myData.push("\');"); $myData.push('"/>');
                            }
                            $myData.push('</td><td class="GridViewLabItemStyle" style="text-align:center;"> ');
                            if ($testData[i].IsSampleCollected != "N" && $testData[i].IsSampleCollected != "R") {
                                $myData.push('<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" ');
                                $myData.push(' onclick="$openReject(\'');
                                $myData.push($testData[i].Test_ID); $myData.push("\');"); $myData.push('">');
                                $myData.push('R</span>');
                            }
                            $myData.push('</td><td id="tdSampleRecollectAfterReject" style="display:none;">');
                            $myData.push($testData[i].SampleRecollectAfterReject);
                            $myData.push('</td><td id="tdReportType" style="display:none;">');
                            $myData.push($testData[i].reporttype);
                            $myData.push('</td><td id="tdRequiredFields" style="display:none;">');
                            $myData.push($testData[i].RequiredFields);
                            $myData.push('</td>');
                            $myData.push('<td id="tdInterface_companyName" style="display:none;">');
                            $myData.push($testData[i].Interface_companyName);
                            $myData.push('</td></tr>');
                            $myData = $myData.join("");
                            $('#tblSample').append($myData);
                        }
                    }
                }
                else {
                    toast("Error", $testData.response, "");
                }
            });
        }
        function $fillSampleType(Ctrl, _SampleID) {
            $("#tblSample tr").find("." + _SampleID).val($(Ctrl).val());
        }
        function $checkRequiredField() {
            var $field = [];
            var $requiredFiled = [];
            $('#tblSample tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "sampleHeader") {
                    if ($(this).closest("tr").find("#tdRequiredFields").text() != "") {
                        $field.push($(this).closest("tr").find("#tdRequiredFields").text());
                    }
                }
            });
            if ($field.length > 0) {
                for (var i = 0; i < $field.length ; i++) {
                    $requiredFiled.push($field[i]);
                }
                var $uniqueNames = [];
                $.each($requiredFiled, function (i, el) {
                    if ($.inArray(el, $uniqueNames) === -1) $uniqueNames.push(el);
                });
                return $uniqueNames.join(',');
            }
            else {
                return "";
            }
        }
        var $closeRequiredFieldsModel = function (callback) {
            $('#divRequiredField').hideModel();
        }
        function $requiredFiled() {
            var datarequired = new Array();
            $('#tblRequiredField tr').each(function () {
                var objRequ = new Object();
                objRequ.FieldID = $(this).attr("id");
                objRequ.FieldName = $(this).find('#tdRequiredFiledName').text();
                if ($(this).find('#tdRequiredInputType').text() == "CheckBox") {
                    if ($(this).find('#tdRequiredInput').find('.clRequiredInput').is(':checked')) {
                        objRequ.FieldValue = "1";
                    }
                    else {
                        objRequ.FieldValue = "0";
                    }
                }
                else {
                    objRequ.FieldValue = $(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                }
                if ($(this).find('#tdRequiredUnit').text() != "") {
                    objRequ.Unit = $(this).find('#tdRequiredInput').find('.unit').val();
                }
                else {
                    objRequ.Unit = "";
                }
                objRequ.LedgerTransactionID = $('#txtLabID').val();
                objRequ.LedgerTransactionNo = $('#txtLabNo').val();

                datarequired.push(objRequ);
            });
            return datarequired;
        }
        function CheckSampleTypeColor(Control) {
            var SampleTypeId = Control.value;
            var Rowindex = Control.name.split('_')[1];
            serverCall('SampleCollection.aspx/ChangeSampleTypeColor', { SampleTypeId: SampleTypeId }, function (response) {
                var $ColorCode = response;
                $('#tblSample tbody tr').each(function () {
                    $(this).find('#colorcode_' + Rowindex + '').css("background-color", $ColorCode);
                },'','',false);
            });
        }
        function saveRequiredField() {
            var sn = 0;
            $('#tblRequiredField tr').each(function () {
                if ($(this).find('#tdRequiredInput').find('.clRequiredInput').val() == "") {
                    sn = 1;
                    finame = $(this).find('#tdRequiredFiledName').text();
                    $(this).find('#tdRequiredInput').find('.clRequiredInput').focus();
                    return false;
                }
            });
            if (sn == 1) {
                toast("Error", "".concat("Please Enter ", finame), "");
                return false;
            }
            var $RequiredField = $requiredFiled();
            serverCall('SampleCollection.aspx/SaveRequiredField', { RequiredField: $RequiredField }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {                  
                    $closeRequiredFieldsModel();
                    var data = getdata();
                    if (data == "15") {
                        toast("Error", "Please Entre Barcode", "");
                        return;
                    }
                    if (data == "") {
                        toast("Error", "Please Select Sample To Collect", "");
                        return;
                    }
                    if (data == "1") {
                        toast("Error", "Sample Already Collected", "");
                        return;
                    }
                    if (data == "5") {
                        toast("Error", "Please Select Sample Type", "");
                        return;
                    }
                    if (data == "10") {
                        toast("Error", "Please Enter Specimen Type", "");
                        return;
                    }
                    if (data == "3") {
                        toast("Error", "Rejected Sample is not collected for this client....", "");
                        return;
                    }
                    $sampleDataSave(data);
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        function getBarcodeDetail1(_barcode) {
            try {
                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.LedgerTransactionNo = '';
                objbarcodedata.BarcodeNo = '';
                objbarcodedata.Test_ID = _barcode;
                barcodedata.push(objbarcodedata);
                serverCall('Services/LabBooking.asmx/getBarcode', { data: barcodedata }, function (response) {
                    window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                });
            }
            catch (e) {
                alert("Barcode Printer Not Install");
            }
        }       
        $openReject = function (testid) {
            $encryptQueryStringData(testid, function ($returnData) {
                $fancyBoxOpen('SampleReject.aspx?test_id=' + $returnData + '');
            });
        }       
        function $addTube(tid) {
            var qty = $('.sampleqty_' + tid).html();
            qty = parseInt(qty) + 1;
            $('.sampleqty_' + tid).html(qty);
            serverCall('SampleCollection.aspx/AddTube', { TestID: tid, qty: qty }, function (response) {
                TestData1 = JSON.parse(response);
                if (TestData1.status) {
                    toast("Success", "Added Successfully", "");
                }
                else {
                    toast("Error", "Error", "");
                }
            });
        }
        function $removeTube(tid) {
            var qty = $('.sampleqty_' + tid).html();
            if (parseInt(qty) == 1) {
                toast("Info", "Tube Can't be less then 1", "");
                return;
            }
            qty = parseInt(qty) - 1;
            $('.sampleqty_' + tid).html(qty);
            serverCall('SampleCollection.aspx/AddTube', { TestID: tid, qty: qty }, function (response) {
                TestData1 = JSON.parse(response);
                if (TestData1.status) {
                    toast("Success", "Removed Successfully", "");
                }
                else {
                    toast("Error", "Error", "");
                }
            });

        }
        function showme(u, d) {
            confirmationBox('User:-' + u + "</br>Date:-" + d);
        }
        function confirmationBox(contentMsg) {
            $.alert({
                title: 'Alert!',
                content: contentMsg,
            });
        }
        function confirmationBox(contentMsg) {
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
                    somethingElse: {
                        text: 'Ok',
                        action: function () {
                            clearSampleAction();
                        }
                    },
                }
            });
        }
        function clearSampleAction() {

        }
        function call() {
            if ($('#hd').prop('checked') == true) {
                $('#tblSample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "sampleHeader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', true);
                    }
                });
            }
            else {
                $('#tblSample tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "sampleHeader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', false);
                    }
                });
            }
        }
        function getdata() {
            var sccount = 0;
            var barcode = 0;
            var nccount = 0;
            var smtype = 0;
            var $RejectSampletocollect = 0;
            var dataPLO = new Array();
            $('#tblSample tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "sampleHeader") {
                    if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                        if ($.trim($(this).closest("tr").find('#txtBarcode').val()) == "") {
                            barcode = 15;
                        }
                        if ($(this).closest("tr").find("#tdIsSampleCollected").text() == "S") {
                            sccount = parseInt(sccount) + 1;
                        }
                        else if ($(this).closest("tr").find("#tdSampleRecollectAfterReject").html() == "0" && $(this).closest("tr").find("#tdIsSampleCollected").html() == "R") {
                           $RejectSampletocollect = 3;
                        }
                        else {
                            nccount = parseInt(nccount) + 1;
                            var samplerec = "";
                            if ($(this).closest("tr").find("#tdReportType").text() == "7") {
                                if ($(this).find('#txtSpecimenType').val() == "") {
                                    smtype = 10;
                                }
                                samplerec = $(this).find('#ddlnoofsp').val() + "^" + $(this).find('#ddlnoofsli').val() + "^" + $(this).find('#ddlnoofblock').val();

                                dataPLO.push({
                                    Test_ID: $(this).closest("tr").attr("id"),
                                    SampleTypeID: "0",
                                    SampleTypeName: $(this).find('#txtSpecimenType').val(),
                                    ReportType: $(this).closest("tr").find("#tdReportType").text(),
                                    HistoCytoSampleDetail: samplerec,
                                    BarcodeNo: $(this).closest("tr").find('#txtBarcode').val(),
                                    Interface_companyName: $(this).closest("tr").find("#tdInterface_companyName").text(),
                                    LedgertransactionNo: $(this).closest("tr").find('#tdLedgertransactionNo').text(),
                                    IsSampleCollectedByPatient: $(this).closest("tr").find('#chkIsSampleCollectedByPatient').is(':checked') ? 1 : 0                                    
                                });
                                // dataPLO.push($(this).closest("tr").attr("id") + "#0#" + $(this).find('#txtSpecimenType').val() + "#" + $(this).closest("tr").find("#tdReportType").text() + "#" + samplerec + "#" + $(this).closest("tr").find('#txtBarcode').val() + "#" + $(this).closest("tr").find("#tdInterface_companyName").text() + "#" + $(this).closest("tr").find('#tdLedgertransactionNo').text());
                            }
                            else {
                                if ($(this).find('#sampletypes').val() == "0") {
                                    smtype = 1;
                                }
                                samplerec = "";
                                dataPLO.push({
                                    Test_ID: $(this).closest("tr").attr("id"),
                                    SampleTypeID: $(this).find('#sampletypes').val(),
                                    SampleTypeName: $(this).find('#sampletypes option:selected').text(),
                                    ReportType: $(this).closest("tr").find("#tdReportType").text(),
                                    HistoCytoSampleDetail: samplerec,
                                    BarcodeNo: $(this).closest("tr").find('#txtBarcode').val(),
                                    Interface_companyName: $(this).closest("tr").find("#tdInterface_companyName").text(),
                                    LedgertransactionNo: $(this).closest("tr").find('#tdLedgertransactionNo').text(),
                                    IsSampleCollectedByPatient: $(this).closest("tr").find('#chkIsSampleCollectedByPatient').is(':checked') ? 1 : 0
                                });
                                // dataPLO.push($(this).closest("tr").attr("id") + "#" + $(this).find('#sampletypes').val() + "#" + $(this).find('#sampletypes option:selected').text() + "#" + $(this).closest("tr").find("#tdReportType").text() + "#" + samplerec + "#" + $(this).closest("tr").find('#txtBarcode').val() + "#" + $(this).closest("tr").find("#tdInterface_companyName").text() + "#" + $(this).closest("tr").find('#tdLedgertransactionNo').text());
                            }
                        }
                    }
                }
            });
            if (barcode == 15) {
                return "15";
            }
            if (smtype == 1) {
                return "5";
            }
            if (smtype == 10) {
                return "10";
            }
            if (nccount == 0 && sccount != 0) {
                return "1";
            }
            if ($RejectSampletocollect == 3) {
                return "3";
            }
            return dataPLO;
        }
        function $bindallRequiredField(item) {
            $('#tblRequiredField tr').remove();
            var _temp = [];
            _temp.push(serverCall('SampleCollection.aspx/bindAllRequiredField', { requiredFiled: item, LabNo: $('#txtLabNo').val() }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    for (var i = 0; i <= $ReqData.length - 1; i++) {
                        var $myData = [];
                        $myData.push("<tr id='"); $myData.push($ReqData[i].id); $myData.push("'");
                        $myData.push('style="background-color:lightgoldenrodyellow;height:21px;" class="my'); $myData.push(i); $myData.push('">');
                        $myData.push('<td align="left" id="tdRequiredFiledName" style="font-weight:bold;"  >');
                        $myData.push($ReqData[i].FieldName);
                        $myData.push('</td>');
                        $myData.push('<td align="left" id="tdRequiredInput"  >');
                        if ($ReqData[i].InputType == "TextBox") {
                            $myData.push('<input type="text" class="clRequiredInput requiredField"  value=" ');
                            $myData.push($ReqData[i].FieldValue); $myData.push('"');
                            $myData.push('/>');
                        }
                        else if ($ReqData[i].InputType == "DropDownList") {
                            $myData.push('<select  class="clRequiredInput requiredField">');
                            for (var a = 0; a <= $ReqData[i].DropDownOption.split('|').length - 1; a++) {
                                $myData.push('<option>');
                                $myData.push($ReqData[i].DropDownOption.split('|')[a]);
                                $myData.push('</option>');
                            }
                            $myData.push('</select>');
                        }
                        else if ($ReqData[i].InputType == "CheckBox") {
                            if ($ReqData[i].FieldValue == "1") {
                                $myData.push('<input type="checkbox"  class="clRequiredInput" checked="checked"/>');
                            }
                            else {
                                $myData.push('<input type="checkbox"  class="clRequiredInput" />');
                            }
                        }
                        else if ($ReqData[i].InputType == "Date") {
                            $myData.push('<input type="text" id="txtReuiredAppDate');
                            $myData.push($ReqData[i].InputType); $myData.push('"');
                            $myData.push(' class="clRequiredInput requiredField"  value="');
                            $myData.push($ReqData[i].FieldValue);
                            $myData.push('"');
                            $myData.push('/>');
                        }
                        if ($ReqData[i].Unit != "") {
                            $myData.push('<select   class="unit">');
                            for (var a = 0; a <= $ReqData[i].Unit.split('|').length - 1; a++) {
                                $myData.push('<option>');
                                $myData.push($ReqData[i].Unit.split('|')[a]);
                                $myData.push('</option>');
                            }
                            $myData.push('</select>');
                        }
                        $myData.push('</td>');
                        $myData.push('<td align="left" id="tdRequiredUnit" style="display:none;"  >');
                        $myData.push($ReqData[i].Unit);
                        $myData.push('</td>');
                        $myData.push('<td align="left" id="tdRequiredInputType" style="display:none;"  >');
                        $myData.push($ReqData[i].InputType);
                        $myData.push('</td>');

                        $myData.push('<td align="left" id="tdRequiredUnitSaved" style="display:none;"  >');
                        $myData.push($ReqData[i].savedunit);
                        $myData.push('</td>');

                        $myData.push('<td align="left" id="tdRequiredInputTypeSaved" style="display:none;"  >');
                        $myData.push($ReqData[i].FieldValue);
                        $myData.push('</td>');

                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblRequiredField').append($myData);

                        $("".concat("#txtReuiredAppDate", $ReqData[i].InputType)).datepicker({
                            dateFormat: "dd-M-yy"
                        });
                        $('#ui-datepicker-div').css('z-index', '999999');
                    }
                    tablefunctionnew();
                    $('#divRequiredField').showModel();
                    $('.my0').find('#tdRequiredInput').find('.clRequiredInput').focus();
                });
            }));
        }
        function tablefunctionnew() {
            $('#tblRequiredField tr').each(function () {
                if ($(this).find('#tdRequiredUnitSaved').text() != "") {
                    $(this).find('#tdRequiredInput').find('.unit').val($(this).find('#tdRequiredUnitSaved').text());
                }
                $(this).find('#tdRequiredInput').find('.clRequiredInput').val($(this).find('#tdRequiredInputTypeSaved').text());
            });
        }
        function $saveCollData() {
            var data = getdata();
            if (data == "15") {
                toast("Error", "Please Entre Barcode", "");
                return;
            }
            if (data == "") {
                toast("Error", "Please Select Sample To Collect", "");
                return;
            }
            if (data == "1") {
                toast("Error", "Sample Already Collected", "");
                return;
            }
            if (data == "5") {
                toast("Error", "Please Select Sample Type", "");
                return;
            }
            if (data == "10") {
                toast("Error", "Please Enter Specimen Type", "");
                return;
            }
            if (data == "3") {
                toast("Error", "Rejected Sample is not collected for this Panel....", "");
                return;
            }
            var $requiredFiled = $checkRequiredField();
            if ($requiredFiled != "") {
                $bindallRequiredField($requiredFiled);
                return;
            }
            $sampleDataSave(data);
        }
        function $sampleDataSave(data) {
            var _$temp = [];
            _$temp.push(serverCall('SampleCollection.aspx/saveSamplecollection', { data: data }, function (response) {
                $.when.apply(null, _$temp).done(function () {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $showBarCodeData($('#txtLabNo').val(), $('#txtLabID').val(), $('#txtSinNo').val());
                        $getBarcodeDetail(data);
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                })
            }));
        }

        
        
    </script>

    <script type="text/javascript">
        function $getBarcodeDetail(data) {
            try {

                var $barCodeData = new Array();
                var $objBarCodeData = new Object();

                for (var i = 0; i < data.length; i++) {

                   // if (data[i].split('#')[6] == "") {
                    $objBarCodeData.LedgerTransactionNo = data[i]["LedgertransactionNo"];
                    $objBarCodeData.BarcodeNo = data[i]["BarcodeNo"].trim();
                        $objBarCodeData.Test_ID = "";//.concat("'", data[i]["Test_ID"], "'");//"".concat("'", data[i], "'");
                        $barCodeData.push($objBarCodeData);
                  //  }
                }
                if ($barCodeData.length > 0) {
                    serverCall('Services/LabBooking.asmx/getBarcode', { data: $barCodeData }, function (response) {
                        window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                    });
                }
            }
            catch (e) {

            }
        }
        function $bindPanel(CentreIDAll, TypeOfCall) {
            var $centreID;
            if (TypeOfCall == "Auto" || $("#ddlCentreAccess").val() == "ALL") {
                $centreID = $centreIDs.join(",");
            }
            else {
                $centreID = $("#ddlCentreAccess").val();
            }
            var $ddlPanel = $('#ddlPanel');
            $("#ddlPanel option").remove();
            serverCall('SampleCollection.aspx/bindPanel', { CentreID: $centreID }, function (response) {
                if ($("#ddlCentreAccess").val() == "ALL")
                   // $ddlPanel.append($("<option></option>").val("ALL").html("ALL Rate Type"));
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), defaultValue: 'All Panel', valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
                else
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
                $ddlPanel.attr("disabled", false);
                $ddlPanel.trigger('chosen:updated');
            });
        }
    </script>

    <script type="text/javascript">
        var $centreIDs = [];
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $centreIDs = [];
            $("#ddlCentreAccess option").each(function () {
                if (this.value != "ALL") {
                    $centreIDs.push(this.value);
                }
            });

            $bindPanel($centreIDs.join(","), 'Auto');
            $("#txtSearchValue").keydown(
                function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 13 || key == 9) {
                        $searchSampleCollection();
                    }
                });
            
            var $table = $("#tb_ItemList");
            $table.delegate("tr.clickablerow", "click", function () {
                $table.find("tr.clickablerow").removeClass('rowColor');
                $(this).addClass('rowColor'); 
            });
        });

        function $getdetail(MasterSampleQty, SampleRemarks) {
            $('#trrow').remove();
            var $temp = [];
            $temp.push("<div id='show' >");
            $('#trrow').remove();
            $temp.push("<table id='trrow' cellspacing='0' style='width:200px;font-family:Arial; font-size:12px; '  rules='all' frame='box' border='1' >");
            $temp.push("<tr style='background-color:black;color:white; font-weight:bold;'>");
            $temp.push("<th style='width:90px;text-align:left;'>Sample Qty</th>");
            $temp.push("<th style='width:150px;text-align:left;'>Sample Remarks </th>");           
            $temp.push("</tr>");
            $temp.push("<tr  style='background-color:#d3d3d3;color:black; font-weight:bold;'>");
            $temp.push("<td style='width:90px;text-align:left;'>"); $temp.push(MasterSampleQty); $temp.push("</td>");
            $temp.push("<td style='width:150px;text-align:left;'>"); $temp.push(SampleRemarks); $temp.push("</td>");
            $temp.push("</tr>");
            $temp.push("</table>");
            $temp.push("</div>");
            $temp = $temp.join("");
            $('#sampledetail').append($temp);
            $('#sampledetail').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        function hideme() {
            $('#sampledetail').hide();
        }
    </script>

</asp:Content>

