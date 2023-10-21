<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DepartmentWiseSales.aspx.cs" Inherits="Design_Lab_PrePrintedBarcode" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      <%: Scripts.Render("~/bundles/Chosen") %>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <style>
       
        .POuter_Box_Inventory {
        
        width:1200px;
        }
    </style>
    <div id="Pbody_box_inventory" style="width: 1205px;">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Department Wise Sales Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        
        <div class="POuter_Box_Inventory">
            <div class="content">

                <table>

                    <tr>
                        <td style="width:90px" >
                          <strong> From Date :</strong> 
                        </td>
                        <td style="width:150px">
                            <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                        </td>

                        <td style="width:80px">
                        <strong>   To Date : </strong>
                        </td>
                        <td style="width:150px">
                           <asp:TextBox ID="txtToDate"  CssClass="ItDoseTextinputText"  runat="server" ReadOnly="true"  Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                        </td>

                         <td style="width:80px" >
                           <strong> Centre :</strong> 
                        </td>
                        <td style="width:280px">
                              <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess chosen-select" Width="255px" runat="server">
                        </asp:DropDownList>
                        </td>
                        <td>
                            <input type="button" value="PDF Report" onclick="GetReport(1)" />
                            <input type="button" value="Excel Report"  onclick="GetReport(2)" />

                        </td>
                    </tr>

                </table>


            </div>


        </div>
    </div>
    <script>

        $(document).ready(function () {


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


        function GetReport(Type)
        {
            var FromDate = $('[id$=txtFormDate]').val();
            var ToDate = $('[id$=txtToDate]').val();
            var Centre = $('[id$=ddlCentreAccess]').val();

            $.ajax({
                url: "DepartmentWiseSales.aspx/GetReport",
                async: true,
                data: JSON.stringify({FromDate:FromDate,ToDate:ToDate,Centre:Centre,Type:Type}),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = result.d;
                    if (data == "0")
                    {
                        alert("No Record Found !");
                    }
                    else if (data == "1") {
                        window.open('../Common/Commonreport.aspx');
                    }
                    else if (data == "2") {
                        window.open('../Common/ExportToExcel.aspx');
                    }
                }
            });

        }
    </script>
   

</asp:Content>

