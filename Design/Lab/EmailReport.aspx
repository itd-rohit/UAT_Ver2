<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EmailReport.aspx.cs" Inherits="Design_Lab_EmailReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreLoad.ascx" TagName="wuc_CentreLoad"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Email Report</b><br />
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
                <tr>
                    <td style="width: 20%; text-align: right">Mailed To :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:RadioButtonList ID="rdoMailedTo" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Patient" Value="Patient" ></asp:ListItem>
                            <asp:ListItem Text="Doctor" Value="Doctor"></asp:ListItem>
                            <asp:ListItem Text="Client" Value="Doctor"></asp:ListItem>
                        </asp:RadioButtonList>

                    </td>
                    <td style="width: 20%; text-align: right">Mail Type :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                             <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Auto" Value="1" ></asp:ListItem>
                            <asp:ListItem Text="Manual" Value="0"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>



        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre Search &nbsp; &nbsp; 
            </div>
            <uc1:wuc_CentreLoad ID="CentreInfo" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">


            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>

    </div>
    <script type="text/javascript">
        function getReport() {
            var CentreID = '';
            var SelectedLaength = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                CentreID += $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',')[i] + ',';
            }            
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            var MailedTo = $("#<%=rdoMailedTo.ClientID%>").find(":checked").val();
            var MailType = $("#<%=rdoReportType.ClientID%>").find(":checked").val();
            PageMethods.getReport(dtFrom, dtTo, MailedTo, MailType, CentreID, onSuccessReport, OnfailureReport);
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

