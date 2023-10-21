﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OnlinePayment.aspx.cs" Inherits="Design_PaymentGateWay_OnlinePayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
    <style>
        .savebutton {
            cursor: pointer;
            background-color: lightgreen;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .resetbutton {
            cursor: pointer;
            background-color: lightcoral;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .searchbutton {
            cursor: pointer;
            background-color: blue;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .PrintButton {
            cursor: pointer;
            background-color: #00FFFF;
            font-weight: bold;
            color: black;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }
    </style>
    <div id="Pbody_box_inventory" style="width: 95.6%;">
        <div class="Outer_Box_Inventory" style="width: 99.6%; text-align: center;">
            <div class="content" style="text-align: center;">
                Online Payment
                    <div id="frmError" runat="server">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ForColor="red"></asp:Label>
                    </div>
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%;">
            <div class="content" style="width: 99.6%; text-align: left!important;">
                <span style="color: red"><strong>Note:</strong>* mandatory fields.</span>
                <br />
            </div>
            <div class="content" style="width: 99.6%; text-align: center!important;">
                <table style="padding-left: 10%">
                    <tr style="padding-bottom: 50px">
                        <td style="text-align: right; padding-bottom: 10px">Panel<span style="color: red">*</span>: </td>
                        <td style="text-align: left; padding-bottom: 10px">
                            <asp:DropDownList ID="ddlpanel" runat="server" Width="207" OnSelectedIndexChanged="ddlpanel_SelectedIndexChanged" AutoPostBack="true">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" InitialValue="0" ErrorMessage="Select Panel" ControlToValidate="ddlpanel" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </td>
                        <td></td>
                        <td style="text-align: right; padding-bottom: 10px;display:none">LabNumber: </td>
                        <td style="text-align: left; padding-bottom: 10px;" colspan="2">
                            <asp:TextBox ID="LabNumber" runat="server" Width="200" Enabled="false" style="display:none" />
                            <span id="labnumbercheck" style="color: red"></span>
                            <asp:RequiredFieldValidator ID="RequiredFieldLabNumber" runat="server" Enabled="false" ErrorMessage="Please Enter Lab Number" ControlToValidate="LabNumber" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; padding-bottom: 10px">Amount<span style="color: red">*</span> : </td>
                        <td style="text-align: left; padding-bottom: 10px">
                            <asp:TextBox ID="amount" runat="server" Width="200" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please Enter Amount" ControlToValidate="amount" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        </td>
                        <td></td>
                        <td style="text-align: right; padding-bottom: 10px; width: 131px">Payment Remark<span style="color: red">*</span>: </td>
                        <td style="text-align: left; padding-bottom: 10px" colspan="2">
                            <asp:TextBox ID="Remark" runat="server" Width="200" /></td>
                    </tr>
                </table>
                <br />
                <asp:Button ID="submit" Text="submit" Width="100px" CssClass="savebutton" runat="server" OnClick="submit_Click1" />
                <input type="reset" value="Clear" style="width: 100px" class="resetbutton" onclick="clear();" />
                <br />
                <hr style="padding-left: -10%" />
				 <a href="ContactUs.aspx" target="_blank">Contact Us</a>
                &nbsp;&nbsp;&nbsp;
				 <a href="AboutUs.aspx" target="_blank">About Us</a>
                &nbsp;&nbsp;&nbsp;
                <a href="tnc.aspx" target="_blank">Terms of Use</a>
                &nbsp;&nbsp;&nbsp;
                    <a href="refundpolicy.aspx" target="_blank">Refund Policy</a>
                &nbsp;&nbsp;&nbsp;
                    <a href="Privacy.aspx" target="_blank">Privacy Policy</a>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function clear() {
            $('#<%=ddlpanel.ClientID%>').val('0');
          
        }
        function ValidateLabno() {
            $("#labnumbercheck").text('')
            $("#ctl00_ContentPlaceHolder1_RequiredFieldLabNumber").text("Please Enter Lab Number! ");
            $('#<%=submit.ClientID%>').attr('disabled', false);
            $.ajax({
                url: "OnlinePayment.aspx/ValidateLabnumber",
                type: "POST", // data has to be Posted    
                data: '{labnumber:"' + $('#<%=LabNumber.ClientID%>').val() + '"}',
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "Json",
                success: function (result) {
                    if (result == "0") {
                        $("#ctl00_ContentPlaceHolder1_RequiredFieldLabNumber").text("Lab Number Not Exist! ");
                        $('#<%=submit.ClientID%>').attr('disabled', true);
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
        $(document).ready(function () {
            $("#ctl00_ContentPlaceHolder1_RequiredFieldLabNumber").text("Please Enter Lab Number! ");
            $('#<%=LabNumber.ClientID%>').keyup(function (event) {
                var length = $('#<%=LabNumber.ClientID%>').val();
                if (length.length > 6) {
                    ValidateLabno();
                }
            });
            $('#<%=amount.ClientID%>').keypress(function (event) {
                var $this = $(this);
                if ((event.which != 46 || $this.val().indexOf('.') != -1) &&
                   ((event.which < 48 || event.which > 57) &&
                   (event.which != 0 && event.which != 8))) {
                    event.preventDefault();
                }
                var text = $(this).val();
                if ((event.which == 46) && (text.indexOf('.') == -1)) {
                    setTimeout(function () {
                        if ($this.val().substring($this.val().indexOf('.')).length > 3) {
                            $this.val($this.val().substring(0, $this.val().indexOf('.') + 3));
                        }
                    }, 1);
                }

                if ((text.indexOf('.') != -1) &&
                    (text.substring(text.indexOf('.')).length > 2) &&
                    (event.which != 0 && event.which != 8) &&
                    ($(this)[0].selectionStart >= text.length - 2)) {
                    event.preventDefault();
                }
            });
        })
    </script>

</asp:Content>

