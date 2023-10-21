<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CancelReport.aspx.cs" Inherits="Design_OPD_CancelReport"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <b>Cancel Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="text-align: center; width: 47%;">
                <tr>
                    <td style="width: 99px; text-align: right"> From Date :&nbsp;</td>
                    <td style="text-align: left; width: 143px;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 72px; text-align: right">To Date :&nbsp;</td>
                    <td style="text-align: left; width: 137px;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                </tr>
            </table>
            <table style="text-align: center;">
                <tr>
                    <td style="text-align: left; width: 116px;">
                        <asp:CheckBox ID="chkCentres" runat="server" Text="Centers" onclick="SelectAllCentres()" /></td>
                    <td colspan="4">
                        <div style="overflow: scroll; height: 266px; width: 1100px; text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnSearch_Click" />
        </div>

    </div>
    <script type="text/javascript">
        function SelectAllCentres() {
            var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
        }
    }

    </script>
</asp:Content>

