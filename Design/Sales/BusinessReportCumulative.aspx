<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="BusinessReportCumulative.aspx.cs" Inherits="Design_Sales_BusinessReportCumulative" %>

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
                            <b>Business Report Cumulative </b>
                        </td>
                    </tr>
                </table>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="width: 1000px;">
            <div class="content">
                <div class="Purchaseheader">Report Type</div>

                <table>
                    <tr>
                        <td>Report Type :
                        </td>
                        <td>
                            <asp:RadioButtonList ID="rdreporttype" runat="server" RepeatDirection="Horizontal" Style="font-weight: 700">
                                <asp:ListItem Value="Cumulative" Selected="True">Cumulative</asp:ListItem>
                                <asp:ListItem Value="MonthWiseTrend">Month Wise Trend</asp:ListItem>
                                <asp:ListItem Value="DateWiseTrend">Date Wise Trend</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>



                    </tr>
                </table>

            </div>
            <div class="content">
                <div class="Purchaseheader">Date Filter</div>
                <table>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rddate" runat="server" GroupName="a" Text="Date" Checked="true" />

                            &nbsp;&nbsp;

                         <span class="filterdate">From Date :</span>
                            <asp:TextBox ID="txtfromdate" runat="server" Width="110px" class="filterdate" />
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                            &nbsp;&nbsp;
                            <span class="filterdate">To Date :</span>
                            <asp:TextBox ID="txttodate" runat="server" Width="110px" class="filterdate" />
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>

                        </td>

                    </tr>

                    <tr>
                        <td>
                            <asp:RadioButton ID="rdcurrentmonth" runat="server" GroupName="a" Text="Current Month" />


                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rdtoday" runat="server" GroupName="a" Text="Today" />


                        </td>
                    </tr>

                </table>
            </div>

            <div class="content">
                <div class="Purchaseheader">Client Detail</div>

                <table>
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
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Client :
                        </td>
                        <td colspan="3">
                            <asp:ListBox ID="ddlclient" runat="server" Width="600px" CssClass="multiselect" SelectionMode="Multiple" />
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div>


            <div class="content">
                <div class="Purchaseheader">Report Option</div>
                <table>
                    <tr>
                        <td>
                            <asp:RadioButtonList ID="rdgroup" runat="server" onclick="chkCondition()">
                                <asp:ListItem Value="ClientWise" Selected="True">Client Wise</asp:ListItem>
                                <asp:ListItem Value="DepartmentWise">Department Wise</asp:ListItem>
                                <asp:ListItem Value="TestWise">Test Wise</asp:ListItem>
                            </asp:RadioButtonList></td>
                    </tr>


                    <tr class="depttest" style="display: none;">
                        <td>Department :&nbsp;


                               <asp:ListBox ID="ddldepartment" CssClass="multiselect " SelectionMode="Multiple" Width="200px" runat="server" onchange="bindtest()"></asp:ListBox>
                            <span class="test" style="display: none;">&nbsp;&nbsp;&nbsp;Test :&nbsp;

                          

                                 <asp:ListBox ID="ddltest" CssClass="multiselect" SelectionMode="Multiple" Width="440px" runat="server"></asp:ListBox>
                            </span></td>
                    </tr>
                </table>
            </div>


            <div class="content GroupingOption" style="display: none">
                <div class="Purchaseheader">Grouping Option</div>

                <asp:CheckBox ID="chkclientgrouping" runat="server" Text="Client Wise Grouping" />

            </div>

        </div>
        <div class="POuter_Box_Inventory" style="width: 1000px; text-align: center;">
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
            jQuery('#<%=ddlclient.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('#<%=ddldepartment.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('#<%=ddltest.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            bindbusinesszone();
            bindcentretype();
            bindclient();
        });

        $("[id=<%=rdreporttype.ClientID%>] input").on("click", function () {
                      var selectedValue = $(this).val();

                      if (selectedValue == "Cumulative") {

                          $("#<%=rddate.ClientID%>").attr('disabled', false);
                          $("#<%=rddate.ClientID%>").prop('checked', true);
                          $("#<%=rdcurrentmonth.ClientID%>").parent().show();
                          $("#<%=rdtoday.ClientID%>").parent().show();
                      }
                      else if (selectedValue == "MonthWiseTrend") {
                          $("#<%=rddate.ClientID%>").attr('disabled', false);
                          $("#<%=rddate.ClientID%>").prop('checked', true);
                          $("#<%=rdcurrentmonth.ClientID%>").parent().hide();
                          $("#<%=rdtoday.ClientID%>").parent().hide();
                      }
                      else if (selectedValue == "DateWiseTrend") {
                          $("#<%=rddate.ClientID%>").attr('disabled', false);
                          $("#<%=rddate.ClientID%>").prop('checked', true);
                          $("#<%=rdcurrentmonth.ClientID%>").parent().hide();
                          $("#<%=rdtoday.ClientID%>").parent().hide();
                      }


                  });

          $("[id=<%=rdgroup.ClientID%>] input").on("click", function () {
            var selectedValue = $(this).val();

            if (selectedValue == "ClientWise") {
                $('.depttest').hide();
                $('.test').hide();
                $()
                $('#<%=ddldepartment.ClientID%> option').remove();
                          $('#<%=ddldepartment.ClientID%>').append($("<option></option>").val("0").html("ALL"));

                          jQuery('#<%=ddldepartment.ClientID%>').multipleSelect("refresh");

                          $('#<%=ddltest.ClientID%> option').remove();

                          jQuery('#<%=ddltest.ClientID%>').multipleSelect("refresh");
                      }

              if (selectedValue == "DepartmentWise") {
                          $('.depttest').show();


                          binddepartment();
                          $('#<%=ddltest.ClientID%> option').remove();

                          jQuery('#<%=ddltest.ClientID%>').multipleSelect("refresh");
                          $('.test').hide();
                      }
              if (selectedValue == "TestWise") {
                          $('.depttest').show();
                          $('.test').show();
                          binddepartment();
                          bindtest();

                      }
                  });

                  function bindbusinesszone() {
                      $('#<%=ddlbusinessunit.ClientID%> option').remove();
                      jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "BusinessReportCumulative.aspx/bindbusinessUnit",
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
                      jQuery('#<%=ddlclient.ClientID%>').multipleSelect("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "BusinessReportCumulative.aspx/bindclient",
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
                                  jQuery('#<%=ddlclient.ClientID%>').multipleSelect({
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
                      function bindcentretype() {
                          $('#<%=ddlcentretype.ClientID%> option').remove();
                      jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "BusinessReportCumulative.aspx/bindcentertype",
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

                  function binddepartment() {
                      $('#<%=ddldepartment.ClientID%> option').remove();

                      jQuery('#<%=ddldepartment.ClientID%>').multipleSelect("refresh");
                      jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                      $.ajax({
                          url: "BusinessReportCumulative.aspx/binddepartment",
                          data: '{}',
                          type: "POST",
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,
                          dataType: "json",
                          success: function (result) {
                              deptdata = jQuery.parseJSON(result.d);

                              for (var a = 0; a <= deptdata.length - 1; a++) {
                                  jQuery('#<%=ddldepartment.ClientID%>').append($("<option></option>").val(deptdata[a].DisplayName).html(deptdata[a].DisplayName));
                               }
                               jQuery('#<%=ddldepartment.ClientID%>').multipleSelect({
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
                   function bindtest() {
                       $('#<%=ddltest.ClientID%> option').remove();
                      jQuery('#<%=ddltest.ClientID%>').multipleSelect("refresh");
                       if ($("#<%=rdgroup.ClientID%> :checked").val() == "TestWise") {
                          jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                          $.ajax({
                              url: "BusinessReportCumulative.aspx/bindtest",
                              data: '{deptid:"' + $('#<%=ddldepartment.ClientID%>').val() + '"}',
                              type: "POST",
                              contentType: "application/json; charset=utf-8",
                              timeout: 120000,
                              dataType: "json",
                              success: function (result) {
                                  testdata = jQuery.parseJSON(result.d);
                                  for (var a = 0; a <= testdata.length - 1; a++) {
                                      jQuery('#<%=ddltest.ClientID%>').append($("<option></option>").val(testdata[a].ItemID).html(testdata[a].TypeName));
                                  }
                                  jQuery('#<%=ddltest.ClientID%>').multipleSelect({
                                      includeSelectAllOption: true,
                                      filter: true, keepOpen: false
                                  });
                                  $modelUnBlockUI();

                              },
                              error: function (xhr, status) {
                                  $modelUnBlockUI();
                              }
                          });
                      }
                  }




    </script>


    <script type="text/javascript">

        function getreport() {
            var reportype = $("#<%=rdreporttype.ClientID%> :checked").val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();
            var isdate = $("#<%=rddate.ClientID%>").is(':checked') ? 1 : 0;
            var iscurrentmonth = $("#<%=rdcurrentmonth.ClientID%>").is(':checked') ? 1 : 0;
            var istoday = $("#<%=rdtoday.ClientID%>").is(':checked') ? 1 : 0;
            var businessunit = $('#<%=ddlbusinessunit.ClientID%>').val();
            var centretype = $('#<%=ddlcentretype.ClientID%>').val();
            var client = $('#<%=ddlclient.ClientID%>').val();
            if (client == null) {
                client = "";
            }

            var reportoption = $('#<%=rdgroup.ClientID%> :checked').val();
            var department = $('#<%=ddldepartment.ClientID%>').val();
            var test = $('#<%=ddltest.ClientID%>').val();
            var isclientwisegrouping = $("#<%=chkclientgrouping.ClientID%>").is(':checked') ? 1 : 0;
            if (client == "") {
                alert("Please Select Client");
                return;
            }
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            $.ajax({
                url: "BusinessReportCumulative.aspx/GetReport",
                data: '{reportype:"' + reportype + '",isdate:"' + isdate + '",fromdate:"' + fromdate + '",todate:"' + todate + '",iscurrentmonth:"' + iscurrentmonth + '",istoday:"' + istoday + '",businessunit:"' + businessunit + '",centretype:"' + centretype + '",client:"' + client + '",reportoption:"' + reportoption + '",department:"' + department + '",test:"' + test + '",isclientwisegrouping:"' + isclientwisegrouping + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {

                    if (result.d == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else if (result.d == "2") {
                        alert("Month Wise Trend (Not More Than 1 Year");
                    }
                    else if (result.d == "3") {
                        alert("Date Wise Trend (Not More Than 31 Days");
                    }
                    else if (result.d == "0") {
                        alert("No Record Found..!");
                    }
                    $modelUnBlockUI();

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                }
            });


        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            chkCondition();
        });
        function chkCondition() {
            if (jQuery("#rdgroup input[type=radio]:checked").val() == "ClientWise") {
                jQuery(".GroupingOption").hide();
                jQuery("#chkclientgrouping").prop('checked', false);
            }
            else if ($("#rdgroup input[type=radio]:checked").val() == "DepartmentWise") {
                jQuery(".GroupingOption").show();

            }
            else if ($("#rdgroup input[type=radio]:checked").val() == "TestWise") {
                jQuery(".GroupingOption").show();

            }
            jQuery("#chkclientgrouping").prop('checked', false);
        }
    </script>
</asp:Content>
