<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/Design/DefaultHome.master" CodeFile="AutoConsumemaster.aspx.cs" Inherits="Design_Store_AutoConsumemaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <style type="text/css">
        .selected {
            background-color:aqua !important;
           border:2px solid black;
        }
          </style>
      
     <%: Scripts.Render("~/bundles/JQueryStore") %>

           <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
          <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
     
     
     <div id="Pbody_box_inventory" >
          <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">   
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align: center">          
                          <b>Store Item Auto Consume Master</b>                        
              </div>
          <div class="POuter_Box_Inventory" >       
                <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val().toString())"></asp:ListBox>
  </div>
                     <div class="col-md-3">
                    <label class="pull-left">SubCategory Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val().toString())"></asp:ListBox>

  </div>
   <div class="col-md-3">
                    <label class="pull-left">Item Category  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>

                    </div>
                    </div>


               <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Machine  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">

                     <asp:ListBox ID="ddlmachine" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>
                    </div>

                    <div class="col-md-3">
                    <label class="pull-left">Manufacture  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlManufacture" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>

                     </div>
                    </div>

              <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Items  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                                                                    <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>

                     </div>
                   <div class="col-md-3"><input type="button" value="Add" class="searchbutton" onclick="addme()" /></div>
                  <div class="col-md-3"><input type="button" value="Save" class="savebutton" id="btnsave" style="display:none;" onclick="savemefinal()" /></div>
                       </div>              
         </div>
           <div class="POuter_Box_Inventory" >         
                <div class="Purchaseheader" >
                    <div class="row">
                <div class="col-md-24">
                     <table width="60%">
                <tr>
                    <td style="width: 50%;">Store Item List </td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Data Not Mapped</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: palegreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Data  Mapped</td>
                    
                    
                </tr>
            </table>
                    </div></div>

                </div>
                <div class="row">
                <div class="col-md-24">
                 <div  style="width:100%; max-height:600px;overflow:auto;">
                     <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                         <tr id="triteheader">
                             <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                             <td class="GridViewHeaderStyle">SubCategory </td>
                             <td class="GridViewHeaderStyle">Item Type</td>
                             <td class="GridViewHeaderStyle">Item Name</td>
                             <td class="GridViewHeaderStyle">Machine</td>
                             <td class="GridViewHeaderStyle">Manufacture</td>
                             <td class="GridViewHeaderStyle">PackSize</td>
                             <td class="GridViewHeaderStyle">
                                <select name="consumetype" id="ddlconsumetypehead" style="width:120px;" onchange="setall(this)">
                                    <option value="0">Consume Type</option>
                                    <option value="1">PatientWise</option>
                                    <option value="2">TestWise</option>
                                    <option value="3">BarcodeNoWise</option>
                                    <option value="4">MachineWise</option></select>
                             </td>
                             <td class="GridViewHeaderStyle">

                                 <select name="eventtype" id="ddleventtypehead" style="width:180px;" onchange="setall(this)">
                                     <option value="0">Select Event Type</option><option value="1">Booking</option><option value="2">SampleCollection</option><option value="3">SampleTransfer</option><option value="4">PatientReceiptPrint</option><option value="5">PatientReportPrint</option><option value="6">HistoGrossingAndSliding</option><option value="7">MicroPlating</option><option value="8">SampleProcessing</option></select>


                             </td>
                             <td class="GridViewHeaderStyle">Consume Unit</td>
                             <td class="GridViewHeaderStyle">
                                 <input type="text" id="QtyPerTest" placeholder="QtyPerTest" style="width:75px;font-weight:bold;" onkeyup="showme(this)" name="qty" />
                             </td>
                             <td class="GridViewHeaderStyle" width="250px;">Lab Item</td>
                         </tr>
                     </table>
                </div>
              </div></div>
               </div>
         </div>
                <asp:Panel ID="OnlineFilterOLD" runat="server" Style="display: none;">
            <div class="POuter_Box_Inventory" style="width: 1000px; background-color: papayawhip">
                <div class="Purchaseheader">
                    Add Lab Investigation/Observation
                </div>
                <div class="content" style="text-align: center;">

                    <table width="99%" >
                        <tr>
                            <td>
                                Lab Item Type :
                            </td>
                            <td>
                                <select name="ddllabitemtype" id="ddllabitemtype" onchange="getitemlist()" style="width: 120px;">
                                    <option value="0">Select</option>
                                    <option value="1">Investigation</option>
                                    <option value="2">Observation</option>
                                     <option value="3">ALL</option>
                                </select>
                            </td>

                            <td>
                                Lab Item :	
                            </td>
                            <td align="left" style="text-align:left;">
                              
                                 <asp:ListBox ID="lstlabitem" CssClass="multiselect " SelectionMode="Multiple" Width="640px" runat="server" ClientIDMode="Static"></asp:ListBox>
                              
                            </td>

                          

                        </tr>
                        <tr>
                            <td colspan="4" align="center">
                                 <br /> <br />
                                <input type="text" id="txtval" style="display:none;" />
                                <input type="button" value="Add" class="savebutton" onclick="addtomaintable()" />
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:Button ID="btnCloseOnlinePOPUP" CssClass="resetbutton" Text="Close Without Adding" runat="server" />
                            </td>
                        </tr>
                    </table>

                    
                </div>
            </div>
        </asp:Panel>



                 <cc1:ModalPopupExtender ID="ModalPopupOnlineFilter" runat="server" CancelControlID="btnCloseOnlinePOPUP" TargetControlID="btnCloseOnlinePOPUP"
        BackgroundCssClass="filterPupupBackground" PopupControlID="OnlineFilterOLD">
    </cc1:ModalPopupExtender>



         <script type="text/javascript">
             $(function () {               
                 $('[id=ddlcattype]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id=ddlsubcattype]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id=ddlcategory]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id=ddlItem]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                
                 $('[id=ddlmachine]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id=ddlManufacture]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id=lstlabitem]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 
                 bindCatagoryType();
                 bindManufacture();
                 bindmachine();
             });            
    </script>
         <script type="text/javascript">
             function bindManufacture() {
                 jQuery('#<%=ddlManufacture.ClientID%> option').remove();
                 jQuery('#ddlManufacture').multipleSelect("refresh");
                 serverCall('Services/StoreCommonServices.asmx/bindManufacture', { }, function (response) {
                     jQuery('#ddlManufacture').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#ddlManufacture"), isClearControl: '' });                   
                 });                
             }
             function bindmachine() {
                 jQuery('#<%=ddlmachine.ClientID%> option').remove();
                 jQuery('#ddlmachine').multipleSelect("refresh");
                 serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                     jQuery('#ddlmachine').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#ddlmachine"), isClearControl: '' });
                 });               
             }


             function bindCatagoryType() {
                 jQuery('#<%=ddlcattype.ClientID%> option').remove();
                 jQuery('#ddlcattype').multipleSelect("refresh");

                 serverCall('MappingStoreItemWithCentre.aspx/bindcattype', {}, function (response) {
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
            var manufacture = $('#ddlManufacture').val().toString();

                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");               
                serverCall('AutoConsumemaster.aspx/binditem', { CategoryTypeId: CategoryTypeId, SubCategoryTypeId: SubCategoryTypeId, CategoryId: CategoryId, machineid: machineid, manufacture: manufacture }, function (response) {
                    jQuery('#ddlItem').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                });                    
        }
    </script>

         <script type="text/javascript">
             function addme() {

                 if ((JSON.stringify($('#ddlItem').val()) == '[]')) {
                     toast("Error","Please Select Item","");
                     $('#ddlItem').focus();
                     return;
                 }
                 var Items = $("#ddlItem").val().toString();
                 $('#tblitemlist tr').slice(1).remove();
                 $('#ddlconsumetypehead').val('0');
                 $('#ddleventtypehead').val('0');
                 $('#QtyPerTest').val('');

                 serverCall('AutoConsumemaster.aspx/Addme', { Items: Items }, function (response) {
                     ItemData = jQuery.parseJSON(response);
                     if (ItemData.length == 0) {
                         toast("Error", 'No Item Added', "");                       
                         $('#btnsave').hide();
                     }
                     else {
                         for (var i = 0; i <= ItemData.length - 1; i++) {

                             var color = "palegreen";
                             if (ItemData[i].mapid == "0") {
                                 color = "bisque";
                             }

                             var $Tr = [];
                             $Tr.push("<tr style='background-color:"); $Tr.push(color);$Tr.push(";' id='"); $Tr.push(parseInt(i + 1)); $Tr.push("' class='"); $Tr.push(ItemData[i].mapid); $Tr.push("'>");


                             $Tr.push("<td class='GridViewLabItemStyle' >");$Tr.push(parseInt(i + 1));$Tr.push("</td>");
                             $Tr.push('<td class="GridViewLabItemStyle"  >');$Tr.push(ItemData[i].SubCategoryTypeName);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].ItemType);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" id="tditemname1" >');$Tr.push(ItemData[i].typename);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].machinename );$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].manufacturename);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].packsize );$Tr.push('</td>');

                             $Tr.push('<td class="GridViewLabItemStyle" ><select name="consumetype" id="ddlconsumetype" style="width:120px;"><option value="0">Select</option><option value="1">PatientWise</option><option value="2">TestWise</option><option value="3">BarcodeNoWise</option><option value="4">MachineWise</option></select></td>');


                             $Tr.push('<td class="GridViewLabItemStyle" ><select name="eventtype" id="ddleventtype" style="width:180px;"><option value="0">Select</option><option value="1">Booking</option><option value="2">SampleCollection</option><option value="3">SampleTransfer</option><option value="4">PatientReceiptPrint</option><option value="5">PatientReportPrint</option><option value="6">HistoGrossingAndSliding</option><option value="7">MicroPlating</option><option value="8">SampleProcessing</option></select></td>');

                             $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" >');$Tr.push( ItemData[i].MinorUnitName);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" ><input type="text" id="txtqty" name="qty" style="width:75px;" onkeyup="showme1(this)" value="');$Tr.push( precise_round(ItemData[i].StoreItemQty, 5));$Tr.push('" /></td>');
                             $Tr.push('<td class="GridViewLabItemStyle" width="250px;" ><input type="button" onclick="addmenow(this)" value="Add" class="savebutton" onclick="save"/><div style="width:100%;max-height:100px;overflow:auto;"> <table class="mydatatable" id="mydata" style="width: 99%; border-collapse: collapse; text-align: left;"><tr class="GridViewHeaderStyle" id="mydatahead"><td>Type</td><td>Name</td><td width="20px;"></td></tr></table></div></td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tditemid">');$Tr.push( ItemData[i].itemid);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdmachineid">');$Tr.push(ItemData[i].machineid);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdmanufactureid">');$Tr.push( ItemData[i].manufactureid);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdMinorUnitId">');$Tr.push(ItemData[i].MinorUnitId);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdMinorUnitInDecimal">');$Tr.push(ItemData[i].MinorUnitInDecimal);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdConsumetypeID">');$Tr.push(ItemData[i].ConsumetypeID);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdEventtypeID">');$Tr.push(ItemData[i].EventtypeID);$Tr.push('</td>');
                             $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdlabdata">');$Tr.push(ItemData[i].labdata);$Tr.push('</td>');
                             $Tr.push("</tr>");
                             $Tr = $Tr.join("");
                             $('#btnsave').show();
                             $('#tblitemlist').append($Tr);
                        }
                         tablefunction();
                     }
                 });                
             }
             function precise_round(num, decimals) {
                 if (num != "") {
                     return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
                 }
                 else {
                     return num;
                 }
             }
             function tablefunction() {

                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "triteheader" && id !="mydatahead") {
                         $(this).closest("tr").find('#ddlconsumetype').val($(this).closest('tr').find('#tdConsumetypeID').html());
                         $(this).closest("tr").find('#ddleventtype').val($(this).closest('tr').find('#tdEventtypeID').html());
                         var labdata = $(this).closest('tr').find('#tdlabdata').html();

                        
                         if (labdata != "") {
                             for (var aa = 0; aa <= labdata.split('^').length-1; aa++) {
                                 var ii = labdata.split('^')[aa];
                               
                                 if (ii != "") {
                                     var $Tr = [];
                                     $Tr.push("<tr style='background-color:cyan;' id='"); $Tr.push(ii.split('#')[1]); $Tr.push("'>");
                                     $Tr.push('<td class="GridViewLabItemStyle" id="tditemtype" >'); $Tr.push(ii.split('#')[0]); $Tr.push('</td>');
                                     $Tr.push('<td class="GridViewLabItemStyle" id="tditemname" >'); $Tr.push(ii.split('#')[2]); $Tr.push('</td>');
                                     $Tr.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');
                                     $Tr.push("</tr>");
                                     $Tr = $Tr.join("");
                                     $(this).closest("tr").find('#mydata').append($Tr);
                                 }
                             }

                         }
                     }
                 });
             }

         </script>



               <script type="text/javascript">

                   function setall(ctrl) {

                       var val = $(ctrl).val();
                       var name = $(ctrl).attr("name");
                       $('select[name="' + name + '"]').each(function () {
                           $(this).val(val);
                       });
                   }


                   function showme(ctrl) {

                       if ($(ctrl).val().indexOf(" ") != -1) {
                           $(ctrl).val($(ctrl).val().replace(' ', ''));
                       }

                       var nbr = $(ctrl).val();
                       var decimalsQty = nbr.replace(/[^.]/g, "").length;
                       if (parseInt(decimalsQty) > 1) {
                           $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                       }

                   

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

                   function showme1(ctrl) {

                       if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

                           if ($(ctrl).val().indexOf(".") != -1) {
                               $(ctrl).val($(ctrl).val().replace('.', ''));
                           }
                       }

                       if ($(ctrl).val().indexOf(" ") != -1) {
                           $(ctrl).val($(ctrl).val().replace(' ', ''));
                       }

                       var nbr = $(ctrl).val();
                       var decimalsQty = nbr.replace(/[^.]/g, "").length;
                       if (parseInt(decimalsQty) > 1) {
                           $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                       }



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

                   
               </script>

               <script type="text/javascript">

                   function addmenow(ctrl) {
                       $('#txtval').val($(ctrl).closest('tr').attr('id'));
                       jQuery('#<%=lstlabitem.ClientID%> option').remove();
                       jQuery('#lstlabitem').multipleSelect("refresh");

                       $('#ddllabitemtype').val('0');
                       $find("<%=ModalPopupOnlineFilter.ClientID%>").show();

                   }
                   function getitemlist() {                                          
                       jQuery('#<%=lstlabitem.ClientID%> option').remove();
                       jQuery('#lstlabitem').multipleSelect("refresh");
                       if ($('#ddllabitemtype').val() != "0") {
                           serverCall('AutoConsumemaster.aspx/bindalldata', { type: $('#ddllabitemtype').val()  }, function (response) {
                               var idata = $.parseJSON(response);
                               if (idata.length == 0) {
                                   toast("Info", 'No Record', "");                                  
                                   return;
                               }
                               $("#<%=lstlabitem.ClientID%>").bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'name', controlID: $("#<%=lstlabitem.ClientID%>"), isClearControl: '' });                             
                           });                         
                       }
                     

                   }

                   function addtomaintable() {

                       if ((JSON.stringify($('#lstlabitem').val()) == '[]')) {
                           toast("Error","Please Select Item To Add","");
                           $('#lstlabitem').focus();
                           return;
                       }

                       var id = $('#txtval').val();

                       $('#lstlabitem > option:selected').each(function () {
                         

                           if ($('#' + id).find('#mydata').find('#' + $(this).val()).length == 0) {
                               var $Tr = [];
                               $Tr.push("<tr style='background-color:cyan;' id='");$Tr.push($(this).val()); $Tr.push("'>");
                               $Tr.push('<td class="GridViewLabItemStyle" id="tditemtype" >');$Tr.push($(this).text().split('#')[1] ); $Tr.push('</td>');
                               $Tr.push('<td class="GridViewLabItemStyle" id="tditemname" >');$Tr.push($(this).text().split('#')[0].trim()); $Tr.push('</td>');
                               $Tr.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');
                               $Tr.push("</tr>");
                               $Tr = $Tr.join("");
                               $('#' + id).find('#mydata').append($Tr);
                           }                         
                       });
                       $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
                   }
                   function deleterow(itemid) {
                       $(itemid).closest('tr').remove();
                   }                 
               </script>
               <script type="text/javascript">
                   function getdata() {
                       var dataIm = new Array();
                       $('#tblitemlist tr').each(function () {
                           var id = $(this).closest("tr").attr("id");
                           if (id != "triteheader") {
                               var Itemid = $(this).closest("tr").find('#tditemid').html();
                               var ItemName = $(this).closest("tr").find('#tditemname1').html();
                               var ConsumetypeID = $(this).closest("tr").find('#ddlconsumetype').val();
                               var ConsumetypeName = $(this).closest("tr").find('#ddlconsumetype option:selected').text();
                               var EventtypeID = $(this).closest("tr").find('#ddleventtype').val();
                               var EventtypeName = $(this).closest("tr").find('#ddleventtype option:selected').text();
                               var StoreItemQty = $(this).closest("tr").find('#txtqty').val();
                               var InvMaxQty = $(this).closest("tr").find('#txtqty').val();
                               $(this).closest("tr").find('#mydata tr').each(function () {
                                   var id1 = $(this).closest("tr").attr("id")
                                   if (id1 != "mydatahead") {
                                      
                                       var objAutoConsumeData = new Object();
                                       objAutoConsumeData.Itemid = Itemid;
                                       objAutoConsumeData.ItemName = ItemName;
                                       objAutoConsumeData.ConsumetypeID = ConsumetypeID;
                                       objAutoConsumeData.ConsumetypeName = ConsumetypeName;
                                       objAutoConsumeData.EventtypeID = EventtypeID;
                                       objAutoConsumeData.EventtypeName = EventtypeName;
                                       objAutoConsumeData.StoreItemQty = StoreItemQty;
                                       objAutoConsumeData.InvMaxQty = InvMaxQty;
                                       objAutoConsumeData.LabitemTypeID = $(this).closest("tr").find('#tditemtype').html() == "Investigation" ? "1" : "2";
                                       objAutoConsumeData.LabitemTypeName = $(this).closest("tr").find('#tditemtype').html();
                                       objAutoConsumeData.LabItemId = id1;
                                       objAutoConsumeData.LabItemName = $(this).closest("tr").find('#tditemname').html();
                                       dataIm.push(objAutoConsumeData);
                                   }
                               });                           
                           }
                       });
                       return dataIm;
                   }
                   function validation() {
                       var contype = "0";
                       $('#tblitemlist tr').each(function () {
                           var id = $(this).closest("tr").attr("id");
                           if (id != "triteheader" && $(this).closest("tr").find('#ddlconsumetype').val() == "0") {
                               contype = "1";
                               $(this).closest("tr").find('#ddlconsumetype').focus();
                               return;
                           }
                           
                       });
                       if (contype == "1") {
                           toast("Error","Please Select Consume Type","");
                           return false;
                       }
                       var evtype = "0";
                       $('#tblitemlist tr').each(function () {
                           var id = $(this).closest("tr").attr("id");
                           if (id != "triteheader" && $(this).closest("tr").find('#ddleventtype').val() == "0") {
                               evtype = "1";
                               $(this).closest("tr").find('#ddleventtype').focus();
                               return;
                           }

                       });

                       if (evtype == "1") {
                           toast("Error","Please Select Event Type","");
                           return false;
                       }


                       var qty = "0";
                       $('#tblitemlist tr').each(function () {
                           var id = $(this).closest("tr").attr("id");
                           if (id != "triteheader" && ($(this).closest("tr").find('#txtqty').val() == "" || $(this).closest("tr").find('#txtqty').val() == "")) {
                               qty = "1";
                               $(this).closest("tr").find('#txtqty').focus();
                               return;
                           }

                       });

                       if (qty == "1") {
                           toast("Error","Please Enter Qty Per Test","");
                           return false;
                       }
                       var table1 = "0";

                       $('.mydatatable').each(function () {
                           if ($(this).rowCount() == 0 || $(this).rowCount() == 1) {
                              
                               table1 = "1";
                               $(this).closest("tr").find('.savebutton').focus();
                               return;
                           }
                       });                 
                       if (table1 == "1") {
                           toast("Error","Please Select Lab Item","");
                           return false;
                       }                      
                       return true;
                   }
                   function savemefinal() {
                       if (validation() == false) {
                           return;
                       }
                       var data = getdata();
                    
                       serverCall('AutoConsumemaster.aspx/SaveData', { data: data }, function (response) {

                           if (response == "1") {
                               toast("Success", "Data Saved Successfully");
                               addme();
                           }
                           else {
                               toast("Error",response,"");
                           }
                       });
                      
                   }

                   $.fn.rowCount = function () {
                       return $('tr', $(this).find('tbody')).length;
                   };
               </script>
    </asp:Content>
    
