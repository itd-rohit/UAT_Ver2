<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Store/VendorPortal/VendorPortal.master" AutoEventWireup="true" CodeFile="VendorIssueItem.aspx.cs" Inherits="Design_Store_VendorPortal_VendorIssueItem" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <link href="../../../App_Style/multiple-select.css" rel="stylesheet" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
     <script type="text/javascript" src="../../../Scripts/jquery.multiple.select.js"></script>
      
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
      <style type="text/css">
        .selected {
            background-color:aqua !important;
           border:2px solid black;
        }
        
    </style>
     <div id="Pbody_box_inventory" style="width:1304px;">
         
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Issue Item Against  Purchase Order</b>  
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
                            PO Accept From Date :
                        </td>
                        <td>
                            <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="font-weight: 700">
                            PO Accept To Date :
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
                               <asp:ListItem Value="-1">Select</asp:ListItem>
                               <asp:ListItem Value="1" Selected="True">Accepted</asp:ListItem>
                                <asp:ListItem Value="2">Issued</asp:ListItem>
                             
                           </asp:DropDownList> </td>

                        <td>
                            <input type="button" class="searchbutton" value="Search" onclick="searchdata()" />
                        </td>
                    </tr>
                  
                    <tr>
                        <td style="font-weight: 700">
                            Item :</td>
                        <td colspan="8">
                                                <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="1040px" runat="server" ClientIDMode="Static"></asp:ListBox>
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
                      </div> </td>

    <td>
<table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>

                     
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Accepted</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Issued</td>
                     
                </tr>
            </table>
    </td>

   
</tr>
                     </table>
                  
                      </div></div>

                     <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content"> 
        <table style="width:1300px">
                    <tr>
                        <td width="645px" valign="top">
                
                 <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                     
                                      
                                        <td class="GridViewHeaderStyle">PO Number</td>
                                        <td class="GridViewHeaderStyle">Aceept Date</td>
                                      

                                        <td class="GridViewHeaderStyle">Location</td>
                                       
                                        <td class="GridViewHeaderStyle">Gross Amt</td>
                                        <td class="GridViewHeaderStyle">Disc Amt</td>
                                        <td class="GridViewHeaderStyle">Tax Amt</td>
                                        <td class="GridViewHeaderStyle">Net Amt</td>
                                       
                                        <td class="GridViewHeaderStyle" style="width:20px;">Print PO</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Comm ent</td>
                                       
                                        
                                     
                        </tr>
                </table>

                </div>
</td>
                        <td width="5px">

                        </td>
                         <td width="645px">
                              <input type="button" value="Issue Item" onclick="openpopup()" class="savebutton issuediv" id="btnaccept" style="display:none;" />
                             <div class="issuediv" style='width:690px;max-height:275px;overflow:auto;display:none;'>
                                 <table  id="tblitemdetail" style="width:99%;border-collapse:collapse;text-align:left;table-layout: fixed;width:1070px;" >
                       <tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">
                     <td class="GridViewHeaderStyle" style="width:40px;">#</td>
                            <td class="GridViewHeaderStyle" style="width:40px;">Comm ent</td>
                      <td class="GridViewHeaderStyle" style="width: 190px;">Item Name</td>
                           <td class="GridViewHeaderStyle" style="width: 60px;">Remain Qty</td>
                           <td class="GridViewHeaderStyle" style="width: 80px;">Issue Qty</td>
                           <td class="GridViewHeaderStyle" style="width:40px;">Rate</td>
                           <td class="GridViewHeaderStyle" style="width:40px;">Tax Amt</td>
                           <td class="GridViewHeaderStyle" style="width:40px;">Net Amt</td>
                           <td class="GridViewHeaderStyle" style="width: 100px;">Manufacture</td>
                           <td class="GridViewHeaderStyle" style="width: 100px;">Machine</td>
                           <td class="GridViewHeaderStyle" style="width: 60px;">Pack Size</td>
                           
                          
                             
                            <td class="GridViewHeaderStyle" style="width: 80px;">Last Issue Qty</td>
                           <td class="GridViewHeaderStyle" style="width: 80px;">Last Issue Date</td>
                            <td class="GridViewHeaderStyle" style="width: 80px;">MisMatch Qty</td>
                           </tr>
                                 </table>
                                 </div>
                        </td>
                           <td width="5px">

                        </td>
                        </tr>
            </table>
                           
                </div>

          
             </div>

         </div>
     <asp:Panel ID="pnl" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >

       
                 <div class="Purchaseheader">
                     Issue Detail
                      </div>
        <table width="99%">
            <tr>
                <td style="font-weight:bold;">Invoice No : </td>
                <td>
                    <asp:TextBox ID="txtinvoiceno" runat="server"></asp:TextBox>
                                    </td>

                <td style="font-weight:bold;">
                    Invoice Date : 
                </td>
                   <td>
                    <asp:TextBox ID="txtinvoicedate" runat="server"></asp:TextBox>
                          <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtinvoicedate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                       &nbsp;&nbsp;&nbsp;
                        <span style="font-weight:bold;"> <a style="color:blue;" href="javascript:void(0)" onclick="showuploadbox()">Upload Invoice</a></span>

                       <asp:TextBox ID="lbfilename" runat="server" style="display:none;" />
                                    </td>

               
            </tr>
           <tr>
<td style="font-weight:bold;">
    Courier Detail :
</td>

               <td colspan="3">
<asp:TextBox ID="txtourierdetail" runat="server" Width="400px" MaxLength="200" />
               </td>
            </tr>

           <tr>
               <td style="font-weight:bold;">AWB Number : </td>
               <td>
                   <asp:TextBox ID="txtawbnumber" runat="server" MaxLength="100" />
               </td>
               <td style="font-weight:bold;"> Dispatch Date : </td>
              <td><asp:TextBox ID="txtdispatchdate" runat="server"></asp:TextBox>
                          <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtdispatchdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                  </td>  
           </tr>
        </table> 
        

                <center> <input type="button" value="Issue Now" class="searchbutton" onclick="acceptpurchaseorder()" />&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Cancel" /> </center>
              
    </asp:Panel>

     <cc1:ModalPopupExtender ID="modelpopup1" runat="server"   TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button1" runat="server" style="display:none" />

    <script type="text/javascript">


        $(function () {
            $('[id=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            binditem();
        });

        function showuploadbox() {
            var filename = "";
            if ($('#<%=lbfilename.ClientID%>').val() == "") {
               filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
           }
           else {
                filename = $('#<%=lbfilename.ClientID%>').val();
            }
            $('#<%=lbfilename.ClientID%>').val(filename);
               window.open('AddFile.aspx?Filename=' + filename, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');


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


        function binditem() {
           

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
           
                $.ajax({
                    url: "VendorIssueItem.aspx/binditem",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        for (i = 0; i < ItemData.length; i++) {
                            jQuery("#ddlItem").append(jQuery("<option></option>").val(ItemData[i].ItemId).html(ItemData[i].ItemName));
                        }
                        jQuery('[id*=ddlItem]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
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

        function clearform() {

            $('#<%=txtinvoiceno.ClientID%>').val('');
            $('#<%=txtourierdetail.ClientID%>').val('');
            $('#<%=lbfilename.ClientID%>').val('');
        }
        function searchdata() {


            

            $('#btnaccept').hide();

            var fromdate = $('#<%=txtFromDate.ClientID%>').val();
            var todate = $('#<%=txtToDate.ClientID%>').val();
            var postatus = $('#<%=ddlpostatus.ClientID%>').val();
            var Items = $("#ddlItem").val();
            $.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $('#tblitemdetail tr').slice(1).remove();
            $('.issuediv').hide();
            $.ajax({
                url: "VendorIssueItem.aspx/SearchData",
                data: '{fromdate:"' + fromdate + '",todate:"' + todate + '",postatus:"' + postatus + '",ponumber:"' + $('#<%=txtponumber.ClientID%>').val() + '",Items:"' + Items + '"}', // parameter map      
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
                         

                            mydata += '<td class="GridViewLabItemStyle" ><a title="Click To Show Item And Issue" style="font-weight:bold;color:blue;cursor:pointer;" onclick="showitem(this)">  ' + ItemData[i].PurchaseOrderNo + '</a></td>';

                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PODate + '</td>';
                          
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" >' + ItemData[i].Location + '</td>';
                           
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].GrossTotal, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].DiscountOnTotal, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + precise_round(ItemData[i].TaxAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' +Math.round(precise_round(ItemData[i].NetTotal, 5)) + '</td>';

                           


                            mydata += '<td class="GridViewLabItemStyle" title="Click To View Item"  ><img src="../../../App_Images/print.gif" style="cursor:pointer;" onclick="printPO(this)" />  </td>';
                            mydata += '<td class="GridViewLabItemStyle"   > ';
                            if (ItemData[i].vendorcomment == "") {
                                mydata += '<img title="Click To View/Add Comment" src="../../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="addcommentpowise(this)" /> ';
                            }
                            else {
                                mydata += '<img title="' + ItemData[i].vendorcomment + '" src="../../../App_Images/Redplus.png" style="cursor:pointer;" onclick="addcommentpowise(this)" /> ';
                            }
                            mydata += '</td>';

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

        function addcommentpowise(ctrl) {
           
            var href = "VendorComment.aspx?POID=" + $(ctrl).closest('tr').attr("id") + "&PONO=" + $(ctrl).closest('tr').find("#pono").text() + "&ItemID=&CType=1";
            openmypopup(href);
        }
        function addcommentitemwise(ctrl) {

            var href = "VendorComment.aspx?POID=" + $(ctrl).closest('tr').find("#tdpoid").text() + "&PONO=" + $(ctrl).closest('tr').find("#tdpono").text() + "&ItemID=" + $(ctrl).closest('tr').attr("id") + "&CType=2";
            openmypopup(href);
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


      

        function openpopup() {
            var itemid = "";
            var POID = "";
            var PONo = "";
            $('#tblitemdetail tr').each(function () {
                if ($(this).attr('id') != "trheader" && $(this).find('#mmcheck').is(":checked")) {
                    itemid += $(this).attr('id') + '#' + $(this).find('#txtissueqty').val() + ",";
                    POID = $(this).find('#tdpoid').html();
                    PONo = $(this).find('#tdpono').html();
                }
            });

            if (itemid == "") {
                showerrormsg("Please Enter Issue Qty");
                return;
            }

            $find("<%=modelpopup1.ClientID%>").show();
        }
       

        function acceptpurchaseorder() {
            var itemid = "";
            var POID = "";
            var PONo = "";
            $('#tblitemdetail tr').each(function () {
                if ($(this).attr('id') != "trheader" && $(this).find('#mmcheck').is(":checked")) {
                    itemid += $(this).attr('id') + '#' + $(this).find('#txtissueqty').val() + ",";
                    POID = $(this).find('#tdpoid').html();
                    PONo = $(this).find('#tdpono').html();
                }
            });

            if (itemid == "") {
                showerrormsg("Please Enter Issue Qty");
                return;
            }

            if ($('#<%=txtinvoiceno.ClientID%>').val() == "") {
                showerrormsg("Please Enter Invoice No");
                $('#<%=txtinvoiceno.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtourierdetail.ClientID%>').val() == "") {
                showerrormsg("Please Enter Courier Detail");
                $('#<%=txtourierdetail.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtawbnumber.ClientID%>').val() == "") {
                showerrormsg("Please Enter AWB  No");
                $('#<%=txtawbnumber.ClientID%>').focus();
                return;
            }
            if ($('#<%=lbfilename.ClientID%>').val() == "") {
                showerrormsg("Please Upload Invoice");
               
                return;
            }

            $.blockUI();

            $.ajax({
                url: "VendorIssueItem.aspx/IssuePoItem",
                data: '{Data:"' + itemid + '",POID:"' + POID + '",PONo:"' + PONo + '",invoiceno:"'+$('#<%=txtinvoiceno.ClientID%>').val()+'",invoicedate:"'+$('#<%=txtinvoicedate.ClientID%>').val()+'",cdetail:"'+$('#<%=txtourierdetail.ClientID%>').val()+'",filename:"'+$('#<%=lbfilename.ClientID%>').val()+'",awbnumber:"'+$('#<%=txtawbnumber.ClientID%>').val()+'",dispatchdate:"'+$('#<%=txtdispatchdate.ClientID%>').val()+'"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        showmsg("Item Issued.!");
                        $find("<%=modelpopup1.ClientID%>").hide();
                        clearform();
                        searchdata();
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


        function showitem(ctrl) {

            var POID = $(ctrl).closest('tr').attr("id");
          
            $('#tblitemdetail tr').slice(1).remove();
            $("#tblitemlist tr").removeClass("selected");

            $(ctrl).closest('tr').addClass("selected");


            $.blockUI();

            $.ajax({
                url: "VendorIssueItem.aspx/BindItemDetail",
                data: '{POID:"' + POID + '"}', // parameter map      
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



                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "";
                            mydata += "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].itemid + "'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) ;
                            if (precise_round(ItemData[i].approvedqty, 5) > 0) {
                                mydata += '<input type="checkbox" id="mmcheck" disabled="disabled" />';
                            }
                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle"   > ';
                            if (ItemData[i].vendorcommentitem == "") {
                                mydata += '<img title="Click To View/Add Comment" src="../../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="addcommentitemwise(this)" /> ';
                            }
                            else {
                                mydata += '<img title="' + ItemData[i].vendorcommentitem + '" src="../../../App_Images/Redplus.png" style="cursor:pointer;" onclick="addcommentitemwise(this)" /> ';
                            }
                            mydata += '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].itemname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdappqty">' + precise_round(ItemData[i].approvedqty, 5) + '</td>';

                            if (precise_round(ItemData[i].approvedqty, 5) > 0) {
                                mydata += '<td class="GridViewLabItemStyle" style="background-color:lightseagreen;"><input onkeyup="showme(this);" type="textbox" id="txtissueqty"  placeholder="Issue Qty" style="width:60px;background-color:papayawhip;font-weight:bold;"/></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" style="background-color:blue;font-weight:bold;color:white;">Order Qty : ' + precise_round(ItemData[i].orderqty, 5) + '<br/> Issue Qty : ' + precise_round(ItemData[i].VendorIssueQty, 5) + '</td>';
                            }
                            mydata += '<td class="GridViewLabItemStyle">' + precise_round(ItemData[i].rate, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + precise_round(ItemData[i].taxamount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + Math.round(precise_round(ItemData[i].netamount, 5)) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].ManufactureName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].machinename + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].packsize + '</td>';
                            
                            
                           
                          
                            
                            if (ItemData[i].lastissueqty == "") {
                                mydata += '<td class="GridViewLabItemStyle">0</td>';
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                            }
                            else {
                                
                                mydata += '<td class="GridViewLabItemStyle">' + precise_round(ItemData[i].lastissueqty.split('#')[0], 5) + '<br><img title="Click To View Issue Detail" src="../../../App_Images/view.gif" style="cursor:pointer;" onclick="showissuedetail(this)" /></td>';
                                mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].lastissueqty.split('#')[1] + '</td>';
                            }
                            mydata += '<td class="GridViewLabItemStyle">' + precise_round(ItemData[i].MisMatchQty, 5) + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdpoid" style="display:none;">' + ItemData[i].PurchaseOrderID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdpono" style="display:none;">' + ItemData[i].PurchaseOrderNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdorderqty" style="display:none;">' + precise_round(ItemData[i].orderqty, 5) + '</td>';
                            
                            mydata += "</tr>";


                            $('#tblitemdetail').append(mydata);

                        }


                        $('.issuediv').show();
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
            var href = "VendorItemIssueDetail.aspx?POID=" + $(ctrl).closest('tr').find("#tdpoid").text() + "&ItemID=" + $(ctrl).closest('tr').attr("id") + "&PONO=" + $(ctrl).closest('tr').find("#tdpono").text() + "&OrderQty=" + $(ctrl).closest('tr').find("#tdorderqty").text();
            openmypopup(href);
        }


        function showme(ctrl) {

            //if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

            //    if ($(ctrl).val().indexOf(".") != -1) {
            //        $(ctrl).val($(ctrl).val().replace('.', ''));
            //    }
            //}


            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
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



            var recqty = parseFloat($(ctrl).closest('tr').find('#tdappqty').html());
        

            var total = recqty;
            if (parseFloat($(ctrl).val()) > parseFloat(total)) {
                showerrormsg("Can Not Issue More Then Order Qty.!");
                $(ctrl).val(total);
                return;
            }

            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#mmcheck').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#mmcheck').prop('checked', false)
            }

        }
    </script>


</asp:Content>

