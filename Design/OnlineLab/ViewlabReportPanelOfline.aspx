<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewlabReportPanelOfline.aspx.cs" Inherits="Design_OnlineLab_ViewlabReportPanelOfline" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" /> 
     
    <script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
  <%: Scripts.Render("~/bundles/ResultEntry") %>
    <div id="Pbody_box_inventory" style="height:550px;width:98%;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
             <Services>
                <asp:ServiceReference Path="~/Design/Common/Services/CommonServices.asmx"  InlineScript="true"/>
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:99.7%;">

            <b>Investigation Result</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
             <asp:Label ID="lblOnlineStatus" runat="server"  style="display:none" ClientIDMode="Static"></asp:Label>

        </div>
                  <div id="output"></div>  
    <div id="overlay" class="web_dialog_overlay"></div>  
    <div id="dialog" class="web_dialog"> 
          <table style="width: 100%;height:80px; border: 0px;" cellpadding="3" cellspacing="0">  
            <tr>  
                <td class="web_dialog_title">Send SMS</td>  
                <td class="web_dialog_title align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor:pointer;">Close</a></td>  
            </tr>  
            <tr>
                <td><strong>Mobile No :</strong> </td>
                <td><asp:TextBox ID="txtSMSMobile" runat="server" MaxLength="10" Width="160px" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')"></asp:TextBox>
                    <asp:TextBox ID="txtVisitNo" runat="server" MaxLength="10" Width="160px" style="display:none;"></asp:TextBox>                    
                </td>
            </tr>
                          
            <tr>  
                <td  style="text-align: center;">
                     
                    <input type="button" value="Send " class="savebutton"  onclick="SendSMS();" style="width:90px;" />     
                     </td>  
                <td  style="text-align: center;"> 
                    <input type="button" value="Cancel" class="savebutton"  onclick=" HideDialog(true);" style="width:90px;" /></td>  
            </tr>  
        </table>  
        </div>
     <div>
         <table style="width: 100%; border: 1px solid #569ADA;border-collapse:collapse">
                               
                                <tr>
                                    <td  style="width: 13%;text-align:right">Visit No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtLabNo" runat="server"  MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 15%;text-align:right">UHID No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtCRNo" runat="server"  MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 12%;text-align:right">BarCode No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtBarCodeNo" runat="server"  MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td  style="width: 13%;text-align:right">Patient Name :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtPName" runat="server"   MaxLength="30" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 15%;text-align:right">Mobile No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtMobile" runat="server"  MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td  style="width: 12%"<%-->Department :--%>&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:DropDownList ID="ddlDepartment" runat="server"  style="display:none">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtPhone" runat="server" style="display:none"   MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox></td>
                                </tr>
                                
                                <tr>
                                    <td  style="width: 13%;text-align:right">From Date :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="FrmDate" runat="server"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                        
                                    </td>
                                    <td  style="width: 15%;text-align:right">To Date :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                         <asp:TextBox ID="ToDate" runat="server" ></asp:TextBox>
                                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                       
                                    </td>
                                    <td  style="width: 12%;text-align:right">Status :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="ddl">
                                            <asp:ListItem></asp:ListItem>
                                            <asp:ListItem Value="1">Approved</asp:ListItem>
                                            <asp:ListItem Value="2"> Not Approved</asp:ListItem>
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td  style="width: 13%;text-align:right">
                                        <label class="labelForSearch" style="display: none">
                                            Patient Type :</label></td>
                                    <td  style="width: 16.5%">
                                        <asp:DropDownList ID="ddlPatientType" runat="server" Style="display: none">
                                            <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
                                            <asp:ListItem Value="1">Urgent</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td  style="width: 15%">
                                        <asp:Label ID="lblUseType" runat="server" style="display:none"></asp:Label>
                                    </td>
                                    <td  style="width: 16.5%"></td>
                                    <td  style="width: 12%"></td>
                                    <td  style="width: 16.5%"></td>
                                </tr>
                                <tr>
                                    <td  style="width: 13%"></td>
                                    <td  style="width: 16.5%"></td>
                                    <td  style="width: 15%"></td>
                                    <td  style="width: 18.5%"></td>
                                    <td  style="width: 12%"></td>
                                    <td  style="width: 16.5%"></td>
                                </tr>
                            </table>
          <div style="text-align: center; border: 1px solid #569ADA;">
                                
                                <asp:CheckBox ID="Chk_Header" runat="server" Text="Report With Header" Checked="false" />
                                &nbsp;&nbsp;&nbsp;
                    
                                <input type="button" value="Search" class="searchbutton" style="width:150px;" onclick="labSearch()"  id="btnSearch" />
                                &nbsp;&nbsp; &nbsp;     
                    
                   
                               
                            </div>
             <div style="text-align: center; border: 1px solid #569ADA;width:99.7%;">

                            <table style="width:100%;border-collapse:collapse" >
                                <tr style="text-align:center">
                                    <td style="text-align:center" >

                                        <table style="width:100%;text-align:center">
                                            <tr>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align:left">Due Patient</td>
                                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align:left">Approved</td>


                                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align:left">Not Approved</td>

                                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: cyan;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align:left">Report Printed</td>
                                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align:left">Hold</td>
                                                 <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>

                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                       <div id="LabSearchOutput" style="max-height: 800px; overflow-x: auto;">
                        </div>
                        <br />
                        <input type="button" value="Print" id="btnPrintAll" onclick="printAllLabReport()" class="ItDoseButton"
                            style="display: none" />
           <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" />
        </div>

          <script id="tb_LabSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tl_labSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Visit No.</th>    
             <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID No.</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Sin No.</th>         
			<th class="GridViewHeaderStyle" scope="col" style="width:124px;">Patient&nbsp;Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;display:none;">Gender</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;display:none;">Panel</th>  
             <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Mobile</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Attachment</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">SMS</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Email</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Hold Reason</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Net Bill</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">MRP Bill</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Print</th>
           
		</tr>
        <#
        var dataLength=LabData.length;
        
        var objRow;
        var status;
      
        for(var j=0;j<dataLength;j++)
        {
        objRow = LabData[j];
        #>
                    <tr id="<#=j+1#>" 
                        <#if(objRow.Reportdownload=="1"){#>
                        style="background-color:Cyan"
                         <#} 
                        if(objRow.AllowPrint=="Y" && objRow.Approved=="1"){#>
                        style="background-color:LightGreen"
                         <#}
                        if(objRow.isHold=="1"){#>
                        style="background-color:Yellow"
                         <#} 
                        else{#>
                         style="background-color:White"
                         <#} 
                         if(objRow.AllowPrint=="N" && objRow.Approved=="1"){#>
                        style="background-color:Pink"
                         <#}
                        
                         #>
                        >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>

                    <td class="GridViewLabItemStyle" id="tdLedgerTransactionNo"  style="width:120px;text-align:center" ><#=objRow.LedgerTransactionNo#></td>
                         <td class="GridViewLabItemStyle" id="td2" style="width:124px;"></td>
                         <td class="GridViewLabItemStyle" id="td3" style="width:124px;"></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:124px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:120px;display:none;"><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdGender" style="width:70px;text-align:center;display:none;"><#=objRow.Gender#></td>
                    <td class="GridViewLabItemStyle" id="tdPanel" style="width:180px;display:none;"><#=objRow.Panel#></td>
                          <td class="GridViewLabItemStyle" id="td4" style="width:86px;text-align:center"></td>
                    <td class="GridViewLabItemStyle" id="tdInDate" style="width:86px;text-align:center"><#=objRow.InDate#></td>
                    <td class="GridViewLabItemStyle" id="tdTestName"  style="width:220px;text-align:left" ><#=objRow.testName#></td>
                          <td class="GridViewLabItemStyle" id="td5" style="width:86px;text-align:center">
                               <# if(objRow.IsRemarksAvail=="0"){#>
                              <img src="../../App_Images/ButtonAdd.png" style="border-style: none;cursor:pointer;" onclick="callRemarksPage('<#=objRow.Test_ID#>','<#=objRow.testName#>','<#=objRow.LedgerTransactionNo#>');">
                               <#}else{#>
                              <img src="../../App_Images/Redplus.png" style="border-style: none;cursor:pointer;" onclick="callRemarksPage('<#=objRow.Test_ID#>','<#=objRow.testName#>','<#=objRow.LedgerTransactionNo#>');">
                               <#}#>
                          </td>
                          <td class="GridViewLabItemStyle" id="td6" style="width:86px;text-align:center"><img src="../../App_Images/attachment.png" style="cursor:pointer;width:20px;height:20px;" onclick="Addattachment('<#=objRow.LedgerTransactionNo#>');" /></td>
                        <td class="GridViewLabItemStyle" id="td7" style="width:86px;text-align:center">
                           <# if(objRow.AllowPrint=="Y" && objRow.Approved=="1"){#>
                            <img src="../../App_Images/SMS.ico" style="cursor:pointer;width:20px;height:20px;" onclick="SMSSending('<#=objRow.LedgerTransactionNo#>','<#=objRow.Test_ID#>');" />
                            <#}#>
                        </td>
                        <td class="GridViewLabItemStyle" id="td8" style="width:86px;text-align:center">
                            <# if(objRow.AllowPrint=="Y" && objRow.Approved=="1"){#>
                            <img src="../../App_Images/EmailICON.png" style="cursor:pointer;width:20px;height:20px;" onclick="EmailResend('<#=objRow.LedgerTransactionNo#>');" />
<#}#>
                        </td>
                        <td class="GridViewLabItemStyle" id="td1"  style="width:220px;text-align:center" >
                            <span  >
                                <#if(objRow.Reportdownload=="1"){#>
                            Approved and Printed
                            <#} #>
                             <#if(objRow.AllowPrint=="Y" && objRow.Approved=="1" && objRow.Reportdownload=="0"){#>
                            Approved
                            <#} #>
                                <#if(objRow.AllowPrint=="N" && objRow.Approved=="1"){#>
                            Approved and Amount Due
                            <#} #>
                                
                                </span>
                            </td>
                          <td class="GridViewLabItemStyle" id="td9" style="width:86px;text-align:center"><#=objRow.Hold_Reason#></td>
                          <td class="GridViewLabItemStyle" id="td10" style="width:86px;text-align:center">
                              <img src="../../App_Images/folder.gif" style="cursor:pointer;" onclick="PrintNetBill('<#=objRow.LedgerTransactionID#>')">
                          </td>
                          <td class="GridViewLabItemStyle" id="td11" style="width:86px;text-align:center">
                              <img src="../../App_Images/folder.gif" style="cursor:pointer;" onclick="PrintMRPBill('<#=objRow.LedgerTransactionID#>')">
                          </td>
                    <td class="GridViewLabItemStyle"  style="width:60px;text-align:center">
                        <input type="checkbox"   id="chkSelect"   onclick="chkPrint(this)"
                          <#if(objRow.AllowPrint=="Y" && objRow.Approved=="1"){#>
                       class="<#=objRow.LedgerTransactionNo#>"
                        <#}
                        else {#>
                        disabled="disabled"
                         <#}
                         #>
                         /></td>
                    <td class="GridViewLabItemStyle" id="tdPrint"  style="width:60px;text-align:center">
                        <img src="../../App_Images/print.gif"   title="Click to Print"
                            <#if(objRow.AllowPrint=="Y" && objRow.Approved=="1"){#>
                             onclick="printLabReport(this)" style="cursor:pointer" <#}
                        else {#>
                        style="cursor:pointer;display:none;"
                        <#}
                         #>
                         />
                    </td>
                   
                   <td class="GridViewLabItemStyle" id="tdTest_ID"  style="width:60px;text-align:right;display:none">
                       <#=objRow.Test_ID#>
                   </td>
                     <td class="GridViewLabItemStyle" id="tdInvestigation_ID"  style="width:60px;text-align:right;display:none">
                       <#=objRow.Investigation_ID#>
                   </td>
                   <td class="GridViewLabItemStyle" id="tdIsCulture"  style="width:60px;text-align:right;display:none">
                       <#=objRow.isCulture#>
                   </td>
                      <td class="GridViewLabItemStyle" id="tdApproved"  style="width:60px;text-align:right;display:none">
                       <#=objRow.Approved#>
                   </td>
                        
                         
                    </tr>

        <#}

        #>
        
     </table>
    </script>



     </div>
       

    </div>
    <script type="text/javascript">
        function PrintNetBill(LabID) {
            window.open("../Lab/PatientReceipt.aspx?LabID=" + LabID);
        }
        function PrintMRPBill(LabID) {
            window.open("../Lab/PatientReceipt.aspx?LabID=" + LabID+'&MRPBill=1');
        }
        function chkPrint(rowID) {
            var LedgertransactionNo = $(rowID).closest('tr').find("#tdLedgerTransactionNo").text();

            if ($(rowID).closest('tr').find("#chkSelect").is(':checked')) {
                $("input[type=checkbox]").not('#Chk_Header').prop('checked', false);
                $("#tl_labSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        var tblLedger = $.trim($rowid.find("#tdLedgerTransactionNo").text());
                        if (LedgertransactionNo == tblLedger && $.trim($rowid.find("#tdApproved").text()) == 1) {                            
                            $rowid.find("#chkSelect").prop('checked', 'checked');
                        }
                    }
                });

            }

           

        }
        function labSearch() {
            $("#btnSearch").attr('disabled', 'disabled').val('Submitting...');           
            PageMethods.bindLabReport('', $.trim($("#<%=txtLabNo.ClientID%>").val()), $.trim($("#<%=txtCRNo.ClientID%>").val()), $.trim($("#<%=txtPName.ClientID%>").val()), $.trim($("#<%=txtMobile.ClientID%>").val()), $("#<%=ddlDepartment.ClientID%>").val(), $("#<%=FrmDate.ClientID%>").val(), $("#<%=ToDate.ClientID%>").val(), $("#<%=ddlStatus.ClientID%>").val(), $("#<%=ddlPatientType.ClientID%>").val(), $("#<%=lblUseType.ClientID%>").text(), '<%=Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["OnlinePanelID"]))%>', '', '', $("#<%=txtBarCodeNo.ClientID%>").val(), onLabSuccess, OnLabfailure);
            }

            function onLabSuccess(result) {
                if (result == 2) {
                    $("#lblMsg").text('Timeframe can not be more than 365 days');
                    $('#btnPrintAll,#LabSearchOutput').hide();
                }
                else {
                    LabData = jQuery.parseJSON(result);
                    if (LabData != null) {
                        var output = $('#tb_LabSearch').parseTemplate(LabData);
                        $('#LabSearchOutput').html(output);

                    }
                    else {
                        $('#btnPrintAll,#LabSearchOutput').hide();
                    }
                }
                $("#btnSearch").removeAttr('disabled').val('Search');
            }
            function OnLabfailure(result) {
                $("#btnSearch").removeAttr('disabled').val('Search');
            }
            function printLabReport(rowID) {
                var testID = ""; var CulturetestID = ""; var normalTestID = ""; var IsCulture = ""; var labCount = 0;
                $("#tl_labSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if ((id != "Header") && ($rowid.find("#chkSelect").is(':checked'))) {
                        labCount = 1;
                        if ($.trim($rowid.find("#tdIsCulture").text()) == 1) {
                            if (CulturetestID != "") {
                                CulturetestID += "".concat(",", "", $.trim($rowid.find("#tdTest_ID").text()), "");
                            }
                            else {
                                CulturetestID = "".concat("", $.trim($rowid.find("#tdTest_ID").text()), "");
                            }
                        }
                        else {
                            if (testID != "") {
                                testID += "".concat(",", "", $.trim($rowid.find("#tdTest_ID").text()), "");
                            }
                            else {
                                testID = "".concat("", $.trim($rowid.find("#tdTest_ID").text()), "");
                            }
                        }
                    }

                });
                var alltestID = "".concat(testID, "#", CulturetestID)                
                if (labCount == 0) {
                    alert('Please Select Item');
                    return;
                }
                else
                    PageMethods.printLabReport(testID, $("#lblUseType").text(), onLabPrintSuccess, OnLabPrintfailure, alltestID);
            }
            function onLabPrintSuccess(result, alltestID) {
                var normalTestID = alltestID.split('#')[0];
                var CulturetestID = alltestID.split('#')[1];

                if (normalTestID != "")
                    CommonServices.encryptData(normalTestID, onSuccessOnlineReport, OnfailureOnlineReport);
                if (CulturetestID != "")
                    CommonServices.encryptData(CulturetestID, onSuccessCulturetestReport, OnfailureCulturetestReport);

            }
            function onSuccessOnlineReport(normalTestID) {


                var PHead = $("#ContentPlaceHolder1_Chk_Header").is(':checked') ? 1 : 0;
              
                CommonServices.encryptData(PHead, onCompleteSuccessNormal, OnCompletefailureNormal, normalTestID);

            }

            function onCompleteSuccessNormal(PHead, normalTestID) {

                window.open('../../Design/Lab/labreportnew.aspx?TestID=' + normalTestID + '&PHead=' + PHead + '&isOnlinePrint=' + $("#<%=lblOnlineStatus.ClientID%>").text() + '');
            }

            function OnCompletefailureNormal() {

            }
            function onSuccessCulturetestReport(CulturetestID) {
                var PHead = $("#ContentPlaceHolder1_Chk_Header").is(':checked') ? 1 : 0;
             
                CommonServices.encryptData(PHead, onCompleteSuccessCulturetest, OnCompletefailureCulturetest, CulturetestID);
            }
            function onCompleteSuccessCulturetest(PHead, cultureTestID) {
                window.open('../../Design/Lab/labreportnew.aspx?TestID=' + cultureTestID + '&PHead=' + PHead + '&isOnlinePrint=' + $("#<%=lblOnlineStatus.ClientID%>").text() + '');

            }
            function OnCompletefailureCulturetest() {

            }
            function OnfailureCulturetestReport() {

            }

            function OnfailureOnlineReport() {

            }
            function OnLabPrintfailure() {

            }
        </script>
        <script type="text/javascript">
            $(function () {
                if ($("#lblUseType").text() == "Patient")
                    labSearch();
            });
            function SearchPatient() {

            }
        </script>
    <script type="text/javascript">
        function openfile(path, type, labno, pname) {
            window.open("../Lab/labreportnew.aspx?TestID=" + labno);
        }

        function openattacfile(name, path) {
            window.open("../Lab/DownloadAttachment.aspx?filename=" + name + "&FilePath=" + path);
        }
        </script>

        <script type="text/javascript">
            function printAllLabReport() {



            }
        </script>

    <script type="text/javascript">
        function callRemarksPage(Test_ID, TestName, LabNo) {
            var href = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + Test_ID + "&TestName='" + TestName + "&VisitNo=" + LabNo+"&Offline=1";
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
            }
            )
        }
        function EmailResend(LedNo) {
            $.fancybox({
                maxWidth: 1030,
                maxHeight: 800,
                fitToView: false,
                width: '90%;',
                height: '50%',
                href: '../Lab/ReportEmailPopUP.aspx?VisitNo=' + LedNo + '&FromPUPPortal=1',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        function Addattachment(LabNo) {
            $.fancybox({
                maxWidth: 1030,
                maxHeight: 800,
                fitToView: false,
                width: '65%;',
                height: '50%',
                href: '../Lab/AddFileRegistration.aspx?labno=' + LabNo + '&HideHelpDesk=1',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        function SMSSending(LabNo, Test_ID) {
            ShowDialog(true);
            $('#<%=txtVisitNo.ClientID%>').val('');
            $('#<%=txtSMSMobile.ClientID%>').val('');
            $('#<%=txtVisitNo.ClientID%>').val(LabNo);
            
        }
        function SendSMS() {
            var LabNo = $('#<%=txtVisitNo.ClientID%>').val();
            var Mobile = $('#<%=txtSMSMobile.ClientID%>').val();
            PageMethods.SendSMS(LabNo,Mobile,'<%=Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["OnlinePanelID"]))%>', onSuccessSendSMS, OnfailureSendSMS);
        }
        function onSuccessSendSMS(result) {
            if (result == "1") {
                alert('SMS Sent Successfully....!');
                $('#<%=txtVisitNo.ClientID%>').val('');
                $('#<%=txtSMSMobile.ClientID%>').val('');
                HideDialog();
            }
            else {
                alert('SMS Sending Failed....!');
            }
        }
        function OnfailureSendSMS() {
            alert('SMS Sending Failed....!');
        }
        function HideDialog() {
            $("#overlay").hide();
            $("#dialog").fadeOut(300);
        }
        function ShowDialog(modal) {
            $("#overlay").show();
            $("#dialog").fadeIn(300);
            if (modal) {
                $("#overlay").unbind("click");
            }
            else {
                $("#overlay").click(function (e) {
                    HideDialog();
                });
            }
        }
    </script>
     <style>
        input[type="text"]  {
            padding: 5px 12px;
            margin: 2px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            width:200px;
        }
        .ddl  {
            padding: 5px 12px;
            margin: 2px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
             width:200px;
        }
        .auto-style1 {
            font-weight: bold;
            text-align: right;
        }
        table {
    border-collapse: collapse;
}
    </style>
     <style type="text/css">  
        .web_dialog_overlay  
        {  
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
        .web_dialog  
        {  
            display: none;  
            position: fixed;  
            width: 310px;
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
        .web_dialog_title  
        {  
            border-bottom: solid 2px #336699;  
            background-color: #336699;  
            padding: 4px;  
            color: White;  
            font-weight: bold;  
        }  
        .web_dialog_title a  
        {  
            color: White;  
            text-decoration: none;  
        }  
        .align_right  
        {  
            text-align: right;  
        }  
    </style> 
</asp:Content>

