<%@ Page Language="C#"  ClientIDMode="Static" AutoEventWireup="true" CodeFile="Lab_PrescriptionOPDEdit.aspx.cs" Inherits="Design_Lab_Lab_PrescriptionOPDEdit" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
   
   
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    	<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>	
    <script src="../../Scripts/MarcTooltips.js"></script>	
     <script src="../../Scripts/jquery-ui.js"></script>
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     
    </head><body>
    	
  <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sc1" runat="server">
            <Services>
                <Ajax:ServiceReference Path="Services/LabBooking.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Registration Edit</b>
            <span id="spnError"></span>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
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

                              <input type="text" id="txtLabNo" class="requiredField" maxlength="15" data-title="Enter Lab No. (Press Enter To Search)" onkeyup="$searchOnEnter(event);"/>

                              </div>

                        <div class="col-md-3">
                          <input type="button"  id="btnSearch" class="ItDoseButton" value="Search" onclick="$searchData(this);" />
                           
                        </div>
                          <div class="col-md-7">
                              &nbsp;
                              </div>
                        </div>
                 </div>
         </div>
            
        <div class="POuter_Box_Inventory" style="text-align: center">
    <div id="PatientDetails">
		<div  class="Purchaseheader">
			Patient Details		
		</div>	 
		 <div class="row">
		 <div class="col-md-21">					     
	     <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Mobile No.</label>
			  <b class="pull-right">:</b>
		   </div>		  
		   <div class="col-md-5">
			    <input id="txtMobileNo"  type="text"    disabled="disabled" />                           
		   </div>
		   <div class="col-md-3">
			   <label class="pull-left">UHID</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <input type="text" id="txtUHIDNo"  disabled="disabled"/>
						<span id="spnUHIDNo" style="display:none"></span> 
		   </div>
		   <div class="col-md-3">
               <label class="pull-left">PreBooking&nbsp;No.</label>
			 
		   </div>
		   <div class="col-md-5">	
             		 <input type="text" id="txtPreBookingNo" disabled="disabled" />				 
				
               
		   </div>	 
	  </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left"> Patient Name  </label>
			  <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-2">
               <select id="ddlTitle" ></select>
						
		   </div>
		  <div  class="col-md-3 ">
			  <input type="text" id="txtPName"   autocomplete="off"  style="text-transform:uppercase"  disabled="disabled" />
		   </div>

		   <div class="col-md-3">
			   <label class="pull-left">Age  <asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setdobop1(this)" GroupName="rdDOB" /></label>
			   <b class="pull-right">:</b>
		   </div>
		   
  <div class="col-md-5">		
                     <input type="text" id="txtAge" style="width:33%;float:left" onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();"      max-value="120"  autocomplete="off"  maxlength="3" data-title="Enter Age"   placeholder="Years"/>          
                     <input type="text" id="txtAge1" style="width:33%;float:left" onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();"     max-value="12"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Months"/>                      
                     <input type="text" id="txtAge2" style="width:33%;float:left"  onlynumber="5" onkeyup="clearDateOfBirth(event);getdob();"    max-value="30"  autocomplete="off"  maxlength="2" data-title="Enter Age"   placeholder="Days"/>							         
      </div>
		   <div class="col-md-3"><label class="pull-left">DOB<asp:RadioButton ID="rdDOB" runat="server" GroupName="rdDOB" onclick="setdobop(this)" /></label>
			   <b class="pull-right">:</b>
		   </div>                 
		   <div class="col-md-5">
						<asp:TextBox ID="txtDOB" onclick="getdob()" ReadOnly="true" runat="server" Enabled="false" ClientIDMode="Static"></asp:TextBox>					
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
        <label class="pull-left"> Referred Doctor</label>
			  <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
             <input  type="text"  id="txtReferDoctor" value="SELF"  disabled="disabled"/>
                <input type="hidden" id="hftxtReferDoctor" value="1" />		
              </div>
     <div class="col-md-3">
         <label class="pull-left">Second Ref.</label>
			  <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
            <input  type="text"  id="txtSecondReference" disabled="disabled" value="SELF"/>	
              <input type="hidden" id="hfSecondReference" value="1" />	
              </div>
     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">Address</label>
			  <b class="pull-right">:</b>
		   </div>
		  
		   <div class="col-md-5">
             <input type="text" id="txtPAddress" maxlength="50" disabled="disabled"/>	
               </div>
     <div class="col-md-3">
       <label class="pull-left"> Locality </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
              <select id="ddlArea"  disabled="disabled" ></select>         
              </div>
     <div class="col-md-3">
        <label class="pull-left"> PinCode</label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
              <input type="text"   autocomplete="off"  id="txtPinCode"  disabled="disabled" />        
              </div>
     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">City</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-5">
                <select id="ddlCity"  disabled="disabled" onchange="$onCityChange(this.value)"></select> 
             
               </div>
     <div class="col-md-3">
       <label class="pull-left"> State </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
               <select id="ddlState"  disabled="disabled" onchange="$onStateChange(this.value)"></select>    
                 <input type="hidden" style="display:none" id="txtPanelData" /> 
                 <input type="hidden" style="display:none" id="txtCentreData" />
                 <input type="hidden" style="display:none" id="txtPrescribeDate" />
                 <input type="hidden" style="display:none" id="txtDiscShareType" />   
                 <input type="hidden" id="txtLedgertransactionNo" />    
                 <input type="hidden" id="txtLedgertransactionID" />    
                 <input type="hidden" id="txtMRNo" />   
                 <input type="hidden" id="txtGender" />   
                 <input type="hidden" id="txtPatientType" />   
                 <input type="hidden" id="txtTotalAgeInDays" /> 
                 <input type="hidden" id="hdSampleCollectionOnReg" />    
                 <input type="hidden" id="hdBarCodePrintedType" />  
                 <input type="hidden" id="hdBarCodePrintedCentreType" />  
                 <input type="hidden" id="hdBarCodePrintedHomeColectionType" />  
                 <input type="hidden" id="hdSetOfBarCode" />  
                 <input type="hidden" id="txtmembershipcardid" />
              </div>
     <div class="col-md-3">
        <label class="pull-left"> Source </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
              <select id="ddlSource" disabled="disabled">
                   <option value=""></option>
                   <option value="WalkIn">WalkIn</option>
                   <option value="Website">Website</option>
                   <option value="Leaflet">Leaflet</option>
                   <option value="Newspaper">Newspaper</option>
                   <option value="Referral">Referral</option>                   
               </select>            
              </div>
     </div>
         <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">  ID Proof No.  </label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-2">
               <select id="ddlIdentityType" disabled="disabled">
                   <option value="Secondary Doctor">Secondary Doctor</option>
                   <option value="Aadhaar Card">Aadhaar Card</option>
                   <option value="Card No.">Card No.</option>
                   <option value="DL No.">DL No.</option>
                   <option value="Voter Card">Voter Card</option>
                   <option value="Passport No.">Passport No.</option>
                   <option value="Pan Card No.">Pan Card No.</option>
               </select>              
               </div>
                  <div class="col-md-3">
                      <input type="text" id="txtIdProofNo"  disabled="disabled"/>                    
                      </div>
     <div class="col-md-3">
       <label class="pull-left"> Dispatch Mode </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">
               <select id="ddlDispatchMode" disabled="disabled">
                   <option value="0">Select</option>
                   <option value="1">Email</option>
                   <option value="2">Refer Doctor</option>
                   <option value="3">Courier</option>                                    
               </select>          
              </div>
     <div class="col-md-3">
        <label class="pull-left"> Email </label>
         <b class="pull-right">:</b>
         </div>
          <div class="col-md-5">

               <input type="text"  autocomplete="off"  id="txtEmail"  disabled="disabled" />             
              </div>
     </div>
        <div class="row">
		  <div class="col-md-3">
			   <label class="pull-left">  Visit Type  </label>
			  <b class="pull-right">:</b>
		   </div>
      <div class="col-md-3">
          <select id="ddlVisitType" disabled="disabled" onchange="showHomeCollectionOption()" >
                   <option value="Center Visit">Center Visit</option>
                   <option value="Home Collection">Home Collection</option>               
               </select>   
	   </div>
      <div class="col-md-2">
          <input type="checkbox" id="chkIsVip" name="chkIsVip" disabled="disabled" />VIP
          
          </div>
       <div class="col-md-3 divFieldBoy" style="display:none" >
            <label class="pull-left">  FieldBoy  </label>
			  <b class="pull-right">:</b>
            </div>
      <div class="col-md-5 divFieldBoy" style="display:none">
              <select id="ddlFieldBoy" disabled="disabled" ></select>
           </div>
            <div class="col-md-3 divFieldBoy" style="display:none">
                  <label class="pull-left"> Coll. Date Time </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-3 divFieldBoy" style="display:none">
                <input type="text" id="txtCollectionDate" class="setCollectionDate" maxlength="100" data-title="Enter Sample Collection Date"/>    
               </div>
             <div class="col-md-2 divFieldBoy" style="display:none">
                  <asp:TextBox ID="txtCollectionTime" runat="server" data-title="Enter Sample Collection Time"></asp:TextBox>                                  
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" Enabled="True" AutoComplete="true" 
    TargetControlID="txtCollectionTime"  AcceptAMPM="True"></cc1:MaskedEditExtender>
<cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtCollectionTime"  ControlExtender="masTime" IsValidEmpty="false" InvalidValueMessage=""  ></cc1:MaskedEditValidator>                 
               </div>            
 </div>
	  <div class="row">
             <div class="col-md-3">
			   <label class="pull-left">Other Ref. No.   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			   	  <input type="text" id="txtOtherLabRefNo"  disabled="disabled"/>
		   </div>
          
             <div class="col-md-3">
			   <label class="pull-left">Clinical History</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
             
				<input type="text" id="txtClinicalHistory"  disabled="disabled"/>		 
		   </div>
           <div class="col-md-3">
                  <label class="pull-left"> Remarks </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtRemarks" disabled="disabled"/>    
               </div>
             </div>
           <div class="row" style="display:none" id="divPUPDetail">
             <div class="col-md-3">
			   <label class="pull-left">PUP Ref No.    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			   <input  type="text"  id="txtPUPRefNo"  />			 
		   </div>
             <div class="col-md-3">
			   <label class="pull-left">PUP Contact   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">			 
			 <input  type="text"  id="txtPUPContact"  />
		   </div>
     <div class="col-md-3">
			   <label class="pull-left">PUP Mobile   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">			  
			 <input  type="text"  id="txtPUPMobile" maxlength="10"  />
		   </div>
             </div>
           <div class="row" style="display:none" id="divHLMDetail">
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
			   <label class="pull-left">OPD/IPD No.   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <input type="text" maxlength="10" id="txtHLMOPDIPNo" />			 
		   </div>
     <div class="col-md-3">
			   <label class="pull-left">   </label>			   
		   </div>
		   <div class="col-md-5">			  			 
		   </div>
             </div>
           <div class="row divCorporate" style="display:none" >
             <div class="col-md-3">
			   <label class="pull-left">ID Type   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <select id="ddlCorporateIDType" >                
                   <option value="ID Card">ID Card</option>
                   <option value="Letter">Letter</option>                  
               </select>			 			 
		   </div>
             <div class="col-md-3">
			   <label class="pull-left">ID Card</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <input type="text" maxlength="50" id="txtCorporateIDCard" />		 
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
               <select id="ddlCardHolderRelation" class="requiredField" data-title="Relation With Card Holder Name" onchange="CardHolderRelation()"></select>
               </div>    
	  </div> 

             <div class="row">
                 <div class="col-md-3">
                  <label class="pull-left"> SRFNo </label>
			  <b class="pull-right">:</b>
                 </div>
          <div class="col-md-5">
                <input type="text" id="txtSRFNumber" disabled="disabled"/>    
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
             	<div class="row">
				 <div class="col-md-24">
                     <span id="spnFileName"  style="display:none"></span>
					 <button onclick="showDocumentMaster()" id="btnDocumentMaster" type="button" style="width:100%" ><span id="spnDocumentCounts"  class="badge badge-grey">0</span><b>Printer Upload</b> </button>					
				 </div>
			 </div>
			 	<div class="row">
				 <div class="col-md-24">
                     
					 <button onclick="showManualDocumentMaster()" id="btnMaualDocument" type="button" style="width:100%" ><span id="spnDocumentMaualCounts"  class="badge badge-grey">0</span><b>Manual Upload</b> </button>					
				 </div>
			 </div>		 			  
		 </div>	
	 </div>         
</div>	
        </div>
        <div class="POuter_Box_Inventory clDisplay" style="display:none">
            <div class="row" style="margin-top: 0px;">
                <div class="col-md-8">
                    <div class="row">
						<div style="padding-right: 0px;" class="col-md-18">
							<label class="pull-left">                               
								<input id="rdbItem_1" type="radio" name="labItems" value="1" onclick="$clearItem(function () { })" checked="checked"  />
								<label for="rdbItem_1">By Name</label>
								<input id="rdbItem_0" type="radio" name="labItems" value="0" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_0">By Code </label>
								<input id="rdbItem_2" type="radio" name="labItems" value="2" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_2">InBetween</label>								
							</label>
						</div>		
                        <div class="col-md-6">
								<button style="width: 100%; padding: 0px;border-radius:4px;" class="label label-important" type="button"><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;">Count : 0</span></button>
						</div>					                           												
					</div>
                    <div class="row">						
						<div style="padding-left: 15px;" class="col-md-24">
							<input type="text" id="txtInvestigationSearch" title="Enter Search Text" autocomplete="off" />
						</div>					
					</div>
                    </div>
                <div class="col-md-16">
					<div style=" height: 125px; overflow-y: auto; overflow-x: hidden;">
						<table id="tb_ItemList" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
							<thead>
								<tr id="LabHeader">
									<th class="GridViewHeaderStyle" scope="col" style="">Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Item</th>
									<th class="GridViewHeaderStyle" scope="col" style="">View</th> 
                                    <th class="GridViewHeaderStyle" scope="col" style="">Dos</th>  
                                    <th class="GridViewHeaderStyle" scope="col" style="">MRP</th>                              
                                    <th class="GridViewHeaderStyle" scope="col" style="">Rate</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Qty</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Disc.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Amt.</th>
									<th class="GridViewHeaderStyle" scope="col" style="">Delivery Date</th>                                  
									<th class="GridViewHeaderStyle clSampleCollection" scope="col" style="display:none">Sam.Coll.</th>
									<th class="GridViewHeaderStyle" scope="col" style="">IsUrgent</th>
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
         <div class="POuter_Box_Inventory clDisplay" style="display:none">
             <div class="col-md-15 ">
                  <div class="col-md-5 clpaybypatient">
				   <label class="pull-left">Payby Patient</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3 clpaybypatient">
                    <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtpaybypatientfinal" type="text"  autocomplete="off" />
				</div>
                     <div class="col-md-5 clpaybypanel">
				   <label class="pull-left">Payby Panel</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3 clpaybypanel">
                    <input disabled="disabled" class="ItDoseTextinputNum" style="font-weight:Bold" value="0" id="txtpaybypanelfinal" type="text"  autocomplete="off" />
				</div>
                 </div>
                 <div class="col-md-9">                                        
			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Gross Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				   <input disabled="disabled" id="txtGrossAmount" class="ItDoseTextinputNum"  value="0" autocomplete="off"  type="text"  />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Net Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
						<input disabled="disabled" class="ItDoseTextinputNum"  value="0" id="txtNetAmount"  type="text" autocomplete="off"  />
				</div>
			</div>				
			<div class="row" style="display:none">
				<div class="col-md-7">
				   <label class="pull-left">Paid Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
                    <input disabled="disabled" class="ItDoseTextinputNum" value="0" id="txtPaidAmount" type="text"  autocomplete="off" />
				</div>
				<div class="col-md-7">
				   Balance Amount
                    <b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					  <input  type="text" class="ItDoseTextinputNum"  value="0"  id="txtBlanceAmount" autocomplete="off" disabled="disabled"  />
				</div>
			</div>			
		</div>
             </div>
         <div class="POuter_Box_Inventory clDisplay" style="text-align: center;display:none">
             <span id="spnSavingType" style="display:none">0</span>
			 <input type="button" value="Required Fields" class="ItDoseButton" onclick="$requiredFields(this)" />
			<input type="button" style="margin-top:7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$updateLabPrescription(this, $(this).val());" />
            <input type="button" style="margin-top:7px" value="Cancel" onclick="$clearForm()" class="resetbutton" />
		</div>
    
    <div id="divViewRemarks" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 400px;max-width:40%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeViewRemarksModel()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Remarks Detail</h4>
			</div>
            <div class="modal-body">			
                     <div id="divPopUPRemarks" >
                         </div>               
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="$closeViewRemarksModel()">Close</button>
			</div>                  
        </div>
 </div>
         </div>
        <div id="divPrePrintedBarcode" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 800px;max-width:72%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closePrePrintedBarcodeModel()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Sample Type And Barcode</h4>
			</div>
            <div class="modal-body">			
                     <div style="height:200px"  class="row">
					<div id="divPrePrintedBarcodeData" class="col-md-24">
                        <table id="tb_SampleList" style="width: 99%; border-collapse: collapse" class="GridViewStyle">
				            <tr id="trSampleHeader">
					        <td class="GridViewHeaderStyle" >#</td>
					        <td class="GridViewHeaderStyle" >Test Name</td>
					        <td class="GridViewHeaderStyle" >Sample Type</td>
					        <td class="GridViewHeaderStyle">
						    <input type="text" id="txtAllBarCode" style="display:none" name="myBarCode" onkeyup="setBarCodeToall(this)" placeholder="Barcode For All" /></td>
					        <td class="GridViewHeaderStyle" >SNR</td>
				</tr>
			</table>
                        </div>					
				</div>
                <div style="text-align:center" class="row">
			    <input type="button" value="Save" class="savebutton" onclick="$updateLabData(this);" id="btnFinalSave" />
			    <input type="button" id="btnSkipSave" value="Skip & Save" onclick="$updateLabData(this);" class="savebutton" />
				</div>
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="$closePrePrintedBarcodeModel()">Close</button>
			</div>                  
        </div>
 </div>
         </div>

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

        <div id="divDocumentMaualMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 760px; height: 300px">
			<div class="modal-header">
				<button type="button" class="close" onclick="divDocumentMaualCloseModel()" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Patient Documents Master</h4>
			</div>
			<div class="modal-body">
				<table style="width: 100%;">
					<tr>
						<td style="width:140px">
							Document Type :&nbsp;
						</td>
                        <td>
                            <select id="ddlDocumentType" style="width:360px" class="requiredField"></select>
                        </td>
						<td>
                            &nbsp;
						</td>
					</tr>
                    <tr>
                        <td style="width:140px">
							Select File :&nbsp;
						</td>
                            <td >
                            <input type="file" id="fileManualUpload" /> 
						
                        </td>
                        <td>
                            <input type="button" id="btnMaualUpload" value="Upload Files" onclick="saveMaualDocument()" /> 
                        </td>
                    </tr>
                    <tr><td colspan="2"><em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em></td></tr>
				                    <tr><td colspan="2"><em><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 10 MB.</span></em></td></tr>

                </table>
                <div id="divManualUpload" style="overflow:auto">							  
							</div>               
                            <table id="tblMaualDocument" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="trManualDocument">
                                    <th class="GridViewHeaderStyle" style="width:40px">&nbsp;</th>	
					                <th class="GridViewHeaderStyle" style="width:140px">Document Type</th>	
                                    <th class="GridViewHeaderStyle" style="width:280px">Document Name</th>	
                                    <th class="GridViewHeaderStyle" style="width:180px">Uploaded By</th>
                                    <th class="GridViewHeaderStyle" style="width:100px">Date</th>
                                    <th class="GridViewHeaderStyle" style="width:40px">View</th>									
								</tr>
							</thead>
							<tbody></tbody>
						</table>
			</div>
			
		</div>
	</div>
</div>
 <%--RequiredField Div--%>
   <div id="divRequiredField" class="modal fade">
    <div class="modal-dialog">
         <div class="modal-content" style="min-width: 500px;max-width:50%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeRequiredFieldsModel()"  aria-hidden="true">&times;</button>
				<h4 class="modal-title">Required Fields</h4>
			</div>
            <div class="modal-body">
                <div  class="row">
					<div id="divRequiredFieldPopUp" class="col-md-24">
                        <table id="tblRequiredField"  style="width:95%;border-collapse:collapse;margin-left:15px;" class="GridViewStyle">           
        </table>
					</div>
				</div>
              
                <div style="text-align:center" class="row">
					   <input type="button" value="Save" class="savebutton" onclick="$saveRequiredField(this, $(this).val())" id="btnSaveRequired" />
			    <input type="button" id="btnCancelRequiredField" value="Cancel" onclick="$closeRequiredFieldsModel()" class="resetbutton" />
				</div>
        </div>
   </div>
       </div>
 </div>    
   <script type="text/javascript">
       var $closePrePrintedBarcodeModel = function (callback) {
           $('#divPrePrintedBarcode').hideModel();
       }
       var $clearForm = function () {
           $resetItem(function () { });
           $clearControl(function () { });
       };
       var $closeViewRemarksModel = function (callback) {
           $('#divViewRemarks').hideModel()
       }
       function viewRemarks(remarks, type) {
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
           $("#divPopUPRemarks").html($mm);
           $("#divViewRemarks").showModel();
       }
    </script>
    <script type="text/javascript">
        function showHomeCollectionOption() {
            if ($('#ddlVisitType').val() == "Home Collection") {
                $('.divFieldBoy').show();
            }
            else {
                $('.divFieldBoy').hide();
                $('#ddlVisitType').prop('selectedIndex', 0);
            }
        }
        var $searchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                if (e.target.id == 'txtLabNo') {
                    if (e.target.value.length == "") {
                        toast('Info', "Please Enter Lab No.", '');
                        return;
                    }
                }
                $searchData(e);
            }
        };
        var $Decrypt = function (DecryptText, callback) {
            if (DecryptText != "") {
                serverCall('../Common/Services/CommonServices.asmx/decryptData', { ID: DecryptText.trim() }, function (response) {
                    callback(response);
                });
            }
        }
        var $searchData = function (e) {
            $clearForm(function () { });
            if ($.trim($("#txtLabNo").val()) == "") {
                toast("Info", "Please Enter Lab No.", "");
                $("#txtLabNo").focus();
                $(".clDisplay").hide();
                return;
            }
            $modelBlockUI(function () { });
            var data = { LabNo: '' };
            data.LabNo = $("#txtLabNo").val();
            getPatientTestDetails(data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var resultData = JSON.parse(response);
                    if (resultData == -1) {                     
                        modelAlert("Time is expired . You cannot edit the Prescription..!");
                        return;
                    }
                    if (resultData.length > 0) {
                     
                      if (resultData[0].BillTimeDiff > 10080 && '<%=Session["RoleID"]%>' == '2') {
                               modelAlert("You can edit Patient within 7 Days of Billing");
							}
                        else{
                            bindOldPatientDetails(response);}
                    }

                    
                    else
                        modelAlert('No Record Found');
                }
                else
                    modelAlert('No Record Found');

                $modelUnBlockUI(function () { });
            });
        }
        var getPatientTestDetails = function (data, callback) {
            serverCall('../Lab/Services/LabBooking.asmx/GetPatientReceiptData', data, function (response) {
                callback(response);
            });
        }
        var InvList = [];
        var bindOldPatientDetails = function (data) {
            if (!String.isNullOrEmpty(data)) {
                OldPatientDetails = JSON.parse(data);
                if (OldPatientDetails != null) {
                    //if (OldPatientDetails[0].InvoiceNo != "") {
                    //    toast("Error", "Invoice is generated you can not edit the bill", "");
                    //    $('#btnSearch').removeAttr('disabled').val('Search');
                    //    return false;
                    //}
                    $('#txtLabNo').val(OldPatientDetails[0].LedgerTransactionNo)
                    $("#txtMobileNo").val(OldPatientDetails[0].Mobile).attr('disabled', 'disabled');

                    $($('#ddlTitle option').filter(function () { return this.text == OldPatientDetails[0].Title })[0]).prop('selected', true).attr('disabled', 'disabled');
                    $("#txtUHIDNo").val(OldPatientDetails[0].patient_id).attr('disabled', 'disabled');
                    $("#spnUHIDNo").text(OldPatientDetails[0].patient_id);
                    $("#ddlGender").val(OldPatientDetails[0].Gender).attr('disabled', 'disabled');
                    $("#txtPName").val(OldPatientDetails[0].PName).attr('disabled', 'disabled');
                    $("#txtPName").attr("title", OldPatientDetails[0].PName);
                    $('#txtAge').val(OldPatientDetails[0].AgeYear).attr('disabled', 'disabled');
                    $('#txtAge1').val(OldPatientDetails[0].AgeMonth).attr('disabled', 'disabled');
                    $('#txtAge2').val(OldPatientDetails[0].AgeDays).attr('disabled', 'disabled');
                    $('#txtDOB').val(OldPatientDetails[0].dob).attr('disabled', 'disabled');
                    $('#txtPAddress').val(OldPatientDetails[0].House_No).attr('disabled', 'disabled');
                    $('#txtEmail').val(OldPatientDetails[0].Email).attr('disabled', 'disabled');
                    $('#ddlState').append($("<option></option>").val(OldPatientDetails[0].StateID).html(OldPatientDetails[0].State));
                    $('#ddlCity').append($("<option></option>").val(OldPatientDetails[0].CityID).html(OldPatientDetails[0].City));
                    $('#ddlArea').append($("<option></option>").val(OldPatientDetails[0].LocalityID).html(OldPatientDetails[0].Locality));


                    $('#ddlState,#ddlCity,#ddlArea,#ddlTitle').attr('disabled', 'disabled');

                    $('#txtPinCode').val(OldPatientDetails[0].Pincode).attr('disabled', 'disabled');

                    $('#txtReferDoctor').val(OldPatientDetails[0]["DoctorName"]).attr('disabled', 'disabled');
                    $('#hftxtReferDoctor').val(OldPatientDetails[0]["Doctor_ID"]).attr('disabled', 'disabled');
                    
                    $('#txtSRFNumber').val(OldPatientDetails[0]["SRFNo"]);
                    $('#txtCentreData').val(OldPatientDetails[0]["CentreID"]);
                    $('#txtLedgertransactionID').val(OldPatientDetails[0]["LedgerTransactionID"]);
                    $('#txtLedgertransactionNo').val(OldPatientDetails[0]["LedgerTransactionNo"]);
                    $('#txtDiscShareType').val(OldPatientDetails[0]["DiscShareType"]);
                    $('#rdAge,#rdDOB').attr('disabled', 'disabled');
                    $('#txtMRNo').val(OldPatientDetails[0]["patient_id"]);
                    $('#txtGender').val(OldPatientDetails[0]["Gender"]);
                    $('#txtPatientType').val(OldPatientDetails[0]["Patienttype"]);
                   
                    $('#txtPanelData').val(OldPatientDetails[0]["Panel_ID"]);
                    if (OldPatientDetails[0]["Doctor_ID"] == "2") {
                        $('#txtOtherDoctor').attr("disabled", false);
                        //  $('#txtOtherDoctor').val(OldPatientDetails[0]["OtherDoctorName"]).attr('disabled', 'disabled');

                    }
                    $('#txtRemarks').val(OldPatientDetails[0]["Remarks"]).attr('disabled', 'disabled');
                    $('#txtSRFNumber').val(OldPatientDetails[0]["SRFNo"]);//.attr('disabled', 'disabled');


                    $('#ddlDispatchMode').val(OldPatientDetails[0]["DispatchModeID"]).attr('disabled', 'disabled');
                    $('#txtPrescribeDate').val(OldPatientDetails[0]["PrescribeDate"]);
                    if (OldPatientDetails[0]["PatientIDProofNo"] != "") {
                        $('#ddlIdentityType').val(OldPatientDetails[0]["PatientIDProof"]).attr('disabled', 'disabled');
                        $('#txtIdProofNo').val(OldPatientDetails[0]["PatientIDProofNo"]).attr('disabled', 'disabled');
                    }
                    $('#txtIdProofNo,#ddlIdentityType').attr('disabled', 'disabled');
                    $('#ddlSource').val(OldPatientDetails[0]["PatientSource"]).attr('disabled', 'disabled');

                    $('#ddlVisitType').val(OldPatientDetails[0]["VisitType"]).attr('disabled', 'disabled');

                    $('#hdSampleCollectionOnReg').val(OldPatientDetails[0]["SampleCollectionOnReg"]);
                    $('#hdBarCodePrintedType').val(OldPatientDetails[0]["BarCodePrintedType"]);
                    $('#hdBarCodePrintedCentreType').val(OldPatientDetails[0]["BarCodePrintedCentreType"]);
                    $('#hdBarCodePrintedHomeColectionType').val(OldPatientDetails[0]["BarCodePrintedHomeColectionType"]);
                    $('#hdSetOfBarCode').val(OldPatientDetails[0]["setOfBarCode"]);
                    if ($('#ddlVisitType').val() == "Home Collection") {
                        $('.divFieldBoy').show();
                        $bindFieldBoy(function (callback) {
                            $('#ddlFieldBoy').val(OldPatientDetails[0]["HomeVisitBoyID"]).attr('disabled', 'disabled');
                        });
                    }
                    else {
                        $('.divFieldBoy').hide();
                    }
                    $('#ddlVisitType').prop('selectedIndex', 0);

                    if (OldPatientDetails[0]["Patienttype"] == "HLM") {
                        $("#ddlHLMType").val(OldPatientDetails[0]["HLMPatientType"]);
                        $("#txtHLMOPDIPNo").val(OldPatientDetails[0]["HLMOPDIPDNo"]);
                        $("#divHLMDetail").show();
                    }
                    else {
                        $("#ddlHLMType").val(OldPatientDetails[0]["HLMPatientType"]);
                        $("#txtHLMOPDIPNo").val('');
                        $("#divHLMDetail").hide();
                    }
                    if (OldPatientDetails[0]["VIP"] == "1") {
                        $('#chkIsVip').prop("checked", true);
                    }
                    else {
                        $('#chkIsVip').prop("checked", false);
                    }

                    //if (OldPatientDetails[0]["Patienttype"] == "PUP") {
                    //    $("#txtPUPContact").val(OldPatientDetails[0]["PUPContact"]).attr('disabled', 'disabled');
                    //    $("#txtPUPMobile").val(OldPatientDetails[0]["PUPEmailId"]).attr('disabled', 'disabled');
                    //    $("#txtPUPRefNo").val(OldPatientDetails[0]["PUPRefNo"]).attr('disabled', 'disabled');

                    //}

                    if (OldPatientDetails[0]["CorporateIDCard"] != "") {
                        $("#txtCorporateIDCard").val(OldPatientDetails[0]["CorporateIDCard"]).attr('disabled', 'disabled');
                        $("#ddlCorporateIDType").val(OldPatientDetails[0]["CorporateIDType"]).attr('disabled', 'disabled');
                        $("#divCorporate").show();
                    }
                    else {
                        $("#divCorporate").hide();
                    }

                    if (jQuery("#txtPanelData").val().split('#')[6] == "1") {

                        jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").show();
                    }
                    else {

                        jQuery(".paientpaypercentage,.clpaybypatient,.clpaybypanel").hide();
                    }



                    for (var i = 0; i <= OldPatientDetails.length - 1 ; i++) {
                        var inv = OldPatientDetails[i].Investigation_ID;
                        for (var j = 0; j < (inv.split(',').length) ; j++) {
                            if ($.inArray(inv.split(',')[j], InvList) != -1) {
                                toast("Info", "Item Already in List", "");
                                return;
                            }
                        }
                        for (var a = 0; a < (inv.split(',').length) ; a++) {
                            if (inv.split(',')[a].trim() != "") {
                                InvList.push(inv.split(',')[a]);
                            }
                        }

                        var type = "Test";
                        if (OldPatientDetails[i].ispackage == "1") {
                            type = "Package";
                        }
                      
                        var $investigationTr = [];
                        var isoutsrc = OldPatientDetails[i].IsOutSrc;
                        if (isoutsrc == '1') {
                            $investigationTr.push("<tr style='background-color:#fae8f9;' id='"); $investigationTr.push(OldPatientDetails[i].ItemID); $investigationTr.push("'>");
                        }
                        else {
                            $investigationTr.push("<tr id='"); $investigationTr.push(OldPatientDetails[i].ItemID); $investigationTr.push("'>");
                        }
                        
                        $investigationTr.push("<td class='GridViewLabItemStyle' id='tdTestCode'>");
                        $investigationTr.push(OldPatientDetails[i].testcode);
                        $investigationTr.push("</td>");
                        $investigationTr.push("<td id='tdItemName' style='text-align:left; width:200px; max-width: 200px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;'>");
                        $investigationTr.push("<span data-title='");
                        $investigationTr.push(OldPatientDetails[i].item); $investigationTr.push("'");
                        $investigationTr.push('id="spnItemName">'); $investigationTr.push(OldPatientDetails[i].item);
                        $investigationTr.push("</span></td>");
                        $investigationTr.push("<td style='text-align:center;'>");
                        if (OldPatientDetails[i].SampleRemarks != "") {
                            $investigationTr.push('<a href="javascript:void(0);" onclick="viewRemarks(\'');
                            $investigationTr.push(OldPatientDetails[i].SampleRemarks); $investigationTr.push("\',"); $investigationTr.push("\'");
                            $investigationTr.push(type); $investigationTr.push("\');"); $investigationTr.push('">');
                            $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
                        }

                        $investigationTr.push("</td><td style='text-align:center;'>");
                        $investigationTr.push('<a  href="javascript:void(0);" onclick="viewDOS(\'');
                        $investigationTr.push(OldPatientDetails[i].Investigation_ID); $investigationTr.push("\',"); $investigationTr.push("\'");
                        $investigationTr.push(OldPatientDetails[i].CentreID);
                        $investigationTr.push("\',"); $investigationTr.push("\'"); $investigationTr.push(type);
                        $investigationTr.push("\',this);"); $investigationTr.push('">');
                     
                        $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
                        $investigationTr.push("</td>");


                        if ($('#txtPanelData').val().split('#')[4] == "0") {
                            $investigationTr.push('<td id="tdMRP"  style="text-align:right">');
                            $investigationTr.push(OldPatientDetails[i].MRP);
                            $investigationTr.push('</td><td id="tdRate"  style="text-align:right">');
                            $investigationTr.push(OldPatientDetails[i].rate);
                            $investigationTr.push('</td>');                           
                            $investigationTr.push('<td>'); $investigationTr.push(OldPatientDetails[i].Quantity); $investigationTr.push('</td>');
                            $investigationTr.push('<td id="tdItemWiseDiscount" >');
                            $investigationTr.push('<input id="txtItemWiseDiscount" class="ItDoseTextinputNum" type="text"  style="width:50px;" value="');
                            $investigationTr.push(OldPatientDetails[i].DiscountAmt); $investigationTr.push('"'); $investigationTr.push('disabled="disabled"/></td>');
                            $investigationTr.push('<td id="tdNetAmount" style="text-align:right" ><input type="text" class="ItDoseTextinputNum" style="width:50px;" id="txtNetAmt" value="');
                            $investigationTr.push(OldPatientDetails[i].amount); $investigationTr.push('"'); $investigationTr.push('disabled="disabled"/></td>');
                        }
                        else {
                            $investigationTr.push('<td class="GridViewLabItemStyle" id="tdMRP" style="text-align:right;color:lemonchiffon">');
                            $investigationTr.push(OldPatientDetails[i].MRP);
                            $investigationTr.push('</td>');
                            $investigationTr.push('<td class="GridViewLabItemStyle" id="tdRate" style="text-align:right;color:lemonchiffon">');
                            $investigationTr.push(OldPatientDetails[i].rate);
                            $investigationTr.push('</td>');                           
                            $investigationTr.push('<td>');$investigationTr.push(OldPatientDetails[i].Quantity);$investigationTr.push('</td>');                                                          
                            $investigationTr.push('<td id="tdItemWiseDiscount" >');
                            $investigationTr.push('<input id="txtItemWiseDiscount" type="text"  style="width:50px;display:none;" value="');
                            $investigationTr.push(OldPatientDetails[i].DiscountAmt); $investigationTr.push('"'); $investigationTr.push('disabled="disabled"/></td>');
                            $investigationTr.push('<td id="tdNetAmount" style="text-align:right;" ><input type="text" style="width:50px;display:none" id="txtNetAmt" value="');
                            $investigationTr.push(OldPatientDetails[i].amount); $investigationTr.push('"'); $investigationTr.push('disabled="disabled"/></td>');
                        }
                        if (OldPatientDetails[i].DeliveryDate == '01-Jan-0001 12:00 AM') {
                            $investigationTr.push('<td id="tddeliverydate_show"  style="font-weight:bold;text-align: center;"></td>');
                        }
                        else {
                            $investigationTr.push('<td id="tddeliverydate_show"  style="font-weight:bold;text-align: center;">');
                            $investigationTr.push(OldPatientDetails[i].DeliveryDate);
                            $investigationTr.push('</td>');
                        }
                        $investigationTr.push('<td id="tdQuantity" style="display:none" >'); $investigationTr.push('<select id="ddlIsRequiredQty"><option>');
                        $investigationTr.push(OldPatientDetails[i].Quantity); $investigationTr.push('</option></select></td>');
                        $investigationTr.push('<td id="tdoldAmount" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].Amount); $investigationTr.push('</td>');
                        $investigationTr.push('<td id="tdDeliveryDateold" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].DeliveryDate);
                        $investigationTr.push('<td id="tdDeliveryDate"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].DeliveryDate);
                        $investigationTr.push('</td><td id="tdSRADate"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].SRADate);
                        $investigationTr.push('</td>');
                        if (OldPatientDetails[i].SampleCollectionOnReg == 1 && OldPatientDetails[i].BarCodePrintedType == "System") {
                            $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsSampleCollection'  autocomplete='off' type='checkbox'  ");
                            if (OldPatientDetails[i].SampleDefined == "0")
                                $investigationTr.push(' disabled="disabled"  ');
                            else
                                $investigationTr.push(' checked="checked" ');

                            $investigationTr.push(" class='ItDoseTextinputNum'  style='padding:2px'  /></td>");
                            $(".clSampleCollection").show();

                        }
                        else
                            $(".clSampleCollection").hide();
                        $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsUrgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px' onchange='GetUrgentTAT(this);'  /></td>");


                        if (jQuery("#txtPanelData").val().split('#')[6] == "1") {

                            $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypatient" value="');
                            $investigationTr.push(OldPatientDetails[i].paybypatient); $investigationTr.push('"');
                            $investigationTr.push('disabled="disabled"/></td>');


                            if (OldPatientDetails[i].paybypanelper == "0" && jQuery("#txtPanelData").val().split('#')[7] == "1") {
                                $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" onkeyup="setcopaymentamount(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                                $investigationTr.push(OldPatientDetails[i].paybypanel); $investigationTr.push('"');
                                $investigationTr.push('/></td>');

                                $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;" autocomplete="off" onlynumber="10" class="ItDoseTextinputNum" id="tdpaybypanelper" maxlength="3" onkeyup="setcopaymentper(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                                $investigationTr.push(OldPatientDetails[i].paybypanelper); $investigationTr.push('"');
                                $investigationTr.push('/></td>');
                            }
                            else {
                                $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" value="');
                                $investigationTr.push(OldPatientDetails[i].paybypanel); $investigationTr.push('"');
                                $investigationTr.push('disabled="disabled"/></td>');
                                $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="tdpaybypanelper" value="');
                                $investigationTr.push(OldPatientDetails[i].paybypanelper); $investigationTr.push('"');
                                $investigationTr.push('disabled="disabled"/></td>');
                            }



                        }
                        else {

                            $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypatient" value="');
                            $investigationTr.push(OldPatientDetails[i].paybypatient); $investigationTr.push('"');
                            $investigationTr.push('disabled="disabled"/></td>');


                            $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" value="');
                            $investigationTr.push(OldPatientDetails[i].paybypanel); $investigationTr.push('"');
                            $investigationTr.push('disabled="disabled"/></td>');



                            $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="tdpaybypanelper" value="');
                            $investigationTr.push(OldPatientDetails[i].paybypanelper); $investigationTr.push('"');
                            $investigationTr.push('disabled="disabled"/></td>');



                        }                        

                        $investigationTr.push('<td id="tdIsPackage"   style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].ispackage);
                        $investigationTr.push('</td><td id="tdIsReporting"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].IsReporting);
                        $investigationTr.push('</td><td id="tdSubCategoryID"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].SubCategoryID);
                        $investigationTr.push('</td><td id="tdReportType"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].reporttype);
                        $investigationTr.push('</td><td id="tdGenderInvestigate"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].GenderInvestigate);
                        $investigationTr.push('</td><td id="tdSample" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].Sample);
                        $investigationTr.push('</td><td id="tdRequiredAttachment"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].RequiredAttachment); $investigationTr.push('</td>');
                        $investigationTr.push('<td id="tdRequiredAttchmentAt" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].AttchmentRequiredAt); $investigationTr.push('</td>');
                        $investigationTr.push('<td id="tdRequiredFields"  style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].RequiredFields);
                        $investigationTr.push('</td><td id="tdIsNewTest"  style="font-weight:bold;text-align: center;display:none;">0</td>');
                        $investigationTr.push('<td id="tdIsScheduleRate" style="font-weight:bold;text-align: center;display:none;">');
                        $investigationTr.push(OldPatientDetails[i].IsScheduleRate);
                        $investigationTr.push('</td><td class="inv" id=');
                        $investigationTr.push(OldPatientDetails[i].Investigation_ID); $investigationTr.push(">");
                            <%if (Util.GetString(Session["RoleID"]).Trim() != "177" && Util.GetString(Session["RoleID"]).Trim() != "6" && Util.GetString(Session["RoleID"]).Trim() != "211")
                              {%>
                        if (OldPatientDetails[i].result_flag == "0" && OldPatientDetails[i].IsRefund == "0") {     //&& OldPatientDetails[i].IsTransferred == '0' && OldPatientDetails[i].AllowSameDateEdit == '1'
                            $investigationTr.push('<a href="javascript:void(0);" onclick="$removeLabItems(this);"><img class="btn" src="../../App_Images/Delete.gif"/></a>');
                        }
                            <%}
                              else
                              { %>
                        if (OldPatientDetails[i].result_flag == "0" && OldPatientDetails[i].IsRefund == "0") {
                            $investigationTr.push('<a href="javascript:void(0);" onclick="$removeLabItems(this);"><img class="btn" src="../../App_Images/Delete.gif"/></a>');
                        }
                        <%} %>
                        $investigationTr.push('<td id="tdItemID"  style="text-align: center;display:none;">');
                        $investigationTr.push("<span id='spnItemID' style='display:none'>");
                        $investigationTr.push(OldPatientDetails[i].ItemID);
                        $investigationTr.push('</span></td>');
                        $investigationTr.push('<td id="tdDepartmentDisplayName" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].DepartmentDisplayName);
                        $investigationTr.push('</td>');
                        $investigationTr.push('<td id="tdSubCategoryName" style="display:none;">');
                        $investigationTr.push(OldPatientDetails[i].SubCategoryName);
                        $investigationTr.push('</td></tr>');
                        $investigationTr = $investigationTr.join("");
                        jQuery("#tb_ItemList tbody").prepend($investigationTr);
                        jQuery("#tb_ItemList").tableHeadFixer({
                        });
                        $('#tb_ItemList').show();
                        MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                    }
                    $('.clDisplay').show();
                    $("#tblMaualDocument tr").slice(1).remove();
                    $bindPatientDocumnet($("#spnUHIDNo").text(), function () { });
                    $('#lblTotalLabItemsCount').text('Count : ' + OldPatientDetails.length);
                    $updatePaymentAmount(function () { });
                }
            }
        }
        var $bindFieldBoy = function (callback) {
            var $ddlFieldBoy = $('#ddlFieldBoy');
            serverCall('../Lab/Services/LabBooking.asmx/getfieldboy', { centreid: $('#txtCentreData').val() }, function (response) {
                $ddlFieldBoy.bindDropDown({ data: JSON.parse(response).fieldBoyData, valueField: 'id', textField: 'Name', defaultValue: "" });
                callback($ddlFieldBoy.val());
            });
        }
        var $bindState = function (callback) {
            var $ddlState = $('#ddlState');
            serverCall('../Common/Services/CommonServices.asmx/bindState', { BusinessZoneID: 0 }, function (response) {
                $ddlState.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                callback($ddlState.val());
            });
        }
        var $bindCity = function (StateID, callback) {
            var $ddlCity = $('#ddlCity');
            $('#ddlCity,#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                callback($ddlCity.val());
            });
        }
        var $bindTitle = function (callback) {
            serverCall('../Common/Services/CommonServices.asmx/bindTitleWithGender', {}, function (response) {
                var $ddlTitle = $('#ddlTitle');
                $ddlTitle.bindDropDown({ data: JSON.parse(response), valueField: 'gender', textField: 'title' });
                callback($ddlTitle.val());
            });
        }
        var $bindLocality = function (CityID, callback) {
            var $ddlArea = $('#ddlArea');
            $('#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlArea.val());
            });
        }

        $(function () {
            $bindTitle(function () {
            });
            $bindDocumentMasters(function (callback) {
                if ("<%=Request.Form["LabID"] %>".length > 0) {
                    serverCall('../Common/Services/CommonServices.asmx/decryptData', { ID: "<%=Request.Form["LabID"] %>" }, function (response) {
                    $("#txtLabNo").val(response);
                    $searchData(this);
                });
            }
            });
        });
    </script>
    <script type="text/javascript">
        var $clearItem = function () {
            $('#txtInvestigationSearch').val('');
        }
        $removeLabItems = function (elem) {
            var $tr = $(elem).closest('tr');
            var RmvInv = $tr.find('.inv').attr("id").split(',');
            var len = RmvInv.length;
            InvList.splice($.inArray(RmvInv[0], InvList), len);
            $(elem).closest('tr').remove();
            $updatePaymentAmount(function () { });
        };
        $(function () {
            $onSearchInvestigation();
        });
    </script>
     <script type="text/javascript">
         $onSearchInvestigation = function () {
             $("#txtInvestigationSearch").bind("keydown", function (event) {
                 if (event.keyCode === $.ui.keyCode.TAB &&
                 $(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 if ($("#ddlGender option:selected").text() == "") {
                     toast("Error", "Please Select Gender", "");
                     $("#ddlGender").focus();
                     return;
                 }
             })
           .autocomplete({
               autoFocus: true,
               source: function (request, response) {
                   $.getJSON("../Common/CommonJsonData.aspx?cmd=GetTestList",
                        {
                            ReferenceCodeOPD: $("#txtPanelData").val().split('#')[1],
                            SearchType: $('input:radio[name=labItems]:checked').val(),
                            CentreCode: $('#txtCentreData').val(),
                            Gender: $("#ddlGender option:selected").text(),
                            DOB: $('#txtDOB').val(),
                            Panel_Id: $("#txtPanelData").val().split('#')[0],
                            PanelType: $("#txtPanelData").val().split('#')[3],
                            PrescribeDate: $('#txtPrescribeDate').val(),
                            DiscountTypeID: "",
                            PanelID_MRP: $("#txtPanelData").val().split('#')[5],
                            TestName: extractLast1(request.term),
                            MemberShipCardNo:  jQuery("#txtmembershipcardid").val()
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
                   $validateInvestigation(i, function () { });
                   this.value = '';
               },
               focus: function (e, i) {
                   // console.log(i);
               },
               close: function (el) {
                   el.target.value = '';
               },
               minLength: 2
           });
         }
         function extractLast1(term) {
             if ($('#txtPanelData').val() == '') {
                 toast("Error", "Please Select Rate Type", "");
             }
             return split(term).pop();
         }
         function iseven(val) {
             if (val % 2 === 0 || val == 3) { return true; }
             else { return false; }
         }
         function split(val) {
             return val.split(/,\s*/);
         }
         function extractLast(term) {
             return split(term).pop();
         }
         $bindItems = function (data, callback) {
             serverCall('../Common/Services/CommonServices.asmx/GetTestList', data, function (response) {
                 var responseData = $.map(JSON.parse(response), function (item) {
                     return {
                         label: item.label,
                         val: item.value,
                         DiscPer: item.DiscPer,
                         Rate: item.Rate,
                         Type: item.type
                     }
                 });
                 callback(responseData);
             });
         }
         $validateInvestigation = function (ItemID, callback) {
             if ($('#tb_ItemList tr td #spnItemID').filter(function () { return ($(this).text().trim() == ItemID.item.value) }).length > 0) {
                 toast('Info', "Selected Item Already Added", '');
                 $('#txtInvestigationSearch').val('').focus()
                 return;
             }
             $getItemRate(ItemID, function (investigationRateDetails, Rate) {
                 $addInvestigationRow(ItemID, Rate, investigationRateDetails, function () {
                     $clearPaymentControl(function () {
                         $updatePaymentAmount(function () { });
                     });
                 });
             });
         };
         $getItemRate = function (ItemID, callback) {
             $ItemID = ItemID.item.value;
             $type = ItemID.item.type;
             $Rate = ItemID.item.Rate.split('#')[0];
             $DiscPer = ItemID.item.DiscPer;
            
             $MRP = ItemID.item.MRP.split('#')[0];
             $iscopayment = jQuery("#txtPanelData").val().split('#')[6];
             $panelid = $('#txtPanelData').val().split('#')[0];
             serverCall('../Lab/Services/LabBooking.asmx/GetitemRate', { ItemID: $ItemID, type: $type, Rate: $Rate, addedtest: '', centreID: $('#txtCentreData').val(), DiscPer: $DiscPer, DeliveryDate: "", MRP: $MRP,IsCopayment: $iscopayment, panelid: $panelid,MembershipCardNo:'',IsSelfPatient:0,UHIDNo:'' }, function (response) {
                 if (!String.isNullOrEmpty(response)) {
                     var responseData = JSON.parse(response);
                     callback(responseData[0], ItemID.item.Rate);
                 }
                 else
                     callback();
             });
         }
         $addInvestigationRow = function (ItemID, Rate, investigationRateDetails, callback) {
             var inv = investigationRateDetails.Investigation_Id;
             for (var i = 0; i < (inv.split(',').length) ; i++) {
                 if ($.inArray(inv.split(',')[i], InvList) != -1) {
                     toast("Info", "Item Already in List", "");
                     return;
                 }
             }
             for (var i = 0; i < (inv.split(',').length) ; i++) {
                 InvList.push(inv.split(',')[i]);
             }
             var $investigationTr = [];
             var isoutsrc = investigationRateDetails.IsOutSrc;
             if (isoutsrc == '1') {
                 $investigationTr.push("<tr style='background-color:#fae8f9;' id=" + ItemID.item.value + ">");
             }
             else {
                 $investigationTr.push("<tr  id=" + ItemID.item.value + ">");
             }
             $investigationTr.push("<td  id='tdTestCode'>");
             $investigationTr.push(investigationRateDetails.testCode);
             $investigationTr.push("</td><td id='tdItemName' style='text-align:left; width:200px; max-width: 200px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;' >");
             $investigationTr.push("<span data-title='");
             $investigationTr.push(investigationRateDetails.typeName); $investigationTr.push("'");
             $investigationTr.push('id="spnItemName">'); $investigationTr.push(investigationRateDetails.typeName);
             $investigationTr.push("</span></td>");
             $investigationTr.push("<td style='text-align:center;'>");
             if (investigationRateDetails.SampleRemarks != "") {
                 $investigationTr.push('<a href="javascript:void(0);" onclick="viewRemarks(\'');
                 $investigationTr.push(investigationRateDetails.SampleRemarks); $investigationTr.push("\',"); $investigationTr.push("\'");
                 $investigationTr.push(investigationRateDetails.type); $investigationTr.push("\');"); $investigationTr.push('">');
                 $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
             }
             $investigationTr.push("</td><td style='text-align:center;'>");
             $investigationTr.push('<a  href="javascript:void(0);" onclick="viewDOS(\'');
             $investigationTr.push(investigationRateDetails.Investigation_Id); $investigationTr.push("\',"); $investigationTr.push("\'");
             $investigationTr.push($('#txtCentreData').val());
             $investigationTr.push("\',"); $investigationTr.push("\'"); $investigationTr.push(investigationRateDetails.type); $investigationTr.push("\',this);"); $investigationTr.push('">');
             $investigationTr.push('<img src="../../App_Images/view.gif" /></a>');
             $investigationTr.push("</td>");
             if ($("#txtPanelData").val().split('#')[4] == "0") {
                 $investigationTr.push('<td id="tdMRP"  style="text-align:right">');
                 $investigationTr.push(investigationRateDetails.MRP);
                 $investigationTr.push('</td><td id="tdRate"  style="text-align:right">');
                 $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('</td>');
                 if (investigationRateDetails.IsRequiredQuantity == '1') {
                     $investigationTr.push('<td id="tdQuantity" >');
                     $investigationTr.push('<select id="ddlIsRequiredQty" onchange="getqnty(this)">');
                     $investigationTr.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>'); $investigationTr.push('</select></td>');
                 }
                 else {
                     $investigationTr.push('<td>1</td>');
                     $investigationTr.push('<td id="tdQuantity" style="display:none" >');
                     $investigationTr.push('<select id="ddlIsRequiredQty">'); $investigationTr.push('<option>1</option>'); $investigationTr.push('</select></td>');
                 }
                 $investigationTr.push('<td id="tdItemWiseDiscount" >');
                 $investigationTr.push('<input id="txtItemWiseDiscount" type="text" class="ItDoseTextinputNum" disabled="disabled" style="width:50px;" value="0"  />');
                 $investigationTr.push('</td><td id="tdNetAmount" ><input type="text" class="ItDoseTextinputNum" style="width:50px;" id="txtNetAmt" value="');
                 $investigationTr.push(investigationRateDetails.Amount); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');
             }
             else {
                 $investigationTr.push('<td id="tdMRP"  style="color:lemonchiffon;" style="text-align:right">');
                 $investigationTr.push(investigationRateDetails.MRP); $investigationTr.push('</td>');
                 $investigationTr.push('<td id="tdRate"  style="color:lemonchiffon;" style="text-align:right">');
                 $investigationTr.push(investigationRateDetails.Rate); $investigationTr.push('</td>');

                 if (investigationRateDetails.IsRequiredQuantity == '1') {
                     $investigationTr.push('<td id="tdQuantity" >');
                     $investigationTr.push('<select id="ddlIsRequiredQty" onchange="getqnty(this)">');
                     $investigationTr.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>'); $investigationTr.push('</select></td>');
                 }
                 else {
                     $investigationTr.push('<td></td>');
                     $investigationTr.push('<td id="tdQuantity" style="display:none" >');
                     $investigationTr.push('<select id="ddlIsRequiredQty">'); $investigationTr.push('<option>1</option>'); $investigationTr.push('</select></td>');
                 }
                 $investigationTr.push('<td id="tdItemWiseDiscount" style="color:lemonchiffon;" style="text-align:right">');
                 $investigationTr.push('<input id="txtItemWiseDiscount" type="text"  style="width:50px;" value="0"  />');
                 $investigationTr.push('</td><td id="tdNetAmount" style="color:lemonchiffon;" style="text-align:right"><input type="text" style="width:50px;" id="txtNetAmt" value="');
                 $investigationTr.push(investigationRateDetails.Amount); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');
             }
             if (investigationRateDetails.DeliveryDate.split('#')[1] == '01-Jan-0001 12:00 AM') {
                 $investigationTr.push('<td id="tddeliverydate_show"  style="font-weight:bold;text-align: center;"></td>');
             }
             else {
                 $investigationTr.push('<td id="tddeliverydate_show"  style="font-weight:bold;text-align: center;">');
                 $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
                 $investigationTr.push('</td>');
             }
             $investigationTr.push('<td id="tdoldAmount" style="display:none;">');
             $investigationTr.push(investigationRateDetails.Amount); $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdDeliveryDateold" style="display:none;">');
             $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
             $investigationTr.push('<td id="tdDeliveryDate"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[1]);
             $investigationTr.push('</td><td id="tdSRADate"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.DeliveryDate.split('#')[0]);
             $investigationTr.push('</td>');
             if ($('#hdSampleCollectionOnReg').val() == 1 && $('#hdBarCodePrintedType').val() == "System") {
                 $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsSampleCollection'  autocomplete='off' type='checkbox'  ");
                 if (investigationRateDetails.SampleDefined == "0")
                     $investigationTr.push(' disabled="disabled"  ');
                 else
                     $investigationTr.push(' checked="checked" ');
                 $investigationTr.push(" class='ItDoseTextinputNum'  style='padding:2px'  /></td>");
                 $(".clSampleCollection").show();
             }
             else
                 $(".clSampleCollection").hide();
             $investigationTr.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsUrgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px' onchange='GetUrgentTAT(this);' /></td>");

             if (jQuery("#txtPanelData").val().split('#')[6] == "1") {

                 $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypatient" value="');
                 $investigationTr.push(investigationRateDetails.paybypatient); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');


                 if (investigationRateDetails.paybypanelper == "0" && jQuery("#txtPanelData").val().split('#')[21] == "1") {
                     $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" onkeyup="setcopaymentamount(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                     $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                     $investigationTr.push('/></td>');

                     $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;" autocomplete="off" onlynumber="10" class="ItDoseTextinputNum" id="tdpaybypanelper" maxlength="3" onkeyup="setcopaymentper(this)" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" value="');
                     $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                     $investigationTr.push('/></td>');
                 }
                 else {
                     $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" value="');
                     $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                     $investigationTr.push('disabled="disabled"/></td>');
                     $investigationTr.push('<td style="text-align: left;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="tdpaybypanelper" value="');
                     $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                     $investigationTr.push('disabled="disabled"/></td>');
                 }



             }
             else {

                 $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypatient" value="');
                 $investigationTr.push(investigationRateDetails.paybypatient); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');


                 $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle"><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="txtpaybypanel" value="');
                 $investigationTr.push(investigationRateDetails.paybypanel); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');
                 


                 $investigationTr.push('<td style="text-align: left;display:none;" class="GridViewLabItemStyle" ><input type="text" style="width:50px;"  class="ItDoseTextinputNum" id="tdpaybypanelper" value="');
                 $investigationTr.push(investigationRateDetails.paybypanelper); $investigationTr.push('"');
                 $investigationTr.push('disabled="disabled"/></td>');



             }
             $investigationTr.push('<td id="tdIsLMPRequired" style="display:none;">');
             $investigationTr.push(investigationRateDetails.IsLMPRequired); $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdLMPFormDay" style="display:none;">');
             $investigationTr.push(investigationRateDetails.LMPFormDay); $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdLMPToDay" style="display:none;">');
             $investigationTr.push(investigationRateDetails.LMPToDay); $investigationTr.push('</td>');

             $investigationTr.push("<td class='inv' id='"); $investigationTr.push(investigationRateDetails.Investigation_Id); $investigationTr.push("'");
             $investigationTr.push('class="GridViewLabItemStyle"><img  class="btn" alt="" src="../../App_Images/Delete.gif" onclick="$removeLabItems(this)"  /></td>');
             $investigationTr.push('<td id="tdIsPackage"    style="display:none;">');
             $investigationTr.push(investigationRateDetails.ispackage);
             $investigationTr.push('</td><td id="tdIsReporting"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.reporting);
             $investigationTr.push('</td><td id="tdSubCategoryID"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.subcategoryid);
             $investigationTr.push('</td><td id="tdReportType"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.reporttype);
             $investigationTr.push('</td><td id="tdGenderInvestigate"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.GenderInvestigate);
             $investigationTr.push('</td><td id="tdSample"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.Sample);
             $investigationTr.push('</td><td id="tdRequiredAttachment"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.RequiredAttachment); $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdRequiredAttchmentAt" style="display:none;">');
             $investigationTr.push(investigationRateDetails.AttchmentRequiredAt); $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdRequiredFields"  style="display:none;">');
             $investigationTr.push(investigationRateDetails.RequiredFields);
             $investigationTr.push('</td><td id="tdIsScheduleRate"  style="font-weight:bold;text-align: center;display:none;">');
             $investigationTr.push(Rate.split('#')[1]);
             $investigationTr.push('</td><td id="tdIsNewTest"  style="font-weight:bold;text-align: center;display:none;">1</td>');
             $investigationTr.push('<td id="tdItemID"  style="font-weight:bold;text-align: center;display:none;">');
             $investigationTr.push("<span id='spnItemID' style='display:none'>");
             $investigationTr.push(ItemID.item.value);
             $investigationTr.push('</span></td><td id="tdPanelItemCode" style="display:none;">');
             $investigationTr.push(ItemID.item.Rate.split('#')[2]);
             $investigationTr.push("</td>");
             $investigationTr.push('<td id="tdDepartmentDisplayName" style="display:none;">');
             $investigationTr.push(investigationRateDetails.DepartmentDisplayName);
             $investigationTr.push('</td>');
             $investigationTr.push('<td id="tdSubCategoryName" style="display:none;">');
             $investigationTr.push(investigationRateDetails.SubcategoryName);

             $investigationTr.push('</td></tr>');
             $investigationTr = $investigationTr.join("");
             jQuery("#tb_ItemList tbody").prepend($investigationTr);
             MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
             callback(true);
         }
         var $clearPaymentControl = function (callback) {
             $('#txtGrossAmount,#txtNetAmount,#txtDiscountAmount,#txtDiscountPerCent,#txtPaidAmount,#txtBlanceAmount').val('0');
             $('#txtDiscountReason').val('');
             $('#ddlApprovedBy').prop('selectedIndex', 0);
             callback(true);
         }
         $updatePaymentAmount = function (callback) {
             var totalBillAmount = 0;
             var totalDiscountAmount = 0;
             var $totalpaybypanel = 0;
             var $totalpaybypatient = 0;

             $tbSelected = $('#tb_ItemList');
             var labItemsAmountDetails = $tbSelected.find('tr:not(#LabHeader)').each(function () {
                 $qty = Number(1);
                // $rate = Number($(this).closest('tr').find('#tdRate').text());
                 $rate = Number(jQuery(this).closest('tr').find('#txtNetAmt').val());//sunil change for add qnty
                 totalBillAmount = Number(totalBillAmount) + Number($rate);
                 $discountAmount = Number($(this).closest('tr').find('#txtItemWiseDiscount').val());

                 totalDiscountAmount = Number(totalDiscountAmount) + Number($discountAmount);


                 $totalpaybypanel = Number($totalpaybypanel) + Number(jQuery(this).closest('tr').find('#txtpaybypanel').val());
                 $totalpaybypatient = Number($totalpaybypatient) + Number(jQuery(this).closest('tr').find('#txtpaybypatient').val());

             });
             $('#txtpaybypanelfinal').val($totalpaybypanel);
             $('#txtpaybypatientfinal').val($totalpaybypatient);

             if (labItemsAmountDetails.length > 0) {
                 $addBillAmount({
                     billAmount: totalBillAmount,
                     disCountAmount: totalDiscountAmount

                 }, function () { });

                 $($tbSelected).show();
             }
             else {
                 $($tbSelected).hide();
                 $clearPaymentControl(function () { });
             }
             $('#lblTotalLabItemsCount').text('Count : ' + labItemsAmountDetails.length);
         };
         var $addBillAmount = function (data, callback) {
             $('#txtGrossAmount').val(data.billAmount);
             $('#txtNetAmount').val(data.billAmount - data.disCountAmount);
             $('#txtDiscountAmount').val(data.disCountAmount);
             $bindPaymentMode(function () {

             });
         };

         var $bindPaymentMode = function (callback) {
         }
         var $resetItem = function () {
             InvList = [];
             $('#tb_ItemList tr').slice(1).remove();

             $clearPaymentControl(function () { });
             $('#lblTotalLabItemsCount').text('Count : 0');
             $("#tb_ItemList,.clDisplay").hide();
         }

         var $clearControl = function () {
             $("input[type=text]").not('#txtLabNo').val("");
             $("#chkIsVip").prop('checked', false);
             $("#ddlDispatchMode,#ddlSource,#ddlIdentityType,#ddlVisitType").prop('selectedIndex', 0);
             $("#spnDocumentMaualCounts,#spnDocumentCounts").text('0');
             $('#imgPatient').attr('src', '../../App_Images/no-avatar.gif');
             document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
             $("#tblMaualDocument tr").slice(1).remove();
             $('#spnError,#spnFileName').text('');
         };
         var $clearPaymentControl = function (callback) {
             $('#txtGrossAmount,#txtNetAmount,#txtPaidAmount,#txtBlanceAmount').val('0');
             callback(true);
         }

         </script>
    <script type="text/javascript">
        function bindsampletype(InvestigationID) {
            $('#tb_SampleList tr').slice(1).remove();
            $('#txtAllBarCode').val('');
            serverCall('../Lab/Services/LabBooking.asmx/GetsampleTypeWithLabNo', { investigationid: InvestigationID, LabNo: $('#txtLedgertransactionID').val() }, function (response) {
                var $SampleData = JSON.parse(response);


                for (var i = 0; i <= $SampleData.length - 1; i++) {
                    var $mydata = [];

                    $mydata.push("<tr id='" + $SampleData[i].investigation_id + "'  class='GridViewItemStyle' ");
                    if ($SampleData[i].barcodeno == "") {
                        $mydata.push("style='background-color:#e8e4f1;'>");
                    }
                    else {
                        $mydata.push("style='background-color:lemonchiffon'>");
                    }

                    $mydata.push('<td>');
                    $mydata.push(parseInt(i + 1));
                    $mydata.push('</td>');
                    $mydata.push('<td  style="font-weight:bold;" id="tdInvName" >');
                    $mydata.push($SampleData[i].NAME);
                    $mydata.push('</td>');
                    $mydata.push('<td id="tdSampleTypeName" style="font-weight:bold;">');
                    if ($SampleData[i].Container == "7") {
                        if ($SampleData[i].barcodeno == "") {
                            $mydata.push('<input id="txtSpecimenType" onkeypress="return blockSpecialChar(event)"   type="text" placeholder="Enter Specimen Type" style="width:140px;background-color:lightblue;"/>');
                            $mydata.push('<br/><strong>No of Container:</strong>&nbsp;&nbsp;<select id="ddlNoofsp"><option>0</option>');
                            $mydata.push('<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                            $mydata.push('<br/><strong>No of Slides:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlNoofsli">');
                            $mydata.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                            $mydata.push('<br/><strong>No of Block:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select id="ddlNoofblock">');
                            $mydata.push('<option>0</option><option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>');
                            $mydata.push('<option>6</option><option>7</option><option>8</option><option>9</option></select>');
                        }
                        else {
                            $mydata.push('<input id="txtSpecimenType" readonly="readonly"  type="text" value="' + $SampleData[i].sampleinfo.split('^')[0].split('|')[1] + '" style="width:140px;background-color:lightblue;"/>');
                            $mydata.push('<br/><strong>No of Container:&nbsp;&nbsp;');
                            $mydata.push($SampleData[i].HistoCytoSampleDetail.split('^')[0]);
                            $mydata.push('</strong>');
                            $mydata.push('<br/><strong>No of Slides:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                            $mydata.push($SampleData[i].HistoCytoSampleDetail.split('^')[1]);
                            $mydata.push('</strong>');
                            $mydata.push('<br/><strong>No of Block:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                            $mydata.push($SampleData[i].HistoCytoSampleDetail.split('^')[2]);
                            $mydata.push('</strong>');
                        }
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
                    if ($SampleData[i].barcodeno == "") {
                        if ($SampleData[i].Container == "7") {
                            if ($('#hdSetOfBarCode').val() == "SampleType") {
                                $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,');
                                $mydata.push("'");
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push("')"); $mydata.push('"');
                                $mydata.push('placeholder="Enter Barcode" class="');
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"/>');
                                $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                            }
                            else {
                                $mydata.push('<td id="tdBarCodeNo"><input type="text"  style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,0)" placeholder="Enter Barcode" class="');
                                $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                $mydata.push('"/>');
                                $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                            }
                        }
                        else {
                            if ($SampleData[i].sampleinfo.split('^').length == 1) {
                                if ($('#hdSetOfBarCode').val() == "SampleType") {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,');
                                    $mydata.push("'");
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push("')"); $mydata.push('"');
                                    $mydata.push('placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">1</span></td>');
                                }
                                else {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,0)" placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">1</span></td>');
                                }
                            }
                            else {
                                if ($('#hdSetOfBarCode').val() == "SampleType") {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,');
                                    $mydata.push("'");
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push("')"); $mydata.push();
                                    $mydata.push('placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]);
                                    $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                                }
                                else {
                                    $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,0)" placeholder="Enter Barcode" class="');
                                    $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"/>');
                                    $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                                }
                            }
                        }
                    }
                    else {
                        if ($('#hdSetOfBarCode').val() == "SampleType") {
                            $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" name="myBarCodeNo" id="txtBarCodeNo" onkeyup="sameBarcode(this,0)" placeholder="Enter Barcode"  disabled="disabled" value="');
                            $mydata.push($SampleData[i].barcodeno); $mydata.push('"');
                            $mydata.push(' class="'); $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"');
                            $mydata.push('"/>');
                            $mydata.push('<span id="stype" style="display:none;">0</span></td>');
                        }
                        else {
                            $mydata.push('<td id="tdBarCodeNo"><input type="text" style="width:140px" id="txtBarCodeNo" onkeyup="sameBarCode(this,0)" placeholder="Enter Barcode" disabled="disabled" value="');
                            $mydata.push($SampleData[i].barcodeno); $mydata.push('"');
                            $mydata.push(' class="'); $mydata.push($SampleData[i].sampleinfo.split('|')[0]); $mydata.push('"');
                            $mydata.push('"/>');
                            $mydata.push('<span id="stype" style="display:none;">0</span></td>');

                        }
                    }
                    if ($SampleData[i].barcodeno != "") {
                        $mydata.push('<td id="tdCheckSNR"><input type="checkbox" id="chSNR" onclick="chkSNRClick(this);" style="display:none;"/></td>');
                    }
                    else {
                        $mydata.push('<td id="tdCheckSNR"><input type="checkbox" id="chSNR" onclick="chkSNRClick(this);"/></td>');
                    }

                    $mydata.push('<td id="tdReportType" style="display:none;">');
                    $mydata.push($SampleData[i].Container);
                    $mydata.push('</td>');
                    if ($SampleData[i].barcodeno == "") {
                        $mydata.push('<td id="tdIsNewEntry" style="display:none;">1</td>');
                    }
                    else {
                        $mydata.push('<td id="tdIsNewEntry" style="display:none;">0</td>');
                    }
                    $mydata.push('</tr>');
                    $mydata = $mydata.join("");
                    $('#tb_SampleList').append($mydata);

                }

            });
            $('#divPrePrintedBarcode').showModel();
        }

        function setBarCodeToall(ctrl) {
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }
        function chkSNRClick(ctrl) {
            if ($(ctrl).is(':checked')) {
                $(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').val('SNR');
            }
            else {
                $(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').val('');
            }
            $(ctrl).closest('td').closest('tr').find('input[type=text]#txtBarCodeNo').attr('disabled', $(ctrl).is(':checked'));
        }

        function sameBarCode(ctrl, $SampleTypeID) {
            if ($SampleTypeID == 0) {
                var value = $(ctrl).val();
                var classname = $(ctrl).attr("class")
                var inputs = $("." + classname);

                for (var i = 0; i < inputs.length; i++) {
                    $(inputs[i]).val(value);
                }
            }
            else {
                $("#tb_SampleList tr").find("." + $SampleTypeID).val($(ctrl).val());
            }
        }
    </script>

    <script type="text/javascript">
        function $validation() {
            var $count = $('#tb_ItemList tr').length;
            if ($count == 0 || $count == 1) {
                toast("Error", "Please Select Test", "");
                $('#txtInvestigationSearch').focus();
                return false;
            }

            var attachment = [];
            $('#tb_ItemList').find('tbody tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    if ($.trim($(this).closest("tr").find("#tdRequiredAttchmentAt").html()) == "1") {
                        if ($.trim($(this).closest("tr").find("#tdIsPackage").html()) == 1) {
                            if ($(this).closest("tr").find("#tdRequiredAttachment").text() != "") {
                                for (var i = 0; i < $(this).closest("tr").find("#tdRequiredAttachment").text().split(',').length; i++) {
                                    var reqAttachment = $(this).closest("tr").find("#tdRequiredAttachment").text().split(',')[i];
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

                            if ($(this).closest("tr").find("#tdRequiredAttachment").text() != "") {
                                for (var i = 0; i < $(this).closest("tr").find("#tdRequiredAttachment").text().split('|').length; i++) {
                                    var reqAttachment = $(this).closest("tr").find("#tdRequiredAttachment").text().split('|')[i];
                                    if (reqAttachment != "" && attachment.indexOf(reqAttachment) == -1) {
                                        attachment.push(reqAttachment);
                                    }
                                }
                            }
                        }
                    }
                }
            });


            if (attachment.length > 0 && $("#tblMaualDocument").find('tbody tr').length == "0") {
              //  toast("Error", "".concat(attachment.join(","), ' ', "Required to Attach With Booked Test"), "");
               // return false;
            }
            var MaualDocumentID = [];
            if ($("#tblMaualDocument").find('tbody tr').length > 0) {
                $("#tblMaualDocument").find('tbody tr').each(function () {
                    MaualDocumentID.push($(this).closest('tr').find("#tdManualDocumentName").text());
                });
            }


            var DocumentDifference = [];

            jQuery.grep(attachment, function (el) {
                if (jQuery.inArray(el, MaualDocumentID) == -1) DocumentDifference.push(el);
            });
            if (DocumentDifference.length > 0) {
            //    toast("Error", "".concat(DocumentDifference.join(","), ' ', "Required to Attach With Booked Test"), "");
              //  return false;
            }



            return true;
        }
        var $updateLabPrescription = function (btnSave, buttonVal) {
            if ($validation() == false) {
                return;
            }
            $("#spnSavingType").text('1');
           
            $modelBlockUI();

            var requiredFiled = $checkRequiredField();
            if (requiredFiled.length > 0) {
                $bindRequiredFieldData(requiredFiled);
            }
            else {
                $updateLabPrescriptionData(function (btnSave, buttonVal) { });
            }
        }
        var $updateLabPrescriptionData = function (btnSave, buttonVal) {
            if ($('#hdBarCodePrintedType').val() == "PrePrinted" && ((($('#hdBarCodePrintedCentreType').val() == 1 && $("#ddlVisitType").val() == "Center Visit")) || ($('#hdBarCodePrintedHomeColectionType').val() == 1 && $("#ddlVisitType").val() == "Home Collection")) && $('#hdSampleCollectionOnReg').val() == "1") {
                var InvestigationID = [];
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "LabHeader") {
                        InvestigationID.push($.trim($(this).closest("tr").find(".inv").attr("id")));
                    }
                });
                if ($('#hdSetOfBarCode').val() == "SampleType")
                    $("#txtAllBarCode").hide();
                else
                    $("#txtAllBarCode").show();
                bindsampletype(InvestigationID.join(','));
                return;
            }
            else {
                $updateLabData(function (btnSave) { });
            }
        };
        var $updateLabData = function (btnSave) {
            var sampledata = [];
            if ($('#hdBarCodePrintedType').val() == "PrePrinted" && ((($('#hdBarCodePrintedCentreType').val() == 1 && $("#ddlVisitType").val() == "Center Visit")) || ($('#hdBarCodePrintedHomeColectionType').val() == 1 && $("#ddlVisitType").val() == "Home Collection")) && $('#hdSampleCollectionOnReg').val() == "1") {
                var validate = 0;
                $('#tb_SampleList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trSampleHeader") {
                        if ($.trim($(this).find('#txtBarCodeNo').val()) == "") {
                            validate = 1;
                            $(this).find('#txtBarCodeNo').focus();
                            return;
                        }
                    }
                });
                if (validate == 1) {
                    if ($('#ddlPatientType').val() != "1") {
                        toast("Error", "Please Enter Barcode No.", "");
                        return false;
                    }
                }
                validate = 0;
                $('#tb_SampleList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trSampleHeader" && $(this).find('#tdReportType').html() == "7") {
                        if ($.trim($(this).find('#txtSpecimenType').val()) == "") {
                            validate = 1;
                            $(this).find('#txtBarCodeNo').focus();
                            return;
                        }
                    }
                });
                if (validate == 1) {
                    toast("Error", "Please Enter Specimen Type", "");
                    return false;
                }
                sampledata = getsampledata();
            }
            var patient_data = PatientData();
            var PLOdata = patientlabinvestigationopd();
            if (PLOdata == "")
                return;
            var $RequiredField = requiredfiled();
            var sampledategiven = "0";
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Lab_PrescriptionOPDEdit.aspx/UpdatePatientReceipt', { PatientData: patient_data, PLO: PLOdata, sampledata: sampledata, RequiredField: $RequiredField }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $(btnSave).removeAttr('disabled').val('Save');
                    if ($('#hdBarCodePrintedType').val() == 'PrePrinted' && (($('#hdBarCodePrintedCentreType').val() == 1 && $("#ddlVisitType").val() == "Center Visit")) || ($('#hdBarCodePrintedHomeColectionType').val() == 1 && $("#ddlVisitType").val() == "Home Collection")) {
                        $('#divPrePrintedBarcode').hideModel();
                    }
                    $clearForm(function () { });
                    toast("Success", "Record Saved Successfully", "");
                }
                else {
                    if ($('#hdBarCodePrintedType').val() == 'PrePrinted' && (($('#hdBarCodePrintedCentreType').val() == 1 && $("#ddlVisitType").val() == "Center Visit")) || ($('#hdBarCodePrintedHomeColectionType').val() == 1 && $("#ddlVisitType").val() == "Home Collection")) {
                        $('#divPrePrintedBarcode').hideModel();
                    }
                    toast("Error", $responseData.response, "");
                   
                    $("#btnSkipSave").removeAttr('disabled').val('Skip & Save');
                    $("#btnSave,#btnFinalSave").removeAttr('disabled').val('Save');
                }
            });
        };

    </script>
    <script type="text/javascript">
        function getsampledata() {
            var datasample = new Array();
            $('#tb_SampleList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trSampleHeader" && $(this).closest("tr").find('#tdIsNewEntry').text() == "1") {
                    var objsample = new Object();
                    objsample.InvestigationID = $(this).closest("tr").attr("id");
                    objsample.InvestigationName = $.trim($(this).closest("tr").find("#tdInvName").text());
                    if ($(this).closest("tr").find("#tdReportType").text() == "7") {
                        objsample.SampleTypeID = "1";
                        objsample.SampleTypeName = $.trim($(this).closest("tr").find("#txtSpecimenType").val());
                    }
                    else {
                        if ($(this).closest("tr").find("#stype").html() == "1") {
                            objsample.SampleTypeID = $.trim($(this).closest("tr").find("#spnSampleTypeID").html());
                            objsample.SampleTypeName = $.trim($(this).closest("tr").find("#spnSampleTypeName").html());
                        }
                        else {
                            objsample.SampleTypeID = $.trim($(this).closest("tr").find("#ddlSampleType option:selected").val());
                            objsample.SampleTypeName = $.trim($(this).closest("tr").find("#ddlSampleType option:selected").text());
                        }
                    }
                    objsample.BarcodeNo = $.trim($(this).closest("tr").find("#txtBarCodeNo").val());
                    objsample.IsSNR = $(this).closest("tr").find("#chSNR").prop('checked') == true ? '1' : '0';
                    if ($(this).closest("tr").find("#tdReportType").text() == "7") {
                        objsample.HistoCytoSampleDetail = $(this).find('#ddlNoofsp').val() + "^" + $(this).find('#ddlNoofsli').val() + "^" + $(this).find('#ddlNoofblock').val();
                    }
                    else {
                        objsample.HistoCytoSampleDetail = '';
                    }
                    datasample.push(objsample);
                }
            });
            return datasample;
        }
        function patientlabinvestigationopd() {
            var dataPLO = new Array();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "LabHeader") {

                    var ispackage = $.trim($(this).closest("tr").find("#tdIsPackage").html());
                    if (ispackage == "0") {
                        var objPLO = new Object();
                        objPLO.ItemId = $.trim($(this).closest("tr").attr("id"));
                        objPLO.ItemCode = $.trim($(this).closest("tr").find("#tdTestCode").text());
                        objPLO.ItemName = $.trim($(this).closest("tr").find("#tdItemName").text());
                        objPLO.InvestigationName = $.trim($(this).closest("tr").find("#tdItemName").text());
                        objPLO.PackageName = "";
                        objPLO.PackageCode = "";
                        objPLO.Investigation_ID = $.trim($(this).closest("tr").find(".inv").attr("id"));
                        objPLO.IsPackage = "0";
                        objPLO.SubCategoryID = $.trim($(this).closest("tr").find("#tdSubCategoryID").html());
                        objPLO.MRP = $.trim($(this).closest("tr").find("#tdMRP").html());
                        objPLO.Rate = $.trim($(this).closest("tr").find("#tdRate").html());
                        objPLO.Amount = $.trim($(this).closest("tr").find("#txtNetAmt").val());
                        objPLO.DiscountAmt = $.trim($(this).closest("tr").find("#txtItemWiseDiscount").val());
                        objPLO.PayByPanel = jQuery(this).closest("tr").find("#txtpaybypanel").val();
                        objPLO.PayByPanelPercentage = jQuery(this).closest("tr").find("#tdpaybypanelper").val();
                        objPLO.PayByPatient = jQuery(this).closest("tr").find("#txtpaybypatient").val();

                        objPLO.Quantity = $.trim($(this).closest("tr").find("#ddlIsRequiredQty").val());
                        objPLO.IsRefund = "0";
                        objPLO.IsReporting = $.trim($(this).closest("tr").find("#tdIsReporting").html());
                        objPLO.ReportType = $.trim($(this).closest("tr").find("#tdReportType").html());
                        objPLO.CentreID = $('#txtCentreData').val();
                        objPLO.TestCentreID = "0";
                        objPLO.DeliveryDate = $.trim($(this).closest("tr").find("#tdDeliveryDate").html());
                        objPLO.SRADate = $.trim($(this).closest("tr").find("#tdSRADate").html());
                        objPLO.DiscountByLab = $('#txtDiscShareType').val();
                        objPLO.IsScheduleRate = $.trim($(this).closest("tr").find("#tdIsScheduleRate").html());
                        objPLO.PanelItemCode = $.trim($(this).closest("tr").find("#tdPanelItemCode").html());
                        objPLO.isUrgent = $(this).closest("tr").find("#chkIsUrgent").is(':checked') ? 1 : 0;

                        if ($.trim($(this).closest("tr").find("#tdSample").html()) == "N") {
                            objPLO.IsSampleCollected = "Y";
                            objPLO.SampleBySelf = "0";
                        }
                        else if ($(this).closest("tr").find("#chkIsSampleCollection").is(':checked')) {
                            objPLO.IsSampleCollected = "S";
                            objPLO.SampleBySelf = "1";
                        }
                        else {
                            objPLO.IsSampleCollected = "N";
                            objPLO.SampleBySelf = "0";
                        }
                        objPLO.RequiredAttachment = $.trim($(this).closest("tr").find("#tdRequiredAttachment").html());
                        objPLO.RequiredAttchmentAt = $.trim($(this).closest("tr").find("#tdRequiredAttchmentAt").html());
                        objPLO.DepartmentDisplayName = jQuery.trim(jQuery(this).closest("tr").find("#tdDepartmentDisplayName").html());
                        objPLO.SubCategoryName = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryName").html());
                        dataPLO.push(objPLO);
                    }
                    else {
                        var objPLO = new Object();

                        objPLO.ItemId = $.trim($(this).closest("tr").attr("id"));
                        objPLO.ItemCode = $.trim($(this).closest("tr").find("#tdTestCode").text());
                        objPLO.ItemName = $.trim($(this).closest("tr").find("#tdItemName").text());
                        objPLO.InvestigationName = "";
                        objPLO.PackageName = $.trim($(this).closest("tr").find("#tdItemName").text());
                        objPLO.PackageCode = $.trim($(this).closest("tr").find("#tdTestCode").text());
                        objPLO.Investigation_ID = "0";
                        objPLO.IsPackage = "1";
                        objPLO.SubCategoryID = $.trim($(this).closest("tr").find("#tdSubCategoryID").html());
                        objPLO.MRP = $.trim($(this).closest("tr").find("#tdMRP").html());
                        objPLO.Rate = $.trim($(this).closest("tr").find("#tdRate").html());
                        objPLO.Quantity = $.trim($(this).closest("tr").find("#ddlIsRequiredQty").val());
                        objPLO.Amount = $.trim($(this).closest("tr").find("#txtNetAmt").val());
                        objPLO.DiscountAmt = $.trim($(this).closest("tr").find("#txtItemWiseDiscount").val());
                        objPLO.PayByPanel = jQuery(this).closest("tr").find("#txtpaybypanel").val();
                        objPLO.PayByPanelPercentage = jQuery(this).closest("tr").find("#tdpaybypanelper").val();
                        objPLO.PayByPatient = jQuery(this).closest("tr").find("#txtpaybypatient").val();

                        objPLO.IsRefund = "0";
                        objPLO.IsReporting = "0";
                        objPLO.ReportType = "0";
                        objPLO.CentreID = $('#txtCentreData').val();
                        objPLO.TestCentreID = "0";
                        objPLO.DeliveryDate = $.trim($(this).closest("tr").find("#tdDeliveryDate").html());
                        objPLO.SRADate = $.trim($(this).closest("tr").find("#tdSRADate").html());
                        objPLO.DiscountByLab = $('#txtDiscShareType').val();
                        objPLO.IsScheduleRate = $.trim($(this).closest("tr").find("#tdIsScheduleRate").html());
                        objPLO.PanelItemCode = $.trim($(this).closest("tr").find("#tdPanelItemCode").html());
                        objPLO.isUrgent = $(this).closest("tr").find("#chkIsUrgent").is(':checked') ? 1 : 0;

                        if ($.trim($(this).closest("tr").find("#tdSample").html()) == "N") {
                            objPLO.IsSampleCollected = "Y";
                            objPLO.SampleBySelf = "0";
                        }
                        else if ($(this).closest("tr").find("#chkIsSampleCollection").is(':checked')) {
                            objPLO.IsSampleCollected = "S";
                            objPLO.SampleBySelf = "1";
                        }
                        else {
                            objPLO.IsSampleCollected = "N";
                            objPLO.SampleBySelf = "0";
                        }
                        objPLO.RequiredAttachment = $.trim($(this).closest("tr").find("#tdRequiredAttachment").html());
                        objPLO.RequiredAttchmentAt = $.trim($(this).closest("tr").find("#tdRequiredAttchmentAt").html());
                        objPLO.DepartmentDisplayName = jQuery.trim(jQuery(this).closest("tr").find("#tdDepartmentDisplayName").html());
                        objPLO.SubCategoryName = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryName").html());
                        dataPLO.push(objPLO);
                    }
                }
            });
            return dataPLO;
        }

        function PatientData() {
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
            var objLT = new Object();

            objLT.LedgerTransactionID = $('#txtLedgertransactionID').val();
            objLT.LedgerTransactionNo = $('#txtLedgertransactionNo').val();
            objLT.Patient_ID = $('#txtMRNo').val();
            objLT.Gender = $('#txtGender').val();
            objLT.AgeInDays = ageindays;
            objLT.CentreID = $('#txtCentreData').val();
            objLT.Panel_ID = $('#txtPanelData').val().split('#')[0];
            objLT.PatientType = $('#txtPatientType').val();
            objLT.BarCodePrintedType = $('#hdBarCodePrintedType').val();
            objLT.VisitType = $('#ddlVisitType').val();
            objLT.AttachedFileName = $('#spnFileName').text();
            return objLT;
        }
    </script>
    <script type="text/javascript">
        function viewDOS(investigationid, centerid, type, rowID) {
            var IsUrgent = $(rowID).closest('tr').find("#chkIsUrgent").is(':checked') ? 1 : 0;

            fancyBoxOpen('../Master/DosData.aspx?investigationid=' + investigationid + '&centerid=' + centerid + '&type=' + type + '&IsUrgent=' + IsUrgent + '');
        }
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 1350,
                maxHeight: 500,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );
        }
          </script>

    <script type="text/javascript">
        function showDocumentMaster() {
            var $filename = "";
            if ($("#spnUHIDNo").text() == "") {
                toast("Info", "Please Search Patient", "");
                $('#txtLabNo').focus();
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
        function showManualDocumentMaster() {
            if ($("#spnUHIDNo").text() == "") {
                toast("Info", "Please Search Patient", "");
                $('#txtLabNo').focus();
                return;
            }
            var $filename = "";
            if ($('#spnFileName').text() == "") {
                $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                $filename = $('#spnFileName').text();
            }
            $('#spnFileName').text($filename);
            $('#divDocumentMaualMaters').show();
            if ($("#tblMaualDocument tr").length == 0) {
                serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: $('#txtLedgertransactionNo').val(), Filename: '', PatientID: $("#spnUHIDNo").text(), oldPatientSearch: 1, documentDetailID: 0, isEdit: 1 }, function (response) {
                    var maualDocument = JSON.parse(response);
                    $addPatientDocumnet(maualDocument);
                });
            }
        }
        $addPatientDocumnet = function (maualDocument) {
            for (var i = 0; i < maualDocument.length ; i++) {
                var $PatientDocumnetTr = [];
                $PatientDocumnetTr.push("<tr>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                $PatientDocumnetTr.push('<img id="imgMaualDocument" alt="Remove Document" src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="removeMaualDocument(this)"/>');
                $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle' id='tdManualDocumentName'>");
                $PatientDocumnetTr.push(maualDocument[i].DocumentName); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'><a target='_blank' href='DownloadAttachment.aspx?FileName=<#=objRow.AttachedFile#>&FilePath=<#=objRow.fileurl#>'> ");
                $PatientDocumnetTr.push(maualDocument[i].AttachedFile); $PatientDocumnetTr.push("</a>");
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
                $PatientDocumnetTr.push('<td class="GridViewLabItemStyle"  style="text-align:center" ><img src="../../App_Images/view.GIF" alt=""  style="cursor:pointer" onclick="manualViewDocument(this)" /> </td>');
                $PatientDocumnetTr.push('</tr>');
                $PatientDocumnetTr = $PatientDocumnetTr.join("");
                $("#tblMaualDocument tbody").prepend($PatientDocumnetTr);
            }
            $('#spnDocumentMaualCounts').text($("#tblMaualDocument tr").length - 1);
        };
        function divDocumentMaualCloseModel() {
            $('#divDocumentMaualMaters').closeModel();
        }
        function divDocumentMatersCloseModel() {
            getUpdatedPatientDocuments(function (responseData) {
                $('#spnDocumentCounts').text(responseData.length);
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
        function saveMaualDocument() {
            if ($("#ddlDocumentType").val() == "0") {
                toast("Error", "Please Select Document Type", "");
                $("#ddlDocumentType").focus();
                return;
            }
            if ($("#fileManualUpload").val() == '') {
                toast("Error", "Please Select File to Upload", "");
                jQuery("#fileManualUpload").focus();
                return;
            }
            var validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx"];
            var extension = $('#fileManualUpload').val().split('.').pop().toLowerCase();
            if (jQuery.inArray(extension, validFilesTypes) == -1) {
                toast("Error", "".concat("Invalid File. Please upload a File with", " extension:\n\n", validFilesTypes.join(", ")), "");
                return;
            }

            var maxFileSize = 10485760; // 10MB -> 10 * 1024 * 1024
            var fileUpload = $('#fileManualUpload');
            if (fileUpload[0].files[0].size > maxFileSize) {
                toast("Error", "You can Upload Only 10 MB File", "");
                return;
            }
            var MaualDocumentID = [];
            if ($("#tblMaualDocument").find('tbody tr').length > 0) {
                $("#tblMaualDocument").find('tbody tr').each(function () {
                    MaualDocumentID.push($(this).closest('tr').find("#tdMaualDocumentID").text());
                });
            }
            if (MaualDocumentID.length > 0) {
                if (jQuery.inArray($("#ddlDocumentType").val(), MaualDocumentID) != -1) {
                    toast("Error", "Document already Saved", "");
                    return;
                }
            }
            var formData = new FormData();
            formData.append('file', $('#fileManualUpload')[0].files[0]);
            formData.append('documentID', $('#ddlDocumentType').val());
            formData.append('documentName', $('#ddlDocumentType option:selected').text());
            formData.append('Filename', $('#spnFileName').text());
            formData.append('Patient_ID', $('#spnUHIDNo').text());
            formData.append('LabNo', $('#txtLedgertransactionNo').val());
            $.ajax({
                type: 'post',
                url: '../../UploadHandler.ashx',
                data: formData,
                success: function (data, status) {
                    if (status != 'error') {
                        toast("Success", "Uploaded Successfully", "");
                        var _temp = [];
                        _temp.push(serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: $('#txtLedgertransactionNo').val(), Filename: $('#spnFileName').text(), PatientID: $('#spnUHIDNo').text(), oldPatientSearch: 0, documentDetailID: data, isEdit: 1 }, function (response) {
                            $.when.apply(null, _temp).done(function () {
                                var maualDocument = JSON.parse(response);
                                $("#tblMaualDocument tr").slice(1).remove();

                                $("#fileManualUpload").val('');
                                $("#ddlDocumentType").prop('selectedIndex', 0);
                                $('#spnDocumentMaualCounts').text($("#tblMaualDocument tr").length - 1);
                            });
                        }));
                    }
                },
                processData: false,
                contentType: false,
                error: function () {
                    alert("something went wrong!");
                }
            });
        }
        function removeMaualDocument(rowID) {
            serverCall('../Common/Services/CommonServices.asmx/deletePatientDocument', { deletePath: $(rowID).closest('tr').find("#tdManualFileURL").text(), ID: $(rowID).closest('tr').find("#tdMaualID").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $(rowID).closest('tr').remove();
                    toast("Success", $responseData.response, "");
                    $('#spnDocumentMaualCounts').text($("#tblMaualDocument tr").length - 1);
                }
                else {
                    toast("Error", $responseData.response, "");
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
        function manualViewDocument(rowID) {
            serverCall('Lab_PrescriptionOPD.aspx/manualEncryptDocument', { fileName: $(rowID).closest('tr').find("#tdMaualAttachedFile").text(), filePath: $(rowID).closest('tr').find("#tdManualFileURL").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PostQueryString($responseData, '../Lab/ViewDocument.aspx');
                }
            });
        }
        $bindPatientDocumnet = function (PatientID) {
            serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: $('#txtLedgertransactionNo').val(), Filename: '', PatientID: PatientID, oldPatientSearch: 1, documentDetailID: 0, isEdit: 1 }, function (response) {
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
        function $requiredFields(rowID) {
            $("#spnSavingType").text('0');
            if ($("#txtLabNo").val() == "") {
                toast('Info', "Please Enter Lab No.", '');
                return;
            }
            $bindAllRequiredField();
        }
        function $checkRequiredField() {
            var field = [];
            var requiredFiled = [];
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    if ($.trim($(this).closest("tr").find("#tdRequiredFields").text()) != "") {
                        field.push($(this).closest("tr").find("#tdRequiredFields").text());
                    }
                }
            }
            );
            if (field.length > 0) {
                for (var i = 0; i < field.length ; i++) {
                    requiredFiled.push(field[i]);
                }
                var uniqueNames = [];
                $.each(requiredFiled, function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                return uniqueNames.join(',');
            }
            else {
                return "";
            }
        }
        function $bindAllRequiredField() {
            var requiredFiled = $checkRequiredField();
            if (requiredFiled == "") {
                showerrormsg("No Required Field Tagged With Selected Test");
                return;
            }         
            $bindRequiredFieldData(requiredFiled)
        }

        function $bindRequiredFieldData(requiredFiled) {
            $('#tblRequiredField tr').remove();
            var _temp = [];
            _temp.push(serverCall('Lab_PrescriptionOPDEdit.aspx/bindAllRequiredField', { requiredFiled: requiredFiled, LabNo: $("#txtLedgertransactionNo").val() }, function (response) {
                $.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    for (var i = 0; i <= $ReqData.length - 1; i++) {
                        var $mydata = [];
                        $mydata.push("<tr id='"); $mydata.push($ReqData[i].id); $mydata.push("'");
                        $mydata.push(' style="background-color:lightgoldenrodyellow;" class="my'); $mydata.push(i); $mydata.push('">');
                        $mydata.push('<td align="left" id="tdRequiredFiledName" class="GridViewLabItemStyle" style="font-weight:bold;"  >');
                        $mydata.push($ReqData[i].FieldName);
                        $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdRequiredInput" class="GridViewLabItemStyle" >');
                        if ($ReqData[i].InputType == "TextBox") {
                            $mydata.push('<input type="text" class="clRequiredInput requiredField" style="width:70px;" value="');
                            $mydata.push($ReqData[i].FieldValue); $mydata.push('"');
                            $mydata.push('/>');
                        }
                        else if ($ReqData[i].InputType == "DropDownList") {
                            $mydata.push('<select style="width:70px;" class="clRequiredInput requiredField ddlRequiredDropDown_');
                            $mydata.push(i); $mydata.push('">');
                            for (var a = 0; a <= $ReqData[i].DropDownOption.split('|').length - 1; a++) {
                                $mydata.push('<option value="'); $mydata.push($ReqData[i].DropDownOption.split('|')[a]); $mydata.push('">');
                                $mydata.push($ReqData[i].DropDownOption.split('|')[a]);
                                $mydata.push('</option>');
                            }
                            $mydata.push('</select>');
                        }
                        else if ($ReqData[i].InputType == "CheckBox") {
                            if ($ReqData[i].FieldValue == "1") {
                                $mydata.push('<input type="checkbox"  class="clRequiredInput" checked="checked"/>');
                            }
                            else {
                                $mydata.push('<input type="checkbox"  class="clRequiredInput" />');
                            }
                        }
                        else if ($ReqData[i].InputType == "Date") {                            
                            if ($ReqData[i].FieldValue != "") {
                                $mydata.push('<input type="text" class="clRequiredInput requiredField" style="width:140px;" value="');
                                $mydata.push($ReqData[i].FieldValue); $mydata.push('"');
                                $mydata.push('/>');
                            }
                            else {
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
                        }
                        if ($ReqData[i].Unit != "") {
                            $mydata.push('<select style="width:70px;"  class="unit ddlRequiredUnit_');
                            $mydata.push(i); $mydata.push('">');
                            for (var a = 0; a <= $ReqData[i].Unit.split('|').length - 1; a++) {
                                $mydata.push('<option value="'); $mydata.push($ReqData[i].Unit.split('|')[a]); $mydata.push('">');
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
                        $mydata.push('<td align="left" id="tdRequiredSavedUnit" class="GridViewLabItemStyle" style="display:none;"  >');
                        $mydata.push($ReqData[i].savedUnit);
                        $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdRequiredFieldValue" class="GridViewLabItemStyle" style="display:none;"  >');
                        $mydata.push($ReqData[i].FieldValue);
                        $mydata.push('</td>');
                        $mydata.push("</tr>");
                        $mydata = $mydata.join("");
                        $('#tblRequiredField').append($mydata);
                        jQuery("#txtappdate" + $ReqData[i].id).datepicker({
                            dateFormat: "dd-M-yy"
                        });
                        jQuery('#ui-datepicker-div').css('z-index', '999999');
                        if ($ReqData[i].Unit != "") {
                            $("".concat(".ddlRequiredUnit_", i)).val($ReqData[i].savedUnit);

                        }
                        if ($ReqData[i].InputType == "DropDownList") {
                            if ($ReqData[i].FieldValue != "") {
                                $("".concat(".ddlRequiredDropDown_", i)).val($ReqData[i].FieldValue);
                            }
                        }
                    }
                    $('#divRequiredField').showModel();
                    $('.my0').find('#tdRequiredInput').find('.clRequiredInput').focus();
                });
                $modelUnBlockUI();

                return;
            }));

        }
        var $closeRequiredFieldsModel = function (callback) {
            $('#divRequiredField').hideModel();
        }
        function $saveRequiredField(btnSave, buttonVal) {
            var $sn = 0;
            var $fieldName = "";
            var $SCAN_DATE = "";
            var $samplecollectiondate = "";
            var $GESTATIONAL_WEEK = "";
            var $GESTATIONAL_DAYS = "";           
       
            $('#tblRequiredField tr').each(function () {
                if ($(this).find('#tdRequiredInput').find('.clRequiredInput').val() == "") {
                    $sn = 1;
                    $fieldName = $(this).find('#tdRequiredFiledName').text();
                    $(this).find('#tdRequiredInput').find('.clRequiredInput').focus();
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
            var $RequiredField = requiredfiled();

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

            $(btnSave).attr('disabled', true).val('Submitting...');
            if ($("#spnSavingType").text() == "0") {
                serverCall('Lab_PrescriptionOPDEdit.aspx/SaveRequiredField', { RequiredField: $RequiredField }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                        $('#divRequiredField').hideModel();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }                  
                });
            }
            else {
                $("#btnSaveRequired").attr('disabled', true).val("Submiting...");
                $closeRequiredFieldsModel();
                $updateLabPrescriptionData(function (btnSave, buttonVal) { });
                $('#btnSaveRequired').attr('disabled', false).val("Save");
            }
            $(btnSave).removeAttr('disabled').val(buttonVal);
        }
            function requiredfiled() {
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
                    objRequ.LedgerTransactionID = $("#txtLedgertransactionID").val();
                    objRequ.LedgerTransactionNo = $("#txtLedgertransactionNo").val();
                    datarequired.push(objRequ);
                });
                return datarequired;
            }
        //sunil
            function setd() {
                var d = new Date();
                var m_names = new Array("Jan", "Feb", "Mar",
       "Apr", "May", "Jun", "Jul", "Aug", "Sep",
       "Oct", "Nov", "Dec");
                var yyyy = d.getFullYear();
                var MM = d.getMonth();
                var dd = d.getDate();
                var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
                return xxx;
            }
            minTwoDigits = function (n) {
                return (n < 10 ? '0' : '') + n;
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
            function GetUrgentTAT(ctrl) {
                debugger;
                var $InvID = $(ctrl).closest('tr').attr('id');
                var $Olddeliverydate = jQuery(ctrl).closest('tr').find('#tdDeliveryDateold').html();
                var $CentreID = $('#txtCentreData').val();
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
                $updatePaymentAmount();

            }
    </script></form>
</body></html>

