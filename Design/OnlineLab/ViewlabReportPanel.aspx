<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" ClientIDMode="Static" CodeFile="ViewlabReportPanel.aspx.cs" Inherits="Design_Online_Lab_ViewlabReportPanel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9,IE=10" />
    <title>Online Lab Report</title>
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
    <script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <style type="text/css">
        .nav {
            list-style: none;
            margin: 0;
            padding: 0;
            text-align: center;
        }

            .nav li {
                display: inline;
            }

            .nav a {
                display: inline-block;
                background-color: #569ADA;
                padding: 10px;
                border-radius: 8px;
                text-decoration: none;
            }

            .nav a {
                border-radius: 4px;
                color: white;
                font-weight: bold;
            }

                .nav a:hover {
                    background-color: #3B0B0B;
                }

        input[type="submit"],input[type="button"] {
            background-color: #569ADA;
            padding: 5px;
            border-radius: 8px;
            -ms-border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

            input[type="submit"]:hover {
                background-color: #3B0B0B;
            }

        /*/*#divUserType
        {
            background-color:white;
        }*/
    </style>
    <script type = "text/javascript" >
        function changeHashOnLoad() {
            window.location.href += "#";
            setTimeout("changeHashAgain()", "50");
        }

        function changeHashAgain() {
            window.location.href += "1";
        }

        var storedHash = window.location.hash;
        window.setInterval(function () {
            if (window.location.hash != storedHash) {
                window.location.hash = storedHash;
            }
        }, 50);


</script>
</head>
<body style="background-color: #D7E9FE;" onload="changeHashOnLoad(); " >
  
   
    <script type="text/javascript">

        function OpenPdfTest(labNo) {
            if ($.trim(labNo) != "") {
                window.open("popup.aspx?LabNo=" + labNo);
            }
        }

    </script>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <asp:ServiceReference Path="~/Design/Common/Services/CommonServices.asmx"  InlineScript="true"/>
            </Services>
        </Ajax:ScriptManager>
        
           
                <div style="border: 1px solid Gray;">
                    
                    <div style="background-color: white">
                        <table style="width: 100%; border: 1px solid gray;">
                            <tr>
                                <td >
                                  <img src="Images/SHLlogo.png" alt="" height="240" width="490" />
                                <td >
                                   
                                    <div id="menu" runat="server">

                                        <ul class="nav">

                                            <li style="display: none;"><a href="ViewlabReportPanel.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Patient Report</span></a></li>
                                            <li style="display: none;"><a href="OtherReports.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Other Report</span></a></li>




                                            <li style="display: none;"><a href="ContactUs.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Contact US</span></a></li>
                                            <li><asp:LinkButton ID="ink" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li>
                                        </ul>
                                    </div>
                                    <div id="menupat" runat="server" visible="false">
                                        <ul class="nav">
                                            <li><a href="ViewlabReportPanel.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Patient Report</span></a></li>
                                            <li><a href="ContactUs.aspx<%=Request.RawUrl.Substring(Request.RawUrl.IndexOf('?'))%>"><span>Contact US</span></a></li>
                                            <li>
                                                <asp:LinkButton ID="LinkButton1" runat="server" OnClick="ink_Click">Log Out</asp:LinkButton></li>
                                        </ul>
                                    </div>
                                   
  
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div style="margin: 0px auto 0px auto; width: 1000px; background-color: #EFF3FB;">

                        <div style="width: 1000px;">
                            <div>
                                <asp:Label runat="server" ID="lblBalance" Style="float: right;" ForeColor="Red" Font-Bold="true"></asp:Label></div>
                            <br />
                            <div style="text-align: center">
                                <b>Investigation Result</b>
                                <br />
                                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                                <asp:Label ID="lblOnlineStatus" runat="server"  style="display:none" ClientIDMode="Static"></asp:Label>
                            </div>

                        </div>
                        <div id="divUserType" runat="server" style="width: 1000px"
                            visible="false">

                            <table style="width: 100%; border: 1px solid #569ADA;border-collapse:collapse">
                               
                                <tr>
                                    <td  style="width: 13%;text-align:right">Visit No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtLabNo" runat="server"  Width="140px" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 15%;text-align:right">UHID No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtCRNo" runat="server"  Width="140px" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 12%;text-align:right">BarCode No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtBarCodeNo" runat="server"  Width="140px" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td  style="width: 13%;text-align:right">Patient Name :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtPName" runat="server"  Width="140px" MaxLength="30" AutoCompleteType="Disabled"></asp:TextBox></td>
                                    <td  style="width: 15%;text-align:right">Mobile No. :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="txtMobile" runat="server"  Width="140px" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td  style="width: 12%"<%-->Department :--%>&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:DropDownList ID="ddlDepartment" runat="server" Width="150px" style="display:none">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtPhone" runat="server" style="display:none"  Width="140px" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox></td>
                                </tr>
                                
                                <tr>
                                    <td  style="width: 13%;text-align:right">From Date :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:TextBox ID="FrmDate" runat="server" Width="140px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                        
                                    </td>
                                    <td  style="width: 15%;text-align:right">To Date :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                         <asp:TextBox ID="ToDate" runat="server" Width="140px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                       
                                    </td>
                                    <td  style="width: 12%;text-align:right">Status :&nbsp;</td>
                                    <td  style="width: 16.5%">
                                        <asp:DropDownList ID="ddlStatus" runat="server" Width="144px">
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
                                     <td  style="width: 15%">
                                        <asp:Label ID="Labno" runat="server" style="display:none"></asp:Label>
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
                    
                                <input type="button" value="Search" onclick="labSearch()"  id="btnSearch" />
                                &nbsp;&nbsp; &nbsp;     
                    
                   
                               
                            </div>

                        </div>

                        <div style="text-align: center; border: 1px solid #569ADA;">

                            <table style="width:1000px;border-collapse:collapse" >
                                <tr style="text-align:center">
                                    <td style="text-align:center" >

                                        <table style="width:1000px;text-align:center">
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
                                                 <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                       
                          <div id="LabSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                        <input type="button" value="Print" id="btnPrintAll" onclick="printAllLabReport()" class="ItDoseButton"
                            style="display: none" />

                      
                    </div>

                </div>
      
        

        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" />
        </div>
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

        <script id="tb_LabSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tl_labSearch"
    style="width:980px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Visit No.</th>          
			<th class="GridViewHeaderStyle" scope="col" style="width:124px;">Patient&nbsp;Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Gender</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Panel</th>            
            <th class="GridViewHeaderStyle" scope="col" style="width:86px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Test Name</th>
           <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Status</th>
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
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:124px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:120px;"><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdGender" style="width:70px;text-align:center"><#=objRow.Gender#></td>
                    <td class="GridViewLabItemStyle" id="tdPanel" style="width:180px;"><#=objRow.Panel#></td>
                    <td class="GridViewLabItemStyle" id="tdInDate" style="width:86px;text-align:center"><#=objRow.InDate#></td>
                    <td class="GridViewLabItemStyle" id="tdTestName"  style="width:220px;text-align:left" ><#=objRow.testName#></td>
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
        <script type="text/javascript">
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
                                //  $("." + LedgertransactionNo).prop('checked', 'checked');
                                //  $(rowID).closest('tr').find("#chkSelect input[type=checkbox]").prop('checked', 'checked');
                                $rowid.find("#chkSelect").prop('checked', 'checked');
                            }
                        }
                    });

                }
                
                //var totalChkLength = $("." + LedgertransactionNo).length;

                //var chkLength = $("input:checkbox[class=" + LedgertransactionNo + "]:checked").length;

              
                //if ($("." + LedgertransactionNo).is(':checked'))
                //    $("." + LedgertransactionNo).prop('checked', 'checked');
                
            }
            function labSearch() {
                $("#btnSearch").attr('disabled', 'disabled').val('Submitting...');
                PageMethods.bindLabReport($("#Labno").text(), $.trim($("#txtLabNo").val()), $.trim($("#txtCRNo").val()), $.trim($("#txtPName").val()), $.trim($("#txtMobile").val()), $("#ddlDepartment").val(), $("#FrmDate").val(), $("#ToDate").val(), $("#ddlStatus").val(), $("#ddlPatientType").val(), $("#lblUseType").text(), '<%=Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["OnlinePanelID"]))%>', '', '', $("#txtBarCodeNo").val(), onLabSuccess, OnLabfailure);
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
                var testID = ""; var CulturetestID = ""; var normalTestID = ""; var IsCulture = "";var labCount=0;
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
               // var testID =$.trim( $(rowID).closest('tr').find('#tdTest_ID').text());
               // var Investigation_ID = $.trim($(rowID).closest('tr').find('#tdInvestigation_ID').text());
               // var IsCulture = $.trim($(rowID).closest('tr').find('#tdIsCulture').text());
                if (labCount == 0) {
                    alert('Please Select Item');
                    return;
                }
                else
                    if (CulturetestID != "") {
                        testID = CulturetestID
                    }
                    PageMethods.printLabReport(testID, $("#lblUseType").text(), onLabPrintSuccess, OnLabPrintfailure, alltestID);
            }
            function onLabPrintSuccess(result, alltestID) {                                         
                // CommonServices.encryptData(1, onSuccessOnlineData, OnfailureOnlineData, alltestID);
                //if (normalTestID != "") {
                //    window.open('../../Design/Lab/labreportnew.aspx?TestID=' + normalTestID + '&PHead=' + PHead + '&isOnlinePrint=' + isOnlinePrint + '');
                //}
                //if (CulturetestID != "") { 
                //    window.open('../../Design/Lab/labreportmicro.aspx?IsPrev=1&TestID=' + CulturetestID + '&PHead=' + PHead + '&isOnlinePrint=' + isOnlinePrint + '');
                //}
                
                var normalTestID = alltestID.split('#')[0];
                var CulturetestID = alltestID.split('#')[1];

                if (normalTestID != "")
                    CommonServices.encryptData(normalTestID, onSuccessOnlineReport, OnfailureOnlineReport);
                if (CulturetestID != "")
                    CommonServices.encryptData(CulturetestID, onSuccessCulturetestReport, OnfailureCulturetestReport);

            }
            function onSuccessOnlineReport(normalTestID) {
               
               
                //var normalTestID = alltestID.split('#')[0];
                //var CulturetestID = alltestID.split('#')[1];
                
                //if (normalTestID != "")
                //    CommonServices.encryptData(normalTestID, onSuccessOnlineReport, OnfailureOnlineReport, result);
                //if (CulturetestID != "")
                //    CommonServices.encryptData(CulturetestID, onSuccessCulturetestReport, OnfailureCulturetestReport, result);

                var PHead = $("#Chk_Header").is(':checked') ? 1 : 0;
                CommonServices.encryptData(PHead, onCompleteSuccessNormal, OnCompletefailureNormal, normalTestID);

            }

            function onCompleteSuccessNormal(PHead, normalTestID) {

                window.open('../../Design/Lab/labreportnew.aspx?TestID=' + normalTestID + '&PHead=' + PHead + '&isOnlinePrint=' + $("#lblOnlineStatus").text() + '');
            }

            function OnCompletefailureNormal() {

            }
            function onSuccessCulturetestReport(CulturetestID) {                
                var PHead = $("#Chk_Header").is(':checked') ? 1 : 0;
                CommonServices.encryptData(PHead, onCompleteSuccessCulturetest, OnCompletefailureCulturetest, CulturetestID);
            }
            function onCompleteSuccessCulturetest(PHead, CulturetestID) {               
                window.open('../../Design/Lab/labreportnew.aspx?TestID=' + CulturetestID + '&PHead=' + PHead + '&isOnlinePrint=' + $("#lblOnlineStatus").text() + '');

            }
            function OnCompletefailureCulturetest() {

            }
            function OnfailureCulturetestReport() {

            }




            //


            //function onSuccessOnlineReport(normalTestID, isOnlinePrint) {
            //    var PHead = $("#Chk_Header").is(':checked') ? 1 : 0;
            //    CommonServices.encryptData(PHead, onCompleteSuccess, OnCompletefailure, alltestID);
            //    window.open('../../Design/Lab/labreportnew.aspx?TestID=' + normalTestID + '&PHead=' + PHead + '&isOnlinePrint=' + isOnlinePrint + '');
            //}
            //function onCompleteSuccess(result) {
            //    window.open('../../Design/Lab/labreportnew.aspx?TestID=' + normalTestID + '&PHead=' + PHead + '&isOnlinePrint=' + isOnlinePrint + '');
            //}
            //function onSuccessCulturetestReport(CulturetestID, isOnlinePrint) {
            //    var PHead = $("#Chk_Header").is(':checked') ? 1 : 0;
            //    window.open('../../Design/Lab/labreportmicro.aspx?TestID=' + CulturetestID + '&PHead=' + PHead + '&isOnlinePrint=' + isOnlinePrint + '');
            //}
            //function OnfailureCulturetestReport() {

            //}
            function OnfailureOnlineReport() {

            }
            //function OnfailureOnlineData() {


            //}
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
    </form>
</body>
</html>
