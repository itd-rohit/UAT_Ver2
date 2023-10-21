<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CAPProgramResultEntry.aspx.cs" Inherits="Design_Quality_CAPProgramResultEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

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
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
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
                          <b>CAP Program Result Entry</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                          <td style="font-weight: 700">Processing Lab :</td>
                          <td><asp:DropDownList ID="ddlcentre" runat="server" Width="400px" class="ddlprocessinglab chosen-select chosen-container" onchange="bindshipment()"></asp:DropDownList></td>
                          <td style="font-weight: 700">Shipment No :</td>
                          <td><asp:DropDownList ID="ddlshipment" runat="server" class="ddlshipment chosen-select chosen-container" Width="350px" onchange="bindprogram()"  ></asp:DropDownList>
                          </td>
                    </tr>


                      
                


                    <tr>
                          <td style="font-weight: 700">Program :</td>
                          <td><asp:DropDownList ID="ddlprogram" runat="server" class="ddlprogram chosen-select chosen-container" Width="400px"   ></asp:DropDownList></td>
                        <td style="font-weight: 700">Status :</td>
                          <td style="font-weight: 700">
                              <asp:DropDownList ID="ddlstatus" runat="server">
                                  <asp:ListItem Value="">All</asp:ListItem>
                                   <asp:ListItem Value=" qcpp.CAPDone=0 and qcpp.ResultUploaded=0 and qcpp.Approved=0 and qcpp.result_flag=0 ">Result Not Saved</asp:ListItem>
                                  <asp:ListItem Value="  qcpp.CAPDone=0 and qcpp.ResultUploaded=0 and qcpp.Approved=0 and qcpp.result_flag=1 ">Result Saved</asp:ListItem>
                                    <asp:ListItem Value=" qcpp.CAPDone=0 and qcpp.ResultUploaded=0 and qcpp.Approved=1 ">Result Approved</asp:ListItem>
                                   <asp:ListItem Value=" qcpp.CAPDone=0 and qcpp.ResultUploaded=1 ">Result Uploaded</asp:ListItem>
                                   <asp:ListItem Value=" qcpp.CAPDone=1 ">CAP Done</asp:ListItem>
                                  
                              </asp:DropDownList>
                              &nbsp;&nbsp;
                              <input type="button" value="Search" class="searchbutton" onclick="searchdata()" id="btnadd" />&nbsp;&nbsp;
                              <input type="button" value="Reset" class="resetbutton" onclick="resetme()" /></td>
                    </tr>


                      
                


                    </table>
                </div>
                </div>

            <div class="POuter_Box_Inventory" style="width:1300px;">
         <div class="content">

            
                               <table width="90%">
                <tr>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgoldenrodyellow;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Not Saved</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                 <td>Result Saved</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td>Result Approved</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightsalmon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Uploaded</td>

                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>CAP Done</td>
                    
                </tr>
            </table>
                      
                 


              <div  style="width:1295px; max-height:400px;overflow:auto;">

                    <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 72px;">RegDate</td>
                                        <td class="GridViewHeaderStyle">Department</td>
                              <td class="GridViewHeaderStyle">Visit No</td>
                                        <td class="GridViewHeaderStyle">Sin No</td>
                                       
                                        <td class="GridViewHeaderStyle">Specimen</td>
                                        <td class="GridViewHeaderStyle">Testname</td>
                                        <td class="GridViewHeaderStyle">Observation Name</td>  
                                        <td class="GridViewHeaderStyle">Result</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">Mac Reading</td>
                                        <td class="GridViewHeaderStyle">Machine</td>
                                        <td class="GridViewHeaderStyle">Unit</td>                                        
                                        <td class="GridViewHeaderStyle">S.D.I</td>
                                        <td class="GridViewHeaderStyle">Grade</td>
                                        <td class="GridViewHeaderStyle">Last Status</td>
                                        

                                       
                            </tr>
                            </table>
                  </div>
             </div>
                </div>

            <div class="POuter_Box_Inventory" style="width:1300px;">
         <div class="content" style="text-align:center;">
             <input type="button" value="Save" class="savebutton" id="btnsave" onclick="savedata('0')" style="display:none;"/>

             <input type="button" value="Approved" class="savebutton" id="btnapproved" onclick="savedata('1')" style="display:none;" />


              <input type="button" value="Send Result To CAP"  class="savebutton"  id="btnsend" onclick="savedata('2')" style="display:none;" />

             <input type="button" value="CAP Done"  class="savebutton"  id="btneqasdone" onclick="savedata('3')" style="display:none;" />

             <span style="font-weight:bold;display:none;" id="btnpdfreport1"><input type="checkbox" id="chheader" />Print Header(PDF)</span>&nbsp;
              <input type="button" value="PDF Report"  class="searchbutton"  id="btnpdfreport" onclick="pdfreport()" style="display:none;"  />&nbsp;&nbsp;
               <input type="button" value="Excel Report"  class="searchbutton"  id="btnexcelreport" onclick="excelreport()" style="display:none;"  />


             </div>
               </div>

           </div>


      <script type="text/javascript">

          var cansave = '<%=cansave %>';
          var canapprove = '<%=canapprove %>';
          var canupload = '<%=canupload %>';
          var canfinaldone = '<%=canfinaldone %>';

          $(function () {


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


              bindshipment();

          });



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



          function bindshipment() {


              var labid = $('#<%=ddlcentre.ClientID%>').val();
             jQuery('#<%=ddlshipment.ClientID%> option').remove();
             $('#<%=ddlshipment.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null) {


                 $.blockUI();
                 $.ajax({
                     url: "CAPProgramResultEntry.aspx/bindshipment",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Shipment Found");
                         }

                         jQuery("#<%=ddlshipment.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Shipment No"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlshipment.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].shipmentno).html(CentreLoadListData[i].shipmentno));
                         }

                         $("#<%=ddlshipment.ClientID%>").trigger('chosen:updated');





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


          function bindprogram() {


              var labid = $('#<%=ddlcentre.ClientID%>').val();
              var shipmentno = $('#<%=ddlshipment.ClientID%>').val();
              jQuery('#<%=ddlprogram.ClientID%> option').remove();
              $('#<%=ddlprogram.ClientID%>').trigger('chosen:updated');

              if (shipmentno != "0" && shipmentno != null) {


                  $.blockUI();
                  $.ajax({
                      url: "CAPProgramResultEntry.aspx/bindprogram",
                      data: '{labid: "' + labid + '",shipmentno:"' + shipmentno + '"}',
                      type: "POST", // data has to be Posted    	        
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,

                      dataType: "json",
                      success: function (result) {

                          CentreLoadListData = $.parseJSON(result.d);
                          if (CentreLoadListData.length == 0) {
                              showerrormsg("No Program Found");
                          }

                          jQuery("#<%=ddlprogram.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Program"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlprogram.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].programid).html(CentreLoadListData[i].ProgramName));
                         }

                         $("#<%=ddlprogram.ClientID%>").trigger('chosen:updated');





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
        function searchdata() {

            var length = $('#<%=ddlcentre.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }


            var length1 = $('#<%=ddlshipment.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlshipment.ClientID%>').val() == "0") {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlshipment.ClientID%>').focus();
                return;
            }

            var length1 = $('#<%=ddlprogram.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlprogram.ClientID%>').val() == "0") {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }




            var type = $('#<%=ddlstatus.ClientID%>').val();
            $('#tbl tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "CAPProgramResultEntry.aspx/searchdata",
                data: '{centreid: "' + $('#<%=ddlcentre.ClientID%>').val() + '",shipmentno:"' + $('#<%=ddlshipment.ClientID%>').val() + '",programid:"' + $('#<%=ddlprogram.ClientID%>').val() + '",type:"' + type + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("No Program Found");
                        $.unblockUI();
                        return;
                    }

                    var programname = "";
                    var co = 0;
                    var LedgerTransactionID = "";
                    for (var i = 0; i <= PanelData.length - 1; i++) {
                        co = parseInt(co + 1);
                        var mydata = "";


                        if (programname != PanelData[i].ProgramName) {

                            mydata = "<tr style='background-color:white' id='triteheader1' class='" + PanelData[i].ProgramID + "' name='" + PanelData[i].CentreId + "' title='" + PanelData[i].ShipmentNo + "'><td colspan='16' style='font-weight:bold;'>Shipment No:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].ShipmentNo + "</span>&nbsp;&nbsp;&nbsp;Program ID:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].ProgramID + "</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Program Name:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].ProgramName + "</span>&nbsp;&nbsp;&nbsp;Expected ResultDate:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].ExpectedResultDate + "</span>";

                            if ((PanelData[i].custatus == "ResultUploaded" || PanelData[i].custatus=="CAPDone") &&  PanelData[i].CAPResultFileName == "") {
                                mydata += "<input onclick='openuploadbox(this)' type='button' style='font-weight:bold;cursor:pointer;float:right; background-color: aqua' value='Upload Result'/> ";
                            }

                            if ((PanelData[i].custatus == "ResultUploaded" || PanelData[i].custatus == "CAPDone") && PanelData[i].CAPResultFileName != "") {
                                mydata += "<input onclick='openuploadbox(this)' type='button' style='font-weight:bold;cursor:pointer;float:right; background-color: lightgreen' value='Result Uploaded'/> ";
                            }
                            mydata += "</td></tr>";




                            programname = PanelData[i].ProgramName;
                            co = 1;


                            if (PanelData[i].custatus == "New" && cansave == "1") {
                                $('#btnsave').show();
                                $('#btnapproved').hide();
                                $('#btnsend').hide();
                                $('#btneqasdone').hide();
                                $('#btnexcelreport').hide();
                                $('#btnpdfreport').hide();
                                $('#btnpdfreport1').hide();


                            }
                            if (PanelData[i].custatus == "ResultDone" && canapprove == "1") {
                                $('#btnsave').hide();
                                $('#btnapproved').show();
                                $('#btnsend').hide();
                                $('#btneqasdone').hide();
                                $('#btnexcelreport').hide();
                                $('#btnpdfreport').hide();
                                $('#btnpdfreport1').hide();

                            }
                            if (PanelData[i].custatus == "Approved" && canupload == "1") {
                                $('#btnsave').hide();
                                $('#btnapproved').hide();
                                $('#btnsend').show();
                                $('#btneqasdone').hide();
                                $('#btnexcelreport').hide();
                                $('#btnpdfreport').hide();
                                $('#btnpdfreport1').hide();

                            }
                            if (PanelData[i].custatus == "ResultUploaded" && canfinaldone == "1") {
                                $('#btnsave').hide();
                                $('#btnapproved').hide();
                                $('#btnsend').hide();
                                $('#btneqasdone').show();
                                $('#btnexcelreport').hide();
                                $('#btnpdfreport').hide();
                                $('#btnpdfreport1').hide();

                            }
                            if (PanelData[i].custatus == "CAPDone") {
                                $('#btnsave').hide();
                                $('#btnapproved').hide();
                                $('#btnsend').hide();
                                $('#btneqasdone').hide();
                                $('#btnexcelreport').hide();
                                $('#btnpdfreport').hide();
                                $('#btnpdfreport1').hide();

                            }

                            if (PanelData[i].custatus == "ResultUploaded" || PanelData[i].custatus == "CAPDone") {
                                $('#btnexcelreport').show();
                                $('#btnpdfreport').show();
                                $('#btnpdfreport1').show();

                            }

                            //btnsave  btnapproved btnsend btneqasdone

                        }


                        if (LedgerTransactionID != PanelData[i].LedgerTransactionID) {

                            mydata += "<tr style='background-color:" + PanelData[i].rowcolor + ";border-top:2px solid gray;box-shadow: 0px 0px 10px gray;' id='" + PanelData[i].test_id + "' class='" + PanelData[i].ProgramID + "'  name='" + PanelData[i].ShipmentNo + "'>";
                        }
                        else {
                            mydata += "<tr style='background-color:" + PanelData[i].rowcolor + ";' id='" + PanelData[i].test_id + "' class='" + PanelData[i].ProgramID + "'  name='" + PanelData[i].ShipmentNo + "'>";
                        }

                        mydata += '<td class="GridViewLabItemStyle"  id="srno" style="border: solid 1px lightgray;">' + parseInt(i + 1) + '<input type="checkbox" id="chk" checked="checked" disabled="disabled" style="display:none;"  /></td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].regdate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].departmant + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].visitno + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].sinno + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].Specimen + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].InvestigationName + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;">' + PanelData[i].LabObservationName + '<span id="LabObservationID" style="display: none;">' + PanelData[i].labobservationid + '</span></td>';

                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;" ><input type="text" id="txtvalue" style="width:75px;"  value="' + PanelData[i].ResultValue + '" readonly="readonly"/></td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;" >' + PanelData[i].flag + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;" >' + PanelData[i].MacReading + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;" >' + PanelData[i].MachineName + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px lightgray;" >' + PanelData[i].ReadingFormat + '</td>';
                        if(PanelData[i].custatus == "New" || PanelData[i].custatus == "ResultDone" || PanelData[i].custatus=="Approved")
                        {
                            mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px lightgray;"  ><input type="text" id="txtcapvalue" style="width:75px;display:none;"  value="' + PanelData[i].Acceptability + '"  /></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px lightgray;">';
                            mydata += '<select id="ddlstatus" style="width: 112px;display:none;">';
                            mydata += '<option value="" selected="selected"></option> ';
                            mydata += '<option value="Acceptable">Acceptable</option> ';
                            mydata += '<option value="NotAcceptable">NotAcceptable</option> ';
                            mydata += '</select></td>';
                        }
                        else{
                            mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px lightgray;"  ><input type="text" id="txtcapvalue" style="width:75px;"  value="' + PanelData[i].Acceptability + '" /></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px lightgray;">';
                            mydata += '<select id="ddlstatus" style="width: 112px">';
                            if (PanelData[i].Grade == "") {
                                mydata += '<option value="" selected="selected"></option> ';
                                mydata += '<option value="Acceptable">Acceptable</option> ';
                                mydata += '<option value="NotAcceptable">NotAcceptable</option> ';
                            }
                            else if (PanelData[i].Grade == "Acceptable") {
                                mydata += '<option value="" ></option> ';
                                mydata += '<option value="Acceptable" selected="selected">Acceptable</option> ';
                                mydata += '<option value="NotAcceptable">NotAcceptable</option> ';
                            }
                            else if (PanelData[i].Grade == "NotAcceptable") {
                                mydata += '<option value="" ></option> ';
                                mydata += '<option value="Acceptable">Acceptable</option> ';
                                mydata += '<option value="NotAcceptable" selected="selected">NotAcceptable</option> ';
                            }
                            mydata += '</select></td>';

                        }
                        if (LedgerTransactionID != PanelData[i].LedgerTransactionID) {
                            mydata += '<td id="lststatus" class="GridViewLabItemStyle"  style="border: solid 1px lightgray;font-weight:bold;">' + PanelData[i].lastStatus + '</td>';
                        }
                        else {
                            mydata += '<td id="lststatus" class="GridViewLabItemStyle"  style="border: solid 1px lightgray;font-weight:bold;"></td>';
                        }
                        mydata += '<td id="invid" class="GridViewLabItemStyle"  style="border: solid 1px lightgray;display:none;">' + PanelData[i].Investigation_ID + '</td>';
                        
                        mydata += '</tr>';

                        $('#tbl').append(mydata);

                        LedgerTransactionID = PanelData[i].LedgerTransactionID;

                      
                    }
                    $("#<%=ddlcentre.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=ddlshipment.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=ddlprogram.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                 
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });
        }


        function openuploadbox(ctrl) {
            var programid = $(ctrl).closest('tr').attr('class');
            var labid = $(ctrl).closest('tr').attr('name');
            var shipmentno = $(ctrl).closest('tr').attr('title');
            var href = "CAPResultUpload.aspx?programid=" + programid + "&labid=" + labid + "&shipmentno=" + shipmentno;

              $.fancybox({
                  'background': 'none',
                  'hideOnOverlayClick': true,
                  'overlayColor': 'gray',
                  'width': '950px',
                  'height': '800px',
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
                      searchdata();
                  }
              });

        }


    </script>

    <script type="text/javascript">

        function validation(flag) {


            if ($('#tbl tr').length == 0) {
                showerrormsg("Please Search Result..!");
                return false;
            }


            var s11 = 0;
            $('#tbl tr').each(function () {

                if ($(this).attr("id") != "trheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#txtvalue').val() == "") {
                        s11 = 1;
                        $(this).find('#txtvalue').focus();
                        return;
                    }
                }
            });

            if (s11 == 1) {
                showerrormsg("Please Enter Lab Result Value ");
                return false;
            }

            if (flag == "3") {

                var s11 = 0;
                $('#tbl tr').each(function () {

                    if ($(this).attr("id") != "trheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                        if ($(this).find('#txtcapvalue').val() == "") {
                            s11 = 1;
                            $(this).find('#txtcapvalue').focus();
                            return;
                        }
                    }
                });

                if (s11 == 1) {
                    showerrormsg("Please Enter SDI Value ");
                    return false;
                }

                var s11 = 0;
                $('#tbl tr').each(function () {

                    if ($(this).attr("id") != "trheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                        if ($(this).find('#ddlstatus').val() == "") {
                            s11 = 1;
                            $(this).find('#ddlstatus').focus();
                            return;
                        }
                    }
                });

                if (s11 == 1) {
                    showerrormsg("Please Select Grade");
                    return false;
                }
            }




            return true;
        }

        function getdata() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                if ($(this).attr("id") != "trheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                    var objILCResult = new Object();
                    
                    objILCResult.shipmentno = $(this).attr("name");
                    objILCResult.ProgramID = $(this).attr("class");
                    objILCResult.test_id = $(this).attr("id");
                    objILCResult.Value = $(this).find("#txtvalue").val();
                    objILCResult.Acceptability = $(this).find("#txtcapvalue").val();
                    
                    objILCResult.Grade = $(this).find("#ddlstatus").val();
                    objILCResult.investigationid = $(this).find("#invid").text();
                    objILCResult.LabObservationID = $(this).find("#LabObservationID").html();
                    
                    

                    dataIm.push(objILCResult);
                }
            });
            return dataIm;


        }


        function savedata(flag) {


            if (validation(flag) == true) {
                var EQASResultData = getdata();
                if (EQASResultData.length == 0) {
                    showerrormsg("Please Search Result To Save");
                    return;
                }
                $.blockUI();
                $.ajax({
                    url: "CAPProgramResultEntry.aspx/saveresult",
                    data: JSON.stringify({ CAPResultData: EQASResultData, flag: flag }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        $.unblockUI();
                        if (result.d == "1") {
                            if (flag == "0") {
                                showmsg("CAP Result Saved Successfully..!");
                                $('#<%=ddlstatus.ClientID%>').prop('selectedIndex', 2);
                                searchdata();
                            }
                            else if (flag == "1") {
                                showmsg("CAP Result Approved Successfully..!");
                                $('#<%=ddlstatus.ClientID%>').prop('selectedIndex', 3);
                                searchdata();
                            }
                            if (flag == "2") {
                                showmsg("CAP Result Send To CAP Successfully..!");
                                $('#<%=ddlstatus.ClientID%>').prop('selectedIndex', 4);
                                searchdata();
                            }
                            if (flag == "3") {
                               
                                showerrormsg("CAP Done Successfully..!");
                                $('#<%=ddlstatus.ClientID%>').prop('selectedIndex', 5);
                                searchdata();
                            }



                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        showerrormsg(xhr.responseText);
                    }
                });

            }



        }


    </script>

    <script type="text/javascript">

        function excelreport() {

            var length = $('#<%=ddlcentre.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }


            var length1 = $('#<%=ddlshipment.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlshipment.ClientID%>').val() == "0") {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlshipment.ClientID%>').focus();
                return;
            }

            var length1 = $('#<%=ddlprogram.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlprogram.ClientID%>').val() == "0") {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }





            jQuery.ajax({
                url: "CAPProgramResultEntry.aspx/exporttoexcel",
                data: '{labid: "' + $('#<%=ddlcentre.ClientID%>').val() + '",shipmentno:"' + $('#<%=ddlshipment.ClientID%>').val() + '",programid:"' + $('#<%=ddlprogram.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        $.unblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }




        function pdfreport() {

            var length = $('#<%=ddlcentre.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }


            var length1 = $('#<%=ddlshipment.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlshipment.ClientID%>').val() == "0") {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlshipment.ClientID%>').focus();
                return;
            }

            var length1 = $('#<%=ddlprogram.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlprogram.ClientID%>').val() == "0") {
                showerrormsg("Please Select Program");
                $('#<%=ddlprogram.ClientID%>').focus();
                return;
            }



            var phead = 0;
            if ($('#chheader').is(':checked')) {
                phead = 1;
            }
            window.open('CAPSummaryReport.aspx?labid=' + $('#<%=ddlcentre.ClientID%>').val() + '&phead=' + phead + '&programid=' + $('#<%=ddlprogram.ClientID%>').val() + '&shipmentno=' + $('#<%=ddlshipment.ClientID%>').val());

         }
    </script>

    <script type="text/javascript">

        function resetme() {
            $('#tbl tr').slice(1).remove();
            $("#<%=ddlcentre.ClientID%>").attr("disabled", false).trigger('chosen:updated');
            jQuery('#<%=ddlshipment.ClientID%> option').remove();
            $("#<%=ddlshipment.ClientID%>").attr("disabled", false).trigger('chosen:updated');
            bindshipment();
            jQuery('#<%=ddlprogram.ClientID%> option').remove();
            $("#<%=ddlprogram.ClientID%>").attr("disabled", false).trigger('chosen:updated');
            $('#btnsave').hide();
            $('#btnapproved').hide();
            $('#btnsend').hide();
            $('#btneqasdone').hide();
            $('#btnexcelreport').hide();
            $('#btnpdfreport').hide();
            $('#btnpdfreport1').hide();

        }
    </script>
</asp:Content>

