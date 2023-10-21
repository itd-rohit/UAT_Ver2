<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DiscountOnMRPMaster.aspx.cs" Inherits="Design_Sales_DiscountOnMRPMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <%: Scripts.Render("~/bundles/MsAjaxJs") %>

     

   <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
  <div id="Pbody_box_inventory" style="width: 1304px;">
      <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">   
                <b>Discount On MRP Master</b>
              <br />
             <table style="width:100%;border-collapse:collapse;text-align:center">
                <tr style="text-align:center">
                    <td style="width:40%">
                        &nbsp;
                    </td>
                    <td  colspan="4" style="width:30%">
                         <asp:RadioButtonList ID="rblEntryType" runat="server"   ClientIDMode="Static"  RepeatDirection="Horizontal" RepeatLayout="Table" onchange="bindSalesHierarchy()" >
                    <asp:ListItem Text="PCC" Value="1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="PUP" Value="2"></asp:ListItem>
                </asp:RadioButtonList>
                    </td>
                     <td style="width:30%">
                        &nbsp;
                    </td>
                </tr>
            </table>
            </div>
       <div class="POuter_Box_Inventory" style="text-align: left;width: 1300px;">
        
              <div id="divTestDetail" style="overflow:auto; height:300px">                 
 
                  <table border="1" id="mtable" style="width:99%;border-collapse:collapse" class="GridViewStyle">
                <thead>
                
                </thead>
                <tbody>
                    
            </tbody>
        </table>  

              </div>  
             
              </div>
       <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;" id="div_Save">
              <input type="button" id="btnSave" onclick="saveTestLimit()" value="Save"  class="searchbutton"/>&nbsp;&nbsp;
             </div>
      </div>
    <script type="text/javascript">
        jQuery(function () {
            bindSalesHierarchy();
        });

        function bindSalesHierarchy() {
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
          tblbody = []; tblhead = [];
            data = ""; tblhrow = [];
            jQuery('#mtable thead,#mtable tbody').html('');
            PageMethods.bindSalesHierarchy(jQuery("#rblEntryType input[type=radio]:checked").next().text(), onSuccessSalesHierarchy, OnfailureSalesHierarchy);
        }
        var data = "";  
       

        var tblbody = [];
        var tblhead = [];
        var tblhrow = [];
        function onSuccessSalesHierarchy(result) {
            data = jQuery.parseJSON(result);
            var count = 0;
            jQuery.each(data, function () {
               var tblrow = [];
                jQuery.each(this, function (k, v) {
                    if (k == 'ID') {
                        if (k == 'ID') {
                            tblrow.push("<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>");
                        }
                        else {
                            tblrow.push("<td class='GridViewLabItemStyle'>" + v + "</td>");
                        }
                    }
                    else {
                        if (v == null)
                            v = '#';
                        var DiscountOnMRP = v.split('#');
                        if (k == 'BusinessCommitment')
                            tblrow.push("<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><input type='text' style='width:90px' id='" + k.substr(k.indexOf('#') + 1) + "' class='BusinessCommitment' value='" + DiscountOnMRP[0] + "'/></td>");
                        else
                            tblrow.push("<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><input type='text' style='width:70px' id='" + k.substr(k.indexOf('#') + 1) + "' class='testValue' value='" + DiscountOnMRP[0] + "'/></td>");


                    }
                    if (k == 'BusinessCommitment') {
                        count = count + 1;
                    }
                    if (count == 1) {
                        if (k == 'ID') {
                            if (k == 'ID') {
                                tblhrow.push("<td style='width:150px; display: none;' class='GridViewHeaderStyle'>" + k + "</td>");
                            }
                            else {
                                tblhrow.push("<td style='width:150px;' class='GridViewHeaderStyle'>" + k + "</td>");
                            }
                        }
                        else {
                            tblhrow.push("<td style='width:80px;' class='GridViewHeaderStyle " + k.substr(k.indexOf('#') + 1) + "'>" + k + "</td>");
                        }
                    }
                });
                tblrow.push("<td class='GridViewLabItemStyle' style='text-align: center;width:40px'><img src='../../App_Images/ButtonAdd.png' class='Add' id='imgAdd' style='cursor:pointer' title='Click to Add Row' onclick='return addDetail(this)' /></td>");
                tblrow.push("<td class='GridViewLabItemStyle' style='text-align: center;width:40px'><img src='../../App_Images/Delete.gif' class='Remove' id='imgRmv' style='cursor:pointer' title='Click to Remove Row' onclick='removeDetail(this)'/></td>");
                tblbody.push("<tr>" + tblrow.join("") + "</tr>");
            });
            tblhead.push ("<tr>" + tblhrow.join("") + "</tr>");
            jQuery("#mtable thead").html(tblhead.join(""));
            jQuery("#mtable tbody").html(tblbody.join(""));

            jQuery("#mtable tbody tr").find("#imgAdd,#imgRmv").hide();
            jQuery("#mtable tbody tr:last").find("#imgAdd,#imgRmv").show();
            if (jQuery("#mtable tbody tr").length == "1") {
                jQuery("#mtable tbody tr:last").find("#imgRmv").hide();
            }
            jQuery.unblockUI();

        }
        function OnfailureSalesHierarchy(result) {
            jQuery.unblockUI();

        }
        function addDetail(rowID) {

            var count = jQuery("#mtable tbody tr").length;
            var addColumn = 0;
           tblbody = []; tblrow = [];
            var isEmptyValue = 0;
            var businessComm = jQuery(rowID).closest('tr').find("#BusinessCommitment").val();
            if (businessComm == "") {
                showerrormsg('Please Enter Business Commitment');
                jQuery(rowID).closest('tr').find("#BusinessCommitment").focus();
                isEmptyValue = 1;
                return false;
            }
            jQuery(rowID).closest('tr').find(".testValue").each(function (event) {
                var DiscountOnMRP = jQuery.trim(jQuery(this).closest('td').find(".testValue").val());
                if (DiscountOnMRP == "") {
                    showerrormsg('Please Enter Test Limit');
                    jQuery(this).closest('td').find(".testValue").focus();
                    isEmptyValue = 1;
                    return false;
                }
                var DiscountOnMRP1 = jQuery(this).closest('td').next('td').find(".testValue").val();

                if (DiscountOnMRP1 == "" && DiscountOnMRP1 != 'undefined') {
                    showerrormsg('Please Enter Test Limit');
                    jQuery(this).closest('td').next('td').find(".testValue").focus();
                    isEmptyValue = 1;
                    //  event.preventDefault();
                    return false;

                }
                if (parseInt(DiscountOnMRP) > parseInt(DiscountOnMRP1)) {
                    showerrormsg('Please Enter Valid Test Limit');
                    jQuery(this).closest('td').next('td').find(".testValue").focus();
                    isEmptyValue = 1;
                    return false;
                }
            });
            if (jQuery("#mtable tbody tr").length > 1) {
                jQuery('#mtable tbody tr').find("#BusinessCommitment").not(':last').each(function (event) {

                    var PreBusinessComm = jQuery(this).closest('tr').find('#BusinessCommitment').val();

                    if (parseFloat(businessComm) == parseFloat(PreBusinessComm)) {
                        showerrormsg('Please Enter Valid Business Commitment');
                        jQuery(rowID).closest('tr').find("#BusinessCommitment").focus();
                        isEmptyValue = 1;
                        return false;
                    }


                });
            }
            
            if (isEmptyValue == 1) {
                return false;
            }
            jQuery("#mtable tbody tr:last").find("#imgAdd,#imgRmv").hide();
            jQuery.each(data, function () {
                if (addColumn == 0) {
                     var tblrow = [];
                    jQuery.each(this, function (k, v) {
                        if (k == 'ID') {
                            if (k == 'ID') {
                                tblrow.push("<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>");
                            }
                            else {
                                tblrow.push("<td class='GridViewLabItemStyle'>" + v + "</td>");
                            }
                        }
                        else {
                            if (v == null)
                                v = '#';
                            var DiscountOnMRP = v.split('#');
                            if (k == 'BusinessCommitment')
                                tblrow.push("<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><input type='text' style='width:90px' id='" + k.substr(k.indexOf('#') + 1) + "' class='BusinessCommitment' value=''/></td>");
                            else
                                tblrow.push("<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><input type='text' style='width:70px' id='" + k.substr(k.indexOf('#') + 1) + "' class='testValue' value=''/></td>");
                        }
                        addColumn = 1;
                    });
                    tblrow.push("<td class='GridViewLabItemStyle' style='text-align: center;width:40px'><img src='../../App_Images/ButtonAdd.png' class='Add' style='cursor:pointer' id='imgAdd' title='Click to Add Row' onclick='return addDetail(this)' /></td>");
                    tblrow.push("<td class='GridViewLabItemStyle' style='text-align: center;width:40px'><img src='../../App_Images/Delete.gif' class='Remove' style='cursor:pointer' id='imgRmv' title='Click to Remove Row' onclick='removeDetail(this)'/></td>");
                    tblbody.push("<tr>" + tblrow.join("") + "</tr>");

                    jQuery("#mtable tbody").append(tblbody.join(""));
                }
            });
                                
        }
        function removeDetail() {
            jQuery("#mtable tbody tr:last").remove();
            jQuery("#mtable tbody tr:last").find("#imgAdd,#imgRmv").show();
            if (jQuery("#mtable tbody tr").length == "1") {
                jQuery("#mtable tbody tr:last").find("#imgRmv").hide();
            }
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
        jQuery('body').on('keydown', 'input.testValue', function (e) {
            // Allow: backspace, delete, tab, escape, enter and .        
            if (jQuery.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                // Allow: Ctrl+A, Command+A
                (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                // Allow: home, end, left, right, down, up
                (e.keyCode >= 35 && e.keyCode <= 40)) {
                // let it happen, don't do anything
                return;
            }
            // Ensure that it is a number and stop the keypress
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });
        jQuery('body').on('keydown', 'input.BusinessCommitment', function (e) {
            // Allow: backspace, delete, tab, escape, enter and .
            if (jQuery.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                // Allow: Ctrl+A, Command+A
                (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                // Allow: home, end, left, right, down, up
                (e.keyCode >= 35 && e.keyCode <= 40)) {
                // let it happen, don't do anything
                return;
            }
            // Ensure that it is a number and stop the keypress
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });
    </script>
    <script type="text/javascript">
        function saveTestLimit() {
            var isEmptyValue = 0;
            jQuery('#mtable tbody tr').find("#BusinessCommitment").each(function () {
                var businessCommitment = jQuery.trim(jQuery(this).closest('tr').find('#BusinessCommitment').val());
                if (businessCommitment == "") {
                    showerrormsg('Please Enter Business Commitment');
                    jQuery(this).closest('tr').find("#BusinessCommitment").focus();
                    isEmptyValue = 1;
                    return;
                }
                var preBusinessCommitment = jQuery.trim(jQuery(this).closest('tr').next('tr').find('#BusinessCommitment').val());

                if (preBusinessCommitment != 'null') {
                    if (parseFloat(businessCommitment) == parseFloat(preBusinessCommitment)) {
                        showerrormsg('Please Enter Valid Business Commitment');
                        jQuery(this).closest('tr').next('tr').find('#BusinessCommitment').focus();
                        isEmptyValue = 1;
                        return;
                    }
                }

            });
            if (isEmptyValue == 1) {
                return;
            }

            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                jQuery(this).find('td').find(".testValue").each(function () {

                    var DiscountOnMRP = jQuery.trim(jQuery(this).closest('td').find(".testValue").val());
                    if (DiscountOnMRP == "") {
                        showerrormsg('Please Enter Test Limit');
                        jQuery(this).closest('td').find(".testValue").focus();
                        isEmptyValue = 1;
                        return;
                    }
                    var DiscountOnMRP1 = jQuery(this).closest('td').next('td').find(".testValue").val();

                    if (DiscountOnMRP1 == "" && DiscountOnMRP1 != 'undefined') {
                        showerrormsg('Please Enter DiscountOnMRP');
                        jQuery(this).closest('td').next('td').find(".testValue").focus();
                        isEmptyValue = 1;

                        return;
                    }
                    if (DiscountOnMRP1 != 'undefine') {
                        if (parseInt(DiscountOnMRP) > parseInt(DiscountOnMRP1)) {
                            showerrormsg('Please Enter Valid DiscountOnMRP');
                            jQuery(this).closest('td').next('td').find(".testValue").focus();
                            isEmptyValue = 1;
                            return;
                        }
                    }


                });
            });
            if (isEmptyValue == 1) {
                return;
            }

            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var dataItem = new Array();
            var item = new Object();
            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                var $tds = jQuery(this).find('td');

                var businessCommitment = parseFloat(jQuery(this).closest('tr').find('#BusinessCommitment').val());
                jQuery(".testValue", this).each(function () {

                    var SalesID = parseInt($(this).attr('id'));
                    var DiscountOnMRP = this.value;
                    if (DiscountOnMRP.length != 0 && DiscountOnMRP.length != '' && DiscountOnMRP != 'null') {

                        item.businessCommitment = businessCommitment;
                        item.salesID = SalesID;
                        item.DiscountOnMRP = DiscountOnMRP;
                        dataItem.push(item);
                        item = new Object();
                    }
                });


            });
            if (dataItem.length > 0) {
                jQuery.ajax({
                    type: "POST",
                    url: "DiscountOnMRPMaster.aspx/saveTestLimit",
                    data: "{ItemDetail:'" + JSON.stringify(dataItem) + "',EntryType:'" + jQuery("#rblEntryType input[type=radio]:checked").next().text() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result['d'] == "1") {
                            showerrormsg('Record Saved Successfully');
                        }
                        else {
                            showerrormsg('Error');
                        }
                        jQuery.unblockUI();
                        dataItem.splice(0, dataItem.length);
                    },
                    failure: function (response) {
                        showerrormsg('Error');
                        jQuery.unblockUI();
                    }
                });
            }
            else {
                showerrormsg('Please Add Test Limit');
                dataItem.splice(0, dataItem.length);
                jQuery.unblockUI();
            }

        }
    </script>
</asp:Content>
