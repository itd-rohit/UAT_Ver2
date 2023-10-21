<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InqueryDepartment_Master.aspx.cs" Inherits="Design_CallCenter_InqueryCategory_Master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .GridViewHeaderStyle {    
    height: 24px;
}
    </style>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width:1300px;">
        <div class="POuter_Box_Inventory" style="width:1296px;text-align: center; ">
            <b>Enquiry Department Master</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory" style="width:1296px;">
            <table style="width:400px; margin:0 auto;">
                <tr>
                    <td style="font-weight: bold;">Department Name : &nbsp;</td>
                    <td>
                        <input type="hidden" id="id" />
                        <input type="text" style="height: 20px; width: 200px;" id="txtCategoryName"  maxlength="50"/></td>
                </tr>
                 <tr>
                    <td style="font-weight: bold;">Status : &nbsp;</td>
                    <td>
                        <input type="checkbox" name="Active" id="Active" value="Car" checked />Active<br>
                        </td>
                </tr>
             
                <tr>
                    <td></td>
                    <td>
                        <input type="button" value="Save" id="savebtn" class="searchbutton" onclick="savdata();" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1296px;">
            <table cellspacing="0" rules="all" style="width: 100%" border="0" id="tblcategory">
                <thead>
                    <tr>
                        <th class="GridViewHeaderStyle" style=" width:80px;">S.No.</th>
                        <th class="GridViewHeaderStyle" style="display: none;">ID</th>
                        <th class="GridViewHeaderStyle"  >Category Name</th>
                        <th class="GridViewHeaderStyle">Status</th>
                        <th class="GridViewHeaderStyle" style=" width:100px;">Action</th> 
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('#txtCategoryName').focus();
            GetCategory();
        });

        function GetCategory() {
            jQuery.ajax({
                url: "InqueryDepartment_Master.aspx/BindDepartment",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data == null) {
                        showerrormsg("No Department Found..!");
                    }
                    else {
                        jQuery('#tblcategory tbody').html('');
                        for (var i = 0; i < data.length; i++) {
                            var Changestatus = data[i].IsActive == 1 ? "0" : "1";
                             
                            var changeTitle = data[i].IsActive == 1 ? "Deactive" : "Active";

                            jQuery('#tblcategory tbody').append('<tr>' +
                                 '<td class="GridViewLabItemStyle" >' + (i + 1) + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].DepartmentID + '</td>' +
                        '<td class="GridViewLabItemStyle">' + data[i].DepartmentName + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].IsActive == 1 ? "Active" : "Deactive") + '</td>' +
                       '<td class="GridViewLabItemStyle">' + (data[i].IsLabDepartment == "0" ? "<input type='button' class='ItDoseButton' value='Edit' onclick='Edit(this)'/>" : "") + '</td>' +
                    '</tr>');
                        }
                    }
                }
            });
        }
        function Edit(btnl) {
            if (typeof (btnl) == "object") {                
                jQuery('#id').val(jQuery(btnl).closest("tr").find("td:eq(1)").text());
                jQuery('#txtCategoryName').val(jQuery(btnl).closest("tr").find("td:eq(2)").text());
                var status = jQuery(btnl).closest("tr").find("td:eq(3)").text();
                if (status == "Active") {
                    jQuery('#Active').prop('checked', true);
                }
                else {
                    jQuery('#Active').prop('checked', false);
                }
                jQuery('#txtCategoryName').focus();
            }
        }
        function savdata() {
            if (jQuery.trim(jQuery('#txtCategoryName').val()) == "") {
                showerrormsg("Please Enter Category Name");
                jQuery('#txtCategoryName').focus();
                return;
            }
            
            jQuery('#savebtn').attr('disabled', 'disabled').val('Saving...');
            var status = jQuery('#Active').is(':checked') ? 1 : 0;
           
            var request = { DepartmentName: jQuery('#txtCategoryName').val(), DepartmentID: jQuery('#id').val(), status: status };
            jQuery.ajax({
                url: "InqueryDepartment_Master.aspx/SaveDepartment",
                data: JSON.stringify(request),
                type: "POST", 	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#savebtn').removeAttr('disabled').val('Save');
                    if (result.d == "1") {
                        jQuery('#id').val('');
                        jQuery('#txtCategoryName').val('');
                        GetCategory();
                        showerrormsg("Record Saved Successfully ");
                        return;
                    }
                    if (result.d == "2") {                       
                        showerrormsg("Department already exists");
                        return;
                    }
                    if (result.d == "0") {
                        showerrormsg("Error occurred");
                        return;
                    }
                }
            });
        }                
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
</asp:Content>

