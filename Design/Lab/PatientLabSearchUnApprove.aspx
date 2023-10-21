<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientLabSearchUnApprove.aspx.cs" Inherits="Design_Lab_PatientLabSearchUnApprove" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <%: Scripts.Render("~/bundles/confirmMinJS") %>
        <%: Scripts.Render("~/bundles/PostReportScript") %>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <style type="text/css">
        div#divLabDetail {
            height: 200px;
            overflow: scroll;
        }
    </style>

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align:center">
                    <b>Amended Patient Report</b>
                </div>
            </div>


            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>

            <div class="row">
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlSearchType" runat="server">
                        <asp:ListItem Value="plo.BarcodeNo" Selected="True">SIN No.</asp:ListItem>
                        <asp:ListItem Value="lt.Patient_ID">UHID No.</asp:ListItem>
                        <asp:ListItem Value="plo.LedgerTransactionNo">Visit No.</asp:ListItem>
                        <asp:ListItem Value="pm.mobile">Mobile No</asp:ListItem>
                        <asp:ListItem Value="pm.pname">Patient Name</asp:ListItem>


                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtSearchValue" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <asp:CheckBox ID="chkCentre" runat="server" onClick="$bindCentre();" Text="Centre :" Style="font-weight: 700" />
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" runat="server">
                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <asp:CheckBox ID="chkPanel" runat="server" onClick="$bindPanel();" Text="Rate Type :" Style="font-weight: 700" />
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select">
                    </asp:DropDownList>

                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlDepartment" runat="server">
                    </asp:DropDownList>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlSearchByDate" runat="server">
                        <asp:ListItem Value="plo.date" Selected="True">Registration Date</asp:ListItem>
                        <asp:ListItem Value="plo.SampleReceiveDate">Sample Receiving Date</asp:ListItem>
                        <asp:ListItem Value="plo.ApprovedDate">Approved Date</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFormDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFormDate" />


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
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate" />



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
                <div class="col-md-1">
                    </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkTest" runat="server" onClick="$bindTest();" Text="Test :" Style="font-weight: 700" />
                </div>

                <div class="col-md-4">
                    <asp:DropDownList ID="ddlInvestigation" class="ddlInvestigation  chosen-select" runat="server">
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlUser" runat="server">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <asp:TextBox ID="txtSinNo" placeholder="Scan SIN No Here" runat="server"></asp:TextBox>

                </div>

                <div class="col-md-2">
                    <asp:CheckBox ID="chkDoctor" runat="server" Checked="false" Text="Doctor : " onClick="$bindDoctor();" Style="font-weight: 700" />
                </div>

                <div class="col-md-4">
                    <asp:DropDownList ID="ddlReferDoc" runat="server" class="ddlReferDoc chosen-select"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <input id="ChkIsUrgent" type="checkbox" />
                    <strong>Urgent</strong>
                </div>
                <div class="col-md-3">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="$patientLabSearch('0', '')" />
                </div>


                <div class="col-md-2">
                    <input type="checkbox" id="chheader" /><strong>Header</strong>
                </div>
                <div class="col-md-2">
                   
                </div>

                <div class="col-md-3">

                    <label class="pull-right">
                        Dispatch Type
							   <b class="pull-right">:</b></label>
                </div>

                <div class="col-md-2">
                    <asp:DropDownList ID="ddlDispacthMode" runat="server">
                        <asp:ListItem Value="BOTH" Text="BOTH"></asp:ListItem>
                        <asp:ListItem Value="PRINT" Text="PRINT"></asp:ListItem>
                        <asp:ListItem Value="MAIL" Text="MAIL"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        


            <div class="row">
                    <div class="col-md-1 square badge-New" style="height: 20px;width:2%; float: left; " onclick="$patientLabSearch('1','');">
                    </div>
                    <div class="col-md-1">
                        New
                    </div>                  
                        <div class="col-md-1 square badge-SampleCollect" style="height: 20px;width:2%; float: left; " onclick="$patientLabSearch('2','');">
                        </div>
                        <div class="col-md-3">
                            Sample Collected

                        </div>
                    
                    <div class="col-md-1 square badge-SampleReject" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('14','');">
                    </div>

                    <div class="col-md-3">
                        Sample Rejected
                    </div>

                    <div class="col-md-1 square badge-DepartmentReceive" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('3','');">
                    </div>


                    <div class="col-md-3">
                        Department Receive
                    </div>

                    <div class="col-md-1 square badge-Tested" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('7','');">
                    </div>

                    <div class="col-md-1">
                        Tested
                    </div>

                    <div class="col-md-1 square badge-Approved" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('8','');">
                    </div>

                    <div class="col-md-2">
                        Approved
                    </div>

                    <div class="col-md-1 square badge-Printed" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('9','');">
                    </div>

                    <div class="col-md-1">
                        Printed
                    </div>

                    <div class="col-md-1 square badge-Hold" style=" height: 20px;width:2%;float: left; " onclick="$patientLabSearch('10','');">
                    </div>

                    <div class="col-md-1">
                        Hold
                    </div>
                    <div class="col-md-1 square badge-Dispatched" style=" height: 20px;width:2%; float: left; " onclick="$patientLabSearch('13','');">
                    </div>

                    <div class="col-md-1">
                        Dispatched
                    </div>
              



            </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Details
                &nbsp;&nbsp;
                  <span style="font-weight: bold; color: black;">Total Record:&nbsp;</span><span id="spnTestCount" style="font-weight: bold; color: black;"></span>
                </div>
                <div id="PagerDiv1" style="display: none; background-color: white; width: 99%; padding-left: 7px;">
                </div>
                 <div class="row" style=" height: 360px; overflow-y: auto; overflow-x: hidden;">
                      <div class="col-md-24">
                    <table style="width: 99%; " border-collapse: collapse" id="tb_ItemList" class="GridViewStyle">
                         <thead>
                        <tr id="header">
                            <td class="GridViewHeaderStyle">S.No.</td>
                            <td class="GridViewHeaderStyle">Entry DateTime</td>
                            <td class="GridViewHeaderStyle">Lab No.</td>
                            <td class="GridViewHeaderStyle">SIN No.</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Age/Sex</td>
                            <td class="GridViewHeaderStyle">Centre</td>
                            <td class="GridViewHeaderStyle">Rate Type</td>
                            <td class="GridViewHeaderStyle">Doctor</td>
                            <td class="GridViewHeaderStyle">Department</td>
                            <td class="GridViewHeaderStyle">Investigation</td>
                           <%-- <td class="GridViewHeaderStyle">
                                <input type="checkbox" id="hd" onclick="call()" class="mmc" /></td>
                            <td class="GridViewHeaderStyle">View</td>--%>
                            <td class="GridViewHeaderStyle">Print Report</td>
                           <%-- <td class="GridViewHeaderStyle">Prev.</td>
                            
                            <td class="GridViewHeaderStyle">Dispatch</td>
                            <td class="GridViewHeaderStyle">Remarks</td>--%>
                        </tr>
                            </thead>
							<tbody></tbody>
                    </table>

                    <div id="PagerDiv" style="display: none; background-color: white;">
                    </div>
                </div>
                     </div>
            </div>
            <asp:Button ID="btnHideLab" runat="server" Style="display: none" />
            <cc1:ModalPopupExtender ID="mpLabInfo" runat="server" CancelControlID="btnCancelLabInfo"
                DropShadow="true" TargetControlID="btnHideLab" BackgroundCssClass="filterPupupBackground"
                PopupControlID="pnlLabDisplay" OnCancelScript="closeLabData()" BehaviorID="mpLabInfo">
            </cc1:ModalPopupExtender>


            <asp:Panel ID="pnlLabDisplay" runat="server" Style="display: none; width: 860px; height: 264px;" CssClass="pnlVendorItemsFilter"
                ScrollBars="Both">
                <div class="Purchaseheader" id="Div1" runat="server">
                    <table style="width: 100%; border-collapse: collapse" border="0">
                        <tr>
                            <td>
                                <b>Test Detail</b>
                            </td>
                            <td style="text-align: right">
                                <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../App_Images/Delete.gif" style="cursor: pointer" onclick="closeLabData()" />
                                    to close</span></em>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="divLabDetail"></div>
                <table style="width: 100%; border-collapse: collapse" border="0">
                    <tr>
                        <td style="text-align: center">

                            <asp:Button ID="btnCancelLabInfo" runat="server" CssClass="ItDoseButton" Text="Close"
                                ToolTip="Click To Cancel" />
                        </td>

                    </tr>
                </table>
            </asp:Panel>       

         <div id="divPrePrintedBarcode" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 34%;max-width:36%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Amended Report Detail</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel"  onclick="closeReport()"  aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
			</div>
            <div class="modal-body">			
                     <div style="height:220px;overflow-y:auto;"  class="row">
					<div id="divPrePrintedBarcodeData" style="" class="col-md-24">
                      <table id="apptable" style="width:100%"></table>
                        </div>					
				</div>               
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="closeReport()">Close</button>
			</div>                  
        </div>
 </div>
         </div> 
        </div>
    <script type="text/javascript">
        function $bindCentre() {
            var $ddlCentre = $("#ddlCentreAccess");
            if ($('#chkCentre').is(':checked')) {
                $("#ddlCentreAccess option").remove();
                $ddlCentre.append($("<option></option>").val("ALL").html("ALL"));
                serverCall('MachineResultEntry.aspx/bindAccessCentre', {}, function (response) {
                    $ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
                    $ddlCentre.trigger('chosen:updated');
                });
            }
            else {
                $("#ddlCentreAccess option").remove();
                $ddlCentre.append($("<option></option>").val("ALL").html("ALL"));
                $ddlCentre.trigger('chosen:updated');
            }
        }
        function $bindPanel() {
            var $ddlPanel = $("#ddlPanel");
            if ($('#chkPanel').is(':checked')) {
                $("#ddlPanel option").remove();
                $ddlPanel.append($("<option></option>").val("").html(""));
                serverCall('OPDRePrint.aspx/GetPanelMaster', {}, function (response) {
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'panel_id', textField: 'company_name', isSearchAble: true });
                    $ddlPanel.trigger('chosen:updated');
                });
            }
            else {
                $("#ddlPanel option").remove();
                $ddlPanel.trigger('chosen:updated');
            }
        };

        function $bindTest() {
            var $ddlInv = $("#ddlInvestigation");
            if ($('#chkTest').is(':checked')) {
                $("#ddlInvestigation option").remove();
                $ddlInv.append($("<option></option>").val("").html(""));
                serverCall('MachineResultEntry.aspx/GetTestMaster', {}, function (response) {
                    $ddlInv.bindDropDown({ data: JSON.parse(response), valueField: 'testid', textField: 'testname', isSearchAble: true });
                    $ddlInv.trigger('chosen:updated');
                });
            }
            else {
                $("#ddlInvestigation option").remove();
                $ddlInv.trigger('chosen:updated');
            }
        };

        function $bindDoctor() {
            var $ddlDoctor = $("#ddlReferDoc");
            if (($('#chkDoctor').prop('checked') == true)) {
                $("#ddlReferDoc option").remove();
                $ddlDoctor.append($("<option></option>").val("").html(""));
                serverCall('OPDRePrint.aspx/GetDoctorMaster', {}, function (response) {
                    $ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'doctor_id', textField: 'name', isSearchAble: true });
                    $ddlDoctor.trigger('chosen:updated');
                });
            }
            else {
                $('#ddlReferDoc option:nth-child(1)').attr('selected', 'selected')
                $("#ddlReferDoc option").remove();
                $ddlDoctor.trigger('chosen:updated');
            }
        };
    </script>

    <script type="text/javascript">
        var RoleID = '<%#UserInfo.RoleID.ToString()%>';
        
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
            $(document).keydown(
                 function (e) {
                     var key = (e.keyCode ? e.keyCode : e.charCode);
                     if (key == 13) {
                         e.preventDefault();
                     }

                 });

            $("#txtSinNo").keydown(
           function (e) {
               var key = (e.keyCode ? e.keyCode : e.charCode);
               if (key == 13) {
                   e.preventDefault();
                   if ($('#txtSinNo').val() != "")
                       $patientLabSearch('0','');
               }

           });
        });



        function $getSearchData() {
            var $dataLab = new Array();
            $dataLab.push({
                SearchType: jQuery('#ddlSearchType').val(),
                SearchValue: jQuery('#txtSearchValue').val(),
                Centre: jQuery('#ddlCentreAccess').val(),
                Panel: jQuery('#ddlPanel').val(),
                Department: jQuery('#ddlDepartment').val(),
                SearchByDate: jQuery('#ddlSearchByDate').val(),
                FromDate: jQuery('#txtFormDate').val(),
                FromTime: jQuery('#txtFromTime').val(),
                ToDate: jQuery('#txtToDate').val(),
                ToTime: jQuery('#txtToTime').val(),
                Investigation: jQuery('#ddlInvestigation').val(),
                SinNo: jQuery('#txtSinNo').val(),
                ReferDoc: jQuery('#ddlReferDoc').val(),
                IsUrgent: $("#ChkIsUrgent").is(':checked') ? 1 : 0,
                UserID: jQuery('#ddlUser').val(),
                DispacthMode: jQuery('#ddlDispacthMode').val(),

            });
            return $dataLab;
        }
        function checkPaitent(ID) {
            var cls = $(ID).attr("data");
            if ($(ID).prop('checked') == true) {
                $("." + cls).prop("checked", true)
            }
        };
        var $testcount = 0;
        var stype1 = '0';
        var TestData = "";
        var _$PageSize = 100;
        var _$PageNo = 0;
      
        function $patientLabSearch(stype, pageno) {
            stype1 = stype;
            var $searchData = $getSearchData();
            $('#tb_ItemList tr').slice(1).remove();       
            if (pageno == "")
                _$PageNo = 0;
            else
                _$PageNo = pageno;
            serverCall('PatientLabSearchUnApprove.aspx/SearchPatient', { searchData: $searchData, stype: stype, PageNo: _$PageNo, PageSize: _$PageSize }, function (response) {
                $responseData = $.parseJSON(response);
                if ($responseData.status) {
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        toast("Info", "No Data Found", "");
                        $('#spnTestCount').html('0');
                        $('#PagerDiv1').html('');
                        $('#PagerDiv1').hide();
                        return;
                    }
                    else {
                       
                        $testcount = parseInt($responseData[0].TotalRecord);
                        $('#spnTestCount').html($testcount);
                        _$PageNo = $responseData[0].TotalRecord / _$PageSize;
                        var $barcodeNo = "";
                        var dataLength = $responseData.length;
                        for (var i = 0; i < $responseData.length; i++) {
                            var $myData = [];
                            $myData.push("<tr id='");
                            $myData.push($responseData[i].Test_ID); $myData.push("'");
                            $myData.push('style="background-color:');
                            $myData.push($responseData[i].rowColor); $myData.push('">');
                            if ($responseData[i].LogisticStatus != "") {
                                $myData.push("<td class='GridViewLabItemStyle' >");
                                $myData.push(parseInt(i + 1));
                                if ($responseData[i].IsUrgent == "1") {
                                    $myData.push("<img src='../../App_Images/Urgent.gif'>");
                                }
                                $myData.push("<img src='../../App_Images/truck.jpg' style='width:24px; height:24px' title='");
                                $myData.push($responseData[i].LogisticStatus); $myData.push("'/>");
                                $myData.push("</td>");
                            }
                            else {
                                $myData.push("<td class='GridViewLabItemStyle' >");
                                $myData.push(parseInt(i + 1));

                                if ($responseData[i].IsUrgent == "1") {
                                    $myData.push("<img src='../../App_Images/Urgent.gif'>");
                                }
                                $myData.push("</td>");
                            }
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].EntryDate); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle"><b>'); $myData.push($responseData[i].LedgerTransactionNo); $myData.push('</b></td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="td_BarcodeNo"><b>'); $myData.push($responseData[i].BarcodeNo); $myData.push('</b></td>');
                            $myData.push('<td class="GridViewLabItemStyle"><b>'); $myData.push($responseData[i].PName); $myData.push('</b></td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].pinfo); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].centre); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].PanelName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].DoctorName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].Dept); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].ItemName); $myData.push('</td>');
                           // $myData.push('<td class="GridViewLabItemStyle">');
                            //if ($responseData[i].Approved == "1") {
                            //    $myData.push('<input type="checkbox" id="mmchk" onchange="checkPaitent(this)" class="');
                            //    $myData.push($responseData[i].LedgerTransactionNo);
                            //    $myData.push('"/>');
                            //}
                            //$myData.push('</td>');
                            //$myData.push('<td class="GridViewLabItemStyle">');
                            //if ($barcodeNo != $responseData[i].BarcodeNo) {
                            //    $myData.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewDetail(this)"/>');
                            //}
                            //$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">');
                          //  if ($responseData[i].Approved == "1") {
                                $myData.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="showunapprovedreport(');
                                $myData.push($responseData[i].Test_ID); $myData.push(')"/>');
                           // }
                            $myData.push('</td>');
                            //$myData.push('<td class="GridViewLabItemStyle">');
                            //if ($responseData[i].Approved == "1") {
                            //    $myData.push('<img src="../../App_Images/Refresh.gif" style="cursor:pointer;" onclick="PrintReport(1)"/>');
                            //}
                            //$myData.push('</td>');
                            
                            //$myData.push('<td class="GridViewLabItemStyle" style="text-align:center;">');
                            //if ($responseData[i].Approved == "1") {
                            //    $myData.push('<img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="$dispatch(this);" />');
                            //    $myData.push('<input type="hidden" value="');
                            //    $myData.push($responseData[i].LedgerTransactionNo.trim());
                            //    $myData.push('"/>');
                            //}
                            //$myData.push('</td>');
                            //$myData.push('<td style="display:none;" id="tdBarCodeGroup">');
                            //$myData.push($responseData[i].barcode_group);
                            //$myData.push('</td>');
                            //$myData.push('<td style="text-align:center;" class="GridViewLabItemStyle">');
                            //if ($responseData[i].IsSampleCollected == "R" && $responseData[i].UpdateRemarks.length > 0) {
                            //    $myData.push('  <img src="../../App_Images/Post.gif" title="');
                            //    $myData.push($responseData[i].UpdateRemarks);
                            //    $myData.push('"/>');
                            //}

                            //$myData.push('<img src="../../App_Images/');
                            //if ($responseData[i].Remarks == "0") {
                            //    $myData.push('ButtonAdd.png');
                            //}
                            //else {
                            //    $myData.push('RemarksAvailable.jpg');
                            //}
                            //$myData.push('" style="border-style: none;cursor:pointer;" onclick="$callRemarksPage(\'');
                            //$myData.push($responseData[i].Test_ID); $myData.push("\',"); $myData.push("\'");
                            //$myData.push($responseData[i].ItemName); $myData.push("\',"); $myData.push("\'");
                            //$myData.push($responseData[i].LedgerTransactionNo); $myData.push("\',"); $myData.push("\'");
                            //$myData.push($responseData[i].ID); $myData.push("\');"); $myData.push('"></td>');
                            $myData.push("</tr>");
                            $myData = $myData.join("");
                            $('#tb_ItemList tbody').append($myData);
                            $barcodeNo = $responseData[i].BarcodeNo;
                            
                        }
                       
                        var $myval = [];
                        if (_$PageNo > 1 && _$PageNo < 50) {
                            for (var j = 0; j < _$PageNo; j++) {
                                var me = parseInt(j) + 1;
                                $myval.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\''); $myval.push(j); $myval.push('\');"  >'); $myval.push(me); $myval.push('</a>');
                            }
                        }
                        else if (_$PageNo > 50) {
                            for (var j = 0; j < 50; j++) {
                                var me = parseInt(j) + 1;
                                $myval.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\''); $myval.push(j); $myval.push('\');"  >'); $myval.push(me); $myval.push('</a>');
                            }
                            $myval.push('&nbsp;&nbsp;<select onchange="shownextrecord()" id="ddlPage">');
                            $myval.push('<option value="Select">Select Page</option>');
                            for (var j = 50; j < _$PageNo; j++) {
                                var me = parseInt(j) + 1;
                                $myval.push('<option value="'); $myval.push(j); myval.push('">'); $myval.push(me); $myval.push('</option>');
                            }
                            $myval.push("</select>");
                        }
                        $myval = $myval.join("");
                        $('#PagerDiv1').append($myval);
                        $('#PagerDiv1').show();


                    }
                    jQuery("#tb_ItemList").tableHeadFixer({
                    });
                }
                else {
                    toast("Error", $responseData.response, "");
                    $('#spnTestCount').html('0');
                    $('#PagerDiv1').html('');
                    $('#PagerDiv1').hide();
                    return;
                }
                
            });
        };
        function openreport(testid) {
            testid = testid + ",";
            window.open("../opd/labreportmicro.aspx?testid=" + testid);
        }
        function $callRemarksPage(Test_ID, TestName, LabNo) {
            serverCall('PatientLabSearch.aspx/PostRemarksData', { TestID: Test_ID, TestName: TestName, VisitNo: LabNo }, function (response) {
                $responseData = JSON.parse(response);
                window.open("../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo + "", null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            });
        }
        function show(pageno) {
            $patientLabSearch(stype1, pageno);
        }
        function shownextrecord() {
            var mm = $('#ddlPage option:selected').val();
            if (mm != "Select") {
                show(mm);
            }
        }
        function call() {
            if ($('#hd').prop('checked') == true) {
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        $(this).closest("tr").find('#mmchk').prop('checked', true);
                    }
                });
            }
            else {
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', false);
                    }
                });
            }
        }
        function PrintReport(IsPrev) {
            var testid = "";
            var id = "";
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                        testid += id + ",";
                        if (IsPrev != "1") {
                            $(this).closest("tr").css('background-color', '#00FFFF');
                        }
                    }
                }
            });
            if (testid == "") {
                toast("Info", "Please Select Test To Print", "");
                return;
            }
            if ($('#chheader').prop('checked') == true) {
                window.open("labreportnew.aspx?IsPrev=" + IsPrev + "&PHead=1&testid=" + testid);
            }
            else {
                window.open("labreportnew.aspx?IsPrev=" + IsPrev + "&testid=" + testid);
            }
            $('.mmc').prop('checked', false);
        }
        function viewDetail(rowID) {
            var BarcodeNo = $(rowID).closest("tr").find('#td_BarcodeNo').text();
            serverCall('PatientLabSearch.aspx/PostData', { ID: BarcodeNo }, function (response) {
                $responseData = JSON.parse(response);

                window.open("SampleTracking.aspx?barcodeno=" + $responseData.LabID, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            });
        }
        function closeLabData() {
            $find('mpLabInfo').hide();
        }
        function closeReport() {
            //  $find('mdapp').hide();
            jQuery('#divPrePrintedBarcode').hideModel();
        }
    </script>
    <script id="tb_LabSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:820px;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" >S.No.               
			</th>
            <th class="GridViewHeaderStyle" scope="col" >Entry Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Entry By</th>
			<th class="GridViewHeaderStyle" scope="col" >Status</th>                                            
		</tr>
        <#
        var dataLength=LabData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = LabData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#> </td>                                                           
                    <td class="GridViewLabItemStyle" id="tdEntryDate" "><#=objRow.EntryDate#></td>
                    <td class="GridViewLabItemStyle" id="tdEntryBy" "><#=objRow.EntryBy#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus" ><#=objRow.Status#></td>                                         
                    </tr>
        <#}
        #>        
     </table>
    </script>
    <script type="text/javascript">
        function $dispatch(Ctrl) {
            var LabNo = $(Ctrl).next().val().trim();

            serverCall('PatientLabSearch.aspx/PostData', { ID: LabNo }, function (response) {
                $responseData = JSON.parse(response);
                PostQueryString($responseData, 'PrintReportFrontOffice.aspx');
            });           
        }
        function showunapprovedreport(test_id) {           
            $('#apptable').empty();
            serverCall('PatientLabSearchUnApprove.aspx/GetUnapprovedreportlist', { TestID: test_id }, function (response) {             
                var $responseData = $.parseJSON(response);
                debugger;
                if ($responseData != null) {
                    var uniid = "";
                    var myno = "";
                    var $reporttype = "";
                    $('#apptable').append('<tr id="Header"><td class="GridViewHeaderStyle" width="40px" scope="col">S.No.</td><td class="GridViewHeaderStyle" scope="col" width="80px">Report</td><td class="GridViewHeaderStyle" scope="col">Date</td></tr>');
                    for (var a = 0; a <= $responseData.length - 1; a++) {                       
                        myno = a + 1;
                        $reporttype = $responseData[a].ReportType;
                        $('#apptable').append('<tr><td>' + myno + '</td><td><a href="javascript:void(0);"   onclick="Searchreport(\'' + $responseData[a].Unique_Hash + '\',\'' + test_id + '\',\'' + $reporttype + '\')">Print</a></td><td>' + $responseData[a].Unique_Hash + '</td></tr>');

                    }
                    myno = Number(myno) + 1;
                    $('#apptable').append('<tr><td>' + myno + '</td><td><a href="javascript:void(0);" onclick="Searchreport(\'' + uniid + '\',\'' + test_id + '\',\'' + $reporttype + '\')" >Print</a></td><td>Current Report</td></tr>');
                    jQuery('#divPrePrintedBarcode').showModel();
                }
            });          
        }
        function Searchreport(uniid, test_id, ReportType) {          
            var $head = 0;
            if ($('#chheader').prop('checked') == true)
                $head = 1;
            if (ReportType == 7) {
                if (uniid == "") {
                    window.open('../../Design/Lab/labreportnewhisto.aspx?testid=' + test_id + ',&Phead=' + $head);
                }
                else {
                    window.open('../../Design/Lab/labreporthisto_notapprove.aspx?testid=' + test_id + ',&Phead=' + $head + '&unid=' + uniid);
                }
            }
            else if (ReportType == 2) {
                if (uniid == "") {
                    window.open('../../Design/Lab/labreportmicro.aspx?testid=' + test_id + ',&Phead=' + $head);
                }
                else {
                    window.open('../../Design/Lab/labreportmicroUnapprove.aspx?testid=' + test_id + ',&Phead=' + $head + '&unid=' + uniid);
                }
            }
            else {
                if (uniid == "") {
                    window.open('../../Design/Lab/labreportnew.aspx?testid=' + test_id + ',&Phead=' + $head);
                }
                else {
                    window.open('../../Design/Lab/labreportnotapprove.aspx?testid=' + test_id + ',&Phead=' + $head + '&unid=' + uniid);
                }
            }
        }
    </script>
</asp:Content>
