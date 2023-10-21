<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LogisticReceivePendingReport.aspx.cs" Inherits="Design_Lab_LogisticReceivePendingReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;"">

            <b>Logistic Receive Pending Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="text-align: center;">
                <tr>
                    <td style="text-align: left; width: 116px;">
                        <asp:CheckBox ID="chkCentres" runat="server" Text="Centers" onclick="SelectAllCentres()" /></td>
                    <td colspan="3">
                        <div style="overflow: scroll; height: 266px; width: 1210px; text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <table style="text-align: center; width: 100%;">
                
                <tr>
                    <td style="width: 20%; text-align: right"> From Collection Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Collection Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                </tr>
                
            </table>
            


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnSearch_Click" OnClientClick="return validate()"/>
        </div>

    </div>
     <script type="text/javascript">
         function validate() {
             
             if ($(".chkCentre input[type=checkbox]:checked").length == 0) {
                 $("#lblMsg").text('Please Select Centre');
                 return false;
             }
             else
                 return true;
         }
         function SelectAllCentres() {
             var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
             var chkBoxCount = chkBoxList.getElementsByTagName("input");
             for (var i = 0; i < chkBoxCount.length; i++) {
                 chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
            }
        }

    </script>
</asp:Content>

