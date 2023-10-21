<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GetAllReport.aspx.cs" Inherits="Design_Lab_GetAllReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
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
                          <b>DownLoad Camp Patient Report</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
              <div class="content">
                <div class="Purchaseheader">Panel Details</div>
                  <table width="100%">
                      <tr>
                          <td style="font-weight: 700">From Date :</td>
                          <td>
                               <asp:TextBox ID="txtentrydatefrom" runat="server" Width="110px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                           &nbsp;<strong>To Date:</strong> <asp:TextBox ID="txtentrydateto" runat="server" Width="110px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="txtentrydate0_CalendarExtender0" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>&nbsp;&nbsp; 
                              Report Path: <asp:Label ID="lb" runat="server" Font-Bold="true"></asp:Label>
                          </td>
                      </tr>
                      <tr>
                          <td style="font-weight: 700">Panel Name :</td>
                          <td>
                              <asp:DropDownList ID="ddlpanel" runat="server" Width="400px" class="ddlpanel chosen-select chosen-container"></asp:DropDownList>
                          &nbsp;&nbsp;

                              <input type="button" value="Search" class="searchbutton" onclick="searchme()" />

                              &nbsp;&nbsp;

                               <input type="button" value="Get Data" id="btn" style="display:none;" class="savebutton" onclick="saveme()" />

                          </td>
                      </tr>
                  </table>
                  </div>
              </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
               <div style="max-height:400px;overflow:auto;">
                 <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">Centre</td>
                                        <td class="GridViewHeaderStyle">Panel</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Booking Date</td>
                                        <td class="GridViewHeaderStyle"  style="width: 100px;">Visit ID</td>
                                        <td class="GridViewHeaderStyle"  style="width: 120px;">UHID</td>
                                        <td class="GridViewHeaderStyle">Patient Name</td>
                                         <td class="GridViewHeaderStyle">Test Name</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;"><input type="checkbox" id="chheader" class="mmc" onclick="checkall(this)" /></td>
                                        
                                     </tr>
                                 </table></div>
               </div>
                </div>
              
      </div>



    <script type="text/javascript">

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

        $(document).ready(function () {


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


        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(ctr).is(":checked")) {

                        $(this).find('#chk').attr('checked', true);
                    }
                    else {
                        $(this).find('#chk').attr('checked', false);
                    }


                }
            });
        }
        function searchme() {

            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                showerrormsg("Please Select Panel");

                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }

            $('#tblitemlist tr').slice(1).remove();
            $modelBlockUI();
            jQuery.ajax({
                url: "getallreport.aspx/SearchRecords",
                data: '{panelid:"' + $('#<%=ddlpanel.ClientID%>').val() + '",fromdate:"' + $('#<%=txtentrydatefrom.ClientID%>').val() + '",todate:"' + $('#<%=txtentrydateto.ClientID%>').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        $('#btn').hide();
                        showerrormsg("No data Found Within Selected Searching Criteria");
                        $modelUnBlockUI();
                        $('#<%=ddlpanel.ClientID%>').focus();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:palegreen;' id='" + ItemData[i].LedgerTransactionID + "'>";
                           
                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";
                            mydata += '<td class="GridViewLabItemStyle"  id="tdcentre">' + ItemData[i].centre + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpanelname">' + ItemData[i].panelname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdbookingdate">' + ItemData[i].bookingdate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdvisitid">' + ItemData[i].LedgerTransactionno + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tduhid">' + ItemData[i].patient_id + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpname">' + ItemData[i].pname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdtestname">' + ItemData[i].Testname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" id="chk" class="mmc" /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"  id="tdlabid">' + ItemData[i].LedgerTransactionID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"  id="tdtestid" >' + ItemData[i].testid + '</td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                            $('#btn').show();
                        }
                        $modelUnBlockUI();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    $modelUnBlockUI();
                }
            });
        }

        function saveme() {
            var testid = "";
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(this).find("#chk").is(":checked")) {

                        testid += $(this).find('#tdlabid').text() + ",";
                    }



                }
            });
            if (testid == "") {

                showerrormsg("Please Select Data");
                return;
            }
            $modelBlockUI();
            jQuery.ajax({
                url: "getallreport.aspx/ExportData",
                data: '{labid:"' + testid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                  
                    if (result.d == "1") {
                        showmsg("Data Exported Sucessfully");

                        $('.mmc').prop('checked', false);
                    }
                    else {
                        showerrormsg(result.d);
                    }
                    $modelUnBlockUI();

                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    $modelUnBlockUI();
                }
            });


        }
    </script>
</asp:Content>

