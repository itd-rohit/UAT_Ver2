<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MemberShipCardIssue.aspx.cs" Inherits="Design_Membershipcard_MemberShipCardIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
   
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
    <script type="text/javascript" src="../../Scripts/InvalidContactNo.js"></script>
   
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Membership Card Issue</b>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2 ">
                    <label class="pull-left">Select Card  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4 ">
                    <asp:DropDownList ID="ddlcard" runat="server" onchange="$getCardDetail()" CssClass="ddlcard chosen-select chosen-container" />
                </div>
                <div class="col-md-2 ">
                    <label class="pull-left">Card Amount </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-1 ">
                    <span id="spcardamount" style="color: blue;"></span>
                </div>
                
                <div class="col-md-3 " >
                    <label class="pull-left">No. of Dependant </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1 ">
                    <span id="spnodependant" style="color: blue;"></span>
                </div>

                <div class="col-md-2 ">
                    <label class="pull-left">Expiry Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 ">
                    <span id="spexpirydate" style="color: blue;"></span>
                </div>
                <div class="col-md-4 ">
                    <input type="button" onclick="showdetail()" value="View Test" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 ">
                    <%  if (Resources.Resource.MemberShipCardNoAutoGenerate == "0")
                        {%>
                    <label class="pull-left">
                        Card No. 
                    </label>
                    <b class="pull-right">:</b><%}%>
                </div>
                <div class="col-md-4 ">
                    <input type="text" id="txtmembershipcard" placeholder="Enter Membership Card" maxlength="20"
                        <%  if (Resources.Resource.MemberShipCardNoAutoGenerate == "1")
                            {%>
                        style="display: none;" value=""
                        <%}%> />
                </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Primary Member
            </div>
             <div class="row" style="margin-top: 0px;">
					
	     <div class="row">
                <div class="col-md-2 ">
                    <label class="pull-left">Mobile No.  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <input id="txtMobileNo" onkeyup="previewCountDigit(event,function(e){$patientSearchOnEnter(e)});" onblur="$patientSearchOnEnter(event);"  type="text" class="requiredField" onlynumber="10" autocomplete="off" data-title="Enter Contact No. (Press Enter To Search)"/>

                </div>
                <div class="col-md-2 ">
                    <label class="pull-left">UHID  </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5 ">
                    <input id="txtUHID" autocomplete="off" type="text" patientAdvanceAmount="0"/>
                    <input id="txtUHIDOLD" style="display: none;" />
                </div>
                <div class="col-md-2 ">
                    Upload Photo
                </div>
                <div class="col-md-6 ">
                    <input type="file" id="fileupload" />
                </div>
                <div class="col-md-2 ">&nbsp; </div>
            </div>
             <div class="row">
                <div class="col-md-2 ">
                    <label class="pull-left">Patient Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 ">
                     <select id="ddlTitle" class="ddlTitle" onchange="$onTitleChange(this.value)" ></select>
                     </div>
                    <div class="col-md-3 ">
                    <input type="text" id="txtPName" class="requiredField checkSpecialCharater" autocomplete="off" style="text-transform: uppercase; " onlytext="50" maxlength="50" data-title="Enter Patient Name" />

                    </div>
                 <div class="col-md-2 ">
                      <label class="pull-left">Age <asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setAgeMain(this)" GroupName="rdDOB" /> </label>
                    <b class="pull-right">:</b>
                     </div>
                  <div class="col-md-5 ">
                      <input type="text" id="txtAge" style="width:33%; float: left" onkeyup="$clearDateOfBirth(event);$getdob();" onlynumber="5" class="requiredField" max-value="120" autocomplete="off" maxlength="3" data-title="Enter Age" placeholder="Years" />
                      <input type="text" id="txtAge1" style="width:33%; float: left" onkeyup="$clearDateOfBirth(event);$getdob();" onlynumber="5" class="requiredField" max-value="12" autocomplete="off" maxlength="2" data-title="Enter Age" placeholder="Months" />
                      <input type="text" id="txtAge2" style="width:33%; float: left" onkeyup="$clearDateOfBirth(event);$getdob();" onlynumber="5" class="requiredField" max-value="30" autocomplete="off" maxlength="2" data-title="Enter Age" placeholder="Days" />

                      </div>
                 <div class="col-md-2 ">
                      <label class="pull-left">DOB <asp:RadioButton ID="rdDOB" runat="server" GroupName="rdDOB" onclick="setDOBMain(this)" /> </label>
                    <b class="pull-right">:</b>
                     </div>
                   <div class="col-md-3 ">
                                             <asp:TextBox ID="txtDOB" ReadOnly="true" ClientIDMode="Static" runat="server" Width="126px" Enabled="false" onkeyup="getAgeNew( $('#txtdob').val())"></asp:TextBox>
                         </div>
                  <div class="col-md-2 ">
                      <label class="pull-left"> Gender</label>
                    <b class="pull-right">:</b>
                      </div>
                  <div class="col-md-3 ">
                       <select id="ddlGender">
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Trans">Transgender</option>
                        <option value=""></option>
                    </select>
                      </div>
                 
                  
        </div>
      
                 </div>
        <div class="Purchaseheader">
            Dependant Member
        </div>

        <table id="tbldependent" style="width: 99%; border-collapse: collapse; text-align: left;">
            <tr id="trh">
                <td class="GridViewHeaderStyle" style="width: 30px;">S.No.</td>
                <td class="GridViewHeaderStyle" style="width: 120px;">Mobile</td>
                <td class="GridViewHeaderStyle" style="width: 120px;">UHID</td>
                <td class="GridViewHeaderStyle" style="width: 270px;">Patient Name</td>
                <td class="GridViewHeaderStyle" style="width: 10px;">&nbsp;</td>
                <td class="GridViewHeaderStyle" style="width: 170px;">Age</td>
                <td class="GridViewHeaderStyle" style="width:10px;">&nbsp;</td>
                <td class="GridViewHeaderStyle" style="width:100px;">DOB</td>
                <td class="GridViewHeaderStyle" style="width: 100px;">Gender</td>
                <td class="GridViewHeaderStyle" style="width: 100px;">Relation</td>
                <td class="GridViewHeaderStyle" style="width: 60px;">Photo</td>
            </tr>
        </table>
    </div>
        <div class="POuter_Box_Inventory" id="divPaymentControl" runat="server">
            <div style="margin-top: 0px;" class="row">
		    <div class="col-md-12 ">
             <div class="row">
				<div  class="col-md-5">
					 <label class="pull-left">Currency</label>
					 <b class="pull-right">:</b>
				</div>
				<div class="col-md-4">
                    <select onchange="$onChangeCurrency(this,'1',function(){});" id="ddlCurrency">
					</select>
                    <span id="spnBaseCurrency" style="display:none"></span>
	              <span id="spnBaseCountryID" style="display:none"></span>
	              <span id="spnBaseNotation" style="display:none"></span>
	              <span id="spnCFactor" style="display:none"></span> <span id="spnConversion_ID" style="display:none"></span>   <span id="spnControlPatientAdvanceAmount" style="display:none">0</span>           

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
				<div  class="col-md-5">
					 <label class="pull-left">PaymentMode</label>
					 <b class="pull-right">:</b>
				</div>
				<div  id="divPaymentMode"  style="padding-right:100px" class="col-md-19"></div>
			</div>
                 <div style="display:none;overflow-y: auto; overflow-x: hidden" class="row isReciptsBool1">
				<div id="divPaymentDetails" class="col-md-24 isReciptsBool" style="overflow-y: auto; overflow-x: hidden">
				<table  class="GridViewStyle cltblPaymentDetail" border="1" id="tblPaymentDetail" rules="all" style="border-collapse:collapse;">
				 <thead>
				 <tr id="trPayment">
				 <th class="GridViewHeaderStyle"  scope="col" >Payment Mode</th>
				 <th class="GridViewHeaderStyle"  scope="col" >Paid Amt.</th>
                 <th class="GridViewHeaderStyle"  scope="col"   >Currency</th>
                 <th class="GridViewHeaderStyle"  scope="col"   >Base</th>
				 <th class="GridViewHeaderStyle clHeaderChequeNo"  scope="col"  style="display:none;">Cheque/Card No.</th>
				 <th class="GridViewHeaderStyle clHeaderChequeDate" scope="col" style="display:none;">Cheque/Card Date</th>
				 <th class="GridViewHeaderStyle clHeaderBankName"  scope="col" style="display:none;">Bank Name</th>			 
				 </tr>
				 </thead>
				 <tbody></tbody>
				</table>
			</div>             
			</div>
            </div>
<div class="col-md-12">
    <div class="row" >
                  <div class="col-md-5">
				   <label class="pull-left">Gross Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                   <input disabled="disabled" id="txtGrossAmount" class="ItDoseTextinputNum"  value="0" autocomplete="off"  type="text"  />
				</div>
				 <div class="col-md-5">
				   <label class="pull-left">Net Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
					<input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold;color:#09f" value="0" id="txtNetAmount"  type="text" autocomplete="off"  />
				</div>	
                <div class="col-md-5 clPaidAmt">
				   <label class="pull-left">Paid Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3 clPaidAmt">
                    <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtPaidAmount" type="text"  autocomplete="off" />
				</div>			
			</div>	
    <div class="row">				
				<div class="col-md-5">
				 <label class="pull-left">Balance Amount</label>
                    <b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
					  <input  type="text" class="ItDoseTextinputNum" style="font-weight:Bold"  value="0"  id="txtBlanceAmount" autocomplete="off" disabled="disabled"  />
				</div>			             
				<div class="col-md-5" >
				 <label class="pull-left">Currency Round</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3" >
                  <input  type="text" class="ItDoseTextinputNum" style="font-weight:Bold"  value="0"  id="txtCurrencyRound" autocomplete="off" disabled="disabled"  />                             
				</div>
                   <div class="col-md-5 clpaybypanel">
				   <label class="pull-left"></label>
								<b class="pull-right"></b>
				</div>
				<div class="col-md-3 clpaybypanel">
                   
				</div>
				<%--<div class="col-md-8" >				                    
				</div>	--%>						                          		  
            </div>  	
    </div>
 </div>
             </div>   
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <input type="button" value="Save" onclick="$saveMembershipData()" id="btnSave" />
        &nbsp;&nbsp;&nbsp;
                <input type="button" value="Cancel" onclick="$clearall()" />
    </div>
    </div>
     <div id="divCardDetail" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 66%;max-width:50%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title"><b><span id="spnPopupCard"></span></b> Card Test Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCardDetailModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body" >
                <div style="height:200px"  class="row">
					<div id="divCardDetailData" class="col-md-24" style="max-height: 440px; overflow: auto; width: 860px;">
                        <table id="tblMemberShipItemDetail" style="width: 99%; border-collapse: collapse; text-align: left;">
                            <thead>
                            <tr id="trItemDetail">
                                <td class="GridViewHeaderStyle" style="width: 50px;">S.No.</td>
                                <td class="GridViewHeaderStyle" style="width: 150px;">Department</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">Test Code</td>
                                <td class="GridViewHeaderStyle" style="width: 480px;">Test Name</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">SelfDisc</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">DependentDisc</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">SelfFreeTestCount</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">DependentFreeTestCount</td>
                            </tr>
                                </thead>
							<tbody></tbody>
                        </table>
					</div>
				</div>
                </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeCardDetailModel()">Close</button>
			</div>

            </div>
        </div>
         </div>


            <div id="oldPatientModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 54%;max-width:50%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Old Patient Search</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body" >
			    <div class="row clMoreFilter"  style="display:none" >
					 <div  class="col-md-3">
						  <label class="pull-left">  Mobile No.    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
                         <input type="text" onlynumber="10" id="txtSerachModelContactNo" />						  
					 </div>
					 <div  class="col-md-3">
						   <label class="pull-left"> UHID   </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						 <input type="text" id="txtSearchModelMrNO" />
					 </div>
                     <div  class="col-md-3">
						  <label class="pull-left">Name</label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						   <input type="text" onlytext="50" id="txtSearchModelName" />
					 </div>
				 </div>
			    <div class="row clMoreFilter"  style="display:none" >			 
					 <div  class="col-md-3">
						   <label class="pull-left">Country</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						    <select id="ddlSearchModelCountry" onchange="$onCountryModelChange(this.value)"></select>
					 </div>
                      <div  class="col-md-3">
						   <label class="pull-left">State</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						    <select id="ddlSearchModelState" onchange="$onStateModelChange(this.value)"></select>
					 </div>
                      <div  class="col-md-3">
						   <label class="pull-left">City</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						    <select id="ddlSearchModelCity" onchange="$onCityModelChange(this.value)"></select>
					 </div>
				 </div>
				<div class="row clMoreFilter" style="display:none" >
					 <div  class="col-md-3">
						  <label class="pull-left">Locality</label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
                         <select id="ddlSearchModelLocality"></select>
						   					 </div>
					 <div  class="col-md-3">
						   <label class="pull-left">From Date</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
                         <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true"  ToolTip="Select Date of Registration" ></asp:TextBox>
						   <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 

						 					 </div>
                     <div  class="col-md-3">
						   <label class="pull-left">To Date</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">	
                          <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true"   ToolTip="Select Date of Registration" ></asp:TextBox>
						  <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					   
					 </div>
				 </div>
				<div style="text-align:center;display:none" class="row clMoreFilter">                    
					   <button type="button"  onclick="$searchOldPatientDetail()">Search</button>
				</div>
				<div style="height:200px"  class="row">
					<div id="divSearchModelPatientSearchResults" class="col-md-24">
					</div>
				</div>
			</div>
			<div class="modal-footer">				
				<button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
			</div>
		</div>
	</div>
</div>

   
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
					<input type="checkbox" data-IsBankShow='<#=objRow.IsBankShow#>' data-IsChequeNoShow='<#=objRow.IsChequeNoShow#>' data-IsChequeDateShow='<#=objRow.IsChequeDateShow#>' data-IsOnlineBankShow='<#=objRow.IsOnlineBankShow#>' name="paymentMode" onchange="$onPaymentModeChange(this,jQuery('#ddlCurrency'),function(){});"  value='<#=objRow.PaymentModeID#>'  />
                        <b  <#=(patientAdvancePaymentModeID.indexOf(objRow.PaymentModeID)>-1?"class='patientInfo'":'' ) #> > <#= objRow.PaymentMode  #> </b>
					
					</div>
			<#}#>       
</script>
    <script type="text/javascript">
        var $clearDateOfBirth = function (e) {
            var $inputValue = (e.which) ? e.which : e.keyCode;
            if ($inputValue == 46 || $inputValue == 8) {
                jQuery(e.target).val('');
                jQuery('#txtDOB').val('').prop('disabled', false);
            }
        }
        var $getdob = function (birthDate) {
            var $age = "";
            var $ageyear = "0";
            var $agemonth = "0";
            var $ageday = "0";
            if (jQuery('#txtAge').val() != "") {
                if (jQuery('#txtAge').val() > 110) {
                    toast("Error", "Please Enter Valid Age in Years", "");
                    jQuery('#txtAge').val('');
                }
                $ageyear = jQuery('#txtAge').val();
            }
            if (jQuery('#txtAge1').val() != "") {
                if (jQuery('#txtAge1').val() > 12) {
                    toast("Error", "Please Enter Valid Age in Months", "");
                    jQuery('#txtAge1').val('');
                }
                $agemonth = jQuery('#txtAge1').val();

            }
            if (jQuery('#txtAge2').val() != "") {
                if (jQuery('#txtAge2').val() > 30) {
                    toast("Error", "Please Enter Valid Age in Days", "");
                    jQuery('#txtAge2').val('');
                }
                $ageday = jQuery('#txtAge2').val();
            }
            var d = new Date(); // today!
            if ($ageday != "")
                d.setDate(d.getDate() - $ageday);
            if ($agemonth != "")
                d.setMonth(d.getMonth() - $agemonth);
            if ($ageyear != "")
                d.setFullYear(d.getFullYear() - $ageyear);
            var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            jQuery('#txtDOB').val(xxx);
           
        }
        $bindDOB = function () {
            jQuery("#txtDOB").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var $today = new Date();
                    var $dob = value;
                    getAge($dob, $today);
                }
            });
           

        }
        function getAge(birthDate, ageAtDate) {
            var $daysInMonth = 30.436875; // Days in a month on average.
            // var dob = new Date(birthDate);
            //shat 05.10.17
            var $dateSplit = birthDate.split("-");
            var $dob = new Date($dateSplit[1] + " " + $dateSplit[0] + ", " + $dateSplit[2]);
            //
            var aad;
            if (!ageAtDate) aad = new Date();
            else aad = new Date(ageAtDate);
            var $yearAad = aad.getFullYear();
            var $yearDob = $dob.getFullYear();
            var $years = $yearAad - $yearDob; // Get age in years.
            $dob.setFullYear($yearAad); // Set birthday for this year.
            var $aadMillis = aad.getTime();
            var $dobMillis = $dob.getTime();
            if ($aadMillis < $dobMillis) {
                --$years;
                $dob.setFullYear($yearAad - 1); // Set to previous year's birthday
                $dobMillis = $dob.getTime();
            }
            var $days = ($aadMillis - $dobMillis) / 86400000;
            var $monthsDec = $days / $daysInMonth; // Months with remainder.
            var $months = Math.floor($monthsDec); // Remove fraction from month.
            $days = Math.floor($daysInMonth * ($monthsDec - $months));
            jQuery('#txtAge').val($years);
            jQuery('#txtAge1').val($months);
            jQuery('#txtAge2').val($days);

        }
        minTwoDigits = function (n) {
            return (n < 10 ? '0' : '') + n;
        }
        setAgeMain = function (ctrl) {
            if (jQuery(ctrl).is(':checked')) {
                jQuery('#txtDOB').attr("disabled", true);
                jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);
                jQuery('#txtDOB').removeClass('requiredField');
                jQuery('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
            }
        }
        setDOBMain = function (ctrl) {
            if (jQuery(ctrl).is(':checked')) {
                jQuery('#txtDOB').attr("disabled", false);
                jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", true);
                jQuery('#txtDOB').addClass('requiredField');
                jQuery('#txtAge,#txtAge1,#txtAge2').removeClass('requiredField');
            }
        }
        function getDOBDept(row) {


            jQuery("#txtDOB_" + row).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    //  var dob = new Date(value);
                    var dob = value;
                    getAgeDept(dob, today, row);
                }
            });
        }
        function getAgeDept(birthDate, ageAtDate, row) {
            var daysInMonth = 30.436875; // Days in a month on average.
            // var dob = new Date(birthDate);
            //shat 05.10.17
            var dateSplit = birthDate.split("-");
            var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
            //
            var aad;
            if (!ageAtDate) aad = new Date();
            else aad = new Date(ageAtDate);
            var yearAad = aad.getFullYear();
            var yearDob = dob.getFullYear();
            var years = yearAad - yearDob; // Get age in years.
            dob.setFullYear(yearAad); // Set birthday for this year.
            var aadMillis = aad.getTime();
            var dobMillis = dob.getTime();
            if (aadMillis < dobMillis) {
                --years;
                dob.setFullYear(yearAad - 1); // Set to previous year's birthday
                dobMillis = dob.getTime();
            }
            var days = (aadMillis - dobMillis) / 86400000;
            var monthsDec = days / daysInMonth; // Months with remainder.
            var months = Math.floor(monthsDec); // Remove fraction from month.
            days = Math.floor(daysInMonth * (monthsDec - months));
            jQuery("#txtAge_" + row).val(years);
            jQuery("#txtAge1_" + row).val(months);
            jQuery("#txtAge2_" + row).val(days);

        }
        function setAge(ctrl, row) {

            if (jQuery('#rdoAge_' + row).is(':checked')) {
                jQuery("#txtDOB_" + row).attr("disabled", true);
                jQuery("#txtAge_" + row).attr("disabled", false);
                jQuery("#txtAge1_" + row).attr("disabled", false);
                jQuery("#txtAge2_" + row).attr("disabled", false);
            }
        }
        function setDOB(ctrl, row) {
            if (jQuery('#rdoDOB_' + row).is(':checked')) {
                jQuery('#txtDOB_' + row).attr("disabled", false);
                jQuery("#txtAge_" + row).attr("disabled", true);
                jQuery("#txtAge1_" + row).attr("disabled", true);
                jQuery("#txtAge2_" + row).attr("disabled", true);


            }
        }
        jQuery(function () {
            $bindDOB();
            $getCurrencyDetails(function (baseCountryID) {
                $getPaymentMode("0", function () {
                $getConversionFactor(baseCountryID, function (CurrencyData) {
                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));

                       });
                    });
            });
            });
        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            var _temp = [];
            if ((Number(jQuery('#ddlCurrency').val()) == Number('<%=Resources.Resource.BaseCurrencyID%>')) && (parseFloat(jQuery('#txtUHIDNo').attr('patientAdvanceAmount')) > 0)) {
                jQuery('input[type=checkbox][name=paymentMode][value=9]').attr('disabled', false);
            }
            else {
                jQuery('input[type=checkbox][name=paymentMode][value=9]').prop('checked', false).attr('disabled', 'disabled');
            }
            var blanceAmount = jQuery("#txtBlanceAmount").val();
            var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
            _temp = [];
            _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: jQuery('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $convertedCurrencyData = JSON.parse(CurrencyData);
                    jQuery('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, jQuery('#ddlCurrency option:selected').data("value").Round), ' ', jQuery('#spnBaseNotation').text()));
                    jQuery('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', jQuery('#ddlCurrency option:selected').text()));
                    jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                    var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + jQuery('#ddlCurrency').val());
                    jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                        jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                    });
                    callback(true);
                })
            }));
        }
        var $getCurrencyDetails = function (callback) {
            var $ddlCurrency = jQuery('#ddlCurrency');
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
        var $getConversionFactor = function ($countryID, callback) {
            serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $countryID, Amount: 0 }, function (response) {
                callback(JSON.parse(response));
            });
        }
        var $paymentModeCache = [];
        var $bindPaymentMode = function (callback) {            
            if ($paymentModeCache.length > 0)
                callback($paymentModeCache);
            else {
                serverCall('../Common/Services/CommonServices.asmx/bindPaymentMode', {}, function (response) {
                    $paymentModeCache = JSON.parse(response);
                    callback($paymentModeCache);
                }, '', 0);
            }
        }
        $getPaymentMode = function (con, callback) {                         
            if (con == 0) {
                //  jQuery("#divPaymentMode").html('');
                $bindPaymentMode(function (response) {
                    paymentModes = jQuery.extend(true, [], response);
                    if (paymentModes.length > 0) {
                        paymentModes.patientAdvanceAmount = Number(jQuery('#txtUHID').attr('patientAdvanceAmount'));
                        var patientAdvancePaymentModeIndex = paymentModes.map(function (item) { return item.PaymentModeID; }).indexOf(9);
                        if (patientAdvancePaymentModeIndex > -1) {
                            if (paymentModes.patientAdvanceAmount < 1)
                                paymentModes.splice(patientAdvancePaymentModeIndex, 1);
                            else
                                paymentModes[patientAdvancePaymentModeIndex].PaymentMode = paymentModes[patientAdvancePaymentModeIndex].PaymentMode + '(' + paymentModes.patientAdvanceAmount + ')';
                        }
                        var $responseData = jQuery('#scPaymentModes').parseTemplate(paymentModes);
                        jQuery('#divPaymentMode').html($responseData);
                        jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', true);
                        $validatePaymentModes(1, 'Cash', Number(jQuery('#txtNetAmount').val()), jQuery('#ddlCurrency'), function (response) {
                            $bindPaymentDetails(response, function (response) {
                                $bindPaymentModeDetails(jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode]:checked'), response, function (data) {

                                });
                            });
                        });
                    }
                });
            }
            else {
                
                jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
                jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode]').prop('checked', false);
                jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', 'checked');
                $validatePaymentModes(1, 'Cash', Number(jQuery('#txtNetAmount').val()), jQuery('#ddlCurrency'), function (response) {
                    $bindPaymentDetails(response, function (response) {
                        $bindPaymentModeDetails(jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode]:checked'), response, function (data) {
                        });
                    });
                });
            }
            jQuery("#divPaymentDetails,.isReciptsBool,.isReciptsBool1,.clPaidAmt").show();
            jQuery(".isReciptsBool").css("height", 84);
            jQuery("#txtAmountGiven").val('');
            jQuery("#tblPaymentDetail").tableHeadFixer({
            });
                
               
            
        };
        var $onPaidAmountChanged = function (e) {
            var row = jQuery(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
            var $paidAmount = Number(e.target.value);
            if (isNaN($paidAmount) || $paidAmount == "")
                $paidAmount = 0;
            if ($PaymentModeID == "9" && parseFloat($paidAmount) > parseFloat(jQuery('#txtUHIDNo').attr('patientAdvanceAmount'))) {
                row.find('#txtPatientPaidAmount').val(0);
                jQuery(row).find('#tdBaseCurrencyAmount').text(0);
                $paidAmount = 0;
            }
            $convertToBaseCurrency($countryID, $paidAmount, function (baseCurrencyAmount) {
                jQuery(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount.SellingCurrencyAmount);
                $calculateTotalPaymentAmount(e, function () {
                });
                if (jQuery(e.target).closest('tr').find("#tdPaymentMode").text() == "Cash" || jQuery("#ddlPanel").val().split('#')[20] == "1") {
                    var $amountGiven = jQuery("#txtAmountGiven").val();
                    if (isNaN($amountGiven) || $amountGiven == "")
                        $amountGiven = 0;
                    if ($amountGiven > 0)
                        $renderAmt();
                }
            });
        }
        var $convertToBaseCurrency = function ($countryID, $paidAmount, callback) {
            var baseCurrencyCountryID = Number(jQuery('#spnBaseCountryID').text());
            $paidAmount = Number($paidAmount);
            $paidAmount = isNaN($paidAmount) ? 0 : $paidAmount;
            if (baseCurrencyCountryID == $countryID) {
                var data = {
                    BaseCurrencyAmount: $paidAmount,
                    ConversionFactor: jQuery('#spnCFactor').text(),
                    Converson_ID: jQuery('#spnConversion_ID').text(),
                    SellingCurrencyAmount: $paidAmount
                }
                callback(data);
                return false;
            }
            try {
                serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $countryID, Amount: $paidAmount }, function (CurrencyData) {
                    callback(JSON.parse(CurrencyData));
                });
            } catch (e) {
                callback(0);
            }
        }
        $onPaymentModeChange = function (elem, ddlCurrency, callback) {
            if (elem.checked == false) {
                jQuery('#divPaymentDetails').find('#' + parseInt(parseInt(ddlCurrency.val()) + parseInt(elem.value))).remove();

                if (jQuery(".clChequeNo").length == 0)
                    jQuery('.clHeaderChequeNo').hide();
                else
                    jQuery('.clHeaderChequeNo').show();
                if (jQuery(".clChequeDate").length == 0)
                    jQuery('.clHeaderChequeDate').hide();
                else
                    jQuery('.clHeaderChequeDate').show();
                if (jQuery(".clBankName").length == 0)
                    jQuery('.clHeaderBankName').hide();
                else
                    jQuery('.clHeaderBankName').show();
                if (jQuery('#tblPaymentDetail tr').hasClass('Cash'))
                    jQuery("#txtAmountGiven").removeAttr('disabled', 'disabled');
                else {
                    jQuery("#txtAmountGiven").val('');
                    jQuery("#txtAmountGiven").attr('disabled', 'disabled');
                }
                //var $paidAmount = 0;
                //jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                //    $paidAmount = $paidAmount + Number(jQuery(this).closest('tr').find('#txtPatientPaidAmount').val());
                //});
                //jQuery("#txtPaidAmount").val($paidAmount);
                //var $due = parseInt(jQuery('#txtNetAmount').val()) - parseInt($paidAmount);
                //jQuery('#txtBlanceAmount').val($due);

                $calculateTotalPaymentAmount(function () { });
                return;
            }
            $validatePaymentModes(elem.value, jQuery(elem).next('b').text(), Number(jQuery('#txtNetAmount').val()), jQuery('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails(jQuery(elem), response, function (data) {
                        $bindBankMaster(data.bankControl, data.IsOnlineBankShow, function () {
                            $calculateTotalPaymentAmount(function () { });
                        });
                    });
                });
            });
        }
        var $calculateTotalPaymentAmount = function (event, row, callback) {
            var $totalPaidAmount = 0;
            jQuery('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
            var $netAmount =  parseFloat(jQuery('#txtNetAmount').val());
            var $roundOffTotalPaidAmount = Math.round($totalPaidAmount);
            if ($roundOffTotalPaidAmount > $netAmount) {
                if (event != null) {
                    var row = jQuery(event.target).closest('tr');
                    var $targetBaseCurrencyAmountTd = row.find('#tdBaseCurrencyAmount');
                    var $tragetBaseCurrencyAmount = jQuery.trim($targetBaseCurrencyAmountTd.text());
                    jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount - $tragetBaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                    jQuery('#txtBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount - $tragetBaseCurrencyAmount)), '<%=Resources.Resource.BaseCurrencyRound%>'));
                    $targetBaseCurrencyAmountTd.text(0);
                    row.find('#txtPatientPaidAmount').val(0);
                }
            }
            else {
                jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                jQuery('#txtBlanceAmount').val(precise_round(parseFloat(jQuery('#txtNetAmount').val()) - parseFloat(jQuery('#txtPaidAmount').val()), '<%=Resources.Resource.BaseCurrencyRound%>'));
            }
             var $blanceAmount = jQuery("#txtBlanceAmount").val();
             if (isNaN($blanceAmount) || $blanceAmount == "")
                 $blanceAmount = 0;
             var $currencyRound = 0;
             $blanceAmount = parseFloat($blanceAmount) + precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');
            $currencyRound = precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>');
             var $currencyRoundValue = parseFloat(jQuery('#txtPaidAmount').val()) + parseFloat($currencyRound);
             if ($blanceAmount < 1)
                 jQuery('#txtCurrencyRound').val(precise_round($roundOffTotalPaidAmount - $totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
            else
                jQuery('#txtCurrencyRound').val('0');
             $onChangeCurrency(jQuery("#ddlCurrency"), 0, function (response) {
             });
         };
        var $validatePaymentModes = function ($PaymentModeID, $PaymentMode, $billAmount, $ddlCurrency, callback) {
            var $totalPaidAmount = 0;
            jQuery('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(jQuery(this).text()); });
            var data = {
                currentSelectedPaymentMode: Number($PaymentModeID),
                totalSelectedPaymentModes: jQuery('#tdPaymentModes input[type=checkbox]:checked'),
                billAmount: $billAmount,
                totalPaidAmount: $totalPaidAmount,
                defaultPaidAmount: 0,
                patientAdvanceAmount: Number(jQuery('#txtUHIDNo').attr('patientAdvanceAmount')),
                roundOffAmount: Number(jQuery('#txtControlRoundOff').val()),
                currentCurrencyName: jQuery.trim(jQuery($ddlCurrency).find('option:selected').text()),
                currentCurrencyNotation: jQuery.trim(jQuery($ddlCurrency).find('option:selected').text()),
                baseCurrencyName: jQuery.trim(jQuery('#spnBaseCurrency').text()),
                baseCurrencyNotation: jQuery.trim(jQuery('#spnBaseNotation').text()),
                currencyFactor: Number(jQuery('#spnCFactor').text()),
                paymentMode: jQuery.trim($PaymentMode),
                PaymentModeID: Number($PaymentModeID),
                currencyID: Number($ddlCurrency.val()),
                currencyRound: jQuery($ddlCurrency).find('option:selected').data("value").Round,
                Converson_ID: Number(jQuery('#spnConversion_ID').text()),
                isInBaseCurrency: false
            }
            if (data.baseCurrencyNotation.toLowerCase() == data.currentCurrencyNotation.toLowerCase())
                data.isInBaseCurrency = true;
            callback(data);
        }
        var $bindBankMaster = function (bankControls, IsOnlineBankShow, callback) {
            $getBankMaster(function (response) {
                response = jQuery.grep(response, function (value) {
                    return value.IsOnlineBank == IsOnlineBankShow;
                });
                jQuery(bankControls).bindDropDown({ data: response, valueField: 'BankName', textField: 'BankName', defaultValue: '', selectedValue: '', showDataValue: '1' });
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
            var $patientAdvancePaymentModeID = [9];
            if ($patientAdvancePaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
                maxInputValue = data.patientAdvanceAmount;
            var $temp = []; var maxInputValue = 100000000;
            $temp.push('<tr class="');

            $temp.push(jQuery.trim(data.$paymentDetails.S_CountryID));
            $temp.push('"');
            $temp.push(' id="'); $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('">');
            $temp.push('<td id="tdPaymentMode" class="GridViewLabItemStyle ');
            $temp.push(jQuery.trim(data.$paymentDetails.PaymentMode.split('(')[0]));
            $temp.push('"');
            $temp.push('style="width:100px">');
            $temp.push(jQuery.trim(data.$paymentDetails.PaymentMode.split('(')[0])); $temp.push('</td>');
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

            if (IsShowDetail.data('ischequenoshow') == 1)
                jQuery('.clHeaderChequeNo').show();
            $temp.push('<td id="tdCardNo" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('ischequenoshow') == 0 ? '"style="display:none">' : ' clChequeNo">');
            $temp.push(IsShowDetail.data('ischequenoshow') == 0 ? '' : '<input type="text" autocomplete="off" class="requiredField" id="txtCardNo" />');
            $temp.push('</td>');

            if (IsShowDetail.data('ischequedateshow') == 1)
                jQuery('.clHeaderChequeDate').show();
            $temp.push('<td id="tdCardDate" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('ischequedateshow') == 0 ? '"style="display:none">' : ' clChequeDate">');
            $temp.push(IsShowDetail.data('ischequedateshow') == 0 ? '' : '<input type="text" autocomplete="off" readonly  class="setCardDate requiredField" id="txtCardDate_');
            $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('"/>');
            $temp.push('</td>');

            if (IsShowDetail.data('isbankshow') == 1)
                jQuery('.clHeaderBankName').show();
            $temp.push('<td id="tdBankName" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('isbankshow') == 0 ? '"style="display:none">' : ' clBankName">');
            $temp.push(IsShowDetail.data('isbankshow') == 0 ? '' : '<select class="bnk requiredField" style="padding: 0px;"></select>');
            $temp.push('</td>');

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
            jQuery('#tblPaymentDetail tbody').append($temp);
            jQuery('#tblPaymentDetail tbody tr').find("".concat('#txtCardDate_', data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID)).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0",
                onSelect: function (dateText) {
                    jQuery('#tblPaymentDetail tbody tr').find("".concat('#txtCardDate_', data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID)).val(dateText);
                }
            });
            var bankControl = jQuery('#divPaymentDetails table tbody tr:last-child').find('.bnk');
            callback({ bankControl: bankControl, IsOnlineBankShow: IsShowDetail.data('isonlinebankshow') });
            if (jQuery('#tblPaymentDetail tr').hasClass('Cash'))
                jQuery("#txtAmountGiven").removeAttr('disabled', 'disabled');
            else {
                jQuery("#txtAmountGiven").val('');
                jQuery("#txtAmountGiven").attr('disabled', 'disabled');
            }
        }
    </script>
            <script id="tb_OldPatient" type="text/html">
	<table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse :collapse;">
		<thead>  
			 <tr id="Header"> 
					<th class="GridViewHeaderStyle" scope="col">Select</th>
					<th class="GridViewHeaderStyle" scope="col">UHID</th> 
					<th class="GridViewHeaderStyle" scope="col">Patient Name</th> 
					<th class="GridViewHeaderStyle" scope="col">Age</th> 
					<th class="GridViewHeaderStyle" scope="col">DOB</th>
					<th class="GridViewHeaderStyle" scope="col">Gender</th> 
					<th class="GridViewHeaderStyle" scope="col">Mobile</th> 
					<th class="GridViewHeaderStyle" scope="col">Reg. Date</th> 					
			 </tr>
		</thead>
		<tbody>
		<#     		 
			  var dataLength=OldPatient.length;
		if(_EndIndex>dataLength)
			{           
			   _EndIndex=dataLength;
			}
		for(var j=_StartIndex;j<_EndIndex;j++)
			{           
            $PNameMob[j] = OldPatient[j].PName;
            
	   var objRow = OldPatient[j];
		#>              
						<tr onmouseover="this.style.color='#00F'"  class="trOldPatient"  onMouseOut="this.style.color=''" id="<#=j+1#>"  style='cursor:pointer;'>                          
                          
                         
                                              
						<td class="GridViewLabItemStyle">
					   <a  class="btn" onclick="$onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
						  Select						   
					   </a>
                            <span data-title='Click to Select'  ></span>                
						</td>  
                                                                                                  
						<td  class="GridViewLabItemStyle" id="tdPatient_ID"  ><#=objRow.Patient_ID#></td>
						<td class="GridViewLabItemStyle" id="tdPName" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PName#></td>
						<td class="GridViewLabItemStyle" id="tdAge" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.age#></td>
						<td class="GridViewLabItemStyle" id="tdDOB"  ><#=objRow.dob#></td>
						<td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.gender#></td>
						<td class="GridViewLabItemStyle" id="tdMobile" ><#=objRow.mobile#></td>
						<td class="GridViewLabItemStyle" id="tdvisitdate" ><#=objRow.visitDate#></td>   						
                        <td class="GridViewLabItemStyle" id="tdAgeYear" style="display:none" ><#=objRow.ageYear#></td>
                        <td class="GridViewLabItemStyle" id="tdAgeMonth" style="display:none" ><#=objRow.ageMonth#></td>
                        <td class="GridViewLabItemStyle" id="tdAgeDays" style="display:none" ><#=objRow.ageDays#></td>
                        <td class="GridViewLabItemStyle" id="tdEmail" style="display:none" ><#=objRow.email#></td>
                        <td class="GridViewLabItemStyle" id="tdTitle" style="display:none" ><#=objRow.title#></td>
                        <td class="GridViewLabItemStyle" id="tddtEntry" style="display:none" ><#=objRow.dtEntry#></td>
                        
                        <td class="GridViewLabItemStyle" id="tdPatientAdvance" style="display:none" ><#=objRow.OPDAdvanceAmount#></td>
                        <td class="GridViewLabItemStyle" id="tdvip" style="display:none" ><#=objRow.VIP#></td>
						</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
            <# if(_PageCount>1) {#>
	 <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
	   <tr>
   <# if(_PageCount>1) {
	 for(var j=0;j<_PageCount;j++){ #>
	 <td class="GridViewLabItemStyle" style="width:8px;"><a  class="btn"   href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
	 <#}         
   }
#>
	 </tr>     
	 </table>  
            <#}
#>
	</script>
    <script type="text/javascript">      
        var $onPatientSelect = function (elem) {
            if (DependentSNo == 0) {
                $('#tbldependent tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trh") {
                        var ss = $(this).closest('tr').find('#srnn').text();
                        if ($('#txtUHIDOLD_' + ss).val() == $(elem).closest("tr").find('#tdPatient_ID').text()) {
                            c = 1;
                            return;
                        }
                    }
                });
                if (c == 1) {
                    jQuery('#oldPatientModel').hideModel();
                    jQuery('#tablePatient tr').remove();
                    toast("Error", "Same Patient Selected In Dependant List", "");
                    return;
                }
                jQuery("#txtMobileNo").val(jQuery(elem).closest('tr').find('#tdMobile').text()).attr('disabled', 'disabled');

                jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == jQuery(elem).closest('tr').find('#tdTitle').text() })[0]).prop('selected', true).attr('disabled', 'disabled');
               // $onTitleChange(jQuery('#ddlTitle').val());

                jQuery("#ddlGender").val(jQuery(elem).closest('tr').find('#tdGender').text()).attr('disabled', 'disabled');
                jQuery("#txtPName").val(jQuery(elem).closest('tr').find('#tdPName').text()).attr('disabled', 'disabled');
                jQuery("#txtDOB").val(jQuery(elem).closest('tr').find('#tdDOB').text());
                jQuery("#txtUHID").val(jQuery(elem).closest('tr').find('#tdPatient_ID').text()).attr('disabled', 'disabled');
                jQuery("#txtUHIDOLD").val(jQuery(elem).closest('tr').find('#tdPatient_ID').text()).attr('disabled', 'disabled');

                var txtPID = jQuery('#txtUHIDNo').val(jQuery(elem).closest('tr').find('#tdPatient_ID').text()).attr('patientAdvanceAmount', jQuery(elem).closest('tr').find('#tdPatientAdvance').text());
                if (!String.isNullOrEmpty(jQuery(elem).closest('tr').find('#tdPatient_ID').text()))
                    jQuery(txtPID).change();

                jQuery("#txtAge").val(jQuery(elem).closest('tr').find('#tdAgeYear').text());
                jQuery("#txtAge1").val(jQuery(elem).closest('tr').find('#tdAgeMonth').text());
                jQuery("#txtAge2").val(jQuery(elem).closest('tr').find('#tdAgeDays').text());

               
                jQuery('#oldPatientModel').hideModel();
                jQuery('#tablePatient tr').remove();
                var $today = new Date();
                var $dob = jQuery(elem).closest('tr').find('#tdDOB').text();
                getAge($dob, $today);
            }
            else {
                if ($('#txtUHID').val() == $(elem).closest("tr").find('#tdPatient_ID').text()) {
                    jQuery('#oldPatientModel').hideModel();
                    jQuery('#tablePatient tr').remove();
                    toast("Error", "Same Patient Selected As Primary Member","");
                    return;
                }
                var c = 0;
                $('#tbldependent tr').each(function () {
                    var id = $(this).closest("tr").attr("id");tdPatient_ID
                    if (id != "trh") {
                        var ss = $(this).closest('tr').find('#srnn').text();
                        if ($('#txtUHIDOLD_' + ss).val() == $(elem).closest("tr").find('#tdPatient_ID').text()) {
                            c = 1;
                            return;
                        }
                    }
                });
                if (c == 1) {
                    jQuery('#oldPatientModel').hideModel();
                    jQuery('#tablePatient tr').remove();
                    toast("Error", "Same Patient Selected In Dependant List","");
                    return;
                }
                jQuery("#txtMobileNo_" + DependentSNo).val(jQuery(elem).closest('tr').find('#tdMobile').text()).attr('disabled', 'disabled');
                $('#txtUHID_' + DependentSNo).val($(elem).closest("tr").find('#tdPatient_ID').text()).prop('disabled', true);
                $('#txtUHIDOLD_' + DependentSNo).val($(elem).closest("tr").find('#tdPatient_ID').text());                            
                $("#ddlTitle_" + DependentSNo + " option:contains(" + $(elem).closest("tr").find('#tdTitle').text() + ")").attr('selected', 'selected');                            
                $('#ddlGender_' + DependentSNo).val(jQuery(elem).closest('tr').find('#tdGender').text()).attr('disabled', 'disabled');
                jQuery("#txtDOB_" + DependentSNo).val(jQuery(elem).closest('tr').find('#tdDOB').text());
                $('#txtPName_' + DependentSNo).val(jQuery(elem).closest('tr').find('#tdPName').text()).attr('disabled', 'disabled');
                $('#txtAge_' + DependentSNo).val(jQuery(elem).closest('tr').find('#tdAgeYear').text());
                $('#txtAge1_' + DependentSNo).val(jQuery(elem).closest('tr').find('#tdAgeMonth').text());
                $('#txtAge2_' + DependentSNo).val(jQuery(elem).closest('tr').find('#tdAgeDays').text());
                jQuery('#oldPatientModel').hideModel();
                jQuery('#tablePatient tr').remove();
            }           
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            jQuery('#oldPatientModel').showModel();
            var outputPatient = jQuery('#tb_OldPatient').parseTemplate(OldPatient);
            jQuery('#divSearchModelPatientSearchResults').html(outputPatient);
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
        }
        var $getOldPatientDetails = function (data, url, callback) {
            serverCall(url, data, function (response) {
                callback(response);
            });
        }
        function $patientSearchOnEnterDept(ctrl,event) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
            }
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            var keyCode = ('which' in event) ? event.which : event.keyCode;
            var id = $(ctrl).closest('tr').find('#srnn').text();
            if ($(ctrl).val().length == 10 && keyCode == 13) {
                $bindoldpatient($(ctrl).val(), '0', 'Mobile', id);
            }
        }
        function $bindoldpatient(searchvalue, type, setype, id) {
            DependentSNo = id;
            $('#tablePatient tr').slice(1).remove();
            $modelBlockUI();
            var data = { MobileNo: '', Patient_ID: '', PName: '', FromRegDate: '', ToRegDate: '', MemberShipCardNo: '' };
            if (setype == "UHID") {              
               data.Patient_ID = searchvalue;
            }
            else {
                data.MobileNo = searchvalue;
            }          
            $getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatient', function (response) {
                jQuery('#tablePatient tr').remove();
                if (!String.isNullOrEmpty(response)) {
                    var $resultData = JSON.parse(response);
                    if ($resultData.length > 0) {
                        $bindOldPatientDetailsContact(response, id);
                        jQuery('#txtPName').focus()
                    }
                    else {
                        toast('Info', 'No Record Found', '');
                    }
                }
                else {
                    toast('Info', 'No Record Found', '');
                }
            });           
        }      
        var OldPatientDetails = "";
        var $PNameMob = [];
        var $patientSearchOnEnter = function (e) {
            DependentSNo = 0;
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13 || code == 9 || (e.target.id === 'txtMobileNo' && e.target.value.length === 10)) {
                var data = { MobileNo: '', Patient_ID: '', PName: '', FromRegDate: '', ToRegDate: '', MemberShipCardNo: '' };
                if (e.target.id == 'txtMobileNo') {
                    if (e.target.value.length < 10) {
                        toast('Info', 'Invalid Mobile No.', '');
                        return;
                    }
                    if ($.inArray(jQuery("#txtMobileNo").val(), invalidContact) != -1) {
                        toast('Info', 'Invalid Mobile No.', '');
                        return;
                    }
                    data.MobileNo = e.target.value;
                }
                if (e.target.id == 'txtUHIDNo') {
                    if (e.target.value.length == 0) {
                        toast('Info', 'Invalid UHID No.', '');
                        return;
                    }
                    data.Patient_ID = e.target.value;
                }               
                $PNameMob.length = 0;
                jQuery('.clMoreFilter').hide();
                if (jQuery('#tablePatient').find('tr:not(#Header)').length == 0) {
                    $getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatient', function (response) {
                        jQuery('#tablePatient tr').remove();
                        if (!String.isNullOrEmpty(response)) {
                            var $resultData = JSON.parse(response);
                            if ($resultData.length > 0) {
                                $bindOldPatientDetailsContact(response,0);
                                jQuery('#txtPName').focus()
                            }
                            else {
                                toast('Info', 'No Record Found', '');
                            }
                        }
                        else {
                            toast('Info', 'No Record Found', '');
                        }
                    });
                }
            }
        }
        var _PageNo = 0;
        var _PageSize = 6;
        $closeOldPatientSearchModel = function () {
            jQuery('#oldPatientModel').hideModel();
            jQuery('#tablePatient tr').remove();
        }
        var DependentSNo = 0;
        var $bindOldPatientDetailsContact = function (data, ID) {
            
            if (!String.isNullOrEmpty(data)) {
                OldPatient = JSON.parse(data);
                var isPageBind = 0;
                if (OldPatient != null) {
                    _PageCount = OldPatient.length / _PageSize;
                    if (isPageBind == 0) {
                        showPage(0);
                        isPageBind = 1;
                    }
                }
                else
                    jQuery('#divSearchModelPatientSearchResults').html('');
            }
            else
                jQuery('#divSearchModelPatientSearchResults').html('');
        }
        jQuery(function () {
            $bindTitle(function () { });         
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
            $(".setmydate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0"
            });
        });
        var $bindTitle = function (callback) {
            var $ddlTitle = jQuery('.ddlTitle');
            titleWithGenderData(function ($responseData) {
                var options = [];
                for (var i = 0; i < $responseData.length; i++) {
                    options.push('<option value="');
                    options.push($responseData[i].Gender);
                    options.push('">');
                    options.push($responseData[i].Title);
                    options.push('</option>');
                }
                $ddlTitle.append(options.join(""));
            });
            jQuery('#ddlGender').attr('disabled', 'disabled');
            callback($ddlTitle.val());
        }
        var $bindDeptTitle = function (callback) {
            var $ddlTitle = jQuery('.ddlTitleDept');
            titleWithGenderData(function ($responseData) {
                var options = [];
                for (var i = 0; i < $responseData.length; i++) {
                    options.push('<option value="');
                    options.push($responseData[i].Gender);
                    options.push('">');
                    options.push($responseData[i].Title);
                    options.push('</option>');
                }
                $ddlTitle.append(options.join(""));
            });            
            callback($ddlTitle.val());
        }     
        var $bindDeptRelation = function (callback) {
            var $ddlDeptRelation = jQuery('.ddlDeptRelation');
            var options = [];
            var $dependentRelation = new Array("Select","Father", "Mother", "Husband", "Wife", "Son", "Daughter", "Relative", "Uncle", "Aunty", "Sister", "Brother", "Spouse");
            for (var i = 0; i < $dependentRelation.length; i++) {
                    options.push('<option value="');
                    options.push($dependentRelation[i]);
                    options.push('">');
                    options.push($dependentRelation[i]);
                    options.push('</option>');
                }
            $ddlDeptRelation.append(options.join(""));
            callback($ddlDeptRelation.val());
        }
        var $onTitleChange = function (gender) {
            var $gender = jQuery('#ddlGender').val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                jQuery('#ddlGender').val("").prop('disabled', false);
            }
            else {
                jQuery('#ddlGender').val(gender).prop('disabled', true);
            }
        }
        var $onTitleChangenew = function (gender, id) {
            var $gender = jQuery('#ddlGender_' + id).val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                jQuery('#ddlGender_' + id).val("").prop('disabled', false);
            }
            else {
                jQuery('#ddlGender_' + id).val(gender).prop('disabled', true);
            }
        }
        function $getCardDetail() {
            $clearControl();
            if ($('#ddlcard').val() != "0") {
                serverCall('MemberShipCardIssue.aspx/getCardDetail', { cardID: $('#ddlcard').val() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        var CardDetails = jQuery.parseJSON($responseData.response);
                        $('#spcardamount').html(Math.round($('#ddlcard').val().split('#')[4]));
                    
                        $('#spnodependant').html($('#ddlcard').val().split('#')[1]);
                        $('#spexpirydate').html($('#ddlcard').val().split('#')[3]);
                        $('#txtGrossAmount,#txtNetAmount,#txtBlanceAmount').val(Math.round($('#ddlcard').val().split('#')[4]));
                        $('#txtPaidAmount').val(0);
                        $('#txtDueAmount').val(0);                                           
                        for (var a = 1; a <= Number($('#spnodependant').html()) ; a++) {
                            var $Tr = [];
                            $Tr.push('<tr style="background-color:lightgreen;" class="GridViewItemStyle">');
                            $Tr.push('<td  align="left" id="srnn">'); $Tr.push(parseFloat(a)); $Tr.push('</td>');
                            $Tr.push('<td  align="left"> <input  id="txtMobileNo_'); $Tr.push(a); $Tr.push('" maxlength="10" onkeyup="$patientSearchOnEnterDept(this,event);"   style="width:120px;" /> </td>');
                            $Tr.push('<td  align="left"> <input  id="txtUHID_'); $Tr.push(a); $Tr.push('" onkeyup="$patientSearchOnEnterDept(this,event);" style="width:120px;"  />  <input id="txtUHIDOLD_'); $Tr.push(a); $Tr.push('"  style="display:none;" />  </td>');
                            $Tr.push('<td  align="left"> <select id="ddlTitle_'); $Tr.push(a); $Tr.push('"  class="ddlTitleDept" onchange="$onTitleChangenew(this.value,'); $Tr.push(a); $Tr.push(')" style="width:60px;"></select>');
                            $Tr.push('<input type="text" id="txtPName_'); $Tr.push(a); $Tr.push('"  class="requiredField checkSpecialCharater" autocomplete="off"  style="text-transform:uppercase;width:190px;"  onlyText="50" maxlength="50"  data-title="Enter Patient Name" /></td>');

                            $Tr.push('<td align="left"><input type="radio"  checked="checked" name="DeptAge_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' onclick="setAge(this,'); $Tr.push(a); $Tr.push(')"'); $Tr.push('id="rdoAge_'); $Tr.push(a); $Tr.push('"/> </td>'); $Tr.push('<td><input type="text"  id="txtAge_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' onkeyUp="getdobDept(this,'); $Tr.push(a); $Tr.push(')"'); $Tr.push(' style="width:50px;float:left" onlynumber="5"  max-value="120"  autocomplete="off"  maxlength="3"    placeholder="Years"/><input type="text" id="txtAge1_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' onkeyUp="getdobDept(this,'); $Tr.push(a); $Tr.push(')"'); $Tr.push(' style="width:60px;float:left" onlynumber="5"   max-value="12"  autocomplete="off"  maxlength="2"  placeholder="Months"/><input type="text" id="txtAge2_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' onkeyUp="getdobDept(this,'); $Tr.push(a); $Tr.push(')"'); $Tr.push(' style="width:50px;float:left"  onlynumber="5"  max-value="30"  autocomplete="off"  maxlength="2"   placeholder="Days"/></td>');
                            $Tr.push('<td align="left"><input type="radio"  name="DeptAge_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' onclick="setDOB(this,'); $Tr.push(a); $Tr.push(')"'); $Tr.push('id="rdoDOB_'); $Tr.push(a); $Tr.push('"/> </td>'); $Tr.push('<td><input type="text" class="txtdobDept" disabled="disabled" id="txtDOB_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' style="width:100px;float:left" onlynumber="5"  maxlength="11" autocomplete="off" "/></td>');
                            $Tr.push('<td><select id="ddlGender_'); $Tr.push(a); $Tr.push('"'); $Tr.push(' disabled><option value="Male">Male</option><option value="Female">Female</option><option value="Trans">Transgender</option><option value=""></option></select></td>');
                            $Tr.push('<td><select class="ddlDeptRelation" id="ddlrelation_'); $Tr.push(a); $Tr.push('">');
                            //$Tr.push(' <option value="0">Select</option><option value="Father">Father</option>  <option value="Mother">Mother</option>  <option value="Husband">Husband</option>  <option value="Wife">Wife</option>  <option value="Son">Son</option>  <option value="Daughter">Daughter</option>  <option value="Relative">Relative</option>  <option value="Uncle">Uncle</option>  <option value="Aunty">Aunty</option>  <option value="Sister">Sister</option>  <option value="Brother">Brother</option>  <option value="Spouse">Spouse</option></select> ');
                            $Tr.push('</td>');



                           $Tr.push('<td> <input type="file" id="fileupload_'); +$Tr.push(a); $Tr.push('" /></td>');

                            $Tr = $Tr.join("");
                            jQuery("#tbldependent").append($Tr);
                            getDOBDept(a);
                        }
                       $bindSpecialCharater()
            
                        $bindDeptTitle(function () { });
                        $bindDeptRelation(function () { });
                        $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
                        for (var i = 0; i <= CardDetails.length - 1; i++) {
                            var $Tr = [];
                            $Tr.push('<tr class="GridViewItemStyle">');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:left">'); $Tr.push(parseFloat(i + 1)); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:left">'); $Tr.push(CardDetails[i].deptname); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:left">'); $Tr.push(CardDetails[i].TestCode); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:left">'); $Tr.push(CardDetails[i].ItemName); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:right">'); $Tr.push(CardDetails[i].SelfDisc); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:right">'); $Tr.push(CardDetails[i].DependentDisc); $Tr.push('</td>');

                            $Tr.push('<td class="GridViewItemStyle" style="text-align:right">'); $Tr.push(CardDetails[i].SelfFreeTestCount); $Tr.push('</td>');
                            $Tr.push('<td class="GridViewItemStyle" style="text-align:right">'); $Tr.push(CardDetails[i].DependentFreeTestCount); $Tr.push('</td>');
                            $Tr.push('</tr>');
                            $Tr = $Tr.join("");
                            jQuery("#tblMemberShipItemDetail tbody").append($Tr);
                        }
                        jQuery("#tblMemberShipItemDetail").tableHeadFixer({
                        });
                    }
                    else {
                        toast("Info", $responseData.response);
                        $clearControl();
                    }
                });              
            }
            else {
                $clearControl();
            }
        }
        function getdobDept(ctrl, row) {
            if (jQuery(ctrl).val().charAt(0) == "0") {
                jQuery(ctrl).val(Number(jQuery(ctrl).val()));
            }
            if (jQuery(ctrl).val().match(/[^0-9]/g)) {
                jQuery(ctrl).val(jQuery(ctrl).val().replace(/[^0-9]/g, ''));
                jQuery(ctrl).val(Number(jQuery(ctrl).val()));
                return;
            }
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if (jQuery("#txtAge_" + row).val() != "") {
                if (jQuery("#txtAge_" + row).val() > 110) {
                    showerrormsg("Please Enter Valid Age in Years");
                    jQuery("#txtAge_" + row).val('');
                }
                ageyear = jQuery("#txtAge_" + row).val();
            }
            if (jQuery("#txtAge1_" + row).val() != "") {
                if (jQuery("#txtAge1_" + row).val() > 12) {
                    showerrormsg("Please Enter Valid Age in Months");
                    jQuery("#txtAge1_" + row).val('');
                }
                agemonth = jQuery("#txtAge1_" + row).val();

            }
            if (jQuery("#txtAge2_" + row).val() != "") {
                if (jQuery("#txtAge2_" + row).val() > 30) {
                    showerrormsg("Please Enter Valid Age in Days");
                    jQuery("#txtAge2_" + row).val('');
                }
                ageday = jQuery("#txtAge2_" + row).val();
            }
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            jQuery("#txtDOB_" + row).val(xxx);

        }
        $showConversionAmt = function (con, elem, callback) {
            if (con == "remove")
                jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            var _temp = [];
            var blanceAmount = jQuery("#txtBlanceAmount").val();
            var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
            _temp = [];
            _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: jQuery("#ddlCurrency").val(), Amount: $blanceAmount }, function (CurrencyData) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $convertedCurrencyData = JSON.parse(CurrencyData);
                    jQuery('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                    jQuery('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, jQuery("#ddlCurrency option:selected").data("value").Round), ' ', jQuery('#spnBaseNotation').text()));
                    jQuery('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', jQuery('#ddlCurrency option:selected').text()));
                    jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                    var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + jQuery("#ddlCurrency").val());
                    jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                        jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                    });
                    if (con == "remove") {                      
                            jQuery('#tblPaymentDetail tr').slice(1).remove();
                            $getPaymentMode("1", function () { });
                            jQuery('#txtCurrencyRound').val('0');                        
                    }
                    callback(true);
                })
            }));
        };
        function $clearControl() {
            $('#spcardamount,#spnodependant,#spexpirydate').html('');              
            $('#txtGrossAmount,#txtNetAmount,#txtPaidAmount,#txtBlanceAmount,#txtCurrencyRound').val('');
            $('#tblMemberShipItemDetail tr').slice(1).remove();
            $('#tbldependent tr').slice(1).remove();
            $('#tblPaymentDetail tr').slice(1).remove();
            $showConversionAmt("remove", jQuery("#ddlCurrency"), function () { });            
        }
        $closeCardDetailModel = function () {
            jQuery('#divCardDetail').hideModel();
        }
        function showdetail() {
            if ($('#ddlcard').val() != "0") {
                jQuery('#divCardDetail').showModel();
                jQuery('#spnPopupCard').text($('#ddlcard option:selected').text());
            }
            else {
                toast("Error", "Select Card To View Detail");
            }
        }
       
    </script>
    <script type="text/javascript">        
        function $clearall() {
            $('#ddlcard').prop('selectedIndex', 0).chosen('destroy').chosen();
            $("#fileupload").val(null);
            $clearControl();
            $('#txtmembershipcard,#txtUHIDOLD').val('');
            $('#txtMobileNo,#txtUHID#txtPName,#txtAge,#txtAge1,#txtAge2,#txtPName,#txtUHID,#txtDOB').val('').attr('disabled', false);
            $('#ddlTitle').prop('selectedIndex', 0).attr('disabled', false)
            $('#ddlGender').val('Male').attr('disabled', true);
            $("#ddlTitle option:contains('Mr.')").attr('selected', 'selected');
        }
        function getdob(ageyear, agemonth, ageday) {
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar","Apr", "May", "Jun", "Jul", "Aug", "Sep","Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            return xxx;
        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }
        function $patientmaster() {
            var dataPM = new Array();
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#txtAge').val() != "") {
                ageyear = $('#txtAge').val();
            }
            if ($('#txtAge1').val() != "") {
                agemonth = $('#txtAge1').val();
            }
            if ($('#txtAge2').val() != "") {
                ageday = $('#txtAge2').val();
            }
            age = ageyear + " Y " + agemonth + " M " + ageday + " D ";
            var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);
            var objPM = new Object();
            objPM.Patient_ID = $('#txtUHIDOLD').val();
            objPM.Title = $('#ddlTitle option:selected').text();
            objPM.PName = $('#txtPName').val();
            objPM.Mobile = $('#txtMobileNo').val();
            objPM.Age = age;
            objPM.AgeYear = ageyear;
            objPM.AgeMonth = agemonth;
            objPM.AgeDays = ageday;
            objPM.TotalAgeInDays = ageindays;
            objPM.DOB = $('#txtDOB').val();
            objPM.Gender = $("#ddlGender").val();
            if ($('#rdDOB').is(':checked'))
                objPM.IsDOBActual = 1;
            else
                objPM.IsDOBActual = 0;
           
            objPM.FamilyMemberIsPrimary = 1;
            objPM.FamilyMemberRelation = "Self";
            objPM.base64PatientProfilePic = "";
            objPM.CentreID = "0";
            objPM.StateID = "0";
            objPM.CityID = "0";
            objPM.localityid = "0";
            objPM.IsOnlineFilterData = 0;
            objPM.IsDuplicate = 0;
            objPM.PinCode = "0";
            dataPM.push(objPM);
            $('#tbldependent tr').each(function () {
                if ($(this).closest("tr").attr("id") != "trh") {
                   ageyear = 0;  agemonth = 0;  ageday = 0;
                    var ss = $(this).closest('tr').find('#srnn').text();
                    if ($.trim($('#txtMobileNo_' + ss).val()) != "") {
                        if ($('#txtAge_' + ss).val() != "") {
                            ageyear = $('#txtAge_' + ss).val();
                        }
                        if ($('#txtAge1_' + ss).val() != "") {
                            agemonth = $('#txtAge1_' + ss).val();
                        }
                        if ($('#txtAge1_' + ss).val() != "") {
                            ageday = $('#txtAge2_' + ss).val();
                        }
                        if (ageyear == "")
                            ageyear = 0;
                        if (agemonth == "")
                            agemonth = 0;
                        if (ageday == "")
                            ageday = 0;

                        age = ageyear + " Y " + agemonth + " M " + ageday + " D ";
                        var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);
                        var objPM = new Object();
                        objPM.Patient_ID = $('#txtUHIDOLD_' + ss).val();
                        objPM.Title = $('#ddlTitle_' + ss + ' option:selected').text();
                        objPM.PName = $('#txtPName_' + ss).val();
                        objPM.Mobile = $('#txtMobileNo_' + ss).val();
                        objPM.Age = age;
                        objPM.AgeYear = ageyear;
                        objPM.AgeMonth = agemonth;
                        objPM.AgeDays = ageday;
                        objPM.TotalAgeInDays = ageindays;
                        objPM.DOB = $('#txtDOB_' + ss).val();
                        objPM.Gender = $('#ddlGender_' + ss).val();
                        if ($('#rdoDOB_' + ss).is(':checked'))
                            objPM.IsDOBActual = 1;
                        else
                            objPM.IsDOBActual = 0;

                        objPM.FamilyMemberIsPrimary = 0;
                        objPM.FamilyMemberRelation = $('#ddlrelation_' + ss).val();
                        objPM.base64PatientProfilePic = "";
                        objPM.CentreID = "0";
                        objPM.StateID = "0";
                        objPM.CityID = "0";
                        objPM.localityid = "0";
                        objPM.IsOnlineFilterData = 0;
                        objPM.IsDuplicate = 0;
                        objPM.PinCode = "0";
                        dataPM.push(objPM);
                    }
                }
            });
            return dataPM;
        }
        $f_ledgertransaction = function () {
            var $objLT = new Object();
            $objLT.GrossAmount = Number($('#txtGrossAmount').val());
            $objLT.NetAmount = Number($('#txtNetAmount').val());
            $objLT.Adjustment = Number($('#txtPaidAmount').val());
            return $objLT;
        }
        function patientlabinvestigationopd() {
            var objPLO = new Object();
            objPLO.ItemId = $('#ddlcard').val().split('#')[5];
            objPLO.ItemName = $('#ddlcard option:selected').text();
            objPLO.SubCategoryID = $('#ddlcard').val().split('#')[6];
            objPLO.Amount = Number($('#txtNetAmount').val());
            objPLO.Rate = Number($('#txtNetAmount').val());
            return objPLO
        }

        $f_Receipt = function () {
            var $dataRC = new Array();
            if (parseFloat(jQuery('#txtNetAmount').val()) > 0) {
                jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                   
                        var $objRC = new Object();
                        $objRC.PayBy = "P";
                        $objRC.PaymentMode = jQuery(this).closest('tr').find('#tdPaymentMode').text();
                        $objRC.PaymentModeID = jQuery(this).closest('tr').find('#tdPaymentModeID').text();
                        $objRC.Amount = jQuery(this).closest('tr').find('#tdBaseCurrencyAmount').text();
                        $objRC.BankName = String.isNullOrEmpty(jQuery(this).closest('tr').find('#tdBankName select').val()) ? '' : jQuery(this).closest('tr').find('#tdBankName select').val();
                        $objRC.CardNo = String.isNullOrEmpty(jQuery(this).closest('tr').find('#txtCardNo').val()) ? '' : jQuery(this).closest('tr').find('#txtCardNo').val();
                        $objRC.CardDate = String.isNullOrEmpty(jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').find('#tdS_CountryID').text() + jQuery(this).closest('tr').find('#tdPaymentModeID').text())).val()) ? '' : jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').find('#tdS_CountryID').text() + jQuery(this).closest('tr').find('#tdPaymentModeID').text())).val();
                        $objRC.S_Amount = jQuery(this).closest('tr').find('#txtPatientPaidAmount').val();
                        $objRC.S_CountryID = jQuery(this).closest('tr').find('#tdS_CountryID').text();
                        $objRC.S_Currency = jQuery(this).closest('tr').find('#tdS_Currency').text();
                        $objRC.S_Notation = jQuery(this).closest('tr').find('#tdS_Notation').text();
                        $objRC.C_Factor = jQuery(this).closest('tr').find('#tdC_Factor').text();
                        $objRC.Currency_RoundOff = jQuery.trim(jQuery('#txtCurrencyRound').val()) == "" ? 0 : jQuery('#txtCurrencyRound').val();
                        $objRC.Naration = "";
                        $objRC.PayTmMobile = "";
                        $objRC.PayTmOtp = "";
                        $objRC.CentreID = 0;
                        $objRC.TIDNumber = "";
                        $objRC.Panel_ID = 0;
                        $objRC.CurrencyRoundDigit = jQuery(this).closest('tr').find('#tdCurrencyRound').text();
                        $objRC.Converson_ID = jQuery(this).closest('tr').find('#tdConverson_ID').text();
                        $dataRC.push($objRC);
                    
                });
            }
            return $dataRC;
        }
        function $saveMembershipData() {
            if ($validation() == false) {
                return;
            }
            $("#btnSave").attr('disabled', true).val("Submiting...");
            var pmdata = $patientmaster();
            var ltdata = $f_ledgertransaction();
            var plodata = patientlabinvestigationopd();
            var rcdata = $f_Receipt();
            serverCall('MemberShipCardIssue.aspx/savedata', { PatientData: pmdata, LTData: ltdata, plodata: plodata, rcdata: rcdata, cardid: $('#ddlcard').val().split('#')[0], cardvalidity: $('#ddlcard').val().split('#')[7], cardno: $('#txtmembershipcard').val(), CardDependent: $.trim($('#spnodependant').text()) }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    $clearall();
                    window.open("MemberShipCardDesign.aspx?CardNumber=" + $responseData.No);
                    window.open("../Lab/PatientReceiptNew1.aspx?LabID=" + $responseData.LabID);
                }
                else {
                    toast("Error", $responseData.response, "");
                }
                $('#btnSave').attr('disabled', false).val("Save");
            });                       
        }
        function $validation() {

            if ($('#ddlcard').val() == "0") {
                toast("Error", "Please Select Card", "");
                return false;
            }
            var count = $('#tblMemberShipItemDetail tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "No Test Added With This Card Please Add Test Before Issue", "");
                return false;
            }
            if ($('#txtmembershipcard:visible').length > 0 && $('#txtmembershipcard').val() == "") {
                toast("Error", "Please Enter Card No.", "");
                $('#txtmembershipcard').focus();
                return false;
            }
            if ($('#txtMobileNo').val() == "") {
                toast("Error", "Please Enter Mobile No", "");
                $('#txtMobileNo').focus();
                return false;
            }
            if ($('#txtPName').val() == "") {
                toast("Error", "Please Enter Primary Member Name", "");
                $('#txtPName').focus();
                return false;
            }
            if ($('#txtPName').val() == "") {
                toast("Error", "Please Enter Primary Member Name", "");
                $('#txtPName').focus();
                return false;
            }

            var ageyear = "";
            var agemonth = "";
            var ageday = "";
            if ($('#txtAge').val() != "") {
                ageyear = $('#txtAge').val();
            }
            if ($('#txtAge1').val() != "") {
                agemonth = $('#txtAge1').val();
            }
            if ($('#txtAge2').val() != "") {
                ageday = $('#txtAge2').val();
            }
            if (ageyear == "" && agemonth == "" && ageday == "") {
                toast("Error", "Please Enter Patient Age", "");
                $('#txtAge').focus();
                return false;
            }
            if ($('#ddlGender').val() == "") {
                toast("Error", "Please Select Patient Gender", "");
                $('#ddlGender').focus();
                return false;
            }
            if (Number($('#txtDueAmount').val()) > 0) {
                toast("Error", "Partial Payment of Card is Not Allowed", "");
                return false;
            }
            var c = 0;
            var chkMultipleRelation = new Array("Father", "Mother", "Husband", "Wife");
            var relationPush=[];
            $('#tbldependent tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trh") {
                    var ss = $(this).closest('tr').find('#srnn').text();
                    if ($.trim($('#txtMobileNo_' + ss).val()) != "") {
                        if ($('#txtMobileNo_' + ss).val() == "") {
                            c = 1;
                            $('#txtMobileNo_' + ss).focus();
                            return;
                        }
                        if ($('#txtPName_' + ss).val() == "") {
                            c = 2;
                            $('#txtPName_' + ss).focus();
                            return;
                        }

                        if ($('#txtAge_' + ss).val() == "" && $('#txtAge1_' + ss).val() == "" && $('#txtAge2_' + ss).val() == "") {
                            c = 3;
                            $('#txtAge_' + ss).focus();
                            return;
                        }
                        if ($('#ddlGender_' + ss).val() == "") {
                            c = 4;
                            $('#ddlGender_' + ss).focus();
                            return;
                        }
                        if ($('#ddlrelation_' + ss).val() == "Select") {
                            c = 5;
                            $('#ddlrelation_' + ss).focus();
                            return;
                        }
                        relationPush.push($('#ddlrelation_' + ss).val());

                    }
                }
               
            });
           
            
            if (c == 1) {
                toast("Error", "Please Enter Dependant  Mobile No.", "");
                return false;
            }
            if (c == 2) {
                toast("Error", "Please Enter Dependant  Name", "");
                return false;
            }
            if (c == 3) {
                toast("Error", "Please Enter Dependant  Age", "");
                return false;
            }
            if (c == 4) {
                toast("Error", "Please Enter Dependant  Gender", "");
                return false;
            }
            if (c == 5) {
                toast("Error", "Please Select Dependant Relation", "");
                return false;
            }

            if ($.grep(relationPush, function (elem) {
                return elem === "Father";
            }).length > 1) {
                toast("Error", "Please Enter Valid Dependent Relation", "");
                return false;
            }
            if ($.grep(relationPush, function (elem) {
                return elem === "Mother";
            }).length > 1) {
                toast("Error", "Please Enter Valid Dependent Relation", "");
                return false;
            }
            if ($.grep(relationPush, function (elem) {
                return elem === "Husband";
            }).length > 1) {
                toast("Error", "Please Enter Valid Dependent Relation", "");
                return false;
            }

            if ($.grep(relationPush, function (elem) {
                return elem === "Wife";
            }).length > 1) {
                toast("Error", "Please Enter Valid Dependent Relation", "");
                return false;
            }

            return true;
        }
        
        
jQuery(function () {
            $bindSpecialCharater();

        });
$bindSpecialCharater=function(){
            jQuery(".checkSpecialCharater").keypress(function (e) {
                var keynum
                var keychar
                var numcheck
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                formatBox = document.getElementById(jQuery(this).val().id);
                strLen = jQuery(this).val().length;
                strVal = jQuery(this).val();
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                    ((e.keyCode) ? e.keyCode :
                                    ((e.which) ? e.which : 0));
                    if ((charCode == 45)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '-');
                            if (hasDec)
                                return false;
                        }
                    }
                    if (charCode == 46) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                    if (charCode == 47) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '/');
                            if (hasDec)
                                return false;
                        }
                    }
                }
                //List of special characters you want to restrict || keychar == "/"
                if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                    return false;
                else
                    return true;
            });

}
    </script>
</asp:Content>

