<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SummaryReportOfILC.aspx.cs" Inherits="Design_Quality_SummaryReportOfILC" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
     <%:Scripts.Render("~/bundles/JQueryUIJs") %>
     <%:Scripts.Render("~/bundles/Chosen") %>
     <%:Scripts.Render("~/bundles/MsAjaxJs") %>
     <%:Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
	  <script src="http://malsup.github.io/jquery.blockUI.js"></script>
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
                          <b>Summary Report of ILC</b>  

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
                            Processing Lab :
                        </td>

                        <td style="width:40%">
                             <asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()">
                             </asp:DropDownList>
                            

                           

                            <asp:DropDownList ID="ddlprocessinglab"  CssClass="ddlprocessinglab chosen-select chosen-container" Width="365px" runat="server"></asp:DropDownList>
                        </td>

                      
                    <td style=" text-align: right; font-weight: 700;">From Date :&nbsp;</td>
                    <td style="text-align: left; width: 20%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       
                    </td>
                    <td style=" text-align: right; font-weight: 700;">To Date :&nbsp;</td>
                    <td style="text-align: left; ">
                        <asp:TextBox ID="txtToDate" runat="server" Width="152px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       
                   
                    </td>
                
                        
                        </tr>

                    <tr>
                        <td style="font-weight: 700">
                            Status :</td>

                        <td style="width:40%">
                        <asp:DropDownList ID="ddlstatus" runat="server">
                              <asp:ListItem Value=""></asp:ListItem>
                            <asp:ListItem Value="Accept">Accept</asp:ListItem>
                             <asp:ListItem Value="Fail">Fail</asp:ListItem>
                        </asp:DropDownList>    
                        </td>

                      
                    <td style=" text-align: right; font-weight: 700;">&nbsp;</td>
                    <td style="text-align: left; width: 20%;">

                        &nbsp;</td>
                    <td style=" text-align: right; font-weight: 700;">&nbsp;</td>
                    <td style="text-align: left; ">
                        &nbsp;</td>
                
                        
                        </tr>

                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="4">
                           
                        <input type="button" value="Get Report" class="searchbutton" onclick="summaryreport()" />
                            &nbsp;&nbsp;&nbsp;&nbsp;
                        </td>

                        
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
                url: "SummaryReportOfILC.aspx/bindCentre",
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
            $.blockUI();
            $.ajax({
                url: "SummaryReportOfILC.aspx/Getsummaryreport",
                data: '{processingcentre:"' + processingcentre + '",dtFrom:"' + dtFrom + '",dtTo:"' + dtTo + '",status:"'+$('#<%=ddlstatus.ClientID%>').val()+'"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {

                        var ua = window.navigator.userAgent;
                        var msie = ua.indexOf("MSIE ");


                        sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(ItemData));




                        $.unblockUI();
                        return (sa);
                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });

        }
    </script>
</asp:Content>






