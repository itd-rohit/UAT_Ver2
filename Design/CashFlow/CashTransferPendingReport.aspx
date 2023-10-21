<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CashTransferPendingReport.aspx.cs" Inherits="Design_CashFlow_CashTransferPendingReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
     <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style=" text-align: center;">

            <b>Cash InHand Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Option
             
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right">
                        <b>Receive Cash From :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="bindSearchType('0')">
                            <asp:ListItem Text="User" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Field Boy" Value="2"></asp:ListItem>
                            <asp:ListItem Text="Bank" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr>
                     <td style="width: 20%; text-align: right"><b>Centre :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:ListBox ID="lstCenterList" CssClass="multiselect" SelectionMode="Multiple" Width="340px" runat="server" ClientIDMode="Static" onchange="bindSearchType(0)"></asp:ListBox>
                    </td>
                    <td style="width: 20%; text-align: right"><b>Employee :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:ListBox ID="lstEmployee" CssClass="multiselect" SelectionMode="Multiple" Width="360px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" style=" text-align: center">
            <input type="button" class="searchbutton" id="btnSearch" value="Search" onclick="SearchReport()" />
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
                jQuery('[id*=lstCenterList],[id*=lstEmployee]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            bindCentre();
        });
        function bindCentre() {            
            jQuery("#lstCenterList option").remove();
            jQuery("#lstCenterList").multipleSelect('refresh');
            PageMethods.bindCentre(onSucessCentre,onFailureCentre);
        }
        function onSucessCentre(result) {
            var CentreData = jQuery.parseJSON(result);
            for (i = 0; i < CentreData.length; i++) {
                jQuery('#<%=lstCenterList.ClientID%>').append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
            }
            jQuery('#<%=lstCenterList.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function onFailureCentre(result) {

        }           
        function onSucessSearchType(result, con) {
            jQuery("#lstEmployee option").remove();
            jQuery("#lstEmployee").multipleSelect('refresh');
            var empData = jQuery.parseJSON(result);      
            if (empData != null) {              
                for (var a = 0; a <= empData.length - 1; a++) {
                    jQuery('#lstEmployee').append(jQuery("<option></option>").val(empData[a].ID).html(empData[a].Name));
                }
            }
            jQuery('#<%=lstEmployee.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });         
        }    
        function bindSearchType(con) {
            var CentreID = jQuery("#lstCenterList").val();
            if (CentreID != "")
                PageMethods.bindSearchType(jQuery('#rblSearchType input[type=radio]:checked').val(), CentreID, onSucessSearchType, onFailureSearch, con);
            else {
                jQuery("#lstEmployee option").remove();
                jQuery("#lstEmployee").multipleSelect('refresh');
            }         
        }            
        function onFailureSearch(result) {
            jQuery.unblockUI();
        }
        function SearchReport() {
            var EmployeeID = jQuery("#lstEmployee").val();
            if (EmployeeID != "") {
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

                PageMethods.bindSearchReport(jQuery('#rblSearchType input[type=radio]:checked').val(),EmployeeID, onSucessReport, onFailureSearch);
            }
            else {

            }
        }
        function onSucessReport(result) {
            if (result == 1)
                window.open('../common/ExportToExcel.aspx');
            else
                jQuery("#lblMsg").text("No Record Found");
 jQuery.unblockUI();
        }
    </script>
</asp:Content>

