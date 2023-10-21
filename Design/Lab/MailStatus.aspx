<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MailStatus.aspx.cs" Inherits="Design_Lab_MailStatus"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Mail Status</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 90%">
                <tr>
                    <td>
                        <label class="labelForSearch">
                            From Lab No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtFromLabNo" runat="server" Width="183px" />
                    </td>
                    <td>
                        <label class="labelForSearch">
                            To Lab No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtToLabNo" runat="server" Width="183px" /></td>
                    <td>
                        <label class="labelForSearch">
                            Lab No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtLabNo" runat="server" Width="183px" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="labelForSearch">
                            Patient Name :</label></td>
                    <td>
                        <asp:TextBox ID="txtPName" runat="server" Width="183px" />
                    </td>
                    <td>
                        <label class="labelForSearch">
                            UHID No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtCRNo" runat="server" Width="183px" />
                    </td>

                    <td>
                        <label class="labelForSearch">
                            Center :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlCentreAccess" CssClass="chosen-select" Width="183px" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="labelForSearch">
                            From Date :</label></td>
                    <td>
                        <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true" Width="98px"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                            TargetControlID="dtFrom"
                            Format="dd-MMM-yyyy" />
                        <asp:TextBox ID="txtFromTime" runat="server" Width="80px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                            ControlExtender="mee_txtFromTime"
                            ControlToValidate="txtFromTime"
                            InvalidValueMessage="*"></cc1:MaskedEditValidator>
                    </td>
                    <td>
                        <label class="labelForSearch" style="float: left;">
                            To Date :</label></td>
                    <td>
                        <asp:TextBox ID="dtTo" runat="server" ReadOnly="true" Width="98px"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                            TargetControlID="dtTo"
                            Format="dd-MMM-yyyy" />
                        <asp:TextBox ID="txtToTime" runat="server" Width="80px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                            ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                            InvalidValueMessage="*"></cc1:MaskedEditValidator>
                    </td>
                    <td>
                        <label class="labelForSearch">
                            Department :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlDepartment" CssClass="chosen-select" Width="183px" runat="server">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="labelForSearch">
                            Mobile No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtMobile" runat="server"
                            Width="183px" class="numbersOnly"></asp:TextBox>
                    </td>
                    <td>
                        <label class="labelForSearch">
                            Phone No. :</label></td>
                    <td>
                        <asp:TextBox ID="txtPhone" runat="server"
                            Width="183px" class="numbersOnly"></asp:TextBox>
                    </td>
                    <td>
                        <label class="labelForSearch">
                            Refer By :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlReferDoctor" CssClass="chosen-select" Width="183px" runat="server"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label class="labelForSearch">
                            Patient Type :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlPatientType" runat="server" Width="183px" CssClass="chosen-select">
                            <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                            <asp:ListItem Value="1">Urgent</asp:ListItem>
                        </asp:DropDownList></td>
                    <td>
                        <label class="labelForSearch">
                            Client :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlPanel" CssClass="chosen-select" runat="server" Width="183px"></asp:DropDownList>
                    </td>
                    <td>
                        <label class="labelForSearch">
                            Status :</label></td>
                    <td>
                        <asp:DropDownList ID="ddlStatus" Width="183px" CssClass="chosen-select" runat="server">
                            <%--   <asp:ListItem></asp:ListItem>--%>
                            <asp:ListItem Value="1">Approved</asp:ListItem>
                            <asp:ListItem Value="2">Requested For Mail</asp:ListItem>
                            <asp:ListItem Value="3">Mail Sent</asp:ListItem>
                            <asp:ListItem Value="3">Sending Failed</asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
                <tr style="display: none">
                    <td>
                        <label class="labelForSearch" style="width: 130px">
                            AccessionNo From:</label></td>
                    <td>
                        <asp:TextBox ID="txtcardfrom" runat="server" Width="150px"></asp:TextBox>
                    </td>
                    <td>
                        <label class="labelForSearch" id="LABEL1">Accession No. To:</label></td>
                    <td>
                        <asp:TextBox ID="txtcardto" runat="server"></asp:TextBox></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:RadioButtonList ID="rblsearchType" runat="server" RepeatDirection="Horizontal" onchange="Cleartable()" CssClass="ItDoseRadiobuttonlist">
                            <asp:ListItem Text="Client" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Doctor" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Patient" Value="2" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td></td>
                    <td>
                        <asp:CheckBox ID="chkPrintHeader" Text="Print Header" runat="server" />
                    </td>
                    <td>Email Type</td>
                    <td>
                        <asp:DropDownList ID="EmailType" Width="183px" CssClass="chosen-select" runat="server">
                            <asp:ListItem Value="1">Lab Report</asp:ListItem>
                            <asp:ListItem Value="2">Patient Receipt</asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
            </table>
           
            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            <input id="btnSearch" type="button" value="Search" class="savebutton" />
            &nbsp; &nbsp;
                <input type="button" id="btnSendMail" class="savebutton" value="SendMail" />
            <div id="colorindication" runat="server">
                <table width="100%">
                    <tr>
                        <td align="center">
                            <table width="70%">
                                <tr>
                                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Approved</td>
                                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Requested for Mail</td>
                                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #3399FF;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Mail Sent</td>
                                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #E2680A;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Sending Fail</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div id="PatientLabSearchOutput" style="max-height: 350px; overflow-y: auto; overflow-x: hidden;">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                    style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr id="trHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;" hidden></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;" hidden></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;" hidden></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">UHID No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Lab No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 145px;">Client Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 145px;">Patient Name</th>
                       
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Age/Sex</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Investigation</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Doctor</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">EmailID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 5px;">
                                <input type="checkbox" id="chkAll" onclick="checkAll()" /></th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript">
        $(function () {
            $('.numbersOnly').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
        });
        $(function () {
            $('.txtonly').keyup(function () {
                this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
            });
        });

        $(document).ready(function () {
            $("#btnSearch").click(PatientLabSearch);
            $("#btnSendMail").click(Sendmail);
        });
        var PatientData = "";
        var SearchType = "";
        function PatientLabSearch() {
            var symbol = "";
            $("#tb_grdLabSearch tr").slice(1).remove();
            serverCall('../lab/MailStatus.aspx/SearchMail', { LabNo: $("#<%=txtLabNo.ClientID %>").val(), RegNo: $("#<%=txtCRNo.ClientID %>").val(), PName: $("#<%=txtPName.ClientID %>").val(), CentreID: $("#<%=ddlCentreAccess.ClientID %>").val(), dtFrom: $("#<%=dtFrom.ClientID %>").val(), dtTo: $("#<%=dtTo.ClientID %>").val(), Dept: $("#<%=ddlDepartment.ClientID %>").val(), Status: $("#<%=ddlStatus.ClientID %>").val(), PhoneNo: $("#<%=txtPhone.ClientID %>").val(), Mobile: $("#<%=txtMobile.ClientID %>").val(), refrdby: $("#<%=ddlReferDoctor.ClientID%>").val(), Ptype: $("#<%=ddlPatientType.ClientID%>").val(), TimeFrm: $("#<%=txtFromTime.ClientID%>").val(), TimeTo: $("#<%=txtToTime.ClientID%>").val(), FromLabNo: $("#<%=txtFromLabNo.ClientID %>").val(), ToLabNo: $("#<%=txtToLabNo.ClientID %>").val(), PanelID: $("#<%=ddlPanel.ClientID %>").val(), CardNoFrom: $("#<%=txtcardfrom.ClientID%>").val(), CardNoTo: $("#<%=txtcardto.ClientID%>").val(), type: $("#<%=EmailType.ClientID%>").val() }, function (response) {
                PatientData = $.parseJSON(response);
                if (PatientData.length == 0) {
                    toast("Error", "No Record Found", "");
                }
                else {
                    $('[id$=lblMsg]').text('');
                }

                if ($('#<%=rblsearchType.ClientID%> input[type=radio]:checked').val() == "1") {
                    SearchType = "1";
                }
                else if ($('#<%=rblsearchType.ClientID%> input[type=radio]:checked').val() == "3") {
                    SearchType = "3";
                }
                else {
                    SearchType = "2";
                }
                var output = '';
                for (var i = 0; i < PatientData.length; i++) {
                    var $temp = [];
                    $temp.push('<tr  style="background-color:'); $temp.push(PatientData[i].rowColor); $temp.push(';" > ');
                    $temp.push(' <td class="GridViewLabItemStyle">'); $temp.push(i + 1); $temp.push('</td>');
                    $temp.push(' <td class="GridViewLabItemStyle" hidden>'); $temp.push(PatientData[i].Transaction_ID); $temp.push('</td>');
                    $temp.push(' <td class="GridViewLabItemStyle" hidden>'); $temp.push(PatientData[i].LedgerTransactionNo); $temp.push('</td>');
                    $temp.push(' <td class="GridViewLabItemStyle" hidden>'); $temp.push(PatientData[i].Test_ID); $temp.push('</td>');
                    $temp.push(' <td class="GridViewLabItemStyle">'); $temp.push(PatientData[i].Patient_ID); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle" id="labno">'); $temp.push(PatientData[i].LedgerTransactionNo); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle" style="text-align:left">'); $temp.push(PatientData[i].PanelName); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle" id="pname" style="text-align:left">'); $temp.push(PatientData[i].pname); $temp.push('</td>  ');
                    
                    $temp.push(' <td class="GridViewLabItemStyle">'); $temp.push(PatientData[i].age); $temp.push('</td>  ');
                    //$temp.push(' <td class="GridViewLabItemStyle" >'); $temp.push(PatientData[i].PatientMailID); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle" id="testname" style="text-align:left">'); $temp.push(PatientData[i].ObservationName); $temp.push('</td>  ');
                    // $temp.push(' <td class="GridViewLabItemStyle" >'); $temp.push(PatientData[i].PanelMailID); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle" style="text-align:left">'); $temp.push(PatientData[i].Doctor); $temp.push('</td>  ');
                    $temp.push(' <td class="GridViewLabItemStyle"><input type="text" style="width:192px"  id="txtEmailID" onkeyup="fillEmailIds(this)" value="');
                    //if (PatientData[i].IsSend == null && PatientData[i].isSent == null) 
                    if (SearchType == "1") {
                        if (PatientData[i].EmailId != "" && PatientData[i].PanelMailID == "")
                            $temp.push(PatientData[i].EmailId);
                        else                            
                            $temp.push(PatientData[i].PanelMailID);                       
                        $temp.push('"  class='); $temp.push(PatientData[i].panelClass);
                    }
                    else if (SearchType == "3") {
                        if (PatientData[i].EmailId != "" && PatientData[i].DoctorEmailId == "")
                            $temp.push(PatientData[i].EmailId);
                        else
                            $temp.push(PatientData[i].DoctorEmailId);
                        //$temp.push(PatientData[i].DoctorEmailId);
                        $temp.push('"  class='); $temp.push(PatientData[i].DoctorClass);
                    }
                    else {
                        if (PatientData[i].EmailId != "" && PatientData[i].PatientMailID == "")
                            $temp.push(PatientData[i].EmailId);
                        else
                            $temp.push(PatientData[i].PatientMailID);
                        
                        $temp.push('"  class="cls'); $temp.push(PatientData[i].Transaction_ID);
                    }
                    //}
                    //else {
                    //    $temp.push(PatientData[i].EmailId); $temp.push('" disabled ');

                    //}         

                    $temp.push('  "  /></td>');
                    $temp.push('<td class="GridViewLabItemStyle"  style="width:80px;">'); $temp.push(PatientData[i].InDate); $temp.push('</td>  ');
                    $temp.push('<td class="GridViewLabItemStyle" style="text-align:center width:5px;">');
                    //if (PatientData[i].IsSend == null && PatientData[i].isSent == null)
                    $temp.push(' <input class="Clschec"  type="checkbox" id="chkMail" />');
                    $temp.push('</td>  ');
                    $temp.push('<td id="reporttype" style="display:none;">'); $temp.push(PatientData[i].ReportType); $temp.push('</td>  ');
                    $temp.push('<td id="testid" style="display:none;">'); $temp.push(PatientData[i].Test_ID); $temp.push('</td>  ');
                    $temp.push('</tr>  ');
                    $temp = $temp.join("");
                    $('#tb_grdLabSearch tbody').append($temp);
                }
                $("#tb_grdLabSearch").tableHeadFixer();
            });

        };
        function Sendmail() {
            $("#btnSendMail").attr("disabled", "disabled").val("Processing......");
            var MailData = '';
            var MailData = TableToArray();
            if (MailData == '0') {
                toast("Error", "Record Not Selected", "Please Check EmailId and select atleast one patient details");
                $("#btnSendMail").attr("disabled", false).val("SendMail");
                return;
            }
            if ($("#<%=EmailType.ClientID%>").val() == "2") {
                serverCall('../lab/Services/Mail.asmx/SendMailPatientWise', { data: MailData }, function (response) {
                    $("#btnSendMail").attr("disabled", false).val("SendMail");
                    if (response == '1') {
                        toast("Success", "Email Sent Successfully", "");
                        PatientLabSearch();
                    }
                    else
                        toast("Error", "Email not Sent","");
                })
            }
            else {
                serverCall('../lab/Services/Mail.asmx/SendMail', { data: MailData }, function (response) {
                    $("#btnSendMail").attr("disabled", false).val("SendMail");
                    if (response == '1') {
                        toast("Success", "Email Sent Successfully!", "");
                        PatientLabSearch();
                    }
                    else
                        toast("Error", "Email not sent","");
                })
            }
        }
        function TableToArray() {
            var PHead = 0;
            var Type = 1;
            var ischk = '<%= Session["LoginType"].ToString() %>';
            if (ischk == "RADIOLOGY")
                Type = 3;
            else
                Type = 1;
            var ar = new Array();
            if ($("#<%=chkPrintHeader.ClientID %>").attr("checked"))
                PHead = 1;
            var chckemail = '0';
            $('#tb_grdLabSearch tr').find('#chkMail').filter(':checked').each(function () {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (filter.test($(this).closest("tr").find("#txtEmailID").val())) {
                    var Obj = new Object();
                    Obj.PatientName = $(this).closest("tr").find("#pname").html();
                    Obj.LedgertransactionId = $(this).closest("tr").find("td:eq(1)").text();
                    Obj.LedgerTransactionNo = $(this).closest("tr").find("td:eq(2)").text();
                    Obj.TestID = $(this).closest("tr").find("td:eq(3)").text();
                    Obj.TestName = $(this).closest("tr").find("#testname").html();
                    Obj.EmailId = $(this).closest("tr").find("#txtEmailID").val();
                    Obj.PHead = PHead;
                    Obj.Panelid = $("#<%=ddlPanel.ClientID %>").val();
                    Obj.logintype = Type;
                    ar.push(Obj);
                }
                else {
                    chckemail = "1";
                    return false;
                }
            });
            if (ar == "") {
                return "0";
            }
            else {
                if (chckemail == "1")
                    return "0";
                else
                    return ar;
            }
        }
        function checkAll() {
            if ($('#chkAll').is(':checked')) {
                $('.Clschec').attr("checked", true);
            }
            else {
                $('.Clschec').attr("checked", false);
            }
        }
        function fillEmailIds(el) {
            var cla = $(el).attr('class');
            $('.' + cla + '').val($(el).val());

        }
        function Cleartable()
        {
            $('#tb_grdLabSearch tbody').html('');
        }
    </script>
</asp:Content>

