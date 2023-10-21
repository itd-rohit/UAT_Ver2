<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="FeedBackInfo.aspx.cs" Inherits="Design_Websitedata_FeedBackInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="keywords" content="NABL ACCREDIATED LABS OF INDIA, CHD CLINICAL LAB, DIAGNOSTIC CENTER OF INDIA, DIAGNOSTIC LABORATOTIES OF CHANDIGARH, CLINICAL LABORATORIES OF CHANDIGARH, CCL, LABS OF CHANDIGARH, LABORATORIES, PATHOLOGY LABS, MEDICAL LABORATORIES, CLINICAL LABS, MEDICAL TESTS, LAB INVESTIGATION, CLINICAL PATH LABS, CLINICAL LABS, DIAGNOSTIC LABS, DIAGNOSTIC CENTRE, PATHOLOGICAL CENTRE, MEDICAL LABS IN INDIA, HEALTH CARE CENTRE, CLINICAL DIAGNOSTIC CENTRE, PATH LABS, LABORATORIES, PATHOLOGICAL CLINICAL CENTREPRIVATE LABORATORIES" />
    <title>Chandigarh Clinical Laboratories Pvt. Ltd. | Chandigarh</title>
    <link href="css/ccl_stylesheet.css" type="text/css" rel="stylesheet" />

    <script language="JavaScript" src="js/leftmenu.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div id="main_Container">
            <div id="middle_content">
                <div id="main_content">
                    <div id="main">
                            <asp:Label ID="lblMsg" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>&nbsp;</p>
                        <form name="online_appointment">
                            <div class="online_app_container">
                                <fieldset>
                                    <span>Name*</span><asp:TextBox ID="txtName" runat="server" MaxLength="50"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtName" ID="RequiredFieldValidator1"
                                        runat="server" Width="2px">*</asp:RequiredFieldValidator></fieldset>
                                <fieldset>
                                    <span>Date of Visit*</span><asp:TextBox ID="txtDOV" runat="server" MaxLength="10"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtDOV" ID="RequiredFieldValidator2"
                                        runat="server" Width="2px">*</asp:RequiredFieldValidator>(DD-MM-YYYY)</fieldset>
                                <fieldset>
                                    <span>Address*</span>
                                    <asp:TextBox ID="txtAdd" runat="server" TextMode="MultiLine" MaxLength="200"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtAdd"
                                        runat="server" Width="2px">*</asp:RequiredFieldValidator></fieldset>
                                <fieldset>
                                    <span>Mobile No.*</span><asp:TextBox ID="txtMbNo" runat="server" MaxLength="25"></asp:TextBox>
                                    <asp:RequiredFieldValidator ControlToValidate="txtMbNo" ID="RequiredFieldValidator3"
                                        runat="server" Width="2px">*</asp:RequiredFieldValidator></fieldset>
                                <fieldset>
                                    <span>Email ID*</span>
                                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="60"></asp:TextBox><asp:RequiredFieldValidator
                                        ID="RequiredFieldValidator4" ControlToValidate="txtEmail" runat="server" Width="2px">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Width="3px">*</asp:RegularExpressionValidator>
                                </fieldset>
                                <%--<asp:Button CssClass="submit_btn fr" Width="100px" Height="22px" ID="btnSubmit" runat="server"
                                    Text="Submit" />--%>
                                <%--<a href="#" class="submit_btn fr"><span>Submit</span></a>
                            </div>
                            <div class="general_enquiry_pic">
                            </div>
                            <div class="clearfix">
                            </div>
                            <p style="margin-top: 15px;">
                                Fields marked with*are mandatory</p>
                        <%--</form>--%>
                            </div>
                            <div class="form_feedback">
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold;">
                                        What time did you visit us?</p>
                                    <li style="list-style: none;">
                                        <asp:RadioButtonList ID="radTime" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="50px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Between 7:30 am – 9am" Text="  Between 7:30 am – 9am"></asp:ListItem>
                                            <asp:ListItem Value="Between 9 am – 11am" Text="  Between 9 am – 11am"></asp:ListItem>
                                            <asp:ListItem Value="Between 11 am – 5pm" Text="  Between 11 am – 5pm"></asp:ListItem>
                                            <asp:ListItem Value="Between 5 pm – 8pm" Text="  Between 5 pm – 8pm"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </li>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Between 9 am – 11am</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Between 11 am – 5pm</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Between 5 pm – 8pm</span>
                                    </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 0px 5px;">
                                    <p style="font-weight: bold">
                                        How did you come to know Overview?</p>
                                    <%--<li style="list-style: none;">--%>
                                        <table width="500px">
                                            <tr>
                                                <td>
                                                    <asp:RadioButtonList ID="radKnow" CssClass="f1" runat="server" RepeatColumns="2"
                                                        RepeatLayout="Table" RepeatDirection="Horizontal" Height="75px" Width="500px">
                                                        <asp:ListItem Selected="True" Value="Refer by Doctor" Text=" Refer by Doctor"></asp:ListItem>
                                                        <asp:ListItem Value="Newspaper/Magazine Ad" Text=" Newspaper/Magazine Ad"></asp:ListItem>
                                                        <asp:ListItem Value="Hoarding/ kiosk" Text=" Hoarding/ kiosk"></asp:ListItem>
                                                        <asp:ListItem Value="Leaflet" Text=" Leaflet"></asp:ListItem>
                                                        <asp:ListItem Value="Close to home/ Workplace" Text=" Close to home/ Workplace"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text=" If any another please specify"></asp:ListItem>
                                                    </asp:RadioButtonList></td>
                                            </tr>
                                            <tr align="right">
                                                <td>
                                                    <asp:TextBox ID="txtAnyOth" MaxLength="50" CssClass="specify" runat="server"></asp:TextBox></td>
                                            </tr>
                                        </table>
                                    <%--</li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Refer by Doctor</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Newspaper/Magazine Ad</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Hoarding/ kiosk</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Leaflet</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Close to home/ Workplace</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>If any another please specify</span>
                                        <input type="text" value="" class="specify" />
                                    </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Why did you choose CCL Lab</p>
                                        <table width="500px">
                                            <tr>
                                                <td>
                                                    <asp:RadioButtonList ID="radChose" CssClass="f1" runat="server" RepeatColumns="2"
                                                        RepeatLayout="Table" RepeatDirection="Horizontal" Height="50px" Width="500px">
                                                        <asp:ListItem Selected="True" Value="Oldest reliable lab" Text=" Oldest reliable lab"></asp:ListItem>
                                                        <asp:ListItem Value="Quality of report" Text=" Quality of report"></asp:ListItem>
                                                        <asp:ListItem Value="Our service" Text=" Our service"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text=" If any another please specify"></asp:ListItem>
                                                    </asp:RadioButtonList></td>
                                            </tr>
                                            <tr align="right">
                                                <td>
                                                    <asp:TextBox ID="txtChose" CssClass="specify" MaxLength="50" runat="server"></asp:TextBox></td>
                                            </tr>
                                        </table>
                                        
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Oldest reliable lab</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Quality of report</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Our service</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>If any another please specify</span>
                                        <input type="text" value="" class="specify" />
                                    </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Was the registration process easy and convenient?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radRegProcess" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="25px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Yes" Text=" Yes"></asp:ListItem>
                                            <asp:ListItem Value="No" Text=" No"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Yes</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>No</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Was the staff at registration counter courteous?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radStaff" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="25px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Yes" Text=" Yes"></asp:ListItem>
                                            <asp:ListItem Value="No" Text=" No"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Yes</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>No</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        How long was the waiting time before drawing blood?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radBlood" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="30px" Width="500px">
                                            <asp:ListItem Selected="True" Value="0-5 minutes" Text=" 0-5 minutes"></asp:ListItem>
                                            <asp:ListItem Value="5-15 minutes" Text=" 5-15 minutes"></asp:ListItem>
                                            <asp:ListItem Value="15-30 minutes" Text=" 15-30 minutes"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>0-5 minutes</span> --%></li>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>5-15 minutes</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>15-30minutes</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Was the technician courteous and efficient?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radTech" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="25px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Yes" Text=" Yes"></asp:ListItem>
                                            <asp:ListItem Value="No" Text=" No"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Yes</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>No</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        How would you like to collect your report?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radRep" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="50px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Visit the center" Text=" Visit the center"></asp:ListItem>
                                            <asp:ListItem Value="Through the website" Text=" Through the website"></asp:ListItem>
                                            <asp:ListItem Value="Via E-mail" Text=" Via E-mail"></asp:ListItem>
                                            <asp:ListItem Value="Home Delivery through commercial courier" Text=" Home Delivery through commercial
                                            courier"></asp:ListItem>
                                        </asp:RadioButtonList>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Visit the center</span>--%>
                                    </li>
                                   <%-- <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Through the website</span>
                                    </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Via E-mail</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Home Delivery through commercial
                                            courier</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Are you aware of our home collection and report delivery service?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radAware" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="25px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Yes" Text=" Yes"></asp:ListItem>
                                            <asp:ListItem Value="No" Text=" No"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Yes</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>No</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        How would you rate our overall services of the lab?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radSer" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="50px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Poor" Text=" Poor"></asp:ListItem>
                                            <asp:ListItem Value="Average" Text=" Average"></asp:ListItem>
                                            <asp:ListItem Value="Good" Text=" Good"></asp:ListItem>
                                            <asp:ListItem Value="Excellent" Text=" Excellent"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Poor</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Average</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Good</span> </li>
                                    <li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>Excellent</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Would you recommend our services to others ?</p>
                                    <li style="list-style: none;">
                                    <asp:RadioButtonList ID="radRecommend" CssClass="f1" runat="server" RepeatColumns="2"
                                            RepeatLayout="Table" RepeatDirection="Horizontal" Height="25px" Width="500px">
                                            <asp:ListItem Selected="True" Value="Yes" Text=" Yes"></asp:ListItem>
                                            <asp:ListItem Value="No" Text=" No"></asp:ListItem>
                                        </asp:RadioButtonList></li>
                                        <%--<input name="" type="radio" value="" class="fl" /><span>Yes</span> </li>--%>
                                    <%--<li style="list-style: none;">
                                        <input name="" type="radio" value="" class="fl" /><span>No</span> </li>--%>
                                </ul>
                                <ul style="list-style: none; margin: 0px; padding: 0px 0px 20px 5px;">
                                    <p style="font-weight: bold">
                                        Please share your feedback to help us serve you better</p>
                                    <li style="list-style: none;">
                                        <asp:TextBox ID="txtFeedback" TextMode="MultiLine" runat="server"></asp:TextBox>
                                    </li>
                                </ul>
                                <asp:Button Width="100px" Height="22px" ID="btnSubmit" runat="server"
                                    Text="Submit" OnClick="btnSubmit_Click" />
                                <%--<a href="#" class="submit_btn fl"><span>Submit</span></a>--%><div class="clearfix">
                                </div>
                            </div>
                            <div class="clearfix">
                            </div>
                        </form>
                    </div>
                </div>
    </form>
    <div class="clearfix">
    </div>
    </div>
    </div>
</body>
</html>
