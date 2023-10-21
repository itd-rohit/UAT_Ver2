<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="GrowthReport.aspx.cs" Inherits="Design_SalesDiagnostic_GrowthReport" %>

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
    <script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script> 
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
    <div id="Pbody_box_inventory">
          <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="text-align:center">Growth Report</div>
            <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>

            <div class="row">
                  <div class="col-md-2"> <label class="pull-right">Executives :</label></div>
                <div class="col-md-3"> <asp:DropDownList ID="ddlpro" runat="server" CssClass="chosen-select" ClientIDMode="Static"></asp:DropDownList></div>
                <div class="col-md-2"> <label class="pull-right">Previous From :</label></div>
                <div class="col-md-2"><asp:TextBox ID="PtxtFrom" runat="server"  ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="PtxtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender> </div>
                <div class="col-md-2"> <label class="pull-right">To :</label></div>
                 <div class="col-md-2"><asp:TextBox ID="PtxtTo" runat="server"  ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="PtxtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                <div class="col-md-2"> <label class="pull-right">From :</label></div>
               <div class="col-md-2">   <asp:TextBox ID="txtFrom" runat="server"  ReadOnly="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                   </div>
                <div class="col-md-2"> <label class="pull-right">To :</label></div>
               <div class="col-md-2"> <asp:TextBox ID="txtTo" runat="server" ReadOnly="true" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                <div class="col-md-3"><input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Search();" style="margin-left: 30px;" />&nbsp;&nbsp;&nbsp;                           
                            <img src="../../../App_Images/excelexport.gif" alt="Export" onclick="ExcelReport()" style="width: 34px; height: 30px;vertical-align:middle" /></div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center; overflow-y: auto; max-height: 500px;">
            <div class="row">
                <div class="col-md-24">
                <div style="text-align: right; padding-right: 18px;">
                    <b><span id="spnTotal"></span></b>
                </div>
                <table style="width: 99%; border-collapse: collapse;" id="tb_Referring" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width: 250px; text-align: left">Name</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Previous Sales</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Current Sales</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">(Previous Sales -Current Sales)</td>
                        <td class="GridViewHeaderStyle" style="width: 150px; text-align: center">Growth (%)</td>
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
            var type = "Franchise";
            serverCall('GrowthReport.aspx/GrowthReportExcel', { FromDate: $("#<%=txtFrom.ClientID %>").val(), ToDate: $("#<%=txtTo.ClientID %>").val(),pro:pro,PFromDate:$("#<%=PtxtFrom.ClientID %>").val(),PToDate:$("#<%=PtxtTo.ClientID %>").val(),type:type }, function (response) {
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
            var pro = $("#<%=ddlpro.ClientID %>").val();
            var type = "Franchise";
            serverCall('GrowthReport.aspx/GrowthReport', { FromDate: $("#<%=txtFrom.ClientID %>").val(), ToDate: $("#<%=txtTo.ClientID %>").val(),pro:pro,PFromDate:$("#<%=PtxtFrom.ClientID %>").val(),PToDate:$("#<%=PtxtTo.ClientID %>").val(),type:type }, function (response) {
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
                            if (ProData[i].PROName == "Total ::") {
                                mydata = "<tr style='background-color:#e04755;'>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 250px;background-color:red;color:white; text-align:left"><b>' + ProData[i].PROName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;background-color:red;color:white; text-align:center"><b>' + ProData[i].Last_Sale + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;background-color:red;color:white; text-align:center"><b>' + ProData[i].Curr_Sale + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;background-color:red;color:white; text-align:center"><b>' + ProData[i].diff + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;background-color:red;color:white; text-align:center"><b>' + ProData[i].SalePer + '<b></td>';
                                mydata += "</tr>";
                                $('#spnTotal').text("Total Sale : " + ProData[i].TotalSale);
                                $('#tb_Referring').append(mydata);
                            } else {
                                mydata = "<tr  style='background-color:" + ProData[i].rowColor + ";'>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 250px; text-align:left"><b>' + ProData[i].PROName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Last_Sale + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].Curr_Sale + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].diff + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].SalePer + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Referring').append(mydata);
                            }

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

