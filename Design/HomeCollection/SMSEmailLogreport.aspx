<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SMSEmailLogreport.aspx.cs" Inherits="Design_HomeCollection_SMSEmailLogreport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>SMS Email Notification Log Report</strong>
        </div>


        <div class="POuter_Box_Inventory">

            <div class="row">
                 <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left"><b>From Date</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>

                <div class="col-md-2">
                    <label class="pull-left"><b>To Date</b></label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-2">
                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>

                <div class="col-md-2">
                    <label class="pull-left"><b>Log Type </b></label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-3">
                    <asp:DropDownList ID="ddltype" runat="server">
                        <asp:ListItem Value="0">Select Type</asp:ListItem>
                        <asp:ListItem Value="SMS">SMS</asp:ListItem>
                        <asp:ListItem Value="Email">Email</asp:ListItem>
                        <asp:ListItem Value="Notification">Notification</asp:ListItem>
                    </asp:DropDownList>
                </div>

            </div>
            <div class="row">
               
                    <div class="col-md-11"></div>
                    <div class="col-md-2" style="font-weight: bold; text-align: center">

                        <input type="button" value="Get Report" class="searchbutton" onclick="getsummmaryreport()" />

                    
                </div>
            </div>
       </div>
    </div>

    <script type="text/javascript">




        function getsummmaryreport() {
            if ($('#<%=ddltype.ClientID%>').val() == "0") {
                 toast("Error", "Please Select Log Type");
                 $('#<%=ddltype.ClientID%>').focus();
                 return;
             }          
             serverCall('SMSEmailLogreport.aspx/SummaryReport',
                 { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), logtype: $('#<%=ddltype.ClientID%>').val() },
                 function (result) {
                     ItemData = result;

                     if (ItemData == "false") {
                         toast("Error", "No Data Found");
                        

                     }
                     else {
                         window.open('../common/ExportToExcel.aspx');
                        

                     }

                 })


             }



    </script>
</asp:Content>


