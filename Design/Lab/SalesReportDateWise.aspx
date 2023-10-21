<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SalesReportDateWise.aspx.cs" Inherits="Design_OPD_SalesReportDateWise" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
     <ajax:scriptmanager ID="ScriptManager2" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 
    <div id= "Pbody_box_inventory">
<div class="POuter_Box_Inventory">
<div class="content" style="text-align:center;">   
<b>Sales Report Date Wise </b>&nbsp;<br />
<asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

</div> 
</div>
<div class="POuter_Box_Inventory" >
        <div class="Purchaseheader" >

            </div>
    <table width="99%">
        <tr>
            <td style="text-align: right; font-weight: 700; width: 331px;">
                From Date::
            </td>
            <td>
               <asp:TextBox ID="txtfromdate" runat="server" Width="100px" />
                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
    TargetControlID="txtfromdate"
    Format="dd-MMM-yyyy"
    PopupButtonID="txtfromdate" /> 
            </td>

            <td style="text-align: right">
                To Date::
            </td>
            <td>
                 <asp:TextBox ID="txttodate" runat="server" Width="100px" />
                <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
    TargetControlID="txttodate"
    Format="dd-MMM-yyyy"
    PopupButtonID="txttodate" /> 
            </td>
        </tr>
        <tr>
            <td style="text-align: right; font-weight: 700; width: 331px;">Type::</td>
            <td colspan="3">
               <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal" OnSelectedIndexChanged="rd_SelectedIndexChanged" AutoPostBack="true">
                   <asp:ListItem Selected="True" Value="0">Department Wise</asp:ListItem>
                    <asp:ListItem Value="1">Test Wise</asp:ListItem>
                   <asp:ListItem Value="2">PCC Registration</asp:ListItem>
                   <asp:ListItem Value="3">RateType</asp:ListItem>
               </asp:RadioButtonList>
            </td>
        </tr>

        <tr id="mytr" runat="server" visible="false">
            <td style="text-align: right; font-weight: 700; width: 331px;">Department::</td>
            <td colspan="2"><asp:DropDownList ID="ddldepartment" runat="server"></asp:DropDownList> </td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center; font-weight: 700">
                
            <asp:Button ID="btnsearch" runat="server" Text="Get Report" OnClick="btnsearch_Click" Font-Bold="true" />

&nbsp;&nbsp;
                <asp:Button ID="btnExport" OnClick="btnExport_Click" runat="server" Text="Export To Excel" Font-Bold="true"  />
            </td>
        </tr>
    </table>
    </div>

        <div class="POuter_Box_Inventory" >
            <table style="width:100%">
                <tr>
                    <td>
                        <div style="width:992px;height:420px;overflow:scroll;">
                            <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True" ShowFooter="true">
                              <FooterStyle BackColor="#006699"  Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            </asp:GridView>
                        </div>
                    </td>
                </tr>
            </table>
            </div>
        </div>
        
              </ContentTemplate>

           <Triggers>
        <Ajax:PostBackTrigger ControlID="btnExport" />
    </Triggers>
      </Ajax:UpdatePanel> 
</asp:Content>

