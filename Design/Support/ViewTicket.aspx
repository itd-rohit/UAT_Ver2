<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewTicket.aspx.cs"
    Inherits="Design_Support_ViewTicket" Title="View Support Ticket" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            var RoleID = '<%=Session["RoleID"].ToString()%>';
            if (RoleID == "195") {
                $('#btnExTOExcel2,btnExTOExcel1').hide();

            }
        });
    </script>
    <style>
        #AllContenth td, #AllContenth th {
            padding: 5px;
            background-color: silver;
        }

        #AllContenth tr:nth-child(even) {
            background-color: #C0C0C0;
        }

        #AllContenth tr:nth-child(even) {
            background-color: #d8d0f5;
        }

        #AllContent td, #AllContent th {
            padding: 5px;
        }

        #AllContent tr:nth-child(even) {
            background-color: #d8d0f5;
        }

        #AllContent td, #AllContent th {
            padding: 5px;
        }

        #AllContentNew td, #AllContentNew th {
            padding: 5px;
        }

        #AllContentNew tr:nth-child(even) {
            background-color: #d8d0f5;
        }

        #AllContentNew td, #AllContent th {
            padding: 5px;
        }

        

        #AllContenth td, #AllContenth th {
            border: 1px solid #ddd;
            text-align: left;
        }

        #AllContenth {
            border-collapse: collapse;
            width: 100%;
        }

        #AllContent td, #AllContent th {
            border: 1px solid #ddd;
            text-align: left;
            background-color: #C2F4C2;
        }

        #AllContent {
            border-collapse: collapse;
            width: 100%;
        }

        #AllContentNew td, #AllContentNew th {
            border: 1px solid #ddd;
            text-align: left;
            background-color: #F4C2C2;
        }

        #AllContentNew {
            border-collapse: collapse;
            width: 100%;
        }
       
    </style>



    
    <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>View Issues</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFormDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFormDate" />
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                        ControlExtender="mee_txtFromTime"
                        ControlToValidate="txtFromTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-1" style="text-align: center">-</div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate" />
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                    <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                    </cc1:MaskedEditExtender>
                    <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                        ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                        InvalidValueMessage="*">
                    </cc1:MaskedEditValidator>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">Issue No.  </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-2">
                    <asp:TextBox ID="txtIssueNo" runat="server"></asp:TextBox>
                </div>


                <div class="col-md-2">
                    <label class="pull-left">Barcode No.  </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-2">
                    <asp:TextBox ID="txtVialId" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Status </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select id="ddlStatus">
                    </select>
                </div>
            </div>
            <div class="row">

                <div class="col-md-2">
                    <label class="pull-left">Lab No.  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtRegNo" runat="server"></asp:TextBox>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">Client  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtPcc" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2" style="display: none">
                    <label class="pull-left">Dept.  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="display: none">
                    <asp:DropDownList ID="ddldept" runat="server"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="col-md-8"></div>
            <div class="col-md-8">
                <input type="button" class="ItDoseButton" id="searchid" value="Search" onclick="Search();" />
                <asp:Button ID="btnExTOExcel2" Visible="false" CssClass="ItDoseButton" Text="Summary Report" runat="server" OnClick="btnExTOExcel2_Click"></asp:Button>
                <asp:Button ID="btnExTOExcel1" CssClass="ItDoseButton" Text="Detail Report" runat="server" OnClick="btn_clickExportToExcel"></asp:Button>
                <asp:Button ID="btnExcel3" CssClass="ItDoseButton" Text="Detail Report with Remark" runat="server" OnClick="btnExcel3_Click"></asp:Button>

            </div>
            <div class="col-md-2"></div>
        <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: #F4C2C2; border-radius: 9px">
        </div>
        <div class="col-md-1">
            <span>Read</span>
        </div>
        <div class="col-md-1" style="height: 20px; width: 2%; float: left; background-color: #C2F4C2; border-radius: 9px">
        </div>
        <div class="col-md-1">
            <span>New</span>
        </div>
    </div>

    <div class="POuter_Box_Inventory" style="text-align: center">
        <div class="row">
            <table id="AllContenth" class="tblFileDes" width="100%" style="border: 1px solid #808080;">
            </table>
            <table id="AllContent" class="tblFileDes" width="100%" style="border: 1px solid #808080;">
            </table>
            <div id="Green" style="margin: auto;">
            </div>
            <table id="AllContentNew" class="tblFileDes" width="100%" style="border: 1px solid #808080; margin-top: 15px;">
            </table>
            <div id="greenNew" style="margin: auto;">
            </div>
        </div>
    </div>
    </div>
   
    <script src="../../Scripts/Pagination/smartpaginator.js" type="text/javascript"></script>
    <link href="../../App_Style/simplePagination.css/smartpaginator.css" rel="stylesheet" />
    <script type="text/javascript">           
        $(function () {         
            bindstatus();
        });
        function bindstatus() {
            serverCall('Services/Support.asmx/GetStatus', {}, function (response) {
                $("#ddlStatus").bindDropDown({ defaultValue: '', data: JSON.parse(response), valueField: 'STATUS', textField: 'STATUS', isSearchAble: true });
            });
        }
        document.onkeypress = calSearchFun;
        function calSearchFun() {
            var code = window.event.keyCode;
            switch (code) {
                case 13:
                    getList();
                    break;
            }
        }
        function Search() {
            getList();
        }
        function getList() {
            var aas = 1;
            var aasnew = 1;                   
            var FromBarcode = '';
            var ToBarcode = '';
            var Role_ID = '<%=Session["RoleID"].ToString().Trim()%>'; //added by chandan for department wise segregation
            var Status = $('#ddlStatus').val();
            if (Status == "New") {
                $('#green').show();
                $('#greenNew').hide();
            }
            else if (Status == "PCC Reply" || Status == "Support Reply" || Status == "Department Reply" || Status == "Closed" || Status == "Resolved") {
                $('#greenNew').show();
                $('#green').hide();
            }
            serverCall('Services/Support.asmx/GetIssueList', { FromDate: $('#txtFormDate').val(), ToDate: $('#txtToDate').val(), IssueCode: $('#txtIssueNo').val(), VialId: $('#txtVialId').val(), FromBarcode: FromBarcode, ToBarcode: ToBarcode, RegNo: $('#txtRegNo').val(), PccCode: $('#txtPcc').val(), Status: Status, TimeFrm: $("#txtFromTime").val(), TimeTo: $("#txtToTime").val(), Dept: $('#ddldept option:selected').val(), Role_ID:Role_ID }, function (response) {
                $('#AllContenth,#AllContent,#AllContentNew').html('');              
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($responseData.responseDetail != "") {
                        var Result = jQuery.parseJSON($responseData.responseDetail);
                        if (Status == "0") {
                            $('#greenNew,#green').show();                           
                        }
                        var $myDataRow = [];
                        $myDataRow.push("<thead><tr>");
                        $myDataRow.push('<th style="height:30px;width: 70px;">Issue No.</th>');
                        $myDataRow.push('<th style="width: 346px;">Subject</th>');
                        $myDataRow.push('<th style="width: 90px;">Barcode No.</th>');
                        $myDataRow.push('<th style="width: 90px;">Visit No.</th>');
                        $myDataRow.push('<th style="width: 112px;">Client</th>');
                        $myDataRow.push('<th style="width: 112px;">Test</th>');
                        $myDataRow.push('<th style="width: 126px;">Submit Date</th>');
                        $myDataRow.push('<th style="width: 80px;">Status</th>');
                        $myDataRow.push('</tr></thead>');

                        $myDataRow = $myDataRow.join("");
                        $('#AllContenth').append($myDataRow);

                        $.each(Result, function (index, item) {

                            if (item.STATUS == "New") {
                                var sss = aas++;
                                var $myData = [];
                                $myData.push("<tr>");
                                $myData.push('<td style="height:30px;width: 70px;"><a onclick="openTicketView(this);" href="#"'); $myData.push(' style="curser:pointer" >'); $myData.push(item.IssueCode); $myData.push('</a></td>');
                                $myData.push('<td style="text-align:left;width: 340px;">'); $myData.push(item.Subject); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 90px;">'); $myData.push(item.VialId); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 90px;">'); $myData.push(item.RegNo); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 112px;">'); $myData.push(item.Company_Name); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 100px;">'); $myData.push(item.itemid); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 126px;">'); $myData.push(item.dtAdd); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 80px;">'); $myData.push(item.STATUS); $myData.push('</td>');
                                $myData.push('<td id="tdID" style="text-align:left;display:none">'); $myData.push(item.ID); $myData.push('</td>');
                                $myData.push('</tr>');
                                $myData = $myData.join("");
                                $('#AllContent').append($myData);


                                $('#green').smartpaginator({
                                    totalrecords: sss,
                                    recordsperpage: 100,
                                    datacontainer: 'AllContent',
                                    dataelement: 'tr',
                                    theme: 'green'
                                });
                            }
                            else {
                                var sssnew = aasnew++;

                                var $myData = [];
                                $myData.push("<tr>");
                                $myData.push('<td style="height:30px;width: 70px;"><a onclick="openTicketView(this);" href="#"'); $myData.push(' style="curser:pointer" >'); $myData.push(item.IssueCode); $myData.push('</a></td>');
                                $myData.push('<td style="text-align:left;width: 342px;">'); $myData.push(item.Subject); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 90px;">'); $myData.push(item.VialId); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 90px;">'); $myData.push(item.RegNo); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 112px;">'); $myData.push(item.Company_Name); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 100px;">'); $myData.push(item.itemid); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 126px;">'); $myData.push(item.dtAdd); $myData.push('</td>');
                                $myData.push('<td style="text-align:left;width: 80px;">'); $myData.push(item.STATUS); $myData.push('</td>');
                                $myData.push('<td id="tdID" style="text-align:left;display:none">'); $myData.push(item.ID); $myData.push('</td>');
                                $myData.push('</tr>');
                                $myData = $myData.join("");
                                $('#AllContentNew').append($myData);

                                $('#greenNew').smartpaginator({
                                    totalrecords: sssnew,
                                    recordsperpage: 100,
                                    datacontainer: 'AllContentNew',
                                    dataelement: 'tr',
                                    theme: 'green'
                                });
                            }
                        });
                    }
                    else {
                        $('#greenNew').hide();
                        $('#green').hide();
                        toast('Info', 'No Record Found');
                        return;
                    }
                }
            });
        }
        function openTicketView(rowID) {
            serverCall('ViewTicket.aspx/encryptData', { ID: $(rowID).closest('tr').find("#tdID").text() }, function (response) {
                window.open('AnswerTicket.aspx?TicketId=' + response, '_blank');
            });
        }


        
    </script>
</asp:Content>

