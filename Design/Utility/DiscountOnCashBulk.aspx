<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DiscountOnCashBulk.aspx.cs" Inherits="Design_Utility_DiscountOnCashBulk" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <script type="text/javascript" src="../../JavaScript/jquery-1.3.2.min.js"></script>
  <script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>
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
   <script type="text/javascript">
   $(document).ready(function(){
  $("#<%=txtDisc.ClientID%>").keyup(function(){
 var Amt = "";
    var NetAmt = "0";
     var NetAmtNewPnl= $("#<%=lblNetAmtNewPnl.ClientID%>").text();
    var DiscountAmt= $("#<%=txtDisc.ClientID%>").val();
      var NetAmtAll= $("#<%=lblNetAmtAll.ClientID%>").text();
     var NetAmtEditPt= $("#<%=lblNetAmtEditPt.ClientID%>").text();
     var TotalCash = $("#<%=lblTotalCash.ClientID%>").text();
     
    
    if(Number(NetAmtNewPnl)-Number(DiscountAmt) <= 0) 
    {
    alert("Discount amount can't be greater then equal to "+NetAmtNewPnl);
    
    }
    else
    {
        var NetAmt= Number(NetAmtNewPnl)-Number(DiscountAmt);
        //alert(NetPay);     
        $("#<%=lblNetAmtNewPnlFinal.ClientID%>").html(NetAmt);
        
        var NetAmtAllFinal = Number(NetAmtAll) - ( Number(NetAmtEditPt) - Number(NetAmt));
        $("#<%=lblNetAmtAllFinal.ClientID%>").html(NetAmtAllFinal);
        
         var CashAfterUtility = Number(TotalCash) - ( Number(NetAmtEditPt) - Number(NetAmt));
        $("#<%=lblCashAfterUtility.ClientID%>").html(CashAfterUtility);
        
        
     }

  });
   });
   
 </script> 
       <div id="Pbody_box_inventory" Class="Pbody_box_inventory" style="width:97%;" >
    <div class="POuter_Box_Inventory" style="width:99.6%;">
    <div class="content">
    <div style="text-align:center;">
    <b>Discount On Cash (Bulk Settlement)<br />
    </b>
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    
      <div style="display:none">   <asp:TextBox ID="txtUniqueHash" runat="server" CssClass="txtHash"></asp:TextBox>&nbsp;</div>
  </div>

   </div>
   </div>
   
        <div class="Outer_Box_Inventory" style="width:99.6%; text-align: center;">
    <div class="Purchaseheader">
        Search Criteria&nbsp;</div>
        
        <div style="text-align:center;">
            <table>
                
                <tr>
                    <td  align="right">
                            From Date :</td>
                    <td align="left" >
                       <uc1:EntryDate ID="FrmDate" runat="server" />
                        </td>
                    <td  align="right" style="width: 102px">
                            To Date :</td>
                    <td align="left" >
                        <uc1:EntryDate id="ToDate" runat="server"></uc1:EntryDate>
                        </td>
                    <td  align="right" style="width: 128px">
                          </td>
                    <td align="left" >
                         </td>
                </tr>  
            </table> 
                </div>
                  
        </div>
         <div class="Outer_Box_Inventory" style="width:99.6%">
         <div class="Purchaseheader">
         <input id="chkAllCentre" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkAllCentre',document.getElementById('<%=chkCentre.ClientID %>'))"  />Select Centre :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chkCentre" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
           <div class="Outer_Box_Inventory" style="width: 99.6%">
               <div class="Purchaseheader">
                   <input id="challdoctor" onclick="CheckBoxListSelect1('challdoctor',document.getElementById('<%=chkdoctor.ClientID %>'))"
                       type="checkbox" value="Users" />Select Doctor :</div>
               <div class="content" style="text-align: left">
                   <table>
                       <tr>
                           <td>
                               <div style="overflow-y: scroll; height: 100px">
                                   <asp:CheckBoxList ID="chkdoctor" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                                   </asp:CheckBoxList></div>
                           </td>
                       </tr>
                   </table>
               </div>
           </div>
           <div class="Outer_Box_Inventory" style="width: 99.6%">
               <div class="Purchaseheader">
                   <input id="chkdepartment" onclick="CheckBoxListSelect1('chkdepartment',document.getElementById('<%=ckdepartment.ClientID %>'))"
                       type="checkbox" value="Users" />Select Department :</div>
               <div class="content" style="text-align: left">
                   <table>
                       <tr>
                           <td >
                               <div style="overflow-y: scroll; height: 100px">
                                   <asp:CheckBoxList ID="ckdepartment" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                                   </asp:CheckBoxList></div>
                           </td>
                       </tr>
                   </table>
               </div>
           </div>
             <div class="Outer_Box_Inventory" style="width:99.6%">
         <div class="Purchaseheader">
          <input id="chkAllPanel" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkAllPanel',document.getElementById('<%=chkPanel.ClientID %>'))"  />Select Source Panel :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
             <div style="height:100px;overflow-y:scroll;">
              <asp:CheckBoxList ID="chkPanel" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
        </asp:CheckBoxList></div>
              </td>
                        </tr>
               </table>
            </div>
            </div><div class="Outer_Box_Inventory" style="width:99.6%;">
                <div class="Purchaseheader">
                    <input id="chkAllTargetPanel" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkAllTargetPanel',document.getElementById('<%=chkTargetPanel.ClientID %>'))"  />Select Target Panel :</div>
                <div class="content" style="text-align: left;height:100px;overflow-y:scroll;">
                    <table>
                        <tr >
                            <td>
                                <asp:CheckBoxList ID="chkTargetPanel" runat="server" RepeatColumns="6" RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
    <div class="POuter_Box_Inventory" style="width:99.6%;">
      <div class="content" style="text-align: center;"> 
          <table style="width: 954px">
              <tr>
                  <td style="width: 100px">
                   <div style="display:none;">   <asp:CheckBox ID="chkDiscount" runat="server" Text="Discounted Patient" />
				   </div>
				   </td>
                  <td style="width: 100px; text-align: right">
                      Minimum Amount per receipt</td>
                  <td style="width: 100px; text-align: left">
                      <asp:TextBox ID="txtMinAmount" runat="server" Width="50px">100</asp:TextBox></td>
                  <td style="width: 100px">
          <asp:Button ID="btnShow" runat="server" Width="160px" Text="Show Data" OnClick="btnShow_Click"/></td>
              </tr>
          </table>
          <asp:Label ID="lblNewPanel" runat="server" ForeColor="green"></asp:Label>  
      </div>
   </div>
    <div class="Outer_Box_Inventory" style="width:99.6%">
                <div class="Purchaseheader">
                    Account Detail :</div>
                <div class="content" style="text-align: left;">
                <table>
                <tr style="width:1000px;"><td style="width:250px;"></td><td style="width:250px;">
                    <asp:Label ID="Label1" runat="server" CssClass="Purchaseheader" Height="17px" Text="All"
                        Width="250px"></asp:Label></td>
                <td style="width:250px;">
                    <asp:Label ID="Label2" runat="server" CssClass="Purchaseheader" Height="17px" Text="Editable Patients"
                        Width="250px"></asp:Label></td><td style="width:250px;">
                    <asp:Label ID="Label3" runat="server" CssClass="Purchaseheader" Height="17px" Text="After new Panel "
                        Width="161px"></asp:Label></td></tr>
                    <tr style="width: 1000px">
                        <td style="width: 250px; height: 23px">
                            <asp:Label ID="Label5" runat="server" CssClass="Purchaseheader" Height="17px" Text="Total Patients"
                                Width="250px"></asp:Label></td>
                        <td style="width: 250px; height: 23px">
                            <asp:Label ID="lblPtCountAll" runat="server"></asp:Label></td>
                        <td style="width: 250px; height: 23px">
                            <asp:Label ID="lblEditCountEt" runat="server"></asp:Label></td>
                        <td style="width: 250px; height: 23px">
                            <asp:Label ID="lblPtCountNewPnl" runat="server"></asp:Label></td>
                    </tr>
                 <tr style="width:1000px;"><td style="width:250px; height: 23px;"><asp:Label ID="lblGrossAmtHead" runat="server" CssClass="Purchaseheader" Height="17px" Text="Gross Amount"
                         Width="250px"></asp:Label></td><td style="width:250px; height: 23px;">
                             <asp:Label ID="lbGrossAmtAll" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width:250px; height: 23px;">
                    <asp:Label ID="lblGrossAmtEditPt" runat="server"></asp:Label></td><td style="width:250px; height: 23px;">
                    <asp:Label ID="lblGrossAmtNewPnl" runat="server" Font-Bold="True"></asp:Label></td></tr>
                 <tr style="width:1000px;"><td style="width:250px;">
                     <asp:Label ID="lblDiscAmountHead" runat="server" CssClass="Purchaseheader" Height="17px" Text="Disc Amount"
                         Width="250px"></asp:Label></td><td style="width:250px;">
                             <asp:Label ID="lblDiscAmtAll" runat="server"></asp:Label></td>
                <td style="width:250px;">
                    <asp:Label ID="lblDiscAmtEditPt" runat="server"></asp:Label></td><td style="width:250px;">
                    <asp:Label ID="lblDiscAmtNewPnl" runat="server"></asp:Label></td></tr>
                 <tr style="width:1000px;"><td style="width:250px;">
                         <asp:Label ID="lblNetAmountHead" runat="server" CssClass="Purchaseheader" Height="14px"  Text="Net Amount"
                             Width="250px"></asp:Label></td><td style="width:250px;">
                                 <asp:Label ID="lblNetAmtAll" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width:250px;">
                    <asp:Label ID="lblNetAmtEditPt" runat="server"></asp:Label></td><td style="width:250px;">
                    <asp:Label ID="lblNetAmtNewPnl" runat="server"></asp:Label></td></tr>
                 <tr style="width:1000px;"><td style="width:250px;"></td><td style="width:250px;"></td>
                <td style="width:250px; text-align: right;">
                   </td><td style="width:250px;">
                       <div style="display:none;">    <asp:TextBox ID="txtDisc" runat="server"  Width="100px" ></asp:TextBox>
					   </div>
					   </td></tr>
                    <tr style="width: 1000px">
                        <td style="width: 250px">
                            <asp:Label ID="Label6" runat="server" CssClass="Purchaseheader" Height="14px" Text="Final Gross Amount"
                                Width="250px"></asp:Label></td>
                        <td style="width: 250px">
                            <asp:Label ID="lblGrossAmtAllFinal" runat="server" Font-Bold="True" ForeColor="DarkBlue"></asp:Label></td>
                        <td style="width: 250px">
                        </td>
                        <td style="width: 250px">
                        </td>
                    </tr>
                 <tr style="width:1000px;"><td style="width:250px;">
                     <asp:Label ID="Label4" runat="server" CssClass="Purchaseheader" Height="14px" Text="Final Net Amount"
                         Width="250px"></asp:Label></td><td style="width:250px;">
                             <asp:Label ID="lblNetAmtAllFinal" runat="server" Font-Bold="True" ForeColor="Navy"></asp:Label></td>
                <td style="width:250px;">
                    <strong></strong></td><td style="width:250px;">
                    <asp:Label ID="lblNetAmtNewPnlFinal" runat="server" Font-Bold="True"></asp:Label></td></tr>
                    <tr style="width: 1000px">
                        <td style="width: 250px">
                            <asp:Label ID="lblTotalCashHead" runat="server" CssClass="Purchaseheader" Height="14px"
                                Text="Total Cash" Width="250px"></asp:Label></td>
                        <td style="width: 250px">
                            <asp:Label ID="lblTotalCash" runat="server" Font-Bold="True" ForeColor="#004000"></asp:Label></td>
                        <td style="width: 250px">
                        </td>
                        <td style="width: 250px">
                        </td>
                    </tr>
                    <tr style="width: 1000px">
                        <td style="width: 250px">
                            <asp:Label ID="Label7" runat="server" CssClass="Purchaseheader" Height="14px" Text="Cash After Utility"
                                Width="250px"></asp:Label></td>
                        <td style="width: 250px">
                            <asp:Label ID="lblCashAfterUtility" runat="server" Font-Bold="True" ForeColor="#004000"></asp:Label></td>
                        <td style="width: 250px">
                        </td>
                        <td style="width: 250px">
                        </td>
                    </tr>
                </table>
                
                    </div>
            </div>
   <div class="POuter_Box_Inventory" style="width:99.6%;">
      <div class="content" style="text-align: center;"> 
          <asp:Button ID="btnSave" runat="server" Width="160px" Text="Upload Data" OnClick="btnSave_Click"/>  
      </div>
   </div>   
   </div>
</asp:Content>

