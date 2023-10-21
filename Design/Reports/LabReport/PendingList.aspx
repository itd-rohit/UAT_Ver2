<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="PendingList.aspx.cs" Inherits="Design_Lab_PendingList" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
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
            <div class="row" style="text-align: center;">
                <div class="col-md-24">
                <b>Pending List</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="div1" runat="server">
            <div class="row">
                <div class="col-md-3"><label class="pull-right">  Date Type :</label></div>
                <div class="col-md-3"> <asp:DropDownList ID="ddlDateType" runat="server">
                    <asp:ListItem Selected="true" Value="lt.Date">Reg Date</asp:ListItem>
                    <asp:ListItem Value="plo.DeliveryDate">Delivery Date</asp:ListItem>
                    <asp:ListItem Value="plo.SampleDate">Sample Date</asp:ListItem>
                </asp:DropDownList></div>
               
              
                     <div class="col-md-3"> <label class="pull-right">From Date :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" /></div>
                 <div class="col-md-3"><label class="pull-right">To Date :</label></div>
                 <div class="col-md-3"><asp:TextBox ID="dtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtToDate" Format="dd-MMM-yyyy" PopupButtonID="dtToDate" /></div>
                 <div class="col-md-3"></div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory"  id="div2" runat="server">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkAllDept" runat="server" Text="Select All Department" CssClass="ItDoseCheckbox" />
            </div>
            <div class="row" style="height:100px;overflow:scroll;border:double">
                <div class="col-md-24">
                <asp:CheckBoxList ID="chkDept" runat="server" RepeatColumns="6"
                    RepeatDirection="Horizontal">
                </asp:CheckBoxList></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory"   id="div3" runat="server">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkAllCentre" runat="server" Text="Select All Centers" CssClass="ItDoseCheckbox" /><br />
            </div>
            <div class="row" style="height:100px;overflow:scroll;border:double">
                  <div class="col-md-24">
                <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal">
                </asp:CheckBoxList>
                      </div>
            </div>
        </div>
             <div class="POuter_Box_Inventory"  id="div6" runat="server">
            <div class="Purchaseheader">
                Test Centre <asp:CheckBox ID="chkTestCentres" runat="server" Text="Select All Test Centers" onclick="SelectAll('TestCentre')" />
            </div> 
           <div class="row" style="height:100px;overflow:scroll;border:double">
               <div class="col-md-24">
             <asp:CheckBoxList ID="chlTestCentres" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkTestCentre"></asp:CheckBoxList>   
                   </div>                    
               </div>
             </div>
        <div class="POuter_Box_Inventory"  id="div4" runat="server">
            <div class="row" style="text-align: center;">
                   <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True"  Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel"   Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                  <div class="col-md-16">
                <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />    
                      </div>
                  <div class="col-md-4"></div>
            </div>
        </div>
     <script type="text/javascript">
         $(document).ready(function () {
             $("#<%=chkAllDept.ClientID %>").click(function () {
                $('#<%=chkDept.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
            });

            $("#<%=chkAllCentre.ClientID %>").click(function () {
                $('#<%=chlCentres.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
            });

             $("#<%=chkTestCentres.ClientID %>").click(function () {
                 $('#<%=chlTestCentres.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
              });
        });
        function getreport() {
            var FromDate = jQuery('#<%=dtFrom.ClientID%>').val().trim();
            var ToDate = jQuery('#<%=dtToDate.ClientID%>').val().trim();
            var CentreId = "";
            $("[id*=chlCentres] input:checked").each(function () {
                CentreId += $(this).val() + ",";
            });
            var TestCentreId = "";
            $("[id*=chlTestCentres] input:checked").each(function () {
                TestCentreId += $(this).val() + ",";
            });
            var Department = "";
            $("[id*=chkDept] input:checked").each(function () {
                Department += $(this).val() + ",";
            });
            var DateType = jQuery('#<%=ddlDateType.ClientID%>').val().toString();
            var ReportFromat = jQuery('#<%=rdoReportFormat.ClientID%> input:checked').val().toString();
            var Reporttype = "0";
            serverCall('PendingList.aspx/GetReport', { FromDate: FromDate, ToDate: ToDate, CentreId: CentreId, ReportFromat: ReportFromat, DepartmentID: Department, Reporttype: Reporttype, DateType: DateType, TestCentreId: TestCentreId }, function (response) {
                var $responseData = JSON.parse(response);
                PostQueryString($responseData, 'PendingListPdf.aspx');
            });
        }
    </script>
</form>
</body>
</html>

