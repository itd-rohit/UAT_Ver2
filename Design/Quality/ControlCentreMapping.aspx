<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ControlCentreMapping.aspx.cs" Inherits="Design_Quality_ControlCentreMapping" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
	   <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
 <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
     <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Centre Control Mapping</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 

                  <table width="99%">
                      <tr>
                          <td style="font-weight: 700">Centre :</td>
                          <td><asp:DropDownList ID="ddlprocessinglab" runat="server" class="ddlprocessinglab chosen-select chosen-container" Width="380" onchange="bindmachine()">
                           
                          </asp:DropDownList></td>

                          <td style="font-weight: 700">
                              Machine :
                          </td>
                          <td>
<asp:DropDownList ID="ddlmachine" runat="server" class="ddlmachine chosen-select chosen-container" Width="500" onchange="bindcontrol()">
                           
                          </asp:DropDownList>
                          </td>
                      </tr>
                      <tr>
                          <td style="font-weight: 700">Control :
                          </td>
                          <td colspan="3">
                              <asp:DropDownList ID="ddlcontrol" runat="server" class="ddlcontrol chosen-select chosen-container" Width="800px" >
                           
                          </asp:DropDownList>
                             &nbsp;&nbsp;&nbsp;&nbsp; <input type="button" value="Search" class="searchbutton" onclick="searchparameter()" /></td>

                      </tr>
                      </table>
                </div>
              </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
             <div class="Purchaseheader"> <table width="99%">
                 <tr>
                     
                     <td><span id="spn"></span></td>
                 </tr>
                                          </table> </div>
            <div class="content">


             


                 <div  style="width:1295px; max-height:370px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                     <thead>
                    <tr id="trheader">
                        
                          <th class="GridViewHeaderStyle" style="width: 30px;">Sr.No</th>
                          <th class="GridViewHeaderStyle" style="width: 30px;" title="Map More Assay No">Add</th>
                          <th class="GridViewHeaderStyle" style="width: 125px;">LabObservation ID</th>
                          <th class="GridViewHeaderStyle">LabObservation Name</th>
                          <th class="GridViewHeaderStyle" style="width:45px;">Level</th>
                          <th class="GridViewHeaderStyle" style="width:85px;">Min Value</th>
                          <th class="GridViewHeaderStyle" style="width:85px;">Max Value</th>
                          <th class="GridViewHeaderStyle" style="width:115px;">Base Mean Value</th>
                          <th class="GridViewHeaderStyle" style="width:115px;">Base SD Value</th>
                          <th class="GridViewHeaderStyle" style="width:110px;">Base CV (%)</th>
                          <th class="GridViewHeaderStyle"  style="width:110px;">Assay No</th>
                          <th class="GridViewHeaderStyle"  style="width:110px;">Sin No</th>
                          <th class="GridViewHeaderStyle" style="width:100px;">Lock Machine</th>
                          <%--<th class="GridViewHeaderStyle" style="width:20px;" title="QC Scheduling"></th>--%>
                          <th class="GridViewHeaderStyle" style="width:20px;" title="Remove Mapping">#</th>
                          
                          
                    </tr>
                          </thead>
                </table>
                </div>
                </div>
             </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
             <table width="99%">
                 <tr>
                     <td width="50%">
                          <table width="60%">
                <tr>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" >
                                &nbsp;&nbsp;</td>
                    <td>Mapped Data</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;</td>
                    <td>UnMapped Data</td>
                     
                   
                    
                </tr>
            </table>
                     </td>
                      <td width="50%">
                           <input type="button" value="Save" class="savebutton" id="btnsave" onclick="savedata()" style="display:none;" />&nbsp;&nbsp;
             <input type="button" value="Reset" class="resetbutton" id="btnreset" onclick="resetdata()"  />
                      </td>
                 </tr>
             </table>
            
            </div>


         </div>

     <script type="text/javascript">

         var caneditsin = '<%=caneditsin %>';
         var caneditlabmin = '<%=caneditlabmin %>';
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
                 
             jQuery("#tblitemlist").tableHeadFixer({

             });
             bindmachine();

         });


         function showme2(ctrl) {

             

             var val = $(ctrl).val();
             var name = $(ctrl).attr("name");
             $('input[name="' + name + '"]').each(function () {
                 $(this).val(val);
             });
         }

         function bindmachine() {
             var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddlmachine.ClientID%> option').remove();
             $('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null) {


                 //$.blockUI();
                 $.ajax({
                     url: "ControlCentreMapping.aspx/bindmachine",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Machine Found");
                         }

                         jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Machine"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].MacID).html(CentreLoadListData[i].machinename));
                         }

                         $("#<%=ddlmachine.ClientID%>").trigger('chosen:updated');





                         //$.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.unblockUI();
                     }
                 });
             }
         }

         function bindcontrol() {

             var macid = $('#<%=ddlmachine.ClientID%>').val();
             jQuery('#<%=ddlcontrol.ClientID%> option').remove();
             $('#<%=ddlcontrol.ClientID%>').trigger('chosen:updated');

             if (macid != "0" && macid != null) {


                 //$.blockUI();
                 $.ajax({
                     url: "ControlCentreMapping.aspx/bindcontrol",
                     data: '{macid: "' + macid.split('#')[1] + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Control Found");
                         }

                         jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].controlid).html(CentreLoadListData[i].controlname));
                         }

                         $("#<%=ddlcontrol.ClientID%>").trigger('chosen:updated');





                         //$.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.unblockUI();
                     }
                 });
             }
         }

         </script>


    <script type="text/javascript">

        function searchparameter() {

            if ($('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                return;
            }

            if ($('#<%=ddlmachine.ClientID%>').val() == "0") {
                showerrormsg("Please Select Machine");
                return;
            }

            if ($('#<%=ddlcontrol.ClientID%>').val() == "0") {
                showerrormsg("Please Select Control");
                return;
            }

            $("input[type='text']").val("");

            $('#tblitemlist tr').slice(1).remove();
            $('#spn').html('');
            //$.blockUI();
            $.ajax({
                url: "ControlCentreMapping.aspx/bindparameter",
                data: '{controlid:"' + $('#<%=ddlcontrol.ClientID%>').val() + '",machineid:"' + $('#<%=ddlmachine.ClientID%>').val().split('#')[0] + '",centreid:"' + $('#<%=ddlprocessinglab.ClientID%>').val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        //$.unblockUI();
                        $('#btnsave').hide();
                        return;
                    }
                    var controldetail = "Control Name:- <label style='color:red;'>" + ItemData[0].controlname + "</label>   Lot Number:- <label style='color:red;'>" + ItemData[0].lotnumber + "</label>  Control Provider:- <label style='color:red;'>" + ItemData[0].ControlProvider + "</label>   Start Date:- <label style='color:red;'>" + ItemData[0].startdate + "</label>   Lot Expiry:- <label style='color:red;'>" + ItemData[0].LotExpiry + "</label><br/>";
                    if (caneditsin == "1" || caneditlabmin=="1") {
                        controldetail += '<div style="float:left;"> Select All : <input type="checkbox" id="chhead" onclick="checkall(this)"/></div>';
                    }
                    if (caneditsin == "1") {
                        controldetail += '<div style="margin-left:50%;">Enter Sin No for All Parameter :&nbsp;&nbsp;';
                        controldetail += '<input type="text" onkeyup="showme2(this)" style="width:100px;background-color:lightgray;" name="sinnolevel1" placeholder="Sin No Level1" />&nbsp;&nbsp;';
                        controldetail += '<input type="text" onkeyup="showme2(this)" style="width:100px;background-color:lightgray;" name="sinnolevel2" placeholder="Sin No Level2" />&nbsp;&nbsp;';
                        controldetail += '<input type="text" onkeyup="showme2(this)" style="width:100px;background-color:lightgray;" name="sinnolevel3" placeholder="Sin No Level3" />&nbsp;&nbsp;</div>';
                    }
                  


                    $('#spn').html(controldetail);
                    var obsid = "";
                    for (i = 0; i < ItemData.length; i++) {
                        var level = 'Level' + ItemData[i].levelid;
                        var color = "bisque";
                        if (ItemData[i].savedid != "") {
                            color = "lightgreen";
                        }
                        var mydata = "";
                        if (ItemData[i].LabObservation_ID != obsid) {
                            mydata = "<tr style='border-top:2px solid gray;background-color:" + color + ";' id='" + ItemData[i].LabObservation_ID + "_" + level +"_"+ItemData[i].assayno+ "'>";
                        }
                        else {
                            mydata = "<tr style='background-color:" + color + ";' id='" + ItemData[i].LabObservation_ID + "_" + level + "_" + ItemData[i].assayno + "'>";
                        }
                        if (ItemData[i].savedid == "") {
                            if (caneditsin == "1" || caneditlabmin == "1") {
                                mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '&nbsp;<input type="checkbox" id="ch" checked="checked"/></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                            }
                        }
                        else {
                            if (caneditsin == "1" || caneditlabmin == "1") {
                                mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '&nbsp;<input type="checkbox" id="ch" /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                            }
                        }
                    
                     
                        if (ItemData[i].LabObservation_ID != obsid) {
                            mydata += '<td><img id="aimg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" title="Add More Assay No" onclick="addme(this);" />';
                            mydata += '<img id="dimg" src="../../App_Images/Delete.gif" style="cursor:pointer;display:none;" onclick="deleterow(this)"/></td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="l1"  style="font-weight:bold;">' + ItemData[i].LabObservation_ID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="p1" style="font-weight:bold;" >' + ItemData[i].LabObservation_Name + '</td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"    style="font-weight:bold;"><img id="dimg" src="../../App_Images/Delete.gif" style="cursor:pointer;display:none;" onclick="deleterow(this)"/></td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="l1"  style="font-weight:bold;"></td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="p1" style="font-weight:bold;" ></td>';
                        }
                       
                        mydata += '<td align="left" id="Level" style="font-weight:bold;">' + level + '</td>';
                       
                        if (caneditlabmin == "0") {
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtminvalue" class=' + level + ' value="' + ItemData[i].Minvalue + '" onkeyup="checkminvalue(this)"  /></td>';
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtmaxvalue" class=' + level + ' value="' + ItemData[i].Maxvalue + '" onkeyup="setsdvalue(this)"  /></td>';
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtbaseminvalue"  class=' + level + ' value="' + ItemData[i].BaseMeanvalue + '"    /></td>';
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtbasesdvalue"   class=' + level + ' value="' + ItemData[i].BaseSDvalue + '"  /></td>';
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtbasecvper"  class=' + level + ' value="' + ItemData[i].BaseCVPercentage + '"   /></td>';
                            mydata += '<td align="left" ><input readonly="readonly" type="text" style="width:60px;" id="txtassayno"  class=' + level + ' value="' + ItemData[i].assayno + '"   /></td>';
                        }
                        else {
                            mydata += '<td align="left" ><input  type="text" style="width:60px;" id="txtminvalue" onkeyup="checkminvalue(this)" class=' + level + ' value="' + ItemData[i].Minvalue + '"  /></td>';
                            mydata += '<td align="left" ><input  type="text" style="width:60px;" id="txtmaxvalue" class=' + level + ' value="' + ItemData[i].Maxvalue + '" onkeyup="setsdvalue(this)"  /></td>';
                            mydata += '<td align="left" ><input  type="text" style="width:60px;" id="txtbaseminvalue"  class=' + level + ' value="' + ItemData[i].BaseMeanvalue + '"    /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbasesdvalue"   class=' + level + ' value="' + ItemData[i].BaseSDvalue + '"  /></td>';
                            mydata += '<td align="left" ><input  type="text" style="width:60px;" id="txtbasecvper"  class=' + level + ' value="' + ItemData[i].BaseCVPercentage + '"   /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtassayno"  class=' + level + ' value="' + ItemData[i].assayno + '"   /></td>';
                        }

                     
                        if (caneditsin == "0") {


                            if (ItemData[i].levelid == "1") {
                                mydata += '<td align="left" ><input type="text"  readonly="readonly" name="sinnolevel1" style="width:60px;" id="txtsinno"  class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                            else if (ItemData[i].levelid == "2") {
                                mydata += '<td align="left" ><input type="text" readonly="readonly" name="sinnolevel2" style="width:60px;" id="txtsinno" class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                            else {
                                mydata += '<td align="left" ><input type="text" readonly="readonly" name="sinnolevel3" style="width:60px;" id="txtsinno" class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                        }
                        else {
                            if (ItemData[i].levelid == "1") {
                                mydata += '<td align="left" ><input type="text"   name="sinnolevel1" style="width:60px;" id="txtsinno"  class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                            else if (ItemData[i].levelid == "2") {
                                mydata += '<td align="left" ><input type="text" name="sinnolevel2" style="width:60px;" id="txtsinno" class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                            else {
                                mydata += '<td align="left" ><input type="text"  name="sinnolevel3" style="width:60px;" id="txtsinno" class=' + level + ' value="' + ItemData[i].barcodeno + '"   /></td>';
                            }
                        }

                     
                        if (caneditsin == "0") {
                            if (ItemData[i].LockMachine == "0") {
                                if (ItemData[i].oldlock == "0") {
                                    mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox" disabled="true"  id="chlock" /></td>';
                                }
                                else {
                                    mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox"  disabled="true" id="chlock"  checked="checked"/></td>';
                                }
                                        
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox" disabled="true" id="chlock" checked="checked"/></td>';
                            }
                        }
                        else {
                            if (ItemData[i].LockMachine == "0") {
                                if (ItemData[i].oldlock == "0") {
                                    mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox"   id="chlock" /></td>';
                                }
                                else {
                                    mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox"   id="chlock"  checked="checked"/></td>';
                                }
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox"  id="chlock" checked="checked"/></td>';
                            }
                        }
                        //mydata += '<td>';
                        //if (ItemData[i].savedid != "") {
                        //    mydata += '<img id="sc" src="../../App_Images/tatdelay.gif" style="cursor:pointer;" onclick="openqcsheduling(this)" title="QC Scheduling" />';
                        //}
                        //mydata += '</td>';
                    
                        mydata += '<td>';
                        if (ItemData[i].savedid != "" && caneditsin=="1") {
                            mydata += '<img id="delme" src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="removerow(this)"/>';
                        }
                        mydata += '</td>';
                        mydata += '<td align="left" id="LevelID" style="font-weight:bold;display:none;">' + ItemData[i].levelid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="savedid"  style="display:none;">' + ItemData[i].savedid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_ID"  style="display:none;">' + ItemData[i].LabObservation_ID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="ParameterName" style="display:none;" >' + ItemData[i].LabObservation_Name + '</td>';

                        mydata += '<td class="GridViewLabItemStyle"  id="refminvalue" style="display:none;" >' + ItemData[i].refminvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="refmaxvalue" style="display:none;" >' + ItemData[i].refmaxvalue + '</td>';
                        mydata += "</tr>";
                        obsid = ItemData[i].LabObservation_ID;
                        $('#tblitemlist').append(mydata);
                        $('#btnsave').show();

                    }

                    $("#<%=ddlprocessinglab.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=ddlmachine.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=ddlcontrol.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                  
                    //$.unblockUI();
                  

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }


        function deleterow(itemid) {
           
            $("#tblitemlist").find('[name="'+$(itemid).closest('tr').attr('name')+'"]').remove();

        
        }

        function removerow(ctrl) {
            if (confirm("Do You want To Remove Mapping.?")) {
                //$.blockUI();
                jQuery.ajax({
                    url: "ControlCentreMapping.aspx/RemoveData",
                    data: '{savedid:"' + $(ctrl).closest('tr').find('#savedid').html() + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Mapping Removed");
                            var table = document.getElementById('tblitemlist');
                            table.deleteRow(ctrl.parentNode.parentNode.rowIndex);

                        }

                        //$.unblockUI();


                    },
                    error: function (xhr, status) {
                        //$.unblockUI();
                        alert("Error ");
                    }
                });
            }
        }

        function addme(ctrl) {

            var nn= Math.random();


            var labobsid1 = $(ctrl).closest('tr').attr('id');
            var labobsid2 = $(ctrl).closest('tr').attr('id').replace('Level1', 'Level2');
            var labobsid3 = $(ctrl).closest('tr').attr('id').replace('Level1', 'Level3');




            var $tr1 = $('#tblitemlist tr#' + labobsid1);
            var $clone1 = $tr1.clone();
            $clone1.attr('id', $clone1.attr('id').replace('Level', 'new'));
            $clone1.find('#txtassayno').val('');
            $clone1.find('#savedid').html('');
            $clone1.find('#l1').html('');
            $clone1.find('#p1').html('');
            $clone1.find('#delme').hide();
            $clone1.find('#aimg').hide();
            $clone1.attr('name', nn);
            $clone1.find('#dimg').show();
            $clone1.css("background-color", "yellow");
            $clone1.css("border-top", "0px");
          
            if ($('table#tblitemlist').find('#' + labobsid2).length == 0) {
                $tr1.after($clone1);
            }
            else {
                var $tr2 = $('#tblitemlist tr#' + labobsid2);
                var $clone2 = $tr2.clone();
                $clone2.find('#txtassayno').val('');
                $clone2.find('#savedid').html('');
                $clone2.find('#l1').html('');
                $clone2.find('#p1').html('');
                $clone2.attr('id', $clone2.attr('id').replace('Level', 'new'));
                $clone2.find('#aimg').hide();
                $clone2.attr('name', nn);
                $clone2.find('#delme').hide();
                $clone2.css("background-color", "yellow");
                $clone2.css("border-top", "0px");


                if ($('table#tblitemlist').find('#' + labobsid3).length == 0) {
                    $tr2.after($clone2);
                    $tr2.after($clone1);
                }
                else {
                    var $tr3 = $('#tblitemlist tr#' + labobsid3);
                    var $clone3 = $tr3.clone();
                    $clone3.find('#txtassayno').val('');
                    $clone3.find('#savedid').html('');
                    $clone3.attr('id', $clone3.attr('id').replace('Level', 'new'));
                    $clone3.find('#aimg').hide();
                    $clone3.find('#l1').html('');
                    $clone3.find('#p1').html('');
                    $clone3.attr('name', nn);
                    $clone3.find('#delme').hide();
                    $clone3.css("background-color", "yellow");
                    $clone3.css("border-top", "0px");
                    $tr3.after($clone3);
                    $tr3.after($clone2);
                    $tr3.after($clone1);
                }

            }
        }
        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "trheader") {

                    if ($(ctr).is(":checked")) {

                        $(this).find('#ch').attr('checked', true);
                    }
                    else {
                        $(this).find('#ch').attr('checked', false);
                    }


                }
            });
        }
    </script>


    <script type="text/javascript">

        function checkduplicateassayno(ctrl) {

return "";
            var LabObservation_ID = $(ctrl).closest('tr').find('#LabObservation_ID').html();

            var assayno = $(ctrl).val();
            if ($.trim(assayno) != "") {
                //$.blockUI();
                var a = 0;
                $('#tblitemlist tr').each(function () {
                   
                    var oldassayno = $(this).find("#txtassayno").val();
                    if ($.trim(assayno).toUpperCase() == $.trim(oldassayno).toUpperCase()) {
                        a = a + 1;
                    }
                });

                if (a > 1) {
                    $(ctrl).val('');
                    $(ctrl).focus();
                    showerrormsg('This Assay No Already Exist.!');
                    //$.unblockUI();
                    return;
                }



                $.ajax({
                    url: "ControlCentreMapping.aspx/checkduplicateassayno",
                    data: '{LabObservation_ID:"' + LabObservation_ID + '",assayno:"' + assayno + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                       
                        if (Number(result.d) > 0) {
                            $(ctrl).val('');
                            $(ctrl).focus();
                            showerrormsg('This Assay No Already Exist.!');
                          
                        }
                        //$.unblockUI();

                    },
                    error: function (xhr, status) {

                        //$.unblockUI();

                    }
                });

            }



        }


        function checkduplicatebarcodeno(ctrl) {
         return "";
            var savedid = $(ctrl).closest('tr').find('#savedid').html();
            var level=$(ctrl).attr('id').split('level')[1];
            

            var barcodeno = $(ctrl).val();
            if ($.trim(barcodeno) != "") {
                //$.blockUI();
                var a = 0;
                $('#tblitemlist tr').each(function () {
                    var oldbarcodeno1 = $(this).find("#txtbarcodenolevel1").val();
                    var oldbarcodeno2 = $(this).find("#txtbarcodenolevel2").val();
                    var oldbarcodeno3 = $(this).find("#txtbarcodenolevel3").val();

                    if (level == "1") {
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno2).toUpperCase())) {
                            a = a + 1;
                        }
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno3).toUpperCase())) {
                            a = a + 1;
                        }
                    }
                    else if (level == "2") {
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno1).toUpperCase())) {
                            a = a + 1;
                        }
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno3).toUpperCase())) {
                            a = a + 1;
                        }
                    }
                    else if (level == "3") {
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno1).toUpperCase())) {
                            a = a + 1;
                        }
                        if (($.trim(barcodeno).toUpperCase() == $.trim(oldbarcodeno2).toUpperCase())) {
                            a = a + 1;
                        }
                    }
                   
                   
                   
                });

                if (a > 0) {
                    $(ctrl).val('');
                    $(ctrl).focus();
                    showerrormsg('This Sin No Already Exist.!');
                    //$.unblockUI();
                    return;
                }



                $.ajax({
                    url: "ControlCentreMapping.aspx/checkduplicatesinno",
                    data: '{barcodeno:"' + barcodeno + '",savedid:"' + savedid + '",level:"' + level + '",lotnumber:"' + $('#<%=ddlcontrol.ClientID%>').val() + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        if (Number(result.d) > 0) {
                            $(ctrl).val('');
                            $(ctrl).focus();
                            showerrormsg('This Sin No Already Exist.!');

                        }
                        //$.unblockUI();

                    },
                    error: function (xhr, status) {

                        //$.unblockUI();

                    }
                });

            }



        }


        function resetdata() {
            $('#tblitemlist tr').slice(1).remove();
            $('#spn').html('');
            $('#btnsave').hide();
            $("#<%=ddlprocessinglab.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $("#<%=ddlmachine.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $('#<%=ddlcontrol.ClientID%> option').remove();
            $('#<%=ddlcontrol.ClientID%>').attr("disabled", false).trigger('chosen:updated');
            $("input[type='text']").val("");
           
        }

    </script>


    <script type="text/javascript">

        function getparameterlist() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true && $(this).closest('tr').find('#txtsinno').val()!="") {

                    var objcontroldata = new Object();
                    objcontroldata.CentreId = $('#<%=ddlprocessinglab.ClientID%>').val();
                    objcontroldata.ControlID = $('#<%=ddlcontrol.ClientID%>').val();
                    objcontroldata.ControlName = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[0].trim();
                    objcontroldata.LotNumber = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[1].trim();

                    objcontroldata.MachineID = $('#<%=ddlmachine.ClientID%>').val().split('#')[0].trim();
                    objcontroldata.MachineGroupId = $('#<%=ddlmachine.ClientID%>').val().split('#')[1].trim();


                    objcontroldata.LabObservation_ID = $(this).closest('tr').find('#LabObservation_ID').html();
                    objcontroldata.LabObservation_Name = $(this).closest('tr').find('#ParameterName').html();
                    objcontroldata.AssayNo = $(this).closest('tr').find('#txtassayno').val();

                    objcontroldata.LockMachine = $(this).closest("tr").find("#chlock").prop('checked') == true ? 1 : 0;


                    objcontroldata.LevelID = $(this).closest('tr').find('#LevelID').html();
                    objcontroldata.Level = $(this).closest('tr').find('#Level').html();
                   
                    objcontroldata.BarcodeNo = $(this).closest('tr').find("#txtsinno").val();
                    objcontroldata.MinValue = $(this).closest('tr').find('#txtminvalue').val();
                    objcontroldata.MaxValue = $(this).closest('tr').find('#txtmaxvalue').val();
                    objcontroldata.BaseMeanValue = $(this).closest('tr').find('#txtbaseminvalue').val();
                    objcontroldata.BaseSDValue = $(this).closest('tr').find('#txtbasesdvalue').val();
                    objcontroldata.BaseCVPercent = $(this).closest('tr').find('#txtbasecvper').val();

                    objcontroldata.savedid = $(this).closest('tr').find('#savedid').html();

                    dataIm.push(objcontroldata);
                }
            }
            );
            return dataIm;

        }


        function validation(flag) {


            if ($('#tblitemlist tr').length == 0) {
                showerrormsg("Please Search Data..!");
                return false;
            }


            var s11 = 0;
            $('#tblitemlist tr').each(function () {

                if ($(this).attr("id") != "trheader" && $(this).find("#ch").is(':checked')) {
                    if ($(this).find('#txtsinno').val() == "") {
                        s11 = 1;
                        $(this).find('#txtsinno').focus();
                        return;
                    }
                }
            });

            if (s11 == 1) {
                showerrormsg("Please Enter Sin No");
                return false;
            }

           

                var s11 = 0;
                $('#tblitemlist tr').each(function () {

                    if ($(this).attr("id") != "trheader" && $(this).find("#ch").is(':checked')) {
                        if ($(this).find('#txtassayno').val() == "") {
                            s11 = 1;
                            $(this).find('#txtassayno').focus();
                            return;
                        }
                    }
                });

                if (s11 == 1) {
                    showerrormsg("Please Enter Assay No");
                    return false;
                }

               


            return true;
        }


       

        function savedata() {

            if (validation() == false) {
                return;
            }

            var datatosave = getparameterlist();
         
            if (datatosave.length == 0) {
                showerrormsg("Please Select Data");
                return;
            }

            //$.blockUI();
            $.ajax({
                url: "ControlCentreMapping.aspx/SaveData",
                data: JSON.stringify({  controldata: datatosave }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         //$.unblockUI();
                         var save = result.d;
                         if (save == "1") {
                             showmsg("Record Saved Successfully");

                             searchparameter();

                         }
                         else {
                             showerrormsg(save);

                             // console.log(save);
                         }
                     },
                     error: function (xhr, status) {
                         //$.unblockUI()
                         showerrormsg("Some Error Occure Please Try Again..!");

                         console.log(xhr.responseText);
                     }
                 });

        }

        
    </script>

    <script type="text/javascript">
        function setsdvalue(ctrl) {
            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));

            var Maxvalue1 = $(ctrl).closest("tr").find("#txtmaxvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtmaxvalue").val());
            var refmaxvalue = $(ctrl).closest("tr").find("#refmaxvalue").text() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#refmaxvalue").text());

            if (parseFloat(Maxvalue1) > parseFloat(refmaxvalue)) {
                showerrormsg("Min Value should be less equal " + refmaxvalue);
                $(ctrl).val(refmaxvalue);
            }


            var Minvalue = $(ctrl).closest("tr").find("#txtminvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtminvalue").val());
            var Maxvalue = $(ctrl).closest("tr").find("#txtmaxvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtmaxvalue").val());
            var Meanvalue = precise_round((Minvalue + Maxvalue) / 2, 2);

            var sdvalue = precise_round((Maxvalue - Meanvalue) / 2, 2);
            $(ctrl).closest("tr").find("#txtbaseminvalue").val(Meanvalue);
            $(ctrl).closest("tr").find("#txtbasesdvalue").val(sdvalue);
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function checkminvalue(ctrl) {
            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));
            var Minvalue = $(ctrl).closest("tr").find("#txtminvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtminvalue").val());
            var refminvalue = $(ctrl).closest("tr").find("#refminvalue").text() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#refminvalue").text());

            if (parseFloat(Minvalue) < parseFloat(refminvalue)) {
                showerrormsg("Min Value should be greater equal " + refminvalue);
                $(ctrl).val(refminvalue);
            }

        }
    </script>

   
</asp:Content>

