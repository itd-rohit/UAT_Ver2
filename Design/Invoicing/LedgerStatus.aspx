<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="LedgerStatus.aspx.cs" Inherits="Design_Invoicing_LedgerStatus" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



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
            height:180px;
        }

        .modal-footer {
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
        <div id="Pbody_box_inventory" >
             <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
           </Services>
        </Ajax:ScriptManager>

             <div class="POuter_Box_Inventory" style="text-align:center">
                 <div class="row">
                <div class="col-md-24">
                    <b>Ledger Status for Cash PUP
                    </b>
                </div>
            </div>                     
</div>
      <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
               Ledger Status 
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
                                                <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()" class="ddlState chosen-select" ClientIDMode="Static"></asp:DropDownList>

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

            <div class="row" id="trAccount" style="display:none">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
 <label class="pull-left">All</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:CheckBox ID="chkAllLedger" runat="server" Checked="false" onclick="chkLedger()" /> 
                    </div>
                   <div class="col-md-2"></div>
               <div class="col-md-3">
 <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPanelName" runat="server"  ></asp:TextBox>    
                </div>
         
             </div> 
          </div> 
           <div class="POuter_Box_Inventory" style="text-align:center">
            <input type="button" id="btnSearch" class="searchbutton" onclick="searchLedger()" value="Search" />
           <input type="button" id="btnexportReport" class="searchbutton" onclick="ExcelExport()" value="Report"  style="display:none"/>
  
              
          

          
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
            </div>
    <div id="myModal" class="modal">
              <!-- Modal content -->
              <div class="modal-content">
                <div class="modal-header">
                  <span class="close">×</span>
                  <h2 class="modal_header">Unlock Client</h2>
                </div>
                <div class="modal-body">
                   <br />
                    <span id="span_panel" style="font-weight:bold; font-size:14px;"></span>
                    <asp:TextBox ID="txtPanelID" runat="server" style="display:none;"></asp:TextBox>
                    <br /><br />
                     <div class="row">
                        <div class="col-md-12">


                    <asp:CheckBox ID="chkLock" runat="server" Text="Unlock Client for" onclick="changeLockStatus();" />

                 Time Limit:</div><div class="col-md-4"> <asp:TextBox ID="txtTimeLimit" runat="server" CssClass="ItDoseTextinputText" ></asp:TextBox></div>
                    <cc1:FilteredTextBoxExtender ID="ftbTimeLimit" runat="server" TargetControlID="txtTimeLimit" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    <div class="col-md-4"><asp:DropDownList ID="ddlTime" runat="server" >
                        <asp:ListItem Value="1">Hours</asp:ListItem>
                        <asp:ListItem Value="24">Days</asp:ListItem>                      
                    </asp:DropDownList></div></div>
                       <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Reason</label>
                    <b class="pull-right">:</b>
                  </div>
                            <div class="col-md-18">
                            <asp:TextBox ID="txtReason" runat="server" MaxLength="100" ></asp:TextBox>
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
                <div class="modal-footer" style="text-align:center">
                    <br />
                    <input type="button" id="btnSave" class="searchbutton"  onclick="updateClient()" value="Update" />
                   
                    <br />
                </div>
              </div>

            </div>


     <script type="text/javascript">
         function bindState() {
             jQuery("#ddlState option").remove();
           //  if (jQuery("#ddlBusinessZone").val() != 0)
                 CommonServices.bindState(0,jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
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
         var modal = "";
         var span = "";
         function ShowModalWindow(ClientName, PanelCode, isLock, Panel_ID, LockUnLockReason) {

             if (isLock == 'Lock (Manual Lock)' || isLock == 'Lock (Auto Lock)') {
                 jQuery('#span_panel').html(PanelCode + ":" + ClientName);
                 jQuery('.modal_header').html('Unlock Client');
                 jQuery('#<%=txtPanelID.ClientID%>').val(Panel_ID);
                 jQuery('#<%=chkLock.ClientID%>').prop('checked', false);
                 jQuery('#<%=chkLock.ClientID%>').hide();
                 jQuery('#<%=txtTimeLimit.ClientID%>').removeAttr('disabled');

             }
             else {
                 jQuery('#span_panel').html(PanelCode + ":" + ClientName);
                 jQuery('.modal_header').html('Lock Client');
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
                    toast("Error", "Please Enter " + jQuery('.modal_header').html() + " Reason", "");
                    jQuery('#txtReason').focus();
                    return;
                }
                serverCall('AccountWelcomePage.aspx/SaveUpdation', { PanelID: Panel_ID, setLock: setLock, txtTimeLimit: txtTimeLimit, ddlTime: ddlTime, LockUnLockReason: jQuery('#txtReason').val().replace("'", "").replace('"', ' ') }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                        modal.style.display = "none";
                        searchLedger();
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
            modal = document.getElementById('myModal');
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
         function bindState() {
             jQuery("#ddlState option").remove();
          
             jQuery('#ddlState').trigger('chosen:updated');
             jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
          //  if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(0,jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
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
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
                PageMethods.bindPanel($("#ddlBusinessZone").val(), jQuery("#ddlState").val(),onSuccessPanel, OnfailurePanel);
            
                
            
        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);

            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (panelData != null) {
                for (i = 0; i < panelData.length; i++) {
                    jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });

            }


        }
        function OnfailurePanel() {

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
           //  jQuery('#ddlState').empty();
             jQuery('#ddlState').trigger('chosen:updated');
             jQuery('#<%=lstPanel.ClientID%> option').remove();
             jQuery('#lstPanel').multipleSelect("refresh");
             jQuery('#LedgerSearchOutput').html('');
             jQuery('#LedgerSearchOutput').hide();
         }
   </script>
     <script type="text/javascript">
         function searchLedger() {
             var PanelID = "";
            
             
             if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "") 
                 PanelID = jQuery("#hdPanelID").val().split('#')[0];
                    
             else if (jQuery("#chkAllLedger").is(':checked') && jQuery("#chkAllLedger").is(':visible')) 
                 PanelID = "";                 
             else 
                 PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();                    
             if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked') && !jQuery("#chkAllLedger").is(':visible')) {
                 toast("Error",'Please Select Client Name');
                 return;
             }
             serverCall('LedgerStatus.aspx/searchLedger', { PanelID: PanelID }, function (response) {
                 LedgerData = jQuery.parseJSON(response);
                 if (LedgerData != null) {
                     var output = $('#sc_Ledger').parseTemplate(LedgerData);
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
         
         function ExcelExport() {
             var PanelID = "";
             if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "")
                 PanelID = jQuery("#hdPanelID").val().split('#')[0];
             else if (jQuery("#chkAllLedger").is(':checked') && jQuery("#chkAllLedger").is(':visible'))
                 PanelID = "";
             else
                 PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
             if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked') && !jQuery("#chkAllLedger").is(':visible')) {
                 toast("Error", 'Please Select Client Name');
                 return;
             }
             serverCall('LedgerStatus.aspx/ExcelExport', { PanelID: PanelID }, function (response) {
                 if (response == "1") {
                     window.open("../Common/ExportToExcel.aspx");
                 }
                 else {
                     toast("Info","No record found !");
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
            <th class="GridViewHeaderStyle" scope="col" >Client Name</th>
			
			<th class="GridViewHeaderStyle" scope="col" >State</th>
            <th class="GridViewHeaderStyle" scope="col">City</th>	
			<th class="GridViewHeaderStyle" scope="col" >Creation Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Contact No.</th>
            <th class="GridViewHeaderStyle" scope="col">Credit Limit</th>
            <th class="GridViewHeaderStyle" scope="col">Balance Amount</th>

			<%--<th class="GridViewHeaderStyle" scope="col" >Status </th>--%>
			<th class="GridViewHeaderStyle" scope="col" >Type </th>
            <th class="GridViewHeaderStyle noExl" scope="col" style="display:none" >TDS(%) </th>
			
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
                         <#if(objRow.isLock=="Lock (Manual Lock)" || objRow.isLock=="Lock (Auto Lock)"){#>
                        class="Lock"
                         <#} 
                          else{#>
                        class="Open"
                        <#} 
                         
                        #>
                        >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelCode"   ><#=objRow.PanelCode#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelName" ><#=objRow.PanelName#></td>                    
                    <td class="GridViewLabItemStyle" id="tdState" ><#=objRow.State#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.City#></td>
                    <td class="GridViewLabItemStyle" id="tdCreatorDate" ><#=objRow.CreatorDate#></td>
                    <td class="GridViewLabItemStyle" id="tdMobile" "><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdCreditLimit"  ><#=objRow.CreditLimit#></td>
                    <td class="GridViewLabItemStyle" id="tdTotalOutstanding"   ><#=objRow.BalanceAmt#></td>
                    <%--<td class="GridViewLabItemStyle" id="tdStatus" >                      
                     <a class="set_<#=objRow.Panel_ID#>" href="javascript:void(0);" onclick="ShowModalWindow('<#=objRow.PanelName#>','<#=objRow.PanelCode#>','<#=objRow.isLock#>','<#=objRow.Panel_ID#>');">
                         <#=objRow.isLock#>                      
                         </a>
                                             
                    </td>--%>
                    <td class="GridViewLabItemStyle" id="tdPayment_Mode"  ><#=objRow.Payment_Mode#></td>
                    <td class="GridViewLabItemStyle noExl" id="tdTaxPercentage"  style="display:none""><#=objRow.TaxPercentage#></td>                  
                    </tr>
        <#}
        #>       
     </table>
    </script>
<script type="text/javascript">
    //function exportReport() {

    //    $("#tblLedger").remove(".noExl").table2excel({
    //        name: "Client Ledger Status",
    //        filename: "LedgerStatusReport", //do not include extension
    //        exclude_inputs: false
    //    });
    //}
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
                jQuery('#ddlBusinessZone').trigger('chosen:updated');
            }
            jQuery(function () {
                chkLedger();
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
                          jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=LedgerPanelPUP", {
                              SearchType: "2",
                              PaymentMode: "Cash",
                              PanelName: request.term
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
                          $("#hdPanelID").val(ui.item.value);
                         
                          this.value = ui.item.label;
                          return false;
                      },
                  });
            });
            function showAccountSearch() {
                jQuery("#trAccount").show();
            }
    </script>

</asp:Content>

