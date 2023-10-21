<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DownloadRateList.aspx.cs" Inherits="DayWiseDiscountReport" %>

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
                            <b>Download Rate List </b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>


        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">

            <input type="button" value="Download" class="searchbutton" onclick="OpenPopUp();" />
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center; max-height: 500px; overflow-x: auto;">
        </div>

    </div>
    <%-- Popup SampleType Wise Test Apurva : 11-09-2018 --%>
    <div id="LedgerPasswordPopup" style="display: none; position: fixed; top: 25%; left: 40%; width: 250px; height: 150px; border: 1px solid red; background-color: #fff; text-align: center; padding: 15px;">

        <a href="javascript:void(0);" style="float: right;" id="A1" onclick="ClosePopUp()">Close</a>
        <div style="margin-top: 20px; overflow: auto; height: 70px; padding-top: 30px;">
            <div style="width: 70%; text-align: left; font-weight: bold; padding-left: 41px; padding-bottom: 10px;">
                <span>Ledger Password  </span>
            </div>
            <input type="password" placeholder="Enter Ledger Password" id="txtLedgerPassword" />
        </div>
        <input type="button" class="savebutton" value="Submit" onclick="CheckLedgerPassword();" />

    </div>
    <%-- Popup SampleType Wise Test Apurva : 11-09-2018 END --%>


    <script type="text/javascript">

        function OpenPopUp() {
            $('#LedgerPasswordPopup').show();
$('#txtLedgerPassword').val('');
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            $('[id$=txtLedgerPassword]').focus();
        }

        function ClosePopUp() {
            $('#LedgerPasswordPopup').fadeOut("slow");
            $('#LedgerPasswordPopup').hide();
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }

        function CheckLedgerPassword() {
            var LedgerPassword = $('[id$=txtLedgerPassword]').val().trim();
            if (LedgerPassword == "") {
                alert('Please Enter ledger password !');
                $('[id$=txtLedgerPassword]').focus();
                return;
            } else {
                $.ajax({
                    url: "DownloadrateList.aspx/CheckLedgerPassword",
                    async: false,
                    data: '{LedgerPassword:"' + LedgerPassword + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            ClosePopUp();
                            window.open('DownloadRateList1.aspx');
                        } else if (result.d == "0") {
                            alert('Incorrect Ledger Password !');
                        }
                        else if (result.d == "2") {
                            alert('No Record Found !');
                        }
                        else {
                            alert('Some Error Occured !');
                        }
                    }
                });

            }
        }

    </script>


</asp:Content>
