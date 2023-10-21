<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OutSourceTestToOtherLab.aspx.cs" Inherits="Design_Lab_OutSourceTestToOtherLab" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                    <b>Outsource Test To Other Lab</b>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option                            
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFormDate" runat="server" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                    <asp:TextBox ID="txtFromTime" runat="server" Style="display: none;"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                        ControlExtender="mee_txtFromTime"
                        ControlToValidate="txtFromTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                    <asp:TextBox ID="txtToTime" runat="server" Width="70px" Style="display: none;"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*"> </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" runat="server">
                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Department </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" class="ddlDepartment  chosen-select chosen-container" runat="server">
                    </asp:DropDownList>
                </div>
                
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">OutSourceLab </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddloutsourcelab" class="ddloutsourcelab  chosen-select chosen-container" runat="server">
                    </asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">SIN No.</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtBarcodeNo" maxlength="10" />
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-2">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchData();" />&nbsp;
                </div>
                <div class="col-md-2">
                    <input id="btnsave" type="button" value="Save" style="display: none;" class="savebutton" onclick="Savedata();" />
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">

            <div class="Purchaseheader">
                OutSource Test List 
                       <span style="color: red;">&nbsp;&nbsp;&nbsp;Total Test:&nbsp;</span><span id="totalcount" style="color: red">0</span>
            </div>
            <div style="width: 100%; overflow: auto; height: 410px;">

                <table style="width: 99%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                    <tr id="saheader" style="height: 20px;">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left;">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">RegDate</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">From Centre</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Visit No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Sin No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Patient Name</th>
                        <%--<th class="GridViewHeaderStyle" scope="col" style="text-align:left;font-size:13px;">Age/Gender</th>--%>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Department</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Test Name</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">OutSource Lab</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; display: none;">Rate</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">TAT</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">File Required</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Status</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">Add Report</th>
                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left;">select</th>
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
            BindCentre();
        });

        function BindCentre() {
            var $ddlCentre = $("#<%=ddlCentreAccess.ClientID %>");
            $("#<%=ddlCentreAccess.ClientID %> option").remove();
            serverCall('MachineResultEntry.aspx/bindAccessCentre', {}, function (response) {
                $ddlCentre.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
            });

        }


        function SearchData() {
            $('#tb_ItemList tr').slice(1).remove();
            $("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            try {
                serverCall('OutSourceTestToOtherLab.aspx/binddata', { FromDate: $("#<%=txtFormDate.ClientID %>").val(), ToDate: $("#<%=txtToDate.ClientID %>").val(), CentreID: $("#<%=ddlCentreAccess.ClientID%>").val(), Department: $("#<%=ddlDepartment.ClientID%>").val(), TimeFrm: $("#<%=txtFromTime.ClientID%>").val(), TimeTo: $("#<%=txtToTime.ClientID%>").val(), OutsourceLabid: $("#<%=ddloutsourcelab.ClientID%>").val(), BarcodeNo: $("#txtBarcodeNo").val().trim() }, function (response) {
               
var TestData = jQuery.parseJSON(response);
                if (TestData == "-1") {
                    $('#totalcount').html('0');
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    toast("Error", "Your Session Expired.... Please Login Again", "");
                    var url = "../Default.aspx";
                    $(location).attr('href', url);
                    return;
                }
                if (TestData.length == 0) {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    $('#totalcount').html('0');
                    toast("Error", "No OutSource List Found", "");
                    $('#btnsave').hide();
                    return;
                }
                else {
                    var a = 0;
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    $('#btnsave').show();
                    for (var i = 0; i <= TestData.length - 1; i++) {

                        a++;
                        var mydata = [];
                        if (TestData[i].Status == "Pending") {
                            mydata.push("<tr id='"); mydata.push(TestData[i].Test_ID); mydata.push("'"); mydata.push("style='background-color:white;height:25px;'>");
                        }
                        else {
                            mydata.push("<tr id='"); mydata.push(TestData[i].Test_ID); mydata.push("'"); mydata.push("style='background-color:lightgreen;height:25px;'>");
                        }
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].RegDate); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].centre); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].LedgerTransactionNo); mydata.push('</td>');
                        if (TestData[i].Status == "Pending") {
                            mydata.push('<td id="tdbarcodeno" class="GridViewLabItemStyle" align="left" style="font-size:12px;"><input type="text" id="barcodeno" value='); mydata.push(TestData[i].BarcodeNo); mydata.push('></td>');//
                        }
                        else {
                            mydata.push('<td id="tdbarcodeno" class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].BarcodeNo); mydata.push('</td>');
                        }
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].PName); mydata.push('</td>');
                        //mydata += '<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">' + TestData[i].Age + '</td>';
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].dept); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].itemname); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">');
                        mydata.push('<select id="ddloutsrclabname" class="outsrclabclass" style="background-color:pink;width:132px;"></select>');
                        mydata.push('</td>');

                        mydata.push('<td id="rate" class="GridViewLabItemStyle" align="left" style="font-size:12px;display:none;">'); mydata.push(TestData[i].LabOutSrcRate); mydata.push('</td>');
                        mydata.push('<td id="tat" class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].TAT); mydata.push('</td>');
                        mydata.push('<td id="IsFileRequired" class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].IsFileRequired); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">'); mydata.push(TestData[i].Status); mydata.push('</b></td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="centre" style="font-size:12px;">');
                        if (TestData[i].Status == "OutSourced") {
                            mydata.push('<img  src="../../App_Images/print.gif" style="border-style: none;cursor:pointer;" alt="" onclick="openme(\''); mydata.push(TestData[i].LedgerTransactionNo); mydata.push('\',\''); mydata.push(TestData[i].Test_ID); mydata.push('\')">');
                        }
                        mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">');
                        if (TestData[i].Status == "Pending") {
                            mydata.push('<input type="checkbox" id="chme"/>');
                        }

                        mydata.push('</td>');
                        mydata.push('<td style="display:none;" id="outsrclabid">'); mydata.push(TestData[i].LabOutsrcID); mydata.push('</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join("");
                        $('#tb_ItemList').append(mydata);
                    }
                    $('#totalcount').html(a);
                    tablefuncation();
                }
            });
        } catch (e) {

        }
    }
    function tablefuncation() {
        var $ddlOutSource = $(".outsrclabclass");
        $(".outsrclabclass option").remove();
        serverCall('OutSourceTestToOtherLab.aspx/bindoutsrclab', {}, function (response) {
            var OutSourceData = jQuery.parseJSON(response);
            if (OutSourceData.length == 0) {
            }
            else {
                for (i = 0; i < OutSourceData.length; i++) {
                    $ddlOutSource.append($("<option></option>").val(OutSourceData[i]["ID"]).html(OutSourceData[i]["NAME"]));
                }
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    var outsrclabid = $(this).closest("tr").find("#outsrclabid").html();
                    if (id != "saheader") {
                        $(this).closest("tr").find("#ddloutsrclabname").val(outsrclabid);
                    }
                });
            }
        });
        
    }
    function openme(LedgerTransactionNo, _test_id) {
        serverCall('OutSourceTestToOtherLab.aspx/encryptData', { LedgerTransactionNo: LedgerTransactionNo, Test_ID: _test_id }, function (response) {
            var $responseData = jQuery.parseJSON(response);

            window.open('AddReport.aspx?OutSrc=' + $responseData.OutSrc + '&LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&Test_ID=' + $responseData.Test_ID, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

        });
    }
    function Savedata() {
        var data = getdata();
        if (data == "") {
            toast("Error", "Please Select Data to Save", "");
            return;
        }

        serverCall('OutSourceTestToOtherLab.aspx/savedata', { data: data }, function (response) {
            if (response == "1") {
                toast("Success", "OutSource Data Saved", "");
                SearchData();
            }
            else {
                toast("Error", response, "");
                SearchData();
            }
        });

    }
    function getdata() {
        var dataPLO = new Array();
        $('#tb_ItemList tr').each(function () {
            var id = $(this).closest("tr").attr("id");
            if (id != "saheader") {
                if ($(this).closest("tr").find('#chme').is(':checked')) {
                    var val = $(this).closest("tr").attr("id") + "#" + $(this).closest("tr").find("#ddloutsrclabname").val() + "#" + $(this).closest("tr").find("#ddloutsrclabname option:selected").text() + "#" + $(this).closest("tr").find("#rate").html() + "#" + $(this).closest("tr").find("#barcodeno").val();
                    dataPLO.push(val);
                }
            }
        });
        return dataPLO;
    }
    </script>
</asp:Content>

