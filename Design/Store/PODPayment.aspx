<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PODPayment.aspx.cs" Inherits="Design_Store_PODPayment" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
    <%: Scripts.Render("~/bundles/JQueryStore") %>

   
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align:center">
                          <b>POD Payments</b>
          
            </div>
       
        <div class="POuter_Box_Inventory" ">
           <div class="row">
	  <div class="col-md-3 " style="display:none">
			   <label class="pull-left">POD Location  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " style="display:none">
			   <asp:DropDownList ID="ddllocation" runat="server" ></asp:DropDownList>		 		 
		   </div>
                <div class="col-md-3 " >
			   <label class="pull-left">Vendor  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:DropDownList ID="ddlvendor" runat="server" ></asp:DropDownList> 		 
		   </div>
            
             <div class="col-md-3">
                    <label class="pull-right">From Date :</label>
                
</div>      
                <div class="col-md-5">
               
                        <asp:TextBox ID="txtentrydatefrom" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>

                   <div class="col-md-3">
                       <label class="pull-right"> To Date :</label> 
                       <b class="pull-right"></b>
                       </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtentrydateto" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
             
             </div>
               <div class="row">

               </div>
            
                <div class="row" >
                    <div class="col-md-5"></div>
                    <div class="col-md-5"></div>
                     <div class="col-md-5" >
                        <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                          <input type="button" value="Get Report Excel" class="searchbutton" onclick="GetReport();" id="btnsave"/>

                  </div>
 <div class="col-md-1 square badge-Tested" onclick="paidpod(0);" style=" height: 20px;width:2%; float: left;" >
                    </div>

                    <div class="col-md-3" onclick="paidpod(0);">
                       Unpaid
                    </div>

                    <div class="col-md-1 square badge-Approved" onclick="paidpod(1);" style=" height: 20px;width:2%; float: left; " >
                    </div>

                    <div class="col-md-3" onclick="paidpod(1);">
                        Paid
                    </div>

                   
                    </div>
                 
        </div>



        <div class="POuter_Box_Inventory" >
           
                <div class="Purchaseheader">
                    POD Detail
                </div>

              <div class="row">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">

                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;">View Item</td>
                            <td class="GridViewHeaderStyle" >POD No</td>
                            <td class="GridViewHeaderStyle" >Location</td>
                             <td class="GridViewHeaderStyle"  >Supplier</td>
                            <td class="GridViewHeaderStyle" >Gross Amt</td>
                            <td class="GridViewHeaderStyle" >Disc Amt</td>
                            <td class="GridViewHeaderStyle"  >Tax Amt</td>
                            <td class="GridViewHeaderStyle"  >Net Amt</td>

                            <td class="GridViewHeaderStyle">Payment</td>


                        </tr>
                    </table>

                </div>


            </div>



        
        <div id="popup_box" style="background-color: lightgreen; height: 80px; text-align: center; width: 340px;">
            <div id="showpopupmsg" style="font-weight: bold;"></div>
            <br />


        </div>




            <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="600px">


        <div class="Purchaseheader">
            Payment Detail
        </div>
                
        
            <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Supplier Name  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:DropDownList ID="ddlsupplier" runat="server" onchange="gettotaldue(this.value);">
                            <asp:ListItem Value="0" Text="Select vendor"></asp:ListItem>
                        </asp:DropDownList>		 
		   </div>
            </div>
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Invoice No  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtinvoice" runat="server"  ReadOnly="true"></asp:TextBox>
                        <asp:HiddenField ID="hdnledgerid" runat="server"  />
                     <img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)">		 
		   </div>
            </div>
            <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">GRN No  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtgrnno" runat="server"  ReadOnly="true"></asp:TextBox>	 
		   </div>
            </div>
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Net Amount  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtnet" runat="server"   ReadOnly="true"></asp:TextBox>
		   </div>
            </div>
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Total Paid  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txttotal" runat="server" onkeyup="showme(this);" ></asp:TextBox>
		   </div>
            </div>
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Payment Mode  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:DropDownList ID="ddlmode" runat="server" onchange="checkdivstatus(this);">
                              <asp:ListItem Value="1" Text="Cash"></asp:ListItem>
                             <asp:ListItem Value="2" Text="Credit Card"></asp:ListItem>
                             <asp:ListItem Value="3" Text="Debit Card"></asp:ListItem>
                             <asp:ListItem Value="4" Text="NEFT"></asp:ListItem>

                        </asp:DropDownList>  </div>
            </div>
                 <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Refrence number  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtref" runat="server"  ></asp:TextBox>
		   </div>
            </div>   
<div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Date </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtpaydate" runat="server" ></asp:TextBox>

        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtpaydate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
		   </div>
            </div>       
            <div class="col-md-3 " >
			   <label class="pull-left">Other Details </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:TextBox ID="txtother" runat="server" ></asp:TextBox>
                    <asp:HiddenField ID="hdnpod" runat="server" />
                     <asp:HiddenField ID="hdnvenorid" runat="server" />   </div>
                            
                
               
       
                <div class="row" style="text-align:right">
                 
			  <input type="button" class="searchbutton" value="Save" onclick="savedata();" /><asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
			   <b class="pull-right">:</b>
		   </div>

       

    </asp:Panel>
    <asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="lnkDummy" BehaviorID="mpe" BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>




                 <asp:Panel ID="pnl2" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="600px">


        <div class="Purchaseheader">
            Payment Detail
        </div>
     
           <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Payment Done By  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:Label runat="server" ID="lblrecievername"></asp:Label>
                       		 
		   </div>
            </div>
                   <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Payment Mode </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:Label runat="server" ID="lblpaymode"></asp:Label>
                       		 
		   </div>
            </div>
            <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Payment date</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:Label runat="server" ID="lbldate"></asp:Label>
                       		 
		   </div>
            </div>
             <div class="row">
                 <div class="col-md-3 " >
			   <label class="pull-left">Reference Number</label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			 <asp:Label runat="server" ID="lblref"></asp:Label>
                       		 
		   </div>
            </div>
               <div class="row" style="text-align:right">
                 <div class="col-md-3 " >
			   <asp:Button ID="closebtn" runat="server" CssClass="resetbutton" Text="Close" />
			   <b class="pull-right">:</b>
		   </div>     
                  
               
               
             </div>
            
        

       

    </asp:Panel>
    <asp:LinkButton ID="lnkshow" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="lnkshow" BehaviorID="showpayment" BackgroundCssClass="filterPupupBackground" PopupControlID="pnl2" CancelControlID="closebtn">
    </cc1:ModalPopupExtender>



    </div>
    <script type="text/javascript">


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


        });


        function opentransferpopup(ctrl) {

            $('#<%=ddlsupplier.ClientID%>').children('option:not(:first)').remove();
            var poddata = $(ctrl).closest("tr").find("#PODnumber").text();


            serverCall('PODPayment.aspx/bindvendorbypod',{pod:poddata},function(response){
                $responseData=$.parseJSON(response);
                if($responseData.length==0){
                    toast("Error","No POD Found");
                }
                else
                    for(var i=0; i<=$responseData.length-1;i++) {
                        $('#<%=ddlsupplier.ClientID%>').append($("<option></option>").val($responseData[i].vendorid + '#' + $responseData[i].grn + '#' + $responseData[i].netbalance + '#' + poddata + '#' + $responseData[i].invoiceno + '#' + $responseData[i].ledgertransactionid).html($responseData[i].suppliername));
                    }
       });

            $find('mpe').show();
        }


        function gettotaldue(sel) {
            console.log(sel);
            var allitems = String(sel);
            var arr = new Array();
            arr = allitems.split('#');
            if (arr.length != 0) {

                $('#<%=txtgrnno.ClientID%>').val(arr[1]);
                $('#<%=txtinvoice.ClientID%>').val(arr[4]);
                $('#<%=hdnvenorid.ClientID%>').val(arr[0]);
                $('#<%=txtnet.ClientID%>').val(arr[2]);
                $('#<%=hdnpod.ClientID%>').val(arr[3]);
                $('#<%=hdnledgerid.ClientID%>').val(arr[5]);
                $(".online").hide();
            }


        }




        function checkdivstatus(ctrl) {
            if (ctrl.value == '1') {
                $(".online").hide();
            }

            else {
                $(".online").show();

            }
        }



        function showpayment(ctrl) {
            debugger;
            var poddata = $(ctrl).closest("tr").find("#PODnumber").text();

            serverCall('PODPayment.aspx/bindpaymentdetails',{pod:poddata},function(response){
                $responseData =$.parseJSON(response)

                $('#<%=lblrecievername.ClientID%>').html($responseData[0].paymentrecieved);
                $('#<%=lblpaymode.ClientID%>').html($responseData[0].paymentmode);
                $('#<%=lbldate.ClientID%>').html($responseData[0].paymentdate);
                $('#<%=lblref.ClientID%>').html($responseData[0].refrencenumber);
                if ($responseData[0].paymentmode == "Cash") {
                    $(".refclass").hide();

                }
                else {
                    $(".refclass").show();
                }

            });
           

            $find('showpayment').show();


        }




    </script>

    <script type="text/javascript">



        function searchdata() {

            var vendor = $("#<%=ddlvendor.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
           

            
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PODPayment.aspx/SearchData',{fromdate:fromdate,todate:todate,supplier:vendor},function(response){
                $responseData =$.parseJSON(response);
               

                    if ($responseData.length == 0) {
                        toast("Error","No POD Found","");
                        


                    }
                    else {

                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $mydata = [];
                            $myData.push(   "<tr style='background-color:"); $myData.push( $responseData[i].rowColor ); $myData.push( ";' id='" ); $myData.push( $responseData[i].PODnumber ); $myData.push( "'>");
                            $myData.push( '<td class="GridViewLabItemStyle" >' ); $myData.push( parseInt(i + 1) + '</td>');
                            $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');

                            $myData.push( '<td class="GridViewLabItemStyle" id="PODnumber" >' ); $myData.push( $responseData[i].PODnumber ); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="location" >' ); $myData.push( $responseData[i].location); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="suppliername" >' ); $myData.push( $responseData[i].suppliername ); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="GrossAmount" >' ); $myData.push( precise_round($responseData[i].GrossAmount, 5) ); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="DiscountOnTotal">' ); $myData.push( precise_round($responseData[i].DiscountOnTotal, 5) ); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="TaxAmount" >' ); $myData.push( precise_round($responseData[i].TaxAmount, 5) ); $myData.push( '</td>');
                            $myData.push( '<td class="GridViewLabItemStyle"  id="NetAmount" >' ); $myData.push( precise_round($responseData[i].NetAmount, 5) ); $myData.push( '</td>');
                            if ($responsedata[i].is_payment == "1") {
                                $myData.push( '<td class="GridViewLabItemStyle" ><input type="button" value="Details" id="detail" class="searchbutton" onclick="showpayment(this)"/></td>');
                            }
                            else {
                                $myData.push( '<td class="GridViewLabItemStyle" ><input type="button" value="Payment" id="payment" class="searchbutton" onclick="opentransferpopup(this)"/>  </td>');
                            }

                            $myData.push( "</tr>");
                            $mydata= $mydata.join("");

                            $('#tblitemlist').append($mydata);

                        }
                   

                    }

               
               
            });



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

        }

        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
           
            serverCall('PODPayment.aspx/BindItemDetail',{pod:id},function(response){
                $responseData =$.parseJSON(response);
                if ($responseData.length == 0) {
                        toast("Error","No GRN Found","");
                       

                    }
                    else {
                        $(ctrl).attr("src", "../../App_Images/minus.png");

                        var $mydata = [];
                           $mydata.push( "<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>");
                           $mydata.push( '<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                           $mydata.push( '<td  style="width:20px;">#</td>');
                           $mydata.push( '<td>GRN No</td>');
                           $mydata.push( '<td>supplier name</td>');
                           $mydata.push( '<td>PO Number</td>');
                           $mydata.push( '<td>Invoice No</td>');
                           $mydata.push( '<td>Gross Amt</td>');
                           $mydata.push( '<td>Disc Amt</td>');
                           $mydata.push( '<td>Tax Amt</td>');
                           $mydata.push( '<td>GRN/Net Amt</td>');



                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            $mydata.push( "<tr style='background-color:#70e2b3;' id='" );$mydata.push( $responseData[i].LedgerTransactionID );$mydata.push( "'>");
                            $mydata.push( '<td >');$mydata.push( parseInt(i + 1) );$mydata.push( '</td>');



                            $mydata.push('<td >' );$mydata.push( $responseData[i].LedgerTransactionNo );$mydata.push( '</td>');
                            $mydata.push('<td >' );$mydata.push( $responseData[i].SupplierName );$mydata.push( '</td>');
                            $mydata.push( '<td  >' );$mydata.push( $responseData[i].PurchaseOrderNo );$mydata.push( '</td>');
                            $mydata.push( '<td  >' );$mydata.push( $responseData[i].InvoiceNo );$mydata.push( '</td>');
                            $mydata.push( '<td  >' );$mydata.push( precise_round($responseData[i].GrossAmount, 5) );$mydata.push( '</td>');
                            $mydata.push( '<td  >' );$mydata.push( precise_round($responseData[i].DiscountOnTotal, 5) );$mydata.push( '</td>');
                            $mydata.push( '<td  >' );$mydata.push( precise_round($responseData[i].TaxAmount, 5) );$mydata.push( '</td>');
                            $mydata.push('<td  >' );$mydata.push( precise_round($responseData[i].NetAmount, 5) );$mydata.push( '</td>');


                            $mydata.push("</tr>");




                        }
                        $mydata.push( "</table><div>");

                        var $newdata = [];
                        $newdata('<tr id="ItemDetail');$newdata.push(id);$newdata.push( '"><td colspan="18">');$newdata.push( $mydata); $newdata.push( '</td></tr>');

                        $($newdata).insertAfter($(ctrl).closest('tr'));


                       

                    }

               
                
            });


        }








        function paidpod(status) {
            debugger;
            
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PODPayment.aspx/Allpod',{status:status},function(response){
              
                    if ($responseData.length == 0) {
                        toast("Error","No POD Found","");
                        


                    }
                    else {

                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push("<tr style='background-color:"); $mydata.push( $responseData[i].rowColor + ";' id='" ); $mydata.push( $responseData[i].PODnumber ); $mydata.push( "'>");
                            $mydata.push( '<td class="GridViewLabItemStyle" >'); $mydata.push( parseInt(i + 1) ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');

                            $mydata.push( '<td class="GridViewLabItemStyle" id="PODnumber" >' ); $mydata.push( $responseData[i].PODnumber ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="location" >' ); $mydata.push( $responseData[i].location ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="suppliername" >' ); $mydata.push( $responseData[i].suppliername ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="GrossAmount" >' ); $mydata.push( precise_round($responseData[i].GrossAmount, 5) ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="DiscountOnTotal">' ); $mydata.push( precise_round($responseData[i].DiscountOnTotal, 5) ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="TaxAmount" >' ); $mydata.push( precise_round($responseData[i].TaxAmount, 5) ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"  id="NetAmount" >' ); $mydata.push( precise_round($responseData[i].NetAmount, 5) ); $mydata.push( '</td>');
                            if ($responseData[i].is_payment == "1") {
                                $mydata.push( '<td class="GridViewLabItemStyle" ><input type="button" value="Details" id="detail" class="searchbutton" onclick="showpayment(this)"/></td>');
                            }
                            else {
                                $mydata.push( '<td class="GridViewLabItemStyle" ><input type="button" value="Payment" id="payment" class="searchbutton" onclick="opentransferpopup(this)"/>  </td>');
                            }

                            $mydata.push( "</tr>");
                            $mydata=$mydata.join("");


                            $('#tblitemlist').append($mydata);

                        }
                       

                    }

               
            });

        }








    </script>




    <script type="text/javascript">

        function savedata() {

            var pod = $("#<%=hdnpod.ClientID%>").val();
            var grn = $("#<%=txtgrnno.ClientID%>").val();
            var netamt = $("#<%=txtnet.ClientID%>").val();
            var paidamt = $("#<%=txttotal.ClientID%>").val();
            var mode = $('#<%=ddlmode.ClientID %> option:selected').text()
            var ref = $("#<%=txtref.ClientID%>").val();
            var paydate = $("#<%=txtpaydate.ClientID%>").val();
            var other = $("#<%=txtother.ClientID%>").val();
            var vendorid = $('#<%=hdnvenorid.ClientID%>').val();


            serverCall('PODPayment.aspx/savepaymentDetail',{pod:pod,vendorid:vendorid,grn:grn,netamt:netamt,paidamt:paidamt,mode:mode,refrence:ref,paydate:paydate,other:other},function(response){
               
           var save = response;

                    if (save.split('#')[0] == "1") {
                        $('#btnsave').attr('disabled', false).val("Save");
                        clearForm();
                        toast("Success","Data Save successfully","");
                        searchdata();
                        $find('mpe').hide();

                    }
                    else {
                        toast("Error","somthing went wrong","");
                    }
                

            });


        }


        function clearForm() {

            $("#<%=hdnpod.ClientID%>").val("");
            $("#<%=txtgrnno.ClientID%>").val("");
            $("#<%=txtnet.ClientID%>").val("");
            $("#<%=txttotal.ClientID%>").val("");

            $("#<%=txtref.ClientID%>").val("");
            $("#<%=txtpaydate.ClientID%>").val("");
            $("#<%=txtother.ClientID%>").val("");
            $('#<%=hdnvenorid.ClientID%>').val("");

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

        function GetReport() {
            
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error","No Location Found For Current User..!","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            var location = $("#<%=ddllocation.ClientID%>").val();
            var vendor = $("#<%=ddlvendor.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            if (location == 0) {

                location = "";
            }
            serverCall('PODPayment.aspx/GetReport',{location:location,fromdate:fromdate,todate:todate,supplier:vendor},function(response){
               
                if (response == "false") {
                        toast("Error","No Item Found","");
                       
                    }
                    else {
                        window.open('../common/ExportToExcel.aspx');
                       
                    }

              
            });
        }






        function printme(ctrl) {

            window.open('GRNReceipt.aspx?GRNNO=' + $('#<%=hdnledgerid.ClientID%>').val());
        }
    </script>

</asp:Content>




