<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ImportExportItemInterface.aspx.cs" EnableEventValidation="false" Inherits="Design_Interface_ImportExportItemInterface" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Import Export Item Interface Master</b>
            <br />
            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>

        </div>



        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Interface Company</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCompany" class="ddlCompany chosen-select" runat="server"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Select File</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:FileUpload ID="file1" runat="server" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnupload" runat="server" Text="Upload" OnClientClick="return ImportData();" OnClick="btnupload_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />

                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnExport" runat="server" Text="Export File" OnClick="btnExport_Click" OnClientClick="return ExportFile();" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />

                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnsave" runat="server" Text="Save To DataBase" OnClick="btnsave_Click" Style="display: none; cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold; cursor: not-allowed" Enabled="false" />

                </div>
            </div>
        
    </div>




    <div class="row">
        <div class="content" style="height: 420px; width: 99%; overflow: scroll;">
            <table class="" style="width: 100%">
                <asp:GridView ID="grd" CssClass="mydatagrid" PagerStyle-CssClass="pager" Style="width: 100%;"
                    HeaderStyle-CssClass="header" RowStyle-CssClass="rows" runat="server" AutoGenerateColumns="true" OnRowDataBound="grd_RowDataBound">
                </asp:GridView>
            </table>
        </div>
    </div>
    </div>
    <%--Loading Panel--%>
    <asp:HiddenField ID="hdnNoProgress" runat="server" Value="0" />
    <div id="Background2" class="Background" style="display: none">
    </div>
    <div id="Progress2" class="Loading" style="display: none;">
        <img src="../../App_Images/Progress.gif" />&nbsp;&nbsp;
        Please wait...
    </div>
    <%--Loading Panel--%>

    <script type="text/javascript">

        $(function () {
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
            $('.chosen-container').css('width', '230px');
        });


        function ExportFile() {

            var Company = $('[id$=ddlCompany] option:selected').text().trim();
            if (Company == "") {
                toast('Error','Please select Company !');
                return false;
            }
            //serverCall('ImportExportItemInterface.aspx/ExportFile', { Company: Company }, function (response) {
            //    window.open('../common/ExportToExcel.aspx');
            //});

            
            //return false;
        }


        function ImportData() {
            var input = $('[id$=file1]');
            var FileName = $('[id$=file1]').val().trim();

            if ($('[id$=ddlCompany] option:selected') == "") {
                toast('Error','Please select Company !');
                return false;
            }

            if (FileName == "") {
                toast('Error','Please select File !');
                return false;
            }
            var arr = FileName.split('.');
            if (arr[arr.length - 1].toUpperCase() != 'XLSX') {
                toast('Error','Please select a valid .xlsx file !');
                return false;
            }
            var IsInValid = false;
            $('[id$=grd] tr').each(function (index) {
                if ($(this).find('td').eq(6).text() != $('[id$=ddlCompany] option:selected').text()) {
                    IsInValid = true;
                }
            });

            if (IsInValid) {
                toast('Error','Company is not matching ! ');
                return false;
            }

        }
    </script>

    <script type="text/javascript">

        window.onbeforeunload = function () {

            if ($('[id$=hdnNoProgress]').val() == '0') {
                ShowProgress();
            }
            else
                $('[id$=hdnNoProgress]').val('0');

        }
        // Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(pageLoaded);
        function pageLoaded() {
            HideProgress();
        }
        function ShowProgress() {

            $('[id$=Background2]').css('display', '');
            $('[id$=Progress2]').css('display', '');

        }

        function HideProgress() {

            $('[id$=Background2]').css('display', 'none');
            $('[id$=Progress2]').css('display', 'none');
        }
        function SetHiddenFieldValue() {
            $('[id$=hdnNoProgress]').val('1');
        }

    </script>
    <style type="text/css">
        .Background {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: gray;
            filter: alpha(opacity=222);
            opacity: 0.4;
            z-index: 999;
        }

        .Loading {
            background-color: transparent;
            position: fixed;
            top: 55%;
            left: 45%;
            width: 150px;
            height: 45px;
            border: 0px solid #ccc;
            text-align: center;
            vertical-align: middle;
            padding-top: 10px;
            font-family: Arial;
            font-size: 12px;
            z-index: 9999;
        }

        .mydatagrid {
            width: 80%;
            border: solid 2px black;
            min-width: 80%;
        }

        .header {
            background-color: #09f;
            font-family: Arial;
            color: White;
            border: 1px solid #ccc;
            height: 25px;
            text-align: center;
            font-size: 12px;
        }

        .rows {
            background-color: #fff;
            font-family: Arial;
            font-size: 12px;
            color: #000;
            min-height: 25px;
            text-align: left;
            border:1px solid #ccc;
        }

            
        .mydatagrid a /** FOR THE PAGING ICONS  **/ {
            background-color: Transparent;
            padding: 5px 5px 5px 5px;
            color: #fff;
            text-decoration: none;
            font-weight: bold;
        }

            .mydatagrid a:hover /** FOR THE PAGING ICONS  HOVER STYLES**/ {
                background-color: #000;
                color: #fff;
            }

        .mydatagrid span /** FOR THE PAGING ICONS CURRENT PAGE INDICATOR **/ {
            background-color: #c9c9c9;
            color: #000;
            padding: 5px 5px 5px 5px;
        }

        .pager {
            background-color: #646464;
            font-family: Arial;
            color: White;
            height: 30px;
            text-align: left;
        }

        .mydatagrid td {
            padding: 5px;
        }

        .mydatagrid th {
            padding: 5px;
        }
    </style>


</asp:Content>

