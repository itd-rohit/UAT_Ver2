<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="IndentRePrint.aspx.cs" Inherits="Design_Store_IndentRePrint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Indent Status and Approval</b>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <div class="col-md-10"></div>
                <div class="col-md-14">
                    <b>
                        <asp:RadioButtonList ID="rdoIndentType" runat="server" onchange="setIndentType();" RepeatDirection="Horizontal" RepeatLayout="Table">
                            <asp:ListItem Text="SI" Value="SI" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="PI" Value="PI"></asp:ListItem>
                        </asp:RadioButtonList></b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Current Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddllocation" runat="server" onchange="bindindentfromlocation()"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">To Location</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddllocationfrom" runat="server"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Indent No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtindentno" runat="server" Width="160px"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Indent Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlindenttype" runat="server">
                        <asp:ListItem Text="New" Value="New" />
                        <asp:ListItem Text="Issued" Value="Issued" />
                        <asp:ListItem Text="Close" Value="Close" />
                        <asp:ListItem Text="Reject" Value="Reject" />
                        <asp:ListItem Text="Partial Issue" Value="Partial Issue" />
                        <asp:ListItem Text="Partial Receive" Value="Partial Receive" />
                        <asp:ListItem Text="All" Selected="True" Value="All" />
                    </asp:DropDownList>

                </div>
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left">Action</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlaction" runat="server">
                        <asp:ListItem Value=""></asp:ListItem>
                        <asp:ListItem Value="Maker">Maked</asp:ListItem>
                        <asp:ListItem Value="Checker">Checked</asp:ListItem>
                        <asp:ListItem Value="Approval">Approved</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12" style="text-align: right">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                    <input type="button" value="Export To Excel" class="searchbutton" onclick="excel()" />
                </div>
                
                <div class="col-md-12" style="text-align: right">

                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;"></div>
                    <div class="col-md-2">New</div>


                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white;"></div>
                    <div class="col-md-2">Issued</div>
                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"></div>
                    <div class="col-md-2">Close</div>

                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;"></div>
                    <div class="col-md-2">Reject</div>

                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;"></div>
                    <div class="col-md-4">Partial Issue</div>

                    <div class="col-md-1" style="width: 20px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgray;"></div>
                    <div class="col-md-5">Partial Receive</div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Indent Detail
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div style="width: 100%; max-height: 375px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                <td class="GridViewHeaderStyle" style="width: 50px;">View Item</td>
                                <td class="GridViewHeaderStyle">Indent No.</td>
                                <td class="GridViewHeaderStyle">Indent Date</td>
                                <td class="GridViewHeaderStyle">Indent From Location</td>
                                <td class="GridViewHeaderStyle">Indent To Location</td>
                                <td class="GridViewHeaderStyle">Created User</td>
                                <td class="GridViewHeaderStyle">Checked User</td>
                                <td class="GridViewHeaderStyle">Checked Date</td>
                                <td class="GridViewHeaderStyle">Approved User</td>
                                <td class="GridViewHeaderStyle">Approved Date</td>
                                <td class="GridViewHeaderStyle postatus" style="display: none;">PO Status</td>
                                <td class="GridViewHeaderStyle postatus" style="display: none;">Print PO</td>
                                <td class="GridViewHeaderStyle">Narration</td>
                                <td class="GridViewHeaderStyle">Status</td>
                                <td class="GridViewHeaderStyle">ExpectedDate</td>
                                <td class="GridViewHeaderStyle">Action Type</td>
                                <td class="GridViewHeaderStyle">Next Action</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">Print</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">Disp atch</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="popup_box" style="background-color: lightgreen; height: 120px; text-align: center; width: 340px;">
        <div id="showpopupmsg" style="font-weight: bold;"></div>
        <br />
        <b><span style="color: red;">Rejection Reason :</span> </b>&nbsp;&nbsp;<asp:TextBox ID="txtrejectre" runat="server" Width="200px" />
        <br />
        <span id="indentno" style="display: none;"></span>
        <input type="button" class="searchbutton" value="Yes" onclick="reject();" />
        <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>
    <script type="text/javascript">
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
        function unloadPopupBox() {    // TO Unload the Popupbox
            $('#indentno').html('');
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });
            $('#<%=txtrejectre.ClientID%>').val('');
        }
        function bindindentfromlocation() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $("#<%=ddllocationfrom.ClientID%> option").remove();
                $("#<%=ddllocationfrom.ClientID%>").append($("<option></option>").val("0").html("Select From Location"));
                return;
            }
            var dropdown = $("#<%=ddllocationfrom.ClientID%>");
            $("#<%=ddllocationfrom.ClientID%> option").remove();
            serverCall('IndentRePrint.aspx/bindindentfromlocation', { tolocation: $('#<%=ddllocation.ClientID%>').val(), IndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {
                PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    dropdown.append($("<option></option>").val("0").html("Select From Location"));
                }
                else {
                    if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'SI') {
                        dropdown.append($("<option></option>").val("0").html("Select From Location"));
                    }
                    for (i = 0; i < PanelData.length; i++) {
                        dropdown.append($("<option></option>").val(PanelData[i].locationid).html(PanelData[i].location));
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function searchdata() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            var fromlocation = $("#<%=ddllocation.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var tolocation = $("#<%=ddllocationfrom.ClientID%>").val();
            var indentno = $("#<%=txtindentno.ClientID%>").val();
            var indenttype = $("#<%=ddlindenttype.ClientID%>").val();
            $('#tblitemlist tr').slice(1).remove();
            serverCall('IndentRePrint.aspx/SearchData', { tolocation: tolocation, fromdate: fromdate, todate: todate, fromlocation: fromlocation, indentno: indentno, indenttype: indenttype, ActionType: $('#<%=ddlaction.ClientID%>').val(), IsSIIndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No Indent Found", "");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].Rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].indentno); $myData.push("'>");
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].indentno); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].IndentDate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].FromLocation); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ToLocation); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Username); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].CheckedUserName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].CheckedDate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ApprovedUserName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ApprovedDate); $myData.push('</td>');
                        if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'PI') {
                            if (ItemData[i].POStatus == "PO Created") {
                                $myData.push('<td class="GridViewLabItemStyle postatus" style="color: white;background-color: blueviolet" ><b>'); $myData.push(ItemData[i].POStatus); $myData.push('</b></td>');
                            }
                            else if (ItemData[i].POStatus == "Pending") {
                                $myData.push('<td class="GridViewLabItemStyle postatus" style="color: white;background-color: cadetblue" ><b>'); $myData.push(ItemData[i].POStatus); $myData.push('</b></td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle postatus" style="color: white;background-color: #FF5722" ><b>'); $myData.push(ItemData[i].POStatus); $myData.push('</b></td>');
                            }
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle postatus" style="display:none;">'); $myData.push(ItemData[i].POStatus); $myData.push('</td>');
                        }

                        if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'PI') {
                            if (ItemData[i].POStatus == "PO Created") {
                                if (ItemData[i].ponumbers != "") {
                                    $myData.push('<td class="GridViewLabItemStyle postatus" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printmepo(this)" /> </td>');
                                }
                                else {
                                    $myData.push('<td class="GridViewLabItemStyle postatus" >PO Not Approved</td>');
                                }
                            }
                            else if (ItemData[i].POStatus == "Pending") {
                                $myData.push('<td class="GridViewLabItemStyle postatus" ></td>');
                            }
                            else {
                                if (ItemData[i].ponumbers != "") {
                                    $myData.push('<td class="GridViewLabItemStyle postatus" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printmepo(this)" /> </td>');
                                }
                                else {
                                    $myData.push('<td class="GridViewLabItemStyle postatus" >PO Not Approved</td>');
                                }
                            }
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle postatus" style="display:none;"></td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Narration); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Status); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ExpectedDate); $myData.push('</td>');
                        if (ItemData[i].ActionType == "Maker") {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:white;font-weight:bold;" >Maked</td>');
                        }
                        else if (ItemData[i].ActionType == "Checker") {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:aqua;font-weight:bold;" >Checked</td>');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:palegreen;font-weight:bold;">Approved</td>');
                        }
                        if (ItemData[i].Status != "Reject") {
                            if (ItemData[i].ActionType == "Maker") {
                                var aaa = "Checker";
                                $myData.push('<td title="Pending For Check" class="GridViewLabItemStyle" style="background-color:aqua;font-weight:bold;" ><input style="font-weight:bold;cursor:pointer;" type="button" value="Check" onclick="editData(this,\''); $myData.push(aaa); $myData.push('\')"  /> </td>');
                            }
                            else if (ItemData[i].ActionType == "Checker") {
                                var aaa = "Approval";
                                $myData.push('<td  title="Pending For Approve"  class="GridViewLabItemStyle" style="background-color:palegreen;font-weight:bold;" ><input style="font-weight:bold;cursor:pointer;" type="button" value="Approve"  onclick="editData(this,\''); $myData.push(aaa); $myData.push('\')" /> </td>');
                            }
                            else {
                                $myData.push('<td title="Approval Done"  class="GridViewLabItemStyle"></td>');
                            }
                        }
                        else {
                            $myData.push('<td title="Reject Reason"  class="GridViewLabItemStyle">'); $myData.push(ItemData[i].rejectreason); $myData.push('</td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" />  </td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        if (ItemData[i].Status != 'New') {
                            $myData.push('<img src="../../App_Images/truck.jpg" title="View Item Dispatch Detail" style="cursor:pointer;width:20px;width:20px;" onclick="viewdispatch(this)" />');
                        }
                        $myData.push('  </td>');
                        $myData.push('<td style="display:none;" id="tdlocid" >'); $myData.push(ItemData[i].tolocationid); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdIssueInvoiceNo" >'); $myData.push(ItemData[i].IssueInvoiceNo); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdponumbers" >'); $myData.push(ItemData[i].ponumbers); $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                    }
                }
            });
        }
        function viewdispatch(ctrl) {
            openmypopup('IndentDispatchDetail.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function printme(ctrl) {
            window.open('IndentReceipt.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function printmepo(ctrl) {
            var tdponumbers = $(ctrl).closest('tr').find("#tdponumbers").html();
            for (var a = 0; a <= tdponumbers.split(',').length - 1; a++) {
                serverCall('IndentRePrint.aspx/encryptPurchaseOrderID', { ImageToPrint: "1", PurchaseOrderID: tdponumbers.split(',')[a] }, function (response) {
                    var result1 = jQuery.parseJSON(response);
                    window.open('POReport.aspx?ImageToPrint=' + result1[0] + '&POID=' + result1[1]);
                });
            }
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
        function rejectme(ctrl) {
            var indentid = $(ctrl).closest('tr').attr("id");
            $('#showpopupmsg').show();
            $('#showpopupmsg').html("Do You Want To Completely Reject This Indent?");
            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            $('#indentno').html(indentid);
            $('#<%=txtrejectre.ClientID%>').val('');
        }
        function reject() {
            if ($('#<%=txtrejectre.ClientID%>').val() == "") {
                $('#<%=txtrejectre.ClientID%>').focus();
                toast("Error", "Please Enter Reason", "");
                return;
            }
            serverCall('IndentRePrint.aspx/RejectIndent', { IndentNo: $('#indentno').html(), Reason: $('#<%=txtrejectre.ClientID%>').val() }, function (response) {
                ItemData = response;
                unloadPopupBox();
                $('#ContentPlaceHolder1_ddlindenttype').val('Reject');
                toast("Success", "Indent Rejected", "");
                searchdata();
            });
        }
        function showdetail(ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            var locationid = $(ctrl).closest('tr').find("#tdlocid").html();
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            serverCall('IndentRePrint.aspx/BindItemDetail', { IndentNo: id, locationid: locationid }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No Item Found", "");
                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    var $myData = [];
                    $myData.push("<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                    $myData.push('<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">');
                    $myData.push('<td  style="width:20px;">#</td>');
                    $myData.push('<td>Item Name</td>');
                    $myData.push('<td>Consume/Issue Unit</td>');
                    $myData.push('<td>Request Qty</td>');
                    $myData.push('<td>Approved Qty</td>');
                    $myData.push('<td>Issue Qty </td>');
                    $myData.push('<td>Receive Qty </td>');
                    $myData.push('<td>Rejected Qty</td>');
                    $myData.push('<td>Available Qty</td>');
                    $myData.push('<td>Stock In Hand </td>');
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].Rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].id + "'>");
                        $myData.push('<td>'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].itemname); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(ItemData[i].minorunitname); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].ReqQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].ApprovedQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].PendingQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].ReceiveQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].RejectQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].AblQty, 5)); $myData.push('</td>');
                        $myData.push('<td>'); $myData.push(precise_round(ItemData[i].StockINHand, 5)); $myData.push('</td>');
                        $myData.push("</tr>");
                    }
                    $myData.push("</table><div>");
                    
                    var $newdata = [];
                    $newdata.push('<tr id="ItemDetail'); $newdata.push(id); $newdata.push('"><td></td><td colspan="16">'); $newdata.push($myData.join("")); $newdata.push('</td></tr>');
                    $newdata = $newdata.join("");
                    $($newdata).insertAfter($(ctrl).closest('tr'));
                }
            });
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function issueme(ctrl) {
            openmypopup('IndentIssueNew.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function setIndentType() {
            $("#<%=ddllocationfrom.ClientID %> option").remove();
            $('#<%=ddlindenttype.ClientID%>').prop('selectedIndex', 6);
            $('#tblitemlist tr').slice(1).remove();
            $('#<%=txtindentno.ClientID%>').val('');
            bindindentfromlocation();
            if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'PI') {
                //  $('#<%=ddllocationfrom.ClientID%>').prop("disabled", true);

                $('.postatus').show();
            }
            else {
                $('.postatus').hide();
                // $('#<%=ddllocationfrom.ClientID%>').prop("disabled", false);
            }
        }
        function editData(ctrl, type) {
            $("#divMasterNav").css("z-index", '');
            $.fancybox({
                fitToView: false,
                width: '100%',
                height: '100%',
                href: 'CreateSalesIndent.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id") + '&ActionType=' + type,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                autoDimensions: false,
                'type': 'iframe'
            });
        }
        function excel() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            var fromlocation = $("#<%=ddllocation.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var tolocation = $("#<%=ddllocationfrom.ClientID%>").val();
            var indentno = $("#<%=txtindentno.ClientID%>").val();
            var indenttype = $("#<%=ddlindenttype.ClientID%>").val();
            $('#tblitemlist tr').slice(1).remove();
            serverCall('IndentRePrint.aspx/Excel', { tolocation: tolocation, fromdate: fromdate, todate: todate, fromlocation: fromlocation, indentno: indentno, indenttype: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Indent Found", "");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });
        }
    </script>
</asp:Content>

