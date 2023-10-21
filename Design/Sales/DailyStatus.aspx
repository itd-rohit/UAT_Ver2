<%@ Page Title="" Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DailyStatus.aspx.cs" Inherits="Design_SalesDiagnostic_DailyStatus" %>

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
    
   
    <div id="Pbody_box_inventory">
         <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Daily Status</div>
            <div style="text-align: center">
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
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
                     <input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Summary();"  />&nbsp;&nbsp;&nbsp;                           
                        
                </div>
                 <div class="col-md-3">
                       <img src="../../../App_Images/excelexport.gif" alt="Export" onclick="ExportExcelFromTable()" style="width: 34px; height: 30px;" />
                 </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="tb_grid" style="text-align: center; overflow-y: auto; max-height: 500px;">
            <div class="content">
                <div style="text-align: left; color: #c11734">
                    <b>
                        <asp:Label ID="lblProname" runat="server"></asp:Label></b>
                </div>
                <table style="width: 99%; border-collapse: collapse;" id="tb_Status" class="GridViewStyle">
                    <tr id="header">
                         <td class="GridViewHeaderStyle" style="width:50px">Sr.No.</td>
                        <td class="GridViewHeaderStyle" style="width: 300px;">Executives</td>
                        <td class="GridViewHeaderStyle" style="width: 150px">Date</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">Daily Target</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">Achieved</td>
                        <td class="GridViewHeaderStyle" style="width: 80px">Achieved(%)</td>
                        <td class="GridViewHeaderStyle" style="width: 80px">Short</td>
                        <td class="GridViewHeaderStyle" style="width: 80px">Short %</td>
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
        function Summary() {
            serverCall('DailyStatus.aspx/BindDailyStatus', { Pro: $("#<%=ddlpro.ClientID%>").val(), Date: $("#<%=txtFrom.ClientID %>").val() }, function (response) {
                var ProData = $.parseJSON(response);
                    if (ProData.length > 0) { 
                        $('#tb_grid').show();
                        $('#tb_Status tr').slice(1).remove();
                        var dataLength = ProData.length;
                         
                        for (var i = 0; i < dataLength; i++) {
                            if (ProData[i].Total != "Total ::") {
                                debugger;
                                var mydata = "";
                                mydata = "<tr id='" + ProData[i].PROID + "'  style='background-color:" + ProData[i].rowColor + ";'>";
                                mydata += "<td class='GridViewLabItemStyle' ><b>" + parseInt(i + 1) + "<b></td>";
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].ProName + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].MonthYear + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].Target + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Achieved + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px; text-align:center"><b>' + ProData[i].AchievedPer + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].Short + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px; text-align:center"><b>' + ProData[i].ShortPer + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            } else {
                                var mydata = "";
                                mydata = "<tr id='" + ProData[i].PROID + "'  style='background-color: #e04755;'>";
                                mydata += '<td  class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;" colspan="3"><b>' + ProData[i].Total + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].Target + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].Achieved + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdpro1n" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].AchievedPer + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].Short + '<b></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="tdproname" style="width: 150px;color:white; text-align:centre;"><b>' + ProData[i].ShortPer + '<b></td>';
                                mydata += "</tr>";
                                $('#tb_Status').append(mydata);
                            }
                            $('#<%=lblProname.ClientID%>').text($("#<%=ddlpro.ClientID%> :selected").text()); 
                        }

                    } else {
                         showerrormsg('No Record Found. Please Set Target of This User.');
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
    </script>
</form>
</body>
</html>

