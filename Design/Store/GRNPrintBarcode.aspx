<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GRNPrintBarcode.aspx.cs" Inherits="Design_Store_GRNPrintBarcode" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">


    <head runat="server" >

          <title>Print Barcode</title>
     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    

     
      

    </head>
<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <form id="form1" runat="server">
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>


    <div id="Pbody_box_inventory" style="width:1204px;">
         
          <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;">

              <b>
                  Print Barcode
              </b>
                </div>
              </div>

        <div class="POuter_Box_Inventory" style="width:1204px;">
            <div class="content">
                <div class="Purchaseheader" >Item Detail</div>

                <div style="width:99%;max-height:330px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                         
                                      <td class="GridViewHeaderStyle">GRN No</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                       
                                        <td class="GridViewHeaderStyle">BarcodeNo</td>
                                        <td class="GridViewHeaderStyle">InHand Qty</td>
                                        <td class="GridViewHeaderStyle">Batch No</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">IsFree</td>
                                        <td class="GridViewHeaderStyle" style="width: 60px;">Barcode</td>
                        </tr>
                </table>

                    <center>
                        

                        <input type="button" class="savebutton" onclick="printallbarcodeno()" id="btnsave1" style="display:none;float:right;margin-right:15px;" value="Print All Barcode" />
                    </center>
                </div></div>
              </div>
        </div>
    </form>


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


         $(document).ready(function () {
             searchitem();
         });



  
    </script>

    <script type="text/javascript">

        function searchitem() {


           




            <%--  $.unblockUI();--%>
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "GRNPrintBarcode.aspx/SearchData",
                data: '{labno:"'+<%=Util.GetString(Request.QueryString["GRNNO"])%>+'"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                   
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        <%--  $.unblockUI();--%>

                        $('#btnsave1').hide();

                    }
                    else {

                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:bisque;' id='trbody' class='tr_clone'>";

                            mydata += '<td class="GridViewLabItemStyle" id="tdgrnno">' + ItemData[i].LedgerTransactionNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[i].itemname + '</td>';
                         
                            mydata += '<td class="GridViewLabItemStyle" id="tdbarcodeno">' + ItemData[i].BarcodeNo + '</td>';


                            mydata += '<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">' + precise_round(ItemData[i].InhandQty, 5) + '</span>';
                            mydata += '&nbsp;<span style="font-weight:bold;color:red;" >' + ItemData[i].MinorUnit + '</span></td>';


                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].batchnumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ExpiryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IsFree + '</td>';
                            
                            mydata += '<td>';
                            mydata += '<input type="text" id="txtbqty" style="width:30px" onkeyup="showme1(this)" value="' + precise_round(ItemData[i].InhandQty, 5) + '" />';
                            mydata += '&nbsp;&nbsp;<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printbarcode(this)"/>';

                            mydata += '</td>';

                          
                            mydata += '<td style="display:none;" id="tdStockID">' + ItemData[i].stockid + '</td>';
                        

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);


                            $('#btnsave1').show();



                        }
                      <%--  $.unblockUI();--%>


                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });

        }


        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }







        function showme1(ctrl) {
            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', '0'));
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
                $(ctrl).val('0');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('0');
                return;
            }



        }


       


        function printbarcode(ctrl) {

            var stockid = $(ctrl).closest('tr').find('#tdStockID').html();
            var qty = $(ctrl).closest('tr').find('#txtbqty').val();
            if (qty == "" || qty == "0") {
                showerrormsg("Please Enter Qty For Print Barcode");
                $(ctrl).closest('tr').find('#txtbqty').focus();
                return;
            }
            try {


                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.stockid = stockid;
                objbarcodedata.qty = qty;
                barcodedata.push(objbarcodedata);


                $.ajax({
                    url: "Services/StoreCommonServices.asmx/getbarcodedata",
                    data: JSON.stringify({ BarcodeData: barcodedata }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        window.location = 'barcode:///?cmd=' + result.d + '&Source=barcode_source_store';
                    },
                    error: function (xhr, status) {
                        showerrormsg(status + "\r\n" + xhr.responseText);
                    }
                });
            }
            catch (e) {
                showerrormsg("Barcode Printer Not Install");
            }


        }

        function printallbarcodeno() {
            var barcodedata = new Array();




            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {


                    var Quantity = $(this).find('#txtbqty').val() == "" ? 0 : $(this).find('#txtbqty').val();
                    if (Quantity != "0") {


                        var objbarcodedata = new Object();
                        objbarcodedata.stockid = $(this).find('#tdStockID').html();
                        objbarcodedata.qty = Quantity;
                        barcodedata.push(objbarcodedata);
                    }

                }
            });


            try {



                $.ajax({
                    url: "Services/StoreCommonServices.asmx/getbarcodedata",
                    data: JSON.stringify({ BarcodeData: barcodedata }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        window.location = 'barcode:///?cmd=' + result.d + '&Source=barcode_source';
                    },
                    error: function (xhr, status) {
                        showerrormsg(status + "\r\n" + xhr.responseText);
                    }
                });
            }
            catch (e) {
                showerrormsg("Barcode Printer Not Install");
            }


        }
    </script>
</body>
</html>
