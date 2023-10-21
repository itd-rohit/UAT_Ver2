<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" EnableEventValidation="false" ValidateRequest="false" CodeFile="InterComMaster.aspx.cs" Inherits="Design_CallCenter_InterComMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory" style="width: 1300px;">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <b>InterCom Directory</b>
            <asp:Label ID="lblTicketID" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1296px">
            <div class="Purchaseheader">
                Submit Details
            </div>
            <div class="content" style="text-align: center; padding-right: 5px">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 30%; text-align: right">Employee Name<span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="EmployeeName" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                        <td style="width: 30%; text-align: right">Employee ID<span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtEmployeeCode" runat="server" Width="200px" MaxLength="10"></asp:TextBox></td>
                        <td style="width: 30%; text-align: right">Mobile No.<span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="Mobile" class="Mobile" runat="server" Width="200px" MaxLength="10"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="margin-top: 50px">
                        <td style="width: 30%; text-align: right">Email ID <span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="EmailID" class='emailid' runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                        <td style="width: 30%; text-align: right">Designation<span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="Designation" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                        </td>
                        <td style="width: 30%; text-align: right; vertical-align: top">Extension  Code <span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="ExtensionCode" runat="server" Rows="6" Width="200px" Style="max-width: 449px"></asp:TextBox>

                            <asp:Label ID="lblFileName" runat="server" Style="display: none;"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 30%; text-align: right">Center<span style="color: red; font-size: 10px">*</span> :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlCenter" onchange="checkcenter()" CssClass="chosen-select" runat="server" Width="200px"></asp:DropDownList>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <input type="button" id="btnSave" value="Save" onclick="Save()" class="searchbutton" />
            &nbsp;&nbsp;
            <input type="button" id="btnCancel" value="Cancel" onclick="Cancel()" class="searchbutton" />
        </div>
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <div class="Purchaseheader">
                Search Details
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>

                      <td style="width: 40%; text-align: right;color:red;padding-right: 192px;" colspan="7">Please upload excel in downloaded format</td>
                </tr>
                <tr>
                    <td style="width: 40%; text-align: left" colspan="4"></td>
                   
                    <td style="text-align: left; width: 10%;">
                        <asp:Button ID="btnDownload" runat="server" Text="DownLoad Excel" OnClick="lnk1_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />
                    </td>
                    <td style="width: 12%; text-align: right">
                        <b>Upload Excel <span style="color: red; font-size: 10px">*</span> :&nbsp;</b>
                    </td>
                    <td style="text-align: left; width: 36%;">
                        <asp:FileUpload ID="file1" accept=".xls,.xlsx" runat="server" /><asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />
                        <br />
                        <asp:Label ID="Label1" runat="server" ForeColor="Red"></asp:Label>
                    </td>
                </tr>
            </table>
            <div class="POuter_Box_Inventory" style="width: 1296px;">
                <div runat="server" id="tblData" style="max-height: 400px; overflow: auto;">
                    <table width="99%" id="tblAreaDetails"></table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="ActionDiv" runat="server" style="text-align: center; width: 1296px;">
                <input type="button" id="Button1" value="Save" onclick="SaveRecord()" runat="server" tabindex="9" style="cursor: pointer; padding: 5px; width: 150px; color: white; background-color: blue; font-weight: bold;" />
                <input type="button" value="Cancel" onclick="clearData()" style="cursor: pointer; padding: 5px; color: white; background-color: lightcoral; width: 150px; font-weight: bold;" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var count = 1;
        jQuery(function () {
            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                } else {
                    return true;
                }
            }
            $('.Mobile').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });

            $("#tblAreaDetails").tableHeadFixer();
            $(".Mobile").on('keypress keyup', function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    return false;
                }
            });

            $(".emailid").on('blur', function (e) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery(this).val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery(this).val("");
                }
            });
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
        function deleterow2(itemid) {
            var table = document.getElementById('tblAreaDetails');
            if ($('#tblAreaDetails tr').length > 2) {
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                $('#tblAreaDetails tbody tr').each(function (index) {
                    $(this).find('td:eq(0)').text(index + 1)
                })
                toast("Error", "Record deleted..", "");
            }
            else {
                toast("Info", "Atlease one item mendatory", "");
            }
        }
        function clearData() {
            $("#ActionDiv").hide();
            $("#<%=ddlCenter.ClientID %>").trigger("chosen:updated");
            $("#tblAreaDetails").empty();
        }
        function Save() {
            if (IsValid() == "1") {
                return;
            }
            else {
                jQuery('#btnSave').attr('disabled', 'disabled').val('Saving...');
                var arr = new Array();
                var obj = new Object();
                obj.EmployeeName = jQuery("#<%=EmployeeName.ClientID %>").val();
                obj.EmployeeCode = jQuery("#<%=txtEmployeeCode.ClientID %>").val();
                obj.CentreCode = jQuery("#<%=ddlCenter.ClientID %>").val().split('@')[1];
                obj.MobileNo = jQuery("#<%=Mobile.ClientID %>").val();
                obj.EmailID = jQuery.trim(jQuery("#<%=EmailID.ClientID %>").val());
                obj.ExtensionCode = jQuery.trim(jQuery("#<%=ExtensionCode.ClientID %>").val());
                obj.Designation = jQuery("#<%=Designation.ClientID %>").val();
                arr.push(obj);
                serverCall('../CallCenter/InterComMaster.aspx/Save', { data: arr }, function (response) {
                    var res = jQuery.parseJSON(response);
                    jQuery('#btnSave').removeAttr('disabled').val('Save');
                    if (res.Status == "1") {
                        toast("Success", res.msg, "");
                        clear();
                    } else {
                        toast("Error", res.msg, "");
                    }
                });

            }
        }

        function IsValid() {
            var con = 0;
            if (jQuery("#<%=EmployeeName.ClientID %>").val() == "") {
                toast("Error", "Please Enter Employee Name", "");
                jQuery("#<%=EmployeeName.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=txtEmployeeCode.ClientID %>").val() == "") {
                toast("Error", "Please Enter Employee Code", "");
                jQuery("#<%=txtEmployeeCode.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=Mobile.ClientID %>").val() == "") {
                jQuery("#<%=Mobile.ClientID %>").focus();
                toast("Error", "Please Enter Mobile Number", "");
                con = 1;
                return con;
            }
            if (jQuery("#<%=EmailID.ClientID %>").val() == "") {

                toast("Error", "Please Enter Email ID", "");
                jQuery("#<%=EmailID.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery('#<%=EmailID.ClientID %>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#<%=EmailID.ClientID %>').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtEmail').focus();
                    con = 1;
                    return con;
                }
            }
            if (jQuery("#<%=Designation.ClientID %>").val() == "") {

                jQuery("#<%=Designation.ClientID %>").focus();
                toast("Error", "Please Enter designation", "");
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery("#<%=ExtensionCode.ClientID %>").val()) == "") {
                toast("Error", "Please Enter Extension Code", "");
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlCenter.ClientID %>").val() == "0") {
                toast("Error", "Please Select centre", "");
                jQuery("#<%=ddlCenter.ClientID %>").focus();
                con = 1;
                return con;
            }
            return con;
        }
        function clear() {
            jQuery("#<%=ddlCenter.ClientID %>").val("");
            jQuery("#<%=EmployeeName.ClientID %>").val('');
            jQuery("#<%=Mobile.ClientID %>").val('');
            jQuery("#<%=txtEmployeeCode.ClientID %>").val('');
            jQuery("#<%=EmailID.ClientID %>").val('');
            jQuery("#<%=ExtensionCode.ClientID %>").val('');
            jQuery("#<%=Designation.ClientID %>").val('');
            $("#<%=ddlCenter.ClientID %>").trigger("chosen:updated");
        }

        function SaveRecord() {
            var SalesTarget = GetSalesTraget();
            if (SalesTarget == "0") {
                toast("Error", "Please add atlease one Employee details", "");
                return false;
            }
            else {
                if (SalesTarget == "2") {
                    toast("Error", "Please enter valid Mobile No at row number " + count, "");
                    return false;
                }
                if (SalesTarget == "1") {
                    toast("Error", "Please enter valid emailid at row number " + count, "");
                    return false;
                }

            }
            jQuery('#Button1').attr('disabled', 'disabled').val('Saving...');
            serverCall('../CallCenter/InterComMaster.aspx/SaveTarget', { data: SalesTarget }, function (response) {
                jQuery('#Button1').removeAttr('disabled').val('Save');
                var res = response;
                if (res == "1") {
                    toast("Success", "Saved Successfully!!!", "");
                    clearData();
                } else {
                    toast("Error", res, "");
                }
            });

        }
        function GetSalesTraget() {
            var ObsRanges = "";
            var Target = new Array();
            $('#tblAreaDetails tr').each(function (index) {
                if (index > 0) {
                    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                    if (filter.test($(this).find('td:eq(4) input').val())) {
                        if ($(this).find('td:eq(3) input').val().length == 10) {
                            var Obj = new Object();
                            Obj.EmployeeName = $(this).find('td:eq(1) input').val();
                            Obj.EmployeeCode = $(this).find('td:eq(2) input').val();
                            Obj.MobileNo = $(this).find('td:eq(3) input').val();
                            Obj.EmailId = $(this).find('td:eq(4) input').val();
                            Obj.ExtensionCode = $(this).find('td:eq(5) input').val();
                            Obj.Designation = $(this).find('td:eq(6) input').val();
                            Obj.CentreCode = $(this).find('td:eq(7) input').val();
                            Target.push(Obj);
                        }
                        else {
                            ObsRanges = "2";
                            count = index;
                            return false;
                        }

                    }
                    else {
                        ObsRanges = "1";
                        count =index;
                        return false;

                    }
                }

            });
            if (ObsRanges != "")
                return ObsRanges;
            else
                return Target;

        }
        function Cancel() {
            jQuery("#btnSave").val('Save');
            clear();
        }
        function checkcenter() {
            $('#tblAreaDetails tr').find('td:eq(7) input').val(jQuery("#<%=ddlCenter.ClientID %>").val().split('@')[1]);
            }

    </script>
</asp:Content>

