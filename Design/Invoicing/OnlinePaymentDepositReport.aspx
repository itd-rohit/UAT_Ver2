<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OnlinePaymentDepositReport.aspx.cs" Inherits="Design_Invoicing_OnlinePaymentDepositReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    
    <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Client Online Deposit Report<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />
            <div class="row" id="tblType">
                 <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align: center">
                  <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" />
            </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria
            </div>
             <div class="row">
                <div class="col-md-3">
                </div>
            <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select" ClientIDMode="Static"></asp:DropDownList>
                </div>
                 <div class="col-md-1">
                </div>
                  <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()" class="ddlState chosen-select" ClientIDMode="Static"></asp:DropDownList>
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
                 </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                    </div>
                 <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                    </div>
                </div>
             

            <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">All Client</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                     <asp:CheckBox ID="chkClient" runat="server" Checked="false" onclick="chkAllClient()" />
                    </div>
             <div class="col-md-3"></div>
             <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                     <asp:TextBox ID="txtPanelName" runat="server" Width="320px"></asp:TextBox>
                        <input type="hidden" id="hdPanelID" />
                    </div>           
        </div>
 <div class="POuter_Box_Inventory" style="text-align:center">            
                    <input type="button" value="Report" onclick="getReport();" class="searchbutton" />    
            </div>
    </div>
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
           
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });

                bindState();
        });
   
        function bindState() {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
         //   if (jQuery("#ddlBusinessZone").val() != 0)
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
        $(function () {
            if (jQuery("#lblSearchType").text() == "3") {
                PageMethods.bindPanel("0", "0", onSuccessPanel, OnfailurePanel);
            }
            else if (jQuery("#lblSearchType").text() == "2") {
                PageMethods.bindPanel("0", jQuery("#rblSearchType input[type=radio]:checked").val(), onSuccessPanel, OnfailurePanel);
            }
        });
        function clearControl() {
            jQuery('#txtPanelName').val('');
        }
        function chkAllClient() {
            if (jQuery("#chkClient").is(':checked')) {
                jQuery('#ddlBusinessZone').attr('disabled', 'disabled');
            }
            else {
                jQuery('#ddlBusinessZone').removeAttr('disabled');
            }
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
        }
        function bindPanel() {
            jQuery('#lstPanel option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            var SearchType = 0;
            if (jQuery("#lblSearchType").text() != "3") {
                SearchType = jQuery("#rblSearchType input[type=radio]:checked").val();
            }
            PageMethods.bindPanel(jQuery("#ddlBusinessZone").val(), jQuery("#ddlState").val(), SearchType, onSuccessPanel, OnfailurePanel);
        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            if (panelData != null) {
                for (i = 0; i < panelData.length; i++) {
                    jQuery("#lstPanel").append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('#lstPanel').multipleSelect("refresh");
            }
        }
        function OnfailurePanel(result) {

        }
    </script>
    <script type="text/javascript">
        function getReport() {
            var PanelID = ""; var EntryType = "";
            var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
            }
            if ((PanelID == 0 || PanelID == null) && !jQuery("#chkClient").is(':checked')) {
                toast('Error', 'Please Select Client Name');
                jQuery("#ddl_panel").focus();
                return;
            }
            var AllClient = 0;
            if (jQuery("#chkClient").is(':checked') && jQuery("#chkClient").is(':visible'))
                AllClient = 1;
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelName = jQuery("#txtPanelName").val();
            }
            serverCall('OnlinePaymentDepositReport.aspx/getReportData', { PanelID: PanelID, FromDate: $("#txtFromDate").val(), ToDate: $("#txtToDate").val(), AllClient: AllClient }, function (response) {
               
                if (response == "0") {
                    toast('Info', 'No Record Found');
                }
                else if (response == "1") {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast('Error', 'Error');
                }
            });
        }
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
                          PanelName: request.term
                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = this.value;
                      if (term.length < 5) {
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
        function hideSearchCriteria() {
            jQuery('.trType,#divSearch,#tblType').hide();
        }
        function hideSearchCriteria1() {
            jQuery('.trType').hide();
        }
        function showAccountSearch() {
            jQuery("#trAccount").show();
        }
        function clearControl() {
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
           // jQuery('#ddlState,#ddlCity').empty();
            jQuery('#ddlBusinessZone,#ddlState,#ddlCity,#ddlCity').trigger('chosen:updated');
            jQuery('#lstPanel option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
        }
    </script>
</asp:Content>

