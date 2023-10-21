<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQAS_Sumarry_Report_ForSingleLabs.aspx.cs" Inherits="Design_Quality_EQAS_Sumarry_Report_ForSingleLabs" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <%: Scripts.Render("~/bundles/JQueryUIJs")  %>
     <%: Scripts.Render("~/bundles/Chosen")      %>
     <%: Scripts.Render("~/bundles/MsAjaxJs")    %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

     <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>

     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

   

      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
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
                          <b>EQAS Summary Report for Single Lab</b>  

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
                        <td style="font-weight: 700">
                            Processing Lab :</td>

                        <td style="width:40%">
                             <asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()" >
                             </asp:DropDownList>
                            

                           

                            <asp:DropDownList ID="ddlprocessinglab"  class="ddlprocessinglab chosen-select chosen-container"  Width="365px" runat="server"></asp:DropDownList></td>

                      
                    <td style=" text-align: right; font-weight: 700;"><%----%>
                        </td>
                    <td style="text-align: left; ">

                            
                        </td>
                
                        
                        </tr>

                    <tr>
                        <td style="font-weight: 700">
                            <strong>From Date :</strong></td>

                        <td style="width:40%">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       
                        &nbsp;&nbsp; <strong>To Date :</strong>

                        <asp:TextBox ID="txtToDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       
                   
                             </td>

                      
                    <td style=" text-align: right; font-weight: 700;">Machine :</td>
                    <td style="text-align: left; ">

                             <asp:DropDownList ID="ddlmachine"  CssClass="ddlmachine chosen-select chosen-container" Width="400px" runat="server"></asp:DropDownList></td>
                
                        
                        </tr>

                    

                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="4">
                           
                        <input type="button" value="Get Report" class="searchbutton" onclick="summaryreport()" />
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
                url: "EQAS_Sumarry_Report_ForSingleLabs.aspx/bindCentre",
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

    </script>



    <script type="text/javascript">

        function summaryreport() {


            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            if (processingcentre == "" || processingcentre == null || processingcentre == "null") {
                showerrormsg("Please Select Processing Lab");
                return;
            }
            $('#tblItems tr').remove();
            $.blockUI();
            $.ajax({
                url: "EQAS_Sumarry_Report_ForSingleLabs.aspx/Getsummaryreport",
                data: '{processingcentre:"' + processingcentre + '",dtFrom:"' + dtFrom + '",dtTo:"' + dtTo + '",machine:"' + $('#<%=ddlmachine.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "-2") {
                        showerrormsg(" Diffrence between From Date and To Date can't greater then 10 Days");
                        $('#tblItems tr').remove();
                        $.unblockUI();
                        return;
                    }
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $('#tblItems tr').remove();
                        $.unblockUI();

                    }
                    else {

                        var mydatahead = '';
                        mydatahead += "<tr>";
                        mydatahead += "<th colspan='9' style='text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>EQAS Summary for " + ItemData[0].Centre + "</th>";
                        mydatahead += "</tr>";
                        mydatahead += "<tr>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Parameter</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Machine</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Result</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Peer Group Mean</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Peer Group SD</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Peer Group LOW Range</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>Peer Group High Range</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>SDI</th>";
                        mydatahead += "<th style='text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;'>EQASStatus</th>";
                        mydatahead += "</tr>";
                        $('#tblItems').append(mydatahead);

                        for (i = 0; i < ItemData.length; i++) {
                            var mydata = '';
                            mydata += "<tr>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Parameter + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].MachineName + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Result + "</th>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Peer_Group_Mean + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Peer_Group_SD + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Peer_Group_LOW_Range + "</td>";
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + ItemData[i].Peer_Group_High_Range + "</td>";

                            var sdi = Math.round((Number(ItemData[i].Result) - Number(ItemData[i].Peer_Group_Mean)) / ItemData[i].Peer_Group_SD, 2);
                            sdi = isNaN(sdi) ? 0:sdi;
                            mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>" + sdi + "</td>";
                           
                            if (Number(sdi) > 2 || Number(sdi) < -2) {
                                mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>Fail</td>";
                            }

                            else {
                                mydata += "<td style='text-align: left;font-size:12px;background-color: #fff;color: #000;padding: 2px;border:1px solid gray;'>Accept</td>";
                            }
                           
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

