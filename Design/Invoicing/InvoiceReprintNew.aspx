<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InvoiceReprintNew.aspx.cs" Inherits="Design_Master_InvoiceReprintNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

 <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 <%: Scripts.Render("~/bundles/Chosen") %>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
    <script type="text/javascript">
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
            jQuery("#ddlBusinessZone").trigger('chosen:updated');
        });
    </script>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <asp:TextBox ID="lblInvoiceNo" runat="server" Style="display: none" />

        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <b>Invoice Reprint</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <table style="width: 100%; border-collapse: collapse; text-align: center">
                <tr style="text-align: center">
                    <td style="width: 44%">&nbsp;
                    </td>
                    <td colspan="4" style="width: 26%; text-align: left">
                        <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="clearControl()">
                            <asp:ListItem Text="PCC" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="PUP" Value="2"></asp:ListItem>
                            <asp:ListItem Text="HLM" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 30%">&nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right">From Date :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtFromInvoiceDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calFromInvoiceDate" TargetControlID="txtFromInvoiceDate" Format="dd-MMM-yyyy" />
                    </td>
                    <td style="text-align: right">To Date :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtToInvoiceDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calToInvoiceDate" TargetControlID="txtToInvoiceDate" Format="dd-MMM-yyyy" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Invoice No. :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtInvoiceNo" runat="server"></asp:TextBox>
                    </td>
                    <td style="text-align: right;">&nbsp;</td>
                    <td>&nbsp;
                        
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Business Zone :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" Width="180px" class="ddlBusinessZone chosen-select">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right;">State :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlState" runat="server" onchange="bindCity()" Width="180px" class="ddlState chosen-select">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">City :&nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlCity" runat="server" onchange="bindPanel()" Width="180px" class="ddlCity chosen-select">
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right;">Client :&nbsp;</td>
                    <td>
                        <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="320px"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="searchInvoice()" />
                        &nbsp;&nbsp;<input id="btnPrint" onclick="ReportPrint();" type="button" value="Print" class="searchbutton" style="display: none" />

                        &nbsp;&nbsp;<input id="btnCancel" type="button" value="Cancel" class="searchbutton"  onclick="clearControl()" />
                        &nbsp;&nbsp;<input id="btnReport" type="button" value="Report" class="searchbutton" style=" display: none" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Search Result             
            </div>
            <div id="div_Data" style="max-height: 350px; overflow: auto;">
            </div>
            <table class="GridViewStyle" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse: collapse; width: 960px; display: none;">
                <tr id="Header">
                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Invoice No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 220px;">Client Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Invoice Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Created By</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Share Amt.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none;">EmailInvoice </th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Select</th>
                </tr>
            </table>
        </div>
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            Width="500px">
            <div class="Purchaseheader">
                Email Invoice
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right">Email Address :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtemail" runat="server" Width="300px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:RadioButtonList ID="rdoReport1" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Selected="True">Summary</asp:ListItem>
                            <asp:ListItem Value="2">Invoice Item Wise</asp:ListItem>
                            <asp:ListItem Value="3">Detail</asp:ListItem>
                            <asp:ListItem Value="5">Invoice Receipt</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">&nbsp;
                                    <asp:Button ID="Button3" runat="server" CssClass="searchbutton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Button ID="Button4" runat="server" Style="display: none;" />
        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="Button3" DropShadow="true" PopupControlID="Panel1"
            TargetControlID="btnHide" BehaviorID="ModalPopupExtender1">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlReport" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            Width="500px">
            <div id="Div2" class="Purchaseheader" runat="server">
                Report

            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right">Report Type :
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rdoReport" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Selected="True">Summary</asp:ListItem>
                            <asp:ListItem Value="2">Invoice Item Wise</asp:ListItem>
                            <asp:ListItem Value="3">Detail (Patient Wise)</asp:ListItem>
                            <asp:ListItem Value="5">Invoice Receipt</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <input type="button" onclick="ReportOpen();" value="Report" class="searchbutton" id="Button1" title="Click To Save" />
                        &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="searchbutton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Button ID="btnHide" runat="server" Style="display: none;" />
        <cc1:ModalPopupExtender ID="mpreport" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlReport"
            TargetControlID="btnHide" BehaviorID="mpreport">
        </cc1:ModalPopupExtender>
    </div>
    <script type="text/javascript">
        function bindState() {
            jQuery("#lblMsg").text('');
            jQuery("#ddlState option").remove();
            jQuery("#ddlCity option").remove();
            jQuery('#ddlCity,#ddlState').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (jQuery("#ddlState").val() != 0)
                CommonServices.bindState(jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);
            
            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlState').trigger('chosen:updated');

        }
        function onFailureState() {

        }
        function bindCity() {
            jQuery("#ddlCity option").remove();
            jQuery('#ddlCity').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (jQuery("#ddlCity").val() == 0) {
                showerrormsg('Please Select City');
                jQuery("#ddlCity").focus();
                return;
            }
            if (jQuery("#ddlState").val() == -1)
                CommonServices.bindCityFromBusinessZone(jQuery("#ddlState").val(), jQuery("#ddlBusinessZone").val(), onSucessCity, onFailureCity);
            else
                CommonServices.bindCity(jQuery("#ddlState").val(), onSucessCity, onFailureCity);
        }
        function onSucessCity(result) {
            var cityData = jQuery.parseJSON(result);
            if (cityData.length == 0) {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("Select"));
                if (cityData.length > 0) {
                    jQuery("#ddlCity").append(jQuery("<option></option>").val("-1").html("All"));

                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                    }
                    jQuery('#ddlCity').trigger('chosen:updated');
                }
            }
        }
        function onFailureCity() {

        }
        function bindPanel() {
            if (jQuery("#ddlCity").val() == 0) {
                jQuery('#<%=lstPanel.ClientID%> option').remove();
                  jQuery('#lstPanel').multipleSelect("refresh");
              }
              else
                Panel_Invoice.bindPanel(jQuery("#ddlBusinessZone").val(), jQuery("#ddlState").val(), jQuery("#ddlCity").val(), jQuery("#rblSearchType input[type=radio]:checked").val(), "","", onSuccessPanel, OnfailurePanel);
          }
          function onSuccessPanel(result) {
              var panelData = jQuery.parseJSON(result);
              if (panelData.length == 0) {
                  jQuery("#lstPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
              }

              if (panelData.length > 0) {
                  for (i = 0; i < panelData.length; i++) {
                      jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
            else {
                jQuery('#<%=lstPanel.ClientID%> option').remove();
                jQuery('#lstPanel').multipleSelect("refresh");
            }

        }
        function OnfailurePanel() {

        }
    </script>
    <script type="text/javascript">

        jQuery(function () {
            jQuery('[id*=lstPanel]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#btnReport").click(Report);
        });
        var sss = "";
        function searchInvoice() {
            jQuery("#lblMsg").text('');
            var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            if (jQuery.trim(jQuery("#<%=txtInvoiceNo.ClientID %>").val()) == "" && PanelID == "") {
                jQuery("#lblMsg").text('Please Select Client');
                return;
            }
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var aas = 1;
            var snoc = 1;

            jQuery.ajax({
                url: "InvoiceReprintNew.aspx/SearchStatus",
                data: '{fromInvoiceDate:"' + jQuery("#<%=txtFromInvoiceDate.ClientID %>").val() + '",toInvoiceDate:"' + jQuery("#<%=txtToInvoiceDate.ClientID %>").val() + '",PanelID: "' + PanelID + '",InvoiceNo:"' + jQuery("#<%=txtInvoiceNo.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var Result = jQuery.parseJSON(result.d);
                    jQuery('#tb_grdLabSearch tr:not(#Header)').remove();
                    if (Result == null) {
                        jQuery('#tb_grdLabSearch,#btnPrint').hide();
                        jQuery('#btnSearch').show();
                        jQuery("#lblMsg").text('No Record Found');
                        return;
                    }
                    else {
                        jQuery.each(Result, function (index, item) {
                            jQuery('#tb_grdLabSearch').show();
                            sss = aas++;
                            var sn = snoc++;
                            jQuery('#tb_grdLabSearch').append('<tr id="' + item.InvoiceNo + '" "><td class="GridViewLabItemStyle">' + sss + '</td><td id="tdInvoiceNo"  class="GridViewLabItemStyle">' + item.InvoiceNo + '</td><td id="PanelName"  class="GridViewLabItemStyle" style="width:200px">' + item.PanelName + '</td><td id="tdDate"  class="GridViewLabItemStyle" style="text-align:center">' + item.DATE + '</td><td id="InvName"  class="GridViewLabItemStyle" style="width:200px">' + item.InvoiceCreatedBy + '</td><td id="tdShareAmt"  class="GridViewLabItemStyle" style="width:100px;text-align:right">' + item.ShareAmt + '</td><td id="tdInvoiceType" class="GridViewLabItemStyle" style="width:20px;display:none"> ' + item.InvoiceType + '</td><td class="GridViewLabItemStyle" style="width:20px"><input id="chk" type="checkbox" class="" value="1"/></td></tr>');
                        });
                        jQuery('#btnSearch,#btnPrint').show();
                    }

                    jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    jQuery.unblockUI();
                }
            });
        };
    </script>
    <script type="text/javascript">
        function Report() {
            jQuery("#tb_grdLabSearch tr").find("#chk").filter(':checked').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                var $rowid = jQuery(this).closest("tr");
                var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
                window.open('InvoiceReport.aspx?PanelID=' + PanelID + '&InvoiceNo=' + id + '&ReportType=' + jQuery("input:radio[.rad]:checked").val());
            });
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#tb_grdLabSearch :text").hide();
        });
        var InvoiceConcat = "";
        function ckhall() {
            if (jQuery("#chkheader").is(':checked'))
                jQuery("#tb_grdLabSearch :checkbox").prop('checked', 'checked');
            else
                jQuery("#tb_grdLabSearch :checkbox").prop('checked', false);
        }
        function ReportOpen() {
            var Type = jQuery("#<%=rdoReport.ClientID %> input[type=radio]:checked").val();
        }
        function ReportPopUp(rowID) {
            $find('mpreport').show();
            jQuery("#<%=lblInvoiceNo.ClientID%>").val(jQuery(rowID).closest('tr').find('#tdInvoiceNo').text());
        }
        function ReportPrint() {
            var rowid = "";
            jQuery("#lblMsg").text('');
            jQuery("#tb_grdLabSearch tr").find("#chk").filter(':checked').each(function () {
                rowid += jQuery(this).closest('tr').attr('id') + ',';
               
            });
            if (rowid != "")
                window.open('InvoiceReceipt.aspx?InvoiceNo=' + rowid);

               
            else
                jQuery("#lblMsg").text('Please Select Invoice');

        }
        function tablefunc() {
            jQuery("#chkAll").click(function () {
                jQuery("#tb_grdLabSearch tr").find("#chk").prop("checked", jQuery(this).attr("checked"));

            });
        }
    </script>
    <script type="text/javascript">
        function clearControl() {
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
            jQuery('#ddlState,#ddlCity').empty();
            jQuery('#ddlState,#ddlCity').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            jQuery('#tb_grdLabSearch tr:not(#Header)').remove();
            jQuery('#tb_grdLabSearch,#btnPrint').hide();
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
</asp:Content>
