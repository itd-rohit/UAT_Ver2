<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CouponMasterEdit.aspx.cs" Inherits="Design_Coupon_CouponMasterEdit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title></title>
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/toastrsample.css" />
    <script src="../../Scripts/jquery-3.1.1.min.js"></script>
    <script src="../../Scripts/Common.js"></script>
     <script src="../../Scripts/toastr.min.js"></script>
    <script src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
   </head>
<body>


    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>

        <div id="Pbody_box_inventory">

            <div class="POuter_Box_Inventory" style="text-align: center">

                <b>Coupon Master Edit</b>

            </div>

            <div class="POuter_Box_Inventory" id="makerdiv">

                <div class="Purchaseheader">
                </div>


                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Centre Search &nbsp; &nbsp; 
                    </div>
                    <asp:Label ID="lblcoupanid" Style="display: none;" runat="server"></asp:Label>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Business Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList ID="rl" runat="server" RepeatDirection="Horizontal" Style='float: left;' onchange="bindcenter1();">
                                <asp:ListItem Value="0" Selected="True">All</asp:ListItem>
                                <asp:ListItem Value="COCO">COCO</asp:ListItem>
                                <asp:ListItem Value="FOFO">FOFO</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Business Zone</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindcenter()"></asp:ListBox>

                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:ListBox ID="lstType" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindcenter()"></asp:ListBox>

                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Center</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:ListBox ID="lstCentreLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindcenterinner($(this).val().toString())"></asp:ListBox>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre/PUP</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstCentreLoadListinner" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>
                        <div class="col-md-2">
                            <input type="button" id="btnaddcenter" class="searchbutton" runat="server" value="Add" onclick="AddCentre()" />
                        </div>
                    </div>

                </div>
                <div class="POuter_Box_Inventory">
                    <div class="content">
                        <div class="Purchaseheader">
                            Coupon Detail
                        </div>

                        <div style="width: 99%; max-height: 375px; overflow: auto;">
                            <table id="tblcoupon" style="border-collapse: collapse; width: 60%; max-height: 200px; overflow: auto;">

                                <tr id="header">
                                    <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Coupan Applicable Centre/PUP</td>
                                    <td class="GridViewHeaderStyle" style="width: 120px;">Remove</td>

                                </tr>
                            </table>

                        </div>
                    </div>


                </div>


                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Coupon Entry &nbsp; &nbsp; 
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Coupon Name   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCouponName" runat="server" MaxLength='50' ReadOnly="true"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Coupon Type   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ListCouponType" runat="server"></select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Coupon Category    </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ListCouponCategory" runat="server">
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtentrydatefrom" runat="server" Width="169px" ReadOnly="true" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                        </div>
                        <div class="col-md-2"></div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtentrydateto" runat="server" Width="160px" ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2"></div>
                        <div class="col-md-5">
                            <asp:Label ID="lblFileName" runat="server" Style="display: none;"></asp:Label>
                            <span style="font-weight: bold; display: none;" id="spnAttachment"><a href="javascript:void(0)" onclick="showuploadbox()" class="hyFileName" style="color: blue;"><b>Upload Document</b> </a></span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Min Billing Amt.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtminbooking" Text="0" runat="server" MaxLength='50' Width="50" onkeyup="showme(this);"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <input type="radio" name="user_cat" value="1" checked="checked" onclick="showdiv();" id="r1" />
                            Total Bill
                        </div>
                        <div class="col-md-3">
                            <input type="radio" name="user_cat" value="2" onclick="hidediv(); " id="r2" />Testwise Bill
                        </div>
                    </div>

                    <div class="row trtotalbil" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">Discount Amount </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtdisamt" runat="server" Text="0" MaxLength='50' Width="50" onkeyup="showme(this);"></asp:TextBox>


                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Discount % </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtdisper" runat="server" Text="0" Width="50" MaxLength="3" onkeyup="showme(this);"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row trtestbill">
                        <div class="col-md-3">
                            <label class="pull-left">Department </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstdepartment" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindtest($(this).val())"></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Test </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lsttest" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnadd" class="searchbutton" value="Add" onclick="Addrow();" />
                        </div>
                    </div>
                    <div class="row" style="display: none">
                        <div class="col-md-3">
                            <input type="radio" name="issuefor" value="1" checked="checked" onclick="checkissue();" id="r11" />
                            All 

                        </div>
                        <div class="col-md-10">
                            <input type="radio" name="issuefor" value="2" onclick="checkissue();" id="r12" />
                            UHID 
                                <asp:TextBox ID="txtuhid" runat="server" MaxLength="15" onchange="searchpatientbyuhid();"></asp:TextBox>
                            <input type="radio" name="issuefor" value="3" onclick="checkissue();" id="r13" />
                            Mobile 
                                <asp:TextBox ID="txtmobile" runat="server" Width="92px" AutoCompleteType="Disabled" MaxLength="10" onkeyup="showlength()" onchange="searchpatientbymobile();" TabIndex="3"></asp:TextBox>
                            <span id="molen" style="font-weight: bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Multiple Coupon Apply in a Booking   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkmulticoupon" runat="server" Checked="true" onclick="selMultipleCoupon()" ClientIDMode="Static" />
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">for Multiple Patient   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkMultiplePatient" onclick="selMultiplePatient()" ClientIDMode="Static" runat="server" Checked="false" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">for One Time Patient   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:CheckBox ID="chkOneTimePatient" onclick="selOneTimePatient()" ClientIDMode="Static" runat="server" Checked="false" />
                        </div>

                    </div>
                     <div class="row">
                     <div class="col-md-7">
                        <label class="pull-left">One Coupon and One Mobile multiple billing   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1">
                        <asp:CheckBox ID="chkOneCouponOneMobile"  runat="server" Checked="false" onclick="setOneCouponOneMobile()"/>
                    </div>
                         </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">WEEKEND   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:CheckBox ID="chkWeekEnd" onclick="setWeekEnd()" ClientIDMode="Static" runat="server" Checked="false" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">HappyHours   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:CheckBox ID="chkHappyHours" onclick="setHappyHours()" ClientIDMode="Static" runat="server" Checked="false" />
                        </div>
                        <div class="col-md-10" id="tdWeekEndHappyHours" style="display: none">
                            <asp:CheckBoxList ID="chklDaysApplicable" RepeatDirection="Horizontal" RepeatLayout="Table" runat="server" ClientIDMode="Static">
                                <asp:ListItem Text="Sun" Value="Sun"></asp:ListItem>
                                <asp:ListItem Text="Mon" Value="Mon"></asp:ListItem>
                                <asp:ListItem Text="Tue" Value="Tue"></asp:ListItem>
                                <asp:ListItem Text="Wed" Value="Wed"></asp:ListItem>
                                <asp:ListItem Text="Thu" Value="Thu"></asp:ListItem>
                                <asp:ListItem Text="Fri" Value="Fri"></asp:ListItem>
                                <asp:ListItem Text="Sat" Value="Sat"></asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                        <asp:CheckBoxList ID="chkapplicable" runat="server" RepeatDirection="Horizontal" Font-Bold="true">
                            <asp:ListItem Value="1" Text="Work Order" Selected="True"> </asp:ListItem>
                            <asp:ListItem Value="2" Text="Website"></asp:ListItem>
                            <asp:ListItem Value="3" Text="PreBooking"></asp:ListItem>
                            <asp:ListItem Value="4" Text="HomeCollection"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>

                </div>
                <div class="POuter_Box_Inventory  trtestbill" style="display: none;">
                    <div class="Purchaseheader">
                        Add Test &nbsp; &nbsp; 
                    </div>

                    <div style="width: 100%;">
                        <table id="Testtable" style="border-collapse: collapse; width: 100%;">
                            <thead>
                                <tr id="tr1">
                                    <td id="ttestcode" class="GridViewHeaderStyle" style="width: 350px;">Test Code</td>
                                    <td id="ttestname" class="GridViewHeaderStyle" style="width: 350px;">Test Name</td>
                                    <td id="tdepartment" class="GridViewHeaderStyle" style="width: 350px;">Department</td>
                                    <td id="tddiscountper" class="GridViewHeaderStyle" style="width: 350px;">
                                        <input type="text" id="txtdiscperhead" placeholder="Disc % All" style="width: 80px" onkeyup="showme2(this)" name="t1" />
                                    </td>
                                    <td id="tddiscountamt" class="GridViewHeaderStyle" style="width: 350px;">
                                        <input type="text" id="txtdiscamthead" placeholder="Disc Amt All" style="width: 80px" onkeyup="showme2(this)" name="t2" /></td>
                                    <td id="taction" class="GridViewHeaderStyle" style="width: 150px;">Action</td>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>

                    <div id="paging" style="float: right; margin-right: 1px;">
                        <input id="Prevbut" type="button" style="width: 10px; text-align: center" value="<" />
                        Page:<input id="txt_CurrentPage" type="text" style="width: 20px;" value="1" readonly="readonly" />of
              <label id="Tpage" for="myalue"></label>
                        <%--<span id="Tpage">10</span>--%>
                        <input id="Nextbut" type="button" style="width: 10px; text-align: center" value=">" />
                    </div>

                </div>



                <div class="POuter_Box_Inventory" style="display: none;">
                    <div class="Purchaseheader">
                        Add Coupon Number: &nbsp; &nbsp; 
                    </div>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    <div>

                        <div class="content">

                            <table width="100%">
                                <tr>
                                    <td>
                                        <input type="text" id="txtlistcode" maxlength="50" style="width: 50%" />
                                        <label id="lblfile">Enter Coupon Number Seprated by Comma(,)</label></td>
                                    <td><a id="forfile" href="ExcelFormat/excelformat.xlsx">Download Format</a></td>
                                </tr>


                            </table>

                            <table>
                                <tr>
                                    <td>Select File: </td>
                                    <td>
                                        <cc1:AsyncFileUpload ID="file1" runat="server" />
                                    </td>
                                    <td>
                                        <asp:Button ID="btnupload" runat="server" Text="Upload" ClientIDMode="Static" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />
                                    </td>

                                </tr>
                            </table>
                            <div style="width: 1295px; max-height: 100px; overflow: auto;">

                                <table style="width: 100%; border-collapse: collapse; overflow: auto">
                                    <tr>

                                        <td>
                                            <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False"
                                                CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;">
                                                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                                <Columns>
                                                    <asp:BoundField DataField="coupon_code" HeaderText="coupon_code" ItemStyle-Width="150px">
                                                        <ItemStyle Width="150px"></ItemStyle>
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="content">
                        <input type="button" value="Update" class="searchbutton" onclick="UpdateCoupon();" id="btnsave" />
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(function () {
                jQuery("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#hideDetail,#btnSearch,#btnSave").hide();
                $('[id*=lstCentreLoadList],[id*=lstCentreLoadListinner],[id*=lstZone],[id*=lstState],[id*=lstdepartment],[id*=lsttest],[id*=lstType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });               
                bindZone();
                binddepartment();
                showdiv();
                if ('<%=Request.QueryString["CouponId"] %> ' != null) {
                    var coupanid = '<%=Request.QueryString["CouponId"].ToString()%>'
                    bindCentertable(coupanid);
                    bindcoupondetail(coupanid);
                }
            });
            function bindZone() {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                    BusinessZoneID = jQuery.parseJSON(response);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    $('[id*=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });             
            }
            $('#lstZone').on('change', function () {
                jQuery('#<%=lstState.ClientID%> option').remove();
                jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
                jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
                jQuery('#lstState').multipleSelect("refresh");
                jQuery('#lstCity').multipleSelect("refresh");
                jQuery('#lstCentreLoadList').multipleSelect("refresh");
                jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
                var BusinessZoneID = $(this).val().toString();
                bindBusinessZoneWiseState(BusinessZoneID);
            });
            function bindcenter1() {
                bindcenter();
            }
            function bindcenterinner(centreid) {
                var btype = $('#<%=rl.ClientID%> input:checked').val();
                jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
                jQuery('#lstCentreLoadListinner').multipleSelect("refresh");

                if (centreid != "") {
                    serverCall('coupon_master.aspx/bindCentreLoadinner', { centreid: centreid,btype:btype }, function (response) {
                        CentreLoadListData = jQuery.parseJSON(response);
                        jQuery('#lstCentreLoadListinner').html('');
                        var CenterData = '';
                        for (i = 0; i < CentreLoadListData.length; i++) {
                            CenterData += CentreLoadListData[i].CentreID + ',';
                            jQuery("#lstCentreLoadListinner").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                        }
                        CenterData = CenterData.substring(0, CenterData.length - 1);
                        jQuery('[id*=lstCentreLoadListinner]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    });   
                }
            }

            function bindcenter() {
                var btype = $('#<%=rl.ClientID%> input:checked').val();
                jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
                jQuery('#lstCentreLoadList').multipleSelect("refresh");
                jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
                jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
                var tagprocessinglab = "0";
                serverCall('coupon_master.aspx/bindCentreLoad', { Type1: jQuery('#<%=lstType.ClientID%>').val().toString(), btype: btype, StateID: jQuery('#<%=lstState.ClientID%>').val().toString(), ZoneId: jQuery('#<%=lstZone.ClientID%>').val().toString(), tagprocessinglab: tagprocessinglab }, function (response) {
                    CentreLoadListData = jQuery.parseJSON(response);
                    jQuery('#lstCentreLoadList').html('');
                    var CenterData = '';
                    for (i = 0; i < CentreLoadListData.length; i++) {
                        CenterData += CentreLoadListData[i].CentreID + ',';
                        jQuery("#lstCentreLoadList").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                    }
                    CenterData = CenterData.substring(0, CenterData.length - 1);
                    jQuery('[id*=lstCentreLoadList]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });                        
            }
            function bindBusinessZoneWiseState(BusinessZoneID) {
                if (BusinessZoneID != "") {
                    serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                        stateData = jQuery.parseJSON(response);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    });                   
                }
            }
            function bindtype() {
                serverCall('coupon_master.aspx/bindtypedb', { }, function (response) {
                    typedata = jQuery.parseJSON(response);
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        $('#lstType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].TEXT));
                    }
                    $('[id*=lstType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });         
         }
         function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID) {
             if (StateID != "") {
                 serverCall('coupon_master.aspx/bindCentreLoad', { BusinessZoneID: BusinessZoneID,StateID:StateID }, function (response) {
                     CentreLoadListData = jQuery.parseJSON(response);
                     for (i = 0; i < CentreLoadListData.length; i++) {
                         jQuery("#lstCentreLoadList").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                     }
                     jQuery('[id*=lstCentreLoadList]').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
                 });                 
             }
         }
         function binddepartment() {
             jQuery('#<%=lstdepartment.ClientID%> option').remove();
             jQuery('#lstdepartment').multipleSelect("refresh");
             serverCall('coupon_master.aspx/binddepartmenttype', {  }, function (response) {
                 typedata = jQuery.parseJSON(response);
                 for (var a = 0; a <= typedata.length - 1; a++) {
                     $('#lstdepartment').append($("<option></option>").val(typedata[a].subcategoryid).html(typedata[a].NAME));
                 }
                 $('[id*=lstdepartment]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
             });            
         }
            function bindcoupontype() {
                serverCall('coupon_master.aspx/bindcoupontypedb', {  }, function (response) {
                    typedata = jQuery.parseJSON(response);
                    $('#<%=ListCouponType.ClientID%>').html('');
                     $('#<%=ListCouponType.ClientID%>').append("<option value='0'>Select</option>");
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        $('#<%=ListCouponType.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].CoupanType));
                      }
                });           
            }
            function bindcoupontypenew() {
                serverCall('coupon_master.aspx/bindcoupontypedb', {}, function (response) {
                    typedata = jQuery.parseJSON(response);
                    $('#<%=ListCouponType.ClientID%>').html('');
                    $('#<%=ListCouponType.ClientID%>').append("<option value='0'>Select</option>");
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        if (a < typedata.length - 1)
                            $('#<%=ListCouponType.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].CoupanType));
                        else if (a <= typedata.length - 1)
                            $('#<%=ListCouponType.ClientID%>').append($("<option Selected></option>").val(typedata[a].ID).html(typedata[a].CoupanType));
                    }
                });             
      }
      function bindcouponcategory() {
          serverCall('coupon_master.aspx/bindcouponcategorydb', {}, function (response) {
              typedata = jQuery.parseJSON(response);
              $('#<%=ListCouponCategory.ClientID%>').html('');
              $('#<%=ListCouponCategory.ClientID%>').append("<option value='0'>Select</option>");
              for (var a = 0; a <= typedata.length - 1; a++) {
                  $('#<%=ListCouponCategory.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].CoupanCategory));
              }
          });         
        }
        function bindcouponcategorynew() {
            serverCall('coupon_master.aspx/bindcouponcategorydb', {}, function (response) {
                typedata = jQuery.parseJSON(response);
                $('#<%=ListCouponCategory.ClientID%>').html('');
                $('#<%=ListCouponCategory.ClientID%>').append("<option value='0'>Select</option>");
                for (var a = 0; a <= typedata.length - 1; a++) {
                    if (a < typedata.length - 1)
                        $('#<%=ListCouponCategory.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].CoupanCategory));
                    else if (a <= typedata.length - 1)
                        $('#<%=ListCouponCategory.ClientID%>').append($("<option Selected></option>").val(typedata[a].ID).html(typedata[a].CoupanCategory));
                }
            });            
    }
    function bindtest(v) {

        jQuery('#<%=lsttest.ClientID%> option').remove();
            jQuery('#lsttest').multipleSelect("refresh");
            var testvalue = v;
            var ftestvalue = testvalue[0].split('#');
            if (v != "") {
                serverCall('coupon_master.aspx/bindtest', { scid: ftestvalue[0] }, function (response) {
                    stateData = jQuery.parseJSON(response);
                    for (i = 0; i < stateData.length; i++) {
                        jQuery("#lsttest").append(jQuery("<option></option>").val(stateData[i].itemid).html(stateData[i].typename));
                    }
                    jQuery('[id*=lsttest]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
                
            }
        }
        </script>
        <script type="text/javascript">
            function showme(ctrl) {
                if ($(ctrl).val().indexOf(" ") != -1) {
                    $(ctrl).val($(ctrl).val().replace(' ', ''));
                }
                var nbr = $(ctrl).val();
                var decimalsQty = nbr.replace(/[^.]/g, "").length;
                if (parseInt(decimalsQty) > 1) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
                if ($(ctrl).val().length > 1) {
                    if (isNaN($(ctrl).val() / 1) == true) {
                        $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                    }
                }
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val('');
                    return;
                }
                else if ($(ctrl).val() < 0) {
                    $(ctrl).val('');
                    return;
                }
            }
            function showme1(ctrl) {
                if ($(ctrl).val().indexOf(" ") != -1) {
                    $(ctrl).val($(ctrl).val().replace(' ', ''));
                }
                var nbr = $(ctrl).val();
                var decimalsQty = nbr.replace(/[^.]/g, "").length;
                if (parseInt(decimalsQty) > 1) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
                if ($(ctrl).val().length > 1) {
                    if (isNaN($(ctrl).val() / 1) == true) {
                        $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                    }
                }
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val('');
                    return;
                }
                else if ($(ctrl).val() < 0) {
                    $(ctrl).val('');
                    return;
                }
                if ($(ctrl).attr('id') == "txtdiscper") {
                    $(ctrl).closest('tr').find('#txtdiscamt').val('');
                    if ($(ctrl).val() > 100) {
                        $(ctrl).val('100');
                    }
                }
                if ($(ctrl).attr('id') == "txtdiscamt") {
                    $(ctrl).closest('tr').find('#txtdiscper').val('');
                }
            }
            function showme2(ctrl) {
                if ($(ctrl).val().indexOf(" ") != -1) {
                    $(ctrl).val($(ctrl).val().replace(' ', ''));
                }
                var nbr = $(ctrl).val();
                var decimalsQty = nbr.replace(/[^.]/g, "").length;
                if (parseInt(decimalsQty) > 1) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
                if ($(ctrl).val().length > 1) {
                    if (isNaN($(ctrl).val() / 1) == true) {
                        $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                    }
                }
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val('');
                    return;
                }
                else if ($(ctrl).val() < 0) {
                    $(ctrl).val('');
                    return;
                }

                if ($(ctrl).attr('id') == "txtdiscperhead") {
                    $(ctrl).closest('tr').find('#txtdiscamthead').val('');
                    var name = "t2";
                    $('input[name="' + name + '"]').each(function () {
                        $(this).val('');
                    });
                    if ($(ctrl).val() > 100) {
                        $(ctrl).val('100');
                    }
                }
                if ($(ctrl).attr('id') == "txtdiscamthead") {
                    $(ctrl).closest('tr').find('#txtdiscperhead').val('');
                    var name = "t1";
                    $('input[name="' + name + '"]').each(function () {
                        $(this).val('');
                    });
                }
                var val = $(ctrl).val();
                var name = $(ctrl).attr("name");
                $('input[name="' + name + '"]').each(function () {
                    $(this).val(val);
                });
            }
            function precise_round(num, decimals) {
                return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
            }
            function hidediv() {
                $('.trtotalbil').hide();
                $('.trtestbill').show();
                binddepartment();
                jQuery('#<%=lsttest.ClientID%> option').remove();
                jQuery('#lsttest').multipleSelect("refresh");
                jQuery('#<%=lsttest.ClientID%>').multipleSelect("enable");
                jQuery('#<%=lstdepartment.ClientID%>').multipleSelect("enable");
            }
            function showdiv() {
                $('.trtotalbil').show();
                $('.trtestbill').hide();
                jQuery('#<%=lsttest.ClientID%>').multipleSelect("disable");
                jQuery('#<%=lstdepartment.ClientID%>').multipleSelect("disable");
            }

        </script>
        <script type="text/javascript">
            $(document).ready(function () {
                bindtype();
                $('#<%=txtdisamt.ClientID%>').bind('blur', function () {
                    if ($('#<%=txtdisper.ClientID%>').val() == "" || $('#<%=txtdisper.ClientID%>').val() != "0") {
                        $('#<%=txtdisper.ClientID%>').val("0");
                    }
                    if ($('#<%=txtdisamt.ClientID%>').val() == "") {
                        $('#<%=txtdisamt.ClientID%>').val("0");
                    }
                });
                $('#<%=txtdisper.ClientID%>').bind('blur', function () {
                    if ($('#<%=txtdisamt.ClientID%>').val() == "" || $('#<%=txtdisamt.ClientID%>').val() != "0") {
                        $('#<%=txtdisamt.ClientID%>').val("0");
                    }
                    if ($('#<%=txtdisper.ClientID%>').val() == "") {
                        $('#<%=txtdisper.ClientID%>').val("0");
                    }
                });
                $('#<%=txtentrydatefrom.ClientID%>').bind('blur', function () {
                    var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
                    var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
                    var eDate = new Date(EndDate);
                    var sDate = new Date(StartDate);
                    if (StartDate != '' && StartDate != '' && sDate > eDate) {
                        toast('Error',"Please ensure that the End Date is greater than or equal to the Start Date.");
                        return false;
                    }
                });
                $('#<%=txtentrydateto.ClientID%>').bind('blur', function () {
                    var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
                    var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
                    var eDate = new Date(EndDate);
                    var sDate = new Date(StartDate);
                    if (StartDate != '' && StartDate != '' && sDate > eDate) {
                        toast('Error',"Please ensure that the End Date is greater than or equal to the Start Date.");
                        return false;
                    }
                });

                $('#<%=txtdisper.ClientID%>').bind('blur', function () {
                    if ($('#<%=txtdisper.ClientID%>').val() > 100) {
                        toast('Error',"Please enter discount percent less than 100 ");
                        $('#<%=txtdisper.ClientID%>').focus();
                        return;
                    }
                });
                $('.form-control').bind('blur', function () {
                    $(this).parent().next('li').find('.form_helper_show').removeClass("form_helper_show").addClass('form_helper');
                });
                $('#Tpage').text("1");
                $('#Nextbut').click(function () {
                    Nextclick();
                });
                $('#Prevbut').click(function () {
                    Prevclick();
                });
                $('#<%=txtdisamt.ClientID%>').keyup(function (e) {
                    $('#<%=txtdisper.ClientID%>').val("0");
                });

                $('#<%=txtdisamt.ClientID%>').keydown(function (e) {
                    $('#<%=txtdisper.ClientID%>').val("0");
                });

                $('#<%=txtdisper%>').keyup(function (e) {
                    $('#<%=txtdisamt.ClientID%>').val("0");
                });
                $('#<%=txtdisper%>').keydown(function (e) {
                    $('#<%=txtdisamt.ClientID%>').val("0");
                });
            });
            function Nextclick() {
                var totalrecord = $('#Testtable tr').length - 1;
                var pagesize = 5;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                if (parseInt($("#txt_CurrentPage").val()) < totalpage)
                    $("#txt_CurrentPage").val(parseInt($("#txt_CurrentPage").val()) + 1);
                else if (parseInt($("#txt_CurrentPage").val()) == totalpage)
                    $("#txt_CurrentPage").val(totalpage);
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();
                }
            }
            function Prevclick() {
                var totalrecord = $('#Testtable tr').length - 1;
                var pagesize = 5;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                if (parseInt($("#txt_CurrentPage").val()) > 1)
                    $('#txt_CurrentPage').val(parseInt($('#txt_CurrentPage').val()) - 1);
                else if (parseInt($("#txt_CurrentPage").val()) == 1)
                    $('#txt_CurrentPage').val('1');
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();
                }
            }
        </script>
        <script type="text/javascript">
            function UpdateCoupon() {            
                if ($('#<%=txtCouponName.ClientID%>').val() == "") {
                    toast('Error',"Please Enter CouponName ");
                    $('#<%=txtCouponName.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ListCouponType.ClientID%> option:selected').val() == "0") {
                    toast('Error',"Please Select CouponType ");
                    $('#<%=ListCouponType.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ListCouponCategory.ClientID%> option:selected').val() == "0") {
                    toast('Error',"Please Select CouponCategory ");
                    $('#<%=ListCouponCategory.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtentrydatefrom.ClientID%>').val() == "") {
                    toast('Error',"Please Enter from date ");
                    $('#<%=txtentrydatefrom.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtentrydateto.ClientID%>').val() == "") {
                    toast('Error',"Please Enter to date ");
                    $('#<%=txtentrydateto.ClientID%>').focus();
                    return;
                }
                var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
                var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                if (StartDate != '' && EndDate != '' && sDate > eDate) {
                    toast('Error',"Please ensure that the End Date is greater than or equal to the Start Date.");
                    return false;
                }
                if ($('#<%=txtminbooking.ClientID%>').val() == "") {

                    $('#<%=txtminbooking.ClientID%>').val("0");

                }
                var UpdateCoupan = new Object();
                UpdateCoupan.coupanId = $('#<%=lblcoupanid.ClientID%>').text();
                UpdateCoupan.coupanName = $('#<%=txtCouponName.ClientID%>').val();
                UpdateCoupan.coupanTypeId = $('#<%=ListCouponType.ClientID %> option:selected').val();
                UpdateCoupan.coupanType = $('#<%=ListCouponType.ClientID %> option:selected').text();
                UpdateCoupan.coupanCategoryId = $('#<%=ListCouponCategory.ClientID %> option:selected').val();
                UpdateCoupan.coupanCategory = $('#<%=ListCouponCategory.ClientID %> option:selected').text();
                UpdateCoupan.validFrom = $('#<%=txtentrydatefrom.ClientID%>').val();
                UpdateCoupan.validTo = $('#<%=txtentrydateto.ClientID%>').val();
                UpdateCoupan.Center = "";
                $('#tblcoupon tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        if ($(this).closest("tr").find("#tdcentreid").text() != "" && typeof $(this).closest("tr").find("#tdcentreid").text() !== "undefined") {
                            UpdateCoupan.Center += $(this).closest("tr").find("#tdcentreid").text() + ",";
                        }
                    }
                });
                UpdateCoupan.MinBillAmount = $('#<%=txtminbooking.ClientID%>').val();
                var selectedValues = "";
                $("[id*=chkapplicable] input:checked").each(function () {
                    selectedValues += $(this).val() + ",";
                });
                UpdateCoupan.ApplicableFor = selectedValues;
                if ($("#chkmulticoupon").is(":checked")) {
                    UpdateCoupan.IsmultipleApply = 1;
                } else {
                    UpdateCoupan.IsmultipleApply = 0;
                }
                if ($("input[name='user_cat']:checked").val() == "1") {
                    if ($('#<%=txtdisamt.ClientID%>').val() == "") {
                        $('#<%=txtdisamt.ClientID%>').val('0');
                    }
                    if ($('#<%=txtdisper.ClientID%>').val() == "") {
                        $('#<%=txtdisper.ClientID%>').val('0');
                    }
                    if ($('#<%=txtdisamt.ClientID%>').val() == "0" && $('#<%=txtdisper.ClientID%>').val() == "0") {
                        toast('Error',"Please Enter discount or Discount %");
                        $('#<%=txtdisamt.ClientID%>').focus();
                        return;
                    }
                    if ($('#<%=txtdisamt.ClientID%>').val() == "0" && $('#<%=txtdisper.ClientID%>').val() == "") {
                        toast('Error',"Please Enter discount percent.");
                        $('#<%=txtdisamt.ClientID%>').focus();
                        return;
                    }
                    if ($('#<%=txtdisamt.ClientID%>').val() == "" && $('#<%=txtdisper.ClientID%>').val() == "0") {
                        toast('Error',"Please Enter discount amount.");
                        $('#<%=txtdisamt.ClientID%>').focus();
                        return;
                    }
                    UpdateCoupan.billtype = 1;
                    UpdateCoupan.discountpercent = $('#<%=txtdisper.ClientID%>').val();
                    UpdateCoupan.discountamount = $('#<%=txtdisamt.ClientID%>').val();
                }
                else {
                    UpdateCoupan.billtype = 2;
                    UpdateCoupan.discountpercent = "0";
                    UpdateCoupan.discountamount = "0";
                }
                var issuetype = "";
                if ($("input[name='issuefor']:checked").val() == "1")
                    issuetype = "ALL";
                else if ($("input[name='issuefor']:checked").val() == "2")
                    issuetype = "UHID";
                else
                    issuetype = "Mobile";
                UpdateCoupan.issuefor = issuetype;
                UpdateCoupan.UHID = $('#<%=txtuhid.ClientID%>').val();
                UpdateCoupan.Mobile = $('#<%=txtmobile.ClientID%>').val();
                var DaysApplicable = "";
                if ($("#chkWeekEnd").is(':checked') || $("#chkHappyHours").is(':checked')) {
                    $("#chklDaysApplicable input:checked").each(function () {
                        DaysApplicable += $(this).val() + ",";
                    });
                }
                UpdateCoupan.DaysApplicable = DaysApplicable;
                var Allitem = new Array();
                var nn = '0';
                if ($("input[name='user_cat']:checked").val() == "2") {
                    $('[id$=Testtable]').find('tr').each(function (index) {
                        if (index > 0) {
                            var objPLO = new Object();
                            objPLO.discountpercent = $("#Testtable").find("tr").eq(index).find('#txtdiscper').val() == "" ? 0 : $("#Testtable").find("tr").eq(index).find('#txtdiscper').val();
                            objPLO.discountamount = $("#Testtable").find("tr").eq(index).find('#txtdiscamt').val() == "" ? 0 : $("#Testtable").find("tr").eq(index).find('#txtdiscamt').val();
                            if (objPLO.discountpercent == 0 && objPLO.discountamount == 0) {
                                nn = '1';
                            }
                            objPLO.subcategoryids = $("#Testtable").find("tr").eq(index).find("td").eq(2)[0].attributes[0].nodeValue;
                            objPLO.items = $("#Testtable").find("tr").eq(index).find("td").eq(1)[0].attributes[0].nodeValue;
                            Allitem.push(objPLO);
                        }
                    });
                }
                if (nn == "1") {
                    toast('Error',"Please Enter discount amount or discount per in item table.");
                    return;
                }
                serverCall('CouponMasterEdit.aspx/UpdateData', { objupdate: UpdateCoupan, Allitem: Allitem }, function (response) {
                    toast('Success',response);
                });              
            }                     
            function closeFancyboxAndRedirectToUrl(url) {
                window.location = url;
            }
        </script>
        <script type="text/javascript">
            function bindCentertable(coupanid) {
                serverCall('CouponMasterEdit.aspx/BindCenterData', { coupanid: coupanid }, function (response) {
                    var ItemData = jQuery.parseJSON(response);
                    if (ItemData.length == 0) {
                        toast('Error', "No Coupon Found");
                        $('#tblcoupon tr').slice(1).remove();

                    }
                    else {
                        $('#tblcoupon tr').slice(1).remove();
                        for (var i = 0; i < ItemData.length; i++) {
                            var $Tr = [];
                            $Tr.push('<tr style="background-color:bisque;" id="tblBody" class='); $Tr.push(ItemData[i].centreid); $Tr.push("center"); $Tr.push('>');
                            $Tr.push('<td  id="tdcentreid" style="display:none;">'); $Tr.push(ItemData[i].centreid ); $Tr.push('</td>');
                            $Tr.push('<td id="serial_number" class="order" >'); $Tr.push((i + 1)); $Tr.push('</td>');
                            $Tr.push('<td  id="tdcentre" ">'); $Tr.push(ItemData[i].centre); $Tr.push('</td>');
                            $Tr.push('<td id="vdel"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="Deleterow(this);" /></td></tr>');
                            $Tr = $Tr.join("");
                            $('#tblcoupon').append($Tr);
                        }
                    }
                });              
            }
            function AddCentre() {

                $("#lstCentreLoadListinner option:selected").each(function () {
                    var $this = $(this);
                    if ($this.length) {
                        var classname = $this.val() + "center";
                        if ($('table#tblcoupon').find('.' + classname).length > 0) {
                            toast('Error',"Center Already Added");
                            return;
                        }
                        var count = $('#tblcoupon tr').length;
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:bisque;" id="tblBody" class='); $Tr.push($this.val()); $Tr.push("center"); $Tr.push('>');
                        $Tr.push('<td  id="tdcentreid" style="display:none;">'); $Tr.push($this.val()); $Tr.push('</td>');
                        $Tr.push('<td id="serial_number" class="order" >'); $Tr.push((count)); $Tr.push('</td>');
                        $Tr.push('<td  id="tdcentre" ">'); $Tr.push($this.text()); $Tr.push('</td>');
                        $Tr.push('<td id="vdel"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="Deleterow(this);" /></td></tr>');
                        $Tr = $Tr.join("");
                        $('#tblcoupon').append($Tr);
                    }
                });
          }
            function Deleterow(ctrl) {
                $(ctrl).closest('tr').remove();
            }
            function checkissue() {
                if ($("input[name='issuefor']:checked").val() == "2") {
                    $('#<%=txtuhid.ClientID%>').val("");
                    $('#<%=txtmobile.ClientID%>').val("");
                    $('#<%=txtuhid.ClientID%>').show();
                    $('#<%=txtmobile.ClientID%>').hide();
                    $('#molen').html('');
                }
                else if ($("input[name='issuefor']:checked").val() == "3") {
                    $('#molen').html('');
                    $('#<%=txtuhid.ClientID%>').val("");
                    $('#<%=txtmobile.ClientID%>').val("");
                    $('#<%=txtuhid.ClientID%>').hide();
                    $('#<%=txtmobile.ClientID%>').show();
                }
                else {
                    $('#molen').html('');
                    $('#<%=txtuhid.ClientID%>').val("");
                    $('#<%=txtmobile.ClientID%>').val("");
                    $('#<%=txtuhid.ClientID%>').hide();
                    $('#<%=txtmobile.ClientID%>').hide();
                }
        }
        function showlength() {
            if ($('#<%=txtmobile.ClientID%>').val() != "") {
                $('#molen').html($('#<%=txtmobile.ClientID%>').val().length);
            }
            else {
                $('#molen').html('');
            }
            if ($.trim($('#<%=txtmobile.ClientID%>').val()) == "123456789") {
                toast('Error',"Please Enter Valid Mobile No.");
                $('#<%=txtmobile.ClientID%>').val('');
                $('#molen').html('');
                return;
            }
            if ($.trim($('#<%=txtmobile.ClientID%>').val()).charAt(0) == "0") {
                toast('Error',"Please Enter Valid Mobile No.");
                $('#<%=txtmobile.ClientID%>').val('');
                $('#molen').html('');
                return;
            }
        }
        var callblurFunc = false;
        var rblSearchType = 0;
        $(function () {
            $("#<%= txtmobile.ClientID%>").on('blur', function () {
                if ($("#<%= txtmobile.ClientID%>").val().length == 10 && callblurFunc == false) {
                    searchpatientbymobile();
                }
            });

            $("#<%= txtmobile.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       searchpatientbymobile();
                   }
                   else if (key == 9) {
                       searchpatientbymobile();

                   }
               });


            $("#<%= txtuhid.ClientID%>").on('blur', function () {
                if ($("#<%= txtuhid.ClientID%>").val().length == 10 && callblurFunc == false) {
                    searchpatientbyuhid();
                }
            });

            $("#<%= txtuhid.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       searchpatientbyuhid();
                   }
                   else if (key == 9) {
                       searchpatientbyuhid();

                   }
               });
        });
            function searchpatientbymobile() {
                serverCall('coupon_master.aspx/BindOldPatient', { searchmobile: $("#<%= txtmobile.ClientID%>").val() }, function (response) {
                    OLDPatientData = response;
                    if (OLDPatientData == 0) {
                        toast('Error',"Mobile No. is not valid");
                        $("#<%= txtmobile.ClientID%>").val("");
                    }
                    else {
                        toast('Success',"mobile no. is valid");
                    }
                
                });
           
             }


            function searchpatientbyuhid() {
                serverCall('coupon_master.aspx/BindOldPatientuhid', { searchuhid: $("#<%= txtuhid.ClientID%>").val() }, function (response) {
                    OLDPatientData = response;
                    if (OLDPatientData == 0) {
                        toast('Error', "UHID No. is not valid");
                        $("#<%= txtuhid.ClientID%>").val("");
                         }
                         else {
                             toast('Success', "UHID no. is valid");
                         }
                });
                
         }



        </script>

        <script type="text/javascript">
            function bindcoupondetail(couponid) {
                serverCall('CouponMasterEdit.aspx/BindCouponDetail', { coupanid: couponid }, function (response) {
                    var ItemDataNew = jQuery.parseJSON(response);

                    if (ItemDataNew[0].type == "1") {
                        $('#r1').prop('checked', true);
                        $('#r2').prop('checked', false);
                        showdiv();
                        $('#txtdisamt').val(ItemDataNew[0].discountamount);
                        $('#txtdisper').val(ItemDataNew[0].discountpercentage);
                    }
                    else {
                        $('#r2').prop('checked', true);
                        $('#r1').prop('checked', false);
                        hidediv();

                        $('#Testtable tr').slice(1).remove();
                        for (var i = 0; i <= ItemDataNew.length - 1; i++) {
                            ExistItems.push(ItemDataNew[i].ItemId);
                            var html = "";
                            html += "<tr id=" + (i + 1) + " style='background-color:lemonchiffon;' class='GridViewItemStyle GridCommonTemp'>";
                            html += "<td>" + ItemDataNew[i].TestCode + "</td>";
                            html += "<td value=" + ItemDataNew[i].ItemId + ">" + ItemDataNew[i].TypeName + " <input type='hidden' id='hdnItemId' value='" + ItemDataNew[i].ItemId + "'></td>";
                            html += "<td value=" + ItemDataNew[i].SubCategoryId + ">" + ItemDataNew[i].department + "</td>";
                            html += "<td><input type='text' MaxLength='3' id='txtdiscper' style='width:80px'  onkeyup='showme1(this)' name='t1' value='" + ItemDataNew[i].DiscPer + "' /></td>";
                            html += "<td><input type='text' MaxLength='5' id='txtdiscamt' style='width:80px'  onkeyup='showme1(this)' name='t2' value='" + ItemDataNew[i].DiscAmount + "'  /></td>";
                            html += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deletetestr(" + (i + 1) + ")'></td>";
                            html += '</tr>';
                            $('#Testtable tbody').append(html);
                        }

                        count++;
                        var pagesize = 5;
                        var totalrecord = $('#Testtable tr').length - 1;
                        var totalpage = Math.ceil(totalrecord / pagesize);
                        $('#Tpage').text(totalpage);
                        $(".GridCommonTemp").hide();
                        var currPage = parseInt($("#txt_CurrentPage").val());
                        for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                            $("#Testtable").find("tr").eq(i).show();

                        }
                    }
                    if (ItemDataNew[0].issuetype == "ALL") {
                        $('#r11').prop('checked', true);
                        $('#r12').prop('checked', false);
                        $('#r13').prop('checked', false);
                        $('#txtuhid').val('');
                        $('#txtmobile').val('');
                    }
                    if (ItemDataNew[0].issuetype == "UHID") {
                        $('#r11').prop('checked', false);
                        $('#r12').prop('checked', true);
                        $('#r13').prop('checked', false);
                        $('#txtuhid').val(ItemDataNew[0].uhid);
                        $('#txtmobile').val('');
                    }
                    if (ItemDataNew[0].issuetype == "Mobile") {
                        $('#r11').prop('checked', false);
                        $('#r12').prop('checked', false);
                        $('#r13').prop('checked', true);
                        $('#txtuhid').val('');
                        $('#txtmobile').val(ItemDataNew[0].mobile);
                    }
                    checkissue();
                });              
            }
        </script>
        <script type="text/javascript">
            var ExistItems = new Array();
            function Addrow() {
                if ((JSON.stringify($('#lstdepartment').val()) == '[]')) {
                    toast('Error',"Please Select department ");
                    $('#lstZone').focus();
                    return;
                }
                if ((JSON.stringify($('#lsttest').val()) == '[]')) {
                    toast('Error',"Please Select test ");
                    $('#lstZone').focus();
                    return;
                }
                var dname = [], tname = [], tcode = [], itemid = [], did = [];
                var tests = $('#lsttest').val();

                var html = '';

                $('[id$=Testtable]').find('tr').each(function (index) {
                    if (index > 0) {
                        ExistItems.push($(this).find('#hdnItemId').val());
                    }
                });
                for (i = 0; i < tests.length; i++) {
                    if (ExistItems.indexOf(tests[i].split('#')[0]) == -1) {

                        html += "<tr id=" + (i + 1) + " style='background-color:lemonchiffon;' class='GridViewItemStyle GridCommonTemp'>";
                        html += "<td>" + tests[i].split('#')[2] + "</td>";
                        html += "<td value=" + tests[i].split('#')[0] + ">" + tests[i].split('#')[3] + " <input type='hidden' id='hdnItemId' value='" + tests[i].split('#')[0] + "'></td>";
                        html += "<td value=" + tests[i].split('#')[1] + ">" + tests[i].split('#')[4] + "</td>";
                        html += "<td><input type='text' MaxLength='3' id='txtdiscper' style='width:80px'  onkeyup='showme1(this)' name='t1' /></td>";
                        html += "<td><input type='text' MaxLength='5' id='txtdiscamt' style='width:80px'  onkeyup='showme1(this)' name='t2'  /></td>";
                        html += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deletetestr(" + (i + 1) + ")'></td>";
                        html += '</tr>';
                    }
                }
                $('#Testtable tbody').append(html);
                count++;
                var pagesize = 5;
                var totalrecord = $('#Testtable tr').length - 1;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();

                }
            }
            var count = 1;
            function deletetestr(v) {
                $('#' + v).remove();
                var pagesize = 5;
                var totalrecord = $('#Testtable tr').length - 1;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();
                }
            }
        </script>
        <script type="text/javascript">
            function selMultipleCoupon() {
                if ($("#chkmulticoupon").is(':checked')) {
                    $("#chkWeekEnd,#chkHappyHours").prop('checked', false);
                }
                else {

                }
                uncheckDays();
                $("#tdWeekEndHappyHours").hide();
            }
            setWeekEnd = function () {
                if ($("#chkWeekEnd").is(':checked')) {
                    $("#chkmulticoupon,#chkHappyHours").prop('checked', false);
                    $("#tdWeekEndHappyHours").show();
                }
                else {
                    $("#tdWeekEndHappyHours").hide();
                }
                uncheckDays();
            }
            setHappyHours = function () {
                if ($("#chkHappyHours").is(':checked')) {
                    $("#chkmulticoupon,#chkWeekEnd").prop('checked', false);
                    $("#tdWeekEndHappyHours").show();
                }
                else {
                    $("#tdWeekEndHappyHours").hide();
                }
                uncheckDays();
            }
            uncheckDays = function () {
                $("#chklDaysApplicable input[type=checkbox]").prop('checked', false);
            }
            showHappyHours = function () {
                if ($("#chkWeekEnd").is(':checked') || $("#chkHappyHours").is(':checked')) {
                    $("#tdWeekEndHappyHours").show();
                }
                else {
                    $("#tdWeekEndHappyHours").hide();
                }
                $("#chkmulticoupon,#chkMultiplePatient,#chkOneTimePatient,#chkWeekEnd,#chkHappyHours,#chkOneCouponOneMobile").attr('disabled', 'disabled');
            }
        </script>
    </form>
</body>
</html>
