<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="DeltaCheckMobile.aspx.cs" Inherits="Design_Lab_DeltaCheckMobile" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
	
    </head>
<body>
    <style>
        div#divPatient {
            background: #ffffff;
            overflow-y: auto;
        }

        div#divInvestigation {
            background: #ffffff;
            overflow-y: auto;
        }

        div#divInvestigationLabNo {
            background: #ffffff;
            overflow-y: auto;
        }

        div#divParamterLabNo {
            background: #ffffff;
            overflow-y: auto;
        }

        .web_dialog_overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            background: #000000;
            opacity: .15;
            filter: alpha(opacity=15);
            -moz-opacity: .15;
            z-index: 101;
            display: none;
        }

        .web_dialog {
            display: none;
            position: fixed;
            width: 220px;
            top: 50%;
            left: 50%;
            margin-left: -190px;
            margin-top: -100px;
            background-color: #ffffff;
            border: 2px solid #336699;
            padding: 0px;
            z-index: 102;
            font-family: Verdana;
            font-size: 10pt;
        }

        .web_dialog_title {
            border-bottom: solid 2px #336699;
            background-color: #336699;
            padding: 4px;
            color: White;
            font-weight: bold;
        }

            .web_dialog_title a {
                color: White;
                text-decoration: none;
            }

        .align_right {
            text-align: right;
        }
    </style>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
      <form id="form1" runat="server">
     <div id="output"></div>  
    <div id="overlay1"  class="web_dialog_overlay"></div>  
    <div id="dialog1" style="position: fixed;top: 50%;left: 50%;background-color: #ffffff;border: 2px solid #336699;padding: 0px; z-index: 102;font-family: Verdana;font-size: 10pt;" class="web_dialog"> 
          <div id="tblModifyState">  
            <div class="row">  
                <div class="web_dialog_title">
                    Call Closing Remarks
                </div>  
            </div>  
              <div class="row">
                  <div class="col-md-12">
                      <span id="spnClosingRemarksError" class="ItDoseLblError"></span>
                  </div>
              </div>
           
              <div class="row">  
                <div class="col-md-12">
                    <asp:DropDownList ID="ddlRemarks" runat="server" class="ddlRemarks chosen-select chosen-container" ClientIDMode="Static"></asp:DropDownList>
                </div>  
            </div>             
             
            <div class="row">  
                     <input type="button" value="Save" id="btnReportCallLog" class="savebutton"  onclick="SaveReportCallLog();"  /> 
                     <input type="button" value="Close" id="btnCloseLog" class="resetbutton"  onclick="closeCallLog();"  /> 
            </div>  
        </div>      
                
        </div>


     <div id="Pbody_box_inventory" >
          <Ajax:ScriptManager ID="sc" runat="server" AsyncPostBackErrorMessage="Error..." EnablePageMethods="true"> 
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="display:none;">
            <div class="Purchaseheader" style="display:none;" >
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="row">
            <div style="float:left;display:none;">
                <select id="ddlSearchType" class="ItDoseDropdownbox" onchange="changetext();">
                </select>
                <asp:TextBox ID="txtSearchValue"  runat="server"  onkeyup="showlength()"></asp:TextBox><span id="lblValueLength" style="font-weight:bold;"></span>
                        <asp:DropDownList ID="ddlCentreAccess"  runat="server">
                        </asp:DropDownList> 
                      <asp:TextBox ID="txtFormDate"  runat="server" ReadOnly="true" ></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                            &nbsp;- <asp:TextBox ID="txtToDate"    runat="server" ReadOnly="true" ></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                        <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchDetailByCat();" />
            </div>
             </div>
            </div>
        <div class="POuter_Box_Inventory">    
      <div class="row">
          <div class="col-md-5">
                <div id="divPatient"></div>
          </div>
          <div class="col-md-19">
                        <div class="row">
                           <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #00FA9A;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-3">
                                Fully Paid
                            </div>
                            <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #F6A9D1;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-3">
                                Partial Paid
                            </div> 
                            <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#FF457C;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-3"> 
                                Fully Unpaid</div>
                            <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#F0FFF0;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-3"> 
                                Credit</div>
                            
                        </div> 
              <div class="row">
                        <div id="divInvestigation" >
                        </div>
                    </div>
                       <div class="row">&nbsp;</div>
                        <div class="row">
                            <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;" >
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-1">
                                New</div> 
                            <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:bisque;" >
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2"> 
                                Sample Collected</div>
                            <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#FF0000;" >
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2"> 
                                Sample Rejected</div>
                            <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: White;"  >
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2">
                                Department Receive</div>

                                   
                            <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFC0CB;">
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-1">
                               Tested</div>
                                 <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2">
                                Approved</div>
                             <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#00FFFF;" >
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2">
                                 Printed</div>
                             <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFFF00;">
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-1">
                               Hold</div>
                          
                                   <div class="col-md-1" style=" border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #44A3AA;">
                                &nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-2">
                              Dispatched</div>
                        </div>
                          
                        <div class="row">
                            <div id="divInvestigationLabNo">
                          </div>
                            </div>
             
               <div class="row">
                       <div  id="conbtnid" style="text-align: center;">
                           <input type="button" id="btnReport" value="Close" onclick="OpneSavePOpup()" class="resetbutton" />
                       </div> 
                    </div>
               <div class="row">
                       <div id="divParamterLabNo">              
                        </div>    
                    </div>            
                   </div>  
                </div>
           </div>
    </div>
     
    <div id="overlay" class="web_dialog_overlay" style="display:none;"></div>
    <div id="dialog" class="web_dialog" style="display:none;">
        <div id="tblEmailSend" >
            <div class="row">
                <div class="col-md-4 Purchaseheader">Send Mail</div>
                <div class="col-md-18"></div>
                <div class="col-md-2 Purchaseheader align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor: pointer;">Close</a></div>
            </div>
            <div class="row">  
                <div class="col-md-4"> <asp:Label ID="lblApproved" runat="server" CssClass="ItDoseLblError"></asp:Label></div>                
            </div> 
             <div class="row">  
                <div class="col-md-8" style="text-align:right;"><b>To</b></div>
                <div class="col-md-16" style="text-align:left;"><asp:TextBox ID="txtEmailID" runat="server"></asp:TextBox>
                    <asp:TextBox ID="txtVisitNo" runat="server" Disabled style="display:none;"></asp:TextBox>
                </div>  
            </div> 
            
             <div class="row">  
                <div class="col-md-8" style="text-align:right;"><b>Cc</b></div>
                <div class="col-md-16" style="text-align:left;"><asp:TextBox ID="txtCc" runat="server" ></asp:TextBox></div>  
            </div> 
           
             <div class="row">  
                <div class="col-md-8" style="text-align:right;"><b>Bcc</b></div>
                <div class="col-md-16" style="text-align:left;"><asp:TextBox ID="txtBcc" runat="server" ></asp:TextBox></div>  
            </div> 
            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-16" style="text-align:left;"><input type="button" value="Send " class="savebutton" onclick="SendFinalMail();" id="btnSend" />
                    <input type="button" value="Cancel" class="savebutton" onclick=" HideDialog(true);" id="btnCancel" />
                </div>
            </div>
        </div>
        <div  style="overflow:scroll; height:100px;" id="divEmailStatus">
             <table style="width: 1750px;border: 0px;"  id="tblEmailStatus" class="GridViewStyle">
                                <tr>
                                    <td class="GridViewHeaderStyle" style="width:30px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="width:100px;">Visit No.</td> 
                                    <td class="GridViewHeaderStyle" style="width:300px;">Name</td>                      
                                    <td class="GridViewHeaderStyle" style="width:70px;">Mail Type</td>
                                    <td class="GridViewHeaderStyle" style="width:50px;">Status</td>
                                    <td class="GridViewHeaderStyle" style="width:300px;">To</td>
                                    <td class="GridViewHeaderStyle" style="width:300px;">Cc</td>
                                    <td class="GridViewHeaderStyle" style="width:300px;">Bcc</td>
                                    <td class="GridViewHeaderStyle" style="width:200px;">User Name</td>                        
                                    <td class="GridViewHeaderStyle" style="width:200px;">Sent Date</td>
                                </tr>
                    </table>
            </div>
    </div>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
     <script type="text/javascript">
         $(function () {
             iFrameLabeReport();
             BindRemarks();
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
             $('.chosen-container').css('width', '220px');

             $("#Pbody_box_inventory").css('margin-top', 0);

         });
         function iFrameLabeReport() {
             var loc = window.location.toString(),
              params = loc.split('?')[1],
              params1 = loc.split('&')[1],
              params2 = loc.split('&')[2],
              params3 = params.split('&')[0],
              params4 = loc.split('&')[3].split("Name:")[1],
              iframe = document.getElementById('estimateiframe');
             if (params != undefined) {
                 $('#mastertopcorner').hide();
                 $('#masterheaderid').hide();
                 $('#btnReport').show();
                 $('#ContentPlaceHolder1_ddlCentreAccess').hide();
                 if (params1 == "Patient") {
                     $('#ContentPlaceHolder1_txtFormDate').hide();
                     $('#ContentPlaceHolder1_txtToDate').hide();
                     var result = [{ "value": "pm.Mobile", "Name": "Mobile No." }, { "value": "lt.LedgertransactionNo", "Name": "Visit No." }];
                     for (var i = 0; i < result.length; i++) {
                         $('#ddlSearchType').append('<option value="' + result[i].value + '">' + result[i].Name + '</option>');
                     }
                     SearchDetail(params1, params2, params3);

                 }
                 if (params1 == "Doctor" || params1 == "PUP" || params1 == "PCC") {
                     var result = [{ "value": "pm.Mobile", "Name": "Mobile" }, { "value": "PM.PName", "Name": "Pateint Name" }, { "value": "lt.LedgertransactionNo", "Name": "Visit No" }, { "value": "lt.Patient_ID", "Name": "UHID No" }];
                     for (var i = 0; i < result.length; i++) {
                         $('#ddlSearchType').append('<option value="' + result[i].value + '">' + result[i].Name + '</option>');
                     }
                     SearchDetail(params1, params2, params3);
                 }
             }
             else {
                 $('#btnReport').hide();
                 return false;
             }
         }
         function BindRemarks() {
             PageMethods.GetRemarks(onSuccessRemarks, OnFailureRemarks);
         }
         onSuccessRemarks = function (result) {
             var $responseData = JSON.parse(result);
             $('#ddlRemarks').append('<option value="0">Select</option>');
             if ($responseData.length > 0) {
                 for (var i = 0; i < $responseData.length; i++) {
                     $('#ddlRemarks').append('<option value="' + $responseData[i].ID + '">' + $responseData[i].Remarks + '</option>');
                 }
                 $('.chosen-container').css('width', '330px');
                 $("#ddlRemarks").trigger('chosen:updated');
             }
         }
         OnFailureRemarks = function () {

         }
         function bindRemarksText() {
             $('#ddlRemarks').val($('#callidremarks').val());
         }
         function SearchDetail(callBy, CallByID, MobileNo) {
             var searchby = "";
             if (callBy == "Patient") {
                 searchby = MobileNo;
             }
             if (callBy == "Doctor") {
                 searchby = CallByID;
             }
             if (callBy == "PUP") {
                 searchby = CallByID;
             }
             if (callBy == "PCC") {
                 searchby = CallByID;
             }
             $('#divPatient,#divInvestigation,#divInvestigationLabNo,#divParamterLabNo').html('');
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             serverCall('DeltaCheckMobile.aspx/SearchDetail',
                 { SearchType: $('#ddlSearchType').val(), SearchValue: searchby, FromDate: $("#<%=txtFormDate.ClientID %>").val(), ToDate: $("#<%=txtToDate.ClientID %>").val(), CentreID: $("#<%=ddlCentreAccess.ClientID%>").val(), CallBy: callBy },
                 function (result) {
                     var $responseData = JSON.parse(result);
                     if ($responseData.status) {
                         PatientData = jQuery.parseJSON($responseData.patientDetails);
                         var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                         $('#divPatient').html(output);
                         // $("#tb_grdLabSearchs tr:not(#trHead):first").addClass('rowColor');

                         PatientData = jQuery.parseJSON($responseData.labDetails);
                         var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                         $('#divInvestigation').html(output);

                         PatientData = jQuery.parseJSON($responseData.invDetails);
                         var output = $('#tb_SearchInvestigationLabNo').parseTemplate(PatientData);
                         $('#divInvestigationLabNo').html(output);

                         var $table = $("#tb_grdLabSearchs");
                         $table.delegate("tr.clickablerow", "click", function () {
                             $table.find("tr.clickablerow").removeClass('rowColor');
                             $(this).addClass('rowColor');
                         });
                     }
                     else {
                         toast("Error", $responseData.response);
                         $('#divInvestigation').html('');
                         $('#divInvestigationLabNo').html('');
                     }
                     $("#btnSearch").removeAttr('disabled').val('Search');
                     //$.unblockUI();
                 })

             }
             function SearchPatientDetail(PatientID, rowID) {
                 //jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             serverCall('DeltaCheckMobile.aspx/SearchPatientDetail',
                 { PatientID: PatientID },
                 function (result) {
                     var $responseData = JSON.parse(result);
                     if ($responseData.status) {
                         PatientData = jQuery.parseJSON($responseData.labDetails);
                         var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                         $('#divInvestigation').html(output);
                         PatientData = jQuery.parseJSON($responseData.invDetails);
                         var output = $('#tb_SearchInvestigationLabNo').parseTemplate(PatientData);
                         $('#divInvestigationLabNo').html(output);
                     }
                     else {
                         toast("Error", $responseData.response);
                         $('#divInvestigation').html('');
                         $('#divInvestigationLabNo').html('');
                     }
                     $("#btnSearch").removeAttr('disabled').val('Search');
                     //$.unblockUI();
                 })
         }
         function SearchPatientInvestigation(LabNo) {
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             serverCall('DeltaCheckMobile.aspx/SearchPatientInvestigation',
                 { LabNo: LabNo },
                 function (result) {
                     var $responseData = JSON.parse(result);
                     if ($responseData.status) {
                         PatientData = jQuery.parseJSON($responseData.invDetails);
                         var output = $('#tb_SearchInvestigationLabNo').parseTemplate(PatientData);
                         $('#divInvestigationLabNo').html(output);
                     }
                     else {
                         toast("Error", $responseData.response);

                         $('#divInvestigationLabNo').html('');
                     }
                     $("#btnSearch").removeAttr('disabled').val('Search');
                 })
         }


         function SearchDetailByCat() {
             var loc = window.location.toString(),
              params = loc.split('?')[1],
              params1 = loc.split('&')[1],
              params2 = loc.split('&')[2],
              params3 = params.split('&')[0],
              params4 = loc.split('&')[3].split("Name:")[1],
              iframe = document.getElementById('estimateiframe');
             if (params != undefined) {
                 if ((params1 == "Patient" || params1 == "Doctor" || params1 == "PUP" || params1 == "PCC") && $('#ddlSearchType').val() == "lt.LedgertransactionNo") {
                     SearchDetailVisit();
                 }
                 else {
                     SearchDetail1();
                 }
             }
         }
         function SearchDetailVisit() {
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             serverCall('DeltaCheckMobile.aspx/SearchPatientDetailVisitID',
                 { VisitID: $('#txtSearchValue').val(), fromdate: $('#<%=txtFormDate.ClientID%>').val(), todate: $('#<%=txtToDate.ClientID%>').val() },
                      function (result) {
                          PatientData = $.parseJSON(result);
                          if (PatientData == "-1") {
                              $("#btnSearch").removeAttr('disabled').val('Search');
                              toast("Error", 'Your Session Expired.... Please Login Again');
                              return;
                          }
                          if (PatientData.length == 0) {
                              $("#btnSearch").removeAttr('disabled').val('Search');
                              toast("Error", 'No Record Found');
                              $('#divInvestigation').html('');
                              return;
                          }
                          else {
                              var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                              $('#divInvestigation').html(output);
                              if (PatientData.length > 0) {
                                  SearchPatientInvestigation(PatientData[0].LabNo);
                              }
                              $("#btnSearch").removeAttr('disabled').val('Search');
                          }

                      })
                  }
                  function SearchDetail1() {
                      if ($('#ContentPlaceHolder1_txtSearchValue').val() == "") {
                          toast("Error", "plese enter search area");
                          return;
                      }
                      $('#divPatient').html('');
                      $('#divInvestigation').html('');
                      $('#divInvestigationLabNo').html('');
                      $('#divParamterLabNo').html('');
                      $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
                      serverCall('DeltaCheckMobile.aspx/SearchDetail1',
                          { SearchType: $("#ddlSearchType").val(), SearchValue: $("#<%=txtSearchValue.ClientID %>").val(), FromDate: $("#<%=txtFormDate.ClientID %>").val(), ToDate: $("#<%=txtToDate.ClientID %>").val(), CentreID: $("#<%=ddlCentreAccess.ClientID%>").val() },
                 function (result) {
                     PatientData = $.parseJSON(result);
                     if (PatientData == "-1") {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         toast("Error", 'Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         toast("Error", 'No Record Found');
                         $('#divPatient').html('');
                         return;
                     }
                     else {
                         var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                         $('#divPatient').html(output);
                         if (PatientData.length > 0)
                             SearchPatientDetail(PatientData[0].Mobile);
                         $("#btnSearch").removeAttr('disabled').val('Search');
                     }

                 })
             }


             function SearchPatientParamterDetail(LabNo) {
                 $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
                 serverCall('DeltaCheckMobile.aspx/SearchPatientParamterDetail',
                     { LabNo: LabNo },
                     function (result) {
                         PatientData = $.parseJSON(result);
                         if (PatientData == "-1") {
                             $("#btnSearch").removeAttr('disabled').val('Search');
                             toast("Error", 'Your Session Expired.... Please Login Again');
                             return;
                         }
                         if (PatientData.length == 0) {
                             $("#btnSearch").removeAttr('disabled').val('Search');
                             toast("Error", 'No Record Found');
                             $('#SearchParamterLabNo').html('');
                             $('#divParamterLabNo').html('');
                             return;
                         }
                         else {
                             var blamt = $('#blamt_' + LabNo).text();
                             if (blamt == '0') {
                                 var output = $('#tb_SearchParamterLabNo').parseTemplate(PatientData);
                                 $('#divParamterLabNo').html(output);
                             }
                             $("#btnSearch").removeAttr('disabled').val('Search');
                         }
                     })
             }
             function showlength() {
                 if ($('#<%=txtSearchValue.ClientID%>').val() != "") {
                 $('#lblValueLength').html($('#<%=txtSearchValue.ClientID%>').val().length);
             }
             else {
                 $('#lblValueLength').html('');
             }
         }

         function HideDialog() {
             $("#overlay").hide();
             $("#dialog").fadeOut(300);
         }
         function OpneSavePOpup() {
             $("#spnClosingRemarksError").text('');
             $("#overlay1").show();
             $("#dialog1").fadeIn(500);

         }

</script>
          <script type="text/javascript">


              SendEmail = function (btn) {
                  var LabNo = $(btn).closest('tr').find('#tdLabNo').text().trim();
                  if ($.trim($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text()) == "0" & $(btn).closest('tr').find('#tdIsApproved').text().trim() != "No") {
                      //jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
                 LabReportPopOP('Email', LabNo, $(btn).closest('tr').find('#tdLedgerTransactionID').text().trim(), $(btn).closest('tr').find('#tdEmail').text().trim(), $(btn).closest('tr').find('#tdMobileNo').text().trim());
             }
             if ($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text().trim() != '0') {
                 toast("Error", "Amount is due");
                 return;
             }
             if ($(btn).closest('tr').find('#tdIsApproved').text().trim() == "No") {
                 toast("Error", "Report not approved");
                 return;
             }
         }
         function SendEmail(btnl) {

             if (typeof (btnl) == "object") {
                 var emailto = $(btnl).closest('tr').find('td:eq(6)').text().trim();
                 var amtdue = $(btnl).closest('tr').find('td:eq(4)').text().trim();
                 var labnumber = $(btnl).closest('tr').find('td:eq(3)').text().trim();
                 if ($(btnl).closest('tr').find('td:eq(4)').text().trim() == '0' & $(btnl).closest('tr').find('td:eq(10)').text().trim() != "No") {
                     $('#<%=txtVisitNo.ClientID%>').val(labnumber);
                     $('#<%=txtEmailID.ClientID%>').val(emailto);
                     $('#<%=txtCc.ClientID%>,#<%=txtBcc.ClientID%>').val('');
                     $('#btnSend').attr('value', 'Send');
                     $('#btnSend').removeAttr('disabled');
                     $('#tblEmailStatus tr').slice(1).remove();
                     serverCall('DeltaCheckMobile.aspx/EmailStatusData',
                         { VisitNo: $('#<%=txtVisitNo.ClientID%>').val() },
                         function (result) {
                             EmailStatusData = jQuery.parseJSON(result);
                             if (EmailStatusData.length == 0) {
                                 $('#divEmailStatus').hide();
                             }
                             else {
                                 for (var i = 0; i <= EmailStatusData.length - 1; i++) {
                                     var $mydata = [];
                                     $mydata.push("<tr>");
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push((i + 1)); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].LedgerTransactionNo); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].PName); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].MailType); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].IsSend); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].EmailID); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].Cc); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].Bcc); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].UserName); $mydata.push('</td>');
                                     $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(EmailStatusData[i].dtEntry); $mydata.push('</td>');
                                     $mydata.push("</tr>");
                                     $mydata = $mydata.join("");
                                     $('#tblEmailStatus').append($mydata);
                                 }
                                 $('#divEmailStatus').show();
                             }

                         })
                     ShowDialog(true, '');
                     }
                     else {
                         toast("Error", "You have due amount/not approved");
                     }
                 }
             }
             function SendFinalMail() {
                 $("#btnSend").attr('disabled', true).val("Sending...");
                 serverCall('../CallCenter/Services/OldPatientData.asmx/sendEmail',
                     { VisitNo: $('#<%=txtVisitNo.ClientID%>').val(), EmailID: $('#<%=txtEmailID.ClientID%>').val(), Cc: $('#<%=txtCc.ClientID%>').val(), Bcc: $('#<%=txtBcc.ClientID%>').val() },
                 function (result) {
                     $("#btnSend").attr('disabled', false).val("Send");
                     HideDialog();
                     if (result == '1') {
                         toast("Success", "Email Send successfully...!");
                         $('#<%=txtEmailID.ClientID%>,#<%=txtVisitNo.ClientID%>,#<%=txtCc.ClientID%>,#<%=txtBcc.ClientID%>').val('');
                     }
                     else {
                         toast("Error", "Some Error...!");
                     }
                 })
             }
             function SendSmsLabReport(btn) {
                 var LabNo = $(btn).closest('tr').find('#tdLabNo').text().trim();
                 if ($.trim($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text()) == "0" & $(btn).closest('tr').find('#tdIsApproved').text().trim() != "No") {
                     //jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
                 LabReportPopOP('TinySMS', LabNo, $(btn).closest('tr').find('#tdLedgerTransactionID').text().trim(), $(btn).closest('tr').find('#tdEmail').text().trim(), $(btn).closest('tr').find('#tdMobileNo').text().trim());
             }
             if ($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text().trim() != '0') {
                 toast("Error", "Amount is due");
                 return;
             }
             if ($(btn).closest('tr').find('#tdIsApproved').text().trim() == "No") {
                 toast("Error", "Report not approved");
                 return;
             }

         }

         function SendWhatsAppLabReport(btn) {
             var LabNo = $(btn).closest('tr').find('#tdLabNo').text().trim();
             if ($.trim($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text()) == "0" & $(btn).closest('tr').find('#tdIsApproved').text().trim() != "No") {
                 //jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
                      LabReportPopOP('WhatsApp', LabNo, $(btn).closest('tr').find('#tdLedgerTransactionID').text().trim(), $(btn).closest('tr').find('#tdEmail').text().trim(), $(btn).closest('tr').find('#tdMobileNo').text().trim());
                  }
                  if ($(btn).closest('tr').find("".concat("#blamt_", LabNo)).text().trim() != '0') {
                      toast("Error", "Amount is due");
                      return;
                  }
                  if ($(btn).closest('tr').find('#tdIsApproved').text().trim() == "No") {
                      toast("Error", "Report not approved");
                      return;
                  }
              }

              function call() {
                  if ($('#hd').prop('checked') == true) {
                      $('#Table1 tr').each(function () {
                          var id = $(this).closest("tr").attr("id");
                          $('.mmc').prop('checked', true);
                      });
                  }
                  else {
                      $('.mmc').prop('checked', false);
                  }
              }
              function printAll() {
                  var testid = "";
                  var id = "";
                  var id1 = "";
                  $('#Table1 tr').each(function () {
                      id = $(this).closest("tr").attr("id");
                      id1 = $(this).find('.mmc').val();
                      if (id != "header") {
                          if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                              testid += id1 + ",";
                              $(this).closest("tr").css('background-color', '#00FFFF');
                          }
                      }
                  });

                  if (testid == "") {
                      toast("Error", "Please Select Test To Print");
                      return;
                  }
                  else {
                      window.open("../Lab/labreportnew.aspx?testid=" + testid);
                  }
              }
              $("#btnClose").click(function (e) {
                  HideDialog();
                  e.preventDefault();
              });
              function HideDialog() {
                  $("#overlay").hide();
                  $("#dialog").fadeOut(300);
              }
              function ShowDialog(modal, Type) {
                  $("#tblEmailSend").show();
                  $("#overlay").show();
                  $("#dialog").fadeIn(300);
                  if (modal) {
                      $("#overlay").unbind("click");
                  }
                  else {
                      $("#overlay").click(function (e) {
                          HideDialog();
                      });
                  }
              }
              function changetext() {
                  $('#ContentPlaceHolder1_txtSearchValue').val('');
              }


              function SaveReportCallLog() {
                  var MobileNo = $('#Patientmobile').text();
                  var radioselect = $('input[name=callcenterRadio]:checked').val();
                  var callBy = "";
                  if ($('#ddlRemarks').val() == "0") {
                      $('#spnClosingRemarksError').text('Please Select Closing Remarks');
                      $('#ddlRemarks').focus();
                      return;
                  }
                  if (radioselect == "0") {
                      callBy = "Patient";
                  }
                  if (radioselect == "1") {
                      callBy = "Doctor";
                  }
                  if (radioselect == "2") {
                      callBy = "PUP";
                  }
                  if (radioselect == "3") {
                      callBy = "PCC";
                  }
                  var CallByID = $("#oldptId").text();
                  var CallType = "LabReport";

                  $("#btnReportCallLog").attr('disabled', 'disabled').val("Submiting...");
                  serverCall('DeltaCheckMobile.aspx/SaveNewLabReportLog',
                      ///was stringified
                      { MobileNo: MobileNo, CallBy: callBy, CallByID: CallByID, CallType: CallType, Remarks: $('#ddlRemarks option:selected').text(), RemarksID: $('#ddlRemarks').val() },
                      function (result) {
                          var $responseData = JSON.parse(result);
                          $("#overlay1").hide();
                          $("#dialog1").fadeOut(300);
                          $('#ddlRemarks').prop('selectedIndex', 0);
                          $("#ddlRemarks").trigger('chosen:updated');
                          $('#btnReportCallLog').removeAttr('disabled').val("Save");

                          toast("Success", $responseData.response);
                      })
              }
              closeCallLog = function () {
                  $("#overlay1").hide();
                  $("#dialog1").fadeOut(300);
                  $('#ddlRemarks').prop('selectedIndex', 0);
                  $("#ddlRemarks").trigger('chosen:updated');

              }
          </script>
     <script id="tb_PatientLabSearch" type="text/html"  >
        <table class="GridViewStyle"    id="tb_grdLabSearchs"  style="border-collapse:collapse; width:100%;">   
		<tr id="trHead">  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Details</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">Paramter Detail</th>
</tr>
<#
 var dataLength=PatientData.length;
 var objRow;        
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];        
            #>
<tr id="tr_<#=objRow.Patient_ID#>" class='clickablerow' style="background-color:<#=objRow.rowColor#>"> 
<td class="GridViewLabItemStyle"><#=j+1#></td>    
<td class="GridViewLabItemStyle"><#=objRow.PName#></td>  
<td class="GridViewLabItemStyle"><#=objRow.Patient_ID#></td> 
<td class="GridViewLabItemStyle" style="text-align:center"> 
    <a href="javascript:void(0);" id="click_<#=j+1#>" onclick="SearchPatientDetail('<#=objRow.Patient_ID#>',this);">
        <img id="imgSelect" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a> 
</td>
    <td class="GridViewLabItemStyle" style="text-align: center;display:none;">
        <a target="_blank"  href='DeltaCheckMobileReport.aspx?Mobile=<#=objRow.Mobile#>' >
            <img id="imgPrintReport" src="../../App_Images/print.gif" style="cursor:pointer;" alt="Print Record"/>
            </a></td>

   
</tr> 
 <#}#>
</table>    
    </script>
      <script id="tb_SearchInvestigation" type="text/html"  >
        <table class="GridViewStyle"  id="tb_SearchInvestigations" style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Reg.Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">LabNo.</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Bal.Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Detail</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Email</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Sms</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">WhatsApp</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Receipt</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Ticket</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">Paramter Detail</th> 
</tr>
<#       
 var dataLength=PatientData.length;
 var objRow;         
        for(var j=0;j<dataLength;j++)
        { 
        objRow = PatientData[j];  
            #>
<tr id="tr1" style="background-color:<#=objRow.rowColor#>;"> 
<td class="GridViewLabItemStyle"><#=j+1#></td> 
<td class="GridViewLabItemStyle"><#=objRow.Centre#></td>   
<td class="GridViewLabItemStyle" id="tdMobileNo"><#=objRow.Mobile#></td> 
<td class="GridViewLabItemStyle"><#=objRow.RegDate#></td>
<td class="GridViewLabItemStyle" id="tdLabNo"><#=objRow.LabNo#></td> 
<td class="GridViewLabItemStyle" style="display:none" id="tdEmail"><#=objRow.Email#></td>
    <td class="GridViewLabItemStyle" style="display:none" id="tdLedgerTransactionID"><#=objRow.LedgerTransactionID#></td>
<%--<td class="GridViewLabItemStyle"><#=objRow.PName#></td> --%>
<td class="GridViewLabItemStyle"  style="text-align:right;<#if(objRow.BalAmount !='0') {#>background-color:red;"><#} else {#>"> <#} #>
<#=objRow.BalAmount#></td>
     <td  style="display:none;" id="blamt_<#=objRow.LabNo#>"><#=objRow.BalAmount#></td>    
    <td class="GridViewLabItemStyle" style="text-align:center"> 
    <a href="javascript:void(0);" id="A1" onclick="SearchPatientInvestigation('<#=objRow.LabNo#>');">
        <img id="img1" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a> 
</td>
        <td class="GridViewLabItemStyle" style="text-align:center">           
            <a href="javascript:void(0);" onclick="SendEmail(this)" id="A3">
        <img id="img3" src="../../App_Images/EmailICON.png" style="cursor:pointer;width:20px;height:20px;" alt=""/>
    </a>
        </td>
        <td class="GridViewLabItemStyle" style="text-align:center">
            <a href="javascript:void(0);" id="A4" onclick="SendSmsLabReport(this);">
        <img id="img4" src="../../App_Images/sms.ico" style="cursor:pointer;width:20px;height:20px;" alt=""/>
    </a>
        </td>
     <td class="GridViewLabItemStyle" style="text-align:center">
            <a href="javascript:void(0);" id="A5" onclick="SendWhatsAppLabReport(this);">
        <img id="img2" src="../../App_Images/whatsapp.png" style="cursor:pointer;width:20px;height:20px;" alt=""/>
    </a>
        </td>

       <td class="GridViewLabItemStyle" style="text-align:center">
             <%--<a target="_blank"  href='../Lab/PatientReceipt.aspx?LabID=<#=objRow.LedgerTransactionID#>' >--%>
           <a href="javascript:void(0);" id="A6" onclick="SendReceipt(this);" >
            <img src="../../App_Images/folder.gif" style="cursor:pointer;text-align:center" alt=""/>
           </a>
    </td>
      <td class="GridViewLabItemStyle" style="text-align:center">
           <a href="javascript:void(0);" id="A2" onclick="openTicket(this);" >
            <img  src="../../App_Images/comment.png" style="cursor:pointer;text-align:center;height:20px" alt=""/>
           </a>
          </td>
    <td  style="display:none;" id="tdIsApproved"><#=objRow.Approved#></td>
</tr> 
 <#}#>
</table>    
    </script>
      <script id="tb_SearchInvestigationLabNo" type="text/html"  >
        <table class="GridViewStyle"  id="Table1" style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">LabNo.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">BarcodeNo.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Investigation</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Approved</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;"> 
            <input type="checkbox" id="hd" onclick="call()" class="mmc1" /><a target="_blank" >
            <img id="img5" src="../../App_Images/print.gif" onclick="printAll();" style="cursor:pointer;" alt="Print Record"/>
            </a>
            </th>
</tr>
<#       
 var dataLength=PatientData.length;
 var objRow;        
        for(var j=0;j<dataLength;j++)
        { 
        objRow = PatientData[j];  
            #>
<tr id="tr2" style="background-color:<#=objRow.rowColor#>;"> 
<td class="GridViewLabItemStyle"><#=j+1#></td>    
<td class="GridViewLabItemStyle"><#=objRow.LedgerTransactionNo#></td>  
<td class="GridViewLabItemStyle"><#=objRow.BarcodeNo#></td>
<td class="GridViewLabItemStyle"><#=objRow.Investigation#></td> 
<td class="GridViewLabItemStyle"><#=objRow.Approved#></td> 
<td class="GridViewLabItemStyle" style="text-align:center;">
         <# if(objRow.Approved=="Yes") { #>
    <span class="printcheck">
            <input type="checkbox" id="mmchk" value="<#=objRow.Test_ID#>" class="mmc" />
      <a target="_blank"  href='../lab/labreportnew.aspx?testid=<#=objRow.Test_ID#>,' >
            <img id="img6" src="../../App_Images/print.gif" style="cursor:pointer;" alt="Print Record"/>
            </a>
      <#}#>
     </span>
</td>
      </tr>
 <#}#>
</table>    
    </script>
       <script id="tb_SearchParamterLabNo" type="text/html"  >
        <table id="SearchParamterLabNo" class="GridViewStyle" cellspacing="0"  id="Table2" style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">Investigation</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">ParamterName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">Reading</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">Min Value</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">Max Value</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:auto;">Unit</th> 
</tr>
<#
 var dataLength=PatientData.length;
 var objRow; 
        
        for(var j=0;j<dataLength;j++)
        { 
        objRow = PatientData[j];  
            #>
<tr id="tr3" style="background-color:white;"> 
<td class="GridViewLabItemStyle"><#=j+1#></td>
<# if(j>0) {  if(PatientData[j].Investigation!=PatientData[j-1].Investigation)  {  #> 
<td class="GridViewLabItemStyle" style="font-family:Calibri;font-weight:bold;"><#=objRow.Investigation#></td> 
<#    }    else    {    #>
<td class="GridViewLabItemStyle">&nbsp;</td> 
<# } } else {  #> 
<td class="GridViewLabItemStyle" style="font-family:Calibri;font-weight:bold;"><#=objRow.Investigation#></td> 
<# }    if(objRow.Reading =='HEAD') { #> 
<td class="GridViewLabItemStyle" style="font-family:Calibri;text-decoration:underline;" colspan="5"><#=objRow.ParamterName#></td> 
    <#} else {#>
<td class="GridViewLabItemStyle" style="font-family:Calibri;"><#=objRow.ParamterName#></td>
<td class="GridViewLabItemStyle"><#=objRow.Reading#></td>  
<td class="GridViewLabItemStyle"><#=objRow.MinValue#></td> 
<td class="GridViewLabItemStyle"><#=objRow.MaxValue#></td>  
<td class="GridViewLabItemStyle"><#=objRow.Unit#></td>   
      <#}#>
</tr> 
 <#}#>
</table>    
    </script>
          <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position:absolute;right:-20px;top:-20px;width:36px;height:36px;cursor:pointer;" title="Close"  alt=""/>            
            <div class="POuter_Box_Inventory">
                 <div class="Purchaseheader" style="text-align:center" >
             <span id="notifyhead"></span>
                     </div>
                <table style="width:99%;border-collapse:collapse;display:none"  class="PatientReport">
                    <tr>
                        <td colspan="4" style="text-align:center">
                            <span id="spnErrorLabReport" class="ItDoseLblError" ></span>
                        </td>
                    </tr>
                         <tr><td style="text-align:center;width:60%" >
                         <span id="sphead" style="font-weight:bold;"></span> : <input type="text" id="txtLabReport" style="width:190px"  autocomplete="off" />
                             <input type="button" id="btnSendMail" class="searchbutton" onclick="sendReportMail()" />
                             <input type="button" id="btnSendSMS" class="searchbutton" onclick="sendReportSMS()" />
                             <input type="button" id="btnSendWhatsAPP" class="searchbutton" onclick="sendReportWhatsApp()" />
                              
                             <span id="spnVisitNo" style="display:none"></span>
                             <span id="spnVisitID" style="display:none"></span>
                             <span id="spnOTPResponse" style="display:none"></span>
                            </td>
                             <td style="text-align:right;width:10%">
                                 <span id="spnLabreportOTP" style="display:none;font-weight:bold;" >OTP :&nbsp;</span>
                             </td>
                              <td style="text-align:left;width:14%">
                                  <asp:TextBox ID="txtLabReportOTP" runat="server" MaxLength="6" style="display:none" Width="80px" AutoCompleteType="Disabled"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbLabReportOTP" runat="server" TargetControlID="txtLabReportOTP" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>

                             </td>
                             <td style="text-align:left;width:16%">
                                 &nbsp;<input type="button" id="btnCreateOTP" value="Send OTP" class="searchbutton" style="display:none" onclick="sendLabReportOTP()" />
                                  &nbsp;<input type="button" id="btnResendOTP" value="ReSend OTP" class="searchbutton" style="display:none" onclick="reSendLabReportOTP()" />
                             </td>
                            
               </tr>
                    <tr>
                        <td colspan="4" style="text-align:left">
                            <div class="Purchaseheader">
                Details &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total Records :&nbsp;<span id="spnTotalRecords" class="ItDoseLblError"></span>
            </div>
                        </td>
                    </tr>
                        
                     </table>
                    <table style="width:99%;border-collapse:collapse;display:none"  id="tblsendnotification" class="GridViewStyle PatientReportMail">
                         <thead>
                    <tr id="tr4">
                        <%--<th class="GridViewHeaderStyle" style="width:30px" >S.No.</th>     --%>                  
                        <th class="GridViewHeaderStyle" style="width:70px">Mail Type</th>
                        <th class="GridViewHeaderStyle" style="width: 50px;">Status</th>
                        <th class="GridViewHeaderStyle" style="width: 300px;">Mailed To</th>
                        <th class="GridViewHeaderStyle" style="width: 300px;">Send By</th>
                        <th class="GridViewHeaderStyle" style="width: 200px;">Sent Date</th>
                        </tr>
                              </thead>
							<tbody></tbody>
                        </table>
                <table style="width:50%;border-collapse:collapse;display:none"  id="tblLabReportSMS" class="GridViewStyle PatientReportSMS">
                    <thead>
                    <tr id="tr5">
                        <%--<th class="GridViewHeaderStyle" style="width:30px" >S.No.</th> --%>
                        <th class="GridViewHeaderStyle" style="width: 100px;">Mobile No.</th>                      
                        <th class="GridViewHeaderStyle" style="width: 50px;">Status</th>
                        <th class="GridViewHeaderStyle" style="width: 160px;">Sent Date</th>
                        </tr>
                        </thead>
							<tbody></tbody>
                        </table>
                <table style="width:99%;border-collapse:collapse;display:none;text-align:center"  id="tblReceipt" class="GridViewStyle">
                    <tr>
                        <td colspan="8" style="text-align:center">
                            <span id="spnReceiptError" class="ItDoseLblError" ></span>
                        </td>
                    </tr>
                    <tr  style="text-align:center">
                        <td style="width:12%;text-align:right">
                            MobileNo :&nbsp;
                        </td>
                        <td style="width:12%;text-align:right">
                          <asp:TextBox ID="txtReceiptMobileNo" runat="server" MaxLength="10" ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbReceiptMobileNo" runat="server" TargetControlID="txtReceiptMobileNo" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align:left;width:16%;">
                       &nbsp;&nbsp;<input type="button" id="btnSMSReceipt" value="Receipt SMS" class="searchbutton" onclick="SMSReceipt()"/>
                            
                        </td>
                        <td>
                            <input type="button" id="btnWhatsAppReceipt" value="Receipt WhatsAPP" class="searchbutton" onclick="WhatsAppReceipt()"/>
                      
                        </td>
                        <td style="width:8%;text-align:right">
                            <span id="spnReceiptOTP" style="display:none;font-weight:bold;" >OTP :&nbsp;</span>
                            </td>
                        <td style="width:16%;text-align:right">
                            <asp:TextBox ID="txtReceiptOTP" runat="server" MaxLength="6" style="display:none" Width="100px" AutoCompleteType="Disabled"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbReceiptOTP" runat="server" TargetControlID="txtReceiptOTP" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align:right;width:16%;">
                            &nbsp;<input type="button" style="display:none" id="btnSMSReceiptOTP" value="Send OTP" class="searchbutton" onclick="SMSReceiptOTP()"/>
                            
                        </td>
                        
                        <td style="text-align:left;width:20%;"> 
                            <input type="button" style="display:none" id="btnSMSReceiptOTPResend" value="ReSend OTP" class="searchbutton" onclick="SMSReceiptOTPResend()"/>
                        </td>
                        </tr>
                     <tr  style="text-align:center">
                        <td style="width:12%;text-align:right">
                            Email  :&nbsp;
                        </td>
                        <td style="width:12%;text-align:right">
                             <asp:TextBox ID="txtReceiptEmail" runat="server" MaxLength="100" ></asp:TextBox>
                        </td>
                        <td style="text-align:left">
                             &nbsp;&nbsp;<input type="button" id="btnEmailReceipt" value="Receipt Email" class="searchbutton" onclick="EmailReceipt()"/>
                        </td>
                          <td colspan="4">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" id="tdReceiptDetail">
                             <div class="Purchaseheader">
                Bill SMS/WhatsApp Detail &nbsp;&nbsp;Total Records :&nbsp;<span id="spnReceiptSMSTotalData" class="ItDoseLblError"></span>
                                 </div>
                            <div style="overflow: scroll; display: none; height: 120px;" id="divReceiptDetail">
                    <table style="width: 100%; border: 0px;"  id="tblReceiptDetail" class="GridViewStyle">
                        <thead>
                        <tr>
                            <%--<th class="GridViewHeaderStyle" style="width: 30px;">S.No.</th>--%>
                            <th class="GridViewHeaderStyle" style="width: 100px;">Mobile No.</th>                          
                            <th class="GridViewHeaderStyle" style="width: 50px;">Status</th>                           
                            <th class="GridViewHeaderStyle" style="width: 200px;">Sent Date</th>
                             <th class="GridViewHeaderStyle">Type</th>
                        </tr>
                            </thead>
							<tbody></tbody>
                    </table>
                </div>
                        </td>
                        <td colspan="4" id="tdLabReportDetail">
                            <div class="Purchaseheader">
                 Bill Email Detail&nbsp;&nbsp;Total Records :&nbsp;<span id="spnReceiptEmailTotalData" class="ItDoseLblError"></span>
                                 </div>
                            <div style="overflow: scroll; display: none; height: 120px;" id="divLabReportDetail">
                    <table style="width: 100%; border: 0px;"  id="tblLabReportDetail" class="GridViewStyle">
                        <thead>
                        <tr>
                           <%-- <th class="GridViewHeaderStyle" style="width: 30px;">S.No.</th>--%>
                            <th class="GridViewHeaderStyle" style="width: 100px;">Email</th>                          
                            <th class="GridViewHeaderStyle" style="width: 50px;">Status</th>                           
                            <th class="GridViewHeaderStyle" style="width: 200px;">Sent Date</th>
                        </tr>
                            </thead>
							<tbody></tbody>
                    </table>
                </div>
                        </td>
                    </tr>
                        </table>  
                

                 <table style="width:50%;border-collapse:collapse;display:none"  id="tblLabReportWhatsApp" class="GridViewStyle PatientReportSMS">
                    <thead>
                    <tr id="tr6">
                        <%--<th class="GridViewHeaderStyle" style="width:30px" >S.No.</th> --%>
                        <th class="GridViewHeaderStyle" style="width: 100px;">Mobile No.</th>                      
                        <th class="GridViewHeaderStyle" style="width: 50px;">Status</th>
                        <th class="GridViewHeaderStyle" style="width: 160px;">Sent Date</th>
                        </tr>
                        </thead>
							<tbody></tbody>
                        </table>

                
                
                                  
            </div>
        </div>
          <script type="text/javascript">
              reSendLabReportOTP = function () {
                  jQuery('#btnResendOTP').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.ReSendOTP(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), "LabReport", jQuery.trim(jQuery('#spnVisitID').text()), jQuery.trim(jQuery('#spnOTPResponse').text()), onSuccessLabReportResendOTP, OnFailureEmailSend);
              }
              onSuccessLabReportResendOTP = function (result) {
                  var $responseData = JSON.parse(result);
                  jQuery('#spnErrorLabReport').text($responseData.response);
                  if ($responseData.status) {

                  }
                  else {

                  }
                  if ($responseData.IsShow == 1) {
                      jQuery('#btnResendOTP,#txtLabReportOTP,#spnLabreportOTP').hide();
                      jQuery('#btnCreateOTP').show();
                      jQuery('#txtLabReportOTP').val('');
                  }
                  else {
                      jQuery('#btnResendOTP').show();
                      jQuery('#btnCreateOTP').hide();
                  }
                  jQuery('#btnResendOTP').removeAttr('disabled').val('ReSend OTP');
              }
              sendLabReportOTP = function () {
                  jQuery('#btnCreateOTP').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.SendOTP(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), "LabReport", jQuery.trim(jQuery('#spnVisitID').text()), onSuccessLabReportOTP, OnFailureEmailSend);
              }
              onSuccessLabReportOTP = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery('#spnOTPResponse').text($responseData.responseDetail);
                      jQuery('#spnErrorLabReport').text($responseData.response);
                      jQuery('#txtLabReportOTP,#btnResendOTP,#spnLabreportOTP').show();
                      jQuery('#btnCreateOTP').hide();
                  }
                  else {
                      jQuery('#btnCreateOTP').show();
                      jQuery('#btnResendOTP').hide();
                      jQuery('#spnErrorLabReport').text($responseData.response);
                  }
                  jQuery('#btnCreateOTP').removeAttr('disabled').val('Send OTP');
              }
              SMSReceipt = function () {
                  if (jQuery.trim(jQuery('#txtReceiptMobileNo').val()) == "") {
                      jQuery('#spnReceiptError').text('Please Enter Mobile No.');
                      jQuery('#txtReceiptMobileNo').focus();
                      return;
                  }
                  if (jQuery('#txtReceiptMobileNo').val().length < 10) {
                      jQuery('#spnReceiptError').text('Please Enter Valid Mobile No.');
                      jQuery('#txtReceiptMobileNo').focus();
                      return;
                  }
                  jQuery('#btnSMSReceipt').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.SendSMSReceipt(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), jQuery.trim(jQuery('#spnVisitID').text()), jQuery('#txtReceiptOTP').val(), jQuery('#spnOTPResponse').text(), onSuccessSMSReceipt, OnFailureEmailSend);
              }

              WhatsAppReceipt = function () {

                  if (jQuery.trim(jQuery('#txtReceiptMobileNo').val()) == "") {
                      jQuery('#spnReceiptError').text('Please Enter Mobile No.');
                      jQuery('#txtReceiptMobileNo').focus();
                      return;
                  }
                  if (jQuery('#txtReceiptMobileNo').val().length < 10) {
                      jQuery('#spnReceiptError').text('Please Enter Valid Mobile No.');
                      jQuery('#txtReceiptMobileNo').focus();
                      return;
                  }
                  jQuery('#btnWhatsAppReceipt').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.SendWhatsAppReceipt(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), jQuery.trim(jQuery('#spnVisitID').text()), jQuery('#txtReceiptOTP').val(), jQuery('#spnOTPResponse').text(), onSuccessWhatsAppReceipt, OnFailureEmailSend);
              }
              onSuccessSMSReceipt = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery('#spnReceiptError').text($responseData.response);
                      var $myData = [];
                      $myData.push("<tr >");
                      //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("tblReceiptDetail tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.MobileNo); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push('Sent'); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.responseDetail); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push("SMS"); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblReceiptDetail tbody').prepend($myData);

                  }
                  else {
                      jQuery('#spnReceiptError').text($responseData.response);
                      jQuery('#btnSMSReceiptOTP').show();
                  }
                  jQuery('#spnReceiptSMSTotalData').text(jQuery("#tblReceiptDetail tbody tr").length);
                  jQuery('#btnSMSReceipt').removeAttr('disabled').val('Receipt SMS');
              }

              onSuccessWhatsAppReceipt = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery('#spnReceiptError').text($responseData.response);
                      var $myData = [];
                      $myData.push("<tr >");
                      //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("tblReceiptDetail tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.MobileNo); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push('Sent'); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.responseDetail); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push("WhatsApp"); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblReceiptDetail tbody').prepend($myData);

                  }
                  else {
                      jQuery('#spnReceiptError').text($responseData.response);
                      jQuery('#btnSMSReceiptOTP').show();
                  }
                  jQuery('#spnReceiptSMSTotalData').text(jQuery("#tblReceiptDetail tbody tr").length);
                  jQuery('#btnWhatsAppReceipt').removeAttr('disabled').val('Receipt WhatsApp');
              }



              EmailReceipt = function () {
                  if (jQuery.trim(jQuery('#txtReceiptEmail').val()) == "") {
                      jQuery('#spnReceiptError').text('Please Enter Email ID');
                      jQuery('#txtReceiptEmail').focus();
                      return;
                  }
                  jQuery('#btnEmailReceipt').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.EmailReceipt(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptEmail').val()), "HCBill", jQuery.trim(jQuery('#spnVisitID').text()), onSuccessEmailReceipt, OnFailureEmailSend, jQuery.trim(jQuery('#txtReceiptEmail').val()));
              }
              onSuccessEmailReceipt = function (result, Email) {
                  var $responseData = JSON.parse(result);
                  jQuery('#spnReceiptError').text($responseData.response);
                  if ($responseData.status) {
                      var $myData = [];
                      $myData.push("<tr >");
                      //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("tblLabReportDetail tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(Email); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push('Sent'); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.responseDetail); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblLabReportDetail tbody').prepend($myData);
                      jQuery('#spnReceiptEmailTotalData').text(jQuery('#tblLabReportDetail tbody tr').length);
                  }
                  jQuery('#btnEmailReceipt').removeAttr('disabled').val('Receipt Email');
              }
              SMSReceiptOTP = function () {
                  jQuery('#btnSMSReceiptOTP').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.SendOTP(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), "Receipt", jQuery.trim(jQuery('#spnVisitID').text()), onSuccessSMSReceiptOTP, OnFailureEmailSend);
              }
              onSuccessSMSReceiptOTP = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery('#spnOTPResponse').text($responseData.responseDetail);
                      jQuery('#spnReceiptError').text($responseData.response);
                      jQuery('#txtReceiptOTP,#spnReceiptOTP,#btnSMSReceiptOTPResend').show();
                      jQuery('#btnSMSReceiptOTP').hide();
                  }
                  else {
                      jQuery('#btnSMSReceiptOTP').show();
                      jQuery('#btnSMSReceiptOTPResend').hide();
                      jQuery('#spnReceiptError').text($responseData.response);
                  }
                  jQuery('#btnSMSReceiptOTP').removeAttr('disabled').val('Send OTP');
              }
              SMSReceiptOTPResend = function () {
                  jQuery('#btnSMSReceiptOTPResend').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.ReSendOTP(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtReceiptMobileNo').val()), "Receipt", jQuery.trim(jQuery('#spnVisitID').text()), jQuery.trim(jQuery('#spnOTPResponse').text()), onSuccessReceiptResendOTP, OnFailureEmailSend);
              }
              onSuccessReceiptResendOTP = function (result) {
                  jQuery('#spnReceiptError').text('');
                  var $responseData = JSON.parse(result);
                  jQuery('#spnReceiptError').text($responseData.response);
                  if ($responseData.status) {

                  }
                  else {
                      jQuery('#spnReceiptError').text($responseData.response);
                  }
                  if ($responseData.IsShow == 1) {
                      jQuery('#btnSMSReceiptOTPResend,#spnReceiptOTP,#txtReceiptOTP').hide();
                      jQuery('#btnSMSReceiptOTP').show();
                      jQuery('#txtReceiptOTP').val('');
                  }
                  else {
                      jQuery('#btnSMSReceiptOTPResend').show();
                      jQuery('#btnSMSReceiptOTP').hide();
                  }
                  jQuery('#btnSMSReceiptOTPResend').removeAttr('disabled').val('ReSend OTP');
              }
              SendReceipt = function (btn) {
                  var LabNo = jQuery(btn).closest('tr').find('#tdLabNo').text().trim();
                  var MobileNo = jQuery(btn).closest('tr').find('#tdMobileNo').text().trim();
                  var Email = jQuery(btn).closest('tr').find('#tdEmail').text().trim();
                  jQuery('#tblsendnotification tr').slice(1).remove();
                  jQuery('#spnTotalRecords').text('0');
                  jQuery('#spnReceiptError').text('');
                  jQuery('#tblReceipt').show();
                  jQuery('.PatientReport,#btnSMSReceiptOTP,#txtReceiptOTP,.PatientReportSMS,.PatientReportMail,#tblLAbReportSMS,#tblLabReportWhatsApp,#spnReceiptOTP,#btnSMSReceiptOTP,#btnSMSReceiptOTPResend').hide();
                  jQuery('#txtReceiptOTP').val('');
                  //jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
                  jQuery('#notifyhead').html('Send Receipt');
                  jQuery('#popup_box1').fadeIn("slow");
                  jQuery("#Pbody_box_inventory").css({
                      "opacity": "0.5"
                  });
                  jQuery('#spnVisitNo').text(LabNo);
                  jQuery('#spnVisitID').text($(btn).closest('tr').find('#tdLedgerTransactionID').text().trim());
                  jQuery('#txtReceiptMobileNo').val(MobileNo);
                  jQuery('#txtReceiptEmail').val(Email);
                  // bindOldReceiptDetail();
                  // bindOldLabReportDetail();
                  bindOldReceiptReportDetail();
              }
              bindOldReceiptReportDetail = function () {
                  PageMethods.getSMSEmailDetail(jQuery.trim(jQuery('#spnVisitID').text()), jQuery.trim(jQuery('#spnVisitNo').text()), "HCBill", onSuccessReceiptReport, OnFailureEmailSend);
              }
              onSuccessReceiptReport = function (result) {
                  jQuery('#divLabReportDetail,#divReceiptDetail').show();
                  jQuery('#tblReceiptDetail  tr').slice(1).remove(); jQuery('#tblLabReportDetail  tr').slice(1).remove();
                  jQuery('#spnReceiptEmailTotalData,#spnReceiptSMSTotalData').text('0');
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      if ($responseData.SMSDetail != null) {
                          var ReceiptStatusData = jQuery.parseJSON($responseData.SMSDetail);
                          for (var i = 0; i <= ReceiptStatusData.length - 1; i++) {
                              var $myData = [];
                              $myData.push("<tr >");
                              // $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].Mobile_No); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].IsSend); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].dtEntry); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].type); $myData.push('</td>');
                              $myData.push("</tr>");
                              $myData = $myData.join("");
                              $('#tblReceiptDetail tbody').append($myData);
                          }

                      }
                      if ($responseData.EmailDetail != null) {
                          var LabReportStatusData = jQuery.parseJSON($responseData.EmailDetail);
                          for (var i = 0; i <= LabReportStatusData.length - 1; i++) {
                              var $myData = [];
                              $myData.push("<tr >");
                              //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].EmailID); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].IsSend); $myData.push('</td>');
                              $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].dtEntry); $myData.push('</td>');
                              $myData.push("</tr>");
                              $myData = $myData.join("");
                              $('#tblLabReportDetail tbody').append($myData);
                          }

                      }
                  }
                  jQuery('#spnReceiptSMSTotalData').text($("#tblReceiptDetail tbody tr").length);
                  jQuery('#spnReceiptEmailTotalData').text(jQuery('#tblLabReportDetail tbody tr').length);
                  //jQuery.unblockUI();
              }
              bindOldReceiptDetail = function () {
                  PageMethods.SMSStatusData(jQuery.trim(jQuery('#spnVisitID').text()), "HCBill", onSuccessReceipt, OnFailureEmailSend);
              }
              onSuccessReceipt = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      var ReceiptStatusData = jQuery.parseJSON($responseData.SMSDetail);
                      for (var i = 0; i <= ReceiptStatusData.length - 1; i++) {
                          var $myData = [];
                          $myData.push("<tr >");
                          // $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].Mobile_No); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].IsSend); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].dtEntry); $myData.push('</td>');
                          $myData.push("</tr>");
                          $myData = $myData.join("");
                          $('#tblReceiptDetail tbody').append($myData);
                      }
                      jQuery('#spnReceiptSMSTotalData').text(jQuery("#tblReceiptDetail tbody tr").length);
                  }
                  jQuery('#divReceiptDetail').show();
              }
              bindOldLabReportDetail = function () {
                  PageMethods.EmailStatusData(jQuery.trim(jQuery('#spnVisitNo').text()), "HCBill", onSuccessLabReport, OnFailureEmailSend);
              }
              onSuccessLabReport = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      var LabReportStatusData = jQuery.parseJSON($responseData.responseDetail);
                      for (var i = 0; i <= LabReportStatusData.length - 1; i++) {
                          var $myData = [];
                          $myData.push("<tr >");
                          //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].EmailID); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].IsSend); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(LabReportStatusData[i].dtEntry); $myData.push('</td>');
                          $myData.push("</tr>");
                          $myData = $myData.join("");
                          jQuery('#tblLabReportDetail tbody').append($myData);
                      }

                  }
                  jQuery('#spnReceiptEmailTotalData').text(jQuery('#tblLabReportDetail tbody tr').length);
                  jQuery('#divLabReportDetail').show();
              }
              sendReportMail = function () {
                  if (jQuery.trim(jQuery('#txtLabReport').val()) == "") {
                      jQuery('#spnErrorLabReport').text("Please Enter Email");
                      jQuery('#txtLabReport').focus();
                      return;
                  }
                  jQuery('#btnSendMail').attr('disabled', 'disabled').val('Submitting...');
                  PageMethods.sendReportMail(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtLabReport').val()), jQuery.trim(jQuery('#spnVisitID').text()), onSuccessEmailSend, OnFailureEmailSend);
              }
              onSuccessEmailSend = function (result) {
                  var $responseData = JSON.parse(result);
                  var Status = "";

                  jQuery('#spnErrorLabReport').text($responseData.response);
                  if ($responseData.status) {
                      if ($responseData.responseDetails == "1")
                          Status = "Send";
                      else
                          Status = "Failed";
                      var $myData = [];
                      $myData.push("<tr >");
                      // $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("#tblsendnotification tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push("Manual"); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(Status); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.EmailID); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.SendBy); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.sendDate); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblsendnotification tbody').prepend($myData);
                      jQuery('#spnTotalRecords').text($("#tblsendnotification tbody tr").length);
                  }
                  jQuery('#btnSendMail').removeAttr('disabled').val('Send Email');

              }
              OnFailureEmailSend = function () {
                  //jQuery.unblockUI();
              }
              sendReportSMS = function () {
                  if (jQuery.trim(jQuery('#txtLabReport').val()).length < 10) {
                      jQuery('#spnErrorLabReport').text('Please Enter Valid Mobile No.');
                      jQuery('#txtLabReport').focus();
                      return;
                  }
                  else {
                      jQuery('#btnSendSMS').attr('disabled', 'disabled').val('Submitting...');
                      PageMethods.sendReportSMS(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtLabReport').val()), jQuery.trim(jQuery('#txtLabReportOTP').val()), jQuery.trim(jQuery('#spnVisitID').text()), jQuery.trim(jQuery('#spnOTPResponse').text()), onSuccessSMSSend, OnFailureEmailSend, jQuery.trim(jQuery('#txtLabReport').val()));
                  }
              }
              onSuccessSMSSend = function (result, Mobile_No) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery("#spnErrorLabReport").text($responseData.response);
                      var $myData = [];
                      $myData.push("<tr >");
                      //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("#tblLabReportSMS tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(Mobile_No); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push('Sent'); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.responseDetails); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblLabReportSMS tbody').prepend($myData);
                      jQuery("#txtLabReportOTP").val('');
                      jQuery("#btnCreateOTP,#txtLabReportOTP,#btnResendOTP,#spnLabreportOTP").hide();
                      jQuery("#spnOTPResponse").text('');
                      jQuery("#spnTotalRecords").text($("#tblLabReportSMS tbody tr").length);
                  }
                  else {
                      jQuery("#spnErrorLabReport").text($responseData.response);
                      if ($responseData.isShow == "1") {
                          jQuery("#btnCreateOTP").show();
                          jQuery("#btnResendOTP,#txtLabReportOTP,#spnLabreportOTP").hide();
                          jQuery("#txtLabReportOTP").val('');
                      }
                      else {
                          jQuery("#btnCreateOTP").hide();
                      }
                  }
                  jQuery('#btnSendSMS').removeAttr('disabled').val('Send TinySMS')
              }


              sendReportWhatsApp = function () {
                  if (jQuery.trim(jQuery('#txtLabReport').val()).length < 10) {
                      jQuery('#spnErrorLabReport').text('Please Enter Valid Mobile No.');
                      jQuery('#txtLabReport').focus();
                      return;
                  }
                  else {
                      jQuery('#btnSendWhatsAPP').attr('disabled', 'disabled').val('Submitting...');
                      PageMethods.sendReportWhatsApp(jQuery.trim(jQuery('#spnVisitNo').text()), jQuery.trim(jQuery('#txtLabReport').val()), jQuery.trim(jQuery('#txtLabReportOTP').val()), jQuery.trim(jQuery('#spnVisitID').text()), jQuery.trim(jQuery('#spnOTPResponse').text()), onSuccessWhatsSend, OnFailureEmailSend, jQuery.trim(jQuery('#txtLabReport').val()));
                  }
              }
              onSuccessWhatsSend = function (result, Mobile_No) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      jQuery("#spnErrorLabReport").text($responseData.response);
                      var $myData = [];
                      $myData.push("<tr >");
                      //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($("#tblLabReportSMS tr").length + 1); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(Mobile_No); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push('Sent'); $myData.push('</td>');
                      $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData.responseDetails); $myData.push('</td>');
                      $myData.push("</tr>");
                      $myData = $myData.join("");
                      jQuery('#tblLabReportWhatsApp tbody').prepend($myData);
                      jQuery("#txtLabReportOTP").val('');
                      jQuery("#btnCreateOTP,#txtLabReportOTP,#btnResendOTP,#spnLabreportOTP").hide();
                      jQuery("#spnOTPResponse").text('');
                      jQuery("#spnTotalRecords").text($("#tblLabReportWhatsApp tbody tr").length);
                  }
                  else {
                      jQuery("#spnErrorLabReport").text($responseData.response);
                      if ($responseData.isShow == "1") {
                          jQuery("#btnCreateOTP").show();
                          jQuery("#btnResendOTP,#txtLabReportOTP,#spnLabreportOTP").hide();
                          jQuery("#txtLabReportOTP").val('');
                      }
                      else {
                          jQuery("#btnCreateOTP").hide();
                      }
                  }
                  jQuery('#btnSendWhatsAPP').removeAttr('disabled').val('Send WhatsApp')
              }



              function unloadPopupBox() {
                  jQuery('#popup_box1').fadeOut("slow");
                  jQuery("#Pbody_box_inventory").css({
                      "opacity": "1"
                  });
                  jQuery("#btnResendOTP,#btnCreateOTP,#txtLabReportOTP,#spnLabreportOTP").hide();
                  jQuery("#txtLabReportOTP").val('');
                  jQuery("#spnOTPResponse").text('');
              }
              function LabReportPopOP(type, LabNo, LabID, Email, MobileNo) {
                  jQuery('#notifyhead').html("".concat('Send ', type));
                  jQuery('#tblReceipt,#btnResendOTP,#btnCreateOTP,#txtLabReportOTP,#spnLabreportOTP').hide();
                  jQuery('#popup_box1').fadeIn("slow");
                  jQuery("#Pbody_box_inventory").css({
                      "opacity": "0.5",
                  });
                  jQuery('#spnErrorLabReport,#spnOTPResponse').text('');
                  jQuery('#txtLabReport,#txtLabReportOTP').val('');
                  jQuery('#tblsendnotification tr').slice(1).remove();
                  jQuery('#tblLabReportSMS tr').slice(1).remove();
                  jQuery('#tblLabReportWhatsApp tr').slice(1).remove();

                  if (type == "Email") {
                      jQuery('#sphead').html("Email ID");
                      jQuery('#btnSendMail,.PatientReportMail').show();
                      jQuery('#btnSendSMS,.PatientReportSMS,#btnSendWhatsAPP').hide();
                      jQuery('#btnSendMail').val("".concat('Send ', type));
                      jQuery('#txtLabReport').val(Email);
                      jQuery("#txtLabReport").attr('maxlength', '100');
                      getEmailData(LabNo, 'PDF Report Email');
                  }
                  else if (type == "WhatsApp") {
                      jQuery('#sphead').html("Mobile No.");
                      jQuery('#btnSendMail,.PatientReportMail,#btnSendSMS').hide();
                      jQuery('#btnSendWhatsAPP,.PatientReportSMS').show();
                      jQuery('#btnSendWhatsAPP').val("".concat('Send ', type));
                      jQuery('#txtLabReport').val(MobileNo);
                      jQuery("#txtLabReport").attr('maxlength', '10');
                      getLabReportWhatsData(LabID);
                  }

                  else {
                      jQuery('#sphead').html("Mobile No.");
                      jQuery('#btnSendMail,.PatientReportMail,#btnSendWhatsAPP').hide();
                      jQuery('#btnSendSMS,.PatientReportSMS').show();
                      jQuery('#btnSendSMS').val("".concat('Send ', type));
                      jQuery('#txtLabReport').val(MobileNo);
                      jQuery("#txtLabReport").attr('maxlength', '10');
                      getLabReportSMSData(LabID);
                  }
                  jQuery('#spnVisitNo').text(LabNo);
                  jQuery('#spnVisitID').text(LabID);
                  jQuery('.PatientReport').show();

              }
              getLabReportSMSData = function (LabID) {
                  PageMethods.SMSStatusData(LabID, "TinySMS", onSuccessLabReportSMS, OnFailureEmailSend);
              }
              onSuccessLabReportSMS = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      var ReceiptStatusData = jQuery.parseJSON($responseData.responseDetail);
                      for (var i = 0; i <= ReceiptStatusData.length - 1; i++) {
                          var $myData = [];
                          $myData.push("<tr >");
                          //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].Mobile_No); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].IsSend); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].dtEntry); $myData.push('</td>');
                          $myData.push("</tr>");
                          $myData = $myData.join("");
                          jQuery('#tblLabReportSMS tbody').append($myData);
                      }
                      jQuery("#spnTotalRecords").text($("#tblLabReportSMS tbody tr").length);
                  }
                  jQuery('#tblLabReportSMS').show();
                  jQuery('#tblLabReportWhatsApp').hide();
                  //jQuery.unblockUI();
              }


              getLabReportWhatsData = function (LabID) {
                  PageMethods.SMSWhastsAppData(LabID, "WhatsApp", onSuccessLabReportWhatsApp, OnFailureEmailSend);
              }
              onSuccessLabReportWhatsApp = function (result) {
                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {
                      var ReceiptStatusData = jQuery.parseJSON($responseData.responseDetail);
                      for (var i = 0; i <= ReceiptStatusData.length - 1; i++) {
                          var $myData = [];
                          $myData.push("<tr >");
                          //$myData.push('<td class="GridViewLabItemStyle" >'); $myData.push((i + 1)); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].Mobile_No); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].IsSend); $myData.push('</td>');
                          $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ReceiptStatusData[i].dtEntry); $myData.push('</td>');
                          $myData.push("</tr>");
                          $myData = $myData.join("");
                          jQuery('#tblLabReportWhatsApp tbody').append($myData);
                      }
                      jQuery("#spnTotalRecords").text($("#tblLabReportWhatsApp tbody tr").length);
                  }
                  jQuery('#tblLabReportWhatsApp').show();
                  jQuery('#tblLabReportSMS').hide();
                  //jQuery.unblockUI();
              }



              getEmailData = function (LabNo, Type) {
                  PageMethods.EmailStatusData(LabNo, Type, onSuccessLabEmailData, OnFailureEmailSend);

              }

              onSuccessLabEmailData = function (result) {

                  var $responseData = JSON.parse(result);
                  if ($responseData.status) {


                      var LabEmailData = jQuery.parseJSON($responseData.responseDetail);
                      for (var i = 0; i < LabEmailData.length; i++) {
                          var $myData = [];
                          $myData.push("<tr id='"); $myData.push(LabEmailData[i].ID); $myData.push("'"); $myData.push(">");
                          //$myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(parseInt(i + 1)); $myData.push("</td>");
                          $myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(LabEmailData[i].MailType); $myData.push("</td>");
                          $myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(LabEmailData[i].IsSend); $myData.push("</td>");
                          $myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(LabEmailData[i].EmailID); $myData.push("</td>");
                          $myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(LabEmailData[i].UserName); $myData.push("</td>");
                          $myData.push("<td class='GridViewLabItemStyle' >"); $myData.push(LabEmailData[i].dtEntry); $myData.push("</td>");
                          $myData = $myData.join("");
                          jQuery('#tblsendnotification tbody').append($myData);
                      }
                  }
                  jQuery('#spnTotalRecords').text(jQuery("#tblsendnotification tbody tr").length);
                  jQuery('#tblsendnotification').show();
                  //jQuery.unblockUI();
              }




              openTicket = function () {
                  PageMethods.EncryptDate(onSuccessEncrypt, OnFailureEmailSend);

              }
              onSuccessEncrypt = function (result) {
                  var $responseData = JSON.parse(result);
                  fancyBoxOpen('http://uatlims.apollohl.in/ApolloLive/design/CallCenter/NewTicket.aspx?IsTicket=1&ID=' + $responseData.ID + '&LoginName=' + $responseData.LoginName + '&Centre=' + $responseData.Centre + '&RoleID=' + $responseData.RoleID + '&LoginType=' + $responseData.LoginType + '&CentreName=' + $responseData.CentreName + '');
                  // fancyBoxOpen('http://localhost:50315/Apollo/design/CallCenter/NewTicket.aspx?IsTicket=1&ID=' + $responseData.ID + '&LoginName=' + $responseData.LoginName + '&Centre=' + $responseData.Centre + '&RoleID=' + $responseData.RoleID + '&LoginType=' + $responseData.LoginType + '&CentreName=' + $responseData.CentreName + '');

              }
              function fancyBoxOpen(href) {
                  jQuery.fancybox({

                      'background': 'none',
                      'hideOnOverlayClick': true,
                      'overlayColor': 'gray',
                      'width': '1300px',
                      'height': '900px',
                      'min-height': '900px',
                      'autoScale': false,
                      'autoDimensions': false,
                      'transitionIn': 'elastic',
                      'transitionOut': 'elastic',
                      'speedIn': 6,
                      'speedOut': 6,
                      'href': href,
                      'overlayShow': true,
                      'type': 'iframe',
                      'opacity': true,
                      'centerOnScroll': true,
                      'onComplete': function () {
                      },
                      afterClose: function () {
                      }
                  }
              );

              }
              jQuery.fancybox.defaults.fullScreen = { requestOnStart: true };
    </script>
     <style type="text/css">
         .web_dialog_overlay {
             position: fixed;
             top: 0;
             right: 0;
             bottom: 0;
             left: 0;
             height: 100%;
             width: 100%;
             margin: 0;
             padding: 0;
             background: #000000;
             opacity: .15;
             filter: alpha(opacity=15);
             -moz-opacity: .15;
             z-index: 101;
             display: none;
         }

         .web_dialog {
             display: none;
             position: fixed;
             top: 50%;
             left: 35%;
             width: 800px;
             margin-left: -190px;
             margin-top: -100px;
             background-color: #d7edff;
             border: 2px solid #336699;
             padding: 0px;
             z-index: 102;
             font-family: Verdana;
             font-size: 10pt;
             text-align: center;
         }

         .web_dialog_title a {
             color: White;
             text-decoration: none;
         }

         .align_right {
             text-align: right;
         }

         .rowColor {
             background-color: #90EE90;
         }
     </style> 
          <style type="text/css">
              div#divLabDetail {
                  height: 200px;
                  overflow: scroll;
              }

              #popup_box1 {
                  display: none; /* Hide the DIV */
                  position: fixed;
                  _position: absolute; /* hack for internet explorer 6 */
                  width: 900px;
                  left: 20%;
                  top: 20%;
                  z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
                  /* additional features, can be omitted */
                  border: 2px solid #ff0000;
                  padding: 5px;
                  background-color: #d7edff;
                  border-radius: 5px;
              }
          </style>
</form>
    </body>
    </html>

