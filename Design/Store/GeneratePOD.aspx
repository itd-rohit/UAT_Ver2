<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="GeneratePOD.aspx.cs" Inherits="Design_Store_GeneratePOD" %>

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
                           <b>Generate POD</b>
         </div>
      <div class="POuter_Box_Inventory" >
             <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">GRN Location   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
			  <asp:DropDownList ID="ddllocation" runat="server" ></asp:DropDownList>		 		 
		   </div>
            
             <div class="col-md-3">
                    <label class="pull-right">From Date :</label>
                
</div>       <div class="col-md-2">
               
                        <asp:TextBox ID="txtentrydatefrom" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>

                   <div class="col-md-3">
                       <label class="pull-left"> To Date</label> 
                       <b class="pull-right">:</b>
                       </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
             
             </div>
              <div class="row">
               
                <div class="col-md-3"></div>
                 <div class="col-md-3"></div>
                <div class="col-md-3"></div>
                <div class="col-md-3" >
                        <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                </div>
                     <div class="col-md-1 square badge-Tested" style=" height: 20px;width:2%; float: left;" >
                    </div>

                    <div class="col-md-3">
                        Un-Generated
                    </div>

                    <div class="col-md-1 square badge-Approved" style=" height: 20px;width:2%; float: left; " >
                    </div>

                    <div class="col-md-3">
                        Generated
                    </div>

                    <div class="col-md-1 square badge-Printed" style=" height: 20px;width:2%; float: left; " >
                    </div>

                    <div class="col-md-3">
                        Transfer
                    </div>
                  </div> 
        </div>


   
                 


        <div class="POuter_Box_Inventory" >
          
                <div class="Purchaseheader">
                    GRN Detail
                </div>
            <div class="row" >
                
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">

                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;">View Item</td>
                            <td class="GridViewHeaderStyle">GRN No</td>
                            <td class="GridViewHeaderStyle">POD No</td>
                            <td class="GridViewHeaderStyle">Location</td>
                            <td class="GridViewHeaderStyle">Transfer</td>
                            <td class="GridViewHeaderStyle">PO Number</td>
                            <td class="GridViewHeaderStyle">Invoice No</td>
                            <%--  <td class="GridViewHeaderStyle">Challan No</td>--%>

                            <td class="GridViewHeaderStyle">Supplier</td>
                            <td class="GridViewHeaderStyle">GRN Date</td>

                            <td class="GridViewHeaderStyle">Gross Amt</td>
                            <td class="GridViewHeaderStyle">Disc Amt</td>
                            <td class="GridViewHeaderStyle">Tax Amt</td>
                            <td class="GridViewHeaderStyle">GRN/Net Amt</td>


                            <td class="GridViewHeaderStyle" style="width: 20px;">Select </td>
                            <td class="GridViewHeaderStyle" style="width: 20px; display: none;">id </td>






                        </tr>
                    </table>
                    </div>
               </div>
           
                <div class="row" style="text-align:center">
                    <input type="button" value="Generate POD" id="genpod" class="searchbutton" onclick="savedata()" />

                    <%--<asp:Button ID="transpod" Text="Transfer POD" CssClass="searchbutton" runat="server" OnClientClick="opentransferpopup();" />--%>
                    <input type="button" value="Transfer POD" id="transpod" class="searchbutton" onclick="opentransferpopup()" />
                    <%-- onclick="transferdata()--%>
                </div>
            </div>
    


        



   
    <div id="popup_box" style="background-color: lightgreen; height: 80px; text-align: center; width: 340px;">
        <div id="showpopupmsg" style="font-weight: bold;"></div>
        <br />
        <span id="GRNID" style="display: none;"></span><span id="type" style="display: none;"></span>
        <input type="button" class="searchbutton" value="Yes" onclick="Post();" />

    </div>


    <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="600px">


        <div class="Purchaseheader">
            Transfer Detail
        </div>

        
            <div class="row">
                <div class="col-md-3 ">
			   <label class="pull-left">Courier Name   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
			  <asp:TextBox ID="txtcurriername" runat="server"></asp:TextBox> 		 
		   </div></div>
                   <div class="row">
                <div class="col-md-3 ">
			   <label class="pull-left">Consignment No   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
			  <asp:TextBox ID="txtconsinment" runat="server"></asp:TextBox>		 
		   </div></div>
                     <div class="row">
                <div class="col-md-3 ">
			   <label class="pull-left">Courier Date  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
			  <asp:TextBox ID="txtcurrierdate" runat="server" Width="160px" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtcurrierdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
 </div>
		   </div>
                   
            
       
        <div class="row" style="text-align:center">
            
               <input type="button" class="searchbutton" value="Save" onclick="transferdata();" /><asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
            </div>
        
        <%--<asp:Button ID="btnsave" runat="server" CssClass="searchbutton" Text="Save" OnClientClick="transferdata();" />--%>
        

    </asp:Panel>
    <asp:LinkButton ID="lnkDummy" runat="server"></asp:LinkButton>
    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="lnkDummy" BehaviorID="mpe" BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>






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

            $("#genpod").hide();
            $("#transpod").hide();

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


        function checkPaitent(ID) {
            var cls = $(ID).attr("data");

            if ($(ID).prop('checked') == true) {
                $(".mmc").prop("checked", false)
                $("." + cls).prop("checked", true)
            }
        }



        function searchdata() {


            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                
                toast("Error", "No Location found For Current User..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }




            var location = $("#<%=ddllocation.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            if (location == 0) {
               
                toast("Info", "Please select location..!", "");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

           
            $('#tblitemlist tr').slice(1).remove();
          
            serverCall('GeneratePOD.aspx/SearchData', {location:location,fromdate:fromdate,todate:todate,supplier:'0',ponumber: '',invoiceno:''  ,grnno:'' ,grnstatus:'1'}, function (response) {
                $responseData = $.parseJSON(response);
               
                if ($responseData.length == 0) {
                    toast("Info", "No GRN Found", "");
                    $('#genpod').hide();
                    $('#transpod').hide();
                       
                    return;
                       
                }
                else {
                    $("#genpod").show();
                    $("#transpod").show();
                    var dataLength = $responseData.length;
                    for (var i = 0; i < $responseData.length; i++) {
                        var $myData = [];
                        $myData.push("<tr id='");
                        $myData.push($responseData[i].LedgerTransactionID); $myData.push("'");
                        $myData.push('style="background-color:');
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push( parseInt(i + 1)); $myData.push( '</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                          
                          
                        if($responseData[i].IsDirectGRN == ""){
                            $myData.push=('<td title="Direct GRN" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:aqua;font-weight:bold;">');$myData.push($responseData[i].LedgerTransactionNo);$myData.push( '</td>');

                        }
                        else
                        {
                            $myData.push('<td title="GRN Against PO" class="GridViewLabItemStyle" id="tdgrnno" style="background-color:green;font-weight:bold;color:white;">');$myData($responseData[i].LedgerTransactionNo);$myData.push( '</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >');
                            $myData.push( $responseData[i].PODnumber);
                            $myData.push( '</td>');
                            $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData[i].location); $myData.push( '</td>');

                        }
                        if ($responseData[i].Ispodgenerate == "1" && $responseData[i].IsPOD_transfer == "0") {
                            $myData.push('<td class="GridViewLabItemStyle" ><input type="checkbox" id="mmchk" name="transferchk" onchange="checkPaitent(this)" class="mmc '); $myData.push($responseData[i].PODnumber); $myData.push('" data="'); $myData.push($responseData[i].PODnumber);$myData.push('"/></td>');
                        }
                        else {
                            $mydata.push('<td class="GridViewLabItemStyle" ></td>');
                        }


                           
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData.push( $responseData[i].PurchaseOrderNo); $myData.push( '</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData.push($responseData[i].InvoiceNo); $myData.push ('</td>');
                        //mydata += '<td class="GridViewLabItemStyle" >' + $responseData[i].ChalanNo + '</td>';
                        $mydata.push('<td class="GridViewLabItemStyle" >');$myData.push($responseData[i].SupplierName); $myData.push( '</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData($responseData[i].GRNDate); $myData.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData( precise_round($responseData[i].GrossAmount, 5)); $myData.push( '</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData( precise_round($responseData[i].DiscountOnTotal, 5)); $myData.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData( precise_round($responseData[i].TaxAmount, 5)); $myData.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" >'); $myData( precise_round($responseData[i].NetAmount, 5)) ; $myData.push( '</td>');

                        if ($responseData[i].Ispodgenerate == "1") {
                            $mydata.push('<td class="GridViewLabItemStyle"></td>');
                        }
                        else {
                            $mydata.push( '<td class="GridViewLabItemStyle"><input type="checkbox" name="podchk" value='); $myData.push($responseData[i].LedgerTransactionNo); $myData.push('>    &nbsp;   </td>');
                        }

                        $mydata.push( '<td class="GridViewLabItemStyle" style="display:none;" >');$myData.push($responseData[i].LedgerTransactionID); $myData.push('</td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" style="display:none;" >');$myData.push($responseData[i].locationid); $myData.push('</td>');
                        $mydata.push( "</tr>");;

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
            serverCall('GeneratePOD.aspx/BindItemDetail', { GRNID: id }, function (response) {
                $responseData = $.parseJSON(response);

                if ($responseData.length == 0) {
                    toast("Error", "No GRN Found", "");


                    return;


                }
                else {
                    $(ctrl).attr("src", "../../App_Images/minus.png");

                    var $myData = [];


                    $mydata.push("<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>");
                    $mydata.push('<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                    $mydata.push('<td  style="width:20px;">#</td>');
                    $mydata.push('<td>Item Name</td>');
                    $mydata.push('<td>BarcodeNo</td>');
                    $mydata.push('<td>Batch Number</td>');
                    $mydata.push('<td>Expiry Date</td>');
                    $mydata.push('<td>Rate</td>');
                    $mydata.push('<td>Disc %</td>');
                    $mydata.push('<td>Tax%</td>');
                    $mydata.push('<td>Unit Price</td>');
                    $mydata.push('<td>Paid Qty</td>');
                    $mydata.push('<td>Free Qty</td>');
                    $mydata.push('<td>InHand Qty</td>');
                    $mydata.push('<td>Unit</td>');

                    for (var i = 0; i < $responseData.length - 1; i++) {

                        $mydata.push("<tr style='background-color:#70e2b3;' id='"); $mydata.push($responseData[i].stockid); $mydata.push("'>");
                        $mydata.push('<td >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');



                        $mydata.push('<td >'); $mydata.push($responseData[i].itemname); $mydata.push('</td>');
                        $mydata.push('<td >'); $mydata.push($responseData[i].barcodeno); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push($responseData[i].batchnumber); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push($responseData[i].ExpiryDate); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].rate, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].discountper, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].taxper, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].unitprice, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].PaidQty, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].freeQty, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push(precise_round($responseData[i].initialcount, 5)); $mydata.push('</td>');
                        $mydata.push('<td  >'); $mydata.push($responseData[i].MajorUnit); $mydata.push('</td>');


                        $mydata.push("</tr>");




                    }
                    $mydata.push("</table><div>");
                    var $newdata = [];

                    $newdata.push('<tr id="ItemDetail'); $newdata.push(id);
                    $newdata.push('"><td colspan="18">'); $newdata.push($myData); $newdata.push('</td></tr>');
                    $($newdata).insertAfter($(ctrl).closest('tr'));
                    //var newdata = '<tr id="ItemDetail' + id + '"><td colspan="18">' + mydata + '</td></tr>';

                    //$(newdata).insertAfter($(ctrl).closest('tr'));

                }


            });




        }
        
        function PostDialog(ctrl, type) {

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






        function savedata() {
            debugger;


            var checkedValues = $("input[name='podchk']:checked", "#tblitemlist").map(function () {
                return $(this).val();
            }).get();
            var alldata = checkedValues.join(',');
            if (checkedValues.length == 0) {
                toast("Error", "Please select minimum one option", "");
                
                return;
            }

            var dataIm = new Array();
            var objpod = new Object();
            $('#tblitemlist tr').each(
                 function () {
                     var row = $(this);
                     if (row.find('input[name="podchk"]').is(':checked')) {


                         objpod.LedgerTransactionID = row.find('td:eq(15)').text();
                         objpod.grn_no = row.find('td:eq(2)').text();
                         objpod.podnumber = row.find('td:eq(3)').text();
                         objpod.invoicenumber = row.find('td:eq(6)').text();
                         objpod.grossamt = row.find('td:eq(10)').text();
                         objpod.discamt = row.find('td:eq(11)').text();
                         objpod.taxamt = row.find('td:eq(12)').text();
                         objpod.netamt = row.find('td:eq(13)').text();
                         objpod.location = row.find('td:eq(16)').text();
                         dataIm.push(objpod);
                         objpod = new Object();
                     }
                     return dataIm;
                 });

            serverCall('GeneratePOD.aspx/Post', { objpoddetails:dataIm}, function (response) {
                
                if (response =="1") {
                    toast("Success", "GRN Post Sucessfully..!", "");
                }
                else if(response =="2"){
                    toast("Info","Item Already Issued You Can Not UnPost Or Cancel..!","");


                }
                else {
                    toast("Error","Error.. Please Try Again","");
                }
                        
            });      
          
        
        }



            function opentransferpopup() {

                var checkedValues = $("input[name='transferchk']:checked", "#tblitemlist").map(function () {
                    return $(this).val();
                }).get();
                var alldata = checkedValues.join(',');
                if (checkedValues.length == 0) {
                    toast("Error","Please select minimum one POD option","");
             
                    $find('mpe').hide();
                    return;
                }
                else {
                    $find('mpe').show();


                }


            }


            function transferdata() {

                var checkedValues = $("input[name='transferchk']:checked", "#tblitemlist").map(function () {
                    return $(this).val();
                }).get();
                var alldata = checkedValues.join(',');
                if (checkedValues.length == 0) {
                    toast("Error","Please select minimum one POD option","");
                    return;
                }
                var curriername = $("#<%=txtcurriername.ClientID%>").val();
                var consinment = $("#<%=txtconsinment.ClientID%>").val();
                var courierdate = $("#<%=txtcurrierdate.ClientID%>").val();

                if (curriername == "" || curriername == null) {
                    toast("Error","Please Fill currier name !!!","");
                    return;
                }

                if (consinment == "" || consinment == null) {
                    toast("Error","Please Fill consinment number !!!","");
                    return;
                }

                if (courierdate == "" || courierdate == null) {
                    toast("Error","Please Fill currier date !!!","");
                    return;
                }


                var dataIm = new Array();
                var objpod = new Object();
                $('#tblitemlist tr').each(
                     function () {
                         var row = $(this);
                         if (row.find('input[name="transferchk"]').is(':checked')) {

                             objpod.LedgerTransactionID = row.find('td:eq(14)').text();
                             objpod.grn_no = row.find('td:eq(2)').text();
                             objpod.podnumber = row.find('td:eq(3)').text();

                             dataIm.push(objpod);
                             objpod = new Object();
                         }
                         return dataIm;
                     });
        
                serverCall('GeneratePOD.aspx/transfer', { objpoddetails: dataIm, curriername: curriername, consinment: consinment, courierdate: courierdate}, function (response) {
                   
               
                    if (response == "1") {
                        toast("Success", "POD Transfer Sucessfully..!", "");
                        searchdata();

                        $("#<%=txtcurriername.ClientID%>").val("");
                        $("#<%=txtconsinment.ClientID%>").val("");
                        $("#<%=txtcurrierdate.ClientID%>").val("");
                        $find("mpe").hide();
                        return false;
                        
                       
                        return;
           

                    }
                    else {
                        toast("Error","Error.. Please Try Again","");
                    }
                });
            }

             </script>
</asp:Content>
