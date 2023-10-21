<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="ClientDepositReport.aspx.cs" Inherits="Design_Invoicing_ClientDepositReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/UserControl/InvoiceSearch.ascx" TagPrefix="uc1" TagName="InvoiceSearch" %>
<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

  <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
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
               jQuery(selector).chosen(config[selector]);
           }
          
       });
   </script>
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />

            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <strong>Client Deposit Report<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="All" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Pending" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Approve" Value="2" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Reject" Value="3"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Centre Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="rblSearchType" runat="server" ClientIDMode="Static" onchange="clearControl()">
                    </asp:DropDownList>

                </div>
                  </div>

                <div class="row trType">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Business Zone</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select" ClientIDMode="Static"></asp:DropDownList>
                    </div>
                    <div class="col-md-2">
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
                    <div class="col-md-6">
                        <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Date Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <asp:RadioButtonList ID="rbtnDateType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Deposit Date"  Value="Deposit"></asp:ListItem>
                            <asp:ListItem Text="Entry Date" Selected="True" Value="Entry"></asp:ListItem>
                            <asp:ListItem Text="Validate Date" Value="Validate"></asp:ListItem>

                        </asp:RadioButtonList>
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
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                </div>
                    <div class="col-md-3">
                        <label class="pull-left">To Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />

                    </div>
                </div>

                <div class="row" id="trAccount" style="display: none">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">All Client</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:CheckBox ID="chkClient" runat="server" Checked="false" onclick="chkAllClient()" />
                    </div>
                    <div class="col-md-2">
                </div>
                    <div class="col-md-3">
                        <label class="pull-left">Client Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtPanelName" runat="server"></asp:TextBox>
                        <input type="hidden" id="hdPanelID" />
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align:center">
               
                    <input type="button" value="Report" onclick="getReport();" class="searchbutton" />
              
            </div>

        </div>
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
            jQuery(function () {
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        });
    </script>
        <script type="text/javascript">
            function bindState() {
                jQuery("#ddlState option").remove();
                jQuery('#ddlState').trigger('chosen:updated');
                jQuery('#<%=lstPanel.ClientID%> option').remove();
                jQuery('#lstPanel').multipleSelect("refresh");
                if (jQuery("#ddlBusinessZone").val() != 0)
                    serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: 0, BusinessZoneID: jQuery("#ddlBusinessZone").val() }, function (response) {
                        onSucessState(response);
                    });



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
                if ($("#ddlCity option[value='-1']").length == 0)
                    jQuery("#ddlCity").append(jQuery("<option></option>").val("-1").html("All"));

            }
            function onFailureState() {


            }
            $(function () {
              // if (jQuery("#lblSearchType").text() == "3") {              
              //     serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesCentreAccess', {IsInvoicePanel:2}, function (response) {
              //         onSuccessPanel(response);
              //     });
              // }
              // else if (jQuery("#lblSearchType").text() == "2") {
              //     serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesChildNode', {SearchType:jQuery("#rblSearchType").val(), IsInvoicePanel: 2 }, function (response) {
              //         onSuccessPanel(response);
              //
              //     });                  
              // }
              // else if (jQuery("#lblSearchType").text() == "4") {
              //     serverCall('ClientDepositReport.aspx/bindPanel', { BusinessZoneID: 0,StateID:0,SearchType:0 }, function (response) {
              //         onSuccessPanel(response);
              //     });
              //     
              //
                // }
                bindPanel();
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
                    SearchType = jQuery("#rblSearchType").val();

                }
                serverCall('ClientDepositReport.aspx/bindPanel', { BusinessZoneID: 0, StateID:  0, SearchType: SearchType }, function (response) {
                    onSuccessPanel(response);
                });
               

            }
            function onSuccessPanel(result) {
                var panelData = jQuery.parseJSON(result);
                if (panelData != null) {
                    for (i = 0; i < panelData.length; i++) {
                        jQuery("#lstPanel").append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                    }
                    jQuery('[id*=lstPanel]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    if (panelData.length == 1)
                        jQuery('[id*=lstPanel]').multipleSelect("checkAll");
                }
                jQuery('#lstPanel').multipleSelect("refresh");
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
                    toast("Error",'Please Select Client Name');
                    jQuery("#ddl_panel").focus();
                    return;
                }
                var AllClient = 0;
                if (jQuery("#chkClient").is(':checked') && jQuery("#chkClient").is(':visible'))
                    AllClient = 1;
                if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                    PanelName = jQuery("#txtPanelName").val();
                }
                serverCall('ClientDepositReport.aspx/getReportData', { PanelID: PanelID, FromDate: jQuery("#txtFromDate").val(), ToDate: jQuery("#txtToDate").val(), Type: jQuery("#rblType input[type=radio]:checked").val(), AllClient: AllClient, DateType: jQuery("#rbtnDateType input[type=radio]:checked").val() }, function (response) {
                    PostFormData(response, response.ReportPath);
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
                              SearchType: jQuery("#rblSearchType").val(),
                              PanelName: request.term,
                              IsInvoicePanel:2
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
                jQuery('#ddlState,#ddlCity').empty();
                jQuery('#ddlBusinessZone,#ddlState,#ddlCity,#ddlCity').trigger('chosen:updated');
                jQuery('#lstPanel option').remove();
                jQuery('#lstPanel').multipleSelect("refresh");
            }
        </script>
</asp:Content>

