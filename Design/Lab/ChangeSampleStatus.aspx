<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="ChangeSampleStatus.aspx.cs" Inherits="Design_Lab_ChangeSampleStatus" MasterPageFile="~/Design/DefaultHome.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        
      <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
  
 
  <div id="Pbody_box_inventory" style="width:97%;">
          <div class="POuter_Box_Inventory" style="width:99.6%;">
<div class="content" style="text-align:center; ">   
<b>Change Sample Status</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   
</div>
</div>
      <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4"><strong>Lab No: </strong> </div>
                 <div class="col-md-4"><asp:TextBox ID="txtLabNo" MaxLength="15" runat="server" /></div>
                 <div class="col-md-8"><input type="button" id="btnsearch" onclick="GetData()" value="Search"  class="savebutton" /></div>
                </div>
              </div> 
          <div class="Outer_Box_Inventory" style="width: 99.6%; "  > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
          <div class="POuter_Box_Inventory" style="width:99.6%;">
               <div class="row" style="text-align:center;">
                  <div class="col-md-24"> <input type="button" id="btnUpdate" value="Update" onclick="UpdateRecord()" tabindex="9" class="savebutton" />
                     <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" /></div>
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
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Result Remove</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Sample Status Remove</th>
	
	       

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
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.BarcodeNo#></td>
<td class="GridViewLabItemStyle" style="width:400px;">
    <span id="lbl_TestID_<#=j+1#>" style="width:400px;display:none;"><#=objRow.Test_ID#></span>
    <#  if(objRow.Approved == "0" && objRow.Result_Flag == "1") { #><input id="chkResultStatus" type="checkbox"/> 
    <#}#></td>

<td class="GridViewLabItemStyle" style="width:400px;">
    <#  if(objRow.Result_Flag != "1" ) { #><input id="chkSampleStatus" type="checkbox"/> 
	<%--<#  if( objRow.IsSampleCollected != "N") { #><input id="chkSampleStatus" type="checkbox"/> --%>
    <#}#></td>
</tr> 
<#}#> 
        </table>
          
          </script>   
    <script type="text/javascript">
        function GetData() {
            $('#<%=txtLabNo.ClientID%>').attr("disabled", true);
            $.ajax({

                url: "ChangeSampleStatus.aspx/GetData",
                data: '{ LabNo: "' + $('#<%=txtLabNo.ClientID%>').val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData); 
                    $('#div_InvestigationItems').html(output); 

                },
                error: function (xhr, status) {
                    alert("Error "); 
                }
            });
       }
        function UpdateRecord() {
            $("#btnUpdate").attr('disabled', true);
            var Itemdata = "";
            $("#tb_grdLabSearch tr").find("#chkResultStatus").filter(':checked').each(function () {
                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") { 
                    Itemdata += "0" + '|' + $rowid.find("#lbl_TestID_" + id).html()  + "#";
                }

            });
            $("#tb_grdLabSearch tr").find("#chkSampleStatus").filter(':checked').each(function () {
                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") { 
                    Itemdata += "1" + '|' + $rowid.find("#lbl_TestID_" + id).html() + "#";
                }

            });
            if (Itemdata == "") {
                alert("Please select the Item");
                $("#btnUpdate").attr('disabled', false);
                return;
            }
            $.ajax({

                url: "ChangeSampleStatus.aspx/UpdateRecord",
                data: '{ LabNo: "' + $('#<%=txtLabNo.ClientID%>').val() + '",TestData:"' + Itemdata + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                  //  alert(result.d);
                    if (result.d == "-1") {
                        $("#btnUpdate").attr('disabled', false);
                        alert("Your Session Expired...Please Login Again");
                      //  $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
                        return ;
                    }
                    else if (result.d == "1") {
                        $("#btnUpdate").attr('disabled', false);
                      //  $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
                        alert("Record Saved Successfully");
                        GetData();
                        return;
                    }
                    else if (result.d == "2") { 
                        alert("Duplicate Barcode"); 
                        return;
                    }
                    else {
                        $("#btnUpdate").attr('disabled', false);
                        alert("Please Try Again Later");
                        return;
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function clearForm() {
            $("#btnUpdate").attr('disabled', false);
            $('#div_InvestigationItems').html('');
           // $('#<%=txtLabNo.ClientID%>').attr("disabled", false);
            $('#<%=txtLabNo.ClientID%>').val('');
        }
    </script>
</asp:Content>

