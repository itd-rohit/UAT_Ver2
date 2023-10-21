<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BudgetMaster.aspx.cs" Inherits="Design_Store_BudgetMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

      <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <b>Budget Master</b>
            <br />
            <asp:Label ID="lblError" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 10%">Centre Type :&nbsp;
                    </td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                    <td style="width: 10%">Zone :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                    <td style="width: 10%">State :&nbsp;</td>
                    <td style="width: 26%">
                        <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">Location :&nbsp;</td>
                    <td style="width: 22%">
                     <asp:ListBox ID="lstLocation" CssClass="lstLocation" SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>

                    </td>
                    <td style="width: 10%">Budget Month : </td>
                    <td style="width: 22%">
                          <asp:TextBox ID="txtBudgetMonth" runat="server"  Width="90px" onchange="changeBudgetMonth()" ></asp:TextBox> 
                        <cc1:CalendarExtender ID="calBudgetMonth" ClientIDMode="Static" DefaultView="Months" OnClientShown="onCalendarShown"
                            OnClientHidden="onCalendarHidden"
                             runat="server" TargetControlID="txtBudgetMonth" Format="MMM-yy"></cc1:CalendarExtender>
                        </td>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 26%">
                        &nbsp;</td>
                </tr>
                 <tr>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 22%">
                        <input id="btnMoreFilter" class="ItDoseButton" onclick="showSearch();" style="font-weight: bold;" type="button" value="More Filter" /></td>
                    <td style="width: 12%">&nbsp;</td>
                    <td style="width: 22%">&nbsp;</td>
                    <td style="width: 10%">&nbsp;</td>
                    <td style="width: 24%">&nbsp;</td>
                </tr>
                </table>
             <div class="divSearchInfo" style="display: none;" id="divSearch">
                <div style="width: 1300px; background-color: papayawhip;">
                    <div class="Purchaseheader">
                        Search Option
                    </div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="width: 10%">City :&nbsp;</td>
                            <td style="width: 22%">
                                <asp:TextBox ID="txtCity" runat="server" Width="232px"></asp:TextBox>
                            </td>
                            <td style="width: 12%">&nbsp;</td>
                            <td style="width: 22%">
                                <asp:ListBox ID="lstCity" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                            </td>
                            <td style="width: 10%">
                                <input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />
                            </td>
                            <td style="width: 24%">&nbsp;</td>
                        </tr>
                    </table>
                </div>
            </div>
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <input type="button" id="btnSearch" value="Search" class="searchbutton" onclick="searchData('0')" />&nbsp;&nbsp;
                        <input type="button" id="btnSave" value="Save" class="searchbutton" onclick="saveBudgetData()" style="display:none" />&nbsp;&nbsp;
            
            <span style="background-color: #90EE90; font-weight:bold;font-size:larger" >&nbsp;Budget Set&nbsp;</span>
        </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">  
     <div id="div_Budget"  style="max-height:433px; overflow-y:auto; overflow-x:hidden;">       
        </div>       
   </div>   
        </div>
    <script id="sc_BudgetMaster" type="text/html" >      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbl_Budget" style="border-collapse:collapse;width:1280px;"> 
            <thead>
		<tr id="Header">			
		     <th class="GridViewHeaderStyle" style="width: 34px; text-align: center">S.No.<input type="checkbox" onclick="selectAll()" id="chkALL" checked="checked" class="clChkAll" /></th>
             <th class="GridViewHeaderStyle" style="width: 400px; text-align: center">Location</th>
             <th class="GridViewHeaderStyle" style="width: 90px; text-align: center">Pre. Month Budget</th>
             <th class="GridViewHeaderStyle" style="width: 100px; text-align: center">Pre. Month Budget Amt.</th>
             <th class="GridViewHeaderStyle" style="width: 60px; text-align: center"> Month Budget </th>           
             <th class="GridViewHeaderStyle" style="width: 100px; text-align: center">Budget Amt.
                <input type="checkbox" class="chkBudgetAmt" onclick="chkAllBudgetAmt(this)"/>
                <input type="text"   style="display:none;width:80px" class="clHeaderBudgetAmount" maxlength="9" onkeyup="fillAllBudgetAmount(this.value)"/>
            </th>           
        </tr>                 
                </thead>            
            <tbody>
       <#      
              var dataLength=BudgetData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = BudgetData[j];
                 #>            
           <tr id="<#=j+1#>"  
             <#
                if(objRow.BudgetID!="0")
                {#>
              style="background-color:#90EE90"
                <#}   
                   
                #>   
               
               >        
            <td class="GridViewLabItemStyle" id="tdID"><#=j+1#>
                <#
                if(objRow.BudgetID=="0")
                {#>
             <input type="checkbox" id="chk"   class="clChk" checked="checked"  />
                <#}   
                   
                #>   
                 </td>                                       
            <td  class="GridViewLabItemStyle" id="tdSupplierName" style="text-align:left;"><#=objRow.Location#></td>
               <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.PreMonthBudget#> </td>
               <td  class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.PreMonthBudgetAmt#> </td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><span id="spnBudgetDate"
                 <#
                if(objRow.BudgetID=="0")
                {#>
               class="clBudgetDate" 
                <#}   
                  
                #>   
                > <#=objRow.BudgetDate#> </span></td>
            <td  class="GridViewLabItemStyle" style="text-align:right;">
                <#
                if(objRow.BudgetID=="0")
                {#>
              <input type="text" id="txtBudgetAmount"  class="clBudgetAmount" style="width:90px;text-align:right" maxlength="9" onkeypress='return checkForSecondDecimal(this,event);' />
                <#}  
                else  {#>   
               <span ><#=objRow.BudgetAmount#></span>
                 <#}             
                #>             
                     </td>  
                   
            <td  class="GridViewLabItemStyle" id="tdLocationID" style="text-align:right;display:none"><#=objRow.LocationID#></td> 
               <td  class="GridViewLabItemStyle" id="tdBudgetID" style="text-align:right;display:none"><#=objRow.BudgetID#></td>  
                
            </tr>                  
      <#}#>
            </tbody>
        </table>    
    </script> 

    <script type="text/javascript">
        function chkAllBudgetAmt(rowID) {
            if ($(".chkBudgetAmt").is(':checked'))
                $(".clHeaderBudgetAmount").show();
            else {
                $(".clHeaderBudgetAmount").val('').hide();
                
            }
        }
        function fillAllBudgetAmount(rowID) {
           
            $(".clBudgetAmount").val(rowID);
        
        }

        function selectAll() {
            if ($(".clChkAll").is(':checked')) {
                $(".clChk").prop('checked', 'checked');
            }
            else {
                $(".clChk").prop('checked', false);
            }
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
           
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
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
        function changeBudgetMonth() {
            
            jQuery('.clBudgetDate').text(jQuery('#txtBudgetMonth').val());
        }
    </script>

    <script type="text/javascript">
        function onCalendarHidden() {
            var cal = $find("calBudgetMonth");
            if (cal._monthsBody) {
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        Sys.UI.DomEvent.removeHandler(row.cells[j].firstChild, "click", call);
                    }
                }
            }
        }
        function onCalendarShown() {
            var cal = $find("calBudgetMonth");
            cal._switchMode("months", true);
            if (cal._monthsBody) {
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        Sys.UI.DomEvent.addHandler(row.cells[j].firstChild, "click", call);
                    }
                }
            }
        }
        function call(eventElement) {
            var target = eventElement.target;
            switch (target.mode) {
                case "month":
                    var cal = $find("calBudgetMonth");
                    cal._visibleDate = target.date;
                    cal.set_selectedDate(target.date);
                    //cal._switchMonth(target.date);
                    cal._blur.post(true);
                    cal.raiseDateSelectionChanged();
                    break;
            }
        }
</script>
     <script type="text/javascript">
         function searchData(con) {
             jQuery("#btnSearch").attr('disabled', 'disabled').val('Searching...');
             if (con == 0)
                 jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
             var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
             var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
             var CentreTypeID = jQuery('#lstCentreType').multipleSelect("getSelects").join();
             var LocationID = jQuery('#lstLocation').multipleSelect("getSelects").join();

             jQuery.ajax({
                 url: "BudgetMaster.aspx/bindBudgetMaster",
                 data: '{ CentreTypeID: "' + CentreTypeID + '",ZoneID: "' + ZoneID + '",StateID: "' + StateID + '",LocationID: "' + LocationID + '",BudgetDate:"' + jQuery('#txtBudgetMonth').val() + '"}',
                 type: "POST",
                 timeout: 120000,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                     BudgetData = jQuery.parseJSON(result.d);
                     var output = jQuery('#sc_BudgetMaster').parseTemplate(BudgetData);
                     jQuery('#div_Budget').html(output);
                     jQuery("#div_Budget,#btnSave").show();
                     jQuery("#tbl_Budget").tableHeadFixer({
                     });
                     jQuery("#btnSearch").removeAttr('disabled').val('Search');
                     jQuery.unblockUI();
                 },
                 error: function (xhr, status) {
                     jQuery("#btnSearch").removeAttr('disabled').val('Search');
                     jQuery.unblockUI();
                     alert("Error ");
                 }
             });
         }
         function saveBudgetData() {
             jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
             jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
             var resultBudgetOrder = BudgetMaster();


             if (resultBudgetOrder.chkData.length > 0) {
                 jQuery("#lblError").text('Please Enter Budget Amount In S.No. ' + resultBudgetOrder.chkData);
                 jQuery.each(resultBudgetOrder.chkData, function (index, value) {
                     jQuery('#tbl_Budget tbody tr:eq(' + (value - 1) + ')').find('#txtBudgetAmount').focus();
                     jQuery('#tbl_Budget tbody tr:eq(' + (value - 1) + ')').css("background-color", "#FF0000");
                     jQuery('#tbl_Budget tbody tr:eq(' + (value - 1) + ')').attr('title', 'Please Enter Budget Amount');
                 });
             }
             if (resultBudgetOrder.chkData.length > 0) {
                 jQuery("#btnSave").removeAttr('disabled').val('Save');
                 jQuery.unblockUI();
                 return;
             }
             if (resultBudgetOrder.dataBudgetMaster.length == 0) {
                 showerrormsg("Please Check Location");
                 jQuery("#btnSave").removeAttr('disabled').val('Save');
                 jQuery.unblockUI();
                 return;
             }
             jQuery.ajax({
                 url: "BudgetMaster.aspx/saveBudget",
                 data: JSON.stringify({ BudgetMaster: resultBudgetOrder.dataBudgetMaster }),
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         showerrormsg("Record Saved Successfully");
                         searchData('1');
                     }
                     else if (result.d == "2" || result.d == "0") {
                         showerrormsg("Error...");
                     }
                     else {
                         var POReturnData = jQuery.parseJSON(result.d);

                         if (POReturnData.hasOwnProperty("BudgetAmountValidation")) {
                             jQuery("#lblError").text('Please Enter Valid Budget Amount In S.No. ' + POReturnData.QtyValidation);
                             for (var i in POReturnData.QtyValidation) {
                                 jQuery('#tbl_Budget tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().find('#txtBudgetAmount').focus();
                                 jQuery('#tbl_Budget tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().css("background-color", "#FF0000");
                                 jQuery('#tbl_Budget tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().attr('title', 'Please Enter Budget Amount');
                             }

                         }
                        
                     }
                     jQuery("#btnSave").removeAttr('disabled').val('Save');
                     jQuery.unblockUI();
                 },
                 error: function (xhr, status) {
                     jQuery.unblockUI();
                 }
             });



         }
             function BudgetMaster() {
                 var dataBudgetMaster = new Array();
                 var objBudgetMaster = new Object();
                 var chkData = [];
                 jQuery("#tbl_Budget tr").each(function () {
                     var id = jQuery(this).attr("id");
                     var $rowid = jQuery(this).closest("tr");

                     if (id != "Header") {
                         if ($rowid.find("#chk").is(':checked')) {
                             var ItemData = [];

                             if (jQuery.trim($rowid.find("#txtBudgetAmount").val()) == "") {
                                 $rowid.find("#txtBudgetAmount").focus();
                                 ItemData[0] = jQuery.trim(jQuery(this).find('#tdID').text());
                                 chkData.push(ItemData);
                                 return "";
                             }
                             objBudgetMaster.tableSNo = jQuery.trim($rowid.find("#tdID").text());
                             objBudgetMaster.BudgetAmount = jQuery.trim($rowid.find("#txtBudgetAmount").val());
                             objBudgetMaster.BudgetDate = "".concat("01-", jQuery.trim($("#txtBudgetMonth").val()));
                             objBudgetMaster.LocationID = jQuery.trim($rowid.find("#tdLocationID").text());
                         
                             dataBudgetMaster.push(objBudgetMaster);
                             objBudgetMaster = new Object();
                         }
                     }
                 });
                 return {
                     chkData: chkData,
                     dataBudgetMaster: dataBudgetMaster
                 };

             }
         
          </script>
    <script type="text/javascript">
        function showSearch() {
            jQuery('.divSearchInfo').slideToggle("slow", "linear");
            jQuery('#divSearch').show();
            jQuery('#btnMoreFilter').hide();
            jQuery("#ddlCity_chosen").width("190px");
        }
        function hideSearch() {
            jQuery('.divSearchInfo').slideToggle("slow", "linear");
            jQuery('#divSearch').hide();
            jQuery('#btnMoreFilter').show();
            jQuery('#<%=lstCity.ClientID%> option').remove();
            jQuery('#lstCity').multipleSelect("refresh");
        }
    </script>
     <script type="text/javascript">
         jQuery(function () {
             jQuery('[id*=lstCentreType],[id*=lstZone],[id*=lstState],[id*=lstCity],[id*=lstLocation]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             bindcenterType();
             bindZone();
         });
    </script>
     <script type="text/javascript">
         function showerrormsg(msg) {
             jQuery('#msgField').html('');
             jQuery('#msgField').append(msg);
             jQuery(".alert").css('background-color', 'red');
             jQuery(".alert").removeClass("in").show();
             jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         jQuery(function () {
             jQuery('#txtCity').bind("keydown", function (event) {
                 if (event.keyCode === jQuery.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 if (jQuery('#lstState').multipleSelect("getSelects").join() == "") {
                     showerrormsg("Please Select State");
                     jQuery('#lstState').focus();
                     jQuery('#txtCity').val('');
                     return;
                 }
             })
                   .autocomplete({
                       autoFocus: true,
                       source: function (request, response) {
                           jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindCityWithState", {
                               StateID: jQuery('#lstState').multipleSelect("getSelects").join(),
                               CityName: request.term
                           }, response);
                       },
                       search: function () {
                           // custom minLength                    
                           var term = this.value;
                           if (term.length < 3) {
                               return false;
                           }
                       },
                       focus: function () {
                           // prevent value inserted on focus
                           return false;
                       },
                       select: function (event, ui) {
                           if (jQuery("#lstCity option[value='" + ui.item.value + "']").length == 0) {
                               jQuery("#lstCity").append(jQuery("<option></option>").val(ui.item.value).html(ui.item.label));
                               jQuery('#lstCity').find(":checkbox[value='" + ui.item.value + "']").attr("checked", "checked");
                               jQuery("#lstCity option[value='" + ui.item.value + "']").attr("selected", 1);
                               jQuery('#lstCity').multipleSelect("refresh");
                           }
                           else {
                               showerrormsg("City Already Added");
                           }
                           jQuery('#txtCity').val('');
                           return false;
                       },
                   });
         });
    </script>
    <script type="text/javascript">
        function bindcenterType() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            CommonServices.bindTypeLoad(onSucessCentreType, onFailureCentreType);
        }
        function onSucessCentreType(result) {
            var typedata = jQuery.parseJSON(result);
            for (var a = 0; a <= typedata.length - 1; a++) {
                jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].id).html(typedata[a].type1));
            }
            jQuery('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

        }
        jQuery('#lstCentreType').on('change', function () {
            jQuery('#<%=lstLocation.ClientID%> option').remove();
            jQuery('#lstLocation').multipleSelect("refresh");
            bindLocation();
        });
        function onFailureCentreType() {

        }
        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            CommonServices.bindBusinessZone(onSucessBusinessZone, onFailureBusinessZone);

        }
        function onSucessBusinessZone(result) {
            var BusinessZoneID = jQuery.parseJSON(result);
            for (i = 0; i < BusinessZoneID.length; i++) {
                jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
            }
            jQuery('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

        }
        function onFailureBusinessZone() {

        }
        jQuery('#lstZone').on('change', function () {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            var BusinessZoneID = $(this).val();
            bindState(BusinessZoneID);
            bindLocation();
        });
        function bindState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }
        jQuery('#lstState').on('change', function () {
            jQuery('#<%=lstLocation.ClientID%> option').remove();
            jQuery('#lstLocation').multipleSelect("refresh");
            bindLocation();
        });
        function bindLocation() {
            var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
            var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
            var CentreTypeID = jQuery('#lstCentreType').multipleSelect("getSelects").join();
            var CityID = jQuery('#lstCity').multipleSelect("getSelects").join();
            jQuery('#<%=lstLocation.ClientID%> option').remove();
            jQuery('#lstLocation').multipleSelect("refresh");
            if (ZoneID != "" || StateID != "" || CentreTypeID != "") {
                jQuery.ajax({
                    url: "BudgetMaster.aspx/bindLocation",
                    data: '{ CentreTypeID: "' + CentreTypeID + '",ZoneID: "' + ZoneID + '",StateID: "' + StateID + '",CityID:"' + CityID + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var LocationData = jQuery.parseJSON(result.d);
                        for (i = 0; i < LocationData.length; i++) {
                            jQuery("#lstLocation").append(jQuery("<option></option>").val(LocationData[i].LocationID).html(LocationData[i].Location));
                        }
                        jQuery('[id*=lstLocation]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }
    </script>
</asp:Content>

