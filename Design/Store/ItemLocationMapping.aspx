<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemLocationMapping.aspx.cs" Inherits="Design_Store_ItemLocationMapping" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="Head1">
     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
     

        <%: Scripts.Render("~/bundles/WebFormsJs") %>
        <%: Scripts.Render("~/bundles/JQueryStore") %>
    </head>
<body>
      
      
   
      <form id="form1" runat="server">
       
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align:center">
              <div class="row">
                <div class="col-md-24 " style="text-align:center">
                   <b> Map Item With Location</b>
                </div>
                 </div>
                  <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Current Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                    <asp:DropDownList ID="ddllocation" runat="server" ></asp:DropDownList>
                    </div>
               
                  </div>         

                  </div>                             
        <div class="POuter_Box_Inventory">          
                <div class="Purchaseheader">
                      Item Detail</div>            
                <div class="row">
                <div class="col-md-4 ">
                    <label class="pull-left">Category Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                     <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val().toString())"></asp:ListBox>
                    </div>
                     <div class="col-md-4 ">
                    <label class="pull-left">SubCategory Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                     <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val().toString())"></asp:ListBox>
                    </div>
                    </div>
                 <div class="row">
                <div class="col-md-4 ">
                    <label class="pull-left">Item Category   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                     <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                    </div>
<div class="col-md-4 ">
                    <label class="pull-left">Machine   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                   <asp:ListBox ID="ddlmachine" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem()"></asp:ListBox>

                    </div>
                     </div>
                 
                 <div class="row">
                <div class="col-md-4 ">
                    <label class="pull-left">Items   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                     <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>

                </div>
                <div class="col-md-4 ">
                    <label class="pull-left">Item Code</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">                    
                    <asp:TextBox ID="txtcode" Style="text-transform: uppercase; font-weight: bold;" runat="server" MaxLength="500" ></asp:TextBox>
                </div>
            </div>
                                    
              
         </div>

          


           <div class="POuter_Box_Inventory" style="text-align:center;">
              <div class="row"><div class="col-md-24 ">
                   <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                   <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
                   <input type="button" value="Upload Excel" class="searchbutton" onclick="openmypopup('UploadExcel.aspx?type=MinLevel')" />
                   </div></div>
               </div>
        <div class="POuter_Box_Inventory" style="text-align:center;">
           <div  style="height:200px;overflow:scroll;">
                <div class="row"><div class="col-md-24 ">
                   <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>                                                                               
                                        <td class="GridViewHeaderStyle">Centre</td>
                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">Item</td>
                                       <td class="GridViewHeaderStyle" width="120px">Min Level<br />
                                             <input type="text" name="txtminlevelheader" onkeyup="showme1(this)"  style="width:90px;" />
                                          </td>
                                         <td class="GridViewHeaderStyle" width="120px">Reorder Level<br />
                                             <input type="text" name="txtreorderlevelheader"  onkeyup="showme1(this)" style="width:90px;" />
                                          </td>
                                        <td class="GridViewHeaderStyle" width="120px"><input type="checkbox" onclick="call()" id="hd" />&nbsp;&nbsp;<input onclick="DeleteRows()" type="button" value="Delete" style="cursor:pointer;background-color:pink; font-weight: 700;" /></td>


                                         <td class="GridViewHeaderStyle" width="120px">&nbsp;<input type="checkbox" onclick="call1()" id="hd1" />&nbsp;&nbsp;<input onclick="PIRows()" type="button" value="Item PI" style="cursor:pointer;background-color:yellowgreen; font-weight: 700;" /></td>
                                     </tr>
                                 </table></div> </div></div></div>
         <div class="POuter_Box_Inventory" style="text-align:center;">
         <div class="row"><div class="col-md-24 " style="text-align:center"><input class="savebutton" id="btnmin" type="button" value="Save Min,Reorder Level " style="display:none;" onclick="saveminlevel()" /></center>

             </div></div></div>
         </div>
    
   
    </form>


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
          
            $('[id*=ddlmachine]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindCatagoryType();
           
            bindmachine();
            SearchRecords();
        });
    </script>
    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
                jQuery('#ddlcattype').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: $("#ddlcattype"), isClearControl: '' });
            });          
        }
        function bindmachine() {
            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#ddlmachine').multipleSelect("refresh");
            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                jQuery('#ddlmachine').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#ddlmachine"), isClearControl: '' });
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
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID }, function (response) {
                    jQuery('#ddlsubcattype').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: $("#ddlsubcattype"), isClearControl: '' });
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

                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId }, function (response) {
                    jQuery('#ddlcategory').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
                });


               
            }

            binditem();
        }

        function binditem() {
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            var machineid = $('#ddlmachine').val().toString();
            
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {

                    serverCall('ItemLocationMapping.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, CategoryId: CategoryId, machineid: machineid }, function (response) {
                        jQuery('#ddlItem').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                    });


                    
                }
           
        }
    </script>

    

    <script type="text/javascript">
        function SaveData() {

            if ((JSON.stringify($('#ddlcattype').val()) == '[]')) {
                toast("Error", 'Please Select Category Type', "");
                $('#ddlcattype').focus();
                return;
            }
            if ((JSON.stringify($('#ddlItem').val()) == '[]')) {
                toast("Error", 'Please Select Item', "");
                $('#ddlItem').focus();
                return;
            }
          
           
            var Items = $("#ddlItem").val();
         
            var Centres = $('#<%=ddllocation.ClientID%>').val();
            var dataIm = new Array();
            dataIm.push(Centres);

            serverCall('MappingStoreItemWithCentre.aspx/SaveData', { Items: Items, Centres: dataIm }, function (response) {

                if (response == "1") {
                    toast("Success", 'Item Mapped Successfully', "");
                    Refresh();
                    SearchRecords();
                }
            });


           
        }
    </script>
    <script type="text/jscript">
        function Refresh() {
           

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
            $(':checkbox').prop('checked', false);
            bindCatagoryType();       
            $('#tblitemlist tr').slice(1).remove();
            $('#btnmin').hide();
        }
    </script>
    <script type="text/javascript">     
        function DeleteRows() {
            var data = '';
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    if ($(this).closest("tr").find('.mmchk').prop('checked') == true) {
                        data = data + "," + id;
                    }
                }
            });
            if (data == '') {
                toast("Info", 'Please Select Record', "");
                return;
            }
            serverCall('MappingStoreItemWithCentre.aspx/DeleteRows', { Id: data.substr(1, data.length - 1) }, function (response) {
                if (response == "1") {
                    toast("Success", 'Record Deleted successfully', "");
                    $(':checkbox').prop('checked', false);
                    SearchRecords();
                }
            });           
        }
        function PIRows() {
            var data = '';
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var newdata = "0";
                    if ($(this).closest("tr").find('.mmchk1').prop('checked') == true) {
                        newdata = "1";
                    }
                    id = id + "#" + newdata;
                    data = data + "," + id;
                }
            });           
            var locationid = $('#<%=ddllocation.ClientID%>').val();
            serverCall('MappingStoreItemWithCentre.aspx/PIItemMapping', { Id: data.substr(1, data.length - 1), locationid: locationid }, function (response) {
                if (response == "1") {
                    toast("Success", 'Record Deleted successfully', "");
                    $(':checkbox').prop('checked', false);
                    SearchRecords();
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
        function call1() {

            if ($('#hd1').prop('checked') == true) {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk1').prop('checked', true);

                    }
                });
            }
            else {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk1').prop('checked', false);

                    }
                });
            }
        }
        function SearchRecords() {
            var Items = $("#ddlItem").val().toString();            
            var Centres = $('#<%=ddllocation.ClientID%>').val().toString();
            var ItemCode = $('#<%=txtcode.ClientID%>').val().toString();
            
            $('#tblitemlist tr').slice(1).remove();
            serverCall('ItemLocationMapping.aspx/SearchData', { Items: Items, location: Centres,ItemCode:ItemCode  }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", 'No Item Found', "");
                    $('#btnmin').hide();
                }
                else {
                    $('#btnmin').show();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:palegreen;' id='"); $Tr.push(ItemData[i].mapid); $Tr.push("'>");


                        $Tr.push( "<td class='GridViewLabItemStyle' >"); $Tr.push( parseInt(i + 1));$Tr.push("</td>");
                        $Tr.push( '<td class="GridViewLabItemStyle"  >'); $Tr.push( ItemData[i].Centre );$Tr.push("</td>");
                        $Tr.push( '<td class="GridViewLabItemStyle" >' ); $Tr.push( ItemData[i].Location );$Tr.push("</td>");
                        $Tr.push( '<td class="GridViewLabItemStyle" >'); $Tr.push( ItemData[i].ItemName );$Tr.push("</td>");
                        $Tr.push('<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtminlevelheader" class="txtminlevelheader" value="'); $Tr.push(ItemData[i].MinLevel); $Tr.push('" onkeyup="showme(this)"/></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtreorderlevelheader" class="txtreorderlevelheader" value="'); $Tr.push(ItemData[i].ReorderLevel); $Tr.push('" onkeyup="showme(this)"/></td>');
                        $Tr.push( '<td class="GridViewLabItemStyle" align="left"><input type="checkbox" class="mmchk"  id="'); $Tr.push( ItemData[i].mapid ); $Tr.push('"/></td>');
                        $Tr.push( '<td class="GridViewLabItemStyle" align="left">');
                        if (ItemData[i].IsPIItem == "1") {
                            $Tr.push( '<input type="checkbox" class="mmchk1" checked="checked"  />');
                        }
                        else {
                            $Tr.push( '<input type="checkbox" class="mmchk1"  />');
                        }
                        $Tr.push( '</td>');


                        $Tr.push( "</tr>");
                        $Tr = $Tr.join("");
                        jQuery("#tblitemlist").append($Tr);
                      
                    }
                }
            });         
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

        function ExportToExcel() {
            var Items = $("#ddlItem").val();
            var location = $('#<%=ddllocation.ClientID%>').val();

            serverCall('MappingStoreItemWithCentre.aspx/ExportToExcel', { Items: JSON.stringify(Items), location: JSON.stringify(location) }, function (response) {
                if (response == "1") {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast("Info", 'No Record Found', "");
                }

            });        
        }            
    </script>

    <script type="text/javascript">
        function saveminlevel() {
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
                toast("Info", 'Please Select Record To Save', "");
                return;
            }
            serverCall('MappingStoreItemWithCentre.aspx/UpdateLevels', { Id: data.substr(1, data.length - 1) }, function (response) {
                if (response == "1") {
                    toast("Success", 'Record Updated successfully', "");
                    $(':checkbox').prop('checked', false);
                    SearchRecords();

                }
            });            
        }
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
    </script>
</body>
</html>
