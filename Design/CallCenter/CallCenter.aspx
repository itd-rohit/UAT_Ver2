<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CallCenter.aspx.cs" Inherits="Design_CallCenter_CallCenter" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('.ms-parent multiselect').css('width', '170px;');
        });
    </script>
    <style type="text/css">
        /* Style the tab */
        div.tab {
            overflow: hidden;
            border: 1px solid #ccc;
            height: 35px;
        }

            /* Style the buttons inside the tab */
            div.tab .tablinks {
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 7px 16px;
                transition: 0.3s;
                font-size: 17px;
            }

                /* Change background color of buttons on hover */
                div.tab .tablinks:hover {
                    background-color: #5258ff;
                    color: white;
                }

                /* Create an active/current tablink class */
                div.tab .tablinks.active {
                    background-color: blue;
                    color: white;
                }

        /* Style the tab content */
        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
            margin-left: -10px;
        }
    </style>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1330px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1320px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td align="center" colspan="8">
                            <asp:Label ID="llheader" runat="server" Text="Customer Care Managment" Font-Size="20px" Font-Bold="true"></asp:Label>
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>

                    </tr>
                    <tr style="color: black;">
                        <td width="30px;">
                            <input type="radio" style="width: 18px; height: 18px;" checked="checked" onclick="searchCategory();" name="callcenterRadio" value="0" />
                        </td>
                        <td width="40px;">
                            <strong style="font-size: 15px;" id="patient">Patient</strong>

                        </td>
                        <td width="40px;" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="searchCategory();" name="callcenterRadio" value="1" />
                        </td>
                        <td width="40px"><strong style="font-size: 15px;">Doctor</strong></td>
                        <td width="40px" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="searchCategory();" name="callcenterRadio" value="2" />
                        </td>
                        <td width="40px;"><strong style="font-size: 15px;">PUP</strong>   </td>
                        <td width="40px;" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="searchCategory();" name="callcenterRadio" value="3" />
                        </td>
                        <td><strong style="font-size: 15px;">PCC</strong>   </td>
                    </tr>
                </table>

            </div>
        </div>

        <div class="div_Patientinfo">
            <div class="POuter_Box_Inventory" style="width: 1320px;">
                <div class="content">
                    <div class="Purchaseheader">
                        Search Option
                    </div>
                    <table style="width: 99%;margin-top:-5px;">
                        <tr style="display: none;" class="doctorbind_25">
                            <td style="width: 70px;">
                                <select id="CategoryFilter" onchange="changetext();">
                                    <option value="Name" selected="selected">Name</option>
                                    <option value="Mobile">Mobile</option>
                                </select>
                            </td>
                            <td>

                                <div class="ui-widget" style="display: inline-block;">
                                    <input type="hidden" id="TermHidden" />
                                    <input id="ddlName" size="30" />
                                    <input type="hidden" id="Doctorid" />
                                    <input type="hidden" id="Centreid" />
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table style="width: 99%;">
                        <tr style="display: none;" class="doctorbind_25">
                            <td class="required"><strong>Zone:</strong>  </td>
                            <td>
                                <asp:DropDownList ID="ddlBusinessZone" runat="server" class="ddlBusinessZone chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="bindState()"></asp:DropDownList></td>
                            <td class="required"><strong>State:</strong>  </td>
                            <td>
                                <asp:DropDownList ID="ddlState1" runat="server" class="ddlState1 chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="BindCity()"></asp:DropDownList></td>
                            <td class="required"><strong>City:</strong>  </td>
                            <td>
                                <asp:ListBox ID="lstCity" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                <%-- <select name="langOpt[]" id="ddlCity1" style="width:170px;" onchange="BindCentre();"></select>--%>
                                <%--<asp:DropDownList ID="" name="langOpt[]" multiple="" runat="server" Width="160px" ClientIDMode="Static" ></asp:DropDownList>--%></td>
                            <td style="color: maroon; text-align: right;" class="centre_24"><b>Centre:</b></td>
                            <td class="centre_24">
                                <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                <%--<asp:DropDownList id="ddlCentreAccess" runat="server" class="ddlCentreAccess chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="Binddoctor();"></asp:DropDownList>--%></td>
                            <td class="doctord_25" style="text-align: right"><b>Ref Doctor</b></td>
                            <td class="doctord_25" style="text-align: left">
                                <asp:DropDownList ID="ddlDoctor" runat="server" class="ddlDoctor chosen-select" TabIndex="11" Width="160px" ClientIDMode="Static" onchange="BindDoctorDetail();"></asp:DropDownList>
                            </td>
                            <td style="display: none;" class="panle_24"><strong>Panel:</strong>  </td>
                            <td style="display: none;" class="panle_24">
                                <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="BindPanelDetail();"></asp:DropDownList></td>
                            <td style="display: none;" class="pcc_24"><strong>PCC:</strong>  </td>
                            <td style="display: none;" class="pcc_24">
                                <asp:DropDownList ID="ddlPccCentre" runat="server" class="ddlPccCentre chosen-select chosen-container" Width="160px" ClientIDMode="Static" onchange="bindPccDetail();"></asp:DropDownList></td>
                        </tr>
                        <tr id="patient_25">
                            <td class="ptMobile_25" style="width: 85px;"><b>Mobile No:</b> </td>
                            <td class="ptMobile_25" style="width: 200px;">
                                <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" MaxLength="10" onkeyup="showlength()" TabIndex="3"></asp:TextBox>
                                <span id="molen" style="font-weight: bold;"></span>
                                <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                                </cc1:FilteredTextBoxExtender>
                            </td>
                            <td class="ptMobile_25" style="width: 60px;"><b>Name:</b> </td>
                             <td class="ptMobile_25" style="width: 185px;"><asp:TextBox ID="txtName" runat="server" TabIndex="3"></asp:TextBox></td>
                            <td class="ptMobile_25" style="width: 85px;"><b>From Date:</b> </td>
                            <td class="ptMobile_25" style="width: 120px;"><asp:TextBox ID="txtFormDate" ReadOnly="true" Width="100px" runat="server" TabIndex="3"></asp:TextBox></td>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                            <td class="ptMobile_25" style="width: 80px;"><b>To Date:</b> </td>
                            <td class="ptMobile_25" style="width: 120px;"><asp:TextBox ID="txtToDate" ReadOnly="true" Width="100px" runat="server" TabIndex="3"></asp:TextBox></td>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                            <td class="ptMobile_25">&nbsp;<input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="bindoldpatient(0);" /></td>
                        </tr>
                    </table>
                    <table style="width: 99%">
                        <tr style="border: 1px solid black">
                            <td style="display: none;"><span id="oldptId"></span></td>
                            <td class="ptMobile_25" id="ptdname" style="font-weight: bold; font-size: 11px; display: none;">Name: <span style="color: maroon;" id="PatientName"></span></td>
                            <td class="ptMobile_25" id="dtDoctorID" style="font-weight: bold; font-size: 11px; display: none;">ID: <span style="color: maroon;" id="DoctorID"></span></td>
                            <td class="ptMobile_25" id="dtDoctorCode" style="font-weight: bold; font-size: 11px; display: none;">Code: <span style="color: maroon;" id="DoctorCode"></span></td>
                            <td class="ptMobile_25" id="ptdmobile" style="font-weight: bold; font-size: 11px; display: none;">Mobile: <span style="color: maroon;" id="Patientmobile"></span></td>
                            <td class="ptMobile_25" id="dtSpecialization" style="font-weight: bold; font-size: 11px; display: none;">Specialization: <span style="color: maroon;" id="Specialization"></span></td>
                            <td class="ptMobile_25" id="dtDegree" style="font-weight: bold; font-size: 11px; display: none;">Degree: <span style="color: maroon;" id="Degree"></span></td>
                            <td class="ptMobile_25" id="ptdlastCall" style="font-weight: bold; font-size: 11px; display: none;">Last Call: <span style="color: maroon;" id="PatientLastCall"></span></td>
                            <td class="ptMobile_25" id="ptdCallType" style="font-weight: bold; font-size: 11px; display: none;">Reason Of Call: <span style="color: maroon;" id="PatientCallType"></span></td>
                            <td class="ptMobile_25" id="ptdEmail" style="font-weight: bold; font-size: 11px; display: none;">Email:<span id="EmailId"></span></td>
                            <td class="ptMobile_25" id="ptdCallDetail" style="font-weight: bold; font-size: 11px; display: none;"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="div_Patientinfo">
            <div class="POuter_Box_Inventory" style="width: 1320px;">
                <div class="tab" style="background-color: #00FFFF;">
                    <input class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Lab Report" onclick="openTab(event, 'LabReport')" />
                    <input id="HomeCollection_25" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Home Collection" onclick="openTab(event, 'HomeCollection')" />
                    <input class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Estimate" onclick="openTab(event, 'Estimate')" />
                    <input class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Feed Back" onclick="openTab(event, 'FeedBack')" />
                    <input class="tablinks" style="font-weight: bold; display: none;" type="button" value="Ticket" onclick="openTab(event, 'Ticket')" />
                </div>
                <div id="LabReport" class="tabcontent">
                </div>

                <div id="HomeCollection" class="tabcontent">
                </div>
                <div id="Estimate" class="tabcontent">
                </div>
                <div id="FeedBack" class="tabcontent">
                </div>
                <div id="Ticket" class="tabcontent">
                    <h3>Ticket</h3>
                </div>
            </div>
        </div>
        <%--    <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div id="estimatediv"></div>
        </div>--%>
    </div>
    <asp:Panel ID="panelold" runat="server" Style="display: none; z-index: 100002;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Old Patient
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr id="myheader" style="text-align: left;">
                        <td class="GridViewHeaderStyle">Select</td>
                        <td class="GridViewHeaderStyle">UHID</td>
                        <td class="GridViewHeaderStyle">Patient Name</td>
                        <td class="GridViewHeaderStyle">Age</td>
                        <td class="GridViewHeaderStyle">DOB</td>
                        <td class="GridViewHeaderStyle">Gender</td>
                        <td class="GridViewHeaderStyle">Mobile</td>
                        <td class="GridViewHeaderStyle">Area</td>
                        <td class="GridViewHeaderStyle">City</td>
                        <td class="GridViewHeaderStyle">State</td>
                        <td class="GridViewHeaderStyle">Reg Date</td>

                    </tr>
                </table>
                <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />

    <asp:Panel ID="panel2" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                New Patient
            </div>
            <div class="content" style="text-align: center;">
                <table width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left; font-weight: bold;">
                        <td>Name</td>
                        <td>
                            <asp:DropDownList ID="ddltitle" runat="server" Width="50px" onchange="AutoGender()" TabIndex="4"></asp:DropDownList>
                            <asp:TextBox ID="txtpatientname" class="checkSpecialCharater" runat="server" Width="200px" Style="text-transform: uppercase;" TabIndex="5"></asp:TextBox></td>
                    </tr>
                    <tr style="text-align: left;">
                        <td class="required"><b>Age:</b>
                            <asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setdobop1(this)" GroupName="rdDOB" /></td>
                        <td>
                            <asp:TextBox ID="txtAge" runat="server" onkeyup="getdob()" CssClass="ItDoseTextinputText" Width="50px" MaxLength="3" TabIndex="6" placeholder="Years" />
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender6" runat="server" FilterType="Numbers" TargetControlID="txtAge">
                            </cc1:FilteredTextBoxExtender>
                            <asp:TextBox ID="txtAge1" runat="server" onkeyup="getdob()" CssClass="ItDoseTextinputText" Width="50px" MaxLength="2" TabIndex="7" placeholder="Months" />
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender7" runat="server" FilterType="Numbers" TargetControlID="txtAge1">
                            </cc1:FilteredTextBoxExtender>
                            <asp:TextBox ID="txtAge2" runat="server" onkeyup="getdob()" CssClass="ItDoseTextinputText" Width="50px" MaxLength="2" TabIndex="8" placeholder="Days" />
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender8" runat="server" FilterType="Numbers" TargetControlID="txtAge2">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr style="text-align: left;">
                        <td><b>DOB:</b>
                            <asp:RadioButton ID="rdDOB" runat="server" GroupName="rdDOB" onclick="setdobop(this)" /></td>
                        <td>
                            <asp:TextBox ID="txtdob" runat="server" Width="126px" Enabled="false"></asp:TextBox></td>
                    </tr>

                    <tr style="text-align: left;">
                        <td class="required"><b>Gender:</b></td>
                        <td>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="ItDoseDropdownbox" onchange="resetitem();" Width="120px">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                                <asp:ListItem Value=""></asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr class="Purchaseheader">
                        <td colspan="2">Address</td>
                    </tr>
                    <tr style="text-align: left;">
                        <td>State</td>
                        <td>
                            <asp:DropDownList ID="ddlstate" runat="server" Width="120px" onchange="bindCity(0)"></asp:DropDownList></td>
                    </tr>
                    <tr style="text-align: left;">
                        <td>City</td>
                        <td>
                            <asp:DropDownList ID="ddlcity" runat="server" Width="130px" onchange="bindLocality()"></asp:DropDownList></td>
                    </tr>
                    <tr style="text-align: left;">
                        <td>Area</td>
                        <td>
                            <asp:DropDownList ID="ddlarea" runat="server" Width="173px" TabIndex="11"></asp:DropDownList></td>
                    </tr>
                </table>
                <input type="button" id="btnsave" value="Save" onclick="savedata()" tabindex="21" class="savebutton" style="display: none;" />
                <asp:Button ID="Button2" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient1" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panel2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel3" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                <span style="float: left;">Call Details</span><span style="font-weight: bold; margin-left: 33px;">Name:&nbsp&nbsp<span style="color: black;" id="ptName"></span></span>&nbsp&nbsp<span style="font-weight: bold;">Mobile:&nbsp&nbsp<span style="color: black;" id="ptMobile"></span></span>&nbsp&nbsp<span style="font-weight: bold;">Call By:&nbsp&nbsp<span style="color: black;" id="ptCallBy"></span></span>&nbsp&nbsp<span style="font-weight: bold;">Call By ID:&nbsp&nbsp<span style="color: black;" id="ptCallByID"></span></span>
            </div>
            <div class="content" style="text-align: center;">
                <table id="oldpatienttableCall" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr id="Tr1" style="text-align: left;">
                        <td class="GridViewHeaderStyle">Call Date</td>
                        <td class="GridViewHeaderStyle">Reason Of Call</td>
                        <td class="GridViewHeaderStyle">Attendent</td>
                        <td class="GridViewHeaderStyle">Remarks</td>
                    </tr>
                    <tbody id="oldpatienttableCalltb">
                    </tbody>
                </table>
                <input type="button" runat="server" onclick="closeCallDetails();" class="resetbutton" value="close" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient3" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panel3">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panelsave" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Save
            </div>
            <div class="content" style="text-align: center;">
                <table id="Table1" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                    <tr style="text-align: left;">
                        <td style="font-weight: bold;">Remarks</td>
                        <td>
                            <textarea id="remarks"></textarea></td>
                    </tr>
                </table>
                <input type="button" id="Button3" value="Save" onclick="SaveReportCallLog()" tabindex="21" class="savebutton" />
                <asp:Button ID="Button4" Style="display: none;" runat="server" Text="Close" CssClass="resetbutton" />

            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelopdpatient4" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelsave">
    </cc1:ModalPopupExtender>
    <script type="text/javascript">
        $(function () {
            AutoGender();
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
            $('.chosen-container').css('width', '170px');
            $("#ContentPlaceHolder1_txtdob").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    var dob = new Date(value);
                    getAge(dob, today);
                }
            });
            $("#<%= txtmobile.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);

                   if (key == 13) {

                       e.preventDefault();
                       if (jQuery("#oldpatienttable tr:not(#myheader)").length == 0) {
                           if ($("#<%= txtmobile.ClientID%>").val().length == 10) {
                               bindoldpatient(0);
                           }
                           else {
                               showerrormsg("Please Enter Valid Mobile No.");
                               $("#<%= txtmobile.ClientID%>").focus();
                           }
                       }
                   }
                   else if (key == 9) {
                       if (jQuery("#oldpatienttable tr:not(#myheader)").length == 0) {
                           if (chkInvalidContactNo() == "0") {
                               bindoldpatient(0);

                           }
                           else
                               $("#<%= txtmobile.ClientID%>").focus();
                       }
                   }
               });
        });

       function AutoGender() {
           var ddltitle = $('#<%=ddltitle.ClientID%>').val();
           var Gender = $('#<%=ddlGender.ClientID%>').val();
           if (ddltitle == "Mr." || ddltitle == "Master." || ddltitle == "Baba.")
               $('#<%=ddlGender.ClientID%>').val("Male").attr('disabled', 'disabled');
           else if (ddltitle == "Mrs." || ddltitle == "Miss." || ddltitle == "Ms." || ddltitle == "Smt." || ddltitle == "Baby.")
               $('#<%=ddlGender.ClientID%>').val("Female").attr('disabled', 'disabled');
           else if (ddltitle == "Dr." || ddltitle == "B/O" || ddltitle == "C/O")
               $('#<%=ddlGender.ClientID%>').val("").removeAttr('disabled');
           else
               $('#<%=ddlGender.ClientID%>').val("Male").removeAttr('disabled');

    if (Gender != $('#<%=ddlGender.ClientID%>').val()) {
               // resetitem();
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
       function getAge(birthDate, ageAtDate) {
           var daysInMonth = 30.436875; // Days in a month on average.
           var dob = new Date(birthDate);
           var aad;
           if (!ageAtDate) aad = new Date();
           else aad = new Date(ageAtDate);
           var yearAad = aad.getFullYear();
           var yearDob = dob.getFullYear();
           var years = yearAad - yearDob; // Get age in years.
           dob.setFullYear(yearAad); // Set birthday for this year.
           var aadMillis = aad.getTime();
           var dobMillis = dob.getTime();
           if (aadMillis < dobMillis) {
               --years;
               dob.setFullYear(yearAad - 1); // Set to previous year's birthday
               dobMillis = dob.getTime();
           }
           var days = (aadMillis - dobMillis) / 86400000;
           var monthsDec = days / daysInMonth; // Months with remainder.
           var months = Math.floor(monthsDec); // Remove fraction from month.
           days = Math.floor(daysInMonth * (monthsDec - months));
           $('#<%=txtAge.ClientID%>').val(years);
           $('#<%=txtAge1.ClientID%>').val(months);
           $('#<%=txtAge2.ClientID%>').val(days);

       }
       function showerrormsg(msg) {
           $('#msgField').html('');
           $('#msgField').append(msg);
           $(".alert").css('background-color', 'red');
           $(".alert").removeClass("in").show();
           $(".alert").delay(1500).addClass("in").fadeOut(1000);
       }
       function showmsg(msg) {
           $('#msgField').html('');
           $('#msgField').append(msg);
           $(".alert").css('background-color', '#04b076');
           $(".alert").removeClass("in").show();
           $(".alert").delay(1500).addClass("in").fadeOut(1000);
       }
       function bindoldpatient(type) {
        
           var searchdata = CreateOldPatientFilter();
           $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
           $.ajax({
               url: "../CallCenter/Services/OldPatientData.asmx/BindOldPatient",
               data: JSON.stringify({ searchdata: searchdata, Name: $('#ContentPlaceHolder1_txtName').val(), Fromdate: $('#ContentPlaceHolder1_txtFormDate').val(), ToDate: $('#ContentPlaceHolder1_txtToDate').val() }),
               type: "POST", // data has to be Posted    	        
               contentType: "application/json; charset=utf-8",
               timeout: 120000,
               dataType: "json",
               success: function (result) {
                   OLDPatientData = $.parseJSON(result.d);
                   if (OLDPatientData.length == 0) {
                       showerrormsg("No Patient Found..!");
                       $("#btnSearch").removeAttr('disabled').val('Search');
                       $find("<%=modelopdpatient1.ClientID%>").show();
                       $('#btnsave').show();

                       // return;
                   }
                   else {
                       $('.tabcontent').html('');
                       $('#btnsave').hide();
                       for (var i = 0; i <= OLDPatientData.length - 1; i++) {
                           var mydata = "<tr id='" + OLDPatientData[i].patient_id + "' style='text-align:left;'>";
                           mydata += '<td><input type="button" value="Select" onclick="showoldpatientdata(this,\'' + type + '\');" class="savebutton" /></td>';
                           mydata += '<td id="oldpatientid">' + OLDPatientData[i].patient_id + '</td>';
                           mydata += '<td>' + OLDPatientData[i].title + " " + OLDPatientData[i].pname + ' </td>';
                           mydata += '<td>' + OLDPatientData[i].age + '</td>';
                           mydata += '<td id="olddob">' + OLDPatientData[i].dob + '</td>';
                           mydata += '<td id="oldgender">' + OLDPatientData[i].gender + '</td>';
                           mydata += '<td id="oldmobile">' + OLDPatientData[i].mobile + '</td>';
                           mydata += '<td id="oldLocality" >' + OLDPatientData[i].Locality + '</td>';
                           mydata += '<td id="oldLocalityID" style="display:none">' + OLDPatientData[i].localityID + '</td>';
                           mydata += '<td id="oldCity" >' + OLDPatientData[i].City + '</td>';
                           mydata += '<td id="oldCityID" style="display:none">' + OLDPatientData[i].cityID + '</td>';
                           mydata += '<td id="oldState" >' + OLDPatientData[i].State + '</td>';
                           mydata += '<td id="oldStateID" style="display:none">' + OLDPatientData[i].stateID + '</td>';
                           mydata += '<td>' + OLDPatientData[i].visitdate + '</td>';
                           mydata += '<td id="oldtitle"     style="display:none;">' + OLDPatientData[i].title + '</td>';
                           mydata += '<td id="oldname"      style="display:none;">' + OLDPatientData[i].pname + '</td>';
                           mydata += '<td id="oldpincode"   style="display:none;">' + OLDPatientData[i].pincode + '</td>';
                           mydata += '<td id="oldhouseno"   style="display:none;">' + OLDPatientData[i].house_no + '</td>';
                           mydata += '<td id="oldageyear"   style="display:none;">' + OLDPatientData[i].ageyear + '</td>';
                           mydata += '<td id="oldagemonth"  style="display:none;">' + OLDPatientData[i].agemonth + '</td>';
                           mydata += '<td id="oldageday"    style="display:none;">' + OLDPatientData[i].agedays + '</td>';
                           mydata += '<td id="oldemail"     style="display:none;">' + OLDPatientData[i].email + '</td>';
                           mydata += '<td id="oldlastcall"  style="display:none;">' + OLDPatientData[i].lastcall + '</td>';
                           mydata += '<td id="oldcalltype"  style="display:none;">' + OLDPatientData[i].calltype + '</td>';
                           mydata += '<td id="oldEmail"  style="display:none;">' + OLDPatientData[i].email + '</td>';
                           mydata += '</tr>';
                           if (type == "0") {
                               $('#oldpatienttable').append(mydata);
                               $find("<%=modelopdpatient.ClientID%>").show();
                           }

                       }
                   }
                   $("#btnSearch").removeAttr('disabled').val('Search');
                   $('#ptdname').hide();
                   $('#ptdmobile').hide();
                   $('#ptddob').hide();
                   $('#ptdlastCall').hide();
                   $('#ptdCallType').hide();
                   $('#ptdCallDetail').hide();
               },
               error: function (xhr, status) {
                   // alert('Error!!!');
                   window.status = status + "\r\n" + xhr.responseText;
               }
           });
       }
       function CreateOldPatientFilter() {

           var oldfilter = new Array();
           oldfilter[0] = $('#<%=txtmobile.ClientID%>').val();
           return oldfilter;
       }
       function clearOldpatient() {
           jQuery("#oldpatienttable tr:not(#myheader)").remove();
       }
       function searchCategory() {
           $('.tabcontent').html('');
           $('#ddlBusinessZone').val('0').trigger('chosen:updated');
           jQuery("#ddlState1").html('');
           $("#ddlState1").trigger('chosen:updated');
           jQuery('#lstCity option').remove();
           jQuery('#lstCity').multipleSelect("refresh");
           jQuery('#lstCentre option').remove();
           jQuery('#lstCentre').multipleSelect("refresh");
           jQuery("#ddlDoctor option").remove();
           jQuery("#ddlDoctor").html('').trigger('chosen:updated');
           jQuery("#ddlPanel option").remove();
           jQuery("#ddlPanel").html('').trigger('chosen:updated');
           jQuery("#ddlPccCentre option").remove();
           jQuery("#ddlPccCentre").html('').trigger('chosen:updated');
           $('#CategoryFilter').val("Name");
           $('#ddlName').val("");
           $('#Doctorid').val("");
           $('#Centreid').val("");
           var radioselect = $('input[name=callcenterRadio]:checked').val();
           if (radioselect == "0") {
               $('.ptMobile_25').show();
               $('#ptdEmail').hide();
               $('#HomeCollection_25').show();
               $('.doctorbind_25').hide();
               $('#oldptId').text('');
               $('#PatientName').text('');
               $('#Patientmobile').text('');
               $('#PatientLastCall').text('');
               $('#PatientCallType').text('');
               $('#DoctorID').text('');
               $('#DoctorCode').text('');
               $('#Specialization').text('');
               $('#Degree').text('');
               $('#dtDoctorID').hide('');
               $('#dtDoctorCode').hide('');
               $('#dtSpecialization').hide('');
               $('#dtDegree').hide('');
           }
           if (radioselect == "1") {
               $('.ptMobile_25').hide();
               $('#HomeCollection_25').hide();
               $('#oldptId').text('');
               $('#PatientName').text('');
               $('#Patientmobile').text('');
               $('#PatientLastCall').text('');
               $('#PatientCallType').text('');
               $('.doctorbind_25').show();
               $('.doctord_25').show();
               $('.panle_24').hide();
               $('.centre_24').show();
               $('.pcc_24').hide();
           }
           if (radioselect == "2") {
               $('.ptMobile_25').hide();
               $('#HomeCollection_25').hide();
               $('#oldptId').text('');
               $('#PatientName').text('');
               $('#Patientmobile').text('');
               $('#PatientLastCall').text('');
               $('#PatientCallType').text('');
               $('.doctorbind_25').show();
               $('.doctord_25').hide();
               $('.panle_24').show();
               $('.centre_24').show();
               $('.pcc_24').hide();
           }
           if (radioselect == "3") {
               $('.ptMobile_25').hide();
               $('#HomeCollection_25').hide();
               $('#oldptId').text('');
               $('#PatientName').text('');
               $('#Patientmobile').text('');
               $('#PatientLastCall').text('');
               $('#PatientCallType').text('');
               $('.doctorbind_25').show();
               $('.doctord_25').hide();
               $('.panle_24').hide();
               $('.centre_24').hide();
               $('.pcc_24').show();
           }
       }
       function setdobop(ctrl) {
           if ($(ctrl).is(':checked')) {
               $('#<%=txtdob.ClientID%>').attr("disabled", false);
               $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", true);
           }
       }
       function setdobop1(ctrl) {
           if ($(ctrl).is(':checked')) {
               $('#<%=txtdob.ClientID%>').attr("disabled", true);
               $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", false);
           }
       }
       function getdob() {
           var age = "";
           var ageyear = "0";
           var agemonth = "0";
           var ageday = "0";
           if ($('#<%=txtAge.ClientID%>').val() != "") {
               if ($('#<%=txtAge.ClientID%>').val() > 110) {
                   showerrormsg("Please Enter Valid Age in Years");
                   $('#<%=txtAge.ClientID%>').val('');
               }
               ageyear = $('#<%=txtAge.ClientID%>').val();
           }
           if ($('#<%=txtAge1.ClientID%>').val() != "") {
               if ($('#<%=txtAge1.ClientID%>').val() > 12) {
                   showerrormsg("Please Enter Valid Age in Months");
                   $('#<%=txtAge1.ClientID%>').val('');
               }
               agemonth = $('#<%=txtAge1.ClientID%>').val();

           }
           if ($('#<%=txtAge2.ClientID%>').val() != "") {
               if ($('#<%=txtAge2.ClientID%>').val() > 30) {
                   showerrormsg("Please Enter Valid Age in Days");
                   $('#<%=txtAge2.ClientID%>').val('');
               }
               ageday = $('#<%=txtAge2.ClientID%>').val();

           }


           var d = new Date(); // today!
           if (ageday != "")
               d.setDate(d.getDate() - ageday);
           if (agemonth != "")
               d.setMonth(d.getMonth() - agemonth);
           if (ageyear != "")
               d.setFullYear(d.getFullYear() - ageyear);


           var m_names = new Array("Jan", "Feb", "Mar",
   "Apr", "May", "Jun", "Jul", "Aug", "Sep",
   "Oct", "Nov", "Dec");



           var yyyy = d.getFullYear();
           var MM = d.getMonth();
           var dd = d.getDate();


           var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
           $('#ContentPlaceHolder1_txtdob').val(xxx);


       }
       function minTwoDigits(n) {
           return (n < 10 ? '0' : '') + n;
       }
       function bindCity(con) {
           jQuery('#<%=ddlcity.ClientID%> option').remove();
           jQuery('#<%=ddlarea.ClientID%> option').remove();
           jQuery.ajax({
               url: "../Common/Services/CommonServices.asmx/bindCity",
               data: '{ StateID: "' + jQuery('#<%=ddlstate.ClientID%>').val() + '"}',
                   type: "POST",
                   timeout: 120000,
                   async: false,
                   contentType: "application/json; charset=utf-8",
                   dataType: "json",
                   success: function (result) {
                       cityData = jQuery.parseJSON(result.d);
                       if (cityData.length == 0) {
                           jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                       }
                       else {
                           for (i = 0; i < cityData.length; i++) {
                               jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                         }
                         if (con == "0")
                             bindLocality();
                     }
                   },
                   error: function (xhr, status) {
                       alert("Error ");
                       jQuery('#<%=ddlcity.ClientID%>').attr("disabled", false);
                   }
               });
           }
           function bindLocality() {
               jQuery('#<%=ddlarea.ClientID%> option').remove();
             jQuery.ajax({
                 url: "../Common/Services/CommonServices.asmx/bindLocalityByCity",
                 data: '{CityID: "' + jQuery('#<%=ddlcity.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    localityData = jQuery.parseJSON(result.d);
                    if (localityData.length == 0) {
                        jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery('#<%=ddlarea.ClientID%>').attr("disabled", false);
                }

            });
        }
        function savedata() {
            if (validation() == false) {
                return;
            }
            $("#btnsave").attr('disabled', true).val("Submiting...");
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtAge.ClientID%>').val() != "") {
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
                agemonth = $('#<%=txtAge1.ClientID%>').val();
            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
                ageday = $('#<%=txtAge2.ClientID%>').val();
          }
          age = ageyear + " Y " + agemonth + " M " + ageday + " D ";

          var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);

          var Mobile = $('#<%=txtmobile.ClientID%>').val();
          var Title = $('#<%=ddltitle.ClientID%>').val();
            var Name = $('#<%=txtpatientname.ClientID%>').val();
            var Age = age;
            var AgeYear = ageyear;
            var AgeMonth = agemonth;
            var AgeDays = ageday;
            var TotalAgeInDays = ageindays;
            var DOB = $('#<%=txtdob.ClientID%>').val();
            var Gender = $("#<%=ddlGender.ClientID%> option:selected").text();
            var State = $("#<%=ddlstate.ClientID%> option:selected").text();
            var City = $("#<%=ddlcity.ClientID%> option:selected").text();
            var Locality = $('#<%=ddlarea.ClientID%> option:selected').text();
            var StateID = $('#<%=ddlstate.ClientID%>').val();
            var CityID = $('#<%=ddlcity.ClientID%>').val();
            var localityid = $('#<%=ddlarea.ClientID%>').val();
            $.ajax({
                url: "CallCenter.aspx/SaveNewPatient",
                data: JSON.stringify({ Mobile: Mobile, Title: Title, Name: Name, Age: Age, AgeYear: AgeYear, AgeMonth: AgeMonth, AgeDays: AgeDays, TotalAgeInDays: TotalAgeInDays, DOB: DOB, Gender: Gender, State: State, City: City, Locality: Locality, StateID: StateID, CityID: CityID, localityid: localityid }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Saved..!");
                        $find("<%=modelopdpatient1.ClientID%>").hide();
                        $('#<%=txtpatientname.ClientID%>').val('');
                        $('#<%=txtAge.ClientID%>').val('');
                        $('#<%=txtAge1.ClientID%>').val('');
                        $('#<%=txtAge2.ClientID%>').val('');
                        $('#<%=txtdob.ClientID%>').val('');
                        bindoldpatient(0);
                        $('#<%=ddlstate.ClientID%>').val(2);
                      $('#<%=ddlcity.ClientID%>').val('');
                        $('#<%=ddlarea.ClientID%>').val('');
                    }
                    if (result.d == "0") {
                        showerrormsg("Record Not Saved..!");
                    }
                    $('#btnsave').attr('disabled', false).val("Save");
                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                    $('#btnsave').attr('disabled', false).val("Save");
                    console.log(xhr.responseText);
                }
            });
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
            if ($('#<%=txtpatientname.ClientID%>').val().trim().length == 0) {
              showerrormsg("Please Enter Patient Name");
              $('#<%=txtpatientname.ClientID%>').focus();
              return false;
          }
          var ageyear = "0";
          var agemonth = "0";
          var ageday = "0";
          if ($('#<%=txtAge.ClientID%>').val() != "") {
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
              agemonth = $('#<%=txtAge1.ClientID%>').val();
            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
              ageday = $('#<%=txtAge2.ClientID%>').val();
            }
            if (ageyear == 0 && agemonth == 0 && ageday == 0) {
                showerrormsg("Please Enter Patient Age");
                $('#<%=txtAge.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlGender.ClientID%>').val() == "") {
              showerrormsg("Please Select Patient Gender");
              $('#<%=ddlGender.ClientID%>').focus();
              return false;
          }

          return true;
      }
      function openTab(evt, tabName) {
          var i, tabcontent, tablinks;
          tabcontent = document.getElementsByClassName("tabcontent");
          for (i = 0; i < tabcontent.length; i++) {
              tabcontent[i].style.display = "none";
          }
          tablinks = document.getElementsByClassName("tablinks");
          for (i = 0; i < tablinks.length; i++) {
              tablinks[i].className = tablinks[i].className.replace(" active", "");
          }
          if (tabName == "LabReport") {
              var radioselect = $('input[name=callcenterRadio]:checked').val();
              if (radioselect == "0") {
                  if ($('#Patientmobile').text() == "") {
                      showerrormsg("Please Select Patient");
                      return;
                  }
              }
              if (radioselect == "1") {
                  if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                      showerrormsg("Please Select Doctor");
                      return;
                  }
              }
              if (radioselect == "2") {
                  if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                      showerrormsg("Please Select Panel");
                      return;
                  }
              }
              if (radioselect == "3") {
                  if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                      showerrormsg("Please Select PCC");
                      return;
                  }
              }
              var callBy = "";
              if (radioselect == "0") {
                  callBy = "Patient";
              }
              if (radioselect == "1") {
                  callBy = "Doctor";
              }
              if (radioselect == "2") {
                  callBy = "PUP";
              }
              if (radioselect == "3") {
                  callBy = "PCC";
              }
              var callById = $("#oldptId").text();
              var PName = $("#ptdname").text();
              $('#LabReport').html('');
              $('#LabReport').append('<iframe id="LabReportiframe" src="../../Design/Lab/DeltaCheckMobile.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '""  style="width: 1325px;height:400px;"></iframe>');
              document.getElementById(tabName).style.display = "block";
              evt.currentTarget.className += " active";
          }
          if (tabName == "HomeCollection") {
              if ($('#Patientmobile').text() == "") {
                  showerrormsg("Please Select Patient");
                  return;
              }
              var radioselect = $('input[name=callcenterRadio]:checked').val();
              var callBy = "";
              if (radioselect == "0") {
                  callBy = "Patient";
              }
              if (radioselect == "1") {
                  callBy = "Doctor";
              }
              if (radioselect == "2") {
                  callBy = "PUP";
              }
              if (radioselect == "3") {
                  callBy = "PCC";
              }
              var callById = $("#oldptId").text();
              var PName = $("#ptdname").text();
              var pEmail = $('#EmailId').text();
              $('#HomeCollection').html('');
              $('#HomeCollection').append('<iframe id="LabReportiframe" src="../../Design/Appointment/HomeCollectionNew.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '&' + pEmail + '""  style="width: 1325px;height:650px;"></iframe>');
              document.getElementById(tabName).style.display = "block";
              evt.currentTarget.className += " active";
          }
          if (tabName == "Estimate") {
           
              var radioselect = $('input[name=callcenterRadio]:checked').val();
              if (radioselect == "0") {
                  if ($('#Patientmobile').text() == "") {
                      showerrormsg("Please Select Patient");
                      return;
                  }
              }
              if (radioselect == "1") {
                  if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                      showerrormsg("Please Select Doctor");
                      return;
                  }
              }
              if (radioselect == "2") {
                  if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                      showerrormsg("Please Select Panel");
                      return;
                  }
              }
              if (radioselect == "3") {
                  if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                      showerrormsg("Please Select PCC");
                      return;
                  }
              }
              var callBy = "";
              if (radioselect == "0") {
                  callBy = "Patient";
              }
              if (radioselect == "1") {
                  callBy = "Doctor";
              }
              if (radioselect == "2") {
                  callBy = "PUP";
              }
              if (radioselect == "3") {
                  callBy = "PCC";
              }
              var callById = $("#oldptId").text();
              var PName = $("#ptdname").text();
              $('#Estimate').html('');
              $('#Estimate').append('<iframe id="estimateiframe" src="../../Design/master/EstimateRate.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '"  style="width: 1325px;height:400px;"></iframe>');
              document.getElementById(tabName).style.display = "block";
              evt.currentTarget.className += " active";
          }
          if (tabName == "FeedBack") {
              var radioselect = $('input[name=callcenterRadio]:checked').val();
              if (radioselect == "0") {
                  if ($('#Patientmobile').text() == "") {
                      showerrormsg("Please Select Patient");
                      return;
                  }
              }
              if (radioselect == "1") {
                  if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                      showerrormsg("Please Select Doctor");
                      return;
                  }
              }
              if (radioselect == "2") {
                  if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                      showerrormsg("Please Select Panel");
                      return;
                  }
              }
              if (radioselect == "3") {
                  if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                      showerrormsg("Please Select PCC");
                      return;
                  }
              }
              var callBy = "";
              if (radioselect == "0") {
                  callBy = "Patient";
              }
              if (radioselect == "1") {
                  callBy = "Doctor";
              }
              if (radioselect == "2") {
                  callBy = "PUP";
              }
              if (radioselect == "3") {
                  callBy = "PCC";
              }
              var callById = $("#oldptId").text();
              var PName = $("#ptdname").text();
              var pEmail = $('#EmailId').text();
              var centreID = $('#lstCentre').val();
              $('#FeedBack').html('');
              $('#FeedBack').append('<iframe id="estimateiframe" src="../../Design/CallCenter/FeedbackForm.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '&' + pEmail + '&' + centreID + '"  style="width: 1325px;height:400px;"></iframe>');
              document.getElementById(tabName).style.display = "block";
              evt.currentTarget.className += " active";
          }
          if (tabName == "Ticket") {
              document.getElementById(tabName).style.display = "block";
              evt.currentTarget.className += " active";
          }
      }
      function showoldpatientdata(ctrl, type) {
          $('#<%=rdAge.ClientID%>').prop("checked", true);
            $('#<%=txtAge.ClientID%>').attr("disabled", false);
            $('#<%=txtAge1.ClientID%>').attr("disabled", false);
            $('#<%=txtAge2.ClientID%>').attr("disabled", false);
            $('#<%=txtdob.ClientID%>').attr("disabled", true);
            $('#<%=txtName.ClientID%>').val('');
            $('#<%=txtmobile.ClientID%>').val('');
            $('#ContentPlaceHolder1_txtFormDate').val('');
            $('#ContentPlaceHolder1_txtToDate').val('');
            $("#oldptId").text($(ctrl).closest('tr').find('#oldpatientid').text());
            $('#ptdname').show();
            $("#PatientName").text($(ctrl).closest('tr').find('#oldtitle').text() + "" + $(ctrl).closest('tr').find('#oldname').text().toUpperCase());
            $('#ptdmobile').show();
            $("#Patientmobile").text($(ctrl).closest('tr').find('#oldmobile').text());
            //$('#ptddob').show();
            //$("#Patientdob").text($(ctrl).closest('tr').find('#olddob').text());
            $('#ptdlastCall').show();
            var oldlastcall = "";
            if ($(ctrl).closest('tr').find('#oldlastcall').text() == "null") {
                oldlastcall == "";
            }
            else {
                oldlastcall = $(ctrl).closest('tr').find('#oldlastcall').text();
            }
            $("#PatientLastCall").text(oldlastcall);
            $('#ptdCallType').show();
            var oldcalltype = "";
            if ($(ctrl).closest('tr').find('#oldcalltype').text() == "null") {
                oldcalltype = "";
            }
            else {
                oldcalltype = $(ctrl).closest('tr').find('#oldcalltype').text();
            }
            $("#PatientCallType").text(oldcalltype);
            $("#EmailId").text($(ctrl).closest('tr').find('#oldEmail').text());
            $('#ptdCallDetail').html('');
            $('#ptdCallDetail').show();
            $('#ptdCallDetail').append('<span style="cursor:pointer;color:red;" onclick="ShowCallDetails();">Call Details</span>');
            if (type == "0") {
                $find("<%=modelopdpatient.ClientID%>").hide();
            }
            else {
                $('#oldpatienttable1 tr').slice(1).remove();
                hideshow1();
            }
            jQuery("#oldpatienttable tr:not(#myheader)").remove();
        }
        function hideshow1() {
            $('.div_Patientinfo').slideToggle("slow", "linear");
            $('#searchdiv').hide();

        }
        function ShowCallDetails() {
            var ID = $("#oldptId").text();
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            if (radioselect == "0") {
                callBy = "Patient";
            }
            if (radioselect == "1") {
                callBy = "Doctor";
            }
            if (radioselect == "2") {
                callBy = "PUP";
            }
            if (radioselect == "3") {
                callBy = "PCC";
            }
            $.ajax({
                url: "../CallCenter/Services/OldPatientData.asmx/CallDetails",
                data: JSON.stringify({ CallBy: callBy, ID: ID }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    OLDPatientData = $.parseJSON(result.d);
                    if (OLDPatientData.length > 0) {
                        $('#oldpatienttableCalltb').html('');
                        $('#ptName').text($('#PatientName').text());
                        $('#ptMobile').text(OLDPatientData[0].Mobile);
                        $('#ptCallBy').text(OLDPatientData[0].Call_By);
                        $('#ptCallByID').text(OLDPatientData[0].Call_By_ID);
                        for (var i = 0; i <= OLDPatientData.length - 1; i++) {
                            var mydata = "<tr id='" + OLDPatientData[i].ID + "' style='text-align:left;'>";
                            mydata += '<td>' + OLDPatientData[i].dtEntry + '</td>';
                            mydata += '<td>' + OLDPatientData[i].Call_Type + '</td>';
                            mydata += '<td>' + OLDPatientData[i].UserName + '</td>';
                            mydata += '<td>' + OLDPatientData[i].Remarks + '</td>';
                            mydata += '</tr>';
                            $('#oldpatienttableCalltb').append(mydata);
                            $find("<%=modelopdpatient3.ClientID%>").show();
                        }
                    }

                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                    console.log(xhr.responseText);
                }
            });
        }
        function closeCallDetails() {
            $find("<%=modelopdpatient3.ClientID%>").hide();
        }
        function RemarksPopup() {
            $find("<%=modelopdpatient4.ClientID%>").show();
        }
        function SaveReportCallLog() {
            var MobileNo = $('#Patientmobile').text();
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            var callBy = "";
            if (radioselect == "0") {
                callBy = "Patient";
            }
            if (radioselect == "1") {
                callBy = "Doctor";
            }
            if (radioselect == "2") {
                callBy = "PUP";
            }
            if (radioselect == "3") {
                callBy = "PCC";
            }
            var CallByID = $("#oldptId").text();
            var CallType = "LabReport";
            var Remarks = $('#remarks').val();
            $("#btnsave").attr('disabled', true).val("Submiting...");
            $.ajax({
                url: "CallCenter.aspx/SaveNewEstimateLog",
                data: JSON.stringify({ MobileNo: MobileNo, CallBy: callBy, CallByID: CallByID, CallType: CallType, Remarks: Remarks }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Saved..!");
                        $('#btnsave').attr('disabled', false).val("Save");
                        $find("<%=modelopdpatient4.ClientID%>").hide();
                        $('#remarks').val('');
                    }
                    else {
                        showerrormsg(save.split('#')[1]);
                        $('#btnsave').attr('disabled', false).val("Save");
                    }
                }
            });
        }
        function bindState() {
            jQuery("#ddlState1 option").remove();
            if (jQuery("#ddlBusinessZone").val() == "0") {
                jQuery("#ddlState1").html('');
                $("#ddlState1").trigger('chosen:updated');
                jQuery('#lstCity option').remove();
                jQuery('#lstCity').multipleSelect("refresh");
                jQuery('#lstCentre option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                jQuery("#ddlDoctor option").remove();
                jQuery("#ddlDoctor").html('').trigger('chosen:updated');
                jQuery("#ddlPanel option").remove();
                jQuery("#ddlPanel").html('').trigger('chosen:updated');
                jQuery("#ddlPccCentre option").remove();
                jQuery("#ddlPccCentre").html('').trigger('chosen:updated');
                return false;
            }
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindState",
                data: '{ BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    stateData = jQuery.parseJSON(result.d);
                    console.log(stateData);
                    if (stateData.length == 0) {
                        jQuery("#ddlState1").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        jQuery("#ddlState1").val('');
                    }
                    else {
                        jQuery("#ddlState1").append(jQuery("<option></option>").val("0").html("Select"));
                        jQuery("#ddlState1").append(jQuery("<option></option>").val("-1").html("ALL"));
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#ddlState1").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                    }
                    $("#<%=ddlState1.ClientID%>").trigger('chosen:updated');
                    $('.chosen-container').css('width', '170px');

                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery("#ddlState1").attr("disabled", false);
                }

            });
        }
        function BindCity() {
            jQuery('#lstCity option').remove();
            jQuery('#lstCity').multipleSelect("refresh");
            jQuery('#lstCentre option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            jQuery("#ddlDoctor option").remove();
            jQuery("#ddlDoctor").html('').trigger('chosen:updated');
            jQuery("#ddlPanel option").remove();
            jQuery("#ddlPanel").html('').trigger('chosen:updated');
            jQuery("#ddlPccCentre option").remove();
            jQuery("#ddlPccCentre").html('').trigger('chosen:updated');
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindCityFromBusinessZone",
                data: '{ StateID: "' + jQuery("#ddlState1").val() + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    cityData = jQuery.parseJSON(result.d);
                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#lstCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                    }
                    jQuery('[id*=lstCity]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    $('.ms-parent').css('width', '170px;');
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery("#ddlCity1").attr("disabled", false);
                }

            });
        }
        $('#lstCity').on('change', function () {
            var CityID = $(this).val();
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            if (radioselect == "2" || radioselect == "1") {
                BindCentre(CityID);
            }
            if (radioselect == "3") {
                BindCentrePCC(CityID);
            }
        });
        function BindCentre(CityID) {
            jQuery('#lstCentre option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            jQuery("#ddlDoctor option").remove();
            jQuery("#ddlDoctor").html('').trigger('chosen:updated');
            jQuery("#ddlPanel option").remove();
            jQuery("#ddlPanel").html('').trigger('chosen:updated');
            jQuery("#ddlPccCentre option").remove();
            jQuery("#ddlPccCentre").html('').trigger('chosen:updated');
            if (jQuery("#ddlState1").val() == "0") {
                showerrormsg("Please Select State");
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                return false;
            }
            if (jQuery("#ddlBusinessZone").val() == "0") {
                showerrormsg("Please Select Zone");
                jQuery("#ddlState1").html('');
                $("#ddlState1").trigger('chosen:updated');
                return false;
            }
            if (jQuery("#ddlCity1").val() == "0") {
                showerrormsg("Please Select State");
                jQuery("#ddlState1").html('');
                $("#ddlState1").trigger('chosen:updated');
                return false;
            }
            if (CityID != "") {

                jQuery.ajax({
                    url: "CallCenter.aspx/bindCentre",
                    data: '{ StateID: "' + jQuery("#ddlState1").val() + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '",CityID: "' + CityID + '",CallBy:"' + $('input[name=callcenterRadio]:checked').val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        var centreData = jQuery.parseJSON(result.d);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }
                        var c = '5';
                        //$('#lstCentre').multipleSelect("setSelects", $('#Centreid').val().split(','));
                        if ($('#Centreid').val() != "") {
                            $('#lstCentre').val($('#Centreid').val());
                        }
                        $("#lstCentre").trigger('chosen:updated');
                        $('[id*=lstCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        //jQuery("#ddlCentreAccess").attr("disabled", false);
                    }

                });
            }
        }
        function BindCentrePCC(CityID) {
            jQuery('#lstCentre option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            jQuery("#ddlDoctor option").remove();
            jQuery("#ddlDoctor").html('').trigger('chosen:updated');
            jQuery("#ddlPanel option").remove();
            jQuery("#ddlPanel").html('').trigger('chosen:updated');
            jQuery("#ddlPccCentre option").remove();
            jQuery("#ddlPccCentre").html('').trigger('chosen:updated');
            if (jQuery("#ddlState1").val() == "0") {
                showerrormsg("Please Select State");
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                return false;
            }
            if (jQuery("#ddlBusinessZone").val() == "0") {
                showerrormsg("Please Select Zone");
                jQuery("#ddlState1").html('');
                $("#ddlState1").trigger('chosen:updated');
                return false;
            }
            if (jQuery("#ddlCity1").val() == "0") {
                showerrormsg("Please Select State");
                jQuery("#ddlState1").html('');
                $("#ddlState1").trigger('chosen:updated');
                return false;
            }
            if (CityID != "") {

                jQuery.ajax({
                    url: "CallCenter.aspx/bindCentre",
                    data: '{ StateID: "' + jQuery("#ddlState1").val() + '",BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '",CityID: "' + CityID + '",CallBy:"' + $('input[name=callcenterRadio]:checked').val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var CentreData = jQuery.parseJSON(result.d);
                        if (CentreData.length == 0) {
                            jQuery("#ddlPccCentre").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                            jQuery("#ddlPccCentre option").remove();
                        }
                        else {
                            $("#ddlPccCentre").html('').trigger('chosen:updated');
                            jQuery("#ddlPccCentre").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < CentreData.length; i++) {
                                jQuery("#ddlPccCentre").append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                            }
                        }
                        if ($('#Doctorid').val() != "") {
                            jQuery("#ddlPccCentre").val($('#Doctorid').val());
                            bindPccDetail();
                        }
                        $("#ddlPccCentre").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        //jQuery("#ddlPccCentre").attr("disabled", false);
                    }

                });
            }
        }
        $('#lstCentre').on('change', function () {
 
            var CentreID = $(this).val();
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            if (radioselect == "1") {
                Binddoctor(CentreID);
            }
            if (radioselect == "2") {
                bindPanel(CentreID);
            }
            //if (radioselect == "3") {
            //    bindPccDetail(CentreID);
            //}
        });
        function bindPanel(CentreID) {
            jQuery("#ddlPanel option").remove();
            jQuery("#ddlPanel").html('').trigger('chosen:updated');
            if (CentreID != "") {
                jQuery("#ddlPanel option").remove();
                jQuery.ajax({
                    url: "CallCenter.aspx/bindPanel",
                    data: '{ BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '",StateID: "' + jQuery("#ddlState1").val() + '",CityID: "' + jQuery("#ddlCity1").val() + '",CentreID:"' + CentreID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        panelData = jQuery.parseJSON(result.d);
                        if (panelData.length == 0) {
                            jQuery("#ddlPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlPanel").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < panelData.length; i++) {
                                jQuery("#ddlPanel").append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                            }
                        }
                        if ($('#Doctorid').val() != "") {
                            jQuery("#ddlPanel").val($('#Doctorid').val());
                            BindPanelDetail();
                        }
                        $('.chosen-container').css('width', '170px');
                        $("#<%=ddlPanel.ClientID%>").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlCity").attr("disabled", false);
                    }
                });
            }
        }
        function Binddoctor(CentreID) {
            jQuery("#ddlDoctor option").remove();
            jQuery("#ddlDoctor").html('');
            $("#ddlDoctor").trigger('chosen:updated');
            // $('#<%=ddlDoctor.ClientID%> option').remove();
            var Doctor = $('#<%=ddlDoctor.ClientID%>');

            if (CentreID != "") {
                $.ajax({
                    url: "CallCenter.aspx/GetArea",
                    data: '{ centreid:"' + CentreID + '"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: true,
                    success: function (result) {

                        PatientData = jQuery.parseJSON(result.d);

                        if (PatientData.length == 0) {
                            Doctor.append($("<option></option>").val("0").html("---No Data Found---"));

                        }
                        else {
                            Doctor.html('');
                            Doctor.append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < PatientData.length; i++) {

                                Doctor.append($("<option></option>").val(PatientData[i].Doctor_ID).html(PatientData[i].NAME));
                            }
                        }
                        if ($('#Doctorid').val() != "") {
                            Doctor.val($('#Doctorid').val());
                            BindDoctorDetail();
                        }
                        $('.chosen-container').css('width', '170px');
                        Doctor.trigger('chosen:updated');

                    },
                    error: function (xhr, status) {
                        alert('Error!!!');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        function BindDoctorDetail() {
            $('.tabcontent').html('');
            if ($('#ddlDoctor').val() != "0") {
                $.ajax({
                    url: "CallCenter.aspx/DoctorbindDetail",
                    data: '{ DoctorID:"' + $('#ddlDoctor').val() + '"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: true,
                    success: function (result) {
                        DoctorData = jQuery.parseJSON(result.d);
                        if (DoctorData.length > 0) {
                            $("#oldptId").text(DoctorData[0].Doctor_ID);
                            $('#ptdname').show();
                            $("#PatientName").text(DoctorData[0].NAME);
                            $('#dtDoctorID').show();
                            $('#DoctorID').text(DoctorData[0].Doctor_ID);
                            $('#dtDoctorCode').show();
                            $('#DoctorCode').text(DoctorData[0].DoctorCode);
                            $('#ptdmobile').show();
                            $("#Patientmobile").text(DoctorData[0].Mobile);
                            $('#dtSpecialization').show();
                            $('#Specialization').text(DoctorData[0].Specialization);
                            $('#dtDegree').show();
                            $('#Degree').text(DoctorData[0].Degree);
                            $('#ptdlastCall').show();
                            $("#PatientLastCall").text(DoctorData[0].lastcall);
                            $('#ptdCallType').show();
                            $("#PatientCallType").text(DoctorData[0].calltype);
                            $('#EmailId').text(DoctorData[0].Email);
                            $('#ptdCallDetail').html('');
                            $('#ptdCallDetail').show();
                            $('#ptdCallDetail').append('<span style="cursor:pointer;color:red;" onclick="ShowCallDetails();">Call Details</span>');
                        }
                    },
                    error: function (xhr, status) {
                        alert('Error!!!');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                showerrormsg("Plese select any doctor");
            }
        }
        function BindPanelDetail() {
            $('.tabcontent').html('');
            if ($('#ddlPanel').val() != "0") {
                $.ajax({
                    url: "CallCenter.aspx/PenelbindDetail",
                    data: '{ PanelID:"' + $('#ddlPanel').val() + '"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: true,
                    success: function (result) {

                        DoctorData = jQuery.parseJSON(result.d);
                        if (DoctorData.length > 0) {
                            $("#oldptId").text(DoctorData[0].Panel_ID);
                            $('#ptdname').show();
                            $("#PatientName").text(DoctorData[0].Company_Name);
                            $('#dtDoctorID').show();
                            $('#DoctorID').text(DoctorData[0].Panel_ID);
                            $('#dtDoctorCode').show();
                            $('#DoctorCode').text(DoctorData[0].Panel_Code);
                            $('#ptdmobile').show();
                            $("#Patientmobile").text(DoctorData[0].Mobile);
                            $('#ptdlastCall').show();
                            $("#PatientLastCall").text(DoctorData[0].lastcall);
                            $('#ptdCallType').show();
                            $("#PatientCallType").text(DoctorData[0].calltype);
                            $('#EmailId').text(DoctorData[0].EmailID);
                            $('#ptdCallDetail').html('');
                            $('#ptdCallDetail').show();
                            $('#ptdCallDetail').append('<span style="cursor:pointer;color:red;" onclick="ShowCallDetails();">Call Details</span>');
                        }
                    },
                    error: function (xhr, status) {
                        alert('Error!!!');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                showerrormsg("Plese select panel");
            }
        }
        function bindPccDetail(centreID) {

            $('.tabcontent').html('');
            if (centreID != "") {
                if ($('#ddlPanel').val() != "0") {
                    $.ajax({
                        url: "CallCenter.aspx/PccbindDetail",
                        data: '{ CentreID:"' + $('#ddlPccCentre').val() + '"}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: true,
                        success: function (result) {

                            DoctorData = jQuery.parseJSON(result.d);
                            if (DoctorData.length > 0) {
                                $("#oldptId").text(DoctorData[0].CentreID);
                                $('#ptdname').show();
                                $("#PatientName").text(DoctorData[0].Centre);
                                $('#dtDoctorID').show();
                                $('#DoctorID').text(DoctorData[0].CentreID);
                                $('#dtDoctorCode').show();
                                $('#DoctorCode').text(DoctorData[0].CentreCode);
                                $('#ptdmobile').show();
                                $("#Patientmobile").text(DoctorData[0].Mobile);
                                $('#ptdlastCall').show();
                                $("#PatientLastCall").text(DoctorData[0].lastcall);
                                $('#ptdCallType').show();
                                $("#PatientCallType").text(DoctorData[0].calltype);
                                $('#EmailId').text(DoctorData[0].Email);
                                $('#ptdCallDetail').html('');
                                $('#ptdCallDetail').show();
                                $('#ptdCallDetail').append('<span style="cursor:pointer;color:red;" onclick="ShowCallDetails();">Call Details</span>');
                            }
                        },
                        error: function (xhr, status) {
                            alert('Error!!!');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
            }
        }
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        /*      searching for Term      */
        $("#ddlName")
       .bind("keydown", function (event) {
           if (event.keyCode === $.ui.keyCode.TAB &&
               $(this).autocomplete("instance").menu.active) {
               event.preventDefault();
           }
           $("#TermHidden").val('');
       })
     .autocomplete({
         autoFocus: true,
         source: function (request, response) {
             $.getJSON("CallCenter.aspx?cmd=GetDoctorList", {
                 //  SearchType: $('input:radio[name=rblsearchtype]:checked').val(), 
                 TestName: extractLast(request.term), Category: $('#CategoryFilter').val(), CallBy: $('input[name=callcenterRadio]:checked').val()
             }, response);
         },
         search: function () {
             var term = extractLast(this.value);
             if (term.length < 1) {
                 return false;
             }
         },
         focus: function () {
             return false;
         },
         select: function (event, ui) {
             this.value = '';
             if (ui.item.Doctor_ID != "") {
                 $("#TermHidden").val(ui.item.Doctor_ID);
                 AddDoctor(ui.item.value, ui.item.Doctor_ID);
                 $('#Doctorid').val(ui.item.Doctor_ID);
             }
             else if (ui.item.Panel_ID != "") {
                 $("#TermHidden").val(ui.item.Panel_ID);
                 AddDoctor(ui.item.value, ui.item.Panel_ID);
                 $('#Doctorid').val(ui.item.Panel_ID);
             }
             else if (ui.item.pccid != "") {
                 $("#TermHidden").val(ui.item.pccid);
                 AddDoctor(ui.item.value, ui.item.pccid);
                 $('#Doctorid').val(ui.item.pccid);
             }
             //if (ui.item.Doctor_ID != "") {
             //    AddDoctor(ui.item.value, ui.item.Doctor_ID);
             //}
             $('#ddlBusinessZone').val(ui.item.BusinessZoneID).trigger('chosen:updated');
             bindState();
             $('#ddlState1').val(ui.item.StateID).trigger('chosen:updated');
             BindCity();
             $('#Centreid').val(ui.item.CentreID);
             console.log(ui.item.CentreID);
             //if (ui.item.Doctor_ID != "") {
             //    $('#Doctorid').val(ui.item.Doctor_ID);
             //}
             $('#lstCity').multipleSelect("setSelects", String(ui.item.CityID).split(','));
             if (ui.item.Doctor_ID != "") {
                 Binddoctor(ui.item.CentreID);
             }
             if (ui.item.Panel_ID != "") {
                 bindPanel(ui.item.CentreID);
             }
             //else if (ui.item.pccid != "") {
             //    BindCentrePCC(ui.item.pccid);
             //}
             return false;
         },
     });
        function AddDoctor(dName, doctorId) {
            $('#ddlName').val(dName);
        }
        function changetext() {
            $('#ddlName').val('');
        }
    </script>
</asp:Content>

