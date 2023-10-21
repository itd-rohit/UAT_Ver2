<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GRNFromPO.aspx.cs" Inherits="Design_Store_GRNFromPO" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>GRN Against Purchase Order</b>

        </div>


        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">Select Order</div>

            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">GRN Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddllocation" runat="server" class="ddllocation chosen-select chosen-container" onchange="bindorder();checkpageaccess();"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">Order No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddlpurchaseorder" class="ddlpurchaseorder chosen-select chosen-container" runat="server" ></asp:DropDownList>
                </div>

                <div class="col-md-4">
                    <input type="button" value="Search" class="searchbutton" onclick="getmyorderdata()" />
                </div>
            </div>




        </div>

        <div class="POuter_Box_Inventory hidemeonload" style="display: none;">

            <div class="Purchaseheader">Order Detail</div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Order Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbpodate" runat="server" ForeColor="darkgoldenrod"> </asp:Label>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Order Number   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbponumber" runat="server" ForeColor="darkgoldenrod"> </asp:Label>
                    <asp:Label ID="lbpoid" Style="display: none;" runat="server"> </asp:Label>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Supplier   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblvendorname" runat="server" Style="font-weight: 700" ForeColor="darkgoldenrod"></asp:Label>
                    <asp:Label ID="lblvendorid" runat="server" Style="display: none;" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Subject   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblposubject" runat="server" ForeColor="darkgoldenrod"></asp:Label>
                </div>

                <div class="col-md-5">
                    <asp:Label ID="lbvendorlogin" runat="server" ForeColor="darkgoldenrod"></asp:Label>
                </div>
                <div class="col-md-3">
                    <input type="button" value="Invoice" style="display: none; cursor: pointer; font-weight: bold;" id="btninvoice" onclick="openme(this)" />

                </div>
                <div class="col-md-3">
                    <asp:Label ID="lbvendorcomment" runat="server" ForeColor="darkgoldenrod"></asp:Label>
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory hidemeonload" style="display: none;">

            <div class="Purchaseheader">Item Detail</div>
            <div class="row">
                <div class="col-md-24">
                    <div style="width: 100%; max-height: 250px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">

                                <td class="GridViewHeaderStyle">New<br />
                                    Batch</td>
                                <td class="GridViewHeaderStyle">Item Type</td>
                                <td class="GridViewHeaderStyle">ItemID</td>
                                <td class="GridViewHeaderStyle">Item Name</td>
                                <td class="GridViewHeaderStyle">Vendor Comment</td>
                                <td class="GridViewHeaderStyle">Item Code</td>
                                <td class="GridViewHeaderStyle">Hsn Code</td>
                                <td class="GridViewHeaderStyle">Purchased Unit</td>
                                <td class="GridViewHeaderStyle">Conv erter</td>
                                <td class="GridViewHeaderStyle">Consume Unit</td>
                                <td class="GridViewHeaderStyle">Barcode</td>
                                <td class="GridViewHeaderStyle">Batch Number</td>
                                <td class="GridViewHeaderStyle">Expiry Date</td>
                                <td class="GridViewHeaderStyle">PO Qty</td>
                                <td class="GridViewHeaderStyle">GRN Qty</td>
                                <td class="GridViewHeaderStyle">Rate</td>
                                <td class="GridViewHeaderStyle">Paid Qty</td>
                                <td class="GridViewHeaderStyle">Free Qty</td>
                                <td class="GridViewHeaderStyle">Discount %</td>
                                <td class="GridViewHeaderStyle">IGST %</td>
                                <td class="GridViewHeaderStyle">CGST %</td>
                                <td class="GridViewHeaderStyle">SGST %</td>

                                <td class="GridViewHeaderStyle">Discount Amount</td>
                                <td class="GridViewHeaderStyle">Total GST Amount</td>
                                <td class="GridViewHeaderStyle">BuyPrice</td>
                                <td class="GridViewHeaderStyle">Net Amt</td>
                                <td class="GridViewHeaderStyle">#</td>


                            </tr>
                        </table>

                    </div>
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory hidemeonload" style="display: none;">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Invoice No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtinvoiceno" runat="server" Width="120px"></asp:TextBox>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtinvoicedate" runat="server" Width="120px"></asp:TextBox>

                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtinvoicedate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server" PopupButtonID="txtinvoicedate">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Challan No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtchallanno" runat="server" Width="120px"></asp:TextBox>

                </div>

                <div class="col-md-3">
                    <label class="pull-left">Challan Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtchallandate" runat="server" Width="120px"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtchallandate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server" PopupButtonID="txtchallandate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Gate Entry No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtgateentryno" runat="server" Width="120px"></asp:TextBox>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Freight</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtFreight" Text="0" runat="server" Width="120px" onkeyup="getgrnamount();"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender
                        ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtFreight" FilterType="Custom, Numbers"
                        ValidChars="." Enabled="True">
                    </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Octroi</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtOctori" Text="0" runat="server" onkeyup="getgrnamount();"
                            Width="120px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtOctori"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>

                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">Round Off</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtRoundOff" runat="server" Text="0" onkeyup="getgrnamount();"
                            Width="120px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtRoundOff"
                            FilterType="Custom, Numbers" ValidChars=".-" Enabled="True">
                        </cc1:FilteredTextBoxExtender>

                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">GRN Amount</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtgrnamount" Text="0" runat="server" Width="120px" ReadOnly="true"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtgrnamount"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">Invoice Amount</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtInvoiceAmount" Text="0" runat="server" Width="120px" ReadOnly="true"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtInvoiceAmount"
                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Narration</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-15">
                        <asp:TextBox ID="txtNarration" runat="server" Width="600px"></asp:TextBox>
                    </div>
                    <div class="col-md-6">
                        <input type="button" value="Add Invoice" class="searchbutton" onclick="openmypopup('AddGRNDocument.aspx')" />
                    </div>
                </div>

            </div>

</div>

            <div class="POuter_Box_Inventory hidemeonload" style="display: none; text-align: center;">

                <div class="row">
                    <div class="col-md-24">
                        <input type="checkbox" id="chkbarcode" title="Check To Print Barcode" /><strong>Print Barcode</strong>
                        <input type="button" value="Save" class="savebutton" onclick="savegrn();" id="Button1" />

                        <input type="button" value="Reset" class="resetbutton" onclick="clearform();" />
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
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
                bindorder();
            });
            function openme(ctrl) {
                var invoice = $(ctrl).attr("class");
                window.open("../Store/VendorPortal/AddFile.aspx?Type=2&Filename=" + invoice, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no')
            }
            function openmypopupbarcode(href) {
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
            var filename = "";
            function openmypopup(href) {

                var count = $('#tblitemlist tr').length;
                if (count == 0 || count == 1) {
                    toast("Error", "Please Select Item  ");
                    $('#txtitem').focus();
                    return false;
                }
                if (filename == "") {
                    filename = Math.floor((Math.random() * 10000) + 1);
                }
                href += '?filename=' + filename;
                var width = '1100px';
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
            function bindorder() {
                var dropdown = $("#<%=ddlpurchaseorder.ClientID%>");
            $("#<%=ddlpurchaseorder.ClientID%> option").remove();
            $('#<%=ddlpurchaseorder.ClientID%>').trigger('chosen:updated');
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {

                dropdown.append($("<option></option>").val("0").html("--No Order Found--"));
                return;
            }

                serverCall('GRNFromPO.aspx/bindorder', { location: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                    PanelData = $.parseJSON(response);
                    if (PanelData.length == 0) {
                        dropdown.append($("<option></option>").val("0").html("--No Order Found--"));

                    }
                    else {
                        dropdown.bindDropDown({ defaultValue: 'Select Purchase Order', data: JSON.parse(response), valueField: 'PurchaseOrderID', textField: 'PurchaseOrderNo', isSearchAble: true });

                    }
                });

           
         }
        </script>

        <script type="text/javascript">
            function getmyorderdata() {

                var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlpurchaseorder.ClientID%>').val() == "0") {
                toast("Error", "Please Select Purchase Order");
                $('#<%=ddlpurchaseorder.ClientID%>').focus();
                return;
            }

            $('#<%=ddllocation.ClientID%>').prop("disabled", true);
            $('#<%=ddlpurchaseorder.ClientID%>').prop("disabled", true);
            $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlpurchaseorder.ClientID%>').trigger('chosen:updated');
          

                serverCall('GRNFromPO.aspx/bindorderdetail', { location: $('#<%=ddllocation.ClientID%>').val(), poid: $('#<%=ddlpurchaseorder.ClientID%>').val() }, function (response) {
                    POdata = $.parseJSON(response);
                    if (POdata.length == 0) {
                        toast("Error", "No Detail Found For This Purchase Order");
                        $('.hidemeonload').hide();
                        return;
                    }
                    else {
                        $('.hidemeonload').show();
                        $('#<%=lbpodate.ClientID%>').html(POdata[0].podate);
                        $('#<%=lbponumber.ClientID%>').html(POdata[0].PurchaseOrderNo);
                        $('#<%=lbpoid.ClientID%>').html(POdata[0].PurchaseOrderID);
                        $('#<%=lblvendorid.ClientID%>').html(POdata[0].VendorID);
                        $('#<%=lblvendorname.ClientID%>').html(POdata[0].VendorName);
                        $('#<%=lblposubject.ClientID%>').html(POdata[0].Subject);
                        $('#<%=lbvendorlogin.ClientID%>').html(POdata[0].VendorPortal);
                        if (POdata[0].vendorcomment != "") {
                            $('#<%=lbvendorcomment.ClientID%>').html("<span style='color:black;'> Vendor Comment : </span>" + POdata[0].vendorcomment);
                        }
                        else {
                            $('#<%=lbvendorcomment.ClientID%>').html("");
                        }
                        if (POdata[0].vendorinvoicetext != "") {
                            $('#<%=txtinvoiceno.ClientID%>').val(POdata[0].vendorinvoicetext);
                        }
                        if (POdata[0].vendorinvoicedate != "") {
                            $('#<%=txtinvoicedate.ClientID%>').val(POdata[0].vendorinvoicedate);
                        }
                        if (POdata[0].VendorInvoice != "") {
                            $('#btninvoice').show();
                            $('#btninvoice').addClass(POdata[0].VendorInvoice);

                        }
                        for (i = 0; i < POdata.length; i++) {

                            if ($('table#tblitemlist').find('#' + POdata[i].itemid).length > 0) {
                                toast("Error", "Item Already Added");
                                return;
                            }
                            var $myData = [];


                            $myData.push("<tr style='background-color:bisque;' id='");$myData.push(POdata[i].itemid);$myData.push("' class='tr_clone'>");
                            $myData.push('<td class="GridViewLabItemStyle" >');
                            if (POdata[i].BarcodeOption == "1" && POdata[i].BarcodeGenrationOption == "1") {

                            }
                            else {
                                $myData.push(' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addmenow(this);" />');
                            }
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tditemgroupname">');$myData.push(POdata[i].itemgroup); $myData.push('</td>');
                            $myData.push('<td style="font-weight:bold;" id="tditemid1">');$myData.push(POdata[i].itemid); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tditemname">');$myData.push(POdata[i].typename); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdvendorcommentitem" style="font-weight:bold;">');$myData.push(POdata[i].vendorcommentitem); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdapolloitemcode">');$myData.push(POdata[i].apolloitemcode); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdHsnCode">');$myData.push(POdata[i].HsnCode); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdmajorunitname">');$myData.push(POdata[i].MajorUnitName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdconverter">');$myData.push(POdata[i].Converter); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdminorunitname">');$myData.push(POdata[i].MinorUnitName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');
                            if (POdata[i].BarcodeGenrationOption == "1") {
                                $myData.push('<input type="text" id="txtbarcodeno" style="width:100px;" onblur="showmybarcode(this)"  />');
                            }
                            else {
                                $myData.push('<input type="text" id="txtbarcodeno" style="width:100px;" readonly="readonly" />');
                            }
                            $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" onblur="checkduplicatebatchno(this)" style="width:100px;" /></td>');
                            if (POdata[i].IsExpirable == "0") {
                                $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate');$myData.push(POdata[i].itemid); $myData.push(POdata[i].IsExpirable); $myData.push('" style="width:90px;" class="exdate" readonly="readonly"  /></td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate');$myData.push(POdata[i].itemid); $myData.push('" style="width:90px;" class="exdate"  readonly="readonly" /></td>');
                            }

                            $myData.push('<td class="GridViewLabItemStyle" id="tdpoqty">');$myData.push(POdata[i].poqty);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdgrnqty">');$myData.push(POdata[i].grnqty);$myData.push('</td>');
                            $myData.push('<td align="left" id="tdRate"><input type="text"  style="width:60px" readonly="readonly" id="txtRate" value="');$myData.push(precise_round(POdata[i].Rate, 5));$myData.push('" onkeyup="CalBuyPrice(this);"/></td>');
                            $myData.push('<td align="left" id="tdQuantity"><span style="display:none;" id="sppaidqty">');$myData.push(precise_round(POdata[i].PaidQty, 5));$myData.push('</span><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showmeqty(this);CalBuyPrice(this);" value="');$myData.push(precise_round(POdata[i].PaidQty, 5)); $myData.push('" /></td>');
                            $myData.push('<td align="left" id="tdFreeQty"><span style="display:none;" id="spfreeqty">');$myData.push(precise_round(POdata[i].FreeQty, 5) );$myData.push('</span><input type="text"  style="width:60px" id="txtFreeQty" onkeyup="showmefreeqty(this);"  value="');$myData.push(precise_round(POdata[i].FreeQty, 5));$myData.push('" /></td>');
                            $myData.push('<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" value="' + precise_round(POdata[i].DiscountPer, 5));$myData.push('" onkeyup="CalBuyPrice(this);"/></td>');
                            $myData.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" value="');$myData.push(precise_round(POdata[i].IGSTPer, 5));$myData.push('"  onkeyup="CalBuyPrice(this);"/></td>');
                            $myData.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" value="');$myData.push(precise_round(POdata[i].CGSTPer, 5) );$myData.push('"  onkeyup="CalBuyPrice(this);" /></td>');
                            $myData.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" value="');$myData.push(precise_round(POdata[i].SGSTPer, 5));$myData.push('"  onkeyup="CalBuyPrice(this);" /></td>');


                            $myData.push('<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>');
                            $myData.push('<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>');
                            $myData.push('<td align="left" id="tdBuyPrice"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>');
                            $myData.push('<td align="left" id="tdNetAmt"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>');
                            $myData.push('<td title="Remove"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');


                            $myData.push('<td style="display:none;" id="tditemid">'); $myData.push(POdata[i].itemid); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdmajorunitid">'); $myData.push(POdata[i].MajorUnitId); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdminorunitid">'); $myData.push(POdata[i].MinorUnitId); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdmanufaid">'); $myData.push(POdata[i].ManufactureID); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdmacid">'); $myData.push(POdata[i].MachineID); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdlocationid">'); $myData.push(POdata[i].LocationId); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdpanelid">'); $myData.push(POdata[i].panelid); $myData.push('</td>');

                            $myData.push('<td style="display:none;" id="tdIsExpirable">'); $myData.push(POdata[i].IsExpirable); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdPackSize">'); $myData.push(POdata[i].PackSize); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdBarcodeOption">'); $myData.push(POdata[i].BarcodeOption); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdBarcodeGenrationOption">'); $myData.push(POdata[i].BarcodeGenrationOption); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdIssueInFIFO">'); $myData.push(POdata[i].IssueInFIFO); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdIssueMultiplier">'); $myData.push(POdata[i].IssueMultiplier); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdMajorUnitInDecimal">'); $myData.push(POdata[i].MajorUnitInDecimal); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdMinorUnitInDecimal">'); $myData.push(POdata[i].MinorUnitInDecimal); $myData.push('</td>');

                            $myData.push('<td style="display:none;" id="tdexpdatecutoff">'); $myData.push(POdata[i].expdatecutoff); $myData.push('</td>');
                            $myData.push("</tr>");

                            $myData = $myData.join("");
                            $('#tblitemlist').append($myData);

                            
                            var date = new Date();
                            var newdate = new Date(date);

                            newdate.setDate(newdate.getDate() + parseInt(POdata[i].expdatecutoff));

                            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                       "Aug", "Sep", "Oct", "Nov", "Dec"];

                            var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();




                            $("#txtexpirydate" + POdata[i].itemid).datepicker({
                                dateFormat: "dd-M-yy",
                                changeMonth: true,
                                changeYear: true, yearRange: "-0:+20", minDate: val

                            });
                            CalBuyPrice($('#tblitemlist tr:last').find('#tdQuantity'));
                            getgrnamount();





                        }
                    }

                });

           

        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function deleterow(itemid) {
            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            getgrnamount();
        }
        function addmenow(ctrl) {
            var $tr = $(ctrl).closest('.tr_clone');
            var $clone = $tr.clone();
            $clone.find('#txtbacknumber').val('');
            $clone.find('#txtQuantity').val('');
            $clone.find('#txtTotalGSTAmount').val('');
            $clone.find('#txtFreeQty').val('');
            $clone.find('#txtBuyPrice').val('');
            $clone.find('#txtNetAmt').val('');



            var newid = Math.floor(1000 + Math.random() * 9000);
            $clone.find('.exdate').attr('id', newid);
            $clone.find('.exdate').removeClass('hasDatepicker');

            var date1 = new Date();
            var newdate1 = new Date(date1);

            newdate1.setDate(newdate1.getDate() + parseInt($tr.find('#tdexpdatecutoff').html()));

            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            var val1 = newdate1.getDate() + "-" + months[newdate1.getMonth()] + "-" + newdate1.getFullYear();
            var newid = Math.floor(1000 + Math.random() * 9000);
            $clone.find('.exdate').attr('id', newid);
            $clone.find('.exdate').removeClass('hasDatepicker');

            $clone.find('#' + newid).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-0:+20", minDate: val1

            });


            $clone.css("background-color", "yellow");
            $tr.after($clone);


            // tablefuncation();
        }


        function showmybarcode(ctrl) {

            var barcodeno = $(ctrl).val();
            var barcodeoption = $(ctrl).closest('tr').find('#tdBarcodeOption').html();
            var itemid = $(ctrl).closest('tr').find('#tditemid').html();
           

            serverCall('GrnFromPo.aspx/checkmybarcode', { barcodeno: barcodeno, barcodeoption: barcodeoption, itemid: itemid }, function (response) {
                var data = response;
                if (data.split('#')[0] == "0") {//Error
                    $(ctrl).val('');
                    $(ctrl).focus();
                    $(ctrl).closest('tr').find('#mmc').hide();
                    toast("Error", "Barcode No Already Used By Another Item", "");

                }
                else if (data.split('#')[0] == "1") {//Validate With No BatchNumber
                    toast("Error", "Barcode No Validate", "");
                    $(ctrl).closest('tr').find('#txtbacknumber').val('');
                    $(ctrl).closest('tr').find('.exdate').val('');
                    $(ctrl).closest('tr').find('#txtbacknumber').focus();
                }
                else if (data.split('#')[0] == "2") {// Validate With BatchNumber
                    $(ctrl).closest('tr').find('#mmc').show();
                    $(ctrl).closest('tr').find('#txtbacknumber').val(data.split('#')[1].split('^')[0]);
                    $(ctrl).closest('tr').find('.exdate').val(data.split('#')[1].split('^')[1]);
                    toast("Error", "Barcode No Validate", "");
                }

            });
            
        }

        function showmeqty(ctrl) {


            if ($(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }

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

            var sendqty = $(ctrl).closest('tr').find('#sppaidqty').html();
            var paidqty = $(ctrl).val();

            if (parseFloat(paidqty) > parseFloat(sendqty)) {
                toast("Error", "Receive Qty Can't Greater Then " + sendqty);
                $(ctrl).val(sendqty);
                return;
            }
        }
        function showmefreeqty(ctrl) {
            if ($(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "0") {
                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
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
            var sendqty = $(ctrl).closest('tr').find('#spfreeqty').html();
            var paidqty = $(ctrl).val();

            if (parseFloat(paidqty) > parseFloat(sendqty)) {
                toast("Error", "Receive Qty Can't Greater Then " + sendqty);
                $(ctrl).val(sendqty);
                return;
            }
        }
        function CalBuyPrice(ctrl) {
            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));
            var Quantity = $(ctrl).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtQuantity").val());
            var Rate = $(ctrl).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtRate").val());
            var Disc = $(ctrl).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtDiscountper").val());
            if (Disc > 100) {
                $(ctrl).closest("tr").find("#txtDiscountper").val('100');
                Disc = 100;
            }
            var IGSTPer = $(ctrl).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtIGSTpe").val());
            var CGSTPer = $(ctrl).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtCGSTper").val());
            var SGSTPer = $(ctrl).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtSGSTper").val());
            var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;
            var disc = precise_round((Rate * Disc * 0.01), 5);
            var ratedisc = precise_round((Rate - disc), 5);
            var tax = precise_round((ratedisc * Tax * 0.01), 5);
            var ratetaxincludetax = precise_round((ratedisc + tax), 5);
            var discountAmout = precise_round(disc, 5);
            var TaxAmount = precise_round(tax, 5);
            $(ctrl).closest("tr").find("#txtDiscountAmount").val(discountAmout);
            $(ctrl).closest("tr").find("#txtTotalGSTAmount").val(TaxAmount);
            $(ctrl).closest("tr").find("#txtBuyPrice").val(ratetaxincludetax);
            var NetAmount = precise_round((($(ctrl).closest("tr").find("#txtBuyPrice").val()) * Quantity), 5);
            $(ctrl).closest("tr").find("#txtNetAmt").val(NetAmount);
            getgrnamount();
        }
        function getgrnamount() {
            var NetAmount = 0;
            var GrossAmount = 0;
            var DiscAmount = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != 'triteheader') {
                    var Quantity = $(this).find("#txtQuantity").val() == "" ? 0 : parseFloat($(this).find("#txtQuantity").val());
                    var Rate = $(this).find("#txtRate").val() == "" ? 0 : parseFloat($(this).find("#txtRate").val());
                    var Disc = $(this).find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).find("#txtDiscountper").val());
                    var IGSTPer = $(this).find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).find("#txtIGSTpe").val());
                    var CGSTPer = $(this).find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).find("#txtCGSTper").val());
                    var SGSTPer = $(this).find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).find("#txtSGSTper").val());
                    var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;
                    var disc = precise_round((Rate * Disc * 0.01), 5);
                    var ratedisc = precise_round((Rate - disc), 5);
                    var tax = precise_round((ratedisc * Tax * 0.01), 5);
                    var ratetaxincludetax = precise_round((ratedisc + tax), 5);
                    var discountAmout = precise_round(disc, 5);
                    var TaxAmount = precise_round(tax, 5);
                    NetAmount += precise_round((($(this).find("#txtBuyPrice").val()) * Quantity), 5);
                    DiscAmount += discountAmout;
                }
            });
            var Freight = $('#<%=txtFreight.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtFreight.ClientID %>').val());
            var Octori = $('#<%=txtOctori.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtOctori.ClientID %>').val());
            var RoundOff = $('#<%=txtRoundOff.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtRoundOff.ClientID %>').val());
            var totalamt = parseFloat(NetAmount) + parseFloat(Freight) + parseFloat(Octori) + parseFloat(RoundOff);
            totalamt = precise_round(totalamt, 5);
            $('#<%=txtInvoiceAmount.ClientID %>').val(totalamt);
            $('#<%=txtgrnamount.ClientID %>').val(totalamt);
        }
        </script>
        <script type="text/javascript">
            function clearform() {
                $('#chkbarcode').prop('checked', false);
                filename = "";
                $('#tblitemlist tr').slice(1).remove();
                $('.hidemeonload').hide();
                $('#<%=lbpodate.ClientID%>').html('');
            $('#<%=lbponumber.ClientID%>').html('');
            $('#<%=lbpoid.ClientID%>').html('');
            $('#<%=lblvendorid.ClientID%>').html('');
            $('#<%=lblvendorname.ClientID%>').html('');
            $('#<%=lblposubject.ClientID%>').html('');
            $('#<%=lbvendorlogin.ClientID%>').html('');
            $('#<%=ddllocation.ClientID%>').prop("disabled", false);
            $('#<%=ddlpurchaseorder.ClientID%>').prop("disabled", false);
            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlpurchaseorder.ClientID%>').trigger('chosen:updated');
            $('#<%=txtinvoiceno.ClientID%>').val('');
            $('#<%=txtchallanno.ClientID%>').val('');
            $('#<%=txtgateentryno.ClientID%>').val('');
            $('#<%=txtNarration.ClientID%>').val('');
            $('#<%=txtFreight.ClientID%>').val('0');
            $('#<%=txtOctori.ClientID%>').val('0');
            $('#<%=txtRoundOff.ClientID%>').val('0');
            $('#<%=txtgrnamount.ClientID%>').val('0');
            $('#<%=txtInvoiceAmount.ClientID%>').val('0');

            //var date = new Date();
            //var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
            //   "Aug", "Sep", "Oct", "Nov", "Dec"];

            //var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $('#<%=txtinvoicedate.ClientID%>').val('');
            $('#<%=txtchallandate.ClientID%>').val('');

            bindorder();
        }
        </script>
        <script type="text/javascript">
            function validation() {
                var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlpurchaseorder.ClientID%>').val() == "0") {
                toast("Error", "Please Select Order", "");
                $('#<%=ddlpurchaseorder.ClientID%>').focus();
                return false;
            }
            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Select Item ", "");
                $('#txtitem').focus();
                return false;
            }

            var sn11 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var rate = $(this).find('#txtbacknumber').val() == "" ? 0 : parseFloat($(this).find('#txtbacknumber').val());
                    if (rate == 0) {
                        sn11 = 1;
                        $(this).find('#txtbacknumber').focus();
                        return;
                    }
                }
            });
            if (sn11 == 1) {
                toast("Error", "Please Enter BatchNumber", "");
                return false;
            }

            var sn111 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {



                    if ($(this).find("#tdIsExpirable").html() == "1" && $(this).find(".exdate").val() == "") {
                        sn111 = 1;
                        $(this).find('.exdate').focus();
                        return;
                    }
                }
            });

            if (sn111 == 1) {
                toast("Error", "Please Enter Expiry Date", "");
                return false;
            }


            var sn = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var rate = $(this).find('#txtRate').val() == "" ? 0 : parseFloat($(this).find('#txtRate').val());


                    if (rate == 0) {
                        sn = 1;
                        $(this).find('#txtRate').focus();
                        return;
                    }
                }
            });

            if (sn == 1) {

            }

            var sn1 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var qty = $(this).find('#txtQuantity').val() == "" ? 0 : parseFloat($(this).find('#txtQuantity').val());
                    var qty1 = $(this).find('#txtFreeQty').val() == "" ? 0 : parseFloat($(this).find('#txtFreeQty').val());
                    if (qty == 0 && qty1 == 0) {
                        sn1 = 1;
                        //$(this).find('#txtQuantity').focus();

                        return;
                    }
                }
            });

            if (sn1 == 1) {
                toast("Error", "Please Enter Quantity", "");
                return false;
            }

            if ($('#<%=txtinvoiceno.ClientID %>').val() == "" && $('#<%=txtchallanno.ClientID %>').val() == "") {
                toast("Error", "Please Enter Invoice No. or Chalan No.", "");
                return false;
            }


            if ($('#<%=txtinvoicedate.ClientID %>').val() == "" && $('#<%=txtchallandate.ClientID %>').val() == "") {
                toast("Error", "Please Enter Invoice Date or Chalan Date", "");
                return false;
            }



            if (filename == "") {
                toast("Error", "Please Upload Invoice", "");

                return false;
            }
            return true;
        }
        function getst_ledgertransaction() {
            var TaxAmount = 0;
            var DiscountAmount = 0;
            var GrossAmt = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != 'triteheader') {
                    var Quantity = $(this).find("#txtQuantity").val() == "" ? 0 : parseFloat($(this).find("#txtQuantity").val());
                    TaxAmount += precise_round((($(this).find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).find("#txtTotalGSTAmount").val())) * Quantity), 5);
                    DiscountAmount += precise_round((($(this).find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).find("#txtDiscountAmount").val())) * Quantity), 5);
                    GrossAmt += precise_round((($(this).find("#txtRate").val() == "" ? 0 : parseFloat($(this).find("#txtRate").val())) * Quantity), 5);
                }
            });
            var objst_ledgertransaction = new Object();
            objst_ledgertransaction.LedgerTransactionID = "0";
            objst_ledgertransaction.LedgerTransactionNo = "";
            objst_ledgertransaction.VendorID = $('#<%=lblvendorid.ClientID%>').html();
            objst_ledgertransaction.TypeOfTnx = "Purchase";
            objst_ledgertransaction.PurchaseOrderNo = $('#<%=lbponumber.ClientID%>').html();
            objst_ledgertransaction.GrossAmount = GrossAmt;
            objst_ledgertransaction.DiscountOnTotal = DiscountAmount;
            objst_ledgertransaction.TaxAmount = TaxAmount;

            objst_ledgertransaction.NetAmount = $('#<%=txtgrnamount.ClientID%>').val();
            objst_ledgertransaction.InvoiceAmount = $('#<%=txtInvoiceAmount.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtInvoiceAmount.ClientID%>').val());
            objst_ledgertransaction.InvoiceNo = $('#<%=txtinvoiceno.ClientID%>').val();
            objst_ledgertransaction.InvoiceDate = $('#<%=txtinvoicedate.ClientID%>').val();
            objst_ledgertransaction.InvoiceAttachment = "0";
            objst_ledgertransaction.ChalanNo = $('#<%=txtchallanno.ClientID%>').val();
            objst_ledgertransaction.ChalanDate = $('#<%=txtchallandate.ClientID%>').val();

            objst_ledgertransaction.DiscountReason = "";
            objst_ledgertransaction.Remarks = $('#<%=txtNarration.ClientID%>').val();

            objst_ledgertransaction.IndentNo = "";
            objst_ledgertransaction.Freight = $('#<%=txtFreight.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtFreight.ClientID%>').val());
            objst_ledgertransaction.Octori = $('#<%=txtOctori.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtOctori.ClientID%>').val());
            objst_ledgertransaction.GatePassInWard = $('#<%=txtgateentryno.ClientID%>').val();
            objst_ledgertransaction.GatePassOutWard = "";
            objst_ledgertransaction.IsReturnable = "0";
            objst_ledgertransaction.RoundOff = $('#<%=txtRoundOff.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtRoundOff.ClientID%>').val());
            objst_ledgertransaction.LocationID = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

            objst_ledgertransaction.IsDirectGRN = "0";
            return objst_ledgertransaction;
        }

        function getst_nmstock() {

            var datastock = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {


                    var objStockMaster = new Object();

                    objStockMaster.StockID = "0";
                    objStockMaster.ItemID = id;
                    objStockMaster.ItemName = $(this).find("#tditemname").html();
                    objStockMaster.LedgerTransactionID = "0";
                    objStockMaster.LedgerTransactionNo = "";
                    objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                    objStockMaster.Rate = $(this).find("#txtRate").val();
                    objStockMaster.DiscountPer = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());;
                    objStockMaster.DiscountAmount = $(this).closest("tr").find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountAmount").val());
                    var IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                    var CGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                    var SGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());



                    var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;


                    objStockMaster.TaxPer = Tax;
                    objStockMaster.TaxAmount = $(this).closest("tr").find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGSTAmount").val());
                    objStockMaster.UnitPrice = $(this).closest("tr").find("#txtBuyPrice").val();
                    objStockMaster.MRP = $(this).find("#txtRate").val();


                    var qty = $(this).find("#tdconverter").html() * $(this).find("#txtQuantity").val();
                    objStockMaster.InitialCount = qty;

                    objStockMaster.ReleasedCount = "0";
                    objStockMaster.PendingQty = "0";
                    objStockMaster.RejectQty = "0";


                    objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                    objStockMaster.Naration = $('#<%=txtNarration.ClientID%>').val();
                    objStockMaster.IsFree = "0";

                    objStockMaster.LocationID = $(this).find("#tdlocationid").html();
                    objStockMaster.Panel_Id = $(this).find("#tdpanelid").html();

                    objStockMaster.IndentNo = "";
                    objStockMaster.FromLocationID = "0";
                    objStockMaster.FromStockID = "0";
                    objStockMaster.Reusable = "0";
                    objStockMaster.ManufactureID = $(this).find("#tdmanufaid").html();
                    objStockMaster.MacID = $(this).find("#tdmacid").html();
                    objStockMaster.MajorUnitID = $(this).find("#tdmajorunitid").html();
                    objStockMaster.MajorUnit = $(this).find("#tdmajorunitname").html();
                    objStockMaster.MinorUnitID = $(this).find("#tdminorunitid").html();
                    objStockMaster.MinorUnit = $(this).find("#tdminorunitname").html();
                    objStockMaster.Converter = $(this).find("#tdconverter").html();
                    objStockMaster.Remarks = "GRN Paid Item";

                    objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                    objStockMaster.PackSize = $(this).find("#tdPackSize").html();
                    objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                    objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                    objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                    objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                    objStockMaster.BarcodeNo = $(this).find('#txtbarcodeno').val();
                    objStockMaster.MajorUnitInDecimal = $(this).find('#tdMajorUnitInDecimal').html();
                    objStockMaster.MinorUnitInDecimal = $(this).find('#tdMinorUnitInDecimal').html();

                    if (qty > 0) {
                        datastock.push(objStockMaster);
                    }
                    var freeqty = $(this).closest("tr").find("#txtFreeQty").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtFreeQty").val());
                    if (freeqty > 0) {
                        objStockMaster = new Object();

                        objStockMaster.StockID = "0";
                        objStockMaster.ItemID = id;
                        objStockMaster.ItemName = $(this).find("#tditemname").html();
                        objStockMaster.LedgerTransactionID = "0";
                        objStockMaster.LedgerTransactionNo = "";
                        objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                        objStockMaster.Rate = 0;
                        objStockMaster.DiscountPer = 0;
                        objStockMaster.DiscountAmount = 0;

                        var IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                        var CGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                        var SGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());



                        var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;


                        objStockMaster.TaxPer = Tax;
                        objStockMaster.TaxAmount = 0;
                        objStockMaster.UnitPrice = 0;
                        objStockMaster.MRP = 0;


                        var qty = $(this).find("#tdconverter").html() * freeqty;
                        objStockMaster.InitialCount = qty;

                        objStockMaster.ReleasedCount = "0";
                        objStockMaster.PendingQty = "0";
                        objStockMaster.RejectQty = "0";


                        objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                        objStockMaster.Naration = $('#<%=txtNarration.ClientID%>').val();
                        objStockMaster.IsFree = "1";

                        objStockMaster.LocationID = $(this).find("#tdlocationid").html();
                        objStockMaster.Panel_Id = $(this).find("#tdpanelid").html();

                        objStockMaster.IndentNo = "";
                        objStockMaster.FromLocationID = "0";
                        objStockMaster.FromStockID = "0";
                        objStockMaster.Reusable = "0";
                        objStockMaster.ManufactureID = $(this).find("#tdmanufaid").html();
                        objStockMaster.MacID = $(this).find("#tdmacid").html();
                        objStockMaster.MajorUnitID = $(this).find("#tdmajorunitid").html();
                        objStockMaster.MajorUnit = $(this).find("#tdmajorunitname").html();
                        objStockMaster.MinorUnitID = $(this).find("#tdminorunitid").html();
                        objStockMaster.MinorUnit = $(this).find("#tdminorunitname").html();
                        objStockMaster.Converter = $(this).find("#tdconverter").html();
                        objStockMaster.Remarks = "GRN Free Item";
                        objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                        objStockMaster.PackSize = $(this).find("#tdPackSize").html();
                        objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                        objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                        objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                        objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                        objStockMaster.BarcodeNo = $(this).find('#txtbarcodeno').val();
                        objStockMaster.MajorUnitInDecimal = $(this).find('#tdMajorUnitInDecimal').html();
                        objStockMaster.MinorUnitInDecimal = $(this).find('#tdMinorUnitInDecimal').html();
                        datastock.push(objStockMaster);
                    }


                }
            });

            return datastock;
        }

        function get_taxdata() {

            var datatax = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                var batchnumber = $(this).find("#txtbacknumber").val();
                if (id != "triteheader") {
                    var IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                    var CGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                    var SGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());
                    if (parseFloat(IGSTPer) > 0) {
                        CGSTPer = 0;
                        SGSTPer = 0;
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "IGST";
                        objtax.Percentage = IGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = IGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(CGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "CGST";
                        objtax.Percentage = CGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = CGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(SGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "SGST";
                        objtax.Percentage = SGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = SGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }

                }
            });

            return datatax;
        }

        function savegrn() {
            if (validation() == false) {
                return;
            }
            var st_ledgertransaction = getst_ledgertransaction();
            var st_nmstock = getst_nmstock();
            var taxdata = get_taxdata();
            var PurchaseOrderID = $('#<%=lbpoid.ClientID%>').html();
            var vendorlogin = $('#<%=lbvendorlogin.ClientID%>').html();
            serverCall('GrnFromPo.aspx/savegrn', { st_ledgertransaction: st_ledgertransaction, st_nmstock: st_nmstock, taxdata: taxdata, filename: filename, PurchaseOrderID: PurchaseOrderID, vendorlogin: vendorlogin }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success", "GRN Saved Successfully", "");
                    window.open('GRNReceipt.aspx?GRNNO=' + response.split('#')[1]);
                    if ($('#chkbarcode').prop('checked') == true) {
                        openmypopupbarcode('GRNPrintbarcode.aspx?GRNNO=' + response.split('#')[1]);
                    }
                    clearForm();
                }
                else {
                    toast("Error", response.split('#')[1]);
                }
            });
        }
        function checkduplicatebatchno(ctrl) {
            var itemid = $(ctrl).closest('tr').find('#tditemid').html();
            var batchno = $(ctrl).val();
            if ($.trim(batchno) != "") {
                var a = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    var batchnumber = $(this).find("#txtbacknumber").val();
                    if (id == itemid && $.trim(batchno).toUpperCase() == $.trim(batchnumber).toUpperCase()) {
                        a = a + 1;
                    }
                });
                if (a > 1) {
                    $(ctrl).val('');
                    $(ctrl).focus();
                    toast("Error", "This Batch No. Already Exist");
                    return;
                }
                serverCall('StockPhysicalVerification.aspx/checkduplicatebatchno', { itemid: itemid, batchno: batchno, locationid: locationid }, function (response) {
                    ItemData = $.parseJSON(response);
                    if (ItemData.length > 0) {
                        $(ctrl).closest('tr').find('.exdate ').val(ItemData[0].ExpiryDate);
                    }
                    else {
                        $(ctrl).closest('tr').find('.exdate ').val('');
                    }
                });
            }
        }
        </script>
        <script type="text/javascript">

            var innerhtml = $('#trme').html();

            function checkpageaccess() {
                if ($('#<%=ddllocation.ClientID%>').val() != "0") {
                var res = CheckOtherStorePageAccess($('#<%=ddllocation.ClientID%>').val().split('#')[0]);
                if (res != "1") {
                    $('#trme').hide();
                    $('#trme').html('');
                    toast("Error", res);

                }
                else {
                    $('#trme').show();
                    $('#trme').html(innerhtml);


                }
            }
            else {
                $('#trme').show();
                $('#trme').html(innerhtml);


            }
        }



        function hideme(res) {
            $('#trme').hide();
            $('#trme').html('');



            toast("Error", res, "");
        }
        </script>
</asp:Content>

