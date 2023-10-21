<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="PendingToTransferSampleReport.aspx.cs" Inherits="Design_Lab_DoctorApprovalReport" %>

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
                            <b>Pending To Transfer Sample Report </b>
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
                    <td style="width:320px">
                        <asp:TextBox ID="txtfromdate" runat="server" Width="110px" class="filterdate" />
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        <span class="filterdate">To Date :</span>
                    </td>
                    <td  style="width:320px">
                        <asp:TextBox ID="txttodate" runat="server" Width="110px" class="filterdate" />
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td></td>
                    <td></td>

                </tr>
                <tr>
                    <td>Centre:</td>
                    <td>
                        <asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="300px"></asp:ListBox>
                    </td>
                    <td>
                    </td>
                    <td>
                        
                    </td>
                    <td>
                    </td>
                    <td>
                        
                    </td>

                </tr>


            </table>



        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">

            <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center; max-height: 500px; overflow-x: auto;">
        </div>

    </div>


    <script type="text/javascript">


        $(function () {
            jQuery('#<%=ddlCentre.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

           
            
            bindCentre();
           
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


        function bindCentre() {
            $('#<%=ddlCentre.ClientID%> option').remove();
            jQuery('#<%=ddlCentre.ClientID%>').multipleSelect("refresh");
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            $.ajax({
                url: "PendingToTransferSampleReport.aspx/bindCentre",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    data = jQuery.parseJSON(result.d);

                    for (var a = 0; a <= data.length - 1; a++) {
                        jQuery('#<%=ddlCentre.ClientID%>').append($("<option></option>").val(data[a].CentreID).html(data[a].Centre));
                    }
                    jQuery('#<%=ddlCentre.ClientID%>').multipleSelect({
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
            //string FromDate,string ToDate,string CentreId,string SubcategoryId,string InvestigationId

            if (IsValid) {
                $modelBlockUI();
                var FromDate = $('[id$=txtfromdate]').val().trim();
                var ToDate = $('[id$=txttodate]').val().trim();
                var CentreId = $('[id$=ddlCentre]').val().toString();
              
               
                $.ajax({
                    url: "PendingToTransferSampleReport.aspx/GetReport",
                    async: true,
                    data: JSON.stringify({FromDate:FromDate,ToDate:ToDate,CentreId:CentreId }),
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
