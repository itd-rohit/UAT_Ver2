<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CallCenterReport.aspx.cs" Inherits="Design_CallCenter_CallCenterReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1300px">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1296px">
            <div class="content" style="text-align: center;">
                <b>&nbsp;Call Center Report</b>
            </div>
            <div class="Purchaseheader">
                Search Option
            </div>
            <div>
                <span>
                    <input type="radio" value="0" style="width: 18px; height: 18px;" name="report" onclick="SelectCategory();" checked="checked" /><strong style="font-size: 15px;">Summary Report</strong></span>
                <span>
                    <input type="radio" value="1" style="width: 18px; height: 18px;" name="report" onclick="SelectCategory();" /><strong style="font-size: 15px;">Detail Report</strong></span>
            </div>
            <div class="content">
                <asp:DropDownList ID="ddlSearchType" runat="server" Width="80px">
                    <asp:ListItem Value="" Selected="True">---select---</asp:ListItem>
                    <asp:ListItem Value="ccl.Call_By_ID">UHID</asp:ListItem>
                    <asp:ListItem Value="ccl.Name">Name</asp:ListItem>
                    <asp:ListItem Value="ccl.Mobile">Mobile</asp:ListItem>
                </asp:DropDownList>
                <asp:TextBox ID="txtSearchValue" runat="server" Width="150px"></asp:TextBox>
                <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />

                <asp:TextBox ID="txtToDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                <span style="font-weight: bold; margin-left: 10px;">Call By</span>
                <asp:DropDownList onchange="HideCentre();" ID="DropDownList1" runat="server" Width="80px">
                    <asp:ListItem Value="ALL" Selected="True">ALL</asp:ListItem>
                     <asp:ListItem Value="Patient">Patient</asp:ListItem>
                    <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                    <asp:ListItem Value="PUP">PUP</asp:ListItem>
                    <asp:ListItem Value="PCC">PCC</asp:ListItem>
                </asp:DropDownList>
                <span style="font-weight: bold; margin-left: 10px;">Reason Of Call</span>
                <select id="ResonOfCall" onchange="ShowCentre();">

                </select>
           <%--     <asp:DropDownList ID="ResonOfCall1" onchange="ShowCentre();" runat="server" Width="130px">
                    <asp:ListItem Value="" Selected="True">All</asp:ListItem>
                    <asp:ListItem Value="LabReport">Lab Report</asp:ListItem>
                    <asp:ListItem Value="HomeCollection">Home Collection</asp:ListItem>
                    <asp:ListItem Value="Estimate">Estimate</asp:ListItem>
                    <asp:ListItem Value="FeedBack">Feed Back</asp:ListItem>
                </asp:DropDownList>--%>
                <asp:ListBox Style="display: none;" ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
                <span style="display: none;">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchData();" /></span>
                <input id="btnExcel" type="button" value="Export To  Excel" class="searchbutton" style="background-color: green;" onclick="ExcelToExport();" />
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1296px; display: none;">
            <table width="99%">
                <thead>
                    <tr style="background-color: silver; height: 26px;">
                        <td>Mobile</td>
                        <td>Call By</td>
                        <td>Call By ID</td>
                        <td>ReasonOfCall</td>
                        <td>Call Attend</td>
                        <td>Remarks</td>
                    </tr>
                </thead>
                <tbody id="callreportId">
                </tbody>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            BindCentre();
            HideCentre();
            $('.ms-parent').css('display', 'none');
        });
        function HideCentre() {
            $('#ResonOfCall').html('');
            $('.ms-parent').css('display', 'none');
            var report = $('input[name=report]:checked').val();
            var callby = $('#ContentPlaceHolder1_DropDownList1').val();
            if (report == "1") {
                if (callby == "Patient") {
                    $('#ResonOfCall').append('<option value="HomeCollection">Home Collection</option>');
                    $('#ResonOfCall').append('<option value="FeedBack">Feed Back</option>');
                }
                if (callby == "Doctor" || callby == "PUP" || callby == "PCC") {

                    $('#ResonOfCall').append('<option value="FeedBack">Feed Back</option>');
                }
                if (callby == "ALL") {
                    $('#ResonOfCall').append('<option value="LabReport">Lab Report</option>');
                    $('#ResonOfCall').append('<option value="HomeCollection">Home Collection</option>');
                    $('#ResonOfCall').append('<option value="Estimate">Estimate</option>');
                    $('#ResonOfCall').append('<option value="FeedBack">Feed Back</option>');
                }
            }
            else {
                $('#ResonOfCall').append('<option value="LabReport">Lab Report</option>');
                $('#ResonOfCall').append('<option value="HomeCollection">Home Collection</option>');
                $('#ResonOfCall').append('<option value="Estimate">Estimate</option>');
                $('#ResonOfCall').append('<option value="FeedBack">Feed Back</option>');
            }
            ShowCentre();
        }
        function ShowCentre() {
            jQuery('#lstCentre option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            BindCentre();
            var CallReson = $('#ResonOfCall').val();
            var report = $('input[name=report]:checked').val();
            var callby = $('#ContentPlaceHolder1_DropDownList1').val();
            if (callby == "Patient") {
                if (CallReson == "HomeCollection" && report == "1") {
                    $('.ms-parent').css('display', 'block');
                }
                else {
                    $('.ms-parent').css('display', 'none');
                }
            }
            if (callby == "Doctor" || callby == "PUP" || callby == "PCC") {
                if (CallReson != "HomeCollection") {
                    if (report == "1") {
                        $('.ms-parent').css('display', 'block');
                    }
                    else {
                        $('.ms-parent').css('display', 'none');
                    }
                }
                else {
                    $('.ms-parent').css('display', 'none');
                }
            }

        }
        function BindCentre() {
            jQuery.ajax({
                url: "CallCenterReport.aspx/bindCentre",
                data: '{ }',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                    }
                    var c = '5';
                    //$('#lstCentre').multipleSelect("setSelects", $('#Centreid').val().split(','));
                    if ($('#Centreid').val() != "") {
                        $('#lstCentre').val($('#Centreid').val());
                    }
                    $("#lstCentre").trigger('chosen:updated');
                    $('[id*=lstCentre]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                    //jQuery("#ddlCentreAccess").attr("disabled", false);
                }

            });
        }
        function SelectCategory() {
            HideCentre();
            $('.ms-parent').css('display', 'none');
            jQuery('#lstCentre').multipleSelect("refresh");
            var report = $('input[name=report]:checked').val();
            var callby = $('#ContentPlaceHolder1_DropDownList1').val();
            if (callby != "ALL") {
                if (report == "0") {
                    $('.ms-parent').css('display', 'none');
                }
                else {
                    $('.ms-parent').css('display', 'block');
                }
            }

        }
        function SearchData() {
            var report = $('input[name=report]:checked').val();
            if (report == "0") {
                SearchSummaryData();
            }
            else {
                SearchDetailData();
            }
        }
        function ExcelToExport() {
            var report = $('input[name=report]:checked').val();
            if (report == "0") {
                ExcelToSummary();
            }
            else {
                ExcelDetailData();
            }
        }
        function SearchSummaryData() {
            $('#btnSearch').attr('disabled', true).val("Searching...");
            var request = { SelectedType: $('#ContentPlaceHolder1_ddlSearchType').val(), SearchValue: $('#ContentPlaceHolder1_txtSearchValue').val(), FromDate: $('#ContentPlaceHolder1_txtFormDate').val(), ToDate: $('#ContentPlaceHolder1_txtToDate').val(), CallBy: $('#ContentPlaceHolder1_DropDownList1').val(), ResonOfCall: $('#ResonOfCall').val() };
            $.ajax({
                type: "POST",
                url: "CallCenterReport.aspx/GetCallCenterReport",
                data: JSON.stringify(request),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    $('#btnSearch').attr('disabled', false).val("Search");
                    var ResultData = $.parseJSON(result.d);
                    if (ResultData.length > 0) {
                        $('#callreportId').html('');
                        for (var i = 0; i < ResultData.length; i++) {
                            $('#callreportId').append('<tr>' +
                                '<td>' + ResultData[i].Mobile + '</td>' +
                                '<td>' + ResultData[i].Call_By + '</td>' +
                                '<td>' + ResultData[i].Call_By_ID + '</td>' +
                                '<td>' + ResultData[i].ReasonOfCall + '</td>' +
                                '<td>' + ResultData[i].UserName + '</td>' +
                                '<td>' + ResultData[i].Remarks + '</td>' +
                                '</tr>');
                        }
                    }
                    else {
                        $('#callreportId').html('');
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function SearchDetailData() {
            $('#btnSearch').attr('disabled', true).val("Searching...");
            var request = { SelectedType: $('#ContentPlaceHolder1_ddlSearchType').val(), SearchValue: $('#ContentPlaceHolder1_txtSearchValue').val(), FromDate: $('#ContentPlaceHolder1_txtFormDate').val(), ToDate: $('#ContentPlaceHolder1_txtToDate').val(), CallBy: $('#ContentPlaceHolder1_DropDownList1').val(), ResonOfCall: $('#ResonOfCall').val(), CentreID: $('#lstCentre').val() };
            $.ajax({
                type: "POST",
                url: "CallCenterReport.aspx/GetCallCenterDetailReport",
                data: '{SelectedType: "' + $('#ContentPlaceHolder1_ddlSearchType').val() + '", SearchValue: "' + $('#ContentPlaceHolder1_txtSearchValue').val() + '", FromDate: "' + $('#ContentPlaceHolder1_txtFormDate').val() + '", ToDate: "' + $('#ContentPlaceHolder1_txtToDate').val() + '", CallBy: "' + $('#ContentPlaceHolder1_DropDownList1').val() + '", ResonOfCall: "' + $('#ResonOfCall').val() + '", CentreID: "' + $('#lstCentre').val() + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    $('#btnSearch').attr('disabled', false).val("Search");
                    var ResultData = $.parseJSON(result.d);
                    if (ResultData.length > 0) {
                        $('#callreportId').html('');
                        for (var i = 0; i < ResultData.length; i++) {
                            $('#callreportId').append('<tr>' +
                                '<td>' + ResultData[i].Mobile + '</td>' +
                                '<td>' + ResultData[i].Call_By + '</td>' +
                                '<td>' + ResultData[i].Call_By_ID + '</td>' +
                                '<td>' + ResultData[i].ReasonOfCall + '</td>' +
                                '<td>' + ResultData[i].UserName + '</td>' +
                                '<td>' + ResultData[i].Remarks + '</td>' +
                                '</tr>');
                        }
                    }
                    else {
                        $('#callreportId').html('');
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function ExcelDetailData() {
            $('#btnExcel').attr('disabled', true).val("Exporting...");
            $.ajax({
                type: "POST",
                url: "CallCenterReport.aspx/GetCallCenterDetailReport",
                data: '{SelectedType: "' + $('#ContentPlaceHolder1_ddlSearchType').val() + '", SearchValue: "' + $('#ContentPlaceHolder1_txtSearchValue').val() + '", FromDate: "' + $('#ContentPlaceHolder1_txtFormDate').val() + '", ToDate: "' + $('#ContentPlaceHolder1_txtToDate').val() + '", CallBy: "' + $('#ContentPlaceHolder1_DropDownList1').val() + '", ResonOfCall: "' + $('#ResonOfCall').val() + '", CentreID: "' + $('#lstCentre').val() + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    $('#btnExcel').attr('disabled', false).val("ExcelToExport");
                    if (result.d == "Excel") {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                    else {
                        showerrormsg("No record found");
                    }
                }

            });
        }
        function ExcelToSummary() {
            $('#btnExcel').attr('disabled', true).val("Exporting...");
            var request = { SelectedType: $('#ContentPlaceHolder1_ddlSearchType').val(), SearchValue: $('#ContentPlaceHolder1_txtSearchValue').val(), FromDate: $('#ContentPlaceHolder1_txtFormDate').val(), ToDate: $('#ContentPlaceHolder1_txtToDate').val(), CallBy: $('#ContentPlaceHolder1_DropDownList1').val(), ResonOfCall: $('#ResonOfCall').val() };
            $.ajax({
                type: "POST",
                url: "CallCenterReport.aspx/ExcelToExport",
                data: JSON.stringify(request),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    $('#btnExcel').attr('disabled', false).val("ExcelToExport");
                    if (result.d == "Excel") {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                    else {
                        showerrormsg("No record found");
                    }
                }
            });
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
</asp:Content>

