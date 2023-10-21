<%@ Page Title="" Language="C#"  ClientIDMode="Static" AutoEventWireup="true" CodeFile="ReferringLess1000.aspx.cs" Inherits="Design_SalesDiagnostic_ReferringLess1000" %>

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
    <Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
    </Ajax:ScriptManager>
    
    <div id="Pbody_box_inventory"> 
        <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Business less than 1000</div>
            <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>

            <div class="row">
                <div class="col-md-3"> <label class="pull-right">From Date :</label></div>
                    <div class="col-md-3">
                     <asp:TextBox ID="txtFrom" runat="server"  ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                 <div class="col-md-3"><label class="pull-right">To Date :</label></div>
                     <div class="col-md-3">
                     <asp:TextBox ID="txtTo" runat="server"  ReadOnly="true" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                 </div>
                 <div class="col-md-3"><label class="pull-right">Executives :</label></div>
                     <div class="col-md-3">
                      <asp:DropDownList ID="ddlpro" runat="server" CssClass="chosen-select"  ClientIDMode="Static"></asp:DropDownList>
                 </div>
                <div class="col-md-3">
                     <input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Search();"  />&nbsp;&nbsp;&nbsp;                           
                        
                </div>
                 <div class="col-md-3">
                       <img src="../../../App_Images/excelexport.gif" alt="Export" onclick="ExcelReport()" style="width: 34px; height: 30px;" />
                 </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center;  overflow-y: auto; max-height: 500px;">
            <div class="row">
                <div class="col-md-24">
                <table style="width: 99%; border-collapse: collapse;" id="tb_Referring" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Sr No</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Sales Manager</td>
                        <td class="GridViewHeaderStyle" style="width: 250px; text-align: left">Name Of Client</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Business Unit</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Client Type</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Mobile</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Email ID</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Contact Person</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">LwD</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Work(Avg.)</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Last Visit Date</td>
                    </tr>
                </table>
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
        });
        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tb_Referring'); // id of table

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
            serverCall('ReferringLess1000.aspx/ReferringLessExcel', { ToDate: $("#<%=txtTo.ClientID %>").val(), FromDate: $("#<%=txtFrom.ClientID %>").val(), pro: pro }, function (response) {
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
		

        function Search() 
		{
            var pro = $("#<%=ddlpro.ClientID %>").val();
            serverCall('ReferringLess1000.aspx/ReferringLess', { ToDate: $("#<%=txtTo.ClientID %>").val(), FromDate: $("#<%=txtFrom.ClientID %>").val(), pro: pro }, function (response) {
                    debugger;
                    var ProData = $.parseJSON(response);
                    var totalP = 0;
                    var totalT = 0;
                    var Parties = 0;
                    var Patient = 0;
                    if (ProData.length > 0) {
                        $("#tb_grid").show();
                        $('#tb_Referring tr').slice(1).remove();
                        var dataLength = ProData.length;

                        for (var i = 0; i < ProData.length; i++) {
                            mydata = "<tr id='" + ProData[i].Panel_ID + "'  style='background-color:white;'>";
                            mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 250px; text-align:left"><b>' + ProData[i].SalesManager + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Client + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 250px; text-align:left"><b>' + ProData[i].BusinessUnit + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 250px; text-align:left"><b>' + ProData[i].PanelGroup + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].Mobile + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].EmailID + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].Contact_Person + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].LwD + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].AverageAmt + '<b></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Amount + '<b></td>';
                            mydata += "</tr>";
                            $('#tb_Referring').append(mydata);
                        }

                    }
                    else {
                        showerrormsg('No Record Found');
                        $("#tb_grid").hide();
                       
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
</form>
</body>
</html>


