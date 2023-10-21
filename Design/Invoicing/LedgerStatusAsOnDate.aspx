
<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" EnableEventValidation="false" CodeFile="LedgerStatusAsOnDate.aspx.cs" Inherits="Design_Invoicing_LedgerStatusAsOnDate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
<script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
 
        <style>
            div#divPatient.vertical {
                width: 40%;
                height: 400px;
                background: #ffffff;
                float: left;
                overflow-y: auto;
                border-right: solid 1px gray;
            }

            div#divInvestigation.vertical {
                margin-left: 40%;
                height: 400px;
                background: #ffffff;
                overflow-y: auto;
            }


            div#divPatient.horizontal {
                height: 600px;
                background: #ffffff;
                overflow-y: auto;
            }

            div#divInvestigation.horizontal {
                height: 300px;
                background: #ffffff;
                overflow-y: auto;
            }


            .ht_clone_top_left_corner, .ht_clone_bottom_left_corner, .ht_clone_left, .ht_clone_top {
                z-index: 0;
            }

            .ajax__calendar .ajax__calendar_container {
                z-index: 9999;
            }
            /* The Modal (background) */
            .modal {
                display: none; /* Hidden by default */
                position: fixed; /* Stay in place */
                z-index: 999; /* Sit on top */
                padding-top: 50px; /* Location of the box */
                left: 0;
                top: 0;
                width: 100%; /* Full width */
                height: 100%; /* Full height */
                overflow: auto; /* Enable scroll if needed */
                background-color: rgb(0,0,0); /* Fallback color */
                background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            }

            /* Modal Content */
            .modal-content {
                position: relative;
                background-color: #fefefe;
                margin: auto;
                padding: 0;
                border: 1px solid #888;
                width: 40%;
                box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
                -webkit-animation-name: animatetop;
                -webkit-animation-duration: 0.4s;
                animation-name: animatetop;
                animation-duration: 0.4s;
            }

            /* Add Animation */
            @-webkit-keyframes animatetop {
                from {
                    top: -300px;
                    opacity: 0;
                }

                to {
                    top: 0;
                    opacity: 1;
                }
            }

            @keyframes animatetop {
                from {
                    top: -300px;
                    opacity: 0;
                }

                to {
                    top: 0;
                    opacity: 1;
                }
            }

            /* The Close Button */
            .close {
                color: white;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }

                .close:hover,
                .close:focus {
                    color: #000;
                    text-decoration: none;
                    cursor: pointer;
                }

            .modal-header {
                padding: 2px 16px;
                background-color: #5cb85c;
                color: white;
            }

            .modal-body {
                padding: 2px 16px;
                height: 100px;
            }

            .modal-footer {
                padding: 2px 16px;
                background-color: #5cb85c;
                color: white;
            }

            .handsontable .htDimmed {
                color: #000000;
            }


            .handsontableInput {
                /*width:150px !important;*/
                max-width: 150px !important;
            }

            .handsontableEditor, autocompleteEditor, handsontable, listbox {
                /*width:200px;*/
                max-width: 200px;
            }

            #divimgpopup {
                height: 984px;
                min-height: 134px;
                width: auto;
                width: 400px;
                padding: 10px;
            }

            .ui-dialog-title {
                font-weight: bold;
            }

            .ui-dialog {
                display: block;
                position: absolute;
                outline: 0px;
                height: 300px;
                padding: 10px;
                width: 500px;
                top: 0px;
                left: 514.5px;
                z-index: 9999;
                background-color: whitesmoke;
                box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            }

            .ui-icon-closethick {
                float: right;
            }

            .Lock {
                background-color: #ffd800;
            }

            .Open {
                background-color: #baf467;
            }

            .outstanding {
                background-color: #f85353;
            }

            .Lock:hover, .Open:hover {
                background-color: #E7E8EF;
            }

            .FixedHeader {
                position: absolute;
            }

            .currentRow {
                font-weight: bold;
            }
        </style>
        <div id="Pbody_box_inventory">
             <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
           </Services>
        </Ajax:ScriptManager>
             <div class="POuter_Box_Inventory" style="text-align:center">               
                  <div class="row">
                <div class="col-md-24">
                    <strong>Ledger Status As On Date Report
                    </strong>
                </div>
            </div>
            <div class="row" id="tblType">
                <div class="col-md-10"></div>
                 <div class="col-md-14" style="text-align: center">
                      <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" /> 
                     </div>
                </div>         
</div>
      <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
               Search Criteria 
            </div>
          <div class="row" >
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:DropDownList ID="ddlBusinessZone" runat="server"  onchange="bindState()"   class="ddlBusinessZone chosen-select" ClientIDMode="Static"></asp:DropDownList>

                    </div>
               <div class="col-md-2"></div>
               <div class="col-md-3">
 <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()"  class="ddlState chosen-select" ClientIDMode="Static"></asp:DropDownList>
</div>
              </div>
           <div class="row" >
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple" ></asp:ListBox>
                    </div>
                </div>

           <div class="row" >
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddltype" runat="server"  onchange="setdate()">
                          <asp:ListItem Value="1">As On Date</asp:ListItem>
                            <asp:ListItem Value="2">From Date To Date </asp:ListItem>
                            <asp:ListItem Value="3">Date Wise Trend (Closing Balance)</asp:ListItem>
                      </asp:DropDownList>
                    </div>
                <div class="col-md-2"></div>
               <div class="col-md-3">
 <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtPanelName" runat="server" ></asp:TextBox>
                        <input type="hidden" id="hdPanelID" />
               </div>
                </div>

           <div class="row asondate" >
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">As On Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:TextBox ID="txtDate" runat="server"  Width="100px" ></asp:TextBox>  
                       <cc1:CalendarExtender runat="server" ID="calDate" TargetControlID="txtDate"  Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                               <asp:TextBox ID="txtToTime" runat="server" Width="70px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">                        
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                        ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
                                        InvalidValueMessage="*"  >
                                </cc1:MaskedEditValidator>
                    </div>
               </div>
           <div class="row fromdatetodate" style="display:none;">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox ID="txtfromdate" runat="server"  Width="100px"></asp:TextBox>  
                       <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txtfromdate"  Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       &nbsp; To Date :&nbsp;&nbsp;&nbsp;   <asp:TextBox ID="txttodate" runat="server"  Width="100px"></asp:TextBox>  
                       <cc1:CalendarExtender runat="server" ID="CalendarExtender2" TargetControlID="txttodate"  Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
               </div>            
             </div> 
           <div class="POuter_Box_Inventory" style="text-align:center">
            <input type="button" id="btnSearch" class="searchbutton" onclick="searchLedger()" value="Search" />
           <input type="button" id="btnexportReport" class="searchbutton" onclick="exportReport()" value="Report" />         
          </div>
      <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Details
            </div>
           <div class="row" >
                <div class="col-md-24">
                     <div id="LedgerSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                    </div>
               </div>
            
        </div>
        
   

          </div>  
   


     <script type="text/javascript">
         function bindState() {
             jQuery("#ddlState option").remove();
           //  if (jQuery("#ddlBusinessZone").val() != 0)
                 CommonServices.bindState(jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
         }
         function onSucessState(result) {
             var stateData = jQuery.parseJSON(result);
             if (stateData.length == 0) {
                 jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
             }
             else {
                 jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                 if (stateData.length > 0) {
                     jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
                 }
                 for (i = 0; i < stateData.length; i++) {
                     jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                 }

             }
         }
         function onFailureState() {

         }
          </script>
    
     <script type="text/javascript">
         function bindState() {
             jQuery("#ddlState option").remove();

             jQuery('#ddlState').trigger('chosen:updated');
           //  jQuery('#<%=lstPanel.ClientID%> option').remove();
           //  jQuery('#lstPanel').multipleSelect("refresh");
           //  if (jQuery("#ddlBusinessZone").val() != 0)
                 CommonServices.bindState(0, jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
         }
         function onSucessState(result) {
             var stateData = jQuery.parseJSON(result);

             jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
             if (stateData.length > 0) {
                 jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
             }
             for (i = 0; i < stateData.length; i++) {
                 jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
             }
             jQuery('#ddlState').trigger('chosen:updated');

         }
         function onFailureState() {

         }

         function bindPanel() {

             //jQuery('#<%=lstPanel.ClientID%> option').remove();
             //jQuery('#lstPanel').multipleSelect("refresh");
             serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: '', PanelGroup: jQuery("#rblSearchType input[type=radio]:checked").next('label').text(), IsInvoicePanel: 2, BillingCycle: "0" }, function (response) {
                 jQuery("#lstPanel").bindMultipleSelect({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstPanel") });

             });


         }
         
    </script>
     <script type="text/javascript">
         jQuery(function () {
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

             jQuery('#ddlBusinessZone').trigger('chosen:updated');
             jQuery(function () {
                 jQuery('[id*=lstPanel]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
             });
             bindState();
         });
         function clearControl() {
             jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
             jQuery('#ddlBusinessZone').trigger('chosen:updated');
            // jQuery('#ddlState').empty();
             jQuery('#ddlState').trigger('chosen:updated');
           //  jQuery('#<%=lstPanel.ClientID%> option').remove();
            // jQuery('#lstPanel').multipleSelect("refresh");
             jQuery('#LedgerSearchOutput').html('');
             jQuery('#LedgerSearchOutput').hide();
             jQuery('#txtPanelName').val('');
             jQuery('#hdPanelID').val('');
         }
   </script>
     <script type="text/javascript">
         function searchLedger() {

             var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
             if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                 PanelID = jQuery("#hdPanelID").val().split('#')[0];
             }
             if (PanelID == 0 || PanelID == null) {
                 toast("Error", 'Please Select Client Name');
                 return;
             }

             var AsOnDate = jQuery("#txtDate").val() + " " + jQuery("#txtToTime").val();

             serverCall('LedgerStatusAsOnDate.aspx/searchLedger', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PanelID: PanelID, AsOnDate: AsOnDate, type: jQuery('#ddltype').val(), fromDate: jQuery('#txtfromdate').val(), toDate: jQuery('#txttodate').val() }, function (response) {

                 LedgerData = jQuery.parseJSON(response);
                 if (LedgerData != null) {
                     if ($('#<%=ddltype.ClientID%>').val() == "1" || $('#<%=ddltype.ClientID%>').val() == "3") {
                         var output = $('#sc_Ledger').parseTemplate(LedgerData);
                         jQuery('#LedgerSearchOutput').html(output);
                         jQuery('#LedgerSearchOutput,#btnexportReport').show();
                         jQuery("#tblLedger").tableHeadFixer({
                         });
                     }
                     else {
                         var output = $('#sc_Ledger1').parseTemplate(LedgerData);
                         jQuery('#LedgerSearchOutput').html(output);
                         jQuery('#LedgerSearchOutput,#btnexportReport').show();
                         jQuery("#tblLedger").tableHeadFixer({
                         });
                     }
                 }
                 else {
                     jQuery('#LedgerSearchOutput').html('');
                     jQuery('#LedgerSearchOutput,#btnexportReport').hide();

                 }
             });
         }
            </script>
              <script id="sc_Ledger" type="text/html">

   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblLedger"
    style="border-collapse:collapse;width:100%;">
         <thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>	
		    <th class="GridViewHeaderStyle" scope="col">Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:320px">Client Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px">Zone</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:180px">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px">City</th>	
			<th class="GridViewHeaderStyle" scope="col" >Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Opening Balance</th>												
</tr>
       </thead>      
       <#                   
        var dataLength=LedgerData.length;      
        var objRow;    
        for(var j=0;j<dataLength;j++)
        {
        objRow = LedgerData[j];
        #>
                    <tr id="<#=j+1#>" >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelCode" ><#=objRow.PanelCode#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelName" style="text-align:left"><#=objRow.PanelName#></td>  
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:left"><#=objRow.Zone#></td>                  
                    <td class="GridViewLabItemStyle" id="tdState" style="text-align:left"><#=objRow.State#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.City#></td>
                    <td class="GridViewLabItemStyle" id="tdMobile" style="text-align:left"><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle" id="tddate" style="text-align:left"><#=objRow.AsOnDate#></td>
                    <td class="GridViewLabItemStyle" id="tdOpeningBalance"  style="text-align:right"><#=objRow.OpeningBalance#></td>                  
                    </tr>
        <#}
        #>       
     </table>
    </script>


    <script id="sc_Ledger1" type="text/html">

   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblLedger"
    style="border-collapse:collapse;width:100%;">
         <thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>	
		    <th class="GridViewHeaderStyle" scope="col">Code</th>
            <th class="GridViewHeaderStyle" scope="col" >Client Name</th>
			
			<th class="GridViewHeaderStyle" scope="col" >State</th>
            <th class="GridViewHeaderStyle" scope="col">City</th>	
			<th class="GridViewHeaderStyle" scope="col" >Creation Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Contact No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Opening Amt</th>
			<th class="GridViewHeaderStyle" scope="col" >Booking Amt</th>
			<th class="GridViewHeaderStyle" scope="col">Paid Amt</th>
           
            <th class="GridViewHeaderStyle" scope="col">Balance Amt</th>

			<%--<th class="GridViewHeaderStyle" scope="col" >Status </th>
			<th class="GridViewHeaderStyle" scope="col" >Type </th>--%>
            <th class="GridViewHeaderStyle noExl" scope="col" style="display:none" >TDS(%) </th>
			<th class="GridViewHeaderStyle noExl" scope="col" style="display:none" >SearchType </th>
            <%--<th class="GridViewHeaderStyle noExl" scope="col" >Dunning Letter </th>--%>
</tr>
       </thead>
       
       <#
       
              
                  var dataLength=LedgerData.length;
       
        var objRow;
     
        for(var j=0;j<dataLength;j++)
        {
        objRow = LedgerData[j];
        #>
                    <tr id="Tr2"
                         <#if(objRow.isLock=="Lock (Manual Lock)" || objRow.isLock=="Lock (Auto Lock)"){#>
                        class="Lock"
                         <#} 
                          else{#>
                        class="Open"
                        <#} 
                         
                        #>
                        >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td2" onclick="LedgerStatement(this)"   ><#=objRow.PanelCode#></td>
                    <td class="GridViewLabItemStyle" id="td3" ><#=objRow.PanelName#></td>                    
                    <td class="GridViewLabItemStyle" id="td4" ><#=objRow.State#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.City#></td>
                    <td class="GridViewLabItemStyle" id="tdCreatorDate" ><#=objRow.CreatorDate#></td>
                    <td class="GridViewLabItemStyle" id="td5" "><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdClosingBalance"  ><#=objRow.ClosingBalance#></td>
                    <td class="GridViewLabItemStyle" id="tdCurrentBusiness" ><#=objRow.CurrentBusiness#></td>
                    <td class="GridViewLabItemStyle" id="tdReceivedAmount"  ><#=objRow.ReceivedAmount#></td>
                   <%-- <td class="GridViewLabItemStyle" id="tdCreditLimit"  ><#=objRow.CreditLimit#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdTotalOutstanding"   ><#=objRow.TotalOutstanding#></td>
                   <%-- <td class="GridViewLabItemStyle" id="tdStatus" >                      
                     <a class="set_<#=objRow.Panel_ID#>" href="javascript:void(0);" onclick="ShowModalWindow('<#=objRow.PanelName#>','<#=objRow.PanelCode#>','<#=objRow.isLock#>','<#=objRow.Panel_ID#>');">
                         <#=objRow.isLock#>                      
                         </a>
                                             
                    </td>
                    <td class="GridViewLabItemStyle" id="tdPayment_Mode"  ><#=objRow.Payment_Mode#></td>--%>
                    <td class="GridViewLabItemStyle noExl" id="tdTaxPercentage"  style="display:none"><#=objRow.TaxPercentage#></td>  
                    <td class="GridViewLabItemStyle noExl" id="tdSearchType"  style="display:none"><#=objRow.SearchType#></td> 
                    <td class="GridViewLabItemStyle noExl" id="tdPanel_ID"  style="display:none"><#=objRow.Panel_ID#></td> 
<td class="GridViewLabItemStyle noExl" id="tdInvoiceTo"  style="display:none"><#=objRow.InvoiceTo#></td> 
                   <%-- <td class="GridViewLabItemStyle noExl" id="td6"  ><img id="imgDunningLetters" style="cursor:pointer" onclick="DunningLetters(this)" src="../../App_Images/view.GIF" /> </td> --%>                      
                    </tr>
        <#}
        #>       
     </table>
    </script>
<script type="text/javascript">
    function exportReport() {
        $("#tblLedger").remove(".noExl").table2excel({
            name: "Client Ledger Status As On Date Report",
            filename: "LedgerStatusReport", //do not include extension
            exclude_inputs: false
        });
    }
    </script>
    <script type="text/javascript">
        jQuery(function () {

            jQuery('#txtPanelName').bind("keydown", function (event) {
                if (event.keyCode === jQuery.ui.keyCode.TAB &&
                    $(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
                jQuery("#hdPanelID").val('');
            })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=LedgerPanel", {
                          SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(),
                          PanelName: request.term,
                          IsInvoicePanel: 2
                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = this.value;
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {
                      jQuery("#hdPanelID").val(ui.item.value);
                      this.value = ui.item.label;
                      return false;
                  },
              });

        });
    </script>
    <script type="text/javascript">
        jQuery(function () {
            //  selectType();
        });

        function setdate() {

            if ($('#<%=ddltype.ClientID%>').val() == "1") {
                $('.asondate').show();
                $('.fromdatetodate').hide();

            }
            else {
                $('.asondate').hide();
                $('.fromdatetodate').show();
            }
        }


        function selectType() {
            if (jQuery("#ddltype").val() == "1") {
                jQuery("#txtFromDate,#txtToDate").attr('disabled', 'disabled');
                jQuery("#txtDate").removeAttr('disabled');
            }
            else {
                jQuery("#txtFromDate,#txtToDate").removeAttr('disabled');
                jQuery("#txtDate").attr('disabled', 'disabled');
            }
        }
    </script>
</asp:Content>

