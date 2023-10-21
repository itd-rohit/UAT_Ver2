<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleSearchinStore.aspx.cs" Inherits="Design_SampleStorage_SampleSearchinStore" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

     <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Sample Search</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
          <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Search&nbsp;
                    </div>

              
                  <div class="row">
                      <div class="col-md-3">
                      </div>
                      <div class="col-md-3" style="text-align: right; font-weight: 700;">
                          <label class="pull-left">SIN No/Visit ID   </label>
			                <b class="pull-right">:</b>
                      </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtsinno" runat="server" placeholder="Enter Sin No/Visit ID"></asp:TextBox>
                        </div>
                      <div class="col-md-2">
                          <input class="searchbutton" type="button" value="Search" onclick="searchdata()" />
                      </div>
                      <div class="col-md-2">
                          <input class="resetbutton" type="button" value="Reset" onclick="clearall()" /> 
                      </div>
                  </div>
              

                
 


                        <div class="row">
                            <div class="col-md-3">
                            </div>
                            
                            <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:white;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>
                            <div class="col-md-3"  style="font-weight: 700; text-align: left;"> 
                                &nbsp;&nbsp;Sample Stored</div>
                            
                           
                            <div class="col-md-1" style="border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</div> 
                            <div class="col-md-3" style="font-weight: 700; text-align: left;"> 
                               &nbsp;&nbsp;Sample Discard
                            </div>
                            <div class="col-md-1"  style="border-right: black thin solid; border-top: black thin solid; cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" onclick="PatientLabSearch('13')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</div>  
                            <div class="col-md-3" style="font-weight: 700; text-align: left;">
                                &nbsp;&nbsp;Sample Issued 
                            </div>
                        </div>
              </div>
          <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">
                    Patient Detail
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left" style="color:red">Total Patient   </label>
			            <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
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
                        <th class="GridViewHeaderStyle" scope="col" align="left">Status</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">#</th>
                    </tr>
                </table>
            </div>
            </div>
         <asp:Panel ID="panelold" runat="server" style="display:none;" >
          <div class="POuter_Box_Inventory" style="width:600px;background-color:papayawhip">
               <div class="Purchaseheader">
                    Storage Detail
                </div> 
               <div class="content" style="text-align:center;">
                  <table  width="100%">
                      <tr>
                          <td style="text-align: right; ">Stored Date :&nbsp;</td><td style="font-weight: bold; text-align: left"><span id="sdate"></span></td>
                          <td style="text-align: right">Stored By :&nbsp;</td>
                           <td style="text-align: left;font-weight: bold; "><span id="sby"></span></td>
                      </tr>
                          <tr>
                              <td><br /></td>
                          </tr>
                       <tr>
                          <td style="text-align: right; ">Process Date :&nbsp;</td>
                           <td style="font-weight: bold; text-align: left"><span id="pdate"></span></td>
                           <td style=" text-align: right">Expiry Date :&nbsp;</td>
                           <td style="text-align: left;font-weight: bold; "><span id="edate"></span></td>
                           
                      </tr>
                         <tr>
                              <td><br /></td>
                          </tr>
                        <tr>
                          <td style="text-align: right; ">Issue Date :&nbsp;</td>
                            <td style="font-weight: bold; text-align: left"><span id="idate"></span></td>
                            <td style="text-align: right">Issue By :&nbsp;</td>
                            <td style="font-weight: bold; text-align: left"><span id="iby"></span></td>
                      </tr>
                    
                       <tr>
                          <td style="text-align: right; ">Issue To :&nbsp;</td>
                           <td style="font-weight: bold; text-align: left"><span id="ito"></span></td> 
                           <td style="text-align: right">Invoice No :&nbsp;</td>
                           <td style="font-weight: bold; text-align: left"><span id="inno"></span></td>
                      </tr>
                        <tr>
                          <td style="text-align: right; ">Issue Reason :&nbsp;</td><td style="font-weight: bold; text-align: left" colspan="3"><span id="ireason"></span></td>
                           
                      </tr>
                       <tr>
                              <td><br /></td>
                          </tr>
                         <tr>
                          <td style="text-align: right; ">Discard Date :&nbsp;</td>
                           <td style="font-weight: bold; text-align: left"><span id="ddate"></span></td> 
                           <td style="text-align: right">Discard By :&nbsp;</td>
                           <td style="font-weight: bold; text-align: left"><span id="dby"></span></td>
                      </tr>
                  </table>
                  <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />

                   </div>
              </div>
    </asp:Panel>


          <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" runat="server" style="display:none;" />


         </div>

        <script type="text/javascript">

            function clearall() {
                window.location.reload();
            }

        

            $('#ContentPlaceHolder1_txtsinno').on('keyup', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {

                    searchdata();
                }
            });

            function searchdata() {

                if ($('#<%=txtsinno.ClientID%>').val() == "") {
                    toast("Erro","Please Enter Sin No/Visit ID .!","");
                    $('#<%=txtsinno.ClientID%>').val('');
                    $('#<%=txtsinno.ClientID%>').focus();
                    return;
                }
                $('#tbsample tr').slice(1).remove();
                serverCall('samplesearchinstore.aspx/searchIssue', { sinno: $('#<%=txtsinno.ClientID%>').val() }, function (result) {
                    PanelData = $.parseJSON(result);
                    if (PanelData.length == 0) {
                        toast("Error","No Data Found.!","");
                        $('#<%=txtsinno.ClientID%>').val('');
                            $('#<%=txtsinno.ClientID%>').focus();
                        }
                        else {
                        for (i = 0; i < PanelData.length; i++) {
                            var $mydata = [];
                            $mydata.push("<tr id='");
                            $mydata.push(PanelData[i].uniid);
                            $mydata.push("'  style='background-color:");
                            $mydata.push(PanelData[i].RowColor);
                            $mydata.push(";height:25px;'>");
                            $mydata.push( '<td class="GridViewLabItemStyle">');$mydata.push(parseInt(i + 1) );$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="sinno">');$mydata.push(PanelData[i].Sinno);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle">');$mydata.push(PanelData[i].LedgerTransactionNo );$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle">');$mydata.push(PanelData[i].Patient_ID);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"><b>');$mydata.push(PanelData[i].PName);$mydata.push('</b></td>');
                            $mydata.push( '<td class="GridViewLabItemStyle">');$mydata.push( PanelData[i].Pinfo);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle">');$mydata.push(PanelData[i].BookingCentre);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle"><b>');$mydata.push(PanelData[i].StorageCentre);$mydata.push('</b></td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="sampletype">');$mydata.push(PanelData[i].SampleTypeName);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="device">');$mydata.push(PanelData[i].DeviceName );$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="rack">');$mydata.push(PanelData[i].RackNumber);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tray1">');$mydata.push(PanelData[i].TrayCode);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tray3">');$mydata.push(PanelData[i].SlotNumber);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="tray2">');$mydata.push(PanelData[i].mystatus);$mydata.push('</td>');                            
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issueto">');$mydata.push(PanelData[i].IssueTo);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issuedate">');$mydata.push(PanelData[i].IssueDate);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="issueuser">');$mydata.push(PanelData[i].IssueByUserName);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="IssuePurpose">');$mydata.push(PanelData[i].IssuePurpose);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="IssueInvoiceNo">');$mydata.push(PanelData[i].IssueInvoiceNo);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="processingdate">');$mydata.push( PanelData[i].ProcessedDate);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="expirydate">');$mydata.push(PanelData[i].ExpiryDate);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="DiscardDate">');$mydata.push(PanelData[i].DiscardDate);$mydata.push('</td>');
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="DiscardBy">');$mydata.push(PanelData[i].DiscardBy);$mydata.push('</td>');                            
                            $mydata.push( '<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="StoredDate">');$mydata.push( PanelData[i].StoredDate); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;display:none;" id="StoredBy">'); $mydata.push(PanelData[i].StoredBy);$mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">');
                            $mydata.push( '<img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="openme5(this);" /> ');
                            $mydata.push('</td>');
                            $mydata = $mydata.join("");
                            $('#tbsample').append($mydata);
                            }
                        }



                })



            }

          

          

            function openme5(ctrl) {

                $('#sdate').html($(ctrl).closest("tr").find("#StoredDate").text());
                $('#sby').html($(ctrl).closest("tr").find("#StoredBy").text());

                $('#pdate').html($(ctrl).closest("tr").find("#processingdate").text());
                $('#edate').html($(ctrl).closest("tr").find("#expirydate").text());
                $('#idate').html($(ctrl).closest("tr").find("#issuedate").text());
                $('#iby').html($(ctrl).closest("tr").find("#issueuser").text());
                $('#ito').html($(ctrl).closest("tr").find("#issueto").text());
                $('#ireason').html($(ctrl).closest("tr").find("#IssuePurpose").text());
                $('#inno').html($(ctrl).closest("tr").find("#IssueInvoiceNo").text());
                $('#ddate').html($(ctrl).closest("tr").find("#DiscardDate").text());
                $('#dby').html($(ctrl).closest("tr").find("#DiscardBy").text());

                


                $find("<%=modelopdpatient.ClientID%>").show();

            }


            </script>
</asp:Content>

