<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InfectionControlReportNew.aspx.cs" Inherits="Design_Lab_InfectionControlReportNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 
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
                <div class="col-md-24">
                     <b>Infection Control Report </b>                           
                </div>
            </div>           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Report Filter</div>
            <div class="row">
                <div class="col-md-4"> <span class="filterdate">From Date :</span> </div>
                <div class="col-md-4">
                      <asp:TextBox ID="txtfromdate" runat="server" class="filterdate" />
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                </div>
                <div class="col-md-4"> <span class="filterdate">To Date :</span> </div>
                <div class="col-md-4">
                     <asp:TextBox ID="txttodate" runat="server"  class="filterdate" />
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                </div>
            </div>

             <div class="row">
                <div class="col-md-4">Centre:</div>
                 <div class="col-md-4"> <asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox></div>
                
            <div class="col-md-16"></div>
                 </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                  <div class="col-md-4"><asp:RadioButtonList ID="rblreporttype" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="1" Selected="True">Pdf</asp:ListItem>
                <asp:ListItem Value="2">Excel</asp:ListItem>
                                  </asp:RadioButtonList>       
        </div>
                <div class="col-md-16">
                     <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
                </div>
                 <div class="col-md-4"></div>
            </div>           
        </div>      

    </div>
    <script type="text/javascript">
        $(function () {
            
            jQuery('#<%=ddlCentre.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });                       
            bindCentre();

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


        function bindCentre() {
            $('#<%=ddlCentre.ClientID%> option').remove();
            jQuery('#<%=ddlCentre.ClientID%>').multipleSelect("refresh");
            serverCall('InfectionControlReportNew.aspx/bindCentre', { }, function (response) {
                var data = $.parseJSON(response);
                if (data.length > 0) {                   
                    for (var i = 0; i < data.length; i++) {
                        jQuery('#ddlCentre').append($("<option></option>").val(data[i].CentreID).html(data[i].Centre));
                    }
                }
                $('[id$=ddlCentre]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }       

        function getreport() {

            var IsValid = true;
            var LedgertransactionID = "";           

            if (IsValid) {              
                var FromDate = $('[id$=txtfromdate]').val().trim();
                var ToDate = $('[id$=txttodate]').val().trim();
                var CentreId = $('[id$=ddlCentre]').val().toString();              

                var ReportFromat = "";
                var rb = document.getElementById("<%=rblreporttype.ClientID%>");
                  var radio = rb.getElementsByTagName("input");                  
                  for (var i = 0; i < radio.length; i++) {
                      if (radio[i].checked) {                         
                          ReportFromat = radio[i].value;
                          break;
                      }
                  }

                serverCall('InfectionControlReportNew.aspx/GetReport', { FromDate: FromDate, ToDate: ToDate, CentreId: CentreId, ReportFromat: ReportFromat }, function (response) {
                    var $responseData = JSON.parse(response);
                    PostQueryString($responseData, 'InfectionControlReportPdf.aspx');
                });
            }
        }
    </script>
</form>
</body>
</html>
