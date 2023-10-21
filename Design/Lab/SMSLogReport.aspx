<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SMSLogReport.aspx.cs" Inherits="Design_Lab_SMSLogReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>SMS Log Report</b><br />
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

                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                </tr>
           
            </table>



        </div>    
        <div class="POuter_Box_Inventory" style="text-align: center">


            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>

    </div>
    <script type="text/javascript">
        function getReport() {
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            PageMethods.getReport(dtFrom, dtTo,onSuccessReport, OnfailureReport);
        }
        function onSuccessReport(result) {
            if (result == "1") {
                window.open('../common/ExportToExcel.aspx');
            }
            else if (result == "0") {
                alert('Record Not Found....!');
            }
	    else if (result == "-2") {
                alert('Date Difference Not More Than 31 Days....!');
            }
        }
        function OnfailureReport() {
            alert('Error Occured....! Kindly Select Centre');
            
        }
    </script>
</asp:Content>

