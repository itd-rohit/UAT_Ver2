<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GRNReprint.aspx.cs" Inherits="Design_Store_GRNReprint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <%: Scripts.Render("~/bundles/JQueryStore") %>
     
      
    
     <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory"  style="text-align:center">         
                          <b>GRN Status</b>                        
              </div>
         <div class="POuter_Box_Inventory">            
                    
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">GRN Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddllocation" runat="server" ></asp:DropDownList>
</div>
                 <div class="col-md-2">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                      <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                  <div class="col-md-2">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                     <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                 <div class="col-md-2">
                    <label class="pull-left">Supplier   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlvendor" class="ddlvendor chosen-select chosen-container" runat="server" ></asp:DropDownList>

                     </div>

                  </div>
              <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">PO No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtponumber" runat="server" Width="160px"></asp:TextBox>
                     </div>

                   <div class="col-md-3">
                    <label class="pull-left">Invoice/Challan No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtinvoiceno" runat="server" Width="160px"></asp:TextBox>

                    </div>

                   <div class="col-md-2">
                    <label class="pull-left">GRN No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtgrnno" runat="server" Width="160px"></asp:TextBox>
                    </div>

                  </div>

             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">GRN Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:DropDownList ID="ddlGRNType" runat="server"   Width="160px">
                            <asp:ListItem Selected="True" Text="All" Value="All" />
                            <asp:ListItem Text="Non-Posted" Value="0" />
                            <asp:ListItem Text="Posted" Value="1" />
                            <asp:ListItem Text="Cancel" Value="3" />
                        </asp:DropDownList>
                     </div>

                 <div class="col-md-5">
                      <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />       
                     </div>

                  <div class="col-md-11">
<table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>

                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Posted</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Un-Posted</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Cancel</td>
                </tr>
            </table>
                      </div>
                  </div>


              
              </div>


         <div class="POuter_Box_Inventory" >
         
                 <div class="Purchaseheader">
                     GRN Detail
                      </div>
              <div class="row">
                <div class="col-md-24">
                 <div style="width:100%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:50px;">View Item</td>
                                        <td class="GridViewHeaderStyle">GRN No.</td>
                                        <td class="GridViewHeaderStyle">PO No.</td>
                                        <td class="GridViewHeaderStyle">Invoice No.</td>
                                        <td class="GridViewHeaderStyle">Challan No.</td>
                                        <td class="GridViewHeaderStyle">Supplier</td>
                                        <td class="GridViewHeaderStyle">GRN Date</td>                                      
                                        <td class="GridViewHeaderStyle">Gross Amt.</td>
                                        <td class="GridViewHeaderStyle">Disc Amt.</td>
                                        <td class="GridViewHeaderStyle">Tax Amt.</td>
                                        <td class="GridViewHeaderStyle">GRN/Net Amt.</td>                                      
                                        <td class="GridViewHeaderStyle">Post</td>
                                        <td class="GridViewHeaderStyle">UnPost</td>
                                        <td class="GridViewHeaderStyle">Cancel</td>
                                        <td class="GridViewHeaderStyle">Print</td>
                                        <td class="GridViewHeaderStyle">Doc</td>
                                        <td class="GridViewHeaderStyle">Edit</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Bar Code</td>                                                                                                                   
                        </tr>
                </table>
                </div>
                </div>   
                  </div>        
             </div>        
         </div>
    <div id="popup_box" style="background-color:lightgreen;height:80px;text-align:center;width:340px;">
    <div id="showpopupmsg" style="font-weight:bold;"></div>
             <br />
        <span id="GRNID" style="display:none;"></span><span id="type" style="display:none;"></span>
             <input type="button" class="searchbutton" value="Yes"  onclick="Post();" />
              <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>

    <script type="text/javascript">
        var CanUnpost = '<%=CanUnpost %>';
        var CanCancel = '<%=CanCancel %>';
        
        var filename = "";
        function openmypopup(href) {

           

            
            var width = '1240px';

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

        function unloadPopupBox() {    // TO Unload the Popupbox
            $('#GRNID').html('');
            $('#type').html('');
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });
        }


        $(document).ready(function () {


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
            bindvendor();


        });

        function bindvendor() {


            var dropdown = $("#<%=ddlvendor.ClientID%>");
            $("#<%=ddlvendor.ClientID%> option").remove();

            serverCall('Services/StoreCommonServices.asmx/bindsupplier', {}, function (response) {
                if (JSON.parse(response).length == 0) {
                    dropdown.append($("<option></option>").val("0").html("--No Supplier Found--"));
                    dropdown.trigger('chosen:updated');
                }
                else
                    dropdown.bindDropDown({ defaultValue: 'Select Supplier', data: JSON.parse(response), valueField: 'supplierid', textField: 'suppliername', isSearchAble: true });

            });
           
        }
    </script>

    <script type="text/javascript">
        function searchdata() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }
            var location = $("#<%=ddllocation.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var supplier = $("#<%=ddlvendor.ClientID%>").val();
            var ponumber = $("#<%=txtponumber.ClientID%>").val();
            var invoiceno = $("#<%=txtinvoiceno.ClientID%>").val();
            var grnno = $("#<%=txtgrnno.ClientID%>").val();
            var grnstatus = $("#<%=ddlGRNType.ClientID%>").val();        
            $('#tblitemlist tr').slice(1).remove();
            serverCall('GRNReprint.aspx/SearchData', {location:location,fromdate:fromdate,todate:todate,supplier:supplier,ponumber:ponumber,invoiceno:invoiceno,grnno:grnno,grnstatus:grnstatus}, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No GRN Found","");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        $myData.push("<tr style='background-color:");$myData.push(ItemData[i].rowColor);$myData.push(";' id='");$myData.push(ItemData[i].LedgerTransactionID); $myData.push("'>");
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        if (ItemData[i].IsDirectGRN == "1") {
                            $myData.push('<td title="Direct GRN" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:aqua;font-weight:bold;">');$myData.push(ItemData[i].LedgerTransactionNo);$myData.push('</td>');
                        }
                        else {
                            $myData.push('<td title="GRN Against PO" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:green;font-weight:bold;color:white;">');$myData.push(ItemData[i].LedgerTransactionNo);$myData.push('</td>');
                        }
                        if (ItemData[i].IsDirectGRN == "1") {

                            $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].PurchaseOrderNo); $myData.push('</td>');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" ><a style="color:blue;cursor:pointer;font-weight:bold;" onclick="showpo(\''); $myData.push( ItemData[i].PurchaseOrderNo);$myData.push('\')">'); $myData.push(ItemData[i].PurchaseOrderNo);$myData.push('<a></td>');
                        }
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push(ItemData[i].InvoiceNo); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].ChalanNo); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].SupplierName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].GRNDate); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >' );$myData.push( precise_round(ItemData[i].GrossAmount, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >' );$myData.push( precise_round(ItemData[i].DiscountOnTotal, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( precise_round(ItemData[i].TaxAmount, 5)); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( precise_round(ItemData[i].NetAmount, 5)); $myData.push('</td>');
                          
                        $myData.push('<td class="GridViewLabItemStyle" >');

                        if (ItemData[i].isPost == "0") {
                            $myData.push('<img src="../../App_Images/Post.gif" style="cursor:pointer;" onclick="PostDialog(this,\'1\');" />');
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].isPost == "1" && CanUnpost=="1") {
                            $myData.push('<img src="../../App_Images/Reject.png" style="cursor:pointer;" onclick="PostDialog(this,\'0\');" />');
                        }
                        
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].isPost == "0" && CanCancel=="1") {
                            $myData.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="PostDialog(this,\'3\');" />');
                        }

                        $myData.push('</td>');                          
                        $myData.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" />  </td>');
                        $myData.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/folder.gif" style="cursor:pointer;" onclick="viewdoc(this)" />  </td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].isPost == "0") {                              
                            if (ItemData[i].IsDirectGRN == "1") {
                                $myData.push('<img src="../../App_Images/edit.png" style="cursor:pointer;"  onclick="editgrn(this)" />');
                            }
                            else {
                                $myData.push('<img src="../../App_Images/edit.png" style="cursor:pointer;"  onclick="editgrnpo(this)" />');
                            }
                        }
                        $myData.push('</td>');                           
                        $myData.push('<td class="GridViewLabItemStyle" >');
                        if (ItemData[i].isPost != "3") {
                            $myData.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printmebarcode(this)" />');
                        }
                        $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                    }                   
                }
            });          
        }
        function showpo(ponumber) {
            PageMethods.encryptPurchaseOrderID("1", ponumber, onSucessPrint, onFailurePrint);
        }
        function onSucessPrint(result) {
            var result1 = jQuery.parseJSON(result);           
            window.open('POReport.aspx?ImageToPrint=' + result1[0] + '&POID=' + result1[1]);
        }
        function onFailurePrint(result) {

        }     
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function viewdoc(ctrl) {
            openmypopup('AddGRNDocument.aspx?GRNNo=' + $(ctrl).closest('tr').attr("id"));
        }

        function editgrn(ctrl) {
            openmypopup('DirectGrnEdit.aspx?GRNID=' + $(ctrl).closest('tr').attr("id"));
        }
        function editgrnpo(ctrl) {
            openmypopup('GrnFromPOEdit.aspx?GRNID=' + $(ctrl).closest('tr').attr("id"));
        }

        function printme(ctrl) {
            window.open('GRNReceipt.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id"));
        }
        function printmebarcode(ctrl) {
            openmypopup('GRNPrintbarcode.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id")); 
           //  window.open('GRNPrintbarcode.aspx?GRNNO=' + $(ctrl).closest('tr').attr("id")); 			
        }      
        function showdetail(ctrl) {
            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            serverCall('GRNReprint.aspx/BindItemDetail', { GRNID: id }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Info", "No GRN Found","");

                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");

                    var $myData = [];
                    $myData.push("<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>");
                    $myData.push('<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                    $myData.push('<td  style="width:20px;">#</td>');
                    $myData.push('<td>Item Name</td>');
                    $myData.push('<td>BarcodeNo</td>');
                    $myData.push('<td>Batch Number</td>');
                    $myData.push('<td>Expiry Date</td>');
                    $myData.push('<td>Rate</td>');
                    $myData.push('<td>Disc %</td>');
                    $myData.push('<td>Tax%</td>');
                    $myData.push('<td>Converter</td>');
                    $myData.push('<td>Unit Price</td>');
                    $myData.push('<td>Total Price</td>');
                    $myData.push('<td>Paid Qty</td>');
                    $myData.push('<td>Free Qty</td>');
                    $myData.push('<td>InHand Qty</td>');
                    $myData.push('<td>Unit</td>');


                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $myData.push("<tr style='background-color:#70e2b3;' id='"); $myData.push(ItemData[i].stockid); $myData.push("'>");
                        $myData.push('<td >'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                        $myData.push('<td >'); $myData.push(ItemData[i].itemname); $myData.push('</td>');
                        $myData.push('<td >'); $myData.push(ItemData[i].barcodeno); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(ItemData[i].batchnumber); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(ItemData[i].ExpiryDate); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].rate, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].discountper, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].taxper, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].converter, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].price, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].unitprice, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].PaidQty, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].freeQty, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(precise_round(ItemData[i].initialcount, 5)); $myData.push('</td>');
                        $myData.push('<td  >'); $myData.push(ItemData[i].MajorUnit); $myData.push('</td>');
                        $myData.push("</tr>");
                    }
                    $myData.push("</table><div>");
                    $myData = $myData.join("");
                    var $newdata = [];
                    $newdata.push('<tr id="ItemDetail'); $newdata.push(id); $newdata.push('"><td colspan="18">'); $newdata.push($myData); $newdata.push('</td></tr>');
                    $newdata = $newdata.join("");
                    $newdata.insertAfter($(ctrl).closest('tr'));
                }
            });

           
           
        }
        function PostDialog(ctrl, type)
        {
            $('#showpopupmsg').show();
            if (type == "1")
                $('#showpopupmsg').html("Do You Want To Post?");
            else if (type == "0")
                $('#showpopupmsg').html("Do You Want To UnPost?");
            else
                $('#showpopupmsg').html("Do You Want To Cancel?");          
            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            var id = $(ctrl).closest('tr').attr("id");
            $('#GRNID').html(id);
            $('#type').html(type);        
        }
        function Post() {
           var id=$('#GRNID').html();
           var type = $('#type').html();
           serverCall('GRNReprint.aspx/Post', { GRNID: id, type: type }, function (response) {
               if (response.split('#')[0] == "1") {
                   if (type == "1")
                   toast("Error", "GRN Post Sucessfully","");
                   else if (type == "0")
                   toast("Error", "GRN UnPost Sucessfully","");
                   else
                       toast("Error", "GRN Cancel Sucessfully","");
                   unloadPopupBox();
                   searchdata();
               }
               else if (response.split('#')[0] == "2") {
                   toast("Error", "Item Already Issued You Can Not UnPost Or Cancel","");
                   unloadPopupBox();
               }
               else {
                   toast("Error", response.split('#')[1],"");
                   unloadPopupBox();
               }
           });          
        }      
    </script>
</asp:Content>

