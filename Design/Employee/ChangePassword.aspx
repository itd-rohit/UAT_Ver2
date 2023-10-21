<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Design_Employee_ChangePassword" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Change Password<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Basic Information
            </div>
            <div class="row" style="margin-top: 0px;">
                <div class="row">
                    <div class="col-md-3 col-xs-24">
                        <label class="pull-left">User Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:Label ID="lblUserType" runat="server" Text="User Type" Style="font-weight: bold; font-size: large"></asp:Label>
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-6 col-xs-24">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-xs-24">
                        <label class="pull-left">User Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:TextBox ID="txtUserName" runat="server" CssClass="inputbox" TabIndex="1"   ReadOnly="true"></asp:TextBox>                        
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ControlToValidate="txtUserName" ValidationExpression="^[0-9a-zA-Z''-_]{1,40}$"
                            ErrorMessage="Invalid Username."></asp:RegularExpressionValidator>
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-6 col-xs-24">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-xs-24">
                        <label class="pull-left">Old Password</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:TextBox ID="txtOldPassword" runat="server" CssClass="inputbox requiredField" TabIndex="2"
                            TextMode="Password"></asp:TextBox>                       
                    </div>
                    <div class="col-md-5 col-xs-24">
                         <asp:TextBox ID="txtOldPassCheck" runat="server" Visible="false" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtOldPassCheck"
                            ControlToValidate="txtOldPassword" ErrorMessage="Invalid Password"></asp:CompareValidator>
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-6 col-xs-24">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-xs-24">
                        <label class="pull-left">New Password</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="inputbox requiredField" TabIndex="3"
                            TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-6 col-xs-24">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-xs-24">
                        <label class="pull-left">Confirm Password</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 col-xs-24">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="ItDoseTextinputText requiredField" TabIndex="4"
                            TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToCompare="txtNewPassword"
                            ControlToValidate="txtConfirmPassword" ErrorMessage="New Password Not Matched"></asp:CompareValidator>
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-5 col-xs-24">
                    </div>
                    <div class="col-md-6 col-xs-24">
                    </div>
                </div>             
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" runat="server" CssClass="savebutton" OnClick="btnSave_Click" ClientIDMode="Static"
                TabIndex="5" Text="Save" ToolTip="Click To Save" />
        </div>
    </div>
   

	<script type="text/javascript">
    $(function () {
		shortcut.add('Alt+S', function () {
		    var btnSave = $('#btnSave');
			if (btnSave.length > 0) {
				if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
				    __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '')
				}
			}
		}, addShortCutOptions);
    });
	    </script> 
</asp:Content>
