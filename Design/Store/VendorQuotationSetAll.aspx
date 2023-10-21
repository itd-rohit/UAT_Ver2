<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorQuotationSetAll.aspx.cs" Inherits="Design_Store_VendorQuotationSetAll" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Supplier Quotation Set All</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
             <div id="makerdiv" >

             <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                      Supplier  Detail</div>

                   <table width="99%" >
                       <tr>
                           <td class="required">Supplier Name :</td>
                           <td>
                           <asp:DropDownList ID="ddlsupplier" runat="server" class="ddlsupplier chosen-select chosen-container" Width="300px" onchange="setvendordata()">

                           </asp:DropDownList>

                                <span id="QuotationID" style="display: none;"></span>
                           </td>

                           <td>
                              Address :
                           </td>
                           <td colspan="3">
                               <asp:TextBox ID="txtaddress" runat="server" Width="706px" ReadOnly="true"></asp:TextBox>
                           </td>

                       </tr>
                       <tr>
                           <td>Vendor State :</td>
                           <td>
                               <asp:DropDownList ID="ddlstate" runat="server" Width="300px" onchange="setgstndata()"></asp:DropDownList>
                               
                           </td>

                           <td>
                               GSTN No :</td>
                           <td>
                                <asp:TextBox ID="txtgstnno" runat="server" Width="294px" ReadOnly="true"></asp:TextBox>
                           </td>

                           <td>&nbsp;</td>
                           <td>

                               &nbsp;</td>
                       </tr>
                       <tr style="display:none;">
                           <td>Delivery State :</td>
                           <td>
                              <asp:DropDownList ID="ddlcentrestate" runat="server" Width="300px"  /></td>

                        

                           <td>Centre :</td>
                           <td>

                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                           </td>
                       </tr>
                       <tr>
                     

                           <td>
                               From Date :</td>
                           <td>

                                <asp:TextBox ID="txtentrydate" runat="server" Width="110px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                           &nbsp;To Date:<asp:TextBox ID="txtentrydateto" runat="server" Width="110px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="txtentrydate0_CalendarExtender0" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                           </td>

                           <td>Ref No :</td>
                           <td>

                              <asp:TextBox ID="txtquationrefno" runat="server" Width="114px"></asp:TextBox>
                               
                           </td>
                       </tr>
                     


                        <tr>
                           <td colspan="6">
                               <div class="Purchaseheader">Location  Details</div>
                           </td>
                       </tr>
                        <tr>
                           <td>
                               Centre Type:</td>
                           <td>

                                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                           </td>

                            <td>Delivery Location :</td>
                           <td>

                                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static"></asp:ListBox>
                           </td>
                           </tr>


                       <tr>
                           <td colspan="6">
                               <div class="Purchaseheader">Item Detail</div>
                           </td>
                       </tr>
                         <tr>
                           <td> Machine :</td>
                           <td colspan="3">
                               <asp:DropDownList ID="ddlmachineall" runat="server" Width="400px"></asp:DropDownList>

                               <input type="button" value="Add All Item" class="searchbutton" onclick="AddAllitem()" />
                           </td>
                       </tr>
                       <tr style="display:none;">
                           <td>Item :</td>
                           <td>
 
 
  <input id="txtitem" style="width:300px;text-transform:uppercase;" /></td>

                           <td>
                               Item :</td>
                           <td>
                                 <asp:Label ID="lblItemName" runat="server"></asp:Label>
                               <asp:Label ID="lblItemGroupID" runat="server" style="display:none;"></asp:Label>
                               <asp:Label ID="lblItemID" runat="server" style="display:none;"></asp:Label>
                           </td>

                           <td>
                             
                               &nbsp;</td>
                           <td>
                             
                               &nbsp;</td>
                       </tr>
                       
                       <tr style="display:none;">
                           <td>Manufacturer :</td>
                           <td>
                             
                               <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');" Width="300px">
                               </asp:DropDownList>
                           </td>

                           <td>
                               Machine :</td>
                           <td>
                                 <asp:DropDownList ID="ddlMachine" runat="server" Width="300px" onchange="bindTempData('PackSize');"></asp:DropDownList>
                           </td>

                           <td>
                             
                               Pack Size :</td>
                           <td>
                             
                                <asp:DropDownList ID="ddlPackSize" runat="server" Width="100px" onchange="setDataAfterPackSize();" ></asp:DropDownList>
                             
                               <input type="button" class="searchbutton" value="Add" onclick="AddItem()" /></td>
                       </tr>

                       
                       
                      
                       
                       
                       </table>
                   </div>
                 </div>
               
                  <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                     Added Item</div>
                   <div style="width:100%;max-height:200px;overflow:auto;">
                   <table id="tblQuotation" style="border-collapse:collapse">
                                     <tr id="trquuheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Item Category</td>
                                        <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Hsn Code</td>
                                        <td class="GridViewHeaderStyle">Manufacturer</td>
                                        <td class="GridViewHeaderStyle">Catalog No</td>
                                        <td class="GridViewHeaderStyle">Machine</td>
                                        <td class="GridViewHeaderStyle">Purchased Unit</td>
                                        <td class="GridViewHeaderStyle">Pack Size</td>
                                        <td class="GridViewHeaderStyle">Consumption Unit</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">Quantity</td>
                                        <td class="GridViewHeaderStyle">Rate   <input type="text" class="allrate" style="width:56px;" id="ratehead" onkeyup="SetAllRate(this);" /></td>
                                        <td class="GridViewHeaderStyle">Discount %</td>
                                        <td class="GridViewHeaderStyle">TAX %</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">CGST %</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">SGST %</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">Total GST %</td>
                                        
                                        <td class="GridViewHeaderStyle" style="display:none;">Discount Amount</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">Total GST Amount</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">BuyPrice</td>
                                        <td class="GridViewHeaderStyle" style="display:none;">Net Amt</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                          
                                     </tr>
                                 </table> 
                   </div>
                   </div>
                      </div>  
                 

                

                 
                   


                  <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                   <input type="button" value="Save" class="savebutton" onclick="savedata();" id="btnsave" />
                   <input type="button" value="Update" class="savebutton" onclick="updateitem();" id="btnupdate" style="display:none;" />
                   <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                   </div>
               </div>

         </div>
         

         </div>

         <script type="text/javascript">




             $(function () {

                 

                 $('[id*=lstCentreType]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id*=lstlocation]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });


                 bindcentertype();


             });


             function bindcentertype() {
                 jQuery('#<%=lstCentreType.ClientID%> option').remove();
                 jQuery('#lstCentreType').multipleSelect("refresh");
                 $.ajax({
                     url: "StoreLocationMaster.aspx/bindcentertype",
                     data: '{}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         typedata = jQuery.parseJSON(result.d);
                         for (var a = 0; a <= typedata.length - 1; a++) {
                             jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                         }

                         jQuery('[id*=lstCentreType]').multipleSelect({
                             includeSelectAllOption: true,
                             filter: true, keepOpen: false
                         });
                     },
                     error: function (xhr, status) {
                     }
                 });
             }

            


                

             function bindlocation() {

                

            var TypeId = jQuery('#lstCentreType').val();
           

         
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery.ajax({
                url: "VendorQuotationSetAll.aspx/bindlocation",
                data: '{TypeId:"' + TypeId + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstlocation").append(jQuery("<option></option>").val(centreData[i].LocationID).html(centreData[i].Location));
                    }
                    $('[id*=lstlocation]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }



            



             function showmsg(msg) {
                 $('#msgField').html('');
                 $('#msgField').append(msg);
                 $(".alert").css('background-color', '#04b076');
                 $(".alert").removeClass("in").show();
                 $(".alert").delay(1500).addClass("in").fadeOut(1000);
             }
             function showerrormsg(msg) {
                 $('#msgField').html('');
                 $('#msgField').append(msg);
                 $(".alert").css('background-color', 'red');
                 $(".alert").removeClass("in").show();
                 $(".alert").delay(1500).addClass("in").fadeOut(1000);
             }


             var approvaltypemaker = '<%=approvaltypemaker %>';
             var approvaltypechecker = '<%=approvaltypechecker %>';
             var approvaltypeapproval = '<%=approvaltypeapproval %>';
             $(document).ready(function () {


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
                 bindvendor();



                 if (approvaltypemaker == "1") {
                     $('#makerdiv').show();
                 }
                 else {
                     $('#makerdiv').hide();
                 }

             });

             function bindvendor() {
                 var dropdown = $("#<%=ddlsupplier.ClientID%>");
                 $("#<%=ddlsupplier.ClientID%> option").remove();
                 $.ajax({
                     url: "Services/StoreCommonServices.asmx/bindsupplier",
                     data: '{}', // parameter map 
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         PanelData = $.parseJSON(result.d);
                         if (PanelData.length == 0) {
                             dropdown.append($("<option></option>").val("0").html("--No Supplier Found--"));
                         }
                         else {
                             dropdown.append($("<option></option>").val("0").html("Select Supplier"));
                             for (i = 0; i < PanelData.length; i++) {
                                 dropdown.append($("<option></option>").val(PanelData[i].supplierid).html(PanelData[i].suppliername));
                             }
                         }
                         dropdown.trigger('chosen:updated');

                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }








             function setvendordata() {
                 var dropdown = $("#<%=ddlstate.ClientID%>");
                 $("#<%=ddlstate.ClientID%> option").remove();
                 $('#<%=txtaddress.ClientID%>').val('');
                 $('#<%=txtgstnno.ClientID%>').val('');
                 $.ajax({
                     url: "Services/StoreCommonServices.asmx/bindvendorgstndata",
                     data: '{vendorid:"' + $('#<%=ddlsupplier.ClientID%>').val() + '"}', // parameter map 
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         PanelData = $.parseJSON(result.d);
                         if (PanelData.length == 0) {
                             $("#<%=ddlstate.ClientID%> option").remove();
                         }
                         else {
                             if (PanelData.length > 1) {
                                 dropdown.append($("<option></option>").val("0").html("Select State"));
                             }
                             $('#<%=txtaddress.ClientID%>').val(PanelData[0].address);

                             for (i = 0; i < PanelData.length; i++) {
                                 dropdown.append($("<option></option>").val(PanelData[i].stateid).html(PanelData[i].state));
                             }
                             if (PanelData.length == 1) {
                                 setgstndata();
                             }
                         }


                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }

             function setgstndata() {
                 if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                     $('#<%=txtgstnno.ClientID%>').val('');
                 }
                 else {
                     $('#<%=txtgstnno.ClientID%>').val($('#<%=ddlstate.ClientID%>').val().split('#')[1]);
                 }
             }



             function getquotationdataterm() {

                 var podetailterm = [];

                 $('#tblterms tr').each(function () {
                     if ($(this).attr("id") != "termsheader") {
                         var Podetailtc = new Object();



                         podetailterm.push($(this).find("#tdterm").html());

                     }
                 });

                 return podetailterm;
             }
         </script>

 

   

         <script type="text/javascript">
             function savedata() {
                
                 if (validation() == false) {
                     return;
                 }

                 var quotationData = getquotationdata();
                 var quotationdataterm = getquotationdataterm();
                 var aa = JSON.stringify({ quotationdata: quotationData });
                 $("#btnsave").attr('disabled', true).val("Submiting...");
                 $.blockUI();
                 $.ajax({
                     url: "VendorQuotationSetAll.aspx/SaveVendorQuotation",
                     data: JSON.stringify({ quotationdata: quotationData }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         $.unblockUI();
                         var save = result.d;
                         if (save.split('#')[0] == "1") {

                             $('#btnsave').attr('disabled', false).val("Save");
                             clearForm();
                             showmsg("Quotation No: " + save.split('#')[1]);
                             window.open('VendorQutReport.aspx?QutationNo=' + save.split('#')[1]);
                           



                         }
                         else {
                             $.unblockUI();
                             showerrormsg(save.split('#')[1]);
                             $('#btnsave').attr('disabled', false).val("Save");
                             // console.log(save);
                         }
                     },
                     error: function (xhr, status) {
                         showerrormsg("Some Error Occure Please Try Again..!");
                         $('#btnsave').attr('disabled', false).val("Save");
                         console.log(xhr.responseText);
                     }
                 });
             }

             function clearForm() {
                 $('#QuotationID').html('');
                 $('#btnsave').show();
                 $('#btnupdate').hide();
                 $('#<%=ddlsupplier.ClientID%>').prop('selectedIndex', 0);
                 $("#<%=ddlstate.ClientID%> option").remove();
                 var dropdown = $("#<%=ddlsupplier.ClientID%>");
                 dropdown.attr("disabled", false);
                 dropdown.trigger('chosen:updated');
                 var dropdown2 = $("#<%=ddlstate.ClientID%>");
                 dropdown2.attr("disabled", false);

                 $('#<%=txtaddress.ClientID%>').val('');
                 $('#<%=txtgstnno.ClientID%>').val('');
                 $('#<%=txtquationrefno.ClientID%>').val('');

                 $('#tblQuotation tr').slice(1).remove();
                 $('#tblterms tr').slice(1).remove();
                 var date = new Date();
                 var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
					"Aug", "Sep", "Oct", "Nov", "Dec"];

                 var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
                 $('#<%=txtentrydate.ClientID%>').val('');
                 $('#<%=txtentrydateto.ClientID%>').val('');


                 jQuery('#lstlocation').multipleSelect("enable");
                 jQuery('#lstCentreType').multipleSelect("enable");
    


                 jQuery('#<%=lstlocation.ClientID%> option').remove();
                 jQuery('#lstlocation').multipleSelect("refresh");

                 jQuery('#<%=lstCentreType.ClientID%> option').remove();
                 jQuery('#lstCentreType').multipleSelect("refresh");

              

             }


             function validation() {
                 if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                        showerrormsg("Please Select Supplier..!");
                        $('#<%=ddlsupplier.ClientID%>').focus();
                        return false;
                    }
                    var length = $('#<%=ddlstate.ClientID%> > option').length;
                    if (length == 0) {
                        showerrormsg("No State Found For Supplier..!");
                        $('#<%=ddlstate.ClientID%>').focus();
                        return false;
                    }
                    if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                        showerrormsg("Please Select State For Supplier..!");
                        $('#<%=ddlstate.ClientID%>').focus();
                        return false;
                    }

                    if ($('#<%=txtentrydate.ClientID%>').val() == "") {
                        showerrormsg("Please Select From Date..!");
                        $('#<%=txtentrydate.ClientID%>').focus();
                        return false;
                    }
                    if ($('#<%=txtentrydateto.ClientID%>').val() == "") {
                        showerrormsg("Please Select To Date..!");
                        $('#<%=txtentrydateto.ClientID%>').focus();
                        return false;
                    }

                    var count = $('#tblQuotation tr').length;
                    if (count == 0 || count == 1) {
                        showerrormsg("Please Select Item To set Quotation ");

                        return false;
                    }

                    var sn = 0;
                    $('#tblQuotation tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "trquuheader") {
                            var rate = $(this).find('#txtRate').val() == "" ? 0 : parseFloat($(this).find('#txtRate').val());


                            if (rate == 0) {
                                sn = 1;
                                $(this).find('#txtRate').focus();
                                return;
                            }
                        }
                    });

                    if (sn == 1) {
                        showerrormsg("Please Enter Rate ");
                        return false;
                    }

                    var sn1 = 0;
                    $('#tblQuotation tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "trquuheader") {
                            var qty = $(this).find('#txtQuantity').val() == "" ? 0 : parseFloat($(this).find('#txtQuantity').val());
                            if (qty == 0) {
                                sn1 = 1;
                                $(this).find('#txtQuantity').focus();

                                return;
                            }
                        }
                    });

                    if (sn1 == 1) {
                        showerrormsg("Please Enter Quantity ");
                        return false;
                    }



                    return true;
                }




             function CalBuyPrice(ctrl) {
               
                 $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));


                 var Quantity = $(ctrl).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtQuantity").val());

                 var Rate = $(ctrl).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtRate").val());
                 var Disc = $(ctrl).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtDiscountper").val());
                 if (Disc > 100) {
                     $(ctrl).closest("tr").find("#txtDiscountper").val('100');
                     Disc = 100;
                 }
                 


             }


             function precise_round(num, decimals) {
                 return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
             }


         </script>
         

         <script type="text/javascript">
             function getquotationdata() {
                 var dataIm = new Array();
                 var LocationID = jQuery("#lstlocation").val();
              
                 for (var i = 0; i < LocationID.length; i++) {
                     $('#tblQuotation tr').each(function () {
                         var id = $(this).closest("tr").attr("id");
                         if (id != "trquuheader") {
                           
                             var objQuotation = new Object();
                             objQuotation.Qutationno = $('#QuotationID').html();
                             objQuotation.Quotationrefno = $('#<%=txtquationrefno.ClientID%>').val();
                             objQuotation.VendorId = $('#<%=ddlsupplier.ClientID%>').val();
                             objQuotation.VendorName = $('#<%=ddlsupplier.ClientID%> option:selected').text();
                             objQuotation.VendorAddress = $('#<%=txtaddress.ClientID%>').val();
                             objQuotation.VendorStateId = $('#<%=ddlstate.ClientID%>').val().split('#')[0];
                             objQuotation.VednorStateName = $('#<%=ddlstate.ClientID%> option:selected').text();
                             objQuotation.VednorStateGstnno = $('#<%=txtgstnno.ClientID%>').val();
                             objQuotation.EntryDateFrom = $('#<%=txtentrydate.ClientID%>').val();
                             objQuotation.EntryDateTo = $('#<%=txtentrydateto.ClientID%>').val();
                             objQuotation.DeliveryStateID = LocationID[i].split("#")[3].toString();// $('#<%=ddlcentrestate.ClientID%>').val();
                             objQuotation.DeliveryStateName = LocationID[i].split("#")[4].toString();//$('#<%=ddlcentrestate.ClientID%> option:selected').text();
                             objQuotation.DeliveryCentreID = LocationID[i].split("#")[1].toString();
                             objQuotation.DeliveryCentreName = LocationID[i].split("#")[2].toString();
                             objQuotation.DeliveryLocationID = LocationID[i].split("#")[0].toString();
                             objQuotation.DeliveryLocationName = LocationID[i].split("#")[5].toString();
                             objQuotation.ItemCategoryID = $(this).closest("tr").find("#tditemtypeid").html();
                             objQuotation.ItemCategoryName = $(this).closest("tr").find("#tdItemCategory").html();
                             objQuotation.ItemID = $(this).closest("tr").find("#tdItemid").html();
                             objQuotation.ItemName = $(this).closest("tr").find("#tdItemName").html();
                             objQuotation.HSNCode = $(this).closest("tr").find("#tdhsncode").html();
                             objQuotation.ManufactureID = $(this).closest("tr").find("#tdManufactureID").html();
                             objQuotation.ManufactureName = $(this).closest("tr").find("#tdManufactureName").html();
                             objQuotation.MachineID = $(this).closest("tr").find("#tdMachineID").html();
                             objQuotation.MachineName = $(this).closest("tr").find("#tdMachineName").html();
                             objQuotation.Rate = $(this).closest("tr").find("#txtRate").val();
                             objQuotation.Qty = $(this).closest("tr").find("#txtQuantity").val();
                             objQuotation.DiscountPer = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                             if (LocationID[i].split("#")[3].toString() == $('#<%=ddlstate.ClientID%>').val().split('#')[0].toString()) {
                                 var taxdata = $(this).closest("tr").find("#txtTotalGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGST").val());
                                 objQuotation.SGSTPer = taxdata / 2;
                                 objQuotation.CGSTPer = taxdata / 2;
                                 objQuotation.IGSTPer = 0;
                             }
                             else {

                                 objQuotation.IGSTPer = $(this).closest("tr").find("#txtTotalGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGST").val());
                                 objQuotation.SGSTPer =0;
                                objQuotation.CGSTPer =0;
                             }
                         
                             objQuotation.ConversionFactor = $(this).closest("tr").find("#tdPackSize").html();
                             objQuotation.PurchasedUnit = $(this).closest("tr").find("#tdMajorUnitName").html();
                             objQuotation.ConsumptionUnit = $(this).closest("tr").find("#tdMinorUnitName").html();

                             //calculation

                             var Quantity = $(this).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtQuantity").val());

                             var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                             var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                             if (Disc > 100) {
                                 $(this).closest("tr").find("#txtDiscountper").val('100');
                                 Disc = 100;
                             }

                             var Tax = objQuotation.IGSTPer == 0 ? (objQuotation.SGSTPer + objQuotation.CGSTPer) : objQuotation.IGSTPer;

                             var disc = precise_round((Rate * Disc * 0.01), 5);
                             var ratedisc = precise_round((Rate - disc), 5);
                             var tax = precise_round((ratedisc * Tax * 0.01), 5);
                             var ratetaxincludetax = precise_round((ratedisc + tax), 5);

                             var discountAmout = precise_round(disc, 5);
                             var TaxAmount = precise_round(tax, 5);



                             $(this).closest("tr").find("#txtDiscountAmount").val(discountAmout);

                             $(this).closest("tr").find("#txtTotalGSTAmount").val(TaxAmount);


                             $(this).closest("tr").find("#txtBuyPrice").val(ratetaxincludetax);

                             var NetAmount = precise_round((($(this).closest("tr").find("#txtBuyPrice").val()) * Quantity), 5);

                             $(this).closest("tr").find("#txtNetAmt").val(NetAmount);





                             objQuotation.BuyPrice = $(this).closest("tr").find("#txtBuyPrice").val();
                     
                             objQuotation.FreeQty = $(this).closest("tr").find("#txtFreeQty").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtFreeQty").val());

                             objQuotation.DiscountAmt = $(this).closest("tr").find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountAmount").val());
                             objQuotation.GSTAmount = $(this).closest("tr").find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGSTAmount").val());
                             objQuotation.FinalPrice = $(this).closest("tr").find("#txtNetAmt").val();

                             objQuotation.IsActive = "1";

                             dataIm.push(objQuotation);
                         }
                     });
                 }

                         return dataIm;
                     }


                   
         </script>

    

   
 
    <script type="text/javascript">

        function AddAllitem() {

            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                showerrormsg("Please Select Supplier..!");
                $('#<%=ddlsupplier.ClientID%>').focus();
                return;
            }
            var length = $('#<%=ddlstate.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No State Found For Supplier..!");
                $('#<%=ddlstate.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                showerrormsg("Please Select State For Supplier..!");
                $('#<%=ddlstate.ClientID%>').focus();
                return false;
            }





            if ($('#<%=ddlmachineall.ClientID%>').val() == "0") {
                showerrormsg("Please Select Machine...!");
                $('#<%=ddlmachineall.ClientID%>').focus();
                return;
            }


            $.blockUI();
            $.ajax({
                url: "VendorQuotationSetAll.aspx/getitemdetailtoaddall",
                data: '{machine:"' + $('#<%=ddlmachineall.ClientID%>').val() + '",locationidfrom:"' + jQuery('#lstlocation').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("Data Not Found.!");
                        $.unblockUI();
                        return;
                    }
                    else {

                        for (var i = 0; i <= PanelData.length - 1; i++) {

                            var id = PanelData[i].Itemid;

                            if ($('table#tblQuotation').find('#' + id).length > 0) {
                                showerrormsg("Data Already Added");
                                $.unblockUI();
                                return;
                            }
                            var a = $('#tblQuotation tr').length - 1;
                            var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + id + '>';

                            mydata += '<td  align="left" >' + parseFloat(a + 1) + '</td>';
                            mydata += '<td align="left" id="tdItemCategory">' + PanelData[i].ItemCategory + '</td>';
                            mydata += '<td align="left" id="tdItemid1" style="font-weight:bold;">' + PanelData[i].Itemid + '</td>';
                            mydata += '<td align="left" id="tdItemName">' + PanelData[i].ItemName + '</td>';
                            mydata += '<td align="left" id="tdhsncode">' + PanelData[i].hsncode + '</td>';
                            mydata += '<td align="left" id="tdManufactureName">' + PanelData[i].ManufactureName + '</td>';
                            mydata += '<td align="left" id="tdcatalogno">' + PanelData[i].catalogno + '</td>';
                            mydata += '<td align="left" id="tdMachineName">' + PanelData[i].MachineName + '</td>';
                            mydata += '<td align="left" id="tdMajorUnitName">' + PanelData[i].MajorUnitName + '</td>';
                            mydata += '<td align="left" id="tdPackSize">' + PanelData[i].PackSize + '</td>';
                            mydata += '<td align="left" id="tdMinorUnitName">' + PanelData[i].MinorUnitName + '</td>';

                            mydata += '<td align="left" id="tdQuantity" style="display:none;"><input type="text" value="1" readonly="readonly"  style="width:60px" id="txtQuantity" /></td>';
                            mydata += '<td align="left" id="tdRate"><input type="text"  style="width:60px" id="txtRate" class="allrate" onkeyup="CalBuyPrice(this);"/></td>';
                            mydata += '<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);" /></td>';
                            mydata += '<td align="left" id="tdTotalGST" ><input type="text"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true" value="' + PanelData[i].gstntax + '" /></td>';
                           
                            mydata += '<td align="left" id="tdIGSTper" style="display:none;"><input type="text"  style="width:60px" id="txtIGSTpe" readonly="true"  /></td>';
                            mydata += '<td align="left" id="tdCGSTper" style="display:none;"><input type="text"  style="width:60px" id="txtCGSTper" readonly="true" /></td>';
                            mydata += '<td align="left" id="tdSGSTper" style="display:none;"><input type="text"  style="width:60px" id="txtSGSTper" readonly="true" /></td>';
       


                            mydata += '<td align="left" id="tdFreeQty" style="display:none;"><input type="text"  style="width:60px" id="txtFreeQty"/></td>';
                            mydata += '<td align="left" id="tdDiscountAmount" style="display:none;"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>';
                            mydata += '<td align="left" id="tdTotalGSTAmount" style="display:none;"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>';
                            mydata += '<td align="left" id="tdBuyPrice" style="display:none;"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>';
                            mydata += '<td align="left" id="tdNetAmt" style="display:none;"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>';






                            mydata += '<td  id="tditemtypeid" style="display:none;">' + PanelData[i].itemtypeid + '</td>';
                            mydata += '<td  id="tdItemid" style="display:none;">' + PanelData[i].Itemid + '</td>';
                            mydata += '<td  id="tdManufactureID" style="display:none;">' + PanelData[i].ManufactureID + '</td>';
                            mydata += '<td  id="tdMachineID" style="display:none;">' + PanelData[i].MachineID + '</td>';
                            mydata += '<td  id="tdMajorUnitId" style="display:none;">' + PanelData[i].MajorUnitId + '</td>';
                            mydata += '<td  id="tdMinorUnitId" style="display:none;">' + PanelData[i].MinorUnitId + '</td>';
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';


                            mydata += '</tr>';

                            $('#tblQuotation').append(mydata);
                        }


                        var dropdown = $("#<%=ddlsupplier.ClientID%>");
                        dropdown.attr("disabled", true);
                        dropdown.trigger('chosen:updated');


                        var dropdown1 = $("#<%=lstCentre.ClientID%>");
                        dropdown1.attr("disabled", true);



                        var dropdown2 = $("#<%=ddlstate.ClientID%>");
                        dropdown2.attr("disabled", true);

                        jQuery('#lstlocation').multipleSelect("disable");
                        jQuery('#lstCentreType').multipleSelect("disable");
                        jQuery('#lstCentre').multipleSelect("disable");

                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function deleterow(itemid) {
            var table = document.getElementById('tblQuotation');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }



        function SetAllRate(ctrl) {
            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));

            var Rate = $(ctrl).closest("tr").find("#ratehead").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#ratehead").val());
            $(".allrate").val(Rate);

        }
    </script>
</asp:Content>


