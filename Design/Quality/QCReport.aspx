<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCReport.aspx.cs" Inherits="Design_Quality_QCReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
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
                          <b>QC Report</b>  

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
                          <td><asp:ListBox ID="ddlprocessinglab" runat="server" CssClass="multiselect" SelectionMode="Multiple"  Width="300" onchange="bindcontrol(); bindMachine();">
                           
                          </asp:ListBox>&nbsp; <strong>Control/Lot Number :&nbsp; </strong>
                              <asp:DropDownList ID="ddlcontrol" runat="server" class="ddlcontrol chosen-select chosen-container" Width="300" onchange="bindparameter()" >
                           
                          </asp:DropDownList>
                              &nbsp; <strong>Machine  :&nbsp; </strong>
                              <asp:DropDownList ID="ddlMachine" runat="server" class="ddlMachine chosen-select chosen-container" Width="250" onchange="bindparameter()" >
                           
                          </asp:DropDownList>
                          </td>

                    </tr>
                    <tr>
                         <td style="font-weight: 700">Parameter :</td>
                          <td>
                              <asp:DropDownList ID="ddlparameter" runat="server" class="ddlparameter chosen-select chosen-container" Width="300" onchange="bindlevel()" >
                              </asp:DropDownList>
                              &nbsp;&nbsp;
                              <span style="font-weight:bold;">Level :</span>
                              &nbsp;<asp:DropDownList ID="ddllevel" runat="server" class="ddllevel chosen-select chosen-container" Width="145" >
                              </asp:DropDownList>
                              
                              <strong>&nbsp;&nbsp;&nbsp;&nbsp; From Date :</strong>&nbsp;&nbsp;
                              <asp:TextBox ID="txtfromdate" runat="server" Width="80" ReadOnly="true" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                          &nbsp; <strong>To Date :</strong>
                              <asp:TextBox ID="txttodate" runat="server"  Width="80" ReadOnly="true" ></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                              
                         </td>

                    </tr>
                    <tr>
                         <td style="font-weight: 700" colspan="2" align="center">

                             <input type="button" value="Base Mean Report" class="searchbutton" onclick="showqcreport('0')" />&nbsp;
                             <input type="button" value="Record Mean Report" class="searchbutton" onclick="showqcreport('1')" />&nbsp;
                             <input type="button" value="Show Reading" class="searchbutton" onclick="showreading('')" />
                             <input type="button" value="Add Reading" style="display:none;" class="searchbutton" onclick="addreading()" />

                             <asp:DropDownList ID="ddltype" runat="server" Width="150px">
                                 <asp:ListItem Value="All">ALL</asp:ListItem>
                                 <asp:ListItem Value="Pass">Pass</asp:ListItem>
                                 <asp:ListItem Value="Fail">Fail</asp:ListItem>
                                 <asp:ListItem Value="Warn">Warn</asp:ListItem>
                                 <asp:ListItem Value="NotShowInQC">Not Show in QC</asp:ListItem>
                                 <asp:ListItem Value="NotRun">QC Not Run</asp:ListItem>
                             </asp:DropDownList>
                             <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()" />

                             <% if(canverify=="1")
                                 { %>
                             <input type="button" value="Verify QC Reading" class="savebutton" onclick="verifyreading()" />
                             <% }%>

                         </td>
                    </tr>
                </table>
                </div>
              </div>



           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader">
                    <table width="60%">
                <tr >
                  <td>  Reading</td>
                    <%--  <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>


                    <td>&nbsp;&nbsp; Updated</td>--%>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;cursor:pointer;" onclick="showreading('1')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                 <td>&nbsp;&nbsp; Pass</td>

                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: orange;cursor:pointer;" onclick="showreading('2')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>


                    <td>&nbsp;&nbsp; Warn</td>

                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;cursor:pointer;" onclick="showreading('3')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>


                    <td>&nbsp;&nbsp; Fail</td>

                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;cursor:pointer;" onclick="showreading('4')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>


                    <td>&nbsp;&nbsp;&nbsp; Not Show in QC Report</td>



                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightblue;cursor:pointer;" onclick="showreading('5')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>


                    <td>&nbsp;&nbsp;&nbsp; QC Not Run</td>
                   
                    
                    </tr>
                             </table>
                </div>
                  <div  style="width:1295px; max-height:350px;overflow:auto;">
                         <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trheader">
                        
                          <td class="GridViewHeaderStyle" style="width: 40px;">Sr.No</td>
                          <td class="GridViewHeaderStyle"  title="Verify QC">
                           <% if(canverify=="1")
                                 { %>
                              <input type="checkbox" title="Check To Verify All" onclick="checkall(this)" id="chall" />
                              <% }
                                 else
                                 {%>
                               #
                              <% }%>
                           </td>
                          <td class="GridViewHeaderStyle" style="width: 20px;" title="Remove Reading">#</td>
                          <td class="GridViewHeaderStyle">Centre Name</td>
                          <td class="GridViewHeaderStyle">Machine Name</td>
                          <td class="GridViewHeaderStyle" style="width:75px;">ControlRun<br />
                              DateTime</td>
                          <td class="GridViewHeaderStyle">Control Name</td>
                          <td class="GridViewHeaderStyle">Lot Number</td>
                          <td class="GridViewHeaderStyle">Sin No</td>
                          <td class="GridViewHeaderStyle">Parameter Name</td>
                          <td class="GridViewHeaderStyle" style="width:50px;">Level</td>
                          <td class="GridViewHeaderStyle" style="width:76px;">Reading</td>
                          <td class="GridViewHeaderStyle" style="width:70px;">QC Status</td>
                          <td class="GridViewHeaderStyle" style="width:40px;">Min value</td>
                          <td class="GridViewHeaderStyle" style="width:40px;">Max value</td>
                          <td class="GridViewHeaderStyle" style="width:75px;">Base Mean Value</td>
                          <td class="GridViewHeaderStyle" style="width:60px;">Base SD Value</td>
                          <td class="GridViewHeaderStyle" style="width:60px;">Base CV (%)</td>
                          <td class="GridViewHeaderStyle" style="width:50px;">Unit</td>
                          <td class="GridViewHeaderStyle" style="width:50px;">Tempe rature</td>
                          <td class="GridViewHeaderStyle" style="width:50px;">Method</td>
                          <%--<td class="GridViewHeaderStyle" style="width: 20px;" title="Check To Save RCA or CAPA">#</td>--%>
                          <td class="GridViewHeaderStyle" style="width: 30px;">RCA</td>
                          <td class="GridViewHeaderStyle" style="width: 41px;">Corre ctive Action</td>
                          <td class="GridViewHeaderStyle" style="width: 41px">Preve ntive Action</td>
                        
                         
                          
                          
                    </tr>
                </table>
                      </div>

                <center>
                    <input type="button" value="Update Reading" id="btnupdate" style="display:none;" class="savebutton" onclick="updatereading()" />

                     <input type="button" value="Save RCA and CAPA" id="btnupdate1" style="display:none;" class="savebutton" onclick="savercaandcapa()" />


                </center>
                </div>
               </div>
         </div>

     <asp:Panel ID="panelremarks" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 600px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                <span id="remarksheader">Update Reading Reason</span>
            </div>

            <table width="99%">
                <tr>
                    <td>
                         Update Reason :

                        
                    </td>

                    <td>
                        <asp:TextBox ID="txtupdatereason" runat="server" Width="250px" MaxLength="150" />
                          
                    </td>
                    </tr>
                  
            </table>
         
            <center>
                  <input type="button" class="searchbutton" value="Add" onclick="addremark()" />&nbsp;
                  <input type="button" class="resetbutton" value="Close" onclick="removeremark()" />&nbsp;&nbsp;&nbsp;


               
               

                <input type="text" id="trid" style="display:none;" />
            </center>
        </div>
    </asp:Panel>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />
     <cc1:ModalPopupExtender ID="modelpopupremarks" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelremarks">
    </cc1:ModalPopupExtender>



    <asp:Panel ID="panel1" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 600px; background-color: whitesmoke;">
            <div class="Purchaseheader">
               Add Reading
            </div>
            <table width="99%">
                <tr>
                    <td style="font-weight:bold;">Date :</td>
                    <td>
                         <asp:TextBox ID="txtdate" runat="server"  Width="80" ReadOnly="true" ></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" PopupButtonID="txtdate" TargetControlID="txtdate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                        
                       </td>
                </tr>

                <tr>
                    <td style="font-weight:bold;">
                        Reading :
                    </td>
                    <td>
                          <asp:TextBox ID="txtreading" Width="80" runat="server"></asp:TextBox>
                         <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers,Custom" TargetControlID="txtreading" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                        <input type="button" value="Save Reading" class="savebutton" onclick="savereading()" />&nbsp;&nbsp;
                        <asp:Button ID="btnclosemep" runat="server" CssClass="resetbutton" Text="Cancel" />
                    </td>
                </tr>
            </table>

            </div>

            </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panel1" CancelControlID="btnclosemep">
    </cc1:ModalPopupExtender>





      <asp:Panel ID="panel2" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                <span id="remarksheader1"></span>
            </div>

            <table width="99%">
                <tr>
                    <td>
                        Select Remarks :

                        
                    </td>

                    <td>
                         <select id="ddlremarks" style="width:300px" onchange="getremarks()"></select>
                          
                    </td>
                    </tr>
                  <tr>
                    <td>
                        Remarks :
                    </td>

                    <td>

                     <ckeditor:ckeditorcontrol ID="txtremarkstext"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="500" Height="100" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                    </td>
                </tr>
            </table>
         
            <center>
                <input type="button" class="searchbutton" value="Add" onclick="addremark1()" />&nbsp;
                  <input type="button" class="resetbutton" value="Close" onclick="removeremark1()" />&nbsp;
               
                 <input type="button" class="resetbutton" value="Remove Comment" onclick="removeremarkandremove()" />&nbsp;
                <input type="text" id="trid1" style="display:none;" />
            </center>
            <br />
        </div>
    </asp:Panel>

   
     <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panel2">
    </cc1:ModalPopupExtender>

        <asp:Panel ID="panel3" runat="server" Style="display: none;">
            <div class="POuter_Box_Inventory" style="width: 800px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                Type
             
                </div>
                <table>
                    <tr>
                        <td><strong> Choose One Option: </strong></td>
                        <td> <asp:RadioButtonList ID="rdrca" runat="server" RepeatDirection="Horizontal" Font-Bold="true">
                       <asp:ListItem Value="0" Selected="True">Comment</asp:ListItem>
                       <asp:ListItem Value="1">CheckList</asp:ListItem>
                </asp:RadioButtonList> <asp:TextBox ID="txtype" runat="server" style="display:none;"></asp:TextBox><asp:TextBox ID="txtypeopen" runat="server" style="display:none;"></asp:TextBox></td>
                    </tr>
                </table>
               
               
                <center><input type="button" value="Continue" class="searchbutton" onclick="openmychoice()" />&nbsp;&nbsp;<asp:Button Text="close" ID="btnclosemeplease" runat="server" CssClass="resetbutton" /></center>
                <br />
                </div>
        </asp:Panel>
       <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panel3" CancelControlID="btnclosemeplease">
    </cc1:ModalPopupExtender>



    <script type="text/javascript">

        function checkall(ctrl) {

            if ($(ctrl).prop('checked') == true) {
                $('#tblitemlist tr').each(function () {                  
                    if ($(this).closest("tr").attr("id") != "trheader") {
                        $(this).closest("tr").find('#chverify').prop('checked', true);
                    }
                });
            }
            else {
                $('#tblitemlist tr').each(function () {
                    if ($(this).closest("tr").attr("id") != "trheader") {
                        $(this).closest("tr").find('#chverify').prop('checked', false);
                    }
                });
            }
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
                 
             $('[id=<%=ddlprocessinglab.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             //bindcontrol();

         });
         function bindcontrol() {

             var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddlcontrol.ClientID%> option').remove();
             $('#<%=ddlcontrol.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null && labid!="") {


                 //$.blockUI();
                 $.ajax({
                     url: "QCReport.aspx/bindcontrol",
                     data: '{labid: "' + labid + '"}',
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


        function bindMachine() {

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            jQuery('#<%=ddlMachine.ClientID%> option').remove();
            $('#<%=ddlMachine.ClientID%>').trigger('chosen:updated');

            if (labid != "0" && labid != null && labid != "") {


                //$.blockUI();
                $.ajax({
                    url: "QCReport.aspx/bindMachine",
                    data: '{labid: "' + labid + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                       var CentreMachineListData = $.parseJSON(result.d);
                        if (CentreMachineListData.length == 0) {
                            showerrormsg("No Control Found");
                        }

                        jQuery("#<%=ddlMachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Machine"));
                        for (i = 0; i < CentreMachineListData.length; i++) {

                            jQuery("#<%=ddlMachine.ClientID%>").append(jQuery('<option></option>').val(CentreMachineListData[i].MacID).html(CentreMachineListData[i].machinename));
                         }

                         $("#<%=ddlMachine.ClientID%>").trigger('chosen:updated');





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



        function bindparameter() {

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if ($('#<%=ddlprocessinglab.ClientID%>  > option:selected').length > 1) {
                showerrormsg("Please Select Only One Centre To Get Parameter List");
                $('#<%=ddlcontrol.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
                return;
            }
            
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            jQuery('#<%=ddlparameter.ClientID%> option').remove();
            $('#<%=ddlparameter.ClientID%>').trigger('chosen:updated');

            if (controlid != "0" && controlid != null) {
                //$.blockUI();
                $.ajax({
                    url: "QCReport.aspx/bindparameter",
                    data: '{labid: "' + labid + '",controlid:"' + controlid + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                        CentreLoadListData = $.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                            showerrormsg("No Parameter Found");
                        }
                        jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Parameter"));
                         for (i = 0; i < CentreLoadListData.length; i++) {
                             jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].LabObservation_Name));
                         }
                         $("#<%=ddlparameter.ClientID%>").trigger('chosen:updated');
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



        function bindlevel() {

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var LabObservation_ID = $('#<%=ddlparameter.ClientID%>').val();
             jQuery('#<%=ddllevel.ClientID%> option').remove();
             $('#<%=ddllevel.ClientID%>').trigger('chosen:updated');

            if (LabObservation_ID != "0" && LabObservation_ID != null) {
                 //$.blockUI();
                 $.ajax({
                     url: "QCReport.aspx/bindlevel",
                     data: '{labid: "' + labid + '",controlid:"' + controlid + '",LabObservation_ID:"' + LabObservation_ID + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Level Found");
                         }
                         if (CentreLoadListData.length > 1) {
                             jQuery("#<%=ddllevel.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Level"));
                         }
                        for (i = 0; i < CentreLoadListData.length; i++) {
                            jQuery("#<%=ddllevel.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].levelid).html(CentreLoadListData[i].LEVEL));
                         }
                        $("#<%=ddllevel.ClientID%>").trigger('chosen:updated');
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
        var canverify = '<%=canverify%>';
        function showreading(colorcode) {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter.ClientID%>').val();
            var levelid = $('#<%=ddllevel.ClientID%>').val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();
            var MachineId = $('#<%=ddlMachine.ClientID%>').val();

            if (labid == "0" || labid == null || labid=="") {
                showerrormsg("Please Select Centre");
                return;
            }

             if ($('#<%=ddlprocessinglab.ClientID%>  > option:selected').length > 1) {
                var fromdated = new Date(fromdate);
                var todated = new Date(todate);
                var diff = new Date(todated - fromdated);
                var days = diff / 1000 / 60 / 60 / 24;
                var totaldays = Math.round(days);
                if (totaldays > 0) {
                    showerrormsg("You can only Seach 1 Date Data. When more then 1 centre selected");
                    return;
                }
               
            }


            if (controlid == "0" || controlid == null) {
                controlid = "";
            }
            if (parameterid == "0" || parameterid == null) {
                parameterid = "";
            }
            if (levelid == "0" || levelid == null) {
                levelid = "";
            }

            $('#tblitemlist tr').slice(1).remove();

            //$.blockUI();
            $.ajax({
                url: "QCReport.aspx/showreading",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",fromdate:"' + fromdate + '",todate:"' + todate + '",colorcode:"' + colorcode + '",MachineId:"' + MachineId + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                       // $('#btnupdate').hide();
                        //$('#btnupdate1').hide();
                        
                       
                    }

                    var obsid = "";
                    for (i = 0; i < ItemData.length; i++) {

                        var color = "lightgreen";
                        if (ItemData[i].oldreading != "") {
                            color = "aqua";
                        }
                        
                        if (ItemData[i].qcstatus == "Fail") {
                            color = "yellow";
                        }
                        if (ItemData[i].qcstatus == "Warn") {
                            color = "orange";
                        }
                        if (ItemData[i].ShowInQC == "0") {
                            color = "pink";
                        }
                       
                        if (ItemData[i].qcstatus == "Not Run")
                        {
                            color="lightblue";
                        }
                        var mydata = '';
                        if (ItemData[i].LabObservation_ID != obsid) {
                            mydata += "<tr style='background-color:" + color + ";border-top:4px solid lightgray;' id='" + ItemData[i].id + "'>";
                        }
                        else {
                            mydata += "<tr style='background-color:" + color + ";' id='" + ItemData[i].id + "'>";
                        }
                        mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1);
                        if (ItemData[i].oldreading != "") {
                            var Deactivby = "Old Reading:-  " + ItemData[i].oldreading + "<br/>Update Reason:-" + ItemData[i].UpdateReason + "<br/>Update Date:-  " + ItemData[i].updatedate + "<br/>Update By:-  " + ItemData[i].UpdateBy;
                            mydata += '&nbsp;<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showerrormsg(\'' + Deactivby + '\');" />';
                        }
                        mydata += '</td>';

                        if (ItemData[i].qcstatus != "Not Run") {
                            if (ItemData[i].IsVerify == "1") {
                                mydata += '<td><img src="../../App_Images/Approved.jpg" title="' + ItemData[i].VerifyDetail + '" style="cursor:pointer;height:30px;width:30px;"/></td>';
                            }
                            else if (canverify == "1") {
                                mydata += '<td><input type="checkbox" title="Check To Verify" id="chverify"/></td>';
                            }
                            else {
                                mydata += '<td></td>';
                            }
                        }
                        else {
                            mydata += '<td></td>';
                        }
                        if (ItemData[i].qcstatus != "Not Run") {
                            if (ItemData[i].ShowInQC == "1") {
                                mydata += '<td><img src="../../App_Images/Delete.gif" title="Click To Remove from QC Report" style="cursor:pointer;" onclick="removefromqc(this,\'0\')"/></td>';
                            }
                            else {
                                mydata += '<td><img src="../../App_Images/Reload.jpg" title="Click To Add in QC Report" style="cursor:pointer;" onclick="removefromqc(this,\'1\')"/></td>';
                            }
                        }
                        else {
                            mydata += '<td></td>';
                        }
                            
                        mydata += '<td class="GridViewLabItemStyle"  id="centrename"  ">' + ItemData[i].Centre + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Machine_Id"  ">' + ItemData[i].Machine_Id + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="EntryDateTime"  ">' + ItemData[i].EntryDateTime + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="ControlName"  style="font-weight:bold;">' + ItemData[i].ControlName + '</td>';  
                        mydata += '<td class="GridViewLabItemStyle"  id="LotNumber"  style="font-weight:bold;">' + ItemData[i].LotNumber + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="sinno"  style="font-weight:bold;">' + ItemData[i].sinno + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_Name"  style="font-weight:bold;">' + ItemData[i].LabObservation_Name + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Level"  style="font-weight:bold;">' + ItemData[i].Level + '</td>';
                        if (ItemData[i].oldreading != "") {
                            mydata += '<td class="GridViewLabItemStyle" style="background-color:maroon;"  id="Reading" ><input type="checkbox" id="ch" title="Check To Update Reading" onclick="checkforreason(this)"  style="display:none;"/><input type="text" id="txtreading" value="' + ItemData[i].Reading + '" style="width:50px;"/></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="Reading" ><input type="checkbox" id="ch" title="Check To Update Reading" onclick="checkforreason(this)" style="display:none;" /><input type="text" id="txtreading" value="' + ItemData[i].Reading + '" style="width:50px;"/></td>';
                        }
                        if (ItemData[i].qcstatus != "Not Run") {
                            mydata += '<td class="GridViewLabItemStyle"  id="QCStatus"  style="font-weight:bold;">' + ItemData[i].qcstatus1 + '</td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="QCStatus"  style="font-weight:bold;">' + ItemData[i].qcstatus + '</td>';
                        }
                        mydata += '<td class="GridViewLabItemStyle"  id="Minvalue"  style="font-weight:bold;">' + ItemData[i].Minvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Maxvalue"  style="font-weight:bold;">' + ItemData[i].Maxvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="BaseMeanvalue"  style="font-weight:bold;">' + ItemData[i].BaseMeanvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="BaseSDvalue"  style="font-weight:bold;">' + ItemData[i].BaseSDvalue + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="BaseCVPercentage"  style="font-weight:bold;">' + ItemData[i].BaseCVPercentage + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Unit"  style="font-weight:bold;">' + ItemData[i].Unit + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Temperature"  style="font-weight:bold;">' + ItemData[i].Temperature + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Method"  style="font-weight:bold;">' + ItemData[i].Method + '</td>';
                        //mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" id="ch1" title="Check To Save RCA or CAPA"  /></td>';
                        //if (Number(ItemData[i].Reading) > Number(ItemData[i].SDPos) || Number(ItemData[i].Reading) < Number(ItemData[i].SDNeg)) {

                        if (ItemData[i].qcstatus != "Not Run") {
                            if (ItemData[i].RCA != "") {
                                mydata += '<td align="left"  ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].id + '\',1)"/></td>';
                            }
                            else {
                                mydata += '<td align="left"  ><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;"  onclick="openbox(\'' + ItemData[i].id + '\',1)"/></td>';
                            }

                            if (ItemData[i].CorrectiveAction != "") {
                                mydata += '<td align="left" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;"  onclick="openbox(\'' + ItemData[i].id + '\',2)"/></td>';
                            }
                            else {
                                mydata += '<td align="left" ><img id="CorrectiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;"  onclick="openbox(\'' + ItemData[i].id + '\',2)"/></td>';
                            }

                            if (ItemData[i].PreventiveAction != "") {
                                mydata += '<td align="left" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;"  onclick="openbox(\'' + ItemData[i].id + '\',3)"/></td>';
                            }
                            else {
                                mydata += '<td align="left"><img id="PreventiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;"  onclick="openbox(\'' + ItemData[i].id + '\',3)"/></td>';
                            }
                        }
                        else {
                            mydata += '<td></td>';
                            mydata += '<td></td>';
                            mydata += '<td></td>';
                        }
                        //}
                        //else {
                        //    mydata += '<td class="GridViewLabItemStyle"  ></td>';
                        //    mydata += '<td class="GridViewLabItemStyle"  ></td>';
                        //    mydata += '<td class="GridViewLabItemStyle"  ></td>';
                        //}

                        mydata += '<td class="GridViewLabItemStyle"  id="centreid"  style="display:none;">' + ItemData[i].centreid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="controlid"  style="display:none;">' + ItemData[i].controlid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_ID"  style="display:none;">' + ItemData[i].LabObservation_ID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LevelID"  style="display:none;">' + ItemData[i].LevelID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="id"  style="display:none;">' + ItemData[i].id + '</td>';
                        mydata += '<td id="RCA" style="display:none;">' + ItemData[i].RCA + '</td>';
                        mydata += '<td id="CorrectiveAction" style="display:none;">' + ItemData[i].CorrectiveAction + '</td>';
                        mydata += '<td id="PreventiveAction" style="display:none;">' + ItemData[i].PreventiveAction + '</td>';

                      
                        mydata += '<td id="RCAType" style="display:none;">' + ItemData[i].RCAType + '</td>';
                        mydata += '<td id="CAType" style="display:none;">' + ItemData[i].CAType + '</td>';
                        mydata += '<td id="PAType" style="display:none;">' + ItemData[i].PAType + '</td>';


                        mydata += '<td class="GridViewLabItemStyle"  id="updatereason"  style="display:none;"></td>';
                        
                      
                       
                       
                        mydata += "</tr>";
                      //  $('#btnupdate').show();
                      //$('#btnupdate1').show();
                        obsid = ItemData[i].LabObservation_ID;
                        $('#tblitemlist').append(mydata);
                      

                    }

                   

                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });


        }

        function removefromqc(itemid,status) {

            var id = $(itemid).closest('tr').attr('id');


            //$.blockUI();

            jQuery.ajax({
                url: "QCReport.aspx/removefroqc",
                data: '{ id: "' + id + '",status:"' + status + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (status == "0") {
                        showmsg("Reading Removed from QC Report..");
                    }
                    else {
                        showmsg("Reading Added in QC Report..");
                    }
                 
                    //$.unblockUI();
                    showreading('');
                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }


        function checkforreason(ctrl) {
            if ($(ctrl).prop('checked') == true) {
                $('#trid').val($(ctrl).closest('tr').attr('id'));
                var oldreason= $('#tblitemlist #' + $('#trid').val()).find('#updatereason').html();
                $('#<%=txtupdatereason.ClientID%>').val(oldreason);
                $find("<%=modelpopupremarks.ClientID%>").show();
               
            }
            else {
               
                $('#trid').val($(ctrl).closest('tr').attr('id'));
                $('#tblitemlist #' + $('#trid').val()).find('#updatereason').html('');
                $(ctrl).closest('tr').find('#Reading').css('background-color', $(ctrl).closest('tr').css('background-color'));
            }
        }


        function removeremark() {
            

            $('#tblitemlist #' + $('#trid').val()).find('#ch').prop('checked', false);
            $('#tblitemlist #' + $('#trid').val()).find('#updatereason').html('');
            $('#tblitemlist #' + $('#trid').val()).find('#Reading').css('background-color', $('#tblitemlist #' + $('#trid').val()).css('background-color'));
            $find("<%=modelpopupremarks.ClientID%>").hide();
        }
        function addremark() {
            
            var remarks = $('#<%=txtupdatereason.ClientID%>').val().trim();
           

            if (remarks == "") {
                $('#<%=txtupdatereason.ClientID%>').focus();
                showerrormsg("Please Enter Update Reason");
                return;

            }




            $('#tblitemlist #' + $('#trid').val()).find('#updatereason').html(remarks);
            $('#tblitemlist #' + $('#trid').val()).find('#Reading').css('background-color', 'maroon');
            $find("<%=modelpopupremarks.ClientID%>").hide();

        }



    </script>

    <script type="text/javascript">

        function getparameterlist() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).closest('tr').attr('id') != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true) {
                    dataIm.push($(this).closest('tr').attr('id') + "#" + $(this).closest('tr').find('#txtreading').val() + "#" + $(this).closest('tr').find('#updatereason').html());
                }
            });
            return dataIm;
        }

        function updatereading() {

            var datatosave = getparameterlist();

            if (datatosave.length == 0) {
                showerrormsg("Please Select Data");
                return;
            }


            //$.blockUI();
            $.ajax({
                url: "QCReport.aspx/updatereading",
                data: JSON.stringify({ controldata: datatosave }),
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        showmsg("Reading Update Successfully");

                        showreading('');

                    }
                    else {
                        showerrormsg(result.d);

                        // console.log(save);
                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }
    </script>

    <script type="text/javascript">
       

        function exporttoexcel() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter.ClientID%>').val();
            var levelid = $('#<%=ddllevel.ClientID%>').val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();

            if (labid == "0" || labid == null || labid == "") {
                showerrormsg("Please Select Centre");
                return;
            }

             if ($('#<%=ddlprocessinglab.ClientID%>  > option:selected').length > 1) {
                var fromdated = new Date(fromdate);
                var todated = new Date(todate);
                var diff = new Date(todated - fromdated);
                var days = diff / 1000 / 60 / 60 / 24;
                var totaldays = Math.round(days);
                if (totaldays > 0) {
                    showerrormsg("You can only Seach 1 Date Data. When more then 1 centre selected");
                    return;
                }
               
            }

            if (controlid == "0" || controlid == null) {
                controlid = "";
            }
            if (parameterid == "0" || parameterid == null) {
                parameterid = "";
            }
            if (levelid == "0" || levelid == null) {
                levelid = "";
            }

            var type = $('#<%=ddltype.ClientID%>').val();
            jQuery.ajax({
                url: "QCReport.aspx/showreadingexcel",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",fromdate:"' + fromdate + '",todate:"' + todate + '",type:"' + type + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        //$.unblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        //$.unblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
    </script>


    <script type="text/javascript">
        function showqcreport(type) {

           
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter.ClientID%>').val();
            var levelid = $('#<%=ddllevel.ClientID%>').val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();
            var macid = $('#<%=ddlMachine.ClientID%>').val();

            if (labid == "0" && labid == null) {
                showerrormsg("Please Select Centre");
                return;
            }

            if (controlid == "0" || controlid == null) {
                showerrormsg("Please Select Control");
                return;
            }
            if (parameterid == "0" || parameterid == null) {
                showerrormsg("Please Select Parameter");
                return;
            }
            //if (levelid == "0" || levelid == null) {
            //    showerrormsg("Please Select Level");
            //    return;
            //}

          

         

            //$.blockUI();
            jQuery.ajax({
                url: "QCReport.aspx/showqcreport",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",fromdate:"' + fromdate + '",todate:"' + todate + '",type:"' + type + '",macid:"'+macid+'"}',
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {


                    result1 = $.parseJSON(result.d)

                    var querystring = "labid=" + result1[0] + "&controlid=" + result1[1] + "&parameterid=" + result1[2] + "&levelid=" + result1[3] + "&fromdate=" + result1[4] + "&todate=" + result1[5] + "&type=" + result1[6]+"&macid="+result1[7];
                    window.open('qcgraph.aspx?' + querystring);
                       
                   
                    //$.unblockUI();

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });



        }
     

    </script>



    <script type="text/javascript">

        function addreading() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter.ClientID%>').val();
            var levelid = $('#<%=ddllevel.ClientID%>').val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();

            if (labid == "0" && labid == null) {
                showerrormsg("Please Select Centre");
                return;
            }

            if (controlid == "0" || controlid == null) {
                showerrormsg("Please Select Control");
                return;
            }
            if (parameterid == "0" || parameterid == null) {
                showerrormsg("Please Select Parameter");
                return;
            }
            if (levelid == "0" || levelid == null) {
                showerrormsg("Please Select Level");
                return;
            }
            $('#<%=txtreading.ClientID%>').val('');
            $find("<%=ModalPopupExtender1.ClientID%>").show();

        }


        function savereading() {

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
            var parameterid = $('#<%=ddlparameter.ClientID%>').val();
            var levelid = $('#<%=ddllevel.ClientID%>').val();
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
            var todate = $('#<%=txttodate.ClientID%>').val();
            var date = $('#<%=txtdate.ClientID%>').val();
            var reading = $('#<%=txtreading.ClientID%>').val();
            if (reading == "") {
                showerrormsg("Please Enter Reading");
                $('#<%=txtreading.ClientID%>').focus();
                return;
            }
            var ControlName = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[0].trim();
            var LotNumber = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[1].trim();
           
            var LabObservation_Name = $('#<%=ddlparameter.ClientID%> option:selected').text();
            var Level = $('#<%=ddllevel.ClientID%> option:selected').text().split('#')[0].trim();
            var barcodeno = $('#<%=ddllevel.ClientID%> option:selected').text().split('#')[1].trim();

            //$.blockUI();
            jQuery.ajax({
                url: "QCReport.aspx/savereading",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",parameterid:"' + parameterid + '",levelid:"' + levelid + '",entrydate:"' + date + '",reading:"' + reading + '",ControlName:"' + ControlName + '",LotNumber:"' + LotNumber + '",LabObservation_Name:"' + LabObservation_Name + '",Level:"' + Level + '",barcodeno:"' + barcodeno + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        showmsg("Reading Saved");
                        $find("<%=ModalPopupExtender1.ClientID%>").hide();
                        showreading('');
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
    </script>


    <script type="text/javascript">


        function bindremarks(type) {

            jQuery('#ddlremarks option').remove();
            jQuery.ajax({
                url: "QCReport.aspx/bindremarks",
                data: '{type:"' + type + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    CentreLoadListData = jQuery.parseJSON(result.d);
                    if (CentreLoadListData.length == 0) {
                        return;
                    }

                    jQuery("#ddlremarks").append(jQuery('<option></option>').val("").html("Select " + type));





                    for (i = 0; i < CentreLoadListData.length; i++) {




                        jQuery("#ddlremarks").append(jQuery('<option></option>').val(CentreLoadListData[i].ID).html(CentreLoadListData[i].Remarks));

                    }



                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }

        function openrca(ctrl) {

            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('RCA');
            $('#remarksheader1').html('RCA');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');


            var saveddata = $(ctrl).closest('tr').find('#RCA').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=ModalPopupExtender2.ClientID%>").show();


        }

        function openca(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('Corrective Action');
            $('#remarksheader1').html('CorrectiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#CorrectiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=ModalPopupExtender2.ClientID%>").show();

        }

        function openpa(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('Preventive Action');
            $('#remarksheader1').html('PreventiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#PreventiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=ModalPopupExtender2.ClientID%>").show();

        }


        function getremarks() {


            jQuery.ajax({
                url: "QCReport.aspx/bindremarksdetail",
                data: '{id:"' + jQuery("#ddlremarks").val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {



                    var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                    objEditor.setData(result.d);

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
            }

            function removeremark1() {

            $find("<%=ModalPopupExtender2.ClientID%>").hide();
            }

        function removeremarkandremove() {

            if (confirm("Do you want to remove comment?")) {
                var MacDataId = $('#trid').val();
                var Type = $('#remarksheader1').html();
                var QCType = "QC";

                //$.blockUI();

                $.ajax({
                    url: "QCReport.aspx/removercaandcapa",
                    data: JSON.stringify({ MacDataId: MacDataId, Type: Type, QCType: QCType }),
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        //$.unblockUI();
                        if (result.d == "1") {
                            showmsg(Type + " Removed Successfully");
                            showreading('');
                        }
                        else {
                            showerrormsg(result.d);

                            // console.log(save);
                        }

                    },
                    error: function (xhr, status) {

                        //$.unblockUI();

                    }
                });



                $find("<%=ModalPopupExtender2.ClientID%>").hide();

            }
        }
        function addremark1() {
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            remarks = objEditor.getData();
            if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                remarks = "";
            }

            if (remarks == "") {
                $('#<%=txtremarkstext.ClientID%>').focus();
                showerrormsg("Please Enter or Select Remark");
                return;

            }

            var MacDataId = $('#trid').val();
            var Type = $('#remarksheader1').html();
            var QCType = "QC";
            var Comment = remarks;

            //$.blockUI();

            $.ajax({
                url: "QCReport.aspx/savercaandcapa",
                data: JSON.stringify({ MacDataId: MacDataId, Type: Type, QCType: QCType, Comment: Comment }),
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        showmsg(Type+" Save Successfully");
                        showreading('');
                    }
                    else {
                        showerrormsg(result.d);

                        // console.log(save);
                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });



            $find("<%=ModalPopupExtender2.ClientID%>").hide();

        }
    </script>

    <script type="text/javascript">


        function getparameterlist1() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).closest('tr').attr('id') != "trheader" && $(this).closest('tr').find('#ch1').prop('checked') == true) {
                    var objResult = new Object();
                    objResult.ID = $(this).closest('tr').attr('id');
                    objResult.RCA = $(this).find('#RCA').html();
                    objResult.CorrectiveAction = $(this).find('#CorrectiveAction').html();
                    objResult.PreventiveAction = $(this).find("#PreventiveAction").html();
                    dataIm.push(objResult);
                }
            });
            return dataIm;
        }


        function savercaandcapa() {


            var s1 = 0;

            $('#tblitemlist tr').each(function () {

                if ($(this).attr("id") != "trheader" && $(this).find("#ch1").is(':checked')) {
                    if ($(this).find('#RCA').html() == "" && $(this).find('#CorrectiveAction').html() == "" && $(this).find('#PreventiveAction').html() == "") {
                        s1 = 1;
                        $(this).find('#ch1').focus();
                        return;
                    }
                }
            });

            if (s1 == 1) {
                showerrormsg("Please Select RCA or Corrective Action or Preventive Action");
                return false;
            }


           


            var datatosave = getparameterlist1();



            if (datatosave.length == 0) {
                showerrormsg("Please Select Data");
                return;
            }


            //$.blockUI();
           
            $.ajax({
                url: "QCReport.aspx/savercaandcapa",
                data: JSON.stringify({ qcdatatosave: datatosave }),
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        showmsg("RCA -- Corrective Action -- Preventive Action Save Successfully");

                        showreading('');

                    }
                    else {
                        showerrormsg(result.d);

                        // console.log(save);
                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }


    </script>


    <script type="text/javascript">
        function openbox(trid, type) {

            var ctrl = $('#tblitemlist tr#' + trid);


            if (type == "1") {
                openrca(ctrl);
                return;
            }
            else if (type == "2") {
                openca(ctrl);
                return;
            }
            else if (type == "3") {
                openpa(ctrl);
                return;
            }


            if (type == "1" && $(ctrl).find('#RCAType').html() == "CheckList") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + $(ctrl).attr('id') + "&type=RCA&qctype=QC");
                return;
            }
            if (type == "1" && $(ctrl).find('#RCAType').html() == "Comment") {
                openrca(ctrl);
                return;
            }
            if (type == "2" && $(ctrl).find('#RCAType').html() == "CheckList") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + $(ctrl).attr('id') + "&type=CorrectiveAction&qctype=QC");
                return;
            }
            if (type == "2" && $(ctrl).find('#RCAType').html() == "Comment") {
                openca(ctrl);
                return;
            }

            if (type == "3" && $(ctrl).find('#RCAType').html() == "CheckList") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + $(ctrl).attr('id') + "&type=PreventiveAction&qctype=QC");
                return;
            }
            if (type == "3" && $(ctrl).find('#RCAType').html() == "Comment") {
                openpa(ctrl);
                return;
            }


            $('#<%=txtype.ClientID%>').val(type);
            $('#<%=txtypeopen.ClientID%>').val(trid);
            
            $find("<%=ModalPopupExtender3.ClientID%>").show();

        }


        function openmychoice() {
            var trid = $('#<%=txtypeopen.ClientID%>').val();
            var ctrl = $('#tblitemlist tr#' + trid);

            if ($("#<%=rdrca.ClientID%>").find(":checked").val() == "0") {
                $find("<%=ModalPopupExtender3.ClientID%>").hide();
                if ($('#<%=txtype.ClientID%>').val() == "1") {
                    openrca(ctrl);
                }
                else if ($('#<%=txtype.ClientID%>').val() == "2") {
                    openca(ctrl);
                }
                else if ($('#<%=txtype.ClientID%>').val() == "3") {
                    openpa(ctrl);
                }
            }
            else {
               
                var macdataid = $(ctrl).closest('tr').attr('id');
               
                var type = "";
                var qctype = 'QC';

                if ($('#<%=txtype.ClientID%>').val() == "1")
                    type = "RCA";
                else if ($('#<%=txtype.ClientID%>').val() == "2")
                    type = "CorrectiveAction";
                else if ($('#<%=txtype.ClientID%>').val() == "3")
                    type = "PreventiveAction";

                $find("<%=ModalPopupExtender3.ClientID%>").hide();
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + macdataid + "&type=" + type + "&qctype=" + qctype);
            }
        }



        function openmypopup(href) {
            var width = '1250px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'min-height': '800px',
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
                    showreading('');
                }
            });
        }
       

     function verifyreading() {

            if ($('#tblitemlist tr').length == 1) {
                showerrormsg("Please Search QC Reading To Verify..!");
                return;
            }

            var dataIm = new Array();
            var rtr = 0;
            var recordno=0;
            $('#tblitemlist tr').each(function () {
                if ($(this).closest("tr").attr("id") != "trheader" && $(this).closest("tr").find('#chverify').prop('checked')==true) {
                    if ($(this).closest("tr").find("#QCStatus").text().indexOf('Fail') != -1 && ($(this).closest("tr").find("#RCA").text() == "" || $(this).closest("tr").find("#CorrectiveAction").text() == "" || $(this).closest("tr").find("#PreventiveAction").text() == "")) {
                        dataIm = new Array();
                        rtr = 1;
                        recordno = $(this).closest("tr").find("#srno").text();
                        return;
                    }
                    dataIm.push($(this).closest("tr").attr("id"));

                }
            });
            if (rtr == 1) {
                showerrormsg("Please Enter RCA,Corrective Action and Preventive Action for Record No :" + recordno);
                return;
            }
            if (dataIm.length == 0) {
                showerrormsg("Please Select Data To Verify");
                return;
            }

          //$.blockUI();
            $.ajax({
                url: "QCReport.aspx/verifyqcr",
                data: JSON.stringify({ dataIm: dataIm }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {

                    //$.unblockUI();

                    if (result.d == "1") {
                        showmsg("QC Data Verified..");
                        $('#chall').prop('checked', false);
                        showreading('');
                    }
                    else {
                        showerrormsg(result.d);
                    }
                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });
        }
    </script>
</asp:Content>

