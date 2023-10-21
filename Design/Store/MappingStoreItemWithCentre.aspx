<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MappingStoreItemWithCentre.aspx.cs" Inherits="Design_Store_MappingStoreItemWithCentre" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

        <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     
     
     <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center;">
         
                          <b>Mapping Location With Item And Set Min and Reorder Level</b>  
                      
               
              </div>
<div class="POuter_Box_Inventory" ">
           
                <div class="Purchaseheader">Location Details</div>
                <div class="row" >
		 
		  <div class="col-md-3 ">
			   <label class="pull-left">CentreType   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>		 		 
		   </div>
           
             <div class="col-md-3 ">
			   <label class="pull-left">Zone   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindState($(this).val().toString())"></asp:ListBox>
		   </div>
             </div>
              				
	     <div class="row">
              <div class="col-md-3 ">
			   <label class="pull-left">State   </label>
			   <b class="pull-right">:</b>
		   </div>

		   <div class="col-md-9 ">
<asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>

		   </div>
            

             <div class="col-md-3 ">
			   <label class="pull-left">City   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
		   </div></div>
                      <div class="row">
              <div class="col-md-3 ">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
                    <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">Location   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
		   </div></div>
                                       
                    
               </div>
            
         <div class="POuter_Box_Inventory" >
           
                <div class="Purchaseheader">
                      Item Detail</div>
                 <div class="row">
              <div class="col-md-3 ">
			   <label class="pull-left">Category Type   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
                    <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">SubCategory Type  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>
		   </div></div>
                                     <div class="row">
              <div class="col-md-3 ">
			   <label class="pull-left">Item Category   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
                   <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
		   </div>
           

             <div class="col-md-3 ">
			   <label class="pull-left">Items  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
		   </div></div>              
                               
               </div>
        

          


           <div class="POuter_Box_Inventory" style=" text-align:center;">
             
                   <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                   <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
                   <input type="button" value="Upload Excel" class="searchbutton" onclick="openmypopup('UploadExcel.aspx?type=MinLevel')" />
                   </div>
              
          <div class="POuter_Box_Inventory" style=" text-align:center;">
           <div class="row" style="text-align:center">
                   <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">Centre</td>
                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">Item</td>
                                       <td class="GridViewHeaderStyle" style="width:120px">Min Level<br />
                                             <input type="text" name="txtminlevelheader" onkeyup="showme1(this)"  style="width:90px;" />
                                          </td>

                                         <td class="GridViewHeaderStyle" style="width:120px" >Reorder Level<br />
                                             <input type="text" name="txtreorderlevelheader"  onkeyup="showme1(this)" style="width:90px;" />
                                          </td>
                                        <td class="GridViewHeaderStyle" style="width:120px"><input type="checkbox" onclick="call()" id="hd" />&nbsp;&nbsp;<input onclick="DeleteRows()" type="button" value="Delete" style="cursor:pointer;background-color:pink; font-weight: 700;" /></td>
                                     </tr>
                                 </table>
         
<input class="savebutton" id="btnmin" type="button" value="Save Min & Reorder Level" style="display:none;" onclick="saveminlevel()" />
                </div>
        
         
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
            bindCatagoryType();
            bindcentertype();
            bindZone();

        });
    </script>

    


    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype',{}, function(response){
                jQuery('#ddlcattype').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: $("#ddlcattype"), isClearControl: '' });
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
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype',{CategoryTypeID:CategoryTypeID.toString()}, function(response){
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
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId.toString() }, function (response) {
                    jQuery('#ddlcategory').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
                });     
               
                     
            }

            binditem();
        }

        function binditem() {
            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var CategoryId = $('#ddlcategory').val().toString();
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    
                    serverCall('MappingStoreItemWithCentre.aspx/binditem',{CategoryTypeId:CategoryTypeId,SubCategoryTypeId:SubCategoryTypeId,CategoryId:CategoryId}, function(response){
                        jQuery('#ddlItem').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                    });  
                       
                }
            }
        }
    </script>

    <script type="text/javascript">
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery('#lstCentreType').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });
            }); 
                  
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
          
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery('#lstZone').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
            });  

        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                    jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });

            }
            bindCentrecity(); 
        }

        function bindCentrecity() {
            var StateID = jQuery('#lstState').val().toString();

            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery('#lstCentrecity').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
            });
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {
                    jQuery('#lstCentre').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), isClearControl: '' });
                });   
                

                   
               
            }

            bindlocation();
        }

        function bindlocation() {

            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();

            var centreid = jQuery('#lstCentre').val().toString();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
           
           serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid: centreid, StateID: StateID, TypeId: TypeId, ZoneId: ZoneId, cityId: cityId }, function (response) {
               jQuery('#lstlocation').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
           }); 
              
        }

    </script>

    <script type="text/javascript">
        function SaveData() {

            if ($('#ddlcattype').val().toString() == '') {
                toast("Error","Please Select Category Type","");
                $('#ddlcattype').focus();
                return;
            }
            if ($('#ddlItem').val().toString() == '') {
                toast("Error","Please Select Item","");
                $('#ddlItem').focus();
                return;
            }
            if ($('#lstCentreType').val().toString() == '') {
                toast("Error", "Please Select Centre Type","");
                $('#lstCentreType').focus();
                return;
            }
            if ($('#lstlocation').val().toString() == '') {
                toast("Error", "Please Select Location","");
                $('#lstlocation').focus();
                return;
            }

            var Items = $("#ddlItem").val();
            var Centres = $('#lstlocation').val();

            serverCall('MappingStoreItemWithCentre.aspx/SaveData',{Items: Items, Centres: Centres},function(response){
               
                if (response == "1") {
                    toast("Success", "Item Mapped Successfully","");
                    Refresh();
                    SearchRecords();
                }
                else
                {
                    toast("Error", "Record Not Saved", "");
                }
               
            });
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

            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");

            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");

            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");

            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");


            $(':checkbox').prop('checked', false);
            bindCatagoryType();
            bindcentertype();
            bindZone();
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
                toast("Error", "Please Select Record.","");
                return;
            }
            serverCall('MappingStoreItemWithCentre.aspx/DeleteRows',{Items: Items, Centres: Centres},function(response){
              
           
                if (response == "1") {
                        toast("Success","Record Deleted successfully");
                        SearchRecords();
                        $(':checkbox').prop('checked', false);
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
            
            var Items = $("#ddlItem").val().toString();
            var location = $('#lstlocation').val().toString();
            $('#tblitemlist tr').slice(1).remove();
            serverCall('MappingStoreItemWithCentre.aspx/SearchData',{Items: Items, location: location},function(response){
                $responseData = $.parseJSON(response);
           
                    

                    if ($responseData.length == 0) {
                        toast("Error","No Item Found","");
                        
                        $('#btnmin').hide();

                    }
                    else {
                        $('#btnmin').show();

                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push("<tr style='background-color:palegreen;' id='"); $mydata.push( $responseData[i].mapid ); $mydata.push( "'>");
                           

                            $mydata.push( "<td class='GridViewLabItemStyle' >" ); $mydata.push( parseInt(i + 1));$mydata.push("</td>");
                            $mydata.push( '<td class="GridViewLabItemStyle"  >' ); $mydata.push( $responseData[i].Centre);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" >' ); $mydata.push( $responseData[i].Location);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" >' ); $mydata.push( $responseData[i].ItemName );$mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtminlevelheader" class="txtminlevelheader" value="'); $mydata.push( $responseData[i].MinLevel); $mydata.push('" onkeyup="showme(this)"/></td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" ><input style="width:90px;" type="text" name="txtreorderlevelheader" class="txtreorderlevelheader" value="'); $mydata.push( $responseData[i].ReorderLevel ); $mydata.push('" onkeyup="showme(this)"/></td>');
                            $mydata.push('<td class="GridViewLabItemStyle" align="left"><input type="checkbox" class="mmchk"  id="'); $mydata.push( $responseData[i].mapid ); $mydata.push( '"/></td>');
                           


                          

                            $mydata.push( "</tr>");
                            $mydata= $mydata.join("");
                            $('#tblitemlist').append($mydata);

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
            var Items = $("#ddlItem").val().toString();
            var location = $('#lstlocation').val().toString();
            serverCall('MappingStoreItemWithCentre.aspx/ExportToExcel',{Items: Items, location: location},function(response){
              
            
                if (response == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        toast("Error", "No Record Found..!","");
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
                toast("Error", "Please Select Record To Save.","");
                return;
            }
            serverCall('MappingStoreItemWithCentre.aspx/UpdateLevelsonlyminorder',{Id:data.substr(1, data.length - 1)},function(response){
                
           
                if (response == "1") {
                        toast("Success","Record Updated successfully","");
                        SearchRecords();
                        $(':checkbox').prop('checked', false);
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
</asp:Content>

