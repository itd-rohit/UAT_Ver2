<%@ Page Language="C#"  ClientIDMode="Static" AutoEventWireup="true" CodeFile="BusinessReportCumulative.aspx.cs" Inherits="Design_Reports_BusinessReport_BusinessReportCumulative" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 
    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
  <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">
                <div class="col-md-24"> <b>Business Report Cumulative </b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divcentre" runat="server">
                <div class="Purchaseheader">Report Type</div>
            <div class="row">
                <div class="col-md-4"><label class="pull-right">Report Type :</label></div>
                <div class="col-md-8">   <asp:RadioButtonList ID="rdreporttype" runat="server" RepeatDirection="Horizontal" Style="font-weight: 700">
                                <asp:ListItem Value="Cumulative" Selected="True">Cumulative</asp:ListItem>
                                <asp:ListItem Value="MonthWiseTrend">Month Wise Trend</asp:ListItem>
                                <asp:ListItem Value="DateWiseTrend">Date Wise Trend</asp:ListItem>
                            </asp:RadioButtonList></div>
                 <div class="col-md-4"><label class="pull-right">Visit Type :</label></div>
                 <div class="col-md-4"> <asp:DropDownList ID="ddlVisitType" runat="server">
                                <asp:ListItem Text="All" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Center Visit" Value="Center Visit"></asp:ListItem>
                                <asp:ListItem Text="Home Collection" Value="Home Collection"></asp:ListItem>

                            </asp:DropDownList></div>
            </div>
                <div class="Purchaseheader">Date Filter</div>
            <div class="row">
                <div class="col-md-4"><asp:RadioButton ID="rddate" runat="server" GroupName="a" Text="Date" Checked="true" /></div>
                <div class="col-md-2">    <span class="filterdate">From Date :</span></div>
                     <div class="col-md-2">
                            <asp:TextBox ID="txtFromDate" runat="server" class="filterdate" />
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtFromDate" PopupButtonID="txtFromDate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender></div>
                <div class="col-md-2">    <span class="filterdate">To Date :</span></div>
                     <div class="col-md-2">
                            <asp:TextBox ID="txttodate" runat="server" class="filterdate" />
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender></div>
            </div>
            <div class="row">
                <div class="col-md-4"> <asp:RadioButton ID="rdcurrentmonth" runat="server" GroupName="a" Text="Current Month" /></div>
                </div>
              <div class="row">
                <div class="col-md-4"> <asp:RadioButton ID="rdtoday" runat="server" GroupName="a" Text="Today" /></div>
                  </div>
                <div class="Purchaseheader">Client Detail</div>
             <div class="row">
                <div class="col-md-4">Tag Business Unit:</div>
                 <div class="col-md-4"> <asp:ListBox ID="ddlbusinessunit" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="bindclient()"></asp:ListBox></div>
                  <div class="col-md-4">Client Type:</div>
                  <div class="col-md-4"> <asp:ListBox ID="ddlcentretype" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="bindclient()"></asp:ListBox></div>
                  <div class="col-md-4">Client :</div>
                  <div class="col-md-4">  <asp:ListBox ID="ddlclient" runat="server" CssClass="multiselect" SelectionMode="Multiple" /></div>
                 </div>
                <div class="Purchaseheader">Report Option</div>
                 <div class="row">
                <div class="col-md-4">
                       <asp:RadioButtonList ID="rdgroup" runat="server" onclick="chkCondition()">
                                <asp:ListItem Value="ClientWise" Selected="True">Client Wise</asp:ListItem>
                                <asp:ListItem Value="DepartmentWise">Department Wise</asp:ListItem>
                                <asp:ListItem Value="TestWise">Test Wise</asp:ListItem>
                            </asp:RadioButtonList>
                </div>
                      <div class="col-md-20">
                        <div class="depttest" style="display: none;">
                            Department :<asp:ListBox ID="ddldepartment" CssClass="multiselect " SelectionMode="Multiple" Width="200px" runat="server" onchange="bindtest()"></asp:ListBox>
                            <span class="test" style="display: none;">&nbsp;&nbsp;&nbsp;Test :&nbsp;

                          

                                 <asp:ListBox ID="ddltest" CssClass="multiselect" SelectionMode="Multiple" Width="440px" runat="server"></asp:ListBox>
                            </span>
                        </div>
                          </div>
                     </div>


            <div class="content GroupingOption" style="display: none">
                <div class="Purchaseheader">Grouping Option</div>

                <asp:CheckBox ID="chkclientgrouping" runat="server" Text="Client Wise Grouping" />

            </div>

        </div>
      <div class="POuter_Box_Inventory"  runat="server" id="divuser">           
             <div class="row">   
                   <div class="col-md-12"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                  </div>                         
              
             </div> 
        <div class="POuter_Box_Inventory" runat="server" style="text-align: center;" id="divsave">
            <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
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
            chkCondition();
            $('.depttest').hide()
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
            serverCall('BusinessReportCumulative.aspx/bindbusinessUnit', {}, function (response) {
                zonedata = jQuery.parseJSON(response);
                for (var a = 0; a <= zonedata.length - 1; a++) {
                    jQuery('#<%=ddlbusinessunit.ClientID%>').append($("<option></option>").val(zonedata[a].Centreid).html(zonedata[a].centre));
                }
                jQuery('#<%=ddlbusinessunit.ClientID%>').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }

        function bindclient() {
            jQuery('#<%=ddlclient.ClientID%> option').remove();
            jQuery('#<%=ddlclient.ClientID%>').multipleSelect("refresh");
            serverCall('BusinessReportCumulative.aspx/bindclient', { Businessunit: jQuery('#<%=ddlbusinessunit.ClientID%>').val().toString(), type: jQuery('#<%=ddlcentretype.ClientID%>').val().toString() }, function (response) {
                clientdata = jQuery.parseJSON(response);
                for (var a = 0; a <= clientdata.length - 1; a++) {
                    jQuery('#<%=ddlclient.ClientID%>').append($("<option></option>").val(clientdata[a].panel_ID).html(clientdata[a].PanelName));
                }
                jQuery('#<%=ddlclient.ClientID%>').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });

        }
        function bindcentretype() {
            $('#<%=ddlcentretype.ClientID%> option').remove();
            jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect("refresh");
            serverCall('BusinessReportCumulative.aspx/bindcentertype', {}, function (response) {
                typedata = jQuery.parseJSON(response);
                for (var a = 0; a <= typedata.length - 1; a++) {
                    jQuery('#<%=ddlcentretype.ClientID%>').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                }
                jQuery('#<%=ddlcentretype.ClientID%>').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }

                  function binddepartment() {
                      $('#<%=ddldepartment.ClientID%> option').remove();
                      jQuery('#<%=ddldepartment.ClientID%>').multipleSelect("refresh");

                      serverCall('BusinessReportCumulative.aspx/binddepartment', {}, function (response) {
                          deptdata = jQuery.parseJSON(response);

                          for (var a = 0; a <= deptdata.length - 1; a++) {
                              jQuery('#<%=ddldepartment.ClientID%>').append($("<option></option>").val(deptdata[a].DisplayName).html(deptdata[a].DisplayName));
                              }
                          jQuery('#<%=ddldepartment.ClientID%>').multipleSelect({
                              includeSelectAllOption: true,
                              filter: true, keepOpen: false
                          });
                       });
                   }
        function bindtest() {
            $('#<%=ddltest.ClientID%> option').remove();
            jQuery('#<%=ddltest.ClientID%>').multipleSelect("refresh");
            if ($("#<%=rdgroup.ClientID%> :checked").val() == "TestWise") {
                serverCall('BusinessReportCumulative.aspx/bindtest', { deptid: $('#<%=ddldepartment.ClientID%>').val().toString() }, function (response) {
                    testdata = jQuery.parseJSON(response);
                    for (var a = 0; a <= testdata.length - 1; a++) {
                        jQuery('#<%=ddltest.ClientID%>').append($("<option></option>").val(testdata[a].ItemID).html(testdata[a].TypeName));
                    }
                    jQuery('#<%=ddltest.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
            }
        }
 

        function getreport() {
            var reportype = $("#<%=rdreporttype.ClientID%> :checked").val();
            var fromdate = $('#<%=txtFromDate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();
            var isdate = $("#<%=rddate.ClientID%>").is(':checked') ? 1 : 0;
            var iscurrentmonth = $("#<%=rdcurrentmonth.ClientID%>").is(':checked') ? 1 : 0;
            var istoday = $("#<%=rdtoday.ClientID%>").is(':checked') ? 1 : 0;
            var businessunit = $('#<%=ddlbusinessunit.ClientID%>').val().toString();
            var centretype = $('#<%=ddlcentretype.ClientID%>').val().toString();
            var client = $('#<%=ddlclient.ClientID%>').val().toString();
            if (client == null) {
                client = "";
            }

            var reportoption = $('#<%=rdgroup.ClientID%> :checked').val();
            var department = $('#<%=ddldepartment.ClientID%>').val().toString();
            var test = $('#<%=ddltest.ClientID%>').val().toString();
            var isclientwisegrouping = $("#<%=chkclientgrouping.ClientID%>").is(':checked') ? 1 : 0;
            if (client == "") {
                toast("Error", "Please Select Client", "");
                return;
            }
            var PdfOrexcel = $('#rdoReportFormat input:checked').val();
            var VisitType = $('[id$=ddlVisitType]').val();
            serverCall('BusinessReportCumulative.aspx/GetReport', { reportype: reportype, isdate: isdate, fromdate: fromdate, todate: todate, iscurrentmonth: iscurrentmonth, istoday: istoday, businessunit: businessunit, centretype: centretype, client: client, reportoption: reportoption, department: department, test: test, isclientwisegrouping: isclientwisegrouping, VisitType: VisitType, PdfOrexcel: PdfOrexcel }, function (response) {
                if (response == "1") {
                    if (PdfOrexcel == "1")
                        window.open('BusinessReportCumulativePdf.aspx');
                    else
                        window.open('../../common/ExportToExcel.aspx');
                }
                else if (response == "2") {
                    toast("Info", "Month Wise Trend (Not More Than 1 Year", "");
                }
                else if (response == "3") {
                    toast("Info", "Date Wise Trend (Not More Than 31 Days", "");
                }
                else if (response == "0") {
                    toast("Info", "No Record Found..!", "");
                }
                else if (response == "-1") {
                    toast("Error", "Your From date ,To date Diffrence is too  Long", "");                  
                }
                
            });
        }
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
</form>
</body>
</html>
