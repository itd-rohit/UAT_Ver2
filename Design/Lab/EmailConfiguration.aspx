<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmailConfiguration.aspx.cs" Inherits="Design_Lab_EmailConfiguration" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<style type="text/css">
    .auto-style1 {
        font-size: 9pt;
        font-family: Verdana, Arial, sans-serif, sans-serif;
        width: 196px;
        height: 20px;
    }

    .auto-style2 {
        width: 256px;
        height: 20px;
    }

    .auto-style3 {
        width: 200px;
        height: 20px;
    }

    .auto-style4 {
        width: 268px;
        height: 20px;
    }
</style>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<script src="../../Scripts/jquery-3.1.1.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">


    <script type="text/javascript">

        $(document).ready(function () {
            BindData();
        });
        function BindData() {
            var CentreID = '<%=CentreID%>'; var Panel_ID = '<%=Panel_ID%>'; var Type = '<%=Type%>';
            ResetData();
            $.ajax({
                url: "EmailConfiguration.aspx/BindData",
                data: JSON.stringify({ CentreID: CentreID, Type: Type, Panel_ID: Panel_ID }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    AllData = $.parseJSON(result.d);
                    if (AllData.length > 0) {
                        $("#chkSampleRejection").prop('checked', (AllData[0].AllowSampleRejection == '1') ? true : false);
                        $('#<%=txtSampleRejectionTo.ClientID%>').val(AllData[0].SampleRejectionEmailTO);
                        $('#<%=txtSampleRejectionCC.ClientID%>').val(AllData[0].SampleRejectionEmailCC);
                        $('#<%=txtSampleRejectionBCC.ClientID%>').val(AllData[0].SampleRejectionEmailBCC);

                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                }
            });
        }
        function SaveData() {
            if (ValidateData() != false) {
                var EmailConfigurationData = new Object();
                EmailConfigurationData.CentreID = '<%=CentreID%>';
                EmailConfigurationData.AllowSampleRejection = ($('#chkSampleRejection').is(':checked') == true) ? "1" : "0";
                EmailConfigurationData.SampleRejectionEmailTO = $('#<%=txtSampleRejectionTo.ClientID%>').val();
                EmailConfigurationData.SampleRejectionEmailCC = $('#<%=txtSampleRejectionCC.ClientID%>').val();
                EmailConfigurationData.SampleRejectionEmailBCC = $('#<%=txtSampleRejectionBCC.ClientID%>').val();

                EmailConfigurationData.Panel_ID = '<%=Panel_ID%>';
                EmailConfigurationData.Type = '<%=Type%>';
                $.ajax({
                    url: "EmailConfiguration.aspx/SaveData",
                    data: JSON.stringify({ EmailConfigurationData: EmailConfigurationData }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d.split('#')[0] == '1') {
                            showmsg("Record Saved Successfully....!");
                            BindData();
                        }
                        else {
                            showerrormsg("Some Error Occur Please Try Again..!");
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
                    }
                });
            }
        }
        function validateEmail(email) {
            var emailReg = /^((\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)\s*[,]{0,1}\s*)+$/;
            return emailReg.test(email);
        }
        function validateMobile(MobileNo) {
            var pattern = /^\d{10}$/;
            return pattern.test(MobileNo);
        }
        function ValidateData() {
            if (validateEmail($('#<%=txtSampleRejectionTo.ClientID%>').val()) == false && $('#<%=txtSampleRejectionTo.ClientID%>').val() != "") {
                showmsg('Please Enter Valid Email ID');
                $('#<%=txtSampleRejectionTo.ClientID%>').focus();
                return false;
            }
            if (validateEmail($('#<%=txtSampleRejectionCC.ClientID%>').val()) == false && $('#<%=txtSampleRejectionCC.ClientID%>').val() != "") {
                showmsg('Please Enter Valid Email ID');
                $('#<%=txtSampleRejectionCC.ClientID%>').focus();
                return false;
            }
            if (validateEmail($('#<%=txtSampleRejectionBCC.ClientID%>').val()) == false && $('#<%=txtSampleRejectionBCC.ClientID%>').val() != "") {
                showmsg('Please Enter Valid Email ID');
                $('#<%=txtSampleRejectionBCC.ClientID%>').focus();
                return false;
            }

            return true;
        }


        function ResetData() {
            $("input:text").val("");
            $("input:checkbox").prop('checked', false);
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
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
            <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
        </div>
        <div id="Pbody_box_inventory" style="width: 980px;">
            <div class="POuter_Box_Inventory" style="width: 974px;">
                <div class="Purchaseheader">Email Configuration Sample Rejection</div>
            
                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-2 ">
                                <input type="checkbox" id="chkSampleRejection" />
                            </div>
                            <div class="col-md-16">
                                Allow Sample Rejection Email / SMS

                            </div>
                            <div class="col-md-6 ">
                                &nbsp;
                            </div>
                        </div>

                    </div>



                </div>

                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">To   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtSampleRejectionTo" runat="server" Width="560px" onkeyup="checkValidEmailID(this);"></asp:TextBox>

                            </div>
                            <div class="col-md-6 ">
                                &nbsp;
                            </div>
                        </div>

                    </div>



                </div>

                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">Cc   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtSampleRejectionCC" runat="server" Width="560px"></asp:TextBox>

                            </div>
                            <div class="col-md-6 ">
                                &nbsp;
                            </div>
                        </div>

                    </div>



                </div>


                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">Bcc   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtSampleRejectionBCC" runat="server" Width="560px"></asp:TextBox>

                            </div>
                            <div class="col-md-6 ">
                                &nbsp;
                            </div>
                        </div>

                    </div>



                </div>
                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-24 " style="text-align: center">
                                <input type="button" onclick="SaveData()" value="Save" />
                            </div>


                        </div>
                    </div>



                </div>



            </div>
        </div>

    </form>
</body>
</html>
