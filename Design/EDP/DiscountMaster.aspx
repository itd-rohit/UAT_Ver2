<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" CodeFile="DiscountMaster.aspx.cs" Inherits="Design_EDP_DiscountMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
         <%: Scripts.Render("~/bundles/MsAjaxJs") %>
        <%: Scripts.Render("~/bundles/Chosen") %>
        <link href="../../App_Style/chosen.css" rel="stylesheet" type="text/css" />
         <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <style type="text/css">
    .multiselect
    {
        width: 100%;
    }
</style>
            <div class="POuter_Box_Inventory" style="text-align: center">               
                        <b>Discount Approval</b><br />
                        <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>                   
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="Purchaseheader">
                   Employee
                </div>
                <table style="text-align: center; width: 100%;border-collapse:collapse" >
                    <tr>
                        <td style="width: 30%; text-align: right">
                        Designation :&nbsp;
                             </td>
                        <td style="text-align: left; width: 70%;" colspan="3">
                       <asp:DropDownList ID="ddlDesignation" Width="286px" runat="server" class="ddlDesignation chosen-select" ClientIDMode="Static" onchange="bindEmployee()" ></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                         <td style="width: 30%; text-align: right">
                             Employee :&nbsp; </td>
                               <td style="text-align: left; width: 70%;" colspan="3">     
                                  <%-- <asp:ListBox ID="lstEmployee" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="280px"></asp:ListBox> --%>
                            <asp:DropDownList ID="ddlEmployee" class="ddlEmployee chosen-select" runat="server" Width="286px" ClientIDMode="Static" onchange="SearchData(1);" >
                               </asp:DropDownList>
                        </td>
                    </tr>                      
                                                                      
                       <tr>
                           <td style="text-align:right; width:30%;">Max Discount Per Month(in Rs.) :&nbsp;</td>
                           <td  style="text-align: left; width: 20%;"><asp:TextBox ID="txtDiscountMonth" Width="100px" runat="server"  MaxLength="15" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                              <cc1:FilteredTextBoxExtender runat="server" ID="ftbDiscMonth"  TargetControlID="txtDiscountMonth" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                           </td>
                           <td  style="width: 23%; text-align:right;">&nbsp; </td> <%--Discount On Package :--%>
                           <td style=" text-align: left;width:30%"><asp:CheckBox ID="chkDiscOnPackage" runat="server" style="display:none;"  Checked="true" ClientIDMode="Static"/>
</td>
                   
                        </tr>
                         <tr >
                           <td style="text-align:right; width:30%;"> Max Discount Per Bill(in %.) :&nbsp;</td>
                             <td style="text-align: left; width: 20%;"><asp:TextBox ID="txtDiscountBill" Width="100px" runat="server"  Text="100" ClientIDMode="Static" onkeyup="chkPer()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender runat="server" ID="ftbDiscBill"  TargetControlID="txtDiscountBill" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                             </td>   
                             <td  style="width: 23%; text-align:right;display:none;"">
                                             Applicable Below Base Rate :&nbsp;    
                                 </td>
                           <td style=" text-align: left;width:30%;display:none;"><asp:CheckBox ID="chkApplicableBelow" runat="server" Checked="true" ClientIDMode="Static"/>
                                </td>
                        </tr>
                      
                                                         
                         <tr>
                           <td style="text-align:right; width:30%;">Share Type :&nbsp;</td>
                             <td c style="text-align: left; width: 20%;"><asp:DropDownList ID="ddlsharetype" runat="server"><asp:ListItem Value="0">Client Share</asp:ListItem><asp:ListItem Value="1">Client Share</asp:ListItem></asp:DropDownList> </td>   
                             <td  style="width: 23%; text-align:right;">
                                             &nbsp;</td>
                           <td style=" text-align: left;width:30%">&nbsp;</td>
                        </tr>
                      
                                                         
                    </table>              
            </div>
         <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre Search &nbsp; &nbsp; 
            </div>
       
<table style="width: 100%; border-collapse: collapse">
    <tr>
        <td style="width: 20%; text-align: right">Business Zone :&nbsp;
        </td>
        <td style="width: 20%; text-align: left">
            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" Width="160px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 20%; text-align: right">State :&nbsp;
        </td>
        <td style="width: 20%; text-align: left">
            <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" Width="160px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 20%; text-align: right">City :&nbsp;
        </td>
        <td style="width: 20%; text-align: left">
            <asp:ListBox ID="lstCity" CssClass="multiselect" SelectionMode="Multiple" Width="160px" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
        <td style="width: 20%; text-align: left">
           
        </td>
    </tr>
    <tr>
        <td style="width: 20%; text-align: right">Centre :&nbsp;
        </td>
        <td  style="width: 20%">
            <asp:ListBox ID="lstCentreLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
        </td>
       <td style="width: 20%; text-align: right">
        </td>
        <td  style="width: 20%">
        </td>
    </tr>
</table>

            </div>
                                              
     <div class="POuter_Box_Inventory" style="text-align:center;">      
            <input type="button" name="Save" onclick="SaveDiscount();"  id="btnSave" value="Save"  class="ItDoseButton"/>                                   
          </div>
     <div class="POuter_Box_Inventory" >
         <div id="div_Discount"   style="text-align:center;max-height:320px; overflow:auto">
                
            </div>
     </div>            
        </div>
    <script type="text/javascript">

        //jQuery(function () {
        //    jQuery('[id*=lstEmployee]').multipleSelect({
        //        includeSelectAllOption: true,
        //        filter: true, keepOpen: false
        //    });
        //});


         </script>  
           <script id="tb_Discount" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdDiscount" 
    style="border-collapse:collapse; width:100%;" >
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Centre ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Centre Code</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Centre Name</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Discounted RateType</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">State</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Employee Name</th>	
             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Max Disc.(Amt.)</th>	
             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Max Disc.(%)</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Remove</th>	

</tr>
       <#      
              var dataLength=SearchEmpData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = SearchEmpData[j];        
            #>
 <tr id="tr_<#=j+1#>">                                      
     <td class="GridViewLabItemStyle"><#=j+1#></td>
     <td id="tdCentreID"  class="GridViewLabItemStyle" style="display:none"><#=objRow.CentreID#></td>
     <td id="tdCentreCode" class="GridViewLabItemStyle" style="text-align:left"><#=objRow.CentreCode#></td>
     <td id="tdCentre" class="GridViewLabItemStyle" style="text-align:left"><#=objRow.Centre#></td>
      <td id="tdPanelName" class="GridViewLabItemStyle" style="text-align:left"><#=objRow.PanelName#></td>
     <td id="tdState"  class="GridViewLabItemStyle" style="text-align:left"><#=objRow.State#></td>
     <td id="tdCity"  class="GridViewLabItemStyle" style="text-align:left"><#=objRow.City#></td>
     <td id="tdEmpName"  class="GridViewLabItemStyle" style="text-align:left"><#=objRow.EmpName#></td>
     <td id="td2"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DiscountPerMonth#></td>
     <td id="td3"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DiscountPerBill_per#></td>
     <td align="center" class="GridViewLabItemStyle"><img id="<#=objRow.CentreID#>#<#=objRow.ID#>#tr_<#=j+1#>" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="RemoveData(this)" /></td>
     <td id="tdDisAppID"  class="GridViewLabItemStyle" style="display:none"><#=objRow.DisAppID#></td>
</tr>
            <#}#>
     </table>    
    </script>
                
      <script type="text/javascript">
          function chkPer() {
              if ($("#txtDiscountBill").val() != "") {
                  if ($("#txtDiscountBill").val() > 100) {
                      alert('Please Enter Valid Percentage');
                      $("#txtDiscountBill").val('');
                      return;
                  }
              }
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
          
           </script>
                
      <script type="text/javascript">
          
           </script>
                
      <script type="text/javascript">
          function SaveDiscount() {
              if ($("#ddlDesignation").val() == "0") {
                  alert('Please Select Designation');
                  $("#ddlDesignation").focus();
                  return;
              }
              if ($("#ddlEmployee").val() == "0") {
                  alert('Please Select Employee');
                  $("#ddlEmployee").focus();
                  return;
              }
             // var empDetail = getEmpDetail();
             
             // if (empDetail.length == 0) {
             //     alert('Please Select Employee');
             //     $("#lstEmployee").focus();
             //     return;
             // }                     
              if ($.trim( $("#txtDiscountMonth").val()) == "" || $.trim($("#txtDiscountMonth").val())==0) {
                  alert('Please Enter Max Discount Per Month(in Rs.)');
                  $("#txtDiscountMonth").focus();
                  return;
              }  
             // $("#txtDiscountBill").val('100');
                  
              if ($.trim($("#txtDiscountBill").val()) == "" || $.trim($("#txtDiscountBill").val()) == 0) {
                  alert('Max Discount Per Bill(in %.)');
                  $("#txtDiscountBill").focus();
                  return;
              }                       
              jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
             var ItemData = "";
             jQuery('#lstCentreLoadList :selected').each(function (i, selected) {
                 if (ItemData == "") {
                     ItemData += jQuery(selected).val();
                 }
                 else {
                     ItemData += '#' + jQuery(selected).val() ;
                 }
             });
             //var CentreLength = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',').length;
             //for (var i = 0; i <= CentreLength - 1; i++) {
             //    ItemData += $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',')[i] + '#';               
             //}                       
             if (ItemData == "") {
                 alert('Please Select Centre');
                 jQuery("#btnSave").removeAttr('disabled').val('Save');
                 return;
             }
             var DiscOnPackage = $("#chkDiscOnPackage").is(':checked') ? 1 : 0;
             var ApplicableBelow = $("#chkApplicableBelow").is(':checked') ? 1 : 0;

           

             PageMethods.InsertData(ItemData, jQuery("#txtDiscountMonth").val(), jQuery("#txtDiscountBill").val(), $("#ddlEmployee").val(),DiscOnPackage,ApplicableBelow, $('#<%=ddlsharetype.ClientID%>').val(),onSuccess, Onfailure);
          }
          function getEmpDetail() {
            //  var dataItem = new Array();
            //  var ObjItem = new Object();
              
            //  jQuery('#lstEmployee :selected').each(function (i, selected) {
            //      ObjItem.EmployeeID = jQuery(selected).val();
            //      dataItem.push(ObjItem);
            //      ObjItem = new Object();
            //  });
             
            //  return dataItem;

          }
          function onSuccess(result) {
              if (result == 1) {
                  jQuery('#lblMsg').text("Record Saved Successfully");
                  SearchData(0);
                   Clear();
                   
              }
              else {
                  jQuery('#lblMsg').text("Record Not Saved Successfully");
              }
              jQuery("#btnSave").removeAttr('disabled').val('Save');
          }
          function Onfailure(result) {
              jQuery('#lblMsg').text("Record Not Saved Successfully");
          }
           </script>
                
      <script type="text/javascript">
          function Clear() {
             // jQuery("ddlDesignation").prop('selectedIndex', 0);
             // jQuery("#lstEmployee option").remove();
              // jQuery('#lstEmployee').multipleSelect("refresh");
           //   jQuery("#lstEmployee").multipleSelect("uncheckAll");
              //   jQuery('#lstEmployee').multipleSelect("refresh");

              jQuery("#ddlDesignation").prop('selectedIndex', 0);
              jQuery("#ddlEmployee option").remove();
              jQuery('#ddlDesignation,#ddlEmployee').trigger('chosen:updated');
              
              jQuery("#txtDiscountMonth,#txtDiscountBill").val('');
              jQuery("#ddlBusinessZone").prop('selectedIndex', 0);
              jQuery("#ddlState option").remove();
              jQuery("#ddlCity option").remove();
              jQuery("#lstCentreLoadList option").remove();
              jQuery('#lstCentreLoadList').multipleSelect("refresh");

              jQuery('#chkDiscOnPackage,#chkApplicableBelow').prop('checked', false);
          }
      function RemoveData(rowID) {
          $.ajax({
              url: "DiscountMaster.aspx/Remove",
              data: '{ DisAppID: "' + jQuery(rowID).closest('tr').find('#tdDisAppID').text() + '"}',
              type: "POST",
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              success: function (result) {
                  if (result.d == 1) {
                      alert('Record Removed Successfully');
                      SearchData(0);
                  }
              },
              error: function (xhr, status) {
                  alert("Error ");
              }
          });
      }     
          function getDiscDetails(EmployeeID) {
              $.ajax({

                  url: "DiscountMaster.aspx/bindEmpDisc",
                  data: "{EmployeeID:'" + EmployeeID + "'}",
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  async: false,
                  success: function (result) {
                      empDiscData = jQuery.parseJSON(result.d);
                      if (empDiscData != null && empDiscData != "") {
                          jQuery('#txtDiscountMonth').val(empDiscData[0].DiscountPerMonth);
                          jQuery('#txtDiscountBill').val(empDiscData[0].DiscountPerBill_per);
                          var PendingDis = parseFloat(empDiscData[0].DiscountPerMonth) - parseFloat(empDiscData[0].DiscountGiven)                         
                      }
                      else {
                          jQuery('#txtDiscountMonth,#txtDiscountBill').val('');
                      }                     
                      SearchData(0);
                  },
                  error: function (xhr, status) {
                      alert("Error ");
                  }
              });
          }        
           </script>
                
      <script type="text/javascript">
   

  </script>
    <script type="text/javascript">
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
        });
        jQuery('#ddlDesignation').trigger('chosen:updated');
    </script>
    <script type="text/javascript">
        function bindEmployee() {
            if (jQuery("#ddlDesignation").val() != 0) {

                PageMethods.bindEmployee(jQuery("#ddlDesignation").val(), onSucessEmp, onFailureEmp);
            }
            else {
                jQuery('#ddlEmployee option').remove();
                jQuery('#ddlEmployee').trigger('chosen:updated');
            }
        }
        function onSucessEmp(result) {
            var EmpData = jQuery.parseJSON(result);
            jQuery('#ddlEmployee option').remove();

            if (EmpData != null) {
                jQuery('#ddlEmployee').append(jQuery("<option></option>").val('0').html('Select'));
                for (i = 0; i < EmpData.length; i++) {
                    jQuery("#ddlEmployee").append(jQuery("<option></option>").val(EmpData[i].Employee_ID).html(EmpData[i].Name));
                }
            }
            jQuery('#ddlEmployee').trigger('chosen:updated');

            //SearchData(1);

        }
        function onFailureEmp(result) {


        }
    </script>
    <script type="text/javascript">
        


        function SearchData(con) {
            if (jQuery("#ddlEmployee").val() != 0)
                PageMethods.Search(jQuery("#ddlEmployee").val(), onSucessSearch, onFailureSearch,con);
            else {
                jQuery('#div_Discount').html('');
                jQuery('#div_Discount').hide();
            }
        }
        function onSucessSearch(result,con) {
            SearchEmpData = jQuery.parseJSON(result);
            jQuery("#txtDiscountMonth,#txtDiscountBill").val('');
            jQuery("#chkDiscOnPackage,#chkApplicableBelow").prop('checked', false);
            if (SearchEmpData.length != 0) {
                var output = jQuery('#tb_Discount').parseTemplate(SearchEmpData);
               
                if (con == 1) {
                    jQuery("#txtDiscountMonth").val(SearchEmpData[0].DiscountPerMonth);
                    jQuery("#ddlsharetype").val(SearchEmpData[0].DiscShareType);
                    jQuery("#txtDiscountBill").val(SearchEmpData[0].DiscountPerBill_per);
                    if (SearchEmpData[0].DiscountOnPackage == 1)
                        jQuery("#chkDiscOnPackage").prop('checked', true);
                    else
                        jQuery("#chkDiscOnPackage").prop('checked', false);
                    if (SearchEmpData[0].AppBelowBaseRate == 1)
                        jQuery("#chkApplicableBelow").prop('checked', true);
                    else
                        jQuery("#chkApplicableBelow").prop('checked', false);
                   
                }
                jQuery('#div_Discount').html(output);
                jQuery('#div_Discount').show();
            }
            else {
                jQuery('#div_Discount').hide();
            }
            
        }
        function onFailureSearch() {



        }
    </script>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstCentreLoadList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
          
            bindZone();
        });
        function bindZone() {
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    BusinessZoneID = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    $('[id*=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        $('#lstZone').on('change', function () {
            jQuery('#<%=lstState.ClientID%> option').remove();
        jQuery('#<%=lstCity.ClientID%> option').remove();
        jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
        jQuery('#lstState').multipleSelect("refresh");
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstCentreLoadList').multipleSelect("refresh");
        var BusinessZoneID = $(this).val();
        bindBusinessZoneWiseState(BusinessZoneID);
    });
    $('#lstState').on('change', function () {
        jQuery('#<%=lstCity.ClientID%> option').remove();
        jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
        jQuery('#lstCity').multipleSelect("refresh");
        jQuery('#lstCentreLoadList').multipleSelect("refresh");
        var BusinessZoneID = $('#lstZone').val();
        var StateID = $(this).val();
        bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID);
    });
    $('#lstCity').on('change', function () {
        jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
        jQuery('#lstCentreLoadList').multipleSelect("refresh");
        var BusinessZoneID = $('#lstZone').val();
        var StateID = $('#lstState').val();
        var CityID = $(this).val();
        bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID);
    });



      


    function bindBusinessZoneWiseState(BusinessZoneID) {
        if (BusinessZoneID != "") {
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState",
                data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    stateData = jQuery.parseJSON(result.d);
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
    function bindBusinessZoneAndStateWiseCity(BusinessZoneID, StateID) {
        if (StateID != "") {
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZoneAndStateWiseCity",
                data: '{ BusinessZoneID: "' + BusinessZoneID + '",StateID: "' + StateID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    for (i = 0; i < CityData.length; i++) {
                        jQuery("#lstCity").append(jQuery("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                    jQuery('[id*=lstCity]').multipleSelect({
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
    function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID) {
        if (CityID != "") {
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindCentreLoad",
                data: '{ BusinessZoneID: "' + BusinessZoneID + '",StateID: "' + StateID + '",CityID: "' + CityID + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    CentreLoadListData = jQuery.parseJSON(result.d);
                    for (i = 0; i < CentreLoadListData.length; i++) {
                        jQuery("#lstCentreLoadList").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                    }
                    jQuery('[id*=lstCentreLoadList]').multipleSelect({
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
