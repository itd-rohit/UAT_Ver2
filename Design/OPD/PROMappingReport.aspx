<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PROMappingReport.aspx.cs" Inherits="Design_OPD_PROMappingReport" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
 <script  src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
 <script type="text/javascript">
     $(document).ready(function () {
         $(document).keypress(function (e) {
             if (e.which == 13) {

                 SearchReceipt();

             }
         });
     });
     $(function () {
         $('.numbersOnly').keyup(function () {
             this.value = this.value.replace(/[^0-9\.]/g, '');
         });
     });
     $(function () {
         $('.txtonly').keyup(function () {
             this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
         });
     });


 
</script>
  <script type="text/javascript"> 
function CheckBoxListSelect1(Chk,chl)
{ 
       var chh=document.getElementById(Chk).value;
      
       
          
       
       var chkBoxList = chl;
       
       var chkBoxCount= chkBoxList.getElementsByTagName("input");
        
               for(var i=0;i<chkBoxCount.length;i++)
        {
            chkBoxCount[i].checked = document.getElementById(Chk).checked;
        }
       
}
</script>
 <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <center>
<div id="body_box_inventory" style="width:99%;"  >
        <div class="Outer_Box_Inventory" style="width:99%;margin-top:50px;">
            <div class="content">
                <div style="text-align:center;">
                    <b>PRO Mapping Report</b>
                </div>
                <div style="text-align:center;">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    
                </div>
                <table>
                 <tr style="display:none;"><td>PRO Type :</td>
                    <td colspan="4">
                     <asp:RadioButtonList ID="rblPROType" runat="server" RepeatDirection="Horizontal">
                      
                       <asp:ListItem Selected="true" Value="Panel">Panel</asp:ListItem>
                       <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                       </asp:RadioButtonList> 
                    </td></tr>
                    <tr ><td>Report Formate :</td>
                    <td colspan="4">
                    <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatDirection="Horizontal">
                      <%-- <asp:ListItem  Value="PDF">PDF</asp:ListItem>--%>
                       <asp:ListItem Selected="true" Value="Excel">Excel</asp:ListItem> 
                       </asp:RadioButtonList>
                    </td></tr>
                    </table>
               
           </div>
       </div>
      
      
        <div class="POuter_Box_Inventory">
         <div class="Purchaseheader">
         <input id="chkPRO" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkPRO',document.getElementById('<%=chklstPRO.ClientID %>'))"  />Select PRO:</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstPRO" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
        
            <div class="POuter_Box_Inventory" style="text-align:center;">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click"/>
                </div>
       </div>
        </center>
</asp:Content>



