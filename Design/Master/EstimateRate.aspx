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

                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;" id="mypaymentgrid">
            <div class="content">

                <table style="width: 99%">
                    <tr>
                        <td style="width: 50%; vertical-align: top">
                            <div class="Purchaseheader">
                                Test
                            </div>

                            <table style="width: 99%">
                                <tr>
                                    <td colspan="2">
                                        <input id="rblsearchtype_1" onclick="clearItem()" value="1" name="rblsearchtype" checked="checked" type="radio" />
                                        <b>By Test Name</b><input id="rblsearchtype_0" onclick="    clearItem()" value="0" name="rblsearchtype" type="radio" />
                                        <b>By Test Code</b><input id="rblsearchtype_2" onclick="    clearItem()" value="2" name="rblsearchtype" type="radio" />
                                        <b>InBetween</b> 
                                         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;                                  
                                         <b>Delivery Date </b>     
                                        &nbsp;
                                        <asp:TextBox ID="txtDeliveryDate" style="text-align:center" runat="server" Width="100px" class="setmydateColl" ></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="ui-widget" style="display: inline-block;">
                                            <input type="hidden" id="theHidden" />

                                            <input id="ddlInvestigation" size="50" tabindex="19" />
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <b>Total Test: </b><span id="testcount" style="font-weight: bold;">0</span>
                                            &nbsp;<b>Total Amt.: </b><span id="amtcount" style="font-weight: bold;">0</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="TestDetail" style="margin-top: 5px; max-height: 105px; overflow: scroll; width: 100%;">
                                            <table id="tb_ItemList" style="width: 99%; border-collapse: collapse">
                                                <tr id="header">
                                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Code</td>
                                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Item</td>
                                                    <td class="GridViewHeaderStyle" style="width: 30px; text-align: center">View</td>
                                                    <td class="GridViewHeaderStyle" style="width: 30px; text-align: center">MRP</td>
                                                    <td class="GridViewHeaderStyle" style="width: 40px; text-align: center">Rate</td>
                                                   <%-- <td class="GridViewHeaderStyle" style="width: 50px; text-align: center; display: none;">Disc.</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center; display: none;">Amt.</td>--%>
                                                    <td class="GridViewHeaderStyle" style="width: 90px; text-align: center">Delivery Date</td>
                                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center; display: none;">Sam.Coll.</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center; display: none;">Urgent</td>
                                                    <td style="display: none;"></td>

                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>






                        </td>
                        <td width="1%"></td>
                        <td width="22%" valign="top">
                            <div id="paymentdiv">

                                <div class="Purchaseheader">
                                    Payment
                                </div>

                                <table width="99%">

                                    <tr>
                                        <td><b>Total MRP:</b></td>
                                        <td>
                                            <asp:TextBox ID="txttotalMRP" runat="server" Width="120px" ReadOnly="true"></asp:TextBox></td>
                                    </tr>
                                    
                                    <tr>
                                        <td><b>Total Rate:</b></td>
                                        <td>
                                            <asp:TextBox ID="txttotalamount" runat="server" Width="120px" ReadOnly="true"></asp:TextBox></td>
                                    </tr>


                                </table>

                            </div>
                        </td>


                    </tr>

                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="text-align: center;">
                <input type="button" id="btnopenPopup" style="display: none;" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" />
                &nbsp;<input type="button" value="Clear" onclick="clearForm()" class="resetbutton" />
            </div>
        </div>

    </div>
    <div id="popup_box" style="width:500px;">
        <div id="showpopupmsg" style="height: 290px;width:500px; overflow: scroll;"></div>
        <a href="javascript:void(0);" id="popupBoxClose" onclick="unloadPopupBox()">Close</a>
    </div>
    <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Save
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left;">
                        <td style="font-weight: bold;">Call Closing Remarks</td>
                        <td>
                            <textarea id="remarks1"></textarea></td>
                    </tr>
                </table>
                <input type="button" id="btnsave" value="Save" onclick="saveEstimate()" tabindex="21" class="savebutton" />
                <asp:Button ID="btncloseopd" Style="display: none;" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
    <script type="text/javascript">
        $(document).ready(function () {
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
            iFrameEstimate();
            BindRemarks();
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
        function BindRemarks() {

            $.ajax({
                url: "EstimateRate.aspx/GetRemarks",
                data: '{ }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientRemarks = eval('[' + result.d + ']');
                    $('#remarks').append('<option value="">---Select---</option>');
                    if (PatientRemarks.length > 0) {
                        for (var i = 0; i < PatientRemarks.length; i++) {
                            $('#remarks').append('<option value="' + PatientRemarks[i].Remarks + '">' + PatientRemarks[i].Remarks + '</option>');
                        }
                        $('.chosen-container').css('width', '220px');
                        $("#remarks").trigger('chosen:updated');
                    }
                }
            });

        }
        function bindPanel() {
            jQuery("#ddlPanel option").remove();
            jQuery.ajax({
                url: "EstimateRate.aspx/bindPanel",
                data: '{ BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '",StateID: "' + jQuery("#ddlState").val() + '",CityID: "' + jQuery("#ddlCity").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    panelData = jQuery.parseJSON(result.d);
                    if (panelData.length == 0) {
                        jQuery("#ddlPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlPanel").append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < panelData.length; i++) {
                            jQuery("#ddlPanel").append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                        }
                    }
                    $("#<%=ddlPanel.ClientID%>").trigger('chosen:updated');
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery("#ddlCity").attr("disabled", false);
                }
            });
        }
        function bindCity() {
            jQuery("#ddlCity option").remove();
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindCityFromBusinessZone",
                data: '{ StateID: "' + jQuery("#ddlState").val() + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    cityData = jQuery.parseJSON(result.d);
                    if (cityData.length == 0) {
                        jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("Select"));
                        jQuery("#ddlCity").append(jQuery("<option></option>").val("-1").html("ALL"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }
                    }
                    $("#<%=ddlCity.ClientID%>").trigger('chosen:updated');
                    bindPanel();
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery("#ddlCity").attr("disabled", false);
                }

            });
        }
        function bindState() {

            jQuery("#ddlState option").remove();
            if (jQuery("#ddlBusinessZone").val() == "0") {
                jQuery("#ddlState").html('').trigger('chosen:updated');
                jQuery("#ddlCity").html('').trigger('chosen:updated');
                jQuery("#ddlPanel").html('').trigger('chosen:updated');
                return false;
            }
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindState",
                data: '{ BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    stateData = jQuery.parseJSON(result.d);
                    if (stateData.length == 0) {
                        jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                        jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("ALL"));
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                    }
                    $("#<%=ddlState.ClientID%>").trigger('chosen:updated');
                        bindCity();
                        bindPanel();
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlState").attr("disabled", false);
                    }

                });
            }
            function clearItem() {
                $("#ddlInvestigation").val('');
            }
            function showmsg(msg) {
                $('#msgField').html('');
                $('#msgField').append(msg);
                $(".alert").css('background-color', '#04b076');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(1000);
            }
            function showerrormsg(msg) {
                $('#msgField').html('');
                $('#msgField').append(msg);
                $(".alert").css('background-color', 'red');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(1000);
            }
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }
            function extractLast1(term) {
                rblsearchtype = $('input:radio[name=rblsearchtype]:checked').val();

                var length = $('#<%=ddlPanel.ClientID%> > option').length;
                if (length == 0 || $('#<%=ddlPanel.ClientID%>').val() == "" || $('#<%=ddlPanel.ClientID%>').val() == "0") {
                    showerrormsg("Please Select Any Panel");
                    $('#<%=ddlPanel.ClientID%>').focus();
                }
                return split(term).pop();
            }
            $("#ddlInvestigation")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  $("#theHidden").val('');
              })
            .autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    $.getJSON("EstimateRate.aspx?cmd=GetTestList", {
                        SearchType: $('input:radio[name=rblsearchtype]:checked').val(),
                        //  CentreCode: '',
                        //  Gender: '',
                        //   DOB: '',
                        PanelId: $('#<%=ddlPanel.ClientID%>').val().split('#')[1],
                         //  PanelType: '',
                        TestName: extractLast1(request.term),
                        Panel_Id: $('#<%=ddlPanel.ClientID%>').val().split('#')[0]
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
                debugger
                $("#theHidden").val(ui.item.id);
                this.value = '';
                AddItem(ui.item.value, ui.item.type, ui.item.Rate.split('#')[0]);
                return false;
            },
        });
        var testcount = 0;
        var totalamt = 0;
        var InvList = [];
        var itemwisedic = 0;
        function AddItem(itemid, type, Rate) {
            if (itemid == '') {
                showerrormsg("Please select investigation...");
                return false;
            }
            var addedtest = "";

            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    addedtest += $(this).closest("tr").attr("id") + "_" + $(this).closest("tr").find("#tdispackage").text() + ",";
                }
            });
	   if(Rate=='0')
{
showerrormsg("Test Rate Not Uploaded ..... !");
return;
}
		var DeliveryDate='';
		if($('#<%=txtDeliveryDate.ClientID%>').val()!=''){
	        var date = $('#<%=txtDeliveryDate.ClientID%>').val();  
            var months = ["","jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
             DeliveryDate = date.split('-')[2] + '-' + months.indexOf(date.split('-')[1].toLowerCase()) + '-' + date.split('-')[0];      
}      
          $.ajax({
                url: "../Lab/Services/LabBooking.asmx/GetitemRate",
                data: '{ itemid:"' + itemid + '",type:"' + type + '",Rate:"' + Rate + '",addedtest:"' + addedtest + '",centreID:"' + $('#<%=ddlPanel.ClientID%>').val().split('#')[2] + '",DiscPer:"0",DeliveryDate:"' + DeliveryDate + '",MRP:"0"}', // parameter map 
                      type: "POST", // data has to be Posted    	        
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",
                      success: function (result) {
                          TestData = $.parseJSON(result.d);
                          if (TestData.length == 0) {
                              alert('No Record Found..!');
                              return;
                          }
                          else {

                              var MRP = "0";
                              $.ajax({
                                  url: "../Lab/Lab_PrescriptionOPD.aspx/GetMRP",
                                  async: false,
                                  data: JSON.stringify({ ItemId: itemid, PanelId: $('#<%=ddlPanel.ClientID%>').val().split('#')[1] }),
                                  contentType: "application/json; charset=utf-8",
                                  type: "POST", // data has to be Posted 
                                  timeout: 120000,
                                  dataType: "json",
                                  success: function (result) {
                                      MRP = result.d;
                                  }
                              });



                              var inv = TestData[0].Investigation_Id;
                              for (var i = 0; i < (inv.split(',').length) ; i++) {
                                  if ($.inArray(inv.split(',')[i], InvList) != -1) {
                                      showerrormsg("item Already in List..!");
                                      return;
                                  }
                              }
                              for (var i = 0; i < (inv.split(',').length) ; i++) {
                                  InvList.push(inv.split(',')[i]);
                              }
                              testcount = parseInt(testcount) + 1;
                              $('#testcount').html(testcount);
                              if (MRP == 0)
                              {
                                  MRP = TestData[0].Rate;
                              }
                              var mydata = "<tr id='" + TestData[0].ItemID + "' class='GridViewItemStyle' style='background-color:lemonchiffon'>";
                              mydata += '<td class="inv" id=' + TestData[0].Investigation_Id + '><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif"/></a></td>';
                              mydata += '<td id="tdTestCode" style="font-weight:bold;">' + TestData[0].testCode + '</td>';
                              mydata += '<td id="tditemname" style="font-weight:bold;">' + TestData[0].typeName + '</td>';
                              mydata += '<td style="text-align:centre;">';
                              if (TestData[0].SampleRemarks != "") {
                                  mydata += '<a href="javascript:void(0);" onclick="viewremarks(\'' + TestData[0].SampleRemarks + '\',\'' + type + '\');"><img src="../../App_Images/view.gif"/></a>';
                              }
                              mydata += "</td>";
                              if ('0' == "0") {
                                 
                                  mydata += '<td id="tdMRP" class="paymenttd" style="text-align:right">' + MRP + '</td>';
                                  mydata += '<td id="tdrate" class="paymenttd" style="text-align:right">' + TestData[0].Rate + '</td>';
                                  mydata += '<td id="tddisc" class="paymenttd" style="display:none;">';

                                  if ($('#ContentPlaceHolder1_ddlpatienttype').val() == "1" && TestData[0].ispackage == "0") {// durga change 7 june
                                      mydata += '<input id="txttddisc" type="text"  style="width:50px;" value="0" onkeyup="setitemwisediscount(this);" />';
                                  }
                                  else {
                                      mydata += '<input id="txttddisc" type="text"  readonly="true" style="width:50px;" value="0"  />';
                                  }
                                  mydata += '</td>';
                                  mydata += '<td style="display:none;" id="tdamt" class="paymenttd"><input type="text" style="width:50px;" id="txtnetamt" value="' + TestData[0].Rate + '" readonly="readonly"/></td>';
                              }
                              else {
                                  mydata += '<td id="tdMRP" class="paymenttd" style="text-align:right">' + MRP + '</td>';
                                  mydata += '<td id="tdrate" style="color:lemonchiffon;" style="text-align:right">' + TestData[0].Rate + '</td>';
                                  mydata += '<td id="tddisc" style="display:none;">';
                                  mydata += '<input id="txttddisc" type="text"  style="width:50px;display:none;" value="0" onkeyup="setitemwisediscount(this);" />';
                                  mydata += '</td>';
                                  mydata += '<td style="display:none;" id="tdamt"><input type="text" style="width:50px;display:none;" id="txtnetamt" value="' + TestData[0].Rate + '" readonly="readonly"/></td>';
                              }
                              var delData = (TestData[0].DeliveryDate.split('#')[0] == '01-Jan-0001 12:00 AM') ? '' : TestData[0].DeliveryDate.split('#')[0];
                              mydata += '<td id="tddeliverydate" style="font-weight:bold;text-align: center;">' + delData + '</td>';
                              mydata += '<td style="text-align: center;display:none;"><input type="checkbox" id="chsampleself" disabled="disabled"  ';
                              if (TestData[0].SampleDefined != "0") {
                                  mydata += 'checked="checked" ';
                              }
                              mydata += '/></td>';
                              mydata += '<td style="text-align: center;display:none;"><input type="checkbox" id="chkurgent" disabled="disabled" /></td>';
                              mydata += '<td id="tdispackage"    style="display:none;">' + TestData[0].ispackage + '</td>';
                              mydata += '<td id="tdisreporting" style="display:none;">' + TestData[0].reporting + '</td>';
                              mydata += '<td id="tdsubcategoryid" style="display:none;">' + TestData[0].subcategoryid + '</td>';
                              mydata += '<td id="tdeporttype" style="display:none;">' + TestData[0].reporttype + '</td>';
                              mydata += '<td id="tdGenderInvestigate" style="display:none;">' + TestData[0].GenderInvestigate + '</td>';
                              mydata += '<td id="tdSample" style="display:none;">' + TestData[0].Sample + '</td>';

                              mydata += "</tr>";
                              $('#tb_ItemList').append(mydata);
                              sumtotal();

                              $(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                          }
                      },
                      error: function (xhr, status) {
                          //  console.log(xhr.responseText);
                      }
                  });
              }
        function sumtotal() {
            debugger;
                  var net = 0; totalamt = 0; disc = 0;
                  var packagecount = 0;
                  var MRP = 0;
                  $('#tb_ItemList tr').each(function () {
                      var id = $(this).attr("id");
                      if (id != "header") {
                          if ($(this).find('#tdispackage').text() == "1") {
                              packagecount = 1;
                          }
                          if (packagecount == "1") {
                              $('#ContentPlaceHolder1_txtdiscountamt').prop('readonly', true);
                              $('#ContentPlaceHolder1_txtdiscountper').prop('readonly', true);
                          }
                          else {
                              $('#ContentPlaceHolder1_txtdiscountamt').prop('readonly', false);
                              $('#ContentPlaceHolder1_txtdiscountper').prop('readonly', false);
                          }
                          totalamt = parseInt(totalamt) + parseFloat($(this).find('#tdrate').text());
                          $('#amtcount').html(totalamt);
                          net = net + parseFloat($(this).find("#txtnetamt").val());
                          MRP = MRP + parseFloat($(this).find("#tdMRP").text());
                          $('#<%=txttotalamount.ClientID%>').val(net);
                          $('#<%=txttotalMRP.ClientID%>').val(MRP);
                          disc = disc + Number($(this).find("#txttddisc").val());
                      }
                  });
                  var count = $('#tb_ItemList tr').length;
                  if (count == 0 || count == 1) {
                      $('#amtcount').html('0');
                      $('#<%=txttotalamount.ClientID%>').val('0');
                      $('#<%=txttotalMRP.ClientID%>').val('0');
                      
                }
            }
            function deleteItemNode(row) {
                testcount = parseInt(testcount) - 1;
                $('#testcount').html(testcount);

                var $tr = $(row).closest('tr');
                var RmvInv = $tr.find('.inv').attr("id").split(',');
                var len = RmvInv.length;
                InvList.splice($.inArray(RmvInv[0], InvList), len);
                row.closest('tr').remove();
                sumtotal();
            }
            function viewremarks(remarks, type) {
                var mm = "";
                if (type == "Test") {
                    mm = "<h3>Test Details</h3>";
                    mm += remarks;
                }
                else {
                    mm = "<h3>Package Inclussions</h3>";
                    for (var i = 0; i < (remarks.split(',').length) ; i++) {
                        mm += remarks.split(',')[i];
                        mm += "<br/>";
                    }
                }
                $('#showpopupmsg').show();
                $('#showpopupmsg').html(mm);
                $('#popup_box').fadeIn("slow");
                $("#Pbody_box_inventory").css({
                    "opacity": "0.3"
                });

            }
            function unloadPopupBox() {    // TO Unload the Popupbox
                $('#showpopupmsg').html('');
                $('#popup_box').fadeOut("slow");
                $("#Pbody_box_inventory").css({ // this is just for style        
                    "opacity": "1"
                });
            }
            function clearForm() {
              //  $('#<%=ddlBusinessZone.ClientID%>').prop('selectedIndex', 0);
              //  $("#<%=ddlState.ClientID%> option,#<%=ddlCity.ClientID%> option,#<%=ddlPanel.ClientID%> option").remove();
              //  $("#<%=ddlBusinessZone.ClientID%>,#<%=ddlState.ClientID%>,#<%=ddlCity.ClientID%>,#<%=ddlPanel.ClientID%>").trigger('chosen:updated');
                InvList = [];//Empty Inv List
                $('#testcount').html('0');
                $('#amtcount').html('0');
                testcount = 0;
                totalamt = 0;
                $('#tb_ItemList tr').slice(1).remove();
                $(':text').val('');
            }
            function resetPanelItems() {
                InvList = [];//Empty Inv List
                $('#testcount').html('0');
                $('#amtcount').html('0');
                testcount = 0;
                totalamt = 0;
                $('#tb_ItemList tr').slice(1).remove();
                $(':text').val('');
            }
            function iFrameEstimate() {
                var loc = window.location.toString(),
                 params = loc.split('?')[1],
                 params1 = loc.split('&')[1],
                 params2 = loc.split('&')[2],
                 iframe = document.getElementById('estimateiframe');
                if (params != undefined) {
                    $('#mastertopcorner').hide();
                    $('#masterheaderid').hide();
                    $('#btnopenPopup').show();
                    if (params1 == "Patient") {
                        BindDropData(params.split('&')[0]);
                    }
                    if (params1 == "Doctor") {
                        BindDropDoctorData(params2, params1);
                    }
                    if (params1 == "PUP") {
                        BindDropPUPData(params2, params1);
                    }
                    if (params1 == "PCC") {
                        BindDropPCCData(params2, params1);
                    }
                }
                else {
                    $('#btnopenPopup').hide();
                    return false;
                }
            }
            function OpneSavePOpup() {
                if ($('#<%=ddlBusinessZone.ClientID%>').val() == "0") {
                    showerrormsg("Please Select Business Zone..!");
                    return;
                }
                if ($('#<%=ddlState.ClientID%>').val() == "0") {
                    showerrormsg("Please Select State..!");
                    return;
                }
                if ($('#<%=ddlCity.ClientID%>').val() == "0") {
                    showerrormsg("Please Select City..!");
                    return;
                }
                if ($('#<%=ddlPanel.ClientID%>').val() == "0") {
                    showerrormsg("Please Select Panel..!");
                    return;
                }
                if ($('#<%=txttotalamount.ClientID%>').val() == "") {
                    showerrormsg("Please Select Test..!");
                    return;
                }
                $("#overlay1").show();
                $("#dialog1").fadeIn(300);
            }
            function saveEstimate() {

                var loc = window.location.toString(),
                params = loc.split('?')[1],
                params1 = loc.split('&')[1],
                params2 = loc.split('&')[2],
                params3 = params.split('&')[0],
                params4 = loc.split('&')[3].split("Name:")[1],
                iframe = document.getElementById('estimateiframe');

                var MobileNo = params3;
                var CallBy = params1;
                var CallByID = params2;
                var CallType = "Estimate";
                var Remarks = $('#remarks').val();
                var name = "";
                if (params1 == "PUP" || params1 == "PCC") {
                    name = params4.replace(/%20/g, ' ').trim();
                }
                else {
                    name = params4.split(".")[1].trim().replace(/%20/g, ' ').trim();
                }
                $("#btnupdt").attr('disabled', true).val("Submiting...");
                $.ajax({
                    url: "EstimateRate.aspx/SaveNewEstimateLog",
                    data: JSON.stringify({ MobileNo: MobileNo, CallBy: CallBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks, Name: name }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Record Saved..!");
                            $('#btnupdt').attr('disabled', false).val("Save");
                            $("#overlay1").hide();
                            $("#dialog1").fadeOut(300);
                            $('#remarks').val('');
                            $("#remarks").trigger('chosen:updated');
                            clearForm();
                        }
                        else {
                            showerrormsg(save.split('#')[1]);
                            $('#btnupdt').attr('disabled', false).val("Save");
                        }
                    }
                });
            }
            function patientlabinvestigationopd() {
                var dataPLO = new Array();
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        var objPLO = new Object();
                        objPLO.ItemId = $(this).closest("tr").attr("id");
                        objPLO.ItemName = "".concat($(this).closest("tr").find("#tdTestCode").text(), '~', $(this).closest("tr").find("#tditemname").text());
                        objPLO.TestCode = $.trim($(this).closest("tr").find("#tdTestCode").text());
                        objPLO.Rate = $(this).closest("tr").find("#tdrate").html();
                        objPLO.Discount = $(this).closest("tr").find("#txttddisc").val();
                        objPLO.Amount = $(this).closest("tr").find("#txtnetamt").val();
                        objPLO.DeliveryDate = $(this).closest("tr").find("#tddeliverydate").html();
                        dataPLO.push(objPLO);
                    }
                });

                return dataPLO;
            }
            function clearOldpatient() {
                jQuery("#oldpatienttable tr:not(#myheader)").remove();
            }
            function BindDropData(MID) {
                $modelBlockUI();
                $.ajax({
                    url: "../CallCenter/Services/OldPatientData.asmx/BindDropData",
                    data: JSON.stringify({ MobileNo: MID }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var pdata = $.parseJSON(result.d);
                        if (pdata.length > 0) {
                            $modelUnBlockUI();
                            $('#ddlBusinessZone').val(pdata[0].BusinessZoneID);
                            $("#ddlBusinessZone").trigger('chosen:updated');
                            bindState();
                            $('#ddlState').val(pdata[0].stateid);
                            $("#ddlState").trigger('chosen:updated');
                            bindCity();
                            $('#ddlCity').val(pdata[0].cityid);
                            $("#ddlCity").trigger('chosen:updated');
                            if (pdata[0].masterID == "main") {
                                bindPanel();
                                $('#ddlPanel').val(pdata[0].Panel_ID);
                                $("#ddlPanel").trigger('chosen:updated');
                            }
                            else {

                            }
                        }
                        else {
                            $modelUnBlockUI();
                            showerrormsg("No record found");

                        }
                    }
                });
            }
            function BindDropDoctorData(MID, Type) {
                $modelBlockUI();
                $.ajax({
                    url: "../CallCenter/Services/OldPatientData.asmx/BindDropDoctorData",
                    data: JSON.stringify({ MID: MID, Type: Type }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var pdata = $.parseJSON(result.d);
                        if (pdata.length > 0) {
                            $modelUnBlockUI();
                            $('#ddlBusinessZone').val(pdata[0].BusinessZoneID);
                            $("#ddlBusinessZone").trigger('chosen:updated');
                            bindState();
                            $('#ddlState').val(pdata[0].stateid);
                            $("#ddlState").trigger('chosen:updated');
                            bindCity();
                            $('#ddlCity').val(pdata[0].cityid);
                            $("#ddlCity").trigger('chosen:updated');
                            if (pdata[0].masterID == "main") {
                                bindPanel();
                                $('#ddlPanel').val(pdata[0].Panel_ID);
                                $("#ddlPanel").trigger('chosen:updated');
                            }
                            else {

                            }
                        }
                        else {
                            $modelUnBlockUI();
                            showerrormsg("No record found");

                        }
                    }
                });
            }
            function BindDropPUPData(MID, Type) {
                $modelBlockUI();
                $.ajax({
                    url: "../CallCenter/Services/OldPatientData.asmx/BindDropPUPData",
                    data: JSON.stringify({ MID: MID, Type: Type }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var pdata = $.parseJSON(result.d);
                        if (pdata.length > 0) {
                            $modelUnBlockUI();
                            $('#ddlBusinessZone').val(pdata[0].BusinessZoneID);
                            $("#ddlBusinessZone").trigger('chosen:updated');
                            bindState();
                            $('#ddlState').val(pdata[0].StateID);
                            $("#ddlState").trigger('chosen:updated');
                            bindCity();
                            $('#ddlCity').val(pdata[0].CityID);
                            $("#ddlCity").trigger('chosen:updated');
                            bindPanel();
                            $('#ddlPanel').val(pdata[0].Panel_ID);
                            $("#ddlPanel").trigger('chosen:updated');
                        }
                        else {
                            $modelUnBlockUI();
                            showerrormsg("No record found");
                        }
                    }
                });
            }
            function BindDropPCCData(MID, Type) {
                $modelBlockUI();
                $.ajax({
                    url: "../CallCenter/Services/OldPatientData.asmx/BindDropPUPData",
                    data: JSON.stringify({ MID: MID, Type: Type }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var pdata = $.parseJSON(result.d);
                        if (pdata.length > 0) {
                            $modelUnBlockUI();
                            $('#ddlBusinessZone').val(pdata[0].BusinessZoneID);
                            $("#ddlBusinessZone").trigger('chosen:updated');
                            bindState();
                            $('#ddlState').val(pdata[0].StateID);
                            $("#ddlState").trigger('chosen:updated');
                            bindCity();
                            $('#ddlCity').val(pdata[0].CityID);
                            $("#ddlCity").trigger('chosen:updated');
                            bindPanel();
                            $('#ddlPanel').val(pdata[0].Panel_ID);
                            $("#ddlPanel").trigger('chosen:updated');
                        }
                        else {
                            $modelUnBlockUI();
                            showerrormsg("No record found");
                        }
                    }
                });
            }
    </script>
</asp:Content>

