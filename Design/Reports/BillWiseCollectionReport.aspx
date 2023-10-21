<%@ Page Language="C#" ClientIDMode="Static"  AutoEventWireup="true" CodeFile="BillWiseCollectionReport.aspx.cs" Inherits="Design_Reports_BillWiseCollectionReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreLoad.ascx" TagName="wuc_CentreLoad"
    TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
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
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Bill Wise Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory"  id="divcentre" runat="server">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">From Bill Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4 ">
                    <asp:TextBox ID="txtFromDate" runat="server" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">To Bill Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4 ">

                    <asp:TextBox ID="txtToDate" runat="server" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3 ">
                </div>
                <div class="col-md-7 ">
                </div>
            </div>

            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Bill No. </label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4 ">
                    <asp:TextBox ID="txtBillNo" runat="server" />
                </div>


                <div class="col-md-3 ">
                </div>
            </div>
            <div class="Purchaseheader">
                Centre Search
            </div>
            <uc1:wuc_CentreLoad ID="CentreInfo" runat="server" />
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
            <input type="button" id="btnReport" class="ItDoseButton" value="Report" onclick="$getReport(this);" />

        </div>
    <script type="text/javascript">
        $getReport = function (elem) {
            var postedData = [];
            var data = {
                fromDate: $("#txtFromDate").val(),
                toDate: $("#txtToDate").val(),
                billNo: $("#txtBillNo").val(),
                centreID: $('#lstCentreLoadList').multipleSelect("getSelects").join(),
                reportName: "BillWiseReport",
                reportformat: $('#rdoReportFormat input:checked').val()
            }
            postedData.push(data);
            serverCall('BillWiseCollectionReport.aspx/getReport', { data: postedData }, function (response) {
                console.log(response);
                var resultData = JSON.parse(response);
                PostExcelReport(resultData.ReportData, resultData.ReportName, resultData.Period, resultData.ReportPath);
            });
        };

    </script>
</form>
</body>
</html>

