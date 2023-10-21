<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleStorage.aspx.cs" Inherits="Design_SampleStorage_SampleStorage" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
   Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 
   <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
   <Ajax:ScriptManager ID="ScriptManager1" runat="server">
   </Ajax:ScriptManager>
   <style type="text/css">
      .deactive {
      background-color:white;height:25px;color:#000066;cursor:pointer;
      }
      .active {
      background-color:lightgreen;height:25px;color:#000066;cursor:pointer;
      }
      #ContentPlaceHolder1_ddldevice_chosen{
      width:160px !important;
      }
      .spantrayhalf {
      font-size:12px;padding:5px;margin:5px;border-radius:8px;font-weight:bold;color:transparent;cursor:pointer;background: -webkit-linear-gradient(180deg,pink 50%, green 50%);
      }
      .spantrayfull {
      font-size:12px;padding:5px;margin:5px;border-radius:8px;font-weight:bold;background-color:green;color:transparent;cursor:pointer;
      }
      .spantrayactive {
      font-size:12px;padding:5px;padding-left:0px;border-radius:8px;font-weight:bold;background-color: #CC99FF;color: transparent;cursor:pointer;
      }
      .close {
      background-color:black;color:white;font-weight:bold;padding:3px;border-radius:4px;display:none;cursor:pointer;font-size:11px;
      }
   </style>
   <div id="Pbody_box_inventory" >
      <div class="POuter_Box_Inventory" style="text-align: center;">
         <b>&nbsp;Sample Storage</b>&nbsp;<br />
         <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
      </div>
      <div class="POuter_Box_Inventory">
         <div class="Purchaseheader">
            Add Details&nbsp;
         </div>
         <div class="row">
            <div class="col-md-3" style="text-align:right;">
               <label class="pull-left">Type</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:DropDownList ID="ddltype" runat="server" class="ddltype  chosen-select chosen-container" onchange="resetitem()">
                  <asp:ListItem Value="0">Select</asp:ListItem>
                  <asp:ListItem Value="Processed Samples">Processed Samples</asp:ListItem>
                  <asp:ListItem Value="Scheduled Samples">Scheduled Samples</asp:ListItem>
               </asp:DropDownList>
            </div>
            <div class="col-md-3" style="text-align:right;">
               <label class="pull-left">Sample Type</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:DropDownList ID="ddlsampletype" onchange="BindTray()" runat="server" class="ddlsampletype  chosen-select chosen-container"></asp:DropDownList>
            </div>
            <div class="col-md-3">
               <label class="pull-left">Process Date</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
               <asp:TextBox ID="txtspshedule"  runat="server" ></asp:TextBox>
               <cc1:CalendarExtender ID="calFromDate"  runat="server" TargetControlID="txtspshedule" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
            </div>
         </div>
      </div>
      <div class="POuter_Box_Inventory" style="display:none;" id="traydetail">
         <div class="row">
            <div class="col-md-12" valign="top">
               <div class="Purchaseheader">
                  Add Sample To Tray
               </div>
               <div style="display:none;" id="barcode">
                  <div class="row">
                     <div class="col-md-4" align="right">
                        <label class="pull-left">Tray Type</label>
                        <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-3">
                        <asp:RadioButton ID="rd2" Font-Bold="true" runat="server" Text="New Tray"   onclick="setdobop1(this)"  GroupName="rdDOB"  />
                     </div>
                     <div class="col-md-3">
                        <asp:RadioButton ID="rd1" Font-Bold="true" runat="server" Text="Old Tray" Checked="true"  onclick="setdobop(this)"  GroupName="rdDOB"  />
                     </div>
                     <div class="col-md-7" >
                        <asp:DropDownList ID="ddloldtray" runat="server"  onchange="showcapacity()">                                
                        </asp:DropDownList>
                     </div>
                     <div class="col-md-3">
                        <label class="pull-left">SIN No</label>
                        <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-4">
                        <input type="text" id="txtbarcodeno" placeholder="Scan SIN No" />
                        <asp:TextBox ID="txttray" runat="server" style="display:none;" />
                        <asp:TextBox ID="txtexpiry" runat="server" style="display:none;" />
                     </div>
                  </div>
               </div>
               <div style="overflow:auto;max-height:350px;">
                  <table id="traydesign" rules="all" cellpadding="1" cellspacing="0" style="background-color:white;border-color:#CCCCCC;border-width:1px;border-style:None;border-collapse:collapse;margin-left:5px;color:white;border-color:maroon;" frame="box">
                  </table>
               </div>
            </div>
            <div class="col-md-12" valign="top">
               <div class="Purchaseheader">
                  Device Detail
               </div>
               
                  <div class="row">
                     <div class="col-md-3" style="font-weight:bold;">
                          <label class="pull-left">Device</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-6">
                        <asp:DropDownList ID="ddldevice" onchange="showdevicetable()" runat="server" class="ddldevice  chosen-select chosen-container"></asp:DropDownList>
                     </div>
                     <div class="col-md-13">
                        
                           <div class="row">
                               <div class="col-md-3"></div>
                              <div class="col-md-3" style="border-right: black thin solid; border-top: black thin solid;
                                 border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;">
                                 &nbsp;&nbsp;&nbsp;&nbsp;
                              </div>
                              <div class="col-md-4">
                                 New
                              </div>
                              <div class="col-md-3" style="border-right: black thin solid; border-top: black thin solid;
                                 border-left: black thin solid; border-bottom: black thin solid; background: -webkit-linear-gradient(180deg,pink 50%, green 50%)"">
                                 &nbsp;&nbsp;&nbsp;&nbsp;
                              </div>
                              <div class="col-md-6">
                                 Running
                              </div>
                              <div class="col-md-3" style="border-right: black thin solid; border-top: black thin solid;
                                 border-left: black thin solid; border-bottom: black thin solid; background-color: green;" ">
                                 &nbsp;&nbsp;&nbsp;&nbsp;
                              </div>
                              <div class="col-md-1">
                                 Full
                              </div>
                           </div>
                        
                     </div>
                  </div>
               
               <table id="devicedesign" rules="all" cellpadding="3" cellspacing="0" style="background-color:lightyellow;border-color:#CCCCCC;border-width:1px;border-style:None;border-collapse:collapse;margin-left:5px;color:white;border-color:maroon;" frame="box">
               </table>
            </div>
         </div>
         <div class="row">
             <div class="col-md-11">
             </div>
            <div class="col-md-4">
               <input type="button" class="savebutton" value="Save" onclick="savedata()" />&nbsp;&nbsp;&nbsp;
               <input type="button" value="Clear" class="resetbutton" onclick="clearall()" />
            </div>
         </div>
      </div>
   </div>
   <script type="text/javascript">
       function clearall() {
           window.location.reload();
       }



       $('#txtbarcodeno').on('keyup', function (e) {
           var keyCode = e.keyCode || e.which;
           if (keyCode === 13) {

               searchBarcode();
           }
       });

       function searchBarcode() {
           if ($('#txtbarcodeno').val() == "") {
               toast("Error", "Please Scan SIN No");
               $('#txtbarcodeno').focus();
               return;
           }

           $modelBlockUI();
           serverCall('SampleStorage.aspx/bindsampledata', { barcodeno: $('#txtbarcodeno').val(), sampletype: $('#<%=ddlsampletype.ClientID%> option:selected').val() }, function (result) {
              PanelData = $.parseJSON(result);
              if (PanelData[0].barcodeno == "") {
                  toast("Error", "Incorrect SIN No.");
                  $('#txtbarcodeno').val('');
                  $('#txtbarcodeno').focus();
                  $modelUnBlockUI();
              }
              else {

                  var cc = 0;
                  $('#traydesign tr').each(function () {

                      $(this).find('td').each(function () {


                          if ($(this).find('.myspan').html() == PanelData[0].barcodeno) {
                              cc = 1;

                              toast("Error", "Sin No Already Added");
                              return false;
                          }
                          if ($(this).find('.myspan').html() == "") {

                              $(this).find('.myspan').html(PanelData[0].barcodeno);
                              var test = "Test:" + PanelData[0].Itemname + " Visit No:" + PanelData[0].LedgerTransactionNo + " PName:" + PanelData[0].pname + " " + PanelData[0].Age + " " + PanelData[0].Gender;
                              $(this).find('.myspan').attr('title', test);
                              $(this).find('.myspan').attr('name', "new");
                              $(this).find('.myspan').show();
                              $(this).find('.close').show();
                              cc = 1;
                              return false;
                          }
                      });
                      if (cc == 1)
                          return false;

                  });
                  $('#txtbarcodeno').val('');
                  $('#txtbarcodeno').focus();
                  $modelUnBlockUI();
              }



          })

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
              $(selector).chosen(config[selector]);
          }
          BindSampleType();
      });

      function setdobop(ctrl) {
          $('.myspan').html('');
          $('.myspan').attr('title', '');
          $('.myspan').hide();
          $('.close').hide();
          bindoldtray();

      }

      function setdobop1(ctrl) {
          $('.myspan').html('');
          $('.myspan').attr('title', '');
          $('.myspan').hide();
          bindnewtray();

      }
      function bindoldtray() {
          $modelBlockUI();
          $('#traydesign tr').remove();
          var ddlDoctor = $("#<%=ddloldtray.ClientID %>");
          $("#<%=ddloldtray.ClientID %> option").remove();
          serverCall('SampleStorage.aspx/bindoldtray', { type: $('#<%=ddltype.ClientID%>').val(), date: $('#<%=txtspshedule.ClientID%>').val() }, function (result) {
              PanelData = $.parseJSON(result);
              if (PanelData.length == 0) {
                  toast("Error", "No Old Tray Found..!", "");
                  $('#ContentPlaceHolder1_rd2').prop('checked', true);
                  setdobop1($('#ContentPlaceHolder1_rd2'));
                  $modelUnBlockUI();
              }
              else {
                  ddlDoctor.bindDropDown({ defaultValue: 'Select Old Tray', data: JSON.parse(result), valueField: 'id', textField: 'TrayCode', isSearchAble: true });
                  $modelUnBlockUI();
              }

          })

      }

      function bindnewtray() {
          $modelBlockUI();
          $('#traydesign tr').remove();
          var ddlDoctor = $("#<%=ddloldtray.ClientID %>");
          $("#<%=ddloldtray.ClientID %> option").remove();
          serverCall('SampleStorage.aspx/bindtray', { sampletype: $('#<%=ddlsampletype.ClientID%> option:selected').val() }, function (result) {
              PanelData = $.parseJSON(result);
              if (PanelData.length == 0) {
                  toast("Error", "No Tray Found For Selected Sample Type");
                  $modelUnBlockUI();
                  return;
              }
              else {
                  ddlDoctor.bindDropDown({ defaultValue: 'Select New Tray', data: JSON.parse(result), valueField: 'id', textField: 'trayname', isSearchAble: true });
                  $modelUnBlockUI();


              }
          })
      }
      function BindSampleType() {
          $modelBlockUI();
          var ddlDoctor = $("#<%=ddlsampletype.ClientID %>");
          $("#<%=ddlsampletype.ClientID %> option").remove();
          serverCall('SampleStorage.aspx/bindsampletype', {}, function (result) {
              PanelData = $.parseJSON(result);
              if (PanelData.length == 0) {
                  $modelUnBlockUI();
              }
              else {
                  ddlDoctor.bindDropDown({ defaultValue: 'Select Sample Type', data: JSON.parse(result), valueField: 'id', textField: 'samplename', isSearchAble: true });

                  //ddlDoctor.append($("<option></option>").val("0").html("Select Sample Type"));
                  //for (i = 0; i < PanelData.length; i++) {

                  //    ddlDoctor.append($("<option></option>").val(PanelData[i]["id"]).html(PanelData[i]["samplename"]));
                  //}
              }
              ddlDoctor.trigger('chosen:updated');
              $modelUnBlockUI();


          })
      }




      function BindTray() {
          $('#tbsample tr').slice(1).remove();
          $('#traydesign tr').remove();
          $('#barcode').hide();
          if ($('#<%=ddltype.ClientID%> option:selected').val() == "0") {
              toast("Error", "Please Select Type");
              $('#<%=ddlsampletype.ClientID%>').val('0');
              $('#<%=ddlsampletype.ClientID%>').trigger('chosen:updated');
              $('#<%=ddltype.ClientID%>').focus();
              $('#traydetail').hide();
              return;
          }
          if ($('#<%=ddlsampletype.ClientID%> option:selected').val() == "0") {
              $('#traydetail').hide();
              return;
          }
          $('#traydetail').show();
          $('#barcode').show();
          bindoldtray();
      }
      function showcapacity() {
          //$modelBlockUI();
          debugger;
          $('#traydesign tr').remove();
          if ($('#ContentPlaceHolder1_ddloldtray').val() == "0") {
              return;
          }
          $('#txtbarcodeno').focus();
          $('#<%=txttray.ClientID%>').val($('#ContentPlaceHolder1_ddloldtray').val());
          $('#<%=txtexpiry.ClientID%>').val($('#ContentPlaceHolder1_ddloldtray option:selected').text().split('^')[2]);
          var cap1 = $('#ContentPlaceHolder1_ddloldtray option:selected').text().split('^')[1].split('X')[0];
          var cap2 = $('#ContentPlaceHolder1_ddloldtray option:selected').text().split('^')[1].split('X')[1];
          for (var a = 1; a <= parseInt(cap1) ; a++) {
              var $mydata1 = [];
              $mydata1.push('<tr>');
              for (var b = 1; b <= parseInt(cap2) ; b++) {
                  var $mydata2 = [];
                  var ii = a + "X" + b;
                  $mydata2.push('<td align="left"  style="width:40px;height:15px;padding-bottom:5px;" ><span style="color: blue;font-size: 11px;padding-bottom:5px;" class="myspanid">');
                  $mydata2.push(ii);
                  $mydata2.push('</span><br/><span style="cursor:pointer;font-size:11px;padding:3px;border-radius:8px;font-weight:bold;background-color:#cc4f66;display:none;" class="myspan" id="');
                  $mydata2.push(ii);
                  $mydata2.push('"/><span class="close" title="Click To Remove" onclick="removebarcode(this)">X</span> </td>');
              }
              $mydata1 = $mydata1.concat($mydata2);
              $mydata1.push('</tr>');
              $mydata1 = $mydata1.join("");
              $('#traydesign').append($mydata1);
          }

          if ($('#ContentPlaceHolder1_rd1').is(':checked')) {
              getoldtraydata();
          }
          $modelUnBlockUI();
      }
      function removebarcode(ctrl) {
          $(ctrl).closest('td').find('.myspan').html('');

          $(ctrl).closest('td').find('.myspan').attr('title', '');
          $(ctrl).closest('td').find('.myspan').hide();
          $(ctrl).closest('td').find('.close').hide();
      }


      function showdevicetable() {
          $modelBlockUI();
          $('#devicedesign tr').remove();
          if ($('#<%=ddldevice.ClientID%>').val() == "0") {
              return;
          }

          var c = 65;
          for (var ac = 1; ac <= $('#<%=ddldevice.ClientID%>').val().split('#')[1]; ac++) {
              var $mydata = [];
              $mydata.push('<tr>');

              var tid = String.fromCharCode(c);
              $mydata.push('<td align="left" id=');
              $mydata.push(ac);
              $mydata.push('  style="cursor:pointer; width:100px;height:20px;"  ><span title="Click To Add Tray" style="font-size:12px;padding:5px;border-radius:8px;font-weight:bold;background-color:blue;"  id="');
              $mydata.push(tid);
              $mydata.push('" onclick="addme(this)">Rack ');
              $mydata.push(ac);
              $mydata.push('</span>');
              $mydata.push('<td id="seats">');
              serverCall('SampleStorage.aspx/getdevicedata', { deviceid: $('#<%=ddldevice.ClientID%>').val().split('#')[0], rackid: ac }, function (result) {
                  TestData = $.parseJSON(result);
                  for (var i = 0; i <= TestData.length - 1; i++) {
                      var $mydata2 = [];
                      if (TestData[i].totalcount == TestData[i].totalcapacity) {
                          $mydata2.push('<div  style="float:left;"> <span title="');
                          $mydata2.push(TestData[i].type);
                          $mydata2.push(' ');
                          $mydata2.push(TestData[i].traycode);
                          $mydata2.push('"   class="spantrayfull"   onclick="bookme(\'');
                          $mydata2.push(TestData[i].traycode);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].totalcount);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].totalcapacity);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].type);
                          $mydata2.push('\')">TRAY</span></div>');
                      }
                      else {
                          $mydata2.push('<div style="float:left;"> <span  title="');
                          $mydata2.push(TestData[i].type);
                          $mydata2.push(' ');
                          $mydata2.push(TestData[i].traycode);
                          $mydata2.push('"  class="spantrayhalf"  onclick="bookme(\'');
                          $mydata2.push(TestData[i].traycode);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].totalcount);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].totalcapacity);
                          $mydata2.push('\',\'');
                          $mydata2.push(TestData[i].type);
                          $mydata2.push('\')">TRAY</span></div>');
                      }
                      
                      $mydata.concat($mydata2);
                  }
              })


              $mydata.push('</td>');
              $mydata.push('</tr>');
              $mydata = $mydata.join("");
              $('#devicedesign').append($mydata);
              c++;
          }


          $modelUnBlockUI();
      }


      function addme(ctrl) {

          if ($('.spantrayactive').length == 0) {
              //var id = $(ctrl).attr('id');
              //var co = $($(ctrl).closest('tr').find('#seats')).children('span').length + 1;
              //id = id + "-" + co;
              $(ctrl).closest('tr').find('#seats').append('<div id="justadded" style="float:left;"> <span   class="spantrayactive">TRAY</span><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleteme()"/></div>');
          }

      }

      function deleteme() {
          $('#justadded').remove();


      }

      function bookme(q, q1, q2, q4) {
          toast("Info", q4 + "  Tray: " + q + " Total Capacity: " + q2 + " Total Sample: " + q1, "");
      }
   </script>
   <%--Save Data--%>
   <script type="text/javascript">
       function validation() {


           var ac = "";
           $('#traydesign tr').each(function () {

               ac = $(this).find('.myspan').html();
               return false;

           });

           if (ac == "") {
               toast("Error", "Please Add Sample in Tray", "");
               return false;
           }
           if ($('.spantrayactive').length == 0) {
               toast("Error", "Please Add Tray in Device", "");
               return false;
           }

           if ($('#ContentPlaceHolder1_rd1').is(':checked') && $('#<%=ddloldtray.ClientID%>').val() == "0") {
              toast("Erro", "Please Select Old ", "");
              $('#<%=ddloldtray.ClientID%>').focus();
              return false;
          }

          if ($('#<%=ddltype.ClientID%>').val() == "Scheduled Samples" && $('#<%=txtspshedule.ClientID%>').val() == "") {
              toast("Error", "Please Select Schedule Date", "");
              $('#<%=txtspshedule.ClientID%>').focus();
              return false;
          }

          return true;
      }

      function getdatatosave() {
          var dataPLO = new Array();
          debugger;
          $('#traydesign tr').each(function () {

              $(this).find('td').each(function () {

                  if ($(this).find('.myspan').html() != "") {
                      var plo = [];
                      plo[0] = $('#<%=ddldevice.ClientID%>').val().split('#')[0];// DeviceID
                      if ($('#<%=ddltype.ClientID%>').val() == "Processed Samples") {
                          plo[1] = "P";// Type
                      }
                      else {
                          plo[1] = "S";//Type
                      }

                      if ($('#ContentPlaceHolder1_rd1').is(':checked')) {
                          plo[2] = $('#<%=ddloldtray.ClientID%> option:selected').text().split('^')[0];
                      }
                      else {
                          plo[2] = "";// New Tray
                      }

                      plo[3] = $('#<%=ddlsampletype.ClientID%>').val();// SampleTypeID
                      plo[4] = "1";// Status
                      plo[5] = $('#<%=txtexpiry.ClientID%>').val();// ExpiryDate

                      plo[6] = $('.spantrayactive').parent().closest('tr').children("td:first").attr("id");//RackID


                      plo[7] = $(this).find('.myspan').html();// Barcodeno

                      plo[8] = $('#<%=txttray.ClientID%>').val();//TrayID
                      plo[9] = $('#<%=txtspshedule.ClientID%>').val();//expirydate
                      plo[10] = $(this).find('.myspan').attr("id");// slotnumber
                      dataPLO.push(plo);
                  }
              }
              );
          });

          return dataPLO;
      }

      function resetitem() {
          $('#<%=ddlsampletype.ClientID%>').val('0');
          $('#<%=ddlsampletype.ClientID%>').trigger('chosen:updated');
          $('#traydetail').hide();

          if ($('#<%=ddltype.ClientID%>').val() == "Scheduled Samples") {
              $('.spshedule').html('Schedule Date');
          }
          else {
              $('.spshedule').html('Process Date');
          }
      }

      function savedata() {

          if (validation()) {
              var datatosave = getdatatosave();

              serverCall('sampleStorage.aspx/SaveData', { datatosave: datatosave }, function (result) {
                  TestData = $.parseJSON(result);
                  if (TestData == "1") {
                      toast("Success", "Data Saved", "");
                      $('#<%=ddltype.ClientID%>').val('0');
                      $('#<%=ddltype.ClientID%>').trigger('chosen:updated');
                      resetitem();
                  }
                  else {
                      toast("Error", TestData, "");
                  }
              })

          }
      }


      function getoldtraydata() {
          $modelBlockUI();
          var traycode = $('#<%=ddloldtray.ClientID%> option:selected').text().split('^')[0];
          serverCall('sampleStorage.aspx/GetoldTrayData', { trayid: traycode }, function (result) {
              TestData = $.parseJSON(result);
              if (TestData.length == 0) {

                  $('.myspan').html('');
                  $('.myspan').attr('title', '');
                  $('.myspan').hide();
              }
              else {
                  $('.myspan').html('');
                  $('.myspan').attr('title', '');
                  $('.myspan').hide();
                  for (i = 0; i < TestData.length; i++) {
                      $('.myspan').each(function () {
                          if ($(this).html() == "") {
                              $(this).html(TestData[i].barcodeno);
                              var test = "Test:" + TestData[i].Itemname + " Visit No:" + TestData[i].LedgerTransactionNo + " PName:" + TestData[i].pname + " " + TestData[i].Age + " " + TestData[i].Gender;
                              $(this).attr('title', test);
                              $(this).attr('name', 'old');
                              $(this).show();
                              //$(this).find('.close').show();
                              return false;
                          }
                      }
                      );


                  }

                  $('#<%=ddldevice.ClientID%>').val(TestData[0].deviceid);
                  $('#<%=ddldevice.ClientID%>').trigger('chosen:updated');
                  showdevicetable();
              }
          })

          $modelUnBlockUI();
      }
   </script>
</asp:Content>