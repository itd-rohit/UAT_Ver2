<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectIssue.aspx.cs" Inherits="Design_Store_DirectIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
   

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Direct Issue</b>
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError" />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" id="hideDetail">
            <div id="divSearch">
                <div class="Purchaseheader">
                    Search Option
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Current Location:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:DropDownList ID="ddllocation" CssClass=" ddllocation chosen-select chosen-container requiredField" runat="server" onchange="bindindentfromlocation();"></asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Centre Type:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Zone:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val().toString());bindCentre();"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">State:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Centre:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddlcentre" runat="server" class="ddlcentre chosen-select chosen-container " onchange="bindindentfromlocation()"></asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Issue To Location:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddlissuelocation" class="ddlissuelocation chosen-select chosen-container requiredField" runat="server" onchange=""></asp:DropDownList>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Category:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddlcategorytype" ClientIDMode="Static" runat="server" TabIndex="1" CssClass="textbox">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Item:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6 ">
                                <input id="txtitem" type="text" style="text-transform: uppercase;" />

                            </div>
                            <div class="col-md-3 ">
                                <asp:Label ID="lblItemName" runat="server"></asp:Label>
                                <asp:Label ID="lblItemGroupID" runat="server" Style="display: none;"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Manufacturer:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Machine:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:DropDownList ID="ddlMachine" runat="server" onchange="bindTempData('PackSize');"></asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Pack Size:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:DropDownList ID="ddlPackSize" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>
                            </div>

                        </div>
                        <div class="row" id="trme1">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Barcode:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:TextBox ID="txtbarcodeno" runat="server" placeholder="Scan Barcode For Quick Issue" BackColor="lightyellow" Style="border: 1px solid red;" Font-Bold="true"></asp:TextBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left "></label>

                            </div>
                            <div class="col-md-3 ">
                                <input type="button" value="Add Item" class="searchbutton" onclick="searchitem()" />
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left "></label>

                            </div>
                            <div class="col-md-3 ">
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="Div1">
            <div id="div2">
                <div class="Purchaseheader">
                    Selected Item To Issue
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-24 ">
                                <table id="tblitemlist1" style="width: 99%; border-collapse: collapse; text-align: left;">
                                    <tr id="triteheader1">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle">ItemId</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>

                                        <td class="GridViewHeaderStyle">Batch Number</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">Barcodeno</td>
                                        <td class="GridViewHeaderStyle">Avilable Qty</td>

                                        <td class="GridViewHeaderStyle">Consume Unit</td>
                                        <td class="GridViewHeaderStyle">Unit Price</td>
                                        <td class="GridViewHeaderStyle">Issue Qty</td>
                                        <td class="GridViewHeaderStyle">Remove</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Total Value:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txttotal" runat="server" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Narration:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-12 ">
                        <asp:TextBox ID="txtnarration" MaxLength="200" runat="server"></asp:TextBox>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="Div3">
            <div id="div4">
                <div class="Purchaseheader">
                    Dispatch Details 
                    <span style="font-style: italic; color: red; font-size: 11px;">* You can enter dispatch detail if you want</span>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Dispatch Type:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:RadioButtonList ID="rdoDispatchType" runat="server" onchange="setDispatchType();" RepeatDirection="Horizontal">
                            <asp:ListItem Text="Courier" Value="Courier" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="FieldBoy" Value="FieldBoy"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">No of Box:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txtnoofbox" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtnoofbox">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Total Weight:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txttotalweight" runat="server" />
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Dispatch Date :   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txtdispatchdate" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdispatchdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Consignment Note:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9 ">
                        <asp:TextBox ID="txtconsignmentnote" runat="server" />
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Temperature:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9 ">
                        <asp:TextBox ID="txtTemperature" runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="row Courier">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Courier Name:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9 ">
                        <asp:TextBox ID="txtCourierName" runat="server" />
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">AWB Number:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9 ">
                        <asp:TextBox ID="txtawbnumber" runat="server" />
                    </div>
                </div>
                <div class="row FieldBoy">
                    <div class="col-md-3 ">
                        <label class="pull-left ">FeildBoy:   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9 ">
                        <asp:DropDownList ID="ddlfeildboy" runat="server" Style="float: left;" />
                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txtotherboy" placeholder="Enter Other" runat="server" Width="150px" Style="margin-left: 10px; display: none; float: left;"></asp:TextBox>
                    </div>
                    <div class="col-md-9 ">
                    </div>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="div6">
                <div class="row">
                    <div class="col-md-24 ">
                        <input type="button" value="Save" class="savebutton" onclick="saveissue();" id="Button2" />
                        <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                    </div>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="1100px">


            <div class="Purchaseheader">
                Stock Detail
            </div>
            <div style="width: 99%; max-height: 375px; overflow: auto;">
                <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="triteheader">

                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle">ItemId</td>
                        <td class="GridViewHeaderStyle">Item Name</td>
                        <td class="GridViewHeaderStyle">StockID</td>
                        <td class="GridViewHeaderStyle">Batch Number</td>
                        <td class="GridViewHeaderStyle">Expiry Date</td>
                        <td class="GridViewHeaderStyle">BarcodeNo</td>
                        <td class="GridViewHeaderStyle">Avilable Qty</td>

                        <td class="GridViewHeaderStyle">Consume Unit</td>
                        <td class="GridViewHeaderStyle">Unit Price</td>
                        <td class="GridViewHeaderStyle">Issue Qty</td>
                        <td class="GridViewHeaderStyle">Select</td>
                        <td class="GridViewHeaderStyle"></td>





                    </tr>
                </table>

            </div>

            <center>
                <input type="button" value="Add All" id="btnaddall" style="display: none;" class="savebutton" onclick="issueall()" />
                &nbsp;&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
            </center>

        </asp:Panel>
        <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="Button1"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
        </cc1:ModalPopupExtender>

        <asp:Button ID="Button1" runat="server" Style="display: none" />
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
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindcentertype();
            bindZone();
            bindfieldboy();
            setDispatchType();
        });


        function bindcentertype() {

            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                var $ddlCtype = $('#<%=lstCentreType.ClientID%>');
                $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });
            });
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                var $ddlZone = $('#<%=lstZone.ClientID%>');
                $ddlZone.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
            });
        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    var $ddlState = $('#<%=lstState.ClientID%>');
                    $ddlState.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });
            }
        }
        
        function bindCentre() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();


            var dropdown = $("#<%=ddlcentre.ClientID%>");
            $("#<%=ddlcentre.ClientID%> option").remove();

            serverCall('DirectStockTransfer.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
            });

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




       
        



        function bindindentfromlocation() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $("#<%=ddlissuelocation.ClientID%> option").remove();
                $("#<%=ddlissuelocation.ClientID%>").append($("<option></option>").val("0").html("Select Issue To Location"));
                return;
            }
            var dropdown = $("#<%=ddlissuelocation.ClientID%>");
            $("#<%=ddlissuelocation.ClientID%> option").remove();
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
           // var panelid = $('#<%=ddlcentre.ClientID%>').val();
            var panelid = "";

            serverCall('DirectIssue.aspx/bindindentfromlocation', { tolocation: $('#<%=ddllocation.ClientID%>').val(), TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, panelid: panelid }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'locationid', textField: 'location', isSearchAble: true });
            });
        }

    </script>


    <script type="text/javascript">

        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {


            return split(term).pop();
        }
        $(function () {

            bindindentfromlocation();
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








        });



        function AddItem(itemid, barcodeno) {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select  Current Location..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlissuelocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select  To Location..!", "");
                $('#<%=ddlissuelocation.ClientID%>').focus();
                return;
            }
            $('#tblitemlist tr').slice(1).remove();
            $modelBlockUI();

            serverCall('DirectIssue.aspx/SearchItemDetail', { itemid: itemid, location: $('#<%=ddllocation.ClientID%>').val(), barcodeno: barcodeno }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found..!", "");
                    $modelUnBlockUI();
                }
                else {
                    if (ItemData.length > 1) {
                        $('#btnaddall').show();
                    }
                    else {
                        $('#btnaddall').hide();
                    }
                    for (var i = 0; i <= ItemData.length - 1; i++) {

                        var $mydata = [];
                        $mydata.push("<tr style='background-color:bisque;' id='"); $mydata.push(ItemData[i].stockid); $mydata.push("'>");

                        $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');


                        $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tditemid1">'); $mydata.push(ItemData[i].itemid); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tditemname">'); $mydata.push(ItemData[i].itemname); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdstockid">'); $mydata.push(ItemData[i].stockid); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdbatchnumber">'); $mydata.push(ItemData[i].batchnumber); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdExpiryDate">'); $mydata.push(ItemData[i].ExpiryDate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdbarcodeno">'); $mydata.push(ItemData[i].barcodeno); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdavlqty">'); $mydata.push(ItemData[i].AvilableQty); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdMinorUnit">'); $mydata.push(ItemData[i].MinorUnit); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdUnitPrice">'); $mydata.push(ItemData[i].UnitPrice); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdQuantity"><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showme(this);" class="qty" /></td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >');

                        $mydata.push('<img src="../../App_Images/post.gif" style="cursor:pointer;" onclick="issueme(this)" />');

                        $mydata.push('</td>');

                        $mydata.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData.length > 1) {
                            $mydata.push('<input type="checkbox" id="chk"  />');
                        }
                        $mydata.push('</td>');
                        $mydata.push('<td style="display:none;" id="tditemid" >'); $mydata.push(ItemData[i].itemid); $mydata.push('</td>');
                        $mydata.push('<td style="display:none;" id="tdIssueMultiplier" >'); $mydata.push(ItemData[i].IssueMultiplier); $mydata.push('</td>');

                        $mydata.push('<td style="display:none;" id="tdisdecimalallowed" >'); $mydata.push(ItemData[i].MinorUnitInDecimal); $mydata.push('</td>');

                        $mydata.push("</tr>");

                        $mydata = $mydata.join("");
                        $('#tblitemlist').append($mydata);

                    }

                    $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
                    $('#<%=ddllocation.ClientID%>').prop("disabled", true);
                    $('#<%=ddlissuelocation.ClientID%>').prop("disabled", true);
                    $.unblockUI();
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    $find("<%=modelpopup1.ClientID%>").show();
                    $('#tblitemlist tr').eq(1).find('#txtQuantity').focus();
                    var dropdown2 = $("#<%=ddlcentre.ClientID%>");
                    dropdown2.attr("disabled", true);
                    dropdown2.trigger('chosen:updated');

                    var dropdown3 = $("#<%=ddlissuelocation.ClientID%>");
                    dropdown3.attr("disabled", true);
                    dropdown3.trigger('chosen:updated');



                    jQuery('#<%=lstZone.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstCentreType.ClientID%>').multipleSelect("disable");
                    jQuery('#<%=lstState.ClientID%>').multipleSelect("disable");

                }
            });

        }

        function showme(ctrl) {
            if ($(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "" || $(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "0") {

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
            var avilableqty = $(ctrl).closest('tr').find('#tdavlqty').html();
            if (parseFloat($(ctrl).val()) > parseFloat(avilableqty)) {

                $(ctrl).focus();
                $(ctrl).val(avilableqty);
                toast("Error", "Issue Qty Can't Greater Then Avilable Qty..!", "");
                return;
            }


        }

        function issueme(ctrl) {
            var qty = $(ctrl).closest('tr').find('#txtQuantity').val();
            var IssueMultiplier = $(ctrl).closest('tr').find('#tdIssueMultiplier').html();
            if (qty == "" || qty == "0") {
                $(ctrl).closest('tr').find('#txtQuantity').focus();
                toast("Error", "Please Enter Qty..!", "");
                return;
            }

            if (parseInt(IssueMultiplier) > 0 && parseFloat(qty) % parseInt(IssueMultiplier) != 0) {
                toast("Error", "Issue Quantity Must Be Divisible of " + IssueMultiplier, "");
                $(ctrl).closest('tr').find('#txtQuantity').val('');
                $(ctrl).closest('tr').find('#txtQuantity').focus();
                return;
            }

            if ($('table#tblitemlist1').find('#' + $(ctrl).closest('tr').attr('id')).length > 0) {
                toast("Error", "Item Already Added", "");
                $(ctrl).closest('tr').find('#txtQuantity').val('');
                return;
            }

            var a = $('#tblitemlist1 tr').length - 1;
           
            var $mydata = [];
            $mydata.push("<tr style='background-color:bisque;' id='"); $mydata.push($(ctrl).closest('tr').attr('id')); $mydata.push("'>");


            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(parseInt(a + 1)); $mydata.push('</td>');


            $mydata.push('<td style="font-weight:bold;" id="tditemid1" >'); $mydata.push($(ctrl).closest('tr').find('#tditemid').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tditemname">'); $mydata.push($(ctrl).closest('tr').find('#tditemname').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdbatchnumber">'); $mydata.push($(ctrl).closest('tr').find('#tdbatchnumber').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdExpiryDate">'); $mydata.push($(ctrl).closest('tr').find('#tdExpiryDate').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdbarcodeno">'); $mydata.push($(ctrl).closest('tr').find('#tdbarcodeno').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdavlqty">'); $mydata.push($(ctrl).closest('tr').find('#tdavlqty').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdMinorUnit">'); $mydata.push($(ctrl).closest('tr').find('#tdMinorUnit').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdUnitPrice">'); $mydata.push($(ctrl).closest('tr').find('#tdUnitPrice').html()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" id="tdQuantity">'); $mydata.push($(ctrl).closest('tr').find('#txtQuantity').val()); $mydata.push('</td>');
            $mydata.push('<td class="GridViewLabItemStyle" >');

            $mydata.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)" />');

            $mydata.push('</td>');

            $mydata.push('<td style="display:none;" id="tditemid" >'); $mydata.push($(ctrl).closest('tr').find('#tditemid').html()); $mydata.push('</td>');

            $mydata.push("</tr>");

            $mydata = $mydata.join("");
            $('#tblitemlist1').append($mydata);


            calculatetotal();

            $find("<%=modelpopup1.ClientID%>").hide();
            $('#txtitem').focus();
        }


        function calculatetotal() {

            var finalamt = 0;
            $('#tblitemlist1 tr').each(function () {

                if ($(this).attr('id') != 'triteheader1') {

                    var net = Number($(this).find('#tdUnitPrice').html()) * Number($(this).find('#tdQuantity').html());
                    finalamt = finalamt + net;

                }
            });
            $('#<%=txttotal.ClientID%>').val(precise_round(finalamt, 5));



        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function deleterow(itemid) {
            var table = document.getElementById('tblitemlist1');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            calculatetotal();

        }
    </script>

    <script type="text/javascript">

        function clearForm() {
            var dropdown2 = $("#<%=ddlcentre.ClientID%>");
            $("#<%=ddlcentre.ClientID%> option").remove();
            dropdown2.attr("disabled", false);
            dropdown2.trigger('chosen:updated');
            $('#<%=ddllocation.ClientID%>').prop("disabled", false).prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=ddlcategorytype.ClientID%>').prop("disabled", false).prop('selectedIndex', 0);



            jQuery('#<%=lstZone.ClientID%>').multipleSelect("enable");
            jQuery('#<%=lstCentreType.ClientID%>').multipleSelect("enable");
            jQuery('#<%=lstState.ClientID%>').multipleSelect("enable");
            bindcentertype();
            bindZone();

            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            $('#<%=ddllocation.ClientID%>').prop("disabled", false);
            $('#<%=ddlissuelocation.ClientID%>').prop("disabled", false);
            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0);
            bindindentfromlocation();
            var dropdown3 = $("#<%=ddlissuelocation.ClientID%>");
            dropdown3.attr("disabled", false);
            dropdown3.trigger('chosen:updated');

            $('#tblitemlist tr').slice(1).remove();
            $('#tblitemlist1 tr').slice(1).remove();
            $('#txtitem').val('');
            $('#<%=txtnarration.ClientID%>').val('');
            $find("<%=modelpopup1.ClientID%>").hide();

            clearTempData();

            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
               "Aug", "Sep", "Oct", "Nov", "Dec"];

            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $('#<%=txtdispatchdate.ClientID%>').val(val);
            $('#<%=rdoDispatchType.ClientID%> [value="Courier"]').prop('checked', true);
            setDispatchType();

            $('#<%=txtCourierName.ClientID%>').val('');
            $('#<%=txtnoofbox.ClientID%>').val('');
            $('#<%=txtawbnumber.ClientID%>').val('');
            $('#<%=txttotalweight.ClientID%>').val('');
            $('#<%=txtconsignmentnote.ClientID%>').val('');
            $('#<%=txtTemperature.ClientID%>').val('');


        }

        function createdatatosave() {

            var dataIm = new Array();
            $('#tblitemlist1 tr').each(function () {
                if ($(this).attr("id") != "triteheader1") {
                    var data = $(this).attr("id") + '#' + $(this).find("#tditemid").html() + '#' + $(this).find("#tdQuantity").html() + '#' + $('#<%=ddlissuelocation.ClientID%>').val().split('#')[0] + '#' + $('#<%=ddlissuelocation.ClientID%>').val().split('#')[1];
                    dataIm.push(data);
                }
            });

            return dataIm;
        }

        function saveissue() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Current Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlissuelocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Issue To Location", "");
                $('#<%=ddlissuelocation.ClientID%>').focus();
                return;
            }

            var count = $('#tblitemlist1 tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Select Item Issue ", "");
                $('#txtitem').focus();
                return false;
            }

            var datatosave = createdatatosave();

            var narration = $('#<%=txtnarration.ClientID%>').val();



            var DispatchOption = $("#<%=rdoDispatchType.ClientID%>").find(":checked").val();
            var DispatchDate = $('#<%=txtdispatchdate.ClientID%>').val();
            var CourierName = $('#<%=txtCourierName.ClientID%>').val();
            var AWBNumber = $('#<%=txtawbnumber.ClientID%>').val();
            var NoofBox = $('#<%=txtnoofbox.ClientID%>').val();
            var TotalWeight = $('#<%=txttotalweight.ClientID%>').val();
            var ConsignmentNote = $('#<%=txtconsignmentnote.ClientID%>').val();
            var Temperature = $('#<%=txtTemperature.ClientID%>').val();

            var FieldBoyID = $('#<%=ddlfeildboy.ClientID%>').val();
            var FieldBoyName = $('#<%=ddlfeildboy.ClientID%> option:selected').text();
            var OtherName = $('#<%=txtotherboy.ClientID%>').val();

            serverCall('DirectIssue.aspx/savedirectissue', { datatosave: datatosave, narration: narration, DispatchOption: DispatchOption, DispatchDate: DispatchDate, CourierName: CourierName, AWBNumber: AWBNumber, FieldBoyID: FieldBoyID, FieldBoyName: FieldBoyName, OtherName: OtherName, NoofBox: NoofBox, TotalWeight: TotalWeight, ConsignmentNote: ConsignmentNote, Temperature: Temperature }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success", "Items Issue Successfully..!", "");
                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + response.split('#')[1]);
                    clearForm();

                }
                else {
                    toast("Error", response.split('#')[1], "");
                }

             });
        }
    </script>
    <script type="text/javascript">

        $(function () {
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
                              var _temp = [];
                              _temp.push(serverCall('DirectIssue.aspx/SearchItem', { itemname: extractLast(request.term), locationidfrom: $('#<%=ddllocation.ClientID%>').val(), locationidto: $('#<%=ddlissuelocation.ClientID%>').val(), itemcate: $('#<%=ddlcategorytype.ClientID%>').val() }, function (responsenew) {
                                  jQuery.when.apply(null, _temp).done(function () {
                                      response($.map(jQuery.parseJSON(responsenew), function (item) {
                                          return {
                                              label: item.ItemNameGroup,
                                              value: item.ItemIDGroup
                                          }
                                      }))
                                  });
                              }));
                          },
                          search: function () {
                              // custom minLength

                              var term = extractLast(this.value);
                              if (term.length < 2) {
                                  return false;
                              }
                          },
                          focus: function () {
                              // prevent value inserted on focus
                              return false;
                          },
                          select: function (event, ui) {


                              this.value = '';

                              setTempData(ui.item.value, ui.item.label);
                              // AddItem(ui.item.value);

                              return false;
                          },


                      });


            //  bindindenttolocation();

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
            locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

            locationidto = $('#<%=ddlissuelocation.ClientID%>').val().split('#')[0];

            serverCall('DirectIssue.aspx/bindManufacturer', { locationidfrom: locationidfrom, locationidto: locationidto, ItemIDGroup: ItemIDGroup }, function (response) {
                var tempData = $.parseJSON(response);
                //  console.log(tempData);
                if (tempData.length > 1) {
                    $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val('').html('Select Manufacturer'));
                }
                for (var i = 0; i < tempData.length; i++) {
                    $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val(tempData[i].ManufactureID).html(tempData[i].ManufactureName));
                }
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
            locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];
            locationidto = $('#<%=ddlissuelocation.ClientID%>').val().split('#')[0];
            serverCall('DirectIssue.aspx/bindMachine', { locationidfrom: locationidfrom, locationidto: locationidto, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID }, function (response) {
                var tempData = $.parseJSON(response);
                if (tempData.length > 1) {
                    $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val('').html('Select Machine'));
                }
                for (var i = 0; i < tempData.length; i++) {
                    $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val(tempData[i].MachineID).html(tempData[i].MachineName));
                }
                if (tempData.length == 1) {
                    bindPackSize(ItemIDGroup, ManufactureID, tempData[0].MachineID);
                }
                else {
                    $("#<%=ddlMachine.ClientID %>").focus();
                }
            });

        }
        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];
            locationidto = $('#<%=ddlissuelocation.ClientID%>').val().split('#')[0];
            $("#<%=ddlPackSize.ClientID %> option").remove();

            serverCall('DirectIssue.aspx/bindPackSize', { locationidfrom: locationidfrom, locationidto: locationidto, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }, function (response) {
                var tempData = $.parseJSON(response);
                if (tempData.length > 1) {
                    $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val('').html('Select Pack Size'));
                }
                for (var i = 0; i < tempData.length; i++) {
                    $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val(tempData[i].PackValue).html(tempData[i].PackSize));
                }
                if (tempData.length == 1) {
                    setDataAfterPackSize();
                }
                else if (tempData.length == 0 || tempData.length > 0) {
                    $("#<%=ddlPackSize.ClientID %>").focus();
                }
            });
        }
         function setDataAfterPackSize() {
             if ($("#<%=ddlPackSize.ClientID %>").val() != '') {

                 $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);

             }

         }


         function clearTempData() {
             $("#<%=ddlManufacturer.ClientID %> option").remove();
             $("#<%=ddlMachine.ClientID %> option").remove();
             $("#<%=ddlPackSize.ClientID %> option").remove();
             $("#<%=lblItemID.ClientID %>").html('');
             $("#<%=lblItemGroupID.ClientID %>").html('');
             $("#<%=lblItemName.ClientID %>").html('');
             $('#txtitem').val('');

         }

         function searchitem() {

             if ($('#<%=lblItemID.ClientID%>').html() == "") {

                 toast("Error", "Please Select Item", "");
                return;
            }
            AddItem($('#<%=lblItemID.ClientID%>').html(), "");

            clearTempData();
        }

    </script>

    <script type="text/javascript">

        function issueall() {
            var a = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    a = 1;
                }
            });
            if (a == 0) {
                toast("Error", "Please Select Item To Add", "");
                return;
            }


            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                    issueme($(this).find("#chk"));
                }
            });
        }
    </script>


    <script type="text/javascript">


        function setDispatchType() {

            if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "Courier") {
                $('.FieldBoy').hide();
                $('.Courier').show();
                $('#<%=ddlfeildboy.ClientID%>').prop('selectedIndex', 0);
                $('#<%=txtotherboy.ClientID%>').val('');

                var date = new Date();
                var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                   "Aug", "Sep", "Oct", "Nov", "Dec"];

                var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
                $('#<%=txtdispatchdate.ClientID%>').val(val);


            }
            else if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "FieldBoy") {
                $('.FieldBoy').show();
                $('.Courier').hide();
                $('#<%=txtCourierName.ClientID%>').val('');
                $('#<%=txtnoofbox.ClientID%>').val('');
                $('#<%=txtawbnumber.ClientID%>').val('');
                $('#<%=txttotalweight.ClientID%>').val('');
                $('#<%=txtconsignmentnote.ClientID%>').val('');
                $('#<%=txtTemperature.ClientID%>').val('');


                var date = new Date();
                var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                   "Aug", "Sep", "Oct", "Nov", "Dec"];

                var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
                $('#<%=txtdispatchdate.ClientID%>').val(val);
            }
    }



    $('#<%=ddlfeildboy.ClientID%>').change(function () {
            var value = $('#<%=ddlfeildboy.ClientID %> option:selected').text();
            $('#<%=txtotherboy.ClientID%>').css('display', (value == 'Other') ? 'block' : 'none');
        });



        function bindfieldboy() {
            var dropdown = $("#<%=ddlfeildboy.ClientID%>");
            $("#<%=ddlfeildboy.ClientID%> option").remove();
            var centreid = '<%= UserInfo.Centre%>';

            serverCall('../Lab/Services/LabBooking.asmx/getfieldboy', { centreid: centreid }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'Name' });
            });
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
                    toast("Error",res);
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



        function checkpageaccessto() {

            if ($('#<%=ddlissuelocation.ClientID%>').val() != "0") {
                var res = CheckOtherStorePageAccess($('#<%=ddlissuelocation.ClientID%>').val().split('#')[0]);
                if (res != "1") {
                    $('#trme').hide();
                    $('#trme').html('');
                    $('#trme1').hide();
                    $('#trme1').html('');
                    toast("Error", res, "");
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

