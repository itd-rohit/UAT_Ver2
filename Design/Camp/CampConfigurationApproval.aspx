<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampConfigurationApproval.aspx.cs" Inherits="Design_Camp_CampConfigurationApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Camp Configuration Count Approval </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select"></asp:DropDownList>

                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">State </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:DropDownList ID="ddlState" runat="server" onchange="bindClient()" class="ddlState chosen-select"></asp:DropDownList>

                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Financial Year  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlFinacial" runat="server" CssClass="chosen-select" onchange="$clearDiv()">
                    </asp:DropDownList>
                    <span id="spnFinacialYear" style="display: none"></span>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">Client Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstClientType" runat="server" CssClass="multiselect" SelectionMode="Multiple" onchange="bindClient()"></asp:ListBox>

                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Tag Business Lab</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstTagBusinessLab" runat="server" CssClass="multiselect" SelectionMode="Multiple" onchange="bindClient()"></asp:ListBox>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">Client Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstClient" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>

                </div>

                <div class="col-md-2">
                    <label class="pull-left">Status </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" onchange="$clearDiv();">
                        <asp:ListItem Value="0" Selected="True">Pending</asp:ListItem>
                        <asp:ListItem Value="1">Approved</asp:ListItem>
                        <asp:ListItem Value="-1">All</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-3">&nbsp;</div>
                 <div class="col-md-1" style="background-color:#FFFFFF;height: 20px;width:2%;border:1px solid black;cursor:pointer;" 
                     ></div>
                    <div class="col-md-2" style="text-align:left">Pending</div>    
                <div class="col-md-1" style="background-color: #CEC; height: 20px; width: 2%; border: 1px solid black; cursor: pointer;">
                </div>
                <div class="col-md-3" style="text-align: left">
                    Approved
                </div>
                <div class="col-md-14" style="text-align: left">
                    <input type="button" value="Search" class="searchbutton" onclick="$bindDetail(0)" id="btnSearch" />
                    <input type="button" value="Download Excel" class="searchbutton" onclick="$bindDetail(1)" id="btnDownload" style="display: none" />
                    <input type="button" value="Cancel" onclick="$clearControl()" class="resetbutton" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="divData" class="handsontable htRowHeaders htColumnHeaders" style="height: 315px; overflow: hidden; width: 100%;">
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display: none" id="divSave">
            <input type="button" id="btnApprove" value="Approve" onclick="$approveCampConfig()" class="savebutton" />
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
                jQuery(selector).chosen(config[selector]);
            }
            jQuery(function () {
                jQuery('#lstClient,#lstClientType,#lstTagBusinessLab').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        });
    </script>
    <script type="text/javascript">
        bindState = function () {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').trigger('chosen:updated');
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
            if (jQuery("#ddlBusinessZone").val() != 0)
                serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: 0, BusinessZoneID: jQuery("#ddlBusinessZone").val() }, function (response) {
                    jQuery("#ddlState").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                    if (jQuery("#ddlState option").length > 0) {
                        jQuery("#ddlState").eq(1).before($("<option></option>").val("-1").text("All"));
                    }
                    jQuery('#ddlState').trigger('chosen:updated');
                });
        }
        bindClient = function () {
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");

            serverCall('CampConfigurationMaster.aspx/bindClient', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), ClientTypeID: jQuery('#lstClientType').val().toString(), TagBusinessLabID: jQuery('#lstClientType').val().toString() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var clientData = jQuery.parseJSON($responseData.responseDetail);
                    jQuery("#lstClient").bindMultipleSelect({ data: clientData, valueField: 'ClientID', textField: 'ClientName', controlID: jQuery("#lstClient") });
                }
                else {

                }
            }, '', false);

        }
        $clearDiv = function () {
            jQuery('#divSave,#btnDownload').hide();
            jQuery('#divData').empty();
        }
        $clearControl = function () {
            jQuery('#divSave,#btnDownload').hide();
            jQuery('#divData').empty();
            jQuery('#lstState option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            jQuery('#lstClientType').multipleSelect("setSelects", []);
            jQuery('#lstClientType').val('').trigger('chosen:updated');
            jQuery('#lstTagBusinessLab').multipleSelect("setSelects", []);
            jQuery('#lstTagBusinessLab').val('').trigger('chosen:updated');

            jQuery('#ddlFinacial,#ddlBusinessZone').prop('selectedIndex', '0');
            jQuery('#ddlFinacial,#ddlBusinessZone').trigger('chosen:updated');
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
        }
        var hot2;
        var Operations = {};
        $bindDetail = function (SearchType) {
            if (jQuery("#ddlFinacial").val() == 0) {
                jQuery("#ddlFinacial").focus();
                toast('Error', 'Please Select Finacial Year');
                return;
            }
            var ClientID = jQuery('#lstClient').val().toString();
            if (ClientID == "" && jQuery('#rblStatus input:checked').val() != 0) {
                jQuery('#lstClient').focus();
                toast('Error', 'Please Select Client Name');
                return;
            }
            var userContext = { FinacialDetail: jQuery("#ddlFinacial").val(), SearchType: SearchType };
            serverCall('CampConfigurationApproval.aspx/bindDetail', { FinancialYear: jQuery("#ddlFinacial").val(), ClientID: ClientID, SearchType: SearchType, Status: jQuery('#rblStatus input:checked').val() }, function (response) {
                if (userContext.SearchType == 0) {
                    jQuery('#divData').html('');
                }
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    jQuery('#divSave,#btnDownload').show();
                    var FinacialYear = userContext.FinacialDetail;
                    jQuery('#spnFinacialYear').text(FinacialYear);
                    if (userContext.SearchType == 0) {
                        CampConfigData = jQuery.parseJSON($responseData.responseDetail);
                        var data = CampConfigData,
                        container2 = document.getElementById('divData');
                        hot2 = new Handsontable(container2, {
                            data: CampConfigData,
                            colHeaders: [
                                  "S.No.", "<input type='checkbox' onclick='selectall(this)'/>", "TagBusinessLab", "ClientType", "ClientCode", "ClientName", "April", "May", "June", "July", "August", "September", "October", "November", "December", "January", "February", "March", "Total"
                            ],
                            columns: [
                                 { renderer: AutoNumberRenderer, width: '60px', readOnly: true },
                                 {
                                     data: 'ApprovedStatus',
                                     renderer: CheckBoxrender,
                                 },
                                 { data: 'TagBusinessLab', readOnly: true, className: "htLeft", renderer: approved },
                                 { data: 'ClientType', readOnly: true, className: "htLeft", renderer: approved },
                                 { data: 'ClientCode', readOnly: true, className: "htLeft", renderer: approved },
                                 { data: 'ClientName', readOnly: true, className: "htLeft", renderer: approved },
                                 { data: 'Apr', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'May', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Jun', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Jul', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Aug', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Sep', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Oct', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Nov', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Dec', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Jan', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Feb', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Mar', type: 'numeric', format: '0', readOnly: false, allowInvalid: false, renderer: CampConfigTotal },
                                 { data: 'Total', type: 'numeric', format: '0', readOnly: true, allowInvalid: false, renderer: CampTotal },

                            ],
                            stretchH: "all",
                            fixedColumnsLeft: 6,
                            autoWrapRow: false,
                            minSpareRows: 1,
                            fillHandle: false,
                            rowHeaders: false,
                            maxRows: CampConfigData.length,
                            contextMenu: true,
                            autoColumnSize: true,
                            manualColumnResize: true,
                            manualRowResize: true,
                            colWidths: [30, 30, 120, 120, 80, 220, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 100],
                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                if (row === CampConfigData.length - 1) {
                                    cellProperties.readOnly = true;
                                    cellProperties.className = 'selected-td';
                                }
                                return cellProperties;
                            },
                        });
                        hot2.render();
                    }
                    else {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                }
                else {
                    toast('Error', $responseData.response);
                    jQuery('#divData').empty();
                }
            })
        }
        function CheckBoxrender(instance, td, row, col, prop, value, cellProperties) {
            if (CampConfigData[row].ApprovedStatus == "0" && row != CampConfigData.length - 1) {
                td.innerHTML = "<input onclick='chkCamp(this)' class= '" + CampConfigData[row].ID + " clCamp' type='checkbox'/> ";
            }

            else {
                td.innerHTML = "";
            }
            if (CampConfigData[row].ApprovedStatus == "1") {
                td.style.fontWeight = 'bold';
                cellProperties.readOnly = true;
                cellProperties.className = 'approved-td';
                td.setAttribute("style", "background-color:#CEC;text-align:left;font-weight: bold");
            }
            else {
                if (row === CampConfigData.length - 1) {
                    td.setAttribute("style", "background-color:#CC99FF;text-align:left;");
                }
            }
            return td;
        }
        function chkCamp(ctrl) {
            var chk = jQuery(ctrl).attr("class").split(' ')[0];

            if (jQuery(ctrl).is(":checked")) {
                jQuery('.' + chk).attr('checked', true);
                for (var i = 0; i < CampConfigData.length; i++) {
                    if (CampConfigData[i].ID == chk) {
                        CampConfigData[i].IsApproved = "2";
                    }
                }
            }
            else {

                jQuery('.' + chk).attr('checked', false);
                for (var i = 0; i < CampConfigData.length; i++) {
                    if (CampConfigData[i].ID == chk) {
                        CampConfigData[i].IsApproved = "0";
                    }
                }
            }
        }
        selectall = function (rowID) {
            if (jQuery(rowID).is(':checked')) {
                jQuery('.clCamp').prop('checked', 'checked');

                for (var i = 0; i < CampConfigData.length; i++) {
                    if (CampConfigData[i].ApprovedStatus == 0) {
                        CampConfigData[i].IsApproved = "2";
                    }
                }
            }
            else {
                for (var i = 0; i < CampConfigData.length; i++) {
                    if (CampConfigData[i].ApprovedStatus == 0) {
                        CampConfigData[i].IsApproved = "0";
                    }
                }
                jQuery('.clCamp').prop('checked', false);

            }
        }
        approved = function (instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = value;
            if (CampConfigData[row].ApprovedStatus == "1") {
                td.style.fontWeight = 'bold';
                cellProperties.readOnly = true;
                cellProperties.className = 'approved-td';
                td.setAttribute("style", "background-color:#CEC;text-align:left;font-weight: bold");
            }
            else {
                if (row === CampConfigData.length - 1) {
                    td.setAttribute("style", "background-color:#CC99FF;text-align:left;font-weight: bold");
                }
                else
                    td.setAttribute("style", "text-align:left;font-weight: bold");
            }
            return td;
        }
        AutoNumberRenderer = function (instance, td, row, col, prop, value, cellProperties) {
            if (row === CampConfigData.length - 1) {
                td.innerHTML = '';
                td.style.background = '#CC99FF';
            }
            else {
                var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';
                //if (CampConfigData[row].ApprovedStatus == "0") {
                //    MyStr = MyStr + "<input type='checkbox' class= 'clCamp'/> ";
                //}
                //else {
                //    MyStr = MyStr + "&nbsp;&nbsp;&nbsp;";
                //}
                td.innerHTML = MyStr;
            }
            if (CampConfigData[row].ApprovedStatus == "1") {
                cellProperties.readOnly = true;
                td.style.fontWeight = 'bold';
                td.style.background = '#CEC';
            }
            return td;
        }
        function CampConfigTotal(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.NumericRenderer.apply(this, arguments);
            if (row === CampConfigData.length - 1) {
                var t = CampConfigData.length - 1;
                var Total = 0;
                for (var k = 0; k < t; k++) {
                    var rowTotal = 0;
                    if (CampConfigData[k][prop] != "")
                        rowTotal = parseInt(CampConfigData[k][prop]);
                    Total = parseInt(Total) + parseInt(rowTotal);
                }
                td.innerHTML = Total;
                td.style.fontWeight = 'bold';
            }
            else {
                td.innerHTML = value;
            }
            if (CampConfigData[row].ApprovedStatus == "1") {
                td.style.fontWeight = 'bold';
                cellProperties.readOnly = true;
                cellProperties.className = 'approved-td';
            }
            else {

            }
            return td;
        }
        function CampTotal(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.NumericRenderer.apply(this, arguments);
            td.style.fontWeight = 'bold';
            td.style.background = '#CC99FF';
            td.className = "htRight";
            if (row === CampConfigData.length - 1) {
                var t = CampConfigData.length - 1;
                var Total = 0;
                for (var k = 0; k < t; k++) {
                    var rowTotal = 0;
                    var rowTotal = 0;
                    if (CampConfigData[k][prop] != "")
                        rowTotal = parseInt(CampConfigData[k][prop]);
                    Total = parseInt(Total) + parseInt(rowTotal);
                }
                td.innerHTML = Total;
            }
            else {
                var Apr = 0; var May = 0; var Jun = 0; var Jul = 0; var Aug = 0; var Sep = 0; var Oct = 0; var Nov = 0; var Dec = 0; var Jan = 0; var Feb = 0; var Mar = 0;
                if (instance.getDataAtCell(row, 6) != "")
                    Apr = parseInt(instance.getDataAtCell(row, 6));
                if (instance.getDataAtCell(row, 7) != "")
                    May = parseInt(instance.getDataAtCell(row, 7));
                if (instance.getDataAtCell(row, 8) != "")
                    Jun = parseInt(instance.getDataAtCell(row, 8));
                if (instance.getDataAtCell(row, 9) != "")
                    Jul = parseInt(instance.getDataAtCell(row, 9));
                if (instance.getDataAtCell(row, 10) != "")
                    Aug = parseInt(instance.getDataAtCell(row, 10));
                if (instance.getDataAtCell(row, 11) != "")
                    Sep = parseInt(instance.getDataAtCell(row, 11));
                if (instance.getDataAtCell(row, 12) != "")
                    Oct = parseInt(instance.getDataAtCell(row, 12));
                if (instance.getDataAtCell(row, 13) != "")
                    Nov = parseInt(instance.getDataAtCell(row, 13));
                if (instance.getDataAtCell(row, 14) != "")
                    Dec = parseInt(instance.getDataAtCell(row, 14));
                if (instance.getDataAtCell(row, 15) != "")
                    Jan = parseInt(instance.getDataAtCell(row, 15));
                if (instance.getDataAtCell(row, 16) != "")
                    Feb = parseInt(instance.getDataAtCell(row, 16));
                if (instance.getDataAtCell(row, 17) != "")
                    Mar = parseInt(instance.getDataAtCell(row, 17));
                td.innerHTML = parseInt(Apr) + parseInt(May) + parseInt(Jun) + parseInt(Jul) + parseInt(Aug) + parseInt(Sep) + parseInt(Oct) + parseInt(Nov) + parseInt(Dec) + parseInt(Jan) + parseInt(Feb) + parseInt(Mar);
            }
            CampConfigData[row].Total = td.innerHTML;
            return td;
        }
    </script>
    <script type="text/javascript">
        $approveCampConfig = function () {
            var CampConfigDataDetail = CampConfigData.slice(0, CampConfigData.length - 1);
            if (CampConfigData.length == 0) {
                toast('Error', 'Please Enter Camp Configuration Detail');
                jQuery("#btnSave").removeAttr('disabled').val('Save');
                return;
            }
            if (CampConfigData.length > 0) {
                jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                serverCall('CampConfigurationApproval.aspx/ApproveCampConfig', { CampConfigDetail: CampConfigDataDetail, FinacialYearDetail: jQuery('#spnFinacialYear').text() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast('Success', $responseData.response);
                        $clearControl();
                    }
                    else {
                        toast('Error', $responseData.response);
                    }
                    jQuery("#btnSave").removeAttr('disabled').val('Save');
                });
            }
        }
        function accessRight() {
            jQuery('#btnSearch,#btnApprove').hide();
        }
    </script>
    <style type="text/css">
        div#divData.vertical {
            width: 100%;
            height: 480px;
            background: #ffffff;
            overflow-y: auto;
            border-right: solid 1px gray;
        }

        .handsontable .selected-td {
            background-color: #CC99FF;
            font-weight: bold;
        }

        .handsontable .approved-td {
            color: green;
            background-color: #CEC;
            font-weight: bold;
        }

        .handsontable table thead th {
            font-weight: bold;
            font-size: 12px;
        }

        .handsontable THEAD TH.height {
            height: 20px;
        }

            .handsontable THEAD TH.height .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #FF6138;
                -webkit-box-shadow: 0px 0px 0px 6px #FF6138;
                height: 20px;
            }

        .handsontable THEAD TH.color1 {
            background: #3399FF;
            border-color: #D4441F;
        }

            .handsontable THEAD TH.color1 .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #FF6138;
                -webkit-box-shadow: 0px 0px 0px 6px #FF6138;
                background: #FF6138;
                border-color: #D4441F;
            }

        .handsontable THEAD TH.color2 {
            background: #B0C4DE;
            border-color: #549A6B;
        }

            .handsontable THEAD TH.color2 .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #79BD8F;
                -webkit-box-shadow: 0px 0px 0px 6px #79BD8F;
                background: #79BD8F;
                border-color: #549A6B;
            }

        .handsontable THEAD TH.color3 {
            background: #BEEB9F;
            border-color: #8FC768;
        }

            .handsontable THEAD TH.color3 .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #BEEB9F;
                -webkit-box-shadow: 0px 0px 0px 6px #BEEB9F;
                background: #BEEB9F;
                border-color: #8FC768;
            }

        .handsontable THEAD TH.color4 {
            background: #FFFF9D;
            border-color: #DEDE9A;
        }

            .handsontable THEAD TH.color4 .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #FFFF9D;
                -webkit-box-shadow: 0px 0px 0px 6px #FFFF9D;
                background: #FFFF9D;
                border-color: #DEDE9A;
            }

        .handsontable THEAD TH.color5 {
            background: #00A388;
            border-color: #38887B;
        }

            .handsontable THEAD TH.color5 .collapsibleIndicator {
                box-shadow: 0px 0px 0px 6px #00A388;
                -webkit-box-shadow: 0px 0px 0px 6px #00A388;
                background: #00A388;
                border-color: #38887B;
            }
    </style>
</asp:Content>

