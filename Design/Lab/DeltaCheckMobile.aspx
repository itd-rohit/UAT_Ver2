<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DeltaCheckMobile.aspx.cs" Inherits="Design_Lab_DeltaCheckMobile" %>
 <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
        <%: Scripts.Render("~/bundles/Chosen") %>
    <style>
        div#divPatient {
            height: 600px;
            background: #ffffff;
            overflow-y: auto;
            margin-top:-37px;
        }

        div#divInvestigation {
            height: 100px;
            background: #ffffff;
            overflow-y: auto;
        }

        div#divInvestigationLabNo {
            height: 100px;
            background: #ffffff;
            overflow-y: auto;
        }

        div#divParamterLabNo {
            height: 400px;
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
     <div id="output"></div>  
    <div id="overlay1"  class="web_dialog_overlay"></div>  
    <div id="dialog1" style="    position: fixed;
    width: 250px;
    top: 50%;
    left: 50%;
    margin-left: -190px;
    margin-top: -100px;
    background-color: #ffffff;
    border: 2px solid #336699;
    padding: 0px;
    z-index: 102;
    font-family: Verdana;
    font-size: 10pt;" class="web_dialog"> 
          <table style="width: 100%;display:block; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyState">  
            <tr>  
                <td class="web_dialog_title" style="width:100%;text-align:left;">Remarks</td>  
                <td class="web_dialog_title" style="width:100%"></td>
            </tr>  
            <tr>  
                <td> </td>  
                <td> </td>  
            </tr>  
<%--              <tr>  
                <td colspan="2" style="padding-left: 15px;text-align:left;"><b>Call Closing Option </b></td>  
            </tr>
           <tr>
                <td colspan="2" style="padding-left: 15px;text-align:left;">
                    <select style="width:220px;" id="callidremarks" onchange="bindRemarksText();"></select>
                    </td>
           </tr>--%>
              <tr>  
                <td colspan="2" style="padding-left: 15px;text-align:left;"><b>Call Closing Remarks </b></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;text-align:left;">
                    <asp:DropDownList ID="remarks" runat="server" class="remarks chosen-select chosen-container" Width="160px" ClientIDMode="Static"></asp:DropDownList>
                    <%--<asp:TextBox ID="remarks" TextMode="MultiLine" ClientIDMode="Static" runat="server" Width="214px"></asp:TextBox>--%>
                </td>  
            </tr>             
             
            <tr>  
                <td  style="text-align: left;text-align: left;">
                     <input type="button" value="Save" id="btnupdt" class="savebutton"  onclick="saveLabReport();" style="width:75px;margin-left: 11px;" />     
                     </td>   
            </tr>  
        </table>      
                
        </div>
        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error..."> 
    </Ajax:ScriptManager>
     <div id="Pbody_box_inventory" style="width: 1275px">
        <div class="POuter_Box_Inventory" style="width: 1272px">
            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
            <div class="content" style="float:left;">
                <select id="ddlSearchType" class="ItDoseDropdownbox" onchange="changetext();">

                </select>
                <asp:TextBox ID="txtSearchValue" CssClass="ItDoseTextinputText" runat="server" Width="150px" onkeyup="showlength()"></asp:TextBox><span id="lblValueLength" style="font-weight:bold;"></span>
                        <asp:DropDownList ID="ddlCentreAccess" CssClass="ItDoseDropdownbox" Width="155px" Height="20px" runat="server">
                        </asp:DropDownList> 
                      <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                            &nbsp;- <asp:TextBox ID="txtToDate"  CssClass="ItDoseTextinputText"  runat="server" ReadOnly="true"  Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                   <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchDetailByCat();" />
            </div>
            <div style="float:left;margin-top:0px;margin-left:5px;">
            <table>
                <tr>
                    <td style="width:15px;height:15px;background-color:#B0C4DE"></td>
                    <td style="font-weight:bold;">Cancel</td>
                    <td style="width:15px;height:15px;background-color:#00FA9A"></td>
                    <td style="font-weight:bold;">Full Paid</td>
                    <td style="width:15px;height:15px;background-color:#F0FFF0"></td>
                    <td style="font-weight:bold;">Credit</td>
                    <td style="width:15px;height:15px;background-color:#FFC0CB"></td>
                    <td style="font-weight:bold;">Balance</td>
                    <td style="width:15px;height:15px;background-color:#00FFFF"></td>
                    <td style="font-weight:bold;">Printed</td>
                    <td style="width:15px;height:15px;background-color:#90EE90"></td>
                    <td style="font-weight:bold;">Approved</td>
                    <td style="width:15px;height:15px;background-color:#FFC0CB"></td>
                    <td style="font-weight:bold;">Result Done</td>
                    <td style="width:15px;height:15px;background-color:#E2680A"></td>
                    <td style="font-weight:bold;">Result Not Done</td>
                    <td style="width:15px;height:15px;background-color:#FFFF00"></td>
                    <td style="font-weight:bold;">Hold</td>
                    <td style="width:15px;height:15px;background-color:#CC99FF"></td>
                    <td style="font-weight:bold;">Sample Not Receive</td>
                    <td style="width:15px;height:15px;background-color:#B0C4DE"></td>
                    <td style="font-weight:bold;">Sample Reject</td>
                    <td style="width:15px;height:15px;background-color:red"></td>
                    <td style="font-weight:bold;">Due Amount</td>                   
                </tr>
            </table>
                </div>
            </div>
        <div class="POuter_Box_Inventory" style="width: 1272px">
  <table>
      <tr>
          <td style="width:329px;">
 <div id="divPatient"></div>
          </td>
          <td style="width:700px;">
<div id="divInvestigation">

</div>
    <div id="divInvestigationLabNo">
  </div>
         
   <div class="content" id="conbtnid" style="text-align: center;"><input type="button" id="btnReport" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" /></div> 
               <div id="divParamterLabNo">              
          </div>            
                   </td>  
      </tr>
  </table>
       <%-- <div class="content" style="text-align: center;"><input type="button" id="btnReport" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" /></div>--%>
           </div>
    </div>
     <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Save
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left;">
                        <td style="font-weight:bold;">Call Closing Remarks</td>
                        <td><textarea id="remarks1"></textarea></td>
                    </tr>
                </table>
                 <input type="button" id="btnsave" value="Save" onclick="saveLabReport()" tabindex="21" class="savebutton" />
                <asp:Button ID="btncloseopd" style="display:none;" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd"  TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
                  <div id="overlay" class="web_dialog_overlay" style="display:none;"></div>
    <div id="dialog" class="web_dialog" style="display:none;">
        <table style="width:100%;height: 80px;display:none; border: 0px;" cellpadding="3" cellspacing="0" id="tblEmailSend" >
            <tr>
                <td class="Purchaseheader">Send Mail</td>
                <td class="Purchaseheader align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor: pointer;">Close</a></td>
            </tr>
            <tr>  
                <td colspan="2" style="text-align:center;"> <asp:Label ID="lblApproved" runat="server" CssClass="ItDoseLblError"></asp:Label></td>                
            </tr> 
             <tr>  
                <td style="width:40%;text-align:right;"><b>To</b></td>
                <td style="width:60%;text-align:left;"><asp:TextBox ID="txtEmailID" runat="server" Width="185px"></asp:TextBox>
                    <asp:TextBox ID="txtVisitNo" runat="server" Width="185px" Disabled style="display:none;"></asp:TextBox>
                </td>  
            </tr> 
            
             <tr>  
                <td style="width:40%;text-align:right;"><b>Cc</b></td>
                <td style="width:60%;text-align:left;"><asp:TextBox ID="txtCc" runat="server" Width="185px"></asp:TextBox></td>  
            </tr> 
           
             <tr>  
                <td style="width:40%;text-align:right;"><b>Bcc</b></td>
                <td style="width:60%;text-align:left;"><asp:TextBox ID="txtBcc" runat="server" Width="185px"></asp:TextBox></td>  
            </tr> 
            <tr>
                <td style="width:40%;"></td>
                <td style="width:60%;text-align:left;"><input type="button" value="Send " class="savebutton" onclick="SendFinalMail();" style="width: 100px;" id="btnSend" />
                    <input type="button" value="Cancel" class="savebutton" onclick=" HideDialog(true);" style="width: 95px;" id="btnCancel" /></td>
             
                  
            </tr>
        </table>
        <div  style="overflow:scroll; height:100px;" id="divEmailStatus">
 <table style="width: 1750px;border: 0px;" cellpadding="3" cellspacing="0"  id="tblEmailStatus" class="GridViewStyle">
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
     <script type="text/javascript" language="javascript">
         $(document).ready(function () {
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
         });
         function BindRemarks() {
             $.ajax({
                 url: "DeltaCheckMobile.aspx/GetRemarks",
                 data: '{ }', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientRemarks = eval('[' + result.d + ']');
                     $('#remarks').append('<option value="">---Select---</option>');
                     if (PatientRemarks.length > 0) {
                         for (var i = 0; i < PatientRemarks.length; i++) {
                             $('#remarks').append('<option value="' + PatientRemarks[i].Remarks + '">' + PatientRemarks[i].Remarks + '</option>');
                         }
                         $('.chosen-container').css('width', '220px');
                         $("#remarks").trigger('chosen:updated');
                     }
                 }
             });

         }
         function bindRemarksText() {
             $('#remarks').val($('#callidremarks').val());
         }
         function SearchDetail(callBy, CallByID, MobileNo) {
             $modelBlockUI();
             var searchby = "";
             if (callBy == "Patient") {
                 //if ($('#ContentPlaceHolder1_txtSearchValue').val() == "") {
                 //    showerrormsg("plese enter mobile/Lab no...!");
                 //    return;
                 //}
                 searchby = CallByID;//MobileNo; -- change by ehtesham alam(salek sir)
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
             $('#divPatient').html('');
             $('#divInvestigation').html('');
             $('#divInvestigationLabNo').html('');
             $('#divParamterLabNo').html('');
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchDetail",
                 data: '{ SearchType: "' + $('#ddlSearchType').val() + '",SearchValue:"' + searchby + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",CallBy:"' + callBy + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');
                     if (PatientData == "-1") {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         $('#conbtnid').hide();
                         $('#divPatient').css('margin-top', '0px');
                         $('#divPatient').html('No record found');
                         return;
                     }
                     else {
                         $modelUnBlockUI();
                         $("#<%=lblMsg.ClientID %>").text('');
                         var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                         $('#divPatient').html(output);
                         if (PatientData.length > 0)
                             SearchPatientDetail(PatientData[0].Patient_ID);
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         //return;
                     }

                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     $("#btnSearch").removeAttr('disabled').val('Search');
                     $('#divPatient').html('');
                     //  alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
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
                     //if ($('#ContentPlaceHolder1_txtSearchValue').val() == "") {
                     //    showerrormsg("please enter search area");
                     //    return false;
                     //}
                     SearchDetail1();
                 }
             }
         }
         function SearchDetailVisit() {
             $modelBlockUI();
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchPatientDetailVisitID",
                 data: '{ VisitID: "' + $('#ContentPlaceHolder1_txtSearchValue').val() + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');
                     $("#<%=lblMsg.ClientID %>").text('');
                     if (PatientData == "-1") {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         //$('#conbtnid').hide();
                         return;
                     }
                     else {

                         var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                         $('#divInvestigation').html(output);
                         if (PatientData.length > 0) {
                             SearchPatientInvestigation(PatientData[0].LabNo);
                             var blamt = $('#blamt_' + PatientData[0].LabNo).text();
                             // debugger;
                             if (blamt == '0') {
                                 $('#SearchParamterLabNo').html('');
                                 SearchPatientParamterDetail(PatientData[0].LabNo);
                             }
                             else {
                                 $('#SearchParamterLabNo').html('');
                             }
                         }
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $modelUnBlockUI();


                     }

                 },
                 error: function (xhr, status) {
                     $("#btnSearch").removeAttr('disabled').val('Search');
                     $modelUnBlockUI();
                     //  alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function SearchDetail1() {
             if ($('#ContentPlaceHolder1_txtSearchValue').val() == "") {
                 showerrormsg("plese enter search area");
                 return;
             }
             $modelBlockUI();
             $('#divPatient').html('');
             $('#divInvestigation').html('');
             $('#divInvestigationLabNo').html('');
             $('#divParamterLabNo').html('');
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchDetail1",
                 data: '{ SearchType: "' + $("#ddlSearchType").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');

                     if (PatientData == "-1") {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         return;
                     }
                     else {
                         $("#<%=lblMsg.ClientID %>").text('');
                         var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                         $('#divPatient').html(output);
                         if (PatientData.length > 0)
                             SearchPatientDetail(PatientData[0].Mobile);
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $modelUnBlockUI();
                         //return;
                     }

                 },
                 error: function (xhr, status) {
                     $("#btnSearch").removeAttr('disabled').val('Search');
                     $('#divPatient').html('');
                     $modelUnBlockUI();
                     //  alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function SearchPatientDetail(PatientID) {
             $modelBlockUI();
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchPatientDetail",
                 data: '{ PatientID: "' + PatientID + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');
                     $("#<%=lblMsg.ClientID %>").text('');
                     if (PatientData == "-1") {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $modelUnBlockUI();
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         return;
                     }
                     else {
                         $modelUnBlockUI();
                         var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                         $('#divInvestigation').html(output);
                         if (PatientData.length > 0) {
                             SearchPatientInvestigation(PatientData[0].LabNo);
                             var blamt = $('#blamt_' + PatientData[0].LabNo).text();
                             // debugger;
                             if (blamt == '0') {
                                 $('#SearchParamterLabNo').html('');
                                 SearchPatientParamterDetail(PatientData[0].LabNo);
                             }
                             else {
                                 $('#SearchParamterLabNo').html('');
                             }
                         }
                         $("#btnSearch").removeAttr('disabled').val('Search');



                     }

                 },
                 error: function (xhr, status) {
                     $("#btnSearch").removeAttr('disabled').val('Search');

                     //  alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function SearchPatientInvestigation(LabNo) {

             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchPatientInvestigation",
                 data: '{ LabNo: "' + LabNo + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');

                     if (PatientData == "-1") {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         return;
                     }
                     else {

                         var output = $('#tb_SearchInvestigationLabNo').parseTemplate(PatientData);
                         $('#divInvestigationLabNo').html(output);
                         var blamt = $('#blamt_' + LabNo).text();
                         // debugger;
                         if (blamt == '0') {
                             $('#SearchParamterLabNo').html('');
                             SearchPatientParamterDetail(LabNo);
                         }
                         else {
                             $('#SearchParamterLabNo').html('');
                         }
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         var blamt = $('#blamt_' + LabNo).text();
                         if (blamt != '0') {
                             $('.printcheck').hide();
                             $('#img5').hide();
                         }

                     }

                 },
                 error: function (xhr, status) {
                     $("#btnSearch").removeAttr('disabled').val('Search');

                     //alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function SearchPatientParamterDetail(LabNo) {
             $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SearchPatientParamterDetail",
                 data: '{ LabNo: "' + LabNo + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');

                     if (PatientData == "-1") {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         alert('Your Session Expired.... Please Login Again');
                         return;
                     }
                     if (PatientData.length == 0) {
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $("#<%=lblMsg.ClientID %>").text('No Record Found');
                         $('#SearchParamterLabNo').html('');
                         return;
                     }
                     else {
                         var blamt = $('#blamt_' + LabNo).text();
                         // debugger;
                         if (blamt == '0') {
                             // alert(blamt);
                             var output = $('#tb_SearchParamterLabNo').parseTemplate(PatientData);
                             $('#divParamterLabNo').html(output);
                         }
                         $("#btnSearch").removeAttr('disabled').val('Search');



                     }

                 },
                 error: function (xhr, status) {
                     $("#btnSearch").removeAttr('disabled').val('Search');

                     //    alert('Please Contact to ItDose Support Team');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function showlength() {

             if ($('#<%=txtSearchValue.ClientID%>').val() != "") {
                 $('#lblValueLength').html($('#<%=txtSearchValue.ClientID%>').val().length);
             }
             else {
                 $('#lblValueLength').html('');
             }
         }
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
                     //$('#ContentPlaceHolder1_txtSearchValue').val(params3);
                     $('#ContentPlaceHolder1_txtFormDate').hide();
                     $('#ContentPlaceHolder1_txtToDate').hide();
                     var result = [{ "value": "lt.LedgertransactionNo", "Name": "Visit No" }];
                     for (var i = 0; i < result.length; i++) {
                         $('#ddlSearchType').append('<option value="' + result[i].value + '">' + result[i].Name + '</option>');
                     }
                     SearchDetail(params1, params2, params3);
                     //if ($('#ContentPlaceHolder1_txtSearchValue').val() != "") {
                     //    SearchDetail(params1, params2, params3);
                     //}
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
         function HideDialog() {
             $("#overlay").hide();
             $("#dialog").fadeOut(300);
         }
         function OpneSavePOpup() {
             $("#overlay1").show();
             $("#dialog1").fadeIn(300);

         }
         function saveLabReport() {
             var loc = window.location.toString(),
             params = loc.split('?')[1],
             params1 = loc.split('&')[1],
             params2 = loc.split('&')[2],
             params3 = params.split('&')[0],
             params4 = loc.split('&')[3].split("Name:")[1],
             iframe = document.getElementById('estimateiframe');
             var MobileNo = params3;
             var CallBy = params1;
             var CallByID = params2;
             var CallType = "LabReport";
             var Remarks = $('#remarks').val();
             var name = "";
             if (params1 == "PUP" || params1 == "PCC") {
                 name = params4.replace(/%20/g, ' ').trim();
             }
             else {
                 name = params4.split(".")[1].trim().replace(/%20/g, ' ').trim();
             }
             $("#btnupdt").attr('disabled', true).val("Submiting...");
             $.ajax({
                 url: "DeltaCheckMobile.aspx/SaveNewLabReportLog",
                 data: JSON.stringify({ MobileNo: MobileNo, CallBy: CallBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks, Name: name }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         showmsg("Record Saved..!");
                         $('#btnupdt').attr('disabled', false).val("Save");
                         $("#overlay1").hide();
                         $("#dialog1").fadeOut(300);
                         $('#remarks').val('');
                         $("#remarks").trigger('chosen:updated');
                     }
                     else {
                         showerrormsg(save.split('#')[1]);
                         $('#btnupdt').attr('disabled', false).val("Save");
                     }
                 }
             });
         }
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function SendEmail(btnl) {
             if (typeof (btnl) == "object") {
                 var LebNo = $(btnl).closest('tr').find('td:eq(3)').text().trim();
                 if ($(btnl).closest('tr').find('td:eq(4)').text().trim() == '0' & $(btnl).closest('tr').find('td:eq(10)').text().trim() != "No") {
                     $.fancybox({
                         maxWidth: 1030,
                         maxHeight: 800,
                         fitToView: false,
                         width: '90%;',
                         height: '50%',
                         href: '../Lab/ReportEmailPopUP.aspx?VisitNo=' + LebNo + '',
                         autoSize: false,
                         closeClick: false,
                         openEffect: 'none',
                         closeEffect: 'none',
                         'type': 'iframe'
                     });
                 }
                 if ($(btnl).closest('tr').find('td:eq(4)').text().trim() != '0') {
                     showerrormsg("You have due amount");
                     return;
                 }
                 if ($(btnl).closest('tr').find('td:eq(10)').text().trim() == "No") {
                     showerrormsg("You are not approved");
                     return;
                 }
                 //else {
                 //    showerrormsg("You have due amount/not approved");
                 //}
             }
         }
         function SendEmail112547(btnl) {

             if (typeof (btnl) == "object") {
                 var emailto = $(btnl).closest('tr').find('td:eq(6)').text().trim();
                 var amtdue = $(btnl).closest('tr').find('td:eq(4)').text().trim();
                 var labnumber = $(btnl).closest('tr').find('td:eq(3)').text().trim();
                 if ($(btnl).closest('tr').find('td:eq(4)').text().trim() == '0' & $(btnl).closest('tr').find('td:eq(10)').text().trim() != "No") {
                     $('#<%=txtVisitNo.ClientID%>').val(labnumber);
                     $('#<%=txtEmailID.ClientID%>').val(emailto);
                     $('#<%=txtCc.ClientID%>').val('');
                     $('#<%=txtBcc.ClientID%>').val('');
                     $('#btnSend').attr('value', 'Send');
                     $('#btnSend').removeAttr('disabled');
                     $('#tblEmailStatus tr').slice(1).remove();
                     $.ajax({
                         url: "DeltaCheckMobile.aspx/EmailStatusData",
                         data: '{ VisitNo:"' + $('#<%=txtVisitNo.ClientID%>').val() + '"}', // parameter map 
                         type: "POST", // data has to be Posted    	        
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         dataType: "json",
                         success: function (result) {
                             EmailStatusData = jQuery.parseJSON(result.d);
                             if (EmailStatusData.length == 0) {
                                 $('#divEmailStatus').hide();
                             }
                             else {
                                 for (var i = 0; i <= EmailStatusData.length - 1; i++) {
                                     var mydata = "<tr>";
                                     mydata += '<td class="GridViewLabItemStyle" >' + (i + 1) + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].LedgerTransactionNo + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].PName + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].MailType + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].IsSend + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].EmailID + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].Cc + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].Bcc + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].UserName + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" >' + EmailStatusData[i].dtEntry + '</td>';
                                     mydata += "</tr>";
                                     $('#tblEmailStatus').append(mydata);
                                 }
                                 $('#divEmailStatus').show();
                             }

                         },
                         error: function (xhr, status) {
                         }
                     });
                     ShowDialog(true, '');
                 }
                 else {
                     showerrormsg("You have due amount/not approved");
                 }
             }
         }
         function SendFinalMail() {
             $("#btnSend").attr('disabled', true).val("Sending...");
             $.ajax({
                 url: "../CallCenter/Services/OldPatientData.asmx/sendEmail",
                 data: '{ VisitNo:"' + $('#<%=txtVisitNo.ClientID%>').val() + '",EmailID:"' + $('#<%=txtEmailID.ClientID%>').val() + '",Cc:"' + $('#<%=txtCc.ClientID%>').val() + '",Bcc:"' + $('#<%=txtBcc.ClientID%>').val() + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     $("#btnSend").attr('disabled', false).val("Send");
                     HideDialog();
                     if (result.d == '1') {
                         showmsg("Email Send successfully...!");
                         $('#<%=txtEmailID.ClientID%>').val('');
                            $('#<%=txtVisitNo.ClientID%>').val('');
                            $('#<%=txtCc.ClientID%>').val('');
                            $('#<%=txtBcc.ClientID%>').val('');

                        }
                        else {
                            showerrormsg("Some Error...!");
                        }

                    }
             });
            }
            function SendSms(LabNo) { }
            function call() {
                debugger;
                if ($('#hd').prop('checked') == true) {
                    $('#Table1 tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        $('.mmc').prop('checked', true);
                        //$(this).closest("tr").find('#mmchk').prop('checked', true);
                    });
                }
                else {
                    $('.mmc').prop('checked', false);
                    //$(this).closest("tr").find('#mmchk').prop('checked', false);
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
                    showerrormsg("Please Select Test To Print");
                    return;
                }
                else {
                    window.open("labreportnew.aspx?testid=" + testid);
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
    </script>
     <script id="tb_PatientLabSearch" type="text/html"  >
        <table class="GridViewStyle" cellspacing="0"  id="tb_grdLabSearchs" 
    style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Patient Detail</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">Paramter Detail</th>
</tr>

<#       
 
 var dataLength=PatientData.length;
 window.status="Total Records Found :"+ dataLength;
 var objRow; 
        
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j]; 
        
            #>
<tr id="tr_<#=objRow.BarcodeNo#>" > 
<td class="GridViewLabItemStyle"><#=j+1#></td>    
<td class="GridViewLabItemStyle"><#=objRow.PName#></td>  
<td class="GridViewLabItemStyle"><#=objRow.Patient_ID#></td> 
<td class="GridViewLabItemStyle"> 
    <a href="javascript:void(0);" id="click_<#=j+1#>" onclick="SearchPatientDetail('<#=objRow.Patient_ID#>');">
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
        <table class="GridViewStyle" cellspacing="0"  id="tb_SearchInvestigations" 
    style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Centre</th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Mobile</th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">RegDate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">LabNo</th> 
			<%--<th class="GridViewHeaderStyle" scope="col" style="width:50px;">PName</th> --%>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">BalAmount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Detail</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Email</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Sms</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Cash Receipt</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none;">Paramter Detail</th> 
</tr>

<#       
 
 var dataLength=PatientData.length;
 window.status="Total Records Found :"+ dataLength;
 var objRow; 
        
        for(var j=0;j<dataLength;j++)
        { 
        objRow = PatientData[j];  
            #>
<tr id="tr1" style="background-color:<#=objRow.rowColor#>;"> 
<td class="GridViewLabItemStyle"><#=j+1#></td> 
<td class="GridViewLabItemStyle"><#=objRow.Centre#></td>   
<%--<td class="GridViewLabItemStyle"><#=objRow.Mobile#></td>--%>  
<td class="GridViewLabItemStyle"><#=objRow.RegDate#></td>
<td class="GridViewLabItemStyle"><#=objRow.LabNo#></td> 
<%--<td class="GridViewLabItemStyle"><#=objRow.PName#></td> --%>
<td class="GridViewLabItemStyle" <#if(objRow.BalAmount !='0') {#> style="background-color:red;" ><#}#>
<span id="blamt_<#=objRow.LabNo#>"><#=objRow.BalAmount#></span></td>
    <td class="GridViewLabItemStyle"> 
    <a href="javascript:void(0);" id="A1" onclick="SearchPatientInvestigation('<#=objRow.LabNo#>');">
        <img id="img1" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a> 
</td>
        <td class="GridViewLabItemStyle">
            <span style="display:none;"><#=objRow.Email#></span>
            <a href="javascript:void(0);" onclick="SendEmail(this)" id="A3">
        <img id="img3" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a>
        </td>
        <td class="GridViewLabItemStyle">
            <a href="javascript:void(0);" id="A4" onclick="SendSms('<#=objRow.LabNo#>');">
        <img id="img4" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a>
        </td>
       <td>
             <a target="_blank"  href='PatientReceipt.aspx?LabID=<#=objRow.LedgerTransactionID#>' >
            <img src="../../App_Images/folder.gif" style="cursor:pointer;" alt=""/>
            </a>
    </td>
       <td class="GridViewLabItemStyle" style="display:none;"> 
    <a href="javascript:void(0);" id="A2" onclick="SearchPatientParamterDetail('<#=objRow.LabNo#>');">
        <img id="img2" src="../../App_Images/Post.gif" style="border-style: none" alt=""/>
    </a> 
</td>
    <td  style="display:none;">           <span><#=objRow.Approved#></span></td>
</tr> 
 <#}#>
</table>    
    </script>
      <script id="tb_SearchInvestigationLabNo" type="text/html"  >
        <table class="GridViewStyle" cellspacing="0"  id="Table1" 
    style="border-collapse:collapse; width:100%;">
		<tr>  
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">LabNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">BarcodeNo</th>
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
 window.status="Total Records Found :"+ dataLength;
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
      <a target="_blank"  href='labreportnew.aspx?testid=<#=objRow.Test_ID#>,' >
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
        <table id="SearchParamterLabNo" class="GridViewStyle" cellspacing="0"  id="Table2" 
    style="border-collapse:collapse; width:100%;">
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
 window.status="Total Records Found :"+ dataLength;
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
     </style> 
</asp:Content>

