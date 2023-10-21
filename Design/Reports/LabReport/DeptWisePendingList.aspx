<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="DeptWisePendingList.aspx.cs" Inherits="Design_Lab_DeptWisePendingList" %>

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
    <div id="Pbody_box_inventory">
     
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Technician Pending List</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" id="div1" runat="server">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-4"><label class="pull-right"> From Date :</label></div>
                <div class="col-md-2"> <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtFromTime" runat="server" ></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                            ControlExtender="mee_txtFromTime"
                            ControlToValidate="txtFromTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator></div>
                <div class="col-md-4"><label class="pull-right">To Date :</label></div>
                <div class="col-md-2"> <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                            ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator></div>
            </div>
             <div class="row">
                <div class="col-md-4"><label class="pull-right">Centre :</label></div>
                 <div class="col-md-4"><asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server"  ClientIDMode="Static"></asp:ListBox></div>
                 <div class="col-md-4"><label class="pull-right">Department :</label></div>
                 <div class="col-md-4"><asp:ListBox ID="ddldept" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="GetDepartmentItem();" ClientIDMode="Static"></asp:ListBox>
</div>
           
                <div class="col-md-4"><label class="pull-right">Test Name :</label></div>
                <div class="col-md-4">  <asp:DropDownList ID="ddlItem" runat="server" class="ddlItem  chosen-select" onchange="Search()">
                        </asp:DropDownList></div>
                </div>          
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center" id="div2" runat="server">


            <input type="button" class="searchbutton" value="Get Report Excel" onclick="getReport('Excel');" />
            <input type="button" class="searchbutton" value="Get Report PDF" onclick="getReport('PDF');" />
        </div>

    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $('[id*=ddldept]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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
            GetDepartmentItem();
           
        });
    </script>
    <style type="text/css">
    .multiselect {
        width: 200px;
    }
</style>


    <script type="text/javascript">
        function GetDepartmentItem() {
         
            $("#<%=ddlItem.ClientID %> option").remove();
            var ddlItem = $("#<%=ddlItem.ClientID %>");
            ddlItem.attr("disabled", true);
            var AccessDepartmentEmp = '<%=AccessDepartment%>';
            serverCall('DeptWisePendingList.aspx/GetDepartmentWiseItem', { SubCategoryID:  $('#ddldept').multipleSelect("getSelects").join() ,AccessDepartmentEmp:  AccessDepartmentEmp }, function (response) {
                PatientData = jQuery.parseJSON(response);
                if (PatientData.length == 0) {
                    ddlItem.append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    ddlItem.append($("<option></option>").val("All").html("All"));
                    for (i = 0; i < PatientData.length; i++) {
                        ddlItem.append($("<option></option>").val(PatientData[i].ItemID).html(PatientData[i].TypeName));
                    }
                }
                ddlItem.attr("disabled", false);
                ddlItem.trigger('chosen:updated');
            });
        }
        var ReportType = 'Excel';
        function getReport(ReportTypes) {
            ReportType = ReportTypes;
            var CentreID = $('#ddlCentre').multipleSelect("getSelects").join();
            if (CentreID == '') {
  
                toast("Error", "Please Select Centre", "");
                return;
            }
            var deptid = $('#ddldept').multipleSelect("getSelects").join();
            var centrename = "";
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var TimeFrom = $('#<%=txtFromTime.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            var TimeTo = $('#<%=txtToTime.ClientID%>').val();
            var AccessDepartmentEmpWise = '<%=AccessDepartment%>';
            var ItemID = $('#<%=ddlItem.ClientID%>').val();
           
            PageMethods.getReport(dtFrom, dtTo, CentreID, deptid, centrename, TimeFrom, TimeTo, AccessDepartmentEmpWise, ItemID, ReportType, onSuccessReport, OnfailureReport);
        }
        function onSuccessReport(result) {
         
            if (result == "1") {
                if (ReportType == 'Excel') {
                    window.open('../../common/ExportToExcel.aspx');
                }
                else {
                    window.open('DepartmentWisePendingListPdf.aspx');
                }
            }
            else if (result == "0") {                
                toast("Error", "Record Not Found....!", "");
            }
            ReportType = 'Excel';
        }
        function OnfailureReport() {
            ReportType = 'Excel';
            toast("Error", "Kindly Select Centre", "");            
        }
    </script>   
              
</form>
</body>
</html>

