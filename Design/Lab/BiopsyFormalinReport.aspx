<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BiopsyFormalinReport.aspx.cs" Inherits="Design_OPD_Default" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
     <ajax:scriptmanager ID="ScriptManager2" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading
                 <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 
    <div id= "Pbody_box_inventory">
<div class="POuter_Box_Inventory">
<div class="content" style="text-align:center;">   
<b>Biopsy Report(with or without fomalin)</b>&nbsp;<br />
<asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

</div> 
</div>
<div class="POuter_Box_Inventory" >
        <div class="Purchaseheader" >

            </div>
    <table width="99%">
        <tr>
            <td style="text-align: left; font-weight: 700; width:100px;">
                From Date::
            </td>
            <td style="text-align:left">
               <asp:TextBox ID="txtfromdate" runat="server" Width="100px"  />
                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
    TargetControlID="txtfromdate"
    Format="dd-MMM-yyyy"
    PopupButtonID="txtfromdate" /> 
            </td>

            <td style="text-align: left; font-weight: 700;width:100px;">
                To Date::
            </td>
            <td style="text-align:left">
                 <asp:TextBox ID="txttodate" runat="server" Width="100px"  style="text-align:left" />
                <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
    TargetControlID="txttodate"
    Format="dd-MMM-yyyy"
    PopupButtonID="txttodate" /> 
            </td>
        </tr>

        <tr >
             <td style="text-align: left; font-weight: 700;width:100px;"> Centre::</td>
            <td style="text-align:left"><asp:DropDownList ID="ddlcentre" runat="server" Width="150px"></asp:DropDownList></td>
            <td style="text-align: left; font-weight: 700; width: 100px;">Formalin::</td>
            <td style="text-align:left"><asp:DropDownList ID="ddlFieldBoy" runat="server" Width="150px" style="display:none;"></asp:DropDownList>
                <asp:DropDownList ID="ddlFormalin" runat="server">
                    <asp:ListItem Value="-1">All</asp:ListItem>
                    <asp:ListItem Value="1">With Formalin</asp:ListItem>
                    <asp:ListItem Value="0">Without Formalin</asp:ListItem>

                </asp:DropDownList>
            </td>
           
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
                            <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True" ShowFooter="true"  >
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

