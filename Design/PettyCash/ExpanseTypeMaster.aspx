<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ExpanseTypeMaster.aspx.cs" Inherits="Design_PettyCash_ExpanseTypeMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <b>Expanse Type Master</b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expense Type Master
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Expense Type Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtexpansename" runat="server" CssClass="checkSpecialCharater_forPname requiredField" MaxLength="50"></asp:TextBox>
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Ledger No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtLedger" runat="server" CssClass="checkSpecialCharater_forPname requiredField" MaxLength="50"></asp:TextBox>
                    <asp:Label ID="lblid" runat="server" Style="display: none"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="radio" id="rdoActive" name="Active" class="Active" checked="checked" value="Active" />Active
                        <input type="radio" id="rdoInactive" name="Active" class="Active" value="InActive" />In- Active
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnsave" value="Save" onclick="Savedata();" />
            <input type="button" value="Cancel" onclick="$clearForm();" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Expense Type Detail
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div style="width: 100%; max-height: 375px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">
                                <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                <td class="GridViewHeaderStyle">Expense Type</td>
                                <td class="GridViewHeaderStyle">Ledger No.</td>
                                <td class="GridViewHeaderStyle">Created By</td>
                                <td class="GridViewHeaderStyle" style="width: 90px;">Created Date</td>
                                <td class="GridViewHeaderStyle" style="width: 50px;">Active</td>
                                <td class="GridViewHeaderStyle" style="width: 30px;">Edit</td>
                                <td style="display: none;" class="GridViewHeaderStyle">Remove</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function bindtable() {
            $('#tblitemlist tr').slice(1).remove();
            serverCall('ExpanseTypeMaster.aspx/bindtabledata', {}, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No data Found");
                }
                else {
                    bindData(ItemData);
                }
            });
        }
        function bindData(ItemData) {
            $('#tblitemlist tr').slice(1).remove();
            for (var i = 0; i <= ItemData.length - 1; i++) {
                var $myData = [];
                $myData.push("<tr style='background-color:#edc787 id='"); $myData.push(ItemData[i].Id); $myData.push("'>");
                $myData.push('<td  id="tdID" style="display:none;">'); $myData.push(ItemData[i].Id); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].TypeName); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].acc_code); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].CreateBy); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].date); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Active); $myData.push('</td>');
                $myData.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="Edit(\''); $myData.push(ItemData[i].Id); $myData.push('\',\''); $myData.push(ItemData[i].TypeName); $myData.push('\',\''); $myData.push(ItemData[i].acc_code); $myData.push('\',\''); $myData.push(ItemData[i].Active); $myData.push('\')" /></td>');
                $myData.push('<td  style="display:none;"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)" /></td>');
                $myData.push("</tr>");
                $myData = $myData.join("");
                $('#tblitemlist').append($myData);
            }
        }
        function $clearForm() {
            $('#txtexpansename,#txtLedger').val('');
            $('#txtexpansename').prop('disabled', false);
            $('#lblid').text('');
            $('#rdoActive').attr("checked", "checked");
            $('#btnsave').val('Save');
        }
        function Edit(id, name, acc_code, active) {
            $('#txtexpansename').val(name);
            $('#txtLedger').val(acc_code);
            $('#txtexpansename').prop('disabled', true);
            $('#lblid').text(id);
            if (active == "No")
                $('#rdoInactive').attr("checked", "checked");
            else
                $('#rdoActive').attr("checked", "checked");
            $('#btnsave').val('Update');
        }
        function deleterow(rowID) {
            $confirmationBox('Do You Want to Remove this item?', rowID);
        }
        $confirmationBox = function (contentMsg, rowID) {
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
                            $confirmationAction(rowID);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        $confirmationAction = function (rowID) {
            serverCall('ExpanseTypeMaster.aspx/removerow', { id: $(rowID).closest('tr').find("#tdID").text() }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    bindData(jQuery.parseJSON($responseData.responseDetail));
                }
                else {
                    toast("Error", $responseData.response);
                }

            });
        }
        $clearAction = function () {

        }
    </script>
    <script type="text/javascript">
        $(function () {
            bindtable();
        });
        function Savedata() {
            if ($.trim($('#txtexpansename').val()) == "") {
                toast("Error", "Please Enter Expanse Type Name");
                $('#txtexpansename').focus();
                return false;
            }
            if ($.trim($('#txtLedger').val()) == "") {
                toast("Error", "Please Enter Ledger No");
                $('#txtLedger').focus();
                return false;
            }
            var radioValue = $('.Active:checked').val();
            var Active = 0;
            if (radioValue == 'Active')
                Active = 1;
            var id = $('#lblid').text();
            $("#btnsave").attr('disabled', true).val("Submiting...");
            serverCall('ExpanseTypeMaster.aspx/Saveldiagnosisdata', { expansename: $('#txtexpansename').val(), LedgerNo: $('#txtLedger').val(), id: id, Active: Active }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    bindData(jQuery.parseJSON($responseData.responseDetail));
                    $clearForm();
                    toast("Success", $responseData.response);
                }
                else {
                    toast("Error", $responseData.response);
                }
                $('#btnsave').attr('disabled', false).val("Save");
            });
        }
        $(".checkSpecialCharater_forPname").keypress(function (e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById($(this).val().id);
            strLen = $(this).val().length;
            strVal = $(this).val();
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "/" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125") || (keynum >= "60" && keynum <= "64"))
                return false;
            else
                return true;
        });
    </script>
</asp:Content>