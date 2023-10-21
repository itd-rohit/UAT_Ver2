<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PODGenerate.aspx.cs" Inherits="Design_Store_PODGenerate" %>

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

    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <%--durga msg changes--%>

        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Generate POD</b>
                        </td>
                    </tr>
                </table>
            </div>
        </div>



        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="Purchaseheader">
                </div>
            </div>

            <table width="99%">
                <tr>
                    <td style="font-weight: 700">GRN Location :</td>
                    <td>
                        <asp:DropDownList ID="ddllocation" runat="server"  class="ddllocation chosen-select chosen-container"  Style="width: 245px;" ClientIDMode="Static"></asp:DropDownList>
                    </td>

                    <td>From Date :</td>
                    <td>
                        <asp:TextBox ID="txtentrydatefrom" runat="server" Width="160px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>

                    <td>To Date :</td>
                    <td>
                        <asp:TextBox ID="txtentrydateto" runat="server" Width="160px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>



                </tr>
                <tr>
                    <td colspan="5" style="text-align: right">

                        <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />


                    </td>

                    <td colspan="3">
                        <table width="100%">
                            <tr>
                                <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>


                                <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td>Un-Generated</td>

                                <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td>Generated</td>
                                <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td>Transfer</td>
                            </tr>
                        </table>
                    </td>
                </tr>

            </table>
        </div>





        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="Purchaseheader">
                    GRN Detail
                </div>

                <div style="width: 99%; max-height: 375px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">

                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;">View Item</td>
                            <td class="GridViewHeaderStyle">GRN No</td>
                            <td class="GridViewHeaderStyle">POD No</td>
                            <td class="GridViewHeaderStyle">Location</td>
                            <td class="GridViewHeaderStyle">Transfer</td>
                            <td class="GridViewHeaderStyle">PO Number</td>
                            <td class="GridViewHeaderStyle">Invoice No</td>
                            <%--  <td class="GridViewHeaderStyle">Challan No</td>--%>

                            <td class="GridViewHeaderStyle">Supplier</td>
                            <td class="GridViewHeaderStyle">GRN Date</td>

                            <td class="GridViewHeaderStyle">Gross Amt</td>
                            <td class="GridViewHeaderStyle">Disc Amt</td>
                            <td class="GridViewHeaderStyle">Tax Amt</td>
                            <td class="GridViewHeaderStyle">GRN/Net Amt</td>


                            <td class="GridViewHeaderStyle" style="width: 20px;">Select </td>
                             <td class="GridViewHeaderStyle" style="width: 20px;">Print GRN </td>
                            <td class="GridViewHeaderStyle" style="width: 20px; display: none;">id </td>






                        </tr>
                    </table>

                </div>
                <div style="margin-left: 492px;">
                    <input type="button" value="Generate POD" id="genpod" class="searchbutton" onclick="savedata()" />

                    <%--<asp:Button ID="transpod" Text="Transfer POD" CssClass="searchbutton" runat="server" OnClientClick="opentransferpopup();" />--%>
                    <input type="button" value="Transfer POD" id="transpod" class="searchbutton" onclick="opentransferpopup()" />
                    <%-- onclick="transferdata()--%>
                </div>
            </div>


        </div>



    </div>
    <div id="popup_box" style="background-color: lightgreen; height: 80px; text-align: center; width: 340px;">
        <div id="showpopupmsg" style="font-weight: bold;"></div>
        <br />
        <span id="GRNID" style="display: none;"></span><span id="type" style="display: none;"></span>
        <input type="button" class="searchbutton" value="Yes" onclick="Post();" />

    </div>


    <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="600px">


        <div class="Purchaseheader">
            Transfer Detail
        </div>
        <div style="width: 99%; max-height: 375px; overflow: auto;">
            <table id="Table1" style="width: 99%; border-collapse: collapse; text-align: left;">
                <tr>
                    <td>Courier Name</td>
                    <td>
                        <asp:TextBox ID="txtcurriername" runat="server"></asp:TextBox></td>

                </tr>
                <tr>
                    <td>Consignment No.</td>
                    <td>
                        <asp:TextBox ID="txtconsinment" runat="server"></asp:TextBox></td>

                </tr>
                <tr>
                    <td>Courier Date</td>
                    <td>
                        <asp:TextBox ID="txtcurrierdate" runat="server" Width="160px" ReadOnly="true"></asp:TextBox></td>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtcurrierdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </tr>
            </table>

        </div>

        <center><%--<asp:Button ID="btnsave" runat="server" CssClass="searchbutton" Text="Save" OnClientClick="transferdata();" />--%><input type="button" class="searchbutton" value="Save" onclick="transferdata();" /><asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
        </center>

    </asp:Panel>
    <asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="lnkDummy" BehaviorID="mpe" BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>






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

        $(document).ready(function () {

            $("#genpod").hide();
            $("#transpod").hide();

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


    </script>

    <script type="text/javascript">


        function checkPaitent(ID) {
            var cls = $(ID).attr("data");

            if ($(ID).prop('checked') == true) {
                $(".mmc").prop("checked", false)
                $("." + cls).prop("checked", true)
            }
        }



        function searchdata() {


            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }




            var location = $("#<%=ddllocation.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            if (location == 0) {
                showerrormsg("Please select location..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            $.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "PODGenerate.aspx/SearchData",
                data: '{location:"' + location + '",fromdate:"' + fromdate + '",todate:"' + todate + '",supplier:"' + 0 + '",ponumber:"' + '' + '",invoiceno:"' + '' + '",grnno:"' + '' + '",grnstatus:"' + 1 + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No GRN Found");
                        $.unblockUI();
                        $("#genpod").hide();
                        $("#transpod").hide();


                    }
                    else {
                        $("#genpod").show();
                        $("#transpod").show();
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:" + ItemData[i].rowColor + ";' id='" + ItemData[i].LedgerTransactionID + "'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>';

                            if (ItemData[i].IsDirectGRN == "1") {
                                mydata += '<td title="Direct GRN" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:aqua;font-weight:bold;">' + ItemData[i].LedgerTransactionNo + '</td>';
                            }
                            else {
                                mydata += '<td title="GRN Against PO" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:green;font-weight:bold;color:white;">' + ItemData[i].LedgerTransactionNo + '</td>';
                            }

                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PODnumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].location + '</td>';
                            if (ItemData[i].Ispodgenerate == "1" && ItemData[i].IsPOD_transfer == "0") {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox" id="mmchk" name="transferchk" onchange="checkPaitent(this)" class="mmc ' + ItemData[i].podgroup + '" data="' + ItemData[i].podgroup + '"/></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ></td>';
                            }


                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PurchaseOrderNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].InvoiceNo + '</td>';
                            //mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ChalanNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].SupplierName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].GRNDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].GrossAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].DiscountOnTotal, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].TaxAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].NetAmount, 5) + '</td>';


                            if (ItemData[i].Ispodgenerate == "1") {
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" name="podchk" value=' + ItemData[i].LedgerTransactionNo + '>    &nbsp;   </td>';
                            }

                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" >' + ItemData[i].LedgerTransactionID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" >' + ItemData[i].locationid + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" />  </td>';
                            mydata += "</tr>";


                            $('#tblitemlist').append(mydata);

                        }
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });



        }




        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function viewdoc(ctrl) {
            openmypopup('AddGRNDocument.aspx?GRNNo=' + $(ctrl).closest('tr').attr("id"));
        }

        function editgrn(ctrl) {
            openmypopup('DirectGrnEdit.aspx?GRNID=' + $(ctrl).closest('tr').attr("id"));
        }
        function editgrnpo(ctrl) {
            openmypopup('GrnFromPOEdit.aspx?GRNID=' + $(ctrl).closest('tr').attr("id"));
        }

        function printme(ctrl) {

            window.open('GRNReceipt.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id"));
        }

        function printmebarcode(ctrl) {
            openmypopup('GRNPrintbarcode.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id"));

        }

        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            $.blockUI();

            $.ajax({
                url: "PODGenerate.aspx/BindItemDetail",
                data: '{GRNID:"' + id + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No GRN Found");
                        $.unblockUI();

                    }
                    else {
                        $(ctrl).attr("src", "../../App_Images/minus.png");
                        var mydata = "<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>";
                        mydata += '<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;">#</td>';
                        mydata += '<td>Item Name</td>';
                        mydata += '<td>BarcodeNo</td>';
                        mydata += '<td>Batch Number</td>';
                        mydata += '<td>Expiry Date</td>';
                        mydata += '<td>Rate</td>';
                        mydata += '<td>Disc %</td>';
                        mydata += '<td>Tax%</td>';
                        mydata += '<td>Unit Price</td>';
                        mydata += '<td>Paid Qty</td>';
                        mydata += '<td>Free Qty</td>';
                        mydata += '<td>InHand Qty</td>';
                        mydata += '<td>Unit</td>';


                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            mydata += "<tr style='background-color:#70e2b3;' id='" + ItemData[i].stockid + "'>";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';



                            mydata += '<td >' + ItemData[i].itemname + '</td>';
                            mydata += '<td >' + ItemData[i].barcodeno + '</td>';
                            mydata += '<td  >' + ItemData[i].batchnumber + '</td>';
                            mydata += '<td  >' + ItemData[i].ExpiryDate + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].rate, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].discountper, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].taxper, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].unitprice, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].PaidQty, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].freeQty, 5) + '</td>';
                            mydata += '<td  >' + precise_round(ItemData[i].initialcount, 5) + '</td>';
                            mydata += '<td  >' + ItemData[i].MajorUnit + '</td>';


                            mydata += "</tr>";




                        }
                        mydata += "</table><div>";

                        var newdata = '<tr id="ItemDetail' + id + '"><td colspan="18">' + mydata + '</td></tr>';

                        $(newdata).insertAfter($(ctrl).closest('tr'));


                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });


        }
        function PostDialog(ctrl, type) {

            $('#showpopupmsg').show();
            if (type == "1")
                $('#showpopupmsg').html("Do You Want To Post?");
            else if (type == "0")
                $('#showpopupmsg').html("Do You Want To UnPost?");
            else
                $('#showpopupmsg').html("Do You Want To Cancel?");

            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });

            var id = $(ctrl).closest('tr').attr("id");
            $('#GRNID').html(id);
            $('#type').html(type);

        }



        function printme(ctrl) {

            window.open('GRNReceipt.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id"));
        }


        function savedata() {
            debugger;


            var checkedValues = $("input[name='podchk']:checked", "#tblitemlist").map(function () {
                return $(this).val();
            }).get();
            var alldata = checkedValues.join(',');
            if (checkedValues.length == 0) {
                showerrormsg("Please select minimum one option");
                return;
            }

            var dataIm = new Array();
            var objpod = new Object();
            $('#tblitemlist tr').each(
                 function () {
                     var row = $(this);
                     if (row.find('input[name="podchk"]').is(':checked')) {


                         objpod.LedgerTransactionID = row.find('td:eq(15)').text();
                         objpod.grn_no = row.find('td:eq(2)').text();
                         objpod.podnumber = row.find('td:eq(3)').text();
                         objpod.invoicenumber = row.find('td:eq(6)').text();
                         objpod.grossamt = row.find('td:eq(10)').text();
                         objpod.discamt = row.find('td:eq(11)').text();
                         objpod.taxamt = row.find('td:eq(12)').text();
                         objpod.netamt = row.find('td:eq(13)').text();
                         objpod.location = row.find('td:eq(16)').text();
                         dataIm.push(objpod);
                         objpod = new Object();
                     }
                     return dataIm;
                 });


            $.ajax({
                url: "PODGenerate.aspx/Post",
                data: JSON.stringify({ objpoddetails: dataIm }),
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "1") {
                        showmsg("GRN Post Sucessfully..!");

                        unloadPopupBox();
                        searchdata();

                    }
                    else if (result.d == "2") {
                        showerrormsg("Item Already Issued You Can Not UnPost Or Cancel..!");
                        unloadPopupBox();
                    }
                    else {
                        showerrormsg("Error.. Please Try Again");
                        unloadPopupBox();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                    $.unblockUI();
                    unloadPopupBox();

                }
            });
        }




        function opentransferpopup() {

            var checkedValues = $("input[name='transferchk']:checked", "#tblitemlist").map(function () {
                return $(this).val();
            }).get();
            var alldata = checkedValues.join(',');
            if (checkedValues.length == 0) {
                showerrormsg("Please select minimum one POD option");
                $find('mpe').hide();
                return;
            }
            else {
                $find('mpe').show();


            }


        }


        function transferdata() {

            var checkedValues = $("input[name='transferchk']:checked", "#tblitemlist").map(function () {
                return $(this).val();
            }).get();
            var alldata = checkedValues.join(',');
            if (checkedValues.length == 0) {
                showerrormsg("Please select minimum one POD option");
                return;
            }
            var curriername = $("#<%=txtcurriername.ClientID%>").val();
            var consinment = $("#<%=txtconsinment.ClientID%>").val();
            var courierdate = $("#<%=txtcurrierdate.ClientID%>").val();

            if (curriername == "" || curriername == null) {
                showerrormsg("Please Fill currier name !!!");
                return;
            }

            if (consinment == "" || consinment == null) {
                showerrormsg("Please Fill consinment number !!!");
                return;
            }

            if (courierdate == "" || courierdate == null) {
                showerrormsg("Please Fill currier date !!!");
                return;
            }


            var dataIm = new Array();
            var objpod = new Object();
            $('#tblitemlist tr').each(
                 function () {
                     var row = $(this);
                     if (row.find('input[name="transferchk"]').is(':checked')) {

                         objpod.LedgerTransactionID = row.find('td:eq(14)').text();
                         objpod.grn_no = row.find('td:eq(2)').text();
                         objpod.podnumber = row.find('td:eq(3)').text();

                         dataIm.push(objpod);
                         objpod = new Object();
                     }
                     return dataIm;
                 });


            $.ajax({
                url: "PODGenerate.aspx/transfer",
                data: JSON.stringify({ objpoddetails: dataIm, curriername: curriername, consinment: consinment, courierdate: courierdate }),
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "1") {
                        showmsg("POD Transfer Sucessfully..!");
                        searchdata();

                        $("#<%=txtcurriername.ClientID%>").val("");
                        $("#<%=txtconsinment.ClientID%>").val("");
                        $("#<%=txtcurrierdate.ClientID%>").val("");
                        $find("mpe").hide();
                        return false;

                    }
                    else if (result.d == "2") {
                        showerrormsg("You haven't Permission to transfer POD");
                    }
                    else {
                        showerrormsg("Error.. Please Try Again");

                    }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                    $.unblockUI();


                }
            });

        }


    </script>
</asp:Content>
