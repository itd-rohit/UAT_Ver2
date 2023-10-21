<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="ChangeDeliveryStatus.aspx.cs" Inherits="Design_Lab_ChangeDeliveryStatus" MasterPageFile="~/Design/DefaultHome.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
      <%: Scripts.Render("~/bundles/confirmMinJS") %>
	<script src="../../ckeditor/ckeditor.js"></script>
       <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
      <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/cropzee.js"></script>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery.Jcrop.css"  />
  <script type="text/javascript" language="javascript">
      function SetEnableDisable(rowid) {

          if ($(rowid).is(':checked')) {
              $(rowid).parents("tr").find('.datepic').removeAttr('disabled');
              $(rowid).parents("tr").find('.timepicker').removeAttr('disabled');
          }
          else {
              $(rowid).parents("tr").find('.datepic').attr('disabled', true);
              $(rowid).parents("tr").find('.timepicker').attr('disabled', true);
          }
      }
      checkall = function () {
          if ($('#chkheader').prop('checked') == true) {
              $('#tb_grdLabSearch tr').each(function () {
                  var id = $(this).closest("tr").attr("id");
                   //var id1 = $(this).closest("tr").attr("id");
                  if (id != "Header") {
                      $(this).closest("tr").find('#chk').prop('checked', true);
                      var tid1 = $(this).closest("tr").find('#chk');
                      SetEnableDisable(tid1);
                     
                  }
              });
          }
          else {
              $('#tb_grdLabSearch tr').each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "Header") {
                      $(this).closest("tr").find('#chk').prop('checked', false);
                      var tid1 = $(this).closest("tr").find('#chk');
                      SetEnableDisable(tid1);
                  }
              });
          }
      }
     


  </script>


  <div id="Pbody_box_inventory" style="width:97%;">
  <div class="POuter_Box_Inventory" style="width:99.6%;">
<div class="content" style="text-align:center; ">   
<b>Change Date && Time</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   
</div>
</div>
      <div class="POuter_Box_Inventory" style="width:99.6%;">
            <div class="content">

                <table width="99%">
                  

                    <tr>
                        <td  style="text-align:center">
                            <strong>Lab No:  &nbsp;&nbsp; </strong>  &nbsp;<asp:TextBox ID="txtLabNo" runat="server" Width="150px" /> 
                            <input type="button" id="btnsearch" onclick="GetData()" value="Search"  class="ItDoseButton" />
                        </td>
                    </tr>
                </table>
               
                </div>
              </div> 
          <div class="Outer_Box_Inventory" style="width: 99.6%; "  > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow:auto;width:99.6%;">
                
            </div>
        </div>
          <div class="POuter_Box_Inventory" style="width:99.6%;">
               <div class="content" style="text-align:center;">
                   <input type="button" id="btnUpdate" value="Save" onclick="SaveRecord()" tabindex="9" class="ItDoseButton" />
                     <input type="button" value="Cancel" onclick="clearForm()" class="ItDoseButton" />
                   </div>
                 </div>
   
   
  </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:99.7%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Lab No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Patient</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;display:none">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:130px;text-align:left;">Investigation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;display:none">Barcode</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;">SampleCollection Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;text-align:left;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:85px;text-align:left;">SampleReceive Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;text-align:left;">Time</th>
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;">FilmUpload Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;text-align:left;">Time</th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="width:65px;text-align:left;">Approved Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:25px;text-align:left;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;"><input type="checkbox" id="chkheader"  onclick="checkall()"/></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;display:none;">Test ID</th>
            
	
	       

</tr>
<#  var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
<tr id="<#=j+1#>" style="background-color:<#=objRow.rowcolor#>;">
<td class="GridViewLabItemStyle"><#=j+1#></td> 
<td id="LedgerTransactionNo" class="GridViewLabItemStyle" style="width:50px;"><#=objRow.LedgerTransactionNo#></td>
<td class="GridViewLabItemStyle" style="width:90px;"><#=objRow.PName#></td>
<td class="GridViewLabItemStyle" style="width:40px;display:none"><#=objRow.AgeGender#></td>     
<td class="GridViewLabItemStyle" style="width:130px;"><#=objRow.Investigation#></td>
<td class="GridViewLabItemStyle" style="width:40px;display:none"><#=objRow.BarcodeNo#></td>
       <td id="Td2" class="GridViewLabItemStyle" style="width:80px;"><input id="txtPatientOutDate<#=j+1#>" type="text" value="<#=objRow.SampleCollectionDate#>" style="width:100px;" disabled="disabled" class="datepic"  />
   </td>    
<td id="Td3"class="GridViewLabItemStyle" style="width:30px;"><input id="txtPatientOutTime<#=j+1#>" type="text" value="<#=objRow.SampleCollectionDateTime#>" style="width:100px;"  disabled="disabled" class="timepicker" />
     <td id="Td6" class="GridViewLabItemStyle" style="width:80px;"><input id="txtDate<#=j+1#>" type="text" value="<#=objRow.SampleReceiveDate#>" style="width:100px;" disabled="disabled" class="datepic"  />
   </td>
<td id="Td7"class="GridViewLabItemStyle" style="width:30px;"><input id="txtTime<#=j+1#>" type="text" value="<#=objRow.SampleReceiveDateTime#>" style="width:100px;"  disabled="disabled" class="timepicker" />
 </td> 
 
 </td>        
   <%-- <td id="Td1" class="GridViewLabItemStyle" style="width:80px;"><input id="txtFilmUploadDate<#=j+1#>" type="text" value="<#=objRow.FilmUploadDate#>" style="width:100px;" disabled="disabled" class="datepic"  />
   </td>--%>
<%--<td id="Td8"class="GridViewLabItemStyle" style="width:30px;"><input id="txtFilmUploadTime<#=j+1#>" type="text" value="<#=objRow.FilmUploadTime#>" style="width:100px;"  disabled="disabled" class="timepicker" />
 </td>--%> 
      <td id="Td4" class="GridViewLabItemStyle" style="width:65px;"><input id="txtApproveddate<#=j+1#>" type="text" value="<#=objRow.ApprovedDate#>" style="width:100px;" disabled="disabled" class="datepic"  />
   </td>
<td id="Td5"class="GridViewLabItemStyle" style="width:25px;"><input id="txtApprovedTime<#=j+1#>" type="text" value="<#=objRow.ApprovedTime#>" style="width:100px;"  disabled="disabled" class="timepicker" />
 </td>
    <td id="chkbox"class="GridViewLabItemStyle"><input id="chk" type="checkbox" onclick="SetEnableDisable(this)" /></td>
    <td id="TestId"  class="GridViewLabItemStyle" style="display:none;"><#=objRow.Test_ID#></td>
</tr> 
<#}#> 
        </table>
          
          </script>   
    <script type="text/javascript">
        function setDate(contid) {
            $(contid).datepicker({ dateFormat: 'dd-MM-yy' });
        }
        function GetData() {
            $('#<%=txtLabNo.ClientID%>').attr("disabled", true);
            if ($('#<%=txtLabNo.ClientID%>').val() == '') {
                $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
                alert("Please enter Lab No!!");
                return;
            }
            $.ajax({

                url: "ChangeDeliveryStatus.aspx/GetData",
                data: '{ LabNo: "' + $('#<%=txtLabNo.ClientID%>').val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //JSON.parse(response);
                    PatientData = JSON.parse(result.d);
                    //PatientData = eval('[' + result.d + ']');
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);

                    //$('.timepicker').timepicker({
                    //    timeFormat: 'h:i a',
                    //    interval: 60,
                    //    minTime: '10',
                    //    maxTime: '6:00pm',
                    //    defaultTime: '11',
                    //    startTime: '10:00',
                    //    dynamic: false,
                    //    dropdown: true,
                    //    scrollbar: true
                    //});

                    $('.timepicker').timepicker({
                        //HH:mm:ss p
                        timeFormat: 'h:i:s A',//07:06:54 PM
                        interval: 5,
                        minTime: '12:00am',
                        maxTime: '23:55pm',
                        //defaultTime: '11',
                        startTime: '00:00',
                        dynamic: false,
                        dropdown: true,
                        scrollbar: true
                    });
                    var rowID = 1;
                    $('#tb_grdLabSearch tr').not(':first').each(function () {
                        $(this).find('#txtDate' + rowID).datepicker({ dateFormat: 'dd-MM-yy' });
                        $(this).find('#txtPatientOutDate' + rowID).datepicker({ dateFormat: 'dd-MM-yy' });
                        $(this).find('#txtFilmUploadDate' + rowID).datepicker({ dateFormat: 'dd-MM-yy' });
                        $(this).find('#txtApproveddate' + rowID).datepicker({ dateFormat: 'dd-MM-yy' });
                        rowID += 1;
                    });

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        </script>

     

    <script language="javascript" type="text/javascript">
        function SaveRecord() {
            //$.blockUI();
            var Data = "";
            var idd = 1;
            $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {
                if ($(this).attr('id') != "chkheader") {
                    idd = $(this).parents("tr").attr('id');
                    Data += $(this).closest("tr").find("#LedgerTransactionNo").text() + '|' + $(this).closest("tr").find("#TestId").text() + '|' + $(this).closest("tr").find("#txtDate" + idd + "").val() + '|' + $(this).closest("tr").find("#txtTime" + idd + "").val() + '|' + $(this).closest("tr").find("#txtPatientOutDate" + idd + "").val() + '|' + $(this).closest("tr").find("#txtPatientOutTime" + idd + "").val() +'|'+ $(this).closest("tr").find("#txtApproveddate" + idd + "").val() + '|' + $(this).closest("tr").find("#txtApprovedTime" + idd + "").val()+ '#';

                }

            });

            if (Data == "") {
                //$.unblockUI();
                alert('Kindly Select the Data!!!');
                return;
            }
            $.ajax({

                url: "ChangeDeliveryStatus.aspx/SaveRecord",
                data: '{Data: "' + Data + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert("Record Saved Successfully");
                        clearForm();
                    }
                    else {
                        alert("Record Not Saved");
                    }
                    //$.unblockUI();

                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    alert("Error has occured Record Not saved ");

                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }

        function clearForm() {
            $("#btnUpdate").attr('disabled', false);
            $('#div_InvestigationItems').html('');
            $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
            $('#<%=txtLabNo.ClientID%>').val('');
        }
    </script>
 
</asp:Content>

