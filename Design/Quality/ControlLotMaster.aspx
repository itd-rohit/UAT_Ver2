<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ControlLotMaster.aspx.cs" Inherits="Design_Quality_ControlLotMaster" %>
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

      <style type="text/css">
          #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
           
            width: 905px;
            left: 15%;
            top: 12%;
           
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
           
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 5px; 
            background-color: #d7edff;
            border-radius: 5px;
        }

          .chosen-container {
              width: 100% !important;
          }
          #ContentPlaceHolder1_ddldepartment_chosen {
                width: 205px !important;
          }
          #ContentPlaceHolder1_ddlmachine_chosen {
                width: 303px !important;
          }

           #ContentPlaceHolder1_ddlcontrolprovider_chosen {
                width: 700px !important;
          }
          #ContentPlaceHolder1_ddlcontrolname_chosen {
                width: 700px !important;
          }
           #ContentPlaceHolder1_ddllotnumber_chosen {
                width: 700px !important;
          }
          </style>
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
                          <b>Control Master</b>  

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
                        <td style="font-weight: 700; color: #FF0000;">Control Provider :</td>

                        <td>
                            <asp:TextBox ID="txtcontrolprovider" runat="server" Width="300px" Style="text-transform: uppercase;"  />
                        </td>

                         <td style="font-weight: 700; color: #FF0000;">Control Name :</td>
                         <td> 
                            <asp:TextBox ID="txtcontrolname" runat="server" Width="400px" Style="text-transform: uppercase;"  />
                             <asp:TextBox ID="txtcontrolid" runat="server"  style="display:none;" />
                             &nbsp;&nbsp;
                             <input type="button" id="btnfromgrn" value="Select From GRN" style="cursor:pointer;font-weight:bold;color:white;background-color:maroon;" onclick="openmybox()" />
                            
                        </td>
                       
                        
                       
                    </tr>
                    <tr>
                        <td style="font-weight: 700; color: #FF0000;">Lot Number :</td>

                        <td>
                            <asp:TextBox ID="txtlotnumber" runat="server" Width="150px" Style="text-transform: uppercase;"  />
                            &nbsp; <span style="color: #FF0000"><strong>Start Date :</strong></span>
                             <asp:TextBox ID="txtDateStart" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtDateStart" PopupButtonID="txtDateStart" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                        </td>

                        <td style="font-weight: 700;color: #FF0000;">Lot Expiry :</td>
                         <td> 
                               <asp:TextBox ID="txtlotexpiry" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtlotexpiry" PopupButtonID="txtlotexpiry" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                             

                             &nbsp; <strong>Department :</strong>
                              <asp:DropDownList ID="ddldepartment" runat="server"  Width="205px" class="ddldepartment chosen-select"   ></asp:DropDownList> 

                         </td>
                       
                        
                       
                    </tr>
                  
                    <tr>
                        <td style="font-weight: 700; color: #FF0000;">Machine :</td>

                        <td>
                            <asp:DropDownList ID="ddlmachine" runat="server"  Width="303px" class="ddlmachine chosen-select"   ></asp:DropDownList>
                            &nbsp;&nbsp;
                            <img src="../../App_Images/view.GIF"  style="cursor:pointer;"  onclick="viewmachineparameter()" title="Click to View All LabObservation" />
                           
                          
                            
                        </td>

                         <td style="font-weight: 700; color: #FF0000;">Lab Observation :</td>
                         <td> 

                              

                             <table width="99%">
                <tr>
                    <td width="60%">
                        <div class="ui-widget" style="display: inline-block;">
                                        <input type="hidden" id="theHidden" />

                                        <input id="ddlInvestigation" size="50"  style="text-transform: uppercase;"  />
                                    </div>
                    </td>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lemonchiffon;" >
                                &nbsp;&nbsp;</td>
                    <td>New Data</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #c0fff6;" >
                                &nbsp;&nbsp;</td>
                    <td>Saved Data</td>
                     
                   
                    
                </tr>
            </table>
                         </td>
                       
                        
                       
                    </tr>
                   
                    
                   
                 
                  

                 
                   
                    
                   
                 <tr>
                      <td colspan="4">
                          <div  style="width:1295px; max-height:400px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trheader">
                        
                          <td class="GridViewHeaderStyle" style="width: 40px;">Sr.No</td>
                          <td class="GridViewHeaderStyle">LabObservation ID</td>
                          <td class="GridViewHeaderStyle">LabObservation Name</td>
                          <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                          <td class="GridViewHeaderStyle" style="width:55px;">Level</td>
                          <td class="GridViewHeaderStyle" style="width:85px;">Min Value</td>
                          <td class="GridViewHeaderStyle" style="width:85px;">Max Value</td>
                          <td class="GridViewHeaderStyle" style="width:115px;">Base Mean Value</td>
                          <td class="GridViewHeaderStyle" style="width:115px;">Base SD Value</td>
                          <td class="GridViewHeaderStyle" style="width:110px;">Base CV (%)</td>
                          <td class="GridViewHeaderStyle" style="width:85px;">Unit</td>
                          <td class="GridViewHeaderStyle" style="width:95px;">Temperature</td>
                          <td class="GridViewHeaderStyle" style="width:145px;">Method</td>
                          <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                       
                    </tr>
                </table>
                </div>
                          </td>
                 </tr>
                  

                    
                   
                    
                   
                 
                  

                     <tr>
                       

                        <td colspan="4" align="center">
                            <input type="button" value="Save" class="savebutton" onclick="savemenow()" id="btnsave" style="display:none;" />
                            <input type="button" value="Update" class="savebutton" onclick="updatenow()" id="btnupdate" style="display:none;" />&nbsp;&nbsp;&nbsp;
                            
                            <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                            </td>
                         </tr>
                    </table>
                </div>

         </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div class="Purchaseheader">
                      <table width="90%">
                <tr >
                  <td>  Control List</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;cursor:pointer;" onclick="binddata('1')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Active</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;cursor:pointer;" onclick="binddata('0')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                 <td>DeActive or Expired</td>
                    
                    </tr>
                             </table>
                  </div>
                 <div  style="width:1295px; max-height:400px;overflow:auto;">
                   <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="trhead">
                                       <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       <td class="GridViewHeaderStyle" style="width: 20px;">View</td>
                                       <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                                       
                                       <td class="GridViewHeaderStyle">Control Provider</td>
                                       <td class="GridViewHeaderStyle">Control Name</td>
                                       <td class="GridViewHeaderStyle">Lot Number</td>
                                       <td class="GridViewHeaderStyle">Department</td>
                                       <td class="GridViewHeaderStyle">Machine</td>
                                       <td class="GridViewHeaderStyle">LabObservation</td>
                                       <td class="GridViewHeaderStyle">Start Date</td>
                                       <td class="GridViewHeaderStyle">Lot Expiry</td>
                                       <td class="GridViewHeaderStyle">Status</td>
                                       <td class="GridViewHeaderStyle">Entry Date</td>
                                       <td class="GridViewHeaderStyle">Entry BY</td>
                                       <td class="GridViewHeaderStyle" style="width: 50px;">DeActive</td>
                                     </tr>
                                 </table>
                </div>
             </div>

         
         </div>

         </div>

         <asp:Panel ID="Paneldetail" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width:1100px; background-color: whitesmoke;">
            <div style="text-align:center;">
                <span id="spn0" style="font-weight:bold;"></span><br />
                <span id="spn" style="font-weight:bold;"></span><br />
                <span id="spn1" style="font-weight:bold;"></span><br />
                <span id="spn2" style="font-weight:bold;"></span>

            </div>
             <div class="Purchaseheader">
               Parameter List 
            </div>
              <div style="width:100%;max-height:200px;overflow:auto;width:100%;">
            <table id="tblparameterlist" frame="box" rules="all" border="1" style="font-size:13px;width:99%">
                 <tr id="tr1">
                                       <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                      <td class="GridViewHeaderStyle">LabObservation ID</td>
                                       <td class="GridViewHeaderStyle">LabObservation Name</td>
                                       <td class="GridViewHeaderStyle">Level</td>
                                       <td class="GridViewHeaderStyle">Minvalue</td>
                                       <td class="GridViewHeaderStyle">Maxvalue</td>
                                       <td class="GridViewHeaderStyle">BaseMeanvalue</td>
                                       <td class="GridViewHeaderStyle">Base SD Value</td>
                                       <td class="GridViewHeaderStyle">Base CV %</td>
                                       <td class="GridViewHeaderStyle">Unit</td>
                                       <td class="GridViewHeaderStyle">Temperature</td>
                                       <td class="GridViewHeaderStyle">Method</td>           
                                     </tr>
            </table>
                  </div>
           


           
            <center>
               
                <asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
            </center>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modeldetail" runat="server" CancelControlID="btncloseme" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Paneldetail">
    </cc1:ModalPopupExtender>



     <asp:Panel ID="Panel1" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width:700px; background-color: whitesmoke;">


            <div style="width:100%;max-height:300px;overflow:auto;width:100%;">
            <table id="tblparameterlist1" frame="box" rules="all" border="1" style="font-size:13px;width:99%">
                 <tr id="tr2">
                                       <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                      <td class="GridViewHeaderStyle" style="width: 50px;">Select</td>
                                      <td class="GridViewHeaderStyle">LabObservation ID</td>
                                       <td class="GridViewHeaderStyle">LabObservation Name</td>
                                               
                                     </tr>
            </table>
                  </div>
 <center>
               
                <input type="button" value="Add Parameter" class="savebutton" onclick="addparameter()" />
                <asp:Button ID="btncloseme1" runat="server" CssClass="resetbutton" Text="Close" />
            </center>

            </div>

         
         </asp:Panel>
       <cc1:ModalPopupExtender ID="modeldetail1" runat="server" CancelControlID="btncloseme1" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1">
    </cc1:ModalPopupExtender>

          <asp:Button ID="Button1" runat="server" Style="display: none;" />



     <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position:absolute;right:-20px;top:-20px;width:36px;height:36px;cursor:pointer;" title="Close" />
              
            <div class="POuter_Box_Inventory" style="width:900px;">

                 <div class="Purchaseheader" style="text-align:center">
               Select Control From GRN
            </div>


              <table width="100%">
                  <tr>
                      <td style="font-weight: 700; color: #FF0000;">Control Provider :</td>

                      <td>
                           <asp:DropDownList ID="ddlcontrolprovider" runat="server" Width="500px" class="ddlcontrolprovider chosen-select" onchange="bindcontrolname()"></asp:DropDownList>

                      </td>
                  </tr>
                  <tr>
                       <td style="font-weight: 700; color: #FF0000;">Control Name :</td>
                      <td>
                           <asp:DropDownList ID="ddlcontrolname" runat="server" Width="500px" class="ddlcontrolname chosen-select" onchange="bindbatchnumber()" ></asp:DropDownList>

                      </td>


                  </tr>

                  <tr>
                       <td style="font-weight: 700; color: #FF0000;">Lot Number :</td>
                      <td>
                          <asp:DropDownList ID="ddllotnumber" runat="server" Width="500px" class="ddllotnumber chosen-select" onchange="setexpirydate()" ></asp:DropDownList>
                      </td>

                  </tr>
                  <tr>
                      <td style="font-weight: 700; color: #FF0000;">Lot Expiry :</td>
                      <td>
                           <asp:TextBox ID="txtlotexpiry1" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                      </td>
                  </tr>

                  <tr>
                      <td colspan="2" align="center">
                          <input type="button" value="Select" class="savebutton" onclick="setmycontrol()" />
                      </td>
                  </tr>
              </table>
                </div>
         </div>
    <script type="text/javascript">
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
                 
          
            binddata('1');

        });



        function binddata(type) {

            //$.blockUI();
            $('#tbl tr').slice(1).remove();
            $.ajax({
                url: "ControlLotMaster.aspx/getdata",
                data: '{type:"' + type + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {

                        //$.unblockUI();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var color = "lightgreen";
                            if (ItemData[i].IsActive == "DeActive" || ItemData[i].IsActive == "Expired") {
                                color = "pink";
                            }
                            var mydata = "<tr style='background-color:" + color + ";' id='" + ItemData[i].controlid + "'>";
                            mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" ><img src="../../App_Images/details_open.png" style="cursor:pointer;" onclick="viewdetail(this)"/></td>';
                            if (ItemData[i].IsActive == "Active" || ItemData[i].IsActive == "Expired") {
                                mydata += '<td class="GridViewLabItemStyle" ><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="editetail(this)"/></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"  ></td>';
                            }
                         
                            mydata += '<td class="GridViewLabItemStyle"  id="ControlProvider">' + ItemData[i].ControlProvider + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="controlname" style="font-weight:bold;">' + ItemData[i].controlname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="lotnumber" style="font-weight:bold;">' + ItemData[i].lotnumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="SubCategoryName">' + ItemData[i].SubCategoryName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="machinename">' + ItemData[i].machinename + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="parameter">' + ItemData[i].parameter + '</td>';
                            
                            
                            mydata += '<td class="GridViewLabItemStyle"  id="startdate" style="font-weight:bold;">' + ItemData[i].startdate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="LotExpiry" style="font-weight:bold;">' + ItemData[i].LotExpiry + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="IsActive" style="font-weight:bold;">' + ItemData[i].IsActive + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryDate">' + ItemData[i].EntryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryByName">' + ItemData[i].EntryByName + '</td>';

                            
                          

                            mydata += '<td class="GridViewLabItemStyle"  id="SubCategoryID" style="display:none;">' + ItemData[i].SubCategoryID + '</td>';

                            mydata += '<td class="GridViewLabItemStyle"  id="Machineid" style="display:none;">' + ItemData[i].Machineid + '</td>';


                            mydata += '<td>';
                            if (ItemData[i].IsActive == "Active" || ItemData[i].IsActive == "Expired") {
                                mydata += '<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/>';
                            }
                            else {
                                mydata += '<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showerrormsg(\'' + ItemData[i].Deactivby + '\');" />';
                            }
                            mydata += '</td>';

                            mydata += "</tr>";
                            $('#tbl').append(mydata);

                        }
                        //$.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }


        function viewdetail(ctrl) {
            var id = $(ctrl).closest('tr').attr('id');
            $('#spn0').html("<label style='color:red;'>Control Provider : </label>" + $(ctrl).closest('tr').find('#ControlProvider').html());
            $('#spn').html("<label style='color:red;'>Control Name : </label>" + $(ctrl).closest('tr').find('#controlname').html() + "   <label style='color:red;'>Lot Number : </label>" + $(ctrl).closest('tr').find('#lotnumber').html());
            $('#spn1').html("<label style='color:red;'>Machine Name : </label>" + $(ctrl).closest('tr').find('#machinename').html() + "   <label style='color:red;'>Department : </label>" + $(ctrl).closest('tr').find('#SubCategoryName').html());
            $('#spn2').html("<label style='color:red;'>Start Date : </label>" + $(ctrl).closest('tr').find('#startdate').html() + "   <label style='color:red;'>Lot Expiry </label>" + $(ctrl).closest('tr').find('#LotExpiry').html());

          

            $('#tblparameterlist tr').slice(1).remove();
          
            //$.blockUI();
            $.ajax({
                url: "ControlLotMaster.aspx/bindparametersaved",
                data: '{id:"' + id + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        //$.unblockUI();
                        return;
                    }
                   
                    for (i = 0; i < ItemData.length; i++) {
                        var mydata = "<tr style='background-color:lightgreen;' id='" + ItemData[i].LabObservation_Id + "'>";
                        mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"   style="font-weight:bold;">' + ItemData[i].LabObservation_Id + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"   style="font-weight:bold;">' + ItemData[i].LabObservation_Name + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  style="font-weight:bold;">' + ItemData[i].LEVEL + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Minvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Maxvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].BaseMeanvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].BaseSDvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].BaseCVPercentage + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Unit + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Temperature + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Method + '</td>';
                        mydata += "</tr>";
                        $('#tblparameterlist').append(mydata);
                     
                    }

                    
                    $find("<%=modeldetail.ClientID%>").show();
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });




            
        }




        function editetail(ctrl) {
            var id = $(ctrl).closest('tr').attr('id');
            $('#<%=txtcontrolid.ClientID%>').val(id);
            $('#<%=txtcontrolprovider.ClientID%>').val($(ctrl).closest('tr').find('#ControlProvider').html());
            $('#<%=txtcontrolname.ClientID%>').val($(ctrl).closest('tr').find('#controlname').html()).attr("disabled", true);
            $('#<%=txtlotnumber.ClientID%>').val($(ctrl).closest('tr').find('#lotnumber').html()).attr("disabled", true);
            $('#<%=txtDateStart.ClientID%>').val($(ctrl).closest('tr').find('#startdate').html());
            $('#<%=txtlotexpiry.ClientID%>').val($(ctrl).closest('tr').find('#LotExpiry').html());
            if ($(ctrl).closest('tr').find('#SubCategoryID').html() != "0") {
                $("#<%=ddldepartment.ClientID%>").val($(ctrl).closest('tr').find('#SubCategoryID').html()).trigger('chosen:updated');

            }
            
            $("#<%=ddlmachine.ClientID%>").val($(ctrl).closest('tr').find('#Machineid').html()).attr("disabled", true).trigger('chosen:updated');
            $('#btnupdate').show();
            $('#btnfromgrn').hide();

            $('#tblitemlist tr').slice(1).remove();

            //$.blockUI();
            $.ajax({
                url: "ControlLotMaster.aspx/bindparametersaved",
                data: '{id:"' + id + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        return;
                    }
                    var obsid = "";
                    for (i = 0; i < ItemData.length; i++) {
                        var id = ItemData[i].LabObservation_Id + "_Level" + ItemData[i].LevelID;
                       
                        if ($('table#tblitemlist').find('#' + id).length == 0) {
                            var level = 'Level' + ItemData[i].LevelID;
                            var mydata = '';
                            if (ItemData[i].LabObservation_Id !=obsid ) {
                                mydata += '<tr style="background-color:#c0fff6;border-top:4px solid lightgray;" class="GridViewItemStyle tr_' + ItemData[i].LabObservation_Id + '" id=' + id + ' >';
                               
                            }
                            else {
                                mydata += '<tr style="background-color:#c0fff6;" class="GridViewItemStyle tr_' + ItemData[i].LabObservation_Id + '" id=' + id + ' >';
                            }
                            mydata += '<td align="left" >' + parseFloat(i + 1) + '</td>';
                            mydata += '<td align="left" id="ParameterID" style="font-weight:bold;">' + ItemData[i].LabObservation_Id + '</td>';
                            mydata += '<td align="left" id="Parameter" style="font-weight:bold;">' + ItemData[i].LabObservation_Name + '</td>';
                            mydata += '<td align="left" ><input type="checkbox" id="chk"  checked="checked" /></td>';
                            mydata += '<td align="left" id="Level" style="font-weight:bold;">' + level + '</td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtminvalue" class=' + level + ' value="' + ItemData[i].Minvalue + '"  /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtmaxvalue" class=' + level + ' value="' + ItemData[i].Maxvalue + '" onkeyup="setsdvalue(this)"  /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbaseminvalue" readonly="true" class=' + level + ' value="' + ItemData[i].BaseMeanvalue + '"    /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbasesdvalue" readonly="true"  class=' + level + ' value="' + ItemData[i].BaseSDvalue + '"  /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbasecvper" readonly="true" class=' + level + ' value="' + ItemData[i].BaseCVPercentage + '"   /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtunit" class=' + level + ' value="' + ItemData[i].Unit + '"   /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:60px;" id="txttemp" class=' + level + '  value="' + ItemData[i].Temperature + '"  /></td>';
                            mydata += '<td align="left" ><input type="text" style="width:140px;" id="txtmethod" class=' + level + ' value="' + ItemData[i].Method + '"   /></td>';
                            if (ItemData[i].LevelID == 1) {
                                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownewlevel(\'' + ItemData[i].LabObservation_Id + '\')"/></td>';
                            }
                            else {
                                 mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownewlevel(\'' + ItemData[i].LabObservation_Id + '\')"/></td>';
                            }
                            mydata += '<td align="left" style="display:none;" id="savedid">' + ItemData[i].id + '</td>';
                            mydata += '</tr>';

                            $('#tblitemlist').append(mydata);

                            obsid = ItemData[i].LabObservation_Id;
                         

                       }
                       else {
                           showerrormsg(itemname + " Already Added.");
                       }

                    }


                
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });


        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function setsdvalue(ctrl) {
            $(ctrl).val($(ctrl).val().replace(/[^0-9\.]/g, ''));
            var Minvalue = $(ctrl).closest("tr").find("#txtminvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtminvalue").val());
            var Maxvalue = $(ctrl).closest("tr").find("#txtmaxvalue").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtmaxvalue").val());
            var Meanvalue = precise_round((Minvalue + Maxvalue) / 2, 2);

            var sdvalue = precise_round((Maxvalue - Meanvalue) / 2, 2);
            $(ctrl).closest("tr").find("#txtbaseminvalue").val(Meanvalue);
            $(ctrl).closest("tr").find("#txtbasesdvalue").val(sdvalue);
        }

        function deleterownew(itemid) {
            if (confirm("Do You Want To Deactive This Control?")) {
                var id = $(itemid).closest('tr').attr('id');

                //$.blockUI();


                jQuery.ajax({
                    url: "ControlLotMaster.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                   
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Control Deactive..");
                            //$.unblockUI();
                            binddata('1');
                        }
                        else {
                            //$.unblockUI();
                            showerrormsg(result.d);
                        }
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }


        </script>

    <script type="text/javascript">

        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {


            return split(term).pop();
        }
        $(function () {
            $("#ddlInvestigation")
                  // don't navigate away from the field on tab when selecting an item
                  .bind("keydown", function (event) {
                      if (event.keyCode === $.ui.keyCode.TAB &&
                          $(this).autocomplete("instance").menu.active) {
                          event.preventDefault();
                      }

                      if ($("#<%=ddlmachine.ClientID%>").val() == "0") {
                          showerrormsg("Please Select Machine");
                          $("#<%=ddlmachine.ClientID%>").focus();
                          $("#ddlInvestigation").val('');
                          return;
                      }

                    

                  })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          $.ajax({
                              url: "ControlLotMaster.aspx/bindparameter",
                              data: '{parametername:"' + extractLast(request.term) + '",machineid:"' + $('#<%=ddlmachine.ClientID%>').val() + '"}',
                              contentType: "application/json; charset=utf-8",
                              type: "POST", // data has to be Posted 
                              timeout: 120000,
                              dataType: "json",
                              async: true,
                              success: function (result) {
                                  response($.map(jQuery.parseJSON(result.d), function (item) {
                                      return {
                                          label: item.PatameterName,
                                          value: item.LabObservation_ID
                                      }
                                  }))


                              },
                              error: function (xhr, status) {
                                  showerrormsg(xhr.responseText);
                              }
                          });
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

                          setdata(ui.item.value, ui.item.label);
                          // AddItem(ui.item.value);

                          return false;
                      },

                  });
        });


        function setdata(itemid, itemname) {
            var obsid = "";
            for (var a = 1; a <= 3;a++)
            {
                var i = $('#tblitemlist tr').length - 1;
                var id = itemid + "_Level" + a;
                if ($('table#tblitemlist').find('#' + id).length == 0) {
                    var level = 'Level' + a;
                    var mydata = '';
                    if (obsid != itemname) {
                        mydata += '<tr style="background-color:lemonchiffon;border-top:4px solid lightgray;" class="GridViewItemStyle tr_' + itemid + '" id=' + id + ' >';
                    }
                    else {
                        mydata += '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle tr_' + itemid + '" id=' + id + ' >';
                    }
                    mydata += '<td align="left" >' + parseFloat(i + 1) + '</td>';
                    mydata += '<td align="left" id="ParameterID" style="font-weight:bold;">' + itemid + '</td>';
                    mydata += '<td align="left" id="Parameter" style="font-weight:bold;">' + itemname + '</td>';
                    mydata += '<td align="left" ><input type="checkbox" id="chk"  onclick="setlevel(this,\'' + level + '\')" /></td>';
                    mydata += '<td align="left" id="Level" style="font-weight:bold;">' + level + '</td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtminvalue" class=' + level + ' disabled="disabled"  /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtmaxvalue" class=' + level + ' disabled="disabled" onkeyup="setsdvalue(this)"  /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbaseminvalue" readonly="true" class=' + level + ' disabled="disabled"   /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbasesdvalue" readonly="true" class=' + level + ' disabled="disabled"   /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtbasecvper" readonly="true" class=' + level + ' disabled="disabled"  /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txtunit" class=' + level + ' disabled="disabled"  /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:60px;" id="txttemp" class=' + level + ' disabled="disabled"  /></td>';
                    mydata += '<td align="left" ><input type="text" style="width:140px;" id="txtmethod" class=' + level + ' disabled="disabled"  /></td>';
                    if (a == 1) {
                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(\'' + itemid + '\')"/></td>';
                    }
                    else {
                        mydata += '<td></td>';
                    }
                    mydata += '<td align="left" style="display:none;" id="savedid">0</td>';
                    mydata += '</tr>';

                    $('#tblitemlist').append(mydata);
                    obsid = itemname;

                    $("#<%=ddlmachine.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    // $("#<%=ddldepartment.ClientID%>").attr("disabled", true).trigger('chosen:updated');

                    if ($('#<%=txtcontrolid.ClientID%>').val() == "") {
                        $('#btnsave').show();
                    }
                   
                }
                else {
                    showerrormsg(itemname+" Already Added.");
                }
            }
        }

      

        function setlevel(ctrl, tdid) {
            //if (tdid == "Level2") {
            //    var a = 0;
            //    var id = $(ctrl).closest('tr').attr("id").replace('Level2', 'Level1');
            //    if ($("#tblitemlist").find('#' + id).find('#chk').prop('checked') == false) {
            //        a = 1;
            //    }
            //    if (a == 1) {
            //        showerrormsg("Please Select Level1 First");
            //        $(ctrl).prop('checked',false);
            //        return;
            //    }
            //}
            //if (tdid == "Level3") {
            //    var a = 0;
            //    var id = $(ctrl).closest('tr').attr("id").replace('Level3', 'Level2');
            //    if ($("#tblitemlist").find('#' + id).find('#chk').prop('checked') == false) {
            //        a = 1;
            //    }
            //    if (a == 1) {
            //        showerrormsg("Please Select Level2 First");
            //        $(ctrl).prop('checked', false);
            //        return;
            //    }
            //}
            if (($(ctrl).prop('checked') == true)) {
                $(ctrl).closest('tr').find("." + tdid).prop('disabled', false);
                $(ctrl).closest('tr').find("." + tdid).val("");
            }
            else {
                //if (tdid == "Level1") {
                //    var id = $(ctrl).closest('tr').attr("id").replace('Level1', 'Level2');
                //    $("#tblitemlist").find('#' + id).find('#chk').prop('checked', false);
                //    $("#tblitemlist").find('#' + id).find("input[type='text']").prop('disabled', true).val("");

                //}
                //if (tdid == "Level2") {
                //    var id = $(ctrl).closest('tr').attr("id").replace('Level2', 'Level3');
                //    $("#tblitemlist").find('#' + id).find('#chk').prop('checked', false);
                //    $("#tblitemlist").find('#' + id).find("input[type='text']").prop('disabled', true).val("");
                //}


                $(ctrl).closest('tr').find("." + tdid).prop('disabled', true);
                $(ctrl).closest('tr').find("." + tdid).val("");
            }
        }

        function deleterow(trid) {
           
            $("#tblitemlist").find('.tr_' + trid).remove();
            if ($('#<%=txtcontrolid.ClientID%>').val() == "") {
                var i = $('#tblitemlist tr').length;
                if (i == 1) {
                    $("#<%=ddlmachine.ClientID%>").attr("disabled", false).trigger('chosen:updated');
                    $("#<%=ddldepartment.ClientID%>").attr("disabled", false).trigger('chosen:updated');
                    $('#btnsave').hide();
                }
            }
        }

        function deleterownewlevel(trid) {
            if (confirm("Do You Want To Delete This LabObservation ?")) {
                var id = "";
                $('#tblitemlist .tr_' + trid).each(function () {
                    id += $(this).closest('tr').find('#savedid').html() + ",";
                });
               

                jQuery.ajax({
                    url: "ControlLotMaster.aspx/deletedataparameter",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("LabObservation Deleted..");
                            $("#tblitemlist").find('.tr_' + trid).remove();
                        }
                        else {
                            showerrormsg(result.d);
                        }
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
           
        }

    </script>

         <script type="text/javascript">
             function resetme() {
                 $('#tblitemlist tr').slice(1).remove();
                 
                 $('#<%=txtcontrolid.ClientID%>').val('');
                 $('#<%=txtcontrolname.ClientID%>').val('').attr("disabled", false);
                 $('#<%=txtcontrolprovider.ClientID%>').val('');
                 $('#<%=txtlotnumber.ClientID%>').val('').attr("disabled", false);
                 $('#<%=txtDateStart.ClientID%>').val('');
                 $('#<%=txtlotexpiry.ClientID%>').val('');
                 $("#<%=ddlmachine.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
                 $("#<%=ddldepartment.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
                 $('#btnsave').hide();
                 $('#btnupdate').hide();
                 $('#btnfromgrn').show();
             }
         </script>

         <script type="text/javascript">
             function getparameterlist() {
                 var dataIm = new Array();
                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked')==true) {
                         var objcontroldata = new Object();
                         objcontroldata.MachineID = $('#<%=ddlmachine.ClientID%>').val();
                         objcontroldata.MachineName = $('#<%=ddlmachine.ClientID%> option:selected').text();
                         objcontroldata.Subcategoryid = $('#<%=ddldepartment.ClientID%>').val();
                         if ($('#<%=ddldepartment.ClientID%>').val() == "0") {
                             objcontroldata.SubcategoryName = "";
                         }
                         else {
                             objcontroldata.SubcategoryName = $('#<%=ddldepartment.ClientID%> option:selected').text();
                         }
                         objcontroldata.LabObservation_ID = id.split('_')[0];
                         objcontroldata.LabObservation_Name = $(this).closest('tr').find('#Parameter').html();
                         objcontroldata.LevelID = id.split('_')[1].replace('Level','');
                         objcontroldata.Level = id.split('_')[1];

                         objcontroldata.MinValue = $(this).closest('tr').find('#txtminvalue').val();
                         objcontroldata.MaxValue = $(this).closest('tr').find('#txtmaxvalue').val();
                         objcontroldata.BaseMeanValue = $(this).closest('tr').find('#txtbaseminvalue').val();
                         objcontroldata.BaseSDValue = $(this).closest('tr').find('#txtbasesdvalue').val();
                         objcontroldata.BaseCVPercent = $(this).closest('tr').find('#txtbasecvper').val();
                         objcontroldata.Unit = $(this).closest('tr').find('#txtunit').val();
                         objcontroldata.Temperature = $(this).closest('tr').find('#txttemp').val();
                         objcontroldata.Method = $(this).closest('tr').find('#txtmethod').val();
                         objcontroldata.SavedID = $(this).closest('tr').find('#savedid').html();
                         
                         dataIm.push(objcontroldata);
                     }
                 });
                 return dataIm;

             }

             function savemenow() {

                 if ($('#<%=txtcontrolprovider.ClientID%>').val() == "") {
                     $('#<%=txtcontrolprovider.ClientID%>').focus();
                     showerrormsg("Please Enter Control Provider");
                     return;

                 }

                 if ($('#<%=txtcontrolname.ClientID%>').val() == "") {
                     $('#<%=txtcontrolname.ClientID%>').focus();
                       showerrormsg("Please Enter Control Name");
                       return;

                 }

                 if ($('#<%=txtlotnumber.ClientID%>').val() == "") {
                     $('#<%=txtlotnumber.ClientID%>').focus();
                      showerrormsg("Please Enter Lot Number");
                      return;

                 }


                 if ($("#<%=ddlmachine.ClientID%>").val() == "0") {
                     showerrormsg("Please Select Machine");
                     $("#<%=ddlmachine.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=txtDateStart.ClientID%>").val() == "") {
                     showerrormsg("Please Select Start Date");
                     $("#<%=txtDateStart.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=txtlotexpiry.ClientID%>").val() == "") {
                     showerrormsg("Please Select Lot Expiry ");
                     $("#<%=txtlotexpiry.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=ddldepartment.ClientID%>").val() == "0") {
                     //showerrormsg("Please Select Department");
                    // $("#<%=ddldepartment.ClientID%>").focus();
                    // return;
                 }

                 if ($('#tblitemlist tr').length == 1) {
                     showerrormsg("Please Add LabObservation");
                     return;
                 }

                 var datatosave = getparameterlist();

                 if (datatosave.length == 0) {
                     showerrormsg("Please Select Level");
                     return;
                 }



                 var sn = 0;
                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                         if ($(this).find('#txtminvalue').val() =="") {
                             sn = 1;
                             $(this).find('#txtminvalue').focus();
                             return;
                         }
                     }
                 });

                 if (sn == 1) {
                     showerrormsg("Please Enter Min Value ");
                     return;
                 }

                 var sn1 = 0;
                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                         if ($(this).find('#txtmaxvalue').val() == "") {
                             sn1 = 1;
                             $(this).find('#txtmaxvalue').focus();
                             return;
                         }
                     }
                 });

                 if (sn1 == 1) {
                     showerrormsg("Please Enter Max Value ");
                     return;
                 }

                 var sn11 = 0;
                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                         if ($(this).find('#txtbaseminvalue').val() == "") {
                             sn11 = 1;
                             $(this).find('#txtbaseminvalue').focus();
                             return;
                         }
                     }
                 });

                 if (sn11 == 1) {
                     showerrormsg("Please Enter Base Mean Value ");
                     return;
                 }


                 var sn111 = 0;
                 $('#tblitemlist tr').each(function () {
                     var id = $(this).closest("tr").attr("id");
                     if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                         if ($(this).find('#txtbasesdvalue').val() == "") {
                             sn111 = 1;
                             $(this).find('#txtbasesdvalue').focus();
                             return;
                         }
                     }
                 });

                 if (sn111 == 1) {
                     showerrormsg("Please Enter Base SD Value ");
                     return;
                 }
                 //var sn1111 = 0;
                 //$('#tblitemlist tr').each(function () {
                 //    var id = $(this).closest("tr").attr("id");
                 //    if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                 //        if ($(this).find('#txtbasecvper').val() == "") {
                 //            sn1111 = 1;
                 //            $(this).find('#txtbasecvper').focus();
                 //            return;
                 //        }
                 //    }
                 //});

                 //if (sn1111 == 1) {
                 //    showerrormsg("Please Enter Base CV Percentage ");
                 //    return;
                 //}




                 //$.blockUI();
                 $.ajax({
                     url: "ControlLotMaster.aspx/SaveData",
                     data: JSON.stringify({controlprovider:$('#<%=txtcontrolprovider.ClientID%>').val(),controlname:$('#<%=txtcontrolname.ClientID%>').val(),lotnumber:$('#<%=txtlotnumber.ClientID%>').val(),datestart:$('#<%=txtDateStart.ClientID%>').val(),lotexpiry:$('#<%=txtlotexpiry.ClientID%>').val(), controldata: datatosave }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         //$.unblockUI();
                         var save = result.d;
                         if (save == "1") {
                             showmsg("Record Saved Successfully");

                             resetme();
                             binddata('1');
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
        function viewmachineparameter() {

            if ($("#<%=ddlmachine.ClientID%>").val() == "0") {
                showerrormsg("Please Select Machine");
                $("#<%=ddlmachine.ClientID%>").focus();
             
                return;
            }


           

            $('#tblparameterlist1 tr').slice(1).remove();

            //$.blockUI();
            $.ajax({
                url: "ControlLotMaster.aspx/bindparameter",
                data: '{parametername:"",machineid:"' + $('#<%=ddlmachine.ClientID%>').val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {

                        //$.unblockUI();
                        return;
                    }

                    for (i = 0; i < ItemData.length; i++) {
                        var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].LabObservation_ID + "'>";
                        mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  ><input type="checkbox" id="chk"  /></td>';
                        mydata += '<td class="GridViewLabItemStyle"   style="font-weight:bold;">' + ItemData[i].LabObservation_ID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"   style="font-weight:bold;" id="tdPatameterName">' + ItemData[i].PatameterName + '</td>';
                      
                        mydata += "</tr>";
                        $('#tblparameterlist1').append(mydata);

                    }


                    $find("<%=modeldetail1.ClientID%>").show();
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });




           

        }

        function addparameter() {
            var a = 0;

            $('#tblparameterlist1 tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tr2" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                    setdata(id, $(this).closest('tr').find('#tdPatameterName').html());
                    a++;
                }
            });

            if (a == 0) {
                showerrormsg("Please Select Parameter To Add");
            }
            else {
                showmsg("Parameter Added");
                $find("<%=modeldetail1.ClientID%>").hide();
            }
        }

    </script>


         <script type="text/javascript">

        function updatenow() {

            if ($('#<%=txtcontrolprovider.ClientID%>').val() == "") {
                 $('#<%=txtcontrolprovider.ClientID%>').focus();
                     showerrormsg("Please Enter Control Provider");
                     return;

                 }

                 if ($('#<%=txtcontrolname.ClientID%>').val() == "") {
                 $('#<%=txtcontrolname.ClientID%>').focus();
                     showerrormsg("Please Enter Control Name");
                     return;

                 }

                 if ($('#<%=txtlotnumber.ClientID%>').val() == "") {
                 $('#<%=txtlotnumber.ClientID%>').focus();
                     showerrormsg("Please Enter Lot Number");
                     return;

                 }


                 if ($("#<%=ddlmachine.ClientID%>").val() == "0") {
                 showerrormsg("Please Select Machine");
                 $("#<%=ddlmachine.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=txtDateStart.ClientID%>").val() == "") {
                 showerrormsg("Please Select Start Date");
                 $("#<%=txtDateStart.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=txtlotexpiry.ClientID%>").val() == "") {
                 showerrormsg("Please Select Lot Expiry ");
                 $("#<%=txtlotexpiry.ClientID%>").focus();
                     return;
                 }

                 if ($("#<%=ddldepartment.ClientID%>").val() == "0") {
                 //showerrormsg("Please Select Department");
                 // $("#<%=ddldepartment.ClientID%>").focus();
                     // return;
                 }

             if ($('#tblitemlist tr').length == 1) {
                 showerrormsg("Please Add LabObservation");
                 return;
             }

             var datatosave = getparameterlist();

             if (datatosave.length == 0) {
                 showerrormsg("Please Select Level");
                 return;
             }



             var sn = 0;
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                     if ($(this).find('#txtminvalue').val() == "") {
                         sn = 1;
                         $(this).find('#txtminvalue').focus();
                         return;
                     }
                 }
             });

             if (sn == 1) {
                 showerrormsg("Please Enter Min Value ");
                 return;
             }

             var sn1 = 0;
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                     if ($(this).find('#txtmaxvalue').val() == "") {
                         sn1 = 1;
                         $(this).find('#txtmaxvalue').focus();
                         return;
                     }
                 }
             });

             if (sn1 == 1) {
                 showerrormsg("Please Enter Max Value ");
                 return;
             }

             var sn11 = 0;
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                     if ($(this).find('#txtbaseminvalue').val() == "") {
                         sn11 = 1;
                         $(this).find('#txtbaseminvalue').focus();
                         return;
                     }
                 }
             });

             if (sn11 == 1) {
                 showerrormsg("Please Enter Base Mean Value ");
                 return;
             }


             var sn111 = 0;
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
                     if ($(this).find('#txtbasesdvalue').val() == "") {
                         sn111 = 1;
                         $(this).find('#txtbasesdvalue').focus();
                         return;
                     }
                 }
             });

             if (sn111 == 1) {
                 showerrormsg("Please Enter Base SD value ");
                 return;
             }
             //var sn1111 = 0;
             //$('#tblitemlist tr').each(function () {
             //    var id = $(this).closest("tr").attr("id");
             //    if (id != "trheader" && $(this).closest('tr').find('#chk').prop('checked') == true) {
             //        if ($(this).find('#txtbasecvper').val() == "") {
             //            sn1111 = 1;
             //            $(this).find('#txtbasecvper').focus();
             //            return;
             //        }
             //    }
             //});

             //if (sn1111 == 1) {
             //    showerrormsg("Please Enter Base CV Percentage ");
             //    return;
             //}




             //$.blockUI();
             $.ajax({
                 url: "ControlLotMaster.aspx/UpdateData",
                 data: JSON.stringify({controlid:$('#<%=txtcontrolid.ClientID%>').val(), controlprovider: $('#<%=txtcontrolprovider.ClientID%>').val(), controlname: $('#<%=txtcontrolname.ClientID%>').val(), lotnumber: $('#<%=txtlotnumber.ClientID%>').val(), datestart: $('#<%=txtDateStart.ClientID%>').val(), lotexpiry: $('#<%=txtlotexpiry.ClientID%>').val(), controldata: datatosave }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         //$.unblockUI();
                         var save = result.d;
                         if (save == "1") {
                             showmsg("Record Saved Successfully");

                             resetme();
                             binddata('1');
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

         function unloadPopupBox() {
             $('#popup_box1').fadeOut("slow");
             $("#Pbody_box_inventory").css({
                 "opacity": "1"
             });

         }

         function setmycontrol() {

             if ($('#<%=ddlcontrolprovider.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Control Provider");
                 return;
             }

             if ($('#<%=ddlcontrolname.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Control Name");
                 return;
             }

             if ($('#<%=ddllotnumber.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Lot Number");
                 return;
             }

             $('#<%=txtcontrolprovider.ClientID%>').val($('#<%=ddlcontrolprovider.ClientID%> option:selected').text());
             $('#<%=txtcontrolname.ClientID%>').val($('#<%=ddlcontrolname.ClientID%> option:selected').text());
             $('#<%=txtlotnumber.ClientID%>').val($('#<%=ddllotnumber.ClientID%> option:selected').text());
             $('#<%=txtlotexpiry.ClientID%>').val($('#<%=txtlotexpiry1.ClientID%>').val());
             $('#popup_box1').fadeOut("slow");
             $("#Pbody_box_inventory").css({
                 "opacity": "1"
             });


             
         }

         function openmybox() {
             $('#popup_box1').fadeIn("slow");
             $("#Pbody_box_inventory").css({
                 "opacity": "0.5"
             });
             bindcontrolprovider();

            
         }


         function bindcontrolprovider() {
            

             $('#<%=ddlcontrolprovider.ClientID%> option').remove();
             $('#<%=ddlcontrolprovider.ClientID%>').trigger('chosen:updated');
             $('#<%=ddlcontrolname.ClientID%> option').remove();
             $('#<%=ddlcontrolname.ClientID%>').trigger('chosen:updated');
             $('#<%=ddllotnumber.ClientID%> option').remove();
             $('#<%=ddllotnumber.ClientID%>').trigger('chosen:updated');
             $('#<%=txtlotexpiry1.ClientID%>').val('');
                 //$.blockUI();
                 $.ajax({
                     url: "ControlLotMaster.aspx/bindcontolprovider",
                     data: '{}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Control Provider Found");
                         }

                         jQuery("#<%=ddlcontrolprovider.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control Provider"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlcontrolprovider.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].MAnufactureID).html(CentreLoadListData[i].ManufactureName));
                        }
                        
                         $("#<%=ddlcontrolprovider.ClientID%>").trigger('chosen:updated');





                         //$.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.unblockUI();
                     }
                 });
             
         }

         function bindcontrolname() {
             var controlprovider = $('#<%=ddlcontrolprovider.ClientID%>').val();
             $('#<%=ddlcontrolname.ClientID%> option').remove();
             $('#<%=ddlcontrolname.ClientID%>').trigger('chosen:updated');
             $('#<%=ddllotnumber.ClientID%> option').remove();
             $('#<%=ddllotnumber.ClientID%>').trigger('chosen:updated');
             $('#<%=txtlotexpiry1.ClientID%>').val('');
             if (controlprovider != "0" && controlprovider != null) {


                 //$.blockUI();
                 $.ajax({
                     url: "ControlLotMaster.aspx/bindcontolname",
                     data: '{controlprovider: "' + controlprovider + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Control Name Found");
                         }

                         jQuery("#<%=ddlcontrolname.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control Name"));
                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=ddlcontrolname.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].itemid).html(CentreLoadListData[i].typename));
                         }

                        $("#<%=ddlcontrolname.ClientID%>").trigger('chosen:updated');





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



        function bindbatchnumber() {

            var controlname = $('#<%=ddlcontrolname.ClientID%>').val();
            $('#<%=ddllotnumber.ClientID%> option').remove();
            $('#<%=ddllotnumber.ClientID%>').trigger('chosen:updated');
          
            if (controlname != "0" && controlname != null) {
                //$.blockUI();
                $.ajax({
                    url: "ControlLotMaster.aspx/bindbatch",
                    data: '{controlname: "' + controlname + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                        CentreLoadListData = $.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                            showerrormsg("No Batch Found");
                        }

                      

                        jQuery("#<%=ddllotnumber.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Lot Number"));
                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=ddllotnumber.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].ExpiryDate).html(CentreLoadListData[i].batchnumber));
                        }

                        $("#<%=ddllotnumber.ClientID%>").trigger('chosen:updated');





                        //$.unblockUI();
                    },
                    error: function (xhr, status) {
                      
                        window.status = status + "\r\n" + xhr.responseText;
                        //$.unblockUI();
                    }
                });
            }
        }

        function setexpirydate() {
            $('#<%=txtlotexpiry1.ClientID%>').val('');
            if ($('#<%=ddllotnumber.ClientID%>').val() != null && $('#<%=ddllotnumber.ClientID%>').val() != "0") {
                $('#<%=txtlotexpiry1.ClientID%>').val($('#<%=ddllotnumber.ClientID%>').val());
            }


        }


    </script>
</asp:Content>

