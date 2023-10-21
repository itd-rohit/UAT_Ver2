<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CompleteMappingReport.aspx.cs" Inherits="Design_Investigation_CompleteMappingReport"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

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
<div id="body_box_inventory" style="width:1304px;"  >
        <div class="Outer_Box_Inventory" style="width:1300px;text-align:center;">
          
              
                    <b>Complete Mapping Report</b>
               
                <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    
                </div>
               
         
      
       <div class="Outer_Box_Inventory" style="width:1300px;">
        
                
                <table style="width: 851px; float:left;">
                
                    
<tr><td style="width: 361px; height: 32px;">
                        Report Format</td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                            <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatDirection="Horizontal" Enabled="false">
                                <asp:ListItem  Value="PDF">PDF</asp:ListItem>
                                <asp:ListItem Value="Excel" Selected="true">Excel</asp:ListItem> 
                            </asp:RadioButtonList></td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                        </td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                        </td>
                    <td colspan="4" style="height: 32px">
                        &nbsp;</td></tr>
                    <tr><td style="width: 361px; height: 32px;">
                        Gender</td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                            <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem  Value="M">Male</asp:ListItem>
                                <asp:ListItem Value="F">FeMale</asp:ListItem>
                                 <asp:ListItem Value="Both" Selected="true">Both</asp:ListItem>
                            </asp:RadioButtonList></td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                        </td>
                        <td colspan="1" style="width: 599px; height: 32px;">
                        </td>
                    <td colspan="4" style="height: 32px">
                        &nbsp;</td></tr>
                   <tr><td style="width: 361px">
                       Show Interpretation :</td>
                       <td colspan="1" style="width: 599px">
                       <asp:RadioButtonList ID="rblInter" runat="server" RepeatDirection="Horizontal">
                           <asp:ListItem Selected="true" Value="Yes">Yes</asp:ListItem>
                           <asp:ListItem Value="No">No</asp:ListItem>
                       </asp:RadioButtonList></td>
                       <td colspan="1" style="width: 599px">
                       </td>
                       <td colspan="1" style="width: 599px">
                       </td>
                    <td colspan="4">
                        &nbsp;</td></tr>
                   
                   
               </table>
           </div>
 


        <div class="POuter_Box_Inventory"  style="width:1300px;">
         <div class="Purchaseheader" >
         <input id="chkCentre" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkCentre',document.getElementById('<%=chklstCenter.ClientID %>'))"  />Select Centre :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstCenter" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
        <div class="POuter_Box_Inventory"  style="width:1300px;">
         <div class="Purchaseheader"  >
         <input id="chkDept" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkDept',document.getElementById('<%=chklstDept.ClientID %>'))"  />Select Department:</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstDept" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>


    <div class="POuter_Box_Inventory"  style="width:1300px;">
         <div class="Purchaseheader"  >
         <input id="chkMac" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkMac',document.getElementById('<%=chklstMac.ClientID %>'))"  />Select Machine:</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
                 <div >
    <asp:CheckBoxList ID="chklstMac" runat="server" RepeatColumns="8" RepeatDirection="Horizontal">
        </asp:CheckBoxList></div>
              </td>
                        </tr>
               </table>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="display:none;">
         <div class="Purchaseheader">
         <input id="chkDoctor" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkDoctor',document.getElementById('<%=chklstDoctor.ClientID %>'))"  />Select Doctor :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstDoctor" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align:center;width:1300px;">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
           <asp:Button ID="btnReport" runat="server" CssClass="savebutton" Text="Report" OnClick="btnReport_Click"/>
                 <asp:Button ID="btnInterpretationReport" CssClass="savebutton" runat="server" Text="Interpretation Report" OnClick="btnInterpretationReport_Click"/>
                <asp:Button ID="btnTemplate" runat="server" CssClass="savebutton" Text="Template Report" OnClick="btnTemplate_Click"/>
                </div>
      </div>
</asp:Content>



