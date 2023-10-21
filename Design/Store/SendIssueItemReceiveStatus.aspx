<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SendIssueItemReceiveStatus.aspx.cs" Inherits="Design_Store_SendIssueItemReceiveStatus" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />   
     <%: Scripts.Render("~/bundles/JQueryStore") %>  
        <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align: center">            
               <b>Material Delivery Location Update</b>                         
              </div>
             <div class="POuter_Box_Inventory">                                         
                 <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Current Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddllocation" runat="server"  ></asp:DropDownList>
 </div>

                      <div class="col-md-2">
                    <label class="pull-left">Date From  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                     <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                      <div class="col-md-2">
                    <label class="pull-left">Date To  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                       <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                      <div class="col-md-3">
                    <label class="pull-left">Batch Number</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <asp:TextBox ID="txtbatchnumber" runat="server"></asp:TextBox>
                       </div>

                      </div>

                 <div class="col-md-10" style="text-align:right">
                   <input type="button" value="Search" class="searchbutton" onclick="searchbatch()" />
                </div>
                <div class="col-md-14">
                    <table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Dispatched</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Delivered</td>

                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Received</td>                     
                </tr>
            </table>
                     </div>
                  </div>                          
            <div class="POuter_Box_Inventory" >           
                 <div class="Purchaseheader">
                    Issue Detail
                      </div>
                 <div class="row">
                <div class="col-md-24">
                 <div style="width:100%;height:200px;overflow:auto;">
                <table id="tblbatch" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">                                       
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:80px;">View Detail</td>
                                        <td class="GridViewHeaderStyle">Batch No.</td>
                                        <td class="GridViewHeaderStyle">Batch CreatedDate</td>
                                        <td class="GridViewHeaderStyle">Batch CreatedBy</td>
                                        <td class="GridViewHeaderStyle">Dispatch Date</td>
                                        <td class="GridViewHeaderStyle">Dispatch By</td>
                                        <td class="GridViewHeaderStyle">Dispatch From Location</td>
                                        <td class="GridViewHeaderStyle">Dispatch To Location</td>
                                        <td class="GridViewHeaderStyle">Status</td>                                        
                                        <td class="GridViewHeaderStyle" style="width:100px;">Print Dispatch<br />Invoice</td>                                                                            
                        </tr>
                </table>
                </div> </div> </div>
                <div class="row" style="text-align:center">
                <div class="col-md-24">
                       <input type="button" value="Create Batch" class="savebutton" onclick="dispatchall()" id="btndis" style="display:none;" />              
                </div>
             </div>
            </div>
       <asp:Panel ID="pnl2" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >      
                 <div class="Purchaseheader">
                     Batch Detail
                      </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Batch Number  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lbbatchnumber" runat="server" Font-Bold="true">
                    </asp:Label>
                    </div>
                    <div class="col-md-3">
                    <label class="pull-left">From  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lbfrom" runat="server"  Font-Bold="true">
                    </asp:Label>
                    </div>
                 <div class="col-md-3">
                    <label class="pull-left">To  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lbto" runat="server"  Font-Bold="true">
                    </asp:Label>
                    </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">No of Box  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblnoofbox" runat="server" Font-Bold="true" />
                    </div>
                <div class="col-md-3">
                    <label class="pull-left">Total Weight  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lbltotalweight" runat="server" Font-Bold="true" />
                    </div>
                 <div class="col-md-3">
                    <label class="pull-left">Consignment Note  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:Label ID="txtconsignmentnote1" runat="server" Width="400px" />
                    </div>
                </div>           
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Temperature </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="txtTemperature1" runat="server" Width="100px"></asp:Label>
                     </div>
                 <div class="col-md-3">
                    <label class="pull-left">Dispatch Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbdispatchtype" runat="server" Font-Bold="true" />
                     </div>

                 <div class="col-md-3">
                    <label class="pull-left">Dispatch Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbdispatchdate" runat="server" Font-Bold="true" />

                 </div>
                </div>
           <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Courier name </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lblCouriername" runat="server" Font-Bold="true" />
                     </div>
                 <div class="col-md-3">
                    <label class="pull-left">AWB Number </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblawbnumber" runat="server" Font-Bold="true" />
                     </div>
                 <div class="col-md-3">
                    <label class="pull-left">FeildBoy </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lblfieldother" runat="server" Font-Bold="true" />
                 </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Delivered Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:Label ID="lbldeliverydate" runat="server" Font-Bold="true" />
                     </div>
                 <div class="col-md-3">
                    <label class="pull-left">Status UpdateBy </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbldeliveryuser" runat="server" Font-Bold="true" />
                     </div>

                 <div class="col-md-3">
                    <label class="pull-left">Received Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:Label ID="lbleceiveddate" runat="server" Font-Bold="true" />
                 </div>
                </div>
           <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Status UpdateBy </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lbleceivedby" runat="server" Font-Bold="true" />
                     </div>
                 <div class="col-md-3">                  
                </div>
                <div class="col-md-5">                 
                     </div>
                 <div class="col-md-3">                  
                </div>
                <div class="col-md-5">                    
                 </div>
                </div>
            <div class="row" style="text-align:center">
                <div class="col-md-24">
          <asp:Button ID="btncloseme2" runat="server" CssClass="resetbutton" Text="Close" /> 
          </div>
                </div>      
               </asp:Panel>
      <cc1:ModalPopupExtender ID="modelpopup2" runat="server"   TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl2" CancelControlID="btncloseme2">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" style="display:none" />
    <script type="text/javascript">        
        function searchbatch() {
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var BatchNumber = $('#<%=txtbatchnumber.ClientID%>').val();
            var location = $('#<%=ddllocation.ClientID%>').val();
            if (location == "0") {
                toast("Error", "Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }          
            $('#tblbatch tr').slice(1).remove();
            serverCall('SendIssueItemReceiveStatus.aspx/SearchBatch', { fromdate: fromdate, todate: todate, BatchNumber: BatchNumber, location: location }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Batch Found");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:"); $Tr.push(ItemData[i].Rowcolor); $Tr.push(";' id='"); $Tr.push(ItemData[i].BatchNumber); $Tr.push("'>");
                        $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(parseInt(i + 1)); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetailinner(this)" /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdBatchNumber" >'); $Tr.push(ItemData[i].BatchNumber); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].BatchCreatedDateTime); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].BatchCreatedByName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdDispatchDate">'); $Tr.push(ItemData[i].DispatchDate); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].DispatchByUserName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdFrom">'); $Tr.push(ItemData[i].DispatchFrom); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdTo">'); $Tr.push(ItemData[i].DispatchTo); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle">');
                        if (ItemData[i].DispatchStatus == "3") {
                            $Tr.push('<b>Received</b>');
                        }
                        else {
                            $Tr.push('<input type="text" id="noofboxreceive" title="Enter No of Box Received" placeholder="No of Box" onkeyup="showme(this)" style="width:65px;"/>');
                            $Tr.push('&nbsp;&nbsp;<input type="button" title="Receive Now" value="Receive" style="font-weight:bold;cursor:pointer;" onclick="savemystatus(this)"/> ');
                        }
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');
                        $Tr.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Dispatch Invoice" onclick="printmedispatch(this)" />');
                        $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdIssueInvoiceNo" style="display:none;">'); $Tr.push(ItemData[i].IssueInvoiceNo); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdnoofbox" style="display:none;">'); $Tr.push(ItemData[i].NoofBox); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdtotalweight" style="display:none;">'); $Tr.push(ItemData[i].TotalWeight); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdconnote" style="display:none;">'); $Tr.push(ItemData[i].ConsignmentNote); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdtemp" style="display:none;">'); $Tr.push(ItemData[i].Temperature); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdDispatchOption" style="display:none;">'); $Tr.push(ItemData[i].DispatchOption); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCourierName" style="display:none;">'); $Tr.push(ItemData[i].CourierName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdAWBNumber" style="display:none;">'); $Tr.push(ItemData[i].AWBNumber); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdFieldBoyID" style="display:none;">'); $Tr.push(ItemData[i].FieldBoyID); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdFieldBoyName" style="display:none;">'); $Tr.push(ItemData[i].FieldBoyName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdOtherName" style="display:none;">'); $Tr.push(ItemData[i].OtherName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdDeliveryDate" style="display:none;">'); $Tr.push(ItemData[i].DeliveryDate); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdDeliveryByUserName" style="display:none;">'); $Tr.push(ItemData[i].DeliveryByUserName); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdReceiveDate" style="display:none;">'); $Tr.push(ItemData[i].ReceiveDate); $Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdReceiveByUserName" style="display:none;">'); $Tr.push(ItemData[i].ReceiveByUserName); $Tr.push('</td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#tblbatch').append($Tr);

                    }
                }
                });                      
        }
        function printmedispatch(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();
            if (tdIssueInvoiceNo != "") {
                for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {
                    var BatchNumber = tdIssueInvoiceNo.split(',')[a];
                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                }
            }
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
        function savemystatus(ctrl) {
            var BatchNumber = $(ctrl).closest('tr').find('#tdBatchNumber').html();
            var noofboxreceive = $(ctrl).closest('tr').find('#noofboxreceive').val();           
            var status = "3";
            if (confirm("Do You Want To Change Status")) {
                serverCall('SendIssueItemReceiveStatus.aspx/SaveStatus', { BatchNumber: BatchNumber, status: status, noofboxreceive: noofboxreceive }, function (response) {
                    if (response == "1") {
                        toast("Success", "Status Change Sucessfully");
                        searchbatch();
                    }
                    else {
                        toast("Error", response);
                    }
                });              
            }
        }
        function showdetailinner(ctrl) {
            var BatchNumber = $(ctrl).closest('tr').find('#tdBatchNumber').html();
            var From = $(ctrl).closest('tr').find('#tdFrom').html();
            var To = $(ctrl).closest('tr').find('#tdTo').html();
            $('#<%=lbbatchnumber.ClientID%>').html(BatchNumber).html();
            $('#<%=lbfrom.ClientID%>').html(From);
            $('#<%=lbto.ClientID%>').html(To);
            $('#<%=lblnoofbox.ClientID%>').html($(ctrl).closest('tr').find('#tdnoofbox').html());
            $('#<%=lbltotalweight.ClientID%>').html($(ctrl).closest('tr').find('#tdtotalweight').html());
            $('#<%=txtconsignmentnote1.ClientID%>').html($(ctrl).closest('tr').find('#tdconnote').html());
            $('#<%=txtTemperature1.ClientID%>').html($(ctrl).closest('tr').find('#tdtemp').html());
            $('#<%=lbdispatchtype.ClientID%>').html($(ctrl).closest('tr').find('#tdDispatchOption').html());
            $('#<%=lblCouriername.ClientID%>').html($(ctrl).closest('tr').find('#tdCourierName').html());
            $('#<%=lblawbnumber.ClientID%>').html($(ctrl).closest('tr').find('#tdAWBNumber').html());
            $('#<%=lbdispatchdate.ClientID%>').html($(ctrl).closest('tr').find('#tdDispatchDate').html());
            $('#<%=lbldeliverydate.ClientID%>').html($(ctrl).closest('tr').find('#tdDeliveryDate').html());
            $('#<%=lbldeliveryuser.ClientID%>').html($(ctrl).closest('tr').find('#tdDeliveryByUserName').html());
            $('#<%=lbleceiveddate.ClientID%>').html($(ctrl).closest('tr').find('#tdReceiveDate').html());
            $('#<%=lbleceivedby.ClientID%>').html($(ctrl).closest('tr').find('#tdReceiveByUserName').html());
            if ($(ctrl).closest('tr').find('#tdDispatchOption').html() == "FieldBoy") {
                if ($(ctrl).closest('tr').find('#tdFieldBoyName').html() == "Other") {
                    $('#<%=lblfieldother.ClientID%>').html($(ctrl).closest('tr').find('#tdOtherName').html());
                }
                else {
                    $('#<%=lblfieldother.ClientID%>').html($(ctrl).closest('tr').find('#tdFieldBoyName').html());
                }
            }
            $find("<%=modelpopup2.ClientID%>").show();
        }
    </script>
</asp:Content>


