<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HLMRevenueFromOSSampleReport.aspx.cs" Inherits="Design_Lab_HLMRevenueFromOSSampleReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>HLM Revenue From O/S Sample Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="text-align: center; width: 100%;">
                <tr>
                    <td style="width: 20%; text-align: right">From Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                </tr>
           
            </table>
             <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                HLM Centre <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" />
            </div> 
           <div id="" style="overflow:scroll; height:150px;">
             <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>                       
               </div>
             </div>


        </div>    
        <div class="POuter_Box_Inventory" style="text-align: center">


            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>

    </div>
    <script type="text/javascript">
        function getReport() {
            var Centre='';            
            $('[id*=chlCentres] input:checked').each(function () {
                Centre += this.value + ",";
            });
            if (Centre == "") {
                alert('Kindly Select Centre');
                return;
            }
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            PageMethods.getReport(dtFrom, dtTo, Centre,onSuccessReport, OnfailureReport);
        }
        function onSuccessReport(result) {
            if (result == "1") {
                window.open('../common/ExportToExcel.aspx');
            }
            else if (result == "0") {
                alert('Record Not Found....!');
            }
        }
        function OnfailureReport() {
            alert('Error Occured....!');
            
        }
        function SelectAll(Type) {
            if (Type == "Centre") {
                var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                }
            }
        }
    </script>
</asp:Content>

