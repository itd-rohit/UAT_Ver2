<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PROBusinessForLISPanel.aspx.cs" Inherits="Design_OPD_PROBusinessForLISPanel" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
    <script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(document).keypress(function (e) {
                if (e.which == 13) {

                    SearchReceipt();

                }
            });
        });
        $(function () {
            $('.numbersOnly').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });
        });
        $(function () {
            $('.txtonly').keyup(function () {
                this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
            });
        });


 
    </script>
    <script type="text/javascript"> 
        function CheckBoxListSelect1(Chk,chl)
        { 
            var chh=document.getElementById(Chk).value;
      
       
          
       
            var chkBoxList = chl;
       
            var chkBoxCount= chkBoxList.getElementsByTagName("input");
        
            for(var i=0;i<chkBoxCount.length;i++)
            {
                chkBoxCount[i].checked = document.getElementById(Chk).checked;
            }
       
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="body_box_inventory" style="width: 97%;">
        <div class="Outer_Box_Inventory" style="width: 99.6%;">
            <div class="content">
                <div style="text-align: center;">
                    <b>PRO Business Report</b>
                </div>
                <div style="text-align: center;">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>

            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="content">
                <table style="width: 851px; float: left;">
                    <tr>
                        <td>From Date :</td>
                        <td>
                            <uc1:EntryDate ID="txtFromDate" runat="server" />
                        </td>
                        <td style="width: 66px">To Date : 
                        </td>
                        <td>
                            <uc1:EntryDate ID="txtToDate" runat="server"></uc1:EntryDate>
                        </td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 103px; height: 22px; text-align: left">Pay Mode :</td>
                        <td colspan="3" style="height: 22px; text-align: left">

                            <asp:RadioButtonList ID="chkPaymentMode" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" AutoPostBack="true"
                                OnSelectedIndexChanged="chkPaymentMode_SelectedIndexChanged">
                                <asp:ListItem Value="lt.AmtCredit=0" Selected="True">Cash</asp:ListItem>
                                <asp:ListItem Value="lt.AmtCredit>0">Credit</asp:ListItem>
                                <asp:ListItem Value="Both">Both</asp:ListItem>
                            </asp:RadioButtonList>


                        </td>
                    </tr>
                    <tr>
                        <td style="width: 103px; height: 22px; text-align: left">Panel Status :</td>
                        <td colspan="3" style="height: 22px; text-align: left">

                            <asp:RadioButtonList ID="rblPanelStatus" runat="server" RepeatColumns="3" RepeatDirection="Horizontal" AutoPostBack="true"
                                OnSelectedIndexChanged="rblPanelStatus_SelectedIndexChanged">
                                <asp:ListItem Value="and IsActive=1" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="and IsActive=0">In-Active</asp:ListItem>
                                <asp:ListItem Value="">ALL</asp:ListItem>
                            </asp:RadioButtonList>


                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%;">
            <div class="Purchaseheader">Report Format :</div>
            <div class="content">

                <table style="width: 851px; float: left;">



                    <tr>
                        <td>Report Type :</td>
                        <td colspan="4">
                            <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal"
                                OnSelectedIndexChanged="rblReportType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Selected="true" Value="Summary">Single Line Summary</asp:ListItem>
                                <asp:ListItem Value="MonthlySummary">Monthly Summary</asp:ListItem>
                                <asp:ListItem Value="Detail">Detail</asp:ListItem>
                                <asp:ListItem Value="Performance">Performance</asp:ListItem>
                                    <asp:ListItem Value="PerformanceII">PerformanceII</asp:ListItem>

                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr id="td_rptFormate" runat="server">
                        <td>Report Formate :</td>
                        <td colspan="4">
                            <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Value="PDF">PDF</asp:ListItem>
                                <asp:ListItem Value="Excel">Excel</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>


                </table>
            </div>
        </div>


         <div class="POuter_Box_Inventory"  style="width:99.6%;">
         <div class="Purchaseheader"  style="width:100%;">
         <input id="chkCentre" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkCentre',document.getElementById('<%=chklstCenter.ClientID %>'))"  />Select Centre :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstCenter" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
        <div class="POuter_Box_Inventory"  style="width:99.6%;">
         <div class="Purchaseheader"  style="width:100%;">
         <input id="chkPRO" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkPRO',document.getElementById('<%=chklstPRO.ClientID %>'))"  />Select PRO:</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstPRO" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>


    <div class="POuter_Box_Inventory"  style="width:99.6%;">
         <div class="Purchaseheader"  style="width:100%;">
         <input id="chkpan" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkpan',document.getElementById('<%=chkPanel.ClientID %>'))"  />Select Panel:</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
                 <div style="height:250px;overflow:scroll;">
    <asp:CheckBoxList ID="chkPanel" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
        </asp:CheckBoxList></div>
              </td>
                        </tr>
               </table>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="display:none;">
         <div class="Purchaseheader">
         <input id="chkDoctor" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkDoctor',document.getElementById('<%=chklstDoctor.ClientID %>'))"  />Select Doctor :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstDoctor" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center;width:99.6%;">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:CheckBox ID="chkFromMaster" runat="server" Text="From Master"/> 
            
            <asp:Button ID="btnReport" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnReport_Click"/>
                </div>
    </div>
</asp:Content>

