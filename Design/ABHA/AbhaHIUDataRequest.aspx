<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AbhaHIUDataRequest.aspx.cs" Inherits="Design_ABHA_AbhaHIUDataRequest" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%-- Add content controls here --%>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <style>
        .pull-left {
            float: left !important;
            font-weight: bold;
        }

        .lblText {
            float: left;
            color: blue;
            font-size: 15px;
        }
    </style>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; font-size: 20px;">
            Consent Request          
        </div>

        <div id="divValidateAbhaId" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search By ABHA Address
                <label id="lblIsValidate" style="display: none">0</label>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">ABHA Address</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAbhaId" />
                    <label id="lblAbhaID" style="display: none"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblName"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">ABHA Address No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblHealthIdNumber"></label>
                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" id="btnFetchAuthMode" value="Validate Abha-ID" onclick="SearchByHealthId()" />
            </div>

        </div>

        <div id="divConsentRequest" class="POuter_Box_Inventory" style="display: none">

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Purpose of request</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlPurposeRequest">
                        <option value="">Select</option>
                        <option value="CAREMGT">Care Management</option>
                        <option value="BTG">Break the Glass</option>
                        <option value="PUBHLTH">Public Health</option>
                        <option value="DSRCH">Disease Specific Healthcare Research</option>
                        <option value="PATRQT">Self Requested</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Health info from</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select from date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Health info to</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select to date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Consent Expiry</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtConsentExpiry" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select from date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalConsentExp" TargetControlID="txtConsentExpiry" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Health info type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkOPC" name="chkHelathInfo" value="OPConsultation" style="cursor: pointer;" />
                    <label for="chkOPC" style="cursor: pointer;">OP Consultation</label>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkDR" name="chkHelathInfo" value="DiagnosticReport" style="cursor: pointer;" />
                    <label for="chkDR" style="cursor: pointer;">Diagnostic Report</label>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkDS" name="chkHelathInfo" value="DischargeSummary" style="cursor: pointer;" />
                    <label for="chkDS" style="cursor: pointer;">Discharge Summary</label>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkPre" name="chkHelathInfo" value="Prescription" style="cursor: pointer;" />
                    <label for="chkPre" style="cursor: pointer;">Prescription</label>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkImu" name="chkHelathInfo" value="ImmunizationRecord" style="cursor: pointer;" />
                    <label for="chkImu" style="cursor: pointer;">Immunization Record</label>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chkHDR" name="chkHelathInfo" value="HealthDocumentRecord" style="cursor: pointer;" />
                    <label for="chkHDR" style="cursor: pointer;">Health Document Record</label>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="chWR" name="chkHelathInfo" value="WellnessRecord" style="cursor: pointer;" />
                    <label for="chkWR" style="cursor: pointer;">Wellness Record</label>
                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" id="btnReques" value="Request Consent" onclick="ConsentInitialization()" />
            </div>
        </div>

        <div id="StartTime" class="POuter_Box_Inventory" style="display: none">
            <div style="text-align: center; font-size: 43px; font-weight: bold; color: green;">
                Please wait for <span id="time" style="color: red">05:00</span> minutes!
            </div>

        </div>


        <div id="div1" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Consent
               
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">ABHA Address</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAbhaID" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtConFrom" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select from date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtConFrom" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtConTo" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select to date"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtConTo" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" id="btnSearchConsent" value="Search Consent" onclick="SearchConsent()" />
            </div>

        </div>



        <div class="POuter_Box_Inventory" style="text-align: center;">

            <div class="row ">
                <div class="col-md-24" style="text-align: center; font-weight: bolder">Latest News</div>
                <div class="col-md-24" id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblconsentdata" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SN.</th>

                                <th class="GridViewHeaderStyle">Name</th>

                                <th class="GridViewHeaderStyle">ABHA Address</th>
                                <th class="GridViewHeaderStyle">Request Status</th>

                                <th class="GridViewHeaderStyle">Consent Created On</th>

                                <th class="GridViewHeaderStyle">Consent Granted On</th>

                                <th class="GridViewHeaderStyle">Consent Expiry</th>

                                <th class="GridViewHeaderStyle">Fetch Artifect</th>

                                <th class="GridViewHeaderStyle">Request</th>

                                <th class="GridViewHeaderStyle" style="width: 50px;">View</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            SearchConsent();
        });
        function SearchConsent() {

            serverCall('Service/ABHAM3Services.asmx/GetDataToFill', { FromDate: $("#txtConFrom").val(), ToDate: $("#txtConTo").val(), HealthID: $("#txtAbhaID").val() }, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblconsentdata tbody').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.PatientName + '</td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblPatientID">' + item.PatientID + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblStatus">' + item.Status + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle"> <lable id="lblRequestedDate">' + item.RequestedDate + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblConGrantedDate">' + item.ConGrantedDate + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblPermissionDataEraseAt">' + item.PermissionDataEraseAt + '</lable></td>';

                        if (item.Status == "GRANTED") {
                           rdb += '<td class="GridViewItemStyle" ><input style="float:right" id="btnFetchArtefact" type="button" value="Fetch Artefact" onclick="FetchArtefact(this)"/></td>';
                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" id="btnRequestData" type="button" value="Request Data" onclick="RequestData(this)"/></td>';

                            rdb += '<td class="GridViewItemStyle" ><input style="float:right" id="btnViewData" type="button" value="View" onclick="ViewData(this)"/></td>';

                        } else {
                            rdb += '<td class="GridViewItemStyle" ></td>';
                            rdb += '<td class="GridViewItemStyle" ></td>';
                            rdb += '<td class="GridViewItemStyle" ></td>';
                        }

                        
                        rdb += '<td class="GridViewItemStyle" ></td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblCosentID">' + item.ConsentId + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblConsetnArtefactID">' + item.ConArtifectID + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblReqFromDate">' + item.PerFromDate + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblReqToDate">' + item.PerToDate + '</lable> </td>';

                        rdb += '</tr> ';

                        $('#tblconsentdata tbody').append(rdb);
                    });


                } else {
                    modelAlert(GetData.data);
                }

            });
        }


    </script>

    <script type="text/javascript">

        function SearchByHealthId() {
            var Abha = $("#txtAbhaId").val();

            if (String.isNullOrEmpty(Abha)) {
                modelAlert("Please Enter Valid Health ID.");
                return false;
            }

            $('#btnGetOtp').attr("disabled", true);
            serverCall('Service/ABHAM3Services.asmx/SearchByHealthId', { AbhaId: Abha }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    $("#lblName").text(responseData.response.name);
                    $("#lblHealthIdNumber").text(responseData.response.healthIdNumber);
                    $("#lblAbhaID").text(responseData.response.healthId);

                    if (responseData.response.status == "ACTIVE") {
                        $("#lblIsValidate").text(1);
                        $("#btnFetchAuthMode").hide();
                        $("#divConsentRequest").show();
                        $('#txtAbhaId').attr("disabled", true);
                    } else {
                        $("#btnFetchAuthMode").show();
                        $("#divConsentRequest").hide();
                        $('#txtAbhaId').attr("disabled", false);
                    }



                } else {
                    $("#btnFetchAuthMode").show();
                    $("#divConsentRequest").hide();
                    $('#txtAbhaId').attr("disabled", false);
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message, function () {
                            $("#lblIsValidate").text(0);
                            $("#lblName").text("");
                            $("#lblHealthIdNumber").text("");

                        })
                    } else {
                        modelAlert(responseData.response.message, function () {
                            $("#lblIsValidate").text(0);
                            $("#lblName").text("");
                            $("#lblHealthIdNumber").text("");
                        })

                    }

                    $('#btnFetchAuthMode').attr("disabled", false);
                }

            });
        }


        function ConsentInitialization() {
            var HealthID = $("#lblAbhaID").text();

            if (String.isNullOrEmpty(HealthID)) {
                modelAlert("Health Id not verified.");
                return false;
            }
            var PurposeVal = $("#ddlPurposeRequest").val();
            if (String.isNullOrEmpty(PurposeVal)) {
                modelAlert("Please Select Purpose");
                return false;
            }
            var PurposeText = $("#ddlPurposeRequest option:selected").text();;
            var FromDate = $("#txtFromDate").val();
            var ToDate = $("#txtToDate").val();
            var ConsentExpiry = $("#txtConsentExpiry").val();
            var PatientName = $("#lblName").text();

            var HiType = "";

            var count = 0;
            $("input:checkbox[name=chkHelathInfo]:checked").each(function () {
                if (count == 0) {
                    HiType = $(this).val();
                    count = count + 1;
                } else {

                    HiType = HiType + "," + $(this).val();
                    count = count + 1;
                }

            });

            if (String.isNullOrEmpty(HiType)) {
                modelAlert("Please Select Health info type.");
                return false;
            }


            $('#btnGetOtp').attr("disabled", true);
            serverCall('Service/ABHAM3Services.asmx/ConsentInitialization', { PurposeText: PurposeText, PurposeVal: PurposeVal, HealthID: HealthID, HiType: HiType, FromDate: FromDate, ToDate: ToDate, ConsentExpiry: ConsentExpiry, PatientName: PatientName }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("Requested Successfully.", function () {
                        document.location.reload();
                    });
                } else {
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnFetchAuthMode').attr("disabled", false);
                }

            });
        }



        function RequestData(rowID) {

            var ConsentID = $(rowID).closest('tr').find('#lblConsetnArtefactID').text();
            var FromDate = $(rowID).closest('tr').find('#lblReqFromDate').text();
            var ToDate = $(rowID).closest('tr').find('#lblReqToDate').text();

            if (String.isNullOrEmpty(ConsentID)) {
                modelAlert("Unable to request.");
                return false;
            }

            $(rowID).closest('tr').find('#btnRequestData').attr("disabled", true);

            serverCall('Service/ABHAM3Services.asmx/RequestData', { ConsentId: ConsentID, FromDate: FromDate, ToDate: ToDate }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("Requested Successfully.", function () {
                        document.location.reload();
                    });
                } else {
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }


                    $(rowID).closest('tr').find('#btnRequestData').attr("disabled", false);

                }

            });

        }



        function FetchArtefact(rowID) {

            var ConsentID = $(rowID).closest('tr').find('#lblConsetnArtefactID').text();

            if (String.isNullOrEmpty(ConsentID)) {
                modelAlert("Unable to fetch.");
                return false;
            }

            $(rowID).closest('tr').find('#btnFetchArtefact').attr("disabled", true);

            serverCall('Service/ABHAM3Services.asmx/FetchArtefact', { ConsentId: ConsentID }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("Data Requested Successfully.", function () {
                        document.location.reload();
                    });
                } else {
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                    $(rowID).closest('tr').find('#btnFetchArtefact').attr("disabled", false);

                }

            });

        }

        function ViewData(rowID) {

            var ConsentID = $(rowID).closest('tr').find('#lblConsetnArtefactID').text();

            if (String.isNullOrEmpty(ConsentID)) {
                modelAlert("Unable to fetch.");
                return false;
            } 

            window.open("../ABHA/ViewData.aspx?ConsentID=" + ConsentID + "", "_blank");
             

        }

    </script>
</asp:Content>
