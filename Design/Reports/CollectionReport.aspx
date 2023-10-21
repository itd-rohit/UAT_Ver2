<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static"CodeFile="CollectionReport.aspx.cs" Inherits="Design_Reports_CollectionReport" MasterPageFile="~/Design/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Collection Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <table border="0" style="width: 100%">
                <tr style="border: dotted">
                    <td style="width: 10%; text-align: right; border: groove" valign="middle">
                        <asp:CheckBox ID="chkCentres"  runat="server" onclick="SelectAll('Centre')" Text="Centre :&nbsp;"  /></td>
                    <td colspan="4" style="width: 17%; border: groove; border-left: none; overflow-y: scroll">
                        <asp:CheckBoxList ID="chlCentres"  runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>



                    </td>
                </tr>
                <tr>
                    <td style="width: 10%; text-align: right; border: groove;">
                        <asp:CheckBox ID="chkUsers" runat="server" Text="Users" onclick="SelectAll('Users')" />
                    </td>
                    <td colspan="4" style="width: 17%; height: 25%; border-bottom: groove; border-right: groove; border-top: groove;">
                        <div  style="text-align: left;overflow-y: scroll">
                            <asp:CheckBoxList ID="cblUser" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td style="width: 10%; text-align: right; border-right: groove; border-left: groove">From Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="ucFromDate" runat="server" Width="100px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        &nbsp;Time :&nbsp;
                           <asp:TextBox ID="txtFromTime" runat="server" Width="75px" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" AcceptAMPM="false" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime"  >
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <td style="width: 10%; text-align: right">To Date :&nbsp;
                    </td>
                    <td colspan="2" style="width: 12%; border-right: groove; text-align: left">
                        <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                <td>
                                    <asp:TextBox ID="ucToDate" runat="server" Width="100px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calucToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </td>
                                <td>Time&nbsp;:&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtToTime" runat="server" Width="75px" />
                                    <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtToTime" AcceptAMPM="false" >
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </td>
                                <td style="width: 40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%; text-align: right; border-left: groove; border-right: groove; border-bottom: groove">Report Type :&nbsp;
                    </td>
                    <td colspan="4" style="border-right: groove; border-bottom: groove">
                        <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal" RepeatColumns="4">
                            <asp:ListItem Selected="True" Value="0">Summary</asp:ListItem>
                            <asp:ListItem Value="1">PatientWiseReport</asp:ListItem>
                            <asp:ListItem Value="2">ClientWiseSummary</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr id="trReportFormat" runat="server" visible="false">
                    <td style="width: 10%; text-align: right; border-left: groove; border-right: groove; border-bottom: groove">Report Format :&nbsp;
                    </td>

                    <td colspan="4" style="border-right: groove; border-bottom: groove">
                        <asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" RepeatColumns="4">
                            <asp:ListItem Selected="True" Value="1">PDF</asp:ListItem>
                            <asp:ListItem Value="2">Excel</asp:ListItem>

                        </asp:RadioButtonList>
                    </td>
                </tr>

                <tr id="panel" runat="server" visible="false">
                    <td style="width: 10%; text-align: right; border-left: groove; border-right: groove; border-bottom: groove">
                        <asp:CheckBox ID="challpanel" runat="server" Text="Panel" AutoPostBack="true" OnCheckedChanged="challpanel_CheckedChanged" />
                    </td>
                    <td colspan="4" style="border-right: groove; border-bottom: groove">
                        <div style="width: 100%; max-height: 200px; overflow: scroll;">
                            <asp:CheckBoxList ID="chpanel" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" CssClass="ItDoseCheckbox" RepeatLayout="Table">
                            </asp:CheckBoxList>
                        </div>

                    </td>
                </tr>
            </table>





        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnPreview" runat="server" Text="Report" OnClientClick="CheckTransType();return false;" CssClass="searchbutton" OnClick="btnPreview_Click" />
            &nbsp;&nbsp;
        <asp:Button ID="btnexporttoexcel" runat="server" Text="Export To Excel" OnClick="btnexcel_Click" Visible="false" />
        </div>

    </div>
    <script type="text/javascript">
        function CheckTransType() {
            var stat = false;
            var ctrl = document.getElementById("cblColType");
            var arrayOfCheckBoxes = ctrl.getElementsByTagName("input");
            for (var i = 0; i < arrayOfCheckBoxes.length; i++)
                if (arrayOfCheckBoxes[i].checked)
                    stat = true;
            if (stat == false) {
                alert('Select Collection Type');
            }
            else {
                _dopostback(btnPrint);
            }
        }
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                    var chkBoxCount = chkBoxList.getElementsByTagName("input");
                    for (var i = 0; i < chkBoxCount.length; i++) {
                        chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                    }
                }
                else {
                    var chkBoxList = document.getElementById('<%=cblUser.ClientID %>');
                    var chkBoxCount = chkBoxList.getElementsByTagName("input");
                    for (var i = 0; i < chkBoxCount.length; i++) {
                        chkBoxCount[i].checked = document.getElementById('<%=chkUsers.ClientID %>').checked;
                    }
                }


            }

    </script>

</asp:Content>
