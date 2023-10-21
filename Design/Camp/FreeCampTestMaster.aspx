<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="FreeCampTestMaster.aspx.cs" Inherits="Design_Camp_FreeCampTestMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title></title>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" />
     <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
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
                <asp:ScriptReference Path="~/Scripts/PostReportScript.js"/>
                <asp:ScriptReference Path="~/Scripts/jquery-confirm.min.js" />
            </Scripts>
        </Ajax:ScriptManager>
         <div id="Pbody_box_inventory" style="margin-top: 0px">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <b>Free Camp Test Master
                    </b>
                </div>
                <div class="row" style="display: none">
                    <asp:Label ID="lblCreatedBy" runat="server" Style="display: none" />
                    <asp:Label ID="lblAddedData" runat="server" Style="display: none" />
                </div>
                
            </div>
            <div class="POuter_Box_Inventory" style="text-align: left;">
                <div class="Purchaseheader">
                    Manage Item
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <input id="rblsearchtype_1" onclick="clearItem()" value="1" name="rblSearchType" checked="checked" type="radio" />
                        <b>By Test Name</b><input id="rblsearchtype_0" onclick="clearItem()" value="0" name="rblSearchType" type="radio" />
                        <b>By Test Code</b><input id="rblsearchtype_2" onclick="clearItem()" value="2" name="rblSearchType" type="radio" />
                        <b>InBetween</b>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="ui-widget" style="display: inline-block;">
                            <input type="hidden" id="theHidden" />

                            <input id="txtInvestigation" size="50" tabindex="19" />
                        </div>
                    </div>
                    <div class="col-md-12">
                        <b>Total Test: </b><span id="spnTestCount" style="font-weight: bold;">0</span>
                       
                    </div>
                </div>
                <div class="row">
                    <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: scroll; width: 100%;">
                        <table id="tb_ItemList" style="width: 100%; border-collapse: collapse; display: none">
                            <thead>
                                <tr id="ItemHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">#</td>
                                    <td class="GridViewHeaderStyle" style="width: 90px; text-align: center">Test Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 420px; text-align: center">Test Name</td>                                    
                                    <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Added By</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Added DateTime</td>
                                    <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Last Updated By</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Last Updated DateTime</td>                                  
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" class="searchbutton" onclick="saveTest()" id="btnSave" value="Save" title="Click to Save" disabled="disabled" />
                <input type="button" class="searchbutton" onclick="updateTest()" id="btnUpdate" value="Update" title="Click to Update" style="display: none" />
                &nbsp;&nbsp; 
            <input type="button" class="searchbutton" onclick="getReport()" id="btnExportToExcel" value="Export To Excel" title="Click to ExportToExcel" />
            </div>
        </div>
        <script type="text/javascript">
            var testcount = 0;
            var totalamt = 0;
            var InvList = [];
            function clearItem() {
                jQuery("#txtInvestigation").val('');
            }
            function checkNumeric(e, sender) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            jQuery(function () {
                $("#tb_ItemList").tableHeadFixer({
                });
            });
        </script>
        <script type="text/javascript">
            jQuery("#txtInvestigation")
                  // don't navigate away from the field on tab when selecting an item
                  .bind("keydown", function (event) {
                      if (event.keyCode === $.ui.keyCode.TAB &&
                         jQuery(this).autocomplete("instance").menu.active) {
                          event.preventDefault();
                      }
                      jQuery("#theHidden").val('');
                  })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          serverCall('FreeCampTestMaster.aspx/GetTestList', { SearchType: jQuery('input:radio[name=rblSearchType]:checked').val(), TestName: extractLast1(request.term) },

                              function (responseData) {
                                  var result = $.parseJSON(responseData);
                                  response(result);
                              }, '', 0);
                      },
                      search: function () {
                          // custom minLength
                          var term = extractLast1(this.value);
                          if (term.length < 2) {
                              return false;
                          }
                      },
                      focus: function () {
                          // prevent value inserted on focus
                          return false;
                      },
                      select: function (event, ui) {
                          jQuery("#theHidden").val(ui.item.id);
                          this.value = '';
                          AddItem(ui.item.value, ui.item.type, ui.item.Rate);
                          return false;
                      },
                  });
            function extractLast1(term) {
                return term;
            }
        </script>
        <script type="text/javascript">
            function validateTest() {
                if (jQuery('#tb_ItemList tr:not(#ItemHeader)').length == 0) {
                    toast('Error', 'Please Add Item');
                    return false;
                }               
                return true;
            }
            function saveTest() {
                if (validateTest()) {
                    jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                    var ItemDetail = getItemDetail();
                    serverCall('FreeCampTestMaster.aspx/saveTest', {  ItemDetail: ItemDetail }, function (response) {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            toast("Success", 'Record Save Successfully');
                            clearData();
                            serverCall('FreeCampTestMaster.aspx/getTestDetail', {}, function (response) {
                                onSuccessItem(response);
                            });
                        }
                        else {
                            toast("Error", 'Error');
                            jQuery("#btnSave").removeAttr('disabled').val('Save');
                        }
                    });
                }
            }
            function Onfailure() {
                toast('Error', 'Error');
                jQuery("#btnSave").removeAttr('disabled').val('Save');
            }
            function clearData() {
                InvList = [];
                jQuery("#btnSave").removeAttr('disabled').val('Save');
                //   jQuery('#tb_ItemList').hide();
                jQuery("#tb_ItemList tr:not(#ItemHeader)").remove();
                jQuery('#spnTestCount,#spnTotalAmt').text('0');
                jQuery('input:radio[name="rblSearchType"][value="1"]').prop('checked', true);
                totalamt = 0;
                testcount = 0;
            }
        </script>
        <script type="text/javascript">
            function getItemDetail() {
                var dataItem = new Array();
                var ObjItem = new Object();
                jQuery('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "ItemHeader") {
                        ObjItem.ItemID = jQuery(this).closest("tr").attr("id");
                        ObjItem.IsNew = jQuery(this).closest("tr").find("#tdIsNew").text();
                        ObjItem.IsOld = jQuery(this).closest("tr").find("#tdIsOld").text();
                        dataItem.push(ObjItem);
                        ObjItem = new Object();
                    }
                });
                return dataItem;
            }
        </script>
        <script type="text/javascript">
            function AddItem(ItemID, type, Rate) {
                if (ItemID == '') {
                    toast("Error", "Please Select investigation");
                    return false;
                }
                serverCall('../Common/Services/CommonServices.asmx/GetItemMaster', { ItemID: ItemID, Type: type, Rate: Rate }, function (response) {
                    TestData = $.parseJSON(response);
                    if (TestData.length == 0) {
                        toast('Info', 'No Record Found..!');
                        return;
                    }
                    else {
                        var ItemID = TestData[0].ItemID;
                        if ($.inArray(ItemID, InvList) != -1) {
                            toast('Error', "Item Already in List..!");
                            return;
                        }
                        InvList.push(TestData[0].ItemID);
                        if ($('#spnTestCount').text() != 0)
                            testcount = jQuery('#tb_ItemList tr:not(#ItemHeader)').length;
                        testcount = parseInt(testcount) + 1;
                        $('#spnTestCount').text(testcount);
                        var appendText = [];
                        appendText.push("<tr id='"); appendText.push(TestData[0].ItemID); appendText.push("' class='GridViewItemStyle' style='background-color:lemonchiffon'>");
                        appendText.push('<td class="inv" id='); appendText.push(TestData[0].ItemID); appendText.push(' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>');
                        appendText.push('<td id="tdClientType" style="font-weight:bold;">'); appendText.push(jQuery("#rblEntryType input[type=radio]:checked").next().text()); appendText.push('</td>');
                        appendText.push('<td id="tdTestCode" style="font-weight:bold;">'); appendText.push(TestData[0].testCode); appendText.push('</td>');
                        appendText.push('<td id="tdItemName" style="font-weight:bold;">'); appendText.push(TestData[0].typeName); appendText.push('</td>');
                        appendText.push('<td id="tdIsNew" style="font-weight:bold;display:none">1</td>');
                        appendText.push('<td id="tdIsOld" style="font-weight:bold;display:none">0</td>');
                        
                      
                        appendText.push('<td id="tdAddedBy" style="font-weight:bold;text-align: left">'); appendText.push(jQuery("#lblCreatedBy").text()); appendText.push('</td>');
                        appendText.push('<td id="tdAddedDate" style="font-weight:bold;text-align: center">'); appendText.push(jQuery("#lblAddedData").text()); appendText.push('</td>');
                        appendText.push('<td id="tdLastUpdatedBy" style="font-weight:bold;text-align: center"></td>');
                        appendText.push('<td id="tdLastUpdatedDate" style="font-weight:bold;text-align: center"></td>');
                        appendText.push('<td id="tdFreeCampTestID" style="font-weight:bold;text-align: center;display:none">0</td>');
                        appendText.push("</tr>");
                        jQuery('#tb_ItemList').append(appendText.join(""));
                        jQuery('#tb_ItemList').css('display', 'block');
                        jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                        enableSaveButton();
                    }
                });
            }
            function deleteItemNode(row) {
                var CampTestID = jQuery(row).closest('tr').find("#tdFreeCampTestID").text();
                if (CampTestID != 0) {
                    confirmDelete(CampTestID, jQuery(row).closest('tr').find("#tdItemName").text(), jQuery(row).closest('tr').find("#tdTestCode").text(), row);
                }
                else {
                    testcount = parseInt(testcount) - 1;
                    jQuery('#spnTestCount').html(testcount);

                    var $tr = $(row).closest('tr');
                    var RmvInv = $tr.find('.inv').attr("id").split(',');
                    var len = RmvInv.length;
                    InvList.splice($.inArray(RmvInv[0], InvList), len);
                    row.closest('tr').remove();
                    if (jQuery('#tb_ItemList tr:not(#ItemHeader)').length == 0) {
                        jQuery('#tb_ItemList').hide();
                    }
                    enableSaveButton();
                }
            }
            function confirmDelete(CampTestID, TestName, TestCode, row) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: "".concat('Do you want to Remove ', '?', '<br/><br/><b>Test Code: ', TestCode, '</b>', '<br/><b>Test Name: ', TestName, '</b>'),
                    animation: 'zoom',
                    closeAnimation: 'scale',
                    useBootstrap: false,
                    opacity: 0.5,
                    theme: 'light',
                    type: 'red',
                    typeAnimated: true,
                    boxWidth: '420px',
                    buttons: {
                        'confirm': {
                            text: 'Yes',
                            useBootstrap: false,
                            btnClass: 'btn-blue',
                            action: function () {
                                PageMethods.removeCampTest(CampTestID, onSuccessRemove, OnfailureRemove, row);
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearActions();
                            }
                        },
                    }
                });
            }
            clearActions = function () {

            }
            function onSuccessRemove(result, row) {
                if (result == 1) {
                    toast('Success', "Item Remove Successfully");
                    testcount = parseInt(testcount) - 1;
                    jQuery('#spnTestCount').html(testcount);

                    var $tr = $(row).closest('tr');
                    var RmvInv = $tr.find('.inv').attr("id").split(',');
                    var len = RmvInv.length;
                    InvList.splice($.inArray(RmvInv[0], InvList), len);
                    row.closest('tr').remove();
                    if (jQuery('#tb_ItemList tr:not(#ItemHeader)').length == 0) {
                        jQuery('#tb_ItemList').hide();
                    }
                    enableSaveButton();
                }
                else {
                    toast('Error', "Error...");
                }

            }
            function OnfailureRemove() {
                toast('Error', "Error...");
            }
            
            function enableSaveButton() {
                if ((jQuery('#tb_ItemList tr:not(#ItemHeader)').length > 0)) {
                    jQuery('#btnSave').removeAttr('disabled');
                }
                else {
                    jQuery('#btnSave').attr('disabled', 'disabled');
                }
            }
        </script>
        <script type="text/javascript">
            jQuery(function () {
                bindSpecialTest();
            });
            function bindSpecialTest() {
                InvList = [];
                PageMethods.getTestDetail( onSuccessItem, OnfailureItem);
                InvList = [];
            }
            function onSuccessItem(result) {
                var TestData = jQuery.parseJSON(result);
                if (TestData != null) {
                    jQuery("#tb_ItemList tr:not(#ItemHeader)").remove();
                    for (var i = 0; i < TestData.length; i++) {
                        InvList.push(TestData[i].ItemID);
                        var appendText = [];
                        appendText.push("<tr id='"); appendText.push(TestData[i].ItemID); appendText.push("' class='GridViewItemStyle' >");
                        appendText.push('<td class="inv" id='); appendText.push(TestData[i].ItemID); appendText.push(' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>');
                        appendText.push('<td id="tdTestCode" style="font-weight:bold;">'); appendText.push(TestData[i].TestCode); appendText.push('</td>');
                        appendText.push('<td id="tdItemName" style="font-weight:bold;">'); appendText.push(TestData[i].ItemName); appendText.push('</td>');
                        appendText.push('<td id="tdIsNew" style="font-weight:bold;display:none">0</td>');
                        appendText.push('<td id="tdIsOld" style="font-weight:bold;display:none">1</td>');
                        appendText.push('<td id="tdAddedBy" style="font-weight:bold;text-align: left">'); appendText.push(TestData[i].AddedBy); appendText.push('</td>');
                        appendText.push('<td id="tdAddedDate" style="font-weight:bold;text-align: center">'); appendText.push(TestData[i].AddedDate); appendText.push('</td>');
                        appendText.push('<td id="tdLastUpdatedBy" style="font-weight:bold;text-align: left">'); appendText.push(TestData[i].LastUpdatedBy); appendText.push('</td>');
                        appendText.push('<td id="tdLastUpdatedDate" style="font-weight:bold;text-align: center">'); appendText.push(TestData[i].LastUpdatedDate); appendText.push('</td>');
                        appendText.push('<td id="tdFreeCampTestID" style="font-weight:bold;text-align: center;display:none">'); appendText.push(TestData[i].ID); appendText.push('</td>');
                        appendText.push("</tr>");
                        jQuery('#tb_ItemList').append(appendText.join(""));
                        jQuery('#tb_ItemList').css('display', 'block');
                        jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                    }
                    jQuery('#spnTestCount').text(TestData.length);
                    testcount = TestData.length;
                }
                else {
                    clearData();
                }
                enableSaveButton();
            }

            function OnfailureItem() {
            }
            
            
        </script>
        <script type="text/javascript">
            getReport = function () {
                serverCall('FreeCampTestMaster.aspx/gerReport', {  }, function (response) {
                    PostFormData(response, response.ReportPath);
                });

            }
        </script>
    </form>
</body>
</html>
