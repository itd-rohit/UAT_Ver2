<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="true" AutoEventWireup="true" CodeFile="CoPaymentMaster.aspx.cs" Inherits="Design_Master_CoPaymentMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       
 <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     

    <style type="text/css">
         #ContentPlaceHolder1_tabHeader_tabPanelTest_ddldepartment_chosen {
            width:400px !important;
        }
        .ajax__tab_tab {
            height:24px !important;
            font-size:13px;
            font-weight:bold;
        }
        #ContentPlaceHolder1_tabHeader_header {
            background: url(../../App_Images/app-background.png);
        }
    </style>
    
     <div id="Pbody_box_inventory">
          <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center;">
         
                          <b>Co-Payment Master</b>  
                        
               
              </div>
          <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-3">
			   <label class="pull-left">Select Client   </label>
			   <b class="pull-right">:</b>
		   </div>
                 <div class="col-md-8">
                      <asp:DropDownList ID="ddlpanel" runat="server" class="ddlpanel chosen-select" onchange="binddepartment();binddefaultdata();"></asp:DropDownList>
                       </div>

                 </div>
                 
                  

                      <div class="row">
                                 <cc1:TabContainer ID="tabHeader" runat="server" Width="99%"  ActiveTabIndex="0"  OnClientActiveTabChanged="clientActiveTabChanged">
                                      

                                     
                                 

                                 <cc1:TabPanel runat="server" HeaderText="Test Wise Percentage" ID="tabPanelTest" style="background: url(../../App_Images/patter.jpg)">
                                         <ContentTemplate>
                                            <b> Select Department :</b> <asp:DropDownList ID="ddldepartment" runat="server" Width="400px" class="ddldepartment chosen-select" onchange="gettestlist()"></asp:DropDownList>
                                             <br /><br />
                                             <div class="TestDetail" style="height: 400px; overflow: scroll; width: 100%;">
                                   <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                                       <thead>
                                           <tr id="ItemHeader">
                                               <td class="GridViewHeaderStyle" width="50px">S.No.</td>
                                               <td class="GridViewHeaderStyle" width="150px">Department</td>
                                               <td class="GridViewHeaderStyle" width="100px">Item Code</td>
                                               <td class="GridViewHeaderStyle" width="350px">Item Name</td>
                                               <td class="GridViewHeaderStyle" width="150">CoPayment(%)<br /><input type="text" id="txtdiscall" style="width:100px;" name="t1" onkeyup="setme(this)" maxlength="3"/></td>
                                               <td class="GridViewHeaderStyle" width="50px"><input type="checkbox" id="chall" onclick="checkall(this)" /></td>
                                               <td class="GridViewHeaderStyle" width="50px">Delete</td>
                                           </tr>
                                       </thead>
                                   </table>
               </div>
                                         </ContentTemplate>
                                         </cc1:TabPanel>

                                     <cc1:TabPanel runat="server" HeaderText="Department Wise Percentage" ID="tabPanelDepartment" style="background: url(../../App_Images/patter.jpg)">
                                         <ContentTemplate>
                                             <div class="TestDetail" style="height: 450px; overflow: scroll; width: 100%;">
                                   <table id="tbldepartmentlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                                        <thead>
                                           <tr id="ItemHeaderdept">
                                       <td class="GridViewHeaderStyle" width="50px">S.No.</td>
                                               <td class="GridViewHeaderStyle" width="150px">Department</td>
                                               <td class="GridViewHeaderStyle" width="150">CoPayment(%)<br /><input type="text" id="txtdiscalldept" style="width:100px;" name="t2" onkeyup="setme(this)" maxlength="3"/></td>
                                               <td class="GridViewHeaderStyle" width="50px"><input type="checkbox" id="challdept" onclick="checkalldept(this)" /></td>
                                               <td class="GridViewHeaderStyle" width="50px">Delete</td>
                                               </tr>
                                            </thead>
                                       </table>
                                                 </div>
                                         </ContentTemplate>
                                         </cc1:TabPanel>
                                     <cc1:TabPanel runat="server" HeaderText="Default Percentage" ID="tabPanelDefault" style="background: url(../../App_Images/patter.jpg)" >
                                        
                                        <ContentTemplate>
                                            <table width="100%">
                                                <tr>
                                                    <td id="tt">
                                             <b> Default % :</b>  <asp:TextBox ID="txtdefaultpercentage" runat="server"  Width="70px" MaxLength="3" onkeyup="setme(this)" />
                                               </td> </tr></table>
                                        </ContentTemplate>
                                          </cc1:TabPanel>
                                  </cc1:TabContainer>
                            </div>

                       <div class="row"  style="text-align:center">
                               <input type="button" value="Save" onclick="savedata()" id="btnsave" />
                               <input type="button" value="Reset" onclick="resetdata()" />
                          
                </div>
              </div>
     </div>
          <script type="text/javascript">            
              $(function () {
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
                  bindpanel();
                  binddepartment();
                  $("#tblitemlist").tableHeadFixer({
                  });
                  $("#tbldepartmentlist").tableHeadFixer({
                  });
               
              });
              function bindpanel() {
                  jQuery('#<%=ddlpanel.ClientID%> option').remove();
                  jQuery('#<%=ddlpanel.ClientID%>').trigger('chosen:updated');                
                  serverCall('CoPaymentMaster.aspx/bindpanel', {  }, function (response) {                    
                      jQuery('#<%=ddlpanel.ClientID%>').bindDropDown({ defaultValue: 'Select Panel', data: JSON.parse(response), valueField: 'panel_id', textField: 'panelname', isSearchAble: true });
                  });                
              }
              function binddepartment() {
                  jQuery('#<%=ddldepartment.ClientID%> option').remove();
                  jQuery('#<%=ddldepartment.ClientID%>').trigger('chosen:updated');
                  $('#tbldepartmentlist tr').slice(1).remove();
                  serverCall('CoPaymentMaster.aspx/binddepartment', { panel_id: jQuery('#<%=ddlpanel.ClientID%>').val() }, function (response) {
                      deptdata = jQuery.parseJSON(response);
                      jQuery('#<%=ddldepartment.ClientID%>').append($("<option></option>").val("0").html("Select Department"));
                      for (var a = 0; a <= deptdata.length - 1; a++) {
                          jQuery('#<%=ddldepartment.ClientID%>').append($("<option></option>").val(deptdata[a].subcategoryid).html(deptdata[a].NAME));
                          var $mydata = [];
                          if (deptdata[a].savedid == "0") {
                              $mydata.push('<tr  class="GridViewItemStyle" id="'); $mydata.push(deptdata[a].subcategoryid); $mydata.push('">');
                          }
                          else {
                              $mydata.push('<tr  class="GridViewItemStyle" style="background-color:lightgreen;" id="'); $mydata.push(deptdata[a].subcategoryid); $mydata.push('">');
                          }
                          $mydata.push('<td>'); $mydata.push(parseInt(a + 1)); $mydata.push('</td>');
                          $mydata.push('<td id="deptname">'); $mydata.push(deptdata[a].NAME); $mydata.push('</td>');
                          $mydata.push('<td><input type="text" style="width:100px" id="txtdisc" name="t2" onkeyup="setme(this)" maxlength="3"  value="'); $mydata.push(deptdata[a].CoPaymentPercentage); $mydata.push('" /></td>');
                          $mydata.push('<td><input type="checkbox" id="chk"  /></td>');
                          if (deptdata[a].savedid == "0") {
                              $mydata.push('<td></td>');
                          }
                          else {
                              $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleteme(this)"/></td>');
                          }
                          $mydata.push('<td style="display:none;" id="Subcategoryid">'); $mydata.push(deptdata[a].subcategoryid); $mydata.push('</td>');
                          $mydata.push('<td style="display:none;" id="panelid">'); $mydata.push(deptdata[a].panelid); $mydata.push('</td>');
                          $mydata.push('<td style="display:none;" id="savedid">'); $mydata.push(deptdata[a].savedid); $mydata.push('</td>');
                          $mydata.push('</tr>');
                          $mydata = $mydata.join("");
                          $('#tbldepartmentlist').append($mydata);
                      }
                      jQuery('#<%=ddldepartment.ClientID%>').trigger('chosen:updated');
                  });
              }
              function gettestlist() {               
                  $('#tblitemlist tr').slice(1).remove();
                  var deptid = jQuery('#<%=ddldepartment.ClientID%>').val();
                  if (deptid != "0") {
                      serverCall('CoPaymentMaster.aspx/bindtest', { deptid: deptid , panelid:  jQuery('#<%=ddlpanel.ClientID%>').val() , deptname: jQuery('#<%=ddldepartment.ClientID%> option:selected').text()  }, function (response) {

                          itemdatadata = jQuery.parseJSON(response);
                          if (itemdatadata.length > 0) {
                              for (var i = 0; i <= itemdatadata.length - 1; i++) {
                                  var $mydata = [];
                                  if (itemdatadata[i].savedid == "0") {
                                      $mydata.push('<tr  class="GridViewItemStyle" id="'); $mydata.push(itemdatadata[i].itemid); $mydata.push('">');
                                  }
                                  else {
                                      $mydata.push('<tr  class="GridViewItemStyle" style="background-color:lightgreen;" id="'); $mydata.push(itemdatadata[i].itemid); $mydata.push('">');
                                  }
                                  $mydata.push('<td>'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                                  $mydata.push('<td id="deptname">'); $mydata.push(itemdatadata[i].deptname); $mydata.push('</td>');
                                  $mydata.push('<td id="testcode">'); $mydata.push(itemdatadata[i].testcode); $mydata.push('</td>');
                                  $mydata.push('<td id="typename">'); $mydata.push(itemdatadata[i].typename); $mydata.push('</td>');
                                  $mydata.push('<td><input type="text" style="width:100px" id="txtdisc" name="t1" onkeyup="setme(this)" maxlength="3" value="'); $mydata.push(itemdatadata[i].CoPaymentPercentage); $mydata.push('" /></td>');
                                  $mydata.push('<td><input type="checkbox" id="chk"  /></td>');
                                  if (itemdatadata[i].savedid == "0") {
                                      $mydata.push('<td></td>');
                                  }
                                  else {
                                      $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleteme(this)"/></td>');
                                  }
                                  $mydata.push('<td style="display:none;" id="itemid">'); $mydata.push(itemdatadata[i].itemid); $mydata.push('</td>');
                                  $mydata.push('<td style="display:none;" id="Subcategoryid">'); $mydata.push(itemdatadata[i].Subcategoryid); $mydata.push('</td>');
                                  $mydata.push('<td style="display:none;" id="panelid">'); $mydata.push(itemdatadata[i].panelid); $mydata.push('</td>');
                                  $mydata.push('<td style="display:none;" id="savedid">'); $mydata.push(itemdatadata[i].savedid); $mydata.push('</td>');
                                  $mydata.push('</tr>');
                                  $mydata = $mydata.join("");
                                  $('#tblitemlist').append($mydata);
                              }

                          }
                          else {
                              toast('Error',"No Test Found");
                          }
                      });
                      
                  }
              }
              function setme(ctrl) {

                  if ($(ctrl).val().indexOf(" ") != -1) {
                      $(ctrl).val($(ctrl).val().replace(' ', ''));
                  }
                  if ($(ctrl).val().indexOf(".") != -1) {
                      $(ctrl).val($(ctrl).val().replace('.', ''));
                  }
                  var nbr = $(ctrl).val();
                  var decimalsQty = nbr.replace(/[^.]/g, "").length;
                  if (parseInt(decimalsQty) > 1) {
                      $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                  }
                  if ($(ctrl).val().length > 1) {
                      if (isNaN($(ctrl).val() / 1) == true) {
                          $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                      }
                  }
                  if (isNaN($(ctrl).val() / 1) == true) {
                      $(ctrl).val('');
                      return;
                  }
                  else if ($(ctrl).val() < 0) {
                      $(ctrl).val('');
                      return;
                  }
                  if ($(ctrl).val() > 100) {
                      $(ctrl).val('100');
                  }
                  if ($(ctrl).attr('id') == "txtdiscall") {
                      var val = $(ctrl).val();
                      var name = $(ctrl).attr("name");
                      $('input[name="' + name + '"]').each(function () {
                          $(this).val(val);
                          if (Number($(this).val()) > 0) {
                              $(this).closest('tr').find('#chk').attr('checked', true);
                          }
                          else {
                              $(this).closest('tr').find('#chk').attr('checked', false);
                          }
                      });
                  }
                  else if ($(ctrl).attr('id') == "txtdiscalldept") {
                      var val = $(ctrl).val();
                      var name = $(ctrl).attr("name");
                      $('input[name="' + name + '"]').each(function () {
                          $(this).val(val);
                          if (Number($(this).val()) > 0) {
                              $(this).closest('tr').find('#chk').attr('checked', true);
                          }
                          else {
                              $(this).closest('tr').find('#chk').attr('checked', false);
                          }
                      });
                  }
                  else if ($(ctrl).attr('id') == "ContentPlaceHolder1_tabHeader_tabPanelDefault_txtdefaultpercentage")
                  {
                  }
                  else
                  {
                      if (Number($(ctrl).val()) > 0) {                       
                          $(ctrl).closest('tr').find('#chk').attr('checked', true);
                      }
                      else {
                          $(ctrl).closest('tr').find('#chk').attr('checked', false);
                      }
                  }
              }
              function resetdata() {
                  window.location.reload();                 
              }
              function checkall(ctr) {
                  $('#tblitemlist tr').each(function () {
                      if ($(this).attr('id') != "ItemHeader") {
                          if ($(ctr).is(":checked")) {
                              $(this).find('#chk').attr('checked', true);
                          }
                          else {
                              $(this).find('#chk').attr('checked', false);
                          }
                      }
                  });
              }
              function checkalldept(ctr) {
                  $('#tbldepartmentlist tr').each(function () {
                      if ($(this).attr('id') != "ItemHeaderdept") {
                          if ($(ctr).is(":checked")) {
                              $(this).find('#chk').attr('checked', true);
                          }
                          else {
                              $(this).find('#chk').attr('checked', false);
                          }
                      }
                  });
              }
              function getdata() {
                  var dataIm = new Array();
                  $('#tblitemlist tr').each(function () {
                      if ($(this).attr("id") != "ItemHeader" && $(this).find("#chk").is(':checked')) {                                                 
                          var discper = $(this).closest("tr").find("#txtdisc").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisc").val());
                          var finddata = $(this).closest("tr").find("#panelid").text() + "#" + $(this).closest("tr").find("#Subcategoryid").text() + "#" + $(this).closest("tr").find("#itemid").text() + "#" + discper;
                          dataIm.push(finddata);
                      }
                  });
                  return dataIm;
              }
              function getdatadept() {
                  var dataIm = new Array();
                  $('#tbldepartmentlist tr').each(function () {
                      if ($(this).attr("id") != "ItemHeaderdept" && $(this).find("#chk").is(':checked')) {
                          var discper = $(this).closest("tr").find("#txtdisc").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisc").val());
                          var finddata = $(this).closest("tr").find("#panelid").text() + "#" + $(this).closest("tr").find("#Subcategoryid").text() + "#" + discper;
                          dataIm.push(finddata);
                      }
                  });
                  return dataIm;
              }
              function savedata() {
                  var id=$(".ajax__tab_active").first().attr('id');
                  var typeid = 0;
                  if (jQuery('#<%=ddlpanel.ClientID%>').val() == "0") {
                      toast('Error',"Please Select Panel");
                      return;
                  }                 
                  if (id == "ContentPlaceHolder1_tabHeader_tabPanelDefault_tab" && $('#ContentPlaceHolder1_tabHeader_tabPanelDefault_txtdefaultpercentage').val() == "") {
                      $('#ContentPlaceHolder1_tabHeader_tabPanelDefault_txtdefaultpercentage').focus();
                      toast('Error',"Please Enter Default Percentage");
                      return;
                  }
                  var defaultshare = $('#<%=txtdefaultpercentage.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtdefaultpercentage.ClientID%>').val());
                  var datatosavedept = getdatadept();
                  if (id == "ContentPlaceHolder1_tabHeader_tabPanelDepartment_tab" && datatosavedept.length == 0) {
                      toast('Error',"Please Select Department Data To Save");
                      return;
                  }
                 var datatosave = getdata();
                  if (id == "ContentPlaceHolder1_tabHeader_tabPanelTest_tab" && datatosave.length == 0) {
                      toast('Error',"Please Select Test Data To Save");
                      return;
                  }
                  if (id == "ContentPlaceHolder1_tabHeader_tabPanelDefault_tab") {
                      typeid = 1;
                  }
                  else if (id == "ContentPlaceHolder1_tabHeader_tabPanelDepartment_tab") {
                      typeid = 2;
                  }
                  else {
                      typeid = 3;
                  }                
                  serverCall('CoPaymentMaster.aspx/savealldata', { dataitem: datatosave, datadept: datatosavedept, defaultshare: defaultshare, panelid: $('#<%=ddlpanel.ClientID%>').val(), type: typeid }, function (response) {
                      if (response == "1") {
                          toast('Success',"Record Save Sucessfully");
                          if (id == "ContentPlaceHolder1_tabHeader_tabPanelDefault_tab") {
                              binddefaultdata();
                          }
                          else if (id == "ContentPlaceHolder1_tabHeader_tabPanelDepartment_tab") {
                              binddepartment();
                          }
                          else {
                              gettestlist();
                          }
                      }
                      else {
                          toast('Error',response);
                      }
                  });                 
              }

              function deleteme(ctrl) {
                  if (confirm("Do You Want To Delete This Data?")) {
                      $modelBlockUI();
                      var id = $(".ajax__tab_active").first().attr('id');
                      serverCall('CoPaymentMaster.aspx/deletesingledata', { id: $(ctrl).closest('tr').find('#savedid').text() }, function (response) {
                          if (response == "1") {
                              toast('Success', "Record Delete Sucessfully");
                              if (id == "ContentPlaceHolder1_tabHeader_tabPanelDefault_tab") {
                                  binddefaultdata();
                              }
                              else if (id == "ContentPlaceHolder1_tabHeader_tabPanelDepartment_tab") {
                                  binddepartment();
                              }
                              else {
                                  gettestlist();
                              }

                          }
                          else {
                              toast('Error',response);
                          }
                      });                     
                  }
              }

              function binddefaultdata() {
                  $('#<%=txtdefaultpercentage.ClientID%>').val('');
                  var panelid = jQuery('#<%=ddlpanel.ClientID%>').val();
                  if (panelid != "0") {
                      serverCall('CoPaymentMaster.aspx/binddefault', { panelid: panelid }, function (response) {
                          if (response != "") {
                              $('#tt').css('background-color', 'lightgreen');
                          }
                          else {
                              $('#tt').css('background-color', '');
                          }
                          $('#<%=txtdefaultpercentage.ClientID%>').val(response);
                      });
                   
                  }
                  else {
                      $('#tt').css('background-color', '');
                  }
              }
              </script>
          <script type="text/javascript">
             function clientActiveTabChanged(sender, args) {               
                 var selectedTab = sender.get_tabs()[sender.get_activeTabIndex()]._tab;
                 var tabText = selectedTab.childNodes[0].childNodes[0].childNodes[0].innerText;               
             }
         </script>
</asp:Content>

