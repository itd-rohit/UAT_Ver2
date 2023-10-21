<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionLocationMaster.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionLocationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
   
  
    <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
    <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Home Collection Location Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlZone" runat="server" class="ddlZone chosen-select" ClientIDMode="Static" onchange="bindState('-1')"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static" class="ddlState chosen-select" onchange="bindCity(this.value,'-1');"></asp:DropDownList>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCity" runat="server" class="ddlCity chosen-select" ClientIDMode="Static"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <asp:CheckBox ID="chkIsActive" runat="server" Text="IsActive" Checked="true" Style="font-weight: bold" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-2" style="display: none;">
                    <label class="pull-left">HeadQuater</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none;">
                    <asp:DropDownList ID="ddlHeadquarter" Style="display: none" runat="server"  onchange="bindCity(this.value,'-1');" ClientIDMode="Static"></asp:DropDownList>

                </div>
                <div class="col-md-2" style="display: none;">
                    <label class="pull-left">City Zone</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none;">
                    <asp:DropDownList ID="ddlCityZone" Style="display: none" runat="server"  ClientIDMode="Static"></asp:DropDownList>
                   
                </div>
                 </div>
            <div class="row">
                <div class="col-md-8 Update">
                 <asp:CheckBox ID="chkIshomeCollection" runat="server" Text="IsHomeCollection" Checked="true" class="Update" Style="font-weight: bold" />
                      </div>
                <div class="col-md-2 Update">
                    <label class="pull-left">Location</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 Update">
                    <asp:TextBox ID="txt_Location" runat="server"></asp:TextBox>
                    <asp:Label ID="lblLocation" runat="server" Style="display: none"></asp:Label>
                   
                </div>
                <div class="col-md-2 Update">
                     <asp:TextBox ID="txtPincode" CssClass="pincode" runat="server" MaxLength="6" placeholder="Pincode"></asp:TextBox>
                </div>
            </div>


            <div class="row Update">
                <div class="col-md-3 homecollection">
                    <label class="pull-left">Opening Time</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 homecollection">
                    <input type="text" disabled="disabled" id="txt_OpenTime" runat="server" onchange="getNoSlot();" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="00:00" />

                </div>
                <div class="col-md-3 homecollection"></div>
                <div class="col-md-2 homecollection">
                    <label class="pull-left">Closing Time</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 homecollection">
                    <input type="text" disabled="disabled" id="txt_ClosingTime" runat="server" onchange="getNoSlot();" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="23:30" />
                </div>
                <div class="col-md-2 homecollection">
                    <label class="pull-left">Avg Time</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 homecollection">
                    <asp:DropDownList ID="ddAvgtime"   onchange="getNoSlot();" runat="server">
                        <asp:ListItem  Value="10">10-Min</asp:ListItem>
                        <asp:ListItem Selected="True" Value="15">15-Min</asp:ListItem>
                        <asp:ListItem Value="30">30-Min</asp:ListItem>
                        <asp:ListItem Value="45">45-Min</asp:ListItem>
                        <asp:ListItem Value="60">60-Min</asp:ListItem>
                    </asp:DropDownList> </div>
                    <div class="col-md-2 homecollection">
                    <b>Time Slot :&nbsp;</b> </div>
                 <div class="col-md-2 homecollection"><asp:DropDownList ID="ddlTimeSloat"  runat="server">
                        <asp:ListItem Value="1">1-Slot</asp:ListItem>
                        <asp:ListItem Selected="True" Value="2">2-Slot</asp:ListItem>
                        <asp:ListItem  Value="3">3-Slot</asp:ListItem>
                        <asp:ListItem Value="6">6-Slot</asp:ListItem>
                    </asp:DropDownList>

                </div>
                <div class="col-md-2 homecollection"><b style="display: none"><span style="color: red;" runat="server" id="spn_NoSlot">No of slot:0</span></b> </div>
            </div>
        </div>
       
        <div class="div_Save">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="cursor: pointer;">Area Details   <span style="margin-left: 50%;"><span style="color: red;">Import Area(<span style="color: blue; font-size: 10px; cursor: pointer"><a class="im" url="ExcelFormat/AreaExcelFormat.xlsx" style="cursor: pointer" href="ExcelFormat/AreaExcelFormat.xlsx" target="_blank">Excel Format</a></span>)~</span><asp:FileUpload ID="file1" runat="server" /><asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" /></span></div>
                <div runat="server" id="tblData" style="height: 200px; overflow: auto;">
                    <div class="row">
                        <table width="100%" id="tblAreaDetails">
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 15px" align="left">Add</th>

                                <th class="GridViewHeaderStyle" style="width: 200px" align="left">Location</th>
                                <th class="GridViewHeaderStyle" style="width: 90px" align="left">Pincode~<asp:TextBox ID="txtHeaderPincode" MaxLength="6" runat="server" Width="68%" onkeyup="checkPicodeHeader(this)" placeholder="Pincode"></asp:TextBox></th>
                                <th class="GridViewHeaderStyle" style="width: 50px" align="left">Start Time<input type="text" style="width: 54%; display: none" id="txtHeader_OpenTime" runat="server" onchange="CloneStartTime(this);" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="08:00" /></th>
                                <th class="GridViewHeaderStyle" style="width: 50px" align="left">Closing Time<input type="text" style="width: 45%; display: none;" id="txtHeader_CloseTime" runat="server" onchange="CloneCloseTime(this);" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="18:00" /></th>
                                <th class="GridViewHeaderStyle" style="width: 55px" align="left">Avg Time<asp:DropDownList ID="ddslot_Header" Style="width: 59%; display: none;" onchange="CloneAvgTime(this);" runat="server">
                                    <asp:ListItem Value="15">15-Min</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="30">30-Min</asp:ListItem>
                                    <asp:ListItem Value="45">45-Min</asp:ListItem>
                                    <asp:ListItem Value="60">60-Min</asp:ListItem>
                                </asp:DropDownList>
                                </th>
                                <th class="GridViewHeaderStyle" style="width: 55px; display: none" align="left">No of slot</th>
                                <th class="GridViewHeaderStyle" style="width: 90px" align="left">Time Slot~<asp:DropDownList ID="ddNewslot_Header" Style="width: 44%;" onchange="CloneNewslot(this);" runat="server">
                                    <asp:ListItem Value="1">1-Slot</asp:ListItem>
                                    <asp:ListItem Value="2">2-Slot</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="3">3-Slot</asp:ListItem>
                                    <asp:ListItem Value="6">6-Slot</asp:ListItem>
                                </asp:DropDownList></th>
                                <th class="GridViewHeaderStyle" align="left" style="width: 50px">Remove</th>

                            </tr>

                            <tr id="tr_dynamic" class="tr_remove">
                                <td id="td1" style="text-align: center">
                                    <img src="../../App_Images/plus.png" style="width: 15px; cursor: pointer" onclick="addfidetail();"></td>

                                <td id="td3">
                                    <asp:TextBox ID="txtMoreArea" runat="server" Width="99%" placeholder="Area"></asp:TextBox></td>
                                <td id="td4">
                                    <asp:TextBox ID="txtMorePincode" runat="server" Width="99%" onkeyup="checkPicode(this)" MaxLength="6" placeholder="Pincode"></asp:TextBox></td>
                                <td id="td5">
                                    <input type="text" style="width: 99%;" disabled="disabled" id="txtMore_OpenTime" runat="server" onchange="getNoSlot_More(this);" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="00:00" /></td>
                                <td id="td6">
                                    <input type="text" style="width: 99%;" disabled="disabled" id="txtMore_CloseTime" runat="server" onchange="getNoSlot_More(this);" name="bookingcutoff" onkeypress="return false;" class="bookingcutoff timepiker" value="23:30" /></td>
                                <td id="td7">
                                    <asp:DropDownList ID="ddslot_more" disabled="disabled" Width="99%" onchange="getNoSlot_More(this);" runat="server">
                                        <asp:ListItem Value="10">10-Min</asp:ListItem>
                                        <asp:ListItem Selected="True"  Value="15">15-Min</asp:ListItem>
                                        <asp:ListItem Value="30">30-Min</asp:ListItem>
                                        <asp:ListItem Value="45">45-Min</asp:ListItem>
                                        <asp:ListItem Value="60">60-Min</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td id="td8" style="text-align: center; width: 50px; display: none;"><span style="color: red;" runat="server" id="spnMore_NoSlot">20</span></td>
                                <td id="td2">
                                    <asp:DropDownList ID="ddNewslot_more" Width="99%" runat="server">
                                        <asp:ListItem Value="1">1-Slot</asp:ListItem>
                                        <asp:ListItem Selected="True"  Value="2">2-Slot</asp:ListItem>
                                        <asp:ListItem Value="3">3-Slot</asp:ListItem>
                                        <asp:ListItem Value="6">6-Slot</asp:ListItem>

                                    </asp:DropDownList>
                                </td>
                                <td id="td9" style="width: 50px">
                                    <img src="../../App_Images/Delete.gif" alt="" style="cursor: pointer;" onclick="deleterow2(this)" /></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" runat="server" onclick="SaveRecord()" tabindex="9" class="savebutton" />
            <input type="button" id="btnUpdate" value="Update" runat="server" onclick="UpdateRecord()" tabindex="9" style="display: none" class="savebutton" />
            <input type="button" value="Cancel" onclick="clearData()" class="resetbutton" />

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"><b>No of Record</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlnoofrecord" runat="server" Width="80" Font-Bold="true">
                            <asp:ListItem Value="50">50</asp:ListItem>
                            <asp:ListItem Value="100">100</asp:ListItem>
                            <asp:ListItem Value="200">200</asp:ListItem>
                            <asp:ListItem Value="500">500</asp:ListItem>
                            <asp:ListItem Value="1000">1000</asp:ListItem>
                            <asp:ListItem Value="2000">2000</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlSearchState" runat="server" ClientIDMode="Static" class="ddlSearchState chosen-select" onchange="bindSearchCity(this.value);"></asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlSearchCity" runat="server" class="ddlSearchCity chosen-select" ClientIDMode="Static">
                            <asp:ListItem Value="">--Select City--</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtsearchvalue" runat="server" placeholder="Location" />
                    </div>
                    <div class="col-md-2">
                        <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                    </div>
                    <div class="col-md-2">
                        <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                    </div>
                </div>
                 </div>
                <div class="row">
                    <div style="height: 200px; overflow: auto;">
                        <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                            <tr id="triteheader">
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                                <td class="GridViewHeaderStyle">Location Name</td>
                                <td class="GridViewHeaderStyle">Business Zone</td>
                                <td class="GridViewHeaderStyle">State</td>
                                <td class="GridViewHeaderStyle">City</td>
                                <td class="GridViewHeaderStyle">Pincode </td>
                                <td class="GridViewHeaderStyle">Status</td>
                                <td class="GridViewHeaderStyle">IsHocollection</td>
                                <td class="GridViewHeaderStyle">Opening Time</td>
                                <td class="GridViewHeaderStyle">Closing Time</td>
                                <td class="GridViewHeaderStyle">Avg Time</td>
                                <td class="GridViewHeaderStyle">Time Sloat</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
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
                    $(selector).chosen(config[selector]);
                }
                $('.Update').hide();
                $(".timepiker").timepicker({
                    timeFormat: 'H:i',
                    minTime: '00:00:00',
                    maxTime: '23:30:00',
                    interval: 60
                });
                getNoSlot();
                $('#ContentPlaceHolder1_txtPincode').keyup(function (e) {
                    if (/\D/g.test(this.value)) {
                        this.value = this.value.replace(/\D/g, '');
                    }
                });
                jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');

            });
            function checkPicode(eval) {
                if (/\D/g.test(eval.value)) {
                    eval.value = eval.value.replace(/\D/g, '');
                }
            }
            $("#<%=chkIshomeCollection.ClientID %>").change(function () {
            if ($(this).is(":checked")) {
                getNoSlot();
                $('.homecollection').show();
            }
            else {
                $('.homecollection').hide();
            }
        });
        function addfidetail() {
            var $table = $("#tblAreaDetails tbody"),
          lastRow = $table.find("tr:last-child");
            $table.append(lastRow.clone());
            $(".timepiker").timepicker({
                timeFormat: 'H:i',
                minTime: '00:00:00',
                maxTime: '23:30:00',
                interval: 60
            });
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMoreArea').val('');
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMorePincode').val('');
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_OpenTime').val('00:00');
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_CloseTime').val('23:30');
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_ddslot_more').val('15');
            $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_spnMore_NoSlot').text('20');
        }
        function deleterow2(itemid) {
            var table = document.getElementById('tblAreaDetails');
            if ($('#tblAreaDetails tr').length > 2) {
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            }
            else {
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMoreArea').val('');
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMorePincode').val('');
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_OpenTime').val('00:00');
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_CloseTime').val('23:30');
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_ddslot_more').val('15');
                $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_spnMore_NoSlot').text('20');
            }
        }
        function CloneStartTime(eval) {
            $('[id*=txtMore_OpenTime]').val(eval.value);
            getNoSlot_Header();
        }
        function CloneCloseTime(eval) {
            $('[id*=txtMore_CloseTime]').val(eval.value);
            getNoSlot_Header();
        }
        function CloneAvgTime(eval) {
            $('[id*=ddslot_more]').val(eval.value);
            getNoSlot_Header();
        }
        function CloneNewslot(eval) {
            $('[id*=ddNewslot_more]').val(eval.value);
            getNoSlot_Header();
        }
        function checkPicodeHeader(eval) {
            if (/\D/g.test(eval.value)) {
                eval.value = eval.value.replace(/\D/g, '');
            }
            $('[id*=txtMorePincode]').val(eval.value);
        }
        function getNoSlot_Header() {
            var starttime = $('#ContentPlaceHolder1_txtHeader_OpenTime').val() + ":00";
            var endtime = $('#ContentPlaceHolder1_txtHeader_CloseTime').val() + ":00";
            var interval = $('#ContentPlaceHolder1_ddslot_Header').val();
            var startTimeInMin = convertToMin(starttime);
            var endTimeInMin = convertToMin(endtime);
            var timeIntervel = parseInt(endTimeInMin - startTimeInMin) / (parseInt(interval) * 60);
            $('[id*=spnMore_NoSlot]').text(parseInt(timeIntervel));
        }
        function getNoSlot_More(eval) {
            var $row = $(eval).closest('tr');
            var starttime = $row.find('#ContentPlaceHolder1_txtMore_OpenTime').val() + ":00";
            var endtime = $row.find('#ContentPlaceHolder1_txtMore_CloseTime').val() + ":00";
            var interval = $row.find('#ContentPlaceHolder1_ddslot_more').val();
            var startTimeInMin = convertToMin(starttime);
            var endTimeInMin = convertToMin(endtime);
            var timeIntervel = parseInt(endTimeInMin - startTimeInMin) / (parseInt(interval) * 60);
            $row.find('#ContentPlaceHolder1_spnMore_NoSlot').text(parseInt(timeIntervel))
        }
        function getNoSlot() {
            var starttime = $("#<%=txt_OpenTime.ClientID %>").val() + ":00";
            var endtime = $("#<%=txt_ClosingTime.ClientID %>").val() + ":00";
            var interval = $("#<%=ddAvgtime.ClientID %>").val();
            var startTimeInMin = convertToMin(starttime);
            var endTimeInMin = convertToMin(endtime);
            var timeIntervel = parseInt(endTimeInMin - startTimeInMin) / (parseInt(interval) * 60);
            $("#<%=spn_NoSlot.ClientID %>").text("No of slot:" + parseInt(timeIntervel) + "")

        }
        function convertToMin(inputTime) {
            inputTime = inputTime.split(':');
            var hrinseconds = parseInt(inputTime[0]) * 3600;
            var mininseconds = parseInt(inputTime[1]) * 60;
            return parseInt(hrinseconds) + parseInt(mininseconds) + parseInt(inputTime[2])
        }
        function searchitemexcel() {
            serverCall('HomeCollectionLocationMaster.aspx/SearchDataExcel',
                    { searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), SearchState: $('#<%=ddlSearchState.ClientID%>').val(), SearchCity: $('#<%=ddlSearchCity.ClientID%>').val() }, function (result) {
                        ItemData = result;
                        if (ItemData == "false") {
                            showmsg("No Item Found");
                        }
                        else {
                            window.open('../common/ExportToExcel.aspx');
                        }
                    });
            }
            function searchitem() {
                $('#tblitemlist tr').slice(1).remove();
                serverCall('HomeCollectionLocationMaster.aspx/GetData',
                  { searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), SearchState: $('#<%=ddlSearchState.ClientID%>').val(), SearchCity: $('#<%=ddlSearchCity.ClientID%>').val() },
                function (result) {
                    ItemData = jQuery.parseJSON(result);
                    if (ItemData.length == 0) {
                        toast("Info", "No Item Found");
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = [];
                            mydata.push("<tr style='background-color:bisque;'>");
                            mydata.push('<td class="GridViewLabItemStyle"  id="" >'); mydata.push((i + 1)); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdLocationName" >'); mydata.push(ItemData[i].NAME); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdBusinessZone" >'); mydata.push(ItemData[i].BusinessZoneName); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdState" >'); mydata.push(ItemData[i].state); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdCity">'); mydata.push(ItemData[i].City); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdPinCode">'); mydata.push(ItemData[i].PinCode); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].Status); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdHomeCollectionStatus">'); mydata.push(ItemData[i].HomeCollectionStatus); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdOpeningTime">'); mydata.push(ItemData[i].StartTime); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdClosingTime">'); mydata.push(ItemData[i].EndTime); mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdAvgTime">'); mydata.push(ItemData[i].AvgTime); mydata.push('-Min</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdTimeSloat">'); mydata.push(ItemData[i].NoofSlotForApp); mydata.push('-Slot</td>');
                            mydata.push('<td style="display:none;" id="tdAvgTimeUpdate">'); mydata.push(ItemData[i].AvgTime); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdTimeSloatUpdate">'); mydata.push(ItemData[i].NoofSlotForApp); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdLocationid">'); mydata.push(ItemData[i].ID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdBusinessZoneid">'); mydata.push(ItemData[i].BusinessZoneID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdStateid">'); mydata.push(ItemData[i].StateID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdheadquarterid">'); mydata.push(ItemData[i].HeadquarterID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdCityid">'); mydata.push(ItemData[i].CityID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdCityZoneid">'); mydata.push(ItemData[i].ZoneID); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdactive">'); mydata.push(ItemData[i].active); mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdisHomeCollection">'); mydata.push(ItemData[i].isHomeCollection); mydata.push('</td>');
                            mydata.push("</tr>");
                            mydata = mydata.join("");
                            $('#tblitemlist').append(mydata);
                        }
                    }
                });
               }
               function showdetailtoupdate(ctrl) {
                   $("#<%=btnUpdate.ClientID %>").show();
                $("#<%=btnSave.ClientID %>").hide();
                $('.Update').show();
                $('.div_Save').hide();
                var Locationid = $(ctrl).closest("tr").find('#tdLocationid').html();
                var LocationName = $(ctrl).closest("tr").find('#tdLocationName').html();
                var PinCode = $(ctrl).closest("tr").find('#tdPinCode').html();
                var OpeningTime = $(ctrl).closest("tr").find('#tdOpeningTime').html();
                var ClosingTime = $(ctrl).closest("tr").find('#tdClosingTime').html();
                var AvgTime = $(ctrl).closest("tr").find('#tdAvgTimeUpdate').html();
                var TimeSloat = $(ctrl).closest("tr").find('#tdTimeSloatUpdate').html();
                var BusinessZoneid = $(ctrl).closest("tr").find('#tdBusinessZoneid').html();
                var Stateid = $(ctrl).closest("tr").find('#tdStateid').html();
                var headquarterid = $(ctrl).closest("tr").find('#tdheadquarterid').html();
                var Cityid = $(ctrl).closest("tr").find('#tdCityid').html();
                var CityZoneid = $(ctrl).closest("tr").find('#tdCityZoneid').html();
                var IsActive = $(ctrl).closest("tr").find('#tdactive').html();
                var IsHomeCollectionActive = $(ctrl).closest("tr").find('#tdisHomeCollection').html();
                $('#<%=lblLocation.ClientID%>').text(Locationid);
                $('#<%=txt_Location.ClientID%>').val(LocationName);
                $('#<%=ddlZone.ClientID%>').val(BusinessZoneid);
                jQuery('#ddlZone').trigger('chosen:updated');
                bindState(Stateid);
               // $('#<%=ddlState.ClientID%>').val(Stateid);
            bindHeadquarter(Stateid);
            $('#<%=ddlHeadquarter.ClientID%>').val(headquarterid);
                   bindCity(Stateid, Cityid);
           // $('#<%=ddlCity.ClientID%>').val(Cityid);
           // bindZone();
           // $('#<%=ddlCityZone.ClientID%>').val(CityZoneid);
            jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
            $('#<%=txtPincode.ClientID%>').val(PinCode);
            $('#<%=txt_OpenTime.ClientID%>').val(OpeningTime);
                $('#<%=txt_ClosingTime.ClientID%>').val(ClosingTime);
                $('#<%=ddAvgtime.ClientID%>').val(TimeSloat);
                if (IsActive == '1') {
                    $('#<%=chkIsActive.ClientID %>').prop('checked', true)
            }
            else {
                $('#<%=chkIsActive.ClientID %>').prop('checked', false)
            }
            if (IsHomeCollectionActive == '1') {
                $('#<%=chkIshomeCollection.ClientID %>').prop('checked', true)
               $('#<%= txt_OpenTime.ClientID%>').val(OpeningTime);
               $('#<%= txt_ClosingTime.ClientID%>').val(ClosingTime);
               $('#<%= ddAvgtime.ClientID%>').val(AvgTime);
               $('#<%= ddlTimeSloat.ClientID%>').val(TimeSloat);
               $('.homecollection').show();
           }
           else {
               $('#<%=chkIshomeCollection.ClientID %>').prop('checked', false)
               $('#<%= txt_OpenTime.ClientID%>').val("00:00");
               $('#<%= txt_ClosingTime.ClientID%>').val("23:30");
               $('#<%= ddAvgtime.ClientID%>').val("15");
               $('#<%= ddlTimeSloat.ClientID%>').val("2");
               $('.homecollection').hide();
           }
       }
            function bindState(Stateid) {
           var ddlState;
           var BusinessZoneID;
           ddlState = $("#<%=ddlState.ClientID %>");
            $("#<%=ddlState.ClientID %> option").remove();
            BusinessZoneID = $("#<%=ddlZone.ClientID %>").val();
            $("#<%=ddlHeadquarter.ClientID %> option").remove();
            $("#<%=ddlCity.ClientID %> option").remove();
            $("#<%=ddlCityZone.ClientID %> option").remove();
            ddlState.append($("<option></option>").val("").html("--Select---"));
            serverCall('HomeCollectionLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID },
               function (result) {
                   StateData = jQuery.parseJSON(result);
                   if (StateData.length > 0) {
                       for (i = 0; i < StateData.length; i++) {
                           ddlState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                       }
                   }
                   if (Stateid != -1)
                       $("#<%=ddlState.ClientID %>").val(Stateid);
                   jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
               });

        }

        function bindHeadquarter(StateId) {
            var ddlHeadquarter = "";
            ddlHeadquarter = $("#<%=ddlHeadquarter.ClientID %>");
            $("#<%=ddlHeadquarter.ClientID %> option").remove();
            ddlHeadquarter.append($("<option></option>").val("").html("--Select---"));
            $("#<%=ddlCity.ClientID %> option").remove();
            $("#<%=ddlCityZone.ClientID %> option").remove();
            ddlCity.append($("<option></option>").val("").html("--Select---"));
            serverCall('HomeCollectionLocationMaster.aspx/bindHeadquarter', { StateID: StateId },
               function (result) {
                   HeadquarterData = jQuery.parseJSON(result);
                   if (HeadquarterData.length > 0) {
                       for (i = 0; i < HeadquarterData.length; i++) {
                           ddlHeadquarter.append($("<option></option>").val(HeadquarterData[i].ID).html(HeadquarterData[i].headquarter));
                       }
                   }
                   jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
               });
        }
        function bindCity(HeadquarterId,CityID) {
            var ddlCity = "";
            ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            ddlCity.append($("<option></option>").val("").html("--Select---"));
            $("#<%=ddlCityZone.ClientID %> option").remove();
            serverCall('HomeCollectionLocationMaster.aspx/bindCity', { HeadquarterId: HeadquarterId },
               function (result) {
                   CityData = jQuery.parseJSON(result);
                   if (CityData.length > 0) {
                       for (i = 0; i < CityData.length; i++) {
                           ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                       }
                   }
                   if (CityID != -1)
                       $('#<%=ddlCity.ClientID%>').val(CityID);
                   jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
               });
        }
        function bindSearchCity(StateId) {
           
            var ddlSearchCity = $("#<%=ddlSearchCity.ClientID %>");
            $("#<%=ddlSearchCity.ClientID %> option").remove();
            jQuery("#ddlSearchCity").trigger('chosen:updated');
            ddlSearchCity.append($("<option></option>").val("").html("--Select City---"));
            jQuery("#ddlSearchCity").trigger('chosen:updated');
            serverCall('HomeCollectionLocationMaster.aspx/bindSearchCity', { StateId: StateId },
               function (result) {
                   CityData = jQuery.parseJSON(result);
                   if (CityData.length > 0) {
                       for (i = 0; i < CityData.length; i++) {

                           ddlSearchCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                       }
                       jQuery('#ddlSearchCity').trigger('chosen:updated');
                   }
               });
        }
        function bindZone() {
            var CityID = $("#<%=ddlCity.ClientID %> option:selected").val();
            var StateID = $("#<%=ddlState.ClientID %> option:selected").val();
            var ddlZone = $("#<%=ddlCityZone.ClientID %>");
            $("#<%=ddlCityZone.ClientID %> option").remove();
            ddlZone.append($("<option></option>").val("").html("--Select---"));
            serverCall('HomeCollectionLocationMaster.aspx/bindZone', { StateID: StateID, CityID: CityID },
               function (result) {
                   ZoneData = jQuery.parseJSON(result);
                   if (ZoneData.length > 0) {
                       for (i = 0; i < ZoneData.length; i++) {
                           ddlZone.append($("<option></option>").val(ZoneData[i].ZoneID).html(ZoneData[i].Zone));
                       }
                   }
                   jQuery('#ddlCityZone').trigger('chosen:updated');
               });
        }
        function AriaDetails() {
            var dataAriaDetails = new Array();
            var rowNum = 0;
            var checkValidation = 0;
            var contents = {},
            duplicates = false;
            $('#tblAreaDetails tr').each(function () {
                if (rowNum != 0) {
                    var objAria = new Object();
                    var homeColectionCheck = '0';
                    var IsactiveCheck = '0';
                    objAria.BusinessZoneID = $('#<%= ddlZone.ClientID%>').val();
                        objAria.StateID = $("#<%=ddlState.ClientID %> option:selected").val();
                        objAria.HeadquarterID = '';
                        objAria.CityID = $("#<%=ddlCity.ClientID %> option:selected").val();
                    objAria.CityZoneId = '';
                    if ($('#<%= chkIshomeCollection.ClientID%>').is(':checked')) {
                        homeColectionCheck = '1';
                    }
                    if ($('#<%= chkIsActive.ClientID%>').is(':checked')) {
                            IsactiveCheck = '1';
                        }
                        objAria.IsHomeColection = homeColectionCheck;
                        objAria.IsActive = IsactiveCheck;

                        if ($.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").val()) == "") {
                            toast("Error", "Please Entre Location Name");
                            $(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").focus();
                            checkValidation = "1";
                            return false;
                        }
                        else {
                            objAria.AreaName = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").val());
                        }
                        var tdContent = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").val());
                        if (contents[tdContent]) {
                            // duplicates = true;
                            // toast("Error",'Aria name is already exists');
                            //$(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").focus()
                            // checkValidation = "1";
                            // return false;
                        }
                        contents[tdContent] = true;
                        if ($.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMorePincode").val()) == "") {
                            toast("Error", "Please Entre Pincode");
                            $(this).closest("tr").find("#ContentPlaceHolder1_txtMorePincode").focus();
                            checkValidation = "1";
                            return false;
                        }
                        else {
                            if (isNaN($.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMorePincode").val()))) {
                                toast("Error", "Please Entre Valid Pincode");
                                $(this).closest("tr").find("#ContentPlaceHolder1_txtMorePincode").focus();
                                checkValidation = "1";
                                return false;
                            }
                            else {
                                objAria.Pincode = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMorePincode").val());
                            }
                        }
                        if ($.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_OpenTime").val()) == "") {
                            toast("Error", "Please Select Start time");
                            $(this).closest("tr").find("#ContentPlaceHolder1_txtMore_OpenTime").focus();
                            checkValidation = "1";
                            return false;
                        }
                        else {
                            objAria.OpenTime = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_OpenTime").val());
                        }

                        if ($.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_CloseTime").val()) == "") {
                            toast("Error", "Please Select Close time");
                            $(this).closest("tr").find("#ContentPlaceHolder1_txtMore_CloseTime").focus();
                            checkValidation = "1";
                            return false;
                        }
                        else {
                            objAria.CloseTime = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_CloseTime").val());
                        }
                        var st = '';
                        var et = '';
                        var AvgTime = '0';
                        AvgTime = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_ddslot_more").val());
                        st = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_OpenTime").val());
                        et = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMore_CloseTime").val());
                        if (st >= et) {
                            toast("Error", 'Closing time always greater then Opening time');
                            $(this).closest("tr").find("#ContentPlaceHolder1_txtMore_CloseTime").focus();
                            checkValidation = "1";
                            return false;
                        }
                        objAria.AvgTime = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_ddslot_more").val());
                        objAria.NoofSlotForApp = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_ddNewslot_more").val());
                        dataAriaDetails.push(objAria);
                    }
                    rowNum++;
                });
                if (checkValidation == "1") {
                    return "0";
                }
                else {
                    return dataAriaDetails;
                }
            }
            function SaveRecord() {
                var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;
            // if ($("#<%=txt_Location.ClientID %>").val() == "") {
            //      toast("Error","Please Entre Location Name");
            //      $("#<%=txt_Location.ClientID %>").focus();
            //      return;
            //  }
            if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null || $("#<%=ddlZone.ClientID %>").val() == '') {
                toast("Error", "Please Select Zone");
                $("#<%=ddlZone.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null || $("#<%=ddlState.ClientID %>").val() == '') {
                toast("Error", "Please Select State");
                $("#<%=ddlState.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null || $("#<%=ddlCity.ClientID %>").val() == '') {
                toast("Error", "Please Select City");
                $("#<%=ddlCity.ClientID %>").focus();
                return;
            }
            var AriaDetailsData = AriaDetails();
            if (AriaDetailsData == "0") {
                return false;
            }
            $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            serverCall('HomeCollectionLocationMaster.aspx/SaveLocality', { AriaDetailsData: AriaDetailsData },
               function (result) {
                   DataResult = result;
                   if (DataResult == '1') {
                       toast("Success", 'Record Saved');
                       clearData();
                   }
                   else if (DataResult == '0') {
                       toast("Error", 'Record Not Saved');
                   }
                   else {
                       toast("Error", result + ' area is already exists in this city');
                       $('#tblAreaDetails tr').each(function () {
                           var tdContent = $.trim($(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").val());
                           if (tdContent == DataResult) {
                               $(this).closest("tr").find("#ContentPlaceHolder1_txtMoreArea").focus();
                           }
                       });
                   }
               });
        }
            function UpdateRecord() {
                var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;

                if ($("#<%=txt_Location.ClientID %>").val() == "") {
                    toast("Error", "Please Entre Location Name");
                    $("#<%=txt_Location.ClientID %>").focus();
                    return;
                }
                if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null || $("#<%=ddlZone.ClientID %>").val() == '') {
                    toast("Error", "Please Select Zone");
                    $("#<%=ddlZone.ClientID %>").focus();
                    return;
                }
                if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null || $("#<%=ddlState.ClientID %>").val() == '') {
                    toast("Error", "Please Select State");
                    $("#<%=ddlState.ClientID %>").focus();
                    return;
                }
                if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null || $("#<%=ddlCity.ClientID %>").val() == '') {
                    toast("Error", "Please Select City");
                    $("#<%=ddlCity.ClientID %>").focus();
                    return;
                }
                var st = '';
                var et = '';
                var isHomeCollection = '0';
                var AvgTime = '0';
                var TimeSlot = '0';
                if ($('#<%= chkIshomeCollection.ClientID%>').is(':checked')) {
                    if ($("#<%=txtPincode.ClientID %>").val() == "") {
                        toast("Error", "Please Entre Pincode");
                        $("#<%=txtPincode.ClientID %>").focus();
                        return;
                    }
                    AvgTime = $("#<%=ddAvgtime.ClientID %>").val();
                    TimeSlot = $("#<%=ddlTimeSloat.ClientID %>").val();
                    isHomeCollection = '1';
                    st = $("#<%=txt_OpenTime.ClientID %>").val(); // start time Format: '9:00 PM'
                    et = $("#<%=txt_ClosingTime.ClientID %>").val(); // end time   Format: '11:00 AM' 
                    if (st == "") {
                        toast("Error", 'Please entre opening time');
                        return false;
                    }
                    if (et == "") {
                        toast("Error", 'Please entre closing time');
                        return false;
                    }
                    if (st >= et) {
                        toast("Error", 'Closing time always greater then Opening time');
                        $("#<%=txt_ClosingTime.ClientID %>").focus();
                        return false;
                    }
                }
                var LocationId = $("#<%=lblLocation.ClientID %>").text();
                $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
                serverCall('HomeCollectionLocationMaster.aspx/UpdateRecord', { LocalityId: LocationId, Locality: $('#<%= txt_Location.ClientID%>').val(), BusinessZoneID: $('#<%= ddlZone.ClientID%>').val(), StateID: $("#<%=ddlState.ClientID %> option:selected").val(), HeadquarterID: "", CityID: $("#<%=ddlCity.ClientID %> option:selected").val(), CityZoneId: "", Pincode: $('#<%= txtPincode.ClientID%>').val(), IsActive: IsActive, startTime: st, endTime: et, AvgTime: AvgTime, isHomeCollection: isHomeCollection, TimeSlot: TimeSlot },
            function (result) {
                DataResult = jQuery.parseJSON(result);
                if (DataResult == '1') {
                    toast("Success", 'Record Updated');
                    clearData();
                    searchitem();
                }
                else if (DataResult == '2') {
                    toast("Error", 'Location is already exists in this city.');
                    $('#<%= txt_Location.ClientID%>').focus();
                }
                else {
                    toast("Error", 'Record Not Updat');
                }
            });
            }
function GetData() {
    serverCall('RouteMaster.aspx/GetData', {},
           function (result) {
               PatientData = jQuery.parseJSON(result);
               var output = $('#tb_Route').parseTemplate(PatientData);
               $('#div_Route').html(output);
           });


}
function ShowDetail(e) {
    $("#<%=btnUpdate.ClientID %>").show();
    $("#<%=btnSave.ClientID %>").hide();
    $("#<%=lblLocation.ClientID %>").text($(e).closest('tr').find('#td_Routeid').text());
    $("#<%=ddlZone.ClientID %>").val($(e).closest('tr').find('#td_BusinessZoneID').text());
    bindState($(e).closest('tr').find('#td_BusinessZoneID').text());
    $("#<%=ddlState.ClientID %>").val($(e).closest('tr').find('#td_StateId').text());
        bindCity($(e).closest('tr').find('#td_StateId').text());
        $("#<%=ddlCity.ClientID %>").val($(e).closest('tr').find('#td_CityId').text());
            $("#<%=txt_Location.ClientID %>").val($(e).closest('tr').find('#td_Route').text());
    if ($(e).closest('tr').find('#td_Status').text() == "1") {
        $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
        }
        else {
            $('#<%=chkIsActive.ClientID %>').prop('checked', false);
        }
        jQuery('#ddlZone,#ddlState,#ddlCity').trigger('chosen:updated');
    }
    function clearData() {
        $('.Update').hide();
        $('.div_Save').show();
        //  $("#tblAreaDetails").find("tr:gt(0)").remove();
        $("#tblAreaDetails").find('.tr_remove:gt(0)').remove();
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMoreArea').val('');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMorePincode').val('');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_OpenTime').val('00:00');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_txtMore_CloseTime').val('23:30');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_ddslot_more').val('15');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_spnMore_NoSlot').text('20');
        $('#tblAreaDetails tr:last').find('#ContentPlaceHolder1_ddNewslot_more').val('2');
        $("#<%=lblLocation.ClientID %>").text('');
            $("#<%=txt_Location.ClientID %>").val('');
            $("#<%=txtPincode.ClientID %>").val('');
            $("#<%=btnUpdate.ClientID %>").hide();
            $("#<%=btnSave.ClientID %>").show();
            $("#<%=ddlZone.ClientID %>").val(0);
            $("#<%=ddlState.ClientID %> option").remove();
            $("#<%=ddlHeadquarter.ClientID %> option").remove();
            $("#<%=ddlCity.ClientID %> option").remove();
            $("#<%=ddlCityZone.ClientID %> option").remove();
            $('#<%=chkIshomeCollection.ClientID %>').prop('checked', 'checked');
            $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
            $("#<%=txt_OpenTime.ClientID %>").val('00:00');
            $("#<%=txt_ClosingTime.ClientID %>").val('23:30');
            $("#<%=ddAvgtime.ClientID %>").val('15');
            $("#<%=ddNewslot_Header.ClientID %>").val('3');
            $("#<%=ddlTimeSloat.ClientID %>").val('2');
            $('.homecollection').show();
            jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
            getNoSlot();
        }
        </script>
</asp:Content>






