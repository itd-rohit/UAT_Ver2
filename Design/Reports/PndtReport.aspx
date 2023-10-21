<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PndtReport.aspx.cs" Inherits="Reports_Forms_PndtReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div id="POuter_Box_Inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>PNDT Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Report Criteria
                </div>
                <div class="row" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">From Date   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtFromDate" runat="server" Width="100px" Text=""></asp:TextBox>
                                <asp:Image ID="Image1" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                                <cc1:CalendarExtender ID="Calendar1" PopupButtonID="Image1" runat="server" TargetControlID="txtFromDate" Format="yyyy-MM-dd"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">To Date    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtToDate" runat="server" CssClass="inputtext1" Width="100px" />
                                <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                                <cc1:CalendarExtender ID="CalendarExtender1" PopupButtonID="imgdtFrom" runat="server" TargetControlID="txtToDate" Format="yyyy-MM-dd"></cc1:CalendarExtender>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="col-md-24">
                    <div class="row">
                        <asp:Button ID="btnSearch" OnClick="btnSearch_Click" runat="server" Text="Excel Report" CssClass="ItDoseButton" Width="196px" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

