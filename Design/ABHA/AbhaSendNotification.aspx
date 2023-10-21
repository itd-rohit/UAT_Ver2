<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AbhaSendNotification.aspx.cs" Inherits="Design_ABHA_AbhaSendNotification" %>


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
            Patient SMS Notification
        </div>

        <div id="divFetchAuthMode" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Send Notification
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Mobile No</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtMobileNo" />
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
                <input type="button" id="btnSMS" value="Send SMS" onclick="SendSMSNotification()" />
            </div>

        </div>


        <div id="StartTime" class="POuter_Box_Inventory" style="display: none">
            <div style="text-align: center; font-size: 43px; font-weight: bold; color: green;">
                Please wait for <span id="time" style="color: red">05:00</span> minutes!
            </div>
        </div>


    </div>

    <script type="text/javascript">
        $(document).ready(function () {

            HideShowDiv(0);
        });
    </script>


    <script type="text/javascript">
        function SendSMSNotification() {
            var MobileNo = $("#txtMobileNo").val();

            var RequesterID = $("#txtRequesterId").val();

            if (String.isNullOrEmpty(MobileNo)) {
                modelAlert("Please Enter MobileNo.");
                return false;
            }
            if (String.isNullOrEmpty(RequesterID)) {
                modelAlert("Please Enter Requester ID. ");
                return false;
            }

            $('#btnFetchAuthMode').attr("disabled", true);
            serverCall('Service/ABHAM2Service.asmx/SendSMSNotification', { MobileNo: MobileNo, RequesterID: RequesterID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert("Requested Successfully.Please Wait for Responce.", function () {
                        StartSendSMSTimer(MobileNo, RequesterID, responseData.ReqID)
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

        function StartSendSMSTimer(MobileNo, RequesterID, ReqId) {
            var fiveMinutes = 60 * 5,
            display = $('#time');
            StartOnSendSMSTimer(fiveMinutes, display, MobileNo, RequesterID, ReqId);
            HideShowDiv(1);
        }

        function CloseTimers() {
            intervalId = clearInterval(intervalId);
        }

        function StartOnSendSMSTimer(duration, display, MobileNo, RequesterID, ReqId) {
            var timer = duration, minutes, seconds;
            intervalId = setInterval(function () {
                minutes = parseInt(timer / 60, 10)
                seconds = parseInt(timer % 60, 10);
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;
                display.text(minutes + ":" + seconds);
                GetOnSMSResponce(MobileNo, RequesterID, ReqId)
                if (--timer < 0) {
                    CloseTimers();
                    modelAlert("Time Out ! No Responce From ABDM. Try After Some Time", function () {

                    });
                }

            }, 1000);
        }

        function GetOnSMSResponce(MobileNo, RequesterID, ReqId) {
            serverCall('Service/ABHAM2Service.asmx/GetOnSMSResponce', { MobileNo: MobileNo, RequesterID: RequesterID, ReqId: ReqId }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {

                    if (responseData.IsOnAuthResponce) {
                       
                        CloseTimers();
                        modelAlert("ACKNOWLEDGED  Successfully.", function () {
                            HideShowDiv(0);
                            $("#txtRequesterId").val("");
                            $("#txtMobileNo").val("");
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
                CloseTimers();
                $("#StartTime").hide();
                $("#divFetchAuthMode").show();
            } else if (Typ == 1) {
                $("#StartTime").show();
                $("#divFetchAuthMode").hide();
            }

        }

    </script>


</asp:Content>
