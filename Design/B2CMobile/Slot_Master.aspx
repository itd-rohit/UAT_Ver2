<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Design/B2CMobile/Slot_Master.aspx.cs" Inherits="Design_B2CMobile_Slot_Master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top: -52px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>

        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align:center">
                <b>Slot Master</b>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Banner Details
                </div>
                <div class="row">
                    <div class="col-md-2">
                        <label class="pull-left">Start Time   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlStartTime" runat="server">
                            <asp:ListItem Text="06:00" Value="06:00"></asp:ListItem>
                            <asp:ListItem Text="06:30" Value="06:30"></asp:ListItem>
                            <asp:ListItem Text="07:00" Value="07:00"></asp:ListItem>
                            <asp:ListItem Text="07:30" Value="07:30"></asp:ListItem>
                            <asp:ListItem Text="08:00" Value="08:00"></asp:ListItem>
                            <asp:ListItem Text="08:30" Value="08:30"></asp:ListItem>
                            <asp:ListItem Text="09:00" Value="09:00"></asp:ListItem>
                            <asp:ListItem Text="09:30" Value="09:30"></asp:ListItem>
                            <asp:ListItem Text="10:00" Value="10:00"></asp:ListItem>
                            <asp:ListItem Text="10:30" Value="10:30"></asp:ListItem>
                            <asp:ListItem Text="11:00" Value="11:00"></asp:ListItem>
                            <asp:ListItem Text="11:30" Value="11:30"></asp:ListItem>
                            <asp:ListItem Text="12:00" Value="12:00"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">End Time   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlEndTime" runat="server">
                            <asp:ListItem Text="06:00" Value="06:00"></asp:ListItem>
                            <asp:ListItem Text="06:30" Value="06:30"></asp:ListItem>
                            <asp:ListItem Text="07:00" Value="07:00"></asp:ListItem>
                            <asp:ListItem Text="07:30" Value="07:30"></asp:ListItem>
                            <asp:ListItem Text="08:00" Value="08:00"></asp:ListItem>
                            <asp:ListItem Text="08:30" Value="08:30"></asp:ListItem>
                            <asp:ListItem Text="09:00" Value="09:00"></asp:ListItem>
                            <asp:ListItem Text="09:30" Value="09:30"></asp:ListItem>
                            <asp:ListItem Text="10:00" Value="10:00"></asp:ListItem>
                            <asp:ListItem Text="10:30" Value="10:30"></asp:ListItem>
                            <asp:ListItem Text="11:00" Value="11:00"></asp:ListItem>
                            <asp:ListItem Text="11:30" Value="11:30"></asp:ListItem>
                            <asp:ListItem Text="12:00" Value="12:00"></asp:ListItem>
                            <asp:ListItem Text="12:30" Value="12:30"></asp:ListItem>
                            <asp:ListItem Text="13:00" Value="13:00"></asp:ListItem>
                            <asp:ListItem Text="13:30" Value="13:30"></asp:ListItem>
                            <asp:ListItem Text="14:00" Value="14:00"></asp:ListItem>
                            <asp:ListItem Text="14:30" Value="14:30"></asp:ListItem>
                            <asp:ListItem Text="15:00" Value="15:00"></asp:ListItem>
                            <asp:ListItem Text="15:30" Value="15:30"></asp:ListItem>
                            <asp:ListItem Text="16:00" Value="16:00"></asp:ListItem>
                            <asp:ListItem Text="16:30" Value="16:30"></asp:ListItem>
                            <asp:ListItem Text="17:00" Value="17:00"></asp:ListItem>
                            <asp:ListItem Text="17:30" Value="17:30"></asp:ListItem>

                            <asp:ListItem Text="18:00" Value="18:00"></asp:ListItem>
                            <asp:ListItem Text="18:30" Value="18:30"></asp:ListItem>
                            <asp:ListItem Text="19:00" Value="19:00"></asp:ListItem>
                            <asp:ListItem Text="19:30" Value="19:30"></asp:ListItem>

                            <asp:ListItem Text="20:00" Value="20:00"></asp:ListItem>
                            <asp:ListItem Text="20:30" Value="20:30"></asp:ListItem>
                            <asp:ListItem Text="21:00" Value="21:00"></asp:ListItem>
                            <asp:ListItem Text="21:30" Value="21:30"></asp:ListItem>

                            <asp:ListItem Text="22:00" Value="22:00"></asp:ListItem>
                            <asp:ListItem Text="22:30" Value="22:30"></asp:ListItem>
                            <asp:ListItem Text="23:00" Value="23:00"></asp:ListItem>
                            <asp:ListItem Text="23:30" Value="23:30"></asp:ListItem>

                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Gapping (Min) </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="dllGappingSlot" runat="server">
                            <asp:ListItem Text="15" Value="15"></asp:ListItem>
                            <asp:ListItem Text="30" Value="30"></asp:ListItem>
                            <asp:ListItem Text="45" Value="45"></asp:ListItem>
                            <asp:ListItem Text="60" Value="60"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <asp:Button ID="BtnSaveSlot" runat="server" Text="Save" Width="120px" OnClick="BtnSaveSlot_Click" CssClass="savebutton" />
                    </div>
                </div>
                <div class="row" style="display: none">
                    <div class="col-md-3">
                        <label class="pull-left">No Of Slots   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:Label ID="lblNoOfSlots" runat="server" Text="No Of Slots:" Width="100px  "></asp:Label>
                        <asp:TextBox ID="txtNoOfSlots" runat="server" Text="1" Width="117px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="s" runat="server" FilterType="Numbers" TargetControlID="txtNoOfSlots"></cc1:FilteredTextBoxExtender>
                    </div>
                </div>
                <div class="row" style="display: none">
                    <div class="col-md-3">
                        <asp:Label ID="lblManageHoliday" runat="server" Font-Bold="true" Text="Manage Holiday:" Width="200px"></asp:Label>
                    </div>
                </div>
                <div class="row" style="display: none">
                    <div class="col-md-3">
                        <asp:Calendar ID="Calendar1" runat="server" BackColor="White" BorderColor="White"
                            BorderWidth="1px" Font-Names="Verdana" Font-Size="9pt" ForeColor="Black"
                            Height="190px" NextPrevFormat="FullMonth" ShowNextPrevMonth="false" OnPreRender="Calendar1_PreRender"
                            Width="950px" OnSelectionChanged="Calendar1_SelectionChanged"
                            OnDayRender="Calendar1_DayRender">
                            <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
                            <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333"
                                VerticalAlign="Bottom" />
                            <OtherMonthDayStyle ForeColor="#999999" />
                            <SelectedDayStyle BackColor="#333399" ForeColor="White" />
                            <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px"
                                Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
                        </asp:Calendar>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <asp:GridView ID="GrdSlots" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" Width="100%" OnSelectedIndexChanged="GrdSlots_SelectedIndexChanged">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <RowStyle CssClass="GridViewItemStyle" />
                            <Columns>
                                <asp:BoundField DataField="StartTime" HeaderText="Start Time">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EndTime" HeaderText="End Time">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AvgTimeMin" HeaderText="Avg Time (Min)">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>


            </div>
        </div>
    </form>
</body>
</html>

