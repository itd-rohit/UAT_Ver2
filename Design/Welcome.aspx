<%@ Page Title="Welcome" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Welcome.aspx.cs" Inherits="Design_Welcome" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        #dashboard_box_inventory {
            margin: 40px 1px 1px 1px;
            display: inline-block;
            width: 1340px;
        }
   .mainmenu {
    padding-top: 33px;
    }

        .well {
            min-height: 20px;
            padding: 19px;
            margin-bottom: 20px;
            background-color: #f5f5f5;
            border: 1px solid #eee;
            border: 1px solid rgba(0, 0, 0, 0.05);
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
        }

        .row-fluid .span3 {
            width: 23.404255317%;
        }
    </style>
    <link rel="stylesheet" href="../App_Style/jquery-confirm.min.css">
    <script src="../Scripts/jquery-confirm.min.js" type="text/javascript"></script>

    <cc1:ToolkitScriptManager ID="my" runat="server" EnablePageMethods="true"></cc1:ToolkitScriptManager>
    <div id="dashboard_box_inventory">
        <div id="Div1">
        <asp:Label ID="lblEmpId" runat="server" Style="display: none;"></asp:Label>
        <div class="row">
            <div class="row">
                <div class="col-md-24">
                    <div style="padding: 5px; height: 35px; color: red" class="well span3 top-block">
                        <span style="margin-top: -4px;" class="icon32 icon-color icon-rssfeed pull-left"></span>
                        <marquee behavior="scroll" direction="left" style="width: 1250px"><div runat="server" id="divWelcomeMessage"></div></marquee>
                    </div>
                </div>
            </div>
            <div class="row">
                <div runat="server" id="divWelcomeLabels" class="col-md-20">
                </div>
                <div class="col-md-4">
                    <div style="font-size: 11px;" class="well span3 top-block">
                        <span class="icon32 icon-color icon-user"></span>
                        <div><span class="icon icon-color icon-globe"></span>Your IP</div>
                        <div runat="server" id="divIPAddress" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-clock"></span>Last Login Time</div>
                        <div runat="server" id="divLastLoginTime" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-users"></span>Total Login Attempts</div>
                        <div runat="server" id="divTotalLogin" style="text-decoration: underline; color: blue"></div>
                           <div><span class="icon icon-color icon-users"></span>Total System Login</div>
                        <div runat="server" id="divTotalsystemlogin" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-wrench"></span>Last Password Change</div>
                        <div runat="server" id="divLastPasswordChange" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-users"></span>Today Registered </div>
                        <div runat="server" id="divNoofPatient" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-clock"></span>Change Default Login</div>
                        <div runat="server" id="divDefaultLogin" style="text-decoration: underline; color: blue">
                            <asp:DropDownList ID="ddlRole" runat="server" Width="180px" AutoPostBack="True" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged">
                                    </asp:DropDownList></div>
                        <div runat="server" id="divBatchNumber" style="text-decoration: underline; color: blue"></div>
                        <span class="notification green">0</span>
                        <button type="button" id="btnclosebatch" style="height: 20px; width: 100px; color: white; margin-left: 33px; display: none" onclick="return CheckConfirm()" title="Click To Close Opened Batch" tabindex="6">Close Batch</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="padding-left: 10%; padding-right: 10%; font-family: Tahoma; display:none;">
        <br />
        <br />
        <h2 style="color: #9b0000; text-align: center">Welcome 
                 <asp:Label ID="lblName" runat="server" Text=""></asp:Label></h2>
        <div runat="server" visible="false" id="divCircular" class="divStyle1">
            <span style="font-size: 14pt">You have </span>
            <asp:Label ID="lblCircularCount" runat="server" Text="" Font-Size="14pt"></asp:Label><span style="font-size: 14pt">
                         unread circular.<img src="../App_Images/newcircular.gif" alt="" width="40" />
            </span><a id="aCircular" runat="server" href="~/Design/Circular/ViewCircular.aspx">
                <span style="font-size: 14pt">Read Now</span></a>
        </div>

        <div style=" padding: 5px; -moz-border-radius: 5px; -webkit-border-radius: 5px;  text-align: center;">        
             <div class="row">
                  <div class="col-md-24">  
            <table width="100%" class="well">
                <tr>
                    <td align="center">
                        <table>
                            <tr>
                                <td colspan="3" style="text-align:center"><span class="icon32 icon-color icon-user"></span></td>
                            </tr>
                            <tr style="display: none;">
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">Your Designation :</td>
                                <td style="text-align: left"></td>
                                <td style="width: 300px; text-align: left;">
                                    <asp:Label ID="lblDesignation" runat="server" Text=""></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right" ><span class="icon icon-color icon-clock"></span>You have logged in :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblModule" runat="server" Text=""></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right"><span class="icon icon-color icon-locked"></span>You
                     Current Login Time is :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblCLogin" runat="server" Text=""></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right"><span class="icon icon-color icon-unlocked"></span>You have
                     Last Logged Out at :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblLastLogin" runat="server" Text=""></asp:Label></td>
                            </tr>
                            <tr style="display: none;">
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">No. of Times You have Logged in :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblNoLogin" runat="server" Text=""></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right"><span class="icon icon-color icon-wrench"></span>Change your default login :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    </td>
                            </tr>
                            <tr>
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right"><span class="icon icon-color icon-users"></span>Today No. Of Patient Registered :</td>
                                <td style="text-align: left"></td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblPReg" runat="server" ForeColor="Red" Font-Bold="True" Font-Size="Larger"></asp:Label></td>
                            </tr>
                            <tr id="fr" runat="server" visible="false">
                                <td style="padding-right: 3px; font-weight: bold; width: 263px; text-align: right">Remaining Balance :</td>
                                <td style="text-align: left">&nbsp;</td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblAmount" runat="server" ForeColor="Red" Font-Bold="True" Font-Size="Larger"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

</div>
                 </div>
        </div>
        <br />
        <br />

        
        <div runat="server" id="news" visible="false" style="margin-bottom: 10px; border: solid 2px #83D13D; padding: 5px; -moz-border-radius: 5px; -webkit-border-radius: 5px; background-color: #F2FFE1; text-align: center;">
            <div style="overflow: hidden; overflow-y: auto;">
                <asp:GridView ID="GridNews" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <%# Eval("content") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
    </div>
    <asp:Button ID="btnHidden" runat="server" Visible="false" />
    <cc1:ModalPopupExtender ID="mpAlert" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragHandle" TargetControlID="btnHidden">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none" Width="656px">
        <div id="dragUpdate" runat="server">


            <div class="Purchaseheader">Software Alert</div>

            &nbsp; &nbsp; &nbsp; &nbsp;
        </div>
        <div class="content">
            <table cellpadding="0" cellspacing="0" style="width: 640px">
                <tr>
                    <td align="right" colspan="4" style="height: 16px">Date :
                                     <asp:Label ID="lblDueDate" runat="server"></asp:Label>&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td align="left" colspan="4" style="height: 16px">
                        <h2 style="color: #9b0000; text-align: left; vertical-align: middle">
                            <asp:Label ID="lblAlertName" runat="server"></asp:Label>&nbsp;</h2>
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="4" style="height: 16px">
                        <h3 style="color: #9b0000; text-align: left">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                        </h3>
                    </td>
                </tr>
                <tr>
                    <td align="right" colspan="4" style="height: 16px">
                        <span style="font-size: 12pt; color: #006600">Your system running on grace period,
                                         <asp:Label ID="lblDayLeft" runat="server"></asp:Label>
                            day left.</span></td>
                </tr>
                <tr>
                    <td style="width: 20%; height: 16px;" align="left"></td>
                    <td style="width: 20%; height: 16px;" align="left"></td>
                    <td style="width: 20%; height: 16px;" align="left"></td>
                    <td style="width: 20%; height: 16px;" align="left"></td>
                </tr>
                <tr>
                    <td align="left" style="width: 20%; height: 16px"></td>
                    <td align="left" style="width: 20%; height: 16px"></td>
                    <td align="right" style="width: 20%; height: 16px">
                        <asp:Button ID="btnClose" runat="server" Text="Skip" /></td>
                    <td align="center" style="width: 20%; height: 16px">
                        <input id="btnPaymentDetail" style="display: none;" type="button" value="PaymentDetail" />
                        <%--    <asp:Button ID="btnPaymentDetail" runat="server" Text="PaymentDetail" />--%>
                    </td>
                </tr>


            </table>
        </div>

        &nbsp;
    </asp:Panel>
    <script type="text/javascript">
        function onsucessClientIntimation(result) {

            if (result != "-2") {

                if (result.split('#')[1] == "1") {
                    $.alert({
                        title: 'Balance Amt. <b style="color: red; font-size: 1.0em; font-weight: bold;">: ' + result.split('#')[0] + ' </b>',
                        useBootstrap: false,
                        closeIcon: true,
                        columnClass: 'small',
                        boxWidth: '400px',
                        type: 'red',
                        content: '',
                    });
                }
            }

        }
        function onFailureClientIntimation(result) {

        }
        $(function () {
            PageMethods.ClientIntimation(onsucessClientIntimation, onFailureClientIntimation);

        });

    </script>
    
</asp:Content>
