<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreAutoIndent.aspx.cs" Inherits="Design_Store_StoreAutoIdent" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server"> 
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

   
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align:center">
             <b>Store Auto Indent</b>
        </div>
        <div class="POuter_Box_Inventory" style="display:none;">
          
                <div class="Purchaseheader">Location Details</div>



             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">CentreType  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>

                     </div>

                  <div class="col-md-3">
                    <label class="pull-left">Zone  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>

                     </div>
                     <div class="col-md-3">
                    <label class="pull-left">State  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>

                     </div>

                  </div>

             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">City  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>

                    </div>
                  <div class="col-md-3">
                    <label class="pull-left">Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>

                     </div>
                  <div class="col-md-3">
                    <label class="pull-left">Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>

                    </div>

                     </div>
                

            
        </div>
        <div class="POuter_Box_Inventory" style="display:none;">
           
                <div class="Purchaseheader">
                    Item Detail
                </div>


                 <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>

                     </div>
                       <div class="col-md-3">
                    <label class="pull-left">SubCategory Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox>

                     </div>
                       <div class="col-md-3">
                    <label class="pull-left">Item Category  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>

                     </div>
                     </div>
                   <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Items</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>

                    </div>
                       </div>
               
          
        </div>

        <div class="POuter_Box_Inventory" >

         
                <div class="Purchaseheader">
                    Search  Date
                </div>


                 <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                     <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </div>
                      <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>

 </div>
                      <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Indent Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <b><asp:RadioButtonList ID="rdoIndentType" runat="server"  RepeatDirection="Horizontal" Enabled="false">
                              <asp:ListItem Text="SI" Value="SI" Selected="True"></asp:ListItem>
                              <asp:ListItem Text="PI" Value="PI"></asp:ListItem>
                             </asp:RadioButtonList></b>  
              
            </div>
 </div>
        </div>




        <div class="POuter_Box_Inventory" style=" text-align: center;">
            <div class="row">
                <div class="col-md-24">
             <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
               
                <span class="required btnmin" style="display:none;">Expected Date :</span>
               <asp:TextBox ID="txtexpecteddate" runat="server" width="82" TabIndex="-1" Class="btnmin" style="display:none;"></asp:TextBox>
                <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtexpecteddate" Format="dd-MMM-yyyy" runat="server">
                                    </cc1:CalendarExtender>
                                      

            <input class="savebutton btnmin"  type="button" value="Create Indent"  onclick="saveindent()" style="display:none;" /></div>
      
                </div>
        </div>

         <div class="POuter_Box_Inventory" >

           
                <div class="Purchaseheader">
                    All Items
                </div>
              <div class="row">
                <div class="col-md-24">
        <div style="height: 200px; overflow: scroll;">
            <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                <tr id="triteheader">
                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                    <td class="GridViewHeaderStyle">Location</td>
                    <td class="GridViewHeaderStyle">Item</td>
                    <td class="GridViewHeaderStyle">Event Type</td>
                    <td class="GridViewHeaderStyle">Consume Quantity</td>
                    <td class="GridViewHeaderStyle">Buffer Percentage</td>
                    <td class="GridViewHeaderStyle">Waste Percentage</td>
                    <td class="GridViewHeaderStyle">Average Consumption</td>
                    <td class="GridViewHeaderStyle">InHand Quantity</td>
                    <td class="GridViewHeaderStyle">Indent Quantity</td>
                    <td class="GridViewHeaderStyle">Action</td>
                </tr>
            </table>

            
        </div>

      </div></div>
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
                });
             $('[id*=lstlocation]').multipleSelect({
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
    </script>


     <script type="text/javascript">
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

                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', {}, function (response) {
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

                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', {}, function (response) {
                    jQuery('#ddlcategory').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
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
                    serverCall('MappingStoreItemWithCentre.aspx/binditem', { CategoryTypeId:  CategoryTypeId , SubCategoryTypeId: SubCategoryTypeId , CategoryId: CategoryId  }, function (response) {
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
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });               
            }
            bindCentrecity();
        }

        function bindCentrecity() {
            var StateID = jQuery('#lstState').val();
            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery('#lstCentrecity').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
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

            var centreid = jQuery('#lstCentre').val();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid: centreid, StateID: StateID, TypeId: TypeId, ZoneId: ZoneId, cityId: cityId }, function (response) {
                jQuery('#lstlocation').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
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
           // jQuery('#lstlocation').multipleSelect("refresh");
            $(':checkbox').prop('checked', false);
            bindCatagoryType();
            bindcentertype();
            bindZone();
            $('#tblitemlist tr').slice(1).remove();
            $('.btnmin').hide();
            $('#<%=txtexpecteddate.ClientID%>').val('');
        }
    </script>
    <script type="text/javascript">
        function searchitem() {           
            serverCall('StoreAutoIndent.aspx/SearchData', { location: $('#<%=lstlocation.ClientID%>').val().toString(), item: $('#<%=ddlItem.ClientID%>').val().toString(), fromdate: $('#<%=txtentrydatefrom.ClientID%>').val(), todate: $('#<%=txtentrydateto.ClientID%>').val(), indenttype: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found For Indent");
                    $('#tblitemlist tr').slice(1).remove();
                    $('.btnmin').hide();
                }
                else {
                    $('.btnmin').show();
                    $('#tblitemlist tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var rcol = "";
                        if (ItemData[i].indentqty >= 0) {
                            rcol = "lightgreen";
                        }
                        else {
                            rcol = "lightcoral";
                        }
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:");$Tr.push(rcol);$Tr.push(";' id='");$Tr.push(ItemData[i].itemid); $Tr.push("'>");
                        $Tr.push('<td class="GridViewLabItemStyle" id="sno" >');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="location" >');$Tr.push(ItemData[i].location);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="locationid" style="display:none;" >');$Tr.push(ItemData[i].locationid);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="panelid" style="display:none;" >');$Tr.push(ItemData[i].Panel_ID);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="item" >');$Tr.push(ItemData[i].itemname);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="event" >');$Tr.push(ItemData[i].EventtypeName);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="consume" >');$Tr.push(ItemData[i].consumeqty);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="buffer" >');$Tr.push(ItemData[i].BufferPercentage);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="waste" >');$Tr.push(ItemData[i].WastagePercentage);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="averageconsume" >');$Tr.push(ItemData[i].AverageConsumption);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="inhandqty" >');$Tr.push(ItemData[i].inhandqty);$Tr.push('</td>');
                        if (ItemData[i].indentqty > 0) {
                            $Tr.push('<td class="GridViewLabItemStyle"  ><input type="text" id="inhand" value=');$Tr.push(ItemData[i].indentqty);$Tr.push(' onkeyup="showme(this);" maxlength="10" style="width:60px;"></td>');

                            $Tr.push('<td class="GridViewLabItemStyle" ><input type="checkbox" name="chk" checked></td>');
                        }
                        else {
                            $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].indentqty);$Tr.push('</td>');

                            $Tr.push('<td ></td >');
                        }

                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="mapid" >');$Tr.push(ItemData[i].mapid);$Tr.push('</td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#tblitemlist').append($Tr);
                    }
                }
            });           
        }       
    </script>

    <script type="text/javascript">


        function showme(ctrl) {

            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            //}

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
    </script>
    <script type="text/javascript">
        function getstore_SaveIndentdetail() {
           var dataindent = new Array();
            $('#tblitemlist').find('input[type="checkbox"]:checked').each(function () {      
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {                
                    var objindentMaster = new Object();
                    objindentMaster.IndentNo ="";
                    objindentMaster.ItemId = $(this).closest("tr").attr("id");
                    objindentMaster.ItemName = $(this).closest('tr').find('#item').html();
                    objindentMaster.FromPanelId = $(this).closest('tr').find('#panelid').html();
                    objindentMaster.FromLocationID = $(this).closest('tr').find('#locationid').html();
                    objindentMaster.ToPanelID = 0;
                    objindentMaster.ToLocationID = 0;
                    objindentMaster.ReqQty = $(this).closest('tr').find('input').val();
                    objindentMaster.MinorUnitID =0;
                    objindentMaster.MinorUnitName = "";
                    objindentMaster.Narration = "Auto Indent";
                    objindentMaster.ExpectedDate = $('#<%=txtexpecteddate.ClientID%>').val();
                    objindentMaster.IndentType = $("#<%=rdoIndentType.ClientID%>").find(":checked").val();
                    objindentMaster.FromRights = "";
                    objindentMaster.Rate = 0;
                    objindentMaster.DiscountPer = 0;
                    objindentMaster.TaxPerIGST = 0;
                    objindentMaster.TaxPerCGST = 0;
                    objindentMaster.TaxPerSGST = 0;
                    objindentMaster.ApprovedQty =0;
                    objindentMaster.CheckedQty = 0;
                    objindentMaster.NetAmount = 0;
                    objindentMaster.UnitPrice = 0;
                    objindentMaster.Vendorid = 0;
                    objindentMaster.VendorStateId = 0;
                    objindentMaster.VednorStateGstnno = "";
                    objindentMaster.MaxQty =0;
                    objindentMaster.mapid = $(this).closest('tr').find('#mapid').html() + "#" + $(this).closest('tr').find('#event').html();                   
                    dataindent.push(objindentMaster);
                }
            });
            return dataindent;
        }
        function saveindent() {       
            var store_SaveIndentdetail = getstore_SaveIndentdetail();
            if (store_SaveIndentdetail.length == 0) {
                toast("Error", "Please Select Item To Create Indent");
                return;
            }
            if ($('#<%=txtexpecteddate.ClientID%>').val() == "") {
                toast("Error", "Please Select Expected date");
                $('#<%=txtexpecteddate.ClientID%>').focus();
                return false;
            }
            serverCall('StoreAutoIndent.aspx/saveindent', { store_SaveIndentdetail: store_SaveIndentdetail }, function (response) {
                if (response.split('#')[0] == "1") {
                    toast("Success", "Indent Saved Successfully..!");
                    Refresh();
                }
                else {
                    toast("Error", response.split('#')[1]);
                }
            });        
        }
    </script>

</asp:Content>

