<%@ Page ClientIDMode="Static" Language="C#"  MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampApprovalRightMaster.aspx.cs" Inherits="Design_Camp_CampApprovalRightMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-confirm.min.js"></script>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:HiddenField runat="server" ID="hdn_AllSelect" Value="0" />
                <strong>Camp Approval Right Master
                </strong>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3 ">&nbsp;</div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Verification Type   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 ">
                        <asp:DropDownList ID="ddlVerificationType" runat="server" class="ddlVerificationType chosen-select chosen-container"></asp:DropDownList>
                    </div>
                    <div class="col-md-2 ">&nbsp;</div>
                    <div class="col-md-2 ">
                        <label class="pull-left">Employe   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5 ">
                        <asp:DropDownList ID="ddlEmployee" runat="server" class="ddlEmployee chosen-select chosen-container"></asp:DropDownList>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" id="btn_Save" value="Save" onclick="Save()" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div id="divApprovalRight" style="width: 100%; max-height: 300px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tblApprovalRight" style="border-collapse: collapse; display: none;" class="table">
                        <thead>
                            <tr id="trHeader">
                                <td class="GridViewHeaderStyle" style="width: 40px; text-align: center">S.No.</td>
                                <td class="GridViewHeaderStyle" style="width: 280px; text-align: center">Employee Name</td>
                                <td class="GridViewHeaderStyle" style="width: 120px; text-align: center">Verification</td>
                                <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Status</td>
                                <td class="GridViewHeaderStyle" style="width: 260px; text-align: center">Created By</td>
                                <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Created Date</td>
                                <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Remove</td>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    
        <script type="text/javascript">
            jQuery(function () {
                var config = {
                    '.chosen-select': {},
                    '.chosen-select-deselect': { allow_single_deselect: true },
                    '.chosen-select-no-single': { disable_search_threshold: 10 },
                    '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                    '.chosen-select-width': { width: "95%" }
                }
                for (var selector in config) {
                    jQuery(selector).chosen(config[selector]);
                }
            });
        </script>
        <script type="text/javascript">
            jQuery(function () {
                BindApprovalData();
            });
            function BindApprovalData() {
                serverCall('CampApprovalRightMaster.aspx/BindApprovalData', {}, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        bindApprovalRight($responseData.approvalRight);
                    }
                });
            }
            function bindApprovalRight(approvalRight) {
                jQuery("#tblApprovalRight tr:not(#trHeader)").remove();
                var ApprovalData = jQuery.parseJSON(approvalRight);
                if (ApprovalData.length == "0") {
                    toast('Info', "No Data Found");
                    return;
                }
                for (var i = 0; i < ApprovalData.length; i++) {
                    var appendText = [];
                    appendText.push("<tr >");
                    appendText.push('<td class="GridViewLabItemStyle" style="text-align:center">'); appendText.push((i + 1)); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle" id="tdEmpName" style="text-align:left">'); appendText.push(ApprovalData[i].Name); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle" id="tdVerificationType" style="text-align:left">'); appendText.push(ApprovalData[i].VerificationType); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle">'); appendText.push(ApprovalData[i].STATUS); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle">'); appendText.push(ApprovalData[i].CreatedBy); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle">'); appendText.push(ApprovalData[i].CreateDate); appendText.push('</td>');
                    appendText.push('<td class="GridViewLabItemStyle">');
                    if (ApprovalData[i].IsActive == "1") {
                        appendText.push('<img src="../../App_Images/delete.gif" style="cursor:pointer;margin-left: 15px;" onclick="RightsUpdate(\''); appendText.push(ApprovalData[i].VerificationType); appendText.push('\','); appendText.push(ApprovalData[i].Employee_ID); appendText.push(','); appendText.push(ApprovalData[i].IsActive); appendText.push(',this)">');

                    }
                    else {
                        appendText.push('<img src="../../App_Images/Approved.jpg" style="cursor:pointer;margin-left: 15px;width:15px;height:15px;" onclick="RightsUpdate(\''); appendText.push(ApprovalData[i].VerificationType); appendText.push('\','); appendText.push(ApprovalData[i].Employee_ID); appendText.push(','); appendText.push(ApprovalData[i].IsActive); appendText.push(',this)">');
                    }
                    appendText.push('</td>');
                    appendText.push("</tr>");
                    appendText = appendText.join("");
                    jQuery('#tblApprovalRight').append(appendText);
                }
                jQuery("#tblApprovalRight").tableHeadFixer({
                });
                jQuery("#tblApprovalRight").show();
            }
            function Save() {
                if (jQuery('#ddlVerificationType').val() == 0) {
                    jQuery('#ddlVerificationType').focus();
                    toast('Error', "Please Select Verification Type");
                    return;
                }
                if (jQuery('#ddlEmployee').val() == 0) {
                    jQuery('#ddlEmployee').focus();
                    toast('Error', "Please Select Employee");
                    return;
                }
                serverCall('CampApprovalRightMaster.aspx/Save', { VerificationType: jQuery('#ddlVerificationType').val(), EmployeeId: jQuery('#ddlEmployee').val() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast('Success', $responseData.response);
                        bindApprovalRight($responseData.approvalRight);
                    }
                    else {
                        toast('Error', $responseData.response);
                    }
                });
            }
            function RightsUpdate(VerificationType, EmployeeId, Isactive, rowID) {
                var msg = "";
                var EmpName = $(rowID).closest('tr').find("#tdEmpName").text();
                if (Isactive == 1)
                    msg = "".concat('Do you want to De-Active ', '?', '<br/><br/><b>Employee Name: ', EmpName, '</b>', '<br/><b>Verification Type: ', VerificationType, '</b>')
                else
                    msg = "".concat('Do you want to Active ', '?', '<br/><br/><b>Employee Name: ', EmpName, '</b>', '<br/><b>Verification Type: ', VerificationType, '</b>')
                confirmDelete(VerificationType, EmployeeId, Isactive, msg);
            }
            confirmDelete = function (VerificationType, EmployeeId, Isactive, msg) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: msg,
                    animation: 'zoom',
                    closeAnimation: 'scale',
                    useBootstrap: false,
                    opacity: 0.5,
                    theme: 'light',
                    type: 'red',
                    typeAnimated: true,
                    boxWidth: '420px',
                    buttons: {
                        'confirm': {
                            text: 'Yes',
                            useBootstrap: false,
                            btnClass: 'btn-blue',
                            action: function () {
                                serverCall('CampApprovalRightMaster.aspx/RightsUpdate', { VerificationType: VerificationType, EmployeeId: EmployeeId, Isactive: Isactive }, function (response) {
                                    var $responseData = JSON.parse(response);
                                    if ($responseData.status) {
                                        toast('Success', $responseData.response);
                                        bindApprovalRight($responseData.approvalRight);
                                    }
                                    else {
                                        toast('Error', $responseData.response);
                                    }
                                });
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearActions();
                            }
                        },
                    }
                });
            }
            clearActions = function () {

            }
        </script>

   </asp:Content>
