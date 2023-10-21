<%@ Page  ClientIDMode="Static" Language="C#"  AutoEventWireup="true" CodeFile="Lab_PrescriptionOPDEditInfo.aspx.cs" Inherits="Design_Lab_Lab_PrescriptionOPDEditInfo" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>

<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>
        <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 
     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/chosen.css" />
   
    </head><body>
    	 <%: Scripts.Render("~/bundles/WebFormsJs") %>
  <form id="form1" runat="server">
           <Ajax:ScriptManager ID="sc1" runat="server">
           
        </Ajax:ScriptManager>
            <%--<div class="content">--%>
            <div class="POuter_Box_Inventory" style="text-align:center" >
                <b>Registration Edit</b>
                <span id="spnError"></span>
            <div class="POuter_Box_Inventory">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            &nbsp;                          
                        </div>
                        <div class="col-md-5">
                            &nbsp;
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">Lab No.  </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-4">
                              

                            <asp:TextBox ID="txtLabNo" MaxLength="15" class="requiredField" runat="server" data-title="Enter Lab No. (Press Enter To Search)"  />
                        </div>

                        <div class="col-md-3">
                            <asp:Label ID="lblPatient_ID" runat="server" Style="display: none;"></asp:Label>
                            <asp:TextBox ID="txtCentreID" runat="server" Style="display: none;"></asp:TextBox>
                            <input type="button" id="btnSearch" class="savebutton" value="Search" onclick="getdata()" />

                        </div>
                        <div class="col-md-7">
                            &nbsp;
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div id="PatientDetails">
                    <div class="Purchaseheader">
                        Patient Details		
                    </div>
                     <div class="row">
		            <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Mobile No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            			    <input id="txtMobileNo" class="requiredField" type="text"  allowFirstZero onkeyup="previewCountDigit(event,function(e){OTPMobile(e)});"   onlynumber="10"    autocomplete="off"  />                                                    
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtMobileOTP" placeholder="Enter OTP" style="width:100px;display:none;" />
                            <input type="text" id="txtotppatientuni" style="display:none;" />
                            <input type="hidden" id="hdnIsOTPRequired" value="0" />
                        </div>
                        <div class="col-md-5">
                             <img id="imgVerified" src="../../App_Images/verified.gif" style="width: 16px;top: 183px;left: 407px;position: absolute;display:none;" />
                         </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHIDNo" autocomplete="off" onlytext="50" MaxLength="15" runat="server" data-title="Enter UHID" class="requiredField" Enabled="false"/>
                            <span id="spnUHIDNo" style="display: none"></span>
                        </div>                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <select id="ddlTitle" onchange="$onTitleChange(this.value)"></select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="requiredField" id="txtPName" autocomplete="off" style="text-transform: uppercase" onlytext="50" maxlength="50" data-title="Enter Patient Name" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Age 
                           <input type="radio" checked="checked" id="rdAge" onclick="setAge(this)" name="rdDOB" />   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtAge" class="requiredField" style="width: 33%; float: left" onkeyup="clearDateOfBirth(event);getdob();"   onlynumber="5" max-value="120" autocomplete="off" maxlength="3" data-title="Enter Age" placeholder="Years" />
                            <input type="text" id="txtAge1" class="requiredField" style="width: 33%; float: left" onkeyup="clearDateOfBirth(event);getdob();"  onlynumber="5"  max-value="12" autocomplete="off" maxlength="3" data-title="Enter Age" placeholder="Months" />
                            <input type="text" id="txtAge2" class="requiredField" style="width: 33%; float: left" onkeyup="clearDateOfBirth(event);getdob();" onlynumber="5"  max-value="30" autocomplete="off" maxlength="3" data-title="Enter Age" placeholder="Days" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">DOB <input type="radio"  id="rdDOB" onclick="setDOB(this)" name="rdDOB" />   </label>
                            <b class="pull-right">:</b>                                                      
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDOB" onclick="getdob()" placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" Enabled="false" ></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Gender</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlGender">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value=""></option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            Referred Doctor
                        </div>
                         <div class="col-md-5">

                        <input type="text" id="txtReferDoctor" tabindex="5" value="SELF" data-title="Select Referred Doctor"  />
                            <input type="hidden" id="hftxtReferDoctor" value="1" />
                              </div>

                         <div class="col-md-3">
                            <label class="pull-left">Second Ref.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input  type="text"  id="txtSecondReference" maxlength="50" value="SELF"/>	
              <input type="hidden" id="hfSecondReference" value="1" />	                         
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPAddress" maxlength="50" data-title="Enter Address" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Locality  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlArea"  data-title="Select Locality" ></select>                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> PinCode </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" onlynumber="6"  autocomplete="off"  id="txtPinCode"  maxlength="6"  data-title="Enter PinCode" />                              
                           
                            
                           
                           
                            <input type="hidden" id="txtLedgertransactionNo" />
                            <input type="hidden" id="txtLedgertransactionID" />
                           
                            
                            <input type="hidden" id="txtPatientType" />
                           
                            <input type="hidden" id="hdnMobile" />                           
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">City </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCity"  data-title="Select City" onchange="$onCityChange(this.value)"></select>                              
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">State </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlState"  data-title="Select State" onchange="$onStateChange(this.value)"></select>                                                          
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Country </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlCountry"  data-title="Select Country" onchange="$onCountryChange(this.value)"></select>                                  
                        </div>
                    </div>
                        <div class="row">
                 <div class="col-md-3">
                      <label class="pull-left">Source</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                      <select id="ddlSource" data-title="Select Source">
                   <option value=""></option>
                   <option value="WalkIn">WalkIn</option>
                   <option value="Website">Website</option>
                   <option value="Leaflet">Leaflet</option>
                   <option value="Newspaper">Newspaper</option>
                   <option value="Referral">Referral</option>                   
               </select> 
                      </div>
                          
                 <div class="col-md-3" style="display:none">
                      <label class="pull-left">PRO</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5" style="display:none">
                    <select id="ddlPRO" data-title="Select PRO" class="requiredField" ></select>
       
                      </div>
                             <div class="col-md-3">
                  <label class="pull-left"> SRF Number </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtSRFNumber" maxlength="15" data-title="Enter SRF Number"/>    
               </div>
                     </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">ID Proof No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                              <select id="ddlIdentityType">
                                <option value=""></option>
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
                            <label class="pull-left">Dispatch Mode </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDispatchMode" data-title="Select Dispatch Mode">
                                <option value="0">Select</option>
                                <option value="1" >Email</option>
                                <option value="2">Refer Doctor</option>
                                <option value="3">Courier</option>
                            </select>                        
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> Email</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text"  autocomplete="off"  id="txtEmail"  maxlength="50"  data-title="Enter Email Address" />                              
                        </div>
                    </div>                
                    <div class="row">                                             
                        <div class="col-md-3">
                            <label class="pull-left"></label>
                            
                        </div>
                        <div class="col-md-5">
                                     <input type="checkbox" id="chkIsVip" name="chkIsVip" />VIP        
                        </div>
                         <div class="col-md-3">
                      <label class="pull-left">PassPortNo</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtPassport" maxlength="12" data-title="Enter PassPortNo"/>
                      </div>
                 <div class="col-md-3">
                      <label class="pull-left">Pure HealthID</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtPureHealthID" maxlength="14" data-title="Enter PureHealthID"/>
                      </div>
                    </div>

             <div class="row">
                 <div class="col-md-3">
                      <label class="pull-left">Nationality</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtNationality" maxlength="50" data-title="Enter Nationality" onkeyup="this.value = this.value.replace(/[^a-z]/, '')" />
                      </div>
                 <div class="col-md-3">
                      <label class="pull-left">ESIC/CGHS/ECHS</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtECHS" maxlength="20" data-title="Enter ESIC/CGHS/ECHS"/>
                      </div>
                  <div class="col-md-3">
                      <label class="pull-left">ICMR NO</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtICMRNo" maxlength="14" data-title="Enter ICMR NO"/>
                      </div>
             </div>


            <div class="row">
                     
                      <div class="col-md-3">
                         <label class="pull-left">No. of Children</label>
                         <b class="pull-right">:</b>
                     </div>
                         <div class="col-md-5">
                            <input type="text" id="txtChild" maxlength="10" data-title="No. of Children" />
                         </div>
                      <div class="col-md-3">
                         <label class="pull-left">No. of Son</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                         <input type="text" id="txtSon" maxlength="10" data-title="No. of Son" />
                     </div>
                    
                       <div class="col-md-3">
                         <label class="pull-left">No. of Daughter</label>
                         <b class="pull-right">:</b>
                      </div>  
                   <div class="col-md-5">
                         <input type="text" id="txtDaut" maxlength="10" data-title="Enter No. of Daughter" />
                   </div>

        </div>


             <div class="row">
                     <div class="col-md-3">
                         <label class="pull-left">Pregnancy</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                        <%-- <input type="text" id="txtPreg" maxlength="20" data-title="enter Pregnancy" />--%>


                         <asp:TextBox ID="txtPreg"  placeholder="DD-MM-YYYY" ReadOnly="true" runat="server"   ></asp:TextBox>				
                     </div>
                     <div class="col-md-3">
                         <label class="pull-left">Age of Son</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                         <input type="text" id="txtAgeSon" maxlength="3" data-title="enter Age of Son" />
                     </div>
                     
                     <div class="col-md-3">
                         <label class="pull-left">Age of Doughter</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                         <input type="text" id="txtAgeDaut" maxlength="10" data-title="Enter age of Daughter" />
                     </div>
                     
          </div>
             <div class="row">
                     <div class="col-md-3">
                         <label class="pull-left">PNDT Doctor</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                         <asp:DropDownList ID="ddlPNTDDocotor" runat="server"></asp:DropDownList>
                     </div>
                 <div class="col-md-3">
                  <label class="pull-left"> Remarks </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtRemarks" maxlength="100" data-title="Enter Remarks"/>    
               </div>

         </div>








                    
                    <div class="row" style="display: none" id="divPUPDetail">
                        <div class="col-md-3">
                            <label class="pull-left">PUP Ref No.    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input  type="text"  id="txtPUPRefNo"  disabled="disabled"/>	
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">PUP Contact   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <input  type="text"  id="txtPUPContact" disabled="disabled" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">PUP Mobile   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input  type="text"  id="txtPUPMobile" maxlength="10" disabled="disabled"  />
                        </div>

                    </div>
                    <div class="row" id="divHLMDetail" style="display: none;text-align: left">
                        <div class="col-md-3">
                            <label class="pull-left">HLM Patient Type   </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <select id="ddlHLMType" >
                   <option value=""></option>
                   <option value="General">General</option>
                   <option value="OPD">OPD</option>
                   <option value="IPD">IPD</option>
                   <option value="ICU">ICU</option>
                   <option value="Emergency">Emergency</option>
               </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">OPD/IPD No   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" maxlength="10" id="txtHLMOPDIPNo" />		
                           
                        </div>
                    </div>
                    <div class="row" style="display: none" id="divCorporate">
                        <div class="col-md-3">
                            <label class="pull-left">ID Type   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCorporateIDType">
                                <option value="ID Card">ID Card</option>
                                <option value="Letter">Letter</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">ID Card   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" maxlength="50" id="txtCorporateIDCard" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"></label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                    <div class="col-md-3">
			         <div class="row">
				         <div class="col-md-24">
					           <img id="imgPatient" alt="Patient Image" src="../../App_Images/no-avatar.gif" style="border-style: double;width:114px;height:114px;display:
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
		            </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
        <div class="row">
            <div class="col-md-24" style="text-align: center">
                <input type="button" id="btnSave" value="Update" onclick="updatedata()" tabindex="9" class="savebutton" />
                <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" />
            </div>
        </div>
    </div>
    </div>
    <script type="text/javascript">

        var clearDateOfBirth = function (e) {
            var inputValue = (e.which) ? e.which : e.keyCode;
            if (inputValue == 46 || inputValue == 8) {
                $(e.target).val('');
                $('#txtDOB').val('').prop('disabled', false);

            }
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
        var $bindState = function (CountryID, con, callback) {
            var $ddlState = $('#ddlState');
            $('#ddlState,#ddlCity,#ddlArea').find('option').remove();
            $('#ddlState,#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                if (con == 0)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: 0 });
                else
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });

                callback($ddlState.val());
            });
        }

        var $bindCity = function (StateID, con, callback) {
            var $ddlCity = $('#ddlCity');
            $('#ddlCity,#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                if (con == 0)
                    $ddlCity.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: 0 });
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
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true, selectedValue: 0 });
                else
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });

                callback($ddlArea.val());
            });
        }
        var $onTitleChange = function (gender) {
            var Gender = $('#ddlGender').val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                $('#ddlGender').val("").prop('disabled', false);
            }
            else {
                $('#ddlGender').val(gender).prop('disabled', true);
            }
           
        }
       

        $(function () {
            $bindTitle(function () {
            });
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
                }

                //List of special characters you want to restrict
                if (keychar == "#" || keychar == "/" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                    return false;
                else
                    return true;
            });
            $("#txtLabNo").keydown(

                 function (e) {
                     var key = (e.keyCode ? e.keyCode : e.charCode);
                     if (key == 13) {
                         e.preventDefault();
                         getdata();
                     }
                     else if (key == 9) {

                         getdata();
                     }
                 });
            $("#txtPreg").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    //var dob = new Date(value);
                    var dob = value;
                    getAge(dob, today);
                }
            }).attr('readonly', 'readonly');

            $("#txtDOB").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    //var dob = new Date(value);
                    var dob = value;
                    getAge(dob, today);
                }
            }).attr('readonly', 'readonly');
            function getAge(birthDate, ageAtDate) {
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
                $('#txtAge').val(years);
                $('#txtAge1').val(months);
                $('#txtAge2').val(days);

            }
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#txtReferDoctor")
                // don't navigate away from the field on tab when selecting an item
                .bind("keydown", function (event) {
                    if (event.keyCode === $.ui.keyCode.TAB &&
                        $(this).autocomplete("instance").menu.active) {
                        event.preventDefault();
                    }
                    //   $("#hftxtReferDoctor").val('');
                })
                .autocomplete({
                    source: function (request, response) {
                        $.getJSON("../Common/CommonJsonData.aspx?cmd=ReferDoctor", {
                            docname: extractLast(request.term), centreid: $('#txtCentreID').val()
                        }, response);
                    },
                    search: function () {

                        var term = extractLast(this.value);
                        if (term.length < 2) {
                            return false;
                        }
                    },
                    focus: function () {
                        return false;
                    },
                    select: function (event, ui) {


                        this.value = ui.item.label.split('#')[0].trim();

                        $("#hftxtReferDoctor").val(ui.item.value);

                       
                        return false;
                    }
                });
            $bindTitle(function () {
            });
        });
        var $bindTitle = function (callback) {
            serverCall('../Common/Services/CommonServices.asmx/bindTitleWithGender', {}, function (response) {
                var $ddlTitle = $('#ddlTitle');
                $ddlTitle.bindDropDown({ data: JSON.parse(response), valueField: 'gender', textField: 'title' });
                callback($ddlTitle.val());
            });
        }
        var $bindStateCityLocality = function (con, callback,selectedCountryID, selectedStateID, selectedCityID, selectedLocalityID) {
            var $ddlCountry = $('#ddlCountry'); var ddlState = $('#ddlState'); var $ddlCity = $('#ddlCity'); var $ddllocality = $('#ddlArea');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: selectedCountryID, StateID: selectedStateID, CityID: selectedCityID, IsStateBind: 1, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 1, IsLocality: 1 }, function (response) {
                if (con == 1) {
                    $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: selectedCountryID, showDataValue: 1 });

                }
                ddlState.bindDropDown({ data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: selectedStateID });
                $ddlCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: selectedCityID });
                $ddllocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: selectedLocalityID });
                callback($ddllocality.val());
            });
        }

        function getdob() {
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
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar",
            "Apr", "May", "Jun", "Jul", "Aug", "Sep",
            "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            $('#txtDOB').val(xxx);


        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }
 

        function setDOB(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#txtDOB').attr("disabled", false);
                $('#txtAge,#txtAge1,#txtAge2').attr("disabled", true);
                $('#txtDOB').addClass('requiredField');
                $('#txtAge,#txtAge1,#txtAge2').removeClass('requiredField');

            }
        }
        function setAge(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#txtDOB').attr("disabled", true);
                $('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);
                $('#txtDOB').removeClass('requiredField');
                $('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
            }
        }
            
        function $searchOnEnter() {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                if (e.target.id == 'txtLabNo') {
                    if (e.target.value.length == "") {
                        toast('Info', "Please Enter Lab No.", '');
                        return;
                    }

                }

                getdata(e);
            }
        }
        function getdata() {

            if ($.trim($('#txtLabNo').val()) == "") {
                toast("Error", "Please Enter Lab No.");
                $('#txtLabNo').focus();
                return;

            }
            $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            serverCall('../Lab/Services/LabBooking.asmx/GetPatientInfoData', { LabNo: $('#txtLabNo').val() }, function (response) {
                pdata = $.parseJSON(response);
                if (pdata.length == 0) {
                    clearForm();
                    toast("Error", 'No Record Found..!', "");
                }
                else if (pdata == "-1") {
                    $('.savebutton,.resetbutton').hide();
                    toast("Error", 'Time is expired . You cannot edit the Prescription..!', "");
                }
                else {
                    clearForm();
                    //  if (pdata[0].TotalApprovedTest > 0) {
                    //      $("#lblMsg").text('Patient Demographical Details Not Updated Because  Test Got Approved...!');
                    //      $('.savebutton,.resetbutton').hide();
                    //  }
                    //  else

                 //  if (pdata[0].BillTimeDiff > 30 && '<%=Session["RoleID"]%>' == '9') {
                    //    $("#lblMsg").text('You can Edit Patient within 30 minutes of Billing...!');
                    //    $('.savebutton,.resetbutton').hide();
                    //}
                     if (pdata[0].BillTimeDiff > 10080 && '<%=Session["RoleID"]%>' == '2') {
                        $("#lblMsg").text('You can Edit Patient within 7 Days of Billing...!');
                        $('.savebutton,.resetbutton').hide();
                    }
                    else {
                        $("#lblMsg").text('');
                        $('.savebutton,.resetbutton').show();
                    }
                    $bindPRO(pdata[0].PROID);
                    $('#txtPassport').val(pdata[0].PassportNo);
                    $('#txtPureHealthID').val(pdata[0].PureHealthID);
                    $('#txtRemarks').val(pdata[0].Remarks);
                    $('#txtICMRNo').val(pdata[0].ICMRNo);
                    $('#txtECHS').val(pdata[0].ECHS);
                    $('#txtNationality').val(pdata[0].Nationality);
                    $("#ddlTitle").removeAttr('disabled');
                    $('#ddlGender').attr('disabled', false);
                    $('#rdAge').prop("checked", true);
                    if (pdata[0]["DiscountID"] == "0") {
                        $('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);

                    }
                    else {
                        $('#txtAge,#txtAge1,#txtAge2').attr("disabled", true);

                    }
                    $('#txtCentreID').val(pdata[0]["CentreID"]);
                    $('#txtLabNo').val(pdata[0]["LedgerTransactionNo"]);
                    $('#txtLedgertransactionID').val(pdata[0]["LedgerTransactionID"]);
                    $('#txtLedgertransactionNo').val(pdata[0]["LedgerTransactionNo"]);
                    $('#lblPatient_ID').html(pdata[0]["Patient_ID"]);
                    $("#txtUHIDNo").val(pdata[0]["Patient_ID"]);
                    $("#txtLabNo").val(pdata[0]["LedgerTransactionNo"]);
                    $($('#ddlTitle option').filter(function () { return this.text == pdata[0]["Title"] })[0]).prop('selected', true).attr('disabled', 'disabled');
                    $("#txtDOB").val(pdata[0]["dob"]);
                    $("#txtPName").val(pdata[0]["PName"].toUpperCase());
                    if (pdata[0]["PinCode"] != "0") {
                        $("#txtPinCode").val(pdata[0]["PinCode"]);
                    }
                    $("#txtSRFNumber").val(pdata[0]["SRFNo"]);
                    $("#txtMobileNo").val(pdata[0]["Mobile"]);
                    $("#hdnMobile").val(pdata[0]["Mobile"]);
                    $("#txtAge").val(pdata[0]["AgeYear"]);
                    $("#txtAge1").val(pdata[0]["AgeMonth"]);
                    $("#txtAge2").val(pdata[0]["AgeDays"]);
                    $("#txtEmail").val(pdata[0]["Email"]);
                    $("#txtPAddress").val(pdata[0]["House_No"]);
                    $("#ddlGender").val(pdata[0]["Gender"]);

                    $("#txtChild").val(pdata[0].Children);
                    $("#txtSon").val(pdata[0].Son);
                    $("#txtDaut").val(pdata[0].Daughter);
                    $("#txtPreg").val(pdata[0].Pregnancydate);
                    $("#txtAgeSon").val(pdata[0].AgeSon);
                    $("#txtAgeDaut").val(pdata[0].AgeDaughter);
                    $("#ddlPNTDDocotor").val(pdata[0].PndtDoctorId);


                    $bindStateCityLocality("1", function () { }, pdata[0]["CountryID"], pdata[0]["StateID"], pdata[0]["CityID"], pdata[0]["LocalityID"]);

                    if (pdata[0]["PatientIDProof"] != "") {
                        $("#ddlIdentityType").val(pdata[0]["PatientIDProof"]);
                        $("#txtIdProofNo").val(pdata[0]["PatientIDProofNo"]);
                    }
                    $("#ddlSource").val(pdata[0]["PatientSource"]);

                    $("#txtPUPContact").val(pdata[0]["PUPContact"]);

                    $("#txtPUPMobile").val(pdata[0]["PUPMobileNo"]);
                    $("#txtPUPRefNo").val(pdata[0]["PUPRefNo"]);

                    $("#txtPatientType").val(pdata[0]["PatientType"]);
                    if (pdata[0]["PatientType"] == "PUP") {
                        $("#divPUPDetail").show();
                    }
                    else {
                        $("#divPUPDetail").hide();
                    }
                    if (pdata[0]["PatientType"] == "HLM") {
                        $("#divHLMDetail").show();
                    }
                    else {
                        $("#divHLMDetail").hide();
                    }
                    if (pdata[0]["DispatchModeID"] != "0") {
                        $("#ddlDispatchMode").val(pdata[0]["DispatchModeID"]);
                    }
                    else {
                        $("#ddlDispatchMode").val(0);
                    }

                    if (pdata[0]["HLMPatientType"] != "") {
                        $("#ddlHLMType").val(pdata[0]["HLMPatientType"]);
                        $("#txtHLMOPDIPNo").val(pdata[0]["HLMOPDIPDNo"]);
                    }
                    if (pdata[0]["VIP"] == "1")
                        $('#chkIsVip').prop("checked", true);
                    else
                        $('#chkIsVip').prop("checked", false);

                    $('#txtReferDoctor').val(pdata[0]["DoctorName"]);
                    $('#hftxtReferDoctor').val(pdata[0]["Doctor_ID"]);


                    if (pdata[0].IsMobileVerified == "1") {
                        $('#imgVerified').show();
                    }
                }
                $('#btnSearch').removeAttr('disabled').val('Search');
            });
                
        }
        var $bindPRO = function (callback) {
            $ddlPRO = jQuery('#ddlPRO');
            jQuery('#ddlPanel option').remove();
            serverCall('../Lab/Services/LabBooking.asmx/GetPRO', {}, function (response) {
                if (JSON.parse(response) != "") {
                    $ddlPRO.bindDropDown({  data: JSON.parse(response), valueField: 'PROID', textField: 'PROName', isSearchAble: true,selectedValue:callback });
                }
                else
                    $ddlPRO.append(jQuery("<option></option>").val("0").html("--No PRO--")).chosen('destroy').chosen();
            });
        }
        function clearForm() {
            $('#ddlTitle,#ddlGender,#ddlSource,#ddlHLMType,#ddlIdentityType,#ddlDispatchMode').prop('selectedIndex', 0);
            $('#hftxtReferDoctor').val('');
            $("#txtLedgertransactionID,#txtLedgertransactionNo,#txtCentreID").val("");
            $('#hftxtReferDoctor').val('');
            $('#chkIsVip').prop("checked", false);
            $('#lblPatient_ID').html('');              
            $('#txtMobileOTP,#imgVerified').hide();
         
            $('#hdnMobile').val('');           
            $("input[type=text]").val('');
        }
        function validation() {           
            if ($('#txtMobileNo').val().length == 0 && $("#txtPatientType").val() != "PUP") {
             //   toast("Error", "Please Enter Mobile No", "");
               // $('#txtMobileNo').focus();
              //  return false;           
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
            if (ageyear == "0" && agemonth == "0" && ageday == "0") {
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
                    toast("Error", "Incorrect Email ID", "");
                    $('#txtEmail').focus();
                    return false;
                }
            }
            return true;
        }
        function updatedata() {
            if (validation() == false) {
                return;
            }
            var patientdata = patientmaster();
            var ledgerdata = ledgertransaction();
            var patientotp = OTPDetail();
            
            $("#btnSave").attr('disabled', true).val("Submiting...");
            serverCall('Lab_PrescriptionOPDEditInfo.aspx/UpdatePatientInfo', { PatientData: patientdata, LTData: ledgerdata, patientOTP: patientotp }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $('#btnSave').attr('disabled', false).val("Update");
                    clearForm();
                    toast("Success", "Record Updated..!", "");
                   
                }
                else {
                    toast("Error", $responseData.response, "");
                    $(btnSave).removeAttr('disabled').val('Update');
                
                }
                $modelUnBlockUI(function () { });
            });

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
            var dataPLO = new Object();
            dataPLO.Patient_ID = $('#lblPatient_ID').html();            
            dataPLO.Title = $('#ddlTitle option:selected').text();
            dataPLO.PName = $('#txtPName').val();
            dataPLO.Gender = $("#ddlGender option:selected").text();
            dataPLO.AgeYear = ageyear;
            dataPLO.AgeMonth = agemonth;
            dataPLO.AgeDays = ageday;
            dataPLO.Age = age;
            dataPLO.TotalAgeInDays = ageindays;
            dataPLO.Mobile = $('#txtMobileNo').val();

            if ($('#txtPinCode').val() == "") {
                dataPLO.Pincode = "0";
            }
            else {
                dataPLO.Pincode = $('#txtPinCode').val();
            }
            dataPLO.Country = $('#ddlCountry option:selected').text();
            dataPLO.State = $('#ddlState option:selected').text();
            dataPLO.City = $('#ddlCity option:selected').text();
            dataPLO.Locality = $('#ddlArea option:selected').text();
            dataPLO.House_No = $('#txtPAddress').val();
            dataPLO.Email = $('#txtEmail').val();
            dataPLO.DOB = $('#txtDOB').val();
            dataPLO.CountryID = $('#ddlCountry option:selected').val();
            dataPLO.StateID = $('#ddlState option:selected').val();
            dataPLO.CityID = $('#ddlCity option:selected').val();
            dataPLO.LocalityID = $('#ddlArea option:selected').val();

            return dataPLO;




        }
         function ledgertransaction() {
             var objLT = new Object();

             if ($('#txtIdProofNo').val() != "") {
                 objLT.PatientIDProof = $('#ddlIdentityType option:selected').val();
                 objLT.PatientIDProofNo = $('#txtIdProofNo').val();
             }
             else {
                 objLT.PatientIDProof = "";
                 objLT.PatientIDProofNo = "";
             }
             objLT.PatientSource = $('#ddlSource').val();
             if (($('#chkIsVip').prop('checked') == true)) {
                 objLT.VIP = "1";
            }
            else {
                 objLT.VIP = "0";
            }
       
          
             objLT.HLMPatientType = $('#ddlHLMType').val();
             objLT.HLMOPDIPDNo = $('#txtHLMOPDIPNo').val();
         
            if ($("#hftxtReferDoctor").val() == "") {
                objLT.Doctor_ID = "1";
                objLT.DoctorName = "SELF";
            }
            else {
                objLT.Doctor_ID = $("#hftxtReferDoctor").val();
                objLT.DoctorName = $('#txtReferDoctor').val();
            }
            objLT.DispatchModeID = $('#ddlDispatchMode option:selected').val();
            objLT.DispatchModeName = $('#ddlDispatchMode option:selected').text();
            objLT.LedgerTransactionNo = $('#txtLedgertransactionNo').val();
            objLT.LedgerTransactionID = $('#txtLedgertransactionID').val();
            objLT.PROID = jQuery.trim(jQuery('#ddlPRO').val());
            objLT.SRFNo = jQuery('#txtSRFNumber').val().trim();
            objLT.PassPortNo = jQuery.trim(jQuery('#txtPassport').val());

            objLT.Children = jQuery.trim(jQuery('#txtChild').val());
            objLT.Son = jQuery.trim(jQuery('#txtSon').val());
            objLT.Daughter = jQuery.trim(jQuery('#txtDaut').val());
            objLT.Pregnancydate = jQuery.trim(jQuery('#txtPreg').val());
            objLT.AgeSon = jQuery.trim(jQuery('#txtAgeSon').val());
            objLT.AgeDaughter = jQuery.trim(jQuery('#txtAgeDaut').val());
            objLT.PndtDoctorId = jQuery.trim(jQuery('#ddlPNTDDocotor').val());
            objLT.PureHealthID = jQuery.trim(jQuery('#txtPureHealthID').val());
            objLT.Remarks = jQuery.trim(jQuery('#txtRemarks').val());



            return objLT;

     
        }
    </script>
    <%--shat--%>
    <script type="text/javascript">

        function OTPDetail() {
            var otpd = new Object();
            otpd.OTPUniqID = $('#txtotppatientuni').val();
            otpd.OTPVal = $('#txtMobileOTP').val();
            otpd.OTPRequired = $('#hdnIsOTPRequired').val();
            return otpd;

        }

        function SendOTP() {
            serverCall('Lab_PrescriptionOPDEditInfo.aspx/SendPatientOTP', { mobileno: $('#txtMobileNo').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.response.split('#')[0] == "1") {
                    toast("Success", "OTP Sent.!", "");
                    $('#txtotppatientuni').val($responseData.response.split('#')[1]);
                    $('#txtMobileOTP').show();
                    $('#hdnIsOTPRequired').val('1');
                    $modelUnBlockUI(function () { });
                }
                else {
                    toast("Error", $responseData.response, "");
                    $modelUnBlockUI(function () { });
                }

            });
        }

        var OTPMobile = function (e) {
               
            var key = (e.keyCode ? e.keyCode : e.charCode);
            if ($('#txtMobileNo').val().length == 10) {
                if ($('#txtMobileNo').val() != $('#hdnMobile').val()) {
                 //   SendOTP();
                    $('#imgVerified').hide();
                }

            }
        }
    </script>
      </form>
</body>
</html>

