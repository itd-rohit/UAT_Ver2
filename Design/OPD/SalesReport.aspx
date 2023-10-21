<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SalesReport.aspx.cs" Inherits="Design_OPD_SalesReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div id="Pbody_box_inventory"  style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">


            <b>Sales&nbsp; Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory"  style="width: 1300px;">
            <div class="Purchaseheader">
                Report Criteria
            </div>

            <table border="0" style="width: 100%; border-collapse: collapse">
               
                <tr>
                    <td style="width: 12%; text-align: right;">From Date :</td>
                    <td style="width: 17%">
                        <asp:TextBox ID="ucFromDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 7%"></td>
                    <td style="width: 12%"></td>
                    <td style="width: 12%; text-align: right;">To Date :</td>
                    <td style="width: 17%">
                        <asp:TextBox ID="ucToDate" runat="server" Width="100px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 7%"></td>
                    <td style="width: 12%"></td>
                </tr>
               
                <tr>
                    <td style="width: 12%; text-align: right;">Report Type :</td>
                    
                    <td colspan="5">
                          <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="PDF">PDF</asp:ListItem>
                            <asp:ListItem Value="Export">Export</asp:ListItem>
                        </asp:RadioButtonList></td>
                 
                </tr>
              
            </table>



        </div>
        <div class="POuter_Box_Inventory"  style="width: 1300px;">
            <div class="Purchaseheader">

                <input id="chkAllCentre" type="checkbox" value="Users" onclick="CheckBoxListSelect1()" />Select Centre :
            </div>
            <div class="content" style="text-align: left; overflow: auto; max-height: 100px;">
                <table>
                    <tr>
                        <td>
                            <asp:CheckBoxList ID="chklstCenter" CssClass="chkCentre" runat="server" RepeatColumns="5" RepeatDirection="Horizontal"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
           <div class="POuter_Box_Inventory"  style="width: 1300px;">
            <div class="Purchaseheader">
                <input id="chkAllPanel" type="checkbox" value="Users" onclick="CheckBoxListSelect3()" />Select Panel :
            </div>
            <div class="content" style="text-align: left; overflow: auto; max-height: 100px;">
                <table>
                    <tr>
                        <td>
                            <asp:CheckBoxList ID="chklstPanel" CssClass="chkPanel" runat="server" RepeatColumns="5" RepeatDirection="Horizontal"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
           <div class="POuter_Box_Inventory"  style="width: 1300px;">
            <div class="Purchaseheader">
                <input id="chkAllDept" type="checkbox" value="Users" onclick="CheckBoxListSelect4()" />Select Department :
            </div>
            <div class="content" style="text-align: left; overflow: auto; max-height: 100px;">
                <table>
                    <tr>
                        <td>
                            <asp:CheckBoxList ID="chklstDept" CssClass="chkDept" runat="server" RepeatColumns="7" RepeatDirection="Horizontal"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory"  style="width: 1300px;">
            <div class="Purchaseheader">
                <input id="chkAllUser" type="checkbox" value="Users" onclick="CheckBoxListSelect2()" />Select User :
            </div>
            <div class="content" style="text-align: left; overflow: auto; max-height: 100px;">
                <table>
                    <tr>
                        <td>
                            <asp:CheckBoxList ID="chklstUser" CssClass="chkUser" runat="server" RepeatColumns="5" RepeatDirection="Horizontal"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
       
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">
            <asp:Button ID="btnSaleReport" runat="server" Text="Report"  CssClass="searchbutton" OnClick="btnSaleReport_Click" />
        </div>
        </div> 
    <script type="text/javascript">
        function CheckBoxListSelect1() {
            if ($("#chkAllCentre").is(':checked')) {
                $(".chkCentre input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chkCentre input[type=checkbox]").prop('checked', false);
            }

        }
        function CheckBoxListSelect2() {

            if ($("#chkAllUser").is(':checked')) {
                $(".chkUser input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chkUser input[type=checkbox]").prop('checked', false);
            }

        }
        function CheckBoxListSelect3() {

            if ($("#chkAllPanel").is(':checked')) {
                $(".chkPanel input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chkPanel input[type=checkbox]").prop('checked', false);
            }

        }
        function CheckBoxListSelect4() {

            if ($("#chkAllDept").is(':checked')) {
                $(".chkDept input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chkDept input[type=checkbox]").prop('checked', false);
            }

        }
    </script>
</asp:Content>

