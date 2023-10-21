<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TitleMaster.aspx.cs" Inherits="Design_Master_TitleMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top: -42px">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Title With Gender Master</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Manage Title
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Title   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="text" autocomplete="off" id="textTitle" class="requiredField" maxlength="10" style="padding: 2px" data-title="Enter Title" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Gender </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlGender" CssClass="chosen-select" runat="server" Style="width: 200px">
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                            <asp:ListItem Value="Trans">Transgender</asp:ListItem>
                            <asp:ListItem Value="UnKnown">UnKnown</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-6">
                        <input type="checkbox" id="IsActive" value="1" style="margin-left: -2px;" /><label for="IsActive"> IsActive</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-9">
                        <span id="spnTitleID" style="display: none"></span>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" id="btnSave" class="savebutton" value="Save" onclick="$saveData()" style="margin-left: -250px;" />&nbsp;&nbsp;
            <input type="button" id="btnCancel" class="buttoncancel" value="Cancel" onclick="$cancelData()" style="display: none; background-color: #ff6a00" />
                &nbsp;&nbsp;&nbsp;&nbsp;
            
            </div>
            <div class="POuter_Box_Inventory">
                <div id="divTitleDetail">
                    <table id="tblTitle" border="1" style="border-collapse: collapse; width: 100%;" class="exporttoexcel">
                        <thead>
                            <tr id="Header" class="exporttoexcelheader">
                                <th scope="col" align="left" style="width: 10%">S.No</th>
                                <th scope="col" align="left" style="width: 45%">Title</th>
                                <th scope="col" align="left" style="width: 30%">Gender</th>
                                <th scope="col" align="left" style="width: 20%">Status</th>
                                <th scope="col" align="left" style="width: 10%">Select</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <div class="POuter_Box_Inventory" style="text-align: center;">
                        <button type="button" onclick="saveOrdering()" class="searchbutton">Save Order</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="myModal1" class="modal" style="display: none; position: fixed; zindex: 1; padding-top: 50px; left: 0; top: 50px; width: 100%; height: 80%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4);">
            <!-- Modal content -->
            <div class="modal-content" style="background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 25%;">
                <span class="close" style="color: #aaaaaa; float: right; font-size: 28px; font-weight: bold;">&times;</span>
                <div>
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">New Title </h4>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <table style="border-collapse: collapse;">
                                <thead>
                                    <tr id="tr1">
                                        <th align="right">Title :</th>
                                        <th align="left">
                                            <input type="text" autocomplete="off" id="txtTitle" class="requiredField" maxlength="10" style="padding: 2px" data-title="Enter Title" /></th>
                                        <td align="right">
                                            <button type="button" class="savebutton" style="width: 120px" onclick="$saveTitle({Title:jQuery.trim(jQuery('#txtTitle').val())})">Save</button></td>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <hr />
                        <br />
                        <br />
                        <div class="row">
                            <div id="divTitleMaster" style="height: 300px;">
                                <table id="tblTitleMaster" style="border-collapse: collapse; width: 100%" class="exporttoexcel">
                                    <thead>
                                        <tr id="trTitleHeader">
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 6%">S.No</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 20%">Title</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>

                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
               

            })
            function $bindTitleMasterDetail() {
                jQuery("#tblTitleMaster tr:not(#trTitleHeader)").remove();
                serverCall('TitleMaster.aspx/titleMasterDetail', { data: ar }, function (response) {
                    var $responseData = JSON.parse(response);
                    jQuery('#tblTitleMaster').css('display', 'block');
                    if ($responseData != null) {
                        for (var i = 0; i < $responseData.length; i++) {
                            var $appendText = [];
                            $appendText.push('<tr class="GridViewItemStyle" '); $appendText.push('">');
                            $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(i + 1); $appendText.push('</td>');
                            $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitleMaster_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Title); $appendText.push('</td>');
                            $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData[i].ID); $appendText.push('</td>');
                            $appendText.push("</tr>");
                            $appendText = $appendText.join("");
                            jQuery('#tblTitleMaster').append($appendText);
                        }
                    }

                });
            }
            pageLoad = function (sender, args) {
                if (!args.get_isPartialLoad()) {
                    $addHandler(document, "keydown", onKeyDown);
                }
            }
            function onKeyDown(e) {
                if (e && e.keyCode == Sys.UI.Key.esc) {
                    if (jQuery('#divAddTitle').is(':visible')) {
                        jQuery('#divAddTitle').hideModel();
                    }
                }
            }
            $openNewTitile = function () {
                jQuery('#divAddTitle input[type=text]').val('');
                jQuery('#txtTitle').focus();
                var modal = document.getElementById("myModal1");
                var span = document.getElementsByClassName("close");
                span.onclick = function () {
                    modal.style.display = "none";
                }
                // When the user clicks anywhere outside of the modal, close it
                window.onclick = function (event) {
                    if (event.target == modal) {
                        modal.style.display = "none";
                    }
                }
                modal.style.display = "block";
                $bindTitleMasterDetail();
            }
            $saveData = function () {
                if ($("#btnSave").val() == "Update" && $.trim($("#spnTitleID").text()) == "") {
                    toast("Error", "Please Select Title",'');
                    return;
                }
                if ($("#textTitle").val() == "") {
                    toast("Error", "Please Enter Title",'');
                    $("#textTitle").focus();
                    return;
                }
                var IsActive = '0';
                if ($('#IsActive').prop('checked')) {
                    IsActive = 1;
                }
                serverCall('TitleMaster.aspx/saveData', { title: $("#textTitle").val(), gender: $("#<%=ddlGender.ClientID %>").val(), typeData: $("#btnSave").val(), ID: $.trim($("#spnTitleID").text()), IsActive: IsActive }, function (response) {

                    if (response == "Record Saved Successfully" || response.split('|')[0] == "Record Updated Successfully") {
                        toast("Success", response,'');
                        if ($("#btnSave").val() == "Update") {
                            $("#tblTitle tbody tr").find("".concat('.tdTitle_', $.trim($("#spnTitleID").text()))).text($("#textTitle").val());
                            $("#tblTitle tbody tr").find("".concat('.tdGender_', $.trim($("#spnTitleID").text()))).text($("#<%=ddlGender.ClientID %>").val());
                        }
                        $("#textTitle").val('');
                        $("#<%=ddlGender.ClientID %>").val('Male');
                        $("#btnSave").val('Save');
                        $bindTitleDetail();
                    }
                    else {
                        toast("Error", response, "");
                    }

                });

            }
            $saveTitle = function (titleDetails) {
                if (titleDetails.Title.trim() == "") {
                    toast("Error", "Please Enter Title", '');
                    titleDetails.Title.focus();
                    return;
                }
                serverCall('TitleMaster.aspx/saveTitle', { titleName: titleDetails.Title.trim() }, function (response) {
                    if (response.split('|')[0] == "Record Saved Successfully") {
                        toast("Seccess", response.split('|')[0], '');

                        $bindTitleMasterDetail();
                        $("#textTitle").append($('<option />').val(response.split('|')[2]).text(response.split('|')[2]));
                        $("#textTitle").val(titleDetails.Title);
                        var $appendText = [];
                        $appendText.push('<tr class="GridViewItemStyle" '); $appendText.push('">');
                        $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(jQuery('#tblTitleMaster tr').length); $appendText.push('</td>');
                        $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitleMaster_'); $appendText.push(response.split('|')[1]); $appendText.push('">'); $appendText.push(response.split('|')[2]); $appendText.push('</td>');
                        $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push(response.split('|')[1]); $appendText.push('</td>');
                        $appendText.push("</tr>");
                        $appendText = $appendText.join("");
                        jQuery('#tblTitleMaster').append($appendText);
                        var modal = document.getElementById("myModal1");
                        modal.style.display = "none";
                    }
                    else {
                        toast("Error", response.split('|')[0], '');
                    }

                });

            }
            function $bindTitleDetail() {
                jQuery("#tblTitle tr:not(#Header)").remove();
                serverCall('TitleMaster.aspx/titleDetail', {}, function (response) {
                    var $responseData = JSON.parse(response);
                    jQuery('#tblTitle').css('display', 'block');
                    if ($responseData != null) {
                        for (var i = 0; i < $responseData.length; i++) {
                            var $appendText = [];
                            $appendText.push('<tr class="GridViewItemStyle" id="trTitle_'); $appendText.push($responseData[i].ID); $appendText.push('">');
                            $appendText.push('<td  style="font-weight:bold;text-align: left"> '); $appendText.push(i + 1); $appendText.push('</td>');
                            $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitle_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Title); $appendText.push('</td>');
                            $appendText.push('<td id="tdGender" style="font-weight:bold;text-align: left" class="tdGender_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Gender); $appendText.push('</td>');
                            $appendText.push('<td id="tdStatus" style="font-weight:bold;text-align: left">'); $appendText.push($responseData[i].Status); $appendText.push('</td>');
                            $appendText.push('<td  style="font-weight:bold;">'); $appendText.push("<img onclick='$selectTitle(this)' src='../Purchase/Image/edit.png' style='width: 15px; cursor:pointer'/>"); $appendText.push('</td>');
                            $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData[i].ID); $appendText.push('</td>');
                            $appendText.push("</tr>");
                            $appendText = $appendText.join("");
                            jQuery('#tblTitle').append($appendText);

                        }

                        // jQuery('#tblTitle').append('<tfoot><tr><td colspan="5"  align="center"></td></tr></tfoot>');

                        $("#tblTitle").tableDnD
                    ({
                        onDragClass: "GridViewDragItemStyle",
                        onDragStart: function (table, row) {
                            // $this.addClass("GridViewAltItemStyle");
                        }
                    });
                    }

                });
            }
            $selectTitle = function (rowID) {
                if (jQuery(rowID).closest('tr').find("#tdStatus").text() == "DeActive") {
                    $('#IsActive').prop('checked', false);
                }
                else {
                    $('#IsActive').prop('checked', true);
                }
                $("#textTitle").val(jQuery(rowID).closest('tr').find("#tdTitle").text());
                $("#<%=ddlGender.ClientID %>").val(jQuery(rowID).closest('tr').find("#tdGender").text());
                $("#<%=ddlGender.ClientID %>")
                $("#spnTitleID").text(jQuery(rowID).closest('tr').find("#tdID").text());
                $("#btnSave").val('Update');
                $("#btnCancel").show();
            }
            $(function () {
                $bindTitleDetail();
            });
            $cancelData = function () {
                $("#btnSave").val('Save');
                $("#btnCancel").hide();
                $("#spnTitleID").text('');
            }

            function saveOrdering() {
                var InvOrder = "";
                $("#tblTitle tr").each(function () {
                    if ($(this).attr('id') != "Header") {
                        var id = $(this).attr('id');
                        InvOrder += id.split('_')[1] + '|';
                    }
                });
                serverCall('TitleMaster.aspx/SaveOrdering', { InvOrder: InvOrder }, function (response) {
                    if (response == '1') {
                        toast("Success", 'Order Saved SuccessFully', '');
                        $bindTitleDetail();
                    }

                });
            }
        </script>
        <script>
            // Get the modal
            var modal = document.getElementById("myModal1");
            // Get the <span> element that closes the modal
            var span = document.getElementsByClassName("close")[0];
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }

            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>
    </form>
</body>
</html>

