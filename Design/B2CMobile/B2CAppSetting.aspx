<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Design/B2CMobile/B2CAppSetting.cs" Inherits="Design_DocAccount_B2CAppSetting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <style type="text/css">
        .ActiveClass {
            background-color: #a8e94a!important;
            color: white!important;
        }

        .DeactiveClass {
            background-color: blue!important;
            color: white!important;
        }
    </style>
</head>
<body style="margin-top:-17px!important">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="margin-top:50px!important">
            <div class="POuter_Box_Inventory" >
                <div class="row" style="text-align:center;margin:-21px!Important;">
                    <b>B2C Mobile App Setting</b>
                </div>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Design/Welcome.aspx" Font-Bold="true" Font-Size="Large" Target="_parent">HOME</asp:HyperLink>
                <asp:Panel ID="pnlSalesTarget" runat="server" HorizontalAlign="Center">
                    <div class="HeaderTab">
                        <ul id="ulid">
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/MobileAppB2CSetting.aspx" id="A16" target="main">App Content Setting</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/B2CTabSetting.aspx" id="A6" target="main">Tab Setting</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/TitleMaster.aspx" id="A1" target="main">Title Master</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/uploadBannar.aspx" id="A4" target="main">Banner Configuration</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/CityMaster.aspx" id="A2" target="main">City Configur</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/CentreLocator.aspx" id="A3" target="main">Centre Location</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/Aboutus.aspx" id="A5" target="main">About Us</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/Help.aspx" id="A7" target="main">Help</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/HealthTips.aspx" id="A8" target="main">HealthTips</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/HealthOffer.aspx" id="A9" target="main">HealthOffer</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/Slot_Master.aspx" id="A10" target="main">Slot Master</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/B2CCancelReasion.aspx" id="A110" target="main">Cancel Reason</a> </li>
                            <li><a class="DeactiveClass" onclick="setactive(this)" href="../B2CMobile/B2CAppSmsConfigure.aspx" id="A11" target="main">SMS Configure</a> </li>
                        </ul>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
<script type="text/jscript">
    function setactive(el) {
        $('#ulid li a').removeClass('ActiveClass').addClass('DeactiveClass');
        $(el).removeClass().addClass('ActiveClass');
    }
</script>
</html>




