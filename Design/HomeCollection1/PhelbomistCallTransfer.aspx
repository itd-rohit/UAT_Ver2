<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelbomistCallTransfer.aspx.cs" Inherits="Design_HomeCollection_PhelbomistCallTransfer" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       


     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>



    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 

       <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align:center;">
            
                <strong>Phlebotomist Call Transfer</strong> 
                </div>
               

              <div class="POuter_Box_Inventory" >
          
                <asp:HiddenField runat="server" ID="hdn_AllSelect" Value="0" />
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>State</b></label>
			                <b class="pull-right">:</b>
                            </div>
                       <div class="col-md-5">
                              <asp:DropDownList ID="ddlstate" runat="server" onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>  
                       </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3" >
                            <label class="pull-left"><b>City</b></label>
			                <b class="pull-right">:</b>
                        </div>

                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlcity" runat="server" onchange="bindphelbo()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>
                      
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>Phlebotomist</b></label>
			                <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlphelbotomist" onchange="searchslot();" runat="server"   class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3">
                             <label class="pull-left"><b>Date</b></label>
			                <b class="pull-right">:</b>
                            </div>

                       <div class="col-md-2">
                              
                        <asp:TextBox ID="txttodate" runat="server"   ></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                       </div>
                        
                    </div>

               
                    
                        
                    <div id="slotdiv" onscroll="MoveSecond(this);" style="width:99%;overflow:auto;">

                        <table id="slottable"   frame="box"  rules="all" >

                        </table>
                    </div><br />
                           
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div class="col-md-4" style="font-weight:bold; ">
                             <img src="../../App_Images/TRY6_27.gif" style="height:40px; margin-left:43%;" />
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>State</b></label>
			                <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                              <asp:DropDownList ID="ddlstate_Target" runat="server" onchange="bindCity_Target()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>  
                       </div>

                         <div class="col-md-5"></div>
                        <div class="col-md-3">
                            <label class="pull-left"><b>City</b></label>
			                <b class="pull-right">:</b>
                        </div>

                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlcity_Target" runat="server" onchange="bindphelbo_Target()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>
                      
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                             <label class="pull-left"><b>Phlebotomist</b></label>
			                    <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlphelbotomist_Target" onchange="searchslot_Target();" runat="server"  class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>
                        </div>
                        <div id="slotdiv_Target" onscroll="MoveSecond(this);" style="width:99%;overflow:auto;">

            <table id="slottable_Target"   frame="box"  rules="all" >

                </table>
      </div><br />
                <table width="99%">
                    <tr>
                        <td style="font-weight:bold; "  colspan="4">
                            
                            <input type="button" style="margin-left:40%;" value="Transfer Calls" onclick="Transfer()" class="savebutton" />
                        </td>
                    </tr>
                </table>                  
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

        </script>

    <script type="text/javascript">

        function bindCity() {

            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlphelbotomist.ClientID%> option').remove();
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
            var ddlcity;
            ddlcity = $("#<%=ddlcity.ClientID %>");
            $("#<%=ddlcity.ClientID %> option").remove();

            serverCall('../Common/Services/CommonServices.asmx/bindCity',
                { StateID: jQuery('#<%=ddlstate.ClientID%>').val() },
                function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                    }
                    else {
                        ddlcity.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                    }
                    $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                })
            
           }



           function bindphelbo() {

               jQuery('#<%=ddlphelbotomist.ClientID%> option').remove();
            $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
               var ddlphelbotomist;
               ddlphelbotomist = $("#<%=ddlphelbotomist.ClientID %>");
               $("#<%=ddlphelbotomist.ClientID %> option").remove();

               serverCall('PhelbomistCallTransfer.aspx/bindphelbo',
                   { cityid:  jQuery('#<%=ddlcity.ClientID%>').val() },
                   function (result) {
                       localityData = jQuery.parseJSON(result);
                       if (localityData.length == 0) {
                           jQuery('#<%=ddlphelbotomist.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                    }

                    else {
                        ddlphelbotomist.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'PhlebotomistID', textField: 'name', isSearchAble: true });
                    }
                       $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
                   })
           }



        function bindCity_Target() {

            jQuery('#<%=ddlcity_Target.ClientID%> option').remove();
            jQuery('#<%=ddlphelbotomist_Target.ClientID%> option').remove();
            $('#<%=ddlcity_Target.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlphelbotomist_Target.ClientID%>').trigger('chosen:updated');
            var ddlcity_Target;
            ddlcity_Target = $("#<%=ddlcity_Target.ClientID %>");
            $("#<%=ddlcity_Target.ClientID %> option").remove();

            serverCall('../Common/Services/CommonServices.asmx/bindCity',
                { StateID:  jQuery('#<%=ddlstate_Target.ClientID%>').val()  },
                function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlcity_Target.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                    }
                    else {
                       
                        ddlcity_Target.bindDropDown({ defaultValue: 'Select', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });

                    }
                    $('#<%=ddlcity_Target.ClientID%>').trigger('chosen:updated');
                })
        }



        function bindphelbo_Target() {

            jQuery('#<%=ddlphelbotomist_Target.ClientID%> option').remove();
            $('#<%=ddlphelbotomist_Target.ClientID%>').trigger('chosen:updated');

            var ddlphelbotomist_Target;
            ddlphelbotomist_Target = $("#<%=ddlphelbotomist_Target.ClientID %>");
            $("#<%=ddlphelbotomist_Target.ClientID %> option").remove();
            serverCall('PhelbomistCallTransfer.aspx/bindphelbo',
                { cityid:  jQuery('#<%=ddlcity_Target.ClientID%>').val()  },
                function (result) {
                    localityData = jQuery.parseJSON(result);
                    if (localityData.length == 0) {
                        jQuery('#<%=ddlphelbotomist_Target.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                    }

                    else {
                        
                        ddlphelbotomist_Target.bindDropDown({ defaultValue: 'Select', data: JSON.parse(result), valueField: 'PhlebotomistID', textField: 'name', isSearchAble: true });
                    }
                    $('#<%=ddlphelbotomist_Target.ClientID%>').trigger('chosen:updated');
                })
               
        }

        </script>

    <script type="text/javascript">
        function searchslot() {
          
            
            var phlebotomistid= jQuery('#<%=ddlphelbotomist.ClientID%>').val()

                        $('#slottable tr').remove();

            serverCall('PhelbomistCallTransfer.aspx/bindslot',
                { phlebotomistid:  phlebotomistid , fromdate:  $('#<%=txttodate.ClientID%>').val() },
                function (result) {



                    if (result.split('#')[0] == "1") {
                        toast("Error","No Pending Calls On: " + $('#<%=txttodate.ClientID%>').val() + " ");
                        return;
                    }
                    SlotData = jQuery.parseJSON(result);
                    var mydata = [];



                    var col = [];
                    mydata.push('<tr id="header" style="background:-webkit-gradient(linear, 0 0, 0 100%, from(white), to(lightgray));font-weight:bold;height:35px;">');
                    for (var i = 0; i < SlotData.length; i++) {
                        for (var key in SlotData[i]) {
                            if (col.indexOf(key) === -1) {
                                if (key == "PhlebotomistID" || key == "route" || key == "centreid" || key == "centre") {
                                    mydata.push('<td style="display:none;">'); mydata.push(key.split('#')[0]);mydata.push('</td>');
                                }
                                else {
                                    mydata.push('<td>'); mydata.push(key);mydata.push( '</td>');
                                }
                                col.push(key);
                            }
                        }
                    }


                    mydata.push('</tr>');
                    for (var i = 0; i < SlotData.length; i++) {
                        mydata.push('<tr id="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[0]);mydata.push('" style="height:40px;">');
                        for (var j = 0; j < col.length; j++) {

                            if (col[j] == "PhlebotomistID") {
                                mydata.push('<td style="display:none;">'); mydata.push(SlotData[i][col[j]].split('#')[0]);mydata.push('</td>');
                            }
                            else if (col[j] == "route" || col[j] == "centreid" || col[j] == "centre") {
                                mydata.push('<td style="display:none;">'); mydata.push(SlotData[i][col[j]]);mydata.push('</td>');
                            }


                            else if (col[j] == "PhlebotomistName") {

                                mydata.push('<td title="Select All Call" class="td_SelectAll" onclick="Select_All();" style="font-weight:bold;background-color: #46f100;cursor:pointer;">'); mydata.push(SlotData[i][col[j]]);mydata.push('</td>');

                            }
                            else {


                                if (SlotData[i][col[j]] != null) {

                                    var mm = SlotData[i][col[j]];


                                    mydata.push('<td    colspan="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[1]);mydata.push('"  style="background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));"  >');



                                    for (var c = 0; c <= mm.split('~').length - 1; c++) {
                                        if (mm.split('~')[c].split('#')[10] == "1") {
                                            mydata.push('<div  class="div_all" onclick="Select_Slot('); mydata.push(mm.split('~')[c].split('#')[6]); mydata.push(')" style="background-color: #46f100; cursor: pointer;" id="div_');mydata.push( mm.split('~')[c].split('#')[6] + '"');
                                            var divtitle = "PrebookingId: " + mm.split('~')[c].split('#')[6] + "  &#013;Address: " + mm.split('~')[c].split('#')[2] + "  &#013;Mobile: " + mm.split('~')[c].split('#')[3] + "   &#013;IsVip: " + mm.split('~')[c].split('#')[7] + "  &#013;HardCopyRequired: " + mm.split('~')[c].split('#')[8] + "";
                                            mydata.push('title="'); mydata.push(divtitle);mydata.push( '" >');
                                            mydata.push(mm.split('~')[c].split('#')[1]); mydata.push("<br/>");mydata.push(mm.split('~')[c].split('#')[9]);
                                            mydata.push('<input class="chk_all" type="checkbox" value="'); mydata.push(mm.split('~')[c].split('#')[6]); mydata.push('" style="display:none;" id="chk_'); mydata.push(mm.split('~')[c].split('#')[6]);mydata.push('" ></div>');
                                        }
                                        else {

                                            mydata.push('<img src="../../App_Images/slotbooked.png"/>');
                                        }


                                    }
                                    mydata.push('</td>');
                                    j = j + 2;
                                }
                                else {

                                    mydata.push('<td ondrop="drop(event,\''); mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); mydata.push('\',\''); mydata.push(col[j]); mydata.push('\')"  style="cursor:pointer; background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));" colspan="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[1]);mydata.push('" >');
                                    mydata.push('</td>');
                                    j = j + 2;

                                }


                            }
                        }

                        mydata.push('</tr>');
                    }

                    mydata = mydata.join("")
                    $('#slottable').append(mydata);
                })
            
        }


        function searchslot_Target() {
            

            var phlebotomistid = jQuery('#<%=ddlphelbotomist_Target.ClientID%>').val()            
            $('#slottable_Target tr').remove();
            serverCall('PhelbomistCallTransfer.aspx/bindslot_Target',
                { phlebotomistid:  phlebotomistid , fromdate:  $('#<%=txttodate.ClientID%>').val()  },
                function (result) {

                    if (result.split('#')[0] == "1") {
                        toast("Error",'Please Select Phlebotomist');
                        return;
                    }
                    var mydata = [];
                    SlotData = jQuery.parseJSON(result);


                    var col = [];
                    mydata.push('<tr id="header" style="background:-webkit-gradient(linear, 0 0, 0 100%, from(white), to(lightgray));font-weight:bold;height:35px;">');
                    for (var i = 0; i < SlotData.length; i++) {
                        for (var key in SlotData[i]) {
                            if (col.indexOf(key) === -1) {
                                if (key == "PhlebotomistID" || key == "route" || key == "centreid" || key == "centre") {
                                    mydata.push('<td style="display:none;">'); mydata.push(key.split('#')[0]);mydata.push( '</td>');
                                }
                                else {
                                    mydata.push('<td>'); mydata.push(key);mydata.push('</td>');
                                }
                                col.push(key);
                            }
                        }
                    }


                    mydata.push('</tr>');
                    for (var i = 0; i < SlotData.length; i++) {
                        mydata.push('<tr id="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[0]);mydata.push('" style="height:40px;">');
                        for (var j = 0; j < col.length; j++) {

                            if (col[j] == "PhlebotomistID") {
                                mydata.push('<td style="display:none;">'); mydata.push(SlotData[i][col[j]].split('#')[0]);mydata.push('</td>');
                            }
                            else if (col[j] == "route" || col[j] == "centreid" || col[j] == "centre") {
                                mydata.push('<td style="display:none;">'); mydata.push(SlotData[i][col[j]]);mydata.push( '</td>');
                            }


                            else if (col[j] == "PhlebotomistName") {

                                mydata.push('<td title="Select All Call" style="font-weight:bold;background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));cursor:pointer;">'); mydata.push(SlotData[i][col[j]]);mydata.push('</td>');

                            }
                            else {


                                if (SlotData[i][col[j]] != null) {

                                    var mm = SlotData[i][col[j]];


                                    mydata.push('<td    colspan="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[1]);mydata.push('"  style="background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));"  >');



                                    for (var c = 0; c <= mm.split('~').length - 1; c++) {
                                        if (mm.split('~')[c].split('#')[10] == "1") {
                                            mydata.push('<div style="background-color: #46f100;"  id="div_'); mydata.push(mm.split('~')[c].split('#')[6]);mydata.push('"');




                                            var divtitle = "PrebookingId: " + mm.split('~')[c].split('#')[6] + "  &#013;Address: " + mm.split('~')[c].split('#')[2] + "  &#013;Mobile: " + mm.split('~')[c].split('#')[3] + "   &#013;IsVip: " + mm.split('~')[c].split('#')[7] + "  &#013;HardCopyRequired: " + mm.split('~')[c].split('#')[8] + "";
                                            mydata.push('title="'); mydata.push(divtitle);mydata.push('" >');


                                            mydata.push(mm.split('~')[c].split('#')[1]); mydata.push("<br/>");mydata.push(mm.split('~')[c].split('#')[9]);
                                            mydata.push('</div>');
                                        }
                                        else {

                                            mydata.push('<img src="../../App_Images/slotbooked.png"/>');
                                        }


                                    }
                                    mydata.push('</td>');
                                    j = j + 2;
                                }
                                else {

                                    mydata.push('<td  style="cursor:pointer; background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));"  colspan="'); mydata.push(SlotData[i].PhlebotomistID.split('#')[1]);mydata.push('" >');
                                    mydata.push('</td>');
                                    j = j + 2;

                                }


                            }
                        }

                        mydata.push('</tr>');
                    }

                    mydata = mydata.join("")
                    $('#slottable_Target').append(mydata);
                })
        }

        function Select_Slot(id) {                    
            if ($('#chk_' + id + '').prop("checked") == true) {
                $('#div_' + id + '').css("background-color", "#46f100");
                $('#chk_' + id + '').prop('checked', false);              
            }
            else {
                $('#div_' + id + '').css("background-color", "red");
                $('#chk_' + id + '').prop('checked', true);
            }

            var lengthOfUnchecked = $(".chk_all:not(:checked)").length;

            if (lengthOfUnchecked == 0) {
                $('.td_SelectAll').css("background-color", "red");

            }
            else {
                $('.td_SelectAll').css("background-color", "#46f100");
            }
                    
        }
        function Select_All() {
            if ($('#<%=hdn_AllSelect.ClientID%>').val() == "0") {
                $('.div_all').css("background-color", "red");
                $('.chk_all').prop('checked', true);
                $('#<%=hdn_AllSelect.ClientID%>').val('1');
                $('.td_SelectAll').css("background-color", "red");

            }
            else {
                $('.div_all').css("background-color", "#46f100");
                $('.chk_all').prop('checked', false);
                $('#<%=hdn_AllSelect.ClientID%>').val('0');
                $('.td_SelectAll').css("background-color", "#46f100");
            }
        }


        function Transfer() {
            

            if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                $('#<%=ddlstate.ClientID%>').focus();
                toast("Error","Please Select Source State");
                return;
            }

            if ($('#<%=ddlcity.ClientID%>').val() == "0") {
                $('#<%=ddlcity.ClientID%>').focus();
                toast("Error","Please Select Source City");
                return;
            }
            if ($('#<%=ddlphelbotomist.ClientID%>').val() == "0") {
                $('#<%=ddlphelbotomist.ClientID%>').focus();
                toast("Error","Please Select Source Phelbotomist");
                return;
            }


            if ($('#<%=ddlstate_Target.ClientID%>').val() == "0") {
                $('#<%=ddlstate_Target.ClientID%>').focus();
                toast("Error","Please Select Target State");
                return;
            }

            if ($('#<%=ddlcity_Target.ClientID%>').val() == "0") {
                $('#<%=ddlcity_Target.ClientID%>').focus();
                toast("Error","Please Select Target City");
                return;
            }
            if ($('#<%=ddlphelbotomist_Target.ClientID%>').val() == "0") {
                $('#<%=ddlphelbotomist_Target.ClientID%>').focus();
                toast("Error","Please Select Target Phelbotomist");
                return;
            }
            var lengthOfchecked = $('input:checkbox.chk_all:checked').length;
            if (lengthOfchecked == 0) {
                toast("Error","Please Select Call");
                return;
            }
            
            var PrebookingId = [];
            $.each($('input:checkbox.chk_all:checked'), function () {
                PrebookingId.push($(this).val());
            });

            var All_PrebookingId = PrebookingId.join(",");
            var phelbotomist_SourceId= $('#<%=ddlphelbotomist.ClientID%>').val();
            var phelbotomist_TargetId=  $('#<%=ddlphelbotomist_Target.ClientID%>').val();
            serverCall('PhelbomistCallTransfer.aspx/Transfer',
                { All_PrebookingId:  All_PrebookingId , phelbotomist_SourceId:  phelbotomist_SourceId , phelbotomist_TargetId:  phelbotomist_TargetId },
                function (result) {
                    if (result == "1") {

                        toast("Success","Call Is Successfully Transfer..!");
                        searchslot();
                        searchslot_Target();

                    }
                    else {
                        toast("Error",'Error');
                    }

                })
        
            
            
        }

        $('#<%=txttodate.ClientID%>').change(function ()
        {
           
            if ($('#<%=ddlphelbotomist.ClientID%>').val() != null) {
                if ($('#<%=ddlphelbotomist.ClientID%>').val() != '0') {
                    searchslot();

                }
               
            }

            if ($('#<%=ddlphelbotomist_Target.ClientID%>').val() != null) {
                if ($('#<%=ddlphelbotomist_Target.ClientID%>').val() != '0') {
                    searchslot_Target();

                }

            }
            
        });

        function MoveSecond(ctrl)
        {
            var divPosition = $(ctrl).scrollLeft();
            $('#slotdiv').scrollLeft(divPosition);
            $('#slotdiv_Target').scrollLeft(divPosition);

        }
       
    </script>
  
</asp:Content>



