<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="B2CAppSmsConfigure.aspx.cs" Inherits="Design_PROApp_B2CAppSmsConfigure" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top: -42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>B2C SMS Setting</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    <asp:Label ID="lblImageId" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    SMS Details 
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">SMS Type :   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <select id="ddlSmsType" style="width: 300px;">
                            <option value="New Booking">New Appointment</option>

                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">SMS Text :   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <asp:TextBox ID="txtSMStext" runat="server" Width="1100px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Mobile No :</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtMobile1" placeholder="MobileNo1" runat="server" onkeypress="return isNumber(event)"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtMobile2" placeholder="MobileNo2" runat="server" onkeypress="return isNumber(event)"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtMobile3" placeholder="MobileNo3" runat="server" onkeypress="return isNumber(event)"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <asp:CheckBox ID="chkActive" runat="server" />
                        IsActive
                             <asp:Label ID="lblid" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input id="btnsave" type="button" onclick="savedata()" class="savebutton" style="width: 120px" value="Save " />

                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Result</div>
                <div id="row" style="text-align: center">
                    <div class="col-md-24">
                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                            style="width: 99%; border-collapse: collapse;">
                            <tr id="Header" class="nodrop">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">S.No</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 110px;" align="left">SMS Type</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 500px;">SMS Template</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Mobile1</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Mobile2</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Mobile3</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Added Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Active</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Edit</th>
                            </tr>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="Outer_Box_Inventory" style="text-align: center;">
                <input type="hidden" id="hiddenId" value="0" />
            </div>
        </div>



        <script type="text/javascript">
            $(document).ready(function () {
                GetSMSData('');
            });
            function savedata() {
                if ($("#ddlSmsType").val() == "") {
                    TostError("Please Select SMS Type");
                    return;
                }
                if ($("#<%=txtSMStext.ClientID %>").val() == "") {
                    TostError("Please Enter SMS Template");
                    return;
                }
                var Mobile1 = $("#<%=txtMobile1.ClientID %>").val();
                var Mobile2 = $("#<%=txtMobile2.ClientID %>").val();
                var Mobile3 = $("#<%=txtMobile3.ClientID %>").val();

                $("#btnsave").attr('disabled', 'disabled').val("Processing..");
                var ar = new Array();
                var obj = new Object();
                obj.Id = $("#hiddenId").val();
                obj.SMSText = $("#<%=txtSMStext.ClientID %>").val();
            obj.SmsType = $("#ddlSmsType").val();
            obj.IsActive = $("#<%=chkActive.ClientID %>").prop('checked') ? 1 : 0;
            obj.Mobile1 = Mobile1;
            obj.Mobile2 = Mobile2;
            obj.Mobile3 = Mobile3;
            ar.push(obj);
            serverCall('B2CAppSmsConfigure.aspx/SaveData', { data: ar }, function (response) {
                if (response != "") {
                    if (response == 'Record saved Successfully!' || response == 'Record Update Successfully!') {
                        toast("Success", response, "");
                    }
                    else
                        toast("Error", response, "");
                    GetSMSData('');
                    $("#hiddenId").val(0);
                    $("#<%=txtSMStext.ClientID %>").val('');
                    $("#ddlSmsType").val('');
                    $("#ctl00_ContentPlaceHolder1_txtMobile1").val('');
                    $("#ctl00_ContentPlaceHolder1_txtMobile2").val('');
                    $("#ctl00_ContentPlaceHolder1_txtMobile3").val('');
                    $("#btnsave").removeAttr('disabled').val("Save");
                }
            });
        }
        function Editdata(id) {
            serverCall('B2CAppSmsConfigure.aspx/GetSMSData', { Id: id, Type: 0 }, function (response) {
                if (response != "") {
                    PatientData = jQuery.parseJSON(response);
                    $("#hiddenId").val(PatientData[0].ID);
                    $("#<%=txtSMStext.ClientID %>").val(PatientData[0].SMSTemplate);
                    $("#ddlSmsType").val(PatientData[0].SMS_Type);
                    if (PatientData[0].IsActive == "Yes")
                        $("#<%=chkActive.ClientID %>").prop("checked", true);
                    else
                        $("#<%=chkActive.ClientID %>").prop('checked', false);
                    $("#ctl00_ContentPlaceHolder1_txtMobile1").val(PatientData[0].Mobile1);
                    $("#ctl00_ContentPlaceHolder1_txtMobile2").val(PatientData[0].Mobile2);
                    $("#ctl00_ContentPlaceHolder1_txtMobile3").val(PatientData[0].Mobile3);
                    $("#btnsave").val("Update");
                }
            });

        };

        function GetSMSData(type) {
            var symbol = "";
            $("#PatientLabSearchOutputSMS").empty();
            serverCall('B2CAppSmsConfigure.aspx/GetSMSData', { Id: 0, Type: type }, function (response) {
                if (response != "") {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length == 0) {
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                    }
                    else {
                        if (response != "") {
                            var $responseData = JSON.parse(response);
                            if ($responseData != null) {
                                for (var i = 0; i < $responseData.length; i++) {
                                    var $appendText = [];
                                    $appendText.push('<tr class="GridViewItemStyle" id="'); $appendText.push($responseData[i].ID); $appendText.push('">');
                                    $appendText.push('<td> '); $appendText.push(i + 1); $appendText.push('</td>');
                                    $appendText.push('<td>'); $appendText.push($responseData[i].SMS_Type); $appendText.push('</td>');
                                    $appendText.push('<td  style="display:none;">'); $appendText.push($responseData[i].SMSTemplate); $appendText.push('</td>');
                                    $appendText.push('<td  style="display:none;">'); $appendText.push($responseData[i].Mobile1); $appendText.push('</td>');
                                    $appendText.push('<td  style="display:none;">'); $appendText.push($responseData[i].Mobile2); $appendText.push('</td>');
                                    $appendText.push('<td  style="display:none;">'); $appendText.push($responseData[i].Mobile3); $appendText.push('</td>');
                                    $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].Updatedate); $appendText.push('</td>');
                                    $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].IsActive); $appendText.push('</td>');
                                    $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/edit.png" style="cursor:pointer;" onclick="GetDataForEdit('); $appendText.push($responseData[i].ID); $appendText.push('); </td>');
                                    $appendText.push("</tr>");
                                    $appendText = $appendText.join("");
                                    jQuery('#tb_grdLabSearch tbody').append($appendText);
                                }
                                $("#tb_grdLabSearch").tableDnD
                                ({
                                    onDragClass: "GridViewDragItemStyle",
                                    onDragStart: function (table, row) {
                                    }
                                });
                            }
                        }

                    }
                }
            });

        };
        </script>
    </form>
</body>
</html>
