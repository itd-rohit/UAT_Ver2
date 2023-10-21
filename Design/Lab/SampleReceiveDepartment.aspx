<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleReceiveDepartment.aspx.cs" Inherits="Design_Lab_SampleReceiveDepartment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
         <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
         <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style> 
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>
                Department Received</b>
                  
        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">Search</div>
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">
                        <label class="pull-left">From Date</label>
                        <b class="pull-right">:</b>
                    </div>                 
                            <div class="col-md-3">
                                <asp:TextBox ID="txtFormDate" runat="server" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                            </div>
                            <div class="col-md-2">
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
                            <div class="col-md-3">
                        <label class="pull-left">To Date</label>
                        <b class="pull-right">:</b>
                    </div>           
                            <div class="col-md-3">
                                <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                    ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                                    InvalidValueMessage="*">
                                </cc1:MaskedEditValidator>
                            </div>                                      
                    <div class="col-md-3">
                        <label class="pull-left">Department</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <%--<asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment chosen-select"></asp:DropDownList>--%>
                        <asp:ListBox ID="ddlDepartment" runat="server" CssClass="multiselect" SelectionMode="Multiple" ></asp:ListBox>
                    </div>
                </div>
       </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlSearchType" runat="server" onchange="$movetoNext(this, 'txtSearchValue')" ClientIDMode="Static">
                            <asp:ListItem Value="pli.LedgertransactionNo" >Visit ID</asp:ListItem>
                            <asp:ListItem Value="lt.patient_id">UHID</asp:ListItem>
                            <asp:ListItem Value="pli.BarcodeNo" Selected="True">SIN No.</asp:ListItem>
                            <asp:ListItem Value="lt.PName">Patient Name</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtSearchValue" MaxLength="30" runat="server" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Panel</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select"></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Test Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlInvestigation" runat="server" class="ddlInvestigation chosen-select"></asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="col-md-3">
                        <label class="pull-left">SIN No.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtSinNo" MaxLength="15" placeholder="Scan SIN No. Here" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3"></div>
                    <div class="col-md-5">
                        <input id="btnSearch" class="savebutton" type="button" value="Search" onclick="SearchSampleCollection('S');" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Machine</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlMachine" runat="server" class="ddlMachine chosen-select"></asp:DropDownList>
                        <span id="spnFileName"  style="display:none"></span>
                        <span id="spnPatient_ID"  style="display:none"></span>
                         <span id="spnLabNo"  style="display:none"></span>
                    </div>
                </div>
            </div>
            <div class="row">
                <br />
                <div class="col-md-24 col-xs-24" style="text-align: center">
                    <span style="color: black; border: 1px solid black; background-color: lightyellow; padding: 5px; cursor: pointer;" onclick="SearchSampleCollection('S');">Pending </span>
                    <span style="color: black; border: 1px solid black; background-color: lightgreen; padding: 5px; cursor: pointer;" onclick="SearchSampleCollection('Y');">Received </span>
                    <span style="color: black; border: 1px solid black; background-color: pink; padding: 5px; cursor: pointer;" onclick="SearchSampleCollection('R');">Rejected</span>
                </div>
            </div>
        </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            Patient Detail&nbsp;&nbsp;&nbsp; 
                   <span style="font-weight: bold; color: black;">Total Investigation(s):</span>
            <asp:Label ID="lblTotalPatient" ForeColor="black" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="row" style="max-height: 310px; overflow: scroll;">
            <div class="col-md-24 col-xs-24">
                <table style="width: 100%" id="tblSample" class="GridViewStyle">
                    <tr id="sampleHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Reg Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">SRA Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">SIN No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Visit No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">UHID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">PName</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Sample Type</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Sec No</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Vial Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">TestName</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Status</th>
                        <td class="GridViewHeaderStyle" >Manual Doc</td>
                        <td class="GridViewHeaderStyle" >Scan Doc</td>
                        <td class="GridViewHeaderStyle" >Rej ect</td>
                        <%--<th class="GridViewHeaderStyle" >Attch.</th>--%>
                        <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">
                          <input type="checkbox" onclick="call()" id="hd" /></th>
                    </tr>
                </table>
            </div>
        </div>
        <table id="tblReason" style="display: none; ">
            <tr>          
                <td style="float:left;width:1180px;">
                    <input type="button" value="Transfer" class="searchbutton" onclick="$saveTranferData()" />
                </td>
               <td style="float:right;width:40px;">
                    <input type="button" value="Receive" class="savebutton" onclick="$saveCollData()" />
                    <asp:Label ID="lbfileName" runat="server" Style="display: none;"></asp:Label>
                </td>
                
            </tr>
        </table>
    </div>
    </div>
      <div id="divDocumentMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 900px; height: 600px">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Patient Scan Documents Details</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$divDocumentMatersCloseModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>			
			</div>
			<div class="modal-body">
				<table style="width: 100%;">
					<tr>
						<td style="width:300px">
							<div id="documentMasterDiv" style="height:470px;overflow:auto">							  
							</div>
						</td>
						<td style="width:60%;overflow:auto"">
							<img style="width: 100%; height: 470px; cursor:pointer"   src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" id="imgDocumentPreview"  alt="Preview" />
						</td>
					</tr>
				</table>
			</div>
			<div class="modal-footer">
				 <span id="spnSelectedDocumentID" style="display:none"></span>
				 
				 <input id="file" name="url[]"  style="display:none" type="file" accept="image/x-png,image/gif,image/jpeg,image/jpg"  onchange="handleFileSelect(event)" />
				 <button type="button" style="font-weight:bold"  onclick="$divDocumentMatersCloseModel()">Close</button>
			</div>
		</div>
	</div>
</div>
        <div id="divDocumentMaualMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 760px;">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Patient Manual Documents Details</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$divDocumentMaualCloseModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
			</div>
			<div class="modal-body">				
                <div id="divManualUpload" style="overflow:auto">							  
							</div>               
                            <table id="tblMaualDocument" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="trManualDocument">
					                <th class="GridViewHeaderStyle" >Document Type</th>	
                                    <th class="GridViewHeaderStyle" >Document Name</th>	
                                    <th class="GridViewHeaderStyle" >Uploaded By</th>
                                    <th class="GridViewHeaderStyle" >Date</th>
                                    <th class="GridViewHeaderStyle" >View</th>									
								</tr>
							</thead>
							<tbody></tbody>
						</table>
			</div>
			
		</div>
	</div>
</div>
    <script type="text/javascript">
        var searchType = 0;
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
            $("#txtSinNo").keydown(
                function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 13) {
                        e.preventDefault();
                        if ($.trim($('#txtSinNo').val()) != "") {
                            //searchType = 1;
                            SearchSampleCollection('S');
                        }
                    }
                });
            $bindDocumentMasters();
            jQuery('[id*=ddlDepartment]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });

        var pcount = 0;
        SearchSampleCollection = function (type) {
            $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            $('#tblSample tr').slice(1).remove();

            pcount = 0;
            var $searchData = $getSearchData(type);
            serverCall('SampleReceiveDepartment.aspx/SearchSampleReceive', { searchdata: $searchData }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status == false) {
                    $('#tblReason').hide();
                    $('#lblTotalPatient').html('0');
                    toast("Error", $responseData.response, "");
                }
                else {
                    $('#tblReason').show();
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        $('#tblReason').hide();
                        $('#lblTotalPatient').html('0');
                        toast("Info", "No Record Found", "");
                    }
                    for (var i = 0; i <= $responseData.length - 1; i++) {
                        pcount = parseInt(pcount) + 1;
                        $('#lblTotalPatient').text(pcount);
                        var $myData = [];
                        $myData.push("<tr id='");
                        $myData.push($responseData[i].test_id); $myData.push("'");
                        $myData.push("style='background-color:");
                        $myData.push($responseData[i].rowcolor); $myData.push(";height:25px;'>");
                        $myData.push('<td class="GridViewLabItemStyle">');
                        $myData.push(parseInt(i + 1));
                        if ($responseData[i].IsUrgent == '1') {
                            $myData.push('<img title="Urgent" src="../../App_Images/urgent.gif"/>');
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">');
                        $myData.push($responseData[i].RegDate);
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">');
                        $myData.push($responseData[i].SRADate);
                        $myData.push('</td>');
                        $myData.push('<td ID="tdBarcodeNo" class="GridViewLabItemStyle">');
                        $myData.push($responseData[i].BarcodeNo);
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"><b>');
                        $myData.push($responseData[i].ledgerTransactionNO);
                        $myData.push('</b></td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdPatient_ID"><b>');
                        $myData.push($responseData[i].patient_id);
                        $myData.push('</b></td>');
                        $myData.push('<td class="GridViewLabItemStyle">');
                        $myData.push($responseData[i].PName); $myData.push('</td>');
                        $myData.push('</td>');
                        if ($responseData[i].reporttype == "7") {
                            if ($responseData[i].status == "Pending") {
                                $myData.push('<td class="GridViewLabItemStyle"><input id="txtSpecimenType" type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;" value="');
                                $myData.push($responseData[i].SampleTypeName);
                                $myData.push('"/>');
                                $myData.push('<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlnoofsp"><option>0</option>');
                                $myData.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                $myData.push('<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofsli">');
                                $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                $myData.push('<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlnoofblock">');
                                $myData.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                                $myData.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                                $myData.push('<br/>');
                                $myData.push('<select class="performingDoc" id="performingDocID" style="width:140px;background-color:pink;"> </select>');
                                if ($responseData[i].subcategoryid == "7") {
                                    $myData.push('<select  id="ddlCheckFormline" style="width:140px;background-color:skyblue;margin-top:3px;"><option value="0">Select Formalin</option><option value="1">With Formalin</option><option value="2">Without Formalin</option> </select>');
                                }
                                $myData.push(' </td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle">');
                                $myData.push($responseData[i].SampleTypeName);
                                $myData.push('<br/><strong>No of Container:&nbsp;&nbsp;');
                                $myData.push($responseData[i].HistoCytoSampleDetail.split('^')[0]);
                                $myData.push('</strong>');
                                $myData.push('<br/><strong>No of Slides:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                                $myData.push($responseData[i].HistoCytoSampleDetail.split('^')[1]);
                                $myData.push('</strong>');
                                $myData.push('<br/><strong>No of Block:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                                $myData.push($responseData[i].HistoCytoSampleDetail.split('^')[2]);
                                $myData.push('</strong>');
                                $myData.push('<br/><strong>Doctor:');
                                $myData.push($responseData[i].Performingdoctor);
                                $myData.push('</strong>');
                                if ($responseData[i].subcategoryid == "7") {
                                    $myData.push('<br/><span>Formalin:');
                                    $myData.push($responseData[i].Formalin);
                                    $myData.push('</span>');
                                }
                                $myData.push(' </td>');
                            }
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle"><span id="oldsampletype">');
                            $myData.push($responseData[i].SampleTypeName);
                            $myData.push('</span></td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle"><b>');
                        $myData.push($responseData[i].slidenumber);
                        $myData.push('</b></td><td class="GridViewLabItemStyle"><b>');
                        $myData.push($responseData[i].sampleqty);
                        $myData.push('</b></td><td class="GridViewLabItemStyle">');
                        $myData.push($responseData[i].itemname);
                        $myData.push('</b></td><td class="GridViewLabItemStyle" id="Status">');
                        $myData.push($responseData[i].status); $myData.push('</b></td>');
                        $myData.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/show2.png" style="cursor:pointer;width:20px;height:20px;" ');

                        $myData.push(' onclick="$showManualDocumentMaster(\'');
                        $myData.push($responseData[i].patient_id); $myData.push("\',"); $myData.push("\'");
                        $myData.push($responseData[i].ledgerTransactionNO); $myData.push("\');"); $myData.push('"/></td>');

                        $myData.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/show2.png" style="cursor:pointer;width:20px;height:20px;" ');
                        $myData.push(' onclick="$showDocumentMaster(\'');
                        $myData.push($responseData[i].patient_id); $myData.push("\',"); $myData.push("\'");
                        $myData.push($responseData[i].ledgerTransactionNO); $myData.push("\');"); $myData.push('"/>');
                       
                        if ($responseData[i].subcategoryid == "7" && $responseData[i].IsSampleCollected == "Y") {
                            $myData.push('<input type="button" value="Print TRF" onclick="openmytrf('); $myData.push($responseData[i].test_id);
                            $myData.push(')" style="background-color:#673AB7;color:white;cursor:pointer;font-weight:bold;float:right;">');
                        } 
                        $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;"> ');
                        $myData.push('<span title="Click To Reject Sample" style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="$openReject(\' ');
                        $myData.push($responseData[i].test_id); $myData.push("\');"); $myData.push('"');
                        $myData.push(">R</span>");
                        $myData.push('</td>');
                        $myData.push('<td  class="GridViewLabItemStyle" style="display:none" ><input id="hdRequiredAttachment" type="hidden" value="');
                        $myData.push($responseData[i].RequiredAttachment);
                        $myData.push('">');
                        $myData.push('<input  id="hdRequiredAttachmentAt"  type="hidden" value="');
                        $myData.push($responseData[i].AttchmentRequiredAt);
                        $myData.push('">');
                        $myData.push('<input  id="hdAttachmentCount"  type="hidden" value="');
                        $myData.push($responseData[i].AttachmentCount);
                        $myData.push('">');
                        //if ($responseData[i].RequiredAttachment != "") {
                        //    $myData.push('<a href="#" onclick="showuploadbox(this)"> <img src="../../App_Images/attachment.png" /></a>');
                        //}
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:left;">');
                        if ($responseData[i].status != 'Rejected') {
                            if (type == "0" && $responseData[i].result_flag == "0") {
                                $myData.push('<input type="checkbox" id="mmchk" checked="checked"/>');
                            }
                            else {
                                if ($responseData[i].result_flag == "0") {
                                    $myData.push('<input type="checkbox" id="mmchk"/>');
                                }
                            }
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="pid" style="display:none;">');
                        $myData.push($responseData[i].patient_id);
                        $myData.push('</td><td class="GridViewLabItemStyle" id="labno" style="display:none;">');
                        $myData.push($responseData[i].ledgerTransactionNO);
                        $myData.push('</td><td class="GridViewLabItemStyle" id="reportType" style="display:none;">');
                        $myData.push($responseData[i].reporttype);
                        $myData.push('</td><td class="GridViewLabItemStyle" id="histonumber" style="display:none;">');
                        $myData.push($responseData[i].HistoCytoSampleDetail);
                        $myData.push('</td><td class="GridViewLabItemStyle" id="SubcategoryID" style="display:none;">');
                        $myData.push($responseData[i].subcategoryid);
                        $myData.push("</td></tr>");
                        $myData = $myData.join("");
                        $('#tblSample').append($myData);
                    }
                    tablefuncation();
                }
                $('#btnSearch').removeAttr('disabled').val('Search');
                if (searchType == "1") {
                    $saveCollData();
                    searchType = 0;
                }
            });
        }
        showuploadbox = function (ctrl) {
            var filename = "";
            if ($('#lbfileName').text() == "") {
                filename = $(ctrl).closest('tr').find('#tdBarcodeNo').next().text();
            }
            else {
                filename = $('#lbfileName').text();
            }
            $('#lbfileName').text(filename);
            window.open('../Lab/AddFileRegistration.aspx?Filename=' + filename, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
        }


        tablefuncation = function () {
            var dropdown = $(".performingDoc");
            $(".performingDoc option").remove();
            dropdown.append($("<option></option>").val("0").html("Select Doctor"));
            serverCall('SampleReceiveDepartment.aspx/getdoclist', {}, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.length > 0) {
                    for (i = 0; i < $responseData.length; i++) {
                        dropdown.append($("<option></option>").val($responseData[i].employeeid).html($responseData[i].Name));
                    }
                }
            });
            $('#tblSample tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                var reporttype = $(this).closest("tr").find("#reportType").html();
                var histonumber = $(this).closest("tr").find("#histonumber").html();
                if (id != "sampleHeader" && reporttype == "7" && histonumber != "") {
                    $(this).closest("tr").find("#ddlnoofsp").val(histonumber.split('^')[0]);
                    $(this).closest("tr").find("#ddlnoofsli").val(histonumber.split('^')[1]);
                    $(this).closest("tr").find("#ddlnoofblock").val(histonumber.split('^')[2]);
                }
            });
        }
        $getSearchData = function (type) {
            var $dataPLO = new Array();
            $dataPLO.push({
                InvestigationID: $('#ddlInvestigation').val(),
                PanelID: $('#ddlPanel').val(),
                SearchType: $('#ddlSearchType').val(),
                SearchValue: $('#txtSearchValue').val(),
                Department:jQuery('#ddlDepartment').multipleSelect("getSelects").join(), // $('#ddlDepartment').val(),
                FormDate: $('#txtFormDate').val(),
                FromTime: $('#txtFromTime').val(),
                ToDate: $('#txtToDate').val(),
                ToTime: $('#txtToTime').val(),
                SinNo: $('#txtSinNo').val(),
                Type: type,
                MachineID: $('#ddlMachine').val()
            });
            return $dataPLO;
        }

        $saveTranferData = function () {
            var data = $getTransferData();
            if (data == "") {
                toast("Error", "Please Select Sample To Transfer", "");
                return;
            }
            serverCall('SampleReceiveDepartment.aspx/saveTranferData', { data: data }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    SearchSampleCollection('S');
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        $getTransferData = function () {
            var $dataPLO = new Array();
            $('#tblSample tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "sampleHeader") {
                    if ($(this).closest("tr").find('#mmchk').is(':checked')) {
                        if ($(this).closest("tr").find('#Status').text() == "Received") {
                            $dataPLO.push({
                                Test_ID: $(this).closest("tr").attr("id"),
                                Patient_ID: $(this).closest("tr").find("#pid").text(),
                                LedgertransactionNo: $(this).closest("tr").find("#labno").text(),
                                BarCodeNo: $(this).closest("tr").find("#tdBarcodeNo").text()
                            });
                        }
                    }
                }
            });
            return $dataPLO;
        }
        $getData = function () {
            var $smType = 0;
            var $dataPLO = new Array();
            $('#tblSample tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "sampleHeader") {
                    var $sampleRec = "";
                    if ($(this).closest("tr").find('#mmchk').is(':checked') && $(this).closest("tr").find('#Status').text() == "Pending") {
                        var reporttype = $(this).closest("tr").find("#reportType").html();
                        if (reporttype == "7") {
                            if ($(this).find('#txtSpecimenType').val() == "") {
                                $smType = 10;
                            }
                           // if ($(this).find('#performingDocID').val() == "0") {
                               // $smType = 11;
                           // }
                            if ($(this).find('#ddlCheckFormline').val() == "0") {
                                $smType = 12;
                            }
                            $sampleRec = $(this).find('#ddlnoofsp').val() + "^" + $(this).find('#ddlnoofsli').val() + "^" + $(this).find('#ddlnoofblock').val();
                            var val = $(this).closest("tr").attr("id");
                            var Formalin = $(this).find('#SubcategoryID').html().trim() == "7" ? $(this).find('#ddlCheckFormline').val() : "0";


                            $dataPLO.push({
                                Test_ID: val,
                                HistoCytoSampleDetail: $sampleRec,
                                performingDocID: $(this).find('#performingDocID').val(),
                                ReportType: reporttype,
                                SpecimenType: $(this).closest("tr").find('#txtSpecimenType').val(),
                                BarcodeNo: $(this).find('#tdBarcodeNo').html().trim(),
                                SubcategoryID: $(this).find('#SubcategoryID').html().trim(),
                                RequiredAttachment: $.trim($(this).find("#hdRequiredAttachment").val()),
                                RequiredAttchmentAt: $.trim($(this).find("#hdRequiredAttachmentAt").val()),
                                Patient_ID: $.trim($(this).find("#tdPatient_ID").val()),
                                Formalin: Formalin
                            });



                            // $dataPLO.push(val + "#" + $sampleRec + "#" + $(this).find('#performingDocID').val() + "#" + reportType + "#" + $(this).find('#txtSpecimenType').val() + "#" + $(this).find('#tdBarcodeNo').html().trim() + "#" + $(this).find('#SubcategoryID').html().trim() + '#' + Formalin);
                        }
                        else {
                            var val = $(this).closest("tr").attr("id");
                            $dataPLO.push({
                                Test_ID: $(this).closest("tr").attr("id"),
                                HistoCytoSampleDetail: $sampleRec,
                                performingDocID: "0",
                                ReportType: reporttype,
                                SpecimenType: $(this).find('#oldsampletype').html().trim(),
                                BarcodeNo: $(this).find('#tdBarcodeNo').html().trim(),
                                SubcategoryID: $(this).find('#SubcategoryID').html().trim(),
                                RequiredAttachment: $.trim($(this).find("#hdRequiredAttachment").val()),
                                RequiredAttchmentAt: $.trim($(this).find("#tdRequiredAttchmentAt").val()),
                                Patient_ID: $.trim($(this).find("#tdPatient_ID").val()),
                                Formalin: "0"
                            });
                            // $dataPLO.push(val + "#" + $sampleRec + "#0#" + reportType + "#" + $(this).find('#oldsampletype').html().trim() + "#" + $(this).find('#tdBarcodeNo').html().trim() + "#" + $(this).find('#SubcategoryID').html().trim() + '#0');
                        }
                    }
                }
            });
            if ($smType == 10) {
                return "10";
            }
           // if ($smType == 11) {
               // return "11";
           // }
            if ($smType == 12) {
                return "12";
            }
            return $dataPLO;
        }
        call = function () {
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
        $saveCollData = function () {
            var $data = $getData();
            if ($data == "") {
                toast("Error", "Please Select Sample To Receive", "");
                return;
            }
            if ($data == "10") {
                toast("Error", "Please Enter Specimen Type", "");
                return;
            }
           // if ($data == "11") {
               // toast("Error", "Please Select Doctor For HistoCyto Test", "");
               // return;
           // }
            if ($data == "12") {
                toast("Error", "Please Select Formalin For HistoCyto Test", "");
                return;
            }

            //var attachment = [];
            //$('#tblSample tr').each(function () {
            //    var id = $(this).closest("tr").attr("id");
            //    if (id != "sampleHeader" && $(this).closest("tr").find("#mmchk").is(':checked')) {
            //        if ($.trim($(this).closest("tr").find("#hdRequiredAttachmentAt").val()) == "2") {
            //            if ($(this).closest("tr").find("#hdRequiredAttachment").text() != "") {
            //                for (var i = 0; i < $(this).closest("tr").find("#hdRequiredAttachment").text().split('|').length; i++) {
            //                    var reqAttachment = $(this).closest("tr").find("#hdRequiredAttachment").text().split('|')[i];
            //                    if (reqAttachment != "" && attachment.indexOf(reqAttachment) == -1) {
            //                        attachment.push(reqAttachment);
            //                    }
            //                }
            //            }
            //        }


            //    }
            //});

            //if (attachment.length > 0 && $("#tblMaualDocument").find('tbody tr').length == "0") {
            //    toast("Error", "".concat(attachment.join(","), ' ', "Required to Attach With Booked Test"), "");
            //    return false;
            //}
            //var MaualDocumentID = [];
            //if ($("#tblMaualDocument").find('tbody tr').length > 0) {
            //    $("#tblMaualDocument").find('tbody tr').each(function () {
            //        MaualDocumentID.push($(this).closest('tr').find("#tdManualDocumentName").text());
            //    });
            //}


            //var DocumentDifference = [];

            //jQuery.grep(attachment, function (el) {
            //    if (jQuery.inArray(el, MaualDocumentID) == -1) DocumentDifference.push(el);
            //});
            //if (DocumentDifference.length > 0) {
            //    toast("Error", "".concat(DocumentDifference.join(","), ' ', "Required to Attach With Booked Test"), "");
            //    return ;
            //}


            serverCall('SampleReceiveDepartment.aspx/saveSampleReceive', { data: $data }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    SearchSampleCollection('Y');
                    $('#txtSinNo').val('');
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
    </script>
    <script type="text/javascript">
        $movetoNext = function (current, nextFieldID) {
            document.getElementById(nextFieldID).focus();
        }
    </script>
        <script type="text/javascript">
            $showDocumentMaster = function (Patient_ID, LabNo) {
                var $filename = "";
                if (Patient_ID == "") {
                    toast("Info", "Please Search Patient", "");
                    return;
                }
                if ($('#spnFileName').text() == "") {
                    $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
                }
                else {
                    $filename = $('#spnFileName').text();
                }
                $('#spnFileName').text($filename);
                $('#divDocumentMaters').show();
            }
            $showManualDocumentMaster = function (Patient_ID, LabNo) {
                if (Patient_ID == "") {
                    toast("Info", "Please Search Patient", "");
                    return;
                }
                $("#tblMaualDocument tr").slice(1).remove();
                $('#spnPatient_ID').text(Patient_ID);
                $('#spnLabNo').text(LabNo);
                $bindPatientDocumnet(Patient_ID, LabNo, function () { });
                $('#divDocumentMaualMaters').show();
                if ($("#tblMaualDocument tr").length == 0) {
                    serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: LabNo, Filename: '', PatientID: Patient_ID, oldPatientSearch: 1, documentDetailID: 0, isEdit: 0 }, function (response) {
                        var maualDocument = JSON.parse(response);
                        $addPatientDocumnet(maualDocument);
                    });
                }
            }
            $addPatientDocumnet = function (maualDocument) {
                for (var i = 0; i < maualDocument.length ; i++) {
                    var $PatientDocumnetTr = [];
                    $PatientDocumnetTr.push("<tr>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' id='tdManualDocumentName'>");
                    $PatientDocumnetTr.push(maualDocument[i].DocumentName); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>"); $PatientDocumnetTr.push('<a target="_blank" href="DownloadAttachment.aspx?FileName=');
                    $PatientDocumnetTr.push($.trim(maualDocument[i].AttachedFile));
                    $PatientDocumnetTr.push('&FilePath=');
                    $PatientDocumnetTr.push($.trim(maualDocument[i].fileurl)); $PatientDocumnetTr.push('"'); $PatientDocumnetTr.push("</a>");
                    $PatientDocumnetTr.push(maualDocument[i].AttachedFile);
                    $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle'>");
                    $PatientDocumnetTr.push(maualDocument[i].UploadedBy); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                    $PatientDocumnetTr.push(maualDocument[i].dtEntry); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdMaualAttachedFile'>");
                    $PatientDocumnetTr.push(maualDocument[i].AttachedFile); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdManualFileURL'>");
                    $PatientDocumnetTr.push(maualDocument[i].fileurl); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualID">');
                    $PatientDocumnetTr.push(maualDocument[i].ID); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualDocumentID">');
                    $PatientDocumnetTr.push(maualDocument[i].DocumentID); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle"  style="text-align:center" ><img src="../../App_Images/view.GIF" alt=""  style="cursor:pointer" onclick="$manualViewDocument(this)" /> </td>');
                    $PatientDocumnetTr.push('</tr>');
                    $PatientDocumnetTr = $PatientDocumnetTr.join("");
                    $("#tblMaualDocument tbody").prepend($PatientDocumnetTr);
                }
                $('#spnDocumentMaualCounts').text($("#tblMaualDocument tr").length - 1);
            };
            $divDocumentMaualCloseModel = function () {
                $('#divDocumentMaualMaters').closeModel();
            }
            $divDocumentMatersCloseModel = function () {
                $getUpdatedPatientDocuments(function (responseData) {
                    $('#spnDocumentCounts').text(responseData.length);
                    $('#divDocumentMaters').closeModel();
                });
            }
            $getUpdatedPatientDocuments = function (callback) {
                var $patientDocuments = [];
                $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                    if ($(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                        var $document = {
                            documentId: this.innerHTML.trim(),
                            name: $(this.parentNode).find('#btnDocumentName').val(),
                            data: $(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                        }
                        $patientDocuments.push($document);
                    }
                });
                callback($patientDocuments);
            }
            $bindDocumentMasters = function () {
                serverCall('../Common/Services/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: $('#spnPatient_ID').text() }, function (response) {
                    $responseData = JSON.parse(response);
                    documentMaster = $responseData.patientDocumentMasters;
                    var $template = $('#template_DocumentMaster').parseTemplate(documentMaster);
                    $('#documentMasterDiv').html($template);
                });
            }
            $manualViewDocument = function (rowID) {
                serverCall('Lab_PrescriptionOPD.aspx/manualEncryptDocument', { fileName: $(rowID).closest('tr').find("#tdMaualAttachedFile").text(), filePath: $(rowID).closest('tr').find("#tdManualFileURL").text() }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        PostQueryString($responseData, '../Lab/ViewDocument.aspx');
                    }
                });
            }
            $bindPatientDocumnet = function (PatientID, LabNo) {
                serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: LabNo, Filename: '', PatientID: PatientID, oldPatientSearch: 1, documentDetailID: 0, isEdit: 1 }, function (response) {
                    var maualDocument = JSON.parse(response);
                    if (!String.isNullOrEmpty(maualDocument)) {
                        $addPatientDocumnet(maualDocument);
                    }
                });
            }
    </script>
         <script id="template_DocumentMaster" type="text/html">
		<table cellspacing="0" cellpadding="4" rules="all" border="1"    id="tblDocumentMaster" border="1" style="background-color:White;border-color:Transparent;border-width:1px;border-style:None;width:100%;border-collapse:collapse;">       
				<tr>
					<td style="border:solid 1px transparent"><input type="button"    value="Document Name"  id="Button1" title="" class="btn" style="font-size: 20px;color:white;background-color:#2C5A8B; width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"></td>					
				</tr>				   
			<#
			 var dataLength=documentMaster.length;        
			 var objRow;    			
				for(var j=0;j<dataLength;j++)
				{
					objRow = documentMaster[j];
				#>          
				<tr id="tr_<#=(j+1)#>">
					<td style="border:solid 1px transparent"><button type="button" value="<#=objRow.Name#>"  id="btnDocumentName" title="<#=objRow.Name#>" class="btnDocumentName" style="width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" onclick="documentNameClick(this, this.parentNode.parentNode)">
					   <span style="float: right;font-size: 10px;"  class="badge badge-avilable clSpnDocumentName" ><#=objRow.ExitsCount#></span>  <#=objRow.Name#>
						</button>
						</td>
					<td id="tdDocumentID" class="<#=objRow.ID#>" style="display:none"><#=objRow.ID#>
					</td>
					<td id="tdBase64Document" class="<#=objRow.ID#>" style="display:none"></td>
				</tr>
			<#}#>            
		 </table>    
	</script>  
     <script type="text/javascript">
         function openmytrf(testId) {
             window.open("HistoTRF.aspx?test_id=" + testId);
            
         }
       
         $openReject = function (testid) {
             $encryptQueryStringData(testid, function ($returnData) {
                 $fancyBoxOpen('SampleReject.aspx?test_id=' + $returnData + '');
             });
         }
         pageLoad = function (sender, args) {
             if (!args.get_isPartialLoad()) {
                 $addHandler(document, "keydown", onKeyDown);
             }
         }
         onKeyDown = function (e) {
             if (e && e.keyCode == Sys.UI.Key.esc) {
                 if (jQuery('#divDocumentMaualMaters').is(':visible')) {
                     $divDocumentMaualCloseModel();
                 }
                 if (jQuery('#divDocumentMaters').is(':visible')) {
                     $divDocumentMatersCloseModel();
                 }

             }

         }
          </script>
</asp:Content>

