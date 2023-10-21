<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorQuotation.aspx.cs" Inherits="Design_Store_VendorQuotation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    
     
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager>
         <div class="POuter_Box_Inventory" style="text-align: center">

             <b>Supplier Quotation</b>

         </div>
         <div id="makerdiv">

             <div class="POuter_Box_Inventory">

                 <div class="Purchaseheader">
                     Supplier And Location Detail
                 </div>


                 <div class="row">
                     <div class="col-md-3 ">
                         <label class="pull-left ">Supplier Name   </label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5 ">
                         <asp:DropDownList ID="ddlsupplier" runat="server" class="ddlsupplier chosen-select chosen-container" onchange="setvendordata()">
                         </asp:DropDownList>
                         <span id="QuotationID" style="display: none;"></span>
                     </div>
                     <div class="col-md-3 ">
                         <label class="pull-left ">Supplier State   </label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5 ">
                         <asp:DropDownList ID="ddlstate" runat="server" onchange="setgstndata()"></asp:DropDownList>
                     </div>
                     <div class="col-md-3 ">
                         <label class="pull-left ">GSTN No.  </label>
                         <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5 ">
                         <asp:TextBox ID="txtgstnno" runat="server" ReadOnly="true"></asp:TextBox>

                     </div>
                      </div>
                     <div class="row">
                         <div class="col-md-3 ">
                             <label class="pull-left ">Address  </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-13 ">
                             <asp:TextBox ID="txtaddress" runat="server" ReadOnly="true"></asp:TextBox>
                         </div>
                         <div class="col-md-3 ">
                             <label class="pull-left ">Supplier Type  </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5 ">
                             <asp:DropDownList ID="ddlsuppliertype" runat="server" Enabled="false">
                                 <asp:ListItem Value="0">Select</asp:ListItem>
                                 <asp:ListItem Value="Capex">Capex</asp:ListItem>
                                 <asp:ListItem Value="Opex">Opex</asp:ListItem>
                                 <asp:ListItem Value="Both">Both</asp:ListItem>
                             </asp:DropDownList>
                         </div>
                     </div>


                     <div class="row">
                         <div class="col-md-3 ">
                             <label class="pull-left ">Delivery State  </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5 ">
                             <asp:DropDownList ID="ddlcentrestate" runat="server" onchange="bindCentre()" />
                         </div>
                         
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Centre Type </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                             </div>

                             <div class="col-md-3 ">
                                 <label class="pull-left ">Centre </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                             </div>

                         </div>

                         <div class="row">
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Delivery Location  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                             </div>

                             <div class="col-md-3 ">
                                 <label class="pull-left ">From Date  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-2 ">
                                 <asp:TextBox ID="txtentrydate" runat="server" ReadOnly="true"  CssClass="requiredField"/>
                                 <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                             </div>

                             <div class="col-md-2 ">
                                 <label class="pull-left ">To Date  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-2 ">
                                 <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" CssClass="requiredField" />
                                 <cc1:CalendarExtender ID="txtentrydate0_CalendarExtender0" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                             </div>

                             <div class="col-md-2 ">
                                 <label class="pull-left ">Ref No.</label>
                                 <b class="pull-right">:</b>
                             </div>

                             <div class="col-md-3 ">
                                 <asp:TextBox ID="txtquationrefno" runat="server"></asp:TextBox>
                             </div>
                         </div>
                         <div class="Purchaseheader">Item Detail</div>

                         <div class="row">
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Machine  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:DropDownList ID="ddlmachineall" runat="server"></asp:DropDownList>

                             </div>
                             <div class="col-md-3 ">
                                 <input type="button" value="Add All Item" class="searchbutton" onclick="AddAllitem()" />
                             </div>
                         </div>

                         <div class="row">
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Item  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5">
                                
                                 <asp:TextBox ID="txtitem" runat="server" ClientIDMode="Static" style="text-transform: uppercase;"></asp:TextBox>
                             </div>

                             <div class="col-md-3 ">
                                 <label class="pull-left ">Item  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:Label ID="lblItemName" runat="server"></asp:Label>
                                 <asp:Label ID="lblItemGroupID" runat="server" Style="display: none;"></asp:Label>
                                 <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                             </div>

                         </div>

                         <div class="row">
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Manufacturer  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');">
                                 </asp:DropDownList>
                             </div>
                             <div class="col-md-3 ">
                                 <label class="pull-left ">Machine  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-5 ">
                                 <asp:DropDownList ID="ddlMachine" runat="server" onchange="bindTempData('PackSize');"></asp:DropDownList>
                             </div>

                             <div class="col-md-3 ">
                                 <label class="pull-left ">Pack Size  </label>
                                 <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-3 ">
                                 <asp:DropDownList ID="ddlPackSize" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>
                             </div>
                             <div class="col-md-2 ">
                                 <input type="button" class="searchbutton" value="Add" onclick="AddItem()" />

                             </div>
                         </div>

                     </div>
                

                 <div class="POuter_Box_Inventory">

                     <div class="Purchaseheader">
                         Added Item
                     </div>
                     <div class="row">
                         <div class="col-md-24">
                             <div style="width: 100%; max-height: 200px; overflow: auto;">
                                 <table id="tblQuotation" style="border-collapse: collapse">
                                     <tr id="trquuheader">
                                         <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                         <td class="GridViewHeaderStyle">Item Category</td>
                                         <td class="GridViewHeaderStyle">ItemID</td>
                                         <td class="GridViewHeaderStyle">Item Name</td>
                                         <td class="GridViewHeaderStyle">Hsn Code</td>
                                         <td class="GridViewHeaderStyle">Manufacturer</td>
                                         <td class="GridViewHeaderStyle">Catalog No</td>
                                         <td class="GridViewHeaderStyle">Machine</td>
                                         <td class="GridViewHeaderStyle">Purchased Unit</td>
                                         <td class="GridViewHeaderStyle">Pack Size</td>
                                         <td class="GridViewHeaderStyle">Consumption Unit</td>
                                         <td class="GridViewHeaderStyle" style="display: none;">Quantity</td>
                                         <td class="GridViewHeaderStyle">Rate</td>
                                         <td class="GridViewHeaderStyle">Discount %</td>
                                         <td class="GridViewHeaderStyle">IGST %</td>
                                         <td class="GridViewHeaderStyle">CGST %</td>
                                         <td class="GridViewHeaderStyle">SGST %</td>

                                         <td class="GridViewHeaderStyle">Total GST %</td>
                                         <td class="GridViewHeaderStyle">Change<br />
                                             Tax</td>
                                         <td class="GridViewHeaderStyle">Discount Amount</td>
                                         <td class="GridViewHeaderStyle">Total GST Amount</td>
                                         <td class="GridViewHeaderStyle" style="display: none;">BuyPrice</td>
                                         <td class="GridViewHeaderStyle" style="display: none;">Net Amt</td>
                                         <td class="GridViewHeaderStyle" style="width: 20px;">#</td>

                                     </tr>
                                 </table>
                             </div>
                         </div>
                     </div>

                 </div>

                 <div class="POuter_Box_Inventory">

                     <div class="Purchaseheader">
                         Terms & Conditions
                     </div>

                     <div class="row">
                         <div class="col-md-3 ">
                             <label class="pull-left ">Terms  </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-6 ">
                             <asp:TextBox ID="txtterm" runat="server" />

                         </div>
                         <div class="col-md-2 ">
                             <input type="button" value="Add" onclick="Addterm()" class="searchbutton" />
                         </div>

                         <div class="col-md-11 ">
                             <div style="width: 75%; max-height: 50px; overflow: auto;">
                                 <table id="tblterms" style="border-collapse: collapse" width="95%">
                                     <tr id="termsheader">
                                         <td class="GridViewHeaderStyle" style="width: 80px;">S.No.</td>
                                         <td class="GridViewHeaderStyle">Terms</td>
                                         <td class="GridViewHeaderStyle" style="width: 30px;">#</td>
                                     </tr>
                                 </table>
                             </div>
                         </div>
                     </div>

                 </div>



                 <div class="POuter_Box_Inventory" style="text-align: center;">

                     <input type="button" value="Save" class="savebutton" onclick="savedata();" id="btnsave" />
                     <input type="button" value="Update" class="savebutton" onclick="updateitem();" id="btnupdate" style="display: none;" />
                     <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />

                 </div>

            
         </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">

             <div class="Purchaseheader">
                 <div class="row">
                     <div class="col-md-3 ">
                         <label class="pull-left ">No of Record   </label>
                         <b class="pull-right">:</b>


                     </div>
                     <div class="col-md-3 ">
                         <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                             <asp:ListItem Value="5">5</asp:ListItem>
                             <asp:ListItem Value="10">10</asp:ListItem>
                             <asp:ListItem Value="20">20</asp:ListItem>
                             <asp:ListItem Value="50">50</asp:ListItem>
                             <asp:ListItem Value="100">100</asp:ListItem>
                         </asp:DropDownList>
                     </div>

                     <div class="col-md-2 " style="width: 25px; height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">
                     </div>
                     <div class="col-md-2 ">Created</div>

                     <div class="col-md-2 " style="width: 25px; height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"></div>

                     <div class="col-md-2 ">Checked</div>
                     <div class="col-md-2 " style="width: 25px; height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;"></div>

                     <div class="col-md-2 ">Approved</div>



                     <div class="col-md-3 ">
                         <label class="pull-left ">Location   </label>
                         <b class="pull-right">:</b>
                     </div>

                     <div class="col-md-5 ">
                         <asp:DropDownList ID="ddllocationsearch" class="ddllocationsearch chosen-select chosen-container" runat="server"></asp:DropDownList>
                     </div>
                 </div>

             </div>
             <div class="row">
                 <div class="col-md-3 ">
                     <label class="pull-left ">Qt No/Ref No   </label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-3 ">
                     <asp:TextBox ID="txtqrefnosearch" ClientIDMode="Static" runat="server">
                     </asp:TextBox>
                 </div>

                 <div class="col-md-2 ">
                     <label class="pull-left ">Supplier  </label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5 ">
                     <asp:DropDownList ID="ddlsuppliersearch" runat="server" class="ddlsuppliersearch chosen-select chosen-container">
                     </asp:DropDownList>
                 </div>
                 <div class="col-md-2 ">
                     <label class="pull-left ">Item  </label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-5 ">
                     <asp:DropDownList ID="ddlitemsearch" runat="server" class="ddlitemsearch chosen-select chosen-container">
                     </asp:DropDownList>
                 </div>
                 
             </div>

             <div class="row">
                 <div class="col-md-3 ">
                     <label class="pull-left ">From Date  </label>
                     <b class="pull-right">:</b>
                 </div>


                 <div class="col-md-2 ">
                     <asp:TextBox ID="txtfromdate" runat="server" ReadOnly="true" />
                     <cc1:CalendarExtender ID="txtentrydate0_CalendarExtender" runat="server" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                 </div>
                 <div class="col-md-1 "></div>
                 <div class="col-md-2 ">
                     <label class="pull-left ">To Date  </label>
                     <b class="pull-right">:</b>
                 </div>

                 <div class="col-md-2 ">
                     <asp:TextBox ID="txttodate" runat="server"  ReadOnly="true" />
                     <cc1:CalendarExtender ID="txtentrydate1_CalendarExtender" runat="server" TargetControlID="txttodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                 </div>
                 <div class="col-md-3 "></div>
                 <div class="col-md-2 ">
                     <label class="pull-left ">Status  </label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-3 ">
                     <asp:DropDownList ID="ddlstatus" ClientIDMode="Static" runat="server">
                         <asp:ListItem Value="">All</asp:ListItem>
                         <asp:ListItem Value="0">Created</asp:ListItem>
                         <asp:ListItem Value="1">Checked</asp:ListItem>
                         <asp:ListItem Value="2">Approved</asp:ListItem>
                     </asp:DropDownList>
                 </div>

                 <div class="col-md-2 ">

                     <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />

                 </div>
             </div>
             <div class="row">
                 
                     <div style="max-height: 200px; overflow: auto;">
                         <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                             <tr id="triteheader">
                                 <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                 <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                                 <td class="GridViewHeaderStyle" style="width: 30px;">Check</td>
                                 <td class="GridViewHeaderStyle" style="width: 30px;">Approve</td>
                                 <td class="GridViewHeaderStyle" style="width: 30px;">Print</td>
                                 <td class="GridViewHeaderStyle" style="width: 100px;">Quoation No.</td>
                                 <td class="GridViewHeaderStyle" style="width: 80px;">From Date</td>
                                 <td class="GridViewHeaderStyle" style="width: 80px;">To Date</td>
                                 <td class="GridViewHeaderStyle">Vendor Name</td>
                                 <td class="GridViewHeaderStyle">Vendor Address</td>
                                 <td class="GridViewHeaderStyle">GSTN No.</td>
                                 <td class="GridViewHeaderStyle">Delivery State</td>

                                 <td class="GridViewHeaderStyle">Delivery Location</td>

                             </tr>
                         </table>
                     </div>
             </div>
         </div>

    
 </div>

    <asp:Panel ID="pnl" runat="server" Style="display: none; border: 1px solid;" BackColor="aquamarine" Width="800px">


        <div class="Purchaseheader">
            Change Tax Percentage
        </div>
        <div style="width: 99%; max-height: 375px; overflow: auto;">

            <table width="99%">

                <tr>
                    <td style="font-weight: bold;">Item Name:&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtolditemname" runat="server" Width="600px" ReadOnly="true" />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Old Tax Percentage:&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtoldtax" runat="server" Width="80px" ReadOnly="true" />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">New Tax Percentage :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtnewtax" runat="server" Width="80px"></asp:TextBox>
                        <asp:TextBox ID="txtnewitemid" runat="server" Style="display: none;"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtnewtax">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
            </table>


        </div>

        <center>
            <input type="button" value="Change Tax" id="btnaddall" class="savebutton" onclick="changetax()" />
            &nbsp;&nbsp;&nbsp;<asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
        </center>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelpopup1" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button1" runat="server" Style="display: none" />



    <script type="text/javascript">




        $(function () {
                
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
                
               
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
              
               
            bindcentertype();
               

        });


        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery('#lstCentreType').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });

            });

                
             }

             function bindCentre() {
                 var StateID = $('#<%=ddlcentrestate.ClientID%>').val();

                 if (StateID == "0") {
                     toast("Error", "Please Select State.!");
                     return;
                 }

            
                 var TypeId = jQuery('#lstCentreType').val().toString();
                 var ZoneId = "";
                 var cityId = "";
                 jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");

            serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {
                jQuery("#lstCentre").bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), });
            });

           

            bindlocation();
        }

        function bindlocation() {

            var StateID = jQuery('#lstState').val();

            var StateID = $('#<%=ddlcentrestate.ClientID%>').val();

                 if (StateID == "0") {
                     toast("Error", "Please Select State.!");
                 }

                 var TypeId = jQuery('#lstCentreType').val().toString();
                 var ZoneId = "";
                 var cityId = "";

                 var centreid = jQuery('#lstCentre').val().toString();
                 jQuery('#<%=lstlocation.ClientID%> option').remove();
                 jQuery('#lstlocation').multipleSelect("refresh");
            

                 serverCall('VendorQuotation.aspx/bindlocation', { centreid: centreid , StateID:  StateID , TypeId:  TypeId , ZoneId:  ZoneId , cityId:  cityId  }, function (response) {
                     jQuery("#lstlocation").bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), });
                 });

                

             }


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

                                   serverCall('VendorQuotation.aspx/SearchItem', { itemname: extractLast(request.term), locationidfrom: jQuery('#lstlocation').val().toString(), itemtype: $('#<%=ddlsuppliertype.ClientID%>').val() }, function (responseResult) {
                                       response($.map(jQuery.parseJSON(responseResult), function (item) {
                                           return {
                                               label: item.ItemNameGroup,
                                               value: item.ItemIDGroup
                                           }
                                       }))

                                   },'',false);
                                   
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
            locationidfrom = jQuery('#lstlocation').val().toString();

            serverCall('VendorQuotation.aspx/bindManufacturer', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup }, function (response) {
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
    locationidfrom = jQuery('#lstlocation').val().toString();

    serverCall('VendorQuotation.aspx/bindMachine', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID:  ManufactureID }, function (response) {

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
            locationidfrom = jQuery('#lstlocation').val().toString();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            serverCall('VendorQuotation.aspx/bindPackSize', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }, function (response) {
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

         
         


          var approvaltypemaker = '<%=approvaltypemaker %>';
         var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>'; 
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
               
           

            if (approvaltypemaker == "1") {
                $('#makerdiv').show();
            }
            else {
                $('#makerdiv').hide();
            }

        });

        function bindvendor() {


            var dropdown = $("#<%=ddlsupplier.ClientID%>");
                 $("#<%=ddlsupplier.ClientID%> option").remove();

                 var dropdown1 = $("#<%=ddlsuppliersearch.ClientID%>");
                 $("#<%=ddlsuppliersearch.ClientID%> option").remove();

            serverCall('Services/StoreCommonServices.asmx/bindsupplier', {  }, function (response) {
                PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    dropdown.append($("<option></option>").val("0").html("--No Supplier Found--"));
                    dropdown1.append($("<option></option>").val("0").html("--No Supplier Found--"));
                }
                else {
                    dropdown.append($("<option></option>").val("0").html("Select Supplier"));
                    dropdown1.append($("<option></option>").val("0").html("Select Supplier"));
                    for (i = 0; i < PanelData.length; i++) {
                        dropdown.append($("<option></option>").val(PanelData[i].supplierid).html(PanelData[i].suppliername));
                        dropdown1.append($("<option></option>").val(PanelData[i].supplierid).html(PanelData[i].suppliername));
                    }
                }
                dropdown.trigger('chosen:updated');
                dropdown1.trigger('chosen:updated');
                
                 });
             }

            


             

            

        function setvendordata() {
            var dropdown = $("#<%=ddlstate.ClientID%>");
            $("#<%=ddlstate.ClientID%> option").remove();
            $('#<%=txtaddress.ClientID%>').val('');
            $('#<%=txtgstnno.ClientID%>').val('');
            serverCall('Services/StoreCommonServices.asmx/bindvendorgstndata', { vendorid: $('#<%=ddlsupplier.ClientID%>').val() }, function (response) {
                PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    $("#<%=ddlstate.ClientID%> option").remove();
                }
                else {
                    if (PanelData.length > 1) {
                        dropdown.append($("<option></option>").val("0").html("Select State"));
                    }
                   

                    for (i = 0; i < PanelData.length; i++) {
                        dropdown.append($("<option></option>").val(PanelData[i].stateid).html(PanelData[i].state));
                    }
                    if (PanelData.length == 1) {
                        setgstndata();
                    }
                }

            });

        }

             function setgstndata() {
                 if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                     $('#<%=txtgstnno.ClientID%>').val('');
                     $('#<%=ddlsuppliertype.ClientID%>').val('');
                 }
                 else {
                     $('#<%=txtgstnno.ClientID%>').val($('#<%=ddlstate.ClientID%>').val().split('#&#')[1]);
                     $('#<%=ddlsuppliertype.ClientID%>').val($('#<%=ddlstate.ClientID%>').val().split('#&#')[2]);
                     $('#<%=txtaddress.ClientID%>').val($('#<%=ddlstate.ClientID%>').val().split('#&#')[3]);
                 }
             }

             

    </script>

    <script type="text/javascript">
            
        function AddItem() {

            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                     toast("Error","Please Select Supplier");
                     $('#<%=ddlsupplier.ClientID%>').focus();
                     return;
                 }
                 var length = $('#<%=ddlstate.ClientID%> > option').length;
                 if (length == 0) {
                     toast("Error", "No State Found For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return;
                 }
                 if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                     toast("Error", "Please Select State For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return false;
                 }

                 if ($('#<%=ddlcentrestate.ClientID%>').val() == "0") {
                     toast("Error", "Please Select Delivery  State");
                     $('#<%=ddlcentrestate.ClientID%>').focus();
                     return;
                 }



                 var location = $('#<%=lstlocation.ClientID%>').val();
                 if (location == "") {
                     toast("Error", "Please Select Delivery Location");
                     $('#<%=lstlocation.ClientID%>').focus();
                     return;
                 }


                 if ($('#<%=ddlManufacturer.ClientID%>').val() == "") {
                     toast("Error", "Please Select Manufacturer");
                     $('#<%=ddlManufacturer.ClientID%>').focus();
                     return;
                 }
                 if ($('#<%=ddlMachine.ClientID%>').val() == "") {
                     toast("Error", "Please Select Machine");
                     $('#<%=ddlMachine.ClientID%>').focus();
                     return;
                 }
                 if ($('#<%=ddlPackSize.ClientID%>').val() == "") {
                     toast("Error", "Please Select PackSize");
                     $('#<%=ddlPackSize.ClientID%>').focus();
                     return;
                 }
                 if ($('#<%=lblItemID.ClientID%>').html() == "") {
                     toast("Error", "Please Select Item");
                     $('#txtitem').focus();
                     return;
                 }
                
            serverCall('VendorQuotation.aspx/getitemdetailtoadd', { itemid: $('#<%=lblItemID.ClientID%>').html() }, function (response) {
                PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    toast("Info", "Data Not Found.!");
                }
                else {
                    var id = PanelData[0].Itemid;


if ($('table#tblQuotation').find('#' + id).length > 0) {

                    
                        toast("Error", "Data Already Added");
                        return;

                    }


                             var a = $('#tblQuotation tr').length - 1;
                             var $mydata = [];


                             $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="'); $mydata.push(id); $mydata.push('">');

                             $mydata.push('<td  align="left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('<br/><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetailitem(this)" /></td>');
                             $mydata.push('<td align="left" id="tdItemCategory">');$mydata.push( PanelData[0].ItemCategory);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdItemid1" style="font-weight:bold;">');$mydata.push( PanelData[0].Itemid);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdItemName">');$mydata.push( PanelData[0].ItemName);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdhsncode">');$mydata.push( PanelData[0].hsncode);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdManufactureName">');$mydata.push( PanelData[0].ManufactureName);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdcatalogno">');$mydata.push( PanelData[0].catalogno);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdMachineName">' );$mydata.push( PanelData[0].MachineName);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdMajorUnitName">' );$mydata.push( PanelData[0].MajorUnitName);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdPackSize">');$mydata.push( PanelData[0].PackSize);$mydata.push('</td>');
                             $mydata.push('<td align="left" id="tdMinorUnitName">');$mydata.push( PanelData[0].MinorUnitName);$mydata.push('</td>');

                             $mydata.push('<td align="left" id="tdQuantity" style="display:none;"><input type="text" value="1" readonly="readonly"  style="width:60px" id="txtQuantity" onkeyup="CalBuyPrice(this);"/></td>');
                             $mydata.push('<td align="left" id="tdRate"><input type="text"  style="width:60px" id="txtRate" onkeyup="CalBuyPrice(this);"/></td>');
                             $mydata.push('<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);"/></td>');

                             //case 1 If Vendor State== Delivery State GST break In To CGST and SGST Apply
                             if ($('#<%=ddlstate.ClientID%>').val().split('#')[0] == $('#<%=ddlcentrestate.ClientID%>').val()) {
                            var cgst = PanelData[0].gstntax / 2;

                            $mydata.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                            $mydata.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" readonly="true" onkeyup="CalBuyPrice(this);" value="'); $mydata.push( cgst);$mydata.push('"/></td>');
                            $mydata.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" readonly="true" onkeyup="CalBuyPrice(this);" value="');$mydata.push(cgst); $mydata.push('"/></td>');
                            $mydata.push('<td align="left" id="tdTotalGST"><input type="text"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true" value="');$mydata.push( PanelData[0].gstntax); $mydata.push('" /></td>');
                        }
                            //case 2 If Vendor State <> Delivery State Only IGST Apply
                        else {

                                 $mydata.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" readonly="true" onkeyup="CalBuyPrice(this);" value="'); $mydata.push(PanelData[0].gstntax);$mydata.push('" /></td>');
                            $mydata.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                            $mydata.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                            $mydata.push('<td align="left" id="tdTotalGST"><input type="text"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true" value="');$mydata.push(PanelData[0].gstntax);$mydata.push('" /></td>');
                        }



                        $mydata.push('<td align="left" id="tdFreeQty" style="display:none;"><input type="text"  style="width:60px" id="txtFreeQty"/></td>');
                        $mydata.push('<td align="center" style="background-color:maroon;" id="tdchangetax"><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="edittax(this)"/></td>');
                        $mydata.push('<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>');
                        $mydata.push('<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>');
                        $mydata.push('<td align="left" id="tdBuyPrice" style="display:none;"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>');
                        $mydata.push('<td align="left" id="tdNetAmt" style="display:none;"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>');






                        $mydata.push('<td  id="tditemtypeid" style="display:none;">');$mydata.push( PanelData[0].itemtypeid);$mydata.push('</td>');
                        $mydata.push('<td  id="tdItemid" style="display:none;">');$mydata.push( PanelData[0].Itemid);$mydata.push('</td>');
                        $mydata.push('<td  id="tdManufactureID" style="display:none;">');$mydata.push( PanelData[0].ManufactureID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdMachineID" style="display:none;">');$mydata.push( PanelData[0].MachineID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdMajorUnitId" style="display:none;">');$mydata.push(PanelData[0].MajorUnitId);$mydata.push('</td>');
                        $mydata.push('<td  id="tdMinorUnitId" style="display:none;">');$mydata.push( PanelData[0].MinorUnitId);$mydata.push('</td>');
                        $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');


                        $mydata.push('</tr>');

                       
                        $mydata = $mydata.join("");
                        $('#tblQuotation').append($mydata);

                        var dropdown = $("#<%=ddlsupplier.ClientID%>");
                             dropdown.attr("disabled", true);
                             dropdown.trigger('chosen:updated');


                             var dropdown1 = $("#<%=lstCentre.ClientID%>");
                             dropdown1.attr("disabled", true);



                             var dropdown2 = $("#<%=ddlstate.ClientID%>");
                             dropdown2.attr("disabled", true);

                             var dropdown3 = $("#<%=ddlcentrestate.ClientID%>");
                             dropdown3.attr("disabled", true);



                             jQuery('#lstlocation').multipleSelect("disable");
                             jQuery('#lstCentreType').multipleSelect("disable");
                             jQuery('#lstCentre').multipleSelect("disable");

                         }
            });

                 



                 clearTempData();

             }

             function clearTempData() {
                 $("#<%=ddlManufacturer.ClientID %> option").remove();
                 $("#<%=ddlMachine.ClientID %> option").remove();
                 $("#<%=ddlPackSize.ClientID %> option").remove();
                 $("#<%=lblItemID.ClientID %>").html('');
                 $("#<%=lblItemGroupID.ClientID %>").html('');
                 $("#<%=lblItemName.ClientID %>").html('');
                  
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

                 var NetAmount = precise_round((( $(ctrl).closest("tr").find("#txtBuyPrice").val()) * Quantity), 5);
                 
                 $(ctrl).closest("tr").find("#txtNetAmt").val(NetAmount);


             }
             function deleterow(itemid) {
                 var table = document.getElementById('tblQuotation');
                 table.deleteRow(itemid.parentNode.parentNode.rowIndex);

             }

             
             function Addterm() {

                 if ($('#<%=txtterm.ClientID%>').val() == "") {
                     toast("Error", "Please Enter term");
                     $('#<%=txtterm.ClientID%>').focus();
                     return;
                 }
                 var id = $('#<%=txtterm.ClientID%>').val().replace(' ', '');

                 if ($('table#tblterms').find('#' + id).length > 0) {
                     toast("Error", "Term Already Added");
                     return;
                 }
                 var a = $('#tblterms tr').length - 1;
                 var $mydata = [];
                 $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=');$mydata.push( id); $mydata.push('>');
                 $mydata.push('<td  align="left" >'); $mydata.push( parseFloat(a + 1)); $mydata.push('</td>');
                 $mydata.push('<td align="left" id="tdterm">'); $mydata.push($('#<%=txtterm.ClientID%>').val()); $mydata.push('</td>');
                 $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>');
                 $mydata.push('</tr>');

                
                 $mydata = $mydata.join("");
                 $('#tblterms').append($mydata);
                 $('#<%=txtterm.ClientID%>').val('');
             }
             function deleterow2(itemid) {
                 var table = document.getElementById('tblterms');
                 table.deleteRow(itemid.parentNode.parentNode.rowIndex);

             }

           

    </script>

    <script type="text/javascript">
        function savedata() {
            if (validation() == false) {
                return;
            }

            var quotationdata = getquotationdata();
            var quotationdataterm = getquotationdataterm();
         
            $("#btnsave").attr('disabled', true).val("Submiting...");
            serverCall('VendorQuotation.aspx/SaveVendorQuotation', { quotationdata: quotationdata, quotationdataterm: quotationdataterm }, function (response) {

           
                         
                    var save = response;
                    if (save.split('#')[0] == "1") {

                        $('#btnsave').attr('disabled', false).val("Save");
                        clearForm();
                        toast("Success","Quotation No.: " + save.split('#')[1]);
                        window.open('VendorQutReport.aspx?QutationNo=' + save.split('#')[1]);
                        searchitem();



                    }
                    else {
                             
                        toast("Error", save.split('#')[1]);
                        $('#btnsave').attr('disabled', false).val("Save");
                             
                    }
                
            });
        }

        function clearForm() {
            $('#QuotationID').html('');
            $('#btnsave').show();
            $('#btnupdate').hide();
            $('#<%=ddlsupplier.ClientID%>').prop('selectedIndex', 0);

                 
                
                 $("#<%=ddlstate.ClientID%> option").remove();
                 $('#<%=ddlcentrestate.ClientID%>').prop('selectedIndex', 0);


                 var dropdown = $("#<%=ddlsupplier.ClientID%>");
                 dropdown.attr("disabled", false);
                 dropdown.trigger('chosen:updated');


               


                 var dropdown2 = $("#<%=ddlstate.ClientID%>");
                 dropdown2.attr("disabled", false);

                 var dropdown3 = $("#<%=ddlcentrestate.ClientID%>");
            dropdown3.attr("disabled", false);


              
                

            $('#<%=txtaddress.ClientID%>').val('');
                 $('#<%=txtgstnno.ClientID%>').val('');
                 $('#<%=txtquationrefno.ClientID%>').val('');
                 $('#<%=ddlsuppliertype.ClientID%>').val('');

                 $('#tblQuotation tr').slice(1).remove();
                 $('#tblterms tr').slice(1).remove();
                 var date = new Date();
                 var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                    "Aug", "Sep", "Oct", "Nov", "Dec"];
               
                 var val = date.getDate() + "-" + months[date.getMonth()] + "-" + date.getFullYear();
                 $('#<%=txtentrydate.ClientID%>').val('');
                 $('#<%=txtentrydateto.ClientID%>').val('');


                 jQuery('#lstlocation').multipleSelect("enable");
                 jQuery('#lstCentreType').multipleSelect("enable");
                 jQuery('#lstCentre').multipleSelect("enable");


                 jQuery('#<%=lstlocation.ClientID%> option').remove();
                 jQuery('#lstlocation').multipleSelect("refresh");

                

            jQuery('#<%=lstCentre.ClientID%> option').remove();
                 jQuery('#lstCentre').multipleSelect("refresh");

                 $('#<%=ddlmachineall.ClientID%>').prop('selectedIndex', 0);
                 

             }


             function validation() {
                 if($('#<%=ddlsupplier.ClientID%>').val()=="0")
                 {
                     toast("Error", "Please Select Supplier");
                     $('#<%=ddlsupplier.ClientID%>').focus();
                     return false;
                 }
                 var length = $('#<%=ddlstate.ClientID%> > option').length;
                 if (length == 0) {
                     toast("Error", "No State Found For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return false;
                 }
                 if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                     toast("Error", "Please Select State For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return false;
                 }
                   
                 if ($('#<%=txtentrydate.ClientID%>').val() == "") {
                     toast("Error", "Please Select From Date");
                     $('#<%=txtentrydate.ClientID%>').focus();
                     return false;
                 }
                 if ($('#<%=txtentrydateto.ClientID%>').val() == "") {
                     toast("Error", "Please Select To Date");
                     $('#<%=txtentrydateto.ClientID%>').focus();
                     return false;
                 }

                 var count = $('#tblQuotation tr').length;
                 if (count == 0 || count == 1) {
                     toast("Error", "Please Select Item To set Quotation ");
                      
                     return false;
                 }

                 var sn = 0;
                 $('#tblQuotation tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trquuheader") {
                         var rate = $(this).find('#txtRate').val() == "" ? 0 : parseFloat($(this).find('#txtRate').val());
                            
                            
                         if (rate == 0) {
                             sn = 1;
                             $(this).find('#txtRate').focus();
                             return;
                         }
                     }
                 });

                 if (sn == 1) {
                     toast("Error", "Please Enter Rate ");
                     return false;
                 }

                 var sn1 = 0;
                 $('#tblQuotation tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trquuheader") {
                         var qty = $(this).find('#txtQuantity').val() == "" ? 0 : parseFloat($(this).find('#txtQuantity').val());
                         if (qty == 0) {
                             sn1 = 1;
                             $(this).find('#txtQuantity').focus();
                             
                             return;
                         }
                     }
                 });

                 if (sn1 == 1) {
                     toast("Error", "Please Enter Quantity ");
                     return false;
                 }



                 return true;
             }

    </script>


    <script type="text/javascript">
        function getquotationdata() {
            var dataIm = new Array();
            var LocationID = jQuery('#<%=lstlocation.ClientID%>').val();
               
                
                 $('#tblQuotation tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trquuheader") {
                         var objQuotation = new Object();
                         objQuotation.Qutationno = $('#QuotationID').html();
                         objQuotation.Quotationrefno = $('#<%=txtquationrefno.ClientID%>').val();
                         objQuotation.VendorId = $('#<%=ddlsupplier.ClientID%>').val();
                         objQuotation.VendorName = $('#<%=ddlsupplier.ClientID%> option:selected').text();
                         objQuotation.VendorAddress = $('#<%=txtaddress.ClientID%>').val();
                         objQuotation.VendorStateId = $('#<%=ddlstate.ClientID%>').val().split('#')[0];
                         objQuotation.VednorStateName = $('#<%=ddlstate.ClientID%> option:selected').text();
                         objQuotation.VednorStateGstnno = $('#<%=txtgstnno.ClientID%>').val();
                         objQuotation.EntryDateFrom = $('#<%=txtentrydate.ClientID%>').val();
                         objQuotation.EntryDateTo = $('#<%=txtentrydateto.ClientID%>').val();
                         objQuotation.DeliveryStateID = $('#<%=ddlcentrestate.ClientID%>').val();
                         objQuotation.DeliveryStateName = $('#<%=ddlcentrestate.ClientID%> option:selected').text();
                         objQuotation.DeliveryCentreID ="";
                         objQuotation.DeliveryCentreName = "";
                         objQuotation.DeliveryLocationID = LocationID.toString();
                         objQuotation.DeliveryLocationName ="";
                         objQuotation.ItemCategoryID = $(this).closest("tr").find("#tditemtypeid").html();
                         objQuotation.ItemCategoryName = $(this).closest("tr").find("#tdItemCategory").html();
                         objQuotation.ItemID = $(this).closest("tr").find("#tdItemid").html();
                         objQuotation.ItemName = $(this).closest("tr").find("#tdItemName").html();
                         objQuotation.HSNCode = $(this).closest("tr").find("#tdhsncode").html();
                         objQuotation.ManufactureID = $(this).closest("tr").find("#tdManufactureID").html();
                         objQuotation.ManufactureName = $(this).closest("tr").find("#tdManufactureName").html();
                         objQuotation.MachineID = $(this).closest("tr").find("#tdMachineID").html();
                         objQuotation.MachineName = $(this).closest("tr").find("#tdMachineName").html();



                         objQuotation.Rate = $(this).closest("tr").find("#txtRate").val();
                         objQuotation.Qty = $(this).closest("tr").find("#txtQuantity").val();
                         objQuotation.DiscountPer = $(this).closest("tr").find("#txtDiscountper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountper").val());
                         objQuotation.IGSTPer = $(this).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtIGSTpe").val());
                         objQuotation.SGSTPer = $(this).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtCGSTper").val());
                         objQuotation.CGSTPer = $(this).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtSGSTper").val());

                         objQuotation.ConversionFactor = $(this).closest("tr").find("#tdPackSize").html();
                         objQuotation.PurchasedUnit = $(this).closest("tr").find("#tdMajorUnitName").html();
                         objQuotation.ConsumptionUnit = $(this).closest("tr").find("#tdMinorUnitName").html();

                         objQuotation.BuyPrice = $(this).closest("tr").find("#txtBuyPrice").val();
                         objQuotation.FreeQty = $(this).closest("tr").find("#txtFreeQty").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtFreeQty").val());

                         objQuotation.DiscountAmt = $(this).closest("tr").find("#txtDiscountAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtDiscountAmount").val());
                         objQuotation.GSTAmount = $(this).closest("tr").find("#txtTotalGSTAmount").val() == "" ? 0 : parseFloat($(this).closest("tr").find("#txtTotalGSTAmount").val());
                         objQuotation.FinalPrice = $(this).closest("tr").find("#txtNetAmt").val();

                         objQuotation.IsActive = "1";

                         dataIm.push(objQuotation);
                     }
                 });
                    

                 return dataIm;
             }


             function getquotationdataterm() {

                 var podetailterm = [];

                 $('#tblterms tr').each(function () {
                     if ($(this).attr("id") != "termsheader") {
                         var Podetailtc = new Object();
                       
                       

                         podetailterm.push($(this).find("#tdterm").html());

                     }
                 });

                 return podetailterm;
             }
    </script>

    <script type="text/javascript">

        function searchitem() {

           
           
            $('#tblitemlist tr').slice(1).remove();

            serverCall('VendorQuotation.aspx/SearchData', { quno: $('#<%=txtqrefnosearch.ClientID%>').val() ,fromdate:$('#<%=txtfromdate.ClientID%>').val() ,todate: $('#<%=txttodate.ClientID%>').val() ,Status: $('#<%=ddlstatus.ClientID%>').val() ,NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val() ,vendorid:$('#<%=ddlsuppliersearch.ClientID%>').val() ,itemid:$('#<%=ddlitemsearch.ClientID%>').val(),location:$('#<%=ddllocationsearch.ClientID%>').val() }, function (response) {


           
                         ItemData = jQuery.parseJSON(response);

                         if (ItemData.length == 0) {
                             toast("Error", "No Item Found");
                       

                         }
                         else {
                             for (var i = 0; i <= ItemData.length - 1; i++) {
                                 var $mydata = [];
                                 $mydata.push("<tr style='background-color:"); $mydata.push(ItemData[i].rowcolor); $mydata.push(";' id='"); $mydata.push(ItemData[i].Qutationno); $mydata.push("'>");
                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;display:none;" onclick="showdetailtoupdate(this)" /></td>');

                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail3" >');

                                 if (ItemData[i].ApprovalStatus == "0" && approvaltypechecker == "1") {
                                     $mydata.push('<img src="../../App_Images/Checked.png" style="cursor:pointer;height:30px;width:50px" onclick="checkme(this)" />');
                                 }
                                 $mydata.push('</td>');


                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail4" >');
                                 if (ItemData[i].ApprovalStatus == "1" && approvaltypeapproval == "1") {
                                     $mydata.push('<img src="../../App_Images/Approved.jpg" style="cursor:pointer;height:30px;width:50px" onclick="approveme(this)" />');
                                 }
                                 $mydata.push('</td>');

                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail5" ><img src="../../App_Images/print.GIF" style="cursor:pointer;" onclick="printdetail(this)" /></td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" id="tditemid" >'); $mydata.push(ItemData[i].Qutationno); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].EntryDateFrom); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].EntryDateTo); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].VendorName); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].Address); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].VednorStateGstnno); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].DeliveryStateName); $mydata.push('</td>');
                          
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(ItemData[i].DeliveryLocationName); $mydata.push('</td>');
                           
                           

                                 $mydata.push("</tr>");
                                 $mydata = $mydata.join("");
                                 $('#tblitemlist').append($mydata);
                                 

                             }
                      

                         }

                     
                 });
             }
               
        


             function checkme(ctrl) {

                 var id = $(ctrl).closest("tr").find('#tditemid').html();
                 serverCall('VendorQuotation.aspx/SetStatus', { itemId: id, Status: 1 }, function (response) {
                     ItemData = response;
                    
                     if (ItemData == "true") {

                         toast("Success","Quotation checked Sucessfully");
                         searchitem();
                     }
                     else {
                         toast("Error", ItemData);
                     }

                 });
                 

             }
             function approveme(ctrl) {
                 var id = $(ctrl).closest("tr").find('#tditemid').html();
                 serverCall('VendorQuotation.aspx/SetStatus', { itemId: id, Status: 2 }, function (response) {
                     ItemData = response;
                     toast("Success", "Quotation Approved Sucessfully");                  
                     searchitem();               
                 });
             }
             function showdetail(ctrl) {
                 var qid = $(ctrl).closest("tr").find('#tditemid').html();
                 openmypopup('ShowvendorQuotationDetail.aspx?QutationNo=' + qid);
             }
             function printdetail(ctrl) {
               //  window.open('VendorQutReport.aspx?QutationNo=' + $(ctrl).closest("tr").find('#tditemid').html());
                   window.open('VendorQuotationPDF.aspx?QutationNo=' + $(ctrl).closest("tr").find('#tditemid').html());
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
    </script>


    <script type="text/javascript">
        function showdetailtoupdate(ctrl) {
            clearForm();
            $('#btnsave').hide();
            $('#btnupdate').show();
            var qid = $(ctrl).closest("tr").find('#tditemid').html();

            serverCall('VendorQuotation.aspx/GetDataToUpdate', { qid: qid }, function (response) {


           
                    ItemData = jQuery.parseJSON(response);

                    $('#QuotationID').html(ItemData[0].Qutationno);
                    $('#<%=ddlsupplier.ClientID%>').val(ItemData[0].vendorid);
                         $('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');

                         $('#<%=txtquationrefno.ClientID%>').val(ItemData[0].Quotationrefno);
                         $('#<%=txtaddress.ClientID%>').val(ItemData[0].vendoraddress);
                         $('#<%=txtentrydate.ClientID%>').val(ItemData[0].entrydate);
                         setvendordata();
                         $('#<%=ddlstate.ClientID%>').val(ItemData[0].vendorstateid + "#" + ItemData[0].VednorStateGstnno);
                         $('#<%=txtgstnno.ClientID%>').val(ItemData[0].VednorStateGstnno);
                         $('#<%=ddlcentrestate.ClientID%>').val(ItemData[0].deliverystateid);
                         bindcentre();
                

                         var dropdown = $("#<%=ddlsupplier.ClientID%>");
                         dropdown.attr("disabled", true);
                         dropdown.trigger('chosen:updated');


                  


                         var dropdown2 = $("#<%=ddlstate.ClientID%>");
                    dropdown2.attr("disabled", true);

                    var dropdown3 = $("#<%=ddlcentrestate.ClientID%>");
                    dropdown3.attr("disabled", true);

                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $mydata = [];
                        var id = PanelData[0].ItemID + "_" + PanelData[0].ManufactureID;
                        var a = $('#tblQuotation tr').length - 1;
                        $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push( id); $mydata.push('>');

                        $mydata.push('<td  align="left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('<br/><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetailitem(this)" /></td>');
                        $mydata.push('<td align="left" id="tdItemCategory">'); $mydata.push(ItemData[i].ItemCategoryName); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdItemid1" style="font-weight:bold;">' ); $mydata.push(ItemData[i].ItemID); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdItemName">'); $mydata.push(ItemData[i].ItemName); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdhsncode">'); $mydata.push(ItemData[i].HSNCode); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdManufactureName">' ); $mydata.push(ItemData[i].ManufactureName); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdcatalogno">'); $mydata.push(ItemData[i].catalogno); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdMachineName">'); $mydata.push(ItemData[i].MachineName); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdMajorUnitName">'); $mydata.push(ItemData[i].PurchasedUnit); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdPackSize">'); $mydata.push(ItemData[i].ConversionFactor); $mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdMinorUnitName">'); $mydata.push(ItemData[i].PurchasedUnit); $mydata.push('</td>');

                        $mydata.push('<td align="left" id="tdQuantity"><input value="'); $mydata.push(precise_round(ItemData[i].Qty, 5) ); $mydata.push('" type="text"  style="width:60px" id="txtQuantity" onkeyup="CalBuyPrice(this);"/></td>');
                        $mydata.push('<td align="left" id="tdRate"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].Rate, 5) ); $mydata.push('"  style="width:60px" id="txtRate" onkeyup="CalBuyPrice(this);"/></td>');
                        $mydata.push('<td align="left" id="tdDiscountper"><input value="'); $mydata.push(precise_round(ItemData[i].DiscountPer, 5) ); $mydata.push('" type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);"/></td>');




                        $mydata.push('<td align="left" id="tdIGSTper"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].IGSTPer, 5)); $mydata.push('"  style="width:60px" id="txtIGSTpe" readonly="true" onkeyup="CalBuyPrice(this);"  /></td>');
                        $mydata.push('<td align="left" id="tdCGSTper"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].CGSTPer, 5)); $mydata.push('"  style="width:60px" id="txtCGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                        var totalgst = parseFloat(ItemData[i].IGSTPer) + parseFloat(ItemData[i].CGSTPer) + parseFloat(ItemData[i].SGSTPer);

                        $mydata.push('<td align="left" id="tdSGSTper"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].SGSTPer, 5)); $mydata.push('"  style="width:60px" id="txtSGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                        $mydata.push('<td align="left" id="tdTotalGST"><input type="text" value="'); $mydata.push(precise_round(totalgst,5)); $mydata.push('"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true"  /></td>');




                        $mydata.push('<td align="left" id="tdFreeQty"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].FreeQty, 5));$mydata.push('"  style="width:60px" id="txtFreeQty"/></td>');
                        $mydata.push('<td align="left" id="tdDiscountAmount"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].DiscountAmt, 5));$mydata.push('"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>');
                        $mydata.push('<td align="left" id="tdTotalGSTAmount"><input type="text"  value="'); $mydata.push(precise_round(ItemData[i].GSTAmount, 5) );$mydata.push('" style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>');
                        $mydata.push('<td align="left" id="tdBuyPrice"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].BuyPrice, 5));$mydata.push('"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>');
                        $mydata.push('<td align="left" id="tdNetAmt"><input type="text" value="'); $mydata.push(precise_round(ItemData[i].FinalPrice, 5) );$mydata.push('"  style="width:60px" id="txtNetAmt" readonly="true"/></td>');






                        $mydata.push('<td  id="tditemtypeid" style="display:none;">'); $mydata.push(ItemData[i].ItemCategoryID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdItemid" style="display:none;">'); $mydata.push(ItemData[i].ItemID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdManufactureID" style="display:none;">'); $mydata.push(ItemData[i].ManufactureID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdMachineID" style="display:none;">'); $mydata.push(ItemData[i].MachineID);$mydata.push('</td>');
                        $mydata.push('<td  id="tdMajorUnitId" style="display:none;"></td>');
                        $mydata.push('<td  id="tdMinorUnitId" style="display:none;"></td>');
                        $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');


                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#tblQuotation').append($mydata);
                       
                    }


                    var term = ItemData[0].term;
               
                    for (var c = 0; c <= term.split(',').length-1; c++) {
                    
                        var id = term.split(',')[c].replace(' ', '');
                        var $mydata = [];
                       
                        var a = $('#tblterms tr').length - 1;
                        $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=');$mydata.push(id);$mydata.push('>');
                        $mydata.push('<td  align="left" >');$mydata.push(parseFloat(a + 1));$mydata.push('</td>');
                        $mydata.push('<td align="left" id="tdterm">'); $mydata.push(term.split(',')[c]);$mydata.push('</td>');
                        $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>');
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#tblterms').append($mydata);
                       


                    }                    
                 });
        }


        function updateitem() {


            if (validation() == false) {
                return;
            }

            var quotationdata = getquotationdata();
            var quotationdataterm = getquotationdataterm();

            $("#Update").attr('disabled', true).val("Updating...");

            serverCall('VendorQuotation.aspx/UpdateVendorQuotation', { quotationdata: quotationdata, quotationdataterm: quotationdataterm }, function (response) {
                var save = response;
                if (save.split('#')[0] == "1") {

                    $('#btnupdate').attr('disabled', false).val("Update");
                    clearForm();
                    toast("Success", "Quotation No.: " + save.split('#')[1] + " Updated");
                    window.open('VendorQutReport.aspx?QutationNo=' + save.split('#')[1]);
                    searchitem();



                }
                else {
                    toast("Error", save.split('#')[1]);
                    $('#btnupdate').attr('disabled', false).val("Update");
                    // console.log(save);
                }
           
            });
        }

    </script>

    <script type="text/javascript">


        function showdetailitem(ctrl) {
            var itemid = $(ctrl).closest("tr").find('#tdItemid').html();
            openmypopup('ShowItemDetail.aspx?type=1&itemid=' + itemid);
        }


        function AddAllitem() {

            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                     toast("Error", "Please Select Supplier");
                     $('#<%=ddlsupplier.ClientID%>').focus();
                     return;
                 }
                 var length = $('#<%=ddlstate.ClientID%> > option').length;
                 if (length == 0) {
                     toast("Error", "No State Found For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return;
                 }
                 if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                     toast("Error", "Please Select State For Supplier");
                     $('#<%=ddlstate.ClientID%>').focus();
                     return false;
                 }


                 if ($('#<%=ddlcentrestate.ClientID%>').val() == "0") {
                     toast("Error", "Please Select Delivery  State");
                     $('#<%=ddlcentrestate.ClientID%>').focus();
                     return;
                 }



                 var location = $('#<%=lstlocation.ClientID%>').val();
                 if (location == "") {
                     toast("Error", "Please Select Delivery Location");
                     $('#<%=lstlocation.ClientID%>').focus();
                     return;
                 }


                 if ($('#<%=ddlmachineall.ClientID%>').val() == "0") {
                     toast("Error", "Please Select Machine");
                     $('#<%=ddlmachineall.ClientID%>').focus();
                     return;
                 }

            serverCall('VendorQuotation.aspx/getitemdetailtoaddall', { machine:$('#<%=ddlmachineall.ClientID%>').val() ,locationidfrom: jQuery('#lstlocation').val().toString() ,itemtype: $('#<%=ddlsuppliertype.ClientID%>').val()  }, function (response) {

               

           
                
                    PanelData = $.parseJSON(response);
                    if (PanelData.length == 0) {
                        toast("Error", "Data Not Found.!");
                      
                        return;
                    }
                    else {

                        for (var i = 0; i <= PanelData.length - 1; i++) {

                            var id = PanelData[i].Itemid;

                            if ($('table#tblQuotation').find('#' + id).length > 0) {
                                toast("Error", "Data Already Added");
                                
                                return;
                            }
                            var a = $('#tblQuotation tr').length - 1;
                            var $mydata = [];
                            $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="');$mydata.push(id);$mydata.push('">');

                            $mydata.push('<td  align="left" >');$mydata.push(parseFloat(a + 1));$mydata.push('<br/><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetailitem(this)" /></td>');
                            $mydata.push('<td align="left" id="tdItemCategory">');$mydata.push(PanelData[i].ItemCategory);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdItemid1" style="font-weight:bold;">');$mydata.push(PanelData[i].Itemid);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdItemName">');$mydata.push(PanelData[i].ItemName);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdhsncode">');$mydata.push(PanelData[i].hsncode);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdManufactureName">');$mydata.push(PanelData[i].ManufactureName);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdcatalogno">');$mydata.push( PanelData[i].catalogno);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdMachineName">');$mydata.push(PanelData[i].MachineName);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdMajorUnitName">');$mydata.push(PanelData[i].MajorUnitName);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdPackSize">');$mydata.push(PanelData[i].PackSize);$mydata.push('</td>');
                            $mydata.push('<td align="left" id="tdMinorUnitName">');$mydata.push(PanelData[i].MinorUnitName);$mydata.push('</td>');

                            $mydata.push('<td align="left" id="tdQuantity" style="display:none;"><input type="text" value="1" readonly="readonly"  style="width:60px" id="txtQuantity" onkeyup="CalBuyPrice(this);"/></td>');
                            $mydata.push('<td align="left" id="tdRate"><input type="text"  style="width:60px" id="txtRate" onkeyup="CalBuyPrice(this);"/></td>');
                            $mydata.push('<td align="left" id="tdDiscountper"><input type="text"  style="width:60px" id="txtDiscountper" onkeyup="CalBuyPrice(this);"/></td>');

                            //case 1 If Vendor State== Delivery State GST break In To CGST and SGST Apply
                            if ($('#<%=ddlstate.ClientID%>').val().split('#')[0] == $('#<%=ddlcentrestate.ClientID%>').val()) {
                                var cgst = PanelData[i].gstntax / 2;

                                $mydata.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                                $mydata.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" readonly="true" onkeyup="CalBuyPrice(this);" value="');$mydata.push(cgst);$mydata.push('"/></td>');
                                $mydata.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" readonly="true" onkeyup="CalBuyPrice(this);" value="');$mydata.push(cgst);$mydata.push('"/></td>');
                                $mydata.push('<td align="left" id="tdTotalGST"><input type="text"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true" value="');$mydata.push(PanelData[i].gstntax);$mydata.push('" /></td>');
                            }
                                //case 2 If Vendor State <> Delivery State Only IGST Apply
                            else {

                                $mydata.push('<td align="left" id="tdIGSTper"><input type="text"  style="width:60px" id="txtIGSTpe" readonly="true" onkeyup="CalBuyPrice(this);" value="');$mydata.push(PanelData[i].gstntax);$mydata.push('" /></td>');
                                $mydata.push('<td align="left" id="tdCGSTper"><input type="text"  style="width:60px" id="txtCGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                                $mydata.push('<td align="left" id="tdSGSTper"><input type="text"  style="width:60px" id="txtSGSTper" readonly="true" onkeyup="CalBuyPrice(this);"/></td>');
                                $mydata.push('<td align="left" id="tdTotalGST"><input type="text"  style="width:60px" id="txtTotalGST" readonly="true" readonly="true" value="');$mydata.push(PanelData[i].gstntax);$mydata.push('" /></td>');
                            }



                            $mydata.push('<td align="left" id="tdFreeQty" style="display:none;"><input type="text"  style="width:60px" id="txtFreeQty"/></td>');
                            $mydata.push('<td align="center" style="background-color:maroon;" id="tdchangetax"><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="edittax(this)"/></td>');
                            $mydata.push('<td align="left" id="tdDiscountAmount"><input type="text"  style="width:60px" id="txtDiscountAmount" readonly="true"/></td>');
                            $mydata.push('<td align="left" id="tdTotalGSTAmount"><input type="text"  style="width:60px" id="txtTotalGSTAmount" readonly="true"/></td>');
                            $mydata.push('<td align="left" id="tdBuyPrice" style="display:none;"><input type="text"  style="width:60px" id="txtBuyPrice" readonly="true" /></td>');
                            $mydata.push('<td align="left" id="tdNetAmt" style="display:none;"><input type="text"  style="width:60px" id="txtNetAmt" readonly="true"/></td>');






                            $mydata.push('<td  id="tditemtypeid" style="display:none;">');$mydata.push(PanelData[i].itemtypeid); $mydata.push('</td>');
                            $mydata.push('<td  id="tdItemid" style="display:none;">');$mydata.push(PanelData[i].Itemid); $mydata.push('</td>');
                            $mydata.push('<td  id="tdManufactureID" style="display:none;">');$mydata.push(PanelData[i].ManufactureID ); $mydata.push('</td>');
                            $mydata.push('<td  id="tdMachineID" style="display:none;">');$mydata.push(PanelData[i].MachineID); $mydata.push('</td>');
                            $mydata.push('<td  id="tdMajorUnitId" style="display:none;">');$mydata.push(PanelData[i].MajorUnitId); $mydata.push('</td>');
                            $mydata.push('<td  id="tdMinorUnitId" style="display:none;">');$mydata.push(PanelData[i].MinorUnitId); $mydata.push('</td>');
                            $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');


                            $mydata.push('</tr>');
                            $mydata = $mydata.join("");
                            $('#tblQuotation').append($mydata);
                            
                        }


                        var dropdown = $("#<%=ddlsupplier.ClientID%>");
                        dropdown.attr("disabled", true);
                        dropdown.trigger('chosen:updated');


                        var dropdown1 = $("#<%=lstCentre.ClientID%>");
                        dropdown1.attr("disabled", true);



                        var dropdown2 = $("#<%=ddlstate.ClientID%>");
                        dropdown2.attr("disabled", true);

                        var dropdown3 = $("#<%=ddlcentrestate.ClientID%>");
                        dropdown3.attr("disabled", true);



                        jQuery('#lstlocation').multipleSelect("disable");
                        jQuery('#lstCentreType').multipleSelect("disable");
                        jQuery('#lstCentre').multipleSelect("disable");

                      

                    }

                
            });
        }
                
    </script>

    <script type="text/javascript">

        function edittax(ctrl) {

            var IGSTPer = $(ctrl).closest("tr").find("#txtIGSTpe").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtIGSTpe").val());
            var CGSTPer = $(ctrl).closest("tr").find("#txtCGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtCGSTper").val());
            var SGSTPer = $(ctrl).closest("tr").find("#txtSGSTper").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtSGSTper").val());

            var oldtax = IGSTPer == 0 ? (CGSTPer + SGSTPer) : IGSTPer;
            $('#<%=txtoldtax.ClientID%>').val(oldtax);

                 $('#<%=txtolditemname.ClientID%>').val($(ctrl).closest("tr").find("#tdItemName").text());
                 $('#<%=txtnewtax.ClientID%>').val('');

                 $('#<%=txtnewitemid.ClientID%>').val($(ctrl).closest("tr").attr("id"));

                 $find("<%=modelpopup1.ClientID%>").show();
             }

             function changetax() {
                 if ($('#<%=txtnewtax.ClientID%>').val() == "0" || $('#<%=txtnewtax.ClientID%>').val() == "") {
                     toast("Error", "Please Enter Tax ");
                     $('#<%=txtnewtax.ClientID%>').focus();

            }

            if ($('#<%=txtnewtax.ClientID%>').val() == $('#<%=txtoldtax.ClientID%>').val()) {
                     toast("Error", "Old and New Tax is Same ");
                     $('#<%=txtnewtax.ClientID%>').focus();

            }

            var id = $('#<%=txtnewitemid.ClientID%>').val();

                 if ($('#<%=ddlstate.ClientID%>').val().split('#')[0] == $('#<%=ddlcentrestate.ClientID%>').val()) {
                     var cgst = $('#<%=txtnewtax.ClientID%>').val() / 2;


                $('table#tblQuotation').find('#' + id).find("#txtIGSTpe").val('');
                $('table#tblQuotation').find('#' + id).find("#txtCGSTper").val(cgst);
                $('table#tblQuotation').find('#' + id).find("#txtSGSTper").val(cgst);
                $('table#tblQuotation').find('#' + id).find("#txtTotalGST").val($('#<%=txtnewtax.ClientID%>').val());


            }
            else {
                $('table#tblQuotation').find('#' + id).find("#txtIGSTpe").val($('#<%=txtnewtax.ClientID%>').val());
                $('table#tblQuotation').find('#' + id).find("#txtCGSTper").val('');
                $('table#tblQuotation').find('#' + id).find("#txtSGSTper").val('');
                $('table#tblQuotation').find('#' + id).find("#txtTotalGST").val($('#<%=txtnewtax.ClientID%>').val());
            }


            var rate = $('table#tblQuotation').find('#' + id).find("#txtRate").val() == "" ? 0 : parseFloat($('table#tblQuotation').find('#' + id).find("#txtRate").val());
            if (rate > 0) {
                CalBuyPrice($('table#tblQuotation').find('#' + id).find("#txtRate"));
            }
            $find("<%=modelpopup1.ClientID%>").hide();


        }



    </script>
</asp:Content>

