<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CategoryMaster.aspx.cs" Inherits="Design_Support_CategoryMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <style type="text/css">
        .hide {
            display: none;
        }

        .multiselect {
            width: 100%;
        }

        .theBox_3 {
            display: none;
            border: 1px solid #000;
            width: 200px;
            height: 100px;
            background-color: #ddf;
        }

        #toggleSwitch_j, #StayOpen {
            background-color: #cacaca;
        }
    </style>
    <div id="Pbody_box_inventory">
       
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Category Master</b>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Manage Category
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Category Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="hidden" id="hfCatID" value="0" />
                    <input type="text" id="txtCategory" maxlength="50" class="requiredField"/>
                </div>
                <div class="col-md-1">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Show   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSClient" />Show Client
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMClient" />
                    Mandatory Client
                </div>
            </div>

            <div class="row" style="display:none">
                <div class="col-md-6">
                </div>

                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSRole" />
                    Show Role
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMRole" />
                    Mandatory Role
                </div>

            </div>
            <div class="row" style="display:none">
                <div class="col-md-6">
                </div>

                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSCentre" />
                    Show Centre
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMCentre" />
                    Mandatory Centre
                </div>

            </div>

            <div class="row">
                <div class="col-md-6">
                </div>

                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSBarcodeNo" />
                    Show BarCode No.
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMBarcodeNo" />
                    Mandatory BarCode No.
                </div>

            </div>

            <div class="row">
                <div class="col-md-6">
                </div>

                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSLabNo" />
                    Show Visit No.
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMLabNo" />
                    Mandatory Visit No.
                </div>

            </div>

            <div class="row">
                <div class="col-md-6">
                </div>

                <div class="col-md-5">
                    <input type="checkbox" class="chkShow" id="chkSTestCode" />
                    Show Test 
                </div>
                <div class="col-md-5">
                    <input type="checkbox" class="chkMan" id="chkMTestCode" />
                    Mandatory Test 
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Status   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="checkbox" id="ChkActive" checked="checked" />
                    Active/DeActive
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Hide in Roles   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstRole" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <button id="btnSubmit" type="button" value="Submit" onclick="InsertCategoryDerails()">Submit</button>&nbsp;
            <button id="btnUpdate" type="button" value="Update" onclick="UpdateDetails()" style="display: none">Update</button>&nbsp;
            <button id="btnCancel" type="button" value="Cancel" onclick="Cancel()">Cancel</button>&nbsp;               
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 100%" id="tblCategory">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 42px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 300px;">Category Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Show Client</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;display:none">Show Role</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;display:none">Show Centre</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Show BarCode No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Show Visit No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Show Test</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Status</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 66px;">Action</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">TAT</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">TAG Employee</th>
                        </tr>
                    </thead>
                    <tbody id="msg">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            MandatoryDisabled('0', false);
            GetCategoryDetails('0');
        });
        $(".chkShow").change(function () {
            MandatoryDisabled($(this).attr("id"), $(this).prop('checked'));
        });
        function MandatoryDisabled(ChkBox, isChecked) {
            if (ChkBox == "0") {
                $("input[type=checkbox]").prop("checked", false);
                $(".chkMan").attr("disabled", "disabled");
                $("#ChkActive").prop("checked", "checked");
                return false;
            }
            if (isChecked) {
                $("#" + ChkBox.replace('chkS', 'chkM')).removeAttr("disabled");
            }
            else {
                $("#" + ChkBox.replace('chkS', 'chkM')).prop("checked", false);
                $("#" + ChkBox.replace('chkS', 'chkM')).attr("disabled", "disabled");
            }
        }
        function GetCategoryDetails(Id) {
            serverCall('CategoryMaster.aspx/GetCategoryList', { Id: Id }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    CategoryData(jQuery.parseJSON($responseData.responseDetail));
                }
                else {
                }
            });
        }
        function CategoryData($responseResult) {
            jQuery("#tblCategory tbody").empty();
            for (var i = 0; i < $responseResult.length; i++) {
                var $row = [];
                $row.push('<tr>');
                $row.push('<td>'); $row.push((i + 1)); $row.push('</td>');
                $row.push('<td id="tdCategoryName" Style="text-align:left">'); $row.push($responseResult[i]["CategoryName"]); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["ShowClient"]); $row.push('</td>');
                $row.push('<td style="display:none">'); $row.push($responseResult[i]["ShowRole"]); $row.push('</td>');
                $row.push('<td style="display:none">'); $row.push($responseResult[i]["ShowCentre"]); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["ShowBarcodeNo"]); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["ShowLabNo"]); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["ShowTestCode"]); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["IsActive"]); $row.push('</td>');
                $row.push('<td><button type="button" class="Submit" id="btnEdit" onclick="EditCatgory('); $row.push($responseResult[i]["ID"]); $row.push(')">Edit</button></td>');
                $row.push('<td><button type="button" class="Submit" id="btnTAT" onclick="CategoryTAT(this,'); $row.push($responseResult[i]["ID"]); $row.push(')">TAT</button></td>');
                $row.push('<td><button type="button" class="Submit" id="btnTAT" onclick="CategoryEmpTAT(this,'); $row.push($responseResult[i]["ID"]); $row.push(')">TAG Employee</button></td>');
                //  $row.push('<td><a target="_blank" href="CategoryTAT.aspx?ID='); $row.push($responseResult[i]["ID"]); $row.push('&N='); $row.push($responseResult[i]["CategoryName"]); $row.push('" id="anchEdit">TAT</a></td>');
                //  $row.push('<td><a href="CustomerCare_Inquiry_Category.aspx?ID='); $row.push($responseResult[i]["ID"]); $row.push('&N='); $row.push($responseResult[i]["CategoryName"]); $row.push('" target="_blank" id="anchEdit">TAG Employee</a></td>');
                $row.push('</tr>');
                $row = $row.join("");
                jQuery("#tblCategory tbody").append($row);
            }
        }
        function CategoryTAT(rowID, ID) {
            var CategoryName = $(rowID).closest('tr').find('#tdCategoryName').text();
            serverCall('CategoryMaster.aspx/encryptData', { CategoryName: CategoryName, ID: ID }, function (response) {
                var $responseData = JSON.parse(response);
                window.open("CategoryTAT.aspx?ID=" + $responseData.ID + "&N=" + $responseData.CategoryName);
            });
        }
        function CategoryEmpTAT(rowID, ID) {
            var CategoryName = $(rowID).closest('tr').find('#tdCategoryName').text();
            serverCall('CategoryMaster.aspx/encryptData', { CategoryName: CategoryName, ID: ID }, function (response) {
                var $responseData = JSON.parse(response);
                window.open("CategoryTagEmployee.aspx?ID=" + ID + "&N=" + CategoryName);
            });
        }
        function EditCatgory(ID) {
            serverCall('CategoryMaster.aspx/GetCategoryList', { Id: ID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var $responseResult = jQuery.parseJSON($responseData.responseDetail);
                    $("#hfCatID").val($responseResult[0]["ID"])
                    $("#txtCategory").val($responseResult[0]["CategoryName"]);

                    $responseResult[0]["ShowClient"] == "1" ? $("#chkSClient").prop("checked", "checked") : $("#chkSClient").prop("checked", false);
                    $responseResult[0]["MandatoryClient"] == "1" ? $("#chkMClient").prop("checked", "checked") : $("#chkMClient").prop("checked", false);
                    $responseResult[0]["ShowClient"] == "0" ? $("#chkMClient").prop("disabled", "disabled") : $("#chkMClient").removeAttr("disabled");

                    $responseResult[0]["ShowRole"] == "1" ? $("#chkSRole").prop("checked", "checked") : $("#chkSRole").prop("checked", false);
                    $responseResult[0]["MandatoryRole"] == "1" ? $("#chkMRole").prop("checked", "checked") : $("#chkMRole").prop("checked", false);
                    $responseResult[0]["ShowRole"] == "0" ? $("#chkMRole").prop("disabled", "disabled") : $("#chkMRole").removeAttr("disabled");

                    $responseResult[0]["ShowCentre"] == "1" ? $("#chkSCentre").prop("checked", "checked") : $("#chkSCentre").prop("checked", false);
                    $responseResult[0]["MandatoryCentre"] == "1" ? $("#chkMCentre").prop("checked", "checked") : $("#chkMCentre").prop("checked", false);
                    $responseResult[0]["ShowCentre"] == "0" ? $("#chkMCentre").prop("disabled", "disabled") : $("#chkMCentre").removeAttr("disabled");
                    $responseResult[0]["ShowBarcodeNo"] == "1" ? $("#chkSBarcodeNo").prop("checked", "checked") : $("#chkSBarcodeNo").prop("checked", false);
                    $responseResult[0]["MandatoryBarcodeNo"] == "1" ? $("#chkMBarcodeNo").prop("checked", "checked") : $("#chkMBarcodeNo").prop("checked", false);
                    $responseResult[0]["ShowBarcodeNo"] == "0" ? $("#chkMBarcodeNo").prop("disabled", "disabled") : $("#chkMBarcodeNo").removeAttr("disabled");

                    $responseResult[0]["ShowLabNo"] == "1" ? $("#chkSLabNo").prop("checked", "checked") : $("#chkSLabNo").prop("checked", false);
                    $responseResult[0]["MandatoryLabNo"] == "1" ? $("#chkMLabNo").prop("checked", "checked") : $("#chkMLabNo").prop("checked", false);
                    $responseResult[0]["ShowLabNo"] == "0" ? $("#chkMLabNo").prop("disabled", "disabled") : $("#chkMLabNo").removeAttr("disabled");

                    $responseResult[0]["ShowTestCode"] == "1" ? $("#chkSTestCode").prop("checked", "checked") : $("#chkSTestCode").prop("checked", false);
                    $responseResult[0]["MandatoryTestCode"] == "1" ? $("#chkMTestCode").prop("checked", "checked") : $("#chkMTestCode").prop("checked", false);
                    $responseResult[0]["ShowTestCode"] == "0" ? $("#chkMTestCode").prop("disabled", "disabled") : $("#chkMTestCode").removeAttr("disabled");
                    $responseResult[0]["IsActive"] == "1" ? $("#ChkActive").prop("checked", "checked") : $("#ChkActive").prop("checked", false);
                    var RolesID = new Array();
                    RolesID = $responseResult[0]["ShowRole1"].split(',');
                    $('#<%=lstRole.ClientID%>').val(RolesID);
                    $('[id$=lstRole]').multipleSelect('refresh');
                    $("#btnUpdate").show();

                    $("#btnSubmit").hide();
                    $("html, body").animate({ scrollTop: 0 }, "slow");
                }
            });
        }
        function InsertCategoryDerails() {
            if ($.trim($("#txtCategory").val()) == '') {
                toast("Error", "Please Enter Category Name");
                $("#txtCategory").focus();
                return false;
            }
            var CategoryName = $.trim($("#txtCategory").val());
            var ShowClient = $("#chkSClient").is(":checked") == true ? 1 : 0;
            var ShowRole = $("#chkSRole").is(":checked") == true ? 1 : 0;
            var ShowCentre = $("#chkSCentre").is(":checked") == true ? 1 : 0;
            var ShowBarcodeNo = $("#chkSBarcodeNo").is(":checked") == true ? 1 : 0;
            var ShowLabNo = $("#chkSLabNo").is(":checked") == true ? 1 : 0;
            var ShowTestCode = $("#chkSTestCode").is(":checked") == true ? 1 : 0;
            var MandatoryClient = $("#chkMClient").is(":checked") == true ? 1 : 0;
            var MandatoryRole = $("#chkMRole").is(":checked") == true ? 1 : 0;
            var MandatoryCentre = $("#chkMCentre").is(":checked") == true ? 1 : 0;
            var MandatoryBarcodeNo = $("#chkMBarcodeNo").is(":checked") == true ? 1 : 0;
            var MandatoryLabNo = $("#chkMLabNo").is(":checked") == true ? 1 : 0;
            var MandatoryTestCode = $("#chkMTestCode").is(":checked") == true ? 1 : 0;
            var IsActive = $("#ChkActive").is(":checked") == true ? 1 : 0;
            var selectRole = "";
            $('#<%=lstRole.ClientID%> :selected').each(function (i, selected) {
                if (selectRole == "") {
                    selectRole = $(selected).val();
                }
                else {
                    selectRole = selectRole + "," + $(selected).val();
                }
            });
            serverCall('CategoryMaster.aspx/InsertCategoryDetails', { CategoryName: CategoryName, ShowClient: ShowClient, ShowRole: ShowRole, ShowCentre: ShowCentre, ShowBarcodeNo: ShowBarcodeNo, ShowLabNo: ShowLabNo, ShowTestCode: ShowTestCode, MandatoryClient: MandatoryClient, MandatoryRole: MandatoryRole, MandatoryCentre: MandatoryCentre, MandatoryBarcodeNo: MandatoryBarcodeNo, MandatoryLabNo: MandatoryLabNo, MandatoryTestCode: MandatoryTestCode, IsActive: IsActive, Roles: selectRole }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    clear();
                    CategoryData(jQuery.parseJSON($responseData.responseDetail))
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function UpdateDetails() {
            if ($.trim( $("#txtCategory").val()) == '') {
                toast("Error", "Please Enter Category Name");
                $("#txtCategory").focus();
                return false;
            }
            var ID = $("#hfCatID").val();
            var CategoryName = $("#txtCategory").val();
            var ShowClient = $("#chkSClient").is(":checked") == true ? 1 : 0;
            var ShowRole = $("#chkSRole").is(":checked") == true ? 1 : 0;
            var ShowCentre = $("#chkSCentre").is(":checked") == true ? 1 : 0;
            var ShowBarcodeNo = $("#chkSBarcodeNo").is(":checked") == true ? 1 : 0;
            var ShowLabNo = $("#chkSLabNo").is(":checked") == true ? 1 : 0;
            var ShowTestCode = $("#chkSTestCode").is(":checked") == true ? 1 : 0;
            var MandatoryClient = $("#chkMClient").is(":checked") == true ? 1 : 0;
            var MandatoryRole = $("#chkMRole").is(":checked") == true ? 1 : 0;
            var MandatoryCentre = $("#chkMCentre").is(":checked") == true ? 1 : 0;
            var MandatoryBarcodeNo = $("#chkMBarcodeNo").is(":checked") == true ? 1 : 0;
            var MandatoryLabNo = $("#chkMLabNo").is(":checked") == true ? 1 : 0;
            var MandatoryTestCode = $("#chkMTestCode").is(":checked") == true ? 1 : 0;
            var IsActive = $("#ChkActive").is(":checked") == true ? 1 : 0;
            var selectRole = "";
            $('#<%=lstRole.ClientID%> :selected').each(function (i, selected) {
                if (selectRole == "") {
                    selectRole = $(selected).val();
                }
                else {
                    selectRole = selectRole + "," + $(selected).val();
                }
            });
            serverCall('CategoryMaster.aspx/UpdateDetails', { ID: ID, CategoryName: CategoryName, ShowClient: ShowClient, ShowRole: ShowRole, ShowCentre: ShowCentre, ShowBarcodeNo: ShowBarcodeNo, ShowLabNo: ShowLabNo, ShowTestCode: ShowTestCode, MandatoryClient: MandatoryClient, MandatoryRole: MandatoryRole, MandatoryCentre: MandatoryCentre, MandatoryBarcodeNo: MandatoryBarcodeNo, MandatoryLabNo: MandatoryLabNo, MandatoryTestCode: MandatoryTestCode, IsActive: IsActive, Roles: selectRole }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    clear();
                    CategoryData(jQuery.parseJSON($responseData.responseDetail))
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function Cancel() {
            clear();
        }
        function clear() {
            $("#hfCatID").val('0');
            $("#btnSubmit").show();
            $("#btnUpdate").hide();

            $("input[type=text]").val('');
            $("#<%=lstRole.ClientID%>").val('');
              $('[id$=lstRole]').multipleSelect('refresh');
              MandatoryDisabled('0', false);
          }
          jQuery(function () {
              jQuery('[id*=<%=lstRole.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

        });
       $('#txtCategory').alphanum({
            allow: '/-.'
        });
    </script>
</asp:Content>

