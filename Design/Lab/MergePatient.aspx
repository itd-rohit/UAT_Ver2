<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MergePatient.aspx.cs" Inherits="Design_Lab_MergePatient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">        
    <div id="Pbody_box_inventory">              
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                     <b>Merge Patient<br />
            </b>
          
                </div>
            </div>
           
        </div>
      <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">

                <div class="col-md-24">
                    <strong>Mobile No:  &nbsp;&nbsp; </strong>  &nbsp;<asp:TextBox ID="txtMobileNo" Width="200px" data-title="Enter Mobile No" class="requiredField"  runat="server" /> 
                            <input type="button" style="width:100px" id="btnsearch" onclick="GetData()" value="Search"  class="savebutton" />
                </div>
               
                </div>
              </div> 
         <div class="POuter_Box_Inventory"> 
              <div class="row">
                  <div class="col-md-24">
                      <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
            </div>
                  </div>
              </div>
        </div>
         <div class="POuter_Box_Inventory">
               <div class="row" style="text-align:center;">
                     <div class="col-md-12">
                      <span style="font-weight:bold;display:none" id="mrgto">Merge With Patient::</span> <select id="ddlpatientID" style="width:200px;display:none"></select>
                       </div>
                   <div class="col-md-12">
                        <input type="button" id="btnUpdate" value="Update" onclick="UpdatePatient()" style="display:none" tabindex="9" class="savebutton" />
                     <input type="button" id="btncancel" value="Cancel" onclick="clearForm()" style="display:none" class="resetbutton" />
                   </div>
                  
                   </div>
                 </div>
        </div>
     <script id="tb_InvestigationItems" type="text/html">
          <div class="row">
              <div class="col-md-24">
                  <table id="tb_grdLabSearch" width="100%" style="background-color:cyan">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Lab No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">PatientID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">PName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">MobileNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">PanelName</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">PatientID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Select</th>           

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
<td class="GridViewLabItemStyle" style="width:100px;" id="td_labno_<#=j+1#>"><#=objRow.LedgerTransactionNo#></td>
    <td class="GridViewLabItemStyle" style="width:100px;"><#=objRow.Patient_ID#></td>
<td class="GridViewLabItemStyle" style="width:200px;"><#=objRow.PName#></td>
<td class="GridViewLabItemStyle" style="width:100px;"><#=objRow.AgeGender#></td> 
    <td class="GridViewLabItemStyle" style="width:100px;"><#=objRow.Mobile#></td>     
<td class="GridViewLabItemStyle" style="width:100px;"><#=objRow.RegDate#></td>
<td class="GridViewLabItemStyle" style="width:300px;"><#=objRow.PanelName#></td>
    <td class="GridViewLabItemStyle" style="width:200px;">
        <span id="lbl_OldPatientID_<#=j+1#>"><#=objRow.Patient_ID#></span>
        

    </td>
<td class="GridViewLabItemStyle" style="width:30px;"><input id="chkStatus" type="checkbox"/ onclick="mergePatient()"></td>
  
</tr> 
<#}#> 
        </table>
              </div>
          </div>                  
          </script>
    <script type="text/javascript">
       
         function GetData() {
           
            var mobileno = $('#<%=txtMobileNo.ClientID%>').val();
             $("#tb_grdLabSearch tr").slice(1).remove();
             $('#ddlpatientID').empty();
            serverCall('MergePatient.aspx/GetData', { MobileNo: mobileno }, function (response) {
                PatientData = JSON.parse(response);
                if (PatientData.length != 0) {
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);
                    $('#btnUpdate,#btncancel,#ddlpatientID,#mrgto').show();
                }
                else {                   
                    toast("Error", "Record Not Found..!", "");
                }
                $("#btnSearch").attr('disabled', false).val("Search");
                $modelUnBlockUI(function () { });
            });
        }
        function getUpdatepatient() {
            var objpatient = [];
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).attr('id') != "Header" && $(this).find("#chkStatus").is(':checked')) {
                    var id = $(this).closest("tr").attr("id");
                    var $rowid = $(this).closest("tr");
                    var mydata = new Object();
                    mydata.OldPatientID = $rowid.find("#lbl_OldPatientID_" + id).html();
                    mydata.PatientID = $('#ddlpatientID').val();
                    mydata.LabNo = $rowid.find("#td_labno_" + id).html();
                    objpatient.push(mydata);
                }
            });
            return objpatient;
        }

        function UpdatePatient() {
            $("#btnUpdate").attr('disabled', true);
            var Itemdata = getUpdatepatient();

            if (Itemdata == "") {
                showerrormsg("Please select Patient to merge");
                $("#btnUpdate").attr('disabled', false);
                return;
            }

            serverCall('MergePatient.aspx/UpdatePatient', { savedata: Itemdata }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Patient Merge Successfully", "");
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                GetData();
                $("#btnUpdate").attr('disabled', false);
                $modelUnBlockUI(function () { });
            });
        }
        function mergePatient() {
            $('#ddlpatientID').empty();
            $('#tb_grdLabSearch tr').each(function () {
                if ($(this).attr('id') != "Header" && $(this).find("#chkStatus").is(':checked')) {
                    var id = $(this).closest("tr").attr("id");
                    var $rowid = $(this).closest("tr");
                    var patientID = $rowid.find("#lbl_OldPatientID_" + id).html();
                    $("#ddlpatientID").append($("<option></option>").val(patientID).html(patientID));
                }
            });
        }
       
        function clearForm() {
            $("#btnUpdate").attr('disabled', false);
            $('#div_InvestigationItems').html('');
            $('#<%=txtMobileNo.ClientID%>').attr("disabled", false);
             $('#<%=txtMobileNo.ClientID%>').val('');
            $('#btnUpdate', '#btncancel,#ddlpatientID,#mrgto').hide();
            $('#ddlpatientID').empty();
         }
         </script>
</asp:Content>

