<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="FeedBackForm.aspx.cs" Inherits="Design_CallCenter_FeedBackForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
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

        .web_dialog_overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            background: #000000;
            opacity: .15;
            filter: alpha(opacity=15);
            -moz-opacity: .15;
            z-index: 101;
            display: none;
        }

        .web_dialog {
            display: none;
            position: fixed;
            width: 220px;
            top: 50%;
            left: 50%;
            margin-left: -190px;
            margin-top: -100px;
            background-color: #ffffff;
            border: 2px solid #336699;
            padding: 0px;
            z-index: 102;
            font-family: Verdana;
            font-size: 10pt;
        }

        .web_dialog_title {
            border-bottom: solid 2px #336699;
            background-color: #336699;
            padding: 4px;
            color: White;
            font-weight: bold;
        }

            .web_dialog_title a {
                color: White;
                text-decoration: none;
            }

        .align_right {
            text-align: right;
        }
    </style>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <div id="output"></div>
    <div id="overlay1" class="web_dialog_overlay"></div>
    <div id="dialog1" style="position: fixed; width: 250px; top: 50%; left: 50%; margin-left: -190px; margin-top: -100px; background-color: #ffffff; border: 2px solid #336699; padding: 0px; z-index: 102; font-family: Verdana; font-size: 10pt;"
        class="web_dialog">
        <table style="width: 100%; display: block; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyState">
            <tr>
                <td class="web_dialog_title" style="width: 100%; text-align: left;">Remarks</td>
                <td class="web_dialog_title" style="width: 100%"></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
            </tr>
            <%--              <tr>  
                <td colspan="2" style="padding-left: 15px;text-align:left;"><b>Call Closing Option </b></td>  
            </tr>
           <tr>
                <td colspan="2" style="padding-left: 15px;text-align:left;">
                    <select style="width:220px;" id="callidremarks" onchange="bindRemarksText();"></select>
                    </td>
           </tr>--%>
            <tr>
                <td colspan="2" style="padding-left: 15px; text-align: left;"><b>Call Closing Remarks </b></td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 15px; text-align: left;">
                    <asp:DropDownList ID="remarks" runat="server" class="remarks chosen-select chosen-container" Width="160px" ClientIDMode="Static"></asp:DropDownList>
                    <%--<asp:TextBox ID="remarks" TextMode="MultiLine" ClientIDMode="Static" runat="server" Width="214px"></asp:TextBox>--%>
                </td>
            </tr>

            <tr>
                <td style="text-align: left; text-align: left;">
                    <input type="button" value="Save" id="btnupdt" class="savebutton" onclick="savedata();" style="width: 75px; margin-left: 11px;" />
                </td>
            </tr>
        </table>

    </div>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1000px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 995px;">
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
            <div class="POuter_Box_Inventory" style="width: 995px;">
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
                                <asp:TextBox ID="txtpID" runat="server" Width="150px" MaxLength="10" Style="display: none"></asp:TextBox>
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
            <div class="POuter_Box_Inventory" style="width: 995px;">
                <div class="content">
                    <div class="Purchaseheader">
                        FeedBack Option
                    </div>
                    <table>
                        <tbody id="feedbackId">
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 995px;">
                <div class="content" style="text-align: center;">
                    <input type="button" id="btnopenPopup" style="display: block; float: left; margin-left: 400px;" value="Save" onclick="OpneSavePOpup()" class="savebutton" />
                    <input type="button" value="Clear" style="float: left;" onclick="clearForm()" class="resetbutton" />
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
                                    <th scope="col">EmailID</th>
                                    <th scope="col" style="display: none;">Print</th>
                                    <th scope="col" style="display: none;">SendMail</th>
                                    <th scope="col" style="display: none;">Delete</th>
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
    <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Save
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left;">
                        <td style="font-weight: bold;">Call Closing Remarks</td>
                        <td>
                            <textarea id="remarks1"></textarea></td>
                    </tr>
                </table>
                <input type="button" id="btnsave" value="Save" onclick="savedata()" tabindex="21" class="savebutton" />
                <asp:Button ID="btncloseopd" Style="display: none;" runat="server" Text="Close" CssClass="resetbutton" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
    <script type="text/javascript">
        $(function () {
            iFrameFeedBack();
            BindRemarks();
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
            $('.chosen-container').css('width', '200px');
        });
        function BindRemarks() {
            $.ajax({
                url: "FeedBackForm.aspx/GetRemarks",
                data: '{ }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientRemarks = eval('[' + result.d + ']');
                    $('#remarks').append('<option value="">---Select---</option>');
                    if (PatientRemarks.length > 0) {
                        for (var i = 0; i < PatientRemarks.length; i++) {
                            $('#remarks').append('<option value="' + PatientRemarks[i].Remarks + '">' + PatientRemarks[i].Remarks + '</option>');
                        }
                        $('.chosen-container').css('width', '220px');
                        $("#remarks").trigger('chosen:updated');
                    }
                }
            });

        }
        function BindDropValue(btnl) {
            debugger;
            if (typeof (btnl) == "object") {
                alert("true");
            }
            else {
                alert("false");
            }
        }
        function BindFeedBack(callBy) {
            $modelBlockUI();
            var request = { callType: callBy };
            $.ajax({
                type: "POST",
                url: "FeedBackForm.aspx/GetFeedBackData",
                data: JSON.stringify(request),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    var ResultData = $.parseJSON(result.d);
                    if (ResultData.length > 0) {
                        $modelUnBlockUI();
                        $('#feedbackId').html('');
                        for (var i = 0; i < ResultData.length; i++) {
                            if (ResultData[i].CallType == callBy) {
                                $('#feedbackId').append('<tr>' +
                                    '<td class="fdId" style="display:none;">' + ResultData[i].ID + '</td><td class="QuestionAnswer"><b>' + ResultData[i].Question + '</b></td>' +
                                '</tr>');
                                var TypeName = ResultData[i].TypeName.split("#");
                                var Type = ResultData[i].Type.split("#");
                                var ID = ResultData[i].ID;
                                if (ResultData[i].Category == "radio1") {
                                    $('#feedbackId').append('<table><tr id="bindLeneardata_' + ID + '"></tr></table>');
                                    for (var k = parseInt(Type[0]) ; k <= parseInt(TypeName[0]) ; k++) {
                                        $('#bindLeneardata_' + ID).append('<td><span style="font-weight: bold;margin-left: 9px;">' + k + '</span><br/><input name="' + ResultData[i].ID + '" style="width: 18px;height: 18px;" type="radio" value="' + Type[0] + '-' + TypeName[0] + '/' + k + '" class="fl" /></td');
                                    }
                                }
                                else {
                                    if (Type[0] == "select") {
                                        $('#feedbackId').append('<tr><td><select style="width:180px;height:25px;" name="select" id="fl_' + ID + '" class="fl"><option value="Choose">---Choose---</option></select></td></tr>');
                                    }
                                    for (var j = 0; j < TypeName.length; j++) {
                                        if (Type[j] == "select") {
                                            $('#fl_' + ID).append('<option value="' + ResultData[i].ID + '">' + TypeName[j] + '</option>');
                                        }
                                        else {
                                            $('#feedbackId').append('<tr><td>' +
                                                '<input name="' + ResultData[i].ID + '" style="' + (Type[j] == "text" ? "border-top: darkblue;border-left: darkblue;border-right: darkblue;height: 20px;width: 300px;" : "width: 18px;height: 18px;") + '" type="' + Type[j] + '" value="' + TypeName[j] + '" class="fl" /><span>' + TypeName[j] + '</span></td>' +
                                        '</tr>');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        $modelUnBlockUI();
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function OpneSavePOpup() {
            if (validation() == false) {
                return;
            }
            $("#overlay1").show();
            $("#dialog1").fadeIn(300);
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
        function clearForm() {
            $('#<%=txtName.ClientID%>').val('');
            $('#<%=txtmobile.ClientID%>').val('');
            $('#<%=txtpID.ClientID%>').val('');
            $('#<%=txtEmail.ClientID%>').val('');
            $('#<%=txtdob.ClientID%>').val('');
            $('#<%=txtAdd.ClientID%>').val('');
            $('.fl').val('');
            $('.fl').prop('checked', false);
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
        function savedata() {
        //    debugger;
        //    $("#feedbackId").find('tr td').each(function (rowIndex, e) {
        //        var cols = {};
        //        if ($('input[name=' + $(this).find(".fl").attr('name') + ']:checked').val() != undefined) {
        //            if ($(this).find(".fl").prop("checked") == true) {
        //                // FeedbkName = FeedbkName + $(this).find(".fl").val() + $(this).find(".fl").attr('name');
        //                cols.FeedbkAnswer = $(this).find(".QuestionAnswer").text();
        //                cols.FeedbkName = $(this).find(".fl").val();
        //                cols.FeedbkID = $(this).find(".fl").attr('name');
        //                data.push(cols);
        //            }
        //        }
        //});
        //    return;
            if (validation() == false) {
                return;
            }
            $("#btnupdt").attr('disabled', true).val("Submiting...");
            var data = [];
            var data1 = [];
            var pName = $('#<%=txtName.ClientID%>').val();
            var pMobile = $('#<%=txtmobile.ClientID%>').val();
            var pID = $('#<%=txtpID.ClientID%>').val();
            var pEmail = $('#<%=txtEmail.ClientID%>').val();
            var pDob = $('#<%=txtdob.ClientID%>').val();
            var pAddress = $('#<%=txtAdd.ClientID%>').val();

            $("#feedbackId").find('tr').each(function (rowIndex, e) {
                var cols1 = {};
                cols1.FeedbkAnswer = $(this).find(".QuestionAnswer").text();
                cols1.FeedbkID = $(this).find(".fdId").text();
                if (cols1.FeedbkAnswer && cols1.FeedbkID != "") {
                    data1.push(cols1);
                }
            });
            $("#feedbackId").find('tr td').each(function (rowIndex, e) {
                var cols = {};
                if ($('input[name=' + $(this).find(".fl").attr('name') + ']:checked').val() != undefined) {
                    if ($(this).find(".fl").prop("checked") == true) {
                        // FeedbkName = FeedbkName + $(this).find(".fl").val() + $(this).find(".fl").attr('name');
                        cols.FeedbkAnswer = $(this).find(".QuestionAnswer").text();
                        cols.FeedbkName = $(this).find(".fl").val();
                        cols.FeedbkID = $(this).find(".fl").attr('name');
                        data.push(cols);
                    }
                }
                if ($(this).find(".fl").attr('type') == "text") {
                    cols.FeedbkAnswer = $(this).find(".QuestionAnswer").text();
                    cols.FeedbkName = $(this).find(".fl").val();
                    cols.FeedbkID = $(this).find(".fl").attr('name');
                    data.push(cols);
                }
                if ($(this).find(".fl").attr("name") == "select") {
                    cols.FeedbkAnswer = $(this).find(".QuestionAnswer").text();
                    cols.FeedbkName = $(this).find(".fl :selected").text();
                    cols.FeedbkID = $(this).find(".fl :selected").val();
                    data.push(cols);
                }
            });
            var request = { pName: pName, pMobile: pMobile, pID: pID, pEmail: pEmail, pDob: pDob, pAddress: pAddress, data: data, data1: data1 };
            $.ajax({
                url: "FeedBackForm.aspx/SaveFeedBack",
                data: JSON.stringify(request),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        saveFeedBack();
                        showmsg("Record Saved..!");
                    }
                    if (result.d == "0") {
                        showerrormsg("Feedback not saved");
                    }

                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    //jQuery("#ddlPccCentre").attr("disabled", false);
                }

            });

        }
        function saveFeedBack() {
            var loc = window.location.toString(),
            params = loc.split('?')[1],
            params1 = loc.split('&')[1],
            params2 = loc.split('&')[2],
            params3 = params.split('&')[0],
            params4 = loc.split('&')[3].split("Name:")[1],
            iframe = document.getElementById('estimateiframe');
            var MobileNo = params3;
            var CallBy = params1;
            var CallByID = params2;
            var CallType = "FeedBack";
            var Remarks = $('#remarks').val();
            var centreID = loc.split('&')[5];
            var name = "";
            if (params1 == "PUP" || params1 == "PCC") {
                name = params4.replace(/%20/g, ' ').trim();
            }
            else {
                name = params4.split(".")[1].trim().replace(/%20/g, ' ').trim();
            }
            $("#btnupdt").attr('disabled', true).val("Submiting...");
            $.ajax({
                url: "FeedBackForm.aspx/SaveNewFeedBackLog",
                data: JSON.stringify({ MobileNo: MobileNo, CallBy: CallBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks, Name: name, CentreID: centreID }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Saved..!");
                        $('#btnupdt').attr('disabled', false).val("Save");
                        $("#overlay1").hide();
                        $("#dialog1").fadeOut(300);
                        $('#remarks').val('');
                        $("#remarks").trigger('chosen:updated');
                        // clearForm();
                        alert("Record Saved..!");
                        window.location.reload();
                    }
                    else {
                        showerrormsg(save.split('#')[1]);
                        $('#btnsave').attr('disabled', false).val("Save");
                    }
                }
            });
        }
        function iFrameFeedBack() {
            var loc = window.location.toString(),
            params = loc.split('?')[1],
            params1 = loc.split('&')[1],
            params2 = loc.split('&')[2],
          //  params3 = loc.split('&')[3].split("Name:")[1],
            iframe = document.getElementById('estimateiframe');
            if (params != undefined) {
                var pname = loc.split('&')[3].split("Name:")[1].trim();
                $('#<%=txtName.ClientID%>').val(pname.replace(/%20/g, ' ').trim());//pname.split("%20")[1].trim();
                $('#<%=txtmobile.ClientID%>').val(params.split('&')[0]);
                $('#<%=txtpID.ClientID%>').val(params2);
                $('#ContentPlaceHolder1_txtEmail').val(loc.split('&')[4]);
                if (params1 == "Patient") {
                    BindReport(params2);
                }
                if (params1 == "Doctor" || params1 == "PUP" || params1 == "PCC") {
                    BindReport(params2);
                }
                var callBy = "";
                if (params1 == "Patient") {
                    callBy = "0";
                }
                if (params1 == "Doctor") {
                    callBy = "1";
                }
                if (params1 == "PUP") {
                    callBy = "2";
                }
                if (params1 == "PCC") {
                    callBy = "3";
                }
                BindFeedBack(callBy);
                $('#mastertopcorner').hide();
                $('#masterheaderid').hide();
                //$('#btnopenPopup').show();
            }
            //else {
            //    $('#btnopenPopup').hide();
            //    $('#btnsave').show();
            //    return false;
            //}
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
                    $('#bindreport').html('');
                    if (pdata.length > 0) {
                        for (var i = 0; i < pdata.length; i++) {
                            var si = s++;
                            var mydata = '<tr align="left" style="color:#333333;background-color:White;">' +
				            '<td>' + si + '</td>' +
                            '<td>' + pdata[i].NAME + '</td>' +
                            '<td>' + pdata[i].Mobile + '</td>' +
                            '<td>' + pdata[i].Address + '</td>' +
                            '<td>' + pdata[i].DOB + '</td>' +
                            '<td class="emalid">' + pdata[i].Email + '</td><td  style="display:none;">' +
                            '<input type="image" id="imbprint" onclick="printData(' + pdata[i].ID + ')" title="Remove Item" src="../../App_Images/view.gif">' +
                            '</td><td style="display:none;">' +
                            '<span onclick="SendEmail(this);"><a href="#">SendMail</a></span>' +
                            '</td><td style="display:none;">' +
                            '<input type="button" onclick="DeleteFeedBack(' + pdata[i].OrderID + ')" value="Delete">' +
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
            window.open('../../Design/CallCenter/Viewdata.aspx?id=' + ID + '&type=Feedback');
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
                        alert("FeedBack deleted successfully...!");
                        iFrameFeedBack();
                        //return;
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
    </script>
</asp:Content>

