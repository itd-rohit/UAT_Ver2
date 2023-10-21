<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreApprovalRightMatrix.aspx.cs" Inherits="Design_Store_StoreApprovalRightMatrix" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory" style="width: 1304px;">
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">

            <strong>Store Approval Right Matrix<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">

            <a onclick="exportReport()" class="searchbutton" id="btnexportReport">Report
                  <img src="../../App_Images/xls.png" width="22" style="cursor: pointer; text-align: center" /></a>
        </div>
    </div>
    <script type="text/javascript">
        function exportReport() {
            jQuery('#lblMsg').text('');
            PageMethods.exportToExcel(onsucessExportReport, onFailureSearchApproval);
        }
        function onsucessExportReport(result) {
            if (result == "0") {
                jQuery('#lblMsg').text('No Record Found');
            }
            else if (result == "1") {
                window.open('../common/ExportToExcel.aspx');

            }
        }
        function onFailureSearchApproval() {

        }

    </script>
</asp:Content>

