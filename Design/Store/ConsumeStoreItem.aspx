<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ConsumeStoreItem.aspx.cs" Inherits="Design_Store_ConsumeStoreItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <%: Scripts.Render("~/bundles/JQueryStore") %>

    

    

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    
    <div id="Pbody_box_inventory" style="text-align:center">
         
          
                          <b>Consume Store Item</b>  
                       
              </div>

         <div class="POuter_Box_Inventory" >
           
          <div class="Purchaseheader" >Location Detail</div>
             <div class="row">
	            <div class="col-md-3 " >
			        <label class="pull-left">Current Location   </label>
			         <b class="pull-right">:</b>
		        </div>
		        <div class="col-md-7 " >
			        <asp:DropDownList ID="ddllocation"  class="ddllocation chosen-select chosen-container" runat="server" ></asp:DropDownList>

		        </div>
                <div class="col-md-7 " >
                      <asp:TextBox ID="txtbarcodeno" runat="server"  placeholder="Scan Barcode For Quick Consume" BackColor="lightyellow" style="border:1px solid red;" Font-Bold="true"></asp:TextBox>
                 </div>
               <div class="col-md-5 " >
                          <input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" />
                           <input type="button" value="Reset" onclick="resetme()" class="resetbutton" /> 		 
		         </div>
              </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3 " >
			                 <label class="pull-left">Item   </label>
			                    <b class="pull-right">:</b>
		                </div>
                        <div class="col-md-5" style="display:none">
                            <input id="txtitem" style="width:300px;text-transform:uppercase;" />&nbsp;&nbsp;&nbsp;<asp:Label ID="lblItemName" runat="server"></asp:Label>
                               <asp:Label ID="lblItemGroupID" runat="server" style="display:none;"></asp:Label>
                               <asp:Label ID="lblItemID" runat="server" style="display:none;"></asp:Label>
                         </div>
                     </div>
                     <div class="row" style="display:none">
                             <div class="col-md-3 " >
			                            <label class="pull-left">Manufacturer   </label>
			                            <b class="pull-right">:</b>
		                    </div>
                            <div class="col-md-5" style="display:none">
                                        <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');" Width="300px">
                                        </asp:DropDownList> <strong>Machine : </strong><asp:DropDownList ID="ddlMachine" runat="server" Width="300px" onchange="bindTempData('PackSize');"></asp:DropDownList>

                                     <strong>Pack Size : </strong> <asp:DropDownList ID="ddlPackSize" runat="server" Width="100px" onchange="setDataAfterPackSize();" ></asp:DropDownList>
                   
                        </div>
                </div>
          <div class="POuter_Box_Inventory" >
            
                <div class="Purchaseheader" >Item Detail</div>

                <div class="row">
                <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                        <th class="GridViewHeaderStyle"  style="width:20px;">S.No</th>
                                       
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                       
			                            <td class="GridViewHeaderStyle">Issue Date</td>
                                        <td class="GridViewHeaderStyle">Batch Number</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">Barcode No</td>
	                                    <td class="GridViewHeaderStyle">Current Stock Qty</td>
	                                    <td class="GridViewHeaderStyle">Consume Qty</td>
                                        <td class="GridViewHeaderStyle"><input type="text" name="consumeremarks" onkeyup="showme2(this)"  placeholder="All Consume Remarks" maxlength="180" /></td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;"><input type="checkbox" onclick="checkall(this)"  /></td>
                       
                                       
                        </tr>
                </table>

                    <center>
                        <input type="button" class="savebutton" onclick="savealldata()" id="btnsave" style="display:none;" value="Save" />
                    </center>
                </div>

          </div>
             
        </div>

    <script type="text/javascript">
        $(function () {


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
        $(function () {
            $("#<%= txtbarcodeno.ClientID%>").keydown(
              function (e) {
                  var key = (e.keyCode ? e.keyCode : e.charCode);
                  if (key == 13) {
                      e.preventDefault();
                      if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {

                          searchitem();
                      }



                  }

              });
        });



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

            var barcodeno = $.trim($('#<%=txtbarcodeno.ClientID%>').val());
            var itemid = $('#<%=lblItemID.ClientID%>').html();

            //if (barcodeno == "" && itemid == "") {
            //    toast("Error","Please Select Item Or Enter Barcode No","");
            //    return;
            //}
            
            //  $('#tblitemlist tr').slice(1).remove();
            serverCall('ConsumeStoreItem.aspx/SearchData',{locationid:$('#<%=ddllocation.ClientID%>').val(),barcodeno:barcodeno,itemid:itemid},function(response){
            
                $responseData=$.parseJSON(response);

                if ($responseData.length == 0) {
                        toast("Error","No Item Found In Stock","");
                        $('#tblitemlist tr').slice(1).remove();
                       
                        $('#btnsave').hide();

                    }
                    else {
                    for (var i = 0; i <= $responseData.length - 1; i++) {
                        if ($('table#tblitemlist').find('#' + $responseData[i].stockid).length > 0) {
                                toast("Error","Item Already Added. Please Increase Qty.","");
                                
                                return;
                            }
                        var $mydata = [];
                        $mydata.push("<tr style='background-color:bisque;' id='"); $mydata.push( $responseData[i].stockid ); $mydata.push( "'>");

                        $mydata.push( '<td class="GridViewLabItemStyle" >' ); $mydata.push( parseInt(i+1) ); $mydata.push( '</td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" id="tditemname">' ); $mydata.push( $responseData[i].itemname ); $mydata.push( '</td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" id="tdstockdate">' ); $mydata.push( $responseData[i].stockdate ); $mydata.push( '</td>');
                           
                        $mydata.push( '<td class="GridViewLabItemStyle" id="tdbatchnumber" >' ); $mydata.push( $responseData[i].batchnumber ); $mydata.push( '</td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" id="tdexpirydate" >' ); $mydata.push( $responseData[i].ExpiryDate ); $mydata.push( '</td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" id="tdexpirydate" >' ); $mydata.push( $responseData[i].barcodeno ); $mydata.push( '</td>');
                            
                            
                           
                        $mydata.push( '<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">' ); $mydata.push( precise_round($responseData[i].InHandQty, 5) ); $mydata.push( '</span>');
                        $mydata.push( '&nbsp;<span style="font-weight:bold;color:red;" >' ); $mydata.push( $responseData[i].minorunit ); $mydata.push( '</span></td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" title="Enter Consume Qty"><input type="text" id="txtconsumeqty" style="width:70px;" onkeyup="showme(this)" />');
                        $mydata.push( '&nbsp;<span style="font-weight:bold;color:red;">' ); $mydata.push( $responseData[i].minorunit ); $mydata.push( '</span></td>');


                        $mydata.push( '<td class="GridViewLabItemStyle" ><input type="text" placeholder="Consume Remarks" maxlength="180" id="txtconsumeremarks" name="consumeremarks"/></td>');
                        $mydata.push( '<td class="GridViewLabItemStyle" ><input type="checkbox" id="chk"   /></td>');
                            
                        $mydata.push( '<td style="display:none;" id="tdlocationid">' ); $mydata.push( $responseData[i].locationid ); $mydata.push( '</td>');
                        $mydata.push( '<td style="display:none;" id="tdpanelid">' ); $mydata.push( $responseData[i].panel_id ); $mydata.push( '</td>');
                        $mydata.push( '<td style="display:none;" id="tdItemID">' ); $mydata.push( $responseData[i].itemid ); $mydata.push( '</td>');
                        $mydata.push( '<td style="display:none;" id="tdisdecimalallowed">' ); $mydata.push( $responseData[i].MinorUnitInDecimal ); $mydata.push( '</td>');
                        $mydata.push( '<td style="display:none;" id="tdIsExpirable">' ); $mydata.push( $responseData[i].IsExpirable ); $mydata.push( '</td>');

                            
                        $mydata.push( "</tr>");
                        $mydata=$mydata.join("");
                            $('#tblitemlist').append($mydata);

                           
                            $('#btnsave').show();
                        
                        }
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                       

                    }

               
            });

        }
        function showme2(ctrl) {


            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });


        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
      
        function showme(ctrl) {
            if ($(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "" || $(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "0") {
                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }            
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
            if (parseFloat($(ctrl).val()) > parseFloat($(ctrl).closest('tr').find('#spbal').html())) {
                toast("Error","Consume Qty Can't Greater Then Current Stock Qty","");
                $(ctrl).val($(ctrl).closest('tr').find('#spbal').html());
                return;
            }
            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
           
        }
        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {
                    if ($(ctr).is(":checked")) {
                        $(this).find('#chk').attr('checked', true);
                    }
                    else {
                        $(this).find('#chk').attr('checked', false);
                    }
                }
            });
        }
        function validation() {
            var che = "true";
            var a = $('#tblitemlist tr').length;
            if (a == 1) {
                toast("Info","Please Search Item..!","");
                return false;
            }
            if (a > 0) {
                $('#tblitemlist tr').each(function () {
                    if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && ($(this).find("#txtconsumeqty").val() == "" || $(this).find("#txtconsumeqty").val() == "0")) {
                        $(this).find("#txtconsumeqty").focus();
                        toast("Error","You have not Entered Qty","");
                        che = "false";
                        return false;

                    }
                });
            }
            if (che == "false") {
                return false;
            }
            return true;
        }
    </script>
    <script type="text/javascript">
        function getcompletedataadj() {
            var tempData = [];
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader") {
                    if ($(this).find("#chk").is(':checked')) {
                        var Itemmaster = [];
                        Itemmaster[0] = $(this).find('#tdlocationid').html();
                        Itemmaster[1] = $(this).find('#tdpanelid').html();
                        Itemmaster[2] = $(this).attr("id");
                        Itemmaster[3] = $(this).find('#txtconsumeqty').val();
                        Itemmaster[4] = $(this).find('#tdItemID').html();
                        Itemmaster[5] = $(this).find('#txtconsumeremarks').val();
                        Itemmaster[6] = $(this).find('#tdIsExpirable').html();
                        Itemmaster[7] = $(this).find('#tdexpirydate').html();                        
                        tempData.push(Itemmaster);
                    }
              }
          });
          return tempData;
        }
        function savealldata() {
            if (validation() == true) {
                var mydataadj = getcompletedataadj();
                if (mydataadj.length == 0) {
                    toast("Error","Please Select Item To Save","");
                    return;
                }
                serverCall('ConsumeStoreItem.aspx/saveconsume',{mydataadj: mydataadj},function(response){             
                        if (response == "1") {
                            toast("Success","Stock Consume Successfully..!","");
                            $('#tblitemlist tr').slice(1).remove();
                            resetme();
                        }
                        else {
                            toast("Error","Error","");
                        }                  
                });
            }
        }
    </script>
     <script type="text/javascript">
         $(function () {
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
                               serverCall('ConsumeStoreItem.aspx/SearchItem',{itemname:extractLast(request.term),locationidfrom:$('#<%=ddllocation.ClientID%>').val()},function(result){
                              
                                           response($.map(jQuery.parseJSON(result), function (item) {
                                               return {
                                                   label: item.ItemNameGroup,
                                                   value: item.ItemIDGroup
                                               }
                                           }))


                                      
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
    locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

    serverCall('ConsumeStoreItem.aspx/bindManufacturer',{ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup },function(response){
   
            var tempData = $.parseJSON(response);
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
                
            });
        }
        function bindMachine(ItemIDGroup, ManufactureID) {
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];

            serverCall('ConsumeStoreItem.aspx/bindMachine',{locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID},function(response){
           
                    var tempData = $.parseJSON(response);
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
               
            });
        }
        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = $('#<%=ddllocation.ClientID%>').val().split('#')[0];
            $("#<%=ddlPackSize.ClientID %> option").remove();
            serverCall('ConsumeStoreItem.aspx/bindPackSize',{ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID},function(response){
                
                         var tempData = $.parseJSON(response);
                         if (tempData.length > 1) {
                             $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val('').html('Select Pack Size'));
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
                    
                 });
         }
         function setDataAfterPackSize() {
             if ($("#<%=ddlPackSize.ClientID %>").val() != '') {
                      
                     $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);
               
                 }
            
         }

         function resetme() {
             $('#tblitemlist tr').slice(1).remove();
             $('#<%=txtbarcodeno.ClientID%>').val();
             clearTempData();
             $('#<%=ddllocation.ClientID%>').prop('selectedIndex', 0);
             $('#<%=ddllocation.ClientID%>').trigger('chosen:updated');

             $('#btnsave').hide();
         }
         function clearTempData() {
             $("#<%=ddlManufacturer.ClientID %> option").remove();
             $("#<%=ddlMachine.ClientID %> option").remove();
             $("#<%=ddlPackSize.ClientID %> option").remove();
             $("#<%=lblItemID.ClientID %>").html('');
             $("#<%=lblItemGroupID.ClientID %>").html('');
             $("#<%=lblItemName.ClientID %>").html('');
             $('#txtitem').val('');

         }
         </script>
   
  </asp:Content>

