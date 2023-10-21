<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DeptWisePendingList.aspx.cs" Inherits="Design_Lab_DeptWisePendingList" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Technician Pending List</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="text-align: center; width: 100%;">
                <tr>
                    <td style="width: 20%; text-align: right">From Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        <asp:TextBox ID="txtFromTime" runat="server" Width="70px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                            ControlExtender="mee_txtFromTime"
                            ControlToValidate="txtFromTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator>
                    </td>
                    <td style="width: 20%; text-align: right">To Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        <asp:TextBox ID="txtToTime" runat="server" Width="70px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                            ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">Centre :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:DropDownList ID="ddlCentre" Width="235px" runat="server">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 20%; text-align: right">Department :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:ListBox ID="ddldept" CssClass="multiselect" SelectionMode="Multiple" Width="235px" runat="server" onchange="GetDepartmentItem();" ClientIDMode="Static"></asp:ListBox>



                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td style="width: 20%; text-align: right">Test Name :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:DropDownList ID="ddlItem" runat="server" class="ddlItem  chosen-select" onchange="Search()"
                            Width="228px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">&nbsp;</td>
                    <td style="text-align: left; width: 30%;">&nbsp;</td>
                </tr>
            </table>



        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">


            <input type="button" class="searchbutton" value="Get Report Excel" onclick="getReport('Excel');" />
            <input type="button" class="searchbutton" value="Get Report PDF" onclick="getReport('PDF');" />
        </div>

    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('[id*=ddldept]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            GetDepartmentItem();
        });
    </script>



    <script type="text/javascript">
        function GetDepartmentItem() {
            $modelBlockUI();
            $("#<%=ddlItem.ClientID %> option").remove();
            var ddlItem = $("#<%=ddlItem.ClientID %>");
            ddlItem.attr("disabled", true);
            var AccessDepartmentEmp = '<%=AccessDepartment%>';
            $.ajax({
                url: "DeptWisePendingList.aspx/GetDepartmentWiseItem",
                data: '{ SubCategoryID: "' + $('#ddldept').multipleSelect("getSelects").join() + '",AccessDepartmentEmp: "' + AccessDepartmentEmp + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData.length == 0) {
                        ddlItem.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        ddlItem.append($("<option></option>").val("All").html("All"));
                        for (i = 0; i < PatientData.length; i++) {
                            ddlItem.append($("<option></option>").val(PatientData[i].ItemID).html(PatientData[i].TypeName));
                        }
                    }
                    $modelUnBlockUI();
                    ddlItem.attr("disabled", false);
                    ddlItem.trigger('chosen:updated');
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    $("#btnSave").hide();
                    alert("Error ");
                    ddlItem.attr("disabled", false);
                }
            });



        }
        var ReportType = 'Excel';
        function getReport(ReportTypes) {
            ReportType = ReportTypes;
            var CentreID = $('#<%=ddlCentre.ClientID%>').val();
            if (CentreID == '') {
                alert('Please Select Centre');
                return;
            }
            var deptid = $('#ddldept').multipleSelect("getSelects").join();
            var centrename = $('#<%=ddlCentre.ClientID%> option:selected').text();
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var TimeFrom = $('#<%=txtFromTime.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            var TimeTo = $('#<%=txtToTime.ClientID%>').val();
            var AccessDepartmentEmpWise = '<%=AccessDepartment%>';
            var ItemID = $('#<%=ddlItem.ClientID%>').val();
            $.blockUI({
                css: {
                    border: 'none',
                    padding: '15px',
                    backgroundColor: '#4CAF50',
                    '-webkit-border-radius': '10px',
                    '-moz-border-radius': '10px',
                    color: '#fff',
                    fontWeight: 'bold',
                    fontSize: '16px',
                    fontfamily: 'initial'
                },
                message: 'Getting Pending  Report...........!'
            });
            PageMethods.getReport(dtFrom, dtTo, CentreID, deptid, centrename, TimeFrom, TimeTo, AccessDepartmentEmpWise, ItemID, ReportType, onSuccessReport, OnfailureReport);
        }
        function onSuccessReport(result) {
            $modelUnBlockUI();
            if (result == "1") {
                if (ReportType == 'Excel') {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    window.open('../common/CommonReport.aspx');
                }
            }
            else if (result == "0") {
                alert('Record Not Found....!');
            }
            ReportType = 'Excel';
        }
        function OnfailureReport() {
            ReportType = 'Excel';
            $modelUnBlockUI();
            alert('Error Occured....! Kindly Select Centre');
        }
    </script>

    <script type="text/javascript">
        function getReportpdf() {
            var CentreID = $('#<%=ddlCentre.ClientID%>').val();
            if (CentreID == '') {
                alert('Please Select Centre');
                return;
            }
            var deptid = $('#ddldept').multipleSelect("getSelects").join();
            var centrename = $('#<%=ddlCentre.ClientID%> option:selected').text();
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var TimeFrom = $('#<%=txtFromTime.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            var TimeTo = $('#<%=txtToTime.ClientID%>').val();
            $.blockUI({
                css: {
                    border: 'none',
                    padding: '15px',
                    backgroundColor: '#4CAF50',
                    '-webkit-border-radius': '10px',
                    '-moz-border-radius': '10px',
                    color: '#fff',
                    fontWeight: 'bold',
                    fontSize: '16px',
                    fontfamily: 'initial'
                },
                message: 'Getting Pending  Report...........!'
            });
            PageMethods.getReportpdf(dtFrom, dtTo, CentreID, deptid, centrename, TimeFrom, TimeTo, onSuccessReport1, OnfailureReport1);
        }
        function onSuccessReport1(result) {
            $modelUnBlockUI();
            if (result == "1") {
                window.open('../common/CommonReport.aspx');
            }
            else if (result == "0") {
                alert('Record Not Found....!');
            }
        }
        function OnfailureReport1() {
            $modelUnBlockUI();
            alert('Error Occured....! Kindly Select Centre');
        }
    </script>
</asp:Content>

