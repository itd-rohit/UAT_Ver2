<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Design_Online_Lab_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login Page 
    </title>
    <link href="../../Design/OnlineLab/Css/Saroj.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="~/itdose.ICO" type="image/x-icon" />
    <script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>
    <style type="text/css">
        input[type="submit"] {
            background-color: #569ADA;
            padding: 5px;
            border-radius: 8px;
            -ms-border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

            input[type="submit"]:hover {
                background-color: #3B0B0B;
            }
        .auto-style1 {
            color: #0066FF;
        }
    </style>
    
     <script>
         $(function () {
        function disableBack() {
            window.history.forward();
            window.history.go(1);
        }

            window.onload = disableBack();
            window.onpageshow = function (evt) { if (evt.persisted) disableBack() }
    });
         </script>
</head>
<body style="background-color: #E1E1E1">
    <form id="form1" runat="server">

        <div style="margin: 0px auto 0px auto; width: 1000px; background-color: #E1E1E1;">
            <table id="Table_01" border="0"  height="600" width="1004">
                <tbody>
                    <tr>
                        <td rowspan="10">

                            <img src="../../Design/OnlineLab/Images/saroj-lab_01.jpg" alt="" height="600" width="75" />
                        </td>
                        <td colspan="3">
                            <img src="../../Design/OnlineLab/Images/saroj-lab_02.jpg" alt="" height="37" width="850" /></td>
                        <td rowspan="10">
                            <img src="../../Design/OnlineLab/Images/saroj-lab_03.jpg" alt="" height="600" width="79" /></td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center" bgcolor="#FFFFFF" height="97" valign="middle">
                            <table border="0"  width="750">

                                <tbody>
                                    <tr>

                                        <td colspan="2" class="onlinelabheading" align="center">
                                            <img src="Images/SHLlogo.png" alt="" height="240" width="490" />
											
                                        </td>

                                    </tr>
                                    <tr style="display: none;">
                                        <td style="height: 18px">&nbsp;</td>
                                        <td class="LoginText1" style="text-align: left; height: 18px;" colspan="2">&nbsp;</td>
                                        <td style="height: 18px">&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    
                    <tr>

                        <td rowspan="4">
                            <img src="../../Design/OnlineLab/Images/itdose-lab_07.jpg" alt="" height="240" width="490" />
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <img src="../../Design/OnlineLab/Images/saroj-lab_09.jpg" alt="" height="47" width="359" /></td>
                    </tr>
                    <tr>
                        <td align="center" background="../../Design/OnlineLab/Images/login-mid-line.jpg" height="141" valign="top">
                            <span class="auto-style1"><strong>Please Select Group Name</strong></span><br>
                            <table border="0" width="260">
                                <tbody>
                                    <tr>

                                        <td class="labonlineLoginText" align="left" valign="middle" style="height: 21px; text-align: center;" colspan="2">
                                            <asp:Label ID="lblError" runat="server" Text="Label" Font-Size="Large" ForeColor="red" Visible="false" Style="text-align: center"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td class="labonlineLoginText" align="left" valign="middle" style="height: 21px; width: 86">group name </td>
                                        <td style="width: 169px; height: 21px;" align="left" valign="middle">&nbsp<label>


                                            <asp:DropDownList ID="ddlLoginType" runat="server" Style="width: 142px; border: #1194cb 1px solid;">
                                                <asp:ListItem Text="Patient" Value="Patient"></asp:ListItem>
                                                <asp:ListItem Text="Client" Value="Panel" Selected="True"></asp:ListItem>
                                                <%--<asp:ListItem Text="Doctor" Value="Doctor"></asp:ListItem>--%>
                                               
                                            </asp:DropDownList>



                                            <select name="ddlUserType" id="ddlUserType" class="labonlineloginbox" style="width: 145px; display: none">
                                                <option selected="selected" value="Patient">Patient</option>
                                                <option value="Admin">Admin</option>

                                            </select></label></td>
                                    </tr>
                                    <tr>
                                        <td class="labonlineLoginText" align="left" valign="middle">User Name </td>
                                        <td style="width: 169px;" align="left" valign="middle">&nbsp;
                  <asp:TextBox ID="txtUserName" MaxLength="50" runat="server" Style="width: 139px;" CssClass="labonlineloginbox"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labonlineLoginText" align="left" valign="middle" style="height: 26px">password </td>
                                        <td style="width: 169px; height: 26px;" align="left" valign="middle">&nbsp;
              <asp:TextBox ID="txtPassword" MaxLength="50" runat="server" Style="width: 139px;" CssClass="labonlineloginbox" TextMode="Password"></asp:TextBox>
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td align="left" height="25" valign="middle">&nbsp;</td>
                                        <td style="width: 169px;" align="center" valign="bottom">

                                            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="labonlineLoginText" colspan="2" align="left" height="25" valign="middle">* please enter UserName. and Password as &nbsp;&nbsp; printed on the receipt.</td>
                                    </tr>
                                    <tr>
                                        <td class="labonlineLoginText" colspan="2" align="left" valign="middle">&nbsp;&nbsp;</td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 5px">
                            <img src="../../Design/OnlineLab/Images/saroj-lab_11.jpg" alt="" height="22" width="359"></td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center" bgcolor="#FFFFFF" style="height: 6px">
                            <table border="0" width="630">
                                <tbody>
                                    <tr>
                                        <td colspan="2" class="onlineslogantext" align="center" valign="middle" width="671">
                                            <img src="../../Design/OnlineLab/Images/slogan.jpg" style="height: 47px;" width="531"></td>
                                    </tr>

                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center" bgcolor="#FFFFFF" height="39">
                            <table border="0" width="830">
                                <tbody>
                                    <tr>
                                        <td align="left" valign="middle" width="221" style="height: 32px">
                                            <asp:Button ID="btnAdobeReader" runat="server" Text="Free Download Adobe Reader" OnClick="btnAdobeReader_Click" />&nbsp;</td>
                                        <td align="left" valign="middle" style="width: 319px; height: 32px;">&nbsp;</td>
                                        <td align="right" valign="bottom" width="82" style="width: 208px;" rowspan="2"><span class="ItDoseLabelBl" style="font-size: 10pt; color: Silver;">
                                            <span class="ItDoseLabelBl" style="font-size: 10pt; font-family: Verdana, Arial, sans-serif, sans-serif; color: Maroon; font-weight: bold;">Copy Rights@<%=System.DateTime.Now.Year %>  &nbsp;
     <img src="../../App_Images/itdose.ICO" alt="" style="cursor: pointer" onclick='window.open("http://itdoseinfo.com/")' />
                                            </span></span></td>

                                    </tr>
                                    <tr>
                                        <td colspan="2" class="onlinefooterline" align="left" valign="middle" style="height: 66px">
                                            <strong><span style="color: #ff3333; font-size: large;">* IMPORTANT NOTE *</span><br />
                                                <span style="color: #ff3300">*</span> </strong><span style="color: #ff3300"><strong>
                                                   
                        * KEEP POP-UP BLOCKER OFF FROM TOOLS - Pop-Up Blocker Option.<br />
                                                    * aDOBE READER 8.0 OR HIGHER VERSION MUST INSTALLED.</strong>&nbsp;<br />
                                                </span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">

                            <img src="../../Design/OnlineLab/Images/saroj-lab_14.jpg" alt="" height="40" width="850"></td>
                    </tr>
                </tbody>
            </table>

        </div>
    </form>
</body>
</html>
