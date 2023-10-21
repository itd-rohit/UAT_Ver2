<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" Async="true"  AutoEventWireup="true" CodeFile="Lab_PrescriptionOPD.aspx.cs" Inherits="Design_Lab_Lab_PrescriptionOPD" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server" >
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
        <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/webcamjs/webcam.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/InvalidContactNo.js"></script>
        
     <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
        <%: Scripts.Render("~/bundles/confirmMinJS") %>
        <%: Scripts.Render("~/bundles/PostReportScript") %>
    <div id="Pbody_box_inventory">
		<Ajax:ScriptManager ID="sc1" runat="server">           
		</Ajax:ScriptManager>
    <div class="POuter_Box_Inventory" style="text-align: center">
        <div class="row"><div class="col-md-24">
            <b><asp:Label ID="lblheader" runat="server" Text="New Registration"></asp:Label></b>
			<span id="spnError" ></span>
        <asp:TextBox ID="txtappointment" style="display:none"  Enabled="false" Width="100px" runat="server"></asp:TextBox>        
            <input type="button" id="btnsearchappointment" onclick="searchappointmentData()" value="SearchAppointment" class="searchbutton" style="display:none" />
                         </div> </div>
			
		</div>
    <div class="POuter_Box_Inventory" style="text-align: center">
    <div id="PatientDetails">		 
		 <div class="row" style="margin-top: 0px;">
		 <div class="col-md-21" >					
	     <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:DropDownList ID="ddlCentre" runat="server"  CssClass="ddlCentre chosen-select chosen-container" onchange="$getCentreData(0,function(){})"></asp:DropDownList>		 		 
		   </div>
		   
		   <div class="col-md-3">
			   <label class="pull-left">Client Name</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                <select id="ddlPanel"  data-title="Select Rate Type"  onchange="$showPUPData('0')"></select>			 
		   </div>
		   <div class="col-md-3">
			   <label class="pull-left">Patient Type  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
				<asp:DropDownList ID="ddlPatientType" runat="server"   CssClass="ddlPatientType chosen-select chosen-container" onchange="setdiscountoption()();">
				</asp:DropDownList>
		   </div>
	  </div>
	     <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Mobile No.</label>
			  <b class="pull-right">:</b>
		   </div>		  
		   <div class="col-md-5">
			    <input id="txtMobileNo"  type="text"  allowFirstZero onkeyup="previewCountDigit(event,function(e){$patientSearchOnEnter(e)});" onblur="$patientSearchOnEnter(event);"   data-title="Enter Contact No. (Press Enter To Search)" onlynumber="10"  TabIndex="1"  autocomplete="off"  />                          
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left">UHID</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <input type="text" id="txtUHIDNo"  autocomplete="off" patientAdvanceAmount="0"     maxlength="15"  data-title="Enter UHID No." onkeyup="$patientSearchOnEnter(event);"/>
						<span id="spnUHIDNo" style="display:none"></span> 
		   </div>
		   <div class="col-md-3 "><label class="pull-left">PreBooking&nbsp;No. </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">	
                <input type="text" id="txtPreBookingNo" maxlength="15" data-title="Enter PreBooking No."/>						 				              
		   </div>	 
	  </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Patient Name</label>
			  <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-2  col-xs-10">
               <select id="ddlTitle" TabIndex="2" onchange="$onTitleChange(this.value)" ></select>
              <input type="text" id="txtothertitle"  class="requiredField" maxlength="9" placeholder="enter title" style="display:none" />					
		   </div>
		  <div  class="col-md-3  col-xs-14">
			  <input type="text" id="txtPName"  class="requiredField" TabIndex="3" autocomplete="off"  style="text-transform:uppercase"   maxlength="50"  data-title="Enter Patient Name" />
		   </div>
		   <div class="col-md-3 ">
			   <label class="pull-left">Age           
  <input type="radio" checked="checked" id="rdAge" onclick="setAge(this)" name="rdDOB" />      </label>                           
                   
			   <b class="pull-right">:</b>
		   </div>		   
  <div class="col-md-5">		
                     <input type="text" id="txtAge" TabIndex="4" style="width:33%;float:left" onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();"   class="requiredField"   max-value="120"  autocomplete="off"  maxlength="3" data-title="Enter Age"   placeholder="Years"/>          
                     <input type="text" id="txtAge1" style="width:33%;float:left" onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();"  class="requiredField"   max-value="12"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Months"/>                      
                     <input type="text" id="txtAge2" style="width:33%;float:left"  onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();" class="requiredField"  max-value="30"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Days"/>							         
      </div>
		   <div class="col-md-3"><label class="pull-left">DOB            
  <input type="radio"  id="rdDOB" onclick="setDOB(this)" name="rdDOB" />              
               </label>
			   <b class="pull-right">:</b>
		   </div>                 
		   <div class="col-md-5">
						<asp:TextBox ID="txtDOB" onclick="$getdob()" placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" Enabled="false" ></asp:TextBox>					
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
                    <option value="Trans">Transgender</option>
                    <option value=""></option>
                </select>               
               </div>
     <div class="col-md-3">
          <label class="pull-left">Referred Doctor    </label>
			   <b class="pull-right">:</b>
         </div>
          <div class="col-md-4">
               <input  type="text"   id="txtReferDoctor" TabIndex="5" value="SELF"  data-title="Select Referred Doctor" maxlength="50" class="requiredField"/>
                <input type="hidden" id="hftxtReferDoctor" value="1" />			
              </div>
             <div class="col-md-1">
              <input type="button" class="ItDoseButton" value="New" id="btnAddReferDoctor"  title="Click To Add New Refer Doctor"  onclick="$addNewDoctorReferModel('Add Refer Doctor', '0')" />
              </div>
     <div class="col-md-3">
          <label class="pull-left">Second Ref.</label>
			   <b class="pull-right">:</b>
         </div>
          <div class="col-md-4">
              <input  type="text"  id="txtSecondReference" maxlength="50" value="SELF"/>	
              <input type="hidden" id="hfSecondReference" value="1" />		
              </div>
              <div class="col-md-1">
              <input type="button" class="ItDoseButton" value="New" id="btnAddSecondRef" title="Click To Add New Second Reference"  onclick="$addNewDoctorReferModel('Add Second Reference', '1')" />
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
        <label class="pull-left">PinCode</label>
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
                      <label class="pull-left">Source</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <select id="ddlSource" data-title="Select Source" >
                   <option value=""></option>
                   <option value="WalkIn">WalkIn</option>
                   <option value="Website">Website</option>
                   <option value="Leaflet">Leaflet</option>
                   <option value="Newspaper">Newspaper</option>
                   <option value="Referral">Referral</option>                   
                   </select> 
                      </div>
                 <div class="col-md-3">
                      <label class="pull-left" style="color:red;font-size:12px;"><b>Barcode No</b></label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtBarcodeno"  style="text-transform:uppercase" maxlength="50" style="border-bottom-color: green !important;" data-title="Enter BarcodeNo"/>
                      </div>
                 <div class="col-md-3">
                      <label class="pull-left">PRO</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                    <select id="ddlPRO" data-title="Select PRO" class="requiredField" ></select>
       
                      </div>
                     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">  ID Proof No.  </label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-2">
               <select id="ddlIdentityType" data-title="Select ID Proof No." onchange="$IdentityType()"> 
                   <option value="0" data-type="">Select</option>        
                   <option value="1" data-type="AadhaarCard">Aadhaar Card</option>
                   <option value="2" data-type="CardNo">Card No.</option>
                   <option value="3" data-type="DLNo">DL No.</option>
                   <option value="4" data-type="VoterCard">Voter Card</option>
                   <option value="5" data-type="PassportNo">Passport No.</option>
                   <option value="6" data-type="PanCardNo">Pan Card No.</option>
               </select>           
               </div>
                  <div class="col-md-3">
                      <input type="text" id="txtIdProofNo" disabled="disabled"  maxlength="20" data-title="Enter ID Proof No." style="text-transform:uppercase"  onkeypress="$IdProofValidate(event)" onblur="$IdProofNo()"/>                    
                      </div>
               <div class="col-md-3">
        <label class="pull-left"> Dispatch Mode </label>
         <b class="pull-right">:</b>
         </div>
             <div class="col-md-5">
              <select id="ddlDispatchMode" data-title="Select Dispatch Mode" onchange="$dispatchMode()">
                   <option value="0">Select</option>
                   <option value="1">Email</option>
                   <option value="2">Refer Doctor</option>
                   <option value="3">Courier</option>                                    
               </select>           
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
			   <label class="pull-left">Visit Type</label>
			  <b class="pull-right">:</b>
		   </div>
       <div class="col-md-3">
          <select id="ddlVisitType" data-title="Select Visit Type" onchange="$showHomeCollectionOption()" >
                   <option value="Center Visit">Center Visit</option>
                   <option value="Home Collection">Home Collection</option>               
               </select>   
	   </div>
       <div class="col-md-2">
           <input type="checkbox" id="chkIsVip" name="chkIsVip" />VIP                  
          </div>
       <div class="col-md-3 divFieldBoy" style="display:none" >
            <label class="pull-left">  FieldBoy  </label>
			  <b class="pull-right">:</b>
            </div>
       <div class="col-md-5 divFieldBoy" style="display:none">
              <select id="ddlFieldBoy" data-title="Select FieldBoy" class="requiredField" ></select>
           </div>
       <div class="col-md-3 divFieldBoy" style="display:none">
                  <label class="pull-left"> Coll. Date Time </label>
			  <b class="pull-right">:</b>
                 </div>
       <div class="col-md-3 divFieldBoy" style="display:none">
                <input type="text" id="txtCollectionDate" class="setCollectionDate requiredField" maxlength="100" data-title="Enter Sample Collection Date"/>    
               </div>
       <div class="col-md-2 divFieldBoy" style="display:none">
                  <asp:TextBox ID="txtCollectionTime" runat="server" data-title="Enter Sample Collection Time" CssClass="requiredField"></asp:TextBox>                                  
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" Enabled="True" AutoComplete="true" 
    TargetControlID="txtCollectionTime"  AcceptAMPM="True"></cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtCollectionTime"  ControlExtender="masTime" IsValidEmpty="false" InvalidValueMessage=""  ></cc1:MaskedEditValidator>                 
               </div>            
 </div>             
	  <div class="row">
             <div class="col-md-3">
			 <label class="pull-left">Other.Ref/Institutor</label>
			  <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
 <input type="text" id="txtOtherLabRefNo" maxlength="50" data-title="Enter Other Lab Reference No."/>
			   <input type="text" id="txtDiagnosis" maxlength="100" data-title="Enter Diagnosis" style="display:none"/>
		   </div>      
             <div class="col-md-3">
			  <label class="pull-left">Clinical History</label>
			  <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
              			<input type="text" id="txtClinicalHistory" maxlength="50" data-title="Enter Clinical History"/>	 
		   </div>
           <div class="col-md-3">
                  <label class="pull-left"> Remarks </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtRemarks" maxlength="100" data-title="Enter Remarks"/>    
               </div>
             </div>
      <div class="row" style="display:none" id="divPUPDetail">
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
      <div class="row" style="display:none" id="divHLMDetail">
             <div class="col-md-3">
			   <label class="pull-left">HLM Patient Type   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <select id="ddlHLMType" class="requiredField" data-title="HLM Patient Type">
                   <option value=""></option>
                   <option value="General">General</option>
                   <option value="OPD">OPD</option>
                   <option value="IPD">IPD</option>
                   <option value="ICU">ICU</option>
                   <option value="Emergency">Emergency</option>
               </select>			 			 
		   </div>
             <div class="col-md-3">
			   <label class="pull-left">OPD/IPD No.</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <input type="text" maxlength="10" id="txtHLMOPDIPNo" class="requiredField" data-title="OPD/IPD No."/>			 
		   </div>
     <div class="col-md-3">
			   <label class="pull-left">   </label>			   
		   </div>
		   <div class="col-md-5">			  			 
		   </div>
             </div>
      <div class="row divCorporate" style="display:none" >
             <div class="col-md-3">
			   <label class="pull-left">ID Type</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <select id="ddlCorporateIDType" onchange="$CorporateIDType()">  
                   <option selected="selected" value="0" >Select</option>              
                   <option value="ID Card">ID Card</option>
                   <option value="Letter">Letter</option>                  
               </select>			 			 
		   </div>
             <div class="col-md-3">
			   <label class="pull-left">ID Card</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <input type="text" maxlength="50" id="txtCorporateIDCard"   />		 
		   </div>
     <div class="col-md-3 divGovtPanel" style="display:none">
			   <label class="pull-left">Govt. Type    </label>	
         <b class="pull-right">:</b>	   
		   </div>
		   <div class="col-md-5 divGovtPanel" style="display:none">			   		
               <select id="ddlGovPanelType" class="requiredField">
                   <option selected="selected" value="0">Select</option>
                    <option  value="Service">Service</option>
                    <option  value="Pensioner">Pensioner</option>
               </select> 
		   </div>
             </div>
       <div class="row divCardCorporate" style="display:none" >
           <div class="col-md-3">
			   <label class="pull-left">Card Hol. Name   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <input type="text" id="txtCardHolderName" style="text-transform:uppercase" autocomplete="off"  maxlength="100" data-title="Card Holder Name" class="requiredField"/>
               </div>
             <div class="col-md-3">
			   <label class="pull-left">Card Holder Rel.   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <select id="ddlCardHolderRelation" class="requiredField" data-title="Relation With Card Holder Name" onchange="$cardHolderRelation()"></select>
               </div>    
	  </div> 
             <div class="row divSRF">
                  <div class="col-md-3">
                  <label class="pull-left"> SRF Number </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtSRFNumber" maxlength="15" data-title="Enter SRF Number"/>
               </div>
                 <div class="col-md-3">
                      <label class="pull-left">PassPortNo</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtPassport" maxlength="50" data-title="Enter PassPortNo"/>
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
                   <input type="text" id="txtNationality" maxlength="10" data-title="Enter Nationality"/>
                      </div>
                 <div class="col-md-3">
                      <label class="pull-left">ESIC/CGHS/ECHS</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtECHS" maxlength="50" data-title="Enter ESIC/CGHS/ECHS"/>
                      </div>
                  <div class="col-md-3">
                      <label class="pull-left">ICMR NO</label>
         <b class="pull-right">:</b>
         </div>
                  <div class="col-md-5">
                   <input type="text" id="txtICMRNo" maxlength="14" data-title="Enter ICMR NO"/>
                      </div>
             </div>

             </div>
		 <div class="col-md-3">
			 <div class="row">
                   <div class="col-md-24">
                        <asp:TextBox ID="txtHomeCollection" placeholder="HomeCollection" runat="server" data-title="HomeCollection" ></asp:TextBox>  
                       <span id="spnMembershipCardNo" style="display:none;"></span>
                       <span id="spnMembershipCardID" style="display:none;"></span>
                       <span id="spnIsSelfPatient" style="display:none;"></span> 
                       <input type="text"  id="txtMemberShipCardNo" placeholder="Membership Card"  data-title="Press Enter To Search" onkeyup="$patientSearchOnEnter(event);"
                           <%  if (Resources.Resource.MemberShipCardApplicable == "0")
                               {%> style="display:none;" value=""
                                   <%}%>
                            />
                    </div>
				   <div class="col-md-24">
				 <input id="OldPatient" class="ItDoseButton" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search"  style="display:<%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" />
					 </div>				 
			 </div>
			<div class="row">
				 <div class="col-md-24">
					   <img id="imgPatient" alt="Patient Image" src="../../App_Images/no-avatar.gif" style="border-style: double;width:100%;height:100%;display:
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
			 <div class="row">
				 <div class="col-md-24">
                     <span id="spnFileName"  style="display:none"></span>
					 <button onclick="showDocumentMaster()" id="btnDocumentMaster" type="button" style="width:100%" ><span id="spnDocumentCounts"  class="badge badge-grey">0</span><b>Printer Upload</b> </button>					
				 </div>
			 </div>
			 	<div class="row">
				 <div class="col-md-24">
                     
					 <button onclick="$showManualDocumentMaster()" id="btnMaualDocument" type="button" style="width:100%" ><span id="spnDocumentMaualCounts"  class="badge badge-grey">0</span><b>Manual Upload</b> </button>					
				 </div>
			 </div>				  
		 </div>	
	 </div>         
</div>	
        </div>
        <div class="POuter_Box_Inventory">
			<div class="row" style="margin-top: 0px;">
                <div class="col-md-8">
                    <div class="row">
						<div style="padding-right: 0px;" class="col-md-18">
							<label class="pull-left">                               
								<input id="rdbItem_1" type="radio" name="labItems" value="1" onclick="$clearItem(function () { })"   />
								<label for="rdbItem_1">By Name</label>
								<input id="rdbItem_0" type="radio" name="labItems" value="0" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_0">By Code </label>
								<input id="rdbItem_2" type="radio" name="labItems" value="2" onclick="$clearItem(function () { })" checked="checked" />
								<label for="rdbItem_2">InBetween</label>								
							</label>
						</div>		
                        <div class="col-md-6">
                            <button style="width: 100%; padding: 0px;display:none" class="label label-important" type="button"><b>Count :</b><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;" class="badge badge-grey">0</span></button>
							 <button style="width: 100%; padding: 0px;"  class="label label-important" type="button" onclick="$openinvestigation()">Investigation</button>
						</div>					                           												
					</div>
                    <div class="row" style="display:none">						
						<div style="padding-left: 15px;" class="col-md-24">
                             <asp:ListBox ID="lstCategory" runat="server" CssClass="multiselect"  onchange="$bindDep()" SelectionMode="Multiple"></asp:ListBox>
                            </div>
                          </div>
                  
                     <div class="row" style="display:none">
						<div style="padding-left: 15px;" class="col-md-24">
                             <asp:ListBox ID="lstDepartment" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                            </div>
                          </div>
                    <div class="row">						
						<div style="padding-left: 15px;" class="col-md-24">
							<input type="text" id="txtInvestigationSearch" TabIndex="6" title="Enter Search Text"  autocomplete="off"  />
						</div>					
					</div>
                    </div>
                <div class="col-md-16">
					<div style=" height: 125px; overflow-y: auto; overflow-x: hidden;">
                        <asp:Label runat="server" ID="lblTestCount" style="font-weight:bold;">Test Count:0</asp:Label>
						<table id="tb_ItemList" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
							<thead>
								<tr id="LabHeader">
									<th class="GridViewHeaderStyle" scope="col" style="">Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Item</th>
									<th class="GridViewHeaderStyle" scope="col" style="">View</th> 
                                    <th class="GridViewHeaderStyle" scope="col" style="">Dos</th>  
                                    <th class="GridViewHeaderStyle" scope="col" style="">MRP</th>                              
                                    <th class="GridViewHeaderStyle isHideRate" scope="col" style="">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Qty.</th>
                                    <th class="GridViewHeaderStyle isHideRate" scope="col" style="">Disc.</th>
                                    <th class="GridViewHeaderStyle isHideRate" scope="col" style="">Amt.</th>
                                    
									<th class="GridViewHeaderStyle" scope="col" style="">Delivery Date</th>                                  
									<th class="GridViewHeaderStyle clSampleCollection" scope="col" style="display:none">Sam.Coll.</th>
									<th class="GridViewHeaderStyle" scope="col" style="">IsUrgent</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">IsSelfColl.</th>
                                    <th class="GridViewHeaderStyle paientpaypercentage" scope="col" style="">Pay By<br />Patient</th>
                                    <th class="GridViewHeaderStyle paientpaypercentage" scope="col" style="">Pay By<br />Panel</th>
                                    <th class="GridViewHeaderStyle paientpaypercentage" scope="col" style="">Panel (%)</th>
									<th class="GridViewHeaderStyle" scope="col" style=""></th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
                </div>
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
                 <th class="GridViewHeaderStyle"  scope="col" style="display:block;">Transaction ID</th>			 
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
              <div class="row" id="divDiscountBy">
                  <div class="col-md-5">
				   <label class="pull-left">Discount Amt.</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
				  <input  type="text" class="ItDoseTextinputNum" value="0" onlynumber="10"  autocomplete="off" id="txtDiscountAmount"  onkeyUp="$onDiscountAmountChanged(event,jQuery('#txtGrossAmount').val())"  />
				<span id="spnTotalDiscountAmount" style="display:none"></span>
                </div>
				 <div class="col-md-5">
				   <label class="pull-left">Discount By</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-11">
					<select  id="ddlApprovedBy">						
					</select>
				</div>
			</div>
              <div class="row" id="divDiscountReason">
                  <div class="col-md-5">
				   <label id="lblPaymentType" class="pull-left">Discount in %</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                   <input  type="text" class="ItDoseTextinputNum"  value="0" onlynumber="5" max-value="100" autocomplete="off" id="txtDiscountPerCent" onkeyUp="$onDiscountPercentChanged(event,jQuery('#txtGrossAmount').val())"  />				   
				</div>
				 <div class="col-md-5">
				   <label class="pull-left">Discount Reason</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-11">
					<input  type="text"  id="txtDiscountReason" autocomplete="off"  maxlength="100"  />
				</div>				
			</div>           
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
	              <span id="spnCFactor" style="display:none"></span> <span id="spnConversion_ID" style="display:none"></span>   <span id="spnControlPatientAdvanceAmount" style="display:none">0</span>           
				</div>

                   <div class="col-md-5 clpaybypanel">
				   <label class="pull-left">Payby Panel</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3 clpaybypanel">
                    <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtpaybypanelfinal" type="text"  autocomplete="off" />
				</div>


				<%--<div class="col-md-8" >				  
                    
				</div>	--%>						                          		  
            </div>  
            <div class="row clCashTender" style="display:none">				
				<div class="col-md-5">
				 <label class="pull-left">Cash Rendering</label>
                    <b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                    <input  type="text" class="ItDoseTextinputNum" onlynumber="8"  id="txtAmountGiven" autocomplete="off"  OnKeyUp="$renderAmt();"/> 
                    </div> 
                    <div class="col-md-16 clCashTender" >				  
                    <span id="spnReturn" style="font-weight:bold;color:red "></span>
				</div>	
                 <div class="col-md-5">  <label class="pull-left">App Rec Amt</label>
                    <b class="pull-right">:</b>
                     </div>
                 <div class="col-md-3">
                     <input  type="text" class="ItDoseTextinputNum"  style="font-weight:Bold" onlynumber="8"  id="txtAppAmount" value="0" disabled="disabled" autocomplete="off"/> 
                     </div>
                 <div class="col-md-5 clpaybypatient">
				   <label class="pull-left">Payby Patient</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3 clpaybypatient">
                    <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtpaybypatientfinal" type="text"  autocomplete="off" />
				</div>
            </div>      
                </div>  
            <div class="col-md-13">            
            <div class="row">              
                     <div class="divOutstanding" style="display:none">        
				<div class="col-md-6">
            <label class="pull-left">  <asp:CheckBox ID="chkCashOutstanding" runat="server" Text="Outstanding Amt." onchange="$showOutstanding()"  Font-Bold="true"/>	</label>                   
                    </div>
                   <div class="col-md-5 clCashOutstanding" style="display:none">
                       <label class="pull-left">Employee Name</label>
								<b class="pull-right">:</b>                      
                   </div>	
                   <div class="col-md-6 clCashOutstanding" style="display:none">   
                       <select id="ddlOutstandingEmployee" class="requiredField"></select>                                                         
                       <asp:Label id="lblOutstandingDiscount" runat="server" style="display:none" Text="0"  />                      
                       </div>             
				<div class="col-md-4 clCashOutstanding" style="display:none">
                    <label class="pull-left">Outst. Amt.</label>
								<b class="pull-right">:</b>                                
                    </div>
                   <div class="col-md-3 clCashOutstanding" style="display:none">
                   <input  type="text" class="ItDoseTextinputNum requiredField" onlynumber="5"   id="txtOutstandingAmt" autocomplete="off" onkeyup="$onOutstandingAmt(event)"/>                           
                   </div>	                               	          	
            </div>
                    </div>
                 </div>
            <div class="col-md-11">   
                     <div class="row">                     
                         <div class="col-md-8 div_ReportDeliveryCharges" style="display:none">
                          <label class="pull-left">Report Del. Charge</label>
								<b class="pull-right">:</b> </div>      
                          <div class="col-md-3 div_ReportDeliveryCharges" style="display:none">
                               <input  type="text" class="ItDoseTextinputNum"  value="0"  id="txtReportDeliveryCharge" autocomplete="off" disabled="disabled"  />      
                          </div> 

                         <div class="col-md-8 div_SampleCollectionCharges" style="display:none">				
                     <label class="pull-left">Sample Coll. Charge</label>
								<b class="pull-right">:</b>                                
                    </div>
                   <div class="col-md-3 div_SampleCollectionCharges" style="display:none">
                       <input  type="text" class="ItDoseTextinputNum"  value="0"  id="txtSampleCollectionCharge" autocomplete="off" disabled="disabled"  />                     
                   </div>
            </div>
                    </div>
         </div>
          </div>          
        <div class="POuter_Box_Inventory" style="text-align: center">			
			<input type="button" style="margin-left:-190px;margin-top:7px" TabIndex="7" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveLabPrescription(this, jQuery(this).val());" />
            <input type="button" style="margin-top:7px" value="Cancel" onclick="$clearForm()" class="resetbutton" />
		</div>        
                </div>
        <div id="camViewer" class="modal fade">
    	<div class="modal-dialog">
		<div class="modal-content" style="width: 60%">
			<div class="modal-header">                
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Capture Patient Image</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeCamViewerModel(function(){})" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>                                		   								
			</div>
			<div class="modal-body">
				<div class="row"> 
                     <div class="col-md-12">
                                 <div class="row"> 
                                 <div class="col-md-24" style="text-align:center">
                            Live Camera
                   </div> 
                                 </div>                                 
                                 <div class="row"> 
                                  <div class="col-md-24">
                                      <div id="webcam"></div>
                                       </div>
                                  </div>
                                  <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">                                  
                                 <input type="button" style="font-weight: bold" onclick="$takeProfilePictureSnapShot()"  value="Capture" />
                              </div>
                                  </div>
</div>                                      
					 <div class="col-md-12">
                          <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">
                                      Preview
                                      </div>
                                 </div>
                          <div class="row"> 
                                  <div class="col-md-24">
                        		<img  style="width:100%" id="imgPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Preview" />
                                       </div>
                               </div>
                         <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">
                                      &nbsp;
                                      </div>
                                 </div>
                                 </div>				
			</div>
			<div class="modal-footer">
				<button type="button" id="btnSelectImage" style="display:none"  onclick="$selectPatientProfilePic(document.getElementById('imgPreview').getAttribute('src'))">Select Image</button>
				<button type="button"  onclick="$closeCamViewerModel(function(){})">Close</button>
			</div>
		</div>
	</div>
            </div>
</div>
        <div id="divDocumentMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 70%;">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Patient Documents Scan Upload</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closePatientDocumentModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>								
			</div>
			<div class="modal-body">
                <div class="row"> 
                     <div class="col-md-8">
                         <div id="documentMasterDiv" style="overflow:auto">							  
							</div>
                         </div>
                      <div class="col-md-16" style="overflow:auto">
                          	<img style="width: 100%; cursor:pointer"   src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" id="imgDocumentPreview"  alt="Preview" />
                          </div>
				</div>
			</div>
			<div class="modal-footer">
				 <span id="spnSelectedDocumentID" style="display:none"></span>
				 <button type="button" id="btnScan" style="font-weight:bold"  onclick="$showScanModel()" >Scan</button>
				 <button type="button" style="font-weight:bold"  onclick="$showCaptureModel()" >Capture</button>
				 <input id="file" name="url[]"  style="display:none" type="file" accept="image/x-png,image/gif,image/jpeg,image/jpg"  onchange="handleFileSelect(event)" />
				<%-- <button type="button" id="btnBrowser" onclick="document.getElementById('file').click()" style="font-weight:bold"  >Browse...</button> --%>
				 <button type="button" style="font-weight:bold"  onclick="$closePatientDocumentModel()">Close</button>
			</div>
		</div>
	</div>
</div>
        <div id="divDocumentMaualMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 50%;">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Patient Documents Manual Upload</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
			Press esc or click<button type="button" class="closeModel" onclick="$closePatientManualDocModel()" aria-hidden="true">&times;</button>to close</span></em></div>
                         </div>								
			</div>
			<div class="modal-body">
                <div class="row">
						 <div class="col-md-5">
                             <label class="pull-left">Document Type</label>
                    <b class="pull-right">:</b>
                             </div>
                    <div class="col-md-19">
                         <select id="ddlDocumentType" style="width:60%" class="requiredField"></select>
                         </div>
                     </div>
                <div class="row">
						 <div class="col-md-5">
                              <label class="pull-left">Select File</label>
                    <b class="pull-right">:</b>
                             </div>
                     <div class="col-md-15">
                         <input type="file" id="fileManualUpload" class="custom-file-input"/>
                         </div>
                     <div class="col-md-4">
                         <input type="button" id="btnMaualUpload" value="Upload Files" onclick="$saveMaualDocument()" /> 
                         </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                <progress id="fileProgress" style="display: none" max="100" value="50" data-label="50% Complete">
                    <span class="value" style="width:50%;"></span>
                </progress>
                        </div>
                    </div>
                 <div class="row">
                      <div class="col-md-24">
                          <em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em>
                          </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                        <em><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 10 MB.</span></em>
                         </div>
                    </div>
				
                <div id="divManualUpload" style="overflow:auto">							  
							</div>   
                 <div class="row">
                    <div class="col-md-24">            
                            <table id="tblMaualDocument"  border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="trManualDocument">
                                    <th class="GridViewHeaderStyle" >&nbsp;</th>	
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
	</div>
</div>   
        <div id="divScanViewer"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:70%">
				<div class="modal-header">
                    <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Scan Document</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" data-dismiss="divScanViewer" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>					
				</div>
				<div class="modal-body">				  
                    <div class="row">
						 <div class="col-md-6">
                               <div class="row">
                                   <div class="col-md-24">
                                       <label class="pull-left">Select Scanner   </label>
                    <b class="pull-right">:</b>
</div>
                </div>
                              <div class="row">
                                   <div class="col-md-24">
                                       <select class="form-control" style="width:100%;padding: 0px;" id="ddlSccaner"></select>

</div></div>
                             <div class="row">
                                   <div class="col-md-24" style="text-align:center">
                                       <input type="button" onclick="$scanDocument(jQuery('#ddlSccaner').val())"   value="Scan" />
                                       </div></div>
                             </div>
                        <div class="col-md-18">
                            <div class="row">
                                   <div class="col-md-24">
                                       <div style="width:100%" >
									 <div style="width: 100%;overflow:auto">
									 <img style="width:100%" id="imgScanPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />
									 </div>
								  </div>
                                       </div>
                                </div>
                             </div>
                        </div>

					  
				  
				</div>
				<div class="modal-footer">
					<button type="button"  onclick="$selectScanDocument(document.getElementById('imgScanPreview').src)" >Select</button>
					<button type="button"  data-dismiss="divScanViewer">Close</button>
				</div>
			</div>
		</div>
   </div>
 <%--style="padding-top: 190px;"--%>
        <div id="divDocumentCapture"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:70%">
				<div class="modal-header">
                    <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Capture Document</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" onclick="$closeDocumentCapture()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>												
				</div>
				<div class="modal-body">
				 <div class="row"> 
                     <div class="col-md-12">
                                 <div class="row"> 
                                 <div class="col-md-24" style="text-align:center">
                            Live Camera
                   </div> 
                                 </div>                                 
                                 <div class="row"> 
                                  <div class="col-md-24">
                                      <div id="documentWebCam" style="width:100%;"></div>
                                       </div>
                                  </div>
                                  <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">                                  
                                <input type="button" style="font-weight:bold" onclick="$takeDocumentSnapShot()"   value="Capture" />
                              </div>
                                  </div>
</div>                                    
                     <div class="col-md-12">
                          <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">
                                      Preview
                                      </div>
                                 </div>
                          <div class="row"> 
                                  <div class="col-md-24" style="overflow:auto">
									 <img style="width:100%;height: 100%;" id="imgDocumentSnapPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />

                                       </div>
                               </div>
                         <div class="row"> 
                                  <div class="col-md-24" style="text-align:center">
                                      &nbsp;
                                      </div>
                                 </div>
                                 </div>					  
				  
				</div>
				<div class="modal-footer">  
					<button type="button" id="btnSelectDocumentCapture"  onclick="selectDocumentCapture(document.getElementById('imgDocumentSnapPreview').src)">Select</button>
					<button type="button"  onclick="$closeDocumentCapture()">Close</button>
				</div>
			</div>
		</div>
   </div>   
            </div> 
        <div id="oldPatientModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 74%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                         <div class="col-md-8" style="text-align:left">
                              <h4 class="modal-title">Old Patient Search</h4>
                              </div>
                     <div class="col-md-1 square badge-fullPaid" style=" height: 20px;width:2%; float: left; ">
                        
                         </div><div class="col-md-3">PreBooking</div>
                      <div class="col-md-1 square badge-New" style=" height: 20px;width:2%; float: left; ">
                         
                         </div><div class="col-md-3">MemberShip</div>
                         <div class="col-md-8" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body" >
			    <div class="row clMoreFilter"  style="display:none" >
					 <div  class="col-md-3">
						  <label class="pull-left">Mobile No.</label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
                         <input type="text" onlynumber="10" id="txtSerachModelContactNo" />						  
					 </div>
					 <div  class="col-md-3">
						   <label class="pull-left">UHID</label>
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
        <div id="divPrePrintedBarcode" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 70%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Sample Type And Barcode</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel"  onclick="$closePrePrintedBarcodeModel()"  aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
			</div>
            <div class="modal-body">			
                     <div style="height:290px;overflow: scroll;"  class="row">
					<div id="divPrePrintedBarcodeData" style="" class="col-md-24">
                        <table id="tb_SampleList"  style="width: 99%; border-collapse: collapse" class="GridViewStyle">
				            <tr id="trSampleHeader">
					        <td class="GridViewHeaderStyle" >#</td>
					        <td class="GridViewHeaderStyle" >Test Name</td>
					        <td class="GridViewHeaderStyle" >Sample Type</td>
					        <td class="GridViewHeaderStyle">                              
						    <input type="text" id="txtAllBarCode" style="display:none" name="myBarCodeNo" onkeyup="$setBarCodeToall(this)" placeholder="Barcode For All" />                                                          
					        </td>
					        <td class="GridViewHeaderStyle" >SNR</td>
				</tr>
			</table>
                        </div>					
				</div>
                <div style="text-align:center" class="row">
			    <input type="button" value="Save" class="savebutton" onclick="$saveLabData(this, jQuery(this).val());" id="btnFinalSave" />
			    <input type="button" id="btnSkipSave" value="Skip & Save" onclick="$saveLabData(this, jQuery(this).val());" class="savebutton" />
				</div>
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="$closePrePrintedBarcodeModel()">Close</button>
			</div>                  
        </div>
 </div>
         </div>   
    <%--RequiredField Div--%>
   <div id="divRequiredField" class="modal fade">
    <div class="modal-dialog">
         <div class="modal-content" style="min-width: 50%;max-width:50%">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Required Fields</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeRequiredFieldsModel()"  aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
			</div>
            <div class="modal-body">
                <div  class="row">
					<div id="divRequiredFieldPopUp" class="col-md-24">
                        <table id="tblRequiredField"  style="width:95%;border-collapse:collapse;margin-left:15px;" class="GridViewStyle">           
        </table>
					</div>
				</div>
              
                <div style="text-align:center" class="row">
					   <input type="button" value="Save" class="savebutton" onclick="$saveRequiredField(this, jQuery(this).val())" id="btnSaveRequired" />
			    <input type="button" id="btnCancelRequiredField" value="Cancel" onclick="$closeRequiredFieldsModel()" class="resetbutton" />
				</div>
        </div>
   </div>
       </div>
 </div>       
    <%--Add ReferDoctor Div--%>
    <div id="divAddReferDoctor" tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:40%">
				<div class="modal-header">
                    <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title"><span id="spnReferDoctor"></span><span id="spnOpenType" style="display:none"></span> </h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel" data-dismiss="divAddReferDoctor" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Name</label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-18" >
							  <input type="text" autocomplete="off"  id="txtRefDocName" class="requiredField"  maxlength="50" data-title="Enter Refer Doctor Name" />    
						  </div>
					</div>				
					 <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Mobile No.</label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							  <input type="text" autocomplete="off" id="txtRefDocPhoneNo" onkeyup="previewCountDigit(event,function(e){});" allow   maxlength="10" onlynumber="10" data-title="Enter Refer Doctor Mobile No." />    
						  </div>
					</div>
                    <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Email   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							   <input id="txtRefDocEmail"  type="text" autocomplete="off"   maxlength="100" title="Enter Refer Doctor Email"/>
						  </div>
					</div>
                     <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Address   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							  <input type="text" autocomplete="off" id="txtRefDocAddress"  maxlength="50" data-title="Enter Refer Doctor Address" />    
						  </div>
					</div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveReferDoctor({Name:jQuery.trim(jQuery('#txtRefDocName').val()),Email:jQuery.trim(jQuery('#txtRefDocEmail').val()),Mobile:jQuery.trim(jQuery('#txtRefDocPhoneNo').val()),Address:jQuery.trim(jQuery('#txtRefDocAddress').val())})">Save</button>
						 <button type="button"  data-dismiss="divAddReferDoctor" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <%--Add SecondRef Div--%>
        <div id="divAddSecondRef"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:40%">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddSecondRef" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add Second Reference</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-18" >
							  <input type="text" autocomplete="off"  id="txtSecondRefName" class="requiredField"  maxlength="50" data-title="Enter Second Reference Name" />    
						  </div>
					</div>					
					 <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Mobile No.   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							  <input type="text" autocomplete="off" id="txtSecondRefMobileNo" onkeyup="previewCountDigit(event,function(e){});" allow   maxlength="10" onlynumber="10" data-title="Enter Second Reference Mobile No." />    
						  </div>
					</div>
                    <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Email   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							   <input id="txtSecondRefEmail"  type="text" autocomplete="off"   maxlength="50" title="Enter Second Reference Email"/>
						  </div>
					</div>
                     <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Address   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							  <input type="text" autocomplete="off" id="txtSecondRefAddress"  maxlength="50" data-title="Enter Second Reference Address" />    
						  </div>
					</div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveSecondRef({Name:jQuery.trim(jQuery('#txtSecondRefName').val()),Email:jQuery.trim(jQuery('#txtSecondRefEmail').val()),Mobile:jQuery.trim(jQuery('#txtSecondRefMobileNo').val()),Address:jQuery.trim(jQuery('#txtSecondRefAddress').val())})">Save</button>
						 <button type="button"  data-dismiss="divAddSecondRef" >Close</button>
				</div>
			</div>
		</div>
	</div>
     <div id="divViewRemarks" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 60%;max-width:62%">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Remarks Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeViewRemarksModel()"   aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>								
			</div>
            <div class="modal-body">			
                     <div id="divPopUPRemarks" class="col-md-24">
                         </div>               
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="$closeViewRemarksModel()">Close</button>
			</div>                  
        </div>
    </div>
         </div>
    <div class="containerRecommendedPackage">   
        <div class="divRecommendedPackage" style="text-align:center" > 
            <div class="row">
						 <div class="col-md-12"  style="text-align: left; font-weight: bold; color: blue; font-size: 15px; font-family: Cambria;">
							   Recommended Package
						  </div>
                            <div class="col-md-12">
                                 <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" style=" font-size: 15px" onclick="$hideRecommendedPackage();"  aria-hidden="true">&times;</button>to close</span></em>                                                                          					
                                </div>
                             </div>                                                   
                        <div class="row">                 
            <div style="overflow: scroll; height: 40%; background-color: papayawhip;" class="col-md-24">  
                <table id="tblPackageSuggestion" style="width:100%" border="1">
                    <tr>
                        <th>S.No.</th>
                        <th>Suggested Package</th>
                        <th>Rate</th>
                    </tr>
                </table> 
            </div></div>
            <p>
            </p>
            <p>
            </p>
            <p>
            </p>
        </div>        
        <a href="#" class="button-RecommendedPackage">Recommended Package</a>
    </div>
     <div class="containerPromotionalTest">
                    <div class="divPromotionalTest" style="text-align:center" >
                        <div class="row">
						 <div class="col-md-12"  style="text-align: center; font-weight: bold; color: blue; font-size: 20px; font-family: Cambria;">
							   Promotional Test
						  </div>
                            <div class="col-md-12">
                                 <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" style=" font-size: 15px" onclick="$hidePromotionalTest();"  aria-hidden="true">&times;</button>to close</span></em>                                                                        					
                                </div>
                             </div>                       
                        <div class="row">
                        <div style="overflow: scroll; height: 40%; background-color: papayawhip;" class="col-md-24">
                            <table id="tblPromotionalTest" style="width: 99%; border-collapse: collapse;font-size:11px;">
                                <tr>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 5px;font-size:11px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 45px;font-size:11px;">Selected Test Name</td>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 10px;font-size:11px;">Selected Test Code</td>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 45px;font-size:11px;">Promotional Test Name</td>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 10px;font-size:11px;">Promotional Test Code</td>
                                    <td class="GridViewHeaderStyle" style="text-align: left; width: 10px;font-size:11px;">Rate</td>
                                </tr>
                            </table>
                        </div>
                             </div>
                        <p>
                        </p>
                        <p>
                        </p>
                        <p>
                        </p>
                    </div>
                    <a href="#" class="button-PromotionalTest">Promotional Test</a>
                </div>
     <div class="containerSuggestedTest">
                    <div class="divSuggestedTest" style="text-align:center" >
                        <div class="row">
						 <div class="col-md-12"  style="text-align: center; font-weight: bold; color: blue; font-size: 20px; font-family: Cambria;">
							   Suggested Test
						  </div>
                            <div class="col-md-12">
                                 <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel" style=" font-size: 15px" onclick="$hideSuggestedTest();"  aria-hidden="true">&times;</button>to close</span></em>                                                                          					
                                </div>
                             </div>                            
                          <div class="row">
                        <div style="overflow: scroll; height: 50%; background-color: papayawhip;" class="col-md-24">
                            <table id="tblSuggection" style="width: 99%; border-collapse: collapse;">
                                <tr>
                                    <td class="GridViewHeaderStyle" style="text-align: center; ">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="text-align: center; ">Date</td>
                                    <td class="GridViewHeaderStyle" style="text-align: center; ">Test Name</td>
                                    <td class="GridViewHeaderStyle" style="text-align: center; ">Status</td>
                                </tr>
                            </table>
                        </div>
                               </div>
                        <p>
                        </p>
                        <p>
                        </p>
                        <p>
                        </p>
                    </div>
                    <a href="#" class="button-SuggestedTest">Suggested Test</a>
                </div> 
    
      <div id="divmembershipcard" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 70%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Membsership Card Search</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeMembsershipcardSearchModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
               <table id="tblmembership" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trh">
                         <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                         <td class="GridViewHeaderStyle" style="width:50px;">Select</td>
                         <td class="GridViewHeaderStyle">Card No</td>
                         <td class="GridViewHeaderStyle">Mobile</td>
                         <td class="GridViewHeaderStyle">UHID</td>
                         <td class="GridViewHeaderStyle">Patient Name</td>
                         <td class="GridViewHeaderStyle">Age</td>
                         <td class="GridViewHeaderStyle">Gender</td>
                         <td class="GridViewHeaderStyle">Relation</td>
                         
                    </tr>
                </table>

             
             </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeMembsershipcardSearchModel()">Close</button>
			</div>
            </div>
        </div>
      </div>
    <div id="divInvestigationlist" class="modal fade">
	<div class="modal-dialog" >
		<div class="modal-content" style="width:80%;height:55%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Investigation</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeInvestigationlistModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
               <table id="tblinvestigation" style="width:99%;border-collapse:collapse;text-align:left;">
                   <tr>
                       <td style="width:230px;color:red">Group :</td>
                       <td style="width:180px;color:red">SubGroup :</td>
                       <td style="width:250px">Investigation : <asp:TextBox ID="txtSearch" Width="150px" placeholder="Type To Search" runat="server" OnKeyUp="searchinvestigationlist(this);" ></asp:TextBox></td>
                        <td style="width:230px;color:red">Selected Test :</td>
                   </tr>
                    <tr>
                        <td style="width:230px;height:230px">
     <asp:ListBox ID="lstdeptgroup" runat="server"  onChange="$bindDept(this.value);"   Width="260px" Height="230px"></asp:ListBox>

                            </td>
                         <td style="width:180px;height:230px">
                      
     <asp:ListBox ID="lstdept" runat="server" style="display:none"  onChange="$loadinvestigation('',this.value);"   Width="180px" Height="230px"></asp:ListBox>
 <div style="overflow:auto;height:230px;border:groove">
<table id="tblsubgroup" style="width:99%;border-collapse:collapse;text-align:left;">
                </table></div>
                            </td>
                          <td style="width:360px;height:230px">
                
                          <asp:ListBox ID="ListBox2" runat="server"    style="display:none;"></asp:ListBox>
     <asp:ListBox ID="lstinvestigation" runat="server" class="navList" onChange="$loadinvestigation(this.value,'');"   Width="360px" Height="230px"></asp:ListBox>
                            </td>
                          <td style="width:230px;height:230px">
                                   
              <div style="overflow:auto;height:230px">
    <table id="tbltst" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="tr1">
                         <td class="GridViewHeaderStyle">Test Name</td>
                         <td class="GridViewHeaderStyle">Rate</td>
                    </tr>
                </table>
                       </div>
                            </td>
                    </tr>
                </table>

             
           </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeInvestigationlistModel()">Close</button>
			</div>
            </div>
        </div>
      </div>
    <script type="text/javascript">
        var $clearItem = function () {
            jQuery('#txtInvestigationSearch').val('');
            jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
        }
        var $closePrePrintedBarcodeModel = function (callback) {
            jQuery('#divPrePrintedBarcode').hideModel();
            jQuery('#btnFinalSave').removeAttr('disabled').val('Save');
            jQuery('#btnSkipSave').removeAttr('disabled').val('Skip & Save');
        }
        var $closeViewRemarksModel = function (callback) {
            jQuery('#divViewRemarks').hideModel();
        }
        var $closeRequiredFieldsModel = function (callback) {
            jQuery('#divRequiredField').hideModel();
        }
        </script>
    <script type="text/javascript">
        function $openinvestigation() {
            jQuery('#divInvestigationlist').showModel();
            jQuery('#tbltst tr').slice(1).remove();
            
        }
         $bindDepgroup = function () {
            jQuery('#lstdeptgroup option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindDeptcategory', {}, function (response) {
                var DeptData = JSON.parse(response);
                jQuery('#<%=lstdeptgroup.ClientID%> option').remove();
                if (DeptData != null) {
                    for (i = 0; i < DeptData.length; i++) {
                        jQuery('#lstdeptgroup').append(jQuery("<option></option>").val(DeptData[i].ObservationType_ID).html(DeptData[i].Name));
                    }
                }
            });
        }
        $bindDept = function (CategoryID) {
           
            //jQuery('#lstdept option').remove();
            //jQuery('#lstinvestigation option').remove();
            $('#tblsubgroup tr').empty();
            serverCall('../Common/Services/CommonServices.asmx/loadDeptartment', { CategoryID: CategoryID }, function (response) {
                var DeptData = JSON.parse(response);
               // jQuery('#<%=lstdept.ClientID%> option').remove();
                if (DeptData != null) {
                    for (i = 0; i < DeptData.length; i++) {
                        //  jQuery('#lstdept').append(jQuery("<option></option>").val(DeptData[i].ID).html(DeptData[i].SubgroupName));
                        var dept = [];
                        dept.push('<tr  onmouseover="$loadinvestigation(\'\',\'' + DeptData[i].ID + '\')" >');
                        dept.push('<td>');
                        dept.push(DeptData[i].SubgroupName);
                        dept.push('</td>');
                        dept.push('</tr>');
                        dept = dept.join("");
                        $('#tblsubgroup').append(dept);
                    }
                }
            });
         }
      
        $loadinvestigation = function (itemid, subgroupID) {
            if (jQuery("#ddlGender option:selected").text() == "") {
                toast("Error", "Please Select Gender", "");
                jQuery("#ddlGender").focus();
                return;
            }
            serverCall('../Common/Services/CommonServices.asmx/bindinvestigation',
                {
                    ItemID: itemid,
                    ReferenceCodeOPD: jQuery('#ddlPanel').val().split('#')[1],
                    CentreCode: jQuery('#ddlCentre').val().split('#')[0],
                    Gender: jQuery("#ddlGender option:selected").text(),
                    DOB: jQuery('#txtDOB').val(),
                    Panel_Id: jQuery('#ddlPanel').val().split('#')[0],
                    PanelType: jQuery('#ddlPanel').val().split('#')[5],
                    DiscountTypeID: jQuery('#ddlPatientType').val() == 1 ? 1 : 0,
                    PanelID_MRP: jQuery('#ddlPanel').val().split('#')[18],
                    MemberShipCardNo: jQuery("#spnMembershipCardID").text(),
                    SubcategoryID: jQuery('#lstdeptgroup').val(),
					SubgroupID:subgroupID
                }, function (response) {
                   
                    var $responseData = JSON.parse(response);
                    if (itemid == "") {
                        $("#ListBox2 option").remove();
                        jQuery('#lstinvestigation option').remove();
                        if ($responseData != null) {
                            for (i = 0; i < $responseData.length; i++) {
                                jQuery('#lstinvestigation').append(jQuery("<option></option>").val($responseData[i].value).html($responseData[i].label.split('#')[0]));
                                jQuery("#ListBox2").append($("<option></option>").val($responseData[i].value).html($responseData[i].label));
                            }
                        }
                    }
                    else {
                       
                        setTimeout(function () {
                            for (var i = 0; i < $responseData.length ; i++) {
                                var investigation = {};
                                investigation.item = $responseData[i];
                                $validateInvestigation(investigation, function () { });
                            }
                        }, 1000);

                        var aa = [];
                        aa.push('<tr class="GridViewItemStyle">');
                        aa.push('<td>' + $responseData[0].label.split('#')[0] + '</td>');
                        aa.push('<td>' + $responseData[0].Rate.split('#')[0] + '</td>');
                        aa = aa.join("");
                        $('#tbltst').append(aa);
                    }
                });
        }
        var keys = [];
        var values = [];
        function DoListBoxFilter(listBoxSelector, filter, keys, values) {
            var list = $(listBoxSelector);
            values = [];
            keys = [];

            var options = $('#<% = ListBox2.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            var selectBase = '<option value="{0}">{1}</option>';
            list.empty();
            for (i = 0; i < values.length; ++i) {
                var value = "";
                value = values[i].toLowerCase();
                var temp = "";
                if (value.toLowerCase().indexOf(filter.toLowerCase()) >= 0) {
                    temp = '<option value="' + keys[i] + '">' + values[i] + '</option>';
                    list.append(temp);
                }
            }
        }
        function searchinvestigationlist(ctr) {
            var filter = $(ctr).val().toLowerCase();
            DoListBoxFilter('.navList', filter, keys, values);

        }
        function $showHomeCollectionOption() {
            $resetItem("0");
            if (jQuery('#ddlVisitType').val() == "Home Collection") {
                jQuery('.divFieldBoy').show();
            }
            else if (jQuery('#ddlVisitType').val() == "Center Visit") {
                jQuery('.divFieldBoy').hide();
                jQuery('#ddlVisitType').prop('selectedIndex', 0);
            }
            if (jQuery('#ddlPanel').val().split('#')[14] == "1" && jQuery('#ddlVisitType').val() == "Home Collection") {
                jQuery('.div_SampleCollectionCharges').show();
                jQuery('#txtSampleCollectionCharge').val(jQuery('#ddlPanel').val().split('#')[15]);
            }
            else {
                jQuery('.div_SampleCollectionCharges').hide();
                jQuery('#txtSampleCollectionCharge').val('0');
            }
            if (jQuery('#ddlPanel').val().split('#')[16] == "1" && jQuery('#ddlVisitType').val() == "Home Collection") {
                jQuery('.div_ReportDeliveryCharges').show();
                jQuery('#txtReportDeliveryCharge').val(jQuery('#ddlPanel').val().split('#')[17]);
            }
            else {
                jQuery('.div_ReportDeliveryCharges').hide();
                jQuery('#txtReportDeliveryCharge').val('0');
            }
            var $sampleCollectionCharge = $calculateSampleCollectionCharge();
            var $reportDeliveryCharge = $calculateReportDeliveryCharge();
            jQuery('#txtGrossAmount,#txtNetAmount,#txtBlanceAmount').val(Number($sampleCollectionCharge) + Number($reportDeliveryCharge));
        }
        $calculateSampleCollectionCharge = function () {
            var $sampleCollectionCharge = jQuery('#txtSampleCollectionCharge').val();
            if (isNaN($sampleCollectionCharge) || $sampleCollectionCharge == "")
                $sampleCollectionCharge = 0;
            return $sampleCollectionCharge;
        };
        $calculateReportDeliveryCharge = function () {
            var $reportDeliveryCharge = jQuery('#txtReportDeliveryCharge').val();
            if (isNaN($reportDeliveryCharge) || $reportDeliveryCharge == "")
                $reportDeliveryCharge = 0;
            return $reportDeliveryCharge;
        };
        $addNewDoctorReferModel = function (headerTitle, openType) {
            jQuery('#divAddReferDoctor input[type=text]').val('');
            jQuery('#divAddReferDoctor').showModel();
            jQuery('#txtRefDocName').focus();
            jQuery('#spnReferDoctor').text(headerTitle);
            jQuery('#spnOpenType').text(openType);
        }
        $addNewSecRefModel = function () {
            jQuery('#divAddSecondRef input[type=text]').val('');
            jQuery('#divAddSecondRef').showModel();
        }
        $saveReferDoctor = function (referDoctorDetails) {
            if (referDoctorDetails.Name.trim() == '') {
                if (jQuery('#spnOpenType').text() == "0")
                    toast("Error", "Enter Refer Doctor Name", "");
                else
                    toast("Error", "Enter Second Reference Name", "");
                jQuery('#txtRefDocName').focus();
                return false;
            }
            //if (referDoctorDetails.Mobile.trim() == '') {
            //    modelAlert('Enter Doctor Mobile No.');
            //    return false;
            //}
            if (referDoctorDetails.Mobile.trim() == '123456789') {
                if (jQuery('#spnOpenType').text() == "0")
                    toast("Error", "Enter Valid Refer Doctor Mobile No.", "");
                else
                    toast("Error", "Enter Valid Second Reference Mobile No.", "");
                jQuery('#txtRefDocPhoneNo').focus();
                return false;
            }
            if (referDoctorDetails.Mobile.trim() != '' && referDoctorDetails.Mobile.length < 10) {
                if (jQuery('#spnOpenType').text() == "0")
                    toast("Error", "Enter Valid Refer Doctor Mobile No.", "");
                else
                    toast("Error", "Enter Valid Second Reference Mobile No.", "");
                jQuery('#txtRefDocPhoneNo').focus();
                return false;
            }
            if (referDoctorDetails.Email.length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(referDoctorDetails.Email)) {
                    if (jQuery('#spnOpenType').text() == "0")
                        toast("Error", "Enter Valid Refer Doctor Email", "");
                    else
                        toast("Error", "Enter Valid Second Reference Email", "");
                    jQuery('#txtRefDocEmail').focus();
                    return false;
                }
            }
            serverCall('../Lab/Services/LabBooking.asmx/saveNewdoctorfrombooking', { DoctorName: referDoctorDetails.Name, Mobile: referDoctorDetails.Mobile, centreid: jQuery("#ddlCentre").val().split('#')[0], Email: referDoctorDetails.Email, Address: referDoctorDetails.Address }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if (jQuery('#spnOpenType').text() == 0)
                        Doctor_ID_Temp = parseInt($responseData.response);
                    else
                        TempSecondRef = parseInt($responseData.response);
                    jQuery('#divAddReferDoctor').closeModel();
                    modelAlert('Saved Successfully', function (response) {
                        $bindReferDotor(Doctor_ID_Temp, referDoctorDetails.Name, jQuery('#spnOpenType').text(), function (response) { });
                    });
                }
                else if ($responseData.responseMsg != "") {
                    modelAlert(' Mobile No. : ' + jQuery('#txtRefDocPhoneNo').val() + ' Registered With Doctor : ' + $responseData.responseMsg);
                    Doctor_ID_Temp = 0;
                }
                else {
                    toast("Error", 'Error occurred, Please contact administrator', '');
                    Doctor_ID_Temp = 0;
                }
            });
        }
        var $bindReferDotor = function (id, name, openType) {
            if (openType == 0) {
                jQuery("#hftxtReferDoctor").val(2);//other doctor
                jQuery('#txtReferDoctor').val(name);
            }
            else {
                jQuery("#hfSecondReference").val(2);
                jQuery('#txtSecondReference').val(name);
            }
            jQuery('#divAddReferDoctor input[type=text]').val('');
        }
        $saveSecondRef = function (secondRefDetails) {
            if (secondRefDetails.Name.trim() == '') {
                modelAlert('Enter Second Reference Name');
                return false;
            }
            if (secondRefDetails.Mobile.trim() == '123456789') {
                modelAlert('Enter Valid Second Reference Mobile No.');
                return false;
            }
            if (secondRefDetails.Mobile.trim() != '' && referDoctorDetails.Mobile.length < 10) {
                modelAlert('Enter Valid Second Reference Mobile No.');
                return false;
            }
            serverCall('../Lab/Services/LabBooking.asmx/saveSecondRef', { SecondRefName: secondRefDetails.Name, Mobile: secondRefDetails.Mobile, centreid: jQuery("#ddlCentre").val().split('#')[0], Email: secondRefDetails.Email, Address: secondRefDetails.Address }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    TempSecondRef = parseInt($responseData.response);
                    jQuery('#divAddSecondRef').closeModel();
                    modelAlert('Second Reference Saved Successfully', function (response) {
                        $bindSecondRef(TempSecondRef, secondRefDetails.Name, function (response) { });
                    });
                }
                else if ($responseData.responseMsg != "") {
                    modelAlert(' Mobile No. : ' + jQuery('#txtSecondRefMobileNo').val() + ' Registered With : ' + $responseData.responseMsg);
                    TempSecondRef = 0;
                }
                else {
                    modelAlert('Error occurred, Please contact administrator');
                    TempSecondRef = 0;
                }
            });
        }
        var $bindSecondRef = function (id, name) {
            jQuery("#hfSecondReference").val(id);
            jQuery('#txtSecondReference').val(name);
            jQuery('#divAddSecondRef input[type=text]').val('');
        }
    </script>
    <script type="text/javascript">
        jQuery("#txtDiscountAmount").on("keypress", function (e) {
            var $sampleCollectionCharge = $calculateSampleCollectionCharge();
            var $reportDeliveryCharge = $calculateReportDeliveryCharge();
            var $total = parseFloat(parseFloat(jQuery('#txtGrossAmount').val()) - $sampleCollectionCharge - $reportDeliveryCharge);
            jQuery("#txtDiscountAmount").attr('max-value', $total);
        });
        var $onDiscountAmount = function (e, netAmount) {
            var $currentValue = String.fromCharCode(e.which);
            var $finalValue = jQuery(this).val() + $currentValue;
            if ($finalValue > netAmount) {
                e.preventDefault();
            }
        };
        var $onDiscountAmountChanged = function (e, billAmount) {
            if ($itemwisedic == 1) {
                toast("Info", "Item Wise Discount Amount already Given", "");
                $confirmationBox('Item Wise Discount Amount already Given <br> <b>Do you want to remove?', 0);
                jQuery('#txtDiscountAmount').val('');
                $addRequiredClass();
                return;
            }
            if (jQuery("#tb_ItemList").find('tr:not(#LabHeader)').length == 0) {
                toast("Info", "Please Add Test", "");
                jQuery('#txtDiscountAmount').val('');
                $addRequiredClass();
                return;
            }
            var key = (e.keyCode ? e.keyCode : e.charCode);
            if (key != 9) {
                if (isNaN(jQuery('#txtDiscountPerCent').val() / 1) == true) {
                    $addRequiredClass();
                    return;
                }
                if (jQuery('#txtDiscountPerCent').val().length > 0 && jQuery('#txtDiscountPerCent').val() != "0") {
                    jQuery('#txtDiscountPerCent').val('');
                }
                var $netAmount = parseFloat(billAmount);
                var $discountPerCent = precise_round((e.target.value * 100 / $netAmount), '<%=Resources.Resource.BaseCurrencyRound%>');
                var $total = parseFloat(jQuery('#txtGrossAmount').val());
                var sampleCollectionCharge = $calculateSampleCollectionCharge();
                var reportDeliveryCharge = $calculateReportDeliveryCharge();
                var $total1 = 0;
                $total1 = parseFloat($total - sampleCollectionCharge - reportDeliveryCharge);
                var $disAmt = parseFloat(jQuery('#txtDiscountAmount').val());
                $addRequiredClass();
                if ($disAmt > $total1) {
                    toast("Info", "Discount Amount can't greater then total amount", "");
                    var final = 0;
                    if (sampleCollectionCharge > 0 || reportDeliveryCharge > 0)
                        jQuery('#txtNetAmount').val(Number(sampleCollectionCharge) + Number(reportDeliveryCharge));
                    else
                        jQuery('#txtNetAmount').val(final);
                    jQuery('#txtDiscountAmount').val($total1);
                    jQuery('#spnTotalDiscountAmount').text($total1);
                    $addRequiredClass();
                    $showDue();
                    e.preventDefault();
                    return;
                }
                if (isNaN($disAmt / 1) == true) {
                    jQuery('#txtNetAmount').val($total);
                    jQuery('#txtDiscountAmount').val('0');
                    jQuery('#spnTotalDiscountAmount').text('0');
                    $addRequiredClass();
                    $showDue();
                    return;
                }
                var status = true;
                $addRequiredClass();
                var $final = $total - $disAmt;
                $itemwisedic = 0;
                jQuery('#txtNetAmount').val($final);
                jQuery('#txtDiscountAmount').val($disAmt);
                jQuery('#spnTotalDiscountAmount').text($disAmt);
                $showDue();
                jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
                jQuery('#tblPaymentDetail tr').slice(1).remove();
                $getPaymentMode("1", function () { });
                jQuery('#txtCurrencyRound').val('0');
                $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
            }
        }
        var $onDiscountPercentChanged = function (e, billAmount) {
            var $netAmount = (parseFloat(billAmount));
            var $discountAmount = precise_round(parseFloat(e.target.value * $netAmount / 100), '<%=Resources.Resource.BaseCurrencyRound%>');
            if ($itemwisedic == 1) {
                toast("Info", "Item Wise Discount Amount already Given", "");
                $confirmationBox('Item Wise Discount Amount already Given <br> <b>Do you want to remove?', 0);
                jQuery('#txtDiscountPerCent').val('');
                $addRequiredClass();
                return;
            }
            if (jQuery("#tb_ItemList").find('tr:not(#LabHeader)').length == 0) {
                toast("Info", "Please Add Test", "");
                jQuery('#txtDiscountAmount').val('');
                $addRequiredClass();
                return;
            }
            if (jQuery('#txtDiscountAmount').val() != -1) {
                jQuery('#txtDiscountAmount').val(jQuery('#txtDiscountAmount').val().replace('.', ''));
            }
            var key = (e.keyCode ? e.keyCode : e.charCode);
            if (key != 9) {
                if (isNaN(jQuery('#txtDiscountPerCent').val() / 1) == true) {
                    $addRequiredClass();
                    return;
                }
                if (jQuery('#txtDiscountAmount').val().length > 0 && jQuery('#txtDiscountAmount').val() >= 0)
                    jQuery('#txtDiscountAmount').val('');
                $addRequiredClass();
                var $total = parseFloat(jQuery('#txtGrossAmount').val());
                var $disper = parseFloat(jQuery('#txtDiscountPerCent').val());
                var $sampleCollectionCharge = $calculateSampleCollectionCharge();
                var $reportDeliveryCharge = $calculateReportDeliveryCharge();
                var $total1 = 0;
                $total1 = parseFloat($total - $sampleCollectionCharge - $reportDeliveryCharge);
                if ($disper > 100) {
                    toast("Info", "Discount Percent can't greater then 100", "");
                    var final = 0;
                    if ($sampleCollectionCharge > 0 || $reportDeliveryCharge > 0)
                        jQuery('#txtNetAmount').val(Number($sampleCollectionCharge) + Number($reportDeliveryCharge));
                    else
                        jQuery('#txtNetAmount').val(final);
                    jQuery('#txtDiscountPerCent').val('100');
                    if ($sampleCollectionCharge > 0 || $reportDeliveryCharge > 0)
                        jQuery('#spnTotalDiscountAmount').val($total1);
                    else
                        jQuery('#spnTotalDiscountAmount').text($total1);
                    $addRequiredClass();
                    $showDue();
                    return;
                }
                if (isNaN($disper / 1) == true) {
                    jQuery('#txtNetAmount').val($total);
                    jQuery('#spnTotalDiscountAmount').text('0');
                    $addRequiredClass();
                    $showDue();
                    return;
                }
                var status = true;
                $addRequiredClass();
                var $disval = ($total1 * $disper) / 100;
                $disval = Math.round($disval);
                var $final = $total - $disval;
                $itemwisedic = 0;
                jQuery('#txtNetAmount').val($final);
                jQuery('#spnTotalDiscountAmount').text($disval);
                $showDue();
                jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
                jQuery('#tblPaymentDetail tr').slice(1).remove();
                $getPaymentMode("1", function () { });
                jQuery('#txtCurrencyRound').val('0');
                $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
            }
        }
        var $addRequiredClass = function () {
            if (jQuery('#txtDiscountPerCent').val() > 0 || jQuery('#txtDiscountAmount').val() > 0 || $itemwisedic == 1) {
                jQuery('#ddlApprovedBy,#txtDiscountReason').addClass('requiredField');
            }
            else {
                jQuery('#ddlApprovedBy,#txtDiscountReason').removeClass('requiredField');
            }
        };
    </script>
    <script type="text/javascript">
        function $showoption() {
            $resetItem("1");
            $bindRateType(function (callback) {
                setdiscountoption();
				$showPUPData("1");
            });
        }
		function setdiscountoption()
		{
			jQuery('#txtReferDoctor,#txtSecondReference').val('SELF');
                jQuery('#hftxtReferDoctor,#hfSecondReference').val('1');
                //Walk-In
                if (jQuery('#ddlPatientType').val() == "1") {
                    jQuery('#divPUPDetail,#divHLMDetail,.divCorporate,.divCardCorporate').hide();
                    jQuery('#txtMobileNo').attr("tabindex", 1);
                    jQuery('#divDiscountBy,#divDiscountReason').show();
                }
                    //2 Corporate 6 TPA 7 GOVT PANEL
                else if (jQuery('#ddlPatientType').val() == "2" || jQuery('#ddlPatientType').val() == "6" || jQuery('#ddlPatientType').val() == "7") {
                    jQuery('#divPUPDetail,#divHLMDetail,#divDiscountBy,#divDiscountReason').hide();
                    jQuery('.divCorporate').show();
                    if (jQuery('#ddlPatientType').val() == "2" || jQuery('#ddlPatientType').val() == "6") {
                        jQuery('.divCardCorporate').show();
                        jQuery('.divGovtPanel').hide();
                    }
                    else if (jQuery('#ddlPatientType').val() == "7") {
                        jQuery('.divGovtPanel,.divCardCorporate').show();
                    }
                    else {
                        jQuery('.divGovtPanel,.divCardCorporate').hide();
                    }
                    jQuery('#txtMobileNo').attr("tabindex", 1);
                }
                    //PUP
                else if (jQuery('#ddlPatientType').val() == "3") {
                    jQuery('#divPUPDetail').show();
                    jQuery('#divHLMDetail,.divCorporate,.divCardCorporate,#divDiscountBy,#divDiscountReason').hide();
                    jQuery('#txtMobileNo').attr("tabindex", -1);
                }
                    //HLM
                else if (jQuery('#ddlPatientType').val() == "4" || jQuery('#ddlPatientType').val() == "11") {
                    //jQuery('#txtReferDoctor,#hftxtReferDoctor').val('');
                    jQuery('#divHLMDetail').show();
                    if ((jQuery('#ddlPanel').val().split('#')[2] == "Cash" || jQuery("#ddlPanel").val().split('#')[20] == "1") && jQuery('#ddlPanel').val().split('#')[13] == "1") {
                        jQuery('#divDiscountBy,#divDiscountReason').show();
                    }
                    else {
                        jQuery('#divDiscountBy,#divDiscountReason').hide();
                    }
                    jQuery('#divPUPDetail,.divCorporate,.divCardCorporate').hide();
                    jQuery('#txtMobileNo').attr("tabindex", -1);

                }
                    //CC B2B FC
                else if (jQuery('#ddlPatientType').val() == "8" ) {
                    jQuery('#divPUPDetail,#divHLMDetail,.divCorporate,.divCardCorporate').hide();
                    jQuery('#divDiscountBy,#divDiscountReason').show();
                    jQuery('#txtMobileNo').attr("tabindex", 1);
                }
                else if (jQuery('#ddlPatientType').val() == "9" || jQuery('#ddlPatientType').val() == "10") {
                    jQuery('#divPUPDetail,#divHLMDetail,.divCorporate,.divCardCorporate,#divDiscountBy,#divDiscountReason').hide();
                    jQuery('#txtMobileNo').attr("tabindex", 1);
                }
                
		}
        function $showPUPData(con) {
          //  $getpatienttype();
            $setPUPData();
            if (con == 0)
                $resetItem("0");
        }
        function $getpatienttype() {
            $ddlPanel = jQuery('#ddlPatientType');
            jQuery('#ddlPatientType option').remove();
            serverCall('../Lab/Services/LabBooking.asmx/GetPanelGroup', { PanelID: jQuery('#ddlPanel').val().split('#')[0] }, function (response) {
                if (JSON.parse(response) != "")
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'value', textField: 'label', isSearchAble: true, showDataValue: 1 });
                else
                    $ddlPanel.append(jQuery("<option></option>").val("0").html("--No Rate Type--")).chosen('destroy').chosen();
                
               // callback($ddlPanel.val());
            });
        }
        function $setPUPData() {
		jQuery('#ddlPatientType').val(jQuery('#ddlPanel').val().split('#')[24]);
		jQuery('#ddlPatientType').trigger('chosen:updated');
            if (jQuery('#ddlPatientType').val() == '3') {
                jQuery('#txtPUPRefNo').val(jQuery('#ddlPanel').val().split('#')[6]);
                jQuery('#txtPUPContact').val(jQuery('#ddlPanel').val().split('#')[7]);
                jQuery('#txtPUPMobile').val(jQuery('#ddlPanel').val().split('#')[8]);
              //  jQuery('#txtMobileNo').removeClass('requiredField');
            }
           // else
             //   jQuery('#txtMobileNo').addClass('requiredField');
            if (jQuery('#ddlPanel').val().split('#')[19] == 1)
                jQuery('#txtOtherLabRefNo').addClass('requiredField');
            else
                jQuery('#txtOtherLabRefNo').removeClass('requiredField');
            if (jQuery('#ddlPanel').val().split('#')[11] == '1' && jQuery('#ddlPanel').val().split('#')[12] == '1') {
                jQuery('#spnError').html('<br/>Credit limit exceeded and your account is locked, Kindly contact to account department...........!');
                jQuery('#spnError').attr('style', 'font-family:cambria;font-size:20px;');
                jQuery('#btnSave,#btnCancel').hide();
            }
            else {
                jQuery('#spnError').html('');
                jQuery('#spnError').attr('style', '');
                jQuery('#btnSave,#btnCancel').show();
            }
			setdiscountoption();
        }
        var $getCentreData = function (con, callback) {
            if (con == 0) {
                jQuery('#ddlState').val(jQuery('#ddlCentre').val().split('#')[3]).chosen('destroy').chosen();
                $bindStateCityLocality("0", function () { });
            }
            jQuery('#txtPUPRefNo,#txtPUPContact,#txtPUPMobile').val('');
            switch (jQuery('#ddlCentre').val().split('#')[1]) {
                case '7':
                    {
                        jQuery('#ddlPatientType').val("3");//pup
                        jQuery('#ddlPatientType').attr("disabled", true);
                        break;
                    }
                case '1':
                    {
                        jQuery('#ddlPatientType').val("4");//HLM              
                        jQuery('#ddlPatientType').attr("disabled", false);
                        break;
                    }
                case '9':
                    {
                        jQuery('#ddlPatientType').val("8");//CC
                        jQuery('#ddlPatientType').attr("disabled", false);
                        break;
                    }
                case '10':
                    {
                        jQuery('#ddlPatientType').val("10");//FC
                        jQuery('#ddlPatientType').attr("disabled", false);
                        break;
                    }
                case '11':
                    {
                        jQuery('#ddlPatientType').val("9");//B2B
                        jQuery('#ddlPatientType').attr("disabled", false);
                        break;
                    }
                default:
                    {
                        jQuery('#ddlPatientType').val("1");//WalkIN
                        jQuery('#ddlPatientType').attr("disabled", false);
                        break;
                    }
            }
            jQuery('#ddlPatientType').trigger('chosen:updated');
            $showoption();
            $bindDiscountApprovalAndOutStandingEmp();
            $bindCategory();
            $bindPRO();
            callback(true);
        };
    </script>
    <script type="text/javascript">
        $closeOldPatientSearchModel = function () {
            jQuery('#oldPatientModel').hideModel();
            jQuery('#tablePatient tr').remove();
        }
        var _PageNo = 0;
        var _PageSize = 6;
        var $bindOldPatientDetailsContact = function (data) {
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
        $showOldPatientSearchModel = function () {
            jQuery('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
            jQuery('#oldPatientModel').showModel();
            jQuery('.clMoreFilter').show();
            jQuery('#divSearchModelPatientSearchResults').html('');
        }
        $searchOldPatientDetail = function () {
            var data = {
                PName: jQuery('#txtSearchModelName').val(),
                DOB: "",
                Patient_ID: jQuery('#txtSearchModelMrNO').val(),
                MobileNo: jQuery('#txtSerachModelContactNo').val(),
                fromDate: jQuery('#txtSearchModelFromDate').val(),
                toDate: jQuery('#txtSerachModelToDate').val(),
                stateID: jQuery('#ddlSearchModelState').val(),
                cityID: jQuery('#ddlSearchModelCity').val(),
                localityID: jQuery('#ddlSearchModelLocality').val(),
            }
            $getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatientFromMoreFilter', function (response) {
                $bindOldPatientDetails(response);
            });
        }
        var $bindOldPatientDetails = function (data) {
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
        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            jQuery('#oldPatientModel').showModel();
            var outputPatient = jQuery('#tb_OldPatient').parseTemplate(OldPatient);
            jQuery('#divSearchModelPatientSearchResults').html(outputPatient);
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
        }
        var $onPatientSelect = function (elem) {
            jQuery("#txtMobileNo").val(jQuery(elem).closest('tr').find('#tdMobile').text()).attr('disabled', 'disabled');
            jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == jQuery(elem).closest('tr').find('#tdTitle').text() })[0]).prop('selected', true).attr('disabled', 'disabled');
            $onTitleChange(jQuery('#ddlTitle').val());
            jQuery("#ddlGender").val(jQuery(elem).closest('tr').find('#tdGender').text()).attr('disabled', 'disabled');
            jQuery("#txtPName").val(jQuery(elem).closest('tr').find('#tdPName').text()).attr('disabled', 'disabled');
            jQuery("#txtDOB").val(jQuery(elem).closest('tr').find('#tdDOB').text());
            jQuery("#txtUHIDNo").val(jQuery(elem).closest('tr').find('#tdPatient_ID').text()).attr('disabled', 'disabled');
            var txtPID = jQuery('#txtUHIDNo').val(jQuery(elem).closest('tr').find('#tdPatient_ID').text()).attr('patientAdvanceAmount', jQuery(elem).closest('tr').find('#tdPatientAdvance').text());
            if (!String.isNullOrEmpty(jQuery(elem).closest('tr').find('#tdPatient_ID').text()))
                jQuery(txtPID).change();
            jQuery("#spnUHIDNo").text(jQuery(elem).closest('tr').find('#tdPatient_ID').text());
            jQuery("#txtAge").val(jQuery(elem).closest('tr').find('#tdAgeYear').text());
            jQuery("#txtAge1").val(jQuery(elem).closest('tr').find('#tdAgeMonth').text());
            jQuery("#txtAge2").val(jQuery(elem).closest('tr').find('#tdAgeDays').text());
            jQuery("#txtEmail").val(jQuery(elem).closest('tr').find('#tdEmail').text());
            jQuery("#txtPinCode").val(jQuery(elem).closest('tr').find('#tdPinCode').text());
            jQuery('#ddlCountry').val(jQuery(elem).closest('tr').find('#tdCountryID').text()).chosen('destroy').chosen();
            jQuery('#ddlTitle,#txtPreBookingNo').attr('disabled', 'disabled');
            jQuery("#txtClinicalHistory").val(jQuery(elem).closest('tr').find('#tdClinicalHistory').text());
            jQuery(elem).closest('tr').find('#tdvip').text() == "1" ? jQuery("#chkIsVip").prop('checked', true) : jQuery("#chkIsVip").prop('checked', false);

            jQuery("#txtMemberShipCardNo").val(jQuery(elem).closest('tr').find('#tdMembershipCardNo').text()).attr('disabled', 'disabled');
            
            jQuery("#spnMembershipCardNo").text(jQuery(elem).closest('tr').find('#tdMembershipCardNo').text());
            jQuery("#spnMembershipCardID").text(jQuery(elem).closest('tr').find('#tdMembershipCardID').text());
            jQuery("#spnIsSelfPatient").text(jQuery(elem).closest('tr').find('#tdFamilyMemberIsPrimary').text());
            $bindState(jQuery(elem).closest('tr').find('#tdCountryID').text(), "1", function (selectedStateID) {
                jQuery('#ddlState').val(jQuery(elem).closest('tr').find('#tdStateID').text()).chosen('destroy').chosen();
                $bindCity(jQuery(elem).closest('tr').find('#tdStateID').text(), "1", function (selectedCityID) {
                    jQuery('#ddlCity').val(jQuery(elem).closest('tr').find('#tdCityID').text()).chosen('destroy').chosen();
                    $bindLocality(jQuery(elem).closest('tr').find('#tdCityID').text(), "1", function () {
                        jQuery('#ddlArea').val(jQuery(elem).closest('tr').find('#tdLocalityID').text()).chosen('destroy').chosen();
                    });
                });
            });
            if (jQuery.trim(jQuery(elem).closest('tr').find('#tdPreBookingID').text()) != "") {
                jQuery('#txtPreBookingNo').val(jQuery.trim(jQuery(elem).closest('tr').find('#tdPreBookingID').text()));
                $searchPreBookingNo('0', "1");
            }
            else {
                $searchPatientImage({ PatientID: jQuery.trim(jQuery(elem).closest('tr').find('#tdPatient_ID').text()), dtEntry: jQuery.trim(jQuery(elem).closest('tr').find('#tddtEntry').text()) }, function (response) {
                    if (!String.isNullOrEmpty(response.Item1)) {
                        jQuery('#imgPatient').attr('src', response.Item1);
                    }
                    else
                        jQuery('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
                    if (!String.isNullOrEmpty(response.Item2)) {
                        jQuery('#spnDocumentCounts').text(response.Item2);
                    }
                });
                jQuery("#tblMaualDocument tr").slice(1).remove();
                $bindPatientDocumnet(jQuery.trim(jQuery(elem).closest('tr').find('#tdPatient_ID').text()), function () { });
            }
            $bindSuggestedTest(jQuery.trim(jQuery(elem).closest('tr').find('#tdPatient_ID').text()), function () { });
            jQuery('#oldPatientModel').hideModel();
            jQuery('#tablePatient tr').remove();
            var $today = new Date();
            var $dob = jQuery(elem).closest('tr').find('#tdDOB').text();
            getAge($dob, $today);
        }
        var $bindPatientImage = function (data, callback) {
        }
        $searchPatientImage = function (PatientID, dtEntry, callback) {
            serverCall('../Lab/Services/LabBooking.asmx/BindPatientImage', PatientID, dtEntry, function (response) {
            });
        }
        $bindPatientDocumnet = function (PatientID) {
            serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: '', Filename: '', PatientID: PatientID, oldPatientSearch: 1, documentDetailID: 0, isEdit: 0 }, function (response) {
                var maualDocument = JSON.parse(response);
                if (!String.isNullOrEmpty(maualDocument)) {
                    $addPatientDocumnet(maualDocument, 1);
                }
            });
        }
        $addPatientDocumnet = function (maualDocument, oldPatientSearch) {
            for (var i = 0; i < maualDocument.length ; i++) {
                var $PatientDocumnetTr = [];
                $PatientDocumnetTr.push("<tr>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                if (oldPatientSearch == 0)
                  $PatientDocumnetTr.push('<img id="imgMaualDocument" alt="Remove Document" src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="$removeMaualDocument(this)"/>');
                $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle' id='tdManualDocumentName'>");
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
                jQuery("#tblMaualDocument tbody").prepend($PatientDocumnetTr);
            }
            jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
        };
    </script>
        <script id="tb_OldPatient" type="text/html">
	<table  id="tablePatient" cellspacing="0" rules="all" border="1" style="border-collapse :collapse;">
		<thead>  
			 <tr id="Header"> 
					<th class="GridViewHeaderStyle" scope="col">Select</th>
                    <th class="GridViewHeaderStyle" scope="col">PreBooking No.</th>
                  <#  if(<%=Resources.Resource.MemberShipCardApplicable %>=="1"){#>
                    <th class="GridViewHeaderStyle" scope="col">Card No.</th><#}#>      
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
            $PNameMob[j] = OldPatient[j].PName;
            
	   var objRow = OldPatient[j];
		#>              
						<tr onmouseover="this.style.color='#00F'"  class="trOldPatient"  onMouseOut="this.style.color=''" id="<#=j+1#>"  style='cursor:pointer;                          
                           <#if(objRow.PreBookingID!=0){#>
                            background-color:#ffffff;'>
                            <#}  else if(objRow.MembershipCardNo!=""){#>
                            background-color:#CC99FF;'>
                            <#}
                            else
                        {#> 
                        '> <#}
                        #>                          
						<td class="GridViewLabItemStyle">
					   <a  class="btn" onclick="$onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
						  Select						   
					   </a>
                            <span data-title='Click to Select'  ></span>                
						</td>  
                            <td  class="GridViewLabItemStyle" id="tdPreBookingID">
                          <# if(objRow.PreBookingID!=0)
                            {#>
                                <#=objRow.PreBookingID#>
                            <#}#>                                                       
                                </td>   
                          <#  if(<%=Resources.Resource.MemberShipCardApplicable %>=="1"){#>
                            <td  class="GridViewLabItemStyle" id="tdMembershipCardNo"  ><#=objRow.MembershipCardNo#></td>    <#}#>                                                                  
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
                        <td class="GridViewLabItemStyle" id="tdvip" style="display:none" ><#=objRow.VIP#></td>
                        <td class="GridViewLabItemStyle" id="tdMembershipCardID" style="display:none" ><#=objRow.MembershipCardID#></td>
                        <td class="GridViewLabItemStyle" id="tdFamilyMemberIsPrimary" style="display:none" ><#=objRow.FamilyMemberIsPrimary#></td>
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
        var OldPatientDetails = "";
        var $patientSearchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13 || code == 9 || (e.target.id === 'txtMobileNo' && e.target.value.length === 10)) {
                var data = { MobileNo: '', Patient_ID: '', PName: '', FromRegDate: '', ToRegDate: '',MemberShipCardNo:'' };
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
                else if (e.target.id == 'txtUHIDNo') {
                    if (e.target.value.length == 0) {
                        toast('Info', 'Invalid UHID No.', '');
                        return;
                    }
                    data.Patient_ID = e.target.value;
                }
                else if (e.target.id == 'txtMemberShipCardNo') {
                    if (e.target.value.length == 0) {
                        toast('Info', 'Invalid MemberShipCard No.', '');
                        return;
                    }
                    data.MemberShipCardNo = e.target.value;
                }
                
                data.FromRegDate = jQuery("#txtSearchModelFromDate").val();
                data.ToRegDate = jQuery("#txtSerachModelToDate").val();
                $PNameMob.length = 0;
                jQuery('.clMoreFilter').hide();
                if (jQuery('#tablePatient').find('tr:not(#Header)').length == 0) {
                    $getOldPatientDetails(data, '../Lab/Services/LabBooking.asmx/BindOldPatient', function (response) {
                        jQuery('#tablePatient tr').remove();
                        if (!String.isNullOrEmpty(response)) {
                            var $resultData = JSON.parse(response);
                            if ($resultData.length > 0) {
                                $bindOldPatientDetailsContact(response);
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
        var $getOldPatientDetails = function (data, url, callback) {
            serverCall(url, data, function (response) {
                callback(response);
            });
        }
    </script>
    <script type="text/javascript">
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
        var $onTitleChange = function (gender) {
            var $gender = jQuery('#ddlGender').val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                jQuery('#ddlGender').val("").prop('disabled', false);
            }
            else {
                jQuery('#ddlGender').val(gender).prop('disabled', true);
            }
            if ($gender != jQuery('#ddlGender').val()) {
                $resetItem("0");
            }
            if (jQuery("#ddlTitle option:selected").text() == 'NA')
                $('#txtothertitle').show();
            else
                $('#txtothertitle').hide();
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
    </script>
    <script type="text/javascript">
        bindApprovalType = function () {
            jQuery("#ddlApprovedBy option").remove();
            serverCall('../Lab/Services/LabBooking.asmx/getDiscountApproval', { centreID: jQuery('#ddlCentre').val().split('#')[0] }, function (response) {
                var $ddlApprovedBy = jQuery('#ddlApprovedBy');
                $ddlApprovedBy.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'value', textField: 'label' });
            });
        }
        function bindOutstandingEmployee() {
            jQuery('#ddlOutstandingEmployee option').remove();
            serverCall('Lab_PrescriptionOPD.aspx/BindOutstandingEmployee', { CentreID: jQuery('#ddlCentre').val().split('#')[0] }, function (response) {
                var $ddlOutstandingEmployee = jQuery('#ddlOutstandingEmployee');
                $ddlOutstandingEmployee.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EmployeeID', textField: 'Name' });
            });
        }
        var $bindDiscountApprovalAndOutStandingEmp = function () {
            jQuery("#ddlApprovedBy option").remove();
            jQuery('#ddlOutstandingEmployee option').remove();
            var $ddlApprovedBy = jQuery('#ddlApprovedBy'); var $ddlOutstandingEmployee = jQuery('#ddlOutstandingEmployee');
            serverCall('../Common/Services/CommonServices.asmx/bindDiscountApprovalAndOutStandingEmp', { CentreID: jQuery('#ddlCentre').val().split('#')[0], IsDiscountApproval: 1, IsOutStandingEmp: 1 }, function (response) {
                $ddlApprovedBy.bindDropDown({ data: JSON.parse(response).DiscountApprovalData, valueField: 'value', textField: 'label', isSearchAble: true, defaultValue: "Select" });
                $ddlOutstandingEmployee.bindDropDown({ data: JSON.parse(response).OutstandingEmployeeData, valueField: 'EmployeeID', textField: 'Name', isSearchAble: true, defaultValue: "Select" });

            });
        };
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
            //$resetItem("1");
        }
        minTwoDigits = function (n) {
            return (n < 10 ? '0' : '') + n;
        }
        setAge = function (ctrl) {
            if (jQuery(ctrl).is(':checked')) {
                jQuery('#txtDOB').attr("disabled", true);
                jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);
                jQuery('#txtDOB').removeClass('requiredField');
                jQuery('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
            }
        }
        setDOB = function (ctrl) {
            if (jQuery(ctrl).is(':checked')) {
                jQuery('#txtDOB').attr("disabled", false);
                jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", true);
                jQuery('#txtDOB').addClass('requiredField');
                jQuery('#txtAge,#txtAge1,#txtAge2').removeClass('requiredField');
            }
        }
    </script>
    <script type="text/javascript">
        $resetItem = function ($con) {
            $InvList = [];
            jQuery('#tb_ItemList tr').slice(1).remove();
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            $getPaymentMode($con, function () { });
            $updatePaymentAmount();
            jQuery('#spnTotalDiscountAmount').text('0');
            jQuery('#spnBlanceAmount').text('');
            jQuery('#txtDiscountAmount,#txtDiscountPerCent,#txtOutstandingAmt').val('0');
            jQuery('#txtDiscountReason,#txtCardHolderName,#txtCorporateIDCard').val('');
            jQuery('#ddlOutstandingEmployee,#ddlCorporateIDType,#ddlGovPanelType,#ddlCardHolderRelation,#ddlOutstandingEmployee').prop('selectedIndex', 0);
            jQuery('#lblOutstandingDiscount').text("");
            jQuery('#chkCashOutstanding').prop('checked', false);
            jQuery('.clCashOutstanding').hide();
            jQuery('#lblTestCount').text('Test Count:0');
            $TestCount = 0;
        }
        setPaymentMode = function () {

        }
    </script>
    <script type="text/javascript">
        var $bindDocumentMasters = function (callback) {
            serverCall('../Common/Services/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: jQuery('#spnUHIDNo').text() }, function (response) {
                $responseData = JSON.parse(response);
                documentMaster = $responseData.patientDocumentMasters;
                var $template = jQuery('#template_DocumentMaster').parseTemplate(documentMaster);
                jQuery('#documentMasterDiv').html($template);
                jQuery('#ddlDocumentType').bindDropDown({ defaultValue: 'Select', data: documentMaster, valueField: 'ID', textField: 'Name' });
                callback(true);
            });
        }
        var previewImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+XCanHAAAC1BJREFUeNrs3flT01wbxnGhFUT2vcoiZR9AdMQZ///f1QFEZZO9QIvUQilQ1uea3vMeM+lC1b4Pwef7+YEp6clJGnLl3ElLU5VIJB4B+BtVswkA4g2AeAMg3gCINwDiDYB4A8QbAPEGQLwBEG8AxBsA8QaINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbIN4AiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3QLwBEG8AxBsA8QZAvAEQb4B4AyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AAizMJnig9vf3V1dXSzR4/Pjx27dvQ6EQ24rRGw/M6elp6QaXOWwo4g2A4hz35/b2NpFIJJPJbDarxxcXF3fO8uXLl6qqqoosXf2o2m9paYlEIhT8D0WV9hi2QvBdXV0tLCycnJzc+5rU19dPT0+TcIpzVMz6+noQsi2ZTGZra4u/CPFGxRweHgZnZQ4ODviLEG9Usjj3/hoOh5ubm3UyfC8rU85pP4KAS2sPT3t7+9jYWHV19e3t7erqajwe/7U/eTjc1NSkU2g7OlxfX5+enh4dHRFa4o37Nzw8rGw/yl3NHhoaUql8c3NTzowNDQ29vb06OhS8nH58fByLxQJ1FgDi/d9ib1D9PLmqrg6FQnfGW22i0WgkEinRpiknlUqtrKxks1k2Nefe+LepIP/+/bv7VUX1nR9N0+Hg5cuXvmxbTZ7JZHyzt7S0vH79WuM8m5rRG/dgeXlZyVQC9XN7e/vOcXtqakpn2m5KIpHY399Pp9M6UtiUp0+fdnV1PXv2zN7N1uFgcnJyfn7+7OyMrU288a9SKV7+O8+Dg4Mu2yq5v379au+f6+ig6artLy4uVAJsbGzs7u6OjY01NzdbwsfHx2dnZ90hAMQbwdLY2Njd3e2yrQFZPzs7O1+8ePHkyRNvwa8hXQlfWFjQUG8JV/g1nivzbEbijSDq7e31lvTKdjQa7enpubq62tvb0zCuM3DlvK2tTUcBnXV/+vRpcXFxZmYmHA7b7GrGAE68ETg6kVZu7XEymVQFHolElG0NyJubmwq2a7mzs6Nsj46O6pT748eP+nVgYEDTa2pqmpqaNCMb84HiyvlfS8l072+r9tZptkK7vr6+trbmzbZJpVJzc3Nqr4Lc+5lTK9RBvBEs3rPr4+Pj1tZWZTgWixVrr9J9aWmpo6Mjm2MT6+rq2JLEG8E77wr/PPO6vLxUUDc2NkrPkk6n7c0w92a4fTwOxBvB4q3AFfVMJnN+fn7nXPaZGXdo4Loa8UYQeT9YWl9f/+PHj3LmUgGvbNfW1uZ3AuKNoFCl7R7rjLrMuTRct7W1uWtyOmlnSxJvBM7FxYVLeFdXl/dKWwkKdl9fnyvvNZizJYk3gsh95qy6unpkZKScr1WMRqPuank8Hs9/Cw3EG4FwcHDgquvm5uaJiQnv5fT8cXtgYOD58+f26+XlJd+pRrwRaMvLy+6LnFpbW9+8edPd3Z3/dpeeevXqle9DrL5vgMKDw4dS/3Ln5+efP3+enJy0cbumpkZV+uDgoEb1bDZ7c3OjKflf27ayslLmlXYQb9yndDo9Nzc3Pj7u/jM0FAppuC7YWDW5xm2yTbzxYJydnc3Ozuq8uqenR8N1wTbX19fxeFzn29TkxBsPzO3tbSwW293dbcnJ/6bUZDLJdXLijYcd8h85bIr/Aq6cPwyBuqcX/2dCvFFJ7osZgoB/AifeqKT+/v6ADOBaDfsuFwQfNwB+ME5PTzc2NlKpVJn3JKm4cDisIkIHmjI/vg7iDYDiHADxBkC8AeINgHgDIN4AiDcA4g2AeP9Vstns0dFRAL+K3Lti5axksTZXV1eanslk+FsT7/+Lra2tLzluJ0skEvo1CJ/2Ozw8XFhY0M+gbTTvipWzksXaaJtr+ubmJvvh7+H/ve9wcnJi/x2tkWR6etoeaEpLS8u9r1t7e3t9fX0APwEe2BUj3igsnU5rJO/v7/dN1zCeSqWUee3N2q3z/1lSNafGpXA4HAqF9EAtu7u71fLR/76HvKurK5lM2gObaDcPUIc9PT21tbXWTLPYvYHcXOfn51ZT2HQ9jsfjdiOxjo4ONbBF61f7emMrdBU8raTvqfyXo8cNDQ0WVLVUe5vR2qiBHutFaYk6Aj7K/cOJ2ltvvhVztALqytZQr0492HZwpbi9dnWlF+6+Gc4rf+OwZ1Kc/6nOzk793N7e9t3LXoF3Xyq6t7dXsMLU3ry+vq5msVjMRv7FxUXrZz1nfn5ez9q9+1T2a8pVjjqcnZ3VA+vBelZs9Hh/f9/uCqjHFiR1qMZ2a24didShkqC9X+usNnZaqypXjxVIa6/HlkwvrYZN1EI1r16RVuD6+trN6FZbK2BtbKIWrYl26PGumK/YtjW0V+e2g1FXdmRRG1uub/aCG4edk9H7T2m8tWR++/bN3a9LU7RHai+fmZnRT+2p2imVYe+I5LS2tk5MTNj4Y1l143xvb69yqB40UYvQoWR0dFTT19bWtBNrqFSHeqDgaWy0kEciEV//doI6NTWlQU9hfv/+vdZN7dWb5tW6abpir6UoPIODg5bh/FOMoaEhrYxemqKoF3t2dqYHbW1tbkZ1pWf1ctRM9ci7d+/sQKOu9LqUT1854CvaXR2hg4U61IxuO0SjUXtWMdZ2UEXjHZyLbZwSiwPxLpf2qg8fPmh3d+OVjU6NjY32FeK2m3pv3FeQ1Zzee/FaTW47vQ2DNsQ56rmurk49K7c2yOcfQWy5GtC8ta7NqxgozLbEvr4+hVALsnjnfwmMntrZ2bG7fP/cS8JhO0wocjajO8YpZr61LUGrtLS0dOcm0pFCSVZjb7ytAMnfOCDeldhS4fDw8LDqSe8UlyL3oMRdfry7aYlmCpKKBferXaDScK1YqjRQ8NQg/5xTHWoFxsfHfT3bgcDOVzXk6lBitYMypn58jbVuqup1KFEVoOOCjaKuH8Vb/WiK5rJDks5NFDaNunpWhw8VL6Vfu7Kt9ddKqnMNvFqTgs1K3Ie84MYB594VoJ3YTsLdOGyDquptDXoax9xZesGByy4s2T5d8MK7RVH5sbpAsxzmuKcUsGLz2nJV8dpRxkpr99RZjma0cdgGwIaGhmK5skV7Y2YVhGbUU+41WgO7OuC7KlGQFQU6k9fq5d971DrRxrSX6atQSmwcMHpXhk4+rW60X8fGxjQiuVFIw2P+pXW3Z7vBTRWyK8i9NCZrZLMLYG7iyMiIPaXOvSOnjy1XwXDjrbvRp1JtebaE+H71nQXYUlSk6KTD96xVEHYlwl2S0NFtO6fYcc1L47xdZdSryO9fgbdg61m11Ev2Hl9KbBwUw5cxVYDGE3tjrOD7NHbJTbEZGhrS/lqsWX6Hj379O0ntkphVrb/9ppH1UPB9qWJLVOM7z0pc/a+NUOx12bOle/vtjcPojd9RZhJqcyrYYcELBH++0//S0n91iaU3Qjmb6Lc3DvFG5WkgValZ5uAGUJwDuBtXzgHiDYB4AyDeAIg3AOINgHgDxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbAPEGiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AiDcA4g2AeAMg3gCIN0C8ARBvAMQbAPEGQLwBFPSPAAMA10pqClMkh7QAAAAASUVORK5CYII=';
        ShowCaptureImageModel = function () {
            jQuery('#camViewer').showModel();
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
        $closeCamViewerModel = function (callback) {
            //Webcam.snap(function (data_uri) {
            jQuery('#camViewer').closeModel();
            document.getElementById('imgPreview').src = previewImage; //'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            Webcam.reset();
            callback();
            // });
        }
        selectImage = function (base64image) {
            base64image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            $closeCamViewerModel(function () {
                document.getElementById('imgPatient').src = base64image;
                jQuery('#spnIsCapTure').text('1');
            });
        }
        showDocumentMaster = function () {
            var $filename = "";
            if (jQuery('#spnFileName').text() == "") {
                $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                $filename = jQuery('#spnFileName').text();
            }
            jQuery('#spnFileName').text($filename);
            jQuery('#divDocumentMaters').show();
        }
        $showManualDocumentMaster = function () {
            var $filename = "";
            if (jQuery('#spnFileName').text() == "") {
                $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                $filename = jQuery('#spnFileName').text();
            }
            jQuery('#spnFileName').text($filename);
            jQuery('#divDocumentMaualMaters').show();
            if (jQuery("#tblMaualDocument tr").length == 0) {
                serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: '', Filename: jQuery('#spnFileName').text(), PatientID: '', oldPatientSearch: 0, documentDetailID: 0, isEdit: 0 }, function (response) {
                    var $maualDocument = JSON.parse(response);
                    $addPatientDocumnet($maualDocument, 0);
                });
            }
        }
        $documentNameClick = function (elem, row) {
            jQuery(row.parentNode).find('tr button[type=button]').attr('style', 'width: 100%; text-align: center; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')
            jQuery('#tblDocumentMaster tr #tdBase64Document').each(function (index, elem) {
                if (!String.isNullOrEmpty(jQuery(this).text()))
                    jQuery(this).parent().find('button[type=button]').css({ 'backgroundColor': 'LIGHTGREEN', 'background-image': 'none' });
            });
            jQuery(elem).css({ 'backgroundColor': 'antiquewhite', 'background-image': 'none' });
            elem.style.color = 'black';
            var $seletedDocumentID = jQuery(row).find('#tdDocumentID').text();
            jQuery('#spnSelectedDocumentID').text($seletedDocumentID);
            var $scanDocument = jQuery(row).find('#tdBase64Document')[0].innerHTML;
            if ($scanDocument != '')
                document.getElementById('imgDocumentPreview').src = $scanDocument;
            else {
                var $patientId = jQuery('#spnUHIDNo').text();
                if ($patientId != '') {
                    serverCall('../Common/Services/ScanDocumentServices.asmx/GetDocument', { patientId: $patientId, documentName: elem.value }, function (response) {
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
        $showScanModel = function () {
            if (jQuery('#spnSelectedDocumentID').text() != '') {
                serverCall('../Common/Services/ScanDocumentServices.asmx/GetShareScanners', {}, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        jQuery('#ddlSccaner').bindDropDown({ data: $responseData.data, defaultValue: null, valueField: 'DeviecId', textField: 'Name' });
                    }
                    else
                        modelAlert('Error While Access Scanner');
                });
                document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                jQuery('#divScanViewer').showModel();
            }
            else
                modelAlert('Please Select Document First !!');
        }
        $scanDocument = function (deviceId) {
            serverCall('../Common/Services/ScanDocumentServices.asmx/Scan', { deviceID: deviceId }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status)
                    jQuery('#imgScanPreview').attr('src', 'data:image/jpeg;base64,' + $responseData.data);
                else
                    modelAlert('Error While Scan');
            });
        }
        $selectScanDocument = function (base64Document) {
            var $selectedDocumentID = jQuery('#spnSelectedDocumentID').text().trim();
            jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                if (this.innerHTML.trim() == $selectedDocumentID) {
                    jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                    jQuery('#imgDocumentPreview').attr('src', base64Document);
                    jQuery('#divScanViewer').closeModel();
                }
            });
        }
        $showCaptureModel = function () {
            if (jQuery('#spnSelectedDocumentID').text() != '') {
                document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                jQuery('#divDocumentCapture').showModel();
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
        $takeProfilePictureSnapShot = function () {
            Webcam.snap(function (data_uri) {
                jQuery('#imgPreview').attr('src', data_uri);
                jQuery('#btnSelectImage').show();
            });
        }
        $selectPatientProfilePic = function (base64Image) {
            $closeCamViewerModel(function () {
                document.getElementById('imgPatient').src = base64Image
                jQuery('#spnIsCapTure').text('1');
            });
        }
        $takeDocumentSnapShot = function () {
            Webcam.snap(function (data_uri) {
                jQuery('#imgDocumentSnapPreview').attr('src', data_uri);
                jQuery('#btnSelectDocumentCapture').show();
            });
        }
        selectDocumentCapture = function (base64Document) {
            var $selectedDocumentID = jQuery('#spnSelectedDocumentID').text().trim();
            jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                if (this.innerHTML.trim() == $selectedDocumentID) {
                    jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                    jQuery('#imgDocumentPreview').attr('src', base64Document);
                    jQuery('#divDocumentCapture').closeModel();
                }
            });
            Webcam.reset();
        }
        $closeDocumentCapture = function () {
            jQuery('#divDocumentCapture').closeModel();
            document.getElementById('imgDocumentSnapPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            Webcam.reset();
        }
        $closePatientDocumentModel = function () {
            $getUpdatedPatientDocuments(function ($responseData) {
                jQuery('#spnDocumentCounts').text($responseData.length);
                jQuery('#divDocumentMaters').closeModel();
            });
        }
        $closePatientManualDocModel = function () {
            jQuery('#divDocumentMaualMaters').closeModel();
        }
        $getUpdatedPatientDocuments = function (callback) {
            var $patientDocuments = [];
            jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                if (jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                    var $document = {
                        documentId: this.innerHTML.trim(),
                        name: jQuery(this.parentNode).find('#btnDocumentName').val(),
                        data: jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                    }
                    $patientDocuments.push($document);
                }
            });
            callback($patientDocuments);
        }
    </script>    
    <script type="text/javascript">
        var $bindMandatory = function (callback) {
            var manadatory = [
                { control: '#txtMobileNo', isRequired: true, erroMessage: 'Enter Mobile Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPName', isRequired: true, erroMessage: 'Enter Patient Name', tabIndex: 2, isSearchAble: false },
            ];
            jQuery(manadatory).each(function (index, item) {
                jQuery(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                jQuery(manadatory[0].control).focus();
            });
            callback(true);
        }
        </script>
    <script type="text/javascript">
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
            jQuery(".setCollectionDate").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-20:+0",
                maxDate: new Date()
            }).attr('readonly', 'readonly');

        }
        $onPreBooking = function () {
            jQuery("#txtPreBookingNo").on("blur", function () {
                if (jQuery("#txtPreBookingNo").val() != "") {
                    $modelBlockUI();
                    $searchPreBookingNo('0', '0');
                }
            });
            jQuery("#txtPreBookingNo").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       jQuery("#txtPreBookingNo").blur();
                   }
                   else if (key == 9) {
                       jQuery("#txtPreBookingNo").blur();
                   }
               });
        };
        jQuery("#txtHomeCollection").on("blur", function () {
            if (jQuery("#txtHomeCollection").val() != "") {
                $modelBlockUI();
                searchHomeCollectionData();
            }
        });
        jQuery("#txtHomeCollection").keydown(
             function (e) {
                 var key = (e.keyCode ? e.keyCode : e.charCode);
                 if (key == 13) {
                     e.preventDefault();
                     jQuery("#txtHomeCollection").blur();
                 }
                 else if (key == 9) {
                     jQuery("#txtHomeCollection").blur();
                 }
             });
        var $searchPreBookingNo = function (con, PreBookingIDExit, callback) {
            if (con == 0) {
                serverCall('Lab_PrescriptionOPD.aspx/PreBookingData', { PreBookingNo: jQuery('#txtPreBookingNo').val() }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        var PreBookingData = JSON.parse(response);
                        jQuery("#txtPreBookingNo").attr("disabled", true);
                        jQuery('#ddlPatientType').val('3').attr("disabled", true);
                        jQuery('#divPUPDetail').show();
                        jQuery('#divHLMDetail,.divCorporate,.divCardCorporate').hide();
                        jQuery('#txtMobileNo').attr("tabindex", -1);
                        jQuery('#rdAge').prop("checked", true);
                        jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);
                        jQuery('#txtDOB').attr("disabled", true);
                        if (PreBookingIDExit == 0) {
                            jQuery('#spnUHIDNo').html(PreBookingData[0].Patient_ID);
                            jQuery('#txtUHIDNo').val(PreBookingData[0].Patient_ID).attr("disabled", true);
                            jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == PreBookingData[0].Title })[0]).prop('selected', true).attr('disabled', 'disabled');
                            $onTitleChange(jQuery('#ddlTitle').val());
                            jQuery('#ddlTitle').attr('disabled', 'disabled');
                            jQuery("#txtPName").val(PreBookingData[0].PName).attr("disabled", true);
                            jQuery("#txtPinCode").val(PreBookingData[0].PinCode);
                            jQuery("#txtMobileNo").val(PreBookingData[0].Mobile).attr("disabled", true);
                            jQuery("#txtDOB").val(PreBookingData[0].DOB);
                            jQuery("#txtAge").val(PreBookingData[0].AgeYear);
                            jQuery("#txtAge1").val(PreBookingData[0].AgeMonth);
                            jQuery("#txtAge2").val(PreBookingData[0].AgeDays);
                            jQuery("#txtEmail").val(PreBookingData[0].Email);
                            jQuery("#txtPAddress").val(PreBookingData[0].House_No);
                            jQuery("#ddlGender").val(PreBookingData[0].Gender).attr("disabled", true);
                            jQuery("#ddlState").val(PreBookingData[0].StateID);
                        }
                        jQuery("#ddlVisitType").val(PreBookingData[0].VisitType);
                        if (PreBookingData[0].VisitType == "Home Collection") {

                        }
                        serverCall('Lab_PrescriptionOPD.aspx/bindPreBookingPanel', { PanelID: PreBookingData[0].Panel_ID, PaymentMode: PreBookingData[0].PaymentMode }, function (response) {
                            var $ddlPanel = jQuery('#ddlPanel');
                            jQuery("#ddlPanel option").remove();
                            $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'value', textField: 'label', isSearchAble: true, showDataValue: 1 });

                            $setPUPData();

                            $getPaymentMode("0", function () { });
                        });
                        for (var i = 0; i < PreBookingData.length ; i++) {
                            var investigation = {};
                            investigation.item = PreBookingData[i];
                            $validateInvestigation(investigation, function () { });
                            //  $validateInvestigation({ val: PreBookingData[i].ItemId, Rate: PreBookingData[i].Rate, label: "", DiscPer: '0', Type: PreBookingData[i].Type }, function () { });
                        }
                    }
                    else {
                        modelAlert('No Record Found');
                    }
                });
                $modelUnBlockUI(function () { });
            }
        };
        var $InvList = [];
        var $itemwisedic = 0;
        var $TestCount = 0;
        jQuery(function () {
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
			
            $bindTitle(function () {
                $bindStateCityLocality("1", function (callback) {
                    $bindLocality($('#ddlCity').val(), "0", function () { });
                    $bindDOB();
                    $bindDepgroup();
                    $onSearchInvestigation();
                    $onRefDoctorSearch(); $onSecondRefSearch();
                    $onPreBooking();
                    $bindDocumentMasters(function (callback) {
                        $getCentreData("1", function (callback) {
                            $bindSpecialCharater(function (callback) {
                            });
                            $bindOutstandingAmt(function (callback) {
                            });
                            $bindSlide(function (callback) {
                            });
                            $getCurrencyDetails(function (baseCountryID) {
                                $getConversionFactor(baseCountryID, function (CurrencyData) {
                                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));

                                });
                            });
                        });
                    });
                });
            });
            $showoption();
			 $getCurrencyDetails(function (baseCountryID) {
                                $getConversionFactor(baseCountryID, function (CurrencyData) {
                                    jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                                    jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                                    jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));

                                });
                            });
				jQuery("#txtMobileNo").focus();
        });
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
        $bindSlide = function (callback) {
            jQuery(".button-PromotionalTest").click(function () {
                jQuery(".divPromotionalTest").slideToggle("slow");
                return false;
            });
            jQuery(".button-SuggestedTest").click(function () {
                jQuery(".divSuggestedTest").slideToggle("slow");
                return false;
            });
        };
        $bindSpecialCharater = function (callback) {
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
            callback(true);
        };
        $bindOutstandingAmt = function (callback) {
            jQuery("#txtOutstandingAmt").keyup(function (e) {
                if ($itemwisedic == 1) {
                    toast("Error", "Item Wise Discount Amount already Given", "");

                    jQuery('#txtOutstandingAmt').val('0');
                    return;
                }
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key != 9) {
                    if (isNaN(jQuery('#txtOutstandingAmt').val() / 1) == true) {
                        return;
                    }
                    if (jQuery('#txtPaidAmount').val() == "") {
                        jQuery('#txtPaidAmount').val("0");
                    }
                    if (jQuery('#ddlOutstandingEmployee').val() == "0") {
                        toast("Error", "Please select Outstanding Employee", "");
                        jQuery('#txtOutstandingAmt').val("0");
                        return;
                    }
                    var total = parseFloat(jQuery('#txtGrossAmount').val());
                    var paid = jQuery('#txtPaidAmount').val() == "" ? 0 : jQuery('#txtPaidAmount').val();
                    if (isNaN(paid) || paid == "")
                        paid = 0;
                    var disper = parseFloat(jQuery('#txtOutstandingAmt').val());
                    if ((parseInt(disper) + parseInt(paid)) > total) {
                        toast("Error", "Outstanding Amount can't greater then total amount", "");
                        var final = 0;
                        jQuery('#txtOutstandingAmt').val(total);
                        jQuery('#lblOutstandingDiscount').text(total);
                        $showDue();
                        return;
                    }
                    if (isNaN(disper / 1) == true) {
                        jQuery('#lblOutstandingDiscount').text('0');
                        $showDue();
                        return;
                    }
                    var final = total - (disper + paid);
                    $itemwisedic = 0;
                    jQuery('#txtOutstandingAmt').val(disper);
                    jQuery('#lblOutstandingDiscount').text(disper);
                    $showDue();
                }
            });
            callback(true);
        };
        var $bindTitle = function (callback) {
            var $ddlTitle = jQuery('#ddlTitle');
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
            $ddlTitle.chosen("destroy").chosen({ width: '100%' });
            jQuery('#ddlGender').attr('disabled', 'disabled');
            $bindCredHolderRelation();
            callback($ddlTitle.val());
        }
        var $bindCredHolderRelation = function () {
            serverCall('../Common/Services/CommonServices.asmx/bindCardHolderRelation', {}, function (response) {
                var $ddlCardHolderRelation = jQuery('#ddlCardHolderRelation');
                var $responseData = JSON.parse(response);
                var options = [];
                for (var i = 0; i < $responseData.length; i++) {
                    options.push('<option value="');
                    options.push($responseData[i]);
                    options.push('">');
                    options.push($responseData[i]);
                    options.push('</option>');
                }
                $ddlCardHolderRelation.append(jQuery("<option></option>").val("0").html("Select"));
                $ddlCardHolderRelation.append(options.join(""));
            });
        }
        var $bindRateType = function (callback) {
            $ddlPanel = jQuery('#ddlPanel');
            jQuery('#ddlPanel option').remove();
            serverCall('../Lab/Services/LabBooking.asmx/GetPanel', { CentreID: jQuery('#ddlCentre').val().split('#')[0], VisitType: jQuery('#ddlPatientType').val() }, function (response) {
                if (JSON.parse(response) != "")
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'value', textField: 'label', isSearchAble: true, showDataValue: 1 });
                else
                    $ddlPanel.append(jQuery("<option></option>").val("0").html("--No Rate Type-")).chosen('destroy').chosen();

                if (jQuery('#ddlPanel').val().split('#')[4] == 1) {
                    jQuery('#divPaymentControl').hide();
                }
                else {
                    jQuery('#divPaymentControl').show();
                }
                $getPaymentMode("0", function (callback) {
                });
                callback($ddlPanel.val());
            });
        }
        var $bindPRO = function (callback) {
            $ddlPRO = jQuery('#ddlPRO');
            jQuery('#ddlPanel option').remove();
            serverCall('../Lab/Services/LabBooking.asmx/GetPRO', {  }, function (response) {
                if (JSON.parse(response) != "") {
                    $ddlPRO.bindDropDown({ defaultValue: 'Select PRO', data: JSON.parse(response), valueField: 'PROID', textField: 'PROName', isSearchAble: true });
                }
                else
                    $ddlPRO.append(jQuery("<option></option>").val("0").html("--No PRO--")).chosen('destroy').chosen();
                //callback($ddlPRO.val());
            });
        }
        var $bindStateCityLocality = function (con, callback) {
            var $ddlCountry = jQuery('#ddlCountry'); var $ddlState = jQuery('#ddlState'); var $ddlCity = jQuery('#ddlCity'); var $ddlLocality = jQuery('#ddlArea'); var $ddlFieldBoy = jQuery('#ddlFieldBoy');
            var $ddlSearchModelCountry = jQuery('#ddlSearchModelCountry'); var $ddlSearchModelState = jQuery('#ddlSearchModelState'); var $ddlSearchModelCity = jQuery('#ddlSearchModelCity'); var $ddlSearchModelLocality = jQuery('#ddlSearchModelLocality');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: jQuery('#ddlCentre').val().split('#')[11], StateID: jQuery('#ddlCentre').val().split('#')[3], CityID: jQuery('#ddlCentre').val().split('#')[2], IsStateBind: 1, CentreID: jQuery('#ddlCentre').val().split('#')[0], IsCountryBind: 1, IsFieldBoyBind: 1, IsCityBind: 1, IsLocality: 1 }, function (response) {
                if (con == 1) {
                    $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[11], showDataValue: 1 });
                    $ddlSearchModelCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[11], showDataValue: 1 });
                }
                $ddlState.bindDropDown({ data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[3] });
                $ddlSearchModelState.bindDropDown({ data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[3] });
                $ddlCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[2] });
                $ddlLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[7] });
                $ddlFieldBoy.bindDropDown({ data: JSON.parse(response).fieldBoyData, valueField: 'ID', textField: 'Name', isSearchAble: true, defaultValue: "" });
                $ddlSearchModelCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[2] });
                $ddlSearchModelLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[7] });
                jQuery('#ddlFieldBoy_chosen').find('a').addClass('requiredField');
                callback($ddlLocality.val());
            });
        }
        var $bindState = function (CountryID, con, callback) {
            var $ddlState = jQuery('#ddlState');
            jQuery('#ddlState,#ddlCity,#ddlArea').find('option').remove();
            jQuery('#ddlState,#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                if (con == 0)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[3] });
                else
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });

                callback($ddlState.val());
            });
        }
        var $bindDep = function () {
            CategoryID = jQuery('#lstCategory').multipleSelect("getSelects").join();
            serverCall('../Common/Services/CommonServices.asmx/bindDept', { CategoryID: CategoryID }, function (response) {
                var DeptData = JSON.parse(response);
                // console.log(DeptData);
                jQuery('#<%=lstDepartment.ClientID%> option').remove();
                jQuery('#lstDepartment').multipleSelect("refresh");
                if (DeptData != null) {
                    for (i = 0; i < DeptData.length; i++) {
                        jQuery('#<%=lstDepartment.ClientID%>').append(jQuery("<option></option>").val(DeptData[i].SubCategoryID).html(DeptData[i].NAME));
                    }
                    jQuery('[id*=lstDepartment]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                }
            });
        }
        var $bindCategory = function () {
            serverCall('../Common/Services/CommonServices.asmx/bindCategory', {}, function (response) {
                var DeptData = JSON.parse(response);
                // console.log(DeptData);
                jQuery('#<%=lstCategory.ClientID%> option').remove();
                jQuery('#lstCategory').multipleSelect("refresh");
                if (DeptData != null) {
                    for (i = 0; i < DeptData.length; i++) {
                        jQuery('#<%=lstCategory.ClientID%>').append(jQuery("<option></option>").val(DeptData[i].CategoryID).html(DeptData[i].NAME));
                    }
                    jQuery('[id*=lstCategory]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                }
            });
        }
        var $bindCity = function (StateID, con, callback) {
            var $ddlCity = jQuery('#ddlCity');
            jQuery('#ddlCity,#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                if (con == 0)
                    $ddlCity.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[2] });
                else
                    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });

                callback($ddlCity.val());
            });
        }
        var $bindLocality = function (CityID, con, callback) {
            var $ddlArea = jQuery('#ddlArea');
            jQuery('#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                if (con == 0)
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[7] });
                else
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });

                callback($ddlArea.val());
            });
        }
        var $bindModelState = function (CountryID, callback) {
            var $ddlState = jQuery('#ddlSearchModelState');
            jQuery('#ddlSearchModelState,#ddlSearchModelCity,#ddlSearchModelLocality').empty();

            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                callback($ddlState.val());
            });
        }
        var $bindModelCity = function (StateID, callback) {
            var $ddlCity = jQuery('#ddlSearchModelCity');
            jQuery('#ddlSearchModelCity,#ddlSearchModelLocality').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                callback($ddlCity.val());
            });
        }
        var $bindModelLocality = function (CityID, callback) {
            var $ddlArea = jQuery('#ddlSearchModelLocality');
            jQuery('#ddlSearchModelLocality').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlArea.val());
            });
        }
            </script>
    <script type="text/javascript">
        $removeLabItems = function (elem) {
            var $tr = jQuery(elem).closest('tr');
            var $RmvInv = $tr.find('.inv').attr("id").split(',');
            var $len = $RmvInv.length;
            $InvList.splice(jQuery.inArray($RmvInv[0], $InvList), $len);
            jQuery(elem).closest('tr').remove();
            $updatePaymentAmount();

            $showConversionAmt("remove", jQuery("#ddlCurrency"), function () { });
            $TestCount = parseInt($TestCount) - 1;
            jQuery('#lblTestCount').text('Test Count:' + $TestCount);
            // jQuery('#divPaymentDetails input[type=text]').val('');
            // jQuery('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { jQuery(this).text(''); });


        };
    </script>
    <script type="text/javascript">
        function $viewRemarks(remarks, type) {
            var $mm = [];
            if (type == "Test") {
                $mm.push("<h3>Test Details</h3>");
                $mm.push(remarks);
            }
            else {
                $mm.push("<h3>Package Inclusions</h3>");
                for (var i = 0; i < (remarks.split('##').length) ; i++) {
                    $mm.push("".concat(i + 1, ". "));
                    $mm.push(remarks.split('##')[i]);
                    $mm.push("<br />");
                }
            }
            $mm = $mm.join("");
            jQuery("#divPopUPRemarks").html($mm);
            jQuery("#divViewRemarks").showModel();
        }
    </script>
    <script type="text/javascript">
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        $onRefDoctorSearch = function () {
            jQuery("#txtReferDoctor")
                  // don't navigate away from the field on tab when selecting an item
                  .bind("keydown", function (event) {
                      if (event.keyCode === jQuery.ui.keyCode.TAB &&
                          jQuery(this).autocomplete("instance").menu.active) {
                          event.preventDefault();
                      }
                  })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=ReferDoctor", {
                              docname: extractLast(request.term), centreid: jQuery('#ddlCentre option:selected').val().split('#')[0]
                          }, response);
                      },
                      search: function () {
                          var term = extractLast(this.value);
                          if (term.length < 1) {
                              return false;
                          }
                      },
                      focus: function () {
                          return false;
                      },
                      response: function (event, ui) {
                          if (!ui.content.length) {
                              jQuery("#txtReferDoctor").val('');
                          }
                      },
                      open: function () {
                          jQuery("#txtReferDoctor").attr('rel', 0);
                      },
                      close: function () {
                          if (jQuery("#txtReferDoctor").attr('rel') != '0')
                              jQuery("#txtReferDoctor").val('');
                      },
                      change: function (event, ui) {
                          if (ui.item == null) {
                              jQuery("#txtReferDoctor").val('');
                              return;
                          }
                          if (ui.item.label != jQuery("#txtReferDoctor").val()) {
                              jQuery("#txtReferDoctor").val('');
                          }
                      },
                      select: function (event, ui) {
                          //if (jQuery('#ddlPatientType').val() == "4" && ui.item.value == "1") {
                          //    jQuery("#txtReferDoctor,#hftxtReferDoctor").val('');
                          //    toast("Error", "You can not Select SELF in case of HLM", "");
                          //    return false;
                          //}
                          jQuery("#hftxtReferDoctor").val(ui.item.value);
                          this.value = ui.item.label;
                          if (ui.item.value == "2") {

                          }
                          else {

                          }
                          return false;
                      },
                  });
        }
        $onSecondRefSearch = function () {
            jQuery("#txtSecondReference")
                  // don't navigate away from the field on tab when selecting an item
                  .bind("keydown", function (event) {
                      if (event.keyCode === jQuery.ui.keyCode.TAB &&
                          jQuery(this).autocomplete("instance").menu.active) {
                          event.preventDefault();
                      }
                  })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=ReferDoctor", {
                              docname: extractLast(request.term), centreid: jQuery('#ddlCentre option:selected').val().split('#')[0]
                          }, response);
                      },
                      search: function () {
                          var term = extractLast(this.value);
                          if (term.length < 1) {
                              return false;
                          }
                      },
                      focus: function () {
                          return false;
                      },
                      response: function (event, ui) {
                          if (!ui.content.length) {
                              jQuery("#txtSecondReference").val('');
                          }
                      },
                      open: function () {
                          jQuery("#txtSecondReference").attr('rel', 0);
                      },
                      close: function () {
                          if (jQuery("#txtSecondReference").attr('rel') != '0')
                              jQuery("#txtSecondReference").val('');
                      },
                      change: function (event, ui) {
                          if (ui.item == null) {
                              jQuery("#txtSecondReference").val('');
                              return;
                          }
                          if (ui.item.label != jQuery("#txtSecondReference").val()) {
                              jQuery("#txtSecondReference").val('');
                          }
                      },
                      select: function (event, ui) {
                          jQuery("#hfSecondReference").val(ui.item.value);
                          this.value = ui.item.label;
                          return false;
                      },
                  });
        }
    </script>
    <script type="text/javascript">
        var $previousInvSearch;
        $onSearchInvestigation = function () {
            var $discountType = "";
            jQuery("#txtInvestigationSearch").bind("keydown", function (event) {
                if ($previousInvSearch != null)
                    $previousInvSearch.abort();
                if (event.keyCode === jQuery.ui.keyCode.TAB &&
                jQuery(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
                if (jQuery("#ddlGender option:selected").text() == "") {
                    toast("Error", "Please Select Gender", "");
                    jQuery("#ddlGender").focus();
                    return;
                }
                if (jQuery('#ddlPatientType').val() == "1") {
                    $discountType = 1;
                }
                else {
                    $discountType = "";
                }
            })
          .autocomplete({
              autoFocus: true,
              source: function (request, response) {
                  $previousInvSearch = jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=GetTestList",
                         {
                             ReferenceCodeOPD: jQuery('#ddlPanel').val().split('#')[1],
                             SearchType: jQuery('input:radio[name=labItems]:checked').val(),
                             CentreCode: jQuery('#ddlCentre').val().split('#')[0],
                             Gender: jQuery("#ddlGender option:selected").text(),
                             DOB: jQuery('#txtDOB').val(),
                             Panel_Id: jQuery('#ddlPanel').val().split('#')[0],
                             PanelType: jQuery('#ddlPanel').val().split('#')[5],
                             DiscountTypeID: $discountType,
                             PanelID_MRP: jQuery('#ddlPanel').val().split('#')[18],
                             TestName: extractLast1(request.term),
                             MemberShipCardNo: jQuery("#spnMembershipCardID").text(),
                             DeptID: jQuery('#lstDepartment').multipleSelect("getSelects").join()
                         }, response);
              },
              search: function () {
                  // custom minLength
                  var term = extractLast1(this.value);
                  //if (term.length < 2) {
                  //    return false;
                  //}
                  if (iseven(term.length) == false) {
                      return false;
                  }
              },
              focus: function () {
                  // prevent value inserted on focus
                  return false;
              },
              select: function (e, i) {
                  this.value = '';

                  $validateInvestigation(i, function () { });
                  return false;
              },
          });
        }
        function extractLast1(term) {
            var length = jQuery('#ddlPanel > option').length;
            if (length == 0) {
                toast("Error", "Please Select Rate Type", "");
                jQuery('#ddlPanel').focus();
            }
            return split(term).pop();
        }
        function iseven(val) {
            if (val % 2 === 0 || val == 3) { return true; }
            else { return false; }
        }
        $bindItems = function (data, callback) {
            serverCall('../Common/Services/CommonServices.asmx/GetTestList', data, function (response) {
                var $responseData = jQuery.map(JSON.parse(response), function (item) {
                    return {
                        label: item.label,
                        value: item.value,
                        DiscPer: item.DiscPer,
                        Rate: item.Rate,
                        Type: item.type
                    }
                });
                callback($responseData);
            });
        }
        $validateInvestigation = function (ItemID, callback) {
            if (jQuery('#tb_ItemList tr td #spnItemID').filter(function () { return (jQuery(this).text().trim() == ItemID.item.value) }).length > 0) {
                toast('Info', "Selected Item Already Added", '');
                jQuery('#txtInvestigationSearch').val('').focus();
                jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
                return;
            }
            $getItemRate(ItemID, function (investigationRateDetails) {
                $addInvestigationRow(ItemID, investigationRateDetails, function () {
                    if (jQuery("#ddlPanel").val().split('#')[4] == "0")
                        $updatePaymentAmount();
                    else
                        jQuery('#tb_ItemList').show();
                    $ItemID = ItemID.item.value;
                    $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });

                   // if ('<%=Resources.Resource.ConcentFormApplicable%>' == "1" && '<%=Resources.Resource.ConcentFormOpen%>' == "1")
                    //    $openConcentForm(investigationRateDetails.Investigation_Id, investigationRateDetails.type, investigationRateDetails.typeName, function () { });
                    $bindPromotionalTest($ItemID, function () { });
                });
            });
        };
        $openConcentForm = function (LabID, callback) {
             $hidePromotionalTest();
            if (LabID == "" || LabID == null) {
                return false;
            }
            serverCall('Lab_PrescriptionOPD.aspx/CheckConcentForm', { LabID: LabID }, function (response) {
                $responseData = JSON.parse(response);
              // if ($responseData.status) {
              //     var age = "";
              //     var ageyear = "0";
              //     var agemonth = "0";
              //     var ageday = "0";
              //     if ($('#txtAge').val() != "") {
              //         ageyear = $('#').val();
              //     }
              //     if ($('#txtAge1').val() != "") {
              //         agemonth = $('#txtAge1').val();
              //     }
              //     if ($('#txtAge2').val() != "") {
              //         ageday = $('#txtAge2').val();
              //     }
              //     age = ageyear + " Y " + agemonth + " M " + ageday + " D ";
               //     var $ConcernForm = jQuery.parseJSON($responseData.response);
                    var $ConcernForm = jQuery.parseJSON($responseData.response);
                if ($ConcernForm.length > 0) {
                    for (var i = 0; i < $ConcernForm.length; i++) {
                                 window.open("../ConcentForm/PrintConcentFrom.aspx?ReferDoctor=" + $ConcernForm[i].DoctorName + "&Panel=" + $ConcernForm[i].PanelName + "&TestName=" + $ConcernForm[i].ItemName + "&Gender=" + $ConcernForm[i].Gender + "&Age=" + $ConcernForm[i].Age + "&PatientName=" + $ConcernForm[i].PName + "&RegDate=" + $ConcernForm[i].RegDate + "&Name=" + $ConcernForm[i].ConcernFormid + "&Mobile=" + $ConcernForm[i].Mobile + "&DocMobile=" + $ConcernForm[i].DocMobile + "&Patient_ID=" + $ConcernForm[i].Patient_ID + "&LabNo=" + $ConcernForm[i].LabNo);
                       
                    }
                }

                //}

            });

        }
        $addInvestigationRow = function (ItemID, investigationRateDetails, callback) {
            var $inv = investigationRateDetails.Investigation_Id;
            for (var i = 0; i < ($inv.split(',').length) ; i++) {
                if (jQuery.inArray($inv.split(',')[i], $InvList) != -1) {
                    toast("Info", "Item Already in List", "");
                    return;
                }
            }
            for (var i = 0; i < ($inv.split(',').length) ; i++) {
                $InvList.push($inv.split(',')[i]);
            }
            var $investigationTr = [];
            $investigationTr.push("<tr id='"); $investigationTr.push(investigationRateDetails.ItemID); $investigationTr.push("'>");
            $investigationTr.push("<td id='tdTestCode'>");
            $investigationTr.push(investigationRateDetails.testCode);
            $investigationTr.push("</td><td id='tdItemName' style='text-align:left; width:200px; max-width: 200px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;' class='GridViewLabItemStyle'>");
            $investigationTr.push("<span data-title='");
            $investigationTr.push(investigationRateDetails.typeName); $investigationTr.push("'");
            $investigationTr.push('id="spnItemName">'); $investigationTr.push(investigationRateDetails.typeName);
            $investigationTr.push("</span></td>");
            $investigationTr.push("<td style='text-align:center;'>");
            if (investigationRateDetails.SampleRemarks != "") {
                $investigationTr.push('<a href="javascript:void(0);" onclick="$viewRemarks(\'');
                $investigationTr.push(investigationRateDetails.SampleRemarks); $investigationTr.push("\',"); $investigationTr.push("\'");
                $investigationTr.push(investigationRateDetails.type); $investigationTr.push("\');"); $investigationTr.push('">');
                $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
            }
            $investigationTr.push("</td><td style='text-align:center;'>");
            $investigationTr.push('<a  href="javascript:void(0);" onclick="$viewDOS(\'');
            $investigationTr.push(investigationRateDetails.Investigation_Id); $investigationTr.push("\',"); $investigationTr.push("\'");
            $investigationTr.push(jQuery("#ddlCentre").val().split('#')[0]);
            $investigationTr.push("\',"); $investigationTr.push("\'"); $investigationTr.push(investigationRateDetails.type); $investigationTr.push("\',this);"); $investigationTr.push('">');
            $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
            $investigationTr.push("</td>");
            $investigationTr.push('<td id="tdMRP"  style="text-align:right">');
            $investigationTr.push(investigationRateDetails.MRP); $investigationTr.push("</td>");
            if (jQuery("#ddlPanel").val().split('#')[4] == "0") {

                $investigationTr.push('<td id="tdRate"  style="text-align:right;width:50px;">');
                $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('</td>');

                if (investigationRateDetails.IsRequiredQuantity == '1') {

                    $investigationTr.push('<td id="tdQuantity">');
                    $investigationTr.push('<select id="ddlIsRequiredQty" onchange="getqnty(this)">');
                    $investigationTr.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>'); $investigationTr.push('</select></td>');
                }
                else {
                   
                    $investigationTr.push('<td id="tdQuantity">');
                    $investigationTr.push('<select id="ddlIsRequiredQty" style="display:none">'); $investigationTr.push('<option>1</option>'); $investigationTr.push('</select></td>');
                }

                $investigationTr.push('<td id="tdItemWiseDiscount">');
                if (jQuery('#ddlPatientType').val() == "1" && investigationRateDetails.DiscAmt > 0) {
                    $investigationTr.push('<input id="txtItemWiseDiscount" style="width:50px;" autocomplete="off" type="text" disabled="disabled" onlynumber="10"  value="');
                    $investigationTr.push(investigationRateDetails.DiscAmt); $investigationTr.push('"'); $investigationTr.push(' max-value="'); $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('"');

                }
                if (jQuery('#ddlPatientType').val() == "8" && investigationRateDetails.DiscAmt > 0) {
                    $investigationTr.push('<input id="txtItemWiseDiscount" style="width:50px;" autocomplete="off" disabled="disabled" type="text" onlynumber="10"  value="');
                    $investigationTr.push(investigationRateDetails.DiscAmt); $investigationTr.push('"'); $investigationTr.push(' max-value="'); $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('"');

                }
                else if (jQuery('#ddlPatientType').val() == "1" || jQuery('#ddlPatientType').val() == "8") {
                    $investigationTr.push('<input id="txtItemWiseDiscount" autocomplete="off" onlynumber="10" type="text" style="width:50px;" class="ItDoseTextinputNum"  value="0"  ');
                    $investigationTr.push(' max-value="'); $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('"');
                    $investigationTr.push('onkeyup="$setItemwiseDiscount(this);" onkeypress="$removeZero(this);" />');
                }
                else {
                    $investigationTr.push('<input id="txtItemWiseDiscount" autocomplete="off" onlynumber="10" type="text" style="width:50px;" class="ItDoseTextinputNum" disabled="disabled"  value="0"  ');
                    $investigationTr.push(' max-value="'); $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('"');
                    $investigationTr.push('onkeyup="$setItemwiseDiscount(this);" onkeypress="$removeZero(this);"/>');
                }
                $investigationTr.push('</td><td id="tdNetAmount" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtNetAmt" value="');
                $investigationTr.push(investigationRateDetails.Amount); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
            }
            else {
                $investigationTr.push('<td id="tdRate"  style="text-align:right;display:none">');
                $investigationTr.push(0); $investigationTr.push('</td>');
                if (investigationRateDetails.IsRequiredQuantity == '1') {

                    $investigationTr.push('<td id="tdQuantity" style="text-align:right;">');
                    $investigationTr.push('<select id="ddlIsRequiredQty" onchange="getqnty(this)">');
                    $investigationTr.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>'); $investigationTr.push('</select></td>');
                }
                else {
                   
                    $investigationTr.push('<td id="tdQuantity">');
                    $investigationTr.push('<select id="ddlIsRequiredQty" style="display:none">'); $investigationTr.push('<option>1</option>'); $investigationTr.push('</select></td>');
                }
                $investigationTr.push('<td id="tdItemWiseDiscount" style="display:none"> ');
                $investigationTr.push('<input id="txtItemWiseDiscount" type="text" class="ItDoseTextinputNum" style="width:50px;display:none;" value="');
                $investigationTr.push(0); $investigationTr.push('"'); $investigationTr.push('disabled="disabled"/></td>');
                $investigationTr.push('</td><td id="tdNetAmount" style="display:none"><input type="text" style="display:none;" class="ItDoseTextinputNum" id="txtNetAmt" value="');
                $investigationTr.push(0); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
            }

            if (investigationRateDetails.DeliveryDate.split('#')[1] == '01-Jan-0001 12:00 AM') {
                $investigationTr.push('<td id="tddeliverydate_show" style="text-align: center;"></td>');
            }
            else {
                $investigationTr.push('<td id="tddeliverydate_show" style="text-align: center;">');
                $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
                $investigationTr.push('</td>');
            }
            $investigationTr.push('<td id="tdDeliveryDateold" style="display:none;">');
            $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
            $investigationTr.push('</td><td id="tdDeliveryDate" style="display:none;">');
            $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
            $investigationTr.push('</td><td id="tdSRADate" style="display:none;">');
            $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[0]);
            $investigationTr.push('</td>');
            if (jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg == 1 && jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType == "System") {
                $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsSampleCollection'  autocomplete='off' type='checkbox'  ");
                if (investigationRateDetails.SampleDefined == "0")
                    $investigationTr.push(' disabled="disabled"  ');
                else
                    $investigationTr.push(' checked="checked" ');

                $investigationTr.push(" class='ItDoseTextinputNum'  style='padding:2px'  /></td>");
                jQuery(".clSampleCollection").show();
            }
            else
                jQuery(".clSampleCollection").hide();
            $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsUrgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px' onchange='GetUrgentTAT(this);'  /></td>");
            $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsSampleCollectedByPatient'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px'  /></td>");

            if (jQuery("#ddlPanel").val().split('#')[20] == "1") {
                $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPatient" value="');
                $investigationTr.push(investigationRateDetails.paybypatient); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
                $investigationTr.push('<td id="tdPayByPatient" style="display:none;">');
                $investigationTr.push(investigationRateDetails.paybypatient);
                $investigationTr.push('</td>');            
                if (investigationRateDetails.paybypanelper == "0" && jQuery("#ddlPanel").val().split('#')[21] == "1") {
                    $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPanel" onkeyup="setcopaymentamount(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                    $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                    $investigationTr.push('/></td>');
                    $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;" autocomplete="off" onlynumber="10" class="ItDoseTextinputNum" id="txtPayByPanelPer" maxlength="3" onkeyup="setcopaymentper(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                    $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                    $investigationTr.push('/></td>');
                }
                else {
                    $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPanel" value="');
                    $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                    $investigationTr.push('disabled="disabled"/></td>');
                    $investigationTr.push('<td id="tdPayByPanel" style="display:none;">');
                    $investigationTr.push(investigationRateDetails.paybypanel);
                    $investigationTr.push('</td>');
                    $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPanelPer" value="');
                    $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                    $investigationTr.push('disabled="disabled"/></td>');
                }
            }
            else {

                $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPatient" value="');
                $investigationTr.push(investigationRateDetails.paybypatient); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
                $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPanel" value="');
                $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
                $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtPayByPanelPer" value="');
                $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                $investigationTr.push('disabled="disabled"/></td>');
            }
            $investigationTr.push("<td class='inv' id='"); $investigationTr.push(investigationRateDetails.Investigation_Id); $investigationTr.push("'");
            $investigationTr.push('class="GridViewLabItemStyle"><img  class="btn" alt=""  src="../../App_Images/Delete.gif" onclick="$removeLabItems(this)"  /></td>');
            $investigationTr.push('<td id="tdIsPackage" style="display:none;">');
            $investigationTr.push(investigationRateDetails.ispackage);
            $investigationTr.push('</td><td id="tdIsReporting" style="display:none;">');
            $investigationTr.push(investigationRateDetails.reporting);
            $investigationTr.push('</td><td id="tdSubCategoryID" style="display:none;">');
            $investigationTr.push(investigationRateDetails.subcategoryid);
            $investigationTr.push('</td><td id="tdReportType" style="display:none;">');
            $investigationTr.push(investigationRateDetails.reporttype);
            $investigationTr.push('</td><td id="tdGenderInvestigate" style="display:none;">');
            $investigationTr.push(investigationRateDetails.GenderInvestigate); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdSample" style="display:none;">');
            $investigationTr.push(investigationRateDetails.Sample); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdRequiredAttachment" style="display:none;">');
            $investigationTr.push(investigationRateDetails.RequiredAttachment); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdRequiredAttachmentID" style="display:none;">');
            $investigationTr.push(investigationRateDetails.RequiredAttachmentID); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdRequiredAttchmentAt" style="display:none;">');
            $investigationTr.push(investigationRateDetails.AttchmentRequiredAt); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdRequiredFields" style="display:none;">');
            $investigationTr.push(investigationRateDetails.RequiredFields); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdIsLMPRequired" style="display:none;">');
            $investigationTr.push(investigationRateDetails.IsLMPRequired); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdLMPFormDay" style="display:none;">');
            $investigationTr.push(investigationRateDetails.LMPFormDay); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdLMPToDay" style="display:none;">');
            $investigationTr.push(investigationRateDetails.LMPToDay); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdoldAmount" style="display:none;">');
            $investigationTr.push(investigationRateDetails.Amount); $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdBaseRate" style="display:none;">');
            $investigationTr.push(investigationRateDetails.baserate); $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdDeptInterpretaion" style="display:none;">');
            $investigationTr.push(investigationRateDetails.deptinterpretaion);
            $investigationTr.push('</td><td id="tdIsScheduleRate" style="display:none;">');
            $investigationTr.push(ItemID.item.Rate.split('#')[1]);
            $investigationTr.push('</td><td id="tdItemID" style=";display:none;">');
            $investigationTr.push("<span id='spnItemID' style='display:none'>");
            $investigationTr.push(investigationRateDetails.ItemID);
            $investigationTr.push('</span></td><td id="tdPanelItemCode" style="display:none;">');
            $investigationTr.push(ItemID.item.Rate.split('#')[2]);
            $investigationTr.push("</td>");

            $investigationTr.push('<td id="tdEncryptedRate" style="display:none;">');
            $investigationTr.push(investigationRateDetails.EncryptedRate);
            $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdEncryptedAmount" style="display:none;">');
            $investigationTr.push(investigationRateDetails.EncryptedAmount);
            $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdEncryptedDiscAmt" style="display:none;">');
            $investigationTr.push(investigationRateDetails.EncryptedDiscAmt);
            $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdEncryptedItemID" style="display:none;">');
            $investigationTr.push(investigationRateDetails.EncryptedItemID);
            $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdEncryptedMRP" style="display:none;">');
            $investigationTr.push(investigationRateDetails.EncryptedMRP);
            $investigationTr.push('</td>');
            $investigationTr.push('<td id="tdDepartmentDisplayName" style="display:none;">');
            $investigationTr.push(investigationRateDetails.DepartmentDisplayName);
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdIsMemberShipFreeTest" style="display:none;">');
            $investigationTr.push(investigationRateDetails.IsFreeTest);
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdMemberShipDisc" style="display:none;">');
            $investigationTr.push(investigationRateDetails.MemberShipDisc);
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdMemberShipTableID" style="display:none;">');
            $investigationTr.push(investigationRateDetails.MemberShipTableID);
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdIsMemberShipDisc" style="display:none;">');
            $investigationTr.push(investigationRateDetails.IsMemberShipDisc);
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdIsSelfPatient" style="display:none;">');
            $investigationTr.push($('#spnIsSelfPatient').text());
            $investigationTr.push('</td>');

            $investigationTr.push('<td id="tdFreeTestQuantity" style="display:none;">');
            $investigationTr.push(investigationRateDetails.FreeTestQuantity); 
            $investigationTr.push('</td>');
            
            $investigationTr.push('<td id="tdSubCategoryName" style="display:none;">');
            $investigationTr.push(investigationRateDetails.SubcategoryName);
            $investigationTr.push('</td>');

            $investigationTr.push("</tr>");
            $investigationTr = $investigationTr.join("");
            jQuery("#tb_ItemList tbody").prepend($investigationTr);
            //jQuery("#tb_ItemList tr:first").after($investigationTr);

            $TestCount = parseInt($TestCount) + 1;
            jQuery('#lblTestCount').text('Test Count:' + $TestCount);
            jQuery("#tb_ItemList").tableHeadFixer({
            });
            if (jQuery("#ddlPanel").val().split('#')[4] == "0") {
                jQuery(".isHideRate,#divPaymentControl").show();
            }
            else {
                jQuery(".isHideRate,#divPaymentControl").hide();
            }
            if (jQuery("#ddlPanel").val().split('#')[20] == "1") {

                jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").show();
            }
            else {

                jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").hide();
            }


            if (jQuery("#ddlPanel").val().split('#')[4] == "0")
                $bindSuggestionPackage();
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            callback(true);
        }
        var $clearPaymentControl = function (callback) {
            var $sampleCollectionCharge = $calculateSampleCollectionCharge();
            var $reportDeliveryCharge = $calculateReportDeliveryCharge();
            if ($sampleCollectionCharge > 0 || $reportDeliveryCharge > 0)
                jQuery('#txtGrossAmount,#txtNetAmount,#txtBlanceAmount').val(Number($sampleCollectionCharge) + Number($reportDeliveryCharge));
            else
                jQuery('#txtGrossAmount,#txtNetAmount,#txtBlanceAmount').val('0');
            jQuery('#txtDiscountAmount,#txtDiscountPerCent,#txtPaidAmount').val('0');
            jQuery('#txtDiscountReason').val('');
            jQuery('#spnTotalDiscountAmount').text('0');
            jQuery('#ddlApprovedBy').prop('selectedIndex', 0);
            jQuery('#ddlApprovedBy,#txtDiscountReason').removeClass('requiredField');
            $('#txtpaybypanelfinal').val('0');
            $('#txtpaybypatientfinal').val('0');
            callback(true);
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
                  
                    $showDue();
                    
                    
               if(jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=4]').length == 0)
                 {
                   jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                    var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + jQuery("#ddlCurrency").val());
                    jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                        jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                    });

                   }
                    if (con == "remove") {
                        if (jQuery('#tb_ItemList').find('tr:not(#LabHeader)').length == 0) {
                            jQuery('#tblPaymentDetail tr').slice(1).remove();
                            $getPaymentMode("1", function () { });
                            jQuery('#txtCurrencyRound').val('0');
                        }
                    }
                    callback(true);
                })
            }));

        };
        function $showDue() {
            if (jQuery('#txtGrossAmount').val() == "") {
                toast("Error", "Please Select Test", "");
                jQuery('#txtPaidAmount').val('');
                jQuery('#txtOutstandingAmt').val('0');
                return;
            }
            if (jQuery('#txtPaidAmount').val() == "") {
                var $netAmount = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));

                jQuery('#txtBlanceAmount').val($netAmount);
                return;
            }
            var $total = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
            var $paid = jQuery('#txtPaidAmount').val();
            if (parseFloat($paid) > parseFloat($total)) {
                toast("Error", "Paid Amount can't Greater then Total Amount", "");
                jQuery('#txtPaidAmount').val($total);
                jQuery('#txtBlanceAmount,#txtOutstandingAmt').val('0');
                return;
            }
            var $due = parseInt($total) - parseInt($paid);
            jQuery('#txtBlanceAmount').val($due);
        }
        $updatePaymentAmount = function (callback) {
            var $totalBillAmount = 0;
            var $totalDiscountAmount = 0;
            $tbSelected = jQuery('#tb_ItemList');
            var $totalpaybypanel = 0;
            var $totalpaybypatient = 0;

            var $disc = 0; var $packagecount = 0;
            var $labItemsAmountDetails = $tbSelected.find('tr:not(#LabHeader)').each(function () {
                $qty = Number(1);
                //  $rate = Number(jQuery(this).closest('tr').find('#tdRate').text()); 
                $rate = Number(jQuery(this).closest('tr').find('#txtNetAmt').val());//sunil change for add qnty
                $totalBillAmount = Number($totalBillAmount) + Number($rate);
                $discountAmount = Number(jQuery(this).closest('tr').find('#txtItemWiseDiscount').val());
                $totalDiscountAmount = Number($totalDiscountAmount) + Number($discountAmount);


                $totalpaybypanel = Number($totalpaybypanel) + Number(jQuery(this).closest('tr').find('#txtPayByPanel').val());
                $totalpaybypatient = Number($totalpaybypatient) + Number(jQuery(this).closest('tr').find('#txtPayByPatient').val());


                if (jQuery(this).find('#tdIsPackage').text() == "1") {
                    $packagecount = 1;
                }
                //if ($packagecount == "1") {
                //    if (jQuery('#ddlApprovedBy').val() == "0") {
                //        jQuery('#txtDiscountAmount,#txtDiscountPerCent').attr('disabled', true);
                //    }
                //    else if (jQuery('#ddlApprovedBy').val().split('#')[3] == "0") {
                //        jQuery('#txtDiscountAmount,#txtDiscountPerCent').attr('disabled', true);
                //    }
                //    else if (jQuery('#ddlApprovedBy').val().split('#')[3] == "1") {
                //        jQuery('#txtDiscountAmount,#txtDiscountPerCent').attr('disabled', false);
                //    }
                //}
                //else {
                //    jQuery('#txtDiscountAmount,#txtDiscountPerCent').attr('disabled', false);
                //}
                if (Number(jQuery(this).find("#txtItemWiseDiscount").val()) > 0)
                { $itemwisedic = 1; }

                $disc = $disc + Number(jQuery(this).find("#txtItemWiseDiscount").val());
                jQuery('#spnTotalDiscountAmount').text($disc);
                if ($disc == "0") {
                    jQuery('#txtDiscountAmount,#txtDiscountPerCent').val('0');
                }
                //if (jQuery(this).find('#tdSubCategoryID').text() == "18") {
                //    jQuery(this).find('#txtItemWiseDiscount').attr('disabled', true);
                //}
            });
            $('#txtpaybypanelfinal').val($totalpaybypanel);
            $('#txtpaybypatientfinal').val($totalpaybypatient);
            $totalBillAmount = Number($totalBillAmount);
            if ($labItemsAmountDetails.length > 0) {
                $addBillAmount({
                    billAmount: $totalBillAmount,
                    disCountAmount: $totalDiscountAmount

                }, function () { });
                jQuery($tbSelected).show();


            }
            else {
                jQuery($tbSelected).hide();
                $clearPaymentControl(function () { });
            }
            jQuery('#lblTotalLabItemsCount').text("".concat($labItemsAmountDetails.length));

        };
        $getItemRate = function (ItemID, callback) {
            $ItemID = ItemID.item.value;
            $type = ItemID.item.type;
            $Rate = ItemID.item.Rate.split('#')[0];
            $DiscPer = ItemID.item.DiscPer;
            $MRP = ItemID.item.MRP.split('#')[0];
            $iscopayment = jQuery("#ddlPanel").val().split('#')[20];
            $panelid = jQuery("#ddlPanel").val().split('#')[0];
            var $MembershipCardNo = $('#spnMembershipCardNo').text();
            if (jQuery("#ddlPanel").val().split('#')[2] == "Credit")
                $MembershipCardNo = "";
            serverCall('../Lab/Services/LabBooking.asmx/GetitemRate', { ItemID: $ItemID, type: $type, Rate: $Rate, addedtest: '', centreID: jQuery('#ddlCentre option:selected').val().split('#')[0], DiscPer: $DiscPer, DeliveryDate: "", MRP: $MRP, IsCopayment: $iscopayment, panelid: $panelid, MembershipCardNo: $MembershipCardNo, IsSelfPatient: $('#spnIsSelfPatient').text(), UHIDNo: $("#spnUHIDNo").text() }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var $responseData = JSON.parse(response);
                    callback($responseData[0]);
                }
                else
                    callback();
            });
        }
        var $addBillAmount = function (data, callback) {
            jQuery('#spnControlPatientAdvanceAmount').text(Number(jQuery('#txtUHIDNo').attr('patientAdvanceAmount')));
            var $sampleCollectionCharge = $calculateSampleCollectionCharge();
            var $reportDeliveryCharge = $calculateReportDeliveryCharge();
            jQuery('#txtGrossAmount').val(parseFloat(data.billAmount) + parseFloat($sampleCollectionCharge) + parseFloat($reportDeliveryCharge));
              jQuery('#txtNetAmount').val(parseFloat(data.billAmount - data.disCountAmount) + parseFloat($sampleCollectionCharge) + parseFloat($reportDeliveryCharge));
          //      jQuery('#txtNetAmount').val(parseFloat(data.billAmount) + parseFloat($sampleCollectionCharge) + parseFloat($reportDeliveryCharge));//sunil change for add qnty

         //   jQuery('#txtPatientPaidAmount').val(parseFloat(data.billAmount) + parseFloat($sampleCollectionCharge) + parseFloat($reportDeliveryCharge));
           // jQuery('#txtPaidAmount').val(parseFloat(data.billAmount) + parseFloat($sampleCollectionCharge) + parseFloat($reportDeliveryCharge));
            jQuery('#spnTotalDiscountAmount').text(data.disCountAmount);
            var $paidAmount = jQuery('#txtPaidAmount').val();
            if (isNaN($paidAmount) || $paidAmount == "")
                $paidAmount = 0

            var $netamount = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));

            jQuery('#txtBlanceAmount').val($netamount - $paidAmount - Number(jQuery('#txtAppAmount').val()));
            if (jQuery('#txtBlanceAmount').val() < 0) {
                jQuery('#txtPaidAmount').val($netamount);
                jQuery('#txtBlanceAmount').val('0');
            }
        };
        $getPaymentMode = function (con, callback) {

            if (jQuery("#ddlPanel option").length > 0) {
                if (jQuery("#ddlPanel").val().split('#')[2] == "Cash" || jQuery("#ddlPanel").val().split('#')[20] == "1") {
                    if (con == 0) {
                        jQuery('#tblPaymentDetail tr').slice(1).remove();
                        $bindPaymentMode(function (response) {
                            paymentModes = jQuery.extend(true, [], response);
                            if (paymentModes.length > 0) {
                                paymentModes.patientAdvanceAmount = Number(jQuery('#txtUHIDNo').attr('patientAdvanceAmount'));
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
                    jQuery("#divPaymentDetails,#divDiscountBy,#divDiscountReason,.isReciptsBool,.clCashTender,.isReciptsBool1,.clPaidAmt").show();
                    if (jQuery("#ddlPanel").val().split('#')[20] == "1") {
                        jQuery(".divOutstanding").hide();
                    }
                    else {
                        jQuery(".divOutstanding").show();
                    }
                    jQuery(".isReciptsBool").css("height", 84);
                    jQuery("#txtAmountGiven").val('');
                    jQuery("#tblPaymentDetail").tableHeadFixer({
                    });
                }
                else {
                    jQuery("#divPaymentMode").empty();
                    jQuery("#divPaymentMode").append("<input id='chkPaymentMode4' name='paymentMode' type='checkbox' value='4' checked='checked' disabled='disabled'/><b>Credit</b>");
                    jQuery("#divPaymentDetails,#divDiscountBy,#divDiscountReason,.clCashTender,.divOutstanding,.clPaidAmt").hide();
                    jQuery("#chkCashOutstanding").prop('checked', false);

                    jQuery("#txtOutstandingAmt").val('');
                    jQuery("ddlOutstandingEmployee").prop('selectedIndex', 0);
                    jQuery(".isReciptsBool").css("height", 30);
                }
                if (jQuery("#ddlPanel").val().split('#')[4] == "1") {
                    jQuery("#divPaymentMode,.isHideRate").hide();
                }
                else {
                    jQuery("#divPaymentMode,.isHideRate").show();
                }

                if (jQuery("#ddlPanel").val().split('#')[20] == "1") {
                    jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").show();
                    jQuery("#divDiscountBy,#divDiscountReason,.divOutstanding.clCashOutstanding").hide();
                    jQuery("#chkCashOutstanding").prop('checked', false);
                    jQuery('#ddlOutstandingEmployee').prop('selectedIndex', 0);
                    jQuery('#txtOutstandingAmt').val('');
                }
                else {
                    jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").hide();
                }
            }
        };
        var $paymentModeCache = [];
        var $bindPaymentMode = function (callback) {
            var $IsCache = $paymentModeCache.filter(function (i) { if (i.PanelID == jQuery("#ddlPanel").val().split('#')[0]) { return i } });
            if ($IsCache.length > 0)
                callback($paymentModeCache);
            else {
                serverCall('../Common/Services/CommonServices.asmx/bindPaymentMode', {}, function (response) {
                    $paymentModeCache = JSON.parse(response);
                    callback($paymentModeCache);
                }, '', 0);
            }
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

            $temp.push('<td id="tdtransactionid" class="GridViewLabItemStyle"  style="text-align:right">');
            $temp.push('<input type="text" id="transactionid" /></td>');

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
               if(jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=4]').length == 0)
                 {
                    jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                    var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + jQuery('#ddlCurrency').val());
                    jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                        jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                    });
                  }
                    callback(true);
                })
            }));
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
					<input type="checkbox" data-IsBankShow='<#=objRow.IsBankShow#>' data-IsChequeNoShow='<#=objRow.IsChequeNoShow#>' data-IsChequeDateShow='<#=objRow.IsChequeDateShow#>' data-IsOnlineBankShow='<#=objRow.IsOnlineBankShow#>' name="paymentMode" onchange="$onPaymentModeChange(this,jQuery('#ddlCurrency'),function(){});"  value='<#=objRow.PaymentModeID#>'  />
                        <b  <#=(patientAdvancePaymentModeID.indexOf(objRow.PaymentModeID)>-1?"class='patientInfo'":'' ) #> > <#= objRow.PaymentMode  #> </b>
					
					</div>
			<#}#>       
</script>
    <script  type="text/javascript">
        $removeZero = function (ctrl) {
            if (jQuery(ctrl).val() == 0) {
                jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
            }
        }

        $setItemwiseDiscount = function (ctrl) {
            if (jQuery(ctrl).val().indexOf(".") != -1) {
                jQuery(ctrl).val(jQuery(ctrl).val().replace('.', ''));
            }
            var nbr = jQuery(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
            }
            if (jQuery(ctrl).val().length > 1) {
                if (isNaN(jQuery(ctrl).val() / 1) == true) {
                    jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
                }
            }
            if (isNaN(jQuery(ctrl).val() / 1) == true) {
                jQuery(ctrl).val('');
                return;
            }
            else if (jQuery(ctrl).val() < 0) {
                jQuery(ctrl).val('');
                return;
            }
            if (jQuery('#txtDiscountPerCent').val().length > 0 && jQuery('#txtDiscountPerCent').val() != 0) {
                toast("Error", "Discount Per already Given", "");
                $confirmationBox('Discount Per already Given <br> <b>Do you want to remove?', 1);
                jQuery(ctrl).val('0');
                return;
            }
            if (jQuery('#txtDiscountAmount').val().length > 0 && jQuery('#txtDiscountAmount').val() != 0) {
                toast("Info", "Discount Amount already Given", "");
                $confirmationBox('Discount Amount already Given <br> <b>Do you want to remove?', 1);
                jQuery(ctrl).val('0');
                return;
            }
            if (jQuery(ctrl).val() == "") {
                jQuery(ctrl).val('0');
            }
            var $disc = parseFloat(jQuery(ctrl).val());
            var $rate = jQuery(ctrl).closest("tr").find("#tdRate").text();
            var $qnty = jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val();//sunil change for qnty
            if (parseFloat($disc) > parseFloat($rate)) {
                jQuery(ctrl).val($rate);
                $disc = $rate;
            }
            if ($disc == 0)
                $itemwisedic = 0;
            jQuery(ctrl).closest("tr").find("#txtNetAmt").val((parseFloat($rate * $qnty) - parseFloat($disc)));

            $updatePaymentAmount();
            jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            $getPaymentMode("1", function () { });
            jQuery('#txtCurrencyRound,#txtPaidAmount').val('0');
            var $netAmount = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
            jQuery('#txtBlanceAmount').val($netAmount);
            $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
            $addRequiredClass();
        }
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
        var $calculateTotalPaymentAmount = function (event, row, callback) {
            var $totalPaidAmount = 0;
            jQuery('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
            var $netAmount = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
            var $roundOffTotalPaidAmount = Math.round($totalPaidAmount) + Number($('#txtAppAmount').val());
            if ($roundOffTotalPaidAmount > $netAmount) {
                if (event != null) {
                    var row = jQuery(event.target).closest('tr');
                    var $targetBaseCurrencyAmountTd = row.find('#tdBaseCurrencyAmount');
                    var $tragetBaseCurrencyAmount = jQuery.trim($targetBaseCurrencyAmountTd.text());
                    jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount - $tragetBaseCurrencyAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                    jQuery('#txtBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount - $tragetBaseCurrencyAmount) - Number($('#txtAppAmount').val())), '<%=Resources.Resource.BaseCurrencyRound%>'));
                    $targetBaseCurrencyAmountTd.text(0);
                    row.find('#txtPatientPaidAmount').val(0);
                }
            }
            else {
                jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                jQuery('#txtBlanceAmount').val(precise_round(parseFloat(($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()))) - parseFloat(jQuery('#txtPaidAmount').val()) - Number($('#txtAppAmount').val()), '<%=Resources.Resource.BaseCurrencyRound%>'));
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
    </script>
    <script type="text/javascript">
        var Doctor_ID_Temp = 0; var TempSecondRef = 0;

    </script>
   <script type="text/javascript">
       function checkRequiredField() {
           var field = [];
           var requiredFiled = [];
           jQuery('#tb_ItemList tr').each(function () {
               var id = jQuery(this).closest("tr").attr("id");
               if (id != "LabHeader") {
                   if (jQuery.trim(jQuery(this).closest("tr").find("#tdRequiredFields").text()) != "") {
                       field.push(jQuery(this).closest("tr").find("#tdRequiredFields").text());
                   }
               }
           }
           );
           if (field.length > 0) {
               for (var i = 0; i < field.length ; i++) {
                   requiredFiled.push(field[i]);
               }
               var uniqueNames = [];
               jQuery.each(requiredFiled, function (i, el) {
                   if (jQuery.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
               });
               return uniqueNames.join(',');
           }
           else {
               return "";
           }
       }
   </script>
    <script type="text/javascript">
        function $showAlert() {
            var $msg = "";
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader" && jQuery.trim(jQuery(this).closest("tr").find("#tdDeptInterpretaion").text()) != "") {
                    $msg = jQuery.trim(jQuery(this).closest("tr").find("#tdDeptInterpretaion").text());
                }
            });
            if ($msg != "") {
                alert($msg);
            }
        }
        function $requiredFiled() {
            var $dataRequired = new Array();
            jQuery('#tblRequiredField tr').each(function () {
                var $objRequ = new Object();
                $objRequ.FieldID = jQuery(this).attr("id");
                $objRequ.FieldName = jQuery(this).find('#tdRequiredFiledName').text();
                if (jQuery(this).find('#tdRequiredInputType').text() == "CheckBox") {
                    if (jQuery(this).find('#tdRequiredInput').find('.clRequiredInput').is(':checked')) {
                        $objRequ.FieldValue = "1";
                    }
                    else {
                        $objRequ.FieldValue = "0";
                    }
                }
                else {
                    $objRequ.FieldValue = jQuery(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                }

                if (jQuery(this).find('#tdRequiredUnit').text() != "") {
                    $objRequ.Unit = jQuery(this).find('#tdRequiredInput').find('.unit').val();
                }
                else {
                    $objRequ.Unit = "";
                }
                $objRequ.LedgerTransactionID = 0;
                $objRequ.LedgerTransactionNo = "";
                $dataRequired.push($objRequ);
            });
            return $dataRequired;
        }
        var $chkPrePrintedBarCode = function () {
            var $BarcodePrintingType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType;
            if ($BarcodePrintingType == "PrePrinted" && (((jQuery("#ddlPanel option:selected").data("value").BarCodePrintedCentreType == 1 && jQuery("#ddlVisitType").val() == "Center Visit")) || (jQuery("#ddlPanel option:selected").data("value").BarCodePrintedHomeColectionType == 1 && jQuery("#ddlVisitType").val() == "Home Collection")) && jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg == "1") {
                var InvestigationID = [];
                jQuery('#tb_ItemList tr').each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "LabHeader") {
                        InvestigationID.push(jQuery.trim(jQuery(this).closest("tr").find(".inv").attr("id")));
                    }
                });
                if (jQuery("#ddlPanel option:selected").data("value").setOfBarCode == "SampleType") {
                    jQuery("#txtAllBarCode").hide();
                }
                else {
                    jQuery("#txtAllBarCode").show();
                }
                $bindSampleType(InvestigationID.join(','), btnSave, buttonVal, 0);
                return;
            }
            else {
                $saveLabPrescriptionData(function (btnSave, buttonVal) { });
            }
        }
        var $saveLabPrescription = function (btnSave, buttonVal) {
            if ($validation() == false) {
                return;
            }
            jQuery(btnSave).attr('disabled', true).val('Submitting...');
            $modelBlockUI();
            var requiredFiled = checkRequiredField();
            if (requiredFiled.length > 0) {
                jQuery('#tblRequiredField tr').remove();
                var _temp = [];
                _temp.push(serverCall('Lab_PrescriptionOPD.aspx/bindAllRequiredField', { item: requiredFiled }, function (response) {
                    jQuery.when.apply(null, _temp).done(function () {
                        var $ReqData = JSON.parse(response);
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push("<tr id='"); $mydata.push($ReqData[i].id); $mydata.push("'");
                            $mydata.push('style="background-color:lightgoldenrodyellow;" class="my'); $mydata.push(i); $mydata.push('">');
                            $mydata.push('<td align="left" id="tdRequiredFiledName" style="font-weight:bold;" class="GridViewLabItemStyle" >');
                            $mydata.push($ReqData[i].FieldName);
                            $mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdRequiredInput" class="GridViewLabItemStyle" >');
                            if ($ReqData[i].InputType == "TextBox") {
                                $mydata.push('<input type="text" class="clRequiredInput requiredField" style="width:20%;"/>');
                            }
                            else if ($ReqData[i].InputType == "DropDownList") {
                                $mydata.push('<select style="width:20%;" class="clRequiredInput requiredField">');
                                for (var a = 0; a <= $ReqData[i].DropDownOption.split('|').length - 1; a++) {
                                    $mydata.push('<option>');
                                    $mydata.push($ReqData[i].DropDownOption.split('|')[a]);
                                    $mydata.push('</option>');
                                }
                                $mydata.push('</select>');
                            }
                            else if ($ReqData[i].InputType == "CheckBox") {
                                $mydata.push('<input type="checkbox"  class="clRequiredInput"/>');
                            }
                            else if ($ReqData[i].InputType == "Date") {
                                if ($ReqData[i].FieldName == "SAMPLE COLLECTION") {
                                    $mydata.push('<input type="text" id="txtappdate');
                                    $mydata.push($ReqData[i].id); $mydata.push('"');
                                    $mydata.push(' class="clRequiredInput" style="width:140px;" value="' + setd() + '" />');
                                }
                                else {
                                    $mydata.push('<input type="text" id="txtappdate');
                                    $mydata.push($ReqData[i].id); $mydata.push('"');
                                    $mydata.push(' class="clRequiredInput" style="width:140px;" />');
                                }
                            }


                            if ($ReqData[i].Unit != "") {
                                $mydata.push('<select style="width:20%;"  class="unit">');
                                for (var a = 0; a <= $ReqData[i].Unit.split('|').length - 1; a++) {
                                    $mydata.push('<option>');
                                    $mydata.push($ReqData[i].Unit.split('|')[a]);
                                    $mydata.push('</option>');
                                }
                                $mydata.push('</select>');
                            }
                            $mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdRequiredUnit" class="GridViewLabItemStyle" style="display:none;"  >');
                            $mydata.push($ReqData[i].Unit);
                            $mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdRequiredInputType" class="GridViewLabItemStyle" style="display:none;"  >');
                            $mydata.push($ReqData[i].InputType);
                            $mydata.push('</td>');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery('#tblRequiredField').append($mydata);
                            jQuery("#txtappdate" + $ReqData[i].id).datepicker({
                                dateFormat: "dd-M-yy"
                            });
                            jQuery('#ui-datepicker-div').css('z-index', '999999');
                        }
                        jQuery('#divRequiredField').showModel();
                        jQuery('.my0').find('#tdRequiredInput').find('.clRequiredInput').focus();
                    });
                    $modelUnBlockUI();
                    jQuery(btnSave).attr('disabled', false).val('Save');
                    return;
                }));
            }
            else {
                var $BarcodePrintingType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType;
                if ($BarcodePrintingType == "PrePrinted" && (((jQuery("#ddlPanel option:selected").data("value").BarCodePrintedCentreType == 1 && jQuery("#ddlVisitType").val() == "Center Visit")) || (jQuery("#ddlPanel option:selected").data("value").BarCodePrintedHomeColectionType == 1 && jQuery("#ddlVisitType").val() == "Home Collection")) && jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg == "1") {
                    var $InvestigationID = [];
                    //if (jQuery('#ddlPatientType').val() == "1") {
                    //    jQuery('#btnSkipSave').show();
                    //} else {
                    //    jQuery('#btnSkipSave').hide();
                    //}
                    jQuery('#tb_ItemList tr').each(function () {
                        var id = jQuery(this).closest("tr").attr("id");
                        if (id != "LabHeader") {
                            $InvestigationID.push(jQuery.trim(jQuery(this).closest("tr").find(".inv").attr("id")));
                        }
                    });
                    if (jQuery("#ddlPanel option:selected").data("value").setOfBarCode == "SampleType") {
                        jQuery("#txtAllBarCode").hide();
                    }
                    else {
                        jQuery("#txtAllBarCode").show();
                    }
                    $bindSampleType($InvestigationID.join(','), btnSave, buttonVal, 0);
                    $modelUnBlockUI(function () { });
                    return;
                }
                else {
                    $saveLabPrescriptionData(function (btnSave, buttonVal) { });
                }
            }
        };
        var $saveLabData = function (btnSave, buttonVal) {
            var $BarcodePrintingType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType;
            var $sampleData = [];
            if ($BarcodePrintingType == "PrePrinted" && (((jQuery("#ddlPanel option:selected").data("value").BarCodePrintedCentreType == 1 && jQuery("#ddlVisitType").val() == "Center Visit")) || (jQuery("#ddlPanel option:selected").data("value").BarCodePrintedHomeColectionType == 1 && jQuery("#ddlVisitType").val() == "Home Collection")) && jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg == "1") {
                var $validate = 0;
                if (jQuery(btnSave).attr("id") == "btnFinalSave") {
                    jQuery('#tb_SampleList tr').each(function () {
                        var id = jQuery(this).closest("tr").attr("id");
                        if (id != "trSampleHeader") {
                            if (jQuery.trim(jQuery(this).find('#txtBarCodeNo').val()) == "") {
                                $validate = 1;
                                jQuery(this).find('#txtBarCodeNo').focus();
                                $modelUnBlockUI(function () { });
                                jQuery("#btnSkipSave").val('Skip & Save');
                                return;
                            }
                        }
                    });
                    if ($validate == 1) {
                        $modelUnBlockUI(function () { });
                        toast("Error", "Please Enter Barcode No.", "");
                        jQuery("#btnSkipSave").val('Skip & Save');
                        return;
                    }
                    $validate = 0;
                    jQuery('#tb_SampleList tr').each(function () {
                        var id = jQuery(this).closest("tr").attr("id");
                        if (id != "trSampleHeader" && jQuery(this).find('#tdReportType').html() == "7") {
                            var SpecimenType = jQuery(this).find('#txtSpecimenType').val();
                            if (SpecimenType == "") {
                                $validate = 1;
                                $modelUnBlockUI(function () { });
                                jQuery(this).find('#txtBarCodeNo').focus();
                                jQuery("#btnSkipSave").val('Skip & Save');
                                return;
                            }
                        }
                    });
                    if ($validate == 1) {
                        $modelUnBlockUI(function () { });
                        toast("Error", "Please Enter Specimen Type", "");
                        jQuery("#btnSkipSave").val('Skip & Save');
                        return;
                    }
                }
                $sampleData = $getSampleData();
            }
            var $patientdata = $patientMaster();
            var $ledgertransaction = $f_ledgertransaction();
            var $PLOdata = $patientLabInvestigationOPD();
            if ($PLOdata == "") {
                $modelUnBlockUI(function () { });
                return;
            }
            var $Rcdata = $f_Receipt();
            var $RequiredField = $requiredFiled();
            var $sampleDateGiven = "0";
            $getUpdatedPatientDocuments(function ($patientDocuments) {
                $patientDocuments: $patientDocuments;
            });
            var $patientDocuments = [];
            jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                if (jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                    var $document = {
                        documentId: this.innerHTML.trim(),
                        name: jQuery(this.parentNode).find('#btnDocumentName').val(),
                        data: jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                    }
                    $patientDocuments.push($document);
                }
            });
            $showAlert();
            jQuery(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Lab_PrescriptionOPD.aspx/SaveNewRegistration', { PatientData: $patientdata, LTData: $ledgertransaction, PLO: $PLOdata, Rcdata: $Rcdata, RequiredField: $RequiredField, sampledata: $sampleData, sampledategiven: $sampleDateGiven, isVipM: 0, patientScanDocument: $patientDocuments }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.status) {
                    jQuery(btnSave).removeAttr('disabled').val('Save');
                    $clearForm();
                    toast("Success", "Record Saved Successfully", "");
                   // getBarcodeDetail('', $responseData.No);
                    //if (jQuery('#ddlPatientType').val() != "9" && jQuery('#ddlPatientType').val() != "10") {
                    //    PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
                        // window.open("".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>', "?LabID=", $responseData.ID));
                   // }
                   if (jQuery('#ddlPanel').val().split('#')[22] != "")
                    {
                        var _ReceiptType = jQuery('#ddlPanel').val().split('#')[22].split(',');
                       //if ($responseData.MRPBill != 0) {
                       //     PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>?MRPBill=', $responseData.MRPBill));
                       // }
                        for (var i = 0; i < _ReceiptType.length; i++) {

                            if ( jQuery('#ddlPatientType').val() != "10" && _ReceiptType[i] == "2")  //jQuery('#ddlPatientType').val() != "9" &&
                            {
                                //PostQueryString($responseData, "".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>'));
								 window.open('<%= Resources.Resource.PatientReceiptURL%>?LabID=' + $responseData.LabID);
                                    // window.open("".concat('../Lab/', '<%= Resources.Resource.PatientReceiptURL%>', "?LabID=", $responseData.ID));
                            }

                            if (_ReceiptType[i] == "1") {
                                window.open('TRF.aspx?ID=' + $responseData.LabID);
                            }
                            if (_ReceiptType[i] == "3") {
                                window.open('Departmentslip.aspx?ID=' + $responseData.LabID);
                            }
                        }
						 if ('<%=Resources.Resource.ConcentFormApplicable%>' == "1" && '<%=Resources.Resource.ConcentFormOpen%>' == "1")
                           $openConcentForm($responseData.LabID, function () { });
                    }

                    $modelUnBlockUI(function () { });
                }
                else {

                    toast("Error", $responseData.response, "");
                    jQuery(btnSave).removeAttr('disabled').val(buttonVal);
                    $modelUnBlockUI(function () { });
                }
                jQuery("#btnSkipSave").removeAttr('disabled').val('Skip & Save');
                jQuery("#btnSave,#btnFinalSave").removeAttr('disabled').val('Save');
            });
        }
        var $saveLabPrescriptionData = function (btnSave, buttonVal) {
            var $BarcodePrintingType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType;
            if ($BarcodePrintingType == "PrePrinted" && (((jQuery("#ddlPanel option:selected").data("value").BarCodePrintedCentreType == 1 && jQuery("#ddlVisitType").val() == "Center Visit")) || (jQuery("#ddlPanel option:selected").data("value").BarCodePrintedHomeColectionType == 1 && jQuery("#ddlVisitType").val() == "Home Collection")) && jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg == "1") {
                var InvestigationID = [];
                //if (jQuery('#ddlPatientType').val() == "1") {
                //    jQuery('#btnSkipSave').show();
                //} else {
                //    jQuery('#btnSkipSave').hide();
                //}
                jQuery('#tb_ItemList tr').each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "LabHeader") {
                        InvestigationID.push(jQuery.trim(jQuery(this).closest("tr").find(".inv").attr("id")));
                    }
                });
                $bindSampleType(InvestigationID.join(','), btnSave, buttonVal, 1);
                return;
            }
            else {
                $saveLabData(function (btnSave, buttonVal) { });
            }
        }
        function $saveRequiredField(btnSave, buttonVal) {
            if ($validation() == false) {
                return;
            }
            var $sn = 0;
            var $fieldName = "";
            var $SCAN_DATE = "";
            var $samplecollectiondate = "";
            var $GESTATIONAL_WEEK = "";
            var $GESTATIONAL_DAYS = "";
            jQuery('#tblRequiredField tr').each(function () {
                if (jQuery(this).find('#tdRequiredInput').find('.clRequiredInput').val() == "") {
                    $sn = 1;
                    $fieldName = jQuery(this).find('#tdRequiredFiledName').text();
                    jQuery(this).find('#tdRequiredInput').find('.clRequiredInput').focus();
                    return false;
                }
                if ($(this).find('#tdRequiredFiledName').text() == "GESTATIONAL WEEK") {
                    $GESTATIONAL_WEEK = $(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                    if (isNaN($GESTATIONAL_WEEK)) {
                        $sn = 2;
                    }
                }
                if ($(this).find('#tdRequiredFiledName').text() == "GESTATIONAL DAYS") {
                    $GESTATIONAL_DAYS = $(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                    if (isNaN($GESTATIONAL_DAYS)) {
                        $sn = 3;
                    }
                }
                if (jQuery(this).find('#tdRequiredFiledName').text() == "SCAN DATE") {
                    $SCAN_DATE = $(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                }
                if ($(this).find('#tdRequiredFiledName').text() == "SAMPLE COLLECTION") {
                    $samplecollectiondate = $(this).find('#tdRequiredInput').find('.clRequiredInput').val();
                }
            });
            if ($sn == 1) {
                toast("Error", "".concat("Please Enter ", $fieldName), "");
                return false;
            }
            if ($sn == 2) {
                toast("Error", "Please Enter Numeric Value of GESTATIONAL WEEK..", "");
                return false;
            }
            if ($sn == 3) {
                toast("Error", "Please Enter Numeric Value of GESTATIONAL DAYS..", "");
                return false;
            }
            if (new Date($SCAN_DATE) > new Date($samplecollectiondate)) {
                toast("Error", "Scan Date always smaller then Sample Collection Date ..", "");
                return false;
            }
            //lmp sunil       

            var $IsLmpRequired = "";
            var $Lmpfromday = "";
            var $Lmptoday = "";
            var $testdName = "";
            var $samplecollection = new Date($samplecollectiondate);
            var $SCAN = new Date($SCAN_DATE);


         
            var $diff = new Date($samplecollection - $SCAN);
            var $days = $diff / 1000 / 60 / 60 / 24;

            var $totaldays = (7 * $GESTATIONAL_WEEK) + parseInt($GESTATIONAL_DAYS) + Math.round($days);
            var $msg = "";
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    if (jQuery.trim(jQuery(this).closest("tr").find("#tdIsLMPRequired").html()) == "1") {
                        $IsLmpRequired = jQuery.trim(jQuery(this).closest("tr").find("#tdIsLMPRequired").html());
                        $Lmpfromday = jQuery.trim(jQuery(this).closest("tr").find("#tdLMPFormDay").html());
                        $Lmptoday = jQuery.trim(jQuery(this).closest("tr").find("#tdLMPToDay").html());
                        $testdName = jQuery.trim(jQuery(this).closest("tr").find("#tdItemName").text());

                        if ($IsLmpRequired == 1) {
                            if ($totaldays < $Lmpfromday) {
                                $msg = "".concat("Calculated GA is ", getWeeksDay($totaldays), $testdName, " not possible, kindly come after ", LeftFrom_10Week($totaldays), " week.");
                                return false;
                            }
                            if ($totaldays > $Lmptoday) {
                                $msg = "".concat("Calculated GA is ", getWeeksDay($totaldays), $testdName, " not possible.");
                                return false;
                            }
                        }
                    }
                }
            }
          );
            if ($msg != "") {
                toast("Error", $msg, "");
                return false;
            }

            jQuery("#btnSaveRequired").attr('disabled', true).val("Submiting...");
            $closeRequiredFieldsModel();
            $saveLabPrescriptionData(function (btnSave, buttonVal) { });
            jQuery('#btnSaveRequired').attr('disabled', false).val("Save");
        }
        $getSampleData = function () {
            var $dataSample = new Array();
            jQuery('#tb_SampleList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "trSampleHeader") {
                    var $objSample = new Object();
                    $objSample.InvestigationID = jQuery(this).closest("tr").attr("id");
                    $objSample.InvestigationName = jQuery(this).closest("tr").find("#tdInvName").text();
                    if (jQuery(this).closest("tr").find("#tdReportType").text() == "7") {
                        $objSample.SampleTypeID = "1";
                        $objSample.SampleTypeName = jQuery(this).closest("tr").find("#txtSpecimenType").val();
                    }
                    else {
                        if (jQuery(this).closest("tr").find("#stype").html() == "1") {
                            $objSample.SampleTypeID = jQuery(this).closest("tr").find("#spnSampleTypeID").html();
                            $objSample.SampleTypeName = jQuery(this).closest("tr").find("#spnSampleTypeName").html();
                        }
                        else {
                            $objSample.SampleTypeID = jQuery(this).closest("tr").find("#ddlSampleType option:selected").val();
                            $objSample.SampleTypeName = jQuery(this).closest("tr").find("#ddlSampleType option:selected").text();
                        }
                    }
                    $objSample.BarcodeNo = jQuery(this).closest("tr").find("#txtBarCodeNo").val();

                    $objSample.IsSNR = jQuery(this).closest("tr").find("#chSNR").prop('checked') == true ? '1' : '0';
                    if (jQuery(this).closest("tr").find("#tdReportType").text() == "7") {
                        $objSample.HistoCytoSampleDetail = jQuery(this).find('#ddlNoofsp').val() + "^" + jQuery(this).find('#ddlNoofsli').val() + "^" + jQuery(this).find('#ddlNoofblock').val();
                    }
                    else {
                        $objSample.HistoCytoSampleDetail = '';
                    }
                    $dataSample.push($objSample);
                }
            });
            return $dataSample;
        }
        $clearForm = function () {
            $PNameMob.length = 0;
           
            $InvList = []; $paymentModeCache = [];
            $itemwisedic = 0;
            Doctor_ID_Temp = 0; TempSecondRef = 0;
            jQuery('#spnError,#spnFileName').text('');
            jQuery('#spnTotalDiscountAmount').text('0');
            jQuery('#rdAge').prop("checked", true);
            jQuery('#chkIsVip').prop('checked', false);
            jQuery('#txtDOB').removeClass('requiredField');
            jQuery('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
            jQuery('#ddlTitle,#ddlGender,#ddlSource,#ddlVisitType,#ddlHLMType,#ddlIdentityType,.bnk,#ddlOutstandingEmployee,#ddlCorporateIDType,#ddlGovPanelType,#ddlCardHolderRelation,#ddlFieldBoy').prop('selectedIndex', 0);
            jQuery('#ddlFieldBoy').chosen('destroy').chosen();
            jQuery('#ddlFieldBoy_chosen').find('a').addClass('requiredField');
            jQuery('#ddlTitle,#txtAge,#txtAge1,#txtAge2').removeAttr("disabled");
            jQuery('#ddlGender,#txtDOB').attr('disabled', 'disabled');
            if (jQuery('#txtPreBookingNo').val() != "") {
                $getCentreData("0", function (callback) {
                });
            }
            jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
            jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', 1, ' ', jQuery('#spnBaseNotation').text()));

            jQuery("input[type=text]").not('#txtInvestigationSearch').val('');
            jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
            jQuery('#txtReferDoctor,#txtSecondReference').val('SELF');
            jQuery('#hftxtReferDoctor,#hfSecondReference').val('1');
            jQuery('#tb_ItemList tr').slice(1).remove();
            jQuery('#txtUHIDNo').attr('patientAdvanceAmount', '0');
            jQuery('.containerSuggestedTest').hide();
            jQuery('#tblPaymentDetail tr').slice(1).remove();
            jQuery('#tbltst tr').slice(1).remove();
            $getPaymentMode("0", function () { });
            jQuery('#spnUHIDNo,#spnReturn,#spnBlanceAmount').html('');
            $clearPaymentControl(function () { });
            jQuery('#lblTotalLabItemsCount').text('0');
            jQuery('#ddlApprovedBy').prop('selectedIndex', 0).toggleClass('customRequired', false).chosen('destroy').chosen();
            jQuery('#txtMobileNo,#txtAge,#txtAge1,#txtAge2,#txtUHIDNo,#txtPreBookingNo,#txtPName').attr("disabled", false);

            // jQuery('#ddlGender').attr("disabled", "disabled");
            jQuery('#ddlState').val(jQuery('#ddlCentre').val().split('#')[3]).chosen('destroy').chosen();
            jQuery('#divPrePrintedBarcode,#divRequiredField').hideModel();
            // $bindStateCityLocality("0", function () { });
            jQuery('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
            jQuery('#spnDocumentCounts,#spnDocumentMaualCounts').text('0');
            document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            jQuery('#lblOutstandingDiscount').text("");
            jQuery('#chkCashOutstanding').prop('checked', false);
            jQuery('.clCashOutstanding,.div_SampleCollectionCharges,.divFieldBoy,#tb_ItemList,.containerRecommendedPackage,.div_ReportDeliveryCharges').hide();
            jQuery('#tblPackageSuggestion tr').slice(1).remove();
            jQuery("#btnSkipSave").val('Skip & Save');
            jQuery("#tblMaualDocument tr").slice(1).remove();
            jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
            jQuery("#txtInvestigationSearch").attr('autocapitalize', 'off');
            jQuery("#txtInvestigationSearch").attr('autocorrect', 'off');

            jQuery("#txtMemberShipCardNo").val('').removeAttr('disabled');
 jQuery('#txtHomeCollection').val('').removeAttr('disabled');
            jQuery("#spnMembershipCardNo,#spnMembershipCardID,#spnIsSelfPatient").text('');
            jQuery("#txtappointment,#txtothertitle").val('');
            $('#txtothertitle').hide();
           
            jQuery('#ddlTitle').chosen("destroy").chosen({ width: '100%' });
            $TestCount = 0;
            jQuery('#lblTestCount').text('Test Count:0');
        }
        getBarcodeDetail = function (_barcode, _labno) {
            try {
                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.LedgerTransactionNo = _labno;
                objbarcodedata.BarcodeNo = _barcode;
                barcodedata.push(objbarcodedata);
                jQuery.ajax({
                    url: "../Lab/Services/LabBooking.asmx/getBarcode",
                    data: JSON.stringify({ data: barcodedata }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        window.location = 'barcode:///?cmd=' + result.d + '&Source=barcode_source';
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            catch (e) {
            }
        }
        var $PNameMob = [];
        function $patientMaster() {
            var $age = "";
            var $ageyear = "0";
            var $agemonth = "0";
            var $ageday = "0";
            if (jQuery('#txtAge').val() != "") {
                $ageyear = jQuery('#txtAge').val();
            }
            if (jQuery('#txtAge1').val() != "") {
                $agemonth = jQuery('#txtAge1').val();
            }
            if (jQuery('#txtAge2').val() != "") {
                $ageday = jQuery('#txtAge2').val();
            }
            $age = $ageyear + " Y " + $agemonth + " M " + $ageday + " D ";
            var $ageindays = parseInt($ageyear) * 365 + parseInt($agemonth) * 30 + parseInt($ageday);
            var $objPM = new Array();
            $objPM.push({
                Patient_ID: jQuery.trim(jQuery('#spnUHIDNo').html()),
                Title: jQuery("#ddlTitle option:selected").text() == 'NA' ? jQuery('#txtothertitle').val() : jQuery("#ddlTitle option:selected").text(),
                PName: jQuery.trim(jQuery('#txtPName').val()),
                House_No: jQuery.trim(jQuery('#txtPAddress').val()),
                Street_Name: "",
                PinCode: jQuery('#txtPinCode').val() != "" ? jQuery.trim(jQuery('#txtPinCode').val()) : 0,
                Country: jQuery("#ddlCountry option:selected").text(),
                State: jQuery("#ddlState option:selected").text(),
                City: jQuery("#ddlCity option:selected").text(),
                Locality: jQuery('#ddlArea option:selected').text(),
                CountryID: jQuery('#ddlCountry').val(),
                StateID: jQuery('#ddlState').val(),
                CityID: jQuery('#ddlCity').val(),
                LocalityID: jQuery('#ddlArea').val(),
                Phone: "",
                Mobile: jQuery.trim(jQuery('#txtMobileNo').val()),
                Email: jQuery.trim(jQuery('#txtEmail').val()),
                Age: $age,
                AgeYear: $ageyear,
                AgeMonth: $agemonth,
                AgeDays: $ageday,
                TotalAgeInDays: $ageindays,
                DOB: jQuery('#txtDOB').val(),
                Gender: jQuery("#ddlGender option:selected").text(),
                CentreID: jQuery('#ddlCentre option:selected').val().split('#')[0],
                IsOnlineFilterData: "0",
                IsDuplicate: 0,
                isCapTure: jQuery('#spnIsCapTure').text(),
                base64PatientProfilePic: jQuery('#imgPatient').prop('src'),
                IsDOBActual: jQuery('#rdDOB').is(':checked') ? 1 : 0,
                ClinicalHistory: jQuery.trim(jQuery('#txtClinicalHistory').val()),
                VIP: jQuery('#chkIsVip').prop('checked') ? 1 : 0
            });
            return $objPM;
        }
        function $f_ledgertransaction() {
            var $objLT = new Object();
            $objLT.NetAmount = jQuery.trim(jQuery('#txtNetAmount').val());
            $objLT.GrossAmount = jQuery.trim(jQuery('#txtGrossAmount').val());
            if (jQuery("#ddlPanel").val().split('#')[20] == "1" || jQuery('#chkPaymentMode4').is(':checked')) {
                $objLT.IsCredit = 1
            }
            else {
                $objLT.IsCredit = 0;
            }
           $objLT.PROID=jQuery.trim(jQuery('#ddlPRO').val());
           $objLT.Nationality =jQuery.trim(jQuery('#txtNationality').val());
           $objLT.ECHS 	=jQuery.trim(jQuery('#txtECHS').val());
           $objLT.PureHealthID=jQuery.trim(jQuery('#txtPureHealthID').val());
           $objLT.ICMRNo 	=jQuery.trim(jQuery('#txtICMRNo').val());
           $objLT.PassPortNo 	=jQuery.trim(jQuery('#txtPassport').val());
           $objLT.BarcodeManual 	=jQuery.trim(jQuery('#txtBarcodeno').val());
    
            $objLT.DiscountReason = jQuery.trim(jQuery('#txtDiscountReason').val());
            $objLT.DiscountApprovedByID = jQuery('#ddlApprovedBy').val().split('#')[0];
            $objLT.DiscountApprovedByName = jQuery('#ddlApprovedBy').val() != 0 ? jQuery('#ddlApprovedBy option:selected').text() : "";
            $objLT.Remarks = jQuery.trim(jQuery('#txtRemarks').val());
            $objLT.Panel_ID = jQuery("#ddlPanel").val().split('#')[0];
            $objLT.PanelName = jQuery('#ddlPanel option:selected').text().substr(jQuery('#ddlPanel option:selected').text().indexOf(' ') + 1);
            $objLT.Doctor_ID = jQuery("#hftxtReferDoctor").val() == "" ? "1" : jQuery("#hftxtReferDoctor").val();
            $objLT.DoctorName = jQuery("#hftxtReferDoctor").val() == "" ? "SELF" : jQuery('#txtReferDoctor').val().split('#')[0];
            $objLT.OtherReferLabID = 0;
            $objLT.VIP = jQuery('#chkIsVip').prop('checked') ? 1 : 0;
            $objLT.CentreID = jQuery('#ddlCentre option:selected').val().split('#')[0];
            $objLT.Adjustment = jQuery('#txtPaidAmount').val() == "" ? 0 : jQuery('#txtPaidAmount').val();
            $objLT.HomeVisitBoyID = jQuery('#ddlFieldBoy').val();
            $objLT.PatientIDProof = jQuery.trim(jQuery('#txtIdProofNo').val()) != "" ? jQuery('#ddlIdentityType').val() : "";
            $objLT.PatientIDProofNo = jQuery.trim(jQuery('#txtIdProofNo').val()) != "" ? jQuery.trim(jQuery('#txtIdProofNo').val()) : "";
            $objLT.PatientSource = jQuery('#ddlSource').val();
            $objLT.PatientType = jQuery('#ddlPatientType option:selected').text();
            $objLT.VisitType = jQuery('#ddlVisitType').val();
            $objLT.HLMPatientType = jQuery('#ddlHLMType').val();
            $objLT.HLMOPDIPDNo = jQuery.trim(jQuery('#txtHLMOPDIPNo').val());
            $objLT.DiscountOnTotal = jQuery('#spnTotalDiscountAmount').text() != "0" ? jQuery('#spnTotalDiscountAmount').text() : 0;
            $objLT.DiscountPending = jQuery('#spnTotalDiscountAmount').text() != "0" ? jQuery('#ddlApprovedBy').val().split('#')[2] : 0;
            $objLT.DiscountID = jQuery('#spnTotalDiscountAmount').text() != "0" ? 1 : 0;
            $objLT.DiscountID = jQuery('#spnTotalDiscountAmount').text() != "0" ? 1 : 0;
            if (jQuery("#ddlPanel").val().split('#')[2] == "Credit") {
                $objLT.MemberShipCardNo = "";
                $objLT.MembershipCardID = 0;
            }
            else {
                $objLT.MemberShipCardNo = jQuery('#spnMembershipCardNo').text();
                $objLT.MembershipCardID = jQuery('#spnMembershipCardID').text();
            }
            $objLT.IsSelfPatient = jQuery('#spnIsSelfPatient').text();
            $objLT.AppointmentID = $("#txtappointment").val() != "" ? $("#txtappointment").val() : 0;
            $objLT.HomeCollectionAppID = $("#txtHomeCollection").val() != "" ? $("#txtHomeCollection").val() : 0;
            switch (jQuery('#ddlPatientType').val()) {
                case '2':
                    {
                        $objLT.CorporateIDType = jQuery("#ddlCorporateIDType").val();
                        $objLT.CorporateIDCard = jQuery.trim(jQuery("#txtCorporateIDCard").val());
                        $objLT.CardHolderRelation = jQuery('#ddlCardHolderRelation').val();
                        $objLT.CardHolderName = jQuery.trim(jQuery('#txtCardHolderName').val());
                        $objLT.PatientGovtType = "";
                        break;
                    }
                case '7':
                    {
                        $objLT.CorporateIDType = jQuery("#ddlCorporateIDType").val();
                        $objLT.CorporateIDCard = jQuery.trim(jQuery("#txtCorporateIDCard").val());
                        $objLT.CardHolderRelation = jQuery('#ddlCardHolderRelation').val();
                        $objLT.CardHolderName = jQuery.trim(jQuery('#txtCardHolderName').val());
                        $objLT.PatientGovtType = jQuery('#ddlGovPanelType').val();
                        break;
                    }
                case '6':
                    {
                        $objLT.CorporateIDType = jQuery("#ddlCorporateIDType").val();
                        $objLT.CorporateIDCard = jQuery("#txtCorporateIDCard").val();
                        $objLT.CardHolderRelation = jQuery('#ddlCardHolderRelation').val();
                        $objLT.CardHolderName = jQuery('#txtCardHolderName').val();
                        $objLT.PatientGovtType = "";
                    }
                default:
                    {
                        $objLT.CorporateIDType = "";
                        $objLT.CorporateIDCard = "";
                        $objLT.CardHolderRelation = "";
                        $objLT.CardHolderName = "";
                        $objLT.PatientGovtType = "";
                    }
            }
            $objLT.IsInvoice = jQuery('#ddlPanel').val().split('#')[10];
            $objLT.showBalanceAmt = jQuery('#ddlPanel').val().split('#')[11];
            $objLT.CentreName = jQuery('#ddlCentre option:selected').text();
            $objLT.DiscountType = jQuery('#spnTotalDiscountAmount').text() != "0" ? 1 : 0;
            $objLT.PatientTypeID = jQuery('#ddlPatientType').val();
            $objLT.PreBookingID = jQuery.trim(jQuery('#txtPreBookingNo').val()) != "" ? jQuery('#txtPreBookingNo').val() : 0;
            $objLT.Doctor_ID_Temp = Doctor_ID_Temp;
            $objLT.COCO_FOCO = jQuery('#ddlCentre').val().split('#')[9];
            $objLT.Type1ID = jQuery('#ddlCentre').val().split('#')[1];
            $objLT.BarCodePrintedType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedType;
            $objLT.BarCodePrintedCentreType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedCentreType;
            $objLT.BarCodePrintedHomeColectionType = jQuery("#ddlPanel option:selected").data("value").BarCodePrintedHomeColectionType;
            $objLT.setOfBarCode = jQuery("#ddlPanel option:selected").data("value").setOfBarCode;
            $objLT.SampleCollectionOnReg = jQuery("#ddlPanel option:selected").data("value").SampleCollectionOnReg;
            $objLT.InvoiceToPanelId = jQuery("#ddlPanel option:selected").data("value").InvoiceTo;
            $objLT.OtherLabRefNo = jQuery.trim(jQuery('#txtOtherLabRefNo').val());
            if (jQuery('#chkCashOutstanding').is(':checked')) {
                $objLT.OutstandingEmployeeId = jQuery('#ddlOutstandingEmployee').val().split('#')[0];
                $objLT.CashOutstanding = jQuery('#lblOutstandingDiscount').text();
                if (jQuery('#txtNetAmount').val() == "0") {
                    $objLT.CashOutstandingPer = 100;
                }
                else {
                    $objLT.CashOutstandingPer = ((jQuery('#txtOutstandingAmt').val() / jQuery('#txtNetAmount').val()) * 100);
                }
            }
            else {
                $objLT.OutstandingEmployeeId = 0;
                $objLT.CashOutstanding = 0;
                $objLT.CashOutstandingPer = 0;
            }

            $objLT.SecondReferenceID = jQuery("#hfSecondReference").val() == "" ? "1" : jQuery("#hfSecondReference").val();
            $objLT.SecondReference = jQuery("#hfSecondReference").val() == "" ? "SELF" : jQuery('#txtSecondReference').val().split('#')[0];
            $objLT.AttachedFileName = jQuery('#spnFileName').text();
            $objLT.TempSecondRef = TempSecondRef;
            $objLT.Currency_RoundOff = jQuery.trim(jQuery('#txtCurrencyRound').val()) == "" ? 0 : jQuery('#txtCurrencyRound').val();
            $objLT.DispatchModeID = jQuery('#ddlDispatchMode option:selected').val();
            $objLT.DispatchModeName = jQuery('#ddlDispatchMode option:selected').text();
            $objLT.AppBelowBaseRate = jQuery('#ddlApprovedBy').val().split('#')[4];
            $objLT.IsMRPBill = jQuery('#ddlPanel').val().split('#')[23];
            $objLT.SRFNo = jQuery('#txtSRFNumber').val().trim();

            return $objLT;
        }
        var ItemWiseDisc = 0;
        function $patientLabInvestigationOPD() {
            var $dataPLO = new Array();
            var $rowNum = 1;
            var $amtValue = 0;
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    var $objPLO = new Object();
                    $objPLO.ItemId = jQuery.trim(jQuery(this).closest("tr").attr("id"));
                    $objPLO.ItemName = jQuery(this).closest("tr").find("#tdItemName").text();
                    $objPLO.ItemCode = jQuery.trim(jQuery(this).closest("tr").find("#tdTestCode").text());
                    var $ispackage = jQuery.trim(jQuery(this).closest("tr").find("#tdIsPackage").html());
                    if ($ispackage == 0) {
                        $objPLO.InvestigationName = jQuery.trim(jQuery(this).closest("tr").find("#tdItemName").text());
                        $objPLO.PackageName = "";
                        $objPLO.PackageCode = "";
                        $objPLO.Investigation_ID = jQuery.trim(jQuery(this).closest("tr").find(".inv").attr("id"));
                        $objPLO.IsPackage = "0";
                        $objPLO.IsReporting = jQuery.trim(jQuery(this).closest("tr").find("#tdIsReporting").html());
                        $objPLO.ReportType = jQuery.trim(jQuery(this).closest("tr").find("#tdReportType").html());
                        if (jQuery.trim(jQuery(this).closest("tr").find("#tdSample").html()) == "N") {
                            $objPLO.IsSampleCollected = "Y";
                            $objPLO.SampleBySelf = "1";
                        }
                        else if (jQuery(this).closest("tr").find("#chkIsSampleCollection").is(':checked')) {
                            $objPLO.IsSampleCollected = "S";
                            $objPLO.SampleBySelf = "1";
                        }
                        else {
                            $objPLO.IsSampleCollected = "N";
                            $objPLO.SampleBySelf = "0";
                        }
                    }
                    else {
                        $objPLO.InvestigationName = "";
                        $objPLO.PackageName = jQuery.trim(jQuery(this).closest("tr").find("#tdItemName").text());
                        $objPLO.PackageCode = jQuery.trim(jQuery(this).closest("tr").find("#tdTestCode").text());
                        $objPLO.Investigation_ID = "0";
                        $objPLO.IsPackage = "1";
                        $objPLO.IsReporting = "0";
                        $objPLO.ReportType = "0";
                        $objPLO.IsSampleCollected = "N";
                        $objPLO.SampleBySelf = "0";
                    }
                    $objPLO.SubCategoryID = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryID").html());
                    $objPLO.MRP = jQuery.trim(jQuery(this).closest("tr").find("#tdMRP").html());
                    $objPLO.Rate = jQuery.trim(jQuery(this).closest("tr").find("#tdRate").html());
                    $objPLO.BaseRate = jQuery.trim(jQuery(this).closest("tr").find("#tdBaseRate").html());
                    if (jQuery('#ddlApprovedBy > option').length > 0 && jQuery('#ddlPatientType').val() == "1")
                        $objPLO.DiscountByLab = jQuery('#ddlApprovedBy').val().split('#')[5];
                    else
                        $objPLO.DiscountByLab = 0;
                    $objPLO.DiscountAmt = parseInt(jQuery(this).closest("tr").find("#txtItemWiseDiscount").val());
                    $objPLO.Amount = jQuery(this).closest("tr").find("#txtNetAmt").val();

                    $objPLO.PayByPanel = jQuery(this).closest("tr").find("#txtPayByPanel").val();
                    $objPLO.PayByPanelPercentage = jQuery(this).closest("tr").find("#txtPayByPanelPer").val();
                    $objPLO.PayByPatient = jQuery(this).closest("tr").find("#txtPayByPatient").val();

                    $objPLO.CentreID = jQuery('#ddlCentre option:selected').val().split('#')[0];
                    $objPLO.TestCentreID = "0";
                    $objPLO.isUrgent = jQuery(this).closest("tr").find("#chkIsUrgent").is(':checked') ? 1 : 0;
                    $objPLO.DeliveryDate = jQuery.trim(jQuery(this).closest("tr").find("#tdDeliveryDate").html());
                    $objPLO.SRADate = jQuery.trim(jQuery(this).closest("tr").find("#tdSRADate").html());
                    $objPLO.SampleCollectionDate = "".concat(jQuery('#txtCollectionDate').val(), " ", jQuery('#txtCollectionTime').val());
                    $objPLO.IsScheduleRate = jQuery.trim(jQuery(this).closest("tr").find("#tdIsScheduleRate").html());
                    $objPLO.PanelItemCode = jQuery.trim(jQuery(this).closest("tr").find("#tdPanelItemCode").html());
                    $objPLO.RequiredAttachment = jQuery.trim(jQuery(this).closest("tr").find("#tdRequiredAttachment").html());
                    $objPLO.RequiredAttachmentID = jQuery.trim(jQuery(this).closest("tr").find("#tdRequiredAttachmentID").html());
                    $objPLO.RequiredAttchmentAt = jQuery.trim(jQuery(this).closest("tr").find("#tdRequiredAttchmentAt").html());
                    $objPLO.EncryptedRate = jQuery.trim(jQuery(this).closest("tr").find("#tdEncryptedRate").html());
                    $objPLO.EncryptedAmount = jQuery.trim(jQuery(this).closest("tr").find("#tdEncryptedAmount").html());
                    $objPLO.EncryptedDiscAmt = jQuery.trim(jQuery(this).closest("tr").find("#tdEncryptedDiscAmt").html());
                    $objPLO.EncryptedItemID = jQuery.trim(jQuery(this).closest("tr").find("#tdEncryptedItemID").html());
                    $objPLO.EncryptedMRP = jQuery.trim(jQuery(this).closest("tr").find("#tdEncryptedMRP").html());
                    $objPLO.IsSampleCollectedByPatient = jQuery(this).closest("tr").find("#chkIsSampleCollectedByPatient").is(':checked') ? 1 : 0;
                    $objPLO.Quantity = jQuery.trim(jQuery(this).closest('tr').find("#ddlIsRequiredQty").val());
                    $objPLO.DepartmentDisplayName = jQuery.trim(jQuery(this).closest("tr").find("#tdDepartmentDisplayName").html());

                    $objPLO.IsMemberShipFreeTest = jQuery.trim(jQuery(this).closest("tr").find("#tdIsMemberShipFreeTest").html());
                    $objPLO.MemberShipDisc = jQuery.trim(jQuery(this).closest("tr").find("#tdMemberShipDisc").html());
                    $objPLO.MemberShipTableID = jQuery.trim(jQuery(this).closest("tr").find("#tdMemberShipTableID").html());
                    $objPLO.IsMemberShipDisc = jQuery.trim(jQuery(this).closest("tr").find("#tdIsMemberShipDisc").html());
                    $objPLO.SubCategoryName = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryName").html());
                    $dataPLO.push($objPLO);

                }
            });
            if (Number(jQuery('#txtSampleCollectionCharge').val()) > 0) {
                var $objPLO = new Object();
                $objPLO.ItemId = '<%=Resources.Resource.SampleCollectionChargeItemID%>';
                $objPLO.ItemName = "SAMPLE COLLECTION CHARGE";
                $objPLO.TestCode = "";
                $objPLO.InvestigationName = "SAMPLE COLLECTION CHARGE";
                $objPLO.PackageName = "";
                $objPLO.PackageCode = "";
                $objPLO.Investigation_ID = '<%=Resources.Resource.SampleCollectionChargeInvestigation_ID%>';
                $objPLO.IsPackage = "0";
                $objPLO.SubCategoryID = "27";
                $objPLO.Rate = jQuery('#txtSampleCollectionCharge').val();
                $objPLO.Amount = jQuery('#txtSampleCollectionCharge').val();
                $objPLO.DiscountAmt = 0;
                $objPLO.IsReporting = "0";
                $objPLO.ReportType = "0";
                $objPLO.CentreID = jQuery('#ddlCentre option:selected').val().split('#')[0];
                $objPLO.TestCentreID = "0";
                $objPLO.RequiredAttachment = "";
                $objPLO.DepartmentDisplayName = "";
                $objPLO.SubCategoryName = "OTHER CHARGES";
                $dataPLO.push($objPLO);
            }
            if (Number(jQuery('#txtReportDeliveryCharge').val()) > 0) {
                var $objPLO = new Object();
                $objPLO.ItemId = '<%=Resources.Resource.ReportDeliveryChargeItemID%>';
                $objPLO.ItemName = "REPORT DELIVERY CHARGE";
                $objPLO.TestCode = "";
                $objPLO.InvestigationName = "REPORT DELIVERY CHARGE";
                $objPLO.PackageName = "";
                $objPLO.PackageCode = "";
                $objPLO.Investigation_ID = '<%=Resources.Resource.ReportDeliveryChargeInvestigation_ID%>';
                $objPLO.IsPackage = "0";
                $objPLO.SubCategoryID = "27";
                $objPLO.Rate = jQuery('#txtReportDeliveryCharge').val();
                $objPLO.Amount = jQuery('#txtReportDeliveryCharge').val();
                $objPLO.DiscountAmt = 0;
                $objPLO.IsReporting = "0";
                $objPLO.ReportType = "0";
                $objPLO.CentreID = jQuery('#ddlCentre option:selected').val().split('#')[0];
                $objPLO.TestCentreID = "0";
                $objPLO.RequiredAttachment = "";
                $objPLO.DepartmentDisplayName = "";
                $objPLO.SubCategoryName = "OTHER CHARGES";
                $dataPLO.push($objPLO);
            }
            return $dataPLO;
        }
        $f_Receipt = function () {
            var $dataRC = new Array();
            if (parseFloat(jQuery('#txtNetAmount').val()) > 0) {
                jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                    var $PatientPaidAmount = jQuery(this).closest('tr').find('#txtPatientPaidAmount').val();
                    if (isNaN($PatientPaidAmount) || $PatientPaidAmount == "")
                        $PatientPaidAmount = 0;
                    if ($PatientPaidAmount > 0) {
                        var $objRC = new Object();
                        $objRC.PayBy = "P";
                        $objRC.PaymentMode = jQuery(this).closest('tr').find('#tdPaymentMode').text();
                        $objRC.PaymentModeID = jQuery(this).closest('tr').find('#tdPaymentModeID').text();
                        $objRC.Amount = jQuery(this).closest('tr').find('#tdBaseCurrencyAmount').text();
                        $objRC.transactionid = jQuery(this).closest('tr').find('#transactionid').val();
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
                        $objRC.CentreID = jQuery('#ddlCentre option:selected').val().split('#')[0];
                        $objRC.TIDNumber = "";
                        $objRC.Panel_ID = jQuery("#ddlPanel").val().split('#')[0];
                        $objRC.CurrencyRoundDigit = jQuery(this).closest('tr').find('#tdCurrencyRound').text();
                        $objRC.Converson_ID = jQuery(this).closest('tr').find('#tdConverson_ID').text();
                        $dataRC.push($objRC);
                    }
                });
            }
            return $dataRC;
        }
    </script>
    <script type="text/javascript">

        var CheckValidationRequired = function () {
            var ItemId = "";
            var Mobile = 0;
            var Address = 0;
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    ItemId = ItemId + jQuery(this).closest("tr").find('#spnItemID').text() + ',';
                }
            });

            jQuery.ajax({
                url: "../Lab/Lab_PrescriptionOPD.aspx/CheckValidation",
                data: JSON.stringify({ ItemId: ItemId }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = result.d;
                    if (parseInt(result.Mobile) > 0) {
                        Mobile = 1;
                    }
                    if (parseInt(result.Address) > 0) {
                        Address = 1;
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            return Mobile + '#' + Address;
        }

        $validation = function () {
            //   if (jQuery('#txtMobileNo').val().length == 0 && jQuery('#ddlPatientType').val() != "3") {
            // toast("Error", "Please Enter Mobile No.", "");
            //  jQuery('#txtMobileNo').focus();
            //   return false;
            // }
            if (jQuery('#txtMobileNo').val().length != 0) {
                if (jQuery('#txtMobileNo').val().length < 10) {
                    toast("Error", "Incorrect Mobile No.", "");
                    jQuery('#txtMobileNo').focus();
                    return false;
                }
            }
            if (jQuery("#ddlTitle option:selected").text() == 'NA' && jQuery('#txtothertitle').val()=="") {
                toast("Error", "Please Enter Ttile", "");
                jQuery('#txtothertitle').focus();
                return false;
            }
            if (jQuery('#txtPName').val().trim().length == 0) {
                toast("Error", "Please Enter Patient Name", "");
                jQuery('#txtPName').focus();
                return false;
            }
            if (jQuery('#txtPName').val().trim().charAt(0) == ".") {
                toast("Error", "Please Enter Valid Patient Name, First Character cannot be Dot", "");
                jQuery('#txtPName').focus();
                return false;
            }
            if ($.inArray(jQuery('#txtPName').val().trim(), alphabetsArray) != -1)
            {
                toast("Error", "Please Enter Valid Patient Name", "");
                jQuery('#txtPName').focus();
                return false;
            }
            if (jQuery('#txtDOB').val().length == 0) {
                toast("Error", "Please Enter DOB", "");
                jQuery('#txtDOB').focus();
                return false;

            }
            if (jQuery('#txtReferDoctor').val() == "" || jQuery('#hftxtReferDoctor').val() == "") {
                toast("Error", "Please Enter Referred Doctor", "");
                jQuery("#txtReferDoctor").focus();
                return false;
            }
            var $ageyear = "";
            var $agemonth = "";
            var $ageday = "";
            if (jQuery('#txtAge').val() != "") {
                $ageyear = jQuery('#txtAge').val();
            }
            if (jQuery('#txtAge1').val() != "") {
                $agemonth = jQuery('#txtAge1').val();
            }
            if (jQuery('#txtAge2').val() != "") {
                $ageday = jQuery('#txtAge2').val();
            }
            if ($ageyear == "" && $agemonth == "" && $ageday == "") {
                toast("Error", "Please Enter Patient Age", "");
                jQuery('#txtAge').focus();
                return false;
            }
            if (jQuery('#ddlGender').val() == "") {
                toast("Error", "Please Select Patient Gender", "");
                jQuery('#ddlGender').focus();
                return false;
            }
            if ($("#ddlCountry option:selected").text() == "") {
                toast("Error", "Please Select Country", "");
                jQuery('#ddlCountry').focus();
                return false;
            }
            if ($("#ddlState option:selected").text() == "" || $("#ddlState option:selected").text() == "Select") {
                toast("Error", "Please Select State", "");
                jQuery('#ddlState').focus();
                return false;
            }
            if ($("#ddlCity option:selected").text() == "" || $("#ddlCity option:selected").text() == "Select") {
                toast("Error", "Please Select City", "");
                jQuery('#ddlCity').focus();
                return false;
            }

            if ($("#ddlArea option:selected").text() == "" || $("#ddlArea option:selected").text() == "Select") {
                toast("Error", "Please Select Locality", "");
                jQuery('#ddlArea').focus();
                return false;
            }
            if (jQuery('#txtEmail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtEmail').focus();
                    return false;
                }
            }
            if (jQuery('#ddlPatientType').val() == "4" && jQuery('#ddlHLMType').val() == "") {
                toast("Error", "Please Select HLM Type", "");
                jQuery("#ddlHLMType").focus();
                return false;
            }
            if (jQuery('#ddlPatientType').val() == "4" && jQuery('#txtHLMOPDIPNo').val() == "") {
                toast("Error", "Please Enter OPD/IPD No.", "");
                jQuery("#txtHLMOPDIPNo").focus();
                return false;
            }
            if (jQuery('#ddlVisitType').val() == "Home Collection" && jQuery('#ddlFieldBoy').val() == "0") {
                toast("Error", "Please Select Field Boy", "");
                jQuery('#ddlFieldBoy').focus();
                return false;
            }
            if (jQuery('#ddlVisitType').val() == "Home Collection") {
                if (jQuery('#txtCollectionDate').val() == "") {
                    toast("Error", "Please Select Sample Collection Date", "");
                    jQuery("#txtCollectionDate").focus();
                    return false;
                }
                if (jQuery('#txtCollectionTime').val() == "") {
                    toast("Error", "Please Select Sample Collection Time", "");
                    jQuery("#txtCollectionTime").focus();
                    return false;
                }
            }
            if (jQuery('#txtCollectionDate').val() != "" && jQuery('#txtCollectionTime').val() == "") {
                toast("Error", "Please Select Sample Collection Time", "");
                jQuery("#txtCollectionTime").focus();
                return false;
            }
            if (jQuery('#txtCollectionTime').val() != "" && jQuery('#txtCollectionDate').val() == "") {
                toast("Error", "Please Select Sample Collection Date", "");
                jQuery("#txtCollectionDate").focus();
                return false;
            }
            if ((jQuery("#ddlPatientType").val() == "2" || jQuery("#ddlPatientType").val() == "6" || jQuery("#ddlPatientType").val() == "7") && jQuery("#ddlCorporateIDType").val() != "0" && jQuery.trim(jQuery("#txtCorporateIDCard").val()) == "") {
                toast("Error", "Please Enter ID Card No.", "");
                jQuery("#txtCorporateIDCard").focus();
                return false;
            }
            if ((jQuery("#ddlPatientType").val() == "2" || jQuery("#ddlPatientType").val() == "6" || jQuery("#ddlPatientType").val() == "7") && jQuery("#ddlCorporateIDType").val() == "0" && jQuery.trim(jQuery("#txtCorporateIDCard").val()) != "") {
                toast("Error", "Please Select ID Type", "");
                jQuery("#ddlCorporateIDType").focus();
                return false;
            }
            if (jQuery("#ddlPatientType").val() == "7" && jQuery("#ddlGovPanelType").val() == "0") {
                toast("Error", "Please Select Govt. Type", "");
                jQuery("#ddlGovPanelType").focus();
                return false;
            }
       //   if ((jQuery("#ddlPatientType").val() == "2" || jQuery("#ddlPatientType").val() == "6" || jQuery("#ddlPatientType").val() == "7") && jQuery("#ddlCardHolderRelation").val() != "Self" && jQuery.trim(jQuery("#txtCardHolderName").val()) == "") {
       //       toast("Error", "Please Enter Card Holder Name", "");
       //       jQuery("#txtCardHolderName").focus();
       //       return false;
       //   }
       //   if (jQuery("#ddlCardHolderRelation").val() == "Self" && jQuery.trim(jQuery("#txtCardHolderName").val()).toUpperCase() != jQuery.trim(jQuery("#txtPName").val()).toUpperCase()) {
       //       toast("Error", "Please Enter Valid Card Holder Name", "");
       //       jQuery("#txtCardHolderName").focus();
       //       return false;
       //   }
            if (jQuery("#ddlIdentityType").val() != "0" && jQuery.trim(jQuery("#txtIdProofNo").val()) != "") {

            }
            if (jQuery("#ddlIdentityType").val() != "0" && jQuery.trim(jQuery("#txtIdProofNo").val()) != "") {
                if (jQuery("#ddlIdentityType option:selected").data("type") == "AadhaarCard") {
                    $aadhaarCardValidation();
                }
                else if (jQuery("#ddlIdentityType option:selected").data("type") == "PanCardNo") {
                    $panCardValidation();
                }
            }

            if (jQuery("#ddlDispatchMode").val() == "1" && jQuery.trim(jQuery("#txtEmail").val()) == "") {
                toast("Error", "Please Enter Email", "");
                jQuery("#txtEmail").focus();
                return false;
            }
           
            if ($("#ddlDispatchMode").val() == "3" && jQuery.trim(jQuery("#txtPAddress").val()) == "") {
                toast("Error", "Please Enter Address", "");
                jQuery("#txtPAddress").focus();
                return false;
            }
            if ($("#ddlDispatchMode").val() == "3" && jQuery.trim(jQuery("#txtPinCode").val()) == "") {
                toast("Error", "Please Enter PinCode", "");
                jQuery("#txtPinCode").focus();
                return false;
            }
            if (jQuery('#ddlPanel').val().split('#')[19] == "1" && jQuery.trim(jQuery('#txtOtherLabRefNo').val()) == "") {
                toast("Error", "Please Enter Other Lab Reference No.", "");
                jQuery('#txtOtherLabRefNo').focus();
                return false;
            }
            var $count = jQuery('#tb_ItemList tr').length;
            if ($count == 0 || $count == 1) {
                toast("Error", "Please Select Test", "");
                jQuery('#txtInvestigationSearch').focus();
                jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
                return false;
            }
            var getdata = CheckValidationRequired();
           // if (parseInt(getdata.split('#')[0]) == 1 && jQuery('#txtMobileNo').val().length == 0) {
             //   toast("Error", "Please Enter Mobile No.", "");
             //   jQuery('#txtMobileNo').focus();
            //    return false;
           // }
            if (parseInt(getdata.split('#')[1]) == 1 && jQuery.trim(jQuery("#txtPAddress").val()) == "") {
                toast("Error", "Please Enter Address", "");
                jQuery("#txtPAddress").focus();
                return false;
            }

            if ((Number(jQuery('#txtDiscountAmount').val()) > 0 || Number(jQuery('#txtDiscountPerCent').val()) > 0 || $itemwisedic == 1) && jQuery('#ddlApprovedBy').val() == "0" && jQuery.trim(jQuery('#spnMembershipCardNo').text()) == "") {
                toast("Error", "Please Select Discount Approved By", "");
                jQuery("#ddlApprovedBy").focus();
                return false;
            }
            if (Number(jQuery('#txtDiscountAmount').val()) > 0 || Number(jQuery('#txtDiscountPerCent').val()) > 0 || $itemwisedic == 1 && jQuery.trim(jQuery('#spnMembershipCardNo').text()) == "") {
                var $discpersetinmaster = jQuery('#ddlApprovedBy').val().split('#')[1];
                var $discpertotal = 0;
                if ($itemwisedic == 0) {
                    if (jQuery('#txtDiscountAmount').val() > 0)
                        $discpertotal = (parseFloat(jQuery('#txtDiscountAmount').val()) * 100) / parseFloat(jQuery('#txtGrossAmount').val());
                    else
                        $discpertotal = (parseFloat(jQuery('#txtDiscountPerCent').val()) * 100) / parseFloat(jQuery('#txtGrossAmount').val());
                }
                else {
                    var $itemWiseTotalDisc = 0;
                    jQuery('#tb_ItemList #tdBaseCurrencyAmount').each(function () { $itemWiseTotalDisc += parseFloat(jQuery(this).val()); });
                    $discpertotal = (parseFloat($itemWiseTotalDisc) * 100) / parseFloat(jQuery('#txtGrossAmount').val());
                }
                if (parseInt($discpertotal) > $discpersetinmaster) {
                    toast("Error", "Discount Percentage Limit Exceed <br/> Max Discount Should be: " + $discpersetinmaster + "%", "");
                    jQuery('#ddlApprovedBy').focus();
                    return false;
                }
            }
            if ((Number(jQuery('#txtDiscountAmount').val()) > 0 || Number(jQuery('#txtDiscountPerCent').val()) > 0 || $itemwisedic == 1) && jQuery('#txtDiscountReason').val() == "" && jQuery.trim(jQuery('#spnMembershipCardNo').text()) == "") {
                toast("Error", "Please Enter Discount Reason", "");
                jQuery("#txtDiscountReason").focus();
                return false;
            }
            if (jQuery("#ddlPanel").val().split('#')[20] == "1") {
                var $total = parseFloat(Number(jQuery('#txtpaybypatientfinal').val()));
                if (isNaN($total) || $total == "")
                    $total = 0;
                var $paid = jQuery('#txtPaidAmount').val() == "" ? 0 : jQuery('#txtPaidAmount').val();
                if (isNaN($paid) || $paid == "")
                    $paid = 0;
                if (parseFloat($paid) != parseFloat($total)) {
                    toast("Error", "Please Pay Total Pay By Patient Amount", "");                   
                    return false;
                }
            }
            else if (jQuery('#ddlPanel option:selected').val().split('#')[2] == "Cash") {
                if ((jQuery('#chkCashOutstanding').is(':checked'))) {
                    var $total = ($('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(Number(jQuery('#txtpaybypatientfinal').val())) : parseFloat(Number(jQuery('#txtNetAmount').val())));
                    if (isNaN($total) || $total == "")
                        $total = 0;
                    var $paid = jQuery('#txtPaidAmount').val() == "" ? 0 : jQuery('#txtPaidAmount').val();
                    if (isNaN($paid) || $paid == "")
                        $paid = 0;
                    var $outstanding = jQuery('#lblOutstandingDiscount').text() == "" ? 0 : jQuery('#lblOutstandingDiscount').text();
                    if (isNaN($outstanding) || $outstanding == "")
                        $outstanding = 0;
                    if ((parseInt($paid) + parseInt($outstanding)) > parseInt($total)) {
                        toast("Error", "Paid Amount can't Greater then Total Amount", "");
                        jQuery('#txtPaidAmount').val($total);
                        jQuery('#txtBlanceAmount,#txtOutstandingAmt').val('0');
                        jQuery('#lblOutstandingDiscount').text('0');
                        return false;
                    }
                    var $due = parseInt($total) - (parseInt($paid) + parseInt($outstanding));
                    jQuery('#txtBlanceAmount').val($due);
                    if (parseInt($due) == 0) {

                    }
                    else {
                        toast("Error", "Paid Amount and Outstanding Amount Sum is equal to Total Amount", "");
                        return false;
                    }
                }
                else {
                    var $mincash = jQuery('#ddlPanel').val().split('#')[3];//  78#78#Cash#50
                  // if ($mincash != "0") {
                  //     var $checkno = (parseFloat(jQuery('#txtNetAmount').val()) * parseFloat($mincash)) / 100;
                  //     var $paidAmt = jQuery('#txtPaidAmount').val();
                  //     if (isNaN($paidAmt) || $paidAmt == "")
                  //         $paidAmt = 0;
                  //     if (parseFloat($paidAmt) < parseFloat($checkno)) {
                  //         toast("Error", "".concat("Received amount must be ", $mincash, "% of Total Amount"), "");
                  //         jQuery('#txtPaidAmount').focus();
                  //         return false;
                  //     }
                  // }
                }
            }
            var attachment = [];
            jQuery('#tb_ItemList').find('tbody tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    if (jQuery.trim(jQuery(this).closest("tr").find("#tdRequiredAttchmentAt").html()) == "1") {
                        if (jQuery.trim(jQuery(this).closest("tr").find("#tdIsPackage").html()) == 1) {
                            if (jQuery(this).closest("tr").find("#tdRequiredAttachment").text() != "") {
                                for (var i = 0; i < jQuery(this).closest("tr").find("#tdRequiredAttachment").text().split(',').length; i++) {
                                    var reqAttachment = jQuery(this).closest("tr").find("#tdRequiredAttachment").text().split(',')[i];
                                    if (reqAttachment.indexOf("|") != -1) {
                                        for (var j = 0; j < reqAttachment.split('|').length; j++) {
                                            var reqAttachment1 = reqAttachment.split('|')[j];
                                            if (reqAttachment1 != "" && attachment.indexOf(reqAttachment1) == -1) {
                                                attachment.push(reqAttachment1);
                                            }
                                        }
                                    }
                                    else {
                                        if (reqAttachment != "" && attachment.indexOf(reqAttachment) == -1) {
                                            attachment.push(reqAttachment);
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            if (jQuery(this).closest("tr").find("#tdRequiredAttachment").text() != "") {
                                for (var i = 0; i < jQuery(this).closest("tr").find("#tdRequiredAttachment").text().split('|').length; i++) {
                                    var reqAttachment = jQuery(this).closest("tr").find("#tdRequiredAttachment").text().split('|')[i];
                                    if (reqAttachment != "" && attachment.indexOf(reqAttachment) == -1) {
                                        attachment.push(reqAttachment);
                                    }
                                }
                            }
                        }
                    }
                }
            });

            //  if (attachment.length > 0) {
            //      attachment = jQuery.unique(attachment);
            //      var reqAtta = attachment.sort().join(",");
            //  }



            if (attachment.length > 0 && jQuery("#tblMaualDocument").find('tbody tr').length == "0") {
				if (attachment[0] != "Consent Form"){
                toast("Error", "".concat(attachment.join(","), ' ', "Required to Attach With Booked Test"), "");
                return false;
				}
            }
            var MaualDocumentID = [];
            if (jQuery("#tblMaualDocument").find('tbody tr').length > 0) {
                jQuery("#tblMaualDocument").find('tbody tr').each(function () {
                    MaualDocumentID.push(jQuery(this).closest('tr').find("#tdManualDocumentName").text());
                });
            }
            //var newAttachment = [];
            //if (attachment.length > 0) {
            //    for (var i = 0; i < attachment.length; i++) {                  
            //        if (attachment[i] == "Doctor Prescription" && jQuery.inArray("Doctor Prescription", MaualDocumentID) == "-1") {
            //            toast("Error", "Doctor Prescription Required to Attach With Booked Test", "");
            //            return false;
            //        }                   
            //    }
            //}
            //attachment.splice(jQuery.inArray("Doctor Prescription", attachment), 1);
            //MaualDocumentID.splice(jQuery.inArray("Doctor Prescription", MaualDocumentID), 1);
            //if (attachment.length > 0 && MaualDocumentID.length==0) {
            //    toast("Error", "".concat(attachment.join(","), ' ', "Required to Attach With Booked Test"), "");
            //    return false;
            //}

            var DocumentDifference = [];
            jQuery.grep(attachment, function (el) {
                if (jQuery.inArray(el, MaualDocumentID) == -1) DocumentDifference.push(el);
            });
            if (DocumentDifference.length > 0) {
				if (attachment[0] != "Consent Form"){
                toast("Error", "".concat(DocumentDifference.join(","), ' ', "Required to Attach With Booked Test"), "");
                return false;
				}
            }
            if (jQuery('#ddlPanel option:selected').val().split('#')[2] == "Cash" || jQuery("#ddlPanel").val().split('#')[20] == "1") {


            }
            //var $paymentdone = 0;
            //if (jQuery("#txtNetAmount").val() > 0) {
            //    jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
            //        if (jQuery(this).closest('tr').find("#txtPatientPaidAmount").val() == "" || jQuery(this).closest('tr').find("#txtPatientPaidAmount").val() == 0) {
            //            $paymentdone = 1;
            //            jQuery(this).closest('tr').find("#txtPatientPaidAmount").focus();
            //            return false;
            //        }
            //    });
            //    if ($paymentdone == 1) {
            //        toast("Error", "Please Enter Amount", "");
            //        return false;
            //    }
            //}
            var $cardNoValidate = 0; var $cardDateValidate = 0; var $bankValidate = 0; var $transactionno = 0;
            jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                if (jQuery(this).closest('tr').find("#tdPaymentMode").text() != 1) {
                    if (jQuery(this).closest('tr').find("#txtCardNo").val() == "") {
                        $cardNoValidate = 1;
                        jQuery(this).closest('tr').find("#txtCardNo").focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find("#tdPaymentMode").text() != "Cash" && jQuery(this).closest('tr').find("#transactionid").val() == "") {
                        $transactionno = 1;
                        jQuery(this).closest('tr').find("#transactionid").addClass('requiredField');
                        jQuery(this).closest('tr').find("#transactionid").focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').find('#tdS_CountryID').text() + jQuery(this).closest('tr').find('#tdPaymentModeID').text())).val() == "") {
                        $cardDateValidate = 1;
                        jQuery(this).closest('tr').find("".concat('#txtCardDate_', jQuery(this).closest('tr').find('#tdS_CountryID').text() + jQuery(this).closest('tr').find('#tdPaymentModeID').text())).focus();
                        return false;
                    }
                    if (jQuery(this).closest('tr').find(".bnk").val() == 0) {
                        $bankValidate = 1;
                        jQuery(this).closest('tr').find(".bnk").focus();
                        return false;
                    }
                }
            });
            if ($cardNoValidate == 1) {
                toast("Error", "Please Enter Card Detail", "");
                return false;
            }
            if ($cardDateValidate == 1) {
                toast("Error", "Please Enter Card Date Detail", "");
                return false;
            }
            if ($transactionno == 1) {
                toast("Error", "Please Enter Transaction No", "");
                return false;
            }
            if ($bankValidate == 1) {
                toast("Error", "Please Select Bank Name", "");
                return false;
            }
            var $totalAmt = 0;
            jQuery('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { $totalAmt += parseFloat(jQuery(this).text()); });
            if (precise_round(parseFloat(parseFloat($totalAmt) + parseFloat(jQuery("#txtCurrencyRound").val())), 0) > parseFloat(jQuery('#txtNetAmount').val())) {
                toast("Error", "Paid Amount can't Greater then Total Amount", "");
                return false;
            }
            if (jQuery('#chkCashOutstanding').is(':checked')) {
                if (jQuery('#ddlOutstandingEmployee').val() == "0") {
                    toast("Error", "Please Select Outstanding Employee", "");
                    jQuery('#txtOutstandingAmt').val("");
                    jQuery('#ddlOutstandingEmployee').focus();
                    return false;;
                }
                if (jQuery('#txtOutstandingAmt').val() == "0" || jQuery('#txtOutstandingAmt').val() == "" || jQuery('#txtOutstandingAmt').val() == "") {
                    toast("Error", "Please Enter Outstanding Amount", "");
                    jQuery('#txtOutstandingAmt').focus();
                    return false;
                }

                if (parseFloat(parseFloat(parseFloat(jQuery('#txtOutstandingAmt').val() / jQuery('#txtNetAmount').val()) * 100) > parseFloat(jQuery('#ddlOutstandingEmployee').val().split('#')[2]))) {
                    toast("Error", "".concat("Max Outstanding Bill Percent is ", jQuery('#ddlOutstandingEmployee').val().split('#')[2]), "");
                    jQuery('#txtOutstandingAmt').focus();
                    return false;
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        $bindSampleType = function (investigationid, btnSave, buttonVal, callFunction) {
            jQuery('#tb_SampleList tr').slice(1).remove();
            jQuery('#txtAllBarCode').val('');
            var _$temp = [];
            _$temp.push(serverCall('../Lab/Services/LabBooking.asmx/GetsampleType', { investigationid: investigationid }, function (response) {
                jQuery.when.apply(null, _$temp).done(function () {
                    var $SampleData = JSON.parse(response);
                    for (var i = 0; i <= $SampleData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr id='");
                        $mydata.push($SampleData[i].investigation_id); $mydata.push("'"); $mydata.push("class='GridViewItemStyle' style='background-color:lemonchiffon'>");
                        $mydata.push('<td class="GridViewLabItemStyle" >');
                        $mydata.push(parseInt(i + 1));
                        $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdInvName" >');
                        $mydata.push($SampleData[i].NAME);
                        $mydata.push('</td>');
                        $mydata.push('<td id="tdSampleTypeName" style="font-weight:bold;">');
                        if ($SampleData[i].Container == "7") {
                            $mydata.push('<input id="txtSpecimenType" onkeypress="return blockSpecialChar(event)"   type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;" />');
                            $mydata.push('<br /><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlNoofsp"><option>0</option>');
                            $mydata.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                            $mydata.push('<br /><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlNoofsli">');
                            $mydata.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                            $mydata.push('<br /><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlNoofblock">');
                            $mydata.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                        }
                        else {
                            if ($SampleData[i].sampleinfo.split('^').length == 1) {
                                $mydata.push('<span style="font-weight:bold;" id="spnSampleTypeName">');
                                $mydata.push($SampleData[i].sampleinfo.split('^')[0].split('|')[1]);
                                $mydata.push('</span>');
                                $mydata.push('<span id="spnSampleTypeID" style="display:none;">');
                                $mydata.push($SampleData[i].sampleinfo.split('^')[0].split('|')[0]);
                                $mydata.push('</span>');
                            }
                            else {
                                $mydata.push('<select id="ddlSampleType" style="width:250px">');
                                for (var x = 0; x <= $SampleData[i].sampleinfo.split('^').length - 1; x++) {
                                    $mydata.push("<option value='");
                                    $mydata.push($SampleData[i].sampleinfo.split('^')[x].split('|')[0]); $mydata.push("'>");
                                    $mydata.push($SampleData[i].sampleinfo.split('^')[x].split('|')[1]);
                                    $mydata.push('</option>');
                                }
                                $mydata.push('</select>');
                            }
                        }
                        $mydata.push('</td>');
                        if ($SampleData[i].Container == "7") {
                            if (jQuery("#ddlPanel option:selected").data("value").setOfBarCode == "SampleType") {
                                $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,');
                                $mydata.push("'");
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push("')"); $mydata.push('"');
                                $mydata.push('placeholder="Enter Barcode" class="');
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"/>');
                                $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                            }
                            else {
                                $mydata.push('<td id="tdBarCodeNo"><input type="text"  style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,0)" placeholder="Enter Barcode" class="');
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                $mydata.push('"/>');
                                $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                            }
                        }
                        else {
                            if ($SampleData[i].sampleinfo.split('^').length == 1) {
                                if (jQuery("#ddlPanel option:selected").data("value").setOfBarCode == "SampleType") {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,');
                                    $mydata.push("'");
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push("')"); $mydata.push('"');
                                    $mydata.push('placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">1</span></td>');
                                }
                                else {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,0)" placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">1</span></td>');
                                }
                            }
                            else {
                                if (jQuery("#ddlPanel option:selected").data("value").setOfBarCode == "SampleType") {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,');
                                    $mydata.push("'");
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push("')"); $mydata.push();
                                    $mydata.push('placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                                }
                                else {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="$sameBarcode(this,0)" placeholder="Enter Barcode" class="'); $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                                }
                            }
                        }
                        $mydata.push('<td id="tdCheckSNR"><input type="checkbox" id="chSNR" onclick="$chkSNRClick(this);" /></td>');
                        $mydata.push('<td id="tdReportType" style="display:none;">');
                        $mydata.push($SampleData[i].Container);
                        $mydata.push('</td></tr>');
                        $mydata = $mydata.join("");
                        jQuery('#tb_SampleList').append($mydata);
                    }
                    if ($SampleData.length > 0) {
                        jQuery('#divPrePrintedBarcode').showModel();
                        jQuery(btnSave).attr('disabled', false).val('Save');
                        jQuery("#btnSkipSave").val('Skip & Save');
                    }
                    else {
                        if (callFunction == 0)
                            $saveLabPrescriptionData(function (btnSave, buttonVal) { });
                        else
                            $saveLabData(function (btnSave, buttonVal) { });
                    }
                });
            }));
        }
        $setBarCodeToall = function (ctrl) {
            var val = jQuery(ctrl).val();
            var name = jQuery(ctrl).attr("name");
            jQuery('input[name="' + name + '"]').each(function () {
                jQuery(this).val(val);
            });
        }
        $chkSNRClick = function (ctrl) {
            if (jQuery(ctrl).is(':checked'))
                jQuery(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').val('SNR');
            else
                jQuery(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').val('');
            jQuery(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').attr('disabled', jQuery(ctrl).is(':checked'));
        }
        $sameBarcode = function (ctrl, $SampleTypeID) {
            if ($SampleTypeID == 0) {
                var value = jQuery(ctrl).val();
                var classname = jQuery(ctrl).attr("class");
                var inputs = jQuery("." + classname);
                for (var i = 0; i < inputs.length; i++) {
                    jQuery(inputs[i]).val(value);
                }
            }
            else {
                jQuery("#tb_SampleList tr").find("." + $SampleTypeID).val(jQuery(ctrl).val());
            }
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
					<td style="border:solid 1px transparent"><button type="button" value="<#=objRow.Name#>"  id="btnDocumentName" title="<#=objRow.Name#>" class="btnDocumentName" style="width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" onclick="$documentNameClick(this, this.parentNode.parentNode)">
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
        $renderAmt = function () {
            var $cashPaidAmt = 0;
            jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                if (jQuery(this).closest('tr').find('#tdPaymentModeID').text() == 1) {
                    $cashPaidAmt = jQuery(this).closest('tr').find('#txtPatientPaidAmount').val();
                }
            });
            if ($cashPaidAmt == 0) {
                toast("Info", "Please Enter Cash Paid Amount", "");
                jQuery('#txtAmountGiven').val(''); jQuery('#spnReturn').html('');
                return;
            }
            if (Number(jQuery('#txtPaidAmount').val()) == 0) {
                jQuery('#spnReturn').html('');
                return;
            }
            if (jQuery('#txtAmountGiven').val() == '') {
                jQuery('#spnReturn').html('');
                return;
            }
            var $AmountGiven = jQuery('#txtAmountGiven').val();
            if (isNaN($AmountGiven) || $AmountGiven == 0)
                $AmountGiven = 0;
            if (Number($AmountGiven) > 0) {
                if (parseFloat($AmountGiven) - parseFloat($cashPaidAmt) < 0) {
                    jQuery('#spnReturn').html('');
                    return;
                }
                jQuery('#spnReturn').html("".concat("Return : ", (parseFloat($AmountGiven) - parseFloat($cashPaidAmt))));
            }
            else {
                jQuery('#spnReturn').html('');
            }
        }
    </script>
     <script type="text/javascript">
         jQuery(function () {            
             searchappointmentData();             
         });
         $viewDOS = function (investigationid, centerid, type, rowID) {
             var IsUrgent = $(rowID).closest('tr').find("#chkIsUrgent").is(':checked') ? 1 : 0;
             $fancyBoxOpen('../Master/DosData.aspx?investigationid=' + investigationid + '&centerid=' + centerid + '&type=' + type + '&IsUrgent=' + IsUrgent + '');
         }
          </script>
    <script type="text/javascript"> 
        function searchappointmentData() {          
           var $appointmentno = $("#txtappointment").val();
            if ($appointmentno == "")
                return;
            $("#btnsearchappointment").show();
            $("#txtappointment").show();
          
            serverCall('Lab_PrescriptionOPD.aspx/searchappointmentData', { AppointmentID: $appointmentno }, function (response) {
                var $responseData = JSON.parse(response);
               
                if ($responseData.length == 0) {
                    toast('Info', 'No Patient Found.', '');
                }
                else {
                  //  jQuery("#txtAppointmentNo").attr('disabled', 'disabled');                  
                    jQuery("#ddlCentre option:contains(" + $responseData[0]['Centre'] + ")").attr('selected', true);
                    $getCentreData("1", function (callback) {
                        jQuery("#txtMobileNo").val($responseData[0]['Mobile']).attr('disabled', 'disabled');
                        jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == $responseData[0]['Title'] })[0]).prop('selected', true).attr('disabled', 'disabled');
                        $onTitleChange(jQuery('#ddlTitle').val());
                        jQuery("#ddlGender").val($responseData[0]['Gender']).attr('disabled', 'disabled');
                        jQuery("#txtPName").val($responseData[0]['PatientName']).attr('disabled', 'disabled');                
                        jQuery("#txtAge").val($responseData[0]['AgeYear']);
                        jQuery("#txtAge1").val($responseData[0]['AgeMonth']);
                        jQuery("#txtAge2").val($responseData[0]['AgeDays']);
                        jQuery("#txtEmail").val($responseData[0]['EmailID']);
                        jQuery("#txtPinCode").val($responseData[0]['PinCode']);
                        jQuery('#ddlCountry').val(14).chosen('destroy').chosen();                                        
                        $responseData[0]['VIP'] == "VIP" ? jQuery("#chkIsVip").prop('checked', true) : jQuery("#chkIsVip").prop('checked', false);
                        $getdob();
                        //$bindState(14, "1", function (selectedStateID) {
                        //    jQuery('#ddlState').val($responseData[0]['StateID']).chosen('destroy').chosen();
                        //    $bindCity($responseData[0]['StateID'], "1", function (selectedCityID) {
                        //        jQuery('#ddlCity').val(1).chosen('destroy').chosen();
                        //        $bindLocality(1, "1", function () {
                        //            jQuery('#ddlArea').val(1).chosen('destroy').chosen();
                        //        });
                        //    });
                        //});                       
                        jQuery("#txtAppAmount").val($responseData[0]['Adjustment']);                                            
                        jQuery('#tablePatient tr').remove();                       
                        jQuery('#txtReferDoctor').val($responseData[0]['docname']);
                        jQuery('#hftxtReferDoctor').val($responseData[0]['Referdoctor']);
                        jQuery("#ddlPanel option:contains(" + $responseData[0]['PanelName'] + ")").attr('selected', true);
                    });
                    setTimeout(function () {
                        for (var i = 0; i < $responseData.length ; i++) {
                            var investigation = {};
                            investigation.item = $responseData[i];
                            $validateInvestigation(investigation, function () { });
                        }
                    }, 1000);

                }
            });
        } 
        function searchHomeCollectionData() {
            var $appointmentno = $("#txtHomeCollection").val();
            if ($appointmentno == "")
                return;
            //$("#btnsearchappointment").show();
            //$("#txtappointment").show();

            serverCall('Lab_PrescriptionOPD.aspx/searchHomeCollectionData', { AppointmentID: $appointmentno }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.length == 0) {
                    toast('Info', 'No Patient Found.', '');
                    $('#txtHomeCollection').val('');
                }
                else {
                    debugger;
                    //  jQuery("#txtAppointmentNo").attr('disabled', 'disabled');                  
                  //  jQuery("#ddlCentre option:contains(" + $responseData[0]['Centre'] + ")").attr('selected', true);
                    $getCentreData("1", function (callback) {
                        jQuery("#txtMobileNo").val($responseData[0]['Mobile']).attr('disabled', 'disabled');
                        jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == $responseData[0]['Title'] })[0]).prop('selected', true).attr('disabled', 'disabled');
                        $onTitleChange(jQuery('#ddlTitle').val());
                        jQuery("#ddlGender").val($responseData[0]['Gender']).attr('disabled', 'disabled');
                        jQuery("#txtPName").val($responseData[0]['PatientName']).attr('disabled', 'disabled');
                        jQuery("#txtAge").val($responseData[0]['AgeYear']);
                        jQuery("#txtAge1").val($responseData[0]['AgeMonth']);
                        jQuery("#txtAge2").val($responseData[0]['AgeDays']);
                        jQuery("#txtEmail").val($responseData[0]['EmailID']);
                        jQuery("#txtPinCode").val($responseData[0]['PinCode']);
                        jQuery('#ddlCountry').val(14).chosen('destroy').chosen();
                      //  $responseData[0]['VIP'] == "VIP" ? jQuery("#chkIsVip").prop('checked', true) : jQuery("#chkIsVip").prop('checked', false);
                        $getdob();
                        //$bindState(14, "1", function (selectedStateID) {
                        //    jQuery('#ddlState').val($responseData[0]['StateID']).chosen('destroy').chosen();
                        //    $bindCity($responseData[0]['StateID'], "1", function (selectedCityID) {
                        //        jQuery('#ddlCity').val(1).chosen('destroy').chosen();
                        //        $bindLocality(1, "1", function () {
                        //            jQuery('#ddlArea').val(1).chosen('destroy').chosen();
                        //        });
                        //    });
                        //});                       
                        jQuery("#txtAppAmount").val($responseData[0]['Adjustment']);
                        jQuery('#tablePatient tr').remove();
                        $('#txtHomeCollection').prop('disabled', true);
                       // jQuery('#txtReferDoctor').val($responseData[0]['docname']);
                       // jQuery('#hftxtReferDoctor').val($responseData[0]['Referdoctor']);
                      //  jQuery("#ddlPanel option:contains(" + $responseData[0]['PanelName'] + ")").attr('selected', true);
                    });
                    setTimeout(function () {
                        for (var i = 0; i < $responseData.length ; i++) {
                            var investigation = {};
                            investigation.item = $responseData[i];
                            $validateInvestigation(investigation, function () { });
                        }
                    }, 1000);

                }
            });
        }
        $hideRecommendedPackage = function () {
            jQuery(".divRecommendedPackage").slideToggle("slow");
        }
        jQuery(function () {
            jQuery(".button-RecommendedPackage").click(function () {
                jQuery(".divRecommendedPackage").slideToggle("slow");
            });
        });
        $bindTestPackage = function (testNameData) {



            jQuery("input[name='labItems'][value=2]").prop("checked", true);
            jQuery("#txtInvestigationSearch").val(testNameData.trim());
            jQuery("#txtInvestigationSearch").focus();
            jQuery('#txtInvestigationSearch').autocomplete('search');
            jQuery("#txtInvestigationSearch").focus(function () {
                jQuery(this).autocomplete("search");
                //Use the below line instead of triggering keydown
                // jQuery("#txtInvestigationSearch").data("autocomplete").search(jQuery(this).val());
            });
            $resetItem("0");
            jQuery('#tblPackageSuggestion tr').slice(1).remove();
            jQuery('.containerRecommendedPackage').hide();
        }
        $bindSuggestionPackage = function () {
            var $referenceCodeOPD = jQuery('#ddlPanel').val().split('#')[1];
            var $TestId = [];
            if (jQuery('#tb_ItemList tr').length > 3) {
                jQuery('#tb_ItemList tr').each(function (index) {
                    if (index > 0) {
                        $TestId.push(jQuery(this)[0].id);
                    }
                });
                $TestId = $TestId.join(",");
                var $TotalAmount = jQuery('#txtNetAmount').val().trim();
                serverCall('Lab_PrescriptionOPD.aspx/RecommendedPackage', { TestId: $TestId, referenceCodeOPD: $referenceCodeOPD, TotalAmount: $TotalAmount }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.length > 0) {
                        jQuery('#tblPackageSuggestion tr').slice(1).remove();
                        for (var i = 0; i < $responseData.length; i++) {
                            var $mydata = [];
                            $mydata.push('<tr onclick="$bindTestPackage(\'');
                            $mydata.push($responseData[i].Name); $mydata.push("\');"); $mydata.push('">');
                            $mydata.push('<td>');
                            $mydata.push(i + 1);
                            $mydata.push('</td><td style="text-align:left">');
                            $mydata.push($responseData[i].Name);
                            $mydata.push('<span class="spnTooltip"><table style="border: 1px solid black;width:360px">');
                            for (var j = 0; j < $responseData[i].ItemDetail.split('##').length; j++) {
                                if (j == 0) {
                                    $mydata.push('<tr ><td style="border: 1px solid black;font-weight: bold;" class="GridViewHeaderStyle">S.No.</td>');
                                    $mydata.push('<td style="border: 1px solid black;font-weight: bold;text-align: center;" class="GridViewHeaderStyle">Item Name</td></tr >');
                                }
                                $mydata.push('<tr><td style="border: 1px solid black;background-color:lemonchiffon">');
                                $mydata.push(j + 1);
                                $mydata.push('</td ><td style="border: 1px solid black;background-color:lemonchiffon">');
                                $mydata.push($responseData[i].ItemDetail.split('##')[j]);
                                $mydata.push('</td ></tr >');
                            }
                            $mydata.push('</table></span></td><td style="text-align: right">');
                            $mydata.push($responseData[i].Rate); $mydata.push('</td></tr>');
                            $mydata = $mydata.join("");
                            jQuery('#tblPackageSuggestion').append($mydata);
                        }
                        jQuery('.containerRecommendedPackage,.divRecommendedPackage').show();
                    }
                    else {
                        jQuery('.containerRecommendedPackage,.divRecommendedPackage').hide();
                        jQuery('#tblPackageSuggestion tr').slice(1).remove();
                    }
                });
            }
        }
        $showOutstanding = function () {
            jQuery('#txtOutstandingAmt').val("");
            jQuery('#ddlOutstandingEmployee').prop('selectedIndex', 0);
            jQuery('#lblOutstandingDiscount').text("");
            if (jQuery('#chkCashOutstanding').is(':checked'))
                jQuery('.clCashOutstanding').show();
            else
                jQuery('.clCashOutstanding').hide();
        }
        $CorporateIDType = function () {
            if (jQuery("#ddlCorporateIDType").val() != "0")
                jQuery('#txtCorporateIDCard').addClass('requiredField');
            else
                jQuery('#txtCorporateIDCard').removeClass('requiredField');
        }
        $cardHolderRelation = function () {
            if (jQuery("#ddlCardHolderRelation").val() == "Self")
                jQuery('#txtCardHolderName').val(jQuery('#txtPName').val().toUpperCase()).attr('disabled', 'disabled');
            else
                jQuery('#txtCardHolderName').removeAttr('disabled');
        }
    </script>
    <script type="text/javascript">
        $bindPromotionalTest = function (ItemID, callback) {
            $hidePromotionalTest();
            if (ItemID == "" || ItemID == null) {
                return false;
            }
            serverCall('Lab_PrescriptionOPD.aspx/bindPromotionlTest', { ItemID: ItemID, PanelID: jQuery("#ddlPanel").val().split('#')[1], CentreID: jQuery('#ddlCentre option:selected').val().split('#')[0] }, function (response) {
                $responseData = JSON.parse(response);
                jQuery('#tblPromotionalTest tr').slice(1).remove();

                if ($responseData.length > 0) {
                    for (var i = 0; i <= $responseData.length - 1; i++) {
                        var $promotionalTest = [];
                        var sugtestname = ($responseData[i].TestName.split('~')[1] == undefined) ? $responseData[i].TestName : $responseData[i].TestName.split('~')[1];
                        $promotionalTest.push('<tr style="background-color:aqua; cursor:pointer;"');
                        $promotionalTest.push('onclick="$fillSelectedTest(\''); $promotionalTest.push($responseData[i].TestCode); $promotionalTest.push('\');" >');
                        $promotionalTest.push('<td style="text-align:left;">'); $promotionalTest.push(i + 1);
                        $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].SelectedTestName);
                        $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].SelectedTestCode);
                        $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push(sugtestname);
                        $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].TestCode);
                        $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].rate);
                        $promotionalTest.push('</td></tr>');
                        $promotionalTest = $promotionalTest.join("");
                        jQuery('#tblPromotionalTest').append($promotionalTest);
                    }
                    jQuery('.containerPromotionalTest').show();
                    jQuery(".button-PromotionalTest").click();
                }
                else {
                    jQuery('.containerPromotionalTest').hide();
                }
            });
        }
        $fillSelectedTest = function (testName) {
            jQuery("input[name='labItems'][value=0]").prop("checked", true);
            // jQuery('#rdbItem_2').prop('checked', 'checked');
            jQuery("#txtInvestigationSearch").val(testName);
            jQuery("#txtInvestigationSearch").focus();
            jQuery('#txtInvestigationSearch').autocomplete('search');
            jQuery("#txtInvestigationSearch").focus(function () {
                jQuery(this).autocomplete("search");
                //Use the below line instead of triggering keydown
                // jQuery("#txtInvestigationSearch").data("autocomplete").search(jQuery(this).val());
            });
        }
        $hidePromotionalTest = function () {
            jQuery(".divPromotionalTest").slideToggle("slow");
        }
        $hideSuggestedTest = function () {
            jQuery(".divSuggestedTest").slideToggle("slow");
        }
        $bindSuggestedTest = function (PatientID) {
            jQuery('#tblSuggection tr').slice(1).remove();
            jQuery('.containerSuggestedTest').hide();
            if (jQuery('#ddlPatientType').val() != "3") {
                serverCall('Lab_PrescriptionOPD.aspx/SuggestedTest', { PatientID: PatientID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.length > 0) {
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $SuggestedTest = [];
                            var sugtestname = ($responseData[i].TestName.split('~')[1] == undefined) ? $responseData[i].TestName : $responseData[i].TestName.split('~')[1];
                            $SuggestedTest.push('<tr ');
                            if ($responseData[i].STATUS == 'High') {
                                $SuggestedTest.push(' style="background-color:pink; cursor:pointer; "');
                            }
                            else if ($responseData[i].STATUS == 'Low') {
                                $SuggestedTest.push(' style="background-color:yellow; cursor:pointer; "');
                            }
                            $SuggestedTest.push('onclick="$fillSelectedTest(\'');
                            $SuggestedTest.push($responseData[i].ItemCode); $SuggestedTest.push('\');" >');
                            $SuggestedTest.push('<td style="text-align:center;">'); $SuggestedTest.push(i + 1);
                            $SuggestedTest.push('</td><td style="text-align:center;">'); $SuggestedTest.push($responseData[i].DATE);
                            $SuggestedTest.push('</td><td style="text-align:left;">'); $SuggestedTest.push(sugtestname);
                            $SuggestedTest.push('</td><td style="text-align:center;">'); $SuggestedTest.push($responseData[i].STATUS);
                            $SuggestedTest.push('</td></tr>');
                            $SuggestedTest = $SuggestedTest.join("");
                            jQuery('#tblSuggection').append($SuggestedTest);
                        }
                        jQuery('.containerSuggestedTest').show();
                        jQuery(".button-SuggestedTest").click();
                    }
                });
            }
        }
    </script>
    <script type="text/javascript">
        $saveMaualDocument = function () {
            if (jQuery("#ddlDocumentType").val() == "0") {
                toast("Error", "Please Select Document Type", "");
                jQuery("#ddlDocumentType").focus();
                return;
            }
            if (jQuery("#fileManualUpload").val() == '') {
                toast("Error", "Please Select File to Upload", "");
                jQuery("#fileManualUpload").focus();
                return;
            }
            var $validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx"];
            var $extension = jQuery('#fileManualUpload').val().split('.').pop().toLowerCase();
            if (jQuery.inArray($extension, $validFilesTypes) == -1) {
                toast("Error", "".concat("Invalid File. Please upload a File with", " extension:\n\n", $validFilesTypes.join(", ")), "");
                return;
            }
            var $maxFileSize = 10485760; // 10MB -> 10 * 1024 * 1024
            var $fileUpload = jQuery('#fileManualUpload');
            if ($fileUpload[0].files[0].size > $maxFileSize) {
                toast("Error", "You can Upload Only 10 MB File", "");
                return;
            }
            var $MaualDocumentID = [];
            if (jQuery("#tblMaualDocument").find('tbody tr').length > 0) {
                jQuery("#tblMaualDocument").find('tbody tr').each(function () {
                    $MaualDocumentID.push(jQuery(this).closest('tr').find("#tdMaualDocumentID").text());
                });
            }
            if ($MaualDocumentID.length > 0) {
                if (jQuery.inArray(jQuery("#ddlDocumentType").val(), $MaualDocumentID) != -1) {
                    toast("Error", "Document already Saved", "");
                    return;
                }
            }
            var formData = new FormData();
            formData.append('file', jQuery('#fileManualUpload')[0].files[0]);
            formData.append('documentID', jQuery('#ddlDocumentType').val());
            formData.append('documentName', jQuery('#ddlDocumentType option:selected').text());
            formData.append('Filename', jQuery('#spnFileName').text());
            formData.append('Patient_ID', jQuery('#spnUHIDNo').text());
            formData.append('LabNo', "");
            jQuery.ajax({
                url: '../../UploadHandler.ashx',
                type: 'POST',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function (data, status) {
                    $("#fileProgress").hide();
                    if (status != 'error') {
                        toast("Success", "Uploaded Successfully", "");
                        var _temp = [];
                        _temp.push(serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: '', Filename: jQuery('#spnFileName').text(), PatientID: jQuery('#spnUHIDNo').text(), oldPatientSearch: 0, documentDetailID: data, isEdit: 0 }, function (response) {
                            jQuery.when.apply(null, _temp).done(function () {
                                var maualDocument = JSON.parse(response);
                                $addPatientDocumnet(maualDocument, 0);
                                jQuery("#fileManualUpload").val('');
                                jQuery("#ddlDocumentType").prop('selectedIndex', 0);
                                jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
                            });
                        }));
                    }
                },
                xhr: function () {
                    var fileXhr = $.ajaxSettings.xhr();
                    if (fileXhr.upload) {
                        $("progress").show();
                        fileXhr.upload.addEventListener("progress", function (e) {
                            if (e.lengthComputable) {
                                $("#fileProgress").attr({
                                    value: e.loaded,
                                    max: e.total
                                });
                            }
                        }, false);
                    }
                    return fileXhr;
                }
            });

        }
        $removeMaualDocument = function (rowID) {
            serverCall('../Common/Services/CommonServices.asmx/deletePatientDocument', { deletePath: jQuery(rowID).closest('tr').find("#tdManualFileURL").text(), ID: jQuery(rowID).closest('tr').find("#tdMaualID").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    jQuery(rowID).closest('tr').remove();
                    toast("Success", $responseData.response, "");
                    jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        $manualViewDocument = function (rowID) {
            serverCall('Lab_PrescriptionOPD.aspx/manualEncryptDocument', { fileName: jQuery(rowID).closest('tr').find("#tdMaualAttachedFile").text(), filePath: jQuery(rowID).closest('tr').find("#tdManualFileURL").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PostQueryString($responseData, '../Lab/ViewDocument.aspx');
                }
            });
        }
    </script> 
    <script type="text/javascript">
        var $onOutstandingAmt = function (e) {
            if (jQuery('#ddlOutstandingEmployee').val() == 0) {
                toast("Error", "Please Select Employee Name", "");
                jQuery('#ddlOutstandingEmployee').focus();
                jQuery('#txtOutstandingAmt').val('0');
                return;
            }
            var key = (e.keyCode ? e.keyCode : e.charCode);
            var $totalAmt = 0;
            jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                $totalAmt = Number($totalAmt) + Number(jQuery(this).closest('tr').find("#txtPatientPaidAmount").val());
            });
            $totalAmt = Number($totalAmt) + Number(jQuery('#txtOutstandingAmt').val());
            if ($totalAmt > Number(jQuery('#txtNetAmount').val())) {
                toast("Error", "Paid Amount can't Greater then Total Amount", "");
                jQuery('#txtOutstandingAmt').val('0');
                return false;
            }
            if (parseFloat(parseFloat(parseFloat(jQuery('#txtOutstandingAmt').val() / jQuery('#txtNetAmount').val()) * 100) > parseFloat(jQuery('#ddlOutstandingEmployee').val().split('#')[2]))) {
                toast("Error", "".concat("Max Outstanding Bill Percent is ", jQuery('#ddlOutstandingEmployee').val().split('#')[2]), "");
                jQuery('#txtOutstandingAmt').focus();
                return false;
            }
        };
    </script>
     <script type="text/javascript">
         $confirmationBox = function (contentMsg, type) {
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
                             $confirmationAction(type);
                         }
                     },
                     somethingElse: {
                         text: 'No',
                         action: function () {
                             $clearAction(type);
                         }
                     },
                 }
             });
         }
         $confirmationAction = function ($type) {
             if ($type == 0) {
                 $itemwisedic = 0;
                 jQuery('#tb_ItemList #txtItemWiseDiscount').each(function () { jQuery(this).val('0'); jQuery(this).closest('tr').find("#txtNetAmt").val(jQuery(this).closest('tr').find("#tdRate").text()) });
                 $updatePaymentAmount();
                 $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
                 $addRequiredClass();
             }
             else if ($type == 1) {
                 $itemwisedic = 0;
                 jQuery('#txtDiscountAmount,#txtDiscountPerCent').val('0');
                 $updatePaymentAmount();
                 $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
                 $addRequiredClass();
             }
         }
         $clearAction = function (type) {

         }
         function onKeyDown(e) {
             if (e && e.keyCode == Sys.UI.Key.esc) {
                 if (jQuery('#divAddReferDoctor').is(':visible')) {
                     jQuery('#divAddReferDoctor').hideModel();
                 }
                 else if (jQuery('#oldPatientModel').is(':visible')) {
                     $closeOldPatientSearchModel();
                 }

                 else if (jQuery('#divRequiredField').is(':visible')) {
                     $closeRequiredFieldsModel();
                 }
                 else if (jQuery('#divViewRemarks').is(':visible')) {
                     $closeViewRemarksModel();
                 }
                 else if (jQuery('#camViewer').is(':visible')) {
                     $closeCamViewerModel();
                 }
                 else if (jQuery('#divDocumentMaters').is(':visible')) {
                     $closePatientDocumentModel();
                 }
                 else if (jQuery('#divDocumentMaualMaters').is(':visible')) {
                     $closePatientManualDocModel();
                 }
                 else if (jQuery('#divScanViewer').is(':visible')) {
                     jQuery('#divScanViewer').hideModel();
                 }
                 else if (jQuery('#divDocumentCapture').is(':visible')) {
                     $closeDocumentCapture();
                 }
                 else if (jQuery('.divSuggestedTest').is(':visible')) {
                     $hideSuggestedTest();
                 }
                 else if (jQuery('.divPromotionalTest').is(':visible')) {
                     $hidePromotionalTest();
                 }
                 else if (jQuery('.divRecommendedPackage').is(':visible')) {
                     $hideRecommendedPackage();
                 }
                 else if (jQuery('#divReferDoc').is(':visible')) {
                     jQuery('#divReferDoc').hideModel();
                 }
                 else if (jQuery('#divPrePrintedBarcode').is(':visible')) {
                     $closePrePrintedBarcodeModel();
                 }
             }
         }
         pageLoad = function (sender, args) {
             if (!args.get_isPartialLoad()) {
                 $addHandler(document, "keydown", onKeyDown);
             }
         }
           </script>
    <script type="text/javascript">
        $dispatchMode = function () {
            jQuery('#txtEmail,#txtPinCode,#txtPAddress').removeClass('requiredField');
            if ($("#ddlDispatchMode").val() == "1") {
                jQuery('#txtEmail').addClass('requiredField');
            }
           else if ($("#ddlDispatchMode").val() == "3") {
               jQuery('#txtPinCode,#txtPAddress').addClass('requiredField');
            }
            
        }
        $IdentityType = function () {
            if (jQuery("#ddlIdentityType").val() != "0") {
                jQuery("#txtIdProofNo").removeAttr('disabled');
            }
            else {
                jQuery("#txtIdProofNo").val('').attr('disabled', 'disabled');
            }
            if (jQuery("#ddlIdentityType option:selected").data("type") == "AadhaarCard") {
                $("#txtIdProofNo").attr('maxlength', '16').change();
            }
            else if (jQuery("#ddlIdentityType option:selected").data("type") == "PanCardNo") {
                $("#txtIdProofNo").attr('maxlength', '10').change();
            }
            else {
                $("#txtIdProofNo").attr('maxlength', '20').change();
            }
        };
        $IdProofNo = function () {
            if (jQuery("#ddlIdentityType option:selected").data("type") == "AadhaarCard") {
                $aadhaarCardValidation();
            }
            else if (jQuery("#ddlIdentityType option:selected").data("type") == "PanCardNo") {
                $panCardValidation();
            }
        };
        $IdProofValidate = function (e) {
            var key = (e.keyCode ? e.keyCode : e.charCode);
            var valid = key >= 65 && key <= 90 || // A-Z
               key >= 97 && key <= 122 || key == 45 ||// a-z
                key >= 47 && key <= 57; // 0-9
            if (!valid) {
                e.preventDefault();
            }
        }
        $panCardValidation = function () {
            if (jQuery("#ddlIdentityType option:selected").data("type") == "PanCardNo") {
                if (jQuery.trim(jQuery('#txtIdProofNo').val().length) < 10) {
                    toast("Error", "Please Enter 10 digits for a Valid Pan No.", "");
                    jQuery('#txtIdProofNo').focus();
                    return false;
                }
                var regExp = /[a-zA-z]{5}\d{4}[a-zA-Z]{1}/;
                if (!jQuery.trim(jQuery('#txtIdProofNo').val()).match(regExp)) {
                    toast("Error", "Please Enter Valid Pan No.", "");
                    jQuery('#txtIdProofNo').focus();
                    return false;
                }
            }
        }
        $aadhaarCardValidation = function () {
            var aadhar =jQuery("#txtIdProofNo").val();
            var adharTwelveDigit = /^\d{12}$/;
            var adharSixteenDigit = /^\d{16}$/;
            if (jQuery("#txtIdProofNo").val() != '') {
                if (aadhar.match(adharTwelveDigit)) {                   
                    return true;
                }            
                else if (aadhar.match(adharSixteenDigit)) {                    
                     return true;
                }
                else
                {
                    toast("Error", "Please Enter Valid Aadhaar Card", "");
                    jQuery('#txtIdProofNo').focus();
                }
            
            }
            
        }
        $passportValidation = function () {
            var patt = new RegExp("^([A-Z a-z]){1}([0-9]){7}$")
            if (!patt.test(jQuery("#txtIdProofNo").val())) {
                toast("Error", "Please Enter Valid Passport No.", "");
                jQuery('#txtIdProofNo').focus();
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        var _$refDocPageSize = 20;
        var _$refDocPageNo = 0;
        $bindAllReferDoctor = function (pageNo) {

            if (!jQuery('#divReferDoc').is(':visible'))
                jQuery('#divReferDoc').showModel();

            if (pageNo == "")
                _$refDocPageNo = 0;
            else
                _$refDocPageNo = pageNo;
            $('#tblRefDocDetail tr').slice(2).remove();
            $('#refDocPageDiv').html('');
            serverCall('Lab_PrescriptionOPD.aspx/bindReferDoctor', { centreID: jQuery('#ddlCentre option:selected').val().split('#')[0], PageNo: _$refDocPageNo, PageSize: _$refDocPageSize }, function (response) {
                var $referDoctorData = JSON.parse(response);
                if ($referDoctorData.length == 0) {
                    return;
                }
                else {
                    for (var i = 0; i <= $referDoctorData.length - 1; i++) {
                        if (pageNo == "") {
                            _$refDocPageNo = $referDoctorData[0].TotalRecord / _$refDocPageSize;
                        }
                        var $myData = [];
                        $myData.push("<tr id='"); $myData.push($referDoctorData[i].Doctor_ID); $myData.push("'>");
                        if (pageNo == "") {
                            $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + pageNo * _$refDocPageSize + 1)); $myData.push('</td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle" data-input="name1">'); $myData.push($referDoctorData[i].DocName.trim()); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" data-input="lastname">'); $myData.push($referDoctorData[i].Mobile.trim()); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" data-input="Specialization"> '); $myData.push($referDoctorData[i].Specialization.trim()); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" data-input="Degree">'); $myData.push($referDoctorData[i].Degree.trim()); $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        jQuery("#tblRefDocDetail tbody").append($myData);
                    }
                    if (pageNo == "") {
                        var $myVal = [];
                        if (_$refDocPageNo > 1 && _$refDocPageNo < 20) {
                            for (var j = 0; j < _$refDocPageNo; j++) {
                                var $refDocSNo = parseInt(j) + 1;
                                $myVal.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="$refDocPageDetail(\''); $myVal.push(j); $myVal.push('\');"  >'); $myVal.push($refDocSNo); $myVal.push('</a>');
                            }
                        }
                        else if (_$refDocPageNo > 20) {
                            for (var j = 0; j < 20; j++) {
                                var $refDocSNo = parseInt(j) + 1;
                                $myVal.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="$refDocPageDetail(\''); $myVal.push(j); $myVal.push('\');"  >'); $myVal.push($refDocSNo); $myVal.push('</a>');
                            }
                            $myVal.push('&nbsp;&nbsp;<select onchange="$showNextRecord(this)" id="ddlDocPage">');
                            $myVal.push('<option value="Select">Select Page</option>');
                            for (var j = 20; j < _$refDocPageNo; j++) {
                                var $refDocSNo = parseInt(j) + 1;
                                $myVal.push('<option value="'); $myVal.push(j); $myVal.push('">'); $myVal.push($refDocSNo); $myVal.push('</option>');
                            }
                            $myVal.push("</select>");
                        }
                        $myVal = $myVal.join("");
                        $('#refDocPageDiv').append($myVal);
                        $('#refDocPageDiv').show();
                    }
                }
            });
        }
        $refDocPageDetail = function (pageNo) {
            $bindAllReferDoctor(pageNo);
        }
        $showNextRecord = function ($docPageNo) {
            $bindAllReferDoctor($docPageNo.value);
        }
        $searchModelRefDoc = function ($docName, $docPageNo, $table) {
            dehighlight(document.getElementById($table));
            var filter = $docName.value.toUpperCase();
            var tr = document.getElementById("tblRefDocDetail").getElementsByTagName("tr");
            for (var i = 0; i < tr.length; i++) {
                var td = tr[i].getElementsByTagName("td")[$docPageNo];
                if (td) {
                    var txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                        highlight($docName.value.toLowerCase(), document.getElementById($table));
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
        function dehighlight(container) {
            for (var i = 0; i < container.childNodes.length; i++) {
                var node = container.childNodes[i];
                if (node.attributes && node.attributes['class']
        && node.attributes['class'].value == 'highlighted') {
                    node.parentNode.parentNode.replaceChild(
        document.createTextNode(
        node.parentNode.innerHTML.replace(/<[^>]+>/g, "")),
        node.parentNode);
                    // Stop here and process next parent
                    return;
                } else if (node.nodeType != 3) {
                    // Keep going onto other elements
                    dehighlight(node);
                }
            }
        }
        function highlight(Stxt, container) {
            for (var i = 0; i < container.childNodes.length; i++) {
                var node = container.childNodes[i];
                if (node.nodeType == 3) {
                    // Text node
                    var data = node.data;
                    var data_low = data.toLowerCase();
                    if (data_low.indexOf(Stxt) >= 0) {
                        //Stxt found!
                        var new_node = document.createElement('span');
                        node.parentNode.replaceChild(new_node, node);
                        var result;
                        while ((result = data_low.indexOf(Stxt)) != -1) {
                            new_node.appendChild(document.createTextNode(
        data.substr(0, result)));
                            new_node.appendChild(create_node(
        document.createTextNode(data.substr(
        result, Stxt.length))));
                            data = data.substr(result + Stxt.length);
                            data_low = data_low.substr(result + Stxt.length);
                        }
                        new_node.appendChild(document.createTextNode(data));
                    }
                } else {
                    // Keep going onto other elements
                    highlight(Stxt, node);
                }
            }
        }
        function create_node(child) {
            var node = document.createElement('span');
            node.setAttribute('class', 'highlighted');
            node.attributes['class'].value = 'highlighted';
            node.appendChild(child);
            return node;
        }
    </script>

    <script type="text/javascript">

        //jQuery(function () {
        //    $("#txtMemberShipCardNo").keydown(
        //           function (e) {
        //               var key = (e.keyCode ? e.keyCode : e.charCode);
        //               if (key == 13) {
        //                   e.preventDefault();
        //                   var $field = $(this);
        //                   if ($field.val() != "") {
        //                       bindmembershipcarddata($field.val());
        //                   }
        //               }
        //           });
        //});

        function bindmembershipcarddata(membershipcardno) {
            serverCall('Lab_PrescriptionOPD.aspx/bindmembershipcarddata', { cardno: membershipcardno }, function (response) {
                var $memberdata = JSON.parse(response);
                if ($memberdata.length == 0) {
                    toast('Info', 'No Record Found', '');
                    return;
                }
                else {
                    for (var i = 0; i < $memberdata.length ; i++) {
                        var $memberdatatr = [];
                        $memberdatatr.push('<tr  class="GridViewItemStyle">');
                        $memberdatatr.push('<td>' + parseInt(i + 1) + '</td>');
                        $memberdatatr.push('<td ><input type="button" value="Select" onclick="setmemberdata(this)"/></td>');
                        $memberdatatr.push('<td id="cardno">' + $memberdata[i].cardno + '</td>');
                        $memberdatatr.push('<td id="Mobile">' + $memberdata[i].Mobile + '</td>');
                        $memberdatatr.push('<td id="patient_id">' + $memberdata[i].patient_id + '</td>');
                        $memberdatatr.push('<td>' + $memberdata[i].Title + $memberdata[i].PName + '</td>');
                        $memberdatatr.push('<td>' + $memberdata[i].age + '</td>');
                        $memberdatatr.push('<td id="Gender">' + $memberdata[i].Gender + '</td>');
                        $memberdatatr.push('<td>' + $memberdata[i].Relation + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="Title">' + $memberdata[i].Title + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="PName">' + $memberdata[i].PName + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="AgeYear">' + $memberdata[i].AgeYear + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="AgeMonth">' + $memberdata[i].AgeMonth + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="AgeDays">' + $memberdata[i].AgeDays + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="DOB">' + $memberdata[i].dob + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="Email">' + $memberdata[i].email + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="Pincode">' + $memberdata[i].PinCode + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="tdPatientAdvance">0</td>');
                        $memberdatatr.push('<td style="display:none;" id="ClinicalHistory">' + $memberdata[i].ClinicalHistory + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="CountryID">' + $memberdata[i].CountryID + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="StateID">' + $memberdata[i].StateID + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="CityID">' + $memberdata[i].CityID + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="LocalityID">' + $memberdata[i].LocalityID + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="dtEntry">' + $memberdata[i].dtEntry + '</td>');
                        $memberdatatr.push('<td style="display:none;" id="MembershipCardID">' + $memberdata[i].MembershipCardID + '</td>');
                        $memberdatatr.push('</tr>');
                        $memberdatatr = $memberdatatr.join("");
                        $('#tblmembership').append($memberdatatr);

                    }
                    jQuery('#divmembershipcard').showModel();
                }
            });
        }

        $closeMembsershipcardSearchModel = function () {
            jQuery('#divmembershipcard').hideModel();
            $('#tblmembership tr').slice(1).remove();
        }
        $closeInvestigationlistModel = function () {
            jQuery('#divInvestigationlist').hideModel();
        }

        var setmemberdata = function (elem) {
            jQuery("#txtMemberShipCardNo").val(jQuery(elem).closest('tr').find('#cardno').text()).attr('disabled', 'disabled');
            jQuery("#spnMembershipCardNo").text(jQuery(elem).closest('tr').find('#cardno').text());
            jQuery("#spnMembershipCardID").text(jQuery(elem).closest('tr').find('#MembershipCardID').text());
            jQuery("#spnIsSelfPatient").text(jQuery(elem).closest('tr').find('#tdFamilyMemberIsPrimary').text());
            jQuery("#txtMobileNo").val(jQuery(elem).closest('tr').find('#Mobile').text()).attr('disabled', 'disabled');
            jQuery(jQuery('#ddlTitle option').filter(function () { return this.text == jQuery(elem).closest('tr').find('#Title').text() })[0]).prop('selected', true).attr('disabled', 'disabled');
            $onTitleChange(jQuery('#ddlTitle').val());
            jQuery("#ddlGender").val(jQuery(elem).closest('tr').find('#Gender').text()).attr('disabled', 'disabled');
            jQuery("#txtPName").val(jQuery(elem).closest('tr').find('#PName').text()).attr('disabled', 'disabled');
            jQuery("#txtDOB").val(jQuery(elem).closest('tr').find('#DOB').text());
            jQuery("#txtUHIDNo").val(jQuery(elem).closest('tr').find('#patient_id').text()).attr('disabled', 'disabled');
            var txtPID = jQuery('#txtUHIDNo').val(jQuery(elem).closest('tr').find('#patient_id').text()).attr('patientAdvanceAmount', jQuery(elem).closest('tr').find('#tdPatientAdvance').text());
            if (!String.isNullOrEmpty(jQuery(elem).closest('tr').find('#patient_id').text()))
                jQuery(txtPID).change();
            jQuery("#spnUHIDNo").text(jQuery(elem).closest('tr').find('#patient_id').text());
            jQuery("#txtAge").val(jQuery(elem).closest('tr').find('#AgeYear').text());
            jQuery("#txtAge1").val(jQuery(elem).closest('tr').find('#AgeMonth').text());
            jQuery("#txtAge2").val(jQuery(elem).closest('tr').find('#AgeDays').text());
            jQuery("#txtEmail").val(jQuery(elem).closest('tr').find('#Email').text());
            jQuery("#txtPinCode").val(jQuery(elem).closest('tr').find('#Pincode').text());
            jQuery("#txtClinicalHistory").val(jQuery(elem).closest('tr').find('#ClinicalHistory').text());
            jQuery('#ddlTitle,#txtPreBookingNo').attr('disabled', 'disabled');

            if (jQuery(elem).closest('tr').find('#CountryID').text() != "0") {
                jQuery('#ddlCountry').val(jQuery(elem).closest('tr').find('#tdCountryID').text()).chosen('destroy').chosen();
            }
            if (jQuery(elem).closest('tr').find('#StateID').text() != "0") {
                $bindState(jQuery(elem).closest('tr').find('#CountryID').text(), "1", function (selectedStateID) {
                    jQuery('#ddlState').val(jQuery(elem).closest('tr').find('#StateID').text()).chosen('destroy').chosen();
                    if (jQuery(elem).closest('tr').find('#CityID').text() != "0") {

                        $bindCity(jQuery(elem).closest('tr').find('#StateID').text(), "1", function (selectedCityID) {
                            jQuery('#ddlCity').val(jQuery(elem).closest('tr').find('#CityID').text()).chosen('destroy').chosen();
                            if (jQuery(elem).closest('tr').find('#LocalityID').text() != "0") {
                                $bindLocality(jQuery(elem).closest('tr').find('#CityID').text(), "1", function () {
                                    jQuery('#ddlArea').val(jQuery(elem).closest('tr').find('#LocalityID').text()).chosen('destroy').chosen();
                                });
                            }
                        });
                    }
                });
            }

            $searchPatientImage({ PatientID: jQuery.trim(jQuery(elem).closest('tr').find('#patient_id').text()), dtEntry: jQuery.trim(jQuery(elem).closest('tr').find('#dtEntry').text()) }, function (response) {
                if (!String.isNullOrEmpty(response.Item1)) {
                    jQuery('#imgPatient').attr('src', response.Item1);
                }
                else
                    jQuery('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
                if (!String.isNullOrEmpty(response.Item2)) {
                    jQuery('#spnDocumentCounts').text(response.Item2);
                }
            });
            jQuery("#tblMaualDocument tr").slice(1).remove();
            $bindPatientDocumnet(jQuery.trim(jQuery(elem).closest('tr').find('#patient_id').text()), function () { });

            $bindSuggestedTest(jQuery.trim(jQuery(elem).closest('tr').find('#patient_id').text()), function () { });
            jQuery('#divmembershipcard').hideModel();
            $('#tblmembership tr').slice(1).remove();

            $('#txtDiscountReason').val('Membershipcard Discount');
            jQuery('#ddlApprovedBy,#txtDiscountReason').addClass('requiredField');
        }


        function setcopaymentper(ctrl) {
            if ($(ctrl).val() == "") {
                $(ctrl).val('0');
            }
            if (Number($(ctrl).val()) > 100) {
                $(ctrl).val('100');
            }
            var total = parseInt($(ctrl).closest('tr').find('#txtNetAmt').val());

            var coper = parseInt($(ctrl).val());
            var coperamt = Math.round(parseFloat(total * coper * 0.01));
            $(ctrl).closest('tr').find('#txtPayByPanel').val(coperamt) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));
            $(ctrl).closest('tr').find('#txtPayByPatient').val(total - coperamt) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));

            $updatePaymentAmount();
            $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });

        }

        function setcopaymentamount(ctrl) {
            if ($(ctrl).val() == "") {
                $(ctrl).val('0');
            }
            var total = parseInt($(ctrl).closest('tr').find('#txtNetAmt').val());
            if (Number($(ctrl).val()) > total) {
                $(ctrl).val(total);
            }
            var coamt = Number($(ctrl).closest('tr').find('#txtPayByPanel').val())
            $(ctrl).closest('tr').find('#txtPayByPanelPer').val(Math.round(parseFloat((coamt * 100) / total))) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));

            $(ctrl).closest('tr').find('#txtPayByPatient').val(total - coamt) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));

            $updatePaymentAmount();
            $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });

        }
        function setd() {
            var d = new Date();
            var m_names = new Array("Jan", "Feb", "Mar","Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            return xxx;
        }
        function getWeeksDay(d) {
            var week = Math.floor(d / 7);
            var day = Math.floor(d % 7);
            return week + ' Weeks and ' + day + ' Days';
        }
        function LeftFrom_10Week(d) {
            var week = Math.floor(d / 7);
            return (10 - week);
        }
        //sunil
        function GetUrgentTAT(ctrl) {
           
            var $InvID = $(ctrl).closest('tr').attr('id');
            var $Olddeliverydate = jQuery(ctrl).closest('tr').find('#tdDeliveryDateold').html();
            var $CentreID = jQuery("#ddlCentre").val().split('#')[0];
            var $Isurgent = jQuery(ctrl).closest('tr').find('#chkIsUrgent').is(':checked') ? 1 : 0;
            if ($Isurgent == 1) {
                serverCall('../Lab/Services/LabBooking.asmx/geturgentTAT', { InvID: $InvID, CentreID: $CentreID, Isurgent: $Isurgent }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        jQuery(ctrl).closest('tr').find('#tddeliverydate_show').html($responseData.response); 
                        jQuery(ctrl).closest('tr').find('#tdDeliveryDate').html($responseData.response);
                    }
                });
            }
            else {
                jQuery(ctrl).closest('tr').find('#tddeliverydate_show').html($Olddeliverydate);
                jQuery(ctrl).closest('tr').find('#tdDeliveryDate').html($Olddeliverydate);
            }

        }
        function getqnty(ctrl) {
            if ($(ctrl).closest('tr').find('#tdIsMemberShipFreeTest').html() > 0 && (parseInt($(ctrl).val()) > parseInt($(ctrl).closest('tr').find('#tdFreeTestQuantity').html()))) {
                toast('Error', "".concat('Maximum Free test quantiy is :', parseInt($(ctrl).closest('tr').find('#tdFreeTestQuantity').html())), '');
                return;
            }
            var $oldnetamt = $(ctrl).closest('tr').find('#tdoldAmount').html();
            $(ctrl).closest('tr').find('#txtItemWiseDiscount').val(0);
            if ($(ctrl).val() == 0 || $(ctrl).val() == '') {
                $(ctrl).closest('tr').find('#txtNetAmt').val($oldnetamt);
            }
            else {
                var $qnty = parseInt($(ctrl).val());
                var $netqntyamt = Number(parseFloat($oldnetamt * $qnty));
                $(ctrl).closest('tr').find('#txtNetAmt').val($netqntyamt);
            }
            if (jQuery("#ddlPanel").val().split('#')[20] == "1") {
                var total = parseInt($(ctrl).closest('tr').find('#txtNetAmt').val());
                var coper = parseInt($(ctrl).closest('tr').find('#txtPayByPanelPer').val());
                var coperamt = Math.round(parseFloat(total * coper * 0.01));
                $(ctrl).closest('tr').find('#txtPayByPanel').val(coperamt) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));
                $(ctrl).closest('tr').find('#txtPayByPatient').val(total - coperamt) * parseFloat(jQuery.trim(jQuery(ctrl).closest('tr').find("#ddlIsRequiredQty").val()));

            }
            $updatePaymentAmount();
            $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });

        }
        $('#txtUHIDNo,#txtPreBookingNo,#txtPAddress,#txtOtherLabRefNo,#txtClinicalHistory,#txtRemarks').alphanum({
            allow: '/-.'
        });
        $('#txtDiscountReason').alphanum({
            allow: '.',
disallow:'0123456789'
        });
        $('#txtPName').alphanum({
            allow: '.',
        });
    </script>
   
<style  type="text/css">
    progress {
        text-align: center;
        height: 1.5em;
        width: 100%;
        -webkit-appearance: none;
        border: none;
        /* Set the progressbar to relative */
        position: relative;
    }

        progress:before {
            content: attr(data-label);
            font-size: 0.8em;
            vertical-align: 0;
            /*Position text over the progress bar */
            position: absolute;
            left: 0;
            right: 0;
        }

        progress::-webkit-progress-bar {
            background-color: #c9c9c9;
        }

        progress::-webkit-progress-value {
            background-color: #7cc4ff;
        }

        progress::-moz-progress-bar {
            background-color: #7cc4ff;
        }
</style>

</asp:Content>