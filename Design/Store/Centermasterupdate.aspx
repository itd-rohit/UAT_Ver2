<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Centermasterupdate.aspx.cs" Inherits="Design_Store_Centermasterupdate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      
     <%: Scripts.Render("~/bundles/JQueryStore") %>

     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 


       

      <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align: center">
           
                          <b>Location Details</b>  
                 </div>        
             <div id="makerdiv" >


                   <div class="POuter_Box_Inventory" >
              
                  <div class="Purchaseheader">
                      Location Details</div>


                        <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Location  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                                                   <asp:DropDownList ID="ddlcenter" class="ddlcenter chosen-select chosen-container" runat="server"  onchange="bind_data()"></asp:DropDownList>

                    </div>
                             </div>
                        <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Address  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtname" runat="server"   MaxLength="200" CssClass="requiredField"></asp:TextBox>

                     </div>
                             </div>
                       </div>
                        <div class="POuter_Box_Inventory" style="text-align: center">
                            <input type="button" value="Update" class="searchbutton" onclick="updatedata();" id="btnsave" />
                            </div>
                  


                   <div class="POuter_Box_Inventory" >
          
                  <div class="Purchaseheader">
                      Location Store Address</div>
                        <div class="row">
                <div class="col-md-24">
                   <div style="width:100%;max-height:350px;overflow:auto;">
                   <table id="tblQuotation" style="border-collapse:collapse;width:100%">

                                        <tr id="trquuheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                        <td class="GridViewHeaderStyle">Location Name</td>
                                        <td class="GridViewHeaderStyle">Store Address</td>
                                          
                                          
                                     </tr>
                                 </table> 
                   </div>
                   </div>
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
                   bind_data();
                   bindtabledata();
               });
               function bind_data() {
                   var centerid = $('#<%=ddlcenter.ClientID%>').val();
                   if (centerid == "0") {
                       $(<%=txtname.Text%>).val('');
                       return;
                   }
                   serverCall('Centermasterupdate.aspx/getstoreadd', { id: centerid }, function (response) {
                       var ItemData = jQuery.parseJSON(response);
                       if (ItemData.length == 0) {
                           toast("Error", "No Item Found", "");
                           $('#txtname').val('');
                       }
                       else {
                           $('#txtname').val(ItemData[0].StoreLocationAddress);
                       }
                   });
               }
               function updatedata() {
                   var centerid = $('#ddlcenter').val();
                   if (centerid == "0") {
                       toast("Info", "Please Select Center", "");
                       $('#ddlcenter').focus();
                       return;
                   }
                   var add = $.trim($('#txtname').val());
                   if (add == "") {
                       toast("Info", "Please Enter Center Address", "");
                       $('#txtname').focus();
                       return;
                   }
                   serverCall('Centermasterupdate.aspx/saveaddress', { id: centerid, address: add }, function (response) {
                       toast("Success", "Successfully Updated");

                       $('#txtname').val("");
                       $('#ddlcenter').prop('selectedIndex', 0);
                        jQuery('#ddlcenter').chosen('destroy').chosen();
                       bindtabledata();
                   });
               }
               function bindtabledata() {
                   serverCall('Centermasterupdate.aspx/getitemdetailtoadd', {  }, function (response) {
                       var ItemData = jQuery.parseJSON(response);
                       if (ItemData.length == 0) {
                           toast("info", "No Item Found", "");
                       }
                       else {
                           $("#tblBody").empty();
                           $('#tblQuotation tr').slice(1).remove();
                           for (var i = 0; i <= ItemData.length - 1; i++) {
                               var a = $('#tblQuotation tr').length - 1;
                               var $myData = [];
                               $myData.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                               $myData.push('<td id="serial_number" class="order" >');$myData.push((i + 1));$myData.push('</td>');
                               $myData.push('<td id="Centername">');$myData.push(ItemData[i].location);$myData.push('</td>');
                               $myData.push('<td id="storeadd">');$myData.push(ItemData[i].StoreLocationAddress);$myData.push('</td>');
                               $myData.push('</tr>');
                               $myData = $myData.join("");
                               $('#tblQuotation').append($myData);
                           }
                       }
                   });                 
               }
               </script>
</asp:Content>

