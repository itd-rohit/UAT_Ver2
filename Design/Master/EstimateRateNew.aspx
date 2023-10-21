<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EstimateRateNew.aspx.cs" Inherits="Design_Lab_EstimateRate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  
    <style type="text/css">
        .myred {
            color: red;
            font-weight: bold;
        }

        .web_dialog_overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            background: #000000;
            opacity: .15;
            filter: alpha(opacity=15);
            -moz-opacity: .15;
            z-index: 101;
            display: none;
        }

        .web_dialog {
            display: none;
            position: fixed;
            width: 220px;
            top: 50%;
            left: 50%;
            margin-left: -190px;
            margin-top: -100px;
            background-color: #ffffff;
            border: 2px solid #336699;
            padding: 0px;
            z-index: 102;
            font-family: Verdana;
            font-size: 10pt;
        }

        .web_dialog_title {
            border-bottom: solid 2px #336699;
            background-color: #336699;
            padding: 4px;
            color: White;
            font-weight: bold;
        }

            .web_dialog_title a {
                color: White;
                text-decoration: none;
            }

        .align_right {
            text-align: right;
        }
    </style>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
    <div id="output"></div>
    <div id="overlay1" class="web_dialog_overlay"></div>
    <div id="dialog1" style="position: fixed; width: 250px; top: 50%; left: 50%; margin-left: -190px; margin-top: -100px; background-color: #ffffff; border: 2px solid #336699; padding: 0px; z-index: 102; font-family: Verdana; font-size: 10pt;"
        class="web_dialog">
    </div>


    <div class="dvestimate">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" id="Div1">
                <div class="Purchaseheader">
                    Search Criteria
                </div>
                <div class="content" id="divSearchCriteria">
                    <div class="row">
                        <div class="col-md-2 ">
                            <label class="pull-left">Country   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:DropDownList ID="ddlCountry" runat="server" class="ddlCountry chosen-select chosen-container"  onchange="$bindBusinessZone()"></asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left">Business Zone </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlBusinessZone" runat="server" class="ddlBusinessZone chosen-select chosen-container"  onchange="$bindState(jQuery('#ddlBusinessZone').val(),'','')"></asp:DropDownList>

                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlState" runat="server" class="ddlState chosen-select chosen-container"  onchange="$bindPanel('');"></asp:DropDownList>
	 
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select chosen-container"  onchange="$resetPanelItems();"></asp:DropDownList>
	 
                        </div>
                    </div>

                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div id="PatientDetails">
                    <div class="row" style="margin-top: 0px;">
                        <div class="col-md-21">
                            <div class="row">
                                <div class="col-md-3  ">
                                    <label class="pull-left">Mobile No.  </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 ">
                                    <input id="txtMobileNo" class="requiredField" type="text" allowfirstzero onkeyup="previewCountDigit(event,function(e){});" data-title="Enter Contact No. (Press Enter To Search)" onlynumber="10" autocomplete="off" />
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left"></label>
                                    <b class="pull-right"></b>
                                </div>
                                <div class="col-md-5 ">
                                </div>
                                <div class="col-md-3 ">
                                    <b class="pull-right"></b>
                                </div>
                                <div class="col-md-5 ">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left">Patient Name</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-2  col-xs-10">
                                    <asp:DropDownList ID="ddlTitle" runat="server" onchange="$onTitleChange(this.value)"></asp:DropDownList>
                                </div>
                                <div class="col-md-3  col-xs-14">
                                    <input type="text" id="txtPName" class="requiredField checkSpecialCharater" autocomplete="off" style="text-transform: uppercase" onlytext="50" maxlength="50" data-title="Enter Patient Name" />
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left">
                                        Age           
  <input type="radio" checked="checked" id="rdAge" onclick="setAge(this)" name="rdDOB" />
                                    </label>

                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtAge" style="width: 33%; float: left" onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();" class="requiredField" max-value="120" autocomplete="off" maxlength="3" data-title="Enter Age" placeholder="Years" />
                                    <input type="text" id="txtAge1" style="width: 33%; float: left" onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();" class="requiredField" max-value="12" autocomplete="off" maxlength="2" data-title="Enter Age" placeholder="Months" />
                                    <input type="text" id="txtAge2" style="width: 33%; float: left" onlynumber="5" onkeyup="$clearDateOfBirth(event);$getdob();" class="requiredField" max-value="30" autocomplete="off" maxlength="2" data-title="Enter Age" placeholder="Days" />
                                </div>
                                <div class="col-md-3  ">
                                    <label class="pull-left">
                                        DOB            
  <input type="radio" id="rdDOB" onclick="setDOB(this)" name="rdDOB" />
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5  ">
                                    <asp:TextBox ID="txtDOB" onclick="$getdob()" placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" Enabled="false"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Gender</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlGender" runat="server">
                                        <asp:ListItem Value="Male" Text="Male"></asp:ListItem>
                                        <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Address    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtPAddress" maxlength="50" data-title="Enter Address" />
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Email : </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtemailaddress" runat="server" MaxLength="50" data-title="Enter email"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
       
        <div class="POuter_Box_Inventory" id="mypaymentgrid">
            <div class="row" style="margin-top: 0px;">
                <div class="col-md-8">
                    <div class="row">
						<div style="padding-right: 0px;" class="col-md-18">
							<label class="pull-left">                               
								<input id="rdbItem_1" type="radio" name="labItems" value="1" onclick="$clearItem(function () { })" checked="checked"  />
								<label for="rdbItem_1">By Name</label>
								<input id="rdbItem_0" type="radio" name="labItems" value="0" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_0">By Code </label>
								<input id="rdbItem_2" type="radio" name="labItems" value="2" onclick="$clearItem(function () { })"  />
								<label for="rdbItem_2">InBetween</label>								
							</label>
						</div>		
                        <div class="col-md-6">
                            <button style="width: 100%; padding: 0px;" class="label label-important" type="button"><b>Count :</b><span id="lblTotalLabItemsCount" style="font-size: 14px; font-weight: bold;" class="badge badge-grey">0</span></button>
						</div>					                           												
					</div>
                    <div class="row">						
						<div style="padding-left: 15px;" class="col-md-24">
							<input type="hidden" id="theHidden" />
                                        <input type="text" id="txtInvestigationSearch" title="Enter Search Text"  autocomplete="off"  />
						</div>					
					</div>
                    </div>
                     <div class="col-md-16">
                          <div class="row">
                              <div style="padding-left: 15px;" class="col-md-24">
                            <div class="col-md-4">  Total MRP:</div><div class="col-md-8"><asp:TextBox ID="txttotalMRP" Text="0" runat="server" Width="120px" ReadOnly="true" CssClass="ItDoseTextinputNum"></asp:TextBox></div>
                             <div class="col-md-4">Total Rate:</div><div class="col-md-8"><asp:TextBox ID="txttotalamount" Text="0" runat="server" Width="120px" ReadOnly="true" CssClass="ItDoseTextinputNum"></asp:TextBox></div>
                              </div>
                               </div>
                        <div class="row">
                            <div style="padding-left: 15px;" class="col-md-24">
					<div style=" height: 125px; overflow-y: auto; overflow-x: hidden;">
						<table id="tb_ItemList" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
							<thead>
								<tr id="LabHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Code</td>
                                                <td class="GridViewHeaderStyle" style="width: 280px; text-align: center">Item</td>
                                                <td class="GridViewHeaderStyle" style="width: 30px; text-align: center">View</td>
                                                <td class="GridViewHeaderStyle" style="width: 30px; text-align: center">MRP</td>
                                                <td class="GridViewHeaderStyle" style="width: 40px; text-align: center">Rate</td>
                                               
                                                <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Delivery Date</td>
                                                <td class="GridViewHeaderStyle" style="width: 60px; text-align: center; display: none;">Sam.Coll.</td>
                                                <td class="GridViewHeaderStyle" style="width: 50px; text-align: center; display: none;">Urgent</td>
                                                <td style="display: none;"></td>
                                    </tr>
                               </thead>
							<tbody></tbody>
                            </table>
                    </div>
                             </div>
            </div>

        </div>
    </div>
        </div> 
    <div class="POuter_Box_Inventory" style="text-align: center;">
       
            <input type="button" id="btnopenPopup" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" />
            &nbsp;<input type="button" value="Clear" onclick="$clearForm()" class="resetbutton" />
       
    </div>
          </div>
        
    <div class="dvreport">
        <div class="POuter_Box_Inventory" style="margin-top: 50px;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
        </div>
        <div class="content" id="div2">
            <div class="row">
                <div class="col-md-3  ">
                    <label class="pull-left">From Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtfromdate" runat="server" Width="120px" class="setmydateColl"></asp:TextBox>
                </div>
                <div class="col-md-3  ">
                    <label class="pull-left">To Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txttodate" runat="server" Width="120px" class="setmydateColl"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <input type="button" id="btnexcelreport" value="Excel Report" onclick="$ExcelReport();" style="font-weight: bold; width: auto; height: 25px; display: inline-block;" class="ItDoseButton btnForSearch demo SampleStatus" />
            </div>
        </div>
    </div>
    <div class="dvreportbutton" style="display:none">
        <input id="pop1" onclick="hideshow();" style="font-weight: bold; width: auto; height: 25px; margin-left: 553px; display: inline-block;" class="ItDoseButton btnForSearch demo SampleStatus" type="button" value="Report" />
    </div>
    <div id="popup_box" style="width: 500px;">
        <div id="showpopupmsg" style="height: 290px; width: 500px; overflow: scroll;"></div>
        <a href="javascript:void(0);" id="popupBoxClose" onclick="unloadPopupBox()">Close</a>
    </div>
         <div id="divViewRemarks" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width: 60%;max-width:62%">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Remarks Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeViewRemarksModel()"   aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>								
			</div>
            <div class="modal-body">			
                     <div id="divPopUPRemarks" class="col-md-24">
                         </div>               
                </div>
                <div class="modal-footer">								
			  <button type="button"  onclick="$closeViewRemarksModel()">Close</button>
			</div>                  
        </div>
    </div>
         </div>

    <script type="text/javascript">
        $bindDOB = function () {
            jQuery("#txtDOB").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var $today = new Date();
                    var $dob = value;
                    getAge($dob, $today);
                }
            });
            
        }
        function getAge(birthDate, ageAtDate) {
            var $daysInMonth = 30.436875; // Days in a month on average.
            // var dob = new Date(birthDate);
            //shat 05.10.17
            var $dateSplit = birthDate.split("-");
            var $dob = new Date($dateSplit[1] + " " + $dateSplit[0] + ", " + $dateSplit[2]);
            //
            var aad;
            if (!ageAtDate) aad = new Date();
            else aad = new Date(ageAtDate);
            var $yearAad = aad.getFullYear();
            var $yearDob = $dob.getFullYear();
            var $years = $yearAad - $yearDob; // Get age in years.
            $dob.setFullYear($yearAad); // Set birthday for this year.
            var $aadMillis = aad.getTime();
            var $dobMillis = $dob.getTime();
            if ($aadMillis < $dobMillis) {
                --$years;
                $dob.setFullYear(yearAad - 1); // Set to previous year's birthday
                $dobMillis = $dob.getTime();
            }
            var $days = ($aadMillis - $dobMillis) / 86400000;
            var $monthsDec = $days / $daysInMonth; // Months with remainder.
            var $months = Math.floor($monthsDec); // Remove fraction from month.
            $days = Math.floor($daysInMonth * ($monthsDec - $months));
            jQuery('#txtAge').val($years);
            jQuery('#txtAge1').val($months);
            jQuery('#txtAge2').val($days);

        }
        var $closeViewRemarksModel = function (callback) {
            jQuery('#divViewRemarks').hideModel();
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                 if (jQuery('#divViewRemarks').is(':visible')) {
                    $closeViewRemarksModel();
                }

            }

        }
        var $onTitleChange = function (gender) {
            var $gender = jQuery('#ddlGender').val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                jQuery('#ddlGender').val("").prop('disabled', false);
            }
            else {
                jQuery('#ddlGender').val(gender).prop('disabled', true);
            }
            if ($gender != jQuery('#ddlGender').val()) {

            }
        }
        var $bindDefaultPanel = function () {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('EstimateRateNew.aspx/bindDefaultPanel', {}, function (response) {
                var IDList = JSON.parse(response)
                if (IDList.length > 0) {
                    jQuery('#ddlBusinessZone').val(IDList[0].BusinessZoneID);
                    $("#ddlBusinessZone").trigger('chosen:updated');
                    $bindState(IDList[0].BusinessZoneID, IDList[0].stateid, IDList[0].Panel_ID);
                    jQuery('#ddlPanel').val(IDList[0].Panel_ID);
                    $("#ddlPanel").trigger('chosen:updated');
                }

            });

         }
        var $bindCountry = function (callback) {    
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: 0, StateID: 0, CityID: 0, IsStateBind: 0, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 1, IsLocality: 1 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=Resources.Resource.BaseCurrencyID%>' });
                jQuery('#ddlCountry').val('<%=Resources.Resource.BaseCurrencyID%>').chosen('destroy').chosen();
                callback($ddlCountry.val());
               
            });

        }

        $bindBusinessZone = function () {
            var $ddlBusinessZone = jQuery('#ddlBusinessZone');
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWithCountry', { CountryID: jQuery('#ddlCountry').val() }, function (response) {
                $ddlBusinessZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', isSearchAble: true });
            });
        }

        $(function () {
            $bindCountry(function (callback) {
                $bindBusinessZone();
                $bindDefaultPanel();
                
            });
            $bindTitle();
            $bindDOB();
            $(".setmydateColl").datepicker({
                dateFormat: "dd-M-yy",
                minDate: 0
            }).attr('readonly', 'readonly');
            if ('<%=AccessType%>' != '') {
                $('#divSearchCriteria').hide();
            }
            else {
                $('#divSearchCriteria').show();
            }
            $('.dvestimate').show();
            $('.dvreport').hide();
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
        });
        function hideshow() {
            if ($('#pop1').val() == "Report") {
                $('#pop1').val("New");
                $('.dvestimate').hide();
                $('.dvreport').show();
                $('.dvreportbutton').show();
            }
            else {
                $('#pop1').val("Report");
                $('.dvestimate').show();
                $('.dvreport').hide();
                $('.dvreportbutton').show();
            }
        }
        var $ExcelReport = function () {
            var FromDate = $('#txtfromdate').val();
                var ToDate = $('#txttodate').val();
                var searchdata = FromDate + "$" + ToDate;
                serverCall('EstimateRateNew.aspx/ExcelReport', { searchdata: searchdata }, function (response) {
                    if (response == "true") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        alert("No Record Found..!");
                    }
                });
            }
            var $clearDateOfBirth = function (e) {
                var $inputValue = (e.which) ? e.which : e.keyCode;
                if ($inputValue == 46 || $inputValue == 8) {
                    jQuery(e.target).val('');
                    jQuery('#txtDOB').val('').prop('disabled', false);
                }
            }
            var $bindTitle = function () {
                var $ddlTitle = jQuery('#ddlTitle');
                titleWithGenderData(function ($responseData) {
                    var options = [];
                    for (var i = 0; i < $responseData.length; i++) {
                        options.push('<option value="');
                        options.push($responseData[i].Gender);
                        options.push('">');
                        options.push($responseData[i].Title);
                        options.push('</option>');
                    }
                    $ddlTitle.append(options.join(""));
                });
                jQuery('#ddlGender').attr('disabled', 'disabled');
            }
            var $getdob = function (birthDate) {
                var $age = "";
                var $ageyear = "0";
                var $agemonth = "0";
                var $ageday = "0";
                if (jQuery('#txtAge').val() != "") {
                    if (jQuery('#txtAge').val() > 110) {
                        toast("Error", "Please Enter Valid Age in Years", "");
                        jQuery('#txtAge').val('');
                    }
                    $ageyear = jQuery('#txtAge').val();
                }
                if (jQuery('#txtAge1').val() != "") {
                    if (jQuery('#txtAge1').val() > 12) {
                        toast("Error", "Please Enter Valid Age in Months", "");
                        jQuery('#txtAge1').val('');
                    }
                    $agemonth = jQuery('#txtAge1').val();

                }
                if (jQuery('#txtAge2').val() != "") {
                    if (jQuery('#txtAge2').val() > 30) {
                        toast("Error", "Please Enter Valid Age in Days", "");
                        jQuery('#txtAge2').val('');
                    }
                    $ageday = jQuery('#txtAge2').val();
                }
                var d = new Date(); // today!
                if ($ageday != "")
                    d.setDate(d.getDate() - $ageday);
                if ($agemonth != "")
                    d.setMonth(d.getMonth() - $agemonth);
                if ($ageyear != "")
                    d.setFullYear(d.getFullYear() - $ageyear);
                var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
                var yyyy = d.getFullYear();
                var MM = d.getMonth();
                var dd = d.getDate();
                var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
                jQuery('#txtDOB').val(xxx);
                $resetItem("1");
            }
            minTwoDigits = function (n) {
                return (n < 10 ? '0' : '') + n;
            }
            setAge = function (ctrl) {
                if (jQuery(ctrl).is(':checked')) {
                    jQuery('#txtDOB').attr("disabled", true);
                    jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", false);
                    jQuery('#txtDOB').removeClass('requiredField');
                    jQuery('#txtAge,#txtAge1,#txtAge2').addClass('requiredField');
                }
            }
            setDOB = function (ctrl) {
                if (jQuery(ctrl).is(':checked')) {
                    jQuery('#txtDOB').attr("disabled", false);
                    jQuery('#txtAge,#txtAge1,#txtAge2').attr("disabled", true);
                    jQuery('#txtDOB').addClass('requiredField');
                    jQuery('#txtAge,#txtAge1,#txtAge2').removeClass('requiredField');
                }
            }
            $resetItem = function ($con) {
                InvList = [];
                jQuery('#tb_ItemList tr').slice(1).remove();
                jQuery('#tblPaymentDetail tr').slice(1).remove();
                $('#tb_ItemList').hide();
                $('#txttotalMRP').val('0');
                $('#txttotalamount').val('0');
                testcount = 0;
                totalamt = 0;
                jQuery('#lblTotalLabItemsCount').text('0');
            }
            var $bindPanel = function (panelid) {
                var $ddlPanel = $('#ddlPanel');
                serverCall('EstimateRateNew.aspx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: +jQuery("#ddlState").val(), CityID: 0 }, function (response) {
                    $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', defaultValue: "", isSearchAble: true });
                    if (panelid != '') {
                        jQuery('#ddlPanel').val(panelid);
                        $("#ddlPanel").trigger('chosen:updated');
                    }
                });
            }

            var $bindState = function (zoneid,stateid,panelid) {
                var $ddlState = $('#ddlState');
                serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: "14", BusinessZoneID: zoneid }, function (response) {
                    $ddlState.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'State', defaultValue: "ALL", isSearchAble: true });
                    if (stateid != '') {
                        jQuery('#ddlState').val(stateid);
                        $("#ddlState").trigger('chosen:updated');
                        jQuery("#ddlBusinessZone").val(zoneid);
                        $("#ddlBusinessZone").trigger('chosen:updated');
                    }
                    $bindPanel(panelid);
                   
                });
            }
            function $clearItem() {
                $("#txtInvestigationSearch").val('');
            }
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }
            function extractLast1(term) {           
                var length = jQuery('#ddlPanel > option').length;
                if (length == 0 || jQuery('#ddlPanel').val() == "" || jQuery('#ddlPanel').val() == "0") {
                    toast("Error", "Please Select Any Panel", "");
                    jQuery('#ddlPanel').focus();
                }
                return split(term).pop();
            }
        jQuery("#txtInvestigationSearch")
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  if (jQuery("#ddlGender option:selected").text() == "") {
                      toast("Error", "Please Select Gender", "");
                      jQuery("#ddlGender").focus();
                      return;
                  }
                  $("#theHidden").val('');
              })
            .autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=GetTestEstimateList", {
                   
                        SearchType: jQuery('input:radio[name=labItems]:checked').val(),
                        Gender: jQuery("#ddlGender option:selected").text(),
                        DOB: jQuery('#txtDOB').val(),
                        ReferenceCodeOPD: jQuery('#ddlPanel').val().split('#')[1],
                        TestName: extractLast1(request.term),
                        Panel_Id: jQuery('#ddlPanel').val().split('#')[0],
                        Panel_IdMRP: jQuery('#ddlPanel').val().split('#')[3],
                        
                    }, response);
                },
                search: function () {
                    var term = extractLast1(this.value);
                    if (term.length < 2) {
                        return false;
                    }
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {

                    $("#theHidden").val(ui.item.id);
                    this.value = '';
                    AddItem(ui.item.value, ui.item.type, ui.item.Rate.split('#')[0], ui.item.MRP.split('#')[0]);
                    return false;
                },
            });
            var testcount = 0;
            var totalamt = 0;
            var InvList = [];
            var itemwisedic = 0;
            function AddItem(itemid, type, Rate, MRP) {
                if (itemid == '') {
                    toast("Error", "Please select investigation...", "");
                    return false;
                }
                var addedtest = "";

                jQuery('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "LabHeader") {
                        addedtest += jQuery(this).closest("tr").attr("id") + "_" + jQuery(this).closest("tr").find("#tdispackage").text() + ",";
                    }
                });
                if (Rate == '0') {
                    toast("Error", "Test Rate Not Uploaded ..... !", "");
                    return;
                }
                
                serverCall('../Lab/Services/LabBooking.asmx/GetitemRate', { ItemID: itemid, type: type, Rate: Rate, addedtest: addedtest, centreID: $('#ddlPanel').val().split('#')[2], DiscPer: 0, DeliveryDate:"", MRP: MRP, IsCopayment:0, panelid: $('#ddlPanel').val().split('#')[0],MembershipCardNo:"",IsSelfPatient:0,UHIDNo:""}, function (response) {
                    $responseData = JSON.parse(response);
                    var MRP = $responseData[0].MRP;
                    var inv = $responseData[0].Investigation_Id;
                    for (var i = 0; i < (inv.split(',').length) ; i++) {
                        if ($.inArray(inv.split(',')[i], InvList) != -1) {
                            toast("Error", "item Already in List..!", "");
                            return;
                        }
                    }
                    for (var i = 0; i < (inv.split(',').length) ; i++) {
                        InvList.push(inv.split(',')[i]);
                    }
                    testcount = parseInt(testcount) + 1;
                    jQuery('#lblTotalLabItemsCount').text(testcount);
                    if (MRP == 0) {
                        MRP = $responseData[0].Rate;
                    }
                    var $mydata = [];

                    $mydata.push(" <tr id='");
                    $mydata.push($responseData[0].ItemID); $mydata.push("'");
                    $mydata.push(" class='GridViewItemStyle'>");
                    $mydata.push("<td class='inv' id='"); $mydata.push($responseData[0].Investigation_Id); $mydata.push("'>");
                    $mydata.push("<a href='javascript:void(0);' onclick='deleteItemNode($(this));'><img src='../../App_Images/Delete.gif'/></a></td>");
                    $mydata.push("<td id='tdTestCode' style='font-weight:bold;'>"); $mydata.push($responseData[0].testCode); $mydata.push("</td> ");
                    $mydata.push(" <td id='tditemname' style='font-weight:bold;'>"); $mydata.push($responseData[0].typeName); $mydata.push("</td> ");
                    $mydata.push("<td style='text-align:centre;'>");
                    if ($responseData[0].SampleRemarks != "") {
                        $mydata.push('<a href="javascript:void(0);" onclick="$viewRemarks(\'');
                        $mydata.push($responseData[0].SampleRemarks); $mydata.push("\',"); $mydata.push("\'");
                        $mydata.push(type); $mydata.push("\');"); $mydata.push('">');
                        $mydata.push('<img src="../../App_Images/view.gif" /></a>');
                    }
                    $mydata.push("</td>");
                   
                        $mydata.push('<td id="tdMRP" class="paymenttd" style="text-align:right">'); $mydata.push(MRP); $mydata.push('</td>');
                        $mydata.push('<td id="tdrate"  style="text-align:right">'); $mydata.push($responseData[0].Rate); $mydata.push('</td>');
                        $mydata.push('<td id="tddisc" style="display:none;">');
                        $mydata.push('<input id="txttddisc" type="text"  style="width:50px;display:none;" value="0" onkeyup="setitemwisediscount(this);" />');
                        $mydata.push('</td>');
                        $mydata.push('<td style="display:none;" id="tdamt"><input type="text" style="width:50px;display:none;" id="txtnetamt" value="');
                        $mydata.push($responseData[0].Rate); $mydata.push('"');
                        $mydata.push(' readonly="readonly"/></td>');
                    
                    var delData = ($responseData[0].DeliveryDate.split('#')[0] == '01-Jan-0001 12:00 AM') ? '' : $responseData[0].DeliveryDate.split('#')[0];
                    $mydata.push('<td id="tddeliverydate" style="font-weight:bold;text-align: center;">'); $mydata.push(delData); $mydata.push('</td>');
                    $mydata.push('<td style="text-align: center;display:none;"><input type="checkbox" id="chsampleself" disabled="disabled"  ');
                    if ($responseData[0].SampleDefined != "0") {
                        $mydata.push('checked="checked" ');
                    }
                    $mydata.push('/></td>');
                    $mydata.push('<td style="text-align: center;display:none;"><input type="checkbox" id="chkurgent" disabled="disabled" /></td>');
                    $mydata.push('<td id="tdIsPackage"    style="display:none;">'); $mydata.push($responseData[0].ispackage); $mydata.push('</td>');
                    $mydata.push('<td id="tdisreporting" style="display:none;">'); $mydata.push($responseData[0].reporting); $mydata.push('</td>');
                    $mydata.push('<td id="tdSubCategoryID" style="display:none;">'); $mydata.push($responseData[0].subcategoryid); $mydata.push('</td>');
                    $mydata.push('<td id="tdeporttype" style="display:none;">'); $mydata.push($responseData[0].reporttype); $mydata.push('</td>');
                    $mydata.push('<td id="tdGenderInvestigate" style="display:none;">'); $mydata.push($responseData[0].GenderInvestigate); $mydata.push('</td>');
                    $mydata.push('<td id="tdSample" style="display:none;">'); $mydata.push($responseData[0].Sample); $mydata.push('</td>');

                   

                    $mydata.push("</tr>");
                    $mydata = $mydata.join("");
                    jQuery("#tb_ItemList tbody").prepend($mydata);
                    jQuery('#tb_ItemList').show();
                   
                    sumtotal();
                   
                
                });
                
            }
            function sumtotal() {

                var net = 0; totalamt = 0; disc = 0;
                var packagecount = 0;
                var MRP = 0;
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).attr("id");
                    if (id != "LabHeader") {
                        if ($(this).find('#tdispackage').text() == "1") {
                            packagecount = 1;
                        }
                        totalamt = parseInt(totalamt) + parseFloat($(this).closest('tr').find('#tdrate').text());
                        net = net + parseFloat($(this).closest('tr').find("#txtnetamt").val());
                        MRP = MRP + parseFloat($(this).closest('tr').find("#tdMRP").text());                       
                        disc = disc + Number($(this).closest('tr').find("#txttddisc").val());
                    }
                });
                $('#txttotalamount').val(net);
                $('#txttotalMRP').val(MRP);
                var count = $('#tb_ItemList tr').length;
                if (count == 0 || count == 1) {                    
                    $('#txttotalamount').val('0');
                    $('#txttotalMRP').val('0');
                }
            }
            function deleteItemNode(row) {
                testcount = parseInt(testcount) - 1;
                jQuery('#lblTotalLabItemsCount').text(testcount);

                var $tr = $(row).closest('tr');
                var RmvInv = $tr.find('.inv').attr("id").split(',');
                var len = RmvInv.length;
                InvList.splice($.inArray(RmvInv[0], InvList), len);
                row.closest('tr').remove();
                sumtotal();
            }
            function $viewRemarks(remarks, type) {
                var $mm = [];
                if (type == "Test") {
                    $mm.push("<h3>Test Details</h3>");
                    $mm.push(remarks);
                }
                else {
                    $mm.push("<h3>Package Inclusions</h3>");
                    for (var i = 0; i < (remarks.split('##').length) ; i++) {
                        $mm.push("".concat(i + 1, ". "));
                        $mm.push(remarks.split('##')[i]);
                        $mm.push("<br />");
                    }
                }
                $mm = $mm.join("");
                jQuery("#divPopUPRemarks").html($mm);
                jQuery("#divViewRemarks").showModel();
            }
            function unloadPopupBox() {    // TO Unload the Popupbox
                $('#showpopupmsg').html('');
                $('#popup_box').fadeOut("slow");
                $("#Pbody_box_inventory").css({ // this is just for style        
                    "opacity": "1"
                });
            }
            function $clearForm() {
                //$('#ddlBusinessZone').val(0);
                //$("#ddlBusinessZone").trigger('chosen:updated');
                //$('#ddlState').val(0);
                //$("#ddlState").trigger('chosen:updated');
                //$('#ddlPanel').val(0);
                //$("#ddlPanel").trigger('chosen:updated');
                InvList = [];
                jQuery('#lblTotalLabItemsCount').text('0');             
                testcount = 0;
                totalamt = 0;
                $('#tb_ItemList tr').slice(1).remove();
                $('#tb_ItemList').hide();
                $(':text').val('');
            }
            function $resetPanelItems() {
                InvList = [];
                jQuery('#lblTotalLabItemsCount').text('0');               
                testcount = 0;
                totalamt = 0;
                $('#tb_ItemList tr').slice(1).remove();
                $('#tb_ItemList').hide();
                // $(':text').val('');
                $('#txttotalMRP').val('0');
                $('#txttotalamount').val('0');
                
            }
            function OpneSavePOpup() {
                if ($('#ddlBusinessZone').val() == "0") {
                    toast("Error", "Please Select Business Zone", "");
                    $('#ddlBusinessZone').focus();
                    return;
                }
                if ($('#ddlPanel').val() == "0") {
                    toast("Error", "Please Select Panel", "");
                    $('#ddlPanel').focus();
                    return;
                }
                if ($('#txttotalamount').val() == "") {
                    toast("Error", "Please Select Test", "");
                    return;
                }
                if ($('#txtMobileNo').val().length<10) {
                    toast("Error", "Please Enter  valid Mobile No.", "");
                    $('#txtMobileNo').focus();
                    return;
                }
                if ($('#txtPName').val() == "") {
                    toast("Error", "Please Enter Name", "");
                    $('#txtPName').focus();
                    return;
                }
                if (jQuery('#txtemailaddress').val().length > 0) {
                    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                    if (!filter.test(jQuery('#txtemailaddress').val())) {
                        toast("Error", 'Incorrect Email ID', '');
                        jQuery('#txtemailaddress').focus();
                        return false;
                    }
                }
                var patientdata = patientMaster();
                var PLOdata = patientlabinvestigationopd();

                $("#btnopenPopup").attr('disabled', true).val("Submiting...");
                serverCall('EstimateRateNew.aspx/SaveNewEstimate', { PM: patientdata, PLO: PLOdata }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.Status) {
                        $clearForm();
                        toast("Success", $responseData.response, "");
                        $('#btnopenPopup').attr('disabled', false).val("Save");
                        window.open('EstimateReceipt.aspx?ID=' + $responseData.responseDetail + '');
                    }
                    else {
                        toast("Error", $responseData.response, "");
                        $('#btnopenPopup').attr('disabled', false).val("Save");
                    }
                });
            }
            function patientlabinvestigationopd() {
                var dataPLO = new Array();
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "LabHeader") {
                        var objPLO = new Object();
                        objPLO.ItemId = $(this).closest("tr").attr("id");
                        objPLO.ItemName = "".concat($(this).closest("tr").find("#tdTestCode").text(), '~', $(this).closest("tr").find("#tditemname").text());
                        objPLO.TestCode = $.trim($(this).closest("tr").find("#tdTestCode").text());
                        objPLO.Rate = $(this).closest("tr").find("#tdrate").html();
                        objPLO.Discount = $(this).closest("tr").find("#txttddisc").val();
                        objPLO.Amount = $(this).closest("tr").find("#txtnetamt").val();
                        objPLO.DeliveryDate = $(this).closest("tr").find("#tddeliverydate").html();
                        objPLO.SubCategoryID = $(this).closest("tr").find("#tdSubCategoryID").html();
                        objPLO.IsPackage = $(this).closest("tr").find("#tdIsPackage").html();
                        dataPLO.push(objPLO);
                    }
                });
                return dataPLO;
            }
            function clearOldpatient() {
                jQuery("#oldpatienttable tr:not(#myheader)").remove();
            }
            function patientMaster() {
                var $age = "";
                var $ageyear = "0";
                var $agemonth = "0";
                var $ageday = "0";
                if (jQuery('#txtAge').val() != "") {
                    $ageyear = jQuery('#txtAge').val();
                }
                if (jQuery('#txtAge1').val() != "") {
                    $agemonth = jQuery('#txtAge1').val();
                }
                if (jQuery('#txtAge2').val() != "") {
                    $ageday = jQuery('#txtAge2').val();
                }
                $age = $ageyear + " Y " + $agemonth + " M " + $ageday + " D ";
                var $ageindays = parseInt($ageyear) * 365 + parseInt($agemonth) * 30 + parseInt($ageday);
                var $objPM = new Array();
                $objPM.push({
                    Patient_ID: "",
                    Title: jQuery("#ddlTitle option:selected").text(),
                    PName: jQuery.trim(jQuery('#txtPName').val()),
                    House_No: jQuery.trim(jQuery('#txtPAddress').val()),
                    Street_Name: "",
                    PinCode: 0,
                    Country: "",
                    State: "",
                    City: "",
                    Locality: "",
                    CountryID: 0,
                    StateID: 0,
                    CityID: 0,
                    LocalityID: 0,
                    Phone: "",
                    Mobile: jQuery.trim(jQuery('#txtMobileNo').val()),
                    Email: jQuery.trim(jQuery('#txtemailaddress').val()),
                    Age: $age,
                    AgeYear: $ageyear,
                    AgeMonth: $agemonth,
                    AgeDays: $ageday,
                    TotalAgeInDays: $ageindays,
                    DOB: jQuery('#txtDOB').val(),
                    Gender: jQuery("#ddlGender option:selected").text(),
                    CentreID: jQuery('#ddlPanel option:selected').val().split('#')[0],
                    IsOnlineFilterData: "0",
                    IsDuplicate: 0,
                    isCapTure: "",
                    base64PatientProfilePic: "",
                    IsDOBActual: jQuery('#rdDOB').is(':checked') ? 1 : 0,
                    ClinicalHistory: ""
                });
                return $objPM;
            }
    </script>
</asp:Content>

