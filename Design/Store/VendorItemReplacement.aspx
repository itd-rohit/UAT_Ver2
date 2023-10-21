<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorItemReplacement.aspx.cs" Inherits="Design_Store_VendorItemReplacement" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
    
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Item Replacement </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Return From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtdatefrom" runat="server"  ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Return To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtdateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtdateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddllocation" runat="server"  class="ddllocation chosen-select chosen-container"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Supplier   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlsupplier" runat="server" class="ddlsupplier chosen-select chosen-container"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24 " style="text-align: center">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                    &nbsp;
                        <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                    &nbsp;
                      
                         <input type="button" value="Save" id="btnsave" style="display: none;" class="savebutton" onclick="savedata()" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">           
            <div style="width: 99%; max-height: 330px; overflow: auto;">
                <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                    <tr id="triteheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">NewBatch</td>
                        <td class="GridViewHeaderStyle" style="width: 74px;">Return Date</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">Item Type</td>
                        <td class="GridViewHeaderStyle" style="width: 60px;">Stock ID</td>
                        <td class="GridViewHeaderStyle" style="width: 60px;">Item ID</td>
                        <td class="GridViewHeaderStyle">Item Name</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">Return Qty.</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">OLDReplace Qty.</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">Remain Qty.</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">BatchNumber</td>
                        <td class="GridViewHeaderStyle" style="width: 70px;">ExpiryDate</td>
                        <td class="GridViewHeaderStyle" style="width: 110px;">ReplaceQty.</td>
                        <td class="GridViewHeaderStyle" style="width: 50px;">Rate</td>
                        <td class="GridViewHeaderStyle" style="width: 30px;">Disc.<br />
                            Amt.</td>
                        <td class="GridViewHeaderStyle" style="width: 30px;">Tax<br />
                            Amt.</td>
                        <td class="GridViewHeaderStyle" style="width: 30px;">Unit<br />
                            Price</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                    </tr>
                </table>
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
        });
        function resetme() {
            $('#tblitemlist tr').slice(1).remove();
            $('#txtremarks').val('');
            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=ddlsupplier.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#btnsave').hide();
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

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier", "");
                $('#<%=ddlsupplier.ClientID%>').focus();
                return;
            }
            var fromdate = $('#<%=txtdatefrom.ClientID%>').val();
            var todate = $('#<%=txtdateto.ClientID%>').val();        
            $('#tblitemlist tr').slice(1).remove()
            serverCall('VendorItemReplacement.aspx/SearchData', { locationid: $('#<%=ddllocation.ClientID%>').val(), supplierid: $('#<%=ddlsupplier.ClientID%>').val(), fromdate: fromdate, todate: todate }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (response == "-1") {
                    $.unblockUI();
                    openmapdialog();
                    return;
                }
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found", "");
                    $('#btnsave').hide();
                    $('#btnsave1').hide();
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var rowcolor = "lightgreen";
                        var $myData = [];
                        $myData.push("<tr style='background-color:"); $myData.push(rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].id); $myData.push("' class='tr_clone'>");
                        $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].BarcodeOption == "1" && ItemData[i].BarcodeGenrationOption == "1") {

                        }
                        else {
                            $myData.push(' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addmenow(this);" />');
                        }
                        $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle"  id="PurchaseDate">'); $myData.push(ItemData[i].ReturnDate); $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle" id="CategoryTypeName">'); $myData.push(ItemData[i].CategoryTypeName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="Stockid" style="font-weight:bold;">'); $myData.push(ItemData[i].StockID); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="ItemID" style="font-weight:bold;">'); $myData.push(ItemData[i].ItemID); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="ItemName" style="font-weight:bold;">'); $myData.push(ItemData[i].ItemName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="returnqty" style="font-weight:bold;">'); $myData.push(ItemData[i].ReturnQty); $myData.push('&nbsp;&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].MinorUnit); $myData.push('</span></td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="returnqty" style="font-weight:bold;">'); $myData.push(ItemData[i].ReplaceQty); $myData.push('&nbsp;&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].MinorUnit); $myData.push('</span></td>');
                        $myData.push('<td class="GridViewLabItemStyle" id="returnqty" style="font-weight:bold;">'); $myData.push(ItemData[i].RemainQty); $myData.push('&nbsp;&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].MinorUnit); $myData.push('</span></td>');
                        $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" style="width:100px;" onblur="checkduplicatebatchno(this)"  /></td>');
                        $myData.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate'); $myData.push(i); $myData.push('" style="width:90px;" class="exdate"  /></td>');
                        $myData.push('<td class="GridViewLabItemStyle"  ><input type="text" placeholder="Qty" onkeyup="showme1(this);"  id="txtreplaceqty" style="width:70px;"/>&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].MinorUnit); $myData.push('</span></td>');

                        $myData.push('<td class="GridViewLabItemStyle"  id="Rate">'); $myData.push(ItemData[i].Rate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="DiscountAmount">'); $myData.push(ItemData[i].DiscountAmount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="TaxAmount">'); $myData.push(ItemData[i].TaxAmount); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="UnitPrice">'); $myData.push(ItemData[i].UnitPrice); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tdlocationid" style="display:none;">'); $myData.push(ItemData[i].LocationID); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tdVendorIDid" style="display:none;">'); $myData.push(ItemData[i].VendorID); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tdReturnQty" style="display:none;">'); $myData.push(ItemData[i].RemainQty); $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle"  >');
                        $myData.push('<input type="checkbox" id="chk"/> ');
                        $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                        var date = new Date();
                        var newdate = new Date(date);
                        newdate.setDate(newdate.getDate());
                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                   "Aug", "Sep", "Oct", "Nov", "Dec"];
                        var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();
                        $("#txtexpirydate" + i).datepicker({
                            dateFormat: "dd-M-yy",
                            changeMonth: true,
                            changeYear: true, yearRange: "-0:+20", minDate: val
                        });
                    }
                    $('#btnsave').show();
                    $('#btnsave1').show();
                }
            });
        }


        function addmenow(ctrl) {
            var $tr = $(ctrl).closest('.tr_clone');
            var $clone = $tr.clone();
            $clone.find('#txtbacknumber').val('');
            $clone.find('#txtreplaceqty').val('');
            var newid = Math.floor(1000 + Math.random() * 9000);
            $clone.find('.exdate').attr('id', newid);
            $clone.find('.exdate').removeClass('hasDatepicker');
            var date1 = new Date();
            var newdate1 = new Date(date1);
            newdate1.setDate(newdate1.getDate());
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
       "Aug", "Sep", "Oct", "Nov", "Dec"];
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
        }
        function showme1(ctrl) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
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
            var avlqty = parseFloat($(ctrl).closest('tr').find('#tdReturnQty').html());
            if (parseFloat($(ctrl).val()) > parseFloat(avlqty)) {
                toast("Error", "Can Not Return More Then Replace Qty.!", "");
                $(ctrl).val('');
                return;
            }
            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
        }
    </script>
    <script type="text/javascript">
        function validation() {
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
            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier", "");
                $('#<%=ddlsupplier.ClientID%>').focus();
                return;
            }
            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Select Item  ", "");
                $('#txtitem').focus();
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



                    if ($(this).find(".exdate").val() == "") {
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



            var sn1 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader" && $(this).find("#chk").is(':checked')) {
                    var qty = $(this).find('#txtreplaceqty').val() == "" ? 0 : parseFloat($(this).find('#txtreplaceqty').val());

                    if (qty == 0) {
                        sn1 = 1;
                        $(this).find('#txtreplaceqty').focus();

                        return;
                    }
                }
            });

            if (sn1 == 1) {
                toast("Error", "Please Enter Quantity ", "");

                return false;
            }




            return true;
        }

        function getdata() {
            var datastock = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader" && $(this).find("#chk").is(':checked')) {
                    var objStockMaster = new Object();
                    objStockMaster.VendorID = $('#<%=ddlsupplier.ClientID%>').val();
                    objStockMaster.LocationID = $('#<%=ddllocation.ClientID%>').val();
                    objStockMaster.ReturnID = id;
                    objStockMaster.StockID = $(this).closest("tr").find('#Stockid').html();
                    objStockMaster.ItemID = $(this).closest("tr").find('#ItemID').html();
                    objStockMaster.Qty = $(this).closest("tr").find('#txtreplaceqty').val();
                    objStockMaster.BatchNumber = $(this).closest("tr").find('#txtbacknumber').val();
                    objStockMaster.ExpiryDate = $(this).closest("tr").find('.exdate').val();
                    datastock.push(objStockMaster);
                }
            });
            return datastock;
        }

        function savedata() {
            if (validation() == false) {
                return;
            }

            var mydata = getdata();

            if (mydata.length == 0) {
                toast("Error", "Please Select Item", "");

                return;
            }
            serverCall('VendorItemReplacement.aspx/savedata', { mydata: mydata }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success", "Item Replaced Successfully", "");
                    resetme();
                }
                else {
                    toast("Error", response.split('#')[1], "");
                }
            });
        }
    </script>
</asp:Content>

