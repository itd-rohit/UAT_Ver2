<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PendingSampleReport.aspx.cs" Inherits="Design_Lab_PendingSampleReport" Title="Pending Sample Report" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">    
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <b>Pending Sample Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
            
           <div class="POuter_Box_Inventory" style="width: 1300px;"> 
            <div class="Purchaseheader">
                Date
            </div>           
           <div id="Div2" style=" height:30px;">  
                 <table style="text-align: center; width: 100%;">               
                <tr>
                    <td style="width: 21%; text-align: right"> From Date :&nbsp;</td>
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
               </div>
             </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Centre <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centre" onclick="SelectAll('Centre')" />
                <asp:CheckBox ID="chkCentreStat" runat="server" Text="Select All Stat Centre" onclick="SelectAll('STAT')" />
                <asp:CheckBox ID="chkCentreHLM" runat="server" Text="Select All HLM Centre" onclick="SelectAll('HLM')" />
            </div> 
           <div id="" style="overflow:scroll; height:400px;">
             <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>                       
               </div>
             </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">
            <asp:Button ID="btnExcelReport" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnExcelReport_Click"/>
            
        </div>

    </div>
     <script type="text/javascript">         
         function SelectAll(Type) {
             $("[id*=chlCentres] input[type=checkbox]").prop('checked', false);  
             if (Type == "Centre") {
                 document.getElementById('<%=chkCentreStat.ClientID %>').checked = false;
                 document.getElementById('<%=chkCentreHLM.ClientID %>').checked = false;
                 $("[id*=chlCentres] input[type=checkbox]").prop('checked', document.getElementById('<%=chkCentres.ClientID %>').checked);                
             }
             if (Type == "STAT") {
                 document.getElementById('<%=chkCentres.ClientID %>').checked = false;
                 document.getElementById('<%=chkCentreHLM.ClientID %>').checked = false;
                 PageMethods.getData('STAT', onSuccessSTAT, Onfailure);
             }
             if (Type == "HLM") {
                 document.getElementById('<%=chkCentres.ClientID %>').checked = false;
                 document.getElementById('<%=chkCentreStat.ClientID %>').checked = false;
                 PageMethods.getData('HLM', onSuccessHLM, Onfailure);
                 
             }
        }
         function onSuccessSTAT(result) {
             var CentreData = jQuery.parseJSON(result);            
             $(CentreData[0].CentreID.split(",")).each(function (i, item) {                             
                 $("[id*=chlCentres] input[value=" + $.trim(item) + "]").prop('checked', document.getElementById('<%=chkCentreStat.ClientID %>').checked);
             });

         }
         function onSuccessHLM(result) {
             var CentreData = jQuery.parseJSON(result);
             $(CentreData[0].CentreID.split(",")).each(function (i, item) {
                 $("[id*=chlCentres] input[value=" + $.trim(item) + "]").prop('checked', document.getElementById('<%=chkCentreHLM.ClientID %>').checked);
             }); 
         }
         function Onfailure() {
             alert('Error Occured....!');

         }
    </script>
</asp:Content>

