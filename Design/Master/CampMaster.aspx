<%@ Page Language="C#"  MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CampMaster.aspx.cs" Inherits="Design_Master_CampMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
   

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>
     <style type="text/css">
         .compareDateColor {
             background-color: #90EE90;
         }

        
     </style>
   

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" InlineScript="true" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Camp Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblCurrentDate" runat="server" style="display:none"></asp:Label>
            <asp:Label ID="lblCampRequestID" runat="server"  style="display:none"/>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">


            <div class="Purchaseheader">
                Manage Camp
            </div>
            <div class="row">
                <div class="col-md-3">
                  <label class="pull-left">  Camp Name</label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCampName" runat="server" MaxLength="50" onkeyup="changeCampName()"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <span id="spnCampCode" style="display: none;">Camp Code :</span>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCampCode" runat="server" Style="display: none;" disabled></asp:TextBox>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                  <label class="pull-left">  Camp Date </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3" style="display:none">
                  <label class="pull-left">  To Validity Date  </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display:none">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                  <label class="pull-left">  Business Zone  </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindCentre()" CssClass="ddlBusinessZone chosen-select"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                   <label class="pull-left"> Centre </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCentreList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ></asp:ListBox>
                </div>
                <div class="col-md-3">
                  <label class="pull-left">  Tag Business Lab  </label>
			   <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlTagBusinessLab" runat="server"   CssClass="ddlTagBusinessLab chosen-select"></asp:DropDownList>
                </div>
            </div>
            <div class="row" style="text-align:center">
                <input type="button" id="btnAdd" value="Add" onclick="addCamp()" class="ItDoseButton" />
            </div>
            <div class="row">
                <div id="CampOutput" style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <tr id="campHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 220px; text-align: center">Camp Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 110px; text-align: center">Camp Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 110px; text-align: center;display:none">To Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 260px; text-align: center">Centre</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 260px; text-align: center">Tag Business Lab</th>

                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Remove</th>

                    </tr>

                    </table>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: left;">
              <div class="Purchaseheader">
                Manage Item
            </div>
            <div class="row">
                <div class="row">
                    <div class="col-md-8">
                        <input id="rblsearchtype_1" onclick="clearItem()" value="1" name="rblsearchtype" checked="checked" type="radio" />
                        <b>By Test Name</b><input id="rblsearchtype_0" onclick="clearItem()" value="0" name="rblsearchtype" type="radio" />
                        <b>By Test Code</b><input id="rblsearchtype_2" onclick="clearItem()" value="2" name="rblsearchtype" type="radio" />
                        <b>InBetween</b>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8  ui-widget" style="display: inline-block;">
                        <input type="hidden" id="theHidden" />
                        <input id="ddlInvestigation" size="50" tabindex="19" />
                    </div>
                    <div class="col-md-5">
                    </div>
                    <div class="col-md-11">
                        <b>Total Test: </b><span id="spnTestCount" style="font-weight: bold;">0</span>
                        &nbsp;<b>Total Amt.: </b><span id="spnTotalAmt" style="font-weight: bold;">0</span>
                    </div>
                </div>
            </div>
            <div class="row TestDetail" style="margin-top: 5px; max-height: 260px; overflow: scroll;">
                <table id="tb_ItemList" style="border-collapse: collapse; display: none">
                    <tr id="InvHeader">
                        <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">#</td>
                        <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Code</td>
                        <td class="GridViewHeaderStyle" style="width: 420px; text-align: center">Item</td>
                        <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Rate</td>
                        <td style="display: none;"></td>

                    </tr>
                </table>
            </div>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
             <input type="button" class="ItDoseButton" onclick="saveCamp()" id="btnSave" value="Save" title="Click to Save" disabled="disabled" />
             <input type="button" class="ItDoseButton" onclick="updateCamp()" id="btnUpdate" value="Update" title="Click to Update"  style="display:none" />
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
            jQuery('#ddlTagBusinessLab,#ddlBusinessZone').trigger('chosen:updated');
            jQuery("#ddlTagBusinessLab,#ddlBusinessZone").chosen("destroy").chosen({ width: '100%' });
        });
        function changeCampName() {
            var campName = $("#txtCampName").val();
            if ($('#tbSelected tr:not(#campHeader)').length > 0) {
                $(".clCampName").text(campName);
            }
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
                      $.getJSON("CampMaster.aspx?cmd=GetTestList", {
                          SearchType: $('input:radio[name=rblsearchtype]:checked').val(),
                          TestName: extractLast1(request.term)
                      }, response);
                  },
                  search: function () {
                      // custom minLength
                      var term = extractLast1(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {
                      $("#theHidden").val(ui.item.id);
                      this.value = '';
                      AddItem(ui.item.value, ui.item.type, ui.item.Rate);
                      return false;
                  },
              });
        function extractLast1(term) {
            return term;
        }
    </script>
    <script type="text/javascript">
        
        var testcount = 0;
        var totalamt = 0;
        var InvList = [];
        function AddItem(ItemID, type, Rate) {
            if (ItemID == '') {
                toast("Info","Please select investigation...",'');
                return false;
            }
            serverCall('../Common/Services/CommonServices.asmx/GetItemMaster', {ItemID:ItemID ,Type: type ,Rate: Rate  }, function (result) {
                    TestData = $.parseJSON(result);
                    if (TestData.length == 0) {
                        toast('Info','No Record Found..!','');
                        return;
                    }
                    else {

                        var inv = TestData[0].ItemID;
                        for (var i = 0; i < (inv.split(',').length) ; i++) {
                            if ($.inArray(inv.split(',')[i], InvList) != -1) {
                                toast('Info', 'item Already in List..!', '');
                                return;
                            }
                        }
                        for (var i = 0; i < (inv.split(',').length) ; i++) {
                            InvList.push(inv.split(',')[i]);
                        }
                        if ($('#spnTestCount').text() != 0)
                            testcount = $('#tb_ItemList tr:not(#InvHeader)').length;
                        testcount = parseInt(testcount) + 1;
                        $('#spnTestCount').text(testcount);

                        var mydata = [];
                        mydata.push('<tr id="'); mydata.push(TestData[0].ItemID); mydata.push('" class="GridViewItemStyle" style="background-color:lemonchiffon">');
                        mydata.push('<td class="inv" id="'); mydata.push( TestData[0].ItemID );mydata.push('" style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>');
                        mydata.push('<td id="tdTestCode" style="font-weight:bold;">'); mydata.push(TestData[0].testCode); mydata.push('</td>');
                        mydata.push('<td id="tdItemName" style="font-weight:bold;">'); mydata.push(TestData[0].typeName); mydata.push('</td>');
                        mydata.push('<td id="tdRate" style="color:lemonchiffon;text-align: center"><input type="text" style="width:80px;text-align:right;" onkeyup="sumTotal()" id="txtRate" value="0" disabled onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        mydata.push('</tr>');
                        mydata = mydata.join("");
                        $('#tb_ItemList').append(mydata);
                        $('#tb_ItemList').css('display', 'block');
                        sumTotal();

                        $(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                        enableSaveButton();
                    }
                    $modelUnBlockUI(function () { });
            });

        }
        function deleteItemNode(row) {
            testcount = parseInt(testcount) - 1;
            $('#spnTestCount').html(testcount);
            var $tr = $(row).closest('tr');
            var RmvInv = $tr.find('.inv').attr("id").split(',');
            var len = RmvInv.length;
            InvList.splice($.inArray(RmvInv[0], InvList), len);
            row.closest('tr').remove();
            if ($('#tb_ItemList tr:not(#InvHeader)').length == 0) {
                $('#tb_ItemList').hide();

            }
            sumTotal();
            enableSaveButton();
        }
        function sumTotal() {
            var totalAmt = 0;
            $('#tb_ItemList tr').each(function () {
                var id = $(this).attr("id");
                if (id != "InvHeader") {
                    var rate = 0;
                    if (isNaN($(this).find('#txtRate').val()) || ($(this).find('#txtRate').val() == ""))
                        rate = 0;
                    else
                        rate = $(this).find('#txtRate').val();
                    totalAmt = parseFloat(totalAmt) + parseFloat(rate);

                }
            });
            $('#spnTotalAmt').text(totalAmt);
            var count = $('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                $('#spnTotalAmt').html('0');
            }
        }
    </script>
    <script type="text/javascript">
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
        function clearItem() {
            $("#ddlInvestigation").val('');
        }
        $(function () {
            $('[id*=lstCentreList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
    </script>
    <script type="text/javascript">
        function addCamp() {
            $("#lblMsg").text('');
            if (jQuery.trim($("#txtCampName").val()) == "") {
                $("#txtCampName").focus();
                $("#lblMsg").text('Please Enter Camp Name');
                return;
            }
            var SelectedLaength = $('#lstCentreList').multipleSelect("getSelects").length;

            if (SelectedLaength == 0) {
                $("#lstCentreList").focus();
                $("#lblMsg").text('Please Select Centre');
                return;
            }
            if ($('[id$=ddlTagBusinessLab]').val() == "-1") {
                $('[id$=ddlTagBusinessLab]').focus();
                $("#lblMsg").text('Please Select Tag Business Lab');
                return;
            }
            PageMethods.getCampCount(jQuery.trim($("#txtCampName").val()), Panel_ID, onCampSuccess, OnCampfailure);
        }
        function onCampSuccess(result) {
            var $responseData = JSON.parse(result);
            if ($responseData.response == "0") {
                var centreCon = 0;
                if ($('#tbSelected tr:not(#campHeader)').length > 0) {
                    $('#tbSelected tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "campHeader") {
                            var CentreID = $(this).closest('tr').find("#tdCentreID").text();
                            var CentreName = $(this).closest('tr').find("#tdCentreName").text();
                            $('#lstCentreList :selected').each(function (i, selected) {
                                if ($(selected).val() == CentreID) {
                                    $("#lblMsg").text(CentreName + " Centre Already Added");
                                    centreCon = 1;
                                    return;
                                }
                            });
                        }
                    });
                }
                if (centreCon == 1) {
                    return;
                }
                $('#tbSelected').css('display', 'block');
                $('#lstCentreList :selected').each(function (i, selected) {
                    var mydata = [];
                    mydata.push('<tr id="'); mydata.push($(selected).val()); mydata.push('">');
                    mydata.push('<td class="GridViewItemStyle" id="tdSno" style="display:none">'); mydata.push((i + 1)); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdCampName" ><span class="clCampName" >'); mydata.push($("#txtCampName").val()); mydata.push('</span></td>');
                    mydata.push('<td class="GridViewItemStyle"><input  onclick="chkFromDate(this)" id="txtFromDate'); mydata.push($(selected).val()); mydata.push('" onmousedown="chkFromDate(this)" value="'); mydata.push($("#txtFromDate").val()); mydata.push('"style="width:110px"/></td>');
                    mydata.push(' <td class="GridViewItemStyle" style="display:none"> <input  onclick="chkToDate(this)" id="txtToDate'); mydata.push($(selected).val()); mydata.push('" onmousedown="chkToDate(this)" value="'); mydata.push($("#txtToDate").val()); mydata.push('"style="width:110px;display:none"/></td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreName">'); mydata.push($(selected).text()); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdTagBusinessLab">'); mydata.push($('#ddlTagBusinessLab option:selected').text()); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdTagBusinessLabId" style="display:none">'); mydata.push($('#ddlTagBusinessLab').val()); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreID" style="display:none">'); mydata.push($(selected).val()); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" style="text:align:center"><img src="../../App_Images/Delete.gif" style="cursor:pointer;text:align:center"  onclick="removeCentre(this)" title="Click to Remove"/></td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdBusinessZoneID" style="display:none">'); mydata.push($("#ddlBusinessZone").val()); mydata.push('</td>');
                    mydata.push('</tr>');
                    mydata = mydata.join("");
                    $('#tbSelected').append(mydata);
                });
                if ($('#tbSelected tr:not(#campHeader)').length > 0) {
                    $("#txtCampName").attr('disabled', 'disabled');
                    $('#ddlTagBusinessLab').prop('disabled', 'disabled');
                }
                else {
                    $("#txtCampName").removeAttr('disabled');
                    $('#ddlTagBusinessLab').val('-1');
                    $('#ddlTagBusinessLab').removeAttr('disabled');
                }
                //$('#lstCentreList option').prop('selected', false);
                $('#ddlBusinessZone').prop('selectedIndex', 0);
                $("#lstCentreList option").remove();
                $("#lstCentreList").multipleSelect('refresh');
                enableSaveButton();
            }
            else {
                $('#lblMsg').text('Camp Name Already Exists');
            }
        }
        function OnCampfailure() {
            $('#lblMsg').text('Error');
        }
        function removeCentre(rowID) {
            $(rowID).closest('tr').remove();
            if ($('#tbSelected tr:not(#campHeader)').length == 0) {
                $('#tbSelected').hide();
                // $("#txtCampName").removeAttr('disabled');
            }
            if ($('#tbSelected tr:not(#campHeader)').length == 0) {
                $("#txtCampName").removeAttr('disabled');
                $('#ddlTagBusinessLab').val('-1');
                $('#ddlTagBusinessLab').removeAttr('disabled');
            }
            enableSaveButton();
        }
        function chkToDate(rowid) {
            var CentreID = $(rowid).closest('tr').find("#tdCentreID").text();
            $(rowid).closest('tr').find('#txtToDate' + CentreID).datepicker({
                changeYear: true,
                dateFormat: "dd-M-yy",
                changeMonth: true,
                buttonImageOnly: true,
                minDate: new Date(),
                onSelect: function (dateText, inst) {
                    $(rowid).closest('tr').find('#txtToDate' + CentreID).val(dateText);
                    ChkDate($(rowid).closest('tr').find('#txtFromDate' + CentreID).val(), $(rowid).closest('tr').find('#txtToDate' + CentreID).val(), $(rowid).closest('tr'));
                }
            }).attr('readonly', 'readonly');;
        }
        function chkFromDate(rowid) {
            var CentreID = $(rowid).closest('tr').find("#tdCentreID").text();
            $(rowid).closest('tr').find('#txtFromDate' + CentreID).datepicker({
                dateFormat: "dd-M-yy",
                  changeMonth: true,
                  changeYear: true,
                  minDate: new Date(),
                onSelect: function (dateText, inst) {
                    $(rowid).closest('tr').find('#txtFromDate' + CentreID).val(dateText);
                    ChkDate($(rowid).closest('tr').find('#txtFromDate' + CentreID).val(), $(rowid).closest('tr').find('#txtToDate' + CentreID).val(), $(rowid).closest('tr'));

                }
            }).attr('readonly', 'readonly');;
        }
        function enableSaveButton() {
            if (($('#tbSelected tr:not(#campHeader)').length > 0) && ($('#tb_ItemList tr:not(#InvHeader)').length > 0)) {
                $('#btnSave').removeAttr('disabled');
            }
            else {
                $('#btnSave').attr('disabled', 'disabled');
            }
        }
    </script>
    <script type="text/javascript">
        function bindCentre() {
            $("#lstCentreList option").remove();
            $("#lstCentreList").multipleSelect('refresh');
            if ($("#ddlBusinessZone").val() != "0") {
                PageMethods.bindCentre($("#ddlBusinessZone").val(), onSuccessCallback, OnfailureCallback);
            }
        }
        function onSuccessCallback(result) {
            var CentreData = jQuery.parseJSON(result);
            if (CentreData.length == 0) {
                $('#<%=lstCentreList.ClientID%>').append($("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                for (i = 0; i < CentreData.length; i++) {
                    $('#<%=lstCentreList.ClientID%>').append($("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                }
                $('[id*=lstCentreList]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
        }
        function OnfailureCallback(error) {
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate($('#txtFromDate').val(), $('#txtToDate').val(), 0);
            });
            $('#txtToDate').change(function () {
                ChkDate($('#txtFromDate').val(), $('#txtToDate').val(), 0);
            });
        });
        function ChkDate(FromDate, ToDate, chkCon) {
            CommonServices.CompareFromToDate(FromDate, ToDate, onSuccessDate, OnfailureDate, chkCon)
        }
        function onSuccessDate(result, chkCon) {
            if (result == 0) {
                $('#lblMsg').text('To date can not be less than from date!');
                $('#btnAdd').attr('disabled', 'disabled');
                if (chkCon != 0)
                    chkCon.addClass("compareDateColor");
            }
            else {
                $('#lblMsg').text('');
                $('#btnAdd').removeAttr('disabled');
                if (chkCon != 0)
                    chkCon.removeClass("compareDateColor");
            }
        }
        function OnfailureDate() {

        }
    </script>
    <script type="text/javascript">
        function getItemDetail() {
            var dataCamp = new Array();
            var ObjCamp = new Object();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "InvHeader") {
                    ObjCamp.ItemID = $(this).closest("tr").attr("id");
                    ObjCamp.Rate = $(this).closest("tr").find("#txtRate").val();
                    ObjCamp.ItemName = $(this).closest("tr").find("#tdItemName").text();
                    ObjCamp.TestCode = $(this).closest("tr").find("#tdTestCode").text();
                    dataCamp.push(ObjCamp);
                    ObjCamp = new Object();
                }
            });
            return dataCamp;
        }
        function getCampCentreDetail() {
            var dataCamp = new Array();
            var ObjCamp = new Object();
            $('#tbSelected tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "campHeader") {
                    ObjCamp.Company_Name = $(this).closest("tr").find("#tdCampName").text();
                    var CentreID = $(this).closest('tr').find("#tdCentreID").text();
                    ObjCamp.FromValidDate = $(this).closest("tr").find("#txtFromDate" + CentreID).val();
                    ObjCamp.ToValidDate = $(this).closest("tr").find("#txtToDate" + CentreID).val();
                    ObjCamp.CentreID = $(this).closest('tr').find("#tdCentreID").text();
                    if (Panel_ID != "") {
                        ObjCamp.Panel_ID = Panel_ID;
                    }
                    ObjCamp.TagBusinessLab = $(this).closest('tr').find("#tdTagBusinessLab").text();
                    ObjCamp.TagBusinessLabId = $(this).closest('tr').find("#tdTagBusinessLabId").text();
                    dataCamp.push(ObjCamp);
                    ObjCamp = new Object();
                }
            });
            return dataCamp;
        }
        function validateCamp() {
            $("#lblMsg").text('');
            if ($('#tbSelected tr:not(#campHeader)').length == 0) {
                $("#lblMsg").text('Please Add Centre Wise Camp');
                return false;
            }
            if ($(".compareDateColor").length > 0) {
                $("#lblMsg").text('To date can not be less than from date!');
                return false;
            }
            if ($('#tb_ItemList tr:not(#InvHeader)').length == 0) {
                $("#lblMsg").text('Please Add Item');
                return false;
            }
            var itemRate = 0;
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "InvHeader") {
                    if ($(this).closest("tr").find("#txtRate").val() == "") {
                        itemRate = 1;
                        $(this).closest("tr").find("#txtRate").focus();
                        return false;
                    }
                }
            });
            if (itemRate == 1) {
                $("#lblMsg").text('Rate Should be Greater OR Equal to Zero');
                return false;
            }
            return true;
        }
        function saveCamp() {
            if (validateCamp()) {
                $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                var CampDetail = getCampCentreDetail();
                var ItemDetail = getItemDetail();
                PageMethods.saveCamp(CampDetail, ItemDetail,$("#lblCampRequestID").text(), onSuccess, Onfailure);
            }
        }
        function onSuccess(result) {
            var resultnew = JSON.parse(result);
            if (resultnew.status == true) {
                $('#lblMsg').text('Record Save Successfully');
                clearData();
            }
            else if (resultnew.status == false) {
                $('#lblMsg').text(resultnew.response);
            }        
            $("#btnSave").removeAttr('disabled').val('Save');
        }
        function Onfailure() {
            $('#lblMsg').text('Error');
            $("#btnSave").removeAttr('disabled').val('Save');
        }
        function clearData() {
            InvList = [];
            $('#tbSelected,#tb_ItemList').hide();
            $("#tbSelected tr:not(#campHeader),#tb_ItemList tr:not(#InvHeader)").remove();
            $('#spnTestCount,#spnTotalAmt').text('0');
            $('#txtCampName').val('').removeAttr('disabled');
            $('#ddlBusinessZone').prop('selectedIndex', 0);
            $("#lstCentreList option").remove();
            $("#lstCentreList").multipleSelect('refresh');
            $('input:radio[name="rblsearchtype"][value="1"]').prop('checked', true);
            $('#ddlTagBusinessLab').val('-1');
            $('#ddlTagBusinessLab').removeAttr('disabled');
            totalamt = 0;
            testcount = 0;
        }
    </script>
    <script type="text/javascript">
        var Panel_ID = "";
        $(function () {
            Panel_ID = '<%=Util.GetString(Request.QueryString["Panel_ID"])%>';
            if (Panel_ID != "") {
                $("#btnSave").hide();
                $("#btnUpdate").show();
                PageMethods.getCampDetail(Panel_ID, onSuccessCamp, OnfailureCamp, Panel_ID);
            }
        });
        function onSuccessCamp(result, Panel_ID) {
            $('#tbSelected').css('display', 'block');
            var CampData = jQuery.parseJSON(result);
            $("#txtCampName").val(CampData[0].Company_Name);
            $("#spnCampCode").show();
            $("#txtCampCode").show();
            $("#txtCampCode").val(CampData[0].Panel_Code);
            for (var i = 0; i < CampData.length; i++) {
                var mydata = [];
                mydata.push('<tr id="'); mydata.push(CampData[i].CentreID); mydata.push('">');
                mydata.push('<td class="GridViewItemStyle" id="tdSno" style="display:none">'); mydata.push((i + 1)); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCampName" ><span class="clCampName" >'); mydata.push(CampData[i].Company_Name); mydata.push('</span></td>');
                mydata.push('<td class="GridViewItemStyle"><input  onclick="chkFromDate(this)" id="txtFromDate'); mydata.push(CampData[i].CentreID); mydata.push('"  onmousedown="chkFromDate(this)" value="'); mydata.push(CampData[i].FromValidDate); mydata.push('" style="width:110px"/></td>');
                mydata.push(' <td class="GridViewItemStyle" style="display:none"> <input  onclick="chkToDate(this)" id="txtToDate'); mydata.push(CampData[i].CentreID); mydata.push('" onmousedown="chkToDate(this)" value="'); mydata.push(CampData[i].ToValidDate); mydata.push('" style="width:110px;display:none"/></td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCentreName">'); mydata.push( CampData[i].CentreName); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCentreID" style="display:none">'); mydata.push(CampData[i].CentreID); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" ><img src="../../App_Images/Delete.gif" style="cursor:pointer;text:align:center"  onclick="removeCentre(this)"/></td>'); 
                mydata.push('</tr>');
                mydata = mydata.join("");
                $('#tbSelected').append(mydata);
            }           
            PageMethods.getCampItemDetail(Panel_ID, onSuccessCampItem, OnfailureCampItem, Panel_ID);
        }
        function OnfailureCamp() {

        }
        function onSuccessCampItem(result, Panel_ID) {
            var TestData = jQuery.parseJSON(result);
            for (var i = 0; i < TestData.length; i++) {
                InvList.push(TestData[i].ItemID);
                var mydata = [];
                mydata.push('<tr id="'); mydata.push(TestData[i].ItemID); mydata.push('" class="GridViewItemStyle" style="background-color:lemonchiffon">');
                mydata.push('<td class="inv" id="'); mydata.push(TestData[i].ItemID); mydata.push('" style="text-align: center"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" title="Click to Remove Item"/></a></td>'); mydata.push();
                mydata.push('<td id="tdTestCode" style="font-weight:bold;">'); mydata.push(TestData[i].TestCode); mydata.push('</td>');
                mydata.push('<td id="tdItemName" style="font-weight:bold;">'); mydata.push(TestData[i].ItemName); mydata.push('</td>');
                mydata.push('<td id="tdispackage"    style="display:none;">0</td>'); mydata.push(''); mydata.push(''); 
                mydata.push('<td id="tdRate" style="color:lemonchiffon;text-align: center"><input type="text" style="width:80px;" onkeyup="sumTotal()" id="txtRate" value="');mydata.push(TestData[i].Rate);mydata.push('" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                mydata.push('</tr>'); 
                $('#tb_ItemList').append(mydata);
                $('#tb_ItemList').css('display', 'block');
                $(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
            }          
            $('#spnTestCount').text(TestData.length);
            testcount = TestData.length;
            sumTotal();
            enableSaveButton();
        }
        function OnfailureCampItem() {

        }
    </script>
    <script type="text/javascript">
        function updateCamp() {
            if (validateCamp()) {
                $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
                var CampDetail = getCampCentreDetail();
                var ItemDetail = getItemDetail();
                PageMethods.updateCamp(CampDetail, ItemDetail, onUpdateSuccess, OnUpdatefailure);
            }
        }
        function onUpdateSuccess(result) {
            var resultnew = JSON.parse(result);
            if (resultnew.status == true) {
                $('#lblMsg').text('Record Updated Successfully');
                clearData();
                $("#btnUpdate").removeAttr('disabled').val('Update');
                location.href = '../../Design/Master/CampEditMaster.aspx';
            }
            else if (resultnew.status == false) {
                $('#lblMsg').text(resultnew.response);
            }
            
            $("#btnUpdate").removeAttr('disabled').val('Update');
        }
        function OnUpdatefailure() {
            $('#lblMsg').text('Error');
            $("#btnUpdate").removeAttr('disabled').val('Update');
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            if ($("#lblCampRequestID").text() != "") {
                getCampDetail();
                jQuery('input:radio[name=rblsearchtype]').attr('disabled', 'disabled');
                jQuery('#ddlInvestigation').attr('disabled', 'disabled');
            }
        });
        getCampDetail = function () {
            serverCall('CampMaster.aspx/GetCampItemDetails', { ID: $("#lblCampRequestID").text() }, function (result) {
                TestData = jQuery.parseJSON(result);
                if (TestData.length == 0) {
                    toast('Info', 'No Record Found..!', '');
                    return;
                }
                else {
                    for (var k = 0; k < TestData.length ; k++) {
                        var inv = TestData[k].ItemID.toString();                       
                        for (var i = 0; i < inv.split(',').length ; i++) {
                            InvList.push(inv.split(',')[i]);
                        }                       
                        var mydata = [];
                        mydata.push('<tr id="'); mydata.push(TestData[k].ItemID); mydata.push('" class="GridViewItemStyle" style="background-color:lemonchiffon">');
                        mydata.push('<td class="inv" id="'); mydata.push(TestData[k].ItemID);
                        mydata.push('" style="text-align: center"></td>');                 
                        mydata.push('<td class="inv" id="'); mydata.push(TestData[k].ItemID); mydata.push('</td>');
                        mydata.push('<td id="tdTestCode" style="font-weight:bold;">'); mydata.push(TestData[k].testCode); mydata.push('</td>');
                        mydata.push('<td id="tdItemName" style="font-weight:bold;">'); mydata.push(TestData[k].typeName); mydata.push('</td>');
                        mydata.push('<td id="tdRate" style="text-align: right">'); 
                        mydata.push('<input type="text" style="width:80px;text-align:right" id="txtRate" value="'); mydata.push(TestData[k].RequestedRate); mydata.push('" disabled maxlength="6"/></td>');
                        mydata.push('</tr>');
                        mydata = mydata.join("");
                        $('#tb_ItemList').append(mydata);
                        $('#tb_ItemList').css('display', 'block');
                    }                    
                    testcount = parseInt(jQuery('#tb_ItemList tr:not(#InvHeader)').length);
                    jQuery('#spnTestCount').text(testcount);
                    sumTotal();
                }
            });                     
            jQuery('#btnSave').removeAttr('disabled');
        }
        var $AddressDetail = [];
        function bindCampBusinessDetail(addressDetails) {
            jQuery("#btnAdd").hide();
            jQuery("#txtFromDate,#txtToDate").attr('disabled', 'disabled');
            var $AddressDetail = $.parseJSON(addressDetails);
            jQuery("#ddlBusinessZone").val($AddressDetail[0]);
            jQuery("#ddlBusinessZone").chosen("destroy").chosen({ width: '100%' });
            jQuery('#lstCentreList').append($("<option></option>").val($AddressDetail[2]).html($AddressDetail[3]));
            jQuery('[id*=lstCentreList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery("#ddlTagBusinessLab").val($AddressDetail[4]);
            jQuery("#ddlTagBusinessLab").chosen("destroy").chosen({ width: '100%' });
            jQuery('#lstCentreList').find(":checkbox[value='" + $AddressDetail[2] + "']").attr("checked", "checked");
            jQuery("[id*=lstCentreList] option[value='" + $AddressDetail[2] + "']").attr("selected", 1);
            
            jQuery('#lstCentreList').multipleSelect("refresh");
            jQuery("#lstCentreList").multipleSelect("disable");
            jQuery("#lstCentreList").prop('disabled', 'disabled');
            jQuery('#lstCentreList').multipleSelect("refresh");
            var centreCon = 0;
            if ($('#tbSelected tr:not(#campHeader)').length > 0) {
                $('#tbSelected tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "campHeader") {
                        var CentreID = $(this).closest('tr').find("#tdCentreID").text();
                        var CentreName = $(this).closest('tr').find("#tdCentreName").text();
                        $('#lstCentreList :selected').each(function (i, selected) {
                            if ($(selected).val() == CentreID) {
                                $("#lblMsg").text(CentreName + " Centre Already Added");
                                centreCon = 1;
                                return;
                            }
                        });
                    }
                });
            }
            if (centreCon == 1) {
                return;
            }
            $('#tbSelected').css('display', 'block');
            $('#lstCentreList :selected').each(function (i, selected) {
                var mydata = [];
                mydata.push('<tr id="'); mydata.push($(selected).val().trim()); mydata.push('">');
                mydata.push('<td class="GridViewItemStyle" id="tdSno" style="display:none">'); mydata.push((i + 1)); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCampName" ><span class="clCampName" >'); mydata.push($("#txtCampName").val()); mydata.push('</span></td>');
                mydata.push('<td class="GridViewItemStyle"><input disabled onclick="chkFromDate(this)" id="txtFromDate'); mydata.push($(selected).val().trim()); mydata.push('" onmousedown="chkFromDate(this)" value="'); mydata.push($("#txtFromDate").val()); mydata.push('"style="width:110px"/></td>');
                mydata.push(' <td class="GridViewItemStyle" style="display:none"> <input disabled onclick="chkToDate(this)" id="txtToDate'); mydata.push($(selected).val().trim()); mydata.push('" onmousedown="chkToDate(this)" value="'); mydata.push($("#txtToDate").val()); mydata.push('"style="width:110px;display:none"/></td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCentreName">'); mydata.push($(selected).text()); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdTagBusinessLab">'); mydata.push($('#ddlTagBusinessLab option:selected').text()); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdTagBusinessLabId" style="display:none">'); mydata.push($('#ddlTagBusinessLab').val()); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdCentreID" style="display:none">'); mydata.push($(selected).val().trim()); mydata.push('</td>');
                mydata.push('<td class="GridViewItemStyle" style="text:align:center">&nbsp;</td>');
                mydata.push('<td class="GridViewItemStyle" id="tdBusinessZoneID" style="display:none">'); mydata.push($("#ddlBusinessZone").val()); mydata.push('</td>');
                mydata.push('</tr>');
                mydata = mydata.join("");
                $('#tbSelected').append(mydata);
            });

            if (jQuery('#tbSelected tr:not(#campHeader)').length > 0) {
                jQuery("#txtCampName").attr('disabled', 'disabled');
                jQuery('#ddlTagBusinessLab').attr('disabled', 'disabled').chosen("destroy").chosen({ width: '100%' });
                jQuery("#ddlBusinessZone").attr('disabled', 'disabled').chosen("destroy").chosen({ width: '100%' });
            }
            else {
                $("#txtCampName").removeAttr('disabled');
                $('#ddlTagBusinessLab').val('-1');
                $('#ddlTagBusinessLab').removeAttr('disabled');

            }
            enableSaveButton();


        }
    </script>
</asp:Content>

