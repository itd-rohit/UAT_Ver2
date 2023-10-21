<%@ Page  Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="POAgainstPI.aspx.cs" Inherits="Design_Store_POAgainstPI" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
  <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1304px;">
         <asp:Label ID="lblApprovalCount" runat="server" Style="display: none"></asp:Label>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <b>Purchase Order Against Purchase Indent</b>
            <br />
            <asp:Label ID="lblError" runat="server" CssClass="ItDoseLblError"></asp:Label>
             <asp:Label ID="lblPurchaseOrderID" runat="server" CssClass="ItDoseLblError" Style="display: none"></asp:Label>
            <asp:Label ID="lblPurchaseOrderNo" runat="server" CssClass="ItDoseLblError" Style="display: none"></asp:Label>
        </div>
         <div class="POuter_Box_Inventory" style="width: 1300px;" id="hideDetail">
            
            <div class="divSearchInfo" style="display: none;" id="divSearch">
                <div style="width: 1300px; background-color: papayawhip;">
                    <div class="Purchaseheader">
                        Search Option
                    </div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td style="width: 10%">City :&nbsp;</td>
                            <td style="width: 22%">
                                <asp:TextBox ID="txtCity" runat="server" Width="232px"></asp:TextBox>
                            </td>
                            <td style="width: 12%">&nbsp;</td>
                            <td style="width: 22%">
                                <asp:ListBox ID="lstCity" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                            </td>
                            <td style="width: 10%">
                                <input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />
                            </td>
                            <td style="width: 24%">&nbsp;</td>
                        </tr>
                    </table>
                </div>
            </div>
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td>Category :&nbsp;  <asp:DropDownList ID="ddlcategorytype" ClientIDMode="Static" runat="server" TabIndex="1"  
                                    Width="110px">
                                </asp:DropDownList>
                           &nbsp; From Date :&nbsp;<asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        &nbsp;</td>
                    <td>To Date :&nbsp; &nbsp;<asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    &nbsp; Indent No: <asp:TextBox ID="txtindentnosearch" runat="server" Width="145px"></asp:TextBox></td>
                    <td style="width: 10%">Vendor :&nbsp;</td>
                    <td style="width: 24%"><asp:ListBox ID="lstVendor" runat="server" CssClass="multiselect " SelectionMode="Multiple" Width="300px"></asp:ListBox></td>
                </tr>  
                
                 <tr>
                    <td colspan="4">Centre Type :&nbsp;<asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="120px" runat="server" onchange="bindlocation()"></asp:ListBox>
                         &nbsp;
                         Zone :&nbsp;
                         <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="120px"  onchange="bindCentre()"></asp:ListBox>
                     &nbsp; State :&nbsp; <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="220px" onchange="bindlocation()"></asp:ListBox>
                     &nbsp;Location :<asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="300px" onchange="bindpendingpi()"></asp:ListBox>
                         &nbsp;Pending PI :<asp:ListBox ID="lstpendingpi" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="126px"></asp:ListBox>
                     </td>
                    
                </tr>                 
            </table>

             <table style="width: 100%; border-collapse: collapse;display:none;" class="t1" >
                <tr >
                    <td style="width: 10%">Centre Type :&nbsp;
                    </td>
                    <td style="width: 22%">
                       
                    </td>
                    <td style="width: 12%">Category Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstCategoryType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                    <td style="width: 10%">Manufacture :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstManufacture" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">Zone :&nbsp;</td>
                    <td style="width: 22%">
                       
                    </td>
                    <td style="width: 12%">Sub Category Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstSubCategory" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox></td>

                    <td style="width: 10%">Machine :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstMachine" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">State :&nbsp;</td>
                    <td style="width: 22%">
                       
                    </td>
                    <td style="width: 12%">Item Type :&nbsp;</td>
                    <td style="width: 22%">
                        <asp:ListBox ID="lstItemType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server"></asp:ListBox></td>
                    <td style="width: 10%">Item :&nbsp;</td>
                    <td style="width: 24%">
                        <asp:ListBox ID="lstItemGroup" runat="server" CssClass="multiselect " SelectionMode="Multiple" Width="300px"></asp:ListBox>
                    </td>
                </tr>


                 <tr >
               <td style="width: 10%">Centre :&nbsp;</td>
                      <td style="width: 22%">
                        <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="240px" onchange="bindlocation();"></asp:ListBox>
                    </td>
                       <td style="width: 12%">Location :&nbsp;</td>
                      <td style="width: 22%">
                       
                    </td>
                 </tr>
                
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left; width: 1300px;">
            <table width="100%">
                <tr>
                    <td style="font-weight: 700">Payment Term :</td>
                     <td width="305px" style="width: 510px">
                         <asp:DropDownList ID="ddlpaymentterm" runat="server" Width="400px" onchange="setpaymentterm()">
                             <asp:ListItem Value="1">100% Payment  within 30 days of delivery and submission of invoice with delivery acknowledgement</asp:ListItem>
                             <asp:ListItem Value="2">Other</asp:ListItem>
                         </asp:DropDownList>
                        <asp:TextBox ID="txtpaymentterm" runat="server" Width="200px" placeholder="Enter Payment Term" style="display:none;" MaxLength="100" />
                     </td>
                    <td style="font-weight: 700">Delivery Term:</td>
                     <td width="305px">
                         <asp:DropDownList ID="ddldeliveryterm" runat="server" Width="300px" onchange="setdeliveryterm()">
                              
                             <asp:ListItem Value="2" Selected="True">Other</asp:ListItem>
                          <%--   <asp:ListItem Value="1">Immediate</asp:ListItem>--%>
                         </asp:DropDownList>
                     </td>
                    <td width="205px">
                        <asp:TextBox ID="txtdeliveryterm" runat="server" Width="200px" placeholder="Enter Delivery Term" style="display:none;" MaxLength="100" />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: 700">Warranty:</td>
                     <td width="305px" style="width: 510px">
                        <asp:TextBox ID="txtWarranty" Width="286px" runat="server" MaxLength="200" /></td>
                    <td style="font-weight: 700">NFA No:</td>
                     <td width="305px">
                     <asp:TextBox ID="txtnfano" runat="server" Width="200px" MaxLength="50" />    
                     </td>
                    <td width="205px">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="font-weight: 700">Term &amp; Condition :</td>
                     <td width="305px" colspan="3" style="width: 610px">
                        <asp:TextBox ID="txttermandcondition" Width="832px" runat="server" MaxLength="200" /></td>
                    <td width="205px">
                        &nbsp;</td>
                </tr>
            </table>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            
            <span style="background-color:red;color:white;cursor:pointer;" id="isedited"></span>
            <span style="font-size:13px;font-style:italic"> * Yellow Marked Item Reject Earlier</span>
             &nbsp;&nbsp;  <input type="button" id="btnSearch" value="Search" class="searchbutton" onclick="searchData(0)" />&nbsp;&nbsp;    
            <input type="button" id="btnSave" value="Make PO" class="savebutton" style="display:none" onclick="savePurchaseOrder()" /> &nbsp;&nbsp; 
            
           <% if(Util.GetString(Request.QueryString["ActionType"])=="")
{%>
            <input type="button" id="btnUpdateRate" style="display:none;" class="resetbutton" onclick="updatenewrate()" value="Update Rate" />     &nbsp;
            
            <%}%>
            
             <input type="button" id="btnCheck" value="Check" style="display: none; cursor: pointer;" class="savebutton" onclick="MakeAction('Check');" />
            <input type="button" id="btnApproval" value="Approval" style="display: none; cursor: pointer;" class="savebutton" onclick="MakeAction('Approval');" /> 

                 <input type="button" id="btnview" value="View" style="display: none; cursor: pointer;" class="searchbutton" onclick="ViewMe();" />
            
            <span id="bal" style="font-weight:bold;"></span>
            
            
            <table style="float:right">

                <tr>

                     <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:white;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>

                    <td style="font-weight: 700">Rate Not Changed</td>

                   <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:pink;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>

                    <td style="font-weight: 700">Rate Changed</td>
                </tr>
            </table>        
            </div>


        

        <div class="POuter_Box_Inventory" style="width:1300px;">  
     <div id="div_PO"  style="max-height:433px; overflow-y:auto; overflow-x:hidden;">       
        </div>       
   </div>   
        </div>

      <asp:Panel ID="pnl" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="900px" >
          <table id="newtable" width="99%" frame="box" rules="all" border="1" style="display:none;">
              <tr style="font-weight:bold;background-color:maroon;color:white;height:25px;">
                  <td>#</td>
                  <td>Supplier</td>
                  <td>Rate</td>
                   <td>Discount %</td>
                  <td>Tax  %</td>
                  <td>UnitPrice</td>
                  <td>NetAmount</td>
              </tr>
          </table>


          <div style="width:100%;max-height:400px;overflow:auto;">
          <table id="newtable1" width="99%" frame="box" rules="all" border="1" style="display:none;">
               <tr style="font-weight:bold;background-color:maroon;color:white;height:25px;">
                  <td>#</td>
                  <td>Select</td>
                  <td>Supplier</td>
                  <td>Item</td>
                  <td>Rate</td>
                  <td>Discount %</td>
                  <td>IGST  %</td>
                  <td>SGST %</td>
                  <td>CGST %</td>
              </tr>
          </table></div>
           <center>
          
               <asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" /> </center>
          </asp:Panel>
      <cc1:ModalPopupExtender ID="modelpopup1" runat="server"   TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button2" runat="server" style="display:none" />




        <script type="text/javascript">


            $(function () {
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
        var ActionType = "";
        jQuery(function () {

            if ('<%=Request.QueryString["POID"]%>' != "") {
                jQuery("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#hideDetail,#btnSearch,#btnSave").hide();

                
               

                PageMethods.setPOData('<%=Request.QueryString["POID"]%>', onSucessSearchPO, onFailureSearchPO);
            }

        });
        function onSucessSearchPO(result) {
            
            POData = jQuery.parseJSON(result);
            var output = jQuery('#sc_PO').parseTemplate(POData);
            jQuery('#div_PO').html(output);
            jQuery("#div_PO,#btnSave,#btnUpdateRate").show();
            jQuery("#tbl_PO").tableHeadFixer({
            });

            jQuery('#lblPurchaseOrderID').text(POData[0].PurchaseOrderID);
            jQuery('#lblPurchaseOrderNo').text(POData[0].PurchaseOrderNo);

            $('#<%=txtWarranty.ClientID%>').val(POData[0].Warranty);
            $('#<%=txtnfano.ClientID%>').val(POData[0].NFANo);
            $('#<%=txttermandcondition.ClientID%>').val(POData[0].TermandCondition);
            
            jQuery('#isedited').html(POData[0].re);
            $("#isedited").on("click", function () { showerrormsg(POData[0].remsg); });
            
            var TotalRigthsPO = POData[0].TotalRigthsPO;
            if (TotalRigthsPO == null) {
                TotalRigthsPO = '';
            }

            PageMethods.setPOTermsandconditions(POData[0].PurchaseOrderID, onSucessPOTermsandconditions, onFailureSearchPO);

            var AlreadyActionPerformed = POData[0].ActionType;
            var IsMakerFound = -1;
            var IsCheckerFound = -1;
            var IsApprovalFound = -1;
            IsMakerFound = TotalRigthsPO.indexOf('Maker');
            IsCheckerFound = TotalRigthsPO.indexOf('Checker');
            IsApprovalFound = TotalRigthsPO.indexOf('Approval');



            if (POData[0].ActionType == "Maker") {
                ActionType = "Checker";
                jQuery('#btnSave').hide();
                if (IsCheckerFound >= 0) {
                    jQuery('#btnCheck').show();
                    jQuery('#btnview').show();
                    jQuery('#btnUpdateRate').show();
                }
                sumtotal();



            }
            else if (POData[0].ActionType == "Checker") {
                ActionType = "Approval";
                jQuery('#btnCheck,#btnSave,#btnview').hide();
                if (IsApprovalFound >= 0) {
                    jQuery('#btnApproval').show();
                    
                    jQuery('#btnview').show();
                    jQuery('#btnUpdateRate').hide();
                }
                sumtotal();
            }
            else {
                jQuery('#btnCheck,#btnApproval,#btnSave,#btnUpdateRate,#btnview').hide();
                sumtotal();
            }
        }

        function sumtotal() {

            var total = 0;
            $('#tbl_PO tr').each(function () {

                if ($(this).attr('id') != 'Header') {
                    total = parseFloat($(this).find('#spnNetAmt').html());
                  
                }
            });

            $('#bal').html("Total PO Value :" + precise_round(total,0));
            
        }

        function onFailureSearchPO(result) {

        }

        function onSucessPOTermsandconditions(result) {
            var POTermsData = jQuery.parseJSON(result);

            $('#ddlpaymentterm').val(POTermsData[0].TermConditionID);
            if (POTermsData[0].TermConditionID == "2") {
           
                $('#txtpaymentterm').val(POTermsData[0].TermCondition);
                $('#txtpaymentterm').show();
            }
            $('#ddldeliveryterm').val(POTermsData[0].DeliveryTermID);
            if (POTermsData[0].DeliveryTermID == "2") {
                $('#txtdeliveryterm').val(POTermsData[0].DeliveryTerm);
                $('#txtdeliveryterm').show();
            }
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            var cityId = "";
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                jQuery.ajax({
                    url: "StoreLocationMaster.aspx/bindCentre",
                    data: '{TypeId: "' + TypeId + '",ZoneId: "' + ZoneId + '",StateID: "' + StateID + '",cityid: "' + cityId + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var centreData = jQuery.parseJSON(result.d);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }
                        $('[id*=lstCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }

            bindlocation();
        }

        function bindlocation() {

            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            var cityId = "";

            var centreid = jQuery('#lstCentre').val();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery.ajax({
                url: "MappingStoreItemWithCentre.aspx/bindlocation",
                data: '{centreid:"' + centreid + '",StateID:"' + StateID + '",TypeId:"' + TypeId + '",ZoneId:"' + ZoneId + '",cityId:"' + cityId + '"}',
                type: "POST",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstlocation").append(jQuery("<option></option>").val(centreData[i].LocationID).html(centreData[i].Location));
                    }
                    $('[id*=lstlocation]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }

  </script>
        <script type="text/javascript">
            jQuery(function () {
                jQuery('[id*=lstpendingpi],[id*=lstCentreType],[id*=lstCategoryType],[id*=lstManufacture],[id*=lstZone],[id*=lstSubCategory],[id*=lstMachine],[id*=lstState],[id*=lstItemType],[id*=lstItemGroup],[id*=lstCity],[id*=lstVendor],[id*=lstCentre],[id*=lstlocation]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                bindcenterType();
                bindZone();
                bindCategoryType();
                bindManufacture();
                bindMachine();
                bindVendor();

                setdeliveryterm();
            });
            function bindcenterType() {
                jQuery('#<%=lstCentreType.ClientID%> option').remove();
                jQuery('#lstCentreType').multipleSelect("refresh");
                CommonServices.bindTypeLoad(onSucessCentreType, onFailureCentreType);
            }
            function onSucessCentreType(result) {
                var typeData = jQuery.parseJSON(result);
                for (var a = 0; a <= typeData.length - 1; a++) {
                    jQuery('#lstCentreType').append($("<option></option>").val(typeData[a].id).html(typeData[a].type1));
                }
                jQuery('[id*=lstCentreType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
            function onFailureCentreType() {

            }
            function bindZone() {
                jQuery('#<%=lstZone.ClientID%> option').remove();
                jQuery('#lstZone').multipleSelect("refresh");
                CommonServices.bindBusinessZone(onSucessBusinessZone, onFailureBusinessZone);
            }
            function onSucessBusinessZone(result) {
                var BusinessZoneID = jQuery.parseJSON(result);
                for (i = 0; i < BusinessZoneID.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                }
                jQuery('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
            function onFailureBusinessZone() {

            }
            jQuery('#lstZone').on('change', function () {
                jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            var BusinessZoneID = $(this).val();

            bindState(BusinessZoneID);
            });



        function bindState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
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
        function bindCategoryType() {
            jQuery('#<%=lstCategoryType.ClientID%> option').remove();
            jQuery('#lstCategoryType').multipleSelect("refresh");
            StoreCommonServices.bindcategory(onSucessCategoryType, onFailureCategoryType);
        }
        function onSucessCategoryType(result) {
            var categoryData = jQuery.parseJSON(result);
            for (i = 0; i < categoryData.length; i++) {
                jQuery('#<%=lstCategoryType.ClientID%>').append($("<option></option>").val(categoryData[i].ID).html(categoryData[i].Name));
            }
            jQuery('[id*=lstCategoryType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function onFailureCategoryType() {

        }
        jQuery('#lstCategoryType').on('change', function () {
            jQuery('#<%=lstItemType.ClientID%> option').remove();
            jQuery('#lstSubCategory').multipleSelect("refresh");
            var CategoryTypeID = $(this).val();
            bindSubCategory(CategoryTypeID);
        });
        function bindSubCategory(CategoryTypeID) {
            if (CategoryTypeID != "") {
                jQuery.ajax({
                    url: "Services/StoreCommonServices.asmx/bindsubcategory",
                    data: '{categoryid:"' + CategoryTypeID + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var subcategoryData = jQuery.parseJSON(result.d);
                        for (i = 0; i < subcategoryData.length; i++) {
                            jQuery("#lstSubCategory").append(jQuery("<option></option>").val(subcategoryData[i].ID).html(subcategoryData[i].Name));
                        }
                        jQuery('[id*=lstSubCategory]').multipleSelect({
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
        jQuery('#lstSubCategory').on('change', function () {
            jQuery('#<%=lstItemType.ClientID%> option').remove();
            jQuery('#lstItemType').multipleSelect("refresh");
            var SubCategoryID = $(this).val();
            bindItemType(SubCategoryID);
        });
        function bindItemType(SubCategoryID) {
            if (SubCategoryID != "") {
                jQuery.ajax({
                    url: "Services/StoreCommonServices.asmx/binditemtype",
                    data: '{subcategoryid:"' + SubCategoryID + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var ItemTypeData = jQuery.parseJSON(result.d);
                        for (i = 0; i < ItemTypeData.length; i++) {
                            jQuery("#lstItemType").append(jQuery("<option></option>").val(ItemTypeData[i].ID).html(ItemTypeData[i].Name));
                        }
                        jQuery('[id*=lstItemType]').multipleSelect({
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
        jQuery('#lstItemType').on('change', function () {
            jQuery('#<%=lstItemGroup.ClientID%> option').remove();
            jQuery('#lstItemGroup').multipleSelect("refresh");
            var ItemTypeID = $(this).val();
            bindItemGroup(ItemTypeID);
        });
        function bindItemGroup(ItemTypeID) {
            if (ItemTypeID != "") {
                jQuery.ajax({
                    url: "BudgetIndent.aspx/bindItemGroup",
                    data: '{SubcategoryID:"' + ItemTypeID + '" }',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var ItemGroupData = jQuery.parseJSON(result.d);
                        for (i = 0; i < ItemGroupData.length; i++) {
                            jQuery("#lstItemGroup").append(jQuery("<option></option>").val(ItemGroupData[i].ItemIDGroup).html(ItemGroupData[i].ItemNameGroup));
                        }
                        jQuery('[id*=lstItemGroup]').multipleSelect({
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
        function bindManufacture() {
            jQuery('#<%=lstManufacture.ClientID%> option').remove();
            jQuery('#lstManufacture').multipleSelect("refresh");
            StoreCommonServices.bindManufacture(onSucessManufacture, onFailureManufacture);
        }
        function onSucessManufacture(result) {
            var ManufactureData = jQuery.parseJSON(result);
            for (var a = 0; a <= ManufactureData.length - 1; a++) {
                jQuery('#<%=lstManufacture.ClientID%>').append($("<option></option>").val(ManufactureData[a].ID).html(ManufactureData[a].NAME));
        }
        jQuery('[id*=lstManufacture]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
    }
    function onFailureManufacture() {

    }
    function bindMachine() {
        jQuery('#<%=lstMachine.ClientID%> option').remove();
                jQuery('#lstMachine').multipleSelect("refresh");
                StoreCommonServices.bindmachine(onSucessMachine, onFailureMachine);
            }
            function onSucessMachine(result) {
                var MachineData = jQuery.parseJSON(result);
                for (var a = 0; a <= MachineData.length - 1; a++) {
                    jQuery('#lstMachine').append($("<option></option>").val(MachineData[a].ID).html(MachineData[a].NAME));
                }
                jQuery('[id*=lstMachine]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
            function onFailureMachine() {

            }
            function bindVendor() {
                jQuery('#<%=lstVendor.ClientID%> option').remove();
                jQuery('#lstVendor').multipleSelect("refresh");
                StoreCommonServices.bindsupplier(onSucessVendor, onFailureVendor);
            }
            function onSucessVendor(result) {
                var VendorData = jQuery.parseJSON(result);
                for (var a = 0; a <= VendorData.length - 1; a++) {
                    jQuery('#lstVendor').append($("<option></option>").val(VendorData[a].supplierid).html(VendorData[a].suppliername));
                }
                jQuery('[id*=lstVendor]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
            function onFailureVendor() {

            }
    </script>
        <script type="text/javascript">
            function showerrormsg(msg) {
                jQuery('#msgField').html('');
                jQuery('#msgField').append(msg);
                jQuery(".alert").css('background-color', 'red');
                jQuery(".alert").removeClass("in").show();
                jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
            }

            function showmsg(msg) {
                $('#msgField').html('');
                $('#msgField').append(msg);
                $(".alert").css('background-color', '#04b076');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(1000);
            }
            jQuery(function () {
                jQuery('#txtCity').bind("keydown", function (event) {
                    if (event.keyCode === jQuery.ui.keyCode.TAB &&
                        jQuery(this).autocomplete("instance").menu.active) {
                        event.preventDefault();
                    }
                    if (jQuery('#lstState').multipleSelect("getSelects").join() == "") {
                        showerrormsg("Please Select State");
                        jQuery('#lstState').focus();
                        jQuery('#txtCity').val('');
                        return;
                    }
                })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {
                              jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindCityWithState", {
                                  StateID: jQuery('#lstState').multipleSelect("getSelects").join(),
                                  CityName: request.term
                              }, response);
                          },
                          search: function () {
                              var term = this.value;
                              if (term.length < 3) {
                                  return false;
                              }
                          },
                          focus: function () {
                              return false;
                          },
                          select: function (event, ui) {
                              if (jQuery("#lstCity option[value='" + ui.item.value + "']").length == 0) {
                                  jQuery("#lstCity").append(jQuery("<option></option>").val(ui.item.value).html(ui.item.label));
                                  jQuery('#lstCity').find(":checkbox[value='" + ui.item.value + "']").attr("checked", "checked");
                                  jQuery("#lstCity option[value='" + ui.item.value + "']").attr("selected", 1);
                                  jQuery('#lstCity').multipleSelect("refresh");
                              }
                              else {
                                  showerrormsg("City Already Added");
                              }
                              jQuery('#txtCity').val('');
                              return false;
                          },
                      });
            });
    </script>
        <script type="text/javascript">
            function searchData(con) {

                $('#<%=txtWarranty.ClientID%>').val('');

                $('#<%=txtnfano.ClientID%>').val('');

                $('#<%=txttermandcondition.ClientID%>').val('');
            jQuery("#lblError").text('');          
            jQuery("#btnSearch").attr('disabled', 'disabled').val('Searching...');
           // if (con == 0)
             //   jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var CentreType = jQuery('#lstCentreType').multipleSelect("getSelects").join();
            var CategoryType = jQuery('#lstCategoryType').multipleSelect("getSelects").join();
            var Manufacture = jQuery('#lstManufacture').multipleSelect("getSelects").join();
            var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
            var SubCategory = jQuery('#lstSubCategory').multipleSelect("getSelects").join();
            var Machine = jQuery('#lstMachine').multipleSelect("getSelects").join();
            var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
            var ItemType = jQuery('#lstItemType').multipleSelect("getSelects").join();
            var ItemIDGroup = jQuery('#lstItemGroup').multipleSelect("getSelects").join();
            var CityID = jQuery('#lstCity').multipleSelect("getSelects").join();
            var VendorID = jQuery('#lstVendor').multipleSelect("getSelects").join();

            var Centre = jQuery('#lstCentre').multipleSelect("getSelects").join();
            var CentreLocation = jQuery('#lstlocation').multipleSelect("getSelects").join();
            var pendingpi = jQuery('#lstpendingpi').multipleSelect("getSelects").join();
            var itemcate = jQuery('#<%=ddlcategorytype.ClientID%>').val();
            jQuery.ajax({
                url: "POAgainstPI.aspx/bindData",
                data: '{ CentreType: "' + CentreType + '",CategoryType: "' + CategoryType + '",Manufacture: "' + Manufacture + '",ZoneID: "' + ZoneID + '",SubCategory: "' + SubCategory + '",Machine: "' + Machine + '",StateID: "' + StateID + '",ItemType: "' + ItemType + '",ItemIDGroup: "' + ItemIDGroup + '",FromDate: "' + jQuery('#txtFromDate').val() + '",ToDate: "' + jQuery('#txtToDate').val() + '",CityID: "' + CityID + '",VendorID:"' + VendorID + '",Centre:"' + Centre + '",CentreLocation:"' + CentreLocation + '",indentno:"' + $('#<%=txtindentnosearch.ClientID%>').val() + '",pendingpi:"' + pendingpi + '",itemcate:"' + itemcate + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        POData = jQuery.parseJSON(result.d);
                        var output = jQuery('#sc_PO').parseTemplate(POData);
                        jQuery('#div_PO').html(output);
                        jQuery("#div_PO,#btnSave,#btnUpdateRate").show();
                        jQuery("#tbl_PO").tableHeadFixer({
                        });
                    }

                    else {
                        jQuery("#lblError").text('No Record Found');
                        jQuery("#div_PO,#btnSave,#btnUpdateRate").hide();
                    }
                    jQuery("#btnSearch").removeAttr('disabled').val('Search');

                 //   jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    alert("Error ");
                   // jQuery.unblockUI();
                    jQuery("#btnSearch").removeAttr('disabled').val('Search');
                }
            });
        }
        function selectAll() {
            if ($(".clChkAll").is(':checked')) {
                $(".clChk").prop('checked', 'checked');
            }
            else {
                $(".clChk").prop('checked', false);
            }
        }
    </script>

    


     <script id="sc_PO" type="text/html" >      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbl_PO" style="border-collapse:collapse;width:1280px;"> 
            <thead>
		<tr id="Header">			
		    <td class="GridViewHeaderStyle" style="width: 34px; text-align: center">S.No.<input type="checkbox" onclick="selectAll()"   id="chkALL"  class="clChkAll" /></td>
            <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Indent No.</td>
            <td class="GridViewHeaderStyle" style="width: 160px; text-align: center;cursor:pointer;" onclick="sortTable(2)" >Supplier Name &nbsp;<img src="../../App_Images/down_arrow.png" /></td>          
            <td class="GridViewHeaderStyle" style="width: 160px; text-align: center;cursor:pointer;" onclick="sortTable(3)">Location  &nbsp;<img src="../../App_Images/down_arrow.png" /></td>
            <td class="GridViewHeaderStyle" style="font-weight:bold; text-align: left">ItemID</td>
            <td class="GridViewHeaderStyle" style="width: 180px; text-align: center;cursor:pointer;" onclick="sortTable(4)">Item Name  &nbsp;<img src="../../App_Images/down_arrow.png" /></td>           
            <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Manufacture</td>
            <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">PackSize</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">PurchaseUnit</td>   
              <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Narration</td>         
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Rate</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Disc(%)</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Tax(%)</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">UnitPrice</td>            
            <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Qty.</td>
            <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">NetAmt.</td>
            <td class="GridViewHeaderStyle" style="width: 40px; text-align: center" title="Update New Rate">#</td>
             <td class="GridViewHeaderStyle" style="width: 25px; text-align: center" title="Change Supplier">#</td>
             <td class="GridViewHeaderStyle" style="width: 25px; text-align: center" title="Reject Indent Item">#</td>
        </tr>
                </thead>            
            <tbody>
       <#      
              var dataLength=POData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = POData[j];
                 #>       
           <# if(objRow.VendorID!=objRow.newvendorid || objRow.Rate!= objRow.newrate)
            {#>
            <tr id="trID<#=j+1#>" style="background-color:pink;">  
            <#}
            else
            {
            #>
            <tr id="trID<#=j+1#>" style="background-color:white;">  
            <#}#>
                 
            <td class="GridViewLabItemStyle" id="tdID"><#=j+1#><input type="checkbox" id="chk"  class="clChk" /> </td>  
            <td  class="GridViewLabItemStyle" id="tdIndentNo" style="text-align:left;"><#=objRow.IndentNo#></td>                                     
            <td  class="GridViewLabItemStyle" id="tdSupplierName" style="text-align:left;"><#=objRow.SupplierName#></td>
            <td  class="GridViewLabItemStyle" id="td1" style="text-align:left;"><#=objRow.Location#></td>   
                <td  class="GridViewLabItemStyle" id="td2" style="text-align:left;font-weight:bold;"><#=objRow.ItemID#></td>   
                
                <# if(objRow.rejectby!=0)
                {
                 #>      
            <td  class="GridViewLabItemStyle" id="tdItemName" style="text-align:left;background-color:yellow;"><#=objRow.ItemName#></td>     
                
                <#}
                else
                {
                #>
                 <td  class="GridViewLabItemStyle" id="tdItemName" style="text-align:left;"><#=objRow.ItemName#></td>     
                <#}#>             
            <td  class="GridViewLabItemStyle" id="tdManufacture"  style="text-align:left;"><#=objRow.Manufacture#></td>                  
            <td  class="GridViewLabItemStyle" id="tdPackSize" style="text-align:left;"><#=objRow.PackSize#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.PurchaseUnit#></td>      
                <td  class="GridViewLabItemStyle" style="text-align:left;" title="<#=objRow.Narration#>"><#=objRow.NarrationDisplay#></td>      
            <td  class="GridViewLabItemStyle" id="tdRate" style="text-align:right;"><#=objRow.Rate#></td>
            <td  class="GridViewLabItemStyle" id="tdDiscountPer" style="text-align:right;"><#=objRow.DiscountPer#></td>
            <td  class="GridViewLabItemStyle" id="tdTaxPer" style="text-align:right;"><#=objRow.TaxPer#></td>
            <td  class="GridViewLabItemStyle" id="tdUnitPrice" style="text-align:right;"><#=objRow.UnitPrice#></td> 
            <td  class="GridViewLabItemStyle" id="tdQty" style="text-align:right;"><input type="text" id="txtQty" style="width:60px;text-align:right" onkeyup="chkQty(this)" onkeypress='return checkForSecondDecimal(this,event);' value='<#=objRow.ApprovedQty#>' /></td>
            <td  class="GridViewLabItemStyle" id="tdNetAmount" style="text-align:right;"><span id="spnNetAmt"> <#=objRow.NetAmount#></span></td>

                <td class="GridViewLabItemStyle" style="text-align:center;">
                 <# if(objRow.VendorID!=objRow.newvendorid || objRow.Rate!= objRow.newrate)
            {#>
           <input type="checkbox" id="chupdaterate" checked="checked" class="clChk" title="Update New Rate" /><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="shownewdata(this)" />
            <#}#>
 </td>
                    <td class="GridViewLabItemStyle" style="text-align:center;">

                             <% if(Util.GetString(Request.QueryString["ActionType"])=="")
{%>
          
                 <img src="../../App_Images/Collected.png" style="cursor:pointer" title="Change Supplier" onclick="openvendorchanger(this)" />


                        <%} %>
                   
           

</td>

                <td class="GridViewLabItemStyle" style="text-align:center;">
                    <img src="../../App_Images/Delete.gif" style="cursor:pointer;" title="Reject Item" onclick="rejectme(this)" />
                </td>
                

            <td  class="GridViewLabItemStyle" id="tdManufactureID" style="text-align:right;display:none"><#=objRow.ManufactureID#></td>
            <td  class="GridViewLabItemStyle" id="tdMachineID" style="text-align:right;display:none"><#=objRow.MachineID#></td>
            <td  class="GridViewLabItemStyle" id="tdItemID" style="text-align:right;display:none"><#=objRow.ItemID#></td>    
            <td  class="GridViewLabItemStyle" id="tdFromLocationID" style="text-align:right;display:none"><#=objRow.FromLocationID#></td>
            <td  class="GridViewLabItemStyle" id="tdCatalogNo" style="text-align:right;display:none"><#=objRow.CatalogNo#></td>
            <td  class="GridViewLabItemStyle" id="tdMajorUnitId" style="text-align:right;display:none"><#=objRow.MajorUnitId#></td>
            <td  class="GridViewLabItemStyle" id="tdMajorUnitName" style="text-align:right;display:none"><#=objRow.MajorUnitName#></td>                             
            <td  class="GridViewLabItemStyle" id="tdVendorID" style="text-align:right;display:none"><#=objRow.VendorID#></td>
            <td  class="GridViewLabItemStyle" id="tdIsLoginRequired" style="text-align:right;display:none"><#=objRow.IsLoginRequired#></td>
            <td  class="GridViewLabItemStyle" id="tdVendorStateId" style="text-align:right;display:none"><#=objRow.VendorStateId#></td>
            <td  class="GridViewLabItemStyle" id="tdVednorStateGstnno" style="text-align:right;display:none"><#=objRow.VednorStateGstnno#></td>
            <td  class="GridViewLabItemStyle" id="tdVednorAddress" style="text-align:right;display:none"><#=objRow.SupplierAddress#></td>
            <td  class="GridViewLabItemStyle" id="tdDiscAmt" style="text-align:right;display:none"><#=objRow.DiscAmt#></td>            
            <td  class="GridViewLabItemStyle" id="tdTaxPerCGST" style="text-align:right;display:none"><#=objRow.TaxPerCGST#></td>
            <td  class="GridViewLabItemStyle" id="tdTaxPerIGST" style="text-align:right;display:none"><#=objRow.TaxPerIGST#></td>
            <td  class="GridViewLabItemStyle" id="tdTaxPerSGST" style="text-align:right;display:none"><#=objRow.TaxPerSGST#></td>  
            <td  class="GridViewLabItemStyle" id="tdMajorUnitInDecimal" style="text-align:right;display:none"><#=objRow.MajorUnitInDecimal#></td>   
            <td  class="GridViewLabItemStyle" id="tdApprovedQty" style="text-align:right;display:none"><#=objRow.ApprovedQty#></td>  
                
                <td  class="GridViewLabItemStyle" id="tdRateNew" style="text-align:right;display:none"><#=objRow.newrate#></td>  
                <td  class="GridViewLabItemStyle" id="tdSupplierNameNew" style="text-align:right;display:none"><#=objRow.SupplierNameNew#></td>  
                
                 <td  class="GridViewLabItemStyle" id="tdDiscountPerNew" style="text-align:right;display:none"><#=objRow.discountpernew#></td>  
                <td  class="GridViewLabItemStyle" id="tdTaxPerNew" style="text-align:right;display:none"><#=objRow.taxpernew#></td>  
                 <td  class="GridViewLabItemStyle" id="tdUnitPriceNew" style="text-align:right;display:none"><#=objRow.unitpricenew#></td>  
                <# var net=objRow.unitpricenew*objRow.ApprovedQty;#>
                <td  class="GridViewLabItemStyle" id="tdNetAmountNew" style="text-align:right;display:none"><#=net#></td>  
                
                
                 
            </tr>                  
      <#}#>
            </tbody>
        </table>    
    </script> 
    <script type="text/javascript">
        var DigitsAfterDecimal = 5;
        function chkQty(rowID) {
            jQuery(rowID).closest('tr').css("background-color", "transparent");;
            if (parseFloat(jQuery(rowID).closest('tr').find("#txtQty").val()) > parseFloat(jQuery(rowID).closest('tr').find("#tdApprovedQty").text())) {
                jQuery(rowID).closest('tr').find("#txtQty").val(jQuery(rowID).closest('tr').find("#tdApprovedQty").text());
                showerrormsg("Qty Can Not Greater then Approved Qty");

            }
            var QtyValue = jQuery(rowID).closest('tr').find("#txtQty").val();
            var valIndex = QtyValue.indexOf(".");
            if (valIndex > "0") {
                if (QtyValue.length - (QtyValue.indexOf(".") + 1) > DigitsAfterDecimal) {
                    showerrormsg("Please Enter Valid Discount Percent, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                    jQuery(rowID).closest('tr').find("#txtQty").val(jQuery(rowID).closest('tr').find("#txtQty").val().substring(0, (jQuery(rowID).closest('tr').find("#txtQty").val().length - 1)))
                    return false;
                }
            }
            var Qty = jQuery(rowID).closest('tr').find("#txtQty").val();
            if (isNaN(Qty) || Qty == "")
                Qty = 0;
            jQuery(rowID).closest('tr').find("#spnNetAmt").text(parseFloat(Qty) * parseFloat(jQuery(rowID).closest('tr').find("#tdUnitPrice").text()));
        }
        function savePurchaseOrder() {
            
            jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
           // jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            var resultPurchaseOrder = POMaster(); 

            if (resultPurchaseOrder.chkData.length > 0) {
                jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + resultPurchaseOrder.chkData);
                jQuery.each(resultPurchaseOrder.chkData, function (index, value) {
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').find('#txtQty').focus();
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').css("background-color", "#FF0000");
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').attr('title', 'Please Enter Valid Qty.');
                });
            }
            if (resultPurchaseOrder.chkData.length > 0) {
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');
                //jQuery.unblockUI();
                return;
            }
            if (resultPurchaseOrder.dataPOMaster.length == 0) {
               // showerrormsg("Please Check Item");
                toast("Error", "Please Check Item", "");
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');
                //jQuery.unblockUI();
                return;
            }

            var term = ""; 
            if ($('#<%=ddlpaymentterm.ClientID%> option:selected').text() == "Other") {
                term = $('#<%=txtpaymentterm.ClientID%>').val();
            }
            else {
                term = $('#<%=ddlpaymentterm.ClientID%> option:selected').text();
            }

            var termID = $('#<%=ddlpaymentterm.ClientID%>').val();


            if (term == "") {
                //jQuery.unblockUI();
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');
               // showerrormsg("Please Enter or Select Payment Term");
                toast("Error", "Please Enter or Select Payment Term", "");
                return;
            }
            var deliveryterm = "";
            if ($('#<%=ddldeliveryterm.ClientID%> option:selected').text() == "Other") {
                deliveryterm = $('#<%=txtdeliveryterm.ClientID%>').val();
             }
             else {
                deliveryterm = $('#<%=ddldeliveryterm.ClientID%> option:selected').text();
            }
            var deliverytermID = $('#<%=ddldeliveryterm.ClientID%>').val();

            if (deliveryterm == "") {
                //jQuery.unblockUI();
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');
               // showerrormsg("Please Enter or Select Delivery  Term");
                toast("Error", "Please Enter or Select Delivery  Term", "");
                return;
            }


            jQuery.ajax({
                url: "POAgainstPI.aspx/savePurchaseOrder",
                data: JSON.stringify({ POMaster: resultPurchaseOrder.dataPOMaster, term: term, deliveryterm: deliveryterm, termID: termID, deliverytermID: deliverytermID }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        toast("Info", "Please Enter or Select Delivery  Term", "");
                       // showmsg("Record Saved Successfully");
                        searchData('1');
                    }
                    else if (result.d == "2" || result.d == "0") {
                        showerrormsg("Error...");
                    }
                    else {
                       var POReturnData = jQuery.parseJSON(result.d);
                     
                       if (POReturnData.hasOwnProperty("QtyValidation")) {
                           jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + POReturnData.QtyValidation.split('#')[0]);
                           for (var i in POReturnData.QtyValidation) {
                               jQuery('#tbl_PO tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().find('#txtQty').focus();
                               jQuery('#tbl_PO tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().css("background-color", "#FF0000");
                               jQuery('#tbl_PO tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().attr('title', 'Please Enter Valid Qty.');
                           }

                       }
                       else {
                           jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + POReturnData.ApprovedValidation.TableTrNo);

                           jQuery('table#tbl_PO tr#trID' + POReturnData.ApprovedValidation.TableTrNo).css("background-color", "#FF0000");
                           jQuery('table#tbl_PO tr#trID' + POReturnData.ApprovedValidation.TableTrNo).attr('title', 'Qty. is not greater then ' + POReturnData.ApprovedValidation.Qty);

                          // jQuery('table#tbl_PO tr').find('#' + POReturnData.ApprovedValidation.TableNo).css("background-color", "#FF0000");
                         //  jQuery('table#tbl_PO tr').find('#' + POReturnData.ApprovedValidation.TableNo).attr('title', 'Please Enter Valid Qty.' + POReturnData.ApprovedValidation.TableNo);

                           //jQuery('#tbl_PO tbody tr:eq(' + POReturnData.ApprovedValidation.TableNo + ')').next().find('#txtQty').focus();
                           //jQuery('#tbl_PO tbody tr:eq(' + POReturnData.ApprovedValidation.TableNo + ')').next().css("background-color", "#FF0000");
                           //jQuery('#tbl_PO tbody tr:eq(' + POReturnData.ApprovedValidation.TableNo + ')').next().attr('title', 'Please Enter Valid Qty.' + POReturnData.ApprovedValidation.TableNo);


                       }
                       
                    }
                    jQuery("#btnSave").removeAttr('disabled').val('Make PO');
                    //jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    //jQuery.unblockUI();
                }
            });
        }
        function POMaster() {
            var dataPOMaster = new Array();
            var objPOMaster = new Object();
            var chkData = [];
            jQuery("#tbl_PO tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");

                    if (id != "Header") {
                        if ($rowid.find("#chk").is(':checked')) {
                            var ItemData = [];
                            
                            if (jQuery.trim($rowid.find("#txtQty").val()) == "") {
                                $rowid.find("#txtQty").focus();
                                ItemData[0] = jQuery.trim(jQuery(this).find('#tdID').text());
                                chkData.push(ItemData);
                                return "";
                            }
                            objPOMaster.PurchaseOrderNo = jQuery("#lblPurchaseOrderNo").text();
                            if (jQuery("#lblPurchaseOrderID").text() != "")
                                objPOMaster.PurchaseOrderID = jQuery("#lblPurchaseOrderID").text();
                            else
                                objPOMaster.PurchaseOrderID = 0;
                            objPOMaster.tableSNo =  jQuery.trim($rowid.find("#tdID").text());
                            objPOMaster.Subject = "";
                            objPOMaster.VendorID = jQuery.trim($rowid.find("#tdVendorID").text());
                            objPOMaster.VendorName = jQuery.trim($rowid.find("#tdSupplierName").text());
                            objPOMaster.LocationID = jQuery.trim($rowid.find("#tdFromLocationID").text());
                            objPOMaster.IndentNo = jQuery.trim($rowid.find("#tdIndentNo").text());
                            objPOMaster.VendorStateId = jQuery.trim($rowid.find("#tdVendorStateId").text());
                            objPOMaster.VendorGSTIN = jQuery.trim($rowid.find("#tdVednorStateGstnno").text());
                            objPOMaster.VendorAddress = jQuery.trim($rowid.find("#tdVednorAddress").text());
                            objPOMaster.VendorLogin = jQuery.trim($rowid.find("#tdIsLoginRequired").text());

                            objPOMaster.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                            objPOMaster.ManufactureID = jQuery.trim($rowid.find("#tdManufactureID").text());
                            objPOMaster.ManufactureName = jQuery.trim($rowid.find("#tdManufacture").text());
                            objPOMaster.CatalogNo = jQuery.trim($rowid.find("#tdCatalogNo").text());
                            objPOMaster.MachineID = jQuery.trim($rowid.find("#tdMachineID").text());
                            objPOMaster.MachineName = jQuery.trim($rowid.find("#tdMachineName").text());
                            objPOMaster.MajorUnitId = jQuery.trim($rowid.find("#tdMajorUnitId").text());
                            objPOMaster.MajorUnitName = jQuery.trim($rowid.find("#tdMajorUnitName").text());
                            objPOMaster.PackSize = jQuery.trim($rowid.find("#tdPackSize").text());


                            objPOMaster.ItemName = jQuery.trim($rowid.find("#tdItemName").text());
                            if (jQuery.trim($rowid.find("#txtQty").val()) != "")
                                objPOMaster.OrderedQty = jQuery.trim($rowid.find("#txtQty").val());
                            else
                                objPOMaster.OrderedQty = 0;
                            objPOMaster.Rate = jQuery.trim($rowid.find("#tdRate").text());
                           
                            objPOMaster.DiscountAmount = jQuery.trim($rowid.find("#tdDiscAmt").text());
                            objPOMaster.DiscountPercentage = jQuery.trim($rowid.find("#tdDiscountPer").text());
                            objPOMaster.NetAmount = jQuery.trim($rowid.find("#tdNetAmount").text());
                            objPOMaster.UnitPrice = jQuery.trim($rowid.find("#tdUnitPrice").text());

                            objPOMaster.TaxPerCGST = jQuery.trim($rowid.find("#tdTaxPerCGST").text());
                            objPOMaster.TaxPerIGST = jQuery.trim($rowid.find("#tdTaxPerIGST").text());
                            objPOMaster.TaxPerSGST = jQuery.trim($rowid.find("#tdTaxPerSGST").text());
                            objPOMaster.TaxPer = jQuery.trim($rowid.find("#tdTaxPer").text());
                            
                            
                          
                            objPOMaster.POType = "Normal";

                            objPOMaster.Warranty = $('#<%=txtWarranty.ClientID%>').val();
                            objPOMaster.NFANo = $('#<%=txtnfano.ClientID%>').val();
                            objPOMaster.Termandcondition = $('#<%=txttermandcondition.ClientID%>').val();

                            objPOMaster.IsFree = "0";
                            dataPOMaster.push(objPOMaster);
                            objPOMaster = new Object();
                        }
                    }
            });
            return {
                chkData: chkData,
                dataPOMaster: dataPOMaster
            };
           
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            else {
                if ((charCode != 46 && sender.value.indexOf('.') != -1) && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            if (charCode == '46' && jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                return false;
            }
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function accessRight() {
            jQuery('#btnSearch').hide();
        }
    </script>


    <script type="text/javascript">


        function openmypopup(href) {
            var width = '900px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }


        function ViewMe() {

            openmypopup("PoView.aspx?POID=" + jQuery("#lblPurchaseOrderID").text());
         
        }


        function MakeAction(ButtonActionType) {

            if (ButtonActionType == "Check")
                jQuery("#btnCheck").attr('disabled', 'disabled').val('Submitting...');
            else
                jQuery("#btnApproval").attr('disabled', 'disabled').val('Submitting...');
            //jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            var resultPurchaseOrder = POMaster();

            if (resultPurchaseOrder.chkData.length > 0) {
                jQuery("#lblError").text('Please Enter Valid Qty. In S.No. 1 ' + resultPurchaseOrder.chkData);
                jQuery.each(resultPurchaseOrder.chkData, function (index, value) {
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').find('#txtQty').focus();
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').css("background-color", "#FF0000");
                    jQuery('#tbl_PO tbody tr:eq(' + (value - 1) + ')').attr('title', 'Please Enter Valid Qty.');
                });
            }

           
            if (resultPurchaseOrder.chkData.length > 0) {
                if (ButtonActionType == "Check")
                    jQuery("#btnCheck").removeAttr('disabled').val('Check');
                else
                    jQuery("#btnApproval").removeAttr('disabled').val('Approve');
                //jQuery.unblockUI();
                return;
            }
            if (resultPurchaseOrder.dataPOMaster.length == 0) {
                showerrormsg("Please Check Item");
                if (ButtonActionType == "Check")
                    jQuery("#btnCheck").removeAttr('disabled').val('Check');
                else
                    jQuery("#btnApproval").removeAttr('disabled').val('Approve');
                //jQuery.unblockUI();
                return;
            }
            
            var term = ""; 
            if ($('#<%=ddlpaymentterm.ClientID%> option:selected').text() == "Other") 
                term = $('#<%=txtpaymentterm.ClientID%>').val();
            else
                term = $('#<%=ddlpaymentterm.ClientID%> option:selected').text();

            var termID = $('#<%=ddlpaymentterm.ClientID%>').val();


            
            var deliveryterm = "";
            if ($('#<%=ddldeliveryterm.ClientID%> option:selected').text() == "Other") 
                deliveryterm = $('#<%=txtdeliveryterm.ClientID%>').val();
            else 
                deliveryterm = $('#<%=ddldeliveryterm.ClientID%> option:selected').text();

            var deliverytermID = $('#<%=ddldeliveryterm.ClientID%>').val();
            
            jQuery.ajax({
                url: "POAgainstPI.aspx/MakeAction",
                data: JSON.stringify({ POMaster: resultPurchaseOrder.dataPOMaster, ButtonActionType: ButtonActionType, Term: term, TermID: termID, Deliveryterm: deliveryterm, DeliverytermID: deliverytermID }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var res = result.d.split('#')[0];
                    if (res == "1") {
                        toast("Info",'Purchase Order ' + ButtonActionType + ' Successfully', "");
                     //   showmsg('Purchase Order ' + ButtonActionType + ' Successfully');
                        location.reload(true);
                    }
                    else if (res == "2") {
                        showerrormsg("Already Checked");
                    }
                    else if (res == "3") {
                        showerrormsg("Already Approved");
                    }
                    else if (res == "4") {
                        showerrormsg('You Did not Have Any Right To ' + ButtonActionType + ' Purchase Order');
                    }
                    else if (res == "0") {
                        showerrormsg(result.d.split('#')[1]);
                    }
                   
                    else {
                        var POReturnData = jQuery.parseJSON(result.d);

                        if (POReturnData.hasOwnProperty("QtyValidation")) {
                            jQuery("#lblError").text('Please Enter Valid Qty. In S.No.' + POReturnData.QtyValidation);
                            for (var i in POReturnData.QtyValidation) {
                                jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().find('#txtQuantity').focus();
                                jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().css("background-color", "#FF0000");
                                jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().attr('title', 'Please Enter Valid Qty.');
                            }
                        }
                        else {

                        }
                    }

                   
                    if (ButtonActionType == "Check")
                        jQuery("#btnCheck").removeAttr('disabled').val('Check');
                    else
                        jQuery("#btnApproval").removeAttr('disabled').val('Approve');

               //     jQuery.unblockUI();
                },
                error: function (xhr, status) {

                   
                //    jQuery.unblockUI();
                    if (ButtonActionType == "Check")
                        jQuery("#btnCheck").removeAttr('disabled').val('Check');
                    else
                        jQuery("#btnApproval").removeAttr('disabled').val('Approve');
                }
            });
        }
    </script>

    <script type="text/javascript">
        function sortTable(n) {
            var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
            table = document.getElementById("tbl_PO");
            switching = true;
            // Set the sorting direction to ascending:
            dir = "asc";
            /* Make a loop that will continue until
            no switching has been done: */
            while (switching) {
                // Start by saying: no switching is done:
                switching = false;
                rows = table.getElementsByTagName("tr");
                /* Loop through all table rows (except the
                first, which contains table headers): */
                for (i = 1; i < (rows.length - 1) ; i++) {
                    // Start by saying there should be no switching:
                    shouldSwitch = false;
                    /* Get the two elements you want to compare,
                    one from current row and one from the next: */
                    x = rows[i].getElementsByTagName("td")[n];
                    y = rows[i + 1].getElementsByTagName("td")[n];
                    /* Check if the two rows should switch place,
                    based on the direction, asc or desc: */
                    if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                            // If so, mark as a switch and break the loop:
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                            // If so, mark as a switch and break the loop:
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
                if (shouldSwitch) {
                    /* If a switch has been marked, make the switch
                    and mark that a switch has been done: */
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    // Each time a switch is done, increase this count by 1:
                    switchcount++;
                } else {
                    /* If no switching has been done AND the direction is "asc",
                    set the direction to "desc" and run the while loop again. */
                    if (switchcount == 0 && dir == "asc") {
                        dir = "desc";
                        switching = true;
                    }
                }
            }
        }

        function updatenewrate() {
            var dataIm = new Array();
            $('#tbl_PO tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "Header") {

                    if ($(this).closest("tr").find('#chupdaterate').prop('checked') == true) {
                        var objUpdateDate = new Object();
                        objUpdateDate.IndentNo = $(this).closest("tr").find('#tdIndentNo').html();
                        objUpdateDate.ItemID = $(this).closest("tr").find('#tdItemID').html();
                        objUpdateDate.FromLocationID = $(this).closest("tr").find('#tdFromLocationID').html();
                        objUpdateDate.Qty = $(this).closest("tr").find('#tdApprovedQty').html();
                        objUpdateDate.OldvendorID = $(this).closest("tr").find('#tdVendorID').html();
                        objUpdateDate.VendorStateId = $(this).closest("tr").find('#tdVendorStateId').html();
                        objUpdateDate.VednorStateGstnno = $(this).closest("tr").find('#tdVednorStateGstnno').html();
                        objUpdateDate.Rate = $(this).closest("tr").find('#tdRate').html();
                        objUpdateDate.DiscountPer = $(this).closest("tr").find('#tdDiscountPer').html();
                        objUpdateDate.TaxPerIGST = $(this).closest("tr").find('#tdTaxPerIGST').html();
                        objUpdateDate.TaxPerCGST = $(this).closest("tr").find('#tdTaxPerCGST').html();
                        objUpdateDate.TaxPerSGST = $(this).closest("tr").find('#tdTaxPerSGST').html();
                        objUpdateDate.UnitPrice = $(this).closest("tr").find('#tdUnitPrice').html();
                        objUpdateDate.NetAmount = $(this).closest("tr").find('#spnNetAmt').html();                         
                        dataIm.push(objUpdateDate);
                    }
                }
            });


            if (dataIm.length == 0) {
                showerrormsg("Please Select Record.");
                return;
            }


         //   $.blockUI();

            $.ajax({
                url: "POAgainstPI.aspx/UpdateNewRate",
                data: JSON.stringify({ UpdateData: dataIm }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                //    $.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                         toast("Info",'Rate Updated', "");
                       // showmsg("Rate Updated");
                      
                        searchData(0);

                    }
                    else {
                        showerrormsg(save);
                    
                    }
                },
                error: function (xhr, status) {
                //    $.unblockUI();
                    showerrormsg("Some Error Occure Please Try Again..!");
                  
                }
            });


        }


        function shownewdata(ctrl) {
            $('#newtable tr').slice(1).remove();
            var mydata = "<tr style='background-color:white;height:35px;'>";
            mydata += '<td >Old Data</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdSupplierName").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdRate").html() + '</td>';

            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdDiscountPer").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdTaxPer").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdUnitPrice").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdNetAmount").html() + '</td>';

            mydata += "<tr style='background-color:pink;height:35px;'>";
            mydata += '<td >New Data</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdSupplierNameNew").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdRateNew").html() + '</td>';

            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdDiscountPerNew").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdTaxPerNew").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdUnitPriceNew").html() + '</td>';
            mydata += '<td  >' + $(ctrl).closest('tr').find("#tdNetAmountNew").html() + '</td>';

            $('#newtable').append(mydata);

            $('#newtable').show();
            $('#newtable1').hide();
            $find("<%=modelpopup1.ClientID%>").show();
        }

        function bindvendor(locationid, itemid,vendorid,indentno,qty) {

            $('#newtable1 tr').slice(1).remove();
         //   $.blockUI();

            $.ajax({
                url: "POAgainstPI.aspx/BindVendorwithrate",
                data: '{locationid: "' + locationid + '",itemid: "' + itemid + '",vendorid:"' + vendorid + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    
                    PanelData = $.parseJSON(result.d);



                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var mydata = "<tr style='background-color:" + PanelData[i].Rowcolor + ";' id='" + PanelData[i].vendorid + "'>";
                        mydata += '<td>' + parseInt(i + 1) + '</td>';
                       
                            mydata += '<td><input type="button" value="Select" style="font-weight:bold;cursor:pointer;" onclick="setnewvendor(this)"/></td>';
                        
                                
                        mydata += '<td>' + PanelData[i].vendorname + '</td>';
                        mydata += '<td>' + PanelData[i].itemname + '</td>';
                        mydata += '<td id="tdrate">' + PanelData[i].rate + '</td>';
                        mydata += '<td id="tddiscper">' + PanelData[i].DiscountPer + '</td>';
                        mydata += '<td id="tdigstper">' + PanelData[i].IGSTPer + '</td>';
                        mydata += '<td id="tdsgstper">' + PanelData[i].SGSTPer + '</td>';
                        mydata += '<td id="tdcgstper">' + PanelData[i].CGSTPer + '</td>';
                        mydata += '<td  id="tditemid" style="display:none;">' + PanelData[i].itemid + '</td>';
                        mydata += '<td  id="tdvendorid" style="display:none;">' + PanelData[i].vendorid + '</td>';
                        mydata += '<td  id="tdindentno" style="display:none;">' + indentno + '</td>';
                        mydata += '<td  id="tdqty" style="display:none;">' + qty + '</td>';
                        mydata += '<td  id="tdVednorStateGstnno" style="display:none;">' + PanelData[i].VednorStateGstnno + '</td>';
                        mydata += '<td  id="tdVendorStateId" style="display:none;">' + PanelData[i].VendorStateId + '</td>';
                        mydata += '<td  id="tdlocationid" style="display:none;">' + locationid + '</td>';
                        mydata += '<td  id="tdUnitPrice" style="display:none;">' + PanelData[i].BuyPrice + '</td>';
                        
                        
                        mydata += '</tr>';

                        $('#newtable1').append(mydata);
                    }
                    
                //    $.unblockUI();
                },
                error: function (xhr, status) {
                //    $.unblockUI();
                    showerrormsg("Some Error Occure Please Try Again..!");

                }
            });

        }

        function openvendorchanger(ctrl) {
            $('#newtable tr').slice(1).remove();
            $('#newtable').hide();
            $('#newtable1').show();
          


            bindvendor($(ctrl).closest('tr').find("#tdFromLocationID").html(), $(ctrl).closest('tr').find("#tdItemID").html(), $(ctrl).closest('tr').find("#tdVendorID").html(), $(ctrl).closest('tr').find("#tdIndentNo").html(), $(ctrl).closest('tr').find("#tdApprovedQty").html());

            $find("<%=modelpopup1.ClientID%>").show();
        }
        

        function setpaymentterm() {
            if ($('#<%=ddlpaymentterm.ClientID%> option:selected').text() == "Other") {
                $('#<%=txtpaymentterm.ClientID%>').show();
            }
            else {
                $('#<%=txtpaymentterm.ClientID%>').hide();
            }
        }

        function setdeliveryterm() {
            if ($('#<%=ddldeliveryterm.ClientID%> option:selected').text() == "Other") {
                $('#<%=txtdeliveryterm.ClientID%>').show();
             }
             else {
                 $('#<%=txtdeliveryterm.ClientID%>').hide();
             }
        }

        function showhide() {

            $('.t1').slideToggle("fast");
        }


       



        function setnewvendor(ctrl) {
            if (confirm("Do You Want To Change Supplier.?")) {
                var objUpdateDate = new Object();
                objUpdateDate.IndentNo = $(ctrl).closest("tr").find('#tdindentno').html();
                objUpdateDate.ItemID = $(ctrl).closest("tr").find('#tditemid').html();
                objUpdateDate.FromLocationID = $(ctrl).closest("tr").find('#tdlocationid').html();
                objUpdateDate.Qty = $(ctrl).closest("tr").find('#tdqty').html();
                objUpdateDate.OldvendorID = $(ctrl).closest("tr").find('#tdvendorid').html();
                objUpdateDate.VendorStateId = $(ctrl).closest("tr").find('#tdVendorStateId').html();
                objUpdateDate.VednorStateGstnno = $(ctrl).closest("tr").find('#tdVednorStateGstnno').html();
                objUpdateDate.UnitPrice = $(ctrl).closest("tr").find('#tdUnitPrice').html();
                
                objUpdateDate.Rate = $(ctrl).closest("tr").find('#tdrate').html();
                objUpdateDate.DiscountPer = $(ctrl).closest("tr").find('#tddiscper').html();
                objUpdateDate.TaxPerIGST = $(ctrl).closest("tr").find('#tdigstper').html();
                objUpdateDate.TaxPerCGST = $(ctrl).closest("tr").find('#tdcgstper').html();
                objUpdateDate.TaxPerSGST = $(ctrl).closest("tr").find('#tdsgstper').html();
               



            //    $.blockUI();

                $.ajax({
                    url: "POAgainstPI.aspx/UpdateNewRateWithVendor",
                    data: JSON.stringify({ UpdateData: objUpdateDate }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                   //     $.unblockUI();
                        var save = result.d;
                        if (save == "1") {
                            toast("Info",'Supplier Changed', "");
                          //  showmsg("Supplier Changed");
                            $find("<%=modelpopup1.ClientID%>").hide();
                            searchData(0);

                        }
                        else {
                            showerrormsg(save);

                        }
                    },
                    error: function (xhr, status) {
                     //   $.unblockUI();
                       // showerrormsg("Some Error Occure Please Try Again..!");
                          toast("Error",'Some Error Occure Please Try Again..!', "");

                    }
                });
            }

        }
        
     
        function rejectme(ctrl) {

            if (confirm("Do You Want To Reject This Item.?")) {

            //    $.blockUI();

                $.ajax({
                    url: "POAgainstPI.aspx/RejectItem",
                    data: '{indentno: "' + $(ctrl).closest('tr').find("#tdIndentNo").html() + '",itemid: "' + $(ctrl).closest('tr').find("#tdItemID").html() + '",ActionType:"<%=Request.QueryString["ActionType"]%>",POID:"<%=Request.QueryString["POID"]%>"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                     //   $.unblockUI();
                        var save = result.d;
                        if (save == "1") {

                           // showmsg("Item Rejected");
                            toast("Info",'Item Rejected', "")
                            searchData(0);

                        }
                        else {
                            showerrormsg(save);

                        }
                    },
                    error: function (xhr, status) {
                    //    $.unblockUI();
                        showerrormsg("Some Error Occur Please Try Again..!");

                    }
                });
            }
        }

    </script>
    <script type="text/javascript">
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function bindpendingpi() {

            var locationid = jQuery('#lstlocation').val();
           
            jQuery('#<%=lstpendingpi.ClientID%> option').remove();
            jQuery('#lstpendingpi').multipleSelect("refresh");
            if (locationid != "") {
                jQuery.ajax({
                    url: "POAgainstPI.aspx/bindpendingpi",
                    data: '{locationid:"' + locationid + '"}',
                    type: "POST",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var centreData = jQuery.parseJSON(result.d);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#lstpendingpi").append(jQuery("<option></option>").val(centreData[i].indentno).html(centreData[i].indentno));
                        }
                        $('[id*=lstpendingpi]').multipleSelect({
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
</asp:Content>

