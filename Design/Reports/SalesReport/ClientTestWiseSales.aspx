﻿<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="ClientTestWiseSales.aspx.cs" Inherits="Design_Sales_ClientTestWiseSales" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
         <form id="form1" runat="server">
    <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager2" runat="server">
        <Services>
            <Ajax:ServiceReference Path="~/Lis.asmx" />
        </Services>
          <Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
    </Ajax:ScriptManager>
    
    <style>
        #tblItems th {
            position: -webkit-sticky;
            position: sticky;
            top: 0;
            z-index: 5;
        }


        #RefHead th {
            /*background-color: #09f;*/
            background-color: #673AB7;
            color: #fff;
            padding: 2px;
            font-size: 10px;
        }

        #RefBody td {
            background-color: #fff;
            color: #000;
            padding: 2px;
            text-align: left;
            font-size: 10px;
        }

        .searchbutton {
            cursor: pointer;
            background-color: blue;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .savebutton {
            cursor: pointer;
            background-color: green;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }
    </style>
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
            $("#tb_grid").hide();
        });
        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tblItems'); // id of table

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
		
		function ExcelReport() 
		 {
          
              var pro = $("#<%=ddlpro.ClientID %>").val();
            serverCall('ClientTestWiseSales.aspx/ClientTestWiseSalesExcel', { ToDate: $("#<%=txtTo.ClientID %>").val(), FromDate: $("#<%=txtFrom.ClientID %>").val(), pro: pro, ItemID: $("#<%=ddlInv.ClientID %>").val(), reporttype: ReportType }, function (response) {
                    debugger;
                    var ProData = $.parseJSON(response);	
            if(ProData=="1")
{
  window.open('../../Common/ExportToExcel.aspx'); 
}
else
{
 showerrormsg("No Record(s) found");
}

		});
		}
		
		
		
		
		
        function Search(ReportType) {
            var pro = $("#<%=ddlpro.ClientID %>").val();
            serverCall('ClientTestWiseSales.aspx/ClientTestWiseSales', { ToDate: $("#<%=txtTo.ClientID %>").val(), FromDate: $("#<%=txtFrom.ClientID %>").val(), pro: pro, ItemID: $("#<%=ddlInv.ClientID %>").val(), reporttype: ReportType }, function (response) {

                if (ReportType != "Excel") {
                    if (response != "") {
                        var ProData = $.parseJSON(response);
                        $("#tb_grid").show();
                        $("#RefHead").empty();
                        var col = [];
                        for (var i = 0; i < ProData.length; i++) {
                            for (var key in ProData[i]) {
                                if (col.indexOf(key) === -1) {
                                    col.push(key);
                                }
                            }
                        }
                        debugger
                        var table = document.getElementById("tblItems");
                        var tr = table.insertRow(-1);
                        for (var i = 0; i < col.length; i++) {
                            // var thead = document.createElement("thead");
                            var th = document.createElement("th");
                            th.innerHTML = col[i];
                            tr.appendChild(th);
                            $("#RefHead").append(tr);
                        }


                        $('#tblViewReportData').show();
                        $('[id$=lblErr]').text('');

                        var myData = $.parseJSON(response);
                        //var myData = $.parseJSON(result);
                        var col = [];
                        for (var i = 0; i < myData.length; i++) {
                            for (var key in myData[i]) {
                                if (col.indexOf(key) === -1) {
                                    col.push(key);
                                }
                            }
                        }

                        var table = document.createElement("table");
                        var tr = table.insertRow(-1);
                        for (var i = 0; i < col.length; i++) {
                            // var thead = document.createElement("thead");
                            var th = document.createElement("th");
                            th.innerHTML = col[i];
                            tr.appendChild(th);
                        }
                        for (var i = 0; i < myData.length; i++) {

                            tr = table.insertRow(-1);

                            for (var j = 0; j < col.length; j++) {
                                var tabCell = tr.insertCell(-1);
                                tabCell.innerHTML = myData[i][col[j]];
                            }
                        }

                        var divContainer = document.getElementById("Table1");
                        divContainer.innerHTML = "";

                        divContainer.appendChild(table);
                        $('#Table1').find('table').attr('id', 'tbltempItems');
                        
                        debugger
                        $('#RefBody').empty();
                        var Executive = '';
                        var ColSpan = $('#RefHead').find('th').length;
                        var trLength = $('#tbltempItems').find('tr').length;
                        var html = '';
                        var accounts = [];
                        $('#tbltempItems tr').each(function (index) {
                            if (index > 0) {
                                if (Executive != $(this).find('td').eq(0).text()) {
                                    if (index > 1) {
                                        html += '<tr ">';
                                        for (var i = -1; i < ColSpan - 3; i++) {
                                            if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                                if (i == -1)
                                                    html += '<td style="text-align: left;background-color:#e69da0;color:white;" colspan="3"><b> Total </b></td>'
                                                else
                                                    html += '<td style="text-align: left;background-color:#e69da0;color:white;"><b> ' + (isNaN(accounts[i]) ? "" : accounts[i]) + '</b></td>';
                                            }
                                            accounts[i] = 0;
                                        }
                                    }
                                    html += '</tr>';
                                    if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                        html += '<tr>';
                                        html += '<td style="text-align: left;background-color: #aeb2ca" colspan="' + ColSpan + '"> ' + $(this).find('td').eq(0).text() + ' </td>'
                                        Executive = $(this).find('td').eq(0).text();
                                        html += '</tr>';
                                    }
                                }
                                html += '<tr>';
                                for (var i = -1; i < ColSpan - 3; i++) {
                                    if (i == -1) {
                                        if ($(this).find('td').eq(0).text() != undefined) {
                                            if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                                html += '<td></td>'
                                                html += '<td>' + $(this).find('td').eq(1).text() + '</td>'
                                                html += '<td>' + $(this).find('td').eq(2).text() + '</td>'
                                            }
                                        }
                                        else {
                                            if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                                html += '<td></td>'
                                                html += '<td>' + $(this).find('td').eq(1).text() + '</td>'
                                                html += '<td>' + $(this).find('td').eq(2).text() + '</td>'
                                            }
                                        }
                                    } else {
                                        if (Executive != $(this).find('td').eq(0).text() || accounts[i] == undefined) {
                                            debugger
                                            if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                                html += '<td>' + (isNaN($(this).find('td').eq(i + 3).text()) ? "" : $(this).find('td').eq(i + 3).text()) + '</td>';
                                                //html += '<td>' + (isNaN($(this).find('td').eq(i + 3).text()) ? "" : $(this).find('td').eq(i + 3).text()) + '</td>';

                                                if ($(this).find('td').eq(i + 3).text() == "")
                                                    accounts[i] = 0;
                                                else {
                                                    accounts[i] = $(this).find('td').eq(i + 3).text();
                                                }
                                            }
                                        }
                                        else {
                                            if ($(this).find('td').eq(1).text() != "Grand Total ::") {
                                                html += '<td>' + (isNaN($(this).find('td').eq(i + 3).text()) ? "" : $(this).find('td').eq(i + 3).text()) + '</td>';

                                                if ($(this).find('td').eq(i + 3).text() == "")
                                                    accounts[i] = accounts[i];
                                                else
                                                    accounts[i] = Number(accounts[i]) + parseInt($(this).find('td').eq(i + 3).text());
                                            }
                                        }
                                    }
                                }

                                html += '</tr>';
                                if (index == (trLength - 2)) {
                                    debugger
                                    html += '<tr>';
                                    for (var i = -1; i < ColSpan - 3; i++) {
                                        if (i == -1)
                                            html += '<td style="text-align: left;background-color:#e69da0;color:white;" colspan="3"><b> Total </b></td>'
                                        else {
                                            //html += '<td></td>';
                                            html += '<td style="text-align: left;background-color:#e69da0;color:white;" ><b> ' + (isNaN(accounts[i]) ? "" : accounts[i]) + '</b></td>';
                                        }

                                        accounts[i] = 0;
                                        
                                    }
                                    html += '</tr>';

                                }
                                if (index == (trLength - 1)) {
                                    debugger
                                    html += '<tr>';
                                    for (var i = -1; i < ColSpan - 2; i++) {
                                        if ($(this).find('td').eq(1).text() == "Grand Total ::") {
                                            if (i == -1)
                                                html += '<td style="text-align: left;background-color:#ef1f27;color:white;" colspan="2"><b> ' + $(this).find('td').eq(1).text() + ' </b></td>'
                                            else
                                                html += '<td style="text-align: left;background-color:#ef1f27;color:white;"><b> ' + $(this).find('td').eq(i + 2).text() + ' </b></td>'
                                        }
                                    }
                                    html += '</tr>';

                                }
                            }

                        });

                        $('#RefBody').append(html);
                    }
                    else {
                        showerrormsg('No Record Found');
                        $("#tb_grid").hide();
                    }
                } else {

                    if (response != "") {
                        window.open('../../Design/Common/ExportToExcel.aspx');
                    }
                    else {
                        showerrormsg('No Record Found');
                    }
                }
            });
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

    <div id="Pbody_box_inventory">
        <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center">Sales Executive Vs Client Vs Test</div>
            <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
 <div class="row">
                 <div class="col-md-2"> <label class="pull-right">From :</label></div>
                <div class="col-md-3"><asp:TextBox ID="txtFrom" runat="server" ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFrom" Format="dd-MMM-yyyy" PopupButtonID="txtFrom"></cc1:CalendarExtender>
</div>
     <div class="col-md-2"> <label class="pull-right">To :</label></div>
                <div class="col-md-3"> <asp:TextBox ID="txtTo" runat="server" ReadOnly="true" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtTo" Format="dd-MMM-yyyy" PopupButtonID="txtTo"></cc1:CalendarExtender></div>
      <div class="col-md-2"> <label class="pull-right">Executives :</label></div>
                <div class="col-md-3"><asp:DropDownList ID="ddlpro" runat="server" CssClass="chosen-select"  ClientIDMode="Static"></asp:DropDownList> </div>
     <div class="col-md-3"> <label class="pull-right">TestName :</label></div>
                <div class="col-md-3"><asp:DropDownList ID="ddlInv" runat="server" CssClass="chosen-select"  ClientIDMode="Static"></asp:DropDownList></div>
            <div class="col-md-3"> <input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Search('Table');" style="margin-left: 30px;" />&nbsp;&nbsp;&nbsp;                           
                            <img src="../../../App_Images/excelexport.gif" alt="Export" onclick="Search('Excel');" style="width: 34px; vertical-align: middle; height: 30px;" /></div>
              
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tblViewReportData" style="text-align: center; max-height: 500px; overflow-x: auto; display: none;">
            <div id="showData">
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center; overflow-y: auto; max-height: 500px;">
            <div class="content">
                <table style="width: 100%" id="tblItems" class="table table-bordered">
                    <thead id="RefHead">
                    </thead>
                    <tbody id="RefBody">
                    </tbody>
                </table>
                <div style="width: 100%; display: none" id="Table1" class="table table-bordered">
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
