<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PrintStockBarcode.aspx.cs" Inherits="Design_Store_PrintStockBarcode" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
     
     <%: Scripts.Render("~/bundles/JQueryStore") %>


    <style type="text/css">

        .chosen-container {
            width:800px !important;
        }
    </style>
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

      
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
         
          <div class="POuter_Box_Inventory" style="text-align:center">
            

                <div class="row">
                          <b>Print Stock Barcode</b>
                 </div>
              

                  
                <div class="row">
                  
                  <div class="md-col-3"> 
                     <b> <label class="pull-left">Current Location : </label></b>
			   </div>
                   <div class="col-md-7" >
                       <asp:DropDownList ID="ddllocation" runat="server" ></asp:DropDownList>
                   </div>
                  <div class="col-md-3" >
                          <input type="button" value="More Filter" style="font-weight:bold;cursor:pointer;" onclick="showhide()" />
                    </div>
                      
              </div>
              
              </div>

        <div class="POuter_Box_Inventory" >
           
                      <div class="row" style="display:none">
	                         <div class="col-md-3 " style="display:none">
			                        <label class="pull-left">Category Type  </label>
			                         <b class="pull-right">:</b>
		                        </div>
		   <div class="col-md-5 " style="display:none">
			    <asp:ListBox ID="ddlcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindSubcattype($(this).val())"></asp:ListBox>	 		 
		   </div>
                <div class="col-md-3 " >
			   <label class="pull-left">SubCategory Type  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:ListBox ID="ddlsubcattype" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCategory($(this).val())"></asp:ListBox> 		 
		   </div>
                          </div>
            <div class="row" style="display:none">
	                         <div class="col-md-3 " style="display:none">
			                        <label class="pull-left">Item Category  </label>
			                         <b class="pull-right">:</b>
		                        </div>
		   <div class="col-md-5 " style="display:none">
			    <asp:ListBox ID="ddlcategory" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="binditem();"></asp:ListBox>	 		 
		   </div>
                <div class="col-md-3 " >
			   <label class="pull-left">Items </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			  <asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>	 
		   </div>
                          </div>
            
                               <div class="row" style="text-align:center"  >
                                   <input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" />
                                   <input type="button" value="Print Report" onclick="printme()" class="searchbutton" />
                               </div>   
                                     
                                       
                                     

                                     
                               
               </div>
         </div>

         
          <div class="POuter_Box_Inventory" >
            
                <div class="Purchaseheader" >Item Detail</div>

                <div class="row">
                <table id="tblitemlist" style="width:99%; border-collapse:collapse; text-align:left;">
                    <tr id="triteheader">
                     
                                         
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Item Code</td>
                                        <td class="GridViewHeaderStyle">BarcodeNo</td>
                                        <td class="GridViewHeaderStyle">InHand Qty</td>
                                        <td class="GridViewHeaderStyle">Batch No</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        
                                        <td class="GridViewHeaderStyle" style="width: 60px;">Barcode</td>
                        </tr>
                </table>

                    <center>
                        

                        <input type="button" class="savebutton" onclick="printallbarcodeno()" id="btnsave1" style="display:none;float:right;margin-right:15px;" value="Print All Barcode" />
                    </center>
                </div>
              </div>
              

        
        


     <script type="text/javascript">

         function showhide() {

             $('.t1').slideToggle("fast");
         }
         $(function () {

             $('[id*=ddlcategory]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id*=ddlItem]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             $('[id*=ListItem]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             $('[id*=ddlcattype]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id*=ddlsubcattype]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });


             bindCatagoryType();



           
        });
    </script>

    <script type="text/javascript">
        function bindCatagoryType() {
            jQuery('#<%=ddlcattype.ClientID%> option').remove();
            jQuery('#ddlcattype').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindcattype',{},function(response){
                jQuery('#ddlcattype').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CategoryTypeID', textField: 'CategoryTypeName', controlID: $("#ddlcattype"), isClearControl: '' });
            });   
                  
                   
           
        }

        function bindSubcattype(CategoryTypeID) {
            jQuery('#<%=ddlsubcattype.ClientID%> option').remove();
            jQuery('#ddlsubcattype').multipleSelect("refresh");

            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (CategoryTypeID != "") {
                serverCall('MappingStoreItemWithCentre.aspx/bindSubcattype', { CategoryTypeID: CategoryTypeID.toString() }, function (response) {
                    jQuery('#ddlsubcattype').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryTypeID', textField: 'SubCategoryTypeName', controlID: $("#ddlsubcattype"), isClearControl: '' });
                });
            }
            binditem();
        }

        function bindCategory(SubCategoryTypeMasterId) {
            jQuery('#<%=ddlcategory.ClientID%> option').remove();
            jQuery('#ddlcategory').multipleSelect("refresh");

            jQuery('#<%=ddlItem.ClientID%> option').remove();
            jQuery('#ddlItem').multipleSelect("refresh");
            if (SubCategoryTypeMasterId != "") {
                serverCall('MappingStoreItemWithCentre.aspx/BindSubCategory', { SubCategoryTypeMasterId: SubCategoryTypeMasterId.toString() }, function (response) {
                    jQuery('#ddlcategory').bindMultipleSelect({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', controlID: $("#ddlcategory"), isClearControl: '' });
                });   
                   
            }

            binditem();
        }

        function binditem() {
            var CategoryTypeId = $('#ddlcattype').val();
            var SubCategoryTypeId = $('#ddlsubcattype').val();
            var CategoryId = $('#ddlcategory').val();
            if (CategoryTypeId != "") {
                jQuery('#<%=ddlItem.ClientID%> option').remove();
                jQuery('#ddlItem').multipleSelect("refresh");
                if (CategoryTypeId != "") {
                    serverCall('MappingStoreItemWithCentre.aspx/binditem',{CategoryTypeId:CategoryTypeId,SubCategoryTypeId:SubCategoryTypeId,CategoryId:CategoryId}, function(response){
                        jQuery('#ddlItem').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ItemId', textField: 'ItemName', controlID: $("#ddlItem"), isClearControl: '' });
                    });  
                    
                }
            }
        }
    </script>

    <script type="text/javascript">

      


       
       


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
    </script>

    <script type="text/javascript">

        function searchitem() {


            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error","No Location Found For Current User..!","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error","Please Select Location","");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }


            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var SubCategoryId = $('#ddlcategory').val().toString();
            var itemid = $('#ddlItem').val().toString();

          

         
           
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PrintStockBarcode.aspx/SearchData',{locationid:$('#<%=ddllocation.ClientID%>').val(),CategoryTypeId:CategoryTypeId,SubCategoryTypeId:SubCategoryTypeId,SubCategoryId:SubCategoryId,ItemId:itemid},function(response){
           
                    if (response == "-1") {
                        
                        openmapdialog();
                        return;
                    }
                    $responseData=$.parseJSON(response);
                    

                    if ($responseData.length == 0) {
                        toast("Error","No Item Found","");
                       
                    
                        $('#btnsave1').hide();

                    }
                    else {
                       
                        for (var i = 0; i <= $responseData.length - 1; i++) {
                            var $$mydata =[];
                            $mydata.push("<tr style='background-color:bisque;' id='trbody' class='tr_clone'>");

                            $mydata.push('<td class="GridViewLabItemStyle" id="tditemgroupname">'); $mydata.push( $responseData[i].itemgroup + '</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" id="tditemname">' ); $mydata.push( $responseData[i].typename ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" id="tdapolloitemcode">' ); $mydata.push($responseData[i].apolloitemcode ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" id="tdbarcodeno">'); $mydata.push($responseData[i].barcodeno); $mydata.push('</td>');
                            $mydata.push( '<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">' ); $mydata.push( precise_round($responseData[i].Balance, 5) ); $mydata.push( '</span>');
                            $mydata.push( '&nbsp;<span style="font-weight:bold;color:red;" >' ); $mydata.push( $responseData[i].MinorUnitName ); $mydata.push( '</span></td>');
                           
                           
                            $mydata.push('<td class="GridViewLabItemStyle" >' ); $mydata.push( $responseData[i].batchnumber ); $mydata.push( '</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" >' ); $mydata.push( $responseData[i].ExpiryDate ); $mydata.push('</td>');
                            $mydata.push( '<td>');
                            $mydata.push( '<input type="text" id="txtbqty" style="width:30px" onkeyup="showme1(this)" value="1" />');
                            $mydata.push( '&nbsp;&nbsp;<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printbarcode(this)"/>');
                            
                            $mydata.push( '</td>');

                            $mydata.push( '<td style="display:none;" id="tditemgroupid">' ); $mydata.push( $responseData[i].SubCategoryID ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tditemid">' ); $mydata.push( $responseData[i].itemid ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdmajorunitid">' ); $mydata.push( $responseData[i].MajorUnitId ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdmajorunitname">' ); $mydata.push( $responseData[i].MajorUnitName ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdconverter">' ); $mydata.push( $responseData[i].Converter ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdPackSize">' ); $mydata.push( $responseData[i].PackSize ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdIsExpirable">' ); $mydata.push( $responseData[i].IsExpirable ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdIssueMultiplier">' ); $mydata.push( $responseData[i].IssueMultiplier ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdminorunitid">' ); $mydata.push( $responseData[i].MinorUnitId ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdminorunitname">' ); $mydata.push( $responseData[i].MinorUnitName ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdmanufaid">' ); $mydata.push( $responseData[i].ManufactureID ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdmacid">' ); $mydata.push( $responseData[i].MachineID ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdlocationid">' ); $mydata.push( $responseData[i].LocationId ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdpanelid">' ); $mydata.push( $responseData[i].panelid ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdStockID">' ); $mydata.push( $responseData[i].StockID ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdRate">' ); $mydata.push( $responseData[i].Rate ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdDiscountPer">'); $mydata.push( $responseData[i].DiscountPer ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdDiscountAmount">' ); $mydata.push( $responseData[i].DiscountAmount ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdTaxPer">' ); $mydata.push( $responseData[i].TaxPer ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdTaxAmount">' ); $mydata.push( $responseData[i].TaxAmount ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdUnitPrice">' ); $mydata.push( $responseData[i].UnitPrice ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdMRP">' ); $mydata.push( $responseData[i].MRP ); $mydata.push( '</td>');

                            $mydata.push( '<td style="display:none;" id="tdBarcodeOption">' ); $mydata.push( $responseData[i].BarcodeOption ); $mydata.push( '</td>');
                            $mydata.push( '<td style="display:none;" id="tdBarcodeGenrationOption">' ); $mydata.push( $responseData[i].BarcodeGenrationOption ); $mydata.push( '</td>');
                            $mydata.push('<td style="display:none;" id="tdIssueInFIFO">' ); $mydata.push( $responseData[i].IssueInFIFO ); $mydata.push( '</td>');

                            $mydata.push( "</tr>");
                            $mydata=$mydata.join("");
                            $('#tblitemlist').append($mydata);

                          
                            $('#btnsave1').show();
                         

                         
                        }
                        

                       
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


        function printme() {

            var length = $('#<%=ddllocation.ClientID%> > option').length;
             if (length == 0) {
                 toast("Error","No Location Found For Current User..!","");
                 $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error","Please Select Location","");
                 $('#<%=ddllocation.ClientID%>').focus();
                return;
            }

            var CategoryTypeId = $('#ddlcattype').val().toString();
            var SubCategoryTypeId = $('#ddlsubcattype').val().toString();
            var SubCategoryId = $('#ddlcategory').val().toString();
            var itemid = $('#ddlItem').val().toString();


           
            serverCall('PrintStockBarcode.aspx/SearchDataPrint',{locationid:$('#<%=ddllocation.ClientID%>').val(),CategoryTypeId:CategoryTypeId,SubCategoryTypeId:SubCategoryTypeId,SubCategoryId:SubCategoryId,ItemId:itemid},function(response){
           

                   

                    if (response == "1") {
                        window.open('Report/commonreportstore.aspx');
                       
                    }
                    else {
                        toast("Error","No Item Found","");
                        
                    }

                
            });
        }



        function printbarcode(ctrl) {

            var stockid = $(ctrl).closest('tr').find('#tdStockID').html();
            var qty = $(ctrl).closest('tr').find('#txtbqty').val();
            if (qty == "" || qty == "0") {
                toast("Error","Please Enter Qty For Print Barcode","");
                $(ctrl).closest('tr').find('#txtbqty').focus();
                return;
            }
            try {


                var barcodedata = new Array();
                var objbarcodedata = new Object();
                objbarcodedata.stockid = stockid;
                objbarcodedata.qty = qty;
                barcodedata.push(objbarcodedata);

                serverCall('Services/StoreCommonServices.asmx/getbarcodedata',{BarcodeData: barcodedata},function(response){
               

                        window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source_store';
                   
                });
            }
            catch (e) {
                toast("Error","Barcode Printer Not Install","");
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


                serverCall('Services/StoreCommonServices.asmx/getbarcodedata',{BarcodeData: barcodedata},function(response){
               

                        window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                    
                });
            }
            catch (e) {
                toast("Error","Barcode Printer Not Install","");
            }


        }
    </script>
</asp:Content>

