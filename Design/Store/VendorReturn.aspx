<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorReturn.aspx.cs" Inherits="Design_Store_VendorReturn" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Return Item To Supplier</b>
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
                                <label class="pull-left ">Location   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddllocation" runat="server" class="ddllocation chosen-select chosen-container" onchange="binditem()"></asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Supplier   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:DropDownList ID="ddlsupplier" runat="server" class="ddlsupplier chosen-select chosen-container" onchange="binditem()"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Item   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:ListBox ID="lstitem" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Barcode No.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:TextBox ID="txtbarcodeno" runat="server" placeholder="Scan Barcode For Quick Return" BackColor="lightyellow" Style="border: 1px solid red;" Font-Bold="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row" style="display: none">
                            <div class="col-md-3 ">
                                <label class="pull-left ">From Date   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:TextBox ID="txtdatefrom" runat="server" ReadOnly="true" />
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">To Date   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9 ">
                                <asp:TextBox ID="txtdateto" runat="server" ReadOnly="true" />
                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtdateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="div6">
                <div class="row">
                    <div class="col-md-24 ">
                        <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                        <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                        <span id="btnsave1" style="display: none;"><b><span class="required">Remarks</span> :</b>
                            <input type="text" id="txtremarks" style="width: 150px;" /></span>
                        <input type="button" value="Save" id="btnsave" style="display: none;" class="savebutton" onclick="savedata()" />
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="Div1">
            <div id="div2">
                <div class="Purchaseheader">
                    <table width="60%">
                        <tr>
                            <td style="width: 15%;">Item List </td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Expired Item</td>

                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Expired With In 1 Month</td>

                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Not Expired</td>
                        </tr>
                    </table>
                </div>
                <div class="row">
                    <div class="col-md-24">
                       
                                <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <tr id="triteheader">

                                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Purchase<br />
                                            Date</td>
                                        <td class="GridViewHeaderStyle">Stockid</td>
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                        <td class="GridViewHeaderStyle">Item<br />
                                            ID</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">BarcodeNo.</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Batch<br />
                                            Number</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">Expiry<br />
                                            Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Purchase<br />
                                            Qty</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Purchase<br />
                                            Unit</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Conv erter</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Inhand<br />
                                            Qty.</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Consume<br />
                                            Unit</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Return<br />
                                            Qty.</td>
                                        <td class="GridViewHeaderStyle">Rate</td>
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

        </div>
    </div>
    <script type="text/javascript">

        $("#<%= txtbarcodeno.ClientID%>").keydown(
             function (e) {
                 var key = (e.keyCode ? e.keyCode : e.charCode);
                 if (key == 13) {
                     e.preventDefault();
                     if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {

                         searchdata();
                     }



                 }

             });


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

                 $('#<%=lstitem.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });


        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }


        function binditem() {


            $('#<%=lstitem.ClientID%> option').remove();
            $('#<%=lstitem.ClientID%>').multipleSelect("refresh");

            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier..!", "");
                $('#<%=ddlsupplier.ClientID%>').focus();
                return;
            }

            serverCall('vendorreturn.aspx/binditem', { locationid: $('#<%=ddllocation.ClientID%>').val(), supplierid: $('#<%=ddlsupplier.ClientID%>').val() }, function (response) {
                var $ddlitem = $('#<%=lstitem.ClientID%>');
                $ddlitem.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', controlID: $("#lstitem"), isClearControl: '' });
            });
        }
        
    </script>

    <script type="text/javascript">
        function searchdata() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select Location..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier..!", "");
                $('#<%=ddlsupplier.ClientID%>').focus();
                return;
            }

            var itemid = $('#<%=lstitem.ClientID%>').val();
            var barcodeno = $('#<%=txtbarcodeno.ClientID%>').val();
            if (itemid == "" && barcodeno == "") {
                toast("Error", "Please Select Item or Scan Barcode..!", "");
                return;
            }
            $modelBlockUI();
            $('#tblitemlist tr').slice(1).remove()


            serverCall('vendorreturn.aspx/SearchData', { locationid: $('#<%=ddllocation.ClientID%>').val(), supplierid: $('#<%=ddlsupplier.ClientID%>').val(), fromdate: $('#<%=txtdatefrom.ClientID%>').val(), todate: $('#<%=txtdateto.ClientID%>').val(), itemid: itemid, barcodeno: barcodeno }, function (response) {
                rowcolor = "";
                if (response == "-1") {
                    $modelUnBlockUI();
                    openmapdialog();
                    return;
                }

                ItemData = jQuery.parseJSON(response);

                if (ItemData.length == 0) {
                    toast("Error", "No Item Found..!", "");
                    $modelUnBlockUI();
                    $('#btnsave').hide();
                    $('#btnsave1').hide();


                    $('#<%=txtbarcodeno.ClientID%>').val('');

                }
                else {
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    for (var i = 0; i <= ItemData.length - 1; i++) {


                        var rowcolor = "";
                        if (Number(ItemData[i].exdate) >= 31) {
                            rowcolor = "lightgreen";
                        }
                        else if (Number(ItemData[i].exdate) >= 0 && Number(ItemData[i].exdate) <= 30) {
                            rowcolor = "bisque";
                        }
                        else if (Number(ItemData[i].exdate) < 0) {
                            rowcolor = "pink";
                        }

                        var $mydata = [];

                        $mydata.push("<tr style='background-color:"); $mydata.push(rowcolor); $mydata.push(";' id='"); $mydata.push(ItemData[i].StockID);  $mydata.push("'>");
                        $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="PurchaseDate">'); $mydata.push(ItemData[i].PurchaseDate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="StockID" style="font-weight:bold;">'); $mydata.push(ItemData[i].StockID); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="CategoryTypeName">'); $mydata.push(ItemData[i].CategoryTypeName); $mydata.push('</td>');

                        $mydata.push('<td class="GridViewLabItemStyle" id="ItemID" style="font-weight:bold;">'); $mydata.push(ItemData[i].ItemID); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="ItemName" style="font-weight:bold;">'); $mydata.push(ItemData[i].ItemName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="BarcodeNo">'); $mydata.push(ItemData[i].BarcodeNo); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="BatchNumber">'); $mydata.push(ItemData[i].BatchNumber); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="ExpiryDate">'); $mydata.push(ItemData[i].ExpiryDate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="PurchaseQty" style="font-weight:bold;">'); $mydata.push(ItemData[i].PurchaseQty); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="MajorUnit">'); $mydata.push(ItemData[i].MajorUnit); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="Converter">'); $mydata.push(ItemData[i].Converter); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="Inhandqty" style="font-weight:bold;">'); $mydata.push(ItemData[i].Inhandqty); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="MinorUnit">'); $mydata.push(ItemData[i].MinorUnit); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  ><input type="text" placeholder="Rtn Qty" onkeyup="showme1(this);"  id="txtreturnqty" style="width:50px;"/></td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="Rate">'); $mydata.push(ItemData[i].Rate); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="DiscountAmount">'); $mydata.push(ItemData[i].DiscountAmount); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="TaxAmount">'); $mydata.push(ItemData[i].TaxAmount); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="UnitPrice">'); $mydata.push(ItemData[i].UnitPrice); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="tdlocationid" style="display:none;">'); $mydata.push(ItemData[i].LocationID); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle"  id="tdVendorIDid" style="display:none;">'); $mydata.push(ItemData[i].VendorID); $mydata.push('</td>');

                        $mydata.push('<td class="GridViewLabItemStyle"  >');
                        if (Number(ItemData[i].Inhandqty) > 0) {
                            $mydata.push('<input type="checkbox" id="ch"/> ');
                        }
                        $mydata.push('</td>');
                        $mydata.push("</tr>");

                        $mydata = $mydata.join("");
                        $('#tblitemlist').append($mydata);

                    }

                    $modelUnBlockUI();
                    $('#btnsave').show();

                    $('#btnsave1').show();
                }

            });
        }

    </script>

    <script type="text/javascript">
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


            var avlqty = parseFloat($(ctrl).closest('tr').find('#Inhandqty').html());







            if (parseFloat($(ctrl).val()) > parseFloat(avlqty)) {
                toast("Error", "Can Not Return More Then In Hand Qty..!", "");

                $(ctrl).val('');
                return;
            }



            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#ch').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#ch').prop('checked', false)
            }

        }


    </script>

    <script type="text/javascript">
        function validation() {

            var che = "true";
            var a = $('#tblitemlist tr').length;
            if (a == 1) {
                toast("Error", "Please Search Item..!", "");
                return false;
            }
            if (a > 0) {
                $('#tblitemlist tr').each(function () {
                    if ($(this).attr("id") != "triteheader" && $(this).find("#ch").is(':checked') && ($(this).find("#txtreturnqty").val() == "" || $(this).find("#txtreturnqty").val() == "0")) {
                        $(this).find("#txtreturnqty").focus();
                        toast("Error", "You have not Entered Qty..!", "");
                        che = "false";
                        return false;

                    }
                });
            }
            if (che == "false") {
                return false;
            }


            if ($('#txtremarks').val() == "") {
                toast("Error", "Please Enter Remarks..!", "");
                $('#txtremarks').focus();
                return false;
            }
            return true;
        }

        function getcompletedataadj() {
            var tempData = [];

            $('#tblitemlist tr').each(function () {

                if ($(this).attr("id") != "triteheader") {
                    if ($(this).find("#ch").is(':checked')) {

                        var Itemmaster = [];
                        Itemmaster[0] = $(this).find('#tdlocationid').html();
                        Itemmaster[1] = $(this).find('#tdVendorIDid').html();
                        Itemmaster[2] = $(this).attr("id");
                        Itemmaster[3] = $(this).find('#txtreturnqty').val();
                        Itemmaster[4] = $(this).find('#ItemID').html();
                        Itemmaster[5] = $('#txtremarks').val();
                        tempData.push(Itemmaster);
                    }
                }
            });

            return tempData;
        }


        function savedata() {
            if (validation() == true) {

                var mydataadj = getcompletedataadj();
                if (mydataadj.length == 0) {
                    toast("Error", "Please Select Item To Save..!", "");
                    return;
                }
                $modelBlockUI();


                serverCall('vendorreturn.aspx/savedata', { mydataadj: mydataadj }, function (response) {
                    $modelUnBlockUI();
                    if (response.split('#')[0] == "1") {
                        toast("Success", "Item Return To vendor Successfully..!", "");
                        resetme();
                        window.open('VendorReturnReceipt.aspx?salesno=' + response.split('#')[1]);

                    }
                    else {
                        toast("Error", response.split('#')[1], "");
                    }

                });
            }
        }


        function resetme() {


            $('#tblitemlist tr').slice(1).remove();
            $('#txtremarks').val('');

            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
                 $('#<%=ddlsupplier.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
                 $('#<%=lstitem.ClientID%> option').remove();
                 $('#<%=lstitem.ClientID%>').multipleSelect("refresh");

                 $('#btnsave').hide();
                 $('#btnsave1').hide();

             }

    </script>
</asp:Content>

