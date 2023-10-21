<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQASProgramReport.aspx.cs" Inherits="Design_Quality_EQASProgramReport" %>

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
    <style>
    #showData th {
    background-color: #09f;
    color: #fff;
    padding: 2px;
    text-align:left;
    font-size:12px;
    }
     #showData td {
    background-color: #fff;
    color: #000;
    padding: 2px;
   
 text-align:left;
font-size:12px;
    }
</style>
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
                          <b>EQAS Comparison Report</b>  

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
                            EQAS Provider :
                        </td>

                        <td>
                            <asp:DropDownList ID="ddleqasprovider" runat="server" class="ddleqasprovider chosen-select chosen-container" Width="300px" onchange="bindprogram()"></asp:DropDownList>
                        </td>

                        <td style="font-weight: 700">
                            EQAS Program :
                        </td>

                        <td>
                            <asp:DropDownList ID="ddleqasprogram" runat="server" class="ddleqasprogram chosen-select chosen-container" Width="300px"></asp:DropDownList>
                        </td>

                       <td style="font-weight: 700">
                            Month/Year :
                        </td>
                        <td>
                             <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px">
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
                                        <asp:DropDownList ID="ddlyear" runat="server" Width="100px">
                                            <asp:ListItem Value="2017">2017</asp:ListItem>
                                            <asp:ListItem Value="2018">2018</asp:ListItem>
                                            <asp:ListItem Value="2019">2019</asp:ListItem>
                                            <asp:ListItem Value="2020">2020</asp:ListItem>
                                            <asp:ListItem Value="2021">2021</asp:ListItem>
                                            <asp:ListItem Value="2022">2022</asp:ListItem>
                                        </asp:DropDownList>
                        </td>
                        </tr>

                    <tr>
                        <td colspan="6" style="font-weight: 700; text-align: center">
                        <input type="button" value="Search" class="searchbutton" onclick="getdata()" /> 
                            &nbsp;  &nbsp;  &nbsp;  &nbsp;
                            <input type="button" value="Export To Excel" onclick="getdataexcel()"  class="searchbutton" />   
                        </td>

                        </tr>
                        </table>
                </div>
               </div>


          <div class="POuter_Box_Inventory" style="width:1300px;" id="tblViewReportData">
            <div class="content">
                  <div id="showData" >
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
         });


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



         function bindprogram() {
            

             var eqasproid = $('#<%=ddleqasprovider.ClientID%>').val();
             jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
             jQuery('#<%=ddleqasprogram.ClientID%>').trigger('chosen:updated');
             if (eqasproid == "0") {


                 return;

             }
             $.blockUI();
             $.ajax({
                 url: "EQASProgramReport.aspx/bindprogram",
                 data: '{eqasproid: "' + eqasproid + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,

                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery("<option></option>").val("0").html("Select EQAS Program"));
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery("<option></option>").val(centreData[i].programid).html(centreData[i].programname));
                     }
                     jQuery('#<%=ddleqasprogram.ClientID%>').trigger('chosen:updated');
                     $.unblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     $.unblockUI();
                 }
             });
         }

             </script>

    <script type="text/javascript">

        function getdata() {

            $('#tbl tr').remove();

            var programid = $('#<%=ddleqasprogram.ClientID%>').val();
          
            if (programid == "0" || programid == "null" || programid == null) {
                showerrormsg("Please Select Program");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "EQASProgramReport.aspx/getdata",
                data: '{programid: "' + programid + '",EntryMonth:"' + $('#<%=ddlcurrentmonth.ClientID%>').val() + '",EntryYear:"' + $('#<%=ddlyear.ClientID%>').val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    

                    var data = $.parseJSON(result.d);
                    if (data.length > 0) {

                        $('#tblViewReportData').show();
                        $('[id$=lblErr]').text('');

                        var myData = $.parseJSON(result.d);
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

                        var divContainer = document.getElementById("showData");
                        divContainer.innerHTML = "";
                        divContainer.appendChild(table);
                        $('#showData').find('table').attr('id', 'tblItems');

                    }
                    else {
                       showerrormsg('No Record Found');
                        $('#tblViewReportData').hide();
                    }

                     $.unblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     $.unblockUI();
                 }
             });
        }




        function getdataexcel() {
            var programid = $('#<%=ddleqasprogram.ClientID%>').val();

            if (programid == "0" || programid == "null" || programid == null) {
                showerrormsg("Please Select Program");
                return;
            }
            $.blockUI();
            $.ajax({
                url: "EQASProgramReport.aspx/getdataexcel",
                data: '{programid: "' + programid + '",EntryMonth:"' + $('#<%=ddlcurrentmonth.ClientID%>').val() + '",EntryYear:"' + $('#<%=ddlyear.ClientID%>').val() + '"}',
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
                        window.open('../common/ExportToExcel.aspx');
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }
    </script>
</asp:Content>

