<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Package_Inclusion_Report.aspx.cs" Inherits="Design_Lab_Package_Inclusion_Report" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
     <%: Scripts.Render("~/bundles/PostReportScript") %>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
    .multiselect {
        width: 100%;
    }
    .ms-parent .multiselect {
    width:40%;
    }
</style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Package Inclusion Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="text-align: left;width: 100%;">
                <tr>
                    <td>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <b>Package Name :</b>&nbsp;

 <asp:ListBox ID="lstPackage" CssClass="multiselect" SelectionMode="Multiple" Width="50%" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                </tr>
           
            </table>



        </div>    
        <div class="POuter_Box_Inventory" style="text-align: center">


            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>

    </div>
    <script type="text/javascript">
        function getReport() { 
            var PackageID = $('[id$=lstPackage]').val().toString();
            $.ajax({
                url: "Package_Inclusion_Report.aspx/getReport",
                async: false,
                data: '{PackageID:"' + PackageID + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $('[id$=lblMsg]').text("");
                        window.open('../Common/ExportToExcel.aspx');
                    }
                    else {
                        $('[id$=lblMsg]').text("No Record Found");
                    }
                }
            });
        }
       
       
        function bindPackage() {
            PageMethods.bindPackage(onSuccess, Onfailure);
        }
        function onSuccess(result) {            
            PackageData = jQuery.parseJSON(result);
            for (i = 0; i < PackageData.length; i++) {
                jQuery("#lstPackage").append(jQuery("<option></option>").val(PackageData[i].PlabID).html(PackageData[i].NAME));
            }
            jQuery('[id*=lstPackage]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function Onfailure() {
            alert('Error Occured....!');
        }
       
        $(function () {
	    bindPackage();
	    $('.ms-parent multiselect').css('width', '195px;');
            $('[id*=lstPackage]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            
        });
    </script>
</asp:Content>

