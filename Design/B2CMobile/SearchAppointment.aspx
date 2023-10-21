<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SearchAppointment.aspx.cs" Inherits="Design_PROApp_SearchAppointment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/webcamjs/webcam.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/InvalidContactNo.js"></script>
    <script type="text/javascript" src="../../Scripts/titleWithGender.js"></script>
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <style type="text/css">
        .prodiv {
            background: whitesmoke;
            position: relative;
            top: 50%;
            left: 40%;
            margin-top: -50px;
            margin-left: -40px;
            width: 500px;
            z-index: 1;
            border: 1px solid;
        }

        .topdiv {
            position: absolute;
            left: 0px;
            top: 0px;
            width: 100%;
            height: 100%;
            display: none;
            background: rgb(198, 223, 249);
            background: rgba(198, 223, 249, 0.5);
            filter: alpha(opacity=90);
        }
    </style>
    <asp:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/Lis.asmx" />
        </Services>
    </asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Appointment Booking</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Option 
            </div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">Date Option   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddldateoption" runat="server">
                        <asp:ListItem Value="EntryDate">Entry Date</asp:ListItem>
                        <asp:ListItem Value="AppDate">Appointment Date</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="cal1" runat="server" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"
                        PopupButtonID="txtfromdate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txttodate" runat="server" Width="128px"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate"
                        Format="dd-MMM-yyyy" PopupButtonID="txttodate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Phlebo Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlProName" runat="server" Width="200px">
                    </asp:DropDownList>
                </div>
            </div>

            <div class="row" style="text-align: center">
                <input id="btnsave" type="button" value="Search" onclick="searchdata('')" class="searchbutton" style="width: 150px;"
                    tabindex="0" />
                <asp:Button ID="btnshowaddpopup" runat="server" Text="Add New" OnClientClick="clearform2()"
                    class="resetbutton" Style="width: 150px;" />

                <input type="button" id="btnreport" onclick="getreport()" value="Excel Report" class="savebutton" style="width: 150px;" />
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <table width="100%">
                    <tr>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: white;"
                            onclick="searchdata('Open')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Open
                        </td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #B0C4DE;"
                            onclick="searchdata('App Confirm')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>App<br />
                            Confirm
                        </td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;"
                            onclick="searchdata('PhleboAssign')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Phlebo<br />
                            Assign
                        </td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;"
                            onclick="searchdata('SampleCollectedHome')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Sample<br />
                            Collected Home
                        </td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #00FFFF;"
                            onclick="searchdata('BookingDone')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Booking
                            <br />
                            Done
                        </td>

                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #E2680A;"
                            onclick="searchdata('Cancel')">&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Cancel
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <div class="Purchaseheader">
                Patient Data
            </div>
            <div class="content" style="width: 99.6%;">
                <div style="height: 300px!important">
                    <table id="grd" style="width: 99%;" class="GridViewStyle" cellspacing="0" rules="all"
                        border="1">
                        <thead></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="addpanel" runat="server" Style="background-color: whitesmoke; display: none;">
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <b>Phone Call Booking</b>
                <asp:ImageButton ID="btnclose" runat="server" AlternateText="Close" Style="float: right; height: 50px; width: 50px; top: -18px; right: -20px; position: absolute"
                    ImageUrl="~/Design/Purchase/Image/cancel2.png" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <asp:HiddenField ID="hidAppid" runat="server" />
                <div class="col-md-5">
                    <label class="pull-left">Patient Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:DropDownList ID="ddltitle" Width="60px" runat="server" onChange="return AutoGender();">
                        <asp:ListItem>Mr.</asp:ListItem>
                        <asp:ListItem>Mrs.</asp:ListItem>
                        <asp:ListItem>Miss.</asp:ListItem>
                        <asp:ListItem>Baby.</asp:ListItem>
                        <asp:ListItem>Baba.</asp:ListItem>
                        <asp:ListItem>Master.</asp:ListItem>
                        <asp:ListItem>Dr.</asp:ListItem>
                        <asp:ListItem>B/O</asp:ListItem>
                        <asp:ListItem>Ms.</asp:ListItem>
                        <asp:ListItem>Dog</asp:ListItem>
                        <asp:ListItem>Cat</asp:ListItem>
                        <asp:ListItem>Horse</asp:ListItem>
                        <asp:ListItem>C/O</asp:ListItem>
                    </asp:DropDownList>

                    <asp:TextBox ID="txtname" runat="server" Width="210px" class="txtonly"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Mobile   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtmobile" runat="server" Width="128px" MaxLength="10" class="numbersOnly"
                        onkeyup="showlength()"></asp:TextBox>
                    <span id="mobilenocounter" style="font-weight: bold"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <asp:RadioButton ID="rdAge" onclick="setdobop1(this)" runat="server" Checked="True" GroupName="rdDOB" ForeColor="red" Text="Age      : " />
                </div>
                <div class="col-md-15">
                    <asp:TextBox ID="txtage" runat="server" Width="40px" class="numbersOnly"></asp:TextBox>Y
                            <asp:TextBox ID="txtmonth" runat="server" Width="40px" class="numbersOnly"></asp:TextBox>M
                            <asp:TextBox ID="txtdays" runat="server" Width="40px" class="numbersOnly"></asp:TextBox>D
                            <asp:DropDownList ID="ddlage" runat="server" Style="display: none">
                                <asp:ListItem>YRS</asp:ListItem>
                                <asp:ListItem>MONTHS</asp:ListItem>
                                <asp:ListItem>DAYS</asp:ListItem>
                            </asp:DropDownList>
                    <i>(Ex:- 24Y 4M 0D)</i>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <asp:RadioButton ID="rdDOB" onclick="setdobop(this)" runat="server" GroupName="rdDOB" Text="Date of Birth     : " />
                </div>
                <div class="col-md-15">
                    <asp:TextBox ID="txtdob" onblur="getagefun()" CssClass="datepicker" runat="server" Width="128px"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtdob"
                        Format="dd-MMM-yyyy" PopupButtonID="txtdob">
                    </cc1:CalendarExtender>
                </div>
            </div>

            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">Gender   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                    <asp:RadioButton ID="rbmail" Text="Male" GroupName="g" runat="server" Checked="true" />
                    <asp:RadioButton ID="rbfemail" Text="Female" GroupName="g" runat="server" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">Email   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                    <asp:TextBox ID="txtemail" runat="server" Width="128px"></asp:TextBox>

                </div>
                <div class="col-md-4">
                    <label class="pull-left">Address   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtaddress" runat="server" Width="200px"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">App Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                    <asp:TextBox ID="txtappdate" runat="server" Width="100px"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtappdate" OnClientDateSelectionChanged="dateSelectionChanged"
                        Format="dd-MMM-yyyy" PopupButtonID="txtappdate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">App Time   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <select id="ddlApptimebooking" style="width: 162px;">
                    </select>

                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">Remark   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-12">
                    <asp:TextBox ID="txtremarkssave" runat="server"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="float: left;">
                <table cellpadding="0" cellspacing="0">
                    <tr style="vertical-align: top;">
                        <td>
                            <asp:RadioButtonList ID="rblsearchtype" runat="server" RepeatDirection="Horizontal"
                                RepeatLayout="Flow">
                                <asp:ListItem Selected="True" Value="0">By Code</asp:ListItem>
                                <asp:ListItem Selected="True" Value="1">By First Name</asp:ListItem>
                                <asp:ListItem Value="2"> InBetween</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rdbItem" CssClass="ItDoseRadiobuttonlist" runat="server"
                                Visible="false" RepeatDirection="Horizontal" RepeatLayout="Flow" OnSelectedIndexChanged="rdbItem_SelectedIndexChanged">
                                <asp:ListItem Text="Investigations" Value="3" Selected="True" />
                                <asp:ListItem Text="Item Code" Value="4" />
                            </asp:RadioButtonList>
                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="ItDoseDropdownbox"
                                Width="174px" Visible="false">
                            </asp:DropDownList>
                            <br />
                            <asp:TextBox ID="txtSearch" runat="server" Width="364px" CssClass="ItDoseTextinputText"
                                TabIndex="9" AutoCompleteType="None" /><br />
                            <asp:ListBox ID="lstInv" runat="server" Width="369px" Height="160px" CssClass="ItDoseDropdownbox" />
                        </td>
                        <td style="vertical-align: middle;">
                            <asp:Button ID="btnSelect" runat="server" Text=">>" CausesValidation="false" CssClass="ItDoseButton"
                                Enabled="False" Style="display: none;"></asp:Button><br />
                            <br />
                            <input id="Button4" type="button" value=">>" class="ItDoseButton" onclick="AddItem();" />
                        </td>
                        <td>
                            <div id="div_item" style="height: 200px; overflow: auto;">
                                <span style="font-weight: bold;">Total Test ::&nbsp; </span><span id="testcount"
                                    style="font-weight: bold;">0</span>
                                <br />
                                <table id="tb_ItemList" cellspacing="0">
                                    <tr id="Header">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#
                                        </td>
                                        <td class="GridViewHeaderStyle" style="width: 200px;">Item
                                        </td>
                                        <%--<td class="GridViewHeaderStyle" style="width:80px;" >Date</td>--%>
                                        <td class="GridViewHeaderStyle" style="width: 40px;">Rate
                                        </td>
                                        <td class="GridViewHeaderStyle" style="width: 40px; display: none">Disc.
                                        </td>
                                        <td class="GridViewHeaderStyle" style="width: 40px;">Amt.
                                        </td>
                                        <td style="display: none;"></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-12" style="display: none">

                    <asp:CheckBoxList ID="chkPaymentMode" runat="server" RepeatDirection="Horizontal"
                        Visible="False">
                        <asp:ListItem Selected="True">CASH</asp:ListItem>
                        <asp:ListItem>CREDIT-CARD</asp:ListItem>
                        <asp:ListItem>CHEQUE/DD</asp:ListItem>
                        <asp:ListItem>CREDIT</asp:ListItem>
                    </asp:CheckBoxList>
                    <input id="chkPaymentMode1" type="checkbox" value="1" onclick="bindMultiple();" />
                    CASH
                                <input id="chkPaymentMode2" type="checkbox" value="2" onclick="bindMultiple();" />
                    CREDIT-CARD
                                <input id="chkPaymentMode3" type="checkbox" value="3" onclick="bindMultiple();" />
                    CHEQUE/DD&nbsp;
                                <input id="chkPaymentMode4" type="checkbox" value="4" onclick="bindMultiple();" />
                    CREDIT
                </div>
                <div class="col-md-12">
                    &nbsp; &nbsp; Total :&nbsp;<asp:TextBox ID="txtTotal" CssClass="ItDoseTextinputText" runat="server"
                        Width="60px" Enabled="true" Columns="10">0</asp:TextBox>
                    &nbsp; &nbsp;
                                <asp:Label ID="lblAmount" Font-Bold="true" runat="server" Text="" ForeColor="red" Visible="false"></asp:Label>
                    &nbsp;&nbsp;&nbsp; 
                                <label id="lblBalAmt" style="color: Red; font-weight: bold;">
                                </label>
                    &nbsp; &nbsp; &nbsp;
                </div>
            </div>


            <div class="row" style="text-align: left; display: none">
                <table id="tb_Payment" cellspacing="0">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px">#
                        </td>
                        <td class="GridViewHeaderStyle" style="width: 200px">Payment Mode
                        </td>
                        <%--<td class="GridViewHeaderStyle" style="width:80px;" >Date</td>--%>
                        <td class="GridViewHeaderStyle" style="width: 60px">Amount
                        </td>
                        <td class="GridViewHeaderStyle" style="width: 200px">Cheque No./Credit Card No.
                        </td>
                        <td class="GridViewHeaderStyle" style="width: 100px">Bank Name
                        </td>
                    </tr>
                    <tr id="tr_PM_1" style="display: none;">
                        <td></td>
                        <td>Cash
                        </td>
                        <%--<td  style="width:80px;" >Date</td>--%>
                        <td>
                            <input id="txt_tr_Amt1" onkeyup="BalAmt();" type="text" style="width: 60px;" tabindex="8" />
                            <input id="txtInvID" type="text" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr id="tr_PM_2" style="display: none;">
                        <td></td>
                        <td>Credit Card
                        </td>
                        <td>
                            <input id="txt_tr_Amt2" onkeyup="ShowBalAmt();" type="text" style="width: 60px;" />
                        </td>
                        <td>
                            <input id="txt_tr_CC2" type="text" style="width: 201px;" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddl_tr_Bank2" runat="server" Width="176px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="tr_PM_3" style="display: none;">
                        <td></td>
                        <td>Cheque / DD
                        </td>
                        <td>
                            <input id="txt_tr_Amt3" onkeyup="ShowBalAmt();" type="text" style="width: 60px;" />
                        </td>
                        <td>
                            <input id="txt_tr_CC3" type="text" style="width: 200px;" />
                        </td>
                        <td>
                            <asp:DropDownList ID="ddl_tr_Bank3" runat="server" Width="176px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="tr_PM_4" style="display: none;">
                        <td></td>
                        <td>Credit To Panel
                        </td>
                        <td>
                            <input id="txt_tr_Amt4" type="text" style="width: 60px;" readonly="readonly" />
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
            </div>
            <asp:Label ID="lblMsg1" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory" id="Div_out">
            <div class="row">

                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Paid Amount   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtpaidamount" runat="server" Width="75px" onkeyup="ShowBalAmt();" />
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Discount Amount   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">

                        <asp:TextBox ID="txtDisAmount" runat="server" TabIndex="17" OnKeyUp="sumTotal(this);" onblur="sumTotal(this);"
                            onKeyDown="sumTotal(this);" CssClass="ItDoseTextinputText" Width="75px" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Discount Reason   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <asp:TextBox ID="txtDiscReason" runat="server" CssClass="ItDoseTextinputText" TabIndex="20" Width="200px" />
                    </div>
                    <div class="col-md-12">
                        <label id="Label2" style="color: Red; font-weight: bold;">
                        </label>
                    </div>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center;">
                <input id="btnsavedata" type="button" value="Save" onclick="savedata()" />
                <input id="btnclear" type="button" value="Clear" onclick="clearform()" />
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelobs" runat="server" CancelControlID="btnclose" TargetControlID="btnshowaddpopup"
        BackgroundCssClass="filterPupupBackground" PopupControlID="addpanel">
    </cc1:ModalPopupExtender>
    <div class="topdiv" id="Pro">
        <div class="prodiv">
            <img onclick="hidediv()" style="float: right; height: 50px; width: 50px; top: -18px; right: -20px; position: absolute"
                src="../Purchase/Image/cancel2.png" />
            <div class="row">
                <span id="appidspan" style="display: none;"></span>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <label class="pull-left">App DateTime   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-12">
                    <span id="appspandate"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <label class="pull-left">PRO   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-12">
                    <select id="ddlpro" style="width: 162px;" onchange="SelectedPRO()">
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <label class="pull-left">Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">

                    <asp:TextBox ID="txtassigndate" runat="server" Width="100px"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtassigndate" OnClientDateSelectionChanged="dateSelectionChanged"
                        Format="dd-MMM-yyyy" PopupButtonID="txtassigndate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-6">
                    <label class="pull-left">Time   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <select id="ddlTimeSlot" style="width: 100px;">
                    </select>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" id="savebtn" value="Save" onclick="savepro()" class="savebutton" />
            </div>
        </div>
    </div>
    <div class="topdiv" id="canceldiv">
        <div class="prodiv">
            <div class="row">
                <img onclick="hidecanceldiv()" src="../Purchase/Image/cancel2.png" style="float: right; height: 40px; width: 40px; top: -18px; right: -20px; position: absolute; cursor: pointer;" />
                <div class="col-md-6">
                    <label class="pull-left">Cancel Appointment  </label>
                    <b class="pull-right"></b>
                </div>
                <div class="row">
                    <span id="msgcancel" style="display: none;"></span>
                </div>
                <div class="row">
                    <span id="idforcancel" style="display: none;"></span>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Cancel Reason  </label>
                        <b class="pull-right"></b>
                    </div>
                    <select id="ddlCancelReason" style="width: 162px;" onchange="IsOther()">
                    </select>
                </div>
                <div class="row" style="display: none" id="txtothershow">
                    <div class="col-md-6">
                        <label class="pull-left">Other Reason   </label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtcancelreason" runat="server" Width="200px" TextMode="MultiLine" />
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" id="Button1" value="Save" class="savebutton" onclick="cancelapp()" />

                </div>
            </div>
        </div>
        <div class="topdiv" id="opendiv">
            <div class="prodiv">
                <div class="row">Reopen Appointment</div>
                <div class="row">
                    <img onclick="hideopendiv()" src="../Purchase/Image/cancel2.png" style="float: right; height: 40px; width: 40px; top: -18px; right: -20px; position: absolute; cursor: pointer;" />
                </div>
                <div class="row">
                    <span id="spopen" style="color: red;"></span>
                </div>
                <div class="row">
                    <span id="idforopendiv" style="display: none;"></span>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Reopen Reason    </label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtremarksforopen" runat="server" Width="200px" TextMode="MultiLine" />
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" id="Button3" value="Re-Open" onclick="reopenapp()" />
                </div>
            </div>
        </div>
        <asp:Panel ID="panellog" runat="server" Style="background-color: whitesmoke; display: none; width: 400px;">
            <div class="POuter_Box_Inventory" style="width: 400px;">
                <div class="content" style="text-align: center">
                    <b></b>
                    <asp:ImageButton ID="ImageButton1" runat="server" AlternateText="Close" Style="float: right; height: 50px; width: 50px; top: -18px; right: -20px; position: absolute"
                        ImageUrl="~/Design/Purchase/Image/cancel2.png" />
                    <br />
                    <span id="spid" style="display: none;"></span>
                    <div class="row" style="text-align: left" id="logtable">

                        <span id="ssremarks" style="font-weight: bold;"></span>
                    </div>
                </div>
            </div>

        </asp:Panel>
        <div class="topdiv" id="showpopdata">
            <div class="prodiv">
                <img onclick="hidediv()" style="float: right; height: 30px; width: 30px; top: -18px; right: -20px; position: absolute"
                    src="../Purchase/Image/cancel2.png" />

                <div class="content">
                    <table id="PopupTable" style="width: 99%;" class="GridViewStyle" cellspacing="0" rules="all"
                        border="1">
                    </table>
                </div>
            </div>
        </div>
        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="ImageButton1"
            TargetControlID="Button2" PopupControlID="showpopdata">
        </cc1:ModalPopupExtender>
        <cc1:ModalPopupExtender ID="poplog" runat="server" CancelControlID="ImageButton1"
            TargetControlID="Button2" BackgroundCssClass="filterPupupBackground" PopupControlID="panellog">
        </cc1:ModalPopupExtender>
        <asp:Button ID="Button2" runat="server" Style="display: none;" />
        <script type="text/javascript">
            function dateSelectionChanged(sender, args) {
                var todayDate = new Date();
                selectedDate = sender.get_selectedDate();
                if (selectedDate > todayDate.addDays(10)) {
                    sender._selectedDate = new Date();
                    toast("Error", "You can't select more than 10 days", "");
                    sender._selectedDate = new Date();
                    sender._textbox.set_Value(sender._selectedDate.format(sender._format))
                }
            }
            Date.prototype.addDays = function (days) {
                this.setDate(this.getDate() + parseInt(days));
                return this;
            };
            function ShowPop(appid) {
                $('#showpopdata').show();
                $('#PopupTable').empty();
                serverCall('SearchAppointment.aspx/popupData', { id: appid }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length == 0) {
                        toast("Error", 'No Record Found..!', "");
                    }
                    else {
                        toast("Error", 'Total ' + PatientData.length + ' Found', "");
                        $('#PopupTable').append('<tr id="Header"><td class="GridViewHeaderStyle" scope="col">Sr No.</td> <td class="GridViewHeaderStyle" scope="col">App ID</td> <td class="GridViewHeaderStyle" scope="col">App Book From</td> <td class="GridViewHeaderStyle" scope="col">App Book By</td> <td class="GridViewHeaderStyle" scope="col">Pro Assign Date</td> <td class="GridViewHeaderStyle" scope="col">Status</td></tr>');
                        for (var a = 0; a <= PatientData.length - 1; a++) {
                            var $appendText = [];
                            $appendText.push('<tr style="background-color:'); $appendText.push(PatientData[a].rowColor); $appendText.push('" id='); $appendText.push(PatientData[a].id); $appendText.push('><td>'); $appendText.push(parseFloat(a + 1)); $appendText.push('</td> <td>'); $appendText.push(PatientData[a].id); $appendText.push('</td> <td>'); $appendText.push(PatientData[a].appfrom); $appendText.push('</td> <td>'); $appendText.push(PatientData[a].appbook_byname); $appendText.push('</td> <td>'); $appendText.push(PatientData[a].assign_date); $appendText.push('</td> <td id="apptm">'); $appendText.push(PatientData[a].STATUS); $appendText.push('</td> </tr>');

                            $appendText = $appendText.join("");
                            $('#PopupTable').append($appendText);

                        }
                    }
                });
            }
            function EditInvestigation(ids) {
                clearform();
                debugger;

                $('#<%=hidAppid.ClientID%>').val(ids);
                if (ids != '') {
                    $("#<%=btnshowaddpopup.ClientID%>").click();
                    serverCall('SearchAppointment.aspx/getAppointment', { ids: ids }, function (response) {
                        PatientData = jQuery.parseJSON(response);
                        if (PatientData.length == 0) {
                            toast("Error", 'No Record Found..!', "");
                        }
                        else {
                            $('#<%=ddltitle.ClientID%>').val(PatientData[0].Title);
                            $('#<%=txtname.ClientID%>').val(PatientData[0].NAME);
                            $("#<%=txtmobile.ClientID %>").val(PatientData[0].Mobile);
                            $("#<%=txtage.ClientID %>").val(PatientData[0].Age.split(' ')[0]);
                            $("#<%=txtmonth.ClientID %>").val(PatientData[0].Age.split(' ')[2]);
                            $("#<%=txtdays.ClientID %>").val(PatientData[0].Age.split(' ')[4]);
                            $('#<%=ddlage.ClientID%>').val(PatientData[0].Age.split(' ')[1]);
                            if (PatientData[0].Gender == 'M' || PatientData[0].Gender == 'Male') {
                                $('#<%=rbmail.ClientID%>').attr('checked', 'checked');
                            }
                            else {
                                $('#<%=rbfemail.ClientID%>').attr('checked', 'checked');
                            }
                            $("#<%=txtappdate.ClientID %>").val(PatientData[0].App_date.split(' ')[0]);

                            try {
                                $("#ddlApptimebooking").val(PatientData[0].TimeSlot);
                            } catch (e) {
                                $("#ddlApptimebooking").val('Select');
                            }
                            $("#<%=txtdob.ClientID%>").val(PatientData[0].dob);
                            $("#<%=txtaddress.ClientID %>").val(PatientData[0].Address);
                            document.getElementById('<%=ddlage.ClientID %>').selectedIndex = 0;
                            var testid = PatientData[0].TestName.split(',');
                            debugger;
                            for (var k = 0; k < testid.length; k++) {
                                txtCtrl = "";
                                valCtrl = "";
                                serverCall('SearchAppointment.aspx/GetItemDetails', { itemId: testid[k] }, function (response) {
                                    if (response != "") {
                                        var itemdata = jQuery.parseJSON(response)
                                        txtCtrl = itemdata[0].TypeName;
                                        valCtrl = itemdata[0].ItemID;
                                        AddNewItemByEdit(itemdata[0].Rate);
                                    }
                                });
                            }
                        }
                    });
                }
            }
            function searchdata(status) {
                $('#grd thead').empty();
                $('#grd tbody').empty();
                serverCall('SearchAppointment.aspx/Searchdata', { Fromdate: $("#<%=txtfromdate.ClientID %>").val(), Todate: $("#<%=txttodate.ClientID %>").val(), status: status, dateoption: $("#<%=ddldateoption.ClientID %> option:selected").val(), ProAssign: $("#<%=ddlProName.ClientID %> option:selected").text() }, function (response) {

                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length == 0) {
                        toast("Error", 'No Record Found..!', "");
                    }
                    else {
                        toast("Error", 'Total ' + PatientData.length + ' Found', "");
                        $('#grd').append('<tr id="Header"><td class="GridViewHeaderStyle" scope="col">Sr No.</td> <td class="GridViewHeaderStyle" scope="col">Name</td><td class="GridViewHeaderStyle" scope="col">Mobile</td><td class="GridViewHeaderStyle" scope="col">Gender</td><td class="GridViewHeaderStyle" scope="col">Age</td><td class="GridViewHeaderStyle" scope="col">Entry Date</td><td class="GridViewHeaderStyle" scope="col">App Date</td><td class="GridViewHeaderStyle" scope="col">Phlebo Name</td><td class="GridViewHeaderStyle" scope="col">TestName</td><td class="GridViewHeaderStyle" scope="col">Select Phlebo</td><td class="GridViewHeaderStyle" scope="col">Phlebo Assign Date</td><td class="GridViewHeaderStyle" scope="col" style="display:none">Status</td><td class="GridViewHeaderStyle" scope="col">Change Status</td><td class="GridViewHeaderStyle" scope="col">Rmks</td><td style="display:none;" class="GridViewHeaderStyle" scope="col">View Log</td><td  class="GridViewHeaderStyle" scope="col">Img</td><td  class="GridViewHeaderStyle" scope="col">Edit</td></tr>');
                        for (var a = 0; a <= PatientData.length - 1; a++) {
                            var $appendText = [];
                            if (PatientData[a].remarks != "") {
                                if (PatientData[a].pathcount == "1") {
                                    $appendText.push('<tr style="background-color:'); $appendText.push(PatientData[a].rowColor); $appendText.push('" id='); $appendText.push(PatientData[a].id); $appendText.push('><td><img src="../Purchase/Image/Plus_in.gif" onclick="ShowPop('); $appendText.push(PatientData[a].id); $appendText.push(')"/>'); $appendText.push(parseFloat(a + 1)); $appendText.push('</td><td>'); $appendText.push(PatientData[a].NAME); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Mobile); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Gender); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Age); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Entrydate); $appendText.push('</td><td id="apptm">'); $appendText.push(PatientData[a].App_date); $appendText.push('</td><td id="pro">'); $appendText.push(PatientData[a].proname); $appendText.push('</td><td id="test">'); $appendText.push(PatientData[a].TestName); $appendText.push('</td> <td><img id="tdpro" src="../Purchase/Image/Post.gif" onclick="openPROform('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td id="assdate">'); $appendText.push(PatientData[a].assign_date); $appendText.push('</td><td id="status" style="display:none">'); $appendText.push(PatientData[a].STATUS); $appendText.push('</td> <td><input style="display:none;" type="button" value="Confirm" id="btnconfirm" onclick="confirmapp(' + PatientData[a].id + ')"/><select id="ddlstatus" onchange="openform('); $appendText.push(PatientData[a].id); $appendText.push(',this)"><option>Open</option><option>AppConfirm</option><option>PhleboAssign</option><option>SampleCollectedHome</option><option>Cancel</option></select>'); $appendText.push(PatientData[a].cancel_reason); $appendText.push('</td><td align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog(\''); $appendText.push(PatientData[a].remarks); $appendText.push('\')"  /></td><td style="display:none;" align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td  align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openIMG('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td  align="center"><img src="../Purchase/Image/View.gif" id="txtEdit"  style="border:none;" onclick="EditInvestigation('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td></tr>');
                                }
                                else {
                                    $appendText.push('<tr style="background-color:'); $appendText.push(PatientData[a].rowColor); $appendText.push('" id='); $appendText.push(PatientData[a].id); $appendText.push('><td><img src="../Purchase/Image/Plus_in.gif" onclick="ShowPop('); $appendText.push(PatientData[a].id + ')"/>'); $appendText.push(parseFloat(a + 1)); $appendText.push('</td><td>'); $appendText.push(PatientData[a].NAME); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Mobile); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Gender); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Age); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Entrydate); $appendText.push('</td><td id="apptm">'); $appendText.push(PatientData[a].App_date); $appendText.push('</td><td id="pro">'); $appendText.push(PatientData[a].proname + '</td><td id="test">'); $appendText.push(PatientData[a].TestName); $appendText.push('</td> <td><img id="tdpro" src="../Purchase/Image/Post.gif" onclick="openPROform('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td id="assdate">'); $appendText.push(PatientData[a].assign_date); $appendText.push('</td><td id="status" style="display:none">'); $appendText.push(PatientData[a].STATUS); $appendText.push('</td> <td><input style="display:none;" type="button" value="Confirm" id="btnconfirm" onclick="confirmapp('); $appendText.push(PatientData[a].id); $appendText.push(')"/><select id="ddlstatus" onchange="openform('); $appendText.push(PatientData[a].id); $appendText.push(',this)"><option>Open</option><option>AppConfirm</option><option>PhleboAssign</option><option>SampleCollectedHome</option><option>Cancel</option></select>'); $appendText.push(PatientData[a].cancel_reason); $appendText.push('</td><td align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog(\''); $appendText.push(PatientData[a].remarks); $appendText.push('\')"  /></td><td style="display:none;" align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog(' + PatientData[a].id + ')"/></td><td  align="center"> </td><td  align="center"><img src="../Purchase/Image/View.gif" id="txtEdit"  style="border:none;" onclick="EditInvestigation('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td></tr>');

                                }

                            }
                            else {
                                if (PatientData[a].pathcount == "1") {
                                    $appendText.push('<tr style="background-color:'); $appendText.push(PatientData[a].rowColor); $appendText.push('" id='); $appendText.push(PatientData[a].id); $appendText.push('><td><img src="../Purchase/Image/Plus_in.gif" onclick="ShowPop(' + PatientData[a].id + ')"/>'); $appendText.push(parseFloat(a + 1)); $appendText.push('</td><td>'); $appendText.push(PatientData[a].NAME); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Mobile); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Gender); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Age); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Entrydate); $appendText.push('</td><td id="apptm">'); $appendText.push(PatientData[a].App_date); $appendText.push('</td><td id="pro">'); $appendText.push(PatientData[a].proname); $appendText.push('</td><td id="test">'); $appendText.push(PatientData[a].TestName); $appendText.push('</td> <td><img id="tdpro" src="../Purchase/Image/Post.gif" onclick="openPROform('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td> <td id="assdate">' + PatientData[a].assign_date); $appendText.push('</td><td id="status" style="display:none">'); $appendText.push(PatientData[a].STATUS); $appendText.push('</td><td><input style="display:none;" type="button" value="Confirm" id="btnconfirm" onclick="confirmapp('); $appendText.push(PatientData[a].id); $appendText.push(')"/><select id="ddlstatus" onchange="openform(' + PatientData[a].id); $appendText.push(',this)"><option>Open</option><option>AppConfirm</option><option>PhleboAssign</option><option>SampleCollectedHome</option><option>Cancel</option></select>'); $appendText.push(PatientData[a].cancel_reason); $appendText.push('</td><td align="center"></td><td style="display:none;" align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td  align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openIMG('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td><td  align="center"><img src="../Purchase/Image/View.gif" id="txtEdit" style="border:none;" onclick="EditInvestigation('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td></tr>');
                                }
                                else {
                                    $appendText.push('<tr style="background-color:'); $appendText.push(PatientData[a].rowColor); $appendText.push('" id=' + PatientData[a].id); $appendText.push('><td><img src="../Purchase/Image/Plus_in.gif" onclick="ShowPop('); $appendText.push(PatientData[a].id); $appendText.push(')"/>'); $appendText.push(parseFloat(a + 1)); $appendText.push('</td><td>'); $appendText.push(PatientData[a].NAME); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Mobile); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Gender); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Age); $appendText.push('</td><td>'); $appendText.push(PatientData[a].Entrydate); $appendText.push('</td><td id="apptm">'); $appendText.push(PatientData[a].App_date); $appendText.push('</td><td id="pro">' + PatientData[a].proname + '</td><td id="test">'); $appendText.push(PatientData[a].TestName); $appendText.push('</td> <td><img id="tdpro" src="../Purchase/Image/Post.gif" onclick="openPROform('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td> <td id="assdate">'); $appendText.push(PatientData[a].assign_date); $appendText.push('</td><td id="status" style="display:none">'); $appendText.push(PatientData[a].STATUS); $appendText.push('</td><td><input style="display:none;" type="button" value="Confirm" id="btnconfirm" onclick="confirmapp('); $appendText.push(PatientData[a].id); $appendText.push(')"/><select id="ddlstatus" onchange="openform('); $appendText.push(PatientData[a].id); $appendText.push(',this)"><option>Open</option><option>AppConfirm</option><option>PhleboAssign</option><option>SampleCollectedHome</option><option>Cancel</option></select>'); $appendText.push(PatientData[a].cancel_reason); $appendText.push('</td><td align="center"></td><td style="display:none;" align="center"><img src="../Purchase/Image/View.gif"  style="border:none;" onclick="openlog('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td> <td  align="center"> </td><td  align="center"><img src="../Purchase/Image/View.gif" id="txtEdit" style="border:none;" onclick="EditInvestigation('); $appendText.push(PatientData[a].id); $appendText.push(')"/></td></tr>');

                                }
                            }
                            $appendText = $appendText.join("");
                            $('#grd tbody').append($appendText);
                        }
                        tablefuncation();
                        $("#grd").tableHeadFixer();
                    }
                });
            }
            function CreateTableView(objArray, theme, enableHeader) {
                // set optional theme parameter
                if (theme === undefined) {
                    theme = ''; //default theme
                }
                if (enableHeader === undefined) {
                    enableHeader = true; //default enable headers
                }
                // If the returned data is an object do nothing, else try to parse
                var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

                var str = '<table class="' + theme + '">';
                // table head
                if (enableHeader) {
                    str += '<thead><table><tbody><tr>';
                    for (var index in array[0]) {
                        str += '<th scope="col">' + index + '</th>';
                        break;
                    }
                    str += '</tr></tbody></table></thead>';
                }
                // table body
                str += '<tbody>';
                for (var i = 0; i < array.length; i++) {
                    str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
                    for (var index in array[i]) {
                        if (array[i][index] == null) {
                            str += '<td> </td>';
                        }
                        else {
                            str += '<td>' + array[i][index] + '</td>';
                        }
                    }
                    str += '</tr>';
                }
                str += '</tr></tbody>'
                str += '</table>';
                return str;
            }
            function tablefuncation() {
                $('#grd tr').each(function () {
                    if ($(this).attr("id") != "Header") {
                        $('#savebtn').show();
                        $(this).find('#ddlstatus option:contains("' + $(this).find('#status').html() + '")').attr('selected', 'selected');
                        $(this).find('#ddlstatus').removeAttr("disabled");
                        if ($(this).find('#status').html() == 'Cancel') {
                            $(this).find('#ddlstatus').hide();
                            $(this).find('#btnProSelect').hide();
                            $(this).find('#txtEdit').hide();
                        }
                        if ($(this).find('#status').html() == 'BookingDone') {
                            $(this).find('#ddlstatus').attr("disabled", "disabled");
                            $(this).find('#btnProSelect').hide();
                            $(this).find('#txtEdit').hide();

                        }
                    }
                });

            }
            function openPROform(id) {
                debugger;
                $('#grd1').empty();
                $('#Pro').show();
                BindPro();
                BindTimeSlot();
                $('#savebtn').val('Save');
                $('#appidspan').html(id);
                $('#appspandate').html($('#' + id).find('#apptm').html());
                var appdatetime = $('#' + id).find('#apptm').html().split(' ');
                $('#<%=txtassigndate.ClientID%>').val(appdatetime[0]);
                $('#ddlTimeSlot').val(appdatetime[1]);
                $("#ddlpro option:contains(" + $('#' + id).find('#pro').html() + ")").attr('selected', 'selected');

                if ($('#' + id).find('#status').html() == 'BookingDone' || $('#' + id).find('#status').html() == 'Cancel') {
                    $('#savebtn').hide();
                    $("#ddlpro").attr("disabled", "disabled");
                    $("#ddlTimeSlot").attr("disabled", "disabled");
                    $('#<%=txtassigndate.ClientID%>').attr("disabled", "disabled");
                }
                else {
                    $('#savebtn').show();
                    $("#ddlpro").removeAttr("disabled");
                    $("#ddlTimeSlot").removeAttr("disabled");
                    $('#<%=txtassigndate.ClientID%>').removeAttr("disabled");
            }
        }
        function openform(id, ddl) {
            debugger;
            var status = $('#' + id).find("#ddlstatus option:selected").text();
            if (status == "AppConfirm") {
                if (confirm("Do You Want To Confirm This Appointment")) {
                    serverCall('SearchAppointment.aspx/ConfirmApp', { Appid: id }, function (response) {

                        if (response == "True") {
                            //alert("Appointment Confirmed..!");
                            $('#' + id).css('background-color', '#B0C4DE');

                        }
                    });
                }
            }
            else if (status == "SampleCollectedHome") {
                serverCall('SearchAppointment.aspx/SampleCollectedApp', { Appid: id }, function (response) {
                    if (response == "True") {
                        $('#' + id).css('background-color', 'pink');
                    }
                });
            }
            else if (status == "PhleboAssign") {
                $('#Pro').show();
                $('#savebtn').val('Save');
                $('#appidspan').html(id);
                $('#appspandate').html($('#' + id).find('#apptm').html());
                BindPro();
                BindTimeSlot();
                $('#<%=txtassigndate.ClientID%>').val($('#' + id).find('#apptm').html().split(' ')[0]);
                $('#ddlTimeSlot').val($('#' + id).find('#apptm').html().split(' ')[1]);
            }
            else if (status == "Reshedule") {
                $('#Pro').show();
                $('#savebtn').val('Reshedule');
                $('#appidspan').html(id);
                BindPro();
                BindTimeSlot();
                $("#ddlpro option:contains(" + $('#' + id).find('#pro').html() + ")").attr('selected', 'selected');
                var d = new Date($('#' + id).find('#assdate').html());
                $('#<%=txtassigndate.ClientID%>').val(d.format("dd-MMM-yyyy"));
            }
            else if (status == "Cancel") {
                $('#canceldiv').show();
                $('#idforcancel').html(id);
                $('#<%=txtcancelreason.ClientID%>').val('');
                BindCancelReason();
            }
            else if (status == "Open") {
                if ($('#' + id).find("#status").html() != "Open") {
                    $('#opendiv').show();
                    $('#idforopendiv').html(id);
                    $('#<%=txtremarksforopen.ClientID%>').val('');
                }
            }
            else if (status == "BookingDone") {
                if (confirm("Do You Want To Book This Appointment")) {
                    serverCall('SearchAppointment.aspx/BookingDone', { Appid: id }, function (response) {
                        if (response.split("#")[0] == "1") {
                            $('#' + id).css('background-color', '#00FFFF');
                            $('#' + id).find("#ddlstatus").attr("disabled", "disabled");
                            $('#' + id).find("#txtEdit").attr("onclick", "disabled");
                            $('#' + id).find("#tdpro").attr("onclick", "disabled");
                            openpopupss('../../Design/OPD/OpdSettelmentNew.aspx', result.split("#")[1]);
                        }
                        else {
                            alert(response.split("#")[1]);
                            $('#' + id).find("#ddlstatus").removeAttr("disabled");
                        }
                    });
                }
            }
            else if (status == "BookingEdit") {
                if (confirm("Do You Want To Book This Appointment")) {
                    serverCall('SearchAppointment.aspx/Booking_Edit', { Appid: id, PatientID: "", LabNo: "" }, function (response) {
                        if (response == "True") {
                            $('#' + id).css('background-color', '#00FFFF');
                        }
                    });
                }
            }
}

function openpopupss(url, LabNo, RegDate) {
    window.open(url + '?LabNo=' + LabNo, null, 'left=25, top=100, height=520, width=975,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
}
function BindPro() {
    var ddlpro = $('#ddlpro');
    ddlpro.empty();
    serverCall('SearchAppointment.aspx/BindPro', {}, function (response) {
        PatientData = jQuery.parseJSON(response);
        ddlpro.append($("<option></option>").val("Select").html("Select"));
        for (var a = 0; a <= PatientData.length - 1; a++) {
            ddlpro.append($("<option></option>").val(PatientData[a].proid).html(PatientData[a].NAME));
        }
    });
}

function BindTimeSlot() {
    var ddlTimeSot = $('#ddlTimeSlot');
    ddlTimeSot.empty();
    serverCall('SearchAppointment.aspx/GetTimeSlot', {}, function (response) {
        PatientData = jQuery.parseJSON(response);
        ddlTimeSot.append($("<option></option>").val("Select").html("Select"));
        for (var a = 0; a <= PatientData.length - 1; a++) {
            ddlTimeSot.append($("<option></option>").val(PatientData[a].TimeSlot).html(PatientData[a].TimeSlot));

        }
    });
}
function BindTimeSlot2() {
    var ddlTimeSot1 = $('#ddlApptimebooking');
    ddlTimeSot1.empty();
    serverCall('SearchAppointment.aspx/GetTimeSlot', {}, function (response) {
        PatientData = jQuery.parseJSON(response);
        ddlTimeSot1.append($("<option></option>").val("Select").html("Select"));
        for (var a = 0; a <= PatientData.length - 1; a++) {
            ddlTimeSot1.append($("<option></option>").val(PatientData[a].TimeSlot).html(PatientData[a].TimeSlot));
        }
    });
}
function SelectedPRO() {
    var fromdate = $("#<%=txtfromdate.ClientID %>").val();
    var todate = $("#<%=txttodate.ClientID %>").val();
    $('#grd1').empty();
    serverCall('SearchAppointment.aspx/SearchPro', { ProAssign: $("#ddlpro option:selected").text(), ProId: $('#ddlpro option:selected').val(), FromDate: fromdate, ToDate: todate }, function (response) {
        PatientData = jQuery.parseJSON(response);
        if (PatientData.length == 0) {
            toast("Error", 'No Record Found..!', "");
        }
        else {
            $('#grd1').append('<tr id="Header" style="overflow:scroll"><td class="GridViewHeaderStyle" scope="col">Name</td><td class="GridViewHeaderStyle" scope="col">Assign Date</td><td class="GridViewHeaderStyle" scope="col">Assign Time</td><td class="GridViewHeaderStyle" style="display:none" scope="col">AppID</td><td class="GridViewHeaderStyle" scope="col">Remove</td></tr>');
            for (var a = 0; a <= PatientData.length - 1; a++) {
                $('#grd1').append('<tr><td>' + PatientData[a].NAME + '</td><td>' + PatientData[a].Assign_Date + '</td><td>' + PatientData[a].Assign_Time + '</td><td style="display:none">' + PatientData[a].id + '</td><td align="center"><img src="../Purchase/Image/Delete.gif"   onclick="CancelPro(' + PatientData[a].id + ')"/></td></tr>');

            }
        }
    });

}
function CancelPro(Appid) {
    serverCall('SearchAppointment.aspx/UpdatePro', { id: Appid }, function (response) {
        if (response == "True") {
            toast("Success", 'Pro Cancled!', "");
            $('#grd1').empty();
            $('#Pro').hide();
            searchdata('');
        }
    });
}
function savepro() {
    if ($("#ddlpro option:selected").text() == 'Select') {
        toast("Error", 'Please Select Pro', "");
        return false;
    }
    if ($("#<%=txtassigndate.ClientID %>").val() == '') {
        toast("Error", 'Please Select Date', "");
        return false;
    }
    if ($("#ddlTimeSlot").val() == '') {
        toast("Error", 'Please select Pro Assign Time', "");
        return false;
    }
    $('#msgpro').html('');
    var assigndate = $("#<%=txtassigndate.ClientID %>").val();
    serverCall('SearchAppointment.aspx/SavePro', { Appid: $('#appidspan').html(), ProId: $('#ddlpro option:selected').val(), Assign_date: assigndate, TimeSlot: $("#ddlTimeSlot option:selected").text() }, function (response) {
        if (response == "True") {
            $('#Pro').hide();
            searchdata('');
        }
    });
}

function hidediv() {
    $('#Pro').hide();
    $('#showpopdata').hide();
}

function hidecanceldiv() {
    $('#canceldiv').hide();
}

function hideopendiv() {
    $('#opendiv').hide();
}
function cancelapp() {
    if ($("#ddlCancelreason").val() == 'Select') {
        toast("Error", 'Please Select Cancel reason', "");
        return false;
    }
    if ($("#ddlCancelreason option:selected").text() == "Other Reason") {
        if ($("#<%=txtcancelreason.ClientID %>").val() == '') {
            toast("Error", 'Please Enter Cancel reason', "");
            return false;
        }
    }
    $('#msgcancel').html('');
    serverCall('SearchAppointment.aspx/CancelApp', { Appid: $('#idforcancel').html(), Cancelreason: $("#ddlCancelreason option:selected").text(), OtherReason: $("#<%=txtcancelreason.ClientID %>").val() }, function (response) {
        if (response == "True") {
            $('#canceldiv').hide();
            searchdata('');
        }
    });
}
function openIMG(Appid) {
    window.open("MobileImage.aspx?id=" + Appid);
}

function openlog(Appid) {
    $find("<%=poplog.ClientID%>").show();
    $('#ssremarks').html(Appid);
}

function openlogdata(refid) {
    serverCall('SearchAppointment.aspx/BindSingleAppDetail', { RefId: refid }, function (response) {
        try {
            PatientData = jQuery.parseJSON(response);
            $('#spname').html(PatientData[0].NAME);
            $('#pname').html(PatientData[0].NAME);
            $('#pagegen').html(PatientData[0].agegen);
            $('#pmobile').html(PatientData[0].Mobile);
            $('#pemail').html(PatientData[0].Email);
            $('#paddress').html(PatientData[0].Address);
            $('#appdatetime').html(PatientData[0].App_date);
            $('#appbookby').html(PatientData[0].AppBook_ByName);
            $('#asigpro').html(PatientData[0].proname);
            $('#assby').html(PatientData[0].Assign_ByName);
            $('#prodatetime').html(PatientData[0].assign_date);
            $('#appconfirmby').html(PatientData[0].AppConfirm_ByName);

            if (PatientData[0].isCancel == "True") {
                $('#cancel').show();
                $('#cancelreasontr').show();

                $('#canceldatetime').html(PatientData[0].dtCancel);
                $('#cancelby').html(PatientData[0].CancelByName);
                $('#cancelreason').html(PatientData[0].Cancel_Reason);
            }
        }
        catch (e) {
            alert(e.message);
        }
    });
}

function showlength() {
    if ($('#<%=txtmobile.ClientID%>').val().length == 0) {
        $('#mobilenocounter').html('');
    }
    else {
        $('#mobilenocounter').html($('#<%=txtmobile.ClientID%>').val().length);
    }
}
function reopenapp() {
    if ($("#<%=txtremarksforopen.ClientID %>").val() == '') {
        toast("Error", 'Please Enter ReOpen reason', "");
        return false;
    }
    $('#spopen').html('');
    serverCall('SearchAppointment.aspx/ReopenApp', { Appid: $('#idforopendiv').html(), Reopenreason: $("#<%=txtremarksforopen.ClientID %>").val() }, function (response) {
        if (response == "True") {
            // alert("Appointment Confirmed..!");
            $('#opendiv').hide();
            searchdata('');
        }
    });
}
        </script>
        <script type="text/javascript">
            var TestIdList = []; // test ids array
            function ValidateEmail(email) {
                var expr = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
                return expr.test(email);
            };
            function checkvalidation() {
                if ($("#<%=txtname.ClientID %>").val() == '') {
                    toast("Error", 'Please Enter Patient name', "");
                    return false;
                }
                if (($("#<%=txtage.ClientID %>").val() == '' || $("#<%=txtmonth.ClientID %>").val() == '' || $("#<%=txtdays.ClientID %>").val() == '') || ($("#<%=txtage.ClientID %>").val() == '0' && $("#<%=txtmonth.ClientID %>").val() == '0' && $("#<%=txtdays.ClientID %>").val() == '0')) {
                    toast("Error", 'Please fill Age', "");
                    return false;
                }
                if ($("#<%=txtmobile.ClientID %>").val() == '') {
                    toast("Error", 'Please Enter Mobile', "");
                    return false;
                }
                if ($("#<%=txtmobile.ClientID %>").val() != '' && $("#<%=txtmobile.ClientID %>").val().length < 10) {
                    toast("Error", 'Please Enter Mobile 10 Digit Mobile No', "");
                    return false;
                }
                if ($("#<%=txtemail.ClientID %>").val() != '') {
                    if (!ValidateEmail($("#<%=txtemail.ClientID %>").val())) {
                        toast("Error", 'Please Enter Correct Email Id', "");
                        return false;
                    }
                }
                if ($("#<%=txtappdate.ClientID %>").val() == '') {
                    toast("Error", 'Please Select Date', "");
                    return false;
                }
                if ($("#ddlApptimebooking").val() == 'Select') {
                    toast("Error", 'Please Select App Time', "");
                    return false;
                }

                return true;

            }

            function clearform2() {
                clearform();
            }

            function clearform() {
                InvList = [];

                $("#<%=txtpaidamount.ClientID%>").val("");
                $("#<%=txtremarkssave.ClientID%>").val("");
                $("#<%=txtname.ClientID %>").val("");
                $("#<%=txtmobile.ClientID %>").val("");
                $("#<%=txtage.ClientID %>").val("");
                $("#<%=txtmonth.ClientID %>").val("");
                $("#<%=txtdays.ClientID %>").val("");
                $("#<%=txtappdate.ClientID %>").val("");
                $("#ddlApptimebooking").val("Select");
                $("#<%=txtaddress.ClientID %>").val("");
                document.getElementById('<%=ddlage.ClientID %>').selectedIndex = 0;
                $('#<%=rbmail.ClientID%>').attr('checked', true);

                $('#mobilenocounter').html('')
                $('#testcount').html('0');
                var table = document.getElementById('tb_ItemList');
                var rowCount = table.rows.length;
                for (var j = 1; j < rowCount; j++) {
                    table.deleteRow(table.rows.length - 1)
                }
                $("#<%=txtTotal.ClientID %>").val("");
                $("#<%=txtDisAmount.ClientID %>").val("");
                $("#<%=txtDiscReason.ClientID %>").val("");
                //bilal

            }

            //---------------- for dob
            function setdobop(ctrl) {
                if ($(ctrl).is(':checked')) {
                    $('#<%=txtdob.ClientID%>').attr("disabled", false);
                    $('#<%=txtmonth.ClientID%>,#<%=txtage.ClientID%>,#<%=txtdays.ClientID%>').attr("disabled", true);

                }
            }
            function setdobop1(ctrl) {
                if ($(ctrl).is(':checked')) {
                    $('#<%=txtdob.ClientID%>').attr("disabled", true);
                    $('#<%=txtmonth.ClientID%>,#<%=txtage.ClientID%>,#<%=txtdays.ClientID%>').attr("disabled", false);
                }
            }
            function getagefun() {
                var dob = $('#<%=txtdob.ClientID%>').val();
                var today = new Date();
                getAge(dob, today);
            }
            $(function () {
                $('#<%=txtdob.ClientID%>').bind('blur change', function () {
                    getagefun();
                })
                $('#<%=txtdob.ClientID%>').attr("disabled", true);
                var x = Math.floor(Math.pow(10, 12 - 1) + Math.random() * (Math.pow(10, 12) - Math.pow(10, 12 - 1) - 1));
                $('#<%=txtdob.ClientID%>').datepicker({
                    dateFormat: "dd-M-yy",
                    changeMonth: true,
                    maxDate: new Date,
                    changeYear: true, yearRange: "-100:+0",
                    onSelect: function (value, ui) {
                        var today = new Date();
                        var dob = value;
                        getAge(dob, today);
                    }
                });
            });
            function getAge(birthDate, ageAtDate) {
                var daysInMonth = 30.436875; // Days in a month on average.
                // var dob = new Date(birthDate);
                //shat 05.10.17
                var dateSplit = birthDate.split("-");
                var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
                //
                var aad;
                if (!ageAtDate) aad = new Date();
                else aad = new Date(ageAtDate);
                var yearAad = aad.getFullYear();
                var yearDob = dob.getFullYear();
                var years = yearAad - yearDob; // Get age in years.
                dob.setFullYear(yearAad); // Set birthday for this year.
                var aadMillis = aad.getTime();
                var dobMillis = dob.getTime();
                if (aadMillis < dobMillis) {
                    --years;
                    dob.setFullYear(yearAad - 1); // Set to previous year's birthday
                    dobMillis = dob.getTime();
                }
                var days = (aadMillis - dobMillis) / 86400000;
                var monthsDec = days / daysInMonth; // Months with remainder.
                var months = Math.floor(monthsDec); // Remove fraction from month.
                days = Math.floor(daysInMonth * (monthsDec - months));
                $('#<%=txtage.ClientID%>').val(years);
            $('#<%=txtmonth.ClientID%>').val(months);
            $('#<%=txtdays.ClientID%>').val(days);

        }
        // to  calculate patient age
        function getdob() {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtage.ClientID%>').val() != "") {
                if ($('#<%=txtage.ClientID%>').val() > 110) {
                    alert("Please Enter Valid Age in Years");
                    $('#<%=txtage.ClientID%>').val('');
                }
                ageyear = $('#<%=txtage.ClientID%>').val();
            }
            if ($('#<%=txtmonth.ClientID%>').val() != "") {
                if ($('#<%=txtmonth.ClientID%>').val() > 12) {
                    toast("Error", 'Please Enter Valid Age in Months', "");
                    $('#<%=txtmonth.ClientID%>').val('');
                }
                agemonth = $('#<%=txtmonth.ClientID%>').val();

            }
            if ($('#<%=txtdays.ClientID%>').val() != "") {
                if ($('#<%=txtdays.ClientID%>').val() > 30) {
                    toast("Error", 'Please Enter Valid Age in Days', "");
                    $('#<%=txtdays.ClientID%>').val('');
                }
                ageday = $('#<%=txtdays.ClientID%>').val();

            }


            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);


            var m_names = new Array("Jan", "Feb", "Mar",
    "Apr", "May", "Jun", "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec");



            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();


            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            $(<%=txtdob.ClientID%>).val(xxx);


        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }


        //---------------- end for dob -------------
        function savedata() {

            var itemdata = "";
            $('#tb_ItemList tr').each(function () {
                var id = $(this).attr('id');
                if (id != "Header") {
                    itemdata += id.split('_')[1] + ',';
                }
            });

            if (checkvalidation() == false) {
                return false;
            }
            //26 Y 0 M 0 D     

            var Year = $("#<%=txtage.ClientID %>").val() == '' ? '0' : $("#<%=txtage.ClientID %>").val();
            var Month = $('#<%=txtmonth.ClientID%>').val() == '' ? '0' : $('#<%=txtmonth.ClientID%>').val();
            var Days = $('#<%=txtdays.ClientID%>').val() == '' ? '0' : $('#<%=txtdays.ClientID%>').val();

            var age = Year + " Y " + Month + " M " + Days + " D";

            var dob = $('#<%=txtdob.ClientID%>').val();
            var gender = "Male";
            if ($("#<%=rbfemail.ClientID%>").attr("checked")) {
                gender = "Female";
            }

            var appdate = $("#<%=txtappdate.ClientID %>").val();
            var appointmentid = $('#<%=hidAppid.ClientID%>').val();

            serverCall('SearchAppointment.aspx/SaveCalldata', { Title: $('#<%=ddltitle.ClientID%> option:selected').text(), Pname: $("#<%=txtname.ClientID %>").val(), Mobile: $("#<%=txtmobile.ClientID %>").val(), Age: age, Gender: gender, Email: $("#<%=txtemail.ClientID %>").val(), Address: $("#<%=txtaddress.ClientID %>").val(), Appdate: appdate, itemdata: itemdata, TotalAmount: $("#<%=txtTotal.ClientID %>").val(), Discountamount: $("#<%=txtDisAmount.ClientID %>").val(), DiscountReason: $("#<%=txtDiscReason.ClientID %>").val(), PaidAmount: $("#<%=txtpaidamount.ClientID%>").val(), Remarks: $("#<%=txtremarkssave.ClientID%>").val(), dob: dob, Appid: appointmentid, TimeSlot: $("#ddlApptimebooking option:selected").text() }, function (response) {
                if (response == "True") {
                    toast("Success", 'Record Saved Sucessfully..!', "");

                    clearform();
                    $find("<%=modelobs.ClientID%>").hide();
                    searchdata('');
                }
                else {
                    toast("Success", result, "");
                }
            });
        }
        function AutoGender() {
            var ddltxt = $('#<%=ddltitle.ClientID%> option:selected').text();

            if (ddltxt == "Mrs." || ddltxt == "Miss." || ddltxt == "Baby." || ddltxt == "MS." || ddltxt == "Smt.")
                $('#<%=rbfemail.ClientID%>').attr('checked', 'checked');
            else
                $('#<%=rbmail.ClientID%>').attr('checked', 'checked');

        }

        $(function () {
            $('.numbersOnly').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });
        });

        $(function () {
            $('.txtonly').keyup(function () {
                this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
            });
        });

        var InvList = [];
        function AddItem() {
            var NewItem = [];
            var duplicateInv = 0;
            document.getElementById('Button4').disabled = true;
            document.getElementById('<%=txtSearch.ClientID %>').disabled = true;
            document.getElementById('<%=lstInv.ClientID %>').disabled = true;

            var Ctrl = document.getElementById('<%=lstInv.ClientID %>');
            var x = Ctrl.selectedIndex;
            var y = Ctrl.options;
            //alert(Ctrl);
            if (x == -1) {
                toast("Error", 'Please select investigation...', "");
                ddocument.getElementById('Button4').disabled = false;
                document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
                document.getElementById("<%=lstInv.ClientID %>").disabled = false;
                document.getElementById('<%=txtSearch.ClientID %>').focus();
                return false;
            }

            txtCtrl = Ctrl.options[x].text;
            valCtrl = Ctrl.options[x].value;
            //var inv = valCtrl;
            var inv = valCtrl.split('#')[10];
            for (var i = 0; i < (inv.split(',').length) ; i++)
                NewItem.push(inv.split(',')[i]);
            //for (var i = 0; i < (inv.length) ; i++)
            //    NewItem.push(inv);
            $.each(NewItem, function (index, value) {
                if ($.inArray(value, InvList) != -1) {
                    duplicateInv = value;
                    return;
                }
            });
            if (duplicateInv != 0) {
                var tempInv = $("#tb_ItemList").find('td[id*="' + duplicateInv + '"]').closest('tr').find('td:eq(1)').text();

                if (tempInv == txtCtrl)
                    toast("Error", 'Item already in list.', "");

                else
                    alert(txtCtrl + "\n conflicts with \n  " + tempInv);
                document.getElementById('Button4').disabled = false;
                document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
                document.getElementById("<%=lstInv.ClientID %>").disabled = false;
                document.getElementById('<%=txtSearch.ClientID %>').focus();
                return false;
            }
            else {

                $.merge(InvList, NewItem);
                duplicateInv = 0;

                // for package pop up
                var newtestId = valCtrl.split('#')[0];
                TestIdList.push(newtestId);

                SendRequest(valCtrl.split('#')[0]);
                return false;
            }
        }
        function SendRequest(itemid) {
            serverCall('SearchAppointment.aspx/getItemRate', { ItemID: itemid, Panel_id: 79, mrp: "0", doctor: "", DiscPanelID: "", age: "", CardNo: "" }, function (response) {
                arg = response
                if (arg.split('#')[1] != "") {
                    toast("Error", "This Item is not allowed in this Panel", '');
                    var RmvInv = valCtrl.split('#')[10].split(',');
                    var len = RmvInv.length
                    InvList.splice($.inArray(RmvInv[0], InvList), len);
                    document.getElementById('Button2').disabled = false;
                    document.getElementById('<txtSearch.ClientID %>').disabled = false;
                    document.getElementById('<%=lstInv.ClientID %>').disabled = false;

                    return;
                }
                var Rate = arg.split('#')[0];
                if ((Rate == 'undefined') || (isNaN(Rate))) {
                    Rate = "0";
                }

                flGross = Number(flGross) + Number(Rate);

                frRate = Number(frRate) + Number(arg.split('#')[4]);

                var ItemValue = Rate + "|" + valCtrl.split('#')[0] + "|" + txtCtrl.split('#')[0] + "|" +
                  txtCtrl.split('#')[1] + "|" + valCtrlPanel.split('#')[1] + "|" + valCtrl.split('#')[3] + "|1|" +
                  valCtrl.split('#')[1] + "|Date|" + Rate + "|0|" + valCtrl.split('#')[2] + "|" + valCtrl.split('#')[4] + "|" + 0 + "|" + valCtrl.split('#')[5] + "|" + valCtrl.split('#')[7] + "|" + valCtrl.split('#')[8] + "|" + valCtrl.split('#')[9] + "|" + valCtrl.split('#')[10] + "|" + valCtrl.split('#')[11] + "|" + arg.split('#')[2] + "|" + valCtrl.split('#')[13] + "|" + Number(arg.split('#')[4]) + "|" + valCtrl.split('#')[13];

                document.getElementById('<%=txtTotal.ClientID %>').value = flGross;
                document.getElementById('<%=txtpaidamount.ClientID %>').value = flGross;

                addItemNode(ItemValue, 'false');
                bindMultiple();
                var objDiv = document.getElementById("div_item");
                objDiv.scrollTop = objDiv.scrollHeight;
                document.getElementById("Button4").disabled = false;
                document.getElementById("<txtSearch.ClientID %>").disabled = false;
                document.getElementById("<txtSearch.ClientID %>").focus();
                document.getElementById("<%=lstInv.ClientID %>").disabled = false;


            });
            // Lis.getItemRate(itemid, '78', '0', '', OnComplete, OnError, OnTimeOut);
        }
        var returnData = "";
        var flGross = "0";
        var frRate = "0";
        var flDiscount = "";
        var flDisType = "";
        var txtCtrl = "";
        var valCtrl = "";
        var txtCtrlPanel = "";
        var valCtrlPanel = "";
        var SelfSample = "";
        var myAppNumber = "";
        var myAppDate = "";
        var PDispatchData = "";
        var co = 0;
        function OnComplete(arg) {

            if (arg.split('#')[1] != "") {
                toast("Error", 'This Item is not allowed in this Panel', "");
                var RmvInv = valCtrl.split('#')[10].split(',');
                var len = RmvInv.length
                InvList.splice($.inArray(RmvInv[0], InvList), len);
                document.getElementById('Button2').disabled = false;
                document.getElementById('<%=txtSearch.ClientID %>').disabled = false;
                document.getElementById('<%=lstInv.ClientID %>').disabled = false;

                return;
            }
            var Rate = arg.split('#')[0];
            if ((Rate == 'undefined') || (isNaN(Rate))) {
                Rate = "0";
            }

            //alert(valCtrl);
            //LSHHI3502#LSHHI3#LAB#LSHHI3382#R##X#CBC (Complete Blood Count )#0#21-Jan-2015#LSHHI3382#0#B#0
            //arg[4]  -> is for FRate
            flGross = Number(flGross) + Number(Rate);

            frRate = Number(frRate) + Number(arg.split('#')[4]);

            var ItemValue = Rate + "|" + valCtrl.split('#')[0] + "|" + txtCtrl.split('#')[0] + "|" +
              txtCtrl.split('#')[1] + "|" + valCtrlPanel.split('#')[1] + "|" + valCtrl.split('#')[3] + "|1|" +
              valCtrl.split('#')[1] + "|Date|" + Rate + "|0|" + valCtrl.split('#')[2] + "|" + valCtrl.split('#')[4] + "|" + 0 + "|" + valCtrl.split('#')[5] + "|" + valCtrl.split('#')[7] + "|" + valCtrl.split('#')[8] + "|" + valCtrl.split('#')[9] + "|" + valCtrl.split('#')[10] + "|" + valCtrl.split('#')[11] + "|" + arg.split('#')[2] + "|" + valCtrl.split('#')[13] + "|" + Number(arg.split('#')[4]) + "|" + valCtrl.split('#')[13];

            document.getElementById('<%=txtTotal.ClientID %>').value = flGross;
            document.getElementById('<%=txtpaidamount.ClientID %>').value = flGross;

            addItemNode(ItemValue, 'false');
            bindMultiple();
            var objDiv = document.getElementById("div_item");
            objDiv.scrollTop = objDiv.scrollHeight;
            document.getElementById("Button4").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").focus();
            document.getElementById("<%=lstInv.ClientID %>").disabled = false;
        }
        function OnTimeOut(arg) {
            toast("Error", 'timeOut has occured', "");
            document.getElementById('Button3').disabled = false;
            document.getElementById("Button4").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
            document.getElementById("<%=lstInv.ClientID %>").disabled = false;
        }
        function OnError(arg) {
            toast("Error", 'error has occured: ' + arg._message, "");
            document.getElementById('Button3').disabled = false;
            document.getElementById("Button4").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
            document.getElementById("<%=lstInv.ClientID %>").disabled = false;
        }

        function AddNewItemByEdit(arg) {
            var Rate = arg.split('#')[0];
            if ((Rate == 'undefined') || (isNaN(Rate))) {
                Rate = "0";
            }

            //alert(valCtrl);
            //LSHHI3502#LSHHI3#LAB#LSHHI3382#R##X#CBC (Complete Blood Count )#0#21-Jan-2015#LSHHI3382#0#B#0
            //arg[4]  -> is for FRate
            flGross = Number(flGross) + Number(Rate);

            frRate = Number(frRate);

            var ItemValue = Rate + "|" + valCtrl.split('#')[0] + "|" + txtCtrl.split('#')[0] + "|" +
              txtCtrl.split('#')[1] + "|" + valCtrlPanel.split('#')[1] + "|" + valCtrl.split('#')[3] + "|1|" +
              valCtrl.split('#')[1] + "|Date|" + Rate + "|0|" + valCtrl.split('#')[2] + "|" + valCtrl.split('#')[4] + "|" + 0 + "|" + valCtrl.split('#')[5] + "|" + valCtrl.split('#')[7] + "|" + valCtrl.split('#')[8] + "|" + valCtrl.split('#')[9] + "|" + valCtrl.split('#')[10] + "|" + valCtrl.split('#')[11] + "|" + arg.split('#')[2] + "|" + valCtrl.split('#')[13] + "|" + Number(arg.split('#')[4]) + "|" + valCtrl.split('#')[13];

            document.getElementById('<%=txtTotal.ClientID %>').value = flGross;
            document.getElementById('<%=txtpaidamount.ClientID %>').value = flGross;

            addItemNode(ItemValue, 'false');
            bindMultiple();
            var objDiv = document.getElementById("div_item");
            objDiv.scrollTop = objDiv.scrollHeight;
            document.getElementById("Button4").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").disabled = false;
            document.getElementById("<%=txtSearch.ClientID %>").focus();
            document.getElementById("<%=lstInv.ClientID %>").disabled = false;
        }
        function bindMultiple() {

            if (document.getElementById('chkPaymentMode1').checked) {
                if (document.getElementById('chkPaymentMode2').checked == true) {
                    document.getElementById('txt_tr_Amt1').value = 0;
                }
                else if (document.getElementById('chkPaymentMode3').checked == true) {
                    document.getElementById('txt_tr_Amt2').value = 0;
                }
                else {
                    document.getElementById('txt_tr_Amt1').value = flGross;
                }
                document.getElementById('tr_PM_1').style.display = '';
            }
            else {
                document.getElementById('txt_tr_Amt1').value = '';
                document.getElementById('tr_PM_1').style.display = 'none';
            }

            if (document.getElementById('chkPaymentMode2').checked) {


                document.getElementById('txt_tr_Amt2').value = flGross;
                document.getElementById('tr_PM_2').style.display = '';
            }
            else {
                document.getElementById('txt_tr_Amt2').value = '';
                document.getElementById('tr_PM_2').style.display = 'none';
            }

            if (document.getElementById('chkPaymentMode3').checked) {
                if (document.getElementById('chkPaymentMode2').checked == true) {
                    document.getElementById('txt_tr_Amt2').value = 0;
                }
                if (document.getElementById('chkPaymentMode1').checked == true) {
                    document.getElementById('txt_tr_Amt1').value = 0;
                }
                document.getElementById('txt_tr_Amt3').value = flGross;
                document.getElementById('tr_PM_3').style.display = '';
            }
            else {
                document.getElementById('txt_tr_Amt3').value = '';
                document.getElementById('tr_PM_3').style.display = 'none';
            }
            if (document.getElementById('chkPaymentMode4').checked) {
                document.getElementById('chkPaymentMode1').checked = false;
                document.getElementById('chkPaymentMode2').checked = false;
                document.getElementById('chkPaymentMode3').checked = false;

                document.getElementById('txt_tr_Amt1').value = '';
                document.getElementById('tr_PM_1').style.display = 'none';

                document.getElementById('txt_tr_Amt2').value = '';
                document.getElementById('tr_PM_2').style.display = 'none';

                document.getElementById('txt_tr_Amt3').value = '';
                document.getElementById('tr_PM_3').style.display = 'none';
                document.getElementById('txt_tr_Amt4').value = flGross;
                document.getElementById('tr_PM_4').style.display = '';
            }
            else {
                document.getElementById('txt_tr_Amt4').value = '';
                document.getElementById('tr_PM_4').style.display = 'none';
            }
            if ((!document.getElementById('chkPaymentMode1').checked) && (!document.getElementById('chkPaymentMode2').checked) && (!document.getElementById('chkPaymentMode3').checked) && (!document.getElementById('chkPaymentMode4').checked)) {
                document.getElementById('chkPaymentMode1').checked = true;
                document.getElementById('tr_PM_1').style.display = '';
                document.getElementById('txt_tr_Amt1').value = flGross;
            }

            ShowBalAmt();
        }
        function deleteItemNode(xNodeId) {
            InvList.splice($.inArray(xNodeId.parentNode.parentNode.id.replace('tr_LSHHI', ''), InvList), 1);
            co = parseInt(co) - 1;
            $('#testcount').html(co);
            var RmvInv = xNodeId.parentNode.id.split(',');
            var len = RmvInv.length
            var table = document.getElementById('tb_ItemList');
            table.deleteRow(xNodeId.parentNode.parentNode.rowIndex)
            sumTotal(table);
            InvList.splice($.inArray(RmvInv[0], InvList), len);
        }
        function addItemNode(ItemValue, status) {
            // alert(ItemValue);
            // alert(ItemValue.split('|')[23]);
            debugger;
            co = parseInt(co) + 1;
            $('#testcount').html(co);
            var table = document.getElementById('tb_ItemList');
            var rowCount = table.rows.length;
            var row = table.insertRow(rowCount);
            row.className = "GridViewItemStyle";
            row.id = "tr_" + ItemValue.split('|')[1];
            if (ItemValue.split('|')[19] == "1")   //OutSrc Test
                $(row).css('background-color', '#d8bfd8');


            var cell1 = row.insertCell(0);
            cell1.id = ItemValue.split('|')[18];
            cell1.innerHTML = "<a href='javascript:void(0);' onclick='deleteItemNode(this);'><img src='../Purchase/Image/Delete.gif'  style='border:none;'/></a>";

            var cell2 = row.insertCell(1);
            if (ItemValue.split('|')[23] == "1") {
                cell2.innerHTML = "<span style='cursor:pointer;'  onclick='showoutsource(this);'>" + ItemValue.split('|')[2] + "</span>";
            }
            else {
                cell2.innerHTML = "<span style='cursor:pointer;'  onclick='showobs(this);'>" + ItemValue.split('|')[2] + "</span>";
            }

            cell2.id = "inv_" + ItemValue.split('|')[18];
            cell2.style.overflow = "hidden";


            //            cell2.style.whiteSpace="no-wrap";
            var cell3 = row.insertCell(2);
            var element2 = document.createElement("input");
            element2.type = "text";
            element2.style.width = "40px";
            element2.id = "txt_Rate_" + ItemValue.split('|')[1];
            element2.value = ItemValue.split('|')[0];
            //            element2.setAttribute('onkeyup', 'sumTotal(this);');
            //            element2.setAttribute('onkeydown', 'sumTotal(this);');
            //            element2.setAttribute('onblur', 'sumTotal(this);');
            //            
            if ($.browser.msie) {
                element2.attachEvent('onkeyup', sumTotal);
                element2.attachEvent('onkeydown', sumTotal);
            }
            else {
                element2.addEventListener('onkeyup', sumTotal);
                element2.addEventListener('onkeydown', sumTotal);
            }
            //element2.attachEvent('onblur',sumTotal);
            //element4.setAttribute('onfocus', 'alert(this);');
            //element2.attachEvent('onfocus',sumTotal);

            //durga
            element2.className = "txtDisbaledrate";
            if (Number(element2.value) != Number("0"))
                element2.disabled = "true";

            cell3.appendChild(element2);


            var cell4 = row.insertCell(3);
            var element4 = document.createElement("input");
            element4.type = "text";
            element4.style.width = "40px";
            element4.id = "txt_Discount_" + ItemValue.split('|')[1];
            element4.value = "0";
            cell4.appendChild(element4);
            cell4.style.display = 'none';
            var amt = null;
            var itemamt = null;
            if (parseInt(element4.value) != 0) {
                amt = (parseFloat(ItemValue.split('|')[0]) * parseInt(element4.value)) / 100

                itemamt = parseFloat(ItemValue.split('|')[0]) - _amt;
            }

            var cell5 = row.insertCell(4);
            element4 = document.createElement("input");
            element4.type = "text";
            element4.style.width = "40px";
            element4.id = "txt_Amount_" + ItemValue.split('|')[1];
            //element4.value=ItemValue.split('|')[0];

            if (itemamt != null && parseInt(itemamt) != 0) {
                element4.value = itemamt;
            }
            else {
                element4.value = ItemValue.split('|')[0];
            }
            element4.className = "txtDisbaled";
            //element4.disabled="true";

            cell5.appendChild(element4);




            var cell6 = row.insertCell(5);
            cell6.innerHTML = ItemValue;
            cell6.style.display = 'None';
            sumTotal();
        }

        function sumTotal(Ctrl) {

            var table1 = document.getElementById('tb_ItemList');
            var rowCount1 = table1.rows.length;

            var Amt = "";
            var NetAmt = "0";
            for (var j = 1; j < rowCount1; j++) {

                var txtRate = table1.rows[j].cells[2].firstChild.value;
                var txtDiscount = table1.rows[j].cells[3].firstChild.value;

                Amt = Number(txtRate) - Number(txtDiscount);
                NetAmt = Number(NetAmt) + Number(Amt);


            }
            var dis = Number(NetAmt) * 31 / 100;
            var isDicountGiven = "";
            var table = document.getElementById('tb_ItemList');

            var rowCount = table.rows.length;
            flGross = "0"; frRate = "0";
            for (var j = 1; j < rowCount; j++) {
                var Data = table.rows[j].cells[5].innerHTML;
                var txtRate = table.rows[j].cells[2].firstChild.value;
                var txtDiscount = table.rows[j].cells[3].firstChild.value;

                if (Ctrl != null) {
                    if (Number(txtRate) < Number(txtDiscount)) {
                        toast("Error", 'Discount cannot be greater than Rate.', "");
                        table.rows[j].cells[3].firstChild.value = "0";
                        txtDiscount = "0";
                    }
                }
                if (Number(txtDiscount) > 0)
                    isDicountGiven = "yes";

                table.rows[j].cells[4].firstChild.value = Number(txtRate) - Number(txtDiscount);
                var txtAmount = table.rows[j].cells[4].firstChild.value;

                flGross = Number(flGross) + Number(txtAmount);
                //alert(Data.split('|')[22]);
                frRate = Number(frRate) + Number(Data.split('|')[22]);
            }
            flGross1 = Number(flGross);

            if (Number(document.getElementById('<%=txtDisAmount.ClientID %>').value) > 0) {
                flGross = Number(flGross) - Number(document.getElementById('<%=txtDisAmount.ClientID %>').value);
                isDicountGiven = "yes";
                if (Number(document.getElementById('<%=txtDisAmount.ClientID %>').value) > flGross) {
                    document.getElementById('<%=txtDisAmount.ClientID %>').value = '';
                    flGross = Number(flGross1);
                }

            }
            else if (Number(document.getElementById('<%=txtDisAmount.ClientID %>').value) < 0) {
                document.getElementById('<%=txtDisAmount.ClientID %>').value = '';
            }


        document.getElementById('<%=txtTotal.ClientID %>').value = flGross;
            document.getElementById('<%=txtpaidamount.ClientID %>').value = flGross;
            bindMultiple();
            //alert(chkPaymentMode1.checked);

        }
        function ShowBalAmt() {
            //  alert(Number($('#txt_tr_Amt1').val())+Number($('#txt_tr_Amt2').val()))
            var tempNetAmt = $("#<%=txtTotal.ClientID %>").val();
            var tempAmtPaid = Number($('#<%=txtpaidamount.ClientID%>').val());
            $("#lblBalAmt").text((Number(tempNetAmt) - Number(tempAmtPaid)));
        }
        // var keys = [];
        var values = [];
        $(document).ready(function () {
            BindTimeSlot2();
            var options = $('#<% = lstInv.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });
            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 38 || key == 40) {
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index - 1);
                    else if (key == 40)
                        $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index + 1);

                $('#<% = txtSearch.ClientID %>').val($('#<% = lstInv.ClientID %> :selected').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstInv.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                        return;
                    }
                    DoListBoxFilter('#<% = lstInv.ClientID %>', '#<% = txtSearch.ClientID %>', "1", filter, values, key);
                }
            });
            $('#<% = txtSearch.ClientID %>,#<% = lstInv.ClientID %>').keydown(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        toast("Error", 'Kindly Select an Investigation', "");
                        return;
                    }
                    AddItem();
                    $('#<% = txtSearch.ClientID %>').val('');
                    $('#<% = lstInv.ClientID %> option:nth-child(1)').attr('selected', 'selected')

                }
                else if (key == 38 || key == 40) {
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index);
                    else if (key == 40)
                        $('#<% = lstInv.ClientID %> ').attr('selectedIndex', index);

                $('#<% = txtSearch.ClientID %>').val($('#<% = lstInv.ClientID %> :selected').text());
                    $('#<% = txtSearch.ClientID %>').focus();
                }
            });
        });
    function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values, key) {
        var list = $(listBoxSelector);
        var selectBase = '<option value="{0}">{1}</option>';

        if (searchtype == "0") {
            for (i = 0; i < values.length; ++i) {
                var value = '';
                if (values[i].indexOf('~') == -1)
                    continue;
                else
                    value = values[i].split('~')[0].trim();
                var len = $(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    list.attr('selectedIndex', i);
                    return;
                }
            }
        }
        else if (searchtype == "1") {
            for (i = 0; i < values.length; ++i) {
                var value = '';
                if (values[i].indexOf('~') == -1)
                    value = values[i];
                else
                    value = values[i].split('~')[1].trim();
                var len = $(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    list.attr('selectedIndex', i);
                    return;
                }
            }
        }
        else if (searchtype == "2") {
            if (key == 39) {
                var index = list.get(0).selectedIndex;
                for (i = index + 1; i < values.length; ++i) {
                    var value = values[i];
                    if (value.toLowerCase().match(filter.toLowerCase())) {
                        list.attr('selectedIndex', i);
                        return;
                    }
                }
            }
            else {
                for (i = 0; i < values.length; ++i) {
                    var value = values[i];

                    if (value.toLowerCase().match(filter.toLowerCase())) {
                        list.attr('selectedIndex', i);
                        return;
                    }
                }
            }
        }

        $(textbox).focus();
    }
    function BindCancelReason() {
        var ddlcancel = $('#ddlCancelReason');
        ddlcancel.empty();
        serverCall('SearchAppointment.aspx/BindCancelReason', {}, function (response) {
            PatientData = jQuery.parseJSON(response);
            ddlcancel.append($("<option></option>").val("Select").html("Select"));
            for (var a = 0; a <= PatientData.length - 1; a++) {
                ddlcancel.append($("<option></option>").val(PatientData[a].ID).html(PatientData[a].CancelReason));
            }
        });

    }
    function IsOther() {
        $('#<%=txtcancelreason.ClientID%>').val('');
        if ($('#ddlCancelReason option:selected').text() == "Other Reason")
            $("#txtothershow").show();
        else
            $("#txtothershow").hide();
    }




    function getreport() {
        serverCall('SearchAppointment.aspx/SearchdataExcel', { Fromdate: $("#<%=txtfromdate.ClientID %>").val(), Todate: $("#<%=txttodate.ClientID %>").val(), status: status, dateoption: $("#<%=ddldateoption.ClientID %> option:selected").val(), ProAssign: $("#<%=ddlProName.ClientID %> option:selected").text() }, function (response) {

            ItemData = response;
            if (ItemData == null) {
                toast("Error", "No Item Found", "");
            }
            else {
                PostFormData(response, response.ReportPath);
            }

        });
    }

        </script>
</asp:Content>
