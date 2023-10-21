<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AreaLocationMaster.aspx.cs" Inherits="Design_HomeCollection_AreaLocationMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />

<link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>  

<style type="text/css">
    .multiselect{width:100%;}
    

</style>
  <div id="Pbody_box_inventory" >
      <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center; ">   
            <b>Area Master</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
</div>
      <div class="POuter_Box_Inventory" >
                    <div class="row">
                      <div class="col-md-3">
                        <label class="pull-left"><b>Location</b></label>
			            <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-3">
                          <asp:TextBox ID="txt_Location" runat="server" ></asp:TextBox>
                           <asp:Label ID="lblLocation" runat="server" style="display:none"></asp:Label>
                      </div>
                        <div class="col-md-2">
                                <asp:TextBox ID="txtPincode" runat="server" MaxLength="6" placeholder="Pincode" ></asp:TextBox>
                        </div>
                      <div class="col-md-3">
                            <label class="pull-left"><b>Business Zone</b></label>
			                <b class="pull-right">:</b>
                        </div>
                      <div class="col-md-4">
                          <asp:DropDownList ID="ddlZone" runat="server" class="ddlZone chosen-select" ClientIDMode="Static" onchange="bindState()"></asp:DropDownList>
                      </div>
                       <div class="col-md-2">
                          <label class="pull-left"><b>State</b></label>
			                <b class="pull-right">:</b>
                       </div> 
                      <div class="col-md-3">
                          <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static" class="ddlState chosen-select" onchange="bindHeadquarter(this.value);">
                          </asp:DropDownList>
                      </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkIsActive" runat="server" Text="IsActive" Checked="true"  style="font-weight:bold" /> 
                        </div>
                      </div>
                    <div class="row">
                        <div class="col-md-3" >
                            <label class="pull-left"><b>Headquarter</b></label>
			                <b class="pull-right">:</b>
                        </div>
                      <div class="col-md-5">
                          <asp:DropDownList ID="ddlHeadquarter" runat="server" class="ddlHeadquarter chosen-select"  onchange="bindCity(this.value);" ClientIDMode="Static" ></asp:DropDownList>
                      </div>
                        <div class="col-md-3">
                             <label class="pull-left"><b>City</b></label>
			                 <b class="pull-right">:</b>
                        </div>
                      <div class="col-md-4">
                          <asp:DropDownList ID="ddlCity" runat="server" class="ddlCity chosen-select" onchange="bindZone();" ClientIDMode="Static" ></asp:DropDownList>
                      </div>
                     <div class="col-md-2">
                         <label class="pull-left"><b>City Zone</b></label>
			                 <b class="pull-right">:</b>
                     </div>
                      <div class="col-md-3">
                          <asp:DropDownList ID="ddlCityZone" runat="server" class="ddlCity chosen-select" ClientIDMode="Static" ></asp:DropDownList>
                      </div>
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkIshomeCollection" runat="server" Text="IsHomeCollection"  Checked="true"  style="font-weight:bold" /> 
                        </div>
                      </div>
                    <div class=" row homecollection">
                        <div class="col-md-3">
                            <label class="pull-left"><b>Opening Time</b></label>
			                 <b class="pull-right">:</b>
                        </div>
                     <div class="col-md-5">
                        <input type="text" id="txt_OpenTime"  runat="server"  onchange="getNoSlot();" name="bookingcutoff" onkeypress="return false;"  class="bookingcutoff timepiker" value="08:00"  />
                     </div>
                      <div class="col-md-3">
                          <label class="pull-left"><b>Closing Time</b></label>
			                 <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-4"> 
                          <input type="text"  id="txt_ClosingTime" runat="server" onchange="getNoSlot();" name="bookingcutoff" onkeypress="return false;"   class="bookingcutoff timepiker" value="18:00"  />
                      </div>
                      <div class="col-md-2">
                          <label class="pull-left"><b>Time Slot</b></label>
			                 <b class="pull-right">:</b>
                      </div>
                      <div class="col-md-3">
                         <asp:DropDownList ID="ddTimeSloat" onchange="getNoSlot();" runat="server">
                            <asp:ListItem Value="15">15-Min</asp:ListItem>
                            <asp:ListItem Selected="True" Value="30">30-Min</asp:ListItem>
                            <asp:ListItem Value="45">45-Min</asp:ListItem>
                            <asp:ListItem Value="60">60-Min</asp:ListItem>
                        </asp:DropDownList>
                      </div>
                        <div class="col-md-4">
                            <b><span style="color:red;" runat="server" id="spn_NoSlot">No of slot:0</span></b>  
                        </div>
                      </div>
              </div> 
          <div class="POuter_Box_Inventory" style="text-align:center;">
                   <input type="button" id="btnSave" value="Save" runat="server" onclick="SaveRecord()" tabindex="9" class="savebutton" />
                   <input type="button" id="btnUpdate" value="Update" runat="server" onclick="UpdateRecord()" tabindex="9" style="display:none" class="savebutton" />
                   <input type="button" value="Cancel" onclick="clearData()" class="resetbutton" />
          </div>
         <div class="POuter_Box_Inventory">
            <div class="content">
                <div class="Purchaseheader">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left"><b>No of Record</b></label>
			                    <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                                    <asp:ListItem Value="50">50</asp:ListItem>
                                    <asp:ListItem Value="100">100</asp:ListItem>
                                    <asp:ListItem Value="200">200</asp:ListItem>
                                    <asp:ListItem Value="500">500</asp:ListItem>
                                    <asp:ListItem Value="1000">1000</asp:ListItem>
                                    <asp:ListItem Value="2000">2000</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                           
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSearchState" runat="server" ClientIDMode="Static" class="ddlSearchState chosen-select" onchange="bindSearchCity(this.value);"></asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSearchCity" runat="server" class="ddlSearchCity chosen-select" ClientIDMode="Static" >
                                    <asp:ListItem Value="">--Select City--</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
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
                <div style="height: 450px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            
                            <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                            <td class="GridViewHeaderStyle">Location Name</td>
                            <td class="GridViewHeaderStyle">Business Zone</td>
                            <td class="GridViewHeaderStyle">State</td>
                            <td class="GridViewHeaderStyle">Headquarter</td>
                            <td class="GridViewHeaderStyle">City</td>
                            <td class="GridViewHeaderStyle">City Zone</td>
                            <td class="GridViewHeaderStyle">Pincode </td>
                           <td class="GridViewHeaderStyle">Status</td>
                            <td class="GridViewHeaderStyle">IsHocollection</td>
                             
                             <td class="GridViewHeaderStyle">Opening Time</td>
                            <td class="GridViewHeaderStyle">Closing Time</td>
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


            $(".timepiker").timepicker({
                timeFormat: 'H:i',
                minTime: '08:00:00',
                maxTime: '18:00:00',
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



       
        $("#<%=chkIshomeCollection.ClientID %>").change(function () {
            if ($(this).is(":checked")) {
                getNoSlot();
                $('.homecollection').show();
            }
            else {
                $('.homecollection').hide();
            }
        });
        function getNoSlot() {
            var starttime = $("#<%=txt_OpenTime.ClientID %>").val() + ":00"; 
            var endtime = $("#<%=txt_ClosingTime.ClientID %>").val() + ":00"; 
            var interval = $("#<%=ddTimeSloat.ClientID %>").val();
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
            //$.blockUI();
            serverCall('AreaLocationMaster.aspx/SearchDataExcel',
                { searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(),
                    NoofRecord:$('#<%=ddlnoofrecord.ClientID%>').val(),
                    SearchState:$('#<%=ddlSearchState.ClientID%>').val(),
                    SearchCity:$('#<%=ddlSearchCity.ClientID%>').val()},
                    function (result) {
                        ItemData = result;
                        if (ItemData == "false") {
                            showmsg("No Item Found");
                            //$.unblockUI();
                        }
                        else {
                            window.open('../common/ExportToExcel.aspx');
                            //$.unblockUI();
                        }
                    })
        }



        function searchitem() {
            $('#tblitemlist tr').slice(1).remove();
            serverCall('AreaLocationMaster.aspx/GetData',
                { searchvalue: $('#<%=txtsearchvalue.ClientID%>').val() , NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val() , SearchState: $('#<%=ddlSearchState.ClientID%>').val(), SearchCity: $('#<%=ddlSearchCity.ClientID%>').val() },
                function (result) {
                    ItemData = jQuery.parseJSON(result);
                    if (ItemData.length == 0) {
                        toast("Error","No Item Found","");
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = [];
                            mydata.push("<tr style='background-color:bisque;'>");
                            mydata.push('<td class="GridViewLabItemStyle"  id="" >');mydata.push(i + 1);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdLocationName" >');mydata.push(ItemData[i].NAME);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdBusinessZone" >');mydata.push(ItemData[i].BusinessZoneName);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle"  id="tdState" >');mydata.push(ItemData[i].state);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdheadquarter">');mydata.push(ItemData[i].headquarter);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdCity">');mydata.push(ItemData[i].City);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdCityZone">');mydata.push(ItemData[i].Zone);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdPinCode">');mydata.push(ItemData[i].PinCode);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">');mydata.push(ItemData[i].Status);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdHomeCollectionStatus">');mydata.push(ItemData[i].HomeCollectionStatus);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdOpeningTime">');mydata.push(ItemData[i].StartTime);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdClosingTime">');mydata.push(ItemData[i].EndTime);mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" id="tdTimeSloat">'); mydata.push(ItemData[i].AvgTime);mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdLocationid">');mydata.push(ItemData[i].ID);mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdBusinessZoneid">');mydata.push(ItemData[i].BusinessZoneID);mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdStateid">');mydata.push( ItemData[i].StateID );mydata.push( '</td>');
                            mydata.push( '<td style="display:none;" id="tdheadquarterid">');mydata.push( ItemData[i].HeadquarterID );mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdCityid">');mydata.push(ItemData[i].CityID);mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdCityZoneid">');mydata.push(ItemData[i].ZoneID);mydata.push('</td>');
                            mydata.push( '<td style="display:none;" id="tdactive">');mydata.push(ItemData[i].active);mydata.push('</td>');
                            mydata.push('<td style="display:none;" id="tdisHomeCollection">'); mydata.push(ItemData[i].isHomeCollection);mydata.push('</td>');


                            mydata.push("</tr>");
                            mydata = mydata.join("");
                            $('#tblitemlist').append(mydata);
                        }
                        
                    }
                })
           
         }
        function showdetailtoupdate(ctrl) {
            $("#<%=btnUpdate.ClientID %>").show();
            $("#<%=btnSave.ClientID %>").hide();
            var Locationid = $(ctrl).closest("tr").find('#tdLocationid').html();
            var LocationName = $(ctrl).closest("tr").find('#tdLocationName').html();
            var PinCode = $(ctrl).closest("tr").find('#tdPinCode').html();
            var OpeningTime = $(ctrl).closest("tr").find('#tdOpeningTime').html();
            var ClosingTime = $(ctrl).closest("tr").find('#tdClosingTime').html();
            var TimeSloat = $(ctrl).closest("tr").find('#tdTimeSloat').html();
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
            /////////////////////////////////
            //tried to make an async call
            //var _temp = [];
            //_temp = [];
            //_temp.push(function (CurrencyData) {
            //    bindState()
            //        $.when.apply(null, _temp).done(function () {
            //            $('#<%=ddlState.ClientID%>').val(Stateid);
            //            jQuery('#ddlState').trigger('chosen:updated');
            //            callback(true);
            //        })
            //});
            
                bindState()
            setTimeout(function () {
                $('#<%=ddlState.ClientID%>').val(Stateid);
                jQuery('#ddlState').trigger('chosen:updated');
            }, 2000)
            
            setTimeout(function () {
                bindHeadquarter(Stateid);
                
            }, 3000)
            setTimeout(function () {
                $('#<%=ddlHeadquarter.ClientID%>').val(headquarterid);
                jQuery('#ddlHeadquarter').trigger('chosen:updated');

            }, 4000)
            setTimeout(function () {
                bindCity(headquarterid);
            }, 5000)
            
            setTimeout(function () {
                $('#<%=ddlCity.ClientID%>').val(Cityid);
                jQuery('#ddlCity').trigger('chosen:updated');
            }, 6000)
            setTimeout(function () {
                bindZone();
            }, 7000)
            setTimeout(function () {
                $('#<%=ddlCityZone.ClientID%>').val(CityZoneid);
                jQuery('#ddlCityZone').trigger('chosen:updated');
            }, 8000)
            
            
            jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
            $('#<%=txtPincode.ClientID%>').val(PinCode);
            $('#<%=txt_OpenTime.ClientID%>').val(OpeningTime);
            $('#<%=txt_ClosingTime.ClientID%>').val(ClosingTime);
            $('#<%=ddTimeSloat.ClientID%>').val(TimeSloat);          
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
                $('#<%= ddTimeSloat.ClientID%>').val(TimeSloat);
                $('.homecollection').show();
            }
            else {
                    $('#<%=chkIshomeCollection.ClientID %>').prop('checked', false)
                    $('#<%= txt_OpenTime.ClientID%>').val("08:00");
                    $('#<%= txt_ClosingTime.ClientID%>').val("18:00");
                    $('#<%= ddTimeSloat.ClientID%>').val("30");
                    $('.homecollection').hide();
                        }
                       
           }
        function bindState() {

            var ddlState;
            var BusinessZoneID;

            ddlState = $("#<%=ddlState.ClientID %>");
            $("#<%=ddlState.ClientID %> option").remove();
            BusinessZoneID = $("#<%=ddlZone.ClientID %>").val();
            $("#<%=ddlHeadquarter.ClientID %> option").remove();
            $("#<%=ddlCity.ClientID %> option").remove();
            $("#<%=ddlCityZone.ClientID %> option").remove();
            serverCall('AreaLocationMaster.aspx/bindState',
                { BusinessZoneID:BusinessZoneID},
                function (result) {
                    StateData = jQuery.parseJSON(result);
                    if (StateData.length > 0) {
                        ddlState.bindDropDown({defaultValue: '--Select---',data: JSON.parse(result),valueField: 'ID',textField: 'State',isSearchAble: true});
                    }
                    jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');

                })
        }

        function bindHeadquarter(StateId) {
            var ddlHeadquarter = "";

            ddlHeadquarter = $("#<%=ddlHeadquarter.ClientID %>");

            $("#<%=ddlHeadquarter.ClientID %> option").remove();
            //ddlHeadquarter.append($("<option></option>").val("").html("--Select---"));
            $("#<%=ddlCity.ClientID %> option").remove();
            $("#<%=ddlCityZone.ClientID %> option").remove();

              ddlCity.append($("<option></option>").val("").html("--Select---"));

              serverCall('AreaLocationMaster.aspx/bindHeadquarter',
                  { StateID: StateId },
                  function (result) {
                      HeadquarterData = jQuery.parseJSON(result);
                      if (HeadquarterData.length > 0) {
                          ddlHeadquarter.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'ID', textField: 'headquarter', isSearchAble: true });
                          //for (i = 0; i < HeadquarterData.length; i++) {
                          //    ddlHeadquarter.append($("<option></option>").val(HeadquarterData[i].ID).html(HeadquarterData[i].headquarter));
                          //}
                      }
                      jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
                  })
              
          }



        function bindCity(HeadquarterId) {
            var ddlCity = "";

            ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            //ddlCity.append($("<option></option>").val("").html("--Select---"));
            $("#<%=ddlCityZone.ClientID %> option").remove();

            serverCall('AreaLocationMaster.aspx/bindCity',
                { HeadquarterID: HeadquarterId  },
                function (result) {
                    CityData = jQuery.parseJSON(result);
                    if (CityData.length > 0) {
                        ddlCity.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                        //for (i = 0; i < CityData.length; i++) {
                        //    ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                        //}
                    }
                    jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
                })
        }

        function bindSearchCity(StateId) {
            var ddlSearchCity = "";

            ddlSearchCity = $("#<%=ddlSearchCity.ClientID %>");
             $("#<%=ddlSearchCity.ClientID %> option").remove();
             
            //ddlSearchCity.append($("<option></option>").val("").html("--Select City---"));
            serverCall('AreaLocationMaster.aspx/bindSearchCity',
                {StateId:StateId},
                function(result){
                    CityData = jQuery.parseJSON(result);
                    if (CityData.length > 0) {
                        ddlSearchCity.bindDropDown({ defaultValue: '--Select City---', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                        jQuery('#ddlSearchCity').trigger('chosen:updated');
                    }
                })
             
         }


        function bindZone() {
                var CityID = $("#<%=ddlCity.ClientID %> option:selected").val();
                var StateID = $("#<%=ddlState.ClientID %> option:selected").val();
                var ddlZone = $("#<%=ddlCityZone.ClientID %>");
                $("#<%=ddlCityZone.ClientID %> option").remove();
            
                serverCall('AreaLocationMaster.aspx/bindZone',
                { StateID: StateID, CityID: CityID },
                function (result) {
                    ZoneData = jQuery.parseJSON(result);
                    if (ZoneData.length > 0) {
                        ddlZone.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'ZoneID', textField: 'Zone', isSearchAble: true });
                        //for (i = 0; i < ZoneData.length; i++) {
                        //    ddlZone.append($("<option></option>").val(ZoneData[i].ZoneID).html(ZoneData[i].Zone));
                        //}
                    }
                    jQuery('#ddlCityZone').trigger('chosen:updated');


                })
            
            
        }


        function SaveRecord() {
            var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;
            if ($("#<%=txt_Location.ClientID %>").val() == "") {
                toast("Error","Please Entre Location Name","");
                $("#<%=txt_Location.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null || $("#<%=ddlZone.ClientID %>").val() == '') {
                toast("Error","Please Select Zone","");
                $("#<%=ddlZone.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null || $("#<%=ddlState.ClientID %>").val() == '') {
                toast("Error","Please Select State","");
                $("#<%=ddlState.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlHeadquarter.ClientID %>").val() == "0" || $("#<%=ddlHeadquarter.ClientID %>").val() == null || $("#<%=ddlHeadquarter.ClientID %>").val() == '') {
                toast("Error","Please Select Headquarter","");
                $("#<%=ddlHeadquarter.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null || $("#<%=ddlCity.ClientID %>").val() == '') {
                toast("Error","Please Select City","");
                $("#<%=ddlCity.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlCityZone.ClientID %>").val() == "0" || $("#<%=ddlCityZone.ClientID %>").val() == null || $("#<%=ddlCityZone.ClientID %>").val() == '') {
                toast("Error","Please Select City Zone","");
                $("#<%=ddlCityZone.ClientID %>").focus();
                return;
            }
            var st = '';
            var et = '';
            var isHomeCollection = '0';
            var AvgTime = '0';
            if ($('#<%= chkIshomeCollection.ClientID%>').is(':checked')) {
                if ($("#<%=txtPincode.ClientID %>").val() == "") {
                    toast("Error","Please Entre Pincode","");
                    $("#<%=txtPincode.ClientID %>").focus();
                return;
            }
                 AvgTime = $("#<%=ddTimeSloat.ClientID %>").val();
                 isHomeCollection = '1';
                 st = $("#<%=txt_OpenTime.ClientID %>").val(); // start time Format: '9:00 PM'
                 et = $("#<%=txt_ClosingTime.ClientID %>").val(); // end time   Format: '11:00 AM' 
                 if (st == "") {
                     toast("Error", 'Please entre opening time',"");
                     return false;
                 }
                 if (et == "") {
                     toast("Error", 'Please entre closing time',"");
                     return false;
                 }
                 if (st > et) {
                     toast("Error", 'Closing time always greater then Opening time',"");
                     $("#<%=txt_ClosingTime.ClientID %>").focus();

                    return false;
                }
            }
            $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            serverCall('AreaLocationMaster.aspx/SaveLocality',
                { Locality:$('#<%= txt_Location.ClientID%>').val() ,BusinessZoneID: $('#<%= ddlZone.ClientID%>').val() ,StateID: $("#<%=ddlState.ClientID %> option:selected").val() ,HeadquarterID: $("#<%=ddlHeadquarter.ClientID %> option:selected").val(),CityID:$("#<%=ddlCity.ClientID %> option:selected").val() ,CityZoneId: $('#<%= ddlCityZone.ClientID%>').val() ,Pincode:$('#<%= txtPincode.ClientID%>').val() ,IsActive: IsActive ,startTime: st ,endTime: et ,AvgTime:AvgTime ,isHomeCollection:isHomeCollection },
                function (result) {
                    DataResult = jQuery.parseJSON(result);
                    if (DataResult == '1') {
                        toast("Success",'Record Saved',"");
                        clearData();
                    }
                    else if (DataResult == '2') {
                        toast("Error",'Location is already exists in this city.',"");
                        $('#<%= txt_Location.ClientID%>').focus();
                    }

                    else {
                        toast("Error",'Record Not Saved',"");
                    }
                })

        }



        function UpdateRecord() {
            var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;
            if ($("#<%=txt_Location.ClientID %>").val() == "") {
                toast("Error","Please Entre Location Name","");
                $("#<%=txt_Location.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null || $("#<%=ddlZone.ClientID %>").val() == '') {
                toast("Error","Please Select Zone","");
                $("#<%=ddlZone.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null || $("#<%=ddlState.ClientID %>").val() == '') {
                toast("Error","Please Select State","");
                $("#<%=ddlState.ClientID %>").focus();
                return;
            }

            if ($("#<%=ddlHeadquarter.ClientID %>").val() == "0" || $("#<%=ddlHeadquarter.ClientID %>").val() == null || $("#<%=ddlHeadquarter.ClientID %>").val() == '') {
                toast("Error","Please Select Headquarter","");
                $("#<%=ddlHeadquarter.ClientID %>").focus();
                return;
            }

            if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null || $("#<%=ddlCity.ClientID %>").val() == '') {
                toast("Error","Please Select City","");
                $("#<%=ddlCity.ClientID %>").focus();
                return;
            }

            if ($("#<%=ddlCityZone.ClientID %>").val() == "0" || $("#<%=ddlCityZone.ClientID %>").val() == null || $("#<%=ddlCityZone.ClientID %>").val() == '') {
                toast("Error","Please Select City Zone","");
                $("#<%=ddlCityZone.ClientID %>").focus();
                return;
            }



            var st = '';
            var et = '';
            var isHomeCollection = '0';
            var AvgTime = '0';

            if ($('#<%= chkIshomeCollection.ClientID%>').is(':checked')) {

                if ($("#<%=txtPincode.ClientID %>").val() == "") {
                    toast("Error","Please Entre Pincode","");
                    $("#<%=txtPincode.ClientID %>").focus();
                return;
            }
                AvgTime = $("#<%=ddTimeSloat.ClientID %>").val();
                isHomeCollection = '1';
                st = $("#<%=txt_OpenTime.ClientID %>").val(); // start time Format: '9:00 PM'
                 et = $("#<%=txt_ClosingTime.ClientID %>").val(); // end time   Format: '11:00 AM' 

                //how do i compare time

                if (st == "") {
                    toast("Error",'Please entre opening time',"");
                    return false;
                }
                if (et == "") {
                    toast("Error",'Please entre closing time',"");
                    return false;
                }



                if (st > et) {
                    toast("Error",'Closing time always greater then Opening time',"");
                    $("#<%=txt_ClosingTime.ClientID %>").focus();

                     return false;
                 }
             }


            var LocationId = $("#<%=lblLocation.ClientID %>").text();

            $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
            serverCall('AreaLocationMaster.aspx/UpdateRecord',
                {LocalityId: LocationId , Locality: $('#<%= txt_Location.ClientID%>').val() ,BusinessZoneID: $('#<%= ddlZone.ClientID%>').val() ,StateID: $("#<%=ddlState.ClientID %> option:selected").val() ,HeadquarterID: $("#<%=ddlHeadquarter.ClientID %> option:selected").val() ,CityID: $("#<%=ddlCity.ClientID %> option:selected").val() ,CityZoneId: $('#<%= ddlCityZone.ClientID%>').val() ,Pincode: $('#<%= txtPincode.ClientID%>').val() ,IsActive: IsActive ,startTime: st ,endTime: et ,AvgTime: AvgTime ,isHomeCollection: isHomeCollection },
                function (result) {
                    DataResult = jQuery.parseJSON(result);
                    if (DataResult == '1') {
                        toast("Success",'Record Updated',"");
                        clearData();
                        searchitem();
                    }
                    else if (DataResult == '2') {
                        toast("Error",'Location is already exists in this city.',"");
                        $('#<%= txt_Location.ClientID%>').focus();
                    }
                    else {
                        toast("Error",'Record Not Updat',"");
                    }
                })
        }




        function GetData() {
            serverCall('RouteMaster.aspx/GetData',
                {},
                function (result) {
                    PatientData = jQuery.parseJSON(result);
                    var output = $('#tb_Route').parseTemplate(PatientData);
                    $('#div_Route').html(output);
                })
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
            $("#<%=txt_OpenTime.ClientID %>").val('08:00');
            $("#<%=txt_ClosingTime.ClientID %>").val('18:00');
            $("#<%=ddTimeSloat.ClientID %>").val('30');
            $('.homecollection').show();
            jQuery('#ddlZone,#ddlState,#ddlCity,#ddlHeadquarter,#ddlCityZone').trigger('chosen:updated');
            getNoSlot();


        }

    </script>

</asp:Content>




