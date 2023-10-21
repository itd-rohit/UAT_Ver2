<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="SetMonthwiseTarget.aspx.cs" Inherits="Design_Designation_SetMonthwiseTarget" MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
   <link href="../../App_Style/AppStyle.css" rel="stylesheet" />
       <script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="../../scripts/main.js"></script>
    <link href="../../styles/main.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
           // $(".expander").click();
            $(".target").attr("title", "Please Enter Your Target");
            $(".target").attr("maxlength", "10");
            $(".target").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 9 && charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            });
        });

        function SaveTarget() {
            $('[id^=txt]').removeClass('HighLight');
            jQuery('#<%=lblerrmsg.ClientID%>').text('');
            var TargetData = [];
            var Ids = $('[id^=txt]');
            $(Ids).each(function (e, i) {
                TargetData.push({
                    EmployeeID: this.id.split('_')[1],
                    ReportingEmployeeID: this.id.split('_')[2],
                    IsSelf: this.id.split('_')[3],
                    TargetValue: this.value,
                    IsFirst: this.id.split('_')[4]
                });
            });
            $("#chkTargetMonth input[type=checkbox]:checked").each(function (i,e) {
               // alert(e.value);
                var Month = Number(e.value);
                var Year = Number(jQuery('#<%=ddlYear.ClientID%>').val());
                var MonthId = 0;
                if (parseInt(Month) > 3 && parseInt(Month) <= 12) {
                    MonthId = parseInt(Month) - 3;
                    Year = Number(jQuery('#<%=ddlYear.ClientID%>').val());
                    }
                    else {
                        MonthId = parseInt(Month) + 9;
                        Year = Number(jQuery('#<%=ddlYear.ClientID%>').val()) + 1;
                    }

                jQuery.ajax({
                    url: "SetMonthwiseTarget.aspx/Save",
                    // data: "{Target:'" + JSON.stringify(TargetData) + "',Year:'" + jQuery('#<%=ddlYear.ClientID%>').val() + "',Month:'" + jQuery('#<%=ddlMonth.ClientID%>').val() + "', MonthTarget:'" + $.trim($('#lblMonthTarget').text().split(':')[1]) + "', FDetails:'" + $('#lblFDetail').text() + "',SetMonthId:'" + $('#lblFDetail').text().split('#')[4].toString() + "' }",
                        data: "{Target:'" + JSON.stringify(TargetData) + "',Year:'" + Year + "',Month:'" + Month + "', MonthTarget:'" + $.trim($('#lblMonthTarget').text().split(':')[1]) + "', FDetails:'" + $('#lblFDetail').text() + "',SetMonthId:'" + MonthId + "' }",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                jQuery('#<%=lblerrmsg.ClientID%>').text('Record Saved Successfully.');
                            }
                            else if (result.d == "2") {
                                jQuery('#<%=lblerrmsg.ClientID%>').text('Kindly Add Sales Members.');
                            }
                            else if (result.d == "3") {
                                jQuery('#<%=lblerrmsg.ClientID%>').text('Main head target should be greater than or equal to Month Target');
                            }
                            else {
                                jQuery('#<%=lblerrmsg.ClientID%>').text('Child target should not be less than Parent target.');
                                $('[id^=' + result.d + ']').addClass("HighLight");
                                $('#' + result.d).focus();
                            }
                        },
                        error: function (xhr, status) {
                            jQuery('#<%=lblerrmsg.ClientID%>').text('Error has occurred Record Not saved .');
                        }
                    });
            });
                }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sp1" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b><asp:Label ID="lblHeader" runat="server" Text="Set Monthwise Target"></asp:Label> </b>
                <br />
                <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>&nbsp;
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; font-weight: bold;">
                Target Year :&nbsp;<asp:DropDownList ID="ddlYear" runat="server" ClientIDMode="Static" Enabled="false">
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;Target Month :&nbsp;
                <asp:DropDownList ID="ddlMonth" runat="server" Enabled="false">
                    <asp:ListItem Selected="True" Value="Select">Select</asp:ListItem>
                    <asp:ListItem Value="01">January</asp:ListItem>
                    <asp:ListItem Value="02">February</asp:ListItem>
                    <asp:ListItem Value="03">March</asp:ListItem>
                    <asp:ListItem Value="04">April</asp:ListItem>
                    <asp:ListItem Value="05">May</asp:ListItem>
                    <asp:ListItem Value="06">June</asp:ListItem>
                    <asp:ListItem Value="07">July</asp:ListItem>
                    <asp:ListItem Value="08">August</asp:ListItem>
                    <asp:ListItem Value="09">September</asp:ListItem>
                    <asp:ListItem Value="10">October</asp:ListItem>
                    <asp:ListItem Value="11">November</asp:ListItem>
                    <asp:ListItem Value="12">December</asp:ListItem>
                </asp:DropDownList>
                &nbsp;&nbsp;&nbsp;<div style="display: none;">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;" runat="server" id="dvTarget" visible="false">
                <div class="POuter_Box_Inventory" style="font-size: 16px; width: 99%; margin-left: 5px; margin-right: 5px; text-align: left; font-family: 'Times New Roman';">
                    <asp:Label ID="lblMonthTarget" runat="server" Font-Bold="true"></asp:Label>
                    <br />
                    <asp:PlaceHolder ID="plEmployee" runat="server"></asp:PlaceHolder>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;" runat="server">
                <table>
                    <tr>
                        <td>Copy To :&nbsp; </td>
                        <td>
                            <asp:CheckBoxList ID="chkTargetMonth" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                <asp:ListItem Value="04">April</asp:ListItem>
                                <asp:ListItem Value="05">May</asp:ListItem>
                                <asp:ListItem Value="06">June</asp:ListItem>
                                <asp:ListItem Value="07">July</asp:ListItem>
                                <asp:ListItem Value="08">August</asp:ListItem>
                                <asp:ListItem Value="09">September</asp:ListItem>
                                <asp:ListItem Value="10">October</asp:ListItem>
                                <asp:ListItem Value="11">November</asp:ListItem>
                                <asp:ListItem Value="12">December</asp:ListItem>
                                <asp:ListItem Value="01">January</asp:ListItem>
                                <asp:ListItem Value="02">February</asp:ListItem>
                                <asp:ListItem Value="03">March</asp:ListItem>
                            </asp:CheckBoxList></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;" runat="server" id="divSave" visible="false">
                <input type="button" id="btnSave" value="Save" onclick="SaveTarget()" class="savebutton"  />
            </div>
            <div style="display: none;">
                <asp:Label ID="lblFDetail" runat="server" Font-Bold="true"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>

