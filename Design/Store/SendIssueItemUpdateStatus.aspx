<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SendIssueItemUpdateStatus.aspx.cs" Inherits="Design_Store_SendIssueItemUpdateStatus" %>

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
        <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Material Delivery Logistic Update</b>  
                        </td>
                    </tr>
                  
                    </table>
                </div>
              </div>


             <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 <div class="Purchaseheader">
                      </div>
                </div>

              <table width="99%">
                  <tr>
                   <td style="font-weight: 700">Current Location :</td>
                           <td>
                               <asp:DropDownList ID="ddllocation" runat="server" class="ddllocation chosen-select chosen-container" Style="width: 455px;" ClientIDMode="Static"  ></asp:DropDownList> </td>

                           <td style="font-weight: 700">
                               Date From :</td>


                       <td>
                            <asp:TextBox ID="txtentrydatefrom" runat="server" Width="100px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </td>
                      <td style="font-weight: 700">
                            Date To :
                      </td>
                      <td>
                          <asp:TextBox ID="txtentrydateto" runat="server" Width="100px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </td>

                      <td style="font-weight: 700">
                          Batch Number
                          :
                      </td>
                      <td>
                          <asp:TextBox ID="txtbatchnumber" runat="server"></asp:TextBox>
                      </td>
</tr>
                  
                  <tr>
                   <td style=" text-align: right;" colspan="4">

                       <input type="button" value="Search" class="searchbutton" onclick="searchbatch()" />
                       <input type="button" value="Export To Excel" class="searchbutton" onclick="searchbatchExcel()" />
                      </td> <td colspan="4">

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
                   </td>
</tr>
                  
                                  
                  
                  
              </table>
              </div>



            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 <div class="Purchaseheader">
                    Issue Detail
                      </div>

                 <div style="width:99%;height:400px;overflow:auto;">
                <table id="tblbatch" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:80px;">View Detail</td>
                                        <td class="GridViewHeaderStyle">Batch No</td>
                                        <td class="GridViewHeaderStyle">Batch CreatedDate</td>
                                        <td class="GridViewHeaderStyle">Batch CreatedBy</td>
                                        <td class="GridViewHeaderStyle">Dispatch Date</td>
                                        <td class="GridViewHeaderStyle">Dispatch By</td>
                                        <td class="GridViewHeaderStyle">Dispatch From Location</td>
                                        <td class="GridViewHeaderStyle">Dispatch To Location</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        
                                        <td class="GridViewHeaderStyle" style="width:65px;">Print <br />Address</td>
                                        <td class="GridViewHeaderStyle" style="width:100px;">Print Dispatch<br />Invoice</td>
                                       
                                     
                                      
                                        
                                       
                                        
                                     
                        </tr>
                </table>

                </div>

                <center>
                       <input type="button" value="Create Batch" class="savebutton" onclick="dispatchall()" id="btndis" style="display:none;" />
                </center>
                </div>

          
             </div>



             

            </div>


       <asp:Panel ID="pnl2" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >

       
                 <div class="Purchaseheader">
                     Batch Detail
                      </div>

           <table width="90%">

               <tr>
                   <td width="180px" style="font-weight:bold;">Batch Number:</td>

                   <td>
                    <asp:Label ID="lbbatchnumber" runat="server" Font-Bold="true">
                    </asp:Label>
                   </td>
               </tr>
                <tr>
                   <td width="180px" style="font-weight:bold;">From:</td>

                   <td>
                    <asp:Label ID="lbfrom" runat="server"  Font-Bold="true">
                    </asp:Label>
                   </td>
                    <td  style="font-weight:bold;">To:</td>

                   <td>
                    <asp:Label ID="lbto" runat="server"  Font-Bold="true">
                    </asp:Label>
                   </td>
               </tr>

               
               <tr style="font-weight:bold;">
                   <td>
                   No of Box:
                   </td>
                     <td>
<asp:Label ID="lblnoofbox" runat="server" Font-Bold="true" />
                   </td>
                   <td style="font-weight:bold;">
                       Total Weight:
                   </td>
                   <td>
                       <asp:Label ID="lbltotalweight" runat="server" Font-Bold="true" />
                   </td>
               </tr>


               <tr style="font-weight:bold;">
                      <td>
                  Consignment Note :
                   </td>
                     <td >
                            <asp:Label ID="txtconsignmentnote1" runat="server" Width="400px" />
                   </td>
                   <td>
                 Temperature :
                   </td>
                     <td>
<asp:Label ID="txtTemperature1" runat="server" Width="100px"></asp:Label>
                   </td>
                   
               </tr>


               <tr>
                   <td width="180px" style="font-weight:bold;">
                       Dispatch Type:
                   </td>

                   <td  style="font-weight:bold;">
                       <asp:Label ID="lbdispatchtype" runat="server" Font-Bold="true" />
                   </td>
                   <td style="font-weight:bold;">
                       Dispatch Date :
                   </td>
                   <td>
                        <asp:Label ID="lbdispatchdate" runat="server" Font-Bold="true" />
                   </td>
                  
               </tr>

               <tr  style="font-weight:bold;">
                   <td>
                   Courier name :
                   </td>
                     <td>
  <asp:Label ID="lblCouriername" runat="server" Font-Bold="true" />
                   </td>
                   <td style="font-weight:bold;">
                       AWB Number :
                   </td>
                   <td>
                      <asp:Label ID="lblawbnumber" runat="server" Font-Bold="true" />
                   </td>
               </tr>

               <tr >

               <td style="font-weight:bold;">FeildBoy :</td>  
               <td colspan="3">
                    <asp:Label ID="lblfieldother" runat="server" Font-Bold="true" />
               </td>  
             
               </tr>

                 <tr>
                   <td width="180px" style="font-weight:bold;">
                       Delivered Date:
                   </td>

                   <td  style="font-weight:bold;">
                       <asp:Label ID="lbldeliverydate" runat="server" Font-Bold="true" />
                   </td>
                   <td style="font-weight:bold;">
                      Status UpdateBy
                   </td>
                   <td>
                        <asp:Label ID="lbldeliveryuser" runat="server" Font-Bold="true" />
                   </td>
                  
               </tr>

               <tr>
                   <td width="180px" style="font-weight:bold;">
                       Received Date:
                   </td>

                   <td  style="font-weight:bold;">
                       <asp:Label ID="lbleceiveddate" runat="server" Font-Bold="true" />
                   </td>
                   <td style="font-weight:bold;">
                      Status UpdateBy
                   </td>
                   <td>
                        <asp:Label ID="lbleceivedby" runat="server" Font-Bold="true" />
                   </td>
                  
               </tr>
               </table>


          <center>
             <asp:Button ID="btncloseme2" runat="server" CssClass="resetbutton" Text="Close" /> </center>
       


               </asp:Panel>
      <cc1:ModalPopupExtender ID="modelpopup2" runat="server"   TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl2" CancelControlID="btncloseme2">
    </cc1:ModalPopupExtender>


    <asp:Button ID="Button1" runat="server" style="display:none" />

    <script type="text/javascript">

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



        });



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


        
        function searchbatch() {

            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var BatchNumber = $('#<%=txtbatchnumber.ClientID%>').val();

            var location = $('#<%=ddllocation.ClientID%>').val();

            if (location == "0") {
                showerrormsg("Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            $.blockUI();
            $('#tblbatch tr').slice(1).remove();
            $.ajax({
                url: "SendIssueItemUpdateStatus.aspx/SearchBatch",
                data: '{fromdate:"' + fromdate + '",todate:"' + todate + '",BatchNumber:"' + BatchNumber + '",location:"' + location + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Batch Found");
                        $.unblockUI();


                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].BatchNumber + "'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetailinner(this)" /></td>';



                            mydata += '<td class="GridViewLabItemStyle" id="tdBatchNumber" >' + ItemData[i].BatchNumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].BatchCreatedDateTime + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].BatchCreatedByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdDispatchDate">' + ItemData[i].DispatchDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].DispatchByUserName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdFrom">' + ItemData[i].DispatchFrom + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdTo">' + ItemData[i].DispatchTo + '</td>';

                            mydata += '<td class="GridViewLabItemStyle">';

                            if (ItemData[i].DispatchStatus == "3") {
                                mydata += '<b>Received</b>';
                            }
                            else {

                                mydata += '<select id="mystatus">';
                                if (ItemData[i].DispatchStatus == "1") {
                                    mydata += '<option selected="selected" value="1">Dispatched</option>';
                                }
                                else {
                                    mydata += '<option value="1">Dispatched</option>';
                                }
                               
                                if (ItemData[i].DispatchStatus == "2") {
                                    mydata += '<option selected="selected" value="2">Delivered</option>';
                                }
                                else {
                                    mydata += '<option value="2">Delivered</option>';
                                }

                                mydata += '</select>';

                                mydata += '&nbsp;&nbsp;<input type="button" title="Change Status" value="Save" style="font-weight:bold;cursor:pointer;" onclick="savemystatus(this)"/> ';
                            }

                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="text-align:center;" >';

                            mydata += '<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeaddess(this)" />';

                            mydata += '</td>';


                            mydata += '<td class="GridViewLabItemStyle" >';

                            mydata += '<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Dispatch Invoice" onclick="printmedispatch(this)" />';

                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdIssueInvoiceNo" style="display:none;">' + ItemData[i].IssueInvoiceNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdnoofbox" style="display:none;">' + ItemData[i].NoofBox + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdtotalweight" style="display:none;">' + ItemData[i].TotalWeight + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdconnote" style="display:none;">' + ItemData[i].ConsignmentNote + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdtemp" style="display:none;">' + ItemData[i].Temperature + '</td>';


                            mydata += '<td class="GridViewLabItemStyle" id="tdDispatchOption" style="display:none;">' + ItemData[i].DispatchOption + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdCourierName" style="display:none;">' + ItemData[i].CourierName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdAWBNumber" style="display:none;">' + ItemData[i].AWBNumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdFieldBoyID" style="display:none;">' + ItemData[i].FieldBoyID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdFieldBoyName" style="display:none;">' + ItemData[i].FieldBoyName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdOtherName" style="display:none;">' + ItemData[i].OtherName + '</td>';


                            mydata += '<td class="GridViewLabItemStyle" id="tdDeliveryDate" style="display:none;">' + ItemData[i].DeliveryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdDeliveryByUserName" style="display:none;">' + ItemData[i].DeliveryByUserName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdReceiveDate" style="display:none;">' + ItemData[i].ReceiveDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdReceiveByUserName" style="display:none;">' + ItemData[i].ReceiveByUserName + '</td>';


                            mydata += "</tr>";


                            $('#tblbatch').append(mydata);

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
        function printmedispatch(ctrl) {

            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();


            if (tdIssueInvoiceNo != "") {
                for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {

                    var BatchNumber = tdIssueInvoiceNo.split(',')[a];

                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                }
            }



        }

        function savemystatus(ctrl) {
            var BatchNumber = $(ctrl).closest('tr').find('#tdBatchNumber').html();
            var status = $(ctrl).closest('tr').find('#mystatus').val();

            if (confirm("Do You Want To Change Status")) {

                $.blockUI();

                $.ajax({
                    url: "SendIssueItemUpdateStatus.aspx/SaveStatus",
                    data: '{BatchNumber:"' + BatchNumber + '",status:"' + status + '"}', // parameter map      
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        $.unblockUI();
                        if (result.d == "1") {
                            showmsg("Status Change Sucessfully");
                            searchbatch();
                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                        $.unblockUI();

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






        function searchbatchExcel() {

            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
               var todate = $('#<%=txtentrydateto.ClientID%>').val();
               var BatchNumber = $('#<%=txtbatchnumber.ClientID%>').val();

               var location = $('#<%=ddllocation.ClientID%>').val();

               if (location == "0") {
                   showerrormsg("Please Select Location");
                   $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            $.blockUI();
           
            $.ajax({
                url: "SendIssueItemUpdateStatus.aspx/SearchBatchexcel",
                data: '{fromdate:"' + fromdate + '",todate:"' + todate + '",BatchNumber:"' + BatchNumber + '",location:"' + location + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Batch Found");
                        $.unblockUI();


                    }
                    else {
                        $.unblockUI();
                        if (ItemData == "1") {
                            window.open('../common/ExportToExcel.aspx');
                        }
                        else if (ItemData == "0") {
                            alert('Record Not Found....!');
                        }
                      


                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });


        }







    </script>
</asp:Content>

