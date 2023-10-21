<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="FeedBack.aspx.cs" Inherits="Design_Websitedata_FeedBack" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .myred {
            color: red;
            font-weight: bold;
        }
    </style>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div style="text-align: center; font-weight: 700; font-size: medium;">
                    FeedBack & Suggestions
                </div>
                <div style="text-align: center;">
                    &nbsp;<asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>&nbsp;
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table style="width: 100%">
                <tr>
                    <td>
                        <asp:Button ID="btnExcel" runat="server" Text="ExportToExcel" OnClick="btnExcel_Click" BackColor="LightYellow" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; height: 24px;" valign="middle" class="ItDoseLabel" colspan="6">
                        <table cellspacing="0" cellpadding="4" rules="rows" id="ContentPlaceHolder1_grd" style="background-color: White; border-color: #336666; border-width: 3px; border-style: Double; width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr align="left" style="color: White; background-color: #336666; font-weight: bold;">
                                    <th scope="col">Sr.No</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">MobileNo</th>
                                    <th scope="col">Address</th>
                                    <th scope="col">DateOfVisit</th>
                                    <th scope="col">FeedBack</th>
                                    <th scope="col">EmailID</th>
                                    <th scope="col">Print</th>
                                    <th scope="col">SendMail</th>
                                    <th scope="col">Delete</th>
                                </tr>
                            </thead>
                            <tbody id="bindreport">
                            </tbody>
                        </table>
                    </td>

                </tr>




            </table>
            <div class="POuter_Box_Inventory" style="width: 989px;">
                <div class="content" style="text-align: center;">
                    <input type="button" id="btnopenPopup" style="display: none;" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" />
                </div>
            </div>
        </div>
        <cc1:ModalPopupExtender ID="modelmail" runat="server" PopupControlID="pnlmail"
            TargetControlID="modelpopup" BackgroundCssClass="filterPupupBackground">
        </cc1:ModalPopupExtender>
        <asp:Button ID="modelpopup" runat="server" Style="display: none" />
        <asp:Panel ID="pnlmail" runat="server" BorderStyle="None" Width="400px" BackColor="#EAF3FD" Style="display: none">
            <div class="POuter_Box_Inventory" style="width: 100%">
                <div class="content" style="text-align: left; width: 100%;">
                    <strong>FeedBack Mail Sending</strong><br />
                    <table width="100%">
                        <tr>
                            <td align="right">Mail :</td>
                            <td>
                                <asp:TextBox ID="txtmail" runat="server"></asp:TextBox>
                                <asp:Label ID="lblid" runat="server" Style="display: none"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Comment :</td>
                            <td>
                                <asp:TextBox ID="txtcomment" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <asp:Button ID="btnsendmail" runat="server" CommandName="sendmail" Text="Sendmail" OnClick="btnsendmail_Click" />
                            </td>
                            <td>
                                <asp:Button ID="btncancel" runat="server" Text="cancel" /></td>
                        </tr>
                    </table>
                </div>
            </div>
        </asp:Panel>
    </div>
    <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Save
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left;">
                        <td style="font-weight: bold;">Remarks</td>
                        <td>
                            <textarea id="remarks"></textarea></td>
                    </tr>
                </table>
                <input type="button" id="btnsave" value="Save" onclick="saveFeedBack()" tabindex="21" class="savebutton" />
                <asp:Button ID="btncloseopd" Style="display: none;" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
    <script type="text/javascript">
        $(document).ready(function () {
            iFrameFeedBack();
        });

        function iFrameFeedBack() {
            var loc = window.location.toString(),
             params = loc.split('?')[1],
             params1 = loc.split('&')[1],
             params2 = loc.split('&')[2],
             iframe = document.getElementById('estimateiframe');
            if (params != undefined) {
                BindReport(params.split('&')[0]);
                $('#mastertopcorner').hide();
                $('#masterheaderid').hide();
                $('#btnopenPopup').show();
            }
            else {
                $('#btnopenPopup').hide();
                return false;
            }
        }
        function BindReport(MobileNo) {
            var s = 1;
            $.ajax({
                url: "FeedBack.aspx/BindFeedBack",
                data: JSON.stringify({ MobileNo: MobileNo }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var pdata = $.parseJSON(result.d);
                    if (pdata.length > 0) {
                        for (var i = 0; i < pdata.length; i++) {
                            var si = s++;
                            var mydata = '<tr align="left" style="color:#333333;background-color:White;">' +
				            '<td>' + si + '</td>' +
                            '<td>' + pdata[i].FBNAME + '</td>' +
                            '<td>' + pdata[i].FBMBNO + '</td>' +
                            '<td>' + pdata[i].FBADDRESS + '</td>' +
                            '<td>' + pdata[i].FBDOV + '</td>' +
                            '<td>&nbsp;</td>' +
                            '<td class="emalid">' + pdata[i].FBEMAILID + '</td><td>' +
                            '<input type="image"  id="imbprint" onclick="printData(' + pdata[i].ID + ')" title="Remove Item" src="../../App_Images/view.gif">' +
                            '</td><td>' +
                            '<span onclick="SendEmail(this);"><a href="#">SendMail</a></span>' +
                            '</td><td>' +
                            '<input type="image" onclick="DeleteFeedBack(' + pdata[i].ID + ')" title="Remove Item" src="../../App_Images/Delete.gif">' +
                            '</td></tr>';
                            $('#bindreport').append(mydata);
                        }
                    }
                    else {
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function printData(ID) {
            window.open('../../Design/FeedBack/Viewdata.aspx?id=' + ID + '&type=Feedback');
        }
        function SendEmail(btn) {
            if (typeof (btn) == "object") {
                $('#ContentPlaceHolder1_txtmail').val($(btn).closest("tr").find('td:eq(6)').text());
            }
            $find("<%=modelmail.ClientID%>").show();
        }
        function DeleteFeedBack(ID) {
            $.ajax({
                url: "FeedBack.aspx/DeleteFeedBack",
                data: JSON.stringify({ ID: ID }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("FeedBack deleted successfully...!");
                        return;
                    }
                    if (result.d == "0") {
                        showerrormsg("Not deleted try again...!");
                        return;
                    }
                    if (result.d == "2") {
                        showerrormsg("Some Error...!");
                        return;
                    }
                }
            });
        }
        function OpneSavePOpup() {
            $find("<%=modelopdpatient.ClientID%>").show();
        }
        function saveFeedBack() {

            var loc = window.location.toString(),
            params = loc.split('?')[1],
            params1 = loc.split('&')[1],
            params2 = loc.split('&')[2],
            params3 = params.split('&')[0],
            iframe = document.getElementById('estimateiframe');
            var MobileNo = params3;
            var CallBy = params1;
            var CallByID = params2;
            var CallType = "FeedBack";
            var Remarks = $('#remarks').val();
            $("#btnsave").attr('disabled', true).val("Submiting...");
            $.ajax({
                url: "FeedBack.aspx/SaveNewFeedBackLog",
                data: JSON.stringify({ MobileNo: MobileNo, CallBy: CallBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Saved..!");
                        $('#btnsave').attr('disabled', false).val("Save");
                        $find("<%=modelopdpatient.ClientID%>").hide();
                        $('#remarks').val('');
                        clearForm();
                    }
                    else {
                        showerrormsg(save.split('#')[1]);
                        $('#btnsave').attr('disabled', false).val("Save");
                    }
                }
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
    </script>
</asp:Content>





