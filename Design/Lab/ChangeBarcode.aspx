<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="ChangeBarcode.aspx.cs" Inherits="Design_Lab_ChangeBarcode" MasterPageFile="~/Design/DefaultHome.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
  <div id="Pbody_box_inventory">
          <div class="POuter_Box_Inventory">
<div class="row" style="text-align:center; "> 
    <div class="col-md-24">
<b>Change Barcode</b>

   </div>  
</div>
</div>
      <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">

                <div class="col-md-24">
                    <strong>Visit No:  &nbsp;&nbsp; </strong>  &nbsp;<asp:TextBox ID="txtLabNo" MaxLength="15" Width="200px" data-title="Enter Visit No" class="requiredField"  runat="server" /> 
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
                   <div class="col-md-24">
                        <input type="button" id="btnUpdate" value="Update" onclick="UpdateRecord()" tabindex="9" class="savebutton" style="display:none" />
                     <input type="button" id="btncancel" value="Cancel" onclick="clearForm()" style="display:none" class="resetbutton" />
                   </div>
                  
                   </div>
                 </div>
   
   
  </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Lab No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">PName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Investigation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Barcode</th>
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
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.LedgerTransactionNo#></td>
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.PName#></td>
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.AgeGender#></td>     
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.Investigation#></td>
<td class="GridViewLabItemStyle" style="width:400px;">
  <span id="lbl_TestID_<#=j+1#>" style="width:400px;display:none;"><#=objRow.Test_ID#></span>
    <span id="lbl_OLDBarcodeNo_<#=j+1#>" style="width:400px;display:none;"><#=objRow.BarcodeNo#></span>
     <#  if(objRow.Result_Flag != "1"  || objRow.ReportType == "5") { #>
    <input id="txt_BarcodeNo_<#=j+1#>" type="text" value="<#=objRow.BarcodeNo#>" style="width:400px" maxlength="20" />
     <#} else {#>
    <span id="lbl_BarcodeNo_<#=j+1#>" style="width:400px;"><#=objRow.BarcodeNo#></span>
     <#}#>
</td>
<td class="GridViewLabItemStyle" style="width:400px;">
    <#  if(objRow.Result_Flag != "1" || objRow.ReportType == "5") { #><input id="chkStatus" type="checkbox"/> 
    <#}#></td>
</tr> 
<#}#> 
        </table>
          
          </script>   
    <script type="text/javascript">
        function GetData() {
            $('#<%=txtLabNo.ClientID%>').attr("disabled", true);
            var labno = $('#<%=txtLabNo.ClientID%>').val();
            if (labno == "") {
                toast("Error", "Please enter visit no..!", "");                        
                return;
            }

            serverCall('ChangeBarcode.aspx/GetData', { LabNo: labno }, function (response) {

                PatientData = JSON.parse(response);
                if (PatientData.length != 0) {
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);
                    $("#btnUpdate,#btncancel").show();
                }
                else {
                    $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
                    toast("Error", "Record Not Found..!", "");
                }

                $("#btnSearch").attr('disabled', false).val("Search");               
                $modelUnBlockUI(function () { });
            });
        }

        function getupdatedata() {
            var objplo = [];
            $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {
                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    var mydata = new Object();
                    mydata.LabNo = $('#<%=txtLabNo.ClientID%>').val();
                    mydata.TestID = $rowid.find("#lbl_TestID_" + id).html();
                    mydata.BarcodeNo = $rowid.find("#txt_BarcodeNo_" + id).val();
                    if ($rowid.find("#txt_BarcodeNo_" + id).val() == "") {
                        toast("Error", "Barcode should not be blank..!", "");                      
                        return;
                    }
                    mydata.OldBarcodeNo = $rowid.find("#lbl_OLDBarcodeNo_" + id).html();
                    objplo.push(mydata);                  
                }

            });
            return objplo;
        }

        function UpdateRecord() {
            $("#btnUpdate").attr('disabled', true);
            var Itemdata = getupdatedata();
        
            if (Itemdata == "") {
                toast("Error", "Please select the Item", "");                
                $("#btnUpdate").attr('disabled', false);
                return;
            }
            if (confirm("Do You Want To Change Barcode ") == false) {
                $("#btnUpdate").attr('disabled', false);
                return;
            }
            serverCall('ChangeBarcode.aspx/UpdateRecord', { savedata: Itemdata }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {                                     
                    toast("Success", "Barcode Changed Successfully", "");                                      
                }
                else {                  
                    toast("Error", $responseData.ErrorMsg, "");
                }               
                GetData();
                $("#btnUpdate").attr('disabled', false);
                $modelUnBlockUI(function () { });
            });           
        }
        function clearForm() {
            $("#btnUpdate").attr('disabled', false);
            $('#div_InvestigationItems').html('');
            $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
            $('#<%=txtLabNo.ClientID%>').val('');
            $("#btnUpdate,#btncancel").hide();
        }       
    </script>
</asp:Content>

