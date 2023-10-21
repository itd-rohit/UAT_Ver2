<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CentreShareReport.aspx.cs" Inherits="Design_OPD_CentreShareReport" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<%--    <script type="text/javascript" language="javascript" src="../../Design/Common/popcalendar.js"></script>--%>
  <%--  <script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>--%>
    <%--<script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>--%>
    <%--<script type="text/javascript" src="../../scripts/jquery-1.8.3.min.js"></script>--%>
    <%--<script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>--%>
    <%--<link href="../../combo-select-master/docsupport/prism.css" rel="stylesheet" />--%>
    <%--<link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css" />--%>
    <%--<script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>--%>
    <%--<script src="../../combo-select-master/docsupport/prism.js" type="text/javascript"></script>--%>
<%--    <script src="../../JavaScript/json2.js" type="text/javascript"></script>--%>
    <%--<script type="text/javascript" src="../../JavaScript/ckeditor/ckeditor.js"></script>--%>
    <style type="text/css">
        .searchbutton {
            cursor: pointer;
            background-color: blue;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }
    </style>

    <script type="text/javascript">
        function SelectAllDepartment() {
            var chkBoxList = document.getElementById('<%=chkDepartment.ClientID %>');

            var chkBoxCount = chkBoxList.getElementsByTagName("input");

            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkAllDepartment.ClientID %>').checked;
             }

         }


         function BookingCentre() {
             var chkBoxList = document.getElementById('<%=cblBooingCentre.ClientID %>');

            var chkBoxCount = chkBoxList.getElementsByTagName("input");

            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkBookingCentre.ClientID %>').checked;
                 }

             }
             function TestCentre() {
                 var chkBoxList = document.getElementById('<%=cblTestCentre.ClientID %>');

            var chkBoxCount = chkBoxList.getElementsByTagName("input");

            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkTestCentre.ClientID %>').checked;
            }

        }
    </script>

   <%-- <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>--%>
   <%-- <link href="../../scripts/multiple-select.css" rel="stylesheet" />--%>

    <%--<script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>--%>
    <%--<script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>--%>

    <%--multiselect css--%>
    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>
    <%--multiselect css--%>
    <div id="Pbody_box_inventory" style="width: 97%">
        <div class="Outer_Box_Inventory" style="width: 99.6%;">
            <div class="content" style="text-align: center;">
                <b>Centre Share Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div id="alldata1" class="Outer_Box_Inventory" runat="server" style="width: 99.6%;">
            <div class="content">
                <div style="text-align: center">
                    <table cellpadding="0" cellspacing="0" style="width: 90%; text-align: center">
                        <tr>
                            <td style="height: 24px; width: 116px;" align="left"><b>From Date: </b></td>
                            <td style="height: 24px;" align="left">
                                <uc1:EntryDate ID="ucFromDate1" runat="server" />
                            </td>
                            <td align="right" style="width: 204px; height: 24px"></td>
                            <td style="height: 24px;" align="left"></td>
                            <td style="height: 24px; width: 116px;" align="left"><b>To Date: </b></td>
                            <td style="height: 24px;" align="left">
                                <uc1:EntryDate ID="ucToDate1" runat="server" />
                            </td>
                        </tr> 
                    </table>
                </div>
            </div>
        </div>
        <div class="Outer_Box_Inventory" id="Div1" runat="server" style="width: 99.6%;">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkBookingCentre" runat="server" Text="Booking Centre" onclick="BookingCentre()" />
            </div>
            <div style="overflow: auto; max-height:150px; width: 99.6%; text-align: left;">
                <asp:CheckBoxList ID="cblBooingCentre" runat="server" CssClass="ItDoseCheckboxlist" RepeatColumns="5" RepeatDirection="Horizontal"></asp:CheckBoxList>
            </div>
        </div>
        <div class="Outer_Box_Inventory" id="Div3" runat="server" style="width: 99.6%;">
            <div class="Purchaseheader"> 
            Test Type : </div>
            <div style="overflow: auto; max-height:150px; width: 99.6%; text-align: left;">
                  <asp:RadioButtonList ID="rdbtesttype" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged">
                                   <asp:ListItem Value="ALL" Selected="True">ALL</asp:ListItem>
                                     <asp:ListItem Value="InHouse">In House</asp:ListItem>
                                    <asp:ListItem Value="OutHouse">Out House</asp:ListItem>
                                    <asp:ListItem Value="OutSource">Outsource to other lab</asp:ListItem>
                                </asp:RadioButtonList>
            </div>
        </div>
          <div class="Outer_Box_Inventory" id="Div4" runat="server" style="width: 99.6%;">
            <div class="Purchaseheader"> 
            Report Type : </div>
            <div style="overflow: auto; max-height:150px; width: 99.6%; text-align: left;">
                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Selected="True">Summary I</asp:ListItem>
                                    <asp:ListItem Value="1">Summary II</asp:ListItem>
                                    <asp:ListItem Value="2">Detail</asp:ListItem>
                                </asp:RadioButtonList>
            </div>
        </div>
        <div class="Outer_Box_Inventory" id="Div2" runat="server" style="width: 99.6%;">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkTestCentre" runat="server" Text="Test Centre" onclick="TestCentre()" />
            </div>
            <div style="overflow: auto; max-height: 40px; width: 99.6%; text-align: left;">
                <asp:CheckBoxList ID="cblTestCentre" runat="server" CssClass="ItDoseCheckboxlist" RepeatColumns="5" RepeatDirection="Horizontal"></asp:CheckBoxList>
            </div>
        </div>
        <div class="Outer_Box_Inventory" id="alldepartment" runat="server" style="width: 99.6%;">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkAllDepartment" runat="server"
                    Text="Department" onclick="SelectAllDepartment()" />
            </div>
            <div style="overflow: auto; max-height: 40px; width: 99.6%; text-align: left;">
                <asp:CheckBoxList ID="chkDepartment" runat="server" CssClass="ItDoseCheckboxlist"
                    RepeatColumns="5" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
            </div>
        </div>
        <div id="divsearch" class="POuter_Box_Inventory" runat="server" style="width: 99.6%;">
            <div style="text-align: center;">
                <div class="content" style="text-align: center;">
                    <asp:Button ID="Button1" runat="server" class="searchbutton" Text="Search" OnClick="btnonscreen_Click" Font-Bold="true" />
                    <asp:Button ID="btnExport" class="searchbutton" OnClick="btnExport_Click" runat="server" Text="Export To Excel" Font-Bold="true" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <table style="width: 100%">
                <tr>
                    <td>
                        <div style="width: 99.6%; height: 420px; overflow: scroll;">
                            <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True" ShowFooter="true">
                                <FooterStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            </asp:GridView>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>


</asp:Content>
