<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientValidation.aspx.cs" Inherits="Design_ABHA_PatientValidation" %>


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
            Patient Validation
        </div>

        <div id="divFetchAuthMode" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Fetch Auth Mode
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">ABHA ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAbhaId" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Purpose</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlPurpose">
                        <option value="KYC_AND_LINK">KYC AND LINK</option>
                        <option value="KYC">KYC</option>
                        <option value="LINK">LINK</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Requester ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtRequesterId" />
                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" id="btnFetchAuthMode" value="FetchAuthMode" onclick="FetchAuthMode()" />
            </div>

        </div>


        <div id="StartTime" class="POuter_Box_Inventory" style="display: none">
            <div style="text-align: center; font-size: 43px; font-weight: bold; color: green;">
                Please wait for <span id="time" style="color: red">05:00</span> minutes!
            </div>
        </div>

        <div id="divInitSection" class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Init Section
                <label id="lblRequestId" style="display: none"></label>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">ABHA ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblAbhaID"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">purpose</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label id="lblPurpose"></label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Auth Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlAuthMode">
                    </select>
                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" id="btnInit" value="Next" onclick="InititateVerification()" />
            </div>

        </div>


        <div id="divConfirm" class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Confirm Section
              <label id="lblTransactionID" style="display: none"></label>
                <label id="lblAuthMethod" style="display: none"></label>
            </div>
            <div class="row" id="divOTPSection" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left">OTP</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtOTPConfirm" placeholder="Enter OTP" maxlength="6" />
                </div>
            </div>
            <div class="row" id="divDemographicSection" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left">Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtName" />
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Gender</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="radio" value="M" id="rdbMale" name="rdbGender" />
                    <label for="rdbMale">Male</label>
                    <input type="radio" value="F" id="rdbFemale" name="rdbGender" />
                    <label for="rdbFemale">Female</label>
                    <input type="radio" value="O" id="rdbOther" name="rdbGender" />
                    <label for="rdbOther">Other</label>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">DOB</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDob" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtDob" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>
                <div class="col-md-3" style="margin-top: 5px">
                    <label class="pull-left">Mobile</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="margin-top: 5px">
                    <input type="text" id="txtIdentifireMobile" class="required" />
                </div>



            </div>
            <div class="row" style="text-align: center">
                <input type="button" id="btnConfirm" value="Confirm" onclick="ConfirmVerification()" />
            </div>

        </div>
        <div id="divAddcarecontext" class="POuter_Box_Inventory" style="display: none">
            <label style="color: green; font-size: 20px">Patient Validated Successfully</label>
        </div>

        <div id="divSharedProfile" class="POuter_Box_Inventory">


            <div class="row ">
                <div class="col-md-24" style="text-align: center; font-weight: bolder">Latest Shared Profile Data</div>
                <div class="col-md-24" id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblSharedProfileData" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SN.</th>

                                <th class="GridViewHeaderStyle">Token No</th>
                                <th class="GridViewHeaderStyle">Name</th> 
                                <th class="GridViewHeaderStyle">Mobile</th>
                                <th class="GridViewHeaderStyle">HealthId Number</th> 
                                <th class="GridViewHeaderStyle">HealthId</th>
                                <th class="GridViewHeaderStyle">Gender</th>
                                <th class="GridViewHeaderStyle">DOB</th>
                                <th class="GridViewHeaderStyle">Entry Date</th>

                                <th class="GridViewHeaderStyle">Expiry Date</th>

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

            $("#txtOTPConfirm").keydown(function (e) {

                // Allow: backspace, delete, tab, escape, enter and .
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    // Allow: Ctrl+A, Command+A
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    // Allow: home, end, left, right, down, up
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    // let it happen, don't do anything
                    return;
                }
                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }

            });

            HideShowShareData(0);

        });
    </script>


    <script type="text/javascript">
        function FetchAuthMode() {
            var HealthId = $("#txtAbhaId").val();
            var Purpose = $("#ddlPurpose").val();
            var RequesterID = $("#txtRequesterId").val();

            if (String.isNullOrEmpty(HealthId)) {
                modelAlert("Please Enter ABHA Id");
                return false;
            }
            if (String.isNullOrEmpty(Purpose)) {
                modelAlert("Please Select Purpose. ");
                return false;
            }

            if (String.isNullOrEmpty(RequesterID)) {
                modelAlert("Please Enter Requester ID. ");
                return false;
            }
            HideShowShareData(1);
            $('#btnFetchAuthMode').attr("disabled", true);
            serverCall('Service/ABHAM2Service.asmx/FetchAuthMode', { HealthId: HealthId, Purpose: Purpose, RequesterID: RequesterID, Type: "HIP" }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Requested Successfully.Please Wait for Responce.", function () {
                        StartAuthFetchTimers(HealthId, RequesterID, responseData.ReqID)
                        $('#btnFetchAuthMode').attr("disabled", false);
                    })
                } else {
                    $('#btnFetchAuthMode').attr("disabled", false);
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.error.message)
                    } else {
                        modelAlert(responseData.response.error.message)

                    }
                }

            });
        }

        function StartAuthFetchTimers(HealthId, RequesterID, ReqId) {
            var fiveMinutes = 60 * 5,
            display = $('#time');
            startOnFetchAuthTimer(fiveMinutes, display, HealthId, RequesterID, ReqId);
            HideShowDiv(1);
        }

        function CloseTimers() {
            intervalId = clearInterval(intervalId);
        }

        function startOnFetchAuthTimer(duration, display, HealthId, RequesterID, ReqId) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10)
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                display.text(minutes + ":" + seconds);
                GetOnFetchResponce(HealthId, RequesterID, ReqId)
                if (--timer < 0) {
                    CloseTimers();
                    modelAlert("Time Out ! No Responce From ABDM. Try After Some Time", function () {

                    });
                }

            }, 1000);
        }

        function GetOnFetchResponce(HealthId, RequesterID, ReqId) {
            serverCall('Service/ABHAM2Service.asmx/GetOnFetchAuthModeResponce', { HealthId: HealthId, RequesterID: RequesterID, ReqId: ReqId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.IsOnAuthResponce) {
                        HideShowDiv(2);
                        CloseTimers();
                        $("#lblAbhaID").text(responseData.response[0].HealthId);
                        $("#lblPurpose").text(responseData.response[0].Purpose);

                        var AuthData = responseData.response[0].AuthMethod.split(",");

                        $("#ddlAuthMode").empty();
                        var FirstRow = $("<option>").val("").text("Select");
                        $("#ddlAuthMode").append(FirstRow);
                        var SecondRow = $("<option>").val("MOBILE_OTP").text("MOBILE_OTP");
                        $("#ddlAuthMode").append(SecondRow);
                        $.each(AuthData, function (i) {
                            // create the option
                            if (AuthData[i] != 'PASSWORD') {
                            var opt = $("<option>").val(AuthData[i]).text(AuthData[i]);
                            $("#ddlAuthMode").append(opt);
                            }
                        });

                    } else {
                        CloseTimers();
                        modelAlert(responseData.message, function () {
                            HideShowDiv(0);
                        });
                    }

                }
            });
        }



        function HideShowDiv(Typ) {
            if (Typ == 0) {
                $("#StartTime").hide();
                $("#divFetchAuthMode").show();
            } else if (Typ == 1) {
                $("#StartTime").show();
                $("#divFetchAuthMode").hide();
            } else if (Typ == 2) {
                $("#StartTime").hide();
                $("#divInitSection").show();
            }
            else if (Typ == 3) {
                $("#StartTime").show();
                $("#divInitSection").hide();
            }
            else if (Typ == 4) {
                $("#StartTime").hide();
                $("#divConfirm").show();

            }
            else if (Typ == 5) {
                $("#StartTime").show();
                $("#divConfirm").hide();

            } else if (Typ == 6) {
                $("#StartTime").hide();
                $("#divAddcarecontext").show();
                HideShowShareData(0);

            } else if (Typ == 7) {
                $("#StartTime").show();
                $("#divAddcarecontext").hide();
                HideShowShareData(1);

            }


        }

    </script>

    <script type="text/javascript">

        function InititateVerification() {

            var HealthId = $("#txtAbhaId").val();
            var Purpose = $("#ddlPurpose").val();
            var RequesterID = $("#txtRequesterId").val();
            var AuthMode = $("#ddlAuthMode").val();
            if (String.isNullOrEmpty(HealthId)) {
                modelAlert("ABHA Id Not Found.");
                return false;
            }
            if (String.isNullOrEmpty(Purpose)) {
                modelAlert("Purpose not define.Try Again after some time. ");
                return false;
            }

            if (String.isNullOrEmpty(RequesterID)) {
                modelAlert("Requester not found. ");
                return false;
            }

            if (String.isNullOrEmpty(AuthMode)) {
                modelAlert("Please Select Auth Mode. ");
                return false;
            }
            $('#btnInit').attr("disabled", true);
            serverCall('Service/ABHAM2Service.asmx/HIPInitiation', { HealthId: HealthId, Purpose: Purpose, RequesterID: RequesterID, Type: "HIP", AuthMode: AuthMode }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Requested Successfully.Please Wait for Responce.", function () {
                        StartInitTimers(HealthId, RequesterID, responseData.ReqID)
                        $('#btnInit').attr("disabled", false);
                    })
                } else {
                    $('#btnInit').attr("disabled", false);
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.error.message)
                    } else {
                        modelAlert(responseData.response.error.message)

                    }
                }

            });

        }

        function StartInitTimers(HealthId, RequesterID, ReqId) {
            var fiveMinutes = 60 * 5,
            display = $('#time');
            InitTimer(fiveMinutes, display, HealthId, RequesterID, ReqId);
            HideShowDiv(3);
        }
        function InitTimer(duration, display, HealthId, RequesterID, ReqId) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10)
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                display.text(minutes + ":" + seconds);
                GetOnInitResponce(HealthId, RequesterID, ReqId)
                if (--timer < 0) {
                    CloseTimers();
                    modelAlert("Time Out ! No Responce From ABDM. Try After Some Time", function () {

                    });
                }

            }, 1000);
        }

        function GetOnInitResponce(HealthId, RequesterID, ReqId) {
            serverCall('Service/ABHAM2Service.asmx/GetOnInitResponce', { HealthId: HealthId, RequesterID: RequesterID, ReqId: ReqId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.IsOnAuthResponce) {
                        HideShowDiv(4);
                        CloseTimers();
                        $("#lblTransactionID").text(responseData.response[0].TransactionId);
                        $("#lblAuthMethod").text(responseData.response[0].AuthMode);
                        HideShwoConfirmByDiv(responseData.response[0].AuthMode)
                    } else {
                        CloseTimers();
                        modelAlert(responseData.message, function () {
                            HideShowDiv(2);
                        });
                    }

                }
            });
        }

        function HideShwoConfirmByDiv(Type) {

            if (Type == "DEMOGRAPHICS") {
                $("#divOTPSection").hide();
                $("#divDemographicSection").show();

            } else {
                $("#divOTPSection").show();
                $("#divDemographicSection").hide();
            }
        }

    </script>
    <script type="text/javascript">
        function ConfirmVerification() {
            var ConfirmOTP = $("#txtOTPConfirm").val();


            var Name = $("#txtName").val();
            var Gender = $("input[name='rdbGender']:checked").val();
            var DOB = $("#txtDob").val();
            var TransactionID = $("#lblTransactionID").text();
            var AuthMethod = $("#lblAuthMethod").text();
            var MobileNo = $("#txtIdentifireMobile").val();
            var HealthId = $("#txtAbhaId").val();

            if (String.isNullOrEmpty(TransactionID)) {
                modelAlert("Unable to connect ABDM ,Please refresh and try again.");
                return false;
            }

            if (AuthMethod == "DEMOGRAPHICS") {

                if (String.isNullOrEmpty(Name)) {
                    modelAlert("Please Enter Name.");
                    return false;
                }

                if (String.isNullOrEmpty(Gender) || Gender == undefined || Gender == "") {
                    modelAlert("Please Select Gender . ");
                    return false;
                }

                if (String.isNullOrEmpty(DOB)) {
                    modelAlert("Please Select Date Of Birth. ");
                    return false;
                }


                if (String.isNullOrEmpty(MobileNo)) {
                    modelAlert("Please Enter Mobile No.");
                    return false;
                }

            } else {

                if (String.isNullOrEmpty(ConfirmOTP)) {
                    modelAlert("Please Enter OTP. ");
                    return false;
                }
                Gender = "M";
            }

            $('#btnConfirm').attr("disabled", true);
            serverCall('Service/ABHAM2Service.asmx/HIPConfirmAuth', { TransactionId: TransactionID, AuthMethod: AuthMethod, HealthId: HealthId, OTP: ConfirmOTP, Name: Name, Gender: Gender, DOB: DOB, MobileNo: MobileNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Requested Successfully.Please Wait for Responce.", function () {
                        StartConfirmTimer(TransactionID, responseData.ReqID, HealthId)

                        $('#btnInit').attr("disabled", false);
                    })
                } else {
                    $('#btnConfirm').attr("disabled", false);
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.error.message)
                    } else {
                        modelAlert(responseData.response.error.message)

                    }
                }

            });

        }

        function StartConfirmTimer(TransactionID, RequestId, HealthId) {
            var fiveMinutes = 60 * 5,
           display = $('#time');
            ConfirmTimer(fiveMinutes, display, TransactionID, RequestId, HealthId);
            HideShowDiv(5);
        }

        function ConfirmTimer(duration, display, TransactionID, RequestId, HealthId) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10)
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                display.text(minutes + ":" + seconds);
                GetOnConfirmResponce(TransactionID, RequestId, HealthId)
                if (--timer < 0) {
                    CloseTimers();
                    modelAlert("Time Out ! No Responce From ABDM. Try After Some Time", function () {

                    });
                }

            }, 1000);
        }

        function GetOnConfirmResponce(TransactionID, RequestId, HealthId) {
            serverCall('Service/ABHAM2Service.asmx/GetOnConfirmResponce', { HealthId: HealthId, TransactionID: TransactionID, ReqId: RequestId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.IsOnAuthResponce) {
                        HideShowDiv(6);
                        CloseTimers();
                        $("#lblAccessToken").text(responseData.response[0].AccessToken);

                    } else {
                        CloseTimers();
                        modelAlert(responseData.message, function () {
                            HideShowDiv(4);
                        });
                    }

                }
            });
        }

    </script>


    <%--    Add Care context Section--%>

    <script type="text/javascript">

        function HIPAddCareContext() {

            var AccessToken = $("#lblAccessToken").text();

            var HealthId = $("#txtAbhaId").val();

            if (String.isNullOrEmpty(AccessToken)) {
                modelAlert("Unable to connect ABDM ,Please refresh and try again.");
                return false;
            }


            $('#btnAddCareContext').attr("disabled", true);
            serverCall('Service/ABHAM2Service.asmx/HIPAddCareContext', { HealthId: HealthId, AccessToken: AccessToken }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Requested Successfully.Please Wait for Responce.", function () {
                        HIPAddCareStartTimer(responseData.ReqID);
                        $('#btnAddCareContext').attr("disabled", false);
                    })
                } else {
                    $('#btnConfirm').attr("disabled", false);
                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.error.message)
                    } else {
                        modelAlert(responseData.response.error.message)

                    }
                }

            });

        }
        function HIPAddCareStartTimer(RequestId) {
            var fiveMinutes = 60 * 5,
           display = $('#time');
            StartAddCareContextTime(fiveMinutes, display, RequestId);
            HideShowDiv(7);
        }

        function StartAddCareContextTime(duration, display, RequestId) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10)
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                display.text(minutes + ":" + seconds);
                GetOnAddCareContext(RequestId)
                if (--timer < 0) {
                    CloseTimers();
                    modelAlert("Time Out ! No Responce From ABDM. Try After Some Time", function () {
                        window.location.reload();
                    });
                }

            }, 1000);
        }

        function GetOnAddCareContext(RequestId) {
            serverCall('Service/ABHAM2Service.asmx/GetOnAddCareContext', { ReqId: RequestId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.IsOnAuthResponce) {
                        CloseTimers();
                        modelAlert("Care Context Added successfully.", function () {
                            window.location.reload();
                        });

                    } else {
                        CloseTimers();
                        modelAlert(responseData.message, function () {
                            HideShowDiv(6);
                        });
                    }

                }
            });
        }



        function SearchSharedProfileData() {


            serverCall('Service/ABHAM2Service.asmx/SearchSharedProfileData', {}, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblSharedProfileData tbody').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.Id + '</td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblName">' + item.Name + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblMobile">' + item.Mobile + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle">' + item.HealthIdNumber + '</td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblHealthId">' + item.HealthId + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblGender">' + item.Gender + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblDOB">' + item.DOB + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable>' + item.EntryDate + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable>' + item.ExpiryDate + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle" style="display:none"> <lable id="lblXHIPID">' + item.XHIPID + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblAuthMode">' + item.AuthMode + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblPurpose">' + item.Purpose + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="Process" onclick="ProcessSharedData(this)"/></td>';

                        rdb += '</tr> ';

                        $('#tblSharedProfileData tbody').append(rdb);
                    });


                }

            });
        }


        function ProcessSharedData(rowid) {
            HideShowShareData(1);
            HideShowDiv(1);
            var AbhaID = $(rowid).closest('tr').find("#lblHealthId").text();
            var AuthMode = $(rowid).closest('tr').find("#lblAuthMode").text();
            var Purpose = $(rowid).closest('tr').find("#lblPurpose").text();
            var Requester = $(rowid).closest('tr').find("#lblXHIPID").text();

            var DOB = $(rowid).closest('tr').find("#lblDOB").text();
            var Name = $(rowid).closest('tr').find("#lblName").text();
            var Mobile = $(rowid).closest('tr').find("#lblMobile").text();
            var Gender = $(rowid).closest('tr').find("#lblGender").text();

            $("#txtName").val(Name).attr("disabled", true);
            $("input[name=rdbGender][value=" + Gender + "]").attr('checked', 'checked');
            $("input[name=rdbGender]").attr("disabled", true);
            $("#txtDob").val(DOB).attr("disabled", true);
            $("#txtIdentifireMobile").val(Mobile).attr("disabled", true);

            $("#txtAbhaId").val(AbhaID);
            $('#txtAbhaId').attr("disabled", true);
            $("#txtRequesterId").val(Requester).attr("disabled", true);

            HideShowDiv(2);
            $("#lblAbhaID").text(AbhaID);
            $("#lblPurpose").text(Purpose);

            $("#ddlAuthMode").empty();
            var SecondRow = $("<option>").val(AuthMode).text(AuthMode);
            $("#ddlAuthMode").append(SecondRow).attr("disabled", true);

        }


        function HideShowShareData(Typ) {
            if (Typ == 1) {
                $('#tblSharedProfileData').hide();
                $('#divSharedProfile').hide();
            } else {
                SearchSharedProfileData();
                $('#tblSharedProfileData').show();
                $('#divSharedProfile').show();
            }
        }
    </script>
</asp:Content>
