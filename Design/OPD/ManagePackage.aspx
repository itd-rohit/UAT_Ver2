<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManagePackage.aspx.cs" Inherits="Design_OPD_ManagePackage" Title="Untitled Page" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Package Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Package Details</div>

            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 13%; text-align: right"></td>
                    <td  style="width: 35%; text-align: left">
                        <asp:RadioButtonList ID="rbtNewEdit" runat="server" Font-Bold="True" Font-Names="Verdana"
                            RepeatDirection="Horizontal" OnSelectedIndexChanged="rbtNewEdit_SelectedIndexChanged" AutoPostBack="True">
                            <asp:ListItem Selected="True" Value="1">New</asp:ListItem>
                            <asp:ListItem Value="2">Edit</asp:ListItem>
                        </asp:RadioButtonList></td>
                    <td  style="width: 35%; text-align: right">
                        <asp:Label ID="lblab" runat="server" Text="Last Test Code :" Style="color: red; font-weight: bold;"></asp:Label>
                        <asp:Label ID="lastcode" runat="server" Style="color: red; font-weight: bold;"></asp:Label>
                    </td>
                    <td style="text-align: left">&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">&nbsp;</td>
                </tr>

                <tr>
                    <td style="width: 13%; text-align: right">Package :&nbsp;
                    </td>
                    <td  style="width: 35%; text-align: left" colspan="2">
                        <asp:DropDownList ID="ddlPackage" runat="server" AutoPostBack="True" CssClass="ItDoseDropdownbox"
                            OnSelectedIndexChanged="ddlPackage_SelectedIndexChanged" TabIndex="6" Width="472px">
                        </asp:DropDownList>
                        <asp:TextBox ID="txtPkg" runat="server" Width="473px"></asp:TextBox>
                        <asp:RequiredFieldValidator Display="none" ID="RequiredFieldValidator1" ControlToValidate="txtPkg" runat="server" ErrorMessage="Package Name"
                            SetFocusOnError="True" ValidationGroup="save"></asp:RequiredFieldValidator></td>
                    <td style="width: 15%; text-align: right">
                        <%-- Amount :&nbsp;--%>
                                TestCode :</td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="ItDoseTextinputText" Font-Bold="True"
                            Height="15px" Width="151px" Style="display: none;"></asp:TextBox>
                        <asp:TextBox ID="txttestcode" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">Billing&nbsp;Category&nbsp;:&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlbillcategory" runat="server" Style="margin-left: 0px">
                            <asp:ListItem Value="0">Routine</asp:ListItem>
                            <asp:ListItem Value="1">Special</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 13%; text-align: right"></td>
                    <td style="text-align: left">

                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="True" Text="IsActive" />
                    </td>
                    <td  style="width: 35%; text-align: left" colspan="2">&nbsp;
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                &nbsp; &nbsp;&nbsp;</td>
                    <td style="width: 15%; text-align: right">&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">&nbsp;</td>
                </tr>
            </table>
        </div>
        <asp:ValidationSummary ValidationGroup="save" ShowMessageBox="true" ShowSummary="false" ID="ValidationSummary1" runat="server" />

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Investigation :
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="width: 34%; text-align: right">Investigations :&nbsp;  </td>
                    <td style="width: 85%; text-align: left;">
                        <asp:DropDownList ID="ddlInv" runat="server" Width="400px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 85%; text-align: left">
                        <asp:Button ID="btnAddInv" runat="server" AccessKey="r" CssClass="ItDoseButton"
                            TabIndex="8" Text="Add Investigation" Width="170px" OnClick="btnAddInv_Click" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 34%;text-align:right">Package :&nbsp;</td>
                    <td style="width: 85%;">
                        <asp:DropDownList ID="ddlSubPackage" runat="server" Width="400px">
                        </asp:DropDownList></td>
                    <td style="width: 85%;">
                        <asp:Button ID="btnAddSubPackage" runat="server" AccessKey="r" CssClass="ItDoseButton" Height="27px"
                            TabIndex="8" Text="Add Package" Width="170px" OnClick="btnAddSubPackage_Click" /></td>
                </tr>

                <tr>
                    <td style="width: 34%">&nbsp;
                    </td>
                    <td colspan="2" style="width: 85%">
                        <div style="overflow: auto; padding: 3px; width: 790px; height: 160px;">
                            <asp:CheckBoxList ID="chkInv" runat="server" RepeatColumns="5">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                    <td style="width: 85%;">&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="3">&nbsp;</td>
                </tr>

            </table>
        </div>


        <div class="POuter_Box_Inventory" style="width: 969px; display: none">
            <div class="Purchaseheader">
                Package Doctor&nbsp;
            </div>

            <table style="width: 100%">
                <tr>
                    <td style="width: 34%; text-align: right">Add New Doctor :  </td>
                    <td style="width: 85%;">
                        <asp:DropDownList ID="ddlDoctor" runat="server" Width="294px">
                        </asp:DropDownList>
                        <asp:Button ID="btnAdd" runat="server" AccessKey="r" CssClass="ItDoseButton"
                            TabIndex="8" Text="Add" Width="76px" OnClick="btnAdd_Click" /></td>
                    <td style="width: 85%;"></td>
                </tr>
                <tr>
                    <td style="width: 34%; text-align: right">Doctors :&nbsp;
                    </td>
                    <td colspan="2" style="width: 85%; text-align: left">
                        <div style="overflow: auto; padding: 3px; width: 790px; height: 160px;">
                            <asp:CheckBoxList ID="chldoctor" runat="server" RepeatColumns="5">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center" colspan="3">&nbsp;</td>
                </tr>

            </table>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ValidationGroup="save" ID="butSave" runat="server" AccessKey="r" CssClass="ItDoseButton"
                TabIndex="8" Text="Save" OnClick="butSave_Click" />
        </div>
    </div>
</asp:Content>
