<%@ Page Title="Result Entry" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="MachineResultEntry.aspx.cs" Inherits="PatientResultEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
      <%: Scripts.Render("~/bundles/confirmMinJS") %>
	<script src="../../ckeditor/ckeditor.js"></script>
       <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
      <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../../Scripts/cropzee.js"></script>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery.Jcrop.css"  />
    <style type="text/css">
        .High {
            background-color: hotpink !important;
        }

        .Low {
            background-color: Yellow !important;
        }

        #MainInfoDiv {
            height: 480px !important;
        }

        .ReRun {
            background-color: #F781D8;
        }

        tr.FullRowColorInRerun td {
            background-color: #F781D8!important;
        }

        tr.FullRowColorInCancelByInterface td {
            background-color: #abb54c;
        }

        .ht_clone_top {
            width: auto !important;
        }
	/*	a.fancybox-item.fancybox-close {
		position: absolute;
		top: 565px;
		right: 400px;
		width: 36px;
		height: 36px;
		cursor: pointer;
		z-index: 8040;
		}
        */
        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }
    </style>
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; top: 20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Result Entry</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
                <input type="hidden" id="hdnPickedRow" value="0" />
                <input type="hidden" id="hdnTotalSearchedRecord" value="0" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Black" runat="server" Style="color: black" />
            </div>
            <div class="row" style="vertical-align: top; margin-left: -18px; margin-right: -20px">
                <div class="col-md-15">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlSearchType" runat="server">
                                <asp:ListItem Value="pli.BarcodeNo" Selected="True">SIN No.</asp:ListItem>
                                <asp:ListItem Value="lt.Patient_ID">UHID No.</asp:ListItem>
                                <asp:ListItem Value="pli.LedgerTransactionNo">Visit No.</asp:ListItem>
								<asp:ListItem Value="pm.PName">Patient Name</asp:ListItem>
                                <asp:ListItem Value="lt.srfno">SRF ID</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtSearchValue" MaxLength="30"  runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkcentre" runat="server" onClick="BindCentre();" Text="Centre:" />
                        </div>
                        <div class="col-md-3" style="vertical-align: top; margin-left: -20px;">
                            <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" runat="server">
                                <asp:ListItem Value="ALL">ALL</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3" style="vertical-align: top; margin-left: -10px;">
                            <asp:CheckBox ID="chkPanel" runat="server" onClick="BindPanel();" Text="Panel:" />
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel  chosen-select chosen-container"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment  chosen-select chosen-container">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-9" style="margin-left: -20px">
                    <div class="row">
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlSampleStatus" runat="server">
                                <asp:ListItem Value=" and pli.isSampleCollected<>'N' ">All Patient</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">Pending</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='S' and pli.Result_flag=0 ">Sample Collected</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='Y' and pli.Result_flag=0 ">Sample Receive</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ">Machine Data</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'  and pli.isSampleCollected<>'R' ">Tested</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ">Forwarded</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=0 and pli.isrerun=1 and  pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">ReRun</asp:ListItem>
                                <asp:ListItem Value=" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ">Approved</asp:ListItem>
                                <asp:ListItem Value=" and pli.isHold='1'  ">Hold</asp:ListItem>
                                <asp:ListItem Value=" and pli.isPrint=1  and pli.isSampleCollected<>'R' ">Printed</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='R'  ">Rejected Sample</asp:ListItem>
                                <%--<asp:ListItem  Value=" and pli.Preliminary='1' and  pli.Approved=0   and pli.isPrint=0  ">Preliminary report</asp:ListItem>--%>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlMachine" runat="server">
                            </asp:DropDownList>
                            <asp:CheckBox ID="chremarks" Font-Bold="true" runat="server" Text="Remarks Status" Style="display: none;" />
                            <asp:CheckBox ID="chcomments" Font-Bold="true" runat="server" Text="Comments Status" Style="display: none;" />
                            <asp:DropDownList ID="ddlMacMaster" runat="server" Style="display: none;">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlAbnormal" runat="server">
                                <asp:ListItem Value="0" Text="All Results"> </asp:ListItem>
                                <asp:ListItem Value="1" Text="Abnormal Results"> </asp:ListItem>
                                <asp:ListItem Value="2" Text="Critical Results"> </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <input id="chkaddon" type="checkbox" />
                            <strong>Add-On</strong>&nbsp;
                        </div>
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
                <div class="col-md-13">
                    <div class="row">
                        <div class="col-md-4" style="margin-left: -39px">
                            <asp:CheckBox ID="chkPanel0" runat="server" onClick="BindTest();" Text="Test:" />
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" runat="server">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-8">
                            <input id="ChkIsUrgent" type="checkbox" />
                            <strong>Urgent&nbsp;Investigations</strong>
                        </div>
                        <div class="col-md-6">
                            <asp:DropDownList ID="ddluser" class="ddluser  chosen-select" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-2" style="margin-left: 3px">
                    <div class="row">
                        <div class="col-md-24">
                            <input id="chkChamp" type="checkbox" />
                            <strong>Camp</strong>&nbsp;
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                               <div class="col-md-3">
                     <asp:DropDownList ID="SearchDateby" runat="server">
                                <asp:ListItem Value="Registeration Date" Text="Registration Date"> </asp:ListItem>
                                <asp:ListItem Value="Sample Collection Date" Text="Sample Collection Date"> </asp:ListItem>
                                <asp:ListItem Value="Department Recive Date" Text="Department Receive Date"> </asp:ListItem>
                                <asp:ListItem Value="Approved Date" Text="Approved Date"> </asp:ListItem>
                                
                            </asp:DropDownList>
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
                    <div class="row">
                        <div class="col-md-24">
                            <input id="btnSearch" type="button" value="Search" style="margin-top: -6px;" class="searchbutton" onclick="SearchSampleCollection('');" />
                            <input type="button" id="back" class="resetbutton" value="Back" onclick="closeme()" style="display: none;" />
                            
                            <input id="chkheader" type="checkbox"  checked/>Header
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <table align="center">
                    <tr>
                        <td class="Collected" style="width: 20px; border: 1px solid black;" onclick="SearchSampleCollection(17)"></td>
                        <td style="font-weight: bold;">Collected</td>
                        <td class="Received" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(5)"></td>
                        <td style="font-weight: bold;">Pending</td>
                        <td class="MacData" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(1)"></td>
                        <td style="font-weight: bold;">MacData</td>
                        <td class="Tested" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(4)"></td>
                        <td style="font-weight: bold;">Tested</td>
                        <td class="ReRun" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(13)"></td>
                        <td style="font-weight: bold;">ReRun</td>
                        <td class="Forwarded" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(15)"></td>
                        <td style="font-weight: bold;">Forwarded</td>
                        <td class="Approved" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(6)"></td>
                        <td style="font-weight: bold;">Approved</td>
                        <td class="Approved" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(16)"></td>
                        <td style="font-weight: bold;">Auto Approved</td>
                        <td class="Printed" style="width: 20px; border: 1px solid black; cursor: pointer" onclick="SearchSampleCollection(10)"></td>
                        <td style="font-weight: bold;">Printed</td>
                        <td class="Hold" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(8)"></td>
                        <td style="font-weight: bold;">Hold</td>
                        <td class="Rejected" style="width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(2)"></td>
                        <td style="font-weight: bold;">Rejected</td>
                        <td style="background-color: #FF00FF; width: 20px; border: 1px solid black; cursor: pointer;" onclick="SearchSampleCollection(14)"></td>
                        <td style="font-weight: bold;">New Test Added</td>
                        <td style="background-color: #673AB7; width: 20px; border: 1px solid black; cursor: pointer;"></td>
                        <td style="font-weight: bold;">Repeat Patient</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="divPatient" class="vertical"></div>
            <div id="MainInfoDiv" class="vertical">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                    </div>
                </div>
                 <div class="row">
                    <div id="SelectedPatientinfo">
                    </div>
                </div>
                <div class="row">
                    <div id="divInvestigation" style="display: none;">
                        </div>
                        <div id="divRadiologyEditor" style="display: none; width:800px; height:700px;">
                     <p id="commentbox1"><span id="spInvestigationName" style="font-size:14px;font-weight:bold;color:red"></span> <span id="commentHead1">Templates</span><select id="ddlCommentsLabObservation1"  onchange="ddlCommentsLabObservation1_Load(this.value);" ></select></p>
                     <%--<input type="file" name="file_upload_Radio" id="file_upload_Radio" />--%>
                            <div style="display:none; width:100px;height:150px">
						 <div id="imgCanvas" class="image-previewer" data-cropzee="cropzee-input" ></div>
						 </div>
                             <input id="cropzee-input" type="file" name="" />
                             <br />
                             <span style="color: red;">Note:- Font type : Verdana and Font size : 14 &nbsp;</span>
                             <br />
                    <CKEditor:CKEditorControl ID="CKEditorControl2" BasePath="~/ckeditor" runat="server" Height="400px"  Width="900px"></CKEditor:CKEditorControl>
                    <br />
                    <input type="button" value="Clear Text"  onclick='ClearRadiologyComment();' />&nbsp;&nbsp;&nbsp;
                
                    <input type="button" id="btnRadiologyTestDone" value="Test Done"  onclick='TestDoneRadiology();' />
                    </div>
                </div>
               
                <div class="row">
                    <div style="display: none;">
                        <br />
                        <input id="btnUpdateBarcodeInfo" class="ItDoseButton" type="button" value="Save" style="display: none" onclick="UpdateBarcodes();" disabled />
                    </div>
                </div>
                <div class="row">
                    <div style="padding-top: 2px;" class="btnDiv">
                        <div class="row" style="margin-left: -20px">
                            <div class="col-md-7">
                                <div class="row">
                                    <div class="col-md-4">
                                        <span style="color: black; font-weight: bold;">Machine:</span>
                                    </div>
                                    <div class="col-md-8">
                                        <asp:DropDownList ID="ddlTestDon" runat="server" onchange="PicSelectedRow()"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-4">
                                        <input id="btnPreLabObs" type="button" value="<<" class="demo ItDoseButton" onclick="PreLabObs();" style="width: 50px; height: 25px" disabled />
                                    </div>
                                    <div class="col-md-4">
                                        <input id="btnNextLabObs" type="button" value=">>" class="demo ItDoseButton" onclick="NextLabObs();" style="width: 50px; height: 25px" disabled />
                                    </div>
                                    <div class="col-md-4">
                                        <input id="btnSaveLabObs" type="button" value="Save" class="ItDoseButton btnForSearch demo SampleStatus" onclick="Save();" style="width: auto; height: 25px;" disabled />
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="row">
                                    <%                  
                                        if (ApprovalId == "")
                                        { %>
                                    <%}
                                        else
                                        {
                                            if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4" || ApprovalId == "5")
                                            {%>
                                    <div class="col-md-10">
                                        <asp:DropDownList ID="ddlApprove" runat="server"></asp:DropDownList>
                                    </div>
                                    <div class="col-md-14">
                                        <input id="btnApprovedLabObs" type="button" value="Approve" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Approved();" style="width: auto; height: 25px;" disabled />
                                        <input id="btnPreliminary" type="button" value="Preliminary Report" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Preliminary();" style="width: auto; height: 25px; display: none;" disabled />
                                        <input id="btnholdLabObs" type="button" value="Hold" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Hold();" style="width: auto; height: 25px; display: none;" disabled />
                                        <% if (ApprovalId == "4" || ApprovalId == "3")
                                           {%>
                                        <input id="btnNotApproveLabObs" type="button" value="Not Approve" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="NotApproved();" style="width: auto; height: 25px;" disabled />

                                        <%if (ApprovalId == "4")
                                          { 
                                        %>
                                        <input id="btnUnholdLabObs" type="button" value="Un Hold " class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnHold();" style="width: auto; height: 25px;" disabled />
                                        <% }
                                           }
                                            }

                                            if (ApprovalId == "2" || ApprovalId == "3" || ApprovalId == "4")
                                            {%>
                                        <input id="btnForwardLabObs" type="button" value="Forward" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="Forward();" disabled />
                                        <%}
                   
                                        %>
                                        <input id="btnUnForwardLabObs" type="button" value="Un Forward" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="UnForward();" />
                                        <%

                                        }%>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-11">
                                <div class="row">
                                    <div class="col-md-24">
                                        <input id="btnAddFileLabObs" type="button" value="Add Image" class="ItDoseButton" onclick="window.open('AddAttachment.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');" style="width: auto; height: 25px;" />
                                        <input id="btnaddreport" type="button" value="Add Report" class="ItDoseButton" onclick="openAddReport(LedgerTransactionNo,_test_id)" style="width: auto; height: 25px;" />
                                        <input id="Button5" type="button" value="Sample Reject" class="ItDoseButton" onclick="$openReject(_barcodeno);" style="width: auto; height: 25px;" />
                                        <input id="btnPrintReportLabObs" type="button" value="Print PDF" class="ItDoseButton btnForSearch demo " onclick="PrintReport();" disabled style="width: auto; height: 25px;" />
                                        <input id="btnPatientDetail" type="button" value="Patient Detail" class="ItDoseButton" style="width: auto; height: 25px;" />
                                        <input id="Button1" type="button" value="Delta Check" class="ItDoseButton" style="width: auto; height: 25px;" onclick="opendeltapoup()" />
                                        <a id="various2" style="display: none">Ajax</a>
                                        <input id="btnSide" type="button" value="Main List" class="ItDoseButton" onclick="MainList();" style="width: auto; height: 25px;" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24 col-xs-24">
                            <table>
                                <tr>
                                    <td class="Collected" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Collected</td>
                                    <td class="Received" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Pending</td>
                                    <td class="MacData" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">MacData</td>
                                    <td class="Tested" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Tested</td>
                                    <td class="ReRun" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">ReRun</td>
                                    <td class="Forwarded" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Forwarded</td>
                                    <td class="Approved" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Approved</td>
                                    <td class="Printed" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Printed</td>
                                    <td class="Hold" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Hold</td>
                                    <td class="Rejected" style="width: 20px; border: 1px solid black;"></td>
                                    <td style="font-weight: bold;">Rejected</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
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
                            <div id="CommentBox">
                                <div class="row">
                                    <div class="col-md-3 col-xs-24">
                                        <span id="CommentHead">Comments</span>
                                    </div>

                                    <div class="col-md-17 col-xs-24">
                                        <select id="ddlCommentsLabObservation" onchange="ddlCommentsLabObservation_Load(this.value);" style="margin-left: 5px; height: 25px; min-width: 200px;"></select>
                                    </div>
                                    <div class="col-md-3 col-xs-24">

                                        <span id="sprequiredfile" style="font-weight: bold; background-color: lightcyan; padding: 5px;"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 col-xs-24">
                                    <input type="file" name="file_upload" id="file_upload" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-24 col-xs-24">
                                    <CKEditor:CKEditorControl ID="CKEditorControl1" BasePath="~/ckeditor" runat="server"></CKEditor:CKEditorControl>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="deltadiv" style="display: none; position: absolute;">
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
                $('#txtSearchValue').keypress(function (ev) {
                    if (ev.which === 13)
                        SearchSampleCollection("");
                });
                $("#labendtime").timepicker();
				 LoadAutoCorrect();
            });
        </script>
        <script type="text/javascript">
            function opendeltapoup() {
                $find("<%=ModalPopupExtender3.ClientID%>").show();
            }
            function opendelta1() {
                $find("<%=ModalPopupExtender3.ClientID%>").hide();
                window.open('DeltacheckNewPdf.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id, '');
            }
            function opendelta2() {
                $find("<%=ModalPopupExtender3.ClientID%>").hide();
                window.open('DeltacheckGraph.aspx?LedgerTransactionNo=' + LedgerTransactionNo + '&Test_ID=' + _test_id, '');

            }
            function BindCentre() {
                if (($('#<%=chkcentre.ClientID%>').prop('checked') == true)) {
                    var $ddlCentreAccess = $("#<%=ddlCentreAccess.ClientID %>");
                    $("#<%=ddlCentreAccess.ClientID %> option").remove();
                    serverCall('MachineResultEntry.aspx/bindAccessCentre', {}, function (response) {
                        $ddlCentreAccess.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true, defaultValue: 'ALL', defaultDataValue: 'ALL' });
                    });
                }
                else {
                    $("#<%=ddlCentreAccess.ClientID %> option").remove();
                    $("#<%=ddlCentreAccess.ClientID %>").append($("<option></option>").val("ALL").html("ALL"));
                    $("#<%=ddlCentreAccess.ClientID %>").trigger('chosen:updated');
                }
            }
            function BindPanel() {
                if (($('#<%=chkPanel.ClientID%>').prop('checked') == true)) {
                    var $ddlPanel = $("#ddlPanel");
                    $("#ddlPanel option").remove();
                    $ddlPanel.append($("<option></option>").val("").html(""));
                    serverCall('MachineResultEntry.aspx/GetPanelMaster', { centreid: $("#<%=ddlCentreAccess.ClientID %> option:selected").val() }, function (response) {
                        $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'company_name', isSearchAble: true, defaultValue: '', defaultDataValue: '' });
                });
            }
            else {
                $("#ddlPanel option").remove();
                $("#ddlPanel").trigger('chosen:updated');
            }
        };

        function BindTest() {
            if (($('#<%=chkPanel0.ClientID%>').prop('checked') == true)) {
                var $ddlInvestigation = $("#<%=ddlinvestigation.ClientID %>");
                $("#<%=ddlinvestigation.ClientID %> option").remove();
                serverCall('MachineResultEntry.aspx/GetTestMaster', {}, function (response) {
                    $ddlInvestigation.bindDropDown({ data: JSON.parse(response), valueField: 'testid', textField: 'testname', isSearchAble: true, defaultValue: '', defaultDataValue: '' });
                });
            }
            else {
                $("#ddlinvestigation option").remove();
                $("#ddlinvestigation").trigger('chosen:updated');

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
            var criticalsave = "0";
            var macvalue = "0";
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
            function showdelta(testid, labobserid) {
                var url = "../../Design/Lab/DeltaCheck.aspx?TestID=" + testid + "&LabObservation_ID=" + labobserid;
                $('#deltadiv').load(url);
                $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
            }
            function hidedelta() {
                $('#deltadiv').hide();
            }
            function showCompanyName() {
                var CName = $('#cNameid').text();
                var url = "../../Design/Lab/CheckCompanyName.aspx?CName=" + CName;
                $('#deltadiv').load(url);
                $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
            }
            function hideCompaneName() {
                $('#deltadiv').hide();
            }
            $(function () {
               
                editorid = '<%=CKEditorControl2.ClientID%>'; 
                $("#cropzee-input").cropzee({
                    startSize: [100, 100, '%'],
                });
                $('#MainInfoDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
                $('#divPatient').removeClass('vertical');
                $('#divPatient').addClass('horizontal');
                $('#MainInfoDiv').hide();
                $('.btnDiv').hide();
                $('#btnSide').hide();
                $('#btnUpdateBarcodeInfo').show();
                <%}%>
                elt = document.getElementById('<%=ddlSampleStatus.ClientID%>');
                MYSampleStatus = elt.options[elt.selectedIndex].text;
                UpdateSampleStatus();
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
            function UpdateSampleStatus() {
                try {
                    MYSampleStatus = elt.options[elt.selectedIndex].text;
                }
                catch (e) {
                    MYSampleStatus = "Tested";
                }
                $('.SampleStatus').hide();
                if (MYSampleStatus == "Forwarded") {
                    $('#btnApprovedLabObs').show();
                    $('#btnUnForwardLabObs').show();

                }
                if (MYSampleStatus == "Tested" || MYSampleStatus == "Preliminary report") { $('#btnForwardLabObs').show(); $('#btnApprovedLabObs').show(); }
                if (MYSampleStatus == "Approved" || MYSampleStatus == "Printed") { $('#btnNotApproveLabObs').show(); }
                if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested" || MYSampleStatus == "Machine Data" || MYSampleStatus == "Preliminary report" || MYSampleStatus == "Sample Receive") { $('#btnSaveLabObs').show(); $('#btnApprovedLabObs').show(); }
                if (MYSampleStatus == "Tested" && MYSampleStatus != "Approved" || MYSampleStatus == "Preliminary report") { }
                if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested") { $('#btnholdLabObs').show(); }
                if (MYSampleStatus == "Hold") { $('#btnUnholdLabObs').show(); $('#btnApprovedLabObs').hide(); }
                if (MYSampleStatus == "All Patient") { $('#btnApprovedLabObs').show(); $('#btnNotApproveLabObs').show(); }

            }

            var
                            data,
                            container1,
                            hot1;

            function SearchSampleCollection(ColourCode) {
                var investigationID = "";
                var PanelId = "";
                var SearchDateby = $('#<%=SearchDateby.ClientID%>').val();
                PanelId = $('#<%=ddlPanel.ClientID%>').val();
                investigationID = $('#<%=ddlinvestigation.ClientID%>').val();

                $('#divPatient').show();
                $('#MainInfoDiv').hide();
                var isUrgent = $("#ChkIsUrgent").is(':checked') ? 1 : 0;
                $('#btnSave').hide();
                $('#divPatient').html('');
                $('#divInvestigation').html('');
                $('.demo').attr('disabled', true);
                var chremarks = 0;
                if ($("#chremarks").prop("checked") == true)
                    chremarks = 1;
                var chcomments = 0;
                if ($("#chcomments").prop("checked") == true)
                    chcomments = 1;
                $("#btnSearch").attr('disabled', 'disabled').val('Searching...');

                var addon = $("#chkaddon").is(':checked') ? 1 : 0;

                var camp = $("#chkChamp").is(':checked') ? 1 : 0;

                var TATOption = $("#ddltatoption").val();

                var _temp = [];
                _temp.push(serverCall('MachineResultEntry.aspx/PatientSearch', { SearchType: $("#ddlSearchType").val(), SearchValue: $("#txtSearchValue").val(), FromDate: $("#<%=txtFormDate.ClientID %>").val(), ToDate: $("#<%=txtToDate.ClientID %>").val(), CentreID: $("#<%=ddlCentreAccess.ClientID%>").val(), SmpleColl: $("#<%=ddlSampleStatus.ClientID%>").val(), Department: $("#<%=ddlDepartment.ClientID%>").val(), MachineID: $('#<%=ddlMachine.ClientID%>').val(), MacGroupid: $('#<%=ddlMacMaster.ClientID%>').val(), ZSM: $("#<%=ddlZSM.ClientID%>").val(), TimeFrm: $("#<%=txtFromTime.ClientID%>").val(), TimeTo: $("#<%=txtToTime.ClientID%>").val(), isUrgent: isUrgent, InvestigationId: investigationID, PanelId: PanelId, SampleStatusText: $('#<%=ddlSampleStatus.ClientID %> option:selected').text(), chremarks: chremarks, chcomments: chcomments, BookingUser: $('#<%=ddluser.ClientID%>').val(), ColourCode: ColourCode, addon: addon, ResultType: $('#<%=ddlAbnormal.ClientID%>').val(), camp: camp, TATOption: TATOption, SearchDateby: SearchDateby }, function (response) {
                    $.when.apply(null, _temp).done(function () {
                        PatientData = JSON.parse(response);
                        if (PatientData.status == false) {
                            $('#lblTotalPatient').text('');
                            $('#btnUpdateBarcodeInfo').attr('disabled', true);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                            toast("Error", PatientData.response, "");
                            return;
                        }
                        if (PatientData.response.length == 0) {
                            $('#lblTotalPatient').text('');
                            $('#btnUpdateBarcodeInfo').attr('disabled', true);
                            $("#btnSearch").removeAttr('disabled').val('Search');
                            toast("Error", "No Record Found", "");
                            return;
                        }
                        else {
                            PatientData = PatientData.response;
                            UpdateSampleStatus();
                            currentRow = 1;
                            $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData[0].TotalTest);
                            if (PatientData.length > 0) {
                                $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData[0].TotalTest + '     Total Test:' + PatientData[0].TotalTestPatient);
                            }
                            $('#btnUpdateBarcodeInfo').attr('disabled', false);
                            $('[id$=hdnTotalSearchedRecord]').val(PatientData.length);
                            data = PatientData;
                            container1 = document.getElementById('divPatient');
                            hot1 = new Handsontable(container1, {
                                data: PatientData,
                                colHeaders: [
                          "S.No.", "TAT", "Histoy", "Time Diff", "Reg Date", "SRA Date", "Dept Rec. Date", "UHID No.", "SRF ID", "Patient Name", "Age/Sex", "Visit No.", "Mobile", "SIN No.", "Tests", "PCC/Client Name/Client Code", "Panel Type", "Status", "Detail", "View Doc.", "Print", "Sample Status", "TAT SMS"
                                ],
                                readOnly: true,
                                currentRowClassName: 'currentRow',
                                columns: [
                                { renderer: AutoNumberRenderer, width: '60px' },
                                { renderer: TATStatus, width: '60px' },
                                { renderer: ClinicalHistory, width: '60px' },
                                { data: 'timeDiff', width: '100px' },
                                { data: 'RegDate' },
                                { data: 'SRADate' },
                                { data: 'DATE' },
                                { data: 'Patient_ID', renderer: uhidrender },
                                { data: 'srfno', width: '120px' },
                                { data: 'PName', width: '200px' },
                                { data: 'Age_Gender', width: '100px' }, // , renderer: safeHtmlRenderer
                                { data: 'LedgerTransactionNo', renderer: safeHtmlRenderer },
                                { data: 'LedgerTransactionNo', renderer: safeHtmlRenderer1 },
                                { data: 'BarcodeNo', renderer: EnableBarcode, width: '100px' },
                                { data: 'Test', width: '200px', renderer: safeTestRenderer },
                                { data: 'Centre' },
                                { data: 'panelname' },
                                { data: 'Status' },
                                { renderer: PatientDetail },
                                { renderer: ShowAttachment },
                                { renderer: PrintreportRenderer },
                                { renderer: SampleStatusRenderer },//   , renderer: safeHtmlRenderer 
                                { renderer: TATSMS }
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
                            $("#btnSearch").removeAttr('disabled').val('Search');
                            CallFancyBox();
                        }
                    });
                }));

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
                var TestID = PatientData[row].Test_ID;
                var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
                var _temp = [];
                _temp.push(serverCall('MachineResultEntry.aspx/SaveRemarksStatus', { TestID: TestID, Remarks: _remarks, LedgerTransactionNo: LedgerTransactionNo }, function (response) {
                    $.when.apply(null, _temp).done(function () {
                        var $ResponseData = JSON.parse(response);
                        if ($ResponseData.status) {
                            toast("Success", $ResponseData.response, "");
                        }
                        else {
                            toast("Error", $ResponseData.response, "");
                        }
                    });

                }));
            }
            function showmsgCombinationSample(location) {
                $('#msgField').html('');
                $('#msgField').append("Sample Combination::  " + location);
                $(".alert").css('background-color', 'red');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(1000);
            }
            function callPatientDetail(PTest_ID, PLeddNo) {
                var href = "../Lab/PatientSampleinfoPopup.aspx?TestID=" + PTest_ID + "&LabNo=" + PLeddNo;
                $.fancybox({
                    maxWidth: 860,
                    maxHeight: 800,
                    fitToView: false,
                    width: '80%',
                    height: '70%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
            }
            function callShowAttachment(PLeddNo) {
                window.open('../Lab/ShowAttachment.aspx?labno=' + PLeddNo,null,' status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
			return;
                var href = "../Lab/AddFileRegistration.aspx?labno=" + PLeddNo;
                $.fancybox({
                    maxWidth: 860,
                    maxHeight: 800,
                    fitToView: false,
                    width: '80%',
                    height: '70%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
            }
            function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
                //td.innerHTML = '<a target="_blank" id="aa" href="../Lab/PatientSampleinfoPopup.aspx?TestID=' + PatientData[row].Test_ID + '&LabNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../App_Images/view.GIF" style="border-style: none" alt="">     </a>';          
                td.innerHTML = '<img  src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;" alt="" onclick="callPatientDetail(' + "'" + '' + PatientData[row].Test_ID + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">     </a>';
                td.className = PatientData[row].Status;
                return td;
            }
            function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
                var MyStr1 = "";
                if (PatientData[row].DocumentStatus != "") {
                    MyStr1 = MyStr1 + '<img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt="" onclick="callShowAttachment(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');"></a>';
                }
                td.innerHTML = MyStr1;
                td.className = PatientData[row].Status;
                return td;
            }

            function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
                var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML  

                if (PatientData[row].TATMessage == "Alert") {
                    MyStr = MyStr + '<img src="../../App_Images/Warning.gif" style="width:20px; Height:20px" title="TAT is about to Expire"/>';

                }
                if (PatientData[row].RemarkStatus != "") {
                    MyStr = MyStr + '<img src="../../App_Images/Remark.jpg" style="width:20px; Height:25px" alt=' + PatientData[row].RemarkStatus + '/>';

                }
                if (PatientData[row].Urgent == 'Y') {
                    MyStr = MyStr + '<img title="Urgent" src="../../App_Images/urgent.gif"/>';
                }
                if (PatientData[row].TATDelay == "1") {
                    MyStr = MyStr + '<img title="TATDelay" src="../../App_Images/tatdelay.gif" />';
                }
                //if (PatientData[row].CombinationSample == "1") {
                //    MyStr = MyStr + '<img onclick="showmsgCombinationSample(\'' + PatientData[row].CombinationSampleDept + '\')" title="' + PatientData[row].CombinationSampleDept + '" src="../../App_Images/Red.jpg" style="width:13px; Height:13px;border-radius: 10px;"  />';
                //}
                if (PatientData[row].Comments != "") {
                    MyStr = MyStr + '<img title="Comments" src="../../App_Images/comments.png" style="width:25px;height:25px;" alt="Comments" />';
                }
                if (PatientData[row].IsCriticalResult == "1") {
                    MyStr = MyStr + "<br/><b><font color='ED0A3f'>Critical</font></b>";
                }
                else if (PatientData[row].IsNormalResult != "1") {
                    if (PatientData[row].IsNormalResult == "3")
                        MyStr = MyStr + "<br/><b><font color='deeppink'>High</font></b>";
                    if (PatientData[row].IsNormalResult == "2")
                        MyStr = MyStr + "<br/><b><font color='#ff6037'>Low</font></b>";
                }

                if (PatientData[row].SampleLocation != '')
                    td.innerHTML = MyStr + '<br/>' + PatientData[row].SampleLocation;
                else
                    td.innerHTML = MyStr;
                if (PatientData[row].Status == "Received" && PatientData[row].isrerun == "1") {
                    $(td).parent().addClass('FullRowColorInRerun');

                }
                //if (PatientData[row].IsNormalResult != "1") {
                //    if (PatientData[row].IsNormalResult == "3")
                //        td.className = "High";
                //    if (PatientData[row].IsNormalResult == "2")
                //        td.className = "Low";
                //} else {
                td.className = PatientData[row].Status;
                //}

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
                    if ('<%=Session["RoleID"]%>' == '15')
                        td.innerHTML = '<a href="labreportnew.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead='+ PHeader +'" target="_blank" > <img  src="../../App_Images/print.gif" style="border-style: none" alt="">     </a>';
                     else
                        td.innerHTML = '<a href="labreportnew.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead=0" target="_blank" > <img  src="../../App_Images/print.gif" style="border-style: none" alt="">     </a>';
                }
                else {
                    td.innerHTML = '<span>&nbsp;</span>';
                }
                td.className = PatientData[row].Status;
                return td;
            }
            function TATSMS(instance, td, row, col, prop, value, cellProperties) {
               
                td.innerHTML = '<img  src="../../App_Images/sms.ico" style="cursor:pointer;width:16px;height:16px;" title="Tiny SMS" alt="" onclick="loadSmsdetail(' + "'" + '' + PatientData[row].Mobile + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + '' + "'" + ');">';
                td.className = PatientData[row].Status;
                return td;
            }
            function ClinicalHistory(instance, td, row, col, prop, value, cellProperties) {
                if (PatientData[row].ClinicalHistory != "")
                    td.innerHTML = '<img  src="../../App_Images/HistoryGreen.png" style="border-style: none;cursor:pointer;width:20px; Height:20px;" alt="" onclick="clinicalhistory(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">';
                else
                    td.innerHTML = '<img  src="../../App_Images/HistoryBlue.png" style="border-style: none;cursor:pointer;width:20px; Height:20px;" alt="" onclick="clinicalhistory(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">';
            }
            function SampleStatusRenderer(instance, td, row, col, prop, value, cellProperties) {
                if (PatientData[row].BarcodeNo != "") {
                    td.innerHTML = '<img  src="../../App_Images/view.gif" style="border-style: none;cursor:pointer;" alt="" onclick="callSampleStatusRenderer(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">';
                }
                else {
                    td.innerHTML = '<span>&nbsp;</span>';
                }
                td.className = PatientData[row].Status;
                return td;
            }
            function SampleIconRenderer(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                td.innerHTML = '<a target="_blank" id="aa" href="SampleCollectionPatient.aspx?LedgerTransactionNo=' + PatientData[row].LedgerTransactionNo + '" class="various iframe" > <img  src="../../App_Images/Sample.png" style="border-style: none" alt="">     </a>';
                return td;
            }
            function RemarksFieldRenderer(instance, td, row, col, prop, value, cellProperties) {
                td.innerHTML = '<input type="text" onkeydown="SaveRemarksStatus(event,this);" id="' + PatientData[row].Test_ID + '#' + PatientData[row].LedgerTransactionNo + '" heght="150px;" value="' + PatientData[row].RemarkStatus + '">';
                td.className = PatientData[row].Status;
                return td;
            }

            function OpenTestLog(Test_Id) {
                var _temp = [];
                _temp.push(serverCall('MachineResultEntry.aspx/OpenTestLog', { TestId: Test_Id }, function (response) {
                    $.when.apply(null, _temp).done(function () {
                        var $ResponseData = JSON.parse(response);
                        if ($ResponseData.status) {
                            window.open("SampleLog.aspx?Test_Id=" + Test_Id);
                        }
                        else {
                            toast("Info", "No Log Found", "");
                        }
                    });
                }));
            }
            //-------------------
            function RemarksRenderer(instance, td, row, col, prop, value, cellProperties) {
                var html = '<img  src="../../App_Images/view.gif" title="Log" style="margin-left:15px;border-style: none;cursor:pointer;" alt="" onclick="OpenTestLog(' + LabObservationData[row].PLIID + ');">';
                if (LabObservationData[row].Inv == "1") {
                    if (LabObservationData[row].Remarks == "0") {
                        td.innerHTML = '<img src="../../App_Images/ButtonAdd.png" style="border-style: none;cursor:pointer;" onclick="callRemarksPage(' + "'" + '' + LabObservationData[row].PLIID + '' + "'" + ',' + "'" + '' + LabObservationData[row].LabObservationName + '' + "'" + ',' + "'" + '' + LabObservationData[row].LabNo + '' + "'" + ');">' + html;
                    }
                    else {
                        td.innerHTML = '<img src="../../App_Images/RemarksAvailable.jpg" style="border-style: none;cursor:pointer;" onclick="callRemarksPage(' + "'" + '' + LabObservationData[row].PLIID + '' + "'" + ',' + "'" + '' + LabObservationData[row].LabObservationName + '' + "'" + ',' + "'" + '' + LabObservationData[row].LabNo + '' + "'" + ');">' + html;
                    }
                    return td;
                }
                else {
                    td.innerHTML = '';
                    return td;
                }
            }
            function callSampleStatusRenderer(barcodeno) {
                serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: barcodeno }, function (response) {
                    var href = "../Lab/SampleTracking.aspx?LabNo=" + response;
                    $.fancybox({
                        maxWidth: 840,
                        maxHeight: 800,
                        fitToView: false,
                        width: '80%',
                        height: '70%',
                        href: href,
                        autoSize: false,
                        closeClick: false,
                        openEffect: 'none',
                        closeEffect: 'none',
                        'type': 'iframe'
                    }
                    );
                });
            }
            function clinicalhistory(LabNo) {
                serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: LabNo }, function (response) {
                    var href = "../Lab/ClincalHistory.aspx?LabNo=" + response;
                    $.fancybox({
                        maxWidth: 840,
                        maxHeight: 500,
                        fitToView: false,
                        width: '80%',
                        height: '40%',
                        href: href,
                        autoSize: false,
                        closeClick: false,
                        openEffect: 'none',
                        closeEffect: 'none',
                        'type': 'iframe'
                    }
                    );
                });
            }
            function callRemarksPage(Test_ID, TestName, LabNo) {
                 serverCall('PatientLabSearch.aspx/PostRemarksData', { TestID: Test_ID, TestName: TestName, VisitNo: LabNo }, function (response) {
                    $responseData = JSON.parse(response);
                    var href = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo;
                    $.fancybox({
                        maxWidth: 860,
                        maxHeight: 800,
                        fitToView: false,
                        width: '80%',
                        height: '70%',
                        href: href,
                        autoSize: false,
                        closeClick: false,
                        openEffect: 'none',
                        closeEffect: 'none',
                        'type': 'iframe'
                    }
                    );
                });
            }

            function CallFancyBox() {
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

            function uhidrender(instance, td, row, col, prop, value, cellProperties) {
                td.innerHTML = value;
                if (PatientData[row].ReVisit == "1") {
                    td.setAttribute("style", "background-color:#673AB7;color:white;");
                }
                if (PatientData[row].IsEdited == "1") {
                    td.setAttribute("style", "background-color:#FF00FF;color:white;");
                }

                return td;
            }
            function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {

                    <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                      {%>
                var escaped = Handsontable.helper.stringify(value);
                //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
                //td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
                td.innerHTML = '<a style="font-weight:bold;" href="javascript:void(0);" id="lnk_' + row + '"  onclick="PickRowData(' + row + ');"> ' + PatientData[row].LedgerTransactionNo + '     </a>';
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
            function safeHtmlRenderer1(instance, td, row, col, prop, value, cellProperties) {

                <%if (Util.GetString(Request.QueryString["cmd"]) != "changebarcode")
                      {%>
                var escaped = Handsontable.helper.stringify(value);
                td.innerHTML = '<input  type="button" style="font-weight:bold;" value=' + PatientData[row].LedgerTransactionNo + ' onclick="PickRowData(' + row + ');"> </input >';
                td.id = value.replace(/,/g, "_");
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
                $('[id$=hdnPickedRow]').val(rowIndex);
                rowIndx = rowIndex;
                currentRow = rowIndex;
                $('#MainInfoDiv').show();
                $('#divPatient').hide();
                _test_id = PatientData[rowIndex].Test_ID;
                _barcodeno = PatientData[rowIndex].BarcodeNo;
                searchLabObservation(rowIndex, PatientData[rowIndex].PName, PatientData[rowIndex].Age_Gender, PatientData[rowIndex].LedgerTransactionNo, PatientData[rowIndex].Test_ID, PatientData[rowIndex].Gender, PatientData[rowIndex].AGE_in_Days);
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
            function ddlCommentsLabObservation1_Load(CommentID) {
                var BarcodeNo = $('#tblPatientInfo tr > td#PatientBarcodeNo').html();
                var Test_ID = CommentID.split('#')[1];
                // var type = $('#ddlCommentsLabObservation1').attr('title');
                var type = 'Value';
                $.ajax({
                    url: "MachineResultEntry.aspx/GetComments_labobservation",
                    data: '{ CmntID:"' + CommentID + '",type:"' + type + '",BarcodeNo:"' + BarcodeNo + '",Test_ID:"' + Test_ID + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(result.d);
                    },
                    error: function (xhr, status) {
                        //alert("Error.... ");
                    }
                });

            }
            function NextLabObs() {
                var totalRows = PatientData.length - 1;
                if (totalRows > currentRow) {
                    PickRowData(currentRow + 1);
                }
                else { $('#btnNextLabObs').attr("disabled", true); toast("Info", "No more rows available", ""); }
            }
            function GetParameters(TestId) {
                searchLabObservation(rowIndx, PatientData[rowIndx].PName, PatientData[rowIndx].Age_Gender, PatientData[rowIndx].LedgerTransactionNo, TestId, PatientData[rowIndx].Gender, PatientData[rowIndx].AGE_in_Days);
            }
                var IsRadiology = false;
        var ModalRow = '';
        var ModalValue = '';
        var RTest_Id='';
            function searchLabObservation(_index, pname, age_gender, labNo, testId, gender, ageInDays) {
 IsRadiology = false;
                $('.demo').attr('disabled', true);
                var macId = $('#<%=ddlTestDon.ClientID %> option:selected').val();
                LedgerTransactionNo = labNo;
                LoadInvName(LedgerTransactionNo);
               

               

                $('#divInvestigation').html('');
                $('#divRadiologyEditor').hide();
                $('#divInvestigation').hide();

                $.ajax({
                    url: "MachineResultEntry.aspx/LabObservationSearch",
                    data: '{LabNo:"' + labNo + '",TestID:"' + testId + '",AgeInDays:' + ageInDays + ',RangeType:"Normal",Gender:"' + gender + '",MachineID:"' + $('#<%=ddlMachine.ClientID%>').val() + '",macId:"' + macId + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    renderAllRows: true,
                    mergeCells: true,
                    success: function (result) {
                        $('.SampleStatus').hide();

                        $('#btnPreLabObs').attr("disabled", false);
                        $('#btnNextLabObs').attr("disabled", false);
                        LabObservationData = $.parseJSON(result.d);

                        if (LabObservationData == "-1") {
                            $('.btnForSearch').attr("disabled", true);
                            toast("Error", "Your Session Expired.... Please Login Again", "");
                            return;
                        }
                        if (LabObservationData.length == 0) {
                            $('.btnForSearch').attr("disabled", true);
                            toast("Info", "No Record Found", "");
                            return;

                        }
                        else {
                            bindPatientInfo(LabObservationData[2].TestName, _index);
                            UpdateSampleStatus();
                            $('.demo').attr('disabled', false);
                            $('.SampleStatus').attr('disabled', false);
  row = 2;
						//	alert(LabObservationData[row].ReportType);
                            if (LabObservationData[row].ReportType == "5" || LabObservationData[row].ReportType == "3") {
                                $('#divInvestigation').hide();
                                subcategoryid = LabObservationData[row].SubCategoryID;
                                IsRadiology = true;
                                ModalRow = row;
                                ModalValue = LabObservationData[row].Description;
                                RTest_Id = LabObservationData[row].Test_ID;
                                if (LabObservationData[row].TestDoneStatus == "0") {
                                    // alert(LabObservationData[row].IsSampleCollected);
                                    if (LabObservationData[row].IsSampleCollected == "S" || LabObservationData[row].IsSampleCollected == "Y") {
                                        $('#btnRadiologyTestDone').show();
                                       
                                      //  CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setReadOnly(true);
                                    }
                                    else
                                        $('#btnRadiologyTestDone').hide();

                                    //$('#btnRadiologyTestDone').show();
                                    $('#btnSaveLabObs').hide();
                                }
                                else {

                                  //  if (LabObservationData[row].Approved == "0")
                                  //      CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setReadOnly(false);
                                 //   else
                                     //   CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setReadOnly(true);

                                    $('#btnRadiologyTestDone').hide();
                                    $('#btnSaveLabObs').show();
                                }
                            }

                            else {
                                $('#divInvestigation').show();
                            var data = LabObservationData,
                             container2 = document.getElementById('divInvestigation');
                            hot2 = new Handsontable(container2, {
                                data: LabObservationData,
                                colHeaders: [
                                         "#", "Test", "Value", "Comment", "Flag", "MacReading", "Machine Name", "Reading1", "Reading2", "ReadingFormat", "MinValue", "MaxValue", " ", "Method Name", "Display Reading", "Remarks"
                                ],
                                    columns: [
                                         {
                                             data: 'SaveInv',
                                             renderer: CheckBoxrender,

                                             readOnly: false, width: 30
                                         },
                                { data: 'LabObservationName', renderer: LabObservationRender, width: 300 },
                                { data: 'Value', readOnly: false, renderer: CheckCellValue, width: 150 },
                                { renderer: ShowComment },
                                //{ data: 'Flag', renderer: renderFlag },

                                {
                                    data: 'Flag',
                                    type: 'dropdown',
                                    source: ['Normal', 'High', 'Low', ''],
                                    width: 80,
                                    readOnly: false,
                                    renderer: changeColor
                                },

                                { data: 'MacReading' },
                                { data: 'machinename' },
                                { data: 'Reading1' },
                                { data: 'Reading2' },

                                { data: 'ReadingFormat', readOnly: true },
                                { data: 'MinValue', readOnly: true },
                                { data: 'MaxValue', readOnly: true }, // , renderer: safeHtmlRenderer 
                                {
                                    data: 'PrintMethod',
                                    type: 'checkbox',
                                    checkedTemplate: '1',
                                    uncheckedTemplate: '0',
                                    readOnly: false
                                },
                                { data: 'Method', readOnly: true },
                                { data: 'DisplayReading', readOnly: true },
                                { data: 'Remarks', renderer: RemarksRenderer }

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

                                                if (LabObservationData[row].helpvalueonly == "1") {
                                                    this.strict = true;
                                                    this.allowInvalid = false;
                                                }
                                                else {
                                                    this.strict = false;
                                                }
                                            }
                                            catch (e) {
                                            }
                                        }
                                    }
                                    else if (LabObservationData[row].IsComment == "1") {
                                        this.readOnly = true;
                                    }

                                    if (LabObservationData[row].ReportType != "1") {

                                        this.readOnly = true;

                                    }
                                    if (LabObservationData[row].Inv == "3") {
                                        this.readOnly = true;
                                    }
                                    if (LabObservationData[row].Inv == "2") {
                                        this.readOnly = false;
                                    }
                                }
                            });
                            ApplyFormula();
                            hot2.selectCell(0, 1);
                            $('.btnForSearch').attr("disabled", false);

                        }
                            if (IsRadiology) {

                                $('#<%=ddlTestDon.ClientID%>').hide();

                                //  IsRadiology = false;
                                $('#divInvestigation').html('');
                                $('#divRadiologyEditor').show();
                                $('#divInvestigation').hide();

                                $('.DivInvName').show();
                                $('[id$=Button5]').hide();
                                loadObservationComment(ModalRow, "", "Value", "");
                                //-----------------------
                            } else {
                                $('#<%=ddlTestDon.ClientID%>').show();

                                $('.ApprovalId').hide();
                                $('[id$=Button5]').show();
                                
                            }
                             if (LabObservationData[row].ReportType != "5" && LabObservationData[row].ReportType != "3")
                                 hot2.selectCell(0, 1);
                         }
                    },
                    error: function (xhr, status) {
                        $('#divInvestigation').html('');
                        alert('Please Contact to ItDose Support Team');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });

                setTimeout(function () { loaddata(RTest_Id); }, 2000);
            }
            function bindPatientInfo(TestName, _index)
            {
                $('#SelectedPatientinfo').html('');
                var RepeatPatient = PatientData[_index].ReVisit == "1" ? '<th style="width:20px;background-color:#673AB7;"></th><td>Repeat Patient</td>' : '';
                var $temp = [];
                $temp.push('<table id="tblPatientInfo"><tr><th> S.No.: </th><td>');
                $temp.push((parseInt(_index) + 1));
                $temp.push(' out of ');
                $temp.push($('[id$=hdnTotalSearchedRecord]').val());
                $temp.push('</td> <th>SIN No.:</th><td id="PatientBarcodeNo">');
                $temp.push(PatientData[_index].BarcodeNo);
                $temp.push('</td><th>Patient Name:</th><td>');
                $temp.push(PatientData[_index].PName);
                $temp.push('</td><th>Age/Gender:</th><td>');
                $temp.push(PatientData[_index].Age_Gender);
                $temp.push('</td><th>Date :</th><td>');
                $temp.push(PatientData[_index].DATE);
                $temp.push('</td>   </tr>');
                $temp.push('<tr><th>Client:</th><td colspan="2">');
                $temp.push(PatientData[_index].panelname);
                $temp.push('</td>');
                $temp.push('<td>');
                $temp.push('<th>Visitno :</th><td colspan="2" style="font-weight:bold;color:red">');
                $temp.push(PatientData[_index].LedgerTransactionNo);
                $temp.push('</td>');
                $temp.push('<th>Test Name :</th><td colspan="2" style="font-weight:bold;color:red">');
                $temp.push(TestName);
                $temp.push('</td></tr>');
                $temp.push(RepeatPatient);

                $temp.push('</tr></table>');
                $temp = $temp.join("");
                $('#SelectedPatientinfo').append($temp);
            }
            function loaddata(Test_id) {
                $.ajax({
                    url: "MachineResultEntry.aspx/Getpatient_labobservation_opd_text",
                    async: false,
                    data: '{TestId:"' + Test_id + '",BarcodeNo:""}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                      //   alert(result.d);
                         CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData(result.d);
                    }
                });
            }
            function LoadInvName(LabNo) {
                $.ajax({
                    url: "MachineResultEntry.aspx/GetPatientInvsetigationsNameOnly",
                    data: '{ LabNo:"' + LabNo + '"}',
                    type: "POST",
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
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            function LabObservationRender(instance, td, row, col, prop, value, cellProperties) {
                if (LabObservationData[row].Inv == "1") {
                    if (LabObservationData[row].IsAttached != "") {
                        if (elt.options[elt.selectedIndex].text == "Pending" || elt.options[elt.selectedIndex].text == "ReRun" || elt.options[elt.selectedIndex].text == "Tested" || elt.options[elt.selectedIndex].text == "Machine Data") {
                            if (LabObservationData[row].IsEdited == "1") {
                                td.innerHTML = value + ' <img src="../../App_Images/edit.png" title="' + LabObservationData[row].EditDetail + '"/>' + '<br/>' + LabObservationData[row].IsAttached + '<br/><input style="cursor:pointer;" class="ItDoseButton" type="button" value="ReRun" onclick="openrerunoption(\'' + LabObservationData[row].PLIID + '\')"/>';
                            }
                            else {
                                td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached + '<br/><input style="cursor:pointer;" class="ItDoseButton" type="button" value="ReRun" onclick="openrerunoption(\'' + LabObservationData[row].PLIID + '\')"/>';
                            }
                        }
                        else {
                            if (LabObservationData[row].IsEdited == "1") {
                                td.innerHTML = value + ' <img src="../../App_Images/edit.png" title="' + LabObservationData[row].EditDetail + '"/> ' + '<br/>' + LabObservationData[row].IsAttached;
                            }
                            else {
                                td.innerHTML = value + '<br/>' + LabObservationData[row].IsAttached;
                            }
                        }
                    }
                    else {
                        if (elt.options[elt.selectedIndex].text == "Pending" || elt.options[elt.selectedIndex].text == "ReRun" || elt.options[elt.selectedIndex].text == "Tested" || elt.options[elt.selectedIndex].text == "Machine Data") {
                            if (LabObservationData[row].IsEdited == "1") {
                                td.innerHTML = value + ' <img src="../../App_Images/edit.png" title="' + LabObservationData[row].EditDetail + '"/> ' + '<br/><input type="button" onclick="openrerunoption(\'' + LabObservationData[row].PLIID + '\')" style="cursor:pointer;"  type="button" value="ReRun"/>' + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onclick="openrangeoption(\'' + LabObservationData[row].PLIID + '\')" style="cursor:pointer;"  type="button" value="Range"/>';
                            }
                            else {
                                td.innerHTML = value + '<br/><input type="button" onclick="openrerunoption(\'' + LabObservationData[row].PLIID + '\')" style="cursor:pointer;"  type="button" value="ReRun"/>' + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onclick="openrangeoption(\'' + LabObservationData[row].PLIID + '\')" style="cursor:pointer;"  type="button" value="Range"/>';
                            }
                        }
                        else {
                            if (LabObservationData[row].IsEdited == "1") {
                                td.innerHTML = value + ' <img src="../../App_Images/edit.png" title="' + LabObservationData[row].EditDetail + '"/> ';
                            }
                            else {
                                td.innerHTML = value;
                            }
                        }
                    }
                }

                else {
                    td.innerHTML = value;
                }
                td.style.background = LabObservationData[row].Status;
                td.style.width = '300px';
                if (LabObservationData[row].Inv == "1") {
                    if (value.indexOf("(RERUN)") >= 0) {
                        td.setAttribute("style", "background-color:#F781D8;");
                    }
                    else {
                        $(td).parent().addClass('InvHeader');
                    }
                }
                else if (LabObservationData[row].Inv == "3")
                    $(td).parent().addClass('DeptHeader');
                if (LabObservationData[row].Value == "HEAD") {
                    $(td).parent().addClass('InvSubHead');
                }
                return td;
            }
            function openrangeoption(tid) {
                var href = "../Lab/ReferenceRange.aspx?TestID=" + tid;
                $.fancybox({
                    maxWidth: 300,
                    maxHeight: 100,
                    fitToView: false,
                    width: '30%',
                    height: '10%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
            }
            function openrerunoption(tid) {
                var href = "../Lab/ShowRerun.aspx?TestID=" + tid + "&LabNo=" + LedgerTransactionNo;
                $.fancybox({
                    maxWidth: 860,
                    maxHeight: 800,
                    fitToView: false,
                    width: '80%',
                    height: '70%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe'
                }
                );
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
                    if (LabObservationData[row].Value == "")
                        td.innerHTML = '<span style="text-align:center;" onclick="openmecomment(' + LabObservationData[row].Test_ID + ')"><img src="../../App_Images/ButtonAdd.png"/></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="text-align:right;display:none;"  onclick="openinterpretation(' + LabObservationData[row].Test_ID + ')"><img src="../../App_Images/edit.png" toolTip="Add interpretation" style="display:none;" /></span>';
                    else
                        td.innerHTML = '<span style="text-align:center;" onclick="openmecomment(' + LabObservationData[row].Test_ID + ')"><img src="../../App_Images/Redplus.png"/></span>';
                    return td;
                }

                if (LabObservationData[row].IsComment == "0") {
                    if (value == 'HEAD' || elt.options[elt.selectedIndex].text == "Approved" || LabObservationData[row].IsSampleCollected != 'Y') {
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
                        td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'\');"><img src="../../App_Images/Redplus.png"/></span>';
                }
                if (LabObservationData[row].ReportType != "1") {
                    td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', \'' + prop + '\',\'' + (value == "" ? null : value) + '\');"><img src="../../App_Images/ButtonAdd.png"/></span>';

                }
                if (LabObservationData[row].MacReading != "" && LabObservationData[row].MacReading != null) {
                    if (LabObservationData[row].Value != LabObservationData[row].MacReading) {
                        // change background color when value differ from macreading
                        td.style.setProperty('background-color', '#1aead7', 'important');
                    }
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

            function ShowComment(instance, td, row, col, prop, value, cellProperties) {
                if (LabObservationData[row].Inv == "1") {
                    if (LabObservationData[2].CancelByInterface == "1" && LabObservationData[2].IsSampleCollected == "Y") {
                        td.innerHTML = '<span style="display:none;" id="cNameid">' + LabObservationData[2].InterfaceCName + '</span><span style="cursor:pointer;height:100px;width:100px;" onmouseover="showCompanyName()" onmouseout="hideCompaneName()"><img style="width:20px;height:20px;" src="../../App_Images/alert.PNG"/></span>';
                        $(td).parent().addClass('FullRowColorInCancelByInterface');
                    }
                }
                else {
                    var escaped = Handsontable.helper.stringify(value);
                    if (LabObservationData[row].ReportType == "1" && LabObservationData[row].IsComment == "1") {
                        td.innerHTML = '';
                    }
                    else if (LabObservationData[row].ReportType != "1") {
                        td.innerHTML = '';
                    }
                    else if (LabObservationData[row].LabObservationName == "Organism Tables")
                        td.innerHTML = '';
                    else {
                        if (LabObservationData[row].Description == "" || LabObservationData[row].Description == null || LabObservationData[row].Description == "null") {
                            td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../App_Images/ButtonAdd.png"/></span>' + '&nbsp;<span style="cursor:pointer;height:100px;width:100px;" onmouseover="showdelta(' + LabObservationData[row].PLIID + ',' + LabObservationData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span>';
                        }
                        else {
                            td.innerHTML = '<span style="text-align:center;" onclick="ShowModalWindow(' + row + ', ' + col + ', ' + prop + ',' + value + ');"><img src="../../App_Images/RemarksAvailable.jpg"/></span>' + '&nbsp;<span style="cursor:pointer;height:100px;width:100px;" onmouseover="showdelta(' + LabObservationData[row].PLIID + ',' + LabObservationData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span>';
                        }
                    }
                }
                return td;
            }
            function openRadiology(testid,invid) {
                var Emp_Name = '<%=UserInfo.LoginName.ToString() %>';
                var Emp_ID = '<%=UserInfo.ID.ToString() %>';
                var ris_path = "RIS:OpenForm?Test_ID=" + testid + "&Investigation_Id=" + invid + "&Emp_Name=" + Emp_Name + "&Emp_ID=" + Emp_ID + "&AuthID=" + Emp_ID + "&Weblink=<%=Request.Url.Scheme %>://<%=Request.Url.Host %>:<%=Request.Url.Port %>/<%=Request.Url.AbsolutePath.Split('/')[1] %>/RIS.asmx";

                window.location = ris_path;
            }
            function ShowModalWindow(row, col, prop, value) {              
                if (LabObservationData[row].ReportType == "11") {
                    openRadiology(LabObservationData[row].Test_ID, LabObservationData[row].Investigation_ID);
                    return;
                }               
              //  CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData('');
                console.log(LabObservationData[row].Description);
                if (prop != "Value") {
                    $('#CommentHead').html('Comments');
                    $('#CommentBox').show();
                    $('#sprequiredfile').html('');
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);
                $('.modal-footer').html('<h3 style="height: 20px;">' +
                    '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                    '<div style="float: right;">' +
                    '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',' + prop + ');" class="btnAddComment" style="height: 30px;"/>' +
                    '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                    '</div></h3>');
                modal.style.display = "block";

                loadObservationComment(row, col, prop, value);
            } else if (prop == "Value") {

                if (LabObservationData[row].ReportType == "1") {
                    console.log(prop);
                    $('#CommentBox').hide();
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                    $('.modal_header').html('Set Value');
                    $('.modal-footer').html('<h3 style="height: 20px;">' +
                        '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>' +
                        '<div style="float: right;">' +
                        '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                        '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                        '</div></h3>');

                }
                else if (LabObservationData[row].ReportType == "3" || LabObservationData[row].ReportType == "5") {
                    $('#CommentHead').html('Templates');
                    $('#CommentBox').show();
                    $('#sprequiredfile').html(LabObservationData[1].RequiredField);
                    CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(LabObservationData[row].Description);
                            $('.modal_header').html('Set comment for ' + LabObservationData[row].LabObservationName);

                            var my = '<h3 style="height: 20px;">';
                            my += '<input type="button" value="Clear Text" style="height:30px;" onclick="ClearComment();"/>';

                            <% if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                               {%>
                            my += '&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" placeholder="Template Name" id="txttempname"/> <input type="button" value="Save As Template"  style="height:30px;cursor:pointer;font-weight:bold;" onclick="saveasTemplate();"/><span id="invid" style="display:none;">' + LabObservationData[row].Investigation_ID + '</span>';

                            <%}%>
                            my += '<div style="float: right;">' +
                                '<input type="button" value="Add Comment" onclick="AddComment(' + row + ',\'' + prop + '\');" class="btnAddComment" style="height: 30px;"/>' +
                                '<input type="button" value="Cancel" class="btnCancel" style="height:30px;" onclick="CancelComment();"/>' +
                                '</div></h3>';
                            $('.modal-footer').html(my);
                            BindTemplateValue(row, col, prop, value);
                            loadObservationComment(row, col, prop, value);
                        }
                    modal.style.display = "block";
                }

        }
        function saveasTemplate() {
            var commentValue = CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].getData();
    if (commentValue == "") {
        $('#msgField').html('');
        $('#msgField').append("Please Enter Something To Save As Template");
        $(".alert").css('background-color', 'red');
        $(".alert").removeClass("in").show();
        $(".alert").delay(1500).addClass("in").fadeOut(1000);
        return;
    }
    if ($('#txttempname').val() == "") {
        $('#msgField').html('');
        $('#msgField').append("Please Enter Template Name");
        $(".alert").css('background-color', 'red');
        $(".alert").removeClass("in").show();
        $(".alert").delay(1500).addClass("in").fadeOut(1000);
        $('#txttempname').focus();
        return;
    }
    var tempname = $('#txttempname').val();
    var invid = $('#invid').html();

    var _temp = [];
    _temp.push(serverCall('MachineResultEntry.aspx/savetemplate', { temp: commentValue, tempname: tempname, invid: invid }, function (response) {
        $.when.apply(null, _temp).done(function () {
            var $ResponseData = JSON.parse(response);
            if ($ResponseData.status) {
                toast("Success", $ResponseData.response, "");
                $('#txttempname').val('');
            }
            else {
                toast("Error", $ResponseData.response, "");
            }
        });
    }));
}
function BindTemplateValue(row, col, prop, value) {
    if (LabObservationData[row].Method == 1)
        return;
    $.ajax({
        url: "MachineResultEntry.aspx/Getpatient_labobservation_opd_text",
        data: '{ TestId:"' + LabObservationData[row].LabObservation_ID + '",BarcodeNo:"' + LabObservationData[row].BarcodeNo + '"}', // parameter map
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
            //alert("Error.... ");
        }
    });
}
function loadObservationComment(row, col, prop, value) {
    $('#ddlCommentsLabObservation').attr('title', prop);
    $.ajax({

        url: "MachineResultEntry.aspx/Comments_LabObservation",
        data: '{ LabObservation_ID:"' + LabObservationData[row].LabObservation_ID + '",Type:"' + prop + '",Gender:"' + LabObservationData[row].Gender + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            result = $.parseJSON(result.d);
            $("#ddlCommentsLabObservation1").empty();
            $("#ddlCommentsLabObservation1").append("<option value=''>Select</option>");
            if (prop == 'Value') {
                for (var i = 0; i < result.length; i++) {
                    var newOption = "<option value=" + result[i].Template_ID + "#" + LabObservationData[row].Test_ID + ">" + result[i].Temp_Head + "</option>";
                    $("#ddlCommentsLabObservation1").append(newOption);
                }
            }
            else {
                for (var i = 0; i < result.length; i++) {
                    var newOption = "<option value=" + result[i].Comments_ID + ">" + result[i].Comments_Head + "</option>";
                    $("#ddlCommentsLabObservation1").append(newOption);
                }
            }
        },
        error: function (xhr, status) {
            //alert("Error.... ");
        }
    });
}
function ddlCommentsLabObservation_Load(CommentID) {
    var BarcodeNo = $('#tblPatientInfo tr > td#PatientBarcodeNo').html();
    var Test_ID = CommentID.split('#')[1];
    var type = $('#ddlCommentsLabObservation').attr('title');
    $.ajax({
        url: "MachineResultEntry.aspx/GetComments_labobservation",
        data: '{ CmntID:"' + CommentID + '",type:"' + type + '",BarcodeNo:"' + BarcodeNo + '",Test_ID:"' + Test_ID + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            CKEDITOR.instances['<%=CKEditorControl1.ClientID%>'].setData(result.d);
        },
        error: function (xhr, status) {
            //alert("Error.... ");
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
                try {
                    ApplyEGFRFormula();
                }
                catch (e) {
                }
            }
            function ApplyEGFRFormula() {
                 
               
                var mmvalue = '';
                for (var i = 0; i < LabObservationData.length; i++) {
                       
                       if (((LabObservationData[i].Investigation_ID == '3515' || LabObservationData[i].Investigation_ID == '7129') && LabObservationData[i].Value != ''  && LabObservationData[i].LabObservation_ID == '59') ) {

                        var CREATININE = LabObservationData[i].Value;
                        var AgeInYear = LabObservationData[i].AgeInDays / 365;
                        //if( LabObservationData[i].country==""
                        //Female 175*(Serum Creatinine)^-1.154 x (Age)^-0.203*(0.742)*(1.0)
                        if (LabObservationData[i].Gender == "Female") {

                            var a = Math.pow(CREATININE, (-1.154));
                            var b = Math.pow(AgeInYear, (-0.203));
                            mmvalue = 186  * a * b * 0.742 * 1.0;
                // (186.3 * (Math.pow(sCritinine, -1.154)) * Math.pow(age.split(" ")[0], -0.203) * LastValue).toFixed(2);
                        }

                        //Male 175*(Serum Creatinine)^-1.154 x (Age)^-0.203*(1.0)*(1.0)
                        if (LabObservationData[i].Gender == "Male") {
                            var a = Math.pow(CREATININE, (-1.154));
                            var b = Math.pow(AgeInYear, (-0.203));
                            mmvalue = 186  * a * b * 1.0 * 1.0;
                        }
                    }

                    if (LabObservationData[i].LabObservation_ID == '585') {
                        LabObservationData[i].Value = mmvalue.toFixed(2);
                    }
                }
            }
            function ApplyFormula() {
                for (var i = 0; i < LabObservationData.length; i++) {
                    if (LabObservationData[i].Inv == '0') {
                        LabObservationData[i].isCulture = LabObservationData[i].Formula;
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
                                _salek = eval(LabObservationData[i].isCulture);
                                 if (_salek == 'NA')
                                    LabObservationData[i].Value = _salek;
                                else if (_salek != '')
                                    LabObservationData[i].Value = Math.round(_salek * 100) / 100;
                                else if (LabObservationData[i].LabObservation_ID != '45')
                                    LabObservationData[i].Value = "";

                            } catch (e) { LabObservationData[i].Value = '' }
                            var ans = LabObservationData[i].Value;
                            if (((isNaN(ans)) || (ans == "Infinity")) && _salek !='NA') {
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
                $("#<%=ddltest.ClientID %> option").remove();
                var ddlTest = $("#<%=ddltest.ClientID %>");
                $.ajax({
                    url: "MachineResultEntry.aspx/BindTestToForward",
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
                    url: "MachineResultEntry.aspx/BindCentreToForward",
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
                $find("<%=ModalPopupExtender2.ClientID%>").show();
            }
            function binddoctoforward() {
                $("#<%=ddlforward.ClientID %> option").remove();
                var ddlforward = $("#<%=ddlforward.ClientID %>");
                $.ajax({
                    url: "MachineResultEntry.aspx/BindDoctorToForward",
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
                    $('#msgField').html('');
                    $('#msgField').append("Please Select Test");
                    $(".alert").css('background-color', 'red');
                    $(".alert").removeClass("in").show();
                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    $("#<%=ddltest.ClientID %>").focus();
                    return;
                }
                var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
                if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {
                    $('#msgField').html('');
                    $('#msgField').append("Please Select Centre");
                    $(".alert").css('background-color', 'red');
                    $(".alert").removeClass("in").show();
                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    $("#<%=ddlcentre.ClientID %>").focus();
                    return;
                }
                var length3 = $('#<%=ddlforward.ClientID %>  option').length;
                if ($("#<%=ddlforward.ClientID %> option:selected").val() == "" || length3 == 0) {
                    $('#msgField').html('');
                    $('#msgField').append("Please Select Doctor to Forward");
                    $(".alert").css('background-color', 'red');
                    $(".alert").removeClass("in").show();
                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    $("#<%=ddlforward.ClientID %>").focus();
                    return;
                }
                $.ajax({
                    url: "MachineResultEntry.aspx/ForwardMe",
                    data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '", MobileApproved:0,MobileEMINo:"", MobileNo: "", MobileLatitude: "", MobileLongitude: ""}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $('#msgField').html('');
                            $('#msgField').append("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                                    $(".alert").css('background-color', '#04b076');
                                    $(".alert").removeClass("in").show();
                                    $(".alert").delay(1500).addClass("in").fadeOut(1500);
                                    $find("<%=ModalPopupExtender2.ClientID%>").hide();

                                    var totalRows = PatientData.length - 1;
                                    if (totalRows > currentRow) {
                                        PickRowData(currentRow + 1);
                                    }
                                    else {
                                        PickRowData(currentRow);
                                    }
                                }
                                else {
                                    $('#msgField').html('');
                                    $('#msgField').append(result.d);
                                    $(".alert").css('background-color', 'red');
                                    $(".alert").removeClass("in").show();
                                    $(".alert").delay(1500).addClass("in").fadeOut(1500);
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
                }
                function NotApprovedFinaly() {
                    if ($('#<%=txtnotappremarks.ClientID%>').val() == "") {
                        $('#<%=txtnotappremarks.ClientID%>').focus();
                        showerrormsg("Please Enter Not Approved Remarks");
                        return;
                    }
                    $find('mpnotapprovedrecord').hide();
                    resultStatus = "Not Approved";
                    SaveLabObs();
                }
                function showerrormsg(msg) {
                    $('#msgField').html('');
                    $('#msgField').append(msg);
                    $(".alert").css('background-color', 'red');
                    $(".alert").removeClass("in").show();
                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                }
                var reflextestid = "";
                function checkreflextest() {
                    var aa = 0; var re = "";
                    for (var a = 0; a < LabObservationData.length; a++) {
                        if (LabObservationData[a].Isreflex == "1" && (parseFloat(LabObservationData[a].Value) <= parseFloat(LabObservationData[a].ReflexMin) || parseFloat(LabObservationData[a].Value) >= parseFloat(LabObservationData[a].ReflexMax))) {
                            aa = 1;
                            re = LabObservationData[a].Test_ID + "#" + LabObservationData[a].LabObservation_ID + "#" + LabObservationData[a].LabNo + "#" + LabObservationData[a].Investigation_ID;
                            reflextestid = re;
                            return false;
                        }
                    }
                    if (aa == 0) {
                        reflextestid = "";
                        return true;
                    }
                    else {
                        alert(re);
                        return false;
                    }
                }
                function saveapprovalwithoutreflex() {
                    $find("<%=ModalPopupExtender1.ClientID%>").hide();
                    resultStatus = "Approved";
                    SaveLabObs();
                }
                function Approved() {
                    resultStatus = "Approved";
                    if (checkreflextest() == true) {
                        SaveLabObs();
                    }
                    else {
                        // Show Reflex POP UP
                        $.ajax({
                            url: "MachineResultEntry.aspx/getreflextestlist",
                            //string ApprovedBy,string ApprovalName
                            data: '{Test_ID:"' + reflextestid.split('#')[0] + '",LabObservation_ID:"' + reflextestid.split('#')[1] + '",LabNo:"' + reflextestid.split('#')[2] + '",Investigation_ID:"' + reflextestid.split('#')[3] + '"}',
                            type: "POST", // data has to be Posted    	        
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {
                                $('#mmc tr').slice(1).remove();
                                if (result.d == "") {
                                    SaveLabObs();
                                    return;
                                }
                                for (var a = 0; a <= result.d.split(',').length - 1; a++) {
                                    var $temp = [];
                                    $temp.push('<tr class="GridViewItemStyle" style="background-color:lemonchiffon">');
                                    $temp.push('<td>');
                                    $temp.push(result.d.split(',')[a].split('#')[0]); $temp.push('</td>');
                                    $temp.push('<td><input type="checkbox" checked="checked" id="mmccheck"/></td>');
                                    $temp.push('<td id="invid" style="display:none;">');
                                    $temp.push(result.d.split(',')[a].split('#')[1]); $temp.push('</td>');
                                    $temp.push('<td id="testid" style="display:none;">');
                                    $temp.push(result.d.split(',')[a].split('#')[2]); $temp.push('</td>');
                                    $temp.push('<td id="obsidid" style="display:none;">');
                                    $temp.push(result.d.split(',')[a].split('#')[3]); $temp.push('</td>');
                                    $temp.push('</tr>');
                                    $temp = $temp.join("");
                                    $('#mmc').append($temp);
                                }
                                $find("<%=ModalPopupExtender1.ClientID%>").show();
                            },
                            error: function (xhr, status) {
                            }
                        });
                    }
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
                function SaveLabObs() {
                    if (IsRadiology && ModalRow != '') {
                        var RcommentValue = CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].getData();
                        LabObservationData[ModalRow].Description = RcommentValue;
                        LabObservationData[ModalRow].Method = "1";
                    }
                    var r = true;
                    if (resultStatus == "Save"  ||  resultStatus == "Approved") {
                       // console.log(LabObservationData);
                        $.each(LabObservationData, function (key, value) {
                          //  console.log(value.Investigation_ID);
                            if (value.Investigation_ID == "2118" && value.Value == "POSITIVE") {
                                r = confirm("Covid Value Is Positive Do You Want To Continue ?");
                                return;
                            }
                        }); 
                    }
                    if (r == true) {
                        var notapprovalcomment = "";
                        if (resultStatus == "Not Approved")
                            notapprovalcomment = $.trim($("#txtnotappremarks").val());
                        var HoldRemarks = "";
                        if (resultStatus == "Hold")
                            HoldRemarks = $.trim($("#txtHoldRemarks").val());
                        MachineID_Manual = ($("#ddlTestDon").val() == "") ? 0 : $("#ddlTestDon").val();
                        var IsDefaultSing = '<%=IsDefaultSing%>';

                    var isholddocumentrequired = 0;

                    if (resultStatus == "Hold")
                        isholddocumentrequired = $('#<%=chholddoc.ClientID%>').is(":checked") ? 1 : 0;

                    chkChamp

                    $.ajax({
                        url: "MachineResultEntry.aspx/SaveLabObservationOpdData",
                        data: JSON.stringify({ data: LabObservationData, ResultStatus: resultStatus, ApprovedBy: (($('#ddlApprove').length > 0) ? $('#ddlApprove').val() : ''), ApprovalName: (($('#ddlApprove').length > 0) ? $('#ddlApprove :selected').text() : ''), HoldRemarks: HoldRemarks, criticalsave: criticalsave, notapprovalcomment: notapprovalcomment, macvalue: macvalue, MachineID_Manual: MachineID_Manual, MobileApproved: '0', IsDefaultSing: IsDefaultSing, MobileEMINo: "", MobileNo: "", MobileLatitude: "", MobileLongitude: "", isholddocumentrequired: isholddocumentrequired }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            criticalsave = "0";
                            macvalue = "0";
                            if (result.d.split('##')[0] == 'success') {
                                toast("Success", "Successfully Saved", "");
                                var totalRows = PatientData.length - 1;
                                if (totalRows > currentRow && result.d.split('##')[1]=='1') {
                                    PickRowData(currentRow + 1);
                                }
                                else if (result.d.split('##')[1] == '0') {
                                    PickRowData(currentRow);
                                }
                                if (resultStatus == "Hold") {
                                    closeHoldRemarks();

                                }
                                else if (resultStatus == "Approved") {
                                    $('#btnUnholdLabObs,#btnholdLabObs').hide();
                                }
                            }
                            else {
                                if (result.d == "Critical") {
                                    $('#showpopupmsg').show();
                                    $('#showpopupmsg').html("Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?");
                                    $('#popup_box').fadeIn("slow");
                                    $("#Pbody_box_inventory").css({
                                        "opacity": "0.3"
                                    });
                                }
                                if (result.d == "MacValue") {
                                    $('#showpopupmsg1').show();
                                    $('#showpopupmsg1').html("Entered Value Different from Mac Reading.!<br/>Do You Want To Continue..?");
                                    $('#popup_box1').fadeIn("slow");
                                    $("#Pbody_box_inventory").css({
                                        "opacity": "0.3"
                                    });
                                }
                                else if (result.d == "AbnormalAlert") {
                                    $('#showpopupmsg').show();
                                    $('#showpopupmsg').html("Result Has Abnormal Value..!<br/>Do You Want To Continue..?");
                                    $('#popup_box').fadeIn("slow");
                                    $("#Pbody_box_inventory").css({
                                        "opacity": "0.3"
                                    });
                                }
                                else {
                                    $('#msgField').html('');
                                    $('#msgField').append(result);
                                    $(".alert").css('background-color', 'red');
                                    $(".alert").removeClass("in").show();
                                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                                }
                            }
                        },
                        error: function (xhr, status) {
                            var err = eval("(" + xhr.responseText + ")");
                            if (err.Message == "Critical") {
                                $('#showpopupmsg').show();
                                $('#showpopupmsg').html("Result Has Critical Value.Please Rerun Sample.!<br/>Do You Want To Continue..?");
                                $('#popup_box').fadeIn("slow");
                                $("#Pbody_box_inventory").css({
                                    "opacity": "0.3"
                                });
                            }
                            else if (err.Message == "MacValue") {
                                $('#showpopupmsg1').show();
                                $('#showpopupmsg1').html("Entered Value Different from Mac Reading.!<br/>Do You Want To Continue..?");
                                $('#popup_box1').fadeIn("slow");
                                $("#Pbody_box_inventory").css({
                                    "opacity": "0.3"
                                });
                            }
                            else if (err.Message == "AbnormalAlert") {
                                $('#showpopupmsg').show();
                                $('#showpopupmsg').html("Result Has Abnormal Value..!<br/>Do You Want To Continue..?");
                                $('#popup_box').fadeIn("slow");
                                $("#Pbody_box_inventory").css({
                                    "opacity": "0.3"
                                });
                            }
                            else {
                                toast("Info", err.Message, "");
                            }
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
                }
                function unloadPopupBox() {    // TO Unload the Popupbox
                    $('#popup_box').fadeOut("slow");
                    $("#Pbody_box_inventory").css({ // this is just for style        
                        "opacity": "1"
                    });
                    //$('#showpopupmsg').html('');
                }
                function unloadPopupBox1() {    // TO Unload the Popupbox
                    $('#popup_box1').fadeOut("slow");
                    $("#Pbody_box_inventory").css({ // this is just for style        
                        "opacity": "1"
                    });
                    //$('#showpopupmsg').html('');
                }
                function saveifcritical() {
                    criticalsave = "1";
                    unloadPopupBox();
                    SaveLabObs();
                }
                function savediffrentvaluefrommacdata() {
                    macvalue = "1";
                    unloadPopupBox1();
                    SaveLabObs();
                }
                function PrintReport() {
                    var PHeader = $("#chkheader").is(':checked') ? 1 : 0;
                    if ('<%=Session["RoleID"]%>')
                        window.open('labreportnew.aspx?IsPrev=1&TestID=' + PatientData[currentRow].Test_ID + ',&Phead=' + PHeader + '');
                    else
                        window.open('labreportnew.aspx?IsPrev=1&TestID=' + PatientData[currentRow].Test_ID + ',&Phead=0');
                }
                function UpdateBarcodes(row, _barcode) {
                    var TestID = PatientData[row].Test_ID;
                    var LedgerTransactionNo = PatientData[row].LedgerTransactionNo;
                    var _temp = [];
                    _temp.push(serverCall('MachineResultEntry.aspx/UpdateLabInvestigationOpdData', { TestID: TestID, Barcode: _barcode, LedgerTransactionNo: LedgerTransactionNo }, function (response) {
                        $.when.apply(null, _temp).done(function () {
                            var $responseData = JSON.parse(response);
                            if ($responseData.status) {
                                toast("Success", "Successfully Updated", "");
                            }
                            else {
                                toast("Error", $responseData.response, "");
                            }
                        });
                    }));
                }
                function SearchInvestigation(LabNo) {
                    var _temp = [];
                    _temp.push(serverCall('SampleCollectionPatient.aspx/SearchInvestigation', { LabNo: LabNo, SmpleColl: $("#<%=ddlSampleStatus.ClientID%>").val(), Department: $("#<%=ddlDepartment.ClientID%>").val() }, function (response) {
                        $.when.apply(null, _temp).done(function () {
                            PatientData = $.parseJSON(result.d);
                            if (PatientData == "-1") {
                                toast("Error", "Your Session Expired.... Please Login Again", "");
                                return;
                            }
                            if (PatientData.length == 0) {
                                toast("Info", "No Record Found", "");
                                return;
                            }
                            else {
                                var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                                $('#divInvestigation').html(output);
                                $('.chkSample').each(function () {
                                    this.checked = true;
                                });
                            }
                        })
                    }));
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
                        toast("Error", "Please Select Sample First", "");
                        return;
                    }
                    $.ajax({
                        url: "SampleCollectionPatient.aspx/SaveSampleCollection",
                        data: '{ ItemData:"' + ItemData + '",Type:"' + Type + '"}', // parameter map       
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            if (result == "-1") {
                                toast("Error", "Your Session Expired...Please Login Again", "");
                                return;
                            }
                            if (result == "0") {
                                toast("Error", "Record Not Save", "");
                                return;
                            }
                            if (result == "1") {
                                getBarcode('', BarcodeID);
                                return;
                            }
                        },
                        error: function (xhr, status) {
                            toast("Error", "Please Contact to ItDose Support Team", "");
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
                            toast("Error", "Please Contact to ItDose Support Team", "");
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
                                alert("Cropped Successfully.");
                                $('#<%=X.ClientID%>,#<%=Y.ClientID%>,#<%=W.ClientID%>,#<%=H.ClientID%>').val('');
                            },
                            error: function (xhr, status) {
                            }
                        });
                    }
                }
                function closeme() {
                    try {
                        window.opener.SearchData();
                    }
                    catch (e) {
                    }
                    this.close();
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
        <script type="text/javascript">
            function pageLoad(sender, args) {
                if (!args.get_isPartialLoad()) {
                    $addHandler(document, "keydown", onKeyDown);
                }
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
            function getaddata() {
                var tempData = [];
                $('#mmc tr').each(function () {
                    if ($(this).attr("id") != "mmh") {
                        if ($(this).find("#mmccheck").prop('checked') == true) {
                            var itemmaster = [];
                            itemmaster[0] = $(this).find("#testid").html();//testid
                            itemmaster[1] = $(this).find("#obsidid").html();//obsid
                            itemmaster[2] = $(this).find("#invid").html();//booktestid
                            tempData.push(itemmaster);
                        }
                    }
                });
                return tempData;
            }
            function Addme() {
                var mydataadj = getaddata();
                if (mydataadj == "") {
                    $('#msgField').html('');
                    $('#msgField').append("Please Select test To Add");
                    $(".alert").css('background-color', 'red');
                    $(".alert").removeClass("in").show();
                    $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    return;
                }
                $.ajax({
                    url: "MachineResultEntry.aspx/saveNewtest",
                    data: JSON.stringify({ mydataadj: mydataadj }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 130000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $('#msgField').html('');
                            $('#msgField').append("Saved Successfully");
                            $(".alert").css('background-color', '#04b076');
                            $(".alert").removeClass("in").show();
                            $(".alert").delay(1500).addClass("in").fadeOut(1000);
                            $find("<%=ModalPopupExtender1.ClientID%>").hide();
                        }
                        else {
                            $('#msgField').html('');
                            $('#msgField').append(result.d);
                            $(".alert").css('background-color', 'red');
                            $(".alert").removeClass("in").show();
                            $(".alert").delay(1500).addClass("in").fadeOut(1000);
                        }
                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });
            }
            function confirmStatus(content, Id) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: content,
                    animation: 'zoom',
                    closeAnimation: 'scale',
                    useBootstrap: false,
                    opacity: 0.5,
                    theme: 'light',
                    type: 'red',
                    typeAnimated: true,
                    boxWidth: '420px',
                    buttons: {
                        'confirm': {
                            text: 'Yes',
                            useBootstrap: false,
                            btnClass: 'btn-blue',
                            action: function () {
                                openmypopup("../../Design/Investigation/AddInterpretation.aspx?TestID=" + Id);
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                               
                            }
                        },
                    }
                });
            }
            function openinterpretation(TestID) {
                confirmStatus("Do You want To Edit in Interpretation ?", TestID)
            }
            function openmecomment(TestID) {
                openmypopup("ShowInvComment.aspx?TestId=" + TestID);
            }
            function openmypopup(href) {
                var width = '1120px';
                $.fancybox({
                    'background': 'none',
                    'hideOnOverlayClick': true,
                    'overlayColor': 'gray',
                    'width': width,
                    'height': '800px',
                    'autoScale': false,
                    'autoDimensions': false,
                    'transitionIn': 'elastic',
                    'transitionOut': 'elastic',
                    'speedIn': 6,
                    'speedOut': 6,
                    'href': href,
                    'overlayShow': true,
                    'type': 'iframe',
                    'opacity': true,
                    'centerOnScroll': true,
                    'onComplete': function () {
                    },
                    afterClose: function () {
                    }
                });
            }
            function MainList() {
                $('#divPatient').toggle();
                $('#MainInfoDiv').toggle();
                var PickedRow = 'lnk_' + $('[id$=hdnPickedRow]').val();
                $('#' + PickedRow).closest('tr').find('td').addClass('currentRow');
                $('#' + PickedRow).parent().removeClass('currentRow');
                $('#' + PickedRow).parent().addClass('current highlight');
                hot1.render();
                hot2.render();
            }
            $closeSmsModel = function () {
                jQuery('#divsms').hideModel();
                $('#tblsms tr').slice(1).remove();
            }
            function loadSmsdetail(MobileNo, labno) {
                $('#txtmobilereportsms').val(MobileNo);
                $('#hdnlabno').val(labno);
                serverCall('MachineResultEntry.aspx/loadSmsdetail', { MobileNo: MobileNo }, function (response) {
                    var $responseData = JSON.parse(response);
                    for (var i = 0; i < $responseData.length; i++) {
                        var $mydata = [];
                        $mydata.push('<tr class="GridViewItemStyle">');
                        $mydata.push('<td>'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].Mobile_No); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].Sms_Type); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].STATUS); $mydata.push('</td>');
                        $mydata.push('<td>'); $mydata.push($responseData[i].EntDate); $mydata.push('</td>');
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#tblsms').append($mydata);
                    }

                    jQuery('#divsms').showModel();
                });
            }
			    function checkme(ctrl) {
                var morecheckbox = $(ctrl).attr("class");
                if ($(ctrl).is(":checked")) {
                    $('.' + morecheckbox).attr('checked', true);
                    for (var i = 0; i < LabObservationData.length; i++) {

                        if (LabObservationData[i].Inv != "3" && LabObservationData[i].Test_ID == morecheckbox) {
                            LabObservationData[i].SaveInv = "true";
                        }
                    }

                }
                else {
                    $('.' + morecheckbox).attr('checked', false);

                    for (var i = 0; i < LabObservationData.length; i++) {

                        if (LabObservationData[i].Inv != "3" && LabObservationData[i].Test_ID == morecheckbox) {
                            LabObservationData[i].SaveInv = "false";
                        }
                    }
                }
            }
            function sendTATsms() {
                    if ($('#txtmobilereportsms').val() == "") {
                        toast("Error", "Please enter Mobile No for SMS..!", "");
                        return;
                    }
                    if ($('#labendtime').val() == "") {
                        toast("Error", "Please enter TAT Time..!", "");
                        return;
                    }
                    var tatdate = "".concat($('#txttatdate').val(), " ", $('#labendtime').val());
                    serverCall('MachineResultEntry.aspx/sendTATsms', { MobileNo: $('#txtmobilereportsms').val(), LabNo: $('#hdnlabno').val(), TATDate: tatdate }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }

                });
            }

            function CheckBoxrender(instance, td, row, col, prop, value, cellProperties) {
                if (LabObservationData[row].Inv == "1") {
                    td.innerHTML = "<input onclick='checkme(this)' class= '" + LabObservationData[row+1].Test_ID + "' type='checkbox' checked='" + value + "'/> ";
                }
                if (LabObservationData[row].Inv != "1" && LabObservationData[row].Inv != "3") {
                    td.innerHTML = "<input class= '" + LabObservationData[row].Test_ID + "' type='checkbox' disabled='disabled'  checked='" + value + "' /> ";
                }
                if (LabObservationData[row].Inv == "3") {
                    td.innerHTML = "";
                }
                return td;
            }
			  function TestDoneRadiology() {
                console.log(ModalRow);
                var TestID = LabObservationData[ModalRow].Test_ID
                var LabNo = LabObservationData[ModalRow].LabNo;
                var InvID = LabObservationData[ModalRow].Investigation_ID;
                var ReportType = LabObservationData[ModalRow].ReportType;
                loadPathMachine(ModalRow, "", TestID, InvID, LabNo, ReportType);
            }
			 function ClearRadiologyComment()
          {
               CKEDITOR.instances['<%=CKEditorControl2.ClientID%>'].setData('');
          }
		     function LoadAutoCorrect() {
                $.ajax({
                    url: "MachineResultEntry.aspx/GetAutoCorrect",
                    data: '',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        result = $.parseJSON(result.d);
                        CKEDITOR.config.autocorrect_replacementTable = result;
			CKEDITOR.config.extraPlugins = 'font';
                        // {"abc":"asdkfhajkshdfjkhaskjdf","xyz":"pplsldasdfpoaspdofp" };
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        </script>
        <asp:Button ID="Button2" runat="server" Style="display: none;" />
        <asp:Panel ID="pnl" runat="server" BackColor="#EAF3FD" Style="width: 400px; border: 2px solid maroon; display: none;">
            <div class="Purchaseheader">Reflex Test</div>
            <br />
            <table id="mmc" style="width: 99%; border-collapse: collapse;">
                <tr id="mmh">
                    <td class="GridViewHeaderStyle">Test Name</td>
                    <td class="GridViewHeaderStyle"></td>
                </tr>
            </table>
            <table style="width: 100%" frame="box">
                <tr>
                    <td align="right">
                        <input type="button" value="Add Now" onclick="Addme()" class="savebutton" />
                    </td>
                    <td>
                        <asp:Button Style="display: none;" ID="btn" runat="server" Text="Close" CssClass="resetbutton" />
                        <input type="button" class="resetbutton" value="Cancel" onclick="saveapprovalwithoutreflex()" /></td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button2"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btn">
        </cc1:ModalPopupExtender>
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
            BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" CancelControlID="Button3">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Panel2" runat="server" BackColor="#EAF3FD" Style="width: 400px; border: 2px solid maroon; display: none;">
            <div class="Purchaseheader">Delta Check Option</div>
            <br />
            <table style="width: 99%; border-collapse: collapse;">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" style="font-weight: bold;" onclick="opendelta1()">Tabular Format</a>  </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr style="display:none;">
                    <td>&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" style="font-weight: bold;" onclick="opendelta2()">Graph Format</a>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;<asp:Button ID="Button4" runat="server" Text="Close" CssClass="resetbutton" /></td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
            </table>
        </asp:Panel>

        <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server" TargetControlID="Button2"
            BackgroundCssClass="filterPupupBackground" PopupControlID="Panel2" CancelControlID="Button4">
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
                    <td style="text-align: right">Hold Remarks :&nbsp;
                    </td>
                    <td>
                        <input type="text" maxlength="50" id="txtHoldRemarks" style="width: 240px" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:CheckBox ID="chholddoc" runat="server" Text="Document Required" Font-Bold="true" />
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
            <%-- <table style="border-collapse: collapse">
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
        </table>--%>
        </asp:Panel>
        <asp:Button ID="btnHideHold" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="mpHoldRemarks" runat="server" CancelControlID="btnCancelHold"
            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlHoldRemarks" OnCancelScript="closeHoldRemarks()" BehaviorID="mpHoldRemarks">
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
            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
        </cc1:ModalPopupExtender>
        <div id="popup_box" style="background-color: #eaffc0; height: 80px; text-align: center; width: 440px; font-weight: bold;">
            <div id="showpopupmsg"></div>
            <br />
            <input type="button" class="savebutton" value=" Yes " onclick="saveifcritical()" />
            <input type="button" class="searchbutton" value=" No " onclick="unloadPopupBox()" />
        </div>

        <div id="popup_box1" style="background-color: #eaffc0; height: 80px; text-align: center; width: 440px; font-weight: bold;">
            <div id="showpopupmsg1"></div>
            <br />
            <input type="button" class="savebutton" value=" Yes " onclick="savediffrentvaluefrommacdata()" />
            <input type="button" class="searchbutton" value=" No " onclick="unloadPopupBox1()" />
        </div>
         <div id="divsms" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 70%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Send TAT SMS</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeSmsModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
             <div class="row">
                 <div class="col-md-2">Date:</div>
                 <div class="col-md-3"><asp:TextBox ID="txttatdate" runat="server"></asp:TextBox>
                      <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txttatdate" TargetControlID="txttatdate" />
                 </div>
                 <div class="col-md-2">Time:</div>
                 <div class="col-md-2"> <input type="text" id="labendtime"/> </div>
                 <div class="col-md-2"> </div>
                 
       
                 <div class="col-md-3"><asp:TextBox ID="txtmobilereportsms" runat="server"></asp:TextBox>
                     <asp:HiddenField ID="hdnlabno" runat="server" /> </div>
                 <div class="col-md-5"><input type="button" id="btnsendsms"  onclick="sendTATsms()" class="searchbutton" value="Send SMS" /> </div>
                  <div class="col-md-5"> </div>
             </div>
             <div class="row" style="overflow:scroll;height:200px">
                 <div class="col-md-24">
               <table id="tblsms" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trh">
                         <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                         <td class="GridViewHeaderStyle">Mobile</td>
                         <td class="GridViewHeaderStyle">SMS Type</td>
                         <td class="GridViewHeaderStyle">Status</td>
                         <td class="GridViewHeaderStyle">Date</td>
                         
                    </tr>
                </table>
                 </div>
             </div>
             </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeSmsModel()">Close</button>
			</div>
            </div>
        </div>
      </div>
        <script type="text/javascript">
            function openAddReport(LedgerTransactionNo, _test_id) {
                serverCall('MachineResultEntry.aspx/encryptData', { LedgerTransactionNo: LedgerTransactionNo, Test_ID: _test_id }, function (response) {
                    var $responseData = jQuery.parseJSON(response);
                    window.open('AddReport.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&Test_ID=' + $responseData.Test_ID, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

                });
            }

            $openReject = function (Barcodeno) {
                $encryptQueryStringData(Barcodeno, function ($returnData) {
                    $fancyBoxOpen('SampleReject.aspx?BarcodeNo=' + $returnData + '');
                });
            }
        </script>
    </div>
</asp:Content>

