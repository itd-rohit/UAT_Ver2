<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InfectionControlReport.aspx.cs" Inherits="Design_Lab_InfectionControlReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script src="../../scripts/jquery.multiple.select.js" type="text/javascript"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script>
        jQuery(function () {
            jQuery('[id*=<%=chkinv.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, setSelects: true

            });
            jQuery('[id*=<%=lstCentre.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, setSelects: true
            });

        });
    </script>
    <style type="text/css">
    .multiselect {
        width: 100%;
    }
</style> 
    <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1304px">
        <div class="POuter_Box_Inventory" style="width: 1300px">
            <div class="content" style="text-align: center;">
                <strong>Infection Control Report</strong>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px">
            <div class="Purchaseheader">
                Search Critiria
            </div>
            <div class="content">
                <table width="99%">
                    <tr>

                        <td>From Date :
                           <asp:TextBox ID="dtFrom" runat="server" Width="80px"></asp:TextBox>

                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                TargetControlID="dtFrom"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="dtFrom" />

                            To Date :
                            <asp:TextBox ID="dtToDate" runat="server" Width="80px"></asp:TextBox>

                            <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                TargetControlID="dtToDate"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="dtToDate" />
                            &nbsp;&nbsp;
    Centre :  
                            <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="350px" runat="server" ></asp:ListBox>

                            Investigation :
                            <asp:ListBox ID="chkinv" runat="server" Width="350px" SelectionMode="Multiple"></asp:ListBox>
                            &nbsp;&nbsp; 

                              
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px">

            <div class="content" style="text-align: center; width: 1300px">
                Report Type : 
                <select runat="server" id="rdreporttype">
                    <option value="0">PDF</option>
                    <option value="1">Excel</option>
                    <option value="2">Excel-2(Sample Date)</option>
                     <option value="4">Excel-3(Reg. Date)</option>
					 <option value="5">Excel-4(Approved Date)</option>
                    <option value="3">Excel-ALL</option>
                </select>
                <%-- <asp:RadioButtonList ID="rdreporttype" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                                 <asp:ListItem Value="0" Selected="True">PDF</asp:ListItem>
                                 <asp:ListItem Value="1">Excel</asp:ListItem>
                             </asp:RadioButtonList> --%>
                <asp:CheckBox ID="ch" runat="server" Text="Positive Only" Style="font-weight: 700" Checked="true" />
                <asp:Button ID="btngetreport" CssClass="searchbutton" Width="150px" runat="server" Text="Search" OnClick="btngetreport_Click" />
            </div>
        </div>
</asp:Content>
