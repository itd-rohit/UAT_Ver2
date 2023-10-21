<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InTransitAdjustmentReport.aspx.cs" Inherits="Design_Store_InTransitAdjustmentReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">

         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Stock InTransit Adjustment Report</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">Location Details</div>
                 <table width="99%">
                                       
                                        <tr>
                                            <td >CentreType:&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                            </td>


                                            <td >Zone :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                                            </td>



                                        </tr>
                                        <tr>
                                            <td >State :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                                            </td>


                                            <td >City :</td>
                                            <td>
                                                <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                            </td>
                                        </tr>


                                        <tr>
                                            <td >Centre :</td>
                                            <td>
                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                                            </td>


                                            <td class="required">Location :</td>
                                            <td>
                                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>
                                        </tr>


                                    </table>
                    
               </div>
              </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">
                      Item Detail</div>
            
                                    <table width="99%">
                                     
                                        <tr> 
                                            <td class="required">Category Type:
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>
                                            </td> 
                                            <td >SubCategory Type:
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>
                                            </td> 
                                        </tr>
                                        <tr>
                                            <td >Item Category:
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                                            </td>
                                            <td>

                                               Machine:
                                            </td>
                                            <td>
                                                 <asp:ListBox ID="ddlmachine" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="binditem()"></asp:ListBox></td>

                                        </tr>

                                        <tr>
                                            <td class="required">Items :
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>
                                            <td class="required">&nbsp;</td>
                                            <td>
                                                &nbsp;</td>

                                        </tr>

                                        <tr>
                                            <td class="required">From Date :</td>
                                            <td>
                                                 <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                                                &nbsp;</td>
                                            <td class="required">To Date :</td>
                                            <td>
                                                <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender></td>

                                        </tr>

                                        </table>
                               
               </div>
         </div>

                 <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                   &nbsp;&nbsp;
                   <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport();" id="btnsave" /></div>
                     </div>

         </div>

    <script type="text/javascript">
        $(function () {
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlcategory]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ListCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ListItem]').multipleSelect({
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
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            }); $('[id*=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentrecity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=ddlmachine]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindCatagoryType();
            bindcentertype();
            bindZone();
            bindmachine();
        });
    </script>

    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            $.ajax({
                url: "MappingStoreItemWithCentre.aspx/bindcattype",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);
                    for (i = 0; i < ItemData.length; i++) {
                        jQuery("#ddlcattype").append(jQuery("<option></option>").val(ItemData[i].CategoryTypeID).html(ItemData[i].CategoryTypeName));
                    }
                    jQuery('[id*=ddlcattype]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
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
                $.ajax({
                    url: "MappingStoreItemWithCentre.aspx/bindSubcattype",
                    data: '{ CategoryTypeID: "' + CategoryTypeID + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        for (i = 0; i < ItemData.length; i++) {
                            jQuery("#ddlsubcattype").append(jQuery("<option></option>").val(ItemData[i].SubCategoryTypeID).html(ItemData[i].SubCategoryTypeName));
                        }
                        jQuery('[id*=ddlsubcattype]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });
            }
            binditem();
        }

        function bindCategory(SubCategoryTypeMasterId) {
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (SubCategoryTypeMasterId != "") {
                $.ajax({
                    url: "MappingStoreItemWithCentre.aspx/BindSubCategory",
                    data: '{ SubCategoryTypeMasterId: "' + SubCategoryTypeMasterId + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var CategoryID = jQuery.parseJSON(result.d);
                        for (i = 0; i < CategoryID.length; i++) {
                            jQuery('#ddlcategory').append($("<option></option>").val(CategoryID[i].SubCategoryID).html(CategoryID[i].Name));
                        }
                        $('[id*=ddlcategory]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }

            binditem();
        }

        function binditem() {
            var CategoryTypeId = $('#ddlcattype').val();
            var SubCategoryTypeId = $('#ddlsubcattype').val();
            var CategoryId = $('#ddlcategory').val();
            var machineid = $('#ddlmachine').val();

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeId != "") {
                $.ajax({
                    url: "ItemLocationMapping.aspx/binditem",
                    data: '{CategoryTypeId: "' + CategoryTypeId + '",SubCategoryTypeId: "' + SubCategoryTypeId + '", CategoryId: "' + CategoryId + '",machineid:"' + machineid + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        for (i = 0; i < ItemData.length; i++) {
                            jQuery("#ddlItem").append(jQuery("<option></option>").val(ItemData[i].ItemId).html(ItemData[i].ItemName));
                        }
                        jQuery('[id*=ddlItem]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });
            }

        }
    </script>

    <script type="text/javascript">
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            $.ajax({
                url: "StoreLocationMaster.aspx/bindcentertype",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    typedata = jQuery.parseJSON(result.d);
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                    }

                    jQuery('[id*=lstCentreType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    BusinessZoneID = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    $('[id*=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });


                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "StoreLocationMaster.aspx/bindState",
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
            bindCentrecity();
        }

        function bindCentrecity() {
            var StateID = jQuery('#lstState').val();

            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");

            jQuery.ajax({
                url: "StoreLocationMaster.aspx/bindCentrecity",
                data: '{stateid: "' + StateID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstCentrecity").append(jQuery("<option></option>").val(centreData[i].id).html(centreData[i].city));
                    }
                    $('[id*=lstCentrecity]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            var cityId = jQuery('#lstCentrecity').val();
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
        function bindmachine() {
            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#ddlmachine').multipleSelect("refresh");
            $.ajax({
                url: "Services/StoreCommonServices.asmx/bindmachine",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);
                    for (i = 0; i < ItemData.length; i++) {
                        jQuery("#ddlmachine").append(jQuery("<option></option>").val(ItemData[i].ID).html(ItemData[i].NAME));
                    }
                    jQuery('[id*=ddlmachine]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }
        function bindlocation() {

            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            var cityId = jQuery('#lstCentrecity').val();

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
        function GetReport() {

            $.blockUI();
            var CategoryTypeId = $('#ddlcattype').val();
            var SubCategoryTypeId = $('#ddlsubcattype').val();
            var CategoryId = $('#ddlcategory').val();
            var machineid = $('#ddlmachine').val();
            var itemid = $('#<%=ddlItem.ClientID%>').val();
            var locationid = $('#<%=lstlocation.ClientID%>').val();
            $.ajax({
                url: "InTransitAdjustmentReport.aspx/GetReport",
                data: '{fromdate:"' + $('#<%=txtfromdate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",categorytypeid:"' + CategoryTypeId + '",subcategorytypeid:"' + SubCategoryTypeId + '", subcategoryid:"' + CategoryId + '", itemid:"' + itemid + '", locationid:"' + locationid + '", machineid:"' + machineid + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {
                        window.open('../common/ExportToExcel.aspx');
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }

        
    </script>
</asp:Content>

