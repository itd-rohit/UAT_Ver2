<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LedgerReportforFranchisee.aspx.cs" Inherits="Design_Invoice_LedgerReportforFranchisee" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>
    <link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css" />
    <script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../JavaScript/fancybox/jquery.easing-1.3.pack.js"></script>
    <script type="text/javascript" src="../../JavaScript/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../JavaScript/fancybox/jquery.fancybox-1.3.4.js"></script>
    <script type="text/javascript" src="../../JavaScript/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <link href="../../JavaScript/fancybox/jquery.fancybox-1.3.4.css" rel="stylesheet" type="text/css" />
   
    . 
    <style type="text/css">
        .multiselect {
            width: 100%;
            text-align: left;
        }

        .ajax__calendar .ajax__calendar_container {
            z-index: 9999;
        }
    </style>
    <style>
        .mytextbox {
            padding: 5px 12px;
            margin: 8px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .auto-style1 {
            font-weight: bold;
            text-align: right;
        }

        .savebutton {
            cursor: pointer;
            background-color: lightgreen;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .resetbutton {
            cursor: pointer;
            background-color: lightcoral;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .searchbutton {
            cursor: pointer;
            background-color: blue;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .PrintButton {
            cursor: pointer;
            background-color: #00FFFF;
            font-weight: bold;
            color: black;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }
    </style>
    <style type="text/css">
        /*thead.fixedHeader tr {
	position: relative
}*/


        html > body thead.fixedHeader tr {
            display: block;
        }

        /* make the TH elements pretty */
        thead. th {
            background: #0880cf;
            font-weight: normal;
            padding: 4px 3px;
            text-align: center;
        }

        html > body tbody.scrollContent {
            display: block;
            height: 440px;
            overflow-y: auto;
            overflow-x: hidden;
        }

        html > body tbody.scrollContentChild {
            display: block;
            height: 220px;
            overflow-y: auto;
            overflow-x: hidden;
        }



        tbody.scrollContent td, tbody.scrollContent tr.normalRow td {
            border-bottom: none;
            border-left: none;
            padding: 4px 3px;
        }

        tbody.scrollContent tr.alternateRow td {
            background: #EEE;
            border-bottom: none;
            border-left: none;
            padding: 4px 3px;
        }

        html > body thead. th {
            max-width: 150px;
            min-width: 150px;
        }

        html > body tbody.scrollContent td {
            max-width: 150px;
            min-width: 150px;
        }
    </style>
    <script type="text/javascript">
        function SelectAllCentres() {
            var chkBoxList = document.getElementById('<%=chklstCenter.ClientID %>');
          var chkBoxCount = chkBoxList.getElementsByTagName("input");
          for (var i = 0; i < chkBoxCount.length; i++) {
              chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
               }
           }

    </script>


    <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=<%=lstbusinessunit.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

         });
    </script>
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
             <Services>
            <Ajax:ServiceReference Path="~/Lis.asmx" />
        </Services>
        </Ajax:ScriptManager>
        <div class="Pbody_box_inventory" style="text-align: center;">
            <strong>Ledger Statement<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" Text="" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Unit</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstbusinessunit" CssClass="multiselect" SelectionMode="Multiple" Width="220px" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Payment Mode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPaymentMode" runat="server" Width="146px" AutoPostBack="true" OnSelectedIndexChanged="ddlPaymentype_SelectedIndexChanged" ClientIDMode="Static" CssClass="ddlPaymentMode chosen-select">
                     <asp:ListItem Value="All">All</asp:ListItem>
                     <asp:ListItem Value="Credit">Credit</asp:ListItem>
                     <asp:ListItem Value="RulingAdvance">Rolling Advance</asp:ListItem>
                     <asp:ListItem Value="Cash">Cash</asp:ListItem>
                 </asp:DropDownList>
                </div>
                </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%; display: none;">
            <asp:CheckBox ID="chkSampleColl" runat="server" Text="Show Sample Collected Only" Checked="true" />
            <asp:CheckBox ID="chkOnlyDue" Style="display: none;" runat="server" Text="Show Business Panel Only" />
            <asp:CheckBox ID="chkOnlyDiscount" runat="server" Style="display: none;" Text="Only Discount Patient" />
        </div>
          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Panels" onclick="SelectAllCentres()" CssClass="ItDoseCheckbox" />
            </div>
            <div class="row">
            <div class="content" style="overflow: scroll; height: 266px;">
                
                            <asp:CheckBoxList ID="chklstCenter" RepeatColumns="4" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                   
            </div>
                </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%; display: none;">
            <div class="Purchaseheader">
                ZSM
            </div>
            <div class="content">
                <table>
                    <tr>

                        <td style="width: 99.6%">
                            <asp:CheckBoxList ID="chkZSM" runat="server" RepeatDirection="Horizontal" CssClass="case"
                                RepeatColumns="4">
                            </asp:CheckBoxList></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%; display: none;">
            <div class="Purchaseheader">
                ASM
            </div>
            <div class="content">
                <table>
                    <tr>

                        <td style="width: 700px">
                            <asp:CheckBoxList ID="chkASM" runat="server" RepeatDirection="Horizontal" CssClass="case"
                                RepeatColumns="4">
                            </asp:CheckBoxList></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="content" style="text-align: center;">
                Date : <asp:TextBox ID="txtDate" runat="server" style="width:80px;"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtDate" PopupButtonID="txtDate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                <asp:Button ID="btnSearch" runat="server" CssClass="searchbutton" Width="60px" Text="Search"
                    OnClick="btnSearch_Click" />
            </div>
        </div>
    </div>
   

</asp:Content>



