<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectGRN.aspx.cs" Inherits="Design_Store_DirectGRN" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>

    <style type="text/css">
        #ContentPlaceHolder1_ddlitemmap_chosen {
            width: 800px !important;
        }
    </style>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Direct GRN</b>
        </div>

        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">GRN Detail</div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">GRN Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddllocation" runat="server" class="ddllocation chosen-select chosen-container" onchange="checkpageaccess()"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">Supplier   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlvendor" class="ddlvendor chosen-select chosen-container" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-8">
                    <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal" Enabled="false">
                        <asp:ListItem Value="1">Direct Rate</asp:ListItem>
                        <asp:ListItem Value="2" Selected="True">Quotation Rate</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>



            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Item</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <div class="ui-widget" style="display: inline-block;">
                        <input id="txtitem" style="text-transform: uppercase;width:316px"  type="text"/>
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Item</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblItemName" runat="server"></asp:Label>
                    <asp:Label ID="lblItemGroupID" runat="server" Style="display: none;"></asp:Label>
                    <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Old PO No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtoldpono" runat="server" placeholder="Enter OLD PO Number" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Manufacturer</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');">
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Machine</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlMachine" runat="server" onchange="bindTempData('PackSize');"></asp:DropDownList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Pack Size</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPackSize" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>
                </div>
            </div>

            <div class="row" id="trme1">
                <div class="col-md-3">
                    <label class="pull-left">Barcode</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtbarcodeno" runat="server" placeholder="Scan Barcode For Quick GRN" BackColor="lightyellow" Style="border: 1px solid red;" Font-Bold="true"></asp:TextBox>
                </div>

                <div class="col-md-2">
                </div>
                <div class="col-md-5">
                    <input type="button" value="Add" class="searchbutton" onclick="Addme()" />
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div style="width: 100%; max-height: 250px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">

                                <td class="GridViewHeaderStyle">New<br />
                                    Batch</td>
                                <td class="GridViewHeaderStyle">Item Type</td>
                                <td class="GridViewHeaderStyle">ItemId</td>
                                <td class="GridViewHeaderStyle">Item Name</td>
                                <td class="GridViewHeaderStyle">Item Code</td>
                                <td class="GridViewHeaderStyle">Hsn Code</td>
                                <td class="GridViewHeaderStyle">Purchased Unit</td>
                                <td class="GridViewHeaderStyle">Conv erter</td>
                                <td class="GridViewHeaderStyle">Consume Unit</td>
                                <td class="GridViewHeaderStyle">Barcode</td>
                                <td class="GridViewHeaderStyle">Batch Number</td>
                                <td class="GridViewHeaderStyle">Expiry Date</td>
                                <td class="GridViewHeaderStyle">Rate</td>
                                <td class="GridViewHeaderStyle">Paid Qty.</td>
                                <td class="GridViewHeaderStyle">Extra Free Qty.</td>
                                <td class="GridViewHeaderStyle">Discount %</td>
                                <td class="GridViewHeaderStyle">IGST %</td>
                                <td class="GridViewHeaderStyle">CGST %</td>
                                <td class="GridViewHeaderStyle">SGST %</td>
                                <td class="GridViewHeaderStyle">Dis. Amt.</td>
                                <td class="GridViewHeaderStyle">Total GST Amt.</td>
                                <td class="GridViewHeaderStyle">BuyPrice</td>
                                <td class="GridViewHeaderStyle">Net Amt.</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>

                            </tr>
                        </table>

                    </div>
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory">

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
        <div class="POuter_Box_Inventory" style="text-align: center;" id="trme">
            <div class="row">
                <div class="col-md-24">
            <input type="checkbox" id="chkbarcode" title="Check To Print Barcode" checked="checked" /><strong>Print Barcode</strong>
            <input type="button" value="Save" class="savebutton" onclick="savegrn();" id="Button1" />
            <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                    </div>
        </div>
        </div>
    </div>
    <div id="popup_box" style="background-color: lightgreen; height: 80px; text-align: center; width: 340px;">
        <div id="showpopupmsg" style="font-weight: bold;"></div>
        <br />
        <span id="barcodeno" style="display: none;"></span>
        <input type="button" class="searchbutton" value="Yes" onclick="MapItemWithbarcode();" />
        <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>
    <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="1100px">
        <div class="Purchaseheader">
            Item Detail
        </div>
        <table width="99%">
            <tr>
                <td>Select Item:</td>
                <td>

                    <span style="color: red;">* Only Self Genrated barcode Items(Not System Genrated)</span>
                    <br />
                    <asp:DropDownList ID="ddlitemmap" class="ddlitem chosen-select chosen-container" runat="server" Width="800px"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>Barcode No:</td>
                <td>
                    <asp:TextBox ID="txtbarcodenomap" runat="server" ReadOnly="true"></asp:TextBox>
                </td>
            </tr>


        </table>


        <center>
            <input type="button" value="Map" class="searchbutton" onclick="savenewbarcode()" />&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Cancel" />
        </center>

    </asp:Panel>

    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button2" runat="server" Style="display: none" />
    <script type="text/javascript">

        var filename = "";

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
        function openmypopup(href) {

            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Select Item  ", "");
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
        function unloadPopupBox() {
            $('#barcodeno').html('');
            $('#<%=txtbarcodeno.ClientID%>').val('');
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            $('#<%=txtbarcodeno.ClientID%>').focus();
        }
        function openmapdialog() {
            $('#showpopupmsg').show();
            var msg = "Barcode No :- " + $('#<%=txtbarcodeno.ClientID%>').val() + " Not  Mapped With Any Item.Do You Want To Map?";
            $('#showpopupmsg').html(msg);
            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            $('#barcodeno').html($('#<%=txtbarcodeno.ClientID%>').val());
        }
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
            bindvendor();
        });
        function bindvendor() {
            var dropdown = $("#<%=ddlvendor.ClientID%>");
            $("#<%=ddlvendor.ClientID%> option").remove();
            serverCall('Services/StoreCommonServices.asmx/bindsupplier', {}, function (response) {
                if (JSON.parse(response).length == 0) {
                    dropdown.append($("<option></option>").val("0").html("--No Supplier Found--"));
                    dropdown.trigger('chosen:updated');
                }
                else
                    dropdown.bindDropDown({ defaultValue: 'Select Supplier', data: JSON.parse(response), valueField: 'supplierid', textField: 'suppliername', isSearchAble: true });
            });            
        }
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        function Addme() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier", "");
                $('#<%=ddlvendor.ClientID%>').focus();
                return;
            }
            if ($('#<%=lblItemID.ClientID%>').html() == "") {
                toast("Error", "Please Select Item", "");
                $('#<%=ddlPackSize.ClientID%>').focus();
                return;
            }
            AddItem($('#<%=lblItemID.ClientID%>').html(), "");
        }
        function clearTempData() {
            $("#<%=ddlManufacturer.ClientID %> option").remove();
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            $("#<%=lblItemID.ClientID %>").html('');
            $("#<%=lblItemGroupID.ClientID %>").html('');
            $("#<%=lblItemName.ClientID %>").html('');
        }
        function AddItem(itemid, barcodeno) {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier");
                $('#<%=ddlvendor.ClientID%>').focus();
                return;
            }
            var qtype = $("#<%=rd.ClientID%>").find(":checked").val();
           
            serverCall('DirectGRN.aspx/SearchItemDetail', { itemid:itemid , qtype:qtype , locationid: $('#<%=ddllocation.ClientID%>').val() , barcodeno: barcodeno , vendorid: $('#<%=ddlvendor.ClientID%>').val() }, function (response) {
                if (response == "-1") {
                    openmapdialog();
                    return;
                }
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("info", "No Item Found","");
                }
                else {
                    if ($('table#tblitemlist').find('#' + ItemData[0].itemid).length > 0) {
                        toast("Error", "Item Already Added","");
                        return;
                    }

                    var $myData = [];

                    $myData.push("<tr style='background-color:bisque;' id='");$myData.push( ItemData[0].itemid);$myData.push("' class='tr_clone'>");
                    $myData.push('<td class="GridViewLabItemStyle" >');
                    if (ItemData[0].BarcodeOption == "1" && ItemData[0].BarcodeGenrationOption == "1") {

                    }
                    else {
                        $myData.push(' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addmenow(this);" />');
                    }
                    $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tditemgroupname">');$myData.push(ItemData[0].itemgroup); $myData.push('</td>');
                    $myData.push('<td style="font-weight:bold;" id="tditemid1">');$myData.push( ItemData[0].itemid ); $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tditemname">');$myData.push( ItemData[0].typename); $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tdapolloitemcode">' );$myData.push( ItemData[0].apolloitemcod); $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tdHsnCode">');$myData.push( ItemData[0].HsnCode); $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tdmajorunitname">');$myData.push( ItemData[0].MajorUnitName); $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" id="tdconverter">');$myData.push( ItemData[0].Converter); $myData.push('</td>');
                    $myData.push('<td  class="GridViewLabItemStyle" id="tdmajorunitname">');$myData.push( ItemData[0].MinorUnitName); $myData.push('</td>');


                    $myData.push('<td class="GridViewLabItemStyle" >');
                    if (ItemData[0].BarcodeGenrationOption == "1") {
                        if (newbarcodeno != "") {
                            ItemData[0].barcodeno = newbarcodeno;
                        }
                        $myData.push('<input type="text" id="txtbarcodeno" style="width:100px;" value="');$myData.push(ItemData[0].barcodeno);$myData.push('" />');
                    }
                    else {
                        $myData.push('<input type="text" id="txtbarcodeno" style="width:100px;" readonly="readonly" />');
                    }
                    $myData.push('</td>');
                    $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" onblur="checkduplicatebatchno(this)" style="width:100px;" /></td>');




                    if (ItemData[0].IsExpirable == "0") {
                        $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate');$myData.push(ItemData[0].itemid);$myData.push(ItemData[0].IsExpirable); $myData.push('" style="width:90px;" class="exdate" readonly="readonly"  /></td>');
                    }
                    else {
                        $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate');$myData.push( ItemData[0].itemid);$myData.push('" style="width:90px;" class="exdate" readonly="readonly" /></td>');
                    }


                    $myData.push('<td align="left" id="tdRate"><input type="text"  style="width:60px" readonly="readonly" id="txtRate" value="');$myData.push( precise_round(ItemData[0].Rate, 5)); $myData.push('" onkeyup="CalBuyPrice(this);"/></td>');
                    $myData.push('<td align="left" id="tdQuantity"><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showme(this);CalBuyPrice(this);"/></td>');
                    $myData.push('<td align="left" id="tdFreeQty"><input type="text"  style="width:60px" id="txtFreeQty" onkeyup="showme(this);"/></td>');
                    $myData.push('<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" value="');$myData.push( precise_round(ItemData[0].DiscountPer, 5)); $myData.push('" onkeyup="CalBuyPrice(this);"/></td>');
                    $myData.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" value="');$myData.push( precise_round(ItemData[0].IGSTPer, 5) ); $myData.push('"  onkeyup="CalBuyPrice(this);"/></td>');
                    $myData.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" value="');$myData.push( precise_round(ItemData[0].CGSTPer, 5)); $myData.push('"  onkeyup="CalBuyPrice(this);" /></td>');
                    $myData.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" value="');$myData.push( precise_round(ItemData[0].SGSTPer, 5)); $myData.push('"  onkeyup="CalBuyPrice(this);" /></td>');


                    $myData.push('<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>');
                    $myData.push('<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>');
                    $myData.push('<td align="left" id="tdBuyPrice"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>');
                    $myData.push('<td align="left" id="tdNetAmt"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>');

                    $myData.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');


                    $myData.push('<td style="display:none;" id="tditemid">');$myData.push(ItemData[0].itemid);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdmajorunitid">');$myData.push( ItemData[0].MajorUnitId);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdminorunitid">');$myData.push( ItemData[0].MinorUnitId);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdmanufaid">');$myData.push( ItemData[0].ManufactureID);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdmacid">');$myData.push( ItemData[0].MachineID );$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdlocationid">');$myData.push( ItemData[0].LocationId );$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdpanelid">' );$myData.push( ItemData[0].panelid );$myData.push('</td>');

                    $myData.push('<td style="display:none;" id="tdIsExpirable">' );$myData.push( ItemData[0].IsExpirable);$myData.push( '</td>');
                    $myData.push('<td style="display:none;" id="tdPackSize">' );$myData.push( ItemData[0].PackSize);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdBarcodeOption">' );$myData.push( ItemData[0].BarcodeOption);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdBarcodeGenrationOption">');$myData.push( ItemData[0].BarcodeGenrationOption);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdIssueInFIFO">');$myData.push( ItemData[0].IssueInFIFO);$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdIssueMultiplier">' );$myData.push( ItemData[0].IssueMultiplier );$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdMajorUnitInDecimal">' );$myData.push( ItemData[0].MajorUnitInDecimal );$myData.push('</td>');
                    $myData.push('<td style="display:none;" id="tdMinorUnitInDecimal">' );$myData.push( ItemData[0].MinorUnitInDecimal );$myData.push( '</td>');

                    $myData.push('<td style="display:none;" id="tdexpdatecutoff">');$myData.push(ItemData[0].expdatecutoff);$myData.push('</td>');
                    $myData.push("</tr>");
                    $myData = $myData.join("");
                    $('#tblitemlist').append($myData);
                    var date = new Date();
                    var newdate = new Date(date);
                    newdate.setDate(newdate.getDate() + parseInt(ItemData[0].expdatecutoff));
                    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];
                    var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();
                    $("#txtexpirydate" + ItemData[0].itemid).datepicker({
                        dateFormat: "dd-M-yy",
                        changeMonth: true,
                        changeYear: true, yearRange: "-0:+20", minDate: val
                    });
                    getgrnamount();
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                        stockitemid = "";
                        newbarcodeno = "";
                        clearTempData();

                        $('#<%=ddllocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');
                    $('#<%=ddlvendor.ClientID%>').prop("disabled", true);
                    $('#<%=ddlvendor.ClientID%>').trigger('chosen:updated');
                }
            });           
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
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];
            var val1 = newdate1.getDate() + "-" + months[newdate1.getMonth()] + "-" + newdate1.getFullYear();
            $clone.find('#' + newid).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-0:+20", minDate: val1
            });
            $clone.css("background-color", "yellow");
            $tr.after($clone);
            // tablefuncation();
        }
        function showme(ctrl) {
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
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
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
        function deleterow(itemid) {
            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            getgrnamount();

        }
    </script>


    <script type="text/javascript">
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
        function validation() {

            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }


            if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier","");
                $('#<%=ddlvendor.ClientID%>').focus();
                return false;
            }


            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Select Item ","");
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
                toast("Error", "Please Enter BatchNumber","");
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
                toast("Error", "Please Enter Expiry Date","");
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
                    if (qty == 0) {
                        sn1 = 1;
                        $(this).find('#txtQuantity').focus();

                        return;
                    }
                }
            });

            if (sn1 == 1) {
                toast("Error", "Please Enter Quantity","");
                return false;
            }

            if ($('#<%=txtinvoiceno.ClientID %>').val() == "" && $('#<%=txtchallanno.ClientID %>').val() == "") {
                toast("Error", "Please Enter Invoice No or Chalan No.","");
                return false;
            }

            if ($('#<%=txtinvoicedate.ClientID %>').val() == "" && $('#<%=txtchallandate.ClientID %>').val() == "") {
                toast("Error", "Please Enter Invoice Date or Chalan Date","");
                return false;
            }

            if ($.trim($('#<%=txtoldpono.ClientID%>').val()) == "") {
                toast("Error", "Please Enter OLD PO Number","");
                $('#<%=txtoldpono.ClientID%>').focus();
                return false;
            }

            if (filename == "") {
                toast("Error", "Please Upload Invoice","");
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
            objst_ledgertransaction.VendorID = $('#<%=ddlvendor.ClientID%>').val();
            objst_ledgertransaction.TypeOfTnx = "Purchase";
            objst_ledgertransaction.PurchaseOrderNo = $('#<%=txtoldpono.ClientID%>').val();
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

            objst_ledgertransaction.IsDirectGRN = "1";
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
                    objStockMaster.Remarks = "Direct GRN Paid Item";
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
                        objStockMaster.TaxPer = 0;
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
                        objStockMaster.Remarks = "Direct GRN Free Item";
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
            serverCall('DirectGRN.aspx/savedirectgrn', {st_ledgertransaction: st_ledgertransaction, st_nmstock: st_nmstock, taxdata: taxdata, filename: filename  }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success", "GRN Saved Successfully", "");
                    window.open('GRNReceipt.aspx?GRNNO=' + response.split('#')[1]);
                    if ($('#chkbarcode').prop('checked') == true) {
                        openmypopupbarcode('GRNPrintbarcode.aspx?GRNNO=' + response.split('#')[1]);
                    }
                    clearForm();
                }
                else
                {
                    toast("Error", response.split('#')[1]);
                }
            });         
        }
    </script>
    <script type="text/javascript">
        function clearForm() {
            $('#chkbarcode').prop('checked', true);
            filename = "";
            $('#<%=txtoldpono.ClientID%>').val('');
            $('#<%=txtbarcodeno.ClientID%>').val('');
            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlvendor.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlvendor.ClientID%>').trigger('chosen:updated');
            $('#<%=rd.ClientID %>').find("input[value='2']").prop("checked", true);
            $('#tblitemlist tr').slice(1).remove();
            $('#<%=txtinvoiceno.ClientID%>,#<%=txtchallanno.ClientID%>,#<%=txtgateentryno.ClientID%>').val('');
            $('#<%=txtNarration.ClientID%>').val('');
            $('#<%=txtFreight.ClientID%>').val('0');
            $('#<%=txtOctori.ClientID%>').val('0');
            $('#<%=txtRoundOff.ClientID%>').val('0');
            $('#<%=txtgrnamount.ClientID%>').val('0');
            $('#<%=txtInvoiceAmount.ClientID%>').val('0');
            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];
            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $('#<%=txtinvoicedate.ClientID%>').val('');
            $('#<%=txtchallandate.ClientID%>').val('');
            $('#txtitem').val('');
            $('#<%=ddllocation.ClientID%>').prop("disabled", false);
            $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlvendor.ClientID%>').prop("disabled", false);
            $('#<%=ddlvendor.ClientID%>').trigger('chosen:updated');
            clearTempData();
        }
    </script>
    <script type="text/javascript">

        function binditem1() {
            var dropdown = $("#<%=ddlitemmap.ClientID%>");
            $("#<%=ddlitemmap.ClientID%> option").remove();
            serverCall('StockPhysicalVerification.aspx/binditem', { locationid: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                if(JSON.parse(response).length==0)
                {
                    dropdown.append($("<option></option>").val("0").html("--No Item Found--"));
                    dropdown.trigger('chosen:updated');                
                }
                else
                    dropdown.bindDropDown({ data: JSON.parse(response), valueField: 'itemid', textField: 'typename', isSearchAble: true, defaultValue: "Select" });
            });          
        }
        function MapItemWithbarcode() {
            $('#<%=txtbarcodenomap.ClientID%>').val($('#<%=txtbarcodeno.ClientID%>').val());
            unloadPopupBox();
            binditem1();
            $find("<%=modelpopup1.ClientID%>").show();
        }
        var stockitemid = "";
        var newbarcodeno = "";
        function savenewbarcode() {
            if ($('#<%=ddlitemmap.ClientID%>').val() == "0") {
                toast("Error", "Please Select Item","");
                $('#<%=ddlitemmap.ClientID%>').focus();
                 return;
             }
            serverCall('StockPhysicalVerification.aspx/savebarcode', { itemid:$('#<%=ddlitemmap.ClientID%>').val(),barcodeno:$('#<%=txtbarcodenomap.ClientID%>').val()}, function (response) {
                var type = response;
                $find("<%=modelpopup1.ClientID%>").hide();

                toast("Success", "Barcode Mapped", "");
                if (type == "1") {
                    $('#<%=txtbarcodeno.ClientID%>').val($('#<%=txtbarcodenomap.ClientID%>').val());
                        AddItem('', $('#<%=txtbarcodeno.ClientID%>').val());
                    }
                    else {
                        newbarcodeno = $('#<%=txtbarcodenomap.ClientID%>').val();
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                        stockitemid = $('#<%=ddlitemmap.ClientID%>').val().split('#')[0];

                        AddItem(stockitemid, '');
                    }
            });             
        }
    </script>
    <%-- bind item--%>
    <script type="text/javascript">
        $(function () {
            $("#<%= txtbarcodeno.ClientID%>").keydown(
         function (e) {
             var key = (e.keyCode ? e.keyCode : e.charCode);
             if (key == 13) {
                 e.preventDefault();
                 if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {
                     AddItem('', $.trim($('#<%=txtbarcodeno.ClientID%>').val()));
                 }
             }
         });
            $("#txtitem")
                      .bind("keydown", function (event) {
                          if (event.keyCode === $.ui.keyCode.TAB &&
                              $(this).autocomplete("instance").menu.active) {
                              event.preventDefault();
                          }
                      })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {
                              serverCall('DirectGRN.aspx/SearchItem', { itemname:extractLast(request.term),locationidfrom:$('#<%=ddllocation.ClientID%>').val()}, function (result) {

                                  response($.map(jQuery.parseJSON(result), function (item) {
                                      return {
                                          label: item.ItemNameGroup,
                                          value: item.ItemIDGroup
                                      }
                                  }))
                              });                             
                          },
                          search: function () {
                              var term = extractLast(this.value);
                              if (term.length < 2) {
                                  return false;
                              }
                          },
                          focus: function () {
                              return false;
                          },
                          select: function (event, ui) {
                              this.value = '';
                              setTempData(ui.item.value, ui.item.label);
                              return false;
                          },
                      });
        });
                  function split(val) {
                      return val.split(/,\s*/);
                  }
                  function extractLast(term) {
                      return split(term).pop();
                  }
                  function setTempData(ItemGroupID, ItemGroupName) {
                      $('#<%=lblItemGroupID.ClientID%>').html(ItemGroupID);
                      $('#<%=lblItemName.ClientID%>').html(ItemGroupName);
                      // $('#tblTemp').show();
                      bindTempData('Manufacturer');
                  }
        function bindTempData(bindType) {
            if (bindType == 'Manufacturer') {
                bindManufacturer($('#<%=lblItemGroupID.ClientID%>').html());
            }
            else if (bindType == 'Machine') {
                bindMachine($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val());
            }
            else if (bindType == 'PackSize') {
                bindPackSize($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val(), $("#<%=ddlMachine.ClientID %>").val());
            }             
        }
        function bindManufacturer(ItemIDGroup) {
            $("#<%=ddlManufacturer.ClientID %> option").remove();
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=ddllocation.ClientID%>').val();

            serverCall('DirectGRN.aspx/bindManufacturer', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup }, function (response) {

                if (JSON.parse(response).length == 0) {
                    $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val("0").html("--No Item Found--"));
                    $("#<%=ddlManufacturer.ClientID %>").trigger('chosen:updated');

                }
                else {
                    if ($.parseJSON(response).length > 1) {
                        $("#<%=ddlManufacturer.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'ManufactureID', textField: 'ManufactureName', isSearchAble: true, defaultValue: "Select" });

                    }
                    else {
                        $("#<%=ddlManufacturer.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'ManufactureID', textField: 'ManufactureName', isSearchAble: true });

                    }

                }
                var tempData = $.parseJSON(response);
               
                if (tempData.length == 1) {
                    bindMachine(ItemIDGroup, tempData[0].ManufactureID);
                }
                else {
                    $("#<%=ddlManufacturer.ClientID %>").focus();
                }

            });
                  
     
        }
     function bindMachine(ItemIDGroup, ManufactureID) {
         $("#<%=ddlMachine.ClientID %> option").remove();
         $("#<%=ddlPackSize.ClientID %> option").remove();
         locationidfrom = $('#<%=ddllocation.ClientID%>').val();

         serverCall('DirectGRN.aspx/bindMachine', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID }, function (response) {
             if (JSON.parse(response).length == 0) {
                 $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val("0").html("--No Item Found--"));
                 $("#<%=ddlMachine.ClientID %>").trigger('chosen:updated');
             }
             else {
                 if ($.parseJSON(response).length > 1) {
                     $("#<%=ddlMachine.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName', isSearchAble: true, defaultValue: "Select" });

                 }
                 else {
                     $("#<%=ddlMachine.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName', isSearchAble: true});

                 }
             }
             var tempData = $.parseJSON(response);
             if (tempData.length == 1) {
                 bindPackSize(ItemIDGroup, ManufactureID, tempData[0].MachineID);
             }
             else {
                 $("#<%=ddlMachine.ClientID %>").focus();
             }
         });

   
}
        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = $('#<%=ddllocation.ClientID%>').val();
            $("#<%=ddlPackSize.ClientID %> option").remove();

            serverCall('DirectGRN.aspx/bindPackSize', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }, function (response) {

                if (JSON.parse(response).length == 0) {
                    $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val("0").html("--No Item Found--"));
                    $("#<%=ddlPackSize.ClientID %>").trigger('chosen:updated');
                }
                else {
                    if ($.parseJSON(response).length > 1) {
                        $("#<%=ddlPackSize.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'PackValue', textField: 'PackSize', isSearchAble: true, defaultValue: "Select" });

                    }
                    else {
                        $("#<%=ddlPackSize.ClientID %>").bindDropDown({ data: JSON.parse(response), valueField: 'PackValue', textField: 'PackSize', isSearchAble: true });

                    }
                }
                var tempData = $.parseJSON(response);
                if (tempData.length == 1) {
                    setDataAfterPackSize();
                }
                else if (tempData.length == 0 || tempData.length > 0) {
                    $("#<%=ddlPackSize.ClientID %>").focus();
                }              
            });       
        }
    function setDataAfterPackSize() {
        if ($("#<%=ddlPackSize.ClientID %>").val() != '0') {
            $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);
        }
        else {
            $("#<%=lblItemID.ClientID %>").html('');
        }
    }

    function checkduplicatebatchno(ctrl) {
        var itemid = $(ctrl).closest('tr').find('#tditemid').html();
        var locationid = $(ctrl).closest('tr').find('#tdlocationid').html();
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
        function printallbarcodeno() {
            var barcodedata = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader" && $(this).find("#chk").is(':checked')) {
                    var Quantity = $(this).find('#txtbqty').val() == "" ? 0 : $(this).find('#txtbqty').val();
                    if (Quantity != "0") {
                        var objbarcodedata = new Object();
                        objbarcodedata.stockid = $(this).find('#tdStockID').html();
                        objbarcodedata.qty = Quantity;
                        barcodedata.push(objbarcodedata);
                    }
                }
            });
            if (barcodedata.length == 0) {
                toast("Error", "Please Select Item For Print Barcode","");
                return;
            }
            try {
                serverCall('Services/StoreCommonServices.asmx/getbarcodedata', { BarcodeData: barcodedata }, function (response) {

                    window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                });                
            }
            catch (e) {
                toast("Error", "Barcode Printer Not Install","");
            }
        }
    </script>
    <script type="text/javascript">
        var innerhtml = $('#trme').html();
        var innerhtml1 = $('#trme1').html();
        function checkpageaccess() {
            if ($('#<%=ddllocation.ClientID%>').val() != "0") {
                var res = CheckOtherStorePageAccess($('#<%=ddllocation.ClientID%>').val().split('#')[0]);
                if (res != "1") {
                    $('#trme').hide();
                    $('#trme').html('');
                    $('#trme1').hide();
                    $('#trme1').html('');
                    toast("Error", res);
                }
                else {
                    $('#trme').show();
                    $('#trme').html(innerhtml);

                    $('#trme1').show();
                    $('#trme1').html(innerhtml1);
                }
            }
            else {
                $('#trme').show();
                $('#trme').html(innerhtml);
                $('#trme1').show();
                $('#trme1').html(innerhtml1);
            }
        }
        function hideme(res) {
            $('#trme').hide();
            $('#trme').html('');
            $('#trme1').hide();
            $('#trme1').html('');
            toast("Error", res, "");
        }
    </script>
</asp:Content>

