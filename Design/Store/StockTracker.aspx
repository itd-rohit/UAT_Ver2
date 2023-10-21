<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StockTracker.aspx.cs" Inherits="Design_Store_StockTracker" %>


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

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

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
                          <b>Stock Tracking</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table>
                    <tr>
                        <td style="font-weight:bold;">
                            Enter Barcode No:
                        </td>
                       <td>
                           <asp:TextBox ID="txtbarcodeno" runat="server" Width="180px" />
                       </td>
                        <td>
                            <input type="button" value="Search" onclick="searchindent()" class="searchbutton" />
                        </td>
                    </tr>
                </table>
                </div>
              </div>


            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%" style="background-color:aqua;font-weight:bold;">
                                <tr>
                                    <td id="tditemid"></td>
                                    <td id="tditemname"></td>

                                   
                                </tr>

                                  <tr>
                                    <td id="tdbatchnumber"></td>
                                     <td id="tdexpiry"></td>
                                </tr>
                                 <tr>
                                    <td id="tdrate" colspan="2"></td>
                                </tr>
                                
                            </table>

                <div class="Purchaseheader">
                       <table width="50%">
                                <tr>
                                    
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque; "
                                       >&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Stock Not Available</td>
                                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen; "
                                       >&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>Stock Available</td>

                                </tr>
                            </table>
                </div>
                <div style="height:350px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        <td class="GridViewHeaderStyle">Sr.No</td>
                                        <td class="GridViewHeaderStyle">Date</td>
                                        <td class="GridViewHeaderStyle">TnxType</td>
                                        <td class="GridViewHeaderStyle">GRNNo</td>
                                        <td class="GridViewHeaderStyle">IndentNo</td>
                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">StockID</td>
                                        
                                        <td class="GridViewHeaderStyle">Opening Qty</td>
                                        <td class="GridViewHeaderStyle">Released Qty</td>
                                        <td class="GridViewHeaderStyle">InTransit Qty</td>
                                        <td class="GridViewHeaderStyle">InHand Qty</td>
                                       
                        </tr>
                             </table>
                </div></div>
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

         function searchindent() {

             if ($('#<%=txtbarcodeno.ClientID%>').val() == "") {
                 $('#<%=txtbarcodeno.ClientID%>').focus();
                 showerrormsg("Please Enter Barcode No To Search");
                 return;
             }

             $.blockUI();
             $('#tblitemlist tr').slice(1).remove();
             $.ajax({
                 url: "StockTracker.aspx/GetStockData",
                 data: '{barcodeno:"' + $('#<%=txtbarcodeno.ClientID%>').val() + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {
                        
                       
                        $('#tditemid').html("Item ID:<span style='color:red;'>   " + ItemData[0].itemid + "</span>");
                        $('#tditemname').html("Item Name:<span style='color:red;'>   " + ItemData[0].itemname + "</span>");
                        $('#tdbatchnumber').html("Batch Number:<span style='color:red;'>   " + ItemData[0].batchnumber + "</span>");
                        $('#tdexpiry').html("Expiry Date:<span style='color:red;'>   " + ItemData[0].Expirydate + "</span>");

                        $('#tdrate').html("Rate:<span style='color:red;'>    " + ItemData[0].rate + "</span>  Disc(%):<span style='color:red;'>    " + ItemData[0].discountper + "</span>  DiscAmt:<span style='color:red;'>    " + ItemData[0].discountamount + "</span>  Tax(%):<span style='color:red;'>    " + ItemData[0].taxper + "</span>   TaxAmt:<span style='color:red;'>    " + ItemData[0].taxamount + "</span>  UnitPrice:<span style='color:red;'>    " + ItemData[0].unitprice + "</span>");


                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var color = "bisque";
                            if (ItemData[i].InHandQty > 0) {
                                color = "lightgreen";
                            }
                            var mydata = '';
                            mydata += "<tr style='background-color:" + color + ";' id='" + ItemData[i].stockid + "'>";


                            mydata += '<td  class="GridViewLabItemStyle">' + parseInt(i + 1) + '&nbsp;&nbsp;<img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].EntryDate + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].TnxType + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].GRNNo + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].indentno + '</td>';
                            
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].location + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].stockid + '</td>';
                           
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].InitialCount + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].ReleasedCount + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].PendingQty + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].InHandQty + '</td>';

                         
                           
                           
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



        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            $.blockUI();

            $.ajax({
                url: "StockTracker.aspx/BindItemDetail",
                data: '{Stockid:"' + id + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Detail Found");
                        $.unblockUI();

                    }
                    else {
                        $(ctrl).attr("src", "../../App_Images/minus.png");
                        var mydata = "<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>";
                        mydata += '<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;">#</td>';
                        mydata += '<td>StockID</td>';
                        mydata += '<td>Date</td>';
                        mydata += '<td>From Location</td>';
                        mydata += '<td>To Location</td>';
                        mydata += '<td>Quantity</td>';
                        mydata += '<td>TrasactionType</td>';
                        mydata += '<td>UserName</td>';
                       

                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            mydata += "<tr style='background-color:#70e2b3;' id='" + ItemData[i].salesid + "'>";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';



                            mydata += '<td >' + ItemData[i].StockID + '</td>';
                            mydata += '<td >' + ItemData[i].EntryDate + '</td>';
                            mydata += '<td  >' + ItemData[i].FromLocation + '</td>';
                            mydata += '<td  >' + ItemData[i].ToLocation + '</td>';
                            mydata += '<td  style="font-weight:bold;">' + ItemData[i].Quantity + '</td>';
                            mydata += '<td  style="font-weight:bold;">' + ItemData[i].TrasactionType + '</td>';
                            mydata += '<td  >' + ItemData[i].UserName + '</td>';
                           


                            mydata += "</tr>";




                        }
                        mydata += "</table><div>";

                        var newdata = '<tr id="ItemDetail' + id + '"><td colspan="11">' + mydata + '</td></tr>';

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
    </script>
</asp:Content>

