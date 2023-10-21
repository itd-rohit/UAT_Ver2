<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCResultEntry.aspx.cs" Inherits="Design_Quality_ILCResultEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

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
                            <b>ILC Result Entry</b>

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
                            <asp:DropDownList class="ddlprocessinglab chosen-select chosen-container" ID="ddlprocessinglab" runat="server" Style="width: 450px;" onchange="getilclab()"></asp:DropDownList>



                        </td>



                        <td style="font-weight: 700">ILC Lab :</td>

                        <td colspan="2">
                            <asp:DropDownList class="ddlilclab chosen-select chosen-container" ID="ddlilclab" runat="server" Style="width: 300px;"></asp:DropDownList>
                            &nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>


                    <tr>
                        <td style="font-weight: 700">Sin No 
                                         :</td>

                        <td>
                            <asp:TextBox ID="txtsearch" runat="server" Width="120px" placeholder="Old Or New Sin No" />
                            &nbsp;<strong>Visit ID :</strong>
                            <asp:TextBox ID="txtsearch1" runat="server" Width="120px" placeholder="Old Or New Visit ID" />
                        </td>



                        <td style="font-weight: 700">Current Month/Year :</td>

                        <td>
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>
                            <asp:TextBox ID="txtcurrentyear" runat="server" ReadOnly="true" Width="50px"></asp:TextBox>
                        </td>
                        <td>
                            <input type="button" value="Search" class="searchbutton" onclick="SearchNow()"  id="btnsearch" />

                           


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
                         <td width="55%" align="left">  <input type="button" class="savebutton" value="Save Result" onclick="saveme()" id="btnsave" style="display: none;" /></td>
                    </tr>
                </table>

               
            </div>
        </div>


       

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
                <input type="button" class="searchbutton" value="Add" onclick="addremark()" />&nbsp;
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

                     <ckeditor:ckeditorcontrol ID="txttext"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="500" Height="100" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                    </td>
                </tr>
            </table>
         
            <center>
                <input type="button" class="searchbutton" value="Add" onclick="addtextremark()" />&nbsp;
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
                    url: "ILCResultEntry.aspx/bindilc",
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
            var searchvalue = $('#<%=txtsearch.ClientID%>').val();
            var searchvalue1 = $('#<%=txtsearch1.ClientID%>').val();


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




            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();


            $('#tbltest tr').remove();
            $('#btnsave').hide();
            //$.blockUI();

            jQuery.ajax({
                url: "ILCResultEntry.aspx/getilcresult",
                data: '{ processingcentre: "' + processingcentre + '",searchvalue:"' + searchvalue + '",regisyearandmonth:"' + regisyearandmonth + '",searchvalue1:"' + searchvalue1 + '",ilclab:"' + $('#<%=ddlilclab.ClientID%>').val() + '"}',
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

                        return;
                    }

                    var mydata1 = '<tr id="trheadtest" style="border: solid 1px #66838c;height:30px;">';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 20px;border: solid 1px #66838c;" rowspan="2">#</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 120px;border: solid 1px #66838c;" rowspan="2">Parameter/Test</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 350px;text-align:center;border: solid 1px #66838c;" colspan="3">' + PanelData[0].ProcessingLabName + '</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 400px;text-align:center;border: solid 1px #66838c;" colspan="4">' + PanelData[0].ilclabname + '</td>';


                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 40px;border: solid 1px #66838c;" rowspan="2">Accep table (%)</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 40px;border: solid 1px #66838c;" rowspan="2">Vari ation (%)</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 66px;border: solid 1px #66838c;" rowspan="2">Status</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 78px;border: solid 1px #66838c;" rowspan="2">Remarks</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30px;border: solid 1px #66838c;" rowspan="2">RCA</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 41px;border: solid 1px #66838c;" rowspan="2">Corre ctive Action</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 41px;border: solid 1px #66838c;" rowspan="2">Preve ntive Action</td>';
                    mydata1 += '<td class="GridViewHeaderStyle" style="width: 30px;border: solid 1px #66838c;" rowspan="2">DOC</td>';
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

                        if (PanelData[i].approved == "0") {
                            mydata += '<td><input type="checkbox" id="chk"  /></td>';
                        }
                        else {
                            mydata += '<td></td>';
                        }
                        if (PanelData[i].savedid != "0") {
                            if (PanelData[i].approved == "1") {
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


                            if (PanelData[i].ilclabtypeid == "1") {

                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewvalue" value="' + PanelData[i].newValue + '" readonly="readonly" /></td>';
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewvalue1" value="' + PanelData[i].newValue1 + '" onkeyup="checkaccept(this)" readonly="readonly" /></td>';
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewmethod" value="' + PanelData[i].newmethod + '" readonly="readonly" /></td>';
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewdisplayreading" value="' + PanelData[i].newdisplayreading + '" readonly="readonly" /></td>';
                            }

                            else {
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewvalue" value="' + PanelData[i].newValue + '" onkeyup="checkaccept(this)"/></td>';
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewvalue1" value="' + PanelData[i].newValue1 + '" /></td>';

                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewmethod" value="' + PanelData[i].newmethod + '"/></td>';
                                mydata += '<td align="left" style="border: solid 1px #66838c;font-weight:bold;"><input style="width:98%" type="text" id="txtnewdisplayreading" value="' + PanelData[i].newdisplayreading + '"/></td>';
                            }
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
                            mydata += '<td align="left" style="border: solid 1px #66838c;" >';


                            mydata += '<select id="ddlstatus" style="width: 65px">';
                            mydata += '<option value="">Select</option> ';
                            if (PanelData[i].status != "") {
                                if (PanelData[i].status == 'Accept') {
                                    mydata += '<option value="Accept" selected="selected">Accept</option> ';
                                    mydata += '<option value="Fail">Fail</option> ';
                                }
                                else {

                                    mydata += '<option value="Accept">Accept</option> ';
                                    mydata += '<option value="Fail" selected="selected">Fail</option>';

                                }
                            }
                            else {
                                if (PanelData[i].newValue != "") {
                                    if (vari1 <= PanelData[i].AcceptablePer) {
                                        mydata += '<option value="">Select</option>';
                                        mydata += '<option value="Accept" selected="selected">Accept</option> ';
                                        mydata += '<option value="Fail">Fail</option> ';
                                    }
                                    else {
                                        mydata += '<option value="">Select</option>';
                                        mydata += '<option value="Accept">Accept</option> ';
                                        mydata += '<option value="Fail" selected="selected">Fail</option>';

                                    }
                                }
                                else {
                                    mydata += '<option value="">Select</option>';
                                    mydata += '<option value="Accept">Accept</option> ';
                                    mydata += '<option value="Fail">Fail</option>';
                                }
                            }



                            mydata += '</select></td>';
                           


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
                            mydata += '<td align="left" style="border: solid 1px #66838c;" >';


                            mydata += '<select id="ddlstatus" style="width: 65px">';
                            mydata += '<option value="">Select</option>';
                            if (PanelData[i].status != "") {
                                if (PanelData[i].status == 'Accept') {
                                    mydata += '<option value="Accept" selected="selected">Accept</option> ';
                                    mydata += '<option value="Fail">Fail</option> ';
                                }
                                else {

                                    mydata += '<option value="Accept">Accept</option> ';
                                    mydata += '<option value="Fail" selected="selected">Fail</option>';

                                }
                            }
                            else {

                                mydata += '<option value="Accept">Accept</option> ';
                                mydata += '<option value="Fail">Fail</option> ';

                            }



                            mydata += '</select></td>';


                           

                        }


                        mydata += '<td align="left" style="border: solid 1px #66838c;" ><input type="text" style="width:98%" maxlength="100" id="txtremarks" value="' + PanelData[i].Remarks + '"/></td>';


                        if (PanelData[i].RCA != "") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openrca(this)"/></td>';
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openrca(this)"/></td>';
                        }
                        if (PanelData[i].CorrectiveAction != "") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openca(this)"/></td>';
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="CorrectiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openca(this)"/></td>';
                        }

                        if (PanelData[i].PreventiveAction != "") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openpa(this)"/></td>';
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="PreventiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openpa(this)"/></td>';
                        }
                        if (PanelData[i].UploadFileName != "") {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="UploadFileNameImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openuploadpage(this)"/></td>';
                        }
                        else {
                            mydata += '<td align="left" style="border: solid 1px #66838c;" ><img id="UploadFileNameImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openuploadpage(this)"/></td>';
                        }

                        

                        mydata += '<td id="savedid" style="display:none;">' + PanelData[i].mapid  + '</td>';
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
                        mydata += '<td id="approved" style="display:none;">' + PanelData[i].approved + '</td>';
                        
                        mydata += '<td id="UploadFileName" style="display:none;">' + PanelData[i].UploadFileName + '</td>';
                        mydata += '</tr>';






                        $('#tbltest').append(mydata);
                        tablefunction(PanelData[i].LabObservation_ID);

                    }


                    $('#btnsave').show();
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    alert("Error ");
                    $('#btnsave').hide();
                }
            });

        }

        function tablefunction(trid) {

           
            if ($('#tbltest #' + trid).find('#approved').html() == "1") {
                $('#tbltest #' + trid).find("input,button,textarea,select").attr("disabled", "disabled");
            }
          

        }
        function checkaccept(ctrl) {
            if ($(ctrl).val() == "") {
                $(ctrl).closest('tr').find('#txtvari').html('');
                $(ctrl).closest('tr').find('#txtvari').css('background-color', '')
                $(ctrl).closest('tr').find('#ddlstatus').val('');
                return;
            }
            var A = Number($(ctrl).closest('tr').find('#txtoldvalue').html());
            var B = Number($(ctrl).val());
            var vari = parseInt(((A - B) / A) * 100);
            var vari1 = Number(vari);
            var co = "red";
            if (vari1 < 0) {
                vari1 = vari1 * -1;
            }

            if (vari1 <= Number($(ctrl).closest('tr').find('#txtAcceptablePer').html())) {
                co = "lightgreen";

                $(ctrl).closest('tr').find('#ddlstatus').val('Accept');

            }
            else {
                $(ctrl).closest('tr').find('#ddlstatus').val('Fail');

            }
            $(ctrl).closest('tr').find('#txtvari').html(vari);
            $(ctrl).closest('tr').find('#txtvari').css('background-color', co)


        }


    </script>

    <script type="text/javascript">

        function validation() {


            if ($('#tbltest tr').length == 0) {
                showerrormsg("Please Search Result..!");
                return false;
            }


            var s11 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find('#reporttype').html() == "1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#txtnewvalue').val() == "") {
                        s11 = 1;
                        $(this).find('#txtnewvalue').focus();
                        return;
                    }
                }
            });

            if (s11 == 1) {
                showerrormsg("Please Enter Lab Result Value ");
                return false;
            }


            var s12 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find('#reporttype').html() == "3" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#OLDValuespan').html() == "") {
                        s12 = 1;
                        $(this).find('#OLDValueText').focus();
                        return;
                    }
                }
            });

            if (s12 == 1) {
                showerrormsg("Please Enter Lab Result Value ");
                return false;
            }

            var s13 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find('#reporttype').html() == "3" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#NEWValuespan').html() == "") {
                        s13 = 1;
                        $(this).find('#NEWValueText').focus();
                        return;
                    }
                }
            });

            if (s13 == 1) {
                showerrormsg("Please Enter Lab Result Value ");
                return false;
            }



            var s1 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#ddlstatus').val() == "") {
                        s1 = 1;
                        $(this).find('#ddlstatus').focus();
                        return;
                    }
                }
            });

            if (s1 == 1) {
                showerrormsg("Please Select Status ");
                return false;
            }


            var s2 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#ddlstatus').val() == "Fail" && $(this).find('#RCA').html() == "" && $(this).find('#UploadFileName').html() == "") {
                        s2 = 1;
                        $(this).find('#RCAImg').focus();
                        return;
                    }
                }
            });

            if (s2 == 1) {
                showerrormsg("Please Select RCA or Upload File");
                return false;
            }


            var s3 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find("#chk").is(':checked')) {
                    if ($(this).find('#ddlstatus').val() == "Fail" && $(this).find('#CorrectiveAction').html() == "" && $(this).find('#UploadFileName').html() == "") {
                        s3 = 1;
                        $(this).find('#CorrectiveActionImg').focus();
                        return;
                    }
                }
            });

            if (s3 == 1) {
                showerrormsg("Please Select Corrective Action  or Upload File ");
                return false;
            }


            var s4 = 0;
            $('#tbltest tr').each(function () {

                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1") {
                    if ($(this).find('#ddlstatus').val() == "Fail" && $(this).find('#PreventiveAction').html() == "" && $(this).find('#UploadFileName').html() == "") {
                        s4 = 1;
                        $(this).find('#PreventiveActionImg').focus();
                        return;
                    }
                }
            });

            if (s4 == 1) {
                showerrormsg("Please Select Preventive  Action  or Upload File ");
                return false;
            }


            return true;
        }



        function getdata() {

            var dataIm = new Array();
            $('#tbltest tr').each(function () {
                if ($(this).attr("id") != "trheadtest" && $(this).attr("id") != "trheadtest1" && $(this).find("#chk").is(':checked')) {
                    var objILCResult = new Object();
                    objILCResult.ILCRegistrationID = $(this).find("#mapid").html();
                    objILCResult.EntryMonth = $('#<%=ddlcurrentmonth.ClientID%>').val();
                    objILCResult.EntryYear = $('#<%=txtcurrentyear.ClientID%>').val();
                    objILCResult.ProcessingLabID = $(this).find("#ProcessingLabID").html();
                    objILCResult.ProcessingLabName = $(this).find("#ProcessingLabName").html();
                    objILCResult.ilclabtypeid = $(this).find("#ilclabtypeid").html();
                    objILCResult.ILCLabType = $(this).find("#ILCLabType").html();
                    objILCResult.ILCLabID = $(this).find("#ILCLabID").html();
                    objILCResult.ilclabname = $(this).find("#ilclabname").html();
                    objILCResult.ReportType = $(this).find("#reporttype").html();
                    objILCResult.MapType = $(this).find("#MapType").html();
                    objILCResult.OLDTest_id = $(this).find("#OLDTest_id").html();
                    objILCResult.LabItemID = $(this).find("#LabObservation_ID").html();
                    objILCResult.LabItemName = $(this).find("#LabObservationName").html();
                    objILCResult.Test_id = $(this).find("#Test_id").html();
                    if ($(this).find("#reporttype").html() == "1") {
                        objILCResult.oldvalue = $(this).find("#txtoldvalue").html();
                        objILCResult.oldmethod = $(this).find("#txtoldmethod").html();
                        objILCResult.olddisplayreading = $(this).find("#txtolddisplayreading").html();


                        objILCResult.newvalue = $(this).find("#txtnewvalue").val();
                        objILCResult.newvalue1 = $(this).find("#txtnewvalue1").val();
                        objILCResult.newmethod = $(this).find("#txtnewmethod").val();
                        objILCResult.newdisplayreading = $(this).find("#txtnewdisplayreading").val();

                    }
                    else {
                        objILCResult.oldvalue = $(this).find("#OLDValuespan").html();
                        objILCResult.oldmethod = "";
                        objILCResult.olddisplayreading = "";

                        objILCResult.newvalue = $(this).find("#NEWValuespan").html();
                        objILCResult.newvalue1 = $(this).find("#NEWValueOnespan").html();
                        objILCResult.newmethod = "";
                        objILCResult.newdisplayreading = "";
                    }


                    objILCResult.Acceptable = $(this).find("#txtAcceptablePer").html();
                    objILCResult.Variation = $(this).find("#txtvari").html();
                    objILCResult.Status = $(this).find("#ddlstatus").val();
                    objILCResult.Remarks = $(this).find("#txtremarks").val();
                    
                    objILCResult.RCA = $(this).find('#RCA').html();
                    objILCResult.CorrectiveAction = $(this).find('#CorrectiveAction').html();
                    objILCResult.PreventiveAction = $(this).find("#PreventiveAction").html();
                    objILCResult.UploadFileName = $(this).find("#UploadFileName").html();
                   

                    dataIm.push(objILCResult);
                }
            });
            return dataIm;


        }

        function saveme() {
            if (validation() == true) {
                var ILCResultData = getdata();
                if (ILCResultData.length == 0) {
                    showerrormsg("Please Search Result To Save");
                    return;
                }
                //$.blockUI();
                $.ajax({
                    url: "ILCResultEntry.aspx/saveresult",
                    data: JSON.stringify({ ILCResultData: ILCResultData }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        //$.unblockUI();
                        if (result.d == "1") {
                            showmsg("ILC Result Saved Successfully..!");

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

        }


       
    </script>

    <script type="text/javascript">


        function bindremarks(type) {

            jQuery('#ddlremarks option').remove();
            jQuery.ajax({
                url: "ILCResultEntry.aspx/bindremarks",
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
            bindremarks('Corrective Action');
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
            bindremarks('Preventive Action');
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



        function openuploadpage(ctrl) {
            var filename = "";
            if ($(ctrl).closest('tr').find('#UploadFileName').html() == "") {
                 filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
             }
             else {
                filename = $(ctrl).closest('tr').find('#UploadFileName').html();
            }
            $(ctrl).closest('tr').find('#UploadFileName').html(filename);

            var href = 'ILCUpload.aspx?filename=' + filename + '&Approved=' + $(ctrl).closest('tr').find('#approved') + '&PageName=ResultEntry';

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


        function getremarks() {
           

            jQuery.ajax({
                url: "ILCResultEntry.aspx/bindremarksdetail",
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


           

            $('#tbltest #' + $('#trid').val()).find('#' + $('#remarksheader').html()).html(remarks);
            $('#tbltest #' + $('#trid').val()).find('#' + $('#remarksheader').html() + 'Img').attr('src', '../../App_Images/Redplus.png');
            $find("<%=modelpopupremarks.ClientID%>").hide();

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
        function addtextremark() {
            var objEditor = CKEDITOR.instances['<%=txttext.ClientID%>'];
            remarks = objEditor.getData();
            if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                remarks = "";
            }

            if (remarks == "") {
                $('#<%=txtremarkstext.ClientID%>').focus();
                showerrormsg("Please Enter Result Value");
                return;

            }
            $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "span").html(remarks);

            $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").val('Result Added');

            $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").css('background-color', 'red');
            $('#tbltest #' + $('#trid1').val()).find('#' + $('#spanone').html() + "Text").css('color', 'white');
            $find("<%=modelpopuptext.ClientID%>").hide();
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


</asp:Content>
