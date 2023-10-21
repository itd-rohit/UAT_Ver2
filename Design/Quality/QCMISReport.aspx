<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCMISReport.aspx.cs" Inherits="Design_Quality_QCMISReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
     <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>

      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <style type="text/css">
          .chosen-container {width:300px  !important;}

        </style>
		 <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 


     <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>QC Monthly MIS Report</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr><td style="font-weight: 700">Report Type :</td>

                        <td>
                            <asp:RadioButtonList ID="rd" runat="server" onchange="setreporttype();" RepeatDirection="Horizontal" style="font-weight: 700"> 
                                <asp:ListItem value="1">Month Wise Single Lab Report</asp:ListItem>
                                <asp:ListItem value="2">Month Wise All Lab Report</asp:ListItem>
                                <asp:ListItem value="3">Day Wise Single Lab Point Report</asp:ListItem>
                                <asp:ListItem value="4">Day Wise All Lab Point Report</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    </table>
                </div>
               </div>

         <div id="labwise" style="display:none;">
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                         <td style="font-weight: 700">Centre :</td>
                          <td><asp:DropDownList ID="ddlprocessinglab" runat="server" class="ddlprocessinglab chosen-select chosen-container" Width="380" onchange="bindMachine();">
                             </asp:DropDownList> &nbsp; <strong>Machine  :&nbsp; </strong>
                              <asp:DropDownList ID="ddlMachine" runat="server" class="ddlMachine chosen-select chosen-container" Width="250" onchange="bindcontrol()" >
                           

                          </asp:DropDownList>&nbsp; <strong>Control/Lot Number :&nbsp; </strong>
                              <asp:DropDownList ID="ddlcontrol" runat="server" class="ddlcontrol chosen-select chosen-container" Width="300" onchange="bindparameter()" >
                           
                          
                                 
                          </asp:DropDownList>
                          </td>

                    </tr>
                       <tr>
                         <td style="font-weight: 700">Parameter :</td>
                          <td>
                              <asp:DropDownList ID="ddlparameter" runat="server" class="ddlparameter chosen-select chosen-container" Width="300"  >
                              </asp:DropDownList>
                             <asp:DropDownList ID="ddllevel" runat="server"  Width="145"  style="display:none;">
                              </asp:DropDownList>
                              
                              <strong>&nbsp;&nbsp;&nbsp;
                                  Year :</strong>
                                  <asp:DropDownList ID="ddlyear" runat="server"  Width="100px"></asp:DropDownList>
                                  
                                    <strong>&nbsp;&nbsp;&nbsp; From Month :</strong>&nbsp;&nbsp;
                               <asp:DropDownList ID="ddlfrommonth" runat="server" Width="100px"></asp:DropDownList>
                       
                          &nbsp; <strong>To Month :</strong>
                            <asp:DropDownList ID="ddltomonth" runat="server" Width="100px"></asp:DropDownList>
                              
                         </td>

                    </tr>

                       <tr>
                         <td style="font-weight: 700" colspan="2" align="center"><input type="button" value="Show Data" class="searchbutton" onclick="searchme()" />
                             &nbsp;&nbsp;
                             <input type="button" value="Export To Excel" onclick="searchmeexcel()" class="searchbutton" id="btnexcel" style="display:none;" />
                         </td>

                    </tr>

                    </table>
                </div>

         </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div id="showData" style="height:360px;overflow:auto;">
            </div>
                </div>
              </div>

          </div>

         <div id="monthwise" style="display:none;">

              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">Centre :</td>
                        <td>
                            <asp:ListBox ID="lstcentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="370px" ></asp:ListBox>
                        </td>

                        <td>
                           <b>Year :</b> <asp:DropDownList ID="ddlyearmonthwise" runat="server" Width="100px"></asp:DropDownList> 

                            <b>From Month :</b>  <asp:DropDownList ID="ddlmonthmonthwise" runat="server" Width="100px"></asp:DropDownList>

                            <b>To Month :</b>  <asp:DropDownList ID="ddlmonthmonthwiseto" runat="server" Width="100px"></asp:DropDownList>

                        </td>

                        <td>
                            <input type="button" value="Show Data" class="searchbutton" onclick="searchmemonthwise()" />
                             &nbsp;&nbsp;
                             <input type="button" value="Export To Excel" onclick="searchmeexcelmonthwise()" class="searchbutton" id="btnexcelmonthwise" style="display:none;" />
                        </td>
                    </tr>
                    </table>
                </div>
                  </div>


              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div id="showdatamonthwise" style="height:360px;overflow:auto;">
            </div>
                </div>
              </div>

          </div>

        

         <div id="daywise" style="display:none;">

             <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                         <td style="font-weight: 700">Centre :</td>
                          <td><asp:DropDownList ID="ddlprocessinglab1" runat="server" class="ddlprocessinglab1 chosen-select chosen-container" Width="380" onchange="bindMachine1()">
                           </asp:DropDownList> &nbsp; <strong>Machine  :&nbsp; </strong>
                              <asp:DropDownList ID="ddlMachine1" runat="server" class="ddlMachine chosen-select chosen-container" Width="250" onchange="bindcontrol1()" >
                          </asp:DropDownList>&nbsp; <strong>Control/Lot Number :&nbsp; </strong>
                              <asp:DropDownList ID="ddlcontrol1" runat="server" class="ddlcontrol1 chosen-select chosen-container" Width="600" onchange="bindparameter1()" >
                           
                          </asp:DropDownList>
                          </td>

                    </tr>
                       <tr>
                         <td style="font-weight: 700">Parameter :</td>
                          <td>
                              <asp:DropDownList ID="ddlparameter11" runat="server" class="ddlparameter1 chosen-select chosen-container" Width="300"  >
                              </asp:DropDownList>
                           
                              
                            
                                  
                                    <strong>&nbsp;&nbsp;&nbsp; From Date :</strong>&nbsp;&nbsp;
                             <asp:TextBox ID="txtfromdate" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                               <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>


                          &nbsp; <strong>To Date :</strong>
                             <asp:TextBox ID="txttodate" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                                 <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                              
                         </td>

                    </tr>

                       <tr>
                         <td style="font-weight: 700" colspan="2" align="center"><input type="button" value="Show Data" class="searchbutton" onclick="searchmedaywise()" />
                             &nbsp;&nbsp;
                             <input type="button" value="Export To Excel" onclick="searchmeexceldaywise()" class="searchbutton" id="btnexceldaywise" style="display:none;" />
                         </td>

                    </tr>

                    </table>
                </div>

         </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div id="showdatadaywise" style="height:360px;overflow:auto;">
            </div>
                </div>
              </div>
         </div>


           <div id="daywiseall" style="display:none;">
         

                <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">Centre :</td>
                        <td>
                            <asp:ListBox ID="lstcenterday" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="370px" ></asp:ListBox>
                        </td>

                        <td>
                         <strong>&nbsp;&nbsp;&nbsp; From Date :</strong>&nbsp;&nbsp;
                             <asp:TextBox ID="txtdatefromday" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                               <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtdatefromday" PopupButtonID="txtdatefromday" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>


                          &nbsp; <strong>To Date :</strong>
                             <asp:TextBox ID="txtdatetoday" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                                 <cc1:CalendarExtender ID="CalendarExtender2" PopupButtonID="txtdatetoday" TargetControlID="txtdatetoday" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>

                        </td>

                        <td>
                            <input type="button" value="Show Data" class="searchbutton" onclick="searchmedaywiseall()" />
                             &nbsp;&nbsp;
                             <input type="button" value="Export To Excel" onclick="searchmeexceldaywiseall()" class="searchbutton" id="btnexceldaywiseall" style="display:none;" />
                        </td>
                    </tr>
                    </table>
                </div>
                  </div>


              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div id="showdatadaywiseall" style="height:360px;overflow:auto;">
            </div>
                </div>
              </div>
          </div>
         <script type="text/javascript">

             function setreporttype() {
                 if ($("#<%=rd.ClientID%>").find(":checked").val() == "1") {
                     $('#labwise').show();
                     $('#monthwise').hide();
                     $('#daywise').hide();
                     $('#daywiseall').hide();
                 }
                 else if ($("#<%=rd.ClientID%>").find(":checked").val() == "2") {
                     $('#labwise').hide();
                     $('#monthwise').show();
                     $('#daywise').hide();
                     $('#daywiseall').hide();
                 }
                 else if ($("#<%=rd.ClientID%>").find(":checked").val() == "3") {
                     $('#labwise').hide();
                     $('#monthwise').hide();
                     $('#daywise').show();
                     $('#daywiseall').hide();
                 }
                 else if ($("#<%=rd.ClientID%>").find(":checked").val() == "4") {
                     $('#labwise').hide();
                     $('#monthwise').hide();
                     $('#daywise').hide();
                     $('#daywiseall').show();
                 }
             }
             $(document).ready(function () {
                 $('[id=<%=lstcentre.ClientID%>]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });

                 $('[id=<%=lstcenterday.ClientID%>]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 
             });
               
         </script>

          <script type="text/javascript">
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

              $(document).ready(function () {
                  var config = {
                      '.chosen-select': {},
                      '.chosen-select-deselect': { allow_single_deselect: true },
                      '.chosen-select-no-single': { disable_search_threshold: 10 },
                      '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                      '.chosen-select-width': { width: "95%" }
                  }
                  for (var selector in config) {
                      jQuery(selector).chosen(config[selector]);
                  }


                  bindcontrol();
                  bindcontrol1();

              });
              function bindcontrol() {

                  var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                  var MachineId = $('#<%=ddlMachine.ClientID%>').val();
                  jQuery('#<%=ddlcontrol.ClientID%> option').remove();
                  $('#<%=ddlcontrol.ClientID%>').trigger('chosen:updated');

                  if (labid != "0" && labid != null) {


                      $.blockUI();
                      $.ajax({
                          url: "Qcmisreport.aspx/bindcontrol",
                          data: '{labid: "' + labid + '",MachineId: "' + MachineId + '"}',
                          type: "POST", // data has to be Posted    	        
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,

                          dataType: "json",
                          success: function (result) {

                              CentreLoadListData = $.parseJSON(result.d);
                              if (CentreLoadListData.length == 0) {
                                  showerrormsg("No Control Found");
                              }

                              jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control"));
                              for (i = 0; i < CentreLoadListData.length; i++) {

                                  jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].controlid).html(CentreLoadListData[i].controlname));
                              }

                              $("#<%=ddlcontrol.ClientID%>").trigger('chosen:updated');





                              $.unblockUI();
                          },
                          error: function (xhr, status) {
                              //  alert(status + "\r\n" + xhr.responseText);
                              window.status = status + "\r\n" + xhr.responseText;
                              $.unblockUI();
                          }
                      });
                  }
              }


              function bindMachine() {

                  var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                   jQuery('#<%=ddlMachine.ClientID%> option').remove();
                   $('#<%=ddlMachine.ClientID%>').trigger('chosen:updated');

                   if (labid != "0" && labid != null && labid != "") {


                       $.blockUI();
                       $.ajax({
                           url: "QCReport.aspx/bindMachine",
                           data: '{labid: "' + labid + '"}',
                           type: "POST", // data has to be Posted    	        
                           contentType: "application/json; charset=utf-8",
                           timeout: 120000,

                           dataType: "json",
                           success: function (result) {

                               var CentreMachineListData = $.parseJSON(result.d);
                               if (CentreMachineListData.length == 0) {
                                   showerrormsg("No Control Found");
                               }

                               jQuery("#<%=ddlMachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Machine"));
                        for (i = 0; i < CentreMachineListData.length; i++) {

                            jQuery("#<%=ddlMachine.ClientID%>").append(jQuery('<option></option>').val(CentreMachineListData[i].MacID).html(CentreMachineListData[i].machinename));
                        }

                        $("#<%=ddlMachine.ClientID%>").trigger('chosen:updated');





                        $.unblockUI();
                    },
                    error: function (xhr, status) {
                        //  alert(status + "\r\n" + xhr.responseText);
                        window.status = status + "\r\n" + xhr.responseText;
                        $.unblockUI();
                    }
                });
            }
        }

              function bindparameter() {

                  var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                  var controlid = $('#<%=ddlcontrol.ClientID%>').val();
                  jQuery('#<%=ddlparameter.ClientID%> option').remove();
                  $('#<%=ddlparameter.ClientID%>').trigger('chosen:updated');

                  if (controlid != "0" && controlid != null) {
                      $.blockUI();
                      $.ajax({
                          url: "QCReport.aspx/bindparameter",
                          data: '{labid: "' + labid + '",controlid:"' + controlid + '"}',
                          type: "POST", // data has to be Posted    	        
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,

                          dataType: "json",
                          success: function (result) {

                              CentreLoadListData = $.parseJSON(result.d);
                              if (CentreLoadListData.length == 0) {
                                  showerrormsg("No Parameter Found");
                              }
                              jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Parameter"));
                              for (i = 0; i < CentreLoadListData.length; i++) {
                                  jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].LabObservation_Name));
                              }
                              $("#<%=ddlparameter.ClientID%>").trigger('chosen:updated');
                              $.unblockUI();
                          },
                          error: function (xhr, status) {
                              //  alert(status + "\r\n" + xhr.responseText);
                              window.status = status + "\r\n" + xhr.responseText;
                              $.unblockUI();
                          }
                      });
                  }
              }



              function bindlevel() {

                  var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                  var controlid = $('#<%=ddlcontrol.ClientID%>').val();
                  var LabObservation_ID = $('#<%=ddlparameter.ClientID%>').val();
                  jQuery('#<%=ddllevel.ClientID%> option').remove();
                  $('#<%=ddllevel.ClientID%>').trigger('chosen:updated');

                  if (LabObservation_ID != "0" && LabObservation_ID != null) {
                      $.blockUI();
                      $.ajax({
                          url: "QCReport.aspx/bindlevel",
                          data: '{labid: "' + labid + '",controlid:"' + controlid + '",LabObservation_ID:"' + LabObservation_ID + '"}',
                          type: "POST", // data has to be Posted    	        
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,

                          dataType: "json",
                          success: function (result) {

                              CentreLoadListData = $.parseJSON(result.d);
                              if (CentreLoadListData.length == 0) {
                                  showerrormsg("No Level Found");
                              }
                              if (CentreLoadListData.length > 1) {
                                  jQuery("#<%=ddllevel.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Level"));
                              }
                              for (i = 0; i < CentreLoadListData.length; i++) {
                                  jQuery("#<%=ddllevel.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].levelid).html(CentreLoadListData[i].LEVEL));
                              }
                              $("#<%=ddllevel.ClientID%>").trigger('chosen:updated');
                              $.unblockUI();
                          },
                          error: function (xhr, status) {
                              //  alert(status + "\r\n" + xhr.responseText);
                              window.status = status + "\r\n" + xhr.responseText;
                              $.unblockUI();
                          }
                      });
                  }
              }

         </script>

         <script type="text/javascript">
             function searchme() {



                 var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
                 var controlid = $('#<%=ddlcontrol.ClientID%>').val();
                 var parameterid = $('#<%=ddlparameter.ClientID%>').val();
                 var levelid = $('#<%=ddllevel.ClientID%>').val();
                 var MachineId = $('#<%=ddlMachine.ClientID%>').val();
              

                 if (labid == "0" || labid == null) {
                     showerrormsg("Please Select Centre");
                     return;
                 }

                 if (controlid == "0" || controlid == null) {
                     controlid = "";
                 }
                 if (MachineId == "0" || MachineId == null) {
                     MachineId = "";
                 }
                 if (parameterid == "0" || parameterid == null) {
                     parameterid = "";
                 }
                 if (levelid == "0" || levelid == null) {
                     levelid = "";
                 }
                 if (parseInt($('#<%=ddlfrommonth.ClientID%>').val()) > parseInt($('#<%=ddltomonth.ClientID%>').val())) {
                     showerrormsg("Please Select Proper Month");
                     return;
                 }

                 $('#showData').empty();
                 $.blockUI();
                 $.ajax({
                     url: "Qcmisreport.aspx/GetMonthlyReport",
                     data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",year:"' + $('#<%=ddlyear.ClientID%>').val() + '",frommonth:"' + $('#<%=ddlfrommonth.ClientID%> option:selected').text() + '",tomonth:"' + $('#<%=ddltomonth.ClientID%>  option:selected').text() + '",frommonthint:"' + $('#<%=ddlfrommonth.ClientID%>').val() + '",tomonthint:"' + $('#<%=ddltomonth.ClientID%>').val() + '",machineId:"' + MachineId + '"}',
                     contentType: "application/json; charset=utf-8",
                     type: "POST", // data has to be Posted 
                     timeout: 120000,
                     dataType: "json",

                     success: function (result) {
                         var ItemData = jQuery.parseJSON(result.d);

                         if (ItemData.length == 0) {
                             showerrormsg("No Data Found");
                             $('#btnexcel').hide();
                         }
                         else {
                             var table = $.makeTable(ItemData);
                             $(table).appendTo("#showData");
                             $('#btnexcel').show();
                         }
                         $.unblockUI();


                     },
                     error: function (xhr, status) {
                         $.unblockUI();
                         alert(xhr.responseText);
                     }
                 });
             }


             $.makeTable = function (mydata) {
                 var table = $('<table style="border-collapse:collapse;text-align:left;" id="tblLedger">');

              

                 var controlname = "";
                 var labobsname = "";
                 $.each(mydata, function (index, value) {

                     if (controlname != mydata[index].ControlName) {
                         var newheader = "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Month_Year</b></td><td colspan='7'><b>" + mydata[index].daterang + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>NAME OF THE LAB</b></td><td colspan='7'><b>" + mydata[index].Centre + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>DISCIPLINE</b></td><td colspan='7'><b>" + mydata[index].Department + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Provider<b></td><td  colspan='7'><b>" + mydata[index].ControlProvider + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Name<b></td><td colspan='7'><b>" + mydata[index].ControlName + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Lot Number and Expiry<b></td><td colspan='7'><b>" + mydata[index].LotNumber + "&nbsp;&nbsp;&nbsp;&nbsp;" + mydata[index].LotExpiry + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Machine Name</b></td><td colspan='7'><b>" + mydata[index].MachineName + "</b></td></tr>";
                         controlname = mydata[index].ControlName;
                         labobsname = "";
                         $(table).append(newheader);
                         var tblHeader = "<tr id='trheader'>";
                         var a = 0;
                         for (var k in mydata[0]) {

                           if (a > 7) {
                                 tblHeader += "<th class='GridViewHeaderStyle'><b>" + k + "</b></th>";
                             }
                             a++;
                         }
                         tblHeader += "</tr>";


                         $(tblHeader).appendTo(table);


                     }
                     var TableRow = "<tr style='background-color:#cbefcb;'>";
                     var b = 0;
                     
                     $.each(value, function (key, val) {

                         if (b >7) {
                             if (b == 8) {
                                 if (labobsname != val) {
                                     TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'><b>" + val + "</b></td>";
                                     labobsname = val;
                                 }
                                 else {
                                     TableRow += "<td class='GridViewLabItemStyle' style='border-left:0.5px solid gray;border-right:0.5px solid gray;' ></td>";
                                 }
                             }
                             else {
                                 TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'>" + val + "</td>";
                             }
                         }
                         b++;
                     });


                     TableRow += "</tr>";
                     $(table).append(TableRow);
                 });
                 return ($(table));
             };

             function searchmeexcel() {

                 $("#tblLedger").table2excel({
                     name: "MonthWiseSingleLabReport",
                     filename: "MonthWiseSingleLabReport", //do not include extension
                     exclude_inputs: false
                 });
             }

         </script>

    <script type="text/javascript">
        function searchmemonthwise() {
            var centreid = $('#<%=lstcentre.ClientID%>').val();
            if (centreid == "") {
                showerrormsg("Please Select Centre");
                return;
            }
            var dataIm = new Array();
            $('#<%=lstcentre.ClientID%> > option:selected').each(function () {
             
                dataIm.push($(this).val()+'#'+$(this).text());
            });


            if (parseInt($('#<%=ddlmonthmonthwise.ClientID%>').val()) > parseInt($('#<%=ddlmonthmonthwiseto.ClientID%>').val())) {
                showerrormsg("Please Select Proper Month");
                return;
            }

            $('#showdatamonthwise').empty();
            $.blockUI();
            $.ajax({
                url: "Qcmisreport.aspx/GetMonthlyReportMontWise",
                data: JSON.stringify({ labid: dataIm, year: $('#<%=ddlyearmonthwise.ClientID%>').val(), frommonth: $('#<%=ddlmonthmonthwise.ClientID%> option:selected').text(), frommonthint: $('#<%=ddlmonthmonthwise.ClientID%>').val(), tomonth: $('#<%=ddlmonthmonthwiseto.ClientID%> option:selected').text(), tomonthint: $('#<%=ddlmonthmonthwiseto.ClientID%>').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $('#btnexcelmonthwise').hide();
                    }
                    else {
                        var table = $.makeTablemonthwise(ItemData);
                        $(table).appendTo("#showdatamonthwise");
                        $('#btnexcelmonthwise').show();
                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert(xhr.responseText);
                }
            });
        }


        $.makeTablemonthwise = function (mydata) {
            var table = $('<table style="border-collapse:collapse;text-align:left;" id="tblLedgermonthwise">');



            var controlname = "";
            var labobsname = "";
            $.each(mydata, function (index, value) {

                if (controlname != mydata[index].ControlName) {
                    var newheader = "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Month_Year</b></td><td colspan='7'><b>" + mydata[index].daterang + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>DISCIPLINE</b></td><td colspan='7'><b>" + mydata[index].Department + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Provider<b></td><td  colspan='7'><b>" + mydata[index].ControlProvider + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Name<b></td><td colspan='7'><b>" + mydata[index].ControlName + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Lot Number and Expiry<b></td><td colspan='7'><b>" + mydata[index].LotNumber + "&nbsp;&nbsp;&nbsp;&nbsp;" + mydata[index].LotExpiry + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Machine Name</b></td><td colspan='7'><b>" + mydata[index].MachineName + "</b></td></tr>";
                    controlname = mydata[index].ControlName;
                    labobsname = "";
                    $(table).append(newheader);
                    var tblHeader = "<tr id='trheader'>";
                    var a = 0;
                    for (var k in mydata[0]) {

                        if (a > 6) {
                            tblHeader += "<th class='GridViewHeaderStyle'><b>" + k + "</b></th>";
                        }
                        a++;
                    }
                    tblHeader += "</tr>";


                    $(tblHeader).appendTo(table);


                }
                var TableRow = "<tr style='background-color:#cbefcb;'>";
                var b = 0;

                $.each(value, function (key, val) {

                    if (b > 6) {
                        if (b == 7) {
                            if (labobsname != val) {
                                TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'><b>" + val + "</b></td>";
                                labobsname = val;
                            }
                            else {
                                TableRow += "<td class='GridViewLabItemStyle' style='border-left:0.5px solid gray;border-right:0.5px solid gray;' ></td>";
                            }
                        }
                        else {
                            TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'>" + val + "</td>";
                        }
                    }
                    b++;
                });


                TableRow += "</tr>";
                $(table).append(TableRow);
            });
            return ($(table));
        };

        function searchmeexcelmonthwise() {

            $("#tblLedgermonthwise").table2excel({
                name: "MonthWiseAllLabReport",
                filename: "MonthWiseAllLabReport", //do not include extension
                exclude_inputs: false
            });
        }

    </script>


    <script type="text/javascript">
        function bindMachine1() {

            var labid = $('#<%=ddlprocessinglab1.ClientID%>').val();
             jQuery('#<%=ddlMachine1.ClientID%> option').remove();
             $('#<%=ddlMachine1.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null && labid != "") {


                 $.blockUI();
                 $.ajax({
                     url: "QCReport.aspx/bindMachine",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         var CentreMachineListData = $.parseJSON(result.d);
                         if (CentreMachineListData.length == 0) {
                             showerrormsg("No Control Found");
                         }

                         jQuery("#<%=ddlMachine1.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Machine"));
                               for (i = 0; i < CentreMachineListData.length; i++) {

                                   jQuery("#<%=ddlMachine1.ClientID%>").append(jQuery('<option></option>').val(CentreMachineListData[i].MacID).html(CentreMachineListData[i].machinename));
                        }

                               $("#<%=ddlMachine1.ClientID%>").trigger('chosen:updated');





                               $.unblockUI();
                           },
                           error: function (xhr, status) {
                               //  alert(status + "\r\n" + xhr.responseText);
                               window.status = status + "\r\n" + xhr.responseText;
                               $.unblockUI();
                           }
                       });
                   }
               }
        function bindcontrol1() {

            var labid = $('#<%=ddlprocessinglab1.ClientID%>').val();
            var MachineId1 = $('#<%=ddlMachine1.ClientID%>').val();
             jQuery('#<%=ddlcontrol1.ClientID%> option').remove();
             $('#<%=ddlcontrol1.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null) {


                 $.blockUI();
                 $.ajax({
                     url: "Qcmisreport.aspx/bindcontrol",
                     data: '{labid: "' + labid + '",MachineId: "' + MachineId1 + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Control Found");
                         }

                         jQuery("#<%=ddlcontrol1.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control"));
                              for (i = 0; i < CentreLoadListData.length; i++) {

                                  jQuery("#<%=ddlcontrol1.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].controlid).html(CentreLoadListData[i].controlname));
                              }

                              $("#<%=ddlcontrol1.ClientID%>").trigger('chosen:updated');





                              $.unblockUI();
                          },
                          error: function (xhr, status) {
                              //  alert(status + "\r\n" + xhr.responseText);
                              window.status = status + "\r\n" + xhr.responseText;
                              $.unblockUI();
                          }
                      });
                  }
              }



              function bindparameter1() {

                  var labid = $('#<%=ddlprocessinglab1.ClientID%>').val();
                  var controlid = $('#<%=ddlcontrol1.ClientID%>').val();
                  jQuery('#<%=ddlparameter11.ClientID%> option').remove();
                  $('#<%=ddlparameter11.ClientID%>').trigger('chosen:updated');

                  if (controlid != "0" && controlid != null) {
                      $.blockUI();
                      $.ajax({
                          url: "QCReport.aspx/bindparameter",
                          data: '{labid: "' + labid + '",controlid:"' + controlid + '"}',
                          type: "POST", // data has to be Posted    	        
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,

                          dataType: "json",
                          success: function (result) {

                              CentreLoadListData = $.parseJSON(result.d);
                              if (CentreLoadListData.length == 0) {
                                  showerrormsg("No Parameter Found");
                              }
                              jQuery("#<%=ddlparameter11.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Parameter"));
                              for (i = 0; i < CentreLoadListData.length; i++) {
                                  jQuery("#<%=ddlparameter11.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].LabObservation_Name));
                              }
                              $("#<%=ddlparameter11.ClientID%>").trigger('chosen:updated');
                              $.unblockUI();
                          },
                          error: function (xhr, status) {
                              //  alert(status + "\r\n" + xhr.responseText);
                              window.status = status + "\r\n" + xhr.responseText;
                              $.unblockUI();
                          }
                      });
                  }
              }



      
    </script>


    <script type="text/javascript">
        function searchmedaywise() {



            var labid = $('#<%=ddlprocessinglab1.ClientID%>').val();
            var MachineId = $('#<%=ddlMachine1.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol1.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter11.ClientID%>').val();
            var levelid = "";


            if (labid == "0" || labid == null) {
                showerrormsg("Please Select Centre");
                return;
            }
            if (MachineId == "0" || MachineId == null) {
                MachineId = "";
            }
            if (controlid == "0" || controlid == null) {
                controlid = "";
            }
            if (parameterid == "0" || parameterid == null) {
                parameterid = "";
            }
            if (levelid == "0" || levelid == null) {
                levelid = "";
            }


            if (new Date($('#<%=txtfromdate.ClientID%>').val()) > new Date($('#<%=txttodate.ClientID%>').val())) {
                $('#<%=txttodate.ClientID%>').focus();
                showerrormsg("Please Select Proper Date");
                return;
            }

            var diff = new Date($('#<%=txttodate.ClientID%>').val()) - new Date($('#<%=txtfromdate.ClientID%>').val());


            var days = diff / 1000 / 60 / 60 / 24;
            if (days > 31) {
                showerrormsg("Maximum 31 Days Data Allowed");
                return;
            }

            $('#showdatadaywise').empty();
            $.blockUI();
            $.ajax({
                url: "Qcmisreport.aspx/GetMonthlyReportDayWise",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",fromdate:"' + $('#<%=txtfromdate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",machineId:"' + MachineId + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $('#btnexceldaywise').hide();
                    }
                    else {
                        var table = $.makeTabledaywise(ItemData);
                        $(table).appendTo("#showdatadaywise");
                        $('#btnexceldaywise').show();
                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert(xhr.responseText);
                }
            });
        }


        $.makeTabledaywise = function (mydata) {
                 var table = $('<table style="border-collapse:collapse;text-align:left;" id="tblLedgerdaywise">');



                 var controlname = "";
                 var labobsname = "";
                 $.each(mydata, function (index, value) {

                     if (controlname != mydata[index].ControlName) {
                         var newheader = "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Date Range</b></td><td colspan='7'><b>" + mydata[index].daterang + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>NAME OF THE LAB</b></td><td colspan='7'><b>" + mydata[index].Centre + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>DISCIPLINE</b></td><td colspan='7'><b>" + mydata[index].Department + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Provider<b></td><td  colspan='7'><b>" + mydata[index].ControlProvider + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Name<b></td><td colspan='7'><b>" + mydata[index].ControlName + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Lot Number and Expiry<b></td><td colspan='7'><b>" + mydata[index].LotNumber + "&nbsp;&nbsp;&nbsp;&nbsp;" + mydata[index].LotExpiry + "</b></td></tr>";
                         newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Machine Name</b></td><td colspan='7'><b>" + mydata[index].MachineName + "</b></td></tr>";
                         controlname = mydata[index].ControlName;
                         labobsname = "";
                         $(table).append(newheader);
                         var tblHeader = "<tr id='trheader'>";
                         var a = 0;
                         for (var k in mydata[0]) {

                             if (a > 7) {
                                 tblHeader += "<th class='GridViewHeaderStyle'><b>" + k + "</b></th>";
                             }
                             a++;
                         }
                         tblHeader += "</tr>";


                         $(tblHeader).appendTo(table);


                     }
                     var TableRow = "<tr style='background-color:#cbefcb;'>";
                     var b = 0;

                     $.each(value, function (key, val) {

                         if (b > 7) {
                             if (b == 8) {
                                 if (labobsname != val) {
                                     TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'><b>" + val + "</b></td>";
                                     labobsname = val;
                                 }
                                 else {
                                     TableRow += "<td class='GridViewLabItemStyle' style='border-left:0.5px solid gray;border-right:0.5px solid gray;' ></td>";
                                 }
                             }
                             else {
                                 TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'>" + val + "</td>";
                             }
                         }
                         b++;
                     });


                     TableRow += "</tr>";
                     $(table).append(TableRow);
                 });
                 return ($(table));
             };

        function searchmeexceldaywise() {

                 $("#tblLedgerdaywise").table2excel({
                     name: "Daywisesinglelabpointdata",
                     filename: "Daywisesinglelabpointdata", //do not include extension
                     exclude_inputs: false
                 });
             }

         </script>



         <script type="text/javascript">
             function searchmedaywiseall() {



                 var centreid = $('#<%=lstcenterday.ClientID%>').val();
                 if (centreid == "") {
                     showerrormsg("Please Select Centre");
                     return;
                 }
                 var dataIm = new Array();
                 $('#<%=lstcenterday.ClientID%> > option:selected').each(function () {

                dataIm.push($(this).val() + '#' + $(this).text());
            });
           


            if (new Date($('#<%=txtdatefromday.ClientID%>').val()) > new Date($('#<%=txtdatetoday.ClientID%>').val())) {
                $('#<%=txttodate.ClientID%>').focus();
                showerrormsg("Please Select Proper Date");
                return;
            }

            var diff = new Date($('#<%=txtdatefromday.ClientID%>').val()) - new Date($('#<%=txtdatetoday.ClientID%>').val());


            var days = diff / 1000 / 60 / 60 / 24;
            if (days > 31) {
                showerrormsg("Maximum 31 Days Data Allowed");
                return;
            }

            $('#showdatadaywiseall').empty();
            $.blockUI();
            $.ajax({
                url: "Qcmisreport.aspx/GetMonthlyReportDayWiseAll",
                data: JSON.stringify({ labid: dataIm, fromdate: $('#<%=txtdatefromday.ClientID%>').val(), todate: $('#<%=txtdatetoday.ClientID%>').val()}),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $('#btnexceldaywiseall').hide();
                    }
                    else {
                        var table = $.makeTabledaywiseall(ItemData);
                        $(table).appendTo("#showdatadaywiseall");
                        $('#btnexceldaywiseall').show();
                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert(xhr.responseText);
                }
            });
        }


        $.makeTabledaywiseall = function (mydata) {
            var table = $('<table style="border-collapse:collapse;text-align:left;" id="tblLedgerdaywiseall">');



            var controlname = "";
            var labobsname = "";
            $.each(mydata, function (index, value) {

                if (controlname != mydata[index].ControlName) {
                    var newheader = "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Date Range</b></td><td colspan='7'><b>" + mydata[index].daterang + "</b></td></tr>";
                    //newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>NAME OF THE LAB</b></td><td colspan='7'><b>" + mydata[index].Centre + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>DISCIPLINE</b></td><td colspan='7'><b>" + mydata[index].Department + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Provider<b></td><td  colspan='7'><b>" + mydata[index].ControlProvider + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Control Name<b></td><td colspan='7'><b>" + mydata[index].ControlName + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Lot Number and Expiry<b></td><td colspan='7'><b>" + mydata[index].LotNumber + "&nbsp;&nbsp;&nbsp;&nbsp;" + mydata[index].LotExpiry + "</b></td></tr>";
                    newheader += "<tr style='background-color:#f7e2e5'><td colspan='4'><b>Machine Name</b></td><td colspan='7'><b>" + mydata[index].MachineName + "</b></td></tr>";
                    controlname = mydata[index].ControlName;
                    labobsname = "";
                    $(table).append(newheader);
                    var tblHeader = "<tr id='trheader'>";
                    var a = 0;
                    for (var k in mydata[0]) {

                        if (a > 6) {
                            tblHeader += "<th class='GridViewHeaderStyle'><b>" + k + "</b></th>";
                        }
                        a++;
                    }
                    tblHeader += "</tr>";


                    $(tblHeader).appendTo(table);


                }
                var TableRow = "<tr style='background-color:#cbefcb;'>";
                var b = 0;

                $.each(value, function (key, val) {

                    if (b > 6) {
                        if (b ==7) {
                            if (labobsname != val) {
                                TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'><b>" + val + "</b></td>";
                                labobsname = val;
                            }
                            else {
                                TableRow += "<td class='GridViewLabItemStyle' style='border-left:0.5px solid gray;border-right:0.5px solid gray;' ></td>";
                            }
                        }
                        else {
                            TableRow += "<td class='GridViewLabItemStyle' style='border:0.5px solid gray;'>" + val + "</td>";
                        }
                    }
                    b++;
                });


                TableRow += "</tr>";
                $(table).append(TableRow);
            });
            return ($(table));
        };

        function searchmeexceldaywiseall() {

            $("#tblLedgerdaywiseall").table2excel({
                name: "Daywisesinglelabpointdata",
                filename: "Daywisesinglelabpointdata", //do not include extension
                exclude_inputs: false
            });
        }

         </script>
</asp:Content>

