<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="Inquiry_Master.aspx.cs" Inherits="Design_CallCenter_Inquiry_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <style type="text/css">
        .alert {
            display: none;
            height: 50px;
            width: 220px;
            font-weight: bold;
            color: white;
            background-color: #e04747;
            float: right;
            top: 2em;
            padding: 10px;
            right: 1em;
            border-radius: 5px;
        }

        .spncolor {
            color: black;
        }

        .GridViewHeaderStyle {
            height: 24px;
        }
    </style>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1300px;">
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <b>Query Master</b>
            <input type="button" id="backButton" style="display: none; float: left;" onclick="ShowSubQuery()" value="Back" />
        </div>
        <div class="POuter_Box_Inventory" id="submitQuery_234" style="width: 1296px">
            <div class="Purchaseheader" style="text-align: center;">
            </div>
            <div class="content" style="text-align: center; padding: 0px!important;">
                <asp:Panel ID="Panel1" runat="server">
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="width: 30%; text-align: right; font-weight: bold">Type :&nbsp;</td>
                            <td style="text-align: left">
                                <asp:DropDownList ID="ddlType" runat="server" Width="450px" CssClass="chosen-select">
                                    <asp:ListItem Value="Query" Text="Query" Selected="True">Query</asp:ListItem>
                                    <asp:ListItem Value="Response" Text="Response">Response</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 30%; text-align: right; font-weight: bold">Group : &nbsp;</td>
                            <td style="text-align: left">
                                <asp:DropDownList ID="ddlgroup" runat="server" Width="450px" CssClass="chosen-select" ClientIDMode="Static" onchange="bindCategory()"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 30%; text-align: right; font-weight: bold">Category :&nbsp;</td>
                            <td style="text-align: left">
                                <asp:DropDownList ID="ddlCategory" runat="server" Width="450px" CssClass="chosen-select" onchange="bindSubcategory(0)">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 30%; text-align: right; font-weight: bold">SubCategory :&nbsp; </td>
                            <td style="text-align: left">
                                <asp:DropDownList ID="ddlSubCategory" runat="server" Width="450px" CssClass="chosen-select" onchange="bindSubject()">
                                </asp:DropDownList></td>
                        </tr>
                        <tr class="Query dynamic">
                            <td style="width: 30%; text-align: right; font-weight: bold">Subject :&nbsp;</td>
                            <td style="text-align: left">
                                <asp:TextBox ID="txtSubject" runat="server" Width="449px" Style="max-width: 449px" MaxLength="50"></asp:TextBox>

                            </td>
                        </tr>
                        <tr class="Query dynamic1">
                            <td style="width: 30%; text-align: right; font-weight: bold">Detail :&nbsp;</td>
                            <td style="text-align: left">
                                <asp:TextBox ID="txtDetail" runat="server" TextMode="MultiLine" Rows="8" Width="449px" Style="max-width: 449px"></asp:TextBox>
                                Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 30%; text-align: right; font-weight: bold">Status :&nbsp;</td>
                            <td style="text-align: left">
                                <input type="checkbox" name="Active" id="Active" value="Active" checked />Active<br>
                            </td>
                        </tr>

                    </table>
                </asp:Panel>
            </div>
        </div>

        <div class="POuter_Box_Inventory" id="butondiv" style="width: 1296px; text-align: center;">

            <input type="text" style="display: none;" id="editeId_9384" />
            <input id="btnsave" type="button" class="searchbutton" value="Save" onclick="SaveInquiry()" />
            <%--<input id="queryId" type="button" class="searchbutton" value="Enquiry List" onclick="showQueryList()" />--%>
        </div>

        <div class="POuter_Box_Inventory" id="ListQuery787" style="width: 1296px;">
            <div class="" style="text-align: center;">
                <table class="GridViewStyle" cellspacing="0" rules="all" style="width: 100%" id="queryListHead" border="0">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" style="width: 50px;">S No.</th>
                            <th class="GridViewHeaderStyle" style="width: 55px;">Type</th>
                             <th class="GridViewHeaderStyle" style="width: 150px;">Group</th>
                             <th class="GridViewHeaderStyle" style="width: 150px;">Category</th>
                            <th class="GridViewHeaderStyle" style="width: 150px;">SubCategory</th>
                            <th class="GridViewHeaderStyle" style="width: 150px;">Subject</th>
                            <th class="GridViewHeaderStyle" style="width: 346px;">Details</th>
                            <th class="GridViewHeaderStyle" style="width: 127px;">Entry Date</th>
                            <th class="GridViewHeaderStyle" style="width: 53px;">Active</th>
                            <th class="GridViewHeaderStyle" style="width: 70px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>

                <div id="green" style="margin: auto;">
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            bindGroup();
            showQueryList();
        });
        function bindGroup() {
            jQuery("#ddlgroup option").remove();
            jQuery.ajax({
                url: "../CallCenter/Services/CallCenter.asmx/BindGroup",
                data: '', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var Group = jQuery.parseJSON(result.d);

                    if (Group.length == 0) {
                        jQuery("#<%=ddlgroup.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#<%=ddlgroup.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                        for (var i = 0; i <= Group.length - 1; i++) {
                            jQuery('#ddlgroup').append('<option value="' + Group[i].GroupID + '">' + Group[i].GroupName + '</option>');
                        }
                    }
                    jQuery("#ddlgroup").trigger('chosen:updated');
                },
                error: function (xhr, status) {
                    alert('Error!!!');
                }
            });
        }
        function bindCategory() {          
            jQuery("#ddlCategory option").remove();
            jQuery.ajax({
                url: "../CallCenter/Services/CallCenter.asmx/BindCategory",
                data: '{ GroupID: "' + jQuery("#<%=ddlgroup.ClientID %>").val() + '"}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var categoryname = jQuery.parseJSON(result.d); 

                    if (categoryname.length == 0) {
                        jQuery("#<%=ddlCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#<%=ddlCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                        for (var i = 0; i <= categoryname.length - 1; i++) {
                            jQuery('#ddlCategory').append('<option value="' + categoryname[i].ID + '">' + categoryname[i].CategoryName + '</option>');
                        }
                    }
                    jQuery("#ddlCategory").trigger('chosen:updated');
                },
                error: function (xhr, status) {
                    alert('Error!!!');
                }
            });
        }
        function SaveInquiry() {

            if (jQuery("#ddlgroup").val() == 0) {
                showerrormsg("Please Select Group");
                jQuery("#ddlgroup").focus();
                return;
            }
            if (jQuery("#ddlCategory").val() == 0) {
                showerrormsg("Please Select Category");
                jQuery("#ddlCategory").focus();
                return;
            }
            if (jQuery("#ddlSubCategory").val() == 0) {
                showerrormsg("Please Select SubCategory");
                jQuery("#ddlSubCategory").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtSubject").val()) == "") {
                showerrormsg("Please Enter Subject");
                jQuery("#txtSubject").focus();
                return;
            }
            if (jQuery.trim(jQuery("#txtDetail").val()) == "") {
                showerrormsg("Please Enter Detail");
                jQuery("#txtDetail").focus();
                return;
            }
            var status = jQuery('#Active').is(':checked') ? "1" : "0";
            var request = { IsActive: status, Type: jQuery('#ddlType').val(), CategoryID: jQuery('#ddlCategory').val(), CategoryName: jQuery('#ddlCategory option:selected').text(), SubCategoryID: jQuery('#ddlSubCategory').val(), Subject: jQuery('#txtSubject').val(), Detail: jQuery('#txtDetail').val(), EditId: jQuery('#editeId_9384').val(), GroupID: jQuery('#ddlgroup').val() };

            jQuery('#btnsave').attr('disabled', 'disabled').val('Saving...');
            jQuery.ajax({
                url: "Inquiry_Master.aspx/SaveInquiry",
                data: JSON.stringify(request),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    jQuery('#btnsave').removeAttr('disabled').val('Save');
                    if (result.d == "1") {
                        showQueryList();
                        showerrormsg("Record saved successfully");
                    }
                    else if (result.d == "2") {
                        showQueryList();
                        showerrormsg("Record updated successfully");
                    }
                    else {
                        showerrormsg("Record not saved");
                        return;
                    }
                    jQuery('#ddlType').val("Query");
                    jQuery('#ddlCategory').val('0');
                    jQuery('#txtSubject,#txtDetail').val('');
                    jQuery('#editeId_9384').val('');
                    jQuery('.alert').css('width', '260px');
                    jQuery("#ddlCategory").trigger('chosen:updated');

                    jQuery("#ddlSubCategory option").remove();
                    jQuery("#ddlSubCategory").trigger('chosen:updated');

                },
                error: function (xhr, status) {
                    alert('Error!!!');
                }
            });

        }
        function showQueryList() {
            jQuery.blockUI();
            var aas = 1;

            jQuery.ajax({
                url: "Inquiry_Master.aspx/GetQueryList",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {
                    jQuery.unblockUI();

                    var Result = jQuery.parseJSON(data.d);
                    jQuery('#queryList').html('');
                    if (Result == "-1") {
                        alert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (Result.length == 0) {

                        showerrormsg('No Record Found');
                        return;
                    }
                    else {
                        jQuery('#queryListHead tbody').html('');
                        jQuery.each(Result, function (index, item) {

                            var sss = aas++;
                            var actdect = item.isActive;
                            if (actdect == "1") {
                                actdect = "Yes";
                            }
                            else {
                                actdect = "No";
                            }
                            jQuery('#queryListHead').append('<tr>' +
                                '<td class="GridViewLabItemStyle" style="">' + sss + '</td>' +
                                '<td class="GridViewLabItemStyle" style="width: 48px;">' + item.TYPE + '</td>' +
                                 '<td class="GridViewLabItemStyle" style="">' + item.GroupName + '</td>' +
                                 '<td class="GridViewLabItemStyle" style="">' + item.CategoryName + '</td>' +
                                 '<td class="GridViewLabItemStyle" style="">' + item.SubCategoryName + '</td>' +
                                '<td class="GridViewLabItemStyle" style="">' + item.SUBJECT + '</td>' +
                                '<td class="GridViewLabItemStyle" style="">' + item.Detail + '</td>' +
                                '<td class="GridViewLabItemStyle" style="">' + item.dtEntry + '</td>' +
                                '<td class="GridViewLabItemStyle" style="width:45px;">' + actdect + '</td>' +
                                  '<td class="GridViewLabItemStyle" style=""><input type="button" value="Edit" onclick="EditeQuery(' + item.ID + ')" /></td>' +
                                //'<td style=""><input type="button" value="Edit" onclick="EditeQuery(' + item.Id + ')" />&nbsp;<input type="button" value="Delete" onclick="deleteQuery(' + item.Id + ')" /></td>' +
                                '</tr>');
                        });
                    }
                },
                error: function (xhr, status) {
                    alert("Error.... ");
                }
            });
        }

        function deleteQuery(id) {
            jQuery.ajax({
                url: "Inquiry_Master.aspx/DeleteQuery",
                data: JSON.stringify({ Id: id }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {
                    if (data.d != "") {
                        alert(data.d);
                        showQueryList();
                    }
                },
                error: function (xhr, status) {
                    alert("Error.... ");
                }
            });
        }
        function EditeQuery(id) {
            jQuery.ajax({
                url: "Inquiry_Master.aspx/EditeQuery",
                data: '{ Id: "' + id + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {

                    if (data.d != "") {
                        var Result = jQuery.parseJSON(data.d);
                        jQuery('#ddlType').val(Result[0].TYPE);
                        jQuery('#ddlgroup').val(Result[0].GroupID);
                        jQuery("#<%=ddlgroup.ClientID %>").trigger('chosen:updated');
                        bindCategory();
                        jQuery('#ddlCategory').val(Result[0].categoryId);
                        jQuery("#<%=ddlCategory.ClientID %>").trigger('chosen:updated');

                        bindSubcategory(Result[0].SubCategoryId);

                        jQuery('#txtSubject').val(Result[0].SUBJECT);
                        jQuery('#txtDetail').val(Result[0].Detail);
                        jQuery('#editeId_9384').val(Result[0].Id);
                        jQuery("#lblremaingCharacters").html(MaxLength - (jQuery("#<%=txtDetail.ClientID %>").val().length));
                        var status = Result[0].isActive;

                        if (status == "1") {
                            jQuery('#Active').prop('checked', true);
                        }
                        else {
                            jQuery('#Active').prop('checked', false);
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error.... ");
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
        jQuery(function () {

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
    </script>
    <script type="text/javascript">
        function bindSubcategory(con) {
            jQuery("#<%=ddlSubCategory.ClientID %> option").remove();
            jQuery("#txtSubject,#txtDetail").val('');
            if (jQuery("#<%=ddlCategory.ClientID %>").val() != 0) {
                jQuery.ajax({
                    url: "../CallCenter/Services/CallCenter.asmx/BindSubCategory",
                    data: '{ CategoryID: "' + jQuery("#<%=ddlCategory.ClientID %>").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            jQuery("#<%=ddlSubCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlSubCategory.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < ItemData.length; i++) {
                                jQuery("#<%=ddlSubCategory.ClientID %>").append(jQuery("<option></option>").val(ItemData[i].ID).html(ItemData[i].SubCategoryName));
                            }
                        }
                        if (con != 0) {
                            jQuery("#<%=ddlSubCategory.ClientID %>").val(con);
                        }
                        jQuery("#<%=ddlSubCategory.ClientID %>").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {

                    }
                });
            }
            else {
                jQuery("#<%=ddlSubCategory.ClientID %>").trigger('chosen:updated');
            }
        }
    </script>
    <script type="text/javascript">

        var MaxLength = 500;
        jQuery(function () {

            jQuery("#<% =txtDetail.ClientID%>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            jQuery("#lblremaingCharacters").html(MaxLength - (jQuery("#<%=txtDetail.ClientID %>").val().length));
            jQuery("#<%=txtDetail.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = jQuery(this).val().length;
                if (characterInserted > MaxLength) {
                    jQuery(this).val(jQuery(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                jQuery("#lblremaingCharacters").html(characterRemaining);
            });

            jQuery('#<%=txtDetail.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if (jQuery(this).val().length >= MaxLength) {
                    if (keynum == 8) {
                        return true;
                    }
                    else {
                        if (window.event)//IE
                        {
                            e.returnValue = false;
                            return false;
                        }
                        else//Firefox
                        {
                            e.preventDefault();
                            return false;
                        }
                    }

                }
            });
        });
        function bindSubject() {
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val() == 0) {
                jQuery("#txtSubject").val('');
            }
            else {
                jQuery("#txtSubject").val(jQuery("#<%=ddlSubCategory.ClientID %> option:selected").text());
            }
        }
    </script>    
</asp:Content>

