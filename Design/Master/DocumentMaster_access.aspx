<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocumentMaster_access.aspx.cs" Inherits="Design_Master_DocumentMaster_access" %>

<!DOCTYPE html>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style=" vertical-align: top; margin: -0px">
            
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-3">
                            Centre
                        </div>
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkCentres" runat="server" Text="Select All" onclick="SelectAll(1)" />
                        </div>

                        <div class="col-md-3">Search :</div>
                        <div class="col-md-3">
                            <input id="txtSearchCentres" onkeyup="SearchCheckbox(this,chklCentres)" style="width: 300px" />
                        </div>
                    </div>


                </div>

                <div id="" style="overflow-y: scroll; height: 84px;">
                    <asp:CheckBoxList ID="chklCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-3">
                            Role
                        </div>
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkRole" runat="server" Text="Select All" onclick="SelectAll(2)" />
                        </div>

                        <div class="col-md-3">Search :</div>
                        <div class="col-md-3">
                            <input id="txtRole" onkeyup="SearchCheckbox(this,chklistRole)" style="width: 300px" />
                        </div>
                    </div>


                </div>

                <div id="Div1" style="overflow-y: scroll; height: 84px;">
                    <asp:CheckBoxList ID="chklistRole" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-3">
                            Department
                        </div>
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkDepartment" runat="server" Text="Select All" onclick="SelectAll(3)" />
                        </div>

                        <div class="col-md-4">Search :</div>
                        <div class="col-md-3">
                            <input id="txtDepartment" onkeyup="SearchCheckbox(this,chklistDepartment)" style="width: 300px" />
                        </div>
                    </div>


                </div>

                <div id="Div2" style="overflow-y: scroll; height: 84px;">
                    <asp:CheckBoxList ID="chklistDepartment" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-3">
                            Employee
                        </div>
                        <div class="col-md-4">Search :</div>
                        <div class="col-md-3">
                            <input id="txtEmployee" style="width: 300px" />
                        </div>
                    </div>


                </div>

                <div id="divEmplist" style="overflow-y: scroll; height: 80px; text-align: center;">
                    <table id="tblEmp">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 260px">Employee Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Remove</th>
                            </tr>
                        </thead>
                        <tbody id="tbltbody">
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveDetails();" />
            </div>



        </div>
    </form>
</body>
<script>
    function SelectAll(Type) {
        if (Type == "1") {
            var chkBoxList = document.getElementById('<%=chklCentres.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
            }
        }
        else if (Type == "2") {
            var chkBoxList = document.getElementById('<%=chklistRole.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkRole.ClientID %>').checked;
            }
        }

        else if (Type == "3") {
            var chkBoxList = document.getElementById('<%=chklistDepartment.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkDepartment.ClientID %>').checked;
            }
        }
}

$(function () {
    function split(val) {
        return val.split(/,\s*/);
    }
    function extractLast(term) {
        return split(term).pop();
    }

    $("#txtEmployee").bind("keydown", function (event) {
        if (event.keyCode === $.ui.keyCode.TAB &&
            $(this).autocomplete("instance").menu.active) {
            event.preventDefault();
        }
    }).autocomplete({
        source: function (request, response) {
            $.getJSON("../Common/CommonjsonData.aspx?cmd=GetEmployee", {
                term: extractLast(request.term)
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
            this.value = "";
            CreateDynamicTable(ui.item.id, ui.item.value)
            return false;
        }
    });
});

function CreateDynamicTable(employeeID, EmployeeName) {
    var IsValid = true;
    $("#tblEmp tbody tr").each(function () {
        if (employeeID == $(this).closest('tr').find("#hdnId").val()) {
            IsValid = false;
        }
    });

    if (!IsValid) {
        toast("Error", "Already selected");
        return false;
    }

    var output = [];
    output.push('<tr id="tr_');
    output.push('">');
    output.push('</td>');
    output.push('<td id="tdDocName"  class="GridViewLabItemStyle"  style="width:100px;">');
    output.push('<input type="hidden" id="hdnId" value="');
    output.push(employeeID);
    output.push('"/>');
    output.push(EmployeeName); output.push('</td>');
    output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:10px;"><img style="cursor: pointer;" alt="upload pdf" src="../../App_Images/Delete.gif"  onclick="Remove(this)"   /> </td>');
    output.push('</tr>');
    output = output.join('');
    $("#tbltbody").append(output);
}

function Remove(ctr) {
    $(ctr).closest('tr').remove();
}

var $saveDetails = function () {


    var _Documentdata = GetDetails();
    //if (_Documentdata.length == 0) {
    //    toast("Error", "Please select any access rights");
    //    return false;
    //}
    serverCall('DocumentMaster_access.aspx/SaveDocAccess', { documentdata: _Documentdata, DocumentID: '<%=DocID%>' }, function (response) {

        var $responseData = JSON.parse(response);
        if ($responseData.status) {
            toast("Success", "Record Saved Successfully", "");
        }
        else {
            toast("Error", $responseData.ErrorMsg, "");
        }

        $("#btnsaveDept").val("Save");
        $("#btnsaveDept").prop("disabled", false);
        $modelUnBlockUI(function () { });

    });

}


function GetDetails() {
    var _details = [];
    var objdata = {};

    $("#chklCentres input[type=checkbox]:checked").each(function () {
        objdata = {};
        objdata.DocumentID = '<%=DocID%>';
        objdata.AccessType = "CentreId";
        objdata.AccessTypeto = $(this).val();
        _details.push(objdata);
    });


    $("#chklistRole input[type=checkbox]:checked").each(function () {
        objdata = {};
        objdata.DocumentID = '<%=DocID%>';
            objdata.AccessType = "RoleId";
            objdata.AccessTypeto = $(this).val();
            _details.push(objdata);
        });


        $("#chklistDepartment input[type=checkbox]:checked").each(function () {
            objdata = {};
            objdata.DocumentID = '<%=DocID%>';
            objdata.AccessType = "SubCategoryID";
            objdata.AccessTypeto = $(this).val();
            _details.push(objdata);
        });

        $("#tblEmp tbody tr").each(function () {
            objdata = {};
            objdata.DocumentID = '<%=DocID%>';
            objdata.AccessType = "Employee_ID";
            objdata.AccessTypeto = $(this).closest('tr').find('#hdnId').val();
            _details.push(objdata);
        });
        return _details;

    }

    var $bindCentredata = function () {
        serverCall('DocumentMaster_access.aspx/getAccessDetails', { DocID: '<%=DocID%>', accessType: 'CentreId' }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                var centreids = $responseData.data[0].AccessTypeto.split(',');
                $("#chklCentres  input[type=checkbox]").each(function () {
                    if (jQuery.inArray($(this).val(), centreids) > -1) {
                        $(this).prop("checked", true);
                    }

                });
            }
            $modelUnBlockUI(function () { });
        });

    }

        var $bindRoledata = function () {
            serverCall('DocumentMaster_access.aspx/getAccessDetails', { DocID: '<%=DocID%>', accessType: 'RoleId' }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var centreids = $responseData.data[0].AccessTypeto.split(',');
                    $("#chklistRole input[type=checkbox]").each(function () {
                        if (jQuery.inArray($(this).val(), centreids) > -1) {
                            $(this).prop("checked", true);
                        }

                    });
                }
                $modelUnBlockUI(function () { });
            });

        }

        var $bindDepartmentdata = function () {
            serverCall('DocumentMaster_access.aspx/getAccessDetails', { DocID: '<%=DocID%>', accessType: 'SubCategoryID' }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                var centreids = $responseData.data[0].AccessTypeto.split(',');
                $("#chklistDepartment input[type=checkbox]").each(function () {
                    if (jQuery.inArray($(this).val(), centreids) > -1) {
                        $(this).prop("checked", true);
                    }

                });
            }
            $modelUnBlockUI(function () { });
        });
    }

    var $bindEmpdata = function () {
        serverCall('DocumentMaster_access.aspx/getAccessDetails', { DocID: '<%=DocID%>', accessType: 'Employee_ID' }, function (response) {
            var $responseData = JSON.parse(response);
            $("#tbltbody").html('');
            if ($responseData.status) {

                var _Empdata = $responseData.data;
                var output = [];
                for (var i = 0; i < _Empdata.length; i++) {
                    output.push('<tr id="tr_');
                    output.push('">');
                    output.push('</td>');
                    output.push('<td id="tdDocName"  class="GridViewLabItemStyle"  style="width:100px;">');
                    output.push('<input type="hidden" id="hdnId" value="');
                    output.push(_Empdata[i].Employee_ID);
                    output.push('"/>');
                    output.push(_Empdata[i].Name); output.push('</td>');
                    output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:10px;"><img style="cursor: pointer;" alt="upload pdf" src="../../App_Images/Delete.gif"  onclick="Remove(this)"/> </td>');
                    output.push('</tr>');
                }
                output = output.join('');
                $("#tbltbody").html(output);
            }
            $modelUnBlockUI(function () { });
        });
    }
    $(function () {
        $bindCentredata();
        $bindRoledata();
        $bindDepartmentdata();
        $bindEmpdata();
    });
</script>
</html>
