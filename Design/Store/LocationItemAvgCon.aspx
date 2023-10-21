<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LocationItemAvgCon.aspx.cs" Inherits="Design_Store_LocationItemAvgCon" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    
     <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
         <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Location Month Wise Buffer Percentage ,Wastage Percentage</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory"  >
            <div id="PatientDetails" class="POuter_Box_Inventory"> 
                <div class="Purchaseheader">
                    Location Details
                </div>
                <div class="row" id="tab1" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Category Type   </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                                  <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                              <div class="col-md-3 ">
                                <label class="pull-left ">Zone  </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                                  <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                            </div>
                              <div class="col-md-3 ">
                                <label class="pull-left ">State  </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                                 <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecity()"></asp:ListBox>
                            </div>
                              <div class="col-md-3 ">
                                <label class="pull-left ">City   </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                                    <asp:ListBox ID="lstCentrecity" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                            </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Centre   </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-9 ">
                                 <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                            </div>
                              <div class="col-md-3 ">
                                <label class="pull-left ">Location   </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-5 ">
                                   <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                            </div>
                               <div class="col-md-4 ">
                                 <asp:CheckBox ToolTip="Check For Not Saved Location" ID="chonly" runat="server" Font-Bold="true" Text="Not Set Locations" onclick="showstorenotcreated()" />
                                </div>
                            </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left ">Month  </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                               <asp:ListBox ID="lstmonth" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" ></asp:ListBox>
                            </div>
                             <div class="col-md-3 ">
                                <label class="pull-left ">Buffer %  </label>
                                <b class="pull-right">:</b>
                                </div>
                             <div class="col-md-3 ">
                                <asp:TextBox ID="txtbufferpercetage" runat="server"  />
                             <cc1:filteredtextboxextender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtbufferpercetage">
                                </cc1:filteredtextboxextender>
                            </div>
                              <div class="col-md-6 ">
                                <label class="pull-left "><b>Feb-May 20%, June-Oct 30%,Nov-Jan 10%:  </b> </label>
                                </div>
                             <div class="col-md-3 ">
                                  <label class="pull-left ">Wastage %   </label>
                                <b class="pull-right">:</b>
                            </div>
                               <div class="col-md-3 ">
                                  <asp:TextBox ID="txtwastagepercetage" runat="server"  Text="2" ReadOnly="true" />
                                  <cc1:filteredtextboxextender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtwastagepercetage">
                                </cc1:filteredtextboxextender>
                                </div>
                            </div>
                          <div class="row" style="text-align:center">
                            <div class="col-md-24 ">
                                 <input type="button" value="Save" id="btnmin"  class="savebutton"  onclick="savealldata()" /> &nbsp;&nbsp;
                                 <input type="button" value="Reset" id="Button1"  class="resetbutton"  onclick="refresh()" style="display:none;" />&nbsp;&nbsp;   <input type="button" value="Search" onclick="    searchdata()" class="searchbutton" />
                                </div>
                           </div>
                        </div>
                    </div>
                  
                </div>
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center" >
                <div class="row" id="Div1" style="margin-top: 0px;">
                    <div class="col-md-26">
                         <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;" rowspan="2">#</td>
                                           <td class="GridViewHeaderStyle" rowspan="2" width="300px" style="text-align:left;">Location</td>
                                           <td class="GridViewHeaderStyle" colspan="12" style="text-align:center;">Buffer Percentage</td>
                                           <td class="GridViewHeaderStyle" rowspan="2" width="150px" style="text-align:left;">Wastage Percentage</td>
                                     </tr>
                                   <tr id="tr1">
                                           <td class="GridViewHeaderStyle" >Jan</td>
                                           <td class="GridViewHeaderStyle" >Feb</td>
                                           <td class="GridViewHeaderStyle" >March</td>
                                           <td class="GridViewHeaderStyle" >April</td>
                                           <td class="GridViewHeaderStyle" >May</td>
                                           <td class="GridViewHeaderStyle" >June</td>
                                           <td class="GridViewHeaderStyle" >July</td>
                                           <td class="GridViewHeaderStyle" >Aug</td>
                                           <td class="GridViewHeaderStyle" >Sep</td>
                                           <td class="GridViewHeaderStyle" >Oct</td>
                                           <td class="GridViewHeaderStyle" >Nov</td>
                                           <td class="GridViewHeaderStyle" >Dec</td>
                                     </tr>
                                 </table>
                        </div>
                    </div>
                      </div>
       </div>
        
         
     <script type="text/javascript">

         function showstorenotcreated() {

             if (($('#<%=chonly.ClientID%>').prop('checked') == true)) {
                  bindalllocation();
              }
              else {

                 jQuery('#<%=lstlocation.ClientID%> option').remove();
                 jQuery('#lstlocation').multipleSelect("refresh");
            }
        }


         


         $(function () {
             $('[id=lstZone]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=lstState]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=lstCentre]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
            
             $('[id=ListCentre]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=ListItem]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=lstmonth]').multipleSelect({
                 includeSelectAllOption: false,
                 filter: true, keepOpen: false
             });
             
           
             $('[id=lstCentreType]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             }); $('[id=lstlocation]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=lstCentrecity]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
           
             bindcentertype();
             bindZone();

         });
    </script>

    


    <script type="text/javascript">
      
    </script>

    <script type="text/javascript">
       
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {}, function (response) {
                jQuery('#lstCentreType').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreType"), isClearControl: '' });
            });
        }
        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                jQuery('#lstZone').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
             });
        }

        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                jQuery('#lstState').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
            });
            bindCentrecity();
        }
        function bindCentrecity() {
            var StateID = jQuery('#lstState').val().toString();
            jQuery('#<%=lstCentrecity.ClientID%> option').remove();
            jQuery('#lstCentrecity').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity', { stateid: StateID }, function (response) {
                jQuery('#lstCentrecity').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecity"), isClearControl: '' });
            });
            bindCentre();
         }

        function bindCentre() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh"); 
            serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId:TypeId,ZoneId:ZoneId,StateID:StateID,cityid:cityId }, function (response) {
                jQuery('#lstCentre').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentre"), isClearControl: '' });
            });
            bindlocation();
        }

        function lstlocation() {
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
            serverCall('LocationItemAvgCon.aspx/bindlocation', {}, function (response) {
                jQuery('#lstlocation').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
            });
        }

        function bindlocation() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = jQuery('#lstCentrecity').val().toString();

            var centreid = jQuery('#lstCentre').val().toString();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
            serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid:centreid,StateID:StateID,TypeId:TypeId,ZoneId:ZoneId,cityId:cityId}, function (response) {
                jQuery('#lstlocation').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
            });
        }
    </script>



    <script type="text/javascript">

        function searchdata() {
            $modelBlockUI();

            var location = $('#lstlocation').val().toString();
            $('#tblitemlist tr').slice(2).remove();

            var _temp = [];
            _temp.push(serverCall('LocationItemAvgCon.aspx/Getdata', { location: location }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    if ($ReqData.length == 0) {
                        toast("Error", "No Item Found..!", "");
                        $('#btnmin').hide();
                        $modelUnBlockUI();
                    }
                    else {
                        $('#btnmin').show();
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push("<tr style='background-color:palegreen);''>");


                            $mydata.push("<td class='GridViewLabItemStyle' >"); $mydata.push(parseInt(i + 1)); $mydata.push("</td>");
                            $mydata.push('<td class="GridViewLabItemStyle"  >'); $mydata.push($ReqData[i]["Location"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["1"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["2"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["3"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["4"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["5"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["6"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["7"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["8"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["9"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["10"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["11"]); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["12"]); $mydata.push('</td>');

                            $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i]["Wastage"]); $mydata.push('</td>');




                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery('#tblitemlist').append($mydata);
                        }
                    }
                    $modelUnBlockUI();
                });
            }));

        }


        function savealldata() {
            var locationid = $('#<%=lstlocation.ClientID%>').val().toString();

            var month = $('#<%=lstmonth.ClientID%>').val().toString();

            var buffer = $('#<%=txtbufferpercetage.ClientID%>').val().toString() == '' ? '0' : $('#<%=txtbufferpercetage.ClientID%>').val().toString();

            var wastage = $('#<%=txtwastagepercetage.ClientID%>').val().toString() == '' ? '0' : $('#<%=txtwastagepercetage.ClientID%>').val().toString();

            if (locationid == "") {
                toast("Error", "Please Select Location", "");
                return;
            }
            if (month == "") {
                toast("Error", "Please Select Month", "");
                return;
            }
            if (buffer == "0") {
                toast("Error", "Please Enter Buffer %", "");
                $('#<%=txtbufferpercetage.ClientID%>').focus();
                return;
            }
            if (wastage == "0") {
                toast("Error", "Please Enter Wastage %", "");
                $('#<%=txtwastagepercetage.ClientID%>').focus();
                return;
            }
            $modelBlockUI();
            serverCall('LocationItemAvgCon.aspx/savedata', { locationid: locationid, month: month, buffer: buffer, wastage: wastage }, function (response) {
                var save = response;
                if (save == "1") {
                    toast("Success", "Data Saved Successfully", "");
                    refresh();
                    searchdata();
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        
            $modelUnBlockUI();
        }

        function refresh() {

            $('#<%=txtbufferpercetage.ClientID%>').val('');
            $('#<%=txtwastagepercetage.ClientID%>').val('2');
            $("#<%=lstmonth.ClientID%> option:selected").prop("selected", false);
            jQuery('#<%=lstmonth.ClientID%>').multipleSelect("refresh");
        }
             
    </script>
</asp:Content>

