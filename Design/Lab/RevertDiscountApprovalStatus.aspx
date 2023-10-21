<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="RevertDiscountApprovalStatus.aspx.cs" Inherits="Design_Lab_RevertDiscountApprovalStatus" %>

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

    <div id="Pbody_box_inventory" style="width: 1304px;">

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Revert Discount Approval Status </b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>


        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">
            <span><strong>Lab No. : </strong></span>
            <input type="text" placeholder="Enter Lab No" id="txtLabNo" maxlength="15" style="width: 200px; margin-top: 30px;" /><br />
            <br />
            <input type="button" value="Search" class="searchbutton" onclick="Search()" /><br />
        </div>
        <div class="POuter_Box_Inventory" id="divData" style="width: 1300px; text-align: center; max-height: 500px; overflow-x: auto; display: none;background-color:#fff;">
            <table id="tblData" style="width: 100%">
                <tr>
                    <th class="GridViewHeaderStyle">SNo.</th>
                    <th class="GridViewHeaderStyle">Patient Name</th>
                    <th class="GridViewHeaderStyle">Visit No</th>
                    <th class="GridViewHeaderStyle">Date</th>
                    <th class="GridViewHeaderStyle">Net Amount</th>
                    <th class="GridViewHeaderStyle">Discount</th>
                    <th class="GridViewHeaderStyle">Discount By</th>
                    <th class="GridViewHeaderStyle">Discount Status</th>
                    <th class="GridViewHeaderStyle">Action</th>

                </tr>
            </table>
        </div>

    </div>



    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtLabNo').focus();

        });
        $("#txtLabNo").keydown(function (e) {
            if (e.keyCode == 13) {
                Search();
            }
        });

        function Search() {
            $('#tblData tr').slice(1).remove();
            $('#divData').hide();
            $('[id$=lblErr]').text('');

            var IsValid = true;
            var LedgertransactionNo = $("#txtLabNo").val().trim();
            if (LedgertransactionNo == "") {
                IsValid = false;
            }

            if (IsValid) {
                $modelBlockUI();

                $.ajax({
                    url: "RevertDiscountApprovalStatus.aspx/Search",
                    async: true,
                    data: JSON.stringify({ LedgertransactionNo: LedgertransactionNo }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000000,
                    dataType: "json",
                    success: function (result) {
                        var data = $.parseJSON(result.d);
                        if (data.length > 0) {
                            var html = '';
                            if (data[0].Status == "NoDiscount") {
                                $('[id$=lblErr]').text('No Discount has given');
                            }
                            else if (data[0].IsDiscountApproved == "0") {
                                $('[id$=lblErr]').text('Discount Approval is still Pending');
                            }
                            else {
                                $('#divData').show();
                                for (var i = 0; i < data.length; i++) {
                                    html += '<tr>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + (i + 1) + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].PName + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].LedgertransactionNo + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].DATE + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].NetAmount + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].DiscountOnTotal + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].DiscountApprovedByName + '</td>'; 
                                    html += '<td class="GridViewItemStyle" style="text-align:left">' + data[i].DiscountStatus + '</td>';
                                    html += '<td class="GridViewItemStyle" style="text-align:center"> <input type="Button" id="btnSubmit" value="Reset Status" onclick="UpdateStatus(' + data[i].LedgertransactionId + ');" /> </td>';
                                    html += '</tr>';
                                }
                                $('#tblData').append(html);
                            }
                        } else {
                            $('[id$=lblErr]').text('No Record Found');
                            $('#divData').hide();
                        }
                        $modelUnBlockUI();
                    }
                });
            }
            else {
                alert('Please enter Lab no.');
                $('#txtLabNo').focus();

            }

        }

        function UpdateStatus(LedgertransactionId) {
            $modelBlockUI();
            $.ajax({
                url: "RevertDiscountApprovalStatus.aspx/UpdateStatus",
                async: true,
                data: '{LedgertransactionId:"' + LedgertransactionId + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $modelUnBlockUI();
                        $('[id$=lblErr]').text('Status Updated Successfully');
                        $('#divData').hide();

                    }
                    else {
                        $modelUnBlockUI();
                        $('[id$=lblErr]').text('Some Error Occured !');
                    }
                }
            });

        }

    </script>
</asp:Content>
