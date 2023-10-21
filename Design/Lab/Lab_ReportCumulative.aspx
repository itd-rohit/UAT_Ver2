<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="Lab_ReportCumulative.aspx.cs" Inherits="Design_Sales_BusinessReportCumulative" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width: 1004px;">

        <div class="POuter_Box_Inventory" style="width: 1000px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Lab Report Cumulative </b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" style="font-weight:bold;color:red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="width: 1000px;">

            <div class="content">
                <div class="Purchaseheader">Report Filter</div>
                <table>
                    <tr>
                        <td>
                            <span class="filterdate">From Date :</span>
                        </td>
                        <td>


                            <asp:TextBox ID="txtfromdate" runat="server" Width="110px" class="filterdate" />
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                         
                        </td>
                        <td>
                            <span class="filterdate">To Date :</span>
                        </td>
                        <td>
                            <asp:TextBox ID="txttodate" runat="server" Width="110px" class="filterdate" />
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </td>

                    </tr>
                    <tr>
                        <td>Tag Business Unit:</td>
                        <td>
                            <asp:ListBox ID="ddlbusinessunit" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="400px" onchange="bindclient()"></asp:ListBox>
                        </td>
                        <td>Centre Type:
                        </td>
                        <td>
                            <asp:ListBox ID="ddlcentretype" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="200px" onchange="bindclient()"></asp:ListBox>
                        </td>

                    </tr>
                    <tr>
                        <td>Client :
                        </td>
                        <td colspan="3">
                            <asp:ListBox ID="ddlclient" runat="server" Width="600px" class="chosen-select"  />
                        </td>

                    </tr>

                </table>
            </div>


        </div>
         <div class="POuter_Box_Inventory" style="width: 1000px; text-align: center;">
             <div class="content">
                 <table id="tblPatientData" style="width:100%;display:none;"   class="GridViewStyle">
                     <tr>
                         <th  class="GridViewHeaderStyle" width="10px" style="text-align: center;">SNo.</th>
                         <th  class="GridViewHeaderStyle" width="100px" style="text-align: center;">Visit No</th>
                         <th  class="GridViewHeaderStyle" width="100px" style="text-align: center;">PatientName</th>
                         <th  class="GridViewHeaderStyle" width="60px" style="text-align: center;">Age</th>
                         <th  class="GridViewHeaderStyle" width="250px" style="text-align: center;">Test</th>
                         <th  class="GridViewHeaderStyle" width="10px" style="text-align: center;"><input type="checkbox" id="chkAll" onchange="CheckAll();" /> </th>
                     </tr>
                 </table>
             </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1000px; text-align: center;">
              <input type="button" value="Search" class="searchbutton" onclick="Search()" />
            <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
        </div>
    </div>


    <script type="text/javascript">


        $(function () {
            jQuery('#<%=ddlbusinessunit.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
         
          
            bindbusinesszone();
            bindcentretype();
            bindclient();
        });

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

      
          function bindbusinesszone() {
              $('#<%=ddlbusinessunit.ClientID%> option').remove();
                      jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "Lab_ReportCumulative.aspx/bindbusinessUnit",
                          data: '{}',
                          type: "POST",
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,
                          dataType: "json",

                          success: function (result) {
                              zonedata = jQuery.parseJSON(result.d);

                              for (var a = 0; a <= zonedata.length - 1; a++) {
                                  jQuery('#<%=ddlbusinessunit.ClientID%>').append($("<option></option>").val(zonedata[a].Centreid).html(zonedata[a].centre));
                              }
                              jQuery('#<%=ddlbusinessunit.ClientID%>').multipleSelect({
                                  includeSelectAllOption: true,
                                  filter: true, keepOpen: false
                              });
                              $modelUnBlockUI();
                          },
                          error: function (xhr, status) {
                              alert(xhr.responseText);
                              $modelUnBlockUI();
                          }
                      });
                  }

                  function bindclient() {
                      jQuery('#<%=ddlclient.ClientID%> option').remove();
                      jQuery('#<%=ddlclient.ClientID%>').chosen("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "Lab_ReportCumulative.aspx/bindclient",
                          data: '{Businessunit:"' + jQuery('#<%=ddlbusinessunit.ClientID%>').val() + '",type:"' + jQuery('#<%=ddlcentretype.ClientID%>').val() + '"}',
                          type: "POST",
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,
                          dataType: "json",
                          success: function (result) {
                              clientdata = jQuery.parseJSON(result.d);
                              for (var a = 0; a <= clientdata.length - 1; a++) {
                                  jQuery('#<%=ddlclient.ClientID%>').append($("<option></option>").val(clientdata[a].panel_ID).html(clientdata[a].PanelName));
                                  }
                              jQuery('#<%=ddlclient.ClientID%>').trigger('chosen:updated');
                                  $modelUnBlockUI();
                              },
                          error: function (xhr, status) {
                              alert(xhr.responseText);
                              $modelUnBlockUI();
                          }
                      });

                      }
                      function bindcentretype() {
                          $('#<%=ddlcentretype.ClientID%> option').remove();
                          jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect("refresh");
                          jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                          $.ajax({
                              url: "Lab_ReportCumulative.aspx/bindcentertype",
                              data: '{}',
                              type: "POST",
                              contentType: "application/json; charset=utf-8",
                              timeout: 120000,
                              dataType: "json",
                              success: function (result) {
                                  typedata = jQuery.parseJSON(result.d);
                                  for (var a = 0; a <= typedata.length - 1; a++) {
                                      jQuery('#<%=ddlcentretype.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                              }
                              jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect({
                                  includeSelectAllOption: true,
                                  filter: true, keepOpen: false
                              });
                              $modelUnBlockUI();
                          },
                          error: function (xhr, status) {
                              alert(xhr.responseText);
                              $modelUnBlockUI();
                          }
                      });
                  }

                  




    </script>


    <script type="text/javascript">
        function Search()
        {
            $('#tblPatientData').find('tr').slice(1).remove();
            var PanelId = $('[id$=ddlclient]').val().toString();
            $('[id$=lblErr]').text('');

            if (PanelId != "0");
            $.ajax({
                url: "Lab_ReportCumulative.aspx/Search",
                async: false,
                data: JSON.stringify({ PanelId: PanelId, FromDate: $('#<%=txtfromdate.ClientID%>').val(), ToDate: $('#<%=txttodate.ClientID%>').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = $.parseJSON(result.d)
                    if (data.length > 0) {
                        var html = '';
                        for (var i = 0; i < data.length; i++) {
                            html += '<tr>';
                            html += '<td  class="GridViewLabItemStyle" >' + (i + 1) + '<input type="hidden" id="hdnLedgertransactionID" value="' + data[i].LedgertransactionID + '"></td>';
                            html += '<td id="tdLedgertransactionNo"  class="GridViewLabItemStyle" >' + data[i].LedgerTransactionNo + '</td>';
                            html += '<td  class="GridViewLabItemStyle" style="text-align:left;" >' + data[i].PName + '</td>';
                            html += '<td class="GridViewLabItemStyle" >' + data[i].Age + '</td>';
                            html += '<td class="GridViewLabItemStyle" style="text-align:left;" >' + data[i].Tests + '</td>';
                            html += '<td class="GridViewLabItemStyle" ><input type="checkbox" /></td>';
                            html += '</tr>';
                        }
                        
                        $('#tblPatientData').append(html);
                        $('#tblPatientData').show();
                    } else {
                        $('[id$=lblErr]').text('No Record Found');
                        $('#tblPatientData').hide();
                    }
                }
            });



        }


        function getreport()
        {
            var IsValid = false;
            var LedgertransactionID = "";
            $('#tblPatientData').find('tr').each(function (index) {
                if (index > 0)
                {
                    if($(this).find('input[type=checkbox]').is(':checked'))
                    {
                        LedgertransactionID += "'" + $(this).find('#hdnLedgertransactionID').val() + "',";
                        IsValid = true;
                    }

                }
            });
            if (IsValid) {
                LedgertransactionID = LedgertransactionID.substring(0, LedgertransactionID.length - 1);
                $.ajax({
                    url: "Lab_ReportCumulative.aspx/GetReport",
                    async: false,
                    data: JSON.stringify({ LedgerTransactionID: LedgertransactionID }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        window.open('../Common/LabCumulativeReportExportToExcel.aspx');
                    }
                });
            }
            else {
                alert('Please select atleast one record');
            }

        }
       
        function CheckAll()
        {
            $('#tblPatientData').find('tr').each(function (index) {
                if (index > 0) {
                    if ($('#chkAll').is(':checked')) {
                        $(this).find('input[type=checkbox]').prop('checked', true);
                    }
                    else {
                        $(this).find('input[type=checkbox]').prop('checked', false);
                    }

                }
            });
        }
    
       
    </script>
</asp:Content>
