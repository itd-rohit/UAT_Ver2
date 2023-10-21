<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TatTransfer.aspx.cs" Inherits="Design_Investigation_TatTransfer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="Pbody_box_inventory" style="width: 992px; text-align: left;">
        <div class="Outer_Box_Inventory" style="width: 986px;">
            <div class="content">
                <div style="text-align: center;">
                    <b>TAT Transfer<br />
                    </b>
                    <asp:Label ID="lblStatus" runat="server" CssClass="ItDoseLblError" Text="" />
                </div>

            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 987px;">
            <div class="Purchaseheader">
                Select Department
            </div>
            <table style="width: 953px">
                <tr>
                    <td align="right" style="width: 179px; height: 12px" valign="middle" class="ItDoseLabel">
                        <asp:Label ID="lblMasterType" runat="server" Text="Master Type :" Font-Bold="true" ForeColor="green"></asp:Label>
                    </td>
                    <td align="left" style="height: 12px" valign="middle" colspan="4">
                        <asp:RadioButtonList ID="rblMasterType" runat="server" RepeatDirection="horizontal" AutoPostBack="TRUE" OnSelectedIndexChanged="rblMasterType_SelectedIndexChanged">
                            <asp:ListItem Text="TAT" Selected="true" Value="TAT"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>

                <tr id="Tr1" runat="server">
                    <td align="right" style="width: 179px; height: 22px" valign="middle" class="ItDoseLabel">
                        <asp:Label ID="lblsourceCentre" runat="server" Text="Source Centre : " Font-Bold="true" ForeColor="green"></asp:Label>
                        &nbsp;
                    </td>
                    <td align="left" style="width: 334px; height: 22px" valign="middle">

                        <asp:DropDownList ID="ddlSourceCentre" runat="server" CssClass="ItDoseDropdownbox" Width="245px" >
                        </asp:DropDownList></td>
                    <td align="right" style="font-size: 8pt; width: 200px; color: #000000; font-family: Verdana; height: 13px; text-align: center"
                        valign="middle">
                        <asp:Image ID="Image3" runat="server" ImageUrl="../../App_Style/images/TRY6_25.gif" />
                    </td>


                    <td align="right" style="font-size: 8pt; width: 176px; color: #000000; font-family: Verdana; height: 22px; text-align: right;"
                        valign="middle">&nbsp;<asp:Label ID="lblTargetCentre" runat="server" Text="Target Centre : " Font-Bold="true" ForeColor="green"></asp:Label></td>
                    <td align="left" valign="middle" style="height: 22px; width: 392px;">
                        <asp:DropDownList ID="ddlTargetCentre" runat="server" CssClass="ItDoseDropdownbox" Width="254px" >
                        </asp:DropDownList></td>
                </tr>
                <tr id="Tr2" runat="server">
                    <td align="right" class="ItDoseLabel" style="width: 179px; height: 13px" valign="middle">
                        <asp:Label ID="lblDept" runat="server" Font-Bold="true" ForeColor="green" Text="Department : "></asp:Label></td>
                    <td align="left" style="width: 334px; height: 13px" valign="middle">
                        <asp:DropDownList ID="ddlDept" runat="server" CssClass="ItDoseDropdownbox" Width="244px"  OnSelectedIndexChanged="ddlDept_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td align="right" style="font-size: 8pt; width: 200px; color: #000000; font-family: Verdana; height: 13px; text-align: center"
                        valign="middle"></td>
                    <td align="right" style="font-size: 8pt; width: 176px; color: #000000; font-family: Verdana; height: 13px; text-align: right"
                        valign="middle"></td>
                    <td align="left" style="width: 392px" valign="middle"></td>
                </tr>
            </table>
        </div>
        <div class="Outer_Box_Inventory" style="width: 987px; text-align: center">
            <asp:Button ID="btnsave" runat="server" Text="Transfer" OnClick="btnsave_Click" Style="cursor: pointer;" CssClass="ItDoseButton" />
        </div>
    </div>
</asp:Content>

