<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="UserManager.aspx.cs" Inherits="Design_EDP_UserManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />




    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" >
            <div class="content" style="text-align: center;">
                <b>Role Management</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            
                <div class="row">
                    <div class="col-md-3">
                        </div>
                    <div class="col-md-2">
                        <label class="pull-left">Privilege</label>
                    <b class="pull-right">:</b>
                        
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="ddlRole chosen-select chosen-container" />
                    </div>
                    <div class="col-md-9">
                        <asp:Button ID="btnUser" runat="server" Text="Search" OnClick="btnUser_Click"  CausesValidation="False" OnClientClick="return searchDisable()"/>
                        <asp:Button ID="btnRole" runat="server" Text="New Role" CssClass="ItDoseButton" Width="75px" CausesValidation="False" Visible="false" />
                        <asp:Button ID="Button1" runat="server" Text="Edit Role" CssClass="ItDoseButton" Width="75px" CausesValidation="False" Visible="false" />
                    </div>
                </div>
            </div>
       
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Users Detail
            </div>
            <div  style="text-align: center;">
                <div class="row">
                    <div class="col-md-24">
                        <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Height="500px">
                            <asp:GridView ID="grdRole" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" OnRowCommand="grdRole_RowCommand">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="Left" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("Name") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="User Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Eval("UserName") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Privilege" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/App_Images/login.png" CommandArgument='<%# Eval("Employee_ID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Login"  HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbLogin" runat="server" CausesValidation="false" CommandName="login" ImageUrl="~/App_Images/reg.jpg" Visible='<%# Util.GetBoolean(Eval("ltype")) %>' CommandArgument='<%# Eval("Employee_ID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Password" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbPassword" runat="server" CausesValidation="false" CommandName="Password" ImageUrl="~/App_Images/edit.png" Visible='<%# !Util.GetBoolean(Eval("ptype")) %>' CommandArgument='<%# Eval("Employee_ID") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </div>
                </div>

            </div>
        </div>
    </div>


    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CausesValidation="False" />
    </div>

    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlFilter" Style="display: none;">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Privilege Details
        </div>
        <div class="row">
            <div class="col-md-9">
                <label>
                    Employee</label>
            </div>
            <div class="col-md-15">
                <asp:Label ID="lblEmpName" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-9">
                <label>
                    Privilege</label>
            </div>
            <div class="col-md-15">
                <asp:DropDownList ID="ddlRoleRight" runat="server" CssClass="ItDoseLabel"></asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="filterOpDiv">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                        Text="Save" ValidationGroup="Save" Width="65px" CausesValidation="False" />
                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                        Text="Cancel" Width="65px" />
                </div>
            </div>

        </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server"
        CancelControlID="btnCancel"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlPassowrd" runat="server" CssClass="pnlFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div1" runat="server">
            Login Details
        </div>
        <div class="row">
            <div class="col-md-9">
                <label>
                    Name :</label>
            </div>
            <div class="col-md-15">
                <asp:Label ID="lblEmp" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-9">
                <label>
                    UserName :</label>
            </div>
            <div class="col-md-15">
                <asp:TextBox ID="txtUser" runat="server" CssClass="ItDoseLabel" ValidationGroup="Login"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rqPass" ValidationGroup="Login" runat="server" ControlToValidate="txtUser" ErrorMessage="Enter User Name"
                    Text="*" Display="None" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-9">
                <label>
                    Password :</label>
            </div>
            <div class="col-md-10">
                <asp:TextBox ID="txtPassword" ValidationGroup="Login" runat="server" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ValidationGroup="Login" ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword" ErrorMessage="Enter Password"
                    Text="*" Display="None" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-9">
                <label class="labelForPO">
                    Confirm Pwd :</label>
            </div>
            <div class="col-md-15">
                <asp:TextBox ID="txtConfirm" ValidationGroup="Login" runat="server" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
                <asp:CompareValidator ValidationGroup="Login" ID="CompareValidator2" runat="server" ControlToCompare="txtPassword"
                    ControlToValidate="txtConfirm" ErrorMessage="Confirm Passoword Not Match" SetFocusOnError="True" Display="None">*</asp:CompareValidator>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="filterOpDiv">
                    <asp:Button ID="btnSavePassword" ValidationGroup="Login" runat="server" CssClass="ItDoseButton" OnClick="btnSavePassword_Click"
                        Text="Save" Width="65px" />
                    <asp:Button ID="btnCancelPassword" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                        Text="Cancel" Width="55px" />
                </div>
            </div>
        </div>

    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server"
        CancelControlID="btnCancelPassword"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlPassowrd"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="Panel1" runat="server" CssClass="pnlFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div2" runat="server">
            Change Password
        </div>
        <div class="row">
            <div class="col-md-8">
                <label>
                    Name</label>
            </div>
            <div class="col-md-16">
                <asp:Label ID="lblemp1" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-8">
                <label>
                    Password</label>
            </div>
            <div class="col-md-16">
                <asp:TextBox ID="txtpwd" runat="server" ValidationGroup="Pwd" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-8">
                <label>
                    Confirm Pwd</label>
            </div>
            <div class="col-md-16">
                <asp:TextBox ID="txtcPwd" runat="server" ValidationGroup="Pwd" CssClass="ItDoseLabel" TextMode="Password"></asp:TextBox>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtpwd" ValidationGroup="Pwd"
                    ControlToValidate="txtcPwd" ErrorMessage="Confirm Passoword Not Match" SetFocusOnError="True"></asp:CompareValidator>
                <asp:RequiredFieldValidator ValidationGroup="Pwd" ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtpwd" ErrorMessage="Enter Password"
                    Text="*" Display="None" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="filterOpDiv">
                    <asp:Button ID="btnSavePwd" runat="server" CssClass="ItDoseButton" OnClick="btnSavePwd_Click"
                        Text="Save" ValidationGroup="Pwd" Width="65px" />
                    <asp:Button ID="btnCancel1" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                        Text="Cancel" Width="55px" />
                </div>
        </div>
        </div>


    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"
        CancelControlID="btnCancel1"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlRole" runat="server" CssClass="pnlFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div3" runat="server">
            New Role
        </div>
        <div class="content">
            <label class="labelForPO">
                Role :</label>
            <asp:TextBox ID="txtRole" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Specify Role" ControlToValidate="txtRole" Text="*" Display="None" ValidationGroup="role"></asp:RequiredFieldValidator>
            <div class="Purchaseheader" id="Div4" runat="server">
                Store PaidRole
            </div>
            <asp:RadioButtonList ID="rbtrolldeptlsit" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem>YES</asp:ListItem>
                <asp:ListItem Selected="True">NO</asp:ListItem>
            </asp:RadioButtonList><br />
            <br />
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnSaveRole" runat="server" CssClass="ItDoseButton" OnClick="btnSaveRole_Click"
                Text="Save" Width="65px" ValidationGroup="role" />
            <asp:Button ID="btnCancelRole" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" Width="55px" />

        </div>


    </asp:Panel>
<asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Login" />
<asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="Pwd" />

<asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="role" />
<cc1:ModalPopupExtender ID="MdpRole" runat="server"
    CancelControlID="btnCancelRole"
    DropShadow="true"
    TargetControlID="btnRole"
    BackgroundCssClass="filterPupupBackground"
    PopupControlID="pnlRole"
    PopupDragHandleControlID="dragHandle" >
</cc1:ModalPopupExtender>
            
        


    <asp:Panel ID="pnlUpdate1" runat="server" CssClass="pnlFilter" Width="500px" Style="display: none;">
        <div class="Purchaseheader" id="Div5" runat="server">
            Update Role 
        </div>
        <div class="content">
            <div style="height: 300px; overflow: scroll; width: 100%">

                <asp:GridView ID="rg" runat="server" Width="99%" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True">
                    <Columns>

                        <asp:TemplateField HeaderText="RoleName">

                            <ItemTemplate>
                                <asp:Label ID="lbroleid" runat="server" Text='<%# Bind("ID") %>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="RoleName">

                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("rolename") %>'></asp:Label>

                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IsStorePaid">

                            <ItemTemplate>
                                <asp:CheckBox ID="chkenbl" runat="server"
                                    Checked='<%# Convert.ToBoolean(Eval("isstorepaid")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="White" ForeColor="#000066" />
                    <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                    <RowStyle ForeColor="#000066" />
                    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                </asp:GridView>
            </div>

            <asp:Button ID="btnupdate" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Update" Width="65px" OnClick="btnupdate_Click" />


            <asp:Button ID="Button3" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" Width="65px" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server"
        CancelControlID="Button3"
        DropShadow="true"
        TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate1"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

            $(this).find('.chosen-container').css({width: "100%"});

        });
        searchDisable = function () {
            document.getElementById('<%=btnUser.ClientID%>').disabled = true;
            document.getElementById('<%=btnUser.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnUser', '');
        }
        </script>
</asp:Content>
