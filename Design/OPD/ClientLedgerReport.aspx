<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ClientLedgerReport.aspx.cs" Inherits="Design_OPD_ClientLedgerReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" language="javascript" src="../../Design/Common/popcalendar.js"></script>
<script type="text/javascript" src="../../JavaScript/jquery-1.3.2.min.js"></script>

<script language="javascript" type="text/javascript"> 
  
</script>


 <div id="Pbody_box_inventory"  >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>&nbsp;<Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
        <Services>
            <Ajax:ServiceReference Path="~/Lis.asmx" />
        </Services>
    </Ajax:ScriptManager>
        Client Ledger Report</b>&nbsp;<br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
    </div>
    </div>
      <div class="POuter_Box_Inventory" >
     <div class="Purchaseheader">
     Report Critaria</div>
    <div class="content"> 
              
                     


        <table >
            <tr>

                <td style="width: 134px">Date From :</td>
                <td>
                                 <asp:TextBox ID="txtFromDate" runat="server" CssClass="inputtext1" Width="100px"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="ce_dtfrom"
    TargetControlID="txtFromDate"
    Format="dd-MMM-yyyy"
    PopupButtonID="imgdtFrom" />
                                 
                                   <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                </td>
                <td style="width: 170px">Date
                                 To :</td>
                <td>
                                 <asp:TextBox ID="txtToDate" runat="server" CssClass="inputtext1" Width="100px"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="ce_dtTo"
    TargetControlID="txtToDate"
    Format="dd-MMM-yyyy"
    PopupButtonID="imgdtTo" />
                                 
                                   <asp:Image ID="imgdtTo" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                </td>
            </tr>
         <tr style="display:none">

                <td style="width: 134px">Centre :</td>
                <td colspan="3">

                   
                                 <asp:CheckBoxList ID="chkCentre" runat="server" RepeatColumns="2" RepeatDirection="Horizontal">
                                 </asp:CheckBoxList>

                </td>
            </tr>
      <tr>
          <td style="width:134px">
              Report:
          </td>
          <td >
              <asp:RadioButtonList ID="rblReporttype" runat="server" RepeatDirection="Horizontal">
                  <asp:ListItem Value="0" Selected="True">Detail</asp:ListItem>
                  <asp:ListItem Value="1">Summary</asp:ListItem>
                   
              </asp:RadioButtonList>
          </td>
            <td style="width: 170px"></td>
          <td>
               <asp:RadioButtonList ID="rbltype" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rbltype_SelectedIndexChanged" AutoPostBack="true">
                     <asp:ListItem Value="1">Only Cash </asp:ListItem>
                  <asp:ListItem Value="2">Only Credit </asp:ListItem>
               </asp:RadioButtonList>
          </td>
      </tr>
             </div>
           
      

        </table>
   
    </div>
    </div>
     
     <div class="POuter_Box_Inventory" style="text-align:left; ">
         <div class="Purchaseheader">
             Select Panel:
              <asp:LinkButton ID="btnSelectAll" runat="server" OnClick="btnSelectAll_Click">Select All</asp:LinkButton></div>
     <div style="overflow:scroll;height:150px; text-align: left; border:solid 1px" id="DIV1" onclick="return DIV1_onclick()" >
    <asp:CheckBoxList ID="chkPanel" runat="server" AutoPostBack="true" OnSelectedIndexChanged="chkPanel_SelectedIndexChanged" RepeatColumns="4" RepeatDirection="Horizontal">
        </asp:CheckBoxList>
        </div>        
        </div>
     <div class="POuter_Box_Inventory" style="text-align:center; ">
    <asp:Button ID="btnSearch" runat="server" Text="PDF Report" CssClass="ItDoseButton"  OnClick="btnSearch_Click" />
         &nbsp;&nbsp;
         
    </div>
   
</asp:Content>

