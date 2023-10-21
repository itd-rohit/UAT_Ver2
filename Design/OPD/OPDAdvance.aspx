<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDAdvance.aspx.cs" Inherits="Design_OPD_OPDAdvance" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/webcamjs/webcam.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

        <%: Scripts.Render("~/bundles/PostReportScript") %>
<div id="Pbody_box_inventory">
		<Ajax:ScriptManager ID="sc1" runat="server">           
		</Ajax:ScriptManager>
    <div class="POuter_Box_Inventory" style="text-align: center">
			<b>OPD Advance</b>
			<span id="spnError" ></span>
		</div>
    <div class="POuter_Box_Inventory" style="text-align: center">
    <div id="PatientDetails">
		 
		 <div class="row" style="margin-top: 0px;">
		 <div class="col-md-21" >					
	     <div class="row" style="display:none">
		  <div class="col-md-3 ">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
			  <asp:DropDownList ID="ddlCentre" runat="server"  CssClass="ddlCentre chosen-select chosen-container" ></asp:DropDownList>		 		 
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left">   </label>
			   <b class="pull-right"></b>
		   </div>
		   <div class="col-md-5 ">
				
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left"></label>
			   <b class="pull-right"></b>
		   </div>
		   <div class="col-md-5 ">
              		 
		   </div>
	  </div>
	     <div class="row">
		  <div class="col-md-3  ">
			   <label class="pull-left">  Mobile No.  </label>
			  <b class="pull-right">:</b>
		   </div>		  
		   <div class="col-md-5 ">
			    <input id="txtMobileNo" class="requiredField" type="text"  allowFirstZero onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});" onblur="patientSearchOnEnter(event);"   data-title="Enter Contact No. (Press Enter To Search)" onlynumber="10"    autocomplete="off"  />                          
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left">UHID  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
               <input type="text" id="txtUHIDNo"  autocomplete="off"  patientAdvanceAmount="0"  onlyText="50" maxlength="15"  data-title="Enter UHID No." onkeyup="patientSearchOnEnter(event);"/>
						<span id="spnUHIDNo" style="display:none"></span> 
		   </div>
		   <div class="col-md-3 "><label class="pull-left"></label>
			   <b class="pull-right"></b>
		   </div>
		   <div class="col-md-5 ">	
              						 				              
		   </div>	 
	  </div>
         <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left"> Patient Name  </label>
			  <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-2  col-xs-10">
               <select id="ddlTitle" onchange="$onTitleChange(this.value)"></select>						
		   </div>
		  <div  class="col-md-3  col-xs-14">
			  <input type="text" id="txtPName"  class="requiredField checkSpecialCharater" autocomplete="off"  style="text-transform:uppercase"  onlyText="50" maxlength="50"  data-title="Enter Patient Name" />
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left"> Age           
  <input type="radio" checked="checked" id="rdAge" onclick="setAge(this)" name="rdDOB" />      </label>                           
                   
			   <b class="pull-right">:</b>
		   </div>		   
  <div class="col-md-5  ">		
                     <input type="text" id="txtAge" style="width:33%;float:left" onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();"   class="requiredField"   max-value="120"  autocomplete="off"  maxlength="3" data-title="Enter Age"   placeholder="Years"/>          
                     <input type="text" id="txtAge1" style="width:33%;float:left" onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();"  class="requiredField"   max-value="12"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Months"/>                      
                     <input type="text" id="txtAge2" style="width:33%;float:left"  onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();" class="requiredField"  max-value="30"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Days"/>							         
      </div>
		   <div class="col-md-3  "><label class="pull-left">DOB            
  <input type="radio"  id="rdDOB" onclick="setDOB(this)" name="rdDOB" />              
               </label>
			   <b class="pull-right">:</b>
		   </div>                 
		   <div class="col-md-5  ">
						<asp:TextBox ID="txtDOB" onclick="getdob()" placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" Enabled="false" ></asp:TextBox>					
		   </div>		 
	  </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Gender</label>
			  <b class="pull-right">:</b>
		   </div>		  
		   <div class="col-md-5">
                <select id="ddlGender" >
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                     <option value=""></option>
                </select>               
               </div>
     <div class="col-md-3">
          <label class="pull-left"> </label>
			   <b class="pull-right"></b>
         </div>
          <div class="col-md-4">
             	
              </div>
             <div class="col-md-1">
              </div>
     <div class="col-md-3">
          <label class="pull-left"></label>
			   <b class="pull-right"></b>
         </div>
          <div class="col-md-4">
                            </div>
     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Address</label>
			  <b class="pull-right">:</b>
		   </div>		  
		   <div class="col-md-5">
                <input type="text" id="txtPAddress" maxlength="50" data-title="Enter Address"/>	           
               </div>
     <div class="col-md-3">
       <label class="pull-left">Locality</label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
           <select id="ddlArea"  data-title="Select Locality" ></select>                    
              </div>
     <div class="col-md-3">
        <label class="pull-left">PinCode </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
              <input type="text" onlynumber="6"  autocomplete="off"  id="txtPinCode"  maxlength="6"  data-title="Enter PinCode" />                       
              </div>
     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">City</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-5">
                <select id="ddlCity"  data-title="Select City" onchange="$onCityChange(this.value)"></select>                              
               </div>
     <div class="col-md-3">
       <label class="pull-left">State</label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
                            <select id="ddlState"  data-title="Select State" onchange="$onStateChange(this.value)"></select>    
              </div>
     <div class="col-md-3">
        <label class="pull-left">Country</label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
                      <select id="ddlCountry"  data-title="Select Country" onchange="$onCountryChange(this.value)"></select>                   
              </div>
     </div>           
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">  ID Proof No.  </label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-2">
               <select id="ddlIdentityType" data-title="Select ID Proof No.">         
                   <option value="Aadhaar Card">Aadhaar Card</option>
                   <option value="Card No.">Card No.</option>
                   <option value="DL No.">DL No.</option>
                   <option value="Voter Card">Voter Card</option>
                   <option value="Passport No.">Passport No.</option>
                   <option value="Pan Card No.">Pan Card No.</option>
               </select>              
               </div>
                  <div class="col-md-3">
                      <input type="text" id="txtIdProofNo"  maxlength="20" data-title="Enter ID Proof No."/>                    
                      </div>
               <div class="col-md-3">
        <label class="pull-left">  </label>
         <b class="pull-right"></b>
         </div>
             <div class="col-md-5">
                        
              </div>
     <div class="col-md-3">
       <label class="pull-left">Email  </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
                      <input type="text"  autocomplete="off"  id="txtEmail"  maxlength="50"  data-title="Enter Email Address" />   
              </div>            
     </div>
         
           <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left"> OPD Advance  </label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-5">
              <input type="text"  autocomplete="off"  id="txtOPDAdvance"  maxlength="10" class="ItDoseTextinputNum requiredField"  data-title="Enter OPD Advance" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onOPDAdvanceAmtChanged(event);"/>   

               </div>

               <div class="col-md-3">
        <label class="pull-left">  </label>
         <b class="pull-right"></b>
         </div>
             <div class="col-md-5">
                        
              </div>
     <div class="col-md-3">
       <label class="pull-left">  </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
              </div>            
     </div>   
             
             
                 

             </div>
		 <div class="col-md-3">
			 <div class="row">
				   <div class="col-md-24">
				 <input id="OldPatient" class="ItDoseButton" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search"  style="display:<%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" />
					 </div>				 
			 </div>
			<div class="row">
				 <div class="col-md-24">
					   <img id="imgPatient" alt="Patient Image" src="../../App_Images/no-avatar.gif" style="border-style: double;width:128px;height:128px;display:
							<%if (Resources.Resource.ShowPatientPhoto == "1")
         { %>
							block"
							<% }
         else
         { %>
							 none"
							<% } %>
							  />
					   <span style="display:none" id="spnIsCapTure">0</span>
				 </div>
			 </div>
			 <div class="row">
				   <div class="col-md-24">
					   <button type="button"  onclick="ShowCaptureImageModel()"   style='width:100%;margin-top:2px; display <%if (Resources.Resource.ShowPatientPhoto == "1")
                                                                                                               { %> block: ;'
							<% }
                                                                                                               else
                                                                                                               { %>
							 none"
							<% } %> >
						   Capture
						   </button>				
				 </div>				 
			 </div>
			 
			 				  
		 </div>	
	 </div>         
</div>	
        </div>
    <div class="POuter_Box_Inventory">
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
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col"  style="display:none;">Cheque/Card No.</th>
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col" style="display:none;">Cheque/Card Date</th>
				 <th class="GridViewHeaderStyle clPaymentMode"  scope="col" style="display:none;">Bank Name</th>			 
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
                     <span id="spnBaseCurrency" style="display:none"></span>
	              <span id="spnBaseCountryID" style="display:none"></span>
	              <span id="spnBaseNotation" style="display:none"></span>
	              <span id="spnCFactor" style="display:none"></span>  <span id="spnConversion_ID" style="display:none"></span>           
				</div>
				<div class="col-md-8" >				  
                    
				</div>							                          		  
            </div>  
               
                </div>  
            <div class="col-md-13">            
            <div class="row">              
                    
                    </div>
                 </div>
            <div class="col-md-11">   
                     
                    </div>           
           
         </div>
          </div>          
        <div class="POuter_Box_Inventory" style="text-align: center">			
			<input type="button" style="margin-left:-190px;margin-top:7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveOPDAdvance(this, $(this).val());" />
            <input type="button" style="margin-top:7px" value="Cancel" onclick="clearForm()" class="resetbutton" />
		</div>   
    </div>
        <div id="oldPatientModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 800px;max-width:72%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Old Patient Search</h4>
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

    <script type="text/javascript">
        $(function () {
            $bindTitle(function () {
                $bindStateCityLocality("1", function (callback) {
                    $bindDOB();
                    $bindDocumentMasters(function (callback) {


                        $bindSpecialCharater(function (callback) {
                        });


                        $getCurrencyDetails(function (baseCountryID) {
                            $getConversionFactor(baseCountryID, function (conversionFactor) {
                                $('#spnCFactor').text(conversionFactor);
                                $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round(conversionFactor, 4), ' ', $('#spnBaseNotation').text()));

                            });
                        });

                    });
                });
            });
        });
        var $bindTitle = function (callback) {
            serverCall('../Common/Services/CommonServices.asmx/bindTitleWithGender', {}, function (response) {
                var $ddlTitle = $('#ddlTitle');
                $ddlTitle.bindDropDown({ data: JSON.parse(response), valueField: 'gender', textField: 'title' });
                $('#ddlGender').attr('disabled', 'disabled');
                callback($ddlTitle.val());
            });
        }
        var $getCurrencyDetails = function (callback) {
            var ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/Services/CommonServices.asmx/LoadCurrencyDetail', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#spnBaseCurrency').text(responseData.baseCurrency);
                $('#spnBaseCountryID').text(responseData.baseCountryID);
                $('#spnBaseNotation').text(responseData.baseNotation);
                $(ddlCurrency).bindDropDown({
                    data: responseData.currancyDetails, valueField: 'CountryID', textField: 'Currency', selectedValue: '<%= Resources.Resource.BaseCurrencyID%>'
                });
                callback(ddlCurrency.val());
            });
        }
        var $getConversionFactor = function ($countryID, callback) {
            serverCall('../Common/Services/CommonServices.asmx/GetConversionFactor', { countryID: $countryID }, function (response) {
                callback(response);
            });
        }


        $bindSpecialCharater = function (callback) {
            $(".checkSpecialCharater").keypress(function (e) {
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
                formatBox = document.getElementById($(this).val().id);
                strLen = $(this).val().length;
                strVal = $(this).val();
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
            callback(true);
        };
        $bindDOB = function () {
            $("#txtDOB").datepicker({
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
        var $bindDocumentMasters = function (callback) {
            serverCall('../Common/Services/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: $('#spnUHIDNo').text() }, function (response) {
                $responseData = JSON.parse(response);
                documentMaster = $responseData.patientDocumentMasters;
                var $template = $('#template_DocumentMaster').parseTemplate(documentMaster);
                $('#documentMasterDiv').html($template);
                $('#ddlDocumentType').bindDropDown({ defaultValue: 'Select', data: documentMaster, valueField: 'ID', textField: 'Name' });
                callback(true);
            });
        }

        var $bindStateCityLocality = function (con, callback) {
            var $ddlCountry = $('#ddlCountry'); var $ddlState = $('#ddlState'); var $ddlCity = $('#ddlCity'); var $ddlLocality = $('#ddlArea');
            var $ddlSearchModelCountry = $('#ddlSearchModelCountry'); var $ddlSearchModelState = $('#ddlSearchModelState'); var $ddlSearchModelCity = $('#ddlSearchModelCity'); var $ddlSearchModelLocality = $('#ddlSearchModelLocality');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: $('#ddlCentre').val().split('#')[11], StateID: $('#ddlCentre').val().split('#')[3], CityID: $('#ddlCentre').val().split('#')[2], IsStateBind: 1, CentreID: $('#ddlCentre').val().split('#')[0], IsCountryBind: 1, IsFieldBoyBind: 0,IsCityBind:1,IsLocality:1 }, function (response) {
                if (con == 1) {
                    $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[11], showDataValue: 1 });
                    $ddlSearchModelCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[11], showDataValue: 1 });


                }
                $ddlState.bindDropDown({ data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[3] });
                $ddlSearchModelState.bindDropDown({ data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[3] });

                $ddlCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[2] });
                $ddlLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[7] });
                $ddlSearchModelCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[2] });
                $ddlSearchModelLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[7] });
                callback($ddlLocality.val());
            });
        }
        var $bindState = function (CountryID, con, callback) {
            var $ddlState = $('#ddlState');
            $('#ddlState,#ddlCity,#ddlArea').find('option').remove();
            $('#ddlState,#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                if (con == 0)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[3] });
                else
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });

                callback($ddlState.val());
            });
        }
        var $bindCity = function (StateID, con, callback) {
            var $ddlCity = $('#ddlCity');
            $('#ddlCity,#ddlArea').empty();
            $('#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                if (con == 0)
                    $ddlCity.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[2] });
                else
                    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });

                callback($ddlCity.val());
            });
        }
        var $bindLocality = function (CityID, con, callback) {
            var $ddlArea = $('#ddlArea');
            $('#ddlArea').empty();
            $('#ddlArea').chosen("destroy");

            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                if (con == 0)
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[7] });
                else
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });

                callback($ddlArea.val());
            });
        }
        var $bindModelState = function (CountryID, callback) {
            var $ddlState = $('#ddlSearchModelState');
            $('#ddlSearchModelState,#ddlSearchModelCity,#ddlSearchModelLocality').empty();
            $('#ddlSearchModelState,#ddlSearchModelCity,#ddlSearchModelLocality').chosen("destroy");

            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                callback($ddlState.val());
            });
        }
        var $bindModelCity = function (StateID, callback) {
            var $ddlCity = $('#ddlSearchModelCity');
            $('#ddlSearchModelCity,#ddlSearchModelLocality').empty();
            $('#ddlSearchModelCity,#ddlSearchModelLocality').chosen("destroy");

            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                callback($ddlCity.val());
            });
        }
        var $bindModelLocality = function (CityID, callback) {
            var $ddlArea = $('#ddlSearchModelLocality');
            $('#ddlSearchModelLocality').empty();
            $('#ddlSearchModelLocality').chosen("destroy");

            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlArea.val());
            });
        }
    </script>
    <script type="text/javascript">
        $getPaymentMode = function (con, callback) {
            if (con == 0) {
                $("#divPaymentMode").html('');
                $('#tblPaymentDetail tr').slice(1).remove();
                $bindPaymentMode(function (response) {
                    paymentModes = $.extend(true, [], response);
                    $('#txtGrossAmount,#txtNetAmount,#txtPaidAmount').val($('#txtOPDAdvance').val());
                    if (paymentModes.length > 0) {
                        paymentModes.patientAdvanceAmount = 0;
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
                        $validatePaymentModes(1, 'Cash', Number($('#txtOPDAdvance').val()), $('#ddlCurrency'), function (response) {
                            $bindPaymentDetails(response, function (response) {
                                $bindPaymentModeDetails(response, function (data) {

                                });
                            });
                        });
                    }

                });
            }
            else {
                $("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
                $('#divPaymentMode').find('input[type=checkbox][name=paymentMode]').prop('checked', false);
                $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', 'checked');
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails(response, function (data) {

                    });
                });
            }
            $("#divPaymentDetails,#divDiscountBy,#divDiscountReason,.isReciptsBool,.clCashTender,.divOutstanding,.isReciptsBool1,.clPaidAmt").show();
            $(".isReciptsBool").css("height", 84);
            $("#tblPaymentDetail").tableHeadFixer({
            });
        };

        var $paymentModeCache = [];
        var $bindPaymentMode = function (callback) {
            if ($paymentModeCache.length > 0)
                callback($paymentModeCache);
            else {
                serverCall('../Common/Services/CommonServices.asmx/bindPaymentMode', {}, function (response) {
                    $paymentModeCache = JSON.parse(response);
                    callback($paymentModeCache);
                });
            }
        }

        var $bindPaymentDetails = function (data, callback) {
            $payment = {};
            $payment.billAmount = data.billAmount;
            $payment.$paymentDetails = [];
            $payment.$paymentDetails = {
                Amount: data.billAmount,
                BaceCurrency: data.baseCurrencyName,
                BankName: '',
                C_Factor: data.currencyFactor,
                PaymentMode: data.paymentMode,
                PaymentModeID: data.PaymentModeID,
                PaymentRemarks: '',
                RefNo: '',
                S_Amount: data.billAmount,
                baseCurrencyAmount: data.billAmount,
                S_CountryID: data.currencyID,
                S_Currency: data.currentCurrencyName,
                S_Notation: data.currentCurrencyName,
                currencyRound: data.currencyRound,
                Converson_ID: data.Converson_ID,
            };
            callback($payment);
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

            $validatePaymentModes(elem.value, $(elem).next('b').text(), Number($('#txtNetAmount').val()), $('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails(response, function (data) {
                        $bindBankMaster(data.bankControl, function () {
                            $calculateTotalPaymentAmount(function () { });
                        });
                    });
                });
            });
        }
        var $validatePaymentModes = function ($PaymentModeID, $PaymentMode, $billAmount, $ddlCurrency, callback) {

            var $totalPaidAmount = 0;
            $('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number($(this).text()); });
            var data = {
                currentSelectedPaymentMode: Number($PaymentModeID),
                totalSelectedPaymentModes: $('#tdPaymentModes input[type=checkbox]:checked'),
                billAmount: $billAmount,
                totalPaidAmount: $billAmount,
                defaultPaidAmount: $billAmount,
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
        var $bindBankMaster = function (bankControls, callback) {
            $getBankMaster(function (response) {
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
        var $bindPaymentModeDetails = function (data, callback) {

            var $disableBankDetailPaymentModeID = [1, 4];
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
            $temp.push($.trim(data.$paymentDetails.PaymentMode));
            $temp.push('"');
            $temp.push('style="width:100px">');
            $temp.push($.trim(data.$paymentDetails.PaymentMode)); $temp.push('</td>');
            $temp.push('<td id="tdAmount" class="GridViewLabItemStyle" style="width:100px">');
            $temp.push('<input type="text" onlynumber="10" decimalplace="3" max-value="');
            $temp.push(maxInputValue); $temp.push('"');
            $temp.push(' value="'); $temp.push(data.$paymentDetails.Amount); $temp.push('"');
            $temp.push(' autocomplete="off" id="txtPatientPaidAmount" class="ItDoseTextinputNum requiredField" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onPaidAmountChanged(event);" /></td>');
            $temp.push('<td id="tdS_Currency" class="GridViewLabItemStyle">');
            $temp.push(data.$paymentDetails.S_Currency); $temp.push('</td>');
            $temp.push('<td id="tdBaseCurrencyAmount" class="GridViewLabItemStyle"  style="text-align:right">');
            $temp.push(data.$paymentDetails.baseCurrencyAmount); $temp.push('</td>');
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
            callback({ bankControl: bankControl });


        }
        var $onPaidAmountChanged = function (e) {
            var row = $(e.target).closest('tr');
            var $countryID = Number(row.find('#tdS_CountryID').text());
            var $paidAmount = Number(e.target.value);
            if (isNaN($paidAmount) || $paidAmount == "")
                $paidAmount = 0;
            $convertToBaseCurrency($countryID, $paidAmount, function (baseCurrencyAmount) {
                $(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount.SellingCurrencyAmount);
                $calculateTotalPaymentAmount(e, function () {

                });
                if ($(e.target).closest('tr').find("#tdPaymentMode").text() == "Cash") {
                    var $amountGiven = $("#txtAmountGiven").val();
                    if (isNaN($amountGiven) || $amountGiven == "")
                        $amountGiven = 0;
                    if ($amountGiven > 0)
                        renderAmt();
                }
            });
        }
        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            var _temp = [];
            if (calculateConversionFactor == 1) {
             //   _temp.push(serverCall('../Common/Services/CommonServices.asmx/GetConversionFactor', { countryID: $('#ddlCurrency').val() }, function (conversionFactor) {
             //       $.when.apply(null, _temp).done(function () {
                        var blanceAmount = $("#txtBlanceAmount").val();
                        var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;

                        _temp = [];
                        _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                            $.when.apply(null, _temp).done(function () {

                                var $convertedCurrencyData = JSON.parse(CurrencyData);

                                $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                                $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);

                                $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                                $('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', $('#ddlCurrency option:selected').text()));
                                $('input[type=checkbox][name=paymentMode]').prop('checked', false);
                                var selectedPaymentModeOnCurrency = $('#divPaymentDetails').find('.' + $('#ddlCurrency').val());
                                $(selectedPaymentModeOnCurrency).each(function (index, elem) {

                                    $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + $(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                                });
                                callback(true);
                            })
                        }));
                   // });

                //}));
            }
            else {
                _temp = [];
                var blanceAmount = $("#txtBlanceAmount").val();
                var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: $('#ddlCurrency').val(), Amount: $blanceAmount }, function (CurrencyData) {
                    $.when.apply(null, _temp).done(function () {
                        var $convertedCurrencyData = JSON.parse(CurrencyData);
                        $('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                        $('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                        $('#spnConvertionRate').text("".concat('1 ', $('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, $('#ddlCurrency option:selected').data("value").Round), ' ', $('#spnBaseNotation').text()));
                        $('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', $('#ddlCurrency option:selected').text()));
                        $('input[type=checkbox][name=paymentMode]').prop('checked', false);
                        var selectedPaymentModeOnCurrency = $('#divPaymentDetails').find('.' + $('#ddlCurrency').val());
                        $(selectedPaymentModeOnCurrency).each(function (index, elem) {

                            $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + $(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                        });
                        callback(true);
                    })
                }));
            }



        }
        var $convertCurrency = function (countryID, amount, callback) {
            serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: countryID, Amount: amount }, function (response) {
                callback(response);
            });
        }
        </script>
        <script id="scPaymentModes" type="text/html">  
		<#
		var dataLength=paymentModes.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {
            objRow = paymentModes[j];
		  #>
					<div class="ellipsis" style="float:left">
					<input type="checkbox"   name="paymentMode" onchange="$onPaymentModeChange(this,$('#ddlCurrency'),function(){});"  value='<#=objRow.PaymentModeID#>'  />
					<b> <#= objRow.PaymentMode  #> </b>
					</div>
			<#}#>       
</script>
   <script type="text/javascript">
       var $onOPDAdvanceAmtChanged = function (e) {
           var $OPDAdvanceAmt = Number(e.target.value);

           if ($OPDAdvanceAmt > 0) {
               $addBillAmount({
                   billAmount: $OPDAdvanceAmt
               }, function () { });
           }
           else {
               $clearPaymentControl(function () { });
           }


       }
       var $addBillAmount = function (data, callback) {
           $getPaymentMode("0", function (callback) {
           });
       };
       var $clearPaymentControl = function (callback) {
           $('#txtPaidAmount').val('0');
           callback(true);
       }
       var $convertToBaseCurrency = function ($countryID, $paidAmount, callback) {
           var baseCurrencyCountryID = Number($('#spnBaseCountryID').text());
           $paidAmount = Number($paidAmount);
           $paidAmount = isNaN($paidAmount) ? 0 : $paidAmount;
           if (baseCurrencyCountryID == $countryID) {
               var data = {
                   BaseCurrencyAmount: $paidAmount,
                   ConversionFactor: $('#spnCFactor').text(),
                   Converson_ID: $('#spnConversion_ID').text(),
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
       var $calculateTotalPaymentAmount = function (event, row, callback) {

           var $totalPaidAmount = 0;
           $('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
           var $netAmount = parseFloat($('#txtNetAmount').val());
           var $roundOffTotalPaidAmount = Math.round($totalPaidAmount);

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
                $('#txtBlanceAmount').val(precise_round(parseFloat($('#txtNetAmount').val()) - parseFloat($('#txtPaidAmount').val()), '<%=Resources.Resource.BaseCurrencyRound%>'));


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

           $validatePaymentModes(elem.value, $(elem).next('b').text(), 0, $('#ddlCurrency'), function (response) {
               $bindPaymentDetails(response, function (response) {
                   $bindPaymentModeDetails(response, function (data) {
                       $bindBankMaster(data.bankControl, function () {
                           $calculateTotalPaymentAmount(function () { });
                       });
                   });
               });
           });
       }

   </script>
    <script type="text/javascript">
        function validation() {
            if ($('#txtMobileNo').val().length == 0) {
                toast("Error", "Please Enter Mobile No.", "");
                $('#txtMobileNo').focus();
                return false;
            }
            if ($('#txtMobileNo').val().length != 0) {
                if ($('#txtMobileNo').val().length < 10) {
                    toast("Error", "Incorrect Mobile No.", "");
                    $('#txtMobileNo').focus();
                    return false;
                }
            }
            if ($('#txtPName').val().trim().length == 0) {
                toast("Error", "Please Enter Patient Name", "");
                $('#txtPName').focus();
                return false;
            }
            if ($('#txtDOB').val().length == 0) {
                toast("Error", "Please Enter DOB", "");
                $('#txtDOB').focus();
                return false;

            }
            if ($('#txtReferDoctor').val() == "" || $('#hftxtReferDoctor').val() == "") {
                toast("Error", "Please Select Doctor", "");
                $("#txtReferDoctor").focus();
                return false;
            }
            var $ageyear = "";
            var $agemonth = "";
            var $ageday = "";
            if ($('#txtAge').val() != "") {
                $ageyear = $('#txtAge').val();
            }
            if ($('#txtAge1').val() != "") {
                $agemonth = $('#txtAge1').val();
            }
            if ($('#txtAge2').val() != "") {
                $ageday = $('#txtAge2').val();
            }
            if ($ageyear == "" && $agemonth == "" && $ageday == "") {
                toast("Error", "Please Enter Patient Age", "");
                $('#txtAge').focus();
                return false;
            }
            if ($('#ddlGender').val() == "") {
                toast("Error", "Please Select Patient Gender", "");
                $('#ddlGender').focus();
                return false;
            }
            if ($('#txtEmail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#txtEmail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    $('#txtEmail').focus();
                    return false;
                }
            }


        }
         </script>
    <script type="text/javascript">
        var $saveOPDAdvance = function (btnSave, buttonVal) {
            if (validation() == false) {
                return;
            }
            $(btnSave).attr('disabled', true).val('Submitting...');
            var $patientData = patientmaster();           
            var $Rcdata = f_receipt();


            serverCall('OPDAdvance.aspx/SaveOPDAdvance', { PatientData: $patientData, Rcdata: $Rcdata, isVipM: 0 }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $(btnSave).removeAttr('disabled').val('Save');
                    clearForm();
                    toast("Success", "Record Saved Successfully", "");

                    PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));



                    $modelUnBlockUI(function () { });
                }
                else {
                    toast("Error", $responseData.response, "");
                    $(btnSave).removeAttr('disabled').val(buttonVal);
                    $modelUnBlockUI(function () { });
                }
                $("#btnSave").removeAttr('disabled').val('Save');
            });
        };
        function clearForm() {
            PNameMob.length = 0;
            $('#spnError').text('');
            $('#rdAge').prop("checked", true);
            $('#txtDOB').removeClass('requiredField');
            $('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
            $('#ddlTitle,#ddlGender,.bnk').prop('selectedIndex', 0);
            $('#ddlTitle,#txtAge,#txtAge1,#txtAge2').removeAttr("disabled");
            $('#ddlGender,#txtDOB').attr('disabled', 'disabled');           
            $("input[type=text]").val('');
            $('#tblPaymentDetail tr').slice(1).remove();
            $('#spnUHIDNo,#spnBlanceAmount').html('');
            $clearPaymentControl(function () { });
            $('#txtMobileNo,#txtAge,#txtAge1,#txtAge2,#txtUHIDNo,#txtPName').attr("disabled", false);
            $('#ddlState').val($('#ddlCentre').val().split('#')[3]).chosen('destroy').chosen();
            $('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
        }

        function patientmaster() {
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
            objPM.Patient_ID = $.trim($('#spnUHIDNo').html());
            objPM.Title = $("#ddlTitle option:selected").text();
            objPM.PName = $.trim($('#txtPName').val());
            objPM.House_No = $.trim($('#txtPAddress').val());
            objPM.Street_Name = "";
            objPM.Locality = $('#ddlArea option:selected').text();
            objPM.City = $("#ddlCity option:selected").text();
            if ($('#txtPinCode').val() != "")
                objPM.PinCode = $.trim($('#txtPinCode').val());
            else
                objPM.PinCode = "0";
            objPM.State = $("#ddlState option:selected").text();
            objPM.Country = $("#ddlCountry option:selected").text();
            objPM.Phone = "";
            objPM.Mobile = $.trim($('#txtMobileNo').val());
            objPM.Email = $.trim($('#txtEmail').val());
            objPM.Age = age;
            objPM.AgeYear = ageyear;
            objPM.AgeMonth = agemonth;
            objPM.AgeDays = ageday;
            objPM.TotalAgeInDays = ageindays;
            objPM.DOB = $('#txtDOB').val();
            objPM.Gender = $("#ddlGender option:selected").text();
            objPM.CountryID = $("#ddlCountry").val();
            objPM.StateID = $('#ddlState').val();
            objPM.CityID = $('#ddlCity').val();
            objPM.LocalityID = $('#ddlArea').val();
            objPM.IsOnlineFilterData = "0";
            objPM.IsDuplicate = 0;
            objPM.isCapTure = $('#spnIsCapTure').text();
            objPM.base64PatientProfilePic = $('#imgPatient').prop('src');
            objPM.IsDOBActual = $('#rdDOB').is(':checked') ? 1 : 0;
            objPM.ClinicalHistory = "";
            return objPM;
        }
       
       
        function f_receipt() {
            var datarc = new Array();
            if (parseFloat($('#txtNetAmount').val()) > 0) {
                $("#tblPaymentDetail").find('tbody tr').each(function () {
                    var $PatientPaidAmount = $(this).closest('tr').find('#txtPatientPaidAmount').val();
                    if (isNaN($PatientPaidAmount) || $PatientPaidAmount == "")
                        $PatientPaidAmount = 0;
                    if ($PatientPaidAmount > 0) {
                        var objRC = new Object();
                        objRC.PayBy = "P";
                        objRC.PaymentMode = $(this).closest('tr').find('#tdPaymentMode').text();
                        objRC.PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text();
                        objRC.Amount = $(this).closest('tr').find('#tdBaseCurrencyAmount').text();
                        objRC.BankName = String.isNullOrEmpty($(this).closest('tr').find('#tdBankName select').val()) ? '' : $(this).closest('tr').find('#tdBankName select').val();
                        objRC.CardNo = String.isNullOrEmpty($(this).closest('tr').find('#txtCardNo').val()) ? '' : $(this).closest('tr').find('#txtCardNo').val();
                        objRC.CardDate = String.isNullOrEmpty($(this).closest('tr').find("".concat('#txtCardDate_', $(this).closest('tr').find('#tdS_CountryID').text() + $(this).closest('tr').find('#tdPaymentModeID').text())).val()) ? '' : $(this).closest('tr').find("".concat('#txtCardDate_', $(this).closest('tr').find('#tdS_CountryID').text() + $(this).closest('tr').find('#tdPaymentModeID').text())).val();
                        objRC.S_Amount = $(this).closest('tr').find('#txtPatientPaidAmount').val();
                        objRC.S_CountryID = $(this).closest('tr').find('#tdS_CountryID').text();
                        objRC.S_Currency = $(this).closest('tr').find('#tdS_Currency').text();
                        objRC.S_Notation = $(this).closest('tr').find('#tdS_Notation').text();
                        objRC.C_Factor = $(this).closest('tr').find('#tdC_Factor').text();
                        var CurrencyRound = $('#txtCurrencyRound').val();
                        if (isNaN(CurrencyRound) || CurrencyRound == "")
                            CurrencyRound = 0;
                        objRC.Currency_RoundOff = CurrencyRound;
                        objRC.Naration = "";
                        objRC.PayTmMobile = "";
                        objRC.PayTmOtp = "";
                        objRC.TIDNumber = "";
                        objRC.Panel_ID = 0;
                        objRC.Converson_ID = $(this).closest('tr').find('#tdConverson_ID').text();
                        datarc.push(objRC);
                    }
                });
            }
            return datarc;
        }
    </script>
    <script type="text/javascript">
       
        var $bindCity = function (StateID, con, callback) {
            var $ddlCity = $('#ddlCity');
            $('#ddlCity,#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                if (con == 0)
                    $ddlCity.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[2] });
                else
                    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });

                callback($ddlCity.val());
            });
        }
        var $bindLocality = function (CityID, con, callback) {
            var $ddlArea = $('#ddlArea');
            $('#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                if (con == 0)
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true, selectedValue: $('#ddlCentre').val().split('#')[7] });
                else
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });

                callback($ddlArea.val());
            });
        }
        $showOldPatientSearchModel = function () {
            $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
            $('#oldPatientModel').showModel();
            $('.clMoreFilter').show();
            $('#divSearchModelPatientSearchResults').html('');
        }
        $searchOldPatientDetail = function () {
            var data = {
                PName: $('#txtSearchModelName').val(),
                DOB: "",
                Patient_ID: $('#txtSearchModelMrNO').val(),
                MobileNo: $('#txtSerachModelContactNo').val(),
                fromDate: $('#txtSearchModelFromDate').val(),
                toDate: $('#txtSerachModelToDate').val(),
                stateID: $('#ddlSearchModelState').val(),
                cityID: $('#ddlSearchModelCity').val(),
                localityID: $('#ddlSearchModelLocality').val(),
            }
            getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatientFromMoreFilter', function (response) {
                bindOldPatientDetails(response);
            });
        }
        var bindOldPatientDetails = function (data) {
            if (!String.isNullOrEmpty(data)) {
                OldPatient = JSON.parse(data);
                if (OldPatient != null) {
                    _PageCount = OldPatient.length / _PageSize;
                    showPage(0);
                }
                else
                    $('#divSearchModelPatientSearchResults').html('');
            }
            else
                $('#divSearchModelPatientSearchResults').html('');
        }
    </script>
    <script type="text/javascript">
        var PNameMob = [];
        var patientSearchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13 || (e.target.id === 'txtMobileNo' && e.target.value.length === 10)) {
                var data = { MobileNo: '', Patient_ID: '', PName: '', FromRegDate: '', ToRegDate: '' };
                if (e.target.id == 'txtMobileNo') {
                    if (e.target.value.length < 10) {
                        modelAlert('Invalid Mobile No.');
                        return;
                    }
                    data.MobileNo = e.target.value;
                }
                if (e.target.id == 'txtUHIDNo') {
                    if (e.target.value.length == 0) {
                        modelAlert('Invalid UHID No.');
                        return;
                    }
                    data.Patient_ID = e.target.value;
                }
                data.FromRegDate = $("#txtSearchModelFromDate").val();
                data.ToRegDate = $("#txtSerachModelToDate").val();
                PNameMob.length = 0;
                $('#tablePatient tr').remove();
                $('.clMoreFilter').hide();
                getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatient', function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        var resultData = JSON.parse(response);
                        if (resultData.length > 0) {
                            bindOldPatientDetailsContact(response);
                        }
                        else
                            toast('Info', 'No Record Found', '');
                    }
                    else
                        toast('Info', 'No Record Found', '');
                });
            }
        }
        var getOldPatientDetails = function (data, url, callback) {
            serverCall(url, data, function (response) {
                callback(response);
            });
        }
        var _PageNo = 0;
        var _PageSize = 6;
        $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }
        var bindOldPatientDetailsContact = function (data) {
            if (!String.isNullOrEmpty(data)) {
                OldPatient = JSON.parse(data);
                if (OldPatient != null) {
                    _PageCount = OldPatient.length / _PageSize;
                    showPage(0);
                }
                else
                    $('#divSearchModelPatientSearchResults').html('');
            }
            else
                $('#divSearchModelPatientSearchResults').html('');
        }
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            $('#oldPatientModel').showModel();
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });


        }
        var $onCountryChange = function (selectedCountryID) {
            $bindState(selectedCountryID, "1", function (selectedStateID) {

            });
        }
        var $onStateChange = function (selectedStateID) {
            $bindCity(selectedStateID, "1", function (selectedCityID) {
                $bindLocality(selectedCityID, "1", function () { });
            });
        }
        var $onCityChange = function (selectedCityID) {
            $bindLocality(selectedCityID, "1", function () { });
        }
        var $onCountryModelChange = function (selectedCountryID) {
            $bindModelState(selectedCountryID, function (selectedStateID) {
               
            });
        }
        var $onStateModelChange = function (selectedStateID) {
            $bindModelCity(selectedStateID, function (selectedCityID) {
                $bindModelLocality(selectedCityID, function () { });
            });
        }
        var $onCityModelChange = function (selectedCityID) {
            $bindModelLocality(selectedCityID, function () { });
        }
        var $onTitleChange = function (gender) {
            var $Gender = $('#ddlGender').val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                $('#ddlGender').val("").prop('disabled', false);
            }
            else {
                $('#ddlGender').val(gender).prop('disabled', true);
            }

        }
        var onPatientSelect = function (elem) {
            $("#txtMobileNo").val($(elem).closest('tr').find('#tdMobile').text()).attr('disabled', 'disabled');
            $($('#ddlTitle option').filter(function () { return this.text == $(elem).closest('tr').find('#tdTitle').text() })[0]).prop('selected', true).attr('disabled', 'disabled');
            $onTitleChange($('#ddlTitle').val());
            $("#ddlGender").val($(elem).closest('tr').find('#tdGender').text()).attr('disabled', 'disabled');
            $("#txtPName").val($(elem).closest('tr').find('#tdPName').text()).attr('disabled', 'disabled');
            $("#txtDOB").val($(elem).closest('tr').find('#tdDOB').text());
            $("#txtUHIDNo").val($(elem).closest('tr').find('#tdPatient_ID').text()).attr('disabled', 'disabled');

            var txtPID = $('#txtUHIDNo')
                            .val($(elem).closest('tr').find('#tdPatient_ID').text())
                            .attr('patientAdvanceAmount', $(elem).closest('tr').find('#tdPatientAdvance').text());

            if (!String.isNullOrEmpty($(elem).closest('tr').find('#tdPatient_ID').text()))
                $(txtPID).change();

            $("#spnUHIDNo").text($(elem).closest('tr').find('#tdPatient_ID').text());
            $("#txtAge").val($(elem).closest('tr').find('#tdAgeYear').text());
            $("#txtAge1").val($(elem).closest('tr').find('#tdAgeMonth').text());
            $("#txtAge2").val($(elem).closest('tr').find('#tdAgeDays').text());
            $("#txtEmail").val($(elem).closest('tr').find('#tdEmail').text());
            $("#txtPinCode").val($(elem).closest('tr').find('#tdPinCode').text());

            $('#ddlCountry').val($(elem).closest('tr').find('#tdCountryID').text()).chosen('destroy').chosen();



           // $('#ddlState').val($(elem).closest('tr').find('#tdStateID').text()).chosen('destroy').chosen();
            $('#ddlTitle').attr('disabled', 'disabled');
            $bindState($(elem).closest('tr').find('#tdCountryID').text(), "1", function (selectedStateID) {
                $('#ddlState').val($(elem).closest('tr').find('#tdStateID').text()).chosen('destroy').chosen();
                $bindCity($(elem).closest('tr').find('#tdStateID').text(), "1", function (selectedCityID) {
                    $('#ddlCity').val($(elem).closest('tr').find('#tdCityID').text()).chosen('destroy').chosen();
                    $bindLocality($(elem).closest('tr').find('#tdCityID').text(), "1", function () {
                        $('#ddlArea').val($(elem).closest('tr').find('#tdLocalityID').text()).chosen('destroy').chosen();
                    });
                });
            });
            $searchPatientImage({ PatientID: $.trim($(elem).closest('tr').find('#tdPatient_ID').text()), dtEntry: $.trim($(elem).closest('tr').find('#tddtEntry').text()) }, function (response) {
                if (!String.isNullOrEmpty(response.Item1)) {
                    $('#imgPatient').attr('src', response.Item1);
                }
                else
                    $('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
                if (!String.isNullOrEmpty(response.Item2)) {
                    $('#spnDocumentCounts').text(response.Item2);
                }
            });


            $('#oldPatientModel').hideModel();
        }
        $searchPatientImage = function (PatientID, dtEntry, callback) {
            serverCall('../Lab/Services/LabBooking.asmx/BindPatientImage', PatientID, dtEntry, function (response) {
            });
        }
    </script>
            <script id="tb_OldPatient" type="text/html">
	<table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse :collapse;">
		<thead>  
			 <tr id="Header"> 
					<th class="GridViewHeaderStyle" scope="col">Select</th>
                    <th class="GridViewHeaderStyle" scope="col">PreBooking No.</th>
					<th class="GridViewHeaderStyle" scope="col">UHID</th> 
					<th class="GridViewHeaderStyle" scope="col">Patient Name</th> 
					<th class="GridViewHeaderStyle" scope="col">Age</th> 
					<th class="GridViewHeaderStyle" scope="col">DOB</th>
					<th class="GridViewHeaderStyle" scope="col">Gender</th> 
					<th class="GridViewHeaderStyle" scope="col">Mobile</th> 
					<th class="GridViewHeaderStyle" scope="col">Area</th> 
					<th class="GridViewHeaderStyle" scope="col">City</th> 
					<th class="GridViewHeaderStyle" scope="col">State</th> 
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
            PNameMob[j] = OldPatient[j].PName;
            
	   var objRow = OldPatient[j];
		#>              
						<tr onmouseover="this.style.color='#00F'"  class="trOldPatient"  onMouseOut="this.style.color=''" id="<#=j+1#>" style='cursor:pointer;
                            
                           <#if(objRow.PreBookingID!=0){#>
                            background-color:#C6DFF9;'>
                            <#}  else
                        {#> 
                        '> <#}
                        #>                          
						<td class="GridViewLabItemStyle">
					   <a  class="btn" onclick="onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
						  Select						   
					   </a>
                            <span data-title='Double Click To Select'  ></span>                
						</td>  
                            <td  class="GridViewLabItemStyle" id="tdPreBookingID">
                          <# if(objRow.PreBookingID!=0)
                            {#>
                                <#=objRow.PreBookingID#>
                            <#}#>                                                       
                                </td>
                                                                         
						<td  class="GridViewLabItemStyle" id="tdPatient_ID"  ><#=objRow.Patient_ID#></td>
						<td class="GridViewLabItemStyle" id="tdPName" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PName#></td>
						<td class="GridViewLabItemStyle" id="tdAge" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.age#></td>
						<td class="GridViewLabItemStyle" id="tdDOB"  ><#=objRow.dob#></td>
						<td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.gender#></td>
						<td class="GridViewLabItemStyle" id="tdMobile" ><#=objRow.mobile#></td>
						<td class="GridViewLabItemStyle" id="tdLocality" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Locality#></td>
						<td class="GridViewLabItemStyle" id="tdCity" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.City#></td>
						<td class="GridViewLabItemStyle" id="tdState" style="text-align:left;max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"><#=objRow.State#></td>  
						<td class="GridViewLabItemStyle" id="tdvisitdate" ><#=objRow.visitDate#></td>   
						<td class="GridViewLabItemStyle" id="tdPinCode" style="display:none" ><#=objRow.PinCode#></td>    
                        <td class="GridViewLabItemStyle" id="tdAgeYear" style="display:none" ><#=objRow.ageYear#></td>
                        <td class="GridViewLabItemStyle" id="tdAgeMonth" style="display:none" ><#=objRow.ageMonth#></td>
                        <td class="GridViewLabItemStyle" id="tdAgeDays" style="display:none" ><#=objRow.ageDays#></td>
                        <td class="GridViewLabItemStyle" id="tdEmail" style="display:none" ><#=objRow.email#></td>
                        <td class="GridViewLabItemStyle" id="tdCountryID" style="display:none" ><#=objRow.CountryID#></td>
                        <td class="GridViewLabItemStyle" id="tdStateID" style="display:none" ><#=objRow.StateID#></td>
                        <td class="GridViewLabItemStyle" id="tdCityID" style="display:none" ><#=objRow.CityID#></td>
                        <td class="GridViewLabItemStyle" id="tdLocalityID" style="display:none" ><#=objRow.LocalityID#></td>
                        <td class="GridViewLabItemStyle" id="tdTitle" style="display:none" ><#=objRow.title#></td>
                        <td class="GridViewLabItemStyle" id="tddtEntry" style="display:none" ><#=objRow.dtEntry#></td>
                        <td class="GridViewLabItemStyle" id="tdClinicalHistory" style="display:none" ><#=objRow.ClinicalHistory#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientAdvance" style="display:none" ><#=objRow.OPDAdvanceAmount#></td>
						</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	 <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
	   <tr>
   <# if(_PageCount>1) {
	 for(var j=0;j<_PageCount;j++){ #>
	 <td class="GridViewLabItemStyle" style="width:8px;"><a class="btn" href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
	 <#}         
   }
#>
	 </tr>     
	 </table>  
	</script>

</asp:Content>

