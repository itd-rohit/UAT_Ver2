<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CovidRegistration.aspx.cs" Inherits="Design_Lab_CovidRegistration" %>
<form id="add_record" action="" method="post" enctype="multipart/form-data">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
					  	<h3 class="box-title"><b>Patient Information</b></h3>
					</div><!-- /.box-header -->
                    	
                    <div class="box-body">
                        <div class="col-md-12">
							<div class="form-group">
								<input type="radio" class="community_hospital" name="community_hospital" id="hospital" value="hospital" checked="checked">&nbsp; For Hospital Settings  
								<input type="radio" class="community_hospital" name="community_hospital" id="community" value="community">&nbsp; For Community Settings  
							</div>
							<p><span class="text-danger"><b>* Please Note - Hospital Settings</b> is for the patients visiting OPD, IPD and Emergency and<b> Community Settings</b> is for patients under containment zone/ Non-containment area/ Point of entry/ Testing on demand</span></p>
						</div>
                    </div>
					<div class="box-body">												
						<div class="col-md-6">
                             <div class="form-group">
								<label for="patient_name">Patient Name</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control" name="patient_name" id="patient_name" placeholder="Patient Name">
						</div>
							<div class="form-group">
								<label for="patient_id">Patient ID</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control" name="patient_id" id="patient_id" placeholder="Patient ID">
							</div>
                           
							<div class="form-group">
								<label for="age">Age in</label><span class="text-danger"><b> *</b></span>&emsp;
								<input type="radio" class="age_in" name="age_in" id="age_year" value="Years" checked="checked">&nbsp; Years &emsp;
								<input type="radio" class="age_in" name="age_in" id="age_month" value="Months">&nbsp; Months &emsp;
								<input type="radio" class="age_in" name="age_in" id="age_day" value="Days">&nbsp; Days &emsp;
								<div class="input-group">
									<input type="text" class="form-control" name="age" id="age" maxlength="2" placeholder="Age in Years">
									<span class="input-group-addon" id="age_addon">Years</span>
								</div>
							</div>
							<div class="form-group">
								<label for="gender">Gender</label><span class="text-danger"><b> *</b></span>
								<select name="gender" id="gender" class="form-control">
									<option value="">Select Gender</option>
									<option value="M">Male</option>
									<option value="F">Female</option>
									<option value="T">Transgender</option>
								</select>
							</div>
							<div class="form-group">
								<label for="contact_number">Mobile</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control" name="contact_number" id="contact_number" placeholder="Contact Number" maxlength="10">
							</div>
                            <div class="form-group">
								<label for="contact_number_belongs_to">Mobile Number Belongs To</label><span class="text-danger"><b> *</b></span>
								<select name="contact_number_belongs_to" id="contact_number_belongs_to" class="form-control">
									<option value="">Select to Whom Mobile Number Belongs To</option>
									<option value="patient">Patient</option>
									<option value="relative">Relative</option><!--
									<option value="Others">Others</option>-->
								</select>
							</div>
							<%--<div class="form-group">
								<label for="email">Email</label>
								<input type="text" class="form-control" name="email" id="email" placeholder="Email">
						    </div>--%>
							<div class="form-group" id="aadhar_div">
								<label for="aadhar_number">Patient Aadhaar Number</label>
								<input type="text" class="form-control" name="aadhar_number" id="aadhar_number" placeholder="Aadhaar Number" maxlength="12">
							</div>
                            <div class="form-group" id="SRFNO_div">
								<label for="SRFNO">SRF No</label>
								<%--<input type="text" class="form-control" name="SRFNO" id="SRFNO" placeholder="SRF No" maxlength="20">--%>
                                    
									<div class="input-group">
                <input type="text" class="form-control" name="SRFNO" id="SRFNO" placeholder="SRF No" maxlength="20">
                    <span class="input-group-btn" >
                      <button type="button" onclick="postCovidData(0);"  class="btn btn-warning btn-flat">Update</button>
                    </span>
              </div>
							</div>				
                            <div class="form-group">
								<label for="nationality">Nationality</label><span class="text-danger"><b> *</b></span>
								<select name="nationality" id="nationality" class="form-control">
									<option value='Afghanistan'>Afghanistan</option><option value='Albania'>Albania</option><option value='Algeria'>Algeria</option><option value='American Samoa'>American Samoa</option><option value='Andorra'>Andorra</option><option value='Angola'>Angola</option><option value='Anguilla'>Anguilla</option><option value='Antarctica'>Antarctica</option><option value='Antigua and Barbuda'>Antigua and Barbuda</option><option value='Argentina'>Argentina</option><option value='Armenia'>Armenia</option><option value='Aruba'>Aruba</option><option value='Australia'>Australia</option><option value='Austria'>Austria</option><option value='Azerbaijan'>Azerbaijan</option><option value='Bahamas'>Bahamas</option><option value='Bahrain'>Bahrain</option><option value='Bangladesh'>Bangladesh</option><option value='Barbados'>Barbados</option><option value='Belarus'>Belarus</option><option value='Belgium'>Belgium</option><option value='Belize'>Belize</option><option value='Benin'>Benin</option><option value='Bermuda'>Bermuda</option><option value='Bhutan'>Bhutan</option><option value='Bolivia'>Bolivia</option><option value='Bosnia and Herzegovina'>Bosnia and Herzegovina</option><option value='Botswana'>Botswana</option><option value='Bouvet Island'>Bouvet Island</option><option value='Brazil'>Brazil</option><option value='British Indian Ocean Territory'>British Indian Ocean Territory</option><option value='Brunei Darussalam'>Brunei Darussalam</option><option value='Bulgaria'>Bulgaria</option><option value='Burkina Faso'>Burkina Faso</option><option value='Burundi'>Burundi</option><option value='Cambodia'>Cambodia</option><option value='Cameroon'>Cameroon</option><option value='Canada'>Canada</option><option value='Cape Verde'>Cape Verde</option><option value='Cayman Islands'>Cayman Islands</option><option value='Central African Republic'>Central African Republic</option><option value='Chad'>Chad</option><option value='Chile'>Chile</option><option value='China'>China</option><option value='Christmas Island'>Christmas Island</option><option value='Cocos (Keeling) Islands'>Cocos (Keeling) Islands</option><option value='Colombia'>Colombia</option><option value='Comoros'>Comoros</option><option value='Democratic Republic of the Congo'>Democratic Republic of the Congo</option><option value='Republic of Congo'>Republic of Congo</option><option value='Cook Islands'>Cook Islands</option><option value='Costa Rica'>Costa Rica</option><option value='Croatia (Hrvatska)'>Croatia (Hrvatska)</option><option value='Cuba'>Cuba</option><option value='Cyprus'>Cyprus</option><option value='Czech Republic'>Czech Republic</option><option value='Denmark'>Denmark</option><option value='Djibouti'>Djibouti</option><option value='Dominica'>Dominica</option><option value='Dominican Republic'>Dominican Republic</option><option value='East Timor'>East Timor</option><option value='Ecuador'>Ecuador</option><option value='Egypt'>Egypt</option><option value='El Salvador'>El Salvador</option><option value='Equatorial Guinea'>Equatorial Guinea</option><option value='Eritrea'>Eritrea</option><option value='Estonia'>Estonia</option><option value='Ethiopia'>Ethiopia</option><option value='Falkland Islands (Malvinas)'>Falkland Islands (Malvinas)</option><option value='Faroe Islands'>Faroe Islands</option><option value='Fiji'>Fiji</option><option value='Finland'>Finland</option><option value='France'>France</option><option value='France, Metropolitan'>France, Metropolitan</option><option value='French Guiana'>French Guiana</option><option value='French Polynesia'>French Polynesia</option><option value='French Southern Territories'>French Southern Territories</option><option value='Gabon'>Gabon</option><option value='Gambia'>Gambia</option><option value='Georgia'>Georgia</option><option value='Germany'>Germany</option><option value='Ghana'>Ghana</option><option value='Gibraltar'>Gibraltar</option><option value='Guernsey'>Guernsey</option><option value='Greece'>Greece</option><option value='Greenland'>Greenland</option><option value='Grenada'>Grenada</option><option value='Guadeloupe'>Guadeloupe</option><option value='Guam'>Guam</option><option value='Guatemala'>Guatemala</option><option value='Guinea'>Guinea</option><option value='Guinea-Bissau'>Guinea-Bissau</option><option value='Guyana'>Guyana</option><option value='Haiti'>Haiti</option><option value='Heard and Mc Donald Islands'>Heard and Mc Donald Islands</option><option value='Honduras'>Honduras</option><option value='Hong Kong'>Hong Kong</option><option value='Hungary'>Hungary</option><option value='Iceland'>Iceland</option><option value='India' selected>India</option><option value='Isle of Man'>Isle of Man</option><option value='Indonesia'>Indonesia</option><option value='Iran (Islamic Republic of)'>Iran (Islamic Republic of)</option><option value='Iraq'>Iraq</option><option value='Ireland'>Ireland</option><option value='Israel'>Israel</option><option value='Italy'>Italy</option><option value='Ivory Coast'>Ivory Coast</option><option value='Jersey'>Jersey</option><option value='Jamaica'>Jamaica</option><option value='Japan'>Japan</option><option value='Jordan'>Jordan</option><option value='Kazakhstan'>Kazakhstan</option><option value='Kenya'>Kenya</option><option value='Kiribati'>Kiribati</option><option value='Korea, Democratic People's Republic of'>Korea, Democratic People's Republic of</option><option value='Korea, Republic of'>Korea, Republic of</option><option value='Kosovo'>Kosovo</option><option value='Kuwait'>Kuwait</option><option value='Kyrgyzstan'>Kyrgyzstan</option><option value='Lao People's Democratic Republic'>Lao People's Democratic Republic</option><option value='Latvia'>Latvia</option><option value='Lebanon'>Lebanon</option><option value='Lesotho'>Lesotho</option><option value='Liberia'>Liberia</option><option value='Libyan Arab Jamahiriya'>Libyan Arab Jamahiriya</option><option value='Liechtenstein'>Liechtenstein</option><option value='Lithuania'>Lithuania</option><option value='Luxembourg'>Luxembourg</option><option value='Macau'>Macau</option><option value='North Macedonia'>North Macedonia</option><option value='Madagascar'>Madagascar</option><option value='Malawi'>Malawi</option><option value='Malaysia'>Malaysia</option><option value='Maldives'>Maldives</option><option value='Mali'>Mali</option><option value='Malta'>Malta</option><option value='Marshall Islands'>Marshall Islands</option><option value='Martinique'>Martinique</option><option value='Mauritania'>Mauritania</option><option value='Mauritius'>Mauritius</option><option value='Mayotte'>Mayotte</option><option value='Mexico'>Mexico</option><option value='Micronesia, Federated States of'>Micronesia, Federated States of</option><option value='Moldova, Republic of'>Moldova, Republic of</option><option value='Monaco'>Monaco</option><option value='Mongolia'>Mongolia</option><option value='Montenegro'>Montenegro</option><option value='Montserrat'>Montserrat</option><option value='Morocco'>Morocco</option><option value='Mozambique'>Mozambique</option><option value='Myanmar'>Myanmar</option><option value='Namibia'>Namibia</option><option value='Nauru'>Nauru</option><option value='Nepal'>Nepal</option><option value='Netherlands'>Netherlands</option><option value='Netherlands Antilles'>Netherlands Antilles</option><option value='New Caledonia'>New Caledonia</option><option value='New Zealand'>New Zealand</option><option value='Nicaragua'>Nicaragua</option><option value='Niger'>Niger</option><option value='Nigeria'>Nigeria</option><option value='Niue'>Niue</option><option value='Norfolk Island'>Norfolk Island</option><option value='Northern Mariana Islands'>Northern Mariana Islands</option><option value='Norway'>Norway</option><option value='Oman'>Oman</option><option value='Pakistan'>Pakistan</option><option value='Palau'>Palau</option><option value='Palestine'>Palestine</option><option value='Panama'>Panama</option><option value='Papua New Guinea'>Papua New Guinea</option><option value='Paraguay'>Paraguay</option><option value='Peru'>Peru</option><option value='Philippines'>Philippines</option><option value='Pitcairn'>Pitcairn</option><option value='Poland'>Poland</option><option value='Portugal'>Portugal</option><option value='Puerto Rico'>Puerto Rico</option><option value='Qatar'>Qatar</option><option value='Reunion'>Reunion</option><option value='Romania'>Romania</option><option value='Russian Federation'>Russian Federation</option><option value='Rwanda'>Rwanda</option><option value='Saint Kitts and Nevis'>Saint Kitts and Nevis</option><option value='Saint Lucia'>Saint Lucia</option><option value='Saint Vincent and the Grenadines'>Saint Vincent and the Grenadines</option><option value='Samoa'>Samoa</option><option value='San Marino'>San Marino</option><option value='Sao Tome and Principe'>Sao Tome and Principe</option><option value='Saudi Arabia'>Saudi Arabia</option><option value='Senegal'>Senegal</option><option value='Serbia'>Serbia</option><option value='Seychelles'>Seychelles</option><option value='Sierra Leone'>Sierra Leone</option><option value='Singapore'>Singapore</option><option value='Slovakia'>Slovakia</option><option value='Slovenia'>Slovenia</option><option value='Solomon Islands'>Solomon Islands</option><option value='Somalia'>Somalia</option><option value='South Africa'>South Africa</option><option value='South Georgia South Sandwich Islands'>South Georgia South Sandwich Islands</option><option value='South Sudan'>South Sudan</option><option value='Spain'>Spain</option><option value='Sri Lanka'>Sri Lanka</option><option value='St. Helena'>St. Helena</option><option value='St. Pierre and Miquelon'>St. Pierre and Miquelon</option><option value='Sudan'>Sudan</option><option value='Suriname'>Suriname</option><option value='Svalbard and Jan Mayen Islands'>Svalbard and Jan Mayen Islands</option><option value='Swaziland'>Swaziland</option><option value='Sweden'>Sweden</option><option value='Switzerland'>Switzerland</option><option value='Syrian Arab Republic'>Syrian Arab Republic</option><option value='Taiwan'>Taiwan</option><option value='Tajikistan'>Tajikistan</option><option value='Tanzania, United Republic of'>Tanzania, United Republic of</option><option value='Thailand'>Thailand</option><option value='Togo'>Togo</option><option value='Tokelau'>Tokelau</option><option value='Tonga'>Tonga</option><option value='Trinidad and Tobago'>Trinidad and Tobago</option><option value='Tunisia'>Tunisia</option><option value='Turkey'>Turkey</option><option value='Turkmenistan'>Turkmenistan</option><option value='Turks and Caicos Islands'>Turks and Caicos Islands</option><option value='Tuvalu'>Tuvalu</option><option value='Uganda'>Uganda</option><option value='Ukraine'>Ukraine</option><option value='United Arab Emirates'>United Arab Emirates</option><option value='United Kingdom'>United Kingdom</option><option value='United States'>United States</option><option value='United States minor outlying islands'>United States minor outlying islands</option><option value='Uruguay'>Uruguay</option><option value='Uzbekistan'>Uzbekistan</option><option value='Vanuatu'>Vanuatu</option><option value='Vatican City State'>Vatican City State</option><option value='Venezuela'>Venezuela</option><option value='Vietnam'>Vietnam</option><option value='Virgin Islands (British)'>Virgin Islands (British)</option><option value='Virgin Islands (U.S.)'>Virgin Islands (U.S.)</option><option value='Wallis and Futuna Islands'>Wallis and Futuna Islands</option><option value='Western Sahara'>Western Sahara</option><option value='Yemen'>Yemen</option><option value='Zambia'>Zambia</option><option value='Zimbabwe'>Zimbabwe</option>								</select>
							</div>
							 							
							<div class="form-group"> 
								<div class="form-group">
									<label for="state">State of Residence</label><span class="text-danger"><b> *</b></span>
									<select name="state" id="state" class="form-control" placeholder="Select Any One">
										<option value=''>Select State/UT</option><option value='35'>ANDAMAN AND NICOBAR ISLANDS</option><option value='28'>ANDHRA PRADESH</option><option value='12'>ARUNACHAL PRADESH</option><option value='18'>ASSAM</option><option value ='10'>BIHAR</option><option value='4'>CHANDIGARH</option><option value='22'>CHHATTISGARH</option><option value='26'>DADRA AND NAGAR HAVELI</option><option value='25'>DAMAN AND DIU</option><option value ='7'>DELHI</option><option value='30'>GOA</option><option value='24'>GUJARAT</option><option value='6'>HARYANA</option><option value= ='2'>HIMACHAL PRADESH</option><option value ='1'>JAMMU AND KASHMIR</option><option value ='20'>JHARKHAND</option><option value='29'>KARNATAKA</option><option value ='32'>KERALA</option><option value='37'>LADAKH</option><option value ='31'>LAKSHADWEEP</option><option value='23'>MADHYA PRADESH</option><option value ='27'>MAHARASHTRA</option><option value='14'>MANIPUR</option><option value ='17'>MEGHALAYA</option><option value='15'>MIZORAM</option><option value ='13'>NAGALAND</option><option value='21'>ODISHA</option><option value='34'>PUDUCHERRY</option><option value='3'>PUNJAB</option><option value='8'>RAJASTHAN</option><option value='11'>SIKKIM</option><option value='33'>TAMIL NADU</option><option value='36'>TELANGANA</option><option value='16'>TRIPURA</option><option value='9'>UTTAR PRADESH</option><option value='5'>UTTARAKHAND</option><option value='19'>WEST BENGAL</option>									</select>
									<input type="hidden" name="state_code" id="state_code" value="">
								</div>
							</div>			
							<div class="form-group">
								<label for="district">District of Residence</label><span class="text-danger"><b> *</b></span>
								<select name="district" id="district" class="form-control">
									<option value=''>Select District</option>
								</select>
								<input type="hidden" name="district_code" id="district_code" value="">
							</div>
							<div class="form-group">
								<label for="remarks">Patient Address</label>
							    <textarea class="form-control" name="address" id="address" rows="3" placeholder="Address"></textarea>
						    </div>
                            <%--<div class="form-group">
								<label for="village_name">Patient's Village or Town</label>
								<input type="text" class="form-control" name="village_town" id="village_town" placeholder="village or town">
							</div>		--%>	
								
							
							
							<div class="form-group">
								<label for="remarks">Patient Pincode</label>
								<input type="text" class="form-control" name="pincode" id="pincode" maxlength="6" placeholder="Patient Pincode">
						    </div>
							
							<%--<div class="form-group">
								<label for="date_of_arrival_in_india">Date of Arrival in India</label>
								<input type="text" class="form-control datepicker" name="date_of_arrival_in_india" id="date_of_arrival_in_india" placeholder="Date of Arrival in India" readonly>
							</div>--%><!--
							<div class="form-group">
								<label for="are_you_healthcare_worker">Are you a healthcare worker involved in managing COVID-19 patient?</label>
								<select name="are_you_healthcare_worker" id="are_you_healthcare_worker" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
							<div class="form-group">
								<label for="ri_ili">Resiratory Infection: Influenza Like Illness(ILI)</label><span class="text-danger"><b> *</b></span>
								<select name="ri_ili" id="ri_ili" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
							<div class="form-group">
								<label for="contact_with_lab_confirmed_patient">Have you been in contact with lab confirmed COVID-19 patient?</label>
								<select name="contact_with_lab_confirmed_patient" id="contact_with_lab_confirmed_patient" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
							<div class="form-group">
								<div class="form-group">
									<label for="confirmed_patient_name_if_contact_made">Name of Lab Confirmed Patient</label>
									<textarea class="form-control" id="confirmed_patient_name_if_contact_made" name="confirmed_patient_name_if_contact_made" style="height:34px;" placeholder="Confirmed Patient name if contact made" readonly></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="quarantined_where">Where were you quarantined?</label><span class="text-danger"><b> *</b></span>
								<select name="quarantined_where" id="quarantined_where" class="form-control" style="pointer-events: none;">
									<option value="">Select Any One</option>
									<option value="Home">Home</option>
									<option value="Facility">Facility</option>
								</select>
							</div>-->
							<%--<div class="form-group">
								<label for="quarantined">Was the patient quarantined?</label><span class="text-danger"><b> *</b></span>
								<select name="quarantined" id="quarantined" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>--%>
							<div class="form-group hidden">
								<label for="others_patients_category">Patient Category (Please specify if Other is selected)</label>
								<input type="text" class="form-control" name="others_patients_category" id="others_patients_category" disabled placeholder="Enter Patient Category if the patient doesn’t belong to category 1-9) ">
						    </div>
							<div class="form-group">
								<input type="hidden" class="form-control" name="final_status" id="final_status" value="">
							</div>	
							<div class="form-group hidden" id="passport_div">
								<label for="passport_number">Patient Passport number</label>
								<input type="text" class="form-control" name="passport_number" id="passport_number" placeholder="Passport Number" maxlength="13">
							</div>	
                            			
							
															
                           <!--
							<div class="form-group">
								<label for="ri_sari">Resiratory Infection: Severe Acute Respiratory Illness(SARI)</label><span class="text-danger"><b> *</b></span>
								<select name="ri_sari" id="ri_sari" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
							<div class="form-group">
								<label for="travel_to_foreign_country">Did you travel to foreign country in last 14 days?</label><span class="text-danger"><b> *</b></span>
								<select name="travel_to_foreign_country" id="travel_to_foreign_country" class="form-control">
									<option value="">Select Foreign Travel History</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
							<div class="form-group">
								<div class="form-group">
									<label for="travel_history">Places of Travel</label>
									<textarea class="form-control" id="travel_history" name="travel_history" style="height:34px;" placeholder="Places of Travel" readonly></textarea>
								</div>
							</div>-->
						</div>
						<div class="col-md-6">
                            <div class="form-group">
								<label for="father_name">Father's Name</label>
								<input type="text" class="form-control" name="father_name" id="father_name" placeholder="Father's Name">
						    </div>
                            <div class="form-group">
								<label for="patient_occupation">Patient's Occupation</label><span class="text-danger"><b> *</b></span>
								<select name="patient_occupation" id="patient_occupation" class="form-control">
									<option value="">Select Any One</option>
									<option value="HCW">Health Care Worker</option>
									<option value="POLICE">Police</option>
									<option value="SNTN">Sanitation</option>
									<option value="SECG">Security Guards</option>
									<option value="OTHER">Others</option>
								</select>
							</div>
                            <div class="form-group">
								<label for="aarogya_setu_app_downloaded">Aarogya Setu App Downloaded?</label><span class="text-danger"><b> *</b></span>
								<select name="aarogya_setu_app_downloaded" id="aarogya_setu_app_downloaded" class="form-control">
									<option value="">Select Any One</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
                            <div class="form-group">
								<label for="contact_with_lab_confirmed_patient">Has patient been comes in contact with a lab-confirmed case</label>
						    	<select class="form-control" name="contact_with_lab_confirmed_patient" id="contact_with_lab_confirmed_patient">
									<option value="">Select</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</div>
								<div class="form-group">
								<label for="Patient Category">Patient Category</label><span class="text-danger"><b> *</b></span>
								<table class="table">
									<tbody><tr class="community_settings" style="display: none;">
										<td><input type="radio" name="patient_category" id="ncat1" value="NCat1"></td>
										<td><b>Category 1:</b> All symptomatic (ILI symptoms) cases.</td>
									</tr>
									<tr class="community_settings" style="display: none;">
										<td><input type="radio" name="patient_category" id="ncat3" value="NCat3"></td>
										<td><b>Category 2:</b> All asymptomatic high-risk individuals.</td>
									</tr>
									<tr class="community_settings" style="display: none;">
										<td><input type="radio" name="patient_category" id="ncat4" value="NCat4"></td>
										<td><b>Category 3:</b> All symptomatic (ILI symptoms) individuals with history of international travel in the last 14 days.</td>
									</tr>
									<tr class="community_settings" style="display: none;">
										<td><input type="radio" name="patient_category" id="ncat17" value="NCat17"></td>
										<td><b>Category 4:</b> All individuals who wish to get themselves tested.</td>
									</tr><!--
									<tr>
										<td><input type="radio" name="patient_category" id="ncat2" value="NCat2"></td>
										<td><b>Category 2:</b> All asymptomatic direct and high-risk contacts (in family and workplace, elderly ≥ 65 years of age, immunocompromised, those with co-morbidities etc.) of a laboratory confirmed case to be tested once between day 5 and day 10 of coming into contact.</td>
									</tr>
									<tr>
										<td><input type="radio" name="patient_category" id="ncat5" value="NCat5"></td>
										<td><b>Category 5:</b> All symptomatic (ILI symptoms) contacts of a laboratory confirmed case.</td>
									</tr>
									<tr>
										<td><input type="radio" name="patient_category" id="ncat6" value="NCat6"></td>
										<td><b>Category 6:</b> All symptomatic (ILI symptoms) health care workers / frontline workers involved in containment and mitigation activities.</td>
									</tr>
									<tr>
										<td><input type="radio" name="patient_category" id="ncat7" value="NCat7"></td>
										<td><b>Category 7:</b> All symptomatic ILI cases among returnees and migrants within 7 days of illness.</td>
									</tr>
									<tr>
										<td><input type="radio" name="patient_category" id="ncat8" value="NCat8"></td>
										<td><b>Category 8:</b> All asymptomatic high-risk contacts (contacts in family and workplace, elderly ≥ 65 years of age, those with co-morbidities etc.</td>
									</tr>-->
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat9" value="NCat9"></td>
										<td><b>Category 1:</b> All patients of Severe Acute Respiratory Infection (SARI).</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat10" value="NCat10"></td>
										<td><b>Category 2:</b> All symptomatic (ILI symptoms) patients presenting in a healthcare setting.</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat11" value="NCat11"></td>
										<td><b>Category 3:</b> Asymptomatic high-risk patients who are hospitalized or seeking immediate hospitalization.</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat12" value="NCat12"></td>
										<td><b>Category 4:</b> Asymptomatic patients undergoing surgical / non-surgical invasive procedures (not to be tested more than once a week during hospital stay).</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat13" value="NCat13"></td>
										<td><b>Category 5:</b> All pregnant women in/near labour who are hospitalized for delivery.</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat14" value="NCat14"></td>
										<td><b>Category 6:</b> All symptomatic neonates presenting with acute respiratory / sepsis like illness.</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat15" value="NCat15"></td>
										<td><b>Category 7:</b> Patients presenting with atypical manifestations.[stroke, encephalitis, pulmonary embolism, acute coronary symptoms, Guillain Barre syndrome, Multi-system Inflammatory Syndrome in Children (MIS-C), progressive   gastrointestinal   symptoms]</td>
									</tr>
									<tr class="hospital_settings">
										<td><input type="radio" name="patient_category" id="ncat18" value="NCat18"></td>
										<td><b>Category 8:</b> All individuals who wish to get themselves tested.</td>
									</tr><!--
									<tr>
										<td><input type="radio" name="patient_category" id="ncat16" value="NCat16"></td>
										<td><b>Category 16:</b> All individuals undertaking travel to countries/Indian states mandating a negative COVID-19 test at point of entry.</td>
									</tr>-->
								</tbody></table>							
							</div>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header with-border">
					  	<h3 class="box-title"><b>Clinical Data</b></h3>
					</div><!-- /.box-header -->
					<div class="box-body">
						<div class="col-md-6">
							<div class="form-group">
								<label for="sample_cdate">Date and Time of Sample Collection</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control datetimepicker" name="sample_cdate" id="sample_cdate" placeholder="Date and Time of Sample Collection" readonly>
							</div>
							<div class="form-group">
								<label for="sample_type">Type of Sample</label><span class="text-danger"><b> *</b></span>
								<select name="sample_type" id="sample_type" class="form-control">
									<option value="">Select Sample Type</option>
									<option value="Nasopharyngeal_Oropharyngeal">Nasopharyngeal & Oropharyngeal</option>
									<option value="Nasopharyngeal swab">Nasopharyngeal swab</option>
									<option value="Oropharyngeal swab">Oropharyngeal swab</option>
									<option value="Nasal swab">Nasal swab</option>
									<option value="Throat swab">Throat swab</option>
									<option value="Sputum">Sputum</option>
									<option value="BAL">BAL</option>
									<option value="ETA">ETA</option>
								</select>
								<!--
									<option value="Acute sera">Acute sera</option>
									<option value="Covalescent sera">Covalescent sera</option>
									<option value="Blood">Blood</option>
									<option value="Stool">Stool</option>
								-->
							</div>
							<div class="form-group">
								<label for="status">Symptoms Status</label>
								<select name="status" id="status" class="form-control">
									<option value="">Select Status</option>
									<option value="Symptomatic">Symptomatic</option>
									<option value="Asymptomatic">Asymptomatic</option>
								</select>
							</div>
                           <div class="form-group">
								<label for="symptoms_details">Symptoms</label><br>
								<table class="table">
									<tbody><tr>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="fever" value="fever" >&nbsp;Fever</td>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="cough" value="cough" >&nbsp;Cough</td>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="diarrhoea" value="diarrhoea" >&nbsp;Diarrhoea</td>
									</tr>
									<tr>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="sore_throat" value="sore_throat" >&nbsp;Sore Throat</td>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="loss_of_taste" value="loss_of_taste" >&nbsp;Loss of Taste</td>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="loss_of_smell" value="loss_of_smell" >&nbsp;Loss of Smell</td>
									</tr>
									<tr>
									  <td><input class="symptoms" type="checkbox" name="symptoms[]" id="breathlessness" value="breathlessness" >&nbsp;Breathlessnesss</td>
									  <td colspan="3"><input class="symptoms" type="checkbox" name="symptoms[]" id="other_symptom" value="other" >&nbsp;&nbsp;Other</td>
									</tr>
								</tbody></table>
							</div>
							<div class="form-group">
								<label for="other_symptoms">Other Symptoms(If not mentioned above)</label>
								<input type="text" class="form-control" name="other_symptoms" id="other_symptoms" placeholder="Other Symptoms" readonly="">
							</div>
                            <div class="form-group">
								<label for="sample_collected_from">Sample Collected From</label><span class="text-danger"><sup><b> #</b></sup></span>
								<select class="form-control" name="sample_collected_from" id="sample_collected_from" style="pointer-events: none;">
									<option value="">Select Any One (Only if Community settings is selected earlier)</option>
									<option value="Containment Zone">Containment Zone</option>
									<option value="Non-containment area">Non-containment area</option>
									<!--
									<option value="Testing on demand">Testing on demand</option>-->
									<option value="Point of entry">Point of entry</option>
								</select>
							</div>
							<div class="form-group">
								<label for="hospitalization_date">Date of Hospitalization</label>
								<input type="text" class="form-control datepicker" name="hospitalization_date" id="hospitalization_date" placeholder="Date of Hospitalization">
							</div>
							<div class="form-group">
								<label for="hospital_state">Hospital State</label>
								<select name="hospital_state" id="hospital_state" class="form-control" placeholder="Select Hospital State">
										<option value=''>Select State/UT</option><option value='35'>ANDAMAN AND NICOBAR ISLANDS</option><option value='28'>ANDHRA PRADESH</option><option value='12'>ARUNACHAL PRADESH</option><option value='18'>ASSAM</option><option value ='10'>BIHAR</option><option value='4'>CHANDIGARH</option><option value='22'>CHHATTISGARH</option><option value='26'>DADRA AND NAGAR HAVELI</option><option value='25'>DAMAN AND DIU</option><option value ='7'>DELHI</option><option value='30'>GOA</option><option value='24'>GUJARAT</option><option value='6'>HARYANA</option><option value= ='2'>HIMACHAL PRADESH</option><option value ='1'>JAMMU AND KASHMIR</option><option value ='20'>JHARKHAND</option><option value='29'>KARNATAKA</option><option value ='32'>KERALA</option><option value='37'>LADAKH</option><option value ='31'>LAKSHADWEEP</option><option value='23'>MADHYA PRADESH</option><option value ='27'>MAHARASHTRA</option><option value='14'>MANIPUR</option><option value ='17'>MEGHALAYA</option><option value='15'>MIZORAM</option><option value ='13'>NAGALAND</option><option value='21'>ODISHA</option><option value='34'>PUDUCHERRY</option><option value='3'>PUNJAB</option><option value='8'>RAJASTHAN</option><option value='11'>SIKKIM</option><option value='33'>TAMIL NADU</option><option value='36'>TELANGANA</option><option value='16'>TRIPURA</option><option value='9'>UTTAR PRADESH</option><option value='5'>UTTARAKHAND</option><option value='19'>WEST BENGAL</option>									</select>
							</div>
							<%--<div class="form-group">
								<label for="hospital_id">Hospital ID</label>
								<input type="text" class="form-control" name="hospital_id" id="hospital_id" placeholder="Enter ID assigned to Patient by Hospital">
							</div>
							<div class="form-group">
								<label for="doctor_mobile">Doctor's Mobile Number</label>
								<input type="text" class="form-control" name="doctor_mobile" id="doctor_mobile" value="" placeholder="Doctor's Mobile Number" maxlength="10">
							</div>--%>
							<div class="form-group">
								<label for="sample_tdate">Date and Time of Sample Tested</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control datetimepicker" name="sample_tdate" id="sample_tdate" placeholder="Date and Time of Sample Tested" readonly>
							</div>
							<div class="form-group">
								<label for="covid19_result_egene">E Gene/N Gene (ABI Kits only)/TrueNAT</label>
								<select name="covid19_result_egene" id="covid19_result_egene" class="form-control">
									<option value="">Select</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
									<option value="Under Process">Under Process</option>
									<option value="Inconclusive_Spillage_Rejected" disabled>Inconclusive/Spillage/Rejected</option>
								</select>
							</div>
							<div class="form-group">
								<label for="orf1b_confirmatory">ORF1a/ORF1b/N/N2 Gene(For Seegene & Cepheid)</label>
								<select name="orf1b_confirmatory" id="orf1b_confirmatory" class="form-control">
									<option value="">Select</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
									<option value="Under Process">Under Process</option>
									<option value="Inconclusive_Spillage_Rejected" disabled>Inconclusive/Spillage/Rejected</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="rdrp_confirmatory">RdRp/S Gene</label>
								<select name="rdrp_confirmatory" id="rdrp_confirmatory" class="form-control">
									<option value="">Select</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
									<option value="Under Process">Under Process</option>
									<option value="Inconclusive_Spillage_Rejected" disabled>Inconclusive/Spillage/Rejected</option>
								</select>
							</div>
							
							<div class="form-group has-error">
								<label for="final_result_of_sample" id="final_result_of_sample_label">Final Result of SARS-CoV2(COVID19) for this Sample</label><span class="text-danger"><b> *</b></span>
								<select name="final_result_of_sample" id="final_result_of_sample" class="form-control">
									<option value="">Select Final Result of SARS-CoV2</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
									<option value="Under Process">Under Process</option>
									<option value="Inconclusive">Inconclusive</option>
									<option value="Spillage">Spillage</option>
									<option value="Sample Rejected">Sample Rejected</option>
									<option value="TrueNAT Screening Positive">TrueNAT Screening Positive</option>
									<option value="TrueNAT Screening Negative">TrueNAT Screening Negative</option>
								</select>
							</div>
							
							<%--<div class="form-group">
								<label for="inf_a">Influenza A</label>
								<select name="inf_a" id="inf_a" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="pinf">Parainfluenza</label>
								<select name="pinf" id="pinf" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="h_metapneumovirus">Human Metapneumovirus</label>
								<select name="h_metapneumovirus" id="h_metapneumovirus" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							<div class="form-group">
								<label for="other_test_conducted">Other Test Conducted</label>
								<input type="text" class="form-control" name="other_test_conducted" id="other_test_conducted" placeholder="Other Test Conducted">
							</div>	
							<div class="form-group">
								<label for="2019ncov_samples">Result of Other Test Conducted</label>
								<select name="result_of_other_test" id="result_of_other_test" class="form-control">
									<option value="">Select</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							<div class="form-group">
								<label for="doctor_mobile">Doctor's Mobile Number</label>
								<input type="text" class="form-control" name="doctor_mobile" id="doctor_mobile" placeholder="Doctor's Mobile Number" maxlength="10">
							</div>--%>
                            <div class="form-group">
								<label for="mode_of_transport">Mode of Transport used to visit testing facility</label><span class="text-danger"><b> *</b></span>
								<select class="form-control" name="mode_of_transport" id="mode_of_transport">
									<option value="">Select Any One</option>
									<option value="NA">Not Applicable</option>
									<optgroup label="Public Transport">"&gt;
										<option value="Ambln">Ambulance</option>
										<option value="Bus">Bus</option>
										<option value="Metro">Metro</option>
										<option value="Train">Train</option>
										<option value="Cab">Cab</option>
										<option value="Auto">Auto</option>
									</optgroup>
									<optgroup label="Private Transport">
										<option value="Car">Car</option>
										<option value="Scoty">Scooty</option>
										<option value="Bike">Bike</option>
										<option value="Cycle">Bicycle</option>
										<option value="Walk">Walk</option>
									</optgroup>
								</select>
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group">
								<label for="sample_rdate">Date and Time of Sample Received</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control datetimepicker" name="sample_rdate" id="sample_rdate" placeholder="Date and Time of Sample Received" readonly>
							</div>
							<div class="form-group">
								<label for="sample_id">Sample ID</label><span class="text-danger"><b> *</b></span>
								<input type="text" class="form-control" name="sample_id" id="sample_id" placeholder="Sample ID of Specimen">
							</div>							
							<div class="form-group">
								<label for="date_of_onset_of_symptoms">Date of onset of Symptoms</label>
								<input type="text" class="form-control datepicker" name="date_of_onset_of_symptoms" id="date_of_onset_of_symptoms" placeholder="Date of onset of Symptoms">
							</div>							
							<div class="form-group">								
								<label for="underlying_medical_condition">Underlying Medical Condition</label><br>
								<table class="table">
									<tbody><tr>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="chronic_lung_disease" value="Chronic Lung Disease">&nbsp;&nbsp;Chronic Lung Disease</td>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="chronic_renal_disease" value="Chronic Renal Disease">&nbsp;&nbsp;Chronic Kidney Disease</td>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="diabetes" value="Diabetes">&nbsp;&nbsp;Diabetes</td>
									</tr>
									<tr>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="heart_disease" value="Heart Disease">&nbsp;&nbsp;Heart Disease</td>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="malignancy" value="Malignancy">&nbsp;&nbsp;Cancer</td>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="obesity" value="Obesity">&nbsp;&nbsp;Obesity</td>
									</tr>
									<tr>
										<td><input type="checkbox" name="underlying_medical_condition[]" id="hypertension" value="Hypertension">&nbsp;&nbsp;Hypertension</td>
										<td colspan="2"><input type="checkbox" name="underlying_medical_condition[]" id="other" value="Other">&nbsp;&nbsp;Other</td>
									</tr>
								</tbody></table>
							</div>
                            <div class="form-group">
								<label for="other_underlying_medical_conditions">Other Underlying Medical Conditions(If not mentioned above)</label>
								<input type="text" class="form-control" name="other_underlying_medical_conditions" id="other_underlying_medical_conditions" placeholder="Other Underlying Medical Conditions" readonly>
							</div>	
							<div class="form-group">
								<label for="hospitalized">Is Patient Hospitalized?</label><span class="text-danger"><b> *</b></span>
								<select name="hospitalized" id="hospitalized" class="form-control">
									<option value="">Select Any One</option>					
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select> 
							</div>
							<div class="form-group">
								<label for="hospital_name">Name of the Hospital</label>
								<input type="text" class="form-control" name="hospital_name" id="hospital_name" placeholder="Name of the Hospital">
							</div>	
                            
							<div class="form-group">
								<label for="hospital_district">Hospital District</label>
								<select name="hospital_district" id="hospital_district" class="form-control">
									<option value=''>Select District</option>
								</select>
							</div>
							<%--<div class="form-group">
								<label for="doctor_name">Name of Referring Doctor</label>
								<input type="text" class="form-control" name="doctor_name" id="doctor_name" value="" placeholder="Name of Referring Doctor">
							</div>
							<div class="form-group">
								<label for="doctor_email">Doctor's Email</label>
								<input type="text" class="form-control" name="doctor_email" id="doctor_email" value="" placeholder="Doctor's Email">
							</div>--%>
							<div class="form-group">
								<label for="sample_type">Testing Kit Used</label><span class="text-danger"><b> *</b></span>
								<select name="testing_kit_used" id="testing_kit_used" class="form-control">
									<option value="">Select Testing Kit</option>
									<optgroup label="Antigen Testing Kits">
										<option value="Ag-SD_Biosensor_Standard_Q_COVID-19_Ag_detection_kit" class="Antigen">SD Biosensor Standard Q COVID-19 Ag Detection Kit</option>
									</optgroup>
									<optgroup label="RT-PCR Testing Kits">
										<option value="ICMR-NIV Protocol">ICMR-NIV Protocol</option>
										<option value="TrueNAT">TrueNAT Screening</option>
										<option value="TrueNAT_RDRP_Confirmatory">TrueNAT RDRP Confirmatory</option>
										<option value="Altona">Altona-RealStar</option>
										<option value="ABI_Taqman">(ABI/ThermoFischer)-Taqman</option>
										<option value="ABI_Taqpath">(ABI/ThermoFischer)-Taqpath</option>
										<option value="A_Star_Fortitude">A Star Fortitude Kit 2.0</option>
										<option value="Abbott_Real_Time">Abbott Real-Time SARS-CoV2</option>
										<option value="BAG_ViroQ">BAG diagnostics-ViroQ RT-PCR Kit</option>
										<option value="BGI_Genomics">BGI Genomics</option>
										<option value="Biomerieux_ARGENE">Biomerieux-SARS-COV-2 R-GENE</option>
										<option value="Cepheid">Cepheid-Xpert Xpress</option>
										<option value="Co_Diagnostics_Logix_Smart">Co-Diagnostics-Logix Smart</option>
										<option value="Cosara_Diagnostics_SARAGENE">Cosara Diagnostics-SARAGENE</option>
										<option value="DAAN_Gene_Co_Detection_Kit">DAAN Gene Co Detection Kit 2019-nCoV</option>
										<option value="EUROIMMUN">EUROIMMUN-EURO Real Time SARS CoV2 kit</option>
										<option value="Fastract_SARS_kit">Fastract diagnosis-FTD SARS CoV2 kit</option>
										<option value="Fosun_nCoV_qPCR">Fosun 2019-nCoV qPCR</option>
										<option value="GB_SARS_RTPCR_kit">GB SARS Cov-2 RTPCR kit</option>
										<option value="Genestore_Detection_Expert">Genestore-Detection Expert 1S © SARS CoV-2 One Step rRT-PCR Kit</option>
										<option value="IITD_RTPCR_kit">IIT-Delhi-COROSURE</option>
										<option value="Labgun">Labgenomics-Labgun</option>
										<option value="Liferiver_RTPCR">Liferiver-2019nCoV RT-PCR Kit</option>
										<option value="Meril_RTPCR">Meril COVID19 One-step RT-PCR Kit</option>
										<option value="Mylab">Mylab</option>
										<option value="Medsource_RTPCR">Medsource COVID19 RT-PCR Kit</option>
										<option value="Microbiomed_Veri-Q_Kit">Micobiomed-Veri-Q COVID-19 Multiplex Detection Kit</option>
										<option value="PerkinElmer_Coronavirus_Detection_Kit">PerkinElmer-New Coronavirus Nucleic Acid Detection Kit</option>
										<option value="Primerdesign-Genesig">Primerdesign-Genesig</option>
										<option value="POCT_Q-line_RTPCR_kit">POCT Q-line Molecular Coronavirus RT-PCR Kit</option>
										<option value="Quantiplus_Version2">Quantiplu Version 2</option>
										<option value="Roche">Roche-TIB Molbiol</option>
										<option value="Roche_cobas">Roche cobas SARS CoV-2</option>
										<option value="Sansure_Biotech">Sansure Biotech-2019nCoV Nucleic Acid Diagnostic Kit</option>
										<option value="SD_Biosensor">SD BIOSENSOR</option>
										<option value="Seegene">Seegene-Allplex</option>
										<option value="True_PCR_Kelpest">True PCR Kelpest</option>
										<option value="Trivitron_COVIDSURE">Trivitron COVIDSURE</option>
										<option value="Trivitron_COVIDSURE_Pro">Trivitron COVIDSURE Pro</option>
										<option value="Trivitron-Yingsheng Biotech">Sandong Yingsheng Biotech</option>
										<option value="VIASURE_RTPCR">VIASURE SARS-CoV-2 RT-PCR Kit</option>
										<option value="Zybio_SARS_kit">Zybio SARS CoV-2 detection kit</option>
										<option value="TrueNAT">TrueNAT Screening</option>
                                        <option value="Truenat_duplex_molbio">Truenat COVID-19 duplex- Molbio Diagnostics</option>
                                        <option value="TrueNAT_RDRP_Confirmatory">TrueNAT RDRP Confirmatory</option>
									</optgroup>
								</select>
							</div>
							<div class="form-group">
								<label for="ct_value_screening">Ct value of (E Gene/N Gene) test if positive</label>
								<input type="text" class="form-control" name="ct_value_screening" id="ct_value_screening" placeholder="Ct value of (E Gene/N Gene) test if positive" readonly>
							</div>
							<div class="form-group">
								<label for="ct_value_orf1b">Ct value of (ORF1a/ORF1b/N/N2 Gene) test if positivee</label>
								<input type="text" class="form-control" name="ct_value_orf1b" id="ct_value_orf1b" placeholder="Ct value of (ORF1a/ORF1b/N/N2 Gene) test if positive" readonly>
							</div>
							
							<div class="form-group">
								<label for="ct_value_rdrp">Ct value of (RdRp/S Gene) test if positive</label>
								<input type="text" class="form-control" name="ct_value_rdrp" id="ct_value_rdrp" placeholder="Ct value of (RdRp/S Gene) test if positive" readonly>
							</div>
														
							<div class="form-group">
								<label for="repeat_sample">Is it a Repeat Sample?</label><span class="text-danger"><b> *</b></span>
								<select name="repeat_sample" id="repeat_sample" class="form-control" style="pointer-events: none;" readonly>								
									<option value="Yes">Yes</option>
									<option  value="No" selected>No</option>
								</select> 
							</div>											
							<%--<div class="form-group">
								<label for="inf_b">Influenza B</label>
								<select name="inf_b" id="inf_b" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="rsv">RSV</label>
								<select name="rsv" id="rsv" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="adenovirus">Adenovirus</label>
								<select name="adenovirus" id="adenovirus" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>
							
							<div class="form-group">
								<label for="rhinovirus">Rhinovirus</label>
								<select name="rhinovirus" id="rhinovirus" class="form-control">
									<option value="">Not Done</option>
									<option value="Positive">Positive</option>
									<option value="Negative">Negative</option>
								</select>
							</div>--%>
							<div class="form-group">
								<label for="remarks">Remarks</label>
							    <textarea class="form-control" name="remarks" id="remarks" style="height:34px" placeholder="Remarks.." ></textarea>
							</div>							
						</div>						
						<div class="col-md-12">	
						<div class="form-group">
							<input type="hidden" class="form-control" name="srf_id" id="srf_id" value="">
							
							<button type="button" class="btn btn-alert" onclick="postCovidData(1);" id="btnDraft">Save Draft</button>
							<button type="button" class="btn btn-primary" id="btn">Submit</button>
						</div>
						</div>
					</div>
					<div class="box-footer">
						<span class="pull-right text-danger">* Mandatory fields.</span>
					</div>
				</div>
			</div>
		</div>
		</form>
		
<link href="../../Scripts/alertifyjs/css/themes/bootstrap.min.css" rel="stylesheet" />
<link href="../../App_Style/font-awesome.min.css" rel="stylesheet" />
<link href="../../App_Style/AdminLTE.min.css" rel="stylesheet" />
<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/jquery.serializeToJSON.js" ></script>
<script src="../../Scripts/bootstrap-datepicker.js"></script>
<script src="../../Scripts/bootstrap-datetimepicker.min.js"></script>
<link href="../../App_Style/datepicker3.css" rel="stylesheet" />
<link href="../../Scripts/alertifyjs/css/themes/bootstrap-datetimepicker.min.css" rel="stylesheet" />


<script type="text/javascript">
    var _LedgerTransactionID = '<%=Util.GetInt(Request.QueryString["LedgerTransactionID"])%>';
    function formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;

        return [day, month, year].join('-');
    }
	function postCovidData(LimsStatus) {
	$('button').hide();
        var _data = {};
        var info = $('form').serializeArray();
        for (var i = 0; i < info.length; i++) {
            var _name = info[i].name.replace(/[[\]]/g, '');
            _data[_name] = ((_data[_name] === undefined) ? '' : _data[_name] + ',') + '' + info[i].value;
		}
		if ($('#district').val()==null || $('#district').val()=="")
		{
		alert('Please Select District !!');
		$('#district').focus();
		$('button').show();
		return;
	    }
		_data["LedgerTransactionID"] = _LedgerTransactionID;
		_data["LimsStatus"] = LimsStatus;

        $.ajax({
            url: "CovidRegistration.aspx/Create",
			type: "POST",
			data: JSON.stringify({ data: _data }),
            cache: false,
            contentType: "application/json; charset=utf-8",
            processData: false
        })
			.done(function (msg) {
				alert('Record saved successfully.');
                location.reload(true);
				if(LimsStatus!='2')
				$('button').show();
			}

		)
			.fail(function (jqXHR, textStatus) {
			$('button').show();
                alert("Request failed: " + JSON.stringify(jqXHR));
            });

	}



$(document).on('click', '.browse', function(){
	var file = $(this).parent().parent().parent().find('.file');
  	file.trigger('click');
});
$(document).on('change', '.file', function(){
	$(this).parent().find('.form-control').val($(this).val().replace(/C:\\fakepath\\/i, ''));
});
	var obj;
	$(document).ready(function () {
		
        $.ajax({
            url: "CovidRegistration.aspx/Get",
            type: "POST",
            data: JSON.stringify({ LedgerTransactionID: _LedgerTransactionID }),
            cache: false,
            contentType: "application/json; charset=utf-8",
            processData: false
        })
            .done(function (msg) {
				var PatientData = $.parseJSON(msg.d);
                obj = PatientData[0];
				var keys = Object.keys(obj);
				for (var i = 0; i < keys.length; i++) {
					$('#' + keys[i]).val(obj[keys[i]]);

					if (obj[keys[i]] != null) {
						if ((keys[i] == 'underlying_medical_condition') || (keys[i] == 'symptoms')) {
							var _val = obj[keys[i]].split(',');
							for (var k = 0; k < _val.length; k++)
								$(":checkbox[value='" + _val[k] + "']").prop("checked", "true");
						}
						else if (keys[i] == 'patient_category') {
							var _val = obj[keys[i]].split(',');
							for (var k = 0; k < _val.length; k++)
								$(":radio[value='" + _val[k] + "']").prop("checked", "true");
						}
					}

				}
                <%=sbResponse.ToString()%>
                obj['district']=<%=sbDis.ToString()%>
                $('#state').change();
                <%=sbResult.ToString()%>
                if ('<%=CentreID%>' == '2')
                {
                    $("input[value='community']").attr('checked', true);
                    $('#patient_occupation').val('OTHER');
                   
                    if ($('input[name="community_hospital"]:checked').val() == 'community') {
                        $('.community_settings').show();
                        $('.hospital_settings').hide();
                        $('.hospital_settings').find('input').prop('checked', false);
                        $('.community_settings').find('input').prop('checked', false);
                        $('#hospitalized').css("pointer-events", "none");
                        $('#hospitalized').val('');
                        $('#hospital_name').css("pointer-events", "none");
                        $('#hospital_name').val('');
                        $('#hospitalization_date').css("pointer-events", "none");
                        $('#hospitalization_date').val('');
                        $('#hospital_state').css("pointer-events", "none");
                        $('#hospital_state').val('');
                        $('#hospital_district').css("pointer-events", "none");
                        $('#hospital_district').val('');
                        $('#sample_collected_from').css("pointer-events", "auto");
                        $('#sample_collected_from').val('');
                    }
                    $('#sample_type').val('Nasopharyngeal_Oropharyngeal');
                    $('#sample_collected_from').val('Non-containment area');
                    $('#hospitalized').val('No');
                }
                if ($('#covid19_result_egene').val() == "Positive") {
                    $("#ct_value_screening").attr("readonly", false);
                    $("#ct_value_rdrp").attr("readonly", false);
                    
                }
                var formatedDate = "";
                if ($('#date_of_onset_of_symptoms').val().indexOf('/')>0)
                {
                    formatedDate = formatDate($('#date_of_onset_of_symptoms').val().split(' ')[0]);// + " " + $('#date_of_onset_of_symptoms').val().split(' ')[1];
                    $('#date_of_onset_of_symptoms').val(formatedDate);
                }
                
                if ($('#sample_rdate').val().indexOf('/')>0)
                {
                    formatedDate = formatDate($('#sample_rdate').val().split(' ')[0]) + " " + $('#sample_rdate').val().split(' ')[1];
                     $('#sample_rdate').val(formatedDate);
                }
               
				if (obj["LimsStatus"] == '2') {
					$('button').hide();
				}
			
            }

            )
            .fail(function (jqXHR, textStatus) {
                alert("Request failed: " + textStatus);
            });



		$("#patient_name").on('keypress',function(e)
	{
		var num;
		if(window.event){key = e.keyCode}
		else if (e.which){key = e.which}
		if((key == 8) || (key == 16) || (key == 20) || (key == 32) || (key == 46) || (key >= 65 && key <= 90) || (key >= 97 && key <= 122)) {return true;}
		else {return false;}
	});
	$("#patient_name").on('focusout',function(e)
	{
		if($("#patient_name").val().length <= 3)
		{
			alert("Patient Name should not be less than 4 letters.");
			$("#patient_name").val('');
			$("#patient_name").focus();
		}
	});
	
	$('#aadhar_number').on('focusout', function(){
		//alert(elementId.value);
		var uid = $('#aadhar_number').val();
		//		alert(uid);
		if ( uid.length!= 0 && uid.length < 12  )
		{
			alert("Please enter a valid Aadhaar");
			$('#aadhar_number').val('');
			$('#aadhar_number').focus();
			$('#aadhar_number').parent().addClass('has-error');
			return false;
		}
						
		// Verhoeff algorithm
		var Verhoeff = {
			"d":[
				[0,1,2,3,4,5,6,7,8,9],
				[1,2,3,4,0,6,7,8,9,5],
				[2,3,4,0,1,7,8,9,5,6],
				[3,4,0,1,2,8,9,5,6,7],
				[4,0,1,2,3,9,5,6,7,8],
				[5,9,8,7,6,0,4,3,2,1],
				[6,5,9,8,7,1,0,4,3,2],
				[7,6,5,9,8,2,1,0,4,3],
				[8,7,6,5,9,3,2,1,0,4],
				[9,8,7,6,5,4,3,2,1,0]
				],
			"p":[
				[0,1,2,3,4,5,6,7,8,9],
				[1,5,7,6,2,8,3,0,9,4],
				[5,8,0,3,7,9,6,1,4,2],
				[8,9,1,6,0,4,3,5,2,7],
				[9,4,5,3,1,2,6,8,7,0],
				[4,2,8,6,5,7,3,9,0,1],
				[2,7,9,3,8,0,6,4,1,5],
				[7,0,4,6,9,1,3,2,5,8]
				],
			"j":[0,4,3,2,1,5,6,7,8,9],
			"check":function(str)
			{
				var c = 0;
				str.replace(/\D+/g,"").split("").reverse().join("").replace(/[\d]/g, function(u, i, o){
					c = Verhoeff.d[c][Verhoeff.p[i&7][parseInt(u,10)]];
				});
				//alert(c)
				return c;
				//return (c === 0);
			},
			"get":function(str){
			
				var c = 0;
				str.replace(/\D+/g,"").split("").reverse().join("").replace(/[\d]/g, function(u, i, o){
					c = Verhoeff.d[ c ][ Verhoeff.p[(i+1)&7][parseInt(u,10)] ];
				});
				//alert('d '+Verhoeff.j[c]);
							//alert(Verhoeff.j[c]);
				return Verhoeff.j[c];
			}
		};
		
		// Verhoeff algorithm validator, by Avraham Plotnitzky. (aviplot at gmail)
		String.prototype.verhoeffCheck = (function()
		{
				//alert("sdd");
			var d = [[0,1,2,3,4,5,6,7,8,9],
					[1,2,3,4,0,6,7,8,9,5],
					[2,3,4,0,1,7,8,9,5,6],
					[3,4,0,1,2,8,9,5,6,7],
					[4,0,1,2,3,9,5,6,7,8],
					[5,9,8,7,6,0,4,3,2,1],
					[6,5,9,8,7,1,0,4,3,2],
					[7,6,5,9,8,2,1,0,4,3],
					[8,7,6,5,9,3,2,1,0,4],
					[9,8,7,6,5,4,3,2,1,0]];
			var p = [[0,1,2,3,4,5,6,7,8,9],
					[1,5,7,6,2,8,3,0,9,4],
					[5,8,0,3,7,9,6,1,4,2],
					[8,9,1,6,0,4,3,5,2,7],
					[9,4,5,3,1,2,6,8,7,0],
					[4,2,8,6,5,7,3,9,0,1],
					[2,7,9,3,8,0,6,4,1,5],
					[7,0,4,6,9,1,3,2,5,8]];
			var j = [0,4,3,2,1,5,6,7,8,9];
	
			return function()
			{
				var c = 0;
				this.replace(/\D+/g,"").split("").reverse().join("").replace(/[\d]/g, function(u, i, o){
					c = d[c][p[i&7][parseInt(u,10)]];
				});
							//alert(c);
				return (c === 0);
			};
		})();
		
		if( Verhoeff['check'](uid) != 0 )
		{
			alert("Please enter a valid Aadhaar");
			$('#aadhar_number').val('');
			$('#aadhar_number').focus();
			$('#aadhar_number').parent().addClass('has-error');
			return false;
		}
	});
	
	
	$('#status').on('change', function(){
		var status = $('#status').val();	    
		if(status == "Asymptomatic")
		{
		  	$("#date_of_onset_of_symptoms").attr("readonly", true);			
			$("#date_of_onset_of_symptoms").css("pointer-events","none");
			$("#date_of_onset_of_symptoms").val('');
			$(".symptoms").css("pointer-events","none");
		
		}
        else
		{ 
			$("#date_of_onset_of_symptoms").attr("readonly", false);
			$("#date_of_onset_of_symptoms").css("pointer-events","auto");
			$(".symptoms").css("pointer-events","auto");
		}	
	});
	
	
	//$("#nationality").val('India');
	$("#patient_id").on('focusout', function(){
		var hasSpace = $('#patient_id').val().indexOf(' ')>=0;
		if(hasSpace == true)
		{
			alert('Space is not Allowed in Patient ID');
			$('#patient_id').val('');
			$("#patient_id").focus();			
		}
		
		//<!-- $.post("check_for_patient.php",{patient_id:$('#patient_id').val()}, function(data){ -->
		//	<!-- if(data != '') -->
		//	<!-- { -->
		//		<!-- alert(data); -->
		//		<!-- $('#patient_id').val(''); -->
		//	<!-- } -->
		//<!-- }); -->
	});
	
	$("#sample_id").on('focusout', function(){
		var hasSpace = $('#sample_id').val().indexOf(' ')>=0;
		if(hasSpace == true)
		{
			alert('Space is not Allowed in Sample ID');
			$('#sample_id').val('');
			$("#sample_id").focus();			
		}
	});
	
	
	$('.age_in').on('click', function(){
		if($(this).prop('id') == 'age_year')
		{
			$('#age').prop('placeholder', 'Age in Years');
			$('#age').val('');
			$('#age_addon').text('Years');
		}
		if($(this).prop('id') == 'age_month')
		{
			$('#age').prop('placeholder', 'Age in Months');
			$('#age').val('');
			$('#age_addon').text('Months');
		}
		if($(this).prop('id') == 'age_day')
		{
			$('#age').prop('placeholder', 'Age in Days');
			$('#age').val('');
			$('#age_addon').text('Days');
		}
	});
	
	$('#age').on('focusout', function(){
		var filter = /^[0-9]{2}$/;
		if (!filter.test($(this).val())) {
			alert("Only Numeric characters are allowed in the Age field.");
			$("#age").val('');
			$("#age").parent().addClass('has-error');
			return false;
		}
		if($('.age_in:checked').prop('id') == 'age_month' && (Number($(this).val()) > 11))
		{
			alert("Months can't be greater than 11, if so Enter it in Years");
			$(this).val('');
			$(this).focus();
			$(this).parent().addClass('has-error');
			return false;
		}
		else
		{
			$(this).parent().removeClass('has-error');
		}		
		if($('.age_in:checked').prop('id') == 'age_day' && (Number($(this).val()) > 30))
		{
			alert("Days can't be greater than 30, if so Enter it in Months");
			$(this).val('');
			$(this).focus();
			$(this).parent().addClass('has-error');
			return false;
		}
		else
		{
			$(this).parent().removeClass('has-error');
		}
	});	
	
	$("#contact_number").on('focusout', function(){
		//alert('Mobile');
		var mobile = $("#contact_number").val();
		var filter = /^[6-9][0-9]{9}$/;
		if (!filter.test(mobile)) {
			alert("Mobile Number should be numeric and must starts from 6 to 9. Mobile Number must be of 10 digits.");
			$("#contact_number").val('');
			//$("#contact_number").focus();
			$("#contact_number").parent().addClass('has-error');
		}
		return false;
	});
	$("#pincode").on('focusout', function(){
		var pincode = $("#pincode").val();
		var filter = /^[0-9]{6}$/;
		if (!filter.test(pincode)) {
			alert("Mandatory 6 Numeric characters are allowed in the Pincode field.");
			$("#pincode").val('');
			$("#pincode").parent().addClass('has-error');
		}
		return false;
	});
	
	$("#passport_number").on('keyup', function(){
		$("#passport_number").val($("#passport_number").val().toUpperCase());
	});
	
	$("input[name='patient_category']").on('click', function(){
		if($("#others").is(':checked'))
		{
			$("#others_patients_category").prop("disabled", false);
		}
		else
		{
			$("#others_patients_category").prop("disabled", true);
			$("#others_patients_category").val('');
		}
	});
	
	$("#others_patients_category").on('focusout',function()
	{
		var others_patients_category = $("#others_patients_category").val();
		var filter = /^[a-zA-Z\s]+$/;
		if (!filter.test(others_patients_category)) {
			alert("Only Alphabets and spaces are allowed in Patients Category field.");
			$("#others_patients_category").val('');
			//$("#contact_number").focus();
			$("#patient_name").parent().addClass('has-error');
			return false;
		}
	});
	/*
	$("#passport_number").on('focusout', function(){
		var passport = $("#passport_number").val();
		var filter = /^[A-Z][0-9]{8}$/;
		if (!filter.test(passport)) {
			alert("Passport Number should be 9 letter alphanumeric");
			$("#passport_number").val('');
			//$("#passport_number").focus();
			$("#passport_number").parent().addClass('has-error');
		}
		return false;
	});
	
	$("#travel_to_foreign_country").on('change', function()
	{
		if($(this).val() == 'Yes')
		{
			$('#travel_history').prop('readonly', false);
			$('#travel_history').val('');
		}
		else
		{
			$('#travel_history').prop('readonly', true);
			$('#travel_history').val('');
		}
	});
	
	$("#contact_with_lab_confirmed_patient").on('change', function(){ 
		if($(this).val() == 'Yes')
		{
			$('#confirmed_patient_name_if_contact_made').prop('readonly', false);
		}
		else
		{
			$('#confirmed_patient_name_if_contact_made').prop('readonly', true);
			$('#confirmed_patient_name_if_contact_made').val('');
		}
	});
	
	$("#quarantined").on('change', function(){ 
		if($(this).val() == 'Yes')
		{
			$('#quarantined_where').prop('readonly', false);
			$("#quarantined_where").css("pointer-events","auto");
		}
		else
		{
			$('#quarantined_where').prop('readonly', true);
			$("#quarantined_where").css("pointer-events","none");
			$('#quarantined_where').val('');
		}
	});
	*/
	
	$("#testing_kit_used").on('change', function()
	{
		if($("#testing_kit_used").val() == 'TrueNAT11')
		{
			//$('#covid19_result_egene').css("pointer-events","none");
			$('#covid19_result_egene').val('');
			$("#ct_value_screening").attr("readonly", true); 
			$("#ct_value_screening").val(''); 
			//$('#orf1b_confirmatory').prop("readonly", true)
			$('#orf1b_confirmatory').css("pointer-events","none");
			$('#orf1b_confirmatory').val('');
			$("#ct_value_orf1b").attr("readonly", true); 
			$("#ct_value_orf1b").val('');
			//$('#rdrp_confirmatory').prop("readonly", true)
			$('#rdrp_confirmatory').css("pointer-events","none");
			$('#rdrp_confirmatory').val('');
			$("#ct_value_rdrp").attr("readonly", true); 
			$("#ct_value_rdrp").val('');
			$("#final_result_of_sample").val('');
			$("#final_result_of_sample option:contains('TrueNAT')").attr("disabled",false);
			$("#final_result_of_sample option:not(:contains('TrueNAT'))").attr("disabled",true);
			$("#final_result_of_sample_label").text("TrueNAT Screening result for this sample");
		}
		else
		{
			//$('#covid19_result_egene').css("pointer-events","auto");
			//$('#covid19_result_egene').val('');
			//$("#ct_value_screening").attr("readonly", true); 
			//$("#ct_value_screening").val(''); 
			//$('#orf1b_confirmatory').prop("readonly", true)
			//$('#orf1b_confirmatory').css("pointer-events","auto");
			///$('#orf1b_confirmatory').val('');
			//$("#ct_value_orf1b").attr("readonly", true); 
			//$("#ct_value_orf1b").val('');
			//$('#rdrp_confirmatory').prop("readonly", true)
			//$('#rdrp_confirmatory').css("pointer-events","auto");
			//$('#rdrp_confirmatory').val('');
			//$("#ct_value_rdrp").attr("readonly", true); 
			//$("#ct_value_rdrp").val('');
			//$("#final_result_of_sample").val('');
			//$("#final_result_of_sample option:contains('TrueNAT')").attr("disabled",true);
			//$("#final_result_of_sample option:not(:contains('TrueNAT'))").attr("disabled",false);
			//$("#final_result_of_sample_label").text("Final Result of SARS-CoV2(COVID19) for this Sample");
		}
	});
	
	$("#other").on('click', function()
	{
		if($(this).is(":checked")){
			$("#other_underlying_medical_conditions").prop('readonly', false);
		}
		else{
			$("#other_underlying_medical_conditions").prop('readonly', true);
			$("#other_underlying_medical_conditions").val('');
		}
	});
	
	$("#hospitalized").on('change', function()
	{
		if($(this).val() == 'Yes')
		{
			$('#hospitalization_date').prop('readonly', false);
			$('#hospital_name').prop('readonly', false);
			$('#hospital_district').prop('readonly', false);
			$("#hospital_district").css("pointer-events","auto");
			$('#hospital_state').prop('readonly', false);
			$("#hospital_state").css("pointer-events","auto");
		}
		else
		{
			$('#hospitalization_date').prop('readonly', true);
			$('#hospitalization_date').val('');
			$("#hospitalization_date").css("pointer-events","none");
			$('#hospital_name').prop('readonly', true);
			$('#hospital_name').val('');
			$('#hospital_district').prop('readonly', true);
			$("#hospital_district").css("pointer-events","none");
			$('#hospital_district').val('');
			$('#hospital_state').prop('readonly', true);
			$("#hospital_state").css("pointer-events","none");
			$('#hospital_state').val('');
		}
	});
	
	$('#hospital_state').on('change', function(){
        $.get('getDistrict.aspx', { stateindex: $(this).find(':selected').index() })
		.done(function(data){ 
			 $('#hospital_district').html(data); 
		 }); 
	});
	
	$('#covid19_result_egene').on('change', function()
	{
		$("#final_result_of_sample").val("");
		var covid19_result_egene = $('#covid19_result_egene').val();	    
		if(covid19_result_egene == "Positive")
		{
		  	$("#ct_value_screening").attr("readonly", false);
			$("#ct_value_screening").focus();
		}
        else
		{ 
			$("#ct_value_screening").attr("readonly", true); 
			$("#ct_value_screening").val(''); 
		}	
	});
	
	$('#orf1b_confirmatory').on('change', function()
	{
		$("#final_result_of_sample").val("");
		var orf1b_confirmatory = $('#orf1b_confirmatory').val();	   
		if(orf1b_confirmatory == "Positive")
		{
			$("#ct_value_orf1b").attr("readonly", false); 
			$("#ct_value_orf1b").focus();
		}
		else
		{ 
			$("#ct_value_orf1b").attr("readonly", true); 
			$("#ct_value_orf1b").val('');
		}
	});
	
	$('#rdrp_confirmatory').on('change', function()
	{
		$("#final_result_of_sample").val("");
		var rdrp_confirmatory = $('#rdrp_confirmatory').val();	   
		if(rdrp_confirmatory == "Positive")
		{
			$("#ct_value_rdrp").attr("readonly", false); 
			$("#ct_value_rdrp").focus();
		}
		else
		{ 
			$("#ct_value_rdrp").attr("readonly", true);
			$("#ct_value_rdrp").val('');			 
		}
	});
	
	$('#final_result_of_sample').on('change', function(){
		if($('#covid19_result_egene').val() == '' && $('#orf1b_confirmatory').val() == '' && $('#rdrp_confirmatory').val() == '') 
		{
			alert('Please select the result of E Gene/N Gene/ORF1a/ORF1b/RdRp/S Gene first');
			$('#final_result_of_sample').val('');
			return false;
		}
		$final_result_of_sample = $('#final_result_of_sample').val();
		if($final_result_of_sample == 'Positive')
		{
			if(confirm("Are you sure, You want to set result of this sample as Positive?")) 
			{
				return true;
			} 
			else 
			{
				$('#final_result_of_sample').val('');
				return false;
			}
		}
		if($final_result_of_sample == 'Spillage' || $final_result_of_sample == 'Sample Rejected' || $final_result_of_sample == 'Inconclusive')
		{
			if(confirm("You are selecting Sample Rejected/Spillage/Inconclusive for this sample!!")) 
			{
				//$("#covid19_result_egene option:contains('Inconclusive')").attr("disabled",false);
				//$("#covid19_result_egene option:not(:contains('Inconclusive'))").attr("disabled",true);
				//$("#orf1b_confirmatory option:contains('Inconclusive')").attr("disabled",false);
				//$("#orf1b_confirmatory option:not(:contains('Inconclusive'))").attr("disabled",true);
				//$("#rdrp_confirmatory option:contains('Inconclusive')").attr("disabled",false);
				//$("#rdrp_confirmatory option:not(:contains('Inconclusive'))").attr("disabled",true);
				$('#covid19_result_egene').val('Inconclusive_Spillage_Rejected');
				$('#orf1b_confirmatory').val('Inconclusive_Spillage_Rejected');
				$('#rdrp_confirmatory').val('Inconclusive_Spillage_Rejected');
				return true;
			} 
			else 
			{
				$('#final_result_of_sample').val('');
				return false;
			}
		}
		if($final_result_of_sample == 'Under Process')
		{
			$('#covid19_result_egene').val('Under Process');
			$('#orf1b_confirmatory').val('Under Process');
			$('#rdrp_confirmatory').val('Under Process');
		}
	});
	
	$("#contact_number,#age,#aadhar_number,#pincode,#doctor_mobile,#ct_value_orf1b,#ct_value_screening,#ct_value_rdrp").on('keypress',function(e)
	{
		var num;
		if(window.event){num = e.keyCode}
		else if (e.which){num = e.which}
		if (num >47 && num <58 ){return true;}
		else {return false;}
	});	
			
	$('#nationality').on('change', function(){
		var nationality = $('#nationality').val();	   
        if(nationality != "India"){
		 //  $("#state").attr("readonly", true); 
		 //  $("#state").val(''); 			   
		  // $("#district").attr("readonly", true); 
		 //  $("#district").val(''); 
		  // $('#state').attr("style", "pointer-events: none;");
		   //$('#district').attr("style", "pointer-events: none;");
		   $('#aadhar_div').addClass('hidden');
		   $('#aadhar_number').val('');
		   $('#passport_div').removeClass('hidden');
		}
        else
		{ 
			//$("#state").attr("readonly", false); 
			//$("#district").attr("readonly", false);
			//$('#state').attr("style", "pointer-events: block;");
			//$('#district').attr("style", "pointer-events: block;");		
			$('#aadhar_div').removeClass('hidden');
			$('#passport_div').addClass('hidden');	
			$('#passport_div').val('');			
		}	
	});
	
        $('#state').on('change', function () {
            $('#district').val('');
			$('#state_code').val($(this).find(':selected').attr('key'));
			
	
			
            $.get('getDistrict.aspx', { stateindex: $(this).find(':selected').index() })
                .done(function (data) {
				                    $('#district').html(data);
                    $('#district').val(obj['district']);
                    $('#district').on('change', function () {
                        $('#district_code').val($(this).find(':selected').attr('key'));
					});
						
					$('#district').change();
                });
        });

	//Datepicker
	$('.datepicker').datepicker({
		format: "dd-mm-yyyy",
		//startDate: new Date(),
		todayHighlight: true,
		endDate:'+1d'
	});
	//Datetimepicker
	$(".datetimepicker").datetimepicker({
        format		: "dd-mm-yyyy hh:ii:ss",
        autoclose	: true,
        todayBtn	: true,
		startDate	: "2020-03-23 00:00",
        endDate		: new Date()
       // pickerPosition: "bottom-right"
    });
	
	$('#btn').on('click', function () {

		
		

		// Write input related validations...
		var mandatory_field = [$("#patient_id"),$("#patient_name"),$("#gender"),$("#age"),$("#contact_number"),$("#contact_number_belongs_to"),$("#nationality"),$("#state"),$("#district"),$("#ri_sari"),$("#ri_ili"),$("#travel_to_foreign_country"),$("#quarantined"),$("#sample_cdate"),$("#sample_rdate"),$("#sample_type"),$("#sample_id"),$("#sample_tdate"),$("#testing_kit_used"),$("#final_result_of_sample")];//,$("#orf1b_confirmatory"),$("#rdrp_confirmatory")
		for(i=0; i < mandatory_field.length; i++)
		{
			if($(mandatory_field[i]).val()=='')
			{
				alert('You have left mandatory field empty...');
				$(mandatory_field[i]).focus();
				$(mandatory_field[i]).parent().addClass('has-error');
				return false;
			}
			
			else
			{
				$(mandatory_field[i]).parent().removeClass('has-error');
			}
		}
	    if ($('input[name="community_hospital"]:checked').val() == 'hospital' && $("#hospitalized").val() == '') {
	        alert('You have left mandatory field empty...');
	        $("#hospitalized").val().focus();
	        $("#hospitalized").val().parent().addClass('has-error');
	        return false;
	    }
		var date_fields = $(".datepicker");
		for(i=0; i < date_fields.length; i++)
		{
			if($(date_fields[i]).val().trim() != "")
			{
				var date	= $(date_fields[i]).val();
				var date 	= date.split("-");
				var date 	= new Date(date[2], date[1] - 1, date[0]);
				if(isNaN(date) == true)
				{
					alert("Invalide Date..");
					$(date_fields[i]).focus();
					$(date_fields[i]).parent().addClass('has-error');
					return false;
				}
			} 
		}
	/*
		if($('#nationality').val() == 'India')// Conditional validation
		{
			// Write input related validations...
			var con_mandatory_field = [$("#state"),$("#district")];//
			for(i=0; i < con_mandatory_field.length; i++)
			{
				if($(con_mandatory_field[i]).val()=='')
				{
					alert('You have left mandatory field empty...');
					$(con_mandatory_field[i]).focus();
					$(con_mandatory_field[i]).parent().addClass('has-error');
					return false;
				}
				else
				{
					$(con_mandatory_field[i]).parent().removeClass('has-error');
				}
			}
		}
		if($('#quarantined').val() == 'Yes')
		{
			// Write input related validations...
			var con_mandatory_field = [$("#quarantined_where")];//
			for(i=0; i < con_mandatory_field.length; i++)
			{
				if($(con_mandatory_field[i]).val()=='')
				{
					alert('You have left mandatory field empty...');
					$(con_mandatory_field[i]).focus();
					$(con_mandatory_field[i]).parent().addClass('has-error');
					return false;
				}
				else
				{
					$(con_mandatory_field[i]).parent().removeClass('has-error');
				}
			}
		}
	*/
		
		if($('input[name=patient_category]:checked').length<=0)
		{
			alert("Please select patient category.");
			$(this).parent().addClass('has-error');
			return false;
		}
		
		if($('#others').is(':checked') && $('#others_patients_category').val() == "")
		{
			alert("Please enter patient category if Others is selected.");
			$('#others_patients_category').parent().addClass('has-error');
			$('#others_patients_category').focus();
			return false;
		}
		
		// Date Validation....
		var sample_cdatetime 	= $("#sample_cdate").val().split(" ");
		var sample_cdate 		= sample_cdatetime[0].split("-");
		var sample_ctime 		= sample_cdatetime[1].split(":");		
		var sample_cdatetime	= new Date(sample_cdate[2], sample_cdate[1] - 1, sample_cdate[0], sample_ctime[0], sample_ctime[1], sample_ctime[2]);
		var sample_rdatetime 	= $("#sample_rdate").val().split(" ");
		var sample_rdate 		= sample_rdatetime[0].split("-");
		var sample_rtime 		= sample_rdatetime[1].split(":");		
		var sample_rdatetime	= new Date(sample_rdate[2], sample_rdate[1] - 1, sample_rdate[0], sample_rtime[0], sample_rtime[1], sample_rtime[2]);
		var sample_tdatetime 	= $("#sample_tdate").val().split(" ");
		var sample_tdate 		= sample_tdatetime[0].split("-");
		var sample_ttime 		= sample_tdatetime[1].split(":");		
		var sample_tdatetime	= new Date(sample_tdate[2], sample_tdate[1] - 1, sample_tdate[0], sample_ttime[0], sample_ttime[1], sample_ttime[2]);
		
		//var sample_rdate 		= $("#sample_rdate").val().split(" ");
		//var sample_rtime 		= new Date(sample_rdate[2], sample_rdate[1] - 1, sample_rdate[0]);
		//var sample_tdatetime 	= $("#sample_tdate").val().split(" ");
		//var sample_ttime 		= new Date(sample_tdate[2], sample_tdate[1] - 1, sample_tdate[0]);
		var curdate	 			= Date.now();

		if(sample_cdatetime > sample_rdatetime)
		{
			alert("Sample Collection Date should be earlier than Sample Received Date");
			return false;
		}
		if(sample_rdatetime > sample_tdatetime)
		{
			alert("Sample Received Date should be earlier than Date of Sample Tested");
			return false;
		}
		if(sample_tdatetime > curdate)
		{
			alert("Date of Sample Tested should be earlier than Today's Date");
			return false;
		}
		
		if($("#testing_kit_used").val() == 'TrueNAT')
		{
			alert("This is a TrueNAT Screening Test only. Please perform Confirmatory Test for this Sample and add that Confirmatory test as follow up.");
		}
        postCovidData(2);
		
		
	});
		
	$("#logout").click(function(){
		$.ajax({// ajax request is made to logout admin  3679mm  1579mm
			url: 'logout.php',
			cache: false,
			contentType: false,
			processData: false,
			type: 'POST',
			success: function(){
				$(location).attr('href', 'login.php');
			}
		});
	});
});
</script>