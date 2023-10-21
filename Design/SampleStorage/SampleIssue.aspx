<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleIssue.aspx.cs" Inherits="Design_SampleStorage_SampleIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
     <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <b>&nbsp;Sample Issue</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
          <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Search&nbsp;
                    </div>
                   <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Reg Date From</label>
			                <b class="pull-right">:</b>
                       </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtdatefrom" runat="server"></asp:TextBox>
                              <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtdatefrom" PopupButtonID="txtdatefrom" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Reg Date To</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtdateo" runat="server"></asp:TextBox>
                              <cc1:calendarextender ID="Calendarextender1" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtdateo" PopupButtonID="txtdateo" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> 
                            <asp:TextBox ID="txtpname" runat="server"></asp:TextBox>
                        </div>
                   </div>

                   <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">SIN No</label>
			                <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5"> 
                           <asp:TextBox ID="txtsinno" runat="server"></asp:TextBox></div>

                       <div class="col-md-3">
                           <label class="pull-left">Visit No</label>
			                <b class="pull-right">:</b>

                       </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtvisitno" runat="server"></asp:TextBox></div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID No</label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"> <asp:TextBox ID="txtuhidno" runat="server"></asp:TextBox></div>
                   </div>

                   <div class="row">
                          <input type="button" value="Search" class="searchbutton col-md-offset-11" onclick="searchdata()" />
                   </div>
              <table style="width:100%;">
                 <tr><td align="center">
              <table  style="width:50%;border-collapse:collapse">
                        <tr>
                            
                            
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:white;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="font-weight: 700; text-align: left;"> 
                                &nbsp;&nbsp;Sample Stored</td>
                            
                           
                              <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td> <td style="font-weight: 700; text-align: left;"> 
                               &nbsp;&nbsp;Sample Discard</td>
                          

                              
                                   <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" onclick="PatientLabSearch('13')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>  <td style="font-weight: 700; text-align: left;">
                                &nbsp;&nbsp;Sample Issued </td>
                           
                            
                        </tr>
                    </table>
</td></tr> </table>

              </div>


         
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Patient Detail&nbsp;&nbsp;&nbsp; 
                   <span style="color: red;"><b>Total Patient:</b></span>
                <asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="content" style="max-height: 310px; overflow: scroll;">
                <table style="width: 99%" cellspacing="0" id="tbsample" class="GridViewStyle">
                    <tr id="saheader">
                        <th class="GridViewHeaderStyle" scope="col" align="left" >S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">SIN No.</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">Visit No.</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">UHID</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">PName</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">Age/Sex</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">BookingCentre</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">StorageCentre</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">SampleType</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">DeviceName</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">RackNumber</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">TrayNumber</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">SlotNumber</th>
                         <th class="GridViewHeaderStyle" scope="col" align="left">Issue</th>
                    </tr>
                </table>
            </div>

            </div>

         </div>


     <asp:Panel ID="panelold" runat="server" style="display:none;">
          <div class="POuter_Box_Inventory" style="background-color:papayawhip">
               <div class="Purchaseheader">
                                Issue Sample
                                   </div> 
               <div class="content" style="text-align:center;">
                  <table width="100%">
                      <tr>
                          <td style="text-align: right; width: 239px;">Sample Type :&nbsp;&nbsp;</td><td style="text-align: left"><span id="sampletype1" style="font-weight:bold;"></span></td>
                      </tr>
                       <tr>
                          <td style="text-align: right; width: 239px;">SIN No :&nbsp;&nbsp;</td><td style="text-align: left"><span id="sinno1" style="font-weight:bold;"></span></td>
                      </tr>
                       <tr>
                          <td style="text-align: right; width: 239px;">Device :&nbsp;&nbsp;</td><td style="text-align: left"><span id="device1" style="font-weight:bold;"></span></td>
                      </tr>
                       <tr>
                          <td style="text-align: right; width: 239px;">Rack Number :&nbsp;&nbsp;</td><td style="text-align: left"><span id="rack1" style="font-weight:bold;"></span></td>
                      </tr>
                         <tr>
                          <td style="text-align: right; width: 239px;">Tray :&nbsp;&nbsp;</td><td style="text-align: left"><span id="tray1" style="font-weight:bold;"></span></td>
                      </tr>
                      <tr>
                          <td style="text-align: right; width: 239px;font-weight:bold;">Issue To :&nbsp;&nbsp;</td><td style="text-align: left"><asp:TextBox ID="txtissueto" runat="server" /><span id="uniid1" style="font-weight:bold;display:none;"></span></td>
                      </tr>
                       <tr>
                          <td style="text-align: right; width: 239px;font-weight:bold;">Issue Reason :&nbsp;&nbsp;</td><td style="text-align: left"><asp:TextBox ID="txtissuereason" runat="server" Width="321px" /></td>
                      </tr>
                         <tr>
                          <td style="text-align: right; width: 239px;font-weight:bold;">Invoice No :&nbsp;&nbsp;</td><td style="text-align: left"><asp:TextBox ID="txtincoiceno" runat="server" /></td>
                      </tr>
                  </table>

                   <input type="button" class="savebutton" value="Issue" onclick="issuedata()" />
                  <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />

                   </div>
              </div>
    </asp:Panel>

     <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" style="display:none;" />

    <script type="text/javascript">

        

        var pcount = 0;
        function searchdata() {
            var $mydata = [];
             pcount = 0;
             $('#tbsample tr').slice(1).remove();
             serverCall('SampleIssue.aspx/searchIssue',
                 { fromdate: $('#<%=txtdatefrom.ClientID%>').val() , todate: $('#<%=txtdateo.ClientID%>').val() , pname:$('#<%=txtpname.ClientID%>').val() , sinno: $('#<%=txtsinno.ClientID%>').val() , visitno:$('#<%=txtvisitno.ClientID%>').val() , uhid: $('#<%=txtuhidno.ClientID%>').val() },
                 function (result) {
                     
                     PanelData = $.parseJSON(result);
                     if (PanelData.length == 0) {
                         toast("Error", "No Data Found.!", "");
                     }
                     else {

                         for (i = 0; i < PanelData.length; i++) {
                             pcount = parseInt(pcount) + 1;
                             $('#<%=lblTotalPatient.ClientID%>').text(pcount);
                             var $mydata = [];
                             $mydata.push("<tr id='" + PanelData[i].uniid + "'  style='background-color:" + PanelData[i].RowColor + ";height:25px;'>");
                             $mydata.push('<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="sinno">' + PanelData[i].Sinno + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle">' + PanelData[i].LedgerTransactionNo + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle">' + PanelData[i].Patient_ID + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle"><b>' + PanelData[i].PName + '</b></td>');
                             $mydata.push('<td class="GridViewLabItemStyle">' + PanelData[i].Pinfo + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle">' + PanelData[i].BookingCentre + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle"><b>' + PanelData[i].StorageCentre + '</b></td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="sampletype">' + PanelData[i].SampleTypeName + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="device">' + PanelData[i].DeviceName + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="rack">' + PanelData[i].RackNumber + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tray">' + PanelData[i].TrayCode + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tray">' + PanelData[i].slotnumber + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issueto">' + PanelData[i].IssueTo + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issuedate">' + PanelData[i].IssueDate + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issueuser">' + PanelData[i].IssueByUserName + '</td>');
                             $mydata.push('<td class="GridViewLabItemStyle">');
                            if (PanelData[i].status == "1") {
                                $mydata.push('<img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="openme(this);" /> ');
                            }
                            else if (PanelData[i].status == "3") {
                                $mydata.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showme(this);" /> ');
                            }
                            $mydata.push('</td>');
                            $mydata = $mydata.join("");
                            $('#tbsample').append($mydata);
                        }
                    }
                 })

        }

        function openme(ctrl) {

           

            $('#uniid1').html($(ctrl).closest("tr").attr("id"));
            $('#sampletype1').html($(ctrl).closest("tr").find("#sampletype").text());
            $('#sinno1').html($(ctrl).closest("tr").find("#sinno").text());
            $('#device1').html($(ctrl).closest("tr").find("#device").text());
            $('#rack1').html($(ctrl).closest("tr").find("#rack").text());
            $('#tray1').html($(ctrl).closest("tr").find("#tray").text());

            $('#<%=txtissueto.ClientID%>').focus();
            $find("<%=modelopdpatient.ClientID%>").show();
        }
        function showme(ctrl) {
            var datatodisp = "Issue To :  " + $(ctrl).closest("tr").find("#issueto").text() + "<br/>" + "Issue Date :  " + $(ctrl).closest("tr").find("#issuedate").text() + "<br/>" + "Issue By :  " + $(ctrl).closest("tr").find("#issueuser").text();

            toast("Success",datatodisp,"");
        }

        function issuedata() {

            if ($('#<%=txtissueto.ClientID%>').val() == "") {
                toast("Success","Please Enter Issuing Person Name","");
                return;
            }
            if ($('#<%=txtissuereason.ClientID%>').val() == "") {
                toast("Success","Please Enter Issuing Reason","");
                return;
            }

            serverCall('SampleIssue.aspx/saveissue',
                { unid:$('#uniid1').html(), barcodeno: $('#sinno1').html() , issueto:$('#<%=txtissueto.ClientID%>').val() , issuepurpose:  $('#<%=txtissuereason.ClientID%>').val(), invoiceno:$('#<%=txtincoiceno.ClientID%>').val() },
                function (result) {
                    PanelData1 = $.parseJSON(result);
                    if (PanelData1 == "1") {

                        toast("Success", "Sample Issue Sucessfully", "");
                        clearform();
                    }
                    else {
                        toast("Error", PanelData1, "");
                    }
                })
            
        }

        function clearform() {
            $('#<%=txtincoiceno.ClientID%>').val('');
            $('#<%=txtissueto.ClientID%>').val('');
            $('#<%=txtissuereason.ClientID%>').val('');
            $('#uniid1').html('');
            $('#sampletype1').html('');
            $('#sinno1').html('');
            $('#device1').html('');
            $('#rack1').html('');
            $('#tray1').html('');
            $find("<%=modelopdpatient.ClientID%>").hide();
            searchdata();
        }
    </script>
</asp:Content>

