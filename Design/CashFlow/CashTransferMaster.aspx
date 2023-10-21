<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CashTransferMaster.aspx.cs" Inherits="Design_CashFlow_CashTransferMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
   <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Cash Transfer Master </strong>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
        <div class="POuter_Box_Inventory" >
            <table style="width: 100%; border-collapse: collapse">

                <tr>
                    <td style="width: 20%; text-align: right">
                        <b>Receiver User :&nbsp;</b></td>
                    <td style="width: 20%; text-align: left">
                        <asp:TextBox ID="txtEmployee" runat="server" Width="260px"></asp:TextBox>
                        <input type="hidden" value="0" id="hdEmployeeID" />

                    </td>
                    <td style="width: 20%; text-align: right">
                        <b>Receive Cash From :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="bindSearchType()">

                            <asp:ListItem Text="Field Boy" Value="2" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Bank" Value="3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr class="searchType">
                    <td style="width: 20%; text-align: right">
                        <b>Business Zone :&nbsp;</b></td>
                    <td style="width: 20%; text-align: left">
                        <asp:ListBox ID="lstZoneList" CssClass="multiselect" SelectionMode="Multiple" Width="262px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                    <td style="width: 20%; text-align: right"><b>Field Boy :&nbsp;</b>
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:ListBox ID="lstFieldBoy" CssClass="multiselect" SelectionMode="Multiple" Width="340px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                </tr>

            </table>
        </div>
        <div id="employeeList"></div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" class="searchbutton" id="btnSave" value="Save" onclick="SaveCashTransferMaster()" />
        </div>
         <div class="POuter_Box_Inventory" style=" text-align: center;max-height:400px;overflow:auto;">
           <table id="tblItems"  class="GridViewStyle" style="width:99%;background-color:#fff;">
               <tr>
                   <th class="GridViewHeaderStyle">
                       S.NO.
                   </th>
                   <th class="GridViewHeaderStyle">
                       Type
                   </th>
                   <th class="GridViewHeaderStyle">
                       Receiver
                   </th>
                    <th class="GridViewHeaderStyle">
                       Sender
                   </th>
                    <th class="GridViewHeaderStyle">
                       Created By
                   </th>
                    <th class="GridViewHeaderStyle">
                       Created On
                   </th>
                   <th class="GridViewHeaderStyle">
                       Remove
                   </th>
               </tr>

           </table>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=lstZoneList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstFieldBoy]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindZone();
            bindSearchType();
        });

        function bindZone() {
            CommonServices.bindBusinessZone(onSucessZone, onFailureZone);
        }
        function onSucessZone(result) {
            BusinessZoneID = jQuery.parseJSON(result);
            for (i = 0; i < BusinessZoneID.length; i++) {
                jQuery('#lstZoneList').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
            }
            jQuery('[id*=lstZoneList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function onFailureZone(result) {

        }
        jQuery('#lstZoneList').on('change', function () {

            var BusinessZoneID = $(this).val();
            bindBusinessZoneWiseFieldBoy(BusinessZoneID);
        });
        function bindBusinessZoneWiseFieldBoy(BusinessZoneID) {
            jQuery('#lstFieldBoy option').remove();
            jQuery('#lstFieldBoy').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "CashTransferMaster.aspx/bindBusinessZoneWiseFieldBoy",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        FieldBoyData = jQuery.parseJSON(result.d);
                        for (i = 0; i < FieldBoyData.length; i++) {
                            jQuery("#lstFieldBoy").append(jQuery("<option></option>").val(FieldBoyData[i].ID).html(FieldBoyData[i].Name));
                        }
                        jQuery('[id*=lstFieldBoy]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }

    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#txtEmployee").autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    jQuery.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "CashTransferMaster.aspx/SearchEmployee",
                        data: "{'query':'" + jQuery("#txtEmployee").val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            var result = $.parseJSON(data.d);
                            response(result);

                        },
                        Error: function (results) {
                            alert("Error");
                        }
                    });
                },
                focus: function () {
                    // prevent value inserted on focus
                    return false;
                },
                select: function (event, ui) {
                    jQuery("#hdEmployeeID").val(ui.item.value);
                    jQuery("#txtEmployee").val(ui.item.label);
                    return false;
                },
                appendTo: "#employeeList"

            });
        });

        function bindSearchType() {
            jQuery('#lblMsg').text("");
            if (jQuery('#rblSearchType input[type=radio]:checked').val() == 2) {
                jQuery('.searchType').show();
            }
            else {
                jQuery('.searchType').hide();
            }
            clearControl(0);
        }
    </script>
    <script type="text/javascript">
        function SaveCashTransferMaster() {
            if (jQuery("#hdEmployeeID").val() == "" || jQuery("#txtEmployee").val() == "") {
                jQuery('#lblMsg').text("Please Enter User Name");
                jQuery("#txtEmployee").focus();
                return;
            }
            if (jQuery('#lstFieldBoy').multipleSelect("getSelects").join() == "" && jQuery('#rblSearchType input[type=radio]:checked').val() == 2) {
                jQuery('#lblMsg').text("Please Select Field Boy ");
                return;
            }


            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            var dataCashTransfer = new Array();
            var objCashTransfer = new Object();


            objCashTransfer.TypeName = jQuery('#rblSearchType input[type=radio]:checked').next().text();
            objCashTransfer.TypeID = jQuery('#rblSearchType input[type=radio]:checked').val();
            objCashTransfer.Employee_ID_To = jQuery("#hdEmployeeID").val();
            objCashTransfer.EmployeeName_To = jQuery("#txtEmployee").val();
            if (jQuery('#rblSearchType input[type=radio]:checked').val() == 2) {
                jQuery('#lstFieldBoy :selected').each(function () {
                    objCashTransfer.Employee_ID_By = $(this).val();
                    objCashTransfer.EmployeeName_By = $(this).text();
                    dataCashTransfer.push(objCashTransfer);
                    objCashTransfer = new Object();
                });
            }
            else {
                objCashTransfer.Employee_ID_By = "0";
                objCashTransfer.EmployeeName_By = "";
                dataCashTransfer.push(objCashTransfer);
            }
            PageMethods.SaveCashTransfer(dataCashTransfer, onSucessCashTransfer, onFailureCashTransfer);
        }
        function onSucessCashTransfer(result) {
            if (result == "1") {
                jQuery('#lblMsg').text("Record Saved Successfully");
                SearchData();
                clearControl(1);
               
            }
            else if (result == "0") {
                jQuery('#lblMsg').text('Record already exists');
            }

            else {
                jQuery('#lblMsg').text('Error');
            }
            jQuery.unblockUI();
        }
        function onFailureCashTransfer(result) {
            jQuery('#lblMsg').text('Error');
            jQuery.unblockUI();
        }
        function clearControl(con) {
            if (con == 1) {
                jQuery("#hdEmployeeID,#txtEmployee").val('');
            }
            jQuery("#lstZoneList  option:selected").prop("selected", false);
            jQuery('#lstZoneList').multipleSelect("refresh");
            jQuery('#lstFieldBoy option').remove();
            jQuery('#lstFieldBoy').multipleSelect("refresh");
        }
    </script>

    <script>
        $(document).ready(function () {
            SearchData();
        });

        function SearchData()
        {
            $.blockUI();
            $.ajax({
                url: "CashTransferMaster.aspx/SearchData",
                async: true,
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = $.parseJSON(result.d);
                    $('#tblItems tr').slice(1).remove();
                    if (data.length > 0)
                    {
                        var html = '';
                        for (var i = 0; i < data.length; i++)
                        {
                            html += '<tr>';
                            html += '<td class="GridViewLabItemStyle">' + (i + 1) + ' </td>';
                            html += '<td class="GridViewLabItemStyle">' + data[i].TypeName + ' </td>';
                            html += '<td class="GridViewLabItemStyle">' + data[i].EmployeeName_To + ' </td>';
                            html += '<td class="GridViewLabItemStyle">' + data[i].EmployeeName_By + ' </td>';
                            html += '<td class="GridViewLabItemStyle">' + data[i].CreatedBy + ' </td>';
                            html += '<td class="GridViewLabItemStyle">' + data[i].CreatedOn + ' </td>';
                            html += '<td class="GridViewLabItemStyle"> <img src="../../App_Images/Delete.gif" onclick="Deactivate(' + data[i].Id + ')" /></td>';
                            html += '</tr>';

                        }
                        $('#tblItems').append(html);
                        
                    }
$.unblockUI();
                },
                error: function () {
                    $.unblockUI();
                }
            });
        }

        function Deactivate(Id)
        {
            var IsConfirmed = confirm("Are You Sure ?");
            if (IsConfirmed) {
                $.ajax({
                    url: "CashTransferMaster.aspx/Deactivate",
                    async: true,
                    data: '{Id:"' + Id + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            SearchData();
                        } else {
                            alert("Some error occured, Please try again later");
                        }
                    }
                });
            }
        }
    </script>
</asp:Content>

