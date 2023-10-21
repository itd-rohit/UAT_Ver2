<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BulkRegistration.aspx.cs" Inherits="Design_Master_BulkRegistration" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
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
        });
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <b>Bulk Registration (Test Code :- RT-COV19-ECGI Test Name :- COVID19 PCR)  </b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Detail
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Download Excel </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 " style="text-align: left">

                    <asp:Button ID="btnDownloadExcel" runat="server" OnClick="btnDownloadExcel_Click" Text="Download Excel" CssClass="savebutton" OnClientClick="return validateDownload();" />
                </div>
                <div class="col-md-2 "></div>

            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Upload By </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 " style="text-align: left">
                    <asp:TextBox ID="txtWitness" MaxLength="50" runat="server" CssClass="requiredField"></asp:TextBox>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Upload Excel </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 " style="text-align: left">
                    <asp:FileUpload ID="fuExcel" runat="server" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload Excel" CssClass="savebutton" OnClientClick="return validateUpload();" />
                    <asp:TextBox ID="txtDOB" ClientIDMode="Static" runat="server" Style="display: none"></asp:TextBox>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function validateDownload() {

            // document.getElementById('<%=btnDownloadExcel.ClientID%>').disabled = true;
            // document.getElementById('<%=btnDownloadExcel.ClientID%>').value = 'Submitting...';
            // __doPostBack('ctl00$ContentPlaceHolder1$btnDownloadExcel', '');

        }
        function validateUpload() {
            if ($.trim($("#txtWitness").val()) == "") {
                toast('Error', 'Please Enter Witness');
                $("#txtWitness").focus();
                return false;
            }
            if ($("#fuExcel")[0].files.length == 0) {
                toast('Error', 'Please Select File');
                $("#fuExcel").focus();
                return false;
            }
            var file = $('#fuExcel').val();
            if (!(/\.(xlsx|xls)$/i).test(file)) {
                toast('Error','Please upload valid excel file .xlsx, .xls only');
                $(file).val('');
                return false;
            }

            $modelBlockUI();
            document.getElementById('<%=btnUpload.ClientID%>').disabled = true;
            document.getElementById('<%=btnUpload.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnUpload', '');

        }
    </script>
    <script type="text/javascript">
        function getdob(AgeInYear, AgeInMonth, AgeInDays) {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if (AgeInYear != "")
                ageyear = AgeInYear;

            if (AgeInMonth != "")
                agemonth = AgeInMonth;

            if (AgeInDays != "")
                ageday = AgeInDays;

            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar",
    "Apr", "May", "Jun", "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var DOB = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;

            $("#txtDOB").val(DOB);

        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }
    </script>
</asp:Content>

