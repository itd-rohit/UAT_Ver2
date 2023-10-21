<%@ Page Title="Refund" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="RemoveLogisticTransaction.aspx.cs" Inherits="Design_Lab_RemoveLogisticTransaction" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <div class="alert fade" style="position: absolute; left: 50%; border-radius: 15px;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1300px;">
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <asp:Label ID="llheader" runat="server" Text="Remove Logistic Transaction" Font-Size="16px" Font-Bold="true"></asp:Label></td>

                    </tr>

                    <tr>

                        <td align="center">
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                    </tr>
                </table>

            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">Search Option</div>
            <div class="content">

                <table width="99%">

                    <tr>
                        <td style="width: 550px;text-align:right;">
                            <b>Barcode No :&nbsp;</b>                           
                        </td>
                        <td>
                             <asp:TextBox ID="txtLabNo" runat="server" CssClass="mytextbox" placeholder="Enter Barcode No To Search"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 550px;text-align:right;">
                                               
                        </td>
                        <td>
                            <input type="button" value="Search" class="searchbutton" onclick="searchdata('BT')" style="width:195px;" />
                        </td>
                    </tr>
                   
                </table>
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Patient Details&nbsp;
            </div>
            <table style="width: 1200px">
                <tr style="color: #000000; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 228px; height: 13px" valign="middle"></td>

                    <td align="right" class="ItDoseLabel" style="width: 98px; height: 13px; text-align: left"
                        valign="middle"><b>Patient ID :</b></td>
                    <td align="left" style="width: 284px; height: 13px" valign="middle">
                        <asp:Label ID="lblPatientID" runat="server" CssClass="PatientLabel" ></asp:Label></td>
                    <td align="right" style="width: 128px; height: 13px; text-align: left" valign="middle"><b>Patient Name:</b></td>
                    <td align="left" style="width: 255px; height: 13px" valign="middle">
                        <asp:Label ID="lblName" runat="server" CssClass="PatientLabel"></asp:Label></td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 228px; height: 13px" valign="middle"></td>
                    <td align="right" class="ItDoseLabel" style="width: 98px; height: 14px; text-align: left"
                        valign="middle"><b>Age / Gender:</b></td>
                    <td align="left" style="width: 284px; height: 14px" valign="middle">
                        <asp:Label ID="lblAge" runat="server" CssClass="PatientLabel"></asp:Label></td>
                    <td align="right" style="width: 128px; height: 14px; text-align: left" valign="middle"><b>Amount Paid:</b></td>
                    <td align="left" style="width: 255px; height: 14px" valign="middle">
                        <asp:Label ID="lblAmtPaid" runat="server" CssClass="PatientLabel"></asp:Label></td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 228px; height: 13px" valign="middle"></td>
                    <td align="right" class="ItDoseLabel" style="width: 98px; height: 14px; text-align: left"
                        valign="middle"><b>Doctor:</b></td>
                    <td align="left" style="width: 284px; height: 14px" valign="middle">
                        <asp:Label ID="lblDoctor" runat="server" CssClass="PatientLabel"></asp:Label></td>
                    <td align="right" style="width: 128px; height: 14px; text-align: left" valign="middle"><b>Net AMount:</b></td>
                    <td align="left" style="width: 255px; height: 14px" valign="middle">
                        <asp:Label ID="lblNetAmt" runat="server" CssClass="PatientLabel"></asp:Label>
                    </td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 228px; height: 13px" valign="middle"></td>
                    <td align="right" class="ItDoseLabel" style="width: 98px; height: 14px; text-align: left"
                        valign="middle"><b>Due Amount:</b></td>
                    <td align="left" style="width: 284px; height: 14px" valign="middle">
                        <asp:Label ID="lblDueAmt" runat="server" CssClass="PatientLabel" ForeColor="Red" Font-Bold="true"></asp:Label></td>
                    <td align="right" style="width: 128px; height: 14px; text-align: left" valign="middle"><b>Visit No:</b></td>
                    <td align="left" style="width: 255px; height: 14px" valign="middle">
                        <asp:Label ID="lblLabNoToSave" runat="server" CssClass="PatientLabel"></asp:Label>
                    </td>

                </tr>
                 <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif;">
                    <td align="right" class="ItDoseLabel" style="width: 228px; height: 13px" valign="middle"></td>
                    <td align="right" class="ItDoseLabel" style="width: 98px; height: 14px; text-align: left"
                        valign="middle"><b>Barcode No:</b></td>
                    <td align="left" style="width: 284px; height: 14px" valign="middle">
                        <asp:Label ID="lblReceiptNo" runat="server" CssClass="PatientLabel"></asp:Label></td>
                    <td align="right" style="width: 128px; height: 14px; text-align: left" valign="middle"><b>Lab ID:</b></td>
                    <td align="left" style="width: 255px; height: 14px" valign="middle">
                        <asp:Label ID="lblLabID" runat="server" CssClass="PatientLabel" ></asp:Label>
                    </td>

                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader" style="width: 1295px;">
                Prescribed Investigation
            </div>
            <table style="width: 1300px;">
                <tr>
                    <td style="width: 100px"></td>
                    <td style="width: 231px; text-align: center">Remove Reason</td>
                    <td colspan="2">
                        <asp:TextBox ID="txtReason" runat="server" Width="396px" CssClass="mytextbox" placeholder="Enter Remove Reason"></asp:TextBox>
                        <input type="button" value="Remove" class="searchbutton" onclick="savedata()" id="btnSave" style="width:120px;" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">

            <div class="content">
                <table style="width: 99%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" width="30px" style="text-align: center;">#</td>
                        <td class="GridViewHeaderStyle" width="300px" style="text-align: center;">Investigation</td>                                               
                        <td class="GridViewHeaderStyle" width="100px" style="text-align: center;">Date</td>                        
                        <td class="GridViewHeaderStyle" width="100px" style="text-align: center;">Status</td>                       
                    </tr>
                </table>
            </div>
        </div>

          

        <div class="POuter_Box_Inventory" style="width: 1300px; display: none;" id="mypay">
            <div class="Purchaseheader">Payment Detail&nbsp;&nbsp;&nbsp;  </div>
            <div class="content">
                <table width="99%">
                    <tr>
                        <td width="131px"><b>Item::</b></td>
                        <td colspan="5"><span id="itemname"></span>
                            <span id="labno" style="display: none;"></span>
                            <span id="labid" style="display: none;"></span>
                            <span id="pid" style="display: none;"></span>
                            <span id="panelid" style="display: none;"></span>
                            <span id="centreid" style="display: none;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Pay By::</b></td>
                        <td>
                            <asp:DropDownList ID="ddlpayby" runat="server">
                                <asp:ListItem Value="P">Patient</asp:ListItem>
                                <asp:ListItem Value="C">Corporate</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Amount::</b></td>
                        <td width="243">
                            <asp:TextBox ID="txtamount" runat="server" onkeyup="checkme()"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtamount">
                            </cc1:FilteredTextBoxExtender>
                            <asp:TextBox ID="lblamount" runat="server" Style="display: none;"></asp:TextBox>
                        </td>
                        <td width="220px"><b>Payment Mode::</b></td>
                        <td>
                            <asp:DropDownList ID="ddlpaymentmode" runat="server" onchange="showpaymentoption()"></asp:DropDownList>
                        </td>
                        <td width="202px"></td>
                        <td width="253px"></td>
                    </tr>
                    <tr id="trayment" style="display: none;">
                        <td><b>Bank Name:</b></td>
                        <td>
                            <asp:DropDownList ID="ddlbank" runat="server" Width="173" /></td>
                        <td><b>Card/Cheque No:</b></td>
                        <td>
                            <asp:TextBox ID="txtcardno" runat="server" Width="176"></asp:TextBox></td>
                        <td><b>Card/Cheque  Date:</b></td>
                        <td>
                            <asp:TextBox ID="txtcarddate" runat="server" Width="176"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="left" style="color: red;">
                            <input type="checkbox" id="chrefund" disabled="disabled" /><b>REFUND</b> </td>
                        <td><b>Remarks::</b></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtremarks" runat="server" placeholder="Remarks" Width="80%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <input type="button" id="btnsave" value="Save" onclick="savedata()" tabindex="9" class="savebutton" />
                            <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" />
                        </td>
                    </tr>
                </table>


            </div>

        </div>

    </div>
    <script type="text/javascript"> 
        function searchdata(Type) {            
            $('#tb_ItemList tr').slice(1).remove();
            var BarcodeNo;
            if(Type=='BT'){
                BarcodeNo = $('#<%= txtLabNo.ClientID%>').val();
            }
            else {
                BarcodeNo = $('#<%= lblReceiptNo.ClientID%>').html();
            }
            if (BarcodeNo == '') {
                showerrormsg("Please Enter Barcode No");
                clearAllTextBox();
                clearAllLabel();
                return;
            }           
            $modelBlockUI();
            $.ajax({
                url: "RemoveLogisticTransaction.aspx/searchdata",
                data: JSON.stringify({ BarcodeNo: BarcodeNo }),
                type: "POST",   	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);                       
                    if (TestData.length == 0) {
                        clearAllLabel();
                        $modelUnBlockUI();
                        showerrormsg("Record Not Found..!");
                        return false;
                    }
                    else {
                        clearAllLabel();
                        // Patient Personal Details
                        $('#<%= lblPatientID.ClientID%>').html(TestData[0].Patient_ID);
                            $('#<%= lblName.ClientID%>').html(TestData[0].PName);
                            $('#<%= lblAge.ClientID%>').html(TestData[0].Age + " " + TestData[0].Gender);
                            $('#<%= lblDoctor.ClientID%>').html(TestData[0].DoctorName);
                            $('#<%= lblAmtPaid.ClientID%>').html(TestData[0].Adjustment);
                            $('#<%= lblNetAmt.ClientID%>').html(TestData[0].NetAmount);
                        $('#<%= lblDueAmt.ClientID%>').html(parseInt(TestData[0].NetAmount) - parseInt(TestData[0].Adjustment));                       
                        $('#<%= lblLabNoToSave.ClientID%>').html(TestData[0].LedgerTransactionNo);
                        $('#<%= lblReceiptNo.ClientID%>').html(TestData[0].BarcodeNo);
                        $('#<%= lblLabID.ClientID%>').html(TestData[0].LedgerTransactionID);

                            
                        
                            for (var i = 0; i <= TestData.length - 1; i++) {
                                var mydata = '<tr>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + (i+1) + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData[i].ItemName.substr(TestData[i].ItemName.indexOf("~") + 1); + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData[i].DATE + '</td>';                               
                                mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData[i].RemovalStatus + '</td>';
                                mydata += '</tr>';
                                $('#tb_ItemList').append(mydata);
                            }
                        }
                        $modelUnBlockUI();
                        clearAllTextBox();
                    },
                    error: function (xhr, status) {
                        showerrormsg(status + "\r\n" + xhr.responseText);
                        window.status = status + "\r\n" + xhr.responseText;
                        $modelUnBlockUI();
                    }
                });
            }
     
        function savedata() {
            var BarcodeNo = $('#<%= lblReceiptNo.ClientID%>').html();
            var RemoveReason = $('#<%= txtReason.ClientID%>').val();
            if (RemoveReason == '') {
                showerrormsg("Please Enter Removal Reason.");
                return;
            }
            
                $modelBlockUI();
                $.ajax({
                    url: "RemoveLogisticTransaction.aspx/SaveData",
                    data: JSON.stringify({ BarcodeNo: BarcodeNo, RemoveReason: RemoveReason }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var save = result.d;
                        if (save.split('#')[0] == "1") {                       
                            clearAllTextBox();                         
                            $modelUnBlockUI();
                            showmsg("Removal Logistic Transaction Done.");
                            searchdata('FN');                           
                        }
                        else {
                            $modelUnBlockUI();
                        showerrormsg(save.split('#')[1]);                                               
                        }
                    },
                    error: function (xhr, status) {
                        $modelUnBlockUI();
                        showerrormsg("Some Error Occure Please Try Again..!");                        
                         console.log(xhr.responseText);
                    }
                });
        }
         
        
        function clearAllTextBox() {
            $(":text").val('');
        }
        function clearAllLabel() {
            $('.PatientLabel').html('');
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
        
    </script>
<style>
    .mytextbox{
    padding: 5px 12px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;

}
    #tb_ItemList tr:hover
    {
        background-color:yellowgreen;
        font-weight:bold;
        font-size:xx-large;
    }
</style>
</asp:Content>

