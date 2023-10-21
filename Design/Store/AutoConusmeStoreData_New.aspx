<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AutoConusmeStoreData_New.aspx.cs" Inherits="Design_Store_AutoConusmeStoreData_New" %>

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
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: center">
                            <b>Auto Consume Store Item</b>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="Purchaseheader">Location Detail</div>
                <table style="width: 100%">
                    <tr>
                        <td style="font-weight: 700">Search Type:</td>
                        <td colspan="2">
                            <select id="ddlSearchType" class="ddlSearchType chosen-select chosen-container" style="width: 180px">
                                
                                <option value="Machine">Machine Wise</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700">From Date:</td>
                        <td>
                            <asp:TextBox ID="txtFromDate" runat="server" Width="90px" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="font-weight: 700">To Date:</td>
                        <td>
                            <asp:TextBox ID="txtToDate" runat="server" Width="90px" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right; font-weight: 700">Location :&nbsp; </td>
                        <td>
                            <asp:DropDownList ID="ddllocation" runat="server" Style="width: 350px;" class="ddllocation chosen-select chosen-container"></asp:DropDownList>
                        </td>
                        <td style="text-align: right; font-weight: 700">Machine :</td>
                        <td>
                            <asp:DropDownList ID="ddlmachine" runat="server" class="ddlmachine chosen-select chosen-container" Width="150px"></asp:DropDownList>
                        </td>
                        <td>
                            <input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" /><input type="button" value="Reset" onclick="    resetme()" class="resetbutton" /></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="Purchaseheader">Item Detail</div>
                <div style="width: 99%; max-height: 380px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <th class="GridViewHeaderStyle" style="width: 20px;">S.No</th>
                            <td class="GridViewHeaderStyle">View Stock</td>
                            <td class="GridViewHeaderStyle">Item Name</td>
                            <td class="GridViewHeaderStyle">Current Stock Qty.</td>
                            <td class="GridViewHeaderStyle">Event</td>
                            <td class="GridViewHeaderStyle">BarcodeNo.</td>
                            <td class="GridViewHeaderStyle">Calculated Qty.</td>
                            <td class="GridViewHeaderStyle" style="display: none;">
                                <input type="text" name="consumeremarks" onkeyup="showme2(this)" placeholder="All Consume Remarks" maxlength="180" /></td>
                            <td class="GridViewHeaderStyle" style="width: 30px;">
                                <input type="checkbox" onclick="checkall(this)" /></td>
                            <td class="GridViewHeaderStyle" style="text-align:center">Status</td>
                        </tr>
                    </table>
                    <center>
                        <input type="button" class="savebutton" onclick="savealldata()" id="btnSave" style="display:none;" value="Save" />
                    </center>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="OnlineFilterOLD" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1200px; background-color: papayawhip">
            <div class="Purchaseheader">
                 <table style="width:100%;border-collapse:collapse">
                    <tr>
                        <td style=" text-align:left">
                             Detail
                        </td>
                        <td> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:bisque;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 140px;text-align:left"> 
                                &nbsp;Patient Wise</td>
                         <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#F781D8;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 120px;text-align:left"> 
                                &nbsp;Rerun</td>
                         <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#90EE90;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 100px;text-align:left"> 
                                &nbsp;QC</td>
                        <td style=" text-align:right">
                            <em><span style="font-size: 7.5pt;color: #0000ff;">
                Press esc or click<img src="../../App_Images/Delete.gif" onclick="$closeDetail()" style="cursor:pointer"/>to close</span></em>

                        </td>
                    </tr>
                </table>
            </div>
            <div class="content" style="text-align: center; overflow: scroll; height: 400px">
                <table id="Table1" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="tr1">
                        <th class="GridViewHeaderStyle" style="width: 20px;">S.No.</th>
                        <td class="GridViewHeaderStyle">Booking Centre</td>
                        <td class="GridViewHeaderStyle">Visit No.</td>
                        <td class="GridViewHeaderStyle">UHID No.</td>
                        <td class="GridViewHeaderStyle">Patient Name</td>
                        <td class="GridViewHeaderStyle">Age</td>
                        <td class="GridViewHeaderStyle">Gender</td>
                        <td class="GridViewHeaderStyle">Test Name</td>
                        <td class="GridViewHeaderStyle">Consume Type</td>
                        <td class="GridViewHeaderStyle">Event</td>
                        <td class="GridViewHeaderStyle">EventDate</td>
                    </tr>
                </table>
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: center">
                            <asp:Button ID="btnCloseOnlinePOPUP" CssClass="resetbutton" Text="Close" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupOnlineFilter" runat="server" CancelControlID="btnCloseOnlinePOPUP" TargetControlID="btnCloseOnlinePOPUP"
        BackgroundCssClass="filterPupupBackground" PopupControlID="OnlineFilterOLD">
    </cc1:ModalPopupExtender>
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

        function showme2(ctrl) {
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });

        }

        function CalculateValue(ctrl) {
            var id = $(ctrl).closest('tr').find("#tdItemID").html();


            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                //alert($('#ItemDetail' + id).find("#tdInHandQty").html())

                var ConsumedQty = $(ctrl).closest('tr').find("#txtconsumeqty").val();
                $('#tbItemDetail_' + id + ' tr').each(function () {
                    if ($(this).attr('id') != "trheader") {
                        if (ConsumedQty > 0) {

                            var InHandQty = $(this).find("#tdInHandQty").html();
                            if (Number(InHandQty) >= Number(ConsumedQty)) {
                                $(this).find("#tdConsumedQty").html(ConsumedQty);
                                ConsumedQty = Number(ConsumedQty) - Number(ConsumedQty);
                            }
                            else {
                                $(this).find("#tdConsumedQty").html(InHandQty);
                                ConsumedQty = Number(ConsumedQty) - Number(InHandQty);
                            }

                        }
                        else {
                            $(this).find("#tdConsumedQty").html('0');
                        }
                    }
                });
            }
        }
        function showdetail(ctrl) {
            var id = $(ctrl).closest('tr').find("#tdItemID").html();
            var locationid = $(ctrl).closest('tr').find("#tdlocationid").html();
            var ConsumedQty = $(ctrl).closest('tr').find("#txtconsumeqty").val();
            //alert(ConsumedQty);
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
            $.ajax({
                url: "AutoConusmeStoreData_New.aspx/BindItemDetail",
                data: '{ItemID:"' + id + '",locationid:"' + locationid + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        $(ctrl).attr("src", "../../App_Images/minus.png");
                        var tblid = 'tbItemDetail_' + id;
                        var mydata = "<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' id='" + tblid + "' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>";
                        mydata += '<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;">#</td>';
                        mydata += '<td>Stock ID</td>';
                        mydata += '<td>Item Name</td>';
                        mydata += '<td>Stock Date</td>';
                        mydata += '<td>Batch No.</td>';
                        mydata += '<td>Expiry Date</td>';
                        mydata += '<td>Minor Unit</td>';
                        mydata += '<td>InHandQty</td>';
                        mydata += '<td>ConsumeQty</td>';


                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            mydata += "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].stockid + "'>";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';
                            mydata += '<td >' + ItemData[i].stockid + '</td>';
                            mydata += '<td >' + ItemData[i].itemname + '</td>';
                            mydata += '<td  >' + ItemData[i].stockdate + '</td>';
                            mydata += '<td  >' + ItemData[i].batchnumber + '</td>';
                            mydata += '<td  >' + ItemData[i].ExpiryDate + '</td>';
                            mydata += '<td  >' + ItemData[i].minorunit + '</td>';
                            mydata += '<td id="tdInHandQty">' + ItemData[i].InHandQty + '</td>';

                            if (Number(ConsumedQty) > 0) {
                                if (Number(ItemData[i].InHandQty) >= Number(ConsumedQty)) {
                                    mydata += '<td id="tdConsumedQty" style="background-color:yellow" >' + ConsumedQty + '</td>';
                                    ConsumedQty = Number(ConsumedQty) - Number(ConsumedQty);
                                }
                                else {
                                    mydata += '<td id="tdConsumedQty"  style="background-color:yellow" >' + ItemData[i].InHandQty + '</td>';
                                    ConsumedQty = Number(ConsumedQty) - Number(ItemData[i].InHandQty);
                                }
                            }
                            else
                                mydata += '<td id="tdConsumedQty"  ></td>';

                            mydata += "</tr>";
                        }
                        mydata += "</table><div>";
                        var newdata = '<tr id="ItemDetail' + id + '"><td></td><td colspan="16">' + mydata + '</td></tr>';
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
        function searchitem() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }
            var fromdate = $('#<%=txtFromDate.ClientID%>').val();
            var todate = $('#<%=txtToDate.ClientID%>').val();
            $('#tblitemlist tr').slice(1).remove();
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
            $.ajax({
                url: "AutoConusmeStoreData_New.aspx/SearchData",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",fromdate:"' + fromdate + '",todate:"' + todate + '",macid:"' + $('#<%=ddlmachine.ClientID%>').val() + '",SearchType:"' + $('#ddlSearchType').val() + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("No Auto Consume Data Found");
                        $('#tblitemlist tr').slice(1).remove();
                        $.unblockUI();
                        $('#btnSave').hide();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var $myData = [];
                            $myData.push("<tr style='background-color:bisque;' id='");
                            $myData.push(ItemData[i].stockid);$myData.push("'>");
                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push(parseInt(i + 1));$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tditemname">');$myData.push(ItemData[i].itemname);$myData.push('</td>');
                            $myData.push('<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">'); $myData.push(precise_round(ItemData[i].InHandQty, 5));$myData.push('</span>');
                            $myData.push('&nbsp;<span style="font-weight:bold;color:red;" >');$myData.push(ItemData[i].minorunit);$myData.push('</span></td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdEventtypeName">'); $myData.push(ItemData[i].EventtypeName);$myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle" id="tdbarcodeno" style="font-weight:bold;"><input type="button"   id="btnreportpdf" value="BarcodeDetail" onclick="viewbarcodedetail(this);"></td>');
                            $myData.push('<td class="GridViewLabItemStyle" title="Enter Consume Qty">');
                            $myData.push('<input type="text" id="txtconsumeqty" style="width:70px;" onkeyup="showme(this);" autocomplete="off" />');
                            $myData.push('&nbsp;&nbsp;<span style="font-weight:bold;color:white;background-color:blue;padding:2px;" id="totalqty">'); $myData.push( ItemData[i].TotalUsedQty); $myData.push('</span>&nbsp;&nbsp;');
                            $myData.push('&nbsp;<span style="font-weight:bold;color:red;">'); $myData.push(ItemData[i].minorunit); $myData.push('</span></td>');
                            $myData.push('<td class="GridViewLabItemStyle" style="display:none;"><input type="text" placeholder="Consume Remarks" maxlength="180" id="txtconsumeremarks" name="consumeremarks"/></td>');
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="checkbox" id="chk"   /></td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].PatientStatus); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdlocationid">'); $myData.push(ItemData[i].locationid); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdpanelid">'); $myData.push(ItemData[i].panel_id); $myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdItemID">'); $myData.push(ItemData[i].itemid);$myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdconid">'); $myData.push(ItemData[i].conid);$myData.push('</td>');
                            $myData.push('<td style="display:none;" id="tdautoconsumeID">'); $myData.push(ItemData[i].autoconsumeID);$myData.push('</td>');
                            $myData.push("</tr>");

                            $myData = $myData.join("");
                            jQuery("#tblitemlist").append($myData);
                            $('#btnSave').show();
                        }
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI();
                }
            });
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function showme(ctrl) {

            if ($(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "" || $(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "0") {

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
            if (parseFloat($(ctrl).val()) > parseFloat($(ctrl).closest('tr').find('#spbal').html())) {
                showerrormsg("Consume Qty Can't Greater Then Current Stock Qty");
                $(ctrl).val($(ctrl).closest('tr').find('#spbal').html());
                return;
            }
            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
            //showdetail(ctrl);
            CalculateValue(ctrl);
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
        function validation() {
            var che = "true";
            var a = $('#tblitemlist tr').length;
            if (a == 1) {
                showerrormsg("Please Search Item..!");
                return false;
            }
            if (a > 0) {
                $('#tblitemlist tr').each(function () {
                    if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && ($(this).find("#txtconsumeqty").val() == "" || $(this).find("#txtconsumeqty").val() == "0")) {
                        $(this).find("#txtconsumeqty").focus();
                        showerrormsg("You have not Entered Qty");
                        che = "false";
                        return false;

                    }
                });
            }
            if (che == "false") {
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function getcompletedataadj() {
            var tempData = [];
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader") {
                    if ($(this).find("#chk").is(':checked')) {
                        var Itemmaster = [];
                        Itemmaster[0] = $(this).find('#tdlocationid').html();
                        Itemmaster[1] = $(this).find('#tdpanelid').html();
                        //Itemmaster[2] = $(this).attr("id");
                        Itemmaster[3] = $(this).find('#txtconsumeqty').val();
                        Itemmaster[4] = $(this).find('#tdItemID').html();
                        Itemmaster[5] = $(this).find('#txtconsumeremarks').val();
                        //Itemmaster[6] = $(this).find('#tdIsExpirable').html();
                        //Itemmaster[7] = $(this).find('#tdexpirydate').html();
                        Itemmaster[8] = $(this).find('#tdconid').html();
                        Itemmaster[9] = $(this).find('#tdEventtypeName').html();
                        tempData.push(Itemmaster);
                    }
                }
            });
            return tempData;
        }
        function savealldata() {
            if (validation() == true) {
                var mydataadj = getcompletedataadj();
                if (mydataadj.length == 0) {
                    showerrormsg("Please Select Item To Save");
                    return;
                }
                $.ajax({
                    url: "AutoConusmeStoreData_New.aspx/saveconsume",
                    data: JSON.stringify({ mydataadj: mydataadj }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Stock Consume Successfully..!");
                            $('#tblitemlist tr').slice(1).remove();
                            resetme();
                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        showerrormsg(xhr.responseText);
                    }
                });
            }
        }
        function viewbarcodedetail(ctrl) {
            var id = $(ctrl).closest('tr').find('#tdconid').html();
            var EventtypeName = $(ctrl).closest('tr').find('#tdEventtypeName').html();
            var StoreItemID = $(ctrl).closest('tr').find('#tdItemID').html(); 
 var autoconsumeID = $(ctrl).closest('tr').find('#tdautoconsumeID').html(); 

           jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
            $.ajax({
                url: "AutoConusmeStoreData_New.aspx/getdetail",
                data: '{ID:"' + id + '",EventtypeName:"' + EventtypeName + '",StoreItemID:"' + StoreItemID + '",autoconsumeID:"'+autoconsumeID+'"}',
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("No Detail Found");
                        $('#Table1 tr').slice(1).remove();
                        $.unblockUI();
                    }
                    else {
                        $('#Table1 tr').slice(1).remove();
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var $myData = [];                           
                            $myData.push("<tr ");
                            if (ItemData[i].IsRerun == "1")
                                $myData.push(" style='background-color:#F781D8;'> ");
                            else if (ItemData[i].IsRerun == "0")
                                $myData.push(" style='background-color:bisque;'> ");
                            else
                                $myData.push(" style='background-color:#90EE90;'> ");
                            $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].BookingCentre); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].visitid); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].patient_id); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].pname); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].age); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].gender); $myData.push('</td>');
			    if (ItemData[i].InvName != "") {
                                $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].InvName); $myData.push('</td>');
                            }
                            else {
                                $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].ObservationName); $myData.push('</td>');
                            }
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].LabConsumeType); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].EventtypeName); $myData.push('</td>');
                            $myData.push('<td class="GridViewLabItemStyle">'); $myData.push(ItemData[i].EntryDate); $myData.push('</td>');
                            $myData.push("</tr>");
                            $myData = $myData.join("");
                            jQuery("#Table1").append($myData);
                        }
                        $find("<%=ModalPopupOnlineFilter.ClientID%>").show();
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI();
                }
            });
        }
$closeDetail = function () {
            $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
        };
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                
                    $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
                
                
            }

        }
pageLoad = function (sender, args) {
             if (!args.get_isPartialLoad()) {
                 $addHandler(document, "keydown", onKeyDown);
             }
         }
    </script>
</asp:Content>

