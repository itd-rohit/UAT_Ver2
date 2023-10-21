<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TATPendingNew.aspx.cs" Inherits="Design_Store_MIS_TATPendingNew" %>

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
              background-color:#0095ff;
            /*   background-color:#007fff; color:white;*/
           
            border: solid 1px #C6DFF9;
            font-weight: bold;
            color: #FFFFFF;
            font-size: 8.5pt;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            Search();
            
            setInterval(
               function () { Search() }
              , 30000);
        });

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
            var Department = $("#<%=ddlDepartment.ClientID %>").val();
            var compare = '';
            
           // $.blockUI();
            $.ajax({
                url: "TATPendingNew.aspx/Search",
                data: '{dtFrom:"' + $("#<%=dtFrom.ClientID %>").val() + '",dtTo:"' + $("#<%=dtTo.ClientID %>").val() + '",CentreID:"' + _CentreID + '",UserID:"' + _UserID + '",ReportType:"' + _ReportType + '",compare:"' + compare + '",Department:"' + Department + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result == "-1") {
                        showerrormsg('Session Expired. Please Login Again');
                        $('#tb_grid').hide();
                        $('#tb_Status').hide();                       
                    }
                    var $responseData = JSON.parse(result.d);
                    $responseData = $responseData.response;
                    if ($responseData.length == 0) {
                        $('#spnTestCount').html('0');
                        $('#spnAmtCount').html('0');
                        toast("Info", "No Record Found", "");
                    }
                    else {
                        $('#tb_grid').show();
                        $('#tb_Status').show();
                        $('#tb_Status tr').remove();
                        testCount = parseInt($responseData[0].TotalTestPatient);
                        $('#spnTestCount').html(testCount);
                        totalAmt = parseFloat($responseData[0].TotalTest);
                        $('#spnAmtCount').html(totalAmt);
                        var theader = '';
                        if (_ReportType == '1') {
                            theader = "";
                            theader += '<tr id="tr_1" style="Height:40px;">';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">TAT</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Patient Name/Age/Sex</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 150px;">UHID NO./SINNO</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Department</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Tests</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">Time Diff</td>';
                           
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }
                      else  if (_ReportType == '2') {
                            theader = "";
                            theader += '<tr id="tr_1" style="Height:40px;">';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 50px">Sr.No.</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">TAT</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Patient Name/Age/Sex</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 150px;">UHID NO./SINNO</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Department</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 100px;">Tests</td>';
                            theader += '<td class="GridViewHeaderStyle2" style="width: 200px;">Time Diff</td>';
                          
                            theader += '</tr>';
                            $('#tb_Status').append(theader);
                        }
                       
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
                     
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var mydata = "";
                            if (_ReportType == '1' ) {
                              
                                    mydata = "";                                            
                                    mydata += "</tr>";
                                    $('#tb_Status').append(mydata);
                                    mydata = "";
                                    mydata = "<tr style='background-color:white;Height:30px;'>";
                                    mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                    mydata += '<td class="GridViewLabItemStyle" id="tdEmployeeName" style="width: 100px;background-color:red; text-align:left"><b>' + $responseData[i].TATDelay + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdCentre" style="width: 100px; text-align:left"><b>' + $responseData[i].pattinfo + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdRoleName" style="width: 150px; text-align:left"><b>' + $responseData[i].UHID_SINNO + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdLoginTime" style="width: 100px; text-align:left"><b>' + $responseData[i].Dept + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdLoginTime" style="width: 100px; text-align:left"><b>' + $responseData[i].Tests + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdLogOutTime" style="width: 200px; text-align:left"><b>' + $responseData[i].TimeLeft + '<b></td>';
                                  
                                    mydata += "</tr>";
                                    $('#tb_Status').append(mydata);
                                
                            }
                          else  if (_ReportType == '2') {

                                mydata = "";
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                                mydata = "";
                                mydata = "<tr style='background-color:white;Height:30px;'>";
                                mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdEmployeeName" style="width: 100px;background-color:yellow; text-align:left"><b>' + $responseData[i].TATIntimate + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdCentre" style="width: 100px; text-align:left"><b>' + $responseData[i].pattinfo + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdRoleName" style="width: 150px; text-align:left"><b>' + $responseData[i].UHID_SINNO + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdLoginTime" style="width: 100px; text-align:left"><b>' + $responseData[i].Dept + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdLoginTime" style="width: 100px; text-align:left"><b>' + $responseData[i].Tests + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdLogOutTime" style="width: 200px; text-align:left"><b>' + $responseData[i].TimeLeft + '<b></td>';
                               
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);

                            }
                        }
                    }
                },
                error: function (xhr, status) {
                   
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
            <b>TAT Pending Detail</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option
               
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
			   <label class="pull-left">TAT Type    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			  <asp:DropDownList ID="ddlReportType" runat="server" CssClass="ddlReportType chosen-select" Width="160px">
                   <asp:ListItem Selected="True" Value="1" style="background-color: red !important; color: white">Outside TAT</asp:ListItem>
                                <asp:ListItem  Value="2" style="background-color: yellow !important;">Near TAT</asp:ListItem>
                               
                          
                            </asp:DropDownList>
                 

		   </div>
                          <div class="col-md-3">
			   <label class="pull-left">Department    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
                 <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment  chosen-select">
                 </asp:DropDownList>			                
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
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight: bold; color: white;">Total Patient:&nbsp;</span><span id="spnTestCount" style="font-weight: bold; color: white;"></span>
                        <span style="font-weight: bold; color: white;">Total Test:&nbsp;</span><span id="spnAmtCount" style="font-weight: bold; color: white;"></span>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Black" runat="server" Style="color: black" />
            </div>
            <div class="row" style="vertical-align: top; margin-left: -10px; margin-right: 20px;height: 480px; overflow: auto;">
                <div class="col-md-21">
                    <div class="row">
                        <table style="width: 100%; border-collapse: collapse; text-align: left;" id="tb_Status" class="GridViewStyle"></table>
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

