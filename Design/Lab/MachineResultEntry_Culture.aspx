<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineResultEntry_Culture.aspx.cs" Inherits="Design_Lab_MicroCultureLabResult" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>


    <style type="text/css">
        #MainInfoDiv {
            height: 480px !important;
        }

        .sapaleColected {
            width: 25px;
            border-right: black thin solid;
            border-top: black thin solid;
            cursor: pointer;
            border-left: black thin solid;
            border-bottom: black thin solid;
            background-color: bisque;
        }
    </style>

    <div id="popup_box" style="height: 120px;">

        <a href="javascript:void(0);" id="popupBoxClose" onclick="unloadPopupBox()">Close</a>

        Approval Type::<asp:DropDownList ID="ddlapptype" runat="server">
            <asp:ListItem>Select</asp:ListItem>
            <asp:ListItem>Interim</asp:ListItem>
            <asp:ListItem>Final</asp:ListItem>
        </asp:DropDownList>
        <br />
        <br />
        <input type="button" class="savebutton" value="Save" onclick="SaveApproved()" />&nbsp;&nbsp;
            <input type="button" class="resetbutton" value="Cancel" onclick="unloadPopupBox()" />
    </div>





    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Result Entry Culture</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="row">

                <div class="row">
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlSearchType" runat="server">
                            <asp:ListItem Value="pli.BarcodeNo" Selected="True">SIN No.</asp:ListItem>
                            <asp:ListItem Value="lt.Patient_ID">UHID No.</asp:ListItem>
                            <asp:ListItem Value="pli.LedgerTransactionNo">Visit No.</asp:ListItem>
                            <asp:ListItem Value="pm.Mobile">Mobile No.</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtSearchValue" runat="server"></asp:TextBox>
                    </div>
                 
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlDepartment" runat="server">
                        </asp:DropDownList>
                    </div>
                      <div class="col-md-2" style="vertical-align: top; margin-left: -10px;">
                            <asp:CheckBox ID="chkPanel" runat="server" onClick="BindPanel();" Text="Panel:" />
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel  chosen-select chosen-container"></asp:DropDownList>
                        </div>
                    <div class="col-md-2">
                        <asp:CheckBox ID="chkPanel0" runat="server" onClick="BindTest();" Text="Test :" Style="font-weight: 700" />

                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlSampleStatus" runat="server">
                            <asp:ListItem Value="  and pli.isSampleCollected<>'N' ">All Patient</asp:ListItem>
                            <asp:ListItem Value=" and pli.CultureStatus='Incubation' and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">Pending</asp:ListItem>
                            <asp:ListItem Value=" and pli.isSampleCollected='S' and pli.Result_flag=0 ">Sample Collected</asp:ListItem>
                            <asp:ListItem Value=" and pli.isSampleCollected='Y' and pli.Result_flag=0 ">Sample Receive</asp:ListItem>
                            <asp:ListItem Value=" and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ">Machine Data</asp:ListItem>
                            <asp:ListItem Value=" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'   and pli.isSampleCollected<>'R' ">Tested</asp:ListItem>
                            <asp:ListItem Value=" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ">Forwarded</asp:ListItem>
                            <asp:ListItem Value=" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ">Approved</asp:ListItem>
                            <asp:ListItem Value=" and pli.isHold='1'  ">Hold</asp:ListItem>
                            <asp:ListItem Value=" and pli.isPrint=1  and pli.isSampleCollected<>'R' ">Printed</asp:ListItem>
                            <asp:ListItem Value=" and pli.isSampleCollected='R'  ">Rejected Sample</asp:ListItem>
                            <%--<asp:ListItem  Value=" and pli.Preliminary='1' and  pli.Approved=0   and pli.isPrint=0  ">Preliminary report</asp:ListItem>--%>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">

                        <input id="chkChamp" type="checkbox" />
                        <strong>Camp</strong>&nbsp;
                    </div>
                </div>
            </div>
            
             <div class="row" style="margin-left: -16px; margin-right: -20px">
             <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-7">
                            <asp:DropDownList ID="ddlZSM" runat="server" Style="display: none;">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtFormDate" runat="server" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                        </div>
                        <div class="col-md-5" style="margin-left: -12px">
                            <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                ControlExtender="mee_txtFromTime"
                                ControlToValidate="txtFromTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-7" style="margin-left: -4px">
                            <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                        </div>
                        <div class="col-md-5" style="margin-left: -12px">
                            <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>
                        </div>
                    </div>
                </div>
             <div class="col-md-2">
                    TAT Option :
                </div>
             <div class="col-md-3">
                    <select id="ddltatoption">
                        <option value="ALL">ALL</option>
                        <option value="1" style="background-color: green !important; color: white;">WithIn TAT</option>
                        <option value="2" style="background-color: yellow !important;">Near TAT</option>
                        <option value="3" style="background-color: red !important; color: white">Outside TAT</option>
                    </select>
                </div>

             <div class="col-md-3">
                            <input id="ChkIsUrgent" type="checkbox" />
                            <strong>Urgent/Emergency</strong>
                   </div>

                   <div class="col-md-3">
                    <input id="ChkTATDate" type="checkbox" /> <strong>TAT Scheduled Date </strong>
                </div>
                 <div class="col-md-2">
                         <input id="chkheader" type="checkbox"  checked="checked"/><strong>Header</strong>
                       </div>

             <div class="col-md-1">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchSampleCollection('');" />
                </div>
             </div>
          
                <div class="col-md-1">
                    <asp:CheckBox ID="chkcentre" runat="server" onClick="BindCentre();" Text="Centre :" Style="font-weight: 700; display: none;" />
                    <asp:DropDownList ID="ddlCentreAccess" Style="display: none;" runat="server">
                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                    </asp:DropDownList>
                    
                    <asp:DropDownList ID="ddlMachine" Width="100px" runat="server" Style="display: none;">
                    </asp:DropDownList>
                    <asp:CheckBox ID="chremarks" Font-Bold="true" runat="server" Text="Remarks Status" Style="display: none;" />
                    <asp:CheckBox ID="chcomments" Font-Bold="true" runat="server" Text="Comments Status" Style="display: none;" />
                </div>
            </div>
        

     

        <div class="POuter_Box_Inventory">
            <div class="row">
                <table align="center">
                    <tr>
                        <td class="sapaleColected" onclick="SearchSampleCollection(16)"></td>

                        <td style="font-weight: bold;">Sample Collected</td>
                        <td class="Received" style="width: 20px; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque; cursor: pointer;"
                            onclick="SearchSampleCollection(5)"></td>
                        <td style="font-weight: bold;">Pending</td>
                        <td class="MacData" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(1)"></td>
                        <td style="font-weight: bold;">MacData</td>
                        <td class="Tested" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(4)"></td>
                        <td style="font-weight: bold;">Tested</td>
                        <td class="ReRun" style="width: 20px; border: 1px solid black; background-color: #FF00FF; cursor: pointer;" onclick="SearchSampleCollection(17)"></td>
                        <td style="font-weight: bold;">Sample Recieve</td>
                        <td class="Forwarded" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(15)"></td>
                        <td style="font-weight: bold;">Forwarded</td>
                        <td class="Approved" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(6)"></td>
                        <td style="font-weight: bold;">Approved</td>
                        <td class="Printed" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(10)"></td>
                        <td style="font-weight: bold;">Printed</td>
                        <td class="Hold" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(8)"></td>
                        <td style="font-weight: bold;">Hold</td>
                        <td class="Rejected" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(2)"></td>
                        <td style="font-weight: bold;">Rejected</td>

                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="divPatient" class="vertical"></div>
            <div id="MainInfoDiv" class="vertical">
                <div class="Purchaseheader">
                    <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                </div>
                <div style="height: 410px; overflow: auto;">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-3">
                                <strong>Report Type:</strong>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlreportnumber" runat="server" onchange="pickmeagain()">
                                    <%--                                    <asp:ListItem Value="Preliminary 1">Preliminary 1</asp:ListItem>
                                    <asp:ListItem Value="Preliminary 2">Preliminary 2</asp:ListItem>
                                    <asp:ListItem Value="Preliminary 3">Preliminary 3</asp:ListItem>
                                    <asp:ListItem Value="Final Report">Final Report</asp:ListItem>--%>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24">
                            <div class="col-md-10">
                                <div id="divInvestigation">
                                </div>
                            </div>
                            <div class="col-md-14">
                                <div id="divantibody" style="display: none; background-color: lightyellow;">
                                    <div class="Purchaseheader">Antibiotic Entry</div>
                                    <div id="AntiBioList" style="max-height: 330px; overflow: auto;">
                                        <table id="AntiBioTicList" style="width: 99%; border-collapse: collapse">
                                            <tr id="antiheader">
                                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                <td class="GridViewHeaderStyle">Antibiotic</td>
                                                <td class="GridViewHeaderStyle">Interpretation</td>
                                                <td class="GridViewHeaderStyle">MIC</td>
                                                <td class="GridViewHeaderStyle" style="display: none">BreakPoint</td>
                                                <td class="GridViewHeaderStyle" style="display: none">MIC/BP</td>
                                                <td class="GridViewHeaderStyle" style="display: none">Group</td>
                                            </tr>
                                        </table>
                                    </div>
                                    <table width="99%;">
                                        <tr style="background-color: aqua">
                                            <td style="font-weight: bold;">Select Organism: </td>
                                            <td>
                                                <asp:DropDownList ID="ddlOrganism" runat="server" Width="400px" onchange="AddAntibotic()"></asp:DropDownList></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div id="SelectedPatientinfo">
                        </div>
                    </div>

                    <div class="row">
                        <input id="btnUpdateBarcodeInfo" class="ItDoseButton" type="button" value="Save" style="display: none" onclick="UpdateBarcodes();" disabled />
                        <div style="padding-top: 2px;" class="btnDiv">
                            <span style="color: black; font-weight: bold;">Incubation Date:</span>
                            <asp:TextBox ID="txtindate" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtindate" TargetControlID="txtindate" OnClientDateSelectionChanged="checkDate" />

                            <asp:TextBox ID="txtintime" runat="server" Width="70px"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="MaskedEditExtender1" Mask="99:99:99" TargetControlID="txtintime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="MaskedEditValidator1"
                                ControlExtender="mee_txtFromTime"
                                ControlToValidate="txtintime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>

                            <asp:DropDownList ID="ddlTestDon" runat="server" onchange="PicSelectedRow()" Style="display: none;"></asp:DropDownList>
                            <input id="btnPreLabObs" type="button" value="<<" class="demo ItDoseButton" onclick="PreLabObs();" style="width: 50px; height: 25px" disabled />
                            <input id="btnNextLabObs" type="button" value=">>" class="demo ItDoseButton" onclick="NextLabObs();" style="width: 50px; height: 25px" disabled />
                            <input id="btnSaveLabObs" type="button" value="Save" class="ItDoseButton btnForSearch demo SampleStatus" onclick="Save();" style="width: auto; height: 25px;" disabled />
                            <%                  
                                if (ApprovalId == "")
                                { %>
                            <%}
                                else
                                {
                                    if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                                    {%>
                            <asp:DropDownList ID="ddlApprove" runat="server" Width="140px"></asp:DropDownList>
                            <input id="btnApprovedLabObs" type="button" value="Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Approved();" style="width: auto; height: 25px;" disabled />
                            <input id="btnPreliminary" type="button" value="Preliminary Report" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Preliminary();" style="width: auto; height: 25px; display: none;" disabled />
                            <% if (ApprovalId == "4" || ApprovalId == "3")
                               {%>
                            <input id="btnNotApproveLabObs" type="button" value="Not Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="NotApproved();" style="width: auto; height: 25px;" disabled />

                            <%if (ApprovalId == "4")
                              { 
                            %>
                            <input id="btnholdLabObs" type="button" value="Hold " class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Hold();" style="width: auto; height: 25px; font-weight: bold;" disabled />

                            <input id="btnUnholdLabObs" type="button" value="Un Hold " class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnHold();" style="width: auto; height: 25px; font-weight: bold;" disabled />
                            <% }
                               }
                                }

                                if (ApprovalId == "2" || ApprovalId == "3" || ApprovalId == "4")
                                {%>
                            <input id="btnForwardLabObs" type="button" value="Forward" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Forward();" />
                            <%}
                   
                            %>
                            <input id="btnUnForwardLabObs" type="button" value="Un Forward" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnForward();" />
                            <%

                            }%>
                            <input id="btnAddFileLabObs" type="button" value="Add File" class="ItDoseButton" onclick="window.open('AddAttachment.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=', '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');" style="width: auto; height: 25px;" />

                            <input id="btnaddreport" type="button" value="Add Report" class="ItDoseButton" onclick="openAddReport(LedgerTransactionNo, _test_id)" style="width: auto; height: 25px;" />


                            <input id="btnPrintReportLabObs" type="button" value="Print PDF" class="ItDoseButton btnForSearch demo " onclick="PrintReport();" disabled style="width: auto; height: 25px;" />
                            <input id="btnPatientDetail" type="button" value="Patient Detail" class="ItDoseButton" style="width: auto; height: 25px;" />
                            <a id="various2" style="display: none">Ajax</a>
                            <input id="btnSide" type="button" value="Main List" class="ItDoseButton" onclick="$('#divPatient').toggle(); $('#MainInfoDiv').toggle(); hot1.render(); hot2.render();" style="width: auto; height: 25px;" />
                                              <input id="Button5" type="button" value="Sample Reject" class="ItDoseButton" onclick="window.open('SampleReject.aspx?barcode=' + _barcodeno, '', 'dialogwidth:50;');" style="width: auto; height: 25px;" />


 </div>

                    </div>
                    <div class="row">
                        <div id="myModal" class="modal">
                            <!-- Modal content -->
                            <div class="modal-content">
                                <div class="modal-header">
                                    <span class="close">×</span>
                                    <h2 class="modal_header">Modal Header</h2>
                                </div>
                                <div class="modal-body">
                                    <div id="divimgpopup">
                                        <asp:HiddenField ID="X" runat="server" />
                                        <asp:HiddenField ID="Y" runat="server" />
                                        <asp:HiddenField ID="W" runat="server" />
                                        <asp:HiddenField ID="H" runat="server" />
                                        <div id="imgpopup">
                                        </div>
                                        <br />
                                        <input type="button" value="Crop" onclick="crop(); return false;" />
                                    </div>
                                    <p id="CommentBox"><span id="CommentHead">Comments</span><select id="ddlCommentsLabObservation" onchange="ddlCommentsLabObservation_Load(this.value);" style="margin-left: 5px; height: 25px; min-width: 200px;"></select></p>
                                    <p>
                                        <input type="file" name="file_upload" id="file_upload" />
                                        <CKEditor:CKEditorControl ID="CKEditorControl1" BasePath="~/ckeditor" runat="server"></CKEditor:CKEditorControl>
                                    </p>
                                </div>
                                <div>
                                </div>
                                <div class="modal-footer">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>





            </div>
        </div>

        <div id="deltadiv" style="display: none; position: absolute;">
        </div>

        <select size="4" style="position: absolute; min-height: 100px; display: none;" class="helpselect" onkeyup="addtotext1(this,event)" ondblclick="addtotext(this)">
            <option value="Intermediate">Intermediate</option>
            <option value="Resistant">Resistant</option>
            <option value="Highly Sensitive">Highly Sensitive</option>
            <option value="Moderately Sensitive">Moderately Sensitive</option>
            <option value="Midly Sensitive">Midly Sensitive</option>
            <option value="Sensitive">Sensitive</option>

        </select>
    </div>




    <script type="text/javascript">
        $(document).ready(function () {
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
            $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {
                if (ev.which === 13)
                    SearchSampleCollection('');
            });

            $('.helpselect').keydown(function (e) {
                if (e.keyCode == 13)
                    e.preventDefault();
            });
            $('.helpselect').keyup(function (e) {
                if (e.keyCode == 13)
                    e.preventDefault();
            });

        });
    </script>
    <script type="text/javascript">
        function BindCentre() {
            $modelBlockUI();





            var ddlDoctor = $("#<%=ddlCentreAccess.ClientID %>");
            var chkDoc = $("#<%=chkcentre.ClientID %>");


            if (($('#<%=chkcentre.ClientID%>').prop('checked') == true)) {


                $("#<%=ddlCentreAccess.ClientID %> option").remove();




                $.ajax({

                    url: "MachineResultEntry_Culture.aspx/bindAccessCentre",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            ddlDoctor.append($("<option></option>").val("ALL").html("ALL"));
                            for (i = 0; i < PanelData.length; i++) {

                                ddlDoctor.append($("<option></option>").val(PanelData[i]["CentreID"]).html(PanelData[i]["Centre"]));
                            }
                        }
                        ddlDoctor.trigger('chosen:updated');

                        $modelUnBlockUI();
                    },
                    error: function (xhr, status) {
                        toast("Error", "Error ");

                        ddlDoctor.trigger('chosen:updated');

                        $modelUnBlockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

            }
            else {

                $("#<%=ddlCentreAccess.ClientID %> option").remove();
                ddlDoctor.append($("<option></option>").val("ALL").html("ALL"));
                ddlDoctor.trigger('chosen:updated');
                $modelUnBlockUI();
            }

        }

        function BindPanel() {
            $modelBlockUI();





            var ddlPanel = $("#<%=ddlPanel.ClientID %>");
            var chkPanel = $("#<%=chkPanel.ClientID %>");


            if (($('#<%=chkPanel.ClientID%>').prop('checked') == true)) {


                $("#<%=ddlPanel.ClientID %> option").remove();
                ddlPanel.append($("<option></option>").val("").html(""));



                $.ajax({

                    url: "MachineResultEntry_Culture.aspx/GetPanelMaster",
                    //centreid: "' + $("#<%=ddlCentreAccess.ClientID %> option:selected").val() + '"
                    data: '{centreid: "' + $("#<%=ddlCentreAccess.ClientID %> option:selected").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            for (i = 0; i < PanelData.length; i++) {

                                ddlPanel.append($("<option></option>").val(PanelData[i]["Panel_ID"]).html(PanelData[i]["company_name"]));
                            }
                        }
                        ddlPanel.trigger('chosen:updated');

                        $modelUnBlockUI();
                    },
                    error: function (xhr, status) {
                        toast("Error", "Error ");

                        ddlPanel.trigger('chosen:updated');

                        $modelUnBlockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

            }
            else {

                $("#<%=ddlPanel.ClientID %> option").remove();

                ddlPanel.trigger('chosen:updated');
                $modelUnBlockUI();
            }

        };

        function BindTest() {
            $modelBlockUI();





            var ddlDoctor = $("#<%=ddlinvestigation.ClientID %>");
            var chkDoc = $("#<%=chkPanel0.ClientID %>");


            if (($('#<%=chkPanel0.ClientID%>').prop('checked') == true)) {


                $("#<%=ddlinvestigation.ClientID %> option").remove();
                ddlDoctor.append($("<option></option>").val("").html(""));



                $.ajax({

                    url: "MachineResultEntry_Culture.aspx/GetTestMaster",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            for (i = 0; i < PanelData.length; i++) {

                                ddlDoctor.append($("<option></option>").val(PanelData[i]["testid"]).html(PanelData[i]["testname"]));
                            }
                        }
                        ddlDoctor.trigger('chosen:updated');

                        $modelUnBlockUI();
                    },
                    error: function (xhr, status) {
                        toast("Error", "Error ");

                        ddlDoctor.trigger('chosen:updated');

                        $modelUnBlockUI();
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

            }
            else {

                $("#<%=ddlinvestigation.ClientID %> option").remove();

                ddlDoctor.trigger('chosen:updated');
                $modelUnBlockUI();
            }

        };


    </script>

    <script type="text/javascript">
        var PatientData = '';
        var LabObservationData = '';
        var _test_id = '';
        var _barcodeno = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        var resultStatus = "";
        var LedgerTransactionNo = "";
        var MYSampleStatus = "";
        var elt;
        // for image crop
        var Year = '<%=Year %>';
        var Month = '<%=Month %>';
        var image;
        var ImgTag;
        var savedvalue = "";
        var formattedDate;
        //end
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function getme(testid) {
            var url = "../../Design/Lab/showreading.aspx?TestID=" + testid;
            $('#deltadiv').load(url);
            $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
        }
        function hideme() {
            $('#deltadiv').hide();
        }
        $(document).ready(function () {
            // ManageDivHeight();
            $('#MainInfoDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            $('#divPatient').removeClass('vertical');
            $('#divPatient').addClass('horizontal');
            // $('#divPatient').css('height', '450px');
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
            $('#btnSide').hide();
            $('#btnUpdateBarcodeInfo').show();
                <%}%>
            elt = document.getElementById('<%=ddlSampleStatus.ClientID%>');
            // MYSampleStatus = elt.options[elt.selectedIndex].text;
            //UpdateSampleStatus();
            $('#<%=ddlSampleStatus.ClientID%>').change(function () {
                $('.SampleStatus').hide();
            });
            modal = document.getElementById('myModal');
            // Get the button that opens the modal

            // Get the <span> element that closes the modal
            span = document.getElementsByClassName("close")[0];
            // When the user clicks on the button, open the modal 
            //btn.onclick = function () {
            //    modal.style.display = "block";
            //}
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        });
        function ManageDivHeight() {
            $('#divInvestigation').removeClass('vertical');
            $('#divPatient').removeClass('vertical');
            $('#divInvestigation').addClass('horizontal');
            $('#divPatient').addClass('horizontal');
        }
        function UpdateSampleStatus(mystatus) {

            MYSampleStatus = mystatus;
            $('.SampleStatus').hide();
            if (MYSampleStatus == "Forwarded") {
                $('#btnApprovedLabObs').show();
                $('#btnUnForwardLabObs').show();

            }
            if (MYSampleStatus == "Tested") { $('#btnApprovedLabObs').show(); $('#btnForwardLabObs').show(); }
            if (MYSampleStatus == "Approved" || MYSampleStatus == "Printed") { $('#btnNotApproveLabObs').show(); }
            if (MYSampleStatus == "Pending" || MYSampleStatus == "Tested" || MYSampleStatus == "Machine Data" || MYSampleStatus == "Sample Receive") { $('#btnSaveLabObs').show(); }
            if (MYSampleStatus == "Hold") { $('#btnUnholdLabObs').show(); }





        }

        var
                        data,
                        container1,
                        hot1;

        function SearchSampleCollection(ColourCode) {
            var investigationID = "";
            var PanelId = "";



            PanelId = $('#<%=ddlPanel.ClientID%>').val();
            investigationID = $('#<%=ddlinvestigation.ClientID%>').val();
            //alert(investigationID);

            $('#divPatient').show();
            $('#MainInfoDiv').hide();

            var isUrgent = $("#ChkIsUrgent").is(':checked') ? 1 : 0;
            var isTATDate = $("#ChkTATDate").is(':checked') ? 1 : 0;
            $('#btnSave').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('.demo').attr('disabled', true);

            var chremarks = 0;
            if ($("#ctl00_ContentPlaceHolder1_chremarks").prop("checked") == true)
                chremarks = 1;

            var chcomments = 0;
            if ($("#ctl00_ContentPlaceHolder1_chcomments").prop("checked") == true)
                chcomments = 1;


            var camp = $("#chkChamp").is(':checked') ? 1 : 0;

            var TATOption = $("#ddltatoption").val();

            $("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            $modelBlockUI();
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/PatientSearch",
                data: '{ SearchType: "' + $("#<%=ddlSearchType.ClientID %>").val() + '",SearchValue:"' + $("#<%=txtSearchValue.ClientID %>").val() + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",ZSM:"' + $("#<%=ddlZSM.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",isUrgent:"' + isUrgent + '",InvestigationId:"' + investigationID + '",PanelId:"' + PanelId + '", SampleStatusText:"' + $('#<%=ddlSampleStatus.ClientID %> option:selected').text() + '",chremarks:"' + chremarks + '",ColourCode:"' + ColourCode + '",chcomments:"' + chcomments + '", camp:"' + camp + '", TATOption: "' + TATOption + '",isTATDate:"' + isTATDate + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $('.SampleStatus').hide();
                    $('.SampleStatus').attr('disabled', true);

                    PatientData = $.parseJSON(result.d);
                    if (PatientData == "-1") {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $modelUnBlockUI();
                        toast("Error", 'Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $modelUnBlockUI();
                        toast("Error", 'No Record Found');
                        return;
                    }
                    if (PatientData == "-2") {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $modelUnBlockUI();
                        toast("Error", 'Your From date ,To date Diffrence is too  Long');
                        return;
                    }
                    else {
                        //UpdateSampleStatus();
                        currentRow = 1;
                        $("#<%=lblMsg.ClientID %>").text('');
                        $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData.length);
                        $('#btnUpdateBarcodeInfo').attr('disabled', false);
                        // var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                        // $('#divPatient').html(output);

                        data = PatientData;
                        container1 = document.getElementById('divPatient');
                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                      "S.No.", "TAT", "Time Diff", "Dept Rec. Date", "PCC/Client Name/Client Code", "Report Type", "Visit No.", "SIN No.", "UHID No.", "Patient Name", "Age/Sex", "Tests", "Status", "Detail", "Remarks", "View Doc.", "Print"
                            ],
                            readOnly: true,
                            currentRowClassName: 'currentRow',
                            columns: [
                            { renderer: AutoNumberRenderer, width: '60px' },
                            { renderer: TATStatus, width: '60px' },
                            { data: 'timeDiff', width: '100px' },
                            { data: 'DATE' },
                            { data: 'Centre' },

                            { data: 'reportnumber' },
                            { data: 'LedgerTransactionNo', renderer: safeHtmlRenderer },
                            { data: 'BarcodeNo', renderer: EnableBarcode, width: '100px' },
                            { data: 'Patient_ID' },
                            { data: 'PName', width: '200px' },
                            { data: 'Age_Gender', width: '100px' }, // , renderer: safeHtmlRenderer 
                            { data: 'Test', width: '200px', renderer: safeTestRenderer },
                            { data: 'Status' },
                            { renderer: PatientDetail },
                            { data: 'Remarks', renderer: RemarksRenderer },
                            { renderer: ShowAttachment },
                          //   { data: 'Test_ID', renderer: SampleIconRenderer },
                            { renderer: PrintreportRenderer } //   , renderer: safeHtmlRenderer 
                          //  { data: 'Test_ID', renderer: RemarksFieldRenderer },
                            //{ data: 'RemarkStatus', readOnly: false, width: '150px' },//, renderer: RemarksFieldRenderer
                            //{ data: 'Comments', width: '150px' }

                            ],
                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            fillHandle: false,
                            // rowHeaders: true,
                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                cellProperties.className = PatientData[row].Status;
                                return cellProperties;
                            },
                            beforeChange: function (change, source) {
                                updateRemarks(change);
                            }
                        });
                        hot1.render();
                        hot1.selectCell(0, 0);

                        //if (PatientData.length > 0)
                        //    SearchInvestigation(PatientData[0].ledgerTransactionNO);
                        $("#btnSearch").removeAttr('disabled').val('Search');

                        $modelUnBlockUI();
                        CallFancyBox();
                        //return;
                    }
                },
                error: function (xhr, status) {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    $modelUnBlockUI();
                    $('#divPatient').html('');
                    toast("Error", 'Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
            // ManageDivHeight();
        }


        function updateRemarks(change) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            UpdateBarcodes(change[0][0], change[0][3]);
            <%}
            %>
                <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                  {%>
            SaveRemarksStatus(change[0][0], change[0][3]);
                <%}
            %>
        }
        function SaveRemarksStatus(row, _remarks) {

            //var TestIDWithLedgerTransactionNo = e.target.id;
            console.log(row);
            var TestID = PatientData[row].Test_ID;
            var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
            //var Remarks = PatientData[row].RemarkStatus;
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/SaveRemarksStatus",
                data: '{ TestID: "' + TestID + '",Remarks:"' + _remarks + '",LedgerTransactionNo:"' + LedgerTransactionNo + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == '1') {
                        toast("Success", 'Remarks Status Saved.');
                    }
                    if (result == '-1') {
                        toast("Error", 'Remarks Status Not Saved.');
                    }
                },
                error: function (xhr, status) {
                }
            });

        }

        function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<a target="_blank" id="aa" href="../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[row].Test_ID + '&LabNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../App_Images/view.GIF" style="border-style: none" alt="">     </a>';
            return td;
        }
        function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
            var MyStr1 = "";
            if (PatientData[row].DocumentStatus != "") {
                MyStr1 = MyStr1 + '<a target="_blank" id="mm"  href="../Lab/ShowAttachment.aspx?labno=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../App_Images/attachment.png" style="border-style: none" alt=""></a>';
            }
            td.innerHTML = MyStr1;
            return td;
        }

        ///Bilal
        function TATStatus(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span></span>';//td.innerHTML   
            if (PatientData[row].TATDelay == "1") {
                MyStr = '<span style="color:white;font-weight:bold;font-size:10px;">Outside TAT</span>';
                td.style.background = 'red';
            }
            else if (PatientData[row].TATIntimate == "1") {
                MyStr = '<span style="color:black;font-weight:bold;font-size:10px;">Near TAT</span>';
                td.style.background = 'yellow';
            }
            else {
                MyStr = '<span style="color:white;font-weight:bold;font-size:10px;">Within TAT</span>';
                td.style.background = 'green';
            }
            td.innerHTML = MyStr;
            return td;
        }

        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML              
            if (PatientData[row].RemarkStatus != "") {
                MyStr = MyStr + '<img src="../../App_Images/Remark.jpg" style="width:20px; Height:25px" alt=' + PatientData[row].RemarkStatus + '/>';

            }
            if (PatientData[row].Urgent == 'Y') {
                MyStr = MyStr + '<img title="Urgent" src="../../App_Images/urgent.gif"/>';
            }
            if (PatientData[row].TATDelay == "1") {
                MyStr = MyStr + '<img title="TATDelay" src="../../App_Images/tatdelay.gif" />';
            }
            if (PatientData[row].CombinationSample == "1") {
                MyStr = MyStr + '<img title="CombinationSample" src="../../App_Images/Red.jpg" style="width:13px; Height:13px;border-radius: 10px;"  />';
            }
            if (PatientData[row].Comments != "") {
                MyStr = MyStr + '<img title="Comments" src="../../App_Images/comments.png" style="width:25px;height:25px;" alt="Comments" />';
            }

            if (PatientData[row].SampleLocation != '')
                td.innerHTML = MyStr + '<br/>' + PatientData[row].SampleLocation;
            else
                td.innerHTML = MyStr;

            td.className = PatientData[row].Status;
            return td;
        }
        function EnableBarcode(instance, td, row, col, prop, value, cellProperties) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            cellProperties.readOnly = false;
                <%}%>
            td.innerHTML = value;
            td.className = PatientData[row].Status;
            return td;
        }
        function PrintreportRenderer(instance, td, row, col, prop, value, cellProperties) {
            var PHeader = $("#chkheader").is(':checked') ? 1 : 0;
            if (PatientData[row].Approved == "1") {
                // var escaped = Handsontable.helper.stringify(value);
                //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                td.innerHTML = '<a href="labreportmicro.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&PHead='+ PHeader +'target="_blank" > <img  src="../../App_Images/print.gif" style="border-style: none" alt="">     </a>';
                //  td.id = value.replace(/,/g, "_");
            }
            else {
                td.innerHTML = '<span>&nbsp;</span>';
            }
            td.className = PatientData[row].Status;
            return td;
        }

        function SampleIconRenderer(instance, td, row, col, prop, value, cellProperties) {


            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            td.innerHTML = '<a target="_blank" id="aa" href="SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../App_Images/Sample.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            // td.style.background = PatientData[row].Status;
            return td;
        }
        function RemarksFieldRenderer(instance, td, row, col, prop, value, cellProperties) {
            // var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            //  td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="../OPD/AddRemarks_PatientTestPopup.aspx?TestID=' + PatientData[row].Test_ID + '&Name=' + PatientData[row].PName + '&LabNo=' + PatientData[row].LedgerTransactionNo + '"  > <img  src="../../App_Images/edit.png" style="border-style: none" alt="">     </a>';
            //td.id = value.replace(/,/g, "_");
            td.innerHTML = '<input type="text" onkeydown="SaveRemarksStatus(event,this);" id="' + PatientData[row].Test_ID + '#' + PatientData[row].LedgerTransactionNo + '" heght="150px;" value="' + PatientData[row].RemarkStatus + '">';
            td.className = PatientData[row].Status;
            return td;
        }

        function CallFancyBox() {
            //$(".various").fancybox();
            //$(".Remark").fancybox();
            $("#btnPatientDetail").click(function () {
                $("#various2").attr('href', '../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[currentRow].Test_ID + '&LabNo=' + PatientData[currentRow].LedgerTransactionNo);
                $("#various2").fancybox({
                    maxWidth: 860,
                    maxHeight: 600,
                    fitToView: false,
                    width: '70%',
                    height: '70%',
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
                $("#various2").trigger('click');

            });

            $("a.various").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });


            $("a.Remark").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $("a.PatientDetail").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $("a.ShowAttachment").fancybox({
                maxWidth: 860,
                maxHeight: 600,
                fitToView: false,
                width: '70%',
                height: '70%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
            $('#fancybox-content').css('padding-top', '15px');
            $('#fancybox-content').css('height', '500px');
            $('#fancybox-content').css('overflow-y', 'auto');

        }
        function ManageSampleStatus(row) {
            window.open('SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo, '_blank')
        }
        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {

                 <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                   {%>
            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            //td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
            td.innerHTML = '<a style="font-weight:bold;" href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> ' + PatientData[row].LedgerTransactionNo + '     </a>';
            td.id = value.replace(/,/g, "_");
            //td.style.backgroundColor = "none";
            $(td).addClass(cellProperties.className);
                <%}
                   else
                   {%>
            td.innerHTML = PatientData[row].LedgerTransactionNo;
                <%}%>
            return td;
        }
        function safeTestRenderer(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            td.innerHTML = '<span title="' + value + '" style="overflow: hidden;text-overflow: ellipsis;position: absolute;left: 0; right: 0;">' + value + '</span>';
            //td.id = value.replace(/,/g, "_");
            td.style.width = '200px';
            td.style.position = 'relative';
            $(td).addClass(cellProperties.className);
            return td;
        }
        function setHidden(instance, td, row, col, prop, value, cellProperties) {
            td.hidden = true;
            return td;
        }
        function ExitFullScreen() {
            $('#divInvestigation').removeClass('horizontal');
            $('#divInvestigation').addClass('vertical');
            $('#divPatient').removeClass('horizontal');
            $('#divPatient').addClass('vertical');
        }
        var rowIndx = "";
        function PickRowData(rowIndex) {
            debugger;
            rowIndx = rowIndex;

            //$("#divPatient tr > td").css("background", "#ffffff");
            //$("#divPatient tr:nth-child(" + (rowIndex+1) + ") > td").css("background", "rgb(189, 245, 245)");
            //ExitFullScreen();
            currentRow = rowIndex;
            // hot1.selectCell(currentRow + 1, 0);
            // hot1.selectCell(currentRow, 0);
            //console.log(rowIndex + 1);
            $('#MainInfoDiv').show();
            $('#divPatient').hide();
            _test_id = PatientData[rowIndex].Test_ID;
            _barcodeno = PatientData[rowIndex].BarcodeNo;

            var investicationId = PatientData[rowIndex].Investigation_ID;

            BindReportType(investicationId);
            debugger;
            var ddlreportnumber = $("#<%=ddlreportnumber.ClientID %> option").length;;
            debugger;

            if (ddlreportnumber == 1) {
                toast("Error", 'Preliminary and Final Report type not defined for this test<br/> Please Contact to Admin !!');

            }
              else {
                searchLabObservation(rowIndex, PatientData[rowIndex].PName, PatientData[rowIndex].Age_Gender, PatientData[rowIndex].LedgerTransactionNo, PatientData[rowIndex].Test_ID, PatientData[rowIndex].Gender, PatientData[rowIndex].AGE_in_Days, $('#<%=ddlreportnumber.ClientID%>').val());

                 }


                 }



        function BindReportType(investicationId) {
            var ddlreportnumber = $("#<%=ddlreportnumber.ClientID %>");

            $("#<%=ddlreportnumber.ClientID %> option").remove();


            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindReportno",
                data: '{ investicationId:"' + investicationId + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                  
                    var DdlSop = result.d;
                    var Value = DdlSop.split(',');

                    if (Value.length > 0) {
                        for (i = 0; i < Value.length; i++) {

                            ddlreportnumber.append($("<option></option>").val($.trim(Value[i])).html($.trim(Value[i])));
                        }


                    }
                    else {
                        toast("Error", 'You Have Not Selected Any Report Type Please Select From Master Page ');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function PicSelectedRow() {
            PickRowData(rowIndx);
        }

        function PreLabObs() {
            var minRows = 0;
            if (currentRow > minRows) {
                PickRowData(currentRow - 1);

            }
            else { $('#btnPreLabObs').attr("disabled", true); }
        }
        function NextLabObs() {
            var totalRows = PatientData.length - 1;

            //console.log(totalRows + '/' + currentRow);
            if (totalRows > currentRow) {

                PickRowData(currentRow + 1);
                //hot1.selectCell(currentRow, 1);
            }
            else { $('#btnNextLabObs').attr("disabled", true); toast("Error", 'No more rows available'); }
        }
        function searchLabObservation(_index, pname, age_gender, labNo, testId, gender, ageInDays, reportnumber) {
            $('.demo').attr('disabled', true);
            var macId = $('#<%=ddlTestDon.ClientID %> option:selected').val();
            LedgerTransactionNo = labNo;
            LoadInvName(LedgerTransactionNo);
            $('#SelectedPatientinfo').html('');
            $('#SelectedPatientinfo').append('' +
                '<table id="tblPatientInfo"><tr><th>SIN No:</th><td id="PatientBarcodeNo">' + PatientData[_index].BarcodeNo + '</td><th>Patient Name:</th><td>' + pname + '</td><th>Age/Gender:</th><td>' + age_gender + '</td></tr>' + '</td><th>DATE :</th><td>' + PatientData[_index].DATE + '</td></tr>' + '</td><th>Sample:</th><td>' + PatientData[_index].SampleTypeName + '</td></tr>' +
                '</table>');
            $('#divInvestigation').html('');
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/LabObservationSearch",
                data: '{LabNo:"' + labNo + '",TestID:"' + testId + '",AgeInDays:' + ageInDays + ',RangeType:"Normal",Gender:"' + gender + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",macId:"' + macId + '",reportnumber:"' + reportnumber + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                renderAllRows: true,
                mergeCells: true,
                success: function (result) {
                    $('.SampleStatus').hide();

                    $('#btnPreLabObs').attr("disabled", false);
                    $('#btnNextLabObs').attr("disabled", false);
                    LabObservationData = $.parseJSON(result.d);

                    if (LabObservationData == "-1") {
                        $('.btnForSearch').attr("disabled", true);
                        $modelUnBlockUI();
                        toast("Error", 'Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (LabObservationData.length == 0) {
                        $('.btnForSearch').attr("disabled", true);
                        $modelUnBlockUI();
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        return;
                    }
                    else {

                        UpdateSampleStatus(LabObservationData[0].mystatus);

                        $('#divantibody').hide();
                        $('#AntiBioTicList tr').slice(1).remove();

                        $('.demo').attr('disabled', false);
                        $('.SampleStatus').attr('disabled', false);
                        $("#<%=lblMsg.ClientID %>").text('');

                        var data = LabObservationData,
                         container2 = document.getElementById('divInvestigation');
                        hot2 = new Handsontable(container2, {
                            data: LabObservationData,
                            colHeaders: [
                                 "Test", "Value", "Unit", "Comment"
                            ],
                            columns: [
                            { data: 'LabObservationName', readOnly: false, renderer: LabObservationRender, width: 200 },
                            { data: 'Value', readOnly: false, renderer: CheckCellValue, width: 100 },
                            { data: 'ReadingFormat', readOnly: false },
                            { renderer: ShowComment },



                            ],
                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            rowHeaders: true,
                            readOnly: true,
                            fillHandle: false,
                            rowHeaders: false,
                            beforeChange: function (change, source) {
                                updateFlag(change);

                            },

                            cells: function (row, col, prop) {

                                if (LabObservationData[row].IsComment == "0") {
                                    if (prop === 'Value' && LabObservationData[row].Help != "" && LabObservationData[row].Approved == "0") {
                                        var val = LabObservationData[row].Value;
                                        var helpArr = [];
                                        var helpDropDown = [];
                                        try {
                                            helpArr = LabObservationData[row].Help.split('|');
                                            for (var i = 0; i < helpArr.length; i++) {
                                                var arr = [];
                                                arr = helpArr[i].split('#');
                                                helpDropDown.push(arr[0]);
                                            }
                                            this.type = 'autocomplete';
                                            this.source = helpDropDown;
                                            this.strict = false;
                                        }
                                        catch (e) {
                                        }
                                    }


                                }
                                else if (LabObservationData[row].IsComment == "1") {
                                    this.readOnly = true;
                                }

                                if (prop === 'Value' && LabObservationData[row].LabObservationName == "MicroScopy") {
                                    this.type = 'dropdown';
                                    this.source = ['Wet Mount', 'Gram Stain', 'AFB Stain', 'Other'];
                                    //if (elt.options[elt.selectedIndex].text == "Approved" || elt.options[elt.selectedIndex].text == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                                    //    this.readOnly = true;
                                    //}
                                    //else {
                                    //    this.readOnly = false;
                                    //}

                                }

                                if (LabObservationData[row].Inv == "3") {
                                    this.readOnly = true;
                                }



                            }
                        });
                        ApplyFormula();
                        hot2.selectCell(0, 1);

                        $modelUnBlockUI();
                        $('.btnForSearch').attr("disabled", false);

                        $('#<%=txtindate.ClientID%>').val(LabObservationData[0].incubationdate);
                        $('#<%=txtintime.ClientID%>').val(LabObservationData[0].incubationtime);
                        showantibiotic(LabObservationData[0].micro);


                    }
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    $('#divInvestigation').html('');
                    toast("Error", 'Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function checkDate(sender, args) {
            if (sender._selectedDate <= new Date()) {
                toast("Error", "You cannot select a day earlier than today!");
                sender._selectedDate = new Date();
                // set the date back to the current date

                $('#<%=txtindate.ClientID%>').val(sender._selectedDate.format(sender._format));
            }
        }
        function LoadInvName(LabNo) {
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/GetPatientInvsetigationsNameOnly",
                data: '{ LabNo:"' + LabNo + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    InvData = result.d;
                    $('.DivInvName').html(InvData);
                    $('.DivInvName').show();
                },
                error: function (xhr, status) {
                    toast("Error", "Error.... ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function LabObservationRender(instance, td, row, col, prop, value, cellProperties) {

            if (LabObservationData[row].Inv == "1") {
                if (LabObservationData[row].IsAttached != "") {
                    td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached;
                }
                else {

                    td.innerHTML = value;
                }
            }

            else {
                td.innerHTML = value;
            }
            td.style.background = LabObservationData[row].Status;
            td.style.width = '200px';

            if (LabObservationData[row].Inv == "1") {
                $(td).parent().addClass('InvHeader');
            }
            else if (LabObservationData[row].Inv == "3") {
                $(td).parent().addClass('DeptHeader');
            }
            else if (LabObservationData[row].Inv == "2") {


            }

            if (LabObservationData[row].Value == "HEAD") {
                $(td).parent().addClass('InvSubHead');
            }
            cellProperties.readOnly = true;
            return td;
        }
        function CheckCellValue(instance, td, row, col, prop, value, cellProperties) {

            if ((LabObservationData[row].Inv == "1") || (LabObservationData[row].Inv == "3")) {
                cellProperties.readOnly = true;
                td.innerHTML = '';

                return td;
            }
            else if (LabObservationData[row].Inv == "4") {
                cellProperties.readOnly = true;
                td.innerHTML = value;

                return td;
            }
            else if (LabObservationData[row].Inv == "2") {
                //if (elt.options[elt.selectedIndex].text == "Approved" || elt.options[elt.selectedIndex].text == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                //    cellProperties.readOnly = true;
                //}
                //else {
                //    cellProperties.readOnly = false;
                //}
                td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/ButtonAdd.png"/></span>';
                return td;
            }

            if (LabObservationData[row].IsComment == "0") {

                if (value == 'HEAD' || MYSampleStatus == "Approved" || MYSampleStatus == "Printed" || LabObservationData[row].IsSampleCollected != 'Y') {
                    cellProperties.readOnly = true;
                } else {
                    cellProperties.readOnly = false;
                }
                td.innerHTML = value;
            }
            else if (LabObservationData[row].IsComment == "1") {

                if (LabObservationData[row].Value == "")
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/ButtonAdd.png"/></span>';
                if (LabObservationData[row].Value != "")
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/Redplus.png"/></span>';
            }
            if (LabObservationData[row].LabObservation_ID == "1529" )//organism page
            {
                td.innerHTML = '<img  src="../../App_Images/edit.png" style="border-style: none;cursor:pointer;" alt="" onclick="viewobsdata(' + LabObservationData[row].Test_ID + ',' + LabObservationData[row].Investigation_ID + ')">';
                cellProperties.readOnly = true;
            }

                //td.innerHTML = '<a target="_blank" id="cc" class="iframe Remark" href="LabResultEntryNew_Micro.aspx?TestID=' + LabObservationData[row].Test_ID + '&LabNo=' + LabObservationData[row].LabNo + '&InvId=' + LabObservationData[row].Investigation_ID + '"  > <img  src="../../App_Images/edit.png" style="border-style: none" alt="">     </a>';
                //td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/ButtonAdd.png"/></span>';
            else if (LabObservationData[row].ReportType != "1") {
                td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/ButtonAdd.png"/></span>';

            }
            return td;
        }
        function changeColor(instance, td, row, col, prop, value, cellProperties) {


            if (LabObservationData[row].Inv > 0) {
                td.innerHTML = value;
                return td;
            }


            isRed = 0;
            var MinRange = LabObservationData[row].MinValue;
            var MaxRange = LabObservationData[row].MaxValue;
            var Value = LabObservationData[row].Value;
            if (Value == "") {
                LabObservationData[row].Flag = '';
                value = '';
            }
            else {
                if (MinRange != "") {
                    if (parseFloat(Value) < parseFloat(MinRange)) {
                        isRed = 1;
                        LabObservationData[row].Flag = 'Low';
                        value = 'Low';
                    }
                    else {
                        LabObservationData[row].Flag = 'Normal';
                        value = 'Normal';
                    }
                }

                if (isRed == 0 && MaxRange != "") {
                    if (parseFloat(Value) > parseFloat(MaxRange)) {

                        LabObservationData[row].Flag = 'High';
                        value = 'High';
                    }
                    else {
                        LabObservationData[row].Flag = 'Normal';
                        value = 'Normal';
                    }
                }
            }
            if (value == "Low") {
                td.style.background = 'rgb(251, 255, 0)';
                $(td).parent().addClass('FullRowColorInYellow');
            }
            else if (value == "High") {
                td.style.background = 'pink';
                $(td).parent().addClass('FullRowColorInPink');
            }
            td.innerHTML = value;

            return td;
        }


        function viewobsdata(testid, invid) {
            $('#divantibody').show();

        }

        function ShowComment(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            if (LabObservationData[row].ReportType == "1" && LabObservationData[row].IsComment == "1") {
                td.innerHTML = '';
            }
            else if (LabObservationData[row].ReportType != "1") {
                td.innerHTML = '';
            }
            else if (LabObservationData[row].LabObservationName == "Organism Tables")
                td.innerHTML = '';
            else {
                td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../App_Images/ButtonAdd.png"/></span>';
            }
            return td;
        }
        function ShowModalWindow(row, col, prop, value) {

            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData('');
            console.log(LabObservationData[row].Description);
            if (prop != "Value") {
                $('#CommentHead').html('Comments');
                $('#CommentBox').show();
                CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                $('.modal-footer').html('<h3 style="height: 20px;">' +
                    '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                    '<div style="float: right;">' +
                    '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                    '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                    '</div></h3>');
                modal.style.display = "block";

                loadObservationComment(row, col, prop, value);
            } else if (prop == "Value") {

                if (LabObservationData[row].ReportType == "1") {

                    $('#CommentHead').html('Comments');
                    $('#CommentBox').show();
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                    $('.modal-footer').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                        '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');
                    modal.style.display = "block";
                    loadObservationComment(row, col, prop, value);

                }
                else if (LabObservationData[row].ReportType == "3" || LabObservationData[row].ReportType == "5") {

                    $('#CommentHead').html('Templates');
                    $('#CommentBox').show();
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                    $('.modal-footer').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                        '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');

                    BindTemplateValue(row, col, prop, value);


                    loadObservationComment(row, col, prop, value);
                }
                else {

                    $('#CommentHead').html('Comment');
                    $('#CommentBox').show();
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                    $('.modal-footer').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                        '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');
                    loadObservationComment(row, col, prop, value);
                }

            modal.style.display = "block";
        }
}
function BindTemplateValue(row, col, prop, value) {
    if (LabObservationData[row].Method == 1)
        return;
    $.ajax({
        url: "MachineResultEntry_Culture.aspx/Getpatient_labobservation_opd_text",
        data: '{ TestId:"' + LabObservationData[row].LabObservation_ID + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            LabObservationData[row].Method = 1;
            LabObservationData[row].Description = result.d;
            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);
        },
        error: function (xhr, status) {
            toast("Error", "Error.... ");
        }
    });
}
function loadObservationComment(row, col, prop, value) {
    $('#ddlCommentsLabObservation').attr('title', prop);
    if (prop == 'Value') {
        var labobservationid = LabObservationData[2].Test_ID;
    }
    else {
        var labobservationid = LabObservationData[2].LabObservation_ID;
    }
    $.ajax({

        url: "MachineResultEntry_Culture.aspx/Comments_LabObservation",
        data: '{ LabObservation_ID:"' + labobservationid + '",Type:"' + prop + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            result = $.parseJSON(result.d);
            $("#ddlCommentsLabObservation").empty();
            $("#ddlCommentsLabObservation").append("<option value=''>Select</option>");
            if (prop == 'Value') {
                for (var i = 0; i < result.length; i++) {
                    var newOption = "<option value=" + result[i].Template_ID + ">" + result[i].Temp_Head + "</option>";
                    $("#ddlCommentsLabObservation").append(newOption);
                }
            }
            else {
                for (var i = 0; i < result.length; i++) {
                    var newOption = "<option value=" + result[i].Comments_ID + ">" + result[i].Comments_Head + "</option>";
                    $("#ddlCommentsLabObservation").append(newOption);
                }
            }
        },
        error: function (xhr, status) {
            toast("Error", "Error.... ");
        }
    });

}


function ddlCommentsLabObservation_Load(CommentID) {
    var type = $('#ddlCommentsLabObservation').attr('title');
    $.ajax({
        url: "MachineResultEntry_Culture.aspx/GetComments_labobservation",
        data: '{ CmntID:"' + CommentID + '",type:"' + type + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);
        },
        error: function (xhr, status) {
            toast("Error", "Error.... ");
        }
    });

    }

    function ClearComment()
    { CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(''); }
    function CancelComment()
    { modal.style.display = "none"; }
    function AddComment(rowValue, prop) {
        var commentValue = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].getData();
        //if (prop == 'Value') {

        //    LabObservationData[rowValue].Value = commentValue;
        //}
        //else {

        //    LabObservationData[rowValue].Description = commentValue;
        //}
        LabObservationData[rowValue].Description = commentValue;
        if (LabObservationData[rowValue].IsComment == 1) {
            //LabObservationData[rowValue].Description = commentValue;
            //LabObservationData[rowValue].Value = 'Reported';

        }
        modal.style.display = "none";
    }
    var isRed = 0;
    function updateFlag(change) {
        var myarr = [];
        myarr = change;
        isRed = 0;
        if (myarr != null) {
            var row = change[0][0];
            var col = change[0][1];
            var old = change[0][2];
            var newvalue = change[0][3];

            var MinRange = LabObservationData[row].MinValue;
            var MaxRange = LabObservationData[row].MaxValue;
            var Value = newvalue;
            if (col == 'Value') { LabObservationData[row].Value = newvalue; }
            else if (col == 'MinValue') { LabObservationData[row].MinValue = newvalue; }
            else if (col == 'MaxValue') { LabObservationData[row].MaxValue = newvalue; }
            else if (col == 'PrintMethod') { LabObservationData[row].PrintMethod = newvalue; }
            else if (col == 'ReadingFormat') { LabObservationData[row].ReadingFormat = newvalue; }
            else if (col == 'Flag') { LabObservationData[row].Flag = newvalue; }
            if (col == 'Value') {
                if (isNaN(newvalue) || newvalue == "" || newvalue == "HEAD") {
                    LabObservationData[row].Flag = '';
                }
                else {
                    if (MinRange != "") {
                        if (parseFloat(Value) < parseFloat(MinRange)) {
                            isRed = 1;
                            LabObservationData[row].Flag = 'Low';
                        }
                        else {
                            LabObservationData[row].Flag = 'Normal';
                        }
                    }

                    if (isRed == 0 && MaxRange != "") {
                        if (parseFloat(Value) > parseFloat(MaxRange)) {
                            LabObservationData[row].Flag = 'High';
                        }
                        else {
                            LabObservationData[row].Flag = 'Normal';
                        }
                    }
                    ApplyFormula();
                }
            }
        }
    }
    function ApplyFormula() {

        for (var i = 0; i < LabObservationData.length; i++) {


            if (LabObservationData[i].Inv == '0') {
                //console.log(LabObservationData[i].LabObservation_ID.Value);
                LabObservationData[i].isCulture = LabObservationData[i].Formula;
                // LabObservationData[i].isCulture=LabObservationData[i].isCulture.replace((LabObservationData[i].LabObservation_ID+"@"),LabObservationData[i].Value);
                //alert(LabObservationData[i].isCulture);

                if (LabObservationData[i].isCulture != '') {
                    for (var j = 0; j < LabObservationData.length; j++) {
                        try {
                            if (LabObservationData[j].Inv == '0')
                                LabObservationData[i].isCulture = LabObservationData[i].isCulture.replace(new RegExp("#" + (LabObservationData[j].LabObservation_ID + "@"), 'g'), LabObservationData[j].Value);
                        }
                        catch (e) {
                        }

                    }

                    try {
                        LabObservationData[i].Value = Math.round(eval(LabObservationData[i].isCulture) * 100) / 100;
                    } catch (e) { LabObservationData[i].Value = '' }
                    var ans = LabObservationData[i].Value;
                    if ((isNaN(ans)) || (ans == "Infinity") || (ans == 0)) {
                        LabObservationData[i].Value = '';
                    }

                }
            }
        }
    }
    function UnForward() {
        resultStatus = "Un Forward";
        SaveLabObs();
    }

    function Forward() {
        //resultStatus = "Forward";

        $("#<%=ddltest.ClientID %> option").remove();
            var ddlTest = $("#<%=ddltest.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindTestToForward",
                data: '{ testid: "' + PatientData[currentRow].Test_ID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    Tdata = $.parseJSON(result.d);
                    for (i = 0; i < Tdata.length; i++) {

                        ddlTest.append($("<option></option>").val(Tdata[i]["test_id"]).html(Tdata[i]["name"]));
                    }

                },
                error: function (xhr, status) {



                }
            });


            $("#<%=ddlcentre.ClientID %> option").remove();
            var ddlcentre = $("#<%=ddlcentre.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindCentreToForward",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    Cdata = $.parseJSON(result.d);
                    for (i = 0; i < Cdata.length; i++) {

                        ddlcentre.append($("<option></option>").val(Cdata[i]["centreid"]).html(Cdata[i]["centre"]));
                    }

                },
                error: function (xhr, status) {



                }
            });

            binddoctoforward();

            $find('ModalPopupExtender2').show();

            //SaveLabObs();
        }

        function binddoctoforward() {
            $("#<%=ddlforward.ClientID %> option").remove();
            var ddlforward = $("#<%=ddlforward.ClientID %>");
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/BindDoctorToForward",
                data: '{centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '"}', // parameter map 
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {

                Fdata = $.parseJSON(result.d);
                for (i = 0; i < Fdata.length; i++) {

                    ddlforward.append($("<option></option>").val(Fdata[i]["employeeid"]).html(Fdata[i]["Name"]));
                }

            },
            error: function (xhr, status) {



            }
        });
    }
    function Forwardme() {


        var length1 = $('#<%=ddltest.ClientID %>  option').length;
            if ($("#<%=ddltest.ClientID %> option:selected").val() == "" || length1 == 0) {
                toast("Error", "Please Select Test");
                $("#<%=ddltest.ClientID %>").focus();
                return;
            }
            var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
            if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {
                toast("Error", "Please Select Centre");
                $("#<%=ddlcentre.ClientID %>").focus();
                return;
            }

            var length3 = $('#<%=ddlforward.ClientID %>  option').length;


            if ($("#<%=ddlforward.ClientID %> option:selected").val() == "" || length3 == 0) {
                toast("Error", "Please Select Doctor to Forward");
                $("#<%=ddlforward.ClientID %>").focus();
                return;
            }


            $.ajax({
                url: "MachineResultEntry_Culture.aspx/ForwardMe",
                data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        toast("Success", "Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());

                        $find('ModalPopupExtender2').hide();

                        var totalRows = PatientData.length - 1;
                        if (totalRows > currentRow) {

                            PickRowData(currentRow + 1);

                        }
                        else {
                            PickRowData(currentRow);
                        }

                    }
                    else {
                        toast("Error", result.d);


                    }
                },
                error: function (xhr, status) {



                }
            });

        }
        function NotApproved() {
            $('#<%=txtnotappremarks.ClientID%>').val('');
            $find('mpnotapprovedrecord').show();
            $('#<%=txtnotappremarks.ClientID%>').focus();

            //resultStatus = "Not Approved";
            //SaveLabObs();
        }

        function NotApprovedFinaly() {
            if ($('#<%=txtnotappremarks.ClientID%>').val() == "") {
                $('#<%=txtnotappremarks.ClientID%>').focus();
                toast("Error", "Please Enter Not Approved Remarks");
                return;
            }
            $find('mpnotapprovedrecord').hide();
            resultStatus = "Not Approved";
            SaveLabObs();

        }


        function Approved() {

            //viewremarks();
            resultStatus = "Approved";
            SaveLabObs();
        }
        function Preliminary() {
            resultStatus = "Preliminary Report";
            SaveLabObs();
        }
        function Save() {
            resultStatus = "Save";
            SaveLabObs();
        }
        function UnHold() {
            resultStatus = "UnHold";
            SaveLabObs();
        }
        function Hold() {
            $find('mpHoldRemarks').show();
        }


        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpHoldRemarks')) {
                    closeHoldRemarks();
                }
            }
        }


        function closeHoldRemarks() {
            $("#txtHoldRemarks").val('');
            $find('mpHoldRemarks').hide();
            $("#spnHoldRemarks").text('');
            $("#btnHoldRemarks").removeAttr('disabled').val('Save');
        }
        function saveHoldRemarks() {
            if ($.trim($("#txtHoldRemarks").val()) != "") {
                $("#btnHoldRemarks").attr('disabled', 'disabled').val('Submitting...');
                resultStatus = "Hold";
                SaveLabObs();
                $("#spnHoldRemarks").text('');
            }
            else {
                $("#spnHoldRemarks").text('Please Enter Remarks');
                $("#txtHoldRemarks").focus();
            }

        }


        function SaveApproved() {

            if ($('#<%=ddlapptype.ClientID%> option:selected').text() == 'Select') {

                toast("Error", "Please Select Approval Type");
                $('#<%=ddlapptype.ClientID%>').focus();
                    return;
                }

                if ($('#<%=ddlapptype.ClientID%> option:selected').text() == "Final") {
                resultStatus = "Approved";
            }
            else {
                resultStatus = "InterimApproved";
            }

            SaveLabObs();
            unloadPopupBox();

        }
        function viewremarks() {


            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });

        }
        function unloadPopupBox() {    // TO Unload the Popupbox

            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });
        }


        function SaveLabObs() {
            var antibioticdatetosave = antibioticdate();

            var reportnumber = $('#<%=ddlreportnumber.ClientID%>').val();

                var notapprovalcomment = "";

                if (resultStatus == "Not Approved")
                    notapprovalcomment = $.trim($("#<%=txtnotappremarks.ClientID%>").val());

            var HoldRemarks = "";
            if (resultStatus == "Hold")
                HoldRemarks = $.trim($("#txtHoldRemarks").val());


            $.ajax({
                url: "MachineResultEntry_Culture.aspx/SaveLabObservationOpdData",
                //string ApprovedBy,string ApprovalName
                data: JSON.stringify({ reportnumber: reportnumber, antibioticdata: antibioticdatetosave, data: LabObservationData, ResultStatus: resultStatus, ApprovedBy: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%>').val() : ''), ApprovalName: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%> :selected').text() : ''), HoldRemarks: HoldRemarks, notapprovalcomment: notapprovalcomment }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    if (result.d == 'success') {
                        toast('Success', 'Successfully Saved');

                        var totalRows = PatientData.length - 1;
                        if (totalRows > currentRow) {

                            PickRowData(currentRow + 1);

                        }
                        else {
                            PickRowData(currentRow);
                        }
                    }
                    else {

                        toast('Error', result.d);

                    }

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    var err = eval("(" + xhr.responseText + ")");
                    toast('Error', err.Message);


                    //alert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function PrintReport() {
            var PHeader = $("#chkheader").is(':checked') ? 1 : 0;
            window.open('labreportmicro.aspx?IsPrev=1&TestID=' + PatientData[currentRow].Test_ID + ',&PHead='+ PHeader +'&reportnumber=' + $('#<%=ddlreportnumber.ClientID%>').val());
        }
        function UpdateBarcodes(row, _barcode) {
            console.log(row);
            var TestID = PatientData[row].Test_ID;
            var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
            $.ajax({
                url: "MachineResultEntry_Culture.aspx/UpdateLabInvestigationOpdData",
                data: '{ TestID: "' + TestID + '",Barcode:"' + _barcode + '",LedgerTransactionNo:"' + LedgerTransactionNo + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "success") {
                        toast("Success", 'Successfully Updated');
                    }
                    if (result == "duplicate") {
                        toast("Error", 'Vial ID Already  Exit..');
                    }

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();

                    toast("Error", 'Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        //vartika code end




        function SearchInvestigation(LabNo) {

            $modelBlockUI();


            //$('.btnDiv').children().attr("disabled", "disabled");
            $.ajax({
                url: "SampleCollectionPatient.aspx/SearchInvestigation",
                data: '{ LabNo: "' + LabNo + '", SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    PatientData = $.parseJSON(result.d);
                    // $('.demo').attr('disabled', '');
                    if (PatientData == "-1") {
                        $modelUnBlockUI();
                        toast("Error", 'Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.length == 0) {
                        $modelUnBlockUI();
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        return;
                    }
                    else {

                        var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                        $('#divInvestigation').html(output);
                        $('.chkSample').each(function () {
                            this.checked = true;
                        });
                        $modelUnBlockUI();



                    }

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();

                    toast("Error", 'Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function SaveSampleCollection(Type) {


            var ItemData = "";
            var BarcodeID = "";
            $("#tb_SearchInvestigations tr").find(':checkbox').filter(':checked').each(function () {
                var TestID = $(this).closest("tr").attr("id");

                var $rowid = $(this).closest("tr");
                if (TestID != "Header") {
                    ItemData += $(this).closest('tr').attr('id') + '#';
                    BarcodeID += $(this).closest('tr').attr('id').split('_')[0] + ',';

                }

            });
            if (ItemData == "") {
                toast("Error", "Please Select Sample First..!");
                return;
            }
            //  alert(BarcodeID);
            $modelBlockUI();
            $.ajax({
                url: "SampleCollectionPatient.aspx/SaveSampleCollection",
                data: '{ ItemData:"' + ItemData + '",Type:"' + Type + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "-1") {
                        $modelUnBlockUI();
                        toast("Error", "Your Session Expired...Please Login Again");

                        return;
                    }
                    if (result == "0") {
                        $modelUnBlockUI();
                        toast("Error", "Record Not Save...");
                        return;
                    }
                    if (result == "1") {
                        $modelUnBlockUI();
                        getBarcode('', BarcodeID);
                        //alert("Record Saved Successfully...");
                        return;
                    }
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    toast("Error", "Please Contact to ItDose Support Team");

                }


            });
        }


        function getBarcode(_LabNo, _Test_ID) {
            $.ajax({
                url: "SampleCollectionPatient.aspx/getBarcode",
                data: '{ LabNo:"' + _LabNo + '",TestID:"' + _Test_ID + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result != '')
                        window.location = 'barcode://?test=1&cmd=' + result;
                },
                error: function (xhr, status) {

                    toast("Error", "Please Contact to ItDose Support Team");

                }


            });
        }
        $(function () {


            $("#divimgpopup").dialog({
                title: 'Crop Image',
                autoOpen: false,
                modal: true,
                width: '500'

            });
            $("#file_upload").uploadify({
                'height': 15,
                'swf': '../../Scripts/uploadify/uploadify.swf',
                'uploader': '../../Scripts/uploadify/FileUpload.aspx?name=' + getCurrentDateData(),
                'onUploadSuccess': function (file, data, response) {
                    image = file;

                    ImgTag = '<img id="bigimg" border="0"  src="../../Uploads/' + Year + '/' + Month + '/' + formattedDate + '_' + file.name + '"  />';
                    //            ImgTag = "<img border='0'  src='../../Uploads/'"+Year+'/'+Month+'/'+formattedDate+'_'+file.name +'"  />';
                    $("#imgpopup").html(ImgTag);
                    $("#divimgpopup").dialog('open');

                    $("#bigimg").Jcrop({
                        onChange: storeCoords,
                        onSelect: storeCoords

                    });


                    //            editor1.PasteHTML(ImgTag);


                }
            });
        });

        function storeCoords(c) {

            $('#<%=X.ClientID%>').val(c.x);

            $('#<%=Y.ClientID%>').val(c.y);

            $('#<%=W.ClientID%>').val(c.w);

            $('#<%=H.ClientID%>').val(c.h);

        };
        function getCurrentDateData() {
            var d = new Date()
            formattedDate = guid();
            return formattedDate;

        }

        function guid() {
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
              s4() + '-' + s4() + s4() + s4();
        }

        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000)
              .toString(16)
              .substring(1);
        }
        function crop() {

            if ($("#<%=W.ClientID%>").val() == "" || $("#<%=H.ClientID%>").val() == "" || $("#<%=X.ClientID%>").val() == "" || $("#<%=Y.ClientID%>").val() == "") {
                ImgTag = '<img  src="' + $("#bigimg").attr("src") + '"  />';
                var objEditor = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'];
                objEditor.focusManager.focus();
                objEditor.insertHtml(ImgTag);

                $("#divimgpopup").dialog('close');
            }
            else {

                $.ajax({
                    url: "Services/PatientLabSearch.asmx/Crop",
                    data: '{ W: "' + $("#<%=W.ClientID %>").val() + '",H: "' + $("#<%=H.ClientID %>").val() + '",X: "' + $("#<%=X.ClientID %>").val() + '",Y:"' + $("#<%=Y.ClientID %>").val() + '",ImgPath:"' + $("#bigimg").attr("src") + '"}', // parameter map 
                   type: "POST", // data has to be Posted    	        
                   contentType: "application/json; charset=utf-8",
                   timeout: 120000,
                   dataType: "json",
                   success: function (result) {
                       console.log(result);
                       ImgTag = '<img  src="' + result + '"  />';
                       var objEditor = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'];
                        objEditor.focusManager.focus();
                        objEditor.insertHtml(ImgTag);
                        $("#divimgpopup").dialog('close');
                        toast("Success", "Cropped Successfully.");
                        $('#<%=X.ClientID%>').val('');

                        $('#<%=Y.ClientID%>').val('');

                        $('#<%=W.ClientID%>').val('');

                        $('#<%=H.ClientID%>').val('');
                    },
                   error: function (xhr, status) {
                       toast("Error", "Error..");
                   }
               });
            }
        }

    </script>


    <script type="text/javascript">
        $(function () {
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#ddlInvestigation")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  $("#theHidden").val('');
              })
              .autocomplete({

                  source: function (request, response) {
                      $.getJSON("../Common/json.aspx?cmd=investigation", {
                          term: extractLast(request.term)
                      }, response);
                  },
                  search: function () {
                      // custom minLength
                      var term = extractLast(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {

                      $("#theHidden").val(ui.item.id)

                      var terms = split(this.value);
                      // remove the current input
                      terms.pop();
                      // add the selected item
                      terms.push(ui.item.value);
                      // add placeholder to get the comma-and-space at the end
                      //terms.push("");
                      this.value = terms;
                      return false;
                  }
              });
        });
        $(function () {
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#ddlPanel")
              // don't navigate away from the field on tab when selecting an item
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  $("#pnlHidden").val('');
              })
              .autocomplete({

                  source: function (request, response) {
                      $.getJSON("../Common/json.aspx?cmd=Panel&CentreId=" + $('#<%=ddlCentreAccess.ClientID%>').val(), {
                          term: extractLast(request.term)
                      }, response);
                  },
                  search: function () {
                      // custom minLength
                      var term = extractLast(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {

                      $("#pnlHidden").val(ui.item.id)

                      var terms = split(this.value);
                      // remove the current input
                      terms.pop();
                      // add the selected item
                      terms.push(ui.item.value);
                      // add placeholder to get the comma-and-space at the end
                      //terms.push("");
                      this.value = terms;
                      return false;
                  }
              });
        });
    </script>



    <%-- Micro Saving--%>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function _showhideList(ctr, ctr1) {


            if ($('.helpselect').css('display') == 'none') {
                $('.helpselect').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 100 }).show();
                $('.helpselect').attr("id", "help_" + ctr + "_" + ctr1);
                $('.helpselect :first-child').attr('selected', true);
            } else {
                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
                $('.helpselect').prop('selectedIndex', 0);
            }

        }

        function _showhideList1(myctrl, event, ctr, ctr1) {

            var position = $(myctrl).position();

            if (event.keyCode == 13) {


                if ($('.helpselect').css('display') == 'none') {

                    $('.helpselect').css({ 'top': parseInt(position.top) + 22, 'left': parseInt(position.left) }).show();
                    $('.helpselect').attr("id", "help_" + ctr + "_" + ctr1);
                    $('.helpselect').focus();
                    $('.helpselect :first-child').attr('selected', true);

                } else {
                    $('.helpselect').hide();
                    $('.helpselect').removeAttr("id");
                    $('.helpselect').prop('selectedIndex', 0);
                }
                $find('ModalPopupExtender2').hide();

                $find('mpnotapprovedrecord').hide();
            }
        }

        function addtotext(obj) {

            var id = $(obj).attr("id");
            var mm = id.split('_')[1] + '_' + id.split('_')[2];
            $('.' + mm).val($(obj).val());
            $('.' + mm).focus();

            $('.helpselect').hide();
            $('.helpselect').removeAttr("id");
        }

        function addtotext1(obj, event) {
            $find('ModalPopupExtender2').hide();

            $find('mpnotapprovedrecord').hide();
            if (event.keyCode == 13) {

                var id = $(obj).attr("id");
                var mm = id.split('_')[1] + '_' + id.split('_')[2];
                $('.' + mm).val($(obj).val());
                $('.' + mm).focus();

                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");


            }
        }




        function AddAntibotic() {

            if ($('#ContentPlaceHolder1_ddlOrganism option:selected').val() != "0") {

                if ($('.' + $('#ContentPlaceHolder1_ddlOrganism option:selected').val()).length > 0) {
                    toast("Error", $('#ContentPlaceHolder1_ddlOrganism option:selected').text() + ' Already Added !!');
                    $("#ContentPlaceHolder1_ddlOrganism").prop('selectedIndex', 0);
                    return;
                }



                $.ajax({
                    url: "MachineResultEntry_culture.aspx/BindobsAntibiotic",
                    data: '{ obid:"' + $('#ContentPlaceHolder1_ddlOrganism option:selected').val() + '",obname:"' + $('#ContentPlaceHolder1_ddlOrganism option:selected').text() + '",testid:"' + _test_id + '",Barcodeno:"' + _barcodeno + '",reportnumber:"' + $('#<%=ddlreportnumber.ClientID%>').val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        Obsrow = $.parseJSON(result.d);

                        if (Obsrow.length > 0) {
                            var mydata = '<tr class=' + Obsrow[0].obid + ' id="ObservationName" style="background-color:gold;">';
                            mydata += '<td class="GridViewLabItemStyle"></td>';
                            mydata += '<td class="GridViewLabItemStyle" colspan="6" style="font-weight:bold;font-size:15px;" id="tdAntiName" >' + Obsrow[0].obname;
                            mydata += '&nbsp;&nbsp;&nbsp;<input type="button" onclick="removecurrentorganism(this)" value="Remove"  style="cursor:pointer;background-color:red;color:white;font-weight:bold;" />';
                            var t1 = "txtcolonycount_" + Obsrow[0].obid;
                            var t2 = "txtcolonycountcomment_" + Obsrow[0].obid;
                            var t3 = "txtobsdisplayname_" + Obsrow[0].obid;
                            mydata += '<br/><strong style="font-size:12px;background-color:aqua;">Organism Display Name:</strong><input id=' + t3 + ' type="text" value="' + Obsrow[0].OrganismNameDisplayname + '" style="width:350px;font-size:12px;" class="OrganismNameDisplayname" /> ';

                            mydata += '<br/><input type="text" id=' + t1 + ' class="colonycount" placeholder="Colony Count" style="width:100px;" value="' + Obsrow[0].colonycount + '" /> ';
                            mydata += '<input type="text" id=' + t2 + ' class="colonycountcomment" placeholder="Comment" style="width:552px;" value="' + Obsrow[0].colonycountcomment + '" />';
                            mydata += "</td></tr>";
                            $('#AntiBioTicList').append(mydata);

                            for (var i = 0; i <= Obsrow.length - 1; i++) {


                                var mydata = '<tr class=' + Obsrow[i].obid + ' id=' + Obsrow[i].id;
                                if (Obsrow[i].id == "0") {

                                    mydata += ' style="background-color:chartreuse;" ';
                                }

                                mydata += ' > ';
                                mydata += '<td class="GridViewLabItemStyle">';
                                if (Obsrow[i].id == "0") {

                                    mydata += ' <a href="javascript:void(0);" onclick="deletemeplz($(this));"><img src="../../App_Images/Delete.gif"/></a> ';
                                }
                                else {

                                    mydata += parseInt(i + 1);
                                }
                                mydata += '</td>';


                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" >' + Obsrow[i].name + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + Obsrow[i].obid + '\',\'' + Obsrow[i].id + '\')"  class=' + Obsrow[i].obid + '_' + Obsrow[i].id + ' type="text" id="txtvalue" style="width:90px;" value="' + Obsrow[i].VALUE + '" />  <img id="imghelp" onclick="_showhideList(\'' + Obsrow[i].obid + '\',\'' + Obsrow[i].id + '\')" src="../../App_Images/question_blue.png" /></td>';
                                mydata += '<td class="GridViewLabItemStyle"><input type="text" onkeyup="calculatebp(this)" id="txtmic" style="width:60px;" value="' + Obsrow[i].mic + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtbreakpoint" value="' + Obsrow[i].breakpoint + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtmicbreak" value="' + Obsrow[i].mic_bp + '" /></td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup">' + Obsrow[i].AntibioticGroupName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + Obsrow[i].id + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;">' + Obsrow[i].AntibioticGroupID + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + Obsrow[i].obname + '</td>';
                                mydata += "</tr>";
                                $('#AntiBioTicList').append(mydata);

                            }
                            jj = jj + 1;
                            var ss = "new" + jj;
                            var mydata = '<tr class=' + Obsrow[0].obid + ' id=' + ss + ' style="background-color:chartreuse">';
                            mydata += '<td class="GridViewLabItemStyle"></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" ><input type="text" style="width:80%;text-transform: uppercase;" id="txtnewanti"/><input type="button" value="AddNew" onclick="AddNewAntiRow(this,\'' + Obsrow[0].obid + '\',\'' + Obsrow[0].obname + '\')"/></td>';
                            mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + Obsrow[0].obid + '\',\'' + ss + '\')"  class=' + Obsrow[0].obid + '_' + ss + ' type="text" id="txtvalue" style="width:90px;"  />  <img id="imghelp" onclick="_showhideList(\'' + Obsrow[0].obid + '\',\'' + ss + '\')" src="../../App_Images/question_blue.png" /></td>';
                            mydata += '<td class="GridViewLabItemStyle"><input type="text" onkeyup="calculatebp(this)" id="txtmic" style="width:60px;"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtbreakpoint"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtmicbreak"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup"></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + ss + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;"></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + Obsrow[0].obname + '</td>';
                            mydata += "</tr>";
                            $('#AntiBioTicList').append(mydata);
                        }
                        else {
                            toast("Error", "No AntiBioTic Mapped with " + $("#ContentPlaceHolder1_ddlOrganism option:selected").text());
                        }

                        $("#ContentPlaceHolder1_ddlOrganism").prop('selectedIndex', 0);
                    },
                    error: function (xhr, status) {

                        //window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        function deletemeplz(row) {

            row.closest('tr').remove();


        }
        var jj = 1;
        function AddNewAntiRow(ctrl, obid, obname) {
            jj = jj + 1;
            var ss = "new" + jj;
            var mydata = '<tr class=' + obid + ' id=' + ss + ' style="background-color:chartreuse">';
            mydata += '<td class="GridViewLabItemStyle"></td>';
            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tdAntiName" ><input type="text" style="width:80%;text-transform: uppercase;" id="txtnewanti"/></td>';
            mydata += '<td class="GridViewLabItemStyle"><input onkeyup="_showhideList1(this,event,\'' + obid + '\',\'' + ss + '\')"  class=' + obid + '_' + ss + ' type="text" id="txtvalue" style="width:90px;"  />  <img id="imghelp" onclick="_showhideList(\'' + obid + '\',\'' + ss + '\')" src="../../App_Images/question_blue.png" /></td>';
            mydata += '<td class="GridViewLabItemStyle"><input type="text" onkeyup="calculatebp(this)" id="txtmic" style="width:60px;"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtbreakpoint"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" style="width:60px;" id="txtmicbreak"  /></td>';
            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none" id="tdAntiGroup"></td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdAntiID" style="display:none;">' + ss + '</td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdAntiGroupID" style="display:none;"></td>';
            mydata += '<td class="GridViewLabItemStyle" id="tdobname" style="display:none;">' + obname + '</td>';
            mydata += "</tr>";
            $(ctrl).parent("td").parent("tr").after(mydata);
        }

        function showantibiotic(micro) {

            if (micro != "" && micro != "null" && micro != "0") {


                for (var i = 0; i < micro.split(',').length; i++) {
                    var chunk = micro.split(',')[i];

                    if (chunk != "") {
                        $('#divantibody').show();
                        $('#ContentPlaceHolder1_ddlOrganism').val(chunk);

                        AddAntibotic();
                    }

                }
            }
        }







        function antibioticdate() {
            var dataantibiotic = new Array();
            $('#AntiBioTicList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "antiheader" && id != "ObservationName") {
                    var plo = new Object();
                    plo.testid = _test_id;
                    plo.OrganismID = $(this).closest("tr").attr("class");
                    plo.OrganismName = $(this).closest("tr").find('#tdobname').html();
                    if (id.indexOf("new") >= 0) {
                        plo.Antibioticid = "0";
                        plo.AntibioticName = $(this).closest("tr").find('#txtnewanti').val();
                    }
                    else {
                        plo.Antibioticid = $(this).closest("tr").find('#tdAntiID').html();
                        plo.AntibioticName = $(this).closest("tr").find('#tdAntiName').html();
                    }
                    plo.AntibioticGroupid = $(this).closest("tr").find('#tdAntiGroupID').html();
                    plo.AntibioticGroupname = $(this).closest("tr").find('#tdAntiGroup').html();
                    plo.AntibioticInterpreatation = $(this).closest("tr").find('#txtvalue').val();
                    plo.MIC = $(this).closest("tr").find('#txtmic').val();
                    plo.BreakPoint = $(this).closest("tr").find('#txtbreakpoint').val();
                    plo.MIC_BP = $(this).closest("tr").find('#txtmicbreak').val();
                    plo.OrganismGroupID = $('#txtcolonycount_' + $(this).closest("tr").attr("class")).val();
                    plo.OrganismGroupName = $('#txtcolonycountcomment_' + $(this).closest("tr").attr("class")).val();
                    plo.Enzymename = $('#txtobsdisplayname_' + $(this).closest("tr").attr("class")).val();
                    dataantibiotic.push(plo);
                }
            });
            return dataantibiotic;
        }

        function removecurrentorganism(ctrl) {

            $('#AntiBioTicList').find('.' + $(ctrl).closest('tr').attr("class")).remove();



        }



        $('#AntiBioTicList').keydown(function (e) {
            if (e.keyCode == 13)
                e.preventDefault();

            var $table = $(this);
            var $active = $('input:focus,select:focus', $table);
            var $next = null;
            var focusableQuery = 'input:visible,select:visible,textarea:visible';
            var position = parseInt($active.closest('td').index()) + 1;
            console.log('position :', position);
            switch (e.keyCode) {
                case 37: // <Left>
                    $next = $active.parent('td').prev().find(focusableQuery);
                    break;
                case 38: // <Up>                    
                    $next = $active
                        .closest('tr')
                        .prev()
                        .find('td:nth-child(' + position + ')')
                        .find(focusableQuery)
                    ;

                    break;
                case 39: // <Right>
                    $next = $active.closest('td').next().find(focusableQuery);
                    break;
                case 40: // <Down>
                    $next = $active
                        .closest('tr')
                        .next()
                        .find('td:nth-child(' + position + ')')
                        .find(focusableQuery)
                    ;
                    break;
            }
            if ($next && $next.length) {
                $next.focus();
            }
        });


        function calculatebp(obj) {
            var mic = $(obj).val();
            var bp = $(obj).closest("tr").find("#txtbreakpoint").val();
            if (mic == "" || isNaN(mic)) {
                //$(obj).closest("tr").find("#txtbpmic").val('');
                return;
            }

            if (bp == "" || isNaN(bp)) {
                $(obj).closest("tr").find("#txtmicbreak").val(mic);
                return;
            }

            var micbp = parseFloat(mic) / parseFloat(bp);

            $(obj).closest("tr").find("#txtmicbreak").val(parseFloat(micbp).toFixed(4));
        }
        function pickmeagain() {
            debugger;
            //PickRowData(rowIndx);
            searchLabObservation(rowIndx, PatientData[rowIndx].PName, PatientData[rowIndx].Age_Gender, PatientData[rowIndx].LedgerTransactionNo, PatientData[rowIndx].Test_ID, PatientData[rowIndx].Gender, PatientData[rowIndx].AGE_in_Days, $('#<%=ddlreportnumber.ClientID%>').val());

        }

        function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {

            if (PatientData[row].RemarkStatus == "0") {
                td.innerHTML = '<img src="../../App_Images/ButtonAdd.png" style="border-style: none;cursor:pointer;" onclick="callRemarksPage(' + "'" + '' + PatientData[row].Test_ID + '' + "'" + ',' + "'" + '' + PatientData[row].Test + '' + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + '' + "'" + ');">';
            }
            else {
                td.innerHTML = '<img src="../../App_Images/RemarksAvailable.jpg" style="border-style: none;cursor:pointer;" onclick="callRemarksPage(' + "'" + '' + PatientData[row].Test_ID + '' + "'" + ',' + "'" + '' + PatientData[row].Test + '' + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + '' + "'" + ');">';
            }
            return td;

        }

        function callRemarksPage(Test_ID, TestName, LabNo) {
            serverCall('MachineResultEntry_culture.aspx/PostRemarksData1', { TestID: Test_ID, TestName: TestName, VisitNo: LabNo }, function (response) {
                $responseData = JSON.parse(response);
                var href = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo;

                $.fancybox({
                    maxWidth: 860,
                    maxHeight: 800,
                    fitToView: false,
                    width: '65%',
                    height: '70%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                });

                // window.open("../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo + "", null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            });
        }

    </script>
    <asp:Button ID="Button2" runat="server" Style="display: none;" />
    <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" Style="width: 400px; border: 2px solid maroon; display: none;">
        <div class="Purchaseheader">Forward Test</div>
        <br />
        <table style="width: 99%; border-collapse: collapse;">
            <tr>
                <td>&nbsp;Select Test:</td>
                <td>
                    <asp:DropDownList ID="ddltest" runat="server" Width="200px"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>&nbsp;Select Centre:</td>
                <td>
                    <asp:DropDownList ID="ddlcentre" runat="server" Width="200px" onchange="binddoctoforward()"></asp:DropDownList></td>
            </tr>
            <tr>
                <td>&nbsp;Forward To:</td>
                <td>
                    <asp:DropDownList ID="ddlforward" runat="server" Width="200px"></asp:DropDownList></td>
            </tr>
        </table>
        <table style="width: 100%" frame="box">

            <tr>
                <td align="right">
                    <input type="button" value="Forward" onclick="Forwardme()" class="savebutton" />
                </td>
                <td>
                    <asp:Button ID="Button3" runat="server" Text="Close" CssClass="resetbutton" /></td>
            </tr>
        </table>
    </asp:Panel>


    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" CancelControlID="Button3" BehaviorID="ModalPopupExtender2">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlnotapproved" runat="server" Style="display: none; width: 300px; background-color: lightgray;">
        <div class="Purchaseheader">
            Not Approved Remarks
        </div>

        <center>
            <asp:TextBox ID="txtnotappremarks" runat="server" MaxLength="200" Width="250px" placeholder="Enter Not Approved Remarks" Style="text-transform: uppercase;" /><br />
            <br />
            <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />&nbsp;&nbsp;
            <asp:Button ID="btnCancelNotapproved" runat="server" CssClass="resetbutton" Text="Cancel" /><br />
            <br />
        </center>
    </asp:Panel>


    <cc1:ModalPopupExtender ID="mpnotapprovedrecord" runat="server" CancelControlID="btnCancelNotapproved"
        DropShadow="true" TargetControlID="Button2" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlHoldRemarks" runat="server" Style="display: none; width: 400px;" CssClass="pnlVendorItemsFilter">
        <div class="Purchaseheader" id="Div2" runat="server">
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td>
                        <b>Hold Remarks</b>
                    </td>
                    <td style="text-align: right">
                        <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../App_Images/Delete.gif" style="cursor: pointer" onclick="closeHoldRemarks()" />
                            to close</span></em>
                    </td>
                </tr>
            </table>
        </div>
        <table style="border-collapse: collapse">
            <tr>
                <td colspan="2" style="text-align: center">
                    <span id="spnHoldRemarks" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Remarks :&nbsp;
                </td>
                <td>
                    <input type="text" maxlength="50" id="txtHoldRemarks" style="width: 240px" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveHoldRemarks()" value="Save" class="ItDoseButton" />
                    <asp:Button ID="btnCancelHold" runat="server" CssClass="ItDoseButton" Text="Close"
                        ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Button ID="btnHideHold" runat="server" Style="display: none" />
    <cc1:ModalPopupExtender ID="mpHoldRemarks" runat="server" CancelControlID="btnCancelHold"
        DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlHoldRemarks" OnCancelScript="closeHoldRemarks()" BehaviorID="mpHoldRemarks">
    </cc1:ModalPopupExtender>
    <script type="text/javascript">
        function openAddReport(LedgerTransactionNo, _test_id) {
            serverCall('MachineResultEntry.aspx/encryptData', { LedgerTransactionNo: LedgerTransactionNo, Test_ID: _test_id }, function (response) {
                var $responseData = jQuery.parseJSON(response);
                window.open('AddReport.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&Test_ID=' + $responseData.Test_ID, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

            });
        }
    </script>
</asp:Content>

