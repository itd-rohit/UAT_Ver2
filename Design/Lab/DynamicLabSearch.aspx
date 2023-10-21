<%@ Page Title="Sample Tracker" ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DynamicLabSearch.aspx.cs" Inherits="Design_Lab_DynamicLabSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <style type="text/css">
        div#divLabDetail {
            height: 200px;
            overflow: scroll;
        }

        .auto-style1 {
            width: 430px;
        }
    </style>
  
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-24" style="text-align:center">
                    <b>Sample Tracker </b>
                    <br />
                 
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-9">   <%-- auto-style1--%>
                    SIN No. OR Visit ID OR Mobile No. OR UHID No. OR Biopsy No. :
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtDynamicSearch" runat="server" CssClass="ItDoseTextinputText" />
                </div>
                <div class="col-md-3">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton"  />
                </div>
               
                <div class="col-md-9">
                    <input type="checkbox" id="chheader" class="mmc" /><strong>Header</strong>
                    <input id="btnprint" type="button" value="Print" class="resetbutton" onclick="PrintReport('0')" />
                    <input id="btnPreview" type="button" value="Preview" class="resetbutton" onclick="PrintReport('1')" />
                </div>
            </div>
           <div class="row">
               <div class="col-md-24">
                <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;"
                        onclick="PatientLabSearch('1')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;"
                        onclick="PatientLabSearch('2')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Sample Collected</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: White;"
                        onclick="PatientLabSearch('3')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Department Receive</td>
                    <%--<td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #B0C4DE;" onclick="PatientLabSearch('4')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Mac Data</td>--%>
                    <%--<td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #F781D8;"  onclick="PatientLabSearch('5')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               ReRun</td> --%>
                    <%--<td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #A9A9A9;"  onclick="PatientLabSearch('6')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                InComplete</td>--%>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #FFC0CB;"
                        onclick="PatientLabSearch('7')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Tested</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"
                        onclick="PatientLabSearch('8')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Approved</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #00FFFF;"
                        onclick="PatientLabSearch('9')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Printed</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #FFFF00;"
                        onclick="PatientLabSearch('10')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Hold</td>
                    <%--  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #3399FF;" onclick="PatientLabSearch('11')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Forward</td>--%>
                    <%-- <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #E9967A;" onclick="PatientLabSearch('12')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Received</td>--%>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #44A3AA;"
                        onclick="PatientLabSearch('13')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Dispatched</td>
                    <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #ccc;"
                        onclick="PatientLabSearch('13')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rejected</td>
                </tr>
            </table>
               </div>
           </div>
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Sample Status Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <table style="width: 99%; border-collapse: collapse" id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" >S.No.</td>
                        <td class="GridViewHeaderStyle" >Entry DateTime</td>
                        <td class="GridViewHeaderStyle" >Lab No.</td>
                        <td class="GridViewHeaderStyle" >SIN No.</td>
                        <td class="GridViewHeaderStyle">Patient Name</td>
                        <td class="GridViewHeaderStyle" >Patient Mobile</td>
                        <td class="GridViewHeaderStyle" >Age/Sex</td>
                        <td class="GridViewHeaderStyle" >Centre</td>
                        <td class="GridViewHeaderStyle" >Rate Type</td>
                        <td class="GridViewHeaderStyle" >Doctor</td>
                        <td class="GridViewHeaderStyle" >Doctor Mobile</td>
                        <td class="GridViewHeaderStyle" >PRO</td>
                        <td class="GridViewHeaderStyle" >Department</td>
                        <td class="GridViewHeaderStyle" >Investigation</td>
                        <td class="GridViewHeaderStyle" >Source</td>
                        <td class="GridViewHeaderStyle" >
                            <input type="checkbox" id="hd" onclick="call()" class="mmc" /></td>
                        <td class="GridViewHeaderStyle" >View</td>
                        <td class="GridViewHeaderStyle" >Clinical History</td>
                        <td class="GridViewHeaderStyle" >Is Uploaded</td>
                         <td class="GridViewHeaderStyle" >Document Upload</td>
                        <td class="GridViewHeaderStyle" >BarCode Reprint</td>
                        <td class="GridViewHeaderStyle" >Remarks</td>
                    </tr>
                </table>
                </div>
            </div>
            
            <%-- <div class="Purchaseheader">
                Accounting Status Details
            </div>
            <div id="PatientLabSearchOutput_Account">
            </div>--%>
        </div>
        <asp:Button ID="btnHideLab" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="mpLabInfo" runat="server" CancelControlID="btnCancelLabInfo"
            DropShadow="true" TargetControlID="btnHideLab" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlLabDisplay" OnCancelScript="closeLabData()" BehaviorID="mpLabInfo">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlLabDisplay" runat="server" Style="display: none; width: 860px; height: 264px;" CssClass="pnlVendorItemsFilter"
            ScrollBars="Both">
            <div class="Purchaseheader" id="Div1" runat="server">
                <table style="width: 100%; border-collapse: collapse" border="0">
                    <tr>
                        <td>
                            <b>Test Detail</b>
                        </td>
                        <td style="text-align: right">
                            <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../App_Images/Delete.gif" style="cursor: pointer" onclick="closeLabData()" alt="" />
                                to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divLabDetail"></div>
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td style="text-align: center">

                        <asp:Button ID="btnCancelLabInfo" runat="server" CssClass="ItDoseButton" Text="Close"
                            ToolTip="Click To Cancel" />
                    </td>

                </tr>
            </table>
        </asp:Panel>
    </div>
    <script type="text/javascript">
        var RoleID = '<%=UserInfo.RoleID.ToString()%>';
        $(function () {
            $("#btnSearch").click(PatientLabSearch);          
            $('#txtDynamicSearch').keypress(function (event) {
                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    PatientLabSearch();
                }
            });
        });     
        function call() {
            if ($('#hd').prop('checked') == true) {
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        $(this).closest("tr").find('#mmchk').prop('checked', true);
                    }
                });
            }
            else {
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "saheader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', false);
                    }
                });
            }
        }
        function PrintReport(IsPrev) {
            var testid = "";
            var id = "";
            $('#tb_ItemList tr').each(function () {
                id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    if ($(this).closest("tr").find('#mmchk').prop('checked') == true) {
                        testid += id + ",";
                        if (IsPrev == '0')
                            $(this).closest("tr").css('background-color', '#00FFFF');
                    }
                }
            });
            if (testid == "") {
                toast("Info", "Please Select Test To Print", "");
                return;
            }
            if ($('#chheader').prop('checked') == true) {
                window.open("labreportnew.aspx?IsPrev=" + IsPrev + "&PHead=1&testid=" + testid);
            }
            else {
                window.open("labreportnew.aspx?IsPrev=" + IsPrev + "&testid=" + testid);
            }
            $('.mmc').prop('checked', false);
        }
        function PatientLabSearch() {
            $('#<%=txtDynamicSearch.ClientID%>').focus();
            if ($("#<%=txtDynamicSearch.ClientID %>").val() == "") {
                toast("Info", "Please Enter SIN No. OR Visit ID OR Mobile No.", "");
                return;
            }
            $('#tb_ItemList tr').slice(1).remove();
           

            serverCall('DynamicLabSearch.aspx/SearchDynamic', { DynamicSearch: $("#<%=txtDynamicSearch.ClientID %>").val() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        toast("Error", "Incorrect SIN No./Visit ID/Mobile N.o/UHID No./Biopsy No.", "");
                    }
                    else {
                        var barcodeno = "";
                        var Labno = "";
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $mydata = [];                         
                            $mydata.push("<tr id='");
                            $mydata.push($responseData[i].Test_ID);
                            $mydata.push("'");
                            $mydata.push("style='background-color:");
                            $mydata.push($responseData[i].rowColor);
                            $mydata.push(";'>");

                            if ($responseData[i].LogisticStatus != "") {
                                $mydata.push("<td class='GridViewLabItemStyle' >");
                                $mydata.push(parseInt(i + 1));
                                $mydata.push("<img src='../../App_Images/truck.jpg' style='width:24px; height:24px' title='");
                                $mydata.push($responseData[i].LogisticStatus);
                                $mydata.push("'");
                                $mydata.push('/></td>');
                            }
                            else {
                                $mydata.push('<td class="GridViewLabItemStyle" >');
                                $mydata.push(parseInt(i + 1));
                                $mydata.push('</td>');
                            }
                            if (barcodeno != $responseData[i].BarcodeNo || Labno != $responseData[i].LedgerTransactionNo) {

                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].EntryDate)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle"><b>');
                                $mydata.push($responseData[i].LedgerTransactionNo)
                                $mydata.push('</b></td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="td_BarcodeNo"><b>');
                                $mydata.push($responseData[i].BarcodeNo)
                                $mydata.push('</b></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"><b>');
                                $mydata.push($responseData[i].PName)
                                $mydata.push('</b></td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].PMob.replace('-', ''))
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].pinfo)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].centre)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].PanelName)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].DoctorName)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].DocMob)
                                $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle">');
                                $mydata.push($responseData[i].PROName)
                                $mydata.push('</td>');

                            }
                            else {
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                            }
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            $mydata.push($responseData[i].Dept);
                            $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            $mydata.push($responseData[i].ItemName);
                            $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            $mydata.push($responseData[i].PatientSource);
                            $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            if ($responseData[i].Approved == "1") {
                                $mydata.push('<input type="checkbox" id="mmchk" class="mmc" />');
                            }
                            $mydata.push('</td>');
                          
                            $mydata.push('<td style="display:none;"  id="td_BarcodeNogroup">');
                            $mydata.push($responseData[i].barcode_group);
                            $mydata.push('</td>');
                          
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            // if (barcodeno != $responseData[i].BarcodeNo) {
                            $mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewDetail(\'');
                            $mydata.push($responseData[i].LedgerTransactionNo); $mydata.push('\')"/>');
                     //   }
                           $mydata.push('</td>');

                            $mydata.push('<td class="GridViewLabItemStyle">');
                            if (barcodeno != $responseData[i].BarcodeNo) {
                                $mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="clinicalhistory(\'');
                                $mydata.push($responseData[i].LedgerTransactionNo); $mydata.push('\')"/>');
                            }
                            $mydata.push('</td>');

                            $mydata.push('<td id="td_Isuploded">');
                            $mydata.push($responseData[i].DocUploded);
                            $mydata.push('</td>');

                            $mydata.push('<td  id="td_DocumentUpload">');
                            if ($responseData[i].DocumentStatus != "") {
                                $mydata.push('&nbsp;&nbsp;<img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt="" onclick="callShowAttachment(' + "'" + '' + $responseData[i].LedgerTransactionNo + "'" + ');"></a>&nbsp;&nbsp;&nbsp;&nbsp;');
                            }
                            $mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="$showManualDocumentMaster(\'' + $responseData[i].LedgerTransactionNo + '\',\'' + $responseData[i].Patient_ID + '\')"/>');
                            $mydata.push('</td>');

                            $mydata.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/edit.png" style="cursor:pointer;" ');                            
                            $mydata.push(' onclick="openpopup5(\'');
                            $mydata.push($responseData[i].LedgerTransactionNo);
                            $mydata.push('\')"/>');
                            $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" class="GridViewLabItemStyle" ><img src="../../App_Images/');
                            if ($responseData[i].Remarks == "0") {
                                $mydata.push('ButtonAdd.png');
                            }
                            else {
                                $mydata.push('RemarksAvailable.jpg');
                            }
                            $mydata.push('" style="border-style: none;cursor:pointer;" ');
                            $mydata.push('onclick="callRemarksPage(\'');
                           
                            $mydata.push( $responseData[i].Test_ID);
                            $mydata.push("\',\'");
                            $mydata.push($responseData[i].ItemName ); $mydata.push("\',\'");
                            $mydata.push( $responseData[i].LedgerTransactionNo); $mydata.push("\')");
                            $mydata.push('"/></td></tr>');
                            $mydata = $mydata.join("");
                            $('#tb_ItemList').append($mydata);
                            barcodeno = $responseData[i].BarcodeNo;
                            Labno = $responseData[i].LedgerTransactionNo;
                         }
                    }
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });

           
        };
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

        $showManualDocumentMaster = function (LedgerTransactionNo, Patient_ID) {
            var $filename = "";
            if (jQuery('#spnFileName').text() == "") {
                $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                $filename = jQuery('#spnFileName').text();
            }
            jQuery('#spnFileName').text($filename);
            jQuery('#spnLabNo').text(LedgerTransactionNo);
            jQuery('#spnUHIDNo').text(Patient_ID);
            
            jQuery('#divDocumentMaualMaters').show();
            if (jQuery("#tblMaualDocument tr").length == 0) {
                serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: LedgerTransactionNo, Filename: jQuery('#spnFileName').text(), PatientID: Patient_ID, oldPatientSearch: 0, documentDetailID: 0, isEdit: 0 }, function (response) {
                    var $maualDocument = JSON.parse(response);
                    $addPatientDocumnet($maualDocument);
                });
            }
        }
        $addPatientDocumnet = function (maualDocument) {
            for (var i = 0; i < maualDocument.length ; i++) {
                var $PatientDocumnetTr = [];
                $PatientDocumnetTr.push("<tr>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                $PatientDocumnetTr.push('<img id="imgMaualDocument" alt="Remove Document" src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="$removeMaualDocument(this)"/>');
                $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle' id='tdManualDocumentName'>");
                $PatientDocumnetTr.push(maualDocument[i].DocumentName); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>"); $PatientDocumnetTr.push('<a target="_blank" href="DownloadAttachment.aspx?FileName=');
                $PatientDocumnetTr.push($.trim(maualDocument[i].AttachedFile));
                $PatientDocumnetTr.push('&FilePath=');
                $PatientDocumnetTr.push($.trim(maualDocument[i].fileurl)); $PatientDocumnetTr.push('"'); $PatientDocumnetTr.push("</a>");
                $PatientDocumnetTr.push(maualDocument[i].AttachedFile);
                $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle'>");
                $PatientDocumnetTr.push(maualDocument[i].UploadedBy); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                $PatientDocumnetTr.push(maualDocument[i].dtEntry); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdMaualAttachedFile'>");
                $PatientDocumnetTr.push(maualDocument[i].AttachedFile); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdManualFileURL'>");
                $PatientDocumnetTr.push(maualDocument[i].fileurl); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualID">');
                $PatientDocumnetTr.push(maualDocument[i].ID); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualDocumentID">');
                $PatientDocumnetTr.push(maualDocument[i].DocumentID); $PatientDocumnetTr.push("</td>");
                $PatientDocumnetTr.push('<td class="GridViewLabItemStyle"  style="text-align:center" ><img src="../../App_Images/view.GIF" alt=""  style="cursor:pointer" onclick="$manualViewDocument(this)" /> </td>');
                $PatientDocumnetTr.push('</tr>');
                $PatientDocumnetTr = $PatientDocumnetTr.join("");
                jQuery("#tblMaualDocument tbody").prepend($PatientDocumnetTr);
            }
            jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
        };

        var $Encrypt = function (encryptText, callback) {
            if (encryptText != "") {
                serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: encryptText.trim() }, function (response) {
                    callback(response);
                });
            }
        }
        function callRemarksPage(Test_ID, TestName, LabNo) {
            serverCall('DynamicLabSearch.aspx/PostRemarksData', { TestID: Test_ID, TestName: TestName, VisitNo: LabNo }, function (response) {
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
            });
            
            
            
        }
        function openpopup5(labno) {
            $Encrypt(labno, function (Elabno) {
                window.open("BarCodeReprint.aspx?LabID=" + Elabno);
            });

        }
        var $bindDocumentMasters = function () {
            serverCall('../Common/Services/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: jQuery('#spnUHIDNo').text() }, function (response) {
                $responseData = JSON.parse(response);
                documentMaster = $responseData.patientDocumentMasters;
                var $template = jQuery('#template_DocumentMaster').parseTemplate(documentMaster);
                jQuery('#documentMasterDiv').html($template);
                jQuery('#ddlDocumentType').bindDropDown({ defaultValue: 'Select', data: documentMaster, valueField: 'ID', textField: 'Name' });
                
            });
        }
        $saveMaualDocument = function () {
            if (jQuery("#ddlDocumentType").val() == "0") {
                toast("Error", "Please Select Document Type", "");
                jQuery("#ddlDocumentType").focus();
                return;
            }
            if (jQuery("#fileManualUpload").val() == '') {
                toast("Error", "Please Select File to Upload", "");
                jQuery("#fileManualUpload").focus();
                return;
            }
            var $validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx"];
            var $extension = jQuery('#fileManualUpload').val().split('.').pop().toLowerCase();
            if (jQuery.inArray($extension, $validFilesTypes) == -1) {
                toast("Error", "".concat("Invalid File. Please upload a File with", " extension:\n\n", $validFilesTypes.join(", ")), "");
                return;
            }
            var $maxFileSize = 10485760; // 10MB -> 10 * 1024 * 1024
            var $fileUpload = jQuery('#fileManualUpload');
            if ($fileUpload[0].files[0].size > $maxFileSize) {
                toast("Error", "You can Upload Only 10 MB File", "");
                return;
            }
            var $MaualDocumentID = [];
            if (jQuery("#tblMaualDocument").find('tbody tr').length > 0) {
                jQuery("#tblMaualDocument").find('tbody tr').each(function () {
                    $MaualDocumentID.push(jQuery(this).closest('tr').find("#tdMaualDocumentID").text());
                });
            }
            if ($MaualDocumentID.length > 0) {
                if (jQuery.inArray(jQuery("#ddlDocumentType").val(), $MaualDocumentID) != -1) {
                    toast("Error", "Document already Saved", "");
                    return;
                }
            }
            var formData = new FormData();
            formData.append('file', jQuery('#fileManualUpload')[0].files[0]);
            formData.append('documentID', jQuery('#ddlDocumentType').val());
            formData.append('documentName', jQuery('#ddlDocumentType option:selected').text());
            formData.append('Filename', jQuery('#spnFileName').text());
            formData.append('Patient_ID', jQuery('#spnUHIDNo').text());
            formData.append('LabNo', jQuery('#spnLabNo').text());
            formData.append('isRequestDocument', "1");
            jQuery.ajax({
                url: '../../UploadHandler.ashx',
                type: 'POST',
                data: formData,
                cache: false,
                contentType: false,
                processData: false,
                success: function (data, status) {
                    $("#fileProgress").hide();
                    if (status != 'error') {
                        toast("Success", "Uploaded Successfully", "");
                        var _temp = [];
                        _temp.push(serverCall('../Common/Services/CommonServices.asmx/bindPatientDocument', { labno: jQuery('#spnLabNo').text(), Filename: jQuery('#spnFileName').text(), PatientID: jQuery('#spnUHIDNo').text(), oldPatientSearch: 0, documentDetailID: data, isEdit: 0 }, function (response) {
                            jQuery.when.apply(null, _temp).done(function () {
                                var maualDocument = JSON.parse(response);
                                $addPatientDocumnet(maualDocument);
                                jQuery("#fileManualUpload").val('');
                                jQuery("#ddlDocumentType").prop('selectedIndex', 0);
                                jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
                            });
                        }));
                    }
                },
                xhr: function () {
                    var fileXhr = $.ajaxSettings.xhr();
                    if (fileXhr.upload) {
                        $("progress").show();
                        fileXhr.upload.addEventListener("progress", function (e) {
                            if (e.lengthComputable) {
                                $("#fileProgress").attr({
                                    value: e.loaded,
                                    max: e.total
                                });
                            }
                        }, false);
                    }
                    return fileXhr;
                }
            });

        }
        $closePatientManualDocModel = function () {
            jQuery('#divDocumentMaualMaters').closeModel();
        }
        $removeMaualDocument = function (rowID) {
            serverCall('../Common/Services/CommonServices.asmx/deletePatientDocument', { deletePath: jQuery(rowID).closest('tr').find("#tdManualFileURL").text(), ID: jQuery(rowID).closest('tr').find("#tdMaualID").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    jQuery(rowID).closest('tr').remove();
                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
    </script>
    <script type="text/javascript">
        function viewDetail(testid) {
          //  alert(testid);
          //  var BarcodeNo = $(LabNo).closest("tr").find('#td_BarcodeNo').text();
            serverCall('DynamicLabSearch.aspx/encryptData', { barcodeno: testid }, function (response) {
                var $responseData = JSON.parse(response);
                window.open("SampleTracking.aspx?LabNo=" + $responseData.barcodeno, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

            });

        }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
            $bindDocumentMasters();
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpLabInfo')) {
                    $find('mpLabInfo').hide();
                }

            }
        }

        function closeLabData() {
            $find('mpLabInfo').hide();
        }
          </script>


     <script id="tb_LabSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:820px;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.               
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Entry Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Entry By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Status</th>  
           
                                
		</tr>
        <#
        var dataLength=LabData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = LabData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#> </td>                                                           
                    <td class="GridViewLabItemStyle" id="tdEntryDate" style="width:90px;"><#=objRow.EntryDate#></td>
                    <td class="GridViewLabItemStyle" id="tdEntryBy" style="width:120px;"><#=objRow.EntryBy#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus" style="width:240px;"><#=objRow.Status#></td>
                    
                       
                    </tr>
        <#}
        #>        
     </table>

    </script>   
    <span id="spnFileName"  style="display:none"></span>
    <span id="spnUHIDNo" style="display:none"></span> 
    <span id="spnLabNo" style="display:none"></span> 
    <div id="divDocumentMaualMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 50%;">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Patient Documents Manual Upload</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
			Press esc or click<button type="button" class="closeModel" onclick="$closePatientManualDocModel()" aria-hidden="true">&times;</button>to close</span></em></div>
                         </div>								
			</div>
			<div class="modal-body">
                <div class="row">
						 <div class="col-md-5">
                             <label class="pull-left">Document Type</label>
                    <b class="pull-right">:</b>
                             </div>
                    <div class="col-md-19">
                         <select id="ddlDocumentType" style="width:60%" class="requiredField"></select>
                         </div>
                     </div>
                <div class="row">
						 <div class="col-md-5">
                              <label class="pull-left">Select File</label>
                    <b class="pull-right">:</b>
                             </div>
                     <div class="col-md-15">
                         <input type="file" id="fileManualUpload" class="custom-file-input"/>
                         </div>
                     <div class="col-md-4">
                         <input type="button" id="btnMaualUpload" value="Upload Files" onclick="$saveMaualDocument()" /> 
                         </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                <progress id="fileProgress" style="display: none" max="100" value="50" data-label="50% Complete">
                    <span class="value" style="width:50%;"></span>
                </progress>
                        </div>
                    </div>
                 <div class="row">
                      <div class="col-md-24">
                          <em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em>
                          </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                        <em><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 10 MB.</span></em>
                         </div>
                    </div>
				
                <div id="divManualUpload" style="overflow:auto">							  
							</div>   
                 <div class="row">
                    <div class="col-md-24">            
                            <table id="tblMaualDocument"  border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="trManualDocument">
                                    <th class="GridViewHeaderStyle" >&nbsp;</th>	
					                <th class="GridViewHeaderStyle" >Document Type</th>	
                                    <th class="GridViewHeaderStyle" >Document Name</th>	
                                    <th class="GridViewHeaderStyle" >Uploaded By</th>
                                    <th class="GridViewHeaderStyle" >Date</th>
                                    <th class="GridViewHeaderStyle" >View</th>									
								</tr>
							</thead>
							<tbody></tbody>
						</table>
                        </div>
                    </div>
			</div>			
		</div>
	</div>
</div>   

</asp:Content>

