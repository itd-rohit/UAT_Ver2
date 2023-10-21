<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TransferQuotationRateMachineWise.aspx.cs" Inherits="Design_Store_TransferQuotationRateMachineWise" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />


    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">



            <b>Transfer Quotation Rate From Machine</b>


        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddllocation" runat="server" class="ddllocation chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="ddltolocation" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>
                </div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Machine   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                                                <asp:DropDownList ID="ddlmachinetransfer" runat="server" class="ddlmachinetransfer chosen-select chosen-container"></asp:DropDownList>
                     </div>
                    <div class="col-md-3">
                    <label class="pull-left">To Machine   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                                                <asp:DropDownList ID="ddlmachinetransferto" runat="server"  class="ddlmachinetransferto chosen-select chosen-container"></asp:DropDownList>

                      </div>

                     
                  </div>
             </div>
                  <div class="POuter_Box_Inventory" style="text-align:center">
                  <input type="button" value="Load Item" class="searchbutton" onclick="LoadItem()" />
                      <input type="button" value="Transfer Rate" class="savebutton" onclick="TransferNow()" />
                      </div>
           
       

        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-24">
                <div style="max-height: 400px; overflow: auto;">
                    <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">
                                <input type="checkbox" onclick="checkall(this)" /></td>

                            <td class="GridViewHeaderStyle">Supplier</td>
                            <td class="GridViewHeaderStyle">Supplier State</td>
                            <td class="GridViewHeaderStyle">MachineName</td>
                            <td class="GridViewHeaderStyle">ItemIDGroup</td>
                            <td class="GridViewHeaderStyle">FromItemID</td>
                            <td class="GridViewHeaderStyle">FromItemName</td>

                            <td class="GridViewHeaderStyle">ToItemID</td>
                            <td class="GridViewHeaderStyle">ToItemName</td>

                            <td class="GridViewHeaderStyle">Rate</td>
                            <td class="GridViewHeaderStyle">DiscountPer</td>
                            <td class="GridViewHeaderStyle">DiscountAmt</td>

                            <td class="GridViewHeaderStyle">IGSTPer</td>
                            <td class="GridViewHeaderStyle">SGSTPer</td>
                            <td class="GridViewHeaderStyle">CGSTPer</td>
                            <td class="GridViewHeaderStyle">GSTAmount</td>
                            <td class="GridViewHeaderStyle">BuyPrice</td>





                        </tr>
                    </table>
                </div>
           </div> </div>
        </div>
    </div>
    <script type="text/javascript">       
        $(function () {
            $('#<%=ddltolocation.ClientID%>').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
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
                     bindlocation();
                     bindmachine();
                     bindtolocation();
                 });
    </script>
    <script type="text/javascript">

        function bindlocation() {

            var dropdown = $("#<%=ddllocation.ClientID%>");
            $("#<%=ddllocation.ClientID%> option").remove();

            serverCall('TransferQuotationRateMachineWise.aspx/bindlocation', {}, function (response) {
                if (JSON.parse(response).length == 0) {
                    dropdown.append($("<option></option>").val("0").html("--No Location Found--"));

                }

                else {
                    dropdown.bindDropDown({ data: JSON.parse(response), valueField: 'deliverylocationid', textField: 'deliverylocationname', defaultValue: 'Select From Location', isSearchAble: '' });

                }
            });



        }


        function bindmachine() {


            var dropdown = $("#<%=ddlmachinetransfer.ClientID%>");
            $("#<%=ddlmachinetransfer.ClientID%> option").remove();

            var dropdown1 = $("#<%=ddlmachinetransferto.ClientID%>");
            $("#<%=ddlmachinetransferto.ClientID%> option").remove();

            serverCall('TransferQuotationRateMachineWise.aspx/bindmachine', {}, function (response) {              
                    dropdown.bindDropDown({ data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName', defaultValue: 'Select From Machine', isSearchAble: '' });
                    dropdown1.bindDropDown({ data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName', defaultValue: 'Select To Machine', isSearchAble: '' });                
            });           
        }

        function bindtolocation() {

            $('#<%=ddltolocation.ClientID%> option').remove();
            $('#<%=ddltolocation.ClientID%>').multipleSelect("refresh");
            serverCall('TransferQuotationRateMachineWise.aspx/bindtolocation', {}, function (response) {
                $('#<%=ddltolocation.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'locationid', textField: 'location', controlID: $('#<%=ddltolocation.ClientID%>') });
            });

            
        }
    </script>

    <script type="text/javascript">



        function LoadItem() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                         $('#tblitemlist tr').slice(1).remove();
                         toast("Error","Please Select From Location");
                         return;
                     }
                     if ($('#<%=ddlmachinetransfer.ClientID%>').val() == "0") {
                         $('#tblitemlist tr').slice(1).remove();
                         toast("Error","Please Select From Machine");
                         return;
                     }

                     if ($('#<%=ddlmachinetransferto.ClientID%>').val() == "0") {
                         $('#tblitemlist tr').slice(1).remove();
                         toast("Error", "Please Select To Machine");
                         return;
                     }

                     if ($('#<%=ddlmachinetransferto.ClientID%>').val() == $('#<%=ddlmachinetransfer.ClientID%>').val()) {
                         $('#tblitemlist tr').slice(1).remove();
                         toast("Error", "From Machine and To Machine can't be same");
                         return;
                     }



                     $('#tblitemlist tr').slice(1).remove();
                   

                     serverCall('TransferQuotationRateMachineWise.aspx/SearchFromRecords', { locationid: $('#<%=ddllocation.ClientID%>').val(), machineid: $('#<%=ddlmachinetransfer.ClientID%>').val(), machineidto: $('#<%=ddlmachinetransferto.ClientID%>').val() }, function (response) {
                         ItemData = jQuery.parseJSON(response);
                         if (ItemData.length == 0) {
                             toast("Error", "No Item Rate Found This Location");
                         }
                         else {
                             for (var i = 0; i <= ItemData.length - 1; i++) {

                                 var color = "palegreen";
                                 if (ItemData[i].ComparisonStatus == "0" || ItemData[i].itemidto == "0") {
                                     color = "white";
                                 }
                                 var $Tr = [];
                                 $Tr.push("<tr style='background-color:");$Tr.push(); $Tr.push(";'>");

                                 $Tr.push("<td class='GridViewLabItemStyle' >");$Tr.push(parseInt(i + 1));$Tr.push("</td>");
                                 if (ItemData[i].ComparisonStatus == "1" && ItemData[i].itemidto != "0") {
                                     $Tr.push('<td class="GridViewLabItemStyle"><input type="checkbox" id="ch" checked="checked" /></td>');
                                 }
                                 else {
                                     $Tr.push('<td class="GridViewLabItemStyle"></td>');
                                 }
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].vendorname);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].VednorStateName);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].MachineName);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tditemidgroup">');$Tr.push(ItemData[i].ItemIDGroup);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tditemid">');$Tr.push(ItemData[i].itemid);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">');$Tr.push(ItemData[i].ItemName);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tditemidto">');$Tr.push(ItemData[i].itemidto);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">');$Tr.push(ItemData[i].itemnameto );$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">' );$Tr.push(ItemData[i].Rate);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].DiscountPer);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].DiscountAmt );$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].IGSTPer);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].SGSTPer);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].CGSTPer);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].GSTAmount);$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(ItemData[i].FinalPrice );$Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" style="display:none;">');$Tr.push(ItemData[i].ComparisonStatus );$Tr.push("</td>");
                                 $Tr.push("</tr>");
                                 $Tr = $Tr.join("");
                                 $('#tblitemlist').append($Tr);
                             }
                         }
                     });                    
                 }

                 function TransferNow() {
                     if ($('#<%=ddllocation.ClientID%>').val() == "0") {

                         toast("Error","Please Select From Location");
                         return;
                     }
                     if ($('#<%=ddlmachinetransfer.ClientID%>').val() == "0") {

                         toast("Error","Please Select From Machine");
                         return;
                     }

                     if ($('#<%=ddlmachinetransferto.ClientID%>').val() == "0") {

                         toast("Error","Please Select To Machine");
                         return;
                     }

                     if ($('#<%=ddlmachinetransferto.ClientID%>').val() == $('#<%=ddlmachinetransfer.ClientID%>').val()) {
                         toast("Error","From Machine and To Machine can't be same");
                         return;
                     }
                     var count = $('#tblitemlist tr').length;
                     if (count == 0 || count == 1) {
                         toast("Error","No Rate Set For Selected Location ");
                         return;
                     }
                     var tolocation = $('#<%=ddltolocation.ClientID%>').val().toString();
                     if (tolocation == "") {
                         toast("Error","Please Select To Location");
                         return;
                     }

                     var itemid = "";

                     $('#tblitemlist tr').each(function () {
                         if ($(this).attr("id") != "triteheader" && $(this).find("#ch").is(':checked')) {
                             itemid += (itemid.length > 0 ? ',' : '') + $(this).find("#tditemidgroup").html();
                         }
                     });
                     if (itemid.length == 0) {
                         toast("Error","Please Select Item To Transfer");
                         return;
                     }

                     serverCall('TransferQuotationRateMachineWise.aspx/TransferRateRecords', { locationid: $('#<%=ddllocation.ClientID%>').val(), machineid: $('#<%=ddlmachinetransfer.ClientID%>').val(), machineidto: $('#<%=ddlmachinetransferto.ClientID%>').val(), tolocation: tolocation, itemidtosave: itemid }, function (response) {

                         if (response == "3") {
                             toast("Error", "You Can Select More Then 20 Location");
                             return;
                         }
                         else if (response == "1") {
                             showmsg("Rate Tranfered Sucessfully");
                             refreshnow();

                         }
                         else {
                             toast("Error", response);
                         }

                     });
                     
                 }
                 function checkall(ctr) {
                     $('#tblitemlist tr').each(function () {
                         if ($(this).attr('id') != "triteheader") {
                             if ($(ctr).is(":checked")) {
                                 $(this).find('#ch').attr('checked', true);
                             }
                             else {
                                 $(this).find('#ch').attr('checked', false);
                             }
                         }
                     });
                 }
    </script>
</asp:Content>

