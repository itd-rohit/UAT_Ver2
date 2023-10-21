<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleIssueReport.aspx.cs" Inherits="Design_SampleStorage_SampleIssueReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

     <div id="Pbody_box_inventory">
 <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Sample Issue Report</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
          <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Search&nbsp;
                    </div>
               
                   <div class="row">
                       <div class="col-md-2"></div>
                       <div class="col-md-3" style="text-align: right">
                           <label class="pull-left">Issue Date From   </label>
			                <b class="pull-right">:</b>
                       </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtdatefrom" runat="server"></asp:TextBox>
                              <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtdatefrom" PopupButtonID="txtdatefrom" />
                        </div>
                       <div class="col-md-2"></div>
                        <div class="col-md-3" style="text-align: right">
                            <label class="pull-left">Issue Date To   </label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtdateo" runat="server"></asp:TextBox>
                              <cc1:calendarextender ID="Calendarextender1" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtdateo" PopupButtonID="txtdateo" />
                        </div>

                       </div>
                   <div class="row">
                       <div class="col-md-10"></div>
                       <div class="col-md-2" style="text-align: center">
                           <asp:Button ID="btn" runat="server" CssClass="searchbutton" Text="Search" OnClick="btn_Click" />  </div>
                       </div>
              </div>
         </div>
</asp:Content>

