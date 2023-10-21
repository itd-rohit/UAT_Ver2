<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PIToPOAndGRNReport.aspx.cs" Inherits="Design_Store_PIToPOAndGRN" %>

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
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:1304px;">
         
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>PI Vs PO and PO Vs GRN Report</b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" ></div>

                <table width="100%">
          <tr>
                                            <td class="required">From Date :</td>
                                            <td>
                                                 <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>&nbsp;&nbsp;&nbsp;&nbsp;   </td>
                                            <td class="required">To Date :</td>
                                            <td>
                                                <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>&nbsp;&nbsp;&nbsp;
                                            </td>

                                        </tr>

          <tr>
                                            <td class="required">Report Type :</td>
                                            <td>
                                              <asp:DropDownList ID="ddltype1" runat="server">
                                                  <asp:ListItem Value="1">PI Vs PO</asp:ListItem>
                                                   <asp:ListItem Value="2">PO Vs GRN</asp:ListItem>
                                              </asp:DropDownList>   </td>
                                            <td class="required">Type :</td>
                                            <td>
                                                <asp:DropDownList ID="ddltt" runat="server">
                                                    <asp:ListItem Value="1">Summary</asp:ListItem>
                                                     <asp:ListItem Value="2">Detail</asp:ListItem>
                                                </asp:DropDownList> </td>

                                        </tr>

</table>
                </div>
             </div>
         <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Location Detail</div>

                <table width="100%">
                    <tr>
                        <td style="text-align: left; font-weight: 700">Current Location :&nbsp; </td>
                      <td> <%-- <asp:DropDownList ID="ddllocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" style="width:400px;"></asp:DropDownList> &nbsp;&nbsp;&nbsp;--%>
                           <asp:ListBox ID="ddllocation" CssClass="multiselect " SelectionMode="Multiple" Width="600px" runat="server" ClientIDMode="Static"></asp:ListBox>
                      </td>
                        <td> &nbsp;</td>
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
                                            <td class="required">Items :
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>

                                        </tr>

                                        <tr>
                                            <td >&nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                            <td >&nbsp;</td>
                                            <td>
                                                &nbsp;</td>

                                        </tr>

                                    </table>
                               
               </div>
         </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">
                      Other Detail</div>
                  <table width="99%">
                      <tr>
                          <td><asp:CheckBox ID="ck" runat="server" Text="Manufacture" Font-Bold="true" onclick="bindmm()" /></td>
                          <td><asp:DropDownList ID="ddlmanu" runat="server" Width="300px"></asp:DropDownList></td>
                          <td>Machine</td>
                          <td><asp:DropDownList ID="ddlmachine" runat="server" Width="300px"></asp:DropDownList></td>
                      </tr>
                      </table>

               </div>
        </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content" style="text-align:center;">
               <input type="button" class="searchbutton" value="Get Report PDF" onclick="getpdfreport()" style="display:none;" />&nbsp;&nbsp;
                <input type="button" class="searchbutton" value="Get Report Excel" onclick="getexcelreport()" />
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

            var ddlManufacturingCompany = $('#<%=ddlmanu.ClientID%>');

            ddlManufacturingCompany.empty();
            $.ajax({
                url: "Services/StoreCommonServices.asmx/bindManufacture",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    // appdata = result.d;

                    PatientData = jQuery.parseJSON(result.d);
                    ddlManufacturingCompany.append($("<option></option>").val("0").html("Select Manufacture"));
                    for (var a = 0; a <= PatientData.length - 1; a++) {
                        ddlManufacturingCompany.append($("<option></option>").val(PatientData[a].ID).html(PatientData[a].NAME));
                    }


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }



        function bindmachine() {

            var ddlMachineName = $('#<%=ddlmachine.ClientID%>');

            ddlMachineName.empty();


            $.ajax({
                url: "Services/StoreCommonServices.asmx/bindmachine",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    // appdata = result.d;

                    PatientData = jQuery.parseJSON(result.d);

                    ddlMachineName.append($("<option></option>").val("0").html("Select Machine"));

                    for (var a = 0; a <= PatientData.length - 1; a++) {
                        ddlMachineName.append($("<option></option>").val(PatientData[a].ID).html(PatientData[a].NAME));

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }




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
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    $.ajax({
                        url: "PIToPOAndGRNReport.aspx/binditem",
                        data: '{CategoryTypeId: "' + CategoryTypeId + '",SubCategoryTypeId: "' + SubCategoryTypeId + '", CategoryId: "' + CategoryId + '",LocationID:"' + $('#<%=ddllocation.ClientID%>').val() + '"}',
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
        }
    </script>

        <script type="text/javascript">

            function getpdfreport() {

                //if ($("#ddllocation").val() == "0") {

                //    showerrormsg("Please Select Location.!");
                //    return;
                //}

                //var location = $("#ddllocation").val();//.split('#')[0];


                //var selectedlocation = [];
                //$('#ddllocation :selected').each(function (i, selected) {
                //    selectedlocation[i] = $(selected).val();
                //});

                var locations = $("#ddllocation").val();

                var Items = $("#ddlItem").val();
                var manu = $("#<%=ddlmanu.ClientID%>").val();
                var machine = $("#<%=ddlmachine.ClientID%>").val();



                $.blockUI();
                $.ajax({
                    url: "StockMovementReport.aspx/getstoctmovementreportpdf",
                    data: JSON.stringify({ location: JSON.stringify(locations), Items: JSON.stringify(Items), manu: manu, machine: machine }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        var save = result.d;
                        if (save == "1") {
                            window.open('Report/commonreportstore.aspx');
                            $.unblockUI();
                        }
                        else {

                            showerrormsg(save);
                            $.unblockUI();
                        }
                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        showerrormsg("Some Error Occure Please Try Again..!");
                        $('#btnsave').attr('disabled', false).val("Save");
                        console.log(xhr.responseText);
                    }
                });
            }
        </script>

         <script type="text/javascript">

             function getexcelreport() {
                 //if ($('#<%=ddllocation.ClientID%>').val() == "0") {

                 //   showerrormsg("Please Select Location.!");
                 //   return;
                 //  }

                 //  var location = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

                 var locations = $("#ddllocation").val();

                 var Items = $("#ddlItem").val();
                 var manu = $("#<%=ddlmanu.ClientID%>").val();
                 var machine = $("#<%=ddlmachine.ClientID%>").val();

                 var fromdate = $("#<%=txtfromdate.ClientID%>").val();
                 var todate = $("#<%=txttodate.ClientID%>").val();
                 var type = $("#<%=ddltype1.ClientID%>").val();
                 var rtype = $("#<%=ddltt.ClientID%>").val();
                 $.blockUI();
                 $.ajax({
                     url: "PIToPOAndGRNReport.aspx/getreportexcel",
                     data: JSON.stringify({ location: JSON.stringify(locations), Items: JSON.stringify(Items), manu: manu, machine: machine, fromdate: fromdate, todate: todate, type: type, rtype: rtype }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         var save = result.d;
                         if (save == "true") {
                             window.open('../common/ExportToExcel.aspx');
                             $.unblockUI();
                         }
                         else {

                             showerrormsg(save);
                             $.unblockUI();
                         }
                     },
                     error: function (xhr, status) {
                         $.unblockUI();
                         showerrormsg("Some Error Occure Please Try Again..!");
                         $('#btnsave').attr('disabled', false).val("Save");
                         console.log(xhr.responseText);
                     }
                 });



             }
        </script>
</asp:Content>


