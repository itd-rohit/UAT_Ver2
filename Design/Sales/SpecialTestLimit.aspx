<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="SpecialTestLimit.aspx.cs" Inherits="Design_Sales_SpecialTestLimit" %>

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
                <b>Special Test Amount Limit Master</b>
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

            jQuery('#mtable thead,#mtable tbody').html('');
            PageMethods.bindSalesHierarchy(jQuery("#rblEntryType input[type=radio]:checked").next().text(),onSuccessSalesHierarchy, OnfailureSalesHierarchy);
        }
       

        function onSuccessSalesHierarchy(result) {
            var tbl_body = ""; var tbl_head = "";
            var tbl_hrow = "";
            var data = jQuery.parseJSON(result);
            var count = 0;
            jQuery.each(data, function () {
                var tbl_row = "";
                jQuery.each(this, function (k, v) {
                    if (k == 'ItemName' || k == 'BaseRate' || k == 'ItemID') {
                        if (k == 'ItemID') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>";
                        }
                        else if (k == 'ItemName') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:180px'>" + v + "</td>";
                        }
                        else {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:60px;text-align:right'>" + v + "</td>";
                        }
                    }
                    else {
                        if (v == null)
                            v = '#';
                        var testLimit = v.split('#');
                       
                            tbl_row += "<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><input type='text' style='width:70px' id='" + k.substr(k.indexOf('#') + 1) + "' class='testValue' value='" + testLimit[0] + "'/></td>";


                    }
                    if (k == 'ItemName') {
                        count = count + 1;
                    }
                    if (count == 1) {
                        if (k == 'ItemName' || k == 'BaseRate' || k == 'ItemID') {
                            if (k == 'ItemID') {
                                tbl_hrow += "<td style='width:150px; display: none;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else if (k == 'ItemName') {
                                tbl_hrow += "<td style='width:180px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else {
                                tbl_hrow += "<td style='width:60px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                        }
                        else {
                            tbl_hrow += "<td style='width:80px;' class='GridViewHeaderStyle " + k.substr(k.indexOf('#') + 1) + "'>" + k + "</td>";
                        }
                    }
                });
              
                tbl_body += "<tr>" + tbl_row + "</tr>";
            });
            tbl_head = "<tr>" + tbl_hrow + "</tr>";
            jQuery("#mtable thead").html(tbl_head);
            jQuery("#mtable tbody").html(tbl_body);

            jQuery.unblockUI();

        }
        function OnfailureSalesHierarchy(result) {
            jQuery.unblockUI();

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
    </script>
    <script type="text/javascript">
        function saveTestLimit() {
            var isEmptyValue = 0;
            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                jQuery(this).find('td').find(".testValue").each(function () {

                    var testValue = jQuery.trim(jQuery(this).closest('td').find(".testValue").val());
                    if (testValue == "") {
                        showerrormsg('Please Enter Rate');
                        jQuery(this).closest('td').find(".testValue").focus();
                        isEmptyValue = 1;
                        return;
                    }
                    var testValue1 = jQuery(this).closest('td').next('td').find(".testValue").val();
                   
                    if (testValue1 != 'undefined') {
                    
                        if (parseFloat(testValue) < parseFloat(testValue1)) {
                            showerrormsg('Please Enter Valid Rate');
                            jQuery(this).closest('td').next('td').find(".testValue").focus();
                            isEmptyValue = 1;
                            return;
                        }
                    }
                    if (isEmptyValue == 1) {
                        return;
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
                var specialTestID = parseInt($tds.eq(0).text());
                var basicRate = parseFloat($tds.eq(2).text());
                jQuery(".testValue", this).each(function () {

                    var SalesID = parseInt($(this).attr('id'));
                    var testRate = this.value;
                    if (testRate.length != 0 && testRate.length != '' && testRate != 'null') {

                        item.specialTestID = specialTestID;
                        item.basicRate = basicRate;
                        item.SalesID = SalesID;
                        item.testRate = testRate;
                        dataItem.push(item);
                        item = new Object();
                    }
                });


            });
            if (dataItem.length > 0) {
                jQuery.ajax({
                    type: "POST",
                    url: "SpecialTestLimit.aspx/saveTestLimit",
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

