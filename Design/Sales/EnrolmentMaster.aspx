<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="false" ClientIDMode="Static" AutoEventWireup="true" CodeFile="EnrolmentMaster.aspx.cs" Inherits="Design_Sales_EnrolmentMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
   <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
       <link rel="stylesheet" href="../../App_Style/jquery-ui.css" />
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    

     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory" style="width: 1304px; text-align: left;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <b>Enrolment Master </b>
            <br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblEnrollID" runat="server"  style="display:none" />
            <asp:Label ID="lblTypeID" runat="server"  style="display:none" />
            <asp:Label ID="lblIsApprove" runat="server"  style="display:none" />
            <asp:Label ID="lblTypeName" runat="server"  style="display:none" />
            <asp:Label ID="lblIsDirectApprovalPending" runat="server"  style="display:none" />
            <asp:Label ID="lblIsView" runat="server"  style="display:none" />
            <asp:Label ID="lblCurrentDate" runat="server"  style="display:none" />

            
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: left;">

            <table style="height: auto; width: 100%; border-collapse: collapse">
                <tr style="width: 100%;">
                    <td style="vertical-align: top">
                        <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                <td style="text-align: right; width: 14%"><b>Type :&nbsp;</b></td>
                                <td style="width: 24%">
                                    <asp:Label ID="lbid" runat="server" Style="display: none;"></asp:Label>
                                    <asp:Label ID="lblPanelID" runat="server" Style="display: none;"></asp:Label>
                                    <asp:DropDownList ID="ddlType" runat="server" Width="166px" onchange="selectPatientType()">
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right; width: 14%"><b>Patient&nbsp;Type&nbsp;:&nbsp;</b></td>
                                <td style="width: 20%">
                                    <asp:DropDownList ID="ddlPanelGroup" runat="server" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right; width: 12%">&nbsp;</td>
                                <td style="width: 16%">&nbsp;</td>
                            </tr>
                            <tr>
                               <td style="text-align: right"><b><span style="color: red;"> Name :&nbsp;</span></b></td>
                                <td>
                                    <asp:TextBox ID="txtName" runat="server" Width="240px" MaxLength="50" AutoCompleteType="Disabled"  style="text-transform:uppercase"></asp:TextBox>
                                </td>
                                <td style="text-align: right">&nbsp;</td>
                                <td>
                                    &nbsp;
                                </td>
                                <td style="text-align: right; color: red;">&nbsp;</td>
                                <td style="display: none">&nbsp;
                                        <asp:CheckBox ID="isActive" ForeColor="Red" runat="server" Text="Active" Style="font-weight: 700" Checked="true" /></td>
                            </tr>
                            <tr style="display:none">
                                <td style="text-align: right"><b>Designation :&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlDesignation" runat="server" Width="166px" onchange="bindEmployee();getSpecialTestLimit()">
                                    </asp:DropDownList></td>
                                <td style="text-align: right"><b>Employee Name :&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlName" runat="server" Width="190px" >
                                    </asp:DropDownList></td>
                                <td style="text-align: right;">&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <div id="SalesOutput" style="max-height: 100px; overflow-y: auto; overflow-x: hidden;">
                                        <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                            <tr id="salesHead">
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">S.No.</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 140px; text-align: left">Designation</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 440px; text-align: left">Employee Name</th>
                                                <th class="GridViewHeaderStyle EnrollVerified" scope="col" style="width: 90px; text-align: center;display:none">Created Date</th>
                                                <th class="GridViewHeaderStyle EnrollVerified" scope="col" style="width: 70px; text-align: center;display:none" >Verified</th>
                                                <th class="GridViewHeaderStyle EnrollVerified" scope="col" style="width: 90px; text-align: center;display:none">Verified Date</th>
                                                <th class="GridViewHeaderStyle EnrollVerified" scope="col" style="width: 70px; text-align: center;display:none" >Approved</th>
                                                <th class="GridViewHeaderStyle EnrollVerified" scope="col" style="width: 104px; text-align: center;display:none">Approved Date</th>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>                           
                            <tr>
                                <td style="color: red;" colspan="6">
                                    <div id="Div2" class="Purchaseheader" runat="server">
                                        Address Detail
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right"><b><span class="clAddress"> Address :&nbsp;</span></b></td>
                                <td>
                                    <asp:TextBox ID="txtAddress" runat="server" Width="240px" MaxLength="50" AutoCompleteType="Disabled"> </asp:TextBox>
                                </td>
                                <td style="font-weight: 700; text-align: right"><b>LandLine No. :&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtLandline" runat="server" Width="160px" MaxLength="12" AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftblandline" runat="server" TargetControlID="txtLandline" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                </td>
                                <td style="text-align: right"><b><span class="clMobileNo"> Mobile No. :&nbsp;</span></b></td>
                                <td>
                                    <asp:TextBox ID="txtMobile" runat="server" Width="160px" MaxLength="10" AutoCompleteType="Disabled"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                </td>
                            </tr>
                            <tr class="addressDetail" style="display:none">
                                <td style="text-align: right"><b><span class="clBusinessZone">Business Zone :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                <td style="font-weight: 700; text-align: right"><b><span class="clState">State :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlState" runat="server" onchange="bindHeadQuarter()" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right"><b><span class="clHeadQuarter">HeadQuarter :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlHeadQuarter" runat="server" onchange="bindCity()" Width="166px">
                                    </asp:DropDownList></td>
                            </tr>
                            <tr class="addressDetail" style="display:none">
                                <td style="text-align: right"><b><span class="clCity">City :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlCity" runat="server" onchange="bindZone()" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                <td style="font-weight: 700; text-align: right"><b><span class="clCityZone">City Zone :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlZone" runat="server" onchange="bindLocality()" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right"><b><span class="clLocality">Locality :&nbsp;</span></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlLocality" runat="server" Width="166px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-weight: 700" colspan="6">
                                    <div id="Div5" class="Purchaseheader" runat="server">
                                        Type
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right"><b>Payment&nbsp;Mode&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlPaymentMode" runat="server" Width="166px" onchange="getPaymentCon()">
                                        <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                        <asp:ListItem Value="Credit">Credit</asp:ListItem>
                                    </asp:DropDownList></td>
                                <td style="text-align: right"><b><%--Print At Centre :&nbsp;--%></b></td>
                                <td>
                                    <asp:DropDownList ID="ddlPrintAtCentre" runat="server" Width="166px" style="display:none">
                                    </asp:DropDownList>
                                    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
                                        <p id="msgField" style="color:white;padding:10px;font-weight:bold;">
                                        </p>
                                    </div>
                                    <b><asp:CheckBox ID="chkOnlineLogin" runat="server" ClientIDMode="Static" Text="Online Login Required" /></b>
                                   </td>
                                <td style="text-align: left" colspan="2">
                                    <b>
                                    <asp:CheckBox ID="chkAAALogo" runat="server" ClientIDMode="Static" Text="Show AAA Logo In Report" />
                                    </b>
                                </td>
                                
                            </tr>
                            <tr>
                                <td style="text-align: right"><b>Email&nbsp;Id(Invoice)&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtEmailInvoice" runat="server" Width="160px" MaxLength="50"></asp:TextBox></td>
                                <td style="text-align: right"><b>Email&nbsp;Id(Report)&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtEmailReport" runat="server" Width="160px" MaxLength="50"></asp:TextBox></td>
                                <td style="text-align: right"><b>Report&nbsp;DispatchMode&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlReportDispatchMode" runat="server" Width="166px">
                                        <asp:ListItem Value="BOTH">BOTH</asp:ListItem>
                                        <asp:ListItem Value="MAIL">MAIL</asp:ListItem>
                                        <asp:ListItem Value="PRINT">PRINT</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>                               
                                <td style="text-align: right"><b>GST TIN :&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtGSTTIN" Width="160px" runat="server" MaxLength="50"></asp:TextBox></td>
                                <td style="text-align: right"><b>Invoice&nbsp;Billing&nbsp;Cycle&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlInvoiceBillingCycle" runat="server" Width="166px">
                                        <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                        <asp:ListItem Text="15 Days" Value="15 Days"></asp:ListItem>
                                        <asp:ListItem Text="Monthly" Value="Monthly" Selected="True"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right" title="One Client With Multiple Location"><b> Invoice To :&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlInvoiceTo" runat="server" ToolTip="One Client With Multiple Location" Width="166px">
                                    </asp:DropDownList>
                                    

                                </td>
                            </tr>                           
                            <tr>
                                <td style="text-align: right"><b>Bank Name :&nbsp;</b></td>
                                <td>
                                    <asp:DropDownList ID="ddlBankName" runat="server" Width="166px">
                                    </asp:DropDownList></td>
                                <td style="text-align: right"><b>Account&nbsp;No.&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtAccountNo" Width="160px" runat="server" MaxLength="30"></asp:TextBox></td>
                                <td style="text-align: right"><b>IFSC&nbsp;Code&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtIFSCCode" Width="160px" runat="server" MaxLength="30"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="text-align: right">
                                    <b><span class="clTagRegistrationLab"> Tag RegistrationLab&nbsp;:&nbsp;</span> </b>
                                <td style="text-align: left">

                                    <asp:DropDownList ID="ddlTagProcessingLab" runat="server" Width="166px" onchange="changeRefRate()">
                                    </asp:DropDownList>
                                </td>
                                <td style="text-align: right;display:none"><b>Online&nbsp;UserName&nbsp;:&nbsp;</b></td>
                                <td style="display:none">
                                    <asp:TextBox ID="txtOnlineUserName" runat="server" MaxLength="30" Width="160px"></asp:TextBox>
                                </td>
                                <td style="text-align: right;">
                                    <b>Referring&nbsp;Rate&nbsp;:&nbsp;</b>
                                    <%--<b>Online&nbsp;Password&nbsp;:&nbsp;</b>--%></td>
                                <td >
                                    <asp:TextBox ID="txtOnlinePassword" TextMode="Password" runat="server" MaxLength="30" Width="160px" style="display:none"></asp:TextBox>

                                      <asp:DropDownList ID="ddlReferringRate" runat="server" ToolTip="Select Referring Rate of" Width="166px">
                                    </asp:DropDownList>
                                </td>
                                
                            </tr>
                            <tr>
                                <td style="text-align: right"><b>Credit&nbsp;Limits&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtCreditLimit" AutoCompleteType="Disabled" runat="server" Width="160px" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbCreditLimit" runat="server" ValidChars="0123456789" TargetControlID="txtCreditLimit" />
                                </td>
                                <td style="text-align: right"><b>Min&nbsp;Cash&nbsp;in&nbsp;Booking&nbsp;:&nbsp;</b></td>
                                <td>
                                    <asp:TextBox ID="txtMinCash" runat="server" Text="0" Width="50px" AutoCompleteType="Disabled" onkeyup="chkMinCash()" onkeypress="return checkForSecondDecimal(this,event)" />
                                            <cc1:FilteredTextBoxExtender ID="ftbMinCash" runat="server" FilterType="Numbers" TargetControlID="txtMinCash" />
                                    (In %)
                                            </td>
                                
                                <td style="text-align: left" colspan="2">
                                   

                                    <asp:Label ID="lblFileName" runat="server" style="display:none;"></asp:Label>
                                    <span style="font-weight:bold;" id="spnAttachment"><a href="javascript:void(0)" onclick="showuploadbox()" style="color:blue;"><b>Attach Agreement/MOU/Cancel Cheque</b> </a></span>
                                </td>
                            </tr>                            
                                                      
                            <tr>
                                <td style="text-align: right"><b>Invoice&nbsp;Display&nbsp;Name&nbsp;:&nbsp;</b></td>
                                <td>
                                <asp:TextBox ID="txtInvoiceDisplayName" runat="server" MaxLength="50"  Width="160px"></asp:TextBox>
                                </td>
                                <td style="text-align: right"><b>Invoice&nbsp;Display&nbsp;Address&nbsp;:&nbsp;</b></td>
                                <td colspan="3">
                                   <asp:TextBox ID="txtInvoiceDisplayAddress" runat="server" MaxLength="100"  Width="320px"></asp:TextBox></td>
                                
                            </tr>                            
                                                      
                             <tr>
                                <td style="color: red;" colspan="6">
                                    <div id="Div1" class="Purchaseheader" runat="server">
                                       Test Detail
                                    </div>
                                </td>
                            </tr>
                            <tr id="tr_HLM">
                                <td style="text-align: right"><b><span class="clMinBusinessCommit">Min.&nbsp;Business&nbsp;Commit.&nbsp;:&nbsp;</span></b></td>
                                <td>
                                    
                                    <asp:TextBox ID="txtMinBusinessComm" AutoCompleteType="Disabled" Width="160px" runat="server" onkeyup="selectSpecialTestLimit()" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbMinBusiness" runat="server" TargetControlID="txtMinBusinessComm" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                                </td>
                                <td style="text-align: right">
                                    <b><span class="clMRPPercentage"><span id="spnMRPPercentage" style="display:none"></span></span></b>
                                     
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMRPPercentage" AutoCompleteType="Disabled" style="display:none" runat="server"  Width="50px" onkeyup="chkMRPPercentage()" onkeypress="return checkForSecondDecimal(this,event)" />
                                            <cc1:FilteredTextBoxExtender ID="ftbMRPPercentage" runat="server" ValidChars="0123456789"  TargetControlID="txtMRPPercentage" />
                                </td>
                                <td style="text-align: left"  colspan="2"><b><span id="spnDiscLimit" style="display:none"> Disc. Limit :&nbsp;</span> </b>
                                    <b><span id="spnDesiMRPPercentage" style="display:none"></span></b>&nbsp;&nbsp;&nbsp;&nbsp;
                                     <b>Special Test Limit :&nbsp;
                                    <span id="spnSpecialTestLimit" style="font:bold;font-size:large"></span></b>
                                  <asp:TextBox ID="txtStateCity" runat="server" Style="display:none"></asp:TextBox>
                                </td>                            
                            </tr>  
                            <tr id="tr_HLMMRP"  style="display:none">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="3">
                                     <table style="width:100%;border-collapse:collapse" class="GridViewStyle">
                                        <tr>
                                            <td style="width:6%" class="GridViewHeaderStyle">
                                                &nbsp;
                                            </td>
                                            <td style="width:10%" class="GridViewHeaderStyle">
                                                 &nbsp;
                                            </td>
                                            <td style="width:14%" class="GridViewHeaderStyle">

                                                <b>Hike in MRP %</b></td>
                                             <td style="width:16%" class="GridViewHeaderStyle">

                                                <b> Client Share %</b></td>
                                            <td style="width:16%" class="GridViewHeaderStyle">
                                                Payment Mode
                                            </td>
                                            <td style="width:16%" class="GridViewHeaderStyle">
                                                Patient Pay To
                                            </td>
                                           <td style="width:22%">&nbsp;</td>
                                        </tr>
                                         <tr>
                                            <td class="GridViewLabItemStyle">
                                          <asp:CheckBox ID="chkHLMOP" runat="server" Enabled="false" Checked="true" />
                                                
                                            </td>
                                            <td class="GridViewLabItemStyle">
                                               <b> HLM OP </b>
                                            </td>
                                            <td class="GridViewLabItemStyle">
                                                 <asp:TextBox ID="txtHLMOPMRP" AutoCompleteType="Disabled" runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMOPMRP" runat="server" TargetControlID="txtHLMOPMRP" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>

                                            </td>
                                             <td class="GridViewLabItemStyle">
                                                 <asp:TextBox ID="txtHLMOPClientShare" AutoCompleteType="Disabled"  runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMOPClient" runat="server" TargetControlID="txtHLMOPClientShare" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>

                                            </td>
                                             <td class="GridViewLabItemStyle">
                                                <asp:DropDownList ID="ddlHLMOPPaymentMode" runat="server" Width="100px" onchange="getOPPaymentCon()">
                                                    <asp:ListItem Value="Cash" Text="Cash"></asp:ListItem>
                                                    <asp:ListItem Value="Credit" Text="Credit"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                             <td class="GridViewLabItemStyle">
                                             <asp:RadioButtonList style="FLOAT: left; font-weight:bold;" ID="rblHLMOPPatientPayTo" runat="server"  ClientIDMode="Static" RepeatDirection="Horizontal">
                                                     <asp:ListItem Text="Client" Value="Client" Selected="True"></asp:ListItem>
                                                     <asp:ListItem Text="Lab" Value="Lab"></asp:ListItem>
                                        </asp:RadioButtonList>
                                                  </td>
                                             <td style="width:24%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                           <td class="GridViewLabItemStyle">
                                              
                                               <asp:CheckBox ID="chkHLMIP" runat="server"  />
                                            </td>
                                            <td class="GridViewLabItemStyle">
                                              <b>  HLM IP </b>
                                            </td>
                                            <td class="GridViewLabItemStyle">
                                                <asp:TextBox ID="txtHLMIPMRP" AutoCompleteType="Disabled"  runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMIPMRP" runat="server" TargetControlID="txtHLMIPMRP" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>
                                            </td>
                                             <td class="GridViewLabItemStyle">
                                                  <asp:TextBox ID="txtHLMIPClientShare" AutoCompleteType="Disabled"  runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMIPClient" runat="server" TargetControlID="txtHLMIPClientShare" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>

                                            </td>
                                            <td class="GridViewLabItemStyle">
                                                <asp:DropDownList ID="ddlHLMIPPaymentMode" runat="server" Width="100px" onchange="getIPPaymentCon()">
                                                    <asp:ListItem Value="Cash" Text="Cash"></asp:ListItem>
                                                    <asp:ListItem Value="Credit" Text="Credit"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                             <td class="GridViewLabItemStyle">
                                             <asp:RadioButtonList style="FLOAT: left; font-weight:bold;" ID="rblHLMIPPatientPayTo" runat="server"  ClientIDMode="Static" RepeatDirection="Horizontal">
                                                     <asp:ListItem Text="Client" Value="Client" Selected="True"></asp:ListItem>
                                                     <asp:ListItem Text="Lab" Value="Lab"></asp:ListItem>
                                        </asp:RadioButtonList>
                                                  </td>
                                            <td style="width:24%">&nbsp;</td>
                                        </tr>
                                       
                                        <tr>
                                            <td class="GridViewLabItemStyle">
                                                
                                                <asp:CheckBox ID="chkHLMICU" runat="server"  />
                                            </td>
                                            <td class="GridViewLabItemStyle">

                                               <b> HLM ICU </b></td>
                                            <td class="GridViewLabItemStyle">
                                            <asp:TextBox ID="txtHLMICUMRP" AutoCompleteType="Disabled"  runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMICUMRP" runat="server" TargetControlID="txtHLMICUMRP" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>
   
                                            </td>
                                            <td class="GridViewLabItemStyle">
                                                <asp:TextBox ID="txtHLMICUClientShare" AutoCompleteType="Disabled"  runat="server" MaxLength="6" Width="60px" onkeyup="chkHLMPer(this.value)"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbHLMICUClient" runat="server" TargetControlID="txtHLMICUClientShare" ValidChars="1234567890"></cc1:FilteredTextBoxExtender>

                                            </td>
                                             <td class="GridViewLabItemStyle">
                                                <asp:DropDownList ID="ddlHLMICUPaymentMode" runat="server" Width="100px" onchange="getICUPaymentCon()">
                                                    <asp:ListItem Value="Cash" Text="Cash"></asp:ListItem>
                                                    <asp:ListItem Value="Credit" Text="Credit"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                             <td class="GridViewLabItemStyle">
                                             <asp:RadioButtonList style="FLOAT: left; font-weight:bold;" ID="rblHLMICUPatientPayTo" runat="server"  ClientIDMode="Static" RepeatDirection="Horizontal">
                                                     <asp:ListItem Text="Client" Value="Client" Selected="True"></asp:ListItem>
                                                     <asp:ListItem Text="Lab" Value="Lab"></asp:ListItem>
                                        </asp:RadioButtonList>
                                                  </td>
                                            <td style="width:24%">&nbsp;</td>
                                        </tr>
                                    </table>

                                    &nbsp;</td>
                                <td style="text-align: right">
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                                                        
                            </tr>                                                        
                                      
                                                                        
                            <tr style="display:none">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <div id="div_PCCGrouping"  style="max-height:544px; overflow-y:auto; overflow-x:hidden;">       
        </div></td>                                                          
                            </tr>    
                            <tr>
                                <td colspan="6">
                                    <div class="Purchaseheader" >
                                      Special Test Detail
                                    </div>
                                </td>
                            </tr>                                                
                            <tr>
                                <td style="text-align: right">&nbsp;</td>
                                <td><b>Add Other Test </b>
                                    </td>
                                <td style="text-align: right">
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                                <td style="text-align: left"  colspan="2">&nbsp;</td>                            
                            </tr>                                                      
                            <tr class="trSpecialTest">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <input id="rblsearchtype_1" checked="checked" name="rblsearchtype" onclick="clearItem()" type="radio" value="1" /> <b>By Test Name</b>
                                    <input id="rblsearchtype_0" name="rblsearchtype" onclick="clearItem()" type="radio" value="0" /> <b>By Test Code</b>
                                    <input id="rblsearchtype_2" name="rblsearchtype" onclick="clearItem()" type="radio" value="2" /> <b>InBetween</b> </td>
                            </tr>
                            <tr class="trSpecialTest">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <input type="hidden" id="theHidden" />
                                    <input id="txtNewInvestigation" size="50"  /></td>
                            </tr>
                            <tr>
                                <td style="text-align: left"  >&nbsp;
                                </td>
                                 <td style="text-align: left"  >&nbsp;
                                </td>
                                 <td style="text-align: left"  >
                                      <div class="alertMsg" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
                                        <p id="errorMsg" style="color:white;padding:10px;font-weight:bold;">
                                        </p>
                                    </div>
                                </td>
                                 <td style="text-align: left"  colspan="3" >
                                     <b>Total Test: </b><span id="spnTestCount" style="font-weight: bold;">0</span>
                                </td>
                            </tr>
                            <tr class="trSpecialTest">
                                <td style="text-align: right"><b>Special Test :&nbsp;</b> </td>
                                <td colspan="5">
                                    
                             
<div id="divSpecialtest" style="width: 100%; height: 300px;">
                                   
                            <table id="tb_grdSpecialTest" style="border-collapse: collapse;display:none" class="table">
                                <thead>
                                <tr id="InvHeader" class="nodrop table">                                                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 20px;text-align: center">#</td>                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 460px; text-align: center">Test Name</td>
                                    <td class="GridViewHeaderStyle testRateLimit" style="width: 70px; text-align: center">Rate Limit</td>
                                    <td class="GridViewHeaderStyle specialRateReq" style="width: 104px; text-align: center"><span id="spnSpecialRate"> Special Rate Requested</span></td>
                                    <td class="GridViewHeaderStyle minSalesComm" style="width: 104px; text-align: center">Minimum Sales Commitment</td>                                    
                                    <td class="GridViewHeaderStyle salesDuration" style="width: 104px; text-align: center">Sales Duration (In Days)</td>
                                    <td class="GridViewHeaderStyle IntimationDays" style="width: 60px; text-align: center">Intimation Days </td>
                                    <td class="GridViewHeaderStyle TotalValue" style="width: 60px; text-align: center"><span id="spnTotalValue">Total Value</span> </td>
                                    <td style="display: none;"></td>
                                   
                                </tr>
                                    </thead>
                                <tbody>


                                </tbody>
                            </table>
                        </div>
                                </td>
                            </tr>    
                            
                              
                            <%--Start Marketing Campaign Test Detail--%>
                            <tr class="trMarketingCampaignTest" style="display:none">
                                <td colspan="6" style="text-align: left">
                            <div class="Purchaseheader" >
                                      Marketing Campaign Test Detail

 
                                    </div>     
                                    </td>
                                 </tr>                                
                            <tr class="trMarketingCampaignTest" style="display:none">
                                <td style="text-align: right">&nbsp;</td>
                                <td><b>Marketing Campaign Test </b>
                                    </td>
                                <td style="text-align: right">
                                    &nbsp;</td>
                                <td>
                                    &nbsp;</td>
                                <td style="text-align: left"  colspan="2">&nbsp;</td>                            
                            </tr>                                                      
                            <tr class="trMarketingCampaignTest" style="display:none">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <input id="rblMarketSearchtype_1" checked="checked" name="rblMarketSearchtype" onclick="clearMarketItem()" type="radio" value="1" /> <b>By Test Name</b>
                                    <input id="rblMarketSearchtype_2" name="rblMarketSearchtype" onclick="clearMarketItem()" type="radio" value="0" /> <b>By Test Code</b>
                                    <input id="rblMarketSearchtype_3" name="rblMarketSearchtype" onclick="clearMarketItem()" type="radio" value="2" /> <b>InBetween</b> </td>
                            </tr>
                            <tr class="trMarketingCampaignTest" style="display:none">
                                <td style="text-align: right">&nbsp;</td>
                                <td colspan="5">
                                    <input type="hidden" id="hdMarket" />
                                    <input id="txtMarketInvestigation" size="50"  /></td>
                            </tr>                           
                            <tr class="trMarketingCampaignTest" style="display:none">
                                <td style="text-align: right"><b>&nbsp;Campaign Test :&nbsp;</b> </td>
                                <td colspan="5">
                                   

                                    <div id="divMarketingTest" style="margin-top: 5px; max-height: 500px;  overflow-y: auto; overflow-x: hidden; width: 100%;">
                            <table id="tblMarketingTest" style="width: 98%; border-collapse: collapse;display:none">
                                <tr id="trMarketingTest" >                                                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 20px;text-align: center">#</td>                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 460px; text-align: center">Test Name</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">From Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">To Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">MRP(Rs.)</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Offer MRP</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">PCC Share(%)</td>
                                   
                                </tr>
                            </table>
                        </div>
                                </td>
                            </tr>        
                            
                          <%--End Marketing Campaign Test Detail--%>
              <tr class="trHLMPackage">
                                <td colspan="6" style="text-align: left">
                            <div class="Purchaseheader" >
                                      Add HLM Package

 
                                    </div>     
                                    </td>
                                 </tr>                
                             
                    
                                    
                  <tr class="trHLMPackage">
                      <td style="text-align:right">
                          <b> Package Name :&nbsp;</b>
                      </td>
                      <td>
                          
                        <asp:TextBox ID="txtHLMPackageName" runat="server" MaxLength="100"  Width="160px"></asp:TextBox>
                      </td>
                  </tr>
                  <tr class="trHLMPackage">
                      <td style="text-align:right">
                           &nbsp;
                      </td>
                      <td colspan="5">
                          
                                    <input id="rblHLMtype_1" checked="checked" name="rblHLMType" onclick="clearHLMItem()" type="radio" value="1" /> <b>By Test Name</b>
                                    <input id="rblHLMtype_2" name="rblHLMType" onclick="clearHLMItem()" type="radio" value="0" /> <b>By Test Code</b>
                                    <input id="rblHLMtype_3" name="rblHLMType" onclick="clearHLMItem()" type="radio" value="2" /> <b>InBetween</b> </td>
                    
                  </tr>
                  <tr class="trHLMPackage">
                      <td style="text-align:right">
                          <b> Item Name :&nbsp;</b>
                      </td>
                      <td colspan="5">
                            <input type="hidden" id="HLMHiddenItemID" />
                        <asp:TextBox ID="txtHLMItemName" runat="server" MaxLength="100" Width="320px"></asp:TextBox>
                      </td>
                  </tr>
                  
                      <tr class="trHLMPackage">
                                <td style="text-align: right">&nbsp;</td>
                                 <td colspan="5">
                                   

                                    <div id="divHLMItem" style="margin-top: 5px; max-height: 500px;  overflow-y: auto; overflow-x: hidden; width: 100%;">
                            <table id="tblHLMItemTest" style="width: 98%; border-collapse: collapse;display:none">
                                <tr id="InvHLMItemHeader" >                                                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 20px;text-align: center">#</td>                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Code</td>
                                    <td class="GridViewHeaderStyle" style="width: 460px; text-align: center">Test Name</td>                                    
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">MRP(Rs.)</td>                                  
                                </tr>
                            </table>
                                       
                        </div>
                                </td>
                            </tr>  
                  
              <tr class="trHLMPackage">
                  <td>&nbsp;</td>
                   <td><input type="button" id="btnAddPackage" onclick="addHLMPackage()" class="ItDoseButton" value="Add Package" /></td>
                  </tr>
                      <tr class="trHLMPackage">
                  <td>&nbsp;</td>
                          <td colspan="5">

                               <div id="divHLMPackage" style="margin-top: 5px; max-height: 500px;  overflow-y: auto; overflow-x: hidden; width: 100%;">
                            <table id="tblHLMPackageTest" style="width: 98%; border-collapse: collapse;display:none">
                                <tr id="trHLMPackageHeader" >                                                                                                       
                                    <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">&nbsp;</td>
                                    <td class="GridViewHeaderStyle" style="width: 460px; text-align: center">Package Name</td>                                    
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Test Wise MRP(Rs.)</td>
                                    <td class="GridViewHeaderStyle" style="width: 90px; text-align: center">Patient Rate</td> 
                                    <td class="GridViewHeaderStyle" style="width: 110px; text-align: center">Type</td>
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Net Amt.</td>  
                                    <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">View</td>                                  
                                </tr>
                            </table>
                                       
                        </div>


                              </td>
                          </tr>       
                                                             
                            <tr>
                                <td colspan="6" style="text-align: center">
                                    <input type="button" value="Save" class="searchbutton" id="btnSave" onclick="saveEnrolment(0)" style="font-weight: bold" />
                                    <input type="button" value="Approve" class="searchbutton" id="btnApprove" onclick="ApproveVerifyEnrolment(2)" style="font-weight: bold;display:none" />
                                    <input type="button" value="Verify" class="searchbutton" id="btnVerify" onclick="ApproveVerifyEnrolment(1)" style="font-weight: bold;display:none" />
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        var InvList = []; var marketInvList = [];
        jQuery(function () {

            if (jQuery.trim(jQuery("#lblEnrollID").text()) == "")
                getPaymentCon();

            if (jQuery.trim(jQuery("#lblIsView").text()) != "") {
                jQuery('#btnApprove,#btnSave,#btnVerify').hide();
                jQuery('#txtNewInvestigation').attr('disabled', 'disabled');
                jQuery('input[type=text],input[type=checkbox]').attr('disabled', 'disabled');

            }
            $("#tb_grdSpecialTest").tableHeadFixer({
                
            });

        });

        function getPaymentCon() {
            if (jQuery("#ddlPaymentMode").val() == "Cash") {
                jQuery("#txtMinCash").val('100').removeAttr('disabled');
                jQuery("#txtCreditLimit").val('0').attr('disabled', 'disabled');
            }
            else {
                jQuery("#txtMinCash").val('0').attr('disabled', 'disabled');
                jQuery("#txtCreditLimit").removeAttr('disabled');
            }
        }


    </script>
    <script type="text/javascript">
        jQuery(function () {

            if (jQuery.trim(jQuery("#lblEnrollID").text()) != "") {
                jQuery("#ddlType").val(jQuery("#lblTypeID").text());
                getSpecialTestLimit();
                bindEnrollSpecialTest(jQuery('#ddlType option:selected').text());

                jQuery("#btnSave").hide();
                if (jQuery('#ddlType option:selected').text() == "PCC")
                    getMarketingTest(jQuery.trim(jQuery("#lblEnrollID").text()));
                if (jQuery('#ddlType option:selected').text() == "HLM")
                    getHLMPackage(jQuery.trim(jQuery("#lblEnrollID").text()));
            }
            else {
                jQuery("#lblTypeID").text('');
            }
            selectPatientType();
        });


        function removeAddressDetail() {
            jQuery("#ddlBusinessZone").prop('selectedIndex', 0);
            jQuery("#ddlState option").remove();
            jQuery("#ddlHeadQuarter option").remove();
            jQuery("#ddlCity option").remove();
            jQuery("#ddlZone option").remove();
            jQuery("#ddlLocality option").remove();
        }
        function selectPatientType() {

            if (jQuery.trim(jQuery("#lblEnrollID").text()) == "") {
                jQuery("#txtName").val("".concat(jQuery("#ddlType option:selected").text(), " "));
                InvList = [];
            }
            if (jQuery("#ddlType option:selected").text() == "PUP") {
                jQuery("#ddlPanelGroup").val('3');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                if (jQuery.trim(jQuery("#lblEnrollID").text()) == "") {
                    bindSpecialTest('PUP');
                    jQuery("#txtMRPPercentage").show().val('');
                    jQuery("#chkOnlineLogin").prop('checked','checked');
                }
                else {
                    jQuery("#txtMRPPercentage").show()
                }
                jQuery("#chkOnlineLogin").show();
                jQuery(".addressDetail,#div_PCCGrouping,.trHLMPackage").hide();
                jQuery("#spnMRPPercentage").show().text('Disc. on MRP(%) : ');
                jQuery("#ddlTagProcessingLab option[value='0']").remove();
                jQuery(".trSpecialTest,#tr_HLM").show();
                jQuery("#ddlReferringRate").attr('disabled', 'disabled');
                jQuery("#ddlReferringRate").prop('selectedIndex', 0);
                jQuery("#tr_HLMMRP,.trMarketingCampaignTest").hide();
                jQuery("#tblMarketingTest tr:not(#trMarketingTest)").remove();
                jQuery('.clAddress,.clMobileNo,.clMinBusinessCommit,.clMRPPercentage,.clTagRegistrationLab').css('color', 'red');
                jQuery('.clBusinessZone,.clState,.clHeadQuarter,.clCity,.clCityZone,.clLocality').removeAttr('style');

            }
            else if (jQuery("#ddlType option:selected").text() == "HLM") {
                jQuery('.clBusinessZone,.clState,.clHeadQuarter,.clCity,.clCityZone,.clLocality,.clTagRegistrationLab').css('color', 'red');
                jQuery('.clAddress,.clMobileNo,.clMinBusinessCommit,.clMRPPercentage').removeAttr('style');
                jQuery("#ddlPanelGroup").val('4');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');

                jQuery("#tb_grdSpecialTest tr:not(#InvHeader)").remove();
                jQuery('#divSpecialtest,#spnMRPPercentage,#txtMRPPercentage').hide();
                jQuery("#txtMRPPercentage").val('0');
                if ($("#ddlTagProcessingLab option[value='0']").length == 0)
                    jQuery("#ddlTagProcessingLab option").eq(1).before($("<option></option>").val('0').html('Self'));

                jQuery(".addressDetail,.trSpecialTest").show();
                jQuery("#div_PCCGrouping,.trMarketingCampaignTest").hide();
                jQuery("#ddlReferringRate").prop('selectedIndex', 0);
                jQuery("#ddlReferringRate").attr('disabled', 'disabled');
                jQuery("#tr_HLM").hide(); jQuery("#tr_HLMMRP,.trHLMPackage").show();
                jQuery("#tblMarketingTest tr:not(#trMarketingTest)").remove();
                jQuery("#chkOnlineLogin").prop('checked', false);
                jQuery("#chkOnlineLogin").hide();
            }
            else if (jQuery("#ddlType option:selected").text() == "PCC") {
                jQuery('.clMinBusinessCommit,.clMRPPercentage,.clBusinessZone,.clState,.clHeadQuarter,.clCity,.clCityZone,.clLocality,.clTagRegistrationLab').css('color', 'red');
                jQuery("#ddlPanelGroup").val('1');
                jQuery("#ddlPanelGroup").attr('disabled', 'disabled');
                jQuery(".addressDetail,.trSpecialTest").show();
                if (jQuery.trim(jQuery("#lblEnrollID").text()) == "") {
                    // bindSpecialTest('PCC');
                    jQuery("#tb_grdSpecialTest tr:not(#InvHeader)").remove();
                    jQuery("#txtMRPPercentage").show().val('');
                    jQuery('#divSpecialtest').hide();
                   // bindPCCGrouping();
                }
                else {
                    jQuery("#txtMRPPercentage").show();
                   // bindEnrollPCCGrouping();
                }
                jQuery("#spnMRPPercentage").show().text('Share on MRP(%) : ');
                jQuery("#ddlTagProcessingLab option[value='0']").remove();
                jQuery("#ddlReferringRate").removeAttr('disabled');
                jQuery("#tr_HLM").show(); jQuery("#tr_HLMMRP,.trHLMPackage,.trMarketingCampaignTest").hide();
                jQuery("#chkOnlineLogin").prop('checked', false);
                jQuery("#chkOnlineLogin").hide();

            }
            else {
                jQuery('.clBusinessZone,.clState,.clHeadQuarter,.clCity,.clCityZone,.clLocality,.clTagRegistrationLab').css('color', 'red');
                jQuery("#ddlPanelGroup").prop('selectedIndex', 0).attr('disabled', false);
                jQuery("#tb_grdSpecialTest tr:not(#InvHeader)").remove();
                jQuery('#divSpecialtest,#spnMRPPercentage,#txtMRPPercentage').hide();
                jQuery("#txtMRPPercentage").val('0');
                if (jQuery("#ddlTagProcessingLab option[value='0']").length == 0)
                    jQuery("#ddlTagProcessingLab option").eq(1).before(jQuery("<option></option>").val('0').html('Self'));

                jQuery(".addressDetail").show();
                jQuery(".trSpecialTest,#div_PCCGrouping,.trMarketingCampaignTest").hide();
                jQuery("#ddlReferringRate").removeAttr('disabled');
                jQuery("#tr_HLM").hide(); jQuery("#tr_HLMMRP,.trHLMPackage").hide();
                jQuery("#tblMarketingTest tr:not(#trMarketingTest)").remove();
                jQuery("#chkOnlineLogin").prop('checked', false);
                jQuery("#chkOnlineLogin").hide();

            }
            if (jQuery.trim(jQuery("#lblEnrollID").text()) == "") {
                jQuery("#txtMinBusinessComm").val('');
            }
            if (jQuery("#ddlDesignation").val() != 0 && jQuery.trim(jQuery("#lblEnrollID").text()) == "") {
                if (jQuery("#ddlType option:selected").text() == "PUP" || jQuery("#ddlType option:selected").text() == "PCC") {
                    getSpecialTestLimit();
                }
            }
            if (jQuery.trim(jQuery("#lblEnrollID").text()) == "")
                removeAddressDetail();
        }
        function saveEnrolment(IsEnroll) {
            jQuery('#lblMsg').html('');
            jQuery('#lblIsApprove').text(IsEnroll);
            if (ValidateEnrolment() == "1") {
                return;
            }
            //jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var resultPanel = panelMaster();
            var resultEmployee = employeeCentre();
            var resultTestEnrolment = testEnrolment();
            var resultPCCGrouping = PCCTestGrouping();
            var resultCampaignTest = PCCMarketingCampaign();

            var resultHLMPackage = HLMPackage();
            if (resultTestEnrolment.length == 0 && (jQuery("#ddlType option:selected").text() == "PCC" || jQuery("#ddlType option:selected").text() == "PUP")) {
                showerrormsg('Select Special Test');

                jQuery.unblockUI();
                return;
            }
            jQuery.ajax({
                url: "EnrolmentMaster.aspx/saveEnrolment",
                data: JSON.stringify({ Panel: resultPanel, Employee: resultEmployee, TestEnrolment: resultTestEnrolment, PCCGrouping: resultPCCGrouping, MarketingCampaignTest: resultCampaignTest, HLMPackage: resultHLMPackage }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "1" && result.d != "2" ) {
                        showSaveErrorMsg(result.d);
                    }
                    else if (result.d == "2") {
                        showSaveErrorMsg("Name Already Exist");
                        jQuery("#txtName").focus();
                    }
                    
                    
                    else if (result.d == "1") {
                        showSaveErrorMsg("Record Saved Successfully");
                        clearform();
                    }
                    else {
                        alert('Error...');
                    }
                    jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    jQuery.unblockUI();
                }
            });

        }
        function ValidateEnrolment() {
            var con = 0;
            if (jQuery.trim(jQuery('#txtName').val()) == "") {
                showerrormsg('Enter Name');
                jQuery('#txtName').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#ddlDesignation').val()) == "0") {
                showerrormsg('Select Designation ');
                jQuery('#ddlDesignation').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#ddlName').val()) == "") {
                showerrormsg('Select Employee');
                jQuery('#ddlName').focus();
                con = 1;
                return con;
            }
            if (jQuery('#ddlType option:selected').text() == "PUP") {
                if (jQuery.trim(jQuery('#txtAddress').val()) == "") {
                    showerrormsg('Please Enter Address');
                    jQuery('#txtAddress').focus();
                    con = 1;
                    return con;

                }
                if ((jQuery.trim(jQuery("#txtLandline").val()) == "") && jQuery.trim(jQuery("#txtMobile").val()) == "") {
                    showerrormsg('Please Enter LandLine No. OR Mobile No.');
                    jQuery('#txtMobile').focus();
                    con = 1;
                    return con;
                }

                if (jQuery('#chkOnlineLogin').is(':checked') && jQuery.trim(jQuery('#txtEmailReport').val()) == "") {
                    showerrormsg('Please Enter Email Id(Report)');
                    jQuery('#txtEmailReport').focus();
                    con = 1;
                    return con;
                }
            }

            if (jQuery('#ddlType option:selected').text() != "PUP") {
                if (jQuery.trim(jQuery('#ddlBusinessZone').val()) == "0") {
                    showerrormsg('Please Select Business Zone');
                    jQuery('#ddlBusinessZone').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#ddlState').val()) == "0") {
                    showerrormsg('Please Select State');
                    jQuery('#ddlState').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#ddlHeadQuarter').val()) == "0") {
                    showerrormsg('Please Select HeadQuarter');
                    jQuery('#ddlHeadQuarter').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#ddlCity').val()) == "0") {
                    showerrormsg('Please Select City');
                    jQuery('#ddlCity').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#ddlZone').val()) == "0") {
                    showerrormsg('Please Select Zone');
                    jQuery('#ddlZone').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#ddlLocality').val()) == "0") {
                    showerrormsg('Please Select Locality');
                    jQuery('#ddlLocality').focus();
                    return;
                }
            }
            if (jQuery('#ddlType option:selected').text() == "HLM") {
                if (jQuery('#chkHLMOP').is(':checked')) {
                    if (jQuery.trim(jQuery('#txtHLMOPMRP').val()) == "") {
                        showerrormsg('Enter HLM OP Hike in MRP %');
                        jQuery('#txtHLMOPMRP').focus();
                        con = 1;
                        return con;
                    }
                    if (jQuery.trim(jQuery('#txtHLMOPClientShare').val()) == "") {
                        showerrormsg('Enter HLM OP Client SHARE %');
                        jQuery('#txtHLMOPClientShare').focus();
                        con = 1;
                        return con;
                    }
                }
                if (jQuery('#chkHLMIP').is(':checked')) {
                    if (jQuery.trim(jQuery('#txtHLMIPMRP').val()) == "") {
                        showerrormsg('Enter HLM IP Hike in MRP %');
                        jQuery('#txtHLMIPMRP').focus();
                        con = 1;
                        return con;
                    }
                    if (jQuery.trim(jQuery('#txtHLMIPClientShare').val()) == "") {
                        showerrormsg('Enter HLM IP Client SHARE %');
                        jQuery('#txtHLMIPClientShare').focus();
                        con = 1;
                        return con;
                    }
                }
                if (jQuery('#chkHLMICU').is(':checked')) {
                    if (jQuery.trim(jQuery('#txtHLMICUMRP').val()) == "") {
                        showerrormsg('Enter HLM ICU Hike in MRP %');
                        jQuery('#txtHLMICUMRP').focus();
                        con = 1;
                        return con;
                    }
                    if (jQuery.trim(jQuery('#txtHLMICUClientShare').val()) == "") {
                        showerrormsg('Enter HLM ICU Client SHARE %');
                        jQuery('#txtHLMICUClientShare').focus();
                        con = 1;
                        return con;
                    }
                }
            }

            if (((jQuery('#ddlType option:selected').text() == "PCC") || (jQuery('#ddlType option:selected').text() == "PUP")) && (jQuery('#txtMRPPercentage').val() == "")) {
                if (jQuery('#ddlType option:selected').text() == "PCC")
                    showerrormsg('Enter Share on MRP(%)');
                else
                    showerrormsg('Enter Disc. on MRP(%)');
                jQuery('#txtMRPPercentage').focus();
                con = 1;
                return con;
            }
            if (jQuery('#ddlTagProcessingLab option:selected').text() == "Select") {
                showerrormsg('Select TagProcessing Lab');
                jQuery('#ddlTagProcessingLab').focus();
                con = 1;
                return con;
            }
            var HLMRate = 0;
            var specialRateCount = 0; var SpecialRate = 0; var MinimumSales = 0; var SalesDuration = 0; var IntimationDays = 0; var checkedCount = 1; var RateLimit = 0; var validIntimationDays = 0;
            if (jQuery("#ddlType option:selected").text() == "PCC" || jQuery("#ddlType option:selected").text() == "PUP") {
                jQuery("#tb_grdSpecialTest tr").each(function () {
                    var id = jQuery(this).attr("id");

                    if (id != "InvHeader") {
                       
                        if ((!jQuery(this).closest('tr').find("#chkSelect").is(':visible') || jQuery(this).closest('tr').find("#chkSelect").is(':checked') || jQuery(this).closest('tr').find(".img_Delete").is(':visible')) && jQuery(this).closest('tr').find("#txtSpecialRate").is(':visible') && jQuery.trim(jQuery(this).closest('tr').find("#txtSpecialRate").val()) == "") {
                            showSaveErrorMsg('Enter Special Rate Req.');
                            $(this).closest('tr').find("#txtSpecialRate").focus();
                            SpecialRate = 1;
                            checkedCount += 1;
                            con = 1;
                            return con;
                        }
                        if ((!jQuery(this).closest('tr').find("#chkSelect").is(':visible') || jQuery(this).closest('tr').find("#chkSelect").is(':checked') || jQuery(this).closest('tr').find(".img_Delete").is(':visible')) && jQuery(this).closest('tr').find("#txtMinimumSales").is(':visible') && jQuery.trim(jQuery(this).closest('tr').find("#txtMinimumSales").val()) == "") {
                            showSaveErrorMsg('Enter Min. Sales Comm.');
                            $(this).closest('tr').find("#txtMinimumSales").focus();
                            MinimumSales = 1;
                            checkedCount += 1;
                            con = 1;
                            return con;
                        }
                        if ((!jQuery(this).closest('tr').find("#chkSelect").is(':visible') || jQuery(this).closest('tr').find("#chkSelect").is(':checked') || jQuery(this).closest('tr').find(".img_Delete").is(':visible')) && jQuery(this).closest('tr').find("#txtSalesDuration").is(':visible') && jQuery.trim(jQuery(this).closest('tr').find("#txtSalesDuration").val()) == "") {
                            showSaveErrorMsg('Enter Sales Duration(Days)');
                            jQuery(this).closest('tr').find("#txtSalesDuration").focus();
                            SalesDuration = 1;
                            checkedCount += 1;
                            con = 1;
                            return con;
                        }
                        if ((!jQuery(this).closest('tr').find("#chkSelect").is(':visible') || jQuery(this).closest('tr').find("#chkSelect").is(':checked') || jQuery(this).closest('tr').find(".img_Delete").is(':visible')) && jQuery(this).closest('tr').find("#txtIntimationDays").is(':visible') && jQuery.trim(jQuery(this).closest('tr').find("#txtIntimationDays").val()) == "") {
                            showSaveErrorMsg('Enter Intimation Days');
                            jQuery(this).closest('tr').find("#txtIntimationDays").focus();
                            IntimationDays = 1;
                            checkedCount += 1;
                            con = 1;
                            return con;
                        }

                        if ((parseFloat(jQuery.trim(jQuery(this).closest('tr').find("#txtIntimationDays").val()))) > parseFloat(jQuery.trim(jQuery(this).closest('tr').find("#txtSalesDuration").val()))) {
                            showSaveErrorMsg('Enter Valid Intimation Days');
                            jQuery(this).closest('tr').find("#txtIntimationDays").focus();
                            validIntimationDays = 1;
                            con = 1;
                            return con;
                        }
                    }
                });
                if (SpecialRate == 1) {
                    showSaveErrorMsg('Enter Special Rate Req.');
                    con = 1;
                    return con;
                }
                if (MinimumSales == 1) {
                    showSaveErrorMsg('Enter Min. Sales Comm.');
                    con = 1;
                    return con;
                }
                if (SalesDuration == 1) {
                    showSaveErrorMsg('Enter Sales Duration(Days)');
                    con = 1;
                    return con;
                }
                if (IntimationDays == 1) {
                    showSaveErrorMsg('Enter Intimation Days');
                    con = 1;
                    return con;
                }
                if (validIntimationDays == 1) {
                    showSaveErrorMsg('Enter Valid Intimation Days');
                    con = 1;
                    return con;
                }
                if (checkedCount > 1) {
                    showSaveErrorMsg('Select Special Test');
                    con = 1;
                    return con;
                }
                if (jQuery("#txtMinBusinessComm").val() == "") {
                    jQuery("#txtMinBusinessComm").focus();
                    showerrormsg('Enter Min. Business Commit.');
                    con = 1;
                    return con;
                }
            }
            var PCCGrouping = 0;
            if (jQuery("#ddlType option:selected").text() == "PCC") {
                jQuery("#tb_grdPCCGrouping tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "PCCGroupingHeader") {
                        if ($rowid.find("#chkPCCGrouping").is(':checked') && $rowid.find("#txtPCCGroupShare").val() == "") {
                            PCCGrouping = 1;
                            $rowid.find("#txtPCCGroupShare").focus();
                            con = 1;
                            return con;
                        }
                    }
                });
            }
            else if (jQuery("#ddlType option:selected").text() == "HLM") {

                jQuery("#tb_grdSpecialTest  tr").each(function () {
                    var id = jQuery(this).attr("id");

                    if (id != "InvHeader") {
                        if ((!jQuery(this).closest('tr').find("#chkSelect").is(':visible') || jQuery(this).closest('tr').find("#chkSelect").is(':checked')) && jQuery(this).closest('tr').find("#txtSpecialRate").is(':visible') && jQuery.trim(jQuery(this).closest('tr').find("#txtSpecialRate").val()) == "") {
                            showSaveErrorMsg('Enter Rate ');
                            jQuery(this).closest('tr').find("#txtSpecialRate").focus();
                            HLMRate = 1;
                            con = 1;
                            return con;
                        }
                    }
                });

            }
            if (PCCGrouping == 1) {
                showSaveErrorMsg('Enter PCC Group Share');
                con = 1;
                return con;
            }
            if (HLMRate == 1) {
                showSaveErrorMsg('Enter HLM Item Rate');
                con = 1;
                return con;
            }
            var PCCMarketingCom = 0;
            if (jQuery("#ddlType option:selected").text() == "PCC") {
                
                jQuery("#tblMarketingTest tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "trMarketingTest") {
                        if ($rowid.find(".img_MarketDelete").is(':visible')) {
                            var MarketItemID = $rowid.find("#tdMarketItemID").text();

                            if ($rowid.find("#txtFromDate_" + MarketItemID).val() == "") {
                                showSaveErrorMsg('Enter Marketing Campaign From Date ');
                                $rowid.find("#txtFromDate_" + MarketItemID).focus();
                                PCCMarketingCom = 1;
                              
                                return PCCMarketingCom;
                            }
                            if ($rowid.find("#txtToDate_" + MarketItemID).val() == "") {
                                showSaveErrorMsg('Enter Marketing Campaign To Date ');
                                $rowid.find("#txtFromDate_" + MarketItemID).focus();
                                PCCMarketingCom = 1;
                                return PCCMarketingCom;
                            }
                            if ($rowid.find("#txtOfferMRP").val() == "") {
                                showSaveErrorMsg('Enter Marketing Campaign Offer MRP ');
                                j$rowid.find("#txtOfferMRP").focus();
                                PCCMarketingCom = 1;
                                return PCCMarketingCom;
                            }
                            if ($rowid.find("#txtMarketPCCShare").val() == "") {
                                showSaveErrorMsg('Enter Marketing Campaign PCCShare ');
                                $rowid.find("#txtMarketPCCShare").focus();
                                PCCMarketingCom = 1;
                                return PCCMarketingCom;
                            }
                        }

                    }

                });

            }
            if (PCCMarketingCom == "1") {
                con = 1;
                return con;
            }
            var HLMPackage = 0;
            if (jQuery("#ddlType option:selected").text() == "HLM") {
                jQuery("#tblHLMPackageTest tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "trHLMPackageHeader") {
                       
                        if ($rowid.find("#txtHLMPatientRate").val() == "") {
                            showSaveErrorMsg('Enter Patient Rate ');
                            $rowid.find("#txtHLMPatientRate").focus();
                            HLMPackage = 1;
                            return HLMPackage;
                        }
                        
                        if (($rowid.find("#rbHLMPackageNetPrice").is(':checked')) && ($rowid.find("#txtPackageNetAmt").val() == "")) {
                            showSaveErrorMsg('Enter Net Amount ');
                            $rowid.find("#txtPackageNetAmt").focus();
                            HLMPackage = 1;
                            return HLMPackage;
                        }
                        
                    }

                });
            }
            if (HLMPackage == "1") {
                con = 1;
                return con;
            }
            
            return con;
        }
    </script>
    <script type="text/javascript">

        function panelMaster() {
            var dataPanel = new Array();
            var objPanel = new Object();
            objPanel.TypeID = jQuery('#ddlType').val();
            objPanel.TypeName = jQuery('#ddlType option:selected').text();
            objPanel.PanelGroup = jQuery("#ddlPanelGroup option:selected").text();
            objPanel.PanelGroupID = jQuery("#ddlPanelGroup").val();
            objPanel.Company_Name = jQuery.trim(jQuery("#txtName").val());
            objPanel.Add1 = jQuery.trim(jQuery("#txtAddress").val());
            objPanel.IsActive = jQuery("#isActive").is(':checked') ? 1 : 0;
            objPanel.Mobile = jQuery("#txtMobile").val();
            objPanel.Phone = jQuery("#txtLandline").val();
            objPanel.Payment_Mode = jQuery.trim(jQuery("#ddlPaymentMode").val());
            objPanel.PrintAtCentre = jQuery("#ddlPrintAtCentre").val();
            if (jQuery("#ddlType option:selected").text() == "PCC" || jQuery("#ddlType option:selected").text() == "PUP") {
                objPanel.SharePercentage = jQuery.trim(jQuery("#txtMRPPercentage").val());
            }
            else {
                objPanel.SharePercentage = 0;
            }
            objPanel.EmailID = jQuery.trim(jQuery("#txtEmailInvoice").val());
            objPanel.EmailIDReport = jQuery("#txtEmailReport").val();
            objPanel.ReportDispatchMode = jQuery("#ddlReportDispatchMode").val();
            objPanel.GSTTin = jQuery("#txtGSTTIN").val();
            objPanel.InvoiceBillingCycle = jQuery("#ddlInvoiceBillingCycle").val();
            objPanel.InvoiceTo = jQuery("#ddlInvoiceTo").val();
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
            if (jQuery('#ddlType option:selected').text() == "PUP")
                objPanel.PanelUserID = jQuery.trim(jQuery("#txtEmailReport").val());
            else
                objPanel.PanelUserID = jQuery.trim(jQuery("#txtOnlineUserName").val());
            objPanel.PanelPassword = jQuery("#txtOnlinePassword").val();
            objPanel.TagProcessingLabID = jQuery("#ddlTagProcessingLab").val();
            if (jQuery("#ddlTagProcessingLab option:selected").text() == "Self")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else if (jQuery("#ddlTagProcessingLab").val() != "0")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else
                objPanel.TagProcessingLab = "";
            objPanel.CreditLimit = jQuery.trim(jQuery("#txtCreditLimit").val());
            if (jQuery("#txtMinBusinessComm").val() != "")
                objPanel.MinBusinessCommitment = jQuery("#txtMinBusinessComm").val();
            else
                objPanel.MinBusinessCommitment = 0;

            objPanel.ReferenceCode = jQuery("#ddlReferringRate").val();
            objPanel.ReferenceCodeOPD = jQuery("#ddlReferringRate").val();

            if (jQuery("#txtMinCash").val() != "")
                objPanel.MinBalReceive = jQuery("#txtMinCash").val();
            else
                objPanel.MinBalReceive = 0;
            objPanel.SavingType = "FOCO";
            objPanel.Commission = 0;
            objPanel.isServiceTax = 0;

            objPanel.SecurityDeposit = 0;
            if (jQuery.trim(jQuery("#lblPanelID").text()) != "")
                objPanel.Panel_ID = jQuery.trim(jQuery("#lblPanelID").text());
            else
                objPanel.Panel_ID = 0;
            objPanel.DesignationID = jQuery("#ddlDesignation").val().split('#')[0];
            objPanel.EmployeeID = jQuery("#ddlName").val().split('#')[0];
            objPanel.SequenceNo = jQuery("#ddlName").val().split('#')[2];

            objPanel.AttachedFileName = $('#lblFileName').text();
            if (jQuery("#lblEnrollID").text() != "") {
                objPanel.EnrollID = jQuery("#lblEnrollID").text();
            }
            else {
                objPanel.EnrollID = "";
            }
            objPanel.IsApprove = jQuery("#lblIsApprove").text();
            if (jQuery("#ddlType option:selected").text() != "PUP") {
                objPanel.BusinessZoneID = jQuery.trim(jQuery("#ddlBusinessZone").val());
                objPanel.StateID = jQuery.trim(jQuery("#ddlState").val());
                objPanel.HeadQuarterID = jQuery.trim(jQuery("#ddlHeadQuarter").val());
                objPanel.CityID = jQuery.trim(jQuery("#ddlCity").val());
                objPanel.CityZoneID = jQuery.trim(jQuery("#ddlZone").val());
                objPanel.LocalityID = jQuery.trim(jQuery("#ddlLocality").val());
            }
            else {
                objPanel.BusinessZoneID = 0;
                objPanel.StateID = 0;
                objPanel.HeadQuarterID = 0;
                objPanel.CityID = 0;
                objPanel.CityZoneID = 0;
                objPanel.LocalityID = 0;
            }
            objPanel.AAALogo = jQuery("#chkAAALogo").is(':checked') ? 1 : 0;
            objPanel.OnLineLoginRequired = jQuery("#chkOnlineLogin").is(':checked') ? 1 : 0;

            if (jQuery("#ddlType option:selected").text() == "HLM") {
                objPanel.IsHLMOP = jQuery("#chkHLMOP").is(':checked') ? 1 : 0;

                objPanel.IsHLMIP = jQuery("#chkHLMIP").is(':checked') ? 1 : 0;
                objPanel.IsHLMICU = jQuery("#chkHLMICU").is(':checked') ? 1 : 0;
                objPanel.HLMOPHikeInMRP = jQuery.trim(jQuery("#txtHLMOPMRP").val());
                objPanel.HLMOPClientShare = jQuery.trim(jQuery("#txtHLMOPClientShare").val());
                objPanel.HLMOPPaymentMode = jQuery.trim(jQuery("#ddlHLMOPPaymentMode").val());
                objPanel.HLMOPPatientPayTo = jQuery('#rblHLMOPPatientPayTo input[type=radio]:checked').val();


                objPanel.HLMIPHikeInMRP = jQuery.trim(jQuery("#txtHLMIPMRP").val());
                objPanel.HLMIPClientShare = jQuery.trim(jQuery("#txtHLMIPClientShare").val());
                objPanel.HLMIPPaymentMode = jQuery.trim(jQuery("#ddlHLMIPPaymentMode").val());
                objPanel.HLMIPPatientPayTo = jQuery('#rblHLMIPPatientPayTo input[type=radio]:checked').val();

                objPanel.HLMICUHikeInMRP = jQuery.trim(jQuery("#txtHLMICUMRP").val());
                objPanel.HLMICUClientShare = jQuery.trim(jQuery("#txtHLMICUClientShare").val());
                objPanel.HLMICUPaymentMode = jQuery.trim(jQuery("#ddlHLMICUPaymentMode").val());
                objPanel.HLMICUPatientPayTo = jQuery('#rblHLMICUPatientPayTo input[type=radio]:checked').val();

            }
            else {
                objPanel.IsHLMOP = 0;
                objPanel.IsHLMIP = 0;
                objPanel.IsHLMICU = 0;

            }

            objPanel.InvoiceDisplayName = jQuery('#txtInvoiceDisplayName').val();
            objPanel.InvoiceDisplayAddress = jQuery('#txtInvoiceDisplayAddress').val();

            dataPanel.push(objPanel);
            return dataPanel;
        }

        function employeeCentre() {
            var dataEmployee = new Array();
            var objEmployee = new Object();
            objEmployee.DesignationID = jQuery("#ddlDesignation").val().split('#')[0];
            objEmployee.Employee_ID = jQuery("#ddlName").val().split('#')[0];
            objEmployee.SequenceNo = jQuery("#ddlName").val().split('#')[2];
            if (jQuery("#lblEnrollID").text() != "")
                objEmployee.IsDirectApprovalPending = jQuery("#lblIsDirectApprovalPending").text();
            else
                objEmployee.IsDirectApprovalPending = 0;
            objEmployee.IsDirectApprove = jQuery("#ddlDesignation").val().split('#')[3];
            if (jQuery("#lblIsApprove").text() == "1") {
                objEmployee.IsVerified = 1;
                objEmployee.IsApproved = 0;
            }
            else if (jQuery("#lblIsApprove").text() == "1") {
                objEmployee.IsVerified = 1;
                objEmployee.IsApproved = 1;
            }
            else {
                objEmployee.IsVerified = 0;
                objEmployee.IsApproved = 0;
            }
            objEmployee.EmployeeEmail = jQuery("#ddlName").val().split('#')[3];
            dataEmployee.push(objEmployee);
            objEmployee = new Object();
            jQuery("#tbSelected tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "salesHead") {
                    objEmployee.DesignationID = jQuery.trim($rowid.find("#spnDesignationID").text());
                    objEmployee.Employee_ID = jQuery.trim($rowid.find("#spnEmployee_ID").text());
                    objEmployee.SequenceNo = jQuery.trim($rowid.find("#spnSequenceNo").text());
                    objEmployee.IsDirectApprove = jQuery.trim($rowid.find("#spnIsDirectApprove").text());
                    objEmployee.EmployeeEmail = jQuery.trim($rowid.find("#spnEmployeeEmail").text());
                    objEmployee.IsVerified = 0;
                    objEmployee.IsApproved = 0;
                    dataEmployee.push(objEmployee);
                    objEmployee = new Object();
                }
            });
            return dataEmployee;
        }
        function testEnrolment() {
            var dataSpecialTest = new Array();
            var objSpecialTest = new Object();
            var Priority = 0;
            jQuery("#tb_grdSpecialTest tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");

                if (id != "InvHeader") {

                    // if (!$rowid.find("#chkSelect").is(':checked') || $rowid.find("#chkSelect").is(':visible')) {
                    if ($rowid.find("#chkSelect").is(':checked') || $rowid.find(".img_Delete").is(':visible')) {
                        Priority += 1;
                        objSpecialTest.SpecialTestID = jQuery.trim($rowid.find("#tdItemID").text());
                        objSpecialTest.EntryType = jQuery("#ddlType option:selected").text();
                        objSpecialTest.IsNewTest = jQuery.trim($rowid.find("#tdIsNewTest").text());

                        if (jQuery(this).closest('tr').find("#txtSpecialRate").is(':visible'))
                            objSpecialTest.SpecialTestRate = jQuery.trim($rowid.find("#txtSpecialRate").val());
                        else
                            objSpecialTest.SpecialTestRate = 0;


                        if (jQuery(this).closest('tr').find("#txtMinimumSales").is(':visible'))
                            objSpecialTest.MinimumSales = jQuery.trim($rowid.find("#txtMinimumSales").val());
                        else
                            objSpecialTest.MinimumSales = 0;

                        if (jQuery(this).closest('tr').find("#txtSalesDuration").is(':visible'))
                            objSpecialTest.SalesDuration = jQuery.trim($rowid.find("#txtSalesDuration").val());
                        else
                            objSpecialTest.SalesDuration = 0;

                        if (jQuery(this).closest('tr').find("#txtIntimationDays").is(':visible')) {
                            objSpecialTest.IntimationDays = jQuery.trim($rowid.find("#txtIntimationDays").val());
                        }
                        else {
                            objSpecialTest.IntimationDays = 0;
                        }
                        if (jQuery("#ddlType option:selected").text() == "PUP" && jQuery.trim($rowid.find("#tdIsNewTest").text()) == "0") {
                            objSpecialTest.Rate = jQuery.trim($rowid.find("#tdTestRate").text());
                        }
                       else if (jQuery("#ddlType option:selected").text() == "HLM") {
                            objSpecialTest.Rate = jQuery.trim($rowid.find("#tdTestRate").text());
                        }
                        else {
                            objSpecialTest.Rate = 0;
                        }


                        // objSpecialTest.Rate = jQuery.trim($rowid.find("#txtSpecialRate").val());
                        objSpecialTest.Priority = parseInt(Priority);
                        if (jQuery("#lblEnrollID").text() == "" && jQuery("#ddlType option:selected").text() == "PUP" && jQuery.trim($rowid.find("#tdIsNewTest").text() == 0)) {
                            var TestRate = jQuery.trim($rowid.find("#tdTestRate").text());

                            if (parseFloat(jQuery.trim($rowid.find("#txtSpecialRate").val())) < (parseFloat(TestRate)) || (parseFloat(jQuery(".chk_Select:checked").length) > (parseInt(jQuery("#spnSpecialTestLimit").text())))) {
                                objSpecialTest.IsVerified = 0;
                            }
                            else {
                                objSpecialTest.IsVerified = 1;
                            }
                        }
                        else {
                            objSpecialTest.IsVerified = 0;
                        }

                        if (jQuery("#ddlType option:selected").text() == "HLM") {

                            objSpecialTest.HLMPrice = $rowid.find("input[name=HLMPrice_" + jQuery.trim($rowid.find("#tdItemID").text()) + "]:checked").val();
                        }
                        else {
                            objSpecialTest.HLMPrice = "";
                        }
                        dataSpecialTest.push(objSpecialTest);
                        objSpecialTest = new Object();
                    }
                }
            });
            return dataSpecialTest;
        }
        function PCCTestGrouping() {
            var dataPCCGrouping = new Array();
            var objPCCGrouping = new Object();
            if (jQuery("#ddlType option:selected").text() == "PCC") {
                jQuery("#tb_grdPCCGrouping tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "PCCGroupingHeader") {
                        if ($rowid.find("#chkPCCGrouping").is(':checked')) {
                            objPCCGrouping.GroupID = $rowid.find("#tdGroupID").text();
                            objPCCGrouping.GroupShare = $rowid.find("#txtPCCGroupShare").val();

                            dataPCCGrouping.push(objPCCGrouping);
                            objPCCGrouping = new Object();
                        }
                    }
                });
            }
            return dataPCCGrouping;
        }
    </script>
    <script type="text/javascript">
        function chkMinCash() {
            if (jQuery.trim($("#txtMinCash").val()) != "") {
                if (jQuery("#txtMinCash").val() > 100) {
                    showerrormsg('Please Enter Valid Percentage');
                    jQuery("#txtMinCash").val('0');
                }
            }
        }
        jQuery('#txtName').change(function () {
            jQuery.ajax({
                url: "EnrolmentMaster.aspx/checkesixts",
                data: '{"companyName":"' + jQuery(this).val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    if (data.d == 1) {
                        jQuery('#lblMsg').html('Name already exists in your system !.');
                    }
                    else {
                        jQuery('#lblMsg').html('');
                    }
                }
            });
        });
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
        function bindEmployee() {
            if (jQuery("#ddlDesignation").val() != 0) {
                PageMethods.bindEmployee(jQuery("#ddlDesignation").val().split('#')[0], onSucessEmp, onFailureEmp);
            }
            else {
                jQuery("#ddlName option").remove();
            }
            jQuery("#tbSelected tr:not(#salesHead)").remove();
            bindSpecialTest(jQuery('#ddlType option:selected').text());
        }
        function onSucessEmp(result) {
            var empData = jQuery.parseJSON(result);
            jQuery("#ddlName option").remove();
            if (empData != null) {
                jQuery('#ddlName').append($("<option></option>").val('0').html('Select'));
                for (var a = 0; a <= empData.length - 1; a++) {
                    jQuery('#ddlName').append($("<option></option>").val(empData[a].Employee_ID).html(empData[a].EmpName));
                }
                jQuery('#ddlName').val(<%=Session["ID"].ToString()%>);
            }
        }
        function onFailureEmp(result) {

        }
        function bindSalesHierarchy() {
            jQuery("#tbSelected tr:not(#salesHead)").remove();
            if (jQuery("#ddlName").val() != 0) {
                // jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                PageMethods.bindSalesHierarchy(jQuery("#ddlName").val().split('#')[0], $("#ddlName").val().split('#')[1], jQuery("#ddlName").val().split('#')[2], jQuery("#lblEnrollID").text(), onSucessSalesHierarchy, onFailureSalesHierarchy)
                //   jQuery.unblockUI();
            }
            else {
                //  jQuery("#ddlName option").remove();
            }
        }
        function onSucessSalesHierarchy(result) {
            var SalesData = jQuery.parseJSON(result);

            if (SalesData != null) {
                if (jQuery('#tbSelected tr').length > 0)
                    jQuery('#tbSelected').css('display', 'block');
                if (jQuery('#lblEnrollID').text() != "") {
                    jQuery('.EnrollVerified').show();
                }
                for (var i = 0; i < SalesData.length; i++) {
                    var appendText = [];
                    appendText.push("<tr >");
                    appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + (i + 1) + '</td>');
                    appendText.push('<td class="GridViewLabItemStyle"><span id="DesignationName">' + SalesData[i].DesignationName + '</span><span id="spnDesignationID" style="display:none">' + SalesData[i].DesignationID + '</span><span id="spnIsDirectApprove" style="display:none">' + SalesData[i].IsDirectApprove + '</span><span id="spnEmployee_ID" style="display:none">' + SalesData[i].Employee_ID + '</span><span id="spnSequenceNo" style="display:none">' + SalesData[i].SequenceNo + '</span> </td>');
                    appendText.push('<td class="GridViewLabItemStyle" ><span id="EmpName">' + SalesData[i].EmpName + '</span></td>');
                    if (jQuery('#lblEnrollID').text() != "") {

                        appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + SalesData[i].CreatedDate + '</td>');

                        appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + SalesData[i].IsVerified + '</td>');
                        appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + SalesData[i].VerifiedDate + '</td>');
                        appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + SalesData[i].IsApproved + '</td>');
                        appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">' + SalesData[i].ApprovedDate + '</td>');
                    }
                    appendText.push('<td class="GridViewLabItemStyle" style="display:none" ><span id="spnEmployeeEmail">' + SalesData[i].Email + '</span></td>');
                    appendText.push("</tr>");
                    appendText = appendText.join(" ");
                    jQuery('#tbSelected').append(appendText);
                }
            }
        }
        function onFailureSalesHierarchy() {
            jQuery.unblockUI();
        }
        function bindSpecialTest(type) {
            jQuery("#tb_grdSpecialTest tr:not(#InvHeader)").remove();
            if ((type == "PUP") && (jQuery("#ddlDesignation").val() != 0)) {
                PageMethods.bindSpecialTest(type, jQuery("#ddlDesignation").val().split('#')[0], onSucessSpecialTest, onFailureSpecialTest);
            }
            else {
                jQuery('#divSpecialtest').hide();
            }
        }
        function onSucessSpecialTest(result) {
            specialTest = jQuery.parseJSON(result);
            hideShowHeader();
            jQuery('#tb_grdSpecialTest').css('display', 'block');

            if (specialTest != null) {

                for (var i = 0; i < specialTest.length; i++) {
                    InvList.push(specialTest[i].ItemID);

                    var appendText = [];

                    appendText.push("<tr id='" + specialTest[i].ItemID + "' class='GridViewItemStyle' >");
                    appendText.push('<td class="inv" id=' + specialTest[i].ItemID + ' style="text-align: center"> ');
                    appendText.push(' <input type="checkbox" id="chkSelect" class="chk_Select" onclick="chkSpecialTest(this)"  ');
                    if (specialTest[i].IsCheck == "1")
                        appendText.push(' checked="checked" ');
                    appendText.push('/></td>');
                    appendText.push('<td id="tdTestCode" style="font-weight:bold;">' + specialTest[i].TestCode + '</td>');
                    appendText.push('<td id="tdItemName" style="font-weight:bold;">' + specialTest[i].TestName + '</td>');

                    if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                        appendText.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;"> ' + specialTest[i].TestRate + '</td>');
                    }
                    else {
                        appendText.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;display:none"> ' + specialTest[i].TestRate + '</td>');
                    }
                    appendText.push('<td id="tdSpecialRate" style="text-align: center"> ');
                    appendText.push(" <input type='text' style='width:70px;' id='txtSpecialRate' value='" + specialTest[i].Rate + "'  onchange='checkRateLimit(this);' onkeypress='return checkNumeric(event,this);' maxlength='6'/></td>");
                    appendText.push('<td id="tdIsNewTest" style="font-weight:bold;display:none" >0</td>');
                    appendText.push('<td id="tdItemID" style="font-weight:bold;display:none">' + specialTest[i].ItemID + '</td>');
                    appendText.push("</tr>");
                    appendText = appendText.join(" ");
                    jQuery('#tb_grdSpecialTest').append(appendText);
                   
                }

                jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));


                jQuery('#divSpecialtest').show();

                jQuery('#tb_grdSpecialTest').tableDnD({
                    onDragClass: "myDragClass",

                    onDragStart: function (table, row) {
                    },
                    dragHandle: ".dragHandle"

                });
            }
            else {
                jQuery('#divSpecialtest').hide();
            }
        }
        function onFailureSpecialTest() {

        }
        function chkAll(rowID) {
            if (jQuery(rowID).is(':checked'))
                jQuery(".chk_Select").prop('checked', 'checked');
            else
                jQuery(".chk_Select").prop('checked', false);
        }
        function chngcurmove() {
            document.body.style.cursor = 'move';
        }
    </script>
    <script id="tb_SpecialTest" type="text/html">
    <table class="tbClSpecialtest" cellspacing="0" rules="all" border="1" id="tb_grdSpecialTest1"
    style="width:720px;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No. <input type="checkbox" class="chkAll" onclick="chkAll(this)" style="display:none" /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Test Code</th>                     
            <th class="GridViewHeaderStyle" scope="col" style="width:440px;">Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:center">Rate Limit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:center">Rate</th>
		</tr>
             </thead>
        <#
        var dataLength=specialTest.length;
       
        var objRow;           
        for(var j=0;j<dataLength;j++)
        {
        objRow = specialTest[j];
        #>
                    <tr id="<#=j+1#>" >
                    <td class="GridViewLabItemStyle"><#=j+1#>
                        <input type="checkbox" id="chkSelect" class="chk_Select" onclick="chkSpecialTest(this)"  
                            <#
                            if(objRow.IsCheck=="1")
                            {#>
                        checked="checked"
                        <#}
                            #>                            
                          />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdTestCode" style="width:80px;" onmouseover="chngcurmove()"><#=objRow.TestCode#></td>
                    <td class="GridViewLabItemStyle" id="tdTestName" style="width:440px;" onmouseover="chngcurmove()"><#=objRow.TestName#></td>
                        <td class="GridViewLabItemStyle" id="tdTestRate" style="width:80px;text-align:right" onmouseover="chngcurmove()"><#=objRow.TestRate#></td>
                        <td class="GridViewLabItemStyle" id="tdRate" style="width:80px;" onmouseover="chngcurmove()">
                            <input type="text" style="width:80px" id="txtSpecialRate" autocomplete="off" onchange="checkRateLimit(this)" onkeypress="return checkSecondDecimal(event,this)"                                                                                          
                            value="<#=objRow.Rate#>" 
                           />
                        </td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="display:none"><#=objRow.ItemID#></td>                    
                    </tr>
        <#}
        #>       
     </table>
    </script>
    <script type="text/javascript">
        var SpecialTestLimit = "";
        var DiscountOnMRP = "";
        function getSpecialTestLimit() {
            if (jQuery("#lblEnrollID").text() == "") {
                jQuery("#txtMinBusinessComm").val('');
                jQuery("#spnSpecialTestLimit").text('0');
            }
            SpecialTestLimit = ""; DiscountOnMRP = "";
            if ((jQuery("#ddlDesignation").val() != 0) && (jQuery("#lblTypeName").text() != "HLM")) {

                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/getSpecialTestLimit",
                    data: '{ designationID: "' + jQuery("#ddlDesignation").val().split('#')[0] + '",Type: "' + jQuery("#ddlType option:selected").text() + '"}',
                    type: "POST",
                    async: false,
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d != "") {
                            SpecialTestLimit = jQuery.parseJSON(result.d);
                        }
                        else {
                            SpecialTestLimit = "";
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/getDiscountOnMRP",
                    data: '{ designationID: "' + jQuery("#ddlDesignation").val().split('#')[0] + '",Type: "' + jQuery("#ddlType option:selected").text() + '"}',
                    type: "POST",
                    async: false,
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        if (result.d != "") {
                            DiscountOnMRP = jQuery.parseJSON(result.d);
                            if (jQuery("#lblEnrollID").text() != "")
                                getMRPPer();
                            getEnrolTestLimitCount();

                        }
                        else {
                            DiscountOnMRP = "";
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        }
        function selectSpecialTestLimit() {

            if (jQuery("#ddlDesignation").val() == 0) {
                showerrormsg('Please Select Designation');
                jQuery("#txtMinBusinessComm").val('');
                return;
            }
            else {
                var TestLimit = 0; var DiscountOnMRPPer = 0;
                var MinBusinessComm = jQuery("#txtMinBusinessComm").val();
                if (isNaN(MinBusinessComm)) MinBusinessComm = 0;

                for (var i = 0; i < SpecialTestLimit.length; i++) {
                    if (i == 0) {
                        TestLimit = SpecialTestLimit[i].TestLimit;
                    }
                    else {
                        if (parseFloat(SpecialTestLimit[i].BusinessCommitment) <= parseFloat(MinBusinessComm)) {
                            TestLimit = SpecialTestLimit[i].TestLimit;
                        }
                    }
                }

                jQuery("#spnSpecialTestLimit").text(TestLimit);
                for (var i = 0; i < DiscountOnMRP.length; i++) {
                    if (i == 0) {
                        DiscountOnMRPPer = DiscountOnMRP[i].DiscountOnMRP;
                    }
                    else {
                        if (parseFloat(DiscountOnMRP[i].BusinessCommitment) <= parseFloat(MinBusinessComm)) {
                            DiscountOnMRPPer = DiscountOnMRP[i].DiscountOnMRP;
                        }
                    }
                    
                }
                if (jQuery("#lblEnrollID").text() == "")
                    jQuery("#txtMRPPercentage").val(DiscountOnMRPPer);
                jQuery("#spnDesiMRPPercentage").text(DiscountOnMRPPer);

                colorChange();
            }
        }
        function onSucessSpecialTestLimit(result) {
            if (result != "") {
                SpecialTestLimit = jQuery.parseJSON(result);
            }
            else {
                SpecialTestLimit = "";
            }
        }
        function onFailureSpecialTestLimit() {

        }
        function onSucessDiscountOnMRP(result) {
            if (result != "")
                DiscountOnMRP = jQuery.parseJSON(result);
            else
                DiscountOnMRP = "";
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function checkRateLimit(rowID) {
            var chkLength = jQuery(".chk_Select:checked").length;
            if (jQuery(rowID).closest('tr').find('#chkSelect').is(':visible')) {
                if (!jQuery(rowID).closest('tr').find('#chkSelect').is(':checked') && jQuery(rowID).closest('tr').find('#txtSpecialRate').is(':visible')) {
                    if (parseFloat(jQuery(rowID).closest('tr').find('#txtSpecialRate').val()) > 0) {
                        jQuery(rowID).closest('tr').find('#chkSelect').focus();
                        showerrormsg('Check Special Test to Enter Rate Limit');
                        jQuery(rowID).closest('tr').find('#txtSpecialRate').val('');
                        return;
                    }
                }
                var TestRate = jQuery(rowID).closest('tr').find('#tdTestRate').text();
                if ((parseInt(chkLength)) > (parseInt(jQuery("#spnSpecialTestLimit").text())) || (jQuery("#ddlDesignation").val().split('#')[1] == "0" && parseInt(jQuery(rowID).closest('tr').find('#tdIsNewTest').text()) == 1)) {
                    jQuery("#tb_grdSpecialTest tr").each(function () {
                        var id = jQuery(this).attr("id");
                        var $rowid = jQuery(this).closest("tr");
                        if (id != "InvHeader") {
                            if (jQuery(this).closest('tr').find('#chkSelect').is(':checked')) {
                                jQuery(this).closest('tr').removeClass('greenTest');
                                jQuery(this).closest('tr').addClass('pinkTest');
                            }
                        }
                    });
                }
                else if (jQuery("#ddlDesignation").val().split('#')[1] == "1" && (parseInt(chkLength) <= (parseInt(jQuery("#spnSpecialTestLimit").text())))) {
                    if (parseFloat(jQuery(rowID).closest('tr').find('#txtSpecialRate').val()) >= parseFloat(TestRate)) {
                        jQuery(rowID).closest('tr').addClass('greenTest');
                        jQuery(rowID).closest('tr').removeClass('pinkTest');
                    }
                    else {
                        jQuery(rowID).closest('tr').removeClass('greenTest');
                        jQuery(rowID).closest('tr').addClass('pinkTest');
                    }
                }
                else if ((parseInt(chkLength)) <= (parseInt(jQuery("#spnSpecialTestLimit").text())) && (parseFloat(jQuery(rowID).closest('tr').find('#txtSpecialRate').val()) >= parseFloat(TestRate))) {
                    jQuery(rowID).closest('tr').removeClass('pinkTest');
                    jQuery(rowID).closest('tr').addClass('greenTest');
                }
                else if ((parseFloat(jQuery(rowID).closest('tr').find('#txtSpecialRate').val()) < parseFloat(TestRate))) {
                    jQuery(rowID).closest('tr').removeClass('greenTest');
                    jQuery(rowID).closest('tr').addClass('pinkTest');
                }
            }
            colorChange();
        }
        function chkSpecialTest(rowID) {
        
            if (jQuery("#txtMinBusinessComm").val() == "") {
                jQuery(rowID).closest('tr').find('#chkSelect').prop('checked', false);
                showerrormsg('Enter Min. Business Commit. ');
                jQuery("#txtMinBusinessComm").focus();
                return;
            }
            jQuery('#spnTestCount').text(parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length));

            colorChange();
            if (!jQuery(rowID).closest('tr').find('#chkSelect').is(':checked')) {
                jQuery(rowID).closest('tr').removeClass('pinkTest greenTest');
            }
        }
    </script>
    <style >
        .greenTest {
            background-color: lightgreen;
        }

        .pinkTest {
            background-color: pink;
        }
    </style>
    <script type="text/javascript">
        function chkMRPPercentage() {
            if (jQuery.trim($("#txtMRPPercentage").val()) != "") {
                if (jQuery("#txtMRPPercentage").val() > 100) {
                    showerrormsg('Please Enter Valid Percentage');
                    jQuery("#txtMRPPercentage").val('0');
                }
            }
            colorChange();
        }
        function clearform() {
            InvList = [];
            jQuery('#lbid,#lblPanelID,#lblFileName').text('');
            jQuery("#ddlType,#ddlPanelGroup,#ddlPaymentMode,#ddlPrintAtCentre,#ddlReportDispatchMode,#ddlInvoiceTo,#ddlBankName,#ddlTagProcessingLab,#ddlReferringRate").prop('selectedIndex', 0);
            jQuery("#ddlInvoiceBillingCycle").prop('selectedIndex', 2);
            jQuery("#ddlPanelGroup").removeAttr('disabled');

            jQuery("#txtName,#txtAddress,#txtLandline,#txtMobile,#txtEmailInvoice,#txtEmailReport,#txtIFSCCode,#txtGSTTIN,#txtAccountNo,#txtIFSCCode,#txtOnlinePassword,#txtOnlineUserName,#txtCreditLimit,#txtMinCash,#txtMinBusinessComm,#txtMRPPercentage,#txtInvoiceDisplayName,#txtInvoiceDisplayAddress").val('');
            jQuery("#txtCreditLimit").val('0').attr('disabled', 'disabled');
            jQuery("#txtMinCash").val('100');

            jQuery("#spnSpecialTestLimit").text('');
            jQuery("#tb_grdSpecialTest tr:not(#InvHeader),#tb_grdPCCGrouping tr").remove();
            jQuery("#divSpecialtest,#div_PCCGrouping").hide();
            jQuery("#isActive").prop('checked', 'checked');
            jQuery("#btnApprove,#btnVerify,#spnMRPPercentage,#txtMRPPercentage").hide();
            jQuery("#txtStateCity,#txtHLMOPMRP,#txtHLMOPClientShare,#txtHLMIPMRP,#txtHLMIPClientShare,#txtHLMICUMRP,#txtHLMICUClientShare").val('');
            jQuery("#btnSave").show();
            jQuery("#spnDesiMRPPercentage").text('0');
            jQuery("#chkAAALogo,#chkOnlineLogin,#chkHLMIP,#chkHLMICU").prop('checked', false);
            removeAddressDetail();

            jQuery("#txtName").val("".concat(jQuery("#ddlType option:selected").text(), " "));
            jQuery("#spnTestCount").text(0);
            selectPatientType();
        }
        function showuploadbox() {
            var FileName = "";
            if (jQuery('#lblFileName').text() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#lblFileName').text();
            }
            jQuery('#lblFileName').text(FileName);
            if (jQuery('#lblIsView').text() != "")
                window.open('../Sales/UploadDocument.aspx?FileName=' + FileName + '&IsView=<%=Request.QueryString["View"]%>', null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            else if (jQuery('#lblEnrollID').text() == "")
                window.open('../Sales/UploadDocument.aspx?FileName=' + FileName, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            else
                window.open('../Sales/UploadDocument.aspx?EnrolID=' + FileName, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

        }
        function checkSecondDecimal(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
        }
         </script>
    <script type="text/javascript">
        function bindEnrollSpecialTest(type) {
            if ((type == "PCC" || type == "PUP" || type == "HLM") && (jQuery("#ddlDesignation").val() != 0)) {
                PageMethods.bindEnrollSpecialTest(type, jQuery("#ddlDesignation").val().split('#')[0], jQuery("#lblEnrollID").text(), onSucessEnrolSpecialTest, onFailureSpecialTest);
            }
            else {
                jQuery('#divSpecialtest').html('');
                jQuery('#divSpecialtest').hide();
            }
        }
        function getEnrolTestLimitCount() {
            if (jQuery("#ddlDesignation").val() != 0 && jQuery("#txtMinBusinessComm").val() != "")
                PageMethods.getEnrolTestLimitCount(jQuery("#ddlDesignation").val().split('#')[0], jQuery("#txtMinBusinessComm").val(), jQuery("#lblTypeName").text(), onSucessEnrolTestCount, onFailureSpecialTest);
        }
        function onSucessEnrolTestCount(result) {
            jQuery("#spnSpecialTestLimit").text(result);
        }
        function onSucessEnrolSpecialTest(result) {
            specialTest = jQuery.parseJSON(result);
            if (specialTest != null) {
                if (jQuery('#tb_grdSpecialTest tr:not(#InvHeader)').length == 0)
                    hideShowHeader();

                for (var i = 0; i < specialTest.length; i++) {
                    InvList.push(specialTest[i].ItemID);

                    var appendText = [];

                    appendText.push("<tr id='" + specialTest[i].ItemID + "' class='GridViewItemStyle' >");
                    appendText.push('<td class="inv" id=' + specialTest[i].ItemID + ' style="text-align: center"> ');
                    appendText.push(' <input type="checkbox" id="chkSelect" class="chk_Select" onclick="chkSpecialTest(this)"  ');
                    if (specialTest[i].IsCheck == "1")
                        appendText.push(' checked="checked" ');
                    appendText.push('/></td>');
                    appendText.push('<td id="tdTestCode" style="font-weight:bold;">' + specialTest[i].TestCode + '</td>');
                    appendText.push('<td id="tdItemName" style="font-weight:bold;">' + specialTest[i].TestName + '</td>');

                    if (jQuery("#ddlType option:selected").text() == "PUP" || jQuery("#ddlType option:selected").text() == "HLM") {
                        if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                            appendText.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;">' + specialTest[i].Rate + '</td>');
                        }
                        else {
                            appendText.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;display:none">' + specialTest[i].Rate + '</td>');
                        }
                    }

                    appendText.push('<td id="tdSpecialRate" style="text-align: center"><input type="text" style="width:70px;"  id="txtSpecialRate" autocomplete="off" value="' + specialTest[i].TestRate + '" onkeyup="calculateTotalValue(this);checkRateLimit(this);" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');

                    if (jQuery("#ddlType option:selected").text() == "PUP" && specialTest[i].IsNewTest == 0) {
                        //  appendText.push('<td id="tdMinimumSales" style="text-align: center"><input type="text" style="width:70px;"  id="txtMinimumSales" value="' + specialTest[i].MinimumSales + '" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        //  appendText.push('<td id="tdSalesDuration" style="text-align: center"><input type="text" style="width:70px;"  id="txtSalesDuration" value="' + specialTest[i].SalesDuration + '" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        //  appendText.push('<td id="tdIntimationDays" style="text-align: center"><input type="text" style="width:70px;"  id="txtIntimationDays" value="' + specialTest[i].IntimationDays + '" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');

                    }
                    else if (jQuery("#ddlType option:selected").text() == "HLM") {
                        appendText.push('<td id="tdTotalValue" style="text-align: center">');
                        appendText.push('<input type="radio" title="Net Price" name="HLMPrice_' + specialTest[i].ItemID + '" id="rbHLMNetPrice"  value="Net" ');
                        if (specialTest[i].HLMPrice == "Net")
                            appendText.push(' checked="checked" ');
                        appendText.push(' />Net Price');
                        appendText.push('<input type="radio" title="Gross Price" name="HLMPrice_' + specialTest[i].ItemID + '" id="rbHLMGrossPrice" value="Gross" ');
                        if (specialTest[i].HLMPrice == "Gross")
                            appendText.push(' checked="checked" ');
                        appendText.push('/>Gross Price');
                        appendText.push('</td>');
                    }
                    else {
                        appendText.push('<td id="tdMinimumSales" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtMinimumSales" value="' + specialTest[i].MinimumSales + '" onkeyup="calculateTotalValue(this);checkRateLimit(this);" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        appendText.push('<td id="tdSalesDuration" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtSalesDuration" value="' + specialTest[i].SalesDuration + '" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        appendText.push('<td id="tdIntimationDays" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtIntimationDays" value="' + specialTest[i].IntimationDays + '" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                        appendText.push('<td id="tdTotalValue" style="text-align: center"><input type="text" style="width:70px;"  autocomplete="off" id="txtTotalValues" value="' + specialTest[i].TotalValue + '" onkeypress="return checkNumeric(event,this);"/></td>');

                    }
                    appendText.push('<td id="tdIsNewTest" style="font-weight:bold;display:none" >' + specialTest[i].IsNewTest + '</td>');
                    appendText.push('<td id="tdItemID" style="font-weight:bold;display:none">' + specialTest[i].ItemID + '</td>');
                    appendText.push("</tr>");
                    appendText = appendText.join(" ");
                    jQuery('#tb_grdSpecialTest').append(appendText);
                }


                jQuery('#tb_grdSpecialTest').css('display', 'block');
                jQuery('#divSpecialtest').show();
                jQuery('#spnTestCount').text(parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length));

                jQuery('#tb_grdSpecialTest').tableDnD({
                    onDragClass: "myDragClass",

                    onDragStart: function (table, row) {
                    },
                    dragHandle: ".dragHandle"

                });
                var chkLength = jQuery(".chk_Select:checked").length;

                colorChange();
                if (jQuery.trim(jQuery("#lblIsView").text()) != "") {
                    jQuery('#btnApprove,#btnSave,#btnVerify').hide();
                    jQuery('input[id*=chkSelect]').prop('disabled', false);
                    jQuery("#tb_grdSpecialTest :input").attr("disabled", "disabled");

                }
            }
            else {
                jQuery('#divSpecialtest').hide();
            }
        }
    </script>
    <script type="text/javascript">
        function ApproveVerifyEnrolment(Approve) {
            jQuery('#lblIsApprove').text(Approve);
            if (jQuery('#lblEnrollID').text() == "") {
                saveEnrolment(Approve);
            }
            else {

                jQuery('#lblMsg').html('');
                if (ValidateEnrolment() == "1") {
                    return;
                }
                // jQuery('#btnApprove,#btnVerify').attr('disabled', true).val("Submitting...");
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

                var resultPanel = panelMaster();
                var resultEmployee = employeeCentre();
                var resultTestEnrolment = testEnrolment();
                var resultPCCGrouping = PCCTestGrouping();
                var resultCampaignTest = PCCMarketingCampaign();
                var resultHLMPackage = HLMPackage();

                if (resultTestEnrolment.length == 0 && (jQuery("#ddlType option:selected").text() == "PCC" || jQuery("#ddlType option:selected").text() == "PUP")) {
                    showerrormsg('Select Special Test');
                    jQuery.unblockUI();
                    return;
                }
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/approveEnrolment",
                    data: JSON.stringify({ Panel: resultPanel, Employee: resultEmployee, TestEnrolment: resultTestEnrolment, PCCGrouping: resultPCCGrouping, MarketingCampaignTest: resultCampaignTest, HLMPackage: resultHLMPackage }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != "1" && result.d != "2" && result.d != "3") {
                            showerrormsg(result.d);
                        }
                        else if (result.d == "2") {
                            showerrormsg("Name Already Exist");
                        }
                        else if (result.d == "3") {
                            showerrormsg("Enrolment Already Approved");
                        }
                        else if (result.d == "1") {
                            showerrormsg("Record Saved Successfully");
                            location.href = 'EnrollmentSearch.aspx';

                        }
                        else {
                            alert('Error...');
                        }
                        jQuery.unblockUI();
                    },
                    error: function (xhr, status) {
                        jQuery.unblockUI();
                    }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function bindHeadQuarter() {
            jQuery("#ddlHeadQuarter option").remove();
            jQuery("#ddlCity option").remove();
            jQuery("#ddlZone option").remove();
            jQuery("#ddlLocality option").remove();
            if (jQuery("#ddlState").val() != "0") {
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/bindHeadQuarter",
                    data: '{ StateID: "' + jQuery("#ddlState").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        HeadQuarterData = jQuery.parseJSON(result.d);
                        if (HeadQuarterData.length == 0) {
                            jQuery("#ddlHeadQuarter").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlHeadQuarter").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < HeadQuarterData.length; i++) {
                                jQuery("#ddlHeadQuarter").append(jQuery("<option></option>").val(HeadQuarterData[i].ID).html(HeadQuarterData[i].HeadQuarter));
                            }
                            // bindZone();
                        }
                    },
                    error: function (xhr, status) {
                        jQuery("#ddlHeadQuarter").attr("disabled", false);
                    }
                });
            }
        }
        function bindCity() {
            jQuery("#ddlCity option").remove();
            jQuery("#ddlZone option").remove();
            jQuery("#ddlLocality option").remove();
            if (jQuery("#ddlHeadQuarter").val() != "0") {
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/bindCityByHeadQuarter",
                    data: '{ HeadQuarterID: "' + jQuery("#ddlHeadQuarter").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        cityData = jQuery.parseJSON(result.d);
                        if (cityData.length == 0) {
                            jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < cityData.length; i++) {
                                jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                            }
                            // bindZone();
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlCity").attr("disabled", false);
                    }
                });
            }
        }
        function bindZone() {
            jQuery("#ddlZone option").remove();
            jQuery("#ddlLocality option").remove();
            if (jQuery("#ddlCity").val() != "0") {
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/bindZone",
                    data: '{ CityID: "' + jQuery("#ddlCity").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        zoneData = jQuery.parseJSON(result.d);
                        if (zoneData.length == 0) {
                            jQuery("#ddlZone").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlZone").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < zoneData.length; i++) {
                                jQuery("#ddlZone").append(jQuery("<option></option>").val(zoneData[i].ZoneID).html(zoneData[i].Zone));
                            }
                        }
                        // bindLocality();
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlZone").attr("disabled", false);
                    }

                });
            }
        }
        function bindLocality() {
            jQuery("#ddlLocality option").remove();
            if (jQuery("#ddlZone").val() != "0") {

                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/bindLocalityByZone",
                    data: '{ ZoneID: "' + jQuery("#ddlZone").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        localityData = jQuery.parseJSON(result.d);
                        if (localityData.length == 0) {
                            jQuery("#ddlLocality").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlLocality").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < localityData.length; i++) {
                                jQuery("#ddlLocality").append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                            }
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlLocality").attr("disabled", false);
                    }
                });
            }
        }
        function bindState() {
            jQuery("#ddlState option").remove();
            jQuery("#ddlHeadQuarter option").remove();
            jQuery("#ddlCity option").remove();
            jQuery("#ddlZone option").remove();
            jQuery("#ddlLocality option").remove();
            if ($("#ddlBusinessZone").val() != 0) {
                jQuery.ajax({
                    url: "EnrolmentMaster.aspx/bindState",
                    data: '{ BusinessZoneID: "' + jQuery("#ddlBusinessZone").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        if (stateData.length == 0) {
                            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < stateData.length; i++) {
                                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                            }
                            // bindZone();
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlState").attr("disabled", false);
                    }

                });
            }
        }
           </script>
    <script type="text/javascript">
        function fillEnrolmentAddress() {
            if ('<%=Request.QueryString["EnrolID"] != null%>') {
                if (jQuery("#lblTypeName").text() != "PUP" && jQuery("#txtStateCity").val() != "") {
                    jQuery("#ddlState").val(jQuery("#txtStateCity").val().split('#')[0]);
                    bindHeadQuarter();
                    jQuery("#ddlHeadQuarter").val(jQuery("#txtStateCity").val().split('#')[1]);
                    bindCity();
                    jQuery("#ddlCity").val(jQuery("#txtStateCity").val().split('#')[2]);
                    bindZone();
                    jQuery("#ddlZone").val(jQuery("#txtStateCity").val().split('#')[3]);
                    bindLocality();
                    jQuery("#ddlLocality").val(jQuery("#txtStateCity").val().split('#')[4]);
                }
            }
        }
    </script>
    <script type="text/javascript">
        function AddMoreTest() {
        }
        function clearItem() {
            jQuery("#txtNewInvestigation").val('');
        }
        jQuery("#txtNewInvestigation")
              .bind("keydown", function (event) {

                  if ((jQuery("#txtMinBusinessComm").val() == "" || jQuery("#txtMinBusinessComm").val() == 0) && jQuery("#ddlType option:selected").text() != "HLM") {
                      showerrormsg('Please Enter MinBusiness Commitment');
                      jQuery("#txtMinBusinessComm").focus();
                      return;
                  }
                  if ((jQuery("#txtMRPPercentage").val() == "") && (jQuery("#ddlType option:selected").text() == "PCC" || jQuery("#ddlType option:selected").text() == "PUP")) {
                      showerrormsg('Please Enter ' + jQuery("#spnMRPPercentage").text());
                      jQuery("#txtMRPPercentage").focus();
                      return;
                  }
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  jQuery("#theHidden").val('');
              })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("EnrolmentMaster.aspx?cmd=GetTestList", {
                          SearchType: jQuery('input:radio[name=rblsearchtype]:checked').val(),
                          TestName: extractLast1(request.term)
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
                      jQuery("#theHidden").val(ui.item.id);
                      this.value = '';
                      AddItem(ui.item.value);
                      return false;
                  },
              });
        function extractLast1(term) {
            return term;
        }
        function hideShowHeader() {
            if (jQuery("#ddlType option:selected").text() == "PUP") {
                jQuery(".specialRateReq").show();
                if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                    jQuery(".testRateLimit").show();
                }
                else {
                    jQuery(".testRateLimit").hide();
                }
                jQuery("#spnSpecialRate").text('Special Rate Requested');
                jQuery("#spnTotalValue").text('Total Value');
            }
            else if (jQuery("#ddlType option:selected").text() == "HLM") {
                jQuery(".minSalesComm,.salesDuration,.IntimationDays").hide();
                if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                    jQuery(".testRateLimit").show();
                }
                else {
                    jQuery(".testRateLimit").hide();
                }
                jQuery(".specialRateReq").show();
                jQuery("#spnSpecialRate").text('Rate');
                jQuery(".TotalValue").css({ 'width': '200px' });
                jQuery("#spnTotalValue").text('')
            }
            else {
                jQuery(".testRateLimit").hide();
                //  jQuery(".specialRateReq,.minSalesComm,.salesDuration,.IntimationDays").show();
                jQuery("#spnSpecialRate").text('Special Rate Requested');
                jQuery("#spnTotalValue").text('Total Value');
            }
        }

        function AddItem(ItemID) {
            if (ItemID == '') {
                showerrormsg("Please Select Investigation...");
                return false;
            }

            if (jQuery('#tb_grdSpecialTest tr:not(#InvHeader)').length == 0)
                hideShowHeader();
            jQuery.ajax({
                url: "EnrolmentMaster.aspx/getItemMaster",
                data: '{ ItemID:"' + ItemID + '",Type:"' + jQuery("#ddlType option:selected").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = jQuery.parseJSON(result.d);
                    if (TestData.length == 0) {
                        alert('No Record Found..!');
                        return;
                    }
                    else {
                        var inv = TestData[0].ItemID;
                        if (jQuery.inArray(ItemID, InvList) != -1) {
                            showerrormsg("Item Already in List..!");
                            return;
                        }
                        InvList.push(ItemID);
                        if (jQuery('#tb_grdSpecialTest tr:not(#InvHeader)').length == 0)
                            jQuery('#tb_grdSpecialTest,#divSpecialtest').show();


                        var mydata = [];

                        mydata.push("<tr id='" + TestData[0].ItemID + "' class='GridViewItemStyle' >");
                        mydata.push('<td class="inv" id=' + TestData[0].ItemID + ' style="text-align: center"> ');
                        mydata.push('<a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img class="img_Delete" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
                        mydata.push(' </td>');
                        mydata.push('<td id="tdTestCode" style="font-weight:bold;">' + TestData[0].TestCode + '</td>');
                        mydata.push('<td id="tdItemName" style="font-weight:bold;">' + TestData[0].TestName + '</td>');

                        if (jQuery("#ddlType option:selected").text() == "PUP") {
                            if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                                mydata.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;"></td>');
                            }
                            else {
                                mydata.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;display:none"></td>');
                            }
                        }
                        if (jQuery("#ddlType option:selected").text() != "HLM") {
                            mydata.push('<td id="tdSpecialRate" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtSpecialRate" value="" onkeyup="calculateTotalValue(this);checkRateLimit(this);" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                            mydata.push('<td id="tdMinimumSales" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtMinimumSales" value="" onkeyup="calculateTotalValue(this);checkRateLimit(this);" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                            mydata.push('<td id="tdSalesDuration" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtSalesDuration" value="" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                            mydata.push('<td id="tdIntimationDays" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtIntimationDays" value="" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                            mydata.push('<td id="tdTotalValues" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtTotalValues" value="" readonly="readonly"/></td>');
                        }
                        else {
                            if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                                mydata.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;"> ' + TestData[0].TestRate + '</td>');
                            }
                            else {
                                mydata.push('<td id="tdTestRate" style="text-align: right;font-weight:bold;display:none"> ' + TestData[0].TestRate + '</td>');
                            }
                            mydata.push('<td id="tdSpecialRate" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtSpecialRate" value="" onkeyup="calculateTotalValue(this);checkRateLimit(this);" onkeypress="return checkNumeric(event,this);" maxlength="6"/></td>');
                            mydata.push('<td id="tdTotalValues" style="text-align: center">');
                            mydata.push('<input type="radio" title="Net Price" name="HLMPrice_' + TestData[0].ItemID + '" id="rbHLMNetPrice" value="Net"  checked="checked"  />Net Price');
                            mydata.push('<input type="radio" title="Gross Price" name="HLMPrice_' + TestData[0].ItemID + '" id="rbHLMGrossPrice" value="Gross"/>Gross Price');
                            mydata.push('</td>');

                        }

                        mydata.push('<td id="tdIsNewTest" style="font-weight:bold;display:none" class="clIsNewTest">1</td>');
                        mydata.push('<td id="tdItemID" style="font-weight:bold;display:none">' + TestData[0].ItemID + '</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join(" ");

                       // jQuery('#tb_grdSpecialTest tbody').prepend(mydata);

                        
                       // $("#InvHeader").after($("#tb_grdSpecialTest").prepend(mydata));
                        $("#tb_grdSpecialTest tr:first").after(mydata);

                        jQuery('#tb_grdSpecialTest').css('display', 'block');

                        jQuery('#tb_grdSpecialTest').tableDnD({
                            onDragClass: "myDragClass",
                            onDragStart: function (table, row) {
                            },
                            dragHandle: ".dragHandle"
                        });
                        jQuery(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                        jQuery('#spnTestCount').text(parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length));
                        
                    }
                    colorChange();
                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });
        }
        function calculateTotalValue(rowID) {
            var SpecialRate = 0; var MinimumSales = 0;
            SpecialRate = jQuery(rowID).closest('tr').find("#txtSpecialRate").val();
            if (isNaN(SpecialRate) || SpecialRate == "")
                SpecialRate = 0;
            MinimumSales = jQuery(rowID).closest('tr').find("#txtMinimumSales").val();
            if (isNaN(MinimumSales) || MinimumSales == "")
                MinimumSales = 0;

            jQuery(rowID).closest('tr').find("#txtTotalValues").val(parseFloat(SpecialRate) * parseFloat(MinimumSales));
        }

        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
        }
        function deleteItemNode(row) {
            var $tr = $(row).closest('tr');
            var RmvInv = $tr.find('.inv').attr("id").split(',');
            var len = RmvInv.length;
            InvList.splice($.inArray(RmvInv[0], InvList), len);
            row.closest('tr').remove();
            if (jQuery('#tb_grdSpecialTest tr:not(#InvHeader)').length == 0) {
                jQuery('#tb_grdSpecialTest,#divSpecialtest').hide();
            }
            jQuery('#spnTestCount').text(parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length));

            colorChange();
        }
        function disableSaveButton() {
            jQuery('#btnSave,#ddlDesignation,#ddlName,#ddlType').attr('disabled', 'disabled');
        }
    </script>
     <script type="text/javascript">
         function bindPCCGrouping() {
             if (jQuery('#tb_grdPCCGrouping tr').length == 0)
                 PageMethods.bindPCCGrouping(onSuccessGrouping, OnfailureGrouping);
         }
         function onSuccessGrouping(result) {
             PCCGroupingData = jQuery.parseJSON(result);
             var output = jQuery('#tb_PCCGrouping').parseTemplate(PCCGroupingData);
             jQuery('#div_PCCGrouping').html(output);
             jQuery('#div_PCCGrouping').show();

             if (jQuery.trim(jQuery("#lblIsView").text()) != "") {

                 jQuery('#btnApprove,#btnSave,#btnVerify').hide();
                 jQuery('input[id*=txtPCCGroupShare],input[id*=chkPCCGrouping] ').attr('disabled', 'disabled');

             }
         }
         function bindEnrollPCCGrouping() {
             if (jQuery('#tb_grdPCCGrouping tr').length == 0)
                 PageMethods.bindEnrollPCCGrouping(jQuery.trim(jQuery("#lblEnrollID").text()), onSuccessGrouping, OnfailureGrouping);
         }
          </script>
     <script id="tb_PCCGrouping" type="text/html">      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdPCCGrouping" style="border-collapse:collapse;"> 
            <thead>
		<tr id="PCCGroupingHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:460px;">Group Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Share(%)</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Show</th>						                 
        </tr>
                </thead>
       <#      
              var dataLength=PCCGroupingData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = PCCGroupingData[j];
                 #>            
            <tr>                                 
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#><input type="checkbox" id="chkPCCGrouping" 
                <#
                if(objRow.IsCheck=="1")
                {#>
                checked="checked"
                <#}
                #>
                 /></td>                
            <td  class="GridViewLabItemStyle" style="text-align:center;text-align:left"><#=objRow.GroupName#></td>
                <td  class="GridViewLabItemStyle" style="text-align:center;text-align:left">
                    <input type="text"  style="width:80px" id="txtPCCGroupShare" autocomplete="off" value="<#=objRow.PCCGroupSharePer#>"  onkeyup="chkPCCGroupShare(this)" onkeypress="return checkNumeric(event,this);" maxlength="3"/>
                </td>
            <td  class="GridViewLabItemStyle" id="tdGroupID" style="text-align:center;display:none"><#=objRow.GroupID#></td>               
            <td  class="GridViewLabItemStyle" style="text-align:center;">                                  
                     <img style="width: 15px; cursor:pointer" src="../../App_Images/view.gif" onclick="viewGroupTest(this)" title="Click to View Test" />
            </td>                               
            </tr>                 
      <#}#>
        </table>    
    </script> 
     <script id="tb_PCCGroupingTest" type="text/html">      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdPCCGroupingTest" style="border-collapse:collapse;width:500px;"> 
            <thead>
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Code</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:360px;">Item Name</th>						                 
        </tr>
                </thead>
       <#      
              var dataLength=PCCGroupingTestData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = PCCGroupingTestData[j];
                 #>            
            <tr>                                 
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>                
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TestCode#></td>
            <td  class="GridViewLabItemStyle" id="tdItemName" style="text-align:left;"><#=objRow.ItemName#></td>               
                                         
            </tr>                 
      <#}#>
        </table>    
    </script> 

    <script type="text/javascript">
        function viewGroupTest(rowID) {
            PageMethods.bindPCCGroupingTest(jQuery(rowID).closest('tr').find('#tdGroupID').text(), onSuccessGroupingTest, OnfailureGrouping);
        }
        function onSuccessGroupingTest(result) {
            PCCGroupingTestData = jQuery.parseJSON(result);
            var output = jQuery('#tb_PCCGroupingTest').parseTemplate(PCCGroupingTestData);
            jQuery('#div_GroupTest').html(output);
            $find('mpGroupTest').show();
        }
        function OnfailureGrouping(result) {

        }
        function closeGroupTest() {
            jQuery('#div_GroupTest').html('');
            $find('mpGroupTest').hide();
        }
        function chkPCCGroupShare(rowID) {
            if (jQuery(rowID).val() > 100) {
                jQuery(rowID).val('');
                jQuery(rowID).focus();
                showerrormsg('Enter Valid PCC Group Share(%)');

            }
        }
    </script>

     <asp:Button ID="btnGroupTest" runat="server" Style="display:none" OnClientClick="JavaScript: return false;"/>
    <cc1:ModalPopupExtender ID="mpGroupTest" runat="server"
                            DropShadow="true" TargetControlID="btnGroupTest"   CancelControlID="imgcloseGroupTest" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlGroupTest"    BehaviorID="mpGroupTest">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlGroupTest" runat="server" Style="display: none;width:580px; height:430px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>                                      
                    <td  style="text-align:right">      
                        <img id="imgcloseGroupTest" runat="server" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closeGroupTest()" />  
                    </td>                    
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse">               
                  <tr>
                      <td>
            <div id="div_GroupTest" style="text-align:center;width: 99%; max-height:400px;overflow-y:scroll;">                
            </div>                 
                      </td>
                  </tr>

                      
                </table>    
       
    </asp:Panel>
    <script type="text/javascript">
        function getMRPPer() {

            if (jQuery("#ddlDesignation").val() == 0) {
                showerrormsg('Please Select Designation');
                jQuery("#txtMinBusinessComm").val('');
                return;
            }
            else {
                var DiscountOnMRPPer = 0;
                var MinBusinessComm = jQuery("#txtMinBusinessComm").val();
                for (var i = 0; i < DiscountOnMRP.length; i++) {
                    if (parseFloat(DiscountOnMRP[i].BusinessCommitment) <= parseFloat(MinBusinessComm)) {
                        DiscountOnMRPPer = DiscountOnMRP[i].DiscountOnMRP;
                    }
                    if (jQuery("#ddlType option:selected").text() == "PCC") {
                        if (parseFloat(DiscountOnMRP[i].BusinessCommitment) >= parseFloat(MinBusinessComm)) {
                            DiscountOnMRPPer = DiscountOnMRP[i].DiscountOnMRP;
                        }
                    }
                }

                if (jQuery("#ddlDesignation").val().split('#')[2] == "1") {
                    jQuery("#spnDesiMRPPercentage,#spnDiscLimit").show();
                }
                else {
                    jQuery("#spnDesiMRPPercentage,#spnDiscLimit").hide();
                }
                jQuery("#spnDesiMRPPercentage").text(DiscountOnMRPPer);


            }
        }
        function changeRefRate() {
            if (jQuery("#ddlType option:selected").text() == "PCC") {
                var TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();

                //$("#ddlReferringRate option:contains(" + TagProcessingLab + ")").attr('selected', 'selected');



                //$("#ddlReferringRate option:contains(" + TagProcessingLab + ")").attr('selected', 'selected');
                $("#ddlReferringRate option").removeAttr("selected");
                //alert(TagProcessingLab);
                //  $("#ddlReferringRate").find("option[text=" + TagProcessingLab + "]").attr("selected", true);

                $("#ddlReferringRate option").each(function () {

                    if ($.trim($(this).text()) == $.trim(TagProcessingLab)) {
                        $(this).attr("selected", true);
                        return;
                    }
                });

            }
        }
        function chkHLMPer(textValue) {
            if (isNaN(textValue) || textValue == "")
                textValue = 0;

            if (parseInt(textValue) > 100) {
                showerrormsg('Enter Valid Percentage');
                jQuery(this).val('');
                jQuery(this).focus();
                return;
            }
        }
        jQuery(function () {
            jQuery(window).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });
        });
    </script>
    <script type="text/javascript">
        function getOPPaymentCon() {
            if (jQuery("#ddlHLMOPPaymentMode").val() == "Cash") {
                jQuery('#<%= rblHLMOPPatientPayTo.ClientID %> input[type=radio]').removeAttr('disabled');
                jQuery('#<%= rblHLMOPPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
            else {
                jQuery('#<%= rblHLMOPPatientPayTo.ClientID %> input[type=radio]').attr('disabled', 'disabled');
                jQuery('#<%= rblHLMOPPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
        }
        function getIPPaymentCon() {
            if (jQuery("#ddlHLMIPPaymentMode").val() == "Cash") {
                jQuery('#<%= rblHLMIPPatientPayTo.ClientID %> input[type=radio]').removeAttr('disabled');
                jQuery('#<%= rblHLMIPPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
            else {
                jQuery('#<%= rblHLMIPPatientPayTo.ClientID %> input[type=radio]').attr('disabled', 'disabled');
                jQuery('#<%= rblHLMIPPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
        }
        function getICUPaymentCon() {
            if (jQuery("#ddlHLMICUPaymentMode").val() == "Cash") {
                jQuery('#<%= rblHLMICUPatientPayTo.ClientID %> input[type=radio]').removeAttr('disabled');
                jQuery('#<%= rblHLMICUPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
            else {
                jQuery('#<%= rblHLMICUPatientPayTo.ClientID %> input[type=radio]').attr('disabled', 'disabled');
                jQuery('#<%= rblHLMICUPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
        }
    </script>

    <script type="text/javascript">
        function colorChange() {
            var chkLength = 0;
            if (jQuery("#lblIsView").text() == "") {
                if (jQuery("#ddlType option:selected").text() == "PCC") {
                    chkLength = parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length);

                    if (jQuery("#ddlName").val().split('#')[2] == "1") {
                        jQuery("#btnApprove").show();
                        jQuery("#btnVerify").hide();
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                    }
                    else if (parseInt(chkLength) > parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) > parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                        jQuery('#tb_grdSpecialTest tr').addClass('pinkTest');
                        jQuery('#tb_grdSpecialTest tr').removeClass('greenTest');
                        jQuery('#btnVerify').show();
                        jQuery('#btnApprove').hide();
                    }
                        //1 IsnewtestApprove 3 IsDirectApprove
                    else if (jQuery("#ddlDesignation").val().split('#')[3] == "0") {
                        jQuery('#tb_grdSpecialTest tr').addClass('pinkTest');
                        jQuery('#tb_grdSpecialTest tr').removeClass('greenTest');
                        jQuery('#btnVerify').show();
                        jQuery('#btnApprove').hide();
                    }
                    else if (jQuery(".clIsNewTest").length > 0 && jQuery("#ddlDesignation").val().split('#')[1] == "0") {
                        jQuery('#tb_grdSpecialTest tr').addClass('pinkTest');
                        jQuery('#tb_grdSpecialTest tr').removeClass('greenTest');
                        jQuery('#btnVerify').show();
                        jQuery('#btnApprove').hide();
                    }
                    else if (parseInt(chkLength) <= parseInt(jQuery("#spnSpecialTestLimit").text())) {
                        jQuery('#tb_grdSpecialTest tr').removeClass('pinkTest');
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                        jQuery('#btnVerify,#btnApprove').show();
                    }
                    else if ((jQuery("#ddlDesignation").val().split('#')[1] == "1") && (jQuery(".clIsNewTest").length > 0)) {
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                        jQuery('#tb_grdSpecialTest tr').removeClass('pinkTest');
                        jQuery('#btnApprove,#btnVerify').show();
                    }
                    else {
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                        jQuery('#tb_grdSpecialTest tr').removeClass('pinkTest');
                        jQuery('#btnApprove,#btnVerify').show();
                    }
                }
                else if (jQuery("#ddlType option:selected").text() == "PUP") {
                    chkLength = parseInt(jQuery(".chk_Select:checked").length) + parseInt(jQuery(".img_Delete").length);
                    var testRate = 0;
                    if (jQuery("#ddlDesignation").val().split('#')[3] == "0") {
                        var chkColour = 0;
                        if (parseInt(chkLength) > parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) > parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                            chkColour = 1;
                        }
                        else {
                            chkColour = 2;
                        }
                        jQuery("#tb_grdSpecialTest  tr").each(function () {
                            var id = jQuery(this).attr("id");
                            var $rowid = jQuery(this).closest("tr");

                            if (id != "InvHeader") {
                                if (jQuery(this).closest('tr').find('#chkSelect').is(':checked')) {
                                    if (chkColour == "1") {
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                    }
                                    else {
                                        jQuery(this).closest('tr').removeClass('pinkTest');
                                        jQuery(this).closest('tr').addClass('greenTest');
                                    }
                                }

                            }
                        });

                    }

                    else {

                        jQuery("#tb_grdSpecialTest  tr").each(function () {
                            var id = jQuery(this).attr("id");
                            var $rowid = jQuery(this).closest("tr");

                            if (id != "InvHeader") {
                                if (jQuery(this).closest('tr').find('#chkSelect').is(':checked')) {
                                    var SpecialRate = jQuery(this).closest('tr').find('#txtSpecialRate').val();
                                    if (isNaN(SpecialRate) || SpecialRate == "") SpecialRate = 0;
                                    if ((jQuery(this).closest('tr').find('#tdTestRate').is(':visible') && jQuery(this).closest('tr').find('#tdTestRate').text() != "") && (parseFloat(SpecialRate) < parseFloat(jQuery(this).closest('tr').find('#tdTestRate').text()))) {
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                        // alert('1');
                                        testRate += 1;
                                    }
                                    else if (parseInt(chkLength) > parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) > parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                        // alert('2');
                                    }
                                    else if (parseInt(chkLength) <= parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) <= parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                                        jQuery(this).closest('tr').removeClass('pinkTest');
                                        jQuery(this).closest('tr').addClass('greenTest');
                                        // alert('3');
                                    }
                                    else if (jQuery(this).closest('tr').find('#tdIsNewTest') == 1 && jQuery("#ddlDesignation").val().split('#')[1] == "1") {
                                        jQuery(this).closest('tr').addClass('greenTest');
                                        jQuery(this).closest('tr').removeClass('pinkTest');
                                        // alert('4');
                                    }
                                    else if (jQuery(this).closest('tr').find('#tdIsNewTest') == 1 && jQuery("#ddlDesignation").val().split('#')[1] == "0") {
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                        // alert('5');
                                    }
                                    else if (parseInt(chkLength) > parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) > parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                        // alert('6');
                                    }
                                    else if ((jQuery(this).closest('tr').find('#tdTestRate').is(':visible') && jQuery(this).closest('tr').find('#tdTestRate').text() != "") && (parseFloat(SpecialRate) >= parseFloat(jQuery(this).closest('tr').find('#tdTestRate').text()))) {
                                        jQuery(this).closest('tr').addClass('greenTest');
                                        jQuery(this).closest('tr').removeClass('pinkTest');
                                        // alert('7');
                                    }
                                    else {
                                        jQuery(this).closest('tr').removeClass('greenTest');
                                        jQuery(this).closest('tr').addClass('pinkTest');
                                        // alert('8');
                                    }
                                }
                                else {
                                    jQuery(this).closest('tr').removeClass('greenTest pinkTest');
                                }
                            }
                        });
                    }
                    //Sequence No
                    if (jQuery("#ddlName").val().split('#')[2] == "1") {
                        jQuery("#btnApprove").show();
                        jQuery("#btnVerify").hide();
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                    }
                        // 0 DesignationID,1 IsNewTestApprove,2 IsShowSpecialRate,3 IsDirectApprove
                    else if (jQuery("#ddlDesignation").val().split('#')[3] == "0" || jQuery("#ddlDesignation").val().split('#')[1] == "0") {
                        jQuery("#btnVerify").show();
                        jQuery("#btnApprove").hide();
                    }

                    else if (jQuery("#ddlDesignation").val().split('#')[3] == "1") {
                        if ((jQuery(".pinkTest").length == 0) && parseInt(chkLength) <= parseInt(jQuery("#spnSpecialTestLimit").text()) && parseFloat(jQuery("#txtMRPPercentage").val()) <= parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                            jQuery("#btnApprove,#btnVerify").show();
                        }
                        else {
                            jQuery("#btnVerify").show();
                            jQuery("#btnApprove").hide();
                        }
                    }
                    else if (jQuery("#ddlDesignation").val().split('#')[1] == "1") {
                        if ((jQuery(".pinkTest").length == 0) && parseInt(chkLength) <= parseInt(jQuery("#spnSpecialTestLimit").text()) && parseFloat(jQuery("#txtMRPPercentage").val()) <= parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                            jQuery("#btnApprove,#btnVerify").show();
                            alert(jQuery(".pinkTest").length);
                        }
                        else {
                            jQuery("#btnVerify").show();
                            jQuery("#btnApprove").hide();
                        }
                    }

                    if (parseInt(chkLength) > parseInt(jQuery("#spnSpecialTestLimit").text()) || parseFloat(jQuery("#txtMRPPercentage").val()) > parseFloat(jQuery("#spnDesiMRPPercentage").text())) {
                        jQuery("#btnVerify").show();
                        jQuery("#btnApprove").hide();
                    }
                    //if (jQuery(".pinkTest").length > 0) {
                    //    jQuery('#btnApprove').hide();
                    //    jQuery('#btnVerify').show();
                    //}
                    //else {
                    //    jQuery('#btnApprove,#btnVerify').show();

                    //}
                }
                else if (jQuery("#ddlType option:selected").text() == "HLM") {
                    if (jQuery("#ddlName").val().split('#')[2] == "1" || jQuery("#ddlName").val().split('#')[2] == "2") {
                        jQuery("#btnApprove").show();
                        jQuery("#btnVerify").hide();
                        jQuery('#tb_grdSpecialTest tr').addClass('greenTest');
                    }
                    else {
                        jQuery("#btnApprove").hide();
                        jQuery("#btnVerify").show();
                        jQuery('#tb_grdSpecialTest tr').addClass('pinkTest');
                    }
                }

            }
        }
    </script>

    <script type="text/javascript">
        function clearMarketItem() {
            jQuery("#txtMarketInvestigation").val('');
        }

        jQuery("#txtMarketInvestigation")
             .bind("keydown", function (event) {

                 if (jQuery("#ddlTagProcessingLab").val() == "-1") {
                     showerrormsg('Please Select Tag Registration Lab');
                     jQuery("#ddlTagProcessingLab").focus();
                     return;
                 }

                 if (event.keyCode === $.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 jQuery("#hdMarket").val('');
             })
             .autocomplete({
                 autoFocus: true,
                 source: function (request, response) {
                     jQuery.getJSON("EnrolmentMaster.aspx?cmd=GetTestList", {
                         SearchType: jQuery('input:radio[name=rblMarketSearchtype]:checked').val(),

                         TestName: extractLast(request.term)
                     }, response);
                 },
                 search: function () {
                     var term = extractLast(this.value);
                     if (term.length < 2) {
                         return false;
                     }
                 },
                 focus: function () {
                     return false;
                 },
                 select: function (event, ui) {
                     jQuery("#hdMarket").val(ui.item.id);
                     this.value = '';
                     AddMarketItem(ui.item.value);
                     return false;
                 },
             });
        function extractLast(term) {
            return term;
        }

        function AddMarketItem(ItemID) {
            if (ItemID == '') {
                showerrormsg("Please Select Investigation...");
                return false;
            }


            jQuery.ajax({
                url: "EnrolmentMaster.aspx/getMarketItemMaster",
                data: '{ ItemID:"' + ItemID + '",TagProcessingID:"' + jQuery('#ddlTagProcessingLab').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    marketTestData = $.parseJSON(result.d);
                    if (marketTestData.length == 0) {
                        alert('No Record Found..!');
                        return;
                    }
                    else {
                        var inv = marketTestData[0].ItemID;
                        if (jQuery.inArray(ItemID, marketInvList) != -1) {
                            showerrormsg("item Already in List..!");
                            return;
                        }
                        marketInvList.push(marketTestData[0].ItemID);
                        if (jQuery('#tblMarketingTest tr:not(#trMarketingTest)').length == 0)
                            jQuery('#tblMarketingTest,#divMarketingTest').show();


                        var mydata = [];

                        mydata.push("<tr id='" + marketTestData[0].ItemID + "' class='GridViewItemStyle' >");
                        mydata.push('<td class="MarketInv" id=' + marketTestData[0].ItemID + ' style="text-align: center"> ');
                        mydata.push('<a href="javascript:void(0);" onclick="deleteMarketItem($(this));"><img class="img_MarketDelete" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
                        mydata.push(' </td>');
                        mydata.push('<td id="tdTestCode" style="font-weight:bold;">' + marketTestData[0].TestCode + '</td>');
                        mydata.push('<td id="tdItemName" style="font-weight:bold;">' + marketTestData[0].TestName + '</td>');


                        mydata.push('<td id="tdFromDate" style="text-align: center"><input type="text" onclick="chkFromDate(this)"  onmousedown="chkFromDate(this)" readonly="readonly"  style="width:86px;" autocomplete="off"  id="txtFromDate_' + marketTestData[0].ItemID + '" value="" /></td>');
                        mydata.push('<td id="tdToDate" style="text-align: center"><input type="text" onclick="chkToDate(this)"  onmousedown="chkToDate(this)" readonly="readonly"  style="width:86px;" autocomplete="off"  id="txtToDate_' + marketTestData[0].ItemID + '" value="" /></td>');
                        mydata.push('<td id="tdMarketMRP" style="text-align: center">' + marketTestData[0].MRP + '</td>');

                        mydata.push('<td id="tdOfferMRP" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtOfferMRP" value="" onkeypress="return checkNumeric(event,this);"/></td>');
                        mydata.push('<td id="tdMarketPCCShare" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off" onkeypress="return checkNumeric(event,this);" id="txtMarketPCCShare" value="" onkeyup="chkMarketPCCShare(this)" /></td>');



                        mydata.push('<td id="tdMarketIsNewTest" style="font-weight:bold;display:none" class="clMarketIsNewTest">1</td>');
                        mydata.push('<td id="tdMarketItemID" style="font-weight:bold;display:none">' + marketTestData[0].ItemID + '</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join(" ");

                        jQuery('#tblMarketingTest').append(mydata);
                        jQuery('#tblMarketingTest').css('display', 'block');



                    }

                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });
        }
        function deleteMarketItem(row) {
            var $tr = jQuery(row).closest('tr');
            var RmvInv = $tr.find('.MarketInv').attr("id").split(',');
            var len = RmvInv.length;
            marketInvList.splice(jQuery.inArray(RmvInv[0], marketInvList), len);
            row.closest('tr').remove();
            if (jQuery('#tblMarketingTest tr:not(#trMarketingTest)').length == 0) {
                jQuery('#tblMarketingTest,#divMarketingTest').hide();
            }

        }

        function chkMarketPCCShare(rowID) {
            if (jQuery(rowID).val() > 100) {
                jQuery(rowID).val('');
                jQuery(rowID).focus();
                showerrormsg('Enter Valid PCC Share(%)');

            }
        }
        function CompareFromToDate(FromDate, ToDate) {
            var con = 0;
            jQuery.ajax({
                url: "EnrolmentMaster.aspx/CompareFromToDate",
                data: '{ FromDate:"' + FromDate + '",ToDate:"' + ToDate + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    con = result.d;
                }

            });
            return con;
        }
        function chkFromDate(rowid) {

            var ItemID = $(rowid).closest('tr').find("#tdMarketItemID").text();
            jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).show();
            jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: jQuery('#lblCurrentDate').text(),
                onSelect: function (dateText, inst) {
                    jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val(dateText);
                },
                onClose: function (dateText, inst) {
                    if (jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val() != "" && jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val() != "") {

                        var con = CompareFromToDate(jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val(), jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val());

                        if (con == "0") {
                            showerrormsg('Please Select Valid From Date');
                            jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val('');
                        }
                    }



                }

            });


        }
        function chkToDate(rowid) {

            var ItemID = $(rowid).closest('tr').find("#tdMarketItemID").text();
            jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).show();
            jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).datepicker({
                changeYear: true,
                dateFormat: 'dd-M-yy',
                changeMonth: true,
                buttonImageOnly: true,
                minDate: jQuery('#lblCurrentDate').text(),
                onSelect: function (dateText, inst) {
                    jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val(dateText);
                },
                onClose: function (dateText, inst) {
                    if (jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val() != "" && jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val() != "") {

                        var con = CompareFromToDate(jQuery(rowid).closest('tr').find('#txtFromDate_' + ItemID).val(), jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val());
                        if (con == "0") {
                            showerrormsg('Please Select Valid To Date');
                            jQuery(rowid).closest('tr').find('#txtToDate_' + ItemID).val('');
                        }
                    }
                }

            });


        }

        function onSucessDate(result) {
            return result;
        }
        function onFailureDate(result) {

        }

        function getMarketingTest(EnrollID) {
            PageMethods.bindMarketingTest(EnrollID, onSucessMarketingTest, onFailureMarketingTest);

        }
        function onSucessMarketingTest(result) {
            MarketingTest = jQuery.parseJSON(result);
            
            if (MarketingTest != null) {
                for (var a = 0; a <= MarketingTest.length - 1; a++) {
                    marketInvList.push(MarketingTest[a].ItemID);
                    if (jQuery('#tblMarketingTest tr:not(#trMarketingTest)').length == 0)
                        jQuery('#tblMarketingTest,#divMarketingTest').show();


                    var mydata = [];

                    mydata.push("<tr id='" + MarketingTest[a].ItemID + "' class='GridViewItemStyle' >");
                    mydata.push('<td class="MarketInv" id=' + MarketingTest[a].ItemID + ' style="text-align: center"> ');
                    mydata.push('<a href="javascript:void(0);" onclick="deleteMarketItem($(this));"><img class="img_MarketDelete" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
                    mydata.push(' </td>');
                    mydata.push('<td id="tdTestCode" style="font-weight:bold;">' + MarketingTest[a].TestCode + '</td>');
                    mydata.push('<td id="tdItemName" style="font-weight:bold;">' + MarketingTest[a].TestName + '</td>');


                    mydata.push('<td id="tdFromDate" style="text-align: center"> ');
                    mydata.push("<input type='text' onclick='chkFromDate(this)'  onmousedown='chkFromDate(this)' readonly='readonly'  style='width:86px;' autocomplete='off'  id='txtFromDate_" + MarketingTest[a].ItemID + "' value='" + MarketingTest[a].FromDate + "' /></td>");

                    mydata.push('<td id="tdToDate" style="text-align: center"> ');
                    mydata.push("<input type='text' onclick='chkToDate(this)'  onmousedown='chkToDate(this)' readonly='readonly'  style='width:86px;' autocomplete='off'  id='txtToDate_" + MarketingTest[a].ItemID + "' value='" + MarketingTest[a].ToDate + "'/></td>");

                    mydata.push('<td id="tdMarketMRP" style="text-align: center">' + MarketingTest[a].MRP + '</td>');

                    mydata.push('<td id="tdOfferMRP" style="text-align: center">');
                    mydata.push("<input type='text' style='width:70px;' autocomplete='off'  id='txtOfferMRP' autocomplete='off'  onkeypress='return checkNumeric(event,this);'  value='" + MarketingTest[a].OfferMRP + "'/></td>");

                    mydata.push('<td id="tdMarketPCCShare" style="text-align: center">');
                    mydata.push("<input type='text' style='width:70px;' autocomplete='off'  id='txtMarketPCCShare' autocomplete='off'  onkeypress='return checkNumeric(event,this);'  value='" + MarketingTest[a].PCCSharePer + "' onkeyup='chkMarketPCCShare(this)' /></td>");



                    mydata.push('<td id="tdMarketIsNewTest" style="font-weight:bold;display:none" class="clMarketIsNewTest">0</td>');
                    mydata.push('<td id="tdMarketItemID" style="font-weight:bold;display:none">' + MarketingTest[a].ItemID + '</td>');
                    mydata.push("</tr>");
                    mydata = mydata.join(" ");

                    jQuery('#tblMarketingTest').append(mydata);
                    jQuery('#tblMarketingTest').css('display', 'block');
                }
               
            }
            else {

            }
            if (jQuery.trim(jQuery("#lblIsView").text()) != "") {
                jQuery('input[id*=chkSelect]').prop('disabled', false);
                jQuery("#tblMarketingTest :input").attr("disabled", "disabled");
                jQuery(".img_MarketDelete").hide();
            }
        }
        function onFailureMarketingTest(result) {

        }

        function PCCMarketingCampaign() {
            var dataMarketingCampaign = new Array();
            var objMarketingCampaign = new Object();
            if (jQuery("#ddlType option:selected").text() == "PCC") {
                jQuery("#tblMarketingTest tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "trMarketingTest") {
                        if ($rowid.find(".img_MarketDelete").is(':visible')) {
                            objMarketingCampaign.ItemID = $rowid.find("#tdMarketItemID").text();
                            objMarketingCampaign.FromDate = $rowid.find('#txtFromDate_' + $rowid.find("#tdMarketItemID").text()).val();
                            objMarketingCampaign.ToDate = $rowid.find('#txtToDate_' + $rowid.find("#tdMarketItemID").text()).val();
                            objMarketingCampaign.MRP = $rowid.find("#tdMarketMRP").text();
                            objMarketingCampaign.OfferMRP = $rowid.find("#txtOfferMRP").val();
                            objMarketingCampaign.PCCSharePer = $rowid.find("#txtMarketPCCShare").val();

                            dataMarketingCampaign.push(objMarketingCampaign);
                            objMarketingCampaign = new Object();
                        }
                    }
                });
            }
            return dataMarketingCampaign;
        }
    </script>

    <script type="text/javascript">
        var HLMPackageData = [];
        function clearHLMItem() {
            jQuery("#txtHLMItemName").val('');
        }
        jQuery("#txtHLMItemName")
              .bind("keydown", function (event) {
                  if (jQuery("#ddlTagProcessingLab").val() == "-1") {
                      showerrormsg('Please Select Tag Registration Lab');
                      jQuery("#ddlTagProcessingLab").focus();
                      return;
                  }
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  jQuery("#HLMHiddenItemID").val('');
              })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("EnrolmentMaster.aspx?cmd=GetTestList", {
                          SearchType: jQuery('input:radio[name=rblHLMType]:checked').val(),
                          TestName: extractHLMItem(request.term)
                      }, response);
                  },
                  search: function () {
                      var term = extractHLMItem(this.value);
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      return false;
                  },
                  select: function (event, ui) {
                      jQuery("#HLMHiddenItemID").val(ui.item.id);
                      this.value = '';
                      AddHLMPackageItem(ui.item.value);
                      return false;
                  },
              });
        function extractHLMItem(term) {
            return term;
        }
        function AddHLMPackageItem(ItemID) {
            if (ItemID == '') {
                showerrormsg("Please Select Investigation...");
                return false;
            }
            
            jQuery.ajax({
                url: "EnrolmentMaster.aspx/getHLMPackage",
                data: '{ ItemID:"' + ItemID + '",TagProcessingID:"' + jQuery("#ddlTagProcessingLab").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    HLMPackageItem = jQuery.parseJSON(result.d);
                    if (HLMPackageItem.length == 0) {
                        alert('No Record Found..!');
                        return;
                    }
                    else {
                        var inv = HLMPackageItem[0].ItemID;
                        if (jQuery.inArray(ItemID, HLMPackageData) != -1) {
                            showerrormsg("item Already in List..!");
                            return;
                        }
                        HLMPackageData.push(HLMPackageItem[0].ItemID);
                        if (jQuery('#tblHLMItemTest tr:not(#InvHLMItemHeader)').length == 0)
                            jQuery('#tblHLMItemTest,#divHLMItem').show();


                        var mydata = [];

                        mydata.push("<tr id='" + HLMPackageItem[0].ItemID + "' class='GridViewItemStyle' >");
                        mydata.push('<td class="HLMPackageInv" id=' + HLMPackageItem[0].ItemID + ' style="text-align: center"> ');
                        mydata.push('<a href="javascript:void(0);" onclick="deleteHLMItem($(this));"><img class="img_HLMPackage" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
                        mydata.push(' </td>');
                        mydata.push('<td id="tdHLMTestCode" style="font-weight:bold;">' + HLMPackageItem[0].TestCode + '</td>');
                        mydata.push('<td id="tdHLMItemName" style="font-weight:bold;">' + HLMPackageItem[0].TestName + '</td>');                        
                        mydata.push('<td id="tdHLMMRP" style="text-align: center">' + HLMPackageItem[0].MRP + '</td>');
                        mydata.push('<td id="tdHLMPackageItemID" style="text-align: center;display:none">' + HLMPackageItem[0].ItemID + '</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join(" ");                       
                        jQuery('#tblHLMItemTest').append(mydata);
                        jQuery('#tblHLMItemTest').css('display', 'block');
                    }                  
                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });
        }        
        function closeHLMPackage() {
            $find('mpHLMPackage').hide();
            jQuery('#txtHLMPackageName').val('');
            jQuery("#txtHLMItemName").val('');
        }
        function deleteHLMItem(row) {
            var $tr = jQuery(row).closest('tr');
            var RmvInv = $tr.find('.HLMPackageInv').attr("id").split(',');
            var len = RmvInv.length;
            HLMPackageItem.splice(jQuery.inArray(RmvInv[0], HLMPackageItem), len);
            row.closest('tr').remove();
            if (jQuery('#tblHLMItemTest tr:not(#trMarketingTest)').length == 0) {
                jQuery('#tblHLMItemTest,#divMarketingTest').hide();
            }               
        }
        function addHLMPackage() {
            if (jQuery('#txtHLMPackageName').val() == "") {
                showerrormsg('Please Enter Package Name');
                jQuery('#txtHLMPackageName').focus();
                return;
            }
            if (jQuery('#tblHLMItemTest tr:not(#InvHLMItemHeader)').length == 0) {
                jQuery('#txtHLMItemName').focus();
                showerrormsg('Please Add Test');
                return;
            }
            var HLMMRP = 0; var ItemID = ""; var chkPackagName = 0;

            jQuery("#tblHLMPackageTest tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "trHLMPackageHeader") {
                    if (jQuery.trim(jQuery('#txtHLMPackageName').val()) == jQuery.trim(jQuery(this).closest("tr").find("#tdHLMPackageName").text())) {
                        chkPackagName = 1;
                    }
                }
            });
            if (chkPackagName == "1") {
                jQuery('#txtHLMPackageName').focus();
                showerrormsg('Package Name Already Added');
                return;
            }
            jQuery("#tblHLMItemTest tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");

                if (id != "InvHLMItemHeader") {
                    HLMMRP += parseFloat(jQuery(this).closest("tr").find("#tdHLMMRP").text());
                    
                    if (ItemID == "") {
                        ItemID = jQuery(this).closest("tr").find("#tdHLMPackageItemID").text();

                    }
                    else {
                        ItemID += "".concat(",", jQuery(this).closest("tr").find("#tdHLMPackageItemID").text());



                    }
                }

            });
            
            if (jQuery('#tblHLMPackageTest tr:not(#trHLMPackageHeader)').length == 0) {
                jQuery('#tblHLMPackageTest,#divHLMPackage').show();
            }
            var SNo = jQuery('#tblHLMPackageTest tr:not(#trHLMPackageHeader)').length;

            var mydata = [];

            mydata.push("<tr  class='GridViewItemStyle' >");
            mydata.push('<td  style="text-align: center"> ');
            mydata.push('<a href="javascript:void(0);" onclick="deleteHLMPackage($(this));"><img class="img_HLMPackage" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
            mydata.push(' </td>');
            mydata.push('<td id="tdHLMPackageName" style="font-weight:bold;">' + jQuery("#txtHLMPackageName").val() + '</td>');            
            mydata.push('<td id="tdHLMTestWiseRate" style="font-weight:bold;text-align:right">' + HLMMRP + '</td>');
            mydata.push('<td id="tdHLMPatientRate" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off"  id="txtHLMPatientRate" value="" onkeypress="return checkNumeric(event,this);"/></td>');


            mydata.push('<td id="tdHLMPackageType" style="text-align: center">');
            mydata.push('<input type="radio" title="Gross Price" name="HLMPackage_' + SNo + '" id="rbHLMPackageGrossPrice" value="Gross" onclick="chkHLMPackageNet(this)"/>Gross');
            mydata.push('<input type="radio" title="Net Price" name="HLMPackage_' + SNo + '" id="rbHLMPackageNetPrice" checked="checked" value="Net" onclick="chkHLMPackageNet(this)" />Net');
            mydata.push('</td>');

            mydata.push('<td id="tdPackageNetAmt" style="text-align: center"><input type="text" style="width:70px;" autocomplete="off" onkeypress="return checkNumeric(event,this);" id="txtPackageNetAmt" value=""  /></td>');
            mydata.push('<td id="tdHLMTestWiseView" style="font-weight:bold;text-align: center">');
            mydata.push('<img style="width: 15px; cursor:pointer" src="../../App_Images/view.gif" onclick="viewPackageItem(this)" title="Click to View Test" />');
            mydata.push('</td>');
            mydata.push('<td id="tdHLMPackageAllItemID" style="text-align: center;display:none">' + ItemID + '</td>');
            mydata.push('<td id="tdHLMPackageID" style="text-align: center;display:none">0</td>');

            mydata.push("</tr>");
            mydata = mydata.join(" ");


            jQuery('#tblHLMPackageTest').append(mydata);
            jQuery('#tblHLMPackageTest').css('display', 'block');

            jQuery('#tblHLMItemTest tr:not(#InvHLMItemHeader)').remove();
            jQuery('#tblHLMItemTest,#divMarketingTest').hide();
            jQuery('#txtHLMPackageName,#txtHLMItemName').val('');
            HLMPackageData = [];
        }
        function deleteHLMPackage(row) {
            var $tr = $(row).closest('tr');
          
            row.closest('tr').remove();
            if (jQuery('#tblHLMPackageTest tr:not(#trHLMPackageHeader)').length == 0) {
                jQuery('#tblHLMPackageTest,#divHLMPackage').hide();
            }
        }
        
        function chkHLMPackageNet(rowID) {           
            if (jQuery(rowID).closest("tr").find("#rbHLMPackageGrossPrice").is(':checked')) {
                jQuery(rowID).closest("tr").find("#txtPackageNetAmt").attr('disabled', 'disabled');
                jQuery(rowID).closest("tr").find("#txtPackageNetAmt").val('');
            }            
            else {
                jQuery(rowID).closest("tr").find("#txtPackageNetAmt").removeAttr('disabled');
            }
        }
        function HLMPackage() {
            var dataHLMPackage = new Array();
            var objHLMPackage = new Object();
            if (jQuery("#ddlType option:selected").text() == "HLM") {
              
                jQuery("#tblHLMPackageTest tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "trHLMPackageHeader") {
                       
                        objHLMPackage.PackageName = $rowid.find("#tdHLMPackageName").text();
                        objHLMPackage.ItemID = $rowid.find("#tdHLMPackageAllItemID").text();
                        objHLMPackage.PatientRate = $rowid.find("#txtHLMPatientRate").val();
                        if ($rowid.find("#rbHLMPackageGrossPrice").is(':checked')) {
                            objHLMPackage.ShareType = "Gross";
                            objHLMPackage.NetAmount = 0;
                        }
                        else {
                            objHLMPackage.ShareType = "Net";
                            objHLMPackage.NetAmount = $rowid.find("#txtPackageNetAmt").val();
                        }

                       
                       
                        objHLMPackage.TestWiseMRP = $rowid.find("#tdHLMTestWiseRate").text();
                        objHLMPackage.HLMPackageID = $rowid.find("#tdHLMPackageID").text();
                        
                        dataHLMPackage.push(objHLMPackage);
                        objHLMPackage = new Object();
                    }

                });

            }
            return dataHLMPackage;
        }

        function getHLMPackage(EnrollID) {

            PageMethods.bindHLMPackageTest(EnrollID, onSucessHLMPackage, onFailureHLMPackage);

        }
        function onSucessHLMPackage(result) {
            getHLMPackageData = jQuery.parseJSON(result);

            if (getHLMPackageData != null) {
                for (var a = 0; a <= getHLMPackageData.length - 1; a++) {
                  
                    if (jQuery('#tblHLMPackageTest tr:not(#trHLMPackageHeader)').length == 0)
                        jQuery('#tblHLMPackageTest,#divMarketingTest').show();

                    
                    var mydata = [];
                    
                    mydata.push("<tr  class='GridViewItemStyle' >");
                    mydata.push('<td  style="text-align: center"> ');
                    mydata.push('<a href="javascript:void(0);" onclick="deleteHLMPackage($(this));"><img class="img_HLMPackage" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a>');
                    mydata.push(' </td>');
                    mydata.push('<td id="tdHLMPackageName" style="font-weight:bold;">' + getHLMPackageData[a].PackageName + '</td>');
                    mydata.push('<td id="tdHLMTestWiseRate" style="font-weight:bold;text-align:right">' + getHLMPackageData[a].TestWiseMRP + '</td>');

                    mydata.push('<td id="tdHLMPatientRate" style="text-align: center">');
                    mydata.push("<input type='text' style='width:70px;' autocomplete='off'  id='txtHLMPatientRate' autocomplete='off'  onkeypress='return checkNumeric(event,this);'  value='" + getHLMPackageData[a].PatientRate + "'  /></td>");


                    mydata.push('<td id="tdHLMPackageType" style="text-align: center">');
                    mydata.push('<input type="radio" title="Gross Price" name="HLMPackage_' + a + '" id="rbHLMPackageGrossPrice" value="Gross"  onclick="chkHLMPackageNet(this)"');
                    if (getHLMPackageData[a].ShareType == "Gross")
                        mydata.push(' checked="checked" ');
                    mydata.push(' />Gross');

                    mydata.push('<input type="radio" title="Net Price" name="HLMPackage_' + a + '" id="rbHLMPackageNetPrice"  value="Net" onclick="chkHLMPackageNet(this)" ');
                    if (getHLMPackageData[a].ShareType == "Net")
                        mydata.push(' checked="checked" ');                                      
                    mydata.push('/>Net');

                    mydata.push('</td>');
                    mydata.push('<td id="tdPackageNetAmt" style="text-align: center">');
                    mydata.push("<input type='text' style='width:70px;' autocomplete='off'  id='txtPackageNetAmt' autocomplete='off'  onkeypress='return checkNumeric(event,this);'  value='" + getHLMPackageData[a].NetAmount + "'  ");

                    if (getHLMPackageData[a].ShareType == "Gross")
                        mydata.push(' disabled="disabled" />');
                    else
                        mydata.push(' />');
                        mydata.push('</td>');
                        mydata.push('<td id="tdHLMTestWiseView" style="font-weight:bold;text-align: center">');
                    mydata.push('<img style="width: 15px; cursor:pointer" src="../../App_Images/view.gif" onclick="viewPackageItem(this)" title="Click to View Test" />');
                    mydata.push('</td>');


                    mydata.push('<td id="tdHLMPackageAllItemID" style="text-align: center;display:none">' + getHLMPackageData[a].ItemID + '</td>');
                    mydata.push('<td id="tdHLMPackageID" style="text-align: center;display:none">' + getHLMPackageData[a].ID + '</td>');
                    mydata.push("</tr>");
                    mydata = mydata.join(" ");



                    jQuery('#tblHLMPackageTest').append(mydata);
                    jQuery('#tblHLMPackageTest').css('display', 'block');

                    jQuery('#tblHLMItemTest,#divMarketingTest').hide();
                    jQuery('#txtHLMPackageName,#txtHLMItemName').val('');
                }

            }
            else {

            }
            if (jQuery.trim(jQuery("#lblIsView").text()) != "") {
              
                jQuery("#tblHLMPackageTest :input").attr("disabled", "disabled");
                jQuery(".img_HLMPackage,#btnAddPackage").hide();
            }
        }
        function onFailureHLMPackage() {

        }
    </script>

    <asp:Button ID="btnPackageView" runat="server" Style="display:none" OnClientClick="JavaScript: return false;"/>
    <cc1:ModalPopupExtender ID="mpPackageView" runat="server"
                            DropShadow="true" TargetControlID="btnPackageView"   CancelControlID="imgClosePackageView" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlPackageView"    BehaviorID="mpPackageView">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlPackageView" runat="server" Style="display: none;width:580px; height:430px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>                                      
                    <td  style="text-align:right">      
                        <img id="imgClosePackageView" runat="server" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closePackageView()" />  
                    </td>                    
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse">               
                  <tr>
                      <td>
            <div id="divPackageView" style="text-align:center;width: 99%; max-height:400px;overflow-y:scroll;">                
            </div>                 
                      </td>
                  </tr>

                      
                </table>    
       
    </asp:Panel>
    <script type="text/javascript">
        
        function closePackageView() {
            $find('mpPackageView').hide();
        }

        function viewPackageItem(rowID) {
            PageMethods.viewHLMPackageTest(jQuery(rowID).closest('tr').find('#tdHLMPackageID').text(), jQuery(rowID).closest('tr').find('#tdHLMPackageAllItemID').text(), onSuccessviewPackage, OnfailureviewPackage);
        }
        function onSuccessviewPackage(result) {
            PackageViewData = jQuery.parseJSON(result);
            var output = jQuery('#tb_PackageView').parseTemplate(PackageViewData);
            jQuery('#divPackageView').html(output);
            $find('mpPackageView').show();
        }
        function OnfailureviewPackage(result) {

        }
        function closeGroupTest() {
            jQuery('#div_GroupTest').html('');
            $find('mpGroupTest').hide();
        }
    </script>
      <script id="tb_PackageView" type="text/html">      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblPackageView" style="border-collapse:collapse;width:500px;"> 
            <thead>
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Code</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:360px;">Item Name</th>						                 
        </tr>
                </thead>
       <#      
              var dataLength=PackageViewData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = PackageViewData[j];
                 #>            
            <tr>                                 
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>                
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TestCode#></td>
            <td  class="GridViewLabItemStyle" id="td1" style="text-align:left;"><#=objRow.ItemName#></td>               
                                         
            </tr>                 
      <#}#>
        </table>    
    </script> 

    <script type="text/javascript">
        function showSaveErrorMsg(msg) {
            jQuery('#errorMsg').html('');
            jQuery('#errorMsg').append(msg);
            jQuery(".alertMsg").css('background-color', 'red');
            jQuery(".alertMsg").removeClass("in").show();
            jQuery(".alertMsg").delay(1500).addClass("in").fadeOut(1000);
        }
       
    </script>
        

</asp:Content>



