<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="IndentReceive.aspx.cs" Inherits="Design_Store_IndentReceive" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <style type="text/css" >
        .selected {
            background-color: aqua !important;
            border: 2px solid black;       
        .chosen-container {
            width: 800px !important;
        }
    </style>




    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">



            <div class="row">
                <div class="col-md-24" style="text-align: center">
                   <b> Indent Receive</b>
                </div>
            </div>
            <div class="row">
              <div class="col-md-10" style="text-align: left"> </div>
                <div class="col-md-3" style="text-align: left">
                    <label class="pull-left"> <b>Current Location</b>   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8" style="text-align: left">
                    <asp:DropDownList ID="ddllocation" runat="server"></asp:DropDownList>
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory">
            
        
        <div class="row">
            <div class="col-md-2">
                <label class="pull-left">Indent No.   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:TextBox ID="txtindentno" runat="server" Width="160px"></asp:TextBox>

            </div>
            <div class="col-md-2">
                <label class="pull-left">From Date  </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtentrydatefrom" runat="server"  ReadOnly="true" />
                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

            </div>

            <div class="col-md-2">
                <label class="pull-left">To Date   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" />
                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

            </div>
            <div class="col-md-3">

                <label class="pull-left">Indent Status</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlindenttype" runat="server">
                    <asp:ListItem Text="Pending For Received" Value="Pending For Received" Selected="True" />
                    <asp:ListItem Text="Partial Received" Value="Partial Received" />
                    <asp:ListItem Text="Received" Value="Received" />

                    <asp:ListItem Text="All" Value="All" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12" style="text-align: right">
                <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
            </div>
            <div class="col-md-12">
                <table width="80%">
                    <tr>
                        <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>

                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Pending For Received</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Partial Received</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Received</td>


                    </tr>
                </table>
            </div>
        </div>


        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Indent Detail
            </div>


            <div class="row">
                <div class="col-md-24">
                     <div class="row">
                          <div class="col-md-12">
                              <div style="width: 99%; max-height: 375px; overflow: auto;">
                                <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                                    <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 85px;">Indent No.</td>
                                        <td class="GridViewHeaderStyle">Indent Date</td>
                                        <td class="GridViewHeaderStyle">Issue From Location</td>
                                        <td class="GridViewHeaderStyle">Issue To Location</td>
                                        <td class="GridViewHeaderStyle">Created User</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Print</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Invoice</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Disp atch</td>
                                    </tr>
                                </table>
                            </div>
                              </div>
                         <div class="col-md-12">
                              <asp:TextBox class="issuediv1" ID="txtbarcodeno" autocomplete="off" runat="server" Width="236px" placeholder="Scan Barcode For Quick Receive" BackColor="lightyellow" Style="border: 1px solid red; display: none;" Font-Bold="true"></asp:TextBox>

                            &nbsp;&nbsp;&nbsp;


                          <input type="button" value="Receive Now" class="savebutton issuediv" style="display: none;" onclick="receivenow()" />
                            <br />
                             <div class="issuediv" style='width: 690px; max-height: 275px; overflow: auto; display: none;'>
                                <table frame='box' rules='all' border='1' id="tblitemdetail" style="table-layout: fixed; width: 1270px;">
                                    <tr id="trheader" style="background-color: lightslategray; color: white; font-weight: bold;">
                                        <td style="width: 20px;">#</td>
                                        <td style="width: 60px;">ItemID</td>
                                        <td style="width: 290px;">Item Name</td>
                                        <td style="width: 100px;">Barcode No</td>
                                        <td style="width: 60px;">Unit</td>
                                        <td style="width: 70px;">Pending<br />
                                            Qty</td>
                                        <td style="width: 70px;">Receive<br />
                                            Qty</td>
                                        <td style="width: 120px;">Pending<br />
                                            Remarks</td>
                                        <td style="width: 80px;">Request<br />
                                            Qty</td>
                                        <td style="width: 80px;">Approved<br />
                                            Qty</td>
                                        <td style="width: 80px;">Issued<br />
                                            Qty</td>
                                        <td style="width: 140px;">Last Receive<br />
                                            Qty</td>
                                        <td style="width: 80px;">Reject<br />
                                            Qty</td>
                                    </tr>
                                </table>
                            </div>
                              </div>
                          </div>
                      </div>

                  </div>
               
            </div>
        </div>
        <script type="text/javascript">

            function searchdata() {
                var length = $('#<%=ddllocation.ClientID%> > option').length;
             if (length == 0) {
                 toast("Error", "No Location Found For Current User..!","");
                 $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            var location = $("#<%=ddllocation.ClientID%>").val();
             var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
             var todate = $('#<%=txtentrydateto.ClientID%>').val();
             var indentno = $("#<%=txtindentno.ClientID%>").val();
             var indenttype = $("#<%=ddlindenttype.ClientID%>").val();
             $('#tblitemlist tr').slice(1).remove();
             $('#tblitemdetail tr').slice(1).remove();
             $('.issuediv').hide();
             $('.issuediv1').hide();
             $('#<%=txtbarcodeno.ClientID%>').val('');
                serverCall('IndentReceive.aspx/SearchData', { location: location, fromdate: fromdate, todate:todate, indentno:indentno, indenttype: indenttype }, function (response) {
                    ItemData = jQuery.parseJSON(response);
                    if (ItemData.length == 0) {
                        toast("Error", "No Indent Found","");                      
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var $myData = [];
                            $myData.push("<tr style='background-color:");$myData.push(ItemData[i].Rowcolor);$myData.push(";' id='");$myData.push(ItemData[i].indentno);$myData.push( "'>");
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( parseInt(i + 1)); $myData.push('</td>');
                            var c = "";
                            $myData.push('<td class="GridViewLabItemStyle" ><a style="font-weight:bold;color:blue;cursor:pointer;" onclick="showdetail(this,\'' );$myData.push( c); $myData.push( '\')"> '); $myData.push( ItemData[i].indentno); $myData.push('</a></td>');
                            $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].IndentDate);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push(ItemData[i].ToLocation);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].FromLocation);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].Username);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].Status);$myData.push('</td>');                     
                            $myData.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" />  </td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                            if (ItemData[i].Status != 'New' && ItemData[i].Status != 'Reject') {
                                $myData.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeinvoice(this)" />');
                            }
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                            $myData.push('<img src="../../App_Images/truck.jpg" title="View Item Dispatch Detail" style="cursor:pointer;width:20px;width:20px;" onclick="viewdispatch(this)" />');
                            $myData.push('  </td>');
                            $myData.push('<td style="display:none;" id="tdlocid" >');$myData.push(ItemData[i].tolocationid);$myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdIssueInvoiceNo" >');$myData.push(ItemData[i].IssueInvoiceNo);$myData.push('</td>');
                            $myData.push("</tr>");

                            $myData = $myData.join("");
                            $('#tblitemlist').append($myData);

                        }
                        $('.issuediv1').show();

                    }
                });           
        }
        function viewdispatch(ctrl) {
            openmypopup('IndentDispatchDetail.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function openmypopup(href) {
            var width = '920px';
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
                'overflow-y': 'auto',
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function printme(ctrl) {
            window.open('IndentReceipt.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function printmeinvoice(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();
            if (tdIssueInvoiceNo != "") {
                for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {
                    var BatchNumber = tdIssueInvoiceNo.split(',')[a];
                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                }
            }
        }
        function showdetail(ctrl, itemid) {
            $('#<%=txtbarcodeno.ClientID%>').val('');
            var id = $(ctrl).closest('tr').attr("id");
            var locationid = $(ctrl).closest('tr').find("#tdlocid").html();
            if (itemid == "") {
                $('#tblitemdetail tr').slice(1).remove();
            }
            $("#tblitemlist tr").removeClass("selected");
            $(ctrl).closest('tr').addClass("selected");
            serverCall('IndentReceive.aspx/BindItemDetail', { IndentNo: id , locationid: locationid , itemid: itemid }, function (response) {
                ItemData = jQuery.parseJSON(response);

                if (ItemData.length == 0) {
                    toast("Error", "No Item Found", "");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        var a = precise_round(ItemData[i].PrQty, 5);
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].Rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("'>");
                        if (a > 0) {
                            if (itemid == "") {
                                $myData.push('<td><input type="checkbox" id="mmcheck" disabled="disabled" checked="checked" /></td>');
                            }
                            else {
                                $myData.push('<td><input type="checkbox" id="mmcheck" disabled="disabled" checked="checked"/></td>');
                            }
                        }
                        else {
                            $myData.push('<td><input type="checkbox" id="mmcheck" disabled="disabled" /></td>');
                        }
                        $myData.push('<td>'); $myData.push(ItemData[i].itemid); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].itemname); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].barcodeno); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].minorunitname); $myData.push('</td>');
                        $myData.push('<td id="tdPrQty" style="font-weight:bold;">'); $myData.push(precise_round(ItemData[i].PrQty, 5)); $myData.push('</td>');
                        $myData.push('<td style="background-color:palegreen;">');

                        if (a > 0) {
                            if (itemid == "") {
                                $myData.push('<input onkeyup="showme(this);" id="txtrecqty" type="text" value="'); $myData.push(precise_round(ItemData[i].PrQty, 5)); $myData.push('" placeholder="Qty" style="width:60px;background-color:papayawhip;font-weight:bold;"/> ');
                            }
                            else {
                                $myData.push('<input onkeyup="showme(this);" id="txtrecqty" value="'); $myData.push(precise_round(ItemData[i].PrQty, 5)); $myData.push('" type="text" placeholder="Qty" style="width:60px;background-color:papayawhip;font-weight:bold;"/> ');
                            }
                        }
                        else {
                            $myData.push(precise_round(ItemData[i].ReceiveQty, 5));
                        }
                        $myData.push('</td>');
                        $myData.push('<td style="background-color:lightblue;">');
                        $myData.push('<input value="' + ItemData[i].PendingRemarks + '" type="text" style="width:110px" maxlength="180" placeholder="Pending Remarks" id="txtpendingremarks"/>');
                        $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].ReqQty, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].ApprovedQty, 5)); $myData.push('</td>');
                        $myData.push('<td id="tdissueqty">'); $myData.push(precise_round(ItemData[i].PendingQty, 5)); $myData.push('</td>');
                        $myData.push('<td id="tdreceiveqty">'); $myData.push(precise_round(ItemData[i].ReceiveQty, 5)); $myData.push('</td>');
                        $myData.push('<td id="tdrejectqty">'); $myData.push(precise_round(ItemData[i].RejectQty, 5)); $myData.push('</td>');
                        $myData.push('<td id="tdstockid" style="display:none;" >'); $myData.push(ItemData[i].stockid); $myData.push('</td>');
                        $myData.push('<td id="tdIssueInvoiceNo" style="display:none;">'); $myData.push(ItemData[i].IssueInvoiceNo); $myData.push('</td>');
                        $myData.push('<td id="tdindentno" style="display:none;">'); $myData.push(id); $myData.push('</td>');
                        $myData.push('<td id="tditemid" style="display:none;">'); $myData.push(ItemData[i].itemid); $myData.push('</td>');
                        $myData.push('<td id="tdfrompanelid" style="display:none;">'); $myData.push(ItemData[i].frompanelid); $myData.push('</td>');
                        $myData.push('<td id="tdfromlocationid" style="display:none;">'); $myData.push(ItemData[i].fromlocationid); $myData.push('</td>');
                        $myData.push('<td id="tdMinorUnitInDecimal" style="display:none;">'); $myData.push(ItemData[i].MinorUnitInDecimal); $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemdetail').append($myData);
                    }
                    $('.issuediv').show();
                }
                       
                });                      
        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function showme(ctrl) {
            if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {
                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }



            var recqty = parseFloat($(ctrl).closest('tr').find('#tdissueqty').html());
            var recqty1 = parseFloat($(ctrl).closest('tr').find('#tdreceiveqty').html());
            var recqty2 = parseFloat($(ctrl).closest('tr').find('#tdrejectqty').html());

            var total = recqty - recqty1 - recqty2;
            if (parseFloat($(ctrl).val()) > parseFloat(total)) {
                toast("Error", "Can Not Receive More Then Issue Qty.!","");
                $(ctrl).val(total);
                return;
            }

            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#mmcheck').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#mmcheck').prop('checked', false)
            }

        }
        </script>

        <script type="text/javascript">
            function receiveme(ctrl) {

                if ($(ctrl).closest('tr').find('#txtrecqty').val() == "" || $(ctrl).closest('tr').find('#txtrecqty').val() == "0") {
                    toast("Error", "Please Enter Receive Qty","");
                    $(ctrl).closest('tr').find('#txtrecqty').val();
                    return;
                }

                var IndentNo = $(ctrl).closest('tr').find('#tdindentno').html();
                var itemid = $(ctrl).closest('tr').find('#tditemid').html();
                var stockid = $(ctrl).closest('tr').find('#tdstockid').html();
                var issueqty = $(ctrl).closest('tr').find('#txtrecqty').val();
                var fromlocation = $(ctrl).closest('tr').find('#tdfromlocationid').html();
                var frompanel = $(ctrl).closest('tr').find('#tdfrompanelid').html();
                var IssueInvoiceNo = $(ctrl).closest('tr').find('#tdIssueInvoiceNo').html();
                var PendingRemarks = $(ctrl).closest('tr').find('#txtpendingremarks').val();

                serverCall('IndentReceive.aspx/ReceiveSingleItem', { IndentNo:IndentNo,itemid:itemid,stockid:stockid,issueqty:issueqty,fromlocation:fromlocation,frompanel:frompanel,IssueInvoiceNo:IssueInvoiceNo ,PendingRemarks:PendingRemarks}, function (response) {

                    ItemData = response;

                    if (ItemData == "1") {
                        toast("Success", "Indent Received","");
                        var tdreceiveqty = $(ctrl).closest('tr').find('#tdreceiveqty').html();
                        var fi = parseFloat(tdreceiveqty) + parseFloat(issueqty);
                        $(ctrl).closest('tr').find('#tdreceiveqty').html(precise_round(fi, 5));

                        var tdPrQty = $(ctrl).closest('tr').find('#tdPrQty').html();
                        var fi1 = parseFloat(tdPrQty) - parseFloat(issueqty);
                        $(ctrl).closest('tr').find('#tdPrQty').html(precise_round(fi1, 5));
                        $(ctrl).closest('tr').find('input:text').val('');

                        if (fi1 == 0) {
                            $(ctrl).closest('tr').css('background-color', '#90EE90');
                            $(ctrl).closest('tr').find('input:text').prop('disabled', true);

                            $(ctrl).closest('tr').find('img').hide();

                        }
                        // searchdata();
                    }
                    else {
                        toast("Error", ItemData,"");
                    }
                });              
            }
            function validation() {
                var che = "true";
                var a = $('#tblitemlist tr').length;
                if (a == 1) {
                    toast("Error", "Please Search Indent..!","");
                    return false;
                }

                var b = $('#tblitemdetail tr').length;
                if (b == 1) {
                    toast("Error", "Please Search Item..!","");
                    return false;
                }
                if (b > 0) {
                    $('#tblitemdetail tr').each(function () {
                        if ($(this).attr("id") != "trheader" && $(this).find("#mmcheck").is(':checked') && ($(this).find("#txtrecqty").val() == "" || $(this).find("#txtrecqty").val() == "0")) {
                            $(this).find("#txtrecqty").focus();
                            toast("Error", "You have not Entered Qty","");
                            che = "false";
                            return false;
                        }
                    });
                    $('#tblitemdetail tr').each(function () {
                        if ($(this).attr("id") != "trheader") {
                            var rec = $(this).find("#txtrecqty").val();
                            var pr = $(this).find("#tdPrQty").html();
                            if (parseFloat(rec) < parseFloat(pr) && $.trim($(this).find("#txtpendingremarks").val()) == "") {
                                toast("Error", "Please Enter Pending Remarks","");
                                $(this).find("#txtpendingremarks").focus();
                                che = "false";
                                return false;
                            }
                        }
                    });
                }
                if (che == "false") {
                    return false;
                }
                return true;
            }
            function Getdata() {
                var dataIm = new Array();
                $('#tblitemdetail tr').each(function () {
                    if ($(this).attr("id") != "trheader" && $(this).find("#mmcheck").is(':checked') && ($(this).find("#txtrecqty").val() != "" || $(this).find("#txtrecqty").val() != "0")) {
                        var objStockMaster = new Object();
                        objStockMaster.IndentNo = $(this).find('#tdindentno').html();
                        objStockMaster.itemid = $(this).find("#tditemid").html();
                        objStockMaster.stockid = $(this).find("#tdstockid").html();
                        objStockMaster.Receiveqty = $(this).find('#txtrecqty').val();
                        objStockMaster.fromlocation = $(this).find('#tdfromlocationid').html();
                        objStockMaster.frompanel = $(this).find("#tdfrompanelid").html();
                        objStockMaster.IssueInvoiceNo = $(this).find("#tdIssueInvoiceNo").html();
                        objStockMaster.PendingRemarks = $(this).find("#txtpendingremarks").val();
                        dataIm.push(objStockMaster);
                    }
                });
                return dataIm;
            }
            function receivenow() {
                if (validation() == true) {
                    var mydataadj = Getdata();
                    if (mydataadj.length == 0) {
                        toast("Error", "Please Select Item To Receive","");
                        return;
                    }
                    serverCall('IndentReceive.aspx/ReceiveAll', { mydataadj: mydataadj }, function (response) {
                        if (response == "1") {
                            toast("Success", "Item Receive Successfully..!","");
                            searchdata();
                        }
                        else {
                            toast("Error", response,"");
                        }
                    });                 
                }
            }
        </script>
        <script type="text/javascript">
            $(function () {
                $("#<%= txtbarcodeno.ClientID%>").keydown(
                    function (e) {
                        var key = (e.keyCode ? e.keyCode : e.charCode);
                        if (key == 13) {
                            e.preventDefault();
                            if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {
                                searchindentnofrombarcode();
                            }
                        }
                    });
            });
            function searchindentnofrombarcode() {
                var barcodeno = $.trim($('#<%=txtbarcodeno.ClientID%>').val());
                serverCall('IndentReceive.aspx/searchindentnofrombarcode', { barcodeno: barcodeno }, function (response) {
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    if (response == "") {
                        toast("Error", "No Item Found", "");
                    }
                    else {
                        if ($('table#tblitemlist').find('#' + response.split('#')[0]).length > 0) {

                            if ($('table#tblitemdetail').find('#' + response.split('#')[2]).length > 0) {
                                toast("Error", "Barcode Already Added.!", "");
                                return;
                            }
                            var tr = $('table#tblitemlist').find("#" + response.split('#')[0]);
                            $("#tblitemlist tr").removeClass("selected");
                            tr.addClass("selected");
                            showdetail(tr, response.split('#')[1]);
                        }
                        else {
                            toast("Error", "Indent Not Found In Search List", "");
                        }
                    }
                });
            }
        </script>
</asp:Content>

