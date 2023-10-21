<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AliasMaster.aspx.cs" Inherits="Design_Lab_BillChargeReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Alias Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:HiddenField ID="hdnInvId" runat="server" />


        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <asp:Label ID="lblInvestigationName" runat="server"></asp:Label>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">New Alias </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtAlias" maxlength="100" class="requiredField" />
                </div>
                <div class="col-md-2">
                    <input type="button" id="btnAdd" value="Add" onclick="Add();" />
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblAlias" style="display: none;">


                    <tr id="trHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Alias</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 145px;">Created On</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 145px;">Created By</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 145px;">Status</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 5px;">
                            <input type="checkbox" id="chkAll" onclick="checkAll();" />
                        </th>
                    </tr>

                </table>
            </div>
        </div>
        <div id="divAction" class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Make InActive" onclick="MakeInActive();" />
            <input type="button" value="Make Active" onclick="MakeActive();" />

        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            BindAlias();

            $(document).keypress(function (e) {
                if (e.which == 13) {
                    $('[id$=btnAdd]').click();
                }
            });

        });

        function BindAlias() {
            $('#tblAlias tr').slice(1).remove();
            $.ajax({
                url: "AliasMaster.aspx/BindAlias",
                async: false,
                data: JSON.stringify({ ItemId: $('[id$=hdnInvId]').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = $.parseJSON(result.d);
                    var html = '';
                    if (data.length > 0) {
                        $('#tblAlias').show();
                        $('#divAction').show();
                        for (var i = 0; i < data.length; i++) {
                            html += '<tr id="' + data[i].ID + '">';
                            html += '<td class="GridViewrStyle">' + (i + 1) + '</td>';
                            html += '<td id="tdAlias" class="GridViewStyle">' + data[i].Alias + '</td>';
                            html += '<td class="GridViewStyle">' + data[i].CreatedOn + '</td>';
                            html += '<td class="GridViewStyle">' + data[i].EnteredByName + '</td>';
                            html += '<td class="GridViewStyle">' + data[i].STATUS + '</td>';
                            html += '<td class="GridViewStyle"><input type="checkbox"></td>';
                            html += '</tr>';

                        }

                        $('#tblAlias').append(html);
                    }
                    else {
                        $('#tblAlias').hide();
                        $('#divAction').hide();

                    }
                }
            });

        }

        function Add() {
            if ($('[id$=txtAlias]').val().trim() == "") {
                toast("Error", 'Please enter alias');
                return;
            }
            var IsValid = CheckAliasName();
            if (!IsValid) {
                toast("Error", 'Alias already exist');
                $('[id$=txtAlias]').val('');
                return;
            }
            if (IsValid) {
                $.ajax({
                    url: "AliasMaster.aspx/Add",
                    async: false,
                    data: JSON.stringify({ ItemId: $('[id$=hdnInvId]').val(), Alias: $('[id$=txtAlias]').val().trim() }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            $('[id$=txtAlias]').val('');
                            BindAlias();

                        } else {
                            toast("Error", 'Some Error Occured !');
                        }
                    }
                });
            }

        }


        function CheckAliasName() {
            var IsExists = false;

            $.ajax({
                url: "AliasMaster.aspx/CheckAliasName",
                async: false,
                data: '{Alias:"' + $('[id$=txtAlias]').val().trim() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "0")
                        IsExists = true;
                }
            });
            return IsExists;

        }

        function MakeInActive() {
            var IsValid = false;
            var Ids = '';
            $('#tblAlias').find('tr').each(function (index) {
                if (index > 0) {
                    if ($(this).find('input[type=checkbox]').is(':checked')) {
                        Ids += $(this).attr('id') + ",";
                        IsValid = true;
                    }
                }
            });
            if (IsValid) {
                Ids = Ids.substring(0, Ids.length - 1);

                $.ajax({
                    url: "AliasMaster.aspx/MarkActiveInActive",
                    async: false,
                    data: JSON.stringify({ AliasId: Ids, Status: 'InActive' }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        BindAlias();
                    }
                });
            }
            else {
                toast("Error", 'Please select any alias');
                return;
            }

        }

        function MakeActive() {
            var IsValid = false;
            var Ids = '';
            $('#tblAlias').find('tr').each(function (index) {
                if (index > 0) {
                    if ($(this).find('input[type=checkbox]').is(':checked')) {
                        Ids += $(this).attr('id') + ",";
                        IsValid = true;
                    }
                }
            });
            if (IsValid) {
                Ids = Ids.substring(0, Ids.length - 1);

                $.ajax({
                    url: "AliasMaster.aspx/MarkActiveInActive",
                    async: false,
                    data: JSON.stringify({ AliasId: Ids, Status: 'Active' }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        BindAlias();
                    }
                });
            }
            else {
                toast("Error", 'Please select any alias');
                return;
            }
        }

        function checkAll() {
            if ($('[id$=chkAll]').is(':checked')) {
                $('#tblAlias').find('tr').each(function (index) {
                    if (index > 0) {
                        $(this).find('input[type=checkbox]').prop('checked', true);
                    }
                });
            }
            else {
                $('#tblAlias').find('tr').each(function (index) {
                    if (index > 0) {
                        $(this).find('input[type=checkbox]').prop('checked', false);
                    }
                });
            }
        }
    </script>
</asp:Content>

