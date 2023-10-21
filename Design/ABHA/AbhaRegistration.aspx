<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AbhaRegistration.aspx.cs" Inherits="Design_ABHA_AbhaRegistration" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%-- Add content controls here --%>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <style>
        .pull-left {
            float: left !important;
            font-weight: bold;
        }

        .lblText {
            float: left;
            color: blue;
            font-size: 15px;
        }
    </style>
    <div id="Pbody_box_inventory">
           <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;font-size: 20px;" id="divAbhaHeadingSection">
            <b>ABHA Managment</b>

        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;cursor:pointer;font-size: 16px;" id="divAbhaRadioButtonSection">
            <input type="radio" value="2" id="rdbNoAbhaNo" name="rdbType"  onclick="IsHavingAbhaNo()" />
            <label for="rdbNoAbhaNo" style="font-weight:bolder;cursor:pointer;color: green;">Create ABHA</label>
             <input type="radio" value="1" id="rdbHavingAbhaNo" name="rdbType" checked="checked" onclick="IsHavingAbhaNo()" />
            <label for="rdbHavingAbhaNo" style="font-weight:bolder;cursor:pointer;color:#ff240d">Verify ABHA</label> 
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center" id="divNotHavingAbhaNo">
            <div class="row" id="divStartRegistration">
                <div class="col-md-3">
                      <label class="pull-left"> Registration With </label>
                                <b class="pull-right">:</b>
                   
                </div>

                <div class="col-md-5">
                    <select id="ddlRegistrationWith">
                        <option value="1" selected="selected">Aadhar-Otp</option>
                    </select>
                </div>

                <div class="col-md-3">
                   
                      <label class="pull-left">  Aadhar No  </label>
                                <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">
                    <input type="text" id="txtAadharNo" maxlength="12" />
                </div>

                <div class="col-md-5">
                    <input type="button" onclick="GetAadharOtp()" value="Generate OTP" id="btnGetAadharOtp" />
                </div>

            </div>

            <div class="row" id="divAadharOTPSection" style="display: none">
                <div class="col-md-3">
                  
                      <label class="pull-left">    Aadhar OTP   </label>
                                <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAadharOtp" placeholder="Enter Aadhar OTP" />
                    <label id="lblAadharTnxId" style="display: none"></label>
                </div>

                <div class="col-md-5">
                      <input type="button" id="btnReSendAadharOtp" onclick="ResendAadhaarOtp()" value="Resend OTP" />
                    <input type="button" id="btnVerifyAadharOtp" onclick="VerifyAadharOTP()" value="Next" />
                </div>
            </div>

            <div class="row" id="divMobile" style="display: none">
                <div class="col-md-3">
                   
                     <label class="pull-left">    Mobile No   </label>
                                <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtMobileNo" />
                </div>

                <div class="col-md-5">
                    <input type="button" id="btnGenrateOTPMobile" onclick="GenrateMobileOTP()" value="Next" />
                </div>
            </div>

            <div class="row" id="divMobileOTPVerificationSection" style="display: none">
                <div class="col-md-3">
                   
                      <label class="pull-left">  Mobile OTP   </label>
                                <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtMobileOTP" placeholder="Enter Mobile OTP" />
                    <label id="lblMobileTnxId" style="display: none"></label>
                </div>

                <div class="col-md-5">
                  <%--   <input type="button" id="btnResendMobileOTP" onclick="GenrateMobileOTP()" value="Resend OTP" />--%>
                    <input type="button" id="btnVerifyMobileOTP" onclick="VerifyMobileOTP()" value="Next" />
                </div>
            </div>

            <div id="divGenrateAbhaNoSection" style="display: none">

                <div class="row">
                    <div class="col-md-3">
                       
                          <label class="pull-left">  First Name    </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtFirstName" class="required" />
                    </div>
                    <div class="col-md-3">
                       
                         <label class="pull-left">   Middle Name   </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtMiddleName" />
                    </div>
                    <div class="col-md-3">
                      
                              <label class="pull-left">     Last Name    </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtLastName" />
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                       
                            <label class="pull-left"> Email Id </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" class="required" autocomplete="off" id="txtEmailAddress" maxlength="100" data-title="Enter Email Address (Press Enter To Search)" />

                    </div>
                    <div class="col-md-3">
                       
                         <label class="pull-left"> Health Id  </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtHealthId" class="required" />
                    </div>

                     <div class="col-md-5">
                     <input type="button" value="Check Availability" onclick="CheckAvailability()" id="btnCheckAvailability" />
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                      
                          <label class="pull-left">  Password  </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="password" id="txtPassword" class="required" />
                    </div>

                    <div class="col-md-3">
                        
                          <label class="pull-left"> Confirm Password  </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="password" id="txtConfirmPassword" class="required" />
                    </div>
                </div>
                <div class="row" style="text-align: center">

                    <input type="button" onclick="GenrateAccount()" value="Generate Abha Number" id="btnGenrateAccount" />
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory" style="text-align: center; display: none" id="divHavingAbhaNo">
           
            <div class="row" id="divAbhaSearchForVerificationSection">
                <div class="col-md-3">
                    Search With :
                </div>
                <div class="col-md-3">
                    <select id="ddlSearchWith" onchange="IsHavingAbhaNo()" >
                        <option value="1">HealthId Number</option>
                           <option value="2">HealthID</option>
                    </select>
                </div>
                 <div class="col-md-3 HealthIdNumber" style="display:none" >
                  <label class="pull-left">HealthId Number </label>
                                <b class="pull-right">:</b>
                </div>

                <div class="col-md-1 HealthIdNumber" style="display:none" >
                   <input class="ABHANumber" type="text" maxlength="2" id="txtAbhaFirst"/>

                </div>
                 <div class="col-md-2 HealthIdNumber" style="display:none" >
                     <input class="ABHANumber" type="text" maxlength="4" id="txtAbhaSecond" />

                     </div>
                <div class="col-md-2 HealthIdNumber" style="display:none">
                    <input class="ABHANumber" type="text" maxlength="4"  id="txtAbhaThird" />

                </div>
                  <div class="col-md-2 HealthIdNumber" style="display:none">
                      <input class="ABHANumber" type="text" maxlength="4"   id="txtAbhaFourth"  />
                  </div>

                 <div class="col-md-3 HealthId" style="display:none" >
                  <label class="pull-left">Health ID </label>
                                <b class="pull-right">:</b>
                </div>

                 <div class="col-md-5 HealthId" style="display:none" >
                  <input type="text" id="txtHeathID" class="required" />
                </div>
                 <div class="col-md-5" >
                    <input type="button" id="btnSearchHealthId" value="Search" onclick="SearchByHealthId()" />
                </div>

            </div>
            
             <div class="row"id="divAbhaLoginSection" style="display:none">
                  <div class="col-md-2">
                  <label class="pull-left">Login With </label>
                                <b class="pull-right">:</b>
                </div>

                <div class="col-md-3">
                    <select id="ddlLoginWith">
                        <option value="AADHAAR_OTP" selected="selected">AADHAAR OTP</option>
                        <option value="MOBILE_OTP" >MOBILE OTP</option>                  
                    </select>
                </div>
                 <div class="col-md-2">
                  <label class="pull-left">Name  </label>
                                <b class="pull-right">:</b>
                </div>

                <div class="col-md-3">
                     <label id="lblUserName" style="color:blue;font-weight:bolder"></label>
 
                </div>
                  <div class="col-md-3">
                  <label class="pull-left">HealthID Number  </label>
                                <b class="pull-right">:</b>
                </div>

                <div class="col-md-4">
                     <label id="lblHealthIdNuber" style="color:blue;font-weight:bolder"></label>
                     <label id="lblHealthID" style="color:blue;font-weight:bolder;display:none"></label>

                </div>


                  <div class="col-md-5" >
                    <input type="button" id="btnGetOtp" value="Generate OTP" onclick="AuthInitiation()" />
                       <input type="button" id="btnClear" value="Clear" onclick="IsHavingAbhaNo()" />
                </div>



            </div>
            <div class="row" id="divAbhaOtpVerificationSection" style="display:none">
                <div class="col-md-3">
                    OTP :
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtLoginOtp" placeholder="Enter OTP" />
                    <label id="lblLoginTnxId" style="display: none"></label>
                </div>

                <div class="col-md-5">
                     <input type="button" id="btnReSendLoginOtp" onclick="ResendAuthOTP()" value="Resend OTP" />
                    <input type="button" id="btnVerifyOtp" onclick="AuthVerification()" value="Verify" />
                </div>
                </div>

        </div>

        <div style="text-align: center;display:none " id="divPatientProfileDetails">
            <div class="POuter_Box_Inventory" style="text-align: center;font-size: 25px;">
                <b>Profile Details</b>
            </div>
            <div class="POuter_Box_Inventory">
              

                <div class="row">
                 <div class="col-md-20">
                <div class="row" style="margin-top: 12px;">

                    <div class="col-md-4">
                        <label class="pull-left">Health Id Number   </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8" >
                        <label class="lblText" id="lblHealthIDNo"></label>
                    </div>
                    <div class="col-md-4">
                         <label class="pull-left"> Health Id    </label>
                                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblHealthId"></label>
                    </div>

 </div>
                <div class="row"  style="margin-top: 12px;">
                    <div class="col-md-4"><label class="pull-left"> Mobile   </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblMobile"></label>
                    </div>


               
                    <div class="col-md-4" ><label class="pull-left"> Name    </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblName"></label>
                    </div>
                     </div>
                <div class="row"  style="margin-top: 12px;">
                    <div class="col-md-4"><label class="pull-left"> Gender     </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblGender"></label>
                    </div>

                    <div class="col-md-4"><label class="pull-left"> Date Of Birth      </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblDOB"></label>
                    </div>

                </div>
                <div class="row"  style="margin-top: 12px;">
                    <div class="col-md-4"><label class="pull-left"> State Name       </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblStateName"></label>
                    </div>
                    <div class="col-md-4"><label class="pull-left"> District Name       </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText"  id="lblDistrictName"></label>
                    </div>
                     </div>
                <div class="row"  style="margin-top: 12px;">
                    <div class="col-md-4"><label class="pull-left"> Email    </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblEmail"></label>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left"> Is Mapped    </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblIsMapped"></label>
                    </div>
                </div>
                     <div class="row"  style="margin-top: 12px;">
                           <div class="col-md-4">
                        <label class="pull-left"> Mapped  PatientID   </label>
                                <b class="pull-right">:</b></div>
                    <div class="col-md-8">
                        <label class="lblText" id="lblMappedUHID"></label>
                    </div>
                         </div>
                    </div>
                 <div class="col-md-4">
                  <div class="row" style="text-align: center">
                    <img id="imgPatientPhoto" style="border: 2px solid red;"  alt="No Photo Found" />

                  </div>
                 </div>
                </div>
               

            </div>
              <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="divIsMapped" >
                <b>Map Health Id Number With Patient</b>
            </div>
           <div class="POuter_Box_Inventory" id="divIsMappedPatient" style="display:none">
    <div class="row" style="text-align: center">
        <div class="col-md-3">Patient Id :</div>
        <div class="col-md-5">
            <input type="text" id="txtPatientId" />
        </div>
        <div class="col-md-3">
            <input type="button" id="btnMappPatientID" value="Map Patient" onclick="MappUhidWithAbhaNo()" />
        </div>
        <div class="col-md-8">
            <input type="button" id="btnMappedOldPatient" value="Old Patient Search" onclick="$showOldPatientSearchModel()" />
            <input type="button" id="btnRegisterNewPatient" value="Register New Patient" onclick="redirectToLabPrescriptionOPD()" />
        </div>
    </div>
</div>


        </div>

        <div id="oldPatientModel" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="width: 900px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Old Patient Search</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">UHID    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">

                                <input type="text" id="txtSearchModelMrNO" />
                            </div>
                            <div class="col-md-4" style="display:none">
                                <label class="pull-left">Family No.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8" style="display:none">
                                <input type="text" id="txtFamilyNo" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">First Name    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input type="text" id="txtSearchModelFirstName" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Last Name   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input type="text" id="txtSearchModelLastName" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Contact No.   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input type="text" id="txtSerachModelContactNo" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Address    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <input type="text" id="txtSearchModelAddress" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">From Date    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                                <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">To Date    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                                <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                            </div>
                        </div>


                        <div style="text-align: center" class="row">
                            <button type="button" onclick="$searchOldPatientDetail()">Search</button>
                        </div>
                        <div style="height: 200px" class="row">
                            <div id="divSearchModelPatientSearchResults" class="col-md-24">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: orange" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Admited Patients</b>
                        <button type="button" onclick="$closeOldPatientSearchModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
    
<script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" 
    style="width:876px;border-collapse :collapse;">
        <thead>
        <tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Title</th>
            <th class="GridViewHeaderStyle" scope="col" >First Name</th>
            <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Age</th>
            <th class="GridViewHeaderStyle" scope="col" >Sex</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" >Contact&nbsp;No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Card No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Valid To</th>                          
    
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
       var objRow = OldPatient[j];
        #>
                        <tr id="<#=j+1#>" 
                            style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>' 
                             <%--<#if(objRow.PatientRegStatus =="2"){#>
                        style="background-color:coral;cursor:pointer;"
                         
                        <#}
                         else {#>
                        style="cursor:pointer;"
                        <#}
                        #>--%>
                            >                            
                        <td class="GridViewLabItemStyle">
                       <a  class="btn" onclick="SetPatientIdToMapp($(this).closest('tr').find('#tdPatientID').text())" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                          Select
                           <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                       </a>    </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdTitle"  ><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="tdPFirstName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle" id="tdPLastName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientID"  ><#=objRow.Patient_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.dtEntry#></td>
                        <td class="GridViewLabItemStyle" id="tdHouseNo" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.House_No#></td>
                        <td class="GridViewLabItemStyle" id="tdContactNo" ><#=objRow.mobile#></td>  
                        <td class="GridViewLabItemStyle" id="tdCardNo" ><#=objRow.MembershipCardID#></td>   
                        <td class="GridViewLabItemStyle" id="tdValidTo" ><#=objRow.FamilyMemberIsPrimary#></td>                      
                        
                        <td class="GridViewLabItemStyle" id="tdPatientRegStatus" style="width:80px;display:none"><#=objRow.PatientRegStatus#></td>                         
                        </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
     <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
       <tr>
   <# if(_PageCount>1) {
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }
#>
     </tr>     
     </table>  
    </script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            IsHavingAbhaNo();
            HideShowSearchType();
            $("#txtAadharNo , .ABHANumber ").keydown(function (e) {

                // Allow: backspace, delete, tab, escape, enter and .
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    // Allow: Ctrl+A, Command+A
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    // Allow: home, end, left, right, down, up
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    // let it happen, don't do anything
                    return;
                }
                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }

            });
            var profilePhoto = "data:image/png;base64,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";

            $('#imgPatientPhoto').attr("src", profilePhoto);
        });
        $("#txtAadharNo").blur(function () {
            var value = $(this).val();
            var len = value.length;
            var count = 12;
            if (count != len) {
                if (len > 0) {
                    modelAlert("Adhaar no. should be 12 digits", function () {
                        $("#txtAadharNo").focus();
                    });
                }
            }

        });
        var $showOldPatientSearchModel = function () {
            $('#oldPatientModel').showModel();
        }

        var $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }




        function IsHavingAbhaNo() {
            var val = $('input[name="rdbType"]:checked').val();
            if (val == 1) {
                $("#divHavingAbhaNo").show();
                $("#divAbhaLoginSection").hide();
                $("#divAbhaSearchForVerificationSection").hide();
                $("#divNotHavingAbhaNo").hide();
                HideShowSearchType();
            } else {
                $("#divHavingAbhaNo").hide();
                $("#divAbhaLoginSection").hide();
                $("#divAbhaSearchForVerificationSection").hide();
                $("#divNotHavingAbhaNo").show();
                HideShowSearchType();
            }


        }

        var _PageSize = 9;
        var _PageNo = 0;
        //var $searchOldPatientDetail = function () {
        //    var data = {
        //        PatientID: $('#txtSearchModelMrNO').val(),
        //        PName: $('#txtSearchModelFirstName').val(),
        //        LName: $('#txtSearchModelLastName').val(),
        //        ContactNo: $('#txtSerachModelContactNo').val(),
        //        Address: $('#txtSearchModelAddress').val(),
        //        FromDate: $('#txtSearchModelFromDate').val(),
        //        ToDate: $('#txtSerachModelToDate').val(),
        //        PatientRegStatus: 1,
        //        isCheck: '0',
        //        AadharCardNo: '',
        //        MembershipCardNo: '',
        //        DOB: '',
        //        IsDOBChecked: '0',
        //        Relation: '0',
        //        RelationName: '',
        //        IPDNO: '',
        //        panelID: '',
        //        cardNo: '',
        //        IDProof: '',
        //        visitID: '',
        //        emailID: '',
        //        patientType: '2',
        //        FamilyNo: $("#txtFamilyNo").val()
        //    }
        //    serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
        //        if (!String.isNullOrEmpty(response)) {
        //            OldPatient = JSON.parse(response);
        //            if (OldPatient != null) {
        //                _PageCount = OldPatient.length / _PageSize;
        //                showPage(0);
        //            }
        //            else {
        //                $('#divSearchModelPatientSearchResults').html('');
        //            }
        //        }
        //        else
        //            $('#divSearchModelPatientSearchResults').html('');

        //    });
        //}
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
                PatientID: $('#txtSearchModelMrNO').val(),
                PName: $('#txtSearchModelFirstName').val(),
                DOB: "",
                Patient_ID: jQuery('#txtSearchModelMrNO').val(),
                MobileNo: jQuery('#txtSerachModelContactNo').val(),
                fromDate: jQuery('#txtSearchModelFromDate').val(),
                toDate: jQuery('#txtSerachModelToDate').val(),
                stateID: "",
                cityID:"",
                localityID: "",
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
        function SetPatientIdToMapp(UHID) {
            $("#txtPatientId").val(UHID).attr("disabled", true);
            $closeOldPatientSearchModel();
        }


        function MappUhidWithAbhaNo() {
            var PatientId = $("#txtPatientId").val();
            var AdbahNo = $("#lblHealthIDNo").text();
            if (String.isNullOrEmpty(PatientId)) {
                modelAlert("Please Enter Patient Id");
                return false;
            }
            if (String.isNullOrEmpty(AdbahNo)) {
                modelAlert("Abha No. Not Found ");
                return false;
            }

            $("#btnMappPatientID").attr("disabled", true);
            serverCall('Service/ABHAService.asmx/MappAbhaNoWithPatientID', { PatientID: PatientId, AbhaNo: AdbahNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        window.location.reload();
                    });
                } else {
                    modelAlert(responseData.response, function () {
                        $("#btnMappPatientID").attr("disabled", false);
                    });
                }
            });

        }

    </script>


      <%--  Registration Section--%>

    <script type="text/javascript">

        function GetAadharOtp() {
            var Aadhar = $("#txtAadharNo").val();
            if (String.isNullOrEmpty($("#txtAadharNo").val())) {
                modelAlert("Please Enter Aadhar No");
                return false;
            }


            $('#btnGetAadharOtp').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/GetAadharOtp', { AadharNo: Aadhar }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    $("#divStartRegistration").hide();
                    $("#divAadharOTPSection").show();
                    $("#lblAadharTnxId").text(responseData.response.txnId);

                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnGetAadharOtp').attr("disabled", false);
                }

            });
        }
        function VerifyAadharOTP() {
            var tnxId = $("#lblAadharTnxId").text();
            var OTP = $("#txtAadharOtp").val();
            $('#btnVerifyAadharOtp').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/VerifyAadharOtp', { OTP: OTP, TnxId: tnxId }, function (response) {
                var responseData = JSON.parse(response);
                console.log(responseData.response);
                if (responseData.status) {

                    $("#divAadharOTPSection").hide();
                    $("#divMobile").show();
                    $("#lblAadharTnxId").text(responseData.response.txnId)

                } else {
                    //  modelAlert(responseData.response.details[0].message)

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                    $('#btnVerifyAadharOtp').attr("disabled", false);

                }

            });
        }
        function GenrateMobileOTP() {
            var Mobile = $("#txtMobileNo").val();
            var TnxId = $("#lblAadharTnxId").text();

            $('#btnGenrateOTPMobile').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/CheckAndGenerateMobileOTP', { Mobile: Mobile, TnxId: TnxId }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    if (responseData.MobileStatus) {
                        $("#divMobile").hide();
                        $("#divGenrateAbhaNoSection").show();
                        $("#lblAadharTnxId").text(responseData.response.txnId)
                    } else {
                        $("#divMobile").hide();
                        $("#divMobileOTPVerificationSection").show();
                        $("#lblAadharTnxId").text(responseData.response.txnId)
                    }


                } else {
                    modelAlert(responseData.response.message, function () {
                        $('#btnGenrateOTPMobile').attr("disabled", false);
                    })
                }

            });
        }
        function VerifyMobileOTP() {
            var tnxId = $("#lblAadharTnxId").text();
            var OTP = $("#txtMobileOTP").val();

            $('#btnVerifyMobileOTP').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/VerifyMobileOTP', { OTP: OTP, TnxId: tnxId }, function (response) {
                var responseData = JSON.parse(response);

                console.log(responseData.response);

                if (responseData.status) {
                    $("#divMobileOTPVerificationSection").hide();
                    $("#divGenrateAbhaNoSection").show();
                    $("#lblAadharTnxId").text(responseData.response.txnId)

                } else {
                    // modelAlert(responseData.response.message)
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                    $('#btnVerifyMobileOTP').attr("disabled", false);
                }

            });
        }

     function redirectToLabPrescriptionOPD() {
      var host = window.location.host; 
      var desiredURL = '/uat_ver1/Design/Lab/Lab_PrescriptionOPD.aspx';
      var finalURL = 'http://' + host + desiredURL;
      window.location.href = finalURL;
  }



        function GenrateAccount() {
            $email = $('#txtEmailAddress').val();
            //$emailexp = /^[a-zA-Z\-0-9](([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\-\].,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z0-9](?:[a-zA-Z0-9]|-(?!-))*\.)+[a-zA-Z]{2,}))$/gm;
            $emailexp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            if (($emailexp.test($email) == false) && ($email != '')) {
                modelAlert('Please Enter Valid Email Address');
                return false;
            }


            if (String.isNullOrEmpty($("#txtFirstName").val())) {
                modelAlert("Please Enter First Name");
                return false;
            }



            if (String.isNullOrEmpty($email)) {
                modelAlert("Please Enter EmailId");
                return false;
            }

            if (String.isNullOrEmpty($("#txtHealthId").val())) {
                modelAlert("Please Enter HealthId");
                return false;
            }

            var Password = $("#txtPassword").val();
            var ConfirmPassword = $("#txtConfirmPassword").val();


            if (String.isNullOrEmpty(Password)) {
                modelAlert("Please Enter Password");
                return false;
            }

            if (String.isNullOrEmpty(ConfirmPassword)) {
                modelAlert("Please Enter Confirm Password");
                return false;
            }

            if (Password != ConfirmPassword) {
                modelAlert("Password Not Matched.");
                return false;
            }

            if ($email == '') {
                modelAlert("Please Enter EmailId");
                return false;
            }

            var Abha = new Object();

            Abha.email = $email;
            Abha.firstName = $("#txtFirstName").val();
            Abha.healthId = $("#txtHealthId").val();
            Abha.lastName = $("#txtLastName").val();
            Abha.middleName = $("#txtMiddleName").val();
            Abha.password = Password;
            Abha.profilePhoto = "";
            Abha.txnId = $("#lblAadharTnxId").text();


            $('#btnGenrateAccount').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/CreateHealthIdWithPreVerified', { AbhaRegistration: Abha }, function (response) {
                var responseData = JSON.parse(response);

                console.log(responseData.response);

                if (responseData.status) {

                    if (responseData.IsMappedPatient) {
                        $("#lblIsMapped").text("YES").css({ 'color': 'green', 'font-size': '15px' });
                        $("#lblMappedUHID").text(responseData.MappedPatientID)

                    } else {

                        $("#divIsMapped").show();
                        $("#divIsMappedPatient").show();
                        $("#lblIsMapped").text("NOT").css({ 'color': 'red', 'font-size': '15px' });
                    }

                    BindPatientProfileDetails(responseData.response)
                } else {
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                    $('#btnGenrateAccount').attr("disabled", false);
                }

            });
        }
        function BindPatientProfileDetails(Data) {


            var profilePhoto = "data:image/png;base64," + Data.profilePhoto
            $('#imgPatientPhoto').attr('src', profilePhoto);

            $("#lblHealthIDNo").text(Data.healthIdNumber);
            $("#lblHealthId").text(Data.healthId);
            $("#lblMobile").text(Data.mobile);

            $("#lblName").text(Data.name);
            $("#lblGender").text(Data.gender);

            var Year = Data.yearOfBirth;
            var Month = (Data.monthOfBirth < 10) ? "0" + Data.monthOfBirth : Data.monthOfBirth;
            var Days = (Data.dayOfBirth < 10) ? "0" + Data.dayOfBirth : Data.dayOfBirth;

            $("#lblDOB").text(Days + "-" + Month + "-" + Year);
            $("#lblStateName").text(Data.stateName);
            $("#lblDistrictName").text(Data.districtName);
            $("#lblEmail").text(Data.email);


            Clear();
            $("#divAbhaHeadingSection").hide()
            $("#divAbhaRadioButtonSection").hide()
            $("#divHavingAbhaNo").hide();
            $("#divNotHavingAbhaNo").hide()
            $("#divPatientProfileDetails").show()
        }
        function Clear() {
            $("#txtMobileNo").val("");
            $("#lblAadharTnxId").text("");
            $("#lblAadharTnxId").text("");
            $("#txtAadharOtp").val("");
            $("#txtAadharNo").val("");
            $("#lblAadharTnxId").text("");
            $("#txtMobileOTP").val("");
            $("#txtFirstName").val("");
            $("#txtHealthId").val("");
            $("#txtLastName").val("");
            $("#txtMiddleName").val("");
            $("#lblAadharTnxId").text("");
            $("#txtPassword").val("");
            $("#txtConfirmPassword").val("");

            $("#txtLoginOtp").val("");
            $("#lblLoginTnxId").text("");

            $('#btnVerifyOtp').attr("disabled", false);
            $("#ddlLoginWith").attr("disabled", false);
            $('#btnGetOtp').attr("disabled", false);

            $("#txtAbhaFirst").val("");
            $("#txtAbhaSecond").val("");
            $("#txtAbhaThird").val("");
            $("#txtAbhaFourth").val("");

        }



        function ResendAadhaarOtp() {
            var tnxId = $("#lblAadharTnxId").text();

            $('#btnReSendAadharOtp').attr("disabled", true);
            serverCall('Service/ABHAService.asmx/ResendAadhaarOtp', { TnxId: tnxId }, function (response) {
                var responseData = JSON.parse(response);

                console.log(responseData.response);

                if (responseData.status) {
                    modelAlert("OTP Resend Successfylly.");
                    // $("#lblAadharTnxId").text(responseData.response.txnId)
                    $('#btnReSendAadharOtp').attr("disabled", false);
                } else {
                    // modelAlert(responseData.response.message)
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                    $('#btnReSendAadharOtp').attr("disabled", false);
                }

            });
        }


    </script>
     <script type="text/javascript">
         var OldPatientDetails = "";
         var $patientSearchOnEnter = function (e) {
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

      <%--  Registration Section End--%>


  <%--  Login Section--%>

    <script type="text/javascript">
        $(".ABHANumber").keyup(function () {
            if (this.value.length == this.maxLength) {
                $(this).closest('div').next().find('.ABHANumber').first().focus();
            }
        });

        function AuthInitiation() {
            var Abha1 = $("#txtAbhaFirst").val();
            var Abha2 = $("#txtAbhaSecond").val();
            var Abha3 = $("#txtAbhaThird").val();
            var Abha4 = $("#txtAbhaFourth").val();

            var HealthIdnumber = $("#lblHealthID").text();

            if (String.isNullOrEmpty(HealthIdnumber)) {
                modelAlert("HealthId Number not found.");
                return false;
            }

            var LoginWith = $("#ddlLoginWith").val();
            if (String.isNullOrEmpty(LoginWith)) {
                modelAlert("Please Select Login With.");
                return false;
            }
            var FinalAbhaNo = HealthIdnumber;
            $('#btnGetOtp').attr("disabled", true);
            $("#ddlLoginWith").attr("disabled", true);
            serverCall('Service/ABHAService.asmx/AuthInitiation', { LoginWith: LoginWith, AbhaNumber: FinalAbhaNo }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    $("#divAbhaLoginSection").hide();
                    $("#divAbhaOtpVerificationSection").show();
                    $("#lblLoginTnxId").text(responseData.response.txnId);

                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnGetOtp').attr("disabled", false);
                }

            });
        }

        function AuthVerification() {
            var OTP = $("#txtLoginOtp").val();
            var TxnId = $("#lblLoginTnxId").text();

            if (String.isNullOrEmpty(OTP)) {
                modelAlert("Please Enter OTP.");
                return false;
            }

            if (String.isNullOrEmpty(TxnId)) {
                modelAlert("Try Again ! Some Error Occured.");
                return false;
            }
            var LoginWith = $("#ddlLoginWith").val();
            if (String.isNullOrEmpty(LoginWith)) {
                modelAlert("Please Select Login With.");
                return false;
            }

            $('#btnVerifyOtp').attr("disabled", true);
            $("#ddlLoginWith").attr("disabled", true);
            serverCall('Service/ABHAService.asmx/AuthVerification', { LoginWith: LoginWith, OTP: OTP, TxnId: TxnId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {

                    if (responseData.IsMappedPatient) {
                        $("#lblIsMapped").text("YES").css({ 'color': 'green', 'font-size': '15px' });
                        $("#lblMappedUHID").text(responseData.MappedPatientID)

                    } else {
                        $("#divIsMapped").show();
                        $("#divIsMappedPatient").show();
                        $("#lblIsMapped").text("NOT").css({ 'color': 'red', 'font-size': '15px' });
                    }

                    BindPatientProfileDetails(responseData.response);
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnVerifyOtp').attr("disabled", false);
                }

            });
        }


        function ResendAuthOTP() {

            var TxnId = $("#lblLoginTnxId").text();

            var LoginWith = $("#ddlLoginWith").val();
            if (String.isNullOrEmpty(LoginWith)) {
                modelAlert("Please Select Login With.");
                return false;
            }

            $('#btnReSendLoginOtp').attr("disabled", true);
            $("#ddlLoginWith").attr("disabled", true);
            serverCall('Service/ABHAService.asmx/ResendAuthOTP', { LoginWith: LoginWith, TxnId: TxnId }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("OTP Resend Successfylly.")

                    $('#btnReSendLoginOtp').attr("disabled", false);
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnReSendLoginOtp').attr("disabled", false);
                }

            });
        }

        function CheckAvailability() {
            var HealthID = $('#txtHealthId').val();
            if (HealthID == "" || HealthID == null) {
                modelAlert("Please Enter HealthId to Check.");
                return false;
            }
            $('#btnCheckAvailability').attr("disabled", true);
            $("#txtHealthId").attr("disabled", true);
            serverCall('Service/ABHAService.asmx/ExistsByHealthId', { HealthId: HealthID }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    if (responseData.response.status) {
                        modelAlert("HealthId not available.", function () {
                            $('#txtHealthId').val('');
                        })
                        $('#txtHealthId').attr("disabled", false);
                        $('#btnCheckAvailability').attr("disabled", false);
                    } else {
                        modelAlert("Available.", function () {

                        })
                    }
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message, function () {
                            $('#txtHealthId').val('');
                        })
                    } else {
                        modelAlert(responseData.response.message, function () {
                            $('#txtHealthId').val('');
                        })

                    }

                    $('#txtHealthId').attr("disabled", false);
                    $('#btnCheckAvailability').attr("disabled", false);
                }

            });
        }


        function HideShowSearchType() {
            var Val = $("#ddlSearchWith").val();
            if (Val == 1) {

                $("#divAbhaSearchForVerificationSection").show();
                $("#divAbhaLoginSection").hide();
                $(".HealthIdNumber").show();
                $(".HealthId").hide();
                $('#btnSearchHealthId').attr("disabled", false);
                $("#txtAbhaFirst").val("");
                $("#txtAbhaSecond").val("");
                $("#txtAbhaThird").val("");
                $("#txtAbhaFourth").val("");
                $("#txtHeathID").val("");
                $("#lblUserName").text("");
                $("#lblHealthIdNuber").text("");
                $("#lblHealthID").text("");
            } else {

                $("#divAbhaSearchForVerificationSection").show();
                $("#divAbhaLoginSection").hide();
                $(".HealthIdNumber").hide();
                $(".HealthId").show();
                $('#btnSearchHealthId').attr("disabled", false);
                $("#txtAbhaFirst").val("");
                $("#txtAbhaSecond").val("");
                $("#txtAbhaThird").val("");
                $("#txtAbhaFourth").val("");
                $("#txtHeathID").val("");
                $("#lblUserName").text("");
                $("#lblHealthIdNuber").text("");
                $("#lblHealthID").text("");

            }


        }



        function SearchByHealthId() {
            var Abha = "";

            var Abha1 = $("#txtAbhaFirst").val();
            var Abha2 = $("#txtAbhaSecond").val();
            var Abha3 = $("#txtAbhaThird").val();
            var Abha4 = $("#txtAbhaFourth").val();
            var HealthID = $("#txtHeathID").val();

            var Val = $("#ddlSearchWith").val();



            if (Val == 1) {
                if (String.isNullOrEmpty(Abha1) || String.isNullOrEmpty(Abha2) || String.isNullOrEmpty(Abha3) || String.isNullOrEmpty(Abha4)) {
                    modelAlert("Please Enter Valid ABHA Number");
                    return false;
                }
                if (Abha1.length < 2 || Abha2.length < 4 || Abha3.length < 4 || Abha4.length < 4) {
                    modelAlert("Please Enter Valid ABHA Number");
                    return false;
                }
                Abha = Abha1 + "-" + Abha2 + "-" + Abha3 + "-" + Abha4;

            } else {
                Abha = HealthID;
            }


            if (String.isNullOrEmpty(Abha)) {
                if (Val == 1) {
                    modelAlert("Please Enter Valid ABHA Address Number.");
                } else {
                    modelAlert("Please Enter Valid ABHA Address.");
                }
                return false;
            }

            $('#btnSearchHealthId').attr("disabled", true);
            serverCall('Service/ABHAM3Services.asmx/SearchByHealthId', { AbhaId: Abha }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    $("#lblUserName").text(responseData.response.name);
                    $("#lblHealthIdNuber").text(responseData.response.healthIdNumber);
                    $("#lblHealthID").text(responseData.response.healthId);

                    if (responseData.response.status != "ACTIVE") {
                        modelAlert("User is not active.", function () {
                            HideShowOTPGenrationSetion(0);
                            $('#btnSearchHealthId').attr("disabled", false);
                        });

                    } else {
                        HideShowOTPGenrationSetion(1);
                    }

                } else {
                    modelAlert(responseData.response.message);
                    $('#btnSearchHealthId').attr("disabled", false);
                }

            });
        }

        function HideShowOTPGenrationSetion(Val) {
            if (Val == 0) {
                $("#divAbhaSearchForVerificationSection").show();
                $("#divAbhaLoginSection").hide();

            } else {
                $("#divAbhaSearchForVerificationSection").hide();
                $("#divAbhaLoginSection").show();

            }


        }

    </script>
     <%--  Login Section End --%>

</asp:Content>
