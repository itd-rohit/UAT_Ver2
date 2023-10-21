<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CallCenterPincodeArea.aspx.cs" Inherits="Design_CallCenter_CallCenterPincodeArea" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center; height: 50px;">
            <b>Pincode Bind Area</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory">
            <table>
                <tr>
                    <td style="font-weight: bold;">Pincode : &nbsp;</td>
                    <td>
                        <input type="hidden" id="id" />
                        <input type="text" style="height: 20px; width: 200px;" id="catName" /></td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Centre : &nbsp;</td>
                    <td>
                        <asp:DropDownList ID="ddlCentre" runat="server" class="ddlCentre chosen-select chosen-container" Width="160px" ClientIDMode="Static"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Field Boy : &nbsp;</td>
                    <td>
                        <input type="hidden" id="FieldId" />
                        <asp:ListBox ID="lstFieldBoy" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" value="save" id="savebtn" class="searchbutton" onclick="savdata();" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table style="text-align: left; width: 945px;">
                <thead>
                    <tr style="height: 25px; background-color: silver; color: black; font-weight: bold;">
                        <th style="display: none;">ID</th>
                        <th>PinCode</th>
                        <th>Centre</th>
                        <th>Area</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="bindarea">
                </tbody>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $('[id*=lstFieldBoy]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('.ms-parent multiselect').css('width', '150px;');
            getCentre();
            getFieldBoy();
            GetData();
        });
        function getFieldBoy() {
            $.ajax({
                url: "CallCenterPincodeArea.aspx/GetFeildBoy",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    jQuery('#lstFieldBoy option').remove();
                    jQuery('#lstFieldBoy').multipleSelect("refresh");
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstFieldBoy").append(jQuery("<option></option>").val(centreData[i].FeildboyID).html(centreData[i].NAME));
                    }

                    if ($('#FieldId').val() != "") {
                        $('#lstFieldBoy').val($('#FieldId').val());
                    }
                    $("#lstFieldBoy").trigger('chosen:updated');
                    $('[id*=lstFieldBoy]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                },
                error: function (xhr, status) {
                    alert('Error!!!');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function getCentre() {
            $.ajax({
                url: "CallCenterPincodeArea.aspx/GetCentre",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    AreaData = jQuery.parseJSON(result.d);

                    if (AreaData.length == 0) {
                        $('#ddlCentre').append($("<option></option>").val("0").html("---No Data Found---"));

                    }
                    else {
                        $('#ddlCentre').html('');
                        $('#ddlCentre').append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < AreaData.length; i++) {

                            $('#ddlCentre').append($("<option></option>").val(AreaData[i].CentreID).html(AreaData[i].Centre));
                        }
                    }
                    $('.chosen-container').css('width', '170px');
                    $('#ddlCentre').trigger('chosen:updated');

                },
                error: function (xhr, status) {
                    alert('Error!!!');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function GetData() {
            $.ajax({
                url: "CallCenterPincodeArea.aspx/BindData",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = $.parseJSON(result.d);
                    if (data == null) {
                        showerrormsg("No Category Found..!");
                    }
                    else {
                        $('#bindarea').html('');
                        for (var i = 0; i < data.length; i++) {
                            $('#bindarea').append('<tr>' +
                           '<td style="display:none;">' + data[i].ID + '</td>' +
                           '<td style="display:none;">' + data[i].CentreID + '</td>' +
                           '<td style="display:none;">' + data[i].FieldboyID + '</td>' +
                           '<td>' + data[i].Pincode + '</td>' +
                           '<td>' + data[i].Centre + '</td>' +
                           '<td>' + data[i].Locality + '</td>' +
                           '<td><input type="button" value="Edit" onclick="EditData(this);"/></td>' +
                       '</tr>');
                        }
                    }
                }
            });
        }
        function EditData(btnl) {
            if (typeof (btnl) == "object") {
                var request = { CentreID: $(btnl).closest("tr").find("td:eq(1)").text() };
                $.ajax({
                    url: "CallCenterPincodeArea.aspx/EditData",
                    data: JSON.stringify(request),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var data = $.parseJSON(result.d);
                        $('#id').val(data[0].CentreID);
                        $('#catName').val(data[0].Pincode);
                        $('#ddlCentre').val(data[0].CentreID);
                        $('#ddlCentre').trigger('chosen:updated');
                        var flId = "";
                        for (var i = 0; i < data.length; i++) {
                            flId = flId + data[i].FieldboyID + ",";

                            $('#FieldId').val(flId.substring(0, flId.length - 1));
                            getFieldBoy();
                        }
                    }
                });
                //$('#id').val($(btnl).closest("tr").find("td:eq(0)").text());
                //$('#catName').val($(btnl).closest("tr").find("td:eq(3)").text());
                //$('#ddlCentre').val($(btnl).closest("tr").find("td:eq(1)").text());
                //$('#ddlCentre').trigger('chosen:updated');
                //$('#ddlFieldBoyId').val($(btnl).closest("tr").find("td:eq(2)").text());
            }
        }
        function savdata() {
            if ($('#catName').val() == "") {
                showerrormsg("Please enter category name");
                return;
            }
            if ($('#catType').val() == "") {
                showerrormsg("Please select category type");
                return;
            }
            $('#savebtn').attr('disabled', 'disabled').val('saving...');
            var request = { Pincode: $('#catName').val(), CentreID: $('#ddlCentre').val(), Id: $('#id').val(), FieldboyID: $('#lstFieldBoy').val() };
            $.ajax({
                url: "CallCenterPincodeArea.aspx/SaveData",
                data: '{Pincode: "' + $('#catName').val() + '", CentreID: "' + $('#ddlCentre').val() + '", Id: "' + $('#id').val() + '", FieldboyID: "' + $('#lstFieldBoy').val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $('#savebtn').removeAttr('disabled').val('save');
                    if (result.d == "1") {
                        $('#id').val('');
                        $('#catName').val('');
                        $('#catType').val('');
                        $('#ddlCentre').val(0).trigger('chosen:updated');
                        jQuery('#lstFieldBoy').multipleSelect("refresh");
                        jQuery('#lstFieldBoy option').remove();
                        getFieldBoy();
                        GetData();
                        showmsg("Save successfully...");
                        return;
                    }
                    if (result.d == "0") {
                        showerrormsg("record not saved please try again...");
                        return;
                    }
                }
            });
        }
        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
</asp:Content>

