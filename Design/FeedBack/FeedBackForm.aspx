<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="FeedBackForm.aspx.cs" Inherits="Design_FeedBack_FeedBackForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .myred {
            color: red;
            font-weight: bold;
        }

        .container {
            position: fixed;
            bottom: 0px;
            right: 0px;
            z-index: 1;
            text-align: center;
            display: none;
        }

        .feedback {
            display: none;
            border: solid 4px #006699;
            background-color: #DEDEDE;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        a.button-slide {
            display: block;
            width: 120px;
            padding: 2px;
            margin: 0 auto;
            background-color: #006699;
            color: #FFFFFF;
            font-size: 14px;
            width: 160px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            border-bottom-right-radius: 10px;
            border-bottom-left-radius: 10px;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }
    </style>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>


    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center" colspan="6">
                            <asp:Label ID="llheader" runat="server" Text="FeedBack Form" Font-Size="16px" Font-Bold="true"></asp:Label>
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>

                    </tr>
                </table>

            </div>
        </div>


        <div class="div_Patientinfo">
            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="content">
                    <div class="Purchaseheader">
                        Ensert Option
                    </div>
                    <table style="width: 99%">
                        <tr>
                            <td class="required"><b>Name.:</b> </td>
                            <td width="290px">
                                <asp:TextBox ID="txtName" runat="server" MaxLength="100"></asp:TextBox>
                            </td>
                            <td><b>Mobile No.:</b></td>
                            <td>
                                <asp:TextBox ID="txtpID" runat="server" Width="150px" MaxLength="10" style="display:none"></asp:TextBox>
                                <asp:TextBox ID="txtmobile" runat="server" Width="150px" MaxLength="10" onkeyup="showlength()"></asp:TextBox>
                                <span id="molen" style="font-weight: bold;"></span>
                            </td>
                            <td><b>Email ID:</b></td>
                            <td>
                                <asp:TextBox ID="txtEmail" runat="server" MaxLength="60"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td><b>DOB</b></td>
                            <td>
                                <asp:TextBox ID="txtdob" runat="server" Width="126px"></asp:TextBox></td>
                            <td><b>Address</b></td>
                            <td>
                                <asp:TextBox ID="txtAdd" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox></td>
                        </tr>
                    </table>
                </div>
            </div>


            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="content">
                    <div class="Purchaseheader">
                        FeedBack Option
                    </div>
                    <table>
                        <tr>
                            <td><b>What time did you visit us?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="VisitTime" checked="checked" type="radio" value="Between 7:30 am – 9am" class="fl" /><span>Between 7:30 am – 9am</span></td>
                            <td>
                                <input name="VisitTime" type="radio" value="Between 9 am – 11am" class="fl" /><span>Between 9 am – 11am</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="VisitTime" type="radio" value="Between 11 am – 5pm" class="fl" /><span>Between 11 am – 5pm</span></td>
                            <td>
                                <input name="VisitTime" type="radio" value="Between 5 pm – 8pm" class="fl" /><span>Between 5 pm – 8pm</span></td>
                        </tr>
                        <tr>
                            <td><b>How did you come to know Overview?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="Overview" checked="checked" type="radio" value="Refer by Doctor" class="fl" /><span>Refer by Doctor</span></td>
                            <td>
                                <input name="Overview" type="radio" value="Newspaper/Magazine Ad" class="fl" /><span>Newspaper/Magazine Ad</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="Overview" type="radio" value="Hoarding/ kiosk" class="fl" /><span>Hoarding/ kiosk</span></td>
                            <td>
                                <input name="Overview" type="radio" value="Leaflet" class="fl" /><span>Leaflet</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="Overview" type="radio" value="Close to home/ Workplace" class="fl" /><span>Close to home/ Workplace</span>
                            </td>
                            <td style="display:none;">
                                <input name="Overview" type="radio" value="If any another please specify" class="fl" /><span>If any another please specify</span>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input name="txtAnyOth" style="display:none;" type="text" maxlength="50" id="txtAnyOth" class="specify" /></td>
                        </tr>
                        <tr>
                            <td><b>Why did you choose CCL Lab</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="ccLlAB" checked="checked" type="radio" value="Oldest reliable lab" class="fl" /><span>Oldest reliable lab</span></td>
                            <td>
                                <input name="ccLlAB" type="radio" value="Quality of report" class="fl" /><span>Quality of report</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="ccLlAB" type="radio" value="Our service" class="fl" /><span>Our service</span></td>
                            <td style="display:none;">
                                <input name="ccLlAB" type="radio" value="If any another please specify" class="fl" /><span>If any another please specify</span></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input name="txtChose" style="display:none;" type="text" maxlength="50" id="txtChose" class="specify" /></td>
                        </tr>
                        <tr>
                            <td><b>Was the registration process easy and convenient?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="rgProcess" checked="checked" type="radio" value="Yes" class="fl" /><span>Yes</span></td>
                            <td>
                                <input name="rgProcess" type="radio" value="No" class="fl" /><span>No</span></td>
                        </tr>
                        <tr>
                            <td><b>Was the staff at registration counter courteous?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="rgstaff" checked="checked" type="radio" value="Yes" class="fl" /><span>Yes</span></td>
                            <td>
                                <input name="rgstaff" type="radio" value="No" class="fl" /><span>No</span></td>
                        </tr>
                        <tr>
                            <td><b>How long was the waiting time before drawing blood?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="drblood" checked="checked" type="radio" value="0-5 minutes" class="fl" /><span>0-5 minutes</span></td>
                            <td>
                                <input name="drblood" type="radio" value="5-15 minutes" class="fl" /><span>5-15 minutes</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="drblood" type="radio" value="15-30 minutes" class="fl" /><span>15-30 minutes</span></td>
                        </tr>
                        <tr>
                            <td><b>Was the technician courteous and efficient?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="techCout" checked="checked" type="radio" value="Yes" class="fl" /><span>Yes</span></td>
                            <td>
                                <input name="techCout" type="radio" value="No" class="fl" /><span>No</span></td>
                        </tr>
                        <tr>
                            <td><b>How would you like to collect your report?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="report" checked="checked" type="radio" value="Visit the center" class="fl" /><span>Visit the center</span></td>
                            <td>
                                <input name="report" type="radio" value="Through the website" class="fl" /><span>Through the website</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="report" type="radio" value="Via E-mail" class="fl" /><span>Via E-mail</span></td>
                            <td>
                                <input name="report" type="radio" value="Home Delivery through commercial courier" class="fl" /><span>Home Delivery through commercial courier</span></td>
                        </tr>
                        <tr>
                            <td><b>Are you aware of our home collection and report delivery service?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="rptdelivery" checked="checked" type="radio" value="Yes" class="fl" /><span>Yes</span></td>
                            <td>
                                <input name="rptdelivery" type="radio" value="No" class="fl" /><span>No</span></td>
                        </tr>
                        <tr>
                            <td><b>How would you rate our overall services of the lab?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="overAllreport" checked="checked" type="radio" value="Poor" class="fl" /><span>Poor</span></td>
                            <td>
                                <input name="overAllreport" type="radio" value="Average" class="fl" /><span>Average</span></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="report" type="radio" value="Good" class="fl" /><span>Good</span></td>
                            <td>
                                <input name="report" type="radio" value="Excellent" class="fl" /><span>Excellent</span></td>
                        </tr>
                        <tr>
                            <td><b>Would you recommend our services to others ?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <input name="rcommServices" checked="checked" type="radio" value="Yes" class="fl" /><span>Yes</span></td>
                            <td>
                                <input name="rcommServices" type="radio" value="No" class="fl" /><span>No</span></td>
                        </tr>
                        <tr>
                            <td><b>Would you recommend our services to others ?</b></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="recoOther" runat="server" ClientIDMode="Static" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="text-align: center;">
                 <input type="button" id="btnopenPopup" style="display: none;" value="Save" onclick="OpneSavePOpup()" tabindex="21" class="savebutton" />
                <input type="button" id="btnsave" style="display:none;" value="Save" onclick="savedata()" tabindex="21" class="savebutton" />
                <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" />
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
                                    <th scope="col" style="display:none;">SendMail</th>
                                    <th scope="col">Delete</th>
                                </tr>
                            </thead>
                            <tbody id="bindreport">
                            </tbody>
                        </table>
                    </td>

                </tr>




            </table>
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
                <input type="button" id="Button2" value="Save" onclick="savedata()" tabindex="21" class="savebutton" />
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
            $("#ContentPlaceHolder1_txtdob").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    var dob = new Date(value);
                }
            });
        });
        function iFrameFeedBack() {
            var loc = window.location.toString(),
             params = loc.split('?')[1],
             params1 = loc.split('&')[1],
             params2 = loc.split('&')[2],
           //  params3 = loc.split('&')[3].split("Name:")[1],
             iframe = document.getElementById('estimateiframe');
            if (params != undefined) {
                var pname = loc.split('&')[3].split("Name:")[1].trim();
                $('#<%=txtName.ClientID%>').val(pname.replace(/[%20]/g, ' '));//pname.split("%20")[1].trim();
                $('#<%=txtmobile.ClientID%>').val(params.split('&')[0]);
                $('#<%=txtpID.ClientID%>').val(params2);
                if (params1 == "Patient") {
                    BindReport(params2);
                }
                if (params1 == "Doctor" || params1 == "PUP") {
                    BindReport(params2);
                }
                $('#mastertopcorner').hide();
                $('#masterheaderid').hide();
                $('#btnopenPopup').show();
            }
            else {
                $('#btnopenPopup').hide();
                $('#btnsave').show();
                return false;
            }
        }
        function savedata() {
            if (validation() == false) {
                return;
            }
            $("#Button2").attr('disabled', true).val("Submiting...");
            var pName = $('#<%=txtName.ClientID%>').val();
            var pMobile = $('#<%=txtmobile.ClientID%>').val();
            var pID = $('#<%=txtpID.ClientID%>').val();
            var pEmail = $('#<%=txtEmail.ClientID%>').val();
            var pDob = $('#<%=txtdob.ClientID%>').val();
            var pAddress = $('#<%=txtAdd.ClientID%>').val();
            var pVisit = $("input[name='VisitTime']:checked").val();
            var pOverview = $("input[name='Overview']:checked").val();
            var pccLlAB = $("input[name='ccLlAB']:checked").val();
            var prgProcess = $("input[name='rgProcess']:checked").val();
            var prgstaff = $("input[name='rgstaff']:checked").val();
            var pdrblood = $("input[name='drblood']:checked").val();
            var ptechCout = $("input[name='techCout']:checked").val();
            var preport = $("input[name='report']:checked").val();
            var prptdelivery = $("input[name='rptdelivery']:checked").val();
            var poverAllreport = $("input[name='overAllreport']:checked").val();
            var prcommServices = $("input[name='rcommServices']:checked").val();
            var PRecommneded = $('#recoOther').val();
            var request = { pName: pName, pMobile: pMobile, pID: pID, pEmail: pEmail, pDob: pDob, pAddress: pAddress, pVisit: pVisit, pOverview: pOverview, pccLlAB: pccLlAB, prgProcess: prgProcess, prgstaff: prgstaff, pdrblood: pdrblood, ptechCout: ptechCout, preport: preport, prptdelivery: prptdelivery, poverAllreport: poverAllreport, prcommServices: prcommServices, PRecommneded: PRecommneded };
            $.ajax({
                url: "FeedbackForm.aspx/SaveFeedBack",
                data: JSON.stringify(request),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var save = result.d;
                        if (save == "0") {
                            $('#Button2').attr('disabled', false).val("Save");
                            clearForm();
                            saveFeedBack();
                            showmsg("Record Saved..!");
                        }
                    else {
                        showerrormsg("Record Not Saved");
                        $('#Button2').attr('disabled', false).val("Save");
                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                    $('#Button2').attr('disabled', false).val("Save");
                    console.log(xhr.responseText);
                }
            });
        }
        function clearForm() {
            $('#<%=txtName.ClientID%>').val('');
            $('#<%=txtmobile.ClientID%>').val('');
            $('#<%=txtpID.ClientID%>').val('');
            $('#<%=txtEmail.ClientID%>').val('');
            $('#<%=txtdob.ClientID%>').val('');
            $('#<%=txtAdd.ClientID%>').val('');
            $('#recoOther').val('');
        }
        function validation() {
            if ($('#<%=txtdob.ClientID%>').val().length == 0) {
                showerrormsg("Please Enter DOB");
                $('#<%=txtdob.ClientID%>').focus();
                return false;

            }
            if ($('#<%=txtmobile.ClientID%>').val().length == 0) {
                showerrormsg("Please Enter Mobile No.");
                $('#<%=txtmobile.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtmobile.ClientID%>').val().length != 0) {
                if ($('#<%=txtmobile.ClientID%>').val().length < 10) {
                    showerrormsg("Incorrect Mobile No.");
                    $('#<%=txtmobile.ClientID%>').focus();
                    return false;
                }
            }
            if ($('#<%=txtName.ClientID%>').val().trim().length == 0) {
                showerrormsg("Please Enter Name");
                $('#<%=txtName.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtEmail.ClientID%>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#<%=txtEmail.ClientID%>').val())) {
                    showerrormsg('Incorrect Email ID');
                    $('#<%=txtEmail.ClientID%>').focus();
                    return false;
                }
            }
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
        function showlength() {
            if ($('#<%=txtmobile.ClientID%>').val() != "") {
                $('#molen').html($('#<%=txtmobile.ClientID%>').val().length);
            }
            else {
                $('#molen').html('');
            }
            if ($.trim($('#<%=txtmobile.ClientID%>').val()) == "123456789") {
                showerrormsg("Please Enter Valid Mobile No.");
                $('#<%=txtmobile.ClientID%>').val('');
                $('#molen').html('');
                return;
            }
            if ($.trim($('#<%=txtmobile.ClientID%>').val()).charAt(0) == "0") {
                showerrormsg("Please Enter Valid Mobile No.");
                $('#<%=txtmobile.ClientID%>').val('');
                $('#molen').html('');
                return;
            }
        }
        function BindReport(ID) {
            var s = 1;
            $.ajax({
                url: "FeedBackForm.aspx/BindFeedBack",
                data: JSON.stringify({ ID: ID }),
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
                            '</td><td style="display:none;">' +
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
                url: "FeedBackForm.aspx/DeleteFeedBack",
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
            if (validation() == false) {
                return;
            }
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
                url: "FeedBackForm.aspx/SaveNewFeedBackLog",
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
    </script>
</asp:Content>

