<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AuditTrailReport.aspx.cs" Inherits="Design_Store_MIS_AuditTrailReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
  <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <style>
        .GridViewHeaderStyle2 {
            background-color: #673AB7;
            /* color:white;*/
            border: solid 1px #C6DFF9;
            font-weight: bold;
            color: #FFFFFF;
            font-size: 8.5pt;
        }
    </style>
    <script type="text/javascript">
        
        function Search() {
            $('#tb_grid').hide(); 
            var _CentreID = '';
            $('#<%=lstCentre.ClientID%> :selected').each(function (i, selected) {
                if (_CentreID == "") {
                    _CentreID = $(selected).val();
                }
                else {
                    _CentreID = _CentreID + "," + $(selected).val();
                }
            });
            var _UserID = '';
            
            var _ReportType = $("#<%=ddlReportType.ClientID %>").val();
            var compare = '';
            var labno = $("#<%=txtLab.ClientID %>").val();
           // $.blockUI();
            $.ajax({
                url: "AuditTrailReport.aspx/Search",
                data: '{dtFrom:"' + $("#<%=dtFrom.ClientID %>").val() + '",dtTo:"' + $("#<%=dtTo.ClientID %>").val() + '",CentreID:"' + _CentreID + '",UserID:"' + _UserID + '",ReportType:"' + _ReportType + '",compare:"' + compare + '",labno:"' + labno + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "-1") {
                        showerrormsg('Session Expired. Please Login Again');
                        $('#tb_grid').hide();
                        $('#tb_Status').hide();
                        // $.unblockUI();
                    }
                    var $responseData = JSON.parse(result.d);
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        toast("Info", "No Record Found", "");
                    }
                    else {
                        $('#tb_grid').show();
                        $('#tb_Status').show();
                        $('#tb_Status tr').remove();
                        var theader = '';
                        if (_ReportType == '1' || _ReportType == '2' || _ReportType == '3' || _ReportType == '4' || _ReportType == '5'  || _ReportType == '8' || _ReportType == '9') {
                            theader = "";
                            theader += '<tr id="tr_1" style="">';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Status</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Status By</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 150px;">Status Date</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">OLD Name</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">New Name</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">Remarks</td>';
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }

                        //vivek Panel_ID,ItemID,Company_Name,ItemName,OLDRate,NewRate,OLDRate_CreatedByID,OLDRate_CreatedBy,OLDRate_dtEntry,NewRate_CreatedByID,NewRate_CreatedBy,NewRate_dtEntry      

                       else if (_ReportType == '6') {
                            theader = "";
                            theader += '<tr id="tr_1" style="">';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                            //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Panel_ID</td>';
                            //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">ItemID</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Company_Name</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">ItemName</td>';         
                           
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">OLDRate</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate</td>';

                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">OLDRate_CreatedBy</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">OLDRate_dtEntry</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_CreatedByID</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_CreatedBy</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_dtEntry</td>';
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }
                           //vivek


                        else if (_ReportType == '7') {
                           theader = "";
                           theader += '<tr id="tr_1" style="">';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                           //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Panel_ID</td>';
                           //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">ItemID</td>';
                           //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Company_Name</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">ItemName</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">TestCode</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">FromDate</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">ToDate</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">OldName</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">NewName</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Remarks</td>';

                           //theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">OLDRate</td>';
                           //theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate</td>';

                           //theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">OLDRate_CreatedBy</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">OLDRate_dtEntry</td>';
                          
                           
                           theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_CreatedByID</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_CreatedBy</td>';
                           theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">NewRate_dtEntry</td>';
                           theader += '</tr>';
                           $('#tb_Status').append(theader);
                       }
                           //vivek


                        else if (_ReportType == '10') {
                            theader = "";
                            theader += '<tr id="tr_1" style="">';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">STATUS</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 300px;">Centre</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">labstarttime</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">labendtime</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 300px;">Test Name</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Processtype</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">TATType</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">Working Hours</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">Non Working Hours</td>';

                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">Urgent TAT</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">Days</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 2000px;">Sun Mon Tue Wed Thu Fri Sat</td>';
 

                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">CutoffTime</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Same Day delivery Time</td>';


                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Next Day delivery Time</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px;">Approval To Dispatch</td>';
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }
                            //vivek



                        else {

                            var col = [];
                            $.each($responseData[0], function (key, value) {
                                if (col.indexOf(key) === -1) {
                                    col.push(key);
                                }
                            });

                            theader = "";
                            theader += '<tr id="tr_1" style="">';
                            for (var i = 0; i < col.length; i++) {
                                if (col[i] === 'User') {
                                    theader += '<td class="GridViewHeaderStyle2" style="width:150px;">' + col[i] + '</td>';
                                } else {
                                    theader += '<td class="GridViewHeaderStyle2" style="width:40px;">' + col[i] + '</td>';
                                }
                            }
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }
                        var preval = '';
                       // $.each(ProData, function (index, value) {
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var mydata = "";
                            if (_ReportType == '1' || _ReportType == '2' || _ReportType == '3' || _ReportType == '4' || _ReportType == '5' || _ReportType == '8' || _ReportType == '9') {
                                if (i == 0) {
                                    mydata = "";
                                    mydata = "<tr id='" + $responseData[i].LabNo + "' >";
                                    mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>LabNo : ' + $responseData[i].LabNo + ', Registration By : ' + $responseData[i].RegBy + ', Registration Date : ' + $responseData[i].RegDate + '</td>';
                                    mydata += "</tr>";
                                    $('#tb_Status').append(mydata);
                                    mydata = "";
                                    mydata = "<tr style='background-color:white;'>";
                                    mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Status + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].StatusBy + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"><b>' + $responseData[i].StatusDate + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].OLDNAME + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 100px; text-align:left"><b>' + $responseData[i].NEWNAME + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].Remarks + '<b></td>';
                                    mydata += "</tr>";
                                    $('#tb_Status').append(mydata);
                                } else {
                                    if ($responseData[i].LabNo == preval) {
                                        mydata = "";
                                        mydata = "<tr style='background-color:white;'>";
                                        mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Status + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].StatusBy + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"><b>' + $responseData[i].StatusDate + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].OLDNAME + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 100px; text-align:left"><b>' + $responseData[i].NEWNAME + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].Remarks + '<b></td>';
                                        mydata += "</tr>";
                                        $('#tb_Status').append(mydata);
                                    } else {
                                        mydata = "";
                                        mydata = "<tr id='" + $responseData[i].LabNo + "' >";
                                        mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left">LabNo : <b>' + $responseData[i].LabNo + '<b>, Registration By : <b>' + $responseData[i].RegBy + '<b>, Registration Date : <b>' + $responseData[i].RegDate + '<b></td>';
                                        mydata += "</tr>";
                                        $('#tb_Status').append(mydata);
                                        mydata = "";
                                        mydata = "<tr style='background-color:white;'>";
                                        mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Status + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].StatusBy + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"><b>' + $responseData[i].StatusDate + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].OLDNAME + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 100px; text-align:left"><b>' + $responseData[i].NEWNAME + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].Remarks + '<b></td>';
                                        mydata += "</tr>";
                                        $('#tb_Status').append(mydata);
                                    }
                                }
                                preval = $responseData[i].LabNo;
                            }

                           
                            else {

                                mydata = "";
                                if ($responseData[i].User === 'Grand Total ::') {
                                    mydata += '<tr id="tr_1" style="background-color:red; color:white;">';
                                } else {
                                    mydata += '<tr id="tr_1" style="">';
                                }
                                var col = [];
                                $.each($responseData[0], function (key, value) {
                                    if (col.indexOf(key) === -1) {
                                        col.push(key);
                                    }
                                });
                                for (var j = 0; j < col.length; j++) {
                                    if (col[j] == 'User') {
                                        mydata += '<td class="GridViewLabItemStyle" style="width:40px;">' + $responseData[i].User + '</td>';
                                    }
                                  
                                }
                                mydata += '</tr>';
                                $('#tb_Status').append(mydata);
                            }

                            //vivek
                            if ( _ReportType == '6') {
                            
                             mydata = "";
                           // mydata = "<tr id='" + $responseData[i].LabNo + "' >";
                           // mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>LabNo : ' + $responseData[i].LabNo + ', Registration By : ' + $responseData[i].RegBy + ', Registration Date : ' + $responseData[i].RegDate + '</td>';
                            mydata += "</tr>";
                            $('#tb_Status').append(mydata);
                            mydata = "";


                        //   Panel_ID, ItemID, Company_Name, ItemName, OLDRate, NewRate, OLDRate_CreatedByID, OLDRate_CreatedBy, OLDRate_dtEntry, NewRate_CreatedByID, NewRate_CreatedBy, NewRate_dtEntry
                            mydata = "<tr style='background-color:white;'>";
                            mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                            //mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Panel_ID + '<b></td>';
                            //mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].ItemID + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"><b>' + $responseData[i].Company_Name + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].ItemName + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 100px; text-align:left"><b>' + $responseData[i].OLDRate + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate + '<b></td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].OLDRate_CreatedBy + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].OLDRate_dtEntry + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_CreatedByID + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_CreatedBy + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_dtEntry + '<b></td>';

                            mydata += "</tr>";
                            $('#tb_Status').append(mydata);
                        }
                            //vivek 

                           
                            
                            //vivek
                            if (_ReportType == '7') {

                                mydata = "";
                                // mydata = "<tr id='" + $responseData[i].LabNo + "' >";
                                // mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>LabNo : ' + $responseData[i].LabNo + ', Registration By : ' + $responseData[i].RegBy + ', Registration Date : ' + $responseData[i].RegDate + '</td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                                mydata = "";

                                 
                            
                               
                                mydata = "<tr style='background-color:white;'>";
                                mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                //mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Panel_ID + '<b></td>';
                                //mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].ItemID + '<b></td>';
                              
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].ItemName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].TestCode + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].FromDate + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].ToDate + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].OldName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].NewName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].Remarks + '<b></td>';
                       
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].OLDRate_dtEntry + '<b></td>';
                                //mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].OLDRate_CreatedBy + '<b></td>';
                               
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_CreatedByID + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_CreatedBy + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].NewRate_dtEntry + '<b></td>';

                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            }
                            //vivek 




                            //vivek
                            if (_ReportType == '10') {

                                mydata = "";
                                // mydata = "<tr id='" + $responseData[i].LabNo + "' >";
                                // mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>LabNo : ' + $responseData[i].LabNo + ', Registration By : ' + $responseData[i].RegBy + ', Registration Date : ' + $responseData[i].RegDate + '</td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                                mydata = "";




                                mydata = "<tr style='background-color:white;'>";
                                mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 50px; text-align:left"><b>' + $responseData[i].STATUS + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 300px; text-align:left"><b>' + $responseData[i].centre + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].labstarttime + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 100px; text-align:left"><b>' + $responseData[i].labendtime + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 300px; text-align:left"><b>' + $responseData[i].Testname + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 50px; text-align:left"><b>' + $responseData[i].Processtype + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 50px; text-align:left"><b>' + $responseData[i].TATType + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 50px; text-align:left"><b>' + $responseData[i].woringhours + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 50px; text-align:left"><b>' + $responseData[i].nonworinghours + '<b></td>';

                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 50px; text-align:left"><b>' + $responseData[i].stathours + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 50px; text-align:left"><b>' + $responseData[i].Days + '<b></td>';

                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 300px; text-align:left">';
                                if ($responseData[i].Sun == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">Sun</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;" >Sun</span>';
                                }
                                if ($responseData[i].Mon == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">Mon</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">Mon</span>';
                                }
                                if ($responseData[i].Tue == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">Tue</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">Tue</span>';
                                }
                                if ($responseData[i].wed == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">wed</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">wed</span>';
                                }
                                if ($responseData[i].Thu == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">Thu</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">Thu</span>';
                                }
                                if ($responseData[i].Fri == "1") {
                                    mydata += ' <span style="Color:Green;font-weight:bold;background-color:#90ee90">Fri</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">Fri</span>';
                                }
                                if ($responseData[i].Sat == "1") {
                                    mydata += ' <span style="Color:Green; font-weight:bold;background-color:#90ee90" >Sat</span>';

                                } else {
                                    mydata += ' <span style="Color:Black;font-weight:bold;">Sat</span>';
                                }
                                mydata += '  </td>';


                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 50px; text-align:left"><b>' + $responseData[i].CutOffTime + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 200px; text-align:left"><b>' + $responseData[i].samedaydeliverytime + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 20px; text-align:left"><b>' + $responseData[i].nextdaydeliverytime + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 50px; text-align:left"><b>' + $responseData[i].Approval_To_Dispatch + '<b></td>';

                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            }
                            //vivek 



                        }
                        // $.unblockUI();

                    }
                    // $.unblockUI();

                },
                error: function (xhr, status) {
                    // $.unblockUI();
                    $('#tb_grid').hide();
                    $('#tb_Status').hide();
                    showerrormsg("Please contact to Admin");
                    alert(xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
       <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager2" runat="server">
        <Services>
            <Ajax:ServiceReference Path="~/Lis.asmx" />
        </Services>
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Audit Trail Report</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
                <input type="hidden" id="hdnPickedRow" value="0" />
                <input type="hidden" id="hdnTotalSearchedRecord" value="0" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Black" runat="server" Style="color: black" />
            </div>
            <div class="row" style="vertical-align: top; margin-left: -18px; margin-right: -20px">
                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
			   <label class="pull-left">From Date   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:TextBox ID="dtFrom" runat="server" Width="160px" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="dtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
		   </div>
                          <div class="col-md-3">
			   <label class="pull-left">To Date   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:TextBox ID="dtTo" runat="server" Width="160px"  />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="dtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
		   </div>
                           <div class="col-md-3">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:DropDownList ID="lstCentre" runat="server" Width="160px" SelectionMode="Multiple"></asp:DropDownList>
		   </div>
                        </div>
                     <div class="row">
                       
                           <div class="col-md-3">
			   <label class="pull-left">Report Type    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:DropDownList ID="ddlReportType" runat="server" CssClass="ddlReportType chosen-select" Width="160px">
                                <asp:ListItem Selected="True" Value="1">Demographic Summary</asp:ListItem>
                                <asp:ListItem  Value="2">Panel Summary</asp:ListItem>
                   <asp:ListItem  Value="3">Investigation Summary</asp:ListItem>
                   <asp:ListItem  Value="4">Observation Summary</asp:ListItem>
                   <asp:ListItem  Value="5">Employee Summary</asp:ListItem>
                   <asp:ListItem  Value="6">Itemwise List Summary</asp:ListItem>
                 <asp:ListItem  Value="7">ClientWiserate List Summary</asp:ListItem>
                    <asp:ListItem  Value="8">ShedulRateList Summary</asp:ListItem>
                   <asp:ListItem  Value="9">TransferRate Summary</asp:ListItem>
                   <asp:ListItem  Value="10">TATMaster</asp:ListItem>
                   <%--  <asp:ListItem  Value="8">FormulaMaster Summary</asp:ListItem>--%>
                               <%-- <asp:ListItem  Value="2">Reg User vs Status Count</asp:ListItem>
                                <asp:ListItem Value="3">Change By vs Status Count</asp:ListItem>--%>
                            </asp:DropDownList>
		   </div>

                         
                           <div class="col-md-3">
			   <label class="pull-left">Lab No    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
               <asp:TextBox ID="txtLab" runat="server" Width="160px" />
			  
		   </div>
                    </div>
                     <div class="row">
                         
                       
                           <div class="col-md-21" style="text-align:center">
                         <input type="button" id="btnSearch" runat="server" class="searchbutton" value="Search" onclick="Search();" />&nbsp;&nbsp;&nbsp;                           
                            <img id="btnExcel" src="../../../App_Images/excelexport.gif" alt="Export To Excel" onclick="ExportExcelFromTable()" style="width: 34px; height: 30px; display:none;" />
                            <asp:ImageButton ID="ImageButton1" runat="server" Height="35px" ImageUrl="~/App_Images/excelexport.gif" OnClick="ImageButton1_Click" Width="35px" />
                        </div>
                         </div>

                </div>
            </div>
             <div class="Purchaseheader">
                Data
            </div>
            <div class="row" style="vertical-align: top; margin-left: -18px; margin-right: -20px">
                <div class="col-md-21">
                    <div class="row">
                        <table style="width: 99%; border-collapse: collapse; text-align: left;" id="tb_Status" class="GridViewStyle"></table>
                        </div>
                    </div>
                </div>
         </div>
    <script type="text/javascript">
        $(function () {
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
            $('#tb_grid').hide(); 
        });


        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tb_Status'); // id of table

            for (j = 0 ; j < tab.rows.length ; j++) {
                tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
                //tab_text=tab_text+"</tr>";
            }

            tab_text = tab_text + "</table>";
            tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
            tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
            tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
            {
                txtArea1.document.open("txt/html", "replace");
                txtArea1.document.write(tab_text);
                txtArea1.document.close();
                txtArea1.focus();
                sa = txtArea1.document.execCommand("SaveAs", true, "Say Thanks to Sumit.xls");
            }
            else                 //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showscuessmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'lightgreen');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>


</asp:Content>

