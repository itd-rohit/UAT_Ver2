<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SpecialTestMaster.aspx.cs" Inherits="Design_Master_SpecialTestMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <style type="text/css">
        .compareRate {
            background-color: #90EE90;
        }
    </style>
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <div id="Pbody_box_inventory" ">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Special Test Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static"/>
               <asp:Label ID="lblCreatedBy" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" style="display:none"/>
            <asp:Label ID="lblAddedData" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" style="display:none"/>
        </div>
        
    <div class="POuter_Box_Inventory" style="text-align: left;">
              <div class="Purchaseheader">
                Manage Item
            </div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td colspan="2">
                        <input id="rblsearchtype_1" onclick="clearItem()" value="1" name="rblsearchtype" checked="checked" type="radio" />
                        <b>By Test Name</b><input id="rblsearchtype_0" onclick="clearItem()" value="0" name="rblsearchtype" type="radio" />
                        <b>By Test Code</b><input id="rblsearchtype_2" onclick="clearItem()" value="2" name="rblsearchtype" type="radio" />
                        <b>InBetween</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="ui-widget" style="display: inline-block;">
                            <input type="hidden" id="theHidden" />

                            <input id="ddlInvestigation" size="50" tabindex="19" />
                        </div>
                    </td>
                    <td>
                        <div>
                            <b>Total Test: </b><span id="spnTestCount" style="font-weight: bold;">0</span>
                            &nbsp;<b style="display:none">Total Amt.: </b><span id="spnTotalAmt" style="font-weight: bold;display:none">0</span>
                        </div>
                    </td>
                </tr>
                </table>
               <table style="width: 100%;border-collapse:collapse">
                   <tr>
                    <td colspan="2">
                        <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: scroll; width: 100%;">
                            <table id="tb_ItemList" style="width: 98%; border-collapse: collapse;display:none">
                                <tr id="ItemHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px;text-align: center">#</td>
                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 420px; text-align: center">Item</td>
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Rate</td>
                                    <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Added By</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Added DateTime</td>
                                    <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Last Updated By</td>
                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Last Updated DateTime</td>
                                    <td style="display: none;"></td>

                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
             <input type="button" class="ItDoseButton" onclick="saveTest()" id="btnSave" value="Save" title="Click to Save" disabled="disabled" />
             <input type="button" class="ItDoseButton" onclick="updateTest()" id="btnUpdate" value="Update" title="Click to Update"  style="display:none" />
             </div>

    </div>
    <script type="text/javascript">
        var testcount = 0;
        var totalamt = 0;
        var InvList = [];
        function clearItem() {
            jQuery("#ddlInvestigation").val('');
        }
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }

        }
      </script>
    <script type="text/javascript">
        jQuery("#ddlInvestigation")
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
                      $.getJSON("CampMaster.aspx?cmd=GetTestList", {
                          SearchType: $('input:radio[name=rblsearchtype]:checked').val(),
                          TestName: extractLast1(request.term)
                      }, response);
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
                jQuery("#lblMsg").text('Please Add Item');
                return false;
            }
            var itemRate = 0;
            jQuery('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "ItemHeader") {
                    if (jQuery(this).closest("tr").find("#txtRate").val() == "") {
                        itemRate = 1;
                        jQuery(this).closest("tr").find("#txtRate").focus();
                        return false;
                    }
                }

            });
            if (itemRate == 1) {
                jQuery("#lblMsg").text('Please Enter Rate');
                return false;
            }
            return true;
        }
        function saveTest() {
            if (validateTest()) {
               
                jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                var ItemDetail = getItemDetail();
                PageMethods.saveTest(ItemDetail, onSuccess, Onfailure);
            }
        }
        function onSuccess(result) {
            if (result == 1) {
                showerrormsg('Record Save Successfully');
                clearData();
                PageMethods.getSpecialTest(onSuccessItem, OnfailureItem);
            }
            else {
                showerrormsg('Error');
                jQuery("#btnSave").removeAttr('disabled').val('Save');
            }
        }
        function Onfailure() {
            showerrormsg('Error');
            jQuery('#lblMsg').text('Error');
            jQuery("#btnSave").removeAttr('disabled').val('Save');
        }
        function clearData() {
                InvList = [];
            jQuery("#btnSave").removeAttr('disabled').val('Save');
            //   jQuery('#tb_ItemList').hide();
            jQuery("#tb_ItemList tr:not(#ItemHeader)").remove();
            jQuery('#spnTestCount,#spnTotalAmt').text('0');

            jQuery('input:radio[name="rblsearchtype"][value="1"]').prop('checked', true);
            totalamt = 0;
            testcount = 0;

        }
        </script>
    <script type="text/javascript">
        function getItemDetail() {
            var dataItem = new Array();
            var ObjItem = new Object();

            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "ItemHeader") {
                    ObjItem.ItemID = jQuery(this).closest("tr").attr("id");
                    ObjItem.Rate = jQuery(this).closest("tr").find("#txtRate").val();
                    ObjItem.IsNew = jQuery(this).closest("tr").find("#tdIsNew").text();
                    ObjItem.IsOld = jQuery(this).closest("tr").find("#tdIsOld").text();
                    ObjItem.IsRateChange = jQuery(this).closest("tr").find("#spnIsRateChange").text();

                    dataItem.push(ObjItem);
                    ObjItem = new Object();
                }

            });
            return dataItem;
        }

    </script>
    <script type="text/javascript">
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
       
        function AddItem(ItemID, type, Rate) {
            if (ItemID == '') {
                showerrormsg("Please Select investigation");
                return false;
            }

            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/GetItemMaster",
                data: '{ ItemID:"' + ItemID + '",Type:"' + type + '",Rate:"' + Rate + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {
                        alert('No Record Found..!');
                        return;
                    }
                    else {

                        var ItemID = TestData[0].ItemID;
                       
                       
                        for (var j = 0; j < (ItemID.split(',').length) ; j++) {
                            if ($.inArray(ItemID.split(',')[j], InvList) != -1) {
                                alert("Item Already in List..!");
                                return;

                            }
                        }

                            InvList.push($.trim(TestData[0].ItemID));
                        


                        if ($('#spnTestCount').text() != 0)
                            testcount = jQuery('#tb_ItemList tr:not(#ItemHeader)').length;
                        testcount = parseInt(testcount) + 1;
                        $('#spnTestCount').text(testcount);


                        var mydata = "<tr id='" + TestData[0].ItemID + "' class='GridViewItemStyle' style='background-color:lemonchiffon'>";
                        mydata += '<td class="inv" id=' + TestData[0].ItemID + ' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>';
                        mydata += '<td id="tdTestCode" style="font-weight:bold;">' + TestData[0].testCode + '</td>';
                        mydata += '<td id="tdItemName" style="font-weight:bold;">' + TestData[0].typeName + '</td>';

                        mydata += '<td id="tdIsNew" style="font-weight:bold;display:none">1</td>';
                        mydata += '<td id="tdIsOld" style="font-weight:bold;display:none">0</td>';

                        mydata += '<td id="tdItemRate" style="font-weight:bold;display:none">0</td>';
                        mydata += '<td id="tdIsRateChange" style="font-weight:bold;display:none"><span id="spnIsRateChange" >0</span></td>';
                        mydata += '<td id="tdRate" style="color:lemonchiffon;text-align: center"><input type="text" style="width:80px;" onkeyup="sumTotal()" id="txtRate" value="" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>';
                        mydata += '<td id="tdAddedBy" style="font-weight:bold;text-align: center">' + jQuery("#lblCreatedBy").text() + '</td>';
                        mydata += '<td id="tdAddedDate" style="font-weight:bold;text-align: center">' + jQuery("#lblAddedData").text() + '</td>';
                        mydata += '<td id="tdLastUpdatedBy" style="font-weight:bold;text-align: center"></td>';
                        mydata += '<td id="tdLastUpdatedDate" style="font-weight:bold;text-align: center"></td>';



                        mydata += "</tr>";
                        jQuery('#tb_ItemList').append(mydata);
                        jQuery('#tb_ItemList').css('display', 'block');
                        // sumTotal();

                        jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                        enableSaveButton();
                    }

                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });

        }
        function deleteItemNode(row) {
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
            // sumTotal();
            enableSaveButton();
        }
        function sumTotal() {
            var totalAmt = 0;
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).attr("id");
                if (id != "ItemHeader") {
                    var rate = 0;
                    if (isNaN(jQuery(this).find('#txtRate').val()) || (jQuery(this).find('#txtRate').val() == ""))
                        rate = 0;
                    else
                        rate = jQuery(this).find('#txtRate').val();
                    totalAmt = parseFloat(totalAmt) + parseFloat(rate);

                }
            });
            jQuery('#spnTotalAmt').text(totalAmt);
            var count = jQuery('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                $('#spnTotalAmt').html('0');
            }

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
            PageMethods.getSpecialTest(onSuccessItem, OnfailureItem);
        });

        function onSuccessItem(result) {
            var TestData = jQuery.parseJSON(result);
           
            for (var i = 0; i < TestData.length; i++) {

                InvList.push($.trim( TestData[i].ItemID));


                var mydata = "<tr id='" + TestData[i].ItemID + "' class='GridViewItemStyle' >";
                mydata += '<td class="inv" id=' + TestData[i].ItemID + ' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>';
                mydata += '<td id="tdTestCode" style="font-weight:bold;">' + TestData[i].TestCode + '</td>';
                mydata += '<td id="tdItemName" style="font-weight:bold;">' + TestData[i].ItemName + '</td>';

                mydata += '<td id="tdIsNew" style="font-weight:bold;display:none">0</td>';
                mydata += '<td id="tdIsOld" style="font-weight:bold;display:none">1</td>';


                mydata += '<td id="tdItemRate" style="font-weight:bold;display:none">' + TestData[i].Rate + '</td>';
                mydata += '<td id="tdIsRateChange" style="font-weight:bold;display:none"><span id="spnIsRateChange" >0</span></td>';
                mydata += '<td id="tdRate" style="color:lemonchiffon;text-align: center"><input type="text" style="width:80px;" onkeyup="chkPreviousRate(this)" id="txtRate" value=' + TestData[i].Rate + ' onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>';

                mydata += '<td id="tdAddedBy" style="font-weight:bold;text-align: center">' + TestData[i].AddedBy + '</td>';
                mydata += '<td id="tdAddedDate" style="font-weight:bold;text-align: center">' + TestData[i].AddedDate + '</td>';
                mydata += '<td id="tdLastUpdatedBy" style="font-weight:bold;text-align: center">' + TestData[i].LastUpdatedBy + '</td>';
                mydata += '<td id="tdLastUpdatedDate" style="font-weight:bold;text-align: center">' + TestData[i].LastUpdatedDate + '</td>';

                mydata += "</tr>";
                jQuery('#tb_ItemList').append(mydata);
                jQuery('#tb_ItemList').css('display', 'block');
                jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
            }
            $('#spnTestCount').text(TestData.length);
            // sumTotal();
            testcount = TestData.length;
            enableSaveButton();
          
        }
        function OnfailureItem() {

        }
        function chkPreviousRate(rowID) {
            var PreviousRate = $(rowID).closest('tr').find("#tdItemRate").text();
            var currentRate = $(rowID).closest('tr').find("#txtRate").val();
            if (parseFloat(PreviousRate) != parseFloat(currentRate)) {
                jQuery(rowID).closest('tr').addClass("compareRate");
                jQuery(rowID).closest('tr').find("#spnIsRateChange").text(1);
            }
            else {
                jQuery(rowID).closest('tr').removeClass("compareRate");
                jQuery(rowID).closest('tr').find("#spnIsRateChange").text(0);
            }
        }
    </script>
</asp:Content>

