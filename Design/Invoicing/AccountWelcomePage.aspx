<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" EnableEventValidation="false" CodeFile="AccountWelcomePage.aspx.cs" Inherits="Design_Invoicing_AccountWelcomePage" %>
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
        .modalAccount {
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

        /* modalAccount Content */
        .modalAccount-content {
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

        .modalAccount-header {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }

        .modalAccount-body {
            padding: 2px 16px;
            height:180px;
        }

        .modalAccount-footer {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }

        .handsontable .htDimmed {
            color: #000000;
        }

       
        .handsontableInput
        {
            /*width:150px !important;*/
            max-width:150px !important;
        }
        .handsontableEditor, autocompleteEditor, handsontable, listbox{
             /*width:200px;*/
             max-width:200px;
        }

        #divimgpopup
        {
                height: 984px;
    min-height: 134px;
    width: auto;
    width: 400px;
    padding: 10px;
        }
        .ui-dialog-title
        {
            font-weight: bold;
        }
        .ui-dialog
        {
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
        .ui-icon-closethick
        {
            float:right;
        }

            .Lock {
                background-color:#3399FF;
            }
            .Open {
                background-color:#baf467;
            }
            .outstanding {
                background-color:#f85353;
            }

                .Lock:hover, .Open:hover {
                    background-color:#E7E8EF;
                }

                .FixedHeader {
            position: absolute;
        
        }
            .currentRow {
                font-weight:bold;
            }

    </style>   
        <style>
.tooltip {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black;
}

.tooltip .tooltiptext {
    visibility: hidden;
    width: 280px;
    background-color: #555;
    color: #fff;
    text-align: center;
    border-radius: 6px;
    padding: 5px 0;
    position: absolute;
    z-index: 1;
    bottom: 125%;
    left: 50%;
    margin-left: -140px;
    opacity: 0;
    transition: opacity 0.3s;
}

.tooltip .tooltiptext::after {
    content: "";
    position: absolute;
    top: 100%;
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: #555 transparent transparent transparent;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
    opacity: 1;
}
</style>
        <div id="Pbody_box_inventory">            
            <asp:Label  ID="lblIsSalesTeamMember" runat="server" Style="display:none" Text="0" ClientIDMode="Static"></asp:Label>
             <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />
             <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
           </Services>
        </Ajax:ScriptManager>
             <div class="POuter_Box_Inventory" style="text-align:center">
                 <div class="row">
                <div class="col-md-24" style="text-align:center">
                 <b>Ledger Status </b>
                    </div>
                     </div>
              <div class="row" id="tblType">
                  <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align:center">
                    <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" /> 
                    </div>
                  </div>           
</div>
      <div class="POuter_Box_Inventory">
          <div class="row trType PanelGroup" style="display:none">
              <div class="col-md-3">
                   </div>
               <div class="col-md-3">
                    <label class="pull-left">Panel Group</label>
                    <b class="pull-right">:</b>
                   </div>
               <div class="col-md-5">
                   <asp:ListBox ID="lstPanelGroup" runat="server" CssClass="multiselect" onchange="$bindPanelByGroup()" SelectionMode="Multiple">
                             
                         </asp:ListBox>
                   </div>
              </div>
           <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Unit</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                  <asp:ListBox ID="lstcentre" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                    </div>
               </div> 
           <div class="row trType">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                  <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()"   class="ddlBusinessZone chosen-select" ClientIDMode="Static"></asp:DropDownList>
                    </div>
               <div class="col-md-2">
                   </div>
               <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                  <asp:DropDownList ID="ddlState" runat="server" onchange="$bindPanel()"  class="ddlState chosen-select" ClientIDMode="Static"></asp:DropDownList>
               </div>
               </div>
          <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                     </div>
               <div class="col-md-2">
                   </div>
               <div class="col-md-3">
                    <label class="pull-left">Sales Manager</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
               <asp:ListBox ID="lstSalesManager" runat="server" CssClass="multiselect" SelectionMode="Multiple" ></asp:ListBox> 
              </div>
               </div>
          <div class="row" id="trAccount" style="display:none">
               <div class="col-md-11">
                   </div>
                <div class="col-md-3" style="display:none">
                     <label class="pull-left">All</label>
                    <b class="pull-right">:</b>

                      </div>
              <div class="col-md-5" style="display:none">
                  <asp:CheckBox ID="chkAllLedger" runat="server" Checked="false" onclick="chkLedger()" />
                  </div>
               <div class="col-md-2">
                   </div>
               <div class="col-md-3">
                     <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>

                      </div>
               <div class="col-md-5">
              <asp:TextBox ID="txtPanelName" runat="server"  ></asp:TextBox>
                            <input type="hidden" id="hdPanelID" />
                    </div>
              </div>                    
           </div> 
           <div class="POuter_Box_Inventory" style="text-align:center">
            <input type="button" id="btnSearch" class="searchbutton" onclick="$searchLedger()" value="Search" />
            <input type="button" id="btnexportReport" class="searchbutton" onclick="exportReport()" value="Report" />  
               <input type="button" id="bnnledst" class="searchbutton" onclick="$ExcelLedgerStament()" value="Ledger Statement" />                              
          </div>
      <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Ledger Status Details
            </div> 
          <div class="row">
              <div class="col-md-24">
                   <table  style="width: 100%; border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="LedgerSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                       
                    </td>
                </tr>
            </table>
                  </div>
          </div>          
        </div>      
          </div>  
    <div id="myModalAccount" class="modalAccount">
              <!-- modalAccount content -->
              <div class="modalAccount-content">
                <div class="modalAccount-header">
                  <span class="close">×</span>
                  <h2 class="modalAccount_header">Unlock Client</h2>
                </div>
                <div class="modalAccount-body">
                   <br />
                    <span id="span_panel" style="font-weight:bold; font-size:14px;"></span>
                    <asp:TextBox ID="txtPanelID" runat="server" style="display:none;"></asp:TextBox>
                    <br /><br />
                    <div class="row">
                        <div class="col-md-12">
                            <asp:CheckBox ID="chkLock" runat="server" Text="Unlock Client for" onclick="changeLockStatus();" />
                            Time Limit:</div><div class="col-md-4"> <asp:TextBox ID="txtTimeLimit" runat="server" MaxLength="2" CssClass="ItDoseTextinputText requiredField"></asp:TextBox></div>
                   
                    <div class="col-md-4"><asp:DropDownList ID="ddlTime" runat="server" >
                        <asp:ListItem Value="1">Hours</asp:ListItem>
                        <asp:ListItem Value="24">Days</asp:ListItem>                      
                    </asp:DropDownList>
                         <cc1:FilteredTextBoxExtender ID="ftbTimeLimit" runat="server" TargetControlID="txtTimeLimit" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </div>
                            </div>
                        <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Reason</label>
                    <b class="pull-right">:</b>
                  </div>
                            <div class="col-md-18">
                            <asp:TextBox ID="txtReason" runat="server" MaxLength="100" CssClass="requiredField"></asp:TextBox>
                             </div>
                             </div>
                    <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Last Reason</label>
                    <b class="pull-right">:</b>
                  </div>
                            <div class="col-md-18">
                                <span id="spnLastReaseon"></span>
                                </div>
                             </div>
                </div>
                <div class="modalAccount-footer" style="text-align:center">
                    <br />
                    <input type="button" id="btnSave" class="searchbutton"  onclick="updateClient()" value="Update" />
                   
                    <br />
                </div>
              </div>
           </div>
     <script type="text/javascript">
         function bindState() {
             jQuery("#ddlState option").remove();
             jQuery('#ddlState').trigger('chosen:updated');
            // jQuery('#<%=lstPanel.ClientID%> option').remove();
            // jQuery('#lstPanel').multipleSelect("refresh");
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
          </script>
     <script type="text/javascript">
         var modal = "";
         var span = "";
         function ShowModalWindow(ClientName, PanelCode, isLock, Panel_ID, LockUnLockReason) {
            // if (isLock == 'Lock (Manual Lock)' || isLock == 'Lock (Auto Lock)') {
             if (isLock == 'Lock (Manual)' || isLock == 'Lock (Auto)' || isLock == 'Booking Lock (Manual)' || isLock == 'Printing Lock (Manual)' || isLock == 'Booking Lock (Auto)' || isLock == 'Printing Lock (Auto)') {
                 jQuery('#span_panel').html(PanelCode + ":" + ClientName);
                 jQuery('.modalAccount_header').html('Unlock Client');
                 jQuery('#<%=txtPanelID.ClientID%>').val(Panel_ID);
                 jQuery('#<%=chkLock.ClientID%>').prop('checked', false);
                 jQuery('#<%=chkLock.ClientID%>').hide();
                 jQuery('#<%=txtTimeLimit.ClientID%>').removeAttr('disabled');
             }
             else {
                 jQuery('#span_panel').html(PanelCode + ":" + ClientName);
                 jQuery('.modalAccount_header').html('Lock Client');
                 jQuery('#<%=txtPanelID.ClientID%>').val(Panel_ID);
                 jQuery('#<%=chkLock.ClientID%>').prop('checked', true);
                 jQuery('#<%=chkLock.ClientID%>').show();
                 jQuery('#<%=txtTimeLimit.ClientID%>').attr('disabled', 'disabled');
             }
             jQuery('#spnLastReaseon').text(LockUnLockReason);
             modal.style.display = "block";
         }
         function updateClient() {
             var setLock = 0;
             var Panel_ID = jQuery('#<%=txtPanelID.ClientID%>').val();
             var txtTimeLimit = jQuery('#<%=txtTimeLimit.ClientID%>').val();
             var ddlTime = jQuery('#<%=ddlTime.ClientID%>').val();
             if (jQuery('#<%=chkLock.ClientID%>').is(':checked')) {
                 setLock = 1;
                 txtTimeLimit = 0;
             }
             if (jQuery.trim(jQuery('#txtReason').val()) == "") {
                 toast("Error","Please Enter " + jQuery('.modalAccount_header').html() + " Reason","");
                 jQuery('#txtReason').focus();
                 return;
                }
             serverCall('AccountWelcomePage.aspx/SaveUpdation', { PanelID: Panel_ID, setLock: setLock, txtTimeLimit: txtTimeLimit, ddlTime: ddlTime,LockUnLockReason:jQuery('#txtReason').val().replace("'", "").replace('"', ' ') }, function (response) {
                 var $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     toast("Success", $responseData.response, "");
                     modal.style.display = "none";
                     $searchLedger();
                     jQuery('#txtTimeLimit').val('0');
                     jQuery('#txtReason').val('');
                 }
                 else {
                     toast("Error", $responseData.response, "");
                 }
             });
         }
         function changeLockStatus() {
             if (jQuery('#<%=chkLock.ClientID%>').is(':checked')) {
                    jQuery('#<%=txtTimeLimit.ClientID%>').val(0);
                    jQuery('#<%=txtTimeLimit.ClientID%>').attr('disabled', 'disabled');
                }
                else {
                    jQuery('#<%=txtTimeLimit.ClientID%>').removeAttr('disabled');
                }
            }
            jQuery(function () {
                modal = document.getElementById('myModalAccount');
                span = document.getElementsByClassName("close")[0];
                span.onclick = function () {
                    modal.style.display = "none";
                }
                window.onclick = function (event) {
                    if (event.target == modal) {
                        modal.style.display = "none";
                    }
                }
            });
    </script>
     <script type="text/javascript">
         function $bindPanel() {
             centre = jQuery('#lstcentre').multipleSelect("getSelects").join();
             if (centre == "") {
                 alert("Please  Select Business Unit");
                 bindState();               
                 return;
             }
             var PanelGroup = jQuery("#rblSearchType input[type=radio]:checked").next('label').text(); //$('[id$=lstPanelGroup]').val().toString();
             serverCall('AccountWelcomePage.aspx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: '', PanelGroup: PanelGroup, IsInvoicePanel: 2, BillingCycle: "0", CentreID: jQuery('#lstcentre').multipleSelect("getSelects").join() }, function (response) {
                 bindPanelDetail(response);
             });
         }
    </script>
     <script type="text/javascript">
         jQuery(function () {
             bindState();

             //$('input[type=radio]#rblSearchType_0').attr("disabled", true);
             //$('input[type=radio]#rblSearchType_1').attr("disabled", true);
             //$('input[type=radio]#rblSearchType_3').attr("disabled", true);

             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 jQuery(selector).chosen(config[selector]);
             }
             jQuery('#ddlBusinessZone').trigger('chosen:updated');
            
             jQuery('[id*=lstPanel],[id*=lstSalesManager],[id*=lstcentre]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 if (jQuery("#lblSearchType").text() == "1")
                     salesManager();
					
         });
		 $('input[type=radio]#rblSearchType_0').attr("checked", true);
         function salesManager() {
             PageMethods.salesManager(onSuccessSalesManager, OnfailureSalesManager);
         }
         function onSuccessSalesManager(result) {
             var SalesManagerData = jQuery.parseJSON(result);
             jQuery('#<%=lstSalesManager.ClientID%> option').remove();
            jQuery('#lstSalesManager').multipleSelect("refresh");
            if (SalesManagerData != null) {
                for (i = 0; i < SalesManagerData.length; i++) {
                    jQuery('#<%=lstSalesManager.ClientID%>').append(jQuery("<option></option>").val(SalesManagerData[i].PROID).html(SalesManagerData[i].PRONAME));
                }
                jQuery('[id*=lstSalesManager]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
        }
        function OnfailureSalesManager() {

        }
         function clearControl() {
             jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
             jQuery('#ddlBusinessZone').trigger('chosen:updated');
            // jQuery('#ddlState').empty();
             jQuery('#ddlState').trigger('chosen:updated');
            // jQuery('#<%=lstPanel.ClientID%> option').remove();
             jQuery('#lstPanel').multipleSelect("refresh");
             jQuery('#LedgerSearchOutput').html('');
             jQuery('#LedgerSearchOutput').hide();
             
             if ($("#lblSearchType").text() == "2") {
                 //jQuery('#<%=lstPanel.ClientID%> option').remove();
                // jQuery('#lstPanel').multipleSelect("refresh");
                 serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesChildNode', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), IsInvoicePanel: 2 }, function (response) {
                     onSuccessPanel(response);
                 });
             }
             else if ($("#lblSearchType").text() == "3") {
                 serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesCentreAccess', { IsInvoicePanel: 2 }, function (response) {
                     onSuccessPanel(response);
                 });
             }
             if (jQuery("#rblSearchType input[type=radio]:checked").val() == "7") {
                 $('.PanelGroup').show();
             } else {
                 $('.PanelGroup').hide();
             }
			 $('input[type=radio]#rblSearchType_2').attr("checked", true);
         }
         function bindPanelDetail(response) {
             var panelData = jQuery.parseJSON(response);
             if (panelData != null) {
                 jQuery('#lstPanel').bindMultipleSelect({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery('#lstPanel') });
             }
             else {
                 jQuery('[id*=lstPanel]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
             }
         }
   </script>
     <script type="text/javascript">
         function $searchLedger() {
             var PanelID = "";
           
                 PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
                 if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked')) {
                     toast("Error", 'Please Select Client Name', "");
                     return;
                 }
             // alert(PanelID);
                 var center = "";
                 center = jQuery('#lstcentre').multipleSelect("getSelects").join();
             var SalesManager = "";
             if ($("#lblSearchType").text() == "1") {
                 SalesManager = jQuery('#lstSalesManager').multipleSelect("getSelects").join();
             }
             serverCall('AccountWelcomePage.aspx/searchLedger', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PanelID: PanelID, SalesManager: SalesManager, center: center }, function (response) {
                 LedgerData = jQuery.parseJSON(response);
                 if (LedgerData != null) {
                     var output = jQuery('#sc_Ledger').parseTemplate(LedgerData);
                     jQuery('#LedgerSearchOutput').html(output);
                     jQuery('#LedgerSearchOutput,#btnexportReport').show();
                     jQuery("#tblLedger").tableHeadFixer({
                     });
                 }
                 else {
                     jQuery('#LedgerSearchOutput').html('');
                     jQuery('#LedgerSearchOutput,#btnexportReport').hide();
                 }
             });
         }
            </script>
      <script type="text/javascript">
          function $ExcelLedgerStament() {
              var PanelID = "";
             
              PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
              if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked')) {
                  toast("Error", 'Please Select Client Name', "");
                  return;
              }
             
              var center = "";
              center = jQuery('#lstcentre').multipleSelect("getSelects").join();
              var SalesManager = "";
              if ($("#lblSearchType").text() == "1") {
                  SalesManager = jQuery('#lstSalesManager').multipleSelect("getSelects").join();
              }
              serverCall('AccountWelcomePage.aspx/ExcelLedgerStament', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PanelID: PanelID, SalesManager: SalesManager, center: center }, function (response) {
                  LedgerData = jQuery.parseJSON(response);
                  if (LedgerData == "false") {
                      toast("Error", "No Item Found", "");
                  }
                  else {
                      window.open('../common/ExportToExcel.aspx');
                  }
              });
          }
            </script>
              <script id="sc_Ledger" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblLedger" style="border-collapse:collapse;width:120%">
    
         <thead>
		<tr id="Header">
            <%--<th class="GridViewHeaderStyle" scope="col" >S.No.</th>--%>	
            <th class="GridViewHeaderStyle" scope="col">Code</th>
            <th class="GridViewHeaderStyle" scope="col" >Client Name</th>			
            <th class="GridViewHeaderStyle" scope="col" >Centre</th>
	    <th class="GridViewHeaderStyle" scope="col" >Sales Manager</th>
            <%--<th class="GridViewHeaderStyle" scope="col">City</th>--%>	
	    <th class="GridViewHeaderStyle" scope="col" >Creation Date</th>
	    <th class="GridViewHeaderStyle" scope="col" >Contact No.</th>
	    <th class="GridViewHeaderStyle" scope="col" >Curr. Month Opening</th>
	    <th class="GridViewHeaderStyle" scope="col" >Curr. Month Business</th>
	    <th class="GridViewHeaderStyle" scope="col">Received Amt.</th>
            <%--<th class="GridViewHeaderStyle" scope="col">Credit Limit</th>--%>
            <th class="GridViewHeaderStyle" scope="col">Balance Amount</th>
	    <th class="GridViewHeaderStyle" scope="col" >Status </th>
            <th class="GridViewHeaderStyle noExl" scope="col" >Lock/Unlock Reason </th>
            <th class="GridViewHeaderStyle" scope="col" >Security Amount</th>
	    <th class="GridViewHeaderStyle" scope="col" >Type </th>
            <th class="GridViewHeaderStyle" scope="col" >Intimation</th>
            <th class="GridViewHeaderStyle" scope="col" >Intimation Limit</th>
            <th class="GridViewHeaderStyle" scope="col" >Booking Lock</th>
            <th class="GridViewHeaderStyle" scope="col" >Booking Limit</th>
            <th class="GridViewHeaderStyle" scope="col" >Reporting Lock</th>
            <th class="GridViewHeaderStyle" scope="col" >Reporting Limit</th>
            <th class="GridViewHeaderStyle" scope="col" >Last Paid Amt. </th>
            <th class="GridViewHeaderStyle" scope="col" >Last Paid Date </th>
            <th class="GridViewHeaderStyle noExl" scope="col" style="display:none" >TDS(%) </th>
	    <th class="GridViewHeaderStyle noExl" scope="col" style="display:none" >SearchType </th>
            <th class="GridViewHeaderStyle noExl" scope="col" style="display:none">Dunning Letter </th>
</tr>
       </thead>      
       <#                 
        var dataLength=LedgerData.length;       
        var objRow;     
        for(var j=0;j<dataLength;j++)
        {
        objRow = LedgerData[j];
        #>
                    <tr id="<#=j+1#>"
                        <#if(objRow.isLock=="Lock (Manual)" || objRow.isLock=="Lock (Auto)" || objRow.isLock=="Booking Lock (Manual)" || objRow.isLock=="Printing Lock (Manual)" || objRow.isLock=="Booking Lock (Auto)" || objRow.isLock=="Printing Lock (Auto)"){#>
                        class="Lock"
                         <#} 
                          else{#>
                        class="Open"
                        <#}                         
                        #>
                        >
                    <%--<td class="GridViewLabItemStyle"><#=j+1#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdPanelCode"><a target="_blank"  href='InvoiceReport.aspx?PanelId=<#=objRow.Panel_ID#>'><#=objRow.PanelCode#></a></td>
                    <td class="GridViewLabItemStyle" id="tdPanelName" style="text-align:left"><#=objRow.PanelName#></td>                    
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:left"><#=objRow.Centre#></td> 
                    <td class="GridViewLabItemStyle" id="tdState" style="text-align:left"><#=objRow.SalesManager#></td>
                    <%--<td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.City#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdCreatorDate" ><#=objRow.CreatorDate#></td>
                    <td class="GridViewLabItemStyle" id="tdMobile" "><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdClosingBalance"  style="text-align:right"><#=objRow.ClosingBalance#></td>
                    <td class="GridViewLabItemStyle" id="tdCurrentBusiness" style="text-align:right"><#=objRow.CurrentBusiness#></td>
                    <td class="GridViewLabItemStyle" id="tdReceivedAmount"  style="text-align:right"><#=objRow.ReceivedAmount#></td>
                    <%--<td class="GridViewLabItemStyle" id="tdCreditLimit"  style="text-align:right"><#=objRow.CreditLimit#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdTotalOutstanding"   style="text-align:right"><#=objRow.TotalOutstanding#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus" >      
                        <# if(jQuery("#lblIsSalesTeamMember").text()=="0" ) 
                        {#>               
                     <a class="set_<#=objRow.Panel_ID#>" <%=IsHavingRights%> href="javascript:void(0);" onclick="ShowModalWindow('<#=objRow.PanelName#>','<#=objRow.PanelCode#>','<#=objRow.isLock#>','<#=objRow.Panel_ID#>','<#=objRow.LockUnLockReason#>');">
                         <#=objRow.isLock#>                      
                         </a>
                        <#}
                        else
                            {#>  
                        <#=objRow.isLock#>  
                        <#}#>              
                    </td>
                    <td class="GridViewLabItemStyle noExl"  >
                            <# if(objRow.LockUnlockReason !=""){#>   
                           <%-- <div class="tooltip">
                                <img id="imgLockUnLockReason" style="cursor:pointer"  src="../../App_Images/view.GIF" />
                                 <span class="tooltiptext" ><#=objRow.LockUnlockReason#></span>
                                </div>--%>
                        <#=objRow.LockUnlockReason#>  
                        <#}#>  
                        </td>
                    <td class="GridViewLabItemStyle" id="td3"  ><#=objRow.SecurityAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdPayment_Mode"  ><#=objRow.Payment_Mode#></td>
                    
                    <td class="GridViewLabItemStyle"><#=objRow.IsShowIntimation#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"  ><#=objRow.IntimationLimit#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.IsBlockPanelBooking#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"  ><#=objRow.CreditLimit#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.IsBlockPanelReporting#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"  ><#=objRow.LabReportLimit#></td>
                    <td class="GridViewLabItemStyle" id="tdLastPaidAmt" style="text-align:right"  ><#=objRow.LastPaidAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdLastPaidDate" style="text-align:center"  ><#=objRow.LastPaidDate#></td>
                    <td class="GridViewLabItemStyle noExl" id="tdTaxPercentage"  style="display:none"><#=objRow.TaxPercentage#></td>  
                    <td class="GridViewLabItemStyle noExl" id="tdSearchType"  style="display:none"><#=objRow.SearchType#></td> 
                    <td class="GridViewLabItemStyle noExl" id="tdPanel_ID"  style="display:none"><#=objRow.Panel_ID#></td> 
                    <td class="GridViewLabItemStyle noExl" id="tdInvoiceTo"  style="display:none"><#=objRow.InvoiceTo#></td> 
                    <td class="GridViewLabItemStyle noExl" id="td1" style="display:none" ><img id="imgDunningLetters" style="cursor:pointer" onclick="DunningLetters(this)" src="../../App_Images/view.GIF" /> </td>                       
                    </tr>
        <#}
        #>       
     </table>
    </script>
<script type="text/javascript">
    function exportReport() {
        jQuery("#tblLedger").remove(".noExl").table2excel({
            name: "Client Ledger Status",
            filename: "LedgerStatusReport", //do not include extension
            exclude_inputs: false
        });
    }
    </script>
  <script type="text/javascript">
      function chkLedger() {
          if (jQuery("#chkAllLedger").is(':checked')) {
              clearControl();
              jQuery('#txtPanelName').val('');
              jQuery('#ddlBusinessZone,#txtPanelName').attr('disabled', 'disabled');
          }
          else {
              jQuery('#ddlBusinessZone,#txtPanelName').removeAttr('disabled');
          }
          jQuery('#ddlBusinessZone,#ddlState').trigger('chosen:updated');
      }
      jQuery(function () {
          chkLedger();
          var PaymentMode = "";
          jQuery('#txtPanelName').bind("keydown", function (event) {
              if (event.keyCode === jQuery.ui.keyCode.TAB &&
                  jQuery(this).autocomplete("instance").menu.active) {
                  event.preventDefault();
              }
              jQuery("#hdPanelID").val('');
              if (jQuery("#rblSearchType input[type=radio]:checked").val() == "7")
                  PaymentMode = "Credit";
              else
                  PaymentMode = "";
          })
            .autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=LedgerPanel", {
                        SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(),
                        PaymentMode: PaymentMode,
                        PanelName: request.term,
                        IsInvoicePanel:2
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
      function showAccountSearch() {
          jQuery("#trAccount").show();
      }
    </script>
    <script type="text/javascript">
        function LedgerStatement(rowID) {
            serverCall('AccountWelcomePage.aspx/encryptData', { PanelID: jQuery(rowID).closest('tr').find("#tdPanel_ID").text(), Type: jQuery(rowID).closest('tr').find("#tdSearchType").text() }, function (response) {
                var result = jQuery.parseJSON(response);
                window.open('LedgerStatement.aspx?ClientID=' + result[0] + '&Type=' + result[1] + '');
            });
        }
        function DunningLetters(rowID) {
            serverCall('AccountWelcomePage.aspx/encryptData', { PanelID: jQuery(rowID).closest('tr').find('#tdInvoiceTo').text(), Type: jQuery(rowID).closest('tr').find('#tdSearchType').text() }, function (response) {
                var result = jQuery.parseJSON(response);
                window.open('DunningLetter.aspx?PanelID=' + result[0] + '&Type=' + result[1] + '');
            });
        }
    </script>   
    <script type="text/javascript">
        function bindSalesPanel() {
            jQuery('.trType,#trAccount').hide();
            jQuery('[id*=lstSalesManager]').hide();
            serverCall('Services/Panel_Invoice.asmx/SalesChildNode', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val() }, function (response) {
                bindPanelDetail(response);
            });
        }
        function hideSearchCriteria() {
            jQuery('.trType,#tblType,#trAccount').hide();
            jQuery('[id*=lstSalesManager]').hide();
        }
        function $bindPanelByGroup() {
            clearControl();
            var PanelGroupId = $('[id$=lstPanelGroup]').val().toString();
            if (PanelGroupId != '') {
                //jQuery('#<%=lstPanel.ClientID%> option').remove();
                //jQuery('#lstPanel').multipleSelect("refresh");
                serverCall('AccountWelcomePage.aspx/BindPanelByGroup', { PanelGroupId: PanelGroupId }, function (response) {
                    jQuery("#lstPanel").bindMultipleSelect({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstPanel") });

                });


            }
        }
    </script>  
</asp:Content>

