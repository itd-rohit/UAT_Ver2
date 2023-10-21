<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="AgeingReport_Cash.aspx.cs" Inherits="Design_Sales_AgeingReport_Cash" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
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
    . 
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .ajax__calendar .ajax__calendar_container {
            z-index: 9999;
        }
    </style>
    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center">Sales Executive vs Ageing
            </div>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <div class="row">
                 <div class="col-md-3"> <label class="pull-right">Sales Manager :</label></div>
                <div class="col-md-3"><asp:DropDownList ID="ddlpro" runat="server" ClientIDMode="Static" CssClass="chosen-select"></asp:DropDownList></div>
                <div class="col-md-3"></div>
                <div class="col-md-3"> <input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Search();" style="width: 100px;" /></div>
                <div class="col-md-3"> <img src="../../../App_Images/excelexport.gif" alt="Export" onclick="ExcelReport()" style="width: 34px; height: 30px;" /></div>
            </div> 
            </div>
        
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center;  overflow-y: auto; max-height: 500px;">
            <div class="content">

                <table style="width: 99%; border-collapse: collapse;" id="tb_Tat" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width: 150px">Executive Name</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; display: none">Under Credit Period</td>
                        <td class="GridViewHeaderStyle" id="tdDoctor" style="width: 150px">Over Due<=30 Days</td>
                        <td class="GridViewHeaderStyle" id="tdCentre" style="width: 150px">Over Due 30 &<=180 Days</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Over Due > 180 Days</td>
                        <td class="GridViewHeaderStyle" style="width: 100px">Total O/S</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Total Received</td>
                        <%--<td class="GridViewHeaderStyle" style="width: 100px">Balance</td>--%>
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
        });
		
		
		
		 function ExcelReport() 
		 {
          
              serverCall('AgeingReport_Cash.aspx/SearchExcel', { pro: $("#<%=ddlpro.ClientID%>").val()}, function (response) {
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
		
		
		
        function Search() {
            var sumofPro = 0;
            serverCall('AgeingReport_Cash.aspx/Search', { pro: $("#<%=ddlpro.ClientID%>").val()}, function (response) {
                var ProData = $.parseJSON(response);
                    if (ProData == 0) {
                        showerrormsg("No Record Found");
                        $('#tb_grid').hide();
                       
                    }
                    else {
                        $('#<%=lblMsg.ClientID%>').text('');
                        $('#tb_grid').show();
                        $('#tb_Tat tr').slice(1).remove(); 
                        for (var i = 0; i < ProData.length; i++)
                        { 
                            if (ProData[i].ProName != "Total ::") {
                                var mydata = "";
                                mydata = "<tr id='" + ProData[i].PROID + "'  style='background-color:white;'>";
                                mydata += '<td class="GridViewLabItemStyle" id="TdExecutive1" style="width: 300px; text-align:left"><a href="AgeingReport_Cash_Detail.aspx?SalesManagerID=' + ProData[i].PROID + '" target="_blank" alt="" ><b>' + ProData[i].ProName + '<b></a></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdover30" style="width: 150px; text-align:center"><b>' + precise_round(ProData[i].Days30,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdover30and180" style="width: 50px; text-align:center"><b>' + precise_round(ProData[i].Less180,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdover180" style="width: 150px; text-align:center"><b>' + precise_round(ProData[i].More180,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdTotalOutStanding" style="width: 50px; text-align:center"><b>' + precise_round(ProData[i].TotalOutStanding,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdover180" style="width: 150px; text-align:center"><b>' + precise_round(ProData[i].TotalReceived,2) + '<b></td>';
                                $('#tb_Tat').append(mydata);
                            } else {
                                var mydata = "";
                                mydata = "<tr id='" + ProData[i].PROID + "'  style='background-color: #e04755;'>";
                                mydata += '<td  class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].ProName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:centre;"><b>' + precise_round(ProData[i].Days30,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + precise_round(ProData[i].Less180,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:centre;"><b>' + precise_round(ProData[i].More180,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + precise_round(ProData[i].TotalOutStanding,2) + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + precise_round(ProData[i].TotalReceived,2) + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Tat').append(mydata);
                            }
                        }
                    }
            });
        }

        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tb_Tat'); // id of table

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
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
    </script>
</form>
</body>
</html>
