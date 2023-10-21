<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LocationLocationMappingSI.aspx.cs" Inherits="Design_Store_LocationLocationMappingSI" %>

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
     

          

    </head>
<body>
      
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <form id="form1" runat="server">
     


 

      
       
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">     
        </Ajax:ScriptManager>
         <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-24 " style="text-align:center">
                   <b> Map Location With Location For SI</b>
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
                  </div></div>
          <div class="POuter_Box_Inventory">



           <div class="content">
                <div class="Purchaseheader"> To Location Details</div>

                <div class="row">
                      <div class="col-md-3 ">
                    <label class="pull-left">CentreType  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                    <asp:ListBox ID="lstCentreTypeto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentreto()"></asp:ListBox>

                    </div>

                     <div class="col-md-3 ">
                    <label class="pull-left">Zone  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                  <asp:ListBox ID="lstZoneto" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindStateto($(this).val().toString())"></asp:ListBox>

                    </div>
                    </div>

               <div class="row">
                      <div class="col-md-3 ">
                    <label class="pull-left">State  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                <asp:ListBox ID="lstStateto" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecityto()"></asp:ListBox>

                    </div>

                    <div class="col-md-3 ">
                    <label class="pull-left">City  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
               <asp:ListBox ID="lstCentrecityto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentreto()"></asp:ListBox>

                    </div>
                   </div>
                <div class="row">
                      <div class="col-md-3 ">
                    <label class="pull-left">Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                                                                    <asp:ListBox ID="lstCentreto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindlocationto()"></asp:ListBox>

                    </div>

                      <div class="col-md-3 ">
                    <label class="pull-left">Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                                                                    <asp:ListBox ID="lstlocationto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>

                    </div>
                     </div>
             
                    
               </div>
              </div>


           <div class="POuter_Box_Inventory" style=" text-align:center;">
               <div class="row"><div class="col-md-24 ">
                   <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />
                   <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
                   </div> </div> </div>
              <div class="POuter_Box_Inventory" style=" text-align:center;">
                   <div class="row"><div class="col-md-24 ">
           <div  style="height:200px;overflow:scroll;">
                   <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">From Location</td>
                                        <td class="GridViewHeaderStyle">To Location</td>
                                        <td class="GridViewHeaderStyle">Indent Type</td>
                                        
                                        <td class="GridViewHeaderStyle"><input type="checkbox" onclick="call()" id="hd" />&nbsp;&nbsp;<input onclick="DeleteRows()" type="button" value="Delete" style="cursor:pointer;background-color:pink; font-weight: 700;" /></td>
                                     </tr>
                                 </table></div>

                       </div> </div></div>
             </div>
    
    </form>


    <script type="text/javascript">
        $(function () {
            SearchRecords();
            $('[id*=lstZoneto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });       
            $('[id*=lstStateto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });         
            $('[id*=lstCentreto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });         
            $('[id*=lstlocationto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });          
            $('[id*=lstCentreTypeto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstCentrecityto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });         
            bindcentertype();
            bindZone();
        });
    </script>
    <script type="text/javascript">
        function bindcentertype() {        
            jQuery('#<%=lstCentreTypeto.ClientID%> option').remove();        
            jQuery('#lstCentreTypeto').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery('#lstCentreTypeto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreTypeto"), isClearControl: '' });
            });          
        }
        function bindZone() {      
            jQuery('#<%=lstZoneto.ClientID%> option').remove();         
            jQuery('#lstZoneto').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery('#lstZoneto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZoneto"), isClearControl: '' });
            });           
        }     
        function bindStateto(BusinessZoneID) {
            jQuery('#<%=lstStateto.ClientID%> option').remove();
            jQuery('#lstStatefrom').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    jQuery('#lstStateto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstStateto"), isClearControl: '' });
                });              
            }
            bindCentrecityto();
        }
        function bindCentrecityto() {
            var StateID = jQuery('#lstStateto').val().toString();
            jQuery('#<%=lstCentrecityto.ClientID%> option').remove();
            jQuery('#lstCentrecityto').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery('#lstCentrecityto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecityto"), isClearControl: '' });
            });            
            bindCentreto();
        }
        function bindCentreto() {         
            var StateID = jQuery('#lstStateto').val().toString();
            var TypeId = jQuery('#lstCentreTypeto').val().toString();
            var ZoneId = jQuery('#lstZoneto').val().toString();
            var cityId = jQuery('#lstCentrecityto').val().toString();           
            jQuery('#<%=lstCentreto.ClientID%> option').remove();
            jQuery('#lstCentreto').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentre', { TypeId: TypeId , ZoneId: ZoneId , StateID:  StateID , cityid:  cityId }, function (response) {
                jQuery('#lstCentreto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentreto"), isClearControl: '' });
            });         
            bindlocationto();
        }
        function bindlocationto() {
            var StateID = jQuery('#lstStateto').val().toString();
            var TypeId = jQuery('#lstCentreTypeto').val().toString();
            var ZoneId = jQuery('#lstZoneto').val().toString();
            var cityId = jQuery('#lstCentrecityto').val().toString();
            var centreid = jQuery('#lstCentreto').val().toString();
            jQuery('#<%=lstlocationto.ClientID%> option').remove();
            jQuery('#lstlocationto').multipleSelect("refresh");
            serverCall('LocationLocationMappingSI.aspx/bindlocation', { centreid:  centreid , StateID: StateID , TypeId: TypeId , ZoneId:  ZoneId , cityId:  cityId , locationid: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                jQuery('#lstlocationto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocationto"), isClearControl: '' });
            });         
        }
    </script>
    <script type="text/javascript">
        function SaveData() {
            if ((JSON.stringify($('#lstlocationto').val()) == '[]')) {
                toast("Info", 'Please Select To Location', "");
                $('#lstlocationto').focus();
                return;
            }
            var type = "SI";
            var fromcenterID = $('#<%=ddllocation.ClientID%>').val();
            var tocenterID = $('#<%=lstlocationto.ClientID%>').val().toString();
            serverCall('CenterIndentRight.aspx/SubmitData', { fcenterID: fromcenterID, tcenterID: tocenterID, IndentType: type }, function (response) {
                if (response == "True") {
                    Refresh();
                    SearchRecords();
                    toast("Success", 'Grouping Saved Successfully', "");
                    return;
                }
                else {                   
                    toast("Info", response, "");
                }
            });           
        }
    </script>
    <script type="text/jscript">
        function Refresh() {         
            jQuery('#<%=lstZoneto.ClientID%> option').remove();
            jQuery('#lstZoneto').multipleSelect("refresh");
            jQuery('#<%=lstStateto.ClientID%> option').remove();
            jQuery('#lstStateto').multipleSelect("refresh");
            jQuery('#<%=lstCentreto.ClientID%> option').remove();
            jQuery('#lstCentreto').multipleSelect("refresh");
            jQuery('#<%=lstCentreTypeto.ClientID%> option').remove();
            jQuery('#lstCentreTypeto').multipleSelect("refresh");
            jQuery('#<%=lstlocationto.ClientID%> option').remove();
            jQuery('#lstlocationto').multipleSelect("refresh");
            $(':checkbox').prop('checked', false);
            bindcentertype();
            bindZone();
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
            serverCall('CenterIndentRight.aspx/RemoveData', { Id: data.substr(1, data.length - 1) }, function (response) {
                if (response == "1") {
                    toast("Success", 'Record Deleted successfully', "");
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
            var fromcenterID = $('#<%=ddllocation.ClientID%>').val();
            var tocenterID = $('#<%=lstlocationto.ClientID%>').val().toString();
            $('#tblitemlist tr').slice(1).remove();
            var type = "SI";
            serverCall('CenterIndentRight.aspx/SearchData', { fcenterID: fromcenterID, tcenterID: tocenterID, IndentType: type }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", 'No Item Found', "");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];                       
                        $Tr.push("<tr style='background-color:palegreen;' id='"); $Tr.push( ItemData[i].ID ); $Tr.push("'>");
                        $Tr.push("<td class='GridViewLabItemStyle' >"); $Tr.push( parseInt(i + 1)); $Tr.push("</td>");
                        $Tr.push('<td class="GridViewLabItemStyle"  >'); $Tr.push( ItemData[i].FromCenter); $Tr.push("</td>");
                        $Tr.push('<td class="GridViewLabItemStyle" >' ); $Tr.push( ItemData[i].ToCenter); $Tr.push("</td>");
                        $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push( ItemData[i].IndentType); $Tr.push("</td>");
                        $Tr.push('<td class="GridViewLabItemStyle" align="left"><input type="checkbox" class="mmchk" style="align:centre;margin-left:25px" id="'); $Tr.push(ItemData[i].ID); $Tr.push('"/></td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        jQuery("#tblitemlist").append($Tr);                      
                    }
                }
            });         
        }
        function ExportToExcel() {
            var fromCentre = $('#<%=ddllocation.ClientID%>').val().toString();
            serverCall('CenterIndentRight.aspx/ExportToExcel', { fromCentre: fromCentre }, function (response) {
                if (response == "true") {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast("Info", 'No Record Found', "");
                }
            });                      
        }      
    </script>
</body>
</html>
