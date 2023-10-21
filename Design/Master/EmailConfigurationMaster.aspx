<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EmailConfigurationMaster.aspx.cs" Inherits="Design_Master_EmailConfigurationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Email Configuration Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory " style="text-align: center">

            <div class="row  ">
                <div class="col-md-1 GridViewHeaderStyle">
                    S.No.
                </div>
                <div class="col-md-4 GridViewHeaderStyle">
                    Module
                </div>
                <div class="col-md-4 GridViewHeaderStyle">
                    Screen
                </div>
               
                <div class="col-md-4 GridViewHeaderStyle">
                    ToWhom
                </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    TagType
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    Client
                </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    EmailType
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    Active
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    View
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    1.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_1">Registration</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_1">Work Order</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_1" runat="server" onclick="$activeDeactiveToWhom($(this),1,'Patient')" />Patient<asp:CheckBox ID="chkClient_1" runat="server" onclick="$activeDeactiveToWhom($(this),1,'Client')" />Client<%--<asp:CheckBox ID="chkDoctor_11" runat="server" onclick="$activeDeactiveToWhom($(this),11,'Doctor')" />Doctor--%>
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_1" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),1)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_1" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,1)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Patient Registration Email
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_1" runat="server" onclick="$activeDeactiveEmail($(this),1)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_1" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,1)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    2.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_2">Reporting</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_2">Report Approval</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_2" runat="server" onclick="$activeDeactiveToWhom($(this),2,'Patient')" />Patient<asp:CheckBox ID="chkClient_2" runat="server" onclick="$activeDeactiveToWhom($(this),2,'Client')" />Client <asp:CheckBox ID="CheckBox1" runat="server" onclick="$activeDeactiveToWhom($(this),2,'Doctor')" />Doctor
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_2" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),2)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_2" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,2)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Email Lab Report
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_2" runat="server" onclick="$activeDeactiveEmail($(this),2)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_2" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,2)" />
                </div>
            </div>

             <div class="row">
                <div class="col-md-1 ">
                    3.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_3">PO to vendor</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_3">PO Creation</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_3" runat="server" onclick="$activeDeactiveToWhom($(this),3,'Client')" />Client 
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_3" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),3)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_3" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,3)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                   PO to Vendor
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_3" runat="server" onclick="$activeDeactiveEmail($(this),3)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_3" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,3)" />
                </div>
            </div>


              <div class="row">
                <div class="col-md-1 ">
                    4.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_4">Invoice</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_4">Invoice Creation</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_4" runat="server" onclick="$activeDeactiveToWhom($(this),4,'Client')" />Client 
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_4" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),4)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_4" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,4)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Invoice to Client
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_4" runat="server" onclick="$activeDeactiveEmail($(this),4)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_4" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,4)" />
                </div>
            </div>

             <div class="row">
                <div class="col-md-1 ">
                    5.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_5">New Client</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_5">Centre Master</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_5" runat="server" onclick="$activeDeactiveToWhom($(this),5,'Client')" />Client 
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_5" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),5)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_5" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,5)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Welcome Email to new Client
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_5" runat="server" onclick="$activeDeactiveEmail($(this),5)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_5" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,5)" />
                </div>
            </div>

             <div class="row">
                <div class="col-md-1 ">
                    6.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_6">Payment confirmation</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_6">OPD Settlement</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_6" runat="server" onclick="$activeDeactiveToWhom($(this),6,'Patient')" />Patient  
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_6" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),6)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_6" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,6)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Payment Confirmation to Patient
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_6" runat="server" onclick="$activeDeactiveEmail($(this),6)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_6" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,6)" />
                </div>
            </div>

               <div class="row">
                <div class="col-md-1 ">
                    7.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_7">Payment confirmation</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_7">Advance Payment/ Validate Payment</span>
                </div>
               
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_7" runat="server" onclick="$activeDeactiveToWhom($(this),7,'Client')" />Client  
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_7" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),7)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_7" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,7)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Payment Confirmation to Client
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_7" runat="server" onclick="$activeDeactiveEmail($(this),7)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_7" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,7)" />
                </div>
            </div>



        </div>
    </div>

    <div id="divEmailView" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 80%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">Email View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeEmailView()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                     <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Email Subject</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtEmailSubject" runat="server" CssClass="requiredField"  Width="100%" MaxLength="300"></asp:TextBox>
                            
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Email Body</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                             <CKEditor:CKEditorControl ID="txtEmailBody" BasePath="~/ckeditor" runat="server" EnterMode="BR" Width="100%" Height="300" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|TextColor|"></CKEditor:CKEditorControl>
                            <asp:TextBox ID="txtTemplate" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px" style="display:none;"></asp:TextBox>
                            <span id="spnEmailID" style="display: none"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Active Columns</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <span id="spnActiveColumns"></span>
                        </div>
                    </div>
                    <div class="row" style="display: none" id="divSQL">
                        <div class="col-md-5" style="display: none" >
                            <label class="pull-left">SQL Query</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19" style="display: none" >
                            <asp:TextBox ID="txtSQLQuery" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnPopUpSave" value="Save" onclick="$saveEmailTemp()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div id="divClient" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">Client View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeClientiew()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left"><b>Module</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnModule"></span>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"><b>Screen</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnScreen"></span>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">TagClient</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:DropDownList ID="ddlTagClient" runat="server" class="ddlTagClient chosen-select chosen-container" onchange="$bindClient()"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left"><span id="spnSaveType"></span>Client</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:ListBox ID="lstClient" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnClient" value="Save" onclick="$saveClient()" />
                        </div>
                    </div>
                    <div class="Purchaseheader divShow" style="display: none"><span id="spnType"></span></div>

                    <div class="row divShow" style="display: none">
                        <div class="col-md-24" style="width: 100%; max-height: 250px; overflow: auto;">
                            <table id="tblEmailClientList" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
                                <thead>
                                    <tr id="Header">
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 30px">S.No.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px">
                                            <input type="checkbox" class="chlAll" onclick="$selectAll(this)" /></th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 620px">Client</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row divShow" style="text-align: center; display: none">
                        <div class="col-md-24">
                            <input type="button" id="btnRemove" value="Remove Discard" onclick="$removeDiscard()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $selectAll = function (rowID) {
            if ($(rowID).is(':checked'))
                $(".chkInd").prop('checked', 'checked');
            else
                $(".chkInd").prop('checked', false);
        }
        $closeEmailView = function () {
            jQuery('#divEmailView').hideModel();
        }
        $closeClientiew = function () {
            jQuery('#divClient').closeModel();
        }
        $bindModule = function () {
            serverCall('EmailConfigurationMaster.aspx/bindModule', {}, function (response) {
                var $EmailConfig = JSON.parse(response);
                if ($EmailConfig.status) {
                    var $EmailClient = jQuery.parseJSON($EmailConfig.ActiveEmailClient);
                    $EmailConfig = jQuery.parseJSON($EmailConfig.response);
                    for (var i = 0; i < $EmailConfig.length ; i++) {
                        var $EmailClientResponse = jQuery.grep($EmailClient, function (value) {
                            return value.EmailConfigurationID == $EmailConfig[i].ID;
                        });
                        if ($EmailClientResponse.length > 0) {
                            for (var k = 0; k < $EmailClientResponse.length; k++) {
                                $('#lstTagType_' + $EmailConfig[i].ID).find(":checkbox[value='" + $EmailClientResponse[k].type1ID + "']").attr("checked", "checked");
                                $("[id*=lstTagType_" + $EmailConfig[i].ID + "] option[value='" + $EmailClientResponse[k].type1ID + "']").attr("selected", 1);
                                $('#lstTagType_' + $EmailConfig[i].ID).multipleSelect("refresh");
                            }
                        }
                        if ($EmailConfig[i].IsActive == "1")
                            jQuery('#chkActive_' + $EmailConfig[i].ID).prop('checked', 'checked');
                        else
                            jQuery('#chkActive_' + $EmailConfig[i].ID).prop('checked', false);

                        if ($EmailConfig[i].ID == "1") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "2") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "3") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "4") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "5") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "6") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);

                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "7") {
                            if ($EmailConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "8") {
                            if ($EmailConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "9") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "10") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "11") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $EmailConfig[i].ID).prop('checked', false);
                        }

                        else if ($EmailConfig[i].ID == "12") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "13") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "14") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "15") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "16") {
                            if ($EmailConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                            if ($EmailConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "17") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "18") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "19") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "20") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                        else if ($EmailConfig[i].ID == "21") {
                            if ($EmailConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $EmailConfig[i].ID).prop('checked', false);
                        }
                    }
                }
            })
        };
        $(function () {
            if ('<%=UserInfo.ID%>' == "1") {
                $('#divSQL').show();
            }
            else {
                $('#divSQL').hide();
            }
            $bindModule();
            for (var i = 1; i <= 21; i++) {
                $("#lstTagType_" + i).multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }

            $('[id*=lstClient]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

        });
    </script>
    <script type="text/javascript">
        $(document).keypress(function (e) {
            if (e.keyCode === 27) {
                alert('1');
            }
        });
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                alert('1');
                if (jQuery('#divEmailView').is(':visible')) {
                    alert('1');
                    $closeEmailView();
                }


            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        $saveTagType = function (TagType, EmailConfigurationID) {
            serverCall('EmailConfigurationMaster.aspx/saveTagType', { TagTypeID: TagType, EmailConfigurationID: EmailConfigurationID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                }
                else {
                    toast('Error', $responseData.response, '');
                }
            });
        }
        $activeDeactiveEmail = function (chkvalue, EmailConfigurationID) {
            var msg = "DeActivate"; var Active = 0;
            if ($(chkvalue).is(':checked')) {
                msg = "Activate";
                Active = 1;
            }
            $confirmationBox("".concat('Do You want to ', msg, " Email<br/><br/><b>Module :", $("#spnModule_" + EmailConfigurationID).text(), "</b><br/><b>Screen :", $("#spnScreen_" + EmailConfigurationID).text()), 2, Active, EmailConfigurationID, '', '');
        }
        $activeDeactiveToWhom = function (chkvalue, EmailConfigurationID, savingType) {
            var msg = "DeActivate"; var Active = 0;
            if ($(chkvalue).is(':checked')) {
                msg = "Activate";
                Active = 1;
            }
            $confirmationBox("".concat('Do You want to ', msg, " Email<br/><br/><b>Module :", jQuery("#spnModule_" + EmailConfigurationID).text(), "</b><br/><b>Screen :", $("#spnScreen_" + EmailConfigurationID).text()), 3, Active, EmailConfigurationID, '', savingType);
        }
        $view = function (rowID, EmailConfigurationID) {
            serverCall('EmailConfigurationMaster.aspx/bindEmailTemplate', { ID: EmailConfigurationID }, function (response) {
                var $EmailConfigDetail = JSON.parse(response);
                jQuery("#spnEmailID").text(EmailConfigurationID);
                jQuery("#txtTemplate").val($EmailConfigDetail[0].Template);

                var objResultEditor = CKEDITOR.instances['<%=txtEmailBody.ClientID%>'];
                objResultEditor.setData($EmailConfigDetail[0].Template);

                jQuery("#txtEmailSubject").val($EmailConfigDetail[0].Subject);

                jQuery("#spnActiveColumns").text($EmailConfigDetail[0].ActiveColumns);
                if ($EmailConfigDetail[0].EmailTrigger == "Schedule" && '<%=UserInfo.ID%>' == 1)
                    jQuery("#divSQL").show();
                else
                    jQuery("#divSQL").hide();
                if ('<%=UserInfo.ID%>' != 1)
                    jQuery("#txtSQLQuery").val($EmailConfigDetail[0].SQLQuery);
                jQuery('#divEmailView').showModel();
            });
        }
        $addClient = function (rowID, EmailConfigurationID) {
            jQuery('#ddlTagClient').prop('selectedIndex', 0);
            jQuery('#ddlTagClient').chosen('destroy').chosen();
            jQuery('.divShow').hide();
            jQuery('#spnModule').text($("#spnModule_" + EmailConfigurationID).text());
            jQuery('#spnScreen').text($("#spnScreen_" + EmailConfigurationID).text());
            jQuery('#tblEmailClientList tr').slice(1).remove();
            jQuery("#spnEmailID").text(EmailConfigurationID);
            $bindTagClient();
            jQuery('#divClient').showModel();
        }
        $bindTagClient = function () {
            serverCall('EmailConfigurationMaster.aspx/bindClientType', { EmailConfigurationID: jQuery("#spnEmailID").text() }, function (response) {
                jQuery("#ddlTagClient").bindDropDown({ data: JSON.parse(response).CentreType, valueField: 'ID', textField: 'type1', isSearchAble: true, defaultValue: "Select", showDataValue: '' });
            });
        };
        $bindEmailClientList = function ($EmailClient) {
            jQuery('#tblEmailClientList tr').slice(1).remove();
            if ($EmailClient != null) {
                for (var i = 0; i < $EmailClient.length ; i++) {
                    var $myData = [];
                    $myData.push('<tr  class="GridViewItemStyle">');
                    $myData.push('<td style="text-align:left" id="tdSNo">'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                    $myData.push('<td style="text-align:left" id="tdSelect">'); $myData.push('<input type="checkbox" class="chkInd" id="chkClientID_'); $myData.push($EmailClient[i].Panel_ID); $myData.push('"'); $myData.push('/></td>');
                    $myData.push('<td style="text-align:left" id="tdCompany_Name">'); $myData.push($EmailClient[i].Company_Name); $myData.push('</td>');
                    $myData.push('<td style="text-align:left;display:none" id="tdClientID">'); $myData.push($EmailClient[i].Panel_ID); $myData.push('</td>');
                    $myData.push('</tr>');
                    $myData = $myData.join("");
                    jQuery("#tblEmailClientList tbody").append($myData);
                }
            }
            if (jQuery("#tblEmailClientList").find('tbody tr').length > 0)
                jQuery(".divShow").show();
            else
                jQuery(".divShow").hide();
        };
        $bindClient = function () {
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
            jQuery('.chlAll').prop('checked', false);
            serverCall('EmailConfigurationMaster.aspx/bindClient', { CentreType1ID: $("#ddlTagClient option:selected").val(), EmailConfigurationID: $("#spnEmailID").text() }, function (response) {
                jQuery("#lstClient").bindMultipleSelect({ data: JSON.parse(response).client, valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstClient"), isClearControl: '' });
                jQuery('#tblEmailClientList tr').slice(1).remove();
                var $EmailClient = JSON.parse(response);
                $bindEmailClientList(jQuery.parseJSON($EmailClient.bindClient));
                if (JSON.parse(response).isActivatedTypeID > 0) {
                    jQuery("#btnClient").val('Discard Client');
                    jQuery("#spnType").text('Discard Client Details');
                    jQuery("#btnRemove").val('Remove Discard');
                    jQuery("#spnSaveType").text('Discard ');
                }
                else {
                    jQuery("#btnClient").val('Activate Client');
                    jQuery("#spnType").text('Activate Client Details');
                    jQuery("#btnRemove").val('Remove Activate');
                    jQuery("#spnSaveType").text('Activate ');
                }
            });
        }
        $removeDiscard = function () {
            if (jQuery(".chkInd").is(':checked').length == 0) {
                toast('Error', 'Please Select Client', '');
                return;
            }
            var AllClientID = [];
            jQuery("#tblEmailClientList").find('tbody tr').each(function () {
                var clientID = jQuery(this).closest('tr').find('#tdClientID').text();
                if (jQuery(this).closest('tr').find('#chkClientID_' + clientID).is(':checked')) {
                    AllClientID.push(clientID);
                }
            });
            if (AllClientID.length == 0) {
                toast('Error', 'Please Select Client', '');
                return;
            }
            var clients = AllClientID.toString();
            $confirmationBox("".concat('Do You want to ', $("#btnRemove").val(), " Client"), 1, clients, $("#spnEmailID").text(), $("#ddlTagClient").val(), $("#btnRemove").val());
        }
    </script>
    <script type="text/javascript">
        $saveClient = function () {
            if ($("#ddlTagClient").val() == "0") {
                toast('Error', 'Please Select TagClient', '');
                jQuery("#ddlTagClient").focus();
                return;
            }
            var ClientID = $("#lstClient").val().toString();
            if (ClientID == "") {
                toast('Error', 'Please Select Client', '');
                jQuery("#lstClient").focus();
                return;
            }
            serverCall('EmailConfigurationMaster.aspx/saveClient', { ClientID: ClientID, CentreType1ID: jQuery("#ddlTagClient").val(), SavingType: $("#btnClient").val(), EmailConfigurationID: $("#spnEmailID").text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                    $clearControl();
                    $bindEmailClientList(jQuery.parseJSON($responseData.bindClientActDis));
                }
                else
                    toast('Error', $responseData.response, '');
            });
        }
        $clearControl = function () {
            jQuery('#ddlTagClient').prop('selectedIndex', 0);
            jQuery('#ddlTagClient').chosen('destroy').chosen();
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
            jQuery('#tblEmailClientList tr').slice(1).remove();
        }
    </script>
    <script type="text/javascript">
        $confirmationBox = function (contentMsg, type, TagTypeID, EmailConfigurationID, CentreType1ID, savingType) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            $confirmationAction(type, TagTypeID, EmailConfigurationID, CentreType1ID, savingType);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction(type, EmailConfigurationID, savingType);
                        }
                    },
                }
            });
        }
        $confirmationAction = function ($type, TagTypeID, EmailConfigurationID, CentreType1ID, savingType) {
            debugger;
            if ($type == 0) {
                serverCall('EmailConfigurationMaster.aspx/saveTagType', { TagTypeID: TagTypeID, EmailConfigurationID: EmailConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        toast('Success', $responseData.response, '');
                    else
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 1) {
                serverCall('EmailConfigurationMaster.aspx/removeClient', { ClientID: TagTypeID, CentreType1ID: CentreType1ID, SavingType: savingType, EmailConfigurationID: EmailConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast('Success', $responseData.response, '');
                        $clearControl();
                        $bindEmailClientList(jQuery.parseJSON($responseData.bindClientActDis));
                        jQuery('.chlAll').prop('checked', false);
                    }
                    else
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 2) {
                serverCall('EmailConfigurationMaster.aspx/activeDeactiveEmail', { Active: TagTypeID, EmailConfigurationID: EmailConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        toast('Success', $responseData.response, '');
                    else
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 3) {
                serverCall('EmailConfigurationMaster.aspx/activeDeactiveToWhom', { Active: TagTypeID, EmailConfigurationID: EmailConfigurationID, savingType: savingType }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        toast('Success', $responseData.response, '');
                    else
                        toast('Error', $responseData.response, '');
                });
            }
        }
        $clearAction = function (type, EmailConfigurationID, savingType) {
            if (type == 2) {
                if ($("#chkActive_" + EmailConfigurationID).is(':checked'))
                    $("#chkActive_" + EmailConfigurationID).prop('checked', false);
                else
                    $("#chkActive_" + EmailConfigurationID).prop('checked', 'checked');
            }
            if (type == 3) {
                if (savingType == "Patient") {
                    if ($("#chkPatient_" + EmailConfigurationID).is(':checked'))
                        $("#chkPatient_" + EmailConfigurationID).prop('checked', false);
                    else
                        $("#chkPatient_" + EmailConfigurationID).prop('checked', 'checked');
                }
                else if (savingType == "Doctor") {
                    if ($("#chkDoctor_" + EmailConfigurationID).is(':checked'))
                        $("#chkDoctor_" + EmailConfigurationID).prop('checked', false);
                    else
                        $("#chkDoctor_" + EmailConfigurationID).prop('checked', 'checked');
                }
                else if (savingType == "Client") {
                    if ($("#chkClient_" + EmailConfigurationID).is(':checked'))
                        $("#chkClient_" + EmailConfigurationID).prop('checked', false);
                    else
                        $("#chkClient_" + EmailConfigurationID).prop('checked', 'checked');
                }
                else if (savingType == "Employee") {
                    if ($("#chkEmployee_" + EmailConfigurationID).is(':checked'))
                        $("#chkEmployee_" + EmailConfigurationID).prop('checked', false);
                    else
                        $("#chkEmployee_" + EmailConfigurationID).prop('checked', 'checked');
                }
            }
        }
        $saveEmailTemp = function () {

            var EmailBody;
            var objEmailBody = CKEDITOR.instances['<%=txtEmailBody.ClientID%>'];
            EmailBody = objEmailBody.getData();

            if (EmailBody.trim() == "null" || EmailBody.trim() == "<br />") {
                EmailBody = "";
            }

            if ($('#txtEmailSubject').val().trim() == "") {
                toast('Error', 'Please Enter Email Subject', '');
                $("#txtEmailSubject").focus();
                return;
            }

            if (EmailBody == "") {
                toast('Error', 'Please Enter Email Body', '');
                $("#txtTemplate").focus();
                return;
            }

           
            //  if ($("#txtSQLQuery").val() == "" && '<%=UserInfo.ID%>' == 1) {
            //toast('Error', 'Please Enter SQLQuery', '');
            //$("#txtSQLQuery").focus();
            //return;
            //  }
            serverCall('EmailConfigurationMaster.aspx/saveEmailTemplate', { ID: $("#spnEmailID").text(), Template: EmailBody, SQLQuery: $("#txtSQLQuery").val(), Subject: $('#txtEmailSubject').val().trim() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                }
                else {
                    toast('Error', $responseData.response, '');
                }
                $closeEmailView();
            });
        }
    </script>
</asp:Content>

