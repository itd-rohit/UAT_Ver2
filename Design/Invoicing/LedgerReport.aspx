<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master"
    ClientIDMode="Static" AutoEventWireup="true" EnableEventValidation="true" CodeFile="LedgerReport.aspx.cs" Inherits="Design_Invoicing_LedgerReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

  
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />

   
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            
            <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />
            <div class="row">
                <div class="col-md-24">
                    <strong>Ledger Report
                    </strong>
                </div>
            </div>
            <div class="row" id="tblType">
                <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align: center;display:none;">
                    <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <div class="row trType PanelGroup" style="display: none">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Panel Group</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstPanelGroup" runat="server" CssClass="multiselect" onchange="BindPanelByGroup()" SelectionMode="Multiple"></asp:ListBox>
                </div>
            </div>
            <div class="row trType">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">TagBusiness Lab</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstTagBusinessLab" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                </div>
            </div>

            <div class="row trType">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select">
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">State </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlState" class="ddlState chosen-select" onchange="bindPanel()"></select>
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
                    <select id="ddl_panel" class="ddl_panel chosen-select"></select>
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
                    <asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>
                    <cc1:CalendarExtender runat="server" ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                </div>
                <div class="col-md-5">
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
                    <label class="pull-left">All</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:CheckBox ID="chkAllLedger" runat="server" Checked="false" onclick="chkLedger()" />
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPanelName" runat="server"></asp:TextBox>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Type
            </div>
           <div class="row"><div class="col-md-6"></div><div class="col-md-14">
                <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Summary (Not More Than 6 Month)" Value="Summary" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Detail (Not More Than 31 Days)" Value="Detail"></asp:ListItem>
                </asp:RadioButtonList>
                <input type="hidden" id="hdPanelID" />
            </div></div>
             <div class="row" id="divReport"><div class="col-md-12"></div><div class="col-md-12">
                <input type="button" value="Report" onclick="getReport();" class="searchbutton" />
                <input type="button" id="btnLedgerStatement" style="display: none" value="Ledger Statement" onclick="LedgerStatement();" class="searchbutton" />
            </div></div></div>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('#ddl_panel').trigger('chosen:updated');
            jQuery('[id*=lstTagBusinessLab]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            jQuery('[id*=lstPanelGroup]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            if (jQuery('#lblSearchType').text() == "1") {
                jQuery('#<%=lstTagBusinessLab.ClientID%> option').remove();
                jQuery('#lstTagBusinessLab').multipleSelect("refresh");
                serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindTagBusinessLab', {  }, function (response) {
                    jQuery("#lstTagBusinessLab").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery("#lstTagBusinessLab") });

                    jQuery('[id*=lstTagBusinessLab]').multipleSelect("checkAll");
                });
            }
            BindPanelByGroup();
        });       
        function hideSearchCriteria() {
            jQuery('.trType,#tblType').hide();
        }
        function hideSearchCriteria1() {
            jQuery('.trType').hide();
        }
        function hideReport() {
            jQuery('#divReport').hide();
        }
        function bindState() {
            jQuery("#ddlState option").remove();

            jQuery('#ddlState').trigger('chosen:updated');
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
            jQuery("#ddl_panel").empty();
            jQuery('#ddl_panel').trigger('chosen:updated');
            serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: jQuery('#lstTagBusinessLab').multipleSelect("getSelects").join(), PanelGroup: jQuery("#rblSearchType input[type=radio]:checked").next('label').text(), IsInvoicePanel: 2, BillingCycle: "0" }, function (response) {
                jQuery('#ddl_panel').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
            });
        }       
        function clearControl() {
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
           // jQuery('#ddlState,#ddl_panel').empty();
            jQuery('#ddlBusinessZone,#ddlState,#ddl_panel').trigger('chosen:updated');
        //  serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindPanel', { BusinessZoneID: 0, StateID: -1, SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: jQuery('#lstTagBusinessLab').multipleSelect("getSelects").join(), PanelGroup: '', IsInvoicePanel: 2, BillingCycle: "0" }, function (response) {
        //      jQuery("#ddl_panel").bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, defaultValue: "Select" });
        //
        //  });
            //------------
			
            //bindPanel();
            BindPanelByGroup();
			
          //  if (jQuery("#rblSearchType input[type=radio]:checked").val() == "7") {
            //    $('.PanelGroup').show();
            //} else {
              //  $('.PanelGroup').hide();
            //}
        }
        function getReport() {
            var PanelID = ""; var EntryTypeID = ""; var EntryType = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
                EntryType = jQuery("#hdPanelID").val().split('#')[1];
                EntryTypeID = jQuery("#hdPanelID").val().split('#')[2];
            }
            else if (!jQuery("#chkAllLedger").is(':checked') && jQuery("#ddl_panel").val() != null) {
                PanelID = jQuery("#ddl_panel").val().split('#')[0];
                EntryType = jQuery("#ddl_panel").val().split('#')[1];
                EntryTypeID = jQuery("#ddl_panel").val().split('#')[2];
            }
            else if (jQuery("#chkAllLedger").is(':checked')) {
                EntryType = jQuery("#rblSearchType input[type=radio]:checked").next().text();
                EntryTypeID = jQuery("#rblSearchType input[type=radio]:checked").val();
            }
            if ((PanelID == 0 || PanelID == null) && !jQuery("#chkAllLedger").is(':checked')) {
                toast("Error", 'Please Select Client Name');
                jQuery("#ddl_panel").focus();
                return;
            }

            var AllLedger = 0; var PanelName = jQuery("#ddl_panel option:selected").text();
            if (jQuery("#chkAllLedger").is(':checked') && jQuery("#chkAllLedger").is(':visible'))
                AllLedger = 1;
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelName = jQuery("#txtPanelName").val();
            }
            serverCall('LedgerReport.aspx/getReportData', { PanelName: PanelName, PanelID: PanelID, dtFrom: jQuery("#txtFromDate").val(), dtTo: jQuery("#txtToDate").val(), ClientType: EntryType, ClientTypeID: EntryTypeID, ReportType: jQuery("#rdoType input[type=radio]:checked").val(), password: "", AllLedger: AllLedger, IsPassword: 0 }, function (response) {
                 responseData(response);
            });

        }
function responseData(response) {
            var resultData = jQuery.parseJSON(response);
            if (resultData == "0") {
                toast("Error", 'No Record Found');
            }
            else if (resultData == "1") {
                window.open('../common/ExportToExcel.aspx');
                //   clearControl();
            }
            else if (resultData == "2") {
                toast("Error", 'Summary (Not More Than 6 Month) Allowed');
            }
            else if (resultData == "3") {
                toast("Error", 'Detail (Not More Than 31 Days');
            }

            else if (resultData == "5") {
                toast("Error", 'Please Enter Valid Password');
            }
            else if (resultData == "8") {
                confirmationBox();
            }
        }

    </script>
    <script type="text/javascript">
        function confirmationBox() {
            jQuery.confirm({
                title: 'Confirmation!',
                useBootstrap: false,
                closeIcon: true,
                columnClass: 'small',
                type: 'red',
                typeAnimated: true,
                animationBounce: 2,
                autoClose: 'cancel|20000',
                content: '' +
        '<form action="" class="formName" >' +
        '<div class="form-group" >' +
        '<label>Enter Password :&nbsp;</label>' +
        '<input type="password" placeholder="Password" class="name form-control" required />' +
        '</div>' +
        '</form>',
                buttons: {
                    formSubmit: {
                        text: 'Submit',
                        btnClass: 'btn-blue',
                        useBootstrap: false,
                        type: 'red',
                        typeAnimated: true,
                        autoClose: 'cancel|10000',
                        action: function () {

                            var name = this.$content.find('.name').val();
                            if (!name) {
                                alert('Please Enter Password');
                                this.$content.find('.name').focus();
                                return false;
                            }

                            var AllLedger = 0; var PanelName = jQuery("#ddl_panel option:selected").text();
                            if (jQuery("#chkAllLedger").is(':checked') && jQuery("#chkAllLedger").is(':visible'))
                                AllLedger = 1;

                            var PanelID = ""; var EntryType = ""; var EntryTypeID = "";
                            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                                PanelID = jQuery("#hdPanelID").val().split('#')[0];
                                EntryType = jQuery("#hdPanelID").val().split('#')[1];
                                EntryTypeID = jQuery("#hdPanelID").val().split('#')[2];
                            }
                            else if (!jQuery("#chkAllLedger").is(':checked') && jQuery("#ddl_panel").val() != null) {
                                PanelID = jQuery("#ddl_panel").val().split('#')[0];
                                EntryType = jQuery("#ddl_panel").val().split('#')[1];
                                EntryTypeID = jQuery("#ddl_panel").val().split('#')[2];
                            }
                            if ((PanelID == 0 || PanelID == null) && !jQuery("#chkAllLedger").is(':checked')) {
                                toast("Error", 'Please Select Client Name');
                                jQuery("#ddl_panel").focus();
                                return;
                            }
                            var PanelName = jQuery("#ddl_panel option:selected").text();

                            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                                PanelName = jQuery("#txtPanelName").val();
                            }
                            serverCall('LedgerReport.aspx/getReportData', { PanelName: PanelName, PanelID: PanelID, dtFrom: jQuery("#txtFromDate").val(), dtTo: jQuery("#txtToDate").val(), ClientType: EntryType, ClientTypeID: EntryTypeID, ReportType: jQuery("#rdoType input[type=radio]:checked").val(), password:name, AllLedger: AllLedger, IsPassword: 1 }, function (response) {
                                responseData(response);

                            });
                        }
                    },
                    cancel: function () {
                        //close
                    },

                },
                onContentReady: function () {
                    // bind to events
                    var jc = this;
                    this.$content.find('form').on('submit', function (e) {
                        // if the user submits the form by pressing enter in the field.
                        e.preventDefault();
                        jc.$$formSubmit.trigger('click'); // reference the button and click it
                    });
                }
            });
        }
    </script>
    <script type="text/javascript">
        function chkLedger() {
            if (jQuery("#chkAllLedger").is(':checked')) {
                clearControl();

                jQuery('#rdoType input[value="Detail"]').prop('checked', 'checked');
                jQuery('#rdoType input[type=radio],#ddlBusinessZone').attr('disabled', 'disabled');
            }
            else {
                jQuery('#rdoType input[type=radio],#ddlBusinessZone').removeAttr('disabled');
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
                      jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=LedgerPanel", {
                          SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(),
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
        function LedgerStatement() {
            var PanelID = ""; var PanelType = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
                PanelType = jQuery("#hdPanelID").val().split('#')[1];
            }
            else if (jQuery("#ddl_panel").val() != null) {
                PanelType = jQuery("#ddl_panel").val().split('#')[1];
                PanelID = jQuery("#ddl_panel").val().split('#')[0];
            }

            if (PanelID == 0 || PanelID == null) {
                toast("Error", 'Please Select Client Name');
                jQuery("#ddl_panel").focus();
                return;
            }
            serverCall('LedgerReport.aspx/encryptData', { PanelID: PanelID, Type: PanelType }, function (response) {
                var result1 = jQuery.parseJSON(response);
                window.open('LedgerStatement.aspx?ClientID=' + result1[0] + '&Type=' + result1[1] + '');
            });          
        }     
    </script>
    <script type="text/javascript">
        $('#lstTagBusinessLab').on('change', function () {
            serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindPanel', { BusinessZoneID: $('#ddlBusinessZone').val(), StateID: -1, SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: jQuery('#lstTagBusinessLab').multipleSelect("getSelects").join(), PanelGroup: '', IsInvoicePanel: 2, BillingCycle: "0" }, function (response) {
                jQuery("#ddl_panel").bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, defaultValue: "Select" });
            });
        });
        $(function () {
            BindPanelByGroup();
        });
        function bindsalespanel() {
            if ($("#lblSearchType").text() == "2") {
                serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesChildNode', { SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), IsInvoicePanel: 0 }, function (response) {
                    jQuery("#ddl_panel").bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, defaultValue: "Select" });
                });
            }
            else if ($("#lblSearchType").text() == "3") {
                serverCall('../Invoicing/Services/Panel_Invoice.asmx/SalesCentreAccess', {IsInvoicePanel:2}, function (response) {
                  if(JSON.parse(response).length==1)
                      jQuery("#ddl_panel").bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
                  else
                    jQuery("#ddl_panel").bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, defaultValue: "Select" });
                });
            }
        }

        function BindPanelByGroup() {
            //clearControl();
            var PanelGroupId = $('[id$=lstPanelGroup]').val().toString();
            //if (PanelGroupId != '') {
                jQuery('#ddl_panel option').remove();
                jQuery('#ddl_panel').trigger('chosen:updated');
                serverCall('LedgerReport.aspx/BindPanelByGroup', { PanelGroupId: 0 }, function (response) {
                    if ('<%=UserInfo.LoginType%>' == 'PCC' || '<%=UserInfo.LoginType%>' == 'SUBPCC')
                        jQuery('#ddl_panel').bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
                    else
                        jQuery('#ddl_panel').bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true, defaultValue: "Select" });


                });
           // }
        }

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
            //bindState();
        });
    </script>

</asp:Content>

