<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CriticalPatientReport.aspx.cs" Inherits="Design_Lab_CriticalPatientReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreLoad.ascx" TagName="wuc_CentreLoad"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Critical Patient Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria Approved Date
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromDate" runat="server" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre Search
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
            serverCall('CriticalPatientReport.aspx/getReport', { dtFrom: dtFrom, dtTo: dtTo, CentreID: CentreID }, function (response) {
                PostFormData(response, response.ReportPath);
            });
            
        }
       
    </script>
</asp:Content>

