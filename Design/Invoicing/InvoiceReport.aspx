<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="InvoiceReport.aspx.cs" Inherits="Reports_Forms_InvoiceReport" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--<script type="text/javascript" src="../../JavaScript/jquery-1.3.2.min.js"></script>--%>

    <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
    <style type="text/css">
        .ajax__calendar_container {
            z-index: 9999;
        }

        #ctl00_ContentPlaceHolder1_gdvLedgerReport td, #ctl00_ContentPlaceHolder1_gdvLedgerReport th {
            padding: 6px;
        }
        .ItDoseLblError1 {
        color: red;
        font-size: 17pt;
        font-family: Verdana, Arial, sans-serif, sans-serif;
        font-weight: bold;
        z-index: 9;
        position: fixed;
        background-color: white;
        left: 297px;
        border: 2px solid black;
        border-radius: 4px;
        top: 106px;
}
        
    </style>
    <%--chosen--%>
    <link href="../../combo-select-master/docsupport/prism.css" rel="stylesheet" />
    <link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css" />
    <script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>
    <script src="../../combo-select-master/docsupport/prism.js" type="text/javascript"></script>
    <%--end chosen--%>
    <script type="text/javascript">
        $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
    </script>
    <div id="Pbody_box_inventory"  >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Ledger Transaction</b>
                <br />
                <div style="float: right; clear: both;" id="div_pcount"></div>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
         <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="dtFrom" runat="server" AutoPostBack="false"></asp:TextBox>
                            
                </div>
                <div class="col-md-2">
                    <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtFrom" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="dtTo" runat="server" AutoPostBack="false"></asp:TextBox>
                            
                </div>
                <div class="col-md-2">
                    <asp:Image ID="imgdtTo" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                            <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtTo" Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtTo" />
                            <asp:CheckBox ID="chkSampleReceive" runat="server" Text="Sample Lab Receive Only" style="display:none;"/>
                </div>
            </div>
             <div class="row">
                  <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Client</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                        <asp:DropDownList ID="ddl_panel" runat="server" CssClass="chosen-select chosen-container"></asp:DropDownList>
             </div>
             </div>
             </div>
         <div  class="POuter_Box_Inventory" >
             <div class="row">
                 <div class="col-md-8"></div>
                 <div class="col-md-6">
             <asp:Button ID="Button1" Text="Search" runat="server" OnClick="Btn_Ledger_Search" CssClass="searchbutton" style="width:100px;"/>
                        <asp:Button ID="btn_Search" Text="Print" runat="server" OnClick="btn_Search_Click" CssClass="PrintButton" style="width:100px;"/>
                      <asp:CheckBox ID="chkprintheader" runat="server" Text="Print Header" />
                </div></div>
         </div>
         <div class="POuter_Box_Inventory" >
             <div style="text-align: center;">
                <div class="Purchaseheader" >
                   Search Result 
                     <asp:Label ID="lblTotal" runat="server" Text="" Style="padding: 5px; background-color: #A7E791; font-weight: bold;"></asp:Label>
                </div>
                <div id="tb_Search">
                </div>
            </div>
            <asp:Table ID="gdvLedgerReport2" Width="100%" AutoGenerateColumns="false" runat="server" CellPadding="10" GridLines="horizontal" HorizontalAlign="Center">

                <asp:TableRow>

                    <asp:TableCell>Client ‎</asp:TableCell>

                    <asp:TableCell>
                        <asp:Label runat="server" ID="lblpccName"></asp:Label>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow>

                    <asp:TableCell>CLOSING BALANCE‎</asp:TableCell>

                    <asp:TableCell>
                        <asp:Label runat="server" ID="lblClosing"></asp:Label>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow>

                    <asp:TableCell>SECURITY AMOUNT‎‎</asp:TableCell>

                    <asp:TableCell>
                        <asp:Label runat="server" ID="lblsecurityAmount"></asp:Label>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow>

                    <asp:TableCell>TESTING CHARGES AFTER LAST CREDIT BILL‎</asp:TableCell>

                    <asp:TableCell>
                        <asp:Label runat="server" ID="lblTestingbill"></asp:Label>
                    </asp:TableCell>

                </asp:TableRow>

                <asp:TableRow Font-Bold="true">

                    <asp:TableCell>NET PAYABLE‎‎</asp:TableCell>

                    <asp:TableCell>
                        <asp:Label runat="server" ID="lblnetPay"></asp:Label>
                    </asp:TableCell>
                    
                </asp:TableRow>
            </asp:Table>
            <asp:GridView Width="100%" AutoGenerateColumns="false" runat="server" ShowFooter="true" OnRowDataBound="gdvLedgerReport_RowDataBound" ID="gdvLedgerReport" CellSpacing="0" rules="all" border="1">
                <Columns>
                    <asp:BoundField HeaderText="Bill Date" DataField="BillDate" />
                    <asp:BoundField HeaderText="Invoice No" DataField="invoiceno" />
                    <asp:BoundField HeaderText="Particulars" DataField="period" />
                    <asp:BoundField HeaderText="Debit Amount" DataField="debit" />
                    <asp:BoundField HeaderText="Credit Amount" DataField="credit" />
                    <asp:BoundField HeaderText=""  />
                </Columns>
            </asp:GridView>
            <asp:Table ID="Table1" Width="100%" AutoGenerateColumns="false" runat="server" CellPadding="10" GridLines="horizontal" HorizontalAlign="Center">

 
                <asp:TableRow>
                    <asp:TableCell>‎</asp:TableCell>
                    <asp:TableCell></asp:TableCell>
                    <asp:TableCell></asp:TableCell>
                    <asp:TableCell>Closing Amount ‎:‎
                        <asp:Label runat="server" style="margin-right: -200px;" ID="lblClosingamount">   </asp:Label></asp:TableCell>
                </asp:TableRow>

            </asp:Table>
        </div>
    </div>
</asp:Content>
