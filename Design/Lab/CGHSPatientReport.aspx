<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CGHSPatientReport.aspx.cs" Inherits="CGHSPatientReport" %>

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

    <div id="Pbody_box_inventory" style="width: 1304px;">

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>CGHS Patient Report </b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">


            <div class="Purchaseheader">Report Filter</div>
            <table>
                <tr>
                    <td>
                        <span class="filterdate">From Date :</span>
                    </td>
                    <td style="width: 320px">
                        <asp:TextBox ID="txtfromdate" runat="server" Width="110px" class="filterdate" />
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        <span class="filterdate">To Date :</span>
                    </td>
                    <td style="width: 320px">
                        <asp:TextBox ID="txttodate" runat="server" Width="110px" class="filterdate" />
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td></td>
                    <td></td>

                </tr>
                <tr style="display:none;">
                    <td>Report Type:</td>
                    <td>
                        <asp:RadioButtonList ID="rdlReportType" runat="server" RepeatColumns="2">
                            <asp:ListItem Text="Summary" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Detail" Value="2"  Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>

                </tr>


            </table>



        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">
             <input type="button" value="Search" class="searchbutton" onclick="Search();" />
            <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
        </div>
     <div id="divRecord" class="POuter_Box_Inventory" style="width: 1300px; text-align: center; max-height: 500px; overflow-x: auto;display:none;">
            <table id="tblRecord" style="width:70%">
                <tr>
                    <th class="GridViewHeaderStyle" style="width:4%">SNo.</th>
                    <th class="GridViewHeaderStyle"  style="width:15%">Patient Id</th>
                    <th class="GridViewHeaderStyle"  style="width:30%">Patient Name</th>
                    <th class="GridViewHeaderStyle" style="width:20%">Visit No</th>
                    <th class="GridViewHeaderStyle" style="width:15%">Age/Gender</th>
                    <th class="GridViewHeaderStyle" style="width:15%">Date</th>
                    <th class="GridViewHeaderStyle"  style="width:1%"><input type="checkbox" id="chkAll" onchange="SelectAll()" /> </th>

                </tr>

            </table>

        </div>

    </div>



    <script type="text/javascript">

        function getreport() {

            var IsValid = false;
            var LedgertransactionID = "";

            var LtId = '';
            $('#tblRecord tr').each(function (index) {
                if (index > 0) {
                    if ($(this).find('input[type=checkbox]').is(':checked')) {
                        LtId += $(this).find('#hdnLtId').val() + ',';
                        IsValid = true;
                    }
                }
            });

            if (IsValid) {
                $modelBlockUI();
                var FromDate = $('[id$=txtfromdate]').val().trim();
                var ToDate = $('[id$=txttodate]').val().trim();
                var ReportType = $('[id$=rdlReportType] input:checked').val();
                LtId = LtId.substring(0, (LtId.length - 1));


                $.ajax({
                    url: "CGHSPatientReport.aspx/GetReport",
                    async: true,
                    data: JSON.stringify({ FromDate: FromDate, ToDate: ToDate, ReportType: ReportType, LtId: LtId }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000000,
                    dataType: "json",
                    success: function (result) {
                        $modelUnBlockUI();
                        if (result.d == '1') {
                            $('[id$=lblErr]').text('');
                            window.open("CGHSReport.aspx");
                            window.open("CGHSReport_Annexure5.aspx");
                            window.open("CGHSReport_Annexure7.aspx");
                        }
                        else {
                            $('[id$=lblErr]').text('No Record found !');
                        }

                    }
                });
            }
            else {

                alert('Please select any record !');
            }

        }


        function Search() {

            var IsValid = true;
            var LedgertransactionID = "";
            //string FromDate,string ToDate,string CentreId,string SubcategoryId,string InvestigationId

            if (IsValid) {
                $modelBlockUI();
                var FromDate = $('[id$=txtfromdate]').val().trim();
                var ToDate = $('[id$=txttodate]').val().trim();
                var ReportType = $('[id$=rdlReportType] input:checked').val();

                $.ajax({
                    url: "CGHSPatientReport.aspx/Search",
                    async: true,
                    data: JSON.stringify({ FromDate: FromDate, ToDate: ToDate, ReportType: ReportType }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000000,
                    dataType: "json",
                    success: function (result) {
                        $modelUnBlockUI();
                        if (result.d == '0') {
                            $('[id$=lblErr]').text('Some Error Occured !');
                        }
                        else {
                            var data = $.parseJSON(result.d);
                            if (data.length > 0) {
                                $('#divRecord').show();
                                for (var i = 0; i < data.length; i++) {
                                    var html = '';
                                    html += '<tr>';
                                    html += '<td class="GridViewLabItemStyle">' + (i + 1) + ' <input id="hdnLtId" type="hidden" value="' + data[i].LedgertransactionId + '" /> </td>';
                                    html += '<td class="GridViewLabItemStyle">' + data[i].Patient_Id + ' </td>';
                                    html += '<td class="GridViewLabItemStyle">' + data[i].PName + ' </td>';
                                    html += '<td class="GridViewLabItemStyle">' + data[i].LedgertransactionNo + ' </td>';
                                    html += '<td class="GridViewLabItemStyle">' + data[i].col1 + ' </td>';
                                    html += '<td class="GridViewLabItemStyle">' + data[i].DATE + ' </td>';
                                    html += '<td class="GridViewLabItemStyle"> <input type="checkbox" id="chk" /> </td>';
                                    html += '</tr>';
                                    $('#tblRecord').append(html);
                                }
                            }
                            else {
                                $('#divRecord').hide();
                                $('[id$=lblErr]').text('No Record Found !');
                            }
                        }
                    }
                });
            }

        }

        function SelectAll() {
            $('#tblRecord tr').each(function (index) {
                if (index > 0) {
                    if ($('#chkAll').is(':checked')) {
                        $(this).find('input[type=checkbox]').attr('checked', true);
                    }
                    else {
                        $(this).find('input[type=checkbox]').attr('checked', false);

                    }
                }
            });
        }

       

    </script>
</asp:Content>
