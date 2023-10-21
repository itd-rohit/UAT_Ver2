<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionMissed.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionMissed" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />       
      <%: Scripts.Render("~/bundles/Chosen") %>

      <div id="Pbody_box_inventory" >
             <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align:center;">
                <strong>Missed Home Collection</strong> 
                </div>
           <div class="POuter_Box_Inventory" >
         <div class="row">    
             <div class="col-md-2">
                                            <label class="pull-left"><b>From Date</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-2">
                 <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
             </div>
              <div class="col-md-2"></div>
              <div class="col-md-2">
                                            <label class="pull-left"><b>To Date</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-2">
                 <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                 </div>

             </div>
               <div class="row">    
                 <div class="col-md-2">
                                            <label class="pull-left"><b>State</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-4">
                 <asp:DropDownList ID="ddlstate" runat="server"  onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>  
                 </div>
               <div class="col-md-2">
                                            <label class="pull-left"><b>City</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-4">
                  <asp:DropDownList ID="ddlcity" runat="server"  onchange="bindLocality()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>

                 </div>
                 <div class="col-md-2">
                                            <label class="pull-left"><b>Area</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-4">
                 <asp:DropDownList ID="ddlarea" runat="server"  onchange="bindpincode()" class="ddlarea chosen-select chosen-container"></asp:DropDownList>
                 </div>
               <div class="col-md-2">
                                            <label class="pull-left"><b>Pincode</b></label>
			                                <b class="pull-right">:</b>
                                        </div>

             <div class="col-md-4">
                 <asp:TextBox ID="txtpincode" runat="server"  MaxLength="6"></asp:TextBox> 
                                 <cc1:filteredtextboxextender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                                </cc1:filteredtextboxextender>
                 </div>
               </div>
              <div class="row" style="text-align:center">
                   <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />
                    <input type="button" value="Export To Excel" class="searchbutton" onclick="exceldata()" />
                  </div>
               
                
               </div>
            <div class="POuter_Box_Inventory">
            <div class="row">
                 <div  style="width:100%; max-height:480px;overflow:auto;">
                      <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
                        <tr id="trheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        
                                        <td class="GridViewHeaderStyle" style="width: 150px;">EntryDate</td>
                                        <td class="GridViewHeaderStyle" style="width: 120px;">EntryBy</td>
                                        <td class="GridViewHeaderStyle">Patient Name</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;">Mobile No</td>
                                        <td class="GridViewHeaderStyle" >Address</td>
                                        <td class="GridViewHeaderStyle" >Area</td>
                                        <td class="GridViewHeaderStyle"  style="width: 120px;">City</td>
                                        <td class="GridViewHeaderStyle"  style="width: 120px;">State</td>
                                        <td class="GridViewHeaderStyle"  style="width: 80px;">Pincode</td>
                                        <td class="GridViewHeaderStyle" >Reason</td>
                            </tr>
                          </table>
                     </div>
            </div>
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
         function bindCity(con) {

             jQuery('#<%=ddlcity.ClientID%> option').remove();
              jQuery('#<%=ddlarea.ClientID%> option').remove();
              $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
              $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
             serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
                 cityData = jQuery.parseJSON(result);
                 if (cityData.length == 0) {
                     jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                       }
                       else {
                           jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                           for (i = 0; i < cityData.length; i++) {
                               jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }

                    }
                 $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
             });            
        }
        function bindLocality() {
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: jQuery('#<%=ddlcity.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                           }

                           else {
                               jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                               for (i = 0; i < localityData.length; i++) {
                                   jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                               }
                           }
                $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');

            });
           
               }

         function bindpincode() {

             jQuery('#<%=txtpincode.ClientID%>').val('');
             serverCall('customercare.aspx/bindpincode', { LocalityID: jQuery('#<%=ddlarea.ClientID%>').val() }, function (result) {
                 pincode = result;
                 if (pincode == "") {
                     jQuery('#<%=txtpincode.ClientID%>').val('').attr('readonly', false);
                     }
                     else {
                         jQuery('#<%=txtpincode.ClientID%>').val(pincode).attr('readonly', true);
                     }
             });           
         }
        </script>
    <script type="text/javascript">
        function searchdata() {           
            $('#tbl tr').slice(1).remove();
            serverCall('HomeCollectionMissed.aspx/getdata', { fromdate:  $('#<%=txtfromdate.ClientID%>').val() , todate: $('#<%=txttodate.ClientID%>').val() , stateId:  $('#<%=ddlstate.ClientID%>').val() , cityid:  $('#<%=ddlcity.ClientID%>').val() , areaid:  $('#<%=ddlarea.ClientID%>').val() , pincode:  $('#<%=txtpincode.ClientID%>').val() }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast('Info',"No Missed Home Collection Data Found");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var color = "pink";
                        var mydata = [];
                        mydata.push("<tr style='background-color:"); mydata.push(color); mydata.push(";' id='"); mydata.push(ItemData[i].id); mydata.push("'>");
                        mydata.push('<td class="GridViewLabItemStyle">'); mydata.push(parseInt(i + 1)); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].EntryDate); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].EntryByName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].Pname); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].MobileNo); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].Address); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].AreaName); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].City); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].state); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].Pincode); mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">'); mydata.push(ItemData[i].Reason); mydata.push('</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join("");
                        $('#tbl').append(mydata);
                    }
                }
            });
            
        }
        function exceldata() {
            serverCall('HomeCollectionMissed.aspx/getdataexcel', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: $('#<%=ddlarea.ClientID%>').val(), pincode: $('#<%=txtpincode.ClientID%>').val() }, function (result) {
                ItemData = result;
                if (ItemData == "false") {
                    toast('Info',"No Item Found");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });           
        }
    </script>
</asp:Content>

