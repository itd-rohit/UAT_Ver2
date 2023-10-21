<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SigmaAnalysisReport.aspx.cs" Inherits="Design_Quality_SigmaAnalysisReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
	  <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
         <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Sigma Analysis Report</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
                  </div>
             <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">Year / Month :</td>
                        <td>
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="80px">
                                  <asp:ListItem Value="1">January</asp:ListItem>
                                  <asp:ListItem Value="2">February</asp:ListItem>
                                  <asp:ListItem Value="3">March</asp:ListItem>
                                  <asp:ListItem Value="4">April</asp:ListItem>
                                  <asp:ListItem Value="5">May</asp:ListItem>
                                  <asp:ListItem Value="6">June</asp:ListItem>
                                  <asp:ListItem Value="7">July</asp:ListItem>
                                  <asp:ListItem Value="8">August</asp:ListItem>
                                  <asp:ListItem Value="9">September </asp:ListItem>
                                  <asp:ListItem Value="10">October </asp:ListItem>
                                  <asp:ListItem Value="11">November</asp:ListItem>
                                  <asp:ListItem Value="12">December</asp:ListItem>
                                 


                             </asp:DropDownList>&nbsp;&nbsp;
                                        <asp:DropDownList ID="ddlyear" runat="server" Width="70px">
                                            <asp:ListItem Value="2017">2017</asp:ListItem>
                                            <asp:ListItem Value="2018">2018</asp:ListItem>
                                            <asp:ListItem Value="2019">2019</asp:ListItem>
                                            <asp:ListItem Value="2020">2020</asp:ListItem>
                                            <asp:ListItem Value="2021">2021</asp:ListItem>
                                            <asp:ListItem Value="2022">2022</asp:ListItem>
                                        </asp:DropDownList>
                        </td>
                        <td style="font-weight: 700">Processing Lab :</td>
                        <td><asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()">
                             </asp:DropDownList>
                           
                            <asp:DropDownList ID="ddlprocessinglab"  CssClass="ddlprocessinglab chosen-select chosen-container" Width="365px" runat="server"></asp:DropDownList></td>
                        <td style="font-weight: 700">Machine :</td>
                        <td><asp:DropDownList ID="ddlmachine" runat="server"  Width="303px" class="ddlmachine chosen-select"   ></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="6">
                            <input type="button" value="Get Report" onclick="getreport()" class="searchbutton" />
                             &nbsp;&nbsp;&nbsp;&nbsp;
                              <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()" />
                        </td>
                    </tr>
                    </table>
                </div>
                 </div>

                <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div style="width:99%;overflow:auto;height:370px;" id="mydiv">

            <table id="tblItems"   frame="box"  rules="all" >

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
                $(selector).chosen(config[selector]);
            }




            //bindilclab();



        });

        function bindcentre() {

            var TypeId = $('#<%=ddlcentretype.ClientID%>').val();
            jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            // jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
            if (TypeId == "0") {


                return;

            }

            $.ajax({
                url: "SigmaAnalysisReport.aspx/bindCentre",
                data: '{TypeId: "' + TypeId + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    centreData = $.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                    }
                    $("#<%=ddlprocessinglab.ClientID%>").trigger('chosen:updated');
                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }



        function getreport() {


            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            var month = $('#<%=ddlcurrentmonth.ClientID%>').val();
            var year = $('#<%=ddlyear.ClientID%>').val();
            if (processingcentre == "" || processingcentre == null || processingcentre == "null") {
                showerrormsg("Please Select Processing Lab");
                return;
            }
            $('#tblItems tr').remove();
            $.blockUI();
            $.ajax({
                url: "SigmaAnalysisReport.aspx/Getsummaryreport",
                data: '{processingcentre:"' + processingcentre + '",month:"' + month + '",year:"' + year + '",machine:"' + $('#<%=ddlmachine.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                   
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $('#tblItems tr').remove();
                        $.unblockUI();

                    }
                    else {

                        var mydatahead = '';
                        mydatahead += "<tr>";
                        mydatahead += "<th colspan='9' style='text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>SIGMA ANALYSIS REPORT for " + ItemData[0].centre + " of :" + $('#<%=ddlcurrentmonth.ClientID%> option:selected').text() + " " + year + "</th>";
                        mydatahead += "</tr>";
                        mydatahead += "<tr>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Parameter</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Machine</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Total Allowable Error (CLIA)</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Unit</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Control level</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Current lab CV%</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Bias %</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Total error</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Sigma level (CLIA)</th>";
                        
                        mydatahead += "</tr>";
                        $('#tblItems').append(mydatahead);

                        for (i = 0; i < ItemData.length; i++) {
                            var mydata = '';
                            mydata += "<tr>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].LabObservation_Name + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].MachineName + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].TotalAllowableError + "</th>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'></td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Level + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].CurrentLabCVPer + "</td>";

                            var biasper =Math.round(((ItemData[i].LabMean - ItemData[i].PeerMean) / ItemData[i].PeerMean) * 100,3);
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + biasper + "</td>";
                            var totalerror =Math.round(((1.65 * biasper) + ItemData[i].CurrentLabCVPer),3);
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + totalerror + "</td>";

                            var clia = Math.round(((ItemData[i].TotalAllowableError - biasper) / ItemData[i].CurrentLabCVPer),3);
                            clia = isNaN(clia) ? 0 : clia;
                            if (!isFinite(clia)) {
                                clia = 0;
                            }
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + clia + "</td>";

                          

                            mydata += "</tr>";
                            $('#tblItems').append(mydata);
                        }
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });

        }


        function exporttoexcel() {
            var count = $('#tblItems tr').length;
            if (count == 0 || count == 1) {
                showerrormsg("Please Select Data To Export");
                return;
            }



            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");


            sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=mydiv]').html()));

        }


    </script>
</asp:Content>

