<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleDiscard.aspx.cs" Inherits="Design_SampleStorage_SampleDiscard" %>



<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    

    <style type="text/css">
        .deactive {
            background-color:white;height:25px;color:#000066;cursor:pointer;
        }
         .active {
            background-color:lightgreen;height:25px;color:#000066;cursor:pointer;
        }
          /*#ContentPlaceHolder1_ddldevice_chosen{
            width:300px !important;
        }*/

        .spantrayhalf {
            font-size:12px;padding:5px;margin:5px;border-radius:8px;font-weight:bold;color:transparent;cursor:pointer;background: -webkit-linear-gradient(180deg,pink 50%, green 50%);
        }
         .spantrayfull {
            font-size:12px;padding:5px;margin:5px;border-radius:8px;font-weight:bold;background-color:green;color:transparent;cursor:pointer;
        }
         .spantrayactive {
               font-size:12px;padding:5px;margin:5px;border-radius:8px;font-weight:bold;color:transparent;cursor:pointer;background: -webkit-linear-gradient(180deg,cyan 100%, green 0%);


             
        }
         .close {
             background-color:black;color:white;font-weight:bold;padding:5px;border-radius:10px;display:none;cursor:pointer;
        }
    </style>


     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

        <div id="Pbody_box_inventory" >
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="row">
                        <div class="col-md-9"></div>
                        <div class="col-md-4">
                            <b>Sample Discard</b>
                        </div>
                    </div>
                    <div class="row">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        <div class="row">
                            <div class="col-md-3">
                                Search
                            </div>
                        </div>
                    </div>
               
                     <div class="row">
                         <div class="col-md-3" style="text-align:right;">
                             <label class="pull-left"><b>Centre</b></label>
			                <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                                 <asp:DropDownList ID="ddlcentre" runat="server" class="ddlcentre  chosen-select chosen-container" onchange="binddevice()">
                              </asp:DropDownList>
                         </div>
                         <div class="col-md-3" style="text-align:right;">
                             <label class="pull-left"><b>Expiry Date</b></label>
			                    <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">   
                             <asp:TextBox ID="txtspshedule"  runat="server" ></asp:TextBox>
                             <cc1:CalendarExtender ID="calFromDate"  runat="server" TargetControlID="txtspshedule" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                         <div class="col-md-3" style="font-weight: 700;text-align:right;">
                             <label class="pull-left"><b>Device</b></label>
			                    <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddldevice"  runat="server" class="ddldevice  chosen-select chosen-container"></asp:DropDownList>
                         </div>
                     </div>
                     <div class="row">
                         <div class="col-md-5"></div>
                          <div class="col-md-12" style="text-align:center;">
                            <b>
                                <input type="button" class="searchbutton" value="Load Expired Tray" onclick="loadmydata()" />
                            </b>
                          </div>
                     </div>
                 
               </div>
                <div class="POuter_Box_Inventory">
                     <div class="row">
                         <div class="col-md-12">
                               <div class="savediv" style="display:none;">
                                   <div class="row">
                                      <div class="col-md-2" style="border-right: black thin solid; border-top: black thin solid;
                                        border-left: black thin solid; border-bottom: black thin solid; background: -webkit-linear-gradient(180deg,pink 50%, green 50%)"">
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                      </div>
                                      <div class="col-md-3">
                                        Running
                                      </div> 
                                        <div class="col-md-2" style="border-right: black thin solid; border-top: black thin solid;
                                            border-left: black thin solid; border-bottom: black thin solid; background-color: green;" ">
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                        </div> 
                                       <div class="col-md-3">
                                           Full
                                       </div> 
                                        <div class="col-md-2" style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                            border-left: black thin solid; border-bottom: black thin solid; background: -webkit-linear-gradient(180deg,cyan 100%, green 0%)"" ">
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                        </div> 
                                       <div class="col-md-3">
                                            Selected
                                       </div>
                                  </div>
                              </div>
                                <div style="width:99%;overflow:auto;height:360px;">
                                    <table id="devicedesign" rules="all" cellpadding="3" cellspacing="0" style="background-color:lightyellow;border-color:#CCCCCC;border-width:1px;border-style:None;border-collapse:collapse;margin-left:5px;color:white;border-color:maroon;" frame="box"></table>
                                </div>
                         </div>
                         <div class="col-md-12" valign="top">
                            <div class="row">
                                <div class="col-md-4"> 
                                    <label class="pull-left">Tray Code   </label>
			                        <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-4">
                                    <span id="trcode" style="font-weight:bold;"></span>
                                </div>
                                <div class="col-md-4">
                                        <label class="pull-left">Expiry   </label>
			                        <b class="pull-right">:</b>
                            </div>
                                <div class="col-md-4">
                                    <span id="trexpiry" style="font-weight:bold;"></span>
                                </div>
                                <div class="col-md-4">
                                        <label class="pull-left"> Type   </label>
			                        <b class="pull-right">:</b>
                            </div>    
                                <div class="col-md-4">
                                    <span id="trtype" style="font-weight:bold;"></span>
                                </div>
                            </div>
                          </div>
                         <div style="overflow:auto;height:360px;">
                            <table id="traydesign" rules="all" cellpadding="3" cellspacing="0" style="background-color:white;border-color:#CCCCCC;border-width:1px;border-style:None;border-collapse:collapse;width:99%;color:white;border-color:maroon;" frame="box">   
                            </table>
                         </div>
                      </div>
              </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center;display:none;" id="savediv">
                     <div class="row">
                         <div class="col-md-10"></div>
                         <div class="col-md-2">
                            <input type="button" class="savebutton" value="Discard" onclick="savedata()" />
                         </div>
                         <div class="col-md-2">
                            <input type="button" value="Clear" class="resetbutton" onclick="clearall()" />
                         </div>
                     </div>

                 </div>
     <script type="text/javascript">
         var centreid = '<%=UserInfo.Centre%>';

         function clearall() {
             window.location.reload();
         }

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
             BindCentre();
         });



         function BindCentre() {


             var ddlDoctor = $("#<%=ddlcentre.ClientID %>");
             $("#<%=ddlcentre.ClientID %> option").remove();


             serverCall('../Lab/MachineResultEntry.aspx/bindAccessCentre', {}, function (result) {
                 PanelData = $.parseJSON(result);
                 if (PanelData.length == 0) {
                 }
                 else {
                     ddlDoctor.bindDropDown({ defaultValue: 'ALL', data: JSON.parse(result), valueField: 'CentreID', textField: 'Centre', isSearchAble: true });
                 }
                 $("#<%=ddlcentre.ClientID %>").val(centreid);

                     ddlDoctor.trigger('chosen:updated');
                     $("#<%=ddlcentre.ClientID %>").attr('disabled', true);
                     ddlDoctor.trigger('chosen:updated');
                     binddevice();
             })


         }

         function binddevice() {
             var ddlDoctor = $("#<%=ddldevice.ClientID %>");
             $("#<%=ddldevice.ClientID %> option").remove();
             serverCall('SampleDiscard.aspx/binddevice', { centreid: $('#<%=ddlcentre.ClientID%>').val() }, function (result) {
                 PanelData = $.parseJSON(result);
                 if (PanelData.length == 0) {
                 }
                 else {
                     ddlDoctor.bindDropDown({ defaultValue: 'Select Device', data: JSON.parse(result), valueField: 'id', textField: 'devicename', isSearchAble: true });
                 }


                 ddlDoctor.trigger('chosen:updated');
             })
         }


         function loadmydata() {

             if ($('#<%=ddldevice.ClientID%> option').length == 0 ) {
                 toast("Error","Please Select Device","");
                 return;
             }
             if ($('#<%=ddldevice.ClientID%> option:selected').val() == "0") {
                 showdevicetable();
             }
             else {
                 showdevicetable1();
             }

             $('#savediv').show();
             $('.savediv').show();
         }


         function showdevicetable() {
             $('#devicedesign tr').remove();
             var devicename = "";

             $('#ContentPlaceHolder1_ddldevice option').each(function () {

                 if (this.value != "0") {
                     for (var ac = 1; ac <= this.value.split('#')[1]; ac++) {


                         var mmt = "";
                         var $mydata=[];
                         $mydata.push('<tr>');
                        
                         $mydata.push('<td align="left" style="font-weight:bold;color:blue;">');
                         if(devicename!=this.text)
                         $mydata.push(this.text);
                         $mydata.push('</td>');
                         $mydata.push('<td align="left" id='); $mydata.push(ac); $mydata.push('  style=" width:100px;height:25px;"  ><span style="font-size:12px;padding:5px;border-radius:8px;font-weight:bold;background-color:blue;"   >Rack '); $mydata.push(ac);$mydata.push('</span></td> ');
                         $mydata.push('<td id="seats">');
                         
                         serverCall('SampleDiscard.aspx/getdevicedata', { deviceid: this.value.split('#')[0], rackid: ac, expirydate: $('#ContentPlaceHolder1_txtspshedule').val() },
                             function (result) {
                                 TestData = JSON.parse(result);
                                 if (TestData.length == 0) {
                                     mmt = "1";
                                 }
                                 for (var i = 0; i <= TestData.length - 1; i++) {
                                     if (TestData[i].totalcount == TestData[i].totalcapacity) {
                                         $mydata.push('<div class="traydiv" id="'); $mydata.push(TestData[i].traycode); $mydata.push('" style="float:left;"> <span  title="'); $mydata.push(TestData[i].type); $mydata.push(' '); $mydata.push(TestData[i].traycode); $mydata.push('"   class="spantrayfull"   onclick="getoldtraydata(\''); $mydata.push(TestData[i].traycode); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity1); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity2); $mydata.push('\',\''); $mydata.push(TestData[i].type); $mydata.push('\',\''); $mydata.push(TestData[i].expirydate); $mydata.push('\',this)">TRAY</span></div>');
                                     }
                                     else {
                                         $mydata.push('<div class="traydiv" id="'); $mydata.push(TestData[i].traycode); $mydata.push('" style="float:left;"> <span  title="'); $mydata.push(TestData[i].type); $mydata.push(' '); $mydata.push(TestData[i].traycode); $mydata.push('"  class="spantrayhalf"  onclick="getoldtraydata(\''); $mydata.push(TestData[i].traycode); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity1); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity2); $mydata.push('\',\''); $mydata.push(TestData[i].type); $mydata.push('\',\''); $mydata.push(TestData[i].expirydate); $mydata.push('\',this)">TRAY</span></div>');
                                     }
                                 }
                             })
                         

                         $mydata.push('</td>');
                         $mydata.push('</tr>');
                         $mydata = $mydata.join("");
                        if(mmt=="")
                         $('#devicedesign').append($mydata);

                         devicename = this.text;

                     }
                 }
             })


         }


         function showdevicetable1() {
             $('#devicedesign tr').remove();

             var devicename = "";
             

               
             for (var ac = 1; ac <= $('#<%=ddldevice.ClientID%> option:selected').val().split('#')[1]; ac++) {


                         var mmt = "";
                         var $mydata=[];
                         $mydata.push('<tr>');
                        
                         $mydata.push('<td align="left" style="font-weight:bold;color:blue;">');
                         if(devicename!= $('#<%=ddldevice.ClientID%> option:selected').text())
                             $mydata.push($('#<%=ddldevice.ClientID%> option:selected').text());
                           $mydata.push('</td>');
                           $mydata.push('<td align="left" id='); $mydata.push(ac); $mydata.push('  style=" width:100px;height:25px;"  ><span style="font-size:12px;padding:5px;border-radius:8px;font-weight:bold;background-color:blue;"   >Rack '); $mydata.push(ac);$mydata.push('</span></td> ');
                           $mydata.push('<td id="seats">');
                           serverCall('SampleDiscard.aspx/getdevicedata', { deviceid: $('#<%=ddldevice.ClientID%> option:selected').val().split('#')[0], rackid: ac, expirydate: $('#ContentPlaceHolder1_txtspshedule').val() },
                               function (result) {
                                   TestData = JSON.parse(result);
                                   if (TestData.length == 0) {
                                       mmt = "1";
                                   }
                                   for (var i = 0; i <= TestData.length - 1; i++) {
                                      
                                       if (TestData[i].totalcount == TestData[i].totalcapacity) {
                                           $mydata.push('<div class="traydiv" id="'); $mydata.push(TestData[i].traycode); $mydata.push('" style="float:left;"> <span  title="'); $mydata.push(TestData[i].type); $mydata.push(' '); $mydata.push(TestData[i].traycode); $mydata.push('"   class="spantrayfull"   onclick="getoldtraydata(\''); $mydata.push(TestData[i].traycode); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity1); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity2); $mydata.push('\',\''); $mydata.push(TestData[i].type); $mydata.push('\',\''); $mydata.push(TestData[i].expirydate); $mydata.push('\',this)">TRAY</span></div>');
                                       }
                                       else {
                                           $mydata.push('<div class="traydiv" id="'); $mydata.push(TestData[i].traycode); $mydata.push('" style="float:left;"> <span  title="'); $mydata.push(TestData[i].type); $mydata.push(' '); $mydata.push(TestData[i].traycode); $mydata.push('"  class="spantrayhalf"  onclick="getoldtraydata(\''); $mydata.push(TestData[i].traycode); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity1); $mydata.push('\',\''); $mydata.push(TestData[i].Capacity2); $mydata.push('\',\''); $mydata.push(TestData[i].type); $mydata.push('\',\''); $mydata.push(TestData[i].expirydate); $mydata.push('\',this)">TRAY</span></div>');
                                       }
                                   }
                               })
                         $mydata.push('</td>');
                         $mydata.push('</tr>');
                          $mydata = $mydata.join("")
                         if(mmt=="")
                         $('#devicedesign').append($mydata);

                         devicename = $('#<%=ddldevice.ClientID%> option:selected').text();

                     }
                
           


         }

         function getoldtraydata(traycode, cap1, cap2, type, expiry, ctrl) {
             if ($(ctrl).hasClass("spantrayactive")) {
                 $(ctrl).removeClass("spantrayactive");
                 $(ctrl).parent().removeAttr("name");
             }
             else {
                 $(ctrl).addClass("spantrayactive");
                 $(ctrl).parent().attr("name", "select");
             }

             $('#traydesign tr').remove();
          
             $('#trayinfo').hide();


           

             for (var a = 1; a <= parseInt(cap1) ; a++) {
                 var $mydata=[];
                 $mydata.push('<tr>');
                 for (var b = 1; b <= parseInt(cap2) ; b++) {
                     var ii = a + "_" + b;
                     $mydata.push('<td align="left"  style=" width:100px;height:15px;" ><span style="cursor:pointer;font-size:12px;padding:5px;border-radius:8px;font-weight:bold;background-color:#cc4f66;display:none;" class="myspan" id="'); $mydata.push(ii); $mydata.push('"/></td>');
                 }
                 $mydata.push('</tr>');
                 $mydata = $mydata.join("");
                 $('#traydesign').append($mydata);
             }


             $('#trayinfo').show();
                
               $('#trcode').html(traycode);
               $('#trexpiry').html(expiry);
               $('#trtype').html(type);
               serverCall('sampleStorage.aspx/GetoldTrayData', { trayid: traycode }, function (result) {
                   TestData = $.parseJSON(result);
                   if (TestData.length == 0) {

                       $('.myspan').html('');
                       $('.myspan').attr('title', '');
                       $('.myspan').hide();
                   }
                   else {
                       $('.myspan').html('');
                       $('.myspan').attr('title', '');
                       $('.myspan').hide();
                       for (i = 0; i < TestData.length; i++) {
                           $('.myspan').each(function () {
                               if ($(this).html() == "") {
                                   $(this).html(TestData[i].barcodeno);
                                   var test = "Test:" + TestData[i].Itemname + " Visit No:" + TestData[i].LedgerTransactionNo + " PName:" + TestData[i].pname + " " + TestData[i].Age + " " + TestData[i].Gender;
                                   $(this).attr('title', test);
                                   $(this).attr('name', 'old');
                                   $(this).show();
                                   //$(this).find('.close').show();
                                   return false;
                               }
                           }
                           );


                       }
                   }
               })
             
         }

         function getdiscdata()
         {
             var dataPLO = new Array();
             $('.traydiv').each(function () {
                 if($(this).attr("name")=="select")
                 dataPLO.push($(this).attr("id"));
             }
           );
             return dataPLO;
         }
         function savedata() {

             var datatosave = getdiscdata();
            
            
             if (datatosave == "") {
                 toast("Error","Please Select Tray To Discard","");
                 return;
             }
             serverCall('SampleDiscard.aspx/SaveData', { datatosave: datatosave },
                 function (result) {
                     TestData = $.parseJSON(result);
                     if (TestData == "1") {
                         toast("Success","Tray Discard Sucessfully","");
                         loadmydata();
                         $('#traydesign tr').remove();
                         $('#trayinfo').hide();
                     }
                     else {
                         toast("Error",TestData,"");
                     }
                 })
         }
         </script>
</asp:Content>

