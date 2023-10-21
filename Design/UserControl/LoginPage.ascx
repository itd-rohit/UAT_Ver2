<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LoginPage.ascx.cs" Inherits="Design_UserControl_LoginPage" %>


    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>

    <div style="margin-left:85px;">
        <table>
            <tr>
                <td style="height:30px;text-align:center;" colspan="2">
                     <asp:Label ID="lblError" runat="server" Visible="false" ForeColor="Red" EnableViewState="false" Font-Bold="true"></asp:Label>
                     <asp:Label ID="lblAdrenalinError" runat="server" style="display:none;" ForeColor="Red" EnableViewState="false" Font-Bold="true"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="border: solid 2px #303e54; padding: 3px 3px 3px 3px; width: 360px; text-align: center; border-radius: 10px;">
                                <div class="Purchaseheader">
                                    User Login Area
                                </div>
                                <table style="width:100%" id="tblLogin">
                                   <tr id="tr_UserType">
                                        <td style="text-align:left;font-weight:bold;">
                                           User Type</td>
                                        <td>
                                            <asp:DropDownList ID="ddlUserType" runat="server" Width="208px">
                                                <asp:ListItem Text="Employee" Value="Employee" Selected="True"></asp:ListItem>
                                                 <asp:ListItem Text="PRO" Value="PRO"></asp:ListItem>
                                            </asp:DropDownList>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:left;font-weight:bold;">
                                           User Name</td>
                                        <td>
                                            <asp:TextBox ID="txtUserName" MaxLength="50" runat="server" Width="205px" CssClass="ItDoseTextinputText" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUserName"
                                Display="None" ErrorMessage="Specify User Name" SetFocusOnError="True">*</asp:RequiredFieldValidator>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align:left;font-weight:bold;">
                                          Password</td>
                                        <td>
                                            <asp:TextBox ID="txtPassword" MaxLength="50" runat="server" Width="205px" TextMode="Password" CssClass="ItDoseTextinputText" onkeydown = "return (event.keyCode!=13);" />
                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                                Display="None" ErrorMessage="Specify Password" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                                ShowSummary="False" />
                                        </td>
                                    </tr>


                                    <tr>
                                        <td colspan="2">
                                            &nbsp;</td>
                                    </tr>


                                    <tr>
                                        <td colspan="2">
                                            <input type="button" onclick="WelcomeLogin();" value="Login" class="ItDoseButton" style="width:60px;font-weight:bold;" />
                                            <asp:Button ID="btnLogin" runat="server" style="display:none;" Text="Login" Width="60px" CssClass="ItDoseButton" OnClick="btnLogin_Click" Font-Bold="true" />
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" Width="60px" CssClass="ItDoseButton" OnClick="btnCancel_Click" Font-Bold="true" CausesValidation="False" />
                                        <a href="#" id="lnkForgotPass" onclick="return ForgotPass();" Style="color: #000099; font-weight: 700; text-decoration: underline; cursor: pointer">Forgot Password?</a> 
                                        </td>
                                    </tr>
                                </table>
                            </div>
                </td>
            </tr>

            <tr>
                <td style="text-align:center;">
                    <br />
                    <br /> 
                    <asp:HyperLink ID="lnkHomePage" runat="server" onclick="setHomepage();" Style="color: #000099; font-weight: 700; text-decoration: underline; cursor: pointer" 
                        Text="Set Home Page"></asp:HyperLink>       <br />
                    <br />                </td>
                   <td style="text-align:center;">
                        <br />
                    <br /> 
                                <asp:HyperLink ID="lnlBookMark" runat="server" class="Bookmark" Style="color: #000099; font-weight: 700; text-decoration: underline; cursor: pointer"
                                    Text="Add To Favorites"></asp:HyperLink>   <br />
                    <br /> 
                    </td>
            </tr>
        </table>

                  
                 </div>

<script type="text/javascript">
    function WelcomeLogin() {        
        $("#LoginPage_lblAdrenalinError").hide();
        $('#LoginPage_lblAdrenalinError').html('');
        $('#LoginPage_lblError').html('');
        $('#LoginPage_btnLogin').click();
        
    }
    $(document).ready(function () {
        $("#LoginPage_txtPassword").keydown(
                 function (e) {
                     var key = (e.keyCode ? e.keyCode : e.charCode);
                     if (key == 13 ) {
                         WelcomeLogin();
                     }
                 });
    });
</script>