<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InHouseOutHouseReport.aspx.cs" Inherits="Design_Lab_InHouseOutHouseReport"  %>
<%@ Register Src="~/Design/UserControl/CentreLoadTypeWithoutPCCPUP.ascx" TagPrefix="uc1" TagName="CentreLoadTypeWithoutPCCPUP" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
        <%: Scripts.Render("~/bundles/Chosen") %>
      <%: Scripts.Render("~/bundles/PostReportScript") %>
 <%--Search--%>   
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
          $('.chosen-container').css('width', '230px');
      });
      

   </script>


        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
       
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
   <div id="body_box_inventory" style="width: 1285px; height: 200px;" >
    <div class="Outer_Box_Inventory" style="width: 1280px; " >
    <div class="content">
    <div style="text-align:center;">
    <b>InHouse Out House Report</b></div>
     <br />
     <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
   </div>
   </div>
   <div class="Outer_Box_Inventory" style="width: 1280px;height:155px;" >
    <div class="Purchaseheader">Search criteria</div>
                 <div>
                <uc1:CentreLoadTypeWithoutPCCPUP runat="server" ID="CentreLoadTypeWithoutPCCPUP" />
                 </div>
                  <div class="Outer_Box_Inventory" style="width: 1275px;border:none; "  > 
                    <table id="TBMain" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 28px;">
                       <tr>
                            <td align="right" style="width: 130px; text-align: right;font-weight:bold;">
                                Centre:&nbsp;</td>
                            <td align="left" style="width: 20px; text-align: left">
                                <asp:DropDownList ID="ddlCentre" class="ddlCentre chosen-select chosen-container" runat="server" ClientIDMode="Static" onchange="Search();">
                                </asp:DropDownList>
                            </td>
                            
                           <td></td><td></td>
                                                </tr>
                        <tr style="display:none;">
                           <td align="right" style="width: 130px; text-align: right;font-weight:bold;">
                                 Category:&nbsp;</td>
                            <td><asp:CheckBoxList ID="chkCategory" runat="server" RepeatDirection="Horizontal">                               
                                 <asp:ListItem Text="Tagged PUP" Value="PUP"></asp:ListItem>
                                </asp:CheckBoxList> </td>
                        </tr>
                            </table> 
             <div  style="text-align: center;width:1280px;">

            <input type="button" class="ItDoseButton" value="Report" onclick="getReport();" />
        </div>
           
        </div>
       
       
        
        </div>
        
      
        
        
      
   </div>
   
    
    
   <%--Saving--%> 
     <script type="text/javascript">
         $(function () {
             $('[id*=bindCentre]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             $("#spnDefaultLogo").mouseover(function () {
                 $("#spanLogo").show();
             });
             $("#spnDefaultLogo").mouseout(function () {
                 $("#spanLogo").hide();
             });
         });
         
         function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID, TypeID) {             
             $("#ddlCentre option").remove();
             $('#ddlCentre').trigger('chosen:updated');
             $('#IsNable').val('0');
             if (TypeID != "") {
                 jQuery.ajax({
                     url: "InHouseOutHouseReport.aspx/bindCentreLoadType",
                     data: '{ BusinessZoneID: "' + BusinessZoneID + '",StateID: "' + StateID + '",CityID: "' + CityID + '",TypeID:"' + TypeID + '"}',
                     type: "POST",
                     timeout: 120000,
                     async: false,
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (result) {
                         CentreLoadListData = jQuery.parseJSON(result.d);
                         if (CentreLoadListData.length > 0) {
                             for (i = 0; i < CentreLoadListData.length; i++) {
                                 $("#ddlCentre").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                             }
                         }
                         else {
                             $("#ddlCentre").append($("<option></option>").val("0").html("---No Data Found---"));

                         }
                         $('#ddlCentre').trigger('chosen:updated');
                         $('.chosen-container').css('width', '230px');
                     },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });
             }
         }
      
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
 </script>
     <script type="text/javascript">
         function getReport() {
             
             var CentreData = $("#ddlCentre option:selected").text() + '|' + $("#ddlCentre").val();
             if (CentreData == "|null") {
                 showerrormsg('Please Select Centre...........!');
                 return;
             }
             var PUP = '0';
             $('#<%=chkCategory.ClientID %> input[type=checkbox]').each(function () {
                 if ($(this).prop('checked')==true) {                     
                     if ($(this).val() == "PUP") {
                         PUP = '1';
                     }
                 }
             });             
             jQuery.ajax({
                 url: "InHouseOutHouseReport.aspx/getReport",
                 data: '{ CentreData: "' + CentreData + '",PUP: "' + PUP + '"}',
                 type: "POST",
                 timeout: 120000,
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {                     
                     var resultData = jQuery.parseJSON(result.d);
                     PostReport(resultData.Query, resultData.ReportName, resultData.Period, resultData.ReportPath);
                 },
                 error: function (xhr, status) {
                     showerrormsg("Error ");
                 }
             });
        }
         $('#lstZone,#lstState,#lstCity').on('change', function () {
             $("#ddlCentre option").remove();
             $('#ddlCentre').trigger('chosen:updated');
         });

    </script>

</asp:Content>

