<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="POEditAdmin.aspx.cs" Inherits="Design_Store_POEditAdmin" %>


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
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:1320px;">
         
          <div class="POuter_Box_Inventory" style="width:1316px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Purchase Order Edit</b>  
                        </td>
                    </tr>
                  
                    </table>
                </div>


              </div>


          <div class="POuter_Box_Inventory" style="width:1316px;">
            <div class="content">
                <div class="Purchaseheader" >PO Search</div>

                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">
                            Enter Purchase Order No :&nbsp;&nbsp;&nbsp;                        
                            <asp:TextBox ID="txtponumber" runat="server" style="width:404px;" placeholder="Purchase Order Number"></asp:TextBox>

                            &nbsp;&nbsp;&nbsp; 
                            <input type="button" value="Search" onclick="searchpo()" class="searchbutton" />
                        </td>
                        
                    </tr>

                    </table>
                </div>

        </div>


           <div class="POuter_Box_Inventory" style="width:1316px;">
            <div class="content">
                <div class="Purchaseheader" >PO Detail</div>
               <table width="99%">
                   <tr>
                       <td width="180px" style="font-weight: 700">PO No :</td>
                        <td style="font-weight:bold;" width="300px"><span id="ponumber"></span></td>
                        <td colspan="2" style="font-weight: 700">Supplier Name :</td>
                        <td colspan="2"><asp:DropDownList ID="ddlsupplier" runat="server" onchange="bindStateVaL();" Width="400px"></asp:DropDownList></td>
                        <td  style="font-weight: 700">State :</td>
                        <td ><asp:DropDownList ID="ddlState" runat="server" Width="200px"></asp:DropDownList></td>
                   </tr>
                   <tr>
                       <td width="150px" style="font-weight: 700">Location:</td>
                       <td style="font-weight:bold;" width="300px"><span id="location"></span>
                           <span id="location_stateid" style="display:none;"></span>
                           <span id="poid" style="display:none;"></span>
                       </td>
                       <td width="170px" style="font-weight: 700">Gross Total :</td>
                        <td style="font-weight:bold;" width="300px"><span id="grosstotal"></span></td>
                        <td width="150px" style="font-weight: 700">Discount Amt :</td>
                        <td width="200px"><span style="font-weight:bold;" id="discamt"></span> &nbsp; <strong>Tax Amt :</strong><span style="font-weight:bold;" id="taxamt"></span> </td>
                       <td width="150px" style="font-weight: 700">Net Total :</td>
                       <td style="font-weight:bold;" width="300px"><span id="nettotal"></span> </td>
                   </tr>
               </table>


                <div style="width:99%;max-height:500px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                        <th class="GridViewHeaderStyle"  style="width:20px;">S.No</th>
                                       
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                       
			                            <td class="GridViewHeaderStyle">Approved Qty</td>
                                        <td class="GridViewHeaderStyle">Rate</td>
                                        <td class="GridViewHeaderStyle">Disc Per</td>
	                                    <td class="GridViewHeaderStyle">Disc Amt</td>
	                                     <td class="GridViewHeaderStyle">IGST Per</td>
                                         <td class="GridViewHeaderStyle">CGST Per</td>
                                         <td class="GridViewHeaderStyle">SGST Per</td>
                                         <td class="GridViewHeaderStyle">Tax Amt</td>
                                         <td class="GridViewHeaderStyle">Unit Price</td>
                                         <td class="GridViewHeaderStyle">Net Amt</td>
                                        
                       
                                       
                        </tr>
                </table>

                
                </div>

                <center>
                    <input type="button" value="Update" class="savebutton" onclick="updatemenow()" />
                </center>
                </div>
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


        function searchpo() {


            var ponumber = $('#<%=txtponumber.ClientID%>').val();

            if (ponumber == "") {
                showerrormsg("Please Enter Purchase Order No");
                $('#<%=txtponumber.ClientID%>').focus();
                return;
            }
            $('#tblitemlist tr').slice(1).remove();
             $.blockUI();
            
             $.ajax({
                 url: "PoEditAdmin.aspx/SearchData",
                 data: '{ponumber:"' + ponumber + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("Invalid PO Number or PO Not Approved");
                        $('#tblitemlist tr').slice(1).remove();
                        $.unblockUI();
                        

                    }


                    else if (ItemData == "0") {
                        showerrormsg("GRN Done PO Can't be Edit");
                        $('#tblitemlist tr').slice(1).remove();
                        $.unblockUI();
                    }
                    else {
                        $('#<%=ddlsupplier.ClientID%>').val(ItemData[0].VendorID);
                        $('#ponumber').html(ItemData[0].PurchaseOrderNo);
                        $('#poid').html(ItemData[0].PurchaseOrderID);

                        $('#location').html(ItemData[0].location.split('^#^')[0]);
                        $('#location_stateid').html(ItemData[0].location.split('^#^')[1]);
                        $('#grosstotal').html(precise_round(ItemData[0].GrossTotal, 5));
                        $('#discamt').html(precise_round(ItemData[0].DiscountOnTotal, 5));
                        $('#taxamt').html(precise_round(ItemData[0].TaxAmt, 5));
                        $('#nettotal').html(precise_round(ItemData[0].NetTotal, 5));
                        bindState(ItemData[0].VendorID,ItemData[0].location.split('^#^')[1]);
                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].ItemID + "'>";

                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[i].ItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdApprovedQty">' + ItemData[i].ApprovedQty + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdRate" ><input style="width:70px;" type="text" onkeyup="showme(this);CalBuyPrice(this);" value=' + ItemData[i].Rate + ' id="txtrate"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdDiscountPercentage" ><input style="width:70px;" type="text" onkeyup="showme(this);CalBuyPrice(this);" value=' + ItemData[i].DiscountPercentage + ' id="txtdisper"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdDiscountAmount" >' + precise_round(ItemData[i].DiscountAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdIGSTPercentage" ><input style="width:70px;" onkeyup="showme(this);CalBuyPrice(this);" type="text" value=' + precise_round(ItemData[i].IGSTPercentage, 5) + ' id="txtdisperIGST"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdCGSTPercentage" ><input style="width:70px;" onkeyup="showme(this);CalBuyPrice(this);" type="text" value=' + precise_round(ItemData[i].CGSTPercentage, 5) + ' id="txtdisperCGST"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdSGSTPercentage" ><input style="width:70px;" onkeyup="showme(this);CalBuyPrice(this);" type="text" value=' + precise_round(ItemData[i].SGSTPercentage, 5) + ' id="txtdisperSGST"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdTaxAmount" >' + precise_round(ItemData[i].TaxAmount, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdUnitPrice" >' + precise_round(ItemData[i].UnitPrice, 5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdNetAmount" >' + precise_round(ItemData[i].NetAmount, 5) + '</td>';





                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);




                        }

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


            var Quantity = $(ctrl).closest("tr").find("#tdApprovedQty").text() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#tdApprovedQty").text());

            var Rate = $(ctrl).closest("tr").find("#txtrate").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtrate").val());
            var Disc = $(ctrl).closest("tr").find("#txtdisper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtdisper").val());
            if (Disc > 100) {
                $(ctrl).closest("tr").find("#txtDiscountper").val('100');
                Disc = 100;
            }
            var IGSTPer = $(ctrl).closest("tr").find("#txtdisperIGST").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtdisperIGST").val());
            var CGSTPer = $(ctrl).closest("tr").find("#txtdisperCGST").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtdisperCGST").val());
            var SGSTPer = $(ctrl).closest("tr").find("#txtdisperSGST").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtdisperSGST").val());

            var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;

            var disc = precise_round((Rate * Disc * 0.01), 5);
            var ratedisc = precise_round((Rate - disc), 5);
            var tax = precise_round((ratedisc * Tax * 0.01), 5);
            var ratetaxincludetax = precise_round((ratedisc + tax), 5);

            var discountAmout = precise_round(disc, 5);
            var TaxAmount = precise_round(tax, 5);



            $(ctrl).closest("tr").find("#tdDiscountAmount").text(discountAmout);

            $(ctrl).closest("tr").find("#tdTaxAmount").text(TaxAmount);


            $(ctrl).closest("tr").find("#tdUnitPrice").text(ratetaxincludetax);

            var NetAmount = precise_round((($(ctrl).closest("tr").find("#tdUnitPrice").html()) * Quantity), 5);

            $(ctrl).closest("tr").find("#tdNetAmount").text(NetAmount);
            getgrnamount();

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


        function getgrnamount() {
            var NetAmount = 0;
            var GrossAmount = 0;
            var DiscAmount = 0;
            var txtAmount = 0;
            $('#tblitemlist tr').each(function () {

                if ($(this).attr('id') != 'triteheader') {

                    var Quantity = $(this).closest("tr").find("#tdApprovedQty").text() == "" ? 0 : parseFloat($(this).closest("tr").find("#tdApprovedQty").text());

                    var Rate = $(this).closest("tr").find("#txtrate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtrate").val());
                    var Disc = $(this).closest("tr").find("#txtdisper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisper").val());

                    var IGSTPer = $(this).closest("tr").find("#txtdisperIGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperIGST").val());
                    var CGSTPer = $(this).closest("tr").find("#txtdisperCGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperCGST").val());
                    var SGSTPer = $(this).closest("tr").find("#txtdisperSGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperSGST").val());

                    var Tax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;

                    var disc = precise_round((Rate * Disc * 0.01), 5);
                    var ratedisc = precise_round((Rate - disc), 5);
                    var tax = precise_round((ratedisc * Tax * 0.01), 5);
                    var ratetaxincludetax = precise_round((ratedisc + tax), 5);

                    var discountAmout = precise_round(disc, 5);
                    var TaxAmount = precise_round(tax, 5);

                    GrossAmount  += precise_round(((Rate) * Quantity), 5);
                    NetAmount += precise_round((($(this).find("#tdUnitPrice").text()) * Quantity), 5);
                    DiscAmount += precise_round(((discountAmout) * Quantity), 5);
                    txtAmount += precise_round(((TaxAmount) * Quantity), 5);
                }


            });

            $('#grosstotal').html(precise_round(GrossAmount,5));
            $('#discamt').html(precise_round(DiscAmount,5));
            $('#taxamt').html(precise_round(txtAmount,5));
            $('#nettotal').html(precise_round(NetAmount,5));


        }
           


        function updatemenow() {


            if (confirm("Dear Admin.Do You Want To Change This PO")) {


                var pomaster = get_maindata();
                var podetail = get_detaildata();
                var potax = get_taxdata();
               
                if ((pomaster[8] == "") || (pomaster[8] == null)) {
                    alert('Please select state of Supplier');
                    $('#<%=ddlState.ClientID%>').focus();
                return false;
            }

                $.blockUI();
                $.ajax({
                    url: "POEditAdmin.aspx/updatepo",
                    data: JSON.stringify({ pomaster: pomaster, podetail: podetail, potax: potax }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        $.unblockUI();
                        if (result.d.split('#')[0] == "1") {
                            showmsg("PO update Successfully..!");
                            $('#tblitemlist tr').slice(1).remove();
                            $('#<%=txtponumber.ClientID%>').val('');
                            $('#<%=ddlsupplier.ClientID%>').val('1');
                            $('#<%=ddlState.ClientID%>').val('');
                            $('#ponumber').html('');
                            $('#poid').html('');

                            $('#location').html('');
                            $('#grosstotal').html('');
                            $('#discamt').html('');
                            $('#taxamt').html('');
                            $('#nettotal').html('');
                            //searchpo();
                        }
                        else {
                            showerrormsg(result.d.split('#')[1]);
                        }

                    },
                    error: function (xhr, status) {
                        showerrormsg(xhr.responseText);
                        $.unblockUI();
                    }
                });
            }
        }
         

        function get_maindata() {
            var dataMain = new Array();
            dataMain.push($('#poid').html());
            dataMain.push($('#ponumber').html());
            dataMain.push($('#ContentPlaceHolder1_ddlsupplier').val());
            dataMain.push($('#ContentPlaceHolder1_ddlsupplier option:selected').text());
            dataMain.push($('#grosstotal').html());
            dataMain.push($('#discamt').html());
            dataMain.push($('#taxamt').html());
            dataMain.push($('#nettotal').html());
            dataMain.push($('#ContentPlaceHolder1_ddlState').val());
            return dataMain;
        }


        function get_detaildata() {

            var datadetail = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
              
                if (id != "triteheader") {
                    var objdetail = new Object();
                  
                    objdetail.PurchaseOrderID = $('#poid').html();
                    objdetail.PurchaseOrderNo = $('#ponumber').html();
                        
                    objdetail.ItemID = id;
                    objdetail.Rate = $(this).closest("tr").find("#txtrate").val();

                    objdetail.TaxAmount = $(this).closest("tr").find("#tdTaxAmount").text();
                    objdetail.DiscountAmount = $(this).closest("tr").find("#tdDiscountAmount").text();
                    objdetail.DiscountPercentage = $(this).closest("tr").find("#txtdisper").val();
                    objdetail.NetAmount = $(this).closest("tr").find("#tdNetAmount").text();
                    objdetail.UnitPrice = $(this).closest("tr").find("#tdUnitPrice").text();
                   
                    datadetail.push(objdetail);

                }
            });
           

            return datadetail;
        }

        function get_taxdata() {

            var datatax = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
              
                if (id != "triteheader") {
                    var IGSTPer = $(this).closest("tr").find("#txtdisperIGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperIGST").val());
                    var CGSTPer = $(this).closest("tr").find("#txtdisperCGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperCGST").val());
                    var SGSTPer = $(this).closest("tr").find("#txtdisperSGST").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisperSGST").val());

                    if (parseFloat(IGSTPer) > 0 ) {
                        CGSTPer = 0; SGSTPer = 0;

                    }
                    if (parseFloat(CGSTPer) > 0 || parseFloat(SGSTPer) > 0) {
                        IGSTPer = 0;
                       
                    }

                    if (parseFloat(IGSTPer) > 0) {
                       
                        var objtax = new Object();
                        objtax.PurchaseOrderID = $('#poid').html();
                        objtax.PurchaseOrderNo = $('#ponumber').html();
                        
                        objtax.ItemID = id;
                        
                        objtax.TaxName = "IGST";
                        objtax.Percentage = IGSTPer;
                        var Rate = $(this).closest("tr").find("#txtrate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtrate").val());
                        var Disc = $(this).closest("tr").find("#txtdisper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisper").val());
                        var Tax = IGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(CGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.PurchaseOrderID = $('#poid').html();
                        objtax.PurchaseOrderNo = $('#ponumber').html();

                        objtax.ItemID = id;

                        objtax.TaxName = "CGST";
                        objtax.Percentage = CGSTPer;
                        var Rate = $(this).closest("tr").find("#txtrate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtrate").val());
                        var Disc = $(this).closest("tr").find("#txtdisper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisper").val());
                        var Tax = CGSTPer;
                        var disc = precise_round((Rate * Disc * 0.01), 5);
                        var ratedisc = precise_round((Rate - disc), 5);
                        var tax = precise_round((ratedisc * Tax * 0.01), 5);


                        objtax.TaxAmt = tax;
                        datatax.push(objtax);
                    }
                    if (parseFloat(SGSTPer) > 0) {
                        var objtax = new Object();
                        objtax.PurchaseOrderID = $('#poid').html();
                        objtax.PurchaseOrderNo = $('#ponumber').html();

                        objtax.ItemID = id;

                        objtax.TaxName = "SGST";
                        objtax.Percentage = SGSTPer;
                        var Rate = $(this).closest("tr").find("#txtrate").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtrate").val());
                        var Disc = $(this).closest("tr").find("#txtdisper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtdisper").val());
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

        function bindState(SupplierID,LocationStateId) {
            jQuery('#<%=ddlState.ClientID%> option').remove();
           
            if (SupplierID != "") {
                jQuery.ajax({
                    url: "POEditAdmin.aspx/bindState",
                    data: '{ SupplierID: "' + SupplierID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        var check=0;
                        for (i = 0; i < stateData.length; i++) {
                            if (LocationStateId == stateData[i].StateId) {
                                check = 1;
                            }
                            jQuery('#<%=ddlState.ClientID%>').append(jQuery("<option></option>").val(stateData[i].StateId).html(stateData[i].State));
                        }
                        if (check == 1) {
                            $('#<%=ddlState.ClientID%>').val(LocationStateId);
                        }

                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
            
        }

        function bindStateVaL() {
         var spid=   $('#<%=ddlsupplier.ClientID%>').val();
            var stateid = $('#location_stateid').html();
            
          bindState(spid, stateid);
        }

    </script>
</asp:Content>

