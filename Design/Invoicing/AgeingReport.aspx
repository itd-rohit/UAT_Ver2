<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" EnableEventValidation="false" CodeFile="AgeingReport.aspx.cs" Inherits="Design_Invoicing_AgeingReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .red {
            background-color: red !important;
            color: #fff !important;
            font-weight: 600;
        }
    </style>
      <style type="text/css">
    #showData th {
    background-color: #09f;
    color: #fff;
    padding: 2px;
   
    font-size:10px;
    }
     #showData td {
    background-color: #fff;
    color: #000;
    padding: 2px;
   
 text-align:left;
font-size:10px;
    }
</style>
    <div id="Pbody_box_inventory">
        <asp:Label ID="lblIsSalesTeamMember" runat="server" Style="display: none" Text="0" ClientIDMode="Static"></asp:Label>
        <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />

            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Ledger Status Ageing Report </b>
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
            <div class="row trType">
                <div class="col-md-3">
                </div>
                <div class="col-md-3 trType">
                    <label class="pull-left">Sales Manager</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 trType">
                    <asp:ListBox ID="lstSalesManager" runat="server" CssClass="multiselect" SelectionMode="Multiple" onchange="bindPanel();"></asp:ListBox>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select" ClientIDMode="Static"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()" class="ddlState chosen-select" ClientIDMode="Static"></asp:DropDownList>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                </div>
            </div>
            <div class="row" id="trAccount" style="display: none">
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
                    <asp:TextBox ID="txtPanelName" runat="server"></asp:TextBox>
                    <input type="hidden" id="hdPanelID" />
                </div>
            </div>
            <div class="row" id="trIncludeCurrentMonthBusiness">
                <div class="col-md-1">
                </div>
                <div class="col-md-5">
                    <label class="pull-left">Include Current Month Business</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkIncludeCurretMonth" />
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Report Format</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Month Wise" Value="1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Day Wise" Value="2"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSearch" class="searchbutton" onclick="searchLedger()" value="Search" />
            <input type="button" id="btnExport" class="searchbutton" onclick="ExportLedger()" value="Export to Excel" />
        </div>
        <div class="POuter_Box_Inventory" id="tblViewReportData" style="text-align: center; max-height: 350px; overflow-x: auto; display: none;">
            <div class="Purchaseheader">
                Details                 
                <span style="color: red; margin-left: 57px;">Total Outstanding:</span><span id="spnTotalOS">0</span>
                

            </div>
            <div id="showData">
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function ShowTotalAmount() {
            var Outstanding = 0;
            var creditOs = 0;
            for (var i = 0; i < $('#tblItems tr').length; i++) {
                if (i > 0) {
                    Outstanding += parseInt($('#tblItems tr').eq(i).find('td').eq(5).text());
                    
                }
            }
            $('#spnTotalOS').text(Outstanding);
           
        }

        function bindState() {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
             jQuery('#lstPanel').multipleSelect("refresh");
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
        function bindPanel() {
            var SearchType = $('[id$=lblSearchType]').text();
            var SalesManager = $('[id$=lstSalesManager]').val().toString();
            if (SearchType == "1") {
                serverCall('AgeingReport.aspx/BindPanel', { BusinessZoneID: $("#ddlBusinessZone").val(), StateID: $("#ddlState").val(), SearchType: $("#rblSearchType input[type=radio]:checked").val(), SalesManager: SalesManager,PanelGroup:jQuery("#rblSearchType input[type=radio]:checked").next('label').text() }, function (response) {
                    onSuccessPanel(response);
                });
            }
            if (SearchType == "2") {
                serverCall('AgeingReport.aspx/SalesChildNode', { SearchType: $("#rblSearchType input[type=radio]:checked").val(), SalesManager: SalesManager }, function (response) {
                    onSuccessPanel(response);
                });
            }
            if (SearchType == "4") {
                serverCall('AgeingReport.aspx/bindRegionalClient', { BusinessZoneID: $("#ddlBusinessZone").val(), StateID: $("#ddlState").val(), SearchType: $("#rblSearchType input[type=radio]:checked").val(), SalesManager: SalesManager }, function (response) {
                    onSuccessPanel(response);
                });
            }
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
            jQuery('#ddlCity_chosen').hide();
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
            
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
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
             if ($("#lblSearchType").text() == "2") {
                 serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesChildNode', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), IsInvoicePanel: 2 }, function (response) {
                     onSuccessPanel(response);
                 });
             }
             else if ($("#lblSearchType").text() == "3") {
                 serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesCentreAccess', { IsInvoicePanel: 2 }, function (response) {
                     onSuccessPanel(response);
                 });
             }
         }
         $(function () {
             if ($("#lblSearchType").text() == "3") {
                 serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesCentreAccess', { IsInvoicePanel: 2 }, function (response) {
                     onSuccessPanel(response);
                 });
             }
         });
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
            if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked')) {
                toast('Error', 'Please Select Client Name');
                return;
            }

            var SalesManager = $('[id$=lstSalesManager]').val().toString();
            var IncludeCurrentMonthBusiness = $('#chkIncludeCurretMonth').is(':checked') ? 1 : 0;
            var ReportFormat = $('[id$=rdoReportFormat] input:checked').val();
            serverCall('AgeingReport.aspx/searchLedger', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PanelID: PanelID, SalesManager: SalesManager, IncludeCurrentMonthBusiness: IncludeCurrentMonthBusiness, Type: "View", ReportFormat: ReportFormat }, function (response) {
                if (response != null) {
                    var data = $.parseJSON(response);
                    if (data.length > 0) {
                        $('#tblViewReportData').show();
                        var myData = $.parseJSON(response);
                        var col = [];
                        for (var i = 0; i < myData.length; i++) {
                            for (var key in myData[i]) {
                                if (col.indexOf(key) === -1) {
                                    col.push(key);
                                }
                            }
                        }
                        var table = document.createElement("table");
                        var tr = table.insertRow(-1);
                        for (var i = 0; i < col.length; i++) {
                            var th = document.createElement("th");
                            th.innerHTML = col[i];
                            tr.appendChild(th);
                        }
                        for (var i = 0; i < myData.length; i++) {
                            tr = table.insertRow(-1);
                            for (var j = 0; j < col.length; j++) {
                                var tabCell = tr.insertCell(-1);
                                tabCell.innerHTML = myData[i][col[j]];
                            }
                        }
                        var divContainer = document.getElementById("showData");
                        divContainer.innerHTML = "";
                        divContainer.appendChild(table);
                        $('#showData').find('table').attr('id', 'tblItems');
                        $('[id$=tblItems] td').each(function () {
                            var CellValue = parseInt($(this).text());
                            if (CellValue != NaN && CellValue < 0) {
                                $(this).addClass('red');
                            }
                        });
                        ShowTotalAmount();
                    }
                    else {
                        toast("Info", 'No Record Found');
                        $('#tblViewReportData').hide();
                    }
                }
                else {
                    toast("Info", 'No Record Found');
                    $('#tblViewReportData').hide();
                }
            });
        }
        function ExportLedger() {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery.trim(jQuery("#txtPanelName").val()) != "")
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
            else if (jQuery("#chkAllLedger").is(':checked') && jQuery("#chkAllLedger").is(':visible'))
                PanelID = "";
            else
                PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            if (PanelID == "" && !jQuery("#chkAllLedger").is(':checked')) {
                toast('Error', 'Please Select Client Name');
                return;
            }
            var SalesManager = $('[id$=lstSalesManager]').val().toString();
            var IncludeCurrentMonthBusiness = $('#chkIncludeCurretMonth').is(':checked') ? 1 : 0;
            var ReportFormat = $('[id$=rdoReportFormat] input:checked').val();
            serverCall('AgeingReport.aspx/searchLedger', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PanelID: PanelID, SalesManager: SalesManager, IncludeCurrentMonthBusiness: IncludeCurrentMonthBusiness, Type: "Download", ReportFormat: ReportFormat }, function (response) {
                if (response == "1") {
                    window.open('../Common/ExportToExcel.aspx');
                } else {
                    toast('Error', "No Data Found");
                }
            });
        }
    </script>
    <script type="text/javascript">
        function exportReport() {

            $("#tblLedger").remove(".noExl").table2excel({
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
                    $(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }

                jQuery("#hdPanelID").val('');
                if (jQuery("#rblSearchType input[type=radio]:checked").val() == "2")
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
        function bindSalesPanel() {

            jQuery('.trType,#trAccount').hide();
            jQuery('[id*=lstSalesManager]').hide();
            Panel_Invoice.SalesChildNode(jQuery("#rblSearchType input[type=radio]:checked").val(), onSuccessPanel, OnfailurePanel);
        }
        function hideSearchCriteria() {
            jQuery('.trType,#tblType,#trAccount').hide();
            jQuery('[id*=lstSalesManager]').hide();
            jQuery('[id$=tblSearchPanel]').hide();
            jQuery('[id$=trIncludeCurrentMonthBusiness]').hide();
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            salesManager();
        });
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
    </script>

</asp:Content>

