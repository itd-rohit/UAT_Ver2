<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="PrintReportFrontOffice.aspx.cs" Inherits="Design_FrontOffice_PrintReportFrontOffice" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <%: Scripts.Render("~/bundles/PostReportScript") %>
    <style>
        .DataFound {
            display: none;
        }    
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Dispatch Patient Report</b>
                    <asp:HiddenField ID="hdnLabNo" runat="server" Value="" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
<div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Lab No.</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtLabNo" />
                </div>             
                <div class="col-md-4">
                    <input type="button" value="Get Details" onclick="$getDetails();"  />
                </div>
                 <div class="col-md-3">
                    <label class="pull-left"><b>Dispatch To</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlDispatchTo" onchange="SetDispatchOption();" class="requiredField" >
                        <option value="0">--Dispatch To--</option>
                        <option value="1">Self</option>
                        <option value="2">Other</option>
                        <option value="3">Courier</option>
                    </select>
                </div>
            </div>
            <div class="row" id="divOther" style="display: none;">
                <div class="col-md-3">
                    <label class="pull-left"><b>Name </b></label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <input type="text" id="txtOtherName" maxlength="50" class="requiredField"/>
                </div>
                <div class="col-md-3">
                    </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Mobile No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtOtherMobile"  maxlength="10" class="requiredField" onlynumber="10" />
                </div>
            </div>
            <div class="row" id="divCourier" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left"><b>Courier Name </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtCourierName" maxlength="50" class="requiredField"/>
                </div>
                <div class="col-md-3">
                    </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Docket No. </b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtDocketNumber" maxlength="15" class="requiredField"/>
                </div>
            </div>
            <div class="row">
                <div class="col-md-10">
                </div>
                <div class="col-md-4">
                    <input type="checkbox" value="Print Header" id="chkHeader" /><strong>Print Header</strong>
                </div>
                <div class="col-md-2">
                    <input type="button" value="Print & Dispatch" onclick="$dispatch();" />
                </div>
                <div class="col-md-8"></div>
            </div>
        </div>    
    <div class="POuter_Box_Inventory DataFound" >
        <div class="Purchaseheader">Patient Detail</div>
        <div class="row">
            <div class="col-md-3" style="font-weight: bold">
                <label class="pull-left"><b>Patient Name </b></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8" style="font-weight: bold">
                <span id="spnPName"></span>
            </div>
            <div class="col-md-3" style="font-weight: bold">
                <label class="pull-left"><b>Lab No. </b></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8" style="font-weight: bold">
                <span id="spnLabNo"></span>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3" style="font-weight: bold">
                <label class="pull-left"><b>Age </b></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8" style="font-weight: bold">
                <span id="spnAge"></span>
            </div>
            <div class="col-md-3" style="font-weight: bold">
              <label class="pull-left"><b>Gender </b></label>
                <b class="pull-right">:</b>  
            </div>
            <div class="col-md-8" style="font-weight: bold">
                <span id="spnGender"></span>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3" style="font-weight: bold">
                <label class="pull-left"><b>Refer Doctor </b></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8" style="font-weight: bold">
                <span id="spnRDoctor"></span>
            </div>
            <div class="col-md-3" style="font-weight: bold">
                <label class="pull-left"><b>Client </b></label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8" style="font-weight: bold">

                <span id="spnPanel"></span>
            </div>
        </div>
    </div>    
    <div class="POuter_Box_Inventory  DataFound" style="text-align: center; max-height: 500px; overflow-x: auto;">
 <div class="row Purchaseheader">
     <div class="col-md-8">   <div >Test Detail</div></div>
 <div class="col-md-1 square badge-Dispatched" style="height: 20px;width:2%; float: left;">
                    </div>
                    <div class="col-md-2">
                        Dispatched
                    </div>                  
                        <div class="col-md-1 square badge-Approved" style="height: 20px;width:2%; float: left;">
                        </div>
                        <div class="col-md-3">
                            Pending

                        </div>
                    </div>
                    
        <table id="tblData" style="width:100%" class="GridViewStyle">
            <tr>
                <th class="GridViewHeaderStyle">S.No.</th>
                <th class="GridViewHeaderStyle">Department</th>
                <th class="GridViewHeaderStyle">Investigation</th>
                <th class="GridViewHeaderStyle">Status</th>
                <th class="GridViewHeaderStyle">DispatchBy</th>
                <th class="GridViewHeaderStyle">DispatchOn</th>
                <th class="GridViewHeaderStyle">
                    <input type="checkbox" id="chkAll" onchange="CheckAll();" /></th>
            </tr>
        </table>
    </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('#txtLabNo').focus();
            if ($('[id$=hdnLabNo]').val().trim() != '') {
                $('#txtLabNo').val($('[id$=hdnLabNo]').val().trim());
                $getDetails();
            }
        });
        $('#txtLabNo').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                $getDetails();
            }
        });

        function $getDetails() {
            $('#tblData tr').slice(1).remove();         
            if ($.trim( $('#txtLabNo').val()) == "") {
                toast("Info", "Please Enter Lab No.", "");
                $('#txtLabNo').focus();
                return;
            }
            serverCall('PrintReportFrontOffice.aspx/GetDetails', { LabNo: $('#txtLabNo').val().trim() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $responseData = $responseData.response;
                    if ($responseData.length > 0) {

                        $('.DataFound').show();
                        $('#spnLabNo').text($responseData[0].LabNo);
                        $('#spnPName').text($responseData[0].PName);
                        $('#spnAge').text($responseData[0].Age);
                        $('#spnGender').text($responseData[0].Gender);
                        $('#spnPanel').text($responseData[0].PanelName);
                        $('#spnRDoctor').text($responseData[0].DoctorName);

                        for (var i = 0; i < $responseData.length; i++) {
                            var $mydata = [];
                            var RowColor = ($responseData[i].Status == "Pending" || $responseData[i].Status == "Result Pending" || $responseData[i].Status == "Result Not Done") ? "#44A3AA" : "#90EE90";
                            $mydata.push('<tr style="background-color:'); $mydata.push(RowColor); $mydata.push('">');
                            $mydata.push('<td>');
                            $mydata.push((i + 1)); $mydata.push('</td>');
                            $mydata.push('<td style="text-align:left;">'); $mydata.push($responseData[i].Department); $mydata.push('</td>');
                            $mydata.push('<td style="text-align:left;">'); $mydata.push($responseData[i].InvestigationName); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].Status); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].DispatchBy); $mydata.push('</td>');
                            $mydata.push('<td>'); $mydata.push($responseData[i].DispatchedOn); $mydata.push('</td>');
                            $mydata.push('<td>');
                            if ($responseData[i].Approved == "1" && $responseData[i].DispatchBy.trim().length == 0) {
                                $mydata.push('<input type="checkbox" id="chkTest" checked="checked"/><input type="hidden" id="hdnId" value="');
                                $mydata.push($responseData[i].Test_Id); $mydata.push('">'); 
                            }
                            $mydata.push('</td></tr>');
                            $mydata = $mydata.join('');
                            jQuery('#tblData').append($mydata);
                        }
                    }
                    else {
                        $('.DataFound').hide();
                        toast("Info", "No Data Found", "");
                    }
                }
                else {
                    toast("Error", $responseData.response, "");
                }           
            });
        }
        function $dispatch() {          
            var IsValid = false;
            var DispatchTo = $('#ddlDispatchTo').val();
            if (DispatchTo == "0") {
                toast("Error", "Please Select Dispatch To", "");
                $('#ddlDispatchTo').focus();
                return;
            }
            else if (DispatchTo == "2") {
                if ($('#txtOtherName').val().trim() == "") {
                    toast("Error", "Please Enter Other Name", "");
                    $('#txtOtherName').focus();
                    return;
                }
                if ($('#txtOtherMobile').val().trim() == "") {
                    toast("Error", "Please Enter Other Mobile No.", "");
                    $('#txtOtherMobile').focus();
                    return;
                }
            
                if ($('#txtOtherMobile').val().trim().length <10) {
                    toast("Error", "Please Enter Valid Other Mobile No.", "");
                    $('#txtOtherMobile').focus();
                    return;
                }
            }
            else if (DispatchTo == "3") {
                if ($('#txtCourierName').val().trim() == "") {
                    toast("Error", "Please Enter Courier Name", "");
                    $('#txtCourierName').focus();
                    return;
                }
                if ($('#txtDocketNumber').val().trim() == "") {
                    toast("Error", "Please Enter Docket No.", "");
                    $('#txtDocketNumber').focus();
                    return;
                }
            }
            var Test_ID = [];
            $('#tblData').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {
                    if ($(this).is(':checked')) {
                        IsValid = true;
                        Test_ID.push($(this).next().val());
                    }
                }
            });
            if (!IsValid) {
                toast("Info", "Please Select any Investigation", "");
                return;
            }
            
            if (Test_ID.length > 0) {
                serverCall('PrintReportFrontOffice.aspx/dispatchSave', { TestId: Test_ID, DispatchTo: $('#ddlDispatchTo option:selected').text(), OtherName: $('#txtOtherName').val().trim(), OtherMobile: $('#txtOtherMobile').val().trim(), CourierName: $('#txtCourierName').val().trim(), DocketNumber: $('#txtDocketNumber').val().trim() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        var Header = $('[id$=chkHeader]').is(':checked') ? '1' : '0';

                        

                        var testData ="".concat( Test_ID.join(),","); 
                        window.open('../Lab/labreportnew.aspx?IsPrev=0&PHead=' + Header + '&testid=' + testData);
                        $getDetails();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                });
            }
        }

        function CheckAll() {
            $('#tblData').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {
                    if ($('#chkAll').is(':checked')) {
                        $(this).attr('checked', 'checked');
                    }
                    else {
                        $(this).removeAttr('checked');
                    }

                }
            });
        }

        function SetDispatchOption() {
            var DispatchTo = $('[id$=ddlDispatchTo]').val();
            if (DispatchTo == "0" || DispatchTo == "1") {
                $('#divOther').hide();
                $('#divCourier').hide();
            }
            else if (DispatchTo == "2") {
                $('#divOther').show();
                $('#divCourier').hide();
            }
            else if (DispatchTo == "3") {
                $('#divCourier').show();
                $('#divOther').hide();
            }
        }
    </script>
</asp:Content>
