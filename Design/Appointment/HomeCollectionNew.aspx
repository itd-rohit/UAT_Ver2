<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="HomeCollectionNew.aspx.cs" Inherits="Design_Appointment_HomeCollectionNew" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    

 <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <style type="text/css">
        #ctl00_ContentPlaceHolder1_ddltest_chosen {
            width: 400px !important;
        }

        .auto-style1 {
            font-size: large;
        }

        #ctl00_ContentPlaceHolder1_ddlPanel_chosen {
            width: 250px !important;
        }

        .auto-style1 {
            font-size: large;
        }

        #ctl00_ContentPlaceHolder1_ddlDoctor_chosen {
            width: 250px !important;
        }

        .auto-style1 {
            font-size: large;
        }

        #ctl00_ContentPlaceHolder1_ddlCentreAccess1_chosen {
            width: 250px !important;
        }

        .auto-style1 {
            font-size: large;
        }

        .chosen-container {
            width: 233px;
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
  <script type="text/javascript">
      $(document).ready(function () {
          Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(PageLoaded)
      });

      function PageLoaded(sender, args) {
         // iFrameHmCollection();
          $("#ddlBusinessZone,#ddlState,#ddlCentreAccess").chosen();
          BindCentre();
      }

</script>
 
     <script type="text/javascript">

         var PatientData = "";
         var ctrl = "";
         $(document).ready(function () {
             //iFrameHmCollection();
             BindRemarks();
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
         function BindRemarks() {
             $.ajax({
                 url: "HomeCollectionNew.aspx/GetRemarks",
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
         function SearchOldPatient() {
             if ($('#<%=txtMobile.Text.Trim()%>') == "") {
                 return;
             }
             $("#tboldpatient").empty();
             $.ajax({
                 url: "HomeCollectionNew.aspx/getoldpatient",
                 data: '{ mobile:"' + $("#<%= txtMobile.ClientID%>").val() + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');
                     if (PatientData.length == 0) {
                         // alert("No Data Found");
                         return;
                     }
                     // alert(PatientData);
                     $('#tboldpatient').append('<tr id="Header"><td class="GridViewHeaderStyle" scope="col">Select</td><td class="GridViewHeaderStyle" scope="col">Name</td><td class="GridViewHeaderStyle" scope="col">Gender</td><td class="GridViewHeaderStyle" scope="col">Age</td><td class="GridViewHeaderStyle" scope="col">Mobile</td><td class="GridViewHeaderStyle" scope="col">Visit/App Date</td><td class="GridViewHeaderStyle" scope="col">Visit/App Time</td></tr>');
                     for (var a = 0; a <= PatientData.length - 1; a++) {
                         $('#tboldpatient').append('<tr  id=' + PatientData[a].ID + '><td align="center"><a href="javascript:void(0);"   onclick="BindOldpatientData(\'' + PatientData[a].ID + '\',\'' + PatientData[a].Mobile + '\')">Select</a></td><td>' + PatientData[a].PatientName + '</td><td>' + PatientData[a].Gender + '</td><td>' + PatientData[a].AgeYear + '</td><td>' + PatientData[a].Mobile + '</td><td>' + PatientData[a].AppDate + '</td><td>' + PatientData[a].AppTime + '</td></tr>');

                     }
                     $find("<%=ModelPopupExtender3.ClientID%>").show();
                 },
                 error: function (xhr, status) {
                     alert('Error!!!');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function BindOldpatientData(ID, Mobile) {
             $find("<%=ModelPopupExtender3.ClientID%>").hide();


             $.ajax({
                 url: "HomeCollectionNew.aspx/getoldpatientdetail",
                 data: '{ ID:"' + ID + '",Mobile:"' + Mobile + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData1 = eval('[' + result.d + ']');

                     // alert(PatientData1);
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


                 },
                 error: function (xhr, status) {
                     alert('Error!!!');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }


         function receiptreprint(ID) {
             window.open('HomecollectionslotwiseReceipt.aspx?ID=' + ID);
             return;
         }

         function BindPanel() {
             // $('#<%=ddlPanel.ClientID%> option').remove();
             var Panel = $('#<%=ddlPanel.ClientID%>');
             // var ddltest = $('#<%=ddltest.ClientID%>');
             $('#<%=ddlPanel.ClientID%>').html('').trigger('chosen:updated');
             $.ajax({
                 url: "HomeCollectionNew.aspx/PanelBInd",
                 data: '{ centreid:"' + $('#<%=ddlCentreAccess1.ClientID%>').val().split('#')[0] + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    PatientData = $.parseJSON(result.d);//eval('[' + result.d + ']');

                    if (PatientData.length == 0) {
                        Panel.append($("<option></option>").val("0").html("---No Data Found---"));

                    }
                    else {
                        for (i = 0; i < PatientData.length; i++) {

                            Panel.append($("<option></option>").val(PatientData[i].PanelID).html(PatientData[i].Company_Name));
                        }
                    }

                    Panel.trigger('chosen:updated');
                    var PanelID = $('#<%=ddlPanel.ClientID%>').val();
                     $('.chosen-container').css('width', '233px');
                     Getinvlist(PanelID);
                 },
                error: function (xhr, status) {
                    alert('Error!!!');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
         function Binddoctor() {
             // $('#<%=ddlDoctor.ClientID%> option').remove();
             var Doctor = $('#<%=ddlDoctor.ClientID%>');


             $.ajax({
                 url: "HomeCollectionNew.aspx/Doctorbind",
                 data: '{ centreid:"' + $('#<%=ddlCentreAccess1.ClientID%>').val().split('#')[0] + '"}', // parameter map 
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: true,
                 success: function (result) {

                     PatientData = eval('[' + result.d + ']');

                     if (PatientData.length == 0) {
                         Doctor.append($("<option></option>").val("0").html("---No Data Found---"));

                     }
                     else {
                         for (i = 0; i < PatientData.length; i++) {

                             Doctor.append($("<option></option>").val(PatientData[i].Doctor_ID).html(PatientData[i].NAME));
                         }
                     }
                     Doctor.trigger('chosen:updated');

                 },
                 error: function (xhr, status) {
                     alert('Error!!!');
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function GetinvlistPanel() {
             var PanelID = $('#<%=ddlPanel.ClientID%>').val();
             Getinvlist(PanelID);
         }

         function Getinvlist(Panel) {

             $('#<%=ddltest.ClientID%> option').remove();
              // var Panel = $('#<%=ddlPanel.ClientID%>').val();
              var ddltest = $('#<%=ddltest.ClientID%>');

              $.ajax({
                  url: "HomeCollectionNew.aspx/getinvlist",
                  data: '{ PanelID:"' + Panel + '"}', // parameter map
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {

                      PatientData = eval('[' + result.d + ']');

                      if (PatientData.length == 0) {
                          ddltest.append($("<option></option>").val("0").html("---No Data Found---"));

                      }
                      else {
                          for (i = 0; i < PatientData.length; i++) {
                              ddltest.append($("<option></option>").val(PatientData[i].myid).html(PatientData[i].typename));
                          }
                      }
                      ddltest.trigger('chosen:updated');
                  },
                  error: function (xhr, status) {
                      alert('Error!!!');
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
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

          function openmypopup(ctrl1, phelbo, time, phelboname) {
              debugger;
              var dbHour = time.split(':')[0];
              var dbMin = time.split(':')[1];
              var now = new Date(Date.now());
              var sysHour = String(now.getHours());
              var sysMin = String(now.getMinutes());
              //var utcHour = String(now.getUTCHours());
              //var utcMin = String(now.getUTCMinutes());
              var dbDay = $('#ContentPlaceHolder1_dtFrom').val().split('-')[0];
              var sysDate = new Date();
              var sysDay = sysDate.format('dd-MMM-yyyy').split('-')[0];
              if (sysMin == "1") {
                  sysMin = "01";
              }
              if (sysMin == "2") {
                  sysMin = "02";
              }
              if (sysMin == "3") {
                  sysMin = "03";
              }
              if (sysMin == "4") {
                  sysMin = "04";
              }
              if (sysMin == "5") {
                  sysMin = "05";
              }
              if (sysMin == "6") {
                  sysMin = "06";
              }
              if (sysMin == "7") {
                  sysMin = "07";
              }
              if (sysMin == "8") {
                  sysMin = "08";
              }
              if (sysMin == "9") {
                  sysMin = "09";
              }

              if (sysHour == "1") {
                  sysHour = "01";
              }
              if (sysHour == "2") {
                  sysHour = "02";
              }
              if (sysHour == "3") {
                  sysHour = "03";
              }
              if (sysHour == "4") {
                  sysHour = "04";
              }
              if (sysHour == "5") {
                  sysHour = "05";
              }
              if (sysHour == "6") {
                  sysHour = "06";
              }
              if (sysHour == "7") {
                  sysHour = "07";
              }
              if (sysHour == "8") {
                  sysHour = "08";
              }
              if (sysHour == "9") {
                  sysHour = "09";
              }
              if (dbDay == sysDay) {
                  if (dbHour < sysHour || dbMin < sysMin) {
                      if (dbHour <= sysHour) {
                          showerrormsg("you will not book your appoinment for this time");
                          return false;
                      }
                  }
              }
              $('#PatientLabSearchOutput').html('');
              var CentreID = "";
              if ($('#txtcentrbind').val() == "") {
                  CentreID = $('#txtCentreAccess').val(); //$('#ddlCentreAccess').val();///document.getElementById('ContentPlaceHolder1_ddlCentreAccess').value;
              }
              else {
                  CentreID = $('#txtcentrbind').val();
              }
              clearform();
              //  document.getElementById('ctl00_ContentPlaceHolder1_ddlCentreAccess1').value = CentreID;           
              $("#ContentPlaceHolder1_ddlCentreAccess1").val(CentreID).trigger('chosen:updated');
              CentreID = '';
              BindPanel();
              Binddoctor();
              //Getinvlist();
              $('#<%=lbmsg.ClientID%>').html('');
              $('#<%=lblphilboid.ClientID%>').html(phelbo);
              $('#<%=lblphilboname.ClientID%>').html(phelboname);
              $('#<%=lbltimeslot.ClientID%>').html(time);


              // alert(phelbo + "   " + time);


              $find("<%=modelurgent.ClientID%>").show();

              getappdata();
              ctrl = ctrl1;
              $('#<%=txtpname.ClientID%>').focus();
             $('#ContentPlaceHolder1_ddlCentreAccess1').attr('disabled', true).trigger('chosen:updated');
             $('#ContentPlaceHolder1_txtpname').val($('#pname').val());
             $('#ContentPlaceHolder1_txtemail').val($('#ptxtemail').val());
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

         function clearform() {


             $('#<%=txtaddress.ClientID%>').val('');
             $('#<%=txtaddress1.ClientID%>').val('');
             $('#<%=txtaddress2.ClientID%>').val('');
             $('#<%=txtpinno.ClientID%>').val('');
             $('#<%=txtemail.ClientID%>').val('');
             document.getElementById('<%=ddlGender.ClientID %>').selectedIndex = 0;
             $('#<%=txtedit.ClientID%>').val('');
             $('#<%=txtbooked.ClientID%>').val('');
             $('#<%=txtre.ClientID%>').val('');
             $('#<%=txtAge.ClientID%>').val('');
             $('#<%=txtAge1.ClientID%>').val('');
             $('#<%=txtAge2.ClientID%>').val('');
             document.getElementById('<%=ddltest.ClientID %>').selectedIndex = 0;
             $('#<%=ddltest.ClientID%>').trigger('chosen:updated');
             $('#<%=ddlPanel.ClientID%>').trigger('chosen:updated');
             $('#<%=ddlDoctor.ClientID%>').trigger('chosen:updated');
             $("select#ctl00_ContentPlaceHolder1_ddlPanel").prop('selectedIndex', 0);
             $("select#ctl00_ContentPlaceHolder1_ddlDoctor").prop('selectedIndex', 0);
             //$('#ddlCentreAccess').val('0');
             // document.getElementById('<%=ddlCentreAccess1.ClientID %>').selectedIndex = 0;
             $('#molen').html('');
             $('#<%=txtpname.ClientID%>').focus();
             $('#lblamt').html('');
             $('#testtable tr').remove();
             lblamttotal = 0;
             $('#<%=lbidforedit.ClientID%>').html('');

         }


         function getappdata() {
             var Centre = $('#<%=ddlCentreAccess1.ClientID%> :selected').val();
             $.ajax({
                 url: "HomeCollectionNew.aspx/getappdata",
                 data: '{phelbo:"' + $('#<%=lblphilboid.ClientID%>').html() + '",date:"' + $('#<%=dtFrom.ClientID%>').val() + '",time:"' + $('#<%=lbltimeslot.ClientID%>').html() + '",Centre:"' + Centre + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = eval('[' + result.d + ']');
                     if (PatientData.length == 0) {
                         $('#PatientLabSearchOutput').empty();

                         return;
                     }
                     var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                     $('#PatientLabSearchOutput').html(output);
                     $('#<%=txtbooked.ClientID%>').val(PatientData[0].IsBooked);
                     //$('#<%=txtbooked.ClientID%>').val("1");
                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     alert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });


         }

         function savealldata() {

             //if(dtFrom.Text < CURDATE()) {
             // alert("You can not Booked Test in  Past date...!");)
             //}

             $('#<%=lbmsg.ClientID%>').html('');

             // if ($('#ctl00_ContentPlaceHolder1_dtFrom').val() < CurrentTime) {
             //  $('#<%=lbmsg.ClientID%>').html("You can not Booked Test in  Past date...!");
             //  return;
             // }
             // if ($('#ctl00_ContentPlaceHolder1_dtFrom').val() < $('#ctl00_ContentPlaceHolder1_CurrentTime').val()) {
             //   $('#<%=lbmsg.ClientID%>').html("You can not Booked Test in  Past date...!");
             //  return;
             // }


             if ($('#ContentPlaceHolder1_txtpname').val() == "") {
                 $('#<%=lbmsg.ClientID%>').html("Please Enter Patient Name..!");
                 $('#<%=txtpname.ClientID%>').focus();
                 return;
             }
             if ($('#ContentPlaceHolder1_txtMobile').val() == "") {
                 $('#<%=lbmsg.ClientID%>').html("Please Enter Mobile No..!");
                 $('#<%=txtMobile.ClientID%>').focus();
                 return;
             }
             if ($('#ContentPlaceHolder1_txtMobile').val().length < 10) {
                 $('#<%=lbmsg.ClientID%>').html("Incorrect Mobile No..!");
                 $('#<%=txtMobile.ClientID%>').focus();
                 return;
             }


             var test = gettestdata();
             var totalamt = parseFloat($('#lblamt').html());
             var Title = $('#<%=cmbTitle.ClientID%> option:selected ').val();

             //var Centre = $('#<%=ddlCentreAccess1.ClientID%> option:selected ').val();txtbooked
             var Centre = $('#<%=ddlCentreAccess1.ClientID%> :selected').val();
             $.ajax({
                 url: "HomeCollectionNew.aspx/savealldate",
                 data: '{phelbo:"' + $('#<%=lblphilboid.ClientID%>').html() + '",  phelboname:"' + $('#<%=lblphilboname.ClientID%>').html() + '",  date:"' + $('#<%=dtFrom.ClientID%>').val() + '",  time:"' + $('#<%=lbltimeslot.ClientID%>').html() + '",  pname:"' + $('#<%=txtpname.ClientID%>').val() + '",  mobile:"' + $('#<%=txtMobile.ClientID%>').val() + '",  address:"' + $('#<%=txtaddress.ClientID%>').val() + '",address1:"' + $('#<%=txtaddress1.ClientID%>').val() + '",address2:"' + $('#<%=txtaddress2.ClientID%>').val() + '",emailid:"' + $('#<%=txtemail.ClientID%>').val() + '",pinno:"' + $('#<%=txtpinno.ClientID%>').val() + '",test:"' + test + '",totalamt:"' + totalamt + '",ageyear:"' + $('#<%=txtAge.ClientID%>').val() + '",agemonth:"' + $('#<%=txtAge1.ClientID%>').val() + '",agedays:"' + $('#<%=txtAge2.ClientID%>').val() + '",gender:"' + $('#<%=ddlGender.ClientID%> option:selected').text() + '",appid:"' + $('#<%=lbidforedit.ClientID%>').html() + '",PanelID:"' + $('#<%=ddlPanel.ClientID%> option:selected').val() + '",DoctorID:"' + $('#<%=ddlDoctor.ClientID%> option:selected').val() + '",Title:"' + Title + '",Centre:"' + Centre + '",Type:"' + $('#<%=txtedit.ClientID%>').val() + '",Booked:"' + $('#<%=txtbooked.ClientID%>').val() + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result == "-1") {
                         alert("You can not Booked Test in  Past date...!");
                         return;
                     }
                     if (result == "2") {
                         alert("You can not edit this. It is already booked...!");
                         return;
                     }

                     if (result.d.split('#')[0] == "updated") {
                         saveHomeCollection(Centre);
                         $('#<%=lbmsg.ClientID%>').html("Booking Updated..!");
                         $find("<%=modelopdpatient.ClientID%>").hide();
                         createtable(ctrl, $('#<%=lblphilboid.ClientID%>').html(), $('#<%=lbltimeslot.ClientID%>').html(), "tr_" + result.d.split('#')[1]);
                         getappdata();
                         $("select#ctl00_ContentPlaceHolder1_ddlPanel").prop('selectedIndex', 0);
                         $("select#ctl00_ContentPlaceHolder1_ddlDoctor").prop('selectedIndex', 0);
                         clearform();

                         // window.open('HomecollectionslotwiseReceipt.aspx?ID=' + result.split('#')[1]);
                     }
                     else if (result.d.split('#')[0] == "saved") {
                         saveHomeCollection(Centre);
                         $('#<%=lbmsg.ClientID%>').html("Slot Book for Home Collection..!");
                         createtable(ctrl, $('#<%=lblphilboid.ClientID%>').html(), $('#<%=lbltimeslot.ClientID%>').html(), "tr_" + result.d.split('#')[1]);

                         getappdata();
                         $("select#ctl00_ContentPlaceHolder1_ddlPanel").prop('selectedIndex', 0);
                         $("select#ctl00_ContentPlaceHolder1_ddlDoctor").prop('selectedIndex', 0);
                         clearform();
                         //window.open('HomecollectionslotwiseReceipt.aspx?ID='+result.split('#')[1]);
                     }
                     else {
                         alert(ressult);
                     }

                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     alert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
     }

     function gettestdata() {
         var mytestdata = "";
         $('#testtable tr').each(function () {
             var aaaaaa = $(this).attr("id") + "_" + $(this).find('#invname').text() + "@" + $(this).find('#am').text();
             mytestdata = aaaaaa + "#" + mytestdata;

         });
         return mytestdata;
     }
     function createtable(ctrl, phid, phtime, trid) {

         var title = $('#<%=txtaddress.ClientID%>').val() + $('#<%=txtaddress1.ClientID%>').val() + $('#<%=txtaddress2.ClientID%>').val() + $('#<%=txtpinno.ClientID%>').val() + $('#<%=txtMobile.ClientID%>').val();
         if ($(ctrl).find('.inner tr').length == 0) {
             var mydata = '<table class="inner" frame="box" border="1" rules="all" id=' + phid + '_' + phtime + '>';
             mydata += '<tr id=' + trid + ' style="background-color:lightgreen;" title=' + title + '>';
             mydata += '<td>' + $('#<%=txtpname.ClientID%>').val() + '</td>';

             mydata += '</tr></table>';
             $(ctrl).html(mydata);
         }
         else {

             var mydata = '<tr id=' + trid + ' style="background-color:lightgreen;" title=' + title + '>';
             mydata += '<td>' + $('#<%=txtpname.ClientID%>').val() + '</td>';

             mydata += '</tr>';
             $(ctrl).find('.inner').append(mydata);
         }




     }

     function up(lstr) {
         var str = lstr.value;
         lstr.value = str.toUpperCase();
     }

     function opencncelpoup(id) {
         $('#<%=lbcencelid.ClientID%>').html(id);
         $find("<%=ModalPopupExtender1.ClientID%>").show();
         $('#<%=txtcancelreason.ClientID%>').focus();
     }


     function openshepopup(id, IsBooked) {
         var CentreID = document.getElementById('ContentPlaceHolder1_ddlCentreAccess1').value;
         clearform();
         document.getElementById('ContentPlaceHolder1_ddlCentreAccess2').value = CentreID;
         $('#ContentPlaceHolder1_ddlCentreAccess2').trigger('chosen:updated');
         CentreID = '';
         BinPhle();
         BinSloteTime();
         $('#<%=lblresid.ClientID%>').html(id);
             $('#<%=lblcrph.ClientID%>').html($('#ContentPlaceHolder1_lblphilboname').html());
             $('#<%=lblcutme.ClientID%>').html($('#ContentPlaceHolder1_lbltimeslot').html());
             $('#<%=txtre.ClientID%>').val(IsBooked);
             $("#<%=ddlphe.ClientID%> option:contains(" + $('#ContentPlaceHolder1_lblphilboname').html() + ")").attr('selected', 'selected').trigger('chosen:updated');
             $('#<%=txtreremarks.ClientID%>').val('');
             $find("<%=ModalPopupExtender2.ClientID%>").show();


         }
         function BinPhle() {
             $.ajax({
                 url: "HomeCollectionNew.aspx/BindPhle",
                 data: JSON.stringify({ CentreID: $('#ContentPlaceHolder1_ddlCentreAccess2').val() }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     var phldata = $.parseJSON(result.d);
                     if (phldata.length > 0) {
                         $('#ContentPlaceHolder1_ddlphe').html('');
                         for (var i = 0; i < phldata.length; i++) {
                             $('#ContentPlaceHolder1_ddlphe').append('<option value="' + phldata[i].ID + '">' + phldata[i].Name + '</option>');
                         }
                         $("#ContentPlaceHolder1_ddlphe").trigger('chosen:updated');
                     }
                 }
             });
         }
         function BinSloteTime() {
             $.ajax({
                 url: "HomeCollectionNew.aspx/BindTimeSlote",
                 data: JSON.stringify({ date: $('#ContentPlaceHolder1_dtFrom').val() }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     var phldata = $.parseJSON(result.d);
                     if (phldata.length > 0) {
                         $('#ContentPlaceHolder1_ddlretimeslot').html('');
                         for (var i = 0; i < phldata.length; i++) {
                             $('#ContentPlaceHolder1_ddlretimeslot').append('<option value="' + phldata[i].Timeslot + '">' + phldata[i].Timeslot + '</option>');
                         }
                     }
                 }
             });
         }
         function cencelme() {
             var id = $('#<%=lbcencelid.ClientID%>').html();
             if ($('#<%=txtcancelreason.ClientID%>').val() == "") {

                 alert("Please Enter Reason..!");
                 $('#<%=txtcancelreason.ClientID%>').focus();
                 return;
             }
             $.ajax({
                 url: "HomeCollectionNew.aspx/cencelapp",
                 data: '{id:"' + id + '",reason:"' + $('#<%=txtcancelreason.ClientID%>').val() + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         $('#<%=lbmsg.ClientID%>').html("Booking Cancel..!");
                         $find("<%=ModalPopupExtender1.ClientID%>").hide();
                         clearform();
                         getappdata();
                         $('#tr_' + id).css('background-color', 'pink');
                     }
                     else {
                         alert(result.d);
                     }
                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     alert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         var lblamttotal = 0;
         function addme() {
             $('#<%=lbmsg.ClientID%>').html("");
             if ($('#<%=ddltest.ClientID%>').val() == "0") {
                 $('#<%=lbmsg.ClientID%>').html("Please Select Test To Add..!");
                 $('#<%=ddltest.ClientID%>').focus();
                 return;
             }
             var x = 0;
             $('#testtable tr').each(function () {
                 if ($('#<%=ddltest.ClientID%>').val().split('#')[0] == this.id) {
                     x = 1;
                     return;
                 }
             });
             if (x == 1) {
                 $('#<%=lbmsg.ClientID%>').html("This Test Already Added..!");
                 $('#<%=ddltest.ClientID%>').focus();
                 return;
             }
             var a1 = $('#testtable tr').length;
             var mydata1 = '<tr id=' + $('#<%=ddltest.ClientID%>').val().split('#')[0] + '>';
             mydata1 += '<td align="centre">' + parseFloat(a1 + 1) + '</td>';
             mydata1 += '<td align="centre" id="invname">' + $('#<%=ddltest.ClientID%> option:selected').text() + '</td>';
             mydata1 += '<td align="centre" id="am">' + $('#<%=ddltest.ClientID%>').val().split('#')[1] + '</td>';
             mydata1 += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletemyrol(this)"/></td>';
             mydata1 += '</tr>';
             $('#testtable').append(mydata1);

             lblamttotal = lblamttotal + parseFloat($('#<%=ddltest.ClientID%>').val().split('#')[1]);
             $('#lblamt').html(lblamttotal);
             var rowpos = $('#testtable tr:last').position();
             $('#scdiv').scrollTop(rowpos.top);

         }

         function deletemyrol(ctrl11) {
             var mm = $(ctrl11).closest('tr').find('#am').text();
             var table = document.getElementById('testtable');
             table.deleteRow(ctrl11.parentNode.parentNode.rowIndex);
             var cc = $('#lblamt').html();
             var aa = parseFloat(cc) - parseFloat(mm);
             $('#lblamt').html(aa);
             lblamttotal = aa;
             $('#<%=lbmsg.ClientID%>').html("");
         }

         function editme(id) {

             $.ajax({
                 url: "HomeCollectionNew.aspx/editappgetdata",
                 data: '{id:"' + id + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientDataApp = eval('[' + result.d + ']');
                     clearform();
                     BindPanel();
                     Binddoctor();
                     $('#<%=txtpname.ClientID%>').val(PatientDataApp[0].PatientName);
                     $('#<%=txtMobile.ClientID%>').val(PatientDataApp[0].Mobile);
                     // txtedit.text = 1;
                     //ctl00$ContentPlaceHolder1$txtedit
                     $('#<%=txtaddress.ClientID%>').val(PatientDataApp[0].Address);
                     $('#<%=txtaddress1.ClientID%>').val(PatientDataApp[0].Address1);
                     $('#<%=txtaddress2.ClientID%>').val(PatientDataApp[0].Address2);
                     $('#<%=txtpinno.ClientID%>').val(PatientDataApp[0].PinCode)
                     $('#<%=txtemail.ClientID%>').val(PatientDataApp[0].EmailID);
                     $('#<%=ddlGender.ClientID %>').val(PatientDataApp[0].Gender);
                     $('#<%=txtAge.ClientID%>').val(PatientDataApp[0].AgeYear);
                     $('#<%=txtAge1.ClientID%>').val(PatientDataApp[0].AgeMonth);
                     $('#<%=txtAge2.ClientID%>').val(PatientDataApp[0].AgeDays);
                     $('#lblamt').html(PatientDataApp[0].TotalAmt);
                     $('#<%=lbidforedit.ClientID%>').html(id);
                     $('#<%=ddlPanel.ClientID%>').val(PatientDataApp[0].PanelID);
                     $('#<%=ddlCentreAccess1.ClientID%>').val(PatientDataApp[0].CentreID);
                     $('#<%=ddlDoctor.ClientID%>').val(PatientDataApp[0].Referdoctor);
                     $('#<%=txtedit.ClientID%>').val("1");
                     $('#<%=txtbooked.ClientID%>').val(PatientDataApp[0].IsBooked);
                     $('#molen').html('10');


                     for (var ac = 0; ac <= PatientDataApp[0].Investigation.split('#').length - 1; ac++) {

                         if (PatientDataApp[0].Investigation.split('#')[ac] != "") {
                             var mydata1 = '<tr id=' + PatientDataApp[0].Investigation.split('#')[ac].split('_')[0] + '>';
                             mydata1 += '<td align="centre">' + parseFloat(ac + 1) + '</td>';
                             mydata1 += '<td align="centre" id="invname">' + PatientDataApp[0].Investigation.split('#')[ac].split('_')[1].split('@')[0] + '</td>';
                             mydata1 += '<td align="centre" id="am">' + PatientDataApp[0].Investigation.split('#')[ac].split('_')[1].split('@')[1] + '</td>';
                             mydata1 += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletemyrol(this)"/></td>';
                             mydata1 += '</tr>';
                             $('#testtable').append(mydata1);


                             var rowpos = $('#testtable tr:last').position();
                             $('#scdiv').scrollTop(rowpos.top);
                         }

                     }


                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     alert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });



         }


         function Rescheduleme() {
             var Centre = $('#<%=ddlCentreAccess2.ClientID%> :selected').val();
             $('#<%=lblresid.ClientID%>').html();
             $.ajax({
                 url: "HomeCollectionNew.aspx/changeappdatetime",
                 data: '{appid:"' + $('#<%=lblresid.ClientID%>').html() + '",date:"' + $('#<%=txtredate.ClientID%>').val() + '",time:"' + $('#ContentPlaceHolder1_ddlretimeslot option:selected').val() + '",phelbo:"' + $('#ContentPlaceHolder1_ddlphe option:selected').val() + '",phelboname:"' + $('#ContentPlaceHolder1_ddlphe option:selected').text() + '",remarks:"' + $('#<%=txtreremarks.ClientID%>').val() + '",Centre:"' + Centre + '",Booked:"' + $('#<%=txtre.ClientID%>').val() + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "2") {
                         alert('You can not reschedule this. It is already booked...!');
                     }
                     if (result.d == "1") {
                         alert('Booking Reschedule..!');
                         $('#ContentPlaceHolder1_btnsearch').click();
                         $('#ContentPlaceHolder1_btncloseurgent2').click();
                         $('#ContentPlaceHolder1_btncloseurgent').click();
                         //window.location.reload();

                         //  $('#tr_' + $('#<%=lblresid.ClientID%>').html()).hide();
                // $find("<%=ModalPopupExtender2.ClientID%>").hide();
                // $find("<%=modelurgent.ClientID%>").hide();

                // openmypopup('', $('#ctl00_ContentPlaceHolder1_ddlphe option:selected').val(), $('#ctl00_ContentPlaceHolder1_ddlretimeslot option:selected').val(), $('#ctl00_ContentPlaceHolder1_ddlphe option:selected').text());

                //  $('#<%=lbmsg.ClientID%>').html("Booking Reschedule..!");

                // createtablenew();
            }
            else {
                alert(result.d);
            }

        },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     alert(xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
}


function createtablenew() {
}

function iFrameHmCollection() {
    var loc = window.location.toString(),
     params = loc.split('?')[1],
     params1 = loc.split('&')[1],
     params2 = loc.split('&')[2],
     params4 = loc.split('&')[3].split("Name:")[1],
     iframe = document.getElementById('estimateiframe');
    if (params != undefined) {
        params3 = params.split('&')[0];
        BindDropData(params3);
        $('#mastertopcorner').hide();
        $('#masterheaderid').hide();
        $('#btnhColl').show();
        $('#ContentPlaceHolder1_txtMobile').val(params3);
        $('#<%=txtpname.ClientID%>').val(params4.split(".")[1].trim().replace(/%20/g, ' '));
                 $('#pname').val(params4.split(".")[1].trim().replace(/%20/g, ' '));
                 $('#ContentPlaceHolder1_txtemail').val(loc.split('&')[4]);
                 $('#ptxtemail').val(loc.split('&')[4]);
             }
             else {
                 $('#btnhColl').hide();
                 $('#btnsaveslot').show();
                 return false;
             }
         }
         function OpneSavePOpup() {
             if ($('#ContentPlaceHolder1_txtaddress').val() == "") {
                 alert("please enter house number");
                 return false;
             }
             else {
                 $("#overlay1").show();
                 $("#dialog1").fadeIn(300);
                 $('#ContentPlaceHolder1_btncloseurgent').click();
             }
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
         function saveHomeCollection(CentreID) {

             var loc = window.location.toString(),
             params = loc.split('?')[1],
             params1 = loc.split('&')[1],
             params2 = loc.split('&')[2],
             params4 = loc.split('&')[3].split("Name:")[1],
             iframe = document.getElementById('estimateiframe');
             if (params2 == undefined) {
                 return;
             }
             params3 = params.split('&')[0];
             var MobileNo = params3;
             var CallBy = params1;
             var CallByID = params2;
             var CallType = "HomeCollection";
             var Remarks = $('#remarks').val();
             $("#btnupdt").attr('disabled', true).val("Submiting...");
             $.ajax({
                 url: "HomeCollectionNew.aspx/SaveNewHomeCollLog",
                 data: JSON.stringify({ MobileNo: MobileNo, CallBy: CallBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks, Name: params4.split(".")[1].trim().replace("%20", " "), centreID: CentreID }),
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
                         $('#ContentPlaceHolder1_btncloseurgent').click();
                     }
                     else {
                         showerrormsg(save.split('#')[1]);
                         $('#btnsave').attr('disabled', false).val("Save");
                     }
                 }
             });
         }
         function OpneSavePOpup() {
             $("#overlay1").show();
             $("#dialog1").fadeIn(300);
             $find("<%=modelurgent.ClientID%>").hide();
         }
         function bindState() {
             var bb = jQuery("#ddlBusinessZone").val();
             var CountryID = 0;
             jQuery("#ddlState option").remove();
             if (jQuery("#ddlBusinessZone").val() == "0") {
                 jQuery("#ddlState").html('');
                 $("#ddlState").trigger('chosen:updated');
                 return false;
             }
             jQuery.ajax({
                 url: "../Common/Services/CommonServices.asmx/bindState",
                 data: '{ CountryID:"' + CountryID + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                 type: "POST",
                 timeout: 120000,
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                     stateData = jQuery.parseJSON(result.d);
                     // console.log(stateData);
                     if (stateData.length == 0) {
                         jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                         jQuery("#ddlState").val('');
                     }
                     else {
                         jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                         jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("ALL"));
                         for (i = 0; i < stateData.length; i++) {
                             jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                         }
                     }
                     $("#<%=ddlState.ClientID%>").trigger('chosen:updated');

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     jQuery("#ddlState").attr("disabled", false);
                 }

             });
         }
         function BindCentre() {
             jQuery("#ddlCentreAccess option").remove();
             if (jQuery("#ddlState").val() == "0") {
                 showerrormsg("Please Select State");
                 jQuery("#ddlCentreAccess").html('');
                 $("#ddlCentreAccess").trigger('chosen:updated');
                 return false;
             }
             if (jQuery("#ddlBusinessZone").val() == "0") {
                 //showerrormsg("Please Select Zone");
                 jQuery("#ddlState").html('');
                 $("#ddlState").trigger('chosen:updated');
                 return false;
             }
             jQuery.ajax({
                 url: "HomeCollectionNew.aspx/bindCentre",
                 data: '{ StateID: "' + jQuery("#ddlState").val() + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                 type: "POST",
                 timeout: 120000,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                     if (result.d != null) {
                         var CentreData = jQuery.parseJSON(result.d);
                         if (CentreData.length == 0) {
                             jQuery("#ddlCentreAccess").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                             jQuery("#ddlCentreAccess option").remove();
                         }
                         else {
                             $("#ddlCentreAccess").html('').trigger('chosen:updated');
                             jQuery("#ddlCentreAccess").append(jQuery("<option></option>").val("0").html("Select"));
                             for (i = 0; i < CentreData.length; i++) {
                                 jQuery("#ddlCentreAccess").append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                                 jQuery("#ContentPlaceHolder1_ddlCentreAccess2").append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                             }
                         }
                     }
                     $("#ddlCentreAccess").trigger('chosen:updated');
                     $("#ContentPlaceHolder1_ddlCentreAccess2").trigger('chosen:updated');
                     if ($('#txtcentrbind').val() == "") {
                         $('#ddlCentreAccess').val($('#txtCentreAccess').val());
                         $("#ddlCentreAccess").trigger('chosen:updated');
                     }
                     else if ($('#txtcentrbind').val() != "") {
                         $('#ddlCentreAccess').val($('#txtcentrbind').val());
                         $("#ddlCentreAccess").trigger('chosen:updated');
                     }

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     jQuery("#ddlCentreAccess").attr("disabled", false);
                 }

             });
         }
         function BindlblCentre() {
             $('#txtCentreAccess').val($('#ddlCentreAccess').val());
             $('#txtcentrbind').val($('#ddlCentreAccess').val());
         }
         function BindTimeSlote() {
             jQuery.ajax({
                 url: "HomeCollectionNew.aspx/BindTimeSlote",
                 data: '{ date: "' + jQuery("#ContentPlaceHolder1_dtFrom").val() + '",CentreID: "' + jQuery("#ddlCentreAccess").val() + '"}',
                 type: "POST",
                 timeout: 120000,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {

                 },
                 error: function (xhr, status) {
                     alert("Error ");
                     jQuery("#ddlCentreAccess").attr("disabled", false);
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
         function BindDropData(Mobile) {
             $.ajax({
                 url: "../CallCenter/Services/OldPatientData.asmx/BindDropData",
                 data: JSON.stringify({ MobileNo: Mobile }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     var pdata = $.parseJSON(result.d);
                     if (pdata.length > 0) {
                         $('#ddlBusinessZone').val(pdata[0].BusinessZoneID);
                         $("#ddlBusinessZone").trigger('chosen:updated');
                         bindState();
                         $('#ddlState').val(pdata[0].stateid);
                         $("#ddlState").trigger('chosen:updated');
                         BindCentre();
                         $('#ddlCentreAccess').val(pdata[0].CentreID);
                         $('#ddlCentreAccess').trigger('chosen:updated');
                         $('#txtCentreAccess').val(pdata[0].CentreID);
                     }
                     else {
                         showerrormsg("No record found");

                     }
                 }
             });
         }
         //$('.selector1').each(function () {
         //    $(this).draggable({
         //        containment: $(this).parent().parent()
         //    });
         //});
         //$(document).ready(function () {

         //    //this will hold reference to the tr we have dragged and its helper
         //    var c = {};

         //    $("#calenderdiv tr td.inner tbody tr td").draggable({
         //        helper: "clone",
         //        start: function (event, ui) {
         //            c.tr = this;
         //            c.helper = ui.helper;
         //        }
         //    });


         //    $("#calenderdiv tr td.inner tbody tr td").droppable({
         //        drop: function (event, ui) {
         //            var inventor = ui.draggable.text();
         //            $(this).find("input").val(inventor);

         //            $(c.tr).remove();
         //            $(c.helper).remove();
         //        }
         //    });

         //});
         //onmouseover="changecolor(this)" onmouseout="changecolor1(this)"
         </script>
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
                     <input type="button" value="Save" id="btnupdt" class="savebutton"  onclick="savealldata();" style="width:75px;margin-left: 11px;" />     
                     </td>   
            </tr>  
        </table>      
                
        </div>
        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
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
                 <input type="button" id="btnsave" value="Save" onclick="savealldata()" tabindex="21" class="savebutton" />
                <asp:Button ID="btncloseopd" style="display:none;" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button3" runat="server" Style="display: none;" />
      <Ajax:ScriptManager ID="sm1" runat="server" />
     <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../../App_Images/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
    <Ajax:UpdatePanel ID="up" runat="server">
        <ContentTemplate>
     <div id="Pbody_box_inventory" style="width:1330px" >
     <div class="POuter_Box_Inventory"  style="width:1330px" >
         <div class="content" style="text-align: center;">
                <b><span class="auto-style1">Home Collection</span></b><input type="text" style="display:none;" id="pname"></input><input type="hidden" id="ptxtemail" />
         <br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                             </div>
    <div class="content"  style="width:1320px">
        <table width="100%" frame="box">
            <tr>
                <td class="required"><strong>Zone:</strong>  </td>
                        <td>
                            <asp:DropDownList ID="ddlBusinessZone" runat="server"  class="ddlBusinessZone chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="bindState()"></asp:DropDownList></td>
                        <td class="required"><strong>State:</strong>  </td>
                        <td>
                            <asp:DropDownList ID="ddlState" runat="server" class="ddlState chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="BindCentre()"></asp:DropDownList></td>
                   <td style="color:maroon;width:10%; text-align: right;"><b>Centre:</b></td>
                                 <td><asp:TextBox ID="txtCentreAccess" style="display:none;width:40px;" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:TextBox><asp:TextBox ID="txtcentrbind" style="display:none;width:40px;float:right;" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:TextBox>
                                     <asp:DropDownList id="ddlCentreAccess" class="ddlCentreAccess chosen-select chosen-container" runat="server" Width="200px" onchange="BindlblCentre()" ClientIDMode="Static">
                        </asp:DropDownList></td>
                <td  style="color:maroon;width:10%; text-align: right;"><b>Date:&nbsp;&nbsp;&nbsp; </b></td>
                <td>  <asp:TextBox ID="dtFrom" runat="server"   Width="100px"></asp:TextBox>
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" />


                    &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;<input id="btnsearch1" type="button" style="display:none" value="Search" class="searchbutton" onclick="BindTimeSlote();" />
                    <asp:Button ID="btnsearch" runat="server" Text="Search Data" OnClick="btnsearch_Click" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />
                </td>
            </tr>
            <tr> <asp:TextBox ID="CurrentTime" runat="server"  Width="100px"  style="display:none;"></asp:TextBox>
                <%--<asp:Label ID="CurrentTime" runat="server" />--%>

            </tr>
        </table>
        <%--style="word-wrap:break-word;white-space:normal"--%>
        <div id="calenderdiv" style="width:99%;overflow:scroll;height:470px;">
<% if (dt.Rows.Count > 0)
   {
        %>
            <table id="mytable"   frame="box" border="1" rules="all" style="background-color:white;border-color:darkred;width:99%;table-layout:fixed;">
                <thead>
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
                        ><%=dwc.ColumnName %></td>
                   
                    <%} %>
                </tr>
           </thead>
                                <tbody>
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
                <tr id="<%=dw["PhlebotomistID"].ToString() %>" style="height:40px;">
                    <%} %>
                       <%  foreach (System.Data.DataColumn dwc in dt.Columns)
                           { %>
                    <td id="<%=dwc.ColumnName %>"
                        <% if (dwc.ColumnName == "PhlebotomistID" || dwc.ColumnName == "HolidayDate")
                           { %> 
                        style="display:none;"
                        <%}
                           if (dw["HolidayDate"].ToString() != dtFrom.Text)
                           {
                               if (dwc.ColumnName != "PhlebotomistName")
                               {%>
                       style="cursor:pointer;width:60px" onclick="openmypopup(this,'<%=dw["PhlebotomistID"].ToString() %>','<%=dwc.ColumnName %>','<%=dw["PhlebotomistName"].ToString() %>')" 
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
                         <% if (dwc.ColumnName == "PhlebotomistID" || dwc.ColumnName == "PhlebotomistName" || dwc.ColumnName == "HolidayDate")
                            {%>
                        <%=dw[dwc.ColumnName].ToString()%>

                        <%}
                            //continue
                            else if (dw[dwc.ColumnName].ToString() != "")
                            {%>
                        <table class="inner" frame="box" border="1" rules="all" id="<%=dw["PhlebotomistID"].ToString() + "_" + dwc.ColumnName%>">
                            
                              <%  foreach (string ss in dw[dwc.ColumnName].ToString().Split('~'))
                                  {
                           %>
                        <tr id="tr_<%=ss.Split('#')[0]%>" class="selector1" title="Add: <%=ss.Split('#')[3]%>  Mo: <%=ss.Split('#')[2]%>"
                            <%
                                      if (ss.Split('#')[4].ToString() == "1")
                                      {  
                             %>
                            style="background-color:pink"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "0")
                                      {
                               %>
                              style="background-color:yellow"
                            <%}
                                      else if (ss.Split('#')[5].ToString() == "1")
                                      {
                               %>
                              style="background-color:lightgreen"
                            <%}  %>
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
 </tbody>
                 </table>

            <%} %>
        </div>
           

    </div>
         </div>
         </div>

    </ContentTemplate>
    </Ajax:UpdatePanel>
    <asp:Panel ID="paneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;" >
        <div class="Outer_Box_Inventory" style="width: 900px; text-align :center;height:550px;">
            
                <div style="text-align: center;">
                    <div class="Outer_Box_Inventory" style="width: 897px; text-align: center;">
                        <table border="0" cellpadding="2" cellspacing="2" width="896">
                             <tr>
                                <td colspan="4" align="center" style="font-weight:bold;font-size:16px;">
<div  style="width:100%;border:1px solid darkred;height:30px;">
                                    Book Slot

    <asp:Label ID="lbidforedit" runat="server" style="display:none;" />
                                 <asp:Button ID="btncloseurgent" runat="server" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer;float:right;" Text="Close"  Width="65px"/> </div> 
                                </td>
                                  
                            </tr>
                             <tr>
                                <td colspan="4" align="center">
                                    <asp:Label ID="lbmsg" runat="server" Font-Bold="true" ForeColor="Red" />
                                    </td>
                                 </tr>
                            <tr>
                                <td style="text-align: right"> <b> Phlebotomist Name:</b></td>
                                  <td style="text-align: left"><asp:Label ID="lblphilboname" runat="server"  Font-Bold="true" />
    <asp:Label ID="lblphilboid" runat="server" Font-Bold="true" style="display:none;"  /></td>
                                  <td style="text-align: right">  <b> Time Slot:</b></td>
                                  <td style="text-align: left"><asp:Label ID="lbltimeslot" runat="server"  Font-Bold="true" /></td>
                            </tr>

                            <tr>
                                <td style="text-align: right"> <b> Patient Name:</b></td>
                                  <td style="text-align: left"><asp:DropDownList ID="cmbTitle" runat="server" TabIndex="1" CssClass="ItDoseDropdownbox" Width="73px"
                                 onChange="return AutoGender();">
                            </asp:DropDownList><asp:TextBox ID="txtpname" onkeyup="up(this)" runat="server" Width="230px" TabIndex="1" /> </td>
                                  <td style="text-align: right"> <b> Age/Gender:</b></td>
                                  <td style="text-align: left">
                                      <asp:DropDownList ID="ddlGender" runat="server" CssClass="ItDoseDropdownbox"  Width="70px" TabIndex="2">
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
                                  </td>
                            </tr>
                            <tr>
                                <td style="text-align: right"><b>Mobile No:</b></td>
                                  <td style="text-align: left">
                                      <asp:TextBox ID="txtMobile" runat="server" TabIndex="4"  CssClass="ItDoseTextinputText"     Width="150px" MaxLength="10"
                             onkeyup="showlength()"   ></asp:TextBox>&nbsp;&nbsp;<span id="molen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                            </cc1:FilteredTextBoxExtender>
                                     </td>
                                  <td style="text-align: right"><b>Email ID:</b></td>
                                  <td style="text-align: left">
                                       <asp:TextBox TabIndex="5" ID="txtemail" runat="server"  Width="230px" onkeypress="this.value = this.value.toLowerCase();" ></asp:TextBox>
                                  </td>
                            </tr>
                             <tr>
                                 <td style="text-align: right"><b>House No:</b></td>
                                 <td style="text-align: left">
                                     <asp:TextBox ID="txtaddress" runat="server" onkeyup="up(this)" TabIndex="6" Width="230px"></asp:TextBox>
                                 </td>
                                 <td style="text-align: right"><b>Locality:</b></td>
                                 <td style="text-align: left">
                                     <asp:TextBox ID="txtaddress1" runat="server" onkeyup="up(this)" TabIndex="7" Width="230px"></asp:TextBox>
                                 </td>
                             </tr>
                             <tr>
                                 <td style="text-align: right"><b>LandMark:</b></td>
                                 <td style="text-align: left">
                                     <asp:TextBox ID="txtaddress2" runat="server" onkeyup="up(this)" TabIndex="8" Width="230px"></asp:TextBox>
                                 </td>
                                 <td style="text-align: right"><b>Pin Code:</b></td>
                                 <td style="text-align: left"><asp:TextBox ID="txtpinno" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText"     Width="150px" MaxLength="6"
                              ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtpinno" >
                            </cc1:FilteredTextBoxExtender></td>
                             </tr>
                            <tr>
                                <td style="text-align:right"><b>Panel:</b></td>
                                <td style="text-align:left">
                                    <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select" TabIndex="10" onchange="GetinvlistPanel()" ></asp:DropDownList>
                                </td>
                                <td style="text-align:right"><b>Ref Doctor</b></td>
                                <td style="text-align:left">
                                    <asp:DropDownList ID="ddlDoctor" runat="server" class="ddlDoctor chosen-select" TabIndex="11" ></asp:DropDownList>
                                </td>
                            </tr>
                             <tr>
                        <td style="text-align:right"><b>Centre:</b></td>
                                <td style="text-align:left"> <asp:DropDownList id="ddlCentreAccess1" runat="server" class="ddlCentreAccess1 chosen-select"></asp:DropDownList></td></tr>
                                    <tr> <td style="text-align:left"><asp:TextBox ID="txtedit" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText" Text="0" style="display:none;"></asp:TextBox></td>
                            </tr>  <tr> <td style="text-align:left"><asp:TextBox ID="txtbooked" runat="server" TabIndex="9"  CssClass="ItDoseTextinputText" Text="0" style="display:none;" ></asp:TextBox></td>
                            </tr>
                                 <tr>
                                <td align="right"><b>Investigation:</b></td>
                                <td colspan="3" align="left">
                                    <asp:DropDownList ID="ddltest" TabIndex="12" class="ddltest chosen-select" runat="server" Width="300px"></asp:DropDownList>
                                    &nbsp;&nbsp;
                                    <input type="button" id="btnadd" value="Add" style="padding:5px;border-radius:10px;cursor:pointer;background-color:chocolate;color:white;font-weight:bold;" onclick="addme()" />

                                    &nbsp;&nbsp;

                                 <b> TotalAmt::</b>&nbsp;   <span id="lblamt" style="font-weight:bold;" ></span>
                                </td>
                            </tr>
                             <tr>
                                 <td colspan="4" align="center">
                                     <div id="scdiv" style="width:80%;height:70px;overflow:scroll;">
                                     <table id="testtable" frame="box" border="1" rules="all" width="70%" style="background-color:#c8fa87;"></table></div>
                                 </td>
                                 </tr>
                            <tr>
                                <td colspan="4" align="center">
                                    <input type="button" id="btnhColl" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" />
                                     <input tabindex="11" type="button" id="btnsaveslot"  style="display:none;font-weight:bold;padding:5px;border-radius:10px;background-color:blue;color:white;cursor:pointer;" value="Save Data" onclick="savealldata()"  /> 
                                </td>
                            </tr>
                             <tr>
                                <td colspan="4" align="center">
                                     <div id="PatientLabSearchOutput" style="width:890px; height:200px;overflow:scroll;border:1px solid darkred;"></div>
                                    </td>
                                 </tr>
                        </table>
                        
                    </div>
                    </div>
           
        </div>
    </asp:Panel>
  <cc1:ModalPopupExtender ID="modelurgent" runat="server" CancelControlID="btncloseurgent" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="paneldata">
    </cc1:ModalPopupExtender>

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
               <td><b>Current Phlebot::</b></td>
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
                         <asp:Image ID="Image1" runat="server" ImageUrl="../../App_Images/ew_calendar.gif"  />
                                <cc1:CalendarExtender runat="server" ID="CalendarExtender1" OnClientDateSelectionChanged="checkDate1"
                                        TargetControlID="txtredate"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="Image1" />
                   </td>
                   <td><b>Select Time::</b></td>
                   <td>

                       <asp:DropDownList ID="ddlretimeslot" runat="server" />
                   </td>
                  </tr>

            <tr>
               <td><b>Select Phlebot::</b></td> 
                <td colspan="3">
                    <asp:DropDownList ID="ddlphe" class="ddlphe chosen-select chosen-container"  runat="server" Width="250px"></asp:DropDownList>
                </td>
                </tr><tr>
            <td ><b>Centre:</b></td>
                                 <td> <asp:DropDownList id="ddlCentreAccess2" class="ddlCentreAccess2 chosen-select chosen-container" disabled="disabled" runat="server" >
                        </asp:DropDownList></td></tr>
           <tr>
               <td><b>Remarks::</b></td> 
                <td colspan="3">
                    <asp:TextBox ID="txtreremarks" runat="server" Width="300px" onkeyup="up(this)" ></asp:TextBox>
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

    <asp:Panel ID="pnloldpatient" runat="server" BackColor="#ffff66" BorderStyle="None" style="display:none" >
          <div class="Outer_Box_Inventory" style="width: 700px; color:green">
                <div class="Purchaseheader" style="color:#f00">
                    Old Patient Detail
                    </div>
               <div class="Outer_Box_Inventory" style="width: 700px;min-height:80px;max-height:300px;overflow:scroll;">
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
    
    
    
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tb_grdLabSearch" width="99%" style="table-layout:fixed;border:1px solid darkred;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" >S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="word-wrap:break-word;white-space:normal" >AppDateTime</th>
            <th class="GridViewHeaderStyle" scope="col" style="word-wrap:break-word;white-space:normal">PName</th>
             <th class="GridViewHeaderStyle" scope="col" style="word-wrap:break-word;white-space:normal">PInfo</th>
			<th class="GridViewHeaderStyle" scope="col" style="word-wrap:break-word;white-space:normal">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="word-wrap:break-word;white-space:normal">EmailID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;word-wrap:break-word;white-space:normal">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;word-wrap:break-word;white-space:normal" >Test</th>
            <th class="GridViewHeaderStyle" scope="col" >Amt</th>
            <th class="GridViewHeaderStyle" scope="col" width="30px" >Edit</th>
             <th class="GridViewHeaderStyle" scope="col" width="30px" title="Reshedule" >RS</th>
            <th class="GridViewHeaderStyle" scope="col" >Print</th>
			<th class="GridViewHeaderStyle" scope="col" >Cancel</th>
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
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.appdate#>&nbsp;<#=objRow.apptime#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.PatientName#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.pinfo#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.Mobile#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.EmailID#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.Address#></td>
<td class="GridViewLabItemStyle" style="word-wrap:break-word;white-space:normal"><#=objRow.mytest#></td>
<td class="GridViewLabItemStyle"><#=objRow.TotalAmt#></td>
    <td class="GridViewLabItemStyle">
        <# if(objRow.Iscancel=='0')
        { #>
 <img src='../../App_Images/edit.png'  style='border:none;cursor:pointer;' onclick="editme('<#=objRow.id#>')"/>
<#}#>
</td>
    <td class="GridViewLabItemStyle" width="30px" align="center">
        <# if(objRow.Iscancel=='0')
        { #>
 <img src='../../App_Images/reload.jpg'  style='border:none;cursor:pointer;' onclick="openshepopup('<#=objRow.id#>','<#=objRow.IsBooked#>')"/>
<#}#>
</td>
    <td class="GridViewLabItemStyle" width="40px" align="center">
        <%--<a href='HomecollectionslotwiseReceipt.aspx?ID=<#=objRow.id#>'>Print</a>--%>
        <img src="../../App_Images/folder.gif" style="border-style: none;cursor:pointer;" onclick="receiptreprint('<#=objRow.id#>')"/>
    </td>
<td class="GridViewLabItemStyle" width="30px" align="center">
     <# if(objRow.Iscancel=='0')
        { #>
 <img src='../../App_Images/Delete.gif'  style='border:none;cursor:pointer;' onclick="opencncelpoup('<#=objRow.id#>')"/>
    <#}
    else
    {
    #>
    <span style="font-weight:bold;color:blue;" title="<#=objRow.cancelreason#>"><img src='../../App_Images/Red.jpg'  style='border:none;cursor:pointer;' onclick="opencncelpoup('<#=objRow.id#>')"/></span>
    <#}#>
</td>

</tr>
         
            

            <#}#>

</table>
           
           
    </script>


</asp:Content>

