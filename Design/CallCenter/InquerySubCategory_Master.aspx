<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="InquerySubCategory_Master.aspx.cs" Inherits="Design_CallCenter_InqueryCategory_Master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
        <style type="text/css">
        .GridViewHeaderStyle {    
    height: 24px;
}
    </style>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width:1300px;">
        <div class="POuter_Box_Inventory" style="width:1296px;text-align: center;">
            <b>Enquiry SubCategory Master</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory" style="width:1296px;">
           <table style="width:600px;  border-collapse:collapse;margin:0 auto;">
                <tr>
                    <td style="font-weight: bold;">Group : &nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlgroup" runat="server" style="width: 205px;" ClientIDMode="Static" onchange="bindSubcategory()"></asp:DropDownList>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Category : &nbsp;</td>
                    <td>
                          <asp:DropDownList ID="ddlCategory" runat="server" style="width: 205px;" ClientIDMode="Static"></asp:DropDownList>
                    </td>
                     <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">SubCategory Name : &nbsp;</td>
                    <td>
                        <input type="hidden" id="id" />
                        <input type="text" style="width: 200px;" id="txtSubCategoryName" maxlength="50" /></td>
                     <td>
                        &nbsp;
                    </td>
                </tr>
                
                 <tr>
                    <td style="font-weight: bold; vertical-align:top;">Show : &nbsp;</td>
                    <td>
                        <asp:CheckBox ID="chkShowBarcodeNumber" ClientIDMode="Static" runat="server" Text="Show SIN No." onclick="chkBarcodeNumber()" /><br /> 
                         <asp:CheckBox ID="chkShowInvestigationID" ClientIDMode="Static" runat="server" Text="Show Investigation" onclick="chkShowInvestigationID()"/><br /> 
                         <asp:CheckBox ID="chkShowPatientID" ClientIDMode="Static" runat="server" Text="Show UHID No." onclick="chkShowPatientID()"/> <br />
                        <asp:CheckBox ID="chkShowVisitNo" ClientIDMode="Static" runat="server" Text="Show Visit No." onclick="chkShowVisitNo()"/> <br />
                        <asp:CheckBox ID="chkShowDepartment" ClientIDMode="Static" runat="server" Text="Show Department" onclick="chkShowDepartment()"/> <br />
                    </td>
                      <td>
                         <asp:CheckBox ID="chkMandatoryBarcodeNumber" ClientIDMode="Static" runat="server" Text="Mandatory SIN No." Enabled="false"/><br /> 
                         <asp:CheckBox ID="chkMandatoryInvestigationID" ClientIDMode="Static" runat="server" Text="Mandatory Investigation" Enabled="false"/><br /> 
                         <asp:CheckBox ID="chkMandatoryPatientID" ClientIDMode="Static" runat="server" Text="Mandatory UHID No." Enabled="false"/> <br />
                        <asp:CheckBox ID="chkMandatoryVisitNo" ClientIDMode="Static" runat="server" Text="Mandatory Visit No." Enabled="false"/> <br />
                        <asp:CheckBox ID="chkMandatoryDepartment" ClientIDMode="Static" runat="server" Text="Mandatory Department" Enabled="false"/> <br />
                    </td>
                </tr>
                 <tr>
                    <td style="font-weight: bold;">Status : &nbsp;</td>
                    <td>
                        <input type="checkbox" name="Active" id="Active" value="Car" checked />Active<br>
                        </td>
                      <td>
                        &nbsp;
                        </td>
                </tr>
               </table>
              </div>
                <div class="POuter_Box_Inventory" style="width:1296px;text-align:center">
                        <input type="button" value="Save" id="btnSave" class="searchbutton" onclick="savdata();" />
                   
            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width:1296px;">
            <table  cellspacing="0" rules="all" style="width: 100%" border="0"  id="tblsubcategory">
                <thead>
                    <tr>
                         <th class="GridViewHeaderStyle" style=" width:80px;">S.No.</th>
                        <th class="GridViewHeaderStyle" style="display: none;">ID</th>
                        <th class="GridViewHeaderStyle">Group</th>
                        <th class="GridViewHeaderStyle">Category Name</th>
                        <th class="GridViewHeaderStyle">SubCategory Name</th>
                         
                        <th class="GridViewHeaderStyle">Show SIN No.</th>
                        <th class="GridViewHeaderStyle">Show Investigation</th>
                        <th class="GridViewHeaderStyle">Show UHID No.</th>
                          <th class="GridViewHeaderStyle">Show Visit No.</th>
                         <th class="GridViewHeaderStyle">Show Department</th>
                        <th class="GridViewHeaderStyle">Active</th>
                        <th class="GridViewHeaderStyle">Action</th>
                        <th class="GridViewHeaderStyle">TAT</th>
                        <th class="GridViewHeaderStyle">TAG Employee</th>
                    </tr>
                </thead>
                <tbody id="bindcategor">
                </tbody>
            </table>
        </div>
    </div>
    <script>
        function chkBarcodeNumber() {
            if ($("#chkShowBarcodeNumber").is(':checked')) {
                $("#chkMandatoryBarcodeNumber").removeAttr('disabled');
            }
            else {
                $("#chkMandatoryBarcodeNumber").attr('disabled', 'disabled');
                $("#chkMandatoryBarcodeNumber").prop('checked', false);
            }
        }
        function chkShowInvestigationID() {
            if ($("#chkShowInvestigationID").is(':checked')) {
                $("#chkMandatoryInvestigationID").removeAttr('disabled');
            }
            else {
                $("#chkMandatoryInvestigationID").attr('disabled', 'disabled');
                $("#chkMandatoryInvestigationID").prop('checked', false);
            }
        }
        function chkShowPatientID() {
            if ($("#chkShowPatientID").is(':checked')) {
                $("#chkMandatoryPatientID").removeAttr('disabled');
            }
            else {
                $("#chkMandatoryPatientID").attr('disabled', 'disabled');
                $("#chkMandatoryPatientID").prop('checked', false);
            }
        }
        function chkShowVisitNo() {
            if ($("#chkShowVisitNo").is(':checked')) {
                $("#chkMandatoryVisitNo").removeAttr('disabled');
            }
            else {
                $("#chkMandatoryVisitNo").attr('disabled', 'disabled');
                $("#chkMandatoryVisitNo").prop('checked', false);
            }
        }
        function chkShowDepartment() {
            if ($("#chkShowDepartment").is(':checked')) {
                $("#chkMandatoryDepartment").removeAttr('disabled');
            }
            else {
                $("#chkMandatoryDepartment").attr('disabled', 'disabled');
                $("#chkMandatoryDepartment").prop('checked', false);
            }
        }
        jQuery(function () {
            jQuery("#ddlCategory").focus();
            GetCategory();
        });
        function GetCategory() {
            jQuery.ajax({
                url: "InquerySubCategory_Master.aspx/BindSubCategory",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data == null) {
                        showerrormsg("No Category Found..!");
                    }
                    else {
                        jQuery('#bindcategor').html('');
                        for (var i = 0; i < data.length; i++) {
                            jQuery('#bindcategor').append('<tr>' +
                          '<td class="GridViewLabItemStyle">' + (i + 1) + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].ID + '</td>' +
                        '<td class="GridViewLabItemStyle">' + data[i].GroupName + '</td>' +
                        '<td class="GridViewLabItemStyle">' + data[i].CategoryName + '</td>' +
                        '<td class="GridViewLabItemStyle">' + data[i].SubCategoryName + '</td>' +                                                
                        '<td class="GridViewLabItemStyle">' + (data[i].ShowBarcodeNumber == 1 ? "Yes" : "No") + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].ShowInvestigationID == 1 ? "Yes" : "No") + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].ShowPatientID == 1 ? "Yes" : "No") + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].ShowVisitNo == 1 ? "Yes" : "No") + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].ShowDepartment == 1 ? "Yes" : "No") + '</td>' +
                        '<td class="GridViewLabItemStyle">' + (data[i].IsActive == 1 ? "Active" : "Deactive") + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].CategoryID + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].GroupID + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].MandatoryBarcodeNumber + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].MandatoryInvestigationID + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].MandatoryPatientID + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].MandatoryVisitNo + '</td>' +
                        '<td class="GridViewLabItemStyle" style="display:none;">' + data[i].MandatoryDepartment + '</td>' +
                        '<td class="GridViewLabItemStyle"><input type="button" class=ItDoseButton value="Edit" onclick="EditEmployee(this);"/></td>' +
                        '<td class="GridViewLabItemStyle"><a target="_blank" href="../CallCenter/CustomerCare_Inquiry_CategoryTAT.aspx?Id=' + data[i].ID + '"><span>TAT</span></a></td>' +
                        '<td class="GridViewLabItemStyle"><a target="_blank" href="../CallCenter/CustomerCare_Inquiry_Category.aspx?Id=' + data[i].ID + '"><span>TAG Employee</span></a></td>' +
                    '</tr>');
                        }
                    }
                }
            });
        }
        function EditEmployee(btnl) {
            if (typeof (btnl) == "object") { 
                jQuery('#id').val(jQuery(btnl).closest("tr").find("td:eq(1)").text());
                jQuery('#txtSubCategoryName').val(jQuery(btnl).closest("tr").find("td:eq(4)").text());
                var ShowBarcodeNumber = jQuery(btnl).closest("tr").find("td:eq(5)").text();
                var ShowInvestigationID = jQuery(btnl).closest("tr").find("td:eq(6)").text();
                var ShowPatientID = jQuery(btnl).closest("tr").find("td:eq(7)").text();
                var ShowVisitNo = jQuery(btnl).closest("tr").find("td:eq(8)").text();
                var ShowDepartment = jQuery(btnl).closest("tr").find("td:eq(9)").text();
                var MandatoryBarcodeNumber = jQuery(btnl).closest("tr").find("td:eq(13)").text();
                var MandatoryInvestigationID = jQuery(btnl).closest("tr").find("td:eq(14)").text();
                var MandatoryPatientID = jQuery(btnl).closest("tr").find("td:eq(15)").text();
                var MandatoryVisitNo = jQuery(btnl).closest("tr").find("td:eq(16)").text();
                var MandatoryDepartment = jQuery(btnl).closest("tr").find("td:eq(17)").text();
                if (ShowBarcodeNumber == "Yes") {
                    jQuery('#<%=chkShowBarcodeNumber.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkShowBarcodeNumber.ClientID %>').prop('checked', false);
                }

                if (MandatoryBarcodeNumber == "1") {
                    jQuery('#<%=chkMandatoryBarcodeNumber.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkMandatoryBarcodeNumber.ClientID %>').prop('checked', false);
                }
                chkBarcodeNumber();
                if (ShowInvestigationID == "Yes") {
                    jQuery('#<%=chkShowInvestigationID.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkShowInvestigationID.ClientID %>').prop('checked', false);
                }

                if (MandatoryInvestigationID == "1") {
                    jQuery('#<%=chkMandatoryInvestigationID.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkMandatoryInvestigationID.ClientID %>').prop('checked', false);
                }
                chkShowInvestigationID();
                if (ShowPatientID == "Yes") {
                    jQuery('#<%=chkShowPatientID.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkShowPatientID.ClientID %>').prop('checked', false);
                }

                if (MandatoryPatientID == "1") {
                    jQuery('#<%=chkMandatoryPatientID.ClientID %>').prop('checked', true);
                 }
                 else {
                     jQuery('#<%=chkMandatoryPatientID.ClientID %>').prop('checked', false);
                 }
                chkShowPatientID();
                if (ShowVisitNo == "Yes") {
                    jQuery('#<%=chkShowVisitNo.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkShowVisitNo.ClientID %>').prop('checked', false);
                }
                
                if (MandatoryVisitNo == "1") {
                    jQuery('#<%=chkMandatoryVisitNo.ClientID %>').prop('checked', true);
                 }
                 else {
                     jQuery('#<%=chkMandatoryVisitNo.ClientID %>').prop('checked', false);
                 }
                chkShowVisitNo();
                if (ShowDepartment == "Yes") {
                    jQuery('#<%=chkShowDepartment.ClientID %>').prop('checked', true);
                }
                else {
                    jQuery('#<%=chkShowDepartment.ClientID %>').prop('checked', false);
                }

                if (MandatoryDepartment == "1") {
                    jQuery('#<%=chkMandatoryDepartment.ClientID %>').prop('checked', true);
                 }
                 else {
                     jQuery('#<%=chkMandatoryDepartment.ClientID %>').prop('checked', false);
                 }
                chkShowDepartment();
                var status = jQuery(btnl).closest("tr").find("td:eq(10)").text();
                if (status == "Active") {
                    jQuery('#Active').prop('checked', true);
                }
                else {
                    jQuery('#Active').prop('checked', false);
                }
               
                jQuery('#<%=ddlgroup.ClientID %>').val(jQuery(btnl).closest("tr").find("td:eq(12)").text());
              
                bindSubcategory();
                jQuery('#<%=ddlCategory.ClientID %>').val(jQuery(btnl).closest("tr").find("td:eq(11)").text());
                jQuery('#txtSubCategoryName').focus();
            }
        }
        function savdata() {
            if (jQuery('#ddlCategory').val() == "0") {
                showerrormsg("Please Select Category name");
                jQuery('#ddlCategory').focus();
                return;
            }
            if (jQuery.trim(jQuery('#txtSubCategoryName').val()) == "") {
                showerrormsg("Please Enter SubCategory Name");
                jQuery('#txtSubCategoryName').focus();
                return;
            }

            var ShowBarcodeNumber = jQuery('#<%=chkShowBarcodeNumber.ClientID %>').is(':checked') ? 1 : 0;
            var ShowInvestigationID = jQuery('#<%= chkShowInvestigationID.ClientID %>').is(':checked') ? 1 : 0;
            var ShowPatientID = jQuery('#<%= chkShowPatientID.ClientID %>').is(':checked') ? 1 : 0;
            var ShowVisitNo = jQuery('#<%= chkShowVisitNo.ClientID %>').is(':checked') ? 1 : 0;
            var IsActive = jQuery('#Active').is(':checked') ? 1 : 0;
            var ShowDepartment = jQuery('#<%= chkShowDepartment.ClientID %>').is(':checked') ? 1 : 0;

            var MandatoryBarcodeNumber = jQuery('#<%= chkMandatoryBarcodeNumber.ClientID %>').is(':checked') ? 1 : 0;
            var MandatoryInvestigationID = jQuery('#<%= chkMandatoryInvestigationID.ClientID %>').is(':checked') ? 1 : 0;
            var MandatoryPatientID = jQuery('#<%= chkMandatoryPatientID.ClientID %>').is(':checked') ? 1 : 0;
            var MandatoryVisitNo = jQuery('#<%= chkMandatoryVisitNo.ClientID %>').is(':checked') ? 1 : 0;
            var MandatoryDepartment = jQuery('#<%= chkMandatoryDepartment.ClientID %>').is(':checked') ? 1 : 0;
            
            jQuery('#btnSave').attr('disabled', 'disabled').val('Saving...');
            var request = { ShowDepartment: ShowDepartment, ShowVisitNo: ShowVisitNo, IsActive: IsActive, ShowPatientID: ShowPatientID, ShowInvestigationID: ShowInvestigationID, ShowBarcodeNumber: ShowBarcodeNumber, CategoryName: jQuery('#txtSubCategoryName').val(), Id: jQuery('#id').val(), CategoryID: jQuery('#ddlCategory').val(), GroupID: jQuery('#ddlgroup').val(), MandatoryBarcodeNumber: MandatoryBarcodeNumber, MandatoryInvestigationID: MandatoryInvestigationID, MandatoryPatientID: MandatoryPatientID, MandatoryVisitNo: MandatoryVisitNo, MandatoryDepartment: MandatoryDepartment };

            jQuery.ajax({
                url: "InquerySubCategory_Master.aspx/SaveSubCategory",
                data: JSON.stringify(request),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#btnSave').removeAttr('disabled').val('Save');
                    if (result.d == "1") {
                        jQuery('#id').val('');
                        jQuery('#txtSubCategoryName').val('');
                        jQuery('#<%=chkShowDepartment.ClientID %>,#<%=chkShowVisitNo.ClientID %>,#<%=chkShowBarcodeNumber.ClientID %>,#<%=chkShowInvestigationID.ClientID %>,#<%=chkShowPatientID.ClientID %>').prop('checked', false);                          
                        jQuery('#chkMandatoryBarcodeNumber,#chkMandatoryInvestigationID,#chkMandatoryPatientID,#chkMandatoryVisitNo,#chkMandatoryDepartment').prop('checked', false);
                        jQuery('#chkMandatoryBarcodeNumber,#chkMandatoryInvestigationID,#chkMandatoryPatientID,#chkMandatoryVisitNo,#chkMandatoryDepartment').attr('disabled', 'disabled');
                       
                        jQuery('#<%=ddlCategory.ClientID %>').val('0');
               
                        GetCategory();
                        showerrormsg("Record Saved Successfully");
                        return;
                    }
                    if (result.d == "2") {
                        showerrormsg("SubCategory already exists");
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

    <script type="text/javascript">
        function bindSubcategory() {
            jQuery("#<%=ddlCategory.ClientID %> option").remove();
            if (jQuery("#<%=ddlgroup.ClientID %>").val() != "0") {
                jQuery.ajax({
                    url: "InquerySubCategory_Master.aspx/bindCategory",
                    data: '{ GroupID: "' + jQuery("#<%=ddlgroup.ClientID %>").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            jQuery("#<%=ddlCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < ItemData.length; i++) {
                                jQuery("#<%=ddlCategory.ClientID %>").append(jQuery("<option></option>").val(ItemData[i].ID).html(ItemData[i].CategoryName));
                            }
                        }
                         
                    },
                    error: function (xhr, status) {

                    }
                });
            }
            
        }
    </script>
</asp:Content>

