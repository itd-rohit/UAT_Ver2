<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>::: LIS :::</title>
    <!--Script Start-->
    <script type="text/javascript" src="../Scripts/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="../Scripts/MarcTooltips.min.js"></script>
    <!--CSS Start-->
    <link rel="stylesheet" href="../Styles/supersized.css" type="text/css" media="screen" />
    <link rel="stylesheet" href="../Styles/Loginstyle.css" />
    <link rel="stylesheet" href="../Styles/media.css" />
    <link rel="stylesheet" href="../App_Style/grid24.css" />
    <link rel="stylesheet" href="../Scripts/LoginScript/component.css" />
    <link rel="stylesheet" href="../App_Style/MarcTooltips.css" />
    <link href="../App_Style/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        jQuery(function () {
            $('#<%=txtUserName.ClientID%>').focus();
        });     
        function ShowHidePassword(ID) {
            if (document.getElementById($("#" + ID).prev().attr('id')).type == "password") {
                $("#" + ID).attr("data-hint", "Show");
                $("#" + ID).find("i").removeClass("icon-eye-slash").addClass("icon-eye");
                document.getElementById($("#" + ID).prev().attr('id')).type = "text";
                $("#" + ID).find("i").attr("title", "Click to Hide Password");
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
            else {
                $("#" + ID).attr("data-hint", "Hide");
                $("#" + ID).find("i").removeClass("icon-eye").addClass("icon-eye-slash");
                document.getElementById($("#" + ID).prev().attr('id')).type = "password";
                $("#" + ID).find("i").attr("title", "Click to Show Password");
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
        }
        function Validate() {
            if ($('#<%=txtUserName.ClientID%>').val() == "") {
                alert("Please Enter User Name");
                $('#<%=txtUserName.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtPassword.ClientID%>').val() == "") {
                alert("Please Enter Password");
                $('#<%=txtPassword.ClientID%>').focus();
                return false;
            }
            document.getElementById('<%=btnLogin.ClientID%>').disabled = true;
            document.getElementById('<%=btnLogin.ClientID%>').value = 'Submitting...';     
            __doPostBack('btnLogin', '');           
        }
        function ForgotPass() {
            window.location = 'ForgotPassword.aspx';
        }      
    </script>
</head>
<body>
    <div id="controls-wrapper" class="load-item">
        <div id="controls">
            <ul id="slide-list"></ul>
        </div>
    </div>
    <!--header-->
    <div class="loginpage">
    </div>
    <div class="md-modal md-effect-1" id="modal-1">
        <div class="md-content">
            <div class="loginpad" style="background: url('../App_Images/app-background.png');">
                <h6>
                    <asp:Label ID="lblClientFullName" runat="server" Font-Bold="true" Font-Size="X-Large"></asp:Label></h6>
                <div class="logininnerpad">
                    <div class="icelogo">
                        <asp:Image ID="imgClientLogo" runat="server" />
                    </div>
                    <h3><strong>Welcome, Please Login..</strong></h3>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:Label ID="lblError" runat="server" Visible="False" ForeColor="Red"
                                EnableViewState="False"></asp:Label>
                        </div>
                    </div>
                    <form id="form1" runat="server">
                        <div class="row" id="tr_UserType" >
                            <div class="col-md-6">
                               <label class="pull-left"><b> User Type</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <asp:DropDownList ID="ddlUserType" runat="server" CssClass="textAreaBoxInputs">
                                    <asp:ListItem Text="Employee" Value="Employee" Selected="True"></asp:ListItem>
                                    <%--<asp:ListItem Text="PRO" Value="PRO"></asp:ListItem>--%>
                                    <%--<asp:ListItem Text="PUP" Value="PUP"></asp:ListItem>--%>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>User Name</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <asp:TextBox ID="txtUserName" runat="server" CssClass="textAreaBoxInputs" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left"><b>Password</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">

                                <asp:TextBox ID="txtPassword"  data-title="Show Password" TextMode="Password" runat="server" CssClass="textAreaBoxInputs" AutoCompleteType="Disabled"></asp:TextBox>
                                <span id="ShowHidePassword" title="Click to Show Password" class="dvShowHidePassword hint--top hint--bounce hint--rounded"
                                    data-hint="Hide" onclick="ShowHidePassword(this.id);"><i class="icon icon-eye-slash"></i>
                                </span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24" style="vertical-align: top">
                                <asp:Button ID="btnLogin" runat="server" CssClass="btn" Text="Login" OnClick="btnLogin_Click" OnClientClick="return Validate()" />
                                <asp:Button ID="btnCancel" runat="server" CssClass="btn cancelbtn" Text="Clear" OnClick="btnCancel_Click" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24" style="text-align: center">
                                <a href="#" id="lnkForgotPass" onclick="return ForgotPass();" style="color: #000099; font-weight: 700; text-decoration: underline; cursor: pointer">Forgot Password?</a>
                            </div>
                        </div>
                    </form>
                </div>
                <h1></h1>
            </div>
        </div>
    </div>
    <div>
        <div class="logo" style="display: none">
            <a href="http://www.itdoseinfo.com">
                <img src="#"></a> <%--images/itdose.jpg--%>
            <button class="md-trigger" data-modal="modal-1" id="modal1" style="display: none">Fade in &amp; Scale</button>
        </div>
		<div style="border: double 2px Blue; text-align: center; background-color: #06799B; border-radius: 10px; margin-left: 10px; width: 98%; height: 30px; margin-bottom: 10px; margin-top: 10px">
                <b>Copyright © 2021, ITDOSE INFOSYSTEMS PVT.LTD ., All Rights Reserved Powered By: ITDOSE INFOSYSTEMS PVT.LTD.</b>    
        </div>
    </div>
    <script type="text/javascript" src="../Scripts/LoginScript/html5.js"></script>
    <script type="text/javascript" src="../Scripts/LoginScript/respond.js"></script>
    <script type="text/javascript" src="../Scripts/LoginScript/jquery.min.js"></script>
    <script type="text/javascript" src="../Scripts/LoginScript/supersized.3.2.7.min.js"></script>
    <script src="../Scripts/LoginScript/modernizr.custom.js" type="text/javascript"></script>
    <script src="../Scripts/LoginScript/classie.js" type="text/javascript"></script>
    <script src="../Scripts/LoginScript/modalEffects.js" type="text/javascript"></script>  
    <script type="text/javascript">
        jQuery(function ($) {
            $('#modal1').click();
            $.supersized({
                // Functionality
                slideshow: 1,			// Slideshow on/off
                autoplay: 1,			// Slideshow starts playing automatically
                start_slide: 1,			// Start slide (0 is random)
                stop_loop: 0,			// Pauses slideshow on last slide
                random: 0,			// Randomize slide order (Ignores start slide)
                slide_interval: 4000,		// Length between transitions
                transition: 1, 			// 0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
                transition_speed: 1000,		// Speed of transition
                new_window: 1,			// Image links open in new window/tab
                pause_hover: 0,			// Pause slideshow on hover
                keyboard_nav: 1,			// Keyboard navigation on/off
                performance: 1,			// 0-Normal, 1-Hybrid speed/quality, 2-Optimizes image quality, 3-Optimizes transition speed // (Only works for Firefox/IE, not Webkit)
                image_protect: 1,			// Disables image dragging and right click with Javascript
                // Size & Position						   
                min_width: 0,			// Min width allowed (in pixels)
                min_height: 0,			// Min height allowed (in pixels)
                vertical_center: 1,			// Vertically center background
                horizontal_center: 1,			// Horizontally center background
                fit_always: 0,			// Image will never exceed browser width or height (Ignores min. dimensions)
                fit_portrait: 1,			// Portrait images will not exceed browser height
                fit_landscape: 1,			// Landscape images will not exceed browser width
                // Components							
                slide_links: 'blank',	// Individual links for each slide (Options: false, 'num', 'name', 'blank')
                thumb_links: 1,			// Individual thumb links for each slide
                thumbnail_navigation: 0,			// Thumbnail navigation
                slides: [			// Slideshow Images

                                                    { image: '../App_Images/bg1.jpg' },
                                                    { image: '../App_Images/bg6.jpg' },
                                                    { image: '../App_Images/bg7.jpg' },
                                                    { image: '../App_Images/bg5.jpg' },
{ image: '../App_Images/bg2.jpg' },
{ image: '../App_Images/bg3.jpg' },
{ image: '../App_Images/bg4.jpg' },
{ image: '../App_Images/bg2112020.jpg' },
{ image: '../App_Images/bg9.jpg' },
{ image: '../App_Images/bg10.jpg' }

                ],
                // Theme Options			   
                progress_bar: 0,			// Timer for each slide							
                mouse_scrub: 0
            });
        });
    </script>
</body>
</html>
