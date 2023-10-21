<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SendIssueItem.aspx.cs" Inherits="Design_Store_SendIssueItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>SI Batch Creation And Dispatch</b>

        </div>


        <div class="POuter_Box_Inventory">

           
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Current Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:DropDownList ID="ddllocation" class="ddllocation chosen-select chosen-container" runat="server" onchange="bindindentfromlocation()"></asp:DropDownList>
                    &nbsp;&nbsp; 

                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:DropDownList ID="ddllocationfrom" class="ddllocationfrom chosen-select chosen-container" runat="server"></asp:DropDownList>

                </div>

            </div>


            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Issue Date From</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Issue Date To </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlstatus" runat="server">
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="BatchCreated" Value="BatchCreated" />
                        <asp:ListItem Text="Dispatched" Value="Dispatched" />
                        <asp:ListItem Text="Delivered" Value="Delivered" />
                        <asp:ListItem Text="Received" Value="Received" />
                        <asp:ListItem Text="All" Value="All" />
                    </asp:DropDownList>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">Issue Invoice No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtissueinvoiceno" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-10" style="text-align: right">
                    <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />

                </div>

                <div class="col-md-14">
                    <table width="100%">
                        <tr>
                            <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Pending</td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>BatchCreated</td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Dispatched</td>
                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Delivered</td>

                            <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Received</td>

                        </tr>
                    </table>
                </div>
            </div>

        </div>



        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Issue Detail
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div style="width: 100%; height: 200px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">

                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">View Item</td>
                                <td class="GridViewHeaderStyle">Indent No.</td>
                                <td class="GridViewHeaderStyle">Indent Date</td>
                                <td class="GridViewHeaderStyle">Issue Invoice No.</td>
                                <td class="GridViewHeaderStyle">Issue Date</td>
                                <td class="GridViewHeaderStyle">Dispatch From Location</td>
                                <td class="GridViewHeaderStyle">Dispatch To Location</td>
                                <td class="GridViewHeaderStyle">Status</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">Print
                                    <br />
                                    Invoice</td>
                                <td class="GridViewHeaderStyle" style="width: 65px;">Print
                                    <br />
                                    Address</td>

                                <td class="GridViewHeaderStyle">
                                    <input type="checkbox" onclick="checkall(this)" title="Check Here For Select All" /></td>





                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <input type="button" value="Create Batch" class="savebutton" onclick="dispatchall()" id="btndis" style="display: none;" />
                </div>
            </div>
        </div>






        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Pending Batch
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtbatchdatefrom" runat="server" Width="160px" ReadOnly="true" />
                    <cc1:CalendarExtender ID="txtentrydatefrom0_CalendarExtender" runat="server" TargetControlID="txtbatchdatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtbatchdateto" runat="server" Width="160px" ReadOnly="true" />
                    <cc1:CalendarExtender ID="txtentrydateto0_CalendarExtender" runat="server" TargetControlID="txtbatchdateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Batch No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtbatchnumber" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-3">
                    <input type="button" class="searchbutton" value="Search" onclick="searchbatch()" />
                </div>
            </div>


            <div class="row">
                <div class="col-md-24">

                    <div style="width: 100%; max-height: 150px; overflow: auto;">

                        <table id="tblbatch" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="trbatch">
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">View Detail</td>
                                <td class="GridViewHeaderStyle">Dispatch</td>
                                <td class="GridViewHeaderStyle">Batch No.</td>
                                <td class="GridViewHeaderStyle">Batch Created Date</td>
                                <td class="GridViewHeaderStyle">Batch Created by</td>
                                <td class="GridViewHeaderStyle">From Location</td>
                                <td class="GridViewHeaderStyle">To Location</td>
                                <td class="GridViewHeaderStyle" style="width: 65px;">Print
                                    <br />
                                    Address</td>
                                <td class="GridViewHeaderStyle" style="width: 100px;">Print Dispatch<br />
                                    Invoice</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="1100px">


        <div class="Purchaseheader">
            Batch Detail
        </div>

        <table width="90%">



            <tr style="font-weight: bold;">
                <td>No of Box:
                </td>
                <td>
                    <asp:TextBox ID="txtnoofbox" runat="server" Width="100px"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtnoofbox">
                    </cc1:FilteredTextBoxExtender>
                </td>
                <td style="font-weight: bold;">Total Weight:
                </td>
                <td>
                    <asp:TextBox ID="txttotalweight" runat="server" Width="100px" />

                </td>
            </tr>


            <tr style="font-weight: bold;">
                <td>Consignment Note :
                </td>
                <td>
                    <asp:TextBox ID="txtconsignmentnote" runat="server" Width="400px" />
                </td>
                <td>Temperature :
                </td>
                <td>
                    <asp:TextBox ID="txtTemperature" runat="server" Width="100px"></asp:TextBox>
                </td>

            </tr>


        </table>

        <center>
            <input type="button" value="Create Batch" class="savebutton" onclick="dispatchnow()" />
            &nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
        </center>

    </asp:Panel>

    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>



    <asp:Panel ID="pnl2" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="1100px">


        <div class="Purchaseheader">
            Batch Detail
        </div>

        <table width="90%">

            <tr>
                <td width="180px" style="font-weight: bold;">Batch Number:</td>

                <td>
                    <asp:Label ID="lbbatchnumber" runat="server" Font-Bold="true">
                    </asp:Label>
                </td>
            </tr>
            <tr>
                <td width="180px" style="font-weight: bold;">From:</td>

                <td>
                    <asp:Label ID="lbfrom" runat="server" Font-Bold="true">
                    </asp:Label>
                </td>
                <td style="font-weight: bold;">To:</td>

                <td>
                    <asp:Label ID="lbto" runat="server" Font-Bold="true">
                    </asp:Label>
                </td>
            </tr>


            <tr style="font-weight: bold;">
                <td>No of Box:
                </td>
                <td>
                    <asp:TextBox ID="txtnoofbox1" runat="server" Width="100px"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtnoofbox1">
                    </cc1:FilteredTextBoxExtender>
                </td>
                <td style="font-weight: bold;">Total Weight:
                </td>
                <td>
                    <asp:TextBox ID="txttotalweight1" runat="server" Width="100px" />

                </td>
            </tr>


            <tr style="font-weight: bold;">
                <td>Consignment Note :
                </td>
                <td>
                    <asp:TextBox ID="txtconsignmentnote1" runat="server" Width="400px" />
                </td>
                <td>Temperature :
                </td>
                <td>
                    <asp:TextBox ID="txtTemperature1" runat="server" Width="100px"></asp:TextBox>
                </td>

            </tr>


            <tr>
                <td width="180px" style="font-weight: bold;">Dispatch Type:
                </td>

                <td style="font-weight: bold;">
                    <asp:RadioButtonList ID="rdoDispatchType" runat="server" Width="200px" onchange="setDispatchType();" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Courier" Value="Courier" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="FieldBoy" Value="FieldBoy"></asp:ListItem>
                    </asp:RadioButtonList>
                </td>
                <td style="font-weight: bold;">Dispatch Date :
                </td>
                <td>
                    <asp:TextBox ID="txtdispatchdate" runat="server" Width="100px" ReadOnly="true" />
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtdispatchdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </td>

            </tr>

            <tr class="Courier" style="font-weight: bold;">
                <td>Courier name :
                </td>
                <td>
                    <asp:TextBox ID="txtCourierName" runat="server" Width="400px" />
                </td>
                <td style="font-weight: bold;">AWB Number :
                </td>
                <td>
                    <asp:TextBox ID="txtawbnumber" runat="server" Width="100px" />
                </td>
            </tr>

            <tr class="FieldBoy">

                <td style="font-weight: bold;">FeildBoy :</td>
                <td colspan="3">
                    <asp:DropDownList ID="ddlfeildboy" runat="server" Width="200px" Style="float: left;" />

                    <asp:TextBox ID="txtotherboy" placeholder="Enter Other" runat="server" Width="150px" Style="margin-left: 10px; display: none; float: left;"></asp:TextBox>
                </td>

            </tr>
        </table>


        <center>
            <input type="button" value="Dispatch Now" class="savebutton" onclick="dispatchnowwithbatch()" />
            &nbsp;&nbsp;<asp:Button ID="btncloseme2" runat="server" CssClass="resetbutton" Text="Close" />
        </center>



    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelpopup2" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl2" CancelControlID="btncloseme2">
    </cc1:ModalPopupExtender>


    <asp:Button ID="Button1" runat="server" Style="display: none" />

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
        $('#<%=ddlfeildboy.ClientID%>').change(function () {
            var value = $('#<%=ddlfeildboy.ClientID %> option:selected').text();
            $('#<%=txtotherboy.ClientID%>').css('display', (value == 'Other') ? 'block' : 'none');
        });



        function bindfieldboy() {
            var dropdown = $("#<%=ddlfeildboy.ClientID%>");
            $("#<%=ddlfeildboy.ClientID%> option").remove();
            var centreid = '<%= UserInfo.Centre%>';
            serverCall('../Lab/Services/LabBooking.asmx/getfieldboy', { centreid: centreid }, function (response) {              
                if ($.parseJSON(response).length == 0) {
                    $("#<%=ddlfeildboy.ClientID%>").append($("<option></option>").val("0").html("Field Boy Not Found"));
                    $("#<%=ddlfeildboy.ClientID%>").trigger('chosen:updated');
                }
                else {                  
                    $("#<%=ddlfeildboy.ClientID%>").bindDropDown({ data: JSON.parse(response), valueField: 'id', textField: 'Name', defaultValue: 'Select Field Boy',isSearchAble:'' });                 
                }
            });             
        }
        function openmypopup(href) {
            var width = '1280px';
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
        $(function () {
            setDispatchType();
            bindfieldboy();
        });

        function bindindentfromlocation() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $("#<%=ddllocationfrom.ClientID%> option").remove();
                $("#<%=ddllocationfrom.ClientID%>").append($("<option></option>").val("0").html("Select From Location"));
                return;
            }
            var dropdown = $("#<%=ddllocationfrom.ClientID%>");
            $("#<%=ddllocationfrom.ClientID%> option").remove();


            serverCall('SendIssueItem.aspx/bindindentfromlocation', { tolocation: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                if ($.parseJSON(response).length == 0) {
                    dropdown.append($("<option></option>").val("0").html("Select To Location"));
                    dropdown.trigger('chosen:updated');
                }
                else {
                    dropdown.bindDropDown({ data: JSON.parse(response), valueField: 'locationid', textField: 'location', defaultValue: 'Select To Location', isSearchAble: '' });
                }
            });            
        }
    </script>
    <script type="text/javascript">
        function searchdata() {

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $('#<%=ddllocation.ClientID%>').focus();
                toast("Error","Please Select Current Location");
                return;
            }

            if ($('#<%=ddllocationfrom.ClientID%>').val() == "0") {
                $('#<%=ddllocationfrom.ClientID%>').focus();
                toast("Error","Please Select To Location");
                return;
            }
            var location = $('#<%=ddllocation.ClientID%>').val();
            var locationto = $('#<%=ddllocationfrom.ClientID%>').val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var IssueInoiceNo = $('#<%=txtissueinvoiceno.ClientID%>').val();
            var status = $('#<%=ddlstatus.ClientID%>').val();


           
            $('#tblitemlist tr').slice(1).remove();

            serverCall('SendIssueItem.aspx/SearchData', { location: location, locationto: locationto, fromdate: fromdate, todate: todate, IssueInoiceNo: IssueInoiceNo, status: status }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No Indent Found");
                    $('#btndis').hide();
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:");$Tr.push(ItemData[i].Rowcolor);$Tr.push(";' id='" );$Tr.push(ItemData[i].IssueInvoiceno);$Tr.push("'>");
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdindentno" >');$Tr.push(ItemData[i].IndentNo);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IndentDate);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IssueInvoiceno);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IssueDate);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].DispatchFrom);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].DispatchTo);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].Status);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Issue Invoice" onclick="printmeinvoice(this)" /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        $Tr.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeaddess(this)" />');
                        $Tr.push('</td>');
                       
                        $Tr.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].Status == "Pending") {
                            $Tr.push('<input type="checkbox" id="chk"  />');
                        }
                        $Tr.push('</td>');
                        $Tr.push("</tr>");

                        $Tr = $Tr.join("");
                        $('#tblitemlist').append($Tr);

                    }
                    
                    $('#btndis').show();

                }
            });

            
        }

        function printmeinvoice(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').attr("id");
            window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + tdIssueInvoiceNo);
        }

       
        function printmeaddess(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdindentno").html();
            window.open('IndentIssueReceipt.aspx?Type=2&IndentNo=' + tdIssueInvoiceNo);
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


        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            var locationid = $(ctrl).closest('tr').find("#tdlocid").html();
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            serverCall('SendIssueItem.aspx/BindItemDetail', { IssueInvoiceNo: id  }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No Item Found");                     
                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    var $Tr = [];
                    $Tr.push("<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                    $Tr.push('<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">');
                    $Tr.push('<td  style="width:20px;">#</td>');
                    $Tr.push('<td>Item Name</td>');
                    $Tr.push('<td>Send Qty</td>');                     
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $Tr.push("<tr style='background-color:aqua;' id='" + ItemData[i].id + "'>");
                        $Tr.push('<td >'); $Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td >');$Tr.push(ItemData[i].typename);$Tr.push('</td>');                         
                        $Tr.push('<td  >'); $Tr.push(precise_round(ItemData[i].sendqty, 5) + '</td>');                           
                        $Tr.push("</tr>");
                    }
                    $Tr.push("</table><div>");
                    $Tr.join("");
                    var $Tr1 = [];
                    $Tr1.push('<tr id="ItemDetail');$Tr1.push(id); $Tr1.push('"><td></td><td colspan="16">'); $Tr1.push($Tr1);$Tr1.push('</td></tr>');
                    $Tr1.join("");
                    $($Tr1).insertAfter($(ctrl).closest('tr'));


                      
                }
            });

            
        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function dispatchall() {
            var a = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {
                    if ($(this).find('#chk').is(":checked")) {

                        a++;
                    }
                }
            });


            if (a == 0) {
                toast("Error","Please Select Invoice To Dispatch");
                return;
            }

            $find("<%=modelpopup1.ClientID%>").show();
        }


        function setDispatchType() {
            if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "Courier") {
                $('.FieldBoy').hide();
                $('.Courier').show();
                $('#<%=ddlfeildboy.ClientID%>').prop('selectedIndex', 0);
                $('#<%=txtotherboy.ClientID%>').val('');

                var date = new Date();
                var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];

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
                var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];
                var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
                $('#<%=txtdispatchdate.ClientID%>').val(val);
            }
    }
    </script>

    <script type="text/javascript">
        function getdispatchdata() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {
                    if ($(this).find('#chk').is(":checked")) {
                        dataIm.push($(this).attr('id') + '#' + $(this).closest('tr').find('#tdindentno').html());
                    }
                }
            });
            return dataIm;
        }
                

        function dispatchnow() {

         
            if ($('#<%=txtnoofbox.ClientID%>').val() == "" || $('#<%=txtnoofbox.ClientID%>').val() == "0") {
                toast("Error","Please Enter No of Box");
                $('#<%=txtnoofbox.ClientID%>').focus();
                return;
            }

            

            var getdatatosave = getdispatchdata();

            if (getdatatosave.length == 0) {
                toast("Error","Please Select Data To Dispatch");

                return;
            }


          
            var NoofBox = $('#<%=txtnoofbox.ClientID%>').val();
            var TotalWeight = $('#<%=txttotalweight.ClientID%>').val();
            var ConsignmentNote = $('#<%=txtconsignmentnote.ClientID%>').val();
            var Temperature = $('#<%=txtTemperature.ClientID%>').val();

            serverCall('SendIssueItem.aspx/SendDispatchData', {datatosave: getdatatosave, NoofBox: NoofBox, TotalWeight: TotalWeight, ConsignmentNote: ConsignmentNote, Temperature: Temperature }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success","Batch Created Successfully..!");

                    $find("<%=modelpopup1.ClientID%>").hide();
                    clearForm();
                    var IndentNo = response.split('#')[2];
                    window.open('IndentIssueReceipt.aspx?Type=2&IndentNo=' + IndentNo);
                    searchdata();
                    searchbatch();
                }
                else {
                    toast("Error",response.split('#')[1]);
                    
                }
            });                     
        }
        function clearForm() {
            $('#<%=txtCourierName.ClientID%>').val('');
            $('#<%=txtnoofbox.ClientID%>').val('');
            $('#<%=txtawbnumber.ClientID%>').val('');
            $('#<%=txttotalweight.ClientID%>').val('');
            $('#<%=txtconsignmentnote.ClientID%>').val('');
            $('#<%=txtTemperature.ClientID%>').val('');        
            $('#<%=txtnoofbox1.ClientID%>').val('');           
            $('#<%=txttotalweight1.ClientID%>').val('');
            $('#<%=txtconsignmentnote1.ClientID%>').val('');
            $('#<%=txtTemperature1.ClientID%>').val('');
            $('#<%=lbbatchnumber.ClientID%>').html('');
            $('#<%=lbfrom.ClientID%>').html('');
            $('#<%=lbto.ClientID%>').html('');
            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul","Aug", "Sep", "Oct", "Nov", "Dec"];
            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $('#<%=txtdispatchdate.ClientID%>').val(val);
            $('<%=rdoDispatchType.ClientID%>[value="Courier"]').prop('checked', true);
            setDispatchType(); 
        }
    </script>

    <script type="text/javascript">

        function searchbatch() {                     
            var fromdate = $('#<%=txtbatchdatefrom.ClientID%>').val();
            var todate = $('#<%=txtbatchdateto.ClientID%>').val();
            var BatchNumber = $('#<%=txtbatchnumber.ClientID%>').val();
                
            var location = $('#<%=ddllocation.ClientID%>').val();

            if (location == "0") {
                toast("Error","Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }               
            $('#tblbatch tr').slice(1).remove();
            serverCall('SendIssueItem.aspx/SearchBatch', { fromdate: fromdate,todate:todate,BatchNumber:BatchNumber,location:location }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No Batch Found");                                                     
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:");$Tr.push(ItemData[i].Rowcolor);$Tr.push(";' id='");$Tr.push(ItemData[i].BatchNumber);$Tr.push("'>");
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetailinner(this)" /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><a style="font-weight:bold;color:blue;cursor:pointer;"  onclick="dispatchbatchnow(this);">Dispatch Now</a></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdBatchNumber" >');$Tr.push(ItemData[i].BatchNumber);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].BatchCreatedDateTime);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].BatchCreatedByName);$Tr.push('</td>');                            
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdFrom">');$Tr.push(ItemData[i].DispatchFrom);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdTo">');$Tr.push(ItemData[i].DispatchTo);$Tr.push('</td>');                                                                                               
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        $Tr.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeaddess1(this)" />');
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');                             
                        $Tr.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Dispatch Invoice" onclick="printmedispatch(this)" />');                               
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdIssueInvoiceNo" style="display:none;">');$Tr.push(ItemData[i].IssueInvoiceNo);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdnoofbox" style="display:none;">');$Tr.push(ItemData[i].NoofBox);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdtotalweight" style="display:none;">');$Tr.push(ItemData[i].TotalWeight);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdconnote" style="display:none;">');$Tr.push(ItemData[i].ConsignmentNote);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdtemp" style="display:none;">');$Tr.push(ItemData[i].Temperature);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdtemp1" style="display:none;">' );$Tr.push(ItemData[i].IndentNo);$Tr.push('</td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#tblbatch').append($Tr);
                    }                                                        
                }
            });               
        }
        function printmeaddess1(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdtemp1").html();
            window.open('IndentIssueReceipt.aspx?Type=2&IndentNo=' + tdIssueInvoiceNo);
        }
        function printmedispatch(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();
            if (tdIssueInvoiceNo != "") {
                for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {
                    var BatchNumber = tdIssueInvoiceNo.split(',')[a];
                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                }
            }
        }
        function dispatchbatchnow(ctrl) {
            var BatchNumber = $(ctrl).closest('tr').find('#tdBatchNumber').html();
            var From = $(ctrl).closest('tr').find('#tdFrom').html();
            var To = $(ctrl).closest('tr').find('#tdTo').html();
            $('#<%=lbbatchnumber.ClientID%>').html(BatchNumber).html();
            $('#<%=lbfrom.ClientID%>').html(From);
            $('#<%=lbto.ClientID%>').html(To);
            $('#<%=txtnoofbox1.ClientID%>').val($(ctrl).closest('tr').find('#tdnoofbox').html());
            $('#<%=txttotalweight1.ClientID%>').val($(ctrl).closest('tr').find('#tdtotalweight').html());
            $('#<%=txtconsignmentnote1.ClientID%>').val($(ctrl).closest('tr').find('#tdconnote').html());
            $('#<%=txtTemperature1.ClientID%>').val($(ctrl).closest('tr').find('#tdtemp').html());              
            $find("<%=modelpopup2.ClientID%>").show();
        }
        function showdetailinner(ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            var locationid = $(ctrl).closest('tr').find("#tdlocid").html();
            if ($('table#tblbatch').find('#ItemDetail' + id).length > 0) {
                $('table#tblbatch tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            serverCall('SendIssueItem.aspx/BindItemDetailInner', { BatchNo: id }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No Item Found");                     
                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    var $Tr = [];
                    $Tr.push("<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                    $Tr.push('<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">');
                    $Tr.push('<td  style="width:20px;">#</td>');
                    $Tr.push('<td>Issue Invoice No.</td>');
                    $Tr.push('<td>Indent No.</td>');
                    $Tr.push('<td>Item Name</td>');
                    $Tr.push('<td>Send Qty.</td>');
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $Tr.push("<tr style='background-color:aqua;' id='");$Tr.push( ItemData[i].id);$Tr.push("'>");
                        $Tr.push('<td >');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td >');$Tr.push( ItemData[i].issueinvoiceno);$Tr.push('</td>');
                        $Tr.push('<td >');$Tr.push( ItemData[i].indentno);$Tr.push('</td>');
                        $Tr.push('<td >');$Tr.push( ItemData[i].typename);$Tr.push('</td>');
                        $Tr.push('<td  >' );$Tr.push( precise_round(ItemData[i].sendqty, 5) + '</td>');
                        $Tr.push("</tr>");
                    }
                    $Tr.push("</table><div>");
                    $Tr = $Tr.join("");
                    var $Tr1 = [];
                    $Tr1.push('<tr id="ItemDetail');$Tr1.push(id); $Tr1.push('"><td></td><td colspan="10">');$Tr1.push($Tr);$Tr1.push('</td></tr>');
                    $($Tr1).insertAfter($(ctrl).closest('tr'));                      
                }
            });           
        }
        function dispatchnowwithbatch() {
            var BatchNumber = $('#<%=lbbatchnumber.ClientID%>').html();
            var DispatchOption = $("#<%=rdoDispatchType.ClientID%>").find(":checked").val();
            var DispatchDate = $('#<%=txtdispatchdate.ClientID%>').val();
            var CourierName = $('#<%=txtCourierName.ClientID%>').val();
            var AWBNumber = $('#<%=txtawbnumber.ClientID%>').val();
            var NoofBox = $('#<%=txtnoofbox1.ClientID%>').val();
            var TotalWeight = $('#<%=txttotalweight1.ClientID%>').val();
            var ConsignmentNote = $('#<%=txtconsignmentnote1.ClientID%>').val();
            var Temperature = $('#<%=txtTemperature1.ClientID%>').val();
            var FieldBoyID = $('#<%=ddlfeildboy.ClientID%>').val();
            var FieldBoyName = $('#<%=ddlfeildboy.ClientID%> option:selected').text();
            var OtherName = $('#<%=txtotherboy.ClientID%>').val();
            if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "Courier" && $('#<%=txtCourierName.ClientID%>').val() == "") {
                toast("Error","Please Enter Courier Name");
                $('#<%=txtCourierName.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtnoofbox1.ClientID%>').val() == "" || $('#<%=txtnoofbox1.ClientID%>').val() == "0") {
                toast("Error","Please Enter No of Box");
                $('#<%=txtnoofbox.ClientID%>').focus();
                return;
            }

            if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "FieldBoy" && $('#<%=ddlfeildboy.ClientID%>').val() == "0") {
                toast("Error","Please Select FeildBoy");
                $('#<%=ddlfeildboy.ClientID%>').focus();
                return;
            }
            if ($("#<%=rdoDispatchType.ClientID%>").find(":checked").val() == "FieldBoy" && $('#<%=ddlfeildboy.ClientID%> option:selected').text() == "Other" && $('#<%=txtotherboy.ClientID%>').val() == "") {
                toast("Error","Please Enter Other Name");
                $('#<%=txtotherboy.ClientID%>').focus();
                return;
            }

            serverCall('SendIssueItem.aspx/FinalDispatchData', { BatchNumber: BatchNumber,DispatchOption:DispatchOption,DispatchDate:DispatchDate,CourierName:CourierName,AWBNumber:AWBNumber,FieldBoyID:FieldBoyID,FieldBoyName:FieldBoyName,OtherName:OtherName, NoofBox: NoofBox, TotalWeight: TotalWeight, ConsignmentNote: ConsignmentNote, Temperature: Temperature  }, function (response) {

                if (response.split('#')[0] == "1") {
                    toast("Success","Batch Dispatch Successfully..!");
                    $find("<%=modelpopup2.ClientID%>").hide();
                    clearForm();                    
                    searchdata();
                    searchbatch();
                }
                else {
                    toast("Error",response.split('#')[1]);
                }
            });
      
           
        }
    </script>
</asp:Content>

