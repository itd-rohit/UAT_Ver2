<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelbomistHoliday.aspx.cs" Inherits="Design_HomeCollection_PhelbomistHoliday" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" />            
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>


   

       <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">
           
                <strong>Phlebotomist Holiday</strong> 
                </div>
               

              <div class="POuter_Box_Inventory" >
           
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>State</b></label>
			            <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-5">
                              <asp:DropDownList ID="ddlstate" runat="server" onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>  
                       </div>

                        <div class="col-md-3">
                            <label class="pull-left"><b>City</b></label>
			            <b class="pull-right">:</b>
                         </div>

                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlcity" runat="server"  onchange="bindphelbo()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>                      
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>Phlebotomist</b></label>
			            <b class="pull-right">:</b>
                 </div>
                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlphelbotomist" runat="server"  class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                       </div>
                        <div class="col-md-3">
                             <label class="pull-left"><b>From Date</b></label>
			            <b class="pull-right">:</b>
                            </div>
                       <div class="col-md-2">
                              <asp:TextBox ID="txtfromdate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                       </div>
                         <div class="col-md-3"></div>
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
                        <div class="col-md-10"></div>
                        <div class="col-md-2">
                            <input type="button" value="Save" onclick="saveme()" class="savebutton" />
                        </div>                      
                    </div>
                </div>                                  
           <div class="POuter_Box_Inventory" style=" text-align: center;">         
                <div class="Purchaseheader">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left"><b>No of Record</b></label>
			                    <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:DropDownList ID="ddlnoofrecord" runat="server"  Font-Bold="true">
                                    <asp:ListItem Value="50">50</asp:ListItem>
                                    <asp:ListItem Value="100">100</asp:ListItem>
                                    <asp:ListItem Value="200">200</asp:ListItem>
                                    <asp:ListItem Value="500">500</asp:ListItem>
                                    <asp:ListItem Value="1000">1000</asp:ListItem>
                                    <asp:ListItem Value="2000">2000</asp:ListItem>
                                </asp:DropDownList>
                            </div>                                                                               
                            <div class="col-md-1"></div>
                            <div class="col-md-2">
                                <label class="pull-left"><b>From Date</b></label>
			                    <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtfromdate_Serch" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtfromdate_Serch" PopupButtonID="txtfromdate_Serch" Format="dd-MMM-yyyy" runat="server"> </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-1"></div>
                             <div class="col-md-2">
                                 <label class="pull-left"><b>To Date</b></label>
			                    <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txttodate_Serch" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txttodate_Serch" PopupButtonID="txttodate_Serch" Format="dd-MMM-yyyy" runat="server"> </cc1:CalendarExtender>
                            </div>
                             <div class="col-md-1"></div>
                           <div class="col-md-2">
                                <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                           </div>
                            <div class="col-md-2">
                                <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                            </div>
                        </div>
                </div>
                <div style=" height: 200px; overflow: auto;">
                    <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>                           
                            <td class="GridViewHeaderStyle" style="width: 30px;">Cancel</td>                          
                            <td class="GridViewHeaderStyle">Phlebotomist</td>                           
                            <td class="GridViewHeaderStyle">From Date</td>
                            <td class="GridViewHeaderStyle">To  Date</td>
                             <td class="GridViewHeaderStyle">Status</td>
                        </tr>
                    </table>
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
        </script>
    <script type="text/javascript">
        function bindCity() {        
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlphelbotomist.ClientID%> option').remove();
            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
            $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
            var ddlcity;
            ddlcity = $("#<%=ddlcity.ClientID %>");
            $("#<%=ddlcity.ClientID %> option").remove();
            serverCall('../Common/Services/CommonServices.asmx/bindCity',{ StateID: jQuery('#<%=ddlstate.ClientID%>').val()}, function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                       }
                       else {
                        ddlcity.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                    }
                    $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                })
        }      
        function bindphelbo() {
            jQuery('#<%=ddlphelbotomist.ClientID%> option').remove();
            $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
            var ddlphelbotomist;
            ddlphelbotomist = $("#<%=ddlphelbotomist.ClientID %>");
            $("#<%=ddlphelbotomist.ClientID %> option").remove();
            serverCall('PhelbomistHoliday.aspx/bindphelbo',
                { cityid:  jQuery('#<%=ddlcity.ClientID%>').val() },
                function (result) {
                    localityData = jQuery.parseJSON(result);
                    if (localityData.length == 0) {
                        jQuery('#<%=ddlphelbotomist.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                    }
                    else {                      
                        ddlphelbotomist.bindDropDown({ defaultValue: '--Select---', data: JSON.parse(result), valueField: 'PhlebotomistID', textField: 'name', isSearchAble: true });
                    }
                    $('#<%=ddlphelbotomist.ClientID%>').trigger('chosen:updated');
                })
            
        }
        function saveme() {
            var length = $('#<%=ddlphelbotomist.ClientID%> > option').length;
            if (length == 0) {
                toast("Error","Please Select Phlebotomist ");
                $('#<%=ddlphelbotomist.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlphelbotomist.ClientID%>').val() == "0") {
                toast("Error","Please Select Phlebotomist");
                $('#<%=ddlphelbotomist.ClientID%>').focus();
                return;
            }
            serverCall('PhelbomistHoliday.aspx/saveholiday',
                { phlebotomist: jQuery('#<%=ddlphelbotomist.ClientID%>').val() , fromdate:  $('#<%=txtfromdate.ClientID%>').val() , todate:  $('#<%=txttodate.ClientID%>').val() },
                function (result) {
                    if (result == "0") {
                        toast("Error", "You have appointment between from date and to date,Please adjust your appointment..!");
                    }
                    else if (result == "1") {
                        toast("Success", "Holiday sucessfully added");
                    }
                    else {
                    }
                })          
        }
        function CancelPhelboHoliday(HoliDayid)
        {
            serverCall('PhelbomistHoliday.aspx/CancelPhelboHoliday',
                { HoliDayid:  HoliDayid  },
                function (result) {

                    if (result == "1") {
                        toast("Error","Cancel successfully");
                        searchitem();
                    }
                    else {
                        toast("Error", "Error");
                    }
                })

        }
        function searchitem() {
            $('#tblitemlist tr').slice(1).remove();
            serverCall('PhelbomistHoliday.aspx/GetData',
                { fromDate:  $('#<%=txtfromdate_Serch.ClientID%>').val() , toDate:  $('#<%=txttodate_Serch.ClientID%>').val() , NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val() },
                function (result) {
                    ItemData = jQuery.parseJSON(result);
                    if (ItemData.length == 0) {
                        toast("Error","No Item Found");
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = [];
                            if (ItemData[i].IsActive == "1") {
                                mydata.push("<tr style='background-color:#99fb93;'>");
                            }
                            else {
                                mydata.push("<tr style='background-color:bisque;'>");
                            }

                            mydata.push('<td class="GridViewLabItemStyle"  id="" >'); mydata.push((i + 1));mydata.push('</td>');
                            if (ItemData[i].IsActive == "1") {
                                mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><a style="cursor:pointer" ><img src="../../App_Images/Reject.png" Title="Cencel" onclick="CancelPhelboHoliday('); mydata.push(ItemData[i].id);mydata.push(')"><a>  </td>');

                            }
                            else {
                                mydata.push( '<td class="GridViewLabItemStyle"  id="tddetail2" >  ---</td>');
                            }
                            mydata.push( '<td class="GridViewLabItemStyle"  id="tdPhelboName" >');mydata.push( ItemData[i].Name);mydata.push('</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="tdFromDate" >');mydata.push(ItemData[i].FromDate );mydata.push('</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="tdToDate" >');mydata.push(ItemData[i].ToDate);mydata.push('</td>');
                            mydata.push( '<td class="GridViewLabItemStyle" id="tdStatus">');mydata.push(ItemData[i].status );mydata.push('</td>');
                            mydata.push("</tr>");
                            mydata = mydata.join("");
                            $('#tblitemlist').append(mydata);
                        }
                    }
                })
        }
    </script>
</asp:Content>

