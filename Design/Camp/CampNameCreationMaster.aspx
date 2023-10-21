<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CampNameCreationMaster.aspx.cs" Inherits="Design_Camp_CampNameCreationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" />
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sc" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/tableHeadFixer.js" />
                <asp:ScriptReference Path="~/Scripts/jquery-ui.js" />
            </Scripts>
        </Ajax:ScriptManager>

        <div id="Pbody_box_inventory" style="margin-top: 0px">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Camp Name Creation Master</b>
                <br />

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                     <div class="col-md-2"></div>
                    <div class="col-md-2">
                        <label class="pull-left">Camp Name   </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-5" style="text-align: left">
                        <asp:TextBox ID="txtCampName" runat="server" MaxLength="50" AutoCompleteType="Disabled" CssClass="requiredField"></asp:TextBox>
                        <span id="spnCampID" style="display:none"></span>
                    </div>
                    <div class="col-md-2"></div>
                     <div class="col-md-2 clStatus" style="display:none">
                        <label class="pull-left">Status   </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-5 clStatus" style="text-align: left;display:none">
                        <input type="radio" name="rblStatus" value="1" title="Active" class="rblStatus" />Active
                        <input type="radio" name="rblStatus" value="0" title="De-Active" class="rblStatus" />De-Active
                       
                        </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" class="searchbutton" onclick="$saveCamp()" id="btnSave" value="Save" title="Click to Save"  />
              
                <input type="button" class="searchbutton" onclick="$updateCamp()" id="btnUpdate" value="Update" title="Click to Update" style="display: none" />
                  <input type="button" class="searchbutton" onclick="$cancelCamp()" id="btnCancel" value="Cancel" title="Click to Cancel"  />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">

                    <div class="CampDetail" style="margin-top: 5px; max-height: 360px; overflow: scroll; width: 100%;">
                        <table id="tb_CampList" style="width: 98%; border-collapse: collapse; display: none">
                            <thead>
                                <tr id="CampHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">#</td>

                                    <td class="GridViewHeaderStyle" style="width: 240px; text-align: center">Camp Name</td>
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">IsActive</td>
                                    <td class="GridViewHeaderStyle" style="width: 240px; text-align: center">Created By</td>
                                    <td class="GridViewHeaderStyle" style="width: 140px; text-align: center">Created Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: center;">Select</td>


                                </tr>
                            </thead>
                        </table>
                    </div>
                 </div>
                </div>
        </div>
         <script type="text/javascript">
             $cancelCamp = function () {
                 jQuery('#btnSave').show();
                 jQuery('#btnUpdate,.clStatus').hide();
                 jQuery('#txtCampName').val('');
                 jQuery('#spnCampID').text('');
               
             }
             jQuery(function () {
                 $bindCampDetail();
             });
                 $bindCampDetail=function() {
                     PageMethods.CampMaster(onSuccess, Onfailure);
                 }
                 Onfailure = function () {

                 }
                 onSuccess = function (result) {
                     var CampData = jQuery.parseJSON(result);
                     if (CampData != null) {
                         jQuery("#tb_CampList tr:not(#CampHeader)").remove();
                         for (var i = 0; i < CampData.length; i++) {
                             var appendText = [];
                             appendText.push("<tr id='"); appendText.push(CampData[i].ID); appendText.push("' class='GridViewItemStyle' >");
                             appendText.push('<td id="tdSNo">'); appendText.push(i+1); appendText.push('</td>');
                             appendText.push('<td id="tdCampName" style="text-align:left">'); appendText.push(CampData[i].CampName); appendText.push('</td>');
                             appendText.push('<td id="tdIsActive" style="text-align:left">'); appendText.push(CampData[i].IsActive); appendText.push('</td>');
                             appendText.push('<td id="tdCreatedBy" style="text-align:left">'); appendText.push(CampData[i].CreatedBy); appendText.push('</td>');
                             appendText.push('<td id="tdCreatedDate" style="text-align:left">'); appendText.push(CampData[i].CreatedDate); appendText.push('</td>');
                             appendText.push('<td id="tdID" style=display:none>'); appendText.push(CampData[i].ID); appendText.push('</td>');
                             appendText.push('<td id="tdIsActiveStatus" style=display:none>'); appendText.push(CampData[i].IsActiveStatus); appendText.push('</td>');
                             
                             appendText.push('<td id="tdSelect">'); appendText.push('<img src="../../App_Images/view.GIF" style="cursor:pointer" onclick="$getCampDetail(this)"  alt=""/>'); appendText.push('</td>');
                             appendText.push("</tr>");
                             jQuery('#tb_CampList').append(appendText.join(""));
                             jQuery('#tb_CampList').css('display', 'block');
                          
                         }
                     }

                 }
                 $getCampDetail = function (rowID) {
                     jQuery.trim(jQuery('#txtCampName').val(jQuery(rowID).closest('tr').find("#tdCampName").text()));
                     jQuery.trim(jQuery('#spnCampID').text(jQuery(rowID).closest('tr').find("#tdID").text()));
                     jQuery("input[name='rblStatus'][value='" + jQuery(rowID).closest('tr').find("#tdIsActiveStatus").text() + "']").prop('checked', true);
                     jQuery('#btnSave').hide();
                     jQuery('#btnUpdate').show();
                     jQuery(".clStatus").show();
                 }
                 $saveCamp = function () {
                     if (jQuery.trim(jQuery('#txtCampName').val()) == "") {
                         toast('Error', 'Please Enter Camp Name');
                         jQuery('#txtCampName').focus();
                         return false;

                     }
                     serverCall('CampNameCreationMaster.aspx/SaveCamp', { CampName: jQuery.trim(jQuery('#txtCampName').val()) }, function (response) {
                         var $responseData = JSON.parse(response);
                         if ($responseData.status) {
                             toast('Success', $responseData.response, '');
                             $cancelCamp();
                             $bindCampDetail();
                         }
                         else {
                             toast('Error', $responseData.response,'');
                         }
                     });
                 }
                 $updateCamp = function () {
                     if (jQuery.trim(jQuery('#txtCampName').val()) == "") {
                         toast('Error', 'Please Enter Camp Name');
                         jQuery('#txtCampName').focus();
                         return false;

                     }
                    
                     serverCall('CampNameCreationMaster.aspx/UpdateCamp', { CampName: jQuery.trim(jQuery('#txtCampName').val()), CampID: jQuery.trim(jQuery('#spnCampID').text()), Status: jQuery("#form1 input[type='radio']:checked").val() }, function (response) {
                         var $responseData = JSON.parse(response);
                         if ($responseData.status) {
                             toast('Success', $responseData.response, '');
                             $cancelCamp();
                             $bindCampDetail();
                         }
                         else {
                             toast('Error', $responseData.response, '');
                         }
                     });
                 }
             </script>
    </form>
</body>
</html>
