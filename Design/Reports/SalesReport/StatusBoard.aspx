<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="StatusBoard.aspx.cs" Inherits="Design_SalesDiagnostic_StatusBoard" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
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
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <style>
        .GridViewHeaderStyle2 {
            background-color: #673AB7;
            /* color:white;*/
            border: solid 1px #C6DFF9;
            font-weight: bold;
            color: #FFFFFF;
            font-size: 8.5pt;
        }
        /*  .GridViewLabItemStyle {
              background-color:#ffffff;
        }*/
    </style>
    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center">Monthly Status</div>
            <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3"> <label class="pull-right">Executives :</label></div>
                <div class="col-md-3"> <asp:DropDownList ID="ddlpro" runat="server" CssClass="chosen-select" ></asp:DropDownList> </div>
                <div class="col-md-3"><input type="button" id="btnSearch" runat="server" class="searchbutton" value="Search" onclick="Summary();" /></div>
                <div class="col-md-3"><img src="../../../App_Images/excelexport.gif" alt="" onclick="ExcelReport()" style="width: 34px; height: 30px;" /></div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center;  overflow-y: auto; max-height: 500px;">
            <div class="content">
                <table style="width: 99%; border-collapse: collapse;" id="tb_Status" class="GridViewStyle">
                    <tr id="Head2">
                        <td colspan="4" class="GridViewHeaderStyle" style="width: 150px; text-align: center">Target Info</td>
                        <td colspan="3" class="GridViewHeaderStyle" style="width: 150px; text-align: center">Referal Info</td>
                        <td colspan="2" class="GridViewHeaderStyle" style="width: 150px; text-align: center">New referal Info</td>
                    </tr>
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width: 150px">Target Date</td>
                        <td class="GridViewHeaderStyle" style="width: 150px;">Target</td>
                        <td class="GridViewHeaderStyle" style="width: 150px;">Achieved</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Achieved(%)</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Total Client</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Active Client</td>
                        <td class="GridViewHeaderStyle" style="width: 150px;">Total vs Active %</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">New Client</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">New Sales</td>
                    </tr>
                </table>
                <table style="width: 99%; border-collapse: collapse;display:none;" id="tb_Referal" class="GridViewStyle">

                    <tr id="header2">
                        <td class="GridViewHeaderStyle2" style="width: 150px">Target Date</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px;">Target</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px;">Achieved</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px">Achieved(%)</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px">Total Client</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px">Active Client</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px;">Total vs Active %</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px">New Client</td>
                        <td class="GridViewHeaderStyle2" style="width: 150px">New Sales</td>
                    </tr>
                </table>
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
		 function ExcelReport() 
		{
           serverCall('StatusBoard.aspx/BindSummaryExcel', { Pro: $("#<%=ddlpro.ClientID%>").val()}, function (response) {
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
		
		
		
        function Summary() {
            serverCall('StatusBoard.aspx/BindSummary', { Pro: $("#<%=ddlpro.ClientID%>").val()}, function (response) {
                var ProData = $.parseJSON(response);
                    if (ProData.length > 0) {
                        $('#tb_grid').show();
                        $('#tb_Status tr').slice(2).remove();
                        var dataLength = ProData.length;
                        for (var i = 0; i < ProData.length; i++) {
                            var mydata = "";
                            if (ProData[i].Total != "Total ::") {
                                mydata = "<tr id='" + ProData[i].PROID + "'  style='background-color:" + ProData[i].rowColor + ";'>";
                                //mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].TargetDate + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].Target + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Achieved + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].AchievedPer + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].AltRef + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].RefNo + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].RefPer + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].NewRefNo + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].sales + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            }
                            else {
                                mydata = "<tr id='" + ProData[i].PROID + "' style='background-color: #e04755;' >";
                                // mydata += '<td colspan="9" class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"></td>';
                                mydata += '<td  class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + ProData[i].Total + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].Target) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].Achieved) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].AchievedPer) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].AltRef) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].RefNo) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].RefPer) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].NewRefNo) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(ProData[i].sales) + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            }
                        }
                       // Referal();
                    } else {
                        showerrormsg('No Record Found');
                        $("#tb_grid").hide();
                       
                    }
            });
        }
        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tb_Referal'); // id of table

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
        function Referal() {
            serverCall('StatusBoard.aspx/ReferalInfo', { Pro: $("#<%=ddlpro.ClientID%>").val()}, function (response) {
                var RefData = $.parseJSON(response);
                    if (RefData.length == 0) {
                        showerrormsg("No Data Found..!");
                        // $('#tb_Referal tr').slice(1).remove();
                        $('#tb_grid').hide();
                        return;
                    }
                    else {

                        $('#tb_grid').show();
                        debugger
                        $('#tb_Referal tr').slice(1).remove();
                        var dataLength = RefData.length;
                        for (var i = 0; i < RefData.length; i++) {
                            var mydata = "";
                            if (RefData[i].ProName != "Total ::") {
                                if (i == 0) {
                                    mydata = "<tr id='" + RefData[i].PROID + "' >";
                                    mydata += '<td class="GridViewLabItemStyle" colspan="2" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>' + RefData[i].ProName + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:center"></td>';
                                    mydata += "</tr>";
                                    $('#tb_Referal').append(mydata);

                                    mydata = "<tr id='" + RefData[i].PROID + "'  style='background-color:" + RefData[i].rowColor + ";'>";
                                    //mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].TargetDate + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].Target + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].Achieved + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].AchievedPer + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].AltRef + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].RefNo + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].RefPer + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].NewRefNo + '<b></td>';
                                    mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].sales + '<b></td>';
                                    mydata += "</tr>";
                                    $('#tb_Referal').append(mydata);

                                }
                                else {
                                    if (RefData[i].ProName == RefData[i - 1].ProName) {
                                        mydata = "<tr id='" + RefData[i].PROID + "'  style='background-color:" + RefData[i].rowColor + ";'>";
                                        //mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].TargetDate + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].Target + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].Achieved + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].AchievedPer + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].AltRef + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].RefNo + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].RefPer + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].NewRefNo + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].sales + '<b></td>';
                                        mydata += "</tr>";
                                        $('#tb_Referal').append(mydata);
                                    }
                                    else {
                                        mydata = "<tr id='" + RefData[i].PROID + "' >";
                                        mydata += '<td class="GridViewLabItemStyle" colspan="2" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:left"><b>' + RefData[i].ProName + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" colspan="7" id="tdproname" style="width: 150px;background-color:#4a57b5;color:white; text-align:center"></td>';
                                        mydata += "</tr>";
                                        $('#tb_Referal').append(mydata);
                                        mydata = "<tr id='" + RefData[i].PROID + "'  style='background-color:" + RefData[i].rowColor + ";'>";
                                        //mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].TargetDate + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].Target + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].Achieved + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].AchievedPer + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].AltRef + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].RefNo + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].RefPer + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + RefData[i].NewRefNo + '<b></td>';
                                        mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + RefData[i].sales + '<b></td>';
                                        mydata += "</tr>";
                                        $('#tb_Referal').append(mydata);
                                    }
                                }

                            }
                            else {
                                mydata = "<tr id='" + RefData[i].PROID + "' style='background-color: #e04755;' >";
                                //mydata += '<td colspan="9" class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:left"></td>';
                                mydata += '<td  class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:right"><b>' + RefData[i].ProName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].Target) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].Achieved) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].AchievedPer) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; color:white;text-align:center"><b>' + Math.round(RefData[i].AltRef) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].RefNo) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].RefPer) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].NewRefNo) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:center"><b>' + Math.round(RefData[i].sales) + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Referal').append(mydata);
                            }
                        }
                    }
            });
        }
    </script>
</form>
</body>
</html>

