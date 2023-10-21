<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RefundReport.aspx.cs" Inherits="Design_OPD_RefundReport"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/CheckboxSearch.js" />
      <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
</Ajax:ScriptManager>  
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Refund Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory" id="divcentre" runat="server">
            <div class="Purchaseheader">
                Report Criteria
            </div>
                <div class="row">
                <div class="col-md-4"><label class="pull-right">From Date :</label> </div>
                <div class="col-md-4"><asp:TextBox ID="ucFromDate" runat="server" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                     <div class="col-md-4"><label class="pull-right">To Date :</label> </div>
                    <div class="col-md-4"><asp:TextBox ID="ucToDate" runat="server" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
            </div>
              <div class="row">
                <div class="col-md-4"><label class="pull-right">Amount Type :</label> </div>
                   <div class="col-md-8"><asp:RadioButtonList ID="rblAmtStatus" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">Amount Refund</asp:ListItem>
                                <asp:ListItem Value="1">Test Refund</asp:ListItem>
                            </asp:RadioButtonList></div>
                  </div>
            <div class="Purchaseheader">
                <input id="chkCentre" type="checkbox" value="Users" onclick="CheckBoxListSelect1()" />Select Centre :
            </div>
           <div class="row" style="overflow:scroll;height:300px;">
                <div class="col-md-24"> <asp:CheckBoxList ID="chklstCenter" CssClass="chkAllCentre" runat="server" RepeatColumns="8" RepeatDirection="Horizontal"></asp:CheckBoxList></div>
               </div>
            </div>
            

        <div class="POuter_Box_Inventory" style="text-align: center;" id="divsave" runat="server">
            <div class="row">
                     <div class="col-md-4"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                 <div class="col-md-16">
             <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />    
                     </div>
                 <div class="col-md-4"></div>
        </div>
            </div>
    <script type="text/javascript"> 
        function CheckBoxListSelect1(Chk,chl)
        { 
            if ($("#chkCentre").is(':checked')) {
                $(".chkAllCentre input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chkAllCentre input[type=checkbox]").prop('checked', false);
            }
        }
        function getreport() {
            var FromDate = jQuery('#<%=ucFromDate.ClientID%>').val().trim();
              var ToDate = jQuery('#<%=ucToDate.ClientID%>').val().trim();
              var CentreId = "";
              $("[id*=chklstCenter] input:checked").each(function () {
                  CentreId += $(this).val() + ",";
              });
          
              
            var ReportFromat = jQuery('#<%=rdoReportFormat.ClientID%> input:checked').val().toString();
            var Reporttype = jQuery('#<%=rblAmtStatus.ClientID%> input:checked').val().toString();
              serverCall('RefundReport.aspx/GetReport', { FromDate: FromDate, ToDate: ToDate, CentreId: CentreId, ReportFromat: ReportFromat, Reporttype: Reporttype }, function (response) {
                  var $responseData = JSON.parse(response);
                  if ($responseData == "-1") {
                      alert('Your From date ,To date Diffrence is too  Long');
                      //toast("Error", 'Your From date ,To date Diffrence is too  Long');
                      return;
                  }
                  PostQueryString($responseData, 'RefundReportPdf.aspx');
              });
          }
    </script>
</form>
</body>
</html>


