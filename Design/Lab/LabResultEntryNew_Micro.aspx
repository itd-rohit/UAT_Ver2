 <%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabResultEntryNew_Micro.aspx.cs" Inherits="Design_Lab_LabResultEntryNew_Micro" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">


     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
    <style type="text/css">
        /* The Modal (background) */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        /* Modal Content/Box */
        .modal-content {
            background-color: #fefefe;
            margin: 20% auto; /* 15% from the top and centered */
            margin-left: 40%;
            padding: 20px;
            border: 1px solid #888;
            width: 25%; /* Could be more or less, depending on screen size */
        }
    </style>
    </head>
   <body>
       
       <form  id="formMicro" runat="server">

           <script type="text/jscript" language="jscript">
               var LabNo = '<%=LabNo %>';
               var Test_ID = '<%=TestID %>';
               var Investigation_Id = '<%=Investigation_Id %>';

               $(document).ready(function () {
                   if ('<%=IsHold%>' == "1") {
                       $('.btnhold').hide();
                       $('.btnunhold').show();
                       $('.btnPrint').hide();

                   }
                   else {
                       $('.btnhold').show();
                       $('.btnunhold').hide();
                       $('.btnPrint').show();
                   }
                   if ('<%=isApproval%>' == "0")
                       $('#Sample_type').hide();


                   var tofind = $('#<%=lbstatus.ClientID%>').html();
                   var aa = document.getElementById('repstatus');
                   for (var i = 0; i < aa.options.length; i++) {
                       if (aa.options[i].text === tofind) {
                           aa.selectedIndex = i;
                           break;
                       }
                   }

                   BindSampleType();
                   BindInvestigationobsearvation();
                   $('#tb_MicroMIC tr').not(':first').each(function () {
                       if ($(this).find('#txtValueenzyme_' + $(this).attr('id')).val() == "Detected") {
                           checkvalue($(this).find('#txtValueenzyme_' + $(this).attr('id')));
                       }
                   });


                   var config = {
                       '.chosen-select': {},
                       '.chosen-select-deselect': { allow_single_deselect: true },
                       '.chosen-select-no-single': { disable_search_threshold: 10 },
                       '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                       '.chosen-select-width': { width: "95%" }
                   }
                   for (var selector in config) {
                       $('#ddlOrganism').chosen(config[selector]);
                       $('#ddlComments').chosen(config[selector]);
                       $('#tbanti tr').not(':first').each(function () {
                           $(this).find('#ddlValue').chosen(config[selector]);
                       });
                       $('#tb_MicroMIC tr').not(':first').each(function () {
                           $(this).find('#ddlEnzyme').chosen(config[selector]);
                       });
                   }
               });
               $("#tb_MicroMIC").find("#imgHelp").live("click", function () {

                   if ($(this).closest("tr").find("#IsCommentField").text() == "1") {
                       _executeComment($($(this)).closest("tr").find("#imgComments"));
                   }
                   else {
                       //  txtvaluelogic(e, $($(this)).closest("tr").find("#txtValue"), 'keydown');
                   }
               });
               $(function () {
                   // LoadInvName();
                   $(document).ready(function () {
                       $(".DivInvName").click(function () {
                           if (showinv == '1') {
                               $('#div_Investigations').slideToggle('fast');
                           }
                           else {
                               $.blockUI();
                               LoadInv();
                           }
                       });
                   });
               });
               var mouseX;
               var mouseY;
               $(document).mousemove(function (e) {
                   mouseX = e.pageX;
                   mouseY = e.pageY;
               });
               function getme(testid) {
                   // alert('ok');
                   var url = "../../Design/Lab/showreading.aspx?TestID=" + testid;
                   $('#deltadiv').load(url);
                   $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
               }
               function hideme() {
                   $('#deltadiv').hide();
               }

               function BindMICOrganismAnti(barcodeno) {
                   serverCall('LabResultEntryNew_Micro.aspx/BindMICOrganismAnti', { Barcodeno: barcodeno }, function (response) {
                       var OrgMan = JSON.parse(response);
                       if (OrgMan.length == 0)
                           return;
                   $('#ddlOrganism').val(OrgMan[0].id).trigger('chosen:updated');
                   showobsandenzimelist($('#ddlOrganism'));
                   showantibiotics(OrgMan[0].id, OrgMan[0].name,barcodeno);
                   });
               }
               function LoadInvName() {
                   $("#dragHandle").hide();
                   serverCall('Services/ResultEntry.asmx/GetPatientInvsetigationsNameOnly', {}, function (response) {
                       InvData = JSON.parse(response);
                       $('.DivInvName').html(InvData);
                       $('.DivInvName').show();
                   });
               }

               function BindInvestigationobsearvation() {
                   serverCall('LabResultEntryNew_Micro.aspx/BindInvestigationobsearvation', { Test_ID: Test_ID , Investigation_Id:  Investigation_Id , LabNo:  LabNo  }, function (response) {
                       ObsTable = JSON.parse(response);
                       $('#sampledate').html(ObsTable[0].sampledate);
                       $('#sampleCollectionDate').html(ObsTable[0].sampleCollectionDate);
                       $('#ddlMethod').val(ObsTable[0].Method == '' ? 'Automated by BD Phoenix' : ObsTable[0].Method)
                       var ObsOutput = $('#DynamicTable_Micro_Mic').parseTemplate(ObsTable);
                       $('#div_Tests').html(ObsOutput);
                       BindMICOrganismAnti(ObsTable[0].Barcodeno);
                       if (ObsTable[0].organism != "0") {

                           for (var i = 0; i < ObsTable[0].organism.split(',').length; i++) {
                               var chunk = ObsTable[0].organism.split(',')[i];

                               if (chunk != "") {
                                   $('#ddlOrganism').val(chunk);
                                   var name = $('#ddlOrganism option:selected').text();
                               }
                           }
                       }
                   });
               }

               function showobsFORMIC(id, orname) {
                   serverCall('LabResultEntryNew_Micro.aspx/Bindobsgroupenzyme', { obid:  id , obname:  orname , testid:  Test_ID  }, function (response) {
                       Obsrow = JSON.parse(response);
                       var ObsrowOutput = $('#Add_MoreObservation').parseTemplate(Obsrow);
                       $('#div_Tests').html(ObsrowOutput);
                   });
               }

               function showobsandenzimelist(ctr) {
                   if ($('#ddlOrganism option:selected').val() != "0") {

                       if ($('.' + $('#ddlOrganism option:selected').val()).length > 0) {
                           alert('Already Added !!');
                           $("#ddlOrganism").attr('selectedIndex', '0');
                           return;
                       }
                       serverCall('LabResultEntryNew_Micro.aspx/Bindobsgroupenzyme', { obid: $('#ddlOrganism option:selected').val(), obname: $('#ddlOrganism option:selected').html(), testid: Test_ID }, function (response) {
                           Obsrow = JSON.parse(response);
                           var ObsrowOutput = $('#Add_MoreObservation').parseTemplate(Obsrow);
                           $(ctr).parent("td").parent("tr").before(ObsrowOutput);
                           var config = {
                               '.chosen-select': {},
                               '.chosen-select-deselect': { allow_single_deselect: true },
                               '.chosen-select-no-single': { disable_search_threshold: 10 },
                               '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                               '.chosen-select-width': { width: "95%" }
                           }
                           for (var selector in config) {
                               $('#tb_MicroMIC tr').not(':first').each(function () {
                                   $(this).find('#ddlEnzyme').chosen(config[selector]);
                               });
                           }
                       });
                   }
               }

               function tablelength() {
                   var a = $('#tb_MicroMIC tr').length;
                   return a;
               }

               function showantibiotics(obid, obname,barcodeno) {
                   if ($('#tbanti').find('.' + obid).length > 0) {
                       return;
                   }

                   serverCall('LabResultEntryNew_Micro.aspx/Bindantibiotics', { obid: obid, obname: obname, testid: Test_ID, Barcodeno: '<%=Request.QueryString["barcodeno"]%>' }, function (response) {
                       AntiTable = JSON.parse(response);
                       var ObsOutput = $('#DynamicTable_Aticbiotic').parseTemplate(AntiTable);
                       $('#tbanti').append(ObsOutput);
                       $("#div_anti").show();
                       $('#tbanti tr').not(':first').each(function () {
                           if ($(this).find('#txtinter_' + $(this).attr('id')).val() != undefined) {
                               var dataToSelect = $(this).find('#txtinter_' + $(this).attr('id')).val();
                               $(this).find("#ddlValue").val(dataToSelect.toLowerCase());
                           }
                       });
                       var config = {
                           '.chosen-select': {},
                           '.chosen-select-deselect': { allow_single_deselect: true },
                           '.chosen-select-no-single': { disable_search_threshold: 10 },
                           '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                           '.chosen-select-width': { width: "95%" }
                       }
                       for (var selector in config) {
                           $('#tbanti tr').not(':first').each(function () {
                               $(this).find('#ddlValue').chosen(config[selector]);
                           });

                       }
                   });
               }

               function removeobs(obid) {
                   $('.' + obid).remove();
                   //$("#obsname").html('');
                   $('#tbanti').find('.' + obid).remove();
                   //$("#div_anti").hide();

                   if ($('#tbanti tr').length == 1) {
                       $("#div_anti").hide();
                   }
               }

               // Help Menu Display and Hide
               var mouseX;
               var mouseY;
               $(document).mousemove(function (e) {
                   mouseX = e.pageX;
                   mouseY = e.pageY;
               });
               // Add Help Value To textBox
               function addtotext(obj) {

                   var id = $(obj).attr("id");

                   $("#txtinter_" + id.split('_')[1]).val($(obj).val());

                   $('.helpselect').hide();
                   $('.helpselect').removeAttr("id");
               }

               function addenzyme(obj) {

                   var id = $(obj).attr("id");

                   $("#txtValueenzyme_" + id.split('_')[1]).val($(obj).val());

                   if ($("#txtValueenzyme_" + id.split('_')[1]).val() == "Detected") {
                       $("#txtValueenzyme_" + id.split('_')[1]).css({ 'color': 'white', 'background-color': 'red' });
                       getanibioticsagainsenzyme($("#txtValueenzyme_" + id.split('_')[1]));

                   }
                   else {
                       $("#txtValueenzyme_" + id.split('_')[1]).css({ 'color': '', 'background-color': '' });

                       $('#tbanti').find("input[type=text]").attr('disabled', false);
                   }
                   $('.helpenzyme').hide();
                   $('.helpenzyme').removeAttr("id");
               }


               function checkvalue(ctr) {

                   if ($(ctr).val() == "Detected") {
                       $(ctr).css({ 'color': 'white', 'background-color': 'red' });
                       getanibioticsagainsenzyme(ctr);
                   }
                   else {
                       $(ctr).css({ 'color': '', 'background-color': '' });
                       var enzymeid = $(ctr).closest("tr").attr('id');


                       $('#tbanti').find("input[type=text]").attr('disabled', false);
                       getanibioticsagainsenzyme(ctr);
                   }

                   $('.helpenzyme').hide();
                   $('.helpenzyme').removeAttr("id");
               }

               // Calculate MIC and BreakPoint
               function calculatebp(obj) {
                   var mic = $(obj).val();
                   var bp = $(obj).closest("tr").find("#txtbp").val();
                   if (mic == "" || isNaN(mic)) {
                       //$(obj).closest("tr").find("#txtbpmic").val('');
                       return;
                   }

                   if (bp == "" || isNaN(bp)) {
                       $(obj).closest("tr").find("#txtbpmic").val(mic);
                       return;
                   }

                   var micbp = parseFloat(mic) / parseFloat(bp);
                   $(obj).closest("tr").find("#txtbpmic").val(parseFloat(micbp).toFixed(4));
               }


               function getanibioticsagainsenzyme(obid) {

                   var enzymeid = $(obid).closest("tr").attr('id');
                   serverCall('LabResultEntryNew_Micro.aspx/Bindantibioticsagainsanzyme', { enyid: enzymeid }, function (response) {
                       AntiEnzyme = JSON.parse(response);
                       for (var a = 0; a <= AntiEnzyme.length - 1; a++) {

                           $('#tbanti tr').not(':first').each(function () {
                               if ($(this).find('#txtinter_' + AntiEnzyme[a].mapmasterid).val() != undefined) {
                                   if ($(obid).val() == "Detected") {
                                       var dataToSelect = $(this).find('#txtinter_' + AntiEnzyme[a].mapmasterid).val('Resistant');
                                       $(this).find('#txtinter_' + AntiEnzyme[a].mapmasterid).attr('disabled', true);

                                       $(this).find("#ddlValue option:selected").text('Resistant');
                                       $(this).find("#ddlValue").closest('td').css({ 'color': 'white', 'background-color': 'red' });
                                       $(this).find("#ddlValue").attr('disabled', true);
                                       $(this).find("#ddlValue option:selected").trigger("chosen:updated");
                                   }
                                   else {
                                       $(this).find("#ddlValue").attr('disabled', false);
                                       $(this).find("#ddlValue option:selected").trigger("chosen:updated");
                                   }
                               }
                           });
                       }
                   });
               }

               function getlabobservationdata() {

                   var ObsMain = [];
                   $('#tb_MicroMIC tr').each(function () {
                       if ($(this).attr("id") != "header" && $(this).attr("class") == "labobservation") {
                           var Obsdata = [];
                           Obsdata[0] = Test_ID;
                           Obsdata[1] = $(this).attr("id");
                           Obsdata[2] = $(this).find("#obName").html();
                           Obsdata[3] = $(this).find("#txtValue").val(); //Obsdata[3] = $(this).find("#txtValue").val();/**16-06-2017**/
                           Obsdata[4] = $(this).find("#txtreadingformat").val();
                           Obsdata[5] = $('#repstatus option:selected').text();
                           Obsdata[6] = $('#txtreportdate').val() + ' ' + $('#txtreporttime').val();
                           Obsdata[7] = $(this).find("#txtMethodName").val();
                           Obsdata[8] = $(this).find("#Description").val();
                           ObsMain.push(Obsdata);
                           if ($(this).find("#txtValue").val() != "") {
                               chk = "1";
                           }


                       }
                   }
                   );

                   return ObsMain;
               }


               function getorganismandenzymedata() {
                   var EnyMain = [];
                   $('#tb_MicroMIC tr').each(function () {
                       if ($(this).attr("id") != "header" && $(this).attr("class") != "labobservation" && $(this).attr("id") != "AddParameter" && $(this).attr("id") != "head1") {
                           var Enydata = [];
                           Enydata[0] = Test_ID;
                           Enydata[1] = $(this).attr("class");
                           Enydata[2] = $(this).find("#organismname").html();

                           Enydata[3] = $(this).find("#groupid").html();
                           Enydata[4] = $(this).find("#groupname").html();

                           Enydata[5] = $(this).attr("id");
                           Enydata[6] = $(this).find("#enyname").html();

                           Enydata[7] = $(this).find('#txtValueenzyme_' + $(this).attr('id')).val();//$(this).find(".enyvalue").val();
                           Enydata[8] = $(this).find("#txtreadingformat").val();

                           Enydata[9] = $('#repstatus option:selected').text();
                           Enydata[10] = $('#txtreportdate').val() + ' ' + $('#txtreporttime').val();
                           var mm = "colonycount" + $(this).attr("class");
                           Enydata[11] = $('#' + mm).val();
                           Enydata[12] = $(this).find("#organizmMethod").html();/**30-08-2017**/

                           EnyMain.push(Enydata);


                       }
                   }
                   );

                   return EnyMain;
               }

               function getorganismantibiotics() {

                   var AntiMain = [];
                   $('#tbanti tr').each(function () {
                       if ($(this).attr("id") != "header" && $(this).attr("id") != "head1") {
                           var Antidata = [];
                           Antidata[0] = Test_ID;
                           Antidata[1] = $(this).attr("class");
                           Antidata[2] = $(this).find("#obname").html();

                           Antidata[3] = $(this).attr("id");
                           Antidata[4] = $(this).find("#antiname").html();
                           Antidata[5] = $(this).find("#antigroupid").html();
                           Antidata[6] = $(this).find("#antigroupname").html();
                           if ($(this).find('#ddlValue option:selected').text() == 'None') {
                               Antidata[7] = '';
                           }
                           else {
                               Antidata[7] = $(this).find('#ddlValue option:selected').text();//$(this).find(".antiint").val();
                           }
                           Antidata[8] = $(this).find("#txtmic").val();
                           Antidata[9] = $(this).find("#txtbp").val();
                           Antidata[10] = $(this).find("#txtbpmic").val();

                           Antidata[11] = $('#repstatus option:selected').text();
                           Antidata[12] = $('#txtreportdate').val() + ' ' + $('#txtreporttime').val();
                           Antidata[13] = $(this).find("#organizmMethod").html();
                           Antidata[14] = $(this).find("#lblMAC_Inter").text();
                           Antidata[15] = $(this).find("#lblMAC_MIC").text();
                           AntiMain.push(Antidata);


                       }
                   }
                   );

                   return AntiMain;
               }
               function SaveResult(Approved) {
                   if ('<%=SampleReceive%>' == "1" && Approved == "1") {
                       if (confirm("48 Hours Is not Completed, if you want to approve please click Ok Otherwise Cancel ....!!! ?"))
                           SaveResultAfterConfrirm(Approved)
                   }
                   else {
                       SaveResultAfterConfrirm(Approved)
                   }

               }
               var chk = "0";
               function SaveResultAfterConfrirm(Approved) {

                            
                   var observationdata = getlabobservationdata();
                   var orgasismandenzyme = getorganismandenzymedata();
                   var organismantibiotics = getorganismantibiotics();
                   if (chk == "0") {
                       alert("Kindly Enter atleast one value");
                       return;
                   }
                   var DeliveryDateTime = $('#txtreportdate').val() + ' ' + $('#txtreporttime').val();
                   // var Comments = $('#txtComments').text(); 
                   var Comments = $('#txtComments').html();
                   var Sample_ID = $('#ddlsample').val();
                   var Sample_Type = $('#ddlsample option:selected').text();
                   var OtherSample_Type = $('#txtothersample').val();
                   var Method = $('#ddlMethod').val();
                   if (Method == '')
                   {
                       alert('Please fill Method Name');
                       return false;
                   }
                   $(this).closest('tr').find("#Description").text().replace(/(\r\n|\n|\r)/gm, " ").replace(/(")/g, "'").replace(/(')/g, "\''").replace(/(#)/g, "");

                   debugger;
                   serverCall('LabResultEntryNew_Micro.aspx/SaveResult', { observationdata: observationdata, orgasismandenzyme: orgasismandenzyme, organismantibiotics: organismantibiotics, Approved: Approved, DeliveryDateTime: DeliveryDateTime, Comments: Comments, Sample_Type: Sample_Type, Sample_ID: Sample_ID, OtherSample_Type: "", Investigation_Id: Investigation_Id, Method: Method }, function (result) {
                      
                       if (result == "1") {
                           toast("Success", "Result Saved..!", "");
                           $('#txtothersample').val('');
                           //   window.opener.PatientLabSearch();
                           changeColor('tr_' + Test_ID, '0');
                           //  Confirm();
                           location.reload();

                       }
                       else {
                           toast("Error", result, "");
                       }
                   });
               }
               function BindSampleType() {
                   var ddlinv = $('#ddlsample');
                   ddlinv.empty();
                   serverCall('LabResultEntryNew_Micro.aspx/BindSampleType', { Investigation_Id: Investigation_Id }, function (response) {
                       PatientInv = JSON.parse(response);
                       ddlinv.append($("<option></option>").val('').html(''));
                       for (var a = 0; a <= PatientInv.length - 1; a++) {
                           ddlinv.append($("<option></option>").val(PatientInv[a].SampleTypeID).html(PatientInv[a].SampleTypeName));
                       }

                       var textToFind = $('#<%=lblOtherAndSampleType.ClientID%>').html();

                       var dd = document.getElementById('ddlsample');
                       for (var i = 0; i < dd.options.length; i++) {
                           if (dd.options[i].text.toUpperCase() == textToFind.toUpperCase()) {
                               dd.selectedIndex = i;
                               break;
                           }
                       }

                       $('#txtothersample').val('<%=Othersample%>');
                   });
                   }
                   function NotApproved() {
                       serverCall('LabResultEntryNew_Micro.aspx/NotApproved', { testid: Test_ID }, function (result) {
                           if (result == "1") {
                           
                               alert("Result NotApproved..!");
                               $('.btnappro').show();
                               $('#btnnotapp').hide();
                               $('#apptr').hide();
                               changeColor('tr_' + Test_ID, '0');
                               // Confirm();

                           }
                           else {
                               alert(result);
                           }
                       });
                   
                   }
                   function Hold1() {
                       $.blockUI({ message: $('#Div_hold') });
                   }
                   function Cancle_hold() {
                       $.unblockUI();
                   }
                   // function Approve1(type) {
                   //     $.blockUI({ message: $('#Div_Approve') });
                   // }
                   function Approve1(type) {
                       myModal.style.display = "block";
                   }
                   function closeApprovalSchedule() {
                       myModal.style.display = "none";

                   }
                   function Hold() {
                       //var text = prompt("Do You want to Hold Please Specify Comment", "");
                       var sel = document.getElementById('ddlholdreason');
                       var text = sel.options[sel.selectedIndex].value;

                       if (text == "") {
                           alert(" Please Specify Comment .....!!!!! ");
                           Cancle_hold();
                           return;
                       }
                       serverCall('LabResultEntryNew_Micro.aspx/Hold', { testid: Test_ID, HoldComment: text }, function (result) {
                           if (result == "1") {

                               $(".btnhold").hide();
                               $(".btnunhold").show();
                               $('.btnPrint').hide();
                               alert("On Hold ...!!!")
                               Cancle_hold();
                               changeColor('tr_' + Test_ID, '3');
                               location.reload();
                           }
                       });

                   }
                   function UnHold() {
                       serverCall('LabResultEntryNew_Micro.aspx/UnHold', { testid:  Test_ID  }, function (result) {
                           if (result == "1") {

                               $('#btnhold').show();
                               $(".btnunhold").hide();
                               $('.btnPrint').show();
                               alert("On UnHold ...!!!");
                               changeColor('tr_' + Test_ID, '0');
                               location.reload();
                           }
                       });
                  
                   }


               
                   function Approved(type)
                   {
                       //type = $("#hfApprovetype").val();
                       // if ('<%=SampleReceive%>' == "1")
                   // {
                   //     //if (confirm("48 Hours Is not Completed, if you want to approve please click Ok Otherwise Cancel....!!! ?"))
                   Approve1(type);
                   //     // Approvedafterconfirm(type)
                   // }
                   // else {
                   //       Approvedafterconfirm(type)
                   //  }

               }
               function Approvedafterconfirm(type) {
                   serverCall('LabResultEntryNew_Micro.aspx/Approved', { testid: Test_ID }, function (result) {
                       if (result.split('_')[2] == "1") {
                           if (type = "1") {

                               alert("Result Approved..!");
                               $('#btnnotapp').show();
                               $('.btnappro').hide();
                               $('#apptr').show();
                               $('#buttontr').hide();
                               $('#appby').html(result.split('_')[0]);
                               $('#appdate').html(result.split('_')[1]);
                               changeColor('tr_' + Test_ID, '1');
                               // Confirm();
                           }
                           else {

                               alert("Result Approved..!");
                               $('#btnnotapp').show();
                               $('.btnappro').hide();
                               $('#apptr').show();
                               $('#appby').html(result.split('_')[0]);
                               $('#appdate').html(result.split('_')[1]);
                               // Confirm();
                           }
                           location.reload();
                       }
                       else {
                           alert(result);
                       }
                   });
               }


               function Print(type) {
                   changeColor('tr_' + Test_ID, '2');
                   location.reload();
                   window.open('../../Design/Lab/labreportmicro.aspx?IsPrev=1&TestID=' + Test_ID + "," + '&Phead=0');
               }
              
               function addtotextobs(ctr) {
                   $(ctr).closest('tr').find('#txtValue').val($(ctr).val());
                   $(ctr).hide();
               }
               // Prashant
               function ChangeColor(ctr) {
                   // alert($(ctr).val().toLowerCase());
                   if ($(ctr).val().toLowerCase() == "resistant") {
                       $(ctr).closest('td').css({ 'color': 'white', 'background-color': 'red' });
                   }
                   else {
                       $(ctr).closest('td').css({ 'color': '', 'background-color': '' });
                   }
               }

               function GetComment() {
                   var cId = $('#ddlComments').val();
                   serverCall('LabResultEntryNew_Micro.aspx/GetComment', { cId: cId }, function (result) {
                       var result1 = result.split("{Comments:\"");
                       if(result1.length>1){
                           var res2 = result1[1].split("\"}");
                      
                           $('#txtComments').html(res2[0]);
                      
                   }
                   else
               {
                           $('#txtComments').html(result.replace('[{"Comments":"','').replace('"}]',''));
                       }
                   });
               }

               function fillEnzymeData(rowID) {
                   if ($('#tb_MicroMIC tr#' + rowID).find('#ddlEnzyme option:selected').text() == 'None') {
                       $('#tb_MicroMIC tr#' + rowID).find('#txtValueenzyme_' + rowID).val('');
                   }
                   else {
                       $('#tb_MicroMIC tr#' + rowID).find('#txtValueenzyme_' + rowID).val($('#tb_MicroMIC tr#' + rowID).find('#ddlEnzyme option:selected').text());
                   }
               }

               function showLog(crl) {

                   if (typeof (crl) == 'object') {
                       var obsevalue = $(crl).val();
                   }
                   if (obsevalue != "") {
                       $('#Logdiv').html(obsevalue);
                       $('#Logdiv').css({ 'top': mouseY, 'left': mouseX }).show();
                   }
               }
               function hideLog() {
                   $('#Logdiv').hide();
               }
               function _showenzymehelp(ctr, type) {

                   if (type = "1") {

                       if ($('.helpenzyme').css('display') == 'none') {
                           $('.helpenzyme').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 100 }).show();
                           $('.helpenzyme').attr("id", "helpenz_" + ctr);
                       } else {
                           $('.helpenzyme').hide();
                           $('.helpenzyme').removeAttr("id");
                       }
                   }
                   else {
                       $('.helpenzyme').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 60 }).show();
                       $('.helpenzyme').attr("id", "helpenz_" + ctr);
                   }

               }
               /**08-08-2017***/
               function Exit() {
                   //  window.top.$("#iframePatient").css('width', '0px');
                   //  window.top.$("#iframePatient").css('height', '0px');
                   window.$("#iframePatient").src = "";
                   window.$("#iframePatient").css('display', 'none');
                   // window.top.document.document.getElementById("tr_Detail_" + Test_ID).style.display = 'none';
                   //     window.top.$("Pbody_box_inventory").style.display = "";

               }
               function Confirm() {
                   //alert('Record Saved Succesfully !!!');
                   //Exit();
                   jConfirm(' Do You want to <strong>Exit</strong> ?', 'Record Saved Succesfully !!!', function (r) {
                       if (r == true)
                           Exit();
                       else
                           $("#div_TextTests").hide();
                       $("#Div_Approve").hide();
                       $.unblockUI();
                   });
               }
               function changeColor(str, approved) {
                   // var psrc=window.top.document.getElementById(str).firstChild('imgEdit').attr('src');
                   // alert(psrc);
                   try {
                       if (approved == "1") {
                           window.top.document.getElementById(str).style.backgroundColor = '#90EE90';
                       }
                       else if (approved == "2") {
                           window.top.document.getElementById(str).style.backgroundColor = '#00FFFF';
                       }
                       else if (approved == "3") {
                           window.top.document.getElementById(str).style.backgroundColor = '#FFFF00';
                       }

                       else if (approved == "-1") {
                           window.top.document.getElementById(str).style.backgroundColor = '#FFFF00';
                           window.top.document.getElementById(str).getElementsByTagName('td')[10].style.backgroundColor = '#f1b444';
                           //window.top.document.getElementById(str).style.backgroundColor = '#FFFF00';                           
                       }
                       else {
                           window.top.document.getElementById(str).style.backgroundColor = '#FFC0CB';
                       }


                   }
                   catch (e) {

                   }
               }
               function _executeComment(Ctrl) {
                   serverCall('Services/ResultEntry.asmx/CommentsLabObservation', { LabObservation_ID: $(Ctrl).closest("tr").find("#LabObservation_ID").text() }, function (response) {
                       result = JSON.parse(response);
                       $("#ddlCommentsLabObservation").empty();
                       $("#ddlCommentsLabObservation").append("<option value=''>Select</option>");

                       for (var i = 0; i < result.length; i++) {
                          
                           var newOption = "<option value=" + result[i].Comments_ID + ">" + result[i].Comments_Head + "</option>";
                           $("#ddlCommentsLabObservation").append(newOption);
                       }
                   });
                   $find('<%=mpeAddComments.ClientID %>').show();
                   $("#<%=lblObName.ClientID %>").text($(Ctrl).closest("tr").find("#obName").text());

                   $("#txtObsComments").html($(Ctrl).closest("tr").find("#Description").text());
                   $("#<%=lblObName.ClientID %>").attr("rowid", $(Ctrl).closest("td").attr("id"));

                   $('.cke').css('z-index', '9999999999');
               }

               /**08-08-2017***/
               function AddComments() {
                   debugger;
                   var aa = $("#txtObsComments").html();

                   var bb = $("#tb_MicroMIC").find("#" + $("#<%=lblObName.ClientID %>").attr("rowid")).closest("tr").find("#IsCommentField").html();

                   if (aa != "" && $("#tb_MicroMIC").find("#" + $("#<%=lblObName.ClientID %>").attr("rowid")).closest("tr").find("#IsCommentField").html() == "1")
                       $("#tb_MicroMIC").find("#" + $("#<%=lblObName.ClientID %>").attr("rowid")).closest("tr").find("#txtValue").val("Reported").focus();
                    else
                        $("#tb_MicroMIC").find("#" + $("#<%=lblObName.ClientID %>").attr("rowid")).closest("tr").find("#txtValue").focus();

                    $("#tb_MicroMIC").find("#" + $("#<%=lblObName.ClientID %>").attr("rowid")).closest("tr").find("#Description").text($("#txtObsComments").html());
                   $find('<%=mpeAddComments.ClientID %>').hide();

               }
            </script>
           <Ajax:ScriptManager ID="sp" runat="server">
                
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
           </Ajax:ScriptManager>
           
               <div class="POuter_Box_Inventory" style="text-align: Left;background-color:<%=rowColor%>" align="center">
                   <div class="row">
                       <div class="col-md-3"><label class="pull-right">Report Status :</label> </div>
                       <div class="col-md-3"> <select id="repstatus" runat="server">
                                   <option>Final</option>
                                   <option>Provisional</option></select></div>
                       <div class="col-md-3"><label class="pull-right">Sample Rec Date :</label></div>
                       <div class="col-md-3"><strong><span id="sampledate"></span></strong></div>
                        <div class="col-md-4"><label class="pull-right">Sample Collection Date :</label></div>
                       <div class="col-md-3"><strong><span id="sampleCollectionDate"></span></strong></div>
                       <div class="col-md-3"></div>
                       <div class="col-md-3"> <input style="display:none" type="button" class="searchbutton" value="Home" onclick="Exit();" /></div>
                   </div>
                   <div class="row">
                       <div class="col-md-3"><label class="pull-right">Sch. Approval Date :</label> </div>
                       <div class="col-md-3"><asp:Label runat="server" Text=" NO" ID="lblSchedulerDateTime"></asp:Label></div>
                       <div class="col-md-3"><label class="pull-right">Current Report Status :</label> </div>
                       <div class="col-md-3"><strong>
                               <asp:Label ID="lbstatus" runat="server"></asp:Label></strong></div>
                       <div class="col-md-4"><label class="pull-right">Last Report Datetime:</label> </div>
                       <div class="col-md-3"><strong> <asp:Label ID="lbrptime" runat="server"></asp:Label></strong></div>
                       </div>
                   <div class="row" style="display:none">
                       <div class="col-md-3">Report DateTime :</div>
                       <div class="col-md-3"><asp:TextBox ID="txtreportdate" runat="server" Width="100px"></asp:TextBox></div>
                       <div class="col-md-3"><asp:TextBox ID="txtreporttime" runat="server" Width="100px"></asp:TextBox>
                               <cc1:CalendarExtender ID="cc" runat="server" TargetControlID="txtreportdate" PopupButtonID="txtreportdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                               <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtreporttime"
                                   AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                               </cc1:MaskedEditExtender></div>
                       <div class="col-md-4">Sample Type :</div>
                       <div class="col-md-3"><asp:Label ID="lblOtherAndSampleType" runat="server" style="display:none"></asp:Label></div>
                       </div>
                   <div class="row">
                       <div class="col-md-24"><strong><asp:Label ID="lblPatientDetail" runat="server"></asp:Label></strong></div>
                       </div>
                    <div class="row" id="Sample_type">
                       <div class="col-md-3"><label class="pull-right">Sample Type :</label></div>
                        <div class="col-md-3"><select id="ddlsample" style="width:100px;" ></select></div>
                        <div class="col-md-3"><label class="pull-right">OtherSampleType :</label></div>
                         <div class="col-md-3">  <select id="ddlMethod" style="width: 200px;">
                                   <option value="Automated by BD Phoenix">Automated by BD Phoenix</option>
                                   <option value="Disc Diffusion Method">Disc Diffusion Method</option>
                               </select></div>
                        </div>
              
             </div>
               <div class="POuter_Box_Inventory" style="width:100%">
             <div runat="server" id="dragHandle" onclick="LoadInvName();" style="background-color:black;color:white;font-weight:bold;cursor:help;"> 
                Show Investigation Details  
                 </div>  
          <div class="Purchaseheader"> 
                 <div class="DivInvName" title="Click To Make Test Visible/Invisible!"  style="color:Black; cursor: pointer;font-weight:bold;"> </div> </div>
          
          
          </div>
                <div class="POuter_Box_Inventory" style="text-align: Left; width: 99.7%;" align="center">
     
               <table width="100%">

                   <tr>

                      <td width="50%" valign="top">   <div id="div_Tests" style=" text-align:center;  width:100%;" class="POuter_Box_Inventory" >

             </div></td>
                      <%-- <td width="3%">&nbsp;</td>--%>
                       <td width="47%" valign="top">
                          <%--<strong> <span id="obsname"></span></strong>--%>
           <div id="div_anti" style=" text-align:center;  width:100%; display:none; max-height:435px; overflow-y:scroll;" class="POuter_Box_Inventory">

             <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbanti" style="border-collapse:collapse;">
             <tr  style="text-align: left; color: #387C44;" id="header">
             <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Sr.No</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:150px;">AntibioticName</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Sensitivity Result</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:150px;">MAC-Inter</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:50px;">MIC</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:50px;">MAC-MIC</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none">BreakPoint</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none">MIC/BP</th>
             </tr>
</table>
          
               
              
             </div>
                           </td>
                       </tr> 

                  <%-- /****16-06-2017**/--%>
                   <tr style="text-align: center; background-color: #fafad2;"><td colspan="12" >Select comments:
                         <asp:DropDownList ID="ddlComments" Width="340px" runat="server" onchange="GetComment();"> </asp:DropDownList></td>
                   </tr>
                    <tr  id="Comments" style="text-align: center; background-color: #fafad2;">
                         <td colspan="12" >
                        <div id="txtComments" runat="server" style="width:99%;border:solid 1px #000000;min-height:15px; text-align:left;background-color:#FFFFFF;padding:5px;"  contenteditable="true"  ></div>
                    </td></tr> 
                   <%-- /****16-06-2017**/--%>

                   <% if (isapproved == "0")
                      { %>
                   <tr id="buttontr">
                       <td colspan="3" align="center" style="border:1px solid;">
<input id="btnSave" type="button"  class="ItDoseButton"  value="Save" style="cursor:pointer;font-weight:bold;" accesskey="s" onclick="SaveResult('0')" />
                            <input class="btnhold" type="button" id="btnhold"    value="Hold" onclick="Hold1()"
                   style="cursor:pointer;font-weight:bold;"   accesskey="a" />&nbsp;&nbsp; 
                            
                            <input class="btnunhold" type="button" id="btnunhold"    value="UnHold" onclick="UnHold()"
                   style="cursor:pointer;font-weight:bold;background-color:whitesmoke;"   accesskey="a" />&nbsp;&nbsp; 
                           <input id="btnPrint" class="btnPrint" type="button"  class="ItDoseButton"  value="Print" onclick="Print('1')"
                  style="cursor:pointer;font-weight:bold;"  accesskey="p" />
                <% if (isApproval == "3" || isApproval == "4")
                   { %>

                <% if (isresult == "1")
                   { %>  
                           <input class="btnappro" type="button"     value="Approve" onclick="Approved('0')"
                   style="cursor:pointer;font-weight:bold;"   accesskey="a" />&nbsp;&nbsp; 
                           <%} %>     
               <input id="btnsaveandapproved" type="button"  class="ItDoseButton"  value="Save & Approved" onclick="SaveResult('1')"
                  style="cursor:pointer;font-weight:bold;display:none;"  accesskey="a" />

             
                          
                            
                             <%} %>
                       </td>
                   </tr>
                   <%}
                      else
                      {
                      %>
                   <tr>
                       <td colspan="3" align="center" style="border:1px solid;">

                <% if (isApproval == "3" || isApproval == "4")
                   { %>

                     <input class="btnappro" type="button"   value="Approve" onclick="Approved('1')"
                  style="cursor:pointer;font-weight:bold;display:none;background-color:whitesmoke;"  accesskey="a" />&nbsp;&nbsp;

               <input id="btnnotapp" type="button"  class="ItDoseButton"  value="Not Approve" onclick="NotApproved()"
                  style="cursor:pointer;font-weight:bold;"  accesskey="a" />

             <input id="Button3" type="button"  class="ItDoseButton"  value="Print" onclick="Print('1')"
                  style="cursor:pointer;font-weight:bold;"  accesskey="p" />
                           <%} %>
                       </td>
                   </tr>
                     <tr style="background-color:green;" id="apptr">
                       <td colspan="3" align="center" style="border:1px solid;color:white;">

                        <strong>   Result Approved By::<span id="appby"> <%=approvedby %></span> at:: <span id="appdate"><%=approveddate %></span></strong>
                           </td>
                         </tr>
                   <%} %>
                   
                   </table>
                    </div>
                 <%-- /**16-06-2017**/--%>
                 <datalist id="datalistantibiotic">
                    <option value="Intermediate">Intermediate</option>
                    <option value="Resistant">Resistant</option>
                    <option value="Sensitive">Sensitive</option> 
                </datalist>


               <datalist id="datalisthelpenzyme">
                    <option value="Intermediate">Intermediate</option>
                    <option value="Detected">Detected</option>
                    <option value="Not Detected">Not Detected</option> 
                </datalist>
                <%-- /**16-06-2017**/--%>              
         
            <asp:Button ID="Button7" runat="server" Text="Button" style="display:none;" />

           <asp:Panel ID="CommentsData" runat="server" Width="750px" CssClass="pnlOrderItemsFilter" Style="display:none;" >
    <div class="Purchaseheader" id="Div2" runat="server">
       Set Comments for <asp:Label ID="lblObName" runat="server" ></asp:Label>
       
         
           
       </div>
    <div class="content" style="width:700px;" >
        <table style="width:700px;">
        <tr style="font-weight:bold;">
        <td style="width:25%;">Comments:
        <select id="ddlCommentsLabObservation" onchange="ddlCommentsLabObservation_Load(this.value);">
        
        </select>
        </td>
        </tr>
        <tr>
        <td>
        <%--<asp:TextBox ID="txtObsComments" Width="300px" runat="server"></asp:TextBox>--%>
            <div style="background-color:#FFFFFF; padding:5px; max-height:230px; overflow:scroll; ">
        <span id="txtObsComments"  contenteditable="true" style="background-color:#FFFFFF; padding:5px; max-height:230px; overflow:scroll; "  > </span></div>
        </td>
        </tr>
        
        </table>
</div>
    <div class="filterOpDiv" >
        <input id="btnSaveComments" type="button"  class="ItDoseButton"   value="Add Comments" onclick="AddComments();"/>
        <asp:Button ID="BtnCancelComments" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false"  />
    </div>
</asp:Panel> 

             <cc1:modalpopupextender id="mpeAddComments" runat="server" CancelControlID="BtnCancelComments" 
    TargetControlID="Button7" BackgroundCssClass = "filterPupupBackground" PopupControlID="CommentsData"
    X="50" Y="50">
    </cc1:modalpopupextender>
    
    <script id="DynamicTable_Micro_Mic" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_MicroMIC"
    style="border-collapse:collapse;width:99%;">
		<tr   style="text-align: left; color: #387C44;" id="header">
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Sr.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:250px;">ObservationName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Value</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:100px; display:none">Group</th>
            <%-- <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Unit</th>--%>
</tr>

       <#
       
              var dataLength=ObsTable.length;
          
              var objRow;  
           
        for(var j=0; j < dataLength;j++)
        {
            RowsCount=j+1;
        objRow = ObsTable[j];
         
           
            #>
<tr id="<#=objRow.labObservation_ID#>" style="text-align: left;   background-color: #fafad2;" class="labobservation">
<td style="width:50px;"><#=j+1#></td>
                     <td style="width:250px;">&nbsp;&nbsp<span id="obName" ><#=objRow.obName#></span>
                     </td>
<td style="width:140px;">
     <div style="width:200px;">
        <input id="txtValue" class="flexdatalist"       data-min-length="1"       list="datalisthelpme_<#=objRow.labObservation_ID#>"   type="text"  style="width:225px;" value="<#=objRow.VALUE#>" onmouseover="showLog(this);" onmouseout="hideLog()" />
          <img id="imgHelp"  <#if( objRow.iscomment=="1"){#>class="edit_<#=objRow.labObservation_ID#>" <#}else{#>style="display:none;"<#}#>   src="../../App_Images/question_blue.png" alt="[F1] Help."   />   	
         <# if(objRow.helpoption!="0") {#>
       <%--  /**16-06-2017**/--%>
          <datalist id="datalisthelpme_<#=objRow.labObservation_ID#>">                     
                    <# 
             var _OrgList=objRow.helpoption.split('|');
        var k=_OrgList.length;
        for(k=0;k<_OrgList.length;k++)
        {#>
        <option value="<#=objRow.helpoption.split('|')[k]#>"><#=objRow.helpoption.split('|')[k]#></option>
             <#}#>
                </datalist>
         <%--  /**16-06-2017**/--%>
                         <#}#>	
        <span id="Approved" style="display:none;" ><#=objRow.Approved#></span>
     </div>
</td>
   <td id="<#=j+1#>" style="text-align:center;white-space:nowrap;display:none;">
    
    <img id="imgEdit" src="../../App_Images/edit.png" title="Edit" style="cursor:pointer" />&nbsp;&nbsp;<img id="imgComments" src="../../App_Images/view.gif" title="Add Comments" style="cursor:pointer" /> 
       </td>   
    
<td style="width:100px; display:none"></td>
     <td style="display:none;"><span id="IsCommentField" ><#=objRow.iscomment#></span></td>
    <td style="display:none;"><span id="LabObservation_ID" ><#=objRow.labObservation_ID#></span></td>
     <td style="display:none;"><textarea id="Description" ><#=objRow.Description.replace(/''/g,"'")#></textarea></td> 
  

<td style="width:100px;display:none"> <input id="txtreadingformat" style="width:90px;" type="text" value="<#=objRow.ReadingFormat#>" />  </td>
            <td style="width:100px;display:none"> <input id="txtMethodName" style="width:90px;" type="text" value="<#=objRow.MethodName#>" />  </td>

</tr>

             
              <#}#>

            <tr  id="AddParameter"  style="text-align: left; background-color: #fafad2;">
                <td style="width:50px;"><#=dataLength+1#></td>
   <td colspan="4" style="text-align: left;"  >
	&nbsp;&nbsp;<asp:DropDownList  ID="ddlOrganism" onchange="showobsandenzimelist(this)" runat="server"></asp:DropDownList>

  </td></tr>
        </table>  
 </script>

    <script id="Add_MoreObservation" type="text/html">

  <#
      var dataLength=Obsrow.length;
      
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
                var tabletrlength=tablelength() ;
           if(dataLength>0)
                {
                #>

<tr class="<#=Obsrow[0].obid#>" style="text-align: left; background-color: #fafad2; " id="head1" >
       <td style="width:50px;"></td>
<td id="tdantibiotic_<#=Obsrow[0].obid#>" colspan="4"><strong><span id="organismname"><#=Obsrow[0].obname#></span></strong> <a id="btnrmvantibio" href="javascript:void(0);" onclick="removeobs('<#=Obsrow[0].obid#>');">Remove</a>&nbsp;&nbsp;<strong>Colony Count :&nbsp;</strong><input type="text" id="colonycount<#=Obsrow[0].obid#>" value="<#=Obsrow[0].mmvalue#>" class="colonycount" style="width:70px;" /> <input type="button" style="float:right;cursor:pointer;color:white;background-color:rebeccapurple;" value="Show Antibiotics" onclick="showantibiotics('<#=Obsrow[0].obid#>', '<#=Obsrow[0].obname#>')" /><br /><strong><span>Method: <#=Obsrow[0].Method#></span></strong>
    <span id="groupid" style="display:none;"><#=Obsrow[0].groupid#></span>  <span id="groupname" style="display:none;"><#=Obsrow[0].groupname#></span>
     <span id="enyname" ></span>
</td>
</tr>                
                
                <#
                }
              

        for(var j=0;j<dataLength;j++)
        {
        objRow = Obsrow[j];
        #>

<tr id="<#=objRow.id#>" style="text-align: left;   background-color: #fafad2;" class="<#=objRow.obid#>">
                            <td style="width:50px;"><#=j+1#></td>
                     <td style="width:250px;">&nbsp;&nbsp<span id="enyname" ><#=objRow.name#></span><span id="organismname" style="display:none;"><#=Obsrow[0].obname#></span></td>
                           <td style="width:140px;">
                                <span id="groupid" style="display:none;"><#=objRow.groupid#></span>  <span id="groupname" style="display:none;"><#=objRow.groupname#></span><span id="organizmMethod" style="display:none;"><#=Obsrow[0].Method#></span>
     <div style="width:200px;">
        
       <input id="txtValueenzyme_<#=objRow.id#>" class="flexdatalist"   style="width:225px;"    data-min-length="1"       list="datalisthelpenzyme"  type="text" value="<#=objRow.VALUE#>"  onfocus="_showenzymehelp('<#=objRow.id#>','1')"  onblur="checkvalue(this)"   />
         
	<%--style="<#if(<#=objRow.VALUE#>=='Detected'){#>width:190px;background-color:red;color:white;"<#}else{#>width:190px;"<#}#> <img id="img1" onclick="_showenzymehelp('<#=objRow.id#>','2')" src="../Purchase/Image/question_blue.png" />--%>
         <span id="Span3" style="display:none;" ><#=objRow.Approved#></span> 
      
      </div>
     
    </td>
             <td style="width:100px; display:none"></td>
                            <td style="width:100px;display:none"> <input id="txtreadingformat" style="width:90px;" type="text" value="<#=objRow.ReadingFormat#>" />  </td>
                             </tr>

<#}#>
</script>

    <script id="DynamicTable_Aticbiotic" type="text/html">

       

              <#
       
              var dataLength=AntiTable.length;
          
              var objRow;  
           

              if(dataLength>0)
                {
                #>
             <tr class="<#=AntiTable[0].obid#>" id="head1"><td colspan="6" align="left"><strong > Organism Name : <#=AntiTable[0].obname#></strong>
                 <span id="obname" style="display:none;"><#=AntiTable[0].obname#></span>

                                                </td></tr>
             <#}
        for(var j=0; j < dataLength;j++)
        {
            RowsCount=j+1;
        objRow = AntiTable[j];
           
           
            #>
              <tr class="<#=objRow.obid#>" id="<#=objRow.id#>" style="text-align: left;   background-color: #fafad2;">
                            <td style="width:30px;">&nbsp;&nbsp<#=j+1#>
                                <span id="antigroupid" style="display:none;"><#=objRow.AntibioticGroupID#></span>
                                <span id="antigroupname" style="display:none;"><#=objRow.AntibioticGroupName#></span>
                                <span id="obname" style="display:none;"><#=objRow.obname#></span>
                            </td>
                  <td style="width:150px;">&nbsp;&nbsp;<span id="antiname" ><#=objRow.name#></span></td>
                  <td 
                       
                         <# if(objRow.VALUE == 'Resistant')
        {#>
            style="width:120px;background-color:red;"
        <#}

        else
        {#>
        style="width:120px;"
    <#}#>
                      >
                      
                      <input class="antiint" type="text" id="txtinter_<#=objRow.id#>"  style="width:90px;display:none"   value="<#=objRow.VALUE#>"  />
                      <select id="ddlValue" style="width:200px;" onchange="ChangeColor(this)">
                          <option value="None">None</option>
                            <option value="intermediate">Intermediate</option>
                          <option value="resistant">Resistant</option>
                          <option value="sensitive">Sensitive</option>
</select>
                     <%-- <img id="imghelp" onclick="_showhideList('<#=objRow.id#>','1')" src="../Purchase/Image/question_blue.png" />
                      --%>
                  </td>
                  <td style="width:50px; text-align:center"><label id="lblMAC_Inter"><#=objRow.Interpretation#></label></td>
                  <td style="width:50px;"><input type="text"  style="width:50px" value="<#=objRow.mic#>" onkeyup="calculatebp(this)" id="txtmic"/>
                  </td>
                  <td style="width:50px ; text-align:center"><label id="lblMAC_MIC"><#=objRow.machinereading#></label></td>
                  <td style="width:50px; display:none"><input type="text" style="width:70px" id="txtbp" value="<#=objRow.breakpoint#>" readonly="readonly" /></td>
                  <td style="width:50px; display:none"><input type="text" style="width:50px" id="txtbpmic" value="<#=objRow.mic_bp#>" readonly="readonly" /></td>
                  </tr>
              <#}#>
            
    </script>
           <%--/28-08-2017/--%>
           <div id="Logdiv" style="display:none;position:absolute; background-color:#FAD7A0; border-radius:3%;border-width:10px; border-color:#CD6155; width:25%; text-align:justify">
          
         </div>
        <%--/28-08-2017/--%>
           
        <div id="deltadiv" style="display:none;position:absolute;">
          
        </div>
           
           <div id="Div_hold" class="POuter_Box_Inventory" style="width:300px; display:none; cursor:default; text-align:left;">
            <div class="Purchaseheader" style="width:300px;">
                   <label id="Label1" style="color:Blue;"></label>
                     <label id="Label3" style="display:none;"></label>
            </div>

    Hold Reason :
                        <asp:DropDownList ID="ddlholdreason" Width="150px" runat="server">
                            </asp:DropDownList><br />
            
             &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
             <input id="Button1" type="button" value="Save" onclick="Hold();" />
             <input id="Button2" type="button" value="Cancel" onclick="Cancle_hold();" />
         </div>
              <%-- Schedule Patient For approval --%>
           <div id="myModal" class="modal">
               <div class="modal-content">
            <div class="Purchaseheader" style="width:300px;">
                   <label id="Label2" style="color:Blue;" text=""></label>
                     <label id="Label4" style="display:none;"></label>
            </div>
                <asp:TextBox ID="txtSchedulerDate"  runat="server" CssClass="inputtext1" Width="100px" />
                            <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtSchedulerDate" TargetControlID="txtSchedulerDate" />
                            
                            <asp:TextBox ID="txtSchedulerTime" Text="00:00:00" runat="server" CssClass="inputtext1" Width="70px" />
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtSchedulerTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                             <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                ControlExtender="mee_txtToTime" ControlToValidate="txtSchedulerTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>
              <br />
               <br />
             <input type="button" id="btnScheduleApproval" onclick="ScheduleApproval()" value="Schedule Approval"/>
            
            <%--&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  <input id="Button6" type="button" value="Hold" onclick="Hold1();" />--%>
             <input id="Button4" type="button" value="Approved Yes" onclick="Approvedafterconfirm('0');" />
                   <input id="Button5" type="button" value="Close" onclick="closeApprovalSchedule();" />
             <%--<input id="Button5" type="button" value="No" onclick="Cancle_hold();" />--%>
         </div>
               </div>
             
        <%-- End Schedule Approval--%>


         
  <script>
      function ScheduleApproval()
      {
                
          if ($("#txtSchedulerDate").val() == '')
          {
              $("Please select Scheduler Date");
              return false;
          }
          if ($("#txtSchedulerTime").val() == '')
          {
              alert("Please Select Scheduler Time");
              return false;
          }
          $.ajax({
              url: "LabResultEntryNew_Micro.aspx/SchedulerApproval",
              data: '{ testid:"' + Test_ID + '", DateTime:"' + $("#txtSchedulerDate").val() + " " + $("#txtSchedulerTime").val() + '"}', // parameter map
              type: "POST", // data has to be Posted    	        
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              async: false,
              success: function (result) {
                  if (result == "1")
                  {
                      //    window.opener.PatientLabSearch();

                      alert("Scheduler Submitted!");
                      //$('.btnappro').show();
                      //$('#btnnotapp').hide();
                      //$('#apptr').hide();
                      changeColor('tr_' + Test_ID, '-1');
                      Confirm();

                  }
                  else 
                  {
                      alert(result.d);
                  }

              },
              error: function (xhr, status) {
                  alert(xhr.responseText);

              }
          });
      }
           </script>
</form>
</body>

     
</html>
