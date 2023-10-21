<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQASResultEntry.aspx.cs" Inherits="Design_Quality_EQASResultEntry" %>


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
       
     <%:Scripts.Render("~/bundles/JQueryUIJs") %>
     <%:Scripts.Render("~/bundles/Chosen") %>
     <%:Scripts.Render("~/bundles/MsAjaxJs") %>
     <%:Scripts.Render("~/bundles/JQueryStore") %>
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
                          <b>EQAS Result Entry
                          </b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>

                   


                  </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
         <div class="content">
                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">Centre :
                        </td>

                        <td>
                            <asp:DropDownList class="ddlprocessinglab chosen-select chosen-container" ID="ddlprocessinglab" runat="server" Style="width:350px;" onchange="bindprogram()"></asp:DropDownList>



                        </td>

                          <td style="font-weight: 700">
                             EQAS Program :
                         </td>
                         <td>
                             <asp:DropDownList ID="ddleqasprogram" runat="server" class="ddleqasprogram chosen-select chosen-container" Width="280" >
                           
                          </asp:DropDownList>
                         </td>


                        <td style="font-weight: 700">
                            Current Month/Year :
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>
                            <asp:DropDownList ID="txtcurrentyear" runat="server"  Width="70px"></asp:DropDownList>
                        </td>

                        <td>
                            <input type="button" class="searchbutton" onclick="searchme()" value="Search" />
                        </td>
                        </tr>

                    


                </table>
            </div>
              </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
         <div class="content">

            
                               <table width="90%">
                <tr>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgoldenrodyellow;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Not Saved</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                 <td>Result Saved</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td>Result Approved</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightsalmon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Uploaded</td>

                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>EQAS Done</td>
                    
                </tr>
            </table>
                      
                 


              <div  style="width:1295px; max-height:400px;overflow:auto;">
                   <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                        <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 50px;">Cycle No</td>
                                        <td class="GridViewHeaderStyle" style="width: 72px;">RegDate</td>
                                        <td class="GridViewHeaderStyle">Department</td>
                                         <td class="GridViewHeaderStyle">Visit No</td>
                                        <td class="GridViewHeaderStyle">Sin No</td>
                                        <td class="GridViewHeaderStyle">TestName</td>
                                        <td class="GridViewHeaderStyle">Observation Name</td>
                                        <td class="GridViewHeaderStyle">Result</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">Mac Reading</td>
                                        <td class="GridViewHeaderStyle">Machine</td>
                                        <td class="GridViewHeaderStyle">Unit</td>                                        
                                        <td class="GridViewHeaderStyle">EQAS Result</td>
                                        <td class="GridViewHeaderStyle">EQAS Status</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px">RCA</td>
                                        <td class="GridViewHeaderStyle" style="width: 41px">Corrective Action</td>
                                        <td class="GridViewHeaderStyle" style="width: 41px">Preventive Action</td>
                                       

                                       
                                     
                                     
                                     </tr>

             </table>
                  </div>
             </div>
         </div>

           <div class="POuter_Box_Inventory" style="width:1300px;">
         <div class="content" style="text-align:center;">
             <input type="button" value="Save" class="savebutton" id="btnsave" onclick="savedata('0')" style="display:none;"/>

             <input type="button" value="Approved" class="savebutton" id="btnapproved" onclick="savedata('1')" style="display:none;" />


              <input type="button" value="Send Result To EQAS Provider"  class="savebutton"  id="btnsend" onclick="savedata('2')" style="display:none;" />

             <input type="button" value="EQAS Done"  class="savebutton"  id="btneqasdone" onclick="savedata('3')" style="display:none;" />

             <span style="font-weight:bold;display:none;" id="btnpdfreport1"><input type="checkbox" id="chheader" />Print Header(PDF)</span>&nbsp;
              <input type="button" value="PDF Report"  class="searchbutton"  id="btnpdfreport" onclick="pdfreport()" style="display:none;"  />&nbsp;&nbsp;
               <input type="button" value="Excel Report"  class="searchbutton"  id="btnexcelreport" onclick="excelreport()" style="display:none;"  />


             </div>
               </div>
         </div>

        <div class="POuter_Box_Inventory" id="disp1" style="width:1300px;display:none;color:red;font-size:20px;background-color:white;font-weight:bold;text-align:center;">
             
              </div>
     <asp:Panel ID="panelremarks" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                <span id="remarksheader"></span>
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

                 <table>
                   <tr>
                       <td><input type="button" class="resetbutton" value="Close" onclick="removeremark()" /></td>
                       <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                       <td id="mmcontrol"><input type="button" class="searchbutton" value="Add" onclick="addremark()" />&nbsp;
                           <input type="button" class="resetbutton" value="Remove Comment" onclick="removeremarkandremove()" />&nbsp;
                           <input type="text" id="trid" style="display:none;" />
                       </td>
                   </tr>
                </table>


               
            </center>
        </div>
    </asp:Panel>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />
     <cc1:ModalPopupExtender ID="modelpopupremarks" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelremarks">
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
                </asp:RadioButtonList> <asp:TextBox ID="txtype" runat="server" style="display:none;"></asp:TextBox><asp:TextBox ID="txtypeopen" runat="server" style="display:none;"></asp:TextBox><asp:TextBox ID="txtypeopentest" runat="server" style="display:none;"></asp:TextBox></td>
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


        var cansave = '<%=cansave %>';
        var canapprove = '<%=canapprove %>';
        var canupload = '<%=canupload %>';
        var canfinaldone = '<%=canfinaldone %>';


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
            bindprogram();
        });

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


        function bindprogram() {
            $('#tbl tr').remove();

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
             $('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated');
             if (labid != "0" && labid!=null) {


                 //$.blockUI();
                 $.ajax({
                     url: "EQASRegistration.aspx/bindprogram",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No EQAS Program Mapped with Lab");
                         }

                         jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery('<option></option>').val("0").html("Select EQAS Program"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].ProgramID).html(CentreLoadListData[i].ProgramName));
                         }

                         $("#<%=ddleqasprogram.ClientID%>").trigger('chosen:updated');





                         //$.UNblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.UNblockUI();
                     }
                 });
             }
         }


    </script>
    <script type="text/javascript">
        function searchme() {

            if ($('#<%=ddleqasprogram.ClientID%>').val() == "0") {
                showerrormsg("Please Select Program");
                return;
            }

            $('#tblitemlist tr').slice(1).remove();
            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (labid == "0") {
                return;
            }
            //$.blockUI();
           
            $.ajax({
                url: "EQASResultEntry.aspx/bindresult",
                data: '{labid: "' + labid + '",regisyearandmonth:"' + regisyearandmonth + '",programid:"' + $('#<%=ddleqasprogram.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        //$.UNblockUI();

                    }
                    else {
                        var programname = "";
                        var co = 0;
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            co = parseInt(co + 1);
                            var mydata = "";

                          

                            if (programname != ItemData[i].programname) {

                                mydata = "<tr style='background-color:white' id='triteheader1' class='" + ItemData[i].programid + "' name='" + ItemData[i].centreid + "'><td colspan='18' style='font-weight:bold;'>Provide Name:&nbsp;<span style='background-color:aquamarine'> " + ItemData[i].ProvideName + "</span>&nbsp;&nbsp;&nbsp;Program ID:&nbsp;<span style='background-color:aquamarine'> " + ItemData[i].programid + "</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Program Name:&nbsp;<span style='background-color:aquamarine'> " + ItemData[i].programname + "</span>&nbsp;&nbsp;&nbsp;Expected ResultDate:&nbsp;<span style='background-color:aquamarine'> " + ItemData[i].ExpectedResultDate + "</span>";

                                if (ItemData[i].custatus == "ResultUploaded" && canfinaldone == "1") {
                                    mydata += "<input onclick='openuploadbox(this)' type='button' style='font-weight:bold;cursor:pointer;float:right; background-color: aqua' value='Upload Result'/> ";
                                }

                                if (ItemData[i].custatus == "EQASDone") {
                                    mydata += "<input onclick='openuploadbox(this)' type='button' style='font-weight:bold;cursor:pointer;float:right; background-color: lightgreen' value='Result Uploaded'/> ";
                                }
                                mydata += "</td></tr>";


                            

                                programname = ItemData[i].programname;
                                co = 1;

                             
                                if (ItemData[i].custatus == "New" && cansave=="1") {
                                    $('#btnsave').show();
                                    $('#btnapproved').hide();
                                    $('#btnsend').hide();
                                    $('#btneqasdone').hide();
                                    $('#btnexcelreport').hide();
                                    $('#btnpdfreport').hide();
                                    $('#btnpdfreport1').hide();
                                    

                                }
                                if (ItemData[i].custatus == "ResultDone" && canapprove == "1") {
                                    $('#btnsave').hide();
                                    $('#btnapproved').show();
                                    $('#btnsend').hide();
                                    $('#btneqasdone').hide();
                                    $('#btnexcelreport').hide();
                                    $('#btnpdfreport').hide();
                                    $('#btnpdfreport1').hide();

                                }
                                if (ItemData[i].custatus == "Approved" && canupload == "1") {
                                    $('#btnsave').hide();
                                    $('#btnapproved').hide();
                                    $('#btnsend').show();
                                    $('#btneqasdone').hide();
                                    $('#btnexcelreport').hide();
                                    $('#btnpdfreport').hide();
                                    $('#btnpdfreport1').hide();

                                }
                                if (ItemData[i].custatus == "ResultUploaded" && canfinaldone == "1") {
                                    $('#btnsave').hide();
                                    $('#btnapproved').hide();
                                    $('#btnsend').hide();
                                    $('#btneqasdone').show();
                                    $('#btnexcelreport').hide();
                                    $('#btnpdfreport').hide();
                                    $('#btnpdfreport1').hide();

                                }
                                if (ItemData[i].custatus == "EQASDone") {
                                    $('#btnsave').hide();
                                    $('#btnapproved').hide();
                                    $('#btnsend').hide();
                                    $('#btneqasdone').hide();
                                    $('#btnexcelreport').hide();
                                    $('#btnpdfreport').hide();
                                    $('#btnpdfreport1').hide();

                                }

                                if (ItemData[i].custatus == "ResultUploaded" || ItemData[i].custatus == "EQASDone")
                                {
                                    $('#btnexcelreport').show();
                                  //  $('#btnpdfreport').show();
                                    $('#btnpdfreport1').show();
                                    
                                }

                                    //btnsave  btnapproved btnsend btneqasdone

                            }


                           
                            mydata += "<tr style='background-color:" + ItemData[i].rowcolor + ";' id='" + ItemData[i].test_id + "' class='" + ItemData[i].programid + "' name='" + ItemData[i].centreid + "'>";
                            
                            mydata += '<td class="GridViewLabItemStyle"  id="srno" style="border: solid 1px #66838c;">' + parseInt(i + 1) + '<input type="checkbox" id="chk" checked="checked" disabled="disabled" style="display:none;"  /></td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].cycleno + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].regdate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].departmant + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].VisitNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].barcodeno + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].InvestigationName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;">' + ItemData[i].LabObservationName + '<span id="LabObservationID" style="display: none;">' + ItemData[i].LabObservationID + '</span></td>';
                           
                            if (ItemData[i].ReportType == "1") {
                                mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;" ><input type="text" id="txtvalue" style="width:75px;"  value="' + ItemData[i].ResultValue + '" readonly="readonly"/></td>';
                                mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;" >' + ItemData[i].flag + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;" >' + ItemData[i].MacReading + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;" >' + ItemData[i].MachineName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  style="border: solid 1px #66838c;" >' + ItemData[i].ReadingFormat + '</td>';

                                mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px #66838c;"  ><input type="text" id="txteqasvalue" style="width:75px;"  value="' + ItemData[i].EQASVALUE + '" /></td>';

                                mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px #66838c;">';
                                mydata += '<select id="ddlstatus" style="width: 77px">';
                                mydata += '<option value="Accept" selected="selected">Accept</option> ';
                                mydata += '<option value="Fail">Fail</option> ';
                                mydata += '</select></td>';
                            }
                            else {
                                if (ItemData[i].ReportType == "3") {
                                    mydata += '<td class="GridViewLabItemStyle"  colspan="5"  style="border: solid 1px #66838c;"><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="viewresultbox3report(\'' + ItemData[i].test_id + '\')"/></td>';
                                }
                                else {
                                    mydata += '<td class="GridViewLabItemStyle"  colspan="5"  style="border: solid 1px #66838c;"><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="viewresultbox7report(\'' + ItemData[i].test_id + '\')"/></td>';
                                }
                                mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px #66838c;"  ><input type="text" id="txteqasvalue" style="width:75px;"  value="' + ItemData[i].EQASVALUE + '" /></td>';

                                mydata += '<td class="GridViewLabItemStyle" style="border: solid 1px #66838c;">';
                                mydata += '<select id="ddlstatus" style="width: 77px">';
                                mydata += '<option value="Accept" selected="selected">Accept</option> ';
                                mydata += '<option value="Fail">Fail</option> ';
                                mydata += '</select></td>';
                            }

                            if (ItemData[i].RCA != "") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',1)"/></td>';
                            }
                            else {
                                if (ItemData[i].custatus == "New" || ItemData[i].custatus == "ResultDone" || ItemData[i].custatus == "Approved") {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',1)"/></td>';
                                }
                                else {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                                }
                            }
                            if (ItemData[i].CorrectiveAction != "") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',2)"/></td>';
                            }
                            else {
                                if (ItemData[i].custatus == "New" || ItemData[i].custatus == "ResultDone" || ItemData[i].custatus == "Approved") {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',2)"/></td>';
                                }
                                else {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                                }
                            }

                            if (ItemData[i].PreventiveAction != "") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',3)"/></td>';
                            }
                            else {
                                if (ItemData[i].custatus == "New" || ItemData[i].custatus == "ResultDone" || ItemData[i].custatus == "Approved") {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openbox(\'' + ItemData[i].test_id + '\',\'' + ItemData[i].test_id + '\',3)"/></td>';
                                }
                                else {
                                    mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                                }
                            }
                            mydata += '<td id="RCA" style="display:none;">' + ItemData[i].RCA + '</td>';
                            mydata += '<td id="CorrectiveAction" style="display:none;">' + ItemData[i].CorrectiveAction + '</td>';
                            mydata += '<td id="PreventiveAction" style="display:none;">' + ItemData[i].PreventiveAction + '</td>';

                            mydata += '<td id="RCAType" style="display:none;">' + ItemData[i].RCAType + '</td>';
                            mydata += '<td id="CAType" style="display:none;">' + ItemData[i].CAType + '</td>';
                            mydata += '<td id="PAType" style="display:none;">' + ItemData[i].PAType + '</td>';
                            mydata += '<td id="Test_id" style="display:none;">' + ItemData[i].test_id + '</td>';

                            
                            mydata += '<td id="custatus" style="display:none;">' + ItemData[i].custatus + '</td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }
                        //$.UNblockUI();

                    }

                },
                error: function (xhr, status) {

                    //$.UNblockUI();

                }
            });
        }

    </script>

    <script type="text/javascript">


        function bindremarks(type) {

            jQuery('#ddlremarks option').remove();
            jQuery.ajax({
                url: "EQASResultEntry.aspx/bindremarks",
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



        function getremarks() {


            jQuery.ajax({
                url: "EQASResultEntry.aspx/bindremarksdetail",
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


        function openrca(ctrl) {

            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('RCA');
            $('#remarksheader').html('RCA');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');


            var saveddata = $(ctrl).closest('tr').find('#RCA').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }

            

            if ($(ctrl).closest('tr').find('#custatus').html() == "New" || $(ctrl).closest('tr').find('#custatus').html() == "ResultDone" || $(ctrl).closest('tr').find('#custatus').html() == "Approved") {
                $('#mmcontrol').show();
            }
            else {
                $('#mmcontrol').hide();
            }


            $find("<%=modelpopupremarks.ClientID%>").show();


        }

        function openca(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('Corrective Action');
            $('#remarksheader').html('CorrectiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#CorrectiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }

            if ($(ctrl).closest('tr').find('#custatus').html() == "New" || $(ctrl).closest('tr').find('#custatus').html() == "ResultDone" || $(ctrl).closest('tr').find('#custatus').html() == "Approved") {
                $('#mmcontrol').show();
            }
            else {
                $('#mmcontrol').hide();
            }
            $find("<%=modelpopupremarks.ClientID%>").show();

        }

        function openpa(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
            bindremarks('Preventive Action');
            $('#remarksheader').html('PreventiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#PreventiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }

            if ($(ctrl).closest('tr').find('#custatus').html() == "New" || $(ctrl).closest('tr').find('#custatus').html() == "ResultDone" || $(ctrl).closest('tr').find('#custatus').html() == "Approved") {
                $('#mmcontrol').show();
            }
            else {
                $('#mmcontrol').hide();
            }
            $find("<%=modelpopupremarks.ClientID%>").show();

        }
        function openuploadbox(ctrl) {
            var programid = $(ctrl).closest('tr').attr('class');
            var labid = $(ctrl).closest('tr').attr('name');
            var currentmonth = $('#<%=ddlcurrentmonth.ClientID%>').val();
            var curentyear = $('#<%=txtcurrentyear.ClientID%>').val();
            var href = "EQASResultUpload.aspx?programid=" + programid + "&labid=" + labid + "&currentmonth=" + currentmonth + "&curentyear=" + curentyear;

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': '950px',
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
                    searchme();
                }
            });

        }

        


        function removeremark() {

        
            $find("<%=modelpopupremarks.ClientID%>").hide();
        }
        function addremark() {
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




            $('#tblitemlist #' + $('#trid').val()).find('#' + $('#remarksheader').html()).html(remarks);
            $('#tblitemlist #' + $('#trid').val()).find('#' + $('#remarksheader').html() + 'Img').attr('src', '../../App_Images/Redplus.png');

            var Type = $('#remarksheader').html();
            if (Type == "RCA") {
                $('#tblitemlist #' + $('#trid').val()).find('#RCAType').html('Comment');
            }
            else if (Type == "CorrectiveAction") {
                $('#tblitemlist #' + $('#trid').val()).find('#CAType').html('Comment');
            }
            else if (Type == "PreventiveAction") {
                $('#tblitemlist #' + $('#trid').val()).find('#PAType').html('Comment');
            }

            $find("<%=modelpopupremarks.ClientID%>").hide();

        }

        function removeremarkandremove() {

            if (confirm("Do you want to remove comment?")) {
                var MacDataId = $('#tblitemlist #' + $('#trid').val()).find('#Test_id').html();
                var Type = $('#remarksheader').html();
                var QCType = "EQAS";

                //$.blockUI();

                $.ajax({
                    url: "Eqasresultentry.aspx/removercaandcapa",
                    data: JSON.stringify({ MacDataId: MacDataId, Type: Type, QCType: QCType }),
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        //$.UNblockUI();
                        if (result.d == "1") {
                            showmsg(Type + " Removed Successfully");
                            showreading();
                        }
                        else {
                            showerrormsg(result.d);

                            // console.log(save);
                        }

                    },
                    error: function (xhr, status) {

                        //$.UNblockUI();

                    }
                });


                $('#tblitemlist #' + $('#trid').val()).find('#' + $('#remarksheader').html() + 'Img').attr('src', '../../App_Images/ButtonAdd.png');
                $('#tblitemlist #' + $('#trid').val()).find('#' + $('#remarksheader').html()).html('');
                var Type = $('#remarksheader').html();

                if (Type == "RCA") {
                    $('#tbltest #' + $('#trid').val()).find('#RCAType').html('');
                }
                else if (Type == "CorrectiveAction") {
                    $('#tbltest #' + $('#trid').val()).find('#CAType').html('');
                }
                else if (Type == "PreventiveAction") {
                    $('#tbltest #' + $('#trid').val()).find('#PAType').html('');
                }

                $find("<%=modelpopupremarks.ClientID%>").hide();

            }
        }


    </script>


    <script type="text/javascript">


        function validation() {


            if ($('#tblitemlist tr').length == 0) {
                showerrormsg("Please Search Result..!");
                return false;
            }


            var s11 = 0;
            $('#tblitemlist tr').each(function () {

                if ($(this).attr("id") != "triteheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#txtvalue').val() == "") {
                        s11 = 1;
                        $(this).find('#txtvalue').focus();
                        return;
                    }
                }
            });

            if (s11 == 1) {
                showerrormsg("Please Enter Lab Result Value ");
                return false;
            }


            


            return true;
        }

        function getdata() {

            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).attr("id") != "triteheader1" && $(this).find("#chk").is(':checked')) {
                    var objILCResult = new Object();
                    
                    objILCResult.ProgramID = $(this).attr("class");
                    objILCResult.test_id = $(this).attr("id");
                    objILCResult.Value = $(this).find("#txtvalue").val();
                    objILCResult.EQASvalue = $(this).find("#txteqasvalue").val();
                    objILCResult.EQASStatus = $(this).find("#ddlstatus").val();

                    objILCResult.RCA = $(this).find('#RCA').html();
                    objILCResult.CorrectiveAction = $(this).find('#CorrectiveAction').html();
                    objILCResult.PreventiveAction = $(this).find("#PreventiveAction").html();
                    objILCResult.UploadFileName = "";
                    objILCResult.LabObservationID = $(this).find("#LabObservationID").html();

                    dataIm.push(objILCResult);
                }
            });
            return dataIm;


        }


        function savedata(flag) {


            if (validation() == true) {
                var EQASResultData = getdata();
                if (EQASResultData.length == 0) {
                    showerrormsg("Please Search Result To Save");
                    return;
                }
                //$.blockUI();
                $.ajax({
                    url: "EQASResultEntry.aspx/saveresult",
                    data: JSON.stringify({ EQASResultData: EQASResultData, flag: flag }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        //$.UNblockUI();
                        if (result.d == "1") {
                            if (flag == "0") {
                                showmsg("EQAS Result Saved Successfully..!");
                                searchme();
                            }
                            else if (flag == "1") {
                                showmsg("EQAS Result Approved Successfully..!");
                                searchme();
                            }
                            if (flag == "2") {
                                showmsg("EQAS Result Send To Website Successfully..!");
                                searchme();
                            }
                            if (flag == "3") {
                                showerrormsg("Please Upload Result ");
                            }

                          

                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        //$.UNblockUI();
                        showerrormsg(xhr.responseText);
                    }
                });

            }



        }


       
    </script>

    <script type="text/javascript">

        function excelreport() {

            if ($('#<%=ddleqasprogram.ClientID%>').val() == "0") {
                showerrormsg("Please Select Program");
                return;
            }

       
            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (labid == "0") {
                return;
            }



            jQuery.ajax({
                url: "EQASresultEntry.aspx/exporttoexcel",
                data: '{labid: "' + labid + '",regisyearandmonth:"' + regisyearandmonth + '",programid:"' + $('#<%=ddleqasprogram.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
             
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        //$.UNblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        //$.UNblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }




        function pdfreport() {

            if ($('#<%=ddleqasprogram.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Program");
                 return;
             }


             

             var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             if (labid == "0") {
                 return;
             }

             var phead = 0;
             if ($('#chheader').is(':checked')) {
                 phead = 1;
             }
             window.open('EQASSummaryReport.aspx?labid=' + labid + '&phead=' + phead + '&programid=' + $('#<%=ddleqasprogram.ClientID%>').val() + '&regisyear=' + $('#<%=txtcurrentyear.ClientID%>').val() + '&regismonth=' + $('#<%=ddlcurrentmonth.ClientID%>').val());
           
        }
    </script>

    <script type="text/javascript">
        function openbox(trid, testid, type) {

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
                if ($(ctrl).find('#custatus').html() == "New" || $(ctrl).find('#custatus').html() == "ResultDone" || $(ctrl).find('#custatus').html() == "Approved") {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=RCA&qctype=EQAS");
                }
                else {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=RCA&qctype=EQAS&isapp=1");
                }
                return;
            }
            if (type == "1" && $(ctrl).find('#RCAType').html() == "Comment") {
                openrca(ctrl);
                return;
            }
            if (type == "2" && $(ctrl).find('#CAType').html() == "CheckList") {
                if ($(ctrl).find('#custatus').html() == "New" || $(ctrl).find('#custatus').html() == "ResultDone" || $(ctrl).find('#custatus').html() == "Approved") {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=CorrectiveAction&qctype=EQAS");
                }
                else {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=CorrectiveAction&qctype=EQAS&isapp=1");
                }
                return;
            }
            if (type == "2" && $(ctrl).find('#CAType').html() == "Comment") {
                openca(ctrl);
                return;
            }

            if (type == "3" && $(ctrl).find('#PAType').html() == "CheckList") {
                if ($(ctrl).find('#custatus').html() == "New" || $(ctrl).find('#custatus').html() == "ResultDone" || $(ctrl).find('#custatus').html() == "Approved") {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=PreventiveAction&qctype=EQAS");
                }
                else {
                    openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=PreventiveAction&qctype=EQAS&isapp=1");
                }
                return;
            }
            if (type == "3" && $(ctrl).find('#PAType').html() == "Comment") {
                openpa(ctrl);
                return;
            }


            $('#<%=txtype.ClientID%>').val(type);
            $('#<%=txtypeopen.ClientID%>').val(trid);
            $('#<%=txtypeopentest.ClientID%>').val(testid);

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

            var macdataid = $('#<%=txtypeopentest.ClientID%>').val();
                var trid = $('#<%=txtypeopen.ClientID%>').val();
                var type = "";
                var qctype = 'EQAS';

                if ($('#<%=txtype.ClientID%>').val() == "1")
                type = "RCA";
            else if ($('#<%=txtype.ClientID%>').val() == "2")
                type = "CorrectiveAction";
            else if ($('#<%=txtype.ClientID%>').val() == "3")
                    type = "PreventiveAction";

            $find("<%=ModalPopupExtender3.ClientID%>").hide();

                if (type == "RCA") {
                    $('#tblitemlist tr#' + trid).find('#RCAType').html('CheckList');
                    $('#tblitemlist tr#' + trid).find('#RCA').html('0');
                    $('#tblitemlist tr#' + trid).find('#RCAImg').attr('src', '../../App_Images/Redplus.png');
                }
                else if (type == "CorrectiveAction") {
                    $('#tblitemlist tr#' + trid).find('#CAType').html('CheckList');
                    $('#tblitemlist tr#' + trid).find('#CorrectiveAction').html('0');
                    $('#tblitemlist tr#' + trid).find('#CorrectiveActionImg').attr('src', '../../App_Images/Redplus.png');
                }
                else if (type == "PreventiveAction") {
                    $('#tblitemlist tr#' + trid).find('#PAType').html('CheckList');
                    $('#tblitemlist tr#' + trid).find('#PreventiveAction').html('0');
                    $('#tblitemlist tr#' + trid).find('#PreventiveActionImg').attr('src', '../../App_Images/Redplus.png');
                }

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

                }
            });
        }


        function viewresultbox3report(test_id) {
            window.open('../Lab/LabReportNew.aspx?testid='+test_id+",");

        }

        function viewresultbox7report(test_id) {
            window.open('../Lab/labreportnewhisto.aspx?testid=' + test_id + ",");
        }
    </script>

</asp:Content>

