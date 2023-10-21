<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SetItemsLevel.aspx.cs" Inherits="Design_Store_SetItemsLevel" %>

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
                          <b>Set Item Min And Reorder Level</b>  
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
                                            <td>Category Type:
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
                                            <td >Items :
                                            </td>
                                            <td>
                                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>

                                        </tr>

                                    </table>
                               
               </div>
         </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">Centre Details</div>
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
                                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                            </td>


                                            <td >Centre :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>
                                        </tr>


                                    </table>
                    
               </div>
              </div>


           <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                   &nbsp;
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />
                   <input type="button" value="Save" class="savebutton" onclick="SaveData()" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <input type="button" value="Download Excel" class="searchbutton" onclick="ExportToExcel()" />
                   <input type="button" value="Upload Excel" class="searchbutton" onclick="openmypopup('UploadExcel.aspx?type=MinLevel')" />
                   </div>
               </div>

           <div  style="width:1295px; height:200px;overflow:scroll;">
                   <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                         <td class="GridViewHeaderStyle">Apollo Item Code</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Centre Type</td>
                                        <td class="GridViewHeaderStyle">Centre</td>
                                         <td class="GridViewHeaderStyle">Min Level<br />
                                             <input type="text" name="txtminlevelheader" onkeyup="showme1(this)"  style="width:90px;" />
                                          </td>
                                          <td class="GridViewHeaderStyle">Reorder Level<br />
                                             <input type="text" name="txtreorderlevelheader"  onkeyup="showme1(this)" style="width:90px;" />
                                          </td>
                                         
                                        <td class="GridViewHeaderStyle"><input type="checkbox" onclick="call()" id="hd" /></td>
                                     </tr>
                                 </table></div>


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
            });

            bindCatagoryType();
            bindcentertype();
            bindZone();

        });
    </script>

    


    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            $.ajax({
                url: "SetItemsLevel.aspx/bindcattype",
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
                    url: "SetItemsLevel.aspx/bindSubcattype",
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
                    url: "SetItemsLevel.aspx/BindSubCategory",
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
                        url: "SetItemsLevel.aspx/binditem",
                        data: '{CategoryTypeId: "' + CategoryTypeId + '",SubCategoryTypeId: "' + SubCategoryTypeId + '", CategoryId: "' + CategoryId + '"}',
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
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            $.ajax({
                url: "SetItemsLevel.aspx/bindcentertype",
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
                    url: "SetItemsLevel.aspx/bindState",
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
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                jQuery.ajax({
                    url: "SetItemsLevel.aspx/bindCentre",
                    data: '{ZoneId: "' + ZoneId + '",StateID: "' + StateID + '",TypeId: "' + TypeId + '"}',
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
        }

    </script>

    
    <script type="text/jscript">
        function Refresh() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");

            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");

            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");

            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");

            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");
            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");

            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");

            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            $(':checkbox').prop('checked', false);
            bindCatagoryType();
            bindcentertype();
            bindZone();
        }
    </script>

    <script type="text/javascript">

        function SaveData() {

            var data = '';
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {

                    if ($(this).closest("tr").find('.mmchk').prop('checked') == true) {
                        var newdata = id + "#" + $(this).closest("tr").find('.txtminlevelheader').val() + "#" + $(this).closest("tr").find('.txtreorderlevelheader').val();
                        data = data + "," + newdata;
                    }
                }
            });


            if (data == '') {
                showerrormsg("Please Select Record To Save.");
                return;
            }

            jQuery.ajax({
                url: "SetItemsLevel.aspx/UpdateLevels",
                data: JSON.stringify({ Id: data.substr(1, data.length - 1) }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Updated successfully");
                        SearchRecords();
                        $(':checkbox').prop('checked', false);
                    }
                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });
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
        function call() {

            if ($('#hd').prop('checked') == true) {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', true);

                    }
                });
            }
            else {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', false);

                    }
                });
            }
        }

        function SearchRecords() {
          

            var centres = JSON.stringify($('#lstCentre').val());
            var Items = JSON.stringify($("#ddlItem").val());

            


            $('#tblitemlist tr').slice(1).remove();

            $.ajax({
                url: "SetItemsLevel.aspx/SearchDataNew",
                data: JSON.stringify({ AllItems: Items, AllCenter: centres }),
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:palegreen;' id='" + ItemData[i].Id + "'>";


                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Category + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ApolloItemCode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].type1 + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Centre + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtminlevelheader" class="txtminlevelheader" value="' + ItemData[i].MinLevel + '" onkeyup="showme(this)"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtreorderlevelheader" class="txtreorderlevelheader" value="' + ItemData[i].ReorderLevel + '" onkeyup="showme(this)"/></td>';
                            
                            mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox" class="mmchk"  id="' + ItemData[i].Id + '"/></td>';





                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }

        function ExportToExcel() {
            var centres = JSON.stringify($('#lstCentre').val());
            var Items = JSON.stringify($("#ddlItem").val());

            $.ajax({
                url: "SetItemsLevel.aspx/ExportToExcel",
                data: JSON.stringify({ AllItems: Items, AllCenter: centres }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "true") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        showerrormsg("No Record Found..!");
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
        function showme(ctrl) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
            }
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }
        }
        function showme1(ctrl) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
            }
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }


            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });


        }


    </script>
</asp:Content>
