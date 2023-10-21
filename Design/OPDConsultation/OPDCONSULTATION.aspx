<%@ Page Title="" ClientIDMode="Static"  Language="C#" EnableEventValidation="false" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDCONSULTATION.aspx.cs" Inherits="Design_FrontOffice_OPDCONSULTATION" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="Content1">
        <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <script type="text/javascript" language="javascript">
         var $bindRateType = function () {
             $('#divPaymentControl').hide();
             $('#<%=ddlPanel.ClientID%> option').remove();
             $ddlPanel = $('#<%=ddlPanel.ClientID%>');
               serverCall('../Lab/Services/LabBooking.asmx/GetPanel', { CentreID: $('#<%=ddlCentreAccess.ClientID%>').val(), VisitType: $('#<%=ddlPatientType.ClientID%>').val() }, function (response) {
                   var $response = $.parseJSON(response);
                   if ($response.length == 0) {
                       $ddlPanel.append($("<option></option>").val("0").html("---No Data Found---"));
                   }
                   else {
                       for (var i = 0; i < $response.length; i++) {

                           $ddlPanel.append($("<option></option>").val($response[i].value).html($response[i].label));
                       }
                       if ($('#<%=ddlPanel.ClientID%>').val().split('#')[4] == 1) {
                         $('#divPaymentControl').hide();
                     }
                     else {
                         $('#divPaymentControl').show();
                     }
                     $getPaymentMode("0", function (callback) {
                     });
                 }
             });
         }
         var $bindDoctorlist = function (Cenid) {
             var Centreid = 0;
             if (Cenid != undefined) {
                 var Centreid = Cenid;
             }
             else
             {
                 Centreid = $('#ddlCentreAccess').val();
             }

             $('#<%=lstDoctor.ClientID%> option').remove();
            var $lstDoctor = $('#<%=lstDoctor.ClientID%>');
             serverCall('OPDCONSULTATION.aspx/bindDoctorlist', { DepartmentID: $('#<%=ddldept.ClientID%>').val(), Centreid: Centreid }, function (response) {
                 var $response = $.parseJSON(response);
               
                     for (var i = 0; i < $response.length; i++) {

                         $lstDoctor.append($("<option></option>").val($response[i].Doctor_ID).html($response[i].Name));
                     }
             });
         }
         function getapptime() {
             $('#<%=chlapttime.ClientID%> option').remove();
             var $chlapttime = $('#<%=chlapttime.ClientID%>');
             serverCall('OPDCONSULTATION.aspx/getapptime', { DoctorID: $('#<%=lstDoctor.ClientID%>').val(), AppDate: $('#<%=txtAppDate.ClientID%>').val() }, function (response) {
                 var $response = $.parseJSON(response);
               
                 if ($response.status) {
                     $response = $response.response;
                     for (var i = 0; i < $response.length; i++) {
                        
                         $chlapttime.append($("<option></option>").val($response[i].Timeslot).html($response[i].Timeslot));
                     }
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });
         }
         function getappointmentno() {
             serverCall('OPDCONSULTATION.aspx/getappointmentno', { DoctorID: $('#<%=lstDoctor.ClientID%>').val(), AppDate: $('#<%=txtAppDate.ClientID%>').val() }, function (response) {
                 var $response = $.parseJSON(response);
               
                 if ($response.status) {
                     $response = $response.response;
                     $('#<%=lbappno.ClientID%>').html($response);
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });
         }
         function GetLastLabNo(cid) {
             $bindDiscountApprovalAndOutStandingEmp();
             if (cid != undefined) {
                 $bindDoctorlist(cid);
             }

             serverCall('../OPDConsultation/Services/OPDSearch.asmx/GetLastTokenNo', { centre: $('#ddlCentreAccess').val() }, function (response) {
                 var $response = $.parseJSON(response);                 
                 if ($response == "") {
                     $('#<%=lasttokenno.ClientID%>').html('00');
                     $('#<%=txttokenno.ClientID%>').val('01');
                 }
                 else {
                     $('#<%=lasttokenno.ClientID%>').html($response.split('#')[0]);
                     $('#<%=txttokenno.ClientID%>').val($response.split('#')[1]);
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
         function showoldpatient() {
             if ($('#<%=txtPID.ClientID %>').val().length == 0) {
                 toast("Error", "Please Enter Registration No..!", "");
                 $('#<%=txtPID.ClientID %>').focus();
                 return;
             }
             var pid = $('#<%=txtPID.ClientID %>').val();
             serverCall('../OPDConsultation/Services/OPDSearch.asmx/SearchOldPatient', { PID: $("#<%=txtPID.ClientID %>").val() }, function (response) {
               var  PatientData = $.parseJSON(response);
                 if (PatientData.length == 0) {
                     toast("Error", "No Data Found", "");
                     return;
                 }
                 clearForm();
                 setalldesable();
                 $('#<%=txtAge.ClientID%>').attr("disabled", false);
                 document.getElementById('<%=cmbTitle.ClientID%>').value = PatientData[0].Title;
                 document.getElementById('<%=txtPatientName.ClientID %>').value = PatientData[0].PName;
                 document.getElementById('<%=lbpid.ClientID %>').value = PatientData[0].Patient_ID;
                 document.getElementById('<%=txtPID.ClientID %>').value = pid;
                 document.getElementById('<%=txtAge.ClientID%>').value = PatientData[0].Age.split(' ')[0];
                 // document.getElementById('<%=ddlAge.ClientID%>').value = PatientData[0].Age.split(' ')[1];
                 document.getElementById('<%=ddlGender.ClientID%>').value = PatientData[0].Gender;
                
                 document.getElementById('<%=txtAddress.ClientID %>').value = PatientData[0].House_no
                 document.getElementById('<%=txtMobile.ClientID %>').value = PatientData[0].Mobile;
                 document.getElementById('<%=txtPhone.ClientID %>').value = PatientData[0].Phone;
             });

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

         function clearForm() {
             $('#<%=txtPatientName.ClientID %>').val('');
             $('#<%=ddlGender.ClientID %>').selectedIndex = 0;
             $('#<%=txtAddress.ClientID %>').val('');
             $('#<%=txtPhone.ClientID %>').val('');
             $('#<%=txtMobile.ClientID %>').val('');
             $('#<%=txtAge.ClientID %>').val('');
             $('#<%=txttokenno.ClientID %>').val('');
             $('#<%=txtComments.ClientID %>').val('');
             $('#molen').html('');
             $('#<%=cmbTitle.ClientID%>').prop("disabled", false);
             $('#<%=txtPatientName.ClientID%>').prop("disabled", false);
             $('#<%=txtMobile.ClientID%>').prop("disabled", false);
             $('#<%=txttokenno.ClientID%>').focus();
             $('#<%=txtPID.ClientID %>').val('');
             $('#<%=lbpid.ClientID %>').val('');
             
             $('#<%=cmbTitle.ClientID %>').selectedIndex = 0;
             $('#<%=chlapttime.ClientID%> option').remove();
             jQuery('#tblPaymentDetail tr').slice(1).remove();
             $('#txtGrossAmount').val(0);
             $('#txtNetAmount').val(0);
             $('#txtPaidAmount').val(0);
             $('#txtBlanceAmount').val(0);
             $('#divpaymode').show();
             $('[id$=ddlPanel]').prop('selectedIndex', 0);
             jQuery('#txtReferDoctor').val('SELF');
             jQuery('#hftxtReferDoctor').val('1');
             document.getElementById('<%=ddlCentreAccess.ClientID %>').selectedIndex = 0;
             //$('#tb_ItemList tr').remove();
             GetLastLabNo();
             $bindRateType();
             $bindDoctorlist();
         }


         function setalldesable() {
             $('#<%=cmbTitle.ClientID%>').prop("disabled", true);
              $('#<%=txtPatientName.ClientID%>').prop("disabled", true);
              $('#<%=txtMobile.ClientID%>').prop("disabled", true);
              $('#<%=txtAge.ClientID%>').prop("disabled", true);
              $('#<%=ddlGender.ClientID%>').prop("disabled", true);
             
              $('#<%=txtPhone.ClientID%>').prop("disabled", true);
              $('#<%=txtAddress.ClientID%>').prop("disabled", true);

              $('#<%=ddlAge.ClientID%>').prop("disabled", true);
           
              $('#<%=rdAge.ClientID%>').prop("disabled", true);
         }

         function hideshow() {
             $('.div_Patientinfo').slideToggle("slow");
             $('#searchdiv').show();
         }
         function hideshow1() {
             $('.div_Patientinfo').slideToggle("slow");
             $('#searchdiv').hide();
             $('#tdpatientdetail').hide();
             $('#tdPatient').hide();
         }

         function searchpatient() {
             if ($("#<%=txtMobile.ClientID%>").val().length == 10 || $("#<%=TextBox1.ClientID%>").val() != "") {                  
                 $('#tdpatientdetail').show();
                 $('#tdPatient').show();
                 var regno = $("#<%=txtPatSearch.ClientID%>").val();
                 var pname = $("#<%=txtPNameSearch.ClientID%>").val();
                 if ($("#<%=TextBox1.ClientID%>").val() == "") {
                     var mobile = $("#<%=txtMobile.ClientID%>").val();                     
                 }
                 else {
                     var mobile = $("#<%=TextBox1.ClientID%>").val();
                 }
                 var table = $("#tdPatient");

                 //if (mrno.length>0) {
                 serverCall('../OPDConsultation/Services/OPDSearch.asmx/bindoldpatient', { regno: regno, pname: pname, mobile: mobile }, function (response) {
                     var pdata = $.parseJSON(response)
                     if (pdata.length == 0) {
                         table.append($('<tr><td>' + '</td><td>' + '</td><td>' + '</td><td>' + '</td><td>' + '</td></tr>'));
                         toast("Error", "No Detail Found", "");
                         $('#tdpatientdetail').hide();
                         $('#tdPatient').hide();
                         //$('#page').css('display', 'none');
                         return;
                     }
                     else {
                         table.empty();
                         table.append($('<tr><td class="GridViewHeaderStyle">Select</td><td class="GridViewHeaderStyle">Sr.No</td><td class="GridViewHeaderStyle">RegNO:</td><td class="GridViewHeaderStyle">Patient name</td><td class="GridViewHeaderStyle">District</td><td class="GridViewHeaderStyle">State</td><td class="GridViewHeaderStyle">Age</td><td class="GridViewHeaderStyle">Gender</td><td class="GridViewHeaderStyle">Contact No</td><td class="GridViewHeaderStyle">Date of Reg</td></tr>'));
                         for (i = 0; i < pdata.length; i++) {
                             var a = i + 1;
                             table.append($('<tr style="text-align: left;"><td><input type="button" value="Select" onclick="getoldpatient(\'' + pdata[i].Patient_ID + '\');$getdob()"/>' + '</td><td>' + a + '</td><td>' + pdata[i].Patient_ID + '</td><td>' + pdata[i].patname +
                                 '</td><td>' + pdata[i].city + '</td><td>' + pdata[i].state + '</td><td>' + pdata[i].Age + '</td><td>' + pdata[i].Gender + '</td><td>' + pdata[i].Contact_No + '</td><td>' + pdata[i].Date + '</td></tr>'));
                         }
                     }

                 });
             }
         }

         function getoldpatient(pid) {
		     if($("#<%=TextBox1.ClientID%>").val() != "")
			 {
				$('.div_Patientinfo').slideToggle("slow");
			 }
             $('#searchdiv').hide();
             $('#tdpatientdetail').hide();
             $('#tdPatient').hide();
             $("#<%=txtPID.ClientID%>").val(pid);
             showoldpatient();
         }

         </script>

    <script type="text/javascript">
        $(document).ready(function () {
            GetLastLabNo();
            $bindDoctorlist();
            $bindRateType();
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
        });
    </script>
  
<script type="text/javascript">
    function up(lstr) {
        var str = lstr.value;
        lstr.value = str.toUpperCase();
    }
    function MoveUpAndDownText(textbox2, listbox2, textbox3) {
        var f = document.theSource;
        var listbox = listbox2;
        var textbox = textbox2;
        var textbox1 = textbox3;
        if (event.keyCode == 13) {
            __doPostBack('UpdatePanel1', '')
        }
        if (event.keyCode == '38' || event.keyCode == '40') {
            if (event.keyCode == '40') {
                for (var m = 0; m < listbox.length; m++) {
                    if (listbox.options[m].selected == true) {
                        if (m + 1 == listbox.length) {
                            return;
                        }
                        listbox.options[m + 1].selected = true;
                        textbox.value = listbox.options[m + 1].text;
                        textbox1.value = listbox.options[m + 1].Department;

                        return;
                    }
                }

                listbox.options[0].selected = true;
            }
            if (event.keyCode == '38') {
                for (var m = 0; m < listbox.length; m++) {
                    if (listbox.options[m].selected == true) {
                        if (m == 0) {
                            return;
                        }
                        listbox.options[m - 1].selected = true;
                        textbox.value = listbox.options[m - 1].text;
                        textbox1.value = listbox.options[m - 1].Department;
                        return;
                    }
                }
            }

        }
    }


    function suggestName(textbox2, listbox2, level) {
        if (isNaN(level)) { level = 1 }
        if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
            var listbox = listbox2;
            var textbox = textbox2;

            var soFar = textbox.value.toString();
            var soFarLeft = soFar.substring(0, level).toLowerCase();
            var matched = false;
            var suggestion = '';
            var m
            for (m = 0; m < listbox.length; m++) {
                suggestion = listbox.options[m].text.toString();
                suggestion = suggestion.substring(0, level).toLowerCase();
                if (soFarLeft == suggestion) {
                    listbox.options[m].selected = true;
                    matched = true;
                    break;
                }

            }
            if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
        }

    }
    function showlength() {
        if ($('#<%=txtMobile.ClientID%>').val() != "") {
              $('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
            }
            else {
                $('#molen').html('');
            }
    }

    function AutoGender() {
        var ddltitle = document.getElementById('<%=cmbTitle.ClientID%>');

        var ddltxt = ddltitle.options[ddltitle.selectedIndex].value;
        if (ddltxt == "Mrs." || ddltxt == "Miss." || ddltxt == "Baby." || ddltxt == "Ms." || ddltxt == "Smt.")

            document.getElementById('<%=ddlGender.ClientID%>').value = "Female";

        else

            document.getElementById('<%=ddlGender.ClientID%>').value = "Male";

    }
    function showshedule() {

        if ($("#<%=lstDoctor.ClientID%>").prop('selectedIndex') == -1) {
            toast("Error", "Please Select Doctor for Check Schedule", "");
            return;
        }
        $('#apptable1').empty();
        serverCall('../OPDConsultation/Services/OPDSearch.asmx/getdocsheduleforopd', { docid: $("#<%=lstDoctor.ClientID%> option:selected").val() }, function (response) {
            $responsedata = $.parseJSON(response);
            if ($responsedata.length == 0) {
                toast("Error", "No Schedule Found", "");
                return;
            }
            $('#apptable1').append('<tr id="Header"><td class="GridViewHeaderStyle" scope="col">Day</td><td class="GridViewHeaderStyle" scope="col">StartTime</td><td class="GridViewHeaderStyle" scope="col">EndTime</td><td class="GridViewHeaderStyle" scope="col">AvgTime</td><td class="GridViewHeaderStyle" scope="col">RoomNo</td><td class="GridViewHeaderStyle" scope="col">Fees</td></tr>');
            for (var a = 0; a <= $responsedata.length - 1; a++) {
                $('#apptable1').append('<tr><td>' + $responsedata[a].Day + '</td><td>' + $responsedata[a].starttime + '</td><td>' + $responsedata[a].endtime + '</td><td>' + $responsedata[a].avgtime + '</td><td>' + $responsedata[a].room_no + '</td><td>' + $responsedata[a].fee + '</td></tr>');

            }
            $find("<%=ModalPopupExtender1.ClientID%>").show();
        });
    }

    function checkDate(sender, args) {
        if (sender._selectedDate < new Date()) {
            sender._selectedDate = new Date();
            $('#<%=txtAppDate.ClientID%>').val(sender._selectedDate.format(sender._format));
        }
    }
   
    </script>
      


  <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center" >
            
                <b><asp:Label ID="llheader" runat="server" Text="New Registration"></asp:Label></b>
                
                <asp:TextBox ID="txtUniqueHash" runat="server" style="display:none;"></asp:TextBox>
                <br />
                 <div class="col-md-3 ">
			   <label class="pull-left">  Center   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                          <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess" runat="server"  onchange="GetLastLabNo(this.value)"></asp:DropDownList></div>
            
                            <div class="col-md-3 "> <b class="pull-right">Patient Type:</b></div>
                            <div class="col-md-5" style="text-align:left"><asp:DropDownList ID="ddlPatientType"  runat="server" onchange="$bindRateType()" TabIndex="1" >
				</asp:DropDownList></div>
                            <div class="col-md-3"><b class="pull-right">Rate Type:</b></div>
                            <div class="col-md-5" style="text-align:left"> 
                                 <asp:DropDownList ID="ddlPanel" runat="server" TabIndex="10" onchange="GetinvlistPanel()" ></asp:DropDownList>
                            </div>
                       
            </div>
        </div>
        <div class="div_Patientinfo">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Patient Info
            </div>
              <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">  Token No   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                  
                 <asp:TextBox ID="txttokenno" runat="server" TabIndex="1" ></asp:TextBox>
               </div>
                         <div class="col-md-3 ">
			   <label class="pull-left"><b> Last Token No </b></label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 "><b><asp:Label ID="lasttokenno" class="pull-left" Font-Bold="true" Font-Size="Large" ForeColor="Red" runat="server" style="font-weight:bold"></asp:Label></b>
                    </div>
                   <div class="col-md-3 ">
                           
                      </div>
                         
                           <div class="col-md-5 ">  
                            <input id="pop1" class="ItDoseButton" onclick="hideshow();" style="width: 87px;" type="button" value="Old Patients" />
                    </div>
                  </div>
            <div class="row" style="display:none" >
                    Reg No. :
                            <asp:TextBox ID="lbpid" runat="server" style="display:none;" />
                            
                                 <input id="pop2" class="ItDoseButton" onclick="openPopupApp('pop2');" style="width: 115px;display:none;"
                                type="button" value="Old Appointment"  />
                                 <asp:TextBox ID="hdn_appno" runat="server" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtPID" runat="server" CssClass="ItDoseTextinputText" Height="15px"
                                Width="100px" Enabled="false"></asp:TextBox>
                            <input type="button" id="btnviewold" value="Search" onclick="showoldpatient()" class="ItDoseButton" style="display:none;" />&nbsp;    
                  </div>  

                   <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left"> Patient Name  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-1 ">
                  
                         <asp:DropDownList ID="cmbTitle" runat="server" Width="50px"
                                TabIndex="2" onChange="return AutoGender();">

                            </asp:DropDownList></div>
                        <div class="col-md-4 ">
               <asp:TextBox ID="txtPatientName" CssClass="required" runat="server" data-title="Enter Patient Name" 
                               TabIndex="3" onkeyup="up(this)"></asp:TextBox>
                             </div>
                         <div class="col-md-3 ">
			   <label class="pull-left">Age </label>
			   <b class="pull-right"> <asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setAge(this)" GroupName="rdDOB" ForeColor="red" 
                                 /> </b>
		   </div>
		   <div class="col-md-5 ">
		 
                    <asp:TextBox ID="txtAge" runat="server" CssClass="required" Width="55px" onkeyup="$clearDateOfBirth(event);$getdob();" MaxLength="3" TabIndex="4" placeholder="Years" /><%--Year--%>
                                <asp:TextBox ID="txtAge1" runat="server" onkeyup="$clearDateOfBirth(event);$getdob();"  Width="55px" MaxLength="2" TabIndex="4" placeholder="Months" /><%--Month--%>
                                <asp:TextBox ID="txtAge2" runat="server" onkeyup="$clearDateOfBirth(event);$getdob();" Width="55px" MaxLength="2" TabIndex="4" placeholder="Days" /><%--Days--%>
		 <asp:DropDownList
                                ID="ddlAge" runat="server" Width="75px" Visible="false">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem>DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlGender" runat="server"  Width="80px">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                            </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="Fage" FilterType="Numbers,Custom" TargetControlID="txtAge"
                                runat="Server" ValidChars=".">
                            </cc1:FilteredTextBoxExtender> </div>
          	  <div class="col-md-3 ">
			   <label class="pull-left">DOB<asp:RadioButton ID="rdDOB" onclick="setDOB(this)" runat="server" GroupName="rdDOB"  /></label>
			   <b class="pull-right">:</b>
		   </div>
		 
                           <div class="col-md-3">               <asp:TextBox ID="txtDOB" onclick="$getdob()" placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" Enabled="false" ></asp:TextBox>	</div>
                       </div>
               <div class="row">
                                 <div class="col-md-3 ">
			   <label class="pull-left">Mobile No </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                        <asp:TextBox ID="txtMobile" runat="server" CssClass="required"     MaxLength="10" data-title="Enter Mobile No"
                          onchange="searchpatient()"  ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                            </cc1:FilteredTextBoxExtender>
               <input type="text" id="txtUHIDNo" style="display:none"  autocomplete="off" patientAdvanceAmount="0"     maxlength="15"  data-title="Enter UHID No." onkeyup="$patientSearchOnEnter(event);"/>
               </div>
		  <div class="col-md-3 ">
			   <label class="pull-left"> Phone </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                              <asp:TextBox ID="txtPhone" runat="server"  /><cc1:FilteredTextBoxExtender ID="fltPhone" runat="server" FilterType="Numbers"
                                    TargetControlID="txtPhone">
                                </cc1:FilteredTextBoxExtender></td>
               </div>
                           </div>
                       <div class="row">
	    
                            <div class="col-md-3 ">
			   <label class="pull-left">  Address  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                           
                            <asp:TextBox ID="txtAddress" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                                 MaxLength="100" ToolTip="Enter Address"
                                 TabIndex="5"     ></asp:TextBox>
                      </div>
                        <div class="col-md-3 ">
			   <label class="pull-left">  Comment  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">  <asp:TextBox ID="txtComments" runat="server"  ></asp:TextBox></div>    
            

                           <div class="col-md-3 ">
			   <label class="pull-left">  Refer Doctor  </label>
			   <b class="pull-right">:</b>
		   </div>
             <div class="col-md-5">
               <input  type="text"   id="txtReferDoctor" value="SELF"  data-title="Select Referred Doctor" maxlength="50"  />
                <input type="hidden" id="hftxtReferDoctor" value="1" />			
              </div>
		 </div>
                
            </div>
            </div>
        </div>
        <div class=".div_Patientinfo" style="display:none;" id="searchdiv">
            <div class="POuter_Box_Inventory" >
	             <div class="Purchaseheader">
	                      Old Patient Search
                    
	      </div>
	        <div class="row">
                   <div class="col-md-3 " >
			   <label class="pull-left">Patient ID </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
	                                    <asp:TextBox ID="txtPatSearch" runat="server"  TabIndex="1"></asp:TextBox>
	                                </div>
	                <div class="col-md-3 " >
			   <label class="pull-left">  Name </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
	                  
                       
	                       <asp:TextBox ID="txtPNameSearch" runat="server" TabIndex="2" class="txtonly"  data-title="Enter Patient Name" ></asp:TextBox>
	          </div>
              
             
                    <div class="col-md-3 " >
			   <label class="pull-left">Moblie </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
	               
	                                    <asp:TextBox ID="TextBox1" runat="server" 
	                                                TabIndex="3"   MaxLength="10" class="numbersOnly"></asp:TextBox>
                    
	                               </div></div>
           
	           
           
            
	          <div class="row" >
	                    <input type="button" id="Button4" value="Search" tabindex="9" class="ItDoseButton" onclick="searchpatient()" />
	                         <input type="button" id="btnnew" value="New Patient" tabindex="9" class="ItDoseButton" onclick="clearForm(); hideshow1();" />
	                </div>
            
	          

	                        </div>
    
	   
            
            </div>
     <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="tdpatientdetail" >
	           <div class="Purchaseheader" style="color: #663300">
	        Patient Detail</div>
	    <div class="content"> <div style="overflow:scroll; height:200px;" id="divscroll" ><%--onscroll="searchpatient()"--%>
	        <table id="tdPatient" width="100%" class="GridViewStyle" cellspacing="0" cellpadding="0"></table>
	         <input type="hidden" id="pagevalue" value="200" />
	    </div>
        </div>
                </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Doctor Detail</div>

            
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Visit Type </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="ItDoseDropdownbox"></asp:DropDownList>
                       
                   </div>
                 <div class="col-md-3 " >
			   <label class="pull-left"> Appointment Date </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
                        <asp:TextBox ID="txtAppDate" runat="server" onchange="getappointmentno();" ></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" OnClientDateSelectionChanged="checkDate" PopupButtonID="txtAppDate" TargetControlID="txtAppDate"></cc1:CalendarExtender>
                   </div>
                   <div class="col-md-3 " >
			   <label class="pull-left"> Appointment Time  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-3 " >
                             <asp:DropDownList ID="chlapttime" runat="server"> </asp:DropDownList>
                        <asp:Label ID="lblNoSchedule" runat="server" Text=""></asp:Label>
                    
                  </div>
                 </div>
        
             
  
              <div class="row">
                   <div class="col-md-3 " >
			   <label class="pull-left">Department </label>
			   <b class="pull-right">:</b>
		   </div>   <div class="col-md-5 " >
         <asp:DropDownList ID="ddldept" runat="server" onchange="$bindDoctorlist();" ></asp:DropDownList>
                   </div>
        </div>
            <div class="row">
                <div class="col-md-3 " >
			   <label class="pull-left">Doctor </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " > 
                        <asp:TextBox ID="txtDoctor" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                         onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtDoctor,ctl00$ContentPlaceHolder1$lstDoctor,ctl00$ContentPlaceHolder1$txtDepartment);"
                        onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtDoctor,ctl00$ContentPlaceHolder1$lstDoctor);"
                        TabIndex="9" ></asp:TextBox>
                        <br />
                    <asp:ListBox ID="lstDoctor" runat="server" CssClass="inputtext123"  Height="100px"
                        onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtDoctor,ctl00$ContentPlaceHolder1$lstDoctor,ctl00$ContentPlaceHolder1$txtDepartment);"
                        onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtDoctor,ctl00$ContentPlaceHolder1$lstDoctor);" onclick="getapptime();" >
                    </asp:ListBox></div>
                 <div class="col-md-8 " >
                         <input type="button" id="btnadditem" value="Add Doctor" onclick="AddItem()" style="font-weight:bold" />
                        <input type="button" id="btn" value="Show Doctor Schedule" onclick="showshedule()" style="font-weight:bold" />
                        &nbsp;&nbsp;  <asp:Label ID="lbappno" runat="server" Font-Bold="true"></asp:Label>
                   </div>
                  <div class="col-md-8">
                    
                      <div id="mydatalist" style=" height: 125px; overflow-y: auto; overflow-x: hidden;">
						<table id="tb_ItemList" width="100%" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="LabHeader">
									<th class="GridViewHeaderStyle" scope="col" style="">SrNo</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="">Doctor</th>
									<th class="GridViewHeaderStyle" scope="col" style="">Time</th> 
                                    <th class="GridViewHeaderStyle" scope="col" style="">Rate</th>  
									<th class="GridViewHeaderStyle" scope="col" style="">#</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>

                   </div>
            </div>

               </div>
              <div class="POuter_Box_Inventory" id="divPaymentControl">
        <div style="margin-top: 0px;" class="row">
		    <div class="col-md-12 " >
                <div id="divpaymode">              
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
				<div  id="divPaymentMode" class="col-md-19"></div>
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
      </div>    
            
             
            
             
            <div class="col-md-12">  
                <div class="row" >
                  <div class="col-md-5">
				   <label class="pull-left">Discount Amt.</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                   <input  id="txtDiscAmt" class="ItDoseTextinputNum" onkeyup="getamount();"  value="0" autocomplete="off"  type="text"  />
				</div>
				 
                <div class="col-md-5">
				   <label class="pull-left">Discount By</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-8">
					<select  id="ddlApprovedBy">						
					</select>
				</div>			
			</div>	

            <div class="row" >
            <div class="col-md-5">
				   <label class="pull-left">Discount Percent</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-3">
                   <input  id="txtDiscPer" class="ItDoseTextinputNum"  value="0" onkeyup="getDiscAmt();" autocomplete="off"  type="text"  />
				</div>

                 <div class="col-md-5">
				   <label class="pull-left">Discount Reason</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-8">
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
                    <b class="pull-right"></b>
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
                 <div class="col-md-5">
                     </div>
                 <div class="col-md-3">
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
                    </div>
                 </div>
            <div class="col-md-11">                     
                    </div>
         </div>
          </div>
               <div class="POuter_Box_Inventory" style="text-align:center" >
                   <input type="button" style="margin-left:-190px;margin-top:7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$save();" />
               </div>
    <asp:Button ID="Button1" style="display:none;" runat="server" />
    
<asp:Panel ID="mypanel" runat="server"  style="display:none"  BackColor="#ffff99" BorderStyle="None" Width="500px" Height="200px">
      
       <table id="apptable1" width="90%"></table>
    <br />
    <br />
        <center><asp:Button ID="hideme" runat="server" Text="Close" /></center>
    </asp:Panel>
               <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="hideme" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="mypanel">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button2" style="display:none;" runat="server" />


    <asp:Button ID="Button3" style="display:none;" runat="server" /> 
     <%-- /**Payment Mode Script**/--%>
     <script type="text/javascript" id="paymentmode">

         $getPaymentMode = function (con, callback) {
             if ($('#<%=ddlPanel.ClientID%>').val().split('#')[1].length > 0) {
                 if ($('#<%=ddlPanel.ClientID%>').val().split('#')[2] == "Cash" || $('#<%=ddlPanel.ClientID%>').val().split('#')[20] == "1") {
                     if (con == 0) {
                         $('#tblPaymentDetail tr').slice(1).remove();
                         $bindPaymentMode(function (response) {
                             paymentModes = $.extend(true, [], response);
                             if (paymentModes.length > 0) {
                                 paymentModes.patientAdvanceAmount = Number($('#txtUHIDNo').attr('patientAdvanceAmount'));
                                 var patientAdvancePaymentModeIndex = paymentModes.map(function (item) { return item.PaymentModeID; }).indexOf(9);
                                 if (patientAdvancePaymentModeIndex > -1) {
                                     if (paymentModes.patientAdvanceAmount < 1)
                                         paymentModes.splice(patientAdvancePaymentModeIndex, 1);
                                     else
                                         paymentModes[patientAdvancePaymentModeIndex].PaymentMode = paymentModes[patientAdvancePaymentModeIndex].PaymentMode + '(' + paymentModes.patientAdvanceAmount + ')';
                                 }
                                 var $responseData = $('#scPaymentModes').parseTemplate(paymentModes);
                                 $('#divPaymentMode').html($responseData);
                                 $('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=1]').prop('checked', true);
                                 $validatePaymentModes(1, 'Cash', Number($('#txtNetAmount').val()), $('#ddlCurrency'), function (response) {
                                     $bindPaymentDetails(response, function (response) {
                                         $bindPaymentModeDetails($('#divPaymentMode').find('input[type=checkbox][name=paymentMode]:checked'), response, function (data) {

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
                         $validatePaymentModes(1, 'Cash', Number($('#txtNetAmount').val()), $('#ddlCurrency'), function (response) {
                             $bindPaymentDetails(response, function (response) {
                                 $bindPaymentModeDetails($('#divPaymentMode').find('input[type=checkbox][name=paymentMode]:checked'), response, function (data) {
                                 });
                             });
                         });
                     }
                     $("#divPaymentDetails,#divDiscountBy,#divDiscountReason,.isReciptsBool,.divOutstanding,.isReciptsBool1,.clPaidAmt").show();
                     $(".isReciptsBool").css("height", 84);
                     $("#txtAmountGiven").val('');
                     $("#tblPaymentDetail").tableHeadFixer({
                     });
                 }
                 else {
                     $("#divPaymentMode").remove();
                     $("#divPaymentMode").append("<input id='chkPaymentMode4' name='paymentMode' type='checkbox' value='4' checked='checked' disabled='disabled'/><b>Credit</b>");
                     $("#divPaymentDetails,#divDiscountBy,#divDiscountReason,.divOutstanding,.clPaidAmt").hide();
                     $("#chkCashOutstanding").prop('checked', false);
                     $("#txtOutstandingAmt").val('');
                     $("ddlOutstandingEmployee").prop('selectedIndex', 0);
                     $(".isReciptsBool").css("height", 30);
                 }
                 if ($('#<%=ddlPanel.ClientID%>').val().split('#')[4] == "1") {
                     $("#divPaymentMode,.isHideRate").hide();
                 }
                 else {
                     $("#divPaymentMode,.isHideRate").show();
                 }

                 if ($('#<%=ddlPanel.ClientID%>').val().split('#')[20] == "1") {

                     $(".paientpaypercentage,.clpaybypatient,.clpaybypanel").show();
                     $("#divDiscountBy,#divDiscountReason").hide();
                 }
                 else {
                     $(".paientpaypercentage,.clpaybypatient,.clpaybypanel").hide();
                 }
             }
         };
         var $paymentModeCache = [];
         var $bindPaymentMode = function (callback) {
             var $IsCache = $paymentModeCache.filter(function (i) { if (i.PanelID == $('#<%=ddlPanel.ClientID%>').val().split('#')[0]) { return i } });
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
                $('#divPaymentDetails').find('#' + parseInt(parseInt(ddlCurrency.val()) + parseInt(elem.value))).remove();

                if ($(".clChequeNo").length == 0)
                    $('.clHeaderChequeNo').hide();
                else
                    $('.clHeaderChequeNo').show();
                if ($(".clChequeDate").length == 0)
                    $('.clHeaderChequeDate').hide();
                else
                    $('.clHeaderChequeDate').show();
                if ($(".clBankName").length == 0)
                    $('.clHeaderBankName').hide();
                else
                    $('.clHeaderBankName').show();
                if ($('#tblPaymentDetail tr').hasClass('Cash'))
                    $("#txtAmountGiven").removeAttr('disabled', 'disabled');
                else {
                    $("#txtAmountGiven").val('');
                    $("#txtAmountGiven").prop('disabled', 'disabled');
                }
                $calculateTotalPaymentAmount(function () { });
                return;
            }
            $validatePaymentModes(elem.value, $(elem).next('b').text(), Number($('#txtNetAmount').val()), $('#ddlCurrency'), function (response) {
                $bindPaymentDetails(response, function (response) {
                    $bindPaymentModeDetails($(elem), response, function (data) {
                        $bindBankMaster(data.bankControl, data.IsOnlineBankShow, function () {
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
                totalPaidAmount: $totalPaidAmount,
                defaultPaidAmount: 0,
                patientAdvanceAmount: Number($('#txtUHIDNo').prop('patientAdvanceAmount')),
                roundOffAmount: Number($('#txtControlRoundOff').val()),
                currentCurrencyName: $.trim($($ddlCurrency).find('option:selected').text()),
                currentCurrencyNotation: $.trim($($ddlCurrency).find('option:selected').text()),
                baseCurrencyName: $.trim($('#spnBaseCurrency').text()),
                baseCurrencyNotation: $.trim($('#spnBaseNotation').text()),
                currencyFactor: Number($('#spnCFactor').text()),
                paymentMode: $.trim($PaymentMode),
                PaymentModeID: Number($PaymentModeID),
                currencyID: Number($ddlCurrency.val()),
                currencyRound: $($ddlCurrency).find('option:selected').data("value"),
                Converson_ID: Number($('#spnConversion_ID').text()),
                isInBaseCurrency: false
            }
            if (data.baseCurrencyNotation.toLowerCase() == data.currentCurrencyNotation.toLowerCase())
                data.isInBaseCurrency = true;
            callback(data);
        }
        var $bindBankMaster = function (bankControls, IsOnlineBankShow, callback) {
            $getBankMaster(function (response) {
                response = $.grep(response, function (value) {
                    return value.IsOnlineBank == IsOnlineBankShow;
                });
                $(bankControls).bindDropDown({ data: response, valueField: 'BankName', textField: 'BankName', defaultValue: '', selectedValue: '', showDataValue: '1' });
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

            $temp.push($.trim(data.$paymentDetails.S_CountryID));
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

            if (IsShowDetail.data('ischequenoshow') == 1)
                $('.clHeaderChequeNo').show();
            $temp.push('<td id="tdCardNo" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('ischequenoshow') == 0 ? '"style="display:none">' : ' clChequeNo">');
            $temp.push(IsShowDetail.data('ischequenoshow') == 0 ? '' : '<input type="text" autocomplete="off" class="requiredField" id="txtCardNo" />');
            $temp.push('</td>');

            if (IsShowDetail.data('ischequedateshow') == 1)
                $('.clHeaderChequeDate').show();
            $temp.push('<td id="tdCardDate" class="GridViewLabItemStyle ');
            $temp.push(IsShowDetail.data('ischequedateshow') == 0 ? '"style="display:none">' : ' clChequeDate">');
            $temp.push(IsShowDetail.data('ischequedateshow') == 0 ? '' : '<input type="text" autocomplete="off" readonly  class="setCardDate requiredField" id="txtCardDate_');
            $temp.push(data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID); $temp.push('"/>');
            $temp.push('</td>');

            if (IsShowDetail.data('isbankshow') == 1)
                $('.clHeaderBankName').show();
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
            if ($('#tblPaymentDetail tr').hasClass('Cash'))
                $("#txtAmountGiven").removeAttr('disabled', 'disabled');
            else {
                $("#txtAmountGiven").val('');
                $("#txtAmountGiven").prop('disabled', 'disabled');
            }
        }
        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            var _temp = [];
            if ((Number($('#ddlCurrency').val()) == Number('<%=Resources.Resource.BaseCurrencyID%>')) && (parseFloat($('#txtUHIDNo').prop('patientAdvanceAmount')) > 0)) {
                $('input[type=checkbox][name=paymentMode][value=9]').prop('disabled', false);
            }
            else {
                $('input[type=checkbox][name=paymentMode][value=9]').prop('checked', false).prop('disabled', 'disabled');
            }
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
    $(function () {
        $onRefDoctorSearch();
        $bindDiscountApprovalAndOutStandingEmp();
        $getCurrencyDetails(function (baseCountryID) {
            $getConversionFactor(baseCountryID, function (CurrencyData) {
                jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));

            });
        });
    });
    var $calculateTotalPaymentAmount = function (event, row, callback) {
        var $totalPaidAmount = 0;
        jQuery('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
        var $netAmount = ($('[id$=ddlPanel]').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
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
                 jQuery('#txtBlanceAmount').val(precise_round(parseFloat(($('[id$=ddlPanel]').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtpaybypatientfinal').val()) : parseFloat(jQuery('#txtNetAmount').val()))) - parseFloat(jQuery('#txtPaidAmount').val()), '<%=Resources.Resource.BaseCurrencyRound%>'));
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
          var $onPaidAmountChanged = function (e) {
              var row = jQuery(e.target).closest('tr');
              var $countryID = Number(row.find('#tdS_CountryID').text());
              var $PaymentModeID = Number(row.find('#tdPaymentModeID').text());
              var $paidAmount = Number(e.target.value);
              if (isNaN($paidAmount) || $paidAmount == "")
                  $paidAmount = 0;
              if ($PaymentModeID == "9" && parseFloat($paidAmount) > parseFloat(jQuery('#txtUHIDNo').prop('patientAdvanceAmount'))) {
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
          $f_Receipt = function () {
              debugger;
              var $dataRC = new Array();
              if (parseFloat(jQuery('#txtNetAmount').val()) > 0) {
                  jQuery("#tblPaymentDetail").find('tbody tr').each(function () {
                      var $PatientPaidAmount = jQuery(this).closest('tr').find('#txtPatientPaidAmount').val();
                      if (isNaN($PatientPaidAmount) || $PatientPaidAmount == "")
                          $PatientPaidAmount = 0;
                      if ($PatientPaidAmount > 0) {
                          var $objRC = new Object();
                          debugger;
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
                          $objRC.CentreID = $('#<%=ddlCentreAccess.ClientID%> option:selected').val();
                         $objRC.TIDNumber = "";
                         $objRC.Panel_ID = $('#<%=ddlPanel.ClientID%>').val().split('#')[0];
                         $objRC.CurrencyRoundDigit = 0;
                         $objRC.Converson_ID = jQuery(this).closest('tr').find('#tdConverson_ID').text();
                         $dataRC.push($objRC);
                     }
                 });
             }
             return $dataRC;
         }
    </script> 
    <%--End of Payment Mode--%>
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
   <script type="text/javascript" id="Script1">
       var $save = function () {
           if ($validation() == false) {
               return;
           }
           var $patientdata = $patientMaster();
           var $ledgertransaction = $f_ledgertransaction();
           var $PLOdata = $patientLabInvestigationOPD();
           if ($PLOdata == "") {
               $modelUnBlockUI(function () { });
               return;
           }
           var $Rcdata = $f_Receipt();

           jQuery("#btnSave").prop('disabled', true).val('Submitting...');
           serverCall('OPDCONSULTATION.aspx/SaveNewRegistration', { PatientData: $patientdata, LTData: $ledgertransaction, PLO: $PLOdata, Rcdata: $Rcdata }, function (response) {
               var $responseData = JSON.parse(response);

               if ($responseData.status) {
                   toast("Success", "Record Saved Successfully", "");
                   clearForm();
                   $modelUnBlockUI(function () { });
               }
               else {

                   toast("Error", $responseData.response, "");
                   $modelUnBlockUI(function () { });
               }

               jQuery("#btnSave").removeAttr('disabled').val('Save');
           });
       }
    
       function $patientMaster() {
           debugger;
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
             Patient_ID: $('#<%=txtPID.ClientID%>').val(),
             Title: jQuery("#cmbTitle option:selected").text(),
             PName: jQuery.trim(jQuery('#txtPatientName').val()),
             House_No: jQuery.trim(jQuery('#txtAddress').val()),
             Street_Name: "",
             PinCode: 0,
             Country: "",
             State: "",
             City: "",
             Locality: "",
             CountryID: 0,
             StateID: 0,
             CityID: 0,
             LocalityID: 0,
             Phone: jQuery.trim(jQuery('#txtPhone').val()),
             Mobile: jQuery.trim(jQuery('#txtMobile').val()),
             Email: "",
             Age: $age,
             AgeYear: $ageyear,
             AgeMonth: $agemonth,
             AgeDays: $ageday,
             TotalAgeInDays: $ageindays,
             DOB: jQuery('#txtDOB').val(),
             Gender: jQuery("#ddlGender option:selected").text(),
             CentreID: jQuery('#ddlCentreAccess option:selected').val(),
             IsOnlineFilterData: "0",
             IsDuplicate: 0,
             isCapTure: "",
             base64PatientProfilePic: "",
             IsDOBActual: jQuery('#rdDOB').is(':checked') ? 1 : 0,
             ClinicalHistory: jQuery.trim(jQuery('#txtComments').val()),
             VIP:  0
         });
         return $objPM;
     }
     function $f_ledgertransaction() {
         var $objLT = new Object();
         $objLT.NetAmount = jQuery.trim(jQuery('#txtNetAmount').val());
         $objLT.GrossAmount = jQuery.trim(jQuery('#txtGrossAmount').val());
         $objLT.IsCredit =  0;
         //$objLT.DiscountReason = "";
         //$objLT.DiscountApprovedByID = 0;
         //$objLT.DiscountApprovedByName = "";
         $objLT.Remarks = "";
         $objLT.Panel_ID = jQuery("#ddlPanel").val().split('#')[0];
         $objLT.PanelName = jQuery('#ddlPanel option:selected').text().substr(jQuery('#ddlPanel option:selected').text().indexOf(' ') + 1);
         $objLT.Doctor_ID = jQuery("#hftxtReferDoctor").val() == "" ? "1" : jQuery("#hftxtReferDoctor").val();
         $objLT.DoctorName = jQuery("#hftxtReferDoctor").val() == "" ? "SELF" : jQuery('#txtReferDoctor').val().split('#')[0];

         //$objLT.OtherReferLabID = 0;
         $objLT.VIP =  0;
         $objLT.CentreID = jQuery('#ddlCentreAccess option:selected').val();
         $objLT.Adjustment = jQuery('#txtPaidAmount').val() == "" ? 0 : jQuery('#txtPaidAmount').val();
         //$objLT.HomeVisitBoyID = "";
         //$objLT.PatientIDProof = "";
         //$objLT.PatientIDProofNo =  "";
         //$objLT.PatientSource = "";
         //$objLT.PatientType = "";
         //$objLT.VisitType = "";
         //$objLT.HLMPatientType = "";
         //$objLT.HLMOPDIPDNo = "";
         if ($('#txtDiscAmt').val() != 0 || $('#txtDiscAmt').val() != "")
         {
             $objLT.DiscountOnTotal = $('#txtDiscAmt').val();
             $objLT.DiscountReason = jQuery('#txtDiscountReason').val();
             $objLT.DiscountApprovedByID = jQuery('#ddlApprovedBy').val().split('#')[0];
             $objLT.DiscountApprovedByName = jQuery('#ddlApprovedBy').val() != 0 ? jQuery('#ddlApprovedBy option:selected').text() : "";
         }
         else
         {
             $objLT.DiscountOnTotal = 0;
             $objLT.DiscountReason = "";
             $objLT.DiscountApprovedByID = 0;
             $objLT.DiscountApprovedByName = "";
         }
         //$objLT.DiscountPending =  0;
         //$objLT.DiscountID =  0;
         //$objLT.DiscountID =  0;
         //$objLT.MemberShipCardNo = "";
         //$objLT.MembershipCardID = "";
         //$objLT.IsSelfPatient = "";
         //$objLT.AppointmentID =  0;
         //$objLT.HomeCollectionAppID =  0;
        
         //$objLT.IsInvoice = jQuery('#ddlPanel').val().split('#')[10];
         //$objLT.showBalanceAmt = jQuery('#ddlPanel').val().split('#')[11];
         $objLT.CentreName = jQuery('#ddlCentreAccess option:selected').text();
         //$objLT.DiscountType =  0;
         //$objLT.PatientTypeID = "";
         //$objLT.PreBookingID =  0;
         //$objLT.Doctor_ID_Temp = "";
         //$objLT.COCO_FOCO = "";
         //$objLT.Type1ID = "";
         //$objLT.BarCodePrintedType = "";
         //$objLT.BarCodePrintedCentreType = "";
         //$objLT.BarCodePrintedHomeColectionType = "";
         //$objLT.setOfBarCode = "";
         //$objLT.SampleCollectionOnReg = "";
         //$objLT.InvoiceToPanelId = "";
         //$objLT.OtherLabRefNo = "";
       
             //$objLT.OutstandingEmployeeId = 0;
             //$objLT.CashOutstanding = 0;
             //$objLT.CashOutstandingPer = 0;
         

         //$objLT.SecondReferenceID = "";
         //$objLT.SecondReference = "";
         //$objLT.AttachedFileName = "";
         //$objLT.TempSecondRef = "";
         $objLT.Currency_RoundOff =  0 ;
         //$objLT.DispatchModeID = "";
         //$objLT.DispatchModeName = "";
         //$objLT.AppBelowBaseRate = "";
         $objLT.OPDConsultationTokenNo = jQuery('#txttokenno').val();
         return $objLT;
     }
     var ItemWiseDisc = 0;
     function $patientLabInvestigationOPD() {
         var $dataPLO = new Array();
         var $rowNum = 1;
         var $amtValue = 0;
         jQuery('#tb_ItemList tr').each(function () {
             var id = jQuery(this).closest("tr").prop("id");
             if (id != "LabHeader") {
                 var $objPLO = new Object();
                 $objPLO.ItemId = jQuery.trim(jQuery(this).closest("tr").find("#tdItem_ID").html());
                 $objPLO.ItemName = jQuery(this).closest("tr").find("#tdItem").text();
                 $objPLO.ItemCode = "";
               
                 $objPLO.InvestigationName = jQuery.trim(jQuery(this).closest("tr").find("#tdItem").text());
                     $objPLO.PackageName = "";
                     $objPLO.PackageCode = "";
                     $objPLO.Investigation_ID = jQuery.trim(jQuery(this).closest("tr").find("#td_Type_ID").html());
                     $objPLO.IsPackage = "0";
                     $objPLO.IsReporting = "0";
                     $objPLO.ReportType = "0";
                     $objPLO.IsSampleCollected = "N";
                     $objPLO.SampleBySelf = "0";
                 
                     $objPLO.SubCategoryID = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryID").html());
                     $objPLO.MRP = jQuery.trim(jQuery(this).closest("tr").find("#txtRate").val());
                     $objPLO.Rate = jQuery.trim(jQuery(this).closest("tr").find("#txtRate").val());
                 //$objPLO.BaseRate = "";
               
                 //    $objPLO.DiscountByLab = 0;
                 //$objPLO.DiscountAmt = "";
                     $objPLO.Amount = jQuery.trim(jQuery(this).closest("tr").find("#txtRate").val());

                 //$objPLO.PayByPanel = "";
                 //$objPLO.PayByPanelPercentage = "";
                 //$objPLO.PayByPatient = "";

                 $objPLO.CentreID = jQuery('#ddlCentreAccess option:selected').val();
                 //$objPLO.TestCentreID = "0";
                 //$objPLO.isUrgent =  0;
                 //$objPLO.DeliveryDate = "";
                 $objPLO.SRADate = jQuery.trim(jQuery(this).closest("tr").find("#tdtime").html());
                 $objPLO.SampleCollectionDate = jQuery('#<%=txtAppDate.ClientID%>').val();
                 //$objPLO.IsScheduleRate = "";
                 //$objPLO.PanelItemCode = "";
                 //$objPLO.RequiredAttachment = "";
                 //$objPLO.RequiredAttchmentAt = "";
                 //$objPLO.EncryptedRate = "";
                 //$objPLO.EncryptedAmount = "";
                 //$objPLO.EncryptedDiscAmt = "";
                 //$objPLO.EncryptedItemID = "";
                 //$objPLO.EncryptedMRP = "";
                 //$objPLO.IsSampleCollectedByPatient =  0;
                 $objPLO.Quantity = "1";
                 //$objPLO.DepartmentDisplayName = "";

                 //$objPLO.IsMemberShipFreeTest = "";
                 //$objPLO.MemberShipDisc = "";
                 //$objPLO.MemberShipTableID = "";
                 //$objPLO.IsMemberShipDisc = "";
                 $objPLO.SubCategoryName = jQuery.trim(jQuery(this).closest("tr").find("#tdSubCategoryName").text());
                 $dataPLO.push($objPLO);

             }
         });
       
     
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
                     $objRC.CentreID = jQuery('#ddlCentreAccess option:selected').val();
                     $objRC.TIDNumber = "";
                     $objRC.Panel_ID = jQuery("#ddlPanel").val().split('#')[0];
                     $objRC.CurrencyRoundDigit = 0;
                     $objRC.Converson_ID = jQuery(this).closest('tr').find('#tdConverson_ID').text();
                     $dataRC.push($objRC);
                 }
             });
         }
         return $dataRC;
     }

     function AddItem() {
         var itemid = $('#<%=lstDoctor.ClientID%>').val();
         if ($("#<%=lstDoctor.ClientID%>").prop('selectedIndex') == -1) {
             toast("Error", "Please Select Doctor to add", "");
             return;
         }
         var time = $('#<%=chlapttime.ClientID%> option:selected').val();
         if (time == "") {
             toast("Error", "Appointment Time", "");
             return;
         }
         var IsValid = true;
         $("#tb_ItemList tr").each(function () {
             if (itemid == $(this).closest('tr').find("#td_Type_ID").html()) {
                 IsValid = false;
             }
         });
         if (!IsValid) {
             toast("Error", "Doctor Already selected");
             return false;
         }
        
         serverCall('OPDCONSULTATION.aspx/AddItem', { Type_ID: itemid, PatientID: $('#<%=txtPID.ClientID%>').val(), subcategoryid: $('#<%=ddlCategory.ClientID%>').val(), AppDate: $('#<%=txtAppDate.ClientID%>').val(), Apptime: time }, function (response) {
             var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        $responseData = $responseData.response;
                        if ($responseData.length == 0) {
                            toast("Error", "No Data Found", "");
                            $('#mydatalist').hide();
                            return;
                        }
                        else {
                            
                            for (var i = 0; i < $responseData.length; i++) {
                              
                                var $myData = [];
                                $myData.push("<tr style='background-color:White;'>");
                                $myData.push("<td class='GridViewLabItemStyle' style='width:9%'>");
                                $myData.push(parseInt(i + 1));
                                $myData.push("</td>");
                                $myData.push('<td class="GridViewLabItemStyle" style="display:none" id="td_Type_ID">');
                          
                                $myData.push($responseData[i].Type_ID); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="display:none" id="tdItem_ID">'); $myData.push($responseData[i].itemid); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="display:none" id="tdSubCategoryID">'); $myData.push($responseData[i].SubCategoryID); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="display:none" id="tdSubCategoryName">'); $myData.push($responseData[i].Name); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" id="tdItem">'); $myData.push($responseData[i].Item); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" id="tdtime">'); $myData.push(time); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" id="tdRate">'); $myData.push('<input type="text" style="width:60px" onkeyup="txtRateVal(this);" ');
                             
                                $myData.push(' value="'); $myData.push($responseData[i].Rate); $myData.push('"');
                                $myData.push(' id="txtRate" /></td>');
                                $myData.push('<td class="GridViewLabItemStyle">'); $myData.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="remove(this)"/>'); $myData.push('</td>');
                               
                                $myData.push("</tr>");
                                $myData = $myData.join("");
                                $('#tb_ItemList').append($myData);
                                $('#mydatalist').show();
                            }
                           
                        }
                        getamount();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                       // $('#mydatalist').hide();
                    }
                });
     }
       function txtRateVal(id) {

           id.value = id.value.replace(/[^0-9]/g, '');
           getamount();
       }
       function remove(ctrl) {
           var mm = $(ctrl).closest('tr').find('#tdItem_ID').html();
           var table = document.getElementById('tb_ItemList');
           table.deleteRow(ctrl.parentNode.parentNode.rowIndex);
           var DoctorID = $(ctrl).closest('tr').find('#td_Type_ID').html();
           serverCall('OPDCONSULTATION.aspx/DeleteTempDoc', { DoctorID: DoctorID }, function (response) {
               var $response = $.parseJSON(response);
           });
       }
       function getDiscAmt()
       {
           
           var amt = 0;
           
           $("#tb_ItemList tr").each(function () {
               var id = $(this).closest("tr").attr('id');
               if (id != "LabHeader") {
                   amt = amt + parseFloat($(this).closest('tr').find("#txtRate").val());
               }
           });
           if (parseFloat($('#txtDiscPer').val()) > 100) {
               $('#txtDiscPer').val("");
               $('#txtDiscAmt').val("");
               $('#txtNetAmount').val(amt);
               toast("Error", "You can not enter discount percenteage more than 100% !!", "");
               $('#txtDiscPer').focus();
               return false;

           }
           if ($('#txtDiscPer').val() != 0 || $('#txtDiscPer').val() != "") {
               var discAmt = (amt * parseFloat($('#txtDiscPer').val())) / 100;
               $('#txtDiscAmt').val(discAmt);
               
           }
           getamount();
       }
       function getamount() {
           var amt = 0;
           var amtNet = 0;
           $("#tb_ItemList tr").each(function () {
               var id = $(this).closest("tr").attr('id');
               if (id != "LabHeader") {
                   amt = amt + parseFloat($(this).closest('tr').find("#txtRate").val());
               }
           });
           amtNet = amt;

           if ($('#txtDiscAmt').val() != 0 || $('#txtDiscAmt').val() != "")
           {
               if (parseFloat($('#txtDiscAmt').val()) > 0 && jQuery('#ddlApprovedBy').val() == "0") {
                   $('#txtDiscPer').val("");
                   $('#txtDiscAmt').val("");
                   $('#txtNetAmount').val(amt);
                   toast("Error", "Please Select Discount Approved By", "");
                   jQuery("#ddlApprovedBy").focus();
                   return false;
               }
               if (Number(jQuery('#txtDiscAmt').val()) > 0 || Number(jQuery('#txtDiscPer').val()) > 0) {
                   var $discpersetinmaster = jQuery('#ddlApprovedBy').val().split('#')[1];
                   var $discpertotal = 0;
                  
                   if (jQuery('#txtDiscAmt').val() > 0)
                           $discpertotal = (parseFloat(jQuery('#txtDiscAmt').val()) * 100) / parseFloat(jQuery('#txtGrossAmount').val());
                       else
                           $discpertotal = (parseFloat(jQuery('#txtDiscPer').val()) * 100) / parseFloat(jQuery('#txtGrossAmount').val());
                  
                   if (parseInt($discpertotal) > $discpersetinmaster) {
                       toast("Error", "Discount Percentage Limit Exceed <br/> Max Discount Should be: " + $discpersetinmaster + "%", "");
                       $('#txtDiscPer').val("");
                       $('#txtDiscAmt').val("");
                       $('#txtNetAmount').val(amt);
                       jQuery('#ddlApprovedBy').focus();
                       return false;
                   }
               }
              
               if(parseFloat($('#txtDiscAmt').val()) > amt)
               {
                   $('#txtDiscPer').val("");
                   $('#txtDiscAmt').val("");
                   $('#txtNetAmount').val(amt);
                   toast("Error", "You can not enter discount  more than Gross Amount !!", "");
                   $('#txtDiscAmt').focus();
                   return false;
               }
               var discPer = 0;
               amtNet = amt - parseFloat($('#txtDiscAmt').val());
               if(parseFloat($('#txtDiscAmt').val()) != 0)
               {
                   discPer = parseFloat((parseFloat($('#txtDiscAmt').val()) / amt) * 100);
               }
               $('#txtDiscPer').val(discPer);
           }

           
         
           $('#txtGrossAmount').val(amt);

           $('#txtNetAmount').val(amtNet);
       }
       $validation = function () {
          
           if (jQuery('#txtPatientName').val().trim().length == 0) {
               toast("Error", "Please Enter Patient Name", "");
               jQuery('#txtPatientName').focus();
               return false;
           }
           if (jQuery('#txtPatientName').val().trim().charAt(0) == ".") {
               toast("Error", "Please Enter Valid Patient Name, First Character cannot be Dot", "");
               jQuery('#txtPatientName').focus();
               return false;
           }
           if ($('#<%=ddlCentreAccess.ClientID%>').val() == 0) {
               toast("Error", "Please Select  Centre", "");
               jQuery('#ddlCentreAccess').focus();
               return false;
           }
           //if()
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
           if (jQuery('#txtDOB').val().length == 0) {
               toast("Error", "Please Enter DOB", "");
               jQuery('#txtDOB').focus();
               return false;

           }
           if (jQuery('#txtMobile').val().length == 0) {
               toast("Error", "Please Enter Mobile No.", "");
               jQuery('#txtMobile').focus();
               return false;
           }
           if (jQuery('#txtMobile').val().length != 0) {
               if (jQuery('#txtMobile').val().length < 10) {
                   toast("Error", "Incorrect Mobile No.", "");
                   jQuery('#txtMobile').focus();
                   return false;
               }
           }
           var $count = jQuery('#tb_ItemList tr').length;
           if ($count == 0 || $count == 1) {
               toast("Error", "Please Select Doctor", "");
               jQuery('#txtDoctor').focus();
               jQuery("#txtDoctor").attr('autocomplete', 'off');
               return false;
           }
           if (jQuery('#txttokenno').val() == "") {
               toast("Error", "Please Enter Token No.", "");
               jQuery('#txttokenno').focus();
               return false;
           }
       }
   </script> 
    <script type="text/javascript">
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }

        var $bindDiscountApprovalAndOutStandingEmp = function () {
            jQuery("#ddlApprovedBy option").remove();
            jQuery('#ddlOutstandingEmployee option').remove();
            var $ddlApprovedBy = jQuery('#ddlApprovedBy'); var $ddlOutstandingEmployee = jQuery('#ddlOutstandingEmployee');
            serverCall('../Common/Services/CommonServices.asmx/bindDiscountApprovalAndOutStandingEmp', { CentreID: $('#ddlCentreAccess').val(), IsDiscountApproval: 1, IsOutStandingEmp: 1 }, function (response) {
                $ddlApprovedBy.bindDropDown({ data: JSON.parse(response).DiscountApprovalData, valueField: 'value', textField: 'label', isSearchAble: true, defaultValue: "Select" });
                $ddlOutstandingEmployee.bindDropDown({ data: JSON.parse(response).OutstandingEmployeeData, valueField: 'EmployeeID', textField: 'Name', isSearchAble: true, defaultValue: "Select" });

            });
        };
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
                               docname: extractLast(request.term), centreid: $('#ddlCentreAccess').val() //jQuery('#ddlCentre option:selected').val().split('#')[0]
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
    </script> 

     </asp:Content>


