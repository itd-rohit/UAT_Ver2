<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DispatchReport.aspx.cs" Inherits="Design_FrontOffice_DispatchReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" >

        <div class="POuter_Box_Inventory" style=" text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Dispatch Report </b>
                    <br />
                    <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">Report Filter</div>
            <div class="row">
                <div class="col-md-3">
                    <span class="filterdate">From Date :</span>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtfromdate" runat="server" Width="110px" class="filterdate" />
                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <span class="filterdate">To Date :</span>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txttodate" runat="server" Width="110px" class="filterdate" />
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Employee:
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="ddlEmployee" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="300px"></asp:ListBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center;">
            <div class="row">
                <div class="col-md-24">
                     <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">


        $(function () {
            jQuery('#<%=ddlEmployee.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });



            bindEmployee();

        });

        $(document).ready(function () {
            $modelBlockUI();

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


        function bindEmployee() {
            $('#<%=ddlEmployee.ClientID%> option').remove();
            jQuery('#<%=ddlEmployee.ClientID%>').multipleSelect("refresh");
           
            $.ajax({
                url: "DispatchReport.aspx/bindEmployee",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    data = jQuery.parseJSON(result.d);

                    for (var a = 0; a <= data.length - 1; a++) {
                        jQuery('#<%=ddlEmployee.ClientID%>').append($("<option></option>").val(data[a].Employee_Id).html(data[a].EmployeeName));
                    }
                    jQuery('#<%=ddlEmployee.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $modelUnBlockUI();
                }
            });
        }


    </script>


    <script type="text/javascript">

        function getreport() {

            var IsValid = true;
            var LedgertransactionID = "";
            //string FromDate,string ToDate,string EmployeeId,string SubcategoryId,string InvestigationId

            if (IsValid) {
                $modelBlockUI();
                var FromDate = $('[id$=txtfromdate]').val().trim();
                var ToDate = $('[id$=txttodate]').val().trim();
                var EmployeeId = $('[id$=ddlEmployee]').val().toString();


                $.ajax({
                    url: "DispatchReport.aspx/GetReport",
                    async: true,
                    data: JSON.stringify({ FromDate: FromDate, ToDate: ToDate, EmployeeId: EmployeeId }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000000,
                    dataType: "json",
                    success: function (result) {
                        $modelUnBlockUI();
                        if (result.d == '1') {
                            $('[id$=lblErr]').text('');
                            window.open('../Common/ExportToExcel.aspx');
                        }
                        else {
                            $('[id$=lblErr]').text('No Record found !');
                        }
                    }
                });
            }

        }

    </script>
</asp:Content>
