<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="MISExcel.aspx.cs" Inherits="Design_MIS_MISExcel" %>
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
   
</Scripts>
</Ajax:ScriptManager>  
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>MIS Report (Excel)</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4"><label class="pull-right">From Date :</label> </div>
                <div class="col-md-4">  <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy" runat="server"> </cc1:CalendarExtender></div>
                 <div class="col-md-4"><label class="pull-right">To Date :</label> </div>
                <div class="col-md-4"><asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="dateto" TargetControlID="ucDateTo" Format="dd-MMM-yyyy" runat="server"> </cc1:CalendarExtender></div>

                <div class="col-md-4"></div>
            </div>
            <div class="row">
                <div class="col-md-4"><label class="pull-right">Report Type :</label> </div>
                <div class="col-md-4"> <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Transactional" Selected="True" Value="1" />
                              <%--  <asp:ListItem Text="Clinical" Value="2" />--%>
                            </asp:RadioButtonList></div>
                </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
            <asp:Button ID="btnReport" runat="server" TabIndex="11" Text="Generate Report" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnReport_Click" />
                    </div></div>
        </div>
</form>
</body>
</html>

