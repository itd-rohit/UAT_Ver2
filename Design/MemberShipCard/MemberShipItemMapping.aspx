<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MemberShipItemMapping.aspx.cs" Inherits="Design_MemberShipCard_MemberShipItemMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style=" text-align: center;">
            <b>Set Membership Item Mapping </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        
        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-4 ">
                     <label class="pull-left">MemebrShip Card  </label>
                    <b class="pull-right">:</b>
                      </div>
                 <div class="col-md-6 ">
                      <asp:DropDownList ID="ddlMembershipCard" runat="server" class="ddlMembershipCard chosen-select"  onchange="bindItem()">                                    
                                </asp:DropDownList>
                       </div>
                  </div>
             <div class="row">
                <div class="col-md-4 ">
                     <label class="pull-left">Department  </label>
                    <b class="pull-right">:</b>
                      </div>
                 <div class="col-md-6 ">
                     <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment chosen-select" onchange="bindItem()"></asp:DropDownList>
                     </div>
              </div>
        </div>
        <div class="POuter_Box_Inventory" >          
                                     <div id="ItemOutput" style="max-height: 410px; overflow-x: auto; text-align: center">            
                  </div></div>
        <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="divSave" >
            <input type="button" id="btnSave" value="Save" class="savebutton" onclick="saveMapping()"/>&nbsp;
            <input type="button" value="Cancel"  class="resetbutton" />
            </div>
    
         </div>
    <script type="text/javascript">
       
        function getType() {
            serverCall('MemberShipItemMapping.aspx/geType', {  }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                  var  MembershipData = jQuery.parseJSON($responseData.response);
                  if (MembershipData != null) {
                        jQuery('#ddlMembershipCard').append(jQuery("<option></option>").val("0").html('Select'));
                        for (i = 0; i < MembershipData.length; i++) {
                            jQuery('#ddlMembershipCard').append(jQuery("<option></option>").val(MembershipData[i].ID).html(MembershipData[i].Name));
                        }
                        jQuery('#ddlMembershipCard').trigger('chosen:updated');

                    }
                }
                else {

                }
            });
           

        }

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
            getType();
        });
        
    </script>

     <script type="text/javascript">
         function hideItem() {
             jQuery("#ItemOutput").html('');
             jQuery("#ItemOutput,#divSave").hide();
         }
         function bindItem() {
             if (jQuery("#ddlMembershipCard").val() == 0) {
                 toast("Info", "Please Select MemebrShip Card", "");
                 jQuery("#ddlMembershipCard").focus();
                 hideItem();
                 return;                                                              
             }             
             if (jQuery("#ddlDepartment").val() == 0) {
                 toast("Info", "Please Select Department", "");
                 jQuery("#ddlDepartment").focus();
                 hideItem();
                 return;
             }
             if (jQuery("#ddlDepartment").val() != 0) {
                 jQuery("#lblMsg").text('');
                 $modelBlockUI();                  
                 
                 serverCall('MemberShipItemMapping.aspx/getItem', { SubCategoryID: jQuery("#ddlDepartment").val(), MemberShipID: jQuery("#ddlMembershipCard").val() }, function (response) {
                     var $responseData = JSON.parse(response);
                     if ($responseData.status) {
                         ItemData = jQuery.parseJSON($responseData.response);                           
                         if (ItemData != null) {
                             jQuery("#ItemOutput").html(jQuery("#tb_ItemDetail").parseTemplate(ItemData));
                             jQuery("#ItemOutput,#divSave").show();
                             jQuery("#tb_ItemSearch").tableHeadFixer({
                             });
                         }
                         else {
                             hideItem();
                         }
                     }
                 });                                       
             }
             else {
                 hideItem();
             }            
         }
             function CheckPer(Per, filterType) {
                 if (jQuery(Per).val().charAt(0) == "0") {
                     jQuery(Per).val(Number(jQuery(Per).val()));
                 }
                 if (jQuery(Per).val().match(/[^0-9]/g)) {
                     jQuery(Per).val(jQuery(Per).val().replace(/[^0-9]/g, ''));
                     jQuery(Per).val(Number(jQuery(Per).val()));
                     return;
                 }
                 if (jQuery(Per).val() > 100) {
                     toast("Info", "Please Enter Valid Percentage","");
                     jQuery(Per).val(0);
                     return;
                 }             
                 if (jQuery(Per).val().indexOf('.') != -1) {
                     var DigitsAfterDecimal = 2;
                     var valIndex = jQuery(Per).val().indexOf(".");
                     if (valIndex > "0") {
                         if (jQuery(Per).val().length - (jQuery(Per).val().indexOf(".") + 1) > DigitsAfterDecimal) {
                             toast("Info", "Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal","");
                             jQuery(Per).val(jQuery(Per).val().substring(0, (jQuery(Per).val().length - 1)));
                             return false;
                         }
                     }
                 }
                 //if (jQuery(Per).val() == 0) {
                 //    jQuery(Per).val(0);
                 //    return;
                 //}
             }
             function checkForSecondDecimal(sender, e) {
                 formatBox = document.getElementById(sender.id);
                 strLen = sender.value.length;
                 strVal = sender.value;
                 hasDec = false;
                 e = (e) ? e : (window.event) ? event : null;
                 if (e) {
                     var charCode = (e.charCode) ? e.charCode :
                                 ((e.keyCode) ? e.keyCode :
                                 ((e.which) ? e.which : 0));
                     if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                         for (var i = 0; i < strLen; i++) {
                             hasDec = (strVal.charAt(i) == '.');
                             if (hasDec)
                                 return false;
                         }
                     }
                 }
                 return true;
             }
             function selfNoOfFree(rowID) {
                 if ($(rowID).closest('tr').find("#chkSelfFree").is(':checked')) {
                     $(rowID).closest('tr').find("#txtSelfNoOfFree").show();
                 }
                 else {
                     $(rowID).closest('tr').find("#txtSelfNoOfFree").val('').hide();
                 }
             }
             function deptNoOfFree(rowID) {
                 if ($(rowID).closest('tr').find("#chkDeptFree").is(':checked')) {
                     $(rowID).closest('tr').find("#txtDeptNoOfFree").show();
                 }
                 else {
                     $(rowID).closest('tr').find("#txtDeptNoOfFree").val('').hide();
                 }
             }
             function fillSelfPer(per) {
                 if (jQuery(per).val() > 100) {
                     toast("Info", "Please Enter Valid Percentage", "");
                     jQuery(per).val('');
                     jQuery(".clSelfPer").val('');
                     return;
                 }           
                 jQuery(".clSelfPer").val(jQuery(per).val());
             }
             function fillDeptPer(per) {
                 if (jQuery(per).val() > 100) {
                     toast("Info", "Please Enter Valid Percentage", "");
                     jQuery(per).val('');
                     jQuery(".clDeptPer").val('');
                     return;
                 }
                 jQuery(".clDeptPer").val(jQuery(per).val());
             }
             function chkAllSelf() {           
                 if ($("#chkHeaderSelfDisc").is(':checked')) {
                     $(".clSelfFree").attr('checked', 'checked');
                     $(".clSelfNoOfFree,.clHeaderSelfNoOfFree").show();
                 }
                 else {
                     $(".clSelfFree").prop('checked', false);
                     $(".clSelfNoOfFree,.clHeaderSelfNoOfFree").hide();
                     $(".clSelfNoOfFree,.clHeaderSelfNoOfFree").val('');
                 }
             }
             function chkAllDept() {
                 if ($("#chkHeaderDeptDisc").is(':checked')) {
                     $(".clDeptFree").attr('checked', 'checked');
                     $(".clDeptNoOfFree,.clHeaderDeptNoOfFree").show();
                 }
                 else {                 
                     $(".clDeptFree").prop('checked', false);
                     $(".clDeptNoOfFree,.clHeaderDeptNoOfFree").hide();
                     $(".clDeptNoOfFree,.clHeaderDeptNoOfFree").val('');
                 }
             }
             function fillSelfFree(per) {           
                 jQuery(".clSelfNoOfFree").val(jQuery(per).val());
             }
             function fillDeptFree(per) {
                 jQuery(".clDeptNoOfFree").val(jQuery(per).val());
             }
    </script>
    <script id="tb_ItemDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_ItemSearch"
    style="width:1210px;border-collapse:collapse;text-align:center">
            <thead>
		<tr id="trItemHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Test Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:520px;">Item</th>           
			<th class="GridViewHeaderStyle" scope="col" style="width:180px;">Self Disc.<input id="txtHeaderSelfDisc"  class="ItDoseTextinputNum clHeaderSelfDisc" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)"  style="width:50px;" onkeyup="CheckPer(this,'Item');fillSelfPer(this)" />%</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Dep. Disc.<input id="txtHeaderDeptDisc"   class="ItDoseTextinputNum clHeaderDeptDisc" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)"  style="width:50px;" onkeyup="CheckPer(this,'Item');fillDeptPer(this)" />%</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Self Free Test Count <input id="txtHeaderSelf"  class="ItDoseTextinputNum clHeaderSelfNoOfFree" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)" maxlength="2"  style="width:40px;" onkeyup="CheckPer(this,'Item');fillSelfFree(this)" /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Dep.Free Test Count  <input id="txtHeaderDept"  class="ItDoseTextinputNum clHeaderDeptNoOfFree" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)" maxlength="2"  style="width:40px;" onkeyup="CheckPer(this,'Item');fillDeptFree(this)" /></th>
</tr>
                 </thead>
       <#
             
              var objRow;
        for(var j=0;j<ItemData.length;j++)
        {
        objRow = ItemData[j];
            #>
                    <tr >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="tdTestCode"  class="GridViewLabItemStyle"><#=objRow.TestCode#></td>
<td id="tdTypeName"  class="GridViewLabItemStyle" style="text-align:left"><#=objRow.TypeName#></td>
<td class="GridViewLabItemStyle" id="tdItemID"  style="width:40px;display:none;text-align:left" ><#=objRow.ItemID#></td>
<td class="GridViewLabItemStyle" id="tdSubcategoryID"  style="width:40px;display:none;text-align:left" ><#=objRow.SubcategoryID#></td>
<td class="GridViewLabItemStyle"><input id="txtSelfDiscPer"  class="ItDoseTextinputNum clSelfPer" onlynumber="10" value="<#=objRow.SelfDisc#>"  type="text" onkeypress="return checkForSecondDecimal(this,event)"  style="width:90px;" onkeyup="CheckPer(this,'Item');" />%</td>
<td class="GridViewLabItemStyle"><input id="txtDeptDiscPer"  class="ItDoseTextinputNum clDeptPer" onlynumber="10" value="<#=objRow.DependentDisc#>"  type="text" onkeypress="return checkForSecondDecimal(this,event)"  style="width:90px;" onkeyup="CheckPer(this,'Item');" />%</td>
<td class="GridViewLabItemStyle"> 
      
    <input id="txtSelfNoOfFree" title="No. of Self Free Test"  class="ItDoseTextinputNum clSelfNoOfFree" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)" maxlength="2"   style="width:40px"  onkeyup="CheckPer(this,'Item');"
          <#
    if(objRow.SelfFreeTest=="1"){#>
         value="<#=objRow.SelfFreeTestCount#>" <#}
    else
    {#>
     value=""
    <#}#>  
          /> </td>
<td class="GridViewLabItemStyle">   
    <input id="txtDeptNoOfFree" title="No. of Dependent Free Test"  class="ItDoseTextinputNum clDeptNoOfFree" onlynumber="10"   type="text" onkeypress="return checkForSecondDecimal(this,event)" maxlength="2"  style="width:40px;" onkeyup="CheckPer(this,'Item');"
          <#
    if(objRow.DependentFreeTest=="1"){#>
         value="<#=objRow.DependentFreeTestCount#>" <#}
    else
    {#>
    value=""
    <#}
    #>
          /> </td>


</tr>
            <#}#>
     </table>
    </script>
    <script type="text/javascript">
        function $ItemMapping() {
            var $dataMap = new Array();
            jQuery('#tb_ItemSearch').find('tr:not(#trItemHeader)').each(function () {

                if (jQuery(this).closest("tr").find("#txtSelfDiscPer").val() != "" || jQuery(this).closest("tr").find("#txtDeptDiscPer").val() != ""
                    || jQuery(this).closest("tr").find("#txtSelfNoOfFree").val() != "" || jQuery(this).closest("tr").find("#txtDeptNoOfFree").val() != "") {
                    var $objMap = new Object();
                    $objMap.SubcategoryID = jQuery(this).closest("tr").find("#tdSubcategoryID").text();
                    $objMap.ItemId = jQuery(this).closest("tr").find("#tdItemID").text();
                    $objMap.SelfDisc = jQuery(this).closest("tr").find("#txtSelfDiscPer").val();
                    $objMap.DependentDisc = jQuery(this).closest("tr").find("#txtDeptDiscPer").val();
                    $objMap.SelfFreeTest = jQuery(this).closest("tr").find("#chkSelfFree").is(':checked') ? 1 : 0;

                    if (jQuery(this).closest("tr").find("#txtSelfNoOfFree").val() != "" && jQuery(this).closest("tr").find("#txtSelfNoOfFree").val()!=0) {
                        $objMap.SelfFreeTestCount = jQuery(this).closest("tr").find("#txtSelfNoOfFree").val();
                        $objMap.SelfFreeTest = 1;
                    }
                    else {
                        $objMap.SelfFreeTestCount = 0;
                        $objMap.SelfFreeTest = 0;
                    }
                   
                    if (jQuery(this).closest("tr").find("#txtDeptNoOfFree").val() != "" && jQuery(this).closest("tr").find("#txtDeptNoOfFree").val()!=0) {
                        $objMap.DependentFreeTestCount = jQuery(this).closest("tr").find("#txtDeptNoOfFree").val();
                        $objMap.DependentFreeTest = 1;
                    }
                    else {
                        $objMap.DependentFreeTestCount = 0;
                        $objMap.DependentFreeTest = 0;
                    }
                    $dataMap.push($objMap);
                }
            });
            return $dataMap;
        }
        function saveValidation() {
            var validation = 0;
            jQuery('#tb_ItemSearch').find('tr:not(#trItemHeader)').each(function () {
                if (jQuery(this).closest("tr").find("#chkSelfFree").is(':checked') && (jQuery.trim(jQuery(this).closest("tr").find("#txtSelfNoOfFree").val()) == "" || jQuery.trim(jQuery(this).closest("tr").find("#txtSelfNoOfFree").val()) == 0)) {
                    jQuery(this).closest("tr").find("#txtSelfNoOfFree").focus();
                    toast("Error", "Please Enter No. Of Self Free Test", "");
                    validation = 1;
                    return;
                }
                if (jQuery(this).closest("tr").find("#chkDeptFree").is(':checked') && (jQuery.trim(jQuery(this).closest("tr").find("#txtDeptNoOfFree").val()) == "" || jQuery.trim(jQuery(this).closest("tr").find("#txtDeptNoOfFree").val()) == 0)) {
                    jQuery(this).closest("tr").find("#txtDeptNoOfFree").focus();
                    toast("Error", "Please Enter No. Of Dependent Free Test", "");
                    validation = 1;
                    return;
                }
            });
            return validation;
        }
        $clearForm = function () {

        }
        saveMapping = function () {
            if (saveValidation() == 1)
                return;
            else {
                var $Mappingdata = $ItemMapping();                                    
                jQuery("#btnSave").attr('disabled', true).val('Submitting...');
                serverCall('MemberShipItemMapping.aspx/SaveMapping', { MemberShipItemMapping: $Mappingdata,MembershipCardID: jQuery("#ddlMembershipCard").val() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        jQuery(btnSave).removeAttr('disabled').val('Save');
                        $clearForm();
                        toast("Success", "Record Saved Successfully", "");
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                    $modelUnBlockUI(function () { });
                    jQuery("#btnSave").removeAttr('disabled').val('Save');
                });
            }
        }
    </script>
</asp:Content>

