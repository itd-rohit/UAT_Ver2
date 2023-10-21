<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionReport.aspx.cs" Inherits="Design_Lab_HomeCollectionReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory" style="width: 1304px">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px">

            <b>Home Collection Report</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:HiddenField ID="hdnCentreId" runat="server" />
            <asp:HiddenField ID="hdnFieldBoyId" runat="server" />


        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px">
            <div class="Purchaseheader">
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 20%; text-align: right; font-weight: bold">From Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 20%">
                        <asp:TextBox ID="txtfromdate" runat="server" Width="100px" />
                        <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                            TargetControlID="txtfromdate"
                            Format="dd-MMM-yyyy"
                            PopupButtonID="txtfromdate" />

                    </td>

                    <td style="width: 20%; text-align: right; font-weight: bold">To Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 40%">
                        <asp:TextBox ID="txttodate" runat="server" Width="100px" />
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
                            TargetControlID="txttodate"
                            Format="dd-MMM-yyyy"
                            PopupButtonID="txttodate" />

                    </td>
                </tr>

                <tr>
                    <td style="width: 20%; text-align: right; font-weight: bold">Centre :&nbsp;</td>
                    <td style="text-align: left; width: 20%">
                        <asp:ListBox ID="ddlcentre" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="360px"></asp:ListBox>

                        <td style="width: 20% ;text-align: right;"><strong>Field Boy ::&nbsp;</strong></td>
                        <td style="text-align: left; width: 40%"> <asp:ListBox ID="ddlFieldBoy" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="360px"></asp:ListBox></td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center; width: 100%">&nbsp;


                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">

            <asp:Button ID="btnExport" OnClientClick="GetData();" OnClick="btnExport_Click" runat="server" Text="Export To Excel" CssClass="searchbutton"  />
        </div>
    </div>
    <script type="text/javascript">
        
        function GetData()
        {
            $('[id$=hdnFieldBoyId]').val($('[id$=ddlFieldBoy]').val().toString());
            $('[id$=hdnCentreId]').val($('[id$=ddlcentre]').val().toString());

        }
       
        jQuery(function () {

            jQuery('.multiselect').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
          
        });
       
    </script>
</asp:Content>

