<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OpdSettelment.aspx.cs" Inherits="Design_Lab_OpdSettelment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
       <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %> 
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="Final Settelment" Font-Size="16px" Font-Bold="true"></asp:Label><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlSearchType" CssClass="ItDoseDropdownbox" runat="server" Width="150px">
                        <asp:ListItem Value="lt.LedgertransactionNo" Selected="True">Lab No</asp:ListItem>
                        <asp:ListItem Value="plo.BarcodeNo">Barcode No</asp:ListItem>
                        <asp:ListItem Value="lt.PName">Patient Name</asp:ListItem>
                        <asp:ListItem Value="pm.Mobile">Mobile</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtLedgerTransactionNo"  runat="server" ></asp:TextBox>
                </div>
                <div class="col-md-2">Centre :</div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess chosen-select chosen-container" runat="server" >
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkDoctor" runat="server" Checked="false" Text="Referred Doctor : " onClick="BindDoctor();" Style="display:none"/>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlReferDoc" runat="server"  Style="display:none"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"><b>From Date :</b></div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFormDate"  runat="server" ></asp:TextBox>
                    <asp:TextBox ID="txtFromTime" Style="display: none" runat="server" ></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime" ControlExtender="mee_txtFromTime" ControlToValidate="txtFromTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2"><b>To Date :</b></div>
                <div class="col-md-6">

                    <asp:TextBox ID="txtToDate"  runat="server" ></asp:TextBox>

                    <asp:TextBox ID="txtToTime" Style="display: none" runat="server" ></asp:TextBox>

                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkPanel" runat="server" onClick="BindPanel();" Text="Client : " Style="display:none"/>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPanel" runat="server"   Style="display:none">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <input type="button" value="Search" class="searchbutton" onclick="$searchData()" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Detail&nbsp;&nbsp;&nbsp; 
                   <span style="font-weight: bold; color: black;">Total Patient:&nbsp;</span><span id="testCount" style="font-weight: bold; color: black;"></span>
                <span style="font-weight: bold; color: black;">Total&nbsp; Due Amt:&nbsp;</span><span id="amtCount" style="font-weight: bold; color: black;"></span>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                        <tr id="header">
                            <td class="GridViewHeaderStyle" style="width:30px">S.No.</td>
                            <td class="GridViewHeaderStyle"style="width:80px">Bill DateTime</td>
                            <td class="GridViewHeaderStyle" style="width:100px">Lab No.</td>
                            <td class="GridViewHeaderStyle" style="width:200px">Patient Name</td>
                            <td class="GridViewHeaderStyle" style="width:150px">Centre</td>
                            <td class="GridViewHeaderStyle" style="width:150px">Client</td>
                            <td class="GridViewHeaderStyle" style="width:150px">Doctor</td>
                            <td class="GridViewHeaderStyle" style="width:70px">Gross&nbsp;Amt.</td>
                            <td class="GridViewHeaderStyle" style="width:70px">Disc Amt.</td>
                            <td class="GridViewHeaderStyle" style="width:70px">Net Amt.</td>
                            <td class="GridViewHeaderStyle" style="width:70px">Paid Amt.</td>
                            <td class="GridViewHeaderStyle" style="width:70px">Due Amt.</td>
                            <td class="GridViewHeaderStyle" style="width:40px">Select</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory divPaymentControl" style="display: none;" >
            <div class="Purchaseheader">Payment Detail&nbsp;&nbsp;&nbsp;  </div>
             <div class="row">              
                           <div class="col-md-3 ">
                               <label class="pull-left">Item   </label>
			                   <b class="pull-right">:</b>
                               </div>
                         <div class="col-md-21 ">
                             <span id="spnItemName"></span>
                                <span id="labNo" style="display: none;"></span>
                              <span id="PName" style="display: none;"></span>
                              <span id="mobileno" style="display: none;"></span>
                              <span id="centretypeid" style="display: none;"></span>
                                <span id="labID" style="display: none;"></span>
                                <span id="spnPatient_ID" style="display: none;" patientAdvanceAmount="0"></span>
                                <span id="spnPanelID" style="display: none;"></span>
                                <span id="spnCentreID" style="display: none;" panel_ID="0"></span>
                             </div>
               </div>
             <div class="row">
              <div class="col-md-3 ">
                               <label class="pull-left">Pay By</label>
			                   <b class="pull-right">:</b>
                               </div>
             <div class="col-md-3 ">
                 <asp:DropDownList ID="ddlPayBy" runat="server">
                                    <asp:ListItem Value="P">Patient</asp:ListItem>
                                    <asp:ListItem Value="C">Corporate</asp:ListItem>
                                </asp:DropDownList>
                 </div>
             <div class="col-md-3 ">                           
                               </div>          
             <div class="col-md-5 ">                
                 </div>
            </div>
            <div class="row">
        <div class="col-md-3 ">
                               <label class="pull-left">Due Amount   </label>
			                   <b class="pull-right">:</b>
                               </div>
                  <div class="col-md-3 ">
                      					<input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold;color:#09f" value="0" id="txtAmount"  type="text" autocomplete="off"  />                                          
                                <asp:TextBox ID="txtDueAmount" runat="server" Style="display: none;"></asp:TextBox>
                      </div>
                  <div class="col-md-3 ">
                       <label class="pull-left">Paid Amount</label>
								<b class="pull-right">:</b>
                               </div>
                 <div class="col-md-3 ">
                       <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtPaidAmount" type="text"  autocomplete="off" />
                     </div>
                 <div class="col-md-3 ">
                   <label class="pull-left">Balance Amount</label>
                    <b class="pull-right">:</b>
                               </div>
                    
            <div class="col-md-3">
                					  <input  type="text" class="ItDoseTextinputNum" style="font-weight:Bold"  value="0"  id="txtBlanceAmount" autocomplete="off" disabled="disabled"  />
                </div>
                <div class="col-md-3 ">
                   <label class="pull-left">Currency Round</label>
                    <b class="pull-right">:</b>
                               </div>
                <div class="col-md-3" >
                       <input  type="text" class="ItDoseTextinputNum" style="font-weight:Bold"  value="0"  id="txtCurrencyRound" autocomplete="off" disabled="disabled"  />  
                     </div>
                  </div>
            <div class="row">
				<div  class="col-md-3">
					 <label class="pull-left">Currency</label>
					 <b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                    <select onchange="$onChangeCurrency(this,'1',function(){});" id="ddlCurrency">
					</select>
                     <span id="spnBaseCurrency" style="display:none"></span>
	              <span id="spnBaseCountryID" style="display:none"></span>
	              <span id="spnBaseNotation" style="display:none"></span>
	              <span id="spnCFactor" style="display:none"></span> <span id="spnConversion_ID" style="display:none"></span>   <span id="spnControlpatientAdvanceAmount" style="display:none">0</span>  
				</div>
                <div id="spnBlanceAmount" style="color:red;font-weight:bold;text-align: left;" class="col-md-5">
				 
				</div>
                <div class="col-md-3">
								<label class="pull-left">Factor</label>
								<b class="pull-right">:</b>
				</div>
				<div id="spnConvertionRate" style="color:red;font-weight:bold;text-align: left;" class="col-md-7">
			</div></div>           
        <div class="row">
        <div class="col-md-3 ">
            <label class="pull-left">Payment Mode   </label>
			                   <b class="pull-right">:</b>
                               </div>
            <div  id="divPaymentMode"  style="padding-right:100px" class="col-md-18"></div>           
				<div class="col-md-3 clPaidAmt">                  
				</div>		
             </div>
            <div class="row">
                  <div class="col-md-3 ">
                      </div>
				<div id="divPaymentDetails" class="col-md-18 isReciptsBool" style="overflow-y: auto; overflow-x: hidden">
				<table  class="GridViewStyle cltblPaymentDetail" border="1" id="tblPaymentDetail" rules="all" style="border-collapse:collapse;">
				 <thead>
				 <tr id="trPayment">
				 <th class="GridViewHeaderStyle"  scope="col" >Payment Mode</th>
				 <th class="GridViewHeaderStyle"  scope="col" >Paid Amt.</th>
                 <th class="GridViewHeaderStyle"  scope="col"   >Currency</th>
                 <th class="GridViewHeaderStyle"  scope="col"   >Base</th>
                 <th class="GridViewHeaderStyle clPaymentMode"  scope="col" style="display:none;">Transaction Id</th>	
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col"  style="display:none;">Cheque/Card No.</th>
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col" style="display:none;">Cheque/Card Date</th>
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col" style="display:none;">Bank Name</th>			 
				 </tr>
				 </thead>
				 <tbody></tbody>
				</table>
			</div>             
				<div class="col-md-3">
				</div>		         
			</div>           
             <div class="row" >
        <div class="col-md-3 ">
                               <input type="checkbox" id="chkRefund" onclick="ValidateAmount()" disabled="disabled" /><b>REFUND</b> 
            
			                  </div>
                 <div class="col-md-3 ">
                     <label class="pull-left">Remarks   </label>
			                   <b class="pull-right">:</b>
                               </div>                    
                <div class="col-md-10 ">
                <asp:TextBox ID="txtRemarks" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                    </div>                 
                </div>
           </div>
        <div class="POuter_Box_Inventory divPaymentControl"  style="display: none;" >
                 <div class="row" >
                     <div class="col-md-24 " style="text-align:center">
                          <input type="button" id="btnSave" value="Save" onclick="savedata()" tabindex="9" class="savebutton" />
                                <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" />
                         </div>
                 </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $getCurrencyDetails(function (baseCountryID) {

            });
        });
        var $getCurrencyDetails = function (callback) {
            var $ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/Services/CommonServices.asmx/LoadCurrencyDetail', {}, function (response) {
                var $responseData = JSON.parse(response);
                jQuery('#spnBaseCurrency').text($responseData.baseCurrency);
                jQuery('#spnBaseCountryID').text($responseData.baseCountryID);
                jQuery('#spnBaseNotation').text($responseData.baseNotation);
               

                jQuery($ddlCurrency).bindDropDown({
                    data: $responseData.currancyDetails, valueField: 'CountryID', textField: 'Currency', selectedValue: '<%= Resources.Resource.BaseCurrencyID%>', showDataValue: 1
                });
                callback($ddlCurrency.val());

               
            });
        }
    </script>
    <script type="text/javascript">

        var labno = '<%=labno%>';
        $(document).ready(function () {
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
        });
        function BindDoctor() {
            var ddlDoctor = $("#ddlReferDoc");
            var chkDoc = $("#chkDoctor");
            if (($('#chkDoctor').prop('checked') == true)) {
                $("#ddlReferDoc option").remove();
                ddlDoctor.append($("<option></option>").val("").html(""));
                serverCall('OPDRePrint.aspx/GetDoctorMaster', {}, function (response) {
                    ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'doctor_id', textField: 'name', isSearchAble: true });
                });
            }
            else {
                $('#ddlReferDoc option:nth-child(1)').attr('selected', 'selected')
                $("#ddlReferDoc option").remove();
                ddlDoctor.trigger('chosen:updated');
            }
        };
        function BindPanel() {
            var ddlDoctor = $("#ddlPanel");
            var chkDoc = $("#chkPanel");
            if (($('#chkPanel').prop('checked') == true)) {
                $("#chkPanel option").remove();
                ddlDoctor.append($("<option></option>").val("").html(""));
                serverCall('OPDRePrint.aspx/GetPanelMaster', {}, function (response) {
                    ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'panel_id', textField: 'company_name', isSearchAble: true });
                });
            }
            else {
                $("#ddlPanel option").remove();
                $('#ddlReferDoc option:nth-child(1)').attr('selected', 'selected')
                ddlDoctor.trigger('chosen:updated');
            }
        };
        function $getSearchData() {
            var dataPLO = new Object();
            dataPLO.SearchType = $('#ddlSearchType').val();
            dataPLO.LabNo = $('#txtLedgerTransactionNo').val();
            dataPLO.Centre = $('#ddlCentreAccess').val();
            dataPLO.Panel = $('#ddlPanel').val();
            dataPLO.ReferBy = $('#ddlReferDoc').val();
            dataPLO.FromDate = $('#txtFormDate').val();
            dataPLO.ToDate = $('#txtToDate').val();
            return dataPLO;

        }
        var testCount = 0; var totalamt = 0;
        function $searchData() {
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            var $searchResultData = $getSearchData();
            $('#tb_ItemList tr').slice(1).remove();
            testCount = 0;
            totalamt = 0;
            serverCall('OpdSettelment.aspx/SearchReceiptData', { searchdata: $searchResultData }, function (response) {
                var $TestData = JSON.parse(response);
                if ($TestData == "-1")
                {
                    toast("Error", "Time is expired . You cannot edit the Settelment..!", "");
                }
                 else if ($TestData.length > 0) {
                    jQuery('.divPaymentControl').hide();
                    for (var i = 0; i <= $TestData.length - 1; i++) {
                      
                        testCount = parseInt(testCount) + 1;
                        jQuery('#testCount').html(testCount);
                        totalamt = parseInt(totalamt) + $TestData[i].DueAmt;
                        jQuery('#amtCount').html(totalamt);
                        var $mydata = [];
                        $mydata.push("<tr id='");
                        $mydata.push($TestData[i].LabNo); $mydata.push("'");
                        $mydata.push(" style='background-color:");
                        $mydata.push($TestData[i].rowColor);
                        $mydata.push("'>");
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].EntryDate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"><b>'); $mydata.push($TestData[i].LabNo); $mydata.push('</b></td>');
                        $mydata.push('<td class="GridViewLabItemStyle"><b>'); $mydata.push($TestData[i].PName); $mydata.push('</b></td>');
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].CentreName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].PanelName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($TestData[i].DoctorName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].GrossAmount); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].DiscountOnTotal); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].NetAmount); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $mydata.push($TestData[i].Adjustment); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:right"> '); $mydata.push($TestData[i].DueAmt); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="text-align:center"> ');
                        if (parseFloat($TestData[i].DueAmt) != 0) {
                            $mydata.push('<img src="../../App_Images/Post.gif" style="cursor:pointer;" ');
                            $mydata.push(' onclick="settelnow(\'');
                            $mydata.push($TestData[i].LabNo); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].InvoiceNo); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].DueAmt); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].ItemName); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].LedgerTransactionID); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].patient_id); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].panel_id); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].centreid); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].mobile); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].type1ID); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].PName); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].OPDAdvanceAmount); $mydata.push("\',");
                            $mydata.push("\'"); $mydata.push($TestData[i].PanelCredit); $mydata.push("\')");
                            $mydata.push('">');
                        }
                        $mydata.push('</td></tr>');
                        $mydata = $mydata.join("");
                        jQuery('#tb_ItemList').append($mydata);
                        if (labno != "" && $TestData.length==1) {
                            settelnow($TestData[i].LabNo, $TestData[i].invoiceno, $TestData[i].DueAmt, $TestData[i].ItemName, $TestData[i].LedgerTransactionID, $TestData[i].patient_id, $TestData[i].panel_id, $TestData[i].centreid, $TestData[i].mobile, $TestData[i].type1ID,$TestData[i].PName, $TestData[i].OPDAdvanceAmount, $TestData[i].PanelCredit);
                        }
                    }
                }
                else {
                    toast("Error", "Record Not Found..!", "");
                }
                $modelUnBlockUI(function () { });
            });
        }
        function settelnow(labno1, invoiceno, DueAmt, ItemName, id, pid, panelid, centreid, mobile, type1ID,PName, OPDAdvanceAmount, PanelCredit) {
            //if (invoiceno != "") {
            //    toast("Error", 'Invoice is already generated settlement cannot be done. Invoice no. ' + invoiceno, "");
            //    return;
            //}
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            jQuery('.clPaymentMode').hide();
            jQuery('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "header" && id != labno1) {
                    $(this).hide();
                }
            });
            jQuery('#txtRemarks').val('');
            jQuery('.divPaymentControl').show();
            jQuery('#labNo').html(labno1);
            jQuery('#mobileno').html(mobile);
            jQuery('#centretypeid').html(type1ID);
            jQuery('#PName').html(PName);
            jQuery('#labID').html(id);
            jQuery('#spnPanelID').html(panelid);
            jQuery('#spnCentreID').html(centreid).attr('panel_ID', panelid);
            jQuery('#spnItemName').html(ItemName);


            jQuery('#spnAmount').val(DueAmt);

            jQuery('#txtPaidAmount,#txtCurrencyRound').val('0');
            var txtPID = $('#spnPatient_ID').html(pid);
            if (!String.isNullOrEmpty(pid))
                jQuery(txtPID).change();
            if (parseFloat(DueAmt) < 0) {
                jQuery('#chkRefund').prop('checked', true);
                jQuery('#txtAmount').val(Math.abs(DueAmt));
                jQuery('#txtBlanceAmount').val(Math.abs(DueAmt));
                jQuery('#txtDueAmount').val(Math.abs(DueAmt));
            }
            else {
                jQuery('#chkRefund').prop('checked', false);
                jQuery('#txtAmount').val(DueAmt);
                jQuery('#txtBlanceAmount').val(DueAmt);
                jQuery('#txtDueAmount').val(DueAmt);
            }
            if (DueAmt == 0) {
                jQuery('#btnSave').hide();
            }
            else {
                jQuery('#btnSave').show();
            }
            jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            var _temp = [];
            _temp.push(serverCall('../Common/Services/CommonServices.asmx/GetConversionFactor', { countryID: '<%=Resources.Resource.BaseCurrencyID%>' }, function (conversionFactor) {
                jQuery.when.apply(null, _temp).done(function () {
                    jQuery('#spnCFactor').text(conversionFactor);
                    jQuery('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round(conversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', $('#spnBaseNotation').text()));
                    $onChangeCurrency($("#ddlCurrency"), 0, function (response) {
                    });
                });
            }));
            _temp = [];
            _temp.push(serverCall('../Common/Services/CommonServices.asmx/getOPDBalanceAmt', { Patient_ID: $('#spnPatient_ID').html() }, function (OPDAdvanceAmount) {
                jQuery.when.apply(null, _temp).done(function () {
                    var txtPID = jQuery('#spnPatient_ID').html($('#spnPatient_ID').html()).attr('patientAdvanceAmount', OPDAdvanceAmount);
                    if (!String.isNullOrEmpty($('#spnPatient_ID').html()))
                        jQuery(txtPID).change();
                    $getPaymentMode("remove", function (callback) {
                    });
                });
            }));

        }
         var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
             var _temp = [];
             if ((Number($('#ddlCurrency').val()) == Number('<%=Resources.Resource.BaseCurrencyID%>')) && (parseFloat($('#spnPatient_ID').attr('patientAdvanceAmount')) > 0)) {
                 jQuery('input[type=checkbox][name=paymentMode][value=9]').attr('disabled', false);
            }
            else {
                 jQuery('input[type=checkbox][name=paymentMode][value=9]').prop('checked', false).attr('disabled', 'disabled');
            }
            if (calculateConversionFactor == 1) {

                // _temp.push(serverCall('../Common/Services/CommonServices.asmx/GetConversionFactor', { countryID: $('#ddlCurrency').val() }, function (CurrencyData) {
                //     $.when.apply(null, _temp).done(function () {
                var blanceAmount = $("#txtBlanceAmount").val();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                _temp = [];
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                    jQuery.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        jQuery('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        jQuery('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        jQuery('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        jQuery('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', $('#ddlCurrency option:selected').text()));
                        jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                        var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + $('#ddlCurrency').val());
                        jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                            $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + $(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                        });
                        callback(true);
                    })
                }));
                // });
                // }));
            }
            else {
                _temp = [];
                var blanceAmount = $("#txtBlanceAmount").val();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                    jQuery.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        jQuery('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        jQuery('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        jQuery('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', jQuery('#ddlCurrency option:selected').text()));
                        jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                        var selectedPaymentModeOnCurrency = $('#divPaymentDetails').find('.' + jQuery('#ddlCurrency').val());
                        jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {

                            jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                        });
                        callback(true);
                    })
                }));
            }
        }
        function clearForm() {
            jQuery('#spnItemName').html('');
            jQuery('#txtBlanceAmount,#txtDueAmount,#txtAmount,#txtPaidAmount').val('');
            jQuery('.divPaymentControl').hide();
            jQuery('#chkRefund').prop('checked', false);
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            jQuery('#tb_ItemList tr').each(function () {
                jQuery(this).show();
            });
        }
        function validation() {
            if (jQuery.trim(jQuery('#txtRemarks').val()) == "") {
                toast("Info", "Please Enter Remarks", "");
                jQuery("#txtRemarks").focus();
                return false;
            }
			
			var $cardNoValidate = 0; var $cardDateValidate = 0; var $bankValidate = 0; var $transactionidValidate = 0;var $transactionidID = 0;

            jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                if (jQuery(this).closest('tr').find("#tdPaymentMode").text() != 1) {
                    if (jQuery(this).closest('tr').find("#txtCardNo").val() == "") {
                        $cardNoValidate = 1;
                        jQuery(this).closest('tr').find("#txtCardNo").focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find("#txttransactionid").val() == "") {
                        $transactionidID = 1;
                        jQuery(this).closest('tr').find("#txttransactionid").focus();
                        return false;
                    }


                    if (jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').attr('id'))).val() == "") {
                        $cardDateValidate = 1;
                        jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').attr('id'))).focus();
                        return false;
                    }

                    if (jQuery(this).closest('tr').find(".bnk").val() == 0) {
                        $bankValidate = 1;
                        jQuery(this).closest('tr').find(".bnk").focus();
                        return false;
                    }

                }
            });
            if($transactionidID == 1) {
                toast("Error", "Please Enter Tansaction ID", "");
                return false;
            }
            if ($cardNoValidate == 1) {
                toast("Error", "Please Enter Card Detail", "");
                return false;
            }
            if ($cardDateValidate == 1) {
                toast("Error", "Please Enter Card Date Detail", "");
                return false;
            }
            if ($bankValidate == 1) {
                toast("Error", "Please Select Bank Name", "");
                return false;
            }
			
			
			
			
            return true
        }
        function savedata() {
            if (validation() == false)
                return;
            var $Rcdata = getsavedata();
            var $Patientdata = getpatientdata();
            serverCall('OpdSettelment.aspx/SaveSettlement', { Rcdata: $Rcdata, Patientdata: $Patientdata }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    clearForm();
                    confirmReceipt('Confirmation!', 'Do You Want to Print Receipt', $responseData);
                    $searchData();
                    toast("Success", "Record Saved Successfully", "");
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
            });
        }
        function getpatientdata() {
            var arrobj = new Array();
            var data = new Object();
            data.PName = jQuery('#PName').html();
            data.MobileNo = jQuery('#mobileno').html();
            data.CentreTypeID = jQuery('#centretypeid').html();
            arrobj.push(data);
            return arrobj;
        }
        function getsavedata() {
            var datarc = new Array();
            if (parseFloat($('#txtPaidAmount').val()) > 0) {
                $("#tblPaymentDetail").find('tbody tr').each(function () {
                    var $PatientPaidAmount = $(this).closest('tr').find('#txtPatientPaidAmount').val();
                    if (isNaN($PatientPaidAmount) || $PatientPaidAmount == "")
                        $PatientPaidAmount = 0;
                    if ($PatientPaidAmount > 0) {
                        var objRC = new Object();
                        objRC.PayBy = $('#ddlPayBy').val();
                        objRC.Patient_ID = $('#spnPatient_ID').html();
                        objRC.PaymentMode = $(this).closest('tr').find('#tdPaymentMode').text();
                        objRC.PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text();

                       
                        objRC.Amount = $('#chkRefund').is(':checked') ? (-1) * ($(this).closest('tr').find('#tdBaseCurrencyAmount').text()) : $(this).closest('tr').find('#tdBaseCurrencyAmount').text();
                       
                        objRC.BankName = String.isNullOrEmpty($(this).closest('tr').find('#tdBankName select').val()) ? '' : $(this).closest('tr').find('#tdBankName select').val();
                        objRC.CardNo = String.isNullOrEmpty($(this).closest('tr').find('#txtCardNo').val()) ? '' : $(this).closest('tr').find('#txtCardNo').val();
                        objRC.TransactionID = String.isNullOrEmpty($(this).closest('tr').find('#txttransactionid').val()) ? '' : $(this).closest('tr').find('#txttransactionid').val();
                        objRC.CardDate = String.isNullOrEmpty($(this).closest('tr').find("".concat('#txtCardDate_', $(this).closest('tr').find('#tdS_CountryID').text() + $(this).closest('tr').find('#tdPaymentModeID').text())).val()) ? '' : $(this).closest('tr').find("".concat('#txtCardDate_', $(this).closest('tr').find('#tdS_CountryID').text() + $(this).closest('tr').find('#tdPaymentModeID').text())).val();

                        objRC.S_Amount = $('#chkRefund').is(':checked') ? (-1) * ($(this).closest('tr').find('#txtPatientPaidAmount').val()) : $(this).closest('tr').find('#txtPatientPaidAmount').val();
                            
                        objRC.S_CountryID = $(this).closest('tr').find('#tdS_CountryID').text();
                        objRC.S_Currency = $(this).closest('tr').find('#tdS_Currency').text();
                        objRC.S_Notation = $(this).closest('tr').find('#tdS_Notation').text();
                        objRC.C_Factor = $(this).closest('tr').find('#tdC_Factor').text();
                        objRC.Currency_RoundOff = $('#txtCurrencyRound').val();
                        objRC.PayTmMobile = "";
                        objRC.PayTmOtp = "";
                        objRC.CentreID = $('#spnCentreID').html();
                        objRC.TIDNumber = "";
                        objRC.Panel_ID = $('#spnPanelID').html();
                        objRC.CurrencyRoundDigit = $(this).closest('tr').find('#tdCurrencyRound').text();
                        objRC.LedgerTransactionID = $('#labID').html();
                        objRC.LedgerTransactionNo = $('#labNo').html();
                        objRC.Naration = $.trim($('#txtRemarks').val());
                        objRC.Refund = $('#chkRefund').is(':checked') ? 1 : 0;
                        objRC.Converson_ID = $(this).closest('tr').find('#tdConverson_ID').text();

                        datarc.push(objRC);
                    }
                });
            }
            return datarc;
        }
    </script>
    <script type="text/javascript">
        var $onPaidAmountChanged = function (e) {
            var row = $(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
            var $paidAmount = Number(e.target.value);
            if ($PaymentModeID == "9" && parseFloat($paidAmount) > parseFloat($('#spnPatient_ID').attr('patientAdvanceAmount'))) {
                row.find('#txtPatientPaidAmount').val(0);
                $(row).find('#tdBaseCurrencyAmount').text(0);
                $paidAmount = 0;
            }
            $convertToBaseCurrency($countryID, $paidAmount, function (baseCurrencyAmount) {
                $(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount);
                $calculateTotalPaymentAmount(e, function () {
                });
            });
        }
        var $convertToBaseCurrency = function ($countryID, $amount, callback) {
            var baseCurrencyCountryID = Number($('#spnBaseCountryID').text());
            $amount = Number($amount);
            $amount = isNaN($amount) ? 0 : $amount;
            if (baseCurrencyCountryID == $countryID || $amount == 0) {
                callback($amount);
                return false;
            }
            try {
                serverCall('../Common/Services/CommonServices.asmx/ConvertCurrency', { countryID: $countryID, Amount: $amount }, function (response) {
                    callback(Number(response));
                });
            } catch (e) {
                callback(0);
            }
        }
        var $calculateTotalPaymentAmount = function (event, row, callback) {
            var $totalPaidAmount = 0;
            $('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
            var $netAmount = parseFloat($('#txtAmount').val());
            var $roundOffTotalPaidAmount = Math.round($totalPaidAmount);
            $('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
            if ($roundOffTotalPaidAmount > $netAmount) {
                if (event != null) {
                    var row = $(event.target).closest('tr');
                    var $targetBaseCurrencyAmountTd = row.find('#tdBaseCurrencyAmount');
                    var $tragetBaseCurrencyAmount = $.trim($targetBaseCurrencyAmountTd.text());
                    $('#txtPaidAmount').val(precise_round($totalPaidAmount - $tragetBaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                    $('#txtBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount - $tragetBaseCurrencyAmount)), '<%=Resources.Resource.BaseCurrencyRound%>'));
                    $targetBaseCurrencyAmountTd.text(0);
                    row.find('#txtPatientPaidAmount').val(0);
                }
            }
            else {
                $('#txtPaidAmount').val(precise_round($totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                $('#txtBlanceAmount').val(precise_round(parseFloat($('#txtAmount').val()) - parseFloat($('#txtPaidAmount').val()), '<%=Resources.Resource.BaseCurrencyRound%>'));
            }
            var $blanceAmount = $("#txtBlanceAmount").val();
            if (isNaN($blanceAmount) || $blanceAmount == "")
                $blanceAmount = 0;
            var $currencyRound = 0;
            $blanceAmount = parseFloat($blanceAmount) + precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');
            $currencyRound = precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');

            var $currencyRoundValue = parseFloat($('#txtPaidAmount').val()) + parseFloat($currencyRound);

            if ($blanceAmount < 1)
                $('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
            else
                $('#txtCurrencyRound').val('0');
            $onChangeCurrency($("#ddlCurrency"), 0, function (response) {
            });
        };
        var $paymentModeCache = [];
        var $bindPaymentMode = function (callback) {
            serverCall('../Common/Services/CommonServices.asmx/bindPaymentMode', {}, function (response) {
                $paymentModeCache = JSON.parse(response);
                callback($paymentModeCache);
            });
        }
        $getPaymentMode = function (con, callback) {
            $("#divPaymentMode").html('');
            $bindPaymentMode(function (response) {
                paymentModes = $.extend(true, [], response);
                if (paymentModes.length > 0) {
                    paymentModes.patientAdvanceAmount = Number($('#spnPatient_ID').attr('patientAdvanceAmount'));
                    var patientAdvancePaymentModeIndex = paymentModes.map(function (item) { return item.PaymentModeID; }).indexOf(9);
                    if (patientAdvancePaymentModeIndex > -1) {
                        if (paymentModes.patientAdvanceAmount < 1)
                            paymentModes.splice(patientAdvancePaymentModeIndex, 1);
                        else
                            paymentModes[patientAdvancePaymentModeIndex].PaymentMode = paymentModes[patientAdvancePaymentModeIndex].PaymentMode + '(' + paymentModes.patientAdvanceAmount + ')';
                    }
                    var responseData = $('#scPaymentModes').parseTemplate(paymentModes);
                    $('#divPaymentMode').html(responseData);
                    $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', true);
                    $validatePaymentModes(1, 'Cash', Number($('#txtAmount').val()), $('#ddlCurrency'), function (response) {
                        $bindPaymentDetails(response, function (response) {
                            $bindPaymentModeDetails($('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', true), response, function (data) {
                            });
                        });
                    });
                }
            });
            $("#divPaymentDetails,.isReciptsBool,.divOutstanding,.isReciptsBool1,.clPaidAmt").show();
            $(".isReciptsBool").css("height", 84);
            $("#tblPaymentDetail").tableHeadFixer({
            });
            $("#divPaymentMode").show();
        };
        var $validatePaymentModes = function ($PaymentModeID, $PaymentMode, $billAmount, $ddlCurrency, callback) {

            var $totalPaidAmount = 0;
            $('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number($(this).text()); });
            var data = {
                currentSelectedPaymentMode: Number($PaymentModeID),
                totalSelectedPaymentModes: $('#tdPaymentModes input[type=checkbox]:checked'),
                billAmount: $billAmount,
                totalPaidAmount: $totalPaidAmount,
                defaultPaidAmount: 0,
                patientAdvanceAmount: Number($('#spnPatient_ID').attr('patientAdvanceAmount')),
                roundOffAmount: Number($('#txtControlRoundOff').val()),
                currentCurrencyName: $.trim($($ddlCurrency).find('option:selected').text()),
                currentCurrencyNotation: $.trim($($ddlCurrency).find('option:selected').text()),
                baseCurrencyName: $.trim($('#spnBaseCurrency').text()),
                baseCurrencyNotation: $.trim($('#spnBaseNotation').text()),
                currencyFactor: Number($('#spnCFactor').text()),
                paymentMode: $.trim($PaymentMode),
                PaymentModeID: Number($PaymentModeID),
                currencyID: Number($ddlCurrency.val()),
                currencyRound: $($ddlCurrency).find('option:selected').data("value").Round,
                Converson_ID: Number($('#spnConversion_ID').text()),
                isInBaseCurrency: false
            }
            if (data.baseCurrencyNotation.toLowerCase() == data.currentCurrencyNotation.toLowerCase())
                data.isInBaseCurrency = true;
            callback(data);
        }
        var $bindPaymentDetails = function (data, callback) {
            $payment = {};
            $payment.billAmount = data.billAmount;
            $payment.$paymentDetails = [];
            $payment.$paymentDetails = {
                Amount: data.defaultPaidAmount,
                BaceCurrency: data.baseCurrencyName,
                BankName: '',
                C_Factor: data.currencyFactor,
                PaymentMode: data.paymentMode,
                PaymentModeID: data.PaymentModeID,
                PaymentRemarks: '',
                RefNo: '',
                S_Amount: 0,
                baseCurrencyAmount: data.defaultPaidAmount,
                S_CountryID: data.currencyID,
                S_Currency: data.currentCurrencyName,
                S_Notation: data.currentCurrencyName,
                currencyRound: data.currencyRound,
                Converson_ID: data.Converson_ID,               
            };
            callback($payment);
        }
        var $bindPaymentModeDetails = function (IsShowDetail, data, callback) {
            //if (con == "remove") {
            //    $('#tblPaymentDetail tr').slice(1).remove();
            //    $('.clPaymentMode').hide();
            //}
            var $patientAdvancePaymentModeID = [9];
            var $disableBankDetailPaymentModeID = [1, 4, 9];
            if ($patientAdvancePaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                maxInputValue = data.patientAdvanceAmount;
            var $temp = []; var maxInputValue = 100000000;
            $temp.push('<tr class="');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1) {
                $temp.push($.trim(data.$paymentDetails.S_CountryID));
            }
            else {
                $temp.push('clShowDetail ');
                $temp.push($.trim(data.$paymentDetails.S_CountryID));
            }
            $temp.push('"');
            $temp.push(' id="'); $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('">');
            $temp.push('<td id="tdPaymentMode" class="GridViewLabItemStyle ');
            $temp.push($.trim(data.$paymentDetails.PaymentMode.split('(')[0]));
            $temp.push('"');
            $temp.push('style="width:100px">');
            $temp.push($.trim(data.$paymentDetails.PaymentMode.split('(')[0])); $temp.push('</td>');
            $temp.push('<td id="tdAmount" class="GridViewLabItemStyle" style="width:100px">');
            $temp.push('<input type="text" onlynumber="10" decimalplace="');
            $temp.push(data.$paymentDetails.currencyRound); $temp.push('"');
            $temp.push('max-value="');
            $temp.push(maxInputValue); $temp.push('"');
            $temp.push(' value="'); $temp.push(data.$paymentDetails.Amount); $temp.push('"');
            $temp.push(' autocomplete="off" id="txtPatientPaidAmount" class="ItDoseTextinputNum requiredField" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onPaidAmountChanged(event);" /></td>');
            $temp.push('<td id="tdS_Currency" class="GridViewLabItemStyle">');
            $temp.push(data.$paymentDetails.S_Currency); $temp.push('</td>');
            $temp.push('<td id="tdBaseCurrencyAmount" class="GridViewLabItemStyle"  style="text-align:right">');
            $temp.push(data.$paymentDetails.baseCurrencyAmount); $temp.push('</td>');


            $temp.push('<td id="tdTransaction" class="GridViewLabItemStyle" ');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                $temp.push(' style="display:none" >');
            else {
                $temp.push('>');
                $('.clPaymentMode').show();
            }
            $temp.push(($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<input type="text" autocomplete="off" class="requiredField" id="txttransactionid" />')); $temp.push('</td>');

            $temp.push('<td id="tdCardNo" class="GridViewLabItemStyle" ');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                $temp.push(' style="display:none" >');
            else {
                $temp.push('>');
                $('.clPaymentMode').show();
            }
            $temp.push(($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<input type="text" autocomplete="off" class="requiredField" id="txtCardNo" />')); $temp.push('</td>');
            $temp.push('<td id="tdCardDate" class="GridViewLabItemStyle" ');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                $temp.push(' style="display:none" >');
            else
                $temp.push('>');
            $temp.push($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<input type="text" autocomplete="off" readonly  class="setCardDate requiredField" id="txtCardDate_');
            $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('"/>');
            $temp.push('</td>');
            $temp.push('<td id="tdBankName" class="GridViewLabItemStyle" ');
            if ($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                $temp.push(' style="display:none" >');
            else
                $temp.push('>');
            $temp.push(($disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<select class="bnk requiredField" style="padding: 0px;"></select>')); $temp.push('</td>');
            $temp.push('<td id="tdPaymentModeID" style="display:none">'); $temp.push(data.$paymentDetails.PaymentModeID); $temp.push('</td>');
            $temp.push('<td id="tdBaceCurrency" style="display:none">'); $temp.push(data.$paymentDetails.BaceCurrency); $temp.push('</td>');
            $temp.push('<td id="tdS_CountryID" style="display:none">'); $temp.push(data.$paymentDetails.S_CountryID); $temp.push('</td>');
            $temp.push('<td id="tdS_Notation" style="display:none">'); $temp.push(data.$paymentDetails.S_Notation); $temp.push('</td>');
            $temp.push('<td id="tdS_Amount" style="display:none">'); $temp.push(data.$paymentDetails.S_Amount); $temp.push('</td>');
            $temp.push('<td id="tdC_Factor" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.C_Factor); $temp.push('</td>');
            $temp.push('<td id="tdCurrencyRound" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.currencyRound); $temp.push('</td>');
            $temp.push('<td id="tdConverson_ID" style="display:none" class="GridViewLabItemStyle">'); $temp.push(data.$paymentDetails.Converson_ID); $temp.push('</td>');

            $temp.push('</tr>');
            $temp = $temp.join("");
            $('#tblPaymentDetail tbody').append($temp);
            $('#tblPaymentDetail tbody tr').find("".concat('#txtCardDate_', data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID)).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0",
                onSelect: function (dateText) {
                    $('#tblPaymentDetail tbody tr').find("".concat('#txtCardDate_', data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID)).val(dateText);
                }
            });
            var bankControl = $('#divPaymentDetails table tbody tr:last-child').find('.bnk');
            callback({ bankControl: bankControl, IsOnlineBankShow: IsShowDetail.data('isonlinebankshow') });
        }
        $onPaymentModeChange = function (elem, ddlCurrency, callback) {
            if (elem.checked == false) {
                $('#divPaymentDetails').find('#' + parseInt(parseInt(ddlCurrency.val()) + parseInt(elem.value))).remove();
                if ($(".clShowDetail").length == 0)
                    $('.clPaymentMode').hide();
                else
                    $('.clPaymentMode').show();
                $calculateTotalPaymentAmount(function () { });
                return;
            }
            $validatePaymentModes(elem.value, $(elem).next('b').text(), Number($('#txtAmount').val()), $('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails(jQuery(elem), response, function (data) {
                        $bindBankMaster(data.bankControl, data.IsOnlineBankShow, function () {
                            $calculateTotalPaymentAmount(function () { });
                        });
                    });
                });
            });
        }
        var $bindBankMaster = function (bankControls, IsOnlineBankShow, callback) {
            $getBankMaster(function (response) {
                response = jQuery.grep(response, function (value) {
                    return value.IsOnlineBank == IsOnlineBankShow;
                });
                $(bankControls).bindDropDown({ data: response, valueField: 'BankName', textField: 'BankName', defaultValue: '', selectedValue: '' });
                callback(true);
            });
        }
        var $bankMaster = [];
        var $getBankMaster = function (callback) {
            if ($bankMaster.length < 1) {
                serverCall('../Common/Services/CommonServices.asmx/getBankMaster', {}, function (response) {
                    $bankMaster = JSON.parse(response);
                    callback($bankMaster);
                });
            }
            else
                callback($bankMaster);
        }
    </script>
            <script id="scPaymentModes" type="text/html">  
		<#
		var dataLength=paymentModes.length;
        var patientAdvancePaymentModeID=[9];

        var objRow;   
        for(var j=0;j<dataLength;j++)
        {
            objRow = paymentModes[j];
		  #>
					<div class="ellipsis" style="float:left">
					<input type="checkbox"   name="paymentMode" data-IsOnlineBankShow='<#=objRow.IsOnlineBankShow#>' onchange="$onPaymentModeChange(this,$('#ddlCurrency'),function(){});"  value='<#=objRow.PaymentModeID#>'  />
                        <b  <#=(patientAdvancePaymentModeID.indexOf(objRow.PaymentModeID)>-1?"class='patientInfo'":'' ) #> > <#= objRow.PaymentMode  #> </b>
					
					</div>
			<#}#>       
</script>
    <script type="text/javascript">
        function confirmReceipt(title, content, $responseData) {
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
                            PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
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

        function ValidateAmount()
        {
            if ($('#chkRefund').prop('checked', true))
            {
                $('#txtAmount').val(Math.abs($('#txtAmount').val()));
                $('#txtBlanceAmount').val(Math.abs($('#txtBlanceAmount').val()));
                $('#txtDueAmount').val(Math.abs($('#txtDueAmount').val()));
            }
        }

    </script>
</asp:Content>

