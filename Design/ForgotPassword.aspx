<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="Design_ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-3.1.1.js"></script>
     <!--Script Start-->
    <script type="text/javascript" src="../Scripts/jquery-3.1.1.min.js"></script>
    <!--CSS Start-->
    <link rel="stylesheet" href="../Styles/supersized.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../Styles/Loginstyle.css" />
    <link rel="stylesheet" href="../Styles/media.css" />
    <link rel="stylesheet" href="../Scripts/LoginScript/component.css" />

    <%--<script src="Scripts/LoginScript/modernizr.custom.js" type="text/javascript"></script>--%>
    <script>
 $(document).ready(function () {
            setPUPPortalLogin();
        });
        function Cancel()
        {
            window.location = 'Default.aspx';
        }
function setPUPPortalLogin() {
        if ('<%=PUPPortalLogin%>' == '1') {
            $('#ddlUserType').val('PUP');
            $('#tblLogin tr#tr_UserType').hide();
        }
        else {
            $('#ddlUserType').val('Employee');
            $('#tblLogin tr#tr_UserType').hide();
        }
    }
        function Validate()
        {
            var isvalid = false;
            var pass = $('#<%=txtPassword.ClientID%>').val();
            var conPass = $('#<%=txtConfirmPassword.ClientID%>').val();
            if(pass=="" ||conPass=="")
            {
                alert('Password And Confirm Password are mendatory fields');
                isvalid = true;
            }
            else {
                if (pass != conPass) {
                    alert('Password And Confirm Password should be same');
                    isvalid = true;
                }
                else {
                    
                }
            }
            if (isvalid == true) {
                return false;
            }

        }
    </script>
</head>
<body style="background: url('../App_Images/app-background.png');" >
    <%--style="background-image:url(Purchase/Image/1.gif)"--%>
    <div id="controls-wrapper" class="load-item">
        <div id="controls">
            <ul id="slide-list"></ul>
        </div>
    </div>
    <!--header-->
    <div class="loginpage">
    </div>
   
                <form id="form1" runat="server" >
                    <div id="mydiv">
                        <div style="padding-top: 2px;">
                            
                            <div  class="loginpad" id="" style="border: double 2px Green; background-color: #FFFFFF; padding: 10px; border-radius: 10px; margin-left: 30%; margin-right: 15%; width: 40%;">

                                <table style="width: 100%;" >
                                  <%--  <tr>
                                        <td align="center" style="height: 100px; width: 300px;">
                                            <%if (Layouts.Rows.Count > 0)
                                              {
                                                  foreach (System.Data.DataRow dr in Layouts.Rows)
                                                  {
                                                      if (Util.GetString(dr["Type"]) == "SiteLogo")
                                                      { 
                                            %>                    <%=Util.GetString(dr["Content"]) %>
                                            <%
                                                  }
                                              }
                                          } %>
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td align="center" style="height: 15px;font-size:larger">
                                            <asp:Label ID="lblError" runat="server" Visible="false" ForeColor="Red" EnableViewState="false" Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                                <div  class="Outer_Box_Login" runat="server" id="GetOtpDiv">

                                    <div   style="text-align: center; padding: 10px 5px 5px 20px;">

                                        <div style="border: solid 2px #303e54; padding: 3px 3px 3px 3px; width: 500px; border-radius: 10px;font-weight:bold;">                
                                            <div class="icelogo">
                                                <asp:Image ID="imgClientLogo" runat="server" />
                                            </div>
                                            <div class="Purchaseheader" style="padding: 10px; color: Green; font-weight: bold;font-size:larger">Forgot Password</div>
                                            <table style="width: 100%;" cellpadding="2" cellspacing="2" id="tblLogin">
                                                <tr id="tr_UserType">
                                                    <td>
                                                        <label class="labelForTag" style="text-align:left;"><span class="ItDoseLabelBl">User Type</span></label></td>
                                                    <td>
                                                        <asp:DropDownList ID="ddlUserType" runat="server"  CssClass="textbox">
                                                            <asp:ListItem Text="Employee" Value="Employee" Selected="True"></asp:ListItem>
                                                            <asp:ListItem Text="PUP" Value="PUP"></asp:ListItem>
                                                        </asp:DropDownList>

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label class="labelForTag" style="text-align:left;"><span class="ItDoseLabelBl">User Name</span></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtUserName" CssClass="textbox" AutoCompleteType="None" MaxLength="50" runat="server" />

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label class="labelForTag" style="text-align:left;"><span class="ItDoseLabelBl">Mobile</span></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtMobile" CssClass="textbox" MaxLength="10" AutoCompleteType="None" runat="server"  />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="text-align: center;">
                                                        <strong>OR</strong>
                                                    </td>

                                                </tr>

                                                <tr>
                                                    <td>
                                                        <label class="labelForTag" style="text-align:left;"><span class="ItDoseLabelBl" style="text-align:left;">Email</span></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtEmail" CssClass="textbox" MaxLength="50" AutoCompleteType="None" runat="server"  />
                                                    </td>
                                                </tr>

                                                <tr id="otpField" runat="server">
                                                    <td>
                                                        <label class="labelForTag" style="text-align:left;"><span class="ItDoseLabelBl">OTP</span></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtOtp" CssClass="textbox" AutoCompleteType="None" MaxLength="6" runat="server" />

                                                    </td>
                                                    <td>
                                                        <asp:Button ID="btnOtp" CssClass="btn" runat="server" Text="Get Otp" Width="100px"  OnClick="btnOTp_Click" Font-Bold="true" /></td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td colspan ="1">
                                            <asp:Button ID="btnResetShow" runat="server" Text="Submit"  CssClass="btn" OnClick="btnResetShow_Click"  />
                                           <input type="button" onclick="return Cancel();" value="Cancel" class="btn cancelbtn"  />
                                                    </td>
                                                </tr>
                                            </table>

                                      
                                    </div>
                                </div>
                               
                            </div>
                                 <div class="Outer_Box_Login" runat="server" id="resetPassDiv">

                                    <div style="text-align: center; padding: 10px 5px 5px 20px;">
                                        
                                        <div style="border: solid 2px #303e54; padding: 3px 3px 3px 3px; width: 500px; text-align: center; border-radius: 10px;font-weight:bold">
                                             <div class="icelogo">
                                                    <asp:Image ID="Image1" runat="server" />
                                            </div>
                                            <div class="Purchaseheader" style="padding: 10px; color: Green; font-weight: bold ;font-size:larger"">
                                                Reset Password
                                            </div>
                                            <table style="width: 100%;" cellpadding="2" cellspacing="2">
                                                <tr>
                                                    <td>
                                                        <label style="text-align:left;"  class="labelForTag"><span class="ItDoseLabelBl">Password</span><strong style="color: red; float: right">*</strong></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtPassword" TextMode="Password" MaxLength="50" runat="server" CssClass="textbox" />

                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <label class="labelForTag"><span class="ItDoseLabelBl">Confirm Password</span><strong style="color: red; float: right">*</strong></label></td>
                                                    <td>
                                                        <asp:TextBox ID="txtConfirmPassword" MaxLength="50" TextMode="Password" runat="server"  CssClass="textbox" />
                                                        <asp:HiddenField ID="hdfEmpCOde" runat="server" />
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>&nbsp;</td>
                                                    <td colspan ="1" style="text-align:center">
                                                        <asp:Button ID="btnreset" CommandName="GetOtp" runat="server" Text="Reset"  CssClass="btn" OnClick="btnREset" style="width:150px" Font-Bold="true" OnClientClick="return Validate();" />
                                                        <input type="button" onclick="return Cancel();" value="Cancel"  class="btn cancelbtn" style="width:150px;font-weight:200"/>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                              
                        </div>
                        </div>
                </form>

</body>
   
</html>
