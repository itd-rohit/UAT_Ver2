<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PODAccept.aspx.cs" Inherits="Design_Store_PODAccept" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>POD Acceptance</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">POD Number   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtpodnumber" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" Width="160px" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtentrydateto" runat="server" Width="160px" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
            </div>
            <div class="row" style="margin-top: 18px">
                <div class="col-md-16" style="text-align: right">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata('NEW')" />
                </div>
                <div class="col-md-8">
                    <div class="col-md-6">
                        <span onclick="searchdata('NEW')" style="width: 15px; cursor: pointer; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;NEW
                    </div>
                    <div class="col-md-6">
                        <span onclick="searchdata('Accept')" style="width: 15px; cursor: pointer; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</span><a>&nbsp;Accept</a>
                    </div>
                    <div class="col-md-6">
                        <span onclick="searchdata('Reject')" style="width: 15px; cursor: pointer; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">&nbsp;&nbsp;&nbsp;&nbsp;</span><a>&nbsp;Reject</a>
                    </div>
                    <div class="col-md-6">
                        <span onclick="searchdata('Partial')" style="width: 15px; cursor: pointer; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #edc787;">&nbsp;&nbsp;&nbsp;&nbsp;</span><a>&nbsp;Partial</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                POD Detail
            </div>
            <div style="width: 99%; max-height: 375px; overflow: auto;">
                <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="triteheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">View Item</td>
                        <td class="GridViewHeaderStyle">POD No.</td>
                        <td class="GridViewHeaderStyle">Invoice No.</td>
                        <td class="GridViewHeaderStyle" id="trans_head" runat="server">Transfer From</td>
                        <td class="GridViewHeaderStyle">Location</td>
                        <td class="GridViewHeaderStyle">Gross Amt.</td>
                        <td class="GridViewHeaderStyle">Disc Amt.</td>
                        <td class="GridViewHeaderStyle">Tax Amt.</td>
                        <td class="GridViewHeaderStyle">Net Amt.</td>
                        <td class="GridViewHeaderStyle">Courier Name</td>
                        <td class="GridViewHeaderStyle">Consinment No.</td>
                        <td class="GridViewHeaderStyle">Corier Date</td>
                        <td class="GridViewHeaderStyle">Accept/Reject</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Print GRN </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="popup_box" style="background-color: lightgreen; height: 80px; text-align: center; width: 340px;">
            <div id="showpopupmsg" style="font-weight: bold;"></div>
            <br />
        </div>
    </div>
    <script type="text/javascript">
        var filename = "";
        function openmypopup(href) {
            var width = '1240px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }

        function unloadPopupBox() {    // TO Unload the Popupbox
            $('#GRNID').html('');
            $('#type').html('');
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });
        }
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
        function printme(ctrl) {
            window.open('GRNReceipt.aspx?GRNNO=' + ctrl); //+ $(ctrl).closest('tr').attr("id"));
        }
    </script>
    <script type="text/javascript">
        function searchdata(Type) {
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var podnumber = $('#<%=txtpodnumber.ClientID%>').val();
            podnumber = podnumber.trim();           
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PODAccept.aspx/SearchData', { fromdate: fromdate, todate: todate, podnumber: podnumber, Type: Type }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Record Found!", "");
                }
                else {
                    if (Type == 'NEW') {
                        $('#<%=trans_head.ClientID%>').html('Transfer From');
                    }
                    if (Type == 'Accept') {
                        $('#<%=trans_head.ClientID%>').html('Accept From');
                    }
                    if (Type == 'Reject') {
                        $('#<%=trans_head.ClientID%>').html('Reject From');
                    }
                    if (Type == 'Partial') {
                        $('#<%=trans_head.ClientID%>').html('Partial From');
                    }
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        ItemData[i].rowColor = (ItemData[i].paid > 0 & ItemData[i].unpaid > 0) ? '#edc787' : ItemData[i].rowColor;
                        var $myData = [];
                        $myData.push('<tr style="background-color:"'); $myData.push(ItemData[i].rowColor); $myData.push('"; id="'); $myData.push(ItemData[i].PODnumber); $myData.push('">');
                        $myData.push('<td class="GridViewLabItemStyle" id="showid" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        $myData.push('<td class="GridViewLabItemStyle" ><a href="#" onclick="showPodStatus(this)">'); $myData.push(ItemData[i].PODnumber); $myData.push('</a></td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].invoiceno); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].name); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].location); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(precise_round(ItemData[i].GrossAmount, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(precise_round(ItemData[i].DiscountOnTotal, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(precise_round(ItemData[i].TaxAmount, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(precise_round(ItemData[i].NetAmount, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].couriername); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].consinmentno); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].senddate); $myData.push('</td>');
                        if (ItemData[i].Type == "NEW") {
                            if (ItemData[i].Islast != "0") {
                                $myData.push('<td class="GridViewLabItemStyle" ><input type="button" value="Accept" id="accept" class="searchbutton" onclick="Transfer(\''); $myData.push(ItemData[i].PODnumber); $myData.push('\',\'Accept\')"/>  <input type="button" value="Reject" id="reject" class="resetbutton" onclick="TransferReject(\''); $myData.push(ItemData[i].PODnumber); $myData.push('\',\'Reject\')"/> </td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle" ><input type="button" value="Transfer" id="transfer" class="searchbutton" onclick="Transfer(\''); $myData.push(ItemData[i].PODnumber); $myData.push('\',\'Transfer\')"/>  <input type="button" value="Reject" id="reject" class="resetbutton" onclick="TransferReject(\''); $myData.push(ItemData[i].PODnumber); $myData.push('\',\'Reject\')"/> </td>');
                            }
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" > '); $myData.push(ItemData[i].Type); $myData.push('</td>');
                        }

                        $myData.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(');$myData.push(ItemData[i].LedgerTransactionID); $myData.push(')" />  </td>');

                        $myData.push('</tr>');
                        $myData = $myData.join("");
                        $('#tblitemlist').append(mydata);
                    }
                }            });

        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function showdetail(ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            var showtrid = $(ctrl).closest('tr').find("#showid").text();
            if ($('table#tblitemlist').find('#ItemDetail' + showtrid).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + showtrid).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }               
            serverCall('PODAccept.aspx/BindItemDetail', {pod:id }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No GRN Found");  

                }
                else {
                    var $myDataTblHead = [];                    
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    $myDataTblHead.push('<div style="width:100%;max-height:275px;overflow:auto;"><table style="width:100%" cellpadding="0" cellspacing="0">');
                    $myDataTblHead.push('<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                    $myDataTblHead.push('<td  style="width:20px;">Accept/Reject</td>');
                    $myDataTblHead.push('<td  style="width:30px;">#</td>');
                    $myDataTblHead.push('<td >GRN No</td>');
                    $myDataTblHead.push('<td>supplier name</td>');
                    $myDataTblHead.push('<td>PO Number</td>');
                    $myDataTblHead.push('<td>Invoice No</td>');
                    $myDataTblHead.push('<td>Gross Amt</td>');
                    $myDataTblHead.push('<td>Disc Amt</td>');
                    $myDataTblHead.push('<td>Tax Amt</td>');
                    $myDataTblHead.push('<td>GRN/Net Amt</td>');
                    $myDataTblHead.push('<td>Reject Comment</td></tr>');
                    var $myData = [];
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        
                        $myData.push( "<tr style='background-color:"); $myData.push(ItemData[i].rowColor);  $myData.push(";' id='"); $myData.push(ItemData[i].LedgerTransactionID); $myData.push( "'>");
                        if (ItemData[i].IsPOD_Accept == "1" || ItemData[i].IsPOD_Accept == "2") {
                            $myData.push('<td ></td>');
                        }
                        else {
                            $myData.push( '<td ><input type="checkbox" name="podchk" checked="true" value='); $myData.push(ItemData[i].LedgerTransactionNo);$myData.push('></td>');
                        }

                        $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td id="GRN">'); $myData.push(ItemData[i].LedgerTransactionNo); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].SupplierName );$myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].PurchaseOrderNo); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push( ItemData[i].InvoiceNo); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].GrossAmount, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].DiscountOnTotal, 5) );$myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].TaxAmount, 5));$myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].NetAmount, 5) ); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].Remarks);  $myData.push('</td>');
                        $myData.push("</tr>");
                        
                    }
                    $myData.push("</table></div>");
                    $myData = $myData.join("");
                    var $tr=[];
                    $tr.push('<tr id="ItemDetail');$tr.push(showtrid);$tr.push('"><td colspan="18">');$tr.push( $myData); $tr.push('</td></tr>');
                   
                    $($tr).insertAfter($(ctrl).closest('tr'));                

                }                    
            });
        }
        function TransferReject(pod, type) {
            var txt;
            var reson = prompt("Please enter Reject Reson:", "");
            serverCall('PODAccept.aspx/PODTransferReject', {podnumber: pod ,PODType:type ,Reason:reson }, function (response) {
                ItemData = jQuery.parseJSON(response);         
                if (response== "1") {
                    toast("Success","POD Transfer successfully");                    
                    searchdata();
                }
                else {
                    toast("Error","somthing went wrong");  
                    
                }                
            });
        }
        function Transfer(pod, type) {
            serverCall('PODAccept.aspx/PODTransfer', {podnumber: pod ,PODType:type }, function (response) {
                ItemData = jQuery.parseJSON(response);           
                if (result.d == "1") {
                    toast("Success","POD Transfer successfully");      
                    searchdata();
                }
                else {
                    toast("Error","somthing went wrong");  
                }
                
            });

        }


        function showPodStatus(ctrl) {
            openmypopup('PODTransferDetails.aspx?PODNO=' + $(ctrl).closest('tr').attr("id"));

        }
        function openmypopup(href) {
            var width = '1240px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
    </script>
</asp:Content>



