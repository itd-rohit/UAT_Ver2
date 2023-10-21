<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GrnFromPOEdit.aspx.cs" Inherits="Design_Store_GrnFromPOEdit" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="Head1">


     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    

     
      <style type="text/css">

        #ddlitemmap_chosen {
            width:800px !important;
        }
          </style>

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
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>GRN From PO Edit</b>  
                            <br />
                            <br />
                            <strong>GRN No :</strong>&nbsp;&nbsp;<asp:TextBox ID="txtgrnno" runat="server" ReadOnly="true"></asp:TextBox>

                            <asp:TextBox ID="txtgrnid" runat="server" ReadOnly="true" style="display:none;"></asp:TextBox>

                            &nbsp;&nbsp;
                            <strong>Purchase Order No :</strong>&nbsp;&nbsp;
                            <asp:TextBox ID="txtponumber" runat="server" ReadOnly="true"></asp:TextBox>

                                &nbsp;&nbsp;
                            &nbsp;&nbsp;
                             <asp:TextBox ID="txtvendorid" runat="server" ReadOnly="true"  style="display:none;"></asp:TextBox>
                            <asp:TextBox ID="txtlocationid" runat="server" ReadOnly="true"  style="display:none;"></asp:TextBox>
                        </td>
                    </tr>
                    </table>
                </div>


              </div>



        <div class="POuter_Box_Inventory" style="width:1200px;">
             <div class="Purchaseheader" >Item Detail</div>
            <div class="content">
                <div style="width:95%;max-height:250px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                         <td class="GridViewHeaderStyle" style="display:none;">New<br />Batch</td>
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Item Code</td>
                                        <td class="GridViewHeaderStyle">Hsn Code</td>
                                        <td class="GridViewHeaderStyle">Purchased Unit</td>
                                        <td class="GridViewHeaderStyle">Barcode</td>
                        
                                        <td class="GridViewHeaderStyle">Batch Number</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">Rate</td>
                                        <td class="GridViewHeaderStyle">Paid Qty</td>
                                        <td class="GridViewHeaderStyle">Extra Free Qty</td>
                                        <td class="GridViewHeaderStyle">Discount %</td>
                                        <td class="GridViewHeaderStyle">IGST %</td>
                                        <td class="GridViewHeaderStyle">CGST %</td>
                                        <td class="GridViewHeaderStyle">SGST %</td>
                                            
                                        <td class="GridViewHeaderStyle">Discount Amount</td>
                                        <td class="GridViewHeaderStyle">Total GST Amount</td>
                                        <td class="GridViewHeaderStyle">BuyPrice</td>
                                        <td class="GridViewHeaderStyle">Net Amt</td>
                                        <td class="GridViewHeaderStyle">#</td>
                                       
                                       
                        </tr>
                </table>

                </div>
                </div>
              </div>

         <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                <table width="99%">
        <tr>
                        <td>Invoice No :&nbsp;</td>
                          <td>
                              <asp:TextBox ID="txtinvoiceno" runat="server" Width="110px"></asp:TextBox>
                          </td>
                          <td>InvoiceDate :&nbsp;</td>
                          <td><asp:TextBox ID="txtinvoicedate" runat="server" Width="110px"></asp:TextBox>

                              <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtinvoicedate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server" PopupButtonID="txtinvoicedate">
                                </cc1:CalendarExtender>
                          </td>
                          <td>ChallanNo :&nbsp;</td>
                          <td> <asp:TextBox ID="txtchallanno" runat="server" Width="110px"></asp:TextBox></td>
             <td>ChallanDate :&nbsp;</td>
                          <td><asp:TextBox ID="txtchallandate" runat="server" Width="110px"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtchallandate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server" PopupButtonID="txtchallandate">
                                </cc1:CalendarExtender>
                          </td>
              <td>GateEntryNo :&nbsp;</td>
              <td><asp:TextBox ID="txtgateentryno" runat="server" Width="110px"></asp:TextBox></td>

                    </tr>


                    <tr>
                        <td>
Freight :&nbsp; 
                        </td>
                          <td>
 <asp:TextBox ID="txtFreight" Text="0" runat="server" Width="110px"  onkeyup="getgrnamount();"
                                ></asp:TextBox>
                               <cc1:FilteredTextBoxExtender
                                    ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtFreight" FilterType="Custom, Numbers"
                                    ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                        </td>
                          <td>
Octroi :&nbsp;
                        </td>
                          <td>
 <asp:TextBox ID="txtOctori" Text="0" runat="server"  onkeyup="getgrnamount();"
                                Width="110px" ></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtOctori"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td>
RoundOff :&nbsp;
                        </td>
                          <td>
<asp:TextBox ID="txtRoundOff" runat="server"  Text="0" onkeyup="getgrnamount();"
                                Width="110px" ></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtRoundOff"
                                FilterType="Custom, Numbers" ValidChars=".-" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                          <td>
GRNAmount :&nbsp;
                        </td>
                          <td>
<asp:TextBox ID="txtgrnamount" Text="0" runat="server" Width="110px" ReadOnly="true"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtgrnamount"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                          <td>
InvoiceAmount :&nbsp;
                        </td>
                          <td>
<asp:TextBox ID="txtInvoiceAmount" Text="0" runat="server" Width="110px" ReadOnly="true" ></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtInvoiceAmount"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>

                               
                        </td>
                    </tr>

                    <tr>
                        <td>Narration :</td>
                        <td colspan="6">
                            <asp:TextBox ID="txtNarration" runat="server"  Width="617px"
                        ></asp:TextBox>
                        </td>
                        <td>
                            <input type="button" value="Add Document" class="searchbutton" onclick="openmypopup('AddGRNDocument.aspx')" />
                        </td>
                    </tr>
                     <tr>
                        <td>Update Remarks :</td>
                        <td colspan="6">
                            <asp:TextBox ID="txtupdateremarks" runat="server"  Width="617px"
                        ></asp:TextBox>
                            </td>
                         </tr>
</table>
                </div>
               </div>


         <div class="POuter_Box_Inventory" style="width:1200px;" id="trme">
            <div class="content" style="text-align:center;">
                <input type="button" value="Update" class="savebutton" onclick="savegrn();" id="Button1" />
                  
                   <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                </div>
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


           
            bindgrndata();


        });
    </script>

    <script type="text/javascript">

        function bindgrndata() {

            $.blockUI();

            $.ajax({
                url: "GrnFromPOEdit.aspx/bindoldgrndata",
                data: '{grnid:"' + $('#<%=txtgrnno.ClientID%>').val() + '"}',
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
                      
                        var grnamount = 0;
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                          

                            //if ($('table#tblitemlist').find('#' + ItemData[i].itemid).length > 0) {
                            //    showerrormsg("Item Already Added");
                            //    $.unblockUI();
                            //    return;
                            //}
                            var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].itemid + "' class='tr_clone'>";

                            mydata += '<td class="GridViewLabItemStyle" style="display:none;">';
                            if (ItemData[0].BarcodeOption == "1" && ItemData[0].BarcodeGenrationOption == "1") {

                            }
                            else {
                                mydata += ' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addmenow(this);" />';
                            }
                            mydata += '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tditemgroupname">' + ItemData[i].itemgroup + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[i].itemname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdapolloitemcode">' + ItemData[i].apolloitemcode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdHsnCode">' + ItemData[i].HsnCode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdmajorunitname">' + ItemData[i].MajorUnit + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >';

                            mydata += '<input type="text" id="txtbarcodeno" style="width:100px;" readonly="readonly" value="' + ItemData[i].barcodeno + '" />';


                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" onblur="checkduplicatebatchno(this)" style="width:100px;" value="' + ItemData[i].batchnumber + '" /></td>';
                            if (ItemData[i].IsExpirable == "0") {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[i].itemid + ItemData[i].IsExpirable + '" style="width:90px;" class="exdate" readonly="readonly" value="' + ItemData[i].ExpiryDate + '"   /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[i].itemid + '" style="width:90px;" class="exdate" value="' + ItemData[i].ExpiryDate + '" readonly="readonly"   /></td>';
                            }



                            mydata += '<td align="left" id="tdRate"><input type="text"  style="width:60px" id="txtRate" onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].rate, 5) + '"/></td>';
                            //alert(ItemData[i].PaidQtynew);
                            mydata += '<td align="left" id="tdQuantity"><span style="display:none;" id="sppaidqty">' + precise_round(ItemData[i].PaidQtynew, 5) + '</span><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showmeqty(this);CalBuyPrice(this);" value="' + precise_round(ItemData[i].PaidQty, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdFreeQty"><input type="text"  style="width:60px" id="txtFreeQty" readonly="true" onkeyup="showme(this);" value="' + precise_round(ItemData[i].freeQty, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].DiscountPer, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].IGSTPer, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].CGSTPer, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].SGSTPer, 5) + '" /></td>';


                            mydata += '<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true" value="' + precise_round(ItemData[i].DiscountAmount, 5) + '"/></td>';
                            mydata += '<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true" value="' + precise_round(ItemData[i].TaxAmount, 5) + '"/></td>';
                            mydata += '<td align="left" id="tdBuyPrice"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" value="' + precise_round(ItemData[i].UnitPrice, 5) + '" /></td>';
                            var netamt = parseFloat(ItemData[i].PaidQty) * parseFloat(ItemData[i].UnitPrice);
                            mydata += '<td align="left" id="tdNetAmt"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true" value="' + precise_round(netamt, 5) + '"/></td>';
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                            mydata += '<td  style="display:none;" id="tdconverter">' + ItemData[i].Converter + '</td>';
                            mydata += '<td  style="display:none;" id="tdminorunitname">' + ItemData[i].MinorUnit + '</td>';
                            mydata += '<td style="display:none;" id="tditemid">' + ItemData[i].itemid + '</td>';
                            mydata += '<td style="display:none;" id="tdmajorunitid">' + ItemData[i].MajorUnitID + '</td>';
                            mydata += '<td style="display:none;" id="tdminorunitid">' + ItemData[i].MinorUnitID + '</td>';
                            mydata += '<td style="display:none;" id="tdmanufaid">' + ItemData[i].ManufactureID + '</td>';
                            mydata += '<td style="display:none;" id="tdmacid">' + ItemData[i].MacID + '</td>';
                            mydata += '<td style="display:none;" id="tdlocationid">' + ItemData[i].locationid + '</td>';
                            mydata += '<td style="display:none;" id="tdpanelid">' + ItemData[i].panel_id + '</td>';
                            mydata += '<td style="display:none;" id="tdstockid">' + ItemData[i].stockid + '</td>';
                            mydata += '<td style="display:none;" id="tdIsExpirable">' + ItemData[i].IsExpirable + '</td>';
                            mydata += '<td style="display:none;" id="tdPackSize">' + ItemData[i].PackSize + '</td>';
                            mydata += '<td style="display:none;" id="tdBarcodeOption">' + ItemData[i].BarcodeOption + '</td>';
                            mydata += '<td style="display:none;" id="tdBarcodeGenrationOption">' + ItemData[i].BarcodeGenrationOption + '</td>';
                            mydata += '<td style="display:none;" id="tdIssueInFIFO">' + ItemData[i].IssueInFIFO + '</td>';
                            mydata += '<td style="display:none;" id="tdIssueMultiplier">' + ItemData[i].IssueMultiplier + '</td>';
                            mydata += '<td style="display:none;" id="tdMajorUnitInDecimal">' + ItemData[i].MajorUnitInDecimal + '</td>';
                            mydata += '<td style="display:none;" id="tdMinorUnitInDecimal">' + ItemData[i].MinorUnitInDecimal + '</td>';
                            mydata += '<td style="display:none;" id="tdexpdatecutoff">' + ItemData[i].expdatecutoff + '</td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                            var date = new Date();
                            var newdate = new Date(date);

                            newdate.setDate(newdate.getDate() + parseInt(ItemData[i].expdatecutoff));

                            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                       "Aug", "Sep", "Oct", "Nov", "Dec"];

                            var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();


                            $("#txtexpirydate" + ItemData[i].itemid).datepicker({
                                dateFormat: "dd-M-yy",
                                changeMonth: true,
                                changeYear: true, yearRange: "-0:+20", minDate: val

                            });
                            // getgrnamount();
                        }

                        $('#<%=txtinvoiceno.ClientID%>').val(ItemData[0].InvoiceNo);
                        $('#<%=txtinvoicedate.ClientID%>').val(ItemData[0].InvoiceDate);
                        $('#<%=txtchallanno.ClientID%>').val(ItemData[0].ChalanNo);
                        $('#<%=txtchallandate.ClientID%>').val(ItemData[0].ChalanDate);
                        $('#<%=txtgateentryno.ClientID%>').val(ItemData[0].GatePassInWard);
                        $('#<%=txtNarration.ClientID%>').val(ItemData[0].remarks);
                        $('#<%=txtupdateremarks.ClientID%>').val(ItemData[0].UpdateRemarks);
                        $('#<%=txtFreight.ClientID%>').val(precise_round(ItemData[0].Freight, 5));
                        $('#<%=txtOctori.ClientID%>').val(precise_round(ItemData[0].Octori, 5));
                        $('#<%=txtRoundOff.ClientID%>').val(precise_round(ItemData[0].RoundOff, 5));
                        $('#<%=txtgrnamount.ClientID%>').val(precise_round(ItemData[0].NetAmount, 5));
                        $('#<%=txtInvoiceAmount.ClientID%>').val(precise_round(ItemData[0].InvoiceAmount, 5));
                       

                        $.unblockUI();

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
        function CalBuyPrice(ctrl) {

            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));


            var Quantity = $(ctrl).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtQuantity").val());

            var Rate = $(ctrl).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtRate").val());
            var Disc = $(ctrl).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtDiscountper").val());
            if (Disc > 100) {
                $(ctrl).closest("tr").find("#txtDiscountper").val('100');
                Disc = 100;
            }
            var IGSTPer = $(ctrl).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtIGSTpe").val());
            var CGSTPer = $(ctrl).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtCGSTper").val());
            var SGSTPer = $(ctrl).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtSGSTper").val());

            var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;

            var disc = precise_round((Rate * Disc * 0.01), 5);
            var ratedisc = precise_round((Rate - disc), 5);
            var tax = precise_round((ratedisc * Tax * 0.01), 5);
            var ratetaxincludetax = precise_round((ratedisc + tax), 5);

            var discountAmout = precise_round(disc, 5);
            var TaxAmount = precise_round(tax, 5);



            $(ctrl).closest("tr").find("#txtDiscountAmount").val(discountAmout);

            $(ctrl).closest("tr").find("#txtTotalGSTAmount").val(TaxAmount);


            $(ctrl).closest("tr").find("#txtBuyPrice").val(ratetaxincludetax);

            var NetAmount = precise_round((($(ctrl).closest("tr").find("#txtBuyPrice").val()) * Quantity), 5);

            $(ctrl).closest("tr").find("#txtNetAmt").val(NetAmount);
            getgrnamount();

        }


        function showmeqty(ctrl) {


            if ($(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }

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

            var sendqty = $(ctrl).closest('tr').find('#sppaidqty').html();
            var paidqty = $(ctrl).val();

            if (parseFloat(paidqty) > parseFloat(sendqty)) {
                showerrormsg("Receive Qty Can't Greater Then " + sendqty);
                $(ctrl).val(sendqty);
                return;
            }
        }
        function showme(ctrl) {


            if ($(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMajorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }

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

        function getgrnamount() {
            var NetAmount = 0;
            var GrossAmount = 0;
            var DiscAmount = 0;
            $('#tblitemlist tr').each(function () {

                if ($(this).attr('id') != 'triteheader') {

                    var Quantity = $(this).find("#txtQuantity").val() == "" ? 0 : parseFloat($(this).find("#txtQuantity").val());

                    var Rate = $(this).find("#txtRate").val() == "" ? 0 : parseFloat($(this).find("#txtRate").val());
                    var Disc = $(this).find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).find("#txtDiscountper").val());

                    var IGSTPer = $(this).find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).find("#txtIGSTpe").val());
                    var CGSTPer = $(this).find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).find("#txtCGSTper").val());
                    var SGSTPer = $(this).find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).find("#txtSGSTper").val());

                    var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;

                    var disc = precise_round((Rate * Disc * 0.01), 5);
                    var ratedisc = precise_round((Rate - disc), 5);
                    var tax = precise_round((ratedisc * Tax * 0.01), 5);
                    var ratetaxincludetax = precise_round((ratedisc + tax), 5);

                    var discountAmout = precise_round(disc, 5);
                    var TaxAmount = precise_round(tax, 5);

                    NetAmount += precise_round((($(this).find("#txtBuyPrice").val()) * Quantity), 5);
                    DiscAmount += discountAmout;
                }


            });


            var Freight = $('#<%=txtFreight.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtFreight.ClientID %>').val());
            var Octori = $('#<%=txtOctori.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtOctori.ClientID %>').val());
            var RoundOff = $('#<%=txtRoundOff.ClientID %>').val() == "" ? 0 : parseFloat($('#<%=txtRoundOff.ClientID %>').val());
            var totalamt = parseFloat(NetAmount) + parseFloat(Freight) + parseFloat(Octori) + parseFloat(RoundOff);
            $('#<%=txtInvoiceAmount.ClientID %>').val(totalamt);
            $('#<%=txtgrnamount.ClientID %>').val(totalamt);

        }


        function checkduplicatebatchno(ctrl) {
            var itemid = $(ctrl).closest('tr').find('#tditemid').html();
            var batchno = $(ctrl).val();
            if ($.trim(batchno) != "") {
             
                var a = 0;
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    var batchnumber = $(this).find("#txtbacknumber").val();
                    if (id == itemid && $.trim(batchno).toUpperCase() == $.trim(batchnumber).toUpperCase()) {
                        a = a + 1;
                    }
                });

                if (a > 1) {
                    $(ctrl).val('');
                    $(ctrl).focus();
                    showerrormsg('This Batch No Already Exist.!');
                }
            }


        }
    </script>

    <script type="text/javascript">

        function clearform() {
            filename = "";
            $('#tblitemlist tr').slice(1).remove();
      
            

            $('#<%=txtinvoiceno.ClientID%>').val('');
            $('#<%=txtchallanno.ClientID%>').val('');
            $('#<%=txtgateentryno.ClientID%>').val('');
            $('#<%=txtNarration.ClientID%>').val('');
            $('#<%=txtFreight.ClientID%>').val('0');
            $('#<%=txtOctori.ClientID%>').val('0');
            $('#<%=txtRoundOff.ClientID%>').val('0');
            $('#<%=txtgrnamount.ClientID%>').val('0');
            $('#<%=txtInvoiceAmount.ClientID%>').val('0');

            var date = new Date();
            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
               "Aug", "Sep", "Oct", "Nov", "Dec"];

            var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
            $('#<%=txtinvoicedate.ClientID%>').val(val);
            $('#<%=txtchallandate.ClientID%>').val(val);

           


        }
    </script>


    <script type="text/javascript">
        function validation() {

            


            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                showerrormsg("Please Select Item  ");
                $('#txtitem').focus();
                return false;
            }

            var sn11 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var rate = $(this).find('#txtbacknumber').val() == "" ? 0 : parseFloat($(this).find('#txtbacknumber').val());


                    if (rate == 0) {
                        sn11 = 1;
                        $(this).find('#txtbacknumber').focus();
                        return;
                    }
                }
            });

            if (sn11 == 1) {
                showerrormsg("Please Enter BatchNumber ");
                return false;
            }


            var sn = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var rate = $(this).find('#txtRate').val() == "" ? 0 : parseFloat($(this).find('#txtRate').val());


                    if (rate == 0) {
                        sn = 1;
                        $(this).find('#txtRate').focus();
                        return;
                    }
                }
            });

            if (sn == 1) {
                showerrormsg("Please Enter Rate ");
                return false;
            }

            var sn1 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var qty = $(this).find('#txtQuantity').val() == "" ? 0 : parseFloat($(this).find('#txtQuantity').val());
                    if (qty == 0) {
                        sn1 = 1;
                        $(this).find('#txtQuantity').focus();

                        return;
                    }
                }
            });

            if (sn1 == 1) {
                showerrormsg("Please Enter Quantity ");
                return false;
            }

            if ($('#<%=txtinvoiceno.ClientID %>').val() == "" && $('#<%=txtchallanno.ClientID %>').val() == "") {
                showerrormsg("Please Enter Invoice No or Chalan No");
                return false;
            }

            if ($.trim($('#<%=txtponumber.ClientID%>').val()) == "") {
                showerrormsg("PO Number Not Found..!");
              
                return false;
            }

            return true;
        }


        function getst_ledgertransaction() {
            var TaxAmount = 0;
            var DiscountAmount = 0;
            var GrossAmt = 0;
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != 'triteheader') {
                    var Quantity = $(this).find("#txtQuantity").val() == "" ? 0 : parseFloat($(this).find("#txtQuantity").val());
                    TaxAmount += precise_round((($(this).find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).find("#txtTotalGSTAmount").val())) * Quantity), 5);
                    DiscountAmount += precise_round((($(this).find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).find("#txtDiscountAmount").val())) * Quantity), 5);
                    GrossAmt += precise_round((($(this).find("#txtRate").val() == "" ? 0 : parseFloat($(this).find("#txtRate").val())) * Quantity), 5);
                }
            });




            var objst_ledgertransaction = new Object();

            objst_ledgertransaction.LedgerTransactionID = $('#<%=txtgrnid.ClientID%>').val();
            objst_ledgertransaction.LedgerTransactionNo = $('#<%=txtgrnno.ClientID%>').val();
            objst_ledgertransaction.VendorID = $('#<%=txtvendorid.ClientID%>').val();
            objst_ledgertransaction.TypeOfTnx = "Purchase";
            objst_ledgertransaction.PurchaseOrderNo = $('#<%=txtponumber.ClientID%>').val();
            objst_ledgertransaction.GrossAmount = GrossAmt;
            objst_ledgertransaction.DiscountOnTotal = DiscountAmount;
            objst_ledgertransaction.TaxAmount = TaxAmount;

            objst_ledgertransaction.NetAmount = $('#<%=txtgrnamount.ClientID%>').val();
            objst_ledgertransaction.InvoiceAmount = $('#<%=txtInvoiceAmount.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtInvoiceAmount.ClientID%>').val());
            objst_ledgertransaction.InvoiceNo = $('#<%=txtinvoiceno.ClientID%>').val();
            objst_ledgertransaction.InvoiceDate = $('#<%=txtinvoicedate.ClientID%>').val();
            objst_ledgertransaction.InvoiceAttachment = "0";
            objst_ledgertransaction.ChalanNo = $('#<%=txtchallanno.ClientID%>').val();
            objst_ledgertransaction.ChalanDate = $('#<%=txtchallandate.ClientID%>').val();

            objst_ledgertransaction.DiscountReason = "";
            objst_ledgertransaction.Remarks = $('#<%=txtNarration.ClientID%>').val();

            objst_ledgertransaction.IndentNo = "";
            objst_ledgertransaction.Freight = $('#<%=txtFreight.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtFreight.ClientID%>').val());
            objst_ledgertransaction.Octori = $('#<%=txtOctori.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtOctori.ClientID%>').val());
            objst_ledgertransaction.GatePassInWard = $('#<%=txtgateentryno.ClientID%>').val();
            objst_ledgertransaction.GatePassOutWard = "";
            objst_ledgertransaction.IsReturnable = "0";
            objst_ledgertransaction.RoundOff = $('#<%=txtRoundOff.ClientID%>').val() == "" ? 0 : parseFloat($('#<%=txtRoundOff.ClientID%>').val());
            objst_ledgertransaction.LocationID = $('#<%=txtlocationid.ClientID%>').val();

            objst_ledgertransaction.IsDirectGRN = "0";
            objst_ledgertransaction.UpdateRemarks = $('#<%=txtupdateremarks.ClientID%>').val();
            return objst_ledgertransaction;
        }

        function getst_nmstock() {

            var datastock = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {


                    var objStockMaster = new Object();
                    if ($(this).find("#tdstockid").html() == "0") {
                        objStockMaster.StockID = "0";
                    }
                    else {
                        objStockMaster.StockID = $(this).find("#tdstockid").html().split(',')[0];
                    }
                    objStockMaster.ItemID = id;
                    objStockMaster.ItemName = $(this).find("#tditemname").html();
                    objStockMaster.LedgerTransactionID = "0";
                    objStockMaster.LedgerTransactionNo = "";
                    objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                    objStockMaster.Rate = $(this).find("#txtRate").val();
                    objStockMaster.DiscountPer = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());;
                    objStockMaster.DiscountAmount = $(this).closest("tr").find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountAmount").val());
                    var IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                    var CGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                    var SGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());



                    var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;


                    objStockMaster.TaxPer = Tax;
                    objStockMaster.TaxAmount = $(this).closest("tr").find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGSTAmount").val());
                    objStockMaster.UnitPrice = $(this).closest("tr").find("#txtBuyPrice").val();
                    objStockMaster.MRP = $(this).find("#txtRate").val();


                    var qty = $(this).find("#tdconverter").html() * $(this).find("#txtQuantity").val();
                    objStockMaster.InitialCount = qty;

                    objStockMaster.ReleasedCount = "0";
                    objStockMaster.PendingQty = "0";
                    objStockMaster.RejectQty = "0";


                    objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                    objStockMaster.Naration = $('#<%=txtNarration.ClientID%>').val();
                    objStockMaster.IsFree = "0";

                    objStockMaster.LocationID = $(this).find("#tdlocationid").html();
                    objStockMaster.Panel_Id = $(this).find("#tdpanelid").html();

                    objStockMaster.IndentNo = "";
                    objStockMaster.FromLocationID = "0";
                    objStockMaster.FromStockID = "0";
                    objStockMaster.Reusable = "0";
                    objStockMaster.ManufactureID = $(this).find("#tdmanufaid").html();
                    objStockMaster.MacID = $(this).find("#tdmacid").html();
                    objStockMaster.MajorUnitID = $(this).find("#tdmajorunitid").html();
                    objStockMaster.MajorUnit = $(this).find("#tdmajorunitname").html();
                    objStockMaster.MinorUnitID = $(this).find("#tdminorunitid").html();
                    objStockMaster.MinorUnit = $(this).find("#tdminorunitname").html();
                    objStockMaster.Converter = $(this).find("#tdconverter").html();
                    objStockMaster.Remarks = "GRN From PO Paid Item";
                    objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                    objStockMaster.PackSize = $(this).find("#tdPackSize").html();
                    objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                    objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                    objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                    objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                    objStockMaster.BarcodeNo = $(this).find('#txtbarcodeno').val();
                    objStockMaster.MajorUnitInDecimal = $(this).find('#tdMajorUnitInDecimal').html();
                    objStockMaster.MinorUnitInDecimal = $(this).find('#tdMinorUnitInDecimal').html();

                    datastock.push(objStockMaster);
                    var freeqty = $(this).closest("tr").find("#txtFreeQty").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtFreeQty").val());
                    if (freeqty > 0) {
                        objStockMaster = new Object();

                        if ($(this).find("#tdstockid").html() == "0") {
                            objStockMaster.StockID = "0";
                        }
                        else {
                            objStockMaster.StockID = $(this).find("#tdstockid").html().split(',')[1];
                        }
                        objStockMaster.ItemID = id;
                        objStockMaster.ItemName = $(this).find("#tditemname").html();
                        objStockMaster.LedgerTransactionID = "0";
                        objStockMaster.LedgerTransactionNo = "";
                        objStockMaster.BatchNumber = $(this).find("#txtbacknumber").val();

                        objStockMaster.Rate = 0;
                        objStockMaster.DiscountPer = 0;
                        objStockMaster.DiscountAmount = 0;

                        objStockMaster.TaxPer = 0;
                        objStockMaster.TaxAmount = 0;
                        objStockMaster.UnitPrice = 0;
                        objStockMaster.MRP = 0;


                        var qty = $(this).find("#tdconverter").html() * freeqty;
                        objStockMaster.InitialCount = qty;

                        objStockMaster.ReleasedCount = "0";
                        objStockMaster.PendingQty = "0";
                        objStockMaster.RejectQty = "0";


                        objStockMaster.ExpiryDate = $(this).find(".exdate ").val()


                        objStockMaster.Naration = $('#<%=txtNarration.ClientID%>').val();
                        objStockMaster.IsFree = "1";

                        objStockMaster.LocationID = $(this).find("#tdlocationid").html();
                        objStockMaster.Panel_Id = $(this).find("#tdpanelid").html();

                        objStockMaster.IndentNo = "";
                        objStockMaster.FromLocationID = "0";
                        objStockMaster.FromStockID = "0";
                        objStockMaster.Reusable = "0";
                        objStockMaster.ManufactureID = $(this).find("#tdmanufaid").html();
                        objStockMaster.MacID = $(this).find("#tdmacid").html();
                        objStockMaster.MajorUnitID = $(this).find("#tdmajorunitid").html();
                        objStockMaster.MajorUnit = $(this).find("#tdmajorunitname").html();
                        objStockMaster.MinorUnitID = $(this).find("#tdminorunitid").html();
                        objStockMaster.MinorUnit = $(this).find("#tdminorunitname").html();
                        objStockMaster.Converter = $(this).find("#tdconverter").html();
                        objStockMaster.Remarks = "GRN From PO Free Item";

                        objStockMaster.IsExpirable = $(this).find("#tdIsExpirable").html();
                        objStockMaster.PackSize = $(this).find("#tdPackSize").html();
                        objStockMaster.IssueMultiplier = $(this).find("#tdIssueMultiplier").html();
                        objStockMaster.BarcodeOption = $(this).find("#tdBarcodeOption").html();
                        objStockMaster.BarcodeGenrationOption = $(this).find("#tdBarcodeGenrationOption").html();
                        objStockMaster.IssueInFIFO = $(this).find("#tdIssueInFIFO").html();
                        objStockMaster.BarcodeNo = $(this).find('#txtbarcodeno').val();
                        objStockMaster.MajorUnitInDecimal = $(this).find('#tdMajorUnitInDecimal').html();
                        objStockMaster.MinorUnitInDecimal = $(this).find('#tdMinorUnitInDecimal').html();
                        datastock.push(objStockMaster);
                    }


                }
            });

            return datastock;
        }


        function get_taxdata() {

            var datatax = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                var batchnumber = $(this).find("#txtbacknumber").val();
                if (id != "triteheader") {
                    var IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                    var CGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                    var SGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());
                    if (parseFloat(IGSTPer) > 0) {
                        CGSTPer = 0;
                        SGSTPer = 0;
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "IGST";
                        objtax.Percentage = IGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = IGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(CGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "CGST";
                        objtax.Percentage = CGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = CGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(SGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.LedgerTransactionID = 0;
                        objtax.LedgerTransactionNo = "";
                        objtax.StockID = 0;
                        objtax.ItemID = id;
                        objtax.BatchNumber = batchnumber;
                        objtax.TaxName = "SGST";
                        objtax.Percentage = SGSTPer;
                        var Rate = $(this).closest("tr").find("#txtRate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtRate").val());
                        var Disc = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                        var Tax = SGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }

                }
            });

            return datatax;
        }

        var deleteditem = "";
        function deleterow(itemid) {
            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            deleteditem = deleteditem + $(itemid).closest('tr').find('#tdstockid').html() + ",";
            getgrnamount();

        }
        function savegrn() {

            if (validation() == false) {
                return;
            }

            var st_ledgertransaction = getst_ledgertransaction();
            var st_nmstock = getst_nmstock();
            var taxdata = get_taxdata();
            $.blockUI();
            $.ajax({
                url: "GrnFromPOEdit.aspx/updategrn",
                data: JSON.stringify({ st_ledgertransaction: st_ledgertransaction, st_nmstock: st_nmstock, taxdata: taxdata, deleteditem: deleteditem }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d.split('#')[0] == "1") {
                        showmsg("GRN Updated Successfully..!");
                        window.open('GRNReceipt.aspx?GRNNO=' + result.d.split('#')[1]);
                        //searchitem();
                        clearForm();

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });


        }
    </script>

    <script type="text/javascript">

        function hideme(res) {
            $('#trme').hide();
            $('#trme').html('');

         
            showerrormsg(res);
        }
    </script>
</body>
</html>
