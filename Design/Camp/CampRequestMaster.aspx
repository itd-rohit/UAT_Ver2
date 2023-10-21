<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampRequestMaster.aspx.cs" Inherits="Design_Camp_CampRequestMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">

    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <asp:Label ID="lblHeader" Style="font-weight: bold" runat="server">Camp Request</asp:Label>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    <asp:Label ID="lblCampID" runat="server" Style="display: none"></asp:Label>


                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Camp Detail
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3">
                    <label class="pull-left">Camp Centre</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select chosen-container" onchange="$resetPanelItems();"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3">
                    <label class="pull-left">Camp Name</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCamp" runat="server" CssClass="ddlCamp chosen-select chosen-container" onchange="$otherCamp()"></asp:DropDownList>

                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-3 clOtherCampName" style="display: none">
                    <label class="pull-left">Other Camp Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 clOtherCampName" style="display: none">
                    <asp:TextBox ID="txtCampName" runat="server" MaxLength="100" AutoCompleteType="Disabled" CssClass="requiredField" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3">
                    <label class="pull-left">Camp Coordinator</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtCampCoOrdinator" runat="server" AutoCompleteType="Disabled" MaxLength="50" />
                </div>
                <div class="col-md-1 "></div>
                <div class="col-md-4 ">
                    <label class="pull-left">Camp Location Address</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6 ">
                    <asp:TextBox ID="txtCampAddress" runat="server" MaxLength="100" AutoCompleteType="Disabled" />
                </div>
            </div>
            <div class="row">


                <div class="col-md-5 ">
                    <label class="pull-left">Camp Coordinator Contact No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 ">
                    <asp:TextBox ID="txtCampContactNo" runat="server" MaxLength="10" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftbCamoContactNo" runat="server" TargetControlID="txtCampContactNo" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Camp Type</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4 ">
                    <asp:DropDownList ID="ddlCampType" runat="server" CssClass="ddlCampType chosen-select chosen-container" onchange="$campTypeDetail()">
                        <asp:ListItem Value="0" Text="Select" Selected="True"></asp:ListItem>
                        <asp:ListItem Value="1" Text="Free Camp"></asp:ListItem>
                        <asp:ListItem Value="2" Text="Paid Camp"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Camp From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 ">
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="requiredField" />
                    <cc1:CalendarExtender ID="calStartDate" runat="server" TargetControlID="txtStartDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">End Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="requiredField" />
                    <cc1:CalendarExtender ID="calEndDate" runat="server" TargetControlID="txtEndDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
            </div>

            <div class="row">
                            
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkIsAllowTinySms" Checked="true" runat="server" Text="SendTinySMSReport" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkissendtinysmsbill" Checked="true" runat="server" Text="SendTinySmsBill" />
                            </div>
                        </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="margin-top: 0px;">
                <div class="col-md-8">
                    <div class="row">
                        <div style="padding-right: 0px;" class="col-md-18">
                            <label class="pull-left">
                                <input id="rdbItem_1" type="radio" name="labItems" value="1" onclick="$clearItem(function () { })" checked="checked" />
                                <label for="rdbItem_1">By Name</label>
                                <input id="rdbItem_0" type="radio" name="labItems" value="0" onclick="$clearItem(function () { })" />
                                <label for="rdbItem_0">By Code </label>
                                <input id="rdbItem_2" type="radio" name="labItems" value="2" onclick="$clearItem(function () { })" />
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
                            <input type="text" id="txtInvestigationSearch" title="Enter Search Text" autocomplete="off" />
                        </div>
                    </div>
                </div>
                <div class="col-md-16">
                    <div class="row">
                        &nbsp;
                    </div>
                    <div class="row">
                        <div style="padding-left: 15px;" class="col-md-24">
                            <div style="height: 146px; overflow-y: auto; overflow-x: hidden;">
                                <table id="tb_ItemList" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
                                    <thead>
                                        <tr id="LabHeader">
                                            <td class="GridViewHeaderStyle" style="width: 30px;">#</td>
                                            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Code</td>
                                            <td class="GridViewHeaderStyle" style="width: 380px; text-align: center">Item</td>
                                            <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Rate</td>
                                            <td class="GridViewHeaderStyle" style="width: 110px; text-align: center">Requested Rate</td>

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
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="Save" onclick="$saveCampRequest()" class="savebutton" />
            &nbsp;<input type="button" id="btnClear" value="Clear" onclick="$clearForm()" class="resetbutton" />
            <input type="button" id="btnApprove" value="Approve" onclick="$approveCampRequest()" class="savebutton" style="display: none" />
            &nbsp;<input type="button" id="btnReject" value="Reject" onclick="$rejectCampRequest()" class="resetbutton" style="display: none" />
        </div>
    </div>
    <div id="divViewRemarks" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 60%; max-width: 62%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Remarks Detail</h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeViewRemarksModel()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div id="divPopUPRemarks" class="col-md-24">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeViewRemarksModel()">Close</button>
                </div>
            </div>
        </div>
    </div>

     <div id="divRejectRemarks" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 50%; max-width: 52%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Reject Reason</h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeRejectRemarksModel()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div  class="row">
                        <div class="col-md-5 ">
                    <label class="pull-left">Reject Reason</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-16 ">
                    <asp:TextBox ID="txtRejectReason" runat="server" MaxLength="100" AutoCompleteType="Disabled" CssClass="requiredField"></asp:TextBox>
                    </div>
                    </div>
                     <div  class="row" style="text-align:center">
                     <input type="button" id="btnCampReject" value="Reject" onclick="$campReject()" />
                         </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeRejectRemarksModel()">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
         $closeViewRemarksModel = function (callback) {
            jQuery('#divViewRemarks').hideModel();
        }
         $closeRejectRemarksModel = function (callback) {
             jQuery('#divRejectRemarks').hideModel();
         }
         function onKeyDown(e) {
             if (e && e.keyCode == Sys.UI.Key.esc) {
                 if (jQuery('#divViewRemarks').is(':visible')) {
                     jQuery('#divViewRemarks').hideModel();
                 }
                 else if (jQuery('#divRejectRemarks').is(':visible')) {
                     jQuery('#divRejectRemarks').hideModel();
                 }
             }
         }
         pageLoad = function (sender, args) {
             if (!args.get_isPartialLoad()) {
                 $addHandler(document, "keydown", onKeyDown);
             }
         }
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
        function $resetPanelItems() {
            InvList = [];
            jQuery('#lblTotalLabItemsCount').text('0');
            jQuery('#tb_ItemList tr').slice(1).remove();
            jQuery('#tb_ItemList').hide();
        }
        function campRequest() {
            var CampName = "";
            if (jQuery("#ddlCamp").val() == -1) {
                CampName = jQuery.trim(jQuery("#txtCampName").val());
            }
            else {
                CampName = jQuery("#ddlCamp option:selected").text();
            }
            var $objCamp = new Array();
            $objCamp.push({
                CampID: jQuery("#ddlCamp").val(),
                CampName: CampName,
                CampCoordinator: jQuery("#txtCampCoOrdinator").val(),
                CampAddress: jQuery("#txtCampAddress").val(),
                ContactNo: jQuery("#txtCampContactNo").val(),
                Panel_ID: jQuery('#ddlPanel').val().split('#')[0],
                CentreID: jQuery('#ddlPanel').val().split('#')[2],
                StartDate: jQuery("#txtStartDate").val(),
                EndDate: jQuery("#txtEndDate").val(),
                ID: jQuery("#lblCampID").text() == "" ? 0 : jQuery("#lblCampID").text(),
                CampTypeID: jQuery("#ddlCampType").val(),
                CampType: jQuery("#ddlCampType option:selected").text()
            });
            return $objCamp;
        }
        function campItemDetail() {
            var dataCamp = new Array();
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    var objCamp = new Object();
                    objCamp.ItemId = jQuery(this).closest("tr").attr("id");
                    objCamp.ItemCode = jQuery(this).closest("tr").find("#tdTestCode").text();
                    objCamp.ItemName = jQuery(this).closest("tr").find("#tdItemName").text();
                    objCamp.Rate = jQuery(this).closest("tr").find("#txtRequestedRate").val();
                    dataCamp.push(objCamp);
                }
            });
            return dataCamp;
        }
        $validation = function () {
            if (jQuery('#ddlCamp').val() == 0) {
                toast("Error", "Please Select Camp Name", "");
                jQuery('#ddlCamp').focus();
                return false;
            }
            if (jQuery('#ddlCamp').val()==-1 && jQuery('#txtCampName').val() == "") {
                toast("Error", "Please Enter Camp Name", "");
                jQuery('#txtCampName').focus();
                return false;
            }
            if (jQuery('#ddlCampType').val() == 0) {
                toast("Error", "Please Select Camp Type", "");
                jQuery('#ddlCampType').focus();
                return false;
            }
            if (jQuery('#tb_ItemList tbody tr').length == 0) {
                toast("Error", "Please Add Test Detail", "");
                jQuery('#txtInvestigationSearch').focus();
                return false;
            }
            var rv = true;
            jQuery('#tb_ItemList tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "LabHeader") {
                    if (jQuery(this).closest("tr").find("#txtRequestedRate").val() == "") {
                        toast("Error", "Please Enter Camp Item Requested Rate", "");
                        jQuery(this).closest("tr").find("#txtRequestedRate").focus();
                        return rv = false;
                    }
                }
            });
            if (!rv) {
                return false;
            }
            return true;
        }
        $saveCampRequest = function () {
            if (!$validation()) {
                return;
            }
            var campData = campRequest();
            var campItemData = campItemDetail();
            if (campItemData.length == 0) {
                toast("Error", "Please Add Test Detail", "");
                jQuery('#txtInvestigationSearch').focus();
                return;
            }
            var IsAllowTinySms = jQuery("#chkIsAllowTinySms").is(":checked") ? 1 : 0;
            var IsSendTinySmsBill = jQuery("#chkissendtinysmsbill").is(":checked") ? 1 : 0;

            jQuery("#btnSave").attr('disabled', true).val("Submiting...");
            serverCall('CampRequestMaster.aspx/SaveCampRequest', { CR: campData, CI: campItemData, IsAllowTinySms: IsAllowTinySms, IsSendTinySmsBill: IsSendTinySmsBill }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.Status) {
                    $clearForm();
                    jQuery('#txtStartDate').val($responseData.FromDate);
                    jQuery('#txtEndDate').val($responseData.ToDate);

                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                    if ($responseData.focusControl != null) {
                        jQuery('#' + $responseData.focusControl).focus();
                    }
                }
                jQuery('#btnSave').attr('disabled', false).val("Save");
            });
        }
        $clearForm = function () {
            $resetPanelItems();
            jQuery('#txtInvestigationSearch').removeAttr('disabled');
            jQuery('#txtCampName,#txtCampCoOrdinator,#txtCampContactNo,#txtCampAddress').val('');
            jQuery('#ddlPanel,#ddlCampType,#ddlCamp').prop('selectedIndex', 0);
            jQuery('#ddlPanel,#ddlCampType,#ddlCamp').chosen('destroy').chosen();
        }
        $clearItem = function () {
            jQuery("#txtInvestigationSearch").val('');
        }
        split = function (val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        function extractLast1(term) {
            return split(term).pop();
        }
        jQuery("#txtInvestigationSearch")
              .bind("keydown", function (event) {
                  if (event.keyCode === jQuery.ui.keyCode.TAB &&
                      jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  var length = jQuery('#ddlPanel > option').length;
                  if (length == 0 || jQuery('#ddlPanel').val() == "" || jQuery('#ddlPanel').val() == 0) {
                      toast("Error", "Please Select Camp Centre", "");
                      jQuery('#ddlPanel').focus();
                  }
                  jQuery("#theHidden").val('');
              })
            .autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=GetCampTestDetail", {
                        SearchType: jQuery('input:radio[name=labItems]:checked').val(),
                        TestName: extractLast1(request.term),
                        ReferenceCodeOPD: jQuery('#ddlPanel').val().split('#')[1],
                        Panel_Id: jQuery('#ddlPanel').val().split('#')[0],
                        Panel_IdMRP: jQuery('#ddlPanel').val().split('#')[3]
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
                    jQuery("#theHidden").val(ui.item.id);
                    this.value = '';
                    AddItem(ui.item.value, ui.item.type, ui.item.Rate.split('#')[0], ui.item.MRP.split('#')[0]);
                    return false;
                },
            });
        var InvList = [];
        function deleteItemNode(row) {
            var $tr = jQuery(row).closest('tr');
            var RmvInv = $tr.find('.inv').attr("id").split(',');
            var len = RmvInv.length;
            InvList.splice(jQuery.inArray(RmvInv[0], InvList), len);
            row.closest('tr').remove();
            jQuery('#lblTotalLabItemsCount').text(jQuery('#tb_ItemList tr:not(#LabHeader)').length);

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
        function AddItem(ItemID, type, Rate, MRP) {
            if (ItemID == '') {
                toast("Error", "Please Select Test", "");
                return false;
            }
            serverCall('../Lab/Services/LabBooking.asmx/GetRequestedCamp', { ItemID: ItemID, type: type }, function (response) {
                $responseData = JSON.parse(response);
                var inv = $responseData[0].Investigation_Id;
                for (var i = 0; i < (inv.split(',').length) ; i++) {
                    if (jQuery.inArray(inv.split(',')[i], InvList) != -1) {
                        toast("Error", "Item Already Added", "");
                        return;
                    }
                }
                for (var i = 0; i < (inv.split(',').length) ; i++) {
                    InvList.push(inv.split(',')[i]);
                }
                var $mydata = [];
                $mydata.push(" <tr id='");
                $mydata.push($responseData[0].ItemID); $mydata.push("'");
                $mydata.push(" class='GridViewItemStyle'>");
                $mydata.push("<td class='inv' id='"); $mydata.push($responseData[0].Investigation_Id); $mydata.push("'>");
                $mydata.push("<a href='javascript:void(0);' onclick='deleteItemNode($(this));'><img src='../../App_Images/Delete.gif'/></a></td>");
                $mydata.push("<td id='tdTestCode' style='font-weight:bold;'>"); $mydata.push($responseData[0].testCode); $mydata.push("</td> ");
                $mydata.push(" <td id='tdItemName' style='font-weight:bold;'>"); $mydata.push($responseData[0].typeName); $mydata.push("</td> ");
                $mydata.push('<td id="tdRate"  style="text-align:right">'); $mydata.push(Rate); $mydata.push('</td>');
                $mydata.push('<td id="tdRequestedRate"  style="text-align:right">');
                $mydata.push('<input id="txtRequestedRate"  type="text" autocomplete="off" onlynumber="10" type="text" style="width:90px;" class="ItDoseTextinputNum requiredField" />');
                $mydata.push('</td>');
                $mydata.push("</tr>");
                $mydata = $mydata.join("");
                jQuery("#tb_ItemList tbody").prepend($mydata);
                jQuery('#tb_ItemList').show();
                jQuery('#lblTotalLabItemsCount').text(jQuery('#tb_ItemList tr:not(#LabHeader)').length);

            });
        }
    </script>
    <script type="text/javascript">
        function bindCampRequestDetail(campDetails) {
            var $CampDetail = jQuery.parseJSON(campDetails);
            jQuery('#btnSave,#btnClear').hide();
            jQuery('#btnApprove,#btnReject').show();
            jQuery('#ddlPanel').append(jQuery("<option></option>").val($CampDetail[0]).html($CampDetail[1]));
            jQuery('#ddlPanel').attr('disabled', 'disabled').chosen("destroy").chosen({ width: '100%' });
           
            jQuery('#ddlCampType').val($CampDetail[2]);
            jQuery('#ddlCampType').attr('disabled', 'disabled').chosen("destroy").chosen({ width: '100%' });
            jQuery('#ddlCamp').val($CampDetail[3]);
            jQuery('#ddlCamp').attr('disabled', 'disabled').chosen("destroy").chosen({ width: '100%' });
        }
        jQuery(function () {
            if (jQuery("#lblCampID").text() != "") {
                getCampDetail();
                jQuery('input:radio[name=rblsearchtype]').attr('disabled', 'disabled');
                jQuery('#ddlInvestigation').attr('disabled', 'disabled');
            }
        });
        getCampDetail = function () {
            serverCall('CampRequestMaster.aspx/GetCampItemDetails', { ID: jQuery("#lblCampID").text() }, function (result) {
                TestData = jQuery.parseJSON(result);
                if (TestData.length == 0) {
                    toast('Info', 'No Record Found', '');
                    return;
                }
                else {
                    var ItemID = [];
                    for (var k = 0; k < TestData.length ; k++) {
                        ItemID.push(TestData[k].ItemID);
                    }
                    serverCall('../Lab/Services/LabBooking.asmx/GetRequestedCamp', { ItemID: ItemID.join(','), type: "" }, function (response) {
                        $responseData = jQuery.parseJSON(response);
                        for (var k = 0; k < $responseData.length ; k++) {
                            var inv = $responseData[k].ItemID.toString();
                            for (var i = 0; i < (inv.split(',').length) ; i++) {
                                InvList.push(inv.split(',')[i]);
                            }
                            var inv = $responseData[k].Investigation_Id;
                            var $mydata = [];
                            $mydata.push(" <tr id='");
                            $mydata.push($responseData[k].ItemID); $mydata.push("'");
                            $mydata.push(" class='GridViewItemStyle'>");
                            $mydata.push("<td class='inv' id='"); $mydata.push($responseData[k].Investigation_Id); $mydata.push("'>");
                            $mydata.push("<a href='javascript:void(0);' onclick='deleteItemNode($(this));'><img src='../../App_Images/Delete.gif'/></a></td>");
                            $mydata.push("<td id='tdTestCode' style='font-weight:bold;'>"); $mydata.push($responseData[k].testCode); $mydata.push("</td> ");
                            $mydata.push("<td id='tdItemName' style='font-weight:bold;'>"); $mydata.push($responseData[k].typeName); $mydata.push("</td> ");
                            $mydata.push('<td id="tdRate" style="text-align:right">');
                            var Rate = 0;
                            var RequestedRate = 0;
                            for (var s = 0; s < TestData.length ; s++) {
                                if ($responseData[k].ItemID == TestData[s].ItemID) {
                                    RequestedRate = TestData[s].RequestedRate;
                                    Rate = TestData[s].Rate;
                                }
                            }
                            $mydata.push(Rate);
                            $mydata.push('</td>');
                            $mydata.push('<td id="tdRequestedRate" style="text-align:right">');
                            $mydata.push('<input id="txtRequestedRate"  type="text" autocomplete="off" onlynumber="10" type="text" style="width:90px;" class="ItDoseTextinputNum requiredField" ');
                            $mydata.push(" value='"); $mydata.push(RequestedRate); $mydata.push("'");
                            $mydata.push('/>');
                            $mydata.push('</td>');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery("#tb_ItemList tbody").append($mydata);
                            jQuery('#tb_ItemList').show();
                            jQuery('#lblTotalLabItemsCount').text(jQuery('#tb_ItemList tr:not(#LabHeader)').length);
                        }
                    });
                }
            });
        }
        $approveCampRequest = function () {
            if (!$validation()) {
                return;
            }
            var campData = campRequest();
            var campItemData = campItemDetail();
            if (campItemData.length == 0) {
                toast("Error", "Please Add Test Detail", "");
                jQuery('#txtInvestigationSearch').focus();
                return;
            }
            jQuery("#btnSave").attr('disabled', true).val("Submiting...");
            serverCall('CampRequestMaster.aspx/ApproveCampRequest', { CR: campData, CI: campItemData }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.Status) {
                    $clearForm();
                    jQuery('#txtStartDate').val($responseData.FromDate);
                    jQuery('#txtEndDate').val($responseData.ToDate);
                    jQuery('#btnApprove,#btnReject').hide();
                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                    if ($responseData.focusControl != null) {
                        jQuery('#' + $responseData.focusControl).focus();
                    }
                }
                jQuery('#btnSave').attr('disabled', false).val("Save");
            });
        }
        $rejectCampRequest = function () {
            $confirmationBox('<b>Do you want to Reject?');

        }
    </script>
    <script type="text/javascript">
        $confirmationBox = function (contentMsg) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            jQuery('#divRejectRemarks').showModel();
                            jQuery('#txtRejectReason').focus();
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        $campReject = function () {
            if (jQuery('#txtRejectReason').val() == "") {
                toast('Error','Please Enter Reject Reason');
                jQuery('#txtRejectReason').focus();
                return;
            }
            jQuery('#btnCampReject').attr('disabled', 'disabled').val("Submitting...");
            var campData = campRequest();
            serverCall('CampRequestMaster.aspx/RejectCampRequest', { CR: campData, RejectReason: jQuery('#txtRejectReason').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.Status) {
                    $clearForm();                   
                    toast("Success", $responseData.response, "");
                    jQuery('#divRejectRemarks').hideModel();
                }
                else {
                    toast("Error", $responseData.response, "");                    
                }
                jQuery('#btnCampReject').attr('disabled', false).val("Save");

            });
        }
        $clearAction = function (type) {

        }
        $otherCamp = function () {
            if (jQuery("#ddlCamp").val() == -1) {
                jQuery(".clOtherCampName").show();
            }
            else {
                jQuery(".clOtherCampName").hide();
                jQuery("#txtCampName").val('');
            }
        }
        $campTypeDetail = function () {
            if (jQuery("#ddlCampType").val() == 1) {
                jQuery("#txtInvestigationSearch").attr('disabled', 'disabled');
                serverCall('CampRequestMaster.aspx/FreeCampDetail', { Panel_ID: jQuery('#ddlPanel').val().split('#')[1] }, function (response) {
                    var $response = JSON.parse(response);
                    if ($response.Status) {

                        $responseData = jQuery.parseJSON($response.response);
                        for (var k = 0; k < $responseData.length ; k++) {
                            var inv = $responseData[k].ItemID.toString();
                            for (var i = 0; i < (inv.split(',').length) ; i++) {
                                InvList.push(inv.split(',')[i]);
                            }
                           
                            var $mydata = [];
                            $mydata.push(" <tr id='");
                            $mydata.push($responseData[k].ItemID); $mydata.push("'");
                            $mydata.push(" class='GridViewItemStyle'>");
                            $mydata.push("<td class='inv' id='"); $mydata.push($responseData[k].ItemID); $mydata.push("'>");
                            //$mydata.push("<a href='javascript:void(0);' onclick='deleteItemNode($(this));'><img src='../../App_Images/Delete.gif'/></a></td>");
                            $mydata.push("</td>");
                            $mydata.push("<td id='tdTestCode' style='font-weight:bold;'>"); $mydata.push($responseData[k].testCode); $mydata.push("</td> ");
                            $mydata.push("<td id='tdItemName' style='font-weight:bold;'>"); $mydata.push($responseData[k].typeName); $mydata.push("</td> ");
                            $mydata.push('<td id="tdRate" style="text-align:right">'); $mydata.push($responseData[k].Rate); $mydata.push("</td> ");                                                      
                            $mydata.push('<td id="tdRequestedRate" style="text-align:right">');
                            $mydata.push('<input id="txtRequestedRate"  type="text" autocomplete="off" disabled onlynumber="10" type="text" style="width:90px;" class="ItDoseTextinputNum requiredField" ');
                            $mydata.push(" value='"); $mydata.push(0); $mydata.push("'");
                            $mydata.push('/>');
                            $mydata.push('</td>');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery("#tb_ItemList tbody").append($mydata);
                            jQuery('#tb_ItemList').show();
                            
                        }
                        jQuery('#lblTotalLabItemsCount').text(jQuery('#tb_ItemList tr:not(#LabHeader)').length);
                    }
                });
            }
            else {
                $resetPanelItems();
                jQuery("#txtInvestigationSearch").removeAttr('disabled');
            }
        }
          </script>
</asp:Content>

