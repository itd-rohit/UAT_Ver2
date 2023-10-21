<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreLocationMaster.aspx.cs" Inherits="Design_Store_StoreLocationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>
   
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Store Location Master</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Centre Details</div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Centre Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                    <asp:ListBox ID="lstCentreType" CssClass="multiselect requiredField" SelectionMode="Multiple" runat="server" onchange="bindCentre(0)"></asp:ListBox>

                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">OR Zone   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" onchange="bindState($(this).val().toString())"></asp:ListBox>

                </div>
            </div>

            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                  <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server"  onchange="bindCentrecity()"></asp:ListBox>

                    </div>

                <div class="col-md-3 ">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                   <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple"  runat="server"  onchange="bindCentre(0)"></asp:ListBox>

                    </div>
                </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8 ">
                     <asp:DropDownList ID="ddlcentre" runat="server"  class="ddlcentre chosen-select chosen-container requiredField" ToolTip="Centre" onchange="SearchRecords();setmyname();"></asp:DropDownList>

                    </div>
                <div class="col-md-11 ">
                                                <asp:CheckBox ToolTip="Check For Store Not Created Centre" ID="chonly" runat="server" Font-Bold="true" Text="Store Not Created" onclick="showstorenotcreated()" />

                </div>
               
                 </div>
            <div class="row">
                <div class="Purchaseheader">Location Details</div>
                </div>


             <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Location</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtlocationmain" ReadOnly="true" Style="text-transform: uppercase; background-color: #23ef91; border: 0px; font-weight: bold;" runat="server" MaxLength="500" ></asp:TextBox>
                   </div>  <div class="col-md-5 ">        
                    <asp:TextBox ID="txtlocation" Style="text-transform: uppercase;" runat="server" MaxLength="500" CssClass="requiredField"></asp:TextBox></div>
                       
                       <div class="col-md-2 "><asp:CheckBox ID="ChkActivate" runat="server" Checked="True" ForeColor="Red" Text="Active" Style="font-weight: 700" />
                          </div>  <div class="col-md-8 ">  <strong>(Example: BIO,IMUNO,HEMA,STORE etc)</strong></div>
                           <div class="col-md-1 "> <span id="locid" style="display: none;"></span></div>
                    

                 </div>

             <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Contact Person</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtconper" Style="text-transform: uppercase;" runat="server"  MaxLength="100" CssClass="requiredField"></asp:TextBox>
                    </div>
                 <div class="col-md-3 ">
                    <label class="pull-left">Contact Person No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtconperno"  runat="server" MaxLength="10" CssClass="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbconperno" runat="server" FilterType="Numbers" TargetControlID="txtconperno">
                            </cc1:FilteredTextBoxExtender>
                    </div>
                 </div>

             <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Address</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtaddress" runat="server" Width="1000px" MaxLength="200" CssClass="requiredField"></asp:TextBox>
                    </div>

                 </div>
            <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">Email</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                     <asp:TextBox ID="txtemailid" runat="server" ></asp:TextBox>                                                                     
                    </div>
                <div class="col-md-5 ">
                    <asp:CheckBox ID="chautoconsume" runat="server" Checked="True" ForeColor="Red" Text="Auto Consume On" Style="font-weight: 700" />
                      </div>
                
                <div class="col-md-3 ">
                    <label class="pull-left">Auto SI Received</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1 ">
                     <asp:TextBox ID="txtautoreceiveday"  runat="server"  MaxLength="3" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtautoreceiveday">
                            </cc1:FilteredTextBoxExtender>
                            
                    </div>

                 <div class="col-md-7 ">
                     <strong>(In Days) * Enter 0 For For Not Apply</strong>
                     </div>
                 </div>
            
        </div>



        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                <input type="button" value="Update" class="savebutton" onclick="UpdateData();" id="btnupdate" style="display: none;" />

                <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />
                <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
            </div>
            
        </div>
        </div>
        <div class="POuter_Box_Inventory" >  
            <div class="row">
                <div class="col-md-24 ">          
                <div style="max-height: 200px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle">State</td>
                            <td class="GridViewHeaderStyle">Centre</td>
                            <td class="GridViewHeaderStyle">Location</td>
                            <td class="GridViewHeaderStyle" style="width: 40px;" title="Auto SI Received Day">Auto SI</td>
                            <td class="GridViewHeaderStyle">Contact Person</td>
                            <td class="GridViewHeaderStyle">Contact Person No</td>
                            <td class="GridViewHeaderStyle">Status</td>
                            <td class="GridViewHeaderStyle">Created Date</td>
                            <td class="GridViewHeaderStyle">Created By</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;" title="Edit Location">Edit</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;" title="item Mapping With Location">Map Items</td>
                            <td class="GridViewHeaderStyle" style="width: 95px;">Store
                                            <br />
                                Location(SI)</td>
                            <td class="GridViewHeaderStyle" style="width: 105px;">Direct
                                <br />
                                Issue</td>
                            <td class="GridViewHeaderStyle" style="width: 105px;">Direct Stock<br />
                                Transfer</td>
                        </tr>
                    </table>
                </div>      
                     </div>
            
        </div>   
        </div>
    </div>
    <script type="text/javascript">
        function openmypopup(href) {
            var width = '1250px';
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
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentrecity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindcentertype();
            bindZone();
        });
    </script>
    <script type="text/javascript">
        function bindcentertype() {        
            serverCall('StoreLocationMaster.aspx/bindcentertype', {  }, function (response) {
                jQuery('#lstCentreType').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });              
            });          
        }
        function bindZone() {           
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery('#lstZone').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
            });         
        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });               
            }
            bindCentrecity();
        }
        function bindCentrecity() {
            var StateID = jQuery('#lstState').val().toString();
            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery('#lstCentrecity').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
            });          
            bindCentre(0);
        }

        function showstorenotcreated() {
            if (($('#<%=chonly.ClientID%>').prop('checked') == true)) {
                bindCentre(0);
            }
            else {
                var dropdown = $("#<%=ddlcentre.ClientID%>");
                $("#<%=ddlcentre.ClientID%> option").remove();
                dropdown.trigger('chosen:updated');
            }
        }

        function bindCentre(con) {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();
            var dropdown = $("#ddlcentre");
            $("#ddlcentre option").remove();
            var isstorecreated = "0";
            if (($('#chonly').prop('checked') == true)) {
                isstorecreated = "1";
            }
            serverCall('StoreLocationMaster.aspx/bindCentreNew', { TypeId:  TypeId , ZoneId: ZoneId , StateID: StateID , cityid: cityId , isstorecreated: isstorecreated }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select Centre', data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
                if (con != 0) {
                    $('#<%=ddlcentre.ClientID%>').val(con);
                    $('#<%=ddlcentre.ClientID%>').trigger('chosen:updated');
                }
            });
            
        }
        function setmyname() {
            var centreid = jQuery('#ddlcentre').val();
            if (centreid == "0") {
                $('#<%=txtlocationmain.ClientID%>').val('');
            }
            else {
                $('#<%=txtlocationmain.ClientID%>').val(jQuery('#ddlcentre option:selected').text());
                $('#<%=txtlocation.ClientID%>').focus();
            }
        }
    </script>

    <script type="text/javascript">
        function SaveData() {
            var length = $('#ddlcentre > option').length;
            if (length == 0) {
                toast("Error", 'Please Select Centre', "");
                return;
            }
            var centreid = jQuery('#ddlcentre').val();
            if (centreid == "0") {
                toast("Error", "Please Select Centre", "");
                return;
            }
            var locationmain = jQuery('#txtlocationmain').val();
            if (locationmain == "") {
                toast("Error", "Please Enter Location", "");
                return;
            }
            var location = jQuery('#txtlocation').val();
            if (location == "") {
                toast("Error", "Please Enter Location", "");
                return;
            }
            var address = jQuery('#<%=txtaddress.ClientID%>').val();
            if (address == "") {
                toast("Error", "Please Enter Address", "");
                return;
            }

            if ($('#<%=txtautoreceiveday.ClientID%>').val() == "") {
                toast("Error", "Please Enter Auto SI Received Day", "");
                return;
            }

            var cpname = jQuery('#txtconper').val();
            var cpno = jQuery('#txtconperno').val();

            if (cpname == "") {
                toast("Error", "Please Enter Contact Person Name", "");
                return;
            }

            if (cpno == "") {
                toast("Error", "Please Enter Contact Person No", "");
                return;
            }
            var cpnoemail = jQuery('#txtemailid').val();
           if (jQuery('#txtemailid').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtemailid').focus();
                    return;
                }
            }

            var savelo = locationmain.trim() + " " + location.trim();
            var autoconsume = "1";

            if (($('#<%=chautoconsume.ClientID%>').prop('checked') == false)) {
                autoconsume = "0";
            }
            serverCall('StoreLocationMaster.aspx/SaveData', { centreid: centreid, location: savelo, cpname: cpname, cpno: cpno, cpnoemail: cpnoemail, address: address, autoreceive: $('#<%=txtautoreceiveday.ClientID%>').val(), autoconsume: autoconsume }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Location Saved Sucessfully", "");

                    $('#locid').html('');
                    jQuery('#txtconper').val('');
                    jQuery('#txtconperno').val('');
                    jQuery('#txtlocation').val('');
                    jQuery('#txtemailid').val('');
                    $('#<%=txtautoreceiveday.ClientID%>').val('');
                    jQuery('#txtlocation').focus();
                    $('#<%=ChkActivate.ClientID%>').prop('checked', true);
                    $('#btnsave').show();
                    $('#btnupdate').hide();
                    SearchRecords();
                }
                else {
                    toast("Error", $responseData.response, "");
                }

            });

        }


             function SearchRecords() {
                 var StateID = jQuery('#lstState').val().toString();
                 var TypeId = jQuery('#lstCentreType').val().toString();
                 var ZoneId = jQuery('#lstZone').val().toString();
                 var cityId = jQuery('#lstCentrecity').val().toString();

                 var centreid = '0';
                 var length = $('#ddlcentre > option').length;
                 if (length > 0) {
                     centreid = $('#<%=ddlcentre.ClientID%>').val().split('#')[0];
                 }


                 $('#tblitemlist tr').slice(1).remove();
                
                 serverCall('StoreLocationMaster.aspx/SearchRecords', { centreid:  centreid , StateID:  StateID , TypeId: TypeId , ZoneId:  ZoneId , cityId:  cityId  }, function (response) {
                     var $responseData = JSON.parse(response);
                     if ($responseData.status) {
                         
                             var ItemData = jQuery.parseJSON($responseData.response)
                             for (var i = 0; i <= ItemData.length - 1; i++) {
                                 var $Tr = [];
                                 $Tr.push("<tr style='background-color:palegreen;' id='");
                                 $Tr.push(ItemData[i].LocationID); $Tr.push("'"); $Tr.push('>');
                                 if (ItemData[i].ContactPerson == null) {
                                     ItemData[i].ContactPerson = "";
                                 }
                                 if (ItemData[i].ContactPersonNo == null) {
                                     ItemData[i].ContactPersonNo = "";
                                 }
                                 $Tr.push("<td class='GridViewLabItemStyle' >"); $Tr.push(parseInt(i + 1)); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle"  id="tdstate">'); $Tr.push(ItemData[i].state); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle"  id="tdcentre">'); $Tr.push(ItemData[i].Centre); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" id="tdlocation">'); $Tr.push(ItemData[i].Location); $Tr.push("</td>");
                                 $Tr.push('<td id="tdAutoIndentReceivedDay">'); $Tr.push(ItemData[i].AutoIndentReceivedDay); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" id="tdContactPerson">'); $Tr.push(ItemData[i].ContactPerson); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" id="tdContactPersonNo">'); $Tr.push(ItemData[i].ContactPersonNo); $Tr.push("</td>");

                                 $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].astatus); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].CreatedDate); $Tr.push("</td>");
                                 $Tr.push('<td class="GridViewLabItemStyle" >'); $Tr.push(ItemData[i].CreatedBy); $Tr.push("</td>");

                                 $Tr.push('<td class="GridViewLabItemStyle" ><input type="button" title="Edit Location" value="Edit" style="cursor:pointer;font-weight:bold;" onclick="editme(this)"/> </td>');
                                 $Tr.push('<td class="GridViewLabItemStyle" ><input type="button" title="Map Items With Current Location" value="Map Items" style="cursor:pointer;font-weight:bold;" onclick="mapitemwithlocation(this)"/> </td>');
                                 $Tr.push('<td class="GridViewLabItemStyle" ><input type="button" title="Map Locations With Current Location For Indent" value="Store Location(SI)" style="cursor:pointer;font-weight:bold;" onclick="maplocationwithlocationsi(this)"/> </td>');

                                 $Tr.push('<td class="GridViewLabItemStyle" ><input type="button" title="Map Locations With Current Location For Direct Issue" value="Direct Issue" style="cursor:pointer;font-weight:bold;" onclick="maplocationwithlocationdr(this)"/> </td>');
                                 $Tr.push('<td class="GridViewLabItemStyle" ><input type="button" title="Map Locations With Current Location For Direct Stock Transfer" value="Direct Stock Transfer" style="cursor:pointer;font-weight:bold;" onclick="maplocationwithlocationdrstocktransfer(this)"/> </td>');
                                 $Tr.push('<td id="tdcentreid" style="display:none;">'); $Tr.push(ItemData[i].panel_id); $Tr.push("</td>");
                                 $Tr.push('<td id="tdactive" style="display:none;">'); $Tr.push(ItemData[i].IsActive); $Tr.push("</td>");
                                 $Tr.push('<td id="tdContactPersonEmail" style="display:none;">'); $Tr.push(ItemData[i].ContactPersonEmail); $Tr.push("</td>");
                                 $Tr.push('<td id="tdContactAddress" style="display:none;">'); $Tr.push(ItemData[i].storelocationAddress); $Tr.push("</td>");
                                 $Tr.push('<td id="tdAutoIndentReceivedDay" style="display:none;">'); $Tr.push(ItemData[i].AutoIndentReceivedDay); $Tr.push("</td>");
                                 $Tr.push('<td id="tdConsumeType" style="display:none;">'); $Tr.push(ItemData[i].ConsumeType); $Tr.push("</td>");
                                 $Tr.push("</tr>");

                                 $Tr = $Tr.join("");
                                 jQuery("#tblitemlist").append($Tr);

                             }

                         }

                     
                     else {
                         toast("Error", "No Location Found With This Centre", "");
                         $('#<%=txtlocation.ClientID%>').focus();
                     }
                 });                
             }

             function editme(ctrl) {
                 $('#<%=txtlocationmain.ClientID%>').val($(ctrl).closest("tr").find('#tdcentre').html());
                 $('#<%=txtlocation.ClientID%>').val($(ctrl).closest("tr").find('#tdlocation').html().replace($(ctrl).closest("tr").find('#tdcentre').html(), '').trim());
                 $('#<%=txtconper.ClientID%>').val($(ctrl).closest("tr").find('#tdContactPerson').html());
                 $('#<%=txtconperno.ClientID%>').val($(ctrl).closest("tr").find('#tdContactPersonNo').html());

                 $('#<%=txtemailid.ClientID%>').val($(ctrl).closest("tr").find('#tdContactPersonEmail').html());
                 $('#<%=txtaddress.ClientID%>').val($(ctrl).closest("tr").find('#tdContactAddress').html());
                 $('#locid').html($(ctrl).closest("tr").attr('id'));

                 if ($(ctrl).closest("tr").find('#tdactive').html() == "1") {
                     $('#<%=ChkActivate.ClientID%>').prop('checked', true);
                 }
                 else {
                     $('#<%=ChkActivate.ClientID%>').prop('checked', false);
                 }
                 if ($(ctrl).closest("tr").find('#tdConsumeType').html() == "1") {
                     $('#<%=chautoconsume.ClientID%>').prop('checked', true);
                 }
                 else {
                     $('#<%=chautoconsume.ClientID%>').prop('checked', false);
                 }
                 bindCentre($(ctrl).closest("tr").find('#tdcentreid').html());
                 
                 $('#<%=txtautoreceiveday.ClientID%>').val($(ctrl).closest("tr").find('#tdAutoIndentReceivedDay').html());
                 $('#btnsave').hide();
                 $('#btnupdate').show();

             }
             function UpdateData() {
                 var length = $('#ddlcentre > option').length;
                 if (length == 0) {
                     toast("Error", "Please Select Centre", "");
                     return;
                 }
                 var centreid = jQuery('#ddlcentre').val();
                 if (centreid == "0") {
                     toast("Error", "Please Select Centre", "");

                     return;
                 }
                 var location = jQuery('#txtlocation').val();
                 if (location == "") {
                     toast("Error", "Please Enter Location", "");
                     return;
                 }
                 var cpname = jQuery('#txtconper').val();
                 var cpno = jQuery('#txtconperno').val();

                 if (cpname == "") {
                     toast("Error", "Please Enter Contact Person Name", "");
                     return;
                 }

                 if (cpno == "") {
                     toast("Error", "Please Enter Contact Person No", "");
                     return;
                 }

                 if ($('#<%=txtautoreceiveday.ClientID%>').val() == "") {
                     toast("Error", "Please Enter Auto SI Received Day", "");
                     return;
                 }

                 var cpnoemail = jQuery('#txtemailid').val();
                 var isactive = "1";

                 if (($('#<%=ChkActivate.ClientID%>').prop('checked') == false)) {
				       isactive = "0";
				   }
				   var locationmain = jQuery('#txtlocationmain').val();
				   if (locationmain == "") {
				       toast("Error", "Please Enter Location", "");
				       return;
				   }
				   var address = jQuery('#<%=txtaddress.ClientID%>').val();
                 if (address == "") {
                     toast("Error", "Please Enter Address", "");
                     return;
                 }

                 var savelo = locationmain.trim() + " " + location.trim();
                 var locid = $('#locid').html();

                 var autoconsume = "1";

                 if (($('#<%=chautoconsume.ClientID%>').prop('checked') == false)) {
                     autoconsume = "0";
                 }
                 
                 serverCall('StoreLocationMaster.aspx/UpdateData', { centreid:  centreid , location: savelo , cpname: cpname, cpno: cpno , locid: locid , isactive: isactive , cpnoemail: cpnoemail, address: address , autoreceive:  $('#<%=txtautoreceiveday.ClientID%>').val() , autoconsume: autoconsume  }, function (response) {
                     var $responseData = JSON.parse(response);
                     if ($responseData.status) {
                         toast("Success", $responseData.response, "");

                         $('#locid').html('');
                         jQuery('#txtconper').val('');
                         jQuery('#txtconperno').val('');
                         jQuery('#txtemailid').val('');
                         jQuery('#txtlocation').val('');
                         jQuery('#txtlocationmain').val('');
                         $('#<%=txtaddress.ClientID%>').val('');
                         $('#<%=ChkActivate.ClientID%>').prop('checked', true);
                         $('#<%=txtautoreceiveday.ClientID%>').val('');
                         $("#<%=ddlcentre.ClientID%> option").remove();
                         $("#<%=ddlcentre.ClientID%>").trigger('chosen:updated');
                         $('#btnsave').show();
                         $('#btnupdate').hide();
                         SearchRecords();
                     }
                     else {
                         toast("Error", $responseData.response, "");
                     }

                 });                 
            }
             function ExportToExcel() {
                 serverCall('StoreLocationMaster.aspx/ExportToExcel', {  }, function (response) {
                     var $responseData = JSON.parse(response);
                     if ($responseData.status) {
                         window.open('../common/ExportToExcel.aspx');
                     }
                     else {
                         toast("Info", "No Record Found..!", "");
                     }
                 });              
             }
             function Refresh() {
                 $('#locid').html('');
                 jQuery('#txtconper').val('');
                 jQuery('#txtconperno').val('');
                 jQuery('#txtemailid').val('');
                 jQuery('#txtlocation').val('');
                 $('#<%=ChkActivate.ClientID%>').prop('checked', true);
                 $("#<%=ddlcentre.ClientID%> option").remove();
                 $("#<%=ddlcentre.ClientID%>").trigger('chosen:updated');
                 $('#<%=txtautoreceiveday.ClientID%>').val('');
                 $('#btnsave').show();
                 $('#btnupdate').hide();
             }
             function setme() {
                 $('#<%=txtlocation.ClientID%>').focus();
             }
             function mapitemwithlocation(ctrl) {
                 openmypopup('itemLocationMapping.aspx?LocID=' + $(ctrl).closest('tr').attr('id'));
             }
             function maplocationwithlocationsi(ctrl) {
                 openmypopup('LocationLocationMappingSI.aspx?LocID=' + $(ctrl).closest('tr').attr('id'));
             }
             function maplocationwithlocationdr(ctrl) {
                 openmypopup('LocationLocationMappingDirectReceive.aspx?LocID=' + $(ctrl).closest('tr').attr('id'));
             }
             function maplocationwithlocationdrstocktransfer(ctrl) {
                 openmypopup('LocationLocationMappingDirectStockTransfer.aspx?LocID=' + $(ctrl).closest('tr').attr('id'));
             }
    </script>
</asp:Content>

