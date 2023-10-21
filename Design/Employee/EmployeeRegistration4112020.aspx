<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EmployeeRegistration.aspx.cs"
    Inherits="Design_Employee_EmployeeRegistration"  ValidateRequest="false" EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
        <link href="../../App_Style/multiple-select.css" rel="stylesheet"/> 
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>
            <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <script type="text/javascript">
        $(function () {
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        </script>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>EMPLOYEE REGISTRATION</b><br />

            &nbsp;<asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>
            <asp:Label ID="lblIsEdit" runat="server"  style="display:none" ClientIDMode="Static"></asp:Label>
             <asp:Label ID="lblEmployee_ID" runat="server"  style="display:none" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Employee Details&nbsp;
            </div>
            <div class="row" style="display:none">
                <div class="col-md-4" >
                    <strong>&nbsp;  </strong>
                </div>
                <div class="col-md-8">

                </div>
                <div class="col-md-4">
                    <asp:Label ID="lblID" runat="server" ForeColor="#0033CC"></asp:Label>
                </div>
                <div class="col-md-8">

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <strong>Employee Code :&nbsp; </strong>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtHouseNo" runat="server" TabIndex="1" MaxLength="35" ToolTip="Enter Empcode" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="ckIsPRO" style="display:none" Text="IsPRO" runat="server" OnCheckedChanged="ckIsPRO_CheckedChanged" />
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPRO" runat="server" TabIndex="2" Visible="False">
                        </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <strong>Name :&nbsp; </strong>
                </div>
                <div class="col-md-2">
                     <asp:DropDownList ID="cmdTitle" runat="server" TabIndex="2" AutoPostBack="false">
                        </asp:DropDownList>
                </div>
                <div class="col-md-3">
                        <asp:TextBox ID="txName" runat="server" TabIndex="3" MaxLength="100" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    Designation :
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlDesignation" onchange="HideHead()" runat="server" TabIndex="2">
                        </asp:DropDownList>
                       
                </div>
                 <div class="col-md-1">
                      <input type="button" value="New" id="btnNewDesignation" onclick="OpenDesignationWindow()"  class="searchbutton"/>
                    </div>
                <div class="col-md-3" id="PRO1">
                    <strong>PRO Head :&nbsp; </strong>
                </div>
                <div class="col-md-5"  id="PRO2">
                     <asp:DropDownList ID="ddlPROHead" runat="server" TabIndex="2" AutoPostBack="false">
                        </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Street No. :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtStreet" runat="server" TabIndex="4"
                            MaxLength="35" ToolTip="Enter Street Name" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    Locality :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtLocality" runat="server" TabIndex="5"
                            MaxLength="35" ToolTip="Enter Locality" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    City :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCity" runat="server" TabIndex="6" MaxLength="35"
                            ToolTip="Enter city" ClientIDMode="Static"></asp:TextBox>
                </div>
               
            </div>
            <div class="row">
                 <div class="col-md-3">
                    Pin Code&nbsp; :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPinCode" runat="server" TabIndex="7"
                            MaxLength="10" ToolTip="Enter Pin code" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPinCode" runat="server" TargetControlID="txtPinCode" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
            </div>
             <div class="row">
            <div class="col-md-4">
                <b>Office Address :&nbsp;</b>
            </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    House No. :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtOhouseNo" runat="server" TabIndex="8"
                            MaxLength="35" ToolTip="Enter House No" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    Street No. :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtOStreet" runat="server" TabIndex="9"
                            MaxLength="35" ToolTip="Enter Street Name" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    Locality :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtOlocality" runat="server" TabIndex="10"
                            MaxLength="35" ToolTip="Enter Locality" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    City :&nbsp;
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtOCity" runat="server" TabIndex="11"
                            MaxLength="35" ToolTip="Enter City" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    Pin Code :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtOPinCode" runat="server" TabIndex="12" MaxLength="10" ToolTip="Enter Pin Code" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbOPinCode" runat="server" TargetControlID="txtOPinCode" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
                 <div class="col-md-3">
                      Email :&nbsp;
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtEmail" runat="server" TabIndex="13"
                            ToolTip="Enter E-Mail Address" MaxLength="100" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                 <div class="col-md-3">
                     Phone No. :&nbsp;
                </div>
                <div class="col-md-1">
                    <asp:TextBox ID="txtSTD" runat="server"  TabIndex="14" MaxLength="5" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbSTD" runat="server" TargetControlID="txtSTD" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </div>
                <div class="col-md-4">
                        -&nbsp;<asp:TextBox ID="txtPhone" runat="server" TabIndex="15" Width="185px"
                            MaxLength="11" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" TargetControlID="txtPhone" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-3">
                    Mobile :&nbsp;
                </div>
                <div class="col-md-5">
                       <asp:TextBox ID="txtMobile" runat="server" MaxLength="11"
                            TabIndex="16" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Personal Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    Father's Name :&nbsp;
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtFather" runat="server" TabIndex="17"  MaxLength="100"
                            ToolTip="Enter Father / Husband Name ( max Character 100 )" ClientIDMode="Static"></asp:TextBox>
                </div>
                 <div class="col-md-3">
                     Mother's Name :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtMother" runat="server" TabIndex="18"  MaxLength="100"
                            ToolTip="Enter Father / Husband Name ( max Character 100 )" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    DOB :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDOB" runat="server" ToolTip="Select Date DOB" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                 <div class="col-md-3">
                     Qualification :&nbsp;
                </div>
                <div class="col-md-5">
                       <asp:TextBox ID="txtqualification" runat="server" TabIndex="19"
                            ToolTip="Enter Qualification" MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                 <div class="col-md-3">
                      ESI Number :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtESI" runat="server" TabIndex="20" ToolTip="Enter ESI No. "
                            MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                               
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    EPF Number :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtEPF" runat="server" TabIndex="21" ToolTip="Enter EPF No."
                            MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                 <div class="col-md-3">
                     Pan No. :&nbsp;
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txtPAN" runat="server" TabIndex="22" ToolTip="Enter PAN No."
                            MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                 <div class="col-md-3">
                      Passport No. :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPassport" runat="server" TabIndex="23"
                            ToolTip="Enter Passport No." MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">Start Date :&nbsp; 
                </div>
                 <div class="col-md-5">
                      <asp:TextBox ID="txtStartTime"  runat="server" TabIndex="26" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calStartDate" runat="server" TargetControlID="txtStartTime" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    Blood Group :&nbsp;
                </div>
                 <div class="col-md-5">
                      <asp:DropDownList ID="cmgBloodGroup" runat="server" ToolTip="Select Blood Group" 
                            TabIndex="25">
                        </asp:DropDownList>
                </div>
            </div>
            <div class="row" style="display:none">
                <div class="col-md-3">
                    <asp:Label ID="Label2" runat="server" Text="Hospital :" Visible="False"></asp:Label>
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="cmbHospital" runat="server" TabIndex="24" Visible="False" Width="146px">
                        </asp:DropDownList>
                </div>
                <div class="col-md-3">
                      <asp:DropDownList ID="cmbUserType" runat="server"  Width="146px" Visible="false">
                        </asp:DropDownList>
                </div>
                <div class="col-md-5">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"><asp:CheckBox ID="IsMobile" runat="server" Text="Access Mobile App" ClientIDMode="Static" />
                </div>
                 <div class="col-md-3">
                     <asp:CheckBox ID="chkAllowSharing" Text="Allow Sharing" runat="server" />
                </div>
                <div class="col-md-4">
                    <asp:CheckBox ID="chkApproveSpecialRate"  Text="Approve Special Rate" runat="server" ClientIDMode="Static" />
                </div>
                 <div class="col-md-3">
                     <asp:CheckBox ID="chkAmrValueAccess" Text="Amr Value Access"  runat="server" ClientIDMode="Static" />
                </div>
                <div class="col-md-3">
                     <asp:CheckBox ID="chkHideRate" runat="server" Text="Hide Rate" style="margin-left:20px;"  /> 
                </div>
                 <div class="col-md-8">
                      <asp:CheckBox ID="chkIsEditMacReading" Text="Can Save/Approve amendment of machine reading" runat="server" />
                </div>
                <div class="col-md-4">
                      <asp:CheckBox ID="chkSampleReject" Text="Sample Logistic Reject" runat="server" />
                </div>
                <div class="col-md-4">
                      <asp:CheckBox ID="chkGlobalReportAccess" Text="Global Report Access" runat="server" />
                </div>
            </div>
        </div>



        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Login Details&nbsp;
            </div>
            <div class="row" style="display: none;">
                <div class="col-md-3">
                     <label>
                            Choose LoginType :&nbsp;</label>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                </div>
            </div>
              <div class="row">
                <div class="col-md-3alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111">
                    <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                     <asp:CheckBox ID="chkDept" runat="server" Text="Departments " onclick="SelectAllDepartments()" /></td>
                </div>
                <div class="col-md-21" style="overflow: scroll; height: 100px;  text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlDepartments" runat="server" RepeatColumns="7" RepeatDirection="Horizontal" OnDataBound="chkDeptmnts_DataBound">
                            </asp:CheckBoxList>
                     
                </div>
            </div>
            <div class="row">
                <asp:CheckBoxList ID="chkalllist" runat="server" RepeatDirection="Horizontal"
                            AutoPostBack="false" RepeatColumns="3" Style="display: none" />
            </div>
             <div class="row">
                <div class="col-md-3">
                    Zone :
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                 <div class="col-md-3">
                     State :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                <div class="col-md-3">
                     Centre :&nbsp;
                </div>
                <div class="col-md-4">
                     <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
                 <div class="col-md-1">
                     <input type="button" value="Add" id="btnAddCentre" class="searchbutton" onclick="addCentre()" />
                </div>
            </div>
              <div class="row">
                 <div class="col-md-3">
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                 </div>
                <div class="col-md-21"style="overflow: scroll; height: 100px;  text-align: left; border: solid 1px">

                <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                    <tr id="CentreHeader">
                       <%-- <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: center">Zone</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align: center">State</th>--%>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 560px; text-align: center">Centre</th>                        
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Remove</th>

                    </tr>
                </table>
                </div>
            </div>
              <div class="row">
                <div class="col-md-3">
                    Default Centre :&nbsp;
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlCentre" runat="server" Width="180px"></asp:DropDownList>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <asp:CheckBox ID="ChkRole" runat="server" Text="Roles " onclick="SelectAllRoles()" />
                </div>
                <div class="col-md-21" style="overflow: scroll; height: 100px;  text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="ChlRoles" runat="server" RepeatColumns="8" RepeatDirection="Horizontal" OnDataBound="chkRoles_DataBound">
                            </asp:CheckBoxList>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    Default Roles :&nbsp;
                </div>
                <div class="col-md-5">
                      <asp:DropDownList ID="ddlRoles" runat="server" ></asp:DropDownList>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <asp:CheckBox ID="chkLogin" runat="server" Text="UserName :" Checked="true" Enabled="false" />&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtuid" runat="server" Font-Bold="true" TabIndex="27"  ClientIDMode="Static" ></asp:TextBox>
                </div>
                 <div class="col-md-3">
                     Password :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtpwd" runat="server" Font-Bold="true"  ClientIDMode="Static" 
                            TextMode="Password" Style="position: static" TabIndex="27"></asp:TextBox>
                </div>
                 <div class="col-md-3">
                     Confirm Password :&nbsp;
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtcpwd" runat="server" Font-Bold="true" ClientIDMode="Static"
                            TextMode="Password" Style="position: static" TabIndex="27" ></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3" style="display: none; text-align: right; padding-top: 5px;padding-bottom: 8px;">
                        <asp:CheckBox ID="chkTranPWD" runat="server" Text="Transaction Password:" />
                </div>
                <div class="col-md-3" style="display: none; padding-top: 5px;padding-bottom: 8px;">
                        <asp:TextBox ID="txtTranPwd" runat="server" Font-Bold="true"
                            Style="position: static" TabIndex="27" TextMode="Password"></asp:TextBox>
                </div>
                <div class="col-md-3" style="display: none; padding-top: 5px;padding-bottom: 8px; text-align: right">Confirm Transaction Password :
                </div>
                <div class="col-md-3" style="display: none; padding-top: 5px;padding-bottom: 8px;">
                        <asp:TextBox ID="txtCTranPwd" runat="server" Font-Bold="true"
                            Style="position: static" TabIndex="27" TextMode="Password"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">            
            <input type="button" id="btnSave" value="Save" onclick="SaveData();"  style="display:none" class="savebutton"/>
            <input type="button" id="btnUpdate" value="Update" onclick="UpdateData();"  style="display:none" class="savebutton"/>
            
             <input type="button" id="btnClear" value="Clear" onclick="Clear();" class="resetbutton"/>

        </div>
    </div>
      <%--Designation Start--%>
        <asp:Button ID="btnhiddenDesignation" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="Designation" runat="server"
            DropShadow="true" TargetControlID="btnhiddenDesignation" CancelControlID="closeDesignation" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnldesignation" OnCancelScript="CloseDesignationWindow()" BehaviorID="Designation">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnldesignation" runat="server" Style="display: none; width: 350px; height: 130px;" CssClass="pnlVendorItemsFilter">
            <div class="Purchaseheader">
                <table style="width: 100%; border-collapse: collapse" border="0">
                    <tr>
                        <td>Add New Designation &nbsp;</td>
                        <td style="text-align: right">
                            <img id="closeDesignation" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" />
                        </td>
                    </tr>
                </table>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td colspan="2" style="text-align:center;">
                      &nbsp;  <label for="txtdesignation" id="lblMsgDesignation" class="ItDoseLblError"></label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px;text-align:right" >Designation :&nbsp;</td>
                    <td style="width: 233px;text-align:left" >
                        <input type="text" id="txtdesignation" style="width: 200px;" value=""  maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: center; ">
                            <input type="button" class="searchbutton" onclick="SaveDesignation()" id="btnsaveDesignation" style="" value="Save" />
                            <input type="button" class="searchbutton" onclick="CloseDesignationWindow()" id="btncancelDesignation" style="" value="Cancel" />
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <%--Designation End--%>
    <script type="text/javascript">
        function HideHead() {
            if ($('#ContentPlaceHolder1_ddlDesignation option:selected').text() == "PRO") {
                 $('#PRO1').show();
                 $('#PRO2').show();
             }
             else {
                 $('#PRO1').hide();
                 $('#PRO2').hide();
             }
         }
        function OpenDesignationWindow() {
            $find('Designation').show();
            $('#txtdesignation').focus();
        }
        function CloseDesignationWindow() {
            $find('Designation').hide();
            $('#txtdesignation').val('');
            $('#lblMsgDesignation').text('');
        }
        function SaveDesignation() {
            if ($.trim($('#txtdesignation').val()) == "") {
                $('#lblMsgDesignation').text("Please Enter Designation");
                $('#txtdesignation').focus();
                return;
            }
            $('#btnsaveDesignation').attr('disabled', 'disabled').val('Submitting...');
            serverCall('EmployeeRegistration.aspx/SaveDesignation', { DesignationName: $.trim($('#txtdesignation').val()) }, function (result) {
                               
                if (result == "Designation Name Already Exist") {
                    $('#lblMsgDesignation').text("Designation Name Already Exist");
                }
                else if (result == "Error") {
                    toast('Error','Error...','');
                }
                else {
                    var data = $.parseJSON(result)
                    $("#<%=ddlDesignation.ClientID%>").find('option:selected').removeAttr("selected");
                        $("#<%=ddlDesignation.ClientID%>").append('<option value="' + data.DesignationID + '" selected="selected">' + data.DesignationName + '</option>');
                        CloseDesignationWindow();
                    }
                $('#btnsaveDesignation').removeAttr('disabled').val('Save');
                $modelUnBlockUI(function () { });
            }   
            );
        }
    </script>
    <script type="text/javascript">
        function SelectAllDepartments() {
            var chkBoxList = document.getElementById("<%=chlDepartments.ClientID %>");
              var chkBoxCount = chkBoxList.getElementsByTagName("input");
              if (document.getElementById('<%=chkDept.ClientID %>').checked == true) {
                for (var i = 0; i < chkBoxCount.length; i++) {
                    document.getElementById('<%=chlDepartments.ClientID %>' + '_' + i).checked = true;
                }
            }
            else {
                for (var i = 0; i < chkBoxCount.length; i++) {
                    document.getElementById('<%=chlDepartments.ClientID %>' + '_' + i).checked = false;
                }
            }
        }
        

    function SelectAllRoles() {

        var chkBoxList = document.getElementById('<%=ChlRoles.ClientID %>');
        var chkBoxCount = chkBoxList.getElementsByTagName("input");
        if (document.getElementById('<%=ChkRole.ClientID %>').checked == true) {
            for (var i = 0; i < chkBoxCount.length; i++) {
                document.getElementById('<%=ChlRoles.ClientID %>' + '_' + i).checked = true;
                $("#<%=ddlRoles.ClientID %>").append($("<option></option>").val($('#<%=ChlRoles.ClientID %>' + '_' + i).closest('span').attr("id")).html($('#<%=ChlRoles.ClientID %>' + '_' + i).closest('span').attr("chk_text")));
            }
        }
        else {
            for (var i = 0; i < chkBoxCount.length; i++) {
                document.getElementById('<%=ChlRoles.ClientID %>' + '_' + i).checked = false;
             $("#<%=ddlRoles.ClientID %> option").remove();
         }
     }
 }
    </script>

     <script type="text/javascript">
         function Clear() {                                 
             jQuery("input[type=text], textarea").val('');            
             jQuery("#txtpwd,#txtcpwd").val('');             
             $("#<%=cmdTitle.ClientID %>,#<%=ddlDesignation.ClientID %>,#<%=cmbHospital.ClientID %>,#<%=cmbUserType.ClientID %>,#<%=cmgBloodGroup.ClientID %>").prop('selectedIndex',0);                          
             $("#<%=chkAllowSharing.ClientID %>,#<%=chkDept.ClientID %> ,#<%=ChkRole.ClientID %> ,#IsMobile").prop('checked', false);                                     
             SelectAllDepartments();             
           
             $("#<%=ddlCentre.ClientID %> option").remove();             
             SelectAllRoles();
             $("#<%=ddlRoles.ClientID %> option").remove();            
             jQuery("#lstZone").multipleSelect("uncheckAll");
             jQuery('#lstZone').multipleSelect("refresh");
             jQuery('#<%=lstState.ClientID%> option').remove();
             jQuery('#lstState').multipleSelect("refresh");
             jQuery('#<%=lstCentre.ClientID%> option').remove();
             jQuery('#lstCentre').multipleSelect("refresh");
             jQuery('#tbSelected').hide();
             jQuery("#tbSelected tr:not(#CentreHeader)").remove();
             CentreIDData.splice(0, CentreIDData.length);
             $("#<%= txtuid.ClientID%>").removeAttr('disabled');
            
         }
        </script>
    <script type="text/javascript">
        var EmpID = $('#<%=lblEmployee_ID.ClientID %>').text();
        $(function () {
            if ($('#ContentPlaceHolder1_ddlDesignation option:selected').text() == "PRO") {
                $('#PRO1').show();
                $('#PRO2').show();
            }
            else {
                $('#PRO1').hide();
                $('#PRO2').hide();
            }
            if (EmpID != '') {
                $("#btnUpdate").show();
                $("#btnSave").hide();
            }
            else {
                $("#btnUpdate").hide();
                $("#btnSave").show();
            }

            $("#<%=chkalllist.ClientID %> :checkbox").click(function () {
                $("#<%=chkalllist.ClientID %>").find(":checkbox").not(':checked').each(function () {
                    var val = $(this).closest('span').attr('class');
                    $("." + val + " input[type='checkbox']").attr('checked', false);
                });
                $("#<%=chkalllist.ClientID %>").find(":checkbox").filter(':checked').each(function () {
                    var val = $(this).closest('span').attr('class');
                    $("." + val + " input[type='checkbox']").attr('checked', true);
                });
            });

            $('.numbersOnly').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });

            $('.txtonly').keyup(function () {
                this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
            });

            
            $("#<%=ChlRoles.ClientID %> :checkbox").click(function () {
               
                $("#<%=ddlRoles.ClientID %> option").remove();
               // if ('<%=Request.QueryString["Employee_ID"]%>' == null) {
                    $("#<%=ChlRoles.ClientID %>").find(":checkbox").filter(':checked').each(function () {
                        $("#<%=ddlRoles.ClientID %>").append($("<option></option>").val($(this).closest('span').attr("id")).html($(this).closest('span').attr("chk_text")));
                    });
               // }
        });
            

          
            
        });

    </script>
    <script type="text/javascript">
        function SaveData() {
            var chkDepartmentID = "";
            var chkCentres = "";
            var chkRoles = "";
            
            if ($.trim($("#<%=txName.ClientID%>").val()) == "") {
                toast('Info',"Please Enter Name",'');
                $("#<%=txName.ClientID%>").focus();
                return;
            }
           // if ($("#<%=cmbUserType.ClientID%>").val() == 0) {
           //     alert("User Type must be selected.");
           //     $("#<%=cmbUserType.ClientID%>").focus();
           //     return;
           // }
            if ($("#<%=ddlDesignation.ClientID%>").val() == 0) {
                toast('Info',"Please Select Designation",'');
                $("#<%=ddlDesignation.ClientID%>").focus();
                return;
            }
            var AllowSharing = $('#<%= chkAllowSharing.ClientID %>').is(':checked') ? 1 : 0;
            var isLogin = $('#<%= chkLogin.ClientID %>').is(':checked') ? 1 : 0;

            $("[id*=chlDepartments] input:checked").each(function () {
                chkDepartmentID += $(this).val() + ',';
            });
            //$("[id*=chlCentres] input:checked").each(function () {
            //    chkCentres += $(this).val() + ',';
            //});
            if (jQuery('#tbSelected tr:not(#CentreHeader)').length == 0) {
                toast('Info','Please Add Centre','');
                $("#btnAddCentre").focus();
                return;
            }
            jQuery('#tbSelected tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "CentreHeader") {                   
                    chkCentres += jQuery(this).closest('tr').find("#tdCentreID").text() + ',';
                }
            });
            $("[id*=ChlRoles] input:checked").each(function () {
                chkRoles += $(this).val() + ',';
            });
            if (chkRoles == "") {
                toast('Info','Please Select Role','');
                return;
            }
            if ($.trim($("#<%=txtuid.ClientID%>").val()) == "") {
                toast('Info',"Please Enter User Name",'');
                $("#<%=txtuid.ClientID%>").focus();
                return;
            }
            if ($.trim($("#<%=txtuid.ClientID%>").val()).length < 2) {
                toast('Info',"Please Enter valid User Name.User Name Must Contain Atleast 2 Characters",'');
                $("#<%=txtuid.ClientID%>").focus();
                return;

            }
            if ($.trim($("#<%=txtpwd.ClientID%>").val()) == "") {
                toast('Info',"Please Enter Password",'');
                $("#<%=txtpwd.ClientID%>").focus();
                return;
            }
            if ($.trim($("#<%=txtpwd.ClientID%>").val()).length < 2) {
                toast('Info',"Please Enter valid Password.Password Must Contain Atleast 2 Characters",'');
                $("#<%=txtpwd.ClientID%>").focus();
                return;

            }
            if ($.trim($("#<%=txtpwd.ClientID%>").val()) !== $.trim($("#<%=txtcpwd.ClientID%>").val())) {
                toast('Info',"Password does not match.",'');
                return;
            }
            var ApproveSpecialRate = $("#chkApproveSpecialRate").is(':checked') ? 1 : 0;
            var AmrValueAccess = $("#chkAmrValueAccess").is(':checked') ? 1 : 0;
            var IsMobileAccess = $("#IsMobile").is(':checked') ? 1 : 0;
            var IsHideRate = $("[id$=chkHideRate]").is(':checked') ? 1 : 0;
            var PROID = 0;
            var IsEditMacReading = $('[id$=chkIsEditMacReading]').is(':checked') ? 1 : 0;
            var defaultcentre=$('#<%=ddlCentre.ClientID %>').val() ==null ?0:$('#<%=ddlCentre.ClientID %>').val();
            var IsSampleLogisticReject = $('[id$=chkSampleReject]').is(':checked') ? 1 : 0; 
            var IsGlobalReportAccess = $('[id$=chkGlobalReportAccess]').is(':checked') ? 1 : 0;

           $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
           serverCall('EmployeeRegistration.aspx/SaveData', { Title: $("#<%=cmdTitle.ClientID%>").val(), Name: $("#<%=txName.ClientID%>").val(), HouseNo: $("#<%=txtHouseNo.ClientID%>").val(), Street: $("#<%=txtStreet.ClientID%>").val(), Locality: $("#<%=txtLocality.ClientID%>").val(), City: $("#<%=txtCity.ClientID%>").val(), Pincode: $("#<%=txtPinCode.ClientID%>").val(), OHouse: $("#<%=txtOhouseNo.ClientID%>").val(), OStreet: $("#<%=txtOStreet.ClientID%>").val(), OLocality: $("#<%=txtOlocality.ClientID%>").val(), OCity: $("#<%=txtOCity.ClientID%>").val(), OPincode: $("#<%=txtOPinCode.ClientID%>").val(), Father: $("#<%=txtFather.ClientID%>").val(), Mother: $("#<%=txtMother.ClientID%>").val(), ESI: $("#<%=txtESI.ClientID%>").val(), EPF: $("#<%=txtEPF.ClientID%>").val(), PAN: $("#<%=txtPAN.ClientID%>").val(), Passport: $("#<%=txtPassport.ClientID%>").val(), DOB: $("#<%=txtDOB.ClientID%>").val(), Qualification: $("#<%=txtqualification.ClientID%>").val(), Email: $("#<%=txtEmail.ClientID%>").val(), AllowSharing: AllowSharing, STD: $("#<%=txtSTD.ClientID%>").val(), Phone: $("#<%=txtPhone.ClientID%>").val(), Mobile: $("#<%=txtMobile.ClientID%>").val(), BloodGroup: $("#<%=cmgBloodGroup.ClientID%>").val(), StartDate: $("#<%=txtStartTime.ClientID%>").val(), Username: $("#<%=txtuid.ClientID%>").val(), Pwd: $("#<%=txtpwd.ClientID%>").val(), ConfirmPwd: $("#<%=txtcpwd.ClientID%>").val(), Dept: chkDepartmentID, Centre: chkCentres, Role: chkRoles, Login: isLogin, defaultCentreID: defaultcentre, Designation: $('#<%=ddlDesignation.ClientID %> option:selected').text(), defaultRoleID: $('#<%=ddlRoles.ClientID %>').val(), ApproveSpecialRate: ApproveSpecialRate, AmrValueAccess: AmrValueAccess, DesignationID: $('#<%=ddlDesignation.ClientID %>').val(), ValidateLogin: 0, IsMobileAccess: IsMobileAccess, PROID: PROID, IsHideRate: IsHideRate, IsEditMacReading: IsEditMacReading, IsSampleLogisticReject: IsSampleLogisticReject, GlobalReportAccess: IsGlobalReportAccess, PROHeadID: $('#<%=ddlPROHead.ClientID%>').val() }, function (result) {
                var empSaveData = JSON.parse(result);
                if (empSaveData.status == false) {
                    toast("Error", empSaveData.response, '');
                }
                else if (empSaveData.status) {
                    toast("Success", "Record saved successfully !", '');
                    Clear();
                }
                $("#btnSave").attr('disabled', false).val('Save');
                $modelUnBlockUI(function () { });
            });

        }
    </script>
    <script type="text/javascript">
        function UpdateData() {                     
            var chkDepartmentID = "";
            var chkCentres = "";
            var chkRoles = "";
           
       
            if ($.trim($("#<%=txName.ClientID%>").val()) == "") {
                toast("Info","Please Enter Name",'');
                $("#<%=txName.ClientID%>").focus();
                return;
            }
          //  if ($("#<%=cmbUserType.ClientID%>").val() == 0) {
          //      alert("User Type must be selected.");
          //      $("#<%=cmbUserType.ClientID%>").focus();
          //      return;
          //  }
            if ($("#<%=ddlDesignation.ClientID%>").val() == 0) {
                toast("Info","Please Select Designation",'');
                $("#<%=ddlDesignation.ClientID%>").focus();
                return;
            }
            
            var isLogin = $('#<%=chkLogin.ClientID %>').is(':checked') ? 1 : 0;
         
            var AllowSharing = $('#<%= chkAllowSharing.ClientID %>').is(':checked') ? 1 : 0;
            $("[id*=chlDepartments] input:checked").each(function () {
                chkDepartmentID += $(this).val() + ',';
            });
            //$("[id*=chlCentres] input:checked").each(function () {
            //    chkCentres += $(this).val() + ',';
            //});
            if (jQuery('#tbSelected tr:not(#CentreHeader)').length == 0) {
                toast("Info",'Please Add Centre','');
                $("#btnAddCentre").focus();
                return;
            }
            jQuery('#tbSelected tr').each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "CentreHeader") {
                    chkCentres += jQuery(this).closest('tr').find("#tdCentreID").text() + ',';
                }
            });
            $("[id*=ChlRoles] input:checked").each(function () {
                chkRoles += $(this).val() + ',';
            });
            if (chkRoles == "") {
                toast("Info",'Please Select Role','');
                return;
            }
            
            
            if ($("#<%=chkLogin.ClientID%>").is(':checked')) {
                if ($.trim($("#<%=txtuid.ClientID%>").val()) == "") {
                    toast("Info","Please Enter User Name",'');
                    $("#<%=txtuid.ClientID%>").focus();
                    return;

                }

                if ($.trim($("#<%=txtuid.ClientID%>").val()).length < 2) {
                    toast("Info","Please Enter valid User Name.User Name Must Contain Atleast 2 Characters",'');
                    $("#<%=txtuid.ClientID%>").focus();
                    return;

                }
                if ($.trim($("#<%=txtpwd.ClientID%>").val()) == "") {
                    toast("Info","Please Enter Password",'');
                    $("#<%=txtpwd.ClientID%>").focus();
                    return;
                }
                if ($.trim($("#<%=txtpwd.ClientID%>").val()).length < 2) {
                    toast("Info","Please Enter valid Password.Password Must Contain Atleast 2 Characters",'');
                    $("#<%=txtpwd.ClientID%>").focus();
                    return;

                }
                if ($.trim($("#<%=txtpwd.ClientID%>").val()) !== $.trim($("#<%=txtcpwd.ClientID%>").val())) {
                    toast("Info","Password does not match.",'');
                    return;
                }
            }
            var ApproveSpecialRate = $("#chkApproveSpecialRate").is(':checked') ? 1 : 0;
            var AmrValueAccess = $("#chkAmrValueAccess").is(':checked') ? 1 : 0;
            var IsMobileAccess = $("#IsMobile").is(':checked') ? 1 : 0;
            var IsHideRate = $("[id$=chkHideRate]").is(':checked') ? 1 : 0;
            var IsEditMacReading = $("[id$=chkIsEditMacReading]").is(':checked') ? 1 : 0;
            var defaultcentre = $('#<%=ddlCentre.ClientID %>').val() == null ? 0 : $('#<%=ddlCentre.ClientID %>').val();
            var IsSampleLogisticReject = $('[id$=chkSampleReject]').is(':checked') ? 1 : 0;
            var IsGlobalReportAccess = $('[id$=chkGlobalReportAccess]').is(':checked') ? 1 : 0;
         
           $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
           serverCall('EmployeeRegistration.aspx/UpdateData', { Title: $("#<%=cmdTitle.ClientID%>").val(), Name: $("#<%=txName.ClientID%>").val(), HouseNo: $("#<%=txtHouseNo.ClientID%>").val(), Street: $("#<%=txtStreet.ClientID%>").val(), Locality: $("#<%=txtLocality.ClientID%>").val(), City: $("#<%=txtCity.ClientID%>").val(), Pincode: $("#<%=txtPinCode.ClientID%>").val(), OHouse: $("#<%=txtOhouseNo.ClientID%>").val(), OStreet: $("#<%=txtOStreet.ClientID%>").val(), OLocality: $("#<%=txtOlocality.ClientID%>").val(), OCity: $("#<%=txtOCity.ClientID%>").val(), OPincode: $("#<%=txtOPinCode.ClientID%>").val(), Father: $("#<%=txtFather.ClientID%>").val(), Mother: $("#<%=txtMother.ClientID%>").val(), ESI: $("#<%=txtESI.ClientID%>").val(), EPF: $("#<%=txtEPF.ClientID%>").val(), PAN: $("#<%=txtPAN.ClientID%>").val(), Passport: $("#<%=txtPassport.ClientID%>").val(), DOB: $("#<%=txtDOB.ClientID%>").val(), Qualification: $("#<%=txtqualification.ClientID%>").val(), Email: $("#<%=txtEmail.ClientID%>").val(), AllowSharing: AllowSharing, STD: $("#<%=txtSTD.ClientID%>").val(), Phone: $("#<%=txtPhone.ClientID%>").val(), Mobile: $("#<%=txtMobile.ClientID%>").val(), BloodGroup: $("#<%=cmgBloodGroup.ClientID%>").val(), StartDate: $("#<%=txtStartTime.ClientID%>").val(), Username: $("#<%=txtuid.ClientID%>").val(), Pwd: $("#<%=txtpwd.ClientID%>").val(), ConfirmPwd: $("#<%=txtcpwd.ClientID%>").val(), Dept: chkDepartmentID, Centre: chkCentres, Role: chkRoles, Login: isLogin, defaultCentreID: defaultcentre, Designation: $('#<%=ddlDesignation.ClientID %> option:selected').text(), defaultRoleID: $('#<%=ddlRoles.ClientID %>').val(), ApproveSpecialRate: ApproveSpecialRate, AmrValueAccess: AmrValueAccess, DesignationID: $('#<%=ddlDesignation.ClientID %>').val(), Employee_ID: $('#<%=lblEmployee_ID.ClientID %>').text(), ValidateLogin: 0, IsMobileAccess: IsMobileAccess, PROID: 0, IsHideRate: IsHideRate, IsEditMacReading: IsEditMacReading, IsSampleLogisticReject: IsSampleLogisticReject, GlobalReportAccess: IsGlobalReportAccess, PROHeadID: $('#<%=ddlPROHead.ClientID%>').val() }, function (result) {
                var empUpdateData =JSON.parse(result);
                if (empUpdateData.status == false) {
                    toast("Error", empUpdateData.response, '');       
                }
                else if (empUpdateData.status) {
                    toast("Success", "Record updated successfully !", '');
                    Clear();
                    location.href = '../../Design/Employee/EditEmployee.aspx';
                    
                }
                $("#btnUpdate").attr('disabled', false).val('Update');
                $modelUnBlockUI(function () { });
            });

        }

    </script>
    <script type="text/javascript">
        var CentreIDData = new Array();
        $(function () {
            bindZone();
            $('#lstZone').on('change', function () {
                var BusinessZoneID = $(this).val();
                bindBusinessZoneWiseState(BusinessZoneID);
            });
            $('#lstState').on('change', function () {
                var StateID = $(this).val();
                bindStateWiseCentre(StateID);
            });
        });
     
        function bindZone() {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (result) {
                BusinessZoneID = jQuery.parseJSON(result);
                for (i = 0; i < BusinessZoneID.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                }
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $modelUnBlockUI(function () { });
            });
        }
        function bindBusinessZoneWiseState(BusinessZoneID) {
           // if ($('#lblIsEdit').text() == 0) {
                jQuery('#<%=lstState.ClientID%> option').remove();
                jQuery('#lstState').multipleSelect("refresh");
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                if (EmpID == '')
                    jQuery('#<%=ddlCentre.ClientID%> option').remove();
            //  }
                if (BusinessZoneID != "") {
                    serverCall('EmployeeRegistration.aspx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID.toString() }, function (result) {
                        stateData = jQuery.parseJSON(result);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                        $modelUnBlockUI(function () { });
                    });
                }
        }
        function bindStateWiseCentre(StateID) {
           // if ($('#lblIsEdit').text() == 0) {
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                if (EmpID == '')
                jQuery('#<%=ddlCentre.ClientID%> option').remove();
            // }
                if (StateID != "") {
                    serverCall('EmployeeRegistration.aspx/bindStateWiseCentre', {StateID: StateID.toString() }, function (result) {
                        centreData = jQuery.parseJSON(result);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }
                        $('[id*=lstCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });    
                        $modelUnBlockUI(function () { });
                    });
                }
            }      
    </script>
    <script type="text/javascript">
        
        if (EmpID != '') {
            bindLoginCentre(EmpID);
        }
        function bindLoginCentre(Employee_ID) {
            //bindZone();
            serverCall('EmployeeRegistration.aspx/bindLoginCentre', {EmployeeID: Employee_ID }, function (result) {
                LoginCentre = jQuery.parseJSON(result);
                jQuery('#tbSelected').css('display', 'block');
                for (i = 0; i < LoginCentre.length; i++) {
                    CentreIDData.push(parseInt(LoginCentre[i].CentreID));
                    var mydata = [];
                    mydata.push("<tr id='"); mydata.push(LoginCentre[i].CentreID); mydata.push("'>");
                    mydata.push('<td class="GridViewItemStyle" id="tdSno" style="display:none">'); mydata.push(i + 1); mydata.push('</td>'); 
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreName">'); mydata.push(LoginCentre[i].Centre); mydata.push( '</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreID" style="display:none">'); mydata.push(LoginCentre[i].CentreID); mydata.push( '</td>');
                    mydata.push('<td class="GridViewItemStyle" style="text-align: center"><img src="../../App_Images/Delete.gif" style="cursor:pointer;text:align:center"  onclick="removeCentre(this)"/></td>'); 
                    mydata.push('</tr>');
                    mydata = mydata.join(" ");
                    $('#tbSelected').append(mydata);
                    $("#<%=ddlCentre.ClientID %>").append($("<option></option>").val(LoginCentre[i].CentreID).html(LoginCentre[i].Centre));
                 }
                 PageMethods.selectDefaultCentre(Employee_ID, onSucessDefaultCentre, onFailureDefaultCentre);
                 $modelUnBlockUI(function () { });
             });
         }
         function onSucessDefaultCentre(result) {
             $("#<%=ddlCentre.ClientID %>").val(result);
         }
         function onFailureDefaultCentre(result) {

         }
          </script>
    <script type="text/javascript">
        function addCentre() {
            if (jQuery("#lstCentre :selected").length == 0) {
                toast('Info', "Please Select Centre", '');
                jQuery("#btnAddCentre").focus();
                return;
            }
            var centreCon = 0;
            jQuery('#tbSelected').css('display', 'block');
            var addCentreCount = 0;
             $('#lstCentre :selected').each(function (i, selected) {                 
                if ($.inArray(parseInt($(selected).val()), CentreIDData) == -1) {
                    var mydata = [];
                    mydata.push("<tr id='"); mydata.push($(selected).val()); mydata.push("'>");
                    mydata.push('<td class="GridViewItemStyle" id="tdSno" style="display:none">'); mydata.push(i + 1); mydata.push('</td>');
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreName">'); mydata.push($(selected).text()); mydata.push('</td>'); 
                    mydata.push('<td class="GridViewItemStyle" id="tdCentreID" style="display:none">'); mydata.push($(selected).val()); mydata.push('</td>'); 
                    mydata.push('<td class="GridViewItemStyle" style="text-align: center"><img src="../../App_Images/Delete.gif" style="cursor:pointer;text:align:center"  onclick="removeCentre(this)"/></td>'); 
                    mydata.push('</tr>');
                    mydata = mydata.join(" ");
                    jQuery('#tbSelected').append(mydata);
                    jQuery("#<%=ddlCentre.ClientID %>").append($("<option></option>").val(jQuery(selected).val()).html(jQuery(selected).text()));
                    CentreIDData.push(parseInt($(selected).val()));
                    addCentreCount += 1;
                }
                else {
                    //selectedCentre.push($(selected).text());
                }
             });
            if (addCentreCount > 0)
                toast('Info', "Centre Added Successfully", '');
         }
        function removeCentre(rowID) {
            var trCentreID = jQuery.trim(jQuery(rowID).closest('tr').find("#tdCentreID").text());
            jQuery('#<%=ddlCentre.ClientID%> option[value=' + trCentreID + ']').remove();
            CentreIDData.splice($.inArray(parseInt(trCentreID), CentreIDData), 1);
            jQuery(rowID).closest('tr').remove();
            if (jQuery('#tbSelected tr:not(#CentreHeader)').length == 0) {
                jQuery('#tbSelected').hide();
            }
        }
       
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            
           
        });
         function bindAdrenalinData() {
             $.blockUI({
                 css: {
                     border: 'none',
                     padding: '15px',
                     backgroundColor: '#4CAF50',
                     '-webkit-border-radius': '10px',
                     '-moz-border-radius': '10px',
                     color: '#fff',
                     fontWeight: 'bold',
                     fontSize: '16px',
                     fontfamily: 'initial'
                 },
                 message: 'Searching Adrenalin Online...........!'
             });
             serverCall('EmployeeRegistration.aspx/bindAdrenalinData', {EmployeeCode: $("#<%= txtHouseNo.ClientID%>").val() }, function (result) {
                AdrenalinData = jQuery.parseJSON(result);
                if (AdrenalinData.length > 0) {
                    $("#<%= cmdTitle.ClientID%>").val((AdrenalinData[0].GENDER == 'M') ? "Mr." : "Mrs.");
                        $("#<%= txName.ClientID%>").val(AdrenalinData[0].EMPLOYEE_LEGAL_NAME);
                        $("#<%= txtFather.ClientID%>").val(AdrenalinData[0].FATHER_NAME);
                        $("#<%= txtMobile.ClientID%>").val(AdrenalinData[0].CONTACT_NUMER);
                        $("#<%= txtOhouseNo.ClientID%>").val(AdrenalinData[0].EMPLOYEE_ADDRESS);
                        $("#<%= txtOhouseNo.ClientID%>").val(AdrenalinData[0].EMPLOYEE_ADDRESS);                       
                        $("#<%= txtuid.ClientID%>").val(AdrenalinData[0].EMPLOYEE_EMPLOYEE_ID);
                        $("#<%= txtuid.ClientID%>").attr('disabled', 'disabled');
                        var todayTime = new Date(AdrenalinData[0].DATE_OF_BIRTH);                       
                        var month = todayTime.getMonth();
                        var day = ("0" + todayTime.getDate()).slice(-2);
                        var year = todayTime.getFullYear();
                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];                        
                        $("#<%= txtDOB.ClientID%>").val(day + "-" + months[month] + "-" + year);
                    }
                    else {
                        toast('Error', "Adrenalin Record Not Found.....!", '');
                        Clear();                       
                    }
                $modelUnBlockUI(function () { });
            });
        }
    </script>
</asp:Content>
