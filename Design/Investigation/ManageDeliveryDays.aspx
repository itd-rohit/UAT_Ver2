<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageDeliveryDays.aspx.cs" Inherits="Design_Investigation_ManageDeliveryDays" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
  
      <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
 <%--Search Delivery Days--%>   
  <script type="text/javascript">

      function $getSearchData() {
          var $data = new Array();
          $data.push({
              TestName: jQuery('#txtTestname').val(),
              CentreId: $("#<%=ddlCentreAccess.ClientID %>").val(),
              SubCategoryId: $("#<%=ddlDepartment.ClientID %>").val(),
          });
          return $data;
      }

      var PatientData = "";
      var _PageSize;
      var _PageNo = 0;
      function Search() {
          var $searchData = $getSearchData();
          serverCall('ManageDeliveryDays.aspx/GetDeliveryDays', { searchData: $searchData }, function (response) {
              PatientData = $.parseJSON(response);

              debugger;             
              if (PatientData.length != 0) {
                  $("#btnSave").show();
              }
              else {
                  $("#btnSave").hide();
                  toast("Info", "No Record Found!", "");
              }
              _PageSize = 300;
              _PageNo = 0;

              var output = $('#tb_InvestigationItems').parseTemplate(PatientData);

              $('#div_InvestigationItems').html(output);
              tabfunc();              
          });
      }
  
   
      function nmrcOnly(ctrl)
      {
          if ($(ctrl).val().indexOf(".") != -1) {
              $(ctrl).val($(ctrl).val().replace('.', ''));
          }
          if ($(ctrl).val().indexOf(" ") != -1) {
              $(ctrl).val($(ctrl).val().replace(' ', ''));
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
      }       
   </script>
   <%--TableFunctions--%>
 <script type="text/javascript">
     function tabfunc() {

         $('#tb_grdLabSearch tr').each(function () {
             var id = $(this).closest("tr").attr("id");
             if (id != "Header") {
                 $(this).closest("tr").find("#ddlptype").val($(this).closest("tr").find("#Td1").text());
                 $(this).closest("tr").find("#ddltattype").val($(this).closest("tr").find("#Td2").text());


                 if ($(this).closest("tr").find("#ddltattype").val() == "Hours") {
                     $(this).closest("tr").find("#txtprocessinghrs").val('0');
                     $(this).closest("tr").find("#txtprocessinghrs").attr('disabled', true);
                     $(this).closest("tr").find("#div_Weeks").hide();
                     $(this).closest("tr").find("#chkSun").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkSun").attr("flag", "0");
                     $(this).closest("tr").find("#chkMon").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkMon").attr("flag", "0");
                     $(this).closest("tr").find("#chkTue").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkTue").attr("flag", "0");
                     $(this).closest("tr").find("#chkWed").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkWed").attr("flag", "0");
                     $(this).closest("tr").find("#chkThu").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkThu").attr("flag", "0");
                     $(this).closest("tr").find("#chkFri").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkFri").attr("flag", "0");
                     $(this).closest("tr").find("#chkSat").removeClass("GridViewDragItemStyle");
                     $(this).closest("tr").find("#chkSat").attr("flag", "0");
                     $(this).closest("tr").find("#cutofftime").attr('disabled', true);
                     $(this).closest("tr").find("#cutofftime").val('00:00:00');
                     $(this).closest("tr").find("#cutofftime1").attr('disabled', true);
                     $(this).closest("tr").find("#cutofftime1").val('00:00:00');
                     $(this).closest("tr").find("#cutofftime2").attr('disabled', true);
                     $(this).closest("tr").find("#cutofftime2").val('00:00:00');
                     $(this).closest("tr").find("#txtsamedaydelivery").attr('disabled', true);
                     $(this).closest("tr").find("#txtsamedaydelivery").val('00:00:00');
                     $(this).closest("tr").find("#txtsamedaydelivery1").attr('disabled', true);
                     $(this).closest("tr").find("#txtsamedaydelivery1").val('00:00:00');
                     $(this).closest("tr").find("#txtsamedaydelivery2").attr('disabled', true);
                     $(this).closest("tr").find("#txtsamedaydelivery2").val('00:00:00');
                     $(this).closest("tr").find("#txtnextdaydelivery").attr('disabled', true);
                     $(this).closest("tr").find("#txtnextdaydelivery").val('00:00:00');
                     $(this).closest("tr").find("#txtworkinghours").attr('disabled', false);
                     $(this).closest("tr").find("#txtnonworkinghours").attr('disabled', false);
                   //  $(this).closest("tr").find("#txtstat").attr('disabled', false);
                     $(this).closest("tr").find("#txtapprovaltodispatch").attr('disabled', false);
                 }
                 else {
                   //  $(this).closest("tr").find("#txtprocessinghrs").val('0');
                     $(this).closest("tr").find("#txtprocessinghrs").attr('disabled', false);
                     $(this).closest("tr").find("#div_Weeks").show();
                     $(this).closest("tr").find("#chkSun").attr('disabled', false);
                     $(this).closest("tr").find("#chkMon").attr('disabled', false);
                     $(this).closest("tr").find("#chkTue").attr('disabled', false);
                     $(this).closest("tr").find("#chkWed").attr('disabled', false);
                     $(this).closest("tr").find("#chkThu").attr('disabled', false);
                     $(this).closest("tr").find("#chkFri").attr('disabled', false);
                     $(this).closest("tr").find("#chkSat").attr('disabled', false);
                     $(this).closest("tr").find("#cutofftime").attr('disabled', false);
                   //  $(this).closest("tr").find("#cutofftime").val('10:00am');
                     $(this).closest("tr").find("#cutofftime1").attr('disabled', false);
                   //  $(this).closest("tr").find("#cutofftime1").val('12:00pm');
                     $(this).closest("tr").find("#cutofftime2").attr('disabled', false);
                    // $(this).closest("tr").find("#cutofftime2").val('2:00pm');
                     $(this).closest("tr").find("#txtsamedaydelivery").attr('disabled', false);
                    // $(this).closest("tr").find("#txtsamedaydelivery").val('6:00pm');
                     $(this).closest("tr").find("#txtsamedaydelivery1").attr('disabled', false);
                  //   $(this).closest("tr").find("#txtsamedaydelivery1").val('6:00pm');
                     $(this).closest("tr").find("#txtsamedaydelivery2").attr('disabled', false);
                  //   $(this).closest("tr").find("#txtsamedaydelivery2").val('6:00pm');
                     $(this).closest("tr").find("#txtnextdaydelivery").attr('disabled', false);
                  //   $(this).closest("tr").find("#txtnextdaydelivery").val('12:00pm');
                     $(this).closest("tr").find("#txtworkinghours").val('0');
                     $(this).closest("tr").find("#txtworkinghours").attr('disabled', true);
                     $(this).closest("tr").find("#txtnonworkinghours").val('0');
                     $(this).closest("tr").find("#txtnonworkinghours").attr('disabled', true);
                   //  $(this).closest("tr").find("#txtstat").val('0');
                  //   $(this).closest("tr").find("#txtstat").attr('disabled', true);
                     $(this).closest("tr").find("#txtapprovaltodispatch").val('0');
                   //  $(this).closest("tr").find("#txtapprovaltodispatch").attr('disabled', true);

                 }
                 $(this).closest("tr").find("#labstarttime").timepicker();
                 $(this).closest("tr").find("#labendtime").timepicker();
                 $(this).closest("tr").find("#cutofftime").timepicker();
                 $(this).closest("tr").find("#cutofftime1").timepicker();
                 $(this).closest("tr").find("#cutofftime2").timepicker();
                 $(this).closest("tr").find("#txtsamedaydelivery").timepicker();
                 $(this).closest("tr").find("#txtsamedaydelivery1").timepicker();
                 $(this).closest("tr").find("#txtsamedaydelivery2").timepicker();
                 $(this).closest("tr").find("#txtnextdaydelivery").timepicker();
             }
             else {
                 $(this).closest("tr").find("#t1head").timepicker();
                 $(this).closest("tr").find("#t2head").timepicker();
                 $(this).closest("tr").find("#t3head").timepicker();
                 $(this).closest("tr").find("#t4head").timepicker();
                 $(this).closest("tr").find("#t5head").timepicker();
                 $(this).closest("tr").find("#t6head").timepicker();
                 $(this).closest("tr").find("#t7head").timepicker();
                 $(this).closest("tr").find("#t8head").timepicker();
                 $(this).closest("tr").find("#t9head").timepicker();
             }
         });

         $("#tb_grdLabSearch tr").find("span").click(function () {
             if ($(this).hasClass("GridViewDragItemStyle")) {
                 $(this).removeClass("GridViewDragItemStyle");
                 $(this).attr("flag", "0");
             }
             else {
                 $(this).addClass("GridViewDragItemStyle");
                 $(this).attr("flag", "1");
             }
         });

         $("#chkheader").click(function () {
             var checked = $("#chkheader").is(":checked");
             $("#tb_grdLabSearch tr").find("#chk").attr("checked", checked);
         });
         $("#chk1").click(function () {
             var checked = $("#chk1").is(":checked");
             $("#tb_grdLabSearch tr").find("#chkssamedayApplicable").attr("checked", checked);
         });
         $("#chk2").click(function () {
             var checked = $("#chk2").is(":checked");
             $("#tb_grdLabSearch tr").find("#chkssameday1Applicable").attr("checked", checked);
         });
         $("#chk3").click(function () {
             var checked = $("#chk3").is(":checked");
             $("#tb_grdLabSearch tr").find("#chkssameday2Applicable").attr("checked", checked);
         });
     }
 
     function chkAll(ctrl, chk) {
         if ($(ctrl).hasClass("GridViewDragItemStyle")) {
             $(ctrl).removeClass("GridViewDragItemStyle");
             $("#tb_grdLabSearch tr").find("#" + chk).attr("flag", "0").removeClass("GridViewDragItemStyle");
         }
         else {
             $(ctrl).addClass("GridViewDragItemStyle");
             $("#tb_grdLabSearch tr").find("#" + chk).attr("flag", "1").addClass("GridViewDragItemStyle");
         }
     };

 </script>  
 <script type="text/javascript">
 $(document).ready(function () {
     var output = $('#tb_InvestigationItems').parseTemplate(PatientData);                      
     $('#div_InvestigationItems').html(output);                
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
 function showme(ctrl) {
     var val = $(ctrl).val();
     var name = $(ctrl).attr("name");

     $('input[name="' + name + '"]').each(function () {
         $(this).val(val);
     });
 }
 function showmeddl(ctrl) {
    var valtat = $(ctrl).val();
     var name = $(ctrl).attr("name");

     //$('input[name="' + name + '"]').each(function () {
     //    $(this).val(val);
     //});
     $('#tb_grdLabSearch tr').each(function () {
         var id = $(this).closest("tr").attr("id");
         if (id != "Header") {
			$(this).closest("tr").find("#ddltattype").val(valtat);
			 $(this).closest("tr").find("#ddltattype option:selected").text(valtat);
			 setcontrol(this,valtat);
         }
     });
 }
 function showme1(ctrl) {
     if ($(ctrl).val().indexOf(".") != -1) {
         $(ctrl).val($(ctrl).val().replace('.', ''));
     }
     if ($(ctrl).val().indexOf(" ") != -1) {
         $(ctrl).val($(ctrl).val().replace(' ', ''));
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
     var val = $(ctrl).val();
     var name = $(ctrl).attr("name");

     $('input[name="' + name + '"]').each(function () {
         $(this).val(val);
     });
 }
 
 </script>
 
<Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
</Ajax:ScriptManager>
    
   <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <div class="row">
    <div class="col-md-24" style="text-align:center;">
    <b>Manage Delivery Days(TAT)</b></div>
     
   </div>
   </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> 
        Search criteria</div>
                  <div class="POuter_Box_Inventory"> 
                      <div class="row">
                          <div class="col-md-4">
                              Centre:
                          </div>
                          <div class="col-md-8">
                              <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" Width="350px" runat="server">                            
                        </asp:DropDownList>
                              </div>
                          <div class="col-md-4">
                              Department :
                          </div>
                          <div class="col-md-8">
                               <asp:DropDownList ID="ddlDepartment"  Width="235px" runat="server">
                        </asp:DropDownList>
                              </div>
                          </div>
                       <div class="row">
                          <div class="col-md-4">Test Name:
                              </div>
                            <div class="col-md-8"><input id="txtTestname" type="text" style="width: 222px"  class="1"/> 
                              </div>
                            <div class="col-md-4">
                              </div>
                            <div class="col-md-8">
                              </div>
                           </div>                    
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center"  >
            <div class="row">
                <div class="col-md-24">
        <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="searchbutton"   />
                   &nbsp;&nbsp; <input id="btnSave" type="button" value="Save"  onclick="save();" class="savebutton" style= "display:none;"   />
                </div>
                </div>                    
             <div class="row">
                <div class="col-md-24">
                    <center>
            <table  style="width:80%;border-collapse:collapse">
                        <tr>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 25px;display:none; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:  #FC834E;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="display:none;">
                              &nbsp;<b>Pre Analytical TAT</b></td> 
  <td style="width: 25px;display:none; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:  #f5cfe9;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="display:none;">
                              &nbsp;<b>Analytical TAT (Deparrtment recive to Approval)</b></td>
                              <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid;display:none; border-bottom: black thin solid; background-color:  #7BFA6A;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="display:none;">
                              &nbsp;<b>Post Analytical TAT
</b></td>
                           
                        </tr>
                    </table>

               </center>
                    </div>                 
                 </div>           
        </div>
       <div class="POuter_Box_Inventory"> 
         <div class="Purchaseheader">
                Search Result
            </div>
            <div class="row">
                <div class="col-md-24">
           <div id="div_InvestigationItems" >
                
            </div>
                    </div>
                </div>
        </div>        
        </div>                                     
   </div>
   
      <script id="tb_InvestigationItems" type="text/html">
            
          <# if(_PageNo==0){#>

        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"  style="width: 99%;table-layout:fixed;">
		
            <tr id="Header">
                <th class="GridViewHeaderStyle" scope="col" style="width: 25px;">#</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;" align="left">Lab Start Time

                     <input type="text" style="width:60px;" name="t1" id="t1head" value="8:00am" onblur="showme(this)"   />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;" align="left">Lab End Time
                    <input type="text" style="width:60px;" name="t2" id="t2head" value="6:00pm" onblur="showme(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" align="left" style="width: 180px;">Test Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 85px;">Process Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;display:none;">SR To DR
                    <input type="text" name="clsrtodr" style="width:35px;" onkeyup="showme1(this)"  value="0" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;display:none;">SR To ST
                     <input type="text" name="clsrtost" style="width:35px;" onkeyup="showme1(this)" value="0" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 45px;display:none;">ST To SLR
                     <input type="text" name="clsttoslr" style="width:35px;" onkeyup="showme1(this)"  value="0" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 45px;display:none;">SLR To ST
                     <input type="text" name="clslrtost" style="width:35px;" onkeyup="showme1(this)"  value="0" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;">TATType
                    <select id="ddltattype2" name="ddltattype"  onchange="showmeddl(this)">
                        <option></option>
    <option>Hours</option>
    <option>Days</option>
</select>
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;">Working Hours
                    <input type="text" style="width:30px;" name="txtworkinghours" id="txtworhead" value="0" onkeyup="showme1(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;">Non Working Hours
                    <input type="text" style="width:30px;" name="txtnonworkinghours" id="txtnonworhead" value="0" onkeyup="showme1(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 55px;">Urgent TAT
                    <input type="text" style="width:30px;" name="txtstat" id="txtstathead" value="0" onkeyup="showme1(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Days
                     <input type="text" name="cldays" style="width:35px;" onkeyup="showme1(this)"  value="0" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 245px;" align="left">
                    <div id="div_WeeksHead">
                        <label id="chkSunHead" style="cursor: pointer;" onclick="chkAll(this,'chkSun')">Sun </label>
                        &nbsp;
                    <label id="chkMonHead" style="cursor: pointer;" onclick="chkAll(this,'chkMon')">Mon </label>
                        &nbsp;
                    <label id="chkTueHead" style="cursor: pointer;" onclick="chkAll(this,'chkTue')">Tue </label>
                        &nbsp;
                    <label id="chkWedHead" style="cursor: pointer;" onclick="chkAll(this,'chkWed')">Wed </label>
                        &nbsp;
                    <label id="chkThuHead" style="cursor: pointer;" onclick="chkAll(this,'chkThu')">Thu </label>
                        &nbsp; 
                    <label id="chkFriHead" style="cursor: pointer;" onclick="chkAll(this,'chkFri')">Fri </label>
                        &nbsp;
                    <label id="chkSatHead" style="cursor: pointer;" onclick="chkAll(this,'chkSat')">Sat </label>
                        &nbsp;
                    </div>
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">CutoffTime
                    <input type="text" style="width:60px;" name="t3" id="t3head" value="10:00am" onblur="showme(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Same Day delivery Time
                     <input type="text" style="width:60px;" name="t4" id="t4head" value="6:00pm"  onblur="showme(this)" />
                    <input id="chk1" type="checkbox" />
                    
                </th>
                 <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">CutoffTime (2)
                    <input type="text" style="width:60px;" name="t6" id="t6head" value="12:00pm" onblur="showme(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Same Day delivery Time (2)
                     <input type="text" style="width:60px;" name="t7" id="t7head" value="6:00pm"  onblur="showme(this)" />
                    <input id="chk2" type="checkbox" />
                </th>
                 <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">CutoffTime (3)
                    <input type="text" style="width:60px;" name="t8" id="t8head" value="2:00pm" onblur="showme(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Next Day delivery Time (1)
                     <input type="text" style="width:60px;" name="t9" id="t9head" value="6:00pm"  onblur="showme(this)" />
                    <input id="chk3" type="checkbox" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Next Day delivery Time (2)
                     <input type="text" style="width:60px;" name="t5" id="t5head" value="12:00pm" onblur="showme(this)"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 65px;display:none;">Approval To Dispatch</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">
                    <input id="chkheader" type="checkbox" /></th>


            </tr>

<#}#>
       <#
            
             var dataLength=PatientData.length;
              var LastDataIndex=_PageSize+(_PageNo*_PageSize);
            

   if(LastDataIndex>dataLength)
  LastDataIndex=dataLength;

           

              window.status="Total Records Found :"+ dataLength;
              var objRow;   
         for(var j=_PageNo*_PageSize;j<LastDataIndex;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.SubCategoryID#>|<#=objRow.Type_ID#>|<#=objRow.CentreId#>" >
<td class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;"><#=j+1#> <input type="hidden" id="hdnRowId" value="<#=objRow.RowId#>" /> </td>
<td id="tdstarttime"  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;">
    <input type="text" style="width:60px;" id="labstarttime" value="<#=objRow.labstarttime#>" name="t1"  />
</td>
   <td id="tdendtime"  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;">
    <input type="text" style="width:60px;" id="labendtime" value="<#=objRow.labendtime#>" name="t2" />
</td>
<td id="InvName" class="GridViewLabItemStyle"  style="background-color:lightgoldenrodyellow;font-weight:bold;"><#=objRow.InvName#></td>

                        <td id="tdptype" class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;">
<select id="ddlptype"  disabled="disabled">
    <option>InHouse</option>
    <option>OutHouse</option>
</select>
</td> 

                         <td id="tdsrtodr" style="background-color:#FC834E;display:none;" class="GridViewLabItemStyle"> <input onkeyup="nmrcOnly(this)" id="txtsrtodr" type="text" value="<#=objRow.SR_To_DR#>" style="width:35px;" name="clsrtodr" /> </td>
                         <td id="tdsrtost" style="background-color:#FC834E;display:none;" class="GridViewLabItemStyle"><input onkeyup="nmrcOnly(this)" id="txtsrtost" type="text" value="<#=objRow.SR_To_ST#>" style="width:35px;" name="clsrtost" /></td>
                         <td id="tdsttoslr" style="background-color:#FC834E;display:none;" class="GridViewLabItemStyle"><input onkeyup="nmrcOnly(this)" id="txtsttoslr" type="text" value="<#=objRow.ST_To_SLR#>" style="width:35px;" name="clsttoslr" /></td>
                         <td id="tdslrtodr" style="background-color:#FC834E;display:none;" class="GridViewLabItemStyle"><input onkeyup="nmrcOnly(this)" id="txtslrtodr" type="text" value="<#=objRow.SLR_To_DR#>" style="width:35px;" name="clslrtost" /></td>



<td id="tddaytype" class="GridViewLabItemStyle" style="background-color:#f5cfe9;"  >
<select id="ddltattype" name="ddltattype" onchange="setcontrol(this)">
    <option value="Hours">Hours</option>
    <option value="Days">Days</option>
</select>
</td>

                        

                        <td class="GridViewLabItemStyle" style="background-color:#f5cfe9;"  id="tdworinghours"><input onkeyup="nmrcOnly(this)" type="text" style="width:50px"  name ="txtworkinghours" id="txtworkinghours" value="<#=objRow.woringhours#>" /> </td>
                        <td class="GridViewLabItemStyle" style="background-color:#f5cfe9;"  id="tdnonworinghours"><input onkeyup="nmrcOnly(this)" type="text" style="width:50px" name="txtnonworkinghours" id="txtnonworkinghours" value="<#=objRow.nonworinghours#>" /> </td>
                        <td class="GridViewLabItemStyle" style="background-color:#f5cfe9;"  id="tdstat"><input onkeyup="nmrcOnly(this)" type="text" style="width:50px"name="txtstat" id="txtstat" value="<#=objRow.stathours#>" /> </td>
<td id="processinnghrs" class="GridViewLabItemStyle" style="background-color:#f5cfe9;width:40px;" ><input name="cldays" onkeyup="nmrcOnly(this)" type="text" id="txtprocessinghrs" style="width:30px;"   value="<#=objRow.Days#>"/></td>
<td id="DayType1" class="GridViewLabItemStyle" style="background-color:#f5cfe9;" >

<div  id="div_Weeks">
<span id="chkSun"  flag="<#=objRow.Sun#>" style="cursor:pointer;"
    <# if(objRow.Sun=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>
     >Sun </span> &nbsp;
<span id="chkMon"  flag="<#=objRow.Mon#>" style="cursor:pointer;"
    
      <# if(objRow.Mon=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>

      >Mon </span> &nbsp;
<span id="chkTue"  flag="<#=objRow.Tue#>" style="cursor:pointer;" 
     <# if(objRow.Tue=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>
     >Tue </span> &nbsp;
<span id="chkWed"  flag="<#=objRow.Wed#>" style="cursor:pointer;" 
     <# if(objRow.Wed=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>
     >Wed </span> &nbsp;
<span id="chkThu"  flag="<#=objRow.Thu#>" style="cursor:pointer;" 
     <# if(objRow.Thu=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>
     >Thu </span> &nbsp; 
<span id="chkFri"  flag="<#=objRow.Fri#>" style="cursor:pointer;" 
    
     <# if(objRow.Fri=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>

     >Fri </span> &nbsp;
<span id="chkSat"  flag="<#=objRow.Sat#>" style="cursor:pointer;" 
     <# if(objRow.Sat=="1")
    {
    #>
     class="GridViewDragItemStyle"
    <#}#>
    
     >Sat </span> &nbsp;
</div>
</td>
<td class="GridViewLabItemStyle" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="cutofftime"    value="<#=objRow.CutOffTime#>" style="width:70px;" name="t3"/>
</td>
<td class="GridViewLabItemStyle"  id="samedaydelivery" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="txtsamedaydelivery"   value="<#=objRow.samedaydeliverytime#>" style="width:70px;" name="t4"/>
     <# if(objRow.IsApplicable=="1"){#>
    <input type="checkbox"  style="width:70px;" checked="checked"  name="t10" id="chkssamedayApplicable" />
    <#}else{#>
    <input type="checkbox"  style="width:70px;"   name="t10" id="chkssamedayApplicable" />
    <#}#>
</td>
<# if(objRow.Depttype!="NonPath"){#>
<td class="GridViewLabItemStyle" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="cutofftime1"    value="<#=objRow.CutOffTime1#>" style="width:70px;" name="t6"/>
</td>
<td class="GridViewLabItemStyle"  id="samedaydelivery1" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="txtsamedaydelivery1"   value="<#=objRow.samedaydeliverytime1#>" style="width:70px;" name="t7"/>
     <# if(objRow.IsApplicable1=="1"){#>
    <input type="checkbox"  style="width:70px;" checked="checked"    name="t11" id="chkssameday1Applicable" />
     <#}else{#>
     <input type="checkbox"  style="width:70px;"    name="t11" id="chkssameday1Applicable" />
    <#}#>
</td>
                         
<td class="GridViewLabItemStyle" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="cutofftime2"    value="<#=objRow.CutOffTime2#>" style="width:70px;" name="t8"/>
</td>
<td class="GridViewLabItemStyle"  id="samedaydelivery2" style="background-color:#f5cfe9;width:30px;" >
<input type="text"  id="txtsamedaydelivery2"   value="<#=objRow.samedaydeliverytime2#>" style="width:70px;" name="t9"/>
     <# if(objRow.IsApplicable2=="1"){#>
      <input type="checkbox"  style="width:70px;"  checked="checked"   name="t12" id="chkssameday2Applicable" />
     <#}else{#>
     <input type="checkbox"  style="width:70px;"    name="t12" id="chkssameday2Applicable" />
    <#}#>
</td>
    <td class="GridViewLabItemStyle"  id="nextdaydelivery" style="background-color:#f5cfe9;width:30px;" >
        <input type="text"  id="txtnextdaydelivery"    value="<#=objRow.nextdaydeliverytime#>" style="width:70px;" name="t5"/>
    </td>
                        <#}else{#>
                        <td class="GridViewLabItemStyle"  style="background-color:#f5cfe9;width:30px;"></td>
                        <td class="GridViewLabItemStyle"  style="background-color:#f5cfe9;width:30px;"></td>
                        <td class="GridViewLabItemStyle"  style="background-color:#f5cfe9;width:30px;"></td>
						<td class="GridViewLabItemStyle"  style="background-color:#f5cfe9;width:30px;"></td>
						<td class="GridViewLabItemStyle"  style="background-color:#f5cfe9;width:30px;"></td>
                        <#}#>
  <td class="GridViewLabItemStyle"  id="approval_to_dispatch" style="display:none;background-color:#7BFA6A;">
        <input type="text" id="txtapprovaltodispatch"  value="<#=objRow.Approval_To_Dispatch#>" onkeyup="nmrcOnly(this)" style="width:55px;"/>
    </td>

<td class="GridViewLabItemStyle" style="width:10px;background-color:lightgoldenrodyellow;"  ><input id="chk" type="checkbox" /></td>

                      
                         <td id="Td1" style="display:none;"><#=objRow.Processtype#></td>
                         <td id="Td2" style="display:none;"><#=objRow.TATType#></td>
                         

</tr>
            <#}#>

   
    <#if(_PageNo==0){#>
     </table> 
           <#}
           
           _PageNo++;
          
           #>
       
    </script>
    
   <%--Saving Delivery Days--%> 
     <script type="text/javascript">
         function createdatatodave() {
             var daattosave = new Array();

             $('#tb_grdLabSearch tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "Header") {
                     if ($(this).closest("tr").find("#chk").is(':checked')) {
                         var objPLO = new Object();
                         
                         objPLO.RowId = $(this).closest("tr").find("#hdnRowId").val();
                         objPLO.CentreID = id.split('|')[2];
                         objPLO.labstarttime = $(this).closest("tr").find("#labstarttime").val();
                         objPLO.labendtime = $(this).closest("tr").find("#labendtime").val(); 
                         objPLO.Processtype = $(this).closest("tr").find("#ddlptype").val();
                         objPLO.SR_To_DR = $(this).closest("tr").find("#txtsrtodr").val();
                         objPLO.SR_To_ST = $(this).closest("tr").find("#txtsrtost").val();
                         objPLO.ST_To_SLR = $(this).closest("tr").find("#txtsttoslr").val();
                         objPLO.SLR_To_DR = $(this).closest("tr").find("#txtslrtodr").val();
                         objPLO.SubcategoryID = id.split('|')[0];
                         objPLO.Investigation_ID = id.split('|')[1];
                         objPLO.TATType = $(this).closest("tr").find("#ddltattype").val();
                         objPLO.woringhours = $(this).closest("tr").find("#txtworkinghours").val();
                         objPLO.nonworinghours = $(this).closest("tr").find("#txtnonworkinghours").val();
                         objPLO.stathours = $(this).closest("tr").find("#txtstat").val();
                         objPLO.Days = $(this).closest("tr").find("#txtprocessinghrs").val();

                         objPLO.Sun = $(this).closest("tr").find("#chkSun").attr("flag");
                         objPLO.Mon = $(this).closest("tr").find("#chkMon").attr("flag");
                         objPLO.Tue = $(this).closest("tr").find("#chkTue").attr("flag");;
                         objPLO.Wed = $(this).closest("tr").find("#chkWed").attr("flag");
                         objPLO.Thu = $(this).closest("tr").find("#chkThu").attr("flag");
                         objPLO.Fri = $(this).closest("tr").find("#chkFri").attr("flag");
                         objPLO.Sat = $(this).closest("tr").find("#chkSat").attr("flag");
                         objPLO.CutOffTime = $(this).closest("tr").find("#cutofftime").val();
                         objPLO.samedaydeliverytime = $(this).closest("tr").find("#txtsamedaydelivery").val();
                         objPLO.IsApplicable = ($(this).closest("tr").find("#chkssamedayApplicable").is(':checked') == true) ? 1 : 0;
                         objPLO.CutOffTime1 = $(this).closest("tr").find("#cutofftime1").val();
                         objPLO.samedaydeliverytime1 = $(this).closest("tr").find("#txtsamedaydelivery1").val();
                         objPLO.IsApplicable1 = ($(this).closest("tr").find("#chkssameday1Applicable").is(':checked') == true) ? 1 : 0;
                         objPLO.CutOffTime2 = $(this).closest("tr").find("#cutofftime2").val();
                         objPLO.samedaydeliverytime2 = $(this).closest("tr").find("#txtsamedaydelivery2").val();
                         objPLO.IsApplicable2 = ($(this).closest("tr").find("#chkssameday2Applicable").is(':checked') == true) ? 1 : 0;
                         objPLO.nextdaydeliverytime = $(this).closest("tr").find("#txtnextdaydelivery").val();
                         objPLO.Approval_To_Dispatch = $(this).closest("tr").find("#txtapprovaltodispatch").val();

                         daattosave.push(objPLO);
                     }
                 }
             });
             return daattosave;
         }

         function save() {
             $("#btnSave").attr('disabled', true);
             var $objsavedata = createdatatodave();

             if ($objsavedata == "") {
                 toast("Error", "Kindly select an Investigation", "");                 
                 $("#btnSave").attr('disabled', false);
                 return;
             }
             serverCall('ManageDeliveryDays.aspx/SaveInvDeliveryDays', { objsavedata: $objsavedata }, function (response) {
                 var $responsedata = JSON.parse(response);
                 if ($responsedata.status) {
                     toast("Success", "Record Saved Successfully", "");
                     $("#tb_grdLabSearch tr").remove();
                     Search();
                 }
                 else {
                     toast("Error", $responsedata.response, "");
                 }
                 $("#btnSave").attr('disabled', false);
             });          
         }  

         function setcontrol(ctrl,TATType) {
			if ($(ctrl).val()!="")
				TATType=$(ctrl).val();
             if (TATType == "Hours") {
                 $(ctrl).closest("tr").find("#txtprocessinghrs").val('0');
                 $(ctrl).closest("tr").find("#txtprocessinghrs").attr('disabled', true);
                 $(ctrl).closest("tr").find("#div_Weeks").hide();
                 $(ctrl).closest("tr").find("#chkSun").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkSun").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkMon").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkMon").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkTue").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkTue").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkWed").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkWed").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkThu").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkThu").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkFri").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkFri").attr("flag", "0");
                 $(ctrl).closest("tr").find("#chkSat").removeClass("GridViewDragItemStyle");
                 $(ctrl).closest("tr").find("#chkSat").attr("flag", "0");
                 $(ctrl).closest("tr").find("#cutofftime").attr('disabled', true);
                 $(ctrl).closest("tr").find("#cutofftime").val('00:00:00');
                 $(ctrl).closest("tr").find("#cutofftime1").attr('disabled', true);
                 $(ctrl).closest("tr").find("#cutofftime1").val('00:00:00');
                 $(ctrl).closest("tr").find("#cutofftime2").attr('disabled', true);
                 $(ctrl).closest("tr").find("#cutofftime2").val('00:00:00');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery").val('00:00:00');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery1").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery1").val('00:00:00');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery2").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery2").val('00:00:00');
                 $(ctrl).closest("tr").find("#txtnextdaydelivery").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtnextdaydelivery").val('00:00:00');
                 $(ctrl).closest("tr").find("#txtworkinghours").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtnonworkinghours").attr('disabled', false);
                // $(ctrl).closest("tr").find("#txtstat").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtapprovaltodispatch").attr('disabled', false);
             }
             else {
               //  $(ctrl).closest("tr").find("#txtprocessinghrs").val('0');
                 $(ctrl).closest("tr").find("#txtprocessinghrs").attr('disabled', false);
                 $(ctrl).closest("tr").find("#div_Weeks").show();
                 $(ctrl).closest("tr").find("#chkSun").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkMon").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkTue").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkWed").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkThu").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkFri").attr('disabled', false);
                 $(ctrl).closest("tr").find("#chkSat").attr('disabled', false);
                 $(ctrl).closest("tr").find("#cutofftime").attr('disabled', false);
                 $(ctrl).closest("tr").find("#cutofftime").val('10:00am');
                 $(ctrl).closest("tr").find("#cutofftime1").attr('disabled', false);
                 $(ctrl).closest("tr").find("#cutofftime1").val('12:00pm');
                 $(ctrl).closest("tr").find("#cutofftime1").attr('disabled', false);
                 $(ctrl).closest("tr").find("#cutofftime2").val('2:00pm');
				 $(ctrl).closest("tr").find("#cutofftime2").attr('disabled', false);
                 $(ctrl).closest("tr").find("#cutofftime1").val('2:00pm');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery").val('6:00pm');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery1").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery1").val('6:00pm');
                 $(ctrl).closest("tr").find("#txtsamedaydelivery2").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtsamedaydelivery2").val('6:00pm');
                 $(ctrl).closest("tr").find("#txtnextdaydelivery").attr('disabled', false);
                 $(ctrl).closest("tr").find("#txtnextdaydelivery").val('12:00pm');
                 $(ctrl).closest("tr").find("#txtworkinghours").val('0');
                 $(ctrl).closest("tr").find("#txtworkinghours").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtnonworkinghours").val('0');
                 $(ctrl).closest("tr").find("#txtnonworkinghours").attr('disabled', true);
               //  $(ctrl).closest("tr").find("#txtstat").val('0');
               //  $(ctrl).closest("tr").find("#txtstat").attr('disabled', true);
                 $(ctrl).closest("tr").find("#txtapprovaltodispatch").val('0');
               //  $(ctrl).closest("tr").find("#txtapprovaltodispatch").attr('disabled', true);

             }
         }
 </script>
</asp:Content>

