<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CalculateDocAccount.aspx.cs" Inherits="Design_DocAccount_CalculateDocAccount" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Calculate DocAccount Share </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right">
                        <b>From Date :&nbsp;</b>
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right">
                        <b>To Date :&nbsp;</b>
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <b>Centre :&nbsp;</b>
                    </td>
                    <td>
                        <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="330px" runat="server"></asp:ListBox>
                    </td>
                    <td style="text-align: right">
                        <b>Department :&nbsp;</b>
                    </td>
                    <td>
                        <asp:ListBox ID="lstDepartment" CssClass="multiselect" SelectionMode="Multiple" Width="330px" runat="server"></asp:ListBox>

                    </td>
                    <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <b>Doctor Status :&nbsp;</b>
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rblActive" runat="server" onclick="$bindDoctor()"
                            RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">In-Active</asp:ListItem>
                            <asp:ListItem Value="2">Both</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: right; ">
                        <b>Doctor :&nbsp;</b>
                    </td>
                    <td >
                        <asp:ListBox ID="lstDoctor" CssClass="multiselect" SelectionMode="Multiple" Width="330px" runat="server"></asp:ListBox>
                    </td>
                    <td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    </td>
                </tr>
                <tr>

                    <td style="text-align: right">
                        <b>Report Type :&nbsp;</b>
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="0" Enabled="true">Item Wise</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Patient Wise</asp:ListItem>
                            <asp:ListItem Value="2" Enabled="true">Doctor Wise</asp:ListItem>
                        </asp:RadioButtonList>

                    </td>
                    <td style="text-align: right">&nbsp;
                    </td>
                    <td style="text-align: right">
                        <asp:CheckBox ID="chkCredit" runat="server" Text="Include Credit" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Report" class="searchbutton" onclick="getReport()" />
        </div>
    </div>
    <script type="text/javascript">
        var $bindDoctor = function () {
            jQuery('#lstDoctor').empty();
            jQuery('#lstDoctor').multipleSelect("refresh");
            serverCall('CalculateDocAccount.aspx/bindDoctor', { Status: jQuery('#rblActive input[type=radio]:checked').val() }, function (response) {
                var $responseData = JSON.parse(response);
                for (i = 0; i < $responseData.length; i++) {
                    jQuery('#lstDoctor').append($("<option></option>").val($responseData[i].Doctor_ID).html($responseData[i].DoctorName));
                }
                jQuery('[id*=lstDoctor]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }
        jQuery(function () {
            jQuery('[id*=lstCentre],[id*=lstDepartment],[id*=lstDoctor]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $bindDoctor();
        });
        function getReport() {
            jQuery('#lblMsg').text('');
            var CentreID = $('#lstCentre').val();
            var DepartmentID = $('#lstDepartment').val();
            if (CentreID != "") {
                serverCall('CalculateDocAccount.aspx/getReport', { CentreID: $('#lstCentre').multipleSelect("getSelects").join(), fromDate: jQuery('#txtFromDate').val(), toDate: jQuery('#txtToDate').val(), DepartmentID: $('#lstDepartment').multipleSelect("getSelects").join(), DoctorID: $('#lstDoctor').multipleSelect("getSelects").join(), ReportType: jQuery('#rblReportType input[type=radio]:checked').val(), ChkCredit: jQuery('#chkCredit').is(':checked') ? 1 : 0 }, function (response) {
                    var $responseData = JSON.parse(response);
                    //if ($responseData == "1")
                    //    window.open('../common/ExportToExcel.aspx');
                    //else if ($responseData == "2")
                    //    jQuery('#lblMsg').text('No Record Found');
                    //else
                    //    jQuery('#lblMsg').text('Error....');
                   
                    PostQueryString($responseData, '../DocAccount/DocAccountReport.aspx');
                });
            }
            else {
                jQuery('#lblMsg').text('Please Select Centre');
            }
        }
    </script>
</asp:Content>

