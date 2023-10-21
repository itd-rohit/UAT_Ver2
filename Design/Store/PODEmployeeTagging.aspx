<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PODEmployeeTagging.aspx.cs" Inherits="Design_Store_PODEmployeeTagging" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>POD Employee Tagging Master</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Employee   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="lstFromEmployee" Width="300px" runat="server" CssClass="multiselect " SelectionMode="Multiple" ClientIDMode="Static"></asp:ListBox>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">To Employee   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="lstToEmployee" Width="300px" runat="server" class="lstToEmployee chosen-select chosen-container" ClientIDMode="Static"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkislast" runat="server" Font-Bold="true" Text="Is Last" />&nbsp;&nbsp;&nbsp;
                      
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkcurrier" runat="server" Font-Bold="true" Text="Courier Required" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" value="Save" class="searchbutton" onclick="savedata();" />
                    <input type="button" value="Search" class="searchbutton" onclick="Searchdata();" />
                    <input type="button" class="searchbutton" onclick="ExportToExcel()" value="Excel Report" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div class="Purchaseheader">
                    Added Item
                </div>
                <div style="width: 100%; max-height: 200px; overflow: auto;">
                    <table id="tblemployee" style="border-collapse: collapse">
                        <tr id="trquuheader">
                            <td class="GridViewHeaderStyle" width="5%">S.No.</td>
                            <td class="GridViewHeaderStyle" width="20%">From Employee</td>
                            <td class="GridViewHeaderStyle" width="20%">To  Employee</td>
                            <td class="GridViewHeaderStyle" width="10%">Last Id</td>
                            <td class="GridViewHeaderStyle" width="10%">Currier Status</td>
                            <td class="GridViewHeaderStyle" width="10%">Created By</td>
                            <td class="GridViewHeaderStyle" width="10%">Create Date</td>
                            <td class="GridViewHeaderStyle" width="10%">#</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            $('[id*=lstFromEmployee]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            Bindemployee();
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
    </script>
    <script type="text/javascript">
        function savedata() {
            if ((JSON.stringify($('#lstFromEmployee').val()) == '[]')) {
                toast("Error", "Please select Employee", "");
                $('#lstFromEmployee').focus();
                return;
            }
            if ($("#lstToEmployee").val() == 0) {
                toast("Error", "Please select Employee", "");
                return;
            }
            var fromemployee = jQuery("#lstFromEmployee").val();
            var toemployee = $("#lstToEmployee option:selected").val();
            var lastid = $('#<%=chkislast.ClientID%>').is(':checked') == true ? 1 : 0;
            var currierreq = $('#<%=chkcurrier.ClientID%>').is(':checked') == true ? 1 : 0;
            serverCall('PODEmployeeTagging.aspx/Savedata', { FromEmployee: fromemployee, ToEmployee: toemployee, LastId: lastid, CurrierRequired: currierreq }, function (response) {
                if (response.split('#')[0] == "1") {
                    Searchdata();
                    clearForm();
                    toast("Success", "Data Save successfully", "");
                }
                if (response.split('#')[0] == "2") {
                    toast("Error", response.split('#')[1], "");
                }
                if (response.split('#')[0] == "3") {
                    toast("Error", response.split('#')[1], "");
                }
            });
        }
        function clearForm() {
            jQuery('#<%=lstFromEmployee.ClientID%> option').remove();
            jQuery('#<%=lstToEmployee.ClientID%> option').remove();
            Bindemployee();
        }
    </script>
    <script type="text/javascript">
        function Bindemployee() {
            jQuery('#<%=lstFromEmployee.ClientID%> option').remove();
            jQuery('#lstFromEmployee').multipleSelect("refresh");
            jQuery('#<%=lstToEmployee.ClientID%> option').remove();
            var dropdownfrom = $("#<%=lstFromEmployee.ClientID%>");
            var dropdownto = $("#<%=lstToEmployee.ClientID%>");
            serverCall('PODEmployeeTagging.aspx/bindemployeedata', {}, function (response) {
                jQuery("#lstToEmployee").append(jQuery("<option></option>").val("0").html("Select"));
                var centreData = jQuery.parseJSON(response);
                for (i = 0; i < centreData.length; i++) {
                    jQuery("#lstFromEmployee").append(jQuery("<option></option>").val(centreData[i].Employee_ID).html(centreData[i].NAME1));
                    jQuery("#lstToEmployee").append(jQuery("<option></option>").val(centreData[i].Employee_ID).html(centreData[i].NAME1));
                }
                $('#lstFromEmployee').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                $("#lstToEmployee").trigger("chosen:updated");
            });
        }
    </script>
    <script type="text/javascript">
        function Searchdata() {
            if ((JSON.stringify($('#lstFromEmployee').val()) == '[]')) {
                toast("Error", "Please select Employee");
                $('#lstFromEmployee').focus();
                return;
            }
          
            var fromemployee = jQuery("#lstFromEmployee").val();
            serverCall('PODEmployeeTagging.aspx/SearchEmployee', { fromid: fromemployee }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    $('#tblemployee tr').slice(1).remove();
                    toast("Error", "No Record Found!", "");
                }
                else {
                    $('#tblemployee tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var a = $('#tblemployee tr').length - 1;
                        var $myData = [];
                        $myData.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $myData.push('<td  id="itemid" style="display:none;">'); $myData.push(ItemData[i].id); $myData.push('</td>');
                        $myData.push('<td id="serial_number" class="order" >'); $myData.push((i + 1)) + $myData.push('</td>');
                        $myData.push('<td id="locationid">'); $myData.push(ItemData[i].fromname); $myData.push('</td>');
                        $myData.push('<td id="locationid">'); $myData.push(ItemData[i].toname); $myData.push('</td>');
                        $myData.push('<td  id="centerid">'); $myData.push((ItemData[i].IsLast == "1" ? "Yes" : "No")); $myData.push('</td>');
                        $myData.push('<td  id="centerid">'); $myData.push((ItemData[i].IsCurierRequired == "1" ? "Required" : "Not Required")); $myData.push('</td>');
                        $myData.push('<td  id="employeeid">'); $myData.push(ItemData[i].CreateBy); $myData.push('</td>');
                        $myData.push('<td  id="centerid" >'); $myData.push(ItemData[i].CreateDate); $myData.push('</td>');
                        $myData.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');
                        $myData.push('</tr>');
                        $myData = $myData.join("");
                        $('#tblemployee').append($myData);
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">
        function deleterow(itemid) {
            var table = document.getElementById('tblemployee');
            var delid = $(itemid).closest("tr").find("#itemid").text();
            serverCall('PODEmployeeTagging.aspx/removerow', { id: delid }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                var update = result.d;
                if (response.split('#')[0] == "1") {
                    toast("Success", "Removed Successfully", "");
                }
            });
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            $('td.order').text(function (i) {
                return i + 1;
            });
        }
        function ExportToExcel() {
            if ((JSON.stringify($('#lstFromEmployee').val()) == '[]')) {
                toast("Error", "Please select Employee", "");
                $('#lstFromEmployee').focus();
                return;
            }
            var fromemployee = jQuery("#lstFromEmployee").val();
            serverCall('PODEmployeeTagging.aspx/ExportToExcel', { fromid: fromemployee }, function (response) {
                if (response == "1") {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast("Error", "No Record Found..!", "");
                }

            });
        }
    </script>
</asp:Content>

