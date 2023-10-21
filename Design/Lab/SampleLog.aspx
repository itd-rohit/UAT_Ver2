<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="SampleLog.aspx.cs"  EnableEventValidation="false" Inherits="Design_Lab_SampleLog" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <style>
      .GridViewHeaderStyle {
    border: solid 0px #C6DFF9;
    font-weight: 100;
    color: #000;
    font-size: 8.5pt;
    background-image: url(../App_Images/headerBg.gif);
    background-repeat: repeat-x;
}
        #grdData th {
        background-color:#09f;
        color:#fff;
        }
         #grdData td {
        background-color:#fff;
        color:#000;
        padding:15px;
        }
    </style>
    <div id="Pbody_box_inventory" style="width: 704px;">

        <div class="POuter_Box_Inventory" style="width: 700px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Patient Lab Report Log </b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 700px; text-align: center;">
            <table width="100%">
                <tr>
                    <td style="text-align: right; width: 20%;"><strong>Patient Name : </strong></td>
                    <td style="text-align: left; width: 20%;">
                        <asp:Label ID="lblName" runat="server" Text="Patient Name"></asp:Label>
                    </td>
                    <td style="text-align: right; width: 20%;"><strong>Gender : </strong>

                    </td>
                    <td style="text-align: left; width: 40%;">
                        <asp:Label ID="lblGender" runat="server" Text="Gender"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%;"><strong>Age : </strong></td>
                    <td style="text-align: left; width: 20%;">
                        <asp:Label ID="lblAge" runat="server" Text="Age"></asp:Label>

                    </td>
                    <td style="text-align: right; width: 20%;"><strong>Mobile : </strong></td>
                    <td style="text-align: left; width: 40%;">
                        <asp:Label ID="lblMobile" runat="server" Text="Mobile"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%"><strong>Centre : </strong></td>
                    <td style="text-align: left; width: 20%">
                        <asp:Label ID="lblCentre" runat="server" Text="Centre"></asp:Label>

                    </td>
                    <td style="text-align: right; width: 20%"><strong>Panel : </strong></td>
                    <td style="text-align: left; width: 40%">
                        <asp:Label ID="lblPanel" runat="server" Text="Panel"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%"><strong>Investigation : </strong></td>
                    <td style="text-align: left; " colspan="3">
                        <asp:Label ID="lblTest" runat="server" Text="Centre"></asp:Label>

                    </td>
                    
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 700px;">
            <div class="Purchaseheader">Report Log</div>
            <asp:GridView ID="grdData" runat="server" AutoGenerateColumns="false" class="GridView" style="width:100%">
                <Columns>
                    <asp:TemplateField HeaderText="SNo.">
                        <ItemTemplate>
                            <asp:Label ID="lblRowNumber" Text='<%# Container.DataItemIndex + 1 %>' runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Approved Date">
                        <ItemTemplate>
                            <asp:Label ID="lblDate" Text='<%#Eval("Date")%>' runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Approved By">
                        <ItemTemplate>
                            <asp:Label ID="lblApprovedBy" Text='<%#Eval("ApprovedName")%>' runat="server" />

                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Visit No">
                        <ItemTemplate>
                            <asp:Label ID="lblVisitNo" Text='<%#Eval("LedgertransactionNo")%>' runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Barcode">
                        <ItemTemplate>
                            <asp:Label ID="lblBarcode" Text='<%#Eval("BarcodeNo")%>' runat="server" />

                        </ItemTemplate>
                    </asp:TemplateField>
                   
                    <asp:TemplateField HeaderText="View">
                        <ItemTemplate>
                            <asp:HiddenField ID="hdnPROID" runat="server" Value='<%#Eval("PLOID")%>' />
                            <asp:Button ID="btnView" runat="server" OnClientClick="return ViewReport(this);" Text="View Report" />
                            <asp:HiddenField ID="hdnTestId" runat="server" Value='<%#Eval("Test_Id")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>

    </div>
    <script>
        function ViewReport(ctrl) {
            var PLOID = $(ctrl).prev().val();
            var Test_Id=$(ctrl).next().val()+",";
            window.open("labreportnotapprove.aspx?IsPrev=1&PHead=1&PLOID="+PLOID+"&TestId=" + Test_Id);
            return false;
        }
    </script>
</asp:Content>
