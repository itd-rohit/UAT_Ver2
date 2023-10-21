<%@ Page Title="" ClientIDMode="Static"  Language="C#" EnableEventValidation="false" MasterPageFile="~/Design/DefaultHome.master"  AutoEventWireup="true" CodeFile="RadiologyAppointment.aspx.cs" Inherits="Design_Appointment_RadiologyAppointment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">    
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
        <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>    
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/InvalidContactNo.js"></script>
        
     <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
        <%: Scripts.Render("~/bundles/confirmMinJS") %>
        <%: Scripts.Render("~/bundles/PostReportScript") %>
    <style type="text/css">
        .example1 {
            height: 40px;
            overflow: hidden;
            position: relative;
        }

            .example1 h3 {
                font-size: 2em;
                color: limegreen;
                position: absolute;
                width: 100%;
                height: 70%;
                margin: 0;
                line-height: 50px;
                text-align: center;
                /* Starting position */
                -moz-transform: translateX(100%);
                -webkit-transform: translateX(100%);
                transform: translateX(100%);
                /* Apply animation to this element */
                -moz-animation: example1 15s linear infinite;
                -webkit-animation: example1 15s linear infinite;
                animation: example1 15s linear infinite;
            }
        /* Move it (define the animation) */
        @-moz-keyframes example1 {
            0% {
                -moz-transform: translateX(100%);
            }

            100% {
                -moz-transform: translateX(-100%);
            }
        }

        @-webkit-keyframes example1 {
            0% {
                -webkit-transform: translateX(100%);
            }

            100% {
                -webkit-transform: translateX(-100%);
            }
        }

        @keyframes example1 {
            0% {
                -moz-transform: translateX(100%);
                -webkit-transform: translateX(100%);
                transform: translateX(100%);
            }

            100% {
                -moz-transform: translateX(-100%);
                -webkit-transform: translateX(-100%);
                transform: translateX(-100%);
            }
        }       

        .auto-style1 {
            font-size: large;
        }

        .scrollit {
            overflow: scroll;
            height: 100px;
        }      

        .auto-style1 {
            font-size: large;
        }
       

        .auto-style1 {
            font-size: large;
        }      

        .auto-style1 {
            font-size: large;
        }

        .asterisk_input:after {
            content: " *";
            color: #e32;
        }
        ul.ui-autocomplete {
            z-index: 1100;
        }
    </style>
  
 
     
     <script type="text/javascript">
         $("#tblContainer").ready(function () {
             showDeptName();
             
         });
         $(document).ready(function () {
             $('[id$=btnsearch]').click();
             showDeptName();           
         });
         function showDeptName() {
             $("#mytable tr:first td").each(function () {
                 $(this).html($(this).html().split('#')[0]);
             });
             fillColor();
           //  scrolify($('#mytable'), 425);
            //   scrolify($('#mytable'), 425); // 425 is height            
         }        
         var mouseX;
         var mouseY;
         $(document).mousemove(function (e) {
             mouseX = e.pageX;
             mouseY = e.pageY;
         });
         function showappdetail(url, crl) {           
             var appdetais = encodeURIComponent(crl);
             $('#deltadiv').load(url);
             $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
             $modelUnBlockUI(function () { });

         }        
         function hidedelta() {
             $('#deltadiv').hide();
             $('#deltadiv').empty();
         }       
         function mergeData() {

             $('mytable tr').each(function () {
                 var tr = $(this);
                 var tds = $('#td_');
                 var tdA = $('#Address');               
             });            

             $(function () {
                 function groupTable($rows, startIndex, total) {
                     if (total === 0) {
                         return;
                     }

                 }
                 groupTable($('#mytable tr:has(td)'), 0, 3);
                 $('#mytable .deleted').remove();
             });
         }
         function fillColor() {            
             //  return;
             $('#mytable tr td').each(function () {
                 var n = $(this).html().indexOf('~');
                 //alert(n);
                 if (n > 0) {
                     var ItemData = ($(this).html());
                     var len = ItemData.split('~').length;
                     //alert(len);
                     var Item = [];
                     Item.length = len;
                     Item = ItemData.split('~');
                     var tmpRecord = '';
                     for (var i = 0; i < len; i++) {
                         var toPrint = '0';
                         tmpRecord += Item[i].split('#')[1] + "#" + Item[i].split('#')[4] + "#" + Item[i].split('#')[5] + "#" + Item[i].split('#')[6] + "#" + Item[i].split('#')[9] + "~";
                         //PatientName#Iscancel#IsBooked#PatientType#IsConfirmed
                         var lenn = tmpRecord.split('~').length;
                         //alert();
                         var Itemm = [];
                         Itemm.length = lenn;
                         Itemm = tmpRecord.split('~');
                         var tblTempRecord = "<table>";
                         for (var ii = 0; ii < lenn - 1; ii++) {
                             var tdColorCode = Itemm[ii].split('#')[1] + '|' + Itemm[ii].split('#')[2] + "|" + Itemm[ii].split('#')[3] + "|" + Itemm[ii].split('#')[4];

                             //Iscancel#IsBooked#PatientType#IsConfirmed
                             tblTempRecord += "<tr>";
                             tblTempRecord += "<td style='border: 2px solid black;cursor: pointer;background-color:";
                             if (tdColorCode.split('|')[0] == '1') {
                                 tblTempRecord += "pink";
                             }
                             else if (tdColorCode.split('|')[2] == 'VIP' && tdColorCode.split('|')[1] == '0' && tdColorCode.split('|')[3] == '0') {                                
                                 tblTempRecord += "#E9967A";
                             }
                             else if (tdColorCode.split('|')[2] == 'VIP' && tdColorCode.split('|')[3] == '1' && tdColorCode.split('|')[1] == '0') {

                                 tblTempRecord += "Orange";
                             }
                             else if (tdColorCode.split('|')[2] == 'VIP' && tdColorCode.split('|')[1] == '1') {                                
                                 tblTempRecord += "#00FFFF";
                             }
                             else if (tdColorCode.split('|')[2] == 'Normal' && tdColorCode.split('|')[1] == '0' && tdColorCode.split('|')[3] == '0') {
                                 tblTempRecord += "White";
                             }
                             else if (tdColorCode.split('|')[2] == 'Normal' && tdColorCode.split('|')[3] == '1' && tdColorCode.split('|')[1] == '0') {                                
                                 tblTempRecord += "Yellow";
                             }
                             else if (tdColorCode.split('|')[2] == 'Normal' && tdColorCode.split('|')[1] == '1') {
                                 tblTempRecord += "#90EE90";
                             }                            
                             tblTempRecord += ";'>";
                             tblTempRecord += Itemm[ii].split('#')[0];
                             tblTempRecord += "</td>";
                             tblTempRecord += "</tr>";
                         }
                         tblTempRecord += "</table>";

                         if (Item[i].split('#')[4] == '1') {
                             toPrint = '1';
                         }
                         else if (Item[i].split('#')[5] == '0') {
                             toPrint = '1';
                         }
                         else if (Item[i].split('#')[5] == '1') {
                             toPrint = '1';
                         }
                         if (toPrint == '1') {
                             $(this).html(tblTempRecord);
                         }
                     }
                 }

                 var singleRecColor = $(this).html().split('#')[4] + '#' + $(this).html().split('#')[5] + '#' + $(this).html().split('#')[6] + '#' + $(this).html().split('#')[9];
                 //if (singleRecColor != "") { alert(singleRecColor); }
                 //Iscancel#IsBooked#PatientType#IsConfirmed
                 var singtblRecord = "<table>";
                 singtblRecord += "<tr>";
                 singtblRecord += "<td style='border: 2px solid black;cursor:pointer;background-color:";
                 var printSingle = '0';

                 if (singleRecColor.split('#')[0] == '1') {
                     singtblRecord += "pink";
                     printSingle = '1';
                 }
                     //vip  & notbooked
                 else if (singleRecColor.split('#')[2] == 'VIP' && singleRecColor.split('#')[1] == '0' && singleRecColor.split('#')[3] == '0') {

                     singtblRecord += "#E9967A";

                     printSingle = '1';
                 }
                     //vip  & confirmed
                 else if (singleRecColor.split('#')[2] == 'VIP' && singleRecColor.split('#')[3] == '1' && singleRecColor.split('#')[1] == '0') {
                     // alert('1');
                     singtblRecord += "Orange";
                     printSingle = '1';
                 }
                     // vip & Booked
                 else if (singleRecColor.split('#')[2] == 'VIP' && singleRecColor.split('#')[1] == '1') {

                     singtblRecord += "#00FFFF";
                     printSingle = '1';
                     //alert();
                 }
                     //normal  & notbooked & Not confirmed
                 else if (singleRecColor.split('#')[2] == 'Normal' && singleRecColor.split('#')[1] == '0' && singleRecColor.split('#')[3] == '0') {
                     //  alert('0');
                     singtblRecord += "White";
                     printSingle = '1';
                 }
                     //normal  & confirmed
                 else if (singleRecColor.split('#')[2] == 'Normal' && singleRecColor.split('#')[3] == '1' && singleRecColor.split('#')[1] == '0') {
                     // alert('1');
                     singtblRecord += "Yellow";
                     printSingle = '1';
                 }

                     //normal  & booked
                 else if (singleRecColor.split('#')[2] == 'Normal' && singleRecColor.split('#')[1] == '1') {
                     // alert('1');
                     singtblRecord += "#90EE90";
                     printSingle = '1';
                 }               

                 singtblRecord += ";'>";
                 singtblRecord += $(this).html().split('#')[1];
                 singtblRecord += "</td>";
                 singtblRecord += "</tr>";
                 singtblRecord += "</table>";
                 if (printSingle == '1') {
                     $(this).html(singtblRecord);
                 }
             });
         }

         var PatientData = "";
         var ctrl = "";
         $(document).ready(function () {
             var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
             $('#PatientLabSearchOutput').html(output);

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
         function CallSearch() {
             document.getElementById('<%= btnsearch.ClientID %>').click();
         }      
         $(function () {
             $("#<%=txtMobile.ClientID%>").keydown(
                 function (e) {
                     var key = (e.keyCode ? e.keyCode : e.charCode);
                     if (key == 13) {
                         e.preventDefault();
                         SearchOldPatient();
                     }
                     else if (key == 9) {
                         SearchOldPatient();
                     }
                 });
         });

         function SearchOldPatient() {          
             if ($('#<%=txtMobile.ClientID%>').val() == "") {
                 return;
             }
                $("#tboldpatient").empty();            
             serverCall('RadiologyAppointment.aspx/getoldpatient', { mobile: $("#<%=txtMobile.ClientID%>").val() }, function (response) {
                 var PatientData = JSON.parse(response);               
                 if (PatientData.length == 0) {                    
                     toast("Info", "No Record Found..!");
                     return;
                 }
                 $('#tboldpatient').append('<tr id="Header"><td class="GridViewHeaderStyle" scope="col">Select</td><td class="GridViewHeaderStyle" scope="col">Name</td><td class="GridViewHeaderStyle" scope="col">Gender</td><td class="GridViewHeaderStyle" scope="col">Age</td><td class="GridViewHeaderStyle" scope="col">Mobile</td><td class="GridViewHeaderStyle" scope="col">Visit/App Date</td><td class="GridViewHeaderStyle" scope="col">Visit/App Time</td></tr>');
                 for (var a = 0; a <= PatientData.length - 1; a++) {
                     $('#tboldpatient').append('<tr  id=' + PatientData[a].ID + '><td align="center"><a href="javascript:void(0);"   onclick="BindOldpatientData(\'' + PatientData[a].ID + '\',\'' + PatientData[a].Mobile + '\')">Select</a></td><td>' + PatientData[a].PatientName + '</td><td>' + PatientData[a].Gender + '</td><td>' + PatientData[a].AgeYear + '</td><td>' + PatientData[a].Mobile + '</td><td>' + PatientData[a].AppDate + '</td><td>' + PatientData[a].AppTime + '</td></tr>');

                 }
                 $find("<%=ModelPopupExtender3.ClientID%>").show();
             });
         }

         function BindOldpatientData(ID, Mobile) {
             $find("<%=ModelPopupExtender3.ClientID%>").hide();
             serverCall('RadiologyAppointment.aspx/getoldpatientdetail', { ID: ID, Mobile: Mobile }, function (response) {
                 var PatientData1 = JSON.parse(response);// eval('[' + result + ']');
                 debugger;
                 $('#<%=ddltimeslot.ClientID%>').val(PatientData1[0].TimeSlotCount);
                 $('#<%=txtMobile.ClientID%>').val(PatientData1[0].Mobile);
                 $('#<%=txtpinno.ClientID%>').val(PatientData1[0].Pincode);
                 $('#<%=txtpname.ClientID%>').val(PatientData1[0].PatientName);
                 $('#<%=txtAge.ClientID%>').val(PatientData1[0].AgeYear);
                 $('#<%=txtAge1.ClientID%>').val(PatientData1[0].AgeMonth);
                 $('#<%=txtAge2.ClientID%>').val(PatientData1[0].AgeDays)
                 $('#<%=txtaddress.ClientID%>').val(PatientData1[0].Address);
                 $('#<%=txtaddress1.ClientID%>').val(PatientData1[0].Address1);
                 $('#<%=txtaddress2.ClientID%>').val(PatientData1[0].Address2);
                 $('#<%=txtemail.ClientID%>').val(PatientData1[0].EmailID);               
             });
         }
         function receiptreprint(ID) {
             $Encrypt(ID, function (EAppoinmentNo) {
                 window.open('AppointmentReceipt.aspx?AppointmentID=' + EAppoinmentNo);
                 return;
             });
          }
         function GetinvlistPanel() {
             var PanelID = $('#<%=ddlPanel.ClientID%>').val().split('#')[1];            
             if (PanelID == 0 || PanelID == undefined) {
                 toast("Error", "Please select Rate Type", "");                
                 return;
             }           
         }      
         function checkDate(sender, args) {

             if (sender._selectedDate < new Date()) {
                 //alert("You can not select Back date.!");
                 sender._selectedDate = new Date();
                 // set the date back to the current date
                 $('#ctl00_ContentPlaceHolder1_dtFrom').val(sender._selectedDate.format(sender._format));
             }

         }

         function checkDate1(sender, args) {

             if (sender._selectedDate < new Date()) {
                 //alert("You can not select Back date.!");
                 sender._selectedDate = new Date();
                 // set the date back to the current date
                 $('#ctl00_ContentPlaceHolder1_txtredate').val(sender._selectedDate.format(sender._format));
             }

         }


         function openmypopup(ctrl1, whichCall, deptid, time, deptname) {            
             if (whichCall.trim() == '2') {
                 deptid = deptid.split('#')[1];
                 deptname = deptname.split('#')[0];
             }            
             var CentreID = $('[id$=ddlCentreAccess]').val();
             clearform();            
             $('[id$=ddlCentreAccess1]').val(CentreID).trigger("chosen:updated.chosen");
             CentreID = '';             
             $('#<%=lbmsg.ClientID%>').html('');
             $('#<%=lblphilboid.ClientID%>').html(deptid);
             $('#<%=lblphilboname.ClientID%>').html(deptname);
             $('#<%=lbltimeslot.ClientID%>').html(time);

             $bindRateType();                       
             $('#openappointmentdiv').show();           
             getappdata();
             ctrl = ctrl1;
             $('#<%=txtMobile.ClientID%>').focus();
          }
         function wopen() {
             var apid = ""
             if ($('#<%=lbidforedit.ClientID%>').html() == "") {
             $('#<%=hdn_RandomNo.ClientID%>').val('');
             var x = Math.floor(Math.pow(10, 12 - 1) + Math.random() * (Math.pow(10, 12) - Math.pow(10, 12 - 1) - 1));
             $('#<%=hdn_RandomNo.ClientID%>').val(x);
             apid = x;
         }
             else {
                 apid = $('#<%=lbidforedit.ClientID%>').html();
             }
             window.open('AddFileAppointment.aspx?AppID='+ apid,null,' status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
         }
          function showlength() {
              if ($('#<%=txtMobile.ClientID%>').val() != "") {
                 $('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
             }
             else {
                 $('#molen').html('');
             }
         }
         function changecolor(ctr) {
             $(ctr).css("background-color", "pink");
         }
         function changecolor1(ctr) {
             $(ctr).css("background-color", "white");
         }
         function $Closeappointmentdiv() {           
             $('#openappointmentdiv').hide();
             // window.location.reload();
             $('[id$=btnsearch]').click();
         }
         function clearform() {            
             document.getElementById('<%=ddltimeslot.ClientID %>').selectedIndex = 0;
             $('#hftxtReferDoctor').val('1');
             $('#<%=txtpname.ClientID%>').val('');
             $('#<%=txtMobile.ClientID%>').val('');
             $('#<%=txtaddress.ClientID%>').val('');
             $('#<%=txtaddress1.ClientID%>').val('');
             $('#<%=txtaddress2.ClientID%>').val('');
             $('#<%=txtpinno.ClientID%>').val('');
             $('#<%=txtemail.ClientID%>').val('');
             document.getElementById('<%=ddlGender.ClientID %>').selectedIndex = 0;
             $('#<%=txtedit.ClientID%>').val('');
             $('#<%=txtbooked.ClientID%>').val('');
             $('#<%=txtbooked1.ClientID%>').val('');
             $('#<%=txtre.ClientID%>').val('');
             $('#<%=txtAge.ClientID%>').val('');
             $('#<%=txtAge1.ClientID%>').val('');
             $('#<%=txtAge2.ClientID%>').val('');
             $('[id$=btnsaveslot]').val('Save Data');
             $('[id$=btnsaveslot]').attr('disabled', false);
             $('#<%=ddlPanel.ClientID%>').trigger('chosen:updated');
             $('#txtGrossAmount').val(0);
             $('#txtNetAmount').val(0);
             $('#txtPaidAmount').val(0);
             $('#txtBlanceAmount').val(0);
             $('#divpaymode').show();
             $('#txtReferDoctor').val('SELF');
             $('#hftxtReferDoctor').val('1');
             $('[id$=ddlPanel]').prop('selectedIndex', 0);             
             document.getElementById('<%=ddlCentreAccess1.ClientID %>').selectedIndex = 0;
             $('#molen').html('');
             $('#<%=txtMobile.ClientID%>').focus();
             $('#lblamt').html('');
             $('#testtable tr').remove();
             lblamttotal = 0;
             $('#<%=lbidforedit.ClientID%>').html('');
             $('#<%=lblbookingnum.ClientID%>').html('');
             $('#<%=txtremark.ClientID%>').val('');
             $('#<%=txtcancelreason.ClientID%>').val('');
             jQuery('#tblPaymentDetail tr').slice(1).remove();
         }


         function getappdata() {
             var Centre = $('#<%=ddlCentreAccess1.ClientID%> :selected').val();
             serverCall('RadiologyAppointment.aspx/getappdata', { deptid: $('#<%=lblphilboid.ClientID%>').html(), date: $('#<%=dtFrom.ClientID%>').val(), time: $('#<%=lbltimeslot.ClientID%>').html(), Centre: Centre }, function (response) {
                 PatientData = eval('[' + response + ']');                 
                 var len = PatientData.length;
                 if (PatientData.length == 0) {
                     $('#PatientLabSearchOutput').empty();
                     return;
                 }
                 $('#<%=lblbookingnum.ClientID%>').html(len);                    
                     var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                     $('#PatientLabSearchOutput').html(output);                   
             });          
         }
         function validation() {
             if ($('[id$=txtMobile]').val() == "") {
                 toast("Error", "Please Enter Mobile No..!", "");
                 $('#<%=txtMobile.ClientID%>').focus();
                 return false;
             }
             if ($('[id$=txtpname]').val() == "") {
                 toast("Error", "Please Enter Patient Name..!", "");
                 $('#<%=txtpname.ClientID%>').focus();
                 return false;
             }
             if ($('[id$=txtAge]').val() == "") {
                 toast("Error", "Please Enter Age..!", "");
                 $('#<%=txtAge.ClientID%>').focus();
                 return false;
             }
            
             if ($('[id$=txtMobile]').val().length < 10) {                 
                 toast("Error", "Incorrect Mobile No..!", "");
                 $('#<%=txtMobile.ClientID%>').focus();
                 return false;
             }
             if ($('[id$=txtaddress]').val() == "") {                 
                 toast("Error", "Please Enter Address..!", "");
                 $('#<%=txtaddress.ClientID%>').focus();
                 return false;
             }
             if ($('#<%=ddltimeslot.ClientID%> option:selected').val() == "") {                
                 toast("Error", "Please Select Time Slot..!", "");
                 $('#<%=ddltimeslot.ClientID%>').focus();
                 return false;
             }             
             if ($('#<%=ddlPanel.ClientID%> option:selected').val() == "0" || $('#<%=ddlPanel.ClientID%> option:selected').val() == "") {              
                 toast("Error", "Please Select Panel..!", "");
                 $('#<%=ddlPanel.ClientID%>').focus();
                 return false;
             }            
             var PatientType = $('input[name="PatientType"]:checked').val();            
             if (PatientType == undefined) {              
                 toast("Error", "Please Select PatientType Vip or normal..!", "");
                 return false;
             }
             if ($('#txtReferDoctor').val() == "" || $('#hftxtReferDoctor').val() == "") {
                 toast("Error", "Please Enter Referred Doctor", "");
                 $("#txtReferDoctor").focus();
                 return false;
             }
             return true;
         }
         function gettestdata() {
             var $Mydata = new Array();
             $('#testtable tr').each(function () {
                 debugger;
                 var $objdata = new Object();
                 $objdata.ItemName = $(this).closest('tr').find('#tdItemName').text();
                 $objdata.Rate = $(this).closest('tr').find('#tdRate').text();
                 $objdata.ItemID = $(this).closest('tr').find('#hdnId').val();
                 $objdata.GrossAmount = $("#txtGrossAmount").val();
                 $objdata.Adjustment = $("#txtPaidAmount").val();
                 $objdata.NetAmount = $("#txtNetAmount").val();
                 $objdata.DoctorID = $("#hftxtReferDoctor").val() == "" ? "1" : $("#hftxtReferDoctor").val();
                 $objdata.SubcategoryID = $('#<%=lblphilboid.ClientID%>').html();
                 $objdata.SubcategoryName = $('#<%=lblphilboname.ClientID%>').html();
                 $objdata.date =$('#<%=dtFrom.ClientID%>').val();
                 $objdata.Time =$('#<%=lbltimeslot.ClientID%>').html();
                 $objdata.PName =$('#<%=txtpname.ClientID%>').val();
                 $objdata.Mobile =$('#<%=txtMobile.ClientID%>').val();
                 $objdata.Address =$('#<%=txtaddress.ClientID%>').val();
                 $objdata.Address1 =$('#<%=txtaddress1.ClientID%>').val();
                 $objdata.Address2 =$('#<%=txtaddress2.ClientID%>').val();
                 $objdata.Emailid = $('#<%=txtemail.ClientID%>').val();
                 $objdata.Pinno =$('#<%=txtpinno.ClientID%>').val();
                 $objdata.Ageyear =$('#<%=txtAge.ClientID%>').val();
                 $objdata.Agemonth =$('#<%=txtAge1.ClientID%>').val();
                 $objdata.Agedays =$('#<%=txtAge2.ClientID%>').val();
                 $objdata.Gender =$('#<%=ddlGender.ClientID%> option:selected').text();
                 $objdata.Appid =$('#<%=lbidforedit.ClientID%>').html();
                 $objdata.PanelID =$('#<%=ddlPanel.ClientID%> option:selected').val().split('#')[0];
                 $objdata.Title =$('#<%=cmbTitle.ClientID%> option:selected ').val();
                 $objdata.Centre =$('#<%=ddlCentreAccess.ClientID%> :selected').val();
                 $objdata.Type =$('#<%=txtedit.ClientID%>').val();
                 $objdata.Booked =$('#<%=txtbooked.ClientID%>').val();
                 $objdata.Bookingnumber =$('#<%=ddltimeslot.ClientID%> option:selected').val();
                 $objdata.Bookingnum =$('#<%=lblbookingnum.ClientID%>').html();
                 $objdata.PatientType =$('input[name="PatientType"]:checked').val();
                 $objdata.Remarks =$('#<%=txtremark.ClientID%>').val();
                 $objdata.fAppId =$('#<%=hdn_RandomNo.ClientID%>').val();
                 $objdata.PanelType =$('#<%=ddlPatientType.ClientID%>').val();

                 $Mydata.push($objdata);
             });
             return $Mydata;
         }

         function savealldata() {                                  
             if (!validation())
                 return;
             var $Rcdata = $f_Receipt();            
             var test = gettestdata();
             if (test == "") {
                 alert("Please select investigation..!!");
                 return;
             }
             $('[id$=btnsaveslot]').attr('disabled',true).val('submitting...');
             serverCall('RadiologyAppointment.aspx/savealldate', { Rcdata: $Rcdata,Appdata:test }, function (response) {
                 var $response = JSON.parse(response);
                 if ($response.status) {
                     if ($response.response == "saved") {
                         toast("Success", "Slot Book for Radiology Appointment..!", "");
                        // createtable(ctrl, $('#<%=lblphilboid.ClientID%>').html(), $('#<%=lbltimeslot.ClientID%>').html(), "tr_" + $response.Appdata, $('input[name="PatientType"]:checked').val());
                         getappdata();                        
                         $('[id$=ddlPanel]').prop('selectedIndex', 0);
                         clearform();
                     }
                     else {
                         toast("Success", "Booking Updated..!", "");
                         getappdata();                       
                         $('[id$=ddlPanel]').prop('selectedIndex', 0);
                         clearform();
                     }
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });
         }
       
     function createtable(ctrl, phid, phtime, trid, PatientType) {
         var title = $('#<%=txtaddress.ClientID%>').val() + $('#<%=txtaddress1.ClientID%>').val() + $('#<%=txtaddress2.ClientID%>').val() + $('#<%=txtpinno.ClientID%>').val() + $('#<%=txtMobile.ClientID%>').val();
         if ($(ctrl).find('.inner tr').length == 0) {
             var mydata = '<table class="inner" frame="box" border="1" rules="all" id=' + phid + '_' + phtime + '>';
             if (PatientType == "Normal")
                 mydata += '<tr id=' + trid + ' style="background-color:white;" title=' + title + '>';
             else
                 mydata += '<tr id=' + trid + ' style="background-color:chocolate;" title=' + title + '>';
             mydata += '<td>' + $('#<%=txtpname.ClientID%>').val() + '</td>';

             mydata += '</tr></table>';
             $(ctrl).html(mydata);
         }
         else {
             if (PatientType == "Normal")
                 var mydata = '<tr id=' + trid + ' style="background-color:white;" title=' + title + '>';
             else
                 mydata += '<tr id=' + trid + ' style="background-color:chocolate;" title=' + title + '>';
             mydata += '<td>' + $('#<%=txtpname.ClientID%>').val() + '</td>';

             mydata += '</tr>';
             $(ctrl).find('.inner').append(mydata);
         }
     }

         function up(lstr) {
             var str = lstr.value;
             lstr.value = str.toUpperCase();
         }

         function opencncelpoup(id, IsBooked) {
             $('#<%=lbcencelid.ClientID%>').html(id);
         $find("<%=ModalPopupExtender1.ClientID%>").show();
         $('#<%=txtbooked1.ClientID%>').val(IsBooked);
         $('#<%=txtcancelreason.ClientID%>').focus();
     }


     function openshepopup(id, IsBooked) {       
         var CentreID = $('[id$=ddlCentreAccess1]').value;
         clearform();         
         CentreID = '';
         $('#<%=lblresid.ClientID%>').html(id);
         $('#<%=lblcrph.ClientID%>').html($('[id$=lblphilboname]').html());
         $('#<%=lblcutme.ClientID%>').html($('[id$=lbltimeslot]').html());
         $('#<%=txtre.ClientID%>').val(IsBooked);
         $("#<%=ddlphe.ClientID%> option:contains(" + $('[id$=lblphilboname]').html() + ")").attr('selected', 'selected');
         $('#<%=txtreremarks.ClientID%>').val('');
         $find("<%=ModalPopupExtender2.ClientID%>").show();
     }
         function cencelme() {
                 
             var id = $('#<%=lbcencelid.ClientID%>').html();
             if ($('#<%=txtcancelreason.ClientID%>').val() == "") {
                 toast("Error", "Please Enter Reason..!", "");
                 $('#<%=txtcancelreason.ClientID%>').focus();
                 return;
             }
             serverCall('RadiologyAppointment.aspx/cencelapp', { id: id, reason: $('#<%=txtcancelreason.ClientID%>').val(), Booked: $('#<%=txtbooked1.ClientID%>').val() }, function (response) {
                 var $response = JSON.parse(response);
                 if ($response.status) {
                     toast("Success", $response.response, "");
                     $find("<%=ModalPopupExtender1.ClientID%>").hide();                  
                     getappdata();
                     $('#tr_' + id).css('background-color', 'pink');
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });
         }        
         function ConfirmAppointment(ID) {
             serverCall('RadiologyAppointment.aspx/ConfirmAppointment', { ID: ID }, function (response) {
                 var $response = JSON.parse(response);
                 if ($response.status) {
                     toast("Success", "Appointment Confirmed...!", "");
                     getappdata();                    
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });
         }
         function deletemyrol(ctrl11) {
             var mm = $(ctrl11).closest('tr').find('#tdRate').text();
             var table = document.getElementById('testtable');
             table.deleteRow(ctrl11.parentNode.parentNode.rowIndex);
             var cc = $('#lblamt').html();
             var aa = parseFloat(cc) - parseFloat(mm);
             $('#lblamt').html(aa);
             lblamttotal = aa;
             $('#txtGrossAmount').val(aa);
             $('#txtNetAmount').val(aa);
             $('#<%=lbmsg.ClientID%>').html("");
         }

         function editme(id) {
            
             serverCall('RadiologyAppointment.aspx/editappgetdata', { id: id }, function (response) {
                 var PatientDataApp = JSON.parse(response);
                // PatientDataApp = eval('[' + result.d + ']');
                 clearform();
                 $('[id$=btnsaveslot]').val('Update');
                 $('#<%=ddlPatientType.ClientID%>').val(PatientDataApp[0].PanelType);
                 $bindRateType();                 
                 $('#<%=ddltimeslot.ClientID%>').val(PatientDataApp[0].TimeSlotCount);
                     $('#<%=txtpname.ClientID%>').val(PatientDataApp[0].PatientName);
                 $('#<%=txtMobile.ClientID%>').val(PatientDataApp[0].Mobile);                 
                 $('#<%=txtaddress.ClientID%>').val(PatientDataApp[0].Address);
                 $('#<%=txtaddress1.ClientID%>').val(PatientDataApp[0].Address1);
                 $('#<%=txtaddress2.ClientID%>').val(PatientDataApp[0].Address2);
                 $('#<%=txtpinno.ClientID%>').val(PatientDataApp[0].PinCode)
                 $('#<%=txtemail.ClientID%>').val(PatientDataApp[0].EmailID);
                 $('#<%=ddlGender.ClientID %>').val(PatientDataApp[0].Gender);
                 $('#<%=txtAge.ClientID%>').val(PatientDataApp[0].AgeYear);
                 $('#<%=txtAge1.ClientID%>').val(PatientDataApp[0].AgeMonth);
                 $('#<%=txtAge2.ClientID%>').val(PatientDataApp[0].AgeDays);
                 $('#lblamt').html(PatientDataApp[0].GrossAmount);                 
                 $('#divpaymode').hide();
                 $("#hftxtReferDoctor").val(PatientDataApp[0].Referdoctor)
                 $('#txtGrossAmount').val(PatientDataApp[0].GrossAmount);
                 $('#txtNetAmount').val(PatientDataApp[0].NetAmount);
                 $('#txtPaidAmount').val(PatientDataApp[0].Adjustment);
                 $('#<%=lbidforedit.ClientID%>').html(id);                 
                 $('#<%=ddlCentreAccess1.ClientID%>').val(PatientDataApp[0].CentreID);                                              

                 $('#<%=txtedit.ClientID%>').val("1");
                 $('#<%=txtbooked.ClientID%>').val(PatientDataApp[0].IsBooked);                 
                 $('input[name=PatientType][value=' + PatientDataApp[0].PatientType + ']').prop('checked', 'checked');                 
                 $('#molen').html('10');                
                
                 for (var ac = 0; ac <= PatientDataApp.length - 1; ac++) {
                     var output = [];                                     
                         output.push('<tr>');
                         output.push('<td align="centre">'); output.push(parseFloat(ac + 1)); output.push('</td>');
                         output.push('<td id="tdDept"  class="GridViewLabItemStyle"  style="width:100px;">');
                         output.push('<input type="hidden" id="hdnId" value="');
                         output.push(PatientDataApp[ac].ItemID);
                         output.push('"/>');
                         output.push(PatientDataApp[ac].DeptName); output.push('</td>');
                         output.push('<td class="GridViewLabItemStyle" id="tdItemName">');
                         output.push(PatientDataApp[ac].Investigation); output.push('</td>');
                         output.push('<td  class="GridViewLabItemStyle" id="tdRate">');
                         output.push(PatientDataApp[ac].Rate); output.push('</td>');

                         output.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletemyrol(this)"/></td>');
                         output.push('</tr>');
                         output = output.join('');
                         $("#testtable").append(output);
                         var rowpos = $('#testtable tr:last').position();
                         $('#scdiv').scrollTop(rowpos.top);                                             
                 }
             });             
         }

         function PatientLabSearch(status)
         {
             $('#<%=hdnstatus.ClientID%>').val(status);
             $('#<%=btnsearch.ClientID%>').trigger("click");
         }

         function Rescheduleme() {
             if ($('#<%=txtre.ClientID%>').val() == "1") {
                 toast("Error", "You can not reschedule this. It is already booked...!", "");
                 return;
             }
             if ($('#<%=txtreremarks.ClientID%>').val() == "") {
                 toast("Error", "Please enter Remarks!", "");
                 return;
             }             
             var $oldapptime = $('#<%=lblcutme.ClientID%>').html();
             var Centre = $('#<%=ddlCentreAccess.ClientID%> option:selected').val();           
             serverCall('RadiologyAppointment.aspx/changeappdatetime', { appid: $('#<%=lblresid.ClientID%>').html(), date: $('#<%=txtredate.ClientID%>').val(), time: $('#<%=ddlretimeslot.ClientID%> option:selected').val(), deptid: $('#<%=ddlphe.ClientID%> option:selected').val(), deptname: $('#<%=ddlphe.ClientID%> option:selected').text(), remarks: $('#<%=txtreremarks.ClientID%>').val(), Centre: Centre, oldapptime: $oldapptime }, function (response) {
                 var $response = $.parseJSON(response);
                 if ($response.status) {
                     toast("Success", $response.response, "");
                     // window.location.reload();
                     getappdata();
                 }
                 else {
                     toast("Error", $response.response, "");
                 }
             });            
         }
         var $Encrypt = function (encryptText, callback) {
             if (encryptText != "") {
                 serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: encryptText.trim() }, function (response) {
                     callback(response);
                 });
             }
         }
         function openpopups(url, AppoinmentNo) {
             $Encrypt(AppoinmentNo, function (EAppoinmentNo) {                 
                 window.open(url + '?AppoinmentNo=' + EAppoinmentNo, null, 'left=50, top=20, height=680, width=1175,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
             });            

         }
         function scrolify(tblAsJQueryObject, height) {
             var oTbl = tblAsJQueryObject;

             // for very large tables you can remove the four lines below
             // and wrap the table with <div> in the mark-up and assign
             // height and overflow property  
             var oTblDiv = $("<div/>");
             oTblDiv.css('height', height);
             oTblDiv.css('overflow', 'scroll');
             oTblDiv.css('overflow-x', 'hidden');
             oTbl.wrap(oTblDiv);

             // save original width
             oTbl.attr("data-item-original-width", oTbl.width());
             oTbl.find('thead tr td').each(function () {
                 $(this).attr("data-item-original-width", $(this).width());
             });
             oTbl.find('tbody tr:eq(0) td').each(function () {
                 $(this).attr("data-item-original-width", $(this).width());
             });


             // clone the original table
             var newTbl = oTbl.clone();

             // remove table header from original table
             oTbl.find('thead tr').remove();
             // remove table body from new table
             newTbl.find('tbody tr').remove();

             oTbl.parent().parent().prepend(newTbl);
             newTbl.wrap("<div/>");

             // replace ORIGINAL COLUMN width                
             newTbl.width(newTbl.attr('data-item-original-width'));
             newTbl.find('thead tr td').each(function () {
                 $(this).width($(this).attr("data-item-original-width"));
             });
             oTbl.width(oTbl.attr('data-item-original-width'));
             oTbl.find('tbody tr:eq(0) td').each(function () {
                 $(this).width($(this).attr("data-item-original-width"));
             });
         }

         $(document).ready(function () {
               scrolify($('#mytable'), 425); // 425 is height         
         });


         //onmouseover="changecolor(this)" onmouseout="changecolor1(this)"
         var $bindRateType = function () {
             $('#divPaymentControl').hide();
             $('#testtable tr').remove();
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

         </script>   

      <Ajax:ScriptManager ID="sm1" runat="server" />
     <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../../App_Images/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
    <Ajax:UpdatePanel ID="up" runat="server" >
        <ContentTemplate>
            <script type="text/javascript" language="javascript">
                function pageLoad() {
                    showDeptName();
                   // fillColor();                    
                    mergeData();

                }
        </script>
     <div id="Pbody_box_inventory">
     <div class="POuter_Box_Inventory">
         <div class="row example1" id="divdisplay" runat="server" visible="false">
             <div class="col-md-24">
                         <h3><asp:Label id="lblflashmsg" runat="server" text="Hello---"></asp:Label> </h3>
                 </div>
                           </div>       
         <div class="row" style="text-align: center;">
               <div class="col-md-24">
                <b><span class="auto-style1">Radiology Appointment</span></b>
                   </div>
                </div>
         
    <div class="content">
        <div class="row" style="border:1px solid">
           
            <div class="col-md-4" style="color:maroon; text-align: right;"><b>Centre:</b></div>
              <div class="col-md-4"><asp:DropDownList id="ddlCentreAccess" class="chosen-select" runat="server"  onchange="CallSearch();" OnSelectedIndexChanged="ddlCentreAccess_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList></div>
             <div class="col-md-3" style="color:maroon; text-align: right;"><b>Date:</b></div>
             <div class="col-md-5">
                  <asp:TextBox ID="dtFrom" runat="server"  Width="100px"></asp:TextBox>                              
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" 
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" />
             </div>
            <div class="col-md-8">
             <asp:Button ID="btnsearch" runat="server" Text="Search Data" OnClick="btnsearch_Click" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />
 </div>
        </div>
      
        <table width="100%">
                        <tr>
                           
  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: White;"  onclick="PatientLabSearch('1')">  
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>

                            <td>
                                New Normal</td> 
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #E9967A;"  onclick="PatientLabSearch('2')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                New VIP</td>
                            
                                 <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"  onclick="PatientLabSearch('3')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Booked Normal</td>
                                  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#00FFFF;"  onclick="PatientLabSearch('4')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Booked VIP</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;" onclick="PatientLabSearch('5')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Appointment Cancel</td>
 <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;" onclick="PatientLabSearch('6')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              Confirm Normal</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: orange;" onclick="PatientLabSearch('7')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              Confirm VIP</td>

                        </tr>
                    </table>

                <%--style="word-wrap:break-word;white-space:normal"--%>
        <div id="calenderdiv" style="width:99%;">
            <table id="tblContainer">
                <tr>
                    <td>
            <%   int horizontal = Convert.ToInt32(StockReports.ExecuteScalar("SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='dept_horizontal'"));
                 if (horizontal != 1)
                 { %>
<% if (dt.Rows.Count > 0)
   {
        %>
            <table id="mytable"   frame="box" border="1" rules="all" style="background-color:white;border-color:darkred;width:99%;table-layout:fixed;">
                <tr id="header" style="background-color: #5258ff;color:white;font-weight:bold;height:30px;">
                    

                    <%  foreach (System.Data.DataColumn dwc in dt.Columns)
                        { %>
                    <td valign="top"
                        <% if (dwc.ColumnName == "PhlebotomistID" || dwc.ColumnName == "HolidayDate")
                           { %> 
                        style="display:none;"
                        <%}
                           else
                           {
                          %>
                        style="width:105px;word-wrap:break-word;white-space:normal"
                        <%} %>
                        ><%=dwc.ColumnName%></td>
                   
                    <%} %>
                </tr>
           
            <%
       foreach (System.Data.DataRow dw in dt.Rows)
       {

           string a = dw["PhlebotomistID"].ToString();
           if (dw["HolidayDate"].ToString() == dtFrom.Text)
           {
                    %>
               <tr id="<%=a.ToString()%>" style="height:40px; background-color:red;">
                    <%}
           else
           { %>
                <tr id="<%=dw["PhlebotomistID"].ToString()%>" style="height:40px;" class="remove">
                    <%} %>
                       <%  foreach (System.Data.DataColumn dwc in dt.Columns)
                           { %>
                    <td id="<%=dwc.ColumnName%>"
                        <% if (dwc.ColumnName == "PhlebotomistID" || dwc.ColumnName == "HolidayDate")
                           { %> 
                        style="display:none;"
                        <%}
                           if (dw["HolidayDate"].ToString() != dtFrom.Text)
                           {
                               if (dwc.ColumnName != "Department")
                               {%>
                       style="cursor:pointer;width:60px" onclick="openmypopup(this,'1','<%=dw["PhlebotomistID"].ToString()%>','<%=dwc.ColumnName%>','<%=dw["Department"].ToString()%>')" 
                        <%}
                               else
                               {
                          %>
                        style="font-weight:bold;width:60px"
                        <%}
                           }
                           else
                           {
                          %>
                        style="font-weight:bold;width:60px"
                        <%} %>
                        >
                         <% if (dwc.ColumnName == "PhlebotomistID" || dwc.ColumnName == "Department" || dwc.ColumnName == "HolidayDate")
                            {%>
                        <%=dw[dwc.ColumnName].ToString()%>

                        <%}

                            else if (dw[dwc.ColumnName].ToString() != "")
                            {%>
                        <table class="inner" frame="box" border="1" rules="all" id="<%=dw["PhlebotomistID"].ToString() + "_" + dwc.ColumnName%>">
                            
                              <%  foreach (string ss in dw[dwc.ColumnName].ToString().Split('~'))
                                  {
                           %>
                        <tr id="tr_<%=ss.Split('#')[0]%>" title="Add: <%=ss.Split('#')[3]%>  Mo: <%=ss.Split('#')[2]%>"
                            <%
                                      if (ss.Split('#')[4].ToString() == "1")
                                      {  
                             %>
                            style="background-color:pink"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "0" && ss.Split('#')[6].ToString() == "Normal")
                                      {
                               %>
                              style="background-color:white"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "0" && ss.Split('#')[6].ToString() == "VIP")
                                      {
                               %>
                              style="background-color:chocolate"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "1" && ss.Split('#')[6].ToString() == "Normal")
                                      {
                               %>
                              style="background-color:#90EE90"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "1" && ss.Split('#')[6].ToString() == "VIP")
                                      {
                               %>
                              style="background-color:#00FFFF"
                            <%}
                                      else if (ss.Split('#')[9].ToString() == "1" && ss.Split('#')[6].ToString() == "Normal")
                                      {
                               %>
                              style="background-color:Yellow"
                            <%}
                                      else if (ss.Split('#')[9].ToString() == "1" && ss.Split('#')[6].ToString() == "VIP")
                                      {
                               %>
                              style="background-color:Orange"
                            <%}
                              
                              
                                %>
                            >
                            <td><%=ss.Split('#')[1]%></td>
                          <%--  <td  ><%=ss.Split('#')[2] %></td>--%>
                           
                        </tr>
                        <%}%></table>
                          <%  } %>

                    </td>
                    
                    <%} %>
                </tr>
            <%} 
              
              %>

                   
                 </table>

            <%} %>

            <% }
                 else
                 {%>

            <% if (dtTest.Rows.Count > 0)
               {
                   
        %>
            <table id="mytable" frame="box" border="1" rules="all" style="background-color:white;border-color:darkred;width:99%;table-layout:fixed;"> 
                <thead>
                 <tr id="Tr1" style="background-color: #5258ff;color:white;font-weight:bold;height:30px;">
                    <%  foreach (System.Data.DataColumn dwc in dtTest.Columns)
                        {
                            // string deptid = dwc.ColumnName.Split('#')[1];
                             %>
                    <td valign="top"style="font-weight:bold;width:105px;word-wrap:break-word;white-space:normal"  ><%=dwc.ColumnName%></td>
                   
                    <%} %>
                     </tr>
                      </thead>
                        <% foreach (System.Data.DataRow dw in dtTest.Rows)
                           {
                               cR += 1; %>
                     <tr id="Tr_" style="height:40px;" >
                    <%  foreach (System.Data.DataColumn dwc in dtTest.Columns)
                        {

                            // string deptid = dwc.ColumnName.Split('#')[1];

                            //  string abc = dwc["Investigation"].ToString().Split('#')[1];<%=ss.Split('#')[3] 
                            // string appDetails =(dwc.ColumnName+"'&Timeslot='"+dw["Timeslot"]); 
                                                                          
                             %>
                                                                          
                    
                        <%-- <td id="Td_" valign="top"style="width:105px;word-wrap:break-word;white-space:normal;" onmouseover="showappdetail( '<%=dw[dwc.ColumnName].ToString()%>' );" onmouseout="hidedelta()" onclick="openmypopup(this,'2','<%=dwc.ColumnName%>','<%=dw["Timeslot"].ToString()%>','<%=dwc.ColumnName%>')"  > <%=dw[dwc.ColumnName].ToString()%></td>--%>
                         <%-- <td id="Td_" valign="top"style="width:105px;word-wrap:break-word;white-space:normal;" onmouseover="showappdetail('Appointment_Delta.aspx?width=97%&Appointment_detail=<%=dwc.ColumnName.Replace("#","_")%>&Times_lot=<%=dw["Timeslot"].ToString()%>&dt_SelctDate=<%=dt_from %>&dtCentrID=<%=dt_CentrID %>',this)" onmouseout="hidedelta()" onclick="openmypopup(this,'2','<%=dwc.ColumnName%>','<%=dw["Timeslot"].ToString()%>','<%=dwc.ColumnName%>')"  > <%=dw[dwc.ColumnName].ToString()%></td>--%>
                           <td id="Td_" valign="top"style="width:105px;word-wrap:break-word;white-space:normal;" onclick="openmypopup(this,'2','<%=dwc.ColumnName%>','<%=dw["Timeslot"].ToString()%>','<%=dwc.ColumnName%>')"  > <%=dw[dwc.ColumnName].ToString()%></td>
                                      
                  <% }
                %>
                    <% }
                      
                       %>    
                  
                </tr>
                
                 </table>
         
            
            

            <% }
                 } %>
           
           </td>
                </tr>
                  </table>
            
        </div>
           
      
    </div>
         </div>
         </div>

    </ContentTemplate>
    </Ajax:UpdatePanel>
      <%--openappointmentdiv Div--%>
   <div id="openappointmentdiv" class="modal fade">
    <div class="modal-dialog">
         <div class="modal-content" style="min-width: 100%;max-width:100%">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Book Slot</h4>
                              </div>

                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel"  onclick="$Closeappointmentdiv()"  aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
			</div>
            <div class="modal-body">                
                    <div class="POuter_Box_Inventory" style="text-align :center;height:500px;overflow:scroll">
            
                <div style="text-align: center;">
                    <div class="POuter_Box_Inventory" style="text-align: center;">
                        <div class="content" style="border:1px solid darkred;height:30px;">
                            <div class="row">
                            <div class="col-md-4 "> <b class="pull-right">Patient Type:</b></div>
                            <div class="col-md-6" style="text-align:left"><asp:DropDownList ID="ddlPatientType"  runat="server" onchange="$bindRateType()" TabIndex="1" >
				</asp:DropDownList></div>
                            <div class="col-md-4"><b class="pull-right">Rate Type:</b></div>
                            <div class="col-md-6" style="text-align:left"> <%--<select id="ddlPanel" style="width:100px"  data-title="Select Rate Type" onchange="GetinvlistPanel()"></select>--%>
                                 <asp:DropDownList ID="ddlPanel" runat="server" TabIndex="10" onchange="GetinvlistPanel()" ></asp:DropDownList>
                            </div>
                            <div class="col-md-4" style="font-weight:bold;font-size:16px;"> Book Slot <asp:Label ID="lbidforedit" runat="server" style="display:none;" />
    <asp:TextBox ID="hdn_RandomNo" runat="server" Style="display: none;"></asp:TextBox>                                

                        </div>
                            </div>
                        <div class="row" style="text-align:center"><div class="col-md-24"> <asp:Label ID="lbmsg" runat="server" Font-Bold="true" ForeColor="Red" /></div> </div>
                        <div class="row"><div class="col-md-4"><b class="pull-right"> Department Name:</b></div>
                            <div class="col-md-6" style="text-align:left"><asp:Label  ID="lblphilboname" runat="server"  Font-Bold="true" />
                                 <asp:Label ID="lblphilboid" runat="server" Font-Bold="true" style="display:none;"  />
                            </div>
                            <div class="col-md-4"><b class="pull-right"> Time Slot:</b></div>
                            <div class="col-md-6" style="text-align:left"><asp:Label ID="lbltimeslot" runat="server"  Font-Bold="true" />
                            <asp:DropDownList ID="ddltimeslot"  runat="server" Width="100px"> </asp:DropDownList></div>
                           <div class="col-md-4" style="text-align:right">          
                                <input type="radio" name="PatientType" value="VIP" /><b>VIP</b>
                                <input type="radio" name="PatientType" value="Normal" checked="checked" /><b>Normal</b>
                                </div>
                        </div>
                          <div class="row">
                              <div class="col-md-4"><b class="pull-right"> Mobile No:</b></div>
                              <div class="col-md-6" style="text-align:left"> <asp:TextBox ID="txtMobile"  runat="server" TabIndex="1"  CssClass="requiredField"  Width="150px" MaxLength="10"
                             onkeyup="showlength()"   ></asp:TextBox>&nbsp;&nbsp;<span id="molen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                            </cc1:FilteredTextBoxExtender>
                                  <input type="text" id="txtUHIDNo" style="display:none"  autocomplete="off" patientAdvanceAmount="0"     maxlength="15"  data-title="Enter UHID No." onkeyup="$patientSearchOnEnter(event);"/>
                              </div>
                               <div class="col-md-4"><b class="pull-right"> Age/Gender:</b></div>
                              <div class="col-md-10" style="text-align:left">  <asp:DropDownList ID="ddlGender" runat="server" CssClass="requiredField"  Width="70px" TabIndex="2">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                            </asp:DropDownList>
                                   <asp:TextBox  ID="txtAge" runat="server"  CssClass="ItDoseTextinputText"  Width="55px" MaxLength="3" TabIndex="3"  placeholder="Years"   /><%--Year--%>
                             <asp:TextBox  ID="txtAge1" runat="server"  CssClass="ItDoseTextinputText"  Width="55px" MaxLength="2" TabIndex="3"  placeholder="Months"    /><%--Month--%>
                             <asp:TextBox  ID="txtAge2" runat="server"  CssClass="ItDoseTextinputText"  Width="55px" MaxLength="2" TabIndex="3" placeholder="Days"   /><%--Days--%>

                              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Numbers" TargetControlID="txtAge" >
                            </cc1:FilteredTextBoxExtender>
                              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Numbers" TargetControlID="txtAge1" >
                            </cc1:FilteredTextBoxExtender>
                              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Numbers" TargetControlID="txtAge2" >
                            </cc1:FilteredTextBoxExtender>
                              </div>
                              </div>
                        <div class="row">
                              <div class="col-md-4"><b class="pull-right"> Patient Name:</b></div>
                            <div class="col-md-6" style="text-align:left"><asp:DropDownList ID="cmbTitle" runat="server" TabIndex="4" CssClass="requiredField" Width="70px" onChange="return AutoGender();">
                            </asp:DropDownList><asp:TextBox ID="txtpname" onkeyup="up(this)" MaxLength="100" runat="server" CssClass="requiredField" Width="200px" TabIndex="1" /></div>
                             <div class="col-md-4"><b class="pull-right"> Email ID:</b></div>
                            <div class="col-md-10" style="text-align:left"> <asp:TextBox TabIndex="5" ID="txtemail"  runat="server" MaxLength="70"  Width="200px" onkeypress="this.value = this.value.toLowerCase();" ></asp:TextBox></div>
                            </div>
                         <div class="row">
                              <div class="col-md-4"><b class="pull-right"> House No:</b></div>
                              <div class="col-md-6" style="text-align:left"> <asp:TextBox ID="txtaddress" runat="server" MaxLength="10" CssClass="requiredField" onkeyup="up(this)" TabIndex="6" Width="230px"></asp:TextBox></div>
                              <div class="col-md-4"><b class="pull-right"> Locality:</b></div>
                              <div class="col-md-6" style="text-align:left"> <asp:TextBox ID="txtaddress1" runat="server" MaxLength="50" onkeyup="up(this)" TabIndex="7" Width="230px"></asp:TextBox></div>
                             <div class="col-md-4" style="text-align:right">Pin Code:<asp:TextBox ID="txtpinno" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText"     Width="100px" MaxLength="6"
                              ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtpinno" >
                            </cc1:FilteredTextBoxExtender></div>
                         </div>
                         <div class="row">
                              <div class="col-md-4"><b class="pull-right">LandMark:</b></div>
                             <div class="col-md-6" style="text-align:left"> <asp:TextBox ID="txtaddress2" runat="server" MaxLength="100" onkeyup="up(this)" TabIndex="8" Width="230px"></asp:TextBox></div>
                             <div class="col-md-4"><b class="pull-right">Remark:</b></div>
                             <div class="col-md-10" style="text-align:left"><asp:TextBox TabIndex="5" ID="txtremark" runat="server" MaxLength="150"  Width="230px"  ></asp:TextBox>                                
                             </div>
                             </div>
                        <div class="row">
                              <div class="col-md-4"><b class="pull-right">Ref Doctor:</b></div>
                            <div class="col-md-6" style="text-align:left"> 
                                 <input  type="text"   id="txtReferDoctor" value="SELF" ClientIDMode="Static"  data-title="Select Referred Doctor" maxlength="50" class="requiredField"/>
                <input type="hidden" id="hftxtReferDoctor" value="1" />	
                              </div>
                            <div class="col-md-4"><b class="pull-right"></b></div>
                             <div class="col-md-10" style="text-align:left"> 
                                 <asp:Label ID="lblbookingnum" runat="server"  Font-Bold="true" style="display:none;" />
                                 <asp:DropDownList id="ddlCentreAccess1" runat="server" style="display:none;"></asp:DropDownList>
                                 <asp:TextBox ID="txtedit" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText" Text="0" style="display:none;"></asp:TextBox>
                                 <asp:TextBox ID="txtbooked" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText" Text="0" style="display:none;" ></asp:TextBox>
                             </div>
                        </div>
                        <div class="row">                          
						<div style="padding-right: 0px;" class="col-md-6">
							<label class="pull-left">                               
								<input id="rdbItem_1" type="radio" name="labItems" value="1" onclick="$clearItem(function () { })" checked="checked"  />
								<label for="rdbItem_1">By Name</label>
								<input id="rdbItem_0" type="radio" name="labItems" value="0" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_0">By Code </label>
								<input id="rdbItem_2" type="radio" name="labItems" value="2" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_2">InBetween</label>								
							</label>
						</div>	
                             <div class="col-md-4">                           
						</div>	                            
                            </div>
                             <div class="row">       
                       				     <div style="padding-left: 15px;" class="col-md-6">
							<input type="text" id="txtInvestigationSearch" title="Enter Search Text"  autocomplete="off" />
						</div>	                        												
					
                             <div class="col-md-6" style="text-align:left">                                                                                                     
                                 <b> TotalAmt::</b>&nbsp;   <span id="lblamt" style="font-weight:bold;" ></span></div>
                                  <div class="col-md-12">
                                    <div id="Div1" style="height:70px;overflow:scroll;">
                                     <table id="testtable" frame="box" border="1" rules="all" width="70%" style="background-color:#c8fa87;">                                       
                                     </table></div>
                             </div>	
                            </div>                      
                         <div class="POuter_Box_Inventory" id="divPaymentControl" runat="server">
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
                         <div class="row" style="text-align:center">
                              <div class="col-md-8"> <input tabindex="11" type="button" id="btnAttach"  style="font-weight:bold;padding:5px;border-radius:10px;background-color:blue;color:white;cursor:pointer;" value="Attach File" onclick="wopen();"  /> </div>
                              <div class="col-md-8"><input tabindex="12" type="button" id="btnsaveslot" class="searchbutton"  style="font-weight:bold;padding:5px;border-radius:10px;background-color:blue;color:white;cursor:pointer;" value="Save Data" onclick="savealldata()"  />  </div>
                              <div class="col-md-8"><input tabindex="12" type="button" id="Button3"  style="font-weight:bold;padding:5px;border-radius:10px;background-color:blue;color:white;cursor:pointer;" value="Close" onclick="$Closeappointmentdiv()"  />  </div>
                             </div>
                         <div class="row">
                             <div class="col-md-24"> <div id="PatientLabSearchOutput" style="width:100%;max-height:150px;overflow:auto;border:1px solid darkred;"></div></div>
                             </div>                                             
                    </div>
                    </div>
           
        </div>                           
        </div>
   </div>
       </div>
 </div>
  </div>

    <asp:Button ID="Button1" runat="server" style="display:none;" />

   <asp:Panel ID="pnlcanceldiv" runat="server" BackColor="#f9c6f0"  style="display:none; border:2px solid darkred;height:120px;" >
       <table>
           <tr>
               <td colspan="2" align="center" style="font-size:16px;" >
                   <b>Cancel</b>
                <br />
                   </td>
               </tr>
           <tr>
               <td><b> Cancel Reason::</b></td>
               <td><asp:TextBox ID="txtcancelreason" runat="server" Width="300px" onkeyup="up(this)" />
                   <asp:Label ID="lbcencelid" runat="server" style="display:none;" />
               </td>
               </tr>
            <tr> <td style="text-align:left"><asp:TextBox ID="txtbooked1" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText" Text="0" style="display:none;" ></asp:TextBox></td>
                            </tr>
                 <tr>
               <td colspan="2" align="center">
                   <input type="button" id="btncancel"  onclick="cencelme()" style="font-weight:bold;padding:5px;border-radius:10px;background-color:green;color:white;cursor:pointer;width:65px;" value="Save" />
                   &nbsp;&nbsp;
                    <asp:Button ID="btncloseurgent1" runat="server" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer;" Text="Close"  Width="65px" />
               </td>
           </tr>
       </table>
   </asp:Panel>

      <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btncloseurgent1" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlcanceldiv">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlres" runat="server" BackColor="#c6dff9"  style="display:none; border:2px solid darkred;height:250px;" >
       <table>
           <tr>
               <td colspan="4" align="center" style="font-size:16px;"  >
                   <b>Reschedule</b>
                <br />
                    <br />
                    <br />
                   </td>
               </tr>
           <tr>
               <td><b>Current Department::</b></td>
               <td><asp:Label  ID="lblcrph" runat="server"  Font-Bold="true" />
                   <asp:Label ID="lblresid" runat="server" style="display:none;" />
               </td>
               <td><b>Current TimeSlot::</b></td>
               <td><asp:Label  ID="lblcutme" runat="server" Font-Bold="true"  /></td>
               </tr>
           <tr> <td><asp:TextBox ID="txtre" runat="server" Width="80px" Text="0" style="display:none;"/> </tr>
              <tr>
               <td><b>Select Date::</b></td>
                   <td><asp:TextBox ID="txtredate" runat="server" Width="80px" />                        
                                <cc1:CalendarExtender runat="server" ID="CalendarExtender1" OnClientDateSelectionChanged="checkDate1"
                                        TargetControlID="txtredate"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="txtredate" />
                   </td>
                   <td><b>Select Time::</b></td>
                   <td>

                       <asp:DropDownList ID="ddlretimeslot" runat="server" />
                   </td>
                  </tr>

            <tr>
               <td><b>Select Department::</b></td> 
                <td colspan="3">
                    <asp:DropDownList ID="ddlphe" runat="server" Width="250px"></asp:DropDownList>
                </td>
                </tr>
           <tr>
               <td><b>Remarks::</b></td> 
                <td colspan="3">
                    <asp:TextBox ID="txtreremarks" runat="server" Width="300px" MaxLength="150" onkeyup="up(this)" ></asp:TextBox>
                </td>
                </tr>


                 <tr>
               <td colspan="4" align="center">
                   <input type="button" id="Button2"  onclick="Rescheduleme()" style="font-weight:bold;padding:5px;border-radius:10px;background-color:green;color:white;cursor:pointer;width:85px;" value="Reschedule" />
                   &nbsp;&nbsp;
                    <asp:Button ID="btncloseurgent2" runat="server" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer;" Text="Close"  Width="85px" />
               </td>
           </tr>
       </table>
   </asp:Panel>

      <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btncloseurgent2" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlres">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnloldpatient" runat="server" BackColor="#ffffcc" BorderStyle="None" style="display:none" >
          <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="color:#f00">
                    Old Patient Detail
                    </div>
               <div class="Outer_Box_Inventory" style="min-height:80px;max-height:300px;overflow:scroll;">
              <table id="tboldpatient" style="width:100%;color:blue">

              </table>
                   </div>
               <div style="text-align:center;">
                  <asp:Button ID="btncloseoldpatient" runat="server" Text="Close" />
             </div>
              </div>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModelPopupExtender3" runat="server" CancelControlID="btncloseoldpatient" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnloldpatient">
    </cc1:ModalPopupExtender>

    <script id="tb_PatientLabSearch" type="text/html">
    
   <asp:HiddenField ID="hdnstatus" runat="server" />
    <div class="scrollit">       
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tb_grdLabSearch" width="100%" style="table-layout:fixed;border:1px solid darkred;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;word-wrap:break-word;white-space:normal" >AppDateTime</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;word-wrap:break-word;white-space:normal">AppID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;word-wrap:break-word;white-space:normal">PName</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:70px;word-wrap:break-word;white-space:normal">Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;word-wrap:break-word;white-space:normal">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;word-wrap:break-word;white-space:normal">EmailID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;word-wrap:break-word;white-space:normal">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;word-wrap:break-word;white-space:normal" >Test</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">NetAmt</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">PaidAmt</th>
            <th class="GridViewHeaderStyle" scope="col" width="30px" >Edit</th>
             <th class="GridViewHeaderStyle" scope="col" width="30px" title="Reshedule" >RS</th>
            <th class="GridViewHeaderStyle" scope="col" width="30px">Print</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Cancel</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Regi stration</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Reg_By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Reg_DateTime</th>
            
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">App Confirm</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">View File</th>
         </tr>

          

       <#
              var dataLength=PatientData.length;
            
              var objRow;  
           
        for(var j=0;j<dataLength;j++)
        {



        objRow = PatientData[j];
             
            #>
<tr style="background-color:<#=objRow.RowColor#>;height:30px;" id="<#=objRow.test_id#>">


<td class="GridViewLabItemStyle"><#=j+1#><# if(objRow.isedited=='1'){ #>&nbsp;&nbsp;<img src='../../App_Images/folder.gif'  style='border:none;' title="Update By:: <#=objRow.UpdateByName#> on:: <#=objRow.uupdate#>"/> <#}#></td>
<td class="GridViewLabItemStyle" style="width:70px;word-wrap:break-word;white-space:normal"><#=objRow.appdate#>&nbsp;<#=objRow.apptime#></td>
    <td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;white-space:normal"><#=objRow.id#></td>
<td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;white-space:normal"><#=objRow.PatientName#></td>
<td class="GridViewLabItemStyle" style="width:70px;word-wrap:break-word;white-space:normal"><#=objRow.pinfo#></td>
<td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;white-space:normal"><#=objRow.Mobile#></td>
<td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;white-space:normal"><#=objRow.EmailID#></td>
<td class="GridViewLabItemStyle" style="width:150px;word-wrap:break-word;white-space:normal"><#=objRow.Address#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal;width:80px"><#=objRow.Investigation#></td>
<td class="GridViewLabItemStyle" style="width:50px;"><#=objRow.TotalAmt#></td>
    <td class="GridViewLabItemStyle" style="width:50px;"><#=objRow.Paidamt#></td>
    <td class="GridViewLabItemStyle">
        <# if(objRow.Iscancel=='0' && objRow.IsBooked=='0')
        { #>
 <img src='../../App_Images/edit.png'  style='border:none;cursor:pointer;' onclick="editme('<#=objRow.id#>')"/>
<#}#>
</td>
    <td class="GridViewLabItemStyle" width="30px" align="center">
        <# if(objRow.Iscancel=='0' && objRow.IsBooked=='0')
        { #>
 <img src='../../App_Images/reload.jpg'  style='border:none;cursor:pointer;' onclick="openshepopup('<#=objRow.id#>','<#=objRow.IsBooked#>')"/>
<#}#>
</td>
    <td class="GridViewLabItemStyle" width="40px" align="center">
        <%--<a href='HomecollectionslotwiseReceipt.aspx?ID=<#=objRow.id#>'>Print</a>--%>
        <img src="../../App_Images/folder.gif" style="border-style: none;cursor:pointer;" onclick="receiptreprint('<#=objRow.id#>')"/>
    </td>
<td class="GridViewLabItemStyle" width="50px" align="center" >
     <# if(objRow.Iscancel=='0' && objRow.IsBooked=='0')
        { #>
 <img src='../../App_Images/Delete.gif'  style='border:none;cursor:pointer;' onclick="opencncelpoup('<#=objRow.id#>','<#=objRow.IsBooked#>')"/>   
    <#}#>
</td>
   <td class="GridViewLabItemStyle" style="width:50px;">
        <# if(objRow.Iscancel=='0' && objRow.IsConfirmed=='1' && objRow.IsBooked=='0')
        { #>
 <img src='../../App_Images/edit.png'  style='border:none;cursor:pointer;' onclick="openpopups('../Lab/Lab_PrescriptionOPD.aspx','<#=objRow.id#>')"/>
       <#}#>
</td>
    <td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;white-space:normal"><#=objRow.EntryByName#></td>
    <td class="GridViewLabItemStyle" style="width:120px;word-wrap:break-word;white-space:normal"><#=objRow.Reg_DateTime#></td>
       <td class="GridViewLabItemStyle" style="width:80px;word-wrap:break-word;white-space:normal">
            <# if(objRow.IsConfirmed=='0' && objRow.Iscancel=='0')
        { #>
              <input type="button" id="btnconfirm" value="Confirm" onclick="ConfirmAppointment('<#=objRow.id#>')"  />
            <#}#>
       </td>
    <td class="GridViewLabItemStyle" style="text-align: center;">
    <# if(objRow.filecount != '0')
                        {#> 
    <img src="../../App_Images/view.GIF" onclick="window.open('ShowAttachment.aspx?AppID=<#=objRow.id#>',null,' status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');" />
                        <#}#>
    
    </td>
</tr>
         
            

            <#}#>

</table>
           
       </div>    
    </script>
   <%-- /**05-08-2017**/--%>
    <div id="deltadiv" style="display: none; position: absolute; background-color:darkgrey; border-width:5px; border-color:red; text-align:center; color:white;width:10%;height:5%">
        </div>
   <%-- /**05-08-2017**/--%>

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
                    $("#txtAmountGiven").attr('disabled', 'disabled');
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
                patientAdvanceAmount: Number($('#txtUHIDNo').attr('patientAdvanceAmount')),
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

        jQuery("#txtemail").on("blur", function () {
            debugger;
            if (jQuery('#txtemail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtemail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtemail').focus();
                    return false;
                }
            }
        });


        $('#txtpname').alphanum({
            allow: '/-.,',
            disallow: '0123456789'
        });


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
            $temp.push(IsShowDetail.data('ischequenoshow') == 0 ? '' : '<input type="text" autocomplete="off" maxlength="20" class="requiredField" id="txtCardNo" />');
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
                $("#txtAmountGiven").attr('disabled', 'disabled');
            }
        }
        var $onChangeCurrency = function (elem, calculateConversionFactor, callback) {
            var _temp = [];
            if ((Number($('#ddlCurrency').val()) == Number('<%=Resources.Resource.BaseCurrencyID%>')) && (parseFloat($('#txtUHIDNo').attr('patientAdvanceAmount')) > 0)) {
                $('input[type=checkbox][name=paymentMode][value=9]').attr('disabled', false);
            }
            else {
                $('input[type=checkbox][name=paymentMode][value=9]').prop('checked', false).attr('disabled', 'disabled');
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
                         $objRC.CentreID =$('#<%=ddlCentreAccess.ClientID%> option:selected').val();
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
    <%--Start of test search--%>
     <script type="text/javascript">
         var $InvList = [];
         var $previousInvSearch;
         $(function () {
             jQuery("#txtInvestigationSearch").bind("keydown", function (event) {
                 if ($previousInvSearch != null)
                     $previousInvSearch.abort();
                 if (event.keyCode === jQuery.ui.keyCode.TAB &&
                 jQuery(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 if ($("#<%=ddlGender.ClientID%> option:selected").text() == "") {
                     toast("Error", "Please Select Gender", "");
                     jQuery("#ddlGender").focus();
                     return;
                 }
             })
           .autocomplete({
               autoFocus: true,
               source: function (request, response) {
                   $previousInvSearch = jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=GetTestList",
                          {
                              ReferenceCodeOPD: $("#<%=ddlPanel.ClientID%>").val().split('#')[1],
                              SearchType: jQuery('input:radio[name=labItems]:checked').val(),
                              Gender: $('#<%=ddlGender.ClientID %> option:selected').text(),
                              Panel_Id: $("#<%=ddlPanel.ClientID%>").val().split('#')[0],
                              PanelType: $("#<%=ddlPanel.ClientID%>").val().split('#')[5],
                              PanelID_MRP: $("#<%=ddlPanel.ClientID%>").val().split('#')[18],
                              SubcategoryID:  $('#<%=lblphilboid.ClientID%>').html(),
                              TestName: extractLast(request.term)
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
                   this.value = "";
                   CreateDynamicTable(ui.item.Rate, ui.item.value, ui.item.label)
                   return false;
               }
           });
         });


        



         function split(val) {
             return val.split(/,\s*/);
         }
         function extractLast(term) {
             return split(term).pop();
         }


         jQuery("#txtAge").on("blur", function () {
             debugger;
             if (jQuery('#txtAge').val() > 120) {      
                     toast("Error", 'Age Not More Than 120 Years!!', '');
                     jQuery('#txtAge').focus();
                     return false;
                 }
             
         });


         jQuery("#txtAge1").on("blur", function () {
             debugger;
             if (jQuery('#txtAge1').val() > 12) {
                 toast("Error", 'Age Month Not More Than 12!!', '');
                 jQuery('#txtAge1').focus();
                 return false;
             }

         });


         jQuery("#txtAge2").on("blur", function () {
             debugger;
             if (jQuery('#txtAge2').val() > 31) {
                 toast("Error", 'Age Days Not More Than 31 Years!!', '');
                 jQuery('#txtAge2').focus();
                 return false;
             }

         });



        
         function CreateDynamicTable(Rate, ItemID,ItemName) {
             debugger;
             var IsValid = true;
             $("#testtable tr").each(function () {
                 if (ItemID == $(this).closest('tr').find("#hdnId").val()) {
                     IsValid = false;
                 }
             });

             if (!IsValid) {
                 toast("Error", "Item Already selected");
                 return false;
             }

             var output = [];
             var a1 = $('#testtable tr').length;
             output.push('<tr>');
             output.push('<td align="centre">'); output.push(parseFloat(a1 + 1)); output.push('</td>');
             output.push('<td id="tdDept"  class="GridViewLabItemStyle"  style="width:100px;">');
             output.push('<input type="hidden" id="hdnId" value="');
             output.push(ItemID);
             output.push('"/>');
             output.push(ItemName.split('#')[1]); output.push('</td>');
             output.push('<td class="GridViewLabItemStyle" id="tdItemName">');
             output.push(ItemName.split('#')[0]); output.push('</td>');
             output.push('<td  class="GridViewLabItemStyle" id="tdRate">');
             output.push(Rate.split('#')[0]); output.push('</td>');

             output.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletemyrol(this)"/></td>');
            output.push('</tr>');
            output = output.join('');
            $("#testtable").append(output);
            getamount();
            var rowpos = $('#testtable tr:last').position();
            $('#scdiv').scrollTop(rowpos.top);
         }
         var lblamttotal = 0;
         function getamount() {
             debugger;
             var amt = 0;
             $("#testtable tr").each(function () {                
                 amt = amt + parseFloat($(this).closest('tr').find("#tdRate").html());
             });
             lblamttotal = parseFloat(amt);
             $('#lblamt').html(lblamttotal);
             $('#txtGrossAmount').val(amt);
             $('#txtNetAmount').val(amt);
         }
         var $clearItem = function () {
             jQuery('#txtInvestigationSearch').val('');
             jQuery("#txtInvestigationSearch").attr('autocomplete', 'off');
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
                               docname: extractLast(request.term), centreid: $('#<%=ddlCentreAccess.ClientID%> option:selected').val()
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
         function split(val) {
             return val.split(/,\s*/);
         }
         function extractLast(term) {
             return split(term).pop();
         }
         </script>
    <%--End of test search--%>
</asp:Content>

