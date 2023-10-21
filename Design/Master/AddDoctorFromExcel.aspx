<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" EnableEventValidation="false" ValidateRequest="false" CodeFile="AddDoctorFromExcel.aspx.cs" Inherits="Design_Master_AddDoctorFromExcel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctor Reffral</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtStateID" runat="server" Style="display: none" />
            <asp:TextBox ID="txtCityID" runat="server" Style="display: none" />
            <asp:TextBox ID="txtLocalityID" runat="server" Style="display: none" />

            <asp:TextBox ID="txtSelectedCountryID" runat="server" Style="display: none" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Submit Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="ddlCenter" Width="360px" runat="server" ClientIDMode="Static" CssClass="multiselect" SelectionMode="Multiple" />


                </div>
                <div class="col-md-3">
                    <asp:Label ID="Label2" runat="server" ClientIDMode="Static" ForeColor="Red"></asp:Label>
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnDownload" runat="server" Text="Download Doctor Excel Format" OnClick="lnk1_Click" Style="cursor: pointer; font-weight: bold;" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Country</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlCountry" data-title="Select Country" onchange="$onCountryChange(this.value)"></select>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlState" data-title="Select State" onchange="$onStateChange(this.value)"></select>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlCity" data-title="Select City" onchange="$onCityChange(this.value)"></select>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Locality</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlArea" data-title="Select Locality"></select>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Upload Excel  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:FileUpload ID="file1" accept=".xls,.xlsx" runat="server" />
                    <br />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:Label ID="Label1" runat="server" ClientIDMode="Static" ForeColor="Red"></asp:Label></label>
                    <b class="pull-right"></b>
                </div>
            </div>



        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnupload" runat="server" Text="Upload" OnClientClick="return Validate()" OnClick="btnupload_Click" CssClass="ItDoseButton" />

        </div>
    </div>
    <script type="text/javascript">
        Validate = function () {
            var con = 0;

            if ($("#ddlCenter").multipleSelect("getSelects").join() == "") {
                toast("Error", "Please Select Center", "");
                $("#ddlCenter").focus();
                con = 1;
                return false;
            }
            if ($("#ddlCountry").val() == "0") {
                toast("Error", "Please Select Country", "");
                $("#ddlCountry").focus();
                con = 1;
                return false;
            }
            if ($("#ddlState").val() == "0") {
                toast("Error", "Please Select State", "");
                $("#ddlState").focus();
                con = 1;
                return false;
            }
            if ($("#ddlCity").val() == "0") {
                toast("Error", "Please Select City", "");
                $("#ddlCity").focus();
                con = 1;
                return false;
            }
            if ($("#ddlArea").val() == "0") {
                toast("Error", "Please Select Locality", "");
                $("#ddlArea").focus();
                con = 1;
                return false;
            }
            var validFilesTypes = ["xlsx", "xls"];
            if (jQuery("#fu_Upload").val() == '') {
                label.innerHTML = 'Please Select File to Upload';
                jQuery("#fu_Upload").focus();
                con = 1;
                return false;
            }
            var extension = jQuery('#file1').val().split('.').pop().toLowerCase();
            if (jQuery.inArray(extension, validFilesTypes) == -1) {
                toast("Error", "Invalid File. Please upload a File with" + " extension:\n\n" + validFilesTypes.join(", "), "");
                con = 1;
                return false;
            }
            if (con == 1) {
                return false;
            }
            else {
                $("#txtSelectedCountryID").val($("#ddlCountry").val());
                $("#txtStateID").val($("#ddlState").val());
                $("#txtCityID").val($("#ddlCity").val());
                $("#txtLocalityID").val($("#ddlArea").val());


                $modelBlockUI();
                document.getElementById('<%=btnupload.ClientID%>').disabled = true;
                document.getElementById('<%=btnupload.ClientID%>').value = 'Uploading...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnupload', '');

            }
        }
        var count = 1;
        jQuery(function () {
            $('#ddlCenter').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                } else {
                    return true;
                }
            }
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

        $bindStateCityLocality = function () {
            var $ddlCountry = jQuery('#ddlCountry'); var $ddlState = jQuery('#ddlState'); var $ddlCity = jQuery('#ddlCity'); var $ddlLocality = jQuery('#ddlArea');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: '<%=Resources.Resource.BaseCurrencyID%>', StateID: 0, CityID: 0, IsStateBind: 1, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 0, IsLocality: 0 }, function (response) {

                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=Resources.Resource.BaseCurrencyID%>', showDataValue: 1 });
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true });
                $ddlCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true });
                $ddlLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true });
            });
         }
    </script>
    <script type="text/javascript">

        $onCountryChange = function (selectedCountryID) {
            $bindState(selectedCountryID, "1", function (selectedStateID) {
            });
        }
        $onStateChange = function (selectedStateID) {
            $bindCity(selectedStateID, "1", function (selectedCityID) {
                $bindLocality(selectedCityID, "1", function () { });
            });
        }
        $onCityChange = function (selectedCityID) {
            $bindLocality(selectedCityID, "1", function () { });
        }
        $bindCountry = function (callback) {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: $("#txtSelectedCountryID").val(), StateID: 0, CityID: 0, IsStateBind: 0, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 0, IsLocality: 0 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: $("#txtSelectedCountryID").val() });
                callback($ddlCountry.val());
            });
        }
        $bindState = function (CountryID, con, callback) {
            var $ddlState = jQuery('#ddlState');
            jQuery('#ddlState,#ddlCity,#ddlArea').find('option').remove();
            jQuery('#ddlState,#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                if (con == 1)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                else
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: $("#txtStateID").val() });

                callback($ddlState.val());
            });
        }
        $bindCity = function (StateID, con, callback) {
            var $ddlCity = jQuery('#ddlCity');
            jQuery('#ddlCity,#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                if (con == 1)
                    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                else
                    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $("#txtCityID").val() });

                callback($ddlCity.val());
            });
        }
        var $bindLocality = function (CityID, con, callback) {
            var $ddlArea = jQuery('#ddlArea');
            jQuery('#ddlArea').empty();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: CityID }, function (response) {
                if (con == 1)
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                else
                    $ddlArea.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true, selectedValue: $("#txtLocalityID").val() });

                callback($ddlArea.val());
            });
        }
        bindAllField = function () {
            $modelBlockUI();
            var $ddlCountry = jQuery('#ddlCountry'); var $ddlState = jQuery('#ddlState'); var $ddlCity = jQuery('#ddlCity'); var $ddlLocality = jQuery('#ddlArea');
            var $ddlCountry = jQuery('#ddlCountry'); var $ddlState = jQuery('#ddlState'); var $ddlCity = jQuery('#ddlCity'); var $ddlLocality = jQuery('#ddlArea');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: $("#txtSelectedCountryID").val(), StateID: $("#txtStateID").val(), CityID: $("#txtCityID").val(), IsStateBind: 1, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 1, IsLocality: 1 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: $("#txtSelectedCountryID").val() });
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response).stateData, valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: $("#txtStateID").val() });
                $ddlCity.bindDropDown({ data: JSON.parse(response).cityData, valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: $("#txtCityID").val() });
                $ddlLocality.bindDropDown({ data: JSON.parse(response).localityData, valueField: 'ID', textField: 'Locality', isSearchAble: true, selectedValue: $("#txtLocalityID").val() });
            });

            //$bindCountry(function (selectedCountryID) {
            //    $bindState($("#txtSelectedCountryID").val(), "0", function (selectedStateID) {
            //        $bindCity($("#txtStateID").val(), "0", function (selectedCityID) {
            //            $bindLocality($("#txtCityID").val(), "0", function (selectedLocalityID) {
            //                $modelUnBlockUI();
            //            });
            //        });
            //    });
            //});
        }
    </script>
</asp:Content>

