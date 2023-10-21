<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ManageInvestigation.aspx.cs" Inherits="Design_Investigation_ManageInvestigation" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--<%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>--%>

    <style type="text/css">
        .jscoin-tabs ul li a {
            background-color: whitesmoke;
            color: black;
        }
    </style>

    <%-- filter search End --%>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Investigation Master</b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <div class="Purchaseheader" id="Div2" runat="server">
                Manage Investigations
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="height: 470px;">
            <div class="row">
                <div class="col-md-4">
                    <input id="chkNewInv" type="checkbox" />
                    New Investigation
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="ChkInActive" runat="server" AutoPostBack="True"
                        OnCheckedChanged="ChkInActive_CheckedChanged" Text="InActive test" />
                </div>
                <div class="col-md-3">
                    <input type="radio" checked="checked" name="chkSearchType" value="1" />Search By Name
                </div>
                <div class="col-md-3">
                    <input type="radio" name="chkSearchType" value="2" />Search by Code
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtSearchInv" placeholder="Type To Search" runat="server" OnKeyUp="Click(this);"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div id="div_InvNameHead" style="font-size: medium; font-weight: bold;"></div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <fieldset class="f1" style="Height: 410px">
                        <legend class="lgd" style="font-weight: bold">Search Investigations</legend>
                        <asp:DropDownList ID="ddlDepartment" runat="server" Style="" onChange="BindListBox(this.value);" >
                        </asp:DropDownList>
                        <br />
                        <br />
                        <asp:ListBox ID="ListBox2" runat="server" Style="display: none;"></asp:ListBox>
                        <asp:ListBox ID="lstInvestigation" runat="server" class="navList" onChange="loadDetail(this.value);" 
                            Height="340px"></asp:ListBox>
                    </fieldset>
                </div>
                <div class="col-md-8">
                    <fieldset class="f1" style="vertical-align: top; height: 410px;">
                        <legend class="lgd" style="font-weight: bold">Investigation Detail</legend>
                        <div class="row">
                            <div class="row" style="height: 310px; overflow: auto;">
                                <div class="col-md-12">
                                    Department:
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList
                                        ID="ddlGroupHead" runat="server">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12" style="color: red;">
                                    Investigation Name:
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtInv" runat="server" Font-Bold="true" CssClass="ItDoseTextinputText"
                                        MaxLength="100"></asp:TextBox>
                                </div>
                                <div class="col-md-12">
                                    Investigation Code:
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtTestCode" runat="server" Font-Bold="true" CssClass="ItDoseTextinputText"
                                        MaxLength="100"></asp:TextBox>
                                </div>
                                <div class="col-md-12">
                                    InvestigationShortName:
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtShortName" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>
                                    <asp:TextBox ID="txtRate" runat="server" CssClass="ItDoseTextinputText"
                                        MaxLength="5" Style="display: none;"></asp:TextBox>
                                </div>
                                <div class="col-md-12">
                                    Investigation Type:
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlinvtype" runat="server">
                                        <asp:ListItem Value="Investigation">Investigation</asp:ListItem>
                                        <asp:ListItem Value="Profile">Profile</asp:ListItem>

                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12">
                                    Booking For:
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlGender" runat="server">
                                        <asp:ListItem Value="B">Both</asp:ListItem>
                                        <asp:ListItem Value="M">Male</asp:ListItem>
                                        <asp:ListItem Value="F">female</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12">
                                    Age Group (In Days):
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtfromage" Text="0" runat="server" placeholder="From Age"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtfromage">
                                    </cc1:FilteredTextBoxExtender>

                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txttoage" Text="36500" runat="server" placeholder="To Age"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txttoage">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-12 lmp" style="color: red;">
                                    LMP (In Days):
                                </div>
                                <div class="col-md-6 lmp">
                                    <asp:TextBox ID="txtLMPFromDay" Text="0" runat="server" placeholder="From LMP"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" TargetControlID="txtLMPFromDay">
                                    </cc1:FilteredTextBoxExtender>

                                </div>
                                <div class="col-md-6 lmp">
                                    <asp:TextBox ID="txtLMPToDay" Text="0" runat="server" placeholder="To LMP"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers" TargetControlID="txtLMPToDay">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-12">
                                    Report Type:
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlReportType" runat="server" onchange="setsampledefine()">
                                        <asp:ListItem Value="1">Path Numeric</asp:ListItem>
                                        <asp:ListItem Value="3">Path RichText</asp:ListItem>
                                                  <asp:ListItem Value="5">Radiology</asp:ListItem>
                                       <%-- <asp:ListItem Value="11">Radiology Word </asp:ListItem>--%>
                                        <asp:ListItem Value="7">Histo Report</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12">
                                    Billing Category:
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlBillingCategory" runat="server">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-12">
                                    AutoConsume :
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlautoconsume" runat="server">
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                        <asp:ListItem Value="1">Investigation Wise</asp:ListItem>
                                        <asp:ListItem Value="2">Observation Wise</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12" style="display: none">
                                    Concern Form:
                                </div>
                                <div class="col-md-12" style="display: none">
                                    <asp:DropDownList ID="ddlConcernFormType" runat="server">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12">
                                    Test Repeat Alert: 
                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddllabalert" runat="server">
                                        <asp:ListItem Value=""></asp:ListItem>
                                        <asp:ListItem Value="1 Week">1 Week</asp:ListItem>
                                        <asp:ListItem Value="2 Week">2 Week</asp:ListItem>
                                        <asp:ListItem Value="3 Week">3 Week</asp:ListItem>
                                        <asp:ListItem Value="4 Week">4 Week</asp:ListItem>
                                        <asp:ListItem Value="1 Month">1 Month</asp:ListItem>
                                        <asp:ListItem Value="2 Month">2 Month</asp:ListItem>
                                        <asp:ListItem Value="3 Month">3 Month</asp:ListItem>
                                        <asp:ListItem Value="4 Month">4 Month</asp:ListItem>
                                        <asp:ListItem Value="5 Month">5 Month</asp:ListItem>
                                        <asp:ListItem Value="6 Month">6 Month</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-12">
                                    Base Rate: 
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtBaseRate" runat="server"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtBaseRate">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-12">
                                    Std Rate: 
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtstdrate" runat="server" ReadOnly="true"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Numbers" TargetControlID="txtstdrate">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-24">
                                    <asp:TextBox ID="txtsms" runat="server" placeholder="SMS ON Alert"></asp:TextBox>
                                </div>
                                <div class="col-md-12" style="font-weight: 500">
                                    Attachment Reqd. at

                                </div>
                                <div class="col-md-12">
                                    <asp:DropDownList ID="ddlAttachmentReqd" runat="server">
                                        <asp:ListItem Text="Work Order" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Dept. Receive" Value="2"></asp:ListItem>

                                    </asp:DropDownList>
                                </div>
                               


                            </div>
                            <div class="col-md-13" style="font-weight: 700">
                                Required Attachment:
                            </div>
                            <div class="col-md-11">
                                <asp:TextBox onkeyup="SearchEmployees1(this,'#chkdocument');" ID="TextBox1" runat="server" placeholder="Search Attachment"></asp:TextBox>
                            </div>
                            <div class="col-md-24" style="height: 43px; overflow: auto;">
                                <asp:CheckBoxList runat="server" OnDataBound="chkdocument_DataBound" ID="chkdocument" RepeatDirection="Horizontal" RepeatColumns="2" ClientIDMode="Static"></asp:CheckBoxList>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="col-md-7">
                    <fieldset class="f1" style="height: 410px;">
                        <legend class="lgd" style="font-weight: bold">Sample Detail</legend>
                        <div class="row">
                            <div class="col-md-12">
                                Sample Option:
                            </div>
                            <div class="col-md-12">
                                <asp:DropDownList ID="ddlType" runat="server" onchange="hide()">
                                    <asp:ListItem Value="R">Sample Required</asp:ListItem>
                                    <asp:ListItem Value="N" Selected="true">Sample Not Required</asp:ListItem>
                                    <asp:ListItem Value="S">Segregation Required</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-12">
                                Sample Qty.:
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtSampleQty" runat="server" Font-Bold="true" class="hide"
                                    MaxLength="100"></asp:TextBox>
                            </div>
                            <div class="col-md-12">
                                Sample Rmks:
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtSampleRmks" runat="server" Font-Bold="true"
                                    class="hide" MaxLength="360"></asp:TextBox>
                            </div>
                            <div class="col-md-12">
                                Logistics Temp. :
                            </div>
                            <div class="col-md-12">
                                <asp:DropDownList ID="ddltemp" runat="server">
                                    <asp:ListItem Value=""></asp:ListItem>
                                    <asp:ListItem Value="Frozen">Frozen (Dry Ice)</asp:ListItem>
                                    <asp:ListItem Value="Dry Ice">Refrigerated (2-8)</asp:ListItem>
                                    <asp:ListItem Value="Room Temp">Ambient (18-22)</asp:ListItem>
                                </asp:DropDownList>

                                <asp:DropDownList ID="ddlcolor" runat="server" Style="display: none;">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtTimelimit" runat="server" CssClass="ItDoseTextinputText"
                                    Width="100px" Style="display: none;"></asp:TextBox>
                                <asp:TextBox ID="txtmaxdiscount" runat="server" CssClass="ItDoseTextinputText"
                                    Text="100" Style="display: none;"></asp:TextBox>
                                <asp:DropDownList ID="ddlbillcat" runat="server" Style="display: none;">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-12">
                                Sample Container:
                            </div>
                            <div class="col-md-12">
                                <asp:DropDownList ID="ddlcontainer" runat="server" onchange="setsampledefine2()"></asp:DropDownList>
                            </div>
                            <div class="col-md-12">
                                Sample Type:
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox onkeyup="SearchEmployees(this,'#chkSample');" ID="txtsearchsample" runat="server" placeholder="Search Sample Type"></asp:TextBox>
                            </div>
                            <div class="col-md-24" style="clear: both; overflow: auto; height: 180px;">
                                <asp:CheckBoxList ID="chkSample" runat="server" RepeatDirection="Horizontal" RepeatColumns="1"
                                    OnDataBound="chkSample_DataBound" ClientIDMode="Static">
                                </asp:CheckBoxList>
                            </div>
                            <div class="col-md-12">
                                Default Sample Type:
                            </div>
                            <div class="col-md-12">
                                <asp:DropDownList ID="ddlSample" runat="server">
                                </asp:DropDownList>
                            </div>
                             <div class="col-md-12" style="font-weight: 500">
                                    TAT Intimate (Mins)
                                </div>
                                <div class="col-md-12">
                                    <asp:TextBox ID="txtTatIntimate" runat="server"
                                        placeholder="Enter TAT Intimate"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Numbers" TargetControlID="txtTatIntimate">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                            <div class="col-md-12" style="font-weight: 500;display:none;">
                                   Allow Test Centre Line
                                </div>
                                <div class="col-md-12" style="display:none;">
                                    <asp:DropDownList runat="server" ID="ddlprintcentre">
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem></asp:DropDownList>
                                </div>
                        </div>
                    </fieldset>
                </div>
                <div class="col-md-4">
                    <fieldset class="f1" style="vertical-align: top; height: 410px;">


                        <legend class="lgd" style="font-weight: bold">Other Detail</legend>
                        <div class="row" style="height: 370px; overflow: auto;">
                            <div class="col-md-24">
                                <asp:CheckBox ID="ChkIsActive" runat="server" Text="IsActive" Checked="true" ForeColor="#FF3333" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkreporting" runat="server" Text="Reporting" class="chk" Checked="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkprntsmplnme" runat="server" Text="PrintSampleName" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkbooking" runat="server" Text="Booking" class="chk" Checked="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkShowPtRpt" runat="server" Text="Show in Patient Report "
                                    class="chk" Checked="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkShowAnlysRpt" runat="server" Text="Show in Analysis Report"
                                    class="chk" Checked="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkShowOnlnRpt" runat="server" Text="Show in Online Report" class="chk"
                                    Checked="true" />
                            </div>
                                  <div class="col-md-24">
                                <asp:CheckBox ID="chkShowinRatelist" runat="server" Text="Show in RateList" class="chk"
                                    Checked="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkIsAutoStore" runat="server" Text="IsAutoSave" class="chk" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="ChkisUrgent" runat="server" Text="Urgent" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkIPrintSeparate" runat="server" Text="Print Separate" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkisorganism" runat="server" Text="IsOrganism" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkisculturereport" runat="server" Text="IsCultureReport" onclick="setsampledefine1()" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkisMic" runat="server" Text="IsMic" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkIsOutSource" runat="server" Text="IsOutSource" class="chk" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ToolTip="Uncheck for Micro and Histo Test" ID="chksampledefine" Checked="true" runat="server" Text="Sample Defined" class="chk" Font-Bold="true" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkIsLMPRequired" runat="server" Text="IsLMPRequired" class="chk" onclick="showHide()" />
                            </div>
                            <div class="col-md-24">
                                <asp:CheckBox ID="chkIsQuantity" runat="server" Text="IsQuantity" class="chk" />
                            </div>
                               <div class="col-md-24">
                                <asp:CheckBox ID="chkShowinTAT" runat="server" Text="Show In TAT" class="chk" />
                            </div>
                           
                            <div class="col-md-24">
                                <div id="Div3" style="clear: both; display: none;" runat="server">
                                    <asp:DropDownList ID="ddlOutSrcLab" runat="server" Style="display: none;"></asp:DropDownList>
                                    <label class="labelForTag" visible="false">
                                        Investigation_ID :</label>
                                    <asp:TextBox ID="txtInvestigation_ID" runat="server" CssClass="ItDoseTextinputText"
                                        MaxLength="200"></asp:TextBox>
                                    <br />
                                    <br />
                                    <label class="labelForTag" visible="false">
                                        ItemID :</label>
                                    <asp:TextBox ID="txtItemID" runat="server" CssClass="ItDoseTextinputText" MaxLength="200"></asp:TextBox><br />
                                    <br />
                                    <label class="labelForTag">
                                        Print Sequence :</label><asp:TextBox ID="txtPrintSeq" runat="server" CssClass="ItDoseTextinputText"
                                            MaxLength="20"></asp:TextBox>
                                    <br />
                                    <br />
                                    <label class="labelForTag" visible="false">
                                        Investigation_ObservationType_ID :</label><asp:TextBox ID="txtInvestigation_ObservationType_ID"
                                            runat="server" CssClass="ItDoseTextinputText"
                                            MaxLength="20"></asp:TextBox>
                                    <br />
                                    <br />
                                    <input type="button" id="btnObservation" value="Insert Observation" />
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input id="btnAddInv" type="button" value="Save" onclick="SaveInvestigation()" class="ItDoseButton" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" Style="display: none;" CausesValidation="false"
                    CssClass="ItDoseButton" />
        </div>
    </div>

    <div class="jscoin-tabs" style="display: none;">
        <ul id="ull" class="menu">
            <li onclick="Call(this);" id="ObservationManage.aspx#1">
                <a href='javascript:toggleMe(0)'>Observation</a>
            </li>
            <li onclick="Call(this);" id="InvComments.aspx#1">
                <a href='javascript:toggleMe(0)'>Test Comment</a>
            </li>
            <li id="AddInterpretation.aspx#1" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Test Interpretation</a>
            </li>
            <li id="InvTemplate.aspx#3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Test Templates</a>
            </li>
            <li id="labobservation_Help.aspx#1" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Help Menu</a>
            </li>
            <li id="InvestigationRole.aspx#1,3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Map Inv To Role</a>
            </li>

            <li id="InvestigationRequiredFields.aspx#1,3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Required Fields</a>
            </li>
            <li id="InvestigationConcernForm.aspx#1,3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Concern Form</a>
            </li>

            <% if (Util.GetString(Session["RoleID"]) == "6" || Util.GetString(Session["RoleID"]) == "1")
               { %>
            <li id="../Master/ItemWiseRateList.aspx#1,3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Rate List</a> </li>



            <%} %>
			<%--
            <li id="AliasMaster.aspx#1,3,5" onclick="Call(this);">
                <a href='javascript:toggleMe(0)'>Alias</a>
            </li> 
			--%>
        </ul>
    </div>
    <script type="text/javascript">
        //jQuery("#ddlType").on("blur", function () {
        //    debugger;
        //    if (jQuery('#ddlType').val().length > 0) {
        //        var =
        //        if (jQuery('#ddlType').val()){
        //            toast("Error", 'Incorrect Invoicing Email ID', '');
        //           jQuery('#ddlType').focus();
        //            return false;
        //        }
        //    }
        //});
        $validation = function () {
            if (jQuery('#ddlType').val() == "R" && jQuery('#ddlType').val() == "N") {
                toast("Error", "Please Select Sample Type", "");
                jQuery("#chkSample").focus();
                return false;
            }
        }
     </script>
    <script type="text/javascript">


        function setsampledefine() {

            if ($('#<%=ddlReportType.ClientID%>').val() == "7") {
                document.getElementById('<%=chksampledefine.ClientID %>').checked = false;
            }
            else {
                document.getElementById('<%=chksampledefine.ClientID %>').checked = true;
            }
        }

        function setsampledefine2() {

            if ($('#<%=ddlcontainer.ClientID%>').val() == "7") {
                 document.getElementById('<%=chksampledefine.ClientID %>').checked = false;
             }
             else {
                 document.getElementById('<%=chksampledefine.ClientID %>').checked = true;
             }
         }


         function setsampledefine1() {

             if ($('#<%=chkisculturereport.ClientID %>').is(':checked')) {
                 document.getElementById('<%=chksampledefine.ClientID %>').checked = false;
             }
             else {
                 document.getElementById('<%=chksampledefine.ClientID %>').checked = true;
             }
         }

         var RoleID = '<%=Session["RoleId"].ToString() %>';
        $(function () {
            if (RoleID != "177") {
                $("#<%=txtRate.ClientID %>").attr('disabled', true);
            }
        });
    </script>
    <script type="text/javascript">
        var URl = "";
        var InvestigationID = "";
        var ReportTypeNo = "";
        function loadDetail(str) {
 
            var chkbx = $("<%=ChkInActive.ClientID %>");
            if (chkbx.cheked == true) {

                $(".jscoin-tabs").hide();

            }
            else {
                $(".jscoin-tabs").show();
            }
            var val = str.split('$');

            SetSubChilds(val[4]);
            InvestigationID = val[6];

            ReportTypeNo = val[4];
            // iframe = document.getElementById("ifrm");
            //alert(iframe.src);
            // $("#ifrm").attr("src", $(this).attr("Frame.aspx?invID=" + val[6]));
            // iframe.src = 'Frame.aspx?InvID=' + val[6] + '&ReportType=' + val[4];
            // URl='Frame.aspx?InvID=' + val[6] + '&ReportType=' + val[4];
            // alert(iframe.src);

            document.getElementById('<%=ddlGroupHead.ClientID %>').value = val[0];
            document.getElementById('<%=txtInv.ClientID %>').value = val[2];
            document.getElementById('<%=ddlType.ClientID %>').value = val[3];
            document.getElementById('<%=ddlReportType.ClientID %>').value = val[4];

            $("#div_InvNameHead").html("Test Name :" + val[2] + " (Short Name : " + val[10] + ")");
            $("#div_InvNameHead").css("display", "");
            $("#div_InvNameHead").css("color", "green");

            document.getElementById('<%=txtInvestigation_ID.ClientID %>').value = val[6];
            document.getElementById('<%=txtInvestigation_ObservationType_ID.ClientID %>').value = val[7];
            document.getElementById('<%=txtItemID.ClientID %>').value = val[8];
            document.getElementById('<%=txtTimelimit.ClientID %>').value = val[9];
            document.getElementById('<%=txtShortName.ClientID %>').value = val[10];
            document.getElementById('<%=txtSampleQty.ClientID %>').value = val[12];
            document.getElementById('<%=txtSampleRmks.ClientID %>').value = val[13];
            document.getElementById('<%=ddlGender.ClientID %>').value = val[14];
            if (val[15] != '' && val[15] != 'null') {
                document.getElementById('<%=ddlcontainer.ClientID %>').value = val[15];
            }
            document.getElementById('<%=txtTestCode.ClientID %>').value = val[20];
            document.getElementById('<%=txtmaxdiscount.ClientID %>').value = val[23];
            document.getElementById('<%=ddlbillcat.ClientID %>').value = val[25];

            if (val[34] == '') {
                document.getElementById('<%=ddlautoconsume.ClientID %>').value = "0";
            }
            else {
                document.getElementById('<%=ddlautoconsume.ClientID %>').value = val[34];
            }

            // alert(val[35]);
            if (val[35] == '') {
                document.getElementById('<%=ddlBillingCategory.ClientID%>').value = "0";
            }
            else {
                document.getElementById('<%=ddlBillingCategory.ClientID%>').value = val[35];
            }
            if (val[36] == '') {
                document.getElementById('<%=ddlConcernFormType.ClientID%>').value = '';
            }
            else {
                document.getElementById('<%=ddlConcernFormType.ClientID%>').value = val[36];
            }

            if (val[37] == '') {
                document.getElementById('<%=ddllabalert.ClientID%>').value = '';
            }
            else {
                document.getElementById('<%=ddllabalert.ClientID%>').value = val[37];
            }
            if (val[38] == '') {
                $('#<%=txtsms.ClientID%>').val('');
            }
            else {
                $('#<%=txtsms.ClientID%>').val(val[38]);
            }
            if (val[39] == '') {
                document.getElementById('<%=ddltemp.ClientID%>').value = '';
            }
            else {
                document.getElementById('<%=ddltemp.ClientID%>').value = val[39];
            }
            document.getElementById('<%=txtfromage.ClientID %>').value = val[40];
            document.getElementById('<%=txttoage.ClientID %>').value = val[41];

            if (val[42] != '') {
                document.getElementById('<%=ddlinvtype.ClientID %>').value = val[42];
            }

            if (val[16] == '1')
                document.getElementById('<%=chkShowPtRpt.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkShowPtRpt.ClientID %>').checked = false;

            if (val[17] == '1')
                document.getElementById('<%=chkShowAnlysRpt.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkShowAnlysRpt.ClientID %>').checked = false;

            if (val[18] == '1')
                document.getElementById('<%=chkShowOnlnRpt.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkShowOnlnRpt.ClientID %>').checked = false;

            if (val[19] == '1')
                document.getElementById('<%=chkIsAutoStore.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkIsAutoStore.ClientID %>').checked = false;

            if (val[54] == '1')
                document.getElementById('<%=chkShowinTAT.ClientID%>').checked = true;
            else
                document.getElementById('<%=chkShowinTAT.ClientID%>').checked = false;
         
             document.getElementById('<%=ddlprintcentre.ClientID%>').value = val[53];
          
            if (val[11] == '1')
                document.getElementById('<%=chkIsOutSource.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkIsOutSource.ClientID %>').checked = false;
            if (val[21] == '1')
                document.getElementById('<%=ChkisUrgent.ClientID %>').checked = true;
            else
                document.getElementById('<%=ChkisUrgent.ClientID %>').checked = false;
            if (val[22] == '1')
                document.getElementById('<%=chkreporting.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkreporting.ClientID %>').checked = false;
            if (val[24] == '1')
                document.getElementById('<%=chkbooking.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkbooking.ClientID %>').checked = false;

            if (val[26] == '1')
                document.getElementById('<%=ChkIsActive.ClientID %>').checked = true;
            else
                document.getElementById('<%=ChkIsActive.ClientID %>').checked = false;

            if (val[27] == '1')
                document.getElementById('<%=chkisorganism.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkisorganism.ClientID %>').checked = false;

            if (val[28] == '1')
                document.getElementById('<%=chkisculturereport.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkisculturereport.ClientID %>').checked = false;
            if (val[29] == '1')
                document.getElementById('<%=chkprntsmplnme.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkprntsmplnme.ClientID %>').checked = false;

            var data = val[30];

            if (val[31] == '1')
                document.getElementById('<%=chkisMic.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkisMic.ClientID %>').checked = false;

            if (val[32] == '1')
                document.getElementById('<%=chkIPrintSeparate.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkIPrintSeparate.ClientID %>').checked = false;
            document.getElementById('<%=txtRate.ClientID %>').value = val[33];


            if (val[43] == '1')//sample defined
                document.getElementById('<%=chksampledefine.ClientID %>').checked = true;
            else
                document.getElementById('<%=chksampledefine.ClientID %>').checked = false;

            if (val[50] == '1')//IsQuantity
                document.getElementById('<%=chkIsQuantity.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkIsQuantity.ClientID %>').checked = false;


            checkme(val[44]);
            $("#<%=txtBaseRate.ClientID %>").val(val[45]);
            //$("#<%=txtBaseRate.ClientID %>").val(val[33]);
            $("#<%=txtstdrate.ClientID %>").val(val[45]);
            

            $("#<%=ddlAttachmentReqd.ClientID %>").val(val[46]);

            //Bilal
            $("#<%=txtTatIntimate.ClientID%>").val(val[51]);
            if (val[52] == '1')//Showinratelist
                document.getElementById('<%=chkShowinRatelist.ClientID %>').checked = true;
            else
                document.getElementById('<%=chkShowinRatelist.ClientID %>').checked = false;

            var OutsrcLabs = (data).split('#');

            var OutsrcLabslen = OutsrcLabs.length;
            $("#<%=chkSample.ClientID %>").find(':checkbox').is(':checked', false);
            $('#<%=ddlSample.ClientID %> option').remove();
            if (data != "") {
                for (var o = 0; o < OutsrcLabslen; o++) {
                    $('#<%=ddlSample.ClientID %>').append($("<option></option>").val(OutsrcLabs[o].split('|')[0]).html(OutsrcLabs[o].split('|')[1]));
                }
            }
            $('#<%=chkSample.ClientID %> input[type=checkbox]').prop('checked', false);
            $('#<%=ddlSample.ClientID %> option').each(function () {
                var opt = $(this).val();
                $('#<%=chkSample.ClientID %> input[type=checkbox]').each(function () {
                    if ($(this).val() == opt) {
                        $(this).prop('checked', true);
                    }
                });
            });
            if (val[47] == '1')//LMP sunil
            {
                document.getElementById('<%=chkIsLMPRequired.ClientID %>').checked = true;
                $('.lmp').show();
            }
            else {
                document.getElementById('<%=chkIsLMPRequired.ClientID %>').checked = false;
                $('.lmp').hide();
            }
            $("#<%=txtLMPFromDay.ClientID %>").val(val[48]);
            $("#<%=txtLMPToDay.ClientID %>").val(val[49]);
        }

        function checkme(dd) {

            $('#<%=chkdocument.ClientID %> input[type=checkbox]').prop('checked', false);

            if (dd != "") {

                for (var c = 0; c <= dd.split('|').length - 1; c++) {

                    var opt = dd.split('|')[c];
                    $('#<%=chkdocument.ClientID %> input[type=checkbox]').each(function () {
                        if ($(this).val() == opt) {
                            $(this).prop('checked', true);
                        }
                    });
                }
            }


        }


        function BindListBox() {

            $('form').attr('disabled', true);
            $("#<%=lstInvestigation.ClientID %> option").remove();
            var lstInvestigation = $("#<%=lstInvestigation.ClientID %>");
            lstInvestigation.attr("disabled", true);
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/BindListBox",
                data: '{ Dept:"' + $("#<%=ddlDepartment.ClientID %>").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    InvData = jQuery.parseJSON(result.d);

                    if (InvData.length == 0) {
                        lstInvestigation.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {

                        for (i = 0; i < InvData.length; i++) {
                            lstInvestigation.append($("<option></option>").val(InvData[i].newValue).html(InvData[i].Name));
                        }
                    }
                    lstInvestigation.attr("disabled", false);
                    $('form').attr('disabled', false);
                },
                error: function (xhr, status) {
                    alert("Error ");
                    lstInvestigation.attr("disabled", false);
                    $('form').attr('disabled', false);
                }
            });
        }
        function SaveInvestigation() {
            if ($("#chkNewInv").is(':checked'))
                SaveNewInvestigation();
            else
                UpdateInvestigation();
        }
        function SaveNewInvestigation() {


            $(':text').attr('disabled', true);

            if ($("#<%=txtInv.ClientID %>").val() == "") {
                alert('Test Name cannot be Blank');
                $(':text').attr('disabled', false);

                return;
            }
            var IsQuantity = '0';
            var OutSrc = '0';
            var showPtRpt = '0';
            var ShowAnlysRpt = '0';
            var ShowOnlnRpt = '0';
            var IsAutoStore = '0';
            var isUrgent = '0';
            var SampleTypeID = "";
            var Reporting = '0';
            var Booking = '0';
            var IsActive = '0';
            var IsOrganism = '0';
            var ShowinTat = '0';
            var IsCulture = '0';
            var IsMic = '0';
            var PrintSeparate = '0';
            var PrintSampleName = '0';
            var sampledefined = '0';
            var showinratelist = '0';
            var BillCategoryID = $("#<%=ddlbillcat.ClientID%>").val();
            var autoconsume = $("#<%=ddlautoconsume.ClientID%> option:selected").val();
            var BillingCategory = $("#<%=ddlBillingCategory.ClientID%> option:selected").val();
            var ConsentType = $("#<%=ddlConcernFormType.ClientID%> option:selected").val();
            var labalert = $("#<%=ddllabalert.ClientID%> option:selected").val();
            var smsonalert = $("#<%=txtsms.ClientID%>").val();
            var temp = $("#<%=ddltemp.ClientID%>").val();
            $('#<%=ddlSample.ClientID %> option').each(function () {
                SampleTypeID += $(this).val() + '|' + $(this).text();
                if ($('#<%=ddlSample.ClientID %>').val() == $(this).val())
            SampleTypeID += '|1';
        else
            SampleTypeID += '|0';

            SampleTypeID += '#';
            });
            if ($('#ContentPlaceHolder1_ddlType').val() == "R" && SampleTypeID == "") {
                alert('Please Select Sample Type....!');
                return;
            }
            else if ($('#ContentPlaceHolder1_ddlType').val() == "S" && SampleTypeID == "") {
                 alert('Please Select Sample Type....!');
                 return;
             }
            if ($('#<%=chkIsQuantity.ClientID %>').is(':checked'))
                IsQuantity = '1';
            if ($('#<%=chkIsOutSource.ClientID %>').is(':checked'))
                OutSrc = '1';
            if ($('#<%=chkShowPtRpt.ClientID %>').is(':checked'))
                showPtRpt = '1';
            if ($('#<%=chkShowAnlysRpt.ClientID %>').is(':checked'))
                ShowAnlysRpt = '1';
            if ($('#<%=chkShowOnlnRpt.ClientID %>').is(':checked'))
                ShowOnlnRpt = '1';
            if ($('#<%=chkIsAutoStore.ClientID %>').is(':checked'))
                IsAutoStore = '1';
            if ($('#<%=ChkisUrgent.ClientID %>').is(':checked'))
                isUrgent = '1';
            if ($('#<%=chkreporting.ClientID %>').is(':checked'))
                Reporting = '1';
            if ($('#<%=chkbooking.ClientID %>').is(':checked'))
                Booking = '1';
            if ($('#<%=ChkIsActive.ClientID %>').is(':checked'))
                IsActive = '1';
            if ($('#<%=chkisorganism.ClientID %>').is(':checked'))
                IsOrganism = '1';
            if ($('#<%=chkisculturereport.ClientID %>').is(':checked'))
                IsCulture = '1';
            if ($(<%=chkShowinTAT.ClientID%>).is(':checked'))
                ShowinTat = '1';
            if ($('#<%=chkisMic.ClientID %>').is(':checked'))
                IsMic = '1';
            if ($('#<%=chkIPrintSeparate.ClientID %>').is(':checked'))
                PrintSeparate = '1';
            if ($('#<%=chkprntsmplnme.ClientID %>').is(':checked'))
                PrintSampleName = '1';

            if ($('#<%=chksampledefine.ClientID %>').is(':checked'))
                sampledefined = '1';
            if ($('#<%=chkShowinRatelist.ClientID%>').is(':checked'))
                showinratelist = '1';

            var IsLMPRequired = $('#<%=chkIsLMPRequired.ClientID %>').is(':checked') ? '1' : '0';
            var LMPDay = ($('#<%=txtLMPFromDay.ClientID %>').val() == '' ? '0' : $('#<%=txtLMPFromDay.ClientID %>').val()) + "|" + ($('#<%=txtLMPToDay.ClientID %>').val() == '' ? '0' : $('#<%=txtLMPToDay.ClientID %>').val());
            if (IsLMPRequired == '1') {
                if (LMPDay.split('|')[0] == "0" || LMPDay.split('|')[1] == "0") {
                    toast("Error", 'LMP Day Should not be zero', '');
                    return;
                }
                if (LMPDay.split('|')[0] >= LMPDay.split('|')[1]) {
                    toast("Error", 'LMP To Day Should be greater than LMP From Day', '');
                    return;
                }
            }
            var RequiredAttachment = getattachment();
            var BaseRate = ($('#<%=txtBaseRate.ClientID %>').val() == '' ? '0' : $('#<%=txtBaseRate.ClientID %>').val());
            var AttchmentRequiredAt = $('[id$=ddlAttachmentReqd]').val();
            var TatIntimate = $("#<%=txtTatIntimate.ClientID%>").val() == "" ? "0" : $("#<%=txtTatIntimate.ClientID%>").val();

            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/SaveNewInvestigation",
                data: '{ InvName: "' + $("#<%=txtInv.ClientID %>").val() + '",TestCode:"' + $("#<%=txtTestCode.ClientID %>").val() + '",DepartmentID:"' + $("#<%=ddlGroupHead.ClientID %>").val() + '",DepartmentName:"' + $("#<%=ddlGroupHead.ClientID %> :selected").text() + '",ReportType: "' + $("#<%=ddlReportType.ClientID %>").val() + '",SampleType:"' + $("#<%=ddlType.ClientID %>").val() + '",ShortName: "' + $("#<%=txtShortName.ClientID %>").val() + '",IsOutSrc:"' + OutSrc + '",TimeLimit:"' + $("#<%=txtTimelimit.ClientID %>").val() + '",SampleQty:"' + $("#<%=txtSampleQty.ClientID %>").val() + '",SampleRmks:"' + $("#<%=txtSampleRmks.ClientID %>").val() + '",ColorCode:"' + $("#<%=ddlcontainer.ClientID %>").val() + '",Gender:"' + $("#<%=ddlGender.ClientID %>").val() + '",showPtRpt:"' + showPtRpt + '",ShowAnlysRpt:"' + ShowAnlysRpt + '",ShowOnlnRpt:"' + ShowOnlnRpt + '",IsAutoStore:"' + IsAutoStore + '",isUrgent:"' + isUrgent + '",SampleTypeID:"' + SampleTypeID + '",MaxDiscount:"' + $("#<%=txtmaxdiscount.ClientID %>").val() + '",Reporting:"' + Reporting + '",Booking:"' + Booking + '",IsActive:"' + IsActive + '",BillCategoryID:"' + BillCategoryID + '",IsOrganism:"' + IsOrganism + '",IsCulture:"' + IsCulture + '",IsMic:"' + IsMic + '",PrintSeparate:"' + PrintSeparate + '",PrintSampleName:"' + PrintSampleName + '",Rate:"' + $("#<%=txtRate.ClientID %>").val() + '",autoconsume:"' + autoconsume + '",BillingCategory:"' + BillingCategory + '",ConsentType:"' + ConsentType + '",labalert:"' + labalert + '",smstext:"' + smsonalert + '",temp:"' + temp + '",fromage:"' + $('#<%=txtfromage.ClientID%>').val() + '",toage:"' + $('#<%=txttoage.ClientID%>').val() + '",invtype:"' + $('#<%=ddlinvtype.ClientID%>').val() + '",sampledefined:"' + sampledefined + '",RequiredAttachment:"' + RequiredAttachment + '",BaseRate:"' + BaseRate + '",AttchmentRequiredAt:"' + AttchmentRequiredAt + '",IsLMPRequired:"' + IsLMPRequired + '",LMPDay:"' + LMPDay + '",IsQuantity:"' + IsQuantity + '", TatIntimate:"' + TatIntimate + '",ShowInRateList:"' + showinratelist + '",ShowinTAT:"' + ShowinTat + '",PrintTestCentre:"'+ $('#<%=ddlprintcentre.ClientID%>').val() +'"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    RateData = result.d;

                    if (result.d == 'Error') {
                        alert('Record  Not Saved');
                    }
                    else if (result.d == '0') {
                        alert('Investigation Already Exist');
                    }
                    else if (result.d == '-1') {
                        alert('Investigation Test Code Already Exist');
                    }
                    else {
                        alert('Record Saved Successfully');
                        clearform();

                        $(':text').attr('disabled', false);
                        $("#<%=lstInvestigation.ClientID %>").attr('disabled', $("#chkNewInv").is(':checked'));
                        document.getElementById('<%=chkbooking.ClientID %>').checked = true;
                        document.getElementById('<%=chkreporting.ClientID %>').checked = true;
                        document.getElementById('<%=chkShowPtRpt.ClientID %>').checked = true;
                        document.getElementById('<%=chkShowAnlysRpt.ClientID %>').checked = true;
                        document.getElementById('<%=chkShowOnlnRpt.ClientID %>').checked = true;
                        document.getElementById('<%=ChkIsActive.ClientID %>').checked = true;
                        document.getElementById('<%=txtmaxdiscount.ClientID %>').value = 100;
                        $("#div_InvNameHead").html('');

                    }

                    $(':text').attr('disabled', false);
                  
                    // $("#ContentPlaceHolder1_txtTestCode").attr('disabled', $("#chkNewInv").is(':checked'));
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });




}

$( document ).ready(function() {
    numbertestcode();
});

 function numbertestcode() {
            $.ajax({
                url: "ManagePackage.aspx/testcodenumber", // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                asylc: false,
                success: function (result) {
                    var pac = result.d;
                    $("#ContentPlaceHolder1_txtTestCode").val(pac);

                },
                error: function (xhr, status) {
                    alert("Error ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


function getattachment() {

    var checked_checkboxes = $("[id*=chkdocument] input:checked");
    var message = "";
    var Alltext = "";
    var Allvalue = "";
    checked_checkboxes.each(function () {
        var value = $(this).val();
        var text = $(this).closest("td").find("label").html();

        Alltext += text + "|";
        Allvalue += value + "|";
        //message += value + "|";


    });
    message = Alltext + "#" + Allvalue;
    return message;

}

function UpdateInvestigation() {
    if ($("#<%=txtInv.ClientID %>").val() == "") {
        alert('Test Name cannot be Blank');
        return;
    }
    var IsQuantity = '0';
    var OutSrc = '0';
    var showPtRpt = '0';
    var SampleTypeID = "";
    var ShowAnlysRpt = '0';
    var ShowOnlnRpt = '0';
    var IsAutoStore = '0';
    var isUrgent = '0';
    var Reporting = '0';
    var Booking = '0';
    var ShowinTat = '0';
    var IsActive = '0';
    var IsOrganism = '0';
    var IsCulture = '0';
    var IsMic = '0';
    var PrintSeparate = '0';
    var PrintSampleName = '0';
    var sampledefined = '0';
    var showinratelist = '0';

    var autoconsume = $("#<%=ddlautoconsume.ClientID%> option:selected").val();
        var BillingCategory = $("#<%=ddlBillingCategory.ClientID%> option:selected").val();
    var ConsentType = $("#<%=ddlConcernFormType.ClientID%> option:selected").val();
    var labalert = $("#<%=ddllabalert.ClientID%> option:selected").val();
    var smsonalert = $("#<%=txtsms.ClientID%>").val();
    var temp = $("#<%=ddltemp.ClientID%>").val();
 

    $('#<%=ddlSample.ClientID %> option').each(function () {
        SampleTypeID += $(this).val() + '|' + $(this).text();
        if ($('#<%=ddlSample.ClientID %>').val() == $(this).val())
                    SampleTypeID += '|1';
                else
                    SampleTypeID += '|0';

                SampleTypeID += '#';
   });
    if ($('#ContentPlaceHolder1_ddlType').val() == "R" && SampleTypeID == "") {
        alert('Please Select Sample Type....!');
        return;
    }
    else if ($('#ContentPlaceHolder1_ddlType').val() == "S" && SampleTypeID == "") {
        alert('Please Select Sample Type....!');
        return;
    }
            if ($('#<%=chkIsQuantity.ClientID %>').is(':checked'))
        IsQuantity = '1';
    if ($('#<%=chkIsOutSource.ClientID %>').is(':checked'))
        OutSrc = '1';
    if ($('#<%=chkShowPtRpt.ClientID %>').is(':checked'))
        showPtRpt = '1';
    if ($('#<%=chkShowAnlysRpt.ClientID %>').is(':checked'))
        ShowAnlysRpt = '1';
    if ($('#<%=chkShowOnlnRpt.ClientID %>').is(':checked'))
        ShowOnlnRpt = '1';
    if ($('#<%=chkIsAutoStore.ClientID %>').is(':checked'))
        IsAutoStore = '1';
    if ($('#<%=ChkisUrgent.ClientID %>').is(':checked'))
        isUrgent = '1';
    if ($(<%=chkShowinTAT.ClientID%>).is(':checked'))
        ShowinTat = '1';
    if ($('#<%=chkreporting.ClientID %>').is(':checked'))
        Reporting = '1';
    if ($('#<%=chkbooking.ClientID %>').is(':checked'))
        Booking = '1';
    if ($('#<%=ChkIsActive.ClientID %>').is(':checked'))
        IsActive = '1';
    if ($('#<%=chkisorganism.ClientID %>').is(':checked'))
        IsOrganism = '1';
    if ($('#<%=chkisculturereport.ClientID %>').is(':checked'))
        IsCulture = '1';
    if ($('#<%=chkisMic.ClientID %>').is(':checked'))
        IsMic = '1';
    if ($('#<%=chkIPrintSeparate.ClientID %>').is(':checked'))
        PrintSeparate = '1';
    if ($('#<%=chkprntsmplnme.ClientID %>').is(':checked'))
        PrintSampleName = '1';

    if ($('#<%=chksampledefine.ClientID %>').is(':checked'))
        sampledefined = '1';
    if ($('#<%=chkShowinRatelist.ClientID%>').is(':checked'))
        showinratelist = '1';

    var IsLMPRequired = $('#<%=chkIsLMPRequired.ClientID %>').is(':checked') ? '1' : '0';
    var LMPDay = ($('#<%=txtLMPFromDay.ClientID %>').val() == '' ? '0' : $('#<%=txtLMPFromDay.ClientID %>').val()) + "|" + ($('#<%=txtLMPToDay.ClientID %>').val() == '' ? '0' : $('#<%=txtLMPToDay.ClientID %>').val());
    if (IsLMPRequired == '1') {
        if (LMPDay.split('|')[0] == "0" || LMPDay.split('|')[1] == "0") {
            toast("Error", 'LMP Day Should not be zero', '');
            return;
        }
        if (LMPDay.split('|')[0] >= LMPDay.split('|')[1]) {
            toast("Error", 'LMP To Day Should be greater than LMP From Day', '');
            return;
        }
    }
    var RequiredAttachment = getattachment();
    var BaseRate = ($('#<%=txtBaseRate.ClientID %>').val() == '' ? '0' : $('#<%=txtBaseRate.ClientID %>').val());
    var AttchmentRequiredAt = $('[id$=ddlAttachmentReqd]').val() == null ? 0 : $('[id$=ddlAttachmentReqd]').val();
        var TatIntimate = $("#<%=txtTatIntimate.ClientID%>").val() == "" ? "0" : $("#<%=txtTatIntimate.ClientID%>").val();
    var billcat = $("#<%=ddlbillcat.ClientID %>").val() == null ? 0 : $("#<%=ddlbillcat.ClientID %>").val();
        $.ajax({

            url: "Services/MapInvestigationObservation.asmx/UpdateInvestigation",
            data: '{ InvName: "' + $("#<%=txtInv.ClientID %>").val() + '",TestCode:"' + $("#<%=txtTestCode.ClientID %>").val() + '",InvID: "' + $("#<%=txtInvestigation_ID.ClientID %>").val() + '",ItemID: "' + $("#<%=txtItemID.ClientID %>").val() + '",DepartmentID:"' + $("#<%=ddlGroupHead.ClientID %>").val() + '",InvObsId:"' + $("#<%=txtInvestigation_ObservationType_ID.ClientID %>").val() + '",DepartmentName:"' + $("#<%=ddlGroupHead.ClientID %> :selected").text() + '",ReportType: "' + $("#<%=ddlReportType.ClientID %>").val() + '",SampleType:"' + $("#<%=ddlType.ClientID %>").val() + '",ShortName: "' + $("#<%=txtShortName.ClientID %>").val() + '",IsOutSrc:"' + OutSrc + '",TimeLimit:"' + $("#<%=txtTimelimit.ClientID %>").val() + '",SampleQty:"' + $("#<%=txtSampleQty.ClientID %>").val() + '",SampleRmks:"' + $("#<%=txtSampleRmks.ClientID %>").val() + '",ColorCode:"' + $("#<%=ddlcontainer.ClientID %>").val() + '",Gender:"' + $("#<%=ddlGender.ClientID %>").val() + '",showPtRpt:"' + showPtRpt + '",ShowAnlysRpt:"' + ShowAnlysRpt + '",ShowOnlnRpt:"' + ShowOnlnRpt + '",IsAutoStore:"' + IsAutoStore + '",isUrgent:"' + isUrgent + '",SampleTypeID:"' + SampleTypeID + '",MaxDiscount:"' + $("#<%=txtmaxdiscount.ClientID %>").val() + '",Reporting:"' + Reporting + '",Booking:"' + Booking + '",IsActive:"' + IsActive + '",BillCategoryID: "' + billcat + '",IsOrganism: "' + IsOrganism + '",IsCulture: "' + IsCulture + '",IsMic:"' + IsMic + '",PrintSeparate:"' + PrintSeparate + '",PrintSampleName:"' + PrintSampleName + '",Rate:"' + $("#<%=txtRate.ClientID %>").val() + '",autoconsume:"' + autoconsume + '",BillingCategory:"' + BillingCategory + '",ConsentType:"' + ConsentType + '",labalert:"' + labalert + '",smstext:"' + smsonalert + '",temp:"' + temp + '",fromage:"' + $('#<%=txtfromage.ClientID%>').val() + '",toage:"' + $('#<%=txttoage.ClientID%>').val() + '",invtype:"' + $('#<%=ddlinvtype.ClientID%>').val() + '",sampledefined:"' + sampledefined + '",RequiredAttachment:"' + RequiredAttachment + '",BaseRate:"' + BaseRate + '",AttchmentRequiredAt:"' + AttchmentRequiredAt + '",IsLMPRequired:"' + IsLMPRequired + '",LMPDay:"' + LMPDay + '",IsQuantity:"' + IsQuantity + '", TatIntimate:"' + TatIntimate + '",ShowInRateList:"' + showinratelist + '",ShowinTAT:"' + ShowinTat + '",PrintTestCentre:"0"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                if (result.d == '1') {
                    alert('Record Updated Successfully');
                    clearform();
                    BindListBox();
                }
                else if (result.d == '-1') {
                    alert('Investigation Test Code Already Exist');
                }
                else {
                    alert('Record Not Updated');
                }
            },
            error: function (xhr, status) {
                alert("Error ");
            }
        });


    }

    var InvData = "";

    function clearform() {
        $(':text, textarea').val('');
        $('select:not(#<%=ddlDepartment.ClientID %>) option:nth-child(1)').attr('selected', 'selected')
            $('#<%=ddlSample.ClientID %>').find("option").remove();
            $(".chk").find(':checkbox').is(':checked', '');
            $(":checkbox:not(#chkNewInv)").is(":checked", false);
            $("#tb_grdLabSearch tr").remove();
            $("#div_InvNameHead").html('');

            $('#<%=chkdocument.ClientID %> input[type=checkbox]').prop('checked', false);
            $('#<%=chkIsLMPRequired.ClientID %> input[type=checkbox]').prop('checked', false);
            $('#<%=chkSample.ClientID %> input[type=checkbox]').prop('checked', false);
            $('#<%=txtfromage.ClientID%>').val('0');
            $('#<%=txttoage.ClientID%>').val('36500');
			numbertestcode();
        }

        function BindListBox() {
            $('form').attr('disabled', true);
            $("#<%=ListBox2.ClientID %> option").remove();
            $("#<%=lstInvestigation.ClientID %> option").remove();
            var lstInvestigation = $("#<%=lstInvestigation.ClientID %>");
            // alert(lstInvestigation);
            var ListBox2 = $("#<%=ListBox2.ClientID %>");
            lstInvestigation.attr("disabled", true);

            $.ajax({

                url: "Services/MapInvestigationObservation.asmx/BindListBox",
                data: '{ Dept:"' + $("#<%=ddlDepartment.ClientID %>").val() + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {

            InvData = jQuery.parseJSON(result.d);
            if (InvData.length == 0) {
                lstInvestigation.append($("<option></option>").val("0").html("---No Data Found---"));
                ListBox2.append($("<option></option>").val("0").html("---No Data Found---"));
            }
            else {

                for (i = 0; i < InvData.length; i++) {
                    lstInvestigation.append($("<option></option>").val(InvData[i].newValue).html(InvData[i].Name));

                    ListBox2.append($("<option></option>").val(InvData[i].newValue).html(InvData[i].Name));
                }
            }
            lstInvestigation.attr("disabled", false);
            ListBox2.attr("disabled", false);
            $('form').attr('disabled', false);
        },
        error: function (xhr, status) {
            alert("Error ");
            lstInvestigation.attr("disabled", false);
            ListBox2.attr("disabled", false);
            $('form').attr('disabled', false);
        }
    });


}
$(function () {
    $('.lmp').hide();
//jQuery("#<%=lstInvestigation.ClientID %>,#<%=ddlDepartment.ClientID %>").attr('disabled','disabled');
    $("#chkNewInv").click(function () {

 jQuery("#<%=lstInvestigation.ClientID %>").attr('disabled', jQuery("#chkNewInv").is(':checked'));
 jQuery("#<%=ddlDepartment.ClientID %>").attr('disabled', jQuery("#chkNewInv").is(':checked'));

        clearform();
        $('#<%=txtfromage.ClientID%>').val('0');
                $('#<%=txttoage.ClientID%>').val('36500');
                //  $("#<%=lstInvestigation.ClientID %>,#ContentPlaceHolder1_txtTestCode").attr('disabled', $("#chkNewInv").is(':checked'));
                document.getElementById('<%=chkbooking.ClientID %>').checked = true;
                document.getElementById('<%=chkreporting.ClientID %>').checked = true;
                document.getElementById('<%=chkShowPtRpt.ClientID %>').checked = true;
                document.getElementById('<%=chkShowAnlysRpt.ClientID %>').checked = true;
                document.getElementById('<%=chkShowOnlnRpt.ClientID %>').checked = true;
                document.getElementById('<%=ChkIsActive.ClientID %>').checked = true;
                document.getElementById('<%=txtmaxdiscount.ClientID %>').value = 100;
                $("#div_InvNameHead").html('');

            });
            $("#<%=chkSample.ClientID %> :checkbox").click(function () {
                $("#<%=ddlSample.ClientID %> option").remove()

                $("#<%=chkSample.ClientID %>").find(":checkbox").filter(':checked').each(function () {
                    $("#<%=ddlSample.ClientID %>").append($("<option></option>").val($(this).closest('span').attr("id")).html($(this).closest('span').attr("chk_text")));
                });
            });
        });
    </script>
    <script type="text/javascript">
        function SearchEmployees(txtSearch, cblEmployees) {
            if ($(txtSearch).val() != "") {
                var count = 0;
                $(cblEmployees).children('tbody').children('tr').each(function () {
                    var match = false;
                    $(this).children('td').children('span').children('label').each(function () {
                        if ($(this).text().toUpperCase().indexOf($(txtSearch).val().toUpperCase()) > -1)
                            match = true;
                    });
                    if (match) {
                        $(this).show();
                        count++;
                    }
                    else { $(this).hide(); }
                });
            }
            else {
                $(cblEmployees).children('tbody').children('tr').each(function () {
                    $(this).show();
                });
            }
        }
        function SearchEmployees1(txtSearch, cblEmployees) {
            if ($(txtSearch).val() != "") {
                var count = 0;
                $(cblEmployees).children('tbody').children('tr').each(function () {
                    var match = false;
                    $(this).children('td').children('span').children('label').each(function () {
                        if ($(this).text().toUpperCase().indexOf($(txtSearch).val().toUpperCase()) > -1)
                            match = true;
                    });
                    if (match) {
                        $(this).show();
                        count++;
                    }
                    else { $(this).hide(); }
                });
            }
            else {
                $(cblEmployees).children('tbody').children('tr').each(function () {
                    $(this).show();
                });
            }
        }
    </script>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        function DoListBoxFilter(listBoxSelector, filter, keys, values) {
            var list = $(listBoxSelector);
            values = [];
            keys = [];
            var SerchType = $("input[name='chkSearchType']:checked").val();
            var options = $('#<% = ListBox2.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            var selectBase = '<option value="{0}">{1}</option>';
            list.empty();
            for (i = 0; i < values.length; ++i) {
                var value = "";
                if (SerchType != "2") {
                    value = values[i].toLowerCase();
                }
                else {
                    var keysArray = keys[i].split('$');
                    value = keysArray[20];
                }
                var temp = "";
                if (value.toLowerCase().indexOf(filter.toLowerCase()) >= 0) {
                    temp = '<option value="' + keys[i] + '">' + values[i] + '</option>';
                    list.append(temp);
                }
            }

        }
        function Click(ctr) {
            var filter = $(ctr).val().toLowerCase();
            // alert(filter);
            DoListBoxFilter('.navList', filter, keys, values);

        }
        function showHide() {
            
            if ($('#<%=chkIsLMPRequired.ClientID %>').is(':checked'))
                $('.lmp').show();
            else
                $('.lmp').hide();
        }
    </script>
    <script type="text/javascript">
        function SetSubChilds(reportType) {
            var RepID = reportType;
            if (RepID == "") {
                $(".jscoin-tabs").hide();
            }
            else
                $(".jscoin-tabs").show();
            $('ul.menu li').each(function (i) {
                $(this).find('a').attr('href', 'javascript:void(0)');

                var ide = $(this).attr('id').split('#');

                var n = ide[1].indexOf(RepID);
                // alert(ide + "  Rep Id  " + RepID + " n " + n);
                if ((n == "-1")) {

                    $(this).hide();
                }
                else
                    $(this).show();
            });
        }
        $(function () {
            var RepID = ReportTypeNo;
            $('ul.menu li').each(function (i) {
                var ide = $(this).attr('id').split('#');
                var n = ide[1].indexOf(RepID);
                if ((n == "-1")) {
                    $(this).hide();
                }
            });
        });
        function Call(chk) {
            // '<%=reportType %>'
            var c = chk;
            var CID = c.id.split('#');
            var Url = CID[0] + '?InvID=' + InvestigationID;
            //"status=yes,toolbar=no,menubar=no,location=no
            window.open(Url, null, "");
            //$(chk).attr("href", Url);
            return false;
            //           var CI = CID[1].split(',');
            //           var validatePage = "0";


        }
    </script>
    <style type="text/css">
        .jscoin-tabs ul.menu > li {
            display: block;
            float: left;
        }

        .jscoin-tabs ul.menu li > a {
            color: #000;
            text-decoration: none;
            display: block;
            text-align: center;
            border: 1px solid #808080;
            padding: 5px 10px 5px 10px;
            margin-right: 5px;
            border: 1px solid blue;
            border-radius: 8px;
            font-weight: bold;
            background-color: #ffe0c0;
            cursor: pointer;
        }

        .jscoin-tabs ul.menu li > div {
            display: none;
            position: absolute;
            width: 100%;
            left: 0;
            margin: -1px 0 0 0;
            z-index: -1;
            text-align: left;
            padding: 0;
        }

            .jscoin-tabs ul.menu li > div > p {
                border: 1px solid #808080;
                padding: 10px;
                margin: 0;
            }

        .jscoin-tabs ul.menu li > a:focus {
            border-bottom: 1px solid #fff;
        }

        .jscoin-tabs ul.menu li:target > a {
            cursor: default;
            border: 1px solid blue;
            border-radius: 8px;
            font-weight: bold;
        }

        .jscoin-tabs ul.menu li:target > div {
            display: block;
        }

        .jscoin-tabs ul li a:hover, .jscoin-tabs ul li .current {
            color: white;
            background-color: black;
        }
    </style>
</asp:Content>
