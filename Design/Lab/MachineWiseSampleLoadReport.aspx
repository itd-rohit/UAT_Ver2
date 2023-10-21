<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineWiseSampleLoadReport.aspx.cs" Inherits="Design_Lab_MachineWiseSampleLoadReport" Title="Machine Wise Sample Load Report" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Machine Wise Sample Load Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
            
           <div class="POuter_Box_Inventory"> 
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
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" />
            </div> 
           <div id="" style="overflow:scroll; height:400px;">
             <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>                       
               </div>
             </div>
        
        <div class="POuter_Box_Inventory" style="text-align: center">
            
            <asp:Button ID="btnExcelReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnExcelReport_Click"/>
            
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
        }

    </script>
</asp:Content>

