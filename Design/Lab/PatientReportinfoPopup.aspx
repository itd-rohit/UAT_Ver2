<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Design/Lab/PatientReportinfoPopup.aspx.cs" Inherits="Design_OPD_PatientSampleinfoPopup" %>

<%@ Register Assembly="DevExpress.Web.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxRichEdit.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxRichEdit" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpellChecker.v20.2, Version=20.2.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpellChecker" TagPrefix="dx" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
<webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
<webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
<webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />

<%: Scripts.Render("~/bundles/WebFormsJs") %>
<%: Scripts.Render("~/bundles/handsontable") %>
<%: Scripts.Render("~/bundles/ResultEntry") %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>

    <style type="text/css">
        .auto-style5 {
            font-size: 9pt;
            font-family: Verdana, Arial, sans-serif, sans-serif;
            width: 200px;
            height: 19px;
        }

        .auto-style6 {
            width: 400px;
            height: 19px;
        }

        .auto-style7 {
            width: 200px;
            height: 19px;
        }

        .auto-style8 {
            width: 400px;
            height: 19px;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="Pbody_box_inventory" style="width: 1350px;vertical-align:top;margin:-0px">
                <div class="POuter_Box_Inventory" style="width: 1350px; text-align: center;">
                    <div style="text-align: center;">

                        <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;
                    </div>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center; width: 1350px;">

                    <table style="width: 100%">
                        <tr>
                            <td colspan="4">
                                <div class="Purchaseheader">Sample Info</div>
                            </td>
                        </tr>

                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 200px;" valign="middle" class="ItDoseLabel">Visit No.:&nbsp;
                            </td>
                            <td align="left" style="width: 400px" valign="middle">
                                <asp:Label ID="lblLabNo" runat="server" Text="Label" Width="400px"></asp:Label>
                            </td>

                            <td align="right" style="width: 200px; text-align: right;" valign="middle">Client  :&nbsp;
                            </td>
                            <td align="left" style="width: 400px;" valign="middle">
                                <asp:Label ID="lblSampleType" runat="server" Text="Label" Width="400px"></asp:Label></td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 200px;" valign="middle" class="ItDoseLabel">Patient Name :&nbsp;</td>
                            <td align="left" style="width: 400px" valign="middle">
                                <asp:Label ID="lblPatientName" runat="server" Text="Label" Width="400px"></asp:Label>
                            </td>

                            <td align="right" style="width: 200px; text-align: right;" valign="middle">Age / Sex :&nbsp; </td>
                            <td align="left" style="width: 400px;" valign="middle">
                                <asp:Label ID="lblAge" runat="server" Text="Label" Width="400px"></asp:Label></td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 200px;" valign="middle" class="ItDoseLabel">Sin No :&nbsp;</td>
                            <td align="left" style="width: 400px" valign="middle">
                                <asp:Label ID="lblSinNo" runat="server" Text="Label" Width="400px"></asp:Label>
                            </td>

                            <td align="right" style="width: 200px; text-align: right;" valign="middle">Date :&nbsp; </td>
                            <td align="left" style="width: 400px;" valign="middle">
                                <asp:Label ID="lblDate" runat="server" Text="Label" Width="400px"></asp:Label></td>
                        </tr>
                       
                          <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 200px;" valign="middle" class="ItDoseLabel">Test Name  :&nbsp;</td>
                            <td align="left" style="width: 400px" valign="middle">
                                <asp:Label ID="lblTestName" runat="server" Text="Label" Width="400px"></asp:Label>
                            </td>
                             <td align="right" style="width: 200px; text-align: right;" valign="middle">Refer Doctor  :&nbsp; </td>
                            <td align="left" style="width: 400px;" valign="middle">
                                <asp:Label ID="lblReferDotor" runat="server" Text="" Width="400px"></asp:Label></td>
                          
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div class="Purchaseheader">Template</div>
                            </td>
                        </tr>
                         </table>
                    <table>
                        <tr>
                            <td style="text-align:left;display:none;">
                            All Template :  <asp:DropDownList ID="dllAllTemplate" class="ddluser  chosen-select" Width="180px" OnSelectedIndexChanged="dllAllTemplate_SelectedIndexChanged" AutoPostBack="true"  runat="server"></asp:DropDownList>
                            </td>
                          <td style="text-align:left">
                            Template :  <asp:DropDownList ID="ddlTemplate" Width="200px" AutoPostBack="true" OnSelectedIndexChanged="ddlTemplate_SelectedIndexChanged" runat="server"></asp:DropDownList>
                            </td>
                            <td style="text-align:left;display:none;">
                            Doctor Assign :  <asp:DropDownList ID="ddlDoctor" class="ddlDoctor  chosen-select" Width="200px" AutoPostBack="true"  runat="server"></asp:DropDownList>
                            </td>
                            <%--   <td  style="text-align:left">
                             Save Type :  <asp:DropDownList ID="ddlSaveType" Width="200px" runat="server">
                                 <asp:ListItem Text="Save" Value="Save"></asp:ListItem>
                                 <asp:ListItem Text="Approve" Value="Approve"></asp:ListItem>
                                  <asp:ListItem Text="Hold" Value="Hold"></asp:ListItem>
                                  <asp:ListItem Text="UnHold" Value="UnHold"></asp:ListItem>
                                          </asp:DropDownList>
                            </td>--%>
                             <td  style="text-align:left">
                             Approved by :<asp:DropDownList ID="ddlApprove" Width="200px"  runat="server"></asp:DropDownList>
                            </td>
                          

                        </tr>
                        <tr>
                            <td style="text-align: left">Crtical :  
                                <asp:CheckBox ID="chkIsCritical" onclick="setImpression(this);" ClientIDMode="Static" Width="200px" runat="server" />
                            </td>
                            <td  style="text-align: left">Follow-up : 
                                <asp:CheckBox ID="chkIsCriticalFollow" onclick="setImpression(this);" ClientIDMode="Static" Width="200px" runat="server" />
                            </td>
                            <td style="text-align: left">Attachment: 
                                 <input id="btnAttachment" type="button" value="Attachment" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="callShowAttachment();" style="width: auto; height: 25px;" />
                            </td>
                              <td style="text-align: left" colspan="2">
                                <asp:Button ID="btnSave" Text="Save" runat="server" class="ItDoseButton btnForSearch demo" Style="width: auto; height: 25px;" OnClick="btnSave_Click" />
                                <input id="Button1" type="button" value="Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="checkTAT();" style="width: auto; height: 25px;" />
                                <asp:Button ID="btnApprovedNew" Text="Approved" ClientIDMode="Static" runat="server" class="ItDoseButton btnForSearch demo"  Style="width: auto; height: 25px;display:none;" OnClick="btnApprovedNew_Click" />
                                <input id="btnPrintReportLabObs" type="button" value="Print PDF" class="ItDoseButton btnForSearch demo " onclick="PrintReport();" style="width: auto; height: 25px;" />
                                <input id="btnNotApproveLabObs" type="button" value="Not Approved" class="ItDoseButton btnForSearch  SampleStatus demo" onclick="NotApproved();" style="width: auto; height: 25px;" />
                                <asp:Button ID="btnHold" Text="Hold" runat="server" class="ItDoseButton btnForSearch demo" Style="width: auto; height: 25px;" OnClick="btnHold_Click" />
                                <asp:Button ID="btnUnHold" Text="UnHold" runat="server" class="ItDoseButton btnForSearch demo" Style="width: auto; height: 25px;" OnClick="btnUnHold_Click" />
                                <input id="btnPatientDetail" type="button" value="Patient Detail" class="ItDoseButton" style="width: auto; height: 25px;" />
                                <a id="various2" style="display: none">Ajax</a>
                            </td>
                        </tr>
                    </table>



                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 1350px;">

                    <div class="Purchaseheader">Test List</div>
                    <div style="width: 100%; height: 700px; overflow-y: scroll;">

                        <dx:ASPxRichEdit ID="ASPxRichEdit1" runat="server" OnSaving="ASPxRichEdit1_Saving" Width="1350px" Height="700px">
                            <Settings>
                                <SpellChecker Enabled="true" SuggestionCount="4">
                                    <Dictionaries>
                                        <dx:ASPxSpellCheckerISpellDictionary
                                            AlphabetPath="~/SpellChecker/EnglishAlphabet.txt"
                                            GrammarPath="~/SpellChecker/english.aff"
                                            DictionaryPath="~/SpellChecker/american.xlg"
                                            Culture="English (United States)"
                                            CacheKey="ISpellDic"></dx:ASPxSpellCheckerISpellDictionary>
                                        <dx:ASPxSpellCheckerCustomDictionary AlphabetPath="~/SpellChecker/EnglishAlphabet.txt" DictionaryPath="~/SpellChecker/CustomEnglish.dic" />
                                    </Dictionaries>
                                </SpellChecker>
                            </Settings>
                        </dx:ASPxRichEdit>

                    </div>
                </div>
            </div>

        </div>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
        </Ajax:ScriptManager>
        <asp:Panel ID="pnlnotapproved" runat="server" Style="display: none; width: 300px; background-color: lightgray;">
            <div class="Purchaseheader">
                Not Approved Remarks
            </div>

            <center>
                <asp:TextBox ID="txtnotappremarks" runat="server" MaxLength="200" Width="250px" placeholder="Enter Not Approved Remarks" Style="text-transform: uppercase;" /><br />
                <br />
                <%-- <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />&nbsp;&nbsp;--%>
                <asp:Button ID="btnNotApproved" runat="server" class="savebutton" Text="Not Approved" OnClick="btnNotApproved_Click" />&nbsp;&nbsp;
                <asp:Button ID="btnCancelNotapproved" runat="server" CssClass="resetbutton" Text="Cancel" /><br />
                <br />
            </center>
        </asp:Panel>
        <asp:Panel ID="pnlImpression" runat="server" Style="display: none; width: 600px; background-color: lightgray;">
            <div class="Purchaseheader">
                Impression
            </div>
            <center>
                <asp:TextBox ID="txtImpression" ClientIDMode="Static" runat="server" MaxLength="1000" TextMode="MultiLine" Width="550px" Height="100px" placeholder="Enter Impression" Style="text-transform: uppercase;" /><br />
                <br />
                <asp:Button ID="btnSaveImpression" runat="server" class="savebutton" Text="Save" OnClick="btnSaveImpression_Click"/>&nbsp;&nbsp;
                <asp:Button ID="btnCancelImpression" runat="server" CssClass="resetbutton" Text="Cancel" OnClientClick="Uncheck()" /><br />
                <br />
            </center>
        </asp:Panel>
         <asp:Panel ID="pnlTAT" runat="server" Style="display: none; width: 600px; background-color: lightgray;">
            <div class="Purchaseheader">
                TAT Delay Remark
            </div>
            <center>
                <asp:TextBox ID="txtTATremark" ClientIDMode="Static" runat="server" MaxLength="1000" TextMode="MultiLine" Width="550px" Height="100px" placeholder="Enter TAT Delay Remark" Style="text-transform: uppercase;" /><br />
                <br />
                <asp:Button ID="btnTATRemark" runat="server" class="savebutton" Text="Save" OnClientClick="return checkTATRemark()" OnClick="btnApprovedNew_Click"/>&nbsp;&nbsp;
                <asp:Button ID="btnTATCancel" runat="server" CssClass="resetbutton" Text="Cancel"  /><br />
                <br />
            </center>
        </asp:Panel>
        <asp:Button ID="btnHideHold" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="mpnotapprovedrecord" runat="server" CancelControlID="btnCancelNotapproved"
            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
        </cc1:ModalPopupExtender>
         <cc1:ModalPopupExtender ID="mpnotfollowup" runat="server" CancelControlID="btnCancelImpression"
            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlImpression" BehaviorID="mpnotfollowup">
        </cc1:ModalPopupExtender>
           <cc1:ModalPopupExtender ID="mpTATremark" runat="server" CancelControlID="btnTATCancel"
            DropShadow="true" TargetControlID="btnHideHold" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlTAT" BehaviorID="mpTATremark">
        </cc1:ModalPopupExtender>
    <asp:HiddenField ID="hdnisContrast" runat="server" />
    </form>
    
</body>
<script type="text/javascript">
   
   $(window).on("beforeunload", function () {
        var test_id = '<%=TestID.Trim()%>'
        var element = $('#<%=lblerrmsg.ClientID%>').text();
        if (element.indexOf("Already") != -1) {

        }
        else {
            serverCall('PatientReportinfoPopup.aspx/updateOpen', { Test_ID: test_id }, function (response) {
            });
        }
    });
    $(window).on("contextmenu", function (e) {
       // e.preventDefault();
    });
    function PrintReport() {
        window.open('labreportnew.aspx?IsPrev=1&TestID=' + <%=TestID.Trim()%> + ',&Phead=0');
    }
    function checkTATRemark() {
        if ($('#txtTATremark').val() == "") {
            alert("Enter TAT Remrk");
            return false;
        }
        else {
            return true;
        }
    }
    function checkTAT() {
        var testid = '<%=TestID.Trim()%>';
        serverCall('PatientReportinfoPopup.aspx/checkTAT', { testid: testid }, function (response) {
            if (response == "1") {
                $find('mpTATremark').show();
            }
            else {
                $("#btnApprovedNew").trigger("click");
            }
        });
    }
    function setImpression(ctr) {
        if ($(ctr).prop("checked") == true) {
            var testid = '<%=TestID.Trim()%>';
            serverCall('PatientReportinfoPopup.aspx/bindimpression', { testid: testid }, function (response) {
                $('#txtImpression').val(response);
                $find('mpnotfollowup').show();
            });
        }
    }
    function Uncheck() {
       // if ($('#txtImpression').val() == "") {
         //   $('#chkIsCritical').prop("checked", false);
           // $('#chkIsCriticalFollow').prop("checked", false);
        //}
    }
         function NotApproved() {
             <%if(IsApproved=="0"){%>
                alert("Approved Report First");
              <%}else{%>
            // $('#<%=txtnotappremarks.ClientID%>').val('');
             $find('mpnotapprovedrecord').show();
             // $('#<%=txtnotappremarks.ClientID%>').focus();
              <%}%>
         }
        
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
        $("#btnPatientDetail").click(function () {
            $("#various2").attr('href', '../Lab/PatientSampleinfoPopup.aspx?TestID=' + <%=TestID.Trim()%> + '&LabNo=<%=LedgerTransactionNo.Trim()%>');
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
        
    });
    function callShowAttachment() {
        var href = "../Lab/AddFileRegistration.aspx?labno=" + '<%=LedgerTransactionNo.Trim()%>';
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
     </script>
    
</html>
