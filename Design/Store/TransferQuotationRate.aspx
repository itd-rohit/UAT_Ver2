<%@ Page Title=""   ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TransferQuotationRate.aspx.cs" Inherits="Design_Store_TransferQuotationRate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
  
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
 <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

        <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Transfer Quotation Rate From Location</b>
            <span id="spnError"></span>
            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />   
        </div>

          <div class="POuter_Box_Inventory" style="text-align: center">

            <div id="PatientDetails" class="POuter_Box_Inventory"> 
                 <div class="row">
                      <div class="col-md-24">
                <div class="col-md-11">
                <div class="Purchaseheader" style="cursor: pointer;" ">
                    From Location
                </div>
            </div>
                     <div class="col-md-2 ">
                               </div>
                    <div class="col-md-11">
                <div class="Purchaseheader" style="cursor: pointer;" ">
                   To Location
                </div>
                </div>
                          </div>
</div>                
                <div class="row" id="tab1" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">From Location:   </label>
                                <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-8 ">
                                 <asp:DropDownList ID="ddllocation" runat="server"  class="ddllocation chosen-select chosen-container" onchange="getfromrate()"></asp:DropDownList>
                              </div>
                           <div class="col-md-2" >
                               <img src="../../App_Images/TRY6_25.gif" style="cursor:pointer;border:1px solid black" onclick="transfernow()" title="Transfer Rate" />
                               </div>
                        <div class="col-md-3 ">
                                <label class="pull-left ">To Location:   </label>
                                <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-8 ">
                                 <asp:ListBox ID="ddltolocation" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ></asp:ListBox>
                              </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">	Machine:   </label>
                                <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-8 ">
                                 <asp:ListBox ID="ddlmachine" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="getfromrate()"></asp:ListBox>
                              </div>
                           <div class="col-md-2 ">
                               </div>
                        <div class="col-md-3 ">
                                <asp:CheckBox ID="ch" runat="server" ToolTip="Check IF You Want To Change Supplier" Text="Change Supp:" onclick="setmein(this)" style="font-weight: 700" />
                        <b class="pull-right">:</b>     
                        </div>
                             <div class="col-md-8 ">
                                <asp:DropDownList ID="ddlchangevendor" ToolTip="Select IF You Want To Change Supplier" runat="server"  class="ddlchangevendor chosen-select chosen-container" onchange="setvendordata()"></asp:DropDownList>
                              </div>
                            </div>
                          <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">	Supplier:   </label>
                                <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-8 ">
                                <asp:ListBox ID="ddlsupplier" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="getfromrate()"></asp:ListBox>
                              </div>
                           <div class="col-md-2 ">
                                 <img src="../../App_Images/Reload.jpg" style="cursor:pointer;border:1px solid black;" onclick="refreshnow()" title="Refresh" />
                               </div>
                        <div class="col-md-3 ">
                             <label class="pull-left ">	State/GSTN:   </label>
                                <b class="pull-right">:</b>
                                
                             </div>
                             <div class="col-md-4 ">
                                 <asp:DropDownList ID="ddlstate" runat="server"  onchange="setgstndata()" ></asp:DropDownList>                               
                              </div>
                              <div class="col-md-4 ">
                                     <asp:TextBox ID="txtgstnno" runat="server"  ReadOnly="true" ></asp:TextBox>
                                  </div>
                            </div>
                           <div class="row">
                            <div class="col-md-3 ">
                                
                             </div>
                             <div class="col-md-8 ">
                                
                              </div>
                           <div class="col-md-2 ">
                               </div>
                        <div class="col-md-3 ">
                             <label class="pull-left ">	Address:   </label>
                                <b class="pull-right">:</b>
                             </div>
                             <div class="col-md-8 ">
                                <asp:TextBox ID="txtaddress" runat="server"  ReadOnly="true" ></asp:TextBox>
                              </div>
                              
                            </div>
                          <div class="row">
                            <div class="col-md-11 ">
                                <table>
                                    <tr>
                                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: palegreen;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>Rate Set</td>
                                         <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rate Not Set</td>
                                    </tr>
                                </table>
                             </div>
                           <div class="col-md-2 ">
                               <input type="button" value="Transfer Rate" class="searchbutton" onclick="transfernow()" style="float:left;" />
                               </div>
                        <div class="col-md-11 ">
                                           <div style="font-weight:bold;font-size:11px; font-style: italic;color:red;padding-left:0px;text-align:left;float:left">
                                               * Only Set Rate Quotation Tranfer<br />
                                               * Check Change Supplier CheckBox and Then Select Supplier if You Want To Change Supplier
                                           </div>
                             </div>
                              
                            </div>
                        </div>

                    </div>


                        </div>
                    </div>
             <div class="POuter_Box_Inventory" style="text-align: center">
                   <div class="row" id="Div1" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                              <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                         <td class="GridViewHeaderStyle" style="width: 20px;"><input type="checkbox" onclick="checkall(this)" /></td>
                                          <td class="GridViewHeaderStyle">Supplier</td>
                                        <td class="GridViewHeaderStyle">Supplier State</td>
                                         <td class="GridViewHeaderStyle">MachineName</td>
                                         <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">ItemName</td>
                                         <td class="GridViewHeaderStyle">Rate</td>
                                      <td class="GridViewHeaderStyle">DiscountPer</td>
                                           <td class="GridViewHeaderStyle">DiscountAmt</td>
                                         <td class="GridViewHeaderStyle">IGSTPer</td>
                                           <td class="GridViewHeaderStyle">SGSTPer</td>
                                           <td class="GridViewHeaderStyle">CGSTPer</td>
                                          <td class="GridViewHeaderStyle">GSTAmount</td>
                                         <td class="GridViewHeaderStyle">BuyPrice</td> 
                                     </tr>
                                 </table>
                            </div>
                        </div>
                       </div>
             </div>

                </div>
    <script type="text/javascript">

        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(ctr).is(":checked")) {

                        $(this).find('#ch').attr('checked', true);
                    }
                    else {
                        $(this).find('#ch').attr('checked', false);
                    }


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

        $(document).ready(function () {
            $('#<%=ddlmachine.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddlsupplier.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddltolocation.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

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
            dlall();
            bindlocation();
            bindmachine();
            bindtolocation();
            bindsupplier();
            bindsupplierchange();
        });


    </script>
    <script type="text/javascript">


        function bindlocation() {
            $("#<%=ddllocation.ClientID%> option").remove();
            serverCall('TransferQuotationRate.aspx/bindlocation', {}, function (response) {
                var $ddlloc = $('#<%=ddllocation.ClientID%>');
                $ddlloc.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'deliverylocationid', textField: 'deliverylocationname', isSearchAble: true });
            });
        }
       
        function bindsupplierchange() {
            $("#<%=ddlchangevendor.ClientID%> option").remove();

            serverCall('TransferQuotationRate.aspx/bindsupplierchange', { }, function (response) {
                var $ddlvendor = $('#<%=ddlchangevendor.ClientID%>');
                $ddlvendor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SupplierID', textField: 'SupplierName', isSearchAble: true });
            });
        }

        function bindmachine() {
            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#ddlmachine').multipleSelect("refresh");
             serverCall('TransferQuotationRate.aspx/bindmachine', {}, function (response) {
                 jQuery('#ddlmachine').bindMultipleSelect({ data: JSON.parse(response), valueField: 'MachineID', textField: 'MachineName', controlID: $("#ddlmachine"), isClearControl: '' });
             });
        }

        function bindsupplier() {
            $('#<%=ddlsupplier.ClientID%> option').remove();
            $('#<%=ddlsupplier.ClientID%>').multipleSelect("refresh");
            serverCall('TransferQuotationRate.aspx/bindsupplier', {}, function (response) {
                jQuery('#ddlsupplier').bindMultipleSelect({ data: JSON.parse(response), valueField: 'VendorId', textField: 'VendorName', controlID: $("#ddlsupplier"), isClearControl: '' });
            });
        }

        function bindtolocation() {
            $('#<%=ddltolocation.ClientID%> option').remove();
            $('#<%=ddltolocation.ClientID%>').multipleSelect("refresh");

            serverCall('TransferQuotationRate.aspx/bindtolocation', {}, function (response) {
                jQuery('#ddltolocation').bindMultipleSelect({ data: JSON.parse(response), valueField: 'locationid', textField: 'location', controlID: $("#ddltolocation"), isClearControl: '' });
            });
        }
         
    </script>

    <script type="text/javascript">

        function setvendordata() {
            var dropdown = $("#<%=ddlstate.ClientID%>");
            $("#<%=ddlstate.ClientID%> option").remove();
            $('#<%=txtaddress.ClientID%>').val('');
            $('#<%=txtgstnno.ClientID%>').val('');
            serverCall('Services/StoreCommonServices.asmx/bindvendorgstndata', { vendorid: $('#<%=ddlchangevendor.ClientID%>').val() }, function (response) {
                var $ddlstate = $('#<%=ddlstate.ClientID%>');
                $ddlstate.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'stateid', textField: 'state' });
                setgstndata();
                $('#<%=txtaddress.ClientID%>').val(response[0].address);
              //  alert(response[0].address);
            });
        }

        function setgstndata() {
            if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                $('#<%=txtgstnno.ClientID%>').val('');
            }
            else {
                $('#<%=txtgstnno.ClientID%>').val($('#<%=ddlstate.ClientID%>').val().split('#')[1]);
            }
        }
    </script>

    <script type="text/javascript">
        function getfromrate() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $('#tblitemlist tr').slice(1).remove();
                return;
            }
            var machineid = $('#<%=ddlmachine.ClientID%>').val().toString();
            var supplier = $('#<%=ddlsupplier.ClientID%>').val().toString();
            $('#tblitemlist tr').slice(1).remove();
            $modelBlockUI();

            var _temp = [];
            _temp.push(serverCall('TransferQuotationRate.aspx/SearchFromRecords', { locationid: $('#<%=ddllocation.ClientID%>').val().toString(), machineid: machineid, supplier: supplier }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    if ($ReqData.length == 0) {
                        toast("Error", "No Item Rate Found This Location..!", "");
                        $modelUnBlockUI();
                    }
                    else {
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            var $mydata = [];

                            var color = "palegreen";
                            if ($ReqData[i].ComparisonStatus == "0") {
                                color = "white";
                            }
                            $mydata.push("<tr style='background-color:"); $mydata.push(color); $mydata.push(";'>");

                            $mydata.push("<td class='GridViewLabItemStyle' >"); $mydata.push(parseInt(i + 1)); $mydata.push("</td>");
                            if ($ReqData[i].ComparisonStatus == "1") {
                                $mydata.push('<td class="GridViewLabItemStyle"><input type="checkbox" id="ch" checked="checked" /></td>');
                            }
                            else {
                                $mydata.push('<td class="GridViewLabItemStyle"></td>');
                            }
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($ReqData[i].vendorname); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].VednorStateName); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].MachineName); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tditemid">'); $mydata.push($ReqData[i].itemid); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].ItemName); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].Rate); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].DiscountPer); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].DiscountAmt); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].IGSTPer); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].SGSTPer); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].CGSTPer); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].GSTAmount); $mydata.push('</td>');

                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].FinalPrice); $mydata.push('</td>');

                            $mydata.push('<td class="GridViewLabItemStyle" style="display:none;">'); $mydata.push($ReqData[i].ComparisonStatus); $mydata.push('</td>');

                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery('#tblitemlist').append($mydata);

                        }
                    }

                });
            }));
            $modelUnBlockUI();
        }



        function transfernow() {

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                toast("Error", "No Item Rate Found This Location..!", "");
                showerrormsg("Please Select From Location");
                return;
            }

            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "No Rate Set For Selected Location..!", "");
                return;
            }
            var tolocation = $('#<%=ddltolocation.ClientID%>').val();
            if (tolocation == "") {
                toast("Error", "Please Select To Location..!", "");
                return;
            }
            if ($('#<%=ch.ClientID%>').is(':checked') && $('#<%=ddlchangevendor.ClientID%>').val() == "0") {
                toast("Error", "Please Select Change Supplier..!", "");
                return;
            }
            if (confirm("All Item Quotation Transfer For Selected Machine and Vendor Do You Want To Continue.?") == false) {
                return;
            }
            var machineid = $('#<%=ddlmachine.ClientID%>').val();
            var supplier = $('#<%=ddlsupplier.ClientID%>').val();

            var tosupplier = $('#<%=ddlchangevendor.ClientID%>').val();
            var tosuppliername = $('#<%=ddlchangevendor.ClientID%> option:selected').text();

            var tostate = "0";
            var tostatename = "0";
            var length = $('#<%=ddlstate.ClientID%> > option').length;
            if (length > 0) {
                tostate = $('#<%=ddlstate.ClientID%>').val();
                tostatename = $('#<%=ddlstate.ClientID%> option:selected').text();
            }
            var tosupplieraddress = $('#<%=txtaddress.ClientID%>').val();

            var togstn = $('#<%=txtgstnno.ClientID%>').val();
            var itemid = "";

            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#ch").is(':checked')) {
                    itemid += (itemid.length > 0 ? ',' : '') + $(this).find("#tditemid").html();
                }
            });
            if (itemid.length == 0) {
                toast("Error", "Please Select Item To Transfer..!", "");
                return;
            }
            $modelBlockUI();
            serverCall('TransferQuotationRate.aspx/TransferRateRecords', { locationid: $('#<%=ddllocation.ClientID%>').val(), machineid:machineid, tolocation: tolocation, itemidtosave:itemid}, function (response) {
                var result = response;
                if (result == "3") {
                    toast("Error", "You Can Select More Then 20 Location..!", "");
                    return;
                }
                else if (result == "1") {
                    toast("Success", "Rate Tranfered Sucessfully...!", "");
                    refreshnow();
                }
                else {
                    toast("Error", result, "");
                }
            });
            $modelUnBlockUI();
        }

        function refreshnow() {
            bindlocation();
            bindmachine();
            bindtolocation();
            bindsupplier();
            $('#tblitemlist tr').slice(1).remove();
            dlall();
            cleme();
        }

        function cleme() {
            $('#<%=ddlchangevendor.ClientID%>').prop('selectedIndex', 0);
            $("#<%=ddlchangevendor.ClientID%>").trigger('chosen:updated');
            $('#<%=txtgstnno.ClientID%>').val('');
            $('#<%=txtaddress.ClientID%>').val('');
            $("#<%=ddlstate.ClientID%> option").remove();
        }

        function enall() {
            $('#<%=ddlchangevendor.ClientID%>').attr("disabled", false);
            $("#<%=ddlchangevendor.ClientID%>").trigger('chosen:updated');
            $('#<%=ddlstate.ClientID%>').attr("disabled", false);
            $('#<%=txtgstnno.ClientID%>').attr("disabled", false);
            $('#<%=txtaddress.ClientID%>').attr("disabled", false);
        }
        function dlall() {
            $('#<%=ddlchangevendor.ClientID%>').attr("disabled", true);
            $("#<%=ddlchangevendor.ClientID%>").trigger('chosen:updated');
            $('#<%=ddlstate.ClientID%>').attr("disabled", true);
            $('#<%=txtgstnno.ClientID%>').attr("disabled", true);
            $('#<%=txtaddress.ClientID%>').attr("disabled", true);
        }


        function setmein(ctrl) {
            if ($(ctrl).is(':checked')) {
                enall();
                cleme();
            }
            else {
                dlall();
                cleme();
            }
        }
    </script>

</asp:Content>

