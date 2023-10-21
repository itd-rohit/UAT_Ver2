<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="OPDRePrint.aspx.cs" Inherits="Design_Lab_OPDRePrint" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="../../App_Style/multiple-select.css" />
        <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/PostReportScript") %>
     <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="Receipt Reprint" Font-Size="16px" Font-Bold="true"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlSearchType" runat="server" onchange="movetoNext(this, 'txtLedgerTransactionNo')" ClientIDMode="Static">
                        <asp:ListItem Value="lt.LedgertransactionNo" Selected="True">Visit No.</asp:ListItem>
                        <asp:ListItem Value="plo.BarcodeNo">SIN No.</asp:ListItem>
                        <asp:ListItem Value="PM.PName">Patient Name</asp:ListItem>
                        <asp:ListItem Value="pm.Mobile">Mobile</asp:ListItem>
                        <asp:ListItem Value="lt.BillNo">BillNo</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtLedgerTransactionNo" runat="server" ClientIDMode="Static" MaxLength="30"></asp:TextBox>
                </div>
                <div class="col-md-2">
                     <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
                    </div>
                <div class="col-md-6">

                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess chosen-select chosen-container" runat="server" >
                    </asp:DropDownList>
                </div>                
                <div class="col-md-2">
                     <label class="pull-left">User   </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                  <asp:DropDownList ID="ddlUser" class="ddlUser  chosen-select chosen-container" runat="server" >
                    </asp:DropDownList>
                </div>
                 <div class="col-md-2">
                     &nbsp;
                      </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">From   </label>
			   <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                    <asp:TextBox ID="txtFormDate" runat="server" Width="109px"></asp:TextBox>
                    <asp:TextBox ID="txtFromTime" runat="server" Width="79px"></asp:TextBox>
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
                      <label class="pull-left">To   </label>
			   <b class="pull-right">:</b>
                     </div>
                    <div class="col-md-6">
                    <asp:TextBox ID="txtToDate" runat="server" Width="122px"></asp:TextBox>
                    <asp:TextBox ID="txtToTime" runat="server" Width="92px"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>  
                 <div class="col-md-2">
                        <label class="pull-left">Panel</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select"></asp:DropDownList>
                    </div>           
                <div class="col-md-2">
                   &nbsp;
                </div>
                <div class="col-md-3">
                    &nbsp;
                </div>
                <div class="col-md-3">
                    </div>                
            </div>
            <div class="row">
                
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">
                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;height:25px;float:left;margin-right:5px;" class="square badge-fullPaid"  onclick="searchdata('1','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Full Paid</b></div>                       
                        </div>               
                </div>
              
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">

                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;height:25px;float:left;margin-right:5px;" class="square badge-PartialPaid"  onclick="searchdata('2','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Partial Paid</b></div>
                        
                        </div>
               
                </div>
                 <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">

                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;height:25px;float:left;margin-right:5px;" class="square badge-FullyUnpaid"  onclick="searchdata('3','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Fully UnPaid</b></div>                       
                        </div>             
                </div>
                 <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">

                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;height:25px;float:left;margin-right:5px;" class="square badge-Credit"  onclick="searchdata('4','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Credit</b></div>                       
                        </div>              
                </div>                           
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">

                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;background-color: #FFFF00;height:25px;float:left;margin-right:5px;"   onclick="searchdata('5','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Edited</b></div>                       
                        </div> 
                     </div>   
                <div class="col-md-4">
                    <div class="row">
                        <div class="col-md-6">
                            </div>
                         <div class="col-md-4">
                               <button type="button" style="width:25px;background-color: #6699ff;height:25px;float:left;margin-right:5px;"   onclick="searchdata('6','');"></button>
                            </div>
                           <div class="col-md-14" style="text-align: left;"><b>Full Refund</b></div>                       
                        </div>               
                </div>                           
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata('0', '')" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="Purchaseheader">
                        Patient Detail&nbsp;&nbsp;&nbsp; 
                   <span style="font-weight: bold; color: black;">Total Patient:&nbsp;</span><span id="spnTestCount" style="font-weight: bold; color: black;"></span>
                        <span style="font-weight: bold; color: black;">Total Net Amt.:&nbsp;</span><span id="spnAmtCount" style="font-weight: bold; color: black;"></span>
                    </div>
                </div>
                <div class="row">
                <div class="col-md-24">
                <div id="PagerDiv1" style="display:none;background-color:white;width:99%;padding-left:7px;">

              </div>
                     </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%; border-collapse: collapse" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle" >S.No.</td>
                            <td class="GridViewHeaderStyle" >Entry DateTime</td>
                            <td class="GridViewHeaderStyle" >Lab No.</td>
                            <td class="GridViewHeaderStyle" >SIN No.</td>
                            <td class="GridViewHeaderStyle" >Patient Name</td>
                            <td class="GridViewHeaderStyle" >Age/Sex</td>
                            <td class="GridViewHeaderStyle" >Mobile No.</td>
                            <td class="GridViewHeaderStyle" >Gross Amt.</td>
                            <td class="GridViewHeaderStyle" >Disc. Amt.</td>
                            <td class="GridViewHeaderStyle" >Net Amt.</td>
                            <td class="GridViewHeaderStyle" >Paid Amt.</td>
                            <td class="GridViewHeaderStyle" >Due Amt.</td>
                            <td class="GridViewHeaderStyle" >Centre</td>
                            <td class="GridViewHeaderStyle" >Client</td>
                            <td class="GridViewHeaderStyle" >Doctor</td>
                            <td class="GridViewHeaderStyle" >User</td>
                            <%--<td class="GridViewHeaderStyle" >Concern Form</td>--%>
                            <td class="GridViewHeaderStyle" >Edit Info</td>
                            <td class="GridViewHeaderStyle" >Receipt Edit</td>
                            <td class="GridViewHeaderStyle" >Settle ment</td>
                            <%--<td class="GridViewHeaderStyle" >Change Panel</td>--%>
                            <td class="GridViewHeaderStyle" >Cash Receipt</td>
                            <td class="GridViewHeaderStyle" >Money Receipt</td>
                            <td class="GridViewHeaderStyle" >Refund Slip</td>
							<td class="GridViewHeaderStyle" >Fully Paid</td>
                            <td class="GridViewHeaderStyle" >Dept.Slip</td>
                            <td class="GridViewHeaderStyle" >TRF</td>
                            <td class="GridViewHeaderStyle" >Consent Form</td>
                            <td class="GridViewHeaderStyle" >View</td>
                            <td class="GridViewHeaderStyle">ClinicalHistory</td>
                            <td class="GridViewHeaderStyle" >BarCode Reprint</td>
                            <td class="GridViewHeaderStyle" >DOC</td>
                            <td class="GridViewHeaderStyle" >Send Email</td>
                            <td class="GridViewHeaderStyle" >Send SMS</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        
    </div>
    <div id="toolTipLayer" style="position: absolute; visibility: hidden; left: 0; right: 0"></div>
    <script type="text/javascript">
        $(function () {
            $("#txtFormDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            });
            $("#txtToDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            });
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
            $("#txtLedgerTransactionNo").keydown(
                    function (e) {
                        var key = (e.keyCode ? e.keyCode : e.charCode);
                        if (key == 13) {
                            e.preventDefault();
                            if ($.trim($('#txtLedgerTransactionNo').val()) != "") {
                                searchdata('0', '');
                            }
                        }
                    });
        });
        function getsearchdata() {
            var dataPLO = new Object();
            dataPLO.SearchType = $('#ddlSearchType').val();
            dataPLO.LabNo = $('#txtLedgerTransactionNo').val();
            dataPLO.Centre = $('#ddlCentreAccess').val();
            dataPLO.User = $('#ddlUser').val();
            dataPLO.FromDate = $('#txtFormDate').val();
            dataPLO.ToDate = $('#txtToDate').val();
            dataPLO.FromTime = $('#txtFromTime').val();
            dataPLO.ToTime = $('#txtToTime').val();
            dataPLO.PanelID = $('#ddlPanel').val();
            return dataPLO;
        }
        function viewDetail2(LabNo) {

            //var BarcodeNo = $(LabNo).closest("tr").find('#td_BarcodeNo').text();
            serverCall('OPDReprint.aspx/encryptData', { LabNo: LabNo }, function (response) {
                var $responseData = JSON.parse(response);
                window.open("SampleTracking.aspx?LabNo=" + $responseData.LabNo, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

            });

        }
        var _$PageSize = 50;
        var _$PageNo = 0;
        var testCount = 0; var totalAmt = 0;
        var grossAmt = 0; var netAmt = 0; var discAmt = 0; var paidAmt = 0;
        var stype1 = '0';
        function searchdata(stype, pageno) {
            var searchdata = new Object();
            searchdata = getsearchdata();
            stype1 = stype;
            $('#tb_ItemList tr').slice(1).remove();
            if (pageno == "")
                _$PageNo = 0;
            else
                _$PageNo = pageno;
            testCount = 0;
            totalAmt = 0;
            grossAmt = 0; netAmt = 0;
            discAmt = 0; paidAmt = 0;dueAmt = 0;
            serverCall('OPDRePrint.aspx/SearchReceiptData', { searchdata: searchdata, stype: stype, PageNo: _$PageNo, PageSize: _$PageSize }, function (response) {
                TestData = $.parseJSON(response);
                if (TestData.length == 0) {
                    $('#spnTestCount').html('0');
                    $('#spnAmtCount').html('0');
                    return;
                }
                else {
                   // $('#PagerDiv1').html('');
                    //$('#PagerDiv1').hide();
                    if (pageno == "") {
                        $('#PagerDiv1').html('');
                    }
                    for (var i = 0; i <= TestData.length - 1; i++) {
                        grossAmt = parseFloat(grossAmt) + parseFloat(TestData[i].GrossAmount);
                        netAmt = parseFloat(netAmt) + parseFloat(TestData[i].NetAmount);
                        discAmt = parseFloat(discAmt) + parseFloat(TestData[i].DiscountOnTotal);
                        paidAmt = parseFloat(paidAmt) + parseFloat(TestData[i].Adjustment);
                        dueAmt = parseFloat(dueAmt) + parseFloat(TestData[i].Due);
                        if (pageno == "") {
                            _$PageNo = TestData[0].TotalRecord / _$PageSize;
                            testCount = parseInt(TestData[0].TotalRecord);
                            $('#spnTestCount').html(testCount);
                            totalAmt =  parseFloat(TestData[0].ttlNetAmount);
                            $('#spnAmtCount').html(totalAmt);
                        }
                       // totalAmt = parseFloat(totalAmt) + parseFloat(TestData[0].ttlNetAmount);
                       
                        var msg;
                        msg = "".concat("TT#", TestData[i].ItemName, "#0#", TestData[i].Result_Flag, "#", TestData[i].Approved, "#", TestData[i].ReportPrint, "");
                        var mydata = [];
                        mydata.push("<tr id='"); mydata.push(TestData[i].LabNo); mydata.push("'  style='background-color:"); mydata.push(TestData[i].rowColor); mydata.push(";'");
                        mydata.push('onMouseOver="show(\'' + msg + '\');" onMouseOut="toolTip()"  class="Text"> ');
                        if (pageno == "") {
                            mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle" >'); mydata.push(parseInt(i + pageno * _$PageSize + 1)); mydata.push('</td>');
                        }
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].EntryDate.trim()); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"><b>'); mydata.push(TestData[i].LabNo); mydata.push('</b></td>');
                        mydata.push('<td class="GridViewLabItemStyle"><b>'); mydata.push(TestData[i].BarcodeNo); mydata.push('</b></td>');
                        mydata.push('<td class="GridViewLabItemStyle"><b>'); mydata.push(TestData[i].PName); mydata.push('</b></td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].Pinfo); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].Mobile); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); mydata.push(TestData[i].GrossAmount); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); mydata.push(TestData[i].DiscountOnTotal); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); mydata.push(TestData[i].NetAmount); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); mydata.push(TestData[i].Adjustment); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); mydata.push(TestData[i].Due); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].CentreName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].PanelName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].DoctorName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(TestData[i].UserName); mydata.push('</td>');
                        //if (TestData[i].IsConcernForm != "0") {
                            //mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/view.gif" style="cursor:pointer;" ');
                        //    mydata.push('onclick="openpopup13(\''); mydata.push(TestData[i].LabNo); mydata.push('\')"/></td>');
                        //}
                        //else {
                        //    mydata.push('<td class="GridViewLabItemStyle"></td>');
                        //}


                        if ('<%=UserInfo.RoleID%>' != '212') {
						if ('<%=UserInfo.RoleID%>' != '11'){
                            mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/edit.png" style="cursor:pointer;" ');
                            mydata.push('onclick="openpopup1(\''); mydata.push(TestData[i].LabNo); mydata.push('\')"/></td>');
							if ('<%=UserInfo.RoleID%>' != '183'){
                            mydata.push('<td class="GridViewLabItemStyle">');
                            if (TestData[i].IsOPDConsultation == "0") {
                                mydata.push('<img alt="" src="../../App_Images/edit.png" style="cursor:pointer;" ');
                                mydata.push('onclick="openpopup2(\'' + TestData[i].LabNo + '\')"/>');
                            }
                            mydata.push('</td>');
							}
							else
								mydata.push('<td class="GridViewLabItemStyle"></td>');
							}
							else
							{
								mydata.push('<td class="GridViewLabItemStyle"></td>');
								mydata.push('<td class="GridViewLabItemStyle"></td>');
                            }
                            mydata.push('<td class="GridViewLabItemStyle">');
                            if (TestData[i].Iscredit == 0) {
                                mydata.push(' <img alt="" src="../../App_Images/edit.png" style="cursor:pointer;" ');
                                mydata.push('onclick="openpopup3(\''); mydata.push(TestData[i].LabNo); mydata.push('\',\'');
                                mydata.push(TestData[i].RegDate); mydata.push('\')"/>');
                            }
                            mydata.push('</td>');


                          //  mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/edit.png" style="cursor:pointer;" ');
                           // mydata.push('onclick="openpopuppanel(\''); mydata.push(TestData[i].LabNo); mydata.push('\',\''); mydata.push(TestData[i].RegDate); mydata.push('\')"/></td>');
                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
							mydata.push('<td class="GridViewLabItemStyle"></td>');
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                        }

                        var $ReceiptType = new Array();                                             
                        for (var s = 0; s < (TestData[i].ReceiptType.split(',').length) ; s++) {
                            $ReceiptType.push(TestData[i].ReceiptType.split(',')[s]);
                        }
                       if ('<%=UserInfo.RoleID%>' != '212'){
                        mydata.push('<td class="GridViewLabItemStyle">');
                        if (jQuery.inArray('2', $ReceiptType) != -1) {
                            mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" ');
                            mydata.push('onclick="openpopup4(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                        }  
						}
						else {
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                       }
                        if ('<%=UserInfo.RoleID%>' != '212') {
                            mydata.push('<td class="GridViewLabItemStyle">');
                            if (jQuery.inArray('2', $ReceiptType) != -1) {
                                mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" ');
                                mydata.push('onclick="openpopupmoney(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                            }
                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                        }
                        if ('<%=UserInfo.RoleID%>' != '212') {
                            mydata.push('<td class="GridViewLabItemStyle">');
                           // if (TestData[i].Due == 0)
                          //  if (TestData[i].IsRefund > 0) {
                                if (jQuery.inArray('2', $ReceiptType) != -1) {
                                    mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" ');
                                    mydata.push('onclick="openpopuprefund(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                                }
                            }
                       // }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                        }


                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">');
                        if (jQuery.inArray('4', $ReceiptType) != -1) {
                            mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" ');
                            mydata.push('onclick="openpopupfullpaid(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                        }                      
                        mydata.push('</td>');  
						
                        mydata.push('<td class="GridViewLabItemStyle">');
                        if (jQuery.inArray('3', $ReceiptType) != -1 && TestData[i].IsOPDConsultation == "0") {
                            mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" '); mydata.push('onclick="openDeptSlip(\'');
                            mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                        }
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">');
                        if (jQuery.inArray('1', $ReceiptType) != -1 && TestData[i].IsOPDConsultation == "0") {
                            mydata.push('<img alt="" src="../../App_Images/folder.gif" style="cursor:pointer;" ');
                            mydata.push('onclick="openTRF(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                        }
                        if (TestData[i].IsConcernForm != "0") {
                            mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/view.gif" style="cursor:pointer;" ');
                            mydata.push('onclick="openpopup13(\''); mydata.push(TestData[i].LabNo); mydata.push('\')"/></td>');
                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"></td>');
                        }
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">');
                        mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewDetail2(\'');
                        mydata.push(TestData[i].LabNo); mydata.push('\')"/>');
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">');
                        mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="clinicalhistory(\'');
                        mydata.push(TestData[i].LabNo); mydata.push('\')"/>');
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle">');
                        if (TestData[i].IsOPDConsultation == "0") {
                            mydata.push('<img alt="" src="../../App_Images/edit.png" style="cursor:pointer;" ');
                            mydata.push('onclick="openpopup5(\''); mydata.push(TestData[i].LabNo); mydata.push('\')"/>');
                        }
                        mydata.push('</td>');
                        if (TestData[i].DocAttach == "0") {
                            mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/show2.png" style="cursor:pointer;width:20px;height:20px;" ');
                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/redarr2.png" style="cursor:pointer;width:20px;height:20px;" ');
                        }
                        mydata.push(' onclick="callShowAttachment(\'' + TestData[i].LabNo + '\')" id="btnDocumentMaster"/></td>');
                        mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/EmailICON.png" style="cursor:pointer;width:20px;height:20px;" ');
                        mydata.push('onclick="EmailResend(\''); mydata.push(TestData[i].LabNo); mydata.push('\')"/>');
                        if (TestData[i].DiscountApprovedByName != "" && TestData[i].IsDiscountApproved == "0") {
                            mydata.push('<img title="Discount Verification Email" alt="" src="../../App_Images/gmail.png" style="cursor:pointer;width:16px;height:16px;" ');//onclick="DiscountVerificationMail('); mydata.push(TestData[i].LabNo); mydata.push(');" />');
                            mydata.push('onclick="DiscountVerificationMail(\''); mydata.push(TestData[i].EncryptID); mydata.push('\')"/>');
                        }
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"><img alt="" src="../../App_Images/sms.ico" style="cursor:pointer;width:16px;height:16px;" title="Tiny SMS"; ');
                        mydata.push('onclick="loadSmsdetail(\''); mydata.push(TestData[i].Mobile); mydata.push('\',\''); mydata.push(TestData[i].LedgerTransactionID); mydata.push('\')"/></td>');
                        mydata.push('</tr>');
                        mydata = mydata.join("");
                        $('#tb_ItemList').append(mydata);
                    }
                    var mydata1 = [];
                    mydata1.push("<tr id='footer' style='font-weight:bold;color:red;'>");
                    mydata1.push('<td colspan="7" align="right">Total::&nbsp;&nbsp;&nbsp;</td>');
                    mydata1.push('<td style="text-align:right" class="GridViewLabItemStyle">'); mydata1.push(precise_round(grossAmt, '<%=Resources.Resource.BaseCurrencyRound%>')); mydata1.push('</td>');
                    mydata1.push('<td style="text-align:right" class="GridViewLabItemStyle">'); mydata1.push(precise_round(discAmt, '<%=Resources.Resource.BaseCurrencyRound%>')); mydata1.push('</td>');
                    mydata1.push('<td style="text-align:right" class="GridViewLabItemStyle">'); mydata1.push(precise_round(netAmt, '<%=Resources.Resource.BaseCurrencyRound%>')); mydata1.push('</td>');
                    mydata1.push('<td style="text-align:right" class="GridViewLabItemStyle">'); mydata1.push(precise_round(paidAmt, '<%=Resources.Resource.BaseCurrencyRound%>')); mydata1.push('</td>');
                    mydata1.push('<td style="text-align:right" class="GridViewLabItemStyle">'); mydata1.push(precise_round(dueAmt, '<%=Resources.Resource.BaseCurrencyRound%>')); mydata1.push('</td>');
                   
                    mydata1.push("</tr>");
                    mydata1 = mydata1.join("");
                    $('#tb_ItemList').append(mydata1);
                    if (pageno == "" ) {
                        var myval = [];
                        if (_$PageNo > 1 && _$PageNo < 50) {

                            for (var j = 0; j < _$PageNo; j++) {
                                var me = parseInt(j) + 1;
                                myval.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="showme(\''); myval.push(j); myval.push('\');"  >'); myval.push(me); myval.push('</a>');

                            }
                        }
                        else if (_$PageNo > 50) {

                            for (var j = 0; j < 50; j++) {
                                var me = parseInt(j) + 1;
                                myval.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="showme(\''); myval.push(j); myval.push('\');"  >'); myval.push(me); myval.push('</a>');

                            }
                            myval.push('&nbsp;&nbsp;<select onchange="shownextrecord()" id="myddl">');
                            myval.push('<option value="Select">Select Page</option>');
                            for (var j = 50; j < _$PageNo; j++) {
                                var me = parseInt(j) + 1;
                                myval.push('<option value="'); myval.push(j); myval.push('">'); myval.push(me); myval.push('</option>');

                            }
                            myval.push("</select>");
                        }
                        myval = myval.join("");
                        $('#PagerDiv1').append(myval);

                        $('#PagerDiv1').show();
                    }
                }

            });
        }
        function showme(pageno) {
            searchdata(stype1, pageno);
        }
        function clinicalhistory(LabNo) {
            serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: LabNo }, function (response) {
                var href = "../Lab/ClincalHistory.aspx?LabNo=" + response;
                $.fancybox({
                    maxWidth: 840,
                    maxHeight: 500,
                    fitToView: false,
                    width: '80%',
                    height: '40%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
            });
        }
        function callShowAttachment(PLeddNo) {
            var href = "../Lab/AddFileRegistration.aspx?labno=" + PLeddNo;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }


        function openpopup1(labno) {
            $Encrypt(labno, function (Elabno) {
                window.open("Lab_PrescriptionOPDEditInfo.aspx?labno=" + Elabno);
            });

        }
        function openpopuppanel(labno) {
            $Encrypt(labno, function (Elabno) {
                window.open("ChangePanel.aspx?labno=" + Elabno);
            });

        }
    
        function openpopup13(labno) {
            serverCall('OPDRePrint.aspx/ConcentFormData', { LabNo: labno }, function (response) {
                $responseData1 = JSON.parse(response);
                var $responseData=jQuery.parseJSON($responseData1.response)
                if ($responseData.length > 0) {
                    for (var i = 0; i < $responseData.length; i++) {
                        window.open("../ConcentForm/PrintConcentFrom.aspx?labno=" + labno + "&ReferDoctor=" + $responseData[i].DoctorName + "&Panel=" + $responseData[i].PanelName + "&TestName=" + $responseData[i].ItemName + "&Gender=" + $responseData[i].Gender + "&Age=" + $responseData[i].Age + "&PatientName=" + $responseData[i].PName + "RegDate=" + $responseData[i].RegDate + "&Name=" + $responseData[i].ConcernFormid + "&Mobile=" + $responseData[i].Mobile + "&DocMobile=" + $responseData[i].DocMobile + "&Patient_ID=" + $responseData[i].Patient_ID + "&Son=" + $responseData[i].Son + "&Children=" + $responseData[i].Children + "&AgeSon=" + $responseData[i].AgeSon + "&Daughter=" + $responseData[i].Daughter + "&AgeDaughter=" + $responseData[i].AgeDaughter + "&House_No=" + $responseData[i].House_No + "&Pregnancydate=" + $responseData[i].Pregnancydate);
                    }
                }
                    });
        }
        function openpopup2(labno) {
            serverCall('OPDRePrint.aspx/PostData', { ID: labno }, function (response) {
                $responseData = JSON.parse(response);
                PostQueryString($responseData, 'Lab_PrescriptionOPDEdit.aspx');
            });



        }
        var $Encrypt = function (encryptText, callback) {
            if (encryptText != "") {
                serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: encryptText.trim() }, function (response) {
                    callback(response);
                });
            }
        }
        function openpopup3(labno, regdate) {
            $Encrypt(labno, function (Elabno) {
                $Encrypt(regdate, function (Eregdate) {
                    window.open("OpdSettelment.aspx?labno=" + Elabno + "&regdate=" + Eregdate);
                });
            });
        }
        function openpopupmoney(labid) {
            window.open('MoneyReceiptNew1.aspx?LabID=' + labid);
          //window.open("".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>?LabID=' + labid));
               // PostQueryString(labid, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
        }
        function openpopuprefund(labid) {
            window.open('RefundReceiptNew1.aspx?LabID=' + labid);
            //window.open("".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>?LabID=' + labid));
             // PostQueryString(labid, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
         }
        function openpopup4(labid) {
            window.open("".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>?LabID=' + labid));
            // PostQueryString(labid, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
        }
		function openpopupfullpaid(labid) { 
          window.open('PatientReceiptNewFull.aspx?LabID=' + labid);
        }
        function openDeptSlip(ID) {
            window.open('Departmentslip.aspx?ID=' + ID);
        }
        function openTRF(ID) {
            window.open('TRF.aspx?ID=' + ID);
        }
        function openpopup5(labno) {
            $Encrypt(labno, function (Elabno) {
                window.open("BarCodeReprint.aspx?LabID=" + Elabno);
            });
        }
        function openpopup6(labno) {
            $Encrypt(labno, function (Elabno) {
                window.open('../Lab/AddFileRegistration.aspx?labno=' + Elabno, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            });
        }
        function show(msg) {
            toolTip(msg)
        }
        function toolTip(msg, fg, bg) {
            initToolTips();
            if (toolTip.arguments.length < 1) // if no arguments are passed then hide the tootip
            {
                if (is_nav4)
                    toolTipSTYLE.visibility = "hidden";
                else
                    toolTipSTYLE.display = "none";
            }
            else // show
            {
                var data = msg.split('#');
                if (data[0] == 'TT') {

                    if (data[1].indexOf(",") < 0) {

                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        var content = [];
                        content.push('<table border="0" cellspacing="0" cellpadding="0" class="toolTip"><tr><td bgcolor="'); content.push(fg); content.push('">');
                        if (data[2] == 'Y') {
                            content.push('<table border="0" cellspacing="1" cellpadding="0"><tr><td bgcolor="#dcdcdc">');
                            content.push('<font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">1) '); content.push(data[1]); content.push(' - Refund');
                        }
                        else if (data[5] == 'Y') {
                            content.push('<table border="0" cellspacing="1" cellpadding="0"><tr><td bgcolor="#00FFFF">');
                            content.push('<font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">1) '); content.push(data[1]); content.push(' - ReportPrint');
                        }
                        else if (data[4] == 'Y') {
                            content.push('<table border="0" cellspacing="1" cellpadding="0"><tr><td bgcolor="#9acd32">');
                            content.push('<font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">1) '); content.push(data[1]); content.push(' - Approved');
                        }
                        else if (data[3] == 'Y') {
                            content.push('<table border="0" cellspacing="1" cellpadding="0"><tr><td bgcolor="#FFC0CB">');
                            content.push('<font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">1) '); content.push(data[1]); content.push(' - ResultSaved');
                        }

                        else {
                            content.push('<table border="0" cellspacing="1" cellpadding="0"><tr><td bgcolor="'); content.push(bg); content.push('">');
                            content.push('<font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">1) '); content.push(data[1]);
                        }

                        content.push('</font></td></tr></table></td></tr></table>');

                        content = content.join(" ");

                    }
                    else {
                        var temp = data[1].split(',');
                        var RefundFlag = data[2].split(',');
                        var ApprovedFlag = data[4].split(',');
                        var ResultDoneFlag = data[3].split(',');
                        var ReportPrintFlag = data[5].split(',');
                        var n = 0;
                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        var content = [];
                        content.push('<table border="0" cellspacing="0" cellpadding="0" class="toolTip"><tr><td bgcolor="'); content.push(fg); content.push('">');
                        content.push('<table border="0" cellspacing="2" cellpadding="0"');

                        if (temp.length < 5) {

                            for (n = 0; n < temp.length; n++) {
                                if (RefundFlag[n] == 'Y') {
                                    content.push('<tr><td bgcolor="#dcdcdc"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - Refund');
                                }
                                else if (ReportPrintFlag[n] == 'Y') {
                                    content.push('<tr><td bgcolor="#00FFFF"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - Report Print');
                                }
                                else if (ApprovedFlag[n] == 'Y') {
                                    content.push('<tr><td bgcolor="#9acd32"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - Approved');
                                }
                                else if (ResultDoneFlag[n] == 'Y') {
                                    content.push('<tr><td bgcolor="#FFC0CB"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - ResultSaved');
                                }
                                else {
                                    content.push('<tr><td bgcolor="'); content.push(bg); content.push('"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]);
                                }
                                content.push('</tr>');
                            }
                        }
                        else {
                            for (n = 0; n < temp.length;) {

                                content.push('<tr>');

                                if (RefundFlag[n] == 'Y') {
                                    content.push('<td bgcolor="#dcdcdc"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - Refund </font></td>');
                                }
                                else if (ApprovedFlag[n] == 'Y') {
                                    content.push('<td bgcolor="#9acd32"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - Approved </font></td>');
                                }
                                else if (ResultDoneFlag[n] == 'Y') {
                                    content.push('<td bgcolor="#FFC0CB"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push(' - ResultSaved </font></td>');
                                }
                                else {
                                    content.push('<td bgcolor="'); content.push(bg); content.push('"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 1)); content.push(') '); content.push(temp[n]); content.push('</font></td>');
                                }

                                if (n < temp.length - 1) {
                                    if (RefundFlag[n + 1] == 'Y') {
                                        content.push('<td bgcolor="#dcdcdc"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 2)); content.push(') '); content.push(temp[n + 1]); content.push(' - Refund </font></td>');
                                    }
                                    else if (ApprovedFlag[n + 1] == 'Y') {
                                        content.push('<td bgcolor="#9acd32"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 2)); content.push(') '); content.push(temp[n + 1]); content.push(' - Approved </font></td>');
                                    }
                                    else if (ResultDoneFlag[n + 1] == 'Y') {
                                        content.push('<td bgcolor="#FFC0CB"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 2)); content.push(') '); content.push(temp[n + 1]); content.push(' - ResultSaved </font></td>');
                                    }
                                    else {
                                        content.push('<td bgcolor="'); content.push(bg); content.push('"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1">'); content.push(eval(n + 2)); content.push(') '); content.push(temp[n + 1]); content.push('</font></td>');
                                    }

                                }
                                else {
                                    content.push('<td bgcolor="'); content.push(bg); content.push('"><font face="sans-serif" color="'); content.push(fg); content.push('" size="-1"></font></td>');
                                }
                                n = n + 2;
                                content.push('</tr>');

                            }

                        }
                        content.push('</table></td></tr></table>');
                        content = content.join(" ");
                    }
                }
                if (is_nav4) {
                    toolTipSTYLE.document.write(content);
                    toolTipSTYLE.document.close();
                    toolTipSTYLE.visibility = "visible";
                }

                else if (is_ie || is_nav6up) {
                    document.getElementById("toolTipLayer").innerHTML = content;
                    toolTipSTYLE.display = 'block'
                }
            }
        }
        //tooltip Position
        var offsetX = 0;
        var offsetY = 5;
        var opacity = 100;
        var toolTipSTYLE;

        function initToolTips() {
            if (document.getElementById) {
                toolTipSTYLE = document.getElementById("toolTipLayer").style;
            }
            if (is_ie || is_nav6up) {
                toolTipSTYLE.visibility = "visible";
                toolTipSTYLE.display = "none";
                document.onmousemove = moveToMousePos;
            }
        }
        function moveToMousePos(e) {
            if (!is_ie) {
                x = e.pageX;
                y = e.pageY;
            } else {
                x = event.x + document.body.scrollLeft;
                y = event.y + document.body.scrollTop;
            }

            toolTipSTYLE.left = x + 15 + offsetX + 'px';
            toolTipSTYLE.top = y + offsetY + 'px';
            return true;
        }
        var agt = navigator.userAgent.toLowerCase();
        var is_major = parseInt(navigator.appVersion);
        var is_minor = parseFloat(navigator.appVersion);

        var is_nav = ((agt.indexOf('mozilla') != -1) && (agt.indexOf('spoofer') == -1)
                    && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera') == -1)
                    && (agt.indexOf('webtv') == -1) && (agt.indexOf('hotjava') == -1));
        var is_nav4 = (is_nav && (is_major == 4));
        var is_nav6 = (is_nav && (is_major == 5));
        var is_nav6up = (is_nav && (is_major >= 5));
        var is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
    </script>
         <script type="text/javascript">
             function showDocumentMaster() {
                 $('#divDocumentMaters').show();
             }
             var $bindDocumentMasters = function (callback) {
                 serverCall('../../design/common/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: $('#txtPID').val() }, function (response) {
                     $responseData = JSON.parse(response);
                     documentMaster = $responseData.patientDocumentMasters;
                     var $template = $('#template_DocumentMaster').parseTemplate(documentMaster);
                     $('#documentMasterDiv').html($template);
                     callback(true);
                 });
             }
             var previewImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
             function ShowCaptureImageModel() {
                 $('#camViewer').showModel();
                 Webcam.set({
                     width: 320,
                     height: 240,
                     image_format: 'jpeg',
                     jpeg_quality: 90,
                     //force_flash: true
                 });
                 Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
                 Webcam.attach('#webcam');
             }
             function closeCamViewer(callback) {
                 //Webcam.snap(function (data_uri) {
                 $('#camViewer').closeModel();
                 document.getElementById('imgPreview').src = previewImage; //'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                 Webcam.reset();
                 callback();
                 // });
             }
             function selectImage(base64image) {
                 base64image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                 closeCamViewer(function () {
                     document.getElementById('imgPatient').src = base64image;
                     $('#spnIsCapTure').text('1');
                 });
             }
             function showDocumentMaster() {
                 $('#divDocumentMaters').show();
             }
             function documentNameClick(elem, row) {
                 $(row.parentNode).find('tr button[type=button]').attr('style', 'width: 100%; text-align: center; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')
                 $('#tblDocumentMaster tr #tdBase64Document').each(function (index, elem) {
                     if (!String.isNullOrEmpty($(this).text()))
                         $(this).parent().find('button[type=button]').css({ 'backgroundColor': 'LIGHTGREEN', 'background-image': 'none' });
                 });
                 $(elem).css({ 'backgroundColor': 'antiquewhite', 'background-image': 'none' });
                 elem.style.color = 'black';
                 var $seletedDocumentID = $(row).find('#tdDocumentID').text();
                 $('#spnSelectedDocumentID').text($seletedDocumentID);
                 var $scanDocument = $(row).find('#tdBase64Document')[0].innerHTML;
                 if ($scanDocument != '')
                     document.getElementById('imgDocumentPreview').src = $scanDocument;
                 else {
                     var patientId = document.getElementById('txtPID').value;
                     if (patientId != '') {
                         serverCall('../../design/common/ScanDocumentServices.asmx/GetDocument', { patientId: patientId, documentName: elem.value }, function (response) {
                             var $responseData = JSON.parse(response);
                             if ($responseData.status)
                                 document.getElementById('imgDocumentPreview').src = $responseData.data;
                             else
                                 document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                         });
                     }
                     else
                         document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                 }
             }
             function showScanModel() {
                 if ($('#spnSelectedDocumentID').text() != '') {
                     serverCall('../../design/common/ScanDocumentServices.asmx/GetShareScanners', {}, function (response) {
                         var $responseData = JSON.parse(response);
                         if ($responseData.status) {
                             $('#ddlSccaner').bindDropDown({
                                 data: $responseData.data,
                                 defaultValue: null,
                                 valueField: 'DeviecId',
                                 textField: 'Name'
                             });
                         }
                         else
                             modelAlert('Error While Access Scanner');
                     });
                     document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                     $('#scanViewer').showModel();
                 }
                 else
                     modelAlert('Please Select Document First !!');
             }
             function scanDocument(deviceId) {
                 serverCall('../../design/common/ScanDocumentServices.asmx/Scan', { deviceID: deviceId }, function (response) {
                     var $responseData = JSON.parse(response);
                     if ($responseData.status)
                         $('#imgScanPreview').attr('src', 'data:image/jpeg;base64,' + $responseData.data);
                     else
                         modelAlert('Error While Scan');
                 });
             }
             function selectScanDocument(base64Document) {
                 var $selectedDocumentID = $('#spnSelectedDocumentID').text().trim();
                 $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                     if (this.innerHTML.trim() == $selectedDocumentID) {
                         $(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                         $('#imgDocumentPreview').attr('src', base64Document);
                         $('#scanViewer').closeModel();
                     }
                 });
             }
             function showCaptureModel() {
                 if ($('#spnSelectedDocumentID').text() != '') {
                     document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                     $('#documentCamViwer').showModel();
                     Webcam.set({
                         width: 320,
                         height: 240,
                         image_format: 'jpeg',
                         jpeg_quality: 90,
                         //force_flash: true
                     });
                     Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
                     Webcam.attach('#documentWebCam');
                 }
                 else
                     modelAlert('Please Select Document First !!');
             }
             function takeDocumentSnapShot() {
                 Webcam.snap(function (data_uri) {
                     $('#imgDocumentSnapPreview').attr('src', data_uri);
                     $('#btnSelectDocumentCapture').show();
                 });
             }
             function selectDocumentCapture(base64Document) {
                 var $selectedDocumentID = $('#spnSelectedDocumentID').text().trim();
                 $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                     if (this.innerHTML.trim() == $selectedDocumentID) {
                         $(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                         $('#imgDocumentPreview').attr('src', base64Document);
                         $('#documentCamViwer').closeModel();
                     }
                 });
                 Webcam.reset();
             }
             function closeDocumentCamViwer() {
                 $('#documentCamViwer').closeModel();
                 document.getElementById('imgDocumentSnapPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                 Webcam.reset();
             }
             function divDocumentMatersCloseModel() {
                 getUpdatedPatientDocuments(function (responseData) {
                     $('#btnDocumentMaster').val(responseData.length + "  Document's");
                     $('#divDocumentMaters').closeModel();
                 });
             }
             function getUpdatedPatientDocuments(callback) {
                 var patientDocuments = [];
                 $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                     if ($(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                         var $document = {
                             documentId: this.innerHTML.trim(),
                             name: $(this.parentNode).find('#btnDocumentName').val(),
                             data: $(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                         }
                         patientDocuments.push($document);
                     }
                 });
                 callback(patientDocuments);
             }
    </script>
    <script type="text/javascript">
        function movetoNext(current, nextFieldID) {
            document.getElementById(nextFieldID).value = "";
            document.getElementById(nextFieldID).focus();
        }
        function EmailResend(LedNo) {
            $.fancybox({
                maxWidth: 1030,
                maxHeight: 800,
                fitToView: false,
                width: '90%;',
                height: '50%',
                href: '../Lab/ReportEmailPopUP.aspx?VisitNo=' + LedNo + '',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        function DiscountVerificationMail(Id) {
            serverCall('OPDRePrint.aspx/GetDiscountApprovalStatus', { Id: Id }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.length > 0) {
                    var Msg = "";
                    if ($responseData[0].IsDiscountApproved == 1)
                        Msg = "".concat("<b>", "Discount Already Approved", "</b><br/><br/>");
                    var Msg = "".concat(Msg, "Do you want to resend Discount verification email to :<b>", $responseData[0].Name, "<br/> (Email :-" + $responseData[0].Email + ")","</b>");
                    var Flag = confirmStatus(Msg, Id);
                }
                else {
                    toast("Info", "No Log Found", "");
                }
            });
        }
        sendDiscountApprovalMail = function (Id) {
            serverCall('OPDRePrint.aspx/ResendDiscountVerificationMail', { Id: Id }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
    </script>    
        <script type="text/javascript">
            function confirmStatus(content, Id) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: content,
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
                                sendDiscountApprovalMail(Id);
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
            $closeSmsModel = function () {
                jQuery('#divsms').hideModel();
                $('#tblsms tr').slice(1).remove();
            }
            function loadSmsdetail(MobileNo,labno) {
                $('#txtmobilebillsms').val(MobileNo);
                $('#txtmobilereportsms').val(MobileNo);
                $('#hdnlabno').val(labno);
                serverCall('OPDRePrint.aspx/loadSmsdetail', { MobileNo: MobileNo }, function (response) {
                    var $responseData = JSON.parse(response);
                        for (var i = 0; i < $responseData.length; i++) {
                            var $mydata = [];
                            $mydata.push('<tr class="GridViewItemStyle">');
                            $mydata.push('<td>'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].Mobile_No); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].Sms_Type); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].STATUS); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].EntDate); $mydata.push('</td>');
                            $mydata.push('</tr>');
                            $mydata = $mydata.join("");
                            $('#tblsms').append($mydata);
                        }
                    
                    jQuery('#divsms').showModel();
                });
            }
            function sendtinysms(smstype) {
                if (smstype == "Receipt") {
                    if ($('#txtmobilebillsms').val() == "") {
                        toast("Error", "Please enter Mobile No for Receipt..!", "");
                        return;
                    }
                }
                if (smstype == "LabReport") {
                    if ($('#txtmobilereportsms').val() == "") {
                        toast("Error", "Please enter Mobile No for LabReport..!", "");
                        return;
                    }
                }
                serverCall('OPDRePrint.aspx/sendtinysms', { MobileNo: $('#txtmobilebillsms').val(), LabNo: $('#hdnlabno').val(), BillType: $('#rblbilltype input:checked').val(), smstype: smstype }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                  
                });
            }
    </script>
        <div id="divDocumentMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 900px; height: 600px">
			<div class="modal-header">
				<button type="button" class="close" onclick="divDocumentMatersCloseModel()" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Patient Documents Master</h4>
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
				 <button type="button" id="btnScan" style="font-weight:bold"  onclick="showScanModel()" >Scan</button>
				 <button type="button" style="font-weight:bold"  onclick="showCaptureModel()" >Capture</button>
				 <input id="file" name="url[]"  style="display:none" type="file" accept="image/x-png,image/gif,image/jpeg,image/jpg"  onchange="handleFileSelect(event)" />
				<%-- <button type="button" id="btnBrowser" onclick="document.getElementById('file').click()" style="font-weight:bold"  >Browse...</button> --%>
				 <button type="button" style="font-weight:bold"  onclick="divDocumentMatersCloseModel()">Close</button>
			</div>
		</div>
	</div>
</div>
        <div id="scanViewer"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:900px;height:600px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="scanViewer" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Scan Document</h4>
				</div>
				<div class="modal-body">
				   <div  id="Div8">
					  <table style="width:100%">
						  <tr>
							  <td style="width:20%">
							  <table style="width:100%">
								  <tr>
									  <td>
										  <b>Select Scanner:</b>
									  </td>
								  </tr>
								  <tr>
										<td>
										 <select class="form-control" style="width:100%;height: 22px;padding: 0px;" id="ddlSccaner"></select>
									  </td>
								  </tr>
								  <tr>
										<td style="text-align:center">
										<input type="button" onclick="scanDocument($('#ddlSccaner').val())"   value="Scan" />
									  </td>
								  </tr>
							  </table>
							  </td>
							  <td style="width:80%">
								  <div style="width:100%" >
									 <div style="width: 100%;height:475px;overflow:auto">
									 <img style="width:100%" id="imgScanPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />
									 </div>
								  </div>
							  </td>
						  </tr>
					  </table>
				   </div>
				</div>
				<div class="modal-footer">
					<button type="button"  onclick="selectScanDocument(document.getElementById('imgScanPreview').src)" >Select</button>
					<button type="button"  data-dismiss="scanViewer">Close</button>
				</div>
			</div>
		</div>
   </div>

 <%--style="padding-top: 190px;"--%>
        <div id="documentCamViwer"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:900px;height:600px">
				<div class="modal-header">
					<button type="button" class="close" onclick="closeDocumentCamViwer()" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Capture Document</h4>
				</div>
				<div class="modal-body">
				   <div  id="Div9">
					  <table style="width:100%">
						  <tr>
							  <td style="width:40%">
							  <table style="width:100%">
								  <tr>
									  <td style="text-align:center">
										  <b >Live Camera</b>
									  </td>
								  </tr>
								  <tr>
										<td>
										 <div id="documentWebCam" style="width:100%;height:300px;">
										 </div>
									  </td>
								  </tr>
								 <tr> 
										<td style="text-align:center">
										<input type="button" style="font-weight:bold" onclick="takeDocumentSnapShot()"   value="Capture" />
									  </td>
								  </tr>
							  </table>
							  </td>
							  <td style="width:60%">
								  <div style="width:100%" >
									 <div style="width: 100%;height:475px;overflow:auto">
									 <img style="width:100%;height: 100%;" id="imgDocumentSnapPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />
									 </div>
								  </div>
							  </td>
						  </tr>
					  </table>
				   </div>
				</div>
				<div class="modal-footer">  
					<button type="button" id="btnSelectDocumentCapture"  onclick="selectDocumentCapture(document.getElementById('imgDocumentSnapPreview').src)">Select</button>
					<button type="button"  onclick="closeDocumentCamViwer()">Close</button>
				</div>
			</div>
		</div>
   </div>
    <div id="divsms" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 70%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Send Manual SMS</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeSmsModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
             <div class="row">
                 <div class="col-md-4"><asp:TextBox ID="txtmobilebillsms" runat="server"></asp:TextBox> </div>
                 <div class="col-md-5"><asp:RadioButtonList ID="rblbilltype" runat="server" RepeatDirection="Horizontal"><asp:ListItem Selected="True" Text="NetBill" Value="0"></asp:ListItem><asp:ListItem Text="MRP Bill" Value="1"></asp:ListItem> </asp:RadioButtonList> </div>
                 <div class="col-md-4"><input type="button" id="btnsendbillsms"  onclick="sendtinysms('Receipt')" class="searchbutton" value="Send Receipt" /> </div>
            <div class="col-md-3"><asp:HiddenField ID="hdnlabno" runat="server" /> </div>
                 <div class="col-md-4"><asp:TextBox ID="txtmobilereportsms" runat="server"></asp:TextBox> </div>
                 <div class="col-md-4"><input type="button" id="btnsendreporttinysms"  onclick="sendtinysms('LabReport')" class="searchbutton" value="Send Lab Report" /> </div>
                 
             </div>
             <div class="row" style="overflow:scroll;height:200px">
                 <div class="col-md-24">
               <table id="tblsms" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trh">
                         <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                         <td class="GridViewHeaderStyle">Mobile</td>
                         <td class="GridViewHeaderStyle">SMS Type</td>
                         <td class="GridViewHeaderStyle">Status</td>
                         <td class="GridViewHeaderStyle">Date</td>
                         
                    </tr>
                </table>
                 </div>
             </div>
             </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeSmsModel()">Close</button>
			</div>
            </div>
        </div>
      </div>
</asp:Content>

