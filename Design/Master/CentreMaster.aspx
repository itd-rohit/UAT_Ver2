<%@ Page ClientIDMode="Static" EnableEventValidation="false" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CentreMaster.aspx.cs" Inherits="Design_Master_CentreMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Centre Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Manage Centre
            </div>
            <div class="row">
                <div class="col-md-6">
                    <fieldset style="vertical-align: top">
                        <legend style="font-weight: bold; vertical-align: top">Search Centre</legend>
                        <div class="row">
                            <div class="col-md-24 ">
                                <asp:TextBox ID="txtSearch" runat="server" OnKeyUp="Click(this);" placeholder="Search Centre"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <asp:DropDownList ID="ddlSearchCentreType" runat="server" onchange="getCentreType1()"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <asp:ListBox ID="lstCentre" runat="server" class="navList" onChange="loadDetail(this.value);"
                                    Height="460px"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <input type="button" value="Export To Excel" onclick="getExcelData();" />
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="col-md-18">
                    <fieldset style="vertical-align: top; margin-left: -16px">
                        <legend style="font-weight: bold; text-align: left">
                            <input id="chkNewInv" type="checkbox" checked="checked" />
                            Create New Centre</legend>
                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Centre Type   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlCentreType" runat="server" onchange="getCentreType()">
								<asp:ListItem Text="Processing Lab" Value="LAB"></asp:ListItem>
								<%--<asp:ListItem Text="HUB" Value="HUB"></asp:ListItem>
                                    <asp:ListItem Text="Client" Value="CC"></asp:ListItem>--%>
                                    
                                </asp:DropDownList>
                                <asp:Label ID="lblCentreID" runat="server" Style="display: none;"></asp:Label>
                                <asp:Label ID="lblPanelID" runat="server" Style="display: none;"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:DropDownList ID="ddlType1" runat="server" onchange="selectPatientType(0)">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Patient Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlPanelGroup" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Centre Name  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtCentreName" maxlength="50" class="requiredField" style="text-transform: uppercase" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Centre Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:TextBox ID="txtCentreCode" runat="server" MaxLength="10"></asp:TextBox>
                            </div>
                            <div class="col-md-4 ">
                                <label class="pull-left">UHID Abb. Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <input type="text" id="txtUHIDCode" maxlength="3" class="requiredField" />
                            </div>
                            <div class="col-md-2">
                                (3 Char)
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">
                                    <asp:CheckBox ID="isActive" ForeColor="Red" runat="server" Text="Active" Style="font-weight: 700" Checked="true" CssClass="requiredField" />
                                </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-8">
                                <a id="hrfDownloadUserManual" style="color: blue; text-decoration: underline; cursor: pointer" href="javascript:void(0)" target='_blank' onclick="DownloadUserManual()">Download User Manual</a>
                            </div>
                            <div class="col-md-4 ">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Address Detail
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Address</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtAddress"  />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Country</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlCountry" runat="server"  onchange="$onCountryChange()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Business Zone</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="$onBusinessZoneChange(this.value)" >
                                </asp:DropDownList>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">State</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlState"  onchange="$onStateChange(this.value)"></select>

                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">City</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlCity" runat="server" onchange="$onCityChange(this.value)" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">City Zone</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlZone" runat="server" onchange="$onZoneChange(this.value)" >
                                </asp:DropDownList>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Locality</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlLocality" runat="server" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">LandLine No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtLandline" runat="server" MaxLength="10"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftblandline" runat="server" TargetControlID="txtLandline" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Mobile No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtMobile" runat="server" MaxLength="10"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </div>
                            <br />
                            <br />
                            <div class="col-md-4">
                                <label class="pull-left">Email</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmailAddress" runat="server" AutoCompleteType="Disabled" MaxLength="70"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Contact Person Detail
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtContactPerson" runat="server" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Mobile</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtContactPersonph" runat="server" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbcontactpersonph" runat="server" TargetControlID="txtContactPersonph" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Email</label>
                                <b class="pull-right">:<span style="font-weight: bold; display: none" id="spnWelcomeMail"><a style="color: blue;" href="javascript:void(0)" id="A1" onclick="resendWelcomeMail()">Resend Welcome Mail</a></span></b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtContactPersonemail" runat="server" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Designation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlContactPersonDesignation" runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Owner Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOwnerName" runat="server" AutoCompleteType="Disabled" MaxLength="50" > </asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">PAN Card No</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtPancardno" runat="server" AutoCompleteType="Disabled" MaxLength="10"> </asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4" style="display:none">
                                <label class="pull-left">Sales Manager</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="display:none">
                                <asp:DropDownList ID="ddlSalesManager" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-4" style="display:none">
                                <label class="pull-left">Pro Master</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="display:none">
                                <asp:DropDownList ID="ddlProId" runat="server"></asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">PAN Card Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"><asp:TextBox ID="txtPancardname" runat="server" MaxLength="50" AutoCompleteType="Disabled" > </asp:TextBox>
                            </div>
                        </div>
                        <div style="display:none">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Type
                                </div>
                            </div>
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-24">
                                <asp:RadioButtonList ID="rblCentreSelection" runat="server" onclick="showHide()" RepeatDirection="Horizontal">
                                    <asp:ListItem Text="COCO" Value="COCO" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="FOFO" Value="FOCO"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 clPaymentMode">
                                <label class="pull-left">Payment Mode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 clPaymentMode">
                                <asp:DropDownList ID="ddlPaymentMode" runat="server" onchange="getPaymentCon();chkRollindAdvance()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 RollingAdvance">
                                <label class="pull-left RollingAdvance">Rolling Advance</label>
                                <b class="pull-right RollingAdvance">:</b>
                            </div>
                            <div class="col-md-4 RollingAdvance" style="text-align: left">
                                <asp:CheckBox ID="chkRollingAdvance" runat="server" />
                            </div>
                           
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Email Id(Invoice)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmailInvoice" MaxLength="70" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Email Id(Report)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmailReport" MaxLength="70" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Security AmtComment</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"> <asp:TextBox ID="txtsecurityamtcomment" MaxLength="100" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Min Business Com.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtMinBusinessComm" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbMinBusiness" runat="server" TargetControlID="txtMinBusinessComm" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">GST TIN</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtGSTTIN" runat="server" MaxLength="15"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Billing Cycle</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlInvoiceBillingCycle" runat="server">
                                    <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                    <asp:ListItem Text="15 Days" Value="15 Days"></asp:ListItem>
                                    <asp:ListItem Text="Monthly" Value="Monthly" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Bank Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlBankName" runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Account No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAccountNo" runat="server" MaxLength="18" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">IFSC Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtIFSCCode" runat="server" MaxLength="11" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Invoice To</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlInvoiceTo" runat="server" ToolTip="Select Invoice To" onchange="chkInvoiceTo()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Disp. Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtInvoiceDisplayName" runat="server" MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Disp. No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtInvoiceDisplayNo" runat="server" MaxLength="200" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 Panel">
                                <label class="pull-left">Invoice Dis. Add. </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12 Panel">
                                <asp:TextBox ID="txtInvoiceDisplayAddress" runat="server" MaxLength="200" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Min Cash Booking</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtMinCash" runat="server" Text="0" onkeyup="chkMinCash()" onkeypress="return checkForSecondDecimal(this,event)" />

                                <cc1:FilteredTextBoxExtender ID="ftbMinCash" runat="server" FilterType="Numbers" TargetControlID="txtMinCash" />
                            </div>
                            <div class="col-md-2">
                                (In %)
                            </div>
                        </div>
                        <div class="row PanelCenter">
                            <div class="col-md-4">
                                <label class="pull-left">Tag&nbsp;Processing&nbsp;Lab </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlTagProcessingLab" runat="server" CssClass="requiredField" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Tag&nbsp;Business&nbsp;Unit</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlTagBusinessLab" runat="server" CssClass="requiredField" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 Panel">
                                <label class="pull-left">Security Deposit</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 Panel">
                                <asp:TextBox ID="txtSecurityDeposit" runat="server" MaxLength="8" AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbSecurityDeposit" runat="server" TargetControlID="txtSecurityDeposit" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Intimation Limit </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlCreditLimitIntimation" runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtCreditLimitIntimation" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkIntimationLock()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbCreditLimitIntimation" runat="server" ValidChars="0123456789" TargetControlID="txtCreditLimitIntimation" />

                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Reporting Limit</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlLabreportlimit" runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtLabreportlimit" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkReportingLock()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftCreditLimitReporting" runat="server" ValidChars="0123456789" TargetControlID="txtLabreportlimit" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Booking Limit</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlCreditLimit" runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtCreditLimit" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkBookingLock()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbCreditLimit" runat="server" ValidChars="0123456789" TargetControlID="txtCreditLimit" />

                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="chkIntimation" runat="server" Text="Show Intimation" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="ChkIsPrintingLock" runat="server" Text="IsPrintingLock" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="ChkIsBookingLock" runat="server" Text="IsBookingLock" />
                            </div>
                        </div>
                        <div class="row clExpectedPaymentDate" style="display:none" >
                            <div class="col-md-4">
                                <label class="pull-left">Exp. PaymentDate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <input type="checkbox" id="chkExpectedPaymentDate" onclick="ExpectedPaymentDate()" />
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlExpectedPaymentDate" runat="server" Style="display: none" CssClass="requiredField"></asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>

                            <div class="col-md-4">
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">BarCode Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlBarCodePrintedType" class="requiredField" onchange="$chkBarCodeType()">
                                    <option id="0">Select</option>
                                    <option id="System">System</option>
                                    <option id="PrePrinted">PrePrinted</option>

                                </select>
                            </div>
                            <div class="col-md-4 clBarcodeType" style="display: none">
                                <label class="pull-left">SetOf BarCode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 clBarcodeType" style="display: none">
                                <select id="ddlSetOfBarCode" class="requiredField">
                                    <option id="Option1">Select</option>
                                    <option id="SampleType">SampleType</option>
                                    <option id="Sequence">Sequence</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkSampleCollectionOnReg" runat="server" Text="Sample Collection On Registration" />
                            </div>
                        </div>
                        <div class="row clBarcodeType" style="display: none">
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkBarcodePrintedCentreType" runat="server" Text="Barcode Printed Centre Visit"  style="margin-left:-99px;"  />

                            </div>
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkBarcodePrintedHomeCollectionType" runat="server" Text="Barcode Printed Homecollection Visit" style="margin-left: -89px;"  />

                            </div>
                            <div class="col-md-8">
                            </div>
                        </div>
                        <div class="row" style="display: none" id="trPermanentClose">
                            <div class="col-md-4">
                                <label class="pull-left">Permanent Close</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <asp:CheckBox ID="chkPermanentClose" runat="server" onclick="PermanentClose()"  />
                            </div>
                            <div class="col-md-4 clPermanentClose" style="display: none">
                                <label class="pull-left">Per. Close Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 clPermanentClose" style="display: none">
                                <asp:TextBox ID="txtPermanentCloseDate" runat="server" Width="110px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calPermanentClose" runat="server" TargetControlID="txtPermanentCloseDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4"></div>
                        </div>
                        <div class="row">
                             <div class="col-md-6">
                                <asp:CheckBox ID="chkShowAmtInBooking" runat="server" Text="Hide Amount In Booking" CssClass="hide" style="margin-left: -46px;" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkshowBalanceAmount" runat="server" Text="Show Balance Amount" style="margin-left: 54px;" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkHideReceiptRate" runat="server" Text="Hide Receipt Rate" style="margin-left: 85px;" />
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                 <asp:CheckBox ID="chkSampleRecollectAfterReject" Checked="true" runat="server" Text="Sample ReCollect After Reject"   />
                                 </div>                
                            <div class="col-md-6">
                                  <asp:CheckBox ID="chkAllowDoctorShare" Checked="true" runat="server" Text="Allow Doctor Share" />
                                 <asp:CheckBox ID="chkMrpBill" Checked="true" runat="server" Text="MRPBill" />
                                 </div>
                            <div class="col-md-5">
                                <asp:CheckBox ID="chkcopayment" runat="server" Text="Co-Payment Applicable" onclick="setcoedit()" Enabled="false"  />
                            </div>
                            <div class="col-md-7">
                                <asp:CheckBox ID="chkcopaymentedit" runat="server" Text="Co-Payment Edit on Registation" Enabled="false"  />
                            </div>
                             
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label style="display: none;" class="pull-left">Receipt/TRF/Department Slip</label>
                                <%--<b class="pull-right">:</b>--%>
                            </div>
                            <%-- <div class="col-md-4" style="text-align: left;" >
                                <asp:ListBox  ID="lstReportsOption" width="160px" runat="server" ClientIDMode="Static" CssClass="multiselect" SelectionMode="Multiple"  >
                                <asp:ListItem Value="1" >TRF</asp:ListItem>
                                    <asp:ListItem Value="2">Receipt</asp:ListItem>
                                    <asp:ListItem Value="3">Department Slip</asp:ListItem>    
                                </asp:ListBox>
                            </div>--%>
                            <div class="col-md-2"></div>
                             <div class="col-md-3">
                                <label class="pull-left">Lab RefNo.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2" style="text-align: left">
                                <asp:CheckBox ID="chkOtherLabRefNo" runat="server" />
                            </div>
                            <div class="col-md-4" style="text-align:left">
                                <asp:CheckBox ID="chkIsBatchCreate" runat="server" Text="BatchRequired" />
                            </div>
                            
                        </div>
                        <div class="row InvoiceCreated" style="display: none">
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Created On</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlnvoiceCreatedOn" class="requiredField" style="width:160px" onchange="GetInvoiceType()">
                                    <option value="0">Select</option>
                                    <option value="1">Patient Wise</option>
                                    <option value="2">Monthly Invoice</option>
                                </select>
                            </div>
                            <div class="col-md-4 clsinvoiceHide" style="display: none;margin-left:5px">
                                <select id="ddlInvoiceType" class="requiredField">
                                    <option value="0">Select</option>
                                    <option value="1">Against Invoice</option>
                                    <option value="2">Advance Payment</option>
                                </select>
                            </div>
                        </div>
                         </div>
                        <div style="display:none">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Rate Type
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 MRP">
                                <label class="pull-left">MRP</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 MRP">
                                <asp:DropDownList ID="ddlReferMrp" runat="server" ToolTip="Select Referring Mrp Rate of"></asp:DropDownList>
                            </div>
                            <div class="col-md-4 PatientNetRate">
                                <label class="pull-left">Patient Net Rate</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-4 PatientNetRate">
                                <asp:DropDownList ID="ddlReferringRate" runat="server" ToolTip="Select Referring Rate of">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 ClientRate">
                                <label class="pull-left">Client Rate</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-4 ClientRate">
                                <asp:DropDownList ID="ddlReferShare" runat="server" ToolTip="Select Client Rate"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left">Logistic Expense</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <asp:CheckBox ID="chkLogisticExpense" runat="server" onclick="showLogisticExpense()" />
                            </div>
                            <div class="col-md-4 tdLogisticExpense" style="display: none">
                                <label class="pull-left">Logistic Rate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 tdLogisticExpense" style="display: none">
                                <asp:DropDownList ID="ddlLogisticExpenseRateType" runat="server" ToolTip="Select Logistic Expense Rate Type">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4 tdLogisticExpense" style="display: none">
                                <label class="pull-left">Expense To</label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-4 tdLogisticExpense" style="display: none">
                                <asp:DropDownList ID="ddlLogisticExpenseTo" runat="server" ToolTip="Select Logistic Expense To"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-8">
                                <label class="pull-left">
                                    <asp:CheckBox ID="chkSampleCollectionCharge" onclick="setSampleCollectionCharge()" runat="server" Text="Sample Collection Charge" />
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-4">
                                <asp:TextBox ID="txtSampleCollectionCharge" MaxLength="10" runat="server" Enabled="false"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbCollectionCharge" runat="server" ValidChars="0987654321" TargetControlID="txtSampleCollectionCharge"></cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-8">
                                <label class="pull-left">
                                    <asp:CheckBox ID="chkReportDeliveryCharge" onclick="setReportDeliveryCharge()" runat="server" Text="Report Delivery Charge" />
                                </label>
                                <b class="pull-right">:</b>
                            </div>

                            <div class="col-md-4">
                                <asp:TextBox ID="txtReportDeliveryCharge" runat="server" MaxLength="10" Enabled="false"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbReportDeliveryCharge" runat="server"  ValidChars="0987654321" TargetControlID="txtReportDeliveryCharge"></cc1:FilteredTextBoxExtender>

                            </div>



                        </div>
                        </div>

                        <div class="row"><%--trLoginDetail--%>
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Centre Login Detail
                                </div>
                            </div>
                        </div>
                        <div class="row"><%--trLoginDetails--%>
                            <div class="col-md-4 tdLoginDetail">
                                <label class="pull-left">User Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"><%--tdLoginDetail--%>
                                <asp:TextBox ID="txtClientUserName" runat="server" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4"><%--tdLoginDetail--%>
                                <label class="pull-left">User Password</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"><%--tdLoginDetail--%>
                                <asp:TextBox ID="txtClientUserPassword" TextMode="Password" runat="server" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4"><%--tdLedgerDetail--%>
                                <label class="pull-left"><input type="checkbox" id="chkLedgerReportPassword" style="display: none" checked="checked" />Ledger Password</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4"><%--tdLedgerDetail--%>
                                <asp:TextBox ID="txtLedgerReportPassword" TextMode="Password" runat="server" MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" style="margin-left: -190px; width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveCentre(this);" />
            <input type="button" style="margin-left: -190px; width: 100px; margin-top: 7px; display: none" id="btnUpdate" class="ItDoseButton" value="Update" onclick="$updateCentre(this);" />
            <input type="button" style="width: 100px; margin-top: 7px" value="Cancel" onclick="window.location.reload();" class="resetbutton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div id="centreControl" style="width: 99%; display: none;">
                <input type="button" value="Header" class="itdosebtntab" onclick="openme('AddCentreHeader')" style="font-weight: bold" />
                <input type="button" value="Analytical" class="itdosebtntab" onclick="openme('Analytical')" style="font-weight: bold; display: none" />
                <input type="button" value="TAT" class="itdosebtntab" onclick="openme('AddcentreTAT')" style="font-weight: bold; display: none" />
                <input type="button" value="Centre Access" class="itdosebtntab" onclick="openme('../../Design/Centre/CentreAccess')" style="font-weight: bold" />
                <input type="button" value="Centre Panel" class="itdosebtntab" onclick="openme('Centre_Panel')" style="font-weight: bold" />
                <input type="button" value="Centre Log" class="itdosebtntab" onclick="showFancyBox()" style="font-weight: bold;display: none" />
                <input type="button" value="Welcome Letter" class="itdosebtntab" onclick="WelcomeLetter()" style="font-weight: bold;display: none" />
                <input type="button" value="Email Configuration" class="itdosebtntab" onclick="openme('../Lab/EmailConfiguration')" style="font-weight: bold;display: none" />
                <input type="button" value="Letter Head" class="itdosebtntab" onclick="showFancyBoxLetterhead('ReportBackGound')" style="font-weight: bold;display: none" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstReportsOption]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $bindAllCentre(function (response) {
                selectPatientType(0);
                $onInit();
                jQuery("#btnSave").show();
                jQuery("#txtSearch,#ddlSearchCentreType").attr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#lstCentre").attr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#chkNewInv").click(function () {
                    chkNew();
                    clearform();
                    jQuery("#btnUpdate").hide();
                    jQuery("#centreControl").hide();
                    getLoginDetail();
                });
                jQuery("#chkRollingAdvance").click(function () {
                    if (jQuery("#chkRollingAdvance").is(':checked') && jQuery("#chkNewInv").is(':checked')) {
                        jQuery("#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit").val('0');
                    }
                });
            });
        });
        $onInit = function () {
            jQuery("#txtCentreName")
           .bind("keydown", function (event) {
               if (event.keyCode === jQuery.ui.keyCode.TAB &&
                   jQuery(this).autocomplete("instance").menu.active) {
                   event.preventDefault();
               }
           })
            .autocomplete({
                autoFocus: true,
                open: function (event, ui) {
                    jQuery(this).autocomplete("widget").css({
                        "width": 400
                    });
                },
                source: function (request, response) {
                    jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=GetCentreList", {
                        CentreName: extractLast1(request.term)
                    }, response);
                },
                search: function () {
                    var term = extractLast1(this.value);
                    if (term.length < 2) {
                        return false;
                    }
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {
                    this.value = ui.item.label;
                    return false;
                },
            });
        };
        $bindAllCentre = function (callback) {
            jQuery('#lstCentre option').remove();
            $lstCentre = $('#lstCentre');
            serverCall('CentreMaster.aspx/bindCentre', { CentreType: jQuery("#ddlSearchCentreType").val() }, function (response) {
                centreData = JSON.parse(response);

                if (centreData != null) {
                    for (var i = 0; i < centreData.length; i++) {
                        jQuery('#lstCentre').append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                    }
                }
                callback($lstCentre.val());
            });
        }
    </script>
    <script type="text/javascript">

        jQuery("#txtGSTTIN").on("blur", function () {
            //   debugger;
            if (jQuery('#txtGSTTIN').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtGSTTIN').val())) {
                    toast("Error", 'GST No is INVALID', '');
                    jQuery('#txtGSTTIN').focus();
                    return false;
                }
            }
        });


        jQuery("#txtAccountNo").on("blur", function () {
            //   debugger;
            if (jQuery('#txtAccountNo').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtAccountNo').val())) {
                    toast("Error", 'Account No is INVALID', '');
                    jQuery('#txtAccountNo').focus();
                    return false;
                }
            }
        });


        jQuery("#txtIFSCCode").on("blur", function () {
            //   debugger;
            if (jQuery('#txtIFSCCode').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtIFSCCode').val())) {
                    toast("Error", 'IFSC Code is INVALID', '');
                    jQuery('#txtIFSCCode').focus();
                    return false;
                }
            }
        });


        
        



        function bindPaymentMode() {
            jQuery('#ddlPaymentMode').find('option').remove();
            if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Cash").html("Cash"));
                jQuery('.RollingAdvance').hide();
            }
            else if (jQuery("#ddlType1 option:selected").text() == "CC") {
                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Cash").html("Cash"));
                jQuery('.RollingAdvance').hide();
                $('#ddlnvoiceCreatedOn').val('1');
                $('.InvoiceCreated').hide();
            }
            else if (jQuery("#ddlType1 option:selected").text() == "HLM") {
                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Cash").html("Cash"));
                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Credit").html("Credit"));
                
            }
            else {
                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Credit").html("Credit"));
                jQuery('.RollingAdvance').show();

            }
            chkRollindAdvance();
            getPaymentCon();
            setcopayment();
        }
        function getPaymentCon() {
            if (jQuery("#ddlPaymentMode").val() == "Cash") {
                jQuery("#txtMinCash").removeAttr('disabled');
              
                jQuery('#chkcopayment, label[for="chkcopayment"]').hide();
                jQuery('#chkcopaymentedit, label[for="chkcopaymentedit"]').hide();
                jQuery("#chkExpectedPaymentDate,#chkcopayment,#chkcopaymentedit,#chkShowAmtInBooking").prop('checked', false);
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').hide();
                jQuery('.spnLimit').html('Cash ');
                jQuery('.RollingAdvance,#chkShowAmtInBooking').hide();
                jQuery('.tdExpectedPaymentDate,#ddlExpectedPaymentDate,#chkExpectedPaymentDate,#ddlExpectedPaymentDate,.clExpectedPaymentDate,#chkcopayment,#chkcopaymentedit').hide();
            }
            else {
                jQuery("#txtMinCash").val('0').attr('disabled', 'disabled');
                jQuery('.spnLimit').html('Credit ');
                jQuery('#chkcopayment, label[for="chkcopayment"]').show();
                jQuery('#chkcopaymentedit, label[for="chkcopaymentedit"]').show();
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').show();
                jQuery('.tdExpectedPaymentDate,#chkExpectedPaymentDate,.clExpectedPaymentDate,.RollingAdvance,#chkcopayment,#chkcopaymentedit,#chkShowAmtInBooking').show();
                jQuery('#chkExpectedPaymentDate').prop('checked', false);
                jQuery('#ddlExpectedPaymentDate').hide();
               
                InvoiceCreatedShowHide();
            }

            jQuery("td.tdExpectedPaymentDate").removeClass("required");
        }
        function chkRollindAdvance() {
            if (jQuery('#ddlPaymentMode').val() == "Cash") {
                jQuery('#chkRollingAdvance').prop('checked', false);
                jQuery('#chkRollingAdvance').attr('disabled', 'disabled');
            }
            else {
                jQuery('#chkRollingAdvance').removeAttr('disabled');
            }
        }
        function selectPatientType(con) {
            jQuery("#ddlReferMrp,#ddlReferringRate,#ddlReferShare").prop('selectedIndex', 0);
            if (jQuery("#ddlType1 option:selected").text() == "PUP") {
                jQuery("#ddlPanelGroup").val('3');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").removeAttr('disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).attr('disabled', 'disabled');
            }
            else if (jQuery("#ddlType1 option:selected").text() == "HLM") {
                jQuery("#ddlPanelGroup").val('4');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery('#<%= rblCentreSelection.ClientID %> input[value="FOCO"]').prop('checked', 'checked');
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").removeAttr('disabled');
                showHide();
                jQuery("#chkHideReceiptRate,#chkShowAmtInBooking").prop('checked', false).removeAttr('disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).attr('disabled', 'disabled');
            }
            else if (jQuery("#ddlType1 option:selected").text() == "B2B") {
                jQuery("#ddlPanelGroup").val('9');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery('#<%= rblCentreSelection.ClientID %> input[value="FOCO"]').prop('checked', 'checked');
                jQuery(".ClientRate").hide();
                jQuery(".MRP,.PatientNetRate").show();
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").attr('disabled', 'disabled');
                showHide();
                jQuery("#ddlInvoiceTo").removeAttr('disabled');
                jQuery("#chkShowAmtInBooking,#chkHideReceiptRate,#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).removeAttr('disabled');
            }
            else if (jQuery("#ddlType1 option:selected").text() == "CC") {
                jQuery("#ddlPanelGroup").val('8');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery('#<%= rblCentreSelection.ClientID %> input[value="FOCO"]').prop('checked', 'checked');
                jQuery(".MRP,.PatientNetRate,.ClientRate").show();
                showHide();
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").attr('disabled', 'disabled');
                jQuery("#chkHideReceiptRate,#chkShowAmtInBooking").prop('checked', false).attr('disabled', 'disabled');
                jQuery("#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');
                jQuery("#ddlInvoiceTo").prop('selectedIndex', 0).attr('disabled', 'disabled');
                jQuery("#txtInvoiceDisplayName,#txtInvoiceDisplayNo,#txtInvoiceDisplayAddress,#ddlTagProcessingLab,#ddlTagBusinessLab,#txtSecurityDeposit,#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit,#ddlReferMrp,#ddlReferringRate,#ddlReferShare").removeAttr('disabled');
                jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab").trigger('chosen:updated');
                jQuery("#ddlInvoiceBillingCycle").prop('selectedIndex', 2).removeAttr('disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).attr('disabled', 'disabled');
            }
            else if (jQuery("#ddlType1 option:selected").text() == "FC") {
                jQuery("#ddlPanelGroup").val('10');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery('#<%= rblCentreSelection.ClientID %> input[value="FOCO"]').prop('checked', 'checked');
                jQuery(".ClientRate").hide();
                jQuery(".MRP,.PatientNetRate").show();
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").attr('disabled', 'disabled');
                showHide();
                jQuery("#chkShowAmtInBooking,#chkHideReceiptRate,#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');

                jQuery("#ddlInvoiceTo").removeAttr('disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).removeAttr('disabled');
            }
            else {
                jQuery("#ddlPanelGroup").prop('selectedIndex', 0).attr('disabled', false);
                jQuery("#ddlInvoiceTo").removeAttr('disabled');
                jQuery("#chkShowAmtInBooking,#chkHideReceiptRate,#chkshowBalanceAmount").prop('checked', false).removeAttr('disabled');
                jQuery("#chkIsBatchCreate").prop('checked', true).attr('disabled', 'disabled');
            }
            if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                jQuery("#ddlPanelGroup").val('1');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery("#ddlTagBusinessLab option").remove();
                jQuery("#ddlTagProcessingLab option").remove();
                jQuery("#ddlTagBusinessLab,#ddlTagProcessingLab").trigger('chosen:updated');
                jQuery("#ddlTagBusinessLab").append(jQuery("<option></option>").val("0").html("Self"));
                jQuery("#ddlTagBusinessLab").trigger('chosen:updated');
                jQuery("#ddlTagProcessingLab").append(jQuery("<option></option>").val("0").html("Self"));
                jQuery("#ddlTagProcessingLab").trigger('chosen:updated');
                jQuery(".ClientRate").hide();
                jQuery(".MRP,.PatientNetRate").show();
                jQuery('#<%= rblCentreSelection.ClientID %> input[value="COCO"]').prop('checked', 'checked');
                jQuery("#<%= rblCentreSelection.ClientID %> input:radio").attr('disabled', true);
                showHide();

            }
            else {
                if (con == 0) {
                    jQuery("#ddlTagBusinessLab option").remove();
                    jQuery("#ddlTagBusinessLab").trigger('chosen:updated');
                    jQuery("#ddlTagProcessingLab option").remove();
                    jQuery("#ddlTagProcessingLab").trigger('chosen:updated');
                    serverCall('CentreMaster.aspx/bindTagBusinessLab', {}, function (response) {

                        $ddlTagBusinessLab = $('#ddlTagBusinessLab');
                        $ddlTagProcessingLab = $('#ddlTagProcessingLab');

                        $ddlTagBusinessLab.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true, defaultValue: 'Select' });
                        $ddlTagProcessingLab.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true, defaultValue: 'Select' });

                        $('#ddlTagBusinessLab').addClass("requiredField");
                        $('#ddlTagProcessingLab').addClass("requiredField");
                    });
                }

            }
            SetCenterName();
            bindPaymentMode();
            if (jQuery("#ddlCentreType").val().toUpperCase() == "LAB") {
                jQuery("td.Intimation").removeClass("required");
                jQuery("#chkshowBalanceAmount").attr('disabled', 'disabled').prop('checked', false);
            }
            else {
                jQuery("td.Intimation").addClass("requiredField");
                jQuery("#chkshowBalanceAmount").attr('disabled', 'disabled').prop('checked', true);
            }

            InvoiceCreatedShowHide();

        }
        function SetCenterName() {
            if (jQuery('#chkNewInv').prop("checked") == true && jQuery("#lblEnrollID").text() == "") {
                jQuery('#txtCentreName').val("");
                jQuery('#txtCentreName').val("".concat(jQuery("#ddlType1 option:selected").text(), " "));
            }

        }
function showHide() {
    if (jQuery("#rblCentreSelection input[type=radio]:checked").val() == "COCO") {
        jQuery(".PanelCenter").show();
        jQuery(".Panel").hide();
        jQuery("#txtLedgerReportPassword").attr('disabled', 'disabled');
        jQuery(".ClientRate").hide();
        jQuery(".MRP,.PatientNetRate").show();
    }
    else {
        jQuery(".PanelCenter,.Panel").show();
        jQuery("#txtLedgerReportPassword").removeAttr('disabled');
    }
    jQuery("#ChkIsBookingLock,#ChkIsPrintingLock").prop('checked', false);
    jQuery("#ddlPaymentMode,#ddlTagProcessingLab,#ddlReportDispatchMode,#ddlBankName,#ddlReferringRate,#ddlInvoiceTo,#ddlReferMrp,#ddlReferShare,#ddlTagBusinessLab,#ddlLogisticExpenseRateType,#ddlLogisticExpenseTo").prop('selectedIndex', 0);
    jQuery("#ddlTagBusinessLab,#ddlTagProcessingLab").trigger('chosen:updated');
    jQuery("#txtEmailInvoice,#txtEmailReport,#txtMinBusinessComm,#txtGSTTIN,#txtAccountNo,#txtIFSCCode,#txtOnlineUserName,#txtOnlinePassword,#txtMinCash,#txtCreditLimit,#txtLabreportlimit,#txtCreditLimitIntimation,#txtOwnerName").val('');
    jQuery("#chkShowAmtInBooking").prop('checked', true);
    jQuery("#ddlInvoiceBillingCycle").prop('selectedIndex', 2);
    jQuery("#ChkIsBookingLock,#ChkIsPrintingLock,#chkIntimation").prop('checked', false);
}
function ExpectedPaymentDate() {
    if (jQuery("#chkExpectedPaymentDate").is(':checked') && jQuery("#ddlPaymentMode").val() == "Credit") {
        jQuery("#ddlExpectedPaymentDate").show();
        jQuery("td.tdExpectedPaymentDate").addClass("required");
    }
    else {
        jQuery("#ddlExpectedPaymentDate").hide();
        jQuery("td.tdExpectedPaymentDate").removeClass("required");
    }
}
function showLogisticExpense() {
    if (jQuery("#chkLogisticExpense").is(':checked'))
        jQuery(".tdLogisticExpense").show();
    else
        jQuery(".tdLogisticExpense").hide();
}
function chkBookingLock() {
    if (jQuery.trim(jQuery("#txtCreditLimit").val()) != "")
        jQuery("#ChkIsBookingLock").prop('checked', true);
    else
        jQuery("#ChkIsBookingLock").prop('checked', false);
}
function chkReportingLock() {
    if (jQuery.trim(jQuery("#txtLabreportlimit").val()) != "")
        jQuery("#ChkIsPrintingLock").prop('checked', true);
    else
        jQuery("#ChkIsPrintingLock").prop('checked', false);
}
function chkIntimationLock() {
    if (jQuery.trim(jQuery("#txtCreditLimitIntimation").val()) != "")
        jQuery("#chkIntimation").prop('checked', true);
    else
        jQuery("#chkIntimation").prop('checked', false);
}
function GetInvoiceType() {
    if (jQuery("#ddlnvoiceCreatedOn").val() == "2") {
        $(".clsinvoiceHide").show();
    }
    else {
        $('#ddlInvoiceType').val('0');
        $(".clsinvoiceHide").hide();
    }

}
    </script>
    <script type="text/javascript">
        function resendWelcomeMail() {
            PageMethods.SendCentreWelcomeEmail(jQuery('#lblCentreID').html(), onsucessWelcomeMail, onFailureWelcomeMail);
        }
        function onsucessWelcomeMail(result) {
            if (result == "1")
                alert('Welcome Mail Send Successfully');
            else if (result == "-2")
                alert('Please Enter Email ID');
            else
                alert('Error');
        }
        function onFailureWelcomeMail(result) {

        }

	  function SendCentreWelcomeEmail(CentreId) {

            $.ajax({
                url: "CentreMaster.aspx/SendCentreWelcomeEmail",
                async: true,
                data: JSON.stringify({ CentreId: CentreId }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                }
            });
        }
    </script>
    <script type="text/javascript">
        function DownloadUserManual() {
            if (jQuery("#ddlType1 option:selected").text() == "CC")
                jQuery("#hrfDownloadUserManual").attr("href", "../../UserManual/CC Manual.pdf");
            else if (jQuery("#ddlType1 option:selected").text() == "B2B")
                jQuery("#hrfDownloadUserManual").attr("href", "../../UserManual/B2B Manual.pdf");
            else if (jQuery("#ddlType1 option:selected").text() == "FC")
                jQuery("#hrfDownloadUserManual").attr("href", "../../UserManual/FC Manual.pdf");
            else
                alert('No User Manual Found');
        }
    </script>
    <script type="text/javascript">
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 696,
                maxHeight: 300,
                fitToView: false,
                width: '70%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );
        }
        function showFancyBox() {
            fancyBoxOpen('CentreLog.aspx?centreID=' + jQuery('#lblCentreID').html() + '');
        }
        function showFancyBoxPanel(PageName) {
            serverCall('CentreMaster.aspx/EncryptCentreLog', { ID: $("#lblCentreID").text() }, function (response) {
                var result = jQuery.parseJSON(response);
                fancyBoxOpen("".concat(PageName, '.aspx?centreID=' + result + ''));
            });
            
        }
        function showFancyBoxLetterhead(PageName) {
            serverCall('CentreMaster.aspx/EncryptCentreLog', { ID: $("#lblPanelID").text() }, function (response) {
                var result = jQuery.parseJSON(response);
                fancyBoxOpen("".concat(PageName, '.aspx?panelid=' + result + ''));
            });
        }
        
        function WelcomeLetter() {
            if (jQuery("#ddlCentreType").val().toUpperCase() == "CC")
                PageMethods.EncryptCentreLog(jQuery('#lblCentreID').html(), onSucessWelcomeLetter, onFailureWelcomeLetter);
            else
                alert('No Welcome Letter Found');
        }
        function onSucessWelcomeLetter(result) {
            var result1 = jQuery.parseJSON(result);
            if (result1 != null)
                window.open('CentreWelcomeLetter.aspx?centreID=' + result1[0] + '');
            else
                alert('No Welcome Letter Found');
        }
        function onFailureWelcomeLetter() {

        }
        function chkInvoiceTo() {
            if (jQuery("#chkNewInv").is(':checked')) {
                if (jQuery("#ddlInvoiceTo").val() != "0") {
                    jQuery("#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit,#txtInvoiceDisplayName,#txtInvoiceDisplayNo,#txtInvoiceDisplayAddress,#txtSecurityDeposit").val('').attr('disabled', 'disabled');
                    jQuery("#chkIntimation,#ChkIsPrintingLock,#ChkIsBookingLock").prop('checked', false).attr('disabled', 'disabled');
                    jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab,#ddlReferMrp,#ddlReferringRate,#ddlReferShare,#ddlInvoiceBillingCycle").attr('disabled', 'disabled');
                    jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab").trigger('chosen:updated');
                    getInvoiceToDetail();
                }
                else {
                    jQuery("#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit,#txtInvoiceDisplayName,#txtInvoiceDisplayNo,#txtInvoiceDisplayAddress,#txtSecurityDeposit").removeAttr('disabled');
                    jQuery("#chkIntimation,#ChkIsPrintingLock,#ChkIsBookingLock").removeAttr('disabled');
                    jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab,#ddlReferMrp,#ddlReferringRate,#ddlReferShare").removeAttr('disabled').prop('selectedIndex', 0);
                    jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab").trigger('chosen:updated');
                    jQuery("#ddlInvoiceBillingCycle").prop('selectedIndex', 2);
                }
            }
        }
        function getInvoiceToDetail() {
            PageMethods.getInvoiceToDetail(jQuery('#ddlInvoiceTo').val(), jQuery('#ddlType1 option:selected').text(), onSucessInvoiceToDetail, onFailureInvoiceToDetail);
        }
        function onSucessInvoiceToDetail(result) {
            var result1 = jQuery.parseJSON(result);
            if (result1 != null) {
                jQuery('#ddlTagProcessingLab').val(result1[0].TagProcessingLabID);
                jQuery("#ddlTagProcessingLab").trigger('chosen:updated');
                jQuery('#ddlTagBusinessLab').val(result1[0].TagBusinessLabID);
                jQuery("##ddlTagBusinessLab").trigger('chosen:updated');
                jQuery('#ddlReferMrp').val(result1[0].PanelID_MRP);
                jQuery('#ddlReferringRate').val(result1[0].ReferenceCodeOPD);
                jQuery('#ddlInvoiceBillingCycle').val(result1[0].InvoiceBillingCycle);
                if (jQuery('#ddlType1 option:selected').text() == "CC")
                    jQuery('#ddlReferShare').val(result1[0].PanelShareID);
                else
                    jQuery('#ddlReferShare').val('0');
            }
        }
        function onFailureInvoiceToDetail(result) {

        }
        function extractLast1(term) {
            return split(term).pop();
        }
        function split(val) {
            return val.split(/,\s*/);
        }
        function getCentreType1() {
            $bindAllCentre(function (response) {
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $bindCountry(function (callback) {
                $bindBusinessZone();
            });
        });
        var $bindCountry = function (callback) {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: 0, StateID: 0, CityID: 0, IsStateBind: 0, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0,IsCityBind:1,IsLocality:1 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=Resources.Resource.BaseCurrencyID%>' });
                jQuery('#ddlCountry').val('<%=Resources.Resource.BaseCurrencyID%>').chosen('destroy').chosen();
                callback($ddlCountry.val());
            });

        }
        $bindBusinessZone = function () {
            jQuery("#ddlState,#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            var $ddlBusinessZone = jQuery('#ddlBusinessZone');
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWithCountry', { CountryID: jQuery('#ddlCountry').val() }, function (response) {
                $ddlBusinessZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', isSearchAble: true });
            });
        }
        var $onCountryChange = function () {            
            $('#ddlState,#ddlCity,#ddlZone,#ddlLocality').chosen('destroy');
            $bindBusinessZone();
        }  
        var $onBusinessZoneChange = function (selectedBusinessZoneID) {
            $('#ddlCity,#ddlZone,#ddlLocality').chosen('destroy');
            $bindState(selectedBusinessZoneID, function () { });
        }
        var $bindState = function (BusinessZoneID, callback) {
            var $ddlState = $('#ddlState');
            jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: 14, BusinessZoneID: BusinessZoneID }, function (response) {
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                callback($ddlState.val());
            });
            $("#ddlState .chosen-single").addClass("requiredField");

        }
        var $onStateChange = function (selectedStateID) {
            $('#ddlZone,#ddlLocality').chosen('destroy');
            $bindCity(selectedStateID, function () { });
        }
        var $bindCity = function (StateID, callback) {
            var $ddlCity = $('#ddlCity');
            jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                callback($ddlCity.val());
            });
        }
        var $onCityChange = function (selectedCityID) {
            $('#ddlZone,#ddlLocality').chosen('destroy');
            $bindZone(selectedCityID, function () { });
        }
        var $bindZone = function (CityID, callback) {
            var $ddlZone = $('#ddlZone');
            jQuery("#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindZone', { CityID: CityID }, function (response) {
                $ddlZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ZoneID', textField: 'Zone', isSearchAble: true });
                callback($ddlZone.val());
            });
        }
        var $onZoneChange = function (selectedZoneID) {
            $bindLocality(selectedZoneID, function () { });
        }
        var $bindLocality = function (ZoneID, callback) {
            var $ddlLocality = $('#ddlLocality');
            jQuery("#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByZone', { ZoneID: ZoneID }, function (response) {
                $ddlLocality.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlLocality.val());
            });
        }
    </script>
    <script type="text/javascript">
        function clearform() {
            jQuery('#lblCentreID,#lblPanelID').text('');
            jQuery('#ddlType1').prop('selectedIndex', '0');
            jQuery('#txtCentreName,#txtCentreCode,#txtUHIDCode,#txtAddress,#txtLandline,#txtMobile,#txtContactPerson,#txtContactPersonph,#txtEmailAddress,#txtContactPersonemail,#txtInvoiceDisplayName,#txtInvoiceDisplayNo,#txtLedgerReportPassword,#txtInvoiceDisplayAddress,#txtSecurityDeposit').val('');
            jQuery('#txtEmailInvoice,#txtEmailReport,#txtMinBusinessComm,#txtGSTTIN,#txtAccountNo,#txtIFSCCode,#txtOnlineUserName,#txtOnlinePassword,#txtMinCash,#txtCreditLimit,#txtCreditLimitIntimation,#txtLabreportlimit,#txtClientUserName,#txtClientUserPassword,#txtOwnerName,#txtPancardno,#txtPancardname,#txtsecurityamtcomment').val('');
            jQuery('#ddlBusinessZone,#ddlContactPersonDesignation,#ddlPanelGroup,#ddlPaymentMode,#ddlReportDispatchMode,#ddlSalesHierarchy,#ddlTagBusinessLab,#ddlBarCodePrintedType').prop('selectedIndex', '0');
            jQuery('#ddlBankName,#ddlReferringRate,#ddlInvoiceTo,#ddlReferMrp,#ddlTagProcessingLab,#ddlReferShare,#ddlLogisticExpenseRateType,#ddlLogisticExpenseTo').prop('selectedIndex', '0');
            jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab").trigger('chosen:updated');
            jQuery('#chkIsBookingLock,#chkHideReceiptRate,#ChkIsPrintingLock,#chkshowBalanceAmount,#chkIntimation,#ChkIsBookingLock,#ChkIsPrintingLock,#chkIntimation,#chkLogisticExpense,#chkRollingAdvance').prop('checked', false);
            jQuery("#chkShowAmtInBooking").prop('checked', true);
            jQuery("#ddlInvoiceBillingCycle").prop('selectedIndex', '2');
            jQuery("#chkBarcodePrintedCentreType,#chkBarcodePrintedHomeCollectionType,#chkSampleCollectionOnReg").prop('checked', false);
            jQuery(".tdLogisticExpense,.clBarcodeType").hide();
            jQuery("#ddlState,#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            jQuery("#isActive").prop('checked', 'checked');
            jQuery("#centerUploadAttachment").removeAttr('onclick');
            jQuery("#chkIsBatchCreate,#chkSampleRecollectAfterReject,#chkAllowDoctorShare,#chkMrpBill").prop('checked', true);
        }
        function bindCentreType() {
            jQuery.ajax({
                url: "CentreMaster.aspx/bindCentreType",
                data: '{Category:"' + jQuery("#ddlCentreType").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    jQuery("#ddlType1").find('option').remove();
                    var CentreTypeData = jQuery.parseJSON(result.d);
                    for (i = 0; i < CentreTypeData.length; i++) {
                        jQuery("#ddlType1").append(jQuery("<option></option>").val(CentreTypeData[i].ID).html(CentreTypeData[i].Type1));
                    }
               
                    selectPatientType();
                },
                error: function (xhr, status) {
                }
            });
        }

       

        function loadDetail(val) {
            jQuery('#chkNewInv').prop('checked', false);
            jQuery('#btnSave').hide();
            clearform(); var PanelIDInvoiceTo = "";
           // $modelBlockUI(function () { });
           
            var _temp = [];
            _temp.push(serverCall('CentreMaster.aspx/getCenterData', { CentreID: val }, function (response) {
                CentreData = JSON.parse(response)[0];
                jQuery('#ddlCentreType').val(CentreData.Category);
                getLoginDetail();
            $.when.apply(null, _temp).done(function () {
                _temp = [];
                _temp.push(serverCall('CentreMaster.aspx/bindCentreType', { Category: jQuery("#ddlCentreType").val() }, function (response) {
                    jQuery("#ddlType1").find('option').remove();

                    jQuery("#ddlType1").bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', isSearchAble: false });

                    $.when.apply(null, _temp).done(function () {
                        _temp = [];

                        jQuery('#ddlType1').val(CentreData.type1ID);
                        jQuery('#ddlType1,#ddlCentreType').attr('disabled', 'disabled');
                        jQuery('#txtCentreName').val(CentreData.Centre);
                        jQuery('#txtCentreCode').val(CentreData.CentreCode);
                        jQuery.trim(jQuery("#txtUHIDCode").val(CentreData.UHIDCode));
                        jQuery('#txtAddress').val(CentreData.Address);
                        jQuery('#ddlCountry').val(CentreData.CountryID).chosen('destroy').chosen();                                
                        jQuery('#ddlSalesHierarchy').val(CentreData.Sales_HierarchyID);
                        $bindState(CentreData.BusinessZoneID, function (selectedStateID) {
                            jQuery('#ddlState').val(CentreData.StateID).chosen('destroy').chosen();
                            $bindCity(CentreData.StateID, function (selectedCityID) {
                                jQuery('#ddlCity').val(CentreData.CityID).chosen('destroy').chosen();
                                $bindZone(CentreData.CityID, function (selectedZoneID) {
                                    $('#ddlZone').val(CentreData.zoneID).chosen('destroy').chosen();
                                    $bindLocality(CentreData.zoneID, function (selectedLocalityID) {
                                        $('#ddlLocality').val(CentreData.LocalityID).chosen('destroy').chosen();
                                    });
                                });
                            });
                        });
                        jQuery('#txtLandline').val(CentreData.Landline);
                        jQuery('#txtMobile').val(CentreData.Mobile);
                        jQuery('#txtEmailAddress').val(CentreData.Email);
                        jQuery('#txtContactPerson').val(CentreData.contactperson);
                        jQuery('#txtContactPersonph').val(CentreData.contactpersonmobile);
                        jQuery('#ddlContactPersonDesignation').val(CentreData.contactpersondesignation);
                        jQuery('#txtContactPersonemail').val(CentreData.contactpersonemail);
                        jQuery('#lblCentreID').html(CentreData.centreid);
                        if (CentreData.isActive == "1")
                            jQuery("#isActive").prop('checked', 'checked');
                        else
                            jQuery("#isActive").prop('checked', false);
                        jQuery('#<%= rblCentreSelection.ClientID %> input[value=' + CentreData.SavingType + ']').prop('checked', 'checked');
                    showHide();
                    selectPatientType(2);                  
                    jQuery('#txtOnlineUserName').val(CentreData.OnLineUserName);
                    jQuery('#txtOnlinePassword').val(CentreData.OnlinePassword);
                    jQuery('#ddlReferringRate').val(CentreData.ReferalRate);

                    if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                        jQuery('#ddlTagProcessingLab').val('0').chosen('destroy').chosen();
                    }
                    else {
                        $.when.apply($, _temp).done(function () {
                            _temp = [];
                            _temp.push(serverCall('CentreMaster.aspx/bindTagBusinessLab', { }, function (response) {

                                jQuery("#ddlTagProcessingLab option").remove();

                                $ddlTagProcessingLab = $('#ddlTagProcessingLab');

                                $ddlTagProcessingLab.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });

                                $('#ddlTagProcessingLab').val(CentreData.TagProcessingLabID).chosen('destroy').chosen();
                                $('#ddlTagProcessingLab').addClass("requiredField");
                            },'',false));

                        });

                    }
                    jQuery('#ddlBusinessZone').val(CentreData.BusinessZoneID).chosen('destroy').chosen();
                    $.when.apply($, _temp).done(function () {
                        _temp = [];
                        _temp.push(serverCall('CentreMaster.aspx/getPanelData', { CentreID: val }, function (response) {
                            PanelData = JSON.parse(response)[0];
                            jQuery('#ddlSalesManager').val(PanelData.SalesManager);
                            jQuery("#lblPanelID").text(PanelData.Panel_ID);

                            var SavingType = CentreData.SavingType;
                            jQuery("#ddlPanelGroup").val(PanelData.PanelGroupID);
                            jQuery('#ddlPaymentMode').find('option').remove();
                            if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Cash").html("Cash"));
                                // jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Credit").html("Credit"));
                                jQuery('.RollingAdvance,.trLoginDetail,.tdLoginDetail,.trLoginDetails').hide();
                            }
                            else if (jQuery("#ddlType1 option:selected").text() == "CC") {
                                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Cash").html("Cash"));
                                jQuery('.RollingAdvance,.trLoginDetail,.tdLoginDetail').hide();
                                jQuery('.tdLedgerDetail,.trLoginDetails').show();
                            }
                            else {

                                jQuery('#ddlPaymentMode').append(jQuery("<option></option>").val("Credit").html("Credit"));
                                jQuery('.RollingAdvance,.tdLedgerDetail,.trLoginDetails').show()
                                jQuery('.trLoginDetail,.tdLoginDetail').hide();
                            }

                            jQuery("#ddlPaymentMode").val(PanelData.Payment_Mode);
                            getPaymentCon();
                            if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                                jQuery("#spnWelcomeMail").hide();
                            }
                            else {
                                jQuery("#spnWelcomeMail").show();
                            }
                                jQuery('#lstReportsOption').val(PanelData.ReceiptType.split(','));
                                jQuery('#lstReportsOption').multipleSelect("refresh");
                                jQuery("#txtOwnerName").val(PanelData.OwnerName);
                                jQuery("#ddlBarCodePrintedType").val(PanelData.BarCodePrintedType);
                                if (PanelData.BarCodePrintedType == "PrePrinted") {
                                    jQuery("#ddlSetOfBarCode").val(PanelData.SetOfBarCode);


                                    if (PanelData.BarCodePrintedCentreType == 1)
                                        jQuery("#chkBarcodePrintedCentreType").prop('checked', 'checked');
                                    else
                                        jQuery("#chkBarcodePrintedCentreType").prop('checked', false);

                                    if (PanelData.BarCodePrintedHomeColectionType == 1)
                                        jQuery("#chkBarcodePrintedHomeCollectionType").prop('checked', 'checked');
                                    else
                                        jQuery("#chkBarcodePrintedHomeCollectionType").prop('checked', false);
                                    $(".clBarcodeType").show();
                                }
                                else {
                                    $(".clBarcodeType").hide();
                                }
                                if (PanelData.SampleCollectionOnReg == 1)
                                    jQuery("#chkSampleCollectionOnReg").prop('checked', 'checked');
                                else
                                    jQuery("#chkSampleCollectionOnReg").prop('checked', false);
                                if (PanelData.SampleRecollectAfterReject == 1)
                                    jQuery("#chkSampleRecollectAfterReject").prop('checked', 'checked');
                                else
                                    jQuery("#chkSampleRecollectAfterReject").prop('checked', false);
                                if (PanelData.IsAllowDoctorShare == 1)
                                    jQuery("#chkAllowDoctorShare").prop('checked', 'checked');
                                else
                                    jQuery("#chkAllowDoctorShare").prop('checked', false);
                                if (PanelData.MrpBill == 1)
                                    jQuery("#chkMrpBill").prop('checked', 'checked');
                                else
                                    jQuery("#chkMrpBill").prop('checked', false);

                                
                                jQuery("#ddlReferShare").val(PanelData.PanelShareID);
                                jQuery("#ddlReferMrp").val(PanelData.PanelID_MRP);

                                if (PanelData.IsOtherLabReferenceNo == "1")
                                    jQuery('#chkOtherLabRefNo').prop('checked', true);
                                else
                                    jQuery('#chkOtherLabRefNo').prop('checked', false);
                                InvoiceCreatedShowHide();
                                jQuery("#ddlnvoiceCreatedOn").val(PanelData.InvoiceCreatedOn)
                                jQuery("#ddlInvoiceType").val(PanelData.MonthlyInvoiceType);
                                jQuery('#txtPancardno').val(PanelData.PANNO);
                                jQuery('#txtPancardname').val(PanelData.PANCardName);
                                jQuery('#txtsecurityamtcomment').val(PanelData.SecurityAmtComments);
                            if (SavingType == "FOCO") {
                                
                                jQuery("#txtEmailInvoice").val(PanelData.EmailID);
                                jQuery("#txtEmailReport").val(PanelData.EmailIDReport);
                                jQuery("#ddlReportDispatchMode").val(PanelData.ReportDispatchMode);
                                jQuery("#txtMinBusinessComm").val(PanelData.MinBusinessCommitment);
                                jQuery("#txtGSTTIN").val(PanelData.GSTTin);
                                jQuery("#ddlInvoiceBillingCycle").val(PanelData.InvoiceBillingCycle);
                                jQuery("#ddlBankName").val(PanelData.BankID);
                                jQuery("#txtAccountNo").val(PanelData.AccountNo);
                                jQuery("#txtIFSCCode").val(PanelData.IFSCCode);
                                var CreditLimit = PanelData.CreditLimit;
                                if (CreditLimit == "0") {
                                    jQuery("#txtCreditLimit").val(CreditLimit);
                                    jQuery("#ddlCreditLimit").val("+");
                                }
                                else if (CreditLimit != "") {
                                    var sign = CreditLimit > 0 ? 1 : CreditLimit == 0 ? 0 : -1;
                                    jQuery("#txtCreditLimit").val(CreditLimit);
                                    if (sign == "-1") {
                                        jQuery("#ddlCreditLimit").val("-");
                                    }
                                    else {
                                        jQuery("#ddlCreditLimit").val("+");
                                    }
                                }
                                else {
                                    jQuery("#txtCreditLimit").val('');
                                }
                              //  jQuery("#ddlTagBusinessLab").val(PanelData.TagBusinessLabID).chosen('destroy').chosen();
                                var LabReportLimit = PanelData.LabReportLimit;
                                if (LabReportLimit == "0") {
                                    jQuery("#txtLabreportlimit").val(LabReportLimit);
                                    jQuery("#ddlLabreportlimit").val("+");
                                }
                                else if (LabReportLimit != "") {
                                    var sign = LabReportLimit > 0 ? 1 : LabReportLimit == 0 ? 0 : -1;
                                    jQuery("#txtLabreportlimit").val(LabReportLimit);
                                    if (sign == "-1")
                                        jQuery("#ddlLabreportlimit").val("-");
                                    else
                                        jQuery("#ddlLabreportlimit").val("+");
                                }
                                else {
                                    jQuery("#txtLabreportlimit").val('');
                                }
                                var IntimationLimit = PanelData.IntimationLimit;
                                if (IntimationLimit == "0") {
                                    jQuery("#txtCreditLimitIntimation").val(IntimationLimit);
                                    jQuery("#ddlCreditLimitIntimation").val("+");
                                }
                                else if (IntimationLimit != "") {
                                    var sign = IntimationLimit > 0 ? 1 : IntimationLimit == 0 ? 0 : -1;
                                    jQuery("#txtCreditLimitIntimation").val(IntimationLimit);
                                    if (sign == "-1")
                                        jQuery("#ddlCreditLimitIntimation").val("-");
                                    else
                                        jQuery("#ddlCreditLimitIntimation").val("+");

                                }
                                else {
                                    jQuery("#txtCreditLimitIntimation").val('');
                                }
                                if (PanelData.IsShowIntimation == "1")
                                    jQuery("#chkIntimation").prop('checked', 'checked');
                                else
                                    jQuery("#chkIntimation").prop('checked', false);

                                if (PanelData.IsBookingLock == "1")
                                    jQuery("#ChkIsBookingLock").prop('checked', 'checked');
                                else
                                    jQuery("#ChkIsBookingLock").prop('checked', false);
                                if (PanelData.IsPrintingLock == "1")
                                    jQuery("#ChkIsPrintingLock").prop('checked', 'checked');
                                else
                                    jQuery("#ChkIsPrintingLock").prop('checked', false);

                                jQuery("#txtMinCash").val(PanelData.MinBalReceive);
                                jQuery("#txtInvoiceDisplayName").val(PanelData.InvoiceDisplayName);
                                jQuery("#txtInvoiceDisplayNo").val(PanelData.InvoiceDisplayNo);
                                jQuery("#txtLedgerReportPassword").val(PanelData.LedgerReportPassword);
                                jQuery("#txtInvoiceDisplayAddress").val(PanelData.InvoiceDisplayAddress);
                                if (PanelData.showBalanceAmt == "1")
                                    jQuery("#chkshowBalanceAmount").prop('checked', 'checked');
                                else
                                    jQuery("#chkshowBalanceAmount").prop('checked', false);
                                
                                jQuery('#ddlReferringRate').val(PanelData.ReferenceCodeOPD);
                                jQuery("#txtMinCash").val(PanelData.MinBalReceive);
                               
                                if (PanelData.HideReceiptRate == "1")
                                    jQuery("#chkHideReceiptRate").prop('checked', 'checked');
                                else
                                    jQuery("#chkHideReceiptRate").prop('checked', false);
                                if (PanelData.IsPermanentClose == "1") {
                                    jQuery('#chkPermanentClose').prop('checked', 'checked');
                                    jQuery('#txtPermanentCloseDate').val(PanelData.PermanentCloseDate);
                                    jQuery(".clPermanentClose").show();
                                }
                                else {
                                    jQuery('#chkPermanentClose').prop('checked', false);
                                    jQuery('#txtPermanentCloseDate').val('');
                                    jQuery(".clPermanentClose").hide();
                                }
                                if (PanelData.IsDuplicatePanNo == "1") {
                                    jQuery("#txtInvoiceDisplayName").attr('disabled', 'disabled');
                                }
                                else {
                                    jQuery("#txtInvoiceDisplayName").removeAttr('disabled');
                                }
                                if (PanelData.IsLogisticExpense == "1") {
                                    jQuery("#chkLogisticExpense").prop('checked', 'checked');
                                    jQuery(".tdLogisticExpense").show();
                                }
                                else {
                                    jQuery("#chkLogisticExpense").prop('checked', false);
                                    jQuery(".tdLogisticExpense").hide();
                                }
                                jQuery("#ddlLogisticExpenseRateType").val(PanelData.LogisticExpenseRateType);
                                jQuery("#ddlLogisticExpenseTo").val(PanelData.LogisticExpenseToPanelID);
                                jQuery("#txtSecurityDeposit").val(PanelData.SecurityDeposit);
                                if (PanelData.Payment_Mode == "Cash") {
                                    jQuery('#chkRollingAdvance').prop('checked', false);
                                    jQuery('#chkRollingAdvance').attr('disabled', 'disabled');
                                }
                                else {
                                    jQuery('#chkRollingAdvance').removeAttr('disabled');
                                    if (PanelData.RollingAdvance == "1")
                                        jQuery('#chkRollingAdvance').prop('checked', true);
                                    else
                                        jQuery('#chkRollingAdvance').prop('checked', false);

                                }
                                jQuery("#txtOwnerName").val(PanelData.OwnerName);

                                if (PanelData.HideRate == "1")
                                    jQuery("#chkShowAmtInBooking").prop('checked', 'checked');
                                else
                                    jQuery("#chkShowAmtInBooking").prop('checked', false);

                                
                                if (jQuery("#ddlPaymentMode").val() == "Credit" && PanelData.chkExpectedPayment == "1") {
                                    jQuery("#chkExpectedPaymentDate").prop('checked', 'checked');
                                    jQuery("#ddlExpectedPaymentDate").show();
                                    jQuery("#ddlExpectedPaymentDate").val(PanelData.ExpectedPaymentDate);

                                }
                                else {
                                    jQuery("#chkExpectedPaymentDate").prop('checked', false);
                                    jQuery("#ddlExpectedPaymentDate").hide();

                                }
                                
                                if (jQuery("#ddlType1 option:selected").text() == "FC" || jQuery("#ddlType1 option:selected").text() == "B2B") {
                                    jQuery("#chkIsBatchCreate").removeAttr('disabled');

                                    if (PanelData.IsBatchCreate == "1") {
                                        jQuery("#chkIsBatchCreate").prop('checked', 'checked')
                                    }
                                    else {
                                        jQuery("#chkIsBatchCreate").prop('checked', false)
                                    }
                                }
                                else {
                                    jQuery("#chkIsBatchCreate").prop('checked', 'checked').attr('disabled', 'disabled');
                                }
                                if (PanelData.ShowCollectionCharge == "1") {
                                    jQuery('#chkSampleCollectionCharge').prop('checked', true);
                                    jQuery('#txtSampleCollectionCharge').val(PanelData.CollectionCharge).attr("disabled", false);
                                }
                                else {
                                    jQuery('#chkSampleCollectionCharge').prop('checked', false);
                                    jQuery('#txtReportDeliveryCharge').val('').attr("disabled", true);

                                }
                                if (PanelData.ShowDeliveryCharge == "1") {
                                    jQuery('#chkReportDeliveryCharge').prop('checked', true);
                                    jQuery('#txtReportDeliveryCharge').val(PanelData.ShowDeliveryCharge).attr("disabled", false);
                                }
                                else {
                                    jQuery('#chkReportDeliveryCharge').prop('checked', false);
                                    jQuery('#txtSampleCollectionCharge').val('').attr("disabled", true);

                                }
                                if (PanelData.CoPaymentApplicable == "1") {
                                    jQuery('#chkcopayment').prop('checked', true);
                                    if (PanelData.CoPaymentEditonBooking == "1") {
                                        jQuery('#chkcopaymentedit').prop('checked', true).attr("disabled", false);
                                    }
                                    else {
                                        jQuery('#chkcopaymentedit').prop('checked', false).attr("disabled", false);
                                    }
                                }
                                else {
                                    jQuery('#chkcopayment').prop('checked', false);
                                    jQuery('#chkcopaymentedit').prop('checked', false).attr("disabled", true);

                                }
                              
                                
                                
                                GetInvoiceType();
                                PanelIDInvoiceTo = PanelData.InvoiceTo;
                                $.when.apply($, _temp).done(function () {
                                    _temp = [];
                                    _temp.push(serverCall('CentreMaster.aspx/getCentreType', { InvoiceTo: PanelIDInvoiceTo }, function (response) {
                                        InvoiceTypeData = response;
                                        var InvoiceTo = "".concat(jQuery("#lblPanelID").text(), "#", InvoiceTypeData);
                                        jQuery("#ddlInvoiceTo").val(InvoiceTo);
                                    }, { isReturn: true }, false));
                                    $modelUnBlockUI(function () { });
                                });

                            }
                            if (jQuery("#ddlType1").val().toUpperCase().split('#')[1] == "LAB") {
                            }
                            else {
                                $.when.apply($, _temp).done(function () {
                                    _temp = [];
                                    _temp.push(serverCall('CentreMaster.aspx/bindTagBusinessLab', {}, function (response) {
                                        jQuery("#ddlTagBusinessLab option").remove();

                                        $ddlTagBusinessLab = $('#ddlTagBusinessLab');

                                        $ddlTagBusinessLab.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });

                                        $('#ddlTagBusinessLab').val(PanelData.TagBusinessLabID).chosen('destroy').chosen();
                                        $('#ddlTagBusinessLab').addClass("requiredField");

                                    }, '', false));
                                });

                            }
                        }, { isReturn: true }, false));
                    });
                    });

                }, { isReturn: true },false));

                
                
                $modelUnBlockUI(function () { });
                jQuery("#btnUpdate,#centreControl,#trPermanentClose").show();
            });
            
            }, { isReturn: true }));
        }
    </script>
    <script type="text/javascript">

        function PermanentClose() {
            if (jQuery("#chkPermanentClose").is(':checked')) {
                PageMethods.GetBalanceAmt(jQuery("#ddlType1 option:selected").text(), jQuery('#lblCentreID').html(), onsucessPermanentClose, onFailurePermanentClose);
            }
        }
        function onFailurePermanentClose(result) {

        }
        function onsucessPermanentClose(result) {
            if (result == 0) {
                if (jQuery("#chkPermanentClose").is(':checked')) {
                    jQuery(".clPermanentClose").show();
                }
                else {
                    jQuery("#txtPermanentCloseDate").val('');
                    jQuery(".clPermanentClose").hide();
                }
            }
            else {
                alert('Please Settle Client Balance Amount ');
                jQuery("#chkPermanentClose").prop('checked', false);
                jQuery("#txtPermanentCloseDate").val('');
                jQuery(".clPermanentClose").hide();
                return;
            }
        }
    </script>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function chkMinCash() {
            if (jQuery.trim(jQuery("#txtMinCash").val()) != "") {
                if (jQuery("#txtMinCash").val() > 100) {
                    alert('Please Enter Valid Percentage');
                    jQuery("#txtMinCash").val('0');
                    return;
                }
            }
        }



        jQuery("#txtEmailAddress").on("blur", function () {
            debugger;
            if (jQuery('#txtEmailAddress').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmailAddress').val())) {
                    toast("Error", 'Incorrect Email Address', '');
                    jQuery('#txtEmailAddress').focus();
                    return false;
                }
            }
        });



        jQuery("#txtContactPersonemail").on("blur", function () {
            debugger;
            if (jQuery('#txtContactPersonemail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtContactPersonemail').val())) {
                    toast("Error", 'Incorrect Personal Email ID', '');
                    jQuery('#txtContactPersonemail').focus();
                    return false;
                }
            }
        });

        jQuery("#txtEmailInvoice").on("blur", function () {
            debugger;
            if (jQuery('#txtEmailInvoice').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmailInvoice').val())) {
                    toast("Error", 'Incorrect Invoicing Email ID', '');
                    jQuery('#txtEmailInvoice').focus();
                    return false;
                }
            }
        });

        jQuery("#txtEmailReport").on("blur", function () {
            debugger;
            if (jQuery('#txtEmailReport').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmailReport').val())) {
                    toast("Error", 'Incorrect Report Email ID', '');
                    jQuery('#txtEmailReport').focus();
                    return false;
                }
            }
        });
        
        

        




    </script>
    <script type="text/javascript">
        function centreMaster() {
            var dataCentre = new Array();
            var objCentre = new Object();
            if (jQuery('#lblCentreID').html() != "")
                objCentre.CentreID = jQuery('#lblCentreID').html();
            else
                objCentre.CentreID = 0;
            objCentre.type1ID = jQuery('#ddlType1').val().split('#')[0];
            objCentre.type1 = jQuery('#ddlType1 option:selected').text();
            objCentre.Centre = jQuery.trim(jQuery("#txtCentreName").val());
            objCentre.CentreCode = jQuery.trim(jQuery("#txtCentreCode").val());
            objCentre.UHIDCode = jQuery.trim(jQuery("#txtUHIDCode").val());
            objCentre.isActive = jQuery("#isActive").is(':checked') ? 1 : 0;
            objCentre.Address = jQuery.trim(jQuery("#txtAddress").val());
            objCentre.Locality = jQuery.trim(jQuery("#ddlLocality option:selected").text());
            objCentre.City = jQuery.trim(jQuery("#ddlCity option:selected").text());
            objCentre.BusinessZoneName = jQuery.trim(jQuery("#ddlBusinessZone option:selected").text());
            objCentre.State = jQuery.trim(jQuery("#ddlState option:selected").text());
            objCentre.Landline = jQuery.trim(jQuery("#txtLandline").val());
            objCentre.Mobile = jQuery.trim(jQuery("#txtMobile").val());
            objCentre.Email = jQuery("#txtEmailAddress").val();
            objCentre.contactperson = jQuery("#txtContactPerson").val();
            objCentre.contactpersonmobile = jQuery.trim(jQuery("#txtContactPersonph").val());
            objCentre.contactpersonemail = jQuery.trim(jQuery("#txtContactPersonemail").val());
            objCentre.contactpersondesignation = jQuery.trim(jQuery("#ddlContactPersonDesignation").val());
            objCentre.zone = jQuery("#ddlZone option:selected").text();
            objCentre.ZoneID = jQuery("#ddlZone").val()==null ?"0": jQuery("#ddlZone").val();
            objCentre.TagProcessingLabID = jQuery("#ddlTagProcessingLab").val();
            if (jQuery("#ddlTagProcessingLab option:selected").text() == "Self")
                objCentre.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
              else if (jQuery("#ddlTagProcessingLab").val() != "0")
                  objCentre.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else
                objCentre.TagProcessingLab = "";
            objCentre.ReferalRate = jQuery("#ddlReferringRate").val();
            objCentre.SavingType = jQuery("#rblCentreSelection input[type=radio]:checked").val();
            objCentre.BusinessZoneID = jQuery.trim(jQuery("#ddlBusinessZone").val());
            objCentre.StateID = (jQuery.trim(jQuery("#ddlState").val()) == null || jQuery.trim(jQuery("#ddlState").val()) == "") ? "0" : jQuery.trim(jQuery("#ddlState").val());
            objCentre.CityID = (jQuery.trim(jQuery("#ddlCity").val()) == "" || jQuery.trim(jQuery("#ddlCity").val()) == null) ? "0" : jQuery.trim(jQuery("#ddlCity").val());
            objCentre.LocalityID = (jQuery.trim(jQuery("#ddlLocality").val()) == "" || jQuery.trim(jQuery("#ddlLocality").val()) == null) ? "0" : jQuery.trim(jQuery("#ddlLocality").val());
            objCentre.Category = jQuery('#ddlType1').val().split('#')[1];
            if (jQuery.trim(jQuery("#txtClientUserName").val()) != "")
                objCentre.UserName = jQuery.trim(jQuery("#txtClientUserName").val());
            else
                objCentre.UserName = "";
            if (jQuery.trim(jQuery("#txtClientUserName").val()) != "")
                objCentre.UserPassword = jQuery.trim(jQuery("#txtClientUserPassword").val());
            else
                objCentre.UserPassword = "";
            objCentre.CountryID = jQuery("#ddlCountry").val();
            objCentre.CountryName = jQuery("#ddlCountry option:selected").text();
            dataCentre.push(objCentre);
            return dataCentre;
        }
        function panelMaster() {
            var dataPanel = new Array();
            var objPanel = new Object();
            objPanel.PanelGroup = jQuery("#ddlPanelGroup option:selected").text();
            objPanel.PanelGroupID = jQuery("#ddlPanelGroup").val();
            objPanel.Payment_Mode = jQuery.trim(jQuery("#ddlPaymentMode").val());
            objPanel.TagProcessingLabID = jQuery("#ddlTagProcessingLab").val();
            if (jQuery("#ddlTagProcessingLab option:selected").text() == "Self")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else if (jQuery("#ddlTagProcessingLab").val() != "0")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else
                objPanel.TagProcessingLab = "";
            objPanel.EmailID = jQuery.trim(jQuery("#txtEmailInvoice").val());
            objPanel.EmailIDReport = jQuery("#txtEmailReport").val();
            if (jQuery("#txtMinBusinessComm").val() != "")
                objPanel.MinBusinessCommitment = jQuery("#txtMinBusinessComm").val();
            else
                objPanel.MinBusinessCommitment = 0;
            objPanel.GSTTin = jQuery("#txtGSTTIN").val();
            objPanel.InvoiceBillingCycle = jQuery("#ddlInvoiceBillingCycle").val();
              if (jQuery("#ddlBankName").val() != "0") {
                  objPanel.BankName = jQuery("#ddlBankName option:selected").text();
                  objPanel.BankID = jQuery("#ddlBankName").val();
            }
            else {
                objPanel.BankName = "";
                objPanel.BankID = 0;
            }
            objPanel.AccountNo = jQuery.trim(jQuery("#txtAccountNo").val());
            objPanel.IFSCCode = jQuery.trim(jQuery("#txtIFSCCode").val());
            objPanel.ReferenceCode = jQuery("#ddlReferringRate").val();
            objPanel.ReferenceCodeOPD = jQuery("#ddlReferringRate").val();
            objPanel.InvoiceTo = jQuery("#ddlInvoiceTo").val().split('#')[0];
              if (jQuery("#txtMinCash").val() != "")
                  objPanel.MinBalReceive = jQuery("#txtMinCash").val();
            else
                objPanel.MinBalReceive = 0;

            if (jQuery.trim(jQuery("#txtCreditLimit").val()) == "")
                  objPanel.CreditLimit = 0;
              else
                  objPanel.CreditLimit = "".concat(jQuery("#ddlCreditLimit").val(), jQuery.trim(jQuery("#txtCreditLimit").val()));
            objPanel.ShowAmtInBooking = jQuery("#chkShowAmtInBooking").is(':checked') ? 1 : 0;
            objPanel.HideRate = jQuery("#chkShowAmtInBooking").is(':checked') ? 1 : 0;
            objPanel.IsBookingLock = jQuery("#ChkIsBookingLock").is(':checked') ? 1 : 0;
            objPanel.IsPrintingLock = jQuery("#ChkIsPrintingLock").is(':checked') ? 1 : 0;
            objPanel.SavingType = jQuery("#rblCentreSelection input[type=radio]:checked").val();
            objPanel.showBalanceAmt = jQuery("#chkshowBalanceAmount").is(':checked') ? 1 : 0;
            if (jQuery.trim(jQuery("#txtSecurityDeposit").val()) == "")
                objPanel.SecurityDeposit = 0;
            else
                objPanel.SecurityDeposit = jQuery.trim(jQuery("#txtSecurityDeposit").val());
            if (jQuery.trim(jQuery("#lblPanelID").text()) != "")
                objPanel.Panel_ID = jQuery.trim(jQuery("#lblPanelID").text());
            else
                objPanel.Panel_ID = 0;

            objPanel.HideReceiptRate = jQuery("#chkHideReceiptRate").is(':checked') ? 1 : 0;
            if (jQuery("#rblCentreSelection input[type=radio]:checked").val() == "FOCO") {
                objPanel.IsInvoice = 1;
                objPanel.InvoiceDisplayName = jQuery.trim(jQuery("#txtInvoiceDisplayName").val());
                objPanel.InvoiceDisplayNo = jQuery.trim(jQuery("#txtInvoiceDisplayNo").val());
                objPanel.InvoiceDisplayAddress = jQuery.trim(jQuery("#txtInvoiceDisplayAddress").val());
            }
            else {
                objPanel.IsInvoice = 0;
                objPanel.InvoiceDisplayName = "";
                objPanel.InvoiceDisplayNo = "";
                objPanel.LedgerReportPassword = "";
                objPanel.InvoiceDisplayAddress = "";
            }
            objPanel.LedgerReportPassword = jQuery.trim(jQuery("#txtLedgerReportPassword").val());
            objPanel.chkLedgerReportPassword = jQuery("#chkLedgerReportPassword").is(':checked') ? 1 : 0;
            if (jQuery("#ddlType1 option:selected").text() == "HLM") {
                objPanel.PatientPayTo = jQuery('#rblHLMOPPatientPayTo input[type=radio]:checked').val();
            }
            else {
                if (jQuery.trim(jQuery("#ddlPaymentMode").val()) == "Credit")
                    objPanel.PatientPayTo = "Client";
                else
                    objPanel.PatientPayTo = jQuery('#rblPatientPayTo input[type=radio]:checked').val();
            }
            if (jQuery.trim(jQuery("#txtMRPPercentage").val()) == "")
                objPanel.DiscPercent = 0;
            else
                objPanel.DiscPercent = jQuery.trim(jQuery("#txtMRPPercentage").val());
            objPanel.EnrollID = jQuery("#lblEnrollID").text();
            if (jQuery('#chkPermanentClose').is(':visible') && jQuery('#chkPermanentClose').is(':checked')) {
                objPanel.IsPermanentClose = 1;
                objPanel.PermanentCloseDate = jQuery('#txtPermanentCloseDate').val();
            }
            else {
                objPanel.IsPermanentClose = 0;
                objPanel.PermanentCloseDate = "";
            }
            objPanel.SalesManager = 0;
            if (jQuery("#ddlType1 option:selected").text() == "CC")
                objPanel.ReferringShareID = jQuery("#ddlReferShare").val();
            else if (jQuery("#ddlType1 option:selected").text() == "B2B" || jQuery("#ddlType1 option:selected").text() == "FC") 
                objPanel.ReferringShareID = 0;
            objPanel.ReferringMrpID = jQuery("#ddlReferMrp").val();
              if (jQuery.trim(jQuery("#txtLabreportlimit").val()) == "")
                  objPanel.LabReportLimit = 0
              else
                  objPanel.LabReportLimit = "".concat(jQuery("#ddlLabreportlimit").val(), jQuery.trim(jQuery("#txtLabreportlimit").val()));

            if (jQuery.trim(jQuery("#txtCreditLimitIntimation").val()) == "")
                  objPanel.IntimationLimit = 0
              else
                  objPanel.IntimationLimit = "".concat(jQuery("#ddlCreditLimitIntimation").val(), jQuery.trim(jQuery("#txtCreditLimitIntimation").val()));
            objPanel.IsShowIntimation = jQuery("#chkIntimation").is(':checked') ? 1 : 0;
            objPanel.TagBusinessLabID = jQuery("#ddlTagBusinessLab").val();
            objPanel.TagBusinessLab = jQuery("#ddlTagBusinessLab option:selected").text();
            objPanel.IsLogisticExpense = jQuery("#chkLogisticExpense").is(':checked') ? 1 : 0;
            if (jQuery("#chkLogisticExpense").is(':checked')) {
                objPanel.LogisticExpenseRateType = jQuery("#ddlLogisticExpenseRateType").val();
                objPanel.LogisticExpenseToPanelID = jQuery("#ddlLogisticExpenseTo").val();
            }
            else {
                objPanel.LogisticExpenseRateType = 0;
                objPanel.LogisticExpenseToPanelID = 0;
            }
            if (jQuery("#ddlPaymentMode").val() == "Cash") {
                objPanel.RollingAdvance = 0;
            }
            else {
                objPanel.RollingAdvance = jQuery("#chkRollingAdvance").is(':checked') ? 1 : 0;
            }
            objPanel.OwnerName = jQuery.trim(jQuery("#txtOwnerName").val());
                if (jQuery("#ddlSalesManager").val() != "" && jQuery("#ddlSalesManager").val() != null){
                    objPanel.SalesManager = jQuery("#ddlSalesManager").val();
                objPanel.SalesManagerName = jQuery("#ddlSalesManager option:selected").text();
            }
        else{
                objPanel.SalesManager = 0;
                objPanel.SalesManagerName ="";
        }


            if (jQuery("#ddlProId").val() != "" && jQuery("#ddlProId").val() != null)
                objPanel.PROID = jQuery("#ddlProId").val();
            else
                objPanel.PROID = 0;



            objPanel.IsOtherLabReferenceNo = jQuery("#chkOtherLabRefNo").is(':checked') ? 1 : 0;




            if (jQuery("#ddlPaymentMode").val() == "Credit") {
                objPanel.chkExpectedPayment = jQuery("#chkExpectedPaymentDate").is(':checked') ? 1 : 0;
                if (jQuery("#chkExpectedPaymentDate").is(':checked'))
                    objPanel.ExpectedPaymentDate = jQuery("#ddlExpectedPaymentDate").val();
                else
                    objPanel.ExpectedPaymentDate = 0;
            }
            else {
                objPanel.chkExpectedPayment = 0;
                objPanel.ExpectedPaymentDate = 0;
            }
            if ($("#ddlBarCodePrintedType").val() == "PrePrinted") {
                objPanel.BarCodePrintedType = $("#ddlBarCodePrintedType").val();
                
                objPanel.BarCodePrintedCentreType = jQuery("#chkBarcodePrintedCentreType").is(':checked') ? 1 : 0;
                objPanel.BarCodePrintedHomeColectionType = jQuery("#chkBarcodePrintedHomeCollectionType").is(':checked') ? 1 : 0;
                objPanel.SetOfBarCode = $("#ddlSetOfBarCode").val();
            }
            else {
                objPanel.BarCodePrintedType = $("#ddlBarCodePrintedType").val();

                objPanel.BarCodePrintedCentreType = 0;
                objPanel.BarCodePrintedHomeColectionType = 0;
                objPanel.SetOfBarCode = "";

            }
            objPanel.SampleCollectionOnReg = jQuery("#chkSampleCollectionOnReg").is(':checked') ? 1 : 0;            
            objPanel.IsHLMOP = 1;
            objPanel.IsHLMIP = 0;
            objPanel.IsHLMICU = 0;
            if (jQuery("#ddlType1 option:selected").text() == "B2B" || jQuery("#ddlType1 option:selected").text() == "FC") {

                objPanel.IsBatchCreate = jQuery("#chkIsBatchCreate").is(':checked') ? 1 : 0;

            }
            else {
                objPanel.IsBatchCreate = 1;
            }
            if ($('#chkSampleCollectionCharge').is(':checked')) {

                objPanel.ShowCollectionCharge = 1;
                objPanel.CollectionCharge = $('#txtSampleCollectionCharge').val();


            }
            else {
                objPanel.ShowCollectionCharge = 0;
                objPanel.CollectionCharge = 0;

            }
            if ($('#chkReportDeliveryCharge').is(':checked')) {

                objPanel.ShowDeliveryCharge = 1;
                objPanel.DeliveryCharge = $('#txtReportDeliveryCharge').val();


            }
            else {
                objPanel.ShowDeliveryCharge = 0;
                objPanel.DeliveryCharge = 0;


            }

            if (jQuery("#ddlPaymentMode").val() == "Cash") {
                objPanel.CoPaymentApplicable = 0;
                objPanel.CoPaymentEditonBooking = 0;
            }
            else {
                objPanel.CoPaymentApplicable = jQuery("#chkcopayment").is(':checked') ? 1 : 0;
                objPanel.CoPaymentEditonBooking = jQuery("#chkcopaymentedit").is(':checked') ? 1 : 0;
               
            }
            objPanel.SampleRecollectAfterReject = jQuery("#chkSampleRecollectAfterReject").is(':checked') ? 1 : 0;
            objPanel.InvoiceCreatedOn = jQuery.trim(jQuery("#ddlnvoiceCreatedOn").val());
            if (jQuery.trim(jQuery("#ddlnvoiceCreatedOn").val()) == 1)
                objPanel.MonthlyInvoiceType = 0;
            else
                objPanel.MonthlyInvoiceType = jQuery.trim(jQuery("#ddlInvoiceType").val());
            objPanel.ReceiptType = jQuery.trim(jQuery("#lstReportsOption").val());
            objPanel.CountryID = jQuery("#ddlCountry").val();
            objPanel.CountryName = jQuery("#ddlCountry option:selected").text();
            objPanel.IsAllowDoctorShare = jQuery("#chkAllowDoctorShare").is(':checked') ? 1 : 0;
            objPanel.MrpBill = jQuery("#chkMrpBill").is(':checked') ? 1 : 0;
            objPanel.PanNo = jQuery("#txtPancardno").val();
            objPanel.PANCardName = jQuery("#txtPancardname").val();
            objPanel.SecurityAmtComments = jQuery('#txtsecurityamtcomment').val();
            dataPanel.push(objPanel);
            return dataPanel;

        }
    </script>
    <script type="text/javascript">
        function openme(pagename) {
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/encryptData",
                data: '{ID:"' + jQuery('#lblCentreID').html() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (pagename == 'EmailConfiguration') {
                        var href = "../Lab/EmailConfiguration.aspx?centreID=" + mydata.d + "&Type=Centre";
                        jQuery.fancybox({
                            maxWidth: 1000,
                            maxHeight: 800,
                            fitToView: false,
                            width: '90%',
                            height: '85%',
                            href: href,
                            autoSize: false,
                            closeClick: false,
                            openEffect: 'none',
                            closeEffect: 'none',
                            'type': 'iframe'
                        }
                        );
                    }
                    else if (pagename == 'TinySMSConfiguration') {
                        var href = "../Lab/TinySMSConfiguration.aspx?centreID=" + mydata.d;
                        jQuery.fancybox({
                            maxWidth: 1000,
                            maxHeight: 400,
                            fitToView: false,
                            width: '90%',
                            height: '45%',
                            href: href,
                            autoSize: false,
                            closeClick: false,
                            openEffect: 'none',
                            closeEffect: 'none',
                            'type': 'iframe'
                        }
                        );
                    }
                    else if (pagename == 'SMSConfiguration') {
                        var href = "SMSConfigurations.aspx?PanelId=" + $('[id$=lblPanelID]').text();
                        jQuery.fancybox({
                            maxWidth: 970,
                            maxHeight: 400,
                            fitToView: false,
                            width: '100%',
                            height: '45%',
                            href: href,
                            autoSize: false,
                            closeClick: false,
                            openEffect: 'none',
                            closeEffect: 'none',
                            'type': 'iframe'
                        }
                        );
                    }
                    else {
                        window.open(pagename + '.aspx?centreID=' + mydata.d);
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        var $saveCentre = function (btnSave) {
            if (ValidateCentre() == false) {
                return;
            }
            $modelBlockUI(function () { });
            $(btnSave).attr('disabled', true).val('Submitting...');
            var resultPanel = panelMaster();
            var resultCentre = centreMaster();
            serverCall('CentreMaster.aspx/saveCentre', { Centre: resultCentre, Panel: resultPanel }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('CentreMasterReport.aspx?LogID=' + $responseData.LogID + '');
                    if (jQuery("#ddlCentreType").val().toUpperCase() == "CC")
                        window.open('CentreWelcomeLetter.aspx?CentreID=' + $responseData.CentreID + '');
		    SendCentreWelcomeEmail($responseData.CentreID);
                    clearform();
                    window.location.reload();
                }
                else {
                    $(btnSave).attr('disabled', false).val('Save');
                    if ($responseData.focusControl != null) {
                        jQuery("#" + $responseData.focusControl).focus();
                    }

                    toast('Error', $responseData.response, '');
                }
                $modelUnBlockUI(function () { });
            });
        }
        var $updateCentre = function (btnUpdate) {
            if (ValidateCentre() == false) {
                return;
            }
            if (jQuery('#chkPermanentClose').is(':visible') && jQuery('#chkPermanentClose').is(':checked') && jQuery('#txtPermanentCloseDate').val() == "") {
                toast('Error', 'Enter Permanent Close Date', '');
                jQuery('#txtPermanentCloseDate').focus();
                return;
            }
            $(btnUpdate).attr('disabled', true).val('Submitting...');
            $modelBlockUI(function () { });

            var resultPanel = panelMaster();
            var resultCentre = centreMaster();
            serverCall('CentreMaster.aspx/UpdateCentre', { Centre: resultCentre, Panel: resultPanel }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', 'Record Updated Successfully', '');
                    jQuery('#chkNewInv').prop('checked', false);
                    jQuery('#btnSave,#btnUpdate').hide();
                    window.open('CentreMasterReport.aspx?LogID=' + $responseData.LogID + '');
                    clearform();
                    window.location.reload();
                }
                else {
                    $(btnUpdate).attr('disabled', false).val('Update');
                    toast('Error', $responseData.response, '');
                }
                $modelUnBlockUI(function () { });
            });
        }
        function ValidateCentre() {
            var con = 0;
            jQuery('#spnError').html('');
            if (jQuery.trim(jQuery('#txtCentreName').val()) == "") {
                toast('Error', 'Please Enter Centre Name', '');
                jQuery('#txtCentreName').focus();
                return false;
            }
            if (jQuery.trim(jQuery('#txtUHIDCode').val()) == "") {
                toast('Error', 'Please Enter UHID Code', '');
                jQuery('#txtUHIDCode').focus();
                return false;
            }
            if (jQuery.trim(jQuery('#txtUHIDCode').val()).length < 3) {
                toast('Error', 'Please Enter Valid UHID Code', '');
                jQuery('#txtUHIDCode').focus();
                return false;
            }
         //  if (jQuery.trim(jQuery('#ddlCountry').val()) == "0") {
         //      toast('Error', 'Please Select Country', '');
         //      jQuery('#ddlCountry').focus();
         //      return false;
         //  }
         //  if (jQuery.trim(jQuery('#ddlBusinessZone').val()) == "0") {
         //      toast('Error', 'Please Select Business Zone', '');
         //      jQuery('#ddlBusinessZone').focus();
         //      return false;
         //  }
        //   if (jQuery.trim(jQuery('#ddlState').val()) == "0" || jQuery.trim(jQuery('#ddlState').val()) == "0") {
        //       toast('Error', 'Please Select State', '');
        //       jQuery('#ddlState').focus();
        //       return false;
        //   }
        //   if (jQuery.trim(jQuery('#ddlCity').val()) == "0" || jQuery.trim(jQuery('#ddlCity').val()) == "0") {
        //       toast('Error', 'Please Select City', '');
        //       jQuery('#ddlCity').focus();
        //       return false;
        //   }
        //   if (jQuery.trim(jQuery('#ddlZone').val()) == "0" || jQuery.trim(jQuery('#ddlZone').val()) == "0") {
        //       toast('Error', 'Please Select Zone', '');
        //       jQuery('#ddlZone').focus();
        //       return false;
        //   }
        //   if (jQuery.trim(jQuery('#ddlLocality').val()) == "0" || jQuery.trim(jQuery('#ddlLocality').val()) == "0") {
         //      toast('Error', 'Please Select Locality', '');
         //      jQuery('#ddlLocality').focus();
         //      return false;
         //  }
         //  if (jQuery.trim(jQuery('#txtOwnerName').val()) == "") {
         //      toast('Error', 'Please Enter Owner Name', '');
         //      jQuery('#txtOwnerName').focus();
         //      return false;
         //  }
            if (jQuery('#ddlTagProcessingLab option:selected').text() == "Select" || jQuery('#ddlTagProcessingLab').val() == null) {
                toast('Error', 'Please Select TagProcessing Lab', '');
                jQuery('#ddlTagProcessingLab').focus();
                return false;
            }
            if (jQuery('#ddlTagBusinessLab option:selected').text() == "Select") {
                toast('Error', 'Please Select TagBusiness Lab', '');
                jQuery('#ddlTagBusinessLab').focus();
                return false;
            }
            if (jQuery("#ddlCentreType").val().toUpperCase() == "CC" && jQuery("#ddlInvoiceTo").val() == "0") {
              // if (jQuery("#txtCreditLimitIntimation").val() == "") {
              //     toast('Error', "Please Enter " + jQuery('#ddlPaymentMode').val() + " Intimation Limit", '');
              //     jQuery('#txtCreditLimitIntimation').focus();
              //     return false;
              // }
             //  if (jQuery("#txtLabreportlimit").val() == "") {
             //      toast('Error', "Please Enter " + jQuery('#ddlPaymentMode').val() + " Reporting Limit", '');
             //      jQuery('#txtLabreportlimit').focus();
             //      return false;
             //  }
             //  if (jQuery("#txtCreditLimit").val() == "") {
             //      toast('Error', "Please Enter " + jQuery('#ddlPaymentMode').val() + " Booking Limit", '');
             //      jQuery('#txtCreditLimit').focus();
             //      return false;
             //  }
                if (parseFloat("".concat(jQuery("#ddlLabreportlimit option:selected").text(), jQuery("#txtLabreportlimit").val())) > parseFloat("".concat(jQuery("#ddlCreditLimitIntimation option:selected").text(), jQuery("#txtCreditLimitIntimation").val()))) {
                    toast('Error', 'Please Enter valid Reporting Limit', '');
                    jQuery('#txtLabreportlimit').focus();
                    return false;
                }
                if (parseFloat("".concat(jQuery("#ddlCreditLimit option:selected").text(), jQuery("#txtCreditLimit").val())) > parseFloat("".concat(jQuery("#ddlLabreportlimit option:selected").text(), jQuery("#txtLabreportlimit").val()))) {
                    toast('Error', 'Please Enter valid Booking Limit', '');
                    jQuery('#txtCreditLimit').focus();
                    return false;
                }
                if (parseFloat("".concat(jQuery("#ddlCreditLimit option:selected").text(), jQuery("#txtCreditLimit").val())) > parseFloat("".concat(jQuery("#ddlCreditLimitIntimation option:selected").text(), jQuery("#txtCreditLimitIntimation").val()))) {
                    toast('Error', 'Please Enter valid Booking Limit', '');
                    jQuery('#txtCreditLimit').focus();
                    return false;
                }
            }
            if (jQuery("#chkLogisticExpense").is(':checked')) {
                if (jQuery('#ddlLogisticExpenseRateType').val() == null || jQuery('#ddlLogisticExpenseRateType').val() == "") {
                    toast('Error', 'Please Select Logistic Expense RateType', '');
                    jQuery('#ddlLogisticExpenseRateType').focus();
                    return false;
                }
                if (jQuery('#ddlLogisticExpenseTo').val() == null || jQuery('#ddlLogisticExpenseTo').val() == "") {
                    toast('Error', 'Please Select Logistic Expense To', '');
                    jQuery('#ddlLogisticExpenseTo').focus();
                    return false;
                }
            }
            if ((jQuery('#ddlType1 option:selected').text() == "HLM" || jQuery('#ddlType1 option:selected').text() == "PCC") && jQuery("#rblCentreSelection input[type=radio]:checked").val() == "FOCO") {
                if (jQuery.trim(jQuery("#txtIFSCCode").val()) == "") {
                    toast('Error', 'Please Enter IFSC Code', '');
                    jQuery('#txtIFSCCode').focus();
                    return false;
                }
            }
            if (jQuery('#btnSave').is(':visible') && jQuery("#ddlCentreType").val().toUpperCase() == "CC") {
                if (jQuery.trim(jQuery("#txtClientUserName").val()) != "" && jQuery.trim(jQuery("#txtClientUserPassword").val()) == "") {
                    toast('Error', 'Please Enter User Password', '');
                    jQuery('#txtClientUserPassword').focus();
                    return false;
                }
                if (jQuery.trim(jQuery("#txtClientUserName").val()) == "" && jQuery.trim(jQuery("#txtClientUserPassword").val()) != "") {
                    toast('Error', 'Please Enter User Name', '');
                    jQuery('#txtClientUserName').focus();
                    return false;
                }
                if (jQuery.trim(jQuery("#txtClientUserName").val()) != "" && jQuery.trim(jQuery("#txtClientUserName").val()).length < 3) {
                    toast('Error', 'Please Enter Valid User Name.User Name Must Contain At least 3 Characters', '');
                    jQuery('#txtClientUserName').focus();
                    return false;
                }
                if (jQuery.trim(jQuery("#txtClientUserName").val()) != "" && jQuery.trim(jQuery("#txtClientUserName").val()).length < 3) {
                    toast('Error', 'Please Enter Valid User Password.User Password Must Contain At least 3 Characters', '');
                    jQuery('#txtClientUserName').focus();
                    return false;
                }
                if (jQuery.trim(jQuery("#txtLedgerReportPassword").val()) != "" && jQuery.trim(jQuery("#txtLedgerReportPassword").val()).length < 3) {
                    toast('Error', 'Please Enter Valid Ledger Password.Ledger Password Must Contain At least 3 Characters', '');
                    jQuery('#txtClientUserName').focus();
                    return false;
                }
            }
            if (jQuery("#chkExpectedPaymentDate").is(':checked') && jQuery("#ddlExpectedPaymentDate").val() == "0" && jQuery("#ddlPaymentMode").val() == "Credit") {
                toast('Error', 'Please Select Expected Payment Date', '');
                jQuery('#ddlExpectedPaymentDate').focus();
                return false;
            }
            if (jQuery('#btnUpdate').is(':visible') && jQuery('#chkLedgerReportPassword').is(':checked')) {
                if (jQuery.trim(jQuery("#txtLedgerReportPassword").val()) != "" && jQuery.trim(jQuery("#txtLedgerReportPassword").val()).length < 3) {
                    toast('Error', 'Please Enter Valid Ledger Password.Ledger Password Must Contain At least 3 Characters', '');
                    jQuery('#txtClientUserName').focus();
                    return false;
                }
            }
            if ($("#chkSampleCollectionCharge").is(':checked') && ($('#txtSampleCollectionCharge').val() == "" || $('#txtSampleCollectionCharge').val() == "0")) {

                toast('Error', 'Please Enter Collection Charge', '');
                jQuery('#txtSampleCollectionCharge').focus();
                return false;
            }
            if ($("#chkReportDeliveryCharge").is(':checked') && ($('#txtReportDeliveryCharge').val() == "" || $('#txtReportDeliveryCharge').val() == "0")) {

                toast('Error', 'Please Enter Report Delivery Charge', '');
                jQuery('#txtReportDeliveryCharge').focus();
                return false;
            }
            if (jQuery("#ddlCentreType").val() == "Client") {
                if ($('#ddlnvoiceCreatedOn').val() == "0") {
                    toast('Error', 'Please Select Invoice Credit type', '');
                    jQuery('#ddlnvoiceCreatedOn').focus();
                    return false;
                }
                if (jQuery("#ddlnvoiceCreatedOn").val() == "2" && $('#ddlInvoiceType').val() == "0") {                  
                        toast('Error', 'Please Select Invoice  type', '');
                        jQuery('#ddlInvoiceType').focus();
                        return false;                    
                }
            }

        }
        function DoListBoxFilter(listBoxSelector, textbox, filter, keys, values) {
            var list = jQuery(listBoxSelector);
            values = [];
            keys = [];
            var options = jQuery('#lstCentre option');
            jQuery.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            var selectBase = '<option value="{0}">{1}</option>';
            for (i = 0; i < values.length; ++i) {
                var value = values[i].toLowerCase();
                var len = jQuery(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    var sc = jQuery('#lstCentre').scrollTop();
                    var news = sc + i;
                    jQuery('#lstCentre').scrollTop(news);
                    list.attr('selectedIndex', i);
                    return;
                }
            }
        }
        var keys = [];
        var values = [];
        var timer = null;
        function Click(ctr) {
            clearTimeout(timer);
            timer = setTimeout(filtCentreData, 200);
        }
        function filtCentreData() {
            jQuery("#lstCentre option").attr("selected", null);
            var filter = jQuery('#txtSearch').val();
            if (filter.length > 0) {
                var search = filter.toLowerCase();
                var arr = jQuery.grep(centreData, function (item) {
                    return item.Centre.toLowerCase().indexOf(search) != -1;
                });
                jQuery('#lstCentre option').remove();
                for (var i = 0; i < arr.length; i++) {
                    jQuery('#lstCentre').append(jQuery("<option></option>").val(arr[i].CentreID).html(arr[i].Centre));
                }
            }
            else {
                clearform();
                jQuery('#lstCentre option').remove();
                for (var i = 0; i < centreData.length; i++) {
                    jQuery('#lstCentre').append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                }
                jQuery("#lstCentre option").removeAttr('selected');
            }
        }
        function chkNew() {
            if (jQuery("#chkNewInv").is(':checked')) {
                jQuery("#btnSave").show();
                jQuery("#txtSearch,#ddlSearchCentreType").attr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#lstCentre").attr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#ddlType1,#ddlCentreType,#txtInvoiceDisplayName,#txtInvoiceDisplayAddress,#txtInvoiceDisplayNo,#ddlTagProcessingLab,#ddlTagBusinessLab,#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit,#ddlReferMrp,#ddlReferringRate,#ddlReferShare").removeAttr('disabled');
                jQuery("#ddlTagProcessingLab,#ddlTagBusinessLab").trigger('chosen:updated');
                jQuery("#spnWelcomeMail,#trPermanentClose,#chkLedgerReportPassword").hide();
                jQuery("#chkLedgerReportPassword").prop('checked', true);
                jQuery("#chkPermanentClose").prop('checked', false);
                if (jQuery("#ddlType1 option:selected").text() == "B2B") {
                    jQuery("#chkShowAmtInBooking,#chkHideReceiptRate,#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');
                }
                else if (jQuery("#ddlType1 option:selected").text() == "CC") {
                    jQuery("#chkHideReceiptRate,#chkShowAmtInBooking").prop('checked', false).attr('disabled', 'disabled');
                    jQuery("#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');
                }
                else if (jQuery("#ddlType1 option:selected").text() == "FC") {
                    jQuery("#chkShowAmtInBooking,#chkHideReceiptRate,#chkshowBalanceAmount").prop('checked', 'checked').attr('disabled', 'disabled');
                }
            }
            else {
                jQuery("#btnSave").hide();
                jQuery("#txtSearch,#ddlSearchCentreType").removeAttr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#lstCentre").removeAttr('disabled', jQuery("#chkNewInv").attr('checked'));
                jQuery("#ddlType1,#ddlCentreType").attr('disabled', 'disabled');
                jQuery("#chkLedgerReportPassword").show();
                jQuery("#chkLedgerReportPassword").prop('checked', false);
            }
            SetCenterName();
        }
        function onsucessTagBusinessLab(result) {
        }
        function onFailureTagBusinessLab(result) {
        }
        function getExcelData() {
            serverCall('Centremaster.aspx/getExcelData', {}, function (response) {
                var $responseData = JSON.parse(response);
                PostReport($responseData.Query, $responseData.ReportName, "", $responseData.ReportPath);

            });
        }
        function getCentreType() {
            getLoginDetail();
            jQuery("#txtClientUserName,#txtClientUserPassword,#txtLedgerReportPassword").val('');
            bindCentreType();
			if (jQuery('#ddlCentreType').val()=="CC")
			{
				clearform();
				jQuery('#ddlCentreType').val('LAB');
				window.open('PUPMaster.aspx');
			}
        }
        function getLoginDetail() {
            if (jQuery("#ddlCentreType").val().toUpperCase() == "LAB") {
                jQuery(".trLoginDetail,.trLoginDetails,.tdLoginDetail,.clPaymentMode").hide();
                jQuery('#chkshowBalanceAmount, label[for="chkshowBalanceAmount"]').hide();
                jQuery('#chkHideReceiptRate, label[for="chkHideReceiptRate"]').hide();
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').hide();
                jQuery('#chkMrpBill, label[for="chkMrpBill"]').hide();
                jQuery('#chkShowAmtInBooking').prop('checked', false);
                jQuery('#ddlInvoiceType').val('1');
            }
            else {
               
                jQuery(".trLoginDetail,.trLoginDetails,.tdLoginDetail,.clPaymentMode").show();
                jQuery('#chkshowBalanceAmount, label[for="chkshowBalanceAmount"]').show();
                jQuery('#chkHideReceiptRate, label[for="chkHideReceiptRate"]').show();
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').show();
                jQuery('#chkMrpBill, label[for="chkMrpBill"]').show();
                jQuery('#chkShowAmtInBooking').prop('checked', false);
                jQuery('#ddlInvoiceType').val('0');
            }
        }
    </script>
    <script type="text/javascript">
        var $chkBarCodeType = function () {
            if ($("#ddlBarCodePrintedType").val() == "System") {
                $(".clBarcodeType").hide();
                $("#chkBarcodePrintedCentreType,#chkBarcodePrintedHomeCollectionType").prop('checked', false);
            }
            else {
                $(".clBarcodeType").show();
            }
        }
        function setSampleCollectionCharge() {
            if ($("#chkSampleCollectionCharge").is(':checked')) {
                $('#txtSampleCollectionCharge').val('').attr("disabled", false);

            }
            else {
                $('#txtSampleCollectionCharge').val('').attr("disabled", true);

            }
        }
        function setReportDeliveryCharge() {
            if ($("#chkReportDeliveryCharge").is(':checked')) {

                $('#txtReportDeliveryCharge').val('').attr("disabled", false);
            }
            else {

                $('#txtReportDeliveryCharge').val('').attr("disabled", true);
            }
        }
    </script>
    <script type="text/javascript">
        function setcoedit() {


            if ($('#chkcopayment').is(':checked')) {
                jQuery("#chkcopaymentedit").prop('checked', false).removeAttr('disabled');

            }
            else {
                jQuery("#chkcopaymentedit").prop('checked', false).attr('disabled', 'disabled');
            }
        }

        function setcopayment() {
            if (jQuery("#ddlPaymentMode").val() == "Cash") {
                jQuery("#chkcopayment").prop('checked', false).attr('disabled', 'disabled');
                jQuery("#chkcopaymentedit").prop('checked', false).attr('disabled', 'disabled');
            }
            else {
                jQuery("#chkcopayment").prop('checked', false).removeAttr('disabled');
                jQuery("#chkcopaymentedit").prop('checked', false).attr('disabled', 'disabled');
            }
        }
        function InvoiceCreatedShowHide() {
            if (jQuery("#ddlCentreType").val().toUpperCase() == "LAB") {
                $('#ddlnvoiceCreatedOn').val('1');
                $('.InvoiceCreated').hide();
            }
            else if (jQuery("#ddlPaymentMode").val().toUpperCase() == "CASH") {
                $('#ddlnvoiceCreatedOn').val('1');
                $('.InvoiceCreated').hide();
            }
            else {
                $('.InvoiceCreated').show();
                $('#ddlnvoiceCreatedOn').val('0');
            }
            if (jQuery("#ddlPaymentMode").val() == "Credit") {
               // $('.InvoiceCreated').show();
            }
            else {               
               // $('#ddlInvoiceType').val('0');
               // jQuery("#ddlnvoiceCreatedOn").val('0')
               // $('.InvoiceCreated').hide();
            }
           
        }
    </script>
</asp:Content>

