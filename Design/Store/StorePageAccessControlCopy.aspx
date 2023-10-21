<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StorePageAccessControlCopy.aspx.cs" Inherits="Design_Store_StorePageAccessControlCopy" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <title></title>
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />        
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />    
  <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>   
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
  
</head>
<body>   
   
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 1204px; height: 450px;">
            <div class="POuter_Box_Inventory" style="width: 1200px; font-weight: bold;">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    Store Page Access Control  Copy from One Year To Another
               
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <div class="Purchaseheader">Location Detail</div>
                    <div class="POuter_Box_Inventory">
                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">CentreType  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Zone  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                            </div>
                            <div class="col-md-2 ">
                                <label class="pull-left">State  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                            </div>

                            <div class="col-md-2 ">
                                <label class="pull-left">City  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">Centre  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                            </div>
                            <div class="col-md-2 ">
                                <label class="pull-left">Location  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2 ">
                                <label class="pull-left">Form Year  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlyear" runat="server" Width="120px" onchange="createtable()">
                                    <asp:ListItem Value="0">Select Year</asp:ListItem>
                                    <asp:ListItem Value="2019">2019</asp:ListItem>
                                    <asp:ListItem Value="2020">2020</asp:ListItem>
                                    <asp:ListItem Value="2021">2021</asp:ListItem>
                                    <asp:ListItem Value="2022">2022</asp:ListItem>
                                    <asp:ListItem Value="2023">2023</asp:ListItem>
                                    <asp:ListItem Value="2024">2024</asp:ListItem>
                                    <asp:ListItem Value="2025">2025</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2 ">
                                <label class="pull-left">To Year  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                               
                                <asp:DropDownList ID="ddlyearto" runat="server" Width="120px" onchange="createtableto()">
                                    <asp:ListItem Value="0">Select Year</asp:ListItem>
                                    <asp:ListItem Value="2019">2019</asp:ListItem>
                                    <asp:ListItem Value="2020">2020</asp:ListItem>
                                    <asp:ListItem Value="2021">2021</asp:ListItem>
                                    <asp:ListItem Value="2022">2022</asp:ListItem>
                                    <asp:ListItem Value="2023">2023</asp:ListItem>
                                    <asp:ListItem Value="2024">2024</asp:ListItem>
                                    <asp:ListItem Value="2025">2025</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <input type="button" value="Copy Now" class="savebutton" onclick="copynow()" />
                            </div>
                        </div>
                        <div class="row" style="margin-bottom:15px">
                            <div class="col-md-12 ">
                                <div class="Purchaseheader">From  Year  Detail</div>
                                <br />
                                <table id="tblitemlist" style="border-collapse: collapse; text-align: left;">
                                    <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Sr.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 80px;">Year</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Month</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">From Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">To Date</td>
                                    </tr>
                                </table>
                            </div>


                            <div class="col-md-12 ">
                                <div class="Purchaseheader">To  Year  Detail</div>
                                <br />
                                <table id="tblitemlistto" style="border-collapse: collapse; text-align: left;">
                                    <tr id="tr1">

                                        <td class="GridViewHeaderStyle" style="width: 20px;">Sr.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 80px;">Year</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Month</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">From Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">To Date</td>
                                    </tr>
                                </table>


                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        $(function () {
            $('[id=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id=ListCentre]').multipleSelect({
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
            bindcentertype();
            bindZone();

        });
    </script>
    <script type="text/javascript">
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery("#lstCentreType").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: jQuery("#lstCentreType") });
            });
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery("#lstZone").bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery("#lstZone") });
            });

        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
             jQuery('#lstState').multipleSelect("refresh");
             if (BusinessZoneID != "") {
                 serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                     jQuery("#lstState").bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery("#lstState") });
                 });
             }
             bindCentrecity();
         }

         function bindCentrecity() {
             var StateID = jQuery('#lstState').val();
             jQuery('#<%=lstCentrecity.ClientID%> option').remove();
                jQuery('#lstCentrecity').multipleSelect("refresh");
                if (StateID != "") {
                    serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID.toString() }, function (response) {
                        jQuery("#lstCentrecity").bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: jQuery("#lstCentrecity") });
                    });

                    bindCentre();
                }
            }

            function bindCentre() {
                var StateID = jQuery('#lstState').val();
                var TypeId = jQuery('#lstCentreType').val();
                var ZoneId = jQuery('#lstZone').val();
                var cityId = jQuery('#lstCentrecity').val();
                jQuery('#<%=lstCentre.ClientID%> option').remove();
                jQuery('#lstCentre').multipleSelect("refresh");
                if (TypeId != "") {
                    serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId.toString(), ZoneId: ZoneId.toString(), StateID: StateID.toString(), cityid: cityId.toString() }, function (response) {
                        jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery("#lstCentre") });
                    });
                }
                bindlocation();
            }

            function bindlocation() {
                var StateID = jQuery('#lstState').val();
                var TypeId = jQuery('#lstCentreType').val();
                var ZoneId = jQuery('#lstZone').val();
                var cityId = jQuery('#lstCentrecity').val();
                var centreid = jQuery('#lstCentre').val();
                jQuery('#<%=lstlocation.ClientID%> option').remove();
                jQuery('#lstlocation').multipleSelect("refresh");
                serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid: centreid.toString(), StateID: StateID.toString(), TypeId: TypeId.toString(), ZoneId: ZoneId.toString(), cityId: cityId.toString() }, function (response) {
                    jQuery("#lstlocation").bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: jQuery("#lstlocation") });
                });
            }

    </script>



    <script type="text/javascript">
        function createtable() {
            var locationid = $('#<%=lstlocation.ClientID%>').val();
            if (locationid == "") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddlyear.ClientID%>').val('0');
                return;
            }
            $('#tblitemlist tr').slice(1).remove();
            var year = $('#<%=ddlyear.ClientID%>').val();
            var locationid = 0;
            $('#<%=lstlocation.ClientID%> > option:selected').each(function () {
                locationid = $(this).val();
                return;
            });
            if ($('#<%=ddlyear.ClientID%>').val() != "0") {
                serverCall('StorePageAccessControl.aspx/getdata', { year: year, locationid: locationid }, function (response) {

                    ItemData = jQuery.parseJSON(response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var id = ItemData[i].entrymonth + "_" + ItemData[i].entryyear;
                        var $myData = [];
                        $myData.push("<tr style='background-color:lightgreen;' id='" ); $myData.push( id ); $myData.push( "'>");
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdmonth" style="font-weight:bold;">' ); $myData.push( ItemData[i].entrymonth ); $myData.push('</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdyear" style="font-weight:bold;">' ); $myData.push( ItemData[i].entryyear ); $myData.push( '</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdmonthname" style="font-weight:bold;">' ); $myData.push( ItemData[i].entrymonthname ); $myData.push( '</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="txtfromdate">' ); $myData.push(ItemData[i].fromdate ); $myData.push('</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="txttodate">' ); $myData.push( ItemData[i].todate ); $myData.push( '</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                    }
                });
            }
        }
        function createtableto() {
            var locationid = $('#<%=lstlocation.ClientID%>').val();
            if (locationid == "") {
                toast("Error", "Please Select Location", "");
                $('#<%=ddlyearto.ClientID%>').val('0');
                return;
            }
            $('#tblitemlistto tr').slice(1).remove();
            var year = $('#<%=ddlyearto.ClientID%>').val();
            if ($('#<%=ddlyear.ClientID%>').val() == $('#<%=ddlyearto.ClientID%>').val()) {              
                toast("Error", "From Year and To Year Can't be Same", "");
                $('#<%=ddlyearto.ClientID%>').val('0');
                return;

            }
            var locationid = 0;
            $('#<%=lstlocation.ClientID%> > option:selected').each(function () {
                locationid = $(this).val();
                return;
            });

            if ($('#<%=ddlyearto.ClientID%>').val() != "0") {
                serverCall('StorePageAccessControl.aspx/getdata', { year: year, locationid: locationid }, function (response) {
                    ItemData = jQuery.parseJSON(response);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var id = ItemData[i].entrymonth + "_" + ItemData[i].entryyear;
                        var $myData = [];
                        $myData.push("<tr style='background-color:lightgreen;' id='"); $myData.push(id); $myData.push("'>");
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdmonth" style="font-weight:bold;">' ); $myData.push( ItemData[i].entrymonth ); $myData.push('</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdyear" style="font-weight:bold;">' ); $myData.push(ItemData[i].entryyear ); $myData.push( '</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="tdmonthname" style="font-weight:bold;">' ); $myData.push( ItemData[i].entrymonthname ); $myData.push( '</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="txtfromdate">' ); $myData.push( ItemData[i].fromdate ); $myData.push( '</td>');
                        $myData.push( '<td class="GridViewLabItemStyle" id="txttodate">' ); $myData.push( ItemData[i].todate ); $myData.push('</td>');
                        $myData.push( "</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlistto').append($myData);
                    }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function getdata() {
            var dataIm = new Array();
            $('#<%=lstlocation.ClientID%> > option:selected').each(function () {
                var locationid = $(this).val();
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {
                        var ProData = new Object();
                        ProData.LocationID = locationid;
                        ProData.EntryYear = $('#<%=ddlyearto.ClientID%>').val();
                        ProData.EntryMonth = $(this).closest("tr").find('#tdmonth').html();
                        ProData.EntryMonthName = $(this).closest("tr").find('#tdmonthname').html();
                        ProData.FromDate = $(this).closest("tr").find('#txtfromdate').html().replace($('#<%=ddlyear.ClientID%>').val(), $('#<%=ddlyearto.ClientID%>').val());
                        ProData.ToDate = $(this).closest("tr").find('#txttodate').html().replace($('#<%=ddlyear.ClientID%>').val(), $('#<%=ddlyearto.ClientID%>').val());
                        dataIm.push(ProData);
                    }
                });
            });
            return dataIm;
        }
        function copynow() {
            var locationid = $('#<%=lstlocation.ClientID%>').val();
            if (locationid == "") {
                toast("Error", "Please Select Location", "");
                return;
            }
            if ($('#<%=ddlyearto.ClientID%>').val() == "0") {
                toast("Error", "Please Select To Year",'');
                $('#<%=ddlyearto.ClientID%>').val('0');
                return;

            }
            if ($('#<%=ddlyear.ClientID%>').val() == $('#<%=ddlyearto.ClientID%>').val()) {
                toast("Error", "From Year and To Year Can't be Same",'');
                $('#<%=ddlyearto.ClientID%>').val('0');
                return;
            }
            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "No Data To Copy ",'');
                return;
            }
            var datatosave = getdata();

            if (datatosave.length == 0) {
                toast("Error","Please Select Year",'');                return;
            }
            var count = $('#tblitemlistto tr').length;
            if (count > 1) {
                toast("Error","Data Already Saved for " + $('#<%=ddlyearto.ClientID%>').val(),'');
                return;
            }

            serverCall('StorePageAccessControl.aspx/savedata', { datatosave: datatosave }, function (response) {
                if (response == "1") {
                    toast("Success", "Data Copy Successfully",'');
                    createtableto();
                }
                else {
                    showerrormsg(response);
                }
            });
        }
    </script>
</body>
</html>
