<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhleboLoginReport.aspx.cs" Inherits="Design_HomeCollection_PhleboLoginReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Phlebo Login Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-4"></div>
                 <div class="col-md-2">
                            <label class="pull-left"><b>From Date </b></label>
			                <b class="pull-right">:</b>
                        </div>
                 
                        <div class="col-md-2">
                             <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                             </div>
                <div class="col-md-3"></div>
                <div class="col-md-2">
                            <label class="pull-left"><b>To Date </b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtToDate" runat="server"  />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                 </div>
            </div>
           



       
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <input type="button" class="ItDoseButton" value="Summary" onclick="getReport(1);"  />
              <input type="button" class="ItDoseButton" value="Details" onclick="getReport(2);"  />

            
        </div>

    </div>
    <script type="text/javascript">
        function getReport(type) {
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            PageMethods.getReport(dtFrom, dtTo,type, onSuccessReport, OnfailureReport);
        }
        function onSuccessReport(result) {
            if (result == "1") {
                window.open('../common/ExportToExcel.aspx');
            }
            else if (result == "0") {
                toast('Info','Record Not Found');
            }
            else if (result == "-2") {
                toast('Error', 'Date Difference Not More Than 31 Days');
            }
        }
        function OnfailureReport() {
            toast('Error', 'Error Occured');

        }
    </script>
</asp:Content>

