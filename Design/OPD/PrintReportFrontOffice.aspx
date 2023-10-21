<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="PrintReportFrontOffice.aspx.cs" Inherits="Design_FrontOffice_PrintReportFrontOffice" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <style>
        .DataFound {
            display: none;
        }

        #tblData td {
            padding-top: 5px;
            padding-bottom: 5px;
        }
    </style>

    <div id="Pbody_box_inventory" style="Width: 1000px">

        <div class="POuter_Box_Inventory" style="Width: 995px">
            <div class="row">
                <div class="col-md-24" align="center">
                    <b>Print Report </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="Width: 995px">
            <div class="Purchaseheader"></div>
            <div class="row">
                <div class="col-md-6">
                </div>
                <div class="col-md-3">
                    Barcode No:
                </div>
                <div class="col-md-5 ">
                    <input type="text" id="txtLabNo" />
                </div>
                <div class="col-md-3">
                    <input type="button" value="Get Details" onclick="GetDetails();" style="margin-left: 20px;" />
                </div>
                <div class="col-md-3 DataFound">
                    <strong>Dispatch To :</strong>
                </div>
                <div class="col-md-4 DataFound">
                    <select id="ddlDispatchTo" onchange="SetDispatchOption();">
                        <option value="0">--Dispatch To--</option>
                        <option value="1">Self</option>
                        <option value="2">Other</option>
                        <option value="3">Courier</option>

                    </select>
                </div>

            </div>
            <div class="row">
                <div class="col-md-14 DataFound" style="text-align: right;">
                    <input type="checkbox" value="Print Header" id="chkHeader"  checked="checked"/><strong>Print Header</strong>
                </div>
                <div class="col-md-2 DataFound" style="text-align: right;">
                    <input type="button" value="Print & Dispatch" onclick="Dispatch();" />
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3" id="divOther" style="display: none;">
                    <input type="text" id="txtOtherName" placeholder="Name" maxlength="50" />
                </div>
                <div class="col-md-3" id="divOther1" style="display: none;">
                    <input type="text" id="txtOtherMobile" placeholder="Mobile" maxlength="10" />
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory DataFound" style="width: 1000px; text-align: center;">
            <div class="Purchaseheader">Patient Detail</div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 25%; text-align: right; font-weight: bold;">Patient Name : </td>
                            <td style="width: 25%; text-align: left; font-weight: bold;"><span id="spnPName"></span></td>
                            <td style="width: 15%; text-align: right; font-weight: bold;">Lab No : </td>
                            <td style="width: 35%; text-align: left; font-weight: bold;"><span id="spnLabNo"></span></td>

                        </tr>
                        <tr>
                            <td style="width: 25%; text-align: right; font-weight: bold;">Age : </td>
                            <td style="width: 25%; text-align: left; font-weight: bold;"><span id="spnAge"></span></td>
                            <td style="width: 15%; text-align: right; font-weight: bold;">Gender : </td>
                            <td style="width: 35%; text-align: left; font-weight: bold;"><span id="spnGender"></span></td>

                        </tr>
                        <tr>
                            <td style="width: 25%; text-align: right; font-weight: bold;">Refer Doctor : </td>
                            <td style="width: 25%; text-align: left; font-weight: bold;"><span id="spnRDoctor"></span></td>
                            <td style="width: 15%; text-align: right; font-weight: bold;">Panel : </td>
                            <td style="width: 35%; text-align: left; font-weight: bold;"><span id="spnPanel"></span></td>

                        </tr>
                    </table>
                </div>
            </div>


        </div>
        <div class="POuter_Box_Inventory  DataFound" style="width: 1000px; text-align: center; max-height: 500px; overflow-x: auto;">
            <div class="Purchaseheader">Test Detail</div>
            <div class="row">
                <div class="col-md-24">
                    <table id="tblData" width="100%" class="GridViewStyle">
                        <tr>
                            <th class="GridViewHeaderStyle">Sno.</th>
                            <th class="GridViewHeaderStyle">Department</th>
                            <th class="GridViewHeaderStyle">Investigation</th>
                            <th class="GridViewHeaderStyle">Status</th>
                            <th class="GridViewHeaderStyle">Visitno</th>
                            <%-- <th class="GridViewHeaderStyle">OPD/IPD</th>--%>
                            <th class="GridViewHeaderStyle">Registration Date</th>
                            <th class="GridViewHeaderStyle">SampleColection Date</th>
                            <th class="GridViewHeaderStyle">DispatchBy</th>
                            <th class="GridViewHeaderStyle">DispatchOn</th>
                            <th class="GridViewHeaderStyle">
                            <input type="checkbox" id="chkAll" onchange="CheckAll();" /></th>
                            <!-- <th class="GridViewHeaderStyle">ViewDetail</th> -->
                        </tr>

                    </table>
                </div>
            </div>


        </div>

    </div>




    <script type="text/javascript">

        $(document).ready(function () {
            $('#txtLabNo').focus();
        });

        $('#txtLabNo').keypress(function (event) {
            var keycode = (event.keyCode ? event.keyCode : event.which);
            if (keycode == '13') {
                GetDetails();
            }
        });

        function GetDetails() {
            $('#tblData tr').slice(1).remove();

            var LabNo = $('#txtLabNo').val().trim();
            if (LabNo == "") {
                alert('Please Enter Barcode No.');
                return;
            }
            $modelBlockUI();
            $.ajax({
                url: "PrintReportFrontOffice.aspx/GetDetails",
                async: true,
                data: JSON.stringify({ LabNo: LabNo }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var data = $.parseJSON(result.d);
                    if (data.length > 0) {
                        $('[id$=lblErr]').text('');
                        $('.DataFound').show();

                        $('#spnLabNo').text(LabNo);
                        $('#spnPName').text(data[0].PName);
                        $('#spnAge').text(data[0].Age);
                        $('#spnGender').text(data[0].Gender);
                        $('#spnPanel').text(data[0].PanelName);
                        $('#spnRDoctor').text(data[0].DoctorName);

                        for (var i = 0; i < data.length; i++) {
                            var html = '';
                            var RowColor = "";
                            if (data[i].Status == "Pending" || data[i].Status == "Result Pending" || data[i].Status == "Result Not Done")
                            {
                                RowColor = "pink";
                            }
                            else if (data[i].isPrint == "1") {

                                RowColor = "cyan";
                            }
                            else {
                                RowColor = "lightgreen";
                            }
                           // var RowColor = (data[i].Status == "Pending" || data[i].Status == "Result Pending" || data[i].Status == "Result Not Done") ? "pink" : "lightgreen";

                            html += '<tr style="background-color:' + RowColor + '">';
                            html += '<td>' + (i + 1) + '</td>';
                            html += '<td style="text-align:left;">' + data[i].Department + '</td>';
                            html += '<td style="text-align:left;">' + data[i].InvestigationName + '</td>';
                            html += '<td id="tdstatus">' + data[i].Status + '</td>';
                            html += '<td>' + data[i].Labno + '</td>';
                            //html += '<td>' + data[i].Hlmopdipd + '</td>';
                            html += '<td style="text-align:left;">' + data[i].Regdate + '</td>';
                            html += '<td style="text-align:left;">' + data[i].Samplecoldate + '</td>';
                            html += '<td>' + data[i].DispatchBy + '</td>';
                            html += '<td>' + data[i].DispatchedOn + '</td>';
                            html += '<td>';
                            //if ( (data[i].Approved == "1" ) || (data[i].Status == "Result Not Done") ) {
                            //    html += '<input type="checkbox" id="chkTest" /><input type="hidden" id="hdnId" value="' + data[i].Test_Id + '">';
                            //}
                            if (data[i].Approved == "1" && data[i].DispatchBy.trim().length == 0) {
                                html += '<input type="checkbox" id="chkTest" /><input type="hidden" id="hdnId" value="' + data[i].Test_Id + '">';
                            }
                            html += '</td>';
                            // html += '<td>';
                            // html += '<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick=viewDetail("' + data[i].Test_Id + '")>';
                            // html += '</td>';
                            html += '</tr>';

                            $('#tblData').append(html);

                        }
                    }
                    else {
                        $('.DataFound').hide();
                        $('[id$=lblErr]').text('No Record Found');
                    }

                    $modelUnBlockUI();
                }
            });


        }

        function viewDetail(BarcodeNo) {
            //var BarcodeNo = $(rowID).closest("tr").find('#td_BarcodeNo').text();
            serverCall('PrintReportFrontOffice.aspx/PostData', { ID: BarcodeNo }, function (response) {
                $responseData = JSON.parse(response);

                window.open("SampleTracking.aspx?barcodeno=" + $responseData.LabID, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            });
        }

        function Dispatch() {
            var TestId = '';
            var IsValid = false;

            var DispatchTo = $('#ddlDispatchTo').val();
            if (DispatchTo == "0") {
                alert('Please select dispatch to.');
                return;
            }
            else if (DispatchTo == "2") {
                if ($('#txtOtherName').val().trim() == "" || $('#txtOtherMobile').val().trim()=="") {
                    alert('Please provide other dispatch to details');
                    return;
                }
            }

            $('#tblData').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {
                    if ($(this).is(':checked')) {
                        IsValid = true;
                        TestId += $(this).next().val() + ',';
                    }

                }
            });
            if (!IsValid) {
                alert('Please select any investigation');
                return;
            }
            var prev = 0;
            $('#tblData tr').each(function () {
                if ($(this).attr('id') != 'header') {
                    tdstatus = $.trim($(this).find('#tdstatus').html());
                    
                    if (tdstatus == "Result Not Done") {
                         prev=1;
                    }
                }
            });
            if (TestId != '') {
                $.ajax({
                    url: "PrintReportFrontOffice.aspx/Dispatch",
                    async: true,
                    data: JSON.stringify({ TestId: TestId, DispatchTo: $('#ddlDispatchTo option:selected').text(), OtherName: $('#txtOtherName').val().trim(), OtherMobile: $('#txtOtherMobile').val().trim() }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var Header = $('[id$=chkHeader]').is(':checked') ? '1' : '0';
                        
                        window.open('../Lab/labreportnew.aspx?IsPrev='+ prev + '&PHead=' + Header + '&testid=' + TestId);
                        GetDetails();
                    }
                });


            }
        }

        function CheckAll() {
            $('#tblData').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {
                    if ($('#chkAll').is(':checked')) {
                        $(this).attr('checked', 'checked');
                    }
                    else {
                        $(this).removeAttr('checked');
                    }

                }
            });
        }

        function SetDispatchOption() {
            var DispatchTo = $('[id$=ddlDispatchTo]').val();
            if (DispatchTo == "0" || DispatchTo == "1" || DispatchTo == "3") {
                $('#divOther').hide();
                $('#divOther1').hide();
            } else {
                $('#divOther').show();
                $('#divOther1').show();
            }
        }
    </script>
</asp:Content>
