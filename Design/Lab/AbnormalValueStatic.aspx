<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AbnormalValueStatic.aspx.cs" Inherits="Design_Lab_AbnormalValueStatic" Title=" Abnormal Value Static" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Lab Investigation Analysis Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Date
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromDate" runat="server" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>
                <div class="col-md-1"></div>

                <div class="col-md-2">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtToDate" runat="server" />
                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                 <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlSearchByDate" runat="server">
                        <asp:ListItem Value="Registration Date">Registeration Date</asp:ListItem>
                        <asp:ListItem Value="Sample Receiving Date" Selected="True">Sample Receiving Date</asp:ListItem>
                        <asp:ListItem Value="Approval Date">Approval Date</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre
                <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" />
            </div>

            <div style="overflow: scroll; height: 150px;">
                <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Department
                <asp:CheckBox ID="chkAllDept" runat="server" Text="Select All Department" onclick="SelectAll('Dept')" />
            </div>
            <div  style="overflow: scroll; height: 150px;">
                <asp:CheckBoxList ID="chkDept" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <div style="margin-left: 400px;display:none">
                <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="PDF" Text="PDF" Selected="True"></asp:ListItem>

                </asp:RadioButtonList>
            </div>
            <asp:Button ID="btnPDFReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnPDFReport_Click" OnClientClick="return validate();"/>

        </div>

    </div>
    <script type="text/javascript">
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                }
            }
            else if (Type == "Dept") {
                var chkBoxList = document.getElementById('<%=chkDept.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkAllDept.ClientID %>').checked;
                 }
             }

     }

    </script>
    <script type="text/javascript">
        function validate() {
            document.getElementById('<%=btnPDFReport.ClientID%>').disabled = true;
            document.getElementById('<%=btnPDFReport.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnPDFReport', '');


        }
    </script>
</asp:Content>

