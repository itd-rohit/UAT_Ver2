<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="DirectGRNEdit.aspx.cs" Inherits="Design_Store_DirectGRNEdit" %>

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
                          <b>Direct GRN Edit</b>  
                            <br />
                            <br />
                            <strong>GRN No :</strong>&nbsp;&nbsp;<asp:TextBox ID="txtgrnno" runat="server" ReadOnly="true"></asp:TextBox>

                            <asp:TextBox ID="txtgrnid" runat="server" ReadOnly="true" style="display:none;"></asp:TextBox>
                        </td>
                    </tr>
                    </table>
                </div>


              </div>


        <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                <div class="Purchaseheader" >GRN Detail</div>

                <table width="100%">
                    <tr>
                        <td style="text-align: right; font-weight: 700">GRN Location :&nbsp; </td>
                      <td>  <asp:DropDownList ID="ddllocation" runat="server" style="width:404px;"></asp:DropDownList> &nbsp;&nbsp;&nbsp;</td>
                        <td style="font-weight: 700"> Supplier :&nbsp;</td>
                        <td><asp:DropDownList ID="ddlvendor" class="ddlvendor chosen-select chosen-container" runat="server" Width="300px"></asp:DropDownList> </td>

                        <td style="font-weight: 700"><asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal" Enabled="false">
                            <asp:ListItem value="1" >Direct Rate</asp:ListItem>
                            <asp:ListItem value="2"  Selected="True">Quotation Rate</asp:ListItem>
                            </asp:RadioButtonList>

                            </td>
                    </tr>
                    

                   <tr>
                        <td style="text-align: right; font-weight: 700">Item :&nbsp;</td>
                      <td>  <div class="ui-widget" style="display: inline-block;">
 
 
  <input id="txtitem" style="width:400px;text-transform:uppercase;" />

                      
</div></td>

                        <td style="font-weight: 700" >Item :</td>

                        <td>                          
                            <asp:Label ID="lblItemName" runat="server"></asp:Label>
                               <asp:Label ID="lblItemGroupID" runat="server" style="display:none;"></asp:Label>
                               <asp:Label ID="lblItemID" runat="server" style="display:none;"></asp:Label></td>
                         <td>
                             <span class="required"><strong>Old PO No:</strong></span>
                             <asp:TextBox ID="txtoldpono" runat="server" Width="150px" placeholder="Enter OLD PO Number"></asp:TextBox>
                         </td>
                        
                    </tr>
                    

                    <tr>
                        <td style="text-align: right; font-weight: 700">Manufacturer :</td>
                      <td>  
 
 
                               <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');" Width="404px">
                               </asp:DropDownList>
                           </td>

                        <td style="font-weight: 700" >Machine :</td>

                        <td>                          
                                 <asp:DropDownList ID="ddlMachine" runat="server" Width="300px" onchange="bindTempData('PackSize');"></asp:DropDownList>
                          
                          </td>
                         <td><strong>Pack Size :</strong>
                             
                                <asp:DropDownList ID="ddlPackSize" runat="server" Width="100px" onchange="setDataAfterPackSize();" ></asp:DropDownList>
                             
                               </td>
                        
                    </tr>
                    

                    <tr id="trme1">
                        <td style="text-align: right; font-weight: 700">Barcode :</td>
                      <td>                            
                          <asp:TextBox ID="txtbarcodeno" runat="server" Width="236px" placeholder="Scan Barcode For Quick GRN" BackColor="lightyellow" style="border:1px solid red;" Font-Bold="true"></asp:TextBox>
                          
                          </td>

                        <td style="font-weight: 700" >&nbsp;</td>

                        <td>                          
                            &nbsp;</td>
                         <td>

                             <input type="button" value="Add" class="searchbutton"  onclick="Addme()" />
                         </td>
                        
                    </tr>
                </table>
                </div>
             </div>


          <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                <div style="width:95%;max-height:250px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                         <td class="GridViewHeaderStyle">New<br />Batch</td>
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
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
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
            <div id="popup_box" style="background-color:lightgreen;height:80px;text-align:center;width:340px;">
    <div id="showpopupmsg" style="font-weight:bold;"></div>
             <br />
        <span id="barcodeno" style="display:none;"></span>
             <input type="button" class="searchbutton" value="Yes"  onclick="MapItemWithbarcode();" />
              <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>


    <asp:Panel ID="pnl" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >

       
                 <div class="Purchaseheader">
                     Item Detail
                      </div>
        <table width="99%">
            <tr>
                <td>Select Item:</td>
                <td>
                   
                  <span style="color:red;"> * Only Self Genrated barcode Items(Not System Genrated)</span>
                     <br /> <asp:DropDownList ID="ddlitemmap" class="ddlitem chosen-select chosen-container" runat="server" Width="800px"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td>Barcode No:</td>
                <td>
                    <asp:TextBox ID="txtbarcodenomap" runat="server" ReadOnly="true" ></asp:TextBox>
                </td>
            </tr>

           
        </table> 
        

                <center> <input type="button" value="Map" class="searchbutton" onclick="savenewbarcode()" />&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Cancel" /> </center>
              
    </asp:Panel>
       <cc1:ModalPopupExtender ID="modelpopup1" runat="server"   TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button2" runat="server" style="display:none" />
    </form>



     <script type="text/javascript">

         var filename = "";
         function openmypopup(href) {

             href = href + '?GRNNo=' + $('#<%=txtgrnid.ClientID%>').val();
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
         function unloadPopupBox() {
             $('#barcodeno').html('');
             $('#<%=txtbarcodeno.ClientID%>').val('');
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });

            $('#<%=txtbarcodeno.ClientID%>').focus();
        }

        function openmapdialog() {

            $('#showpopupmsg').show();
            var msg = "Barcode No :- " + $('#<%=txtbarcodeno.ClientID%>').val() + " Not  Mapped With Any Item.Do You Want To Map?";
            $('#showpopupmsg').html(msg);


            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });


            $('#barcodeno').html($('#<%=txtbarcodeno.ClientID%>').val());

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
             bindgrndata();
           



         });

         function bindvendor() {


             var dropdown = $("#<%=ddlvendor.ClientID%>");
              $("#<%=ddlvendor.ClientID%> option").remove();
              $.ajax({
                  url: "Services/StoreCommonServices.asmx/bindsupplier",
                  data: '{}', // parameter map 
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  async: false,
                  dataType: "json",
                  success: function (result) {
                      PanelData = $.parseJSON(result.d);
                      if (PanelData.length == 0) {
                          dropdown.append($("<option></option>").val("0").html("--No Supplier Found--"));
                      }
                      else {
                          dropdown.append($("<option></option>").val("0").html("Select Supplier"));
                          for (i = 0; i < PanelData.length; i++) {
                              dropdown.append($("<option></option>").val(PanelData[i].supplierid).html(PanelData[i].suppliername));
                          }
                      }
                      dropdown.trigger('chosen:updated');

                  },
                  error: function (xhr, status) {
                      //  alert(status + "\r\n" + xhr.responseText);
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
          }

          function split(val) {
              return val.split(/,\s*/);
          }
          function extractLast(term) {


              return split(term).pop();
          }
          function Addme() {


              var length = $('#<%=ddllocation.ClientID%> > option').length;
             if (length == 0) {
                 showerrormsg("No Location Found For Current User..!");
                 $('#<%=ddllocation.ClientID%>').focus();
                return;
            }


            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Location");
                 $('#<%=ddllocation.ClientID%>').focus();
                return;
            }


            if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Supplier..!");
                 $('#<%=ddlvendor.ClientID%>').focus();
                return;
            }

            if ($('#<%=lblItemID.ClientID%>').html() == "") {
                 showerrormsg("Please Select Item..!");
                 $('#<%=ddlPackSize.ClientID%>').focus();
                return;
            }



            AddItem($('#<%=lblItemID.ClientID%>').html(), "");
         }
         function AddItem(itemid, barcodeno) {
             if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Location");
                 $('#<%=ddllocation.ClientID%>').focus();
                 return;
             }


             if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Supplier..!");
                 $('#<%=ddlvendor.ClientID%>').focus();
                return;
            }
            var qtype = $("#<%=rd.ClientID%>").find(":checked").val();
                      $.blockUI();

                      $.ajax({
                          url: "DirectGRNEdit.aspx/SearchItemDetail",
                          data: '{itemid:"' + itemid + '",qtype:"' + qtype + '", locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",barcodeno:"' + barcodeno + '",vendorid:"' + $('#<%=ddlvendor.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "-1") {
                        $.unblockUI();
                        openmapdialog();
                        return;
                    }

                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();


                    }
                    else {
                        if ($('table#tblitemlist').find('#' + ItemData[0].itemid).length > 0) {
                            showerrormsg("Item Already Added");
                            $.unblockUI();
                            return;
                        }
                        var mydata = "<tr style='background-color:bisque;' id='" + ItemData[0].itemid + "' class='tr_clone'>";
                        mydata += '<td class="GridViewLabItemStyle" >';
                        if (ItemData[0].BarcodeOption == "1" && ItemData[0].BarcodeGenrationOption == "1") {

                        }
                        else {
                            mydata += ' <img src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Batch Number" onclick="addmenow(this);" />';
                        }
                        mydata += '</td>';
                        mydata += '<td class="GridViewLabItemStyle" id="tditemgroupname">' + ItemData[0].itemgroup + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[0].typename + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" id="tdapolloitemcode">' + ItemData[0].apolloitemcode + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" id="tdHsnCode">' + ItemData[0].HsnCode + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" id="tdmajorunitname">' + ItemData[0].MajorUnitName + '</td>';


                        mydata += '<td class="GridViewLabItemStyle" >';
                        if (ItemData[0].BarcodeGenrationOption == "1") {
                            if (newbarcodeno != "") {
                                ItemData[0].barcodeno = newbarcodeno;
                            }
                            mydata += '<input type="text" id="txtbarcodeno" style="width:100px;" value="' + ItemData[0].barcodeno + '" />';
                        }
                        else {
                            mydata += '<input type="text" id="txtbarcodeno" style="width:100px;" readonly="readonly" />';
                        }

                        mydata += '</td>';


                        mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" onblur="checkduplicatebatchno(this)" style="width:100px;" /></td>';


                        if (ItemData[0].IsExpirable == "0") {
                            mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[0].itemid + ItemData[0].IsExpirable + '" style="width:90px;" class="exdate" readonly="readonly"  /></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[0].itemid + '" style="width:90px;" class="exdate"  readonly="readonly"/></td>';
                        }


                      

                        mydata += '<td align="left" id="tdRate"><input type="text"  style="width:60px" readonly="readonly" id="txtRate" value="' + precise_round(ItemData[0].Rate, 5) + '" onkeyup="CalBuyPrice(this);"/></td>';
                        mydata += '<td align="left" id="tdQuantity"><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showme(this);CalBuyPrice(this);"/></td>';
                        mydata += '<td align="left" id="tdFreeQty"><input type="text"  style="width:60px" id="txtFreeQty" onkeyup="showme(this);"/></td>';
                        mydata += '<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" value="' + precise_round(ItemData[0].DiscountPer, 5) + '" onkeyup="CalBuyPrice(this);"/></td>';
                        mydata += '<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" value="' + precise_round(ItemData[0].IGSTPer, 5) + '"  onkeyup="CalBuyPrice(this);"/></td>';
                        mydata += '<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" value="' + precise_round(ItemData[0].CGSTPer, 5) + '"  onkeyup="CalBuyPrice(this);" /></td>';
                        mydata += '<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" value="' + precise_round(ItemData[0].SGSTPer, 5) + '"  onkeyup="CalBuyPrice(this);" /></td>';


                        mydata += '<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>';
                        mydata += '<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>';
                        mydata += '<td align="left" id="tdBuyPrice"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>';
                        mydata += '<td align="left" id="tdNetAmt"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>';

                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                        mydata += '<td  style="display:none;" id="tdconverter">' + ItemData[0].Converter + '</td>';
                        mydata += '<td  style="display:none;" id="tdminorunitname">' + ItemData[0].MinorUnitName + '</td>';
                        mydata += '<td style="display:none;" id="tditemid">' + ItemData[0].itemid + '</td>';
                        mydata += '<td style="display:none;" id="tdmajorunitid">' + ItemData[0].MajorUnitId + '</td>';
                        mydata += '<td style="display:none;" id="tdminorunitid">' + ItemData[0].MinorUnitId + '</td>';
                        mydata += '<td style="display:none;" id="tdmanufaid">' + ItemData[0].ManufactureID + '</td>';
                        mydata += '<td style="display:none;" id="tdmacid">' + ItemData[0].MachineID + '</td>';
                        mydata += '<td style="display:none;" id="tdlocationid">' + ItemData[0].LocationId + '</td>';
                        mydata += '<td style="display:none;" id="tdpanelid">' + ItemData[0].panelid + '</td>';
                        mydata += '<td style="display:none;" id="tdstockid">0</td>';

                        mydata += '<td style="display:none;" id="tdIsExpirable">' + ItemData[0].IsExpirable + '</td>';
                        mydata += '<td style="display:none;" id="tdPackSize">' + ItemData[0].PackSize + '</td>';
                        mydata += '<td style="display:none;" id="tdBarcodeOption">' + ItemData[0].BarcodeOption + '</td>';
                        mydata += '<td style="display:none;" id="tdBarcodeGenrationOption">' + ItemData[0].BarcodeGenrationOption + '</td>';
                        mydata += '<td style="display:none;" id="tdIssueInFIFO">' + ItemData[0].IssueInFIFO + '</td>';
                        mydata += '<td style="display:none;" id="tdIssueMultiplier">' + ItemData[0].IssueMultiplier + '</td>';


                        mydata += '<td style="display:none;" id="tdMajorUnitInDecimal">' + ItemData[0].MajorUnitInDecimal + '</td>';
                        mydata += '<td style="display:none;" id="tdMinorUnitInDecimal">' + ItemData[0].MinorUnitInDecimal + '</td>';
                        mydata += '<td style="display:none;" id="tdexpdatecutoff">' + ItemData[0].expdatecutoff + '</td>';

                        mydata += "</tr>";
                        $('#tblitemlist').append(mydata);

                        var date = new Date();
                        var newdate = new Date(date);

                        newdate.setDate(newdate.getDate() + parseInt(ItemData[0].expdatecutoff));

                        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                   "Aug", "Sep", "Oct", "Nov", "Dec"];

                        var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();



                        $("#txtexpirydate" + ItemData[0].itemid).datepicker({
                            dateFormat: "dd-M-yy",
                            changeMonth: true,
                            changeYear: true, yearRange: "-0:+20", minDate: val

                        });
                        getgrnamount();
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                        stockitemid = "";
                        newbarcodeno = "";
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }

         function addmenow(ctrl) {

             var $tr = $(ctrl).closest('.tr_clone');
             var $clone = $tr.clone();






             $clone.find('#txtbacknumber').val('');
             $clone.find('#txtQuantity').val('');
             $clone.find('#txtTotalGSTAmount').val('');
             $clone.find('#txtFreeQty').val('');
             $clone.find('#txtBuyPrice').val('');
             $clone.find('#txtNetAmt').val('');


             $clone.find('#tdstockid').html('0');



             var newid = Math.floor(1000 + Math.random() * 9000);
             $clone.find('.exdate').attr('id', newid);
             $clone.find('.exdate').removeClass('hasDatepicker');


             var date1 = new Date();
             var newdate1 = new Date(date1);

             newdate1.setDate(newdate1.getDate() + parseInt($tr.find('#tdexpdatecutoff').html()));

             var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
        "Aug", "Sep", "Oct", "Nov", "Dec"];

             var val1 = newdate1.getDate() + "-" + months[newdate1.getMonth()] + "-" + newdate1.getFullYear();



             $clone.find('#' + newid).datepicker({
                 dateFormat: "dd-M-yy",
                 changeMonth: true,
                 changeYear: true, yearRange: "-0:+20", minDate: val1

             });


             $clone.css("background-color", "yellow");
             $tr.after($clone);


             // tablefuncation();
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
        var deleteditem = "";
        function deleterow(itemid) {
            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            deleteditem = deleteditem+$(itemid).closest('tr').find('#tdstockid').html()+",";
            getgrnamount();

        }
        </script>



      <script type="text/javascript">
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
    </script>

    <script type="text/javascript">
        function validation() {

            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select Location..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }


            if ($('#<%=ddlvendor.ClientID%>').val() == "0") {
                showerrormsg("Please Select Supplier..!");
                $('#<%=ddlvendor.ClientID%>').focus();
                return false;
            }


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

            if ($.trim($('#<%=txtoldpono.ClientID%>').val()) == "") {
                showerrormsg("Please Enter OLD PO Number..!");
                $('#<%=txtoldpono.ClientID%>').focus();
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
            objst_ledgertransaction.VendorID = $('#<%=ddlvendor.ClientID%>').val();
            objst_ledgertransaction.TypeOfTnx = "Purchase";
            objst_ledgertransaction.PurchaseOrderNo = $('#<%=txtoldpono.ClientID%>').val();
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
            objst_ledgertransaction.LocationID = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

            objst_ledgertransaction.IsDirectGRN = "1";
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
                        objStockMaster.StockID =$(this).find("#tdstockid").html().split(',')[0];
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
                    objStockMaster.Remarks = "Direct GRN Paid Item";
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
                        objStockMaster.Remarks = "Direct GRN Free Item";
                        
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
        function savegrn() {

            if (validation() == false) {
                return;
            }

            var st_ledgertransaction = getst_ledgertransaction();
            var st_nmstock = getst_nmstock();
            var taxdata = get_taxdata();
            $.blockUI();
            $.ajax({
                url: "DirectGRNEdit.aspx/updatedirectgrn",
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

        function clearForm() {
            filename = "";
            $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlvendor.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlvendor.ClientID%>').trigger('chosen:updated');
            $('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);

            $('#tblitemlist tr').slice(1).remove();

            $('#<%=txtinvoiceno.ClientID%>').val('');
            $('#<%=txtchallanno.ClientID%>').val('');
            $('#<%=txtgateentryno.ClientID%>').val('');
            $('#<%=txtNarration.ClientID%>').val('');
            $('#<%=txtupdateremarks.ClientID%>').val('');
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

            $('#txtitem').val('');
        }
    </script>




    <script type="text/javascript">

        function bindgrndata() {

            $.blockUI();

            $.ajax({
                url: "DirectGRNEdit.aspx/bindoldgrndata",
                data: '{grnid:"' + $('#<%=txtgrnid.ClientID%>').val() + '"}',
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

                        $('#<%=ddllocation.ClientID%>').val(ItemData[0].locid);
                        $('#<%=ddlvendor.ClientID%>').val(ItemData[0].vendorid);

                        checkpageaccess(ItemData[0].locid.split('#')[0]);
                       

                        $('#<%=ddllocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddlvendor.ClientID%>').prop("disabled", true);
                        $('#<%=ddlvendor.ClientID%>').trigger('chosen:updated');

                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            //if ($('table#tblitemlist').find('#' + ItemData[i].itemid).length > 0) {
                            //    showerrormsg("Item Already Added");
                            //    $.unblockUI();
                            //    return;
                            //}
                            var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].itemid + "' class='tr_clone'>";

                            mydata += '<td class="GridViewLabItemStyle" >';
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
                            mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtbacknumber" style="width:100px;" value="' + ItemData[i].batchnumber + '" /></td>';
                            if (ItemData[i].IsExpirable == "0") {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[i].itemid + ItemData[i].IsExpirable + '" style="width:90px;" class="exdate" readonly="readonly" value="' + ItemData[i].ExpiryDate + '"   /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtexpirydate' + ItemData[i].itemid + '" style="width:90px;" class="exdate" value="' + ItemData[i].ExpiryDate + '"   /></td>';
                            }

                         

                            mydata += '<td align="left" id="tdRate"><input type="text"  style="width:60px" id="txtRate" onkeyup="CalBuyPrice(this);" value="' +precise_round(ItemData[i].rate,5) + '"/></td>';
                            mydata += '<td align="left" id="tdQuantity"><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showme(this);CalBuyPrice(this);" value="' +precise_round(ItemData[i].PaidQty,5) + '" /></td>';
                            mydata += '<td align="left" id="tdFreeQty"><input type="text"  style="width:60px" id="txtFreeQty" readonly="true" onkeyup="showme(this);" value="' + precise_round(ItemData[i].freeQty, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].DiscountPer,5) + '" /></td>';
                            mydata += '<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].IGSTPer, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].CGSTPer, 5) + '" /></td>';
                            mydata += '<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper"  onkeyup="CalBuyPrice(this);" value="' + precise_round(ItemData[i].SGSTPer, 5) + '" /></td>';


                            mydata += '<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true" value="' + precise_round(ItemData[i].DiscountAmount,5) + '"/></td>';
                            mydata += '<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true" value="' + precise_round(ItemData[i].TaxAmount,5) + '"/></td>';
                            mydata += '<td align="left" id="tdBuyPrice"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" value="' + precise_round(ItemData[i].UnitPrice,5) + '" /></td>';
                            var netamt = parseFloat(ItemData[i].PaidQty) * parseFloat(ItemData[i].UnitPrice);
                            mydata += '<td align="left" id="tdNetAmt"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true" value="' + precise_round(netamt,5) + '"/></td>';

                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                            mydata += '<td  style="display:none;" id="tdconverter">' + ItemData[i].Converter + '</td>';
                            mydata += '<td  style="display:none;" id="tdminorunitname">' + ItemData[i].MinorUnit + '</td>';
                            mydata += '<td style="display:none;" id="tditemid">' + ItemData[i].ItemID + '</td>';
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

                            newdate.setDate(newdate.getDate() + parseInt(ItemData[0].expdatecutoff));

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
                        $('#<%=txtoldpono.ClientID%>').val(ItemData[0].PurchaseOrderNo);
                        
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }

    </script>

    <script type="text/javascript">

        function binditem1() {


            var dropdown = $("#<%=ddlitemmap.ClientID%>");
            $("#<%=ddlitemmap.ClientID%> option").remove();
            $.ajax({
                url: "StockPhysicalVerification.aspx/binditem",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        dropdown.append($("<option></option>").val("0").html("--No Item Found--"));
                    }
                    else {
                        dropdown.append($("<option></option>").val("0").html("Select Item"));
                        for (i = 0; i < PanelData.length; i++) {
                            dropdown.append($("<option></option>").val(PanelData[i].itemid).html(PanelData[i].typename));
                        }
                    }
                    dropdown.trigger('chosen:updated');

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function MapItemWithbarcode() {
            $('#<%=txtbarcodenomap.ClientID%>').val($('#<%=txtbarcodeno.ClientID%>').val());
             unloadPopupBox();
             binditem1();
             $find("<%=modelpopup1.ClientID%>").show();


        }


        var stockitemid = "";
        var newbarcodeno = "";
        function savenewbarcode() {

            if ($('#<%=ddlitemmap.ClientID%>').val() == "0") {
                showerrormsg("Please Select Item");
                $('#<%=ddlitemmap.ClientID%>').focus();
                return;
            }

            $.ajax({
                url: "StockPhysicalVerification.aspx/savebarcode",
                data: '{itemid:"' + $('#<%=ddlitemmap.ClientID%>').val() + '",barcodeno:"' + $('#<%=txtbarcodenomap.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    var type = result.d;
                    $find("<%=modelpopup1.ClientID%>").hide();
                    showmsg("Barcode Mapped");
                    if (type == "1") {
                        $('#<%=txtbarcodeno.ClientID%>').val($('#<%=txtbarcodenomap.ClientID%>').val());
                         AddItem('', $('#<%=txtbarcodeno.ClientID%>').val());
                     }
                     else {
                         newbarcodeno = $('#<%=txtbarcodenomap.ClientID%>').val();
                         $('#<%=txtbarcodeno.ClientID%>').val('');
                         stockitemid = $('#<%=ddlitemmap.ClientID%>').val().split('#')[0];

                         AddItem(stockitemid, '');
                     }
                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }
    </script>



     <%-- bind item--%>
    <script type="text/javascript">

        $(function () {

            $("#<%= txtbarcodeno.ClientID%>").keydown(
         function (e) {
             var key = (e.keyCode ? e.keyCode : e.charCode);
             if (key == 13) {
                 e.preventDefault();
                 if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {

                     AddItem('', $.trim($('#<%=txtbarcodeno.ClientID%>').val()));
                 }



             }

         });


            $("#txtitem")
                      .bind("keydown", function (event) {
                          if (event.keyCode === $.ui.keyCode.TAB &&
                              $(this).autocomplete("instance").menu.active) {
                              event.preventDefault();
                          }

                      })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {
                              $.ajax({
                                  url: "DirectGRN.aspx/SearchItem",
                                  data: '{itemname:"' + extractLast(request.term) + '",locationidfrom:"' + $('#<%=ddllocation.ClientID%>').val() + '"}',
                                  contentType: "application/json; charset=utf-8",
                                  type: "POST", // data has to be Posted 
                                  timeout: 120000,
                                  dataType: "json",
                                  async: true,
                                  success: function (result) {
                                      response($.map(jQuery.parseJSON(result.d), function (item) {
                                          return {
                                              label: item.ItemNameGroup,
                                              value: item.ItemIDGroup
                                          }
                                      }))


                                  },
                                  error: function (xhr, status) {
                                      showerrormsg(xhr.responseText);
                                  }
                              });
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
    locationidfrom = $('#<%=ddllocation.ClientID%>').val();
    $.ajax({
        url: "DirectGRN.aspx/bindManufacturer",
        data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup }),
        contentType: "application/json; charset=utf-8",
        type: "POST", // data has to be Posted 
        timeout: 120000,
        dataType: "json",
        async: true,
        success: function (result) {
            var tempData = $.parseJSON(result.d);
            console.log(tempData);
            if (tempData.length > 1) {
                $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val('').html('Select Manufacturer'));
            }
            for (var i = 0; i < tempData.length; i++) {
                $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val(tempData[i].ManufactureID).html(tempData[i].ManufactureName));
            }
            if (tempData.length == 1) {
                bindMachine(ItemIDGroup, tempData[0].ManufactureID);
            }
            else {
                $("#<%=ddlManufacturer.ClientID %>").focus();
            }
        },
        error: function (xhr, status) {
            showerrormsg(xhr.responseText);
        }
    });
}
function bindMachine(ItemIDGroup, ManufactureID) {
    $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=ddllocation.ClientID%>').val();
            $.ajax({
                url: "DirectGRN.aspx/bindMachine",
                data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var tempData = $.parseJSON(result.d);
                    if (tempData.length > 1) {
                        $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val('').html('Select Machine'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val(tempData[i].MachineID).html(tempData[i].MachineName));
                    }
                    if (tempData.length == 1) {
                        bindPackSize(ItemIDGroup, ManufactureID, tempData[0].MachineID);
                    }
                    else {
                        $("#<%=ddlMachine.ClientID %>").focus();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = $('#<%=ddllocation.ClientID%>').val();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            $.ajax({
                url: "DirectGRN.aspx/bindPackSize",
                data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var tempData = $.parseJSON(result.d);
                    if (tempData.length > 1) {
                        $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val('0').html('Select Pack Size'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val(tempData[i].PackValue).html(tempData[i].PackSize));
                         }
                    if (tempData.length == 1) {
                        setDataAfterPackSize();

                    }
                    else if (tempData.length == 0 || tempData.length > 0) {
                        $("#<%=ddlPackSize.ClientID %>").focus();
                         }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
         }
         function setDataAfterPackSize() {
             if ($("#<%=ddlPackSize.ClientID %>").val() != '0') {

                 $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);



             }
             else {
                 $("#<%=lblItemID.ClientID %>").html('');
             }

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

        var innerhtml = $('#trme').html();
        var innerhtml1 = $('#trme1').html();
        function checkpageaccess(loctionid) {
            
                var res = CheckOtherStorePageAccess(loctionid);
                if (res != "1") {
                    $('#trme').hide();
                    $('#trme').html('');
                    $('#trme1').hide();
                    $('#trme1').html('');
                    showerrormsg(res);
                }
                else {
                    $('#trme').show();
                    $('#trme').html(innerhtml);

                    $('#trme1').show();
                    $('#trme1').html(innerhtml1);
                }
            
        }



       
    </script>


</body>

</html>
  


