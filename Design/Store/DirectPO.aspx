<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectPO.aspx.cs" Inherits="Design_Store_DirectPO" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
     
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    
   


    <div id="Pbody_box_inventory" style="text-align: center">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        <Services>
            <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
            <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
        </Services>
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Direct Purchase Order</b>
            <span id="spnError"></span>
            <asp:Label ID="lblError" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:Label ID="lblPurchaseOrderID" runat="server" CssClass="ItDoseLblError" Style="display: none"></asp:Label>
            <asp:Label ID="lblPurchaseOrderNo" runat="server" CssClass="ItDoseLblError" Style="display: none"></asp:Label>
        </div>

        <div id="PatientDetails" class="POuter_Box_Inventory">
            
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Category:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlcategorytype" CssClass="requiredField" ClientIDMode="Static" runat="server" TabIndex="1">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Supplier Name:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlsupplier" CssClass="requiredField" runat="server" class="ddlsupplier chosen-select chosen-container" onchange="setvendordata()">
                            </asp:DropDownList>
                            <span id="QuotationID" style="display: none;"></span>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Address:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox ID="txtAddress" runat="server" ReadOnly="true"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Supplier State:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:DropDownList ID="ddlState" runat="server" onchange="setgstndata()"></asp:DropDownList>
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">GSTN No:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtGSTNo" runat="server" ReadOnly="true">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Delivery State:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlCentreState" runat="server" onchange="bindDCentre()" />
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">D. Centre:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlCentre" runat="server" class="ddlCentre <%--chosen-select chosen-container--%>" ToolTip="Delivery Centre" onchange="bindLocation()"></asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">D. Location:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7 ">
                            <asp:DropDownList ID="ddlLocation" runat="server" class="ddlLocation chosen-select chosen-container" ToolTip="Delivery Location"></asp:DropDownList>
                        </div>

                    </div>

               
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Detail
            </div>
             <div class="row">
                   <div class="col-md-3 " >
			                                    <label class="pull-left">Search Option</label>
                                      <b class="pull-right">:</b>
                                 </div>
                   <div class="col-md-8 " >                               
                                     <asp:RadioButtonList ID="rdosearchitem" runat="server" RepeatDirection="Horizontal" Style="font-weight: 700">
                                         <asp:ListItem Text="By First Name" Value="0">
                                    
                                         </asp:ListItem>
                                         <asp:ListItem Text="In Between" Value="1" Selected="True">
                                    
                                         </asp:ListItem>
                                         <asp:ListItem Text="Item Code" Value="2">
                                    
                                         </asp:ListItem>
                                     </asp:RadioButtonList>                                      
                                </div>  
                 </div>
            
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Item:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <input id="txtItem" type="text" style="text-transform: uppercase;" />
                           <%--  <asp:TextBox ID="txtItem" TabIndex="4"   runat="server" Style="text-transform: capitalize"
                                    ></asp:TextBox>--%>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Item:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:Label ID="lblItemName" runat="server"></asp:Label>
                            <asp:Label ID="lblItemGroupID" runat="server" Style="display: none;"></asp:Label>
                            <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">PO Type:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7 ">
                            <asp:DropDownList ID="ddlPOType" runat="server">
                                <asp:ListItem Text="Normal" Value="Normal" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Immediate" Value="Immediate"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Manufacturer:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlManufacturer" runat="server" onchange="bindTempData('Machine');">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Machine:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlMachine" runat="server" onchange="bindTempData('PackSize');"></asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">PO Size:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6 ">
                            <asp:DropDownList ID="ddlPackSize" runat="server" onchange="setDataAfterPackSize();"></asp:DropDownList>

                        </div>
                        <div class="col-md-1 ">
                            <input type="button" class="searchbutton" value="Add" onclick="AddItem()" id="btnAddItem" />
                        </div>
                    </div>
               
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Added Item
            </div>
        
                    <div class="row">
                        <div class="col-md-24 ">
                            <table id="tblPurchaseOrder" style="border-collapse: collapse;width:100%">
                                <tr id="trPOHeader">
                                    <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                    <td class="GridViewHeaderStyle">Category</td>
                                    <td class="GridViewHeaderStyle">Item Category</td>
                                    <td class="GridViewHeaderStyle">ItemID</td>
                                    <td class="GridViewHeaderStyle">Item Name</td>
                                    <td class="GridViewHeaderStyle">HSN Code</td>
                                    <td class="GridViewHeaderStyle">Manufacturer</td>
                                    <td class="GridViewHeaderStyle">Catalog No.</td>
                                    <td class="GridViewHeaderStyle">Machine</td>
                                    <td class="GridViewHeaderStyle">Purchased Unit</td>
                                    <td class="GridViewHeaderStyle">Pack Size</td>

                                    <td class="GridViewHeaderStyle">Rate</td>
                                    <td class="GridViewHeaderStyle">Discount %</td>
                                    <td class="GridViewHeaderStyle">IGST %</td>
                                    <td class="GridViewHeaderStyle">CGST %</td>
                                    <td class="GridViewHeaderStyle">SGST %</td>
                                    <td class="GridViewHeaderStyle">Qty.</td>
                                    <td class="GridViewHeaderStyle">Free Qty.</td>
                                    <td class="GridViewHeaderStyle">Net Amt.</td>
                                    <td class="GridViewHeaderStyle" style="display: none;">BuyPrice</td>
                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                </tr>
                            </table>
                        </div>
                    </div>
               
        </div>
        <div id="Div3" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Terms & Conditions
            </div>
          
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Payment Term:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:DropDownList ID="ddlpaymentterm" runat="server" Width="400px" onchange="setpaymentterm()">
                                <asp:ListItem Value="1">After 30 Days from the date of delivery at place</asp:ListItem>
                                <asp:ListItem Value="3">50% Advance 50% Post delivery</asp:ListItem>
                                <asp:ListItem Value="4">100% Advance Payment</asp:ListItem>
                                <asp:ListItem Value="2">Other</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox ID="txtpaymentterm" runat="server" placeholder="Enter Payment Term" Style="display: none;" MaxLength="100" />
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Delivery Term:   </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-2 ">
                            <asp:DropDownList ID="ddldeliveryterm" runat="server" Width="200px" onchange="setdeliveryterm()">
<asp:ListItem Value="3">Delivered at Door Step</asp:ListItem> 
<asp:ListItem Value="4">Ex-Works</asp:ListItem>                                
<asp:ListItem Value="2">Other</asp:ListItem>
                                
                                <%-- <asp:ListItem>Immediate</asp:ListItem>--%>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-5 ">
                            <asp:TextBox ID="txtdeliveryterm" runat="server" placeholder="Enter Delivery Term" Style="display: none;" MaxLength="100" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Warranty:   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox ID="txtWarranty" runat="server" MaxLength="200" />
                        </div>
                        <div class="col-md-3 ">
                        </div>
                        <div class="col-md-4 ">
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">NFA No:   </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox ID="txtnfano" runat="server" MaxLength="50" />
                        </div>
                        <div class="col-md-4 ">
                            <span style="background-color: red; color: white; cursor: pointer;" id="isedited"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Term &amp; Condition:&nbsp;   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <asp:TextBox ID="txttermandcondition" runat="server" MaxLength="200" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24 ">
                            <table style="width: 100%; border-collapse: collapse; display: none;">
                                <tr>
                                    <td>Terms :&nbsp;</td>
                                    <td>
                                        <asp:TextBox ID="txtPOTerm" runat="server" Width="340px" MaxLength="100" />
                                    </td>
                                    <td>
                                        <input type="button" value="Add Terms" onclick="AddTermConditions()" class="searchbutton" id="btnTermConditions" /></td>
                                    <td colspan="5">
                                        <div style="width: 75%; max-height: 70px; overflow: auto;">
                                            <table id="tblPOTerms" style="border-collapse: collapse">
                                                <tr id="POTermHeader">
                                                    <td class="GridViewHeaderStyle" style="width: 460px">Terms</td>
                                                    <td class="GridViewHeaderStyle" style="width: 30px;">#</td>
                                                    <td class="GridViewHeaderStyle" style="width: 30px; display: none"></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24 ">
                            <input type="button" value="Save" class="savebutton" onclick="savePurchaseOrder();" id="btnSave"  />
                            <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" id="btnReset" />
                            <input type="button" id="btnview" value="View" style="display: none; cursor: pointer;" class="searchbutton" onclick="ViewMe();" />
                            <input type="button" id="btnCheck" value="Check" style="display: none; cursor: pointer;" class="savebutton" onclick="MakeAction('Check');" />
                            <input type="button" id="btnApproval" value="Approval" style="display: none; cursor: pointer;" class="savebutton" onclick="MakeAction('Approval');" />
                        </div>
                    </div>
                </div>
            
    </div>

    <%-- AddTermConditions--%>
    <script type="text/javascript">
        function openmypopup(href) {
            var width = '900px';
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
        function ViewMe() {

            openmypopup("PoView.aspx?POID=" + jQuery("#lblPurchaseOrderID").text());

        }

        jQuery(function () {
            setdeliveryterm();
        });
        function setpaymentterm() {
            if ($('#<%=ddlpaymentterm.ClientID%> option:selected').text() == "Other") {
                $('#<%=txtpaymentterm.ClientID%>').show();
            }
            else {
                $('#<%=txtpaymentterm.ClientID%>').hide();
            }
        }

        function setdeliveryterm() {
            if ($('#<%=ddldeliveryterm.ClientID%> option:selected').text() == "Other") {
                $('#<%=txtdeliveryterm.ClientID%>').show();
            }
            else {
                $('#<%=txtdeliveryterm.ClientID%>').hide();
            }
        }
        function AddTermConditions() {
            if (jQuery.trim(jQuery('#txtPOTerm').val()) == "") {
                toast("Error", "Please Enter Terms & Conditions..!", "");
                jQuery('#txtPOTerm').focus();
                return;
            }
            var id = $('#txtPOTerm').val().replace(' ', '');
            if ($('table#tblPOTerms').find('#' + id).length > 0) {
                toast("Error", "Term Already Added..!", "");
                return;
            }
            jQuery("#btnTermConditions").attr('disabled', 'disabled').val('Submitting...');
            var a = jQuery('#tblPOTerms tr').length - 1;

            var $mydata = [];
            $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push("'>");

            $mydata.push('<td align="left" id="tdPOTerm">'); $mydata.push($('#txtPOTerm').val()); $mydata.push('</td>');
            $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletePOTrem(this)" title="click To Remove Terms & Conditions"/></td>');
            $mydata.push('<td style="width: 30px;display:none" id="tdPOTermConditionID">0</td>');
            $mydata.push('</tr>');

            $mydata = $mydata.join("");
            $('#tblPOTerms').append($mydata);

            jQuery('#txtPOTerm').val('');
            jQuery("#btnTermConditions").removeAttr('disabled').val('Add Terms');
            jQuery("#tblPOTerms").tableHeadFixer({
            });
        }
        function deletePOTrem(rowID) {
            var table = document.getElementById('tblPOTerms');
            table.deleteRow(rowID.parentNode.parentNode.rowIndex);

        }
    </script>

    <%-- Supplier Search--%>
    <script type="text/javascript">
        var ActionType = "";
        function onSucessSearchPO(result) {
            var SearchPOData = $.parseJSON(result);
            jQuery("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback").hide();
            if (SearchPOData[0].ActionType == "Maker") {
                ActionType = "Checker";
                jQuery('#btnCheck,#btnSave').show();
                jQuery('#btnview').show();

                jQuery('#btnReset').hide();
            }
            else if (SearchPOData[0].ActionType == "Checker") {
                ActionType = "Approval";
                jQuery('#btnCheck,#btnReset').hide();
                jQuery('#btnApproval,#btnSave').show();
                jQuery('#btnview').show();
            }
            else {
                jQuery('#txtItem').attr('disabled', 'disabled');
                jQuery('#btnCheck,#btnReset,#btnApproval,#btnSave,#btnAddItem').hide();
            }
            jQuery('#<%=ddlsupplier.ClientID%>').val(SearchPOData[0].VendorID).attr('disabled', 'disabled');
            jQuery('#<%=ddlcategorytype.ClientID%>').val(SearchPOData[0].categorytypeID).attr('disabled', 'disabled');
            jQuery('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');

            $('#<%=txtWarranty.ClientID%>').val(SearchPOData[0].Warranty);
            $('#<%=txtnfano.ClientID%>').val(SearchPOData[0].NFANo);
            $('#<%=txttermandcondition.ClientID%>').val(SearchPOData[0].TermandCondition);

            jQuery('#isedited').html(SearchPOData[0].re);
            $("#isedited").on("click", function () { showerrormsg(SearchPOData[0].remsg); });

            jQuery('#lblPurchaseOrderID').text(SearchPOData[0].PurchaseOrderID);
            jQuery('#lblPurchaseOrderNo').text(SearchPOData[0].PurchaseOrderNo);
            jQuery('#txtAddress').val(SearchPOData[0].VendorAddress).attr('disabled', 'disabled');
            jQuery('#txtGSTNo').val(SearchPOData[0].VednorStateGstnno).attr('disabled', 'disabled');
            jQuery('#ddlState').val(SearchPOData[0].VendorStateId);


            var _temp = [];
            _temp.push(serverCall('DirectPO.aspx/bindPODLocation', { LocationID: SearchPOData[0].DeliveryLocationID }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var SearchPOLocation = $.parseJSON(response);
                    jQuery("#ddlLocation").append($("<option></option>").val(SearchPOLocation[0].LocationID).html(SearchPOLocation[0].Location));
                    jQuery("#ddlLocation").trigger('chosen:updated');
                    jQuery("#ddlCentre").append($("<option></option>").val(SearchPOLocation[0].centreid).html(SearchPOLocation[0].centre));
                    jQuery("#ddlCentre").trigger('chosen:updated');
                    jQuery("#ddlCentreState").val(SearchPOLocation[0].StateID);
                    jQuery("#ddlCentreState,#ddlLocation,#ddlCentre").attr('disabled', 'disabled');
                })
            }));

            _temp.push(serverCall('DirectPO.aspx/bindPOTermCondtion', { PurchaseOrderID: SearchPOData[0].PurchaseOrderID }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var POTermsData = jQuery.parseJSON(response);
                    $('#ddlpaymentterm').val(POTermsData[0].TermConditionID);
                    if (POTermsData[0].TermConditionID == "2") {

                        $('#txtpaymentterm').val(POTermsData[0].TermCondition);
                        $('#txtpaymentterm').show();
                    }
                    $('#ddldeliveryterm').val(POTermsData[0].deliverytermid);
                    if (POTermsData[0].deliverytermid == "2") {
                        $('#txtdeliveryterm').val(POTermsData[0].deliveryterm);
                        $('#txtdeliveryterm').show();
                    }
                })
            }));


            setVendorData(SearchPOData[0].VendorID, "".concat(1, '#', SearchPOData[0].VendorStateId, '#', SearchPOData[0].VednorStateGstnno));

            for (var i = 0; i < SearchPOData.length; i++) {
                var a = jQuery('#tblPurchaseOrder tr').length - 1;

                var $mydata = [];

                $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(SearchPOData[i].Itemid); $mydata.push('>');

                $mydata.push('<td  style="text-align:left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdCategory">'); $mydata.push(SearchPOData[i].categorytypename); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdItemCategory">'); $mydata.push(SearchPOData[i].ItemCategory); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left;font-weight:bold;" id="tdItemID1">'); $mydata.push(SearchPOData[i].Itemid); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdItemName">'); $mydata.push(SearchPOData[i].ItemName); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdhsnCode">'); $mydata.push(SearchPOData[i].hsncode); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdManufactureName">'); $mydata.push(SearchPOData[i].ManufactureName); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdcatalogNo">'); $mydata.push(SearchPOData[i].catalogno); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdMachineName">'); $mydata.push(SearchPOData[i].MachineName); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdMajorUnitName">'); $mydata.push(SearchPOData[i].MajorUnitName); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdPackSize">'); $mydata.push(SearchPOData[i].PackSize); $mydata.push('</td>');
                $mydata.push('<td style="text-align:right" id="tdRate">'); $mydata.push(SearchPOData[i].Rate); $mydata.push('</td>');
                $mydata.push('<td style="text-align:right" id="tdDiscountPer">'); $mydata.push(SearchPOData[i].DiscountPer); $mydata.push('</td>');
                $mydata.push('<td style="text-align:right;" id="tdIGSTper">'); $mydata.push(SearchPOData[i].IGSTPer); $mydata.push(' </td>');
                $mydata.push('<td style="text-align:right;" id="tdCGSTper">'); $mydata.push(SearchPOData[i].CGSTPer); $mydata.push(' </td>');
                $mydata.push('<td style="text-align:right;" id="tdSGSTper">'); $mydata.push(SearchPOData[i].SGSTPer); $mydata.push('</td>');
                $mydata.push('<td style="text-align:left" id="tdQuantity" ><input type="text" value='); $mydata.push(SearchPOData[i].OrderedQty); $mydata.push('  style="width:60px" onkeypress="return checkForSecondDecimal(this,event);" id="txtQuantity" onkeyup="chkApproveQty(this);"/></td>');
                $mydata.push('<td style="text-align:left" id="tdFreeQty" ><input type="text" value='); $mydata.push(SearchPOData[i].FreeQty); $mydata.push(' style="width:60px" id="txtFreeQty" onkeypress="return checkForSecondDecimal(this,event);"/></td>');
                $mydata.push('<td style="text-align:left" id="tdNetAmt" ><span id="spnNetAmt" style="text-align: right;">'); $mydata.push(SearchPOData[i].NetAmount); $mydata.push(' </td>');
                $mydata.push('<td  id="tdBuyPrice" style="display:none;text-align:left"> '); $mydata.push(SearchPOData[i].UnitPrice); $mydata.push('</td>');
                $mydata.push('<td  id="tdItemTypeID" style="display:none;">'); $mydata.push(SearchPOData[i].ItemTypeID); $mydata.push('</td>');
                $mydata.push('<td  id="tdItemID" style="display:none;">'); $mydata.push(SearchPOData[i].Itemid); $mydata.push('</td>');
                $mydata.push('<td  id="tdManufactureID" style="display:none;">'); $mydata.push(SearchPOData[i].ManufactureID); $mydata.push('</td>');
                $mydata.push('<td  id="tdMachineID" style="display:none;">'); $mydata.push(SearchPOData[i].MachineID); $mydata.push('</td>');
                $mydata.push('<td  id="tdMajorUnitId" style="display:none;">'); $mydata.push(SearchPOData[i].MajorUnitId); $mydata.push('</td>');
                $mydata.push('<td  id="tdVendorID" style="display:none;">'); $mydata.push(SearchPOData[i].VendorID); $mydata.push('</td>');
                $mydata.push('<td  id="tdVendorAddress" style="display:none;">'); $mydata.push(SearchPOData[i].VendorAddress); $mydata.push('</td>');
                $mydata.push('<td  id="tdSupplierName" style="display:none;">'); $mydata.push(SearchPOData[i].VendorName); $mydata.push('</td>');
                $mydata.push('<td  id="tdIsLoginRequired" style="display:none;">'); $mydata.push(SearchPOData[i].IsLoginRequired); $mydata.push('</td>');
                $mydata.push('<td  id="tdVendorStateId" style="display:none;">'); $mydata.push(SearchPOData[i].VendorStateId); $mydata.push('</td>');
                $mydata.push('<td  id="tdVednorStateGstnno" style="display:none;">'); $mydata.push(SearchPOData[i].VednorStateGstnno); $mydata.push('</td>');
                $mydata.push('<td  id="tdDiscountAmt" style="display:none;">'); $mydata.push(SearchPOData[i].DiscountAmt); $mydata.push('</td>');
                $mydata.push('<td  id="tdDeliveryLocationID" style="display:none;">'); $mydata.push(SearchPOData[i].DeliveryLocationID); $mydata.push('</td>');
                $mydata.push('<td  id="tdOrderedQty" style="display:none;">'); $mydata.push(SearchPOData[i].OrderedQty); $mydata.push('</td>');
                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');
                $mydata.push('</tr>');

                $mydata = $mydata.join("");
                $('#tblPurchaseOrder').append($mydata);

            }
            jQuery("#tblPurchaseOrder").tableHeadFixer({
            });
        }
        function onFailureSearchPO(result) {

        }

        function chkApproveQty(rowID) {
            var Quantity = jQuery(rowID).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat(jQuery(rowID).closest("tr").find("#txtQuantity").val());
            if (parseFloat(jQuery(rowID).closest("tr").find("#tdOrderedQty").text()) < parseFloat(Quantity)) {
                var msg = "";
                if (ActionType == "Check")
                    msg = ActionType + ' Quantity can not be greater than  Order Quantity...!';
                else
                    msg = ActionType + ' Quantity can not be greater than  Check Quantity...!';
                showerrormsg(msg);
                jQuery(rowID).closest("tr").find("#txtQuantity").val(jQuery(rowID).closest("tr").find("#tdOrderedQty").text())
                Quantity = jQuery(rowID).closest("tr").find("#txtQuantity").val();
            }

            var NetAmount = parseFloat(jQuery(rowID).closest("tr").find("#tdBuyPrice").text()) * parseFloat(Quantity);
            jQuery(rowID).closest("tr").find("#spnNetAmt").text(precise_round(NetAmount, 5));
        }

        jQuery(function () {

            if ('<%=Request.QueryString["POID"]%>' != "") {
                PageMethods.setPOData('<%=Request.QueryString["POID"]%>', onSucessSearchPO, onFailureSearchPO);
                $('#btnSave').hide();
            }
            else {
            }


        });

    </script>
    <script type="text/javascript">
        function clearForm() {
            jQuery('#QuotationID').html('');
            jQuery('#btnSave').hide();
            $('#<%=txtdeliveryterm.ClientID%>').val('');

            jQuery("#ddlCentre option").remove();
            jQuery("#ddlCentre").attr("disabled", false);
            jQuery("#ddlCentre").trigger('chosen:updated');
            $('#<%=ddlcategorytype.ClientID%>').prop("disabled", false);
            $('#<%=ddlcategorytype.ClientID%>').prop('selectedIndex', 0);
            jQuery("#ddlLocation option").remove();
            jQuery("#ddlLocation").attr("disabled", false);
            jQuery("#ddlLocation").trigger('chosen:updated');

            jQuery("#ddlState option").remove();
            jQuery('#ddlCentreState').prop('selectedIndex', 0).removeAttr("disabled");
            jQuery('#txtAddress,#txtGSTNo').val('');
            jQuery('#tblPurchaseOrder tr').slice(1).remove();
            jQuery('#tblPOTerms tr').slice(1).remove();
            jQuery('#<%=ddlsupplier.ClientID%>').prop('selectedIndex', 0).removeAttr("disabled");
            jQuery('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');

            $('#<%=txtWarranty.ClientID%>').val('');
            $('#<%=txtnfano.ClientID%>').val('');
            $('#<%=txttermandcondition.ClientID%>').val('');

        }
        function savePurchaseOrder() {



            var resultPurchaseOrder = POMaster();



            if (resultPurchaseOrder.chkData.length > 0) {
                jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + resultPurchaseOrder.chkData);
                jQuery.each(resultPurchaseOrder.chkData, function (index, value) {
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').find('#txtQuantity').focus();
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').css("background-color", "#FF0000");
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').attr('title', 'Please Enter Valid Qty.');
                });
            }

            if (resultPurchaseOrder.dataPOMaster.length == 0) {
                toast("Error", "Please Select Item", "");
                return;
            }
            jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            $modelBlockUI();


            // var resultPOTermCondition = getPOTermCondition();

            var term = "";
            if ($('#<%=ddlpaymentterm.ClientID%> option:selected').text() == "Other") {
                term = $('#<%=txtpaymentterm.ClientID%>').val();
            }
            else {
                term = $('#<%=ddlpaymentterm.ClientID%> option:selected').text();
            }

            var termID = $('#<%=ddlpaymentterm.ClientID%>').val();


            if (term == "") {
                $modelUnBlockUI();
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');

                toast("Error", "Please Enter or Select Payment  Term", "");
                return;
            }
            var deliveryterm = "";
            if ($('#<%=ddldeliveryterm.ClientID%> option:selected').text() == "Other") {
                deliveryterm = $('#<%=txtdeliveryterm.ClientID%>').val();
            }
            else {
                deliveryterm = $('#<%=ddldeliveryterm.ClientID%> option:selected').text();
            }
            var deliverytermID = $('#<%=ddldeliveryterm.ClientID%>').val();

            if (deliveryterm == "") {
                $modelUnBlockUI();
                jQuery("#btnSave").removeAttr('disabled').val('Make PO');
                toast("Error", "Please Enter or Select Delivery  Term", "");
                return;
            }
            serverCall('DirectPO.aspx/savePurchaseOrder', { POMaster: resultPurchaseOrder.dataPOMaster, term: term, deliveryterm: deliveryterm, termID: termID, deliverytermID: deliverytermID }, function (response) {
                var result = response;
                if (result == "1") {
                    toast("Success", "Record Saved Successfully", "");
                    if (jQuery("#lblPurchaseOrderNo").text() == "") {
                        clearForm();
                    }
                    else {

                    }
                }
                else if (result == "2" || result == "0") {
                    toast("Error", "Error....", "");
                }
                else {
                    var POReturnData = jQuery.parseJSON(result);

                    if (POReturnData.hasOwnProperty("QtyValidation")) {
                        jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + POReturnData.QtyValidation);
                        for (var i in POReturnData.QtyValidation) {
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().find('#txtQuantity').focus();
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().css("background-color", "#FF0000");
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().attr('title', 'Please Enter Valid Qty.');
                        }
                    }
                    else {

                    }
                }
                jQuery("#btnSave").removeAttr('disabled').val('Save');
                $modelUnBlockUI();
            });


            //serverCall('StoreItemMaster.aspx/savePurchaseOrder', {}, function (response) {
              //  $modelUnBlockUI();
            //});
        }
        function POMaster() {
            var dataPOMaster = new Array();
            var objPOMaster = new Object();
            var chkData = [];
            jQuery("#tblPurchaseOrder tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");

                if (id != "trPOHeader") {

                    var MainQty = $rowid.find("#txtQuantity").val() == "" ? 0 : parseFloat($rowid.find("#txtQuantity").val());
                    //var ItemData = [];
                    //if (jQuery.trim($rowid.find("#txtQuantity").val()) == "") {
                    //    $rowid.find("#txtQuantity").focus();
                    //    ItemData[0] = jQuery.trim(jQuery(this).find('#tdItemID').text());
                    //    chkData.push(ItemData);
                    //    return "";
                    //}
                    if (parseFloat(MainQty) > 0) {
                        PODetail($rowid, 0, objPOMaster);
                        dataPOMaster.push(objPOMaster);
                        objPOMaster = new Object();
                    }

                    var FreeQty = $rowid.find("#txtFreeQty").val() == "" ? 0 : parseFloat($rowid.find("#txtFreeQty").val());

                    if (parseFloat(FreeQty) > 0) {
                        PODetail($rowid, 1, objPOMaster);
                        dataPOMaster.push(objPOMaster);
                        objPOMaster = new Object();
                    }
                }
            });
            return {
                chkData: chkData,
                dataPOMaster: dataPOMaster
            };
        }
        function PODetail($rowid, IsFree, objPOMaster) {

            objPOMaster.PurchaseOrderNo = jQuery("#lblPurchaseOrderNo").text();
            if (jQuery("#lblPurchaseOrderID").text() != "")
                objPOMaster.PurchaseOrderID = jQuery("#lblPurchaseOrderID").text();
            else
                objPOMaster.PurchaseOrderID = 0;
            objPOMaster.Subject = "";
            objPOMaster.VendorID = jQuery.trim($rowid.find("#tdVendorID").text());//
            objPOMaster.VendorName = jQuery.trim($rowid.find("#tdSupplierName").text());//
            objPOMaster.LocationID = jQuery.trim($rowid.find("#tdDeliveryLocationID").text());//
            objPOMaster.IndentNo = "";
            objPOMaster.VendorStateId = jQuery.trim($rowid.find("#tdVendorStateId").text());//
            objPOMaster.VendorGSTIN = jQuery.trim($rowid.find("#tdVednorStateGstnno").text());//
            objPOMaster.VendorAddress = jQuery.trim($rowid.find("#tdVendorAddress").text());//
            objPOMaster.VendorLogin = jQuery.trim($rowid.find("#tdIsLoginRequired").text());//

            objPOMaster.ItemID = jQuery.trim($rowid.find("#tdItemID").text());//
            objPOMaster.ManufactureID = jQuery.trim($rowid.find("#tdManufactureID").text());//
            objPOMaster.ManufactureName = jQuery.trim($rowid.find("#tdManufactureName").text());//
            objPOMaster.CatalogNo = jQuery.trim($rowid.find("#tdcatalogNo").text());//
            objPOMaster.MachineID = jQuery.trim($rowid.find("#tdMachineID").text());//
            objPOMaster.MachineName = jQuery.trim($rowid.find("#tdMachineName").text());//
            objPOMaster.MajorUnitId = jQuery.trim($rowid.find("#tdMajorUnitId").text());//
            objPOMaster.MajorUnitName = jQuery.trim($rowid.find("#tdMajorUnitName").text());//
            objPOMaster.PackSize = jQuery.trim($rowid.find("#tdPackSize").text());//
            objPOMaster.ItemName = jQuery.trim($rowid.find("#tdItemName").text());//

            if (IsFree == 0) {
                objPOMaster.OrderedQty = jQuery.trim($rowid.find("#txtQuantity").val());//      
                objPOMaster.TaxPerCGST = jQuery.trim($rowid.find("#tdCGSTper").text());//
                objPOMaster.TaxPerIGST = jQuery.trim($rowid.find("#tdIGSTper").text());//
                objPOMaster.TaxPerSGST = jQuery.trim($rowid.find("#tdSGSTper").text());//
                objPOMaster.DiscountAmount = jQuery.trim($rowid.find("#tdDiscountAmt").text());//
                objPOMaster.DiscountPercentage = jQuery.trim($rowid.find("#tdDiscountPer").text());//
            }
            else {

                objPOMaster.OrderedQty = jQuery.trim($rowid.find("#txtFreeQty").val());//
                objPOMaster.TaxPerCGST = jQuery.trim($rowid.find("#tdCGSTper").text());//
                objPOMaster.TaxPerIGST = jQuery.trim($rowid.find("#tdIGSTper").text());//
                objPOMaster.TaxPerSGST = jQuery.trim($rowid.find("#tdSGSTper").text());//
                objPOMaster.DiscountAmount = 0;//
                objPOMaster.DiscountPercentage = jQuery.trim($rowid.find("#tdDiscountPer").text());//
            }
            objPOMaster.Rate = jQuery.trim($rowid.find("#tdRate").text());//
            objPOMaster.UnitPrice = jQuery.trim($rowid.find("#tdBuyPrice").text());//
            objPOMaster.POType = jQuery("#ddlPOType").val();

            objPOMaster.Warranty = $('#<%=txtWarranty.ClientID%>').val();
            objPOMaster.NFANo = $('#<%=txtnfano.ClientID%>').val();
            objPOMaster.Termandcondition = $('#<%=txttermandcondition.ClientID%>').val();

            objPOMaster.ActionType = ActionType;
            objPOMaster.IsFree = IsFree;
            return objPOMaster;
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
        });
        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
    <script type="text/javascript">
        function AddItem() {
            if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                toast("Error", "Please Select Supplier", "");
                return;
            }

            if (jQuery('#ddlState option').length == 0) {
                toast("Error", "No State Found For Supplier", "");
                jQuery('#ddlState').focus();
                return;
            }
            if (jQuery('#ddlState').val() == "0") {
                toast("Error", "Please Select State For Supplier", "");
                jQuery('#ddlState').focus();
                return false;
            }
            if ($('#ddlCentre > option').length == 0) {
                toast("Error", "Please Select Delivery Centre", "");
                jQuery('#ddlCentre').focus();
                return;
            }
            if (jQuery('#ddlCentre').val() == "0") {
                toast("Error", "Please Select Delivery Centre", "");
                jQuery('#ddlCentre').focus();
                return false;
            }
            if ($('#ddlLocation > option').length == 0) {
                toast("Error", "Please Select Delivery Location", "");
                $('#ddlLocation').focus();
                return;
            }
            if (jQuery('#ddlLocation').val() == "0") {
                toast("Error", "Please Select Delivery Location", "");
                jQuery('#ddlLocation').focus();
                return false;
            }
            if (jQuery('#ddlManufacturer').val() == "") {
                toast("Error", "Please Select Manufacturer", "");
                jQuery('#ddlManufacturer').focus();
                return;
            }
            if (jQuery('#ddlMachine').val() == "") {
                toast("Error", "Please Select Machine", "");
                jQuery('#ddlMachine').focus();
                return;
            }
            if (jQuery('#ddlPackSize').val() == "") {
                toast("Error", "Please Select PackSize...!", "");
                jQuery('#ddlPackSize').focus();
                return;
            }
            if (jQuery('#lblItemID').html() == "") {
                toast("Error", "Please Select Item", "");
                jQuery('#txtItem').focus();
                return;
            }
            jQuery("#btnAddItem").attr('disabled', 'disabled').val('Submitting...');

            serverCall('DirectPO.aspx/getItemDetailtoAdd', { ItemID: $('#lblItemID').html(), SupplierID: jQuery('#<%=ddlsupplier.ClientID%>').val(), DeliveryLocationID: jQuery('#ddlLocation').val() }, function (response) {
                var POData = jQuery.parseJSON(response);
                if (POData.length == 0) {
                    jQuery("#btnAddItem").removeAttr('disabled').val('Add');
                    toast("Error", "Data Not Found.!", "");
                }
                else {
                    var id = jQuery('#lblItemID').html();

                    if (jQuery('table#tblPurchaseOrder').find('#' + id).length > 0) {
                        toast("Error", "Data Already Added.!", "");
                        jQuery("#btnAddItem").removeAttr('disabled').val('Add');
                        return;
                    }
                    var a = jQuery('#tblPurchaseOrder tr').length - 1;


                    var $mydata = [];

                    $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push('>');

                    $mydata.push('<td  style="text-align:left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdCategory">'); $mydata.push(POData[0].categorytypename); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdItemCategory">'); $mydata.push(POData[0].ItemCategory); $mydata.push('</td>');
                    $mydata.push('<td  id="tdItemID1" style="font-weight:bold;text-align:left;">'); $mydata.push(POData[0].Itemid); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdItemName">'); $mydata.push(POData[0].ItemName); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdhsnCode">'); $mydata.push(POData[0].hsncode); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdManufactureName">'); $mydata.push(POData[0].ManufactureName); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdcatalogNo">'); $mydata.push(POData[0].catalogno); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdMachineName">'); $mydata.push(POData[0].MachineName); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdMajorUnitName">'); $mydata.push(POData[0].MajorUnitName); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdPackSize">'); $mydata.push(POData[0].PackSize); $mydata.push('</td>');

                    $mydata.push('<td style="text-align:right" id="tdRate">'); $mydata.push(POData[0].Rate); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:right" id="tdDiscountPer">'); $mydata.push(POData[0].DiscountPer); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:right;" id="tdIGSTper">'); $mydata.push(POData[0].IGSTPer); $mydata.push(' </td>');
                    $mydata.push('<td style="text-align:right;" id="tdCGSTper">'); $mydata.push(POData[0].CGSTPer); $mydata.push(' </td>');
                    $mydata.push('<td style="text-align:right;" id="tdSGSTper">'); $mydata.push(POData[0].SGSTPer); $mydata.push('</td>');
                    $mydata.push('<td style="text-align:left" id="tdQuantity" ><input type="text" value="1"  style="width:60px" onkeypress="return checkForSecondDecimal(this,event);" id="txtQuantity" onkeyup="CalBuyPrice(this);"/></td>');
                    $mydata.push('<td style="text-align:left" id="tdFreeQty" ><input type="text"  style="width:60px" id="txtFreeQty" onkeypress="return checkForSecondDecimal(this,event);"/></td>');
                    $mydata.push('<td style="text-align:left" id="tdNetAmt" ><span id="spnNetAmt" style="text-align: right;">'); $mydata.push(POData[0].BuyPrice); $mydata.push(' </td>');
                    $mydata.push('<td  id="tdBuyPrice" style="display:none;text-align:left"> '); $mydata.push(POData[0].BuyPrice); $mydata.push('</td>');
                    $mydata.push('<td  id="tdItemTypeID" style="display:none;">'); $mydata.push(POData[0].ItemTypeID); $mydata.push('</td>');
                    $mydata.push('<td  id="tdItemID" style="display:none;">'); $mydata.push(POData[0].Itemid); $mydata.push('</td>');
                    $mydata.push('<td  id="tdManufactureID" style="display:none;">'); $mydata.push(POData[0].ManufactureID); $mydata.push('</td>');
                    $mydata.push('<td  id="tdMachineID" style="display:none;">'); $mydata.push(POData[0].MachineID); $mydata.push('</td>');
                    $mydata.push('<td  id="tdMajorUnitId" style="display:none;">'); $mydata.push(POData[0].MajorUnitId); $mydata.push('</td>');

                    $mydata.push('<td  id="tdVendorID" style="display:none;">'); $mydata.push(POData[0].VendorID); $mydata.push('</td>');
                    $mydata.push('<td  id="tdVendorAddress" style="display:none;">'); $mydata.push(POData[0].VendorAddress); $mydata.push('</td>');
                    $mydata.push('<td  id="tdSupplierName" style="display:none;">'); $mydata.push(POData[0].VendorName); $mydata.push('</td>');
                    $mydata.push('<td  id="tdIsLoginRequired" style="display:none;">'); $mydata.push(POData[0].IsLoginRequired); $mydata.push('</td>');
                    $mydata.push('<td  id="tdVendorStateId" style="display:none;">'); $mydata.push(POData[0].VendorStateId); $mydata.push('</td>');
                    $mydata.push('<td  id="tdVednorStateGstnno" style="display:none;">'); $mydata.push(POData[0].VednorStateGstnno); $mydata.push('</td>');
                    $mydata.push('<td  id="tdDiscountAmt" style="display:none;">'); $mydata.push(POData[0].DiscountAmt); $mydata.push('</td>');
                    $mydata.push('<td  id="tdDeliveryLocationID" style="display:none;">'); $mydata.push(POData[0].DeliveryLocationID); $mydata.push('</td>');
                    $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');

                    $mydata.push('</tr>');

                    $mydata = $mydata.join("");
                    jQuery('#tblPurchaseOrder').append($mydata);
                    jQuery('#<%=ddlsupplier.ClientID%>').attr("disabled", "disabled");
                    jQuery('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');


                    jQuery("#<%=ddlCentre.ClientID%>").attr("disabled", true);
                    $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
                    jQuery("#<%=ddlCentre.ClientID%>").trigger('chosen:updated');
                    jQuery("#<%=ddlState.ClientID%>,#<%=ddlCentreState.ClientID%>,#<%=ddlLocation.ClientID%>").attr("disabled", "disabled");
                    jQuery("#<%=ddlLocation.ClientID%>").trigger('chosen:updated');
                    clearTempData();
                    jQuery("#btnAddItem").removeAttr('disabled').val('Add');
                    jQuery("#tblPurchaseOrder").tableHeadFixer({
                    });
                }

            });
        }

        function clearTempData() {
            jQuery("#ddlManufacturer option").remove();
            jQuery("#ddlMachine option").remove();
            jQuery("#ddlPackSize option").remove();
            jQuery("#lblItemID,#lblItemGroupID,#lblItemName").html('');
            jQuery("#btnAddItem").removeAttr('disabled');
            if (jQuery('#tblPurchaseOrder tr:not(#trPOHeader)').length > 0) {
                jQuery('#btnSave').show();
            }
            else {
                jQuery('#btnSave').hide();

            }
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function CalBuyPrice(rowID) {
            var Quantity = jQuery(rowID).closest("tr").find("#txtQuantity").val() == "" ? 0 : parseFloat(jQuery(rowID).closest("tr").find("#txtQuantity").val());
            if (parseFloat($(rowID).val()) > parseFloat(Quantity)) {
                toast("Error", "Approved Quantity can not be greater than Requested Quantity...!", "");
                $(ctrl).val('0');
                return false;
            }
            var NetAmount = parseFloat(jQuery(rowID).closest("tr").find("#tdBuyPrice").text()) * parseFloat(Quantity);
            jQuery(rowID).closest("tr").find("#spnNetAmt").text(precise_round(NetAmount, 5));
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            else {
                if ((charCode != 46 && sender.value.indexOf('.') != -1) && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            if (charCode == '46' && jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                return false;
            }
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>
    <%-- Delete PurchaseOrder --%>
    <script type="text/javascript">
        function deleterow(itemid) {
            var table = document.getElementById('tblPurchaseOrder');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            if (jQuery('#tblPurchaseOrder tr:not(#trPOHeader)').length == 0) {
                jQuery("#ddlCentre").removeAttr("disabled");

                jQuery('#<%=ddlsupplier.ClientID%>').removeAttr("disabled");
                jQuery('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');

                jQuery("#ddlCentre").trigger('chosen:updated');
                jQuery("#ddlState,#ddlCentreState,#ddlLocation").removeAttr("disabled");
                jQuery("#ddlLocation").trigger('chosen:updated');
                clearTempData();
            }
        }
    </script>
    <%-- Bind All Data --%>
    <script type="text/javascript">
        function setgstndata() {
            if (jQuery('#ddlState').val() == "0") {
                jQuery('#txtGSTNo').val('');
            }
            else {
                jQuery('#txtGSTNo').val(jQuery('#ddlState').val().split('#')[1]);
            }
        }

        function setVendorData(SupplierID, con) {
            jQuery("#ddlState option").remove();
            if (con.split('#')[0] == "0")
                jQuery('#txtAddress,#txtGSTNo').val('');

            serverCall('Services/StoreCommonServices.asmx/bindvendorgstndata', { vendorid: SupplierID }, function (response) {
                var VendorData = $.parseJSON(response);
                if (VendorData.length == 0) {
                    jQuery("#ddlState option").remove();
                }
                else {
                    jQuery("#ddlState").append($("<option></option>").val("0").html("Select State"));
                    if (con.split('#')[0] == "0")
                        jQuery('#txtAddress').val(VendorData[0].address);

                    for (i = 0; i < VendorData.length; i++) {
                        jQuery("#ddlState").append($("<option></option>").val(VendorData[i].stateid).html(VendorData[i].state));
                    }
                }
                if (con.split('#')[0] == "1") {
                    var StateID = "".concat(con.split('#')[1], '#', con.split('#')[2]);
                    jQuery("#ddlState").val(StateID);
                    jQuery("#ddlState").attr('disabled', 'disabled');
                }
            });
        }

        function bindDCentre() {
            jQuery("#ddlCentre option").remove();

            serverCall('Services/StoreCommonServices.asmx/bindcentre', { stateid: $('#ddlCentreState').val() }, function (response) {
                var $ddlcentre = $('#<%=ddlCentre.ClientID%>');
                $ddlcentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'centreid', textField: 'centre' });
            });

            jQuery("#ddlCentre").trigger('chosen:updated');
            }

            function bindLocation() {
                jQuery("#ddlLocation option").remove();

                serverCall('DirectPO.aspx/bindLocation', { CentreID: jQuery('#ddlCentre').val() }, function (response) {
                    var LocationlData = $.parseJSON(response);
                    if (LocationlData.length == 0) {
                        jQuery("#ddlLocation").append($("<option></option>").val("0").html("--No Location Found--"));
                    }
                    else {
                        jQuery("#ddlLocation").append($("<option></option>").val("0").html("Select Location"));
                        for (i = 0; i < LocationlData.length; i++) {
                            jQuery("#ddlLocation").append($("<option></option>").val(LocationlData[i].LocationID).html(LocationlData[i].Location));
                        }
                    }
                    if (LocationlData.length == "1") {
                        jQuery("#ddlLocation").prop('selectedIndex', 1);
                    }
                    jQuery("#ddlLocation").trigger('chosen:updated');

                });
            }

            function setTempData(ItemGroupID, ItemGroupName) {
                jQuery('#lblItemGroupID').html(ItemGroupID);
                jQuery('#lblItemName').html(ItemGroupName);
                bindTempData('Manufacturer');
            }

            function bindTempData(bindType) {
                if (bindType == 'Manufacturer') {
                    bindManufacturer(jQuery('#lblItemGroupID').html());
                }
                else if (bindType == 'Machine') {
                    bindMachine(jQuery('#lblItemGroupID').html(), jQuery("#ddlManufacturer").val());
                }
                else if (bindType == 'PackSize') {
                    bindPackSize(jQuery('#lblItemGroupID').html(), jQuery("#ddlManufacturer").val(), jQuery("#ddlMachine").val());
                }
            }

            function bindManufacturer(ItemIDGroup) {
                jQuery("#<%=ddlManufacturer.ClientID %> option").remove();
                jQuery("#<%=ddlMachine.ClientID %> option").remove();
                jQuery("#<%=ddlPackSize.ClientID %> option").remove();
                locationidfrom = $('#<%=ddlLocation.ClientID%>').val();

                serverCall('VendorQuotation.aspx/bindManufacturer', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup }, function (response) {
                    var tempData = $.parseJSON(response);
                    if (tempData.length > 1) {
                        jQuery("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val('').html('Select Manufacturer'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        jQuery("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val(tempData[i].ManufactureID).html(tempData[i].ManufactureName));
                    }
                    if (tempData.length == 1) {
                        bindMachine(ItemIDGroup, tempData[0].ManufactureID);
                    }
                    else {
                        jQuery("#<%=ddlManufacturer.ClientID %>").focus();
                    }
                });
            }


        function bindMachine(ItemIDGroup, ManufactureID) {
            jQuery("#<%=ddlMachine.ClientID %> option").remove();
            jQuery("#<%=ddlPackSize.ClientID %> option").remove();
            locationidfrom = $('#<%=ddlLocation.ClientID%>').val();

            serverCall('VendorQuotation.aspx/bindMachine', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID }, function (response) {
                var tempData = $.parseJSON(response);
                if (tempData.length > 1) {
                    jQuery("#<%=ddlMachine.ClientID %>").append($("<option></option>").val('').html('Select Machine'));
                }
                for (var i = 0; i < tempData.length; i++) {
                    jQuery("#<%=ddlMachine.ClientID %>").append($("<option></option>").val(tempData[i].MachineID).html(tempData[i].MachineName));
                }
                if (tempData.length == 1) {
                    bindPackSize(ItemIDGroup, ManufactureID, tempData[0].MachineID);
                }
                else {
                    jQuery("#<%=ddlMachine.ClientID %>").focus();
                }
            });
        }


        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = jQuery('#ddlLocation').val();
            jQuery("#ddlPackSize option").remove();

            serverCall('VendorQuotation.aspx/bindPackSize', { locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID }, function (response) {
                var tempData = $.parseJSON(response);
                if (tempData.length > 1) {
                    jQuery("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val('').html('Select Pack Size'));
                }
                for (var i = 0; i < tempData.length; i++) {
                    jQuery("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val(tempData[i].PackValue).html(tempData[i].PackSize));
                }
                if (tempData.length == 1) {
                    setDataAfterPackSize();

                }
                else if (tempData.length == 0 || tempData.length > 0) {
                    jQuery("#ddlPackSize").focus();
                }
            });
        }
        function setDataAfterPackSize() {
            if (jQuery("#ddlPackSize").val() != '') {
                jQuery("#lblItemID").html(jQuery("#ddlPackSize").val().split('#')[2]);

            }
        }

    </script>
    <%-- Item Search--%>
    <script type="text/javascript">
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {


            return split(term).pop();
        }
        jQuery(function () {
            jQuery('#txtItem')
                      .bind("keydown", function (event) {
                          if (event.keyCode === $.ui.keyCode.TAB &&
                              $(this).autocomplete("instance").menu.active) {
                              event.preventDefault();
                          }
                          if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                              toast("Error", "Please Select Supplier...!", "");
                              return;
                          }
                      })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {
                              serverCall('DirectPO.aspx/SearchItem', { itemname: extractLast(request.term), locationidfrom: $('#<%=ddlLocation.ClientID%>').val(), searchoption: $("#<%=rdosearchitem.ClientID%>").find(":checked").val() },
                                  function (responseResult) {
                            response($.map(jQuery.parseJSON(responseResult), function (item) {
                                return {
                                    label: item.ItemName,
                                    value: item.ItemID
                                }
                            }))
                        });
                    },
                      
                          search: function () {
                              var term = extractLast(this.value);
                              if (term.length < 2) {
                                  return false;
                              }
                          },
                          focus: function () {
                              return false;
                          },
                          select: function (event, ui) {
                              this.value = '';
                              setTempData(ui.item.value, ui.item.label);
                              return false;
                          },
                      });
        });
       
        function accessRight() {
            jQuery("#ddlCentreState,#ddlCentre,#ddlLocation").attr('disabled', 'disabled');
            jQuery('#<%=ddlsupplier.ClientID%>').attr('disabled', 'disabled');
            jQuery('#<%=ddlsupplier.ClientID%>').trigger('chosen:updated');
            jQuery("#btnAddItem").hide();
            jQuery("#ddlCentre").trigger('chosen:updated');
            jQuery("#ddlLocation").trigger('chosen:updated');
        }
    </script>
    <%-- Maker Checker and Approval Save --%>
    <script type="text/javascript">
        function MakeAction(ButtonActionType) {

            var resultPurchaseOrder = POMaster();

            if (resultPurchaseOrder.chkData.length > 0) {
                jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + resultPurchaseOrder.chkData);
                jQuery.each(resultPurchaseOrder.chkData, function (index, value) {
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').find('#txtQuantity').focus();
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').css("background-color", "#FF0000");
                    jQuery('#tblPurchaseOrder tbody tr:eq(' + (value - 1) + ')').attr('title', 'Please Enter Valid Qty.');
                });
            }

            if (resultPurchaseOrder.dataPOMaster.length == 0) {
                toast("Error", "Please Select Item...!", "");
                return;
            }
            if (ButtonActionType == "Check")
                jQuery("#btnCheck").attr('disabled', 'disabled').val('Submitting...');
            else
                jQuery("#btnApproval").attr('disabled', 'disabled').val('Submitting...');
            //$modelBlockUI();
            serverCall('DirectPO.aspx/MakeAction', { POMaster: resultPurchaseOrder.dataPOMaster, ButtonActionType: ButtonActionType }, function (response) {
                var res = response.split('#')[0];
                if (res == "1") {
                    toast("Success", 'Purchase Order ' + ButtonActionType + ' Successfully', "");
                    location.reload(true);
                }
                else if (res == "2") {
                    toast("Error", "Already Checked...!", "");
                }
                else if (res == "3") {
                    toast("Error", "Already Approved...!", "");
                }
                else if (res == "4") {
                    toast("Error", "You Did not Have Any Right To " + ButtonActionType + " Purchase Order!", "");
                }
                else if (res == "0") {
                    toast("Error", response.split('#')[1], "");
                }
                else {
				
                    var POReturnData = jQuery.parseJSON(result.d);

                    if (POReturnData.hasOwnProperty("QtyValidation")) {
                        jQuery("#lblError").text('Please Enter Valid Qty. In S.No. ' + POReturnData.QtyValidation);
                        for (var i in POReturnData.QtyValidation) {
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().find('#txtQuantity').focus();
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().css("background-color", "#FF0000");
                            jQuery('#tblPurchaseOrder tbody tr:eq(' + JSON.stringify(POReturnData.QtyValidation[i]) + ')').prev().attr('title', 'Please Enter Valid Qty.');
                        }
                    }
                    else {

                    }
                }
                if (ButtonActionType == "Check")
                    jQuery("#btnCheck").removeAttr('disabled').val('Check');
                else
                    jQuery("#btnApproval").removeAttr('disabled').val('Approve');

                $modelUnBlockUI();

            });
        }
    </script>

    <script type="text/javascript">
        function getPOTermCondition() {
            var dataPOTermCondition = new Array();
            var objPOTermCondition = new Object();
            jQuery('#tblPOTerms tr').each(function () {
                var $rowid = jQuery(this).closest("tr");
                if (jQuery(this).attr("id") != "POTermHeader") {
                    objPOTermCondition.PurchaseOrderNo = jQuery("#lblPurchaseOrderNo").text();
                    if (jQuery("#lblPurchaseOrderID").text() != "")
                        objPOTermCondition.PurchaseOrderID = jQuery("#lblPurchaseOrderID").text();
                    else
                        objPOTermCondition.PurchaseOrderID = 0;
                    objPOTermCondition.POTermsCondition = jQuery.trim($rowid.find("#tdPOTerm").text());


                    objPOTermCondition.POTermConditionID = jQuery.trim($rowid.find("#tdPOTermConditionID").text());
                    dataPOTermCondition.push(objPOTermCondition);
                    objPOTermCondition = new Object();
                }
            });
            return dataPOTermCondition;
        }
    </script>

    <script type="text/javascript">
        function setvendordata() {
            var dropdown = $("#<%=ddlState.ClientID%>");
            $("#<%=ddlState.ClientID%> option").remove();
            $('#<%=txtAddress.ClientID%>').val('');
            $('#<%=txtGSTNo.ClientID%>').val('');

            serverCall('Services/StoreCommonServices.asmx/bindvendorgstndata', { vendorid: $('#<%=ddlsupplier.ClientID%>').val() }, function (response) {
                var PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    $("#<%=ddlState.ClientID%> option").remove();
                }
                else {
                    if (PanelData.length > 1) {
                        dropdown.append($("<option></option>").val("0").html("Select State"));
                    }
                    $('#<%=txtAddress.ClientID%>').val(PanelData[0].address);

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
            if ($('#<%=ddlState.ClientID%>').val() == "0") {
                $('#<%=txtGSTNo.ClientID%>').val('');
                 }
                 else {
                     $('#<%=txtGSTNo.ClientID%>').val($('#<%=ddlState.ClientID%>').val().split('#&#')[1]);
                 }
             }
    </script>
</asp:Content>

