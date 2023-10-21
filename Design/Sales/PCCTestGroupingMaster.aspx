<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="PCCTestGroupingMaster.aspx.cs" Inherits="Design_Sales_PCCTestGroupingMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
                <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

     
  <div id="Pbody_box_inventory" style="width: 1304px;">
      <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">           
                <b>PCC Test Grouping Master</b>
              <br />
              <table style="width:100%;border-collapse:collapse;text-align:center">
                <tr >
                    <td style="width:46%">

                        &nbsp;
                        </td>
                    <td style="width:54%">
            <asp:RadioButtonList ID="rblGroupingCon" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="3" onclick="chkEditCon()">
              <asp:ListItem Value="1" Text="New" Selected="True" ></asp:ListItem>
                <asp:ListItem Value="2" Text="Edit" ></asp:ListItem>
               
          </asp:RadioButtonList>
                        </td>
                    </tr>
                  </table>
          
             
            </div>
       <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
      <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;"> 
           <table style="width:100%;border-collapse:collapse;text-align:center">
                
               <tr >
                    <td style="width:20%">
                        &nbsp;
                    </td>
                    <td style="width:40%" colspan="2">
                        
                    </td>
                   
                    <td style="width:20%">
                        &nbsp;
                    </td>
                    <td style="width:20%">
                        &nbsp;
                    </td>
                    </tr>
               <tr >
                    <td style="width:20%;text-align:right">
                      Group Name :&nbsp;
                    </td>
                    <td style="width:20%;text-align:left" >
                       
               <asp:DropDownList ID="ddlGroupName" runat="server" style="display:none" Width="186px" onchange="bindPCCTestGroup()" ></asp:DropDownList>
          <asp:TextBox ID="txtGroupName" runat="server" MaxLength="50" AutoCompleteType="Disabled" Width="180px" ></asp:TextBox>
<span id="spnGroupID" style="display:none"></span>
       <span id="spnGroupName" style="display:none"></span>                 
                    </td>
                   
                    <td style="width:20%;text-align:right" >
                   <span class="Edit" style="display:none">   Status :&nbsp;</span> 
                    </td>
                    <td style="width:20%;text-align:left">
                        <span  class="Edit" style="display:none">
                       <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal">
                           <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                           <asp:ListItem Text="DeActive" Value="0"></asp:ListItem>
                       </asp:RadioButtonList></span> 
                    </td>
                   <td style="width:20%">
                        &nbsp;
                    </td>
                    </tr>
               <tr>
                   <td colspan="5">&nbsp;</td>
               </tr>
               <tr>
                     <td style="width:20%">
                        &nbsp;
                    </td>
                    <td colspan="2" style="text-align:left">
                        <input id="rblsearchtype_1" onclick="clearItem()" value="1" name="rblSearchType" checked="checked" type="radio" />
                        <b>By Test Name</b><input id="rblsearchtype_0" onclick="clearItem()" value="0" name="rblSearchType" type="radio" />
                        <b>By Test Code</b><input id="rblsearchtype_2" onclick="clearItem()" value="2" name="rblSearchType" type="radio" />
                        <b>InBetween</b>
                    </td>
                    <td style="width:20%">
                        &nbsp;
                    </td>
                    <td style="width:20%">
                        &nbsp;
                    </td>
                </tr>
               <tr>
                   <td style="width:20%;text-align:right">
                        Test Name :&nbsp;
                    </td>
                    <td>
                        <div class="ui-widget" style="display: inline-block;">
                            <input type="hidden" id="theHidden" />

                            <input id="txtTest" size="50"  />
                        </div>
                    </td>
                    <td>
                        <div>
                            <b>Total Test: </b><span id="spnTestCount" style="font-weight: bold;">0</span>
                            
                        </div>
                    </td>
                   <td>&nbsp;</td><td>&nbsp;</td>
                </tr>
               </table>     
         <table style="width:100%;border-collapse:collapse;text-align:center">
                   <tr>
                       <td  style="width:17%">
                           &nbsp;
                           </td>
                    <td colspan="4" style="text-align:left; width:83%">
                        <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: scroll; width: 100%;">
                            <table id="tb_ItemList" style="width: 98%; border-collapse: collapse;display:none">
                                <tr id="ItemHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px;text-align: center">#</td>
                                   
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 520px; text-align: center">Item</td>
                                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: center;display:none">IsNew</td>
                                    

                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
          </div>
      <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;"> 
             <input type="button" class="searchbutton" onclick="saveTestGrouping()" id="btnSave" value="Save" title="Click to Save" disabled="disabled" />
             <input type="button" class="searchbutton" onclick="updateTestGrouping()" id="btnUpdate" value="Update" title="Click to Update"  style="display:none" />
             </div>
      </div>
     <script type="text/javascript">
         var testcount = 0;
        
         var InvList = [];
         function clearItem() {
             jQuery("#txtTest").val('');
         }
         
         jQuery(function () {
             chkEditCon();
         });
         function chkEditCon() {
             clearData();
             if (jQuery("#rblGroupingCon input[type=radio]:checked").val() == "1") {
                 jQuery("#txtGroupName,#btnSave").show();
                 jQuery("#ddlGroupName,#btnUpdate,.Edit").hide();
                
             }
             else {
                 jQuery("#txtGroupName,#btnUpdate,#ddlGroupName,.Edit").show();
                 
                 jQuery("#btnSave").hide();
                 bindGroup();
             }
         }
         function bindGroup() {
             if (jQuery("#ddlGroupName option").length == 0) {
                 PageMethods.bindGroup(onSuccessGroup, OnfailureGroup);
             }

         }
         function onSuccessGroup(result) {
             var GroupData = jQuery.parseJSON(result);
             jQuery("#ddlGroupName option").remove();
             jQuery("#ddlGroupName").append(jQuery("<option></option>").val("0").html("---Select---"));
             for (i = 0; i < GroupData.length; i++) {
                 jQuery("#ddlGroupName").append(jQuery("<option></option>").val(GroupData[i].GroupID).html(GroupData[i].GroupName));

             }
         }
         function OnfailureGroup(result) {


         }
      </script>
     <script type="text/javascript">
        jQuery("#txtTest")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === jQuery.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  jQuery("#theHidden").val('');
              })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("PCCTestGroupingMaster.aspx?cmd=GetTestList", {
                          SearchType: jQuery('input:radio[name=rblSearchType]:checked').val(),
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
                      AddItem(ui.item.value, ui.item.type);
                      return false;
                  },
              });
        function extractLast1(term) {
            return term;
        }
    </script>
     <script type="text/javascript">
         function validateTest() {
             if (jQuery('#ddlGroupName').is(':visible') && jQuery('#ddlGroupName').val() == 0) {
                 showerrormsg('Please Select Group Name');
                 jQuery('#ddlGroupName').focus();
                 return false;
             }
            if (jQuery.trim(jQuery('#txtGroupName').val()) == "") {
                showerrormsg('Please Enter Group Name');
                jQuery('#txtGroupName').focus();
                return false;

            }
            
            if (jQuery('#tb_ItemList tr:not(#ItemHeader)').length == 0) {
                showerrormsg('Please Add Item');
                return false;
            }
           
            return true;
        }
        function saveTestGrouping() {
            if (validateTest()) {
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                var ItemDetail = getItemDetail();
                PageMethods.savePCCTestGroup( jQuery.trim(jQuery('#txtGroupName').val()), ItemDetail, onSuccess, Onfailure);
            }
        }
        function onSuccess(result) {
            if (result == 1) {
                showerrormsg('Record Save Successfully');
                clearData();                
            }
           else if (result == 0) {
               showerrormsg('Error');
               
            }
           else if (result == 2) {
               showerrormsg('Group Name Already Exits');
           }
           else {

               var addedData = jQuery.parseJSON(result);

               for (var i = 0; i < addedData.length; i++) {
                   jQuery('#tb_ItemList tr').each(function () {
                       var id = jQuery(this).closest("tr").attr("id");
                       if (id != "ItemHeader") {
                           if (addedData[i].ItemID == jQuery(this).closest("tr").attr("id")) {

                               jQuery(this).closest("tr").css("background-color", "#FF0000");
                               jQuery(this).closest("tr").attr('title', "Item Already Added in Group " + addedData[i].GroupName);
                           }
                       }
                   });
               }
           }

            jQuery.unblockUI();
            jQuery("#btnSave").removeAttr('disabled').val('Save');
        }
        function Onfailure() {
            showerrormsg('Error');
            
            jQuery("#btnSave").removeAttr('disabled').val('Save');
            jQuery.unblockUI();
        }
      </script>  
     <script type="text/javascript">
            function bindPCCTestGroup() {
                jQuery("#txtGroupName").val('');
                jQuery("#spnGroupID").text(jQuery('#ddlGroupName').val().split('#')[0]);
                jQuery("#spnGroupName").text(jQuery('#ddlGroupName option:selected').text());
                
                jQuery('#rblActive').find("input[value='" + jQuery('#ddlGroupName').val().split('#')[1] + "']").prop("checked", "checked");
                if (jQuery('#ddlGroupName').val() != 0)
                    PageMethods.bindPCCTestGroup(jQuery.trim(jQuery('#ddlGroupName').val().split('#')[0]), onSuccessItem, Onfailure);
                else {
                    clearData();

                }

            }
        function onSuccessItem(result) {
            var TestData = jQuery.parseJSON(result);
            if (TestData != null) {
                jQuery("#tb_ItemList tr:not(#ItemHeader)").remove();
                for (var i = 0; i < TestData.length; i++) {

                    InvList.push(jQuery.trim(TestData[i].ItemID));

                    var appendText = [];

                    appendText.push( "<tr id='" + TestData[i].ItemID + "' class='GridViewItemStyle' >");
                    appendText.push('<td class="ItemID" id=' + TestData[i].ItemID + ' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode(jQuery(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>');
                    appendText.push('<td id="tdTestCode" style="font-weight:bold;">' + TestData[i].TestCode + '</td>');
                    appendText.push('<td id="tdItemName" style="font-weight:bold;">' + TestData[i].ItemName + '</td>');
                    appendText.push('<td id="tdIsNew" style="font-weight:bold;display:none">0</td>');
                    appendText.push("</tr>");
                    jQuery('#tb_ItemList').append(appendText.join(""));
                    jQuery('#tb_ItemList').css('display', 'block');
                    jQuery(".TestDetail").scrollTop(jQuery('.TestDetail').prop('scrollHeight'));

                    
                }

                 jQuery("#txtGroupName").val(jQuery('#ddlGroupName option:selected').text());
                jQuery('#rblActive').find("input[value='" + jQuery('#ddlGroupName').val().split('#')[1] + "']").prop("checked", "checked");

                jQuery('#spnTestCount').text(TestData.length);
                testcount = TestData.length;
            }
            else {
                clearData();
            }
            enableSaveButton();
            jQuery.unblockUI();
        }
        function OnfailureItem() {
            jQuery.unblockUI();
        }
        </script>
     <script type="text/javascript">
     function clearData() {
            InvList = [];
            jQuery("#btnSave").removeAttr('disabled').val('Save');
            jQuery("#tb_ItemList tr:not(#ItemHeader)").remove();
            jQuery('#spnTestCount').text('0');
            jQuery('#txtGroupName').val('');
            jQuery('input:radio[name="rblSearchType"][value="1"]').prop('checked', true);          
            testcount = 0;
            jQuery("#spnGroupID,#spnGroupName").text('');
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
          </script>
     <script type="text/javascript">
         function getItemDetail() {
             var dataItem = new Array();
             var ObjItem = new Object();
             jQuery('#tb_ItemList tr').each(function () {
                 var id = jQuery(this).closest("tr").attr("id");
                 if (id != "ItemHeader") {
                     ObjItem.ItemID = jQuery(this).closest("tr").attr("id");                  
                     dataItem.push(ObjItem);
                     ObjItem = new Object();
                 }
             });
             return dataItem;
         }
    </script>
     <script type="text/javascript">
        function AddItem(ItemID, type) {
            if (ItemID == '') {
                showerrormsg("Please Select Item");
                return false;
            }

            jQuery.ajax({
                url: "PCCTestGroupingMaster.aspx/GetItemMaster",
                data: '{ ItemID:"' + ItemID + '",Type:"' + type + '"}', 
                type: "POST",       
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = jQuery.parseJSON(result.d);
                    if (TestData.length == 0) {
                        showerrormsg('No Record Found..!');
                        return;
                    }
                    else {                       
                        var ItemID = TestData[0].ItemID;
                        if (TestData[0].GroupName != "") {
                            showerrormsg("Item Already added in Group " + TestData[0].GroupName);
                            return;
                        }
                        if (jQuery.inArray(ItemID, InvList) != -1) {
                            showerrormsg("Item Already in List..");
                            return;

                        }
                        
                        InvList.push(jQuery.trim(TestData[0].ItemID));
                        
                        if (jQuery('#spnTestCount').text() != 0)
                            testcount = jQuery('#tb_ItemList tr:not(#ItemHeader)').length;
                        testcount = parseInt(testcount) + 1;
                        jQuery('#spnTestCount').text(testcount);
                        var appendText = [];

                        appendText.push( "<tr id='" + TestData[0].ItemID + "' class='GridViewItemStyle' style='background-color:lemonchiffon'>");
                        appendText.push('<td class="ItemID" id=' + TestData[0].ItemID + ' style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode(jQuery(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>');
                        appendText.push('<td id="tdTestCode" style="font-weight:bold;">' + TestData[0].testCode + '</td>');
                        appendText.push('<td id="tdItemName" style="font-weight:bold;">' + TestData[0].typeName + '</td>');
                        appendText.push('<td id="tdIsNew" style="font-weight:bold;display:none">1</td>');


                        appendText.push("</tr>");
                        jQuery('#tb_ItemList').append(appendText.join(""));
                        jQuery('#tb_ItemList').css('display', 'block');
                        jQuery(".TestDetail").scrollTop(jQuery('.TestDetail').prop('scrollHeight'));
                        enableSaveButton();
                    }

                },
                error: function (xhr, status) {
                    showerrormsg('Error...');
                }
            });

        }
        function deleteItemNode(row) {
            testcount = parseInt(testcount) - 1;
            jQuery('#spnTestCount').html(testcount);

            var $tr = jQuery(row).closest('tr');
            var RmvInv = $tr.find('.ItemID').attr("id");
            var len = RmvInv.length;
            InvList.splice(jQuery.inArray(RmvInv[0], InvList), len);
            row.closest('tr').remove();
            if (jQuery('#tb_ItemList tr:not(#ItemHeader)').length == 0) {
                jQuery('#tb_ItemList').hide();

            }
            var IsNew = jQuery(row).closest('tr').find("#tdIsNew").text();
            //if (IsNew == 0) {
            //    jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            //    PageMethods.removePCCTestGrouping(RmvInv, onSuccessRemove, OnfailureRemove);
            //}

            enableSaveButton();
        }
        function onSuccessRemove(result) {
            if (result == 1) {
                showerrormsg("Item Remove Successfully");
            }
            else {
                showerrormsg("Error...");
            }
            jQuery.unblockUI();
        }
        function OnfailureRemove() {
            showerrormsg('Error...');
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
        function updateTestGrouping() {
            if (validateTest()) {
                if (jQuery('#spnGroupID').text() != "") {
                    jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                    jQuery("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
                    var ItemDetail = getItemDetail();
                    var isEdit=0;
                    if ((jQuery.trim(jQuery('#spnGroupName').text()) != jQuery('#txtGroupName').val()) || (jQuery('#rblActive input[type=radio]:checked').val() != jQuery("#ddlGroupName").val().split('#')[1]))
                        isEdit = 1;
                    PageMethods.updatePCCTestGroup(jQuery.trim(jQuery('#spnGroupID').text()), isEdit, jQuery('#rblActive input[type=radio]:checked').val(), jQuery('#txtGroupName').val(), ItemDetail, onUpdate, OnfailureUpdate);
                }
                else {
                    showerrormsg('Select Group to Update');
                }
            }
        }

        function onUpdate(result) {
            if (result == 1) {
                showerrormsg('Record Updated Successfully');
                clearData();

                jQuery('#ddlGroupName').prop('selectedIndex', 0);
                jQuery('#spnGroupID,#spnGroupName').text('');
            }
           else if (result == 0) {
               showerrormsg('Error');
              
            }
            else {
               var addedData = jQuery.parseJSON(result);

               for (var i = 0; i < addedData.length; i++) {
                   jQuery('#tb_ItemList tr').each(function () {
                       var id = jQuery(this).closest("tr").attr("id");
                       if (id != "ItemHeader") {
                           if (addedData[i].ItemID == jQuery(this).closest("tr").attr("id")) {

                               jQuery(this).closest("tr").css("background-color", "#FF0000");
                               jQuery(this).closest("tr").attr('title', "Item Already Added in Group " + addedData[i].GroupName);
                           }
                       }
                   });                 
               }              
            }
            jQuery.unblockUI();
            jQuery("#btnUpdate").removeAttr('disabled').val('Update');
        }
        function OnfailureUpdate() {
            showerrormsg('Error');

            jQuery("#btnUpdate").removeAttr('disabled').val('Update');
            jQuery.unblockUI();
        }
    </script>
</asp:Content>

