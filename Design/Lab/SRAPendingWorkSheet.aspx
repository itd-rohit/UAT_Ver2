



<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SRAPendingWorkSheet.aspx.cs" Inherits="Design_Lab_SRAPendingWorkSheet" %>



<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />


   
<Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>


     <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>SRA Pending WorkList</b><br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />      
    </div>
    </div> 
    
    <div class="POuter_Box_Inventory">
          <div class="Purchaseheader">
              Search</div>
        <div class="content"> 
        <table style="width: 956px">
              <tr>
                <td style="width: 136px; text-align: right;">
                    <b>Centre :</b></td>
                <td colspan="3">
                     <asp:DropDownList ID="ddlcentre" runat="server" class="ddlcentre  chosen-select chosen-container" Width="400px" >
                              </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    <b>Date From :</b></td>
                <td style="width: 250px">
                   <asp:TextBox ID="txtFormDate"  runat="server"  Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtFormDate" />
                </td>
                <td style="width: 250px;text-align:right; font-weight: 700;">
                    To Date :&nbsp; </td>
                 <td style="width: 250px;">
                   <asp:TextBox ID="txtToDate"    runat="server"   Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtToDate" />
                </td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    <b>
                   <asp:Label ID="lblLabNo" Text="Visit No" runat="server"></asp:Label>&nbsp;:</b></td>
                <td style="width: 250px">
                     <asp:TextBox ID="txtLabNo" runat="server"></asp:TextBox></td>
                <td style="width: 250px;text-align:right; font-weight: 700;">
                    SIN NO :&nbsp;
                  </td>
                 <td style="width: 250px;">
                
                     <asp:TextBox ID="txtsinno" runat="server"></asp:TextBox>  </td>
            </tr>
            <tr style="display:none;">
                <td style="width: 136px; text-align: right; font-weight: 700;">
                    Report Type :</td>
                <td style="width: 250px">
                     <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal">
                         <asp:ListItem >PDF</asp:ListItem>
                         <asp:ListItem Selected="True">Excel</asp:ListItem>
                     </asp:RadioButtonList></td>
                <td style="width: 250px;text-align:right; font-weight: 700;">
                    &nbsp;</td>
                 <td style="width: 250px;">
                
                     &nbsp;</td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    &nbsp;</td>
                <td style="width: 250px">
                     &nbsp;</td>
                <td style="width: 250px;text-align:right; font-weight: 700;">
                    &nbsp;</td>
                 <td style="width: 250px;">
                
                     &nbsp;</td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="4">

                    <asp:Button ID="btn" runat="server" CssClass="searchbutton" Text="Search" OnClick="btn_Click" />
                
            </tr>
   
        </table>
    </div>

        </div>
         </div>
        </asp:Content>


