<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DownloadRateList.aspx.cs" Inherits="DayWiseDiscountReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="margin-top:80px;">

        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">
                <div class="col-md-24">
                     <b>Download Rate List </b>
                     <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Download" class="searchbutton" onclick="CheckLedgerPassword();" id="btnDownload" />
        </div>
    </div>
    <div id="LedgerPasswordPopup" style="display: none; position: fixed; top: 25%; left: 40%; width: 400px; height: 150px; border: 1px solid red; background-color: #fff; text-align: center; padding: 15px;">

        <a href="javascript:void(0);" style="float: right;" id="A1" onclick="ClosePopUp()">Close</a><br /><br />
       
     
                <span>Ledger Password  :</span>
           
            <input type="password" style="width:150px" placeholder="Enter Ledger Password" id="txtLedgerPassword" />
      
        <input type="button"  class="savebutton" value="Submit" onclick="CheckLedgerPassword();" />

    </div>

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
            //if (LedgerPassword == "") {
            //    toast("Error", "Please Enter ledger password !", "");
            //    $('[id$=txtLedgerPassword]').focus();
            //    return;
            //} else {
                serverCall('DownloadrateList.aspx/CheckLedgerPassword', { LedgerPassword: LedgerPassword }, function (response) {
                    var $response = JSON.parse(response);
                    if ($response == "1") {
                        ClosePopUp();
                        window.open('DownloadRateList1.aspx');
                    } else if ($response == "0") {
                        toast("Error", "Incorrect Ledger Password !", "");
                    }
                    else if ($response == "2") {
                        toast("Error", "No Record Found !", "");
                    }
                    else if ($response == "-2") {
                        toast("Error","You do not have right to access this page","");
                    }
                    else {
                        toast("Error", "Some Error Occured !", "");
                    }
                });
           // }
        }
        function disableControl() {
            $("#btnDownload").attr('disabled', 'disabled');
        }

    </script>


</asp:Content>
