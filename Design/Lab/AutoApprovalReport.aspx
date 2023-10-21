<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AutoApprovalReport.aspx.cs" Inherits="Design_Lab_AutoApprovalReport"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Auto Approval Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>

        <div class="POuter_Box_Inventory">
            
                <div class="row">
                    <div class="col-md-4"></div>
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
                Centre
                <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" />
            </div>
            <div style="overflow: scroll; height: 400px;">
                <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnExcelReport" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnExcelReport_Click" OnClientClick="return validate();" />

        </div>

    </div>
    <script type="text/javascript">
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                 }
             }
         }

    </script>
    <script type="text/javascript">
        function validate() {
            document.getElementById('<%=btnExcelReport.ClientID%>').disabled = true;
            document.getElementById('<%=btnExcelReport.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnExcelReport', '');


        }
    </script>
</asp:Content>

