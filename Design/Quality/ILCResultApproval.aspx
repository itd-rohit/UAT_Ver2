<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCResultApproval.aspx.cs" Inherits="Design_Quality_ILCResultApproval" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <%:Scripts.Render("~/bundles/JQueryUIJs") %>
    <%:Scripts.Render("~/bundles/Chosen") %>
    <%:Scripts.Render("~/bundles/MsAjaxJs") %>
    <%:Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
	 <script src="http://malsup.github.io/jquery.blockUI.js"></script>
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 1300000">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>ILC Result Approval</b>

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">Select Centre :
                        </td>

                        <td>
                            <asp:DropDownList class="ddlprocessinglab chosen-select chosen-container" ID="ddlprocessinglab" runat="server" Style="width: 400px;" onchange="getilclab()"></asp:DropDownList>



                        </td>



                        <td style="font-weight: 700">ILC Lab :</td>

                        <td>
                            <asp:DropDownList class="ddlilclab chosen-select chosen-container" ID="ddlilclab" runat="server" Style="width: 275px;"></asp:DropDownList>
                          
                        </td>

                            <td style="font-weight: 700">Month/Year :</td>

                        <td>
                           
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>
                             <asp:DropDownList ID="ddlyear" runat="server"  Width="65px"></asp:DropDownList>
                           
                        </td>
                        <td>
                            <input type="button" value="Search" class="searchbutton" onclick="SearchNow()" id="btnsearch" />

                           


                        </td>
                    </tr>


                    


                </table>
            </div>
        </div>

          <div class="POuter_Box_Inventory" id="disp1" style="width:1300px;display:none;color:red;font-size:20px;background-color:white;font-weight:bold;text-align:center;">
             
              </div>


           <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="TestDetail" style="margin-top: 5px; height: 380px; overflow: auto; width: 100%;">
                    <table id="tbltest" style="width: 99%; border-collapse: collapse; table-layout: fixed;">
                    </table>
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="text-align: center; height: 30px;">
                <table width="99%">
                    <tr>
                        <td width="45%" >
                               <table width="90%">
                <tr>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #ffc4e7;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Numeric Report</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Text Report</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Saved</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Result Approved</td>
                    
                </tr>
            </table>
                        </td>
                         <td width="55%" align="left"> 
                             <% if(ApprovalId=="4")
                                    
                                {%>
                             <input type="button" class="savebutton" value="Approve Result" onclick="approvedme()" id="btnsave" style="display: none;" />
                             <%} %>
                             &nbsp;&nbsp;&nbsp;
                              &nbsp;&nbsp;&nbsp;
                             <span  id="ddlreporttype1" style="display: none;font-weight:bold;">Report Type :</span>&nbsp;&nbsp;
                             <select id="ddlreporttype" style="display: none;"><option>Excel</option><option>PDF</option></select>
                              &nbsp;&nbsp;&nbsp;
                            <span style="font-weight:bold;display:none;" id="btnsave11"><input type="checkbox" id="chheader" checked="checked" />Print Header(PDF)</span> 
                             &nbsp;
                             <input type="button" class="searchbutton" value="Print Report" onclick="printme()" id="btnsave1" style="display: none;" />

                         </td>
                    </tr>
                </table>
               
            </div>
        </div>
        </div>


    <div id="popup_box" style="width:980px;left:10%;top:15%;">
       
        <div style="width:99%;overflow:auto;">
        <table width="99%" frame="box" rules="all" border="1">
          
             <tr style="    background-color: lightseagreen; color: white;font-weight: bold">
                <td colspan="2">Result EntryDate</td>
                 <td colspan="3">Result EntryBy</td>
            </tr>
             <tr>
                <td colspan="2"><span id="ResultEntryDate"></span></td>
                 <td colspan="3"><span id="ResultEntryBy"></span></td>
            </tr>
              <tr>
                 <td colspan="5"><br /></td>
            </tr>

             <tr style="    background-color: lightseagreen; color: white;font-weight: bold">
                <td colspan="2">Approved Date</td>
                 <td colspan="3">Approved By</td>
            </tr>
             <tr>
                <td colspan="2"><span id="ApprovedDate"></span></td>
                 <td colspan="3"><span id="ApprovedBy"></span></td>
            </tr>
            
   </table>
        </div>
       <center>

           <input type="button" value="Close" class="resetbutton" onclick="unloadPopupBox()" />
       </center> 
       
    </div>

    
      <asp:Panel ID="panelremarks" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                <span id="remarksheader"></span>
            </div>

            <table width="99%">
             
                  <tr>
                    <td>
                        Remarks :
                    </td>

                    <td>

                     <ckeditor:ckeditorcontrol ReadOnly="true" ID="txtremarkstext"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="500" Height="100" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                    </td>
                </tr>
            </table>
         
            <center>
               
                  <input type="button" class="resetbutton" value="Cancel" onclick="removeremark()" />&nbsp;
               

                <input type="text" id="trid" style="display:none;" />
            </center>
        </div>
    </asp:Panel>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />
     <cc1:ModalPopupExtender ID="modelpopupremarks" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelremarks">
    </cc1:ModalPopupExtender>




    <asp:Panel ID="pnltext" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px; background-color: whitesmoke;">
            <div class="Purchaseheader">
                <span id="spanone"></span>
            </div>

            <table width="99%">
              
                  <tr>
                    <td>
                        Result Value :
                    </td>

                    <td>

                     <ckeditor:ckeditorcontrol ID="txttext" ReadOnly="true"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="500" Height="100" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                    </td>
                </tr>
            </table>
         
            <center>
               
                  <input type="button" class="resetbutton" value="Cancel" onclick="removetextremark()" />&nbsp;
               <input type="text" id="trid1" style="display:none;" />

               
            </center>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelpopuptext" runat="server" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnltext">
    </cc1:ModalPopupExtender>
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


            getilclab();

        



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



        function getilclab() {

            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();

            jQuery('#<%=ddlilclab.ClientID%> option').remove();
            $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');
            $('#tbl tr').slice(1).remove();
            if (processingcentre != "0") {



                jQuery.ajax({
                    url: "ILCRegistration.aspx/bindilc",
                    data: '{processingcentre:"' + processingcentre + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        CentreLoadListData = jQuery.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                            showerrormsg("No ILC Lab Found");
                        }

                        jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val("0").html("Select ILC Lab"));
                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].labid).html(CentreLoadListData[i].labname));
                         }

                        $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');





                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });

            }
        }
    </script>

    <script type="text/javascript">
        function SearchNow() {

            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
          


            if (processingcentre == "0") {
                showerrormsg("Please Select Processing Centre");
                return;
            }

            var length = $('#<%=ddlilclab.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No ILC Lab Found For Selected Centre..!");
                $('#<%=ddlilclab.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddlilclab.ClientID%>').val() == "0") {
                showerrormsg("Please Select ILC Lab");
                $('#<%=ddlilclab.ClientID%>').focus();
                return;
            }




            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=ddlyear.ClientID%>').val();


            $('#tbltest tr').remove();
            $('#btnsave').hide();
            $('#btnsave1').hide();
            $('#btnsave11').hide();
            $('#ddlreporttype').hide();
            $('#ddlreporttype1').hide();
            //$.blockUI();

            jQuery.ajax({
                url: "ILCResultApproval.aspx/getilcresult",
                data: '{ processingcentre: "' + processingcentre + '",regisyearandmonth:"' + regisyearandmonth + '",ilclab:"' + $('#<%=ddlilclab.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length === 0) {
                        showerrormsg("No Data Found");
                        //$.unblockUI();
                        $('#btnsave').hide();
                        $('#btnsave1').hide();
                        $('#btnsave11').hide();
                        $('#ddlreporttype').hide();
                        $('#ddlreporttype1').hide();
                        return;
                    }

                    var mydata1 = '<tr id="trheadtest" style="border: solid 1px #66838c;height:30px;">';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 20px;border: solid 1px #66838c;" rowspan="2">#</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 120px;border: solid 1px #66838c;" rowspan="2">Parameter/Test</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 350px;text-align:center;border: solid 1px #66838c;" colspan="3">' + PanelData[0].ProcessingLabName + '</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 400px;text-align:center;border: solid 1px #66838c;" colspan="4">' + PanelData[0].ilclabname + '</td>';


                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 40px;border: solid 1px #66838c;" rowspan="2">Accep table (%)</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 40px;border: solid 1px #66838c;" rowspan="2">Vari ation (%)</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 45px;border: solid 1px #66838c;" rowspan="2">Status</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 78px;border: solid 1px #66838c;" rowspan="2">Remarks</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30px;border: solid 1px #66838c;" rowspan="2">RCA</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 41px;border: solid 1px #66838c;" rowspan="2">Corre ctive Action</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 41px;border: solid 1px #66838c;" rowspan="2">Preve ntive Action</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30px;border: solid 1px #66838c;" rowspan="2">DOC</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 20px;border: solid 1px #66838c;" rowspan="2"></td>';
                    mydata1 += '</tr>';

                    mydata1 += '<tr id="trheadtest1" style="border: solid 1px #66838c;height:30px;">';

                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 40%;border: solid 1px #66838c;">Lab Result Value</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30%;border: solid 1px #66838c;">Method</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30%;border: solid 1px #66838c;">Bio. Ref. Range</td>';

                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30%;border: solid 1px #66838c;">Result Value 1</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30%;border: solid 1px #66838c;">Result Value 2</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 20%;border: solid 1px #66838c;">Method</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 20%;border: solid 1px #66838c;">Bio. Ref. Range</td>';


                    mydata1 += '</tr>';

                    $('#tbltest').append(mydata1);

                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var color = 'bisque';
                        if (PanelData[i].reporttype == "1") {
                            color = '#ffc4e7';
                        }
                        var ii = PanelData[i].LabObservation_ID + '_' + PanelData[i].MapType;
                        var mydata = '<tr style="background-color:' + color + ';border: solid 1px #66838c;height:25px;" class="GridViewItemStyle" id=' + ii + '>';

                        if (PanelData[i].Approved == "0") {
                            mydata += '<td><input type="checkbox" id="chk"  /></td>';
                        }
                        else {
                            mydata += '<td></td>';
                        }
                        if (PanelData[i].savedid != "") {
                            if (PanelData[i].Approved == "1") {
                                mydata += '<td align="left" style="font-weight:bold;border: solid 1px #66838c;background-color:lightgreen;word-break: break-all;">' + PanelData[i].LabObservationName + '</td>';
                            }
                            else {
                                mydata += '<td align="left" style="font-weight:bold;border: solid 1px #66838c;background-color:aqua;word-break: break-all;">' + PanelData[i].LabObservationName + '</td>';
                            }
                        }
                        else {
                            mydata += '<td align="left" style="font-weight:bold;border: solid 1px #66838c;word-break: break-all;">' + PanelData[i].LabObservationName + '</td>';
                        }
                        if (PanelData[i].reporttype == "1") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;word-break: break-all;" id="txtoldvalue">' + PanelData[i].OLDValue + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;word-break: break-all;" id="txtoldmethod">' + PanelData[i].oldmethod + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;word-break: break-all;" id="txtolddisplayreading">' + PanelData[i].olddisplayreading + '</td>';




                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;">' + PanelData[i].newValue + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;">' + PanelData[i].newValue1 + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;">' + PanelData[i].newmethod + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;">' + PanelData[i].newdisplayreading + '</td>';

                            var co = ""; var vari = "";
                            if (PanelData[i].newValue != "") {
                                var A = Number(PanelData[i].OLDValue);
                                var B = Number(PanelData[i].newValue);
                                vari = parseInt(((A - B) / A) * 100);
                                var vari1 = Number(vari);
                                co = "red";
                                if (vari1 < 0) {
                                    vari1 = vari1 * -1;
                                }
                                if (vari1 <= PanelData[i].AcceptablePer) {
                                    co = "lightgreen";
                                }
                            }
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;" id="txtAcceptablePer">' + PanelData[i].AcceptablePer + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;background-color:' + co + '" id="txtvari" >' + vari + '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;" >' + PanelData[i].status + '</td>';



                        }
                        else {

                            if (PanelData[i].OLDValue != "") {
                                mydata += '<td align="left" colspan="3" style="border: solid 1px #66838c;" ><input readonly="readonly" onfocus="addremarktext(this,\'OLDValue\')" type="text" style="width:80px;background-color:red;color:white;" value="Result Added" id="OLDValueText"/><span id="OLDValuespan" style="display:none;">' + PanelData[i].OLDValue + '</span></td>';
                            }
                            else {
                                mydata += '<td align="left" colspan="3" style="border: solid 1px #66838c;" ><input readonly="readonly" onfocus="addremarktext(this,\'OLDValue\')" type="text" style="width:80px" id="OLDValueText"/><span id="OLDValuespan" style="display:none;">' + PanelData[i].OLDValue + '</span></td>';
                            }
                            mydata += '<td align="left" colspan="4" style="border: solid 1px #66838c;" >';
                            if (PanelData[i].newValue != "") {
                                mydata += '<input readonly="readonly" onfocus="addremarktext(this,\'NEWValue\')" type="text" style="width:80px;background-color:red;color:white;" value="Result Added" id="NEWValueText"/><span id="NEWValuespan" style="display:none;">' + PanelData[i].newValue + '</span>';
                            }
                            else {
                                mydata += '<input readonly="readonly" onfocus="addremarktext(this,\'NEWValue\')" type="text" style="width:80px" id="NEWValueText"/><span id="NEWValuespan" style="display:none;">' + PanelData[i].newValue + '</span>';
                            }

                            if (PanelData[i].newValue1 != "") {
                                mydata += '&nbsp;&nbsp;&nbsp;<input readonly="readonly" onfocus="addremarktext(this,\'NEWValueOne\')" type="text" style="width:80px;background-color:red;color:white;" value="Result Added" id="NEWValueOneText" /><span id="NEWValueOnespan" style="display:none;">' + PanelData[i].newValue1 + '</span>';
                            }
                            else {
                                mydata += '&nbsp;&nbsp;&nbsp;<input readonly="readonly" onfocus="addremarktext(this,\'NEWValueOne\')" type="text" style="width:80px" id="NEWValueOneText" /><span id="NEWValueOnespan" style="display:none;">' + PanelData[i].newValue1 + '</span>';
                            }
                            mydata += '</td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;" id="txtAcceptablePer"></td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;" id="txtvari" ></td>';
                            mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;" >' + PanelData[i].status + '</td>';




                        }


                        mydata += '<td align="left" style="border: solid 1px #66838c;" >' + PanelData[i].Remarks + '</td>';


                        if (PanelData[i].RCA != "") {
                            if (PanelData[i].RCAType == "Comment") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openrca(this)"/></td>';
                            }
                            else {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ii + '\',\'' + PanelData[i].Test_id + '\',1)"/></td>';
                            }
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                        }
                        if (PanelData[i].CorrectiveAction != "") {
                            if (PanelData[i].CAType == "Comment") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openca(this)"/></td>';
                            }
                            else {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ii + '\',\'' + PanelData[i].Test_id + '\',2)"/></td>';
                            }
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                        }

                        if (PanelData[i].PreventiveAction != "") {
                            if (PanelData[i].PAType == "Comment") {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openpa(this)"/></td>';
                            }
                            else {
                                mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openbox(\'' + ii + '\',\'' + PanelData[i].Test_id + '\',3)"/></td>';
                            }
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                        }
                        if (PanelData[i].UploadFileName != "") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="UploadFileNameImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openuploadpage(this)"/></td>';
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ></td>';
                        }
                        mydata += '<td  align="center" style="border: solid 1px #66838c;font-weight:bold;" title="Click To View Detail" ><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewdetail(this)"/></td>';
                        mydata += '<td id="savedid" style="display:none;">' + PanelData[i].savedid + '</td>';
                        mydata += '<td id="mapid" style="display:none;">' + PanelData[i].savedid + '</td>';
                        mydata += '<td id="ProcessingLabID" style="display:none;">' + PanelData[i].ProcessingLabID + '</td>';
                        mydata += '<td id="ProcessingLabName" style="display:none;">' + PanelData[i].ProcessingLabName + '</td>';
                        mydata += '<td id="ilclabtypeid" style="display:none;">' + PanelData[i].ilclabtypeid + '</td>';
                        mydata += '<td id="ILCLabType" style="display:none;">' + PanelData[i].ILCLabType + '</td>';
                        mydata += '<td id="ILCLabID" style="display:none;">' + PanelData[i].ILCLabID + '</td>';
                        mydata += '<td id="ilclabname" style="display:none;">' + PanelData[i].ilclabname + '</td>';
                        mydata += '<td id="reporttype" style="display:none;">' + PanelData[i].reporttype + '</td>';
                        mydata += '<td id="OLDTest_id" style="display:none;">' + PanelData[i].OLDTest_id + '</td>';
                        mydata += '<td id="MapType" style="display:none;">' + PanelData[i].MapType + '</td>';
                        mydata += '<td id="LabObservation_ID" style="display:none;">' + PanelData[i].LabObservation_ID + '</td>';
                        mydata += '<td id="LabObservationName" style="display:none;">' + PanelData[i].LabObservationName + '</td>';
                        mydata += '<td id="Test_id" style="display:none;">' + PanelData[i].Test_id + '</td>';


                        mydata += '<td id="RCA" style="display:none;">' + PanelData[i].RCA + '</td>';
                        mydata += '<td id="CorrectiveAction" style="display:none;">' + PanelData[i].CorrectiveAction + '</td>';
                        mydata += '<td id="PreventiveAction" style="display:none;">' + PanelData[i].PreventiveAction + '</td>';
                        mydata += '<td id="EntryDate" style="display:none;">' + PanelData[i].EntryDate + '</td>';
                        mydata += '<td id="EntryByName" style="display:none;">' + PanelData[i].EntryByName + '</td>';
                        mydata += '<td id="ApproveDate" style="display:none;">' + PanelData[i].ApproveDate + '</td>';
                        mydata += '<td id="ApprovedByName" style="display:none;">' + PanelData[i].ApprovedByName + '</td>';
                        mydata += '<td id="approved" style="display:none;">' + PanelData[i].Approved + '</td>';
                        mydata += '<td id="UploadFileName" style="display:none;">' + PanelData[i].UploadFileName + '</td>';

                        mydata += '<td id="RCAType" style="display:none;">' + PanelData[i].RCAType + '</td>';
                        mydata += '<td id="CAType" style="display:none;">' + PanelData[i].CAType + '</td>';
                        mydata += '<td id="PAType" style="display:none;">' + PanelData[i].PAType + '</td>';


                        mydata += '</tr>';

                        $('#tbltest').append(mydata);


                    }


                    $('#btnsave').show();
                    $('#btnsave1').show();
                    $('#btnsave11').show();
                    $('#ddlreporttype').show();
                    $('#ddlreporttype1').show();
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    alert("Error ");
                    $('#btnsave').hide();
                    $('#btnsave1').hide();
                    $('#btnsave11').hide();
                    $('#ddlreporttype').hide();
                    $('#ddlreporttype1').hide();
                }
            });

        }

     
       


        function viewdetail(ctrl) {
         
            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            var tr = $(ctrl).closest('tr');

       

            $('#ResultEntryDate').html(tr.find('#EntryDate').html());
            $('#ResultEntryBy').html(tr.find('#EntryByName').html());
            
            $('#ApprovedDate').html(tr.find('#ApproveDate').html());
            $('#ApprovedBy').html(tr.find('#ApprovedByName').html());
           
        }

        function unloadPopupBox() {    // To Unload the Popupbox
           
            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // This is just for style        
                "opacity": "1"
            });
          
        }

    </script>


    <script type="text/javascript">


        function getdata() {

            var dataIm = new Array();
            $('#tbltest tr').each(function () {
                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" &&  $(this).find("#chk").is(':checked')) {
                    var objILCResult = new Object();
                    objILCResult.ILCRegistrationID = $(this).find("#savedid").html();
                    dataIm.push(objILCResult);
                }
            });
            return dataIm;
        }
        function approvedme() {
            if ($('#tbltest tr').length == 0) {
                showerrormsg("Please Search Result..!");
                return;
            }

            var ILCResultData = getdata();
            if (ILCResultData.length == 0) {
                showerrormsg("Please Search Result To Save");
                return;
            }
            //$.blockUI();
            $.ajax({
                url: "ILCResultApproval.aspx/approveresult",
                data: JSON.stringify({ ILCResultData: ILCResultData }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        showmsg("ILC Result Approved Successfully..!");
                        SearchNow();

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


     <script type="text/javascript">

         function openrca(ctrl) {

             $('#trid').val($(ctrl).closest('tr').attr('id'));
          
             $('#remarksheader').html('RCA');
             var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
             objEditor.setData('');


            var saveddata = $(ctrl).closest('tr').find('#RCA').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=modelpopupremarks.ClientID%>").show();


        }

        function openca(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
            
            $('#remarksheader').html('CorrectiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#CorrectiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=modelpopupremarks.ClientID%>").show();

        }

        function openpa(ctrl) {
            $('#trid').val($(ctrl).closest('tr').attr('id'));
           
            $('#remarksheader').html('PreventiveAction');
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $(ctrl).closest('tr').find('#PreventiveAction').html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=modelpopupremarks.ClientID%>").show();

        }


      

            function removeremark() {

                var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                remarks = objEditor.getData();
                if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                    remarks = "";
                }

                if (remarks == "") {
                    $('#tbltest #' + $('#trid').val()).find('#' + $('#remarksheader').html()).html('');
                    $('#tbltest #' + $('#trid').val()).find('#' + $('#remarksheader').html() + 'Img').attr('src', '../../App_Images/ButtonAdd.png');

                }

                $find("<%=modelpopupremarks.ClientID%>").hide();
            }


         function openuploadpage(ctrl) {
             var filename= $(ctrl).closest('tr').find('#UploadFileName').html();
          
             if (filename == "") {
                 showerrormsg("No File Uploaded");
                 return;
             }
             var href = 'ILCUpload.aspx?filename=' + filename + '&Approved=' + $(ctrl).closest('tr').find('#approved') + '&PageName=Approval';

             $.fancybox({
                 'background': 'none',
                 'hideOnOverlayClick': true,
                 'overlayColor': 'gray',
                 'width': '1000px',
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
     
    </script>
    <script type="text/javascript">
        function addremarktext(ctrl,type) {

            $('#trid1').val($(ctrl).closest('tr').attr('id'));
         
            $('#spanone').html(type);
            var objEditor = CKEDITOR.instances['<%=txttext.ClientID%>'];
            objEditor.setData('');

            var saveddata = $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "span").html();

            if (saveddata != "") {
                var objEditor = CKEDITOR.instances['<%=txttext.ClientID%>'];
                objEditor.setData(saveddata);
            }
            $find("<%=modelpopuptext.ClientID%>").show();
        }
      
        

       


        function removetextremark() {

            var objEditor = CKEDITOR.instances['<%=txttext.ClientID%>'];
            remarks = objEditor.getData();
            if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                remarks = "";
            }

            if (remarks == "") {
                $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").val('');
                $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "span").html('');
                $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").css('background-color', 'white');
                $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").css('color', 'black');
               

            }

          


            $find("<%=modelpopuptext.ClientID%>").hide();
        }

    </script>


    <script type="text/javascript">

        function printme() {

            var dataIm = new Array();
            $('#tbltest tr').each(function () {
                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1") {
                    var objILCResult = new Object();
                    objILCResult.ILCRegistrationID = $(this).find("#savedid").html();
                    dataIm.push(objILCResult);
                }

            });



            var ILCResultData = dataIm;
            if (ILCResultData.length == 0) {
                showerrormsg("Please Search Result To Print");
                return;
            }
            //$.blockUI();
            $.ajax({
                url: "ILCResultApproval.aspx/printreport",
                data: JSON.stringify({ ILCResultData: ILCResultData, printtype: $('#ddlreporttype').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    if ($('#ddlreporttype').val() == "Excel") {
                        if (result.d == "false") {
                            showerrormsg("No Item Found");
                            //$.unblockUI();
                        }
                        else {

                            window.open('../Common/exporttoexcel.aspx');
                            //$.unblockUI();

                        }
                    }
                    else {
                        var phead = 0;
                        if ($('#chheader').is(':checked')) {
                            phead = 1;
                        }
                        window.open('ILCSummaryReport.aspx?testid=' + result.d+'&phead='+phead);
                        //$.unblockUI();
                    }

                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });

        }
    </script>

    <script type="text/javascript">

        function openbox(trid, testid, type) {
            if (type == "1") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=RCA&qctype=ILC&isapp=1");
                return;
            }
            if (type == "2") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=RCA&qctype=ILC&isapp=1");
                return;
            }
            if (type == "3") {
                openmypopup("QualityQuestionAnswer.aspx?macdataid=" + testid + "&type=RCA&qctype=ILC&isapp=1");
                return;
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
    </script>
</asp:Content>

