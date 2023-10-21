<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="RoleMaster.aspx.cs" Inherits="Design_Master_RoleMaster" Title="Untitled Page" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

       <script type="text/javascript">
   function txtRateValue1(id)
   {
  
       if (id.value >= 100) {
           toast("Error", 'Max Discount Should be 100 or Less Than 100');
           id.value = 100;
       }
   }
 
    </script>
   
   
   <script type="text/javascript">
 
       function Search() {
           serverCall('RoleMaster.aspx/GetRole', { RoleID: $('#<%=ddlRole.ClientID%>').val() }, function (response) {
               PatientData = JSON.parse(response);
               if (PatientData.length != 0) {
                   $("#btnSave").show();
               }
               else
                   $("#btnSave").hide();

               var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
               $('#div_InvestigationItems').html(output);
               $("#tb_grdLabSearch :text").hide();
               $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
           });
       }
      
   </script>
   <script type="text/javascript">
   $(document).ready(function(){
    $("#tb_grdLabSearch :text").hide();
   });
   
   function ckhall() {
       if ($("#chkheader").prop('checked')) {
           $("#tb_grdLabSearch :checkbox").attr('checked', 'checked');
           $("#tb_grdLabSearch :text").css("width", "100px").css("display", "");

           $("#tb_grdLabSearch").find("#lblMaxDiscount,#lblEditInfo,#lblEditPriscription,#lblSettlement,#lblDiscAfterBill,#lblChangePanel,#lblChangePayMode,#lblReceiptCancel,#lblLabRefund").attr("style", "display:none");
       }
       else {
           $("#tb_grdLabSearch :checkbox").attr('checked', false);
           $("#tb_grdLabSearch :text").hide();
           $("#tb_grdLabSearch").find("#lblMaxDiscount,#lblEditInfo,#lblEditPriscription,#lblSettlement,#lblDiscAfterBill,#lblChangePanel,#lblChangePayMode,#lblReceiptCancel,#lblLabRefund").attr("style", "display:block");
       }

   }
   
   function alterRate(ckhid) {

       if ($("#chk_Itemcode" + ckhid).prop('checked')) {
           $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").css("width", "100px").css("display", "");
           $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblMaxDiscount,#lblEditInfo,#lblEditPriscription,#lblSettlement,#lblDiscAfterBill,#lblChangePanel,#lblChangePayMode,#lblReceiptCancel,#lblLabRefund").attr("style", "display:none");
       }
       else {
           $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").hide();
           $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblMaxDiscount,#lblEditInfo,#lblEditPriscription,#lblSettlement,#lblDiscAfterBill,#lblChangePanel,#lblChangePayMode,#lblReceiptCancel,#lblLabRefund").attr("style", "display:block");
       }

       if ($("#chkheader").attr('checked') == true && $("#chk_Itemcode" + ckhid).attr('checked') == false) {
           $("#chkheader").attr('checked', '');
       }


   }
       function save() {
           $("#btnSave").attr('disabled', true);

           var chkduemt = 0
           $("#tb_grdLabSearch tr").each(function () {
               if ($(this).closest("tr").prop("id") != "Header") {
                   if ($(this).closest("tr").find("#chk_DueAmtReport").is(':checked')) {
                       chkduemt = 1;
                   }
                   else {
                       chkduemt = 0
                   }
               }
           });
           //alert(chkduemt);
           var Itemdata = "";
           $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {

               var id = $(this).closest("tr").attr("id");
               var $rowid = $(this).closest("tr");
               if (id != "Header")                   
                   //   Itemdata +=$rowid.find("td:eq(" + 8 + ") ").attr("id")+'|'+$rowid.find("td:eq(" + 8 + ") ").html()+'|'+$rowid.find("#txt_MaxDiscount"+id).val()+'|'+$rowid.find("#txt_EditInfo"+id).val()+'|'+$rowid.find("#txt_EditPriscription"+id).val()+'|'+$rowid.find("#txt_Settlement"+id).val()+'|'+$rowid.find("#txt_DiscAfterBill"+id).val()+'|'+$rowid.find("#txt_ChangePanel"+id).val()+'|'+$rowid.find("#txt_ChangePayMode"+id).val()+'|'+$rowid.find("#txt_ReceiptCancel"+id).val()+"#";
                   Itemdata += $rowid.find("#txt_MaxDiscount" + id).val() + '|' + $rowid.find("#txt_EditInfo" + id).val() + '|' + $rowid.find("#txt_EditPriscription" + id).val() + '|' + $rowid.find("#txt_Settlement" + id).val() + '|' + $rowid.find("#txt_DiscAfterBill" + id).val() + '|' + $rowid.find("#txt_ChangePanel" + id).val() + '|' + $rowid.find("#txt_ChangePayMode" + id).val() + '|' + $rowid.find("#txt_ReceiptCancel" + id).val() + '|' + $rowid.find("#txt_LabRefund" + id).val() + '|' + chkduemt + "#";
           });
           if (Itemdata == "") {
               alert("Please select an Role");
               $("#btnSave").attr('disabled', false);
               return;
           }
           serverCall('RoleMaster.aspx/SaveRole', { RoleID: $("#<%=ddlRole.ClientID %>").val(), ItemData: Itemdata }, function (result) {
               if (result == "1") {
                   $('select option:nth-child(1)').attr('selected', 'selected')
                   $("#tb_grdLabSearch tr").remove();
                  
                   toast("Success", "Record Saved Successfully", "");
                   Search();
               }
               else {
                   toast("Error", "Record Not Saved", "");
                 
               }
               $("#btnSave").attr('disabled', false);
           });
       }
  </script>
   <script type="text/javascript"> 

       //$("#txt_MaxDiscount").on('input', function () {
       //    if ($(this).val().length >= 100) {
       //        alert('you have reached a limit of 100');
       //    }
       //});
       


       $(document).ready(function () {
           $("#txtTestname").keyup(function () {
               var val = $(this).val();
               var len = $(this).val().length;
               $("#chkheader").show();

               $("#tb_grdLabSearch tr").hide();
               $("#tb_grdLabSearch tr:first").show();


               $("#tb_grdLabSearch tr").find("td:eq(" + 8 + ") ").filter(function () {
                   if ($(this).text().toLowerCase().match(val.toLowerCase()) || $(this).parent('tr').find(':checkbox').attr('checked'))
                       return $(this);
               }).parent('tr').show();
           });
       });
    </script>
   <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <div class="content">
    <div style="text-align:center;">
    <b>Role Master</b></div>
     <div style="text-align:center;">
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;</div>
   </div>
   </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> 
        Search criteria</div>
                  <div class="POuter_Box_Inventory">
                      <div class="row">
                          <div class="col-md-3"><label class="pull-right">Role:</label></div>
                          <div class="col-md-4">
                               <asp:DropDownList ID="ddlRole" CssClass="ItDoseDropdownbox" onchange="Search()" runat="server"> </asp:DropDownList>
                          </div>
                           <div class="col-md-8"> * All Value Should Enter in Minute Except Max Discount.</div>
                      </div> 
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center"  >
        <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="ItDoseButton" style="width:60px; display:none;"   />
        </div>
       <div class="POuter_Box_Inventory"> 
        <div id="div_InvestigationItems"  style="max-height:650px;overflow:scroll; "></div>
        </div>
        
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center"  >
        <input id="btnSave" type="button" value="Save"  onclick="save();" class="ItDoseButton" style="width:60px; display:none;"   />
        </div>
        
        
      
   </div>
   
   <script id="tb_InvestigationItems" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse; " >
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Print Due report(Cash Panel)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Role Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Max Discount(%)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Edit Info</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Edit Priscription</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Settlement</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">DiscAfterBill</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Change Panel</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Change PayMode</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Receipt Cancel</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Lab Refund</th>    
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> <input id="chkheader" type="checkbox"  onclick='ckhall();' /></th>
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=j+1#>" 
                                         style="background-color:<#=objRow.CategoryName#>;">
<td class="GridViewLabItemStyle"><#=j+1#></td>
                         
<td class="GridViewLabItemStyle">

                          <#if(objRow.PrintDueReport=="1"){#>
                            <input type="checkbox" id="chk_DueAmtReport" checked="checked" />
                            <#}else{#>
                              <input type="checkbox" id="chk_DueAmtReport" />
                            <#}#>
     
</td>
<td id="<#=objRow.RoleID#>"  class="GridViewLabItemStyle"><#=objRow.RoleName#></td>
<td class="GridViewLabItemStyle" ><input id="txt_MaxDiscount<#=j+1#>" size="100" maxlength="100" type="text" tabindex="-1" value="<#=objRow.MaxDiscount#>" style="width:20px;" onkeyup="txtRateValue1(this);" onblur="txtRateValue(this);" /><span id="lblMaxDiscount" ><#=objRow.MaxDiscount#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_EditInfo<#=j+1#>"  maxlength="15" type="text" tabindex="-1" value="<#=objRow.EditInfo#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);" /><span id="lblEditInfo" ><#=objRow.EditInfo#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_EditPriscription<#=j+1#>" maxlength="15" type="text" value="<#=objRow.EditPriscription#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblEditPriscription" Style="width:20px;"><#=objRow.EditPriscription#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_Settlement<#=j+1#>"  maxlength="15" type="text" tabindex="-1" value="<#=objRow.Settlement#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);" /><span id="lblSettlement" ><#=objRow.Settlement#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_DiscAfterBill<#=j+1#>" maxlength="15" type="text" tabindex="-1" value="<#=objRow.DiscAfterBill#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);" /><span id="lblDiscAfterBill" ><#=objRow.DiscAfterBill#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_ChangePanel<#=j+1#>" maxlength="15" type="text" tabindex="-1" value="<#=objRow.ChangePanel#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblChangePanel" Style="width:20px;"><#=objRow.ChangePanel#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_ChangePayMode<#=j+1#>" maxlength="15" type="text" tabindex="-1" value="<#=objRow.ChangePayMode#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblChangePayMode" Style="width:20px;"><#=objRow.ChangePayMode#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_ReceiptCancel<#=j+1#>" maxlength="15" type="text" tabindex="-1" value="<#=objRow.ReceiptCancel#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblReceiptCancel" Style="width:20px;"><#=objRow.ReceiptCancel#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_LabRefund<#=j+1#>" maxlength="15" type="text" tabindex="-1" value="<#=objRow.LabRefund#>" style="width:20px;" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblLabRefund" Style="width:20px;"><#=objRow.LabRefund#></span></td>
<td class="GridViewLabItemStyle"  ><input id="chk_Itemcode<#=j+1#>" type="checkbox"  tabindex="-1" onclick="alterRate('<#=j+1#>');"  /></td>


</tr>

            <#}#>

     </table>    
    </script>
</asp:Content>

