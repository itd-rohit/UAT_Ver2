<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Design_Mobile_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="../../Scripts/jquery-1.9.1.min.js"></script>
    <link href="bootstrap/style.css" rel="stylesheet" />
    <link href="bootstrap/page.css" rel="stylesheet" />
</head> 
  <body>
       <form id="form1" runat="server">
        <div class="container LoginForm"> 
             <div class="col-lg-4 col-md-4 col-sm-3 col-xs-0"></div> 
            <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 loginbox">
                <div class=" row">
                    <div class="col-lg-8 col-md-8 col-sm-8 col-xs-6">
                        <img src="logo.png" alt="Logo" class="logo"> 
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-6  ">
                        <span class="singtext" >Sign in </span>   
                    </div>
                                 
                </div>
                <div class=" row loginbox_content "> 
                    <div style="margin: 10px;">
                        <asp:Label ID="lblError" runat="server" Visible="False" ForeColor="Red" EnableViewState="false" Font-Bold="true"></asp:Label>
                    </div>                       
                    <div class="input-group input-group-sm" >
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-user"></span>
                        </span>
                        <asp:TextBox CssClass="form-control" ID="txtUserName" runat="server"  placeholder="User name"></asp:TextBox>
                           <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUserName"
                                Display="None" ErrorMessage="Specify User Name" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    </div>
                    <br>
                    <div class="input-group input-group-sm">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-lock"></span>
                        </span>
                        <asp:TextBox CssClass="form-control" ID="txtPassword" runat="server"  type="password" placeholder="Password"></asp:TextBox>
                       <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                                Display="None" ErrorMessage="Specify Password" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    </div>              
                </div>
                <div class="row ">                   
                    <div class="col-lg-8 col-md-8  col-sm-8 col-xs-7 forgotpassword "> 
                        <a href="#"  style="display:none;" > Forgot Password?</a>                        
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-4  col-xs-5 "> 
                        <asp:Button ID="btnLogin" CssClass="btn btn-default login-btn" runat="server" Text="Login" OnClick="btnLogin_Click" /> 
                        
                    </div>
                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-3 col-xs-0"></div>


        </div>
           </form>
    </body>
 
</html>
