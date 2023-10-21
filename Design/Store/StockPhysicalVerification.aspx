<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StockPhysicalVerification.aspx.cs" Inherits="Design_Store_StockPhysicalVerification" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <style type="text/css">
        .chosen-container {
            width: 400px !important;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Stock Physical Verification</b>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-4 "></div>
                <div class="col-md-4 ">
                    <label class="pull-left">Current Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList class="ddllocation chosen-select chosen-container" ID="ddllocation" runat="server" Style="width: 200px; text-align: left;" onchange="checkpageaccess()"></asp:DropDownList>
                </div>
                <div class="col-md-6 "></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Barcode </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtbarcodeno" runat="server" Width="436px" placeholder="Scan Barcode For Quick Stock Verification" BackColor="lightyellow" Style="border: 1px solid red;" Font-Bold="true"></asp:TextBox>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtitemcode" runat="server" Width="120px" placeholder="Enter Item Code"></asp:TextBox>
                </div>
                <div class="col-md-5">
                    <input type="button" value="More Filter" style="font-weight: bold; cursor: pointer;" onclick="showhide()" />
                </div>
            </div>
            <div class="row t1" style="display: none;">
                <div class="col-md-3 ">
                    <label class="pull-left">Category Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">SubCategory Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>
                </div>
            </div>
            <div class="row t1" style="display: none;">
                <div class="col-md-3 ">
                    <label class="pull-left">Item Category </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Items </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row" id="trme" style="text-align: center">
                <div class="col-md-24 ">
                    <input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" />
                    &nbsp;&nbsp;
                                                <input type="button" value="Add Item From Quotation" class="searchbutton" onclick="searchitemQuotation()" />
                    &nbsp;&nbsp;

                                                <input type="button" value="Print" onclick="printme()" class="searchbutton" />
                    <% if (savespv == "1")
                       {
                    %>
                    <input type="button" class="savebutton" onclick="savealldata()" id="btnsave" style="display: none;" value="Save" />
                    <% }%>

                    <% if (approvespv == "1")
                       {
                    %>
                    <input type="button" class="savebutton" onclick="approvealldata()" id="btnapprove" style="display: none;" value="Approve" />
                    <% }%>
                    <input type="button" class="savebutton" onclick="printallbarcodeno()" id="btnsave1" style="display: none; float: right; margin-right: 15px;" value="Print All" />

                </div>
            </div>
            <div class="row">
                <div class="col-md-24 ">
                    <span style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp </span>


                    <span style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightsalmon; cursor: pointer;"
                        onclick="searchmewithcolor('lightsalmon');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span>Saved Earlier&nbsp;&nbsp;&nbsp;&nbsp;</span>


                    <span style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque; cursor: pointer;"
                        onclick="searchmewithcolor('bisque');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span>Stock Not Avilable&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white; cursor: pointer;"
                        onclick="searchmewithcolor('white');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span>Barcode Not Printed&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90; cursor: pointer;"
                        onclick="searchmewithcolor('#90EE90');">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span>Barcode Printed&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;</span>
                    <span>New Batch Added&nbsp;&nbsp;&nbsp;&nbsp;</span>

                    <span style="font-weight: 700; font-style: italic; color: #FF0000;">* Saved Data Went for Approval
                    </span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Item Detail</div>
            <div class="row">
                <div class="col-md-24 ">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle">Stockid</td>
                            <td class="GridViewHeaderStyle">Item Type</td>
                            <td class="GridViewHeaderStyle">Item ID</td>
                            <td class="GridViewHeaderStyle">Item Name</td>
                            <td class="GridViewHeaderStyle">Item Code</td>
                            <td class="GridViewHeaderStyle">PurchaseUnit</td>
                            <td class="GridViewHeaderStyle">Converter</td>
                            <td class="GridViewHeaderStyle">BarcodeNo</td>
                            <td class="GridViewHeaderStyle">InHand Qty</td>
                            <td class="GridViewHeaderStyle" title="Stock Qty Show in Software">Stock Qty</td>
                            <td class="GridViewHeaderStyle">Batch No</td>
                            <td class="GridViewHeaderStyle">Expiry Date</td>
                            <td class="GridViewHeaderStyle" style="width: 30px;"></td>
                            <td class="GridViewHeaderStyle">
                                <input type="text" name="consumeremarks" onkeyup="showme2(this)" placeholder="All  Remarks" maxlength="180" style="width: 100px" /></td>
                            <td class="GridViewHeaderStyle">Rate</td>
                            <td class="GridViewHeaderStyle">Disc<br />
                                Amt</td>
                            <td class="GridViewHeaderStyle">Tax<br />
                                Amt</td>
                            <td class="GridViewHeaderStyle">Unit<br />
                                Price</td>
                            <td class="GridViewHeaderStyle" style="width: 30px;">
                                <input type="checkbox" onclick="checkall(this)" /></td>
                            <td class="GridViewHeaderStyle" style="width: 30px;"></td>
                            <td class="GridViewHeaderStyle">Barcode Print</td>
                        </tr>
                    </table>
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
        <div class="row">
            <div class="col-md-3 ">
                <label class="pull-left">Select Item </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8">
                <span style="color: red;">* Only Self Genrated barcode Items(Not System Genrated)</span>
                <br />
                <asp:DropDownList ID="ddlitemmap" class="ddlitem chosen-select chosen-container" runat="server" Width="800px"></asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3 ">
                <label class="pull-left">Barcode No </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtbarcodenomap" runat="server" ReadOnly="true"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24 " style="text-align: center">
                <input type="button" value="Map" class="searchbutton" onclick="savenewbarcode()" />&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Cancel" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" Style="display: none" />
    <asp:Panel ID="Panel1" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="1250px">
        <div class="Purchaseheader">
            Item Detail
        </div>
        <div class="row">
            <div class="col-md-24 ">
                <table id="tblitemlistqu" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="triteheaderqu">
                        <td class="GridViewHeaderStyle" style="width: 30px;">#</td>
                        <td class="GridViewHeaderStyle">Item Type</td>
                        <td class="GridViewHeaderStyle">Item Name &nbsp;<asp:TextBox ID="txtitemsearch" runat="server" placeholder="Enter Item Name To Search" Width="235px" /></td>
                        <td class="GridViewHeaderStyle">Item ID</td>
                        <td class="GridViewHeaderStyle">Converter</td>
                        <td class="GridViewHeaderStyle">Location State</td>
                        <td class="GridViewHeaderStyle">Supplier State</td>
                        <td class="GridViewHeaderStyle">Supplier Name</td>
                        <td class="GridViewHeaderStyle">Rate</td>
                        <td class="GridViewHeaderStyle">Disc(%)</td>
                        <td class="GridViewHeaderStyle">Disc Amt</td>
                        <td class="GridViewHeaderStyle">IGST(%)</td>
                        <td class="GridViewHeaderStyle">CGST(%)</td>
                        <td class="GridViewHeaderStyle">SGST(%)</td>
                        <td class="GridViewHeaderStyle">Tax Amt</td>
                        <td class="GridViewHeaderStyle">Unit Price</td>
                    </tr>

                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24 " style="text-align: center">
                <input type="button" value="Add" class="searchbutton" onclick="addnewitem()" />&nbsp;&nbsp;<asp:Button ID="Button2" runat="server" CssClass="resetbutton" Text="Cancel" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" CancelControlID="Button2">
    </cc1:ModalPopupExtender>
    <script type="text/javascript">
        var deletedtemid = "";
        $(function () {

            $('[id*=ddlcategory]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=ddlcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlsubcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindCatagoryType();
            $("#<%= txtbarcodeno.ClientID%>").keydown(
              function (e) {
                  var key = (e.keyCode ? e.keyCode : e.charCode);
                  if (key == 13) {
                      e.preventDefault();
                      if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {
                          searchitem();
                      }
                  }
              });
            $("#<%= txtitemcode.ClientID%>").keydown(
             function (e) {
                 var key = (e.keyCode ? e.keyCode : e.charCode);
                 if (key == 13) {
                     e.preventDefault();
                     if ($.trim($('#<%=txtitemcode.ClientID%>').val()) != "") {
                         searchitem();
                     }
                 }
             });
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
            jQuery.expr[':'].contains = function (a, i, m) {
                return jQuery(a).text().toUpperCase()
                    .indexOf(m[3].toUpperCase()) >= 0;
            };
            $('#<%=txtitemsearch.ClientID%>').keyup(function () {
                var search = $(this).val();
                $('#tblitemlistqu tr:not(:first)').hide();
                var len = $('#tblitemlistqu tr:not(:first) td:nth-child(3):contains("' + search + '")').length;
                if (len > 0) {

                    $('#tblitemlistqu tr:not(.notfound) td:nth-child(3):contains("' + search + '")').each(function () {
                        $(this).closest('tr').show();
                    });
                }
            });
        });
        function showme2(ctrl) {
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }
    </script>
    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
                jQuery("#ddlcattype").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: jQuery("#ddlcattype") });
            });
        }
        function bindSubcattype(CategoryTypeID) {
            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");
            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeID != "") {
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID.toString() }, function (response) {
                    jQuery("#ddlsubcattype").bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: jQuery("#ddlsubcattype") });
                });
            }
            binditem();
        }
        function bindCategory(SubCategoryTypeMasterId) {
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");
            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (SubCategoryTypeMasterId != "") {
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId.toString() }, function (response) {
                    jQuery("#ddlcategory").bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: jQuery("#ddlcategory") });
                });
            }
            binditem();
        }
        function binditem() {
            var CategoryTypeId = $('#ddlcattype').multipleSelect("getSelects").join();
            var SubCategoryTypeId = $('#ddlsubcattype').multipleSelect("getSelects").join();
            var CategoryId = $('#ddlcategory').multipleSelect("getSelects").join();
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    serverCall('MappingStoreItemWithCentre.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, CategoryId: CategoryId }, function (response) {
                        jQuery("#ddlItem").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: jQuery("#ddlItem") });

                    });
                }
            }
        }
    </script>

    <script type="text/javascript">
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
        function openmypopup(href) {
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
    </script>
    <script type="text/javascript">
        function searchmewithcolor(color) {
            rowcolor = color;
            searchitem();
        } var rowcolor = "";
        function searchitem() {

            deletedtemid = "";
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            var CategoryTypeId = $('#ddlcattype').multipleSelect("getSelects").join();
            var SubCategoryTypeId = $('#ddlsubcattype').multipleSelect("getSelects").join();
            var SubCategoryId = $('#ddlcategory').multipleSelect("getSelects").join();
            var itemid = $('#ddlItem').multipleSelect("getSelects").join();

            if (stockitemid != "") {
                itemid = stockitemid;
            }


            var barcode = $.trim($('#<%=txtbarcodeno.ClientID%>').val());

            if (itemidfinal == "" && barcode == "") {
                $('#tblitemlist tr').slice(1).remove();
            }
            serverCall('StockPhysicalVerification.aspx/SearchData', { locationid: $('#<%=ddllocation.ClientID%>').val(), CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, SubCategoryId: SubCategoryId, ItemId: itemid, barcode: barcode, itemcode: $('#<%=txtitemcode.ClientID%>').val(), rowcolor: rowcolor, itemidfinal: itemidfinal }, function (response) {
                rowcolor = "";
                if (response == "-1") {
                    openmapdialog();
                    return;
                }
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found!", "");
                    $('#btnsave').hide();
                    $('#btnsave1').hide();
                    $('#btnapprove').hide();
                }
                else {
                    var bal = 0;
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    $('#<%=txtitemcode.ClientID%>').val('');
                    stockitemid = "";
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        if (barcode != "") {
                            if ($('table#tblitemlist').find('#trbody_' + ItemData[i].barcodeno).length > 0) {
                                var old = Number($('#trbody_' + ItemData[i].barcodeno).find('#txtinhandqty').val());
                                $('#trbody_' + ItemData[i].barcodeno).find('#txtinhandqty').val(old + 1);

                                return;
                            }
                        }
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(ItemData[i].rowcolor); $myData.push(";' id='trbody_"); $myData.push(ItemData[i].barcodeno); $myData.push("' class='tr_clone'>");
                        if (ItemData[i].rowcolor == "yellow") {
                            $myData.push('<td class="GridViewLabItemStyle" id="tdstockid"></td>');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" id="tdstockid">'); $myData.push(ItemData[i].StockID); $myData.push('</td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle" id="tditemgroupname">'); $myData.push(ItemData[i].itemgroup); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tditemid" style="font-weight:bold;">'); $myData.push(ItemData[i].itemid); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tditemname">'); $myData.push(ItemData[i].typename); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdapolloitemcode">'); $myData.push(ItemData[i].apolloitemcode); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tdmajorunitname">'); $myData.push(ItemData[i].MajorUnitName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tdconverter">'); $myData.push(ItemData[i].Converter); $myData.push('</td>');

                        if (ItemData[i].barcodeno != "") {
                            $myData.push('<td class="GridViewLabItemStyle" id="tdbarcodeno"><input type="text" id="txtbarcodeno" style="width:50px;" value="'); $myData.push(ItemData[i].barcodeno); $myData.push('" readonly="readonly" /></td>');

                        }
                        else {

                            if (newbarcodeno != "") {
                                $myData.push('<td class="GridViewLabItemStyle" id="tdbarcodeno"><input type="text" id="txtbarcodeno" style="width:50px;" value="'); $myData.push(newbarcodeno); $myData.push('" readonly="readonly"  /></td>');
                            }
                            else if (ItemData[i].BarcodeGenrationOption == "2") {
                                $myData.push('<td class="GridViewLabItemStyle" id="tdbarcodeno"><input type="text" id="txtbarcodeno" style="width:50px;"  readonly="readonly"  /></td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle" id="tdbarcodeno"><input type="text" id="txtbarcodeno" style="width:50px;"  /></td>');
                            }
                        }
                        if (ItemData[i].rowcolor == "yellow") {
                            $myData.push('<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">0</span>');
                        }
                        else {
                            $myData.push('<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">'); $myData.push(precise_round(ItemData[i].Balance, 5)); $myData.push('</span>');
                        }
                        $myData.push('&nbsp;<span style="font-weight:bold;color:red;" >'); $myData.push(ItemData[i].MinorUnitName); $myData.push('</span></td>');
                        var background = 'white';
                        if (ItemData[i].newqty != "" && Number(ItemData[i].newqty) > Number(ItemData[i].Balance)) {
                            background = 'pink';
                        }
                        if (ItemData[i].newqty != "" && Number(ItemData[i].newqty) < Number(ItemData[i].Balance)) {
                            background = 'yellow';
                        }
                        if (ItemData[i].newqty != "") {
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtinhandqty" style="width:70px;background-color:'); $myData.push(background); $myData.push('" onkeyup="showme(this)" value="'); $myData.push(precise_round(ItemData[i].newqty, 5)); $myData.push('" />');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtinhandqty" style="width:70px;background-color:'); $myData.push(background); $myData.push('" onkeyup="showme(this)"  />');
                        }
                        $myData.push('&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].MinorUnitName); $myData.push('</span></td>');
                        if (ItemData[i].batchnumber != "") {
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" style="width:100px;" onblur="checkduplicatebatchno(this)" value="'); $myData.push(ItemData[i].batchnumber); $myData.push('" readonly="readonly" /></td>');
                        }
                        else {

                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" style="width:100px;" onblur="checkduplicatebatchno(this)"  /></td>');

                        }

                        if (ItemData[i].ExpiryDate != "" || ItemData[i].IsExpirable == "0") {
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text"  style="width:90px;" class="exdate" value="'); $myData.push(ItemData[i].ExpiryDate); $myData.push('" readonly="readonly" /></td>');
                        }
                        else {

                            $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate'); $myData.push(i); $myData.push('" style="width:90px;" class="exdate"  /></td>');

                        }
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if ((ItemData[i].BarcodeOption == "1" && ItemData[i].BarcodeGenrationOption == "1") || itemidfinal != "") {

                        }
                        else {
                            if (ItemData[i].Rate != "0" && ItemData[i].savedid == "0") {
                                $myData.push(' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addme(this);" />');
                            }

                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdremarks"><input type="text" id="txtremarks" name="consumeremarks" maxlength="200" value="'); $myData.push(ItemData[i].VerificationRemarks); $myData.push('" style="width:100px;"/></td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="tdRate">'); $myData.push(ItemData[i].Rate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"   id="tdDiscountAmount">'); $myData.push(ItemData[i].DiscountAmount); $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle"  id="tdTaxAmount">'); $myData.push(ItemData[i].TaxAmount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"   id="tdUnitPrice">'); $myData.push(ItemData[i].UnitPrice); $myData.push('</td>');
                        if (ItemData[i].Rate == "0") {
                            $myData.push('<td  ></td>');
                        }
                        else {

                            if (ItemData[i].savedid != "0") {
                                $myData.push('<td  ><input type="checkbox" id="chk"   /></td>');
                            }
                            else {
                                if (itemidfinal == "") {
                                    $myData.push('<td  ><input type="checkbox" id="chk"  /></td>');
                                }
                                else {
                                    $myData.push('<td  ><input type="checkbox" id="chk" checked="checked"  /></td>');
                                }
                            }
                        }
                        $myData.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');

                        $myData.push('<td>');
                        if (ItemData[i].StockID != "0") {
                            if (ItemData[i].rowcolor == "yellow") {
                                ItemData[i].Balance = "0";
                            }
                            if (ItemData[i].BarcodeGenrationOption == "1") {
                                $myData.push('<input type="text" id="txtbqty" style="width:30px" onkeyup="showme1(this)" value="'); $myData.push(precise_round(ItemData[i].Balance, 5)); $myData.push('" />');
                            }
                            else {
                                $myData.push('<input type="text" id="txtbqty" style="width:30px" onkeyup="showme1(this)" value="'); $myData.push(precise_round(ItemData[i].Balance, 5)); $myData.push('" />');
                            }

                            $myData.push('&nbsp;&nbsp;<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printbarcode(this)"/>');
                        }
                        else {
                            $myData.push('<input type="text" id="txtbqty" style="width:30px;display:none;"  value="0" />');
                        }
                        $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tditemgroupid">'); $myData.push(ItemData[i].SubCategoryID); $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tdmajorunitid">'); $myData.push(ItemData[i].MajorUnitId); $myData.push('</td>');


                        $myData.push('<td style="display:none;" id="tdPackSize">'); $myData.push(ItemData[i].PackSize); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdIsExpirable">'); $myData.push(ItemData[i].IsExpirable); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdIssueMultiplier">'); $myData.push(ItemData[i].IssueMultiplier); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdminorunitid">'); $myData.push(ItemData[i].MinorUnitId); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdminorunitname">'); $myData.push(ItemData[i].MinorUnitName); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdmanufaid">'); $myData.push(ItemData[i].ManufactureID); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdmacid">'); $myData.push(ItemData[i].MachineID); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdlocationid">'); $myData.push(ItemData[i].LocationId); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdpanelid">'); $myData.push(ItemData[i].panelid); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdStockID">'); $myData.push(ItemData[i].StockID); $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tdDiscountPer">'); $myData.push(ItemData[i].DiscountPer); $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tdTaxPer">'); $myData.push(ItemData[i].TaxPer); $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tdMRP">'); $myData.push(ItemData[i].MRP); $myData.push('</td>');

                        $myData.push('<td style="display:none;" id="tdBarcodeOption">'); $myData.push(ItemData[i].BarcodeOption); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdBarcodeGenrationOption">'); $myData.push(ItemData[i].BarcodeGenrationOption); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdIssueInFIFO">'); $myData.push(ItemData[i].IssueInFIFO); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdMajorUnitInDecimal">'); $myData.push(ItemData[i].MajorUnitInDecimal); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdMinorUnitInDecimal">'); $myData.push(ItemData[i].MinorUnitInDecimal); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdexpdatecutoff">'); $myData.push(ItemData[i].expdatecutoff); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="savedid">'); $myData.push(ItemData[i].savedid); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="qutationid">'); $myData.push(ItemData[i].qutationid); $myData.push('</td>');



                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        if (itemidfinal == "") {
                            $('#tblitemlist').append($myData);
                        }
                        else {
                            $('#tblitemlist tr:first').after($myData);
                        }

                        var date = new Date();
                        var newdate = new Date(date);

                        newdate.setDate(newdate.getDate() + parseInt(ItemData[0].expdatecutoff));

                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                   "Aug", "Sep", "Oct", "Nov", "Dec"];

                        var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();



                        $("#txtexpirydate" + i).datepicker({
                            dateFormat: "dd-M-yy",
                            changeMonth: true,
                            changeYear: true, yearRange: "-0:+20", minDate: val

                        });
                        //$('#tblitemlist tr').eq(1).find('#txtinhandqty').focus();

                        if (barcode != "") {
                            $('#<%=txtbarcodeno.ClientID%>').focus()
                            $('#trbody_' + ItemData[i].barcodeno).find('#txtinhandqty').val('1');
                            $('#trbody_' + ItemData[i].barcodeno).find('#chk').attr('checked', true);
                        }


                        $('#btnsave').show();
                        $('#btnsave1').show();
                        $('#btnapprove').show();
                        // tablefuncation();

                        bal = parseFloat(bal) + parseFloat(ItemData[i].Balance);
                    }
                    itemidfinal = "";


                    if (newbarcodeno != "" && bal > 0) {
                        addme($('#tblitemlist tr:last'));
                        $('#tblitemlist tr:last').find('#txtinhandqty').focus();

                    }
                    newbarcodeno = "";
                }


            });

        }


        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function addme(ctrl) {

            var $tr = $(ctrl).closest('.tr_clone');
            var $clone = $tr.clone();


            $clone.find(':text').val('');
            $clone.find('#tdstockid').text('');

            if ($clone.find('#tdBarcodeOption').html() == "2") {
                var barcode = $tr.find('#txtbarcodeno').val();
                $clone.find('#txtbarcodeno').val(barcode);
                $clone.find(':text').removeAttr('readonly');

            }
            if (newbarcodeno != "") {
                $clone.find('#txtbarcodeno').val(newbarcodeno);
                $clone.find('#txtbacknumber').removeAttr('readonly');
                $clone.find('.exdate').removeAttr('readonly');

            }
            $clone.find('#txtbarcodeno').attr('readonly', true);
            $clone.find('#txtbacknumber').removeAttr('readonly');
            $clone.find('.exdate').removeAttr('readonly');
            var newid = Math.floor(1000 + Math.random() * 9000);
            $clone.find('.exdate').attr('id', newid);
            $clone.find('.exdate').removeClass('hasDatepicker');


            var date1 = new Date();
            var newdate1 = new Date(date1);

            newdate1.setDate(newdate1.getDate() + parseInt($tr.find('#tdexpdatecutoff').html()));

            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
       "Aug", "Sep", "Oct", "Nov", "Dec"];

            var val1 = newdate1.getDate() + "-" + months[newdate1.getMonth()] + "-" + newdate1.getFullYear();



            $clone.find('#' + newid).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-0:+20", minDate: val1

            });

            $clone.find('#spbal').html('0');
            $clone.css("background-color", "yellow");
            $tr.after($clone);


            // tablefuncation();
        }

        function deleterow(itemid) {

            var $tr = $(itemid).closest('tr');
            if ($tr.find('#savedid').html() != "") {
                deletedtemid += $tr.find('#savedid').html() + ",";


            }

            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
        }
        function showme(ctrl) {
            if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

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

            if (parseFloat($(ctrl).val()) > parseFloat($(ctrl).closest('tr').find('#spbal').html())) {
                $(ctrl).css("background-color", "pink");
            }
            else if (parseFloat($(ctrl).val()) < parseFloat($(ctrl).closest('tr').find('#spbal').html())) {
                $(ctrl).css("background-color", "yellow");
            }
            else {
                $(ctrl).css("background-color", "white");
            }

            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
            $(ctrl).closest('tr').find('#txtbqty').val($(ctrl).val());
        }




        function showme1(ctrl) {

            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', '0'));
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
                $(ctrl).val('0');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('0');
                return;
            }



        }


    </script>

    <script type="text/javascript">

        function getcompletedataadj() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    if (parseFloat($(this).find("#txtinhandqty").val()) >= parseFloat($(this).find("#spbal").html())) {
                        var objStockMaster = new Object();
                        objStockMaster.StockID = "0";
                        objStockMaster.ItemID = $(this).find("#tditemid").html();
                        objStockMaster.ItemName = $(this).find("#tditemname").html();
                        objStockMaster.LedgerTransactionID = "0";
                        objStockMaster.LedgerTransactionNo = "";
                        objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                        objStockMaster.Rate = $(this).find("#tdRate").html();
                        objStockMaster.DiscountPer = $(this).find("#tdDiscountPer").html();
                        objStockMaster.DiscountAmount = $(this).find("#tdDiscountAmount").html();
                        objStockMaster.TaxPer = $(this).find("#tdTaxPer").html();
                        objStockMaster.TaxAmount = $(this).find("#tdTaxAmount").html();
                        objStockMaster.UnitPrice = $(this).find("#tdUnitPrice").html();
                        objStockMaster.MRP = $(this).find("#tdMRP").html();


                        objStockMaster.InitialCount_old = $(this).find("#spbal").html();
                        objStockMaster.InitialCount_New = $(this).find("#txtinhandqty").val();
                        objStockMaster.StockPhysicalVerificationRemarks = $(this).find("#txtremarks").val();
                        objStockMaster.InitialCount = parseInt($(this).find("#txtinhandqty").val()) - parseInt($(this).find("#spbal").html());

                        objStockMaster.ReleasedCount = "0";
                        objStockMaster.PendingQty = "0";
                        objStockMaster.RejectQty = "0";


                        objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                        objStockMaster.Naration = "";
                        objStockMaster.IsFree = "0";

                        objStockMaster.LocationID = $(this).find("#tdlocationid").html();
                        objStockMaster.Panel_Id = $(this).find("#tdpanelid").html();

                        objStockMaster.IndentNo = "";
                        objStockMaster.FromLocationID = "0";
                        objStockMaster.FromStockID = $(this).find("#tdStockID").html();
                        objStockMaster.Reusable = "0";
                        objStockMaster.ManufactureID = $(this).find("#tdmanufaid").html();
                        objStockMaster.MacID = $(this).find("#tdmacid").html();
                        objStockMaster.MajorUnitID = $(this).find("#tdmajorunitid").html();
                        objStockMaster.MajorUnit = $(this).find("#tdmajorunitname").html();
                        objStockMaster.MinorUnitID = $(this).find("#tdminorunitid").html();
                        objStockMaster.MinorUnit = $(this).find("#tdminorunitname").html();
                        objStockMaster.Converter = $(this).find("#tdconverter").html();

                        objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                        objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                        objStockMaster.PackSize = $(this).find("#tdPackSize").html();


                        objStockMaster.Remarks = "Stock Physical Verification";
                        objStockMaster.BarcodeNo = $(this).find("#txtbarcodeno").val();
                        objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                        objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                        objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                        objStockMaster.MajorUnitInDecimal = $(this).find("#tdMajorUnitInDecimal").html();
                        objStockMaster.MinorUnitInDecimal = $(this).find("#tdMinorUnitInDecimal").html();
                        objStockMaster.StockPhysicalVerificationID = $(this).find("#savedid").html();
                        objStockMaster.qutationid = $(this).find("#qutationid").html();

                        dataIm.push(objStockMaster);


                    }


                }
            });
            return dataIm;
        }

        function getcompletedatapro() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    if (parseFloat($(this).find("#txtinhandqty").val()) < parseFloat($(this).find("#spbal").html())) {
                        var objStockMaster = new Object();

                        objStockMaster.StockID = $(this).find("#tdStockID").html();
                        objStockMaster.ItemID = $(this).find("#tditemid").html();
                        objStockMaster.ItemName = $(this).find("#tditemname").html();
                        objStockMaster.LedgerTransactionID = "0";
                        objStockMaster.LedgerTransactionNo = "";
                        objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                        objStockMaster.Rate = $(this).find("#tdRate").html();
                        objStockMaster.DiscountPer = $(this).find("#tdDiscountPer").html();
                        objStockMaster.DiscountAmount = $(this).find("#tdDiscountAmount").html();
                        objStockMaster.TaxPer = $(this).find("#tdTaxPer").html();
                        objStockMaster.TaxAmount = $(this).find("#tdTaxAmount").html();
                        objStockMaster.UnitPrice = $(this).find("#tdUnitPrice").html();
                        objStockMaster.MRP = $(this).find("#tdMRP").html();


                        objStockMaster.InitialCount_old = $(this).find("#spbal").html();
                        objStockMaster.InitialCount_New = $(this).find("#txtinhandqty").val();
                        objStockMaster.StockPhysicalVerificationRemarks = $(this).find("#txtremarks").val();
                        objStockMaster.InitialCount = parseInt($(this).find("#spbal").html()) - parseInt($(this).find("#txtinhandqty").val());

                        objStockMaster.ReleasedCount = "0";
                        objStockMaster.PendingQty = "0";
                        objStockMaster.RejectQty = "0";


                        objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                        objStockMaster.Naration = "";
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

                        objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                        objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                        objStockMaster.PackSize = $(this).find("#tdPackSize").html();

                        objStockMaster.Remarks = "Stock Physical Verification";
                        objStockMaster.BarcodeNo = $(this).find("#txtbarcodeno").val();
                        objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                        objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                        objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                        objStockMaster.MajorUnitInDecimal = $(this).find("#tdMajorUnitInDecimal").html();
                        objStockMaster.MinorUnitInDecimal = $(this).find("#tdMinorUnitInDecimal").html();
                        objStockMaster.StockPhysicalVerificationID = $(this).find("#savedid").html();
                        objStockMaster.qutationid = $(this).find("#qutationid").html();
                        dataIm.push(objStockMaster);


                    }


                }
            });
            return dataIm;
        }


        function getmydata() {

            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    // if (parseFloat($(this).find("#txtinhandqty").val()) != parseFloat($(this).find("#spbal").html())) {
                    var objStockMaster = new Object();

                    objStockMaster.stockid = $(this).find("#tdstockid").html() == "" ? 0 : parseInt($(this).find("#tdstockid").html());
                    objStockMaster.itemid = $(this).find("#tditemid").html();
                    objStockMaster.LocationID = $(this).find("#tdlocationid").html();



                    objStockMaster.OldQty = $(this).find("#spbal").html();

                    objStockMaster.NewQty = $(this).find("#txtinhandqty").val();
                    if ($(this).find("#tdstockid").html() == "0") {
                        objStockMaster.NewBatch = $(this).find("#txtbacknumber").val();
                        objStockMaster.NewBatchExpiryDate = $(this).find(".exdate ").val();
                        objStockMaster.fromstockid = $(this).find("#tdStockID").html();
                    }
                    else {
                        if ($(this).find("#qutationid").html() != "0") {
                            objStockMaster.NewBatch = $(this).find("#txtbacknumber").val();
                            objStockMaster.NewBatchExpiryDate = $(this).find(".exdate ").val();
                            objStockMaster.fromstockid = $(this).find("#tdStockID").html();
                        }
                        else {
                            objStockMaster.NewBatch = $(this).find("#txtbacknumber").val();
                            objStockMaster.NewBatchExpiryDate = $(this).find(".exdate ").val();
                            objStockMaster.fromstockid = "0";
                        }

                    }
                    objStockMaster.StockPhysicalVerificationRemarks = $(this).find("#txtremarks").val();
                    objStockMaster.qutationid = $(this).find("#qutationid").html();
                    objStockMaster.Rate = $(this).find("#tdRate").html();
                    objStockMaster.DiscountPer = $(this).find("#tdDiscountPer").html();
                    objStockMaster.DiscountAmount = $(this).find("#tdDiscountAmount").html();
                    objStockMaster.TaxPer = $(this).find("#tdTaxPer").html();
                    objStockMaster.TaxAmount = $(this).find("#tdTaxAmount").html();
                    objStockMaster.UnitPrice = $(this).find("#tdUnitPrice").html();
                    objStockMaster.MRP = $(this).find("#tdMRP").html();
                    dataIm.push(objStockMaster);




                    //  }
                }
            });
            return dataIm;
        }
        function savealldata() {
            if (validation() == true) {
                var mydata = getmydata();

                if (mydata.length == 0) {
                    toast("Error", "Please Select Item To Save!", "");
                    return;
                }
                serverCall('StockPhysicalVerification.aspx/savestock', { mydata: mydata }, function (response) {
                    if (response == "1") {
                        toast("Success", "Stock Updated Successfully Pending For Approval..!", "");
                        itemidfinal = "";
                        searchitem();

                    }
                    else {
                        toast("Error", response, "");
                    }


                });

            }

        }


        function approvealldata() {

            if (validation() == true) {
                var mydataadj = getcompletedataadj();
                var mydatapro = getcompletedatapro();
                if (mydataadj.length == 0 && mydatapro.length == 0) {
                    showerrormsg("Please Select Item To Approve");
                    toast("Error", "No Record Found!", "");
                    return;
                }
                serverCall('StockPhysicalVerification.aspx/approvestock', { mydataadj: mydataadj, mydatapro: mydatapro, deletedtemid: deletedtemid }, function (response) {
                    if (response == "1") {
                        toast("Success", "Stock Updated Successfully..!", "");
                        itemidfinal = "";
                        searchitem();
                    }
                    else {
                        toast("Error", response, "");
                    }
                });
            }

        }


        function validation() {

            var che = "true";
            var a = $('#tblitemlist tr').length;
            if (a == 1) {
                showerrormsg("Please Search Item..!");
                return false;
            }
            if (a > 0) {
                $('#tblitemlist tr').each(function () {
                    if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && $(this).find("#txtinhandqty").val() == "") {
                        $(this).find("#txtinhandqty").focus();
                        toast("Error", "You have not Entered Qty", "");
                        che = "false";
                        return false;

                    }
                });
            }
            if (che == "false") {
                return false;
            }


            var sn11 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader" && $(this).find("#chk").is(':checked')) {
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
                if (id != "triteheader" && $(this).find("#chk").is(':checked')) {



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
            return true;
        }
        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(ctr).is(":checked")) {

                        $(this).find('#chk').attr('checked', true);
                    }
                    else {
                        $(this).find('#chk').attr('checked', false);
                    }


                }
            });
        }
        function binditem1() {
            var dropdown = $("#<%=ddlitemmap.ClientID%>");
            $("#<%=ddlitemmap.ClientID%> option").remove();
            serverCall('StockPhysicalVerification.aspx/binditem', { locationid: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                PanelData = jQuery.parseJSON(response);
                if (PanelData.length == 0) {
                    dropdown.append($("<option></option>").val("0").html("--No Item Found--"));
                }
                else {
                    dropdown.append($("<option></option>").val("0").html("Select Item"));
                    for (i = 0; i < PanelData.length; i++) {
                        dropdown.append($("<option></option>").val(PanelData[i].itemid).html(PanelData[i].typename));
                    }
                }
                dropdown.trigger('chosen:updated');
            });
        }
        function MapItemWithbarcode() {
            $('#<%=txtbarcodenomap.ClientID%>').val($('#<%=txtbarcodeno.ClientID%>').val());
            unloadPopupBox();
            binditem1();
            $find("<%=modelpopup1.ClientID%>").show();
        }
        function showhide() {
            $('.t1').slideToggle("fast");
        }
        var stockitemid = "";
        var newbarcodeno = "";
        function savenewbarcode() {
            if ($('#<%=ddlitemmap.ClientID%>').val() == "0") {
                toast("Error", "Please Select Item", "");
                $('#<%=ddlitemmap.ClientID%>').focus();
                return;
            }
            serverCall('StockPhysicalVerification.aspx/savebarcode', { itemid: $('#<%=ddlitemmap.ClientID%>').val(), barcodeno: $('#<%=txtbarcodenomap.ClientID%>').val() }, function (response) {
                var type = response;
                $find("<%=modelpopup1.ClientID%>").hide();
                toast("Success", "Barcode Mapped", "");
                if (type == "1") {
                    $('#<%=txtbarcodeno.ClientID%>').val($('#<%=txtbarcodenomap.ClientID%>').val());
                    searchitem();
                }
                else {
                    newbarcodeno = $('#<%=txtbarcodenomap.ClientID%>').val();
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    stockitemid = $('#<%=ddlitemmap.ClientID%>').val().split('#')[0];

                    searchitem();
                }

            });
        }

        function printbarcode(ctrl) {

            var stockid = $(ctrl).closest('tr').find('#tdStockID').html();
            var qty = $(ctrl).closest('tr').find('#txtbqty').val();
            if (qty == "" || qty == "0") {
                toast("Error", "Please Enter Qty For Print Barcode", "");
                $(ctrl).closest('tr').find('#txtbqty').focus();
                return;
            }
            try {
                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.stockid = stockid;
                objbarcodedata.qty = qty;
                barcodedata.push(objbarcodedata);
                serverCall('Services/StoreCommonServices.asmx/getbarcodedata', { BarcodeData: barcodedata }, function (response) {
                    window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source_store';
                });
            }
            catch (e) {
                toast("Error", "Barcode Printer Not Install", "");

            }
        }
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
                toast("Error", "Please Select Item For Print Barcode", "");

                return;
            }
            try {
                serverCall('Services/StoreCommonServices.asmx/getbarcodedata', { BarcodeData: barcodedata }, function (response) {
                    window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                });
            }
            catch (e) {
                toast("Error", "Barcode Printer Not Install", "");
            }
        }
        function printme() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {

                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please select location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            var CategoryTypeId = $('#ddlcattype').multipleSelect("getSelects").join();
            var SubCategoryTypeId = $('#ddlsubcattype').multipleSelect("getSelects").join();
            var SubCategoryId = $('#ddlcategory').multipleSelect("getSelects").join();
            var itemid = $('#ddlItem').multipleSelect("getSelects").join();
            serverCall('StockPhysicalVerification.aspx/SearchDataPrint', { locationid: $('#<%=ddllocation.ClientID%>').val(), CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, SubCategoryId: SubCategoryId, ItemId: itemid }, function (response) {
                ItemData = response;
                if (ItemData == "1") {
                    window.open('Report/commonreportstore.aspx');

                }
                else {
                    toast("Error", "No Item Found", "");

                }
            });
        }

        //function checkduplicatebatchno(ctrl) {
        //    var itemid = $(ctrl).closest('tr').find('#tditemid').html();
        //    var batchno = $(ctrl).val();

        //    if ($.trim(batchno) != "") {

        //        $.ajax({
        //            url: "StockPhysicalVerification.aspx/checkduplicatebatchno",
        //            data: '{itemid:"' + itemid + '",batchno:"' + batchno + '"}',
        //        type: "POST",
        //        timeout: 120000,
        //        async: false,
        //        contentType: "application/json; charset=utf-8",
        //        dataType: "json",
        //        success: function (result) {

        //            ItemData = result.d;

        //            if (ItemData == "1") {
        //                $(ctrl).val('');
        //                $(ctrl).focus();
        //                showerrormsg('This Batch No Already Exist.!');
        //            }

        //        },
        //        error: function (xhr, status) {

        //            $.unblockUI();

        //        }
        //         });
        //    }
        //}


        function checkduplicatebatchno(ctrl) {


            var itemid = $(ctrl).closest('tr').find('#tditemid').html();
            var locationid = $(ctrl).closest('tr').find('#tdlocationid').html();
            var batchno = $(ctrl).val();
            if ($.trim(batchno) != "") {

                var a = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").find('#tditemid').html();
                    var batchnumber = $(this).find("#txtbacknumber").val();
                    if (id == itemid && $.trim(batchno).toUpperCase() == $.trim(batchnumber).toUpperCase()) {
                        a = a + 1;
                    }
                });

                if (a > 1) {
                    $(ctrl).val('');
                    $(ctrl).focus();
                    toast("Error", "This Batch No Already Exist.!", "");


                    return;
                }
                serverCall('StockPhysicalVerification.aspx/checkduplicatebatchno', { itemid: itemid, batchno: batchno, locationid: locationid }, function (response) {
                    ItemData = $.parseJSON(response);
                    if (ItemData.length > 0) {
                        $(ctrl).closest('tr').find('.exdate ').val(ItemData[0].ExpiryDate);
                        $(ctrl).closest('tr').find('#tdRate').html(ItemData[0].Rate);
                        $(ctrl).closest('tr').find('#tdDiscountAmount').html(ItemData[0].DiscountAmount);
                        $(ctrl).closest('tr').find('#tdTaxAmount').html(ItemData[0].TaxAmount);
                        $(ctrl).closest('tr').find('#tdUnitPrice').html(ItemData[0].UnitPrice);

                    }
                    else {
                        $(ctrl).closest('tr').find('.exdate ').val('');
                    }
                });
            }
        }
    </script>

    <script type="text/javascript">
        function searchitemQuotation() {

            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            $('#tblitemlistqu tr').slice(1).remove();
            serverCall('StockPhysicalVerification.aspx/getquotdata', { locationid: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                rowcolor = "";
                if (response == "-1") {
                    openmapdialog();
                    return;
                }
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found or Item Already in Stock", "");
                }
                else {

                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        $myData.push("<tr style='background-color:pink' id='"); $myData.push(ItemData[i].ItemID); $myData.push("'>");
                        $myData.push('<td><input type="checkbox" id="chk" onclick="checkforreason(this)"  /></td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].itemgroup); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].TypeName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="itemid" style="font-weight:bold;">'); $myData.push(ItemData[i].ItemID); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].Converter); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].DeliveryStateName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].VednorStateName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].VendorName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].Rate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].DiscountPer); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].DiscountAmt); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].IGSTPer); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].CGSTPer); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].SGSTPer); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].TaxAmount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].UnitPrice); $myData.push('</td>');
                        $myData.push("</tr>")
                        $myData = $myData.join("");
                        $('#tblitemlistqu').append($myData);

                    }

                    $find("<%=ModalPopupExtender1.ClientID%>").show();
                }


            });

        }

        var itemidfinal = "";
        function addnewitem() {
            itemidfinal = "";
            $('#tblitemlistqu tr').each(function () {
                if ($(this).attr("id") != "triteheaderqu" && $(this).find("#chk").is(':checked')) {
                    itemidfinal += $(this).find("#itemid").html() + ",";
                }
            });
            if (itemidfinal == "") {
                toast("Error", "Please Select Item To Add", "");
                return;
            }
            searchitem();
            $find("<%=ModalPopupExtender1.ClientID%>").hide();
        }
        function checkforreason(ctrl) {
            if ($(ctrl).prop('checked') == true) {
                $(ctrl).closest('tr').css('background-color', 'aqua');

            }
            else {
                $(ctrl).closest('tr').css('background-color', 'pink');
            }
        }
    </script>
    <script type="text/javascript">
        var innerhtml = $('#trme').html();
        function checkpageaccess() {
            if ($('#<%=ddllocation.ClientID%>').val() != "0") {
                var res = CheckPhysicalVerificationPageAccess($('#<%=ddllocation.ClientID%>').val().split('#')[0]);
                if (res != "1") {
                    $('#trme').hide();
                    $('#trme').html('');
                    showerrormsg(res);
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

