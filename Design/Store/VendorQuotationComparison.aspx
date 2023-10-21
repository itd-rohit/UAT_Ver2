<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorQuotationComparison.aspx.cs" Inherits="Design_Store_VendorQuotationComparison" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />


   
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
   <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
   </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Supplier Quotation Comparison</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="PatientDetails" class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Detail
                </div>
                <div class="row" id="tab1" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">State   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Centre   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5  ">
                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Location  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:DropDownList ID="lstlocation" runat="server" ClientIDMode="Static"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Item   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:TextBox ID="txtitem" runat="server" Style="text-transform: uppercase;"></asp:TextBox>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Item   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5  ">
                                <asp:Label ID="lblItemName" runat="server"></asp:Label>
                                <asp:Label ID="lblItemGroupID" runat="server" Style="display: none;"></asp:Label>
                                <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left "></label>

                            </div>
                            <div class="col-md-5 ">
                                <asp:CheckBox ID="ch" Text="Only Set Rate" runat="server" Font-Bold="true" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Manufacturer:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Machine:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5  ">
                                <asp:DropDownList ID="ddlMachine" runat="server" onchange="bindTempData('PackSize');"></asp:DropDownList>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Pack Size   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:DropDownList ID="ddlPackSize" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row" style="display: none;">
                            <div class="col-md-3 ">
                                <label class="pull-left ">From Date:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">To Date:   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5  ">
                                <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Pack Size   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 ">
                                <asp:DropDownList ID="DropDownList3" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-10 ">
                                <table width="60%">
                                    <tr>
                                        <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>New</td>
                                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>Rate Set</td>

                                    </tr>
                                </table>
                            </div>
                            <div class="pull-left">
                                <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                                <input type="button" value="Get Excel Data" class="searchbutton" onclick="getexceldata()" title="Only Set Rate Data Will Show" />
                            </div>


                        </div>
                    </div>
                </div>
            </div>

            <div id="Div1" class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Quotation  Detail
                </div>
                <div class="row" id="Div2">
                   
                            <div class="col-md-24 ">
                                <table id="tblitemlist" style="border-collapse: collapse" width="100%">
                                    <tr id="trquuheader">
                                        <td class="GridViewHeaderStyle" style="width: 50px;">S.No.</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">View</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Print</td>
                                        <td class="GridViewHeaderStyle" style="width: 80px;">Set Rate</td>
                                        <td class="GridViewHeaderStyle">Qutationno</td>
                                        <td class="GridViewHeaderStyle">From Date</td>
                                        <td class="GridViewHeaderStyle">From To</td>

                                        <td class="GridViewHeaderStyle">Supplier Name</td>
                                        <td class="GridViewHeaderStyle">Supplier State</td>
                                        <%--   <td class="GridViewHeaderStyle">Delivery State</td>
                                        <td class="GridViewHeaderStyle">Delivery Centre</td>
                                        <td class="GridViewHeaderStyle">Delivery Location</td>--%>
                                        <%--<td class="GridViewHeaderStyle">Item</td>--%>
                                        <td class="GridViewHeaderStyle">Rate</td>
                                        <%--<td class="GridViewHeaderStyle">Qty</td>--%>
                                        <%-- <td class="GridViewHeaderStyle">FreeQty</td>--%>
                                        <td class="GridViewHeaderStyle">Disc %</td>
                                        <td class="GridViewHeaderStyle">IGST %</td>
                                        <td class="GridViewHeaderStyle">CGST %</td>
                                        <td class="GridViewHeaderStyle">SGST %</td>
                                        <td class="GridViewHeaderStyle">Disc Amt.</td>
                                        <td class="GridViewHeaderStyle">GST Amt.</td>
                                        <td class="GridViewHeaderStyle">BuyPrice</td>
                                        <td class="GridViewHeaderStyle">Net Amt.</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    
            </div>

        </div>
    </div>
    <script type="text/javascript">

        $(function () {
            $('#<%=txtitem.ClientID%>')
                           .bind("keydown", function (event) {
                               if (event.keyCode === $.ui.keyCode.TAB &&
                                   $(this).autocomplete("instance").menu.active) {
                                   event.preventDefault();
                               }
                           })
                           .autocomplete({
                               autoFocus: true,
                               source: function (request, response) {
                                   var _temp = [];
                                   _temp.push(serverCall('VendorQuotation.aspx/SearchItem', { itemname: extractLast(request.term), locationidfrom: $('#<%=lstlocation.ClientID%>').val(), itemtype: '' }, function (responsenew) {
                                       jQuery.when.apply(null, _temp).done(function () {
                                           response($.map(jQuery.parseJSON(responsenew), function (item) {
                                               return {
                                                   label: item.ItemNameGroup,
                                                   value: item.ItemIDGroup
                                               }
                                           }))
                                       });
                                   }, '', false));
                               },
                               search: function () {
                                   // custom minLength

                                   var term = extractLast(this.value);
                                   if (term.length < 2) {
                                       return false;
                                   }
                               },
                               focus: function () {
                                   // prevent value inserted on focus
                                   return false;
                               },
                               select: function (event, ui) {


                                   this.value = '';

                                   setTempData(ui.item.value, ui.item.label);
                                   // AddItem(ui.item.value);

                                   return false;
                               },


                           });


            //  bindindenttolocation();

        });
                       function split(val) {
                           return val.split(/,\s*/);
                       }
                       function extractLast(term) {


                           return split(term).pop();
                       }
                       function setTempData(ItemGroupID, ItemGroupName) {
                           $('#<%=lblItemGroupID.ClientID%>').html(ItemGroupID);
                           $('#<%=lblItemName.ClientID%>').html(ItemGroupName);
                           // $('#tblTemp').show();
                           bindTempData('Manufacturer');

                       }

        function bindTempData(bindType) {
            if (bindType == 'Manufacturer') {
                bindManufacturer($('#<%=lblItemGroupID.ClientID%>').html());
            }
            else if (bindType == 'Machine') {
                bindMachine($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val());
            }
            else if (bindType == 'PackSize') {
                bindPackSize($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val(), $("#<%=ddlMachine.ClientID %>").val());
            }

        }

        function bindManufacturer(ItemIDGroup) {
            $("#<%=ddlManufacturer.ClientID %> option").remove();
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=lstlocation.ClientID%>').val().split('#')[0];
            serverCall('VendorQuotation.aspx/bindManufacturer', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup }, function (response) {
                if (JSON.parse(response).length.length > 1)
                    $('#<%=ddlManufacturer.ClientID%>').bindDropDown({ defaultValue: 'Select Manufacturer', data: JSON.parse(response), valueField: 'ManufactureID', textField: 'ManufactureName' });
                else
                    $('#<%=ddlManufacturer.ClientID%>').bindDropDown({ data: JSON.parse(response), valueField: 'ManufactureID', textField: 'ManufactureName' });
                if (JSON.parse(response).length == 1) {
                    bindMachine(ItemIDGroup, JSON.parse(response)[0].ManufactureID);
                }
                else {
                    $("#<%=ddlManufacturer.ClientID %>").focus();
                }
            });
            

        }


        function bindMachine(ItemIDGroup, ManufactureID) {
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=lstlocation.ClientID%>').val().split('#')[0];
            serverCall('VendorQuotation.aspx/bindMachine', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID }, function (response) {
                if (JSON.parse(response).length.length > 1)
                    $('#<%=ddlMachine.ClientID%>').bindDropDown({ defaultValue: 'Select Machine', data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName' });
                else
                    $('#<%=ddlMachine.ClientID%>').bindDropDown({  data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName' });
                if (JSON.parse(response).length == 1) {
                    bindPackSize(ItemIDGroup, ManufactureID, JSON.parse(response)[0].MachineID);
                }
                else {
                    $("#<%=ddlMachine.ClientID %>").focus();
                }
            });

        }

        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=lstlocation.ClientID%>').val().split('#')[0];
            serverCall('VendorQuotation.aspx/bindPackSize', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }, function (response) {
                if (JSON.parse(response).length.length > 1)
                    $('#<%=ddlPackSize.ClientID%>').bindDropDown({ defaultValue: 'Select Pack Size', data: JSON.parse(response), valueField: 'PackValue', textField: 'PackSize' });
                else
                    $('#<%=ddlPackSize.ClientID%>').bindDropDown({ data: JSON.parse(response), valueField: 'PackValue', textField: 'PackSize' });

                if (response.length == 1) {
                    setDataAfterPackSize();

                }
                else if (JSON.parse(response) == 0 || JSON.parse(response).length > 0) {
                    $("#<%=ddlPackSize.ClientID %>").focus();

                }
            });

        }


     function setDataAfterPackSize() {
         if ($("#<%=ddlPackSize.ClientID %>").val() != '') {

             $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);

         }

     }

    </script>

    <script type="text/javascript">
        $(function () {


            $('[id=ddlitem]').multipleSelect({
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



            bindState();


        });


        function bindState() {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            serverCall('VendorQuotationComparison.aspx/bindState', {}, function (response) {
                jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
            });
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val().toString();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
             jQuery('#lstCentre').multipleSelect("refresh");
             serverCall('VendorQuotationComparison.aspx/bindCentre', { StateID: StateID }, function (response) {
                 jQuery('#lstCentre').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), isClearControl: '' });
             });
             bindlocation();
         }

         function bindlocation() {
             var centreid = jQuery('#lstCentre').val().toString();
             jQuery('#<%=lstlocation.ClientID%> option').remove();

             var StateID = jQuery('#lstState').val().toString();
             var TypeId = "";
             var ZoneId = "";
             var cityId = "";
             serverCall('VendorQuotation.aspx/bindlocation', { centreid: centreid, StateID: StateID, TypeId: TypeId, ZoneId: ZoneId, cityId: cityId }, function (response) {
                
                 $('#<%=lstlocation.ClientID%>').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LocationID', textField: 'Location' });
             });
             }
    </script>

    <script type="text/javascript">
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function getexceldata() {
            var location = $('#lstlocation option:selected').val();

            if ($('#<%=lstlocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select  Location", "");
                return false;
            }

            $modelBlockUI();
            $('#tblitemlist tr').slice(1).remove();

            serverCall('VendorQuotationComparison.aspx/GetExcelDate', { location: location }, function (response) {
                var ItemData = response;
                if (ItemData == "false") {
                    toast("Info", "No Data Found", "");
                    $modelUnBlockUI();
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                    $modelUnBlockUI();
                }
            });
        }

        function searchdata() {

            var Items = $('#<%=lblItemID.ClientID%>').html();

            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();

            var location = $('#lstlocation option:selected').val();

            if ($('#<%=lstlocation.ClientID%>').val() == "0") {
                toast("Error", "Please Select  Location", "");

                return false;
            }
            var onlyserate = "0";

            if ($('#<%=ch.ClientID%>').prop('checked') == true) {
                onlyserate = "1";
            }

            $modelBlockUI();
            $('#tblitemlist tr').slice(1).remove();
            var _temp = [];
            _temp.push(serverCall('VendorQuotationComparison.aspx/SearchData', { Item: Items, fromdate: fromdate, todate: todate, location: location, onlyserate: onlyserate }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    if ($ReqData.length == 0) {
                        toast("Info", "No Item Found", "");
                        $modelUnBlockUI();
                    }
                    else {

                        var itemname = "";
                        var co = 0;
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            co = parseInt(co + 1);

                            var $mydata = [];
                            if (itemname != $ReqData[i].ItemName) {
                                $mydata.push("<tr style='background-color:white'><td colspan='18' style='font-weight:bold;'>ItemID:&nbsp;<span style='background-color:aquamarine'> "); $mydata.push($ReqData[i].ItemID); $mydata.push("</span>&nbsp;Item Name:&nbsp;<span style='background-color:aquamarine'> "); $mydata.push($ReqData[i].ItemName); $mydata.push("</span>&nbsp;&nbsp;Location:<span style='background-color:aquamarine'>"); $mydata.push($ReqData[i].DeliveryLocationName); $mydata.push("</span>&nbsp;&nbsp;State:<span style='background-color:aquamarine'>"); $mydata.push($ReqData[i].DeliveryStateName); $mydata.push("</span></td><tr>");
                                itemname = $ReqData[i].ItemName;
                                co = 1;
                            }

                            $mydata.push("<tr style='background-color:"); $mydata.push($ReqData[i].rowcolor); $mydata.push(";' id='"); $mydata.push(co); $mydata.push("'>");
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(co); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetail(this)" /></td>');


                            $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail5" ><img src="../../App_Images/print.GIF" style="cursor:pointer;" onclick="printdetail(this)" /></td>');
                            $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail6" >');
                            if ($ReqData[i].rowcolor == "white") {
                                $mydata.push('<img src="../../App_Images/Approved.jpg" style="cursor:pointer;height:30px;width:30px;" onclick="setrate(this)" />');
                            }
                            $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" id="tdqid"'); $mydata.push($ReqData[i].Qutationno); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push($ReqData[i].fromdate); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push($ReqData[i].todate); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push($ReqData[i].VendorName); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push($ReqData[i].VednorStateName); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].Rate, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].DiscountPer, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].IGSTPer, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].SGSTPer, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].CGSTPer, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].DiscountAmt, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].GSTAmount, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].BuyPrice, 5)); $mydata.push('</td');
                            $mydata.push('<td class="GridViewLabItemStyle" '); $mydata.push(precise_round($ReqData[i].FinalPrice, 5)); $mydata.push('</td');
                            $mydata.push('<td style="display:none;" id="tditemid"'); $mydata.push($ReqData[i].ItemID); $mydata.push('</td');
                            $mydata.push('<td style="display:none;" id="tdlocationid"'); $mydata.push($ReqData[i].DeliveryLocationID); $mydata.push('</td');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery('#tblitemlist').append($mydata);
                        }
                    }
                    $modelUnBlockUI();
                });
            }));

        }

        function printdetail(ctrl) {
            window.open('VendorQutReport.aspx?QutationNo=' + $(ctrl).closest("tr").find('#tdqid').html());
        }


        function showdetail(ctrl) {
            var qid = $(ctrl).closest("tr").find('#tdqid').html();
            openmypopup('ShowvendorQuotationDetail.aspx?QutationNo=' + qid);
        }



        function openmypopup(href) {
            var width = '1100px';

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

        function setrate(ctrl) {

            var qid = $(ctrl).closest("tr").find('#tdqid').html();
            var itemid = $(ctrl).closest("tr").find('#tditemid').html();
            var locationid = $(ctrl).closest("tr").find('#tdlocationid').html();
            if (confirm("Do You Want to Set Rate.?")) {
                serverCall('VendorQuotationComparison.aspx/SetRate', { qid: qid, itemid: itemid, locationid: locationid }, function (response) {
                    toast("Success", "Item Rate Set Sucessfully", "");
                    searchdata();
                });
            }
        }
    </script>
</asp:Content>

