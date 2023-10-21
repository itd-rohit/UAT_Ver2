<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Store/VendorPortal/VendorPortal.master" AutoEventWireup="true" CodeFile="SearchAllPO.aspx.cs" Inherits="Design_Store_VendorPortal_SearchAllPO" %>

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
                          <b>Search All Purchase Order</b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">
                            &nbsp;From Date :
                        </td>
                        <td>
                            <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="font-weight: 700">
                            To Date :
                        </td>
                        <td>
                            <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                         <td style="font-weight: 700">
                             PO Number :
                          </td>
                         <td>
                             <asp:TextBox ID="txtponumber" runat="server" Width="150px" />
                         </td>

                         <td style="font-weight: 700">
                            PO Status :</td>
                        <td>
                           <asp:DropDownList ID="ddlpostatus" runat="server">
                               <asp:ListItem Value="-1" Selected="True">Select</asp:ListItem>
                               <asp:ListItem Value="0" >New</asp:ListItem>
                               <asp:ListItem Value="1">Accepted</asp:ListItem>
                               <asp:ListItem Value="2">Issued</asp:ListItem>
                                 <asp:ListItem Value="3">Partial GRN</asp:ListItem>
                                 <asp:ListItem Value="4">GRN</asp:ListItem>
                           </asp:DropDownList> </td>

                        <td>
                            <input type="button" class="searchbutton" value="Search" onclick="searchdata()" />
                        </td>
                    </tr>
                  
                </table>
                </div>
              </div>

     <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
              

                     <table style="width:95%">
<tr>
    <td  style="width:250px;">
     <div class="Purchaseheader">
                     Purchase Order Detail
                      </div>   </td>

    <td>
<table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>

                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Accepted</td>
                      
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Issued</td>
                       <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Partial GRN</td>
                       <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #00FFFF;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>GRN</td>
                </tr>
            </table>
    </td>

    <td style="width:250px;text-align:right;">
         
    </td>
</tr>
                     </table>
                  
                      

                   
                   
             
                
                 <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:80px;">View Item</td>
                                      
                                        <td class="GridViewHeaderStyle">PO Number</td>
                                        <td class="GridViewHeaderStyle">PO Date</td>
                                        <td class="GridViewHeaderStyle">PO Status</td>

                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">Contact Person</td>
                                        <td class="GridViewHeaderStyle">Contact No</td>
                                        <td class="GridViewHeaderStyle">Gross Amt</td>
                                        <td class="GridViewHeaderStyle">Disc Amt</td>
                                        <td class="GridViewHeaderStyle">Tax Amt</td>
                                        <td class="GridViewHeaderStyle">Net Amt</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Comm ent</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Print PO</td>
                                       
                                        
                                     
                        </tr>
                </table>

                </div>

                           
                </div>

          
             </div>

        </div>


    <script type="text/javascript">

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
        function searchdata() {




            var fromdate = $('#<%=txtFromDate.ClientID%>').val();
            var todate = $('#<%=txtToDate.ClientID%>').val();
            var postatus = $('#<%=ddlpostatus.ClientID%>').val();

            $.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "SearchAllPO.aspx/SearchData",
                data: '{fromdate:"' + fromdate + '",todate:"' + todate + '",postatus:"' + postatus + '",ponumber:"' + $('#<%=txtponumber.ClientID%>').val() + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData == "-1") {
                     
                        showerrormsg('Your Session Expired.... Please Login Again');
                        $.blockUI();
                        return;

                    }

                    if (ItemData.length == 0) {
                     
                        showerrormsg("No Purchase Order Found");
                        $.unblockUI();
                        return;

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='height:30px; background-color:" + ItemData[i].rowColor + ";' id='" + ItemData[i].PurchaseOrderID + "'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>';

                            mydata += '<td class="GridViewLabItemStyle" ><a title="Click Plus To Show Item" style="font-weight:bold;color:blue;" > ' + ItemData[i].PurchaseOrderNo + '</a></td>';

                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PODate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" >' + ItemData[i].postatus + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" >' + ItemData[i].Location + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ContactPerson + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ContactPersonNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].GrossTotal, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].DiscountOnTotal, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].TaxAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' +Math.round( precise_round(ItemData[i].NetTotal, 5)) + '</td>';

                       
                            mydata += '<td class="GridViewLabItemStyle"   > ';
                            if (ItemData[i].vendorcomment == "") {
                                mydata += '<img title="Click To View/Add Comment" src="../../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="addcommentpowise(this)" /> ';
                            }
                            else {
                                mydata += '<img title="' + ItemData[i].vendorcomment + '" src="../../../App_Images/Redplus.png" style="cursor:pointer;" onclick="addcommentpowise(this)" /> ';
                            }
                            mydata += '</td>';

                            mydata += '<td class="GridViewLabItemStyle" title="Click To View Item"  ><img src="../../../App_Images/print.gif" style="cursor:pointer;" onclick="printPO(this)" />  </td>';

                            mydata += '<td class="GridViewLabItemStyle" id="pono" style="display:none;">' + ItemData[i].PurchaseOrderNo + '</td>';
                            mydata += "</tr>";


                            $('#tblitemlist').append(mydata);

                        }
                       
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });

        }


        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }



        function printPO(ctrl) {

            var PurchaseOrderID = $(ctrl).closest('tr').attr("id");
            PageMethods.encryptPurchaseOrderID("1", PurchaseOrderID, onSucessPrint, onFailurePrint);

        }
        function onSucessPrint(result) {
            var result1 = jQuery.parseJSON(result);
            window.open('../POReport.aspx?ImageToPrint=' + result1[0] + '&POID=' + result1[1]);
        }
        function onFailurePrint(result) {

        }


        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../../App_Images/plus.png");
                return;
            }
            $.blockUI();

            $.ajax({
                url: "SearchAllPO.aspx/BindItemDetail",
                data: '{POID:"' + id + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $.unblockUI();

                    }
                    else {
                        $(ctrl).attr("src", "../../../App_Images/minus.png");
                        var mydata = "<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>";
                        mydata += '<tr id="trheader" style="background-color:lightslategrey;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;padding-left:4px;">#</td>';
                        mydata += '<td style="width:240px;padding-left:4px;">Item</td>';
                        mydata += '<td style="width:150px;padding-left:4px;">Manufacture</td>';
                        mydata += '<td style="width:150px;padding-left:4px;">Machine</td>';
                        mydata += '<td style="width:100px;padding-left:4px;">PackSize</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Order Qty</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Issue Qty</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Last Issue Qty</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Last Issue Date</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">GRN Qty</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Mismatch Qty</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Rate</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Tax Amt</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">IGST%</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">CGST%</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">SGST%</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Disc Amt</td>';
                        mydata += '<td style="width:80px;padding-left:4px;">Net Amt</td>';
                        mydata += '<td style="width:20px;padding-left:4px;">Comm ent</td>';

                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            mydata += "<tr style='background-color:blanchedalmond;' id='" + ItemData[i].itemid + "'>";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';



                            mydata += '<td style="padding-left:4px;">' + ItemData[i].itemname + '</td>';
                            mydata += '<td style="padding-left:4px;">' + ItemData[i].ManufactureName + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + ItemData[i].machinename + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + ItemData[i].packsize + '</td>';
                            mydata += '<td style="padding-left:4px;" id="orderqty" >' + precise_round(ItemData[i].approvedqty, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].VendorIssueQty, 5) + '</td>';

                            if (ItemData[i].lastissueqty == "") {
                                mydata += '<td style="padding-left:4px;">0</td>';
                                mydata += '<td style="padding-left:4px;"></td>';
                            }
                            else {

                                mydata += '<td style="padding-left:4px;">' + precise_round(ItemData[i].lastissueqty.split('#')[0], 5) + '<br><img title="Click To View Issue Detail" src="../../../App_Images/view.gif" style="cursor:pointer;" onclick="showissuedetail(this)" /></td>';
                                mydata += '<td style="padding-left:4px;">' + ItemData[i].lastissueqty.split('#')[1] + '</td>';
                            }
                            mydata += '<td >' + precise_round(ItemData[i].grnqty, 5) + '</td>';
                            mydata += '<td >' + precise_round(ItemData[i].MisMatchQty, 5) + '</td>';
                          



                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].rate, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].taxamount, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].IGSTPer, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].CGSTPer, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].SGSTPer, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;" >' + precise_round(ItemData[i].discountamount, 5) + '</td>';
                            mydata += '<td style="padding-left:4px;font-weight:bold;" >' + Math.round(precise_round(ItemData[i].netamount, 5)) + '</td>';

                            mydata += '<td  style="padding-left:4px;" > ';
                            if (ItemData[i].vendorcommentitem == "") {
                                mydata += '<img title="Click To View/Add Comment" src="../../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="addcommentitemwise(this)" /> ';
                            }
                            else {
                                mydata += '<img title="' + ItemData[i].vendorcommentitem + '" src="../../../App_Images/Redplus.png" style="cursor:pointer;" onclick="addcommentitemwise(this)" /> ';
                            }
                            mydata += '</td>';


                            mydata += '<td  id="tdpoid" style="display:none;">' + ItemData[i].PurchaseOrderID + '</td>';
                            mydata += '<td  id="tdpono" style="display:none;">' + ItemData[i].PurchaseOrderNo + '</td>';


                            mydata += "</tr>";




                        }
                        mydata += "</table><div>";

                        var newdata = '<tr id="ItemDetail' + id + '"><td colspan="14">' + mydata + '</td></tr>';

                        $(newdata).insertAfter($(ctrl).closest('tr'));


                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });


        }

        function showissuedetail(ctrl) {
            var href = "VendorItemIssueDetail.aspx?POID=" + $(ctrl).closest('tr').find("#tdpoid").text() + "&ItemID=" + $(ctrl).closest('tr').attr("id") + "&PONO=" + $(ctrl).closest('tr').find("#tdpono").text() + "&OrderQty=" + $(ctrl).closest('tr').find("#orderqty").text();
            openmypopup(href);
        }
       

        function addcommentpowise(ctrl) {

            var href = "VendorComment.aspx?POID=" + $(ctrl).closest('tr').attr("id") + "&PONO=" + $(ctrl).closest('tr').find("#pono").text() + "&ItemID=&CType=1";
            openmypopup(href);
        }
        function addcommentitemwise(ctrl) {

            var href = "VendorComment.aspx?POID=" + $(ctrl).closest('tr').find("#tdpoid").text() + "&PONO=" + $(ctrl).closest('tr').find("#tdpono").text() + "&ItemID=" + $(ctrl).closest('tr').attr("id") + "&CType=2";
            openmypopup(href);
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
      
    </script>
</asp:Content>