<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StockLedgerReport_new.aspx.cs" Inherits="Design_Store_StockLedgerReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    

      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

      <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Stock Ledger Report(Stock Movement On Date)</b>
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError" />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="divSearch">
                <div class="Purchaseheader">
                    As On Date
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">From Date:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:TextBox ID="txtfromdate" CssClass="requiredField" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3 ">
                                    <label class="pull-left ">To Date:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <asp:TextBox ID="txttodate" CssClass="requiredField" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="txtfromdate0_CalendarExtender" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                                </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           <div class="POuter_Box_Inventory">
            <div id="div1">
                <div class="Purchaseheader">
                   Location Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Current Location:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                    <%-- <asp:DropDownList ID="ddllocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" style="width:400px;"></asp:DropDownList> &nbsp;&nbsp;&nbsp;--%>
                                  <asp:ListBox ID="ddllocation" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                                </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
              </div>
           <div class="POuter_Box_Inventory">
            <div id="div2">
                <div class="Purchaseheader">
                  Item Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Category Type:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                  <asp:ListBox ID="ddlcattype" CssClass="multiselect requiredField" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>
                                </div>
                                 <div class="col-md-3 ">
                                    <label class="pull-left ">SubCategory Type:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                 <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>
                                </div>

                                </div>
                              <div class="row">
                                <div class="col-md-3 ">
                                    <label class="pull-left ">Item Category:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                  <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                                </div>
                                 <div class="col-md-3 ">
                                    <label class="pull-left ">Items:   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-9 ">
                                  <asp:ListBox ID="ddlItem" CssClass="multiselect requiredField" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                                </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
              </div>
            <div class="POuter_Box_Inventory">
            <div id="div3">
                <div class="Purchaseheader">
                  Other Detail
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="row">
                                <div class="col-md-3 ">
                                    <asp:CheckBox ID="ck" runat="server" Text="Manufacture" Font-Bold="true" onclick="bindmm()" />
                                </div>
                                <div class="col-md-9 ">
                                  <asp:DropDownList ID="ddlmanu" runat="server" ></asp:DropDownList>
                                </div>
                                 <div class="col-md-3 ">
                                   <label class="pull-left ">Machine:   </label>
                                    <b class="pull-right">:</b> 
                                </div>
                                <div class="col-md-9 ">
                                  <asp:DropDownList ID="ddlmachine" runat="server" ></asp:DropDownList>
                                </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
           <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="div6">
                <div class="row">
                    <div class="col-md-24 ">
                       <input type="button" class="searchbutton" value="Get Report PDF" onclick="getpdfreport()" />&nbsp;&nbsp;
                     <input type="button" class="searchbutton" value="Get Report Excel" onclick="getexcelreport()" />
                    </div>
                </div>
            </div>
        </div>
          </div>

    <script type="text/javascript">

        $(function () {

            $('[id*=ddlcategory]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=ddllocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            $('[id*=ddlcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlsubcattype]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddlmanu.ClientID%>').append($("<option></option>").val("0").html(""));
            bindmachine();
            bindCatagoryType();


        });



        $(document).ready(function () {


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

    <script type="text/javascript">


        function bindmm() {

            if ($('#<%=ck.ClientID%>').prop('checked') == true) {
                bindManufacture();
            }
            else {
                var ddlManufacturingCompany = $('#<%=ddlmanu.ClientID%>');

                ddlManufacturingCompany.empty();
                ddlManufacturingCompany.append($("<option></option>").val("0").html(""));
            }
        }

        function bindManufacture() {
            var ddlManufacturingCompany = $('[id$=ContentPlaceHolder1_ddlmanu]');
            ddlManufacturingCompany.empty();
            serverCall('Services/StoreCommonServices.asmx/bindManufacture', {}, function (response) {
                ddlManufacturingCompany.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
            });
        }

        function bindmachine() {
            var ddlMachineName = $('[id$=ContentPlaceHolder1_ddlmachine]');
            ddlMachineName.empty();
            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                ddlMachineName.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
            });
        }
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
                var $ddlCtype = $('#<%=ddlcattype.ClientID%>');
                $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: $("#ddlcattype"), isClearControl: '' });
            });
        }
       
        function bindSubcattype(CategoryTypeID) {
            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");

            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeID != "") {
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID.toString() }, function (response) {
                    var $ddlStype = $('#<%=ddlsubcattype.ClientID%>');
                    $ddlStype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: $("#ddlsubcattype"), isClearControl: '' });
                });
                binditem();
            }
        }


        function bindCategory(SubCategoryTypeMasterId) {
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (SubCategoryTypeMasterId != "") {
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId.toString() }, function (response) {
                    var $ddlC = $('#<%=ddlcategory.ClientID%>');
                    $ddlC.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
                });
                binditem();
            }
        }
       
        function binditem() {
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    serverCall('StockStatusReport.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId:SubCategoryTypeId, CategoryId:CategoryId, LocationID:$('#<%=ddllocation.ClientID%>').val().toString()}, function (response) {
                        var $ddlItem = $('#<%=ddlItem.ClientID%>');
                        $ddlItem.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                    });
                }
            }
        }
     
    </script>

        <script type="text/javascript">

            function getpdfreport() {
                var locations = $("#ddllocation").val().toString();
                var Items = $("#ddlItem").val().toString();
                var manu = $("#<%=ddlmanu.ClientID%>").val().toString();
                var machine = $("#<%=ddlmachine.ClientID%>").val().toString();
                var fromdate = $("#<%=txtfromdate.ClientID%>").val().toString();
                var todate = $("#<%=txttodate.ClientID%>").val().toString();

                $modelBlockUI();
                serverCall('StockLedgerReport_new.aspx/getstockstatusreportpdf', { location: locations, Items: Items, manu: manu, machine: machine, fromdate: fromdate, todate: todate }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {

                        var $objData = new Object();
                        $objData.FromDate = JSON.parse(response).FromDate;
                        $objData.ToDate = JSON.parse(response).ToDate;
                        $objData.ItemID = JSON.parse(response).ItemID;
                        $objData.Manu = JSON.parse(response).Manu;
                        $objData.LocationID = JSON.parse(response).LocationID;
                        $objData.MachineID = JSON.parse(response).MachineID;
                        $objData.ReportPath = JSON.parse(response).ReportPath;
                        PostFormData($objData,$objData.ReportPath);
                    }
                    else {
                        toast("Error", "Error", "");
                    }
                });
            }
        </script>

         <script type="text/javascript">

             function getexcelreport() {


                 var locations = $("#ddllocation").val().toString();

                 var Items = $("#ddlItem").val().toString();
                 var manu = $("#<%=ddlmanu.ClientID%>").val().toString();
                 var machine = $("#<%=ddlmachine.ClientID%>").val().toString();

                 var fromdate = $("#<%=txtfromdate.ClientID%>").val().toString();
                 var todate = $("#<%=txttodate.ClientID%>").val().toString();

                 $modelBlockUI();
                 serverCall('StockLedgerReport.aspx/getstockstatusreportexcel', { location: locations, Items: Items, manu: manu, machine: machine, fromdate: fromdate, todate: todate }, function (response) {
                     $responseData = JSON.parse(response);
                     if ($responseData.status) {

                         var $objData = new Object();
                         $objData.FromDate = JSON.parse(response).FromDate;
                         $objData.ToDate = JSON.parse(response).ToDate;
                         $objData.ItemID = JSON.parse(response).ItemID;
                         $objData.Manu = JSON.parse(response).Manu;
                         $objData.LocationID = JSON.parse(response).LocationID;
                         $objData.MachineID = JSON.parse(response).MachineID;
                         $objData.ReportType = JSON.parse(response).ReportType;
                         $objData.ReportPath = JSON.parse(response).ReportPath;
                         PostFormData($objData,$objData.ReportPath);
                     }
                     else {
                         toast("Error", "Error", "");
                     }
                 });
             }
        </script>
</asp:Content>
